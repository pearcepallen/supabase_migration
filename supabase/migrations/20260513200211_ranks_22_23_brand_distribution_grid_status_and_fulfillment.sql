BEGIN;

-- ── Drop dependent views ──────────────────────────────────────
DROP VIEW IF EXISTS public.v_deal_distribution;
DROP VIEW IF EXISTS public.v_brand_distribution_grid;

-- ════════════════════════════════════════════════════════════════
-- RANK 22 — brand_distribution_grid.distribution_status
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_distribution_status (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_distribution_status (name) VALUES
  ('Target'),
  ('In Setup'),
  ('Active w/Inventory'),
  ('Active; No Inventory'),
  ('Discontinued');

ALTER TABLE public.brand_distribution_grid ADD COLUMN distribution_status__new uuid;
UPDATE public.brand_distribution_grid bdg SET distribution_status__new = r.uuid
FROM public.ref_distribution_status r WHERE r.name = bdg.distribution_status::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.brand_distribution_grid WHERE distribution_status IS NOT NULL AND distribution_status__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 22 guard: unmapped non-null distribution_status'; END IF;
END $$;
ALTER TABLE public.brand_distribution_grid DROP COLUMN distribution_status;
ALTER TABLE public.brand_distribution_grid RENAME COLUMN distribution_status__new TO distribution_status;
ALTER TABLE public.brand_distribution_grid
  ADD CONSTRAINT fk_brand_distribution_grid_distribution_status
  FOREIGN KEY (distribution_status) REFERENCES public.ref_distribution_status(uuid);
CREATE INDEX idx_brand_distribution_grid_distribution_status ON public.brand_distribution_grid(distribution_status);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  ref_table_name = 'ref_distribution_status',
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_distribution_status created and seeded.'
WHERE priority_rank = 22;

-- ════════════════════════════════════════════════════════════════
-- RANK 23 — brand_distribution_grid.fulfillment_method
-- Note: original enum type had a trailing space: 'Fulfillment Method '
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.ref_fulfillment_method (
  id         bigint GENERATED ALWAYS AS IDENTITY,
  uuid       uuid   NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name       text   NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO public.ref_fulfillment_method (name) VALUES
  ('Direct'),
  ('Distributor DC');

ALTER TABLE public.brand_distribution_grid ADD COLUMN fulfillment_method__new uuid;
UPDATE public.brand_distribution_grid bdg SET fulfillment_method__new = r.uuid
FROM public.ref_fulfillment_method r WHERE r.name = bdg.fulfillment_method::text;
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM public.brand_distribution_grid WHERE fulfillment_method IS NOT NULL AND fulfillment_method__new IS NULL)
  THEN RAISE EXCEPTION 'Rank 23 guard: unmapped non-null fulfillment_method'; END IF;
END $$;
ALTER TABLE public.brand_distribution_grid DROP COLUMN fulfillment_method;
ALTER TABLE public.brand_distribution_grid RENAME COLUMN fulfillment_method__new TO fulfillment_method;
ALTER TABLE public.brand_distribution_grid
  ADD CONSTRAINT fk_brand_distribution_grid_fulfillment_method
  FOREIGN KEY (fulfillment_method) REFERENCES public.ref_fulfillment_method(uuid);
CREATE INDEX idx_brand_distribution_grid_fulfillment_method ON public.brand_distribution_grid(fulfillment_method);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  ref_table_name = 'ref_fulfillment_method',
  notes = COALESCE(notes,'') || ' | Migrated 2026-05-13. ref_fulfillment_method created and seeded.'
WHERE priority_rank = 23;

-- ════════════════════════════════════════════════════════════════
-- Recreate v_brand_distribution_grid
-- ════════════════════════════════════════════════════════════════

CREATE VIEW public.v_brand_distribution_grid AS
SELECT
  bdg.id AS grid_id, bdg.item_code, bdg.distribution_status, bdg.fulfillment_method,
  bdg.distribution_notes, bdg.brand_id, b.brand,
  bdg.item_name AS item_spec_id,
  sps.unique_item_name AS spec_item_name,
  bdg.distributor_hq AS distributor_hq_id,
  dist_acc.account AS distributor_hq_name,
  (
    SELECT string_agg(rc.name, ', ' ORDER BY rc.name)
    FROM jt_accounts_ref_coverage jrc
    JOIN ref_coverage rc ON rc.uuid = jrc.ref_coverage
    WHERE jrc.account = dist_acc.uuid
  ) AS distributor_region,
  bdg.warehouse_dc AS warehouse_dc_id,
  wh_acc.account AS warehouse_dc_name,
  bdg.updated_at AS last_updated,
  bdg.updated_by
FROM brand_distribution_grid bdg
LEFT JOIN brands           b        ON bdg.brand_id       = b.id
LEFT JOIN spec_price_sheet sps      ON bdg.item_name      = sps.id
LEFT JOIN accounts         dist_acc ON bdg.distributor_hq = dist_acc.uuid
LEFT JOIN accounts         wh_acc   ON bdg.warehouse_dc   = wh_acc.uuid;

-- ════════════════════════════════════════════════════════════════
-- Recreate v_deal_distribution
-- ════════════════════════════════════════════════════════════════

CREATE VIEW public.v_deal_distribution AS
SELECT
  jtd.id AS deal_distribution_id,
  jtd.created_at AS deal_distribution_created_at,
  jtd.deal_id,
  jaadg.account_id AS active_account_id,
  acc.account AS active_account_name,
  jaadg.distribution_grid_id,
  bdg.distribution_status,
  bdg.id AS brand_distribution_grid_id,
  bdg.brand_id,
  b.brand AS brand_name,
  bdg.distributor_hq,
  dist_acc.account AS distributor_hq_name,
  bdg.warehouse_dc,
  wh_acc.account AS warehouse_dc_name,
  bdg.item_name AS spec_price_sheet_id,
  sps.description AS item_description
FROM jt_deal_distribution jtd
LEFT JOIN activity_tracker at               ON jtd.deal_id              = at.id
LEFT JOIN jt_active_account_distribution_grid jaadg ON jtd.distribution_id   = jaadg.id
LEFT JOIN accounts acc                      ON jaadg.account_id          = acc.uuid
LEFT JOIN brand_distribution_grid bdg       ON jaadg.distribution_grid_id = bdg.id
LEFT JOIN brands b                          ON bdg.brand_id              = b.id
LEFT JOIN accounts dist_acc                 ON bdg.distributor_hq        = dist_acc.uuid
LEFT JOIN accounts wh_acc                   ON bdg.warehouse_dc          = wh_acc.uuid
LEFT JOIN spec_price_sheet sps              ON bdg.item_name             = sps.id;

COMMIT;
