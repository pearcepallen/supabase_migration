BEGIN;

-- ════════════════════════════════════════════════════════════════
-- TRACKER-ONLY UPDATES
-- ════════════════════════════════════════════════════════════════

UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Source table brand_promo_requests does not exist in schema.',
  notes = COALESCE(notes,'') || ' | Skipped 2026-05-13: table not found.'
WHERE priority_rank = 25;

UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Awaiting promotion process review before migrating.',
  notes = COALESCE(notes,'') || ' | Skipped 2026-05-13: awaiting promotion review. Column may not exist on brand_promotions.'
WHERE priority_rank = 26;

UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Column is deprecated and will be removed. No migration needed.',
  notes = COALESCE(notes,'') || ' | Skipped 2026-05-13: deprecated column, pending removal.'
WHERE priority_rank = 32;

UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Needs review before array→JT migration can proceed.',
  notes = COALESCE(notes,'') || ' | Skipped 2026-05-13: needs review.'
WHERE priority_rank = 34;

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Marked complete 2026-05-13: remains as enum by design.'
WHERE priority_rank IN (29, 30);

UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Needs review before migration.',
  notes = COALESCE(notes,'') || ' | Skipped 2026-05-13: needs review.'
WHERE priority_rank IN (31, 33);

UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Low priority. Deferred for future migration cycle.',
  notes = COALESCE(notes,'') || ' | Skipped 2026-05-13: low priority deferral.'
WHERE priority_rank = 24;

-- ════════════════════════════════════════════════════════════════
-- DROP DEPENDENT VIEWS
-- ════════════════════════════════════════════════════════════════

DROP VIEW IF EXISTS public.v_brand_promotions_with_skus;
DROP VIEW IF EXISTS public.v_brand_contacts;

-- ════════════════════════════════════════════════════════════════
-- RANK 27 — brand_promotions.submission_status
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_promo_submission_status (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_promo_submission_status (uuid, name) VALUES
  ('a1b2c3d4-0001-0001-0001-000000000001', '---'),
  ('a1b2c3d4-0001-0001-0001-000000000002', 'Missed/Declined'),
  ('a1b2c3d4-0001-0001-0001-000000000003', 'Planned'),
  ('a1b2c3d4-0001-0001-0001-000000000004', 'Requested'),
  ('a1b2c3d4-0001-0001-0001-000000000005', 'Submitted');

ALTER TABLE public.brand_promotions ADD COLUMN submission_status__new uuid;
UPDATE public.brand_promotions bp SET submission_status__new = r.uuid
FROM public.ref_promo_submission_status r WHERE r.name = bp.submission_status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.brand_promotions WHERE submission_status IS NOT NULL AND submission_status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 27 guard: unmapped non-null submission_status values'; END IF;
END $$;
ALTER TABLE public.brand_promotions DROP COLUMN submission_status;
ALTER TABLE public.brand_promotions RENAME COLUMN submission_status__new TO submission_status;
ALTER TABLE public.brand_promotions
  ALTER COLUMN submission_status SET DEFAULT 'a1b2c3d4-0001-0001-0001-000000000004'::uuid;
ALTER TABLE public.brand_promotions
  ADD CONSTRAINT fk_brand_promotions_submission_status
  FOREIGN KEY (submission_status) REFERENCES public.ref_promo_submission_status(uuid);
CREATE INDEX idx_brand_promotions_submission_status ON public.brand_promotions(submission_status);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_promo_submission_status created and seeded.'
WHERE priority_rank = 27;

-- ════════════════════════════════════════════════════════════════
-- RANK 28 — brand_promotions.promo_quarter
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_quarter (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_quarter (name) VALUES ('Q1'),('Q2'),('Q3'),('Q4');

ALTER TABLE public.brand_promotions ADD COLUMN promo_quarter__new uuid;
UPDATE public.brand_promotions bp SET promo_quarter__new = r.uuid
FROM public.ref_quarter r WHERE r.name = bp.promo_quarter::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.brand_promotions WHERE promo_quarter IS NOT NULL AND promo_quarter__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 28 guard: unmapped non-null promo_quarter values'; END IF;
END $$;
ALTER TABLE public.brand_promotions DROP COLUMN promo_quarter;
ALTER TABLE public.brand_promotions RENAME COLUMN promo_quarter__new TO promo_quarter;
ALTER TABLE public.brand_promotions
  ADD CONSTRAINT fk_brand_promotions_promo_quarter
  FOREIGN KEY (promo_quarter) REFERENCES public.ref_quarter(uuid);
CREATE INDEX idx_brand_promotions_promo_quarter ON public.brand_promotions(promo_quarter);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_quarter created and seeded.'
WHERE priority_rank = 28;

-- ════════════════════════════════════════════════════════════════
-- RECREATE v_brand_promotions_with_skus
-- ════════════════════════════════════════════════════════════════

CREATE VIEW public.v_brand_promotions_with_skus AS
SELECT
  bp.id, bp.created_at, bp.brand, bp.master_promo_id, bp.retailer_id,
  bp.distribution_id, bp.promo_quarter, bp.submission_status, bp.brand_approval,
  bp.submission_notes, bp.brand_comments, bp.submitted_promo_contracts,
  json_agg(
    jsonb_build_object(
      'id', sps.id, 'unique_item_name', sps.unique_item_name,
      'other_pricing_unit', sps.other_pricing_unit, 'other_pricing_case', sps.other_pricing_case
    )
  ) FILTER (WHERE sps.id IS NOT NULL) AS skus
FROM brand_promotions bp
LEFT JOIN jt_brand_promotion_skus jt ON bp.id = jt.brand_promotion_id
LEFT JOIN spec_price_sheet sps        ON jt.sku_id = sps.id
GROUP BY bp.id;

-- ════════════════════════════════════════════════════════════════
-- RANKS 35+36 — hh_community_experts + hh_account_experts.status
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_hh_community_expert_status (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_hh_community_expert_status (uuid, name) VALUES
  ('b2c3d4e5-0002-0002-0002-000000000001', 'Active'),
  ('b2c3d4e5-0002-0002-0002-000000000002', 'Form Submitted - Pending Approval'),
  ('b2c3d4e5-0002-0002-0002-000000000003', 'Pending - Need Info'),
  ('b2c3d4e5-0002-0002-0002-000000000004', 'dont_feature');

-- Rank 35
ALTER TABLE public.hh_community_experts ADD COLUMN status__new uuid;
UPDATE public.hh_community_experts ce SET status__new = r.uuid
FROM public.ref_hh_community_expert_status r WHERE r.name = ce.status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.hh_community_experts WHERE status IS NOT NULL AND status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 35 guard: unmapped status in hh_community_experts'; END IF;
END $$;
ALTER TABLE public.hh_community_experts DROP COLUMN status;
ALTER TABLE public.hh_community_experts RENAME COLUMN status__new TO status;
ALTER TABLE public.hh_community_experts
  ALTER COLUMN status SET DEFAULT 'b2c3d4e5-0002-0002-0002-000000000002'::uuid;
ALTER TABLE public.hh_community_experts
  ADD CONSTRAINT fk_hh_community_experts_status
  FOREIGN KEY (status) REFERENCES public.ref_hh_community_expert_status(uuid);
CREATE INDEX idx_hh_community_experts_status ON public.hh_community_experts(status);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. Shared ref_hh_community_expert_status.'
WHERE priority_rank = 35;

-- Rank 36
ALTER TABLE public.hh_account_experts ADD COLUMN status__new uuid;
UPDATE public.hh_account_experts ae SET status__new = r.uuid
FROM public.ref_hh_community_expert_status r WHERE r.name = ae.status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.hh_account_experts WHERE status IS NOT NULL AND status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 36 guard: unmapped status in hh_account_experts'; END IF;
END $$;
ALTER TABLE public.hh_account_experts DROP COLUMN status;
ALTER TABLE public.hh_account_experts RENAME COLUMN status__new TO status;
ALTER TABLE public.hh_account_experts
  ALTER COLUMN status SET DEFAULT 'b2c3d4e5-0002-0002-0002-000000000002'::uuid;
ALTER TABLE public.hh_account_experts
  ADD CONSTRAINT fk_hh_account_experts_status
  FOREIGN KEY (status) REFERENCES public.ref_hh_community_expert_status(uuid);
CREATE INDEX idx_hh_account_experts_status ON public.hh_account_experts(status);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. Shared ref_hh_community_expert_status.'
WHERE priority_rank = 36;

-- ════════════════════════════════════════════════════════════════
-- RANK 37 — hh_contributions.validation_status
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_hh_validation_status (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_hh_validation_status (uuid, name) VALUES
  ('c3d4e5f6-0003-0003-0003-000000000001', 'Incorrect or missing information'),
  ('c3d4e5f6-0003-0003-0003-000000000002', 'Pending Review'),
  ('c3d4e5f6-0003-0003-0003-000000000003', 'Validated');

ALTER TABLE public.hh_contributions ADD COLUMN validation_status__new uuid;
UPDATE public.hh_contributions hc SET validation_status__new = r.uuid
FROM public.ref_hh_validation_status r WHERE r.name = hc.validation_status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.hh_contributions WHERE validation_status IS NOT NULL AND validation_status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 37 guard: unmapped validation_status in hh_contributions'; END IF;
END $$;
ALTER TABLE public.hh_contributions DROP COLUMN validation_status;
ALTER TABLE public.hh_contributions RENAME COLUMN validation_status__new TO validation_status;
ALTER TABLE public.hh_contributions
  ALTER COLUMN validation_status SET DEFAULT 'c3d4e5f6-0003-0003-0003-000000000002'::uuid;
ALTER TABLE public.hh_contributions
  ADD CONSTRAINT fk_hh_contributions_validation_status
  FOREIGN KEY (validation_status) REFERENCES public.ref_hh_validation_status(uuid);
CREATE INDEX idx_hh_contributions_validation_status ON public.hh_contributions(validation_status);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_hh_validation_status created and seeded.'
WHERE priority_rank = 37;

-- ════════════════════════════════════════════════════════════════
-- RANK 21 — brand_contacts_table.contact_tags (array → JT)
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_brand_contact_tags (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_brand_contact_tags (name) VALUES
  ('Accounting'),('Main Contact'),('Marketing'),
  ('Operations'),('Samples'),('Secondary Contact');

CREATE TABLE public.jt_brand_contacts_ref_contact_tags (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at   timestamptz NOT NULL DEFAULT now(),
  contact      uuid NOT NULL REFERENCES brand_contacts_table(uuid) ON DELETE CASCADE,
  contact_tag  uuid NOT NULL REFERENCES ref_brand_contact_tags(uuid) ON DELETE CASCADE,
  UNIQUE (contact, contact_tag)
);

CREATE INDEX idx_jt_brand_contacts_tags_contact     ON public.jt_brand_contacts_ref_contact_tags(contact);
CREATE INDEX idx_jt_brand_contacts_tags_contact_tag ON public.jt_brand_contacts_ref_contact_tags(contact_tag);

INSERT INTO public.jt_brand_contacts_ref_contact_tags (contact, contact_tag)
SELECT bc.uuid, r.uuid
FROM public.brand_contacts_table bc
CROSS JOIN LATERAL unnest(bc.contact_tags) AS tag_val
JOIN public.ref_brand_contact_tags r ON r.name = tag_val::text
ON CONFLICT (contact, contact_tag) DO NOTHING;

ALTER TABLE public.brand_contacts_table DROP COLUMN contact_tags;

CREATE VIEW public.v_brand_contacts AS
SELECT
  c.uuid,
  c.created_at,
  c.first_name,
  c.last_name,
  c.email,
  c.title,
  c.phone,
  c.receive_company_updates,
  c.company AS brand_id,
  b.brand AS brand_name,
  COALESCE(
    array_agg(rct.name ORDER BY rct.name) FILTER (WHERE rct.name IS NOT NULL),
    ARRAY[]::text[]
  ) AS contact_tags
FROM brand_contacts_table c
LEFT JOIN brands b ON c.company = b.id
LEFT JOIN jt_brand_contacts_ref_contact_tags jt ON jt.contact = c.uuid
LEFT JOIN ref_brand_contact_tags rct ON rct.uuid = jt.contact_tag
GROUP BY c.uuid, c.created_at, c.first_name, c.last_name, c.email,
         c.title, c.phone, c.receive_company_updates, c.company, b.brand;

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_brand_contact_tags + JT created. Array backfilled and dropped. v_brand_contacts rewritten.'
WHERE priority_rank = 21;

COMMIT;
