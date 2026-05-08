create extension if not exists "pg_cron" with schema "pg_catalog";

create extension if not exists "hypopg" with schema "extensions";

create extension if not exists "index_advisor" with schema "extensions";

create extension if not exists "pg_net" with schema "extensions";

create extension if not exists "wrappers" with schema "extensions";

create schema if not exists "airtable";

create schema if not exists "harvest hub";

create extension if not exists "http" with schema "public";

create extension if not exists "pg_trgm" with schema "public";

revoke delete on table "public"."claude_migration_log" from "anon";

revoke insert on table "public"."claude_migration_log" from "anon";

revoke references on table "public"."claude_migration_log" from "anon";

revoke select on table "public"."claude_migration_log" from "anon";

revoke trigger on table "public"."claude_migration_log" from "anon";

revoke truncate on table "public"."claude_migration_log" from "anon";

revoke update on table "public"."claude_migration_log" from "anon";

revoke delete on table "public"."claude_migration_log" from "authenticated";

revoke insert on table "public"."claude_migration_log" from "authenticated";

revoke references on table "public"."claude_migration_log" from "authenticated";

revoke select on table "public"."claude_migration_log" from "authenticated";

revoke trigger on table "public"."claude_migration_log" from "authenticated";

revoke truncate on table "public"."claude_migration_log" from "authenticated";

revoke update on table "public"."claude_migration_log" from "authenticated";

revoke delete on table "public"."claude_migration_log" from "service_role";

revoke insert on table "public"."claude_migration_log" from "service_role";

revoke references on table "public"."claude_migration_log" from "service_role";

revoke select on table "public"."claude_migration_log" from "service_role";

revoke trigger on table "public"."claude_migration_log" from "service_role";

revoke truncate on table "public"."claude_migration_log" from "service_role";

revoke update on table "public"."claude_migration_log" from "service_role";

revoke delete on table "public"."enum_ref_migration_tracker" from "anon";

revoke insert on table "public"."enum_ref_migration_tracker" from "anon";

revoke references on table "public"."enum_ref_migration_tracker" from "anon";

revoke select on table "public"."enum_ref_migration_tracker" from "anon";

revoke trigger on table "public"."enum_ref_migration_tracker" from "anon";

revoke truncate on table "public"."enum_ref_migration_tracker" from "anon";

revoke update on table "public"."enum_ref_migration_tracker" from "anon";

revoke delete on table "public"."enum_ref_migration_tracker" from "authenticated";

revoke insert on table "public"."enum_ref_migration_tracker" from "authenticated";

revoke references on table "public"."enum_ref_migration_tracker" from "authenticated";

revoke select on table "public"."enum_ref_migration_tracker" from "authenticated";

revoke trigger on table "public"."enum_ref_migration_tracker" from "authenticated";

revoke truncate on table "public"."enum_ref_migration_tracker" from "authenticated";

revoke update on table "public"."enum_ref_migration_tracker" from "authenticated";

revoke delete on table "public"."enum_ref_migration_tracker" from "service_role";

revoke insert on table "public"."enum_ref_migration_tracker" from "service_role";

revoke references on table "public"."enum_ref_migration_tracker" from "service_role";

revoke select on table "public"."enum_ref_migration_tracker" from "service_role";

revoke trigger on table "public"."enum_ref_migration_tracker" from "service_role";

revoke truncate on table "public"."enum_ref_migration_tracker" from "service_role";

revoke update on table "public"."enum_ref_migration_tracker" from "service_role";

revoke delete on table "public"."ref_best_by_date_format" from "anon";

revoke insert on table "public"."ref_best_by_date_format" from "anon";

revoke references on table "public"."ref_best_by_date_format" from "anon";

revoke select on table "public"."ref_best_by_date_format" from "anon";

revoke trigger on table "public"."ref_best_by_date_format" from "anon";

revoke truncate on table "public"."ref_best_by_date_format" from "anon";

revoke update on table "public"."ref_best_by_date_format" from "anon";

revoke delete on table "public"."ref_best_by_date_format" from "authenticated";

revoke insert on table "public"."ref_best_by_date_format" from "authenticated";

revoke references on table "public"."ref_best_by_date_format" from "authenticated";

revoke select on table "public"."ref_best_by_date_format" from "authenticated";

revoke trigger on table "public"."ref_best_by_date_format" from "authenticated";

revoke truncate on table "public"."ref_best_by_date_format" from "authenticated";

revoke update on table "public"."ref_best_by_date_format" from "authenticated";

revoke delete on table "public"."ref_best_by_date_format" from "service_role";

revoke insert on table "public"."ref_best_by_date_format" from "service_role";

revoke references on table "public"."ref_best_by_date_format" from "service_role";

revoke select on table "public"."ref_best_by_date_format" from "service_role";

revoke trigger on table "public"."ref_best_by_date_format" from "service_role";

revoke truncate on table "public"."ref_best_by_date_format" from "service_role";

revoke update on table "public"."ref_best_by_date_format" from "service_role";

revoke delete on table "public"."ref_best_by_format" from "anon";

revoke insert on table "public"."ref_best_by_format" from "anon";

revoke references on table "public"."ref_best_by_format" from "anon";

revoke select on table "public"."ref_best_by_format" from "anon";

revoke trigger on table "public"."ref_best_by_format" from "anon";

revoke truncate on table "public"."ref_best_by_format" from "anon";

revoke update on table "public"."ref_best_by_format" from "anon";

revoke delete on table "public"."ref_best_by_format" from "authenticated";

revoke insert on table "public"."ref_best_by_format" from "authenticated";

revoke references on table "public"."ref_best_by_format" from "authenticated";

revoke select on table "public"."ref_best_by_format" from "authenticated";

revoke trigger on table "public"."ref_best_by_format" from "authenticated";

revoke truncate on table "public"."ref_best_by_format" from "authenticated";

revoke update on table "public"."ref_best_by_format" from "authenticated";

revoke delete on table "public"."ref_best_by_format" from "service_role";

revoke insert on table "public"."ref_best_by_format" from "service_role";

revoke references on table "public"."ref_best_by_format" from "service_role";

revoke select on table "public"."ref_best_by_format" from "service_role";

revoke trigger on table "public"."ref_best_by_format" from "service_role";

revoke truncate on table "public"."ref_best_by_format" from "service_role";

revoke update on table "public"."ref_best_by_format" from "service_role";

revoke delete on table "public"."ref_brand_approval" from "anon";

revoke insert on table "public"."ref_brand_approval" from "anon";

revoke references on table "public"."ref_brand_approval" from "anon";

revoke select on table "public"."ref_brand_approval" from "anon";

revoke trigger on table "public"."ref_brand_approval" from "anon";

revoke truncate on table "public"."ref_brand_approval" from "anon";

revoke update on table "public"."ref_brand_approval" from "anon";

revoke delete on table "public"."ref_brand_approval" from "authenticated";

revoke insert on table "public"."ref_brand_approval" from "authenticated";

revoke references on table "public"."ref_brand_approval" from "authenticated";

revoke select on table "public"."ref_brand_approval" from "authenticated";

revoke trigger on table "public"."ref_brand_approval" from "authenticated";

revoke truncate on table "public"."ref_brand_approval" from "authenticated";

revoke update on table "public"."ref_brand_approval" from "authenticated";

revoke delete on table "public"."ref_brand_approval" from "service_role";

revoke insert on table "public"."ref_brand_approval" from "service_role";

revoke references on table "public"."ref_brand_approval" from "service_role";

revoke select on table "public"."ref_brand_approval" from "service_role";

revoke trigger on table "public"."ref_brand_approval" from "service_role";

revoke truncate on table "public"."ref_brand_approval" from "service_role";

revoke update on table "public"."ref_brand_approval" from "service_role";

revoke delete on table "public"."ref_category_review_status" from "anon";

revoke insert on table "public"."ref_category_review_status" from "anon";

revoke references on table "public"."ref_category_review_status" from "anon";

revoke select on table "public"."ref_category_review_status" from "anon";

revoke trigger on table "public"."ref_category_review_status" from "anon";

revoke truncate on table "public"."ref_category_review_status" from "anon";

revoke update on table "public"."ref_category_review_status" from "anon";

revoke delete on table "public"."ref_category_review_status" from "authenticated";

revoke insert on table "public"."ref_category_review_status" from "authenticated";

revoke references on table "public"."ref_category_review_status" from "authenticated";

revoke select on table "public"."ref_category_review_status" from "authenticated";

revoke trigger on table "public"."ref_category_review_status" from "authenticated";

revoke truncate on table "public"."ref_category_review_status" from "authenticated";

revoke update on table "public"."ref_category_review_status" from "authenticated";

revoke delete on table "public"."ref_category_review_status" from "service_role";

revoke insert on table "public"."ref_category_review_status" from "service_role";

revoke references on table "public"."ref_category_review_status" from "service_role";

revoke select on table "public"."ref_category_review_status" from "service_role";

revoke trigger on table "public"."ref_category_review_status" from "service_role";

revoke truncate on table "public"."ref_category_review_status" from "service_role";

revoke update on table "public"."ref_category_review_status" from "service_role";

revoke delete on table "public"."ref_demo_customer_type" from "anon";

revoke insert on table "public"."ref_demo_customer_type" from "anon";

revoke references on table "public"."ref_demo_customer_type" from "anon";

revoke select on table "public"."ref_demo_customer_type" from "anon";

revoke trigger on table "public"."ref_demo_customer_type" from "anon";

revoke truncate on table "public"."ref_demo_customer_type" from "anon";

revoke update on table "public"."ref_demo_customer_type" from "anon";

revoke delete on table "public"."ref_demo_customer_type" from "authenticated";

revoke insert on table "public"."ref_demo_customer_type" from "authenticated";

revoke references on table "public"."ref_demo_customer_type" from "authenticated";

revoke select on table "public"."ref_demo_customer_type" from "authenticated";

revoke trigger on table "public"."ref_demo_customer_type" from "authenticated";

revoke truncate on table "public"."ref_demo_customer_type" from "authenticated";

revoke update on table "public"."ref_demo_customer_type" from "authenticated";

revoke delete on table "public"."ref_demo_customer_type" from "service_role";

revoke insert on table "public"."ref_demo_customer_type" from "service_role";

revoke references on table "public"."ref_demo_customer_type" from "service_role";

revoke select on table "public"."ref_demo_customer_type" from "service_role";

revoke trigger on table "public"."ref_demo_customer_type" from "service_role";

revoke truncate on table "public"."ref_demo_customer_type" from "service_role";

revoke update on table "public"."ref_demo_customer_type" from "service_role";

revoke delete on table "public"."ref_focus_month" from "anon";

revoke insert on table "public"."ref_focus_month" from "anon";

revoke references on table "public"."ref_focus_month" from "anon";

revoke select on table "public"."ref_focus_month" from "anon";

revoke trigger on table "public"."ref_focus_month" from "anon";

revoke truncate on table "public"."ref_focus_month" from "anon";

revoke update on table "public"."ref_focus_month" from "anon";

revoke delete on table "public"."ref_focus_month" from "authenticated";

revoke insert on table "public"."ref_focus_month" from "authenticated";

revoke references on table "public"."ref_focus_month" from "authenticated";

revoke select on table "public"."ref_focus_month" from "authenticated";

revoke trigger on table "public"."ref_focus_month" from "authenticated";

revoke truncate on table "public"."ref_focus_month" from "authenticated";

revoke update on table "public"."ref_focus_month" from "authenticated";

revoke delete on table "public"."ref_focus_month" from "service_role";

revoke insert on table "public"."ref_focus_month" from "service_role";

revoke references on table "public"."ref_focus_month" from "service_role";

revoke select on table "public"."ref_focus_month" from "service_role";

revoke trigger on table "public"."ref_focus_month" from "service_role";

revoke truncate on table "public"."ref_focus_month" from "service_role";

revoke update on table "public"."ref_focus_month" from "service_role";

revoke delete on table "public"."ref_fulfillment_method" from "anon";

revoke insert on table "public"."ref_fulfillment_method" from "anon";

revoke references on table "public"."ref_fulfillment_method" from "anon";

revoke select on table "public"."ref_fulfillment_method" from "anon";

revoke trigger on table "public"."ref_fulfillment_method" from "anon";

revoke truncate on table "public"."ref_fulfillment_method" from "anon";

revoke update on table "public"."ref_fulfillment_method" from "anon";

revoke delete on table "public"."ref_fulfillment_method" from "authenticated";

revoke insert on table "public"."ref_fulfillment_method" from "authenticated";

revoke references on table "public"."ref_fulfillment_method" from "authenticated";

revoke select on table "public"."ref_fulfillment_method" from "authenticated";

revoke trigger on table "public"."ref_fulfillment_method" from "authenticated";

revoke truncate on table "public"."ref_fulfillment_method" from "authenticated";

revoke update on table "public"."ref_fulfillment_method" from "authenticated";

revoke delete on table "public"."ref_fulfillment_method" from "service_role";

revoke insert on table "public"."ref_fulfillment_method" from "service_role";

revoke references on table "public"."ref_fulfillment_method" from "service_role";

revoke select on table "public"."ref_fulfillment_method" from "service_role";

revoke trigger on table "public"."ref_fulfillment_method" from "service_role";

revoke truncate on table "public"."ref_fulfillment_method" from "service_role";

revoke update on table "public"."ref_fulfillment_method" from "service_role";

revoke delete on table "public"."ref_master_category" from "anon";

revoke insert on table "public"."ref_master_category" from "anon";

revoke references on table "public"."ref_master_category" from "anon";

revoke select on table "public"."ref_master_category" from "anon";

revoke trigger on table "public"."ref_master_category" from "anon";

revoke truncate on table "public"."ref_master_category" from "anon";

revoke update on table "public"."ref_master_category" from "anon";

revoke delete on table "public"."ref_master_category" from "authenticated";

revoke insert on table "public"."ref_master_category" from "authenticated";

revoke references on table "public"."ref_master_category" from "authenticated";

revoke select on table "public"."ref_master_category" from "authenticated";

revoke trigger on table "public"."ref_master_category" from "authenticated";

revoke truncate on table "public"."ref_master_category" from "authenticated";

revoke update on table "public"."ref_master_category" from "authenticated";

revoke delete on table "public"."ref_master_category" from "service_role";

revoke insert on table "public"."ref_master_category" from "service_role";

revoke references on table "public"."ref_master_category" from "service_role";

revoke select on table "public"."ref_master_category" from "service_role";

revoke trigger on table "public"."ref_master_category" from "service_role";

revoke truncate on table "public"."ref_master_category" from "service_role";

revoke update on table "public"."ref_master_category" from "service_role";

revoke delete on table "public"."ref_promo_quarter" from "anon";

revoke insert on table "public"."ref_promo_quarter" from "anon";

revoke references on table "public"."ref_promo_quarter" from "anon";

revoke select on table "public"."ref_promo_quarter" from "anon";

revoke trigger on table "public"."ref_promo_quarter" from "anon";

revoke truncate on table "public"."ref_promo_quarter" from "anon";

revoke update on table "public"."ref_promo_quarter" from "anon";

revoke delete on table "public"."ref_promo_quarter" from "authenticated";

revoke insert on table "public"."ref_promo_quarter" from "authenticated";

revoke references on table "public"."ref_promo_quarter" from "authenticated";

revoke select on table "public"."ref_promo_quarter" from "authenticated";

revoke trigger on table "public"."ref_promo_quarter" from "authenticated";

revoke truncate on table "public"."ref_promo_quarter" from "authenticated";

revoke update on table "public"."ref_promo_quarter" from "authenticated";

revoke delete on table "public"."ref_promo_quarter" from "service_role";

revoke insert on table "public"."ref_promo_quarter" from "service_role";

revoke references on table "public"."ref_promo_quarter" from "service_role";

revoke select on table "public"."ref_promo_quarter" from "service_role";

revoke trigger on table "public"."ref_promo_quarter" from "service_role";

revoke truncate on table "public"."ref_promo_quarter" from "service_role";

revoke update on table "public"."ref_promo_quarter" from "service_role";

revoke delete on table "public"."ref_sample_status" from "anon";

revoke insert on table "public"."ref_sample_status" from "anon";

revoke references on table "public"."ref_sample_status" from "anon";

revoke select on table "public"."ref_sample_status" from "anon";

revoke trigger on table "public"."ref_sample_status" from "anon";

revoke truncate on table "public"."ref_sample_status" from "anon";

revoke update on table "public"."ref_sample_status" from "anon";

revoke delete on table "public"."ref_sample_status" from "authenticated";

revoke insert on table "public"."ref_sample_status" from "authenticated";

revoke references on table "public"."ref_sample_status" from "authenticated";

revoke select on table "public"."ref_sample_status" from "authenticated";

revoke trigger on table "public"."ref_sample_status" from "authenticated";

revoke truncate on table "public"."ref_sample_status" from "authenticated";

revoke update on table "public"."ref_sample_status" from "authenticated";

revoke delete on table "public"."ref_sample_status" from "service_role";

revoke insert on table "public"."ref_sample_status" from "service_role";

revoke references on table "public"."ref_sample_status" from "service_role";

revoke select on table "public"."ref_sample_status" from "service_role";

revoke trigger on table "public"."ref_sample_status" from "service_role";

revoke truncate on table "public"."ref_sample_status" from "service_role";

revoke update on table "public"."ref_sample_status" from "service_role";

revoke delete on table "public"."ref_ship_carrier" from "anon";

revoke insert on table "public"."ref_ship_carrier" from "anon";

revoke references on table "public"."ref_ship_carrier" from "anon";

revoke select on table "public"."ref_ship_carrier" from "anon";

revoke trigger on table "public"."ref_ship_carrier" from "anon";

revoke truncate on table "public"."ref_ship_carrier" from "anon";

revoke update on table "public"."ref_ship_carrier" from "anon";

revoke delete on table "public"."ref_ship_carrier" from "authenticated";

revoke insert on table "public"."ref_ship_carrier" from "authenticated";

revoke references on table "public"."ref_ship_carrier" from "authenticated";

revoke select on table "public"."ref_ship_carrier" from "authenticated";

revoke trigger on table "public"."ref_ship_carrier" from "authenticated";

revoke truncate on table "public"."ref_ship_carrier" from "authenticated";

revoke update on table "public"."ref_ship_carrier" from "authenticated";

revoke delete on table "public"."ref_ship_carrier" from "service_role";

revoke insert on table "public"."ref_ship_carrier" from "service_role";

revoke references on table "public"."ref_ship_carrier" from "service_role";

revoke select on table "public"."ref_ship_carrier" from "service_role";

revoke trigger on table "public"."ref_ship_carrier" from "service_role";

revoke truncate on table "public"."ref_ship_carrier" from "service_role";

revoke update on table "public"."ref_ship_carrier" from "service_role";

revoke delete on table "public"."ref_sos_call_month" from "anon";

revoke insert on table "public"."ref_sos_call_month" from "anon";

revoke references on table "public"."ref_sos_call_month" from "anon";

revoke select on table "public"."ref_sos_call_month" from "anon";

revoke trigger on table "public"."ref_sos_call_month" from "anon";

revoke truncate on table "public"."ref_sos_call_month" from "anon";

revoke update on table "public"."ref_sos_call_month" from "anon";

revoke delete on table "public"."ref_sos_call_month" from "authenticated";

revoke insert on table "public"."ref_sos_call_month" from "authenticated";

revoke references on table "public"."ref_sos_call_month" from "authenticated";

revoke select on table "public"."ref_sos_call_month" from "authenticated";

revoke trigger on table "public"."ref_sos_call_month" from "authenticated";

revoke truncate on table "public"."ref_sos_call_month" from "authenticated";

revoke update on table "public"."ref_sos_call_month" from "authenticated";

revoke delete on table "public"."ref_sos_call_month" from "service_role";

revoke insert on table "public"."ref_sos_call_month" from "service_role";

revoke references on table "public"."ref_sos_call_month" from "service_role";

revoke select on table "public"."ref_sos_call_month" from "service_role";

revoke trigger on table "public"."ref_sos_call_month" from "service_role";

revoke truncate on table "public"."ref_sos_call_month" from "service_role";

revoke update on table "public"."ref_sos_call_month" from "service_role";

revoke delete on table "public"."ref_states" from "anon";

revoke insert on table "public"."ref_states" from "anon";

revoke references on table "public"."ref_states" from "anon";

revoke select on table "public"."ref_states" from "anon";

revoke trigger on table "public"."ref_states" from "anon";

revoke truncate on table "public"."ref_states" from "anon";

revoke update on table "public"."ref_states" from "anon";

revoke delete on table "public"."ref_states" from "authenticated";

revoke insert on table "public"."ref_states" from "authenticated";

revoke references on table "public"."ref_states" from "authenticated";

revoke select on table "public"."ref_states" from "authenticated";

revoke trigger on table "public"."ref_states" from "authenticated";

revoke truncate on table "public"."ref_states" from "authenticated";

revoke update on table "public"."ref_states" from "authenticated";

revoke delete on table "public"."ref_states" from "service_role";

revoke insert on table "public"."ref_states" from "service_role";

revoke references on table "public"."ref_states" from "service_role";

revoke select on table "public"."ref_states" from "service_role";

revoke trigger on table "public"."ref_states" from "service_role";

revoke truncate on table "public"."ref_states" from "service_role";

revoke update on table "public"."ref_states" from "service_role";

revoke delete on table "public"."ref_states_enum" from "anon";

revoke insert on table "public"."ref_states_enum" from "anon";

revoke references on table "public"."ref_states_enum" from "anon";

revoke select on table "public"."ref_states_enum" from "anon";

revoke trigger on table "public"."ref_states_enum" from "anon";

revoke truncate on table "public"."ref_states_enum" from "anon";

revoke update on table "public"."ref_states_enum" from "anon";

revoke delete on table "public"."ref_states_enum" from "authenticated";

revoke insert on table "public"."ref_states_enum" from "authenticated";

revoke references on table "public"."ref_states_enum" from "authenticated";

revoke select on table "public"."ref_states_enum" from "authenticated";

revoke trigger on table "public"."ref_states_enum" from "authenticated";

revoke truncate on table "public"."ref_states_enum" from "authenticated";

revoke update on table "public"."ref_states_enum" from "authenticated";

revoke delete on table "public"."ref_states_enum" from "service_role";

revoke insert on table "public"."ref_states_enum" from "service_role";

revoke references on table "public"."ref_states_enum" from "service_role";

revoke select on table "public"."ref_states_enum" from "service_role";

revoke trigger on table "public"."ref_states_enum" from "service_role";

revoke truncate on table "public"."ref_states_enum" from "service_role";

revoke update on table "public"."ref_states_enum" from "service_role";

alter table "public"."accounts" drop constraint "fk_accounts_country";

alter table "public"."accounts" drop constraint "fk_accounts_state";

alter table "public"."brand_distribution_grid" drop constraint "fk_brand_distribution_grid_fulfillment_method";

alter table "public"."brand_focus_assignments" drop constraint "fk_brand_focus_assignments_focus_month";

alter table "public"."brand_promotions" drop constraint "fk_brand_promotions_brand_approval";

alter table "public"."brand_promotions" drop constraint "fk_brand_promotions_promo_quarter";

alter table "public"."brands" drop constraint "fk_brands_demo_customer_type";

alter table "public"."claude_migration_log" drop constraint "claude_migration_log_status_check";

alter table "public"."contacts" drop constraint "fk_contacts_verification_needed";

alter table "public"."enum_ref_migration_tracker" drop constraint "enum_ref_migration_tracker_migration_status_check";

alter table "public"."enum_ref_migration_tracker" drop constraint "enum_ref_migration_tracker_priority_check";

alter table "public"."hh_customers" drop constraint "fk_hh_customers_billing_terms";

alter table "public"."hh_customers" drop constraint "fk_hh_customers_payment_status";

alter table "public"."hh_customers" drop constraint "fk_hh_customers_role";

alter table "public"."hh_prospect_customers" drop constraint "fk_hh_prospect_customers_contact_source";

alter table "public"."hh_prospect_customers" drop constraint "fk_hh_prospect_customers_product_interest";

alter table "public"."jt_brand_events" drop constraint "fk_jt_brand_events_attendance_status";

alter table "public"."jt_deal_category_reviews" drop constraint "fk_jt_deal_category_reviews_category_review_status";

alter table "public"."master_categories" drop constraint "fk_master_categories_category";

alter table "public"."profiles" drop constraint "fk_profiles_department";

alter table "public"."ref_best_by_date_format" drop constraint "ref_best_by_date_format_name_key";

alter table "public"."ref_brand_approval" drop constraint "ref_brand_approval_name_key";

alter table "public"."ref_category_review_status" drop constraint "ref_category_review_status_name_key";

alter table "public"."ref_demo_customer_type" drop constraint "ref_demo_customer_type_name_key";

alter table "public"."ref_focus_month" drop constraint "ref_focus_month_name_key";

alter table "public"."ref_fulfillment_method" drop constraint "ref_fulfillment_method_name_key";

alter table "public"."ref_master_category" drop constraint "ref_master_category_name_key";

alter table "public"."ref_promo_quarter" drop constraint "ref_promo_quarter_name_key";

alter table "public"."ref_sample_status" drop constraint "ref_sample_status_name_key";

alter table "public"."ref_ship_carrier" drop constraint "ref_ship_carrier_name_key";

alter table "public"."ref_sos_call_month" drop constraint "ref_sos_call_month_name_key";

alter table "public"."ref_states_enum" drop constraint "ref_states_enum_name_key";

alter table "public"."sample_shipment_tracking" drop constraint "fk_sample_shipment_tracking_carrier";

alter table "public"."sample_shipment_tracking" drop constraint "fk_sample_shipment_tracking_status";

alter table "public"."sos_authorizations" drop constraint "fk_sos_authorizations_calling_year";

alter table "public"."spec_price_sheet" drop constraint "fk_spec_price_sheet_best_by_date_indicated";

drop view if exists "public"."activity_tracker_show_more";

drop view if exists "public"."brand_status_analytics";

drop view if exists "public"."brands_by_region";

drop view if exists "public"."costco_team_member_view";

drop view if exists "public"."event_with_attendees";

drop view if exists "public"."principal_list_product_specs";

drop view if exists "public"."v_active_submission_opportunities";

drop view if exists "public"."v_brand_contacts";

drop view if exists "public"."v_brand_distribution_grid";

drop view if exists "public"."v_brand_promo_requests_with_skus";

drop view if exists "public"."v_brand_promotions_with_skus";

drop view if exists "public"."v_brand_submission_guide";

drop view if exists "public"."v_brands_focus";

drop view if exists "public"."v_brands_needing_attention";

drop view if exists "public"."v_brands_view";

drop view if exists "public"."v_categories_with_brands";

drop view if exists "public"."v_category_review_calendar_data";

drop view if exists "public"."v_category_review_data";

drop view if exists "public"."v_category_review_summary";

drop view if exists "public"."v_category_reviews_with_matching_brands";

drop view if exists "public"."v_comments_with_author_details";

drop view if exists "public"."v_completed_demos";

drop view if exists "public"."v_dashboard_summary";

drop view if exists "public"."v_deal_distribution";

drop view if exists "public"."v_demo_calendar";

drop view if exists "public"."v_demo_check_ins";

drop view if exists "public"."v_full_contact";

drop view if exists "public"."v_gn_categories_with_retailer_mappings";

drop view if exists "public"."v_grouped_syncup_notes";

drop view if exists "public"."v_harvesthub_customer_datagrid";

drop view if exists "public"."v_harvesthub_dashboard_stats";

drop view if exists "public"."v_harvesthub_prospect_customers_datagrid";

drop view if exists "public"."v_hh_customer_activity";

drop view if exists "public"."v_hh_upcoming_deadlines";

drop view if exists "public"."v_master_category_review_data";

drop view if exists "public"."v_my_internal_profile";

drop view if exists "public"."v_program_connects_by_month";

drop view if exists "public"."v_retailer_categories_with_gn_mappings";

drop view if exists "public"."v_review_data_comprehensive";

drop view if exists "public"."v_review_data_with_brands";

drop view if exists "public"."v_scheduled_demos";

drop view if exists "public"."v_sku_category_readable";

drop view if exists "public"."v_sos_authorizations_extended";

drop view if exists "public"."v_sos_authorizations_with_calculated_revenue";

drop view if exists "public"."v_spec_price_sheet";

drop view if exists "public"."v_tile_cards_upcoming_reviews";

drop view if exists "public"."events_detailed_view";

drop view if exists "public"."v_brand_matching";

alter table "public"."claude_migration_log" drop constraint "claude_migration_log_pkey";

alter table "public"."enum_ref_migration_tracker" drop constraint "enum_ref_migration_tracker_pkey";

alter table "public"."ref_best_by_date_format" drop constraint "ref_best_by_date_format_pkey";

alter table "public"."ref_best_by_format" drop constraint "ref_best_by_format_pkey";

alter table "public"."ref_brand_approval" drop constraint "ref_brand_approval_pkey";

alter table "public"."ref_category_review_status" drop constraint "ref_category_review_status_pkey1";

alter table "public"."ref_demo_customer_type" drop constraint "ref_demo_customer_type_pkey";

alter table "public"."ref_focus_month" drop constraint "ref_focus_month_pkey";

alter table "public"."ref_fulfillment_method" drop constraint "ref_fulfillment_method_pkey";

alter table "public"."ref_master_category" drop constraint "ref_master_category_pkey";

alter table "public"."ref_promo_quarter" drop constraint "ref_promo_quarter_pkey";

alter table "public"."ref_sample_status" drop constraint "ref_sample_status_pkey";

alter table "public"."ref_ship_carrier" drop constraint "ref_ship_carrier_pkey";

alter table "public"."ref_sos_call_month" drop constraint "ref_sos_call_month_pkey";

alter table "public"."ref_states" drop constraint "ref_states_pkey";

alter table "public"."ref_states_enum" drop constraint "ref_states_enum_pkey";

drop index if exists "public"."claude_migration_log_pkey";

drop index if exists "public"."enum_ref_migration_tracker_pkey";

drop index if exists "public"."idx_accounts_country";

drop index if exists "public"."idx_accounts_state";

drop index if exists "public"."idx_brand_distribution_grid_fulfillment_method";

drop index if exists "public"."idx_brand_focus_assignments_focus_month";

drop index if exists "public"."idx_brand_promotions_brand_approval";

drop index if exists "public"."idx_brand_promotions_promo_quarter";

drop index if exists "public"."idx_brands_demo_customer_type";

drop index if exists "public"."idx_claude_migration_log_branch";

drop index if exists "public"."idx_claude_migration_log_category";

drop index if exists "public"."idx_claude_migration_log_status";

drop index if exists "public"."idx_contacts_verification_needed";

drop index if exists "public"."idx_enum_tracker_priority";

drop index if exists "public"."idx_enum_tracker_status";

drop index if exists "public"."idx_enum_tracker_table";

drop index if exists "public"."idx_enum_tracker_unique";

drop index if exists "public"."idx_hh_customers_billing_terms";

drop index if exists "public"."idx_hh_customers_payment_status";

drop index if exists "public"."idx_hh_customers_role";

drop index if exists "public"."idx_hh_prospect_customers_contact_source";

drop index if exists "public"."idx_hh_prospect_customers_product_interest";

drop index if exists "public"."idx_jt_brand_events_attendance_status";

drop index if exists "public"."idx_jt_deal_category_reviews_category_review_status";

drop index if exists "public"."idx_master_categories_category";

drop index if exists "public"."idx_profiles_department";

drop index if exists "public"."idx_sample_shipment_tracking_carrier";

drop index if exists "public"."idx_sample_shipment_tracking_status";

drop index if exists "public"."idx_sos_authorizations_calling_year";

drop index if exists "public"."idx_spec_price_sheet_best_by_date_indicated";

drop index if exists "public"."ref_best_by_date_format_name_key";

drop index if exists "public"."ref_best_by_date_format_pkey";

drop index if exists "public"."ref_best_by_format_pkey";

drop index if exists "public"."ref_brand_approval_name_key";

drop index if exists "public"."ref_brand_approval_pkey";

drop index if exists "public"."ref_category_review_status_name_key";

drop index if exists "public"."ref_category_review_status_pkey1";

drop index if exists "public"."ref_demo_customer_type_name_key";

drop index if exists "public"."ref_demo_customer_type_pkey";

drop index if exists "public"."ref_focus_month_name_key";

drop index if exists "public"."ref_focus_month_pkey";

drop index if exists "public"."ref_fulfillment_method_name_key";

drop index if exists "public"."ref_fulfillment_method_pkey";

drop index if exists "public"."ref_master_category_name_key";

drop index if exists "public"."ref_master_category_pkey";

drop index if exists "public"."ref_promo_quarter_name_key";

drop index if exists "public"."ref_promo_quarter_pkey";

drop index if exists "public"."ref_sample_status_name_key";

drop index if exists "public"."ref_sample_status_pkey";

drop index if exists "public"."ref_ship_carrier_name_key";

drop index if exists "public"."ref_ship_carrier_pkey";

drop index if exists "public"."ref_sos_call_month_name_key";

drop index if exists "public"."ref_sos_call_month_pkey";

drop index if exists "public"."ref_states_enum_name_key";

drop index if exists "public"."ref_states_enum_pkey";

drop index if exists "public"."ref_states_pkey";

drop table "public"."claude_migration_log";

drop table "public"."enum_ref_migration_tracker";

drop table "public"."ref_best_by_date_format";

drop table "public"."ref_best_by_format";

drop table "public"."ref_brand_approval";

drop table "public"."ref_category_review_status";

drop table "public"."ref_demo_customer_type";

drop table "public"."ref_focus_month";

drop table "public"."ref_fulfillment_method";

drop table "public"."ref_master_category";

drop table "public"."ref_promo_quarter";

drop table "public"."ref_sample_status";

drop table "public"."ref_ship_carrier";

drop table "public"."ref_sos_call_month";

drop table "public"."ref_states";

drop table "public"."ref_states_enum";


  create table "public"."enum_migration_tracker" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "migrated_at" timestamp with time zone,
    "source_table" text not null,
    "source_column" text not null,
    "source_data_type" text not null,
    "source_udt_name" text not null,
    "source_enum_values" text[],
    "migration_pattern" text not null,
    "ref_table" text,
    "junction_table" text,
    "mapping_column" text not null default 'name'::text,
    "status" text not null default 'pending'::text,
    "migration_mode" text,
    "rows_migrated" integer,
    "rows_total" integer,
    "views_dropped" text[],
    "functions_dropped" text[],
    "triggers_dropped" text[],
    "breaking_changes" text,
    "notes" text,
    "executed_by" text default 'claude-migration-agent'::text
      );


alter table "public"."accounts" alter column "country" set data type public."Country" using "country"::public."Country";

alter table "public"."accounts" alter column "state" set data type public.states_enum using "state"::public.states_enum;

alter table "public"."brand_distribution_grid" alter column "fulfillment_method" set data type public."Fulfillment Method " using "fulfillment_method"::public."Fulfillment Method ";

alter table "public"."brand_focus_assignments" alter column "focus_month" set data type public.focus_month_enum using "focus_month"::public.focus_month_enum;

alter table "public"."brand_promotions" alter column "brand_approval" set data type public."brand_promo_approval (delete)" using "brand_approval"::public."brand_promo_approval (delete)";

alter table "public"."brand_promotions" alter column "promo_quarter" set data type public."Quarter" using "promo_quarter"::public."Quarter";

alter table "public"."brands" alter column "demo_customer_type" set data type public."Demo_special_customer_enum" using "demo_customer_type"::public."Demo_special_customer_enum";

alter table "public"."contacts" alter column "verification_needed" set data type public.verification_status using "verification_needed"::public.verification_status;

alter table "public"."hh_customers" alter column "billing_terms" set data type public.hh_billing_terms_enum using "billing_terms"::public.hh_billing_terms_enum;

alter table "public"."hh_customers" alter column "payment_status" set data type public.hh_payment_status_enum using "payment_status"::public.hh_payment_status_enum;

alter table "public"."hh_customers" alter column "role" set data type public.hh_user_role_enum using "role"::public.hh_user_role_enum;

alter table "public"."hh_prospect_customers" alter column "contact_source" set data type public.hh_contact_source_enum using "contact_source"::public.hh_contact_source_enum;

alter table "public"."hh_prospect_customers" alter column "product_interest" set data type public.hh_product_interest_enum using "product_interest"::public.hh_product_interest_enum;

alter table "public"."jt_brand_events" alter column "attendance_status" set data type public.attendance_status_enum using "attendance_status"::public.attendance_status_enum;

alter table "public"."jt_deal_category_reviews" alter column "category_review_status" set data type public."category_review_status_enum (deprecated?)" using "category_review_status"::public."category_review_status_enum (deprecated?)";

alter table "public"."master_categories" alter column "category" set data type public."category_enum (deprecated?)" using "category"::public."category_enum (deprecated?)";

alter table "public"."profiles" alter column "department" set data type public."Departments" using "department"::public."Departments";

alter table "public"."sample_shipment_tracking" alter column "carrier" set data type public.ship_carrier using "carrier"::public.ship_carrier;

alter table "public"."sample_shipment_tracking" alter column "status" set data type public.sample_status using "status"::public.sample_status;

alter table "public"."sos_authorizations" alter column "calling_year" set data type public.sos_calling_year using "calling_year"::public.sos_calling_year;

alter table "public"."spec_price_sheet" alter column "best_by_date_indicated" set data type public.best_by_enum using "best_by_date_indicated"::public.best_by_enum;

CREATE UNIQUE INDEX enum_migration_tracker_pkey ON public.enum_migration_tracker USING btree (id);

alter table "public"."enum_migration_tracker" add constraint "enum_migration_tracker_pkey" PRIMARY KEY using index "enum_migration_tracker_pkey";

set check_function_bodies = off;

create type "public"."http_header" as ("field" character varying, "value" character varying);

create type "public"."http_request" as ("method" public.http_method, "uri" character varying, "headers" public.http_header[], "content_type" character varying, "content" character varying);

create type "public"."http_response" as ("status" integer, "content_type" character varying, "headers" public.http_header[], "content" character varying);

create or replace view "public"."activity_tracker_show_more" as  SELECT at.id AS activity_id,
    acc.account AS account_name,
    acc.open_review,
    acc.preferred_submission_process,
    acc.placement_requirements,
    acc.account_notes,
    ( SELECT jsonb_agg(jsonb_build_object('id', mcr.id, 'display_name', mcr.display_name, 'retailer_category', mcr.retailer_category, 'submission_deadline', mcr.new_item_submission_deadline, 'review_date', mcr.retailer_review_date, 'is_cancelled', mcr.category_cancellation)) AS jsonb_agg
           FROM public.master_category_review_data mcr
          WHERE (mcr.account = at.account)) AS category_reviews
   FROM (public.activity_tracker at
     LEFT JOIN public.accounts acc ON ((at.account = acc.uuid)));


create or replace view "public"."brand_status_analytics" as  WITH unnested_statuses AS (
         SELECT b.id,
            b.brand,
            r.name AS status,
            b.services,
            b.coverage
           FROM ((public.brands b
             JOIN public.jt_ref_brand_status jt_s ON ((jt_s.brands = b.id)))
             JOIN public.ref_brand_status r ON ((r.id = jt_s.ref_brand_status)))
        ), status_categories AS (
         SELECT unnested_statuses.id,
            unnested_statuses.brand,
            unnested_statuses.status,
                CASE
                    WHEN (unnested_statuses.status = ANY (ARRAY['Active'::text, 'Priority'::text, 'Demo Program - Depricated'::text, 'SOS Program - Depricated'::text])) THEN 'Active/Healthy'::text
                    WHEN (unnested_statuses.status = ANY (ARRAY['Onboarding'::text, 'New to Market'::text])) THEN 'Onboarding'::text
                    WHEN (unnested_statuses.status = ANY (ARRAY['Sustaining (Commission)'::text, 'Commission'::text, 'Low Comm - Depricated'::text, 'Private Label - Depricated'::text, 'Special'::text])) THEN 'Commission/Special'::text
                    WHEN (unnested_statuses.status = ANY (ARRAY['Pause time TBD - Depricated'::text, 'Demo Request Time Off'::text, 'Pause TBD'::text, 'In Cancellation'::text])) THEN 'At Risk/Paused'::text
                    WHEN (unnested_statuses.status = ANY (ARRAY['Former GoodNow Vendor'::text, 'Former Demo Vendor'::text, 'Former SOS Vendor'::text])) THEN 'Former/Inactive'::text
                    WHEN (unnested_statuses.status = 'Prospect'::text) THEN 'Prospect'::text
                    ELSE 'Other'::text
                END AS status_category,
                CASE
                    WHEN (unnested_statuses.status = ANY (ARRAY['Active'::text, 'Priority'::text, 'Demo Program - Depricated'::text, 'SOS Program - Depricated'::text, 'Onboarding'::text, 'New to Market'::text, 'Sustaining (Commission)'::text, 'Commission'::text, 'Low Comm - Depricated'::text, 'Private Label - Depricated'::text, 'Special'::text])) THEN 1
                    WHEN (unnested_statuses.status = ANY (ARRAY['Pause time TBD - Depricated'::text, 'Demo Request Time Off'::text, 'Pause TBD'::text, 'In Cancellation'::text, 'Prospect'::text])) THEN 2
                    WHEN (unnested_statuses.status = ANY (ARRAY['Former GoodNow Vendor'::text, 'Former Demo Vendor'::text, 'Former SOS Vendor'::text])) THEN 3
                    ELSE 4
                END AS health_score
           FROM unnested_statuses
        )
 SELECT status_categories.status,
    status_categories.status_category,
    status_categories.health_score,
    count(DISTINCT status_categories.id) AS brand_count,
    round(((100.0 * (count(DISTINCT status_categories.id))::numeric) / sum(count(DISTINCT status_categories.id)) OVER ()), 2) AS percentage
   FROM status_categories
  GROUP BY status_categories.status, status_categories.status_category, status_categories.health_score
  ORDER BY status_categories.health_score, status_categories.status_category, (count(DISTINCT status_categories.id)) DESC;


create or replace view "public"."brands_by_region" as  SELECT unnest(brands.coverage) AS region,
    count(brands.id) AS brand_count
   FROM public.brands
  GROUP BY (unnest(brands.coverage))
  ORDER BY (count(brands.id)) DESC;


create or replace view "public"."costco_team_member_view" as  SELECT atm.account_uuid,
    a.account AS account_name,
    string_agg(tm.name, ', '::text) AS team_member_names
   FROM ((public.jt_accounts_team_member_guide atm
     JOIN public.accounts a ON ((atm.account_uuid = a.uuid)))
     JOIN public.team_member_guide tm ON ((atm.team_member_uuid = tm.uuid)))
  WHERE (a.account = 'Costco: Mexico HQ'::text)
  GROUP BY atm.account_uuid, a.account
  ORDER BY a.account;


create or replace view "public"."event_with_attendees" as  SELECT e.id AS event_id,
    e.event_name,
    e.event_dates,
    e.event_year,
    ((e.event_name || ' – '::text) || e.event_dates) AS readable_event_title,
    json_agg(DISTINCT b.brand) FILTER (WHERE (b.id IS NOT NULL)) AS attending_brands,
    json_agg(DISTINCT t.name) FILTER (WHERE (t.uuid IS NOT NULL)) AS confirmed_team_members
   FROM ((((public.events e
     LEFT JOIN public.jt_brand_events be ON ((be.event_id = e.id)))
     LEFT JOIN public.brands b ON ((b.id = be.brand_id)))
     LEFT JOIN public.jt_team_members_x_events te ON ((te.event_id = e.id)))
     LEFT JOIN public.team_member_guide t ON ((t.uuid = te.team_member_id)))
  GROUP BY e.id;


create or replace view "public"."events_detailed_view" as  WITH brand_attendees AS (
         SELECT jbe.event_id,
            jsonb_agg(jsonb_build_object('brand_id', b.id, 'brand_name', b.brand, 'attendance_status', jbe.attendance_status, 'price_to_attend', jbe.price_to_attend, 'attendees_list', jbe.attendees, 'confirmed_brand_attendees', jbe.confirmed_brand_attendees, 'brand_notes', jbe.brand_notes)) AS attending_brands
           FROM (public.jt_brand_events jbe
             JOIN public.brands b ON ((jbe.brand_id = b.id)))
          GROUP BY jbe.event_id
        ), team_attendees AS (
         SELECT jte.event_id,
            jsonb_agg(jsonb_build_object('team_member_id', tm.uuid, 'name', tm.name, 'profile_pic', tm.profile_photo, 'role', jte.role, 'notes', jte.notes)) AS attending_team
           FROM (public.jt_team_members_x_events jte
             JOIN public.team_member_guide tm ON ((jte.team_member_id = tm.uuid)))
          GROUP BY jte.event_id
        )
 SELECT e.id,
    e.event_name,
    e.event_year,
    e.event_dates,
    e.event_tags,
    e.location,
    e.website,
    e.notes,
    e.event_forms,
    e.event_dispay_image,
    e.event_description,
    e.goodnow_participation,
    e.booth_number,
    e.accommodations,
    e.event_display_name,
    e.internal_event_planning_forms,
    e.start_date,
    e.end_date,
    ba.attending_brands,
    ta.attending_team
   FROM ((public.events e
     LEFT JOIN brand_attendees ba ON ((e.id = ba.event_id)))
     LEFT JOIN team_attendees ta ON ((e.id = ta.event_id)));


CREATE OR REPLACE FUNCTION public.get_next_category_review_deadline()
 RETURNS SETOF public.v_brand_matching
 LANGUAGE sql
 STABLE
AS $function$
  SELECT *
  FROM public.v_brand_matching
  WHERE 
    new_item_submission_deadline IS NOT NULL 
    AND new_item_submission_deadline >= CURRENT_DATE
  ORDER BY 
    new_item_submission_deadline ASC
  LIMIT 1;
$function$
;

CREATE OR REPLACE FUNCTION public.get_next_event()
 RETURNS SETOF public.events_detailed_view
 LANGUAGE sql
AS $function$
  SELECT *
  FROM public.events_detailed_view -- It searches the "library" (your view)
  WHERE start_date >= CURRENT_DATE -- Finds ones that haven't happened
  ORDER BY start_date ASC           -- Puts the soonest one first
  LIMIT 1;                          -- And ONLY grabs that single one
$function$
;

CREATE OR REPLACE FUNCTION public.notify_task_assignment()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
  t_title text;
  creator_uuid uuid;
  creator_name text;
  t_status text;
  full_message text;
begin
  -- Get task title + creator UUID + status from task_pipeline
  select tp.task_title, tp.created_by, tp.status
  into t_title, creator_uuid, t_status
  from task_pipeline tp
  where tp.id = new.task_id;

  -- Get creator name from team_member_guide
  select tmg.name
  into creator_name
  from team_member_guide tmg
  where tmg.uuid = creator_uuid;

-- Convert snake_case status to Title Case
t_status := replace(initcap(replace(t_status, '_', ' ')), ' ', ' ');

  -- Build dynamic message
  full_message :=
    '<b>' || creator_name || '</b>' ||
    ' has assigned you the task ' ||
    '<b>' || t_title || '</b>' ||
    ' with ' ||
    '<b>' || t_status || '</b>' ||
    ' status.';

  -- Insert notification
  insert into notifications (recipient_id, type, data)
  values (
    new.team_member_uuid, -- the assigned user
    'task_assigned',       -- type
    jsonb_build_object(
      'task_id', new.task_id,
      'task_title', t_title,
      'task_status', t_status,
      'assigned_by_uuid', creator_uuid,
      'assigned_by_name', creator_name,
      'message', full_message
    )
  );

  return new;
end;
$function$
;

create or replace view "public"."principal_list_product_specs" as  SELECT b.id AS brand_id,
    b.brand,
    s.id AS product_id,
    s.unique_item_name AS item_name,
    s.item_status,
    s.sales_rank,
    s.uos,
    s.uom,
    s.vendor_item_number,
    s.ean,
    s.upc_12_digit AS upc,
    s.case_upc,
    s.master_upc,
    s.case_pack,
    s.unit_height_inches,
    s.unit_width_inches,
    s.unit_depth_inches,
    s.case_height_inches,
    s.case_width_inches,
    s.case_depth_inches,
    s.net_case_weight_lbs,
    s.gross_case_weight_lbs,
    s.master_case_weight_lbs,
    s.ti,
    s.hi,
    s.cube,
    s.cases_per_pallet,
    s.pallet_weight_lbs,
    s.item_temp_reqs AS transport,
    s.fob_location,
    s.srp,
    s.direct_ship_available,
    s.minimum_direct_order_quantity AS moq_direct,
    s.minimum_order_quantity_distribution AS moq_distribution,
    s.order_lead_time,
    s.shelf_life_in_days_at_manufacture,
    s.frozen_shelf_life_if_applicable,
    s.shelf_life_in_days_guaranteed,
    s.ingredient_list,
    s.organic,
    s.non_gmo,
    s.gluten_free,
    s.vegan,
    s.vegetarian,
    s.kosher,
    s.dairy_free,
    s.sugar_free,
    s.soy_free,
    s.nut_free,
    s.wheat_free
   FROM (public.brands b
     JOIN public.spec_price_sheet s ON ((s.brand_id = b.id)));


create or replace view "public"."summarized_deadlines_for_calendar" as  SELECT to_char((mcrd.new_item_submission_deadline)::timestamp with time zone, 'YYYY-MM-DD'::text) AS grouped_event_id,
    mcrd.new_item_submission_deadline AS event_date,
    count(mcrd.id) AS item_count,
    'Deadlines'::text AS display_title,
    jsonb_agg(jsonb_build_object('id', mcrd.id, 'display_name', mcrd.display_name, 'account_uuid', mcrd.account, 'retailer_category', mcrd.retailer_category, 'retailer_review_timing', mcrd.retailer_review_timing, 'reset_date', mcrd.reset_date, 'review_type', mcrd.review_type, 'retailer_review_date', mcrd.retailer_review_date, 'on_shelf_reset_date', mcrd.on_shelf_reset_date, 'new_item_submission_deadline', mcrd.new_item_submission_deadline, 'master_category_id', mcrd.master_category_id, 'created_at', mcrd.created_at, 'updated_at', mcrd.updated_at, 'archive', mcrd.archive, 'gnf_sub_category_uuid', mcrd.gnf_sub_category) ORDER BY mcrd.display_name) AS daily_deadlines_details
   FROM public.master_category_review_data mcrd
  WHERE (mcrd.new_item_submission_deadline IS NOT NULL)
  GROUP BY mcrd.new_item_submission_deadline
  ORDER BY mcrd.new_item_submission_deadline;


create or replace view "public"."v_active_submission_opportunities" as  SELECT mc.category AS gn_category,
    mc.full_category AS gn_full_category,
    a.account AS retailer_name,
    rgcm.retailer_category_name,
    mcrd.new_item_submission_deadline,
    mcrd.review_type,
    mcrd.retailer_review_timing,
    mcrd.display_name AS review_name,
    (mcrd.new_item_submission_deadline - CURRENT_DATE) AS days_until_deadline,
    mc.id AS gn_category_id,
    mcrd.id AS review_data_id
   FROM (((((public.master_categories mc
     JOIN public.jt_retailer_category_to_gn_categories jt ON ((mc.id = jt.gn_category_id)))
     JOIN public.retailer_gnf_category_matching rgcm ON ((jt.retailer_category_id = rgcm.id)))
     JOIN public.accounts a ON ((rgcm.account = a.uuid)))
     JOIN public.jt_master_category_review_data_matching jtrdm ON ((rgcm.id = jtrdm.retailer_matching_id)))
     JOIN public.master_category_review_data mcrd ON ((jtrdm.review_data_id = mcrd.id)))
  WHERE (mcrd.new_item_submission_deadline > CURRENT_DATE)
  ORDER BY mcrd.new_item_submission_deadline, mc.category, a.account;


create or replace view "public"."v_brand_contacts" as  SELECT c.uuid,
    c.created_at,
    c.first_name,
    c.last_name,
    c.email,
    c.title,
    c.phone,
    c.contact_tags,
    c.receive_company_updates,
    c.company AS brand_id,
    b.brand AS brand_name
   FROM (public.brand_contacts_table c
     LEFT JOIN public.brands b ON ((c.company = b.id)));


create or replace view "public"."v_brand_distribution_grid" as  SELECT bdg.id AS grid_id,
    bdg.item_code,
    bdg.distribution_status,
    bdg.distribution_notes,
    bdg.brand_id,
    b.brand,
    bdg.item_name AS item_spec_id,
    sps.unique_item_name AS spec_item_name,
    bdg.distributor_hq AS distributor_hq_id,
    dist_acc.account AS distributor_hq_name,
    dist_acc.primary_region AS distributor_region,
    bdg.warehouse_dc AS warehouse_dc_id,
    wh_acc.account AS warehouse_dc_name,
    bdg.updated_at AS last_updated,
    bdg.updated_by
   FROM ((((public.brand_distribution_grid bdg
     LEFT JOIN public.brands b ON ((bdg.brand_id = b.id)))
     LEFT JOIN public.spec_price_sheet sps ON ((bdg.item_name = sps.id)))
     LEFT JOIN public.accounts dist_acc ON ((bdg.distributor_hq = dist_acc.uuid)))
     LEFT JOIN public.accounts wh_acc ON ((bdg.warehouse_dc = wh_acc.uuid)));


create or replace view "public"."v_brand_matching" as  WITH aggregated_managers AS (
         SELECT jccm.master_category_review_id AS review_id,
            array_agg(DISTINCT c.uuid) FILTER (WHERE (c.uuid IS NOT NULL)) AS manager_ids,
            jsonb_agg(jsonb_build_object('id', c.uuid, 'name', c.full_name, 'email', c.contact_email, 'phone', c.contact_phone, 'title', c.job_title)) AS managers_list
           FROM (public.jt_contacts_categories_managed jccm
             JOIN public.contacts c ON ((jccm.contact_id = c.uuid)))
          GROUP BY jccm.master_category_review_id
        ), aggregated_brands AS (
         SELECT link.review_id,
            count(link.id) AS brand_count,
            jsonb_agg(jsonb_build_object('match_id', link.id, 'brand_id', b.id, 'brand_name', b.brand, 'brand_logo', b.brand_logo, 'manufacturer_name', b.manufacturer_name, 'brand_status', COALESCE(( SELECT jsonb_agg(jsonb_build_object('id', r_1.id, 'name', r_1.name) ORDER BY r_1.name) AS jsonb_agg
                   FROM (public.jt_ref_brand_status jt_s
                     JOIN public.ref_brand_status r_1 ON ((r_1.id = jt_s.ref_brand_status)))
                  WHERE (jt_s.brands = b.id)), '[]'::jsonb), 'matched_on', link.created_at) ORDER BY b.brand) AS brands_array,
            max(mc_1.updated_at) AS category_updated_at
           FROM (((public.jt_matched_brands_to_category_reviews link
             JOIN public.jt_master_categories_brands jmc ON ((link.brand_match_id = jmc.id)))
             JOIN public.brands b ON ((jmc.brand_id = b.id)))
             JOIN public.master_categories mc_1 ON ((jmc.master_category_id = mc_1.id)))
          GROUP BY link.review_id
        )
 SELECT r.id AS review_id,
    r.master_category_id AS category_id,
    COALESCE(r.display_name, r.retailer_category, 'Unnamed Review'::text) AS review_name,
    r.review_type,
    r.retailer_review_timing,
    r.new_item_submission_deadline,
    r.on_shelf_reset_date,
    r.archive AS is_archived,
    mc.full_category,
    mc.subcategory,
    mc.category AS category_type,
    COALESCE(ab.brands_array, '[]'::jsonb) AS linked_brands_array,
    COALESCE(ab.brand_count, (0)::bigint) AS linked_brands_count,
    COALESCE(am.manager_ids, ARRAY[]::uuid[]) AS filter_manager_ids,
    COALESCE(am.managers_list, '[]'::jsonb) AS category_managers,
    GREATEST(r.updated_at, ab.category_updated_at) AS last_modified
   FROM (((public.master_category_review_data r
     LEFT JOIN public.master_categories mc ON ((r.master_category_id = mc.id)))
     JOIN aggregated_brands ab ON ((r.id = ab.review_id)))
     LEFT JOIN aggregated_managers am ON ((r.id = am.review_id)));


create or replace view "public"."v_brand_promo_requests_with_skus" as  SELECT bpr.id,
    bpr.created_at,
    bpr.brand_id,
    bpr.retailer_id,
    bpr.distributor_id,
    bpr.promo_type_brand_facing,
    bpr.effective_promo_month,
    bpr.effective_promo_year,
    bpr.submission_status,
    bpr.brand_approval,
    json_agg(
        CASE
            WHEN (sps.id IS NOT NULL) THEN jsonb_build_object('id', sps.id, 'unique_item_name', sps.unique_item_name, 'upc_12_digit', sps.upc_12_digit, 'case_pack', sps.case_pack, 'fob_price_case', sps.fob_price_case, 'srp', sps.srp)
            ELSE NULL::jsonb
        END) FILTER (WHERE (sps.id IS NOT NULL)) AS skus,
    count(sps.id) AS sku_count
   FROM ((public."brand_promo_requests (Deprecated)" bpr
     LEFT JOIN public.jt_brand_promo_request_skus jt ON ((bpr.id = jt.brand_promo_request_id)))
     LEFT JOIN public.spec_price_sheet sps ON ((jt.sku_id = sps.id)))
  GROUP BY bpr.id;


create or replace view "public"."v_brand_promotions_with_skus" as  SELECT bp.id,
    bp.created_at,
    bp.brand,
    bp.master_promo_id,
    bp.retailer_id,
    bp.distribution_id,
    bp.promo_quarter,
    bp.submission_status,
    bp.brand_approval,
    bp.submission_notes,
    bp.brand_comments,
    bp.submitted_promo_contracts,
    json_agg(jsonb_build_object('id', sps.id, 'unique_item_name', sps.unique_item_name, 'other_pricing_unit', sps.other_pricing_unit, 'other_pricing_case', sps.other_pricing_case)) FILTER (WHERE (sps.id IS NOT NULL)) AS skus
   FROM ((public.brand_promotions bp
     LEFT JOIN public.jt_brand_promotion_skus jt ON ((bp.id = jt.brand_promotion_id)))
     LEFT JOIN public.spec_price_sheet sps ON ((jt.sku_id = sps.id)))
  GROUP BY bp.id;


create or replace view "public"."v_brand_submission_guide" as  SELECT mc.category AS gn_category,
    mc.subcategory AS gn_subcategory,
    mc.full_category AS gn_full_category,
    count(DISTINCT a.uuid) AS total_retailers,
    array_agg(DISTINCT a.account ORDER BY a.account) FILTER (WHERE (a.account IS NOT NULL)) AS retailer_names,
    array_agg(DISTINCT rgcm.retailer_category_name ORDER BY rgcm.retailer_category_name) FILTER (WHERE (rgcm.retailer_category_name IS NOT NULL)) AS retailer_category_names,
    min(mcrd.new_item_submission_deadline) AS next_deadline,
    count(
        CASE
            WHEN (mcrd.new_item_submission_deadline > CURRENT_DATE) THEN 1
            ELSE NULL::integer
        END) AS upcoming_deadlines,
    mc.id AS gn_category_id
   FROM (((((public.master_categories mc
     LEFT JOIN public.jt_retailer_category_to_gn_categories jt ON ((mc.id = jt.gn_category_id)))
     LEFT JOIN public.retailer_gnf_category_matching rgcm ON ((jt.retailer_category_id = rgcm.id)))
     LEFT JOIN public.accounts a ON ((rgcm.account = a.uuid)))
     LEFT JOIN public.jt_master_category_review_data_matching jtrdm ON ((rgcm.id = jtrdm.retailer_matching_id)))
     LEFT JOIN public.master_category_review_data mcrd ON ((jtrdm.review_data_id = mcrd.id)))
  GROUP BY mc.id, mc.category, mc.subcategory, mc.full_category;


create or replace view "public"."v_brands_focus" as  SELECT bfa.id AS assignment_id,
    b.brand AS brand_name,
    b.coverage,
    tmg.name AS team_member_name,
    tmg.profile_photo,
    bfa.focus_month,
    bfa."Notes" AS notes,
    bfa.created_at
   FROM ((public.brand_focus_assignments bfa
     JOIN public.brands b ON ((bfa.brand = b.id)))
     JOIN public.team_member_guide tmg ON ((bfa.team_member = tmg.uuid)))
  WHERE ('GoodNow'::public."Active Services" = ANY (b.services));


create or replace view "public"."v_brands_needing_attention" as  SELECT brands.brand,
    brands.attention_flags
   FROM public.brands
  WHERE (brands.attention_flags IS NOT NULL);


create or replace view "public"."v_brands_view" as  SELECT b.id,
    b.brand,
    b.manufacturer_name,
    b.principal_list_status,
    COALESCE(( SELECT jsonb_agg(jsonb_build_object('id', r.id, 'name', r.name) ORDER BY r.name) AS jsonb_agg
           FROM (public.jt_ref_brand_status jt_s
             JOIN public.ref_brand_status r ON ((r.id = jt_s.ref_brand_status)))
          WHERE (jt_s.brands = b.id)), '[]'::jsonb) AS status,
    b.services,
    b.coverage,
    b.start_date,
    b.last_date,
    b.sos_start_date,
    b.demo_start_date,
    b.headquarters_address,
    b.mailing_address_if_different,
    b.free_fill_placement_authorization,
    b.samples_policy_and_request_process,
    b.mission_components,
    b.overall_brand_goals,
    b.demos_included_quarterly,
    b.sos_calls_included_monthly,
    b.sos_sales_rate,
    b.referred_by,
    b.product_pickup_address,
    b.product_summary,
    b.se___current_month,
    b.invoice_timing,
    b.billing_notes,
    b.tax_id_number,
    b.private_label_bulk_and__or_food_service,
    b.describe_any_capabilities_from_the_selection_above,
    b.order_lead_time,
    b.full_reclamation_or_spoils_allowance,
    b.brand_certifications,
    b.capacity_or_production_restrictions,
    b.direct_order_details_process,
    b.marketing_descriptions,
    b.email_pitch_descriptor,
    b.are_you_a_member_of_any_trade_organizations,
    b.product_attributes,
    b.onboarding_notes,
    b.company_website,
    b.cancellation_reasons,
    b.se___next_month,
    b.brand_contracts,
    b.follow_up_email_draft,
    b.category_for_principal_list,
    b.product_sub_category_for_principal_list,
    b.new_item,
    b.product_images,
    b.attention_flags,
    b.brand_logo,
    b.other_active_brokerage_service_coverage,
    b.demo_customer_type,
    b.faire_link,
    b.mable_link,
    b.airgoods_link,
    b.other_link,
    b.pod_foods_link,
    COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', d.id, 'name', d.name, 'size', d.size, 'path', d.storage_path)) FILTER (WHERE (d.id IS NOT NULL)), '[]'::jsonb) AS principal_list_images,
    COALESCE(jsonb_agg(DISTINCT jsonb_build_object('id', mc.id, 'name', mc.full_category)) FILTER (WHERE (mc.id IS NOT NULL)), '[]'::jsonb) AS master_categories
   FROM ((((public.brands b
     LEFT JOIN public.jt_principal_list_product_images jt ON ((b.id = jt.brand)))
     LEFT JOIN public.brand_documents d ON ((jt.brand_document_id = d.id)))
     LEFT JOIN public.jt_master_categories_brands jt_mc ON ((b.id = jt_mc.brand_id)))
     LEFT JOIN public.master_categories mc ON ((jt_mc.master_category_id = mc.id)))
  GROUP BY b.id;


create or replace view "public"."v_categories_with_brands" as  SELECT mc.id AS category_id,
    mc.category,
    mc.subcategory,
    mc.full_category,
    mc.notes AS category_notes,
    b.id AS brand_id,
    b.brand AS brand_name,
    b.manufacturer_name,
    b.product_summary AS brand_description,
    jt.created_at AS relationship_created_at
   FROM ((public.master_categories mc
     LEFT JOIN public.jt_master_categories_brands jt ON ((mc.id = jt.master_category_id)))
     LEFT JOIN public.brands b ON ((jt.brand_id = b.id)));


create or replace view "public"."v_category_review_calendar_data" as  SELECT mcrd.id AS review_data_id,
    mcrd.display_name AS review_name,
    mcrd.retailer_category,
    mcrd.review_type,
    mcrd.new_item_submission_deadline,
    a.account AS account_name
   FROM ((public.master_category_review_data mcrd
     LEFT JOIN public.accounts a ON ((mcrd.account = a.uuid)))
     LEFT JOIN public.jt_master_category_review_data_brands jt ON ((mcrd.id = jt.review_data_id)));


create or replace view "public"."v_category_review_data" as  SELECT mcrd.id,
    mcrd.display_name,
    mcrd.account,
    mcrd.retailer_category,
    mcrd.retailer_review_timing,
    mcrd.reset_date,
    mcrd.review_type,
    mcrd.retailer_review_date,
    mcrd.on_shelf_reset_date,
    mcrd.new_item_submission_deadline,
    mcrd.master_category_id,
    mcrd.created_at,
    mcrd.updated_at,
    mcrd.archive,
    mcrd.gnf_sub_category,
    mcrd.category_specific_review_notes AS category_notes,
    a.account AS account_name,
    ( SELECT array_agg(DISTINCT jatm.team_member_uuid) AS array_agg
           FROM public.jt_accounts_team_member_guide jatm
          WHERE (jatm.account_uuid = mcrd.account)) AS account_manager_ids,
    ( SELECT array_agg(DISTINCT jatm.team_member_name) AS array_agg
           FROM public.jt_accounts_team_member_guide jatm
          WHERE (jatm.account_uuid = mcrd.account)) AS account_manager_names,
    mc.subcategory AS gnf_sub_category_name,
    ( SELECT array_agg(jb.brand_id) AS array_agg
           FROM public.jt_master_category_review_data_brands jb
          WHERE (jb.review_data_id = mcrd.id)) AS brand_ids
   FROM ((public.master_category_review_data mcrd
     LEFT JOIN public.accounts a ON ((mcrd.account = a.uuid)))
     LEFT JOIN public.master_categories mc ON ((mcrd.gnf_sub_category = mc.id)));


create or replace view "public"."v_category_review_summary" as  SELECT a.account AS account_name,
    count(DISTINCT mcrd.id) AS total_review_records,
    count(DISTINCT rgcm.id) AS total_category_mappings,
    count(DISTINCT jtb.brand_id) AS total_brands_in_reviews,
    count(
        CASE
            WHEN (mcrd.new_item_submission_deadline > CURRENT_DATE) THEN 1
            ELSE NULL::integer
        END) AS upcoming_deadlines,
    min(mcrd.new_item_submission_deadline) AS next_deadline,
    max(mcrd.updated_at) AS last_updated
   FROM (((public.accounts a
     LEFT JOIN public.master_category_review_data mcrd ON ((a.uuid = mcrd.account)))
     LEFT JOIN public.retailer_gnf_category_matching rgcm ON ((a.uuid = rgcm.account)))
     LEFT JOIN public.jt_master_category_review_data_brands jtb ON ((mcrd.id = jtb.review_data_id)))
  GROUP BY a.uuid, a.account
  ORDER BY a.account;


create or replace view "public"."v_category_reviews_with_matching_brands" as  SELECT r.id,
    r.display_name,
    r.account,
    r.retailer_category,
    r.retailer_review_timing,
    r.reset_date,
    r.review_type,
    r.retailer_review_date,
    r.on_shelf_reset_date,
    r.new_item_submission_deadline,
    r.master_category_id,
    r.created_at,
    r.updated_at,
    r.archive,
    r.gnf_sub_category,
    r.category_specific_review_notes,
    r.category_cancellation AS category_removal_status,
    r.cr_review_type,
    COALESCE(jsonb_agg(jsonb_build_object('id', b.id, 'name', b.brand, 'logo', b.brand_logo, 'manufacturer', b.manufacturer_name)) FILTER (WHERE (b.id IS NOT NULL)), '[]'::jsonb) AS matched_brands
   FROM (((public.master_category_review_data r
     LEFT JOIN public.jt_matched_brands_to_category_reviews jmb ON ((r.id = jmb.review_id)))
     LEFT JOIN public.jt_master_categories_brands mcb ON ((jmb.brand_match_id = mcb.id)))
     LEFT JOIN public.brands b ON ((mcb.brand_id = b.id)))
  GROUP BY r.id;


create or replace view "public"."v_comments_with_author_details" as  SELECT dac.id,
    dac.deal_id,
    dac.user_id,
    dac.comment_text,
    dac.created_at,
    COALESCE(
        CASE
            WHEN (r_sub.name = ANY (ARRAY['internal'::text, 'admin'::text, 'manager'::text])) THEN tmg.name
            ELSE NULL::text
        END, pu.name) AS author_name,
        CASE
            WHEN (r_sub.name = ANY (ARRAY['internal'::text, 'admin'::text, 'manager'::text])) THEN tmg.profile_photo
            ELSE NULL::text
        END AS author_profile_photo,
    r_sub.name AS author_role_name
   FROM (((public.deal_activity_comments dac
     JOIN public.profiles pu ON ((dac.user_id = pu.id)))
     LEFT JOIN ( SELECT DISTINCT ON (ur_inner.user_id) ur_inner.user_id,
            r_inner.name
           FROM (public.users_roles ur_inner
             JOIN public.roles r_inner ON ((ur_inner.role_id = r_inner.id)))
          ORDER BY ur_inner.user_id,
                CASE r_inner.name
                    WHEN 'admin'::text THEN 1
                    WHEN 'manager'::text THEN 2
                    WHEN 'internal'::text THEN 3
                    ELSE 99
                END) r_sub ON ((pu.id = r_sub.user_id)))
     LEFT JOIN public.team_member_guide tmg ON (((pu.id = tmg.uuid) AND (r_sub.name = ANY (ARRAY['internal'::text, 'admin'::text, 'manager'::text])))));


create or replace view "public"."v_completed_demos" as  SELECT d.id,
    d.demo_date,
    d.date_submitted,
    d.demo_status,
    d.start_time,
    d.end_time,
    d.time_range,
    d.account_id,
    d.team_member_id,
    d.store_poc,
    d.demo_fee,
    d.date_billed,
    d.other_fees,
    d.billing_notes,
    d.notes,
    d.store_busy_rating,
    d.price_on_shelf,
    d.units_before,
    d.units_after,
    d.units_sampled,
    d.avg_samples_given,
    d.total_units_sold,
    d.demo_feedback,
    d.demo_hours,
    d.training_hours,
    d.merchandising_hours,
    d.other_hours,
    d.total_hours,
    d.created_at,
    d.updated_at,
    d.demo_images,
    d.demo_receipts,
    d.demo_request_type,
    d.requested_timing,
    d.store_names,
    d.retailer_fees,
    d.check_in_photo,
    d.check_in_status,
    d.nwg_demo,
    d.notes_to_demo_team,
    d.time_off_requested,
    d.time_off_request_date,
    d.time_off_notes,
        CASE
            WHEN (d.time_off_requested IS TRUE) THEN '#8B5CF6'::text
            WHEN (d.demo_status = ANY (ARRAY['Completed'::public.demo_status_enum, 'Invoiced'::public.demo_status_enum, 'Paid Contract'::public.demo_status_enum, 'Paid Gnf'::public.demo_status_enum])) THEN '#9CA3AF'::text
            WHEN (d.demo_status = ANY (ARRAY['Store Confirmed'::public.demo_status_enum, 'Inventory Confirmed'::public.demo_status_enum, 'Rescheduled'::public.demo_status_enum, 'Cancelled'::public.demo_status_enum, 'Requested'::public.demo_status_enum])) THEN '#10B981'::text
            ELSE '#10B981'::text
        END AS event_color,
    COALESCE(((((string_agg(b.brand, ' + '::text) || ' - '::text) || a.account) || ' - '::text) || to_char((d.demo_date)::timestamp with time zone, 'MM/DD/YYYY'::text)), 'Scheduled Demo'::text) AS demo_name,
    tm.name AS demo_team_member,
    tm.profile_photo,
    string_agg((b.demo_customer_type)::text, ', '::text) AS brand_customer_types,
    a.account,
    a.gnf_priority,
    a.address AS store_address,
    a.city AS store_city,
    a.state AS store_state,
    a.zip AS store_zip,
    a.country,
    a.store_phone_number,
    a.website,
    a.account_description,
    a.account_notes,
    a.uuid AS account_uuid,
    a.updated_at AS account_last_updated,
    jsonb_agg(to_jsonb(b.*)) AS brand_details,
    string_agg(b.brand, ' + '::text) AS brand_names_list
   FROM ((((public.demos d
     LEFT JOIN public.accounts a ON ((d.account_id = a.uuid)))
     LEFT JOIN public.jt_demo_brands jdb ON ((d.id = jdb.demo_id)))
     LEFT JOIN public.brands b ON ((jdb.brand_id = b.id)))
     LEFT JOIN public.team_member_guide tm ON ((d.team_member_id = tm.uuid)))
  GROUP BY d.id, a.uuid, tm.uuid;


create or replace view "public"."v_dashboard_summary" as  SELECT ( SELECT jsonb_build_object('pipeline_items', ( SELECT count(*) AS count
                   FROM public.v_task_pipeline_with_assignees
                  WHERE (v_task_pipeline_with_assignees.is_completed = false)), 'planned_submissions', ( SELECT count(*) AS count
                   FROM public.planned_submissions), 'sync_calls', ( SELECT count(*) AS count
                   FROM public.brand_sync_call_schedule
                  WHERE (brand_sync_call_schedule.sync_date = CURRENT_DATE))) AS jsonb_build_object) AS counts,
    ( SELECT jsonb_build_object('review_name', v_brand_matching.review_name, 'deadline', v_brand_matching.new_item_submission_deadline, 'managers', v_brand_matching.category_managers, 'brands', v_brand_matching.linked_brands_array, 'count', v_brand_matching.linked_brands_count) AS jsonb_build_object
           FROM public.v_brand_matching
          WHERE ((v_brand_matching.new_item_submission_deadline IS NOT NULL) AND (v_brand_matching.new_item_submission_deadline >= CURRENT_DATE))
          ORDER BY v_brand_matching.new_item_submission_deadline
         LIMIT 1) AS next_review,
    ( SELECT row_to_json(e.*) AS row_to_json
           FROM ( SELECT events_detailed_view.id,
                    events_detailed_view.event_name,
                    events_detailed_view.event_year,
                    events_detailed_view.event_dates,
                    events_detailed_view.event_tags,
                    events_detailed_view.location,
                    events_detailed_view.website,
                    events_detailed_view.notes,
                    events_detailed_view.event_forms,
                    events_detailed_view.event_dispay_image,
                    events_detailed_view.event_description,
                    events_detailed_view.goodnow_participation,
                    events_detailed_view.booth_number,
                    events_detailed_view.accommodations,
                    events_detailed_view.event_display_name,
                    events_detailed_view.internal_event_planning_forms,
                    events_detailed_view.start_date,
                    events_detailed_view.end_date,
                    events_detailed_view.attending_brands,
                    events_detailed_view.attending_team
                   FROM public.events_detailed_view
                  WHERE (events_detailed_view.start_date >= CURRENT_DATE)
                  ORDER BY events_detailed_view.start_date
                 LIMIT 1) e) AS next_event,
    ( SELECT row_to_json(a.*) AS row_to_json
           FROM ( SELECT company_announcements.id,
                    company_announcements.created_at,
                    company_announcements.announcement,
                    company_announcements.image,
                    company_announcements.audience,
                    company_announcements.archive,
                    company_announcements.announcement_tags,
                    company_announcements.announcement_date,
                    company_announcements.announcement_title,
                    company_announcements.publish
                   FROM public.company_announcements
                  WHERE ((company_announcements.announcement_date >= CURRENT_DATE) AND (company_announcements.publish IS TRUE) AND (company_announcements.archive IS NOT TRUE))
                  ORDER BY company_announcements.announcement_date
                 LIMIT 1) a) AS next_announcement,
    ( SELECT jsonb_build_object('submission_id', ps.id, 'planned_date', ps.planned_submission_date, 'submission_status', ps.submission_status, 'review_name', mcrd.display_name, 'brand_name', b.brand, 'brand_logo', b.brand_logo, 'deal_name', at.activity_name) AS jsonb_build_object
           FROM (((public.planned_submissions ps
             LEFT JOIN public.master_category_review_data mcrd ON ((ps.category_review = mcrd.id)))
             LEFT JOIN public.activity_tracker at ON ((ps.deal_id = at.id)))
             LEFT JOIN public.brands b ON ((at.brand = b.id)))
          WHERE ((ps.planned_submission_date >= CURRENT_DATE) AND ((ps.submission_status IS FALSE) OR (ps.submission_status IS NULL)))
          ORDER BY ps.planned_submission_date
         LIMIT 1) AS next_planned_submission;


create or replace view "public"."v_deal_distribution" as  SELECT jtd.id AS deal_distribution_id,
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
   FROM ((((((((public.jt_deal_distribution jtd
     LEFT JOIN public.activity_tracker at ON ((jtd.deal_id = at.id)))
     LEFT JOIN public.jt_active_account_distribution_grid jaadg ON ((jtd.distribution_id = jaadg.id)))
     LEFT JOIN public.accounts acc ON ((jaadg.account_id = acc.uuid)))
     LEFT JOIN public.brand_distribution_grid bdg ON ((jaadg.distribution_grid_id = bdg.id)))
     LEFT JOIN public.brands b ON ((bdg.brand_id = b.id)))
     LEFT JOIN public.accounts dist_acc ON ((bdg.distributor_hq = dist_acc.uuid)))
     LEFT JOIN public.accounts wh_acc ON ((bdg.warehouse_dc = wh_acc.uuid)))
     LEFT JOIN public.spec_price_sheet sps ON ((bdg.item_name = sps.id)));


create or replace view "public"."v_demo_calendar" as  SELECT d.id,
    d.account_id,
    d.team_member_id,
        CASE
            WHEN (d.time_off_requested IS TRUE) THEN '#8B5CF6'::text
            WHEN ((d.demo_status)::text = ANY (ARRAY['Completed'::text, 'Invoiced'::text, 'Paid Contract'::text, 'Paid Gnf'::text])) THEN '#9CA3AF'::text
            WHEN ((d.demo_status)::text = ANY (ARRAY['Store Confirmed'::text, 'Inventory Confirmed'::text, 'Rescheduled'::text, 'Cancelled'::text, 'Requested'::text])) THEN '#10B981'::text
            ELSE '#10B981'::text
        END AS event_color,
    COALESCE(((((string_agg(b.brand, ' + '::text) || ' - '::text) || a.account) || ' - '::text) || to_char((d.demo_date)::timestamp with time zone, 'MM/DD/YYYY'::text)), 'Scheduled Demo'::text) AS demo_name,
    d.demo_date,
    d.start_time,
    d.end_time,
    lower(((to_char((d.start_time)::interval, 'FMHH12am'::text) || ' - '::text) || to_char((d.end_time)::interval, 'FMHH12am'::text))) AS formatted_time_range,
    d.demo_status,
    string_agg(b.brand, ' + '::text) AS brands,
    a.account AS store_name,
    tm.name AS demo_team_member,
    tm.email AS team_member_email,
    tm.phone_number,
    tm.address,
    d.time_off_requested,
    d.time_off_request_date,
    d.time_off_notes,
    d.demo_request_type,
    d.requested_timing,
    d.notes_to_demo_team,
    d.notes,
    d.created_at
   FROM ((((public.demos d
     LEFT JOIN public.jt_demo_brands jdb ON ((d.id = jdb.demo_id)))
     LEFT JOIN public.brands b ON ((jdb.brand_id = b.id)))
     LEFT JOIN public.accounts a ON ((d.account_id = a.uuid)))
     LEFT JOIN public.team_member_guide tm ON ((d.team_member_id = tm.uuid)))
  GROUP BY d.id, d.demo_date, d.start_time, d.end_time, d.demo_status, a.account, tm.name, tm.email, tm.phone_number, tm.address, d.time_off_requested, d.time_off_request_date, d.time_off_notes, d.demo_request_type, d.requested_timing, d.notes_to_demo_team, d.notes, d.created_at;


create or replace view "public"."v_demo_check_ins" as  SELECT d.id,
    COALESCE(((((string_agg(b.brand, ' + '::text) || ' - '::text) || a.account) || ' - '::text) || to_char((d.demo_date)::timestamp with time zone, 'MM/DD/YYYY'::text)), 'Demo Check-in'::text) AS name,
        CASE
            WHEN d.check_in_status THEN 'Checked In'::text
            ELSE 'Pending'::text
        END AS check_in_status,
    d.check_in_photo,
    tm.name AS demo_team_member,
    tm.email AS team_member_email,
    d.demo_date,
    string_agg(b.brand, ' + '::text) AS brands,
    a.account AS store_name,
    d.created_at
   FROM ((((public.demos d
     LEFT JOIN public.jt_demo_brands jdb ON ((d.id = jdb.demo_id)))
     LEFT JOIN public.brands b ON ((jdb.brand_id = b.id)))
     LEFT JOIN public.accounts a ON ((d.account_id = a.uuid)))
     LEFT JOIN public.team_member_guide tm ON ((d.team_member_id = tm.uuid)))
  WHERE ((d.demo_date = CURRENT_DATE) OR (d.demo_status = ANY (ARRAY['Store Confirmed'::public.demo_status_enum, 'Inventory Confirmed'::public.demo_status_enum])))
  GROUP BY d.id, d.check_in_status, d.check_in_photo, tm.name, tm.email, d.demo_date, a.account, d.created_at;


create or replace view "public"."v_full_contact" as  WITH aggregated_categories AS (
         SELECT jt_cat.contact_id,
            jsonb_agg(jsonb_build_object('id', mc.id, 'full_category', mc.full_category, 'category', mc.category, 'subcategory', mc.subcategory)) AS managed_categories,
            array_agg(DISTINCT mc.category) AS managed_category_names
           FROM (public.jt_contacts_categories_managed jt_cat
             JOIN public.master_categories mc ON ((jt_cat.master_category_id = mc.id)))
          GROUP BY jt_cat.contact_id
        ), aggregated_rep_accounts AS (
         SELECT jt_acct.contacts_uuid,
            jsonb_agg(jsonb_build_object('id', ra.uuid, 'account_name', ra.account, 'account_type', rat_rep.name)) AS representative_accounts,
            array_agg(DISTINCT ra.uuid) AS representative_account_ids,
            array_agg(DISTINCT ra.account) AS representative_account_names
           FROM ((public.jt_contacts_distributor_rep_accounts jt_acct
             JOIN public.accounts ra ON ((jt_acct.account_uuid = ra.uuid)))
             LEFT JOIN public.ref_account_type rat_rep ON ((ra.account_type = rat_rep.uuid)))
          GROUP BY jt_acct.contacts_uuid
        )
 SELECT c.uuid AS contact_uuid,
    ((c.full_name || ' - '::text) || COALESCE(pa.account, ''::text)) AS contact_and_account,
    c.job_title AS contact_job_title,
    c.first_name,
    c.last_name,
    c.contact_email,
    c.contact_phone,
    c.department_tags,
    c.contact_notes,
    c.full_name AS contact_full_name,
    c.verification_needed,
    c.last_modified,
    c.create_date,
    pa.uuid AS primary_account_uuid,
    pa.account AS primary_account_name,
    rat_pa.name AS primary_account_type,
    pa.city AS primary_account_city,
    pa.state AS primary_account_state,
    pa.website AS primary_account_website,
    agg_cat.managed_categories,
    agg_rep.representative_accounts,
    agg_cat.managed_category_names,
    agg_rep.representative_account_ids,
    agg_rep.representative_account_names,
    c.updated_by
   FROM ((((public.contacts c
     LEFT JOIN public.accounts pa ON ((c.account = pa.uuid)))
     LEFT JOIN public.ref_account_type rat_pa ON ((pa.account_type = rat_pa.uuid)))
     LEFT JOIN aggregated_categories agg_cat ON ((c.uuid = agg_cat.contact_id)))
     LEFT JOIN aggregated_rep_accounts agg_rep ON ((c.uuid = agg_rep.contacts_uuid)));


create or replace view "public"."v_gn_categories_with_retailer_mappings" as  SELECT mc.id AS gn_category_id,
    mc.category AS gn_category,
    mc.subcategory AS gn_subcategory,
    mc.full_category AS gn_full_category,
    mc.notes AS gn_category_notes,
    a.account AS retailer_name,
    a.uuid AS retailer_id,
    rgcm.id AS retailer_category_id,
    rgcm.retailer_category_name,
    rgcm.unique_category_name,
    rgcm.category_name_from_excel,
    mcrd.new_item_submission_deadline,
    mcrd.review_type,
    mcrd.retailer_review_timing,
    mcrd.display_name AS review_name,
    jt.created_at AS mapping_created_at
   FROM (((((public.master_categories mc
     LEFT JOIN public.jt_retailer_category_to_gn_categories jt ON ((mc.id = jt.gn_category_id)))
     LEFT JOIN public.retailer_gnf_category_matching rgcm ON ((jt.retailer_category_id = rgcm.id)))
     LEFT JOIN public.accounts a ON ((rgcm.account = a.uuid)))
     LEFT JOIN public.jt_master_category_review_data_matching jtrdm ON ((rgcm.id = jtrdm.retailer_matching_id)))
     LEFT JOIN public.master_category_review_data mcrd ON ((jtrdm.review_data_id = mcrd.id)));


create or replace view "public"."v_grouped_syncup_notes" as  SELECT to_char(date_trunc('day'::text, note_details.sync_date), 'Mon DD,YYYY'::text) AS formatted_date,
    to_char(date_trunc('day'::text, note_details.sync_date), 'YYYY-MM-DD'::text) AS day_start,
    jsonb_agg(jsonb_build_object('id', note_details.uuid, 'team_member_id', note_details.team_member_uuid, 'team_member_name', note_details.team_member_name, 'profile_photo', note_details.profile_photo, 'note', note_details.note, 'sync_date', note_details.sync_date, 'updated_at', note_details.updated_at, 'user_id', note_details.user_id, 'associated_brands', note_details.associated_brands, 'associated_accounts', note_details.associated_accounts) ORDER BY note_details.sync_date) AS daily_notes
   FROM ( SELECT sn.uuid,
            sn.note,
            sn.sync_date,
            sn.updated_at,
            sn."user" AS user_id,
            tmg.uuid AS team_member_uuid,
            tmg.name AS team_member_name,
            tmg.profile_photo,
            ( SELECT jsonb_agg(jsonb_build_object('jt_id', js_inner.id, 'brand_id', b_inner.id, 'brand_name', b_inner.brand) ORDER BY b_inner.brand) FILTER (WHERE (b_inner.id IS NOT NULL)) AS jsonb_agg
                   FROM (public.jt_sync_up_notes_brands js_inner
                     JOIN public.brands b_inner ON ((js_inner.brand_id = b_inner.id)))
                  WHERE (js_inner.note_id = sn.uuid)) AS associated_brands,
            ( SELECT jsonb_agg(jsonb_build_object('jt_id', ja_inner.id, 'account_id', a_inner.uuid, 'account_name', a_inner.account) ORDER BY a_inner.account) FILTER (WHERE (a_inner.uuid IS NOT NULL)) AS jsonb_agg
                   FROM (public.jt_sync_up_notes_accounts ja_inner
                     JOIN public.accounts a_inner ON ((ja_inner.account_id = a_inner.uuid)))
                  WHERE (ja_inner.note_id = sn.uuid)) AS associated_accounts
           FROM (public.syncup_notes sn
             LEFT JOIN public.team_member_guide tmg ON ((sn.team_member = tmg.uuid)))
          WHERE ((EXISTS ( SELECT 1
                   FROM public.jt_sync_up_notes_brands js_check_exists
                  WHERE (js_check_exists.note_id = sn.uuid))) OR (EXISTS ( SELECT 1
                   FROM public.jt_sync_up_notes_accounts ja_check_exists
                  WHERE (ja_check_exists.note_id = sn.uuid))))) note_details
  GROUP BY (date_trunc('day'::text, note_details.sync_date))
  ORDER BY (date_trunc('day'::text, note_details.sync_date)) DESC;


create or replace view "public"."v_harvesthub_customer_datagrid" as  SELECT c.id,
    c.name,
    c.company,
    c.email,
    c.phone,
    c.status,
    c.role,
    c.rate,
    c.promo_code,
    c.promo_description,
    c.billing_terms,
    c.payment_status,
    c.payment_date,
    c.cr_assigned,
    c.discounted_rate,
    c.total_amount_invoiced,
    c.startup_cpg_amount_owed,
    c.created_at,
    ( SELECT jsonb_agg(jt.category_review_id) AS jsonb_agg
           FROM public.jt_hh_customers_category_reviews jt
          WHERE (jt.customer_id = c.id)) AS category_reviews,
    c.promo_code_id,
    c.cancellation_reason,
    c.customer_notes,
    c.profile_photo,
    c.updated_at,
    c.invoiced_amount,
    c.startup_cpg_paid,
    c.startup_cpg_paid_date,
    jsonb_build_object('id', p.id, 'name', p.name, 'profile_photo', p.profile_photo) AS last_modified_by
   FROM (public.hh_customers c
     LEFT JOIN public.profiles p ON ((c.modified_by = p.id)));


create or replace view "public"."v_harvesthub_dashboard_stats" as  WITH current_metrics AS (
         SELECT count(*) FILTER (WHERE (hh_customers.status = 'Active Customer'::public.hh_customer_status_enum)) AS active_count,
            count(*) FILTER (WHERE (hh_customers.status = 'Cancelled'::public.hh_customer_status_enum)) AS churn_count,
            count(*) FILTER (WHERE (hh_customers.status = 'Signed Up'::public.hh_customer_status_enum)) AS pending_count,
            sum(hh_customers.total_amount_invoiced) FILTER (WHERE ((hh_customers.status = 'Active Customer'::public.hh_customer_status_enum) AND (hh_customers.billing_terms = 'monthly'::public.hh_billing_terms_enum))) AS current_mrr,
            ((COALESCE(sum(hh_customers.total_amount_invoiced) FILTER (WHERE ((hh_customers.status = 'Active Customer'::public.hh_customer_status_enum) AND (hh_customers.billing_terms = 'monthly'::public.hh_billing_terms_enum))), (0)::numeric) * (12)::numeric) + COALESCE(sum(hh_customers.total_amount_invoiced) FILTER (WHERE ((hh_customers.status = 'Active Customer'::public.hh_customer_status_enum) AND (hh_customers.billing_terms = 'yearly'::public.hh_billing_terms_enum))), (0)::numeric)) AS current_arr
           FROM public.hh_customers
        ), previous_metrics AS (
         SELECT count(*) FILTER (WHERE (hh_customers.status = 'Active Customer'::public.hh_customer_status_enum)) AS active_count,
            count(*) FILTER (WHERE (hh_customers.status = 'Cancelled'::public.hh_customer_status_enum)) AS churn_count,
            count(*) FILTER (WHERE (hh_customers.status = 'Signed Up'::public.hh_customer_status_enum)) AS pending_count,
            sum(hh_customers.total_amount_invoiced) FILTER (WHERE ((hh_customers.status = 'Active Customer'::public.hh_customer_status_enum) AND (hh_customers.billing_terms = 'monthly'::public.hh_billing_terms_enum))) AS mrr,
            ((COALESCE(sum(hh_customers.total_amount_invoiced) FILTER (WHERE ((hh_customers.status = 'Active Customer'::public.hh_customer_status_enum) AND (hh_customers.billing_terms = 'monthly'::public.hh_billing_terms_enum))), (0)::numeric) * (12)::numeric) + COALESCE(sum(hh_customers.total_amount_invoiced) FILTER (WHERE ((hh_customers.status = 'Active Customer'::public.hh_customer_status_enum) AND (hh_customers.billing_terms = 'yearly'::public.hh_billing_terms_enum))), (0)::numeric)) AS arr
           FROM public.hh_customers
          WHERE (hh_customers.created_at <= (now() - '30 days'::interval))
        ), contribution_stats AS (
         SELECT count(*) FILTER (WHERE (hh_contributions.created_at >= date_trunc('month'::text, now()))) AS current_month_count,
            count(*) FILTER (WHERE ((hh_contributions.created_at >= date_trunc('month'::text, (now() - '1 mon'::interval))) AND (hh_contributions.created_at < date_trunc('month'::text, now())))) AS last_month_count
           FROM public.hh_contributions
        )
 SELECT c.active_count AS active_customers,
    c.churn_count AS churned_customers,
    c.pending_count AS pending_conversions,
    COALESCE(c.current_mrr, (0)::numeric) AS mrr,
    COALESCE(c.current_arr, (0)::numeric) AS arr,
    con.current_month_count AS this_months_contributions,
    (c.active_count - p.active_count) AS active_change,
    (c.churn_count - p.churn_count) AS churn_change,
    (c.pending_count - p.pending_count) AS pending_conversion_change,
    (COALESCE(c.current_mrr, (0)::numeric) - COALESCE(p.mrr, (0)::numeric)) AS mrr_change,
    (COALESCE(c.current_arr, (0)::numeric) - COALESCE(p.arr, (0)::numeric)) AS arr_change,
    (con.current_month_count - con.last_month_count) AS contributions_change
   FROM current_metrics c,
    previous_metrics p,
    contribution_stats con;


create or replace view "public"."v_harvesthub_prospect_customers_datagrid" as  SELECT hh_prospect_customers.id,
    hh_prospect_customers.name,
    hh_prospect_customers.company,
    hh_prospect_customers.title,
    hh_prospect_customers.email,
    hh_prospect_customers.phone,
    hh_prospect_customers.contact_source,
    hh_prospect_customers.conversion_status,
    hh_prospect_customers.product_interest,
    hh_prospect_customers.customer_inquiry_source,
    hh_prospect_customers.interested_use_cases,
    hh_prospect_customers.inquiry_message,
    hh_prospect_customers.internal_notes,
    hh_prospect_customers.followed_up,
    hh_prospect_customers.linkedin_url,
    hh_prospect_customers.business_card_image,
    hh_prospect_customers.customer_id,
    hh_prospect_customers.is_active,
    hh_prospect_customers.created_at,
    hh_prospect_customers.updated_at
   FROM public.hh_prospect_customers;


create or replace view "public"."v_hh_customer_activity" as  SELECT c.id,
    c.name,
    c.company,
    c.email,
    c.status,
    c.created_at AS signup_date,
    count(DISTINCT jcmc.master_category_id) AS categories_count,
    count(DISTINCT jccr.category_review_id) AS reviews_subscribed,
    count(DISTINCT cont.id) AS total_contributions,
    max(cont.created_at) AS last_contribution_date,
    count(DISTINCT cr.account) AS retailers_involved
   FROM ((((public.hh_customers c
     LEFT JOIN public.jt_hh_customers_master_categories jcmc ON ((c.id = jcmc.customer_id)))
     LEFT JOIN public.jt_hh_customers_category_reviews jccr ON ((c.id = jccr.customer_id)))
     LEFT JOIN public.master_category_review_data cr ON ((jccr.category_review_id = cr.id)))
     LEFT JOIN public.hh_contributions cont ON ((c.id = cont.customer_id)))
  GROUP BY c.id, c.name, c.company, c.email, c.status, c.created_at;


create or replace view "public"."v_hh_upcoming_deadlines" as  SELECT cr.id,
    cr.display_name,
    cr.account,
    cr.retailer_category,
    cr.retailer_review_timing,
    cr.reset_date,
    cr.review_type,
    cr.retailer_review_date,
    cr.on_shelf_reset_date,
    cr.new_item_submission_deadline,
    cr.master_category_id,
    cr.created_at,
    cr.updated_at,
    cr.archive,
    cr.gnf_sub_category,
    a.account AS account_name,
    a.city,
    a.store_count,
    a.website,
    mc.full_category AS gnf_category,
    string_agg(DISTINCT c.name, ', '::text) AS customer_names,
    string_agg(DISTINCT c.email, ', '::text) AS customer_emails,
    (cr.new_item_submission_deadline - CURRENT_DATE) AS days_until_deadline
   FROM ((((public.master_category_review_data cr
     JOIN public.accounts a ON ((cr.account = a.uuid)))
     LEFT JOIN public.master_categories mc ON ((cr.master_category_id = mc.id)))
     LEFT JOIN public.jt_hh_customers_category_reviews jccr ON ((cr.id = jccr.category_review_id)))
     LEFT JOIN public.hh_customers c ON ((jccr.customer_id = c.id)))
  WHERE ((cr.new_item_submission_deadline >= CURRENT_DATE) AND (cr.new_item_submission_deadline <= (CURRENT_DATE + '90 days'::interval)) AND ((cr.archive IS NOT TRUE) OR (cr.archive IS NULL)))
  GROUP BY cr.id, a.account, a.city, a.store_count, a.website, mc.full_category
  ORDER BY cr.new_item_submission_deadline;


create or replace view "public"."v_master_category_review_data" as  SELECT mcrd.id,
    mcrd.display_name,
    mcrd.account AS account_uuid,
    a.cr_calendar AS account_cr_calendar,
    mcrd.retailer_category,
    mcrd.retailer_review_timing,
    mcrd.reset_date,
    mcrd.review_type,
    mcrd.retailer_review_date,
    mcrd.on_shelf_reset_date,
    mcrd.new_item_submission_deadline,
    mcrd.master_category_id,
    mcrd.created_at,
    mcrd.updated_at,
    mcrd.archive,
    mcrd.gnf_sub_category AS gnf_sub_category_uuid,
    mc.full_category AS gnf_sub_category_name
   FROM ((public.master_category_review_data mcrd
     LEFT JOIN public.accounts a ON ((mcrd.account = a.uuid)))
     LEFT JOIN public.master_categories mc ON ((mcrd.gnf_sub_category = mc.id)))
  ORDER BY mcrd.new_item_submission_deadline;


create or replace view "public"."v_my_internal_profile" as  SELECT p.id,
    p.name,
    p.created_at,
    p.brand_id,
    p.department,
    p.user_type,
    p.profile_photo,
    tmg.status,
    tmg.title,
    tmg.address,
    tmg.phone_number,
    tmg.department AS public_department,
    tmg.send_samples,
    tmg.food_handlers_card,
    tmg.calls_counted_by_team_member,
    tmg.counter,
    tmg.email,
    tmg.key_support AS key_accounts,
    tmg.regional_coverage,
    tmg.time_zone,
    tmg.country_of_origin,
    tmg.language_spoken
   FROM (public.profiles p
     LEFT JOIN public.team_member_guide tmg ON ((p.id = tmg.uuid)))
  WHERE (p.id = auth.uid());


create or replace view "public"."v_program_connects_by_month" as  SELECT sa.id AS sos_authorization_id,
    b.brand AS brand_name,
    sa.calling_month,
    sa.calling_year,
    sum(COALESCE(at.connect_count, 0)) AS connects_achieved,
    concat(b.brand, ' - ', sa.calling_month, ' - ', sa.calling_year, ' - ', sum(COALESCE(at.connect_count, 0))) AS program_summary_name
   FROM ((public.sos_authorizations sa
     LEFT JOIN public.activity_tracker at ON ((at.sos_authorizations = sa.id)))
     LEFT JOIN public.brands b ON ((sa.brand = b.id)))
  WHERE ((at.connect_stage)::text ~~* 'Connect%'::text)
  GROUP BY sa.id, b.brand, sa.calling_month, sa.calling_year;


create or replace view "public"."v_retailer_categories_with_gn_mappings" as  SELECT rgcm.id AS retailer_category_id,
    a.account AS retailer_name,
    rgcm.retailer_category_name,
    rgcm.unique_category_name,
    rgcm.category_name_from_excel,
    array_agg(mc.category ORDER BY mc.category) FILTER (WHERE (mc.category IS NOT NULL)) AS gn_categories,
    array_agg(mc.full_category ORDER BY mc.category) FILTER (WHERE (mc.full_category IS NOT NULL)) AS gn_full_categories,
    count(mc.id) AS gn_category_count,
    rgcm.created_at,
    rgcm.updated_at
   FROM (((public.retailer_gnf_category_matching rgcm
     LEFT JOIN public.accounts a ON ((rgcm.account = a.uuid)))
     LEFT JOIN public.jt_retailer_category_to_gn_categories jt ON ((rgcm.id = jt.retailer_category_id)))
     LEFT JOIN public.master_categories mc ON ((jt.gn_category_id = mc.id)))
  GROUP BY rgcm.id, a.account, rgcm.retailer_category_name, rgcm.unique_category_name, rgcm.category_name_from_excel, rgcm.created_at, rgcm.updated_at;


create or replace view "public"."v_review_data_comprehensive" as  SELECT DISTINCT mcrd.id AS review_data_id,
    mcrd.display_name AS review_name,
    mcrd.retailer_category,
    mcrd.retailer_review_timing,
    mcrd.review_type,
    mcrd.new_item_submission_deadline,
    mcrd.reset_date,
    mcrd.retailer_review_date,
    mcrd.on_shelf_reset_date,
    a.account AS account_name,
    a.city AS account_city,
    b.id AS brand_id,
    b.brand AS brand_name,
    rgcm.id AS matching_id,
    rgcm.retailer_category_name,
    rgcm.unique_category_name,
    mc.category AS master_category,
    mc.full_category AS master_full_category
   FROM ((((((public.master_category_review_data mcrd
     LEFT JOIN public.accounts a ON ((mcrd.account = a.uuid)))
     LEFT JOIN public.master_categories mc ON ((mcrd.master_category_id = mc.id)))
     LEFT JOIN public.jt_master_category_review_data_brands jtb ON ((mcrd.id = jtb.review_data_id)))
     LEFT JOIN public.brands b ON ((jtb.brand_id = b.id)))
     LEFT JOIN public.jt_master_category_review_data_matching jtm ON ((mcrd.id = jtm.review_data_id)))
     LEFT JOIN public.retailer_gnf_category_matching rgcm ON ((jtm.retailer_matching_id = rgcm.id)));


create or replace view "public"."v_review_data_with_brands" as  SELECT mcrd.id AS review_data_id,
    mcrd.display_name AS review_name,
    mcrd.retailer_category,
    mcrd.retailer_review_timing,
    mcrd.review_type,
    mcrd.new_item_submission_deadline,
    a.account AS account_name,
    a.city AS account_city,
    b.id AS brand_id,
    b.brand AS brand_name,
    b.manufacturer_name,
    jt.created_at AS brand_relationship_created_at
   FROM (((public.master_category_review_data mcrd
     LEFT JOIN public.accounts a ON ((mcrd.account = a.uuid)))
     LEFT JOIN public.jt_master_category_review_data_brands jt ON ((mcrd.id = jt.review_data_id)))
     LEFT JOIN public.brands b ON ((jt.brand_id = b.id)));


create or replace view "public"."v_scheduled_demos" as  SELECT d.id,
    d.account_id,
    d.team_member_id,
    COALESCE(((((string_agg(b.brand, ' + '::text) || ' - '::text) || a.account) || ' - '::text) || to_char((d.demo_date)::timestamp with time zone, 'MM/DD/YYYY'::text)), 'Scheduled Demo'::text) AS demo_name,
    d.demo_date,
    d.start_time,
    d.end_time,
    lower(((to_char((d.start_time)::interval, 'FMHH12am'::text) || ' - '::text) || to_char((d.end_time)::interval, 'FMHH12am'::text))) AS formatted_time_range,
    d.demo_status,
    string_agg(b.brand, ' + '::text) AS brands,
    a.account AS store_name,
    tm.name AS demo_team_member,
    tm.email AS team_member_email,
    tm.phone_number,
    tm.address,
    d.time_off_requested,
    d.time_off_request_date,
    d.time_off_notes,
    d.demo_request_type,
    d.requested_timing,
    d.notes_to_demo_team,
    d.notes,
    d.created_at
   FROM ((((public.demos d
     LEFT JOIN public.jt_demo_brands jdb ON ((d.id = jdb.demo_id)))
     LEFT JOIN public.brands b ON ((jdb.brand_id = b.id)))
     LEFT JOIN public.accounts a ON ((d.account_id = a.uuid)))
     LEFT JOIN public.team_member_guide tm ON ((d.team_member_id = tm.uuid)))
  WHERE (d.demo_status = ANY (ARRAY['Requested'::public.demo_status_enum, 'Store Confirmed'::public.demo_status_enum, 'Inventory Confirmed'::public.demo_status_enum, 'Rescheduled'::public.demo_status_enum]))
  GROUP BY d.id, d.demo_date, d.start_time, d.end_time, d.demo_status, a.account, tm.name, tm.email, tm.phone_number, tm.address, d.time_off_requested, d.time_off_request_date, d.time_off_notes, d.demo_request_type, d.requested_timing, d.notes_to_demo_team, d.notes, d.created_at;


create or replace view "public"."v_sku_category_readable" as  SELECT mc.category AS category_name,
    sps.description AS sku_description,
    spc.brand_product_sku AS sku_id,
    mc.id AS category_id
   FROM ((public.sku_product_category spc
     JOIN public.master_categories mc ON ((mc.id = spc.product_category)))
     JOIN public.spec_price_sheet sps ON ((sps.id = spc.brand_product_sku)));


create or replace view "public"."v_sos_authorizations_extended" as  SELECT sa.id,
    sa.created_at,
    sa.brand AS brand_id,
    sa.program_type,
    sa.program_status,
    sa.calling_month,
    sa.calling_year,
    sa.region,
    sa.goodnow_input,
    sa.program_calling_goals,
    sa.sponsored_connects,
    sa.total_paid_connects_authorized,
    sa.date_billed,
    sa.sos_rep_assigned AS sos_rep_assigned_id,
    sa.calling_lists_from_vendor,
    sa.program,
    sa.connects_achieved,
    b.brand AS brand_name,
    tmg.name AS rep_name,
    tmg.profile_photo AS rep_profile_photo
   FROM ((public.sos_authorizations sa
     LEFT JOIN public.brands b ON ((sa.brand = b.id)))
     LEFT JOIN public.team_member_guide tmg ON ((sa.sos_rep_assigned = tmg.uuid)));


create or replace view "public"."v_sos_authorizations_with_calculated_revenue" as  SELECT sa.id,
    sa.created_at,
    sa.brand,
    sa.program_type,
    sa.program_status,
    sa.calling_month,
    sa.calling_year,
    sa.region,
    sa.goodnow_input,
    sa.program_calling_goals,
    sa.sponsored_connects,
    sa.total_paid_connects_authorized,
    sa.date_billed,
    sa.sos_rep_assigned,
    sa.calling_lists_from_vendor,
    sa.program,
    sa.connects_achieved,
    b.brand AS brand_name,
    (b.sos_sales_rate)::numeric AS sos_sales_rate,
    ((b.sos_sales_rate)::numeric * ((sa.connects_achieved)::numeric - (sa.sponsored_connects)::numeric)) AS sos_revenue
   FROM (public.sos_authorizations sa
     JOIN public.brands b ON ((sa.brand = b.id)));


create or replace view "public"."v_spec_price_sheet" as  SELECT sps.description,
    sps.item_status,
    sps.sales_rank,
    sps.vendor_item_number,
    sps.upc_12_digit,
    sps.ean,
    sps.case_upc,
    sps.master_upc,
    sps.case_pack,
    sps.master_pack,
    sps.unit_height_inches,
    sps.unit_width_inches,
    sps.unit_depth_inches,
    sps.case_height_inches,
    sps.case_width_inches,
    sps.case_depth_inches,
    sps.master_case_height_inches,
    sps.master_case_width_inches,
    sps.master_case_depth_inches,
    sps.net_case_weight_lbs,
    sps.gross_case_weight_lbs,
    sps.master_case_weight_lbs,
    sps.ti,
    sps.hi,
    sps.cube,
    sps.cases_per_pallet,
    sps.pallet_weight_lbs,
    sps.item_temp_reqs,
    sps.fob_location,
    sps.srp,
    sps.direct_ship_available,
    sps.direct_ship_cost_case,
    sps.fob_price_case,
    sps.unit_cost_fob,
    sps.delivered_west_distribution_by_case,
    sps.delivered_east_distribution_by_case,
    sps.minimum_direct_order_quantity,
    sps.minimum_order_quantity_distribution,
    sps.order_lead_time,
    sps.shelf_life_in_days_at_manufacture,
    sps.frozen_shelf_life_if_applicable,
    sps.shelf_life_in_days_guaranteed,
    sps.ingredient_list,
    sps.other_pricing_case,
    sps.other_pricing_notes,
    sps.other_pricing_unit,
    sps.id,
    sps.brand_id,
    sps.updated_at,
    sps.uos,
    sps.uom,
    sps.unique_item_name,
    sps.order_lead_time_to_distributor AS order_lead_time_distributor,
    sps.product_shelf_life_slacked_out,
    sps.best_by_date_indicated,
    sps.organic_certifier_entity,
    sps.organic,
    sps.non_gmo,
    sps.gluten_free,
    sps.vegan,
    sps.vegetarian,
    sps.kosher,
    sps.dairy_free,
    sps.sugar_free,
    sps.soy_free,
    sps.nut_free,
    sps.wheat_free,
    sps.updated_by,
    b.brand AS brand_name,
    sps.updated_at AS last_updated
   FROM (public.spec_price_sheet sps
     LEFT JOIN public.brands b ON ((sps.brand_id = b.id)));


create or replace view "public"."v_tile_cards_upcoming_reviews" as  SELECT tmg.user_id,
    count(DISTINCT mcrd.id) AS upcoming_reviews
   FROM ((((public.master_category_review_data mcrd
     LEFT JOIN public.jt_deal_category_reviews jdcr ON ((mcrd.id = jdcr.category_reviews)))
     LEFT JOIN public.activity_tracker at ON ((jdcr.activity_tracker = at.id)))
     LEFT JOIN public.jt_deal_owners jdo ON ((at.id = jdo.deal_id)))
     LEFT JOIN public.team_member_guide tmg ON ((jdo.team_member_id = tmg.uuid)))
  WHERE ((tmg.user_id IS NOT NULL) AND (mcrd.archive IS NOT TRUE))
  GROUP BY tmg.user_id;


grant delete on table "public"."enum_migration_tracker" to "anon";

grant insert on table "public"."enum_migration_tracker" to "anon";

grant references on table "public"."enum_migration_tracker" to "anon";

grant select on table "public"."enum_migration_tracker" to "anon";

grant trigger on table "public"."enum_migration_tracker" to "anon";

grant truncate on table "public"."enum_migration_tracker" to "anon";

grant update on table "public"."enum_migration_tracker" to "anon";

grant delete on table "public"."enum_migration_tracker" to "authenticated";

grant insert on table "public"."enum_migration_tracker" to "authenticated";

grant references on table "public"."enum_migration_tracker" to "authenticated";

grant select on table "public"."enum_migration_tracker" to "authenticated";

grant trigger on table "public"."enum_migration_tracker" to "authenticated";

grant truncate on table "public"."enum_migration_tracker" to "authenticated";

grant update on table "public"."enum_migration_tracker" to "authenticated";

grant delete on table "public"."enum_migration_tracker" to "service_role";

grant insert on table "public"."enum_migration_tracker" to "service_role";

grant references on table "public"."enum_migration_tracker" to "service_role";

grant select on table "public"."enum_migration_tracker" to "service_role";

grant trigger on table "public"."enum_migration_tracker" to "service_role";

grant truncate on table "public"."enum_migration_tracker" to "service_role";

grant update on table "public"."enum_migration_tracker" to "service_role";


  create policy "Allow authenticated read access to all users"
  on "auth"."users"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Allow individual read access to own user data"
  on "auth"."users"
  as permissive
  for select
  to authenticated
using ((auth.uid() = id));



  create policy "Allow users to view their own data"
  on "auth"."users"
  as permissive
  for select
  to authenticated
using ((auth.uid() = id));


CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


  create policy "Allow listening for broadcasts for authenticated users only"
  on "realtime"."messages"
  as permissive
  for select
  to authenticated
using ((extension = 'broadcast'::text));



  create policy "Allow authenticated deletes"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'brand-onboarding'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Allow authenticated reads"
  on "storage"."objects"
  as permissive
  for select
  to public
using (((bucket_id = 'brand-onboarding'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Allow authenticated uploads"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'brand-onboarding'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Allow authenticated users to upload files 1fnvahb_0"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check ((bucket_id = 'sell-sheets'::text));



  create policy "Allow authenticated users to upload files 1fnvahb_1"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using ((bucket_id = 'sell-sheets'::text));



  create policy "Allow authenticated users to upload files 1fnvahb_2"
  on "storage"."objects"
  as permissive
  for select
  to authenticated
using ((bucket_id = 'sell-sheets'::text));



  create policy "Authenticated Deletes for Principal List Images"
  on "storage"."objects"
  as permissive
  for delete
  to authenticated
using ((bucket_id = 'principal-list-images'::text));



  create policy "Authenticated Updates for Principal List Images"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using ((bucket_id = 'principal-list-images'::text));



  create policy "Authenticated Uploads for Principal List Images"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check ((bucket_id = 'principal-list-images'::text));



  create policy "Give users authenticated access to folder 1wv2skv_0"
  on "storage"."objects"
  as permissive
  for select
  to public
using (((bucket_id = 'task-files'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Give users authenticated access to folder 1wv2skv_1"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'task-files'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Give users authenticated access to folder 1wv2skv_2"
  on "storage"."objects"
  as permissive
  for update
  to public
using (((bucket_id = 'task-files'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Give users authenticated access to folder 1wv2skv_3"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'task-files'::text) AND (auth.role() = 'authenticated'::text)));



  create policy "Public Read Access for Principal List Images"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'principal-list-images'::text));



  create policy "Users can manage their own profile pics"
  on "storage"."objects"
  as permissive
  for all
  to authenticated
using (((bucket_id = 'profile-pics'::text) AND (auth.uid() = owner)))
with check (((bucket_id = 'profile-pics'::text) AND (auth.uid() = owner)));



  create policy "authenticated access to files 1xpe67m_0"
  on "storage"."objects"
  as permissive
  for select
  to authenticated
using ((bucket_id = 'brand-documents'::text));



  create policy "authenticated access to files 1xpe67m_1"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check ((bucket_id = 'brand-documents'::text));



  create policy "authenticated access to files 1xpe67m_2"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using ((bucket_id = 'brand-documents'::text));



  create policy "authenticated access to files 1xpe67m_3"
  on "storage"."objects"
  as permissive
  for delete
  to authenticated
using ((bucket_id = 'brand-documents'::text));



  create policy "full access 1sxagxu_0"
  on "storage"."objects"
  as permissive
  for select
  to authenticated
using ((bucket_id = 'comment-attachments'::text));



  create policy "full access 1sxagxu_1"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check ((bucket_id = 'comment-attachments'::text));



  create policy "full access 1sxagxu_2"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using ((bucket_id = 'comment-attachments'::text));



  create policy "public access to view via public link  1wv2skv_0"
  on "storage"."objects"
  as permissive
  for select
  to anon
using ((bucket_id = 'task-files'::text));



