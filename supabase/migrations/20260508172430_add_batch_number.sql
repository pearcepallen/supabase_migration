
ALTER TABLE public.ref_migration_tracker
  ADD COLUMN IF NOT EXISTS batch_number integer,
  ADD COLUMN IF NOT EXISTS migration_mode text DEFAULT 'safe' CHECK (migration_mode IN ('safe', 'destructive'));

COMMENT ON COLUMN public.ref_migration_tracker.batch_number IS 'Execution batch grouping. Lower = higher priority. All records in same batch should be executed together in one transaction where possible.';
COMMENT ON COLUMN public.ref_migration_tracker.migration_mode IS 'safe = temp column backfill preserving all existing data. destructive = allow null reset. Default is safe for all.';

-- Set migration_mode to safe for all pending records
UPDATE public.ref_migration_tracker SET migration_mode = 'safe' WHERE status = 'pending';

-- BATCH 1 — ref tables already exist, lowest risk
UPDATE public.ref_migration_tracker SET batch_number = 1 WHERE priority_rank IN (1,2,3,4,6,11,13,14,15,16,38,43);

-- BATCH 2 — high-traffic single cols, shared enums, contained view deps
UPDATE public.ref_migration_tracker SET batch_number = 2 WHERE priority_rank IN (5,7,8,9,10,12);

-- BATCH 3 — spec_price_sheet + principal_list_product_specs full cert block
UPDATE public.ref_migration_tracker SET batch_number = 3 WHERE priority_rank IN (47,48,49,50,51,52,53,54,55,56,57,58,59,60,61);

-- BATCH 4 — promo cluster + brand table cols (shared enums must be coordinated)
UPDATE public.ref_migration_tracker SET batch_number = 4 WHERE priority_rank IN (25,26,27,28,31,32,33,34,39,40);

-- BATCH 5 — remaining singles
UPDATE public.ref_migration_tracker SET batch_number = 5 WHERE priority_rank IN (17,18,19,20,21,22,23,24,29,30,35,36,37,41,42,44,45,46,62);
;