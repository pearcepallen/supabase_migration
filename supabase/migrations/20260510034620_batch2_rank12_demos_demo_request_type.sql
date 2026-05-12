
BEGIN;

-- Drop the 3 affected views (already rewritten by Batch 1, using those as base)
DROP VIEW IF EXISTS public.v_completed_demos;
DROP VIEW IF EXISTS public.v_demo_calendar;
DROP VIEW IF EXISTS public.v_scheduled_demos;

ALTER TABLE public.demos ADD COLUMN demo_request_type__new uuid;

UPDATE public.demos d
SET demo_request_type__new = r.uuid
FROM public.ref_demo_request_type_enum r
WHERE r.name = d.demo_request_type::text;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.demos
    WHERE demo_request_type IS NOT NULL AND demo_request_type__new IS NULL
  ) THEN
    RAISE EXCEPTION 'Unmapped demo_request_type values in demos — aborting.';
  END IF;
END $$;

ALTER TABLE public.demos DROP COLUMN demo_request_type;
ALTER TABLE public.demos RENAME COLUMN demo_request_type__new TO demo_request_type;

ALTER TABLE public.demos
  ADD CONSTRAINT fk_demos_demo_request_type
  FOREIGN KEY (demo_request_type) REFERENCES public.ref_demo_request_type_enum(uuid);

CREATE INDEX idx_demos_demo_request_type ON public.demos(demo_request_type);

-- Recreate views using Batch-1-rewritten definitions as base;
-- demo_request_type is now uuid, passed through as-is
CREATE OR REPLACE VIEW public.v_completed_demos AS
SELECT
  d.id, d.demo_date, d.date_submitted, d.demo_status, d.start_time, d.end_time,
  d.time_range, d.account_id, d.team_member_id, d.store_poc, d.demo_fee,
  d.date_billed, d.other_fees, d.billing_notes, d.notes, d.store_busy_rating,
  d.price_on_shelf, d.units_before, d.units_after, d.units_sampled,
  d.avg_samples_given, d.total_units_sold, d.demo_feedback, d.demo_hours,
  d.training_hours, d.merchandising_hours, d.other_hours, d.total_hours,
  d.created_at, d.updated_at, d.demo_images, d.demo_receipts,
  d.demo_request_type, d.requested_timing, d.store_names, d.retailer_fees,
  d.check_in_photo, d.check_in_status, d.nwg_demo, d.notes_to_demo_team,
  d.time_off_requested, d.time_off_request_date, d.time_off_notes,
  CASE
    WHEN d.time_off_requested IS TRUE THEN '#8B5CF6'::text
    WHEN d.demo_status IN (
      SELECT ref_demo_status_enum.uuid FROM ref_demo_status_enum
      WHERE ref_demo_status_enum.name = ANY(ARRAY['Completed','Invoiced','Paid Contract','Paid Gnf'])
    ) THEN '#9CA3AF'::text
    WHEN d.demo_status IN (
      SELECT ref_demo_status_enum.uuid FROM ref_demo_status_enum
      WHERE ref_demo_status_enum.name = ANY(ARRAY['Store Confirmed','Inventory Confirmed','Rescheduled','Cancelled','Requested'])
    ) THEN '#10B981'::text
    ELSE '#10B981'::text
  END AS event_color,
  COALESCE(
    (((string_agg(b.brand, ' + ') || ' - ') || a.account) || ' - ') || to_char(d.demo_date::timestamptz, 'MM/DD/YYYY'),
    'Scheduled Demo'
  ) AS demo_name,
  tm.name AS demo_team_member, tm.profile_photo,
  string_agg(b.demo_customer_type::text, ', ') AS brand_customer_types,
  a.account, a.gnf_priority, a.address AS store_address, a.city AS store_city,
  a.state AS store_state, a.zip AS store_zip, a.country, a.store_phone_number,
  a.website, a.account_description, a.account_notes, a.uuid AS account_uuid,
  a.updated_at AS account_last_updated,
  jsonb_agg(to_jsonb(b.*)) AS brand_details,
  string_agg(b.brand, ' + ') AS brand_names_list
FROM demos d
LEFT JOIN accounts a ON d.account_id = a.uuid
LEFT JOIN jt_demo_brands jdb ON d.id = jdb.demo_id
LEFT JOIN brands b ON jdb.brand_id = b.id
LEFT JOIN team_member_guide tm ON d.team_member_id = tm.uuid
GROUP BY d.id, a.uuid, tm.uuid;

CREATE OR REPLACE VIEW public.v_demo_calendar AS
SELECT
  d.id, d.account_id, d.team_member_id,
  CASE
    WHEN d.time_off_requested IS TRUE THEN '#8B5CF6'::text
    WHEN d.demo_status IN (
      SELECT ref_demo_status_enum.uuid FROM ref_demo_status_enum
      WHERE ref_demo_status_enum.name = ANY(ARRAY['Completed','Invoiced','Paid Contract','Paid Gnf'])
    ) THEN '#9CA3AF'::text
    WHEN d.demo_status IN (
      SELECT ref_demo_status_enum.uuid FROM ref_demo_status_enum
      WHERE ref_demo_status_enum.name = ANY(ARRAY['Store Confirmed','Inventory Confirmed','Rescheduled','Cancelled','Requested'])
    ) THEN '#10B981'::text
    ELSE '#10B981'::text
  END AS event_color,
  COALESCE(
    (((string_agg(b.brand, ' + ') || ' - ') || a.account) || ' - ') || to_char(d.demo_date::timestamptz, 'MM/DD/YYYY'),
    'Scheduled Demo'
  ) AS demo_name,
  d.demo_date, d.start_time, d.end_time,
  lower((to_char(d.start_time::interval, 'FMHH12am') || ' - ') || to_char(d.end_time::interval, 'FMHH12am')) AS formatted_time_range,
  d.demo_status, string_agg(b.brand, ' + ') AS brands,
  a.account AS store_name, tm.name AS demo_team_member, tm.email AS team_member_email,
  tm.phone_number, tm.address, d.time_off_requested, d.time_off_request_date,
  d.time_off_notes, d.demo_request_type, d.requested_timing, d.notes_to_demo_team,
  d.notes, d.created_at
FROM demos d
LEFT JOIN jt_demo_brands jdb ON d.id = jdb.demo_id
LEFT JOIN brands b ON jdb.brand_id = b.id
LEFT JOIN accounts a ON d.account_id = a.uuid
LEFT JOIN team_member_guide tm ON d.team_member_id = tm.uuid
GROUP BY d.id, d.demo_date, d.start_time, d.end_time, d.demo_status, a.account,
  tm.name, tm.email, tm.phone_number, tm.address, d.time_off_requested,
  d.time_off_request_date, d.time_off_notes, d.demo_request_type,
  d.requested_timing, d.notes_to_demo_team, d.notes, d.created_at;

CREATE OR REPLACE VIEW public.v_scheduled_demos AS
SELECT
  d.id, d.account_id, d.team_member_id,
  COALESCE(
    (((string_agg(b.brand, ' + ') || ' - ') || a.account) || ' - ') || to_char(d.demo_date::timestamptz, 'MM/DD/YYYY'),
    'Scheduled Demo'
  ) AS demo_name,
  d.demo_date, d.start_time, d.end_time,
  lower((to_char(d.start_time::interval, 'FMHH12am') || ' - ') || to_char(d.end_time::interval, 'FMHH12am')) AS formatted_time_range,
  d.demo_status, string_agg(b.brand, ' + ') AS brands,
  a.account AS store_name, tm.name AS demo_team_member, tm.email AS team_member_email,
  tm.phone_number, tm.address, d.time_off_requested, d.time_off_request_date,
  d.time_off_notes, d.demo_request_type, d.requested_timing, d.notes_to_demo_team,
  d.notes, d.created_at
FROM demos d
LEFT JOIN jt_demo_brands jdb ON d.id = jdb.demo_id
LEFT JOIN brands b ON jdb.brand_id = b.id
LEFT JOIN accounts a ON d.account_id = a.uuid
LEFT JOIN team_member_guide tm ON d.team_member_id = tm.uuid
WHERE d.demo_status IN (
  SELECT ref_demo_status_enum.uuid FROM ref_demo_status_enum
  WHERE ref_demo_status_enum.name = ANY(ARRAY['Requested','Store Confirmed','Inventory Confirmed','Rescheduled'])
)
GROUP BY d.id, d.demo_date, d.start_time, d.end_time, d.demo_status, a.account,
  tm.name, tm.email, tm.phone_number, tm.address, d.time_off_requested,
  d.time_off_request_date, d.time_off_notes, d.demo_request_type,
  d.requested_timing, d.notes_to_demo_team, d.notes, d.created_at;

COMMIT;
;