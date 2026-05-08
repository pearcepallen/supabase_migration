
-- Seed already applied above; ON CONFLICT is safe
INSERT INTO public.ref_demo_status_enum (name) VALUES
  ('Requested'),('Store Confirmed'),('Inventory Confirmed'),('Completed'),
  ('Cancelled'),('Rescheduled'),('Invoiced'),('Paid Contract'),('Paid Gnf'),
  ('Paid - GNF Sponsored'),('Confirmed'),('Demo Cancelled')
ON CONFLICT DO NOTHING;

-- ── DROP all 5 dependent views ────────────────────────────────────────────────

DROP VIEW IF EXISTS public.demo_dashboard_metrics;
DROP VIEW IF EXISTS public.v_completed_demos;
DROP VIEW IF EXISTS public.v_scheduled_demos;
DROP VIEW IF EXISTS public.v_demo_calendar;
DROP VIEW IF EXISTS public.v_demo_check_ins;

-- ── demos.demo_status ─────────────────────────────────────────────────────────

ALTER TABLE public.demos ALTER COLUMN demo_status DROP DEFAULT;
ALTER TABLE public.demos ADD COLUMN demo_status__new uuid;

UPDATE public.demos t
SET demo_status__new = r.uuid
FROM public.ref_demo_status_enum r
WHERE t.demo_status::text = r.name;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.demos WHERE demo_status__new IS NULL AND demo_status IS NOT NULL) THEN
    RAISE EXCEPTION 'Unmapped rows in demos.demo_status — aborting.';
  END IF;
END $$;

ALTER TABLE public.demos DROP COLUMN demo_status;
ALTER TABLE public.demos RENAME COLUMN demo_status__new TO demo_status;

ALTER TABLE public.demos
  ALTER COLUMN demo_status SET DEFAULT '1a048369-3173-4da3-9938-2b9b62819b12'::uuid;

ALTER TABLE public.demos
  ADD CONSTRAINT fk_demos_demo_status
    FOREIGN KEY (demo_status) REFERENCES public.ref_demo_status_enum(uuid)
    ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_demos_demo_status ON public.demos (demo_status);

-- ── RECREATE v_completed_demos ────────────────────────────────────────────────
-- CASE comparisons rewritten: ANY(ARRAY[...::demo_status_enum]) → uuid IN (subquery)

CREATE OR REPLACE VIEW public.v_completed_demos AS
SELECT
  d.id, d.demo_date, d.date_submitted, d.demo_status, d.start_time, d.end_time, d.time_range,
  d.account_id, d.team_member_id, d.store_poc, d.demo_fee, d.date_billed, d.other_fees,
  d.billing_notes, d.notes, d.store_busy_rating, d.price_on_shelf, d.units_before, d.units_after,
  d.units_sampled, d.avg_samples_given, d.total_units_sold, d.demo_feedback, d.demo_hours,
  d.training_hours, d.merchandising_hours, d.other_hours, d.total_hours, d.created_at, d.updated_at,
  d.demo_images, d.demo_receipts, d.demo_request_type, d.requested_timing, d.store_names,
  d.retailer_fees, d.check_in_photo, d.check_in_status, d.nwg_demo, d.notes_to_demo_team,
  d.time_off_requested, d.time_off_request_date, d.time_off_notes,
  CASE
    WHEN d.time_off_requested IS TRUE THEN '#8B5CF6'::text
    WHEN d.demo_status IN (
      SELECT uuid FROM public.ref_demo_status_enum
      WHERE name IN ('Completed','Invoiced','Paid Contract','Paid Gnf')
    ) THEN '#9CA3AF'::text
    WHEN d.demo_status IN (
      SELECT uuid FROM public.ref_demo_status_enum
      WHERE name IN ('Store Confirmed','Inventory Confirmed','Rescheduled','Cancelled','Requested')
    ) THEN '#10B981'::text
    ELSE '#10B981'::text
  END AS event_color,
  COALESCE(
    (((string_agg(b.brand, ' + ') || ' - ') || a.account) || ' - ') || to_char(d.demo_date::timestamptz, 'MM/DD/YYYY'),
    'Scheduled Demo'
  ) AS demo_name,
  tm.name AS demo_team_member, tm.profile_photo,
  string_agg(b.demo_customer_type::text, ', ') AS brand_customer_types,
  a.account, a.gnf_priority,
  a.address AS store_address, a.city AS store_city, a.state AS store_state,
  a.zip AS store_zip, a.country, a.store_phone_number, a.website,
  a.account_description, a.account_notes, a.uuid AS account_uuid,
  a.updated_at AS account_last_updated,
  jsonb_agg(to_jsonb(b.*)) AS brand_details,
  string_agg(b.brand, ' + ') AS brand_names_list
FROM public.demos d
LEFT JOIN public.accounts a ON d.account_id = a.uuid
LEFT JOIN public.jt_demo_brands jdb ON d.id = jdb.demo_id
LEFT JOIN public.brands b ON jdb.brand_id = b.id
LEFT JOIN public.team_member_guide tm ON d.team_member_id = tm.uuid
GROUP BY d.id, a.uuid, tm.uuid;

-- ── RECREATE v_scheduled_demos ────────────────────────────────────────────────
-- WHERE demo_status = ANY(...) → WHERE demo_status IN (SELECT uuid ...)

CREATE OR REPLACE VIEW public.v_scheduled_demos AS
SELECT
  d.id, d.account_id, d.team_member_id,
  COALESCE(
    (((string_agg(b.brand, ' + ') || ' - ') || a.account) || ' - ') || to_char(d.demo_date::timestamptz, 'MM/DD/YYYY'),
    'Scheduled Demo'
  ) AS demo_name,
  d.demo_date, d.start_time, d.end_time,
  lower((to_char(d.start_time::interval, 'FMHH12am') || ' - ') || to_char(d.end_time::interval, 'FMHH12am')) AS formatted_time_range,
  d.demo_status,
  string_agg(b.brand, ' + ') AS brands,
  a.account AS store_name, tm.name AS demo_team_member, tm.email AS team_member_email,
  tm.phone_number, tm.address,
  d.time_off_requested, d.time_off_request_date, d.time_off_notes,
  d.demo_request_type, d.requested_timing, d.notes_to_demo_team, d.notes, d.created_at
FROM public.demos d
LEFT JOIN public.jt_demo_brands jdb ON d.id = jdb.demo_id
LEFT JOIN public.brands b ON jdb.brand_id = b.id
LEFT JOIN public.accounts a ON d.account_id = a.uuid
LEFT JOIN public.team_member_guide tm ON d.team_member_id = tm.uuid
WHERE d.demo_status IN (
  SELECT uuid FROM public.ref_demo_status_enum
  WHERE name IN ('Requested','Store Confirmed','Inventory Confirmed','Rescheduled')
)
GROUP BY d.id, d.demo_date, d.start_time, d.end_time, d.demo_status, a.account,
         tm.name, tm.email, tm.phone_number, tm.address,
         d.time_off_requested, d.time_off_request_date, d.time_off_notes,
         d.demo_request_type, d.requested_timing, d.notes_to_demo_team, d.notes, d.created_at;

-- ── RECREATE v_demo_calendar ──────────────────────────────────────────────────
-- demo_status::text = ANY(ARRAY['X'::text]) → demo_status IN (SELECT uuid ...)
-- GROUP BY includes d.demo_status (now uuid — compatible)

CREATE OR REPLACE VIEW public.v_demo_calendar AS
SELECT
  d.id, d.account_id, d.team_member_id,
  CASE
    WHEN d.time_off_requested IS TRUE THEN '#8B5CF6'::text
    WHEN d.demo_status IN (
      SELECT uuid FROM public.ref_demo_status_enum WHERE name IN ('Completed','Invoiced','Paid Contract','Paid Gnf')
    ) THEN '#9CA3AF'::text
    WHEN d.demo_status IN (
      SELECT uuid FROM public.ref_demo_status_enum WHERE name IN ('Store Confirmed','Inventory Confirmed','Rescheduled','Cancelled','Requested')
    ) THEN '#10B981'::text
    ELSE '#10B981'::text
  END AS event_color,
  COALESCE(
    (((string_agg(b.brand, ' + ') || ' - ') || a.account) || ' - ') || to_char(d.demo_date::timestamptz, 'MM/DD/YYYY'),
    'Scheduled Demo'
  ) AS demo_name,
  d.demo_date, d.start_time, d.end_time,
  lower((to_char(d.start_time::interval, 'FMHH12am') || ' - ') || to_char(d.end_time::interval, 'FMHH12am')) AS formatted_time_range,
  d.demo_status,
  string_agg(b.brand, ' + ') AS brands,
  a.account AS store_name, tm.name AS demo_team_member, tm.email AS team_member_email,
  tm.phone_number, tm.address,
  d.time_off_requested, d.time_off_request_date, d.time_off_notes,
  d.demo_request_type, d.requested_timing, d.notes_to_demo_team, d.notes, d.created_at
FROM public.demos d
LEFT JOIN public.jt_demo_brands jdb ON d.id = jdb.demo_id
LEFT JOIN public.brands b ON jdb.brand_id = b.id
LEFT JOIN public.accounts a ON d.account_id = a.uuid
LEFT JOIN public.team_member_guide tm ON d.team_member_id = tm.uuid
GROUP BY d.id, d.demo_date, d.start_time, d.end_time, d.demo_status, a.account,
         tm.name, tm.email, tm.phone_number, tm.address,
         d.time_off_requested, d.time_off_request_date, d.time_off_notes,
         d.demo_request_type, d.requested_timing, d.notes_to_demo_team, d.notes, d.created_at;

-- ── RECREATE v_demo_check_ins ─────────────────────────────────────────────────
-- WHERE demo_status = ANY(ARRAY['Store Confirmed'::demo_status_enum, 'Inventory Confirmed'::demo_status_enum])
-- → demo_status IN (SELECT uuid ...)

CREATE OR REPLACE VIEW public.v_demo_check_ins AS
SELECT
  d.id,
  COALESCE(
    (((string_agg(b.brand, ' + ') || ' - ') || a.account) || ' - ') || to_char(d.demo_date::timestamptz, 'MM/DD/YYYY'),
    'Demo Check-in'
  ) AS name,
  CASE WHEN d.check_in_status THEN 'Checked In'::text ELSE 'Pending'::text END AS check_in_status,
  d.check_in_photo, tm.name AS demo_team_member, tm.email AS team_member_email,
  d.demo_date, string_agg(b.brand, ' + ') AS brands, a.account AS store_name, d.created_at
FROM public.demos d
LEFT JOIN public.jt_demo_brands jdb ON d.id = jdb.demo_id
LEFT JOIN public.brands b ON jdb.brand_id = b.id
LEFT JOIN public.accounts a ON d.account_id = a.uuid
LEFT JOIN public.team_member_guide tm ON d.team_member_id = tm.uuid
WHERE d.demo_date = CURRENT_DATE
   OR d.demo_status IN (
     SELECT uuid FROM public.ref_demo_status_enum WHERE name IN ('Store Confirmed','Inventory Confirmed')
   )
GROUP BY d.id, d.check_in_status, d.check_in_photo, tm.name, tm.email, d.demo_date, a.account, d.created_at;

-- ── RECREATE demo_dashboard_metrics ──────────────────────────────────────────

CREATE OR REPLACE VIEW public.demo_dashboard_metrics AS
SELECT
  ( SELECT count(*) FROM public.demos
    WHERE demo_date > CURRENT_DATE
      AND demo_status IN (SELECT uuid FROM public.ref_demo_status_enum WHERE name IN ('Requested','Store Confirmed'))
  ) AS upcoming_demos,
  ( SELECT count(*) FROM public.demos
    WHERE demo_status IN (SELECT uuid FROM public.ref_demo_status_enum WHERE name = 'Completed')
  ) AS total_completed,
  ( SELECT min(demo_date) FROM public.demos
    WHERE demo_date > CURRENT_DATE
      AND demo_status IN (SELECT uuid FROM public.ref_demo_status_enum WHERE name IN ('Requested','Store Confirmed'))
  ) AS next_demo_date,
  ( SELECT to_char(min(demo_date)::timestamptz, 'MM/DD/YY') FROM public.demos
    WHERE demo_date > CURRENT_DATE
      AND demo_status IN (SELECT uuid FROM public.ref_demo_status_enum WHERE name IN ('Requested','Store Confirmed'))
  ) AS next_demo_formatted;
;