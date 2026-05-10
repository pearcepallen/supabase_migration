set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_task_on_deal_stage_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.create_tasks_from_activity_tracker()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.create_tasks_from_category_reviews()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.determine_task_status(p_activity_tracker_id uuid, p_due_date date)
 RETURNS uuid
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_deal_stage         TEXT;
  v_activity_type_uuid uuid;
  v_activity_type_name TEXT;
  v_result_name        TEXT;
BEGIN
  IF p_activity_tracker_id IS NOT NULL THEN
    SELECT deal_stage::text, activity_type
    INTO v_deal_stage, v_activity_type_uuid
    FROM activity_tracker
    WHERE id = p_activity_tracker_id;

    SELECT name INTO v_activity_type_name
    FROM public.ref_activity_type_enum
    WHERE uuid = v_activity_type_uuid;

    IF v_activity_type_name IN ('SOS Program', 'SOS Only Program') THEN
      v_result_name := 'sos_follow_up';
    ELSE
      CASE v_deal_stage
        WHEN 'Presenting', 'Approved: in Setup' THEN
          v_result_name := 'this_month';
        WHEN 'Target' THEN
          v_result_name := 'to_watch';
        WHEN 'Presenting - Buyer Introduction',
             'Presenting - Buyer Engagement / Meeting',
             'Presenting - Post Review Follow-Up' THEN
          v_result_name := 'next_two_weeks';
        ELSE
          v_result_name := 'this_month';
      END CASE;
    END IF;

    RETURN (SELECT uuid FROM public.ref_kanban_status_enum WHERE name = v_result_name);
  END IF;

  IF p_due_date IS NOT NULL THEN
    IF p_due_date < CURRENT_DATE OR
       (p_due_date >= CURRENT_DATE AND p_due_date <= CURRENT_DATE + INTERVAL '7 days') THEN
      v_result_name := 'this_week_overdue';
    ELSIF p_due_date <= CURRENT_DATE + INTERVAL '14 days' THEN
      v_result_name := 'next_two_weeks';
    ELSIF p_due_date <= CURRENT_DATE + INTERVAL '30 days' THEN
      v_result_name := 'this_month';
    ELSE
      v_result_name := 'to_watch';
    END IF;
    RETURN (SELECT uuid FROM public.ref_kanban_status_enum WHERE name = v_result_name);
  END IF;

  RETURN (SELECT uuid FROM public.ref_kanban_status_enum WHERE name = 'to_watch');
END;
$function$
;

CREATE OR REPLACE FUNCTION public.fetch_tasks_for_deal(p_deal_id uuid)
 RETURNS SETOF public.v_task_pipeline_with_assignees
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  SELECT *
  FROM public.v_task_pipeline_with_assignees
  WHERE linked_deals @> jsonb_build_array(jsonb_build_object('deal_id', p_deal_id));
$function$
;

CREATE OR REPLACE FUNCTION public.get_harvesthub_customers()
 RETURNS SETOF public.v_harvesthub_customer_datagrid
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
  SELECT * FROM public.v_harvesthub_customer_datagrid;
$function$
;

CREATE OR REPLACE FUNCTION public.get_next_event()
 RETURNS SETOF public.events_detailed_view
 LANGUAGE sql
AS $function$
  SELECT * FROM public.events_detailed_view
  WHERE start_date >= CURRENT_DATE
  ORDER BY start_date ASC
  LIMIT 1;
$function$
;

CREATE OR REPLACE FUNCTION public.import_airtable_task_tracker()
 RETURNS TABLE(imported_count integer, assigned_user_mappings text, brand_mappings text, errors text)
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.import_airtable_tasks(p_task_data jsonb)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.ref_migration_tracker_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$function$
;


