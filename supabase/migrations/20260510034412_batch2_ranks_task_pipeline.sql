
BEGIN;

-- Drop dependents in full order
DROP FUNCTION IF EXISTS public.fetch_tasks_for_deal(uuid);
DROP VIEW IF EXISTS public.v_dashboard_summary;
DROP VIEW IF EXISTS public.v_task_pipeline_with_assignees;
DROP FUNCTION IF EXISTS public.determine_task_status(uuid, date);

-- Recreate determine_task_status() returning uuid
CREATE FUNCTION public.determine_task_status(
  p_activity_tracker_id uuid,
  p_due_date date
) RETURNS uuid
LANGUAGE plpgsql AS $$
DECLARE
  v_deal_stage    TEXT;
  v_activity_type TEXT;
  v_result_name   TEXT;
BEGIN
  IF p_activity_tracker_id IS NOT NULL THEN
    SELECT deal_stage::text, activity_type::text
    INTO v_deal_stage, v_activity_type
    FROM activity_tracker
    WHERE id = p_activity_tracker_id;

    IF v_activity_type IN ('SOS Program', 'SOS Only Program') THEN
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
$$;

-- Rank 7: task_pipeline.status
ALTER TABLE public.task_pipeline ADD COLUMN status__new uuid;

UPDATE public.task_pipeline t
SET status__new = r.uuid
FROM public.ref_kanban_status_enum r
WHERE r.name = t.status::text;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.task_pipeline
    WHERE status IS NOT NULL AND status__new IS NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped status values in task_pipeline — aborting.';
  END IF;
END $$;

ALTER TABLE public.task_pipeline DROP COLUMN status;
ALTER TABLE public.task_pipeline RENAME COLUMN status__new TO status;

ALTER TABLE public.task_pipeline
  ADD CONSTRAINT fk_task_pipeline_status
  FOREIGN KEY (status) REFERENCES public.ref_kanban_status_enum(uuid);

CREATE INDEX idx_task_pipeline_status ON public.task_pipeline(status);

-- Rank 8: task_pipeline.source_type
ALTER TABLE public.task_pipeline ADD COLUMN source_type__new uuid;

UPDATE public.task_pipeline t
SET source_type__new = r.uuid
FROM public.ref_source_type_enum r
WHERE r.name = t.source_type::text;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.task_pipeline
    WHERE source_type IS NOT NULL AND source_type__new IS NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped source_type values in task_pipeline — aborting.';
  END IF;
END $$;

ALTER TABLE public.task_pipeline DROP COLUMN source_type;
ALTER TABLE public.task_pipeline RENAME COLUMN source_type__new TO source_type;

ALTER TABLE public.task_pipeline
  ADD CONSTRAINT fk_task_pipeline_source_type
  FOREIGN KEY (source_type) REFERENCES public.ref_source_type_enum(uuid);

CREATE INDEX idx_task_pipeline_source_type ON public.task_pipeline(source_type);

-- Hard-coded UUID for 'manual' in ref_source_type_enum
ALTER TABLE public.task_pipeline
  ALTER COLUMN source_type SET DEFAULT 'c172e7e1-17b6-4e83-bc88-41a981e969a9'::uuid;

-- Rank 9: task_pipeline.priority
ALTER TABLE public.task_pipeline ADD COLUMN priority__new uuid;

UPDATE public.task_pipeline t
SET priority__new = r.uuid
FROM public.ref_priority_enum r
WHERE r.name = t.priority::text;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.task_pipeline
    WHERE priority IS NOT NULL AND priority__new IS NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped priority values in task_pipeline — aborting.';
  END IF;
END $$;

ALTER TABLE public.task_pipeline DROP COLUMN priority;
ALTER TABLE public.task_pipeline RENAME COLUMN priority__new TO priority;

ALTER TABLE public.task_pipeline
  ADD CONSTRAINT fk_task_pipeline_priority
  FOREIGN KEY (priority) REFERENCES public.ref_priority_enum(uuid);

CREATE INDEX idx_task_pipeline_priority ON public.task_pipeline(priority);

-- Hard-coded UUID for 'Medium' in ref_priority_enum
ALTER TABLE public.task_pipeline
  ALTER COLUMN priority SET DEFAULT 'f1476545-35ef-4441-a83e-9dac4ff0208d'::uuid;

-- Recreate v_task_pipeline_with_assignees
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
  ( SELECT jsonb_agg(jsonb_build_object(
        'deal_id', at_inner.id,
        'activity_name', at_inner.activity_name
      ))
    FROM jt_deal_task_pipeline jdtp
    JOIN activity_tracker at_inner ON jdtp.deal_id = at_inner.id
    WHERE jdtp.task_id = t.id
  ) AS linked_deals,
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
        'junction_id', jta.id,
        'document_id', d.id,
        'name',        d.name,
        'size',        d.size,
        'type',        d.type,
        'status',      d.status,
        'path',        d.storage_path
      ))
    FROM jt_task_pipeline_attachments jta
    JOIN brand_documents d ON jta.document_id = d.id
    WHERE jta.task_id = t.id
  ) AS attachment_info
FROM task_pipeline t
LEFT JOIN jt_task_assignments ta ON t.id = ta.task_id
LEFT JOIN team_member_guide tm ON ta.team_member_uuid = tm.uuid
GROUP BY t.id
ORDER BY t.due_date DESC NULLS LAST;

-- Recreate v_dashboard_summary verbatim
CREATE OR REPLACE VIEW public.v_dashboard_summary AS
SELECT
  ( SELECT jsonb_build_object(
      'pipeline_items',      (SELECT count(*) FROM v_task_pipeline_with_assignees WHERE is_completed = false),
      'planned_submissions', (SELECT count(*) FROM planned_submissions),
      'sync_calls',          (SELECT count(*) FROM brand_sync_call_schedule WHERE sync_date = CURRENT_DATE)
    )
  ) AS counts,
  ( SELECT jsonb_build_object(
      'review_name', v.review_name,
      'deadline',    v.new_item_submission_deadline,
      'managers',    v.category_managers,
      'brands',      v.linked_brands_array,
      'count',       v.linked_brands_count
    )
    FROM v_brand_matching v
    WHERE v.new_item_submission_deadline IS NOT NULL
      AND v.new_item_submission_deadline >= CURRENT_DATE
    ORDER BY v.new_item_submission_deadline
    LIMIT 1
  ) AS next_review,
  ( SELECT row_to_json(e.*)
    FROM (
      SELECT id, event_name, event_year, event_dates, event_tags, location, website,
             notes, event_forms, event_dispay_image, event_description, goodnow_participation,
             booth_number, accommodations, event_display_name, internal_event_planning_forms,
             start_date, end_date, attending_brands, attending_team
      FROM events_detailed_view
      WHERE start_date >= CURRENT_DATE
      ORDER BY start_date
      LIMIT 1
    ) e
  ) AS next_event,
  ( SELECT row_to_json(a.*)
    FROM (
      SELECT id, created_at, announcement, image, audience, archive,
             announcement_tags, announcement_date, announcement_title, publish
      FROM company_announcements
      WHERE announcement_date >= CURRENT_DATE
        AND publish IS TRUE
        AND archive IS NOT TRUE
      ORDER BY announcement_date
      LIMIT 1
    ) a
  ) AS next_announcement,
  ( SELECT jsonb_build_object(
      'submission_id',     ps.id,
      'planned_date',      ps.planned_submission_date,
      'submission_status', ps.submission_status,
      'review_name',       mcrd.display_name,
      'brand_name',        b.brand,
      'brand_logo',        b.brand_logo,
      'deal_name',         at.activity_name
    )
    FROM planned_submissions ps
    LEFT JOIN master_category_review_data mcrd ON ps.category_review = mcrd.id
    LEFT JOIN activity_tracker at ON ps.deal_id = at.id
    LEFT JOIN brands b ON at.brand = b.id
    WHERE ps.planned_submission_date >= CURRENT_DATE
      AND (ps.submission_status IS FALSE OR ps.submission_status IS NULL)
    ORDER BY ps.planned_submission_date
    LIMIT 1
  ) AS next_planned_submission;

-- Recreate fetch_tasks_for_deal bound to the updated view
CREATE FUNCTION public.fetch_tasks_for_deal(p_deal_id uuid)
RETURNS SETOF public.v_task_pipeline_with_assignees
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT *
  FROM public.v_task_pipeline_with_assignees
  WHERE linked_deals @> jsonb_build_array(jsonb_build_object('deal_id', p_deal_id));
$$;

COMMIT;
;