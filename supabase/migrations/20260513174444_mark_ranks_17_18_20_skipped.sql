UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Keep as enum per decision 2026-05-13. No ref table will be created.',
  notes = COALESCE(notes, '') || ' | Confirmed keep-as-enum 2026-05-13.'
WHERE priority_rank = 17;

UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'No seeding planned for ref_country. Country remains as enum per decision 2026-05-13.',
  notes = COALESCE(notes, '') || ' | ref_country exists but empty. No backfill. Keep as enum 2026-05-13.'
WHERE priority_rank = 18;

UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Keep as enum per decision 2026-05-13. No ref table or JT will be created.',
  notes = COALESCE(notes, '') || ' | Confirmed keep-as-enum 2026-05-13.'
WHERE priority_rank = 20;
