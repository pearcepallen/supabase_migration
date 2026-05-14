UPDATE ref_migration_tracker SET status = 'skipped', executed_at = now(),
  skip_reason = 'Keep as enum per decision 2026-05-13.',
  notes = COALESCE(notes,'') || ' | Skipped 2026-05-13: keep as enum.'
WHERE priority_rank IN (39, 40);

UPDATE ref_migration_tracker SET status = 'done', executed_at = now(), validation_passed = true,
  notes = COALESCE(notes,'') || ' | Marked complete 2026-05-13: remains as enum by design. No notifications changes.'
WHERE priority_rank IN (41, 42);
