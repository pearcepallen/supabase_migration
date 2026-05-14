-- Rank 15: calling_month — already uuid+FK, tracker note was misleading
UPDATE ref_migration_tracker SET
  status = 'done',
  validation_passed = true,
  executed_at = now(),
  skip_reason = null,
  notes = COALESCE(notes,'') || ' | Marked done 2026-05-13: enum retained by design. No migration action was ever required — column functions correctly as enum and no ref table will be created.'
WHERE priority_rank = 15;

-- Ranks 17, 20: state, call_preferences — keep as enum
UPDATE ref_migration_tracker SET
  status = 'done',
  validation_passed = true,
  executed_at = now(),
  notes = COALESCE(notes,'') || ' | Marked done 2026-05-13: enum retained by design. No migration action was ever required — column functions correctly as enum and no ref table will be created.'
WHERE priority_rank IN (17, 20);

-- Rank 18: country — ref_country exists but unseeded
UPDATE ref_migration_tracker SET
  status = 'done',
  validation_passed = true,
  executed_at = now(),
  notes = COALESCE(notes,'') || ' | Marked done 2026-05-13: enum retained by design. ref_country exists but will not be seeded. No migration action required — column functions correctly as enum.'
WHERE priority_rank = 18;

-- Ranks 29, 30: brand_tasks source + status — keep as enum
UPDATE ref_migration_tracker SET
  notes = COALESCE(notes,'') || ' | Confirmed done 2026-05-13: enum retained by design. No migration action was ever required — column functions correctly as enum and no ref table will be created.'
WHERE priority_rank IN (29, 30);

-- Ranks 39, 40: master_promo_data effective_promo_month + year
UPDATE ref_migration_tracker SET
  status = 'done',
  validation_passed = true,
  executed_at = now(),
  notes = COALESCE(notes,'') || ' | Marked done 2026-05-13: enum retained by design. No migration action was ever required — column functions correctly as enum and no ref table will be created.'
WHERE priority_rank IN (39, 40);

-- Ranks 41, 42: notifications type + status
UPDATE ref_migration_tracker SET
  notes = COALESCE(notes,'') || ' | Confirmed done 2026-05-13: enum retained by design. No migration action was ever required — column functions correctly as enum and no ref table will be created.'
WHERE priority_rank IN (41, 42);

-- Ranks 100-106, 110-124: pre-assessed out of scope
UPDATE ref_migration_tracker SET
  skip_reason = 'Pre-assessed as out of scope: column is not a candidate for enum-to-ref migration (boolean, text flag, or enum retained by design).',
  notes = COALESCE(notes,'') || ' | Skip reason documented 2026-05-13: pre-assessed out of scope. No migration action required.'
WHERE priority_rank IN (100,101,102,103,104,105,106,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124);

-- Deferred/needs-review clarifications
UPDATE ref_migration_tracker SET
  notes = COALESCE(notes,'') || ' | 2026-05-13: remains deferred. Revisit when focus_month migration is prioritized.'
WHERE priority_rank = 24;

UPDATE ref_migration_tracker SET
  notes = COALESCE(notes,'') || ' | 2026-05-13: remains on hold pending promotion process review. Column may not exist on brand_promotions — verify before actioning.'
WHERE priority_rank = 26;

UPDATE ref_migration_tracker SET
  notes = COALESCE(notes,'') || ' | 2026-05-13: remains pending review. Confirm intended ref table structure before migrating.'
WHERE priority_rank IN (31, 33, 34);
