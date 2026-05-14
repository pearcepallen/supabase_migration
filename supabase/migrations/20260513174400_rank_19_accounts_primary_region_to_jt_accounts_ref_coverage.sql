BEGIN;

-- ════════════════════════════════════════════════════════════════
-- RANK 19 — accounts.primary_region (array → JT)
-- ════════════════════════════════════════════════════════════════

CREATE TABLE public.jt_accounts_ref_coverage (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at   timestamptz NOT NULL DEFAULT now(),
  account      uuid NOT NULL REFERENCES accounts(uuid)      ON DELETE CASCADE,
  ref_coverage uuid NOT NULL REFERENCES ref_coverage(uuid)  ON DELETE CASCADE,
  UNIQUE (account, ref_coverage)
);

CREATE INDEX idx_jt_accounts_ref_coverage_account      ON public.jt_accounts_ref_coverage(account);
CREATE INDEX idx_jt_accounts_ref_coverage_ref_coverage ON public.jt_accounts_ref_coverage(ref_coverage);

-- ── Drop and recreate fetch_primary_region() with new return type ──────────────
DROP FUNCTION IF EXISTS public.fetch_primary_region();

CREATE FUNCTION public.fetch_primary_region()
  RETURNS TABLE(uuid uuid, primary_region text)
  LANGUAGE sql
AS $$
  SELECT uuid, name AS primary_region
  FROM ref_coverage
  ORDER BY name;
$$;

-- ── Drop v_brand_distribution_grid (references primary_region) ─────────────────
DROP VIEW IF EXISTS public.v_brand_distribution_grid;

-- ── Drop accounts.primary_region array column ─────────────────────────────────
ALTER TABLE public.accounts DROP COLUMN primary_region;

-- ── Recreate v_brand_distribution_grid ────────────────────────────────────────
CREATE VIEW public.v_brand_distribution_grid AS
SELECT
  bdg.id                                          AS grid_id,
  bdg.item_code,
  bdg.distribution_status,
  bdg.distribution_notes,
  bdg.brand_id,
  b.brand,
  bdg.item_name                                   AS item_spec_id,
  sps.unique_item_name                            AS spec_item_name,
  bdg.distributor_hq                              AS distributor_hq_id,
  dist_acc.account                                AS distributor_hq_name,
  (
    SELECT string_agg(rc.name, ', ' ORDER BY rc.name)
    FROM jt_accounts_ref_coverage jrc
    JOIN ref_coverage rc ON rc.uuid = jrc.ref_coverage
    WHERE jrc.account = dist_acc.uuid
  )                                               AS distributor_region,
  bdg.warehouse_dc                                AS warehouse_dc_id,
  wh_acc.account                                  AS warehouse_dc_name,
  bdg.updated_at                                  AS last_updated,
  bdg.updated_by
FROM brand_distribution_grid bdg
LEFT JOIN brands           b        ON bdg.brand_id       = b.id
LEFT JOIN spec_price_sheet sps      ON bdg.item_name      = sps.id
LEFT JOIN accounts         dist_acc ON bdg.distributor_hq = dist_acc.uuid
LEFT JOIN accounts         wh_acc   ON bdg.warehouse_dc   = wh_acc.uuid;

-- ── Tracker ───────────────────────────────────────────────────────────────────
UPDATE ref_migration_tracker
SET
  status            = 'done',
  executed_at       = now(),
  validation_passed = true,
  notes             = COALESCE(notes, '') || ' | jt_accounts_ref_coverage created. primary_region array dropped. fetch_primary_region() rewritten to query ref_coverage. v_brand_distribution_grid rewritten. 2026-05-13.'
WHERE priority_rank = 19;

COMMIT;
