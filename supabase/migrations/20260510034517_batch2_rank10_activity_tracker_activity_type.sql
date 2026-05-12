
BEGIN;

ALTER TABLE public.activity_tracker ADD COLUMN activity_type__new uuid;

UPDATE public.activity_tracker at
SET activity_type__new = r.uuid
FROM public.ref_activity_type_enum r
WHERE r.name = at.activity_type::text;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.activity_tracker
    WHERE activity_type IS NOT NULL AND activity_type__new IS NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped activity_type values in activity_tracker — aborting.';
  END IF;
END $$;

ALTER TABLE public.activity_tracker DROP COLUMN activity_type;
ALTER TABLE public.activity_tracker RENAME COLUMN activity_type__new TO activity_type;

ALTER TABLE public.activity_tracker
  ADD CONSTRAINT fk_activity_tracker_activity_type
  FOREIGN KEY (activity_type) REFERENCES public.ref_activity_type_enum(uuid);

CREATE INDEX idx_activity_tracker_activity_type ON public.activity_tracker(activity_type);

-- Hard-coded UUID for 'GNF Deal'
ALTER TABLE public.activity_tracker
  ALTER COLUMN activity_type SET DEFAULT 'a437fa27-63fa-4f98-97ab-54724ea0a576'::uuid;

-- Phase 2 rewrite of determine_task_status(): activity_type is now uuid,
-- resolve name via ref_activity_type_enum join instead of casting to text
DROP FUNCTION IF EXISTS public.determine_task_status(uuid, date);

CREATE FUNCTION public.determine_task_status(
  p_activity_tracker_id uuid,
  p_due_date date
) RETURNS uuid
LANGUAGE plpgsql AS $$
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
$$;

COMMIT;
;