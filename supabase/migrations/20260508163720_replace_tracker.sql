
TRUNCATE public.ref_migration_tracker;

INSERT INTO public.ref_migration_tracker (
  priority_rank, source_table, source_column, enum_type_name, migration_pattern,
  before_data_type, before_udt_name, before_column_default, before_is_nullable,
  ref_table_name, ref_table_existed_before,
  views_affected, status, notes
) VALUES

-- ============================================================
-- PRIORITY 1 — hh_customers (4 cols, all ref tables exist, batch together)
-- ============================================================
(1,  'hh_customers', 'role',           'hh_user_role_enum',      'single_fk', 'USER-DEFINED', 'hh_user_role_enum',      NULL,                                  'YES', 'ref_hh_user_role_enum',      true,  ARRAY['v_harvesthub_customer_datagrid'], 'pending', 'ref exists. Batch all 4 hh_customers cols in one transaction.'),
(2,  'hh_customers', 'billing_terms',  'hh_billing_terms_enum',  'single_fk', 'USER-DEFINED', 'hh_billing_terms_enum',  NULL,                                  'YES', 'ref_hh_billing_terms_enum',  true,  ARRAY['v_harvesthub_customer_datagrid'], 'pending', 'ref exists. Batch with #1.'),
(3,  'hh_customers', 'payment_status', 'hh_payment_status_enum', 'single_fk', 'USER-DEFINED', 'hh_payment_status_enum', NULL,                                  'YES', 'ref_hh_payment_status_enum', true,  ARRAY['v_harvesthub_customer_datagrid'], 'pending', 'ref exists. Batch with #1.'),

-- ============================================================
-- PRIORITY 2 — hh_deals
-- ============================================================
(4,  'hh_deals', 'stage',    'hh_deal_stage_enum', 'single_fk', 'USER-DEFINED', 'hh_deal_stage_enum', '''Target''::hh_deal_stage_enum', 'YES', 'ref_deal_stage',    true,  NULL, 'pending', 'ref_deal_stage exists. Has DEFAULT — update to UUID post-migration.'),
(5,  'hh_deals', 'priority', 'priority_enum',       'single_fk', 'USER-DEFINED', 'priority_enum',       NULL,                            'YES', 'ref_priority_enum', false, NULL, 'pending', 'No ref table yet — create ref_priority_enum. Shared with task_pipeline.priority (#15). Create once, apply to both.'),

-- ============================================================
-- PRIORITY 3 — task_pipeline (4 cols)
-- ============================================================
(6,  'task_pipeline', 'task_type',   'task_type_enum',    'single_fk', 'USER-DEFINED', 'task_type_enum',    NULL,                         'NO',  'ref_task_type_enum',    true,  ARRAY['v_task_pipeline_with_assignees'], 'pending', 'ref exists. Column is NOT NULL — safe mode, temp column, no nulls.'),
(7,  'task_pipeline', 'status',      'kanban_status_enum','single_fk', 'USER-DEFINED', 'kanban_status_enum',NULL,                         'YES', 'ref_kanban_status_enum',false, ARRAY['v_task_pipeline_with_assignees'], 'pending', 'No ref yet — create ref_kanban_status_enum.'),
(8,  'task_pipeline', 'source_type', 'source_type_enum',  'single_fk', 'USER-DEFINED', 'source_type_enum',  '''manual''::source_type_enum','YES','ref_source_type_enum',  false, ARRAY['v_task_pipeline_with_assignees'], 'pending', 'No ref yet — create ref_source_type_enum. Has DEFAULT ''manual''.'),
(9,  'task_pipeline', 'priority',    'priority_enum',     'single_fk', 'USER-DEFINED', 'priority_enum',     '''Medium''::priority_enum',  'YES', 'ref_priority_enum',     false, ARRAY['v_task_pipeline_with_assignees'], 'pending', 'Shared with hh_deals.priority (#5) — reuse same ref. Has DEFAULT ''Medium''.'),

-- ============================================================
-- PRIORITY 4 — activity_tracker
-- ============================================================
(10, 'activity_tracker', 'activity_type', 'activity_type_enum', 'single_fk', 'USER-DEFINED', 'activity_type_enum', '''GNF Deal''::activity_type_enum', 'YES', 'ref_activity_type_enum', false, ARRAY['activity_tracker_details_view'], 'pending', 'No ref yet. Has DEFAULT. auth_rls_initplan lint on this table — fix RLS during migration window.'),

-- ============================================================
-- PRIORITY 5 — demos (demo_request_type also lives here per your list)
-- ============================================================
(11, 'demos', 'demo_status',       'demo_status_enum',       'single_fk', 'USER-DEFINED', 'demo_status_enum',       '''Requested''::demo_status_enum', 'YES', 'ref_demo_status_enum',       true,  ARRAY['v_completed_demos','v_demo_calendar','v_scheduled_demos'], 'pending', 'ref exists. 3 views affected. Has DEFAULT. Batch both demos cols.'),
(12, 'demos', 'demo_request_type', 'demo_request_type_enum', 'single_fk', 'USER-DEFINED', 'demo_request_type_enum', NULL,                              'YES', 'ref_demo_request_type_enum', false, ARRAY['v_completed_demos','v_demo_calendar','v_scheduled_demos'], 'pending', 'No ref yet — create ref_demo_request_type_enum. Same 3 views. Batch with #11.'),

-- ============================================================
-- PRIORITY 6 — sos_authorizations (4 cols)
-- ============================================================
(13, 'sos_authorizations', 'program_status', 'program_status_type', 'single_fk', 'USER-DEFINED', 'program_status_type', NULL, 'YES', 'ref_sos_program_type',   true,  ARRAY['v_sos_authorizations_extended','v_sos_authorizations_with_calculated_revenue','v_program_connects_by_month'], 'pending', 'ref exists. 3 views including revenue view. Batch all 4 sos cols.'),
(14, 'sos_authorizations', 'region',         'region',              'single_fk', 'USER-DEFINED', 'region',              NULL, 'YES', 'ref_coverage',           true,  ARRAY['v_sos_authorizations_extended','v_sos_authorizations_with_calculated_revenue'],                            'pending', 'ref_coverage exists — verify region enum values match coverage values before mapping.'),
(15, 'sos_authorizations', 'calling_month',  'sos_call_month',      'single_fk', 'USER-DEFINED', 'sos_call_month',      NULL, 'YES', 'ref_sos_calling_month',  false, ARRAY['v_sos_authorizations_extended','v_sos_authorizations_with_calculated_revenue','v_program_connects_by_month'], 'pending', 'No ref yet — create ref_sos_calling_month. Batch with calling_year.'),
(16, 'sos_authorizations', 'calling_year',   'sos_calling_year',    'single_fk', 'USER-DEFINED', 'sos_calling_year',    NULL, 'YES', 'ref_sos_calling_year',   true,  ARRAY['v_sos_authorizations_extended','v_sos_authorizations_with_calculated_revenue','v_program_connects_by_month'], 'pending', 'ref exists. Batch with #15.'),

-- ============================================================
-- PRIORITY 7 — accounts
-- ============================================================
(17, 'accounts', 'state',           'states_enum',     'single_fk',     'USER-DEFINED', 'states_enum',      NULL,                   'YES', 'ref_states_enum',   false, ARRAY['v_completed_demos','v_full_contact'],   'pending', 'No ref yet — create ref_states_enum. Views reference as store_state and primary_account_state.'),
(18, 'accounts', 'country',         'Country',         'single_fk',     'USER-DEFINED', 'Country',          NULL,                   'YES', 'ref_country',       true,  ARRAY['v_completed_demos'],                   'pending', 'ref_country exists. Capital C in type name — watch cast syntax.'),
(19, 'accounts', 'primary_region',  'region',          'junction_table','ARRAY',        '_region',          'ARRAY[]::region[]',    'YES', 'ref_coverage',      true,  ARRAY['v_brand_distribution_grid'],           'pending', 'Array col → junction table pattern. ref_coverage exists. Has DEFAULT empty array. v_brand_distribution_grid uses distributor_region.'),
(20, 'accounts', 'call_preferences','Call Preferences','junction_table','ARRAY',        '_Call Preferences',NULL,                   'YES', 'ref_call_preferences',false, NULL,                                         'pending', 'Array col → junction table. No ref yet — create ref_call_preferences.'),

-- ============================================================
-- PRIORITY 8 — brand_contacts_table
-- ============================================================
(21, 'brand_contacts_table', 'contact_tags', 'Brand Contact Tags', 'junction_table', 'ARRAY', '_Brand Contact Tags', NULL, 'YES', 'ref_brand_contact_tags', false, ARRAY['v_brand_contacts'], 'pending', 'Array col → junction table. No ref yet — create ref_brand_contact_tags. Actual table name is brand_contacts_table (not brand_contacts).'),

-- ============================================================
-- PRIORITY 9 — brand_distribution_grid
-- ============================================================
(22, 'brand_distribution_grid', 'distribution_status', 'Distribution Status', 'single_fk', 'USER-DEFINED', 'Distribution Status',  NULL, 'YES', 'ref_distribution_status',  false, ARRAY['v_brand_distribution_grid','v_deal_distribution'], 'pending', 'No ref yet — create ref_distribution_status. Name has spaces — watch cast syntax.'),
(23, 'brand_distribution_grid', 'fulfillment_method',  'Fulfillment Method',  'single_fk', 'USER-DEFINED', 'Fulfillment Method ', NULL, 'YES', 'ref_fulfillment_method',   false, NULL,                                                      'pending', 'No ref yet — create ref_fulfillment_method. NOTE: udt_name has trailing space (''Fulfillment Method '') — use exact name in cast.'),

-- ============================================================
-- PRIORITY 10 — brand_focus_assignments
-- ============================================================
(24, 'brand_focus_assignments', 'focus_month', 'focus_month_enum', 'single_fk', 'USER-DEFINED', 'focus_month_enum', NULL, 'YES', 'ref_focus_month_enum', false, ARRAY['v_brands_focus'], 'pending', 'No ref yet — create ref_focus_month_enum.'),

-- ============================================================
-- PRIORITY 11 — brand_promo_requests (Deprecated) & brand_promotions
-- ============================================================
(25, 'brand_promo_requests (Deprecated)', 'effective_promo_month', 'Effective Promo Month',    'single_fk', 'USER-DEFINED', 'Effective Promo Month',    NULL,                              'YES', 'ref_effective_promo_month',  false, ARRAY['v_brand_promo_requests_with_skus'], 'pending', 'Deprecated table but still in use per your list. Shared enum with master_promo_data (#31). Create ref once.'),
(26, 'brand_promotions',                  'promo_year',            'Promo Year',               'single_fk', 'USER-DEFINED', 'Promo Year',               NULL,                              'YES', 'ref_promo_year',             false, ARRAY['v_brand_promo_requests_with_skus'], 'pending', 'No ref yet. Shared with master_promo_data.effective_promo_year (#32) and brand_promo_requests (#25 area). Create once.'),
(27, 'brand_promotions',                  'submission_status',     'promo_submissinon_status', 'single_fk', 'USER-DEFINED', 'promo_submissinon_status', '''Requested''::promo_submissinon_status','YES','ref_promo_submission_status',false,ARRAY['v_brand_promo_requests_with_skus','v_brand_promotions_with_skus'],'pending','Typo in enum name (double n). Create ref with corrected name. Has DEFAULT.'),
(28, 'brand_promotions',                  'promo_quarter',         'Quarter',                  'single_fk', 'USER-DEFINED', 'Quarter',                  NULL,                              'YES', 'ref_quarter',                false, ARRAY['v_brand_promotions_with_skus'],     'pending', 'No ref yet — create ref_quarter.'),

-- ============================================================
-- PRIORITY 12 — brand_tasks
-- ============================================================
(29, 'brand_tasks', 'source', 'brand_task_source', 'single_fk', 'USER-DEFINED', 'brand_task_source', NULL, 'NO',  'ref_brand_task_source', false, NULL, 'pending', 'No ref yet. Column is NOT NULL — safe mode required.'),
(30, 'brand_tasks', 'status', 'brand_task_status', 'single_fk', 'USER-DEFINED', 'brand_task_status', NULL, 'YES', 'ref_brand_task_status', false, NULL, 'pending', 'No ref yet — create ref_brand_task_status.'),

-- ============================================================
-- PRIORITY 13 — brands
-- ============================================================
(31, 'brands', 'principal_list_status', 'Principal List Status',    'single_fk',     'USER-DEFINED', 'Principal List Status',    NULL, 'YES', 'ref_principal_list_status',    false, ARRAY['v_brands_view'], 'pending', 'No ref yet. Name has spaces — watch cast syntax.'),
(32, 'brands', 'new_item_tag_enum',     'new_item_tag_enum',        'single_fk',     'USER-DEFINED', 'new_item_tag_enum',        NULL, 'YES', 'ref_new_item_tag_enum',        false, NULL,                  'pending', 'No ref yet — create ref_new_item_tag_enum.'),
(33, 'brands', 'demo_customer_type',   'Demo_special_customer_enum','single_fk',     'USER-DEFINED', 'Demo_special_customer_enum',NULL,'YES', 'ref_demo_special_customer_enum',false,ARRAY['v_brands_view'], 'pending', 'No ref yet.'),
(34, 'brands', 'private_label_bulk_and__or_food_service', 'sales_channel', 'junction_table', 'ARRAY', '_sales_channel', NULL, 'YES', 'ref_sales_channel', false, ARRAY['v_brands_view'], 'pending', 'Array col → junction table. No ref yet — create ref_sales_channel. Column name is private_label_bulk_and__or_food_service.'),

-- ============================================================
-- PRIORITY 14 — hh_community_experts & hh_account_experts
-- ============================================================
(35, 'hh_community_experts', 'status', 'hh_community_expert_status_enum', 'single_fk', 'USER-DEFINED', 'hh_community_expert_status_enum', '''Form Submitted - Pending Approval''::hh_community_expert_status_enum', 'YES', 'ref_hh_community_expert_status_enum', false, NULL, 'pending', 'No ref yet. Has DEFAULT. Shared with hh_account_experts.status (#36) — create once, apply to both.'),
(36, 'hh_account_experts',  'status', 'hh_community_expert_status_enum', 'single_fk', 'USER-DEFINED', 'hh_community_expert_status_enum', '''Form Submitted - Pending Approval''::hh_community_expert_status_enum', 'YES', 'ref_hh_community_expert_status_enum', false, NULL, 'pending', 'Shares enum with hh_community_experts.status (#35) — reuse same ref. Migrate after #35.'),

-- ============================================================
-- PRIORITY 15 — hh_contributions
-- ============================================================
(37, 'hh_contributions', 'validation_status', 'hh_validation_status_enum', 'single_fk', 'USER-DEFINED', 'hh_validation_status_enum', '''Pending Review''::hh_validation_status_enum', 'YES', 'ref_hh_validation_status_enum', false, NULL, 'pending', 'No ref yet. Has DEFAULT.'),

-- ============================================================
-- PRIORITY 16 — jt_brand_events
-- ============================================================
(38, 'jt_brand_events', 'attendance_status', 'attendance_status_enum', 'single_fk', 'USER-DEFINED', 'attendance_status_enum', NULL, 'YES', 'ref_attendance_status_enum', true, NULL, 'pending', 'ref_attendance_status_enum already exists.'),

-- ============================================================
-- PRIORITY 17 — master_promo_data
-- ============================================================
(39, 'master_promo_data', 'effective_promo_month', 'Effective Promo Month', 'single_fk', 'USER-DEFINED', 'Effective Promo Month', NULL, 'YES', 'ref_effective_promo_month', false, NULL, 'pending', 'Shared enum with brand_promo_requests (#25) — create ref once, reuse.'),
(40, 'master_promo_data', 'effective_promo_year',  'Promo Year',            'single_fk', 'USER-DEFINED', 'Promo Year',            NULL, 'YES', 'ref_promo_year',            false, NULL, 'pending', 'Shared with brand_promotions.promo_year (#26).'),

-- ============================================================
-- PRIORITY 18 — notifications
-- ============================================================
(41, 'notifications', 'type',   'notification_type',   'single_fk', 'USER-DEFINED', 'notification_type',   NULL,                        'NO',  'ref_notification_type',   false, NULL, 'pending', 'NOT NULL column — safe mode, no nulls allowed post-migration.'),
(42, 'notifications', 'status', 'notification_status', 'single_fk', 'USER-DEFINED', 'notification_status', '''unread''::notification_status','NO','ref_notification_status',false, NULL, 'pending', 'NOT NULL with DEFAULT ''unread'' — update DEFAULT to UUID post-migration.'),

-- ============================================================
-- PRIORITY 19 — profiles
-- ============================================================
(43, 'profiles', 'department', 'Departments', 'single_fk', 'USER-DEFINED', 'Departments', NULL, 'YES', 'ref_departments', true, ARRAY['v_my_internal_profile'], 'pending', 'ref_departments exists. Capital D in type name.'),

-- ============================================================
-- PRIORITY 20 — sample_shipment_tracking
-- ============================================================
(44, 'sample_shipment_tracking', 'status',  'sample_status', 'single_fk', 'USER-DEFINED', 'sample_status', NULL, 'YES', 'ref_sample_status', false, NULL, 'pending', 'No ref yet — create ref_sample_status.'),
(45, 'sample_shipment_tracking', 'carrier', 'ship_carrier',  'single_fk', 'USER-DEFINED', 'ship_carrier',  NULL, 'YES', 'ref_ship_carrier',  false, NULL, 'pending', 'No ref yet — create ref_ship_carrier.'),

-- ============================================================
-- PRIORITY 21 — sku_placements
-- ============================================================
(46, 'sku_placements', 'sku_status', 'sku_deal_status', 'single_fk', 'USER-DEFINED', 'sku_deal_status', NULL, 'YES', 'ref_sku_deal_status', false, NULL, 'pending', 'No ref yet — create ref_sku_deal_status.'),

-- ============================================================
-- PRIORITY 22 — spec_price_sheet (batch all together)
-- ============================================================
(47, 'spec_price_sheet', 'item_status',          'item_status',                 'single_fk', 'USER-DEFINED', 'item_status',                 NULL, 'YES', 'ref_item_status',                 false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'No ref yet. Shared with principal_list_product_specs. Batch all spec_price_sheet cols.'),
(48, 'spec_price_sheet', 'item_temp_reqs',        'transport_enum',              'single_fk', 'USER-DEFINED', 'transport_enum',              NULL, 'YES', 'ref_transport_enum',              false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Shared with principal_list_product_specs.transport.'),
(49, 'spec_price_sheet', 'uom',                   'uom_enum',                    'single_fk', 'USER-DEFINED', 'uom_enum',                    NULL, 'YES', 'ref_uom_enum',                    false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Shared with principal_list_product_specs.uom.'),
(50, 'spec_price_sheet', 'best_by_date_indicated','best_by_enum',                'single_fk', 'USER-DEFINED', 'best_by_enum',                NULL, 'YES', 'ref_best_by_enum',                false, ARRAY['v_spec_price_sheet'],                                'pending', 'No ref yet.'),
(51, 'spec_price_sheet', 'organic',               'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'specs_certification_options used across 12+ cols in spec_price_sheet + 11 in principal_list_product_specs. Create ONE ref, batch ALL cert cols together. Note: spec_price_sheet has duplicate *_status cols (gluten_free_status, kosher_status etc.) — dedup during migration.'),
(52, 'spec_price_sheet', 'non_gmo',               'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(53, 'spec_price_sheet', 'gluten_free',            'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(54, 'spec_price_sheet', 'kosher',                 'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(55, 'spec_price_sheet', 'vegan',                  'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(56, 'spec_price_sheet', 'dairy_free',             'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(57, 'spec_price_sheet', 'nut_free',               'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(58, 'spec_price_sheet', 'soy_free',               'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(59, 'spec_price_sheet', 'sugar_free',             'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(60, 'spec_price_sheet', 'vegetarian',             'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),
(61, 'spec_price_sheet', 'wheat_free',             'specs_certification_options', 'single_fk', 'USER-DEFINED', 'specs_certification_options', NULL, 'YES', 'ref_specs_certification_options', false, ARRAY['v_spec_price_sheet','principal_list_product_specs'], 'pending', 'Batch with #51.'),

-- ============================================================
-- PRIORITY 23 — team_member_guide
-- ============================================================
(62, 'team_member_guide', 'status', 'employee_status_enum', 'single_fk', 'USER-DEFINED', 'employee_status_enum', NULL, 'YES', 'ref_employee_status_enum', false, ARRAY['v_my_internal_profile'], 'pending', 'No ref yet — create ref_employee_status_enum.'),

-- ============================================================
-- SKIPPED per your list (Keep As Enum = No)
-- ============================================================
(100, 'accounts',              'flag_for_attention',     'flag_for_attention_enum',            'junction_table', 'ARRAY',        '_flag_for_attention_enum',            NULL, 'YES', 'ref_account_flag_for_attention_enum', true,  NULL, 'skipped', 'Keep as enum per list.'),
(101, 'accounts',              'industry_tag_column',    'industry_tag',                        'junction_table', 'ARRAY',        '_industry_tag',                       NULL, 'YES', 'ref_industry_tag',                   false, NULL, 'skipped', 'Keep as enum per list.'),
(102, 'accounts',              'default_status',         'default_status_enum (deprecated?)',   'single_fk',      'USER-DEFINED', 'default_status_enum (deprecated?)',   NULL, 'YES', 'n/a',                                false, NULL, 'skipped', 'Deprecated — no action.'),
(103, 'accounts',              'account_type',           'account_type',                        'single_fk',      'USER-DEFINED', 'account_type',                        NULL, 'YES', 'ref_account_type',                   true,  NULL, 'skipped', 'Keep as enum per list.'),
(104, 'activity_tracker',      'connect_stage',          'connect_enum (deprecated?)',           'single_fk',      'USER-DEFINED', 'connect_enum (deprecated?)',          NULL, 'YES', 'n/a',                                false, NULL, 'skipped', 'Deprecated — no action.'),
(105, 'activity_tracker',      'sku_placement_type',     'placement_type_enum',                 'single_fk',      'USER-DEFINED', 'placement_type_enum',                 '''Team-led''::placement_type_enum', 'YES', 'n/a', false, NULL, 'skipped', 'Table listed as (blank) with No action per list.'),
(106, 'brand_task_templates',  'applies_to_services',    'Active Services',                     'junction_table', 'ARRAY',        '_Active Services',                    NULL, 'YES', 'ref_active_services',                true,  NULL, 'skipped', 'Keep as enum per list.'),
(107, 'brands',                'status',                 'Brand Status',                        'junction_table', 'ARRAY',        '_Brand Status',                       NULL, 'YES', 'ref_brand_status',                   true,  NULL, 'skipped', 'Keep as enum per list.'),
(108, 'brands',                'services',               'Active Services',                     'junction_table', 'ARRAY',        '_Active Services',                    NULL, 'YES', 'ref_active_services',                true,  NULL, 'skipped', 'Keep as enum per list.'),
(109, 'brands',                'coverage',               'Coverage',                            'junction_table', 'ARRAY',        '_Coverage',                           NULL, 'YES', 'ref_coverage',                       true,  NULL, 'skipped', 'Keep as enum per list.'),
(110, 'brands',                'category_for_principal_list','category_enum (deprecated?)',     'junction_table', 'ARRAY',        '_category_enum (deprecated?)',        NULL, 'YES', 'n/a',                                false, NULL, 'skipped', 'Deprecated — no action.'),
(111, 'brands',                'product_sub_category_for_principal_list','product_subcategory_enum (principal list)','junction_table','ARRAY','_product_subcategory_enum (principal list)',NULL,'YES','ref_product_subcategory_enum',false,NULL,'skipped','Keep as enum per list.'),
(112, 'company_announcements', 'audience',               'Audience',                            'junction_table', 'ARRAY',        '_Audience',                           NULL, 'YES', 'n/a',                                false, NULL, 'skipped', 'Keep as enum per list.'),
(113, 'company_announcements', 'announcement_tags',      'Announcement Tag',                    'junction_table', 'ARRAY',        '_Announcement Tag',                   NULL, 'YES', 'ref_announcement_tag',               true,  NULL, 'skipped', 'Keep as enum per list.'),
(114, 'contacts',              'verification_needed',    'verification_status',                 'junction_table', 'ARRAY',        'verification_status',                 NULL, 'YES', 'ref_verification_status',            true,  NULL, 'skipped', 'Keep as enum per list. NOTE: schema shows this as USER-DEFINED single col — but list says Array/No. Confirm with team.'),
(115, 'contacts',              'department_tags',        'Department Tags (Deprecated) RH',     'junction_table', 'ARRAY',        '_Department Tags (Deprecated) RH',   NULL, 'YES', 'n/a',                                false, NULL, 'skipped', 'Deprecated — no action.'),
(116, 'contacts',              'no_contact_details',     'No Contact Details',                  'junction_table', 'ARRAY',        '_No Contact Details',                 NULL, 'YES', 'ref_no_contact_details',             true,  NULL, 'skipped', 'Keep as enum per list.'),
(117, 'events',                'goodnow_participation',  'GoodNow Event Participation Status',  'single_fk',      'USER-DEFINED', 'GoodNow Event Participation Status',  NULL, 'YES', 'ref_goodnow_event _participation_status', true, ARRAY['events_detailed_view'], 'skipped', 'Keep as enum per list.'),
(118, 'hh_account_experts',    'expert_services_offered','hh_expert_services',                  'junction_table', 'ARRAY',        '_hh_expert_services',                 NULL, 'YES', 'ref_hh_expert_services',             true,  NULL, 'skipped', 'Keep as enum per list.'),
(119, 'hh_community_experts',  'services_offered',       'hh_community_expert_services_offered','junction_table', 'ARRAY',        '_hh_community_expert_services_offered',NULL,'YES','ref_hh_community_expert_services_offered',true,NULL,'skipped','Keep as enum per list.'),
(120, 'hh_customers',          'status',                 'hh_customer_status_enum',             'single_fk',      'USER-DEFINED', 'hh_customer_status_enum',             NULL, 'YES', 'ref_hh_customer_status',             true,  ARRAY['v_harvesthub_customer_datagrid','v_hh_customer_activity'], 'skipped', 'Keep as enum per list.'),
(121, 'hh_licenses',           'product_status',         'hh_license_status_enum',              'single_fk',      'USER-DEFINED', 'hh_license_status_enum',              '''Active Product''::hh_license_status_enum','YES','ref_hh_license_status_enum',false,NULL,'skipped','Keep as enum per list.'),
(122, 'master_categories',     'category',               'category_enum (deprecated?)',          'single_fk',      'USER-DEFINED', 'category_enum (deprecated?)',         NULL, 'YES', 'n/a',                                false, NULL, 'skipped', 'Deprecated — no action.'),
(123, 'master_category_reviews','category_review_type',  'Category Review Types (ANNA BROWN)',  'single_fk',      'USER-DEFINED', 'category_review_status_enum (deprecated?)',NULL,'YES','n/a',false,NULL,'skipped','Keep as enum per list.'),
(124, 'team_member_guide',     'department',             'Departments',                          'junction_table', 'ARRAY',        '_Departments',                        NULL, 'YES', 'ref_departments',                    true,  NULL, 'skipped', 'Keep as enum per list (Array pattern, No action).');
;