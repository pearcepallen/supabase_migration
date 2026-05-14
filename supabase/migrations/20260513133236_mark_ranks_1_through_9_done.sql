UPDATE ref_migration_tracker
SET
  status            = 'done',
  executed_at       = now(),
  validation_passed = true,
  notes             = COALESCE(notes, '') || ' | Schema already applied on m2; tracker updated 2026-05-13.'
WHERE priority_rank IN (1, 2, 3, 4, 5, 6, 7, 8, 9);
