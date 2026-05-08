
-- ── SEED ref_task_type_enum ───────────────────────────────────────────────────

INSERT INTO public.ref_task_type_enum (name) VALUES
  ('deal_activity'), ('category_review'), ('internal_task'), ('data'),
  ('marketing_design'), ('discussion_notes'), ('planned_submission'), ('HarvestHub')
ON CONFLICT DO NOTHING;

-- ── DROP in dependency order: function → view → view ─────────────────────────

DROP FUNCTION IF EXISTS public.fetch_tasks_for_deal(uuid);
DROP VIEW IF EXISTS public.v_dashboard_summary;
DROP VIEW IF EXISTS public.v_task_pipeline_with_assignees;

-- ── task_pipeline.task_type ───────────────────────────────────────────────────

ALTER TABLE public.task_pipeline ADD COLUMN task_type__new uuid;

UPDATE public.task_pipeline t
SET task_type__new = r.uuid
FROM public.ref_task_type_enum r
WHERE t.task_type::text = r.name;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.task_pipeline WHERE task_type__new IS NULL) THEN
    RAISE EXCEPTION 'Unmapped or NULL rows in task_pipeline.task_type — aborting.';
  END IF;
END $$;

ALTER TABLE public.task_pipeline DROP COLUMN task_type;
ALTER TABLE public.task_pipeline RENAME COLUMN task_type__new TO task_type;
ALTER TABLE public.task_pipeline ALTER COLUMN task_type SET NOT NULL;

ALTER TABLE public.task_pipeline
  ADD CONSTRAINT fk_task_pipeline_task_type
    FOREIGN KEY (task_type) REFERENCES public.ref_task_type_enum(uuid)
    ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_task_pipeline_task_type ON public.task_pipeline (task_type);

-- ── RECREATE v_task_pipeline_with_assignees ───────────────────────────────────

CREATE OR REPLACE VIEW public.v_task_pipeline_with_assignees AS
SELECT
  t.id AS task_id,
  t.task_title,
  t.notes,
  t.task_type,
  t.status,
  t.due_date,
  t.priority,
  t.is_completed,
  t.completed_at,
  t.created_at,
  t.updated_at,
  ( SELECT jsonb_agg(jsonb_build_object('deal_id', at_inner.id, 'activity_name', at_inner.activity_name))
    FROM public.jt_deal_task_pipeline jdtp
    JOIN public.activity_tracker at_inner ON jdtp.deal_id = at_inner.id
    WHERE jdtp.task_id = t.id ) AS linked_deals,
  t.brand_id,
  t.account_id,
  t.category_review_id,
  t.created_by AS creator_team_member_uuid,
  t.is_automated,
  t.source_type,
  jsonb_agg(
    jsonb_build_object(
      'assignment_id',    ta.uuid,
      'assigned_at',      ta.assigned_at,
      'team_member_uuid', tm.uuid,
      'user_id',          tm.user_id,
      'name',             tm.name,
      'email',            tm.email,
      'profile_photo',    tm.profile_photo
    )
  ) FILTER (WHERE tm.uuid IS NOT NULL) AS assignees,
  ( SELECT jsonb_agg(jsonb_build_object(
      'junction_id', jta.id, 'document_id', d.id, 'name', d.name,
      'size', d.size, 'type', d.type, 'status', d.status, 'path', d.storage_path
    ))
    FROM public.jt_task_pipeline_attachments jta
    JOIN public.brand_documents d ON jta.document_id = d.id
    WHERE jta.task_id = t.id ) AS attachment_info
FROM public.task_pipeline t
LEFT JOIN public.jt_task_assignments ta ON t.id = ta.task_id
LEFT JOIN public.team_member_guide tm   ON ta.team_member_uuid = tm.uuid
GROUP BY t.id
ORDER BY t.due_date DESC NULLS LAST;

-- ── RECREATE v_dashboard_summary (verbatim) ───────────────────────────────────

CREATE OR REPLACE VIEW public.v_dashboard_summary AS
SELECT
  ( SELECT jsonb_build_object(
      'pipeline_items',      (SELECT count(*) FROM public.v_task_pipeline_with_assignees WHERE is_completed = false),
      'planned_submissions',  (SELECT count(*) FROM public.planned_submissions),
      'sync_calls',           (SELECT count(*) FROM public.brand_sync_call_schedule WHERE sync_date = CURRENT_DATE)
    )
  ) AS counts,
  ( SELECT jsonb_build_object(
      'review_name',  v.review_name,
      'deadline',     v.new_item_submission_deadline,
      'managers',     v.category_managers,
      'brands',       v.linked_brands_array,
      'count',        v.linked_brands_count
    )
    FROM public.v_brand_matching v
    WHERE v.new_item_submission_deadline IS NOT NULL AND v.new_item_submission_deadline >= CURRENT_DATE
    ORDER BY v.new_item_submission_deadline LIMIT 1
  ) AS next_review,
  ( SELECT row_to_json(e.*)
    FROM (
      SELECT id, event_name, event_year, event_dates, event_tags, location, website, notes,
             event_forms, event_dispay_image, event_description, goodnow_participation,
             booth_number, accommodations, event_display_name, internal_event_planning_forms,
             start_date, end_date, attending_brands, attending_team
      FROM public.events_detailed_view
      WHERE start_date >= CURRENT_DATE ORDER BY start_date LIMIT 1
    ) e
  ) AS next_event,
  ( SELECT row_to_json(a.*)
    FROM (
      SELECT id, created_at, announcement, image, audience, archive, announcement_tags,
             announcement_date, announcement_title, publish
      FROM public.company_announcements
      WHERE announcement_date >= CURRENT_DATE AND publish IS TRUE AND archive IS NOT TRUE
      ORDER BY announcement_date LIMIT 1
    ) a
  ) AS next_announcement,
  ( SELECT jsonb_build_object(
      'submission_id',   ps.id,
      'planned_date',    ps.planned_submission_date,
      'submission_status', ps.submission_status,
      'review_name',     mcrd.display_name,
      'brand_name',      b.brand,
      'brand_logo',      b.brand_logo,
      'deal_name',       at.activity_name
    )
    FROM public.planned_submissions ps
    LEFT JOIN public.master_category_review_data mcrd ON ps.category_review = mcrd.id
    LEFT JOIN public.activity_tracker at ON ps.deal_id = at.id
    LEFT JOIN public.brands b ON at.brand = b.id
    WHERE ps.planned_submission_date >= CURRENT_DATE
      AND (ps.submission_status IS FALSE OR ps.submission_status IS NULL)
    ORDER BY ps.planned_submission_date LIMIT 1
  ) AS next_planned_submission;

-- ── RECREATE fetch_tasks_for_deal (verbatim — body unchanged) ─────────────────

CREATE OR REPLACE FUNCTION public.fetch_tasks_for_deal(p_deal_id uuid)
RETURNS SETOF public.v_task_pipeline_with_assignees
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT *
  FROM public.v_task_pipeline_with_assignees
  WHERE linked_deals @> jsonb_build_array(jsonb_build_object('deal_id', p_deal_id));
$$;

-- ── REWRITE create_task_on_deal_stage_change ──────────────────────────────────

CREATE OR REPLACE FUNCTION public.create_task_on_deal_stage_change()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  new_task_id UUID;
  deal_owner_exists BOOLEAN;
  v_task_type_deal_activity UUID;
BEGIN
  SELECT uuid INTO v_task_type_deal_activity
  FROM public.ref_task_type_enum WHERE name = 'deal_activity' LIMIT 1;

  SELECT EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) INTO deal_owner_exists;
  RAISE NOTICE '--- DEBUG TRIGGER ---';
  RAISE NOTICE 'TG_OP: %', TG_OP;
  RAISE NOTICE 'Activity ID: %', NEW.id;
  RAISE NOTICE '1. Activity Type: %', NEW.activity_type;
  RAISE NOTICE '2. Deal Owner Exists?: %', deal_owner_exists;
  RAISE NOTICE '3. Assign for Follow Up: %', NEW.assign_for_follow_up;
  RAISE NOTICE '---------------------';

  IF TG_OP = 'UPDATE' AND NEW.assign_for_follow_up <> OLD.assign_for_follow_up THEN
    IF NEW.activity_type IN ('SOS Program', 'SOS Only Program') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) AND
       NEW.assign_for_follow_up IS NOT NULL
    THEN
      UPDATE public.task_pipeline
      SET status = 'sos_follow_up'::public.kanban_status_enum, updated_at = now()
      WHERE activity_tracker_id = NEW.id;

      INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
      SELECT id, NEW.assign_for_follow_up FROM public.task_pipeline
      WHERE activity_tracker_id = NEW.id
      ON CONFLICT (task_id, team_member_uuid) DO NOTHING;

      IF NOT FOUND THEN
        INSERT INTO public.task_pipeline
          (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
        VALUES (NEW.activity_name, v_task_type_deal_activity, 'sos_follow_up'::public.kanban_status_enum,
                NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto')
        RETURNING id INTO new_task_id;

        INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
        VALUES (new_task_id, NEW.assign_for_follow_up);
      END IF;
    ELSE
      UPDATE public.task_pipeline
      SET status = CASE
            WHEN NEW.deal_stage IN ('Presenting', 'Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
            WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction','Presenting - Buyer Engagement / Meeting','Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
            WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
            ELSE status
          END,
          updated_at = now()
      WHERE activity_tracker_id = NEW.id;

      IF NOT FOUND AND NEW.deal_stage IN (
        'Presenting','Approved: in Setup','Presenting - Buyer Introduction',
        'Presenting - Buyer Engagement / Meeting','Presenting - Post Review Follow-Up','Target'
      ) AND EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) THEN
        INSERT INTO public.task_pipeline
          (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
        VALUES (
          NEW.activity_name, v_task_type_deal_activity,
          CASE
            WHEN NEW.deal_stage IN ('Presenting','Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
            WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction','Presenting - Buyer Engagement / Meeting','Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
            WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
          END,
          NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto'
        );
      END IF;
    END IF;

  ELSIF TG_OP = 'INSERT' THEN
    IF NEW.activity_type IN ('SOS Program', 'SOS Only Program') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) AND
       NEW.assign_for_follow_up IS NOT NULL
    THEN
      INSERT INTO public.task_pipeline
        (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
      VALUES (NEW.activity_name, v_task_type_deal_activity, 'sos_follow_up'::public.kanban_status_enum,
              NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto')
      RETURNING id INTO new_task_id;

      INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
      VALUES (new_task_id, NEW.assign_for_follow_up);
    END IF;

    IF NEW.deal_stage IN (
      'Presenting','Approved: in Setup','Presenting - Buyer Introduction',
      'Presenting - Buyer Engagement / Meeting','Presenting - Post Review Follow-Up','Target'
    ) AND EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) THEN
      INSERT INTO public.task_pipeline
        (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
      VALUES (
        NEW.activity_name, v_task_type_deal_activity,
        CASE
          WHEN NEW.deal_stage IN ('Presenting','Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
          WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction','Presenting - Buyer Engagement / Meeting','Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
          WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
        END,
        NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto'
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

-- ── REWRITE create_tasks_from_activity_tracker ────────────────────────────────

CREATE OR REPLACE FUNCTION public.create_tasks_from_activity_tracker()
RETURNS integer LANGUAGE plpgsql AS $$
DECLARE
  rec RECORD; task_count INTEGER := 0;
  v_status kanban_status_enum; v_source_type source_type_enum;
  v_task_title TEXT; v_task_type_deal_activity UUID;
BEGIN
  SELECT uuid INTO v_task_type_deal_activity FROM public.ref_task_type_enum WHERE name = 'deal_activity' LIMIT 1;

  FOR rec IN
    SELECT at.*, a.account AS account_name, b.brand AS brand_name
    FROM public.activity_tracker at
    LEFT JOIN public.accounts a ON at.account = a.uuid
    LEFT JOIN public.brands   b ON at.brand   = b.id
    WHERE at.send_to_task_tracker = true
      AND NOT EXISTS (SELECT 1 FROM public.task_pipeline tp WHERE tp.activity_tracker_id = at.id)
  LOOP
    v_status := determine_task_status(rec.id);
    v_source_type := CASE WHEN rec.activity_type::text IN ('SOS Program','SOS Only Program')
      THEN 'sos_deal_script'::source_type_enum ELSE 'gnf_deal_script'::source_type_enum END;
    v_task_title := COALESCE(
      rec.account_name || ' - ' || rec.brand_name,
      rec.account_name || ' Deal Activity',
      rec.brand_name   || ' Deal Activity',
      'Deal Activity'
    );
    INSERT INTO public.task_pipeline
      (task_title, notes, task_type, status, activity_tracker_id, brand_id, account_id, assigned_to, is_automated, source_type)
    VALUES (v_task_title, rec.activity_notes, v_task_type_deal_activity, v_status,
            rec.id, rec.brand, rec.account, rec.assign_for_follow_up, true, v_source_type);
    task_count := task_count + 1;
  END LOOP;
  RETURN task_count;
END;
$$;

-- ── REWRITE create_tasks_from_category_reviews ────────────────────────────────

CREATE OR REPLACE FUNCTION public.create_tasks_from_category_reviews()
RETURNS integer LANGUAGE plpgsql AS $$
DECLARE
  rec RECORD; brand_rec RECORD; task_count INTEGER := 0;
  v_status kanban_status_enum; v_task_title TEXT;
  v_task_type_category_review UUID;
BEGIN
  SELECT uuid INTO v_task_type_category_review FROM public.ref_task_type_enum WHERE name = 'category_review' LIMIT 1;

  FOR rec IN
    SELECT cr.*, a.account AS account_name
    FROM public.master_category_review_data cr
    JOIN public.accounts a ON cr.account = a.uuid
    WHERE cr.new_item_submission_deadline IS NOT NULL
      AND cr.new_item_submission_deadline >= CURRENT_DATE
      AND cr.new_item_submission_deadline <= CURRENT_DATE + INTERVAL '60 days'
      AND NOT EXISTS (SELECT 1 FROM public.task_pipeline tp WHERE tp.category_review_id = cr.id)
  LOOP
    FOR brand_rec IN
      SELECT DISTINCT b.*
      FROM public.jt_master_category_review_data_brands jt
      JOIN public.brands b ON jt.brand_id = b.id
      WHERE jt.master_category_review_data_id = rec.id
    LOOP
      v_status := determine_task_status(NULL, rec.new_item_submission_deadline);
      v_task_title := rec.account_name || ' - ' || brand_rec.brand || ' Category Review';
      INSERT INTO public.task_pipeline
        (task_title, notes, task_type, status, category_review_id, brand_id, account_id, due_date, is_automated, source_type)
      VALUES (v_task_title, 'Category review deadline: ' || rec.new_item_submission_deadline::text,
              v_task_type_category_review, v_status,
              rec.id, brand_rec.id, rec.account, rec.new_item_submission_deadline, true, 'category_review_auto');
      task_count := task_count + 1;
    END LOOP;
  END LOOP;
  RETURN task_count;
END;
$$;

-- ── REWRITE import_airtable_task_tracker ──────────────────────────────────────

CREATE OR REPLACE FUNCTION public.import_airtable_task_tracker()
RETURNS TABLE(imported_count integer, assigned_user_mappings text, brand_mappings text, errors text)
LANGUAGE plpgsql AS $$
DECLARE
  import_count INTEGER := 0;
  user_mappings TEXT := ''; brand_mappings TEXT := ''; error_log TEXT := '';
BEGIN
  CREATE TEMP TABLE IF NOT EXISTS temp_airtable_tasks (
    task TEXT, sales_team_email TEXT, sales_team TEXT, notes TEXT,
    task_type TEXT, status TEXT, due_date TEXT, priority TEXT,
    task_completed TEXT, attachments TEXT, created TEXT
  );

  INSERT INTO public.task_pipeline
    (task_title, notes, task_type, status, assigned_to, brand_id, due_date, priority, is_completed, attachments, source_type)
  SELECT
    t.task, t.notes, rtt.uuid,
    CASE t.status
      WHEN 'This Week / Overdue' THEN 'this_week_overdue'::kanban_status_enum
      WHEN 'Next Two Weeks'      THEN 'next_two_weeks'::kanban_status_enum
      WHEN 'This Month'          THEN 'this_month'::kanban_status_enum
      WHEN 'To Watch'            THEN 'to_watch'::kanban_status_enum
      WHEN 'SOS Follow Up'       THEN 'sos_follow_up'::kanban_status_enum
      ELSE                            'this_month'::kanban_status_enum
    END,
    tmg.uuid, b.id,
    CASE WHEN t.due_date IS NOT NULL AND t.due_date != '' THEN to_date(t.due_date,'MM/DD/YYYY') ELSE NULL END,
    CASE t.priority
      WHEN 'High' THEN 'high'::priority_enum WHEN 'Medium' THEN 'medium'::priority_enum
      WHEN 'Low'  THEN 'low'::priority_enum  ELSE 'medium'::priority_enum
    END,
    COALESCE(t.task_completed = 'Completed', false),
    CASE WHEN t.attachments IS NOT NULL AND t.attachments != ''
         THEN jsonb_build_array(jsonb_build_object('filename',split_part(t.attachments,' ',1),'url',regexp_replace(t.attachments,'.*\((.*)\).*','\1')))
         ELSE '[]'::jsonb END,
    'manual'::source_type_enum
  FROM temp_airtable_tasks t
  LEFT JOIN public.ref_task_type_enum rtt ON rtt.name = CASE t.task_type
    WHEN 'Deal Activity' THEN 'deal_activity' WHEN 'Category Review' THEN 'category_review'
    WHEN 'Internal Task' THEN 'internal_task' WHEN 'Data' THEN 'data'
    WHEN 'Marketing / Design' THEN 'marketing_design' ELSE 'internal_task' END
  LEFT JOIN public.team_member_guide tmg ON (tmg.name = t.sales_team OR tmg.email = t.sales_team_email)
  LEFT JOIN public.brands b ON b.brand = t.task;

  GET DIAGNOSTICS import_count = ROW_COUNT;
  SELECT string_agg(DISTINCT t.sales_team||' ('||t.sales_team_email||') -> '||COALESCE(tmg.name,'NOT FOUND'), E'\n')
  INTO user_mappings FROM temp_airtable_tasks t
  LEFT JOIN public.team_member_guide tmg ON (tmg.name = t.sales_team OR tmg.email = t.sales_team_email);
  DROP TABLE IF EXISTS temp_airtable_tasks;
  RETURN QUERY SELECT import_count, user_mappings, brand_mappings, error_log;
END;
$$;

-- ── REWRITE import_airtable_tasks ─────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.import_airtable_tasks(p_task_data jsonb)
RETURNS integer LANGUAGE plpgsql AS $$
DECLARE
  task_record JSONB; task_count INTEGER := 0;
  v_assigned_to UUID; v_brand_id UUID;
  v_status kanban_status_enum; v_task_type UUID; v_priority priority_enum;
  v_task_type_name TEXT;
BEGIN
  FOR task_record IN SELECT * FROM jsonb_array_elements(p_task_data)
  LOOP
    SELECT uuid INTO v_assigned_to FROM public.team_member_guide
    WHERE name = task_record->>'sales_team_name' OR email = task_record->>'sales_team_email' LIMIT 1;

    SELECT id INTO v_brand_id FROM public.brands WHERE brand = task_record->>'brand_name' LIMIT 1;

    v_status := CASE task_record->>'status'
      WHEN 'This Week / Overdue' THEN 'this_week_overdue' WHEN 'Next Two Weeks' THEN 'next_two_weeks'
      WHEN 'This Month' THEN 'this_month' WHEN 'To Watch' THEN 'to_watch'
      WHEN 'SOS Follow Up' THEN 'sos_follow_up' ELSE 'this_month' END;

    v_task_type_name := CASE task_record->>'task_type'
      WHEN 'Deal Activity' THEN 'deal_activity' WHEN 'Category Review' THEN 'category_review'
      WHEN 'Internal Task' THEN 'internal_task' WHEN 'Data' THEN 'data'
      WHEN 'Marketing / Design' THEN 'marketing_design' ELSE 'internal_task' END;

    SELECT uuid INTO v_task_type FROM public.ref_task_type_enum WHERE name = v_task_type_name LIMIT 1;

    v_priority := CASE task_record->>'priority'
      WHEN 'High' THEN 'high' WHEN 'Medium' THEN 'medium' WHEN 'Low' THEN 'low' ELSE 'medium' END;

    INSERT INTO public.task_pipeline
      (task_title, notes, task_type, status, assigned_to, brand_id, due_date, priority, is_completed, source_type)
    VALUES (
      task_record->>'task', task_record->>'notes', v_task_type, v_status,
      v_assigned_to, v_brand_id, (task_record->>'due_date')::DATE, v_priority,
      COALESCE((task_record->>'task_completed')::BOOLEAN, false), 'manual'
    );
    task_count := task_count + 1;
  END LOOP;
  RETURN task_count;
END;
$$;
;