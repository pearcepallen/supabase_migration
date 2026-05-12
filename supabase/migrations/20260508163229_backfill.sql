
INSERT INTO public.ref_migration_tracker (
  priority_rank, source_table, source_column, enum_type_name, migration_pattern,
  before_data_type, before_udt_name, before_column_default, before_is_nullable,
  ref_table_name, ref_table_existed_before,
  views_affected, status, notes
) VALUES

-- PRIORITY 1 — hh_customers (4 columns, batch together)
(1, 'hh_customers', 'status', 'hh_customer_status_enum', 'single_fk',
 'USER-DEFINED', 'hh_customer_status_enum', NULL, 'YES',
 'ref_hh_customer_status', true,
 ARRAY['v_harvesthub_customer_datagrid','v_hh_customer_activity'],
 'pending', 'ref_hh_customer_status already exists. High-traffic table — safe mode required. Batch all 4 hh_customers columns in one transaction.'),

(2, 'hh_customers', 'role', 'hh_user_role_enum', 'single_fk',
 'USER-DEFINED', 'hh_user_role_enum', NULL, 'YES',
 'ref_hh_user_role_enum', true,
 ARRAY['v_harvesthub_customer_datagrid'],
 'pending', 'ref_hh_user_role_enum already exists. Batch with #1.'),

(3, 'hh_customers', 'billing_terms', 'hh_billing_terms_enum', 'single_fk',
 'USER-DEFINED', 'hh_billing_terms_enum', NULL, 'YES',
 'ref_hh_billing_terms_enum', true,
 ARRAY['v_harvesthub_customer_datagrid'],
 'pending', 'ref_hh_billing_terms_enum already exists. Batch with #1.'),

(4, 'hh_customers', 'payment_status', 'hh_payment_status_enum', 'single_fk',
 'USER-DEFINED', 'hh_payment_status_enum', NULL, 'YES',
 'ref_hh_payment_status_enum', true,
 ARRAY['v_harvesthub_customer_datagrid'],
 'pending', 'ref_hh_payment_status_enum already exists. Batch with #1. All 4 hh_customers cols + view rewrite in single transaction.'),

-- PRIORITY 2 — hh_deals
(5, 'hh_deals', 'stage', 'hh_deal_stage_enum', 'single_fk',
 'USER-DEFINED', 'hh_deal_stage_enum', '''Target''::hh_deal_stage_enum', 'YES',
 'ref_deal_stage', true,
 NULL,
 'pending', 'ref_deal_stage exists. Has DEFAULT value — must update DEFAULT to UUID lookup post-migration. Check for triggers on hh_deals.'),

(6, 'hh_deals', 'priority', 'priority_enum', 'single_fk',
 'USER-DEFINED', 'priority_enum', NULL, 'YES',
 'ref_priority_enum', false,
 NULL,
 'pending', 'No ref table yet — create ref_priority_enum. Shared with task_pipeline.priority (#9) — create once, apply to both.'),

-- PRIORITY 3 — task_pipeline
(7, 'task_pipeline', 'status', 'kanban_status_enum', 'single_fk',
 'USER-DEFINED', 'kanban_status_enum', NULL, 'YES',
 'ref_kanban_status_enum', false,
 ARRAY['v_task_pipeline_with_assignees'],
 'pending', 'No ref table yet — create ref_kanban_status_enum. View must be rewritten. RLS lint flagged on this table — review during migration.'),

(8, 'task_pipeline', 'task_type', 'task_type_enum', 'single_fk',
 'USER-DEFINED', 'task_type_enum', NULL, 'NO',
 'ref_task_type_enum', true,
 ARRAY['v_task_pipeline_with_assignees'],
 'pending', 'ref_task_type_enum exists. Column is NOT NULL — safe mode, temp column backfill, no nulls allowed.'),

(9, 'task_pipeline', 'priority', 'priority_enum', 'single_fk',
 'USER-DEFINED', 'priority_enum', '''Medium''::priority_enum', 'YES',
 'ref_priority_enum', false,
 ARRAY['v_task_pipeline_with_assignees'],
 'pending', 'Shared enum with hh_deals.priority (#6). Create ref_priority_enum once. Has DEFAULT ''Medium'' — update to UUID post-migration.'),

(10, 'task_pipeline', 'source_type', 'source_type_enum', 'single_fk',
 'USER-DEFINED', 'source_type_enum', '''manual''::source_type_enum', 'YES',
 'ref_source_type_enum', false,
 ARRAY['v_task_pipeline_with_assignees'],
 'pending', 'No ref table yet — create ref_source_type_enum. Has DEFAULT ''manual'' — update post-migration.'),

-- PRIORITY 4 — activity_tracker
(11, 'activity_tracker', 'activity_type', 'activity_type_enum', 'single_fk',
 'USER-DEFINED', 'activity_type_enum', '''GNF Deal''::activity_type_enum', 'YES',
 'ref_activity_type_enum', false,
 ARRAY['activity_tracker_details_view'],
 'pending', 'No ref table yet. Has DEFAULT. auth_rls_initplan lint hit on this table — fix RLS policy during migration window. Batch with #12.'),

(12, 'activity_tracker', 'sku_placement_type', 'placement_type_enum', 'single_fk',
 'USER-DEFINED', 'placement_type_enum', '''Team-led''::placement_type_enum', 'YES',
 'ref_placement_type_enum', false,
 ARRAY['activity_tracker_details_view'],
 'pending', 'No ref table yet. Has DEFAULT. Batch with #11 — same table, same transaction.'),

-- PRIORITY 5 — demos
(13, 'demos', 'demo_status', 'demo_status_enum', 'single_fk',
 'USER-DEFINED', 'demo_status_enum', '''Requested''::demo_status_enum', 'YES',
 'ref_demo_status_enum', true,
 ARRAY['v_completed_demos','v_demo_calendar','v_scheduled_demos'],
 'pending', 'ref_demo_status_enum already exists. 3 views affected — rewrite all in same transaction. Has DEFAULT.'),

(14, 'demos', 'demo_request_type', 'demo_request_type_enum', 'single_fk',
 'USER-DEFINED', 'demo_request_type_enum', NULL, 'YES',
 'ref_demo_request_type_enum', false,
 ARRAY['v_completed_demos','v_demo_calendar','v_scheduled_demos'],
 'pending', 'No ref table yet — create ref_demo_request_type_enum. Same 3 views as #13 — batch both demos cols in one transaction.'),

-- PRIORITY 6 — sos_authorizations
(15, 'sos_authorizations', 'program_status', 'program_status_type', 'single_fk',
 'USER-DEFINED', 'program_status_type', NULL, 'YES',
 'ref_sos_program_type', true,
 ARRAY['v_sos_authorizations_extended','v_sos_authorizations_with_calculated_revenue','v_program_connects_by_month'],
 'pending', 'ref_sos_program_type exists. 3 views affected including high-value revenue view.'),

(16, 'sos_authorizations', 'region', 'region', 'single_fk',
 'USER-DEFINED', 'region', NULL, 'YES',
 'ref_coverage', true,
 ARRAY['v_sos_authorizations_extended','v_sos_authorizations_with_calculated_revenue'],
 'pending', 'ref_coverage exists — verify region enum values overlap with coverage values before mapping.'),

(17, 'sos_authorizations', 'calling_month', 'sos_call_month', 'single_fk',
 'USER-DEFINED', 'sos_call_month', NULL, 'YES',
 'ref_sos_calling_month', false,
 ARRAY['v_sos_authorizations_extended','v_sos_authorizations_with_calculated_revenue','v_program_connects_by_month'],
 'pending', 'No ref table yet — create ref_sos_calling_month. Batch with calling_year (#18).'),

(18, 'sos_authorizations', 'calling_year', 'sos_calling_year', 'single_fk',
 'USER-DEFINED', 'sos_calling_year', NULL, 'YES',
 'ref_sos_calling_year', true,
 ARRAY['v_sos_authorizations_extended','v_sos_authorizations_with_calculated_revenue','v_program_connects_by_month'],
 'pending', 'ref_sos_calling_year already exists. Batch with #17.'),

-- PRIORITY 7 — contacts & profiles
(19, 'contacts', 'verification_needed', 'verification_status', 'single_fk',
 'USER-DEFINED', 'verification_status', NULL, 'YES',
 'ref_verification_status', true,
 ARRAY['v_full_contact'],
 'pending', 'ref_verification_status already exists. v_full_contact must be rewritten.'),

(20, 'profiles', 'department', 'Departments', 'single_fk',
 'USER-DEFINED', 'Departments', NULL, 'YES',
 'ref_departments', true,
 ARRAY['v_my_internal_profile'],
 'pending', 'ref_departments exists. Enum type name has capital D — watch cast syntax carefully.'),

(21, 'profiles', 'user_type', 'user_type', 'single_fk',
 'USER-DEFINED', 'user_type', NULL, 'YES',
 'ref_user_type', false,
 ARRAY['v_my_internal_profile'],
 'pending', 'No ref table yet — create ref_user_type.'),

-- PRIORITY 8 — hh_prospect_customers
(22, 'hh_prospect_customers', 'contact_source', 'hh_contact_source_enum', 'single_fk',
 'USER-DEFINED', 'hh_contact_source_enum', NULL, 'YES',
 'ref_hh_contact_source_enum', true,
 ARRAY['v_harvesthub_prospect_customers_datagrid'],
 'pending', 'ref_hh_contact_source_enum already exists.'),

(23, 'hh_prospect_customers', 'product_interest', 'hh_product_interest_enum', 'single_fk',
 'USER-DEFINED', 'hh_product_interest_enum', NULL, 'YES',
 'ref_hh_product_interest_enum', false,
 ARRAY['v_harvesthub_prospect_customers_datagrid'],
 'pending', 'IMPORTANT: existing ref table has a tab character in its name (ref_\thh_product_interest_enum) — rename it to ref_hh_product_interest_enum as part of this migration.'),

(24, 'hh_prospect_customers', 'customer_inquiry_source', 'hh_customer_inquiry_source', 'single_fk',
 'USER-DEFINED', 'hh_customer_inquiry_source', NULL, 'YES',
 'ref_hh_customer_inquiry_source', false,
 ARRAY['v_harvesthub_prospect_customers_datagrid'],
 'pending', 'No ref table yet — create ref_hh_customer_inquiry_source.'),

-- PRIORITY 9 — hh_community_experts / hh_account_experts
(25, 'hh_community_experts', 'status', 'hh_community_expert_status_enum', 'single_fk',
 'USER-DEFINED', 'hh_community_expert_status_enum', '''Form Submitted - Pending Approval''::hh_community_expert_status_enum', 'YES',
 'ref_hh_community_expert_status_enum', false,
 NULL,
 'pending', 'No ref table yet — create. Has DEFAULT. Shared with hh_account_experts.status (#26) — migrate both in one transaction.'),

(26, 'hh_account_experts', 'status', 'hh_community_expert_status_enum', 'single_fk',
 'USER-DEFINED', 'hh_community_expert_status_enum', '''Form Submitted - Pending Approval''::hh_community_expert_status_enum', 'YES',
 'ref_hh_community_expert_status_enum', false,
 NULL,
 'pending', 'Shares enum with hh_community_experts.status — same ref table. Migrate after #25.'),

-- PRIORITY 10 — hh_contributions & hh_licenses
(27, 'hh_contributions', 'validation_status', 'hh_validation_status_enum', 'single_fk',
 'USER-DEFINED', 'hh_validation_status_enum', '''Pending Review''::hh_validation_status_enum', 'YES',
 'ref_hh_validation_status_enum', false,
 NULL,
 'pending', 'No ref table yet. Has DEFAULT — create ref_hh_validation_status_enum.'),

(28, 'hh_licenses', 'product_status', 'hh_license_status_enum', 'single_fk',
 'USER-DEFINED', 'hh_license_status_enum', '''Active Product''::hh_license_status_enum', 'YES',
 'ref_hh_license_status_enum', false,
 NULL,
 'pending', 'No ref table yet. Has DEFAULT — create ref_hh_license_status_enum.'),

-- PRIORITY 11 — junction tables with enum columns
(29, 'jt_brand_events', 'attendance_status', 'attendance_status_enum', 'single_fk',
 'USER-DEFINED', 'attendance_status_enum', NULL, 'YES',
 'ref_attendance_status_enum', true,
 NULL,
 'pending', 'ref_attendance_status_enum already exists.'),

(30, 'jt_associated_skus', 'sku_deal_status', 'sku_deal_status', 'single_fk',
 'USER-DEFINED', 'sku_deal_status', NULL, 'YES',
 'ref_sku_deal_status', false,
 NULL,
 'pending', 'No ref table yet. Shared with sku_placements.sku_status (#31) — create ref once, apply to both.'),

(31, 'sku_placements', 'sku_status', 'sku_deal_status', 'single_fk',
 'USER-DEFINED', 'sku_deal_status', NULL, 'YES',
 'ref_sku_deal_status', false,
 NULL,
 'pending', 'Shares enum with jt_associated_skus.sku_deal_status — reuse ref table from #30.'),

-- PRIORITY 12 — accounts
(32, 'accounts', 'country', 'Country', 'single_fk',
 'USER-DEFINED', 'Country', NULL, 'YES',
 'ref_country', true,
 ARRAY['v_completed_demos'],
 'pending', 'ref_country already exists. Enum type name has capital C — watch cast syntax. v_completed_demos references this.'),

-- PRIORITY 13 — brand_promotions
(33, 'brand_promotions', 'submission_status', 'promo_submissinon_status', 'single_fk',
 'USER-DEFINED', 'promo_submissinon_status', '''Requested''::promo_submissinon_status', 'YES',
 'ref_promo_submission_status', false,
 ARRAY['v_brand_promotions_with_skus','v_brand_promo_requests_with_skus'],
 'pending', 'Typo in enum name: promo_submissinon_status (double n). Create ref with corrected name ref_promo_submission_status. Has DEFAULT.'),

(34, 'brand_promotions', 'brand_approval', 'brand_promo_approval', 'single_fk',
 'USER-DEFINED', 'brand_promo_approval (delete)', NULL, 'YES',
 'ref_brand_promo_approval', false,
 ARRAY['v_brand_promotions_with_skus','v_brand_promo_requests_with_skus'],
 'blocked', 'Enum udt_name tagged "(delete)" — confirm with team whether to migrate or drop entirely. Do not proceed until decision is made.'),

-- PRIORITY 14 — team_member_guide & notifications
(35, 'team_member_guide', 'status', 'employee_status_enum', 'single_fk',
 'USER-DEFINED', 'employee_status_enum', NULL, 'YES',
 'ref_employee_status_enum', false,
 ARRAY['v_my_internal_profile'],
 'pending', 'No ref table yet — create ref_employee_status_enum.'),

(36, 'notifications', 'type', 'notification_type', 'single_fk',
 'USER-DEFINED', 'notification_type', NULL, 'NO',
 'ref_notification_type', false,
 NULL,
 'pending', 'Column is NOT NULL — safe mode required, temp column backfill, no nulls allowed post-migration.'),

(37, 'notifications', 'status', 'notification_status', 'single_fk',
 'USER-DEFINED', 'notification_status', '''unread''::notification_status', 'NO',
 'ref_notification_status', false,
 NULL,
 'pending', 'Column is NOT NULL with DEFAULT ''unread'' — update DEFAULT to UUID post-migration. Safe mode required.'),

-- PRIORITY 15 — spec_price_sheet (batch all certification cols)
(38, 'spec_price_sheet', 'item_status', 'item_status', 'single_fk',
 'USER-DEFINED', 'item_status', NULL, 'YES',
 'ref_item_status', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'No ref table yet. Shared with principal_list_product_specs.item_status — create once, apply to both.'),

(39, 'spec_price_sheet', 'uom', 'uom_enum', 'single_fk',
 'USER-DEFINED', 'uom_enum', NULL, 'YES',
 'ref_uom_enum', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'No ref table yet. Shared with principal_list_product_specs.uom.'),

(40, 'spec_price_sheet', 'item_temp_reqs', 'transport_enum', 'single_fk',
 'USER-DEFINED', 'transport_enum', NULL, 'YES',
 'ref_transport_enum', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'No ref table yet. Shared with principal_list_product_specs.transport.'),

(41, 'spec_price_sheet', 'best_by_date_indicated', 'best_by_enum', 'single_fk',
 'USER-DEFINED', 'best_by_enum', NULL, 'YES',
 'ref_best_by_enum', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'No ref table yet — create ref_best_by_enum.'),

(42, 'spec_price_sheet', 'organic', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'specs_certification_options shared across 12 cols in spec_price_sheet + 9 in principal_list_product_specs. Create ONE ref_specs_certification_options, batch ALL certification columns together in a single transaction.'),

(43, 'spec_price_sheet', 'non_gmo', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

(44, 'spec_price_sheet', 'gluten_free', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42. Note: spec_price_sheet has duplicate cols (gluten_free + gluten_free_status) — dedup during migration.'),

(45, 'spec_price_sheet', 'kosher', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

(46, 'spec_price_sheet', 'vegan', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

(47, 'spec_price_sheet', 'dairy_free', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

(48, 'spec_price_sheet', 'nut_free', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

(49, 'spec_price_sheet', 'soy_free', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

(50, 'spec_price_sheet', 'sugar_free', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

(51, 'spec_price_sheet', 'vegetarian', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

(52, 'spec_price_sheet', 'wheat_free', 'specs_certification_options', 'single_fk',
 'USER-DEFINED', 'specs_certification_options', NULL, 'YES',
 'ref_specs_certification_options', false,
 ARRAY['v_spec_price_sheet'],
 'pending', 'Batch with #42.'),

-- PRIORITY 16 — brand_focus_assignments
(53, 'brand_focus_assignments', 'focus_month', 'focus_month_enum', 'single_fk',
 'USER-DEFINED', 'focus_month_enum', NULL, 'YES',
 'ref_focus_month_enum', false,
 ARRAY['v_brands_focus'],
 'pending', 'No ref table yet — create ref_focus_month_enum. v_brands_focus must be rewritten.'),

-- PRIORITY 17 — sample_shipment_tracking
(54, 'sample_shipment_tracking', 'status', 'sample_status', 'single_fk',
 'USER-DEFINED', 'sample_status', NULL, 'YES',
 'ref_sample_status', false,
 NULL,
 'pending', 'No ref table yet — create ref_sample_status.'),

(55, 'sample_shipment_tracking', 'carrier', 'ship_carrier', 'single_fk',
 'USER-DEFINED', 'ship_carrier', NULL, 'YES',
 'ref_ship_carrier', false,
 NULL,
 'pending', 'No ref table yet — create ref_ship_carrier.'),

-- PRIORITY 18 — SKIPPED (deprecated tables/enums)
(56, 'activity_tracker', 'connect_stage', 'connect_enum', 'single_fk',
 'USER-DEFINED', 'connect_enum (deprecated?)', NULL, 'YES',
 'ref_connect_enum', false,
 NULL,
 'skipped', 'Enum tagged deprecated. Skip unless team confirms it is still in use.'),

(57, 'brand_tasks', 'status', 'brand_task_status', 'single_fk',
 'USER-DEFINED', 'brand_task_status', NULL, 'YES',
 'ref_brand_task_status', false,
 NULL,
 'pending', 'No ref table yet — create ref_brand_task_status.'),

(58, 'brand_tasks', 'source', 'brand_task_source', 'single_fk',
 'USER-DEFINED', 'brand_task_source', NULL, 'NO',
 'ref_brand_task_source', false,
 NULL,
 'pending', 'Column is NOT NULL — safe mode required.'),

(59, 'brands', 'principal_list_status', 'Principal List Status', 'single_fk',
 'USER-DEFINED', 'Principal List Status', NULL, 'YES',
 'ref_principal_list_status', false,
 ARRAY['v_brands_view'],
 'pending', 'No ref table yet. Enum name has spaces and capitals — watch cast syntax.'),

(60, 'brands', 'demo_customer_type', 'Demo_special_customer_enum', 'single_fk',
 'USER-DEFINED', 'Demo_special_customer_enum', NULL, 'YES',
 'ref_demo_special_customer_enum', false,
 ARRAY['v_brands_view'],
 'pending', 'No ref table yet.'),

(61, 'events', 'goodnow_participation', 'GoodNow Event Participation Status', 'single_fk',
 'USER-DEFINED', 'GoodNow Event Participation Status', NULL, 'YES',
 'ref_goodnow_event_participation_status', true,
 ARRAY['events_detailed_view'],
 'pending', 'ref_goodnow_event_participation_status exists (note space in existing name — verify exact table name). events_detailed_view must be rewritten.');
;