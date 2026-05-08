
-- ── SEED ──────────────────────────────────────────────────────────────────────

INSERT INTO public.ref_attendance_status_enum (name) VALUES
  ('Interested'),('Confirmed'),('Paid'),('Own Booth'),
  ('Notify – Last Minute Discount'),('Verbal Commitment - Delete'),('GNF Sponsored'),
  ('Attending - No Booth'),('Not Participating'),('Waitlist'),
  ('Notify if Last Minute Availabile')
ON CONFLICT DO NOTHING;

INSERT INTO public.ref_departments (name) VALUES
  ('Sales'),('Demo Support'),('Data & Admin'),('Brand & Marketing'),('SOS Program (Inside Sales)')
ON CONFLICT DO NOTHING;

-- ── DROP dependency chain: fn → v_dashboard_summary → events_detailed_view ───

DROP FUNCTION IF EXISTS public.get_next_event();
DROP VIEW IF EXISTS public.v_dashboard_summary;
DROP VIEW IF EXISTS public.events_detailed_view;

-- ── TX6: jt_brand_events.attendance_status ───────────────────────────────────

ALTER TABLE public.jt_brand_events ADD COLUMN attendance_status__new uuid;

UPDATE public.jt_brand_events t
SET attendance_status__new = r.uuid
FROM public.ref_attendance_status_enum r
WHERE t.attendance_status::text = r.name;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.jt_brand_events WHERE attendance_status__new IS NULL AND attendance_status IS NOT NULL) THEN
    RAISE EXCEPTION 'Unmapped rows in jt_brand_events.attendance_status — aborting.';
  END IF;
END $$;

ALTER TABLE public.jt_brand_events DROP COLUMN attendance_status;
ALTER TABLE public.jt_brand_events RENAME COLUMN attendance_status__new TO attendance_status;

ALTER TABLE public.jt_brand_events
  ADD CONSTRAINT fk_jt_brand_events_attendance_status
    FOREIGN KEY (attendance_status) REFERENCES public.ref_attendance_status_enum(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_jt_brand_events_attendance_status ON public.jt_brand_events (attendance_status);

-- ── TX7: profiles.department ──────────────────────────────────────────────────

DROP VIEW IF EXISTS public.v_my_internal_profile;

ALTER TABLE public.profiles ADD COLUMN department__new uuid;

UPDATE public.profiles t
SET department__new = r.uuid
FROM public.ref_departments r
WHERE t.department::text = r.name;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.profiles WHERE department__new IS NULL AND department IS NOT NULL) THEN
    RAISE EXCEPTION 'Unmapped rows in profiles.department — aborting.';
  END IF;
END $$;

ALTER TABLE public.profiles DROP COLUMN department;
ALTER TABLE public.profiles RENAME COLUMN department__new TO department;

ALTER TABLE public.profiles
  ADD CONSTRAINT fk_profiles_department
    FOREIGN KEY (department) REFERENCES public.ref_departments(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_profiles_department ON public.profiles (department);

-- ── RECREATE events_detailed_view (attendance_status now uuid — passes through) 

CREATE OR REPLACE VIEW public.events_detailed_view AS
WITH brand_attendees AS (
  SELECT
    jbe.event_id,
    jsonb_agg(jsonb_build_object(
      'brand_id',                  b.id,
      'brand_name',                b.brand,
      'attendance_status',         jbe.attendance_status,
      'price_to_attend',           jbe.price_to_attend,
      'attendees_list',            jbe.attendees,
      'confirmed_brand_attendees', jbe.confirmed_brand_attendees,
      'brand_notes',               jbe.brand_notes
    )) AS attending_brands
  FROM public.jt_brand_events jbe
  JOIN public.brands b ON jbe.brand_id = b.id
  GROUP BY jbe.event_id
),
team_attendees AS (
  SELECT
    jte.event_id,
    jsonb_agg(jsonb_build_object(
      'team_member_id', tm.uuid,
      'name',           tm.name,
      'profile_pic',    tm.profile_photo,
      'role',           jte.role,
      'notes',          jte.notes
    )) AS attending_team
  FROM public.jt_team_members_x_events jte
  JOIN public.team_member_guide tm ON jte.team_member_id = tm.uuid
  GROUP BY jte.event_id
)
SELECT
  e.id, e.event_name, e.event_year, e.event_dates, e.event_tags,
  e.location, e.website, e.notes, e.event_forms, e.event_dispay_image,
  e.event_description, e.goodnow_participation, e.booth_number,
  e.accommodations, e.event_display_name, e.internal_event_planning_forms,
  e.start_date, e.end_date,
  ba.attending_brands,
  ta.attending_team
FROM public.events e
LEFT JOIN brand_attendees ba ON e.id = ba.event_id
LEFT JOIN team_attendees  ta ON e.id = ta.event_id;

-- ── RECREATE get_next_event (verbatim) ────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.get_next_event()
RETURNS SETOF public.events_detailed_view
LANGUAGE sql
AS $$
  SELECT * FROM public.events_detailed_view
  WHERE start_date >= CURRENT_DATE
  ORDER BY start_date ASC
  LIMIT 1;
$$;

-- ── RECREATE v_dashboard_summary (verbatim — already matches current state) ───

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

-- ── RECREATE v_my_internal_profile ────────────────────────────────────────────

CREATE OR REPLACE VIEW public.v_my_internal_profile AS
SELECT
  p.id, p.name, p.created_at, p.brand_id, p.department,
  p.user_type, p.profile_photo,
  tmg.status, tmg.title, tmg.address, tmg.phone_number,
  tmg.department AS public_department,
  tmg.send_samples, tmg.food_handlers_card,
  tmg.calls_counted_by_team_member, tmg.counter, tmg.email,
  tmg.key_support AS key_accounts, tmg.regional_coverage,
  tmg.time_zone, tmg.country_of_origin, tmg.language_spoken
FROM public.profiles p
LEFT JOIN public.team_member_guide tmg ON p.id = tmg.uuid
WHERE p.id = auth.uid();
;