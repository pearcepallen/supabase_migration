UPDATE ref_migration_tracker SET ref_table_name = 'ref_hh_community_expert_status',
  notes = COALESCE(notes,'') || ' | ref_table_name corrected from ref_hh_community_expert_status_enum 2026-05-13.'
WHERE priority_rank IN (35, 36);

UPDATE ref_migration_tracker SET ref_table_name = 'ref_hh_validation_status',
  notes = COALESCE(notes,'') || ' | ref_table_name corrected from ref_hh_validation_status_enum 2026-05-13.'
WHERE priority_rank = 37;

UPDATE ref_migration_tracker SET ref_table_name = 'ref_employee_status',
  notes = COALESCE(notes,'') || ' | ref_table_name corrected from ref_employee_status_enum 2026-05-13.'
WHERE priority_rank = 62;
