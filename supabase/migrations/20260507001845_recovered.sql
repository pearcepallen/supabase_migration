SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
CREATE SCHEMA IF NOT EXISTS "airtable";
ALTER SCHEMA "airtable" OWNER TO "postgres";
CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";
CREATE SCHEMA IF NOT EXISTS "harvest hub";
ALTER SCHEMA "harvest hub" OWNER TO "postgres";
CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pgsodium";
COMMENT ON SCHEMA "public" IS 'standard public schema';
CREATE EXTENSION IF NOT EXISTS "http" WITH SCHEMA "public";
CREATE EXTENSION IF NOT EXISTS "hypopg" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "index_advisor" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pg_trgm" WITH SCHEMA "public";
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "wrappers" WITH SCHEMA "extensions";
CREATE TYPE "public"."Active Services" AS ENUM (
    'GoodNow',
    'SOS Program',
    'Demo Program',
    'GoodNow Pets',
    'Former Demo Program [Delete]',
    'Former SOS Program [Delete]',
    'Former GoodNow [Delete]',
    'Costco',
    'GoodNow App License',
    'WTSB',
    'Private Label',
    'Food Service',
    'Alt Channel'
);
ALTER TYPE "public"."Active Services" OWNER TO "postgres";
CREATE TYPE "public"."Announcement Tag" AS ENUM (
    'Announcement',
    'Staff Update',
    'Platform Update',
    'Tradeshows',
    'New Feature',
    'Program Update',
    'Partner Highlight',
    'Policy or Terms Update'
);
ALTER TYPE "public"."Announcement Tag" OWNER TO "postgres";
COMMENT ON TYPE "public"."Announcement Tag" IS 'Tag a description ';
CREATE TYPE "public"."Audience" AS ENUM (
    'GoodNow Agency',
    'SOS Only Customers',
    'Demo Only Customers',
    'Internal Only',
    'HarvestHub Customers'
);
ALTER TYPE "public"."Audience" OWNER TO "postgres";
COMMENT ON TYPE "public"."Audience" IS 'Choose an audience who company announcements are for';
CREATE TYPE "public"."Brand Contact Tags" AS ENUM (
    'Main Contact',
    'Secondary Contact',
    'Accounting',
    'Samples',
    'Marketing',
    'Operations'
);
ALTER TYPE "public"."Brand Contact Tags" OWNER TO "postgres";
COMMENT ON TYPE "public"."Brand Contact Tags" IS 'Contacts can tag the types of departments they over see';
CREATE TYPE "public"."Brand Status" AS ENUM (
    'Onboarding',
    'Active',
    'SOS Program - Depricated',
    'Demo Program - Depricated',
    'Priority',
    'Private Label - Depricated',
    'Sustaining (Commission)',
    'Low Comm - Depricated',
    'In Cancellation',
    'Commission',
    'Pause time TBD - Depricated',
    'Demo Request Time Off',
    'Pause TBD',
    'Former GoodNow Vendor',
    'Special',
    'Prospect',
    'Former Demo Vendor',
    'Former SOS Vendor',
    'New to Market',
    'Former HH Vendor'
);
ALTER TYPE "public"."Brand Status" OWNER TO "postgres";
CREATE TYPE "public"."Call Preferences" AS ENUM (
    'Never Call',
    'Call for SOS Only',
    'Call for GoodNow Brands Only'
);
ALTER TYPE "public"."Call Preferences" OWNER TO "postgres";
COMMENT ON TYPE "public"."Call Preferences" IS 'Tag accounts that should be flagged for no outreach and reason.';
CREATE TYPE "public"."Category Review Types" AS ENUM (
    'Update/Minor Reset',
    'Full/Major Reset',
    'Seasonal Review',
    'Schematic',
    'Open',
    'Other'
);
ALTER TYPE "public"."Category Review Types" OWNER TO "postgres";
COMMENT ON TYPE "public"."Category Review Types" IS 'Category review classification';
CREATE TYPE "public"."Country" AS ENUM (
    'US',
    'Canada',
    'India',
    'Peru',
    'China',
    'South Africa',
    'Mexico',
    'Australia',
    'France',
    'Japan',
    'New Zealand',
    'South Korea',
    'Spain',
    'Sweden',
    'Taiwan',
    'United Kingdom',
    'CA',
    'AU',
    'GB',
    'CR',
    'QA',
    'CL',
    'PR',
    'MX',
    'DE',
    'NZ',
    'CN',
    'FR',
    'KR',
    'CO',
    'ZA',
    'SE',
    'KY',
    'JP',
    'NL',
    'AE',
    'IN',
    'IE',
    'ES',
    'PH',
    'TW',
    'AD',
    'AF',
    'AG',
    'AL',
    'AM',
    'AO',
    'AR',
    'AT',
    'AZ',
    'BA',
    'BB',
    'BD',
    'BE',
    'BF',
    'BG',
    'BH',
    'BI',
    'BJ',
    'BN',
    'BO',
    'BR',
    'BS',
    'BT',
    'BW',
    'BY',
    'BZ',
    'CD',
    'CF',
    'CG',
    'CH',
    'CI',
    'CM',
    'CU',
    'CV',
    'CY',
    'CZ',
    'DJ',
    'DK',
    'DM',
    'DO',
    'DZ',
    'EC',
    'EE',
    'EG',
    'ER',
    'ET',
    'FI',
    'FJ',
    'FM',
    'GA',
    'GD',
    'GE',
    'GH',
    'GM',
    'GN',
    'GQ',
    'GR',
    'GT',
    'GW',
    'GY',
    'HN',
    'HR',
    'HT',
    'HU',
    'ID',
    'IL',
    'IQ',
    'IR',
    'IS',
    'IT',
    'JM',
    'JO',
    'KE',
    'KG',
    'KH',
    'KI',
    'KM',
    'KN',
    'KP',
    'KW',
    'KZ',
    'LA',
    'LB',
    'LC',
    'LI',
    'LK',
    'LR',
    'LS',
    'LT',
    'LU',
    'LV',
    'LY',
    'MA',
    'MC',
    'MD',
    'ME',
    'MG',
    'MH',
    'MK',
    'ML',
    'MM',
    'MN',
    'MR',
    'MT',
    'MU',
    'MV',
    'MW',
    'MY',
    'MZ',
    'NA',
    'NE',
    'NG',
    'NI',
    'NO',
    'NP',
    'NR',
    'OM',
    'PA',
    'PE',
    'PG',
    'PK',
    'PL',
    'PT',
    'PW',
    'PY',
    'RO',
    'RS',
    'RU',
    'RW',
    'SA',
    'SB',
    'SC',
    'SD',
    'SG',
    'SI',
    'SK',
    'SL',
    'SM',
    'SN',
    'SO',
    'SR',
    'SS',
    'ST',
    'SV',
    'SY',
    'SZ',
    'TD',
    'TG',
    'TH',
    'TJ',
    'TL',
    'TM',
    'TN',
    'TO',
    'TR',
    'TT',
    'TV',
    'TZ',
    'UA',
    'UG',
    'UY',
    'UZ',
    'VC',
    'VE',
    'VN',
    'VU',
    'WS',
    'YE',
    'ZM',
    'ZW'
);
ALTER TYPE "public"."Country" OWNER TO "postgres";
CREATE TYPE "public"."Coverage" AS ENUM (
    'West',
    'East',
    'National',
    'SoPac'
);
ALTER TYPE "public"."Coverage" OWNER TO "postgres";
CREATE TYPE "public"."Demo_special_customer_enum" AS ENUM (
    'NWG',
    'POD'
);
ALTER TYPE "public"."Demo_special_customer_enum" OWNER TO "postgres";
CREATE TYPE "public"."Department Tags (Deprecated) RH" AS ENUM (
    'HABA',
    'Frozen',
    'Grocery',
    'Private Label'
);
ALTER TYPE "public"."Department Tags (Deprecated) RH" OWNER TO "postgres";
COMMENT ON TYPE "public"."Department Tags (Deprecated) RH" IS 'Departments contacts works in ';
CREATE TYPE "public"."Departments" AS ENUM (
    'Sales',
    'Demo Support',
    'Data & Admin',
    'Brand & Marketing',
    'SOS Program (Inside Sales)'
);
ALTER TYPE "public"."Departments" OWNER TO "postgres";
CREATE TYPE "public"."Distribution Status" AS ENUM (
    'Target',
    'In Setup',
    'Active w/Inventory',
    'Active; No Inventory',
    'Discontinued'
);
ALTER TYPE "public"."Distribution Status" OWNER TO "postgres";
CREATE TYPE "public"."Distributor Account Type" AS ENUM (
    'Distributor - HQ',
    'Distributor'
);
ALTER TYPE "public"."Distributor Account Type" OWNER TO "postgres";
CREATE TYPE "public"."Effective Promo Month" AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
);
ALTER TYPE "public"."Effective Promo Month" OWNER TO "postgres";
CREATE TYPE "public"."Fulfillment Method " AS ENUM (
    'Direct',
    'Distributor DC'
);
ALTER TYPE "public"."Fulfillment Method " OWNER TO "postgres";
COMMENT ON TYPE "public"."Fulfillment Method " IS 'Type of distribution for how each SKU is fulfilled and delivered to accounts.';
CREATE TYPE "public"."GoodNow Event Participation Status" AS ENUM (
    'Participating - Booth Share',
    'Participating - No Booth',
    'Not Participating',
    'Undecided',
    'Interested',
    'Confirmed & Paid - Delete',
    'Own Booth - Delete',
    'GNF Sponsored - Delete',
    'Special Program - Delete',
    'Waitlist - Delete',
    'Fundmatch - GNF Reimburse - Delete',
    'Notify if Last Minute Available - Delete',
    'Invited - delete',
    'Participating',
    'Attending - No Booth'
);
ALTER TYPE "public"."GoodNow Event Participation Status" OWNER TO "postgres";
CREATE TYPE "public"."No Contact Details" AS ENUM (
    'Not Found on Zoom Info',
    'Not Found on LinkedIn',
    'Not Found on OverSee',
    'Contact No Longer There; Remove'
);
ALTER TYPE "public"."No Contact Details" OWNER TO "postgres";
COMMENT ON TYPE "public"."No Contact Details" IS 'Data integrity helper filed indicating where we haven''t been able to locate a contact. ';
CREATE TYPE "public"."Principal List Status" AS ENUM (
    'Added To Principal List',
    'Not Added',
    'Active'
);
ALTER TYPE "public"."Principal List Status" OWNER TO "postgres";
COMMENT ON TYPE "public"."Principal List Status" IS 'Select this option to push the brand to live principal list';
CREATE TYPE "public"."Promo Delivery" AS ENUM (
    'All Types',
    'Distributor',
    'DSD',
    'Other'
);
ALTER TYPE "public"."Promo Delivery" OWNER TO "postgres";
CREATE TYPE "public"."Promo Department (?)" AS ENUM (
    'All',
    'Grocery',
    'Beer/Wine/Alcohol',
    'HABA',
    'Natural',
    'Other'
);
ALTER TYPE "public"."Promo Department (?)" OWNER TO "postgres";
CREATE TYPE "public"."Promo Year" AS ENUM (
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030'
);
ALTER TYPE "public"."Promo Year" OWNER TO "postgres";
CREATE TYPE "public"."Quarter" AS ENUM (
    'Q1',
    'Q2',
    'Q3',
    'Q4'
);
ALTER TYPE "public"."Quarter" OWNER TO "postgres";
CREATE TYPE "public"."Submission Type (Deprecated, only one type)" AS ENUM (
    'Account Submission',
    'TO Form',
    'Promotion'
);
ALTER TYPE "public"."Submission Type (Deprecated, only one type)" OWNER TO "postgres";
COMMENT ON TYPE "public"."Submission Type (Deprecated, only one type)" IS 'Submission types that are viewed in the submissions history';
CREATE TYPE "public"."account_type" AS ENUM (
    'Chain - Account HQ',
    'Chain - Single Location',
    'Distributor - Single DC',
    'Distributor - HQ',
    'Food Service - Chain',
    'Food Service - Independent',
    'Food Service - Key Account',
    'Independent A',
    'Independent B',
    'Independent C',
    'Other',
    'Retailer: Cafe/Restaurant & Market',
    'Services',
    'Temporarily Closed',
    'Permanently Closed',
    'Vendor'
);
ALTER TYPE "public"."account_type" OWNER TO "postgres";
CREATE TYPE "public"."account_type_enum" AS ENUM (
    'Chain - Account HQ',
    'Chain - Single Location',
    'Distributor',
    'Distributor - HQ',
    'Food Service - Chain',
    'Food Service - Independent',
    'Independent A',
    'Independent B',
    'Independent C',
    'Temporarily Closed',
    'Services',
    'Other'
);
ALTER TYPE "public"."account_type_enum" OWNER TO "postgres";
CREATE TYPE "public"."activity_type_enum" AS ENUM (
    'GNF Deal',
    'SOS Program',
    'SOS Only Program',
    'Placeholder',
    '---'
);
ALTER TYPE "public"."activity_type_enum" OWNER TO "postgres";
CREATE TYPE "public"."attendance_status_enum" AS ENUM (
    'Interested',
    'Confirmed',
    'Paid',
    'Own Booth',
    'Notify – Last Minute Discount',
    'Verbal Commitment - Delete',
    'GNF Sponsored',
    'Attending - No Booth',
    'Not Participating',
    'Waitlist',
    'Notify if Last Minute Availabile'
);
ALTER TYPE "public"."attendance_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."attention_flag_enum" AS ENUM (
    'Needs Review',
    'Pending Follow-Up',
    'Internal Discussion',
    'Stalled Progress',
    'Incomplete Materials'
);
ALTER TYPE "public"."attention_flag_enum" OWNER TO "postgres";
CREATE TYPE "public"."best_by_enum" AS ENUM (
    'MM/DD/YYYY',
    'DD/MM/YYYY',
    'MM/YYYY',
    'MM/YY',
    'MM/DD/YY',
    'DD/MM/YY'
);
ALTER TYPE "public"."best_by_enum" OWNER TO "postgres";
CREATE TYPE "public"."brand_promo_approval (delete)" AS ENUM (
    'Pending',
    'Approved',
    'Declined'
);
ALTER TYPE "public"."brand_promo_approval (delete)" OWNER TO "postgres";
CREATE TYPE "public"."brand_task_source" AS ENUM (
    'Onboarding task',
    'Custom task'
);
ALTER TYPE "public"."brand_task_source" OWNER TO "postgres";
COMMENT ON TYPE "public"."brand_task_source" IS 'template The task was automatically created based on the brand’s service (Sales Agency, SOS, Demos). These are the standard onboarding tasks every brand in that program needs.  one_off A unique, manually-added task created by the team. Example: “Upload new product photography” or “Update sell sheet for Q2.”  This distinction lets you keep reporting clean (e.g., “What % of required onboarding tasks are done?” vs “What extra tasks did we assign?”).';
CREATE TYPE "public"."brand_task_status" AS ENUM (
    'Completed',
    'In Progress',
    'Not Started',
    'Blocked'
);
ALTER TYPE "public"."brand_task_status" OWNER TO "postgres";
COMMENT ON TYPE "public"."brand_task_status" IS 'Status of tasks assigned to brands';
CREATE TYPE "public"."category_enum (deprecated?)" AS ENUM (
    'Grocery',
    'Frozen',
    'Dairy/Wall Refrigeration',
    'Bakery',
    'Deli/Cheese',
    'Prepared Foods',
    'Meat & Seafood',
    'Bulk',
    'Seasonal',
    'Produce',
    'Beer Wine and Spirits',
    'Health & Beauty',
    'General Merchandise',
    'Floral and Gifts',
    'Private Label',
    'Grocery - Snacks - Dried Fruit and Freeze Dried Fruit',
    'Grocery - Powdered Drink Mixes/Hot Cocoa',
    'Grocery - SS Cakes and Sweets',
    'Deli/Cheese - Cheddars',
    'Grocery - SS Condiments and Salad Dressing',
    'Grocery - Cocktail/Drink Mixes',
    'Grocery - SS Juice and other Aseptic Beverages',
    'Grocery - Baking - Fruits Dried and RTS',
    'Grocery - Cookies',
    'Deli/Cheese - Soft Cheese',
    'Grocery - Candy - Chocolate',
    'Grocery - SS Functional/Isotonic Beverages',
    'Grocery - SS Dips and Salsas',
    'Grocery - SS Sodas and Sparkling Juices',
    'Grocery - Snacks - Other',
    'Bakery - Bakery/Other',
    'Deli/Cheese - Semi-Firm/Firm Cheese',
    'Grocery - Baking - Flours',
    'Dairy/Wall Refrigeration -  Refrig. Coffee and Tea',
    'Dairy/Wall Refrigeration -  Refrig. Juice',
    'Grocery - Wholesome Bars and Snacks',
    'Grocery - Grocery All',
    'Deli/Cheese - Deli - Other',
    'Prepared Foods - Fresh  G&G Meals',
    'Grocery - Baking Mixes/Desserts',
    'Grocery - Snacks - Plant Based',
    'Deli/Cheese - Fresh/Deli Condeminents',
    'Seasonal - Deli - Holiday/Misc',
    'Grocery - Cereals Hot',
    'Grocery - Misc. Grocery',
    'Seasonal - Deli - Fall',
    'Grocery - Baking Ingredients',
    'Grocery - Oils - Plant Fats',
    'Seasonal - Deli - Spring',
    'Grocery - Packaged Beans/Legumes',
    'Dairy/Wall Refrigeration -  Refrig. Juice',
    'Dairy/Wall Refrigeration -  Refrig. Coffee and Tea',
    'Grocery - Baking Misc.',
    'Seasonal - Deli - Winter',
    'Grocery - Packaged Rice/Grains',
    'Grocery - SS RTD Coffee and Teas',
    'Grocery - Misc. SS Beverage',
    'Health & Beauty - Diet, Lifestyle, Wellness',
    'Beer Wine Spirits - Mixers, Tonics, Garnishes',
    'Grocery - Packaged Teas/Coffee Alternatives',
    'Grocery - Pasta/Pizza Sauces',
    'Bulk - Bulk Coffee/Tea',
    'General Merchandise - Misc. Household'
);
ALTER TYPE "public"."category_enum (deprecated?)" OWNER TO "postgres";
CREATE TYPE "public"."category_review_status_enum (deprecated?)" AS ENUM (
    'Submitted',
    'Target Submission',
    'Target Resubmission',
    'Account Not Reviewing',
    'Brand Declined Review'
);
ALTER TYPE "public"."category_review_status_enum (deprecated?)" OWNER TO "postgres";
CREATE TYPE "public"."connect_enum (deprecated?)" AS ENUM (
    'No Connect - Follow Up',
    'No Connect - Store Closed',
    'No Connect - Duplicate',
    'Connect - No Interest Right Now',
    'Connect - Sample Requested',
    'Connect - Samples Follow Up',
    'Connect - Info Requested',
    'Connect - Follow Up',
    'Connect - Pending Order',
    'Connect - Active',
    'Connect - Corporate Order Placed',
    'Connect - Dist. Order Placed',
    'Connect - Direct Order Placed',
    'Connect - Order Placed',
    'No Connect - Active',
    'SOS - Call Back',
    'SOS - Duplicate',
    'Connect - Order Requested',
    'TO Order Submitted',
    'Order Submitted'
);
ALTER TYPE "public"."connect_enum (deprecated?)" OWNER TO "postgres";
CREATE TYPE "public"."deal_stage_enum" AS ENUM (
    'Lead',
    'Target',
    'Active',
    'Presenting',
    'Presenting - Buyer Introduction',
    'Presenting - Buyer Engagement / Meeting',
    'Presenting - Post Review Follow-Up',
    'Approved: in Setup',
    'Passed for now',
    'Not in Scope',
    'Discontinued',
    'Not A Target',
    'N/A',
    'Connect - Info Requested',
    'Connect - Sample Requested',
    'Connect - No Interest Right Now',
    'Connect - Samples Follow Up',
    'Connect - Active',
    'Connect - Follow Up',
    'Connect - Pending Order',
    'Connect - Dist. Order Placed',
    'Connect - Direct Order Placed',
    'Connect - Corporate Order Placed',
    'No Connect - Follow Up',
    'No Connect - Duplicate',
    'No Connect - Store Closed',
    'SOS Follow Up',
    'SOS - Call Back',
    'SOS - Corporate',
    'SOS - Duplicate',
    'Pending',
    'Not a Target',
    'Standby'
);
ALTER TYPE "public"."deal_stage_enum" OWNER TO "postgres";
CREATE TYPE "public"."decision_level_tag_enum" AS ENUM (
    'Independent Buying Authority',
    'Corporate Level Buying',
    'Promotions Submitted Here'
);
ALTER TYPE "public"."decision_level_tag_enum" OWNER TO "postgres";
CREATE TYPE "public"."default_status_enum (deprecated?)" AS ENUM (
    'Lead',
    'Target',
    'Presenting',
    'Active',
    'Not a Target',
    'Not in Scope',
    'Passed',
    'Discontinued'
);
ALTER TYPE "public"."default_status_enum (deprecated?)" OWNER TO "postgres";
CREATE TYPE "public"."demo_request_type_enum" AS ENUM (
    'single_store',
    'premier_15_stores',
    'premier_plus_30_stores'
);
ALTER TYPE "public"."demo_request_type_enum" OWNER TO "postgres";
CREATE TYPE "public"."demo_status_enum" AS ENUM (
    'Requested',
    'Store Confirmed',
    'Inventory Confirmed',
    'Completed',
    'Cancelled',
    'Rescheduled',
    'Invoiced',
    'Paid Contract',
    'Paid Gnf',
    'Paid - GNF Sponsored',
    'Confirmed',
    'Demo Cancelled'
);
ALTER TYPE "public"."demo_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."documents_received_enum (deprecated?)" AS ENUM (
    'NQV',
    'Spec Sheet',
    'Sell Sheets',
    'Target Accnt. List',
    'Product Images',
    'Product Labels',
    'Pitch Deck',
    'UPC Barcode Images',
    'W9'
);
ALTER TYPE "public"."documents_received_enum (deprecated?)" OWNER TO "postgres";
CREATE TYPE "public"."employee_status_enum" AS ENUM (
    'Active',
    'Former Employee',
    'Activating'
);
ALTER TYPE "public"."employee_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."file_type_enum" AS ENUM (
    'image',
    'document',
    'spreadsheet',
    'presentation',
    'audio',
    'video',
    'archive',
    'code',
    'other'
);
ALTER TYPE "public"."file_type_enum" OWNER TO "postgres";
CREATE TYPE "public"."flag_for_attention_enum" AS ENUM (
    'Account No Longer Exists',
    'Wrong Store Phone',
    'Wrong Account Description',
    'Wrong Account Type or Subtype',
    'Wrong Address',
    'Wrong Distributor(s) Assigned',
    'Duplicate Account - Please Consolidate'
);
ALTER TYPE "public"."flag_for_attention_enum" OWNER TO "postgres";
CREATE TYPE "public"."focus_month_enum" AS ENUM (
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
);
ALTER TYPE "public"."focus_month_enum" OWNER TO "postgres";
CREATE TYPE "public"."folders_enum (?)" AS ENUM (
    'Spec Sheet',
    'Pitch Deck',
    'Lifestyle Images',
    'Product Labels',
    'UPC Barcode Images',
    'POS Materials',
    'Product Images Front',
    'Product Images Back',
    'Brand Planning',
    'Certifications',
    'W9',
    'Vendor Agreements',
    'Category Review Calendar',
    'Category Review Submission',
    'Distribution Strategy',
    'Distribution Agreement',
    'Miscellaneous',
    'Vendor SOS List',
    'Distribution',
    'Retail',
    'Vendor Contracts',
    'Promotional Planning',
    'Reports + Sales Data',
    'Sales',
    'Images',
    'Logo'
);
ALTER TYPE "public"."folders_enum (?)" OWNER TO "postgres";
CREATE TYPE "public"."hh_account_expert_status" AS ENUM (
    'Approved',
    'Reviewing',
    'Not Approved'
);
ALTER TYPE "public"."hh_account_expert_status" OWNER TO "postgres";
CREATE TYPE "public"."hh_billing_terms_enum" AS ENUM (
    'monthly',
    'yearly',
    'hh_sponsored_license'
);
ALTER TYPE "public"."hh_billing_terms_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_community_expert_services_offered" AS ENUM (
    'Accounting/Deduction Management',
    'Branding/Marketing',
    'Certification / Standards Specialist',
    'Co-Packer/Manufacturing',
    'Distribution / Logistics',
    'Fractional Sales Executive',
    'HR',
    'Ingredients Provider',
    'Investor / Financing',
    'Merchandising',
    'Operations',
    'Packaging - Branding',
    'Packaging - Manufacturing',
    'Pricing / Promotional Strategy',
    'Public Relations',
    'Category Management',
    'Vendor Relations',
    'Procurement',
    'Food Service Sales',
    'Business Coaching',
    'Manufacturing',
    'Fundraising',
    'Brand Activation',
    'Go-To-Market Strategy',
    'Brand Partnerships',
    'Trade Show Support',
    'Growth Strategies'
);
ALTER TYPE "public"."hh_community_expert_services_offered" OWNER TO "postgres";
CREATE TYPE "public"."hh_community_expert_status_enum" AS ENUM (
    'Active',
    'Pending - Need Info',
    'dont_feature',
    'Form Submitted - Pending Approval'
);
ALTER TYPE "public"."hh_community_expert_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_contact_source_enum" AS ENUM (
    'Website Inquiry',
    'Prospect Entry',
    'Signed Up',
    'Inquiry Form',
    'Not Interested',
    'Cold Lead'
);
ALTER TYPE "public"."hh_contact_source_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_content_type_enum" AS ENUM (
    'blog_article',
    'product_feature_update',
    'homepage_feature',
    'support_faq',
    'contribution_guideline',
    'home_page_asset'
);
ALTER TYPE "public"."hh_content_type_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_customer_inquiry_source" AS ENUM (
    'Web Search',
    'Referral',
    'Social Media',
    'Other',
    'StartupCPG Post'
);
ALTER TYPE "public"."hh_customer_inquiry_source" OWNER TO "postgres";
CREATE TYPE "public"."hh_customer_inquiry_use_cases" AS ENUM (
    'Buyer and account information for independent stores',
    'Buyer and account information for chain accounts',
    'Category review calendar information',
    'Other',
    'Buyer information for key accounts',
    'Information and contacts to independent stores'
);
ALTER TYPE "public"."hh_customer_inquiry_use_cases" OWNER TO "postgres";
CREATE TYPE "public"."hh_customer_status_enum" AS ENUM (
    'Active Customer',
    'Former Customer; Cancelled',
    'Onboarding',
    'Cancelled',
    'Customer Order Form Submitted',
    'Declined Services',
    'In Cancellation',
    'Admin User',
    'Payments On Pause',
    'Signed Up',
    'Failed',
    'On Pause',
    'Payment Pending'
);
ALTER TYPE "public"."hh_customer_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_deal_priority_enum" AS ENUM (
    'Low',
    'Medium',
    'High'
);
ALTER TYPE "public"."hh_deal_priority_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_deal_stage_enum" AS ENUM (
    'Target',
    'Presenting',
    'Active',
    'Passed'
);
ALTER TYPE "public"."hh_deal_stage_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_expert_services" AS ENUM (
    'Drop off samples',
    'Submission review',
    'Form preparation',
    'Promotional planning',
    'Present on your behalf',
    'Take photos on shelf (Your brand competition sets)',
    'Meet buyer in person'
);
ALTER TYPE "public"."hh_expert_services" OWNER TO "postgres";
CREATE TYPE "public"."hh_license_status_enum" AS ENUM (
    'Active Product',
    'In development',
    'Deprecated Product'
);
ALTER TYPE "public"."hh_license_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_payment_status_enum" AS ENUM (
    'succeeded',
    'failed'
);
ALTER TYPE "public"."hh_payment_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_product_category_enum (?)" AS ENUM (
    'grocery',
    'frozen',
    'dairy_wall_refrigeration',
    'bakery',
    'deli_cheese',
    'prepared_foods',
    'meat_seafood',
    'bulk',
    'seasonal',
    'produce',
    'beer_wine_spirits',
    'health_beauty',
    'general_merchandise',
    'floral_gifts',
    'private_label'
);
ALTER TYPE "public"."hh_product_category_enum (?)" OWNER TO "postgres";
CREATE TYPE "public"."hh_product_interest_enum" AS ENUM (
    'Nationwide Harvest Plan™',
    'Category Review Access™',
    'Contributor Growth Plan™',
    'Faire Access™'
);
ALTER TYPE "public"."hh_product_interest_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_user_role_enum" AS ENUM (
    'user',
    'admin'
);
ALTER TYPE "public"."hh_user_role_enum" OWNER TO "postgres";
CREATE TYPE "public"."hh_validation_status_enum" AS ENUM (
    'Validated',
    'Pending Review',
    'Incorrect or missing information'
);
ALTER TYPE "public"."hh_validation_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."industry_tag" AS ENUM (
    'Airport',
    'Beer',
    'Boarding',
    'Buying Group',
    'C Store',
    'Clothing',
    'Club',
    'Conventional',
    'Deli',
    'Discount',
    'Drug/Pharmacy',
    'Farm Stand',
    'Fresh',
    'Grocery',
    'HABA',
    'Home Goods',
    'Home/Kitchen',
    'INFRA',
    'Ingredient Supplier',
    'Latino/Hispanic',
    'Liquor Store',
    'Market',
    'Meal Kit',
    'NCG',
    'Natural',
    'Nutritionist',
    'Online',
    'Pet',
    'Recreational',
    'Salon',
    'Spa',
    'Specialty',
    'Spirits',
    'Sporting Facility',
    'Travel',
    'Wine Shop',
    'Café',
    'Food Service',
    'Single Warehouse Location',
    'Baby/Children',
    'Other',
    'Fish',
    'Restaurant',
    'Hardware',
    'Education',
    'Candy Shop',
    'Gift',
    'Hospital/Medical',
    'Manufacturer',
    'Hotel',
    'Distributor',
    'Gym/Fitness',
    'College',
    'Ice Cream Shop',
    'Co-Op',
    'Catering',
    'Packaging',
    'Drinks',
    'Butcher/Meat Market',
    'Tobacco',
    'Gas Station',
    'Local Chain',
    'Birds',
    'DSD',
    'Italian',
    'General Store',
    'Fish Market',
    'Local',
    'Bulk',
    'Wholesaler',
    'Bar',
    'Golf',
    'Service',
    'Vitamin',
    'Farm/Feed Supplies',
    'Cheese Shop',
    'Coffee',
    'Yoga/Pilates',
    'Nursery/Garden Center',
    'Vegan',
    'Brand',
    'Winery',
    'Regional',
    'Investor',
    'Garden Center',
    'TBD',
    'Hispanic',
    'Import/Export',
    'Marketing',
    'Office Supply',
    'Bakery',
    'Distillery',
    'Finance',
    'Delivery',
    'Office - Food Service',
    'Kosher',
    'Spices',
    'Subscription Service',
    'Juice/Smoothie Bar',
    'Non-Alcoholic (NA)',
    'Asian',
    'Supplements',
    'Seafood',
    'Florist',
    'Cosmetics/Bodycare',
    'Government',
    'Bookstore',
    'Tea',
    'Sales/Broker',
    'Meat',
    'Aquarium',
    'Freight/Logistics',
    'Zoo',
    'Branding',
    'Transportation',
    'Asstd living',
    'Dairy/Farm',
    'Co-Packer',
    'B2B',
    'Shelter',
    'Food Truck/Stand',
    'B Store',
    'Vending',
    'Airline',
    'Indian',
    'African',
    'THC',
    'Chain HQ',
    'Japanese',
    'Produce',
    'Middle Eastern',
    'Greek',
    'Museum',
    'French',
    'Deal Activities',
    'Amish',
    'Bioanalytical laboratory',
    'Filipino',
    'Single Location in Chain Account',
    'European',
    'Dispensaries',
    'Summer Camp',
    'Private Label',
    'Barbecue',
    'Chain - Single Location',
    'Pet Medical',
    'Pet Retail'
);
ALTER TYPE "public"."industry_tag" OWNER TO "postgres";
CREATE TYPE "public"."item_status" AS ENUM (
    'Active - Year Round',
    'Active - Seasonal',
    'Permanently Discontinued',
    'Temporarily Inactive'
);
ALTER TYPE "public"."item_status" OWNER TO "postgres";
CREATE TYPE "public"."kanban_status_enum" AS ENUM (
    'this_week_overdue',
    'next_two_weeks',
    'this_month',
    'to_watch',
    'sos_follow_up'
);
ALTER TYPE "public"."kanban_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."multi_select_regions" AS ENUM (
    'PNW',
    'SoCal',
    'Midwest'
);
ALTER TYPE "public"."multi_select_regions" OWNER TO "postgres";
CREATE TYPE "public"."new_item_tag_enum" AS ENUM (
    'New Arrival!'
);
ALTER TYPE "public"."new_item_tag_enum" OWNER TO "postgres";
CREATE TYPE "public"."notification_status" AS ENUM (
    'unread',
    'read'
);
ALTER TYPE "public"."notification_status" OWNER TO "postgres";
CREATE TYPE "public"."notification_type" AS ENUM (
    'new_comment',
    'task_completed',
    'task_assigned',
    'activity_mention'
);
ALTER TYPE "public"."notification_type" OWNER TO "postgres";
CREATE TYPE "public"."placement_type_enum" AS ENUM (
    'Team-led',
    'Brand-led',
    'Shared'
);
ALTER TYPE "public"."placement_type_enum" OWNER TO "postgres";
CREATE TYPE "public"."priority_enum" AS ENUM (
    'High',
    'Medium',
    'Low'
);
ALTER TYPE "public"."priority_enum" OWNER TO "postgres";
CREATE TYPE "public"."product_status_enum" AS ENUM (
    'Available',
    'Out of Stock',
    'Discontinued'
);
ALTER TYPE "public"."product_status_enum" OWNER TO "postgres";
CREATE TYPE "public"."product_subcategory_enum (principal list)" AS ENUM (
    'Honey',
    'Apple Cider',
    'Apple Juice',
    'Baby Care',
    'Baby Food',
    'Baking Mix',
    'Bath',
    'Beans',
    'Cake',
    'Candy',
    'CBD',
    'Cereal',
    'Cheese',
    'Chips',
    'Chocolate',
    'Coffee',
    'Cookies',
    'Deodorant',
    'Dressings',
    'Dried Fruit',
    'Drink Mixes',
    'Fermented Foods',
    'Fresh Seafood',
    'Frozen Seafood',
    'Functional Beverage',
    'Granola',
    'Hot Sauce',
    'Hummus',
    'Ice Cream',
    'Jerky',
    'Juices',
    'Kefir',
    'Lozenges',
    'N/A Alternative',
    'N/A Wine',
    'Nut Butters',
    'Nuts & Seeds',
    'Olive Oil',
    'Oral Care',
    'Packaged Grains',
    'Packaged Meal',
    'Pasta',
    'Peanut Butter',
    'Pet Care',
    'Pet Food',
    'Pet Treats',
    'Plant Oils',
    'Plant-based wraps',
    'Pre-Sliced Deli Meats',
    'Protein Bars',
    'RTD Beverage',
    'Salsa',
    'Sea Moss',
    'Seasonings',
    'Shampoo',
    'Shelf Stable Creamer',
    'Shelf Stable Fish',
    'Shelf Stable Seafood',
    'Shrubs',
    'Skincare',
    'Snacks',
    'Soup / Chowder',
    'Supplements',
    'Tea',
    'Toothpaste',
    'Water',
    'Wellness Shots'
);
ALTER TYPE "public"."product_subcategory_enum (principal list)" OWNER TO "postgres";
CREATE TYPE "public"."program_status_type" AS ENUM (
    'Active/Placeholder',
    'GNF Input Needed',
    'SOS Input Needed',
    'Planning Meeting Set',
    'List Generation',
    'Call Plan Ready',
    'Calls In Progress',
    'Calls Completed',
    'Report Sent',
    'Invoiced/Closed',
    'GNF Sponsored/Closed',
    'Not Completed',
    'No Program Needed',
    'List Being Generated',
    'Campaign Planning Needed'
);
ALTER TYPE "public"."program_status_type" OWNER TO "postgres";
CREATE TYPE "public"."promo_duration_enum (?)" AS ENUM (
    '1 Week',
    '2 Week',
    '3 Week',
    '4 Week'
);
ALTER TYPE "public"."promo_duration_enum (?)" OWNER TO "postgres";
CREATE TYPE "public"."promo_submissinon_status" AS ENUM (
    'Requested',
    'Missed/Declined',
    'Planned',
    '---',
    'Submitted'
);
ALTER TYPE "public"."promo_submissinon_status" OWNER TO "postgres";
CREATE TYPE "public"."prospect_status" AS ENUM (
    'SOS Cold Lead',
    'SOS Lead',
    'Old Lead',
    'Hot',
    'Warm Lead',
    'Active Customer',
    'Not Interested',
    'Not a Target',
    'Former Vendor'
);
ALTER TYPE "public"."prospect_status" OWNER TO "postgres";
CREATE TYPE "public"."region" AS ENUM (
    'Alaska',
    'Hawaii',
    'Intermountain West',
    'MidAtlantic',
    'Midwest',
    'Northeast',
    'Northern California',
    'Pacific Northwest',
    'Rocky Mountain',
    'South',
    'Southern California',
    'Texas and South Central',
    'International - Other',
    'National',
    'Asia',
    'Canada',
    'International',
    'West',
    'East',
    'Pacific NW',
    'Central',
    'SoCal',
    'NorCal',
    'PNW',
    'Idaho',
    'Montana',
    'Southeast',
    'Texas/Central',
    'Mid-Atlantic',
    'Intermountain',
    'Oregon',
    'Michigan'
);
ALTER TYPE "public"."region" OWNER TO "postgres";
CREATE TYPE "public"."regionas (?)" AS ENUM (
    'Mid-Atlantic',
    'West',
    'East',
    'Southeast',
    'Texas/Central',
    'Central',
    'Oregon',
    'Intermountain'
);
ALTER TYPE "public"."regionas (?)" OWNER TO "postgres";
CREATE TYPE "public"."sales_channel" AS ENUM (
    'Retail',
    'Bulk',
    'Food service',
    'Private label',
    'Food Service'
);
ALTER TYPE "public"."sales_channel" OWNER TO "postgres";
CREATE TYPE "public"."sample_status" AS ENUM (
    'not_sent',
    'sent',
    'received',
    'feedback'
);
ALTER TYPE "public"."sample_status" OWNER TO "postgres";
CREATE TYPE "public"."ship_carrier" AS ENUM (
    'ups',
    'fedex',
    'usps',
    'dhl',
    'other'
);
ALTER TYPE "public"."ship_carrier" OWNER TO "postgres";
CREATE TYPE "public"."sku_deal_status" AS ENUM (
    'Active',
    'Rejected',
    'Pursuing',
    'NULL'
);
ALTER TYPE "public"."sku_deal_status" OWNER TO "postgres";
COMMENT ON TYPE "public"."sku_deal_status" IS 'sku status in relation to the current deal';
CREATE TYPE "public"."sos_call_month" AS ENUM (
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
);
ALTER TYPE "public"."sos_call_month" OWNER TO "postgres";
CREATE TYPE "public"."sos_calling_year" AS ENUM (
    '2023',
    '2024',
    '2025',
    '2026',
    '2027'
);
ALTER TYPE "public"."sos_calling_year" OWNER TO "postgres";
CREATE TYPE "public"."source_type_enum" AS ENUM (
    'gnf_deal_script',
    'sos_deal_script',
    'category_review_auto',
    'manual',
    'auto'
);
ALTER TYPE "public"."source_type_enum" OWNER TO "postgres";
CREATE TYPE "public"."specs_certification_options" AS ENUM (
    'Select updated option',
    'Yes - Certified',
    'Yes - Not Certified'
);
ALTER TYPE "public"."specs_certification_options" OWNER TO "postgres";
CREATE TYPE "public"."states_enum" AS ENUM (
    'AL',
    'AK',
    'AZ',
    'AR',
    'CA',
    'CO',
    'CT',
    'DE',
    'FL',
    'GA',
    'HI',
    'ID',
    'IL',
    'IN',
    'IA',
    'KS',
    'KY',
    'LA',
    'ME',
    'MD',
    'MA',
    'MI',
    'MN',
    'MS',
    'MO',
    'MT',
    'NE',
    'NV',
    'NH',
    'NJ',
    'NM',
    'NY',
    'NC',
    'ND',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VT',
    'VA',
    'WA',
    'WV',
    'WI',
    'WY',
    'DC'
);
ALTER TYPE "public"."states_enum" OWNER TO "postgres";
CREATE TYPE "public"."storage_location" AS ENUM (
    'supabase',
    'onedrive'
);
ALTER TYPE "public"."storage_location" OWNER TO "postgres";
COMMENT ON TYPE "public"."storage_location" IS 'location of the file stored whether supabase or onedrive';
CREATE TYPE "public"."sub_tag" AS ENUM (
    'Buying Group',
    'Convenience (C Stores)',
    'Division in Key Account',
    'Key Account',
    'Local Chain',
    'Online',
    'Regional Chain'
);
ALTER TYPE "public"."sub_tag" OWNER TO "postgres";
CREATE TYPE "public"."task_type_enum" AS ENUM (
    'deal_activity',
    'category_review',
    'internal_task',
    'data',
    'marketing_design',
    'discussion_notes',
    'planned_submission',
    'HarvestHub'
);
ALTER TYPE "public"."task_type_enum" OWNER TO "postgres";
CREATE TYPE "public"."transport_enum" AS ENUM (
    'Dry',
    'Ambient',
    'Truck',
    'Chill',
    'cool & dry',
    'Cooler',
    'Refrig',
    'Frozen',
    'Haz-Mat',
    'LTL/FTL',
    'Freezer',
    'Refrigerated',
    'Dry/Ambient',
    'Transport',
    'Direct Ship Available',
    'YES',
    'Climate Controlled',
    'Room Temp',
    'Cold',
    'Shelf Stable',
    '1.875lbs'
);
ALTER TYPE "public"."transport_enum" OWNER TO "postgres";
CREATE TYPE "public"."uom_enum" AS ENUM (
    'oz',
    'fl oz',
    '--',
    'gal',
    'liter',
    'pint',
    'qt',
    'ml',
    'lb',
    'grams',
    'ea',
    'ct',
    'pt',
    'pk',
    'g',
    'L'
);
ALTER TYPE "public"."uom_enum" OWNER TO "postgres";
COMMENT ON TYPE "public"."uom_enum" IS 'unit of measurement';
CREATE TYPE "public"."user_type" AS ENUM (
    'gnf',
    'vendor',
    'harvesthub'
);
ALTER TYPE "public"."user_type" OWNER TO "postgres";
COMMENT ON TYPE "public"."user_type" IS 'type of user shared among each app';
CREATE TYPE "public"."verification_status" AS ENUM (
    'Contact No Longer There; Remove',
    'Wrong / Invalid Phone',
    'Wrong / Invalid Email',
    'Wrong Department'
);
ALTER TYPE "public"."verification_status" OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."(deprecated) handle_account_distributor_sync"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN
  IF (TG_OP = 'DELETE') THEN
    -- When an account is deleted, remove its distributor entry.
    DELETE FROM ref_distributor
    WHERE account_id = OLD.uuid;

  ELSIF (TG_OP = 'UPDATE') THEN
    IF (NEW.account_type IN ('Distributor', 'Distributor - HQ')) THEN
      -- Insert or update id and distributor
      INSERT INTO ref_distributor (account_id, distributor)
      VALUES (NEW.uuid, NEW.account)
      ON CONFLICT (account_id)
      DO UPDATE SET
        distributor = EXCLUDED.distributor;
    ELSE
      -- If the Account_Type is changed to a non-distributor type, remove any distributor entry
      DELETE FROM ref_distributor
      WHERE account_id = NEW.uuid;
    END IF;

  ELSIF (TG_OP = 'INSERT') THEN
    IF (NEW.account_type IN ('Distributor', 'Distributor - HQ')) THEN
      -- Insert or update id and distributor
      INSERT INTO ref_distributor (account_id, distributor)
      VALUES (NEW.uuid, NEW.account)
      ON CONFLICT (account_id)
      DO UPDATE SET
        distributor = EXCLUDED.distributor;
    END IF;
  END IF;

  RETURN NEW;
END;$$;
ALTER FUNCTION "public"."(deprecated) handle_account_distributor_sync"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."activity_tracker_set_last_updated"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.last_updated = now();
  -- Automatically capture the Supabase user making the change
  NEW.last_modified_by = auth.uid(); 
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."activity_tracker_set_last_updated"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."add_customer_to_category"("customer_uuid" "uuid", "category_uuid" "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    INSERT INTO jt_hh_customers_master_categories (customer_id, master_category_id)
    VALUES (customer_uuid, category_uuid)
    ON CONFLICT (customer_id, master_category_id) DO NOTHING;
    
    RETURN FOUND;
END;
$$;
ALTER FUNCTION "public"."add_customer_to_category"("customer_uuid" "uuid", "category_uuid" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."auto_complete_demo"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN
  -- Auto-complete when core completion metrics are provided
  IF NEW.demo_status IN ('Store Confirmed', 'Inventory Confirmed') 
     AND NEW.demo_feedback IS NOT NULL 
     AND NEW.demo_hours > 0 
     AND NEW.store_busy_rating IS NOT NULL 
     AND NEW.units_before IS NOT NULL 
     AND NEW.units_after IS NOT NULL THEN
    NEW.demo_status = 'Completed';
  END IF;
  RETURN NEW;
END;$$;
ALTER FUNCTION "public"."auto_complete_demo"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."calculate_onboarding_completion"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Count completed tasks
    NEW.total_tasks_completed := (
        CASE WHEN NEW.sell_sheets_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.pitch_deck_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.product_images_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.lifestyle_images_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.upc_barcode_images_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.w9_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.spec_sheet_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.distribution_info_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.retail_info_completed THEN 1 ELSE 0 END +
        CASE WHEN NEW.certifications_completed THEN 1 ELSE 0 END
    );
    
    -- Calculate percentage
    NEW.overall_completion_percentage := (NEW.total_tasks_completed::DECIMAL / NEW.total_tasks::DECIMAL) * 100;
    
    -- Set completion date if 100% complete
    IF NEW.overall_completion_percentage = 100 AND OLD.overall_completion_percentage < 100 THEN
        NEW.onboarding_completed_date := NOW();
    ELSIF NEW.overall_completion_percentage < 100 THEN
        NEW.onboarding_completed_date := NULL;
    END IF;
    
    -- Update timestamp
    NEW.updated_at := NOW();
    
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."calculate_onboarding_completion"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."calculate_total_hours"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.total_hours = COALESCE(NEW.demo_hours, 0) + 
                   COALESCE(NEW.training_hours, 0) + 
                   COALESCE(NEW.merchandising_hours, 0) + 
                   COALESCE(NEW.other_hours, 0);
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."calculate_total_hours"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."cascade_account_name_update"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  UPDATE contacts
  SET full_name_and_account = CONCAT(
    first_name, ' ', last_name, ' - ',
    NEW.account
  )
  WHERE account_uuid = NEW.uuid;

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."cascade_account_name_update"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."complete_task"("task_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  UPDATE task_pipeline 
  SET is_completed = true,
      completed_at = NOW()
  WHERE id = task_id;
  
  RETURN FOUND;
END;
$$;
ALTER FUNCTION "public"."complete_task"("task_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    -- Variable to hold the fetched brand name
    v_brand_name text;
    
    -- The master "Brands" folder ID
    v_master_brands_folder_id uuid := '6f709eb8-ab08-4977-a767-8a2ce324aff6';
    
    v_distribution_folder_id uuid;
    v_images_folder_id uuid;
BEGIN
    -- 0. Fetch the brand name from the brands table
    SELECT brand INTO v_brand_name 
    FROM public.brands 
    WHERE id = p_brand_id;

    -- Safety check: stop the function if the brand doesn't exist
    IF v_brand_name IS NULL THEN
        RAISE EXCEPTION 'Brand with ID % not found. Cannot create folders.', p_brand_id;
    END IF;

    -- 1. Create the Brand Folder nested under the master "Brands" folder
    INSERT INTO public.folders (id, name, parent_id, brand_id)
    VALUES (p_brand_id, v_brand_name, v_master_brands_folder_id, p_brand_id);

    -- 2. Create standard main folders without subfolders (using text tags in tag_id)
    INSERT INTO public.folders (name, parent_id, brand_id, tag_id) VALUES 
        ('Vendor Contracts', p_brand_id, p_brand_id, 'Contracts'),
        ('Brand Planning', p_brand_id, p_brand_id, 'Planning'),
        ('Certifications', p_brand_id, p_brand_id, 'Certifications'),
        ('Retail', p_brand_id, p_brand_id, 'Retail'),
        ('Promotional Planning', p_brand_id, p_brand_id, 'Promos'),
        ('Reports + Sales Data', p_brand_id, p_brand_id, 'Reports'),
        ('Archive', p_brand_id, p_brand_id, 'Archive'),
        ('W9', p_brand_id, p_brand_id, 'W9');

    -- 3. Create Distribution folder and its subfolder
    INSERT INTO public.folders (name, parent_id, brand_id, tag_id)
    VALUES ('Distribution', p_brand_id, p_brand_id, 'Distribution')
    RETURNING id INTO v_distribution_folder_id;
    
    INSERT INTO public.folders (name, parent_id, brand_id)
    VALUES ('TO Forms', v_distribution_folder_id, p_brand_id);

    -- 4. Create Images folder and its subfolders
    INSERT INTO public.folders (name, parent_id, brand_id, tag_id)
    VALUES ('Images', p_brand_id, p_brand_id, 'Images')
    RETURNING id INTO v_images_folder_id;

    INSERT INTO public.folders (name, parent_id, brand_id) VALUES 
        ('Lifestyle Images', v_images_folder_id, p_brand_id),
        ('UPC Barcode Images', v_images_folder_id, p_brand_id),
        ('Product Images', v_images_folder_id, p_brand_id),
        ('Product Labels', v_images_folder_id, p_brand_id);
END;
$$;
ALTER FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid", "p_brand_name" "text") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    -- The master "Brands" folder ID
    v_master_brands_folder_id uuid := '6f709eb8-ab08-4977-a767-8a2ce324aff6';
    
    v_distribution_folder_id uuid;
    v_images_folder_id uuid;
BEGIN
    -- 1. Create the Brand Folder nested under the master "Brands" folder
    INSERT INTO public.folders (id, name, parent_id, brand_id)
    VALUES (p_brand_id, p_brand_name, v_master_brands_folder_id, p_brand_id);

    -- 2. Create standard main folders without subfolders (using text tags)
    INSERT INTO public.folders (name, parent_id, brand_id, tag) VALUES 
        ('Vendor Contracts', p_brand_id, p_brand_id, 'Contracts'),
        ('Brand Planning', p_brand_id, p_brand_id, 'Planning'),
        ('Certifications', p_brand_id, p_brand_id, 'Certifications'),
        ('Retail', p_brand_id, p_brand_id, 'Retail'),
        ('Promotional Planning', p_brand_id, p_brand_id, 'Promos'),
        ('Reports + Sales Data', p_brand_id, p_brand_id, 'Reports'),
        ('Archive', p_brand_id, p_brand_id, 'Archive'),
        ('W9', p_brand_id, p_brand_id, 'W9');

    -- 3. Create Distribution folder and its subfolder
    INSERT INTO public.folders (name, parent_id, brand_id, tag)
    VALUES ('Distribution', p_brand_id, p_brand_id, 'Distribution')
    RETURNING id INTO v_distribution_folder_id;
    
    INSERT INTO public.folders (name, parent_id, brand_id)
    VALUES ('TO Forms', v_distribution_folder_id, p_brand_id);

    -- 4. Create Images folder and its subfolders
    INSERT INTO public.folders (name, parent_id, brand_id, tag)
    VALUES ('Images', p_brand_id, p_brand_id, 'Images')
    RETURNING id INTO v_images_folder_id;

    INSERT INTO public.folders (name, parent_id, brand_id) VALUES 
        ('Lifestyle Images', v_images_folder_id, p_brand_id),
        ('UPC Barcode Images', v_images_folder_id, p_brand_id),
        ('Product Images', v_images_folder_id, p_brand_id),
        ('Product Labels', v_images_folder_id, p_brand_id);
END;
$$;
ALTER FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid", "p_brand_name" "text") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."create_mention_notifications"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$declare
  mention text;
  clean_name text;
  mentioned_uuid uuid;
  mentions text[];
begin
  -- 1. Encontrar todas las menciones tipo @Nombre
  mentions := regexp_matches(new.activity_notes, '@([A-Za-z0-9_ ]+)', 'g');

  -- 2. Recorrer todas las menciones encontradas
  foreach mention in array mentions loop
    
    -- Quitar el '@'
    clean_name := trim(both '@' from mention);

    -- Buscar el usuario en team_member_guide por nombre EXACTO
    select id 
    into mentioned_uuid
    from team_member_guide
    where name = clean_name
    limit 1;

    -- Si encontramos el usuario, crear notificación
    if mentioned_uuid is not null then
      insert into notifications (recipient_id, type, data)
      values (
        mentioned_uuid,
        'mention',
        jsonb_build_object(
          'mentioned_name', clean_name,
          'activity_name', new.activity_name,
          'message', clean_name || ' was mentioned in activity "' || new.activity_name || '"'
        )
      );
    end if;

  end loop;

  return new;
end;$$;
ALTER FUNCTION "public"."create_mention_notifications"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."create_rls_policies"("table_names" "text"[], "role_dept_codes" "text"[], "operation" "text") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $_$
DECLARE
    tab text;
    policy_sql text;
    policy_name text;
    check_clause text;
BEGIN
    -- This is the core security condition. It checks if a user belongs to any of the specified roles.
    -- We use '= ANY($1)' which is an efficient way to check for existence in an array parameter.
    check_clause := format(
        'EXISTS (SELECT 1 FROM jt_user_role_dept urd JOIN team_member_dept tmd ON urd.dept_id = tmd.id WHERE urd.user_id = (select auth.uid()) AND tmd.dept_code = ANY(%L))',
        role_dept_codes
    );

    -- Loop through each table provided in the input array
    FOREACH tab IN ARRAY table_names
    LOOP
        -- Create a descriptive and unique policy name, e.g., 'task_pipeline_select_policy'
        policy_name := format('%s_%s_policy', tab, lower(operation));

        -- Drop the old policy if it exists to ensure we can re-run this script safely
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I;', policy_name, tab);

        -- Build the appropriate CREATE POLICY statement based on the operation
        IF operation = 'SELECT' THEN
            policy_sql := format('CREATE POLICY %I ON public.%I FOR SELECT USING (%s);', policy_name, tab, check_clause);
        ELSIF operation = 'INSERT' THEN
            policy_sql := format('CREATE POLICY %I ON public.%I FOR INSERT WITH CHECK (%s);', policy_name, tab, check_clause);
        ELSIF operation = 'UPDATE' THEN
            policy_sql := format('CREATE POLICY %I ON public.%I FOR UPDATE USING (%s) WITH CHECK (%s);', policy_name, tab, check_clause, check_clause);
        ELSIF operation = 'DELETE' THEN
            policy_sql := format('CREATE POLICY %I ON public.%I FOR DELETE USING (%s);', policy_name, tab, check_clause);
        ELSIF operation = 'ALL' THEN
            -- The 'ALL' command applies USING to SELECT, UPDATE, DELETE and WITH CHECK to INSERT, UPDATE.
            policy_sql := format('CREATE POLICY %I ON public.%I FOR ALL USING (%s) WITH CHECK (%s);', policy_name, tab, check_clause, check_clause);
        ELSE
            -- Raise an error for an invalid operation to prevent mistakes
            RAISE EXCEPTION 'Invalid operation specified: %. Must be one of SELECT, INSERT, UPDATE, DELETE, ALL', operation;
        END IF;
        -- Execute the dynamically constructed SQL statement
        EXECUTE policy_sql;
    END LOOP;
END;
$_$;
ALTER FUNCTION "public"."create_rls_policies"("table_names" "text"[], "role_dept_codes" "text"[], "operation" "text") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."create_task_on_deal_stage_change"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  new_task_id UUID; -- A variable to hold the ID of a newly created task.
  deal_owner_exists BOOLEAN; -- Added for debugging
BEGIN
   -- ================== DEBUGGING BLOCK ==================
  SELECT EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) INTO deal_owner_exists;
  RAISE NOTICE '--- DEBUG TRIGGER ---';
  RAISE NOTICE 'TG_OP: %', TG_OP;
  RAISE NOTICE 'Activity ID: %', NEW.id;
  RAISE NOTICE '1. Activity Type: %', NEW.activity_type;
  RAISE NOTICE '2. Deal Owner Exists?: %', deal_owner_exists;
  RAISE NOTICE '3. Assign for Follow Up: %', NEW.assign_for_follow_up;
  RAISE NOTICE '---------------------';
  -- =======================================================

  -- This block handles when an EXISTING activity_tracker record is UPDATED.
  IF TG_OP = 'UPDATE' AND NEW.assign_for_follow_up <> OLD.assign_for_follow_up THEN    
    IF NEW.activity_type IN ('SOS Program', 'SOS Only Program') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) AND
       NEW.assign_for_follow_up IS NOT NULL
    THEN
      -- First, update the status of any existing tasks.
      UPDATE public.task_pipeline
      SET status = 'sos_follow_up'::public.kanban_status_enum,
          updated_at = now()
      WHERE activity_tracker_id = NEW.id;
      -- NEW LOGIC: Also ensure the assignment exists for any updated tasks.
      -- This finds all tasks for the deal and creates the assignment if it doesn't already exist.
      INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
      SELECT id, NEW.assign_for_follow_up
      FROM public.task_pipeline
      WHERE activity_tracker_id = NEW.id
      ON CONFLICT (task_id, team_member_uuid) DO NOTHING;

      -- If no tasks were found to update, create a new one AND assign it.
      IF NOT FOUND THEN
        -- Step 1: Create the task and capture its ID.
        INSERT INTO public.task_pipeline (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
        VALUES (NEW.activity_name, 'deal_activity', 'sos_follow_up'::public.kanban_status_enum, NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto')
        RETURNING id INTO new_task_id;

        -- Step 2: Use the captured ID to create the assignment.
        INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
        VALUES (new_task_id, NEW.assign_for_follow_up);
      END IF;
    ELSE
      -- Original deal stage logic (on update) is unchanged...
      UPDATE public.task_pipeline
      SET status = CASE
                     WHEN NEW.deal_stage IN ('Presenting', 'Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
                     WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
                     WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
                     ELSE status
                   END,
          updated_at = now()
      WHERE activity_tracker_id = NEW.id;

      IF NOT FOUND AND NEW.deal_stage IN ('Presenting', 'Approved: in Setup', 'Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up', 'Target') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) THEN
        INSERT INTO public.task_pipeline (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
        VALUES (
          NEW.activity_name, 'deal_activity',
          CASE
            WHEN NEW.deal_stage IN ('Presenting', 'Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
            WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
            WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
          END,
          NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto'
        );
      END IF;
    END IF;

  -- This block handles when a NEW activity_tracker record is INSERTED.
  ELSIF TG_OP = 'INSERT' THEN
    -- SOS Check (on insert)
    IF NEW.activity_type IN ('SOS Program', 'SOS Only Program') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) AND
       NEW.assign_for_follow_up IS NOT NULL
    THEN
      -- Step 1: Create the task and capture its ID.
      INSERT INTO public.task_pipeline (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
      VALUES (NEW.activity_name, 'deal_activity', 'sos_follow_up'::public.kanban_status_enum, NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto')
      RETURNING id INTO new_task_id;

      -- Step 2: Use the captured ID to create the assignment.
      INSERT INTO public.jt_task_assignments (task_id, team_member_uuid)
      VALUES (new_task_id, NEW.assign_for_follow_up);
    END IF;

    -- Deal Stage Check (on insert) is unchanged...
    IF NEW.deal_stage IN ('Presenting', 'Approved: in Setup', 'Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up', 'Target') AND
       EXISTS (SELECT 1 FROM public.jt_deal_owners WHERE deal_id = NEW.id) THEN
      INSERT INTO public.task_pipeline (task_title, task_type, status, activity_tracker_id, brand_id, account_id, created_by, is_automated, source_type)
      VALUES (
        NEW.activity_name, 'deal_activity',
        CASE
          WHEN NEW.deal_stage IN ('Presenting', 'Approved: in Setup') THEN 'this_month'::public.kanban_status_enum
          WHEN NEW.deal_stage IN ('Presenting - Buyer Introduction', 'Presenting - Buyer Engagement / Meeting', 'Presenting - Post Review Follow-Up') THEN 'next_two_weeks'::public.kanban_status_enum
          WHEN NEW.deal_stage = 'Target' THEN 'to_watch'::public.kanban_status_enum
        END,
        NEW.id, NEW.brand, NEW.account, auth.uid(), TRUE, 'auto'
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."create_task_on_deal_stage_change"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."create_tasks_from_activity_tracker"() RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  rec RECORD;
  task_count INTEGER := 0;
  v_status kanban_status_enum;
  v_source_type source_type_enum;
  v_task_title TEXT;
BEGIN
  -- Create tasks for activities marked for task tracker
  FOR rec IN 
    SELECT 
      at.*,
      a.account as account_name, 
      b.brand as brand_name
    FROM activity_tracker at
    LEFT JOIN accounts a ON at.account = a.uuid  
    LEFT JOIN brands b ON at.brand = b.id
    WHERE at.send_to_task_tracker = true
    AND NOT EXISTS (
      SELECT 1 FROM task_pipeline tp WHERE tp.activity_tracker_id = at.id
    )
  LOOP
    -- Determine status and source
    v_status := determine_task_status(rec.id);
    v_source_type := CASE 
      WHEN rec.activity_type::text IN ('SOS Program', 'SOS Only Program') 
      THEN 'sos_deal_script'::source_type_enum
      ELSE 'gnf_deal_script'::source_type_enum
    END;
    
    -- Create descriptive task title
    v_task_title := COALESCE(
      rec.account_name || ' - ' || rec.brand_name,
      rec.account_name || ' Deal Activity',
      rec.brand_name || ' Deal Activity',
      'Deal Activity'
    );
    
    -- Create task
    INSERT INTO task_pipeline (
      task_title,
      notes,
      task_type,
      status,
      activity_tracker_id,
      brand_id,
      account_id,
      assigned_to,
      is_automated,
      source_type
    ) VALUES (
      v_task_title,
      rec.activity_notes,
      'deal_activity',
      v_status,
      rec.id,
      rec.brand,
      rec.account,
      rec.assign_for_follow_up,
      true,
      v_source_type
    );
    
    task_count := task_count + 1;
  END LOOP;
  
  RETURN task_count;
END;
$$;
ALTER FUNCTION "public"."create_tasks_from_activity_tracker"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."create_tasks_from_category_reviews"() RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  rec RECORD;
  brand_rec RECORD;
  task_count INTEGER := 0;
  v_status kanban_status_enum;
  v_task_title TEXT;
BEGIN
  -- Create tasks for category reviews with upcoming deadlines and linked brands
  FOR rec IN 
    SELECT 
      cr.*,
      a.account as account_name
    FROM master_category_review_data cr
    JOIN accounts a ON cr.account = a.uuid
    WHERE cr.new_item_submission_deadline IS NOT NULL
    AND cr.new_item_submission_deadline >= CURRENT_DATE
    AND cr.new_item_submission_deadline <= CURRENT_DATE + INTERVAL '60 days'
    AND NOT EXISTS (
      SELECT 1 FROM task_pipeline tp WHERE tp.category_review_id = cr.id
    )
  LOOP
    -- Find linked brands for this category review
    FOR brand_rec IN
      SELECT DISTINCT b.*
      FROM jt_master_category_review_data_brands jt
      JOIN brands b ON jt.brand_id = b.id
      WHERE jt.master_category_review_data_id = rec.id
    LOOP
      -- Determine status based on deadline
      v_status := determine_task_status(NULL, rec.new_item_submission_deadline);
      
      -- Create descriptive task title
      v_task_title := rec.account_name || ' - ' || brand_rec.brand || ' Category Review';
      
      -- Create task for each brand
      INSERT INTO task_pipeline (
        task_title,
        notes,
        task_type,
        status,
        category_review_id,
        brand_id,
        account_id,
        due_date,
        is_automated,
        source_type
      ) VALUES (
        v_task_title,
        'Category review deadline: ' || rec.new_item_submission_deadline::text,
        'category_review',
        v_status,
        rec.id,
        brand_rec.id,
        rec.account,
        rec.new_item_submission_deadline,
        true,
        'category_review_auto'
      );
      
      task_count := task_count + 1;
    END LOOP;
  END LOOP;
  
  RETURN task_count;
END;
$$;
ALTER FUNCTION "public"."create_tasks_from_category_reviews"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."custom_access_token_hook"("event" "jsonb") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$declare
  claims jsonb;
  v_brand_id uuid;
  v_department text;
  v_user_type text; -- Prefixed with v_ to avoid ambiguity
begin
  -- 1. Fetch data using the table names, but INTO the prefixed variables
  select brand_id, department, user_type 
  into v_brand_id, v_department, v_user_type
  from public.profiles
  where id = (event->>'user_id')::uuid;

  claims := event->'claims';

  -- 2. Set Brand ID
  if v_brand_id is not null then
    claims := jsonb_set(claims, '{app_metadata, brand_id}', to_jsonb(v_brand_id));
  end if;

  -- 3. Set Department
  if v_department is not null then
    claims := jsonb_set(claims, '{app_metadata, department}', to_jsonb(v_department));
  end if;

  -- 4. Set User Type
  if v_user_type is not null then
    claims := jsonb_set(claims, '{app_metadata, user_type}', to_jsonb(v_user_type));
  end if;

  event := jsonb_set(event, '{claims}', claims);
  return event;
end;$$;
ALTER FUNCTION "public"."custom_access_token_hook"("event" "jsonb") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."determine_task_status"("p_activity_tracker_id" "uuid", "p_due_date" "date") RETURNS "public"."kanban_status_enum"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_deal_stage TEXT;
  v_activity_type TEXT;
BEGIN
  -- Get deal info from activity_tracker if provided
  IF p_activity_tracker_id IS NOT NULL THEN
    SELECT deal_stage::text, activity_type::text 
    INTO v_deal_stage, v_activity_type
    FROM activity_tracker 
    WHERE id = p_activity_tracker_id;
    
    -- SOS Program logic
    IF v_activity_type IN ('SOS Program', 'SOS Only Program') THEN
      RETURN 'sos_follow_up';
    END IF;
    
    -- GNF Deal logic based on deal stage
    CASE v_deal_stage
      WHEN 'Presenting', 'Approved: in Setup' THEN
        RETURN 'this_month';
      WHEN 'Target' THEN  
        RETURN 'to_watch';
      WHEN 'Presenting - Buyer Introduction', 
           'Presenting - Buyer Engagement / Meeting',
           'Presenting - Post Review Follow-Up' THEN
        RETURN 'next_two_weeks';
      ELSE
        RETURN 'this_month';
    END CASE;
  END IF;
  
  -- Date-based logic for manual tasks and category reviews
  IF p_due_date IS NOT NULL THEN
    IF p_due_date < CURRENT_DATE OR 
       (p_due_date >= CURRENT_DATE AND p_due_date <= CURRENT_DATE + INTERVAL '7 days') THEN
      RETURN 'this_week_overdue';
    ELSIF p_due_date <= CURRENT_DATE + INTERVAL '14 days' THEN
      RETURN 'next_two_weeks';
    ELSIF p_due_date <= CURRENT_DATE + INTERVAL '30 days' THEN
      RETURN 'this_month';
    ELSE
      RETURN 'to_watch';
    END IF;
  END IF;
  
  -- Default: If the due date is cleared to NULL, send it to the backlog
  RETURN 'to_watch';
END;
$$;
ALTER FUNCTION "public"."determine_task_status"("p_activity_tracker_id" "uuid", "p_due_date" "date") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."enforce_connect_count"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF NEW.deal_stage ILIKE 'Connect%' THEN
    NEW.connect_count := 1;
  ELSE
    NEW.connect_count := 0;
  END IF;
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."enforce_connect_count"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_account_type_enum"() RETURNS TABLE("account_type_value" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS account_type_value
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'account_type_enum'
        );
$$;
ALTER FUNCTION "public"."fetch_account_type_enum"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_activity_type"() RETURNS TABLE("activity_type_value" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS activity_type_value
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'activity_type_enum'
        );
$$;
ALTER FUNCTION "public"."fetch_activity_type"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_brand_contact_tags"() RETURNS TABLE("brand_contact_tags_type" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS    brand_contact_tags
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'Brand Contact Tags'
        );
$$;
ALTER FUNCTION "public"."fetch_brand_contact_tags"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_brand_folder"() RETURNS TABLE("deal_stage_value" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS folders_enum
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'folders_enum'
        );
$$;
ALTER FUNCTION "public"."fetch_brand_folder"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_category_review_status"() RETURNS TABLE("category_review_status" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS category_review_status
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'category_review_status_enum'
        );
$$;
ALTER FUNCTION "public"."fetch_category_review_status"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_connect_enum"() RETURNS TABLE("connect_enum" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS 	connect_enum
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'connect_enum'
        );
$$;
ALTER FUNCTION "public"."fetch_connect_enum"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_deal_stage"() RETURNS TABLE("deal_stage_value" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS deal_stage_value
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'deal_stage_enum'
        );
$$;
ALTER FUNCTION "public"."fetch_deal_stage"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_deals_for_tasks"("p_accounts" "uuid"[] DEFAULT '{}'::"uuid"[], "p_brands" "uuid"[] DEFAULT '{}'::"uuid"[]) RETURNS TABLE("id" "uuid", "activity_name" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
  RETURN QUERY
  SELECT 
    t.id,
    t.activity_name
  FROM activity_tracker t
  WHERE 
    -- 1. Deal must belong to the selected Accounts (this check is bypassed if no accounts are chosen)
    (
      p_accounts IS NULL 
      OR array_length(p_accounts, 1) IS NULL 
      OR t.account = ANY(p_accounts)
    )
    AND -- <--- This AND is what forces the strict "Pair" requirement
    -- 2. Deal must belong to the selected Brands (this check is bypassed if no brands are chosen)
    (
      p_brands IS NULL 
      OR array_length(p_brands, 1) IS NULL 
      OR t.brand = ANY(p_brands)
    );
END;$$;
ALTER FUNCTION "public"."fetch_deals_for_tasks"("p_accounts" "uuid"[], "p_brands" "uuid"[]) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_hh_customer_billing_terms_enum"() RETURNS TABLE("account_type_value" "text")
    LANGUAGE "sql"
    AS $$SELECT
    enumlabel AS hh_billing_terms_value
FROM
    pg_enum
WHERE
    enumtypid = (
        SELECT oid FROM pg_type WHERE typname = 'hh_billing_terms_enum'
    );$$;
ALTER FUNCTION "public"."fetch_hh_customer_billing_terms_enum"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_primary_region"() RETURNS TABLE("primary_region" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS primary_region
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'Region'
        );
$$;
ALTER FUNCTION "public"."fetch_primary_region"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_program_status"() RETURNS TABLE("program_status_type" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS 	program_status_type
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'program_status_type'
        );
$$;
ALTER FUNCTION "public"."fetch_program_status"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_sku_placement_type"() RETURNS TABLE("placement_type" "text")
    LANGUAGE "sql"
    AS $$
    SELECT
        enumlabel AS placement_type
    FROM
        pg_enum
    WHERE
        enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'placement_type_enum'
        );
$$;
ALTER FUNCTION "public"."fetch_sku_placement_type"() OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_task_pipeline_with_assignees" AS
SELECT
    NULL::"uuid" AS "task_id",
    NULL::"text" AS "task_title",
    NULL::"text" AS "notes",
    NULL::"public"."task_type_enum" AS "task_type",
    NULL::"public"."kanban_status_enum" AS "status",
    NULL::"date" AS "due_date",
    NULL::"public"."priority_enum" AS "priority",
    NULL::boolean AS "is_completed",
    NULL::timestamp with time zone AS "completed_at",
    NULL::timestamp with time zone AS "created_at",
    NULL::timestamp with time zone AS "updated_at",
    NULL::"jsonb" AS "linked_deals",
    NULL::"uuid" AS "brand_id",
    NULL::"uuid" AS "account_id",
    NULL::"uuid" AS "category_review_id",
    NULL::"uuid" AS "creator_team_member_uuid",
    NULL::boolean AS "is_automated",
    NULL::"public"."source_type_enum" AS "source_type",
    NULL::"jsonb" AS "assignees",
    NULL::"jsonb" AS "attachment_info";
ALTER TABLE "public"."v_task_pipeline_with_assignees" OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fetch_tasks_for_deal"("p_deal_id" "uuid") RETURNS SETOF "public"."v_task_pipeline_with_assignees"
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
  SELECT *
  FROM v_task_pipeline_with_assignees
  WHERE 
    -- This searches the JSONB array for an object containing the specific deal_id
    linked_deals @> jsonb_build_array(jsonb_build_object('deal_id', p_deal_id));
$$;
ALTER FUNCTION "public"."fetch_tasks_for_deal"("p_deal_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."fill_full_category"() RETURNS "trigger"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$
BEGIN
  NEW.full_category := NEW.category::TEXT || ' - ' || NEW.subcategory;
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."fill_full_category"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."filter_notes_by_brands"("brand_names" "text"[]) RETURNS TABLE("id" "uuid", "brand" "text")
    LANGUAGE "sql"
    AS $$select id, brand
  from brands
  where brand = any(brand_names);$$;
ALTER FUNCTION "public"."filter_notes_by_brands"("brand_names" "text"[]) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."format_item_name"("description_text" "text", "qty" numeric, "unit_val" "public"."uom_enum") RETURNS "text"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$
BEGIN
  RETURN COALESCE(description_text, '') || ' - ' || COALESCE(qty::text, '') || ' ' || COALESCE(unit_val::text, '');
END;
$$;
ALTER FUNCTION "public"."format_item_name"("description_text" "text", "qty" numeric, "unit_val" "public"."uom_enum") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."generate_review_data_name"("review_data_id" "uuid") RETURNS "text"
    LANGUAGE "plpgsql"
    AS $$DECLARE
    account_name TEXT;
    retail_cat TEXT;  -- Renamed variable
    result_name TEXT;
BEGIN
    -- Get account name and Retailer Category
    SELECT 
        a.account,
        mcrd.retailer_category  -- Select directly from the review data table
    INTO 
        account_name,
        retail_cat
    FROM master_category_review_data mcrd
    JOIN accounts a ON mcrd.account = a.uuid
    -- JOIN master_categories removed (not needed anymore)
    WHERE mcrd.id = review_data_id;
    
    -- Construct the name: Account - Retailer Category
    IF account_name IS NOT NULL AND retail_cat IS NOT NULL THEN
        result_name := account_name || ' - ' || retail_cat;
    ELSIF account_name IS NOT NULL THEN
        result_name := account_name || ' - Unknown Category';
    ELSE
        result_name := 'Unknown Account - Unknown Category';
    END IF;
    
    RETURN result_name;
END;$$;
ALTER FUNCTION "public"."generate_review_data_name"("review_data_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_associated_skus"("input_deal_id" "uuid") RETURNS TABLE("sku_id" "uuid", "sku_name" "text", "category_list" "jsonb", "placement_status" "text", "distribution_details" "jsonb")
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    target_brand_id UUID;
    target_account_id UUID;
BEGIN
    -- 1. Get the Context
    SELECT brand, account 
    INTO target_brand_id, target_account_id
    FROM public.activity_tracker
    WHERE id = input_deal_id;

    -- 2. Return the Master List
    RETURN QUERY
    SELECT 
        s.id AS sku_id,
        s.unique_item_name AS sku_name,
        
        -- Category Logic
        COALESCE(
            (
                SELECT JSONB_AGG(DISTINCT 
                    COALESCE(mc.full_category, mc.category::text, mc.subcategory, 'Uncategorized')
                )
                FROM public.sku_product_category spc
                JOIN public.master_categories mc ON spc.product_category = mc.id
                WHERE spc.brand_product_sku = s.id
            ),
            '[]'::jsonb
        ) AS category_list,
        
        sp.sku_status::text AS placement_status,
        
        -- UPDATED DISTRIBUTION LOGIC
        COALESCE(
            (
                SELECT JSONB_AGG(
                    JSONB_BUILD_OBJECT(
                        'grid_id', bdg.id,                     -- <--- REQUIRED for Updates
                        'current_status', bdg.distribution_status, -- <--- REQUIRED to see current status
                        'distributor_name', dist_acc.account,
                        'distributor_id', dist_acc.uuid,
                        'warehouse_name', dc_acc.account,
                        'warehouse_id', dc_acc.uuid,
                        'item_code', bdg.item_code
                    )
                )
                FROM public.brand_distribution_grid bdg
                
                -- Use LEFT JOINs so we don't lose the row if the link is missing
                LEFT JOIN public.jt_accounts_distribution jt 
                    ON bdg.distributor_hq = jt.distributor_account_id
                    AND jt.retail_account_id = target_account_id
                
                LEFT JOIN public.accounts dist_acc 
                    ON bdg.distributor_hq = dist_acc.uuid
                    
                LEFT JOIN public.accounts dc_acc 
                    ON bdg.warehouse_dc = dc_acc.uuid
                
                WHERE 
                    bdg.item_name = s.id
                    AND (
                        -- Condition 1: Explicit Link exists in JT
                        jt.id IS NOT NULL 
                        -- Condition 2: The Deal Account IS the Distributor (Direct)
                        OR bdg.distributor_hq = target_account_id
                        -- Condition 3: The Deal Account IS the Warehouse (Direct)
                        OR bdg.warehouse_dc = target_account_id
                    )
            ),
            '[]'::jsonb
        ) AS distribution_details

    FROM 
        public.spec_price_sheet s
        
        LEFT JOIN public.sku_placements sp 
            ON s.id = sp.sku_id 
            AND sp.deal_id = input_deal_id

    WHERE 
        s.brand_id = target_brand_id
        
    GROUP BY 
        s.id, s.unique_item_name, sp.sku_status;
END;
$$;
ALTER FUNCTION "public"."get_associated_skus"("input_deal_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_associated_skus_by_deal_id"("p_deal_id" "uuid") RETURNS TABLE("sku_id" "uuid", "sku_description" "text", "sku_item_status" "text", "sku_upc_12_digit" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  SELECT
      sps.id AS sku_id,
      sps.description AS sku_description,
      sps.item_status::TEXT AS sku_item_status, -- FIX: Explicitly cast item_status to TEXT
      sps.upc_12_digit AS sku_upc_12_digit
  FROM
      public.jt_deal_spec_price_sheet AS jtds
  JOIN
      public.spec_price_sheet AS sps ON jtds.sku_id = sps.id
  WHERE
      jtds.deal_id = p_deal_id
  ORDER BY
      sps.description ASC;
END;
$$;
ALTER FUNCTION "public"."get_associated_skus_by_deal_id"("p_deal_id" "uuid") OWNER TO "postgres";
SET default_tablespace = '';
SET default_table_access_method = "heap";
CREATE TABLE IF NOT EXISTS "public"."brands" (
    "brand" "text",
    "manufacturer_name" "text",
    "principal_list_status" "public"."Principal List Status",
    "status" "public"."Brand Status"[],
    "services" "public"."Active Services"[],
    "coverage" "public"."Coverage"[],
    "start_date" "date",
    "last_date" "date",
    "sos_start_date" "date",
    "demo_start_date" "date",
    "headquarters_address" "text",
    "mailing_address_if_different" "text",
    "free_fill_placement_authorization" "text",
    "samples_policy_and_request_process" "text",
    "mission_components" "text",
    "overall_brand_goals" "text",
    "demos_included_quarterly" integer,
    "sos_calls_included_monthly" numeric(10,2),
    "sos_sales_rate" numeric(10,2),
    "referred_by" "text",
    "product_pickup_address" "text",
    "product_summary" "text",
    "se___current_month" numeric(10,2),
    "invoice_timing" "text",
    "billing_notes" "text",
    "tax_id_number" "text",
    "private_label_bulk_and__or_food_service" "public"."sales_channel"[],
    "describe_any_capabilities_from_the_selection_above" "text",
    "order_lead_time" "text",
    "full_reclamation_or_spoils_allowance" "text",
    "brand_certifications" "text",
    "capacity_or_production_restrictions" "text",
    "direct_order_details_process" "text",
    "marketing_descriptions" "text",
    "email_pitch_descriptor" "text",
    "are_you_a_member_of_any_trade_organizations" "text",
    "product_attributes" "text",
    "onboarding_notes" "text",
    "company_website" "text",
    "cancellation_reasons" "text",
    "se___next_month" numeric(10,2),
    "brand_contracts" "text"[],
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "follow_up_email_draft" "text",
    "category_for_principal_list" "public"."category_enum (deprecated?)"[],
    "product_sub_category_for_principal_list" "public"."product_subcategory_enum (principal list)"[],
    "product_images" "jsonb"[],
    "attention_flags" "public"."attention_flag_enum"[],
    "brand_logo" "text",
    "search_vector" "tsvector",
    "other_active_brokerage_service_coverage" "text",
    "demo_customer_type" "public"."Demo_special_customer_enum",
    "faire_link" "text",
    "mable_link" "text",
    "airgoods_link" "text",
    "other_link" "text",
    "pod_foods_link" "text",
    "created" timestamp with time zone DEFAULT "now"(),
    "last_modified" timestamp with time zone DEFAULT "now"(),
    "new_item" boolean
);
ALTER TABLE "public"."brands" OWNER TO "postgres";
COMMENT ON TABLE "public"."brands" IS 'This table rests all the brands that GNF works with across the country';
COMMENT ON COLUMN "public"."brands"."search_vector" IS 'Formats the fields to be used as search values';
COMMENT ON COLUMN "public"."brands"."demo_customer_type" IS 'Tag if this demo brand belongs to a specific customer group: NWG, POD, etc.';
CREATE OR REPLACE FUNCTION "public"."get_brand_by_id"("brand_id" "uuid") RETURNS SETOF "public"."brands"
    LANGUAGE "sql"
    AS $$
  select * from brands where id = brand_id;
$$;
ALTER FUNCTION "public"."get_brand_by_id"("brand_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_brand_skus_for_deal"("p_brand" "uuid", "p_deal" "uuid") RETURNS TABLE("sku_id" "uuid", "sku_description" "text", "jt_id" "uuid", "status" "text", "full_category" "text")
    LANGUAGE "sql" STABLE
    AS $$
  select 
    s.id, 
    s.description, 
    j.id, 
    j.sku_deal_status,
    -- The subquery for the category
    (
      select string_agg(mc.full_category, ', ')
      from jt_spec_price_sheet_categories jt
      join master_categories mc on mc.id = jt.category_id
      where jt.sku_id = s.id
    ) as full_category
  from spec_price_sheet s
  left join jt_associated_skus j
    on j.sku_id = s.id
    and j.deal_id = p_deal
  where s.brand_id = p_brand
  order by s.description;
$$;
ALTER FUNCTION "public"."get_brand_skus_for_deal"("p_brand" "uuid", "p_deal" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_comments_for_activity_notes"("p_activity_id" "uuid") RETURNS TABLE("comment_id" "uuid", "content" "text", "created_at" timestamp with time zone, "activity_id" "uuid", "user_id" "uuid", "username" "text", "profile_photo" "text", "full_name" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,                                         -- The comment's ID
        c.comment_text,                                    -- The comment's text
        c.created_at,                                 -- The comment's timestamp
        c.deal_id,                                -- The ID of the activity being commented on
        c.user_id,                                    -- The author's user ID from auth.users
        COALESCE(tmg.email, 'Anonymous User'),     -- The author's username, with a fallback
        COALESCE(tmg.profile_photo, 'default_profile_photo.png'), -- The author's avatar, with a fallback
        tmg.name                              -- Example: The author's full name from their profile        
    FROM
        "deal_activity_comments" AS c
    -- LEFT JOIN to the profile table to get display info like username
    LEFT JOIN
        "team_member_guide" AS tmg ON c.user_id = tmg.user_id
    -- LEFT JOIN to the auth table to get user-specific info like email
    WHERE
        c.deal_id = p_activity_id
    ORDER BY
        c.created_at DESC;
END;
$$;
ALTER FUNCTION "public"."get_comments_for_activity_notes"("p_activity_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_complete_schema"() RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    result jsonb;
BEGIN
    -- Get all enums
    WITH enum_types AS (
        SELECT 
            t.typname as enum_name,
            array_agg(e.enumlabel ORDER BY e.enumsortorder) as enum_values
        FROM pg_type t
        JOIN pg_enum e ON t.oid = e.enumtypid
        JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
        WHERE n.nspname = 'public'
        GROUP BY t.typname
    )
    SELECT jsonb_build_object(
        'enums',
        COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'name', enum_name,
                    'values', to_jsonb(enum_values)
                )
            ),
            '[]'::jsonb
        )
    )
    FROM enum_types
    INTO result;

    -- Get all tables with their details
    WITH RECURSIVE 
    columns_info AS (
        SELECT 
            c.oid as table_oid,
            c.relname as table_name,
            a.attname as column_name,
            format_type(a.atttypid, a.atttypmod) as column_type,
            a.attnotnull as notnull,
            pg_get_expr(d.adbin, d.adrelid) as column_default,
            CASE 
                WHEN a.attidentity != '' THEN true
                WHEN pg_get_expr(d.adbin, d.adrelid) LIKE 'nextval%' THEN true
                ELSE false
            END as is_identity,
            EXISTS (
                SELECT 1 FROM pg_constraint con 
                WHERE con.conrelid = c.oid 
                AND con.contype = 'p' 
                AND a.attnum = ANY(con.conkey)
            ) as is_pk
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        LEFT JOIN pg_attribute a ON a.attrelid = c.oid
        LEFT JOIN pg_attrdef d ON d.adrelid = c.oid AND d.adnum = a.attnum
        WHERE n.nspname = 'public' 
        AND c.relkind = 'r'
        AND a.attnum > 0 
        AND NOT a.attisdropped
    ),
    fk_info AS (
        SELECT 
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', con.conname,
                    'column', col.attname,
                    'foreign_schema', fs.nspname,
                    'foreign_table', ft.relname,
                    'foreign_column', fcol.attname,
                    'on_delete', CASE con.confdeltype
                        WHEN 'a' THEN 'NO ACTION'
                        WHEN 'c' THEN 'CASCADE'
                        WHEN 'r' THEN 'RESTRICT'
                        WHEN 'n' THEN 'SET NULL'
                        WHEN 'd' THEN 'SET DEFAULT'
                        ELSE NULL
                    END
                )
            ) as foreign_keys
        FROM pg_class c
        JOIN pg_constraint con ON con.conrelid = c.oid
        JOIN pg_attribute col ON col.attrelid = con.conrelid AND col.attnum = ANY(con.conkey)
        JOIN pg_class ft ON ft.oid = con.confrelid
        JOIN pg_namespace fs ON fs.oid = ft.relnamespace
        JOIN pg_attribute fcol ON fcol.attrelid = con.confrelid AND fcol.attnum = ANY(con.confkey)
        WHERE con.contype = 'f'
        GROUP BY c.oid
    ),
    index_info AS (
        SELECT 
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', i.relname,
                    'using', am.amname,
                    'columns', (
                        SELECT jsonb_agg(a.attname ORDER BY array_position(ix.indkey, a.attnum))
                        FROM unnest(ix.indkey) WITH ORDINALITY as u(attnum, ord)
                        JOIN pg_attribute a ON a.attrelid = c.oid AND a.attnum = u.attnum
                    )
                )
            ) as indexes
        FROM pg_class c
        JOIN pg_index ix ON ix.indrelid = c.oid
        JOIN pg_class i ON i.oid = ix.indexrelid
        JOIN pg_am am ON am.oid = i.relam
        WHERE NOT ix.indisprimary
        GROUP BY c.oid
    ),
    policy_info AS (
        SELECT 
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', pol.polname,
                    'command', CASE pol.polcmd
                        WHEN 'r' THEN 'SELECT'
                        WHEN 'a' THEN 'INSERT'
                        WHEN 'w' THEN 'UPDATE'
                        WHEN 'd' THEN 'DELETE'
                        WHEN '*' THEN 'ALL'
                    END,
                    'roles', (
                        SELECT string_agg(quote_ident(r.rolname), ', ')
                        FROM pg_roles r
                        WHERE r.oid = ANY(pol.polroles)
                    ),
                    'using', pg_get_expr(pol.polqual, pol.polrelid),
                    'check', pg_get_expr(pol.polwithcheck, pol.polrelid)
                )
            ) as policies
        FROM pg_class c
        JOIN pg_policy pol ON pol.polrelid = c.oid
        GROUP BY c.oid
    ),
    trigger_info AS (
        SELECT 
            c.oid as table_oid,
            jsonb_agg(
                jsonb_build_object(
                    'name', t.tgname,
                    'timing', CASE 
                        WHEN t.tgtype & 2 = 2 THEN 'BEFORE'
                        WHEN t.tgtype & 4 = 4 THEN 'AFTER'
                        WHEN t.tgtype & 64 = 64 THEN 'INSTEAD OF'
                    END,
                    'events', (
                        CASE WHEN t.tgtype & 1 = 1 THEN 'INSERT'
                             WHEN t.tgtype & 8 = 8 THEN 'DELETE'
                             WHEN t.tgtype & 16 = 16 THEN 'UPDATE'
                             WHEN t.tgtype & 32 = 32 THEN 'TRUNCATE'
                        END
                    ),
                    'statement', pg_get_triggerdef(t.oid)
                )
            ) as triggers
        FROM pg_class c
        JOIN pg_trigger t ON t.tgrelid = c.oid
        WHERE NOT t.tgisinternal
        GROUP BY c.oid
    ),
    table_info AS (
        SELECT DISTINCT 
            c.table_oid,
            c.table_name,
            jsonb_agg(
                jsonb_build_object(
                    'name', c.column_name,
                    'type', c.column_type,
                    'notnull', c.notnull,
                    'default', c.column_default,
                    'identity', c.is_identity,
                    'is_pk', c.is_pk
                ) ORDER BY c.column_name
            ) as columns,
            COALESCE(fk.foreign_keys, '[]'::jsonb) as foreign_keys,
            COALESCE(i.indexes, '[]'::jsonb) as indexes,
            COALESCE(p.policies, '[]'::jsonb) as policies,
            COALESCE(t.triggers, '[]'::jsonb) as triggers
        FROM columns_info c
        LEFT JOIN fk_info fk ON fk.table_oid = c.table_oid
        LEFT JOIN index_info i ON i.table_oid = c.table_oid
        LEFT JOIN policy_info p ON p.table_oid = c.table_oid
        LEFT JOIN trigger_info t ON t.table_oid = c.table_oid
        GROUP BY c.table_oid, c.table_name, fk.foreign_keys, i.indexes, p.policies, t.triggers
    )
    SELECT result || jsonb_build_object(
        'tables',
        COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'name', table_name,
                    'columns', columns,
                    'foreign_keys', foreign_keys,
                    'indexes', indexes,
                    'policies', policies,
                    'triggers', triggers
                )
            ),
            '[]'::jsonb
        )
    )
    FROM table_info
    INTO result;

    -- Get all functions
    WITH function_info AS (
        SELECT 
            p.proname AS name,
            pg_get_functiondef(p.oid) AS definition
        FROM pg_proc p
        JOIN pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
        AND p.prokind = 'f'
    )
    SELECT result || jsonb_build_object(
        'functions',
        COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'name', name,
                    'definition', definition
                )
            ),
            '[]'::jsonb
        )
    )
    FROM function_info
    INTO result;

    RETURN result;
END;
$$;
ALTER FUNCTION "public"."get_complete_schema"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_customer_category_opportunities"("customer_uuid" "uuid") RETURNS TABLE("review_id" "uuid", "retailer_name" "text", "gnf_category" "text", "retailer_category" "text", "submission_deadline" "date", "days_remaining" integer, "urgency_level" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cr.id,
        a.account,
        mc.full_category,
        cr.retailer_category,
        cr.new_item_submission_deadline,
        (cr.new_item_submission_deadline - CURRENT_DATE)::INTEGER,
        CASE 
            WHEN cr.new_item_submission_deadline < CURRENT_DATE THEN 'Expired'
            WHEN cr.new_item_submission_deadline <= CURRENT_DATE + 7 THEN 'Urgent'
            WHEN cr.new_item_submission_deadline <= CURRENT_DATE + 30 THEN 'Soon'
            ELSE 'Future'
        END
    FROM master_category_review_data cr
    JOIN accounts a ON cr.account = a.uuid
    LEFT JOIN master_categories mc ON cr.master_category_id = mc.id
    JOIN jt_hh_customers_master_categories jcmc ON jcmc.customer_id = customer_uuid
    WHERE cr.master_category_id = jcmc.master_category_id
    AND cr.new_item_submission_deadline > CURRENT_DATE
    AND (cr.archive IS NOT TRUE OR cr.archive IS NULL)
    ORDER BY cr.new_item_submission_deadline;
END;
$$;
ALTER FUNCTION "public"."get_customer_category_opportunities"("customer_uuid" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_customer_monthly_status"("customer_uuid" "uuid") RETURNS TABLE("customer_name" "text", "contributions_this_month" integer, "status_message" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.name,
        COUNT(cont.id)::INTEGER,
        CASE 
            WHEN COUNT(cont.id) > 0 THEN '✅ At Least One Contribution'
            ELSE '❌ No Contribution This Month'
        END
    FROM hh_customers c
    LEFT JOIN hh_contributions cont ON c.id = cont.customer_id
        AND EXTRACT(MONTH FROM cont.created_at) = EXTRACT(MONTH FROM CURRENT_DATE)
        AND EXTRACT(YEAR FROM cont.created_at) = EXTRACT(YEAR FROM CURRENT_DATE)
    WHERE c.id = customer_uuid
    GROUP BY c.name;
END;
$$;
ALTER FUNCTION "public"."get_customer_monthly_status"("customer_uuid" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_dashboard_summary"() RETURNS "jsonb"
    LANGUAGE "sql" STABLE
    AS $$
SELECT jsonb_build_object(
    -- 1. TOP TILES: COUNTS
    'counts', jsonb_build_object(
        'pipeline_items', (
            -- UPDATED: now pulls from your specific pipeline view
            -- (Assumes this view only shows active tasks. If it shows closed ones, add WHERE status != 'Closed')
            SELECT count(*) 
            FROM public.v_task_pipeline_with_assignees
            WHERE is_completed = false
        ),
        'planned_submissions', (
            SELECT count(*) 
            FROM public.planned_submissions 
        ),
        'sync_calls', (
            -- UPDATED: now pulls from your call schedule table
            SELECT count(*) 
            FROM public.brand_sync_call_schedule
            WHERE sync_date = CURRENT_DATE -- <--- VERIFY THIS COLUMN NAME (e.g. call_date, start_time)
        )
    ),

    -- 2. TILE: UPCOMING CATEGORY REVIEW
    'next_review', (
        SELECT jsonb_build_object(
            'review_name', review_name,
            'deadline', new_item_submission_deadline,
            'managers', category_managers,
            'brands', linked_brands_array,
            'count', linked_brands_count
        )
        FROM public.v_brand_matching
        WHERE new_item_submission_deadline IS NOT NULL 
          AND new_item_submission_deadline >= CURRENT_DATE
        ORDER BY new_item_submission_deadline ASC
        LIMIT 1
    ),

    -- 3. TILE: UPCOMING EVENT
    'next_event', (
        SELECT row_to_json(e)
        FROM (
            SELECT * FROM public.events_detailed_view
            WHERE start_date >= CURRENT_DATE
            ORDER BY start_date ASC
            LIMIT 1
        ) e
    ),

    -- 4. TILE: ANNOUNCEMENT
    'next_announcement', (
        SELECT row_to_json(a)
        FROM (
            SELECT * FROM public.company_announcements
            WHERE announcement_date >= CURRENT_DATE
              AND publish IS TRUE
              AND (archive IS NOT TRUE)
            ORDER BY announcement_date ASC
            LIMIT 1
        ) a
    ),

    -- 5. TILE: NEXT PLANNED SUBMISSION
    'next_planned_submission', (
        SELECT jsonb_build_object(
            'submission_id', ps.id,
            'planned_date', ps.planned_submission_date,
            'submission_status', ps.submission_status,
            'review_name', mcrd.display_name,
            'brand_name', b.brand,
            'brand_logo', b.brand_logo,
            'deal_name', at.activity_name
        )
        FROM public.planned_submissions ps
        LEFT JOIN public.master_category_review_data mcrd ON ps.category_review = mcrd.id
        LEFT JOIN public.activity_tracker at ON ps.deal_id = at.id
        LEFT JOIN public.brands b ON at.brand = b.id
        WHERE ps.planned_submission_date >= CURRENT_DATE
          AND (ps.submission_status IS FALSE OR ps.submission_status IS NULL)
        ORDER BY ps.planned_submission_date ASC
        LIMIT 1
    )
);
$$;
ALTER FUNCTION "public"."get_dashboard_summary"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_deal_comments_by_brand"("p_deal_id" "uuid") RETURNS TABLE("id" "uuid", "deal_id" "uuid", "user_id" "uuid", "comment_text" "text", "created_at" timestamp with time zone, "author_name" "text", "author_profile_photo" "text", "author_role_name" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  SELECT
      dac.id,
      dac.deal_id,
      dac.user_id,
      dac.comment_text,
      dac.created_at,
      -- Get author name: Prioritize name from team_member_guide IF the user is an internal team role, else use public.users name
      COALESCE(
          CASE WHEN r_sub.name IN ('internal', 'admin', 'manager') THEN tmg.name ELSE NULL END,
          pu.name
      ) AS author_name,
      -- Get profile photo URL: Only from team_member_guide if user is an internal team role, otherwise NULL
      CASE WHEN r_sub.name IN ('internal', 'admin', 'manager') THEN tmg.profile_photo ELSE NULL END AS author_profile_photo,
      r_sub.name AS author_role_name
  FROM
      public.deal_activity_comments AS dac
  JOIN
      public.users AS pu ON dac.user_id = pu.id
  LEFT JOIN (
      -- Corrected subquery to get a single, deterministic role name FOR EACH USER
      SELECT DISTINCT ON (ur_inner.user_id) -- FIX: Ensure one row per user_id
          ur_inner.user_id,
          r_inner.name
      FROM
          public.users_roles ur_inner
      JOIN
          public.roles r_inner ON ur_inner.role_id = r_inner.id
      ORDER BY
          ur_inner.user_id, -- Must be first for DISTINCT ON
          CASE r_inner.name
              WHEN 'admin' THEN 1
              WHEN 'manager' THEN 2
              WHEN 'internal' THEN 3
              ELSE 99
          END ASC
      -- Removed LIMIT 1 here, as DISTINCT ON handles the limiting per user_id
  ) AS r_sub ON pu.id = r_sub.user_id
  LEFT JOIN
      public.team_member_guide AS tmg ON pu.id = tmg.uuid AND r_sub.name IN ('internal', 'admin', 'manager')
  WHERE
      dac.deal_id = p_deal_id
  ORDER BY
      dac.created_at ASC;
END;
$$;
ALTER FUNCTION "public"."get_deal_comments_by_brand"("p_deal_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_demo_details"("demo_id_param" "uuid") RETURNS TABLE("display_name" "text", "brands" "text", "account" "text", "demo_date" "date", "total_hours" numeric, "total_units_sold" integer, "demo_fee" numeric, "store_busy_rating" integer)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    (string_agg(b.brand, ' + ') || ' - ' || a.account || ' - ' || TO_CHAR(d.demo_date, 'MM/DD/YYYY'))::TEXT,
    string_agg(b.brand, ' + ')::TEXT,
    a.account::TEXT,
    d.demo_date,
    d.total_hours,
    d.total_units_sold,
    d.demo_fee,
    d.store_busy_rating
  FROM demos d
  LEFT JOIN jt_demo_brands jdb ON d.id = jdb.demo_id
  LEFT JOIN brands b ON jdb.brand_id = b.id
  LEFT JOIN accounts a ON d.account_id = a.uuid
  WHERE d.id = demo_id_param
  GROUP BY a.account, d.demo_date, d.total_hours, d.total_units_sold, d.demo_fee, d.store_busy_rating;
END;
$$;
ALTER FUNCTION "public"."get_demo_details"("demo_id_param" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_demo_metrics"("demo_id_param" "uuid") RETURNS TABLE("demo_name" "text", "brands" "text", "store_name" "text", "demo_date" "date", "total_hours" numeric, "units_sold" integer, "demo_fee" numeric, "store_rating" integer)
    LANGUAGE "plpgsql"
    AS $$BEGIN
  RETURN QUERY
  SELECT 
    (string_agg(b.brand, ' + ') || ' - ' || a.account || ' - ' || TO_CHAR(d.demo_date, 'MM/DD/YYYY'))::TEXT,
    string_agg(b.brand, ' + ')::TEXT,
    a.account::TEXT,
    d.demo_date,
    d.total_hours,
    d.total_units_sold,
    d.demo_fee,
    d.store_busy_rating
  FROM demos d
  LEFT JOIN jt_demo_brands jdb ON d.id = jdb.demo_id
  LEFT JOIN brands b ON jdb.brand_id = b.id
  LEFT JOIN accounts a ON d.account_id = a.uuid
  WHERE d.id = demo_id_param
  GROUP BY a.account, d.demo_date, d.total_hours, d.total_units_sold, d.demo_fee, d.store_busy_rating;
END;$$;
ALTER FUNCTION "public"."get_demo_metrics"("demo_id_param" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_distinct_values"("_table_name" "text", "_column_name" "text") RETURNS TABLE("value" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    _dtype text;
BEGIN
    -- 1. Get the Data Type of the column first
    SELECT data_type INTO _dtype 
    FROM information_schema.columns 
    WHERE table_name = _table_name AND column_name = _column_name;

    -- 2. Build the query based on type
    -- SCENARIO A: It is a native Postgres Array (e.g., text[], uuid[])
    IF _dtype = 'ARRAY' THEN
        RETURN QUERY EXECUTE format(
            'SELECT DISTINCT unnest(%I)::text FROM %I WHERE %I IS NOT NULL ORDER BY 1 LIMIT 100',
            _column_name, _table_name, _column_name
        );

    -- SCENARIO B: It is JSONB (The complex object list)
    ELSIF _dtype = 'jsonb' THEN
        RETURN QUERY EXECUTE format(
            -- This logic tries to find a "name-like" key to display. 
            -- If it can't find 'name' or 'label', it falls back to the full text.
            'SELECT DISTINCT 
                CASE 
                    WHEN jsonb_typeof(elem) = ''object'' THEN 
                        COALESCE(elem->>''name'', elem->>''owner_name'', elem->>''sku_name'', elem->>''category_name'', elem->>''program'', elem::text)
                    ELSE elem::text 
                END
             FROM %I, jsonb_array_elements(%I) as elem 
             LIMIT 100',
            _table_name, _column_name
        );

    -- SCENARIO C: Standard Text/Integer
    ELSE
        RETURN QUERY EXECUTE format(
            'SELECT DISTINCT %I::text FROM %I WHERE %I IS NOT NULL ORDER BY 1 LIMIT 100', 
            _column_name, _table_name, _column_name
        );
    END IF;
END;
$$;
ALTER FUNCTION "public"."get_distinct_values"("_table_name" "text", "_column_name" "text") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb" DEFAULT '[]'::"jsonb", "_limit" integer DEFAULT 50, "_offset" integer DEFAULT 0) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    _query text;
    _filter_sql text := ' WHERE 1=1 '; 
    _filter_obj jsonb;
    _col text;
    _op text;
    _val text;
    _result jsonb;
BEGIN
    FOR _filter_obj IN SELECT * FROM jsonb_array_elements(_filters)
    LOOP
        _col := _filter_obj->>'col';
        _op  := _filter_obj->>'op';
        _val := _filter_obj->>'val';

        -- FIX: We add ::text to %I so UUIDs correspond correctly to the input text
        IF _op = 'eq' THEN
            _filter_sql := _filter_sql || format(' AND %I::text = %L', _col, _val);
            
        ELSIF _op = 'ilike' THEN 
            _filter_sql := _filter_sql || format(' AND %I::text ILIKE %L', _col, '%' || _val || '%');
            
        ELSIF _op = 'in' THEN 
            -- The magic fix for Multi-selects
            _filter_sql := _filter_sql || format(' AND %I::text = ANY(string_to_array(%L, '',''))', _col, _val);
            
        -- Numeric comparisons don't use ::text because math requires numbers
        ELSIF _op = 'gt' THEN
            _filter_sql := _filter_sql || format(' AND %I > %L', _col, _val);
        ELSIF _op = 'lt' THEN
            _filter_sql := _filter_sql || format(' AND %I < %L', _col, _val);
        END IF;
    END LOOP;

    _query := format('SELECT jsonb_agg(t) FROM (SELECT * FROM %I %s LIMIT %L OFFSET %L) t', _table_name, _filter_sql, _limit, _offset);
    EXECUTE _query INTO _result;
    RETURN COALESCE(_result, '[]'::jsonb);
END;
$$;
ALTER FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb", "_limit" integer, "_offset" integer) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb" DEFAULT '[]'::"jsonb", "_limit" integer DEFAULT 150, "_offset" integer DEFAULT 0, "_logic" "text" DEFAULT 'AND'::"text") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    _query text;
    _filter_sql text;
    _filter_obj jsonb;
    _col text;
    _op  text;
    _val text;
    _sep text; -- Separator (AND / OR)
    _result jsonb;
BEGIN
    -- 1. Determine starting point based on logic
    IF _logic = 'OR' THEN
        _filter_sql := ' WHERE 1=0 '; -- Start false so "OR" can make it true
        _sep := ' OR ';
    ELSE
        _filter_sql := ' WHERE 1=1 '; -- Start true so "AND" can restrict it
        _sep := ' AND ';
    END IF;

    -- 2. Loop through filters
    FOR _filter_obj IN SELECT * FROM jsonb_array_elements(_filters)
    LOOP
        _col := _filter_obj->>'col';
        _op  := _filter_obj->>'op';
        _val := _filter_obj->>'val';

        -- 3. Append condition using the dynamic separator (_sep)
        
        -- EQUALS (=)
        IF _op = 'eq' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text = %L', _col, _val);
        
        -- DOES NOT EQUAL (!=)
        ELSIF _op = 'neq' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text <> %L', _col, _val);

        -- CONTAINS (ilike)
        ELSIF _op = 'ilike' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text ILIKE %L', _col, '%' || _val || '%');

        -- DOES NOT CONTAIN (not ilike)
        ELSIF _op = 'not_ilike' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text NOT ILIKE %L', _col, '%' || _val || '%');

        -- STARTS WITH
        ELSIF _op = 'starts_with' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text ILIKE %L', _col, _val || '%');

        -- ENDS WITH
        ELSIF _op = 'ends_with' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text ILIKE %L', _col, '%' || _val);

        -- IS EMPTY (Null or Empty String)
        ELSIF _op = 'is_empty' THEN
            _filter_sql := _filter_sql || _sep || format('(%I IS NULL OR %I::text = '''')', _col, _col);

        -- IS NOT EMPTY
        ELSIF _op = 'is_not_empty' THEN
            _filter_sql := _filter_sql || _sep || format('(%I IS NOT NULL AND %I::text <> '''')', _col, _col);

        -- IS ONE OF (In Array)
        ELSIF _op = 'in' THEN
            _filter_sql := _filter_sql || _sep || format('%I::text = ANY(string_to_array(%L, '',''))', _col, _val);

        -- GREATER THAN (>)
        ELSIF _op = 'gt' THEN
            _filter_sql := _filter_sql || _sep || format('%I > %L', _col, _val);

        -- GREATER OR EQUAL (>=)
        ELSIF _op = 'gte' THEN
            _filter_sql := _filter_sql || _sep || format('%I >= %L', _col, _val);

        -- LESS THAN (<)
        ELSIF _op = 'lt' THEN
            _filter_sql := _filter_sql || _sep || format('%I < %L', _col, _val);

        -- LESS OR EQUAL (<=)
        ELSIF _op = 'lte' THEN
            _filter_sql := _filter_sql || _sep || format('%I <= %L', _col, _val);

        END IF;
    END LOOP;

    -- 4. Execute
    _query := format('SELECT jsonb_agg(t) FROM (SELECT * FROM %I %s LIMIT %L OFFSET %L) t', _table_name, _filter_sql, _limit, _offset);
    EXECUTE _query INTO _result;
    
    RETURN COALESCE(_result, '[]'::jsonb);
END;
$$;
ALTER FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb", "_limit" integer, "_offset" integer, "_logic" "text") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_folder_path"("target_folder_id" "uuid") RETURNS TABLE("id" "uuid", "name" "text", "level" integer)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  WITH RECURSIVE folder_tree AS (
    -- Base case: start at the target folder
    SELECT f.id, f.name, f.parent_id, 1 as level
    FROM folders f
    WHERE f.id = target_folder_id
    
    UNION ALL
    
    -- Recursive step: climb up to the parent
    SELECT p.id, p.name, p.parent_id, ft.level + 1
    FROM folders p
    JOIN folder_tree ft ON ft.parent_id = p.id
  )
  -- Return results ordered from Root to Child (Home -> Folder)
  SELECT ft.id, ft.name, ft.level
  FROM folder_tree ft
  ORDER BY ft.level DESC;
END;
$$;
ALTER FUNCTION "public"."get_folder_path"("target_folder_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_grouped_syncup_notes"("p_brand_id" "uuid" DEFAULT NULL::"uuid", "p_account_id" "uuid" DEFAULT NULL::"uuid") RETURNS TABLE("formatted_date" "text", "day_start" "text", "daily_notes" "jsonb")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        TO_CHAR(DATE_TRUNC('day', note_details.sync_date), 'Mon DD,YYYY') AS formatted_date,
        TO_CHAR(DATE_TRUNC('day', note_details.sync_date), 'YYYY-MM-DD') AS day_start,
        JSONB_AGG(
            JSONB_BUILD_OBJECT(
                'id',                    note_details.uuid,
                'team_member_id',        note_details.team_member_uuid,
                'team_member_name',      note_details.team_member_name,
                'profile_photo',         note_details.profile_photo,
                'note',                  note_details.note,
                'sync_date',             note_details.sync_date, 
                'updated_at',            note_details.updated_at, 
                'user_id',               note_details.user_id,
                'associated_brands',     note_details.associated_brands,
                'associated_accounts',   note_details.associated_accounts 
            )
            ORDER BY note_details.sync_date ASC 
        ) AS daily_notes
    FROM (
        -- Select all relevant notes, join their user details, and aggregate their associated brands and accounts
        SELECT
            sn.uuid,
            sn.note,
            sn.sync_date,
            sn.updated_at,
            sn."user" AS user_id,
            tmg.uuid AS team_member_uuid,
            tmg.name AS team_member_name,
            tmg.profile_photo,
            (
                SELECT JSONB_AGG(
                            JSONB_BUILD_OBJECT(
                                'jt_id', js_inner.id,
                                'brand_id', b_inner.id,
                                'brand_name', b_inner.brand
                            )
                            ORDER BY b_inner.brand
                        ) FILTER (WHERE b_inner.id IS NOT NULL)
                FROM public.jt_sync_up_notes_brands js_inner
                JOIN public.brands b_inner ON js_inner.brand_id = b_inner.id
                WHERE js_inner.note_id = sn.uuid
            ) AS associated_brands,
            (
                -- Corrected subquery to aggregate associated accounts
                SELECT JSONB_AGG(
                            JSONB_BUILD_OBJECT(
                                'jt_id', ja_inner.id,
                                'account_id', a_inner.uuid, -- The UUID for the account
                                'account_name', a_inner.account -- *** CORRECTED COLUMN NAME IS 'account' ***
                            )
                            ORDER BY a_inner.account -- *** CORRECTED COLUMN NAME IS 'account' ***
                        ) FILTER (WHERE a_inner.uuid IS NOT NULL)
                FROM public.jt_sync_up_notes_accounts ja_inner
                JOIN public.accounts a_inner ON ja_inner.account_id = a_inner.uuid -- Join to the accounts table on UUID
                WHERE ja_inner.note_id = sn.uuid
            ) AS associated_accounts -- Corrected column
        FROM
            public.syncup_notes AS sn
        LEFT JOIN
            public.team_member_guide AS tmg ON sn.team_member = tmg.uuid
        WHERE
            -- Check for existence of EITHER a brand or an account association, if no brand/account filter is applied
            EXISTS (
                SELECT 1
                FROM public.jt_sync_up_notes_brands js_check_exists
                WHERE js_check_exists.note_id = sn.uuid
            )
            OR EXISTS (
                SELECT 1
                FROM public.jt_sync_up_notes_accounts ja_check_exists
                WHERE ja_check_exists.note_id = sn.uuid
            )
            -- Apply brand filter
            AND (
                p_brand_id IS NULL
                OR EXISTS (
                    SELECT 1
                    FROM public.jt_sync_up_notes_brands js_filter
                    WHERE js_filter.note_id = sn.uuid
                        AND js_filter.brand_id = p_brand_id
                )
            )
            -- Apply account filter 
            AND (
                p_account_id IS NULL
                OR EXISTS (
                    SELECT 1
                    FROM public.jt_sync_up_notes_accounts ja_filter
                    WHERE ja_filter.note_id = sn.uuid
                        AND ja_filter.account_id = p_account_id
                )
            )
    ) AS note_details
    GROUP BY DATE_TRUNC('day', note_details.sync_date)
    ORDER BY DATE_TRUNC('day', note_details.sync_date) DESC;
END;
$$;
ALTER FUNCTION "public"."get_grouped_syncup_notes"("p_brand_id" "uuid", "p_account_id" "uuid") OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."hh_customers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "company" "text",
    "email" "text" NOT NULL,
    "phone" "text",
    "status" "public"."hh_customer_status_enum",
    "role" "public"."hh_user_role_enum",
    "rate" numeric(10,2),
    "promo_code" "text",
    "promo_description" "text",
    "promo_code_id" "text",
    "billing_terms" "public"."hh_billing_terms_enum",
    "payment_status" "public"."hh_payment_status_enum",
    "payment_date" "date",
    "cancelation_date" "date",
    "cancellation_reason" "text",
    "customer_notes" "text",
    "profile_photo" "text",
    "cr_assigned" boolean DEFAULT false,
    "hh_contributions" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "hh_license" "uuid",
    "lead_source" "uuid",
    "discounted_rate" numeric,
    "invoiced_amount" "text",
    "total_amount_invoiced" numeric GENERATED ALWAYS AS (
CASE
    WHEN ("rate" IS NULL) THEN NULL::numeric
    ELSE "round"(("rate" * ((1)::numeric - (COALESCE("discounted_rate", (0)::numeric) / (100)::numeric))), 2)
END) STORED,
    "startup_cpg_amount_owed" numeric(10,2) GENERATED ALWAYS AS (
CASE
    WHEN (("promo_code" ~~* '%STARTUPCPG20OFF%'::"text") AND ("invoiced_amount" ~ '^[0-9.]+$'::"text")) THEN "round"((("invoiced_amount")::numeric * 0.5), 2)
    ELSE 0.00
END) STORED,
    "startup_cpg_paid" boolean,
    "startup_cpg_paid_date" "date",
    "modified_by" "uuid",
    "prospect_inquiry_message_from_website" "text",
    "customer_status" "uuid"
);
ALTER TABLE "public"."hh_customers" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_customers" IS 'All the harvest hub customers rest here';
COMMENT ON COLUMN "public"."hh_customers"."discounted_rate" IS 'Rate of discount with promo code applied.';
COMMENT ON COLUMN "public"."hh_customers"."startup_cpg_paid" IS 'Startup CPG’s revenue share payment for this customer has been reconciled and sent.';
COMMENT ON COLUMN "public"."hh_customers"."startup_cpg_paid_date" IS 'Date Startup CPG’s revenue share payment was issued.';
COMMENT ON COLUMN "public"."hh_customers"."modified_by" IS 'Will default to Unknown User uuid.';
CREATE TABLE IF NOT EXISTS "public"."jt_hh_customers_category_reviews" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid",
    "category_review_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_hh_customers_category_reviews" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_hh_customers_category_reviews" IS 'Junction table for mapping out harvest hub customers to category reviews';
CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "name" "text",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "brand_id" "uuid",
    "department" "public"."Departments",
    "user_type" "public"."user_type",
    "profile_photo" "text"
);
ALTER TABLE "public"."profiles" OWNER TO "postgres";
COMMENT ON TABLE "public"."profiles" IS 'public profiles belonging to the auth.users';
CREATE OR REPLACE VIEW "public"."v_harvesthub_customer_datagrid" AS
 SELECT "c"."id",
    "c"."name",
    "c"."company",
    "c"."email",
    "c"."phone",
    "c"."status",
    "c"."role",
    "c"."rate",
    "c"."promo_code",
    "c"."promo_description",
    "c"."billing_terms",
    "c"."payment_status",
    "c"."payment_date",
    "c"."cr_assigned",
    "c"."discounted_rate",
    "c"."total_amount_invoiced",
    "c"."startup_cpg_amount_owed",
    "c"."created_at",
    ( SELECT "jsonb_agg"("jt"."category_review_id") AS "jsonb_agg"
           FROM "public"."jt_hh_customers_category_reviews" "jt"
          WHERE ("jt"."customer_id" = "c"."id")) AS "category_reviews",
    "c"."promo_code_id",
    "c"."cancellation_reason",
    "c"."customer_notes",
    "c"."profile_photo",
    "c"."updated_at",
    "c"."invoiced_amount",
    "c"."startup_cpg_paid",
    "c"."startup_cpg_paid_date",
    "jsonb_build_object"('id', "p"."id", 'name', "p"."name", 'profile_photo', "p"."profile_photo") AS "last_modified_by"
   FROM ("public"."hh_customers" "c"
     LEFT JOIN "public"."profiles" "p" ON (("c"."modified_by" = "p"."id")));
ALTER TABLE "public"."v_harvesthub_customer_datagrid" OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_harvesthub_customers"() RETURNS SETOF "public"."v_harvesthub_customer_datagrid"
    LANGUAGE "sql" SECURITY DEFINER
    AS $$
  SELECT * FROM public.v_harvesthub_customer_datagrid;
$$;
ALTER FUNCTION "public"."get_harvesthub_customers"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_hh_system_stats"() RETURNS TABLE("total_customers" integer, "active_customers" integer, "total_category_reviews" integer, "upcoming_deadlines" integer, "pending_contributions" integer, "active_experts" integer)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*)::INTEGER FROM hh_customers),
        (SELECT COUNT(*)::INTEGER FROM hh_customers WHERE status = 'active_customer'),
        (SELECT COUNT(*)::INTEGER FROM hh_category_reviews),
        (SELECT COUNT(*)::INTEGER FROM hh_category_reviews 
         WHERE new_item_submission_deadline BETWEEN CURRENT_DATE AND CURRENT_DATE + 30),
        (SELECT COUNT(*)::INTEGER FROM hh_contributions WHERE validation_status = 'pending_review'),
        (SELECT COUNT(*)::INTEGER FROM hh_community_experts WHERE status = 'active');
END;
$$;
ALTER FUNCTION "public"."get_hh_system_stats"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_loggedinbrandinfo"("brand_id" "uuid") RETURNS SETOF "public"."brands"
    LANGUAGE "sql"
    AS $$
  select * from brands where id = brand_id;
$$;
ALTER FUNCTION "public"."get_loggedinbrandinfo"("brand_id" "uuid") OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."company_announcements" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "announcement" "text",
    "image" "text",
    "audience" "public"."Audience"[],
    "archive" boolean,
    "announcement_tags" "public"."Announcement Tag"[],
    "announcement_date" "date",
    "announcement_title" "text",
    "publish" boolean
);
ALTER TABLE "public"."company_announcements" OWNER TO "postgres";
COMMENT ON TABLE "public"."company_announcements" IS 'Announcements that will display on announcement page on the vendor portal. Also can be used for internal communications';
COMMENT ON COLUMN "public"."company_announcements"."announcement" IS 'Type our your message and tag an audience.';
COMMENT ON COLUMN "public"."company_announcements"."audience" IS 'Choose who this announcement is intended for';
COMMENT ON COLUMN "public"."company_announcements"."archive" IS 'Hide this message';
COMMENT ON COLUMN "public"."company_announcements"."announcement_tags" IS 'tag a topic';
COMMENT ON COLUMN "public"."company_announcements"."announcement_date" IS 'The date that displays on the app for the update.';
COMMENT ON COLUMN "public"."company_announcements"."announcement_title" IS 'Brief title for the announcement';
COMMENT ON COLUMN "public"."company_announcements"."publish" IS 'Set to true when ready to publish';
CREATE OR REPLACE FUNCTION "public"."get_next_announcement"() RETURNS SETOF "public"."company_announcements"
    LANGUAGE "sql" STABLE
    AS $$SELECT *
  FROM public.company_announcements
  WHERE announcement_date >= CURRENT_DATE
    AND publish IS TRUE
    AND (archive IS NOT TRUE)
  ORDER BY announcement_date ASC
  LIMIT 1;$$;
ALTER FUNCTION "public"."get_next_announcement"() OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."contacts" (
    "verification_needed" "public"."verification_status",
    "job_title" "text",
    "contact_email" "text",
    "contact_phone" "text",
    "department_tags" "public"."Department Tags (Deprecated) RH"[],
    "contact_notes" "text",
    "last_modified" timestamp without time zone DEFAULT "now"(),
    "create_date" "text",
    "first_name" "text",
    "last_name" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "full_name" "text" GENERATED ALWAYS AS ((("first_name" || ' '::"text") || "last_name")) STORED,
    "full_name_and_account" "text",
    "name_and_title" "text",
    "hide_from_apps" boolean,
    "account" "uuid",
    "no_contact_details" "public"."No Contact Details"[],
    "enriched_email" "text",
    "enriched_phone" "text",
    "enriched_company_name" "text",
    "enriched_job_title" "text",
    "last_enriched_timestamp" "text",
    "updated_by" "text"
);
ALTER TABLE "public"."contacts" OWNER TO "postgres";
COMMENT ON TABLE "public"."contacts" IS 'GNF has account representatives. This table lists all the contacts corresponding to our accounts.';
COMMENT ON COLUMN "public"."contacts"."full_name" IS 'Concatenation first and last name fields.';
COMMENT ON COLUMN "public"."contacts"."hide_from_apps" IS 'Contacts who don''t want to appear in our apps.';
COMMENT ON COLUMN "public"."contacts"."account" IS 'References account contact is associated with.';
COMMENT ON COLUMN "public"."contacts"."enriched_email" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
COMMENT ON COLUMN "public"."contacts"."enriched_phone" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
COMMENT ON COLUMN "public"."contacts"."enriched_company_name" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
COMMENT ON COLUMN "public"."contacts"."enriched_job_title" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
COMMENT ON COLUMN "public"."contacts"."last_enriched_timestamp" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
CREATE TABLE IF NOT EXISTS "public"."jt_contacts_categories_managed" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "contact_id" "uuid" NOT NULL,
    "master_category_review_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "master_category_id" "uuid"
);
ALTER TABLE "public"."jt_contacts_categories_managed" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_contacts_categories_managed" IS 'Categories that each contact is responsible for. Links to the master categories';
CREATE TABLE IF NOT EXISTS "public"."jt_master_categories_brands" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "master_category_id" "uuid" NOT NULL,
    "brand_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_master_categories_brands" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_master_categories_brands" IS 'Brands product categories they''ve selected.  A brand can have multiple items of different categories.';
CREATE TABLE IF NOT EXISTS "public"."jt_matched_brands_to_category_reviews" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "review_id" "uuid",
    "brand_match_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);
ALTER TABLE "public"."jt_matched_brands_to_category_reviews" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_matched_brands_to_category_reviews" IS 'Link for brands matching their category reviews';
CREATE TABLE IF NOT EXISTS "public"."master_categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "full_category" "text",
    "category" "public"."category_enum (deprecated?)",
    "subcategory" "text",
    "notes" "text",
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "ref_department_tags_uuid" "uuid"
);
ALTER TABLE "public"."master_categories" OWNER TO "postgres";
COMMENT ON TABLE "public"."master_categories" IS 'All the GNF defined categories live here. The brands use this to onboard themselves and their products/items. Also used to map out the review data per category';
COMMENT ON COLUMN "public"."master_categories"."full_category" IS 'Concatenation of category field and subcategory';
CREATE TABLE IF NOT EXISTS "public"."master_category_review_data" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "display_name" "text",
    "account" "uuid",
    "retailer_category" "text",
    "retailer_review_timing" "text",
    "reset_date" "date",
    "review_type" "text",
    "retailer_review_date" "date",
    "on_shelf_reset_date" "date",
    "new_item_submission_deadline" "date",
    "master_category_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "archive" boolean,
    "gnf_sub_category" "uuid",
    "category_specific_review_notes" "text",
    "category_cancellation" boolean,
    "cr_review_type" "uuid",
    "retailer_gnf_category_matching" "uuid"
);
ALTER TABLE "public"."master_category_review_data" OWNER TO "postgres";
COMMENT ON TABLE "public"."master_category_review_data" IS 'This is where all the category review data is stored for eveyr category and is matched/mapped using the matching table';
COMMENT ON COLUMN "public"."master_category_review_data"."master_category_id" IS 'AKA GNF Category';
COMMENT ON COLUMN "public"."master_category_review_data"."archive" IS 'Toggle this for reviews that are archived';
COMMENT ON COLUMN "public"."master_category_review_data"."gnf_sub_category" IS 'Links to master categories';
COMMENT ON COLUMN "public"."master_category_review_data"."category_specific_review_notes" IS 'Notes left for each category';
COMMENT ON COLUMN "public"."master_category_review_data"."category_cancellation" IS 'If a retailer cancels review.';
CREATE OR REPLACE VIEW "public"."v_brand_matching" AS
 WITH "aggregated_managers" AS (
         SELECT "jccm"."master_category_review_id" AS "review_id",
            "array_agg"(DISTINCT "c"."uuid") FILTER (WHERE ("c"."uuid" IS NOT NULL)) AS "manager_ids",
            "jsonb_agg"("jsonb_build_object"('id', "c"."uuid", 'name', "c"."full_name", 'email', "c"."contact_email", 'phone', "c"."contact_phone", 'title', "c"."job_title")) AS "managers_list"
           FROM ("public"."jt_contacts_categories_managed" "jccm"
             JOIN "public"."contacts" "c" ON (("jccm"."contact_id" = "c"."uuid")))
          GROUP BY "jccm"."master_category_review_id"
        ), "aggregated_brands" AS (
         SELECT "link"."review_id",
            "count"("link"."id") AS "brand_count",
            "jsonb_agg"("jsonb_build_object"('match_id', "link"."id", 'brand_id', "b"."id", 'brand_name', "b"."brand", 'brand_logo', "b"."brand_logo", 'manufacturer_name', "b"."manufacturer_name", 'brand_status', "b"."status", 'matched_on', "link"."created_at") ORDER BY "b"."brand") AS "brands_array",
            "max"("mc_1"."updated_at") AS "category_updated_at"
           FROM ((("public"."jt_matched_brands_to_category_reviews" "link"
             JOIN "public"."jt_master_categories_brands" "jmc" ON (("link"."brand_match_id" = "jmc"."id")))
             JOIN "public"."brands" "b" ON (("jmc"."brand_id" = "b"."id")))
             JOIN "public"."master_categories" "mc_1" ON (("jmc"."master_category_id" = "mc_1"."id")))
          GROUP BY "link"."review_id"
        )
 SELECT "r"."id" AS "review_id",
    "r"."master_category_id" AS "category_id",
    COALESCE("r"."display_name", "r"."retailer_category", 'Unnamed Review'::"text") AS "review_name",
    "r"."review_type",
    "r"."retailer_review_timing",
    "r"."new_item_submission_deadline",
    "r"."on_shelf_reset_date",
    "r"."archive" AS "is_archived",
    "mc"."full_category",
    "mc"."subcategory",
    "mc"."category" AS "category_type",
    COALESCE("ab"."brands_array", '[]'::"jsonb") AS "linked_brands_array",
    COALESCE("ab"."brand_count", (0)::bigint) AS "linked_brands_count",
    COALESCE("am"."manager_ids", ARRAY[]::"uuid"[]) AS "filter_manager_ids",
    COALESCE("am"."managers_list", '[]'::"jsonb") AS "category_managers",
    GREATEST("r"."updated_at", "ab"."category_updated_at") AS "last_modified"
   FROM ((("public"."master_category_review_data" "r"
     LEFT JOIN "public"."master_categories" "mc" ON (("r"."master_category_id" = "mc"."id")))
     JOIN "aggregated_brands" "ab" ON (("r"."id" = "ab"."review_id")))
     LEFT JOIN "aggregated_managers" "am" ON (("r"."id" = "am"."review_id")));
ALTER TABLE "public"."v_brand_matching" OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_next_category_review_deadline"() RETURNS SETOF "public"."v_brand_matching"
    LANGUAGE "sql" STABLE
    AS $$
  SELECT *
  FROM public.v_brand_matching
  WHERE 
    new_item_submission_deadline IS NOT NULL 
    AND new_item_submission_deadline >= CURRENT_DATE
  ORDER BY 
    new_item_submission_deadline ASC
  LIMIT 1;
$$;
ALTER FUNCTION "public"."get_next_category_review_deadline"() OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "event_name" "text" NOT NULL,
    "event_year" integer,
    "event_dates" "text",
    "event_tags" "text"[],
    "location" "text",
    "website" "text",
    "notes" "text",
    "event_forms" "text"[],
    "event_dispay_image" "text",
    "event_description" "text",
    "goodnow_participation" "public"."GoodNow Event Participation Status",
    "booth_number" "text",
    "accommodations" "text",
    "event_display_name" "text" GENERATED ALWAYS AS ((("event_name" || ' - '::"text") || ("event_year")::"text")) STORED,
    "internal_event_planning_forms" "jsonb",
    "start_date" "date",
    "end_date" "date",
    "display_name" "text" GENERATED ALWAYS AS (("event_name" || COALESCE((' - '::"text" || ("event_year")::"text"), ' - '::"text"))) STORED,
    "gn_participation_status" "uuid",
    "event_show_forms" "jsonb",
    "created" timestamp with time zone DEFAULT "now"(),
    "last_modified" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."events" OWNER TO "postgres";
COMMENT ON TABLE "public"."events" IS 'Most brands attend the events like food shows or conferences and they mostly come along with GNF. This table has all the event information';
COMMENT ON COLUMN "public"."events"."event_forms" IS 'Public facing forms that can be displayed out';
COMMENT ON COLUMN "public"."events"."goodnow_participation" IS 'Is our company participating in this event';
COMMENT ON COLUMN "public"."events"."booth_number" IS 'Our booth # for this event.';
COMMENT ON COLUMN "public"."events"."accommodations" IS 'Where are team is staying during the event, along with notes.';
COMMENT ON COLUMN "public"."events"."internal_event_planning_forms" IS 'For internal use; booth layout docs, planning, etc.';
COMMENT ON COLUMN "public"."events"."start_date" IS 'start date for the event';
COMMENT ON COLUMN "public"."events"."end_date" IS 'date when the event ends';
CREATE TABLE IF NOT EXISTS "public"."jt_brand_events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "brand_id" "uuid" NOT NULL,
    "event_id" "uuid" NOT NULL,
    "price_to_attend" numeric(10,2),
    "attendees" "text",
    "brand_notes" "text",
    "confirmed_brand_attendees" "text",
    "attendance_status" "public"."attendance_status_enum"
);
ALTER TABLE "public"."jt_brand_events" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_brand_events" IS 'Junction table to track which brand is attending a particular event';
COMMENT ON COLUMN "public"."jt_brand_events"."attendance_status" IS 'Brands status for an event. Select one';
CREATE TABLE IF NOT EXISTS "public"."jt_team_members_x_events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "event_id" "uuid" NOT NULL,
    "team_member_id" "uuid" NOT NULL,
    "role" "text",
    "notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_team_members_x_events" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_team_members_x_events" IS 'Team members that are attending events';
CREATE TABLE IF NOT EXISTS "public"."team_member_guide" (
    "name" "text" NOT NULL,
    "status" "public"."employee_status_enum",
    "title" "text",
    "address" "text",
    "phone_number" "text",
    "department" "public"."Departments"[],
    "send_samples" "text",
    "food_handlers_card" "text",
    "calls_counted_by_team_member" "text",
    "counter" "text",
    "email" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "profile_photo" "text",
    "key_support" "text"[],
    "regional_coverage" "text"[],
    "time_zone" "text",
    "country_of_origin" "text",
    "language_spoken" "text"[],
    "user_id" "uuid",
    "last_modified" timestamp with time zone,
    "legacy_id" "text"
);
ALTER TABLE "public"."team_member_guide" OWNER TO "postgres";
COMMENT ON TABLE "public"."team_member_guide" IS 'Contains information of all the employees can be used for package drops and filter based on status = "Active"';
COMMENT ON COLUMN "public"."team_member_guide"."key_support" IS 'Key support for each team member';
COMMENT ON COLUMN "public"."team_member_guide"."regional_coverage" IS 'Regions the sales team covers';
COMMENT ON COLUMN "public"."team_member_guide"."time_zone" IS 'Team members time zone';
COMMENT ON COLUMN "public"."team_member_guide"."country_of_origin" IS 'Where the team member resides';
CREATE OR REPLACE VIEW "public"."events_detailed_view" AS
 WITH "brand_attendees" AS (
         SELECT "jbe"."event_id",
            "jsonb_agg"("jsonb_build_object"('brand_id', "b"."id", 'brand_name', "b"."brand", 'attendance_status', "jbe"."attendance_status", 'price_to_attend', "jbe"."price_to_attend", 'attendees_list', "jbe"."attendees", 'confirmed_brand_attendees', "jbe"."confirmed_brand_attendees", 'brand_notes', "jbe"."brand_notes")) AS "attending_brands"
           FROM ("public"."jt_brand_events" "jbe"
             JOIN "public"."brands" "b" ON (("jbe"."brand_id" = "b"."id")))
          GROUP BY "jbe"."event_id"
        ), "team_attendees" AS (
         SELECT "jte"."event_id",
            "jsonb_agg"("jsonb_build_object"('team_member_id', "tm"."uuid", 'name', "tm"."name", 'profile_pic', "tm"."profile_photo", 'role', "jte"."role", 'notes', "jte"."notes")) AS "attending_team"
           FROM ("public"."jt_team_members_x_events" "jte"
             JOIN "public"."team_member_guide" "tm" ON (("jte"."team_member_id" = "tm"."uuid")))
          GROUP BY "jte"."event_id"
        )
 SELECT "e"."id",
    "e"."event_name",
    "e"."event_year",
    "e"."event_dates",
    "e"."event_tags",
    "e"."location",
    "e"."website",
    "e"."notes",
    "e"."event_forms",
    "e"."event_dispay_image",
    "e"."event_description",
    "e"."goodnow_participation",
    "e"."booth_number",
    "e"."accommodations",
    "e"."event_display_name",
    "e"."internal_event_planning_forms",
    "e"."start_date",
    "e"."end_date",
    "ba"."attending_brands",
    "ta"."attending_team"
   FROM (("public"."events" "e"
     LEFT JOIN "brand_attendees" "ba" ON (("e"."id" = "ba"."event_id")))
     LEFT JOIN "team_attendees" "ta" ON (("e"."id" = "ta"."event_id")));
ALTER TABLE "public"."events_detailed_view" OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_next_event"() RETURNS SETOF "public"."events_detailed_view"
    LANGUAGE "sql"
    AS $$
  SELECT *
  FROM public.events_detailed_view -- It searches the "library" (your view)
  WHERE start_date >= CURRENT_DATE -- Finds ones that haven't happened
  ORDER BY start_date ASC           -- Puts the soonest one first
  LIMIT 1;                          -- And ONLY grabs that single one
$$;
ALTER FUNCTION "public"."get_next_event"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_next_planned_submission"() RETURNS TABLE("submission_id" "uuid", "planned_date" "date", "submission_status" boolean, "deal_id" "uuid", "category_review_id" "uuid", "review_name" "text", "brand_name" "text", "deal_name" "text", "brand_logo" "text")
    LANGUAGE "sql" STABLE
    AS $$
  SELECT
    ps.id as submission_id,
    ps.planned_submission_date as planned_date,
    ps.submission_status,
    ps.deal_id,
    ps.category_review as category_review_id,
    mcrd.display_name as review_name,
    b.brand as brand_name,
    
    -- New Columns
    at.activity_name as deal_name,
    b.brand_logo as brand_logo

  FROM public.planned_submissions ps
  
  LEFT JOIN public.master_category_review_data mcrd
    ON ps.category_review = mcrd.id

  LEFT JOIN public.activity_tracker at
    ON ps.deal_id = at.id
    
  LEFT JOIN public.brands b
    ON at.brand = b.id

  WHERE
    ps.planned_submission_date >= CURRENT_DATE
    AND (ps.submission_status IS FALSE OR ps.submission_status IS NULL)
  ORDER BY ps.planned_submission_date ASC
  LIMIT 1;
$$;
ALTER FUNCTION "public"."get_next_planned_submission"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuids" "uuid"[]) RETURNS TABLE("note_id" "uuid", "note_content" "text", "sync_date" timestamp with time zone, "brand_id" "uuid", "brand_name" "text", "team_member_id" "uuid", "team_member_name" "text", "team_member_profile_photo" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        sn.uuid AS note_id,
        sn.note AS note_content,
        sn.sync_date AS sync_date,
        sn.brand AS brand_id,
        b.brand AS brand_name,
        sn.team_member AS team_member_id,
        tmg.name AS team_member_name,
        tmg.profile_photo AS team_member_profile_photo
    FROM
        public.syncup_notes sn
    LEFT JOIN
        public.brands b ON sn.brand = b.id
    LEFT JOIN
        public.team_member_guide tmg ON sn.team_member = tmg.uuid
    WHERE
        p_brand_uuids IS NULL
        OR CARDINALITY(p_brand_uuids) = 0
        OR sn.brand = ANY(p_brand_uuids);
END;
$$;
ALTER FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuids" "uuid"[]) OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuid" "uuid") RETURNS TABLE("note_id" "uuid", "note_content" "text", "sync_date" timestamp with time zone, "brand_id" "uuid", "brand_name" "text", "team_member_id" "uuid", "team_member_name" "text", "team_member_profile_photo" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        sn.uuid AS note_id,
        sn.note AS note_content,
        sn.sync_date AS sync_date,
        sn.brand AS brand_id,
        b.brand AS brand_name,
        sn.team_member AS team_member_id,
        tmg.name AS team_member_name,
        tmg.profile_photo AS team_member_profile_photo
    FROM
        public.syncup_notes sn
    LEFT JOIN
        public.brands b ON sn.brand = b.id
    LEFT JOIN
        public.team_member_guide tmg ON sn.team_member = tmg.uuid
    WHERE
        p_brand_uuid IS NULL -- Still allow for a NULL UUID if you want to fetch all
        OR sn.brand = p_brand_uuid; -- Changed from ANY(p_brand_uuids) to direct comparison
END;
$$;
ALTER FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuid" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_related_skus"("input_brand_id" "uuid") RETURNS TABLE("id" "uuid", "description" "text", "item_status" "text", "upc_12_digit" "text")
    LANGUAGE "sql"
    AS $$
  select
    id,
    description,
    item_status,
    upc_12_digit
  FROM
    spec_price_sheet
  WHERE
    brand_id = input_brand_id;
$$;
ALTER FUNCTION "public"."get_related_skus"("input_brand_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_retailers_for_category"("category_name" "text") RETURNS TABLE("retailer_name" "text", "retailer_city" "text", "store_count" "text", "submission_deadline" "date", "days_remaining" integer, "review_type" "text", "retailer_category" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.account,
        a.city,
        a.store_count,
        cr.new_item_submission_deadline,
        (cr.new_item_submission_deadline - CURRENT_DATE)::INTEGER,
        cr.review_type,
        cr.retailer_category
    FROM hh_category_reviews cr
    JOIN accounts a ON cr.account_id = a.uuid
    WHERE cr.gnf_category ILIKE '%' || category_name || '%'
    AND cr.new_item_submission_deadline > CURRENT_DATE
    ORDER BY cr.new_item_submission_deadline;
END;
$$;
ALTER FUNCTION "public"."get_retailers_for_category"("category_name" "text") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_retailers_for_category"("category_uuid" "uuid") RETURNS TABLE("retailer_name" "text", "retailer_city" "text", "store_count" "text", "submission_deadline" "date", "days_remaining" integer, "review_type" "text", "retailer_category" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.account,
        a.city,
        a.store_count,
        cr.new_item_submission_deadline,
        (cr.new_item_submission_deadline - CURRENT_DATE)::INTEGER,
        cr.review_type,
        cr.retailer_category
    FROM master_category_review_data cr
    JOIN accounts a ON cr.account = a.uuid
    WHERE cr.master_category_id = category_uuid
    AND cr.new_item_submission_deadline > CURRENT_DATE
    AND (cr.archive IS NOT TRUE OR cr.archive IS NULL)
    ORDER BY cr.new_item_submission_deadline;
END;
$$;
ALTER FUNCTION "public"."get_retailers_for_category"("category_uuid" "uuid") OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."spec_price_sheet" (
    "description" "text",
    "item_status" "public"."item_status",
    "sales_rank" "text",
    "vendor_item_number" "text",
    "upc_12_digit" "text",
    "ean" "text",
    "case_upc" "text",
    "master_upc" "text",
    "case_pack" "text",
    "master_pack" "text",
    "unit_height_inches" "text",
    "unit_width_inches" "text",
    "unit_depth_inches" "text",
    "case_height_inches" "text",
    "case_width_inches" "text",
    "case_depth_inches" "text",
    "master_case_height_inches" "text",
    "master_case_width_inches" "text",
    "master_case_depth_inches" "text",
    "net_case_weight_lbs" "text",
    "gross_case_weight_lbs" "text",
    "master_case_weight_lbs" "text",
    "ti" "text",
    "hi" "text",
    "cube" "text",
    "cases_per_pallet" "text",
    "pallet_weight_lbs" "text",
    "item_temp_reqs" "public"."transport_enum",
    "fob_location" "text",
    "srp" "text",
    "direct_ship_available" "text",
    "direct_ship_cost_case" "text",
    "fob_price_case" "text",
    "unit_cost_fob" "text",
    "delivered_west_distribution_by_case" "text",
    "delivered_east_distribution_by_case" "text",
    "minimum_direct_order_quantity" "text",
    "minimum_order_quantity_distribution" "text",
    "order_lead_time" "text",
    "shelf_life_in_days_at_manufacture" bigint,
    "frozen_shelf_life_if_applicable" "text",
    "shelf_life_in_days_guaranteed" "text",
    "ingredient_list" "text",
    "other_pricing_case" "text",
    "other_pricing_notes" "text",
    "other_pricing_unit" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "brand_id" "uuid",
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "uos" numeric,
    "uom" "public"."uom_enum",
    "unique_item_name" "text" GENERATED ALWAYS AS ("public"."format_item_name"("description", "uos", "uom")) STORED,
    "order_lead_time_to_distributor" "text",
    "product_shelf_life_slacked_out" "text",
    "best_by_date_indicated" "public"."best_by_enum",
    "organic_certifier_entity" "text",
    "organic" "public"."specs_certification_options",
    "non_gmo" "public"."specs_certification_options",
    "gluten_free" "public"."specs_certification_options",
    "vegan" "public"."specs_certification_options",
    "vegetarian" "public"."specs_certification_options",
    "kosher" "public"."specs_certification_options",
    "dairy_free" "public"."specs_certification_options",
    "sugar_free" "public"."specs_certification_options",
    "soy_free" "public"."specs_certification_options",
    "nut_free" "public"."specs_certification_options",
    "wheat_free" "public"."specs_certification_options",
    "updated_by" "text",
    "direct_ship" boolean,
    "order_lead_time_to_retailer" "text",
    "organic_status" "public"."specs_certification_options",
    "organic_certifier" "text",
    "non_gmo_status" "public"."specs_certification_options",
    "non_gmo_certifier" "text",
    "gluten_free_status" "public"."specs_certification_options",
    "gluten_free_certifier" "text",
    "vegan_status" "public"."specs_certification_options",
    "vegan_certifier" "text",
    "kosher_status" "public"."specs_certification_options",
    "kosher_certifier" "text",
    CONSTRAINT "spec_price_sheet_upc_12_digit_check" CHECK (("length"("upc_12_digit") <= 12))
);
ALTER TABLE "public"."spec_price_sheet" OWNER TO "postgres";
COMMENT ON TABLE "public"."spec_price_sheet" IS 'SKU placement describing about all the items each brand has';
COMMENT ON COLUMN "public"."spec_price_sheet"."upc_12_digit" IS 'still need to add a constraint --> CHECK (LENGTH(upc_12_digit) <= 12)';
COMMENT ON COLUMN "public"."spec_price_sheet"."item_temp_reqs" IS 'need to go over enums here (rename and update fields)';
COMMENT ON COLUMN "public"."spec_price_sheet"."unit_cost_fob" IS 'have a auto computation trigger to fill this --> fob_price_case/case_pack';
COMMENT ON COLUMN "public"."spec_price_sheet"."shelf_life_in_days_guaranteed" IS 'Must be at least 70% of Shelf Life at Manufacture';
COMMENT ON COLUMN "public"."spec_price_sheet"."organic_certifier_entity" IS 'list out the third party certification';
CREATE OR REPLACE FUNCTION "public"."get_spec_price_sheets_by_brand"("input_brand_id" "uuid") RETURNS SETOF "public"."spec_price_sheet"
    LANGUAGE "sql"
    AS $$
  SELECT * FROM spec_price_sheet WHERE brand_id = input_brand_id;
$$;
ALTER FUNCTION "public"."get_spec_price_sheets_by_brand"("input_brand_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_table_columns"("_table_name" "text") RETURNS TABLE("column_name" "text", "data_type" "text", "display_name" "text")
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    c.column_name::text, 
    c.data_type::text,
    
    -- THE PRETTY PRINTING LOGIC --
    TRIM(
      INITCAP(
        REPLACE(
          REPLACE(
             REPLACE(c.column_name, 'lk_', ''),    -- 1. Remove "lk_" prefix
             'filter_', ''),                       -- 2. Remove "filter_" prefix
          '_', ' '                                 -- 3. Turn underscores into spaces
        )
      )
    ) as display_name

  FROM information_schema.columns c
  WHERE c.table_name = _table_name
  AND c.table_schema = 'public'
  -- Exclude IDs and messy JSON objects you don't want in the dropdown
  AND c.column_name NOT IN ('id', 'uuid', 'account_address_details', 'master_category_reviews_array', 'deal_owners_array');
END;
$$;
ALTER FUNCTION "public"."get_table_columns"("_table_name" "text") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_task_dashboard_tab_counts"() RETURNS "json"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  result json;
BEGIN
  SELECT json_build_object(
    'this_week_overdue', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'this_week_overdue'),
    'next_two_weeks', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'next_two_weeks'),
    'this_month', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'this_month'),
    'to_watch', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'to_watch'),
    'sos_follow_up', (SELECT COUNT(*) FROM task_pipeline WHERE status = 'sos_follow_up')
  ) INTO result;
  RETURN result;
END;
$$;
ALTER FUNCTION "public"."get_task_dashboard_tab_counts"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."get_task_stats"() RETURNS TABLE("status" "public"."kanban_status_enum", "task_count" bigint, "overdue_count" bigint)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    tp.status,
    COUNT(*) as task_count,
    COUNT(*) FILTER (WHERE tp.due_date < CURRENT_DATE) as overdue_count
  FROM task_pipeline tp
  WHERE tp.is_completed = false
  GROUP BY tp.status;
END;
$$;
ALTER FUNCTION "public"."get_task_stats"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."global_search"("search_term" "text", "search_type" "text") RETURNS TABLE("id" "uuid", "display_text" "text", "result_type" "text", "metadata" "jsonb")
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    query_string TEXT;
BEGIN
    query_string := array_to_string(string_to_array(search_term, ' '), ' & ');

    CASE search_type
        WHEN 'brands' THEN
            RETURN QUERY
                SELECT
                    b.id,
                    b.brand AS display_text,
                    'Brand' AS result_type,
                    jsonb_build_object(
                        'services', b.services,
                        'company_website', b.company_website,
                        'manufacturer_name', b.manufacturer_name
                    ) AS metadata
                FROM public.brands b
                WHERE b.search_vector @@ to_tsquery('english', query_string);

        WHEN 'accounts' THEN
            RETURN QUERY
                SELECT
                    a.uuid AS id,
                    a.account AS display_text,
                    'Account' AS result_type,
                    jsonb_build_object(
                        'website', a.website,
                        'industry_tags', a.industry_tags,
                        'city', a.city,
                        'state', a.state
                    ) AS metadata
                FROM public.accounts a
                WHERE a.search_vector @@ to_tsquery('english', query_string);

        WHEN 'activities' THEN
            RETURN QUERY
                SELECT
                    at.id,
                    at.activity_name AS display_text,
                    'Activity' AS result_type,
                    jsonb_build_object(
                        'activity_type', at.activity_type,
                        'deal_stage', at.deal_stage,
                        'follow_up_date', at.follow_up_date,
                        'created_at', at.created_at,
                        -- Returns the raw UUIDs from the activity_tracker table
                        'brand_id', at.brand,
                        'account_id', at.account
                    ) AS metadata
                FROM public.activity_tracker at
                -- No JOINs in this version
                WHERE at.search_vector @@ to_tsquery('english', query_string);
    END CASE;
END;
$$;
ALTER FUNCTION "public"."global_search"("search_term" "text", "search_type" "text") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."handle_employee_status_change"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF NEW.status != 'Active' AND OLD.status = 'Active' THEN
    -- Remove all roles for this user
    DELETE FROM public.users_roles
    WHERE user_id IN (
      SELECT id FROM auth.users 
      WHERE team_member_id = NEW.uuid
    );
    
    -- Log the deactivation
    INSERT INTO public.audit_log (action, team_member_id, timestamp)
    VALUES ('employee_deactivated', NEW.uuid, NOW());
  END IF;
  
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."handle_employee_status_change"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."handle_hh_customers_audit"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
  BEGIN
    -- Updates the timestamp to 'now'
    NEW.updated_at = now();

    -- Captures the Supabase Auth User ID
    -- Note: Will be NULL if updated via Dashboard or Service Role
    NEW.modified_by = auth.uid();

    RETURN NEW;
  END;
  $$;
ALTER FUNCTION "public"."handle_hh_customers_audit"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$$;
ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."handle_submission_status_change"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$begin
  -- IF STATUS CHANGED TO TRUE (Submitted)
  if (NEW.submission_status = true) 
     and (OLD.submission_status is distinct from NEW.submission_status) then
    
    NEW.submitted_date := now();
    NEW.submitted_by := auth.uid(); -- Sets it to the currently logged-in user

  -- IF STATUS CHANGED TO FALSE (Reverted)
  elsif (NEW.submission_status = false) 
        and (OLD.submission_status = true) then
    
    NEW.submitted_date := null;
    NEW.submitted_by := null;
    
  end if;

  return NEW;
end;$$;
ALTER FUNCTION "public"."handle_submission_status_change"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."handle_task_status_change"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- If status changed to 'Completed' (Title Case)
    IF NEW.status = 'Completed' AND (OLD.status IS DISTINCT FROM 'Completed') THEN
        NEW.completed_date = NOW();
    
    -- If status changed FROM 'Completed' to something else (reopened)
    ELSIF NEW.status IS DISTINCT FROM 'Completed' AND OLD.status = 'Completed' THEN
        NEW.completed_date = NULL;
    END IF;

    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."handle_task_status_change"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."import_airtable_task_tracker"() RETURNS TABLE("imported_count" integer, "assigned_user_mappings" "text", "brand_mappings" "text", "errors" "text")
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  import_count INTEGER := 0;
  user_mappings TEXT := '';
  brand_mappings TEXT := '';
  error_log TEXT := '';
BEGIN
  -- This function expects the CSV data to be loaded into a temporary table first
  -- We'll create the temp table structure matching the CSV
  
  CREATE TEMP TABLE IF NOT EXISTS temp_airtable_tasks (
    task TEXT,
    sales_team_email TEXT,
    sales_team TEXT,
    notes TEXT,
    task_type TEXT,
    status TEXT,
    due_date TEXT,
    priority TEXT,
    task_completed TEXT,
    attachments TEXT,
    created TEXT
  );
  
  -- Insert into task_pipeline from temp table
  INSERT INTO task_pipeline (
    task_title,
    notes,
    task_type,
    status,
    assigned_to,
    brand_id,
    due_date,
    priority,
    is_completed,
    attachments,
    source_type
  )
  SELECT 
    t.task,
    t.notes,
    CASE t.task_type
      WHEN 'Deal Activity' THEN 'deal_activity'::task_type_enum
      WHEN 'Category Review' THEN 'category_review'::task_type_enum
      WHEN 'Internal Task' THEN 'internal_task'::task_type_enum
      WHEN 'Data' THEN 'data'::task_type_enum
      WHEN 'Marketing / Design' THEN 'marketing_design'::task_type_enum
      ELSE 'internal_task'::task_type_enum
    END,
    CASE t.status
      WHEN 'This Week / Overdue' THEN 'this_week_overdue'::kanban_status_enum
      WHEN 'Next Two Weeks' THEN 'next_two_weeks'::kanban_status_enum
      WHEN 'This Month' THEN 'this_month'::kanban_status_enum
      WHEN 'To Watch' THEN 'to_watch'::kanban_status_enum
      WHEN 'SOS Follow Up' THEN 'sos_follow_up'::kanban_status_enum
      ELSE 'this_month'::kanban_status_enum
    END,
    tmg.uuid, -- assigned_to
    b.id, -- brand_id
    CASE 
      WHEN t.due_date IS NOT NULL AND t.due_date != '' 
      THEN to_date(t.due_date, 'MM/DD/YYYY')
      ELSE NULL
    END,
    CASE t.priority
      WHEN 'High' THEN 'high'::priority_enum
      WHEN 'Medium' THEN 'medium'::priority_enum
      WHEN 'Low' THEN 'low'::priority_enum
      ELSE 'medium'::priority_enum
    END,
    COALESCE(t.task_completed = 'Completed', false),
    CASE 
      WHEN t.attachments IS NOT NULL AND t.attachments != ''
      THEN jsonb_build_array(
        jsonb_build_object(
          'filename', split_part(t.attachments, ' ', 1),
          'url', regexp_replace(t.attachments, '.*\((.*)\).*', '\1')
        )
      )
      ELSE '[]'::jsonb
    END,
    'manual'::source_type_enum
  FROM temp_airtable_tasks t
  LEFT JOIN team_member_guide tmg ON (
    tmg.name = t.sales_team OR 
    tmg.email = t.sales_team_email
  )
  LEFT JOIN brands b ON b.brand = t.task; -- This might need adjustment based on data
  
  GET DIAGNOSTICS import_count = ROW_COUNT;
  
  -- Generate mapping reports
  SELECT string_agg(DISTINCT 
    t.sales_team || ' (' || t.sales_team_email || ') -> ' || 
    COALESCE(tmg.name, 'NOT FOUND'), 
    E'\n'
  ) INTO user_mappings
  FROM temp_airtable_tasks t
  LEFT JOIN team_member_guide tmg ON (
    tmg.name = t.sales_team OR tmg.email = t.sales_team_email
  );
  
  DROP TABLE IF EXISTS temp_airtable_tasks;
  
  RETURN QUERY SELECT import_count, user_mappings, brand_mappings, error_log;
END;
$$;
ALTER FUNCTION "public"."import_airtable_task_tracker"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."import_airtable_tasks"("p_task_data" "jsonb") RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  task_record JSONB;
  task_count INTEGER := 0;
  v_assigned_to UUID;
  v_brand_id UUID;
  v_account_id UUID;
  v_status kanban_status_enum;
  v_task_type task_type_enum;
  v_priority priority_enum;
BEGIN
  -- Process each task record
  FOR task_record IN SELECT * FROM jsonb_array_elements(p_task_data)
  LOOP
    -- Map assignee by name/email lookup
    SELECT uuid INTO v_assigned_to 
    FROM team_member_guide 
    WHERE name = task_record->>'sales_team_name' 
    OR email = task_record->>'sales_team_email'
    LIMIT 1;
    
    -- Map brand by name
    SELECT id INTO v_brand_id
    FROM brands
    WHERE brand = task_record->>'brand_name'
    LIMIT 1;
    
    -- Map status
    v_status := CASE task_record->>'status'
      WHEN 'This Week / Overdue' THEN 'this_week_overdue'
      WHEN 'Next Two Weeks' THEN 'next_two_weeks'
      WHEN 'This Month' THEN 'this_month'
      WHEN 'To Watch' THEN 'to_watch' 
      WHEN 'SOS Follow Up' THEN 'sos_follow_up'
      ELSE 'this_month'
    END;
    
    -- Map task type
    v_task_type := CASE task_record->>'task_type'
      WHEN 'Deal Activity' THEN 'deal_activity'
      WHEN 'Category Review' THEN 'category_review'
      WHEN 'Internal Task' THEN 'internal_task'
      WHEN 'Data' THEN 'data'
      WHEN 'Marketing / Design' THEN 'marketing_design'
      ELSE 'internal_task'
    END;
    
    -- Map priority
    v_priority := CASE task_record->>'priority'
      WHEN 'High' THEN 'high'
      WHEN 'Medium' THEN 'medium'
      WHEN 'Low' THEN 'low'
      ELSE 'medium'
    END;
    
    -- Insert task
    INSERT INTO task_pipeline (
      task_title,
      notes,
      task_type,
      status,
      assigned_to,
      brand_id,
      due_date,
      priority,
      is_completed,
      source_type
    ) VALUES (
      task_record->>'task',
      task_record->>'notes',
      v_task_type,
      v_status,
      v_assigned_to,
      v_brand_id,
      (task_record->>'due_date')::DATE,
      v_priority,
      COALESCE((task_record->>'task_completed')::BOOLEAN, false),
      'manual'
    );
    
    task_count := task_count + 1;
  END LOOP;
  
  RETURN task_count;
END;
$$;
ALTER FUNCTION "public"."import_airtable_tasks"("p_task_data" "jsonb") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."insert_sku_placements_from_activity"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    sku_id TEXT;
    sku_array TEXT[];
BEGIN
    -- Delete old placements for this deal to avoid duplicates
    DELETE FROM sku_placements WHERE deal_activity_id = NEW.id;

    -- Parse comma-separated UUIDs into array
    sku_array := string_to_array(NEW.associated_skus, ',');

    -- Loop through each and insert new row
    FOREACH sku_id IN ARRAY sku_array LOOP
        INSERT INTO sku_placements (deal_activity_id, spec_id, placement_type)
        VALUES (
            NEW.id,
            trim(sku_id),  -- ensure no extra spaces
            NEW.sku_placement_type
        );
    END LOOP;

    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."insert_sku_placements_from_activity"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."is_active_employee"("user_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM auth.users u
    JOIN public.team_member_guide tmg ON u.team_member_id = tmg.uuid
    WHERE u.id = user_id
    AND tmg.status = 'Active'
  );
END;
$$;
ALTER FUNCTION "public"."is_active_employee"("user_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."is_user_assigned_to_task"("p_task_id" "uuid") RETURNS boolean
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM jt_task_assignments
    WHERE
      task_id = p_task_id AND
      team_member_uuid = (SELECT uuid FROM team_member_guide WHERE user_id = auth.uid())
  );
$$;
ALTER FUNCTION "public"."is_user_assigned_to_task"("p_task_id" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."link_brand_match_to_reviews"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  -- Insert a new record into the matched table for EVERY review found
  -- that shares the same master_category_id as the new brand.
  INSERT INTO public.jt_matched_brands_to_category_reviews (brand_match_id, review_id)
  SELECT 
      NEW.id,       -- The ID of the brand/category link just created
      r.id          -- The ID of the review found
  FROM 
      public.master_category_review_data r
  WHERE 
      r.master_category_id = NEW.master_category_id
  -- If this link already exists, just skip it (requires the constraint from Step 1)
  ON CONFLICT ON CONSTRAINT unique_brand_review_match DO NOTHING;

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."link_brand_match_to_reviews"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."log_deal_stage_history"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if old.deal_stage is distinct from new.deal_stage then
    insert into public.deal_stage_history (
      activity_id,
      old_deal_stage_ref,
      new_deal_stage_ref,
      activity_notes,
      changed_by,
      changed_at
    ) values (
      new.id,
      old.deal_stage,
      new.deal_stage,
      new.activity_notes,
      new.last_modified_by,
      now()
    );
  end if;

  return new;
end;
$$;
ALTER FUNCTION "public"."log_deal_stage_history"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."new_activity_mention"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
  sender_name text;
  -- Variables for the data we look up
  var_activity_title text;
  var_note_snippet text;
  var_account_id uuid;
  var_brand_id uuid;
BEGIN
  -- 1. Get Sender Name
  SELECT name INTO sender_name 
  FROM team_member_guide WHERE uuid = auth.uid(); 
  
  IF sender_name IS NULL THEN sender_name := 'Someone'; END IF;

  -- 2. Get Activity Details (Title, Snippet, AND IDs) all at once
  -- Make sure column names 'account_id' and 'brand_id' match your table exactly!
  SELECT 
    activity_name,
    account,
    brand,
    LEFT(activity_notes, 50) || '...'
  INTO 
    var_activity_title,
    var_account_id,
    var_brand_id,
    var_note_snippet
  FROM activity_tracker 
  WHERE id = NEW.activity_id;

  -- 3. Insert with Extended Payload
  INSERT INTO public.notifications (
    recipient_id,
    type,
    data,
    status
  )
  VALUES (
    NEW.user_id,
    'activity_mention', 
    jsonb_build_object(
      -- === BACKWARD COMPATIBILITY ===
      'message', '<b>' || sender_name || '</b> mentioned you in <b>' || COALESCE(var_activity_title, 'an activity') || '</b>: ' || COALESCE(var_note_snippet, ''),

      -- === NAVIGATION DATA ===
      'activity_id', NEW.activity_id,
      'account_id', var_account_id,  -- Added
      'brand_id', var_brand_id,      -- Added
      
      -- === DISPLAY DATA ===
      'mention_id', NEW.id,
      'sender_name', sender_name,
      'display_title', sender_name || ' mentioned you in ' || COALESCE(var_activity_title, 'an activity'),
      'display_body', COALESCE(var_note_snippet, 'Check the activity for details.'),
      'triggered_at', now()
    ),
    'unread'
  );
  
  RETURN NEW;
END;$$;
ALTER FUNCTION "public"."new_activity_mention"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."notify_hh_customer_status_change"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    IF OLD.status != NEW.status THEN
        -- Send notification (webhook/email integration point)
        PERFORM pg_notify('hh_customer_status_change', 
            json_build_object(
                'customer_id', NEW.id,
                'customer_name', NEW.name,
                'old_status', OLD.status,
                'new_status', NEW.status,
                'email', NEW.email,
                'company', NEW.company
            )::TEXT
        );
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."notify_hh_customer_status_change"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."notify_task_assignment"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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
$$;
ALTER FUNCTION "public"."notify_task_assignment"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."refresh_all_review_data_names"() RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    updated_count INTEGER := 0;
    review_record RECORD;
BEGIN
    FOR review_record IN 
        SELECT id FROM master_category_review_data
    LOOP
        UPDATE master_category_review_data 
        SET name = generate_review_data_name(review_record.id)
        WHERE id = review_record.id;
        
        updated_count := updated_count + 1;
    END LOOP;
    
    RETURN updated_count;
END;
$$;
ALTER FUNCTION "public"."refresh_all_review_data_names"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."search_similar_accounts"("search_term" "text") RETURNS TABLE("uuid" "uuid", "account_name" "text", "similarity_score" real)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  SELECT a.uuid, a.account, 
         similarity(a.account, search_term) as score
  FROM accounts a
  WHERE similarity(a.account, search_term) > 0.3
  ORDER BY score DESC
  LIMIT 10;
END;
$$;
ALTER FUNCTION "public"."search_similar_accounts"("search_term" "text") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."set_assignee_name"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if new.assignee_user_id is null then
    new.assignee_name := null;
    return new;
  end if;

  select tm.name
  into new.assignee_name
  from team_member_guide tm
  where tm.uuid = new.assignee_user_id;

  return new;
end;
$$;
ALTER FUNCTION "public"."set_assignee_name"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."set_brand_name"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if new.brand_uuid is null then
    new.brand_name := null;
    return new;
  end if;

  select b.brand
  into new.brand_name
  from brands b
  where b.id = new.brand_uuid;

  return new;
end;
$$;
ALTER FUNCTION "public"."set_brand_name"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."set_last_modified"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN
  -- Sets the timestamp to the current time
  NEW.updated_at = now();
  
  -- Captures the UUID of the user making the request via Supabase Auth
  -- This will be NULL if the change is made via the Dashboard/Service Role
  NEW.modified_by = auth.uid();
  
  RETURN NEW;
END;$$;
ALTER FUNCTION "public"."set_last_modified"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."set_unique_category_name"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    account_name TEXT;
BEGIN
    -- Get account name
    SELECT a.account INTO account_name
    FROM accounts a 
    WHERE a.uuid = NEW.account;
    
    -- Set unique category name as "Account - Category Name"
    NEW.unique_category_name := COALESCE(account_name, 'Unknown') || ' - ' || COALESCE(NEW.retailer_category_name, '');
    
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."set_unique_category_name"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."subscribe_customer_to_category_review"("customer_uuid" "uuid", "review_uuid" "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    INSERT INTO jt_hh_customers_category_reviews (customer_id, category_review_id)
    VALUES (customer_uuid, review_uuid)
    ON CONFLICT (customer_id, category_review_id) DO NOTHING;
    
    RETURN FOUND;
END;
$$;
ALTER FUNCTION "public"."subscribe_customer_to_category_review"("customer_uuid" "uuid", "review_uuid" "uuid") OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."sync_brand_onboarding_tasks"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$DECLARE
    template_record RECORD;
BEGIN
    -- Loop through all Active Templates that match the Brand's new services
    FOR template_record IN
        SELECT 
            t.uuid AS template_id,
            t.title,
            t.description,
            t.is_required,
            type.code AS type_code
        FROM public.brand_task_templates t
        JOIN public.brand_task_types type ON t.task_type_uuid = type.uuid
        WHERE t.is_active = true 
        AND t.applies_to_services && NEW.services
    LOOP
        -- Dedupe Rule: Check if this task type already exists for this brand
        IF NOT EXISTS (
            SELECT 1 
            FROM public.brand_tasks bt
            WHERE bt.brand_uuid = NEW.id
            AND bt.task_type_code_readonly = template_record.type_code
        ) THEN
            -- Create the task
            INSERT INTO public.brand_tasks (
                brand_uuid,
                source,
                template_uuid,
                task_type_code_readonly,
                title_readonly_if_from_template,
                description_readonly_if_from_template,
                status,
                due_date
            ) VALUES (
                NEW.id,
                'Template',     -- Matches your "source" screenshot
                template_record.template_id,
                template_record.type_code,
                template_record.title,
                template_record.description,
                'Not Started',  -- Matches your "status" screenshot
                CURRENT_DATE + 10 
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;$$;
ALTER FUNCTION "public"."sync_brand_onboarding_tasks"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."sync_gnf_primary"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN
    UPDATE accounts
    SET GNF_Primary = NEW.team_member_uuid
    WHERE uuid = NEW.account_uuid;

    RETURN NEW;
END;$$;
ALTER FUNCTION "public"."sync_gnf_primary"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."sync_new_account_to_partners"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN
  INSERT INTO interaction_partners (partner_name, partner_type, original_record_id)
  VALUES (NEW.account, 'Retailer', NEW.uuid);
  RETURN NEW;
END;$$;
ALTER FUNCTION "public"."sync_new_account_to_partners"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."sync_new_distributor_to_partners"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  INSERT INTO interaction_partners (partner_name, partner_type, original_record_id)
  VALUES (NEW.distributor, 'Distributor', NEW.id);
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."sync_new_distributor_to_partners"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."sync_team_member_photo_to_profile"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  UPDATE public.profiles
  SET profile_photo = NEW.profile_photo
  WHERE id = NEW.uuid; 
  
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."sync_team_member_photo_to_profile"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."sync_team_member_profile"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
begin
  -- Update both the photo and the name in the profiles table
  update public.profiles
  set 
    profile_photo = new.profile_photo,
    name = new.name
  where id = new.uuid; 
  
  return new;
end;
$$;
ALTER FUNCTION "public"."sync_team_member_profile"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."test_name_generation"() RETURNS TABLE("review_id" "uuid", "current_name" "text", "generated_name" "text", "names_match" boolean)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mcrd.id,
        mcrd.name,
        generate_review_data_name(mcrd.id),
        (mcrd.name = generate_review_data_name(mcrd.id))
    FROM master_category_review_data mcrd
    LIMIT 10;
END;
$$;
ALTER FUNCTION "public"."test_name_generation"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."trg_sku_placements_update_deal"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Always update the current or old deal ID
    PERFORM update_deal_placement_type(COALESCE(NEW.deal_activity_id, OLD.deal_activity_id));
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."trg_sku_placements_update_deal"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."trg_task_pipeline_inserts"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Call your EXISTING determine_task_status function for manual tasks
    -- We pass NULL for the activity tracker ID, and the new due date
    NEW.status = determine_task_status(NULL, NEW.due_date);
    
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."trg_task_pipeline_inserts"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."trg_task_pipeline_updates"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.updated_at = NOW();
  
  -- Auto-update status for manual tasks based on due date changes
  IF NEW.due_date IS DISTINCT FROM OLD.due_date 
     AND NEW.category_review_id IS NULL THEN
     
     -- Check if there are NO deals attached via the junction table
     IF NOT EXISTS (SELECT 1 FROM public.jt_deal_task_pipeline WHERE task_id = NEW.id) THEN
        NEW.status = determine_task_status(NULL, NEW.due_date);
     END IF;
  END IF;
  
  -- Set completion timestamp
  IF NEW.is_completed = true AND OLD.is_completed = false THEN
    NEW.completed_at = NOW();
  ELSIF NEW.is_completed = false AND OLD.is_completed = true THEN
    NEW.completed_at = NULL;
  END IF;
  
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."trg_task_pipeline_updates"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_accounts_search_vector"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.search_vector :=
        to_tsvector('english',
            COALESCE(NEW.account, '') || ' ' ||
            COALESCE(NEW.account_description, '') || ' ' ||
            COALESCE(NEW.city, '') || ' ' ||
            COALESCE(NEW.state::text, '') || ' ' ||
            COALESCE(array_to_string(NEW.industry_tags, ' '), '')
        );
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_accounts_search_vector"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_activity_name"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  IF NEW.brand IS NOT NULL AND NEW.account IS NOT NULL THEN
    SELECT COALESCE(b.brand, 'Unknown Brand') || ' - ' || COALESCE(a.account, 'Unknown Account')
    INTO NEW.activity_name
    FROM brands b, accounts a
    WHERE b.id = NEW.brand AND a.uuid = NEW.account;
  END IF;
  
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_activity_name"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_activity_tracker_search_vector"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN
    NEW.search_vector :=
        to_tsvector('english',
            COALESCE(NEW.activity_name, '') 
        );
    RETURN NEW;
END;$$;
ALTER FUNCTION "public"."update_activity_tracker_search_vector"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_affected_review_names_from_categories"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    affected_review_id UUID;
BEGIN
    -- Find affected review data records through the retailer matching
    FOR affected_review_id IN
        SELECT DISTINCT jm.review_data_id
        FROM jt_master_category_review_data_matching jm
        WHERE jm.retailer_matching_id = COALESCE(NEW.retailer_category_id, OLD.retailer_category_id)
    LOOP
        UPDATE master_category_review_data 
        SET name = generate_review_data_name(affected_review_id)
        WHERE id = affected_review_id;
    END LOOP;
    
    RETURN COALESCE(NEW, OLD);
END;
$$;
ALTER FUNCTION "public"."update_affected_review_names_from_categories"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_affected_review_names_from_matching"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    affected_review_id UUID;
BEGIN
    -- Update display names for all review data linked to this retailer matching
    FOR affected_review_id IN 
        SELECT DISTINCT review_data_id 
        FROM jt_master_category_review_data_matching 
        WHERE retailer_matching_id = COALESCE(NEW.id, OLD.id)
    LOOP
        UPDATE master_category_review_data 
        SET display_name = generate_review_data_name(affected_review_id)
        WHERE id = affected_review_id;
    END LOOP;
    
    RETURN COALESCE(NEW, OLD);
END;
$$;
ALTER FUNCTION "public"."update_affected_review_names_from_matching"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_brands_search_vector"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.search_vector :=
        to_tsvector('english',
            COALESCE(NEW.brand, '') || ' ' ||
            COALESCE(NEW.manufacturer_name, '') || ' ' ||
            COALESCE(NEW.main_poc_name, '') || ' ' ||
            COALESCE(NEW.company_website, '') || ' ' ||
            COALESCE(array_to_string(NEW.services, ' '), '')
        );
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_brands_search_vector"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_connect_count"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- If connect_stage contains "Connect ", set connect_count to 1
    IF NEW.connect_stage::text LIKE 'Connect %' THEN
        NEW.connect_count = 1;
    ELSE
        -- Otherwise (if it doesn't contain "Connect "), set connect_count to 0
        NEW.connect_count = 0;
    END IF;
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_connect_count"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_contribution_status"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.contribution_status = CASE 
        WHEN EXTRACT(MONTH FROM NEW.created_at) = EXTRACT(MONTH FROM CURRENT_DATE)
        AND EXTRACT(YEAR FROM NEW.created_at) = EXTRACT(YEAR FROM CURRENT_DATE)
        THEN '✅ Submitted This Month'
        ELSE '❌ No Submission This Month'
    END;
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_contribution_status"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_demos_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_demos_updated_at"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_full_category"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.full_category = CASE 
        WHEN NEW.subcategory IS NOT NULL THEN NEW.category::TEXT || ' - ' || NEW.subcategory
        ELSE NEW.category::TEXT
    END;
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_full_category"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_full_name_and_account"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  UPDATE contacts
  SET full_name_and_account = CONCAT(
    NEW.first_name, ' ', NEW.last_name, ' - ',
    (SELECT account FROM accounts WHERE uuid = NEW.account_uuid)
  )
  WHERE uuid = NEW.uuid;

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_full_name_and_account"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_full_name_job_title"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  UPDATE contacts
  SET full_name_job_title = CONCAT(NEW.first_name, ' ', NEW.last_name, ' - ', NEW.job_title)
  WHERE uuid = NEW.uuid;

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_full_name_job_title"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_human_friendly_names"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$BEGIN
    -- Update the account name based on the account_uuid
    NEW.account_name := (SELECT account FROM accounts WHERE accounts.uuid = NEW.account_uuid);

    -- Update the team member name based on the team_member_uuid
    NEW.team_member_name := (SELECT name  FROM "team_member_guide" WHERE "team_member_guide".uuid = NEW.team_member_uuid);

    RETURN NEW;
END;$$;
ALTER FUNCTION "public"."update_human_friendly_names"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_last_modified_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  NEW.last_modified = now();
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_last_modified_column"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_last_updated_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.last_updated = NOW();
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_last_updated_column"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_name_and_title"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  UPDATE contacts
  SET name_and_title = CONCAT(NEW.first_name, ' ', NEW.last_name, ' - ', NEW.job_title)
  WHERE uuid = NEW.uuid;

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_name_and_title"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_program_field"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  brand_name text;
  total_connects bigint;
BEGIN
  -- Get the brand name from brands table
  SELECT brand INTO brand_name FROM brands WHERE id = NEW.brand;

  -- Safely calculate the total connects
  total_connects := COALESCE(NEW.sponsored_connects, 0) + COALESCE(NEW.total_paid_connects_authorized, 0);

  -- Update the `program` field
  NEW.program := CONCAT(
    brand_name, ' - ',
    NEW.calling_month, ' - ',
    NEW.calling_year, ' - ',
    COALESCE(NEW.program_type[1], ''), ' - ',
    NEW.region, ' - ',
    total_connects::text
  );

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_program_field"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_promo_name"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  readable_account TEXT;
BEGIN
  SELECT a.account INTO readable_account
  FROM accounts a
  WHERE a.uuid = NEW.account;

  NEW.promo_name := readable_account || ' - ' || NEW.promo_type || ' - ' || NEW.effective_promo_month;
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_promo_name"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_review_data_name"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  account_name_text text;
BEGIN
  -- 1. Get the Account Name from the linked accounts table
  -- We use NEW.account because that is the incoming UUID
  SELECT account INTO account_name_text
  FROM public.accounts
  WHERE uuid = NEW.account;

  -- 2. Construct the string using the NEW data directly
  -- Using NEW.retailer_category ensures we capture the change immediately
  IF account_name_text IS NOT NULL AND NEW.retailer_category IS NOT NULL THEN
      NEW.display_name := account_name_text || ' - ' || NEW.retailer_category;
  
  ELSIF account_name_text IS NOT NULL THEN
      NEW.display_name := account_name_text || ' - Unknown Category';
  
  ELSE
      NEW.display_name := 'Unknown Account - Unknown Category';
  END IF;

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_review_data_name"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_review_names_when_account_changes"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- Update all review data display names that reference this account
    UPDATE master_category_review_data 
    SET display_name = generate_review_data_name(id)
    WHERE account = NEW.uuid;
    
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_review_names_when_account_changes"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_review_names_when_category_changes"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    affected_review_id UUID;
BEGIN
    -- Only update if subcategory or category actually changed
    IF OLD.subcategory != NEW.subcategory OR OLD.category != NEW.category THEN
        -- Find all affected review records
        FOR affected_review_id IN
            SELECT DISTINCT jm.review_data_id
            FROM jt_retailer_category_to_gn_categories jrg
            JOIN jt_master_category_review_data_matching jm ON jrg.retailer_category_id = jm.retailer_matching_id
            WHERE jrg.gn_category_id = NEW.id
        LOOP
            UPDATE master_category_review_data 
            SET name = generate_review_data_name(affected_review_id)
            WHERE id = affected_review_id;
        END LOOP;
    END IF;
    
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_review_names_when_category_changes"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_sos_authorizations_connects_achieved"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- This block handles INSERTs and UPDATEs in activity_tracker
    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        -- Update the relevant sos_authorization row using the new or old sos_authorizations ID
        UPDATE public.sos_authorizations sa
        SET connects_achieved = (
            SELECT COALESCE(SUM(at.connect_count), 0)
            FROM public.activity_tracker at
            WHERE at.sos_authorizations = NEW.sos_authorizations
        )
        WHERE sa.id = NEW.sos_authorizations;

        -- If the sos_authorizations ID changed in an UPDATE, also update the old one
        IF (TG_OP = 'UPDATE' AND OLD.sos_authorizations IS NOT NULL AND OLD.sos_authorizations <> NEW.sos_authorizations) THEN
            UPDATE public.sos_authorizations sa
            SET connects_achieved = (
                SELECT COALESCE(SUM(at_old.connect_count), 0)
                FROM public.activity_tracker at_old
                WHERE at_old.sos_authorizations = OLD.sos_authorizations
            )
            WHERE sa.id = OLD.sos_authorizations;
        END IF;

    -- This block handles DELETEs from activity_tracker
    ELSIF (TG_OP = 'DELETE') THEN
        -- Update the relevant sos_authorization row using the old sos_authorizations ID
        UPDATE public.sos_authorizations sa
        SET connects_achieved = (
            SELECT COALESCE(SUM(at_del.connect_count), 0)
            FROM public.activity_tracker at_del
            WHERE at_del.sos_authorizations = OLD.sos_authorizations
        )
        WHERE sa.id = OLD.sos_authorizations;
    END IF;

    RETURN NULL; -- AFTER triggers must return NULL
END;
$$;
ALTER FUNCTION "public"."update_sos_authorizations_connects_achieved"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_task_time_categories"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$BEGIN
  UPDATE public.task_pipeline
  SET
    status = CASE
      WHEN due_date IS NULL THEN status
      WHEN due_date <= CURRENT_DATE + INTERVAL '7 days' THEN 'this_week_overdue'
      WHEN due_date <= CURRENT_DATE + INTERVAL '14 days' THEN 'next_two_weeks'
      WHEN due_date <= CURRENT_DATE + INTERVAL '30 days' THEN 
      'this_month'
      ELSE status
    END
  WHERE
    is_completed = false ; -- Only update active tasks that are not deal_activity
END;$$;
ALTER FUNCTION "public"."update_task_time_categories"() OWNER TO "postgres";
CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "postgres";
CREATE FOREIGN DATA WRAPPER "airtable_wrapper" HANDLER "extensions"."airtable_fdw_handler" VALIDATOR "extensions"."airtable_fdw_validator";
CREATE SERVER "airtable_server" FOREIGN DATA WRAPPER "airtable_wrapper" OPTIONS (
    "api_key_id" '5c3aa298-bef0-4c6d-bd89-b2145c83d2e0'
);
ALTER SERVER "airtable_server" OWNER TO "postgres";
CREATE FOREIGN TABLE "airtable"."accounts" (
    "account" "text",
    "account_type" "text",
    "contact_info_check" "text",
    "account_type_reference_only_do_not_edit" "text",
    "industry_tags" "jsonb",
    "account_sub_type_tag" "text",
    "account_type_tags_for_hh" "jsonb",
    "gnf_priority" "text",
    "address" "text",
    "city" "text",
    "state" "text",
    "zip" "text",
    "full_address" "text",
    "territory" "text",
    "country" "text",
    "store_phone_number" "text",
    "store_count" integer,
    "gnf_primary" "jsonb",
    "primary_region" "jsonb",
    "distributors" "jsonb",
    "distributors_tags" "text",
    "distributors_tags_from_distributors" "jsonb",
    "buying_group" "jsonb",
    "website" "text",
    "account_description" "text",
    "placement_requirements" "text",
    "promotional_support_and_trade_show_information" "text",
    "nif_submission_forms" "jsonb",
    "promotional_forms" "jsonb",
    "cr_calendar" "jsonb",
    "other_documents" "jsonb",
    "demo_support_information" "text",
    "velocity_reporting_details_and_fees" "text",
    "all_gnf_contacts_do_not_filter_2" "jsonb",
    "distributor_reps_assigned" "jsonb",
    "full_name_and_title_from_all_gnf_contacts_do_not_filter_2" "jsonb",
    "category_review_calendar_source_internal_anna_delete_after" "text",
    "open_review" boolean,
    "anchor_account" boolean,
    "category_review_process_notes_delete_for_annas_review" "text",
    "local_diverse_supplier_other_special_programs" "text",
    "preferred_submission_process" "text",
    "kehe_code" "text",
    "unfi_code" "text",
    "old_master_cr_view_reference" "text",
    "default_gnf_status" "text",
    "ff_code" "text",
    "sn_code" "text",
    "asg_code" "text",
    "tff_code" "text",
    "mdi_code" "text",
    "chex_code" "text",
    "c_w_code" "text",
    "pod_dc" "text",
    "p10_dc" "text",
    "infra_list_name" "text",
    "sos_acct_new_product_note" "text",
    "distribution_territory" "jsonb",
    "the_last_cr_submission_deadline" "date",
    "reminder" "text",
    "cm_for_category_reviews" "jsonb",
    "urm_code" "text",
    "full_name_from_distributor_reps_assigned" "jsonb",
    "job_title_from_distributor_reps_assigned" "jsonb",
    "primary_email_from_distributor_reps_assigned" "jsonb",
    "phone_number_from_distributor_reps_assigned" "jsonb",
    "kehe_dc" "text",
    "accounts_copy_need_to_tag" "text",
    "rf_dc" "text",
    "rf_code" "text",
    "phone_number_from_all_gnf_contacts_do_not_filter_2" "jsonb",
    "primary_email_from_all_gnf_contacts_do_not_filter_2" "jsonb",
    "primary_email" "jsonb",
    "job_title_from_all_gnf_contacts_do_not_filter_2" "jsonb",
    "last_name" "jsonb",
    "first_name" "jsonb",
    "formatted_contacts_rollup" "jsonb",
    "distributors_str" "text",
    "logo" "jsonb",
    "notes_comments" "text",
    "sales_volume_factor_1_is_average" integer,
    "flag_for_attention" "jsonb",
    "all_category_review_do_not_filter_hide" "jsonb",
    "archived_forms" "jsonb",
    "create_date" "date",
    "record_created" timestamp without time zone,
    "last_modified_date" timestamp without time zone,
    "created_by" "jsonb",
    "possible_dupe" boolean,
    "call_preferences" "jsonb",
    "no_url_found" boolean
)
SERVER "airtable_server"
OPTIONS (
    "base_id" 'applaQsd7cTgA5u2f',
    "table_id" 'tblyMTmhwvIKhKWVL'
);
ALTER FOREIGN TABLE "airtable"."accounts" OWNER TO "postgres";
CREATE FOREIGN TABLE "airtable"."airtable_table" (
    "name" "text",
    "notes" "text",
    "content" "text",
    "amount" numeric,
    "updated_at" timestamp without time zone
)
SERVER "airtable_server"
OPTIONS (
    "base_id" 'applaQsd7cTgA5u2f',
    "table_id" 'tblyMTmhwvIKhKWVL'
);
ALTER FOREIGN TABLE "airtable"."airtable_table" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_account_type" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text" DEFAULT '#e4e4e4'::"text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_account_type" OWNER TO "postgres";
ALTER TABLE "public"."ref_account_type" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."_os_account_type_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_sub_tags" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_sub_tags" OWNER TO "postgres";
ALTER TABLE "public"."ref_sub_tags" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."_os_sub_tags_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."accounts" (
    "account" "text",
    "gnf_priority" bigint,
    "address" "text",
    "city" "text",
    "state" "public"."states_enum",
    "zip" "text",
    "country" "public"."Country",
    "store_phone_number" "text",
    "store_count" "text",
    "website" "text",
    "account_description" "text",
    "placement_requirements" "text",
    "promotional_support_trade_show_information" "text",
    "ff_code" "text",
    "sn_code" "text",
    "asg_code" "text",
    "tff_code" "text",
    "mdi_code" "text",
    "chex_code" "text",
    "cw_code" "text",
    "logo" "jsonb",
    "record_created" timestamp with time zone,
    "last_modified" timestamp with time zone,
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "primary_region" "public"."region"[] DEFAULT ARRAY[]::"public"."region"[],
    "submission_forms" "jsonb"[],
    "promotional_forms" "jsonb"[],
    "cr_calendar" "jsonb"[],
    "other_documents" "jsonb"[],
    "territory" "text",
    "open_review" boolean,
    "buying_group" "text",
    "anchor_account" boolean,
    "special_program_info" "text",
    "preferred_submission_process" "text",
    "kehe_code" "text",
    "unfi_code" "text",
    "urm_code" "text",
    "archived_forms" "jsonb"[],
    "flag_for_attention" "public"."flag_for_attention_enum"[],
    "account_notes" "text",
    "search_vector" "tsvector",
    "store_number" "text",
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "updated_by" "text",
    "default_deal_stage" "uuid",
    "legacy_id" "text",
    "account_type" "uuid",
    "call_preferences" "public"."Call Preferences"[]
);
ALTER TABLE "public"."accounts" OWNER TO "postgres";
COMMENT ON TABLE "public"."accounts" IS 'This table contains all the current accounts that GNF deals with and manages their portfolio';
COMMENT ON COLUMN "public"."accounts"."territory" IS 'For international addresses only. Would be equivalent to a state or province.';
COMMENT ON COLUMN "public"."accounts"."special_program_info" IS 'From Local/Diverse Supplier/Other Special Programs';
COMMENT ON COLUMN "public"."accounts"."store_number" IS 'Example "241". Store number within a chain account.';
CREATE TABLE IF NOT EXISTS "public"."accounts_migration" (
    "account" "text" NOT NULL,
    "gnf_priority" "text",
    "address" "text",
    "city" "text",
    "state" "public"."states_enum",
    "zip" "text",
    "country" "public"."Country",
    "store_phone_number" "text",
    "store_count" "text",
    "website" "text",
    "account_description" "text",
    "placement_requirements" "text",
    "promotional_support_trade_show_information" "text",
    "ff_code" "text",
    "sn_code" "text",
    "asg_code" "text",
    "tff_code" "text",
    "mdi_code" "text",
    "chex_code" "text",
    "cw_code" "text",
    "logo" "jsonb",
    "record_created" timestamp with time zone,
    "last_modified" timestamp with time zone,
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "primary_region" "public"."region"[] DEFAULT ARRAY[]::"public"."region"[],
    "industry_tags" "public"."industry_tag"[],
    "submission_forms" "jsonb"[],
    "promotional_forms" "jsonb"[],
    "cr_calendar" "jsonb"[],
    "other_documents" "jsonb"[],
    "default_status_enum" "public"."default_status_enum (deprecated?)",
    "territory" "text",
    "open_review" boolean,
    "buying_group" "text",
    "anchor_account" boolean,
    "special_program_info" "text",
    "preferred_submission_process" "text",
    "kehe_code" "text",
    "unfi_code" "text",
    "urm_code" "text",
    "archived_forms" "jsonb"[],
    "flag_for_attention" "public"."flag_for_attention_enum"[],
    "account_notes" "text",
    "account_type" "public"."account_type",
    "search_vector" "tsvector",
    "store_number" "text",
    "call_preferences" "public"."Call Preferences",
    "legacy_id" "text",
    CONSTRAINT "check_industry_tags_not_empty" CHECK (("array_length"("industry_tags", 1) > 0))
);
ALTER TABLE "public"."accounts_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."accounts_migration" IS 'This is a duplicate of accounts';
COMMENT ON COLUMN "public"."accounts_migration"."territory" IS 'For international addresses only. Would be equivalent to a state or province.';
COMMENT ON COLUMN "public"."accounts_migration"."special_program_info" IS 'From Local/Diverse Supplier/Other Special Programs';
COMMENT ON COLUMN "public"."accounts_migration"."store_number" IS 'Example "241". Store number within a chain account.';
COMMENT ON COLUMN "public"."accounts_migration"."call_preferences" IS 'Visibility on which accounts should or should not be cold called.';
CREATE TABLE IF NOT EXISTS "public"."activity_tracker" (
    "deal_stage" "uuid",
    "activity_type" "public"."activity_type_enum" DEFAULT 'GNF Deal'::"public"."activity_type_enum",
    "activity_notes" "text",
    "connect_stage" "public"."connect_enum (deprecated?)",
    "assign_for_follow_up" "uuid",
    "connect_count" integer DEFAULT 0,
    "sos_call_date" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "to_forms" "jsonb",
    "to_form_submitted" boolean,
    "sos_flag_tag" boolean,
    "flag_for_sos_attention" "text",
    "data_to_update" "text",
    "follow_up_date" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "account" "uuid",
    "brand" "uuid",
    "last_updated" timestamp with time zone DEFAULT "now"(),
    "new_account_name" "text",
    "sos_call_team" "uuid",
    "sku_placement_type" "public"."placement_type_enum" DEFAULT 'Team-led'::"public"."placement_type_enum",
    "sos_authorizations" "uuid",
    "activity_name_deprecated" "text",
    "activity_name" "text",
    "planned_date" "date",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "search_vector" "tsvector",
    "to_form_submitted_date" timestamp with time zone,
    "last_modified_by" "uuid",
    "to_form_submit_date" timestamp with time zone,
    "sos_follow_up_date" timestamp with time zone
);
ALTER TABLE "public"."activity_tracker" OWNER TO "postgres";
COMMENT ON TABLE "public"."activity_tracker" IS 'A specialized table to store all the activities that happens at GNF. It contains deals, SKU placement, deal owner, contacts. This helps in maintaining a running log of SOS, GN Deals, Connect Stages.';
COMMENT ON COLUMN "public"."activity_tracker"."connect_stage" IS 'This is the SOS team''s version of deal stage. They use this instead of deal stage.';
COMMENT ON COLUMN "public"."activity_tracker"."assign_for_follow_up" IS '(Previously called GNF Team Member Guide) This is another fk to team member guide so SOS team can assign someone to follow up. May not need this field.';
COMMENT ON COLUMN "public"."activity_tracker"."connect_count" IS 'Need to look at SOS call schema to see how this behaves';
COMMENT ON COLUMN "public"."activity_tracker"."sos_call_date" IS 'The date the SOS team member made the call';
COMMENT ON COLUMN "public"."activity_tracker"."data_to_update" IS 'This is populated from the SOS team when they do calling. When the catch outdated data, the submit that info here for Claudia to update.';
COMMENT ON COLUMN "public"."activity_tracker"."brand" IS 'Links to brands table';
COMMENT ON COLUMN "public"."activity_tracker"."new_account_name" IS 'Support field for when account are spelled wrong maybe?';
COMMENT ON COLUMN "public"."activity_tracker"."sos_call_team" IS 'This should be a filtered selection from our SOS call team. See Airtable field for more details and conditinos.';
COMMENT ON COLUMN "public"."activity_tracker"."sos_authorizations" IS 'Links to sos authorizations table';
CREATE TABLE IF NOT EXISTS "public"."activity_tracker_migration" (
    "deal_stage" "text",
    "activity_type" "public"."activity_type_enum" DEFAULT 'GNF Deal'::"public"."activity_type_enum",
    "activity_notes" "text",
    "connect_stage" "public"."connect_enum (deprecated?)",
    "assign_for_follow_up" "uuid",
    "connect_count" integer DEFAULT 0,
    "sos_call_date" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "to_forms" "jsonb",
    "to_form_submitted" "text",
    "sos_flag_tag" "text",
    "flag_for_sos_attention" "text",
    "data_to_update" "text",
    "follow_up_date" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "account" "uuid",
    "brand" "uuid",
    "last_updated" timestamp with time zone DEFAULT "now"(),
    "new_account_name" "text",
    "sos_call_team" "uuid",
    "sku_placement_type" "public"."placement_type_enum" DEFAULT 'Team-led'::"public"."placement_type_enum",
    "sos_authorizations" "uuid",
    "activity_name_deprecated" "text",
    "activity_name" "text",
    "planned_date" "date",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "search_vector" "tsvector",
    "to_form_submitted_date" timestamp with time zone,
    "legacy_id" "text"
);
ALTER TABLE "public"."activity_tracker_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."activity_tracker_migration" IS 'This is a duplicate of activity_tracker';
COMMENT ON COLUMN "public"."activity_tracker_migration"."connect_stage" IS 'This is the SOS team''s version of deal stage. They use this instead of deal stage.';
COMMENT ON COLUMN "public"."activity_tracker_migration"."assign_for_follow_up" IS '(Previously called GNF Team Member Guide) This is another fk to team member guide so SOS team can assign someone to follow up. May not need this field.';
COMMENT ON COLUMN "public"."activity_tracker_migration"."connect_count" IS 'Need to look at SOS call schema to see how this behaves';
COMMENT ON COLUMN "public"."activity_tracker_migration"."sos_call_date" IS 'The date the SOS team member made the call';
COMMENT ON COLUMN "public"."activity_tracker_migration"."data_to_update" IS 'This is populated from the SOS team when they do calling. When the catch outdated data, the submit that info here for Claudia to update.';
COMMENT ON COLUMN "public"."activity_tracker_migration"."brand" IS 'Links to brands table';
COMMENT ON COLUMN "public"."activity_tracker_migration"."new_account_name" IS 'Support field for when account are spelled wrong maybe?';
COMMENT ON COLUMN "public"."activity_tracker_migration"."sos_call_team" IS 'This should be a filtered selection from our SOS call team. See Airtable field for more details and conditinos.';
COMMENT ON COLUMN "public"."activity_tracker_migration"."sos_authorizations" IS 'Links to sos authorizations table';
COMMENT ON COLUMN "public"."activity_tracker_migration"."legacy_id" IS 'airtable legacy id';
CREATE OR REPLACE VIEW "public"."activity_tracker_show_more" AS
 SELECT "at"."id" AS "activity_id",
    "acc"."account" AS "account_name",
    "acc"."open_review",
    "acc"."preferred_submission_process",
    "acc"."placement_requirements",
    "acc"."account_notes",
    ( SELECT "jsonb_agg"("jsonb_build_object"('id', "mcr"."id", 'display_name', "mcr"."display_name", 'retailer_category', "mcr"."retailer_category", 'submission_deadline', "mcr"."new_item_submission_deadline", 'review_date', "mcr"."retailer_review_date", 'is_cancelled', "mcr"."category_cancellation")) AS "jsonb_agg"
           FROM "public"."master_category_review_data" "mcr"
          WHERE ("mcr"."account" = "at"."account")) AS "category_reviews"
   FROM ("public"."activity_tracker" "at"
     LEFT JOIN "public"."accounts" "acc" ON (("at"."account" = "acc"."uuid")));
ALTER TABLE "public"."activity_tracker_show_more" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."brand_contacts_table" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "company" "uuid",
    "first_name" "text",
    "last_name" "text",
    "email" "text",
    "title" "text",
    "phone" "text",
    "contact_tags" "public"."Brand Contact Tags"[],
    "receive_company_updates" boolean,
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."brand_contacts_table" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_contacts_table" IS 'contacts only associated with goodnow brand services';
COMMENT ON COLUMN "public"."brand_contacts_table"."company" IS 'Links to brands table';
COMMENT ON COLUMN "public"."brand_contacts_table"."contact_tags" IS 'Roles of the brands contact.';
COMMENT ON COLUMN "public"."brand_contacts_table"."receive_company_updates" IS 'Whether or not they should receive company updates or marketing emails';
CREATE TABLE IF NOT EXISTS "public"."brand_contacts_table_migration" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "company" "uuid",
    "first_name" "text",
    "last_name" "text",
    "email" "text",
    "title" "text",
    "phone" "text",
    "contact_tags" "public"."Brand Contact Tags"[],
    "receive_company_updates" boolean,
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "legacy_id" "text"
);
ALTER TABLE "public"."brand_contacts_table_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_contacts_table_migration" IS 'This is a duplicate of brand_contacts_table';
COMMENT ON COLUMN "public"."brand_contacts_table_migration"."company" IS 'Links to brands table';
COMMENT ON COLUMN "public"."brand_contacts_table_migration"."contact_tags" IS 'Roles of the brands contact.';
COMMENT ON COLUMN "public"."brand_contacts_table_migration"."receive_company_updates" IS 'Whether or not they should receive company updates or marketing emails';
CREATE TABLE IF NOT EXISTS "public"."brand_distribution_grid" (
    "item_code" "text",
    "distribution_status" "public"."Distribution Status",
    "distribution_notes" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "brand_id" "uuid",
    "distributor_hq" "uuid",
    "warehouse_dc" "uuid",
    "item_name" "uuid",
    "fulfillment_method" "public"."Fulfillment Method ",
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "updated_by" "text"
);
ALTER TABLE "public"."brand_distribution_grid" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_distribution_grid" IS 'This table is used to track the distribution grid for all the Distributor HQ and Warehouse DC brands with the item being distributed.';
COMMENT ON COLUMN "public"."brand_distribution_grid"."brand_id" IS 'Link to brands table';
COMMENT ON COLUMN "public"."brand_distribution_grid"."distributor_hq" IS 'Links to accounts table. Constraint to only show distributor HQs.';
COMMENT ON COLUMN "public"."brand_distribution_grid"."warehouse_dc" IS 'Links to accounts. Filtred by distributor dc_warehouse account subset';
COMMENT ON COLUMN "public"."brand_distribution_grid"."item_name" IS 'Links to spec_price_sheet.id';
CREATE TABLE IF NOT EXISTS "public"."brand_documents" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "name" "text" NOT NULL,
    "storage_path" "text" NOT NULL,
    "size" "text",
    "type" "text",
    "status" "text" DEFAULT 'pending'::"text",
    "folder_id" "uuid",
    "brand_id" "uuid" DEFAULT "auth"."uid"(),
    "url" "text"
);
ALTER TABLE "public"."brand_documents" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."brand_focus_assignments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brand" "uuid",
    "team_member" "uuid",
    "focus_month" "public"."focus_month_enum",
    "Notes" "text"
);
ALTER TABLE "public"."brand_focus_assignments" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_focus_assignments" IS 'This supports the brand ranking kanban on our front end. Each month James can assign brands to a team member to focus on.';
COMMENT ON COLUMN "public"."brand_focus_assignments"."brand" IS 'Links to brands table';
COMMENT ON COLUMN "public"."brand_focus_assignments"."team_member" IS 'Links to team_member_guide';
CREATE TABLE IF NOT EXISTS "public"."brand_portal_credentials" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "username" "text",
    "password" "text",
    "account" "uuid",
    "attachment" "text"[],
    "brand" "uuid",
    "name" "text",
    "link" "text"
);
ALTER TABLE "public"."brand_portal_credentials" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_portal_credentials" IS 'Where brands can pick an account and supply portal credentials such as username and password to access this.';
COMMENT ON COLUMN "public"."brand_portal_credentials"."username" IS 'username for portal account.';
COMMENT ON COLUMN "public"."brand_portal_credentials"."password" IS 'password for portal account.';
COMMENT ON COLUMN "public"."brand_portal_credentials"."brand" IS 'Links to brands base';
COMMENT ON COLUMN "public"."brand_portal_credentials"."name" IS 'Descriptive name for login. i.e. MYUNFI';
COMMENT ON COLUMN "public"."brand_portal_credentials"."link" IS 'website url link';
CREATE TABLE IF NOT EXISTS "public"."brand_portal_credentials_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "username" "text",
    "password" "text",
    "account" "uuid",
    "attachment" "text"[],
    "brand" "uuid",
    "name" "text",
    "link" "text",
    "legacy_id" "text"
);
ALTER TABLE "public"."brand_portal_credentials_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_portal_credentials_migration" IS 'This is a migration copy of brand_portal_credentials';
COMMENT ON COLUMN "public"."brand_portal_credentials_migration"."username" IS 'username for portal account.';
COMMENT ON COLUMN "public"."brand_portal_credentials_migration"."password" IS 'password for portal account.';
COMMENT ON COLUMN "public"."brand_portal_credentials_migration"."brand" IS 'Links to brands base';
COMMENT ON COLUMN "public"."brand_portal_credentials_migration"."name" IS 'Descriptive name for login. i.e. MYUNFI';
COMMENT ON COLUMN "public"."brand_portal_credentials_migration"."link" IS 'website url link';
CREATE TABLE IF NOT EXISTS "public"."brand_promo_requests (Deprecated)" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "brand_id" "uuid",
    "retailer_id" "uuid",
    "distributor_id" "uuid",
    "promo_type_brand_facing" "text",
    "effective_promo_month" "public"."Effective Promo Month",
    "effective_promo_year" "public"."Promo Year",
    "oi_percentage" numeric(5,2),
    "mcb_percentage" numeric(5,2),
    "per_unit_scan_amount" numeric(8,2),
    "submission_status" "public"."promo_submissinon_status" DEFAULT 'Requested'::"public"."promo_submissinon_status",
    "brand_approval" "public"."brand_promo_approval (delete)",
    "brand_comments" "text",
    "submission_notes" "text",
    "submitted_promotional_contracts" "jsonb",
    CONSTRAINT "brand_promo_requests_promo_type_brand_facing_check" CHECK (("promo_type_brand_facing" = ANY (ARRAY['TPR'::"text", 'AD'::"text", 'EDLP'::"text"])))
);
ALTER TABLE "public"."brand_promo_requests (Deprecated)" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_promo_requests (Deprecated)" IS 'Every promo request made by a brand. This helps track which promo is done and which are left to';
CREATE TABLE IF NOT EXISTS "public"."brand_promotions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brand" "uuid",
    "master_promo_id" "uuid",
    "retailer_id" "uuid",
    "distribution_id" "uuid",
    "promo_quarter" "public"."Quarter",
    "submission_status" "public"."promo_submissinon_status" DEFAULT 'Requested'::"public"."promo_submissinon_status",
    "brand_approval" "public"."brand_promo_approval (delete)",
    "submission_notes" "text",
    "brand_comments" "text",
    "submitted_promo_contracts" "jsonb",
    "oi_percentage" "text",
    "mcb_percentage" "text",
    "per_unit_scan_amount" numeric(8,2),
    "last_updated" timestamp with time zone DEFAULT "now"(),
    "brand_ specific_promo_notes" "text",
    "promo_fee_notes" "text",
    "promo_length" "text",
    "distribution" "uuid",
    "promo_type" "uuid"
);
ALTER TABLE "public"."brand_promotions" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_promotions" IS 'All the promotions done for specific brands';
COMMENT ON COLUMN "public"."brand_promotions"."master_promo_id" IS 'Links to master_promo_data';
COMMENT ON COLUMN "public"."brand_promotions"."retailer_id" IS 'Links to retailer';
COMMENT ON COLUMN "public"."brand_promotions"."distribution_id" IS 'Links to distributor HQs';
COMMENT ON COLUMN "public"."brand_promotions"."promo_fee_notes" IS 'For Brand specific notes regarding promo fees/waivers/and etc.';
COMMENT ON COLUMN "public"."brand_promotions"."promo_length" IS 'Ads run 1-4 weeks, most TPRs are 4 weeks, and some accounts run on bimonthly cycles.';
CREATE OR REPLACE VIEW "public"."brand_status_analytics" AS
 WITH "unnested_statuses" AS (
         SELECT "b"."id",
            "b"."brand",
            "unnest"("b"."status") AS "status",
            "b"."services",
            "b"."coverage"
           FROM "public"."brands" "b"
          WHERE ("b"."status" IS NOT NULL)
        ), "status_categories" AS (
         SELECT "unnested_statuses"."id",
            "unnested_statuses"."brand",
            "unnested_statuses"."status",
                CASE
                    WHEN ("unnested_statuses"."status" = ANY (ARRAY['Active'::"public"."Brand Status", 'Priority'::"public"."Brand Status", 'Demo Program - Depricated'::"public"."Brand Status", 'SOS Program - Depricated'::"public"."Brand Status"])) THEN 'Active/Healthy'::"text"
                    WHEN ("unnested_statuses"."status" = ANY (ARRAY['Onboarding'::"public"."Brand Status", 'New to Market'::"public"."Brand Status"])) THEN 'Onboarding'::"text"
                    WHEN ("unnested_statuses"."status" = ANY (ARRAY['Sustaining (Commission)'::"public"."Brand Status", 'Commission'::"public"."Brand Status", 'Low Comm - Depricated'::"public"."Brand Status", 'Private Label - Depricated'::"public"."Brand Status", 'Special'::"public"."Brand Status"])) THEN 'Commission/Special'::"text"
                    WHEN ("unnested_statuses"."status" = ANY (ARRAY['Pause time TBD - Depricated'::"public"."Brand Status", 'Demo Request Time Off'::"public"."Brand Status", 'Pause TBD'::"public"."Brand Status", 'In Cancellation'::"public"."Brand Status"])) THEN 'At Risk/Paused'::"text"
                    WHEN ("unnested_statuses"."status" = ANY (ARRAY['Former GoodNow Vendor'::"public"."Brand Status", 'Former Demo Vendor'::"public"."Brand Status", 'Former SOS Vendor'::"public"."Brand Status"])) THEN 'Former/Inactive'::"text"
                    WHEN ("unnested_statuses"."status" = 'Prospect'::"public"."Brand Status") THEN 'Prospect'::"text"
                    ELSE 'Other'::"text"
                END AS "status_category",
                CASE
                    WHEN ("unnested_statuses"."status" = ANY (ARRAY['Active'::"public"."Brand Status", 'Priority'::"public"."Brand Status", 'Demo Program - Depricated'::"public"."Brand Status", 'SOS Program - Depricated'::"public"."Brand Status", 'Onboarding'::"public"."Brand Status", 'New to Market'::"public"."Brand Status", 'Sustaining (Commission)'::"public"."Brand Status", 'Commission'::"public"."Brand Status", 'Low Comm - Depricated'::"public"."Brand Status", 'Private Label - Depricated'::"public"."Brand Status", 'Special'::"public"."Brand Status"])) THEN 1
                    WHEN ("unnested_statuses"."status" = ANY (ARRAY['Pause time TBD - Depricated'::"public"."Brand Status", 'Demo Request Time Off'::"public"."Brand Status", 'Pause TBD'::"public"."Brand Status", 'In Cancellation'::"public"."Brand Status", 'Prospect'::"public"."Brand Status"])) THEN 2
                    WHEN ("unnested_statuses"."status" = ANY (ARRAY['Former GoodNow Vendor'::"public"."Brand Status", 'Former Demo Vendor'::"public"."Brand Status", 'Former SOS Vendor'::"public"."Brand Status"])) THEN 3
                    ELSE 4
                END AS "health_score"
           FROM "unnested_statuses"
        )
 SELECT "status_categories"."status",
    "status_categories"."status_category",
    "status_categories"."health_score",
    "count"(DISTINCT "status_categories"."id") AS "brand_count",
    "round"(((100.0 * ("count"(DISTINCT "status_categories"."id"))::numeric) / "sum"("count"(DISTINCT "status_categories"."id")) OVER ()), 2) AS "percentage"
   FROM "status_categories"
  GROUP BY "status_categories"."status", "status_categories"."status_category", "status_categories"."health_score"
  ORDER BY "status_categories"."health_score", "status_categories"."status_category", ("count"(DISTINCT "status_categories"."id")) DESC;
ALTER TABLE "public"."brand_status_analytics" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."brand_sync_call_schedule" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brand_id" "uuid",
    "sync_date" "date",
    "start_time" time with time zone,
    "meeting_link" "text",
    "meeting_topic_notes_optional" "text"
);
ALTER TABLE "public"."brand_sync_call_schedule" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_sync_call_schedule" IS 'Carmen updates this to display this upcoming weeks syncs.';
COMMENT ON COLUMN "public"."brand_sync_call_schedule"."brand_id" IS 'Brand for sync call';
COMMENT ON COLUMN "public"."brand_sync_call_schedule"."meeting_link" IS 'Teams meeting link';
COMMENT ON COLUMN "public"."brand_sync_call_schedule"."meeting_topic_notes_optional" IS 'Any relevant meeting topic notes';
CREATE TABLE IF NOT EXISTS "public"."brand_task_templates" (
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "task_type_uuid" "uuid",
    "applies_to_services" "public"."Active Services"[],
    "title" "text",
    "description" "text",
    "is_required" boolean DEFAULT true,
    "is_active" boolean DEFAULT true
);
ALTER TABLE "public"."brand_task_templates" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_task_templates" IS 'Rules that say which services get which tasks and whether they are required.';
COMMENT ON COLUMN "public"."brand_task_templates"."task_type_uuid" IS 'Links to task_type table';
COMMENT ON COLUMN "public"."brand_task_templates"."applies_to_services" IS 'What services this task applies to.';
COMMENT ON COLUMN "public"."brand_task_templates"."title" IS 'Task title';
COMMENT ON COLUMN "public"."brand_task_templates"."description" IS 'description of task';
COMMENT ON COLUMN "public"."brand_task_templates"."is_required" IS 'Is this a required task for onboarding?';
CREATE TABLE IF NOT EXISTS "public"."brand_task_types" (
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "code" "text" NOT NULL,
    "display_name" "text" NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true NOT NULL
);
ALTER TABLE "public"."brand_task_types" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_task_types" IS 'Task Types → this is our master list of what kinds of tasks exist (like “Upload W9,” “Upload Product Images,” “Complete Company Profile”). It keeps the names clean and consistent so no one spells things differently.';
COMMENT ON COLUMN "public"."brand_task_types"."display_name" IS 'Ex: Upload W9';
COMMENT ON COLUMN "public"."brand_task_types"."is_active" IS 'A brand task that is current / still in use';
CREATE TABLE IF NOT EXISTS "public"."brand_tasks" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brand_uuid" "uuid",
    "source" "public"."brand_task_source" NOT NULL,
    "template_uuid" "uuid",
    "task_type_code_readonly" "text",
    "title_readonly_if_from_template" "text",
    "description_readonly_if_from_template" "text",
    "status" "public"."brand_task_status",
    "due_date" "date",
    "assignee_user_id" "uuid",
    "notes" "text",
    "completed_date" timestamp with time zone,
    "brand_name" "text",
    "assignee_name" "text"
);
ALTER TABLE "public"."brand_tasks" OWNER TO "postgres";
COMMENT ON TABLE "public"."brand_tasks" IS 'Live tasks by brand aka the actual checklist items the brand works on.';
COMMENT ON COLUMN "public"."brand_tasks"."brand_uuid" IS 'Links to brands table';
COMMENT ON COLUMN "public"."brand_tasks"."source" IS 'Is it pre-defined from a template or a one-off task';
COMMENT ON COLUMN "public"."brand_tasks"."template_uuid" IS 'Links to brand task_templates';
COMMENT ON COLUMN "public"."brand_tasks"."task_type_code_readonly" IS 'copied from task_types.code';
COMMENT ON COLUMN "public"."brand_tasks"."title_readonly_if_from_template" IS 'Pre-filled from template. Only fill out if one-off task type';
COMMENT ON COLUMN "public"."brand_tasks"."description_readonly_if_from_template" IS 'Pre-filled from template. Only fill out if one-off task type';
COMMENT ON COLUMN "public"."brand_tasks"."completed_date" IS 'When task marked as completed';
CREATE OR REPLACE VIEW "public"."brands_by_region" AS
 SELECT "unnest"("brands"."coverage") AS "region",
    "count"("brands"."id") AS "brand_count"
   FROM "public"."brands"
  GROUP BY ("unnest"("brands"."coverage"))
  ORDER BY ("count"("brands"."id")) DESC;
ALTER TABLE "public"."brands_by_region" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."brands_migration" (
    "brand" "text",
    "manufacturer_name" "text",
    "principal_list_status" "public"."Principal List Status",
    "status" "public"."Brand Status"[],
    "services" "public"."Active Services"[],
    "coverage" "public"."Coverage"[],
    "start_date" "date",
    "last_date" "date",
    "sos_start_date" "date",
    "demo_start_date" "date",
    "headquarters_address" "text",
    "mailing_address_if_different" "text",
    "free_fill_placement_authorization" "text",
    "samples_policy_and_request_process" "text",
    "mission_components" "text",
    "overall_brand_goals" "text",
    "demos_included_quarterly" integer,
    "sos_calls_included_monthly" numeric(10,2),
    "sos_sales_rate" numeric(10,2),
    "referred_by" "text",
    "product_pickup_address" "text",
    "product_summary" "text",
    "se___current_month" numeric(10,2),
    "invoice_timing" "text",
    "billing_notes" "text",
    "tax_id_number" "text",
    "private_label_bulk_and__or_food_service" "public"."sales_channel"[],
    "describe_any_capabilities_from_the_selection_above" "text",
    "order_lead_time" "text",
    "full_reclamation_or_spoils_allowance" "text",
    "brand_certifications" "text",
    "capacity_or_production_restrictions" "text",
    "direct_order_details_process" "text",
    "marketing_descriptions" "text",
    "email_pitch_descriptor" "text",
    "are_you_a_member_of_any_trade_organizations" "text",
    "product_attributes" "text",
    "onboarding_notes" "text",
    "company_website" "text",
    "cancellation_reasons" "text",
    "se___next_month" numeric(10,2),
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "follow_up_email_draft" "text",
    "category_for_principal_list" "text"[],
    "product_sub_category_for_principal_list" "public"."product_subcategory_enum (principal list)"[],
    "new_item_tag" "public"."new_item_tag_enum",
    "attention_flags" "public"."attention_flag_enum"[],
    "brand_logo" "text",
    "search_vector" "tsvector",
    "other_active_brokerage_service_coverage" "text",
    "legacy_id" "text",
    "brand_contracts" "jsonb",
    "sell_sheets" "jsonb",
    "pitch_decks" "jsonb",
    "product_images" "jsonb"
);
ALTER TABLE "public"."brands_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."brands_migration" IS 'This is a duplicate of brands';
COMMENT ON COLUMN "public"."brands_migration"."legacy_id" IS 'Airtable legacy id';
CREATE TABLE IF NOT EXISTS "public"."contacts_migration" (
    "verification_needed" "public"."verification_status"[],
    "job_title" "text",
    "contact_email" "text",
    "contact_phone" "text",
    "department_tags" "public"."Department Tags (Deprecated) RH"[],
    "contact_notes" "text",
    "last_modified" timestamp without time zone DEFAULT "now"(),
    "create_date" "text",
    "first_name" "text",
    "last_name" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "full_name" "text" GENERATED ALWAYS AS ((("first_name" || ' '::"text") || "last_name")) STORED,
    "full_name_and_account" "text",
    "name_and_title" "text",
    "hide_from_apps" boolean,
    "linked_category_review_contact" "uuid",
    "account" "uuid",
    "no_contact_details" "public"."No Contact Details"[],
    "enriched_email" "text",
    "enriched_phone" "text",
    "enriched_company_name" "text",
    "enriched_job_title" "text",
    "last_enriched_timestamp" "text",
    "legacy_id" "text"
);
ALTER TABLE "public"."contacts_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."contacts_migration" IS 'This is a duplicate of contacts';
COMMENT ON COLUMN "public"."contacts_migration"."full_name" IS 'Concatenation first and last name fields.';
COMMENT ON COLUMN "public"."contacts_migration"."hide_from_apps" IS 'Contacts who don''t want to appear in our apps.';
COMMENT ON COLUMN "public"."contacts_migration"."linked_category_review_contact" IS 'links to the category review contact is associated with.';
COMMENT ON COLUMN "public"."contacts_migration"."account" IS 'References account contact is associated with.';
COMMENT ON COLUMN "public"."contacts_migration"."enriched_email" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
COMMENT ON COLUMN "public"."contacts_migration"."enriched_phone" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
COMMENT ON COLUMN "public"."contacts_migration"."enriched_company_name" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
COMMENT ON COLUMN "public"."contacts_migration"."enriched_job_title" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
COMMENT ON COLUMN "public"."contacts_migration"."last_enriched_timestamp" IS 'Enriched field that populates based on API scraping a platform to help update contact info.';
CREATE TABLE IF NOT EXISTS "public"."jt_accounts_team_member_guide" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "account_uuid" "uuid" NOT NULL,
    "team_member_uuid" "uuid",
    "account_name" "text",
    "team_member_name" "text"
);
ALTER TABLE "public"."jt_accounts_team_member_guide" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_accounts_team_member_guide" IS 'Junction table for Team members i.e. GNF employees who are attached to specific accounts';
CREATE OR REPLACE VIEW "public"."costco_team_member_view" AS
 SELECT "atm"."account_uuid",
    "a"."account" AS "account_name",
    "string_agg"("tm"."name", ', '::"text") AS "team_member_names"
   FROM (("public"."jt_accounts_team_member_guide" "atm"
     JOIN "public"."accounts" "a" ON (("atm"."account_uuid" = "a"."uuid")))
     JOIN "public"."team_member_guide" "tm" ON (("atm"."team_member_uuid" = "tm"."uuid")))
  WHERE ("a"."account" = 'Costco: Mexico HQ'::"text")
  GROUP BY "atm"."account_uuid", "a"."account"
  ORDER BY "a"."account";
ALTER TABLE "public"."costco_team_member_view" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."deal_activity_comments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "deal_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "comment_text" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "attachment" "jsonb"[]
);
ALTER TABLE "public"."deal_activity_comments" OWNER TO "postgres";
COMMENT ON TABLE "public"."deal_activity_comments" IS 'On any particular GNF deal, multiple team members can collaborate and leave their comments  i.e. tag the person they are working with. This table stores all the comments.';
COMMENT ON COLUMN "public"."deal_activity_comments"."attachment" IS 'Let users submit attachemnts';
CREATE TABLE IF NOT EXISTS "public"."deal_stage_history" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "activity_id" "uuid" NOT NULL,
    "old_deal_stage_ref" "uuid",
    "new_deal_stage_ref" "uuid",
    "activity_notes" "text",
    "changed_by" "uuid" DEFAULT "auth"."uid"(),
    "changed_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."deal_stage_history" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."demos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "demo_date" "date",
    "date_submitted" "date",
    "demo_status" "public"."demo_status_enum" DEFAULT 'Requested'::"public"."demo_status_enum",
    "start_time" time without time zone,
    "end_time" time without time zone,
    "time_range" interval GENERATED ALWAYS AS (
CASE
    WHEN (("start_time" IS NOT NULL) AND ("end_time" IS NOT NULL)) THEN ("end_time" - "start_time")
    ELSE NULL::interval
END) STORED,
    "account_id" "uuid",
    "team_member_id" "uuid",
    "store_poc" "text",
    "demo_fee" numeric(10,2) DEFAULT 0,
    "date_billed" "text",
    "other_fees" numeric(10,2) DEFAULT 0,
    "billing_notes" "text",
    "notes" "text",
    "store_busy_rating" integer,
    "price_on_shelf" numeric(10,2),
    "units_before" integer,
    "units_after" integer,
    "units_sampled" integer,
    "avg_samples_given" integer,
    "total_units_sold" integer,
    "demo_feedback" "text",
    "demo_hours" numeric(4,2) DEFAULT 0,
    "training_hours" numeric(4,2) DEFAULT 0,
    "merchandising_hours" numeric(4,2) DEFAULT 0,
    "other_hours" numeric(4,2) DEFAULT 0,
    "total_hours" numeric(4,2) GENERATED ALWAYS AS ((((COALESCE("demo_hours", (0)::numeric) + COALESCE("training_hours", (0)::numeric)) + COALESCE("merchandising_hours", (0)::numeric)) + COALESCE("other_hours", (0)::numeric))) STORED,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "demo_images" "jsonb",
    "demo_receipts" "jsonb",
    "demo_request_type" "public"."demo_request_type_enum",
    "requested_timing" "text",
    "store_names" "text"[],
    "retailer_fees" "jsonb",
    "check_in_photo" "jsonb",
    "check_in_status" boolean DEFAULT false,
    "nwg_demo" boolean DEFAULT false,
    "notes_to_demo_team" "text",
    "time_off_requested" boolean DEFAULT false,
    "time_off_request_date" timestamp with time zone,
    "time_off_notes" "text",
    CONSTRAINT "demos_store_busy_rating_check" CHECK ((("store_busy_rating" >= 1) AND ("store_busy_rating" <= 5)))
);
ALTER TABLE "public"."demos" OWNER TO "postgres";
COMMENT ON TABLE "public"."demos" IS 'Demos are carried out for a lot of our accounts where team member go and conduct a demo for that account. It helps us track check-in information and store any demo related materials';
CREATE OR REPLACE VIEW "public"."demo_dashboard_metrics" AS
 SELECT ( SELECT "count"(*) AS "count"
           FROM "public"."demos"
          WHERE (("demos"."demo_date" > CURRENT_DATE) AND ("demos"."demo_status" = ANY (ARRAY['Requested'::"public"."demo_status_enum", 'Store Confirmed'::"public"."demo_status_enum"])))) AS "upcoming_demos",
    ( SELECT "count"(*) AS "count"
           FROM "public"."demos"
          WHERE ("demos"."demo_status" = 'Completed'::"public"."demo_status_enum")) AS "total_completed",
    ( SELECT "min"("demos"."demo_date") AS "min"
           FROM "public"."demos"
          WHERE (("demos"."demo_date" > CURRENT_DATE) AND ("demos"."demo_status" = ANY (ARRAY['Requested'::"public"."demo_status_enum", 'Store Confirmed'::"public"."demo_status_enum"])))) AS "next_demo_date",
    ( SELECT "to_char"(("min"("demos"."demo_date"))::timestamp with time zone, 'MM/DD/YY'::"text") AS "to_char"
           FROM "public"."demos"
          WHERE (("demos"."demo_date" > CURRENT_DATE) AND ("demos"."demo_status" = ANY (ARRAY['Requested'::"public"."demo_status_enum", 'Store Confirmed'::"public"."demo_status_enum"])))) AS "next_demo_formatted";
ALTER TABLE "public"."demo_dashboard_metrics" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."demos_migration" (
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "demo_date" "date",
    "date_submitted" "date",
    "demo_status" "public"."demo_status_enum" DEFAULT 'Requested'::"public"."demo_status_enum",
    "start_time" time without time zone,
    "end_time" time without time zone,
    "time_range" interval GENERATED ALWAYS AS (
CASE
    WHEN (("start_time" IS NOT NULL) AND ("end_time" IS NOT NULL)) THEN ("end_time" - "start_time")
    ELSE NULL::interval
END) STORED,
    "account_id" "uuid",
    "team_member_id" "uuid",
    "store_poc" "text",
    "demo_fee" numeric(10,2) DEFAULT 0,
    "date_billed" "text",
    "other_fees" numeric(10,2) DEFAULT 0,
    "billing_notes" "text",
    "notes" "text",
    "store_busy_rating" numeric(10,2),
    "price_on_shelf" numeric(10,2),
    "units_before" numeric(10,2),
    "units_after" numeric(10,2),
    "units_sampled" numeric(10,2),
    "avg_samples_given" numeric(10,2),
    "total_units_sold" numeric(10,2),
    "demo_feedback" "text",
    "demo_hours" numeric(4,2) DEFAULT 0,
    "training_hours" numeric(4,2) DEFAULT 0,
    "merchandising_hours" numeric(4,2) DEFAULT 0,
    "other_hours" numeric(4,2) DEFAULT 0,
    "total_hours" numeric(4,2) GENERATED ALWAYS AS ((((COALESCE("demo_hours", (0)::numeric) + COALESCE("training_hours", (0)::numeric)) + COALESCE("merchandising_hours", (0)::numeric)) + COALESCE("other_hours", (0)::numeric))) STORED,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "demo_images" "jsonb",
    "demo_receipts" "jsonb",
    "demo_request_type" "public"."demo_request_type_enum",
    "requested_timing" "text",
    "store_names" "text"[],
    "retailer_fees" "jsonb",
    "check_in_photo" "jsonb",
    "check_in_status" boolean DEFAULT false,
    "nwg_demo" boolean DEFAULT false,
    "notes_to_demo_team" "text",
    "time_off_requested" boolean DEFAULT false,
    "time_off_request_date" timestamp with time zone,
    "time_off_notes" "text",
    "legacy_id" "text",
    CONSTRAINT "demos_store_busy_rating_check" CHECK ((("store_busy_rating" >= (1)::numeric) AND ("store_busy_rating" <= (5)::numeric)))
);
ALTER TABLE "public"."demos_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."demos_migration" IS 'This is a duplicate of demos';
CREATE OR REPLACE VIEW "public"."event_with_attendees" AS
SELECT
    NULL::"uuid" AS "event_id",
    NULL::"text" AS "event_name",
    NULL::"text" AS "event_dates",
    NULL::integer AS "event_year",
    NULL::"text" AS "readable_event_title",
    NULL::"json" AS "attending_brands",
    NULL::"json" AS "confirmed_team_members";
ALTER TABLE "public"."event_with_attendees" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."events_migration" (
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "event_name" "text",
    "event_year" integer,
    "event_dates" "text",
    "event_tags" "text"[],
    "location" "text",
    "website" "text",
    "notes" "text",
    "event_forms" "text"[],
    "event_dispay_image" "text",
    "event_description" "text",
    "goodnow_participation" "public"."GoodNow Event Participation Status",
    "booth_number" "text",
    "accommodations" "text",
    "event_display_name" "text" GENERATED ALWAYS AS ((("event_name" || ' - '::"text") || ("event_year")::"text")) STORED,
    "internal_event_planning_forms" "jsonb",
    "start_date" "date",
    "end_date" "date",
    "display_name" "text" GENERATED ALWAYS AS (("event_name" || COALESCE((' - '::"text" || ("event_year")::"text"), ' - '::"text"))) STORED,
    "legacy_id" "text"
);
ALTER TABLE "public"."events_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."events_migration" IS 'This is a duplicate of events';
COMMENT ON COLUMN "public"."events_migration"."event_forms" IS 'Public facing forms that can be displayed out';
COMMENT ON COLUMN "public"."events_migration"."goodnow_participation" IS 'Is our company participating in this event';
COMMENT ON COLUMN "public"."events_migration"."booth_number" IS 'Our booth # for this event.';
COMMENT ON COLUMN "public"."events_migration"."accommodations" IS 'Where are team is staying during the event, along with notes.';
COMMENT ON COLUMN "public"."events_migration"."internal_event_planning_forms" IS 'For internal use; booth layout docs, planning, etc.';
COMMENT ON COLUMN "public"."events_migration"."start_date" IS 'start date for the event';
COMMENT ON COLUMN "public"."events_migration"."end_date" IS 'date when the event ends';
CREATE TABLE IF NOT EXISTS "public"."folders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "name" "text" NOT NULL,
    "parent_id" "uuid",
    "brand_id" "uuid",
    "tag_id" "text"
);
ALTER TABLE "public"."folders" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."folder_contents" AS
 SELECT "folders"."id",
    "folders"."created_at",
    "folders"."name",
    'folder'::"text" AS "item_type",
    true AS "is_folder",
    NULL::"text" AS "storage_path",
    NULL::"text" AS "size",
    NULL::"text" AS "status",
    NULL::"text" AS "type",
    "folders"."parent_id",
    "folders"."brand_id",
    NULL::"text" AS "url"
   FROM "public"."folders"
UNION ALL
 SELECT "brand_documents"."id",
    "brand_documents"."created_at",
    "brand_documents"."name",
    'file'::"text" AS "item_type",
    false AS "is_folder",
    "brand_documents"."storage_path",
    "brand_documents"."size",
    "brand_documents"."status",
    "brand_documents"."type",
    "brand_documents"."folder_id" AS "parent_id",
    "brand_documents"."brand_id",
    "brand_documents"."url"
   FROM "public"."brand_documents"
  WHERE (("brand_documents"."status" <> 'archived'::"text") OR ("brand_documents"."status" IS NULL));
ALTER TABLE "public"."folder_contents" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."harvesthub_documents" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "name" "text" NOT NULL,
    "storage_path" "text" NOT NULL,
    "size" "text",
    "type" "text",
    "status" "text" DEFAULT 'pending'::"text",
    "folder_id" "uuid",
    "brand_id" "uuid" DEFAULT "auth"."uid"(),
    "url" "text"
);
ALTER TABLE "public"."harvesthub_documents" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."hh_account_experts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "company" "text",
    "email" "text",
    "phone" "text",
    "status" "public"."hh_community_expert_status_enum" DEFAULT 'Form Submitted - Pending Approval'::"public"."hh_community_expert_status_enum",
    "why_expert_on_account" "text",
    "expert_bio" "text",
    "linkedin_url" "text",
    "company_website" "text",
    "profile_photo" "text",
    "associated_accounts" "text",
    "consultation_fees" "text",
    "hourly_rate" "text",
    "payment_method_accepted" "text",
    "internal_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "expert_services_offered" "public"."hh_expert_services"[]
);
ALTER TABLE "public"."hh_account_experts" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_account_experts" IS 'Harvest Hub has a lot of experts for new CPG brands to help them grow and get relevant help from these industry experts';
CREATE TABLE IF NOT EXISTS "public"."hh_account_experts_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "company" "text",
    "email" "text",
    "phone" "text",
    "why_expert_on_account" "text",
    "expert_bio" "text",
    "linkedin_url" "text",
    "company_website" "text",
    "profile_photo" "text",
    "associated_accounts" "text",
    "consultation_fees" "text",
    "hourly_rate" "text",
    "payment_method_accepted" "text",
    "internal_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "expert_services_offered" "public"."hh_expert_services"[],
    "legacy_id" "text",
    "status" "public"."hh_account_expert_status"
);
ALTER TABLE "public"."hh_account_experts_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_account_experts_migration" IS 'This is a duplicate of hh_account_experts';
CREATE TABLE IF NOT EXISTS "public"."hh_blog_articles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "article_type" "text"[],
    "blog_link" "text",
    "source" "text",
    "accreditation" "text",
    "article_name" "text",
    "created_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "blog_image" "jsonb"
);
ALTER TABLE "public"."hh_blog_articles" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_blog_articles" IS 'Informational resources for harvest hub customers';
CREATE TABLE IF NOT EXISTS "public"."hh_blog_articles_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "article_type" "text"[],
    "blog_link" "text",
    "source" "text",
    "accreditation" "text",
    "article_name" "text",
    "created_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "blog_image" "jsonb",
    "legacy_id" "text"
);
ALTER TABLE "public"."hh_blog_articles_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_blog_articles_migration" IS 'This is a migration copy of hh_blog_articles';
CREATE TABLE IF NOT EXISTS "public"."hh_community_experts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "company" "text",
    "email" "text",
    "phone" "text",
    "status" "public"."hh_community_expert_status_enum" DEFAULT 'Form Submitted - Pending Approval'::"public"."hh_community_expert_status_enum",
    "services_offered" "public"."hh_community_expert_services_offered"[],
    "description" "text",
    "linkedin_url" "text",
    "company_website" "text",
    "profile_photo" "text",
    "internal_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."hh_community_experts" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_community_experts" IS 'Community experts at harvest hub help in growing a specific brand for their core business requirements. This is the store for all the consultants working for the community';
CREATE TABLE IF NOT EXISTS "public"."hh_community_experts_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "company" "text",
    "email" "text",
    "phone" "text",
    "status" "public"."hh_community_expert_status_enum" DEFAULT 'Form Submitted - Pending Approval'::"public"."hh_community_expert_status_enum",
    "services_offered" "public"."hh_community_expert_services_offered"[],
    "description" "text",
    "linkedin_url" "text",
    "company_website" "text",
    "profile_photo" "text",
    "internal_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "legacy_id" "text"
);
ALTER TABLE "public"."hh_community_experts_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_community_experts_migration" IS 'This is a duplicate of hh_community_experts';
CREATE TABLE IF NOT EXISTS "public"."hh_contributions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid",
    "account_id" "uuid",
    "contribution_note" "text",
    "file_attachments" "text"[],
    "validation_status" "public"."hh_validation_status_enum" DEFAULT 'Pending Review'::"public"."hh_validation_status_enum",
    "info_updated_in_database" boolean DEFAULT false,
    "internal_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "category_review_id" "uuid"
);
ALTER TABLE "public"."hh_contributions" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_contributions" IS 'Customers are required to submit category reviews and other relevant material as they use the services provided by use';
CREATE TABLE IF NOT EXISTS "public"."hh_contributions_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid",
    "account_id" "uuid",
    "contribution_note" "text",
    "file_attachments" "text"[],
    "validation_status" "public"."hh_validation_status_enum" DEFAULT 'Pending Review'::"public"."hh_validation_status_enum",
    "info_updated_in_database" boolean DEFAULT false,
    "internal_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "legacy_id" "text"
);
ALTER TABLE "public"."hh_contributions_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_contributions_migration" IS 'This is a duplicate of hh_contributions';
CREATE TABLE IF NOT EXISTS "public"."hh_customers_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text",
    "company" "text",
    "email" "text",
    "phone" "text",
    "status" "public"."hh_customer_status_enum",
    "role" "public"."hh_user_role_enum",
    "rate" numeric(10,2),
    "promo_code" "text",
    "promo_description" "text",
    "promo_code_id" "text",
    "billing_terms" "public"."hh_billing_terms_enum",
    "payment_status" "public"."hh_payment_status_enum",
    "payment_date" "date",
    "cancelation_date" "date",
    "cancellation_reason" "text",
    "customer_notes" "text",
    "profile_photo" "text",
    "cr_assigned" boolean DEFAULT false,
    "hh_contributions" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "hh_license" "uuid",
    "lead_source" "uuid",
    "discounted_rate" numeric,
    "invoiced_amount" "text",
    "total_amount_invoiced" numeric GENERATED ALWAYS AS (
CASE
    WHEN ("rate" IS NULL) THEN NULL::numeric
    ELSE "round"(("rate" * ((1)::numeric - (COALESCE("discounted_rate", (0)::numeric) / (100)::numeric))), 2)
END) STORED,
    "startup_cpg_amount_owed" numeric(10,2) GENERATED ALWAYS AS (
CASE
    WHEN (("promo_code" ~~* '%STARTUPCPG20OFF%'::"text") AND ("invoiced_amount" ~ '^[0-9.]+$'::"text")) THEN "round"((("invoiced_amount")::numeric * 0.5), 2)
    ELSE 0.00
END) STORED,
    "startup_cpg_paid" boolean,
    "startup_cpg_paid_date" "date",
    "modified_by" "uuid",
    "prospect_inquiry_message_from_website" "text",
    "customer_status" "uuid",
    "legacy_id" "text"
);
ALTER TABLE "public"."hh_customers_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_customers_migration" IS 'This is a duplicate of hh_customers';
COMMENT ON COLUMN "public"."hh_customers_migration"."discounted_rate" IS 'Rate of discount with promo code applied.';
COMMENT ON COLUMN "public"."hh_customers_migration"."startup_cpg_paid" IS 'Startup CPG’s revenue share payment for this customer has been reconciled and sent.';
COMMENT ON COLUMN "public"."hh_customers_migration"."startup_cpg_paid_date" IS 'Date Startup CPG’s revenue share payment was issued.';
COMMENT ON COLUMN "public"."hh_customers_migration"."modified_by" IS 'Will default to Unknown User uuid.';
CREATE TABLE IF NOT EXISTS "public"."hh_deals" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" NOT NULL,
    "account_id" "uuid" NOT NULL,
    "stage" "public"."hh_deal_stage_enum" DEFAULT 'Target'::"public"."hh_deal_stage_enum",
    "deal_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "priority" "public"."priority_enum"
);
ALTER TABLE "public"."hh_deals" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_deals" IS 'All the dels carried out by the customers that correspond to our accounts and related deal owners from team_member_guide';
CREATE TABLE IF NOT EXISTS "public"."hh_deals_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid",
    "account_id" "uuid",
    "stage" "public"."hh_deal_stage_enum" DEFAULT 'Target'::"public"."hh_deal_stage_enum",
    "deal_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "priority" "public"."priority_enum",
    "legacy_id" "text"
);
ALTER TABLE "public"."hh_deals_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_deals_migration" IS 'This is a migration of hh_deals';
CREATE TABLE IF NOT EXISTS "public"."hh_feature_updates" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "update_type" "text"[],
    "title" "text",
    "date" "date",
    "description" "text",
    "attachment" "text"
);
ALTER TABLE "public"."hh_feature_updates" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_feature_updates" IS 'We share any new feature every now and then. This table is used to send and store that data.';
COMMENT ON COLUMN "public"."hh_feature_updates"."date" IS 'Feature update date';
CREATE TABLE IF NOT EXISTS "public"."hh_feature_updates_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "update_type" "text"[],
    "title" "text",
    "date" "date",
    "description" "text",
    "attachment" "jsonb",
    "legacy_id" "text"
);
ALTER TABLE "public"."hh_feature_updates_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_feature_updates_migration" IS 'This is a migration copy of hh_feature_updates';
COMMENT ON COLUMN "public"."hh_feature_updates_migration"."date" IS 'Feature update date';
CREATE TABLE IF NOT EXISTS "public"."hh_licenses" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_name" "text" NOT NULL,
    "plan_details" "text",
    "product_status" "public"."hh_license_status_enum" DEFAULT 'Active Product'::"public"."hh_license_status_enum",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."hh_licenses" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_licenses" IS 'There is a tiered subscription for harvest hub potential clients and when they convert based on the amount they pay they get services. licenses hold the data to track all these services';
CREATE TABLE IF NOT EXISTS "public"."hh_licenses_migration" (
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_name" "text" NOT NULL,
    "plan_details" "text",
    "product_status" "public"."hh_license_status_enum" DEFAULT 'Active Product'::"public"."hh_license_status_enum",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "legacy_id" "text"
);
ALTER TABLE "public"."hh_licenses_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_licenses_migration" IS 'This is a migration of hh_licenses';
CREATE TABLE IF NOT EXISTS "public"."hh_promo_codes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "promo_code_name" "text",
    "promo_code_description" "text",
    "active_status" boolean
);
ALTER TABLE "public"."hh_promo_codes" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_promo_codes" IS 'Running list of promo codes being used.';
COMMENT ON COLUMN "public"."hh_promo_codes"."promo_code_description" IS 'A brief description of what this code is for and conditions if any.';
COMMENT ON COLUMN "public"."hh_promo_codes"."active_status" IS 'Is this promo code currently active?';
CREATE TABLE IF NOT EXISTS "public"."hh_prospect_customers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text",
    "company" "text",
    "title" "text",
    "email" "text",
    "phone" "text",
    "contact_source" "public"."hh_contact_source_enum",
    "conversion_status" "text",
    "product_interest" "public"."hh_product_interest_enum",
    "customer_inquiry_source" "public"."hh_customer_inquiry_source",
    "interested_use_cases" "public"."hh_customer_inquiry_use_cases"[],
    "inquiry_message" "text",
    "internal_notes" "text",
    "followed_up" boolean DEFAULT false,
    "linkedin_url" "text",
    "business_card_image" "text",
    "customer_id" "uuid",
    "is_active" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."hh_prospect_customers" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_prospect_customers" IS 'Some brands come and show interest in utilizing harvest hub services these are all the prospective customers who might convert into a paying client';
CREATE TABLE IF NOT EXISTS "public"."hh_prospect_customers_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text",
    "company" "text",
    "title" "text",
    "email" "text",
    "phone" "text",
    "contact_source" "public"."hh_contact_source_enum",
    "conversion_status" "text",
    "product_interest" "public"."hh_product_interest_enum",
    "customer_inquiry_source" "public"."hh_customer_inquiry_source",
    "interested_use_cases" "public"."hh_customer_inquiry_use_cases"[],
    "inquiry_message" "text",
    "internal_notes" "text",
    "followed_up" boolean DEFAULT false,
    "linkedin_url" "text",
    "business_card_image" "text",
    "customer_id" "uuid",
    "is_active" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "legacy_id" "text"
);
ALTER TABLE "public"."hh_prospect_customers_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."hh_prospect_customers_migration" IS 'This is a duplicate of hh_prospect_customers';
CREATE TABLE IF NOT EXISTS "public"."interaction_partners" (
    "partner_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "partner_name" "text" NOT NULL,
    "partner_type" "text" NOT NULL,
    "original_record_id" "uuid" NOT NULL
);
ALTER TABLE "public"."interaction_partners" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_accounts_distribution" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "distributor_account_id" "uuid",
    "retail_account_id" "uuid"
);
ALTER TABLE "public"."jt_accounts_distribution" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_accounts_distribution" IS 'Relationship to signify which distributors an account uses.';
CREATE TABLE IF NOT EXISTS "public"."jt_active_account_distribution_grid" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "account_id" "uuid",
    "distribution_grid_id" "uuid"
);
ALTER TABLE "public"."jt_active_account_distribution_grid" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_active_account_distribution_grid" IS 'Active  accounts for a  brand''s distributor. DEPRECATED??';
CREATE TABLE IF NOT EXISTS "public"."jt_activity_note_mentions" (
    "user_id" "uuid" NOT NULL,
    "activity_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."jt_activity_note_mentions" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_activity_note_mentions" IS 'this stores persons mentioned on a deal activity note';
CREATE TABLE IF NOT EXISTS "public"."jt_associated_skus" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "deal_id" "uuid",
    "sku_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "sku_deal_status" "public"."sku_deal_status"
);
ALTER TABLE "public"."jt_associated_skus" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_associated_skus" IS 'Junction table for deals with their associated skus from spec and price sheet';
COMMENT ON COLUMN "public"."jt_associated_skus"."sku_deal_status" IS 'curent status of the sku in relation to the current deal';
CREATE TABLE IF NOT EXISTS "public"."jt_brand_events_migration" (
    "uuid" "uuid" DEFAULT "gen_random_uuid"(),
    "brand_id" "uuid",
    "event_id" "uuid",
    "price_to_attend" numeric(10,2),
    "attendees" "text",
    "brand_notes" "text",
    "confirmed_brand_attendees" "text",
    "attendance_status" "public"."attendance_status_enum",
    "legacy_id" "text"
);
ALTER TABLE "public"."jt_brand_events_migration" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_brand_promo_request_skus" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "brand_promo_request_id" "uuid" NOT NULL,
    "sku_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_brand_promo_request_skus" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_brand_promo_request_skus" IS 'Brands always request a promo for a specific SKU. this is the junction table for that';
CREATE TABLE IF NOT EXISTS "public"."jt_brand_promotion_skus" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "brand_promotion_id" "uuid" NOT NULL,
    "sku_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_brand_promotion_skus" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_brand_promotion_skus" IS 'junction table for brand promotions for multiple SKUs';
CREATE TABLE IF NOT EXISTS "public"."jt_category_review_contacts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "contact_id" "uuid",
    "category_review_id" "uuid",
    "last_modified" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_category_review_contacts" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_category_review_contacts" IS 'Point of contact that manages this category reivew';
COMMENT ON COLUMN "public"."jt_category_review_contacts"."contact_id" IS 'Links to contacts table';
COMMENT ON COLUMN "public"."jt_category_review_contacts"."category_review_id" IS 'Links to master category review data';
CREATE TABLE IF NOT EXISTS "public"."jt_contacts_distributor_rep_accounts" (
    "account_uuid" "uuid" NOT NULL,
    "contacts_uuid" "uuid" NOT NULL
);
ALTER TABLE "public"."jt_contacts_distributor_rep_accounts" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_contacts_distributor_rep_accounts" IS 'Contact reps assigned to their distributed accounts';
COMMENT ON COLUMN "public"."jt_contacts_distributor_rep_accounts"."contacts_uuid" IS 'References contacts table';
CREATE TABLE IF NOT EXISTS "public"."jt_deal_category_reviews" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "activity_tracker" "uuid",
    "category_reviews" "uuid",
    "submitted_by" "uuid",
    "category_review_submission_date" "date",
    "category_review_status" "public"."category_review_status_enum (deprecated?)"
);
ALTER TABLE "public"."jt_deal_category_reviews" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_deal_category_reviews" IS 'track categories submitted via the activity tracker';
COMMENT ON COLUMN "public"."jt_deal_category_reviews"."activity_tracker" IS 'Links to deal activity tracker';
COMMENT ON COLUMN "public"."jt_deal_category_reviews"."category_reviews" IS 'Links to Master Category Review table';
COMMENT ON COLUMN "public"."jt_deal_category_reviews"."submitted_by" IS 'Links to users';
CREATE TABLE IF NOT EXISTS "public"."jt_deal_comment_mentions" (
    "user_id" "uuid",
    "comment_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."jt_deal_comment_mentions" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_deal_comment_mentions" IS 'stores all users who were mentioned in a deal activity comment';
CREATE TABLE IF NOT EXISTS "public"."jt_deal_distribution" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deal_id" "uuid",
    "distribution_id" "uuid",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."jt_deal_distribution" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_deal_distribution" IS 'Junction table that tracks each deal with their account distribution grid';
CREATE TABLE IF NOT EXISTS "public"."jt_deal_owners" (
    "deal_id" "uuid",
    "team_member_id" "uuid",
    "account_id" "uuid"
);
ALTER TABLE "public"."jt_deal_owners" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_deal_owners" IS 'DEPRECATED; DON''T DELETE FOR NOW. Multiple team members can have multiple deals to their name this junction table helps in resolving this relationship';
CREATE TABLE IF NOT EXISTS "public"."jt_deal_spec_price_sheet" (
    "deal_id" "uuid" NOT NULL,
    "sku_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_deal_spec_price_sheet" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_deal_spec_price_sheet" IS 'Multiple deals have multiple SKUS from the spec and price sheet. so this many-to-many relationship in kept in-tact using this junction table';
CREATE TABLE IF NOT EXISTS "public"."jt_deal_task_pipeline" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "deal_id" "uuid",
    "task_id" "uuid",
    "time created" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text")
);
ALTER TABLE "public"."jt_deal_task_pipeline" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_deal_task_pipeline" IS 'relationship between activity tracker and task pipeline';
CREATE TABLE IF NOT EXISTS "public"."jt_demo_brands" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "demo_id" "uuid" NOT NULL,
    "brand_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_demo_brands" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_demo_brands" IS 'Junction table to establish relationship between demos carried out for brands';
CREATE TABLE IF NOT EXISTS "public"."jt_hh_customers_accounts_deals" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid",
    "account_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_hh_customers_accounts_deals" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_hh_customers_accounts_deals" IS 'Maps deals HarvesetHub customers create.';
CREATE TABLE IF NOT EXISTS "public"."jt_hh_customers_licenses(deprecated)" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid",
    "license_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_hh_customers_licenses(deprecated)" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_hh_customers_licenses(deprecated)" IS 'Junction table for mapping out harvest hub customers to licenses offered. Not needed for one to one';
CREATE TABLE IF NOT EXISTS "public"."jt_hh_customers_master_categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid",
    "master_category_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_hh_customers_master_categories" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_hh_customers_master_categories" IS 'Junction table for mapping out harvest hub customers to GN Categories';
CREATE TABLE IF NOT EXISTS "public"."jt_master_categories_brands_migration" (
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "master_category_id" "uuid" NOT NULL,
    "brand_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "legacy_id" "text"
);
ALTER TABLE "public"."jt_master_categories_brands_migration" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_master_category_review_data_brands" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "review_data_id" "uuid" NOT NULL,
    "brand_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_master_category_review_data_brands" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_master_category_review_data_brands" IS 'Junction table relationship between category review data and brands. This is also a many to many relationship.';
CREATE TABLE IF NOT EXISTS "public"."jt_master_category_review_data_matching" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "review_data_id" "uuid" NOT NULL,
    "retailer_matching_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_master_category_review_data_matching" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_master_category_review_data_matching" IS 'Junction table to match category review data and matching table for records';
CREATE TABLE IF NOT EXISTS "public"."jt_principal_list_product_images" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brand" "uuid",
    "brand_document_id" "uuid"
);
ALTER TABLE "public"."jt_principal_list_product_images" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_principal_list_product_images" IS 'Where we store product images for brands. Documents x Brands';
CREATE TABLE IF NOT EXISTS "public"."jt_ref_accounts_category_review_received_status" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "account" "uuid",
    "category_review_received_status" "uuid",
    "legacy_id" "text"
);
ALTER TABLE "public"."jt_ref_accounts_category_review_received_status" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_accounts_flag_for_attention" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "flag_for_attention" "uuid",
    "account" "uuid",
    "legacy_id" "text"
);
ALTER TABLE "public"."jt_ref_accounts_flag_for_attention" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_accounts_industry_tags" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "account" "uuid",
    "industry_tag" "uuid",
    "legacy_id" "text"
);
ALTER TABLE "public"."jt_ref_accounts_industry_tags" OWNER TO "postgres";
COMMENT ON COLUMN "public"."jt_ref_accounts_industry_tags"."account" IS 'Links to accounts that references the industry tags field.';
COMMENT ON COLUMN "public"."jt_ref_accounts_industry_tags"."industry_tag" IS 'References industry tags table';
CREATE TABLE IF NOT EXISTS "public"."jt_ref_active_services" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brands" "uuid",
    "ref_active_services" "uuid"
);
ALTER TABLE "public"."jt_ref_active_services" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_announcement_tag" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "company_announcements" "uuid",
    "ref_announcement_tag" "uuid"
);
ALTER TABLE "public"."jt_ref_announcement_tag" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_applied_services" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brand_task_templates" "uuid",
    "ref_active_services" "uuid"
);
ALTER TABLE "public"."jt_ref_applied_services" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_brand_attention_flag" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brands" "uuid",
    "ref_brand_attention_flag" "uuid"
);
ALTER TABLE "public"."jt_ref_brand_attention_flag" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_ref_brand_attention_flag" IS 'Brand attention flags';
CREATE TABLE IF NOT EXISTS "public"."jt_ref_brand_audience_tag" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "company_announcements" "uuid",
    "ref_brand_audience_tag" "uuid"
);
ALTER TABLE "public"."jt_ref_brand_audience_tag" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_brand_status" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brands" "uuid",
    "ref_brand_status" "uuid"
);
ALTER TABLE "public"."jt_ref_brand_status" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_categories_for_principal_list" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brands" "uuid"
);
ALTER TABLE "public"."jt_ref_categories_for_principal_list" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_contact_department_tags" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "contacts" "uuid",
    "ref_contact_department_tags" "uuid"
);
ALTER TABLE "public"."jt_ref_contact_department_tags" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_contacts_flag_for_attention" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "ref_contacts_flag_for_attention" "uuid",
    "contacts" "uuid"
);
ALTER TABLE "public"."jt_ref_contacts_flag_for_attention" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_coverage" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brands" "uuid",
    "ref_coverage" "uuid"
);
ALTER TABLE "public"."jt_ref_coverage" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_departments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "team_member_guide" "uuid",
    "ref_departments" "uuid"
);
ALTER TABLE "public"."jt_ref_departments" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_hh_community_expert_services_offered" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "harvesthub_community_experts" "uuid",
    "ref_hh_community_expert_services_offered" "uuid"
);
ALTER TABLE "public"."jt_ref_hh_community_expert_services_offered" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_hh_expert_services_offered" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "hh_experts" "uuid",
    "ref_hh_expert_services_offered" "uuid"
);
ALTER TABLE "public"."jt_ref_hh_expert_services_offered" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_no_contact_details" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "contacts" "uuid",
    "ref_no_contact_details" "uuid"
);
ALTER TABLE "public"."jt_ref_no_contact_details" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_product_sub_category" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "ref_product_sub_category_id" "uuid",
    "brands" "uuid"
);
ALTER TABLE "public"."jt_ref_product_sub_category" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_ref_product_sub_category" IS 'Product sub categories for principal list';
CREATE TABLE IF NOT EXISTS "public"."jt_ref_sos_program_type" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "sos_authorizations" "uuid",
    "ref_sos_program_type" "uuid"
);
ALTER TABLE "public"."jt_ref_sos_program_type" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_ref_sub_tags" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "accounts" "uuid",
    "sub_tag_reference_table" "uuid"
);
ALTER TABLE "public"."jt_ref_sub_tags" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_retailer_category_to_gn_categories" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "retailer_category_id" "uuid" NOT NULL,
    "gn_category_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_retailer_category_to_gn_categories" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_retailer_category_to_gn_categories" IS 'Junction table between GNF categories and categories defined by retailers.';
CREATE TABLE IF NOT EXISTS "public"."jt_spec_price_sheet_categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "sku_id" "uuid",
    "category_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."jt_spec_price_sheet_categories" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_spec_price_sheet_categories" IS 'Junction table between spec price sheet (SKUs) and master categories.';
CREATE TABLE IF NOT EXISTS "public"."jt_sync_up_notes_accounts" (
    "note_id" "uuid",
    "account_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."jt_sync_up_notes_accounts" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_sync_up_notes_brands" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "brand_id" "uuid" DEFAULT "gen_random_uuid"(),
    "note_id" "uuid" DEFAULT "gen_random_uuid"(),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);
ALTER TABLE "public"."jt_sync_up_notes_brands" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_sync_up_notes_brands" IS 'Jt for Sync_up_notes and brands table';
CREATE TABLE IF NOT EXISTS "public"."jt_task_assignments" (
    "task_id" "uuid" NOT NULL,
    "team_member_uuid" "uuid" NOT NULL,
    "assigned_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."jt_task_assignments" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_task_pipeline_attachments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "document_id" "uuid",
    "task_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);
ALTER TABLE "public"."jt_task_pipeline_attachments" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."jt_user_notifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "member_id" "uuid",
    "notification_id" "uuid" NOT NULL,
    "is_read" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "time_read" timestamp with time zone
);
ALTER TABLE "public"."jt_user_notifications" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_user_notifications" IS 'Junction table for users and notifications relationship';
CREATE TABLE IF NOT EXISTS "public"."jt_user_role_dept" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "gen_random_uuid"(),
    "dept_id" "uuid" DEFAULT "gen_random_uuid"()
);
ALTER TABLE "public"."jt_user_role_dept" OWNER TO "postgres";
COMMENT ON TABLE "public"."jt_user_role_dept" IS 'Junction table connecting a user to one or more departments/role groups';
CREATE TABLE IF NOT EXISTS "public"."master_categories_migration" (
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "full_category" "text",
    "category" "text",
    "subcategory" "text",
    "notes" "text",
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "legacy_id" "text"
);
ALTER TABLE "public"."master_categories_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."master_categories_migration" IS 'This is a duplicate of master_categories';
COMMENT ON COLUMN "public"."master_categories_migration"."full_category" IS 'Concatenation of category field and subcategory';
CREATE TABLE IF NOT EXISTS "public"."master_category_review_data_migration" (
    "uuid" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "display_name" "text",
    "account" "uuid",
    "retailer_category" "text",
    "retailer_review_timing" "text",
    "review_type" "text",
    "retailer_review_date" "date",
    "on_shelf_reset_date" "date",
    "new_item_submission_deadline" "date",
    "master_category_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "archive" boolean,
    "gnf_sub_category" "text",
    "category_notes" "text",
    "legacy_id" "text" NOT NULL
);
ALTER TABLE "public"."master_category_review_data_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."master_category_review_data_migration" IS 'This is a duplicate of master_category_review_data';
COMMENT ON COLUMN "public"."master_category_review_data_migration"."master_category_id" IS 'AKA GNF Category';
COMMENT ON COLUMN "public"."master_category_review_data_migration"."archive" IS 'Toggle this for reviews that are archived';
COMMENT ON COLUMN "public"."master_category_review_data_migration"."gnf_sub_category" IS 'Links to master categories';
COMMENT ON COLUMN "public"."master_category_review_data_migration"."category_notes" IS 'Notes left for each category';
CREATE TABLE IF NOT EXISTS "public"."master_promo_data" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "account" "uuid",
    "effective_promo_month" "public"."Effective Promo Month",
    "effective_promo_year" "public"."Promo Year",
    "promo_submission_due_date" "date",
    "promo_buy_start_date" "date",
    "promo_buy_end_date" "date",
    "promo_start_date" "date",
    "promo_end_date" "date",
    "promo_fee" numeric,
    "fee_notes" "text",
    "general_promo_notes" "text",
    "promotion_type" "uuid",
    "department" "uuid",
    "goodnow_deadline" "date"
);
ALTER TABLE "public"."master_promo_data" OWNER TO "postgres";
COMMENT ON TABLE "public"."master_promo_data" IS 'Promotional details by account and promo type';
COMMENT ON COLUMN "public"."master_promo_data"."account" IS 'Links to accounts';
COMMENT ON COLUMN "public"."master_promo_data"."general_promo_notes" IS 'Additional promotion notes go here';
CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "recipient_id" "uuid" NOT NULL,
    "type" "public"."notification_type" NOT NULL,
    "status" "public"."notification_status" DEFAULT 'unread'::"public"."notification_status" NOT NULL,
    "data" "jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "read_at" timestamp with time zone
);
ALTER TABLE "public"."notifications" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."notifications(deprecated)" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "title" "text",
    "description" "text",
    "type" "text"
);
ALTER TABLE "public"."notifications(deprecated)" OWNER TO "postgres";
COMMENT ON TABLE "public"."notifications(deprecated)" IS 'notification management and logging table to store notifications per user/team_member';
CREATE TABLE IF NOT EXISTS "public"."planned_submissions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deal_id" "uuid",
    "planned_submission_date" "date",
    "submitted_date" "date",
    "submission_status" boolean DEFAULT false,
    "category_review" "uuid",
    "user" "uuid",
    "submission_type" "public"."Submission Type (Deprecated, only one type)",
    "attachment" "jsonb",
    "last_updated" timestamp with time zone DEFAULT "now"(),
    "submitted_by" "uuid"
);
ALTER TABLE "public"."planned_submissions" OWNER TO "postgres";
COMMENT ON TABLE "public"."planned_submissions" IS 'Deals that the team adds to calendar to show when they are pitching in for a brand.';
COMMENT ON COLUMN "public"."planned_submissions"."planned_submission_date" IS 'Date should show on calendar for a planned submission';
COMMENT ON COLUMN "public"."planned_submissions"."submitted_date" IS 'Date logged as when this submission was sent';
COMMENT ON COLUMN "public"."planned_submissions"."submission_status" IS 'When checked marks as been submitted';
CREATE OR REPLACE VIEW "public"."principal_list_product_specs" AS
 SELECT "b"."id" AS "brand_id",
    "b"."brand",
    "s"."id" AS "product_id",
    "s"."unique_item_name" AS "item_name",
    "s"."item_status",
    "s"."sales_rank",
    "s"."uos",
    "s"."uom",
    "s"."vendor_item_number",
    "s"."ean",
    "s"."upc_12_digit" AS "upc",
    "s"."case_upc",
    "s"."master_upc",
    "s"."case_pack",
    "s"."unit_height_inches",
    "s"."unit_width_inches",
    "s"."unit_depth_inches",
    "s"."case_height_inches",
    "s"."case_width_inches",
    "s"."case_depth_inches",
    "s"."net_case_weight_lbs",
    "s"."gross_case_weight_lbs",
    "s"."master_case_weight_lbs",
    "s"."ti",
    "s"."hi",
    "s"."cube",
    "s"."cases_per_pallet",
    "s"."pallet_weight_lbs",
    "s"."item_temp_reqs" AS "transport",
    "s"."fob_location",
    "s"."srp",
    "s"."direct_ship_available",
    "s"."minimum_direct_order_quantity" AS "moq_direct",
    "s"."minimum_order_quantity_distribution" AS "moq_distribution",
    "s"."order_lead_time",
    "s"."shelf_life_in_days_at_manufacture",
    "s"."frozen_shelf_life_if_applicable",
    "s"."shelf_life_in_days_guaranteed",
    "s"."ingredient_list",
    "s"."organic",
    "s"."non_gmo",
    "s"."gluten_free",
    "s"."vegan",
    "s"."vegetarian",
    "s"."kosher",
    "s"."dairy_free",
    "s"."sugar_free",
    "s"."soy_free",
    "s"."nut_free",
    "s"."wheat_free"
   FROM ("public"."brands" "b"
     JOIN "public"."spec_price_sheet" "s" ON (("s"."brand_id" = "b"."id")));
ALTER TABLE "public"."principal_list_product_specs" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."prospects (deprecated)" (
    "name" "text",
    "email" "text",
    "company" "text",
    "notes" "text",
    "phone" "text",
    "prospect _focus" "text",
    "service_of_interest" "text",
    "status" "public"."prospect_status",
    "website" "text",
    "hq_address" "text",
    "account_description" "text",
    "create_date" "text",
    "manufacturer_name" "text",
    "how_many_years_in_business" "text",
    "is_this_primary_business" "text",
    "company_mission" "text",
    "product_uniqueness" "text",
    "current_annual_revenue" "text",
    "growth_goals" "text",
    "sales_capabilities" "text",
    "current_store_count" "text",
    "lost_accounts_context" "text",
    "manufacturing_type" "text",
    "growth_financing" "text",
    "have_active_distribution_partners" boolean,
    "distribution_regions" "text",
    "investor_round" "text",
    "prior_cpg_experience" "text",
    "prior_sales_solution" boolean,
    "prior_sales_solution_experience" "text",
    "brand_learnings" "text",
    "long_term_commitment" "text",
    "market_feedback" "text",
    "active_distributors" "text",
    "team_member_id" "uuid",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "documents_received_array" "public"."documents_received_enum (deprecated?)"[],
    "documents_received" "public"."documents_received_enum (deprecated?)"[],
    "sell_sheets" "text"[],
    "presentation_decks" "text"[]
);
ALTER TABLE "public"."prospects (deprecated)" OWNER TO "postgres";
COMMENT ON TABLE "public"."prospects (deprecated)" IS 'Team members related to prospective clients/brands who are interested in working with GNF';
COMMENT ON COLUMN "public"."prospects (deprecated)"."team_member_id" IS 'link to team_member_guide';
COMMENT ON COLUMN "public"."prospects (deprecated)"."uuid" IS 'uuid for prospects';
CREATE TABLE IF NOT EXISTS "public"."ref_	hh_product_interest_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_	hh_product_interest_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_	hh_product_interest_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_	hh_product_interest_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_account_flag_for_attention_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_account_flag_for_attention_enum" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_active_services" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_active_services" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_announcement_tag" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_announcement_tag" OWNER TO "postgres";
ALTER TABLE "public"."ref_announcement_tag" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_announcement_tag_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_attendance_status_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_attendance_status_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_attendance_status_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_attendance_status_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_brand_attention_flag_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_brand_attention_flag_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_brand_attention_flag_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_attention_flag_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_brand_audience_tag" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_brand_audience_tag" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_brand_promo_table_distributors" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "distributor" "text"
);
ALTER TABLE "public"."ref_brand_promo_table_distributors" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_brand_status" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_brand_status" OWNER TO "postgres";
COMMENT ON TABLE "public"."ref_brand_status" IS 'List of statuses for any given brand program.';
CREATE TABLE IF NOT EXISTS "public"."ref_categories_for_principal_list" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_categories_for_principal_list" OWNER TO "postgres";
COMMENT ON TABLE "public"."ref_categories_for_principal_list" IS 'Umbrella categories for principal list tagging';
CREATE TABLE IF NOT EXISTS "public"."ref_category_review_received_status" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_category_review_received_status" OWNER TO "postgres";
COMMENT ON TABLE "public"."ref_category_review_received_status" IS 'Multi-select options of  category review status by account';
CREATE TABLE IF NOT EXISTS "public"."ref_category_review_type" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_category_review_type" OWNER TO "postgres";
COMMENT ON COLUMN "public"."ref_category_review_type"."name" IS 'Review type name';
CREATE TABLE IF NOT EXISTS "public"."ref_contact_department_tags" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_contact_department_tags" OWNER TO "postgres";
COMMENT ON TABLE "public"."ref_contact_department_tags" IS 'Reference table for department tags';
CREATE TABLE IF NOT EXISTS "public"."ref_contacts_flag_for_attention" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_contacts_flag_for_attention" OWNER TO "postgres";
COMMENT ON TABLE "public"."ref_contacts_flag_for_attention" IS 'Multiselect options to flag contact.';
CREATE TABLE IF NOT EXISTS "public"."ref_country" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_country" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_coverage" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_coverage" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_deal_stage" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_deal_stage" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_decision_level_tag_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_decision_level_tag_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_decision_level_tag_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_decision_level_tag_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_demo_status_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_demo_status_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_demo_status_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_demo_status_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_departments" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_departments" OWNER TO "postgres";
ALTER TABLE "public"."ref_departments" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_departments_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
ALTER TABLE "public"."ref_account_flag_for_attention_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_flag_for_attention_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_goodnow_event _participation_status" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_goodnow_event _participation_status" OWNER TO "postgres";
ALTER TABLE "public"."ref_goodnow_event _participation_status" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_goodnow_event _participation_status_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_hh_billing_terms_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_hh_billing_terms_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_hh_billing_terms_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_hh_billing_terms_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_hh_community_expert_services_offered" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_hh_community_expert_services_offered" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_hh_contact_source_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_hh_contact_source_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_hh_contact_source_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_hh_contact_source_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_hh_customer_status" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_hh_customer_status" OWNER TO "postgres";
ALTER TABLE "public"."ref_hh_customer_status" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_hh_customer_status_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_hh_expert_services_offered" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_hh_expert_services_offered" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_hh_how_found_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_hh_how_found_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_hh_how_found_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_hh_how_found_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_hh_lead_source" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "lead_source" "text"
);
ALTER TABLE "public"."ref_hh_lead_source" OWNER TO "postgres";
COMMENT ON TABLE "public"."ref_hh_lead_source" IS 'Places we''ve captured leads from.';
CREATE TABLE IF NOT EXISTS "public"."ref_hh_payment_status_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_hh_payment_status_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_hh_payment_status_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_hh_payment_status_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_hh_user_role_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_hh_user_role_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_hh_user_role_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_hh_user_role_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_industry_tag" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_industry_tag" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_no_contact_details" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_no_contact_details" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_product_subcategory_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_product_subcategory_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_product_subcategory_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_product_subcategory_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_promo_delivery" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_promo_delivery" OWNER TO "postgres";
ALTER TABLE "public"."ref_promo_delivery" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_promo_delivery_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_promo_types" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_promo_types" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_prospect_status" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_prospect_status" OWNER TO "postgres";
ALTER TABLE "public"."ref_prospect_status" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_prospect_status_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_sos_calling_year" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_sos_calling_year" OWNER TO "postgres";
ALTER TABLE "public"."ref_sos_calling_year" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_sos_calling_year_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_sos_program_type" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text"
);
ALTER TABLE "public"."ref_sos_program_type" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."ref_task_type_enum" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_task_type_enum" OWNER TO "postgres";
ALTER TABLE "public"."ref_task_type_enum" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_task_type_enum_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."ref_verification_status" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text",
    "color" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);
ALTER TABLE "public"."ref_verification_status" OWNER TO "postgres";
ALTER TABLE "public"."ref_verification_status" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ref_verification_status_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE IF NOT EXISTS "public"."retailer_gnf_category_matching" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "account" "uuid",
    "retailer_category_name" "text",
    "category_name_from_excel" "text",
    "unique_category_name" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."retailer_gnf_category_matching" OWNER TO "postgres";
COMMENT ON TABLE "public"."retailer_gnf_category_matching" IS 'Matching table for retailers and the categories attached by GNF for themalong with the review data per category';
CREATE TABLE IF NOT EXISTS "public"."retailer_gnf_category_matching_migration" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "account" "uuid",
    "retailer_category_name" "text",
    "category_name_from_excel" "text",
    "unique_category_name" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "legacy_id" "text"
);
ALTER TABLE "public"."retailer_gnf_category_matching_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."retailer_gnf_category_matching_migration" IS 'This is a migration copy of retailer_gnf_category_matching';
COMMENT ON COLUMN "public"."retailer_gnf_category_matching_migration"."legacy_id" IS 'Airtable corresponding ID';
CREATE TABLE IF NOT EXISTS "public"."roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE "public"."roles" OWNER TO "postgres";
COMMENT ON TABLE "public"."roles" IS 'Roles utilized in weweb to take control of auth and segment ui components';
CREATE TABLE IF NOT EXISTS "public"."sample_shipment_tracking" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deals_id" "uuid",
    "date_sent" "date",
    "status" "public"."sample_status",
    "carrier" "public"."ship_carrier",
    "tracking_no" "text",
    "date_delivered" "date",
    "notes" "text",
    "is_archived" boolean DEFAULT false
);
ALTER TABLE "public"."sample_shipment_tracking" OWNER TO "postgres";
COMMENT ON TABLE "public"."sample_shipment_tracking" IS 'Tracks brands product samples being shipped out to accounts.';
COMMENT ON COLUMN "public"."sample_shipment_tracking"."deals_id" IS 'Links to deal activity tracker';
COMMENT ON COLUMN "public"."sample_shipment_tracking"."date_sent" IS 'Date samples here shipped';
COMMENT ON COLUMN "public"."sample_shipment_tracking"."status" IS 'Sample status';
COMMENT ON COLUMN "public"."sample_shipment_tracking"."carrier" IS 'What carrier is shipping these samples?';
CREATE TABLE IF NOT EXISTS "public"."sku_account_distribution" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "distribution_grid" "uuid" NOT NULL,
    "account" "uuid" NOT NULL,
    "item_name" "uuid" NOT NULL,
    "distributor_hq" "uuid",
    "dc_warehouse" "uuid"
);
ALTER TABLE "public"."sku_account_distribution" OWNER TO "postgres";
COMMENT ON TABLE "public"."sku_account_distribution" IS 'Hands-off internal to track SKU x account x distributor relationship';
COMMENT ON COLUMN "public"."sku_account_distribution"."distribution_grid" IS 'Links to brand_distribution_grid';
COMMENT ON COLUMN "public"."sku_account_distribution"."account" IS 'Links to accounts';
COMMENT ON COLUMN "public"."sku_account_distribution"."item_name" IS 'Links to brand distribution grid';
COMMENT ON COLUMN "public"."sku_account_distribution"."distributor_hq" IS 'Links to accounts; subset of distributor hq accounts.';
COMMENT ON COLUMN "public"."sku_account_distribution"."dc_warehouse" IS 'Links to accounts; subset of dc_warehouse accounts';
CREATE TABLE IF NOT EXISTS "public"."sku_images" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);
ALTER TABLE "public"."sku_images" OWNER TO "postgres";
COMMENT ON TABLE "public"."sku_images" IS 'Product image display for sku';
CREATE TABLE IF NOT EXISTS "public"."sku_placements" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "deal_id" "uuid",
    "sku_id" "uuid",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "brand_id" "uuid",
    "account_id" "uuid",
    "sku_status" "public"."sku_deal_status"
);
ALTER TABLE "public"."sku_placements" OWNER TO "postgres";
COMMENT ON TABLE "public"."sku_placements" IS 'Tracks which SKUs are actually placed / authorized / discontinued — independent of the deal record itself. It is a more “permanent” or historical record of what’s currently in the store.';
COMMENT ON COLUMN "public"."sku_placements"."deal_id" IS 'Links to deals';
CREATE TABLE IF NOT EXISTS "public"."sku_product_category" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "product_category" "uuid",
    "brand_product_sku" "uuid"
);
ALTER TABLE "public"."sku_product_category" OWNER TO "postgres";
COMMENT ON TABLE "public"."sku_product_category" IS 'Every skus individual tagged product category';
COMMENT ON COLUMN "public"."sku_product_category"."product_category" IS 'Links to Master Product Categories';
COMMENT ON COLUMN "public"."sku_product_category"."brand_product_sku" IS 'Links to spec and price sheet where we house all SKUs';
CREATE TABLE IF NOT EXISTS "public"."sos_authorizations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brand" "uuid",
    "program_type" "text"[] DEFAULT '{}'::"text"[],
    "program_status" "public"."program_status_type",
    "calling_month" "public"."sos_call_month",
    "calling_year" "public"."sos_calling_year",
    "region" "public"."region",
    "goodnow_input" "text",
    "program_calling_goals" "text",
    "sponsored_connects" bigint,
    "total_paid_connects_authorized" integer,
    "date_billed" "date",
    "sos_rep_assigned" "uuid",
    "calling_lists_from_vendor" "jsonb"[],
    "program" "text",
    "connects_achieved" integer,
    "placement_offering" "text",
    "sponsored_plus_total_paid_connects_sum" integer GENERATED ALWAYS AS ((COALESCE("connects_achieved", 0) + COALESCE("total_paid_connects_authorized", 0))) STORED
);
ALTER TABLE "public"."sos_authorizations" OWNER TO "postgres";
COMMENT ON TABLE "public"."sos_authorizations" IS 'Authorization the SOS team creates for the SOS program.';
COMMENT ON COLUMN "public"."sos_authorizations"."brand" IS 'Links to brands';
COMMENT ON COLUMN "public"."sos_authorizations"."region" IS 'Links to region enum';
COMMENT ON COLUMN "public"."sos_authorizations"."goodnow_input" IS 'Details about this specific campaign';
COMMENT ON COLUMN "public"."sos_authorizations"."sponsored_connects" IS 'GoodNow sponsored connects';
COMMENT ON COLUMN "public"."sos_authorizations"."sos_rep_assigned" IS 'Which SOS team member is assigned to the calling program';
COMMENT ON COLUMN "public"."sos_authorizations"."calling_lists_from_vendor" IS 'Lists that our brands give us for calling';
COMMENT ON COLUMN "public"."sos_authorizations"."program" IS 'Concat: CONCATENATE(   {Brand Name}, " - ",    {Calling Month}, " ",    {Calling Year}, " - ",    {Program Type}, " - ",   {Region}, " - ",   {Sponsored + Total Paid Connects Sum} )';
COMMENT ON COLUMN "public"."sos_authorizations"."connects_achieved" IS 'Total amount connects achieved (as defined in the connect_stage) across all callers.';
CREATE TABLE IF NOT EXISTS "public"."sos_authorizations_migration" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "brand" "uuid",
    "program_type" "text"[] DEFAULT '{}'::"text"[],
    "program_status" "public"."program_status_type",
    "calling_month" "public"."sos_call_month",
    "calling_year" "public"."sos_calling_year",
    "region" "public"."region",
    "goodnow_input" "text",
    "program_calling_goals" "text",
    "sponsored_connects" bigint,
    "total_paid_connects_authorized" integer,
    "date_billed" "date",
    "sos_rep_assigned" "uuid",
    "calling_lists_from_vendor" "jsonb"[],
    "program" "text",
    "connects_achieved" integer,
    "legacy_id" "text"
);
ALTER TABLE "public"."sos_authorizations_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."sos_authorizations_migration" IS 'This is a duplicate of sos_authorizations';
COMMENT ON COLUMN "public"."sos_authorizations_migration"."brand" IS 'Links to brands';
COMMENT ON COLUMN "public"."sos_authorizations_migration"."region" IS 'Links to region enum';
COMMENT ON COLUMN "public"."sos_authorizations_migration"."goodnow_input" IS 'Details about this specific campaign';
COMMENT ON COLUMN "public"."sos_authorizations_migration"."sponsored_connects" IS 'GoodNow sponsored connects';
COMMENT ON COLUMN "public"."sos_authorizations_migration"."sos_rep_assigned" IS 'Which SOS team member is assigned to the calling program';
COMMENT ON COLUMN "public"."sos_authorizations_migration"."calling_lists_from_vendor" IS 'Lists that our brands give us for calling';
COMMENT ON COLUMN "public"."sos_authorizations_migration"."program" IS 'Concat: CONCATENATE(   {Brand Name}, " - ",    {Calling Month}, " ",    {Calling Year}, " - ",    {Program Type}, " - ",   {Region}, " - ",   {Sponsored + Total Paid Connects Sum} )';
COMMENT ON COLUMN "public"."sos_authorizations_migration"."connects_achieved" IS 'Total amount connects achieved (as defined in the connect_stage) across all callers.';
CREATE TABLE IF NOT EXISTS "public"."spec_price_sheet_migration" (
    "description" "text",
    "item_status" "public"."item_status",
    "sales_rank" "text",
    "vendor_item_number" "text",
    "upc_12_digit" "text",
    "ean" "text",
    "case_upc" "text",
    "master_upc" "text",
    "case_pack" "text",
    "master_pack" "text",
    "unit_height_inches" "text",
    "unit_width_inches" "text",
    "unit_depth_inches" "text",
    "case_height_inches" "text",
    "case_width_inches" "text",
    "case_depth_inches" "text",
    "master_case_height_inches" "text",
    "master_case_width_inches" "text",
    "master_case_depth_inches" "text",
    "net_case_weight_lbs" "text",
    "gross_case_weight_lbs" "text",
    "master_case_weight_lbs" "text",
    "ti" "text",
    "hi" "text",
    "cube" "text",
    "cases_per_pallet" "text",
    "pallet_weight_lbs" "text",
    "item_temp_reqs" "public"."transport_enum",
    "fob_location" "text",
    "srp" "text",
    "direct_ship_available" "text",
    "direct_ship_cost_case" "text",
    "fob_price_case" "text",
    "unit_cost_fob" "text",
    "delivered_west_distribution_by_case" "text",
    "delivered_east_distribution_by_case" "text",
    "minimum_direct_order_quantity" "text",
    "minimum_order_quantity_distribution" "text",
    "order_lead_time_retailer" "text",
    "shelf_life_in_days_at_manufacture" bigint,
    "frozen_shelf_life_if_applicable" "text",
    "shelf_life_in_days_guaranteed" "text",
    "ingredient_list" "text",
    "last_modified" "text",
    "other_pricing_case" "text",
    "other_pricing_notes" "text",
    "other_pricing_unit" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "brand_id" "uuid",
    "updated_at" timestamp with time zone,
    "uos" numeric,
    "uom" "public"."uom_enum",
    "unique_item_name" "text" GENERATED ALWAYS AS ("public"."format_item_name"("description", "uos", "uom")) STORED,
    "order_lead_time_distributor" "text",
    "product_shelf_life_slacked_out" "text",
    "best_by_date_indicated" "public"."best_by_enum",
    "organic_certifier_entity" "text",
    "organic" "public"."specs_certification_options",
    "non_gmo" "public"."specs_certification_options",
    "gluten_free" "public"."specs_certification_options",
    "vegan" "public"."specs_certification_options",
    "vegetarian" "public"."specs_certification_options",
    "kosher" "public"."specs_certification_options",
    "dairy_free" "public"."specs_certification_options",
    "sugar_free" "public"."specs_certification_options",
    "soy_free" "public"."specs_certification_options",
    "nut_free" "public"."specs_certification_options",
    "wheat_free" "public"."specs_certification_options",
    "legacy_id" "text",
    CONSTRAINT "spec_price_sheet_upc_12_digit_check" CHECK (("length"("upc_12_digit") <= 12))
);
ALTER TABLE "public"."spec_price_sheet_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."spec_price_sheet_migration" IS 'This is a duplicate of spec_price_sheet';
COMMENT ON COLUMN "public"."spec_price_sheet_migration"."upc_12_digit" IS 'still need to add a constraint --> CHECK (LENGTH(upc_12_digit) <= 12)';
COMMENT ON COLUMN "public"."spec_price_sheet_migration"."item_temp_reqs" IS 'need to go over enums here (rename and update fields)';
COMMENT ON COLUMN "public"."spec_price_sheet_migration"."unit_cost_fob" IS 'have a auto computation trigger to fill this --> fob_price_case/case_pack';
COMMENT ON COLUMN "public"."spec_price_sheet_migration"."shelf_life_in_days_guaranteed" IS 'Must be at least 70% of Shelf Life at Manufacture';
COMMENT ON COLUMN "public"."spec_price_sheet_migration"."organic_certifier_entity" IS 'list out the third party certification';
CREATE TABLE IF NOT EXISTS "public"."stat_card_table" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);
ALTER TABLE "public"."stat_card_table" OWNER TO "postgres";
COMMENT ON TABLE "public"."stat_card_table" IS 'Stores calculations for stat cards on app';
ALTER TABLE "public"."stat_card_table" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."stat_card_table_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE OR REPLACE VIEW "public"."summarized_deadlines_for_calendar" AS
 SELECT "to_char"(("mcrd"."new_item_submission_deadline")::timestamp with time zone, 'YYYY-MM-DD'::"text") AS "grouped_event_id",
    "mcrd"."new_item_submission_deadline" AS "event_date",
    "count"("mcrd"."id") AS "item_count",
    'Deadlines'::"text" AS "display_title",
    "jsonb_agg"("jsonb_build_object"('id', "mcrd"."id", 'display_name', "mcrd"."display_name", 'account_uuid', "mcrd"."account", 'retailer_category', "mcrd"."retailer_category", 'retailer_review_timing', "mcrd"."retailer_review_timing", 'reset_date', "mcrd"."reset_date", 'review_type', "mcrd"."review_type", 'retailer_review_date', "mcrd"."retailer_review_date", 'on_shelf_reset_date', "mcrd"."on_shelf_reset_date", 'new_item_submission_deadline', "mcrd"."new_item_submission_deadline", 'master_category_id', "mcrd"."master_category_id", 'created_at', "mcrd"."created_at", 'updated_at', "mcrd"."updated_at", 'archive', "mcrd"."archive", 'gnf_sub_category_uuid', "mcrd"."gnf_sub_category") ORDER BY "mcrd"."display_name") AS "daily_deadlines_details"
   FROM "public"."master_category_review_data" "mcrd"
  WHERE ("mcrd"."new_item_submission_deadline" IS NOT NULL)
  GROUP BY "mcrd"."new_item_submission_deadline"
  ORDER BY "mcrd"."new_item_submission_deadline";
ALTER TABLE "public"."summarized_deadlines_for_calendar" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."syncup_notes" (
    "team_member" "uuid",
    "note" "text" NOT NULL,
    "sync_date" timestamp with time zone,
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text"),
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user" "uuid"
);
ALTER TABLE "public"."syncup_notes" OWNER TO "postgres";
COMMENT ON TABLE "public"."syncup_notes" IS 'Utilized for creating sync-up notes between team members';
CREATE TABLE IF NOT EXISTS "public"."task_pipeline" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "task_title" "text" NOT NULL,
    "notes" "text",
    "task_type" "public"."task_type_enum" NOT NULL,
    "status" "public"."kanban_status_enum",
    "brand_id" "uuid",
    "account_id" "uuid",
    "category_review_id" "uuid",
    "created_by" "uuid",
    "due_date" "date",
    "priority" "public"."priority_enum" DEFAULT 'Medium'::"public"."priority_enum",
    "is_completed" boolean DEFAULT false,
    "completed_at" timestamp with time zone,
    "is_automated" boolean DEFAULT false,
    "source_type" "public"."source_type_enum" DEFAULT 'manual'::"public"."source_type_enum",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."task_pipeline" OWNER TO "postgres";
COMMENT ON TABLE "public"."task_pipeline" IS 'The activity pipeline for all the team members';
CREATE TABLE IF NOT EXISTS "public"."team_member_dept" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "dept_name" character varying,
    "dept_code" character varying
);
ALTER TABLE "public"."team_member_dept" OWNER TO "postgres";
COMMENT ON COLUMN "public"."team_member_dept"."dept_code" IS 'Code to be used for roles, etc.';
CREATE TABLE IF NOT EXISTS "public"."team_member_guide_migration" (
    "name" "text" NOT NULL,
    "status" "public"."employee_status_enum",
    "title" "text",
    "address" "text",
    "phone_number" "text",
    "department" "public"."Departments"[],
    "send_samples" "text",
    "food_handlers_card" "text",
    "calls_counted_by_team_member" "text",
    "counter" "text",
    "email" "text",
    "uuid" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "profile_photo" "text",
    "key_accounts" "text"[],
    "regional_coverage" "text"[],
    "time_zone" "text",
    "country_of_origin" "text",
    "language_spoken" "text"[],
    "user_id" "uuid",
    "brand_id" "uuid",
    "legacy_id" "text" DEFAULT ''::"text"
);
ALTER TABLE "public"."team_member_guide_migration" OWNER TO "postgres";
COMMENT ON TABLE "public"."team_member_guide_migration" IS 'This is a duplicate of team_member_guide';
COMMENT ON COLUMN "public"."team_member_guide_migration"."key_accounts" IS 'Top key accounts for each team member';
COMMENT ON COLUMN "public"."team_member_guide_migration"."regional_coverage" IS 'Regions the sales team covers';
COMMENT ON COLUMN "public"."team_member_guide_migration"."time_zone" IS 'Team members time zone';
COMMENT ON COLUMN "public"."team_member_guide_migration"."country_of_origin" IS 'Where the team member resides';
CREATE TABLE IF NOT EXISTS "public"."test_brand_directory" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "brand_name" "text",
    "manufacturer_name" "text",
    "target_market_channels" "text"[],
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."test_brand_directory" OWNER TO "postgres";
CREATE TABLE IF NOT EXISTS "public"."users_roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "role_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE "public"."users_roles" OWNER TO "postgres";
COMMENT ON TABLE "public"."users_roles" IS 'Junction Table auth.users and public.roles';
CREATE OR REPLACE VIEW "public"."v_active_submission_opportunities" AS
 SELECT "mc"."category" AS "gn_category",
    "mc"."full_category" AS "gn_full_category",
    "a"."account" AS "retailer_name",
    "rgcm"."retailer_category_name",
    "mcrd"."new_item_submission_deadline",
    "mcrd"."review_type",
    "mcrd"."retailer_review_timing",
    "mcrd"."display_name" AS "review_name",
    ("mcrd"."new_item_submission_deadline" - CURRENT_DATE) AS "days_until_deadline",
    "mc"."id" AS "gn_category_id",
    "mcrd"."id" AS "review_data_id"
   FROM ((((("public"."master_categories" "mc"
     JOIN "public"."jt_retailer_category_to_gn_categories" "jt" ON (("mc"."id" = "jt"."gn_category_id")))
     JOIN "public"."retailer_gnf_category_matching" "rgcm" ON (("jt"."retailer_category_id" = "rgcm"."id")))
     JOIN "public"."accounts" "a" ON (("rgcm"."account" = "a"."uuid")))
     JOIN "public"."jt_master_category_review_data_matching" "jtrdm" ON (("rgcm"."id" = "jtrdm"."retailer_matching_id")))
     JOIN "public"."master_category_review_data" "mcrd" ON (("jtrdm"."review_data_id" = "mcrd"."id")))
  WHERE ("mcrd"."new_item_submission_deadline" > CURRENT_DATE)
  ORDER BY "mcrd"."new_item_submission_deadline", "mc"."category", "a"."account";
ALTER TABLE "public"."v_active_submission_opportunities" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_activity_comments_with_profile" WITH ("security_invoker"='on') AS
 SELECT "c"."id" AS "comment_id",
    "c"."comment_text" AS "content",
    "c"."created_at",
    "c"."deal_id" AS "activity_id",
    "c"."user_id",
    COALESCE("tmg"."email", 'Anonymous User'::"text") AS "username",
    COALESCE("tmg"."profile_photo", 'default_profile_photo.png'::"text") AS "profile_photo",
    "tmg"."name" AS "full_name"
   FROM ("public"."deal_activity_comments" "c"
     LEFT JOIN "public"."team_member_guide" "tmg" ON (("c"."user_id" = "tmg"."user_id")));
ALTER TABLE "public"."v_activity_comments_with_profile" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_brand_contacts" AS
 SELECT "c"."uuid",
    "c"."created_at",
    "c"."first_name",
    "c"."last_name",
    "c"."email",
    "c"."title",
    "c"."phone",
    "c"."contact_tags",
    "c"."receive_company_updates",
    "c"."company" AS "brand_id",
    "b"."brand" AS "brand_name"
   FROM ("public"."brand_contacts_table" "c"
     LEFT JOIN "public"."brands" "b" ON (("c"."company" = "b"."id")));
ALTER TABLE "public"."v_brand_contacts" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_brand_distribution_grid" AS
 SELECT "bdg"."id" AS "grid_id",
    "bdg"."item_code",
    "bdg"."distribution_status",
    "bdg"."distribution_notes",
    "bdg"."brand_id",
    "b"."brand",
    "bdg"."item_name" AS "item_spec_id",
    "sps"."unique_item_name" AS "spec_item_name",
    "bdg"."distributor_hq" AS "distributor_hq_id",
    "dist_acc"."account" AS "distributor_hq_name",
    "dist_acc"."primary_region" AS "distributor_region",
    "bdg"."warehouse_dc" AS "warehouse_dc_id",
    "wh_acc"."account" AS "warehouse_dc_name",
    "bdg"."updated_at" AS "last_updated",
    "bdg"."updated_by"
   FROM (((("public"."brand_distribution_grid" "bdg"
     LEFT JOIN "public"."brands" "b" ON (("bdg"."brand_id" = "b"."id")))
     LEFT JOIN "public"."spec_price_sheet" "sps" ON (("bdg"."item_name" = "sps"."id")))
     LEFT JOIN "public"."accounts" "dist_acc" ON (("bdg"."distributor_hq" = "dist_acc"."uuid")))
     LEFT JOIN "public"."accounts" "wh_acc" ON (("bdg"."warehouse_dc" = "wh_acc"."uuid")));
ALTER TABLE "public"."v_brand_distribution_grid" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_brand_promo_requests_with_skus" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::timestamp with time zone AS "created_at",
    NULL::"uuid" AS "brand_id",
    NULL::"uuid" AS "retailer_id",
    NULL::"uuid" AS "distributor_id",
    NULL::"text" AS "promo_type_brand_facing",
    NULL::"public"."Effective Promo Month" AS "effective_promo_month",
    NULL::"public"."Promo Year" AS "effective_promo_year",
    NULL::"public"."promo_submissinon_status" AS "submission_status",
    NULL::"public"."brand_promo_approval (delete)" AS "brand_approval",
    NULL::"json" AS "skus",
    NULL::bigint AS "sku_count";
ALTER TABLE "public"."v_brand_promo_requests_with_skus" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_brand_promotions_with_skus" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::timestamp with time zone AS "created_at",
    NULL::"uuid" AS "brand",
    NULL::"uuid" AS "master_promo_id",
    NULL::"uuid" AS "retailer_id",
    NULL::"uuid" AS "distribution_id",
    NULL::"public"."Quarter" AS "promo_quarter",
    NULL::"public"."promo_submissinon_status" AS "submission_status",
    NULL::"public"."brand_promo_approval (delete)" AS "brand_approval",
    NULL::"text" AS "submission_notes",
    NULL::"text" AS "brand_comments",
    NULL::"jsonb" AS "submitted_promo_contracts",
    NULL::"json" AS "skus";
ALTER TABLE "public"."v_brand_promotions_with_skus" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_brand_submission_guide" AS
 SELECT "mc"."category" AS "gn_category",
    "mc"."subcategory" AS "gn_subcategory",
    "mc"."full_category" AS "gn_full_category",
    "count"(DISTINCT "a"."uuid") AS "total_retailers",
    "array_agg"(DISTINCT "a"."account" ORDER BY "a"."account") FILTER (WHERE ("a"."account" IS NOT NULL)) AS "retailer_names",
    "array_agg"(DISTINCT "rgcm"."retailer_category_name" ORDER BY "rgcm"."retailer_category_name") FILTER (WHERE ("rgcm"."retailer_category_name" IS NOT NULL)) AS "retailer_category_names",
    "min"("mcrd"."new_item_submission_deadline") AS "next_deadline",
    "count"(
        CASE
            WHEN ("mcrd"."new_item_submission_deadline" > CURRENT_DATE) THEN 1
            ELSE NULL::integer
        END) AS "upcoming_deadlines",
    "mc"."id" AS "gn_category_id"
   FROM ((((("public"."master_categories" "mc"
     LEFT JOIN "public"."jt_retailer_category_to_gn_categories" "jt" ON (("mc"."id" = "jt"."gn_category_id")))
     LEFT JOIN "public"."retailer_gnf_category_matching" "rgcm" ON (("jt"."retailer_category_id" = "rgcm"."id")))
     LEFT JOIN "public"."accounts" "a" ON (("rgcm"."account" = "a"."uuid")))
     LEFT JOIN "public"."jt_master_category_review_data_matching" "jtrdm" ON (("rgcm"."id" = "jtrdm"."retailer_matching_id")))
     LEFT JOIN "public"."master_category_review_data" "mcrd" ON (("jtrdm"."review_data_id" = "mcrd"."id")))
  GROUP BY "mc"."id", "mc"."category", "mc"."subcategory", "mc"."full_category";
ALTER TABLE "public"."v_brand_submission_guide" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_brands_focus" WITH ("security_invoker"='on') AS
 SELECT "bfa"."id" AS "assignment_id",
    "b"."brand" AS "brand_name",
    "b"."coverage",
    "tmg"."name" AS "team_member_name",
    "tmg"."profile_photo",
    "bfa"."focus_month",
    "bfa"."Notes" AS "notes",
    "bfa"."created_at"
   FROM (("public"."brand_focus_assignments" "bfa"
     JOIN "public"."brands" "b" ON (("bfa"."brand" = "b"."id")))
     JOIN "public"."team_member_guide" "tmg" ON (("bfa"."team_member" = "tmg"."uuid")))
  WHERE ('GoodNow'::"public"."Active Services" = ANY ("b"."services"));
ALTER TABLE "public"."v_brands_focus" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_brands_needing_attention" AS
 SELECT "brands"."brand",
    "brands"."attention_flags"
   FROM "public"."brands"
  WHERE ("brands"."attention_flags" IS NOT NULL);
ALTER TABLE "public"."v_brands_needing_attention" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_brands_view" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::"text" AS "brand",
    NULL::"text" AS "manufacturer_name",
    NULL::"public"."Principal List Status" AS "principal_list_status",
    NULL::"public"."Brand Status"[] AS "status",
    NULL::"public"."Active Services"[] AS "services",
    NULL::"public"."Coverage"[] AS "coverage",
    NULL::"date" AS "start_date",
    NULL::"date" AS "last_date",
    NULL::"date" AS "sos_start_date",
    NULL::"date" AS "demo_start_date",
    NULL::"text" AS "headquarters_address",
    NULL::"text" AS "mailing_address_if_different",
    NULL::"text" AS "free_fill_placement_authorization",
    NULL::"text" AS "samples_policy_and_request_process",
    NULL::"text" AS "mission_components",
    NULL::"text" AS "overall_brand_goals",
    NULL::integer AS "demos_included_quarterly",
    NULL::numeric(10,2) AS "sos_calls_included_monthly",
    NULL::numeric(10,2) AS "sos_sales_rate",
    NULL::"text" AS "referred_by",
    NULL::"text" AS "product_pickup_address",
    NULL::"text" AS "product_summary",
    NULL::numeric(10,2) AS "se___current_month",
    NULL::"text" AS "invoice_timing",
    NULL::"text" AS "billing_notes",
    NULL::"text" AS "tax_id_number",
    NULL::"public"."sales_channel"[] AS "private_label_bulk_and__or_food_service",
    NULL::"text" AS "describe_any_capabilities_from_the_selection_above",
    NULL::"text" AS "order_lead_time",
    NULL::"text" AS "full_reclamation_or_spoils_allowance",
    NULL::"text" AS "brand_certifications",
    NULL::"text" AS "capacity_or_production_restrictions",
    NULL::"text" AS "direct_order_details_process",
    NULL::"text" AS "marketing_descriptions",
    NULL::"text" AS "email_pitch_descriptor",
    NULL::"text" AS "are_you_a_member_of_any_trade_organizations",
    NULL::"text" AS "product_attributes",
    NULL::"text" AS "onboarding_notes",
    NULL::"text" AS "company_website",
    NULL::"text" AS "cancellation_reasons",
    NULL::numeric(10,2) AS "se___next_month",
    NULL::"text"[] AS "brand_contracts",
    NULL::"text" AS "follow_up_email_draft",
    NULL::"public"."category_enum (deprecated?)"[] AS "category_for_principal_list",
    NULL::"public"."product_subcategory_enum (principal list)"[] AS "product_sub_category_for_principal_list",
    NULL::boolean AS "new_item",
    NULL::"jsonb"[] AS "product_images",
    NULL::"public"."attention_flag_enum"[] AS "attention_flags",
    NULL::"text" AS "brand_logo",
    NULL::"text" AS "other_active_brokerage_service_coverage",
    NULL::"public"."Demo_special_customer_enum" AS "demo_customer_type",
    NULL::"text" AS "faire_link",
    NULL::"text" AS "mable_link",
    NULL::"text" AS "airgoods_link",
    NULL::"text" AS "other_link",
    NULL::"text" AS "pod_foods_link",
    NULL::"jsonb" AS "principal_list_images",
    NULL::"jsonb" AS "master_categories";
ALTER TABLE "public"."v_brands_view" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_categories_with_brands" AS
 SELECT "mc"."id" AS "category_id",
    "mc"."category",
    "mc"."subcategory",
    "mc"."full_category",
    "mc"."notes" AS "category_notes",
    "b"."id" AS "brand_id",
    "b"."brand" AS "brand_name",
    "b"."manufacturer_name",
    "b"."product_summary" AS "brand_description",
    "jt"."created_at" AS "relationship_created_at"
   FROM (("public"."master_categories" "mc"
     LEFT JOIN "public"."jt_master_categories_brands" "jt" ON (("mc"."id" = "jt"."master_category_id")))
     LEFT JOIN "public"."brands" "b" ON (("jt"."brand_id" = "b"."id")));
ALTER TABLE "public"."v_categories_with_brands" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_category_review_calendar_data" AS
 SELECT "mcrd"."id" AS "review_data_id",
    "mcrd"."display_name" AS "review_name",
    "mcrd"."retailer_category",
    "mcrd"."review_type",
    "mcrd"."new_item_submission_deadline",
    "a"."account" AS "account_name"
   FROM (("public"."master_category_review_data" "mcrd"
     LEFT JOIN "public"."accounts" "a" ON (("mcrd"."account" = "a"."uuid")))
     LEFT JOIN "public"."jt_master_category_review_data_brands" "jt" ON (("mcrd"."id" = "jt"."review_data_id")));
ALTER TABLE "public"."v_category_review_calendar_data" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_category_review_data" AS
 SELECT "mcrd"."id",
    "mcrd"."display_name",
    "mcrd"."account",
    "mcrd"."retailer_category",
    "mcrd"."retailer_review_timing",
    "mcrd"."reset_date",
    "mcrd"."review_type",
    "mcrd"."retailer_review_date",
    "mcrd"."on_shelf_reset_date",
    "mcrd"."new_item_submission_deadline",
    "mcrd"."master_category_id",
    "mcrd"."created_at",
    "mcrd"."updated_at",
    "mcrd"."archive",
    "mcrd"."gnf_sub_category",
    "mcrd"."category_specific_review_notes" AS "category_notes",
    "a"."account" AS "account_name",
    ( SELECT "array_agg"(DISTINCT "jatm"."team_member_uuid") AS "array_agg"
           FROM "public"."jt_accounts_team_member_guide" "jatm"
          WHERE ("jatm"."account_uuid" = "mcrd"."account")) AS "account_manager_ids",
    ( SELECT "array_agg"(DISTINCT "jatm"."team_member_name") AS "array_agg"
           FROM "public"."jt_accounts_team_member_guide" "jatm"
          WHERE ("jatm"."account_uuid" = "mcrd"."account")) AS "account_manager_names",
    "mc"."subcategory" AS "gnf_sub_category_name",
    ( SELECT "array_agg"("jb"."brand_id") AS "array_agg"
           FROM "public"."jt_master_category_review_data_brands" "jb"
          WHERE ("jb"."review_data_id" = "mcrd"."id")) AS "brand_ids"
   FROM (("public"."master_category_review_data" "mcrd"
     LEFT JOIN "public"."accounts" "a" ON (("mcrd"."account" = "a"."uuid")))
     LEFT JOIN "public"."master_categories" "mc" ON (("mcrd"."gnf_sub_category" = "mc"."id")));
ALTER TABLE "public"."v_category_review_data" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_category_review_summary" AS
 SELECT "a"."account" AS "account_name",
    "count"(DISTINCT "mcrd"."id") AS "total_review_records",
    "count"(DISTINCT "rgcm"."id") AS "total_category_mappings",
    "count"(DISTINCT "jtb"."brand_id") AS "total_brands_in_reviews",
    "count"(
        CASE
            WHEN ("mcrd"."new_item_submission_deadline" > CURRENT_DATE) THEN 1
            ELSE NULL::integer
        END) AS "upcoming_deadlines",
    "min"("mcrd"."new_item_submission_deadline") AS "next_deadline",
    "max"("mcrd"."updated_at") AS "last_updated"
   FROM ((("public"."accounts" "a"
     LEFT JOIN "public"."master_category_review_data" "mcrd" ON (("a"."uuid" = "mcrd"."account")))
     LEFT JOIN "public"."retailer_gnf_category_matching" "rgcm" ON (("a"."uuid" = "rgcm"."account")))
     LEFT JOIN "public"."jt_master_category_review_data_brands" "jtb" ON (("mcrd"."id" = "jtb"."review_data_id")))
  GROUP BY "a"."uuid", "a"."account"
  ORDER BY "a"."account";
ALTER TABLE "public"."v_category_review_summary" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_category_reviews_with_matching_brands" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::"text" AS "display_name",
    NULL::"uuid" AS "account",
    NULL::"text" AS "retailer_category",
    NULL::"text" AS "retailer_review_timing",
    NULL::"date" AS "reset_date",
    NULL::"text" AS "review_type",
    NULL::"date" AS "retailer_review_date",
    NULL::"date" AS "on_shelf_reset_date",
    NULL::"date" AS "new_item_submission_deadline",
    NULL::"uuid" AS "master_category_id",
    NULL::timestamp with time zone AS "created_at",
    NULL::timestamp with time zone AS "updated_at",
    NULL::boolean AS "archive",
    NULL::"uuid" AS "gnf_sub_category",
    NULL::"text" AS "category_specific_review_notes",
    NULL::boolean AS "category_removal_status",
    NULL::"uuid" AS "cr_review_type",
    NULL::"jsonb" AS "matched_brands";
ALTER TABLE "public"."v_category_reviews_with_matching_brands" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_comments_with_author_details" AS
 SELECT "dac"."id",
    "dac"."deal_id",
    "dac"."user_id",
    "dac"."comment_text",
    "dac"."created_at",
    COALESCE(
        CASE
            WHEN ("r_sub"."name" = ANY (ARRAY['internal'::"text", 'admin'::"text", 'manager'::"text"])) THEN "tmg"."name"
            ELSE NULL::"text"
        END, "pu"."name") AS "author_name",
        CASE
            WHEN ("r_sub"."name" = ANY (ARRAY['internal'::"text", 'admin'::"text", 'manager'::"text"])) THEN "tmg"."profile_photo"
            ELSE NULL::"text"
        END AS "author_profile_photo",
    "r_sub"."name" AS "author_role_name"
   FROM ((("public"."deal_activity_comments" "dac"
     JOIN "public"."profiles" "pu" ON (("dac"."user_id" = "pu"."id")))
     LEFT JOIN ( SELECT DISTINCT ON ("ur_inner"."user_id") "ur_inner"."user_id",
            "r_inner"."name"
           FROM ("public"."users_roles" "ur_inner"
             JOIN "public"."roles" "r_inner" ON (("ur_inner"."role_id" = "r_inner"."id")))
          ORDER BY "ur_inner"."user_id",
                CASE "r_inner"."name"
                    WHEN 'admin'::"text" THEN 1
                    WHEN 'manager'::"text" THEN 2
                    WHEN 'internal'::"text" THEN 3
                    ELSE 99
                END) "r_sub" ON (("pu"."id" = "r_sub"."user_id")))
     LEFT JOIN "public"."team_member_guide" "tmg" ON ((("pu"."id" = "tmg"."uuid") AND ("r_sub"."name" = ANY (ARRAY['internal'::"text", 'admin'::"text", 'manager'::"text"])))));
ALTER TABLE "public"."v_comments_with_author_details" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_completed_demos" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::"date" AS "demo_date",
    NULL::"date" AS "date_submitted",
    NULL::"public"."demo_status_enum" AS "demo_status",
    NULL::time without time zone AS "start_time",
    NULL::time without time zone AS "end_time",
    NULL::interval AS "time_range",
    NULL::"uuid" AS "account_id",
    NULL::"uuid" AS "team_member_id",
    NULL::"text" AS "store_poc",
    NULL::numeric(10,2) AS "demo_fee",
    NULL::"text" AS "date_billed",
    NULL::numeric(10,2) AS "other_fees",
    NULL::"text" AS "billing_notes",
    NULL::"text" AS "notes",
    NULL::integer AS "store_busy_rating",
    NULL::numeric(10,2) AS "price_on_shelf",
    NULL::integer AS "units_before",
    NULL::integer AS "units_after",
    NULL::integer AS "units_sampled",
    NULL::integer AS "avg_samples_given",
    NULL::integer AS "total_units_sold",
    NULL::"text" AS "demo_feedback",
    NULL::numeric(4,2) AS "demo_hours",
    NULL::numeric(4,2) AS "training_hours",
    NULL::numeric(4,2) AS "merchandising_hours",
    NULL::numeric(4,2) AS "other_hours",
    NULL::numeric(4,2) AS "total_hours",
    NULL::timestamp with time zone AS "created_at",
    NULL::timestamp with time zone AS "updated_at",
    NULL::"jsonb" AS "demo_images",
    NULL::"jsonb" AS "demo_receipts",
    NULL::"public"."demo_request_type_enum" AS "demo_request_type",
    NULL::"text" AS "requested_timing",
    NULL::"text"[] AS "store_names",
    NULL::"jsonb" AS "retailer_fees",
    NULL::"jsonb" AS "check_in_photo",
    NULL::boolean AS "check_in_status",
    NULL::boolean AS "nwg_demo",
    NULL::"text" AS "notes_to_demo_team",
    NULL::boolean AS "time_off_requested",
    NULL::timestamp with time zone AS "time_off_request_date",
    NULL::"text" AS "time_off_notes",
    NULL::"text" AS "event_color",
    NULL::"text" AS "demo_name",
    NULL::"text" AS "demo_team_member",
    NULL::"text" AS "profile_photo",
    NULL::"text" AS "brand_customer_types",
    NULL::"text" AS "account",
    NULL::bigint AS "gnf_priority",
    NULL::"text" AS "store_address",
    NULL::"text" AS "store_city",
    NULL::"public"."states_enum" AS "store_state",
    NULL::"text" AS "store_zip",
    NULL::"public"."Country" AS "country",
    NULL::"text" AS "store_phone_number",
    NULL::"text" AS "website",
    NULL::"text" AS "account_description",
    NULL::"text" AS "account_notes",
    NULL::"uuid" AS "account_uuid",
    NULL::timestamp with time zone AS "account_last_updated",
    NULL::"jsonb" AS "brand_details",
    NULL::"text" AS "brand_names_list";
ALTER TABLE "public"."v_completed_demos" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_daily_team_connects" AS
 SELECT ("date_trunc"('day'::"text", "at"."sos_call_date"))::"date" AS "call_date",
    "tm"."name" AS "team_member",
    "sum"(COALESCE("at"."connect_count", 0)) AS "connects",
    "max"("at"."sos_call_date") AS "last_updated"
   FROM ("public"."activity_tracker" "at"
     JOIN "public"."team_member_guide" "tm" ON (("at"."sos_call_team" = "tm"."uuid")))
  WHERE (("at"."connect_stage")::"text" ~~* 'Connect%'::"text")
  GROUP BY (("date_trunc"('day'::"text", "at"."sos_call_date"))::"date"), "tm"."name";
ALTER TABLE "public"."v_daily_team_connects" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_dashboard_summary" AS
 SELECT ( SELECT "jsonb_build_object"('pipeline_items', ( SELECT "count"(*) AS "count"
                   FROM "public"."v_task_pipeline_with_assignees"
                  WHERE ("v_task_pipeline_with_assignees"."is_completed" = false)), 'planned_submissions', ( SELECT "count"(*) AS "count"
                   FROM "public"."planned_submissions"), 'sync_calls', ( SELECT "count"(*) AS "count"
                   FROM "public"."brand_sync_call_schedule"
                  WHERE ("brand_sync_call_schedule"."sync_date" = CURRENT_DATE))) AS "jsonb_build_object") AS "counts",
    ( SELECT "jsonb_build_object"('review_name', "v_brand_matching"."review_name", 'deadline', "v_brand_matching"."new_item_submission_deadline", 'managers', "v_brand_matching"."category_managers", 'brands', "v_brand_matching"."linked_brands_array", 'count', "v_brand_matching"."linked_brands_count") AS "jsonb_build_object"
           FROM "public"."v_brand_matching"
          WHERE (("v_brand_matching"."new_item_submission_deadline" IS NOT NULL) AND ("v_brand_matching"."new_item_submission_deadline" >= CURRENT_DATE))
          ORDER BY "v_brand_matching"."new_item_submission_deadline"
         LIMIT 1) AS "next_review",
    ( SELECT "row_to_json"("e".*) AS "row_to_json"
           FROM ( SELECT "events_detailed_view"."id",
                    "events_detailed_view"."event_name",
                    "events_detailed_view"."event_year",
                    "events_detailed_view"."event_dates",
                    "events_detailed_view"."event_tags",
                    "events_detailed_view"."location",
                    "events_detailed_view"."website",
                    "events_detailed_view"."notes",
                    "events_detailed_view"."event_forms",
                    "events_detailed_view"."event_dispay_image",
                    "events_detailed_view"."event_description",
                    "events_detailed_view"."goodnow_participation",
                    "events_detailed_view"."booth_number",
                    "events_detailed_view"."accommodations",
                    "events_detailed_view"."event_display_name",
                    "events_detailed_view"."internal_event_planning_forms",
                    "events_detailed_view"."start_date",
                    "events_detailed_view"."end_date",
                    "events_detailed_view"."attending_brands",
                    "events_detailed_view"."attending_team"
                   FROM "public"."events_detailed_view"
                  WHERE ("events_detailed_view"."start_date" >= CURRENT_DATE)
                  ORDER BY "events_detailed_view"."start_date"
                 LIMIT 1) "e") AS "next_event",
    ( SELECT "row_to_json"("a".*) AS "row_to_json"
           FROM ( SELECT "company_announcements"."id",
                    "company_announcements"."created_at",
                    "company_announcements"."announcement",
                    "company_announcements"."image",
                    "company_announcements"."audience",
                    "company_announcements"."archive",
                    "company_announcements"."announcement_tags",
                    "company_announcements"."announcement_date",
                    "company_announcements"."announcement_title",
                    "company_announcements"."publish"
                   FROM "public"."company_announcements"
                  WHERE (("company_announcements"."announcement_date" >= CURRENT_DATE) AND ("company_announcements"."publish" IS TRUE) AND ("company_announcements"."archive" IS NOT TRUE))
                  ORDER BY "company_announcements"."announcement_date"
                 LIMIT 1) "a") AS "next_announcement",
    ( SELECT "jsonb_build_object"('submission_id', "ps"."id", 'planned_date', "ps"."planned_submission_date", 'submission_status', "ps"."submission_status", 'review_name', "mcrd"."display_name", 'brand_name', "b"."brand", 'brand_logo', "b"."brand_logo", 'deal_name', "at"."activity_name") AS "jsonb_build_object"
           FROM ((("public"."planned_submissions" "ps"
             LEFT JOIN "public"."master_category_review_data" "mcrd" ON (("ps"."category_review" = "mcrd"."id")))
             LEFT JOIN "public"."activity_tracker" "at" ON (("ps"."deal_id" = "at"."id")))
             LEFT JOIN "public"."brands" "b" ON (("at"."brand" = "b"."id")))
          WHERE (("ps"."planned_submission_date" >= CURRENT_DATE) AND (("ps"."submission_status" IS FALSE) OR ("ps"."submission_status" IS NULL)))
          ORDER BY "ps"."planned_submission_date"
         LIMIT 1) AS "next_planned_submission";
ALTER TABLE "public"."v_dashboard_summary" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_deal_distribution" AS
 SELECT "jtd"."id" AS "deal_distribution_id",
    "jtd"."created_at" AS "deal_distribution_created_at",
    "jtd"."deal_id",
    "jaadg"."account_id" AS "active_account_id",
    "acc"."account" AS "active_account_name",
    "jaadg"."distribution_grid_id",
    "bdg"."distribution_status",
    "bdg"."id" AS "brand_distribution_grid_id",
    "bdg"."brand_id",
    "b"."brand" AS "brand_name",
    "bdg"."distributor_hq",
    "dist_acc"."account" AS "distributor_hq_name",
    "bdg"."warehouse_dc",
    "wh_acc"."account" AS "warehouse_dc_name",
    "bdg"."item_name" AS "spec_price_sheet_id",
    "sps"."description" AS "item_description"
   FROM (((((((("public"."jt_deal_distribution" "jtd"
     LEFT JOIN "public"."activity_tracker" "at" ON (("jtd"."deal_id" = "at"."id")))
     LEFT JOIN "public"."jt_active_account_distribution_grid" "jaadg" ON (("jtd"."distribution_id" = "jaadg"."id")))
     LEFT JOIN "public"."accounts" "acc" ON (("jaadg"."account_id" = "acc"."uuid")))
     LEFT JOIN "public"."brand_distribution_grid" "bdg" ON (("jaadg"."distribution_grid_id" = "bdg"."id")))
     LEFT JOIN "public"."brands" "b" ON (("bdg"."brand_id" = "b"."id")))
     LEFT JOIN "public"."accounts" "dist_acc" ON (("bdg"."distributor_hq" = "dist_acc"."uuid")))
     LEFT JOIN "public"."accounts" "wh_acc" ON (("bdg"."warehouse_dc" = "wh_acc"."uuid")))
     LEFT JOIN "public"."spec_price_sheet" "sps" ON (("bdg"."item_name" = "sps"."id")));
ALTER TABLE "public"."v_deal_distribution" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_deal_stage_history" AS
 SELECT "h"."id" AS "history_id",
    "h"."activity_id",
    "h"."old_deal_stage_ref",
    "old_stage"."name" AS "old_deal_stage_name",
    "old_stage"."color" AS "old_deal_stage_color",
    "h"."new_deal_stage_ref",
    "new_stage"."name" AS "new_deal_stage_name",
    "new_stage"."color" AS "new_deal_stage_color",
    "h"."activity_notes",
    "h"."changed_at",
    "h"."changed_by" AS "user_id",
    "tmg"."name",
    "tmg"."profile_photo"
   FROM ((("public"."deal_stage_history" "h"
     LEFT JOIN "public"."team_member_guide" "tmg" ON (("h"."changed_by" = "tmg"."uuid")))
     LEFT JOIN "public"."ref_deal_stage" "old_stage" ON (("h"."old_deal_stage_ref" = "old_stage"."uuid")))
     LEFT JOIN "public"."ref_deal_stage" "new_stage" ON (("h"."new_deal_stage_ref" = "new_stage"."uuid")));
ALTER TABLE "public"."v_deal_stage_history" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_demo_calendar" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::"uuid" AS "account_id",
    NULL::"uuid" AS "team_member_id",
    NULL::"text" AS "event_color",
    NULL::"text" AS "demo_name",
    NULL::"date" AS "demo_date",
    NULL::time without time zone AS "start_time",
    NULL::time without time zone AS "end_time",
    NULL::"text" AS "formatted_time_range",
    NULL::"public"."demo_status_enum" AS "demo_status",
    NULL::"text" AS "brands",
    NULL::"text" AS "store_name",
    NULL::"text" AS "demo_team_member",
    NULL::"text" AS "team_member_email",
    NULL::"text" AS "phone_number",
    NULL::"text" AS "address",
    NULL::boolean AS "time_off_requested",
    NULL::timestamp with time zone AS "time_off_request_date",
    NULL::"text" AS "time_off_notes",
    NULL::"public"."demo_request_type_enum" AS "demo_request_type",
    NULL::"text" AS "requested_timing",
    NULL::"text" AS "notes_to_demo_team",
    NULL::"text" AS "notes",
    NULL::timestamp with time zone AS "created_at";
ALTER TABLE "public"."v_demo_calendar" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_demo_check_ins" AS
 SELECT "d"."id",
    COALESCE((((("string_agg"("b"."brand", ' + '::"text") || ' - '::"text") || "a"."account") || ' - '::"text") || "to_char"(("d"."demo_date")::timestamp with time zone, 'MM/DD/YYYY'::"text")), 'Demo Check-in'::"text") AS "name",
        CASE
            WHEN "d"."check_in_status" THEN 'Checked In'::"text"
            ELSE 'Pending'::"text"
        END AS "check_in_status",
    "d"."check_in_photo",
    "tm"."name" AS "demo_team_member",
    "tm"."email" AS "team_member_email",
    "d"."demo_date",
    "string_agg"("b"."brand", ' + '::"text") AS "brands",
    "a"."account" AS "store_name",
    "d"."created_at"
   FROM (((("public"."demos" "d"
     LEFT JOIN "public"."jt_demo_brands" "jdb" ON (("d"."id" = "jdb"."demo_id")))
     LEFT JOIN "public"."brands" "b" ON (("jdb"."brand_id" = "b"."id")))
     LEFT JOIN "public"."accounts" "a" ON (("d"."account_id" = "a"."uuid")))
     LEFT JOIN "public"."team_member_guide" "tm" ON (("d"."team_member_id" = "tm"."uuid")))
  WHERE (("d"."demo_date" = CURRENT_DATE) OR ("d"."demo_status" = ANY (ARRAY['Store Confirmed'::"public"."demo_status_enum", 'Inventory Confirmed'::"public"."demo_status_enum"])))
  GROUP BY "d"."id", "d"."check_in_status", "d"."check_in_photo", "tm"."name", "tm"."email", "d"."demo_date", "a"."account", "d"."created_at";
ALTER TABLE "public"."v_demo_check_ins" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_full_contact" AS
 WITH "aggregated_categories" AS (
         SELECT "jt_cat"."contact_id",
            "jsonb_agg"("jsonb_build_object"('id', "mc"."id", 'full_category', "mc"."full_category", 'category', "mc"."category", 'subcategory', "mc"."subcategory")) AS "managed_categories",
            "array_agg"(DISTINCT "mc"."category") AS "managed_category_names"
           FROM ("public"."jt_contacts_categories_managed" "jt_cat"
             JOIN "public"."master_categories" "mc" ON (("jt_cat"."master_category_id" = "mc"."id")))
          GROUP BY "jt_cat"."contact_id"
        ), "aggregated_rep_accounts" AS (
         SELECT "jt_acct"."contacts_uuid",
            "jsonb_agg"("jsonb_build_object"('id', "ra"."uuid", 'account_name', "ra"."account", 'account_type', "rat_rep"."name")) AS "representative_accounts",
            "array_agg"(DISTINCT "ra"."uuid") AS "representative_account_ids",
            "array_agg"(DISTINCT "ra"."account") AS "representative_account_names"
           FROM (("public"."jt_contacts_distributor_rep_accounts" "jt_acct"
             JOIN "public"."accounts" "ra" ON (("jt_acct"."account_uuid" = "ra"."uuid")))
             LEFT JOIN "public"."ref_account_type" "rat_rep" ON (("ra"."account_type" = "rat_rep"."uuid")))
          GROUP BY "jt_acct"."contacts_uuid"
        )
 SELECT "c"."uuid" AS "contact_uuid",
    (("c"."full_name" || ' - '::"text") || COALESCE("pa"."account", ''::"text")) AS "contact_and_account",
    "c"."job_title" AS "contact_job_title",
    "c"."first_name",
    "c"."last_name",
    "c"."contact_email",
    "c"."contact_phone",
    "c"."department_tags",
    "c"."contact_notes",
    "c"."full_name" AS "contact_full_name",
    "c"."verification_needed",
    "c"."last_modified",
    "c"."create_date",
    "pa"."uuid" AS "primary_account_uuid",
    "pa"."account" AS "primary_account_name",
    "rat_pa"."name" AS "primary_account_type",
    "pa"."city" AS "primary_account_city",
    "pa"."state" AS "primary_account_state",
    "pa"."website" AS "primary_account_website",
    "agg_cat"."managed_categories",
    "agg_rep"."representative_accounts",
    "agg_cat"."managed_category_names",
    "agg_rep"."representative_account_ids",
    "agg_rep"."representative_account_names",
    "c"."updated_by"
   FROM (((("public"."contacts" "c"
     LEFT JOIN "public"."accounts" "pa" ON (("c"."account" = "pa"."uuid")))
     LEFT JOIN "public"."ref_account_type" "rat_pa" ON (("pa"."account_type" = "rat_pa"."uuid")))
     LEFT JOIN "aggregated_categories" "agg_cat" ON (("c"."uuid" = "agg_cat"."contact_id")))
     LEFT JOIN "aggregated_rep_accounts" "agg_rep" ON (("c"."uuid" = "agg_rep"."contacts_uuid")));
ALTER TABLE "public"."v_full_contact" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_gn_categories_with_retailer_mappings" AS
 SELECT "mc"."id" AS "gn_category_id",
    "mc"."category" AS "gn_category",
    "mc"."subcategory" AS "gn_subcategory",
    "mc"."full_category" AS "gn_full_category",
    "mc"."notes" AS "gn_category_notes",
    "a"."account" AS "retailer_name",
    "a"."uuid" AS "retailer_id",
    "rgcm"."id" AS "retailer_category_id",
    "rgcm"."retailer_category_name",
    "rgcm"."unique_category_name",
    "rgcm"."category_name_from_excel",
    "mcrd"."new_item_submission_deadline",
    "mcrd"."review_type",
    "mcrd"."retailer_review_timing",
    "mcrd"."display_name" AS "review_name",
    "jt"."created_at" AS "mapping_created_at"
   FROM ((((("public"."master_categories" "mc"
     LEFT JOIN "public"."jt_retailer_category_to_gn_categories" "jt" ON (("mc"."id" = "jt"."gn_category_id")))
     LEFT JOIN "public"."retailer_gnf_category_matching" "rgcm" ON (("jt"."retailer_category_id" = "rgcm"."id")))
     LEFT JOIN "public"."accounts" "a" ON (("rgcm"."account" = "a"."uuid")))
     LEFT JOIN "public"."jt_master_category_review_data_matching" "jtrdm" ON (("rgcm"."id" = "jtrdm"."retailer_matching_id")))
     LEFT JOIN "public"."master_category_review_data" "mcrd" ON (("jtrdm"."review_data_id" = "mcrd"."id")));
ALTER TABLE "public"."v_gn_categories_with_retailer_mappings" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_grouped_syncup_notes" AS
 SELECT "to_char"("date_trunc"('day'::"text", "note_details"."sync_date"), 'Mon DD,YYYY'::"text") AS "formatted_date",
    "to_char"("date_trunc"('day'::"text", "note_details"."sync_date"), 'YYYY-MM-DD'::"text") AS "day_start",
    "jsonb_agg"("jsonb_build_object"('id', "note_details"."uuid", 'team_member_id', "note_details"."team_member_uuid", 'team_member_name', "note_details"."team_member_name", 'profile_photo', "note_details"."profile_photo", 'note', "note_details"."note", 'sync_date', "note_details"."sync_date", 'updated_at', "note_details"."updated_at", 'user_id', "note_details"."user_id", 'associated_brands', "note_details"."associated_brands", 'associated_accounts', "note_details"."associated_accounts") ORDER BY "note_details"."sync_date") AS "daily_notes"
   FROM ( SELECT "sn"."uuid",
            "sn"."note",
            "sn"."sync_date",
            "sn"."updated_at",
            "sn"."user" AS "user_id",
            "tmg"."uuid" AS "team_member_uuid",
            "tmg"."name" AS "team_member_name",
            "tmg"."profile_photo",
            ( SELECT "jsonb_agg"("jsonb_build_object"('jt_id', "js_inner"."id", 'brand_id', "b_inner"."id", 'brand_name', "b_inner"."brand") ORDER BY "b_inner"."brand") FILTER (WHERE ("b_inner"."id" IS NOT NULL)) AS "jsonb_agg"
                   FROM ("public"."jt_sync_up_notes_brands" "js_inner"
                     JOIN "public"."brands" "b_inner" ON (("js_inner"."brand_id" = "b_inner"."id")))
                  WHERE ("js_inner"."note_id" = "sn"."uuid")) AS "associated_brands",
            ( SELECT "jsonb_agg"("jsonb_build_object"('jt_id', "ja_inner"."id", 'account_id', "a_inner"."uuid", 'account_name', "a_inner"."account") ORDER BY "a_inner"."account") FILTER (WHERE ("a_inner"."uuid" IS NOT NULL)) AS "jsonb_agg"
                   FROM ("public"."jt_sync_up_notes_accounts" "ja_inner"
                     JOIN "public"."accounts" "a_inner" ON (("ja_inner"."account_id" = "a_inner"."uuid")))
                  WHERE ("ja_inner"."note_id" = "sn"."uuid")) AS "associated_accounts"
           FROM ("public"."syncup_notes" "sn"
             LEFT JOIN "public"."team_member_guide" "tmg" ON (("sn"."team_member" = "tmg"."uuid")))
          WHERE ((EXISTS ( SELECT 1
                   FROM "public"."jt_sync_up_notes_brands" "js_check_exists"
                  WHERE ("js_check_exists"."note_id" = "sn"."uuid"))) OR (EXISTS ( SELECT 1
                   FROM "public"."jt_sync_up_notes_accounts" "ja_check_exists"
                  WHERE ("ja_check_exists"."note_id" = "sn"."uuid"))))) "note_details"
  GROUP BY ("date_trunc"('day'::"text", "note_details"."sync_date"))
  ORDER BY ("date_trunc"('day'::"text", "note_details"."sync_date")) DESC;
ALTER TABLE "public"."v_grouped_syncup_notes" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_harvesthub_dashboard_stats" AS
 WITH "current_metrics" AS (
         SELECT "count"(*) FILTER (WHERE ("hh_customers"."status" = 'Active Customer'::"public"."hh_customer_status_enum")) AS "active_count",
            "count"(*) FILTER (WHERE ("hh_customers"."status" = 'Cancelled'::"public"."hh_customer_status_enum")) AS "churn_count",
            "count"(*) FILTER (WHERE ("hh_customers"."status" = 'Signed Up'::"public"."hh_customer_status_enum")) AS "pending_count",
            "sum"("hh_customers"."total_amount_invoiced") FILTER (WHERE (("hh_customers"."status" = 'Active Customer'::"public"."hh_customer_status_enum") AND ("hh_customers"."billing_terms" = 'monthly'::"public"."hh_billing_terms_enum"))) AS "current_mrr",
            ((COALESCE("sum"("hh_customers"."total_amount_invoiced") FILTER (WHERE (("hh_customers"."status" = 'Active Customer'::"public"."hh_customer_status_enum") AND ("hh_customers"."billing_terms" = 'monthly'::"public"."hh_billing_terms_enum"))), (0)::numeric) * (12)::numeric) + COALESCE("sum"("hh_customers"."total_amount_invoiced") FILTER (WHERE (("hh_customers"."status" = 'Active Customer'::"public"."hh_customer_status_enum") AND ("hh_customers"."billing_terms" = 'yearly'::"public"."hh_billing_terms_enum"))), (0)::numeric)) AS "current_arr"
           FROM "public"."hh_customers"
        ), "previous_metrics" AS (
         SELECT "count"(*) FILTER (WHERE ("hh_customers"."status" = 'Active Customer'::"public"."hh_customer_status_enum")) AS "active_count",
            "count"(*) FILTER (WHERE ("hh_customers"."status" = 'Cancelled'::"public"."hh_customer_status_enum")) AS "churn_count",
            "count"(*) FILTER (WHERE ("hh_customers"."status" = 'Signed Up'::"public"."hh_customer_status_enum")) AS "pending_count",
            "sum"("hh_customers"."total_amount_invoiced") FILTER (WHERE (("hh_customers"."status" = 'Active Customer'::"public"."hh_customer_status_enum") AND ("hh_customers"."billing_terms" = 'monthly'::"public"."hh_billing_terms_enum"))) AS "mrr",
            ((COALESCE("sum"("hh_customers"."total_amount_invoiced") FILTER (WHERE (("hh_customers"."status" = 'Active Customer'::"public"."hh_customer_status_enum") AND ("hh_customers"."billing_terms" = 'monthly'::"public"."hh_billing_terms_enum"))), (0)::numeric) * (12)::numeric) + COALESCE("sum"("hh_customers"."total_amount_invoiced") FILTER (WHERE (("hh_customers"."status" = 'Active Customer'::"public"."hh_customer_status_enum") AND ("hh_customers"."billing_terms" = 'yearly'::"public"."hh_billing_terms_enum"))), (0)::numeric)) AS "arr"
           FROM "public"."hh_customers"
          WHERE ("hh_customers"."created_at" <= ("now"() - '30 days'::interval))
        ), "contribution_stats" AS (
         SELECT "count"(*) FILTER (WHERE ("hh_contributions"."created_at" >= "date_trunc"('month'::"text", "now"()))) AS "current_month_count",
            "count"(*) FILTER (WHERE (("hh_contributions"."created_at" >= "date_trunc"('month'::"text", ("now"() - '1 mon'::interval))) AND ("hh_contributions"."created_at" < "date_trunc"('month'::"text", "now"())))) AS "last_month_count"
           FROM "public"."hh_contributions"
        )
 SELECT "c"."active_count" AS "active_customers",
    "c"."churn_count" AS "churned_customers",
    "c"."pending_count" AS "pending_conversions",
    COALESCE("c"."current_mrr", (0)::numeric) AS "mrr",
    COALESCE("c"."current_arr", (0)::numeric) AS "arr",
    "con"."current_month_count" AS "this_months_contributions",
    ("c"."active_count" - "p"."active_count") AS "active_change",
    ("c"."churn_count" - "p"."churn_count") AS "churn_change",
    ("c"."pending_count" - "p"."pending_count") AS "pending_conversion_change",
    (COALESCE("c"."current_mrr", (0)::numeric) - COALESCE("p"."mrr", (0)::numeric)) AS "mrr_change",
    (COALESCE("c"."current_arr", (0)::numeric) - COALESCE("p"."arr", (0)::numeric)) AS "arr_change",
    ("con"."current_month_count" - "con"."last_month_count") AS "contributions_change"
   FROM "current_metrics" "c",
    "previous_metrics" "p",
    "contribution_stats" "con";
ALTER TABLE "public"."v_harvesthub_dashboard_stats" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_harvesthub_prospect_customers_datagrid" AS
 SELECT "hh_prospect_customers"."id",
    "hh_prospect_customers"."name",
    "hh_prospect_customers"."company",
    "hh_prospect_customers"."title",
    "hh_prospect_customers"."email",
    "hh_prospect_customers"."phone",
    "hh_prospect_customers"."contact_source",
    "hh_prospect_customers"."conversion_status",
    "hh_prospect_customers"."product_interest",
    "hh_prospect_customers"."customer_inquiry_source",
    "hh_prospect_customers"."interested_use_cases",
    "hh_prospect_customers"."inquiry_message",
    "hh_prospect_customers"."internal_notes",
    "hh_prospect_customers"."followed_up",
    "hh_prospect_customers"."linkedin_url",
    "hh_prospect_customers"."business_card_image",
    "hh_prospect_customers"."customer_id",
    "hh_prospect_customers"."is_active",
    "hh_prospect_customers"."created_at",
    "hh_prospect_customers"."updated_at"
   FROM "public"."hh_prospect_customers";
ALTER TABLE "public"."v_harvesthub_prospect_customers_datagrid" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_hh_customer_activity" AS
 SELECT "c"."id",
    "c"."name",
    "c"."company",
    "c"."email",
    "c"."status",
    "c"."created_at" AS "signup_date",
    "count"(DISTINCT "jcmc"."master_category_id") AS "categories_count",
    "count"(DISTINCT "jccr"."category_review_id") AS "reviews_subscribed",
    "count"(DISTINCT "cont"."id") AS "total_contributions",
    "max"("cont"."created_at") AS "last_contribution_date",
    "count"(DISTINCT "cr"."account") AS "retailers_involved"
   FROM (((("public"."hh_customers" "c"
     LEFT JOIN "public"."jt_hh_customers_master_categories" "jcmc" ON (("c"."id" = "jcmc"."customer_id")))
     LEFT JOIN "public"."jt_hh_customers_category_reviews" "jccr" ON (("c"."id" = "jccr"."customer_id")))
     LEFT JOIN "public"."master_category_review_data" "cr" ON (("jccr"."category_review_id" = "cr"."id")))
     LEFT JOIN "public"."hh_contributions" "cont" ON (("c"."id" = "cont"."customer_id")))
  GROUP BY "c"."id", "c"."name", "c"."company", "c"."email", "c"."status", "c"."created_at";
ALTER TABLE "public"."v_hh_customer_activity" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_hh_upcoming_deadlines" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::"text" AS "display_name",
    NULL::"uuid" AS "account",
    NULL::"text" AS "retailer_category",
    NULL::"text" AS "retailer_review_timing",
    NULL::"date" AS "reset_date",
    NULL::"text" AS "review_type",
    NULL::"date" AS "retailer_review_date",
    NULL::"date" AS "on_shelf_reset_date",
    NULL::"date" AS "new_item_submission_deadline",
    NULL::"uuid" AS "master_category_id",
    NULL::timestamp with time zone AS "created_at",
    NULL::timestamp with time zone AS "updated_at",
    NULL::boolean AS "archive",
    NULL::"uuid" AS "gnf_sub_category",
    NULL::"text" AS "account_name",
    NULL::"text" AS "city",
    NULL::"text" AS "store_count",
    NULL::"text" AS "website",
    NULL::"text" AS "gnf_category",
    NULL::"text" AS "customer_names",
    NULL::"text" AS "customer_emails",
    NULL::integer AS "days_until_deadline";
ALTER TABLE "public"."v_hh_upcoming_deadlines" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_master_category_review_data" AS
 SELECT "mcrd"."id",
    "mcrd"."display_name",
    "mcrd"."account" AS "account_uuid",
    "a"."cr_calendar" AS "account_cr_calendar",
    "mcrd"."retailer_category",
    "mcrd"."retailer_review_timing",
    "mcrd"."reset_date",
    "mcrd"."review_type",
    "mcrd"."retailer_review_date",
    "mcrd"."on_shelf_reset_date",
    "mcrd"."new_item_submission_deadline",
    "mcrd"."master_category_id",
    "mcrd"."created_at",
    "mcrd"."updated_at",
    "mcrd"."archive",
    "mcrd"."gnf_sub_category" AS "gnf_sub_category_uuid",
    "mc"."full_category" AS "gnf_sub_category_name"
   FROM (("public"."master_category_review_data" "mcrd"
     LEFT JOIN "public"."accounts" "a" ON (("mcrd"."account" = "a"."uuid")))
     LEFT JOIN "public"."master_categories" "mc" ON (("mcrd"."gnf_sub_category" = "mc"."id")))
  ORDER BY "mcrd"."new_item_submission_deadline";
ALTER TABLE "public"."v_master_category_review_data" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_my_internal_profile" AS
 SELECT "p"."id",
    "p"."name",
    "p"."created_at",
    "p"."brand_id",
    "p"."department",
    "p"."user_type",
    "p"."profile_photo",
    "tmg"."status",
    "tmg"."title",
    "tmg"."address",
    "tmg"."phone_number",
    "tmg"."department" AS "public_department",
    "tmg"."send_samples",
    "tmg"."food_handlers_card",
    "tmg"."calls_counted_by_team_member",
    "tmg"."counter",
    "tmg"."email",
    "tmg"."key_support" AS "key_accounts",
    "tmg"."regional_coverage",
    "tmg"."time_zone",
    "tmg"."country_of_origin",
    "tmg"."language_spoken"
   FROM ("public"."profiles" "p"
     LEFT JOIN "public"."team_member_guide" "tmg" ON (("p"."id" = "tmg"."uuid")))
  WHERE ("p"."id" = "auth"."uid"());
ALTER TABLE "public"."v_my_internal_profile" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_program_connects_by_month" AS
 SELECT "sa"."id" AS "sos_authorization_id",
    "b"."brand" AS "brand_name",
    "sa"."calling_month",
    "sa"."calling_year",
    "sum"(COALESCE("at"."connect_count", 0)) AS "connects_achieved",
    "concat"("b"."brand", ' - ', "sa"."calling_month", ' - ', "sa"."calling_year", ' - ', "sum"(COALESCE("at"."connect_count", 0))) AS "program_summary_name"
   FROM (("public"."sos_authorizations" "sa"
     LEFT JOIN "public"."activity_tracker" "at" ON (("at"."sos_authorizations" = "sa"."id")))
     LEFT JOIN "public"."brands" "b" ON (("sa"."brand" = "b"."id")))
  WHERE (("at"."connect_stage")::"text" ~~* 'Connect%'::"text")
  GROUP BY "sa"."id", "b"."brand", "sa"."calling_month", "sa"."calling_year";
ALTER TABLE "public"."v_program_connects_by_month" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_retailer_categories_with_gn_mappings" AS
 SELECT "rgcm"."id" AS "retailer_category_id",
    "a"."account" AS "retailer_name",
    "rgcm"."retailer_category_name",
    "rgcm"."unique_category_name",
    "rgcm"."category_name_from_excel",
    "array_agg"("mc"."category" ORDER BY "mc"."category") FILTER (WHERE ("mc"."category" IS NOT NULL)) AS "gn_categories",
    "array_agg"("mc"."full_category" ORDER BY "mc"."category") FILTER (WHERE ("mc"."full_category" IS NOT NULL)) AS "gn_full_categories",
    "count"("mc"."id") AS "gn_category_count",
    "rgcm"."created_at",
    "rgcm"."updated_at"
   FROM ((("public"."retailer_gnf_category_matching" "rgcm"
     LEFT JOIN "public"."accounts" "a" ON (("rgcm"."account" = "a"."uuid")))
     LEFT JOIN "public"."jt_retailer_category_to_gn_categories" "jt" ON (("rgcm"."id" = "jt"."retailer_category_id")))
     LEFT JOIN "public"."master_categories" "mc" ON (("jt"."gn_category_id" = "mc"."id")))
  GROUP BY "rgcm"."id", "a"."account", "rgcm"."retailer_category_name", "rgcm"."unique_category_name", "rgcm"."category_name_from_excel", "rgcm"."created_at", "rgcm"."updated_at";
ALTER TABLE "public"."v_retailer_categories_with_gn_mappings" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_review_data_comprehensive" AS
 SELECT DISTINCT "mcrd"."id" AS "review_data_id",
    "mcrd"."display_name" AS "review_name",
    "mcrd"."retailer_category",
    "mcrd"."retailer_review_timing",
    "mcrd"."review_type",
    "mcrd"."new_item_submission_deadline",
    "mcrd"."reset_date",
    "mcrd"."retailer_review_date",
    "mcrd"."on_shelf_reset_date",
    "a"."account" AS "account_name",
    "a"."city" AS "account_city",
    "b"."id" AS "brand_id",
    "b"."brand" AS "brand_name",
    "rgcm"."id" AS "matching_id",
    "rgcm"."retailer_category_name",
    "rgcm"."unique_category_name",
    "mc"."category" AS "master_category",
    "mc"."full_category" AS "master_full_category"
   FROM (((((("public"."master_category_review_data" "mcrd"
     LEFT JOIN "public"."accounts" "a" ON (("mcrd"."account" = "a"."uuid")))
     LEFT JOIN "public"."master_categories" "mc" ON (("mcrd"."master_category_id" = "mc"."id")))
     LEFT JOIN "public"."jt_master_category_review_data_brands" "jtb" ON (("mcrd"."id" = "jtb"."review_data_id")))
     LEFT JOIN "public"."brands" "b" ON (("jtb"."brand_id" = "b"."id")))
     LEFT JOIN "public"."jt_master_category_review_data_matching" "jtm" ON (("mcrd"."id" = "jtm"."review_data_id")))
     LEFT JOIN "public"."retailer_gnf_category_matching" "rgcm" ON (("jtm"."retailer_matching_id" = "rgcm"."id")));
ALTER TABLE "public"."v_review_data_comprehensive" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_review_data_with_brands" AS
 SELECT "mcrd"."id" AS "review_data_id",
    "mcrd"."display_name" AS "review_name",
    "mcrd"."retailer_category",
    "mcrd"."retailer_review_timing",
    "mcrd"."review_type",
    "mcrd"."new_item_submission_deadline",
    "a"."account" AS "account_name",
    "a"."city" AS "account_city",
    "b"."id" AS "brand_id",
    "b"."brand" AS "brand_name",
    "b"."manufacturer_name",
    "jt"."created_at" AS "brand_relationship_created_at"
   FROM ((("public"."master_category_review_data" "mcrd"
     LEFT JOIN "public"."accounts" "a" ON (("mcrd"."account" = "a"."uuid")))
     LEFT JOIN "public"."jt_master_category_review_data_brands" "jt" ON (("mcrd"."id" = "jt"."review_data_id")))
     LEFT JOIN "public"."brands" "b" ON (("jt"."brand_id" = "b"."id")));
ALTER TABLE "public"."v_review_data_with_brands" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_scheduled_demos" AS
SELECT
    NULL::"uuid" AS "id",
    NULL::"uuid" AS "account_id",
    NULL::"uuid" AS "team_member_id",
    NULL::"text" AS "demo_name",
    NULL::"date" AS "demo_date",
    NULL::time without time zone AS "start_time",
    NULL::time without time zone AS "end_time",
    NULL::"text" AS "formatted_time_range",
    NULL::"public"."demo_status_enum" AS "demo_status",
    NULL::"text" AS "brands",
    NULL::"text" AS "store_name",
    NULL::"text" AS "demo_team_member",
    NULL::"text" AS "team_member_email",
    NULL::"text" AS "phone_number",
    NULL::"text" AS "address",
    NULL::boolean AS "time_off_requested",
    NULL::timestamp with time zone AS "time_off_request_date",
    NULL::"text" AS "time_off_notes",
    NULL::"public"."demo_request_type_enum" AS "demo_request_type",
    NULL::"text" AS "requested_timing",
    NULL::"text" AS "notes_to_demo_team",
    NULL::"text" AS "notes",
    NULL::timestamp with time zone AS "created_at";
ALTER TABLE "public"."v_scheduled_demos" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_sku_category_readable" AS
 SELECT "mc"."category" AS "category_name",
    "sps"."description" AS "sku_description",
    "spc"."brand_product_sku" AS "sku_id",
    "mc"."id" AS "category_id"
   FROM (("public"."sku_product_category" "spc"
     JOIN "public"."master_categories" "mc" ON (("mc"."id" = "spc"."product_category")))
     JOIN "public"."spec_price_sheet" "sps" ON (("sps"."id" = "spc"."brand_product_sku")));
ALTER TABLE "public"."v_sku_category_readable" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_sos_authorizations_extended" AS
 SELECT "sa"."id",
    "sa"."created_at",
    "sa"."brand" AS "brand_id",
    "sa"."program_type",
    "sa"."program_status",
    "sa"."calling_month",
    "sa"."calling_year",
    "sa"."region",
    "sa"."goodnow_input",
    "sa"."program_calling_goals",
    "sa"."sponsored_connects",
    "sa"."total_paid_connects_authorized",
    "sa"."date_billed",
    "sa"."sos_rep_assigned" AS "sos_rep_assigned_id",
    "sa"."calling_lists_from_vendor",
    "sa"."program",
    "sa"."connects_achieved",
    "b"."brand" AS "brand_name",
    "tmg"."name" AS "rep_name",
    "tmg"."profile_photo" AS "rep_profile_photo"
   FROM (("public"."sos_authorizations" "sa"
     LEFT JOIN "public"."brands" "b" ON (("sa"."brand" = "b"."id")))
     LEFT JOIN "public"."team_member_guide" "tmg" ON (("sa"."sos_rep_assigned" = "tmg"."uuid")));
ALTER TABLE "public"."v_sos_authorizations_extended" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_sos_authorizations_with_calculated_revenue" AS
 SELECT "sa"."id",
    "sa"."created_at",
    "sa"."brand",
    "sa"."program_type",
    "sa"."program_status",
    "sa"."calling_month",
    "sa"."calling_year",
    "sa"."region",
    "sa"."goodnow_input",
    "sa"."program_calling_goals",
    "sa"."sponsored_connects",
    "sa"."total_paid_connects_authorized",
    "sa"."date_billed",
    "sa"."sos_rep_assigned",
    "sa"."calling_lists_from_vendor",
    "sa"."program",
    "sa"."connects_achieved",
    "b"."brand" AS "brand_name",
    ("b"."sos_sales_rate")::numeric AS "sos_sales_rate",
    (("b"."sos_sales_rate")::numeric * (("sa"."connects_achieved")::numeric - ("sa"."sponsored_connects")::numeric)) AS "sos_revenue"
   FROM ("public"."sos_authorizations" "sa"
     JOIN "public"."brands" "b" ON (("sa"."brand" = "b"."id")));
ALTER TABLE "public"."v_sos_authorizations_with_calculated_revenue" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_spec_price_sheet" AS
 SELECT "sps"."description",
    "sps"."item_status",
    "sps"."sales_rank",
    "sps"."vendor_item_number",
    "sps"."upc_12_digit",
    "sps"."ean",
    "sps"."case_upc",
    "sps"."master_upc",
    "sps"."case_pack",
    "sps"."master_pack",
    "sps"."unit_height_inches",
    "sps"."unit_width_inches",
    "sps"."unit_depth_inches",
    "sps"."case_height_inches",
    "sps"."case_width_inches",
    "sps"."case_depth_inches",
    "sps"."master_case_height_inches",
    "sps"."master_case_width_inches",
    "sps"."master_case_depth_inches",
    "sps"."net_case_weight_lbs",
    "sps"."gross_case_weight_lbs",
    "sps"."master_case_weight_lbs",
    "sps"."ti",
    "sps"."hi",
    "sps"."cube",
    "sps"."cases_per_pallet",
    "sps"."pallet_weight_lbs",
    "sps"."item_temp_reqs",
    "sps"."fob_location",
    "sps"."srp",
    "sps"."direct_ship_available",
    "sps"."direct_ship_cost_case",
    "sps"."fob_price_case",
    "sps"."unit_cost_fob",
    "sps"."delivered_west_distribution_by_case",
    "sps"."delivered_east_distribution_by_case",
    "sps"."minimum_direct_order_quantity",
    "sps"."minimum_order_quantity_distribution",
    "sps"."order_lead_time",
    "sps"."shelf_life_in_days_at_manufacture",
    "sps"."frozen_shelf_life_if_applicable",
    "sps"."shelf_life_in_days_guaranteed",
    "sps"."ingredient_list",
    "sps"."other_pricing_case",
    "sps"."other_pricing_notes",
    "sps"."other_pricing_unit",
    "sps"."id",
    "sps"."brand_id",
    "sps"."updated_at",
    "sps"."uos",
    "sps"."uom",
    "sps"."unique_item_name",
    "sps"."order_lead_time_to_distributor" AS "order_lead_time_distributor",
    "sps"."product_shelf_life_slacked_out",
    "sps"."best_by_date_indicated",
    "sps"."organic_certifier_entity",
    "sps"."organic",
    "sps"."non_gmo",
    "sps"."gluten_free",
    "sps"."vegan",
    "sps"."vegetarian",
    "sps"."kosher",
    "sps"."dairy_free",
    "sps"."sugar_free",
    "sps"."soy_free",
    "sps"."nut_free",
    "sps"."wheat_free",
    "sps"."updated_by",
    "b"."brand" AS "brand_name",
    "sps"."updated_at" AS "last_updated"
   FROM ("public"."spec_price_sheet" "sps"
     LEFT JOIN "public"."brands" "b" ON (("sps"."brand_id" = "b"."id")));
ALTER TABLE "public"."v_spec_price_sheet" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_tile_cards_total_sos_followups" AS
 SELECT "tmg"."user_id",
    "count"(DISTINCT "at"."id") AS "sos_followups"
   FROM ("public"."activity_tracker" "at"
     JOIN "public"."team_member_guide" "tmg" ON (("at"."assign_for_follow_up" = "tmg"."uuid")))
  WHERE (("tmg"."user_id" IS NOT NULL) AND ("at"."assign_for_follow_up" IS NOT NULL))
  GROUP BY "tmg"."user_id";
ALTER TABLE "public"."v_tile_cards_total_sos_followups" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_tile_cards_upcoming_reviews" AS
 SELECT "tmg"."user_id",
    "count"(DISTINCT "mcrd"."id") AS "upcoming_reviews"
   FROM (((("public"."master_category_review_data" "mcrd"
     LEFT JOIN "public"."jt_deal_category_reviews" "jdcr" ON (("mcrd"."id" = "jdcr"."category_reviews")))
     LEFT JOIN "public"."activity_tracker" "at" ON (("jdcr"."activity_tracker" = "at"."id")))
     LEFT JOIN "public"."jt_deal_owners" "jdo" ON (("at"."id" = "jdo"."deal_id")))
     LEFT JOIN "public"."team_member_guide" "tmg" ON (("jdo"."team_member_id" = "tmg"."uuid")))
  WHERE (("tmg"."user_id" IS NOT NULL) AND ("mcrd"."archive" IS NOT TRUE))
  GROUP BY "tmg"."user_id";
ALTER TABLE "public"."v_tile_cards_upcoming_reviews" OWNER TO "postgres";
CREATE OR REPLACE VIEW "public"."v_user_notifications_detail" AS
 SELECT "jun"."id" AS "user_notification_id",
    "jun"."member_id",
    "jun"."notification_id",
    "jun"."is_read",
    "jun"."created_at" AS "user_notification_created_at",
    "n"."title",
    "n"."description",
    "n"."type",
    "n"."created_at" AS "notification_created_at"
   FROM ("public"."jt_user_notifications" "jun"
     JOIN "public"."notifications(deprecated)" "n" ON (("jun"."notification_id" = "n"."id")));
ALTER TABLE "public"."v_user_notifications_detail" OWNER TO "postgres";
ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_2_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."accounts_migration"
    ADD CONSTRAINT "accounts_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."jt_accounts_team_member_guide"
    ADD CONSTRAINT "accounts_team_members_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."activity_tracker_migration"
    ADD CONSTRAINT "activity_tracker_migration_brand_account_key" UNIQUE ("brand", "account");
ALTER TABLE ONLY "public"."activity_tracker_migration"
    ADD CONSTRAINT "activity_tracker_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "activity_tracker_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_associated_skus"
    ADD CONSTRAINT "associated_skus_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_contacts_table_migration"
    ADD CONSTRAINT "brand_contacts_table_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."brand_contacts_table"
    ADD CONSTRAINT "brand_contacts_table_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."brand_distribution_grid"
    ADD CONSTRAINT "brand_distribution_grid_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_brand_events"
    ADD CONSTRAINT "brand_event_attendance_brand_id_event_id_key" UNIQUE ("brand_id", "event_id");
ALTER TABLE ONLY "public"."jt_brand_events"
    ADD CONSTRAINT "brand_event_attendance_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_focus_assignments"
    ADD CONSTRAINT "brand_focus_assignments_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_portal_credentials_migration"
    ADD CONSTRAINT "brand_portal_credentials_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_portal_credentials"
    ADD CONSTRAINT "brand_portal_credentials_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_promo_requests (Deprecated)"
    ADD CONSTRAINT "brand_promo_requests_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_brand_promotion_skus"
    ADD CONSTRAINT "brand_promotion_skus_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_promotions"
    ADD CONSTRAINT "brand_promotions_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_sync_call_schedule"
    ADD CONSTRAINT "brand_sync_call_schedule_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_tasks"
    ADD CONSTRAINT "brand_task__pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brands"
    ADD CONSTRAINT "brands_brand_key" UNIQUE ("brand");
ALTER TABLE ONLY "public"."brands_migration"
    ADD CONSTRAINT "brands_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."brands"
    ADD CONSTRAINT "brands_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."deal_activity_comments"
    ADD CONSTRAINT "comments_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."company_announcements"
    ADD CONSTRAINT "company_announcements_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."contacts_migration"
    ADD CONSTRAINT "contacts_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."contacts_migration"
    ADD CONSTRAINT "contacts_migration_uuid_key" UNIQUE ("uuid");
ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_uuid_key" UNIQUE ("uuid");
ALTER TABLE ONLY "public"."deal_stage_history"
    ADD CONSTRAINT "deal_stage_history_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."demos_migration"
    ADD CONSTRAINT "demos_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."demos"
    ADD CONSTRAINT "demos_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_documents"
    ADD CONSTRAINT "documents_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_event_name_event_year_key" UNIQUE ("event_name", "event_year");
ALTER TABLE ONLY "public"."events_migration"
    ADD CONSTRAINT "events_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."folders"
    ADD CONSTRAINT "folders_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."harvesthub_documents"
    ADD CONSTRAINT "harvesthub_documents_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_account_experts"
    ADD CONSTRAINT "hh_account_experts_email_key" UNIQUE ("email");
ALTER TABLE ONLY "public"."hh_account_experts_migration"
    ADD CONSTRAINT "hh_account_experts_migration_email_key" UNIQUE ("email");
ALTER TABLE ONLY "public"."hh_account_experts_migration"
    ADD CONSTRAINT "hh_account_experts_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_account_experts"
    ADD CONSTRAINT "hh_account_experts_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_blog_articles_migration"
    ADD CONSTRAINT "hh_blog_articles_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_blog_articles"
    ADD CONSTRAINT "hh_blog_articles_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_community_experts"
    ADD CONSTRAINT "hh_community_experts_email_key" UNIQUE ("email");
ALTER TABLE ONLY "public"."hh_community_experts_migration"
    ADD CONSTRAINT "hh_community_experts_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_community_experts"
    ADD CONSTRAINT "hh_community_experts_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_contributions_migration"
    ADD CONSTRAINT "hh_contributions_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_contributions"
    ADD CONSTRAINT "hh_contributions_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_customers"
    ADD CONSTRAINT "hh_customers_email_key" UNIQUE ("email");
ALTER TABLE ONLY "public"."hh_customers_migration"
    ADD CONSTRAINT "hh_customers_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_customers"
    ADD CONSTRAINT "hh_customers_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_deals_migration"
    ADD CONSTRAINT "hh_deals_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_deals"
    ADD CONSTRAINT "hh_deals_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_feature_updates_migration"
    ADD CONSTRAINT "hh_feature_updates_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_feature_updates"
    ADD CONSTRAINT "hh_feature_updates_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_licenses_migration"
    ADD CONSTRAINT "hh_licenses_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."hh_licenses"
    ADD CONSTRAINT "hh_licenses_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_promo_codes"
    ADD CONSTRAINT "hh_promo_codes_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_prospect_customers_migration"
    ADD CONSTRAINT "hh_prospect_customers_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."hh_prospect_customers"
    ADD CONSTRAINT "hh_prospect_customers_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."interaction_partners"
    ADD CONSTRAINT "interaction_partners_pkey" PRIMARY KEY ("partner_id");
ALTER TABLE ONLY "public"."jt_active_account_distribution_grid"
    ADD CONSTRAINT "jt_active_account_distribution_grid_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_active_services"
    ADD CONSTRAINT "jt_active_services_ref_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_activity_note_mentions"
    ADD CONSTRAINT "jt_activity_note_mentions_id_key" UNIQUE ("id");
ALTER TABLE ONLY "public"."jt_activity_note_mentions"
    ADD CONSTRAINT "jt_activity_note_mentions_pkey" PRIMARY KEY ("user_id", "activity_id");
ALTER TABLE ONLY "public"."jt_ref_applied_services"
    ADD CONSTRAINT "jt_applied_services_ref_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_brand_promo_request_skus"
    ADD CONSTRAINT "jt_brand_promo_request_skus_brand_promo_request_id_sku_id_key" UNIQUE ("brand_promo_request_id", "sku_id");
ALTER TABLE ONLY "public"."jt_brand_promo_request_skus"
    ADD CONSTRAINT "jt_brand_promo_request_skus_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_brand_status"
    ADD CONSTRAINT "jt_brand_status_ref_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_category_review_contacts"
    ADD CONSTRAINT "jt_category_review_contacts_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_contacts_categories_managed"
    ADD CONSTRAINT "jt_contacts_master_categories_contact_id_master_category_id_key" UNIQUE ("contact_id", "master_category_review_id");
ALTER TABLE ONLY "public"."jt_contacts_categories_managed"
    ADD CONSTRAINT "jt_contacts_master_categories_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_coverage"
    ADD CONSTRAINT "jt_coverage_ref_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_deal_category_reviews"
    ADD CONSTRAINT "jt_deal_category_reviews_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_deal_comment_mentions"
    ADD CONSTRAINT "jt_deal_comment_mentions_id_key" UNIQUE ("id");
ALTER TABLE ONLY "public"."jt_deal_comment_mentions"
    ADD CONSTRAINT "jt_deal_comment_mentions_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_deal_spec_price_sheet"
    ADD CONSTRAINT "jt_deal_spec_price_sheet_pkey" PRIMARY KEY ("deal_id", "sku_id");
ALTER TABLE ONLY "public"."jt_deal_task_pipeline"
    ADD CONSTRAINT "jt_deal_task_pipeline_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_demo_brands"
    ADD CONSTRAINT "jt_demo_brands_demo_id_brand_id_key" UNIQUE ("demo_id", "brand_id");
ALTER TABLE ONLY "public"."jt_demo_brands"
    ADD CONSTRAINT "jt_demo_brands_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_accounts_distribution"
    ADD CONSTRAINT "jt_distributor_accounts_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_accounts_flag_for_attention"
    ADD CONSTRAINT "jt_flag_for_attention_ref_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_hh_customers_accounts_deals"
    ADD CONSTRAINT "jt_hh_customers_accounts_customer_id_account_id_key" UNIQUE ("customer_id", "account_id");
ALTER TABLE ONLY "public"."jt_hh_customers_accounts_deals"
    ADD CONSTRAINT "jt_hh_customers_accounts_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_hh_customers_category_reviews"
    ADD CONSTRAINT "jt_hh_customers_category_revi_customer_id_category_review_i_key" UNIQUE ("customer_id", "category_review_id");
ALTER TABLE ONLY "public"."jt_hh_customers_category_reviews"
    ADD CONSTRAINT "jt_hh_customers_category_reviews_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_hh_customers_licenses(deprecated)"
    ADD CONSTRAINT "jt_hh_customers_licenses_customer_id_license_id_key" UNIQUE ("customer_id", "license_id");
ALTER TABLE ONLY "public"."jt_hh_customers_licenses(deprecated)"
    ADD CONSTRAINT "jt_hh_customers_licenses_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_hh_customers_master_categories"
    ADD CONSTRAINT "jt_hh_customers_master_catego_customer_id_master_category_i_key" UNIQUE ("customer_id", "master_category_id");
ALTER TABLE ONLY "public"."jt_hh_customers_master_categories"
    ADD CONSTRAINT "jt_hh_customers_master_categories_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_accounts_industry_tags"
    ADD CONSTRAINT "jt_industry_tags_ref_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_master_categories_brands"
    ADD CONSTRAINT "jt_master_categories_brands_master_category_id_brand_id_key" UNIQUE ("master_category_id", "brand_id");
ALTER TABLE ONLY "public"."jt_master_categories_brands_migration"
    ADD CONSTRAINT "jt_master_categories_brands_mig_uniq_pair" UNIQUE ("master_category_id", "brand_id");
ALTER TABLE ONLY "public"."jt_master_categories_brands_migration"
    ADD CONSTRAINT "jt_master_categories_brands_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."jt_master_categories_brands"
    ADD CONSTRAINT "jt_master_categories_brands_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_master_category_review_data_matching"
    ADD CONSTRAINT "jt_master_category_review_dat_review_data_id_retailer_match_key" UNIQUE ("review_data_id", "retailer_matching_id");
ALTER TABLE ONLY "public"."jt_master_category_review_data_brands"
    ADD CONSTRAINT "jt_master_category_review_data_bran_review_data_id_brand_id_key" UNIQUE ("review_data_id", "brand_id");
ALTER TABLE ONLY "public"."jt_master_category_review_data_brands"
    ADD CONSTRAINT "jt_master_category_review_data_brands_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_master_category_review_data_matching"
    ADD CONSTRAINT "jt_master_category_review_data_matching_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_matched_brands_to_category_reviews"
    ADD CONSTRAINT "jt_matched_brands_to_category_reviews_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_principal_list_product_images"
    ADD CONSTRAINT "jt_principal_list_product_images_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_announcement_tag"
    ADD CONSTRAINT "jt_ref_announcement_tag_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_brand_attention_flag"
    ADD CONSTRAINT "jt_ref_brand_attention_flag_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_brand_audience_tag"
    ADD CONSTRAINT "jt_ref_brand_audience_tag_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_categories_for_principal_list"
    ADD CONSTRAINT "jt_ref_categories_for_principal_list_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_accounts_category_review_received_status"
    ADD CONSTRAINT "jt_ref_category_review_status_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_contact_department_tags"
    ADD CONSTRAINT "jt_ref_contact_department_tags_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_contacts_flag_for_attention"
    ADD CONSTRAINT "jt_ref_contacts_flag_for_attention_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_departments"
    ADD CONSTRAINT "jt_ref_departments_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_hh_community_expert_services_offered"
    ADD CONSTRAINT "jt_ref_hh_community_expert_services_offered_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_hh_expert_services_offered"
    ADD CONSTRAINT "jt_ref_hh_expert_services_offered_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_no_contact_details"
    ADD CONSTRAINT "jt_ref_no_contact_details_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_product_sub_category"
    ADD CONSTRAINT "jt_ref_product_sub_category_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_ref_sos_program_type"
    ADD CONSTRAINT "jt_ref_sos_program_type_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_retailer_category_to_gn_categories"
    ADD CONSTRAINT "jt_retailer_category_to_gn_ca_retailer_category_id_gn_categ_key" UNIQUE ("retailer_category_id", "gn_category_id");
ALTER TABLE ONLY "public"."jt_retailer_category_to_gn_categories"
    ADD CONSTRAINT "jt_retailer_category_to_gn_categories_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_spec_price_sheet_categories"
    ADD CONSTRAINT "jt_spec_price_sheet_categories_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_spec_price_sheet_categories"
    ADD CONSTRAINT "jt_spec_price_sheet_categories_sku_id_category_id_key" UNIQUE ("sku_id", "category_id");
ALTER TABLE ONLY "public"."jt_ref_sub_tags"
    ADD CONSTRAINT "jt_sub_tags_ref_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_sync_up_notes_accounts"
    ADD CONSTRAINT "jt_sync_up_notes_accounts_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_sync_up_notes_brands"
    ADD CONSTRAINT "jt_sync_up_notes_brands_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_task_assignments"
    ADD CONSTRAINT "jt_task_assignments_pkey" PRIMARY KEY ("task_id", "team_member_uuid", "uuid");
ALTER TABLE ONLY "public"."jt_task_assignments"
    ADD CONSTRAINT "jt_task_assignments_uuid_key" UNIQUE ("uuid");
ALTER TABLE ONLY "public"."jt_team_members_x_events"
    ADD CONSTRAINT "jt_team_members_x_events_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."jt_user_role_dept"
    ADD CONSTRAINT "jt_user_role_dept_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."master_categories_migration"
    ADD CONSTRAINT "master_categories_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."master_categories"
    ADD CONSTRAINT "master_categories_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."master_category_review_data_migration"
    ADD CONSTRAINT "master_category_review_data_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."master_category_review_data"
    ADD CONSTRAINT "master_category_review_data_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."master_promo_data"
    ADD CONSTRAINT "master_promo_data_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."notifications(deprecated)"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey1" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."planned_submissions"
    ADD CONSTRAINT "planned_reviews_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."prospects (deprecated)"
    ADD CONSTRAINT "prospects_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_	hh_product_interest_enum"
    ADD CONSTRAINT "ref_	hh_product_interest_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_account_type"
    ADD CONSTRAINT "ref_account_type_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_active_services"
    ADD CONSTRAINT "ref_active_services_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_announcement_tag"
    ADD CONSTRAINT "ref_announcement_tag_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_attendance_status_enum"
    ADD CONSTRAINT "ref_attendance_status_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_brand_attention_flag_enum"
    ADD CONSTRAINT "ref_attention_flag_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_brand_audience_tag"
    ADD CONSTRAINT "ref_brand_audience_tag_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_brand_promo_table_distributors"
    ADD CONSTRAINT "ref_brand_promo_table_distributors_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_brand_status"
    ADD CONSTRAINT "ref_brand_status_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_categories_for_principal_list"
    ADD CONSTRAINT "ref_categories_for_principal_list_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_category_review_received_status"
    ADD CONSTRAINT "ref_category_review_status_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_category_review_type"
    ADD CONSTRAINT "ref_category_review_type_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_contacts_flag_for_attention"
    ADD CONSTRAINT "ref_contacts_flag_for_attention_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_country"
    ADD CONSTRAINT "ref_country_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_coverage"
    ADD CONSTRAINT "ref_coverage_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_deal_stage"
    ADD CONSTRAINT "ref_deal_stage_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_decision_level_tag_enum"
    ADD CONSTRAINT "ref_decision_level_tag_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_demo_status_enum"
    ADD CONSTRAINT "ref_demo_status_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_contact_department_tags"
    ADD CONSTRAINT "ref_department_tags_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_departments"
    ADD CONSTRAINT "ref_departments_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_account_flag_for_attention_enum"
    ADD CONSTRAINT "ref_flag_for_attention_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_goodnow_event _participation_status"
    ADD CONSTRAINT "ref_goodnow_event _participation_status_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_hh_billing_terms_enum"
    ADD CONSTRAINT "ref_hh_billing_terms_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_hh_community_expert_services_offered"
    ADD CONSTRAINT "ref_hh_community_expert_services_offered_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_hh_contact_source_enum"
    ADD CONSTRAINT "ref_hh_contact_source_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_hh_customer_status"
    ADD CONSTRAINT "ref_hh_customer_status_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_hh_expert_services_offered"
    ADD CONSTRAINT "ref_hh_expert_services_offered_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_hh_how_found_enum"
    ADD CONSTRAINT "ref_hh_how_found_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_hh_lead_source"
    ADD CONSTRAINT "ref_hh_lead_source_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_hh_payment_status_enum"
    ADD CONSTRAINT "ref_hh_payment_status_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_hh_user_role_enum"
    ADD CONSTRAINT "ref_hh_user_role_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_industry_tag"
    ADD CONSTRAINT "ref_industry_tag_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_no_contact_details"
    ADD CONSTRAINT "ref_no_contact_details_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_product_subcategory_enum"
    ADD CONSTRAINT "ref_product_subcategory_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_promo_delivery"
    ADD CONSTRAINT "ref_promo_delivery_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_promo_types"
    ADD CONSTRAINT "ref_promo_types_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_prospect_status"
    ADD CONSTRAINT "ref_prospect_status_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_sos_calling_year"
    ADD CONSTRAINT "ref_sos_calling_year_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_sos_program_type"
    ADD CONSTRAINT "ref_sos_program_type_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."ref_sub_tags"
    ADD CONSTRAINT "ref_sub_tags_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_task_type_enum"
    ADD CONSTRAINT "ref_task_type_enum_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."ref_verification_status"
    ADD CONSTRAINT "ref_verification_status_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."retailer_gnf_category_matching_migration"
    ADD CONSTRAINT "retailer_gnf_category_matching_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."retailer_gnf_category_matching"
    ADD CONSTRAINT "retailer_gnf_category_matching_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."sample_shipment_tracking"
    ADD CONSTRAINT "sample_shipment_tracking_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."sku_account_distribution"
    ADD CONSTRAINT "sku_account_distribution_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."sku_images"
    ADD CONSTRAINT "sku_images_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."sku_placements"
    ADD CONSTRAINT "sku_placements_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."sku_product_category"
    ADD CONSTRAINT "sku_product_category_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."sos_authorizations_migration"
    ADD CONSTRAINT "sos_authorizations_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."sos_authorizations"
    ADD CONSTRAINT "sos_authorizations_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."spec_price_sheet_migration"
    ADD CONSTRAINT "spec_price_sheet_migration_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."spec_price_sheet"
    ADD CONSTRAINT "spec_price_sheet_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."stat_card_table"
    ADD CONSTRAINT "stat_card_table_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."syncup_notes"
    ADD CONSTRAINT "syncup_notes_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."jt_task_pipeline_attachments"
    ADD CONSTRAINT "task_pipeline_attachments_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."task_pipeline"
    ADD CONSTRAINT "task_pipeline_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."brand_task_templates"
    ADD CONSTRAINT "task_templates_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."brand_task_types"
    ADD CONSTRAINT "task_types_code_key" UNIQUE ("code");
ALTER TABLE ONLY "public"."brand_task_types"
    ADD CONSTRAINT "task_types_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."team_member_dept"
    ADD CONSTRAINT "team_member_dept_dept_code_key" UNIQUE ("dept_code");
ALTER TABLE ONLY "public"."team_member_dept"
    ADD CONSTRAINT "team_member_dept_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."team_member_guide_migration"
    ADD CONSTRAINT "team_member_guide_migration_pkey" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."team_member_guide"
    ADD CONSTRAINT "team_member_pk" PRIMARY KEY ("uuid");
ALTER TABLE ONLY "public"."test_brand_directory"
    ADD CONSTRAINT "test_brand_directory_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "unique_brand_account" UNIQUE ("brand", "account");
ALTER TABLE ONLY "public"."jt_matched_brands_to_category_reviews"
    ADD CONSTRAINT "unique_brand_review_match" UNIQUE ("brand_match_id", "review_id");
ALTER TABLE ONLY "public"."sku_placements"
    ADD CONSTRAINT "unique_deal_sku" UNIQUE ("account_id", "sku_id");
ALTER TABLE ONLY "public"."ref_industry_tag"
    ADD CONSTRAINT "unique_industry_tag_name" UNIQUE ("name");
ALTER TABLE ONLY "public"."jt_task_assignments"
    ADD CONSTRAINT "unique_task_member_assignment" UNIQUE ("task_id", "team_member_uuid");
ALTER TABLE ONLY "public"."jt_user_notifications"
    ADD CONSTRAINT "user_notifications_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."users_roles"
    ADD CONSTRAINT "users_roles_pkey" PRIMARY KEY ("id");
CREATE INDEX "accounts_migration_search_vector_idx" ON "public"."accounts_migration" USING "gin" ("search_vector");
CREATE INDEX "accounts_search_idx" ON "public"."accounts" USING "gin" ("search_vector");
CREATE INDEX "activity_tracker_migration_account_idx" ON "public"."activity_tracker_migration" USING "btree" ("account");
CREATE INDEX "activity_tracker_migration_brand_idx" ON "public"."activity_tracker_migration" USING "btree" ("brand");
CREATE INDEX "activity_tracker_migration_search_vector_idx" ON "public"."activity_tracker_migration" USING "gin" ("search_vector");
CREATE INDEX "activity_tracker_search_idx" ON "public"."activity_tracker" USING "gin" ("search_vector");
CREATE INDEX "brands_migration_search_vector_idx" ON "public"."brands_migration" USING "gin" ("search_vector");
CREATE INDEX "brands_search_idx" ON "public"."brands" USING "gin" ("search_vector");
CREATE INDEX "demos_migration_account_id_idx" ON "public"."demos_migration" USING "btree" ("account_id");
CREATE INDEX "demos_migration_demo_date_idx" ON "public"."demos_migration" USING "btree" ("demo_date");
CREATE INDEX "demos_migration_demo_status_idx" ON "public"."demos_migration" USING "btree" ("demo_status");
CREATE INDEX "demos_migration_team_member_id_idx" ON "public"."demos_migration" USING "btree" ("team_member_id");
CREATE INDEX "hh_contributions_migration_customer_id_idx" ON "public"."hh_contributions_migration" USING "btree" ("customer_id");
CREATE INDEX "hh_customers_migration_email_idx" ON "public"."hh_customers_migration" USING "btree" ("email");
CREATE INDEX "hh_customers_migration_status_idx" ON "public"."hh_customers_migration" USING "btree" ("status");
CREATE INDEX "hh_deals_migration_account_id_idx" ON "public"."hh_deals_migration" USING "btree" ("account_id");
CREATE INDEX "hh_deals_migration_owner_id_idx" ON "public"."hh_deals_migration" USING "btree" ("owner_id");
CREATE INDEX "hh_deals_migration_stage_idx" ON "public"."hh_deals_migration" USING "btree" ("stage");
CREATE INDEX "hh_licenses_migration_product_name_idx" ON "public"."hh_licenses_migration" USING "btree" ("product_name");
CREATE INDEX "hh_licenses_migration_product_status_idx" ON "public"."hh_licenses_migration" USING "btree" ("product_status");
CREATE INDEX "idx_activity_tracker_account" ON "public"."activity_tracker" USING "btree" ("account");
CREATE INDEX "idx_activity_tracker_brand" ON "public"."activity_tracker" USING "btree" ("brand");
CREATE INDEX "idx_activity_tracker_deal_stage" ON "public"."activity_tracker" USING "btree" ("deal_stage");
CREATE INDEX "idx_brand_id" ON "public"."spec_price_sheet" USING "btree" ("brand_id");
CREATE INDEX "idx_deal_stage_history_activity_id" ON "public"."deal_stage_history" USING "btree" ("activity_id");
CREATE INDEX "idx_deal_stage_history_changed_by" ON "public"."deal_stage_history" USING "btree" ("changed_by");
CREATE INDEX "idx_demos_account_id" ON "public"."demos" USING "btree" ("account_id");
CREATE INDEX "idx_demos_demo_date" ON "public"."demos" USING "btree" ("demo_date");
CREATE INDEX "idx_demos_status" ON "public"."demos" USING "btree" ("demo_status");
CREATE INDEX "idx_demos_team_member_id" ON "public"."demos" USING "btree" ("team_member_id");
CREATE INDEX "idx_hh_contributions_customer" ON "public"."hh_contributions" USING "btree" ("customer_id");
CREATE INDEX "idx_hh_customers_email" ON "public"."hh_customers" USING "btree" ("email");
CREATE INDEX "idx_hh_customers_status" ON "public"."hh_customers" USING "btree" ("status");
CREATE INDEX "idx_hh_deals_account_id" ON "public"."hh_deals" USING "btree" ("account_id");
CREATE INDEX "idx_hh_deals_owner_id" ON "public"."hh_deals" USING "btree" ("owner_id");
CREATE INDEX "idx_hh_deals_stage" ON "public"."hh_deals" USING "btree" ("stage");
CREATE INDEX "idx_hh_licenses_product_name" ON "public"."hh_licenses" USING "btree" ("product_name");
CREATE INDEX "idx_hh_licenses_status" ON "public"."hh_licenses" USING "btree" ("product_status");
CREATE INDEX "idx_jdtp_deal_id" ON "public"."jt_deal_task_pipeline" USING "btree" ("deal_id");
CREATE INDEX "idx_jdtp_task_id" ON "public"."jt_deal_task_pipeline" USING "btree" ("task_id");
CREATE INDEX "idx_jt_contacts_master_categories_contact_id" ON "public"."jt_contacts_categories_managed" USING "btree" ("contact_id");
CREATE INDEX "idx_jt_contacts_master_categories_master_category_id" ON "public"."jt_contacts_categories_managed" USING "btree" ("master_category_review_id");
CREATE INDEX "idx_jt_deal_owners_deal_id" ON "public"."jt_deal_owners" USING "btree" ("deal_id");
CREATE INDEX "idx_jt_deal_owners_team_member_id" ON "public"."jt_deal_owners" USING "btree" ("team_member_id");
CREATE INDEX "idx_jt_demo_brands_brand_id" ON "public"."jt_demo_brands" USING "btree" ("brand_id");
CREATE INDEX "idx_jt_demo_brands_demo_id" ON "public"."jt_demo_brands" USING "btree" ("demo_id");
CREATE INDEX "idx_jt_hh_cust_cat_rev_customer" ON "public"."jt_hh_customers_category_reviews" USING "btree" ("customer_id");
CREATE INDEX "idx_jt_hh_cust_cat_rev_review" ON "public"."jt_hh_customers_category_reviews" USING "btree" ("category_review_id");
CREATE INDEX "idx_jt_hh_cust_master_cat_category" ON "public"."jt_hh_customers_master_categories" USING "btree" ("master_category_id");
CREATE INDEX "idx_jt_hh_cust_master_cat_customer" ON "public"."jt_hh_customers_master_categories" USING "btree" ("customer_id");
CREATE INDEX "idx_mcrd_account" ON "public"."master_category_review_data" USING "btree" ("account");
CREATE INDEX "idx_mcrd_deadline_archive" ON "public"."master_category_review_data" USING "btree" ("new_item_submission_deadline", "archive");
CREATE INDEX "idx_notifications_recipient_created_at" ON "public"."notifications" USING "btree" ("recipient_id", "created_at" DESC);
CREATE INDEX "idx_notifications_recipient_id" ON "public"."notifications" USING "btree" ("recipient_id");
CREATE INDEX "idx_planned_submissions_category_review" ON "public"."planned_submissions" USING "btree" ("category_review");
CREATE INDEX "idx_planned_submissions_date" ON "public"."planned_submissions" USING "btree" ("planned_submission_date");
CREATE INDEX "idx_planned_submissions_deal_id" ON "public"."planned_submissions" USING "btree" ("deal_id");
CREATE INDEX "idx_planned_submissions_tmg_id" ON "public"."planned_submissions" USING "btree" ("user");
CREATE INDEX "idx_ta_task_id" ON "public"."jt_task_assignments" USING "btree" ("task_id");
CREATE INDEX "idx_ta_team_member" ON "public"."jt_task_assignments" USING "btree" ("team_member_uuid");
CREATE INDEX "idx_task_pipeline_category_review" ON "public"."task_pipeline" USING "btree" ("category_review_id");
CREATE INDEX "idx_task_pipeline_due_date" ON "public"."task_pipeline" USING "btree" ("due_date");
CREATE INDEX "idx_task_pipeline_status" ON "public"."task_pipeline" USING "btree" ("status");
CREATE UNIQUE INDEX "jt_associated_skus_deal_sku_idx" ON "public"."jt_associated_skus" USING "btree" ("deal_id", "sku_id");
CREATE INDEX "master_category_review_data_m_new_item_submission_deadline__idx" ON "public"."master_category_review_data_migration" USING "btree" ("new_item_submission_deadline", "archive");
CREATE INDEX "master_category_review_data_migration_account_idx" ON "public"."master_category_review_data_migration" USING "btree" ("account");
CREATE INDEX "spec_price_sheet_migration_brand_id_idx" ON "public"."spec_price_sheet_migration" USING "btree" ("brand_id");
CREATE INDEX "task_pipeline_task_title_idx" ON "public"."task_pipeline" USING "btree" ("task_title");
CREATE UNIQUE INDEX "uniq_event_team_member" ON "public"."jt_team_members_x_events" USING "btree" ("event_id", "team_member_id");
CREATE INDEX "users_roles_role_id_idx" ON "public"."users_roles" USING "btree" ("role_id");
CREATE INDEX "users_roles_user_id_idx" ON "public"."users_roles" USING "btree" ("user_id");
CREATE OR REPLACE VIEW "public"."event_with_attendees" AS
 SELECT "e"."id" AS "event_id",
    "e"."event_name",
    "e"."event_dates",
    "e"."event_year",
    (("e"."event_name" || ' – '::"text") || "e"."event_dates") AS "readable_event_title",
    "json_agg"(DISTINCT "b"."brand") FILTER (WHERE ("b"."id" IS NOT NULL)) AS "attending_brands",
    "json_agg"(DISTINCT "t"."name") FILTER (WHERE ("t"."uuid" IS NOT NULL)) AS "confirmed_team_members"
   FROM (((("public"."events" "e"
     LEFT JOIN "public"."jt_brand_events" "be" ON (("be"."event_id" = "e"."id")))
     LEFT JOIN "public"."brands" "b" ON (("b"."id" = "be"."brand_id")))
     LEFT JOIN "public"."jt_team_members_x_events" "te" ON (("te"."event_id" = "e"."id")))
     LEFT JOIN "public"."team_member_guide" "t" ON (("t"."uuid" = "te"."team_member_id")))
  GROUP BY "e"."id";
CREATE OR REPLACE VIEW "public"."v_brand_promotions_with_skus" AS
 SELECT "bp"."id",
    "bp"."created_at",
    "bp"."brand",
    "bp"."master_promo_id",
    "bp"."retailer_id",
    "bp"."distribution_id",
    "bp"."promo_quarter",
    "bp"."submission_status",
    "bp"."brand_approval",
    "bp"."submission_notes",
    "bp"."brand_comments",
    "bp"."submitted_promo_contracts",
    "json_agg"("jsonb_build_object"('id', "sps"."id", 'unique_item_name', "sps"."unique_item_name", 'other_pricing_unit', "sps"."other_pricing_unit", 'other_pricing_case', "sps"."other_pricing_case")) FILTER (WHERE ("sps"."id" IS NOT NULL)) AS "skus"
   FROM (("public"."brand_promotions" "bp"
     LEFT JOIN "public"."jt_brand_promotion_skus" "jt" ON (("bp"."id" = "jt"."brand_promotion_id")))
     LEFT JOIN "public"."spec_price_sheet" "sps" ON (("jt"."sku_id" = "sps"."id")))
  GROUP BY "bp"."id";
CREATE OR REPLACE VIEW "public"."v_hh_upcoming_deadlines" AS
 SELECT "cr"."id",
    "cr"."display_name",
    "cr"."account",
    "cr"."retailer_category",
    "cr"."retailer_review_timing",
    "cr"."reset_date",
    "cr"."review_type",
    "cr"."retailer_review_date",
    "cr"."on_shelf_reset_date",
    "cr"."new_item_submission_deadline",
    "cr"."master_category_id",
    "cr"."created_at",
    "cr"."updated_at",
    "cr"."archive",
    "cr"."gnf_sub_category",
    "a"."account" AS "account_name",
    "a"."city",
    "a"."store_count",
    "a"."website",
    "mc"."full_category" AS "gnf_category",
    "string_agg"(DISTINCT "c"."name", ', '::"text") AS "customer_names",
    "string_agg"(DISTINCT "c"."email", ', '::"text") AS "customer_emails",
    ("cr"."new_item_submission_deadline" - CURRENT_DATE) AS "days_until_deadline"
   FROM (((("public"."master_category_review_data" "cr"
     JOIN "public"."accounts" "a" ON (("cr"."account" = "a"."uuid")))
     LEFT JOIN "public"."master_categories" "mc" ON (("cr"."master_category_id" = "mc"."id")))
     LEFT JOIN "public"."jt_hh_customers_category_reviews" "jccr" ON (("cr"."id" = "jccr"."category_review_id")))
     LEFT JOIN "public"."hh_customers" "c" ON (("jccr"."customer_id" = "c"."id")))
  WHERE (("cr"."new_item_submission_deadline" >= CURRENT_DATE) AND ("cr"."new_item_submission_deadline" <= (CURRENT_DATE + '90 days'::interval)) AND (("cr"."archive" IS NOT TRUE) OR ("cr"."archive" IS NULL)))
  GROUP BY "cr"."id", "a"."account", "a"."city", "a"."store_count", "a"."website", "mc"."full_category"
  ORDER BY "cr"."new_item_submission_deadline";
CREATE OR REPLACE VIEW "public"."v_brand_promo_requests_with_skus" AS
 SELECT "bpr"."id",
    "bpr"."created_at",
    "bpr"."brand_id",
    "bpr"."retailer_id",
    "bpr"."distributor_id",
    "bpr"."promo_type_brand_facing",
    "bpr"."effective_promo_month",
    "bpr"."effective_promo_year",
    "bpr"."submission_status",
    "bpr"."brand_approval",
    "json_agg"(
        CASE
            WHEN ("sps"."id" IS NOT NULL) THEN "jsonb_build_object"('id', "sps"."id", 'unique_item_name', "sps"."unique_item_name", 'upc_12_digit', "sps"."upc_12_digit", 'case_pack', "sps"."case_pack", 'fob_price_case', "sps"."fob_price_case", 'srp', "sps"."srp")
            ELSE NULL::"jsonb"
        END) FILTER (WHERE ("sps"."id" IS NOT NULL)) AS "skus",
    "count"("sps"."id") AS "sku_count"
   FROM (("public"."brand_promo_requests (Deprecated)" "bpr"
     LEFT JOIN "public"."jt_brand_promo_request_skus" "jt" ON (("bpr"."id" = "jt"."brand_promo_request_id")))
     LEFT JOIN "public"."spec_price_sheet" "sps" ON (("jt"."sku_id" = "sps"."id")))
  GROUP BY "bpr"."id";
CREATE OR REPLACE VIEW "public"."v_scheduled_demos" AS
 SELECT "d"."id",
    "d"."account_id",
    "d"."team_member_id",
    COALESCE((((("string_agg"("b"."brand", ' + '::"text") || ' - '::"text") || "a"."account") || ' - '::"text") || "to_char"(("d"."demo_date")::timestamp with time zone, 'MM/DD/YYYY'::"text")), 'Scheduled Demo'::"text") AS "demo_name",
    "d"."demo_date",
    "d"."start_time",
    "d"."end_time",
    "lower"((("to_char"(("d"."start_time")::interval, 'FMHH12am'::"text") || ' - '::"text") || "to_char"(("d"."end_time")::interval, 'FMHH12am'::"text"))) AS "formatted_time_range",
    "d"."demo_status",
    "string_agg"("b"."brand", ' + '::"text") AS "brands",
    "a"."account" AS "store_name",
    "tm"."name" AS "demo_team_member",
    "tm"."email" AS "team_member_email",
    "tm"."phone_number",
    "tm"."address",
    "d"."time_off_requested",
    "d"."time_off_request_date",
    "d"."time_off_notes",
    "d"."demo_request_type",
    "d"."requested_timing",
    "d"."notes_to_demo_team",
    "d"."notes",
    "d"."created_at"
   FROM (((("public"."demos" "d"
     LEFT JOIN "public"."jt_demo_brands" "jdb" ON (("d"."id" = "jdb"."demo_id")))
     LEFT JOIN "public"."brands" "b" ON (("jdb"."brand_id" = "b"."id")))
     LEFT JOIN "public"."accounts" "a" ON (("d"."account_id" = "a"."uuid")))
     LEFT JOIN "public"."team_member_guide" "tm" ON (("d"."team_member_id" = "tm"."uuid")))
  WHERE ("d"."demo_status" = ANY (ARRAY['Requested'::"public"."demo_status_enum", 'Store Confirmed'::"public"."demo_status_enum", 'Inventory Confirmed'::"public"."demo_status_enum", 'Rescheduled'::"public"."demo_status_enum"]))
  GROUP BY "d"."id", "d"."demo_date", "d"."start_time", "d"."end_time", "d"."demo_status", "a"."account", "tm"."name", "tm"."email", "tm"."phone_number", "tm"."address", "d"."time_off_requested", "d"."time_off_request_date", "d"."time_off_notes", "d"."demo_request_type", "d"."requested_timing", "d"."notes_to_demo_team", "d"."notes", "d"."created_at";
CREATE OR REPLACE VIEW "public"."v_completed_demos" AS
 SELECT "d"."id",
    "d"."demo_date",
    "d"."date_submitted",
    "d"."demo_status",
    "d"."start_time",
    "d"."end_time",
    "d"."time_range",
    "d"."account_id",
    "d"."team_member_id",
    "d"."store_poc",
    "d"."demo_fee",
    "d"."date_billed",
    "d"."other_fees",
    "d"."billing_notes",
    "d"."notes",
    "d"."store_busy_rating",
    "d"."price_on_shelf",
    "d"."units_before",
    "d"."units_after",
    "d"."units_sampled",
    "d"."avg_samples_given",
    "d"."total_units_sold",
    "d"."demo_feedback",
    "d"."demo_hours",
    "d"."training_hours",
    "d"."merchandising_hours",
    "d"."other_hours",
    "d"."total_hours",
    "d"."created_at",
    "d"."updated_at",
    "d"."demo_images",
    "d"."demo_receipts",
    "d"."demo_request_type",
    "d"."requested_timing",
    "d"."store_names",
    "d"."retailer_fees",
    "d"."check_in_photo",
    "d"."check_in_status",
    "d"."nwg_demo",
    "d"."notes_to_demo_team",
    "d"."time_off_requested",
    "d"."time_off_request_date",
    "d"."time_off_notes",
        CASE
            WHEN ("d"."time_off_requested" IS TRUE) THEN '#8B5CF6'::"text"
            WHEN ("d"."demo_status" = ANY (ARRAY['Completed'::"public"."demo_status_enum", 'Invoiced'::"public"."demo_status_enum", 'Paid Contract'::"public"."demo_status_enum", 'Paid Gnf'::"public"."demo_status_enum"])) THEN '#9CA3AF'::"text"
            WHEN ("d"."demo_status" = ANY (ARRAY['Store Confirmed'::"public"."demo_status_enum", 'Inventory Confirmed'::"public"."demo_status_enum", 'Rescheduled'::"public"."demo_status_enum", 'Cancelled'::"public"."demo_status_enum", 'Requested'::"public"."demo_status_enum"])) THEN '#10B981'::"text"
            ELSE '#10B981'::"text"
        END AS "event_color",
    COALESCE((((("string_agg"("b"."brand", ' + '::"text") || ' - '::"text") || "a"."account") || ' - '::"text") || "to_char"(("d"."demo_date")::timestamp with time zone, 'MM/DD/YYYY'::"text")), 'Scheduled Demo'::"text") AS "demo_name",
    "tm"."name" AS "demo_team_member",
    "tm"."profile_photo",
    "string_agg"(("b"."demo_customer_type")::"text", ', '::"text") AS "brand_customer_types",
    "a"."account",
    "a"."gnf_priority",
    "a"."address" AS "store_address",
    "a"."city" AS "store_city",
    "a"."state" AS "store_state",
    "a"."zip" AS "store_zip",
    "a"."country",
    "a"."store_phone_number",
    "a"."website",
    "a"."account_description",
    "a"."account_notes",
    "a"."uuid" AS "account_uuid",
    "a"."updated_at" AS "account_last_updated",
    "jsonb_agg"("to_jsonb"("b".*)) AS "brand_details",
    "string_agg"("b"."brand", ' + '::"text") AS "brand_names_list"
   FROM (((("public"."demos" "d"
     LEFT JOIN "public"."accounts" "a" ON (("d"."account_id" = "a"."uuid")))
     LEFT JOIN "public"."jt_demo_brands" "jdb" ON (("d"."id" = "jdb"."demo_id")))
     LEFT JOIN "public"."brands" "b" ON (("jdb"."brand_id" = "b"."id")))
     LEFT JOIN "public"."team_member_guide" "tm" ON (("d"."team_member_id" = "tm"."uuid")))
  GROUP BY "d"."id", "a"."uuid", "tm"."uuid";
CREATE OR REPLACE VIEW "public"."v_demo_calendar" AS
 SELECT "d"."id",
    "d"."account_id",
    "d"."team_member_id",
        CASE
            WHEN ("d"."time_off_requested" IS TRUE) THEN '#8B5CF6'::"text"
            WHEN (("d"."demo_status")::"text" = ANY (ARRAY['Completed'::"text", 'Invoiced'::"text", 'Paid Contract'::"text", 'Paid Gnf'::"text"])) THEN '#9CA3AF'::"text"
            WHEN (("d"."demo_status")::"text" = ANY (ARRAY['Store Confirmed'::"text", 'Inventory Confirmed'::"text", 'Rescheduled'::"text", 'Cancelled'::"text", 'Requested'::"text"])) THEN '#10B981'::"text"
            ELSE '#10B981'::"text"
        END AS "event_color",
    COALESCE((((("string_agg"("b"."brand", ' + '::"text") || ' - '::"text") || "a"."account") || ' - '::"text") || "to_char"(("d"."demo_date")::timestamp with time zone, 'MM/DD/YYYY'::"text")), 'Scheduled Demo'::"text") AS "demo_name",
    "d"."demo_date",
    "d"."start_time",
    "d"."end_time",
    "lower"((("to_char"(("d"."start_time")::interval, 'FMHH12am'::"text") || ' - '::"text") || "to_char"(("d"."end_time")::interval, 'FMHH12am'::"text"))) AS "formatted_time_range",
    "d"."demo_status",
    "string_agg"("b"."brand", ' + '::"text") AS "brands",
    "a"."account" AS "store_name",
    "tm"."name" AS "demo_team_member",
    "tm"."email" AS "team_member_email",
    "tm"."phone_number",
    "tm"."address",
    "d"."time_off_requested",
    "d"."time_off_request_date",
    "d"."time_off_notes",
    "d"."demo_request_type",
    "d"."requested_timing",
    "d"."notes_to_demo_team",
    "d"."notes",
    "d"."created_at"
   FROM (((("public"."demos" "d"
     LEFT JOIN "public"."jt_demo_brands" "jdb" ON (("d"."id" = "jdb"."demo_id")))
     LEFT JOIN "public"."brands" "b" ON (("jdb"."brand_id" = "b"."id")))
     LEFT JOIN "public"."accounts" "a" ON (("d"."account_id" = "a"."uuid")))
     LEFT JOIN "public"."team_member_guide" "tm" ON (("d"."team_member_id" = "tm"."uuid")))
  GROUP BY "d"."id", "d"."demo_date", "d"."start_time", "d"."end_time", "d"."demo_status", "a"."account", "tm"."name", "tm"."email", "tm"."phone_number", "tm"."address", "d"."time_off_requested", "d"."time_off_request_date", "d"."time_off_notes", "d"."demo_request_type", "d"."requested_timing", "d"."notes_to_demo_team", "d"."notes", "d"."created_at";
CREATE OR REPLACE VIEW "public"."v_task_pipeline_with_assignees" AS
 SELECT "t"."id" AS "task_id",
    "t"."task_title",
    "t"."notes",
    "t"."task_type",
    "t"."status",
    "t"."due_date",
    "t"."priority",
    "t"."is_completed",
    "t"."completed_at",
    "t"."created_at",
    "t"."updated_at",
    ( SELECT "jsonb_agg"("jsonb_build_object"('deal_id', "at_inner"."id", 'activity_name', "at_inner"."activity_name")) AS "jsonb_agg"
           FROM ("public"."jt_deal_task_pipeline" "jdtp"
             JOIN "public"."activity_tracker" "at_inner" ON (("jdtp"."deal_id" = "at_inner"."id")))
          WHERE ("jdtp"."task_id" = "t"."id")) AS "linked_deals",
    "t"."brand_id",
    "t"."account_id",
    "t"."category_review_id",
    "t"."created_by" AS "creator_team_member_uuid",
    "t"."is_automated",
    "t"."source_type",
    "jsonb_agg"("jsonb_build_object"('assignment_id', "ta"."uuid", 'assigned_at', "ta"."assigned_at", 'team_member_uuid', "tm"."uuid", 'user_id', "tm"."user_id", 'name', "tm"."name", 'email', "tm"."email", 'profile_photo', "tm"."profile_photo")) FILTER (WHERE ("tm"."uuid" IS NOT NULL)) AS "assignees",
    ( SELECT "jsonb_agg"("jsonb_build_object"('junction_id', "jta"."id", 'document_id', "d"."id", 'name', "d"."name", 'size', "d"."size", 'type', "d"."type", 'status', "d"."status", 'path', "d"."storage_path")) AS "jsonb_agg"
           FROM ("public"."jt_task_pipeline_attachments" "jta"
             JOIN "public"."brand_documents" "d" ON (("jta"."document_id" = "d"."id")))
          WHERE ("jta"."task_id" = "t"."id")) AS "attachment_info"
   FROM (("public"."task_pipeline" "t"
     LEFT JOIN "public"."jt_task_assignments" "ta" ON (("t"."id" = "ta"."task_id")))
     LEFT JOIN "public"."team_member_guide" "tm" ON (("ta"."team_member_uuid" = "tm"."uuid")))
  GROUP BY "t"."id"
  ORDER BY "t"."due_date" DESC NULLS LAST;
CREATE OR REPLACE VIEW "public"."v_category_reviews_with_matching_brands" AS
 SELECT "r"."id",
    "r"."display_name",
    "r"."account",
    "r"."retailer_category",
    "r"."retailer_review_timing",
    "r"."reset_date",
    "r"."review_type",
    "r"."retailer_review_date",
    "r"."on_shelf_reset_date",
    "r"."new_item_submission_deadline",
    "r"."master_category_id",
    "r"."created_at",
    "r"."updated_at",
    "r"."archive",
    "r"."gnf_sub_category",
    "r"."category_specific_review_notes",
    "r"."category_cancellation" AS "category_removal_status",
    "r"."cr_review_type",
    COALESCE("jsonb_agg"("jsonb_build_object"('id', "b"."id", 'name', "b"."brand", 'logo', "b"."brand_logo", 'manufacturer', "b"."manufacturer_name")) FILTER (WHERE ("b"."id" IS NOT NULL)), '[]'::"jsonb") AS "matched_brands"
   FROM ((("public"."master_category_review_data" "r"
     LEFT JOIN "public"."jt_matched_brands_to_category_reviews" "jmb" ON (("r"."id" = "jmb"."review_id")))
     LEFT JOIN "public"."jt_master_categories_brands" "mcb" ON (("jmb"."brand_match_id" = "mcb"."id")))
     LEFT JOIN "public"."brands" "b" ON (("mcb"."brand_id" = "b"."id")))
  GROUP BY "r"."id";
CREATE OR REPLACE VIEW "public"."v_brands_view" AS
 SELECT "b"."id",
    "b"."brand",
    "b"."manufacturer_name",
    "b"."principal_list_status",
    "b"."status",
    "b"."services",
    "b"."coverage",
    "b"."start_date",
    "b"."last_date",
    "b"."sos_start_date",
    "b"."demo_start_date",
    "b"."headquarters_address",
    "b"."mailing_address_if_different",
    "b"."free_fill_placement_authorization",
    "b"."samples_policy_and_request_process",
    "b"."mission_components",
    "b"."overall_brand_goals",
    "b"."demos_included_quarterly",
    "b"."sos_calls_included_monthly",
    "b"."sos_sales_rate",
    "b"."referred_by",
    "b"."product_pickup_address",
    "b"."product_summary",
    "b"."se___current_month",
    "b"."invoice_timing",
    "b"."billing_notes",
    "b"."tax_id_number",
    "b"."private_label_bulk_and__or_food_service",
    "b"."describe_any_capabilities_from_the_selection_above",
    "b"."order_lead_time",
    "b"."full_reclamation_or_spoils_allowance",
    "b"."brand_certifications",
    "b"."capacity_or_production_restrictions",
    "b"."direct_order_details_process",
    "b"."marketing_descriptions",
    "b"."email_pitch_descriptor",
    "b"."are_you_a_member_of_any_trade_organizations",
    "b"."product_attributes",
    "b"."onboarding_notes",
    "b"."company_website",
    "b"."cancellation_reasons",
    "b"."se___next_month",
    "b"."brand_contracts",
    "b"."follow_up_email_draft",
    "b"."category_for_principal_list",
    "b"."product_sub_category_for_principal_list",
    "b"."new_item",
    "b"."product_images",
    "b"."attention_flags",
    "b"."brand_logo",
    "b"."other_active_brokerage_service_coverage",
    "b"."demo_customer_type",
    "b"."faire_link",
    "b"."mable_link",
    "b"."airgoods_link",
    "b"."other_link",
    "b"."pod_foods_link",
    COALESCE("jsonb_agg"(DISTINCT "jsonb_build_object"('id', "d"."id", 'name', "d"."name", 'size', "d"."size", 'path', "d"."storage_path")) FILTER (WHERE ("d"."id" IS NOT NULL)), '[]'::"jsonb") AS "principal_list_images",
    COALESCE("jsonb_agg"(DISTINCT "jsonb_build_object"('id', "mc"."id", 'name', "mc"."full_category")) FILTER (WHERE ("mc"."id" IS NOT NULL)), '[]'::"jsonb") AS "master_categories"
   FROM (((("public"."brands" "b"
     LEFT JOIN "public"."jt_principal_list_product_images" "jt" ON (("b"."id" = "jt"."brand")))
     LEFT JOIN "public"."brand_documents" "d" ON (("jt"."brand_document_id" = "d"."id")))
     LEFT JOIN "public"."jt_master_categories_brands" "jt_mc" ON (("b"."id" = "jt_mc"."brand_id")))
     LEFT JOIN "public"."master_categories" "mc" ON (("jt_mc"."master_category_id" = "mc"."id")))
  GROUP BY "b"."id";
CREATE OR REPLACE TRIGGER "accounts_search_vector_update" BEFORE INSERT OR UPDATE ON "public"."accounts" FOR EACH ROW EXECUTE FUNCTION "public"."update_accounts_search_vector"();
CREATE OR REPLACE TRIGGER "activity_tracker_deal_stage_change" AFTER INSERT OR UPDATE ON "public"."activity_tracker" FOR EACH ROW EXECUTE FUNCTION "public"."create_task_on_deal_stage_change"();
ALTER TABLE "public"."activity_tracker" ENABLE ALWAYS TRIGGER "activity_tracker_deal_stage_change";
CREATE OR REPLACE TRIGGER "activity_tracker_search_vector_update" BEFORE INSERT OR UPDATE ON "public"."activity_tracker" FOR EACH ROW EXECUTE FUNCTION "public"."update_activity_tracker_search_vector"();
CREATE OR REPLACE TRIGGER "activity_tracker_set_last_updated_trg" BEFORE INSERT OR UPDATE ON "public"."activity_tracker" FOR EACH ROW EXECUTE FUNCTION "public"."activity_tracker_set_last_updated"();
CREATE OR REPLACE TRIGGER "after_activity_mention" AFTER INSERT ON "public"."jt_activity_note_mentions" FOR EACH ROW EXECUTE FUNCTION "public"."new_activity_mention"();
CREATE OR REPLACE TRIGGER "brands_search_vector_update" BEFORE INSERT OR UPDATE ON "public"."brands" FOR EACH ROW EXECUTE FUNCTION "public"."update_brands_search_vector"();
ALTER TABLE "public"."brands" DISABLE TRIGGER "brands_search_vector_update";
CREATE OR REPLACE TRIGGER "on_account_insert" AFTER INSERT ON "public"."accounts" FOR EACH ROW EXECUTE FUNCTION "public"."sync_new_account_to_partners"();
ALTER TABLE "public"."accounts" DISABLE TRIGGER "on_account_insert";
CREATE OR REPLACE TRIGGER "on_employee_status_change" AFTER UPDATE ON "public"."team_member_guide" FOR EACH ROW WHEN (("old"."status" IS DISTINCT FROM "new"."status")) EXECUTE FUNCTION "public"."handle_employee_status_change"();
CREATE OR REPLACE TRIGGER "on_submission_status_update" BEFORE UPDATE ON "public"."planned_submissions" FOR EACH ROW EXECUTE FUNCTION "public"."handle_submission_status_change"();
CREATE OR REPLACE TRIGGER "on_task_assigned" AFTER INSERT ON "public"."jt_task_assignments" FOR EACH ROW EXECUTE FUNCTION "public"."notify_task_assignment"();
CREATE OR REPLACE TRIGGER "set_connect_count_on_connect_stage_change" BEFORE INSERT OR UPDATE ON "public"."activity_tracker" FOR EACH ROW EXECUTE FUNCTION "public"."update_connect_count"();
CREATE OR REPLACE TRIGGER "set_last_modified" BEFORE UPDATE ON "public"."brands" FOR EACH ROW EXECUTE FUNCTION "public"."update_last_modified_column"();
CREATE OR REPLACE TRIGGER "set_last_modified_events" BEFORE UPDATE ON "public"."events" FOR EACH ROW EXECUTE FUNCTION "public"."update_last_modified_column"();
CREATE OR REPLACE TRIGGER "set_last_modified_trg" BEFORE UPDATE ON "public"."jt_category_review_contacts" FOR EACH ROW EXECUTE FUNCTION "public"."set_last_modified"();
CREATE OR REPLACE TRIGGER "tr_hh_customers_audit" BEFORE UPDATE ON "public"."hh_customers" FOR EACH ROW EXECUTE FUNCTION "public"."handle_hh_customers_audit"();
CREATE OR REPLACE TRIGGER "tr_sync_team_member_profile" AFTER UPDATE OF "profile_photo", "name" ON "public"."team_member_guide" FOR EACH ROW WHEN ((("old"."profile_photo" IS DISTINCT FROM "new"."profile_photo") OR ("old"."name" IS DISTINCT FROM "new"."name"))) EXECUTE FUNCTION "public"."sync_team_member_profile"();
CREATE OR REPLACE TRIGGER "trg_auto_complete_demo" BEFORE INSERT OR UPDATE ON "public"."demos" FOR EACH ROW EXECUTE FUNCTION "public"."auto_complete_demo"();
CREATE OR REPLACE TRIGGER "trg_calculate_total_hours" BEFORE INSERT OR UPDATE ON "public"."demos" FOR EACH ROW EXECUTE FUNCTION "public"."calculate_total_hours"();
CREATE OR REPLACE TRIGGER "trg_fill_full_category" BEFORE INSERT OR UPDATE ON "public"."master_categories" FOR EACH ROW EXECUTE FUNCTION "public"."fill_full_category"();
CREATE OR REPLACE TRIGGER "trg_hh_contribution_status" BEFORE INSERT OR UPDATE ON "public"."hh_contributions" FOR EACH ROW EXECUTE FUNCTION "public"."update_contribution_status"();
CREATE OR REPLACE TRIGGER "trg_hh_customer_status_change" AFTER UPDATE ON "public"."hh_customers" FOR EACH ROW EXECUTE FUNCTION "public"."notify_hh_customer_status_change"();
CREATE OR REPLACE TRIGGER "trg_log_deal_stage_change" AFTER UPDATE ON "public"."activity_tracker" FOR EACH ROW EXECUTE FUNCTION "public"."log_deal_stage_history"();
CREATE OR REPLACE TRIGGER "trg_populate_brand_reviews" AFTER INSERT OR UPDATE ON "public"."jt_master_categories_brands" FOR EACH ROW EXECUTE FUNCTION "public"."link_brand_match_to_reviews"();
CREATE OR REPLACE TRIGGER "trg_set_assignee_name" BEFORE INSERT OR UPDATE OF "assignee_user_id" ON "public"."brand_tasks" FOR EACH ROW EXECUTE FUNCTION "public"."set_assignee_name"();
CREATE OR REPLACE TRIGGER "trg_set_brand_name" BEFORE INSERT OR UPDATE OF "brand_uuid" ON "public"."brand_tasks" FOR EACH ROW EXECUTE FUNCTION "public"."set_brand_name"();
CREATE OR REPLACE TRIGGER "trg_set_unique_category_name" BEFORE INSERT OR UPDATE ON "public"."retailer_gnf_category_matching" FOR EACH ROW EXECUTE FUNCTION "public"."set_unique_category_name"();
CREATE OR REPLACE TRIGGER "trg_sync_profile_photo" AFTER UPDATE OF "profile_photo" ON "public"."team_member_guide" FOR EACH ROW WHEN (("old"."profile_photo" IS DISTINCT FROM "new"."profile_photo")) EXECUTE FUNCTION "public"."sync_team_member_photo_to_profile"();
CREATE OR REPLACE TRIGGER "trg_task_pipeline_before_insert" BEFORE INSERT ON "public"."task_pipeline" FOR EACH ROW EXECUTE FUNCTION "public"."trg_task_pipeline_inserts"();
CREATE OR REPLACE TRIGGER "trg_task_pipeline_before_update" BEFORE UPDATE ON "public"."task_pipeline" FOR EACH ROW EXECUTE FUNCTION "public"."trg_task_pipeline_updates"();
CREATE OR REPLACE TRIGGER "trg_update_activity_name" BEFORE INSERT OR UPDATE OF "brand", "account" ON "public"."activity_tracker" FOR EACH ROW EXECUTE FUNCTION "public"."update_activity_name"();
CREATE OR REPLACE TRIGGER "trg_update_name_and_title" AFTER INSERT OR UPDATE OF "first_name", "last_name", "job_title" ON "public"."contacts" FOR EACH ROW EXECUTE FUNCTION "public"."update_name_and_title"();
CREATE OR REPLACE TRIGGER "trg_update_names_from_categories" AFTER INSERT OR DELETE OR UPDATE ON "public"."jt_retailer_category_to_gn_categories" FOR EACH ROW EXECUTE FUNCTION "public"."update_affected_review_names_from_categories"();
CREATE OR REPLACE TRIGGER "trg_update_names_from_matching" AFTER INSERT OR DELETE OR UPDATE ON "public"."jt_master_category_review_data_matching" FOR EACH ROW EXECUTE FUNCTION "public"."update_affected_review_names_from_matching"();
CREATE OR REPLACE TRIGGER "trg_update_program_field" BEFORE INSERT OR UPDATE ON "public"."sos_authorizations" FOR EACH ROW EXECUTE FUNCTION "public"."update_program_field"();
CREATE OR REPLACE TRIGGER "trg_update_promo_name" BEFORE INSERT OR UPDATE ON "public"."master_promo_data" FOR EACH ROW EXECUTE FUNCTION "public"."update_promo_name"();
CREATE OR REPLACE TRIGGER "trg_update_review_data_name" BEFORE INSERT OR UPDATE ON "public"."master_category_review_data" FOR EACH ROW EXECUTE FUNCTION "public"."update_review_data_name"();
CREATE OR REPLACE TRIGGER "trg_update_review_names_from_category" AFTER UPDATE ON "public"."master_categories" FOR EACH ROW EXECUTE FUNCTION "public"."update_review_names_when_category_changes"();
CREATE OR REPLACE TRIGGER "trg_update_sos_authorizations_connects_achieved" AFTER INSERT OR DELETE OR UPDATE OF "connect_count", "sos_authorizations" ON "public"."activity_tracker" FOR EACH ROW EXECUTE FUNCTION "public"."update_sos_authorizations_connects_achieved"();
CREATE OR REPLACE TRIGGER "trigger_demos_updated_at" BEFORE UPDATE ON "public"."demos" FOR EACH ROW EXECUTE FUNCTION "public"."update_demos_updated_at"();
CREATE OR REPLACE TRIGGER "trigger_sync_onboarding_insert" AFTER INSERT ON "public"."brands" FOR EACH ROW WHEN (("new"."status" @> '{Onboarding}'::"public"."Brand Status"[])) EXECUTE FUNCTION "public"."sync_brand_onboarding_tasks"();
ALTER TABLE "public"."brands" DISABLE TRIGGER "trigger_sync_onboarding_insert";
CREATE OR REPLACE TRIGGER "trigger_sync_onboarding_update" AFTER UPDATE ON "public"."brands" FOR EACH ROW WHEN ((("new"."services" IS DISTINCT FROM "old"."services") OR (("new"."status" @> '{Onboarding}'::"public"."Brand Status"[]) AND (NOT ("old"."status" @> '{Onboarding}'::"public"."Brand Status"[]))))) EXECUTE FUNCTION "public"."sync_brand_onboarding_tasks"();
ALTER TABLE "public"."brands" DISABLE TRIGGER "trigger_sync_onboarding_update";
CREATE OR REPLACE TRIGGER "update_brand_distribution_grid_last_updated" BEFORE UPDATE ON "public"."brand_distribution_grid" FOR EACH ROW EXECUTE FUNCTION "public"."update_last_updated_column"();
ALTER TABLE "public"."brand_distribution_grid" DISABLE TRIGGER "update_brand_distribution_grid_last_updated";
CREATE OR REPLACE TRIGGER "update_brand_promotions_last_updated" BEFORE UPDATE ON "public"."brand_promotions" FOR EACH ROW EXECUTE FUNCTION "public"."update_last_updated_column"();
CREATE OR REPLACE TRIGGER "update_hh_licenses_updated_at" BEFORE UPDATE ON "public"."hh_licenses" FOR EACH ROW EXECUTE FUNCTION "public"."update_updated_at_column"();
CREATE OR REPLACE TRIGGER "update_planned_submissions_last_updated" BEFORE UPDATE ON "public"."planned_submissions" FOR EACH ROW EXECUTE FUNCTION "public"."update_last_updated_column"();
CREATE OR REPLACE TRIGGER "update_task_completed_date" BEFORE UPDATE ON "public"."brand_tasks" FOR EACH ROW EXECUTE FUNCTION "public"."handle_task_status_change"();
ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_default_deal_stage_fkey" FOREIGN KEY ("default_deal_stage") REFERENCES "public"."ref_deal_stage"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_ref_account_type_fkey" FOREIGN KEY ("account_type") REFERENCES "public"."ref_account_type"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_accounts_team_member_guide"
    ADD CONSTRAINT "accounts_team_members_account_uuid_fkey" FOREIGN KEY ("account_uuid") REFERENCES "public"."accounts"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_accounts_team_member_guide"
    ADD CONSTRAINT "accounts_team_members_team_member_uuid_fkey" FOREIGN KEY ("team_member_uuid") REFERENCES "public"."team_member_guide"("uuid") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "activity_tracker_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE;
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "activity_tracker_assign_for_follow_up_fkey" FOREIGN KEY ("assign_for_follow_up") REFERENCES "public"."team_member_guide"("uuid") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "activity_tracker_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands"("id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "activity_tracker_deal_stage_fkey" FOREIGN KEY ("deal_stage") REFERENCES "public"."ref_deal_stage"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "activity_tracker_last_modified_by_fkey" FOREIGN KEY ("last_modified_by") REFERENCES "auth"."users"("id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."activity_tracker_migration"
    ADD CONSTRAINT "activity_tracker_migration_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE;
ALTER TABLE ONLY "public"."activity_tracker_migration"
    ADD CONSTRAINT "activity_tracker_migration_assign_for_follow_up_fkey" FOREIGN KEY ("assign_for_follow_up") REFERENCES "public"."team_member_guide"("uuid");
ALTER TABLE ONLY "public"."activity_tracker_migration"
    ADD CONSTRAINT "activity_tracker_migration_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands"("id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."activity_tracker_migration"
    ADD CONSTRAINT "activity_tracker_migration_sos_authorizations_fkey" FOREIGN KEY ("sos_authorizations") REFERENCES "public"."sos_authorizations"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."activity_tracker_migration"
    ADD CONSTRAINT "activity_tracker_migration_sos_call_team_fkey" FOREIGN KEY ("sos_call_team") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "activity_tracker_sos_authorizations_fkey" FOREIGN KEY ("sos_authorizations") REFERENCES "public"."sos_authorizations"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."activity_tracker"
    ADD CONSTRAINT "activity_tracker_sos_call_team_fkey" FOREIGN KEY ("sos_call_team") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_associated_skus"
    ADD CONSTRAINT "associated_skus_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_associated_skus"
    ADD CONSTRAINT "associated_skus_sku_id_fkey" FOREIGN KEY ("sku_id") REFERENCES "public"."spec_price_sheet"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_contacts_table"
    ADD CONSTRAINT "brand_contacts_table_company_fkey" FOREIGN KEY ("company") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_contacts_table_migration"
    ADD CONSTRAINT "brand_contacts_table_migration_company_fkey" FOREIGN KEY ("company") REFERENCES "public"."brands_migration"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_distribution_grid"
    ADD CONSTRAINT "brand_distribution_grid_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_distribution_grid"
    ADD CONSTRAINT "brand_distribution_grid_distributor_hq_fkey" FOREIGN KEY ("distributor_hq") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_distribution_grid"
    ADD CONSTRAINT "brand_distribution_grid_item_name_fkey" FOREIGN KEY ("item_name") REFERENCES "public"."spec_price_sheet"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."brand_distribution_grid"
    ADD CONSTRAINT "brand_distribution_grid_warehouse_dc_fkey1" FOREIGN KEY ("warehouse_dc") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_brand_events"
    ADD CONSTRAINT "brand_event_attendance_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_brand_events"
    ADD CONSTRAINT "brand_event_attendance_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "public"."events"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."brand_focus_assignments"
    ADD CONSTRAINT "brand_focus_assignments_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_focus_assignments"
    ADD CONSTRAINT "brand_focus_assignments_team_member_fkey" FOREIGN KEY ("team_member") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."brand_focus_assignments"
    ADD CONSTRAINT "brand_focus_assignments_team_member_fkey1" FOREIGN KEY ("team_member") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_portal_credentials"
    ADD CONSTRAINT "brand_portal_credentials_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_portal_credentials"
    ADD CONSTRAINT "brand_portal_credentials_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_portal_credentials_migration"
    ADD CONSTRAINT "brand_portal_credentials_migration_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts_migration"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_portal_credentials_migration"
    ADD CONSTRAINT "brand_portal_credentials_migration_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands_migration"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_promo_requests (Deprecated)"
    ADD CONSTRAINT "brand_promo_requests_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id");
ALTER TABLE ONLY "public"."brand_promo_requests (Deprecated)"
    ADD CONSTRAINT "brand_promo_requests_distributor_id_fkey" FOREIGN KEY ("distributor_id") REFERENCES "public"."accounts"("uuid");
ALTER TABLE ONLY "public"."brand_promo_requests (Deprecated)"
    ADD CONSTRAINT "brand_promo_requests_retailer_id_fkey" FOREIGN KEY ("retailer_id") REFERENCES "public"."accounts"("uuid");
ALTER TABLE ONLY "public"."jt_brand_promotion_skus"
    ADD CONSTRAINT "brand_promotion_skus_brand_promotion_id_fkey" FOREIGN KEY ("brand_promotion_id") REFERENCES "public"."brand_promotions"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_brand_promotion_skus"
    ADD CONSTRAINT "brand_promotion_skus_sku_id_fkey" FOREIGN KEY ("sku_id") REFERENCES "public"."spec_price_sheet"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."brand_promotions"
    ADD CONSTRAINT "brand_promotions_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_promotions"
    ADD CONSTRAINT "brand_promotions_distribution_fkey" FOREIGN KEY ("distribution") REFERENCES "public"."ref_brand_promo_table_distributors"("id") ON UPDATE CASCADE;
ALTER TABLE ONLY "public"."brand_promotions"
    ADD CONSTRAINT "brand_promotions_master_promo_id_fkey" FOREIGN KEY ("master_promo_id") REFERENCES "public"."master_promo_data"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_promotions"
    ADD CONSTRAINT "brand_promotions_promo_type_fkey" FOREIGN KEY ("promo_type") REFERENCES "public"."ref_promo_types"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_promotions"
    ADD CONSTRAINT "brand_promotions_retailer_id_fkey" FOREIGN KEY ("retailer_id") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_sync_call_schedule"
    ADD CONSTRAINT "brand_sync_call_schedule_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_tasks"
    ADD CONSTRAINT "brand_task__brand_uuid_fkey" FOREIGN KEY ("brand_uuid") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_tasks"
    ADD CONSTRAINT "brand_tasks_assignee_user_id_fkey" FOREIGN KEY ("assignee_user_id") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."brand_tasks"
    ADD CONSTRAINT "brand_tasks_template_uuid_fkey" FOREIGN KEY ("template_uuid") REFERENCES "public"."brand_task_templates"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."deal_activity_comments"
    ADD CONSTRAINT "comments_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "public"."activity_tracker"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."deal_activity_comments"
    ADD CONSTRAINT "comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."contacts_migration"
    ADD CONSTRAINT "contacts_migration_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts_migration"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_spec_price_sheet"
    ADD CONSTRAINT "deal_associated_skus_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "public"."activity_tracker"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_deal_spec_price_sheet"
    ADD CONSTRAINT "deal_associated_skus_sku_id_fkey" FOREIGN KEY ("sku_id") REFERENCES "public"."spec_price_sheet"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."deal_stage_history"
    ADD CONSTRAINT "deal_stage_history_activity_id_fkey" FOREIGN KEY ("activity_id") REFERENCES "public"."activity_tracker"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."deal_stage_history"
    ADD CONSTRAINT "deal_stage_history_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "auth"."users"("id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."deal_stage_history"
    ADD CONSTRAINT "deal_stage_history_new_deal_stage_ref_fkey" FOREIGN KEY ("new_deal_stage_ref") REFERENCES "public"."ref_deal_stage"("uuid") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."deal_stage_history"
    ADD CONSTRAINT "deal_stage_history_old_deal_stage_ref_fkey" FOREIGN KEY ("old_deal_stage_ref") REFERENCES "public"."ref_deal_stage"("uuid") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."demos"
    ADD CONSTRAINT "demos_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid");
ALTER TABLE ONLY "public"."demos_migration"
    ADD CONSTRAINT "demos_migration_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts_migration"("uuid");
ALTER TABLE ONLY "public"."demos_migration"
    ADD CONSTRAINT "demos_migration_team_member_id_fkey" FOREIGN KEY ("team_member_id") REFERENCES "public"."team_member_guide_migration"("uuid");
ALTER TABLE ONLY "public"."demos"
    ADD CONSTRAINT "demos_team_member_id_fkey" FOREIGN KEY ("team_member_id") REFERENCES "public"."team_member_guide"("uuid");
ALTER TABLE ONLY "public"."brand_documents"
    ADD CONSTRAINT "documents_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "auth"."users"("id");
ALTER TABLE ONLY "public"."brand_documents"
    ADD CONSTRAINT "documents_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."events"
    ADD CONSTRAINT "events_gn_participation_status_fkey" FOREIGN KEY ("gn_participation_status") REFERENCES "public"."ref_goodnow_event _participation_status"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."spec_price_sheet"
    ADD CONSTRAINT "fk_brand" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_owners"
    ADD CONSTRAINT "fk_deal_id" FOREIGN KEY ("deal_id") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_team_members_x_events"
    ADD CONSTRAINT "fk_event" FOREIGN KEY ("event_id") REFERENCES "public"."events"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_retailer_category_to_gn_categories"
    ADD CONSTRAINT "fk_gn_category" FOREIGN KEY ("gn_category_id") REFERENCES "public"."master_categories"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_master_categories_brands"
    ADD CONSTRAINT "fk_master_categories_brands_brand" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_master_categories_brands"
    ADD CONSTRAINT "fk_master_categories_brands_category" FOREIGN KEY ("master_category_id") REFERENCES "public"."master_categories"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."master_category_review_data"
    ADD CONSTRAINT "fk_master_category" FOREIGN KEY ("master_category_id") REFERENCES "public"."master_categories"("id");
ALTER TABLE ONLY "public"."team_member_guide"
    ADD CONSTRAINT "fk_profiles_user" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_retailer_category_to_gn_categories"
    ADD CONSTRAINT "fk_retailer_category" FOREIGN KEY ("retailer_category_id") REFERENCES "public"."retailer_gnf_category_matching"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_master_category_review_data_brands"
    ADD CONSTRAINT "fk_review_data_brands_brand" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_master_category_review_data_brands"
    ADD CONSTRAINT "fk_review_data_brands_review" FOREIGN KEY ("review_data_id") REFERENCES "public"."master_category_review_data"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_master_category_review_data_matching"
    ADD CONSTRAINT "fk_review_matching_retailer" FOREIGN KEY ("retailer_matching_id") REFERENCES "public"."retailer_gnf_category_matching"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_master_category_review_data_matching"
    ADD CONSTRAINT "fk_review_matching_review" FOREIGN KEY ("review_data_id") REFERENCES "public"."master_category_review_data"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_team_members_x_events"
    ADD CONSTRAINT "fk_team_member" FOREIGN KEY ("team_member_id") REFERENCES "public"."team_member_guide"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."folders"
    ADD CONSTRAINT "folders_brand_id_fkey1" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id");
ALTER TABLE ONLY "public"."folders"
    ADD CONSTRAINT "folders_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."folders"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."harvesthub_documents"
    ADD CONSTRAINT "harvesthub_documents_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "auth"."users"("id");
ALTER TABLE ONLY "public"."harvesthub_documents"
    ADD CONSTRAINT "harvesthub_documents_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."hh_contributions"
    ADD CONSTRAINT "hh_contributions_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid");
ALTER TABLE ONLY "public"."hh_contributions"
    ADD CONSTRAINT "hh_contributions_category_review_id_fkey" FOREIGN KEY ("category_review_id") REFERENCES "public"."master_category_review_data"("id");
ALTER TABLE ONLY "public"."hh_contributions"
    ADD CONSTRAINT "hh_contributions_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."hh_customers"("id");
ALTER TABLE ONLY "public"."hh_contributions_migration"
    ADD CONSTRAINT "hh_contributions_migration_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts_migration"("uuid");
ALTER TABLE ONLY "public"."hh_customers"
    ADD CONSTRAINT "hh_customers_customer_status_fkey" FOREIGN KEY ("customer_status") REFERENCES "public"."ref_hh_customer_status"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."hh_customers"
    ADD CONSTRAINT "hh_customers_hh_license_fkey" FOREIGN KEY ("hh_license") REFERENCES "public"."hh_licenses"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."hh_customers"
    ADD CONSTRAINT "hh_customers_lead_source_fkey" FOREIGN KEY ("lead_source") REFERENCES "public"."ref_hh_lead_source"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."hh_customers_migration"
    ADD CONSTRAINT "hh_customers_migration_customer_status_fkey" FOREIGN KEY ("customer_status") REFERENCES "public"."ref_hh_customer_status"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."hh_customers_migration"
    ADD CONSTRAINT "hh_customers_migration_hh_license_fkey" FOREIGN KEY ("hh_license") REFERENCES "public"."hh_licenses"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."hh_customers_migration"
    ADD CONSTRAINT "hh_customers_migration_lead_source_fkey" FOREIGN KEY ("lead_source") REFERENCES "public"."ref_hh_lead_source"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."hh_customers_migration"
    ADD CONSTRAINT "hh_customers_migration_modified_by_fkey" FOREIGN KEY ("modified_by") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."hh_customers"
    ADD CONSTRAINT "hh_customers_modified_by_fkey" FOREIGN KEY ("modified_by") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."hh_deals"
    ADD CONSTRAINT "hh_deals_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."hh_deals_migration"
    ADD CONSTRAINT "hh_deals_migration_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts_migration"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."hh_deals"
    ADD CONSTRAINT "hh_deals_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "public"."hh_customers"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."hh_prospect_customers"
    ADD CONSTRAINT "hh_prospect_customers_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."hh_customers"("id");
ALTER TABLE ONLY "public"."jt_active_account_distribution_grid"
    ADD CONSTRAINT "jt_active_account_distribution_grid_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_active_account_distribution_grid"
    ADD CONSTRAINT "jt_active_account_distribution_grid_distribution_grid_id_fkey" FOREIGN KEY ("distribution_grid_id") REFERENCES "public"."brand_distribution_grid"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_active_services"
    ADD CONSTRAINT "jt_active_services_ref_brands_fkey" FOREIGN KEY ("brands") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_active_services"
    ADD CONSTRAINT "jt_active_services_ref_ref_active_services_fkey" FOREIGN KEY ("ref_active_services") REFERENCES "public"."ref_active_services"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_activity_note_mentions"
    ADD CONSTRAINT "jt_activity_note_mentions_activity_id_fkey" FOREIGN KEY ("activity_id") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_comment_mentions"
    ADD CONSTRAINT "jt_activity_note_mentions_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "public"."deal_activity_comments"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_activity_note_mentions"
    ADD CONSTRAINT "jt_activity_note_mentions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."team_member_guide"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_ref_applied_services"
    ADD CONSTRAINT "jt_applied_services_ref_brand_task_templates_fkey" FOREIGN KEY ("brand_task_templates") REFERENCES "public"."brand_task_templates"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_applied_services"
    ADD CONSTRAINT "jt_applied_services_ref_ref_active_services_fkey" FOREIGN KEY ("ref_active_services") REFERENCES "public"."ref_active_services"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_brand_events_migration"
    ADD CONSTRAINT "jt_brand_events_migration_brand_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands_migration"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_brand_events_migration"
    ADD CONSTRAINT "jt_brand_events_migration_event_fkey" FOREIGN KEY ("event_id") REFERENCES "public"."events_migration"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_brand_promo_request_skus"
    ADD CONSTRAINT "jt_brand_promo_request_skus_brand_promo_request_id_fkey" FOREIGN KEY ("brand_promo_request_id") REFERENCES "public"."brand_promo_requests (Deprecated)"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_brand_promo_request_skus"
    ADD CONSTRAINT "jt_brand_promo_request_skus_sku_id_fkey" FOREIGN KEY ("sku_id") REFERENCES "public"."spec_price_sheet"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_ref_brand_status"
    ADD CONSTRAINT "jt_brand_status_ref_brands_fkey" FOREIGN KEY ("brands") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_brand_status"
    ADD CONSTRAINT "jt_brand_status_ref_ref_brand_status_fkey" FOREIGN KEY ("ref_brand_status") REFERENCES "public"."ref_brand_status"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_category_review_contacts"
    ADD CONSTRAINT "jt_category_review_contacts_category_review_id_fkey" FOREIGN KEY ("category_review_id") REFERENCES "public"."master_category_review_data"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_category_review_contacts"
    ADD CONSTRAINT "jt_category_review_contacts_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "public"."contacts"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_deal_comment_mentions"
    ADD CONSTRAINT "jt_comment_mentions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_contacts_categories_managed"
    ADD CONSTRAINT "jt_contacts_categories_managed_master_category_id_fkey" FOREIGN KEY ("master_category_id") REFERENCES "public"."master_categories"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_contacts_categories_managed"
    ADD CONSTRAINT "jt_contacts_categories_managed_master_category_review_id_fkey" FOREIGN KEY ("master_category_review_id") REFERENCES "public"."master_category_review_data"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_contacts_distributor_rep_accounts"
    ADD CONSTRAINT "jt_contacts_distributor_rep_accounts_account_uuid_fkey" FOREIGN KEY ("account_uuid") REFERENCES "public"."accounts"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_contacts_distributor_rep_accounts"
    ADD CONSTRAINT "jt_contacts_distributor_rep_accounts_contacts_uuid_fkey" FOREIGN KEY ("contacts_uuid") REFERENCES "public"."contacts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_contacts_categories_managed"
    ADD CONSTRAINT "jt_contacts_master_categories_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "public"."contacts"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_ref_coverage"
    ADD CONSTRAINT "jt_coverage_ref_brands_fkey" FOREIGN KEY ("brands") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_coverage"
    ADD CONSTRAINT "jt_coverage_ref_ref_coverage_fkey" FOREIGN KEY ("ref_coverage") REFERENCES "public"."ref_coverage"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_distribution"
    ADD CONSTRAINT "jt_deal+distribution_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_distribution"
    ADD CONSTRAINT "jt_deal+distribution_distribution_id_fkey" FOREIGN KEY ("distribution_id") REFERENCES "public"."jt_active_account_distribution_grid"("id");
ALTER TABLE ONLY "public"."jt_deal_category_reviews"
    ADD CONSTRAINT "jt_deal_category_reviews_activity_tracker_fkey" FOREIGN KEY ("activity_tracker") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_deal_category_reviews"
    ADD CONSTRAINT "jt_deal_category_reviews_category_reviews_fkey" FOREIGN KEY ("category_reviews") REFERENCES "public"."master_category_review_data"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_deal_category_reviews"
    ADD CONSTRAINT "jt_deal_category_reviews_submitted_by_fkey" FOREIGN KEY ("submitted_by") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_owners"
    ADD CONSTRAINT "jt_deal_owners_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_owners"
    ADD CONSTRAINT "jt_deal_owners_team_member_id_fkey" FOREIGN KEY ("team_member_id") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_task_pipeline"
    ADD CONSTRAINT "jt_deal_task_pipeline_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_deal_task_pipeline"
    ADD CONSTRAINT "jt_deal_task_pipeline_task_id_fkey" FOREIGN KEY ("task_id") REFERENCES "public"."task_pipeline"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_demo_brands"
    ADD CONSTRAINT "jt_demo_brands_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_demo_brands"
    ADD CONSTRAINT "jt_demo_brands_demo_id_fkey" FOREIGN KEY ("demo_id") REFERENCES "public"."demos"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_accounts_distribution"
    ADD CONSTRAINT "jt_distributor_accounts_distributor_account_id_fkey" FOREIGN KEY ("distributor_account_id") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_accounts_distribution"
    ADD CONSTRAINT "jt_distributor_accounts_retail_account_id_fkey" FOREIGN KEY ("retail_account_id") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_hh_customers_accounts_deals"
    ADD CONSTRAINT "jt_hh_customers_accounts_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_hh_customers_accounts_deals"
    ADD CONSTRAINT "jt_hh_customers_accounts_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."hh_customers"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_hh_customers_category_reviews"
    ADD CONSTRAINT "jt_hh_customers_category_reviews_category_review_id_fkey" FOREIGN KEY ("category_review_id") REFERENCES "public"."master_category_review_data"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_hh_customers_category_reviews"
    ADD CONSTRAINT "jt_hh_customers_category_reviews_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."hh_customers"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_hh_customers_licenses(deprecated)"
    ADD CONSTRAINT "jt_hh_customers_licenses_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."hh_customers"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_hh_customers_licenses(deprecated)"
    ADD CONSTRAINT "jt_hh_customers_licenses_license_id_fkey" FOREIGN KEY ("license_id") REFERENCES "public"."hh_licenses"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_hh_customers_master_categories"
    ADD CONSTRAINT "jt_hh_customers_master_categories_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."hh_customers"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_hh_customers_master_categories"
    ADD CONSTRAINT "jt_hh_customers_master_categories_master_category_id_fkey" FOREIGN KEY ("master_category_id") REFERENCES "public"."master_categories"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_master_categories_brands_migration"
    ADD CONSTRAINT "jt_master_categories_brands_mig_brand_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands_migration"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_master_categories_brands_migration"
    ADD CONSTRAINT "jt_master_categories_brands_mig_category_fkey" FOREIGN KEY ("master_category_id") REFERENCES "public"."master_categories_migration"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_matched_brands_to_category_reviews"
    ADD CONSTRAINT "jt_matched_brands_to_category_reviews_brand_match_id_fkey" FOREIGN KEY ("brand_match_id") REFERENCES "public"."jt_master_categories_brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_matched_brands_to_category_reviews"
    ADD CONSTRAINT "jt_matched_brands_to_category_reviews_review_id_fkey" FOREIGN KEY ("review_id") REFERENCES "public"."master_category_review_data"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_principal_list_product_images"
    ADD CONSTRAINT "jt_principal_list_product_images_brand_document_id_fkey" FOREIGN KEY ("brand_document_id") REFERENCES "public"."brand_documents"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_principal_list_product_images"
    ADD CONSTRAINT "jt_principal_list_product_images_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_accounts_category_review_received_status"
    ADD CONSTRAINT "jt_ref_accounts_category_review_received_status_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_accounts_flag_for_attention"
    ADD CONSTRAINT "jt_ref_accounts_flag_for_attention_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_accounts_flag_for_attention"
    ADD CONSTRAINT "jt_ref_accounts_flag_for_attention_flag_for_attention_fkey" FOREIGN KEY ("flag_for_attention") REFERENCES "public"."ref_account_flag_for_attention_enum"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_announcement_tag"
    ADD CONSTRAINT "jt_ref_announcement_tag_company_announcements_fkey" FOREIGN KEY ("company_announcements") REFERENCES "public"."company_announcements"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_announcement_tag"
    ADD CONSTRAINT "jt_ref_announcement_tag_ref_announcement_tag_fkey" FOREIGN KEY ("ref_announcement_tag") REFERENCES "public"."ref_announcement_tag"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_brand_attention_flag"
    ADD CONSTRAINT "jt_ref_brand_attention_flag_brands_fkey" FOREIGN KEY ("brands") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_brand_attention_flag"
    ADD CONSTRAINT "jt_ref_brand_attention_flag_ref_brand_attention_flag_fkey" FOREIGN KEY ("ref_brand_attention_flag") REFERENCES "public"."ref_brand_attention_flag_enum"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_brand_audience_tag"
    ADD CONSTRAINT "jt_ref_brand_audience_tag_company_announcements_fkey" FOREIGN KEY ("company_announcements") REFERENCES "public"."company_announcements"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_brand_audience_tag"
    ADD CONSTRAINT "jt_ref_brand_audience_tag_ref_brand_audience_tag_fkey" FOREIGN KEY ("ref_brand_audience_tag") REFERENCES "public"."ref_brand_audience_tag"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_categories_for_principal_list"
    ADD CONSTRAINT "jt_ref_categories_for_principal_list_brands_fkey" FOREIGN KEY ("brands") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_accounts_category_review_received_status"
    ADD CONSTRAINT "jt_ref_category_review_receiv_category_review_received_sta_fkey" FOREIGN KEY ("category_review_received_status") REFERENCES "public"."ref_category_review_received_status"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_contact_department_tags"
    ADD CONSTRAINT "jt_ref_contact_department_tags_contacts_fkey" FOREIGN KEY ("contacts") REFERENCES "public"."contacts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_contact_department_tags"
    ADD CONSTRAINT "jt_ref_contact_department_tags_ref_contact_department_tags_fkey" FOREIGN KEY ("ref_contact_department_tags") REFERENCES "public"."ref_contact_department_tags"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_contacts_flag_for_attention"
    ADD CONSTRAINT "jt_ref_contacts_flag_for_atte_ref_contacts_flag_for_attent_fkey" FOREIGN KEY ("ref_contacts_flag_for_attention") REFERENCES "public"."ref_contacts_flag_for_attention"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_contacts_flag_for_attention"
    ADD CONSTRAINT "jt_ref_contacts_flag_for_attention_contacts_fkey" FOREIGN KEY ("contacts") REFERENCES "public"."contacts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_departments"
    ADD CONSTRAINT "jt_ref_departments_ref_departments_fkey" FOREIGN KEY ("ref_departments") REFERENCES "public"."ref_departments"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_departments"
    ADD CONSTRAINT "jt_ref_departments_team_member_guide_fkey" FOREIGN KEY ("team_member_guide") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_hh_community_expert_services_offered"
    ADD CONSTRAINT "jt_ref_hh_community_expert_se_harvesthub_community_experts_fkey" FOREIGN KEY ("harvesthub_community_experts") REFERENCES "public"."hh_community_experts"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_hh_community_expert_services_offered"
    ADD CONSTRAINT "jt_ref_hh_community_expert_se_ref_hh_community_expert_serv_fkey" FOREIGN KEY ("ref_hh_community_expert_services_offered") REFERENCES "public"."ref_hh_community_expert_services_offered"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_hh_expert_services_offered"
    ADD CONSTRAINT "jt_ref_hh_expert_services_off_ref_hh_expert_services_offer_fkey" FOREIGN KEY ("ref_hh_expert_services_offered") REFERENCES "public"."ref_hh_expert_services_offered"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_hh_expert_services_offered"
    ADD CONSTRAINT "jt_ref_hh_expert_services_offered_hh_experts_fkey" FOREIGN KEY ("hh_experts") REFERENCES "public"."hh_account_experts"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_accounts_industry_tags"
    ADD CONSTRAINT "jt_ref_industry_tags_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_accounts_industry_tags"
    ADD CONSTRAINT "jt_ref_industry_tags_industry_tag_fkey" FOREIGN KEY ("industry_tag") REFERENCES "public"."ref_industry_tag"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_no_contact_details"
    ADD CONSTRAINT "jt_ref_no_contact_details_contacts_fkey" FOREIGN KEY ("contacts") REFERENCES "public"."contacts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_no_contact_details"
    ADD CONSTRAINT "jt_ref_no_contact_details_ref_no_contact_details_fkey" FOREIGN KEY ("ref_no_contact_details") REFERENCES "public"."ref_no_contact_details"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_product_sub_category"
    ADD CONSTRAINT "jt_ref_product_sub_category_brands_fkey" FOREIGN KEY ("brands") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_product_sub_category"
    ADD CONSTRAINT "jt_ref_product_sub_category_ref_product_sub_category_id_fkey" FOREIGN KEY ("ref_product_sub_category_id") REFERENCES "public"."ref_product_subcategory_enum"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_sos_program_type"
    ADD CONSTRAINT "jt_ref_sos_program_type_ref_sos_program_type_fkey" FOREIGN KEY ("ref_sos_program_type") REFERENCES "public"."ref_sos_program_type"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_sos_program_type"
    ADD CONSTRAINT "jt_ref_sos_program_type_sos_authorizations_fkey" FOREIGN KEY ("sos_authorizations") REFERENCES "public"."sos_authorizations"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_spec_price_sheet_categories"
    ADD CONSTRAINT "jt_spec_price_sheet_categories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."master_categories"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_spec_price_sheet_categories"
    ADD CONSTRAINT "jt_spec_price_sheet_categories_sku_id_fkey" FOREIGN KEY ("sku_id") REFERENCES "public"."spec_price_sheet"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_ref_sub_tags"
    ADD CONSTRAINT "jt_sub_tags_ref_accounts_fkey" FOREIGN KEY ("accounts") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_ref_sub_tags"
    ADD CONSTRAINT "jt_sub_tags_ref_sub_tag_reference_table_fkey" FOREIGN KEY ("sub_tag_reference_table") REFERENCES "public"."ref_sub_tags"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_sync_up_notes_accounts"
    ADD CONSTRAINT "jt_sync_up_notes_accounts_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_sync_up_notes_accounts"
    ADD CONSTRAINT "jt_sync_up_notes_accounts_note_id_fkey" FOREIGN KEY ("note_id") REFERENCES "public"."syncup_notes"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_sync_up_notes_brands"
    ADD CONSTRAINT "jt_sync_up_notes_brands_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_sync_up_notes_brands"
    ADD CONSTRAINT "jt_sync_up_notes_brands_note_id_fkey" FOREIGN KEY ("note_id") REFERENCES "public"."syncup_notes"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_user_role_dept"
    ADD CONSTRAINT "jt_user_role_dept_dept_id_fkey" FOREIGN KEY ("dept_id") REFERENCES "public"."team_member_dept"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_user_role_dept"
    ADD CONSTRAINT "jt_user_role_dept_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."master_categories"
    ADD CONSTRAINT "master_categories_ref_department_tags_uuid_fkey" FOREIGN KEY ("ref_department_tags_uuid") REFERENCES "public"."ref_contact_department_tags"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."master_category_review_data"
    ADD CONSTRAINT "master_category_review_data_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."master_category_review_data"
    ADD CONSTRAINT "master_category_review_data_cr_review_type_fkey" FOREIGN KEY ("cr_review_type") REFERENCES "public"."ref_category_review_type"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."master_category_review_data"
    ADD CONSTRAINT "master_category_review_data_gnf_sub_category_fkey" FOREIGN KEY ("gnf_sub_category") REFERENCES "public"."master_categories"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."master_category_review_data_migration"
    ADD CONSTRAINT "master_category_review_data_migration_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts_migration"("uuid");
ALTER TABLE ONLY "public"."master_category_review_data_migration"
    ADD CONSTRAINT "master_category_review_data_migration_master_category_id_fkey" FOREIGN KEY ("master_category_id") REFERENCES "public"."master_categories_migration"("uuid");
ALTER TABLE ONLY "public"."master_category_review_data"
    ADD CONSTRAINT "master_category_review_data_retailer_gnf_category_matching_fkey" FOREIGN KEY ("retailer_gnf_category_matching") REFERENCES "public"."retailer_gnf_category_matching"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."master_promo_data"
    ADD CONSTRAINT "master_promo_data_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."master_promo_data"
    ADD CONSTRAINT "master_promo_data_department_fkey" FOREIGN KEY ("department") REFERENCES "public"."ref_contact_department_tags"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."master_promo_data"
    ADD CONSTRAINT "master_promo_data_promotion_type_fkey" FOREIGN KEY ("promotion_type") REFERENCES "public"."ref_promo_types"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_recipient_id_fkey2" FOREIGN KEY ("recipient_id") REFERENCES "public"."team_member_guide"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."planned_submissions"
    ADD CONSTRAINT "planned_reviews_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."planned_submissions"
    ADD CONSTRAINT "planned_submissions_category_review_fkey" FOREIGN KEY ("category_review") REFERENCES "public"."master_category_review_data"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."planned_submissions"
    ADD CONSTRAINT "planned_submissions_submitted_by_fkey" FOREIGN KEY ("submitted_by") REFERENCES "auth"."users"("id");
ALTER TABLE ONLY "public"."planned_submissions"
    ADD CONSTRAINT "planned_submissions_user_fkey" FOREIGN KEY ("user") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."prospects (deprecated)"
    ADD CONSTRAINT "prospects_team_member_id UUID;_fkey" FOREIGN KEY ("team_member_id") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."retailer_gnf_category_matching"
    ADD CONSTRAINT "retailer_gnf_category_matching_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."retailer_gnf_category_matching_migration"
    ADD CONSTRAINT "retailer_gnf_category_matching_migration_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts_migration"("uuid");
ALTER TABLE ONLY "public"."sample_shipment_tracking"
    ADD CONSTRAINT "sample_shipment_tracking_deals_id_fkey" FOREIGN KEY ("deals_id") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sku_account_distribution"
    ADD CONSTRAINT "sku_account_distribution_account_fkey" FOREIGN KEY ("account") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sku_account_distribution"
    ADD CONSTRAINT "sku_account_distribution_dc_warehouse_fkey" FOREIGN KEY ("dc_warehouse") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sku_account_distribution"
    ADD CONSTRAINT "sku_account_distribution_distribution_grid_fkey" FOREIGN KEY ("distribution_grid") REFERENCES "public"."brand_distribution_grid"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."sku_account_distribution"
    ADD CONSTRAINT "sku_account_distribution_distributor_hq_fkey" FOREIGN KEY ("distributor_hq") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sku_account_distribution"
    ADD CONSTRAINT "sku_account_distribution_item_name_fkey" FOREIGN KEY ("item_name") REFERENCES "public"."brand_distribution_grid"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."sku_placements"
    ADD CONSTRAINT "sku_placements_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sku_placements"
    ADD CONSTRAINT "sku_placements_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sku_placements"
    ADD CONSTRAINT "sku_placements_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "public"."activity_tracker"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."sku_placements"
    ADD CONSTRAINT "sku_placements_sku_id_fkey" FOREIGN KEY ("sku_id") REFERENCES "public"."spec_price_sheet"("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."sku_product_category"
    ADD CONSTRAINT "sku_product_category_Product Category_fkey" FOREIGN KEY ("product_category") REFERENCES "public"."master_categories"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sku_product_category"
    ADD CONSTRAINT "sku_product_category_brand_product_sku_fkey" FOREIGN KEY ("brand_product_sku") REFERENCES "public"."spec_price_sheet"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sos_authorizations"
    ADD CONSTRAINT "sos_authorizations_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sos_authorizations_migration"
    ADD CONSTRAINT "sos_authorizations_migration_brand_fkey" FOREIGN KEY ("brand") REFERENCES "public"."brands_migration"("uuid") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."sos_authorizations_migration"
    ADD CONSTRAINT "sos_authorizations_migration_sos_rep_assigned_fkey" FOREIGN KEY ("sos_rep_assigned") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."sos_authorizations"
    ADD CONSTRAINT "sos_authorizations_sos_rep_assigned_fkey" FOREIGN KEY ("sos_rep_assigned") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY "public"."spec_price_sheet_migration"
    ADD CONSTRAINT "spec_price_sheet_migration_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands_migration"("uuid") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."syncup_notes"
    ADD CONSTRAINT "syncup_notes_team_member_fkey" FOREIGN KEY ("team_member") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."syncup_notes"
    ADD CONSTRAINT "syncup_notes_user_fkey" FOREIGN KEY ("user") REFERENCES "auth"."users"("id");
ALTER TABLE ONLY "public"."jt_task_assignments"
    ADD CONSTRAINT "task_assignments_task_id_fkey" FOREIGN KEY ("task_id") REFERENCES "public"."task_pipeline"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_task_assignments"
    ADD CONSTRAINT "task_assignments_team_member_uuid_fkey" FOREIGN KEY ("team_member_uuid") REFERENCES "public"."team_member_guide"("uuid") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."task_pipeline"
    ADD CONSTRAINT "task_pipeline_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("uuid");
ALTER TABLE ONLY "public"."jt_task_pipeline_attachments"
    ADD CONSTRAINT "task_pipeline_attachments_document_id_fkey" FOREIGN KEY ("document_id") REFERENCES "public"."brand_documents"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_task_pipeline_attachments"
    ADD CONSTRAINT "task_pipeline_attachments_task_id_fkey" FOREIGN KEY ("task_id") REFERENCES "public"."task_pipeline"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."task_pipeline"
    ADD CONSTRAINT "task_pipeline_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id");
ALTER TABLE ONLY "public"."task_pipeline"
    ADD CONSTRAINT "task_pipeline_category_review_id_fkey" FOREIGN KEY ("category_review_id") REFERENCES "public"."master_category_review_data"("id");
ALTER TABLE ONLY "public"."task_pipeline"
    ADD CONSTRAINT "task_pipeline_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."team_member_guide"("uuid");
ALTER TABLE ONLY "public"."brand_task_templates"
    ADD CONSTRAINT "task_templates_task_type_uuid_fkey" FOREIGN KEY ("task_type_uuid") REFERENCES "public"."brand_task_types"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."team_member_guide_migration"
    ADD CONSTRAINT "team_member_guide_migration_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."team_member_guide_migration"
    ADD CONSTRAINT "team_member_guide_migration_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."jt_user_notifications"
    ADD CONSTRAINT "user_notifications_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."team_member_guide"("uuid") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."jt_user_notifications"
    ADD CONSTRAINT "user_notifications_notification_id_fkey" FOREIGN KEY ("notification_id") REFERENCES "public"."notifications(deprecated)"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."users_roles"
    ADD CONSTRAINT "users_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."users_roles"
    ADD CONSTRAINT "users_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;
CREATE POLICY "Enable all access for all users" ON "public"."task_pipeline" TO "authenticated" USING (true);
CREATE POLICY "GNF Full Access" ON "public"."activity_tracker" TO "authenticated" USING (((("auth"."jwt"() -> 'app_metadata'::"text") ->> 'user_type'::"text") = 'gnf'::"text")) WITH CHECK (((("auth"."jwt"() -> 'app_metadata'::"text") ->> 'user_type'::"text") = 'gnf'::"text"));
CREATE POLICY "Internal full access or Brand-locked Vendor" ON "public"."activity_tracker" FOR SELECT TO "authenticated" USING ((((("auth"."jwt"() -> 'app_metadata'::"text") ->> 'user_type'::"text") = 'gnf'::"text") OR (((("auth"."jwt"() -> 'app_metadata'::"text") ->> 'user_type'::"text") = 'vendor'::"text") AND ("brand" = ((("auth"."jwt"() -> 'app_metadata'::"text") ->> 'brand_id'::"text"))::"uuid"))));
CREATE POLICY "Users can create their own folders" ON "public"."folders" FOR INSERT WITH CHECK (("auth"."uid"() = "brand_id"));
CREATE POLICY "Users can delete their own documents" ON "public"."brand_documents" FOR DELETE USING (("auth"."uid"() = "brand_id"));
CREATE POLICY "Users can delete their own folders" ON "public"."folders" FOR DELETE USING (("auth"."uid"() = "brand_id"));
CREATE POLICY "Users can see all assignees for their tasks (secure)" ON "public"."jt_task_assignments" FOR SELECT TO "authenticated" USING ("public"."is_user_assigned_to_task"("task_id"));
CREATE POLICY "Users can see tasks they are assigned to" ON "public"."task_pipeline" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."jt_task_assignments" "ta"
  WHERE (("ta"."task_id" = "task_pipeline"."id") AND ("ta"."team_member_uuid" = ( SELECT "team_member_guide"."uuid"
           FROM "public"."team_member_guide"
          WHERE ("team_member_guide"."user_id" = "auth"."uid"())))))));
CREATE POLICY "Users can upload their own documents" ON "public"."brand_documents" FOR INSERT WITH CHECK (("auth"."uid"() = "brand_id"));
CREATE POLICY "Users can view their own documents" ON "public"."brand_documents" FOR SELECT USING (("auth"."uid"() = "brand_id"));
CREATE POLICY "Users can view their own folders" ON "public"."folders" FOR SELECT USING (("auth"."uid"() = "brand_id"));
CREATE POLICY "Users can view their own notifications" ON "public"."notifications" FOR SELECT USING (("auth"."uid"() = "recipient_id"));
CREATE POLICY "accounts_all_policy" ON "public"."accounts" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "accounts_insert_policy" ON "public"."accounts" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[]))))));
CREATE POLICY "accounts_select_policy" ON "public"."accounts" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{"sales, demo, sos_role"}'::"text"[]))))));
CREATE POLICY "accounts_update_policy" ON "public"."accounts" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[]))))));
ALTER TABLE "public"."activity_tracker" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."brand_distribution_grid" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "brand_distribution_grid_all_policy" ON "public"."brand_distribution_grid" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "brand_distribution_grid_insert_policy" ON "public"."brand_distribution_grid" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "brand_distribution_grid_update_policy" ON "public"."brand_distribution_grid" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "brand_focus_assignments_all_policy" ON "public"."brand_focus_assignments" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "brand_focus_assignments_select_policy" ON "public"."brand_focus_assignments" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sos_team,data_role}'::"text"[]))))));
ALTER TABLE "public"."brand_promo_requests (Deprecated)" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "brand_promo_requests_all_policy" ON "public"."brand_promo_requests (Deprecated)" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "brand_promo_requests_insert_policy" ON "public"."brand_promo_requests (Deprecated)" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[]))))));
CREATE POLICY "brand_promo_requests_select_policy" ON "public"."brand_promo_requests (Deprecated)" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "brand_promo_requests_update_policy" ON "public"."brand_promo_requests (Deprecated)" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[]))))));
CREATE POLICY "brand_promotions_all_policy" ON "public"."brand_promotions" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "brand_promotions_insert_policy" ON "public"."brand_promotions" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[]))))));
CREATE POLICY "brand_promotions_select_policy" ON "public"."brand_promotions" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{"sales, demo, sos_role"}'::"text"[]))))));
CREATE POLICY "brand_promotions_update_policy" ON "public"."brand_promotions" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[]))))));
ALTER TABLE "public"."brand_task_templates" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."brand_task_types" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "brands_all_policy" ON "public"."brands" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "brands_insert_policy" ON "public"."brands" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "brands_select_policy" ON "public"."brands" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team}'::"text"[]))))));
CREATE POLICY "brands_update_policy" ON "public"."brands" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
ALTER TABLE "public"."company_announcements" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "company_announcements_all_policy" ON "public"."company_announcements" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "company_announcements_select_policy" ON "public"."company_announcements" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."contacts" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "contacts_all_policy" ON "public"."contacts" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
ALTER TABLE "public"."contacts_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "contacts_select_policy" ON "public"."contacts" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,harvest_hub}'::"text"[]))))));
CREATE POLICY "deal_activity_comments_all_policy" ON "public"."deal_activity_comments" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "deal_activity_comments_insert_policy" ON "public"."deal_activity_comments" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "deal_activity_comments_select_policy" ON "public"."deal_activity_comments" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "deal_activity_comments_update_policy" ON "public"."deal_activity_comments" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team,data_role}'::"text"[]))))));
ALTER TABLE "public"."demos" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "demos_all_policy" ON "public"."demos" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "demos_insert_policy" ON "public"."demos" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,data_role}'::"text"[]))))));
ALTER TABLE "public"."demos_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "demos_select_policy" ON "public"."demos" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "demos_update_policy" ON "public"."demos" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,data_role}'::"text"[]))))));
ALTER TABLE "public"."events" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "events_all_policy" ON "public"."events" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
ALTER TABLE "public"."events_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "events_select_policy" ON "public"."events" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."hh_account_experts" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_account_experts_all_policy" ON "public"."hh_account_experts" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "hh_account_experts_insert_policy" ON "public"."hh_account_experts" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_account_experts_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_account_experts_select_policy" ON "public"."hh_account_experts" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_account_experts_update_policy" ON "public"."hh_account_experts" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_blog_articles" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_blog_articles_all_policy" ON "public"."hh_blog_articles" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "hh_blog_articles_insert_policy" ON "public"."hh_blog_articles" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_blog_articles_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_blog_articles_select_policy" ON "public"."hh_blog_articles" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_blog_articles_update_policy" ON "public"."hh_blog_articles" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_community_experts" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_community_experts_all_policy" ON "public"."hh_community_experts" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "hh_community_experts_insert_policy" ON "public"."hh_community_experts" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_community_experts_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_community_experts_select_policy" ON "public"."hh_community_experts" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_community_experts_update_policy" ON "public"."hh_community_experts" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_contributions" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_contributions_all_policy" ON "public"."hh_contributions" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "hh_contributions_insert_policy" ON "public"."hh_contributions" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_contributions_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_contributions_select_policy" ON "public"."hh_contributions" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_contributions_update_policy" ON "public"."hh_contributions" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_customers_all_policy" ON "public"."hh_customers" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "hh_customers_insert_policy" ON "public"."hh_customers" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_customers_select_policy" ON "public"."hh_customers" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_customers_update_policy" ON "public"."hh_customers" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_deals" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_deals_all_policy" ON "public"."hh_deals" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "hh_deals_insert_policy" ON "public"."hh_deals" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_deals_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_deals_select_policy" ON "public"."hh_deals" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_deals_update_policy" ON "public"."hh_deals" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_feature_updates" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_feature_updates_all_policy" ON "public"."hh_feature_updates" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "hh_feature_updates_insert_policy" ON "public"."hh_feature_updates" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_feature_updates_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_feature_updates_select_policy" ON "public"."hh_feature_updates" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_feature_updates_update_policy" ON "public"."hh_feature_updates" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_licenses" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_licenses_all_policy" ON "public"."hh_licenses" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "hh_licenses_insert_policy" ON "public"."hh_licenses" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_licenses_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_licenses_select_policy" ON "public"."hh_licenses" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_licenses_update_policy" ON "public"."hh_licenses" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."hh_prospect_customers" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_prospect_customers_all_policy" ON "public"."hh_prospect_customers" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,harvest_hub}'::"text"[]))))));
CREATE POLICY "hh_prospect_customers_insert_policy" ON "public"."hh_prospect_customers" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[]))))));
ALTER TABLE "public"."hh_prospect_customers_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "hh_prospect_customers_select_policy" ON "public"."hh_prospect_customers" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[]))))));
CREATE POLICY "hh_prospect_customers_update_policy" ON "public"."hh_prospect_customers" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[]))))));
ALTER TABLE "public"."interaction_partners" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "interaction_partners_all_policy" ON "public"."interaction_partners" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
ALTER TABLE "public"."jt_accounts_distribution" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_accounts_team_member_guide" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_accounts_team_member_guide_all_policy" ON "public"."jt_accounts_team_member_guide" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "jt_accounts_team_member_guide_insert_policy" ON "public"."jt_accounts_team_member_guide" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "jt_accounts_team_member_guide_select_policy" ON "public"."jt_accounts_team_member_guide" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team}'::"text"[]))))));
CREATE POLICY "jt_accounts_team_member_guide_update_policy" ON "public"."jt_accounts_team_member_guide" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
ALTER TABLE "public"."jt_active_account_distribution_grid" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_active_account_distribution_grid_all_policy" ON "public"."jt_active_account_distribution_grid" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_active_account_distribution_grid_select_policy" ON "public"."jt_active_account_distribution_grid" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_associated_skus" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_associated_skus_all_policy" ON "public"."jt_associated_skus" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_associated_skus_select_policy" ON "public"."jt_associated_skus" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_brand_events" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_brand_events_all_policy" ON "public"."jt_brand_events" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_brand_events_select_policy" ON "public"."jt_brand_events" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_brand_promo_request_skus" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_brand_promo_request_skus_all_policy" ON "public"."jt_brand_promo_request_skus" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_brand_promo_request_skus_select_policy" ON "public"."jt_brand_promo_request_skus" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_brand_promotion_skus" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_brand_promotion_skus_all_policy" ON "public"."jt_brand_promotion_skus" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_brand_promotion_skus_select_policy" ON "public"."jt_brand_promotion_skus" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_category_review_contacts" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_contacts_categories_managed_all_policy" ON "public"."jt_contacts_categories_managed" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_contacts_categories_managed_select_policy" ON "public"."jt_contacts_categories_managed" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_contacts_distributor_rep_accounts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_deal_category_reviews" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_deal_category_reviews_all_policy" ON "public"."jt_deal_category_reviews" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_deal_category_reviews_select_policy" ON "public"."jt_deal_category_reviews" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_deal_distribution" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_deal_distribution_all_policy" ON "public"."jt_deal_distribution" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_deal_distribution_select_policy" ON "public"."jt_deal_distribution" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_deal_owners" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_deal_owners_all_policy" ON "public"."jt_deal_owners" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_deal_owners_select_policy" ON "public"."jt_deal_owners" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
CREATE POLICY "jt_deal_spec_price_sheet_all_policy" ON "public"."jt_deal_spec_price_sheet" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_deal_spec_price_sheet_select_policy" ON "public"."jt_deal_spec_price_sheet" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_demo_brands" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_demo_brands_all_policy" ON "public"."jt_demo_brands" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "jt_demo_brands_insert_policy" ON "public"."jt_demo_brands" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_demo_brands_select_policy" ON "public"."jt_demo_brands" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "jt_demo_brands_update_policy" ON "public"."jt_demo_brands" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_distributor_accounts_all_policy" ON "public"."jt_accounts_distribution" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_distributor_accounts_select_policy" ON "public"."jt_accounts_distribution" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
CREATE POLICY "jt_hh_customers_accounts_all_policy" ON "public"."jt_hh_customers_accounts_deals" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."jt_hh_customers_accounts_deals" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_hh_customers_accounts_select_policy" ON "public"."jt_hh_customers_accounts_deals" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{"sales, demo, sos_role"}'::"text"[]))))));
ALTER TABLE "public"."jt_hh_customers_category_reviews" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_hh_customers_category_reviews_all_policy" ON "public"."jt_hh_customers_category_reviews" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."jt_hh_customers_licenses(deprecated)" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_hh_customers_licenses_all_policy" ON "public"."jt_hh_customers_licenses(deprecated)" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."jt_hh_customers_master_categories" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_hh_customers_master_categories_all_policy" ON "public"."jt_hh_customers_master_categories" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role,harvest_hub}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role,harvest_hub}'::"text"[]))))));
ALTER TABLE "public"."jt_master_categories_brands" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_master_categories_brands_all_policy" ON "public"."jt_master_categories_brands" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_master_categories_brands_select_policy" ON "public"."jt_master_categories_brands" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_master_category_review_data_brands" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_master_category_review_data_brands_all_policy" ON "public"."jt_master_category_review_data_brands" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_master_category_review_data_brands_select_policy" ON "public"."jt_master_category_review_data_brands" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_master_category_review_data_matching" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_master_category_review_data_matching_all_policy" ON "public"."jt_master_category_review_data_matching" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_master_category_review_data_matching_select_policy" ON "public"."jt_master_category_review_data_matching" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_ref_accounts_category_review_received_status" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_accounts_flag_for_attention" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_accounts_industry_tags" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_active_services" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_announcement_tag" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_applied_services" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_brand_attention_flag" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_brand_audience_tag" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_brand_status" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_contact_department_tags" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_contacts_flag_for_attention" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_coverage" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_departments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_hh_community_expert_services_offered" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_hh_expert_services_offered" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_no_contact_details" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_product_sub_category" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_sos_program_type" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_ref_sub_tags" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."jt_retailer_category_to_gn_categories" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_retailer_category_to_gn_categories_all_policy" ON "public"."jt_retailer_category_to_gn_categories" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_retailer_category_to_gn_categories_select_policy" ON "public"."jt_retailer_category_to_gn_categories" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
CREATE POLICY "jt_spec_price_sheet_categories_all_policy" ON "public"."jt_spec_price_sheet_categories" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_spec_price_sheet_categories_select_policy" ON "public"."jt_spec_price_sheet_categories" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_sync_up_notes_brands" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_sync_up_notes_brands_all_policy" ON "public"."jt_sync_up_notes_brands" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_sync_up_notes_brands_select_policy" ON "public"."jt_sync_up_notes_brands" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."jt_team_members_x_events" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jt_team_members_x_events_all_policy" ON "public"."jt_team_members_x_events" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,sales,data_role}'::"text"[]))))));
CREATE POLICY "jt_team_members_x_events_select_policy" ON "public"."jt_team_members_x_events" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{demo,sos_team}'::"text"[]))))));
CREATE POLICY "jt_user_notifications_all_policy" ON "public"."jt_user_notifications" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "jt_user_notifications_insert_policy" ON "public"."jt_user_notifications" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_teamdata_role}'::"text"[]))))));
CREATE POLICY "jt_user_notifications_select_policy" ON "public"."jt_user_notifications" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_teamdata_role}'::"text"[]))))));
CREATE POLICY "jt_user_notifications_update_policy" ON "public"."jt_user_notifications" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_teamdata_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_teamdata_role}'::"text"[]))))));
CREATE POLICY "jt_user_role_dept_all_policy" ON "public"."jt_user_role_dept" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "jt_user_role_dept_insert_policy" ON "public"."jt_user_role_dept" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[]))))));
CREATE POLICY "jt_user_role_dept_select_policy" ON "public"."jt_user_role_dept" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_teamdata_role}'::"text"[]))))));
CREATE POLICY "jt_user_role_dept_update_policy" ON "public"."jt_user_role_dept" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[]))))));
ALTER TABLE "public"."master_categories" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "master_categories_all_policy" ON "public"."master_categories" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
ALTER TABLE "public"."master_categories_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "master_categories_select_policy" ON "public"."master_categories" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."master_category_review_data" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "master_category_review_data_all_policy" ON "public"."master_category_review_data" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "master_category_review_data_insert_policy" ON "public"."master_category_review_data" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{"sales, demo, sos_role"}'::"text"[]))))));
ALTER TABLE "public"."master_category_review_data_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "master_category_review_data_select_policy" ON "public"."master_category_review_data" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team}'::"text"[]))))));
ALTER TABLE "public"."master_promo_data" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "master_promo_data_all_policy" ON "public"."master_promo_data" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "master_promo_data_select_policy" ON "public"."master_promo_data" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team}'::"text"[]))))));
CREATE POLICY "notifications_all_policy" ON "public"."notifications(deprecated)" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "notifications_insert_policy" ON "public"."notifications(deprecated)" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{"sales, demo, sos_role"}'::"text"[]))))));
CREATE POLICY "planned_reviews_all_policy" ON "public"."planned_submissions" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "planned_reviews_insert_policy" ON "public"."planned_submissions" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "planned_reviews_select_policy" ON "public"."planned_submissions" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team}'::"text"[]))))));
CREATE POLICY "planned_reviews_update_policy" ON "public"."planned_submissions" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
ALTER TABLE "public"."planned_submissions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles_all_policy" ON "public"."profiles" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "profiles_insert_policy" ON "public"."profiles" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{salesdemo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "profiles_select_policy" ON "public"."profiles" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{salesdemo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "profiles_update_policy" ON "public"."profiles" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{salesdemo,sos_team,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{salesdemo,sos_team,data_role}'::"text"[]))))));
ALTER TABLE "public"."prospects (deprecated)" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "prospects_all_policy" ON "public"."prospects (deprecated)" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
ALTER TABLE "public"."ref_brand_audience_tag" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_brand_promo_table_distributors" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_brand_status" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_category_review_received_status" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_category_review_type" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_contacts_flag_for_attention" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_hh_community_expert_services_offered" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_hh_expert_services_offered" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_hh_lead_source" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_no_contact_details" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ref_sos_program_type" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."retailer_gnf_category_matching" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "retailer_gnf_category_matching_all_policy" ON "public"."retailer_gnf_category_matching" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "retailer_gnf_category_matching_insert_policy" ON "public"."retailer_gnf_category_matching" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[]))))));
ALTER TABLE "public"."retailer_gnf_category_matching_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "retailer_gnf_category_matching_select_policy" ON "public"."retailer_gnf_category_matching" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{salesdemo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "retailer_gnf_category_matching_update_policy" ON "public"."retailer_gnf_category_matching" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{data_role}'::"text"[]))))));
ALTER TABLE "public"."roles" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "roles_all_policy" ON "public"."roles" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
ALTER TABLE "public"."sample_shipment_tracking" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sample_shipment_tracking_all_policy" ON "public"."sample_shipment_tracking" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "sample_shipment_tracking_insert_policy" ON "public"."sample_shipment_tracking" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "sample_shipment_tracking_select_policy" ON "public"."sample_shipment_tracking" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "sample_shipment_tracking_update_policy" ON "public"."sample_shipment_tracking" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
ALTER TABLE "public"."sku_account_distribution" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sku_account_distribution_all_policy" ON "public"."sku_account_distribution" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "sku_account_distribution_insert_policy" ON "public"."sku_account_distribution" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "sku_account_distribution_select_policy" ON "public"."sku_account_distribution" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "sku_account_distribution_update_policy" ON "public"."sku_account_distribution" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
ALTER TABLE "public"."sku_images" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."sku_placements" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sku_placements_all_policy" ON "public"."sku_placements" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "sku_placements_insert_policy" ON "public"."sku_placements" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[]))))));
CREATE POLICY "sku_placements_select_policy" ON "public"."sku_placements" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[]))))));
CREATE POLICY "sku_placements_update_policy" ON "public"."sku_placements" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[]))))));
CREATE POLICY "sos_authorizations_all_policy" ON "public"."sos_authorizations" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "sos_authorizations_select_policy" ON "public"."sos_authorizations" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[]))))));
CREATE POLICY "spec_price_sheet_all_policy" ON "public"."spec_price_sheet" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin,data_role}'::"text"[]))))));
CREATE POLICY "spec_price_sheet_insert_policy" ON "public"."spec_price_sheet" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
CREATE POLICY "spec_price_sheet_select_policy" ON "public"."spec_price_sheet" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,sos_team}'::"text"[]))))));
CREATE POLICY "spec_price_sheet_update_policy" ON "public"."spec_price_sheet" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales}'::"text"[]))))));
ALTER TABLE "public"."stat_card_table" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."syncup_notes" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "syncup_notes_all_policy" ON "public"."syncup_notes" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "syncup_notes_insert_policy" ON "public"."syncup_notes" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "syncup_notes_select_policy" ON "public"."syncup_notes" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "syncup_notes_update_policy" ON "public"."syncup_notes" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
ALTER TABLE "public"."task_pipeline" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "team_member_dept_all_policy" ON "public"."team_member_dept" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
ALTER TABLE "public"."team_member_guide" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "team_member_guide_all_policy" ON "public"."team_member_guide" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
CREATE POLICY "team_member_guide_insert_policy" ON "public"."team_member_guide" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
ALTER TABLE "public"."team_member_guide_migration" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "team_member_guide_select_policy" ON "public"."team_member_guide" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
CREATE POLICY "team_member_guide_update_policy" ON "public"."team_member_guide" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{sales,demo,sos_team,data_role}'::"text"[]))))));
ALTER TABLE "public"."users_roles" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "users_roles_all_policy" ON "public"."users_roles" USING ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."jt_user_role_dept" "urd"
     JOIN "public"."team_member_dept" "tmd" ON (("urd"."dept_id" = "tmd"."id")))
  WHERE (("urd"."user_id" = ( SELECT "auth"."uid"() AS "uid")) AND (("tmd"."dept_code")::"text" = ANY ('{admin}'::"text"[]))))));
ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";
ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."brand_tasks";
ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."deal_activity_comments";
ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."jt_user_notifications";
ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."notifications";
GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";
GRANT USAGE ON SCHEMA "public" TO "supabase_auth_admin";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_in"("cstring") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_out"("public"."gtrgm") TO "service_role";
GRANT ALL ON FUNCTION "public"."(deprecated) handle_account_distributor_sync"() TO "anon";
GRANT ALL ON FUNCTION "public"."(deprecated) handle_account_distributor_sync"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."(deprecated) handle_account_distributor_sync"() TO "service_role";
GRANT ALL ON FUNCTION "public"."activity_tracker_set_last_updated"() TO "anon";
GRANT ALL ON FUNCTION "public"."activity_tracker_set_last_updated"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."activity_tracker_set_last_updated"() TO "service_role";
GRANT ALL ON FUNCTION "public"."add_customer_to_category"("customer_uuid" "uuid", "category_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."add_customer_to_category"("customer_uuid" "uuid", "category_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."add_customer_to_category"("customer_uuid" "uuid", "category_uuid" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."auto_complete_demo"() TO "anon";
GRANT ALL ON FUNCTION "public"."auto_complete_demo"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."auto_complete_demo"() TO "service_role";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "postgres";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "anon";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "authenticated";
GRANT ALL ON FUNCTION "public"."bytea_to_text"("data" "bytea") TO "service_role";
GRANT ALL ON FUNCTION "public"."calculate_onboarding_completion"() TO "anon";
GRANT ALL ON FUNCTION "public"."calculate_onboarding_completion"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."calculate_onboarding_completion"() TO "service_role";
GRANT ALL ON FUNCTION "public"."calculate_total_hours"() TO "anon";
GRANT ALL ON FUNCTION "public"."calculate_total_hours"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."calculate_total_hours"() TO "service_role";
GRANT ALL ON FUNCTION "public"."cascade_account_name_update"() TO "anon";
GRANT ALL ON FUNCTION "public"."cascade_account_name_update"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."cascade_account_name_update"() TO "service_role";
GRANT ALL ON FUNCTION "public"."complete_task"("task_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."complete_task"("task_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."complete_task"("task_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid", "p_brand_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid", "p_brand_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_default_brand_folders"("p_brand_id" "uuid", "p_brand_name" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."create_mention_notifications"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_mention_notifications"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_mention_notifications"() TO "service_role";
GRANT ALL ON FUNCTION "public"."create_rls_policies"("table_names" "text"[], "role_dept_codes" "text"[], "operation" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."create_rls_policies"("table_names" "text"[], "role_dept_codes" "text"[], "operation" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_rls_policies"("table_names" "text"[], "role_dept_codes" "text"[], "operation" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."create_task_on_deal_stage_change"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_task_on_deal_stage_change"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_task_on_deal_stage_change"() TO "service_role";
GRANT ALL ON FUNCTION "public"."create_tasks_from_activity_tracker"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_tasks_from_activity_tracker"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_tasks_from_activity_tracker"() TO "service_role";
GRANT ALL ON FUNCTION "public"."create_tasks_from_category_reviews"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_tasks_from_category_reviews"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_tasks_from_category_reviews"() TO "service_role";
REVOKE ALL ON FUNCTION "public"."custom_access_token_hook"("event" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."custom_access_token_hook"("event" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."custom_access_token_hook"("event" "jsonb") TO "supabase_auth_admin";
GRANT ALL ON FUNCTION "public"."determine_task_status"("p_activity_tracker_id" "uuid", "p_due_date" "date") TO "anon";
GRANT ALL ON FUNCTION "public"."determine_task_status"("p_activity_tracker_id" "uuid", "p_due_date" "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."determine_task_status"("p_activity_tracker_id" "uuid", "p_due_date" "date") TO "service_role";
GRANT ALL ON FUNCTION "public"."enforce_connect_count"() TO "anon";
GRANT ALL ON FUNCTION "public"."enforce_connect_count"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."enforce_connect_count"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_account_type_enum"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_account_type_enum"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_account_type_enum"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_activity_type"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_activity_type"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_activity_type"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_brand_contact_tags"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_brand_contact_tags"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_brand_contact_tags"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_brand_folder"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_brand_folder"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_brand_folder"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_category_review_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_category_review_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_category_review_status"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_connect_enum"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_connect_enum"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_connect_enum"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_deal_stage"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_deal_stage"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_deal_stage"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_deals_for_tasks"("p_accounts" "uuid"[], "p_brands" "uuid"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_deals_for_tasks"("p_accounts" "uuid"[], "p_brands" "uuid"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_deals_for_tasks"("p_accounts" "uuid"[], "p_brands" "uuid"[]) TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_hh_customer_billing_terms_enum"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_hh_customer_billing_terms_enum"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_hh_customer_billing_terms_enum"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_primary_region"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_primary_region"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_primary_region"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_program_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_program_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_program_status"() TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_sku_placement_type"() TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_sku_placement_type"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_sku_placement_type"() TO "service_role";
GRANT ALL ON TABLE "public"."v_task_pipeline_with_assignees" TO "anon";
GRANT ALL ON TABLE "public"."v_task_pipeline_with_assignees" TO "authenticated";
GRANT ALL ON TABLE "public"."v_task_pipeline_with_assignees" TO "service_role";
GRANT ALL ON FUNCTION "public"."fetch_tasks_for_deal"("p_deal_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."fetch_tasks_for_deal"("p_deal_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fetch_tasks_for_deal"("p_deal_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."fill_full_category"() TO "anon";
GRANT ALL ON FUNCTION "public"."fill_full_category"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fill_full_category"() TO "service_role";
GRANT ALL ON FUNCTION "public"."filter_notes_by_brands"("brand_names" "text"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."filter_notes_by_brands"("brand_names" "text"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."filter_notes_by_brands"("brand_names" "text"[]) TO "service_role";
GRANT ALL ON FUNCTION "public"."format_item_name"("description_text" "text", "qty" numeric, "unit_val" "public"."uom_enum") TO "anon";
GRANT ALL ON FUNCTION "public"."format_item_name"("description_text" "text", "qty" numeric, "unit_val" "public"."uom_enum") TO "authenticated";
GRANT ALL ON FUNCTION "public"."format_item_name"("description_text" "text", "qty" numeric, "unit_val" "public"."uom_enum") TO "service_role";
GRANT ALL ON FUNCTION "public"."generate_review_data_name"("review_data_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."generate_review_data_name"("review_data_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."generate_review_data_name"("review_data_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_associated_skus"("input_deal_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_associated_skus"("input_deal_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_associated_skus"("input_deal_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_associated_skus_by_deal_id"("p_deal_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_associated_skus_by_deal_id"("p_deal_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_associated_skus_by_deal_id"("p_deal_id" "uuid") TO "service_role";
GRANT ALL ON TABLE "public"."brands" TO "anon";
GRANT ALL ON TABLE "public"."brands" TO "authenticated";
GRANT ALL ON TABLE "public"."brands" TO "service_role";
GRANT ALL ON FUNCTION "public"."get_brand_by_id"("brand_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_brand_by_id"("brand_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_brand_by_id"("brand_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_brand_skus_for_deal"("p_brand" "uuid", "p_deal" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_brand_skus_for_deal"("p_brand" "uuid", "p_deal" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_brand_skus_for_deal"("p_brand" "uuid", "p_deal" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_comments_for_activity_notes"("p_activity_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_comments_for_activity_notes"("p_activity_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_comments_for_activity_notes"("p_activity_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_complete_schema"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_complete_schema"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_complete_schema"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_customer_category_opportunities"("customer_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_customer_category_opportunities"("customer_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_customer_category_opportunities"("customer_uuid" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_customer_monthly_status"("customer_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_customer_monthly_status"("customer_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_customer_monthly_status"("customer_uuid" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_dashboard_summary"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_dashboard_summary"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_dashboard_summary"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_deal_comments_by_brand"("p_deal_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_deal_comments_by_brand"("p_deal_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_deal_comments_by_brand"("p_deal_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_demo_details"("demo_id_param" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_demo_details"("demo_id_param" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_demo_details"("demo_id_param" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_demo_metrics"("demo_id_param" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_demo_metrics"("demo_id_param" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_demo_metrics"("demo_id_param" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_distinct_values"("_table_name" "text", "_column_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_distinct_values"("_table_name" "text", "_column_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_distinct_values"("_table_name" "text", "_column_name" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb", "_limit" integer, "_offset" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb", "_limit" integer, "_offset" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb", "_limit" integer, "_offset" integer) TO "service_role";
GRANT ALL ON FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb", "_limit" integer, "_offset" integer, "_logic" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb", "_limit" integer, "_offset" integer, "_logic" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_dynamic_data"("_table_name" "text", "_filters" "jsonb", "_limit" integer, "_offset" integer, "_logic" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_folder_path"("target_folder_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_folder_path"("target_folder_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_folder_path"("target_folder_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_grouped_syncup_notes"("p_brand_id" "uuid", "p_account_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_grouped_syncup_notes"("p_brand_id" "uuid", "p_account_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_grouped_syncup_notes"("p_brand_id" "uuid", "p_account_id" "uuid") TO "service_role";
GRANT ALL ON TABLE "public"."hh_customers" TO "anon";
GRANT ALL ON TABLE "public"."hh_customers" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_customers" TO "service_role";
GRANT ALL ON TABLE "public"."jt_hh_customers_category_reviews" TO "anon";
GRANT ALL ON TABLE "public"."jt_hh_customers_category_reviews" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_hh_customers_category_reviews" TO "service_role";
GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";
GRANT SELECT ON TABLE "public"."profiles" TO "supabase_auth_admin";
GRANT ALL ON TABLE "public"."v_harvesthub_customer_datagrid" TO "anon";
GRANT ALL ON TABLE "public"."v_harvesthub_customer_datagrid" TO "authenticated";
GRANT ALL ON TABLE "public"."v_harvesthub_customer_datagrid" TO "service_role";
GRANT ALL ON FUNCTION "public"."get_harvesthub_customers"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_harvesthub_customers"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_harvesthub_customers"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_hh_system_stats"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_hh_system_stats"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_hh_system_stats"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_loggedinbrandinfo"("brand_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_loggedinbrandinfo"("brand_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_loggedinbrandinfo"("brand_id" "uuid") TO "service_role";
GRANT ALL ON TABLE "public"."company_announcements" TO "anon";
GRANT ALL ON TABLE "public"."company_announcements" TO "authenticated";
GRANT ALL ON TABLE "public"."company_announcements" TO "service_role";
GRANT ALL ON FUNCTION "public"."get_next_announcement"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_next_announcement"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_next_announcement"() TO "service_role";
GRANT ALL ON TABLE "public"."contacts" TO "anon";
GRANT ALL ON TABLE "public"."contacts" TO "authenticated";
GRANT ALL ON TABLE "public"."contacts" TO "service_role";
GRANT ALL ON TABLE "public"."jt_contacts_categories_managed" TO "anon";
GRANT ALL ON TABLE "public"."jt_contacts_categories_managed" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_contacts_categories_managed" TO "service_role";
GRANT ALL ON TABLE "public"."jt_master_categories_brands" TO "anon";
GRANT ALL ON TABLE "public"."jt_master_categories_brands" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_master_categories_brands" TO "service_role";
GRANT ALL ON TABLE "public"."jt_matched_brands_to_category_reviews" TO "anon";
GRANT ALL ON TABLE "public"."jt_matched_brands_to_category_reviews" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_matched_brands_to_category_reviews" TO "service_role";
GRANT ALL ON TABLE "public"."master_categories" TO "anon";
GRANT ALL ON TABLE "public"."master_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."master_categories" TO "service_role";
GRANT ALL ON TABLE "public"."master_category_review_data" TO "anon";
GRANT ALL ON TABLE "public"."master_category_review_data" TO "authenticated";
GRANT ALL ON TABLE "public"."master_category_review_data" TO "service_role";
GRANT ALL ON TABLE "public"."v_brand_matching" TO "anon";
GRANT ALL ON TABLE "public"."v_brand_matching" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brand_matching" TO "service_role";
GRANT ALL ON FUNCTION "public"."get_next_category_review_deadline"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_next_category_review_deadline"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_next_category_review_deadline"() TO "service_role";
GRANT ALL ON TABLE "public"."events" TO "anon";
GRANT ALL ON TABLE "public"."events" TO "authenticated";
GRANT ALL ON TABLE "public"."events" TO "service_role";
GRANT ALL ON TABLE "public"."jt_brand_events" TO "anon";
GRANT ALL ON TABLE "public"."jt_brand_events" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_brand_events" TO "service_role";
GRANT ALL ON TABLE "public"."jt_team_members_x_events" TO "anon";
GRANT ALL ON TABLE "public"."jt_team_members_x_events" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_team_members_x_events" TO "service_role";
GRANT ALL ON TABLE "public"."team_member_guide" TO "anon";
GRANT ALL ON TABLE "public"."team_member_guide" TO "authenticated";
GRANT ALL ON TABLE "public"."team_member_guide" TO "service_role";
GRANT ALL ON TABLE "public"."events_detailed_view" TO "anon";
GRANT ALL ON TABLE "public"."events_detailed_view" TO "authenticated";
GRANT ALL ON TABLE "public"."events_detailed_view" TO "service_role";
GRANT ALL ON FUNCTION "public"."get_next_event"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_next_event"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_next_event"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_next_planned_submission"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_next_planned_submission"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_next_planned_submission"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuids" "uuid"[]) TO "anon";
GRANT ALL ON FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuids" "uuid"[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuids" "uuid"[]) TO "service_role";
GRANT ALL ON FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_notes_by_brand_with_names"("p_brand_uuid" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_related_skus"("input_brand_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_related_skus"("input_brand_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_related_skus"("input_brand_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_retailers_for_category"("category_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_retailers_for_category"("category_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_retailers_for_category"("category_name" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_retailers_for_category"("category_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_retailers_for_category"("category_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_retailers_for_category"("category_uuid" "uuid") TO "service_role";
GRANT ALL ON TABLE "public"."spec_price_sheet" TO "anon";
GRANT ALL ON TABLE "public"."spec_price_sheet" TO "authenticated";
GRANT ALL ON TABLE "public"."spec_price_sheet" TO "service_role";
GRANT ALL ON FUNCTION "public"."get_spec_price_sheets_by_brand"("input_brand_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_spec_price_sheets_by_brand"("input_brand_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_spec_price_sheets_by_brand"("input_brand_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_table_columns"("_table_name" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."get_table_columns"("_table_name" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_table_columns"("_table_name" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."get_task_dashboard_tab_counts"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_task_dashboard_tab_counts"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_task_dashboard_tab_counts"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_task_stats"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_task_stats"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_task_stats"() TO "service_role";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_extract_query_trgm"("text", "internal", smallint, "internal", "internal", "internal", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_extract_value_trgm"("text", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_trgm_consistent"("internal", smallint, "text", integer, "internal", "internal", "internal", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gin_trgm_triconsistent"("internal", smallint, "text", integer, "internal", "internal", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."global_search"("search_term" "text", "search_type" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."global_search"("search_term" "text", "search_type" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."global_search"("search_term" "text", "search_type" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_compress"("internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_consistent"("internal", "text", smallint, "oid", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_decompress"("internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_distance"("internal", "text", smallint, "oid", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_options"("internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_penalty"("internal", "internal", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_picksplit"("internal", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_same"("public"."gtrgm", "public"."gtrgm", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gtrgm_union"("internal", "internal") TO "service_role";
GRANT ALL ON FUNCTION "public"."handle_employee_status_change"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_employee_status_change"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_employee_status_change"() TO "service_role";
GRANT ALL ON FUNCTION "public"."handle_hh_customers_audit"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_hh_customers_audit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_hh_customers_audit"() TO "service_role";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";
GRANT ALL ON FUNCTION "public"."handle_submission_status_change"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_submission_status_change"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_submission_status_change"() TO "service_role";
GRANT ALL ON FUNCTION "public"."handle_task_status_change"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_task_status_change"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_task_status_change"() TO "service_role";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "postgres";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "anon";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http"("request" "public"."http_request") TO "service_role";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_delete"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_get"("uri" character varying, "data" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_head"("uri" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_header"("field" character varying, "value" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "postgres";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "anon";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_list_curlopt"() TO "service_role";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_patch"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "data" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_post"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_put"("uri" character varying, "content" character varying, "content_type" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "postgres";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "anon";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_reset_curlopt"() TO "service_role";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."http_set_curlopt"("curlopt" character varying, "value" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."import_airtable_task_tracker"() TO "anon";
GRANT ALL ON FUNCTION "public"."import_airtable_task_tracker"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."import_airtable_task_tracker"() TO "service_role";
GRANT ALL ON FUNCTION "public"."import_airtable_tasks"("p_task_data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."import_airtable_tasks"("p_task_data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."import_airtable_tasks"("p_task_data" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."insert_sku_placements_from_activity"() TO "anon";
GRANT ALL ON FUNCTION "public"."insert_sku_placements_from_activity"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."insert_sku_placements_from_activity"() TO "service_role";
GRANT ALL ON FUNCTION "public"."is_active_employee"("user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_active_employee"("user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_active_employee"("user_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."is_user_assigned_to_task"("p_task_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_user_assigned_to_task"("p_task_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_user_assigned_to_task"("p_task_id" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."link_brand_match_to_reviews"() TO "anon";
GRANT ALL ON FUNCTION "public"."link_brand_match_to_reviews"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."link_brand_match_to_reviews"() TO "service_role";
GRANT ALL ON FUNCTION "public"."log_deal_stage_history"() TO "anon";
GRANT ALL ON FUNCTION "public"."log_deal_stage_history"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."log_deal_stage_history"() TO "service_role";
GRANT ALL ON FUNCTION "public"."new_activity_mention"() TO "anon";
GRANT ALL ON FUNCTION "public"."new_activity_mention"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."new_activity_mention"() TO "service_role";
GRANT ALL ON FUNCTION "public"."notify_hh_customer_status_change"() TO "anon";
GRANT ALL ON FUNCTION "public"."notify_hh_customer_status_change"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."notify_hh_customer_status_change"() TO "service_role";
GRANT ALL ON FUNCTION "public"."notify_task_assignment"() TO "anon";
GRANT ALL ON FUNCTION "public"."notify_task_assignment"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."notify_task_assignment"() TO "service_role";
GRANT ALL ON FUNCTION "public"."refresh_all_review_data_names"() TO "anon";
GRANT ALL ON FUNCTION "public"."refresh_all_review_data_names"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."refresh_all_review_data_names"() TO "service_role";
GRANT ALL ON FUNCTION "public"."search_similar_accounts"("search_term" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."search_similar_accounts"("search_term" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."search_similar_accounts"("search_term" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."set_assignee_name"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_assignee_name"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_assignee_name"() TO "service_role";
GRANT ALL ON FUNCTION "public"."set_brand_name"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_brand_name"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_brand_name"() TO "service_role";
GRANT ALL ON FUNCTION "public"."set_last_modified"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_last_modified"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_last_modified"() TO "service_role";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "postgres";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "anon";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_limit"(real) TO "service_role";
GRANT ALL ON FUNCTION "public"."set_unique_category_name"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_unique_category_name"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_unique_category_name"() TO "service_role";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "postgres";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "anon";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."show_limit"() TO "service_role";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "postgres";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "anon";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."show_trgm"("text") TO "service_role";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity_dist"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."similarity_op"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_commutator_op"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_commutator_op"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_dist_op"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."strict_word_similarity_op"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."subscribe_customer_to_category_review"("customer_uuid" "uuid", "review_uuid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."subscribe_customer_to_category_review"("customer_uuid" "uuid", "review_uuid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."subscribe_customer_to_category_review"("customer_uuid" "uuid", "review_uuid" "uuid") TO "service_role";
GRANT ALL ON FUNCTION "public"."sync_brand_onboarding_tasks"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_brand_onboarding_tasks"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_brand_onboarding_tasks"() TO "service_role";
GRANT ALL ON FUNCTION "public"."sync_gnf_primary"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_gnf_primary"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_gnf_primary"() TO "service_role";
GRANT ALL ON FUNCTION "public"."sync_new_account_to_partners"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_new_account_to_partners"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_new_account_to_partners"() TO "service_role";
GRANT ALL ON FUNCTION "public"."sync_new_distributor_to_partners"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_new_distributor_to_partners"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_new_distributor_to_partners"() TO "service_role";
GRANT ALL ON FUNCTION "public"."sync_team_member_photo_to_profile"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_team_member_photo_to_profile"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_team_member_photo_to_profile"() TO "service_role";
GRANT ALL ON FUNCTION "public"."sync_team_member_profile"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_team_member_profile"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_team_member_profile"() TO "service_role";
GRANT ALL ON FUNCTION "public"."test_name_generation"() TO "anon";
GRANT ALL ON FUNCTION "public"."test_name_generation"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."test_name_generation"() TO "service_role";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."text_to_bytea"("data" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."trg_sku_placements_update_deal"() TO "anon";
GRANT ALL ON FUNCTION "public"."trg_sku_placements_update_deal"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trg_sku_placements_update_deal"() TO "service_role";
GRANT ALL ON FUNCTION "public"."trg_task_pipeline_inserts"() TO "anon";
GRANT ALL ON FUNCTION "public"."trg_task_pipeline_inserts"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trg_task_pipeline_inserts"() TO "service_role";
GRANT ALL ON FUNCTION "public"."trg_task_pipeline_updates"() TO "anon";
GRANT ALL ON FUNCTION "public"."trg_task_pipeline_updates"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trg_task_pipeline_updates"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_accounts_search_vector"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_accounts_search_vector"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_accounts_search_vector"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_activity_name"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_activity_name"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_activity_name"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_activity_tracker_search_vector"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_activity_tracker_search_vector"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_activity_tracker_search_vector"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_affected_review_names_from_categories"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_affected_review_names_from_categories"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_affected_review_names_from_categories"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_affected_review_names_from_matching"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_affected_review_names_from_matching"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_affected_review_names_from_matching"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_brands_search_vector"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_brands_search_vector"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_brands_search_vector"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_connect_count"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_connect_count"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_connect_count"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_contribution_status"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_contribution_status"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_contribution_status"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_demos_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_demos_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_demos_updated_at"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_full_category"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_full_category"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_full_category"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_full_name_and_account"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_full_name_and_account"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_full_name_and_account"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_full_name_job_title"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_full_name_job_title"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_full_name_job_title"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_human_friendly_names"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_human_friendly_names"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_human_friendly_names"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_last_modified_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_last_modified_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_last_modified_column"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_last_updated_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_last_updated_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_last_updated_column"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_name_and_title"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_name_and_title"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_name_and_title"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_program_field"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_program_field"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_program_field"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_promo_name"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_promo_name"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_promo_name"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_review_data_name"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_review_data_name"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_review_data_name"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_review_names_when_account_changes"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_review_names_when_account_changes"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_review_names_when_account_changes"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_review_names_when_category_changes"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_review_names_when_category_changes"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_review_names_when_category_changes"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_sos_authorizations_connects_achieved"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_sos_authorizations_connects_achieved"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_sos_authorizations_connects_achieved"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_task_time_categories"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_task_time_categories"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_task_time_categories"() TO "service_role";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("string" "bytea") TO "service_role";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("data" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "postgres";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."urlencode"("string" character varying) TO "service_role";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_commutator_op"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_commutator_op"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_dist_op"("text", "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "anon";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."word_similarity_op"("text", "text") TO "service_role";
GRANT ALL ON TABLE "public"."ref_account_type" TO "anon";
GRANT ALL ON TABLE "public"."ref_account_type" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_account_type" TO "service_role";
GRANT ALL ON SEQUENCE "public"."_os_account_type_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."_os_account_type_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."_os_account_type_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_sub_tags" TO "anon";
GRANT ALL ON TABLE "public"."ref_sub_tags" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_sub_tags" TO "service_role";
GRANT ALL ON SEQUENCE "public"."_os_sub_tags_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."_os_sub_tags_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."_os_sub_tags_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."accounts" TO "anon";
GRANT ALL ON TABLE "public"."accounts" TO "authenticated";
GRANT ALL ON TABLE "public"."accounts" TO "service_role";
GRANT ALL ON TABLE "public"."accounts_migration" TO "anon";
GRANT ALL ON TABLE "public"."accounts_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."accounts_migration" TO "service_role";
GRANT ALL ON TABLE "public"."activity_tracker" TO "anon";
GRANT ALL ON TABLE "public"."activity_tracker" TO "authenticated";
GRANT ALL ON TABLE "public"."activity_tracker" TO "service_role";
GRANT ALL ON TABLE "public"."activity_tracker_migration" TO "anon";
GRANT ALL ON TABLE "public"."activity_tracker_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."activity_tracker_migration" TO "service_role";
GRANT ALL ON TABLE "public"."activity_tracker_show_more" TO "anon";
GRANT ALL ON TABLE "public"."activity_tracker_show_more" TO "authenticated";
GRANT ALL ON TABLE "public"."activity_tracker_show_more" TO "service_role";
GRANT ALL ON TABLE "public"."brand_contacts_table" TO "anon";
GRANT ALL ON TABLE "public"."brand_contacts_table" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_contacts_table" TO "service_role";
GRANT ALL ON TABLE "public"."brand_contacts_table_migration" TO "anon";
GRANT ALL ON TABLE "public"."brand_contacts_table_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_contacts_table_migration" TO "service_role";
GRANT ALL ON TABLE "public"."brand_distribution_grid" TO "anon";
GRANT ALL ON TABLE "public"."brand_distribution_grid" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_distribution_grid" TO "service_role";
GRANT ALL ON TABLE "public"."brand_documents" TO "anon";
GRANT ALL ON TABLE "public"."brand_documents" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_documents" TO "service_role";
GRANT ALL ON TABLE "public"."brand_focus_assignments" TO "anon";
GRANT ALL ON TABLE "public"."brand_focus_assignments" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_focus_assignments" TO "service_role";
GRANT ALL ON TABLE "public"."brand_portal_credentials" TO "anon";
GRANT ALL ON TABLE "public"."brand_portal_credentials" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_portal_credentials" TO "service_role";
GRANT ALL ON TABLE "public"."brand_portal_credentials_migration" TO "anon";
GRANT ALL ON TABLE "public"."brand_portal_credentials_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_portal_credentials_migration" TO "service_role";
GRANT ALL ON TABLE "public"."brand_promo_requests (Deprecated)" TO "anon";
GRANT ALL ON TABLE "public"."brand_promo_requests (Deprecated)" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_promo_requests (Deprecated)" TO "service_role";
GRANT ALL ON TABLE "public"."brand_promotions" TO "anon";
GRANT ALL ON TABLE "public"."brand_promotions" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_promotions" TO "service_role";
GRANT ALL ON TABLE "public"."brand_status_analytics" TO "anon";
GRANT ALL ON TABLE "public"."brand_status_analytics" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_status_analytics" TO "service_role";
GRANT ALL ON TABLE "public"."brand_sync_call_schedule" TO "anon";
GRANT ALL ON TABLE "public"."brand_sync_call_schedule" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_sync_call_schedule" TO "service_role";
GRANT ALL ON TABLE "public"."brand_task_templates" TO "anon";
GRANT ALL ON TABLE "public"."brand_task_templates" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_task_templates" TO "service_role";
GRANT ALL ON TABLE "public"."brand_task_types" TO "anon";
GRANT ALL ON TABLE "public"."brand_task_types" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_task_types" TO "service_role";
GRANT ALL ON TABLE "public"."brand_tasks" TO "anon";
GRANT ALL ON TABLE "public"."brand_tasks" TO "authenticated";
GRANT ALL ON TABLE "public"."brand_tasks" TO "service_role";
GRANT ALL ON TABLE "public"."brands_by_region" TO "anon";
GRANT ALL ON TABLE "public"."brands_by_region" TO "authenticated";
GRANT ALL ON TABLE "public"."brands_by_region" TO "service_role";
GRANT ALL ON TABLE "public"."brands_migration" TO "anon";
GRANT ALL ON TABLE "public"."brands_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."brands_migration" TO "service_role";
GRANT ALL ON TABLE "public"."contacts_migration" TO "anon";
GRANT ALL ON TABLE "public"."contacts_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."contacts_migration" TO "service_role";
GRANT ALL ON TABLE "public"."jt_accounts_team_member_guide" TO "anon";
GRANT ALL ON TABLE "public"."jt_accounts_team_member_guide" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_accounts_team_member_guide" TO "service_role";
GRANT ALL ON TABLE "public"."costco_team_member_view" TO "anon";
GRANT ALL ON TABLE "public"."costco_team_member_view" TO "authenticated";
GRANT ALL ON TABLE "public"."costco_team_member_view" TO "service_role";
GRANT ALL ON TABLE "public"."deal_activity_comments" TO "anon";
GRANT ALL ON TABLE "public"."deal_activity_comments" TO "authenticated";
GRANT ALL ON TABLE "public"."deal_activity_comments" TO "service_role";
GRANT ALL ON TABLE "public"."deal_stage_history" TO "anon";
GRANT ALL ON TABLE "public"."deal_stage_history" TO "authenticated";
GRANT ALL ON TABLE "public"."deal_stage_history" TO "service_role";
GRANT ALL ON TABLE "public"."demos" TO "anon";
GRANT ALL ON TABLE "public"."demos" TO "authenticated";
GRANT ALL ON TABLE "public"."demos" TO "service_role";
GRANT ALL ON TABLE "public"."demo_dashboard_metrics" TO "anon";
GRANT ALL ON TABLE "public"."demo_dashboard_metrics" TO "authenticated";
GRANT ALL ON TABLE "public"."demo_dashboard_metrics" TO "service_role";
GRANT ALL ON TABLE "public"."demos_migration" TO "anon";
GRANT ALL ON TABLE "public"."demos_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."demos_migration" TO "service_role";
GRANT ALL ON TABLE "public"."event_with_attendees" TO "anon";
GRANT ALL ON TABLE "public"."event_with_attendees" TO "authenticated";
GRANT ALL ON TABLE "public"."event_with_attendees" TO "service_role";
GRANT ALL ON TABLE "public"."events_migration" TO "anon";
GRANT ALL ON TABLE "public"."events_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."events_migration" TO "service_role";
GRANT ALL ON TABLE "public"."folders" TO "anon";
GRANT ALL ON TABLE "public"."folders" TO "authenticated";
GRANT ALL ON TABLE "public"."folders" TO "service_role";
GRANT ALL ON TABLE "public"."folder_contents" TO "anon";
GRANT ALL ON TABLE "public"."folder_contents" TO "authenticated";
GRANT ALL ON TABLE "public"."folder_contents" TO "service_role";
GRANT ALL ON TABLE "public"."harvesthub_documents" TO "anon";
GRANT ALL ON TABLE "public"."harvesthub_documents" TO "authenticated";
GRANT ALL ON TABLE "public"."harvesthub_documents" TO "service_role";
GRANT ALL ON TABLE "public"."hh_account_experts" TO "anon";
GRANT ALL ON TABLE "public"."hh_account_experts" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_account_experts" TO "service_role";
GRANT ALL ON TABLE "public"."hh_account_experts_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_account_experts_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_account_experts_migration" TO "service_role";
GRANT ALL ON TABLE "public"."hh_blog_articles" TO "anon";
GRANT ALL ON TABLE "public"."hh_blog_articles" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_blog_articles" TO "service_role";
GRANT ALL ON TABLE "public"."hh_blog_articles_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_blog_articles_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_blog_articles_migration" TO "service_role";
GRANT ALL ON TABLE "public"."hh_community_experts" TO "anon";
GRANT ALL ON TABLE "public"."hh_community_experts" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_community_experts" TO "service_role";
GRANT ALL ON TABLE "public"."hh_community_experts_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_community_experts_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_community_experts_migration" TO "service_role";
GRANT ALL ON TABLE "public"."hh_contributions" TO "anon";
GRANT ALL ON TABLE "public"."hh_contributions" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_contributions" TO "service_role";
GRANT ALL ON TABLE "public"."hh_contributions_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_contributions_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_contributions_migration" TO "service_role";
GRANT ALL ON TABLE "public"."hh_customers_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_customers_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_customers_migration" TO "service_role";
GRANT ALL ON TABLE "public"."hh_deals" TO "anon";
GRANT ALL ON TABLE "public"."hh_deals" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_deals" TO "service_role";
GRANT ALL ON TABLE "public"."hh_deals_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_deals_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_deals_migration" TO "service_role";
GRANT ALL ON TABLE "public"."hh_feature_updates" TO "anon";
GRANT ALL ON TABLE "public"."hh_feature_updates" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_feature_updates" TO "service_role";
GRANT ALL ON TABLE "public"."hh_feature_updates_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_feature_updates_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_feature_updates_migration" TO "service_role";
GRANT ALL ON TABLE "public"."hh_licenses" TO "anon";
GRANT ALL ON TABLE "public"."hh_licenses" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_licenses" TO "service_role";
GRANT ALL ON TABLE "public"."hh_licenses_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_licenses_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_licenses_migration" TO "service_role";
GRANT ALL ON TABLE "public"."hh_promo_codes" TO "anon";
GRANT ALL ON TABLE "public"."hh_promo_codes" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_promo_codes" TO "service_role";
GRANT ALL ON TABLE "public"."hh_prospect_customers" TO "anon";
GRANT ALL ON TABLE "public"."hh_prospect_customers" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_prospect_customers" TO "service_role";
GRANT ALL ON TABLE "public"."hh_prospect_customers_migration" TO "anon";
GRANT ALL ON TABLE "public"."hh_prospect_customers_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."hh_prospect_customers_migration" TO "service_role";
GRANT ALL ON TABLE "public"."interaction_partners" TO "anon";
GRANT ALL ON TABLE "public"."interaction_partners" TO "authenticated";
GRANT ALL ON TABLE "public"."interaction_partners" TO "service_role";
GRANT ALL ON TABLE "public"."jt_accounts_distribution" TO "anon";
GRANT ALL ON TABLE "public"."jt_accounts_distribution" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_accounts_distribution" TO "service_role";
GRANT ALL ON TABLE "public"."jt_active_account_distribution_grid" TO "anon";
GRANT ALL ON TABLE "public"."jt_active_account_distribution_grid" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_active_account_distribution_grid" TO "service_role";
GRANT ALL ON TABLE "public"."jt_activity_note_mentions" TO "anon";
GRANT ALL ON TABLE "public"."jt_activity_note_mentions" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_activity_note_mentions" TO "service_role";
GRANT ALL ON TABLE "public"."jt_associated_skus" TO "anon";
GRANT ALL ON TABLE "public"."jt_associated_skus" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_associated_skus" TO "service_role";
GRANT ALL ON TABLE "public"."jt_brand_events_migration" TO "anon";
GRANT ALL ON TABLE "public"."jt_brand_events_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_brand_events_migration" TO "service_role";
GRANT ALL ON TABLE "public"."jt_brand_promo_request_skus" TO "anon";
GRANT ALL ON TABLE "public"."jt_brand_promo_request_skus" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_brand_promo_request_skus" TO "service_role";
GRANT ALL ON TABLE "public"."jt_brand_promotion_skus" TO "anon";
GRANT ALL ON TABLE "public"."jt_brand_promotion_skus" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_brand_promotion_skus" TO "service_role";
GRANT ALL ON TABLE "public"."jt_category_review_contacts" TO "anon";
GRANT ALL ON TABLE "public"."jt_category_review_contacts" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_category_review_contacts" TO "service_role";
GRANT ALL ON TABLE "public"."jt_contacts_distributor_rep_accounts" TO "anon";
GRANT ALL ON TABLE "public"."jt_contacts_distributor_rep_accounts" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_contacts_distributor_rep_accounts" TO "service_role";
GRANT ALL ON TABLE "public"."jt_deal_category_reviews" TO "anon";
GRANT ALL ON TABLE "public"."jt_deal_category_reviews" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_deal_category_reviews" TO "service_role";
GRANT ALL ON TABLE "public"."jt_deal_comment_mentions" TO "anon";
GRANT ALL ON TABLE "public"."jt_deal_comment_mentions" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_deal_comment_mentions" TO "service_role";
GRANT ALL ON TABLE "public"."jt_deal_distribution" TO "anon";
GRANT ALL ON TABLE "public"."jt_deal_distribution" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_deal_distribution" TO "service_role";
GRANT ALL ON TABLE "public"."jt_deal_owners" TO "anon";
GRANT ALL ON TABLE "public"."jt_deal_owners" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_deal_owners" TO "service_role";
GRANT ALL ON TABLE "public"."jt_deal_spec_price_sheet" TO "anon";
GRANT ALL ON TABLE "public"."jt_deal_spec_price_sheet" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_deal_spec_price_sheet" TO "service_role";
GRANT ALL ON TABLE "public"."jt_deal_task_pipeline" TO "anon";
GRANT ALL ON TABLE "public"."jt_deal_task_pipeline" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_deal_task_pipeline" TO "service_role";
GRANT ALL ON TABLE "public"."jt_demo_brands" TO "anon";
GRANT ALL ON TABLE "public"."jt_demo_brands" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_demo_brands" TO "service_role";
GRANT ALL ON TABLE "public"."jt_hh_customers_accounts_deals" TO "anon";
GRANT ALL ON TABLE "public"."jt_hh_customers_accounts_deals" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_hh_customers_accounts_deals" TO "service_role";
GRANT ALL ON TABLE "public"."jt_hh_customers_licenses(deprecated)" TO "anon";
GRANT ALL ON TABLE "public"."jt_hh_customers_licenses(deprecated)" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_hh_customers_licenses(deprecated)" TO "service_role";
GRANT ALL ON TABLE "public"."jt_hh_customers_master_categories" TO "anon";
GRANT ALL ON TABLE "public"."jt_hh_customers_master_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_hh_customers_master_categories" TO "service_role";
GRANT ALL ON TABLE "public"."jt_master_categories_brands_migration" TO "anon";
GRANT ALL ON TABLE "public"."jt_master_categories_brands_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_master_categories_brands_migration" TO "service_role";
GRANT ALL ON TABLE "public"."jt_master_category_review_data_brands" TO "anon";
GRANT ALL ON TABLE "public"."jt_master_category_review_data_brands" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_master_category_review_data_brands" TO "service_role";
GRANT ALL ON TABLE "public"."jt_master_category_review_data_matching" TO "anon";
GRANT ALL ON TABLE "public"."jt_master_category_review_data_matching" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_master_category_review_data_matching" TO "service_role";
GRANT ALL ON TABLE "public"."jt_principal_list_product_images" TO "anon";
GRANT ALL ON TABLE "public"."jt_principal_list_product_images" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_principal_list_product_images" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_accounts_category_review_received_status" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_accounts_category_review_received_status" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_accounts_category_review_received_status" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_accounts_flag_for_attention" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_accounts_flag_for_attention" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_accounts_flag_for_attention" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_accounts_industry_tags" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_accounts_industry_tags" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_accounts_industry_tags" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_active_services" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_active_services" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_active_services" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_announcement_tag" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_announcement_tag" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_announcement_tag" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_applied_services" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_applied_services" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_applied_services" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_brand_attention_flag" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_brand_attention_flag" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_brand_attention_flag" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_brand_audience_tag" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_brand_audience_tag" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_brand_audience_tag" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_brand_status" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_brand_status" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_brand_status" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_categories_for_principal_list" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_categories_for_principal_list" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_categories_for_principal_list" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_contact_department_tags" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_contact_department_tags" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_contact_department_tags" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_contacts_flag_for_attention" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_contacts_flag_for_attention" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_contacts_flag_for_attention" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_coverage" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_coverage" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_coverage" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_departments" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_departments" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_departments" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_hh_community_expert_services_offered" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_hh_community_expert_services_offered" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_hh_community_expert_services_offered" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_hh_expert_services_offered" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_hh_expert_services_offered" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_hh_expert_services_offered" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_no_contact_details" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_no_contact_details" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_no_contact_details" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_product_sub_category" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_product_sub_category" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_product_sub_category" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_sos_program_type" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_sos_program_type" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_sos_program_type" TO "service_role";
GRANT ALL ON TABLE "public"."jt_ref_sub_tags" TO "anon";
GRANT ALL ON TABLE "public"."jt_ref_sub_tags" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_ref_sub_tags" TO "service_role";
GRANT ALL ON TABLE "public"."jt_retailer_category_to_gn_categories" TO "anon";
GRANT ALL ON TABLE "public"."jt_retailer_category_to_gn_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_retailer_category_to_gn_categories" TO "service_role";
GRANT ALL ON TABLE "public"."jt_spec_price_sheet_categories" TO "anon";
GRANT ALL ON TABLE "public"."jt_spec_price_sheet_categories" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_spec_price_sheet_categories" TO "service_role";
GRANT ALL ON TABLE "public"."jt_sync_up_notes_accounts" TO "anon";
GRANT ALL ON TABLE "public"."jt_sync_up_notes_accounts" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_sync_up_notes_accounts" TO "service_role";
GRANT ALL ON TABLE "public"."jt_sync_up_notes_brands" TO "anon";
GRANT ALL ON TABLE "public"."jt_sync_up_notes_brands" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_sync_up_notes_brands" TO "service_role";
GRANT ALL ON TABLE "public"."jt_task_assignments" TO "anon";
GRANT ALL ON TABLE "public"."jt_task_assignments" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_task_assignments" TO "service_role";
GRANT ALL ON TABLE "public"."jt_task_pipeline_attachments" TO "anon";
GRANT ALL ON TABLE "public"."jt_task_pipeline_attachments" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_task_pipeline_attachments" TO "service_role";
GRANT ALL ON TABLE "public"."jt_user_notifications" TO "anon";
GRANT ALL ON TABLE "public"."jt_user_notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_user_notifications" TO "service_role";
GRANT ALL ON TABLE "public"."jt_user_role_dept" TO "anon";
GRANT ALL ON TABLE "public"."jt_user_role_dept" TO "authenticated";
GRANT ALL ON TABLE "public"."jt_user_role_dept" TO "service_role";
GRANT ALL ON TABLE "public"."master_categories_migration" TO "anon";
GRANT ALL ON TABLE "public"."master_categories_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."master_categories_migration" TO "service_role";
GRANT ALL ON TABLE "public"."master_category_review_data_migration" TO "anon";
GRANT ALL ON TABLE "public"."master_category_review_data_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."master_category_review_data_migration" TO "service_role";
GRANT ALL ON TABLE "public"."master_promo_data" TO "anon";
GRANT ALL ON TABLE "public"."master_promo_data" TO "authenticated";
GRANT ALL ON TABLE "public"."master_promo_data" TO "service_role";
GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";
GRANT ALL ON TABLE "public"."notifications(deprecated)" TO "anon";
GRANT ALL ON TABLE "public"."notifications(deprecated)" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications(deprecated)" TO "service_role";
GRANT ALL ON TABLE "public"."planned_submissions" TO "anon";
GRANT ALL ON TABLE "public"."planned_submissions" TO "authenticated";
GRANT ALL ON TABLE "public"."planned_submissions" TO "service_role";
GRANT ALL ON TABLE "public"."principal_list_product_specs" TO "anon";
GRANT ALL ON TABLE "public"."principal_list_product_specs" TO "authenticated";
GRANT ALL ON TABLE "public"."principal_list_product_specs" TO "service_role";
GRANT ALL ON TABLE "public"."prospects (deprecated)" TO "anon";
GRANT ALL ON TABLE "public"."prospects (deprecated)" TO "authenticated";
GRANT ALL ON TABLE "public"."prospects (deprecated)" TO "service_role";
GRANT ALL ON TABLE "public"."ref_	hh_product_interest_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_	hh_product_interest_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_	hh_product_interest_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_	hh_product_interest_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_	hh_product_interest_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_	hh_product_interest_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_account_flag_for_attention_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_account_flag_for_attention_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_account_flag_for_attention_enum" TO "service_role";
GRANT ALL ON TABLE "public"."ref_active_services" TO "anon";
GRANT ALL ON TABLE "public"."ref_active_services" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_active_services" TO "service_role";
GRANT ALL ON TABLE "public"."ref_announcement_tag" TO "anon";
GRANT ALL ON TABLE "public"."ref_announcement_tag" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_announcement_tag" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_announcement_tag_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_announcement_tag_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_announcement_tag_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_attendance_status_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_attendance_status_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_attendance_status_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_attendance_status_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_attendance_status_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_attendance_status_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_brand_attention_flag_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_brand_attention_flag_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_brand_attention_flag_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_attention_flag_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_attention_flag_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_attention_flag_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_brand_audience_tag" TO "anon";
GRANT ALL ON TABLE "public"."ref_brand_audience_tag" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_brand_audience_tag" TO "service_role";
GRANT ALL ON TABLE "public"."ref_brand_promo_table_distributors" TO "anon";
GRANT ALL ON TABLE "public"."ref_brand_promo_table_distributors" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_brand_promo_table_distributors" TO "service_role";
GRANT ALL ON TABLE "public"."ref_brand_status" TO "anon";
GRANT ALL ON TABLE "public"."ref_brand_status" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_brand_status" TO "service_role";
GRANT ALL ON TABLE "public"."ref_categories_for_principal_list" TO "anon";
GRANT ALL ON TABLE "public"."ref_categories_for_principal_list" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_categories_for_principal_list" TO "service_role";
GRANT ALL ON TABLE "public"."ref_category_review_received_status" TO "anon";
GRANT ALL ON TABLE "public"."ref_category_review_received_status" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_category_review_received_status" TO "service_role";
GRANT ALL ON TABLE "public"."ref_category_review_type" TO "anon";
GRANT ALL ON TABLE "public"."ref_category_review_type" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_category_review_type" TO "service_role";
GRANT ALL ON TABLE "public"."ref_contact_department_tags" TO "anon";
GRANT ALL ON TABLE "public"."ref_contact_department_tags" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_contact_department_tags" TO "service_role";
GRANT ALL ON TABLE "public"."ref_contacts_flag_for_attention" TO "anon";
GRANT ALL ON TABLE "public"."ref_contacts_flag_for_attention" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_contacts_flag_for_attention" TO "service_role";
GRANT ALL ON TABLE "public"."ref_country" TO "anon";
GRANT ALL ON TABLE "public"."ref_country" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_country" TO "service_role";
GRANT ALL ON TABLE "public"."ref_coverage" TO "anon";
GRANT ALL ON TABLE "public"."ref_coverage" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_coverage" TO "service_role";
GRANT ALL ON TABLE "public"."ref_deal_stage" TO "anon";
GRANT ALL ON TABLE "public"."ref_deal_stage" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_deal_stage" TO "service_role";
GRANT ALL ON TABLE "public"."ref_decision_level_tag_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_decision_level_tag_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_decision_level_tag_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_decision_level_tag_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_decision_level_tag_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_decision_level_tag_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_demo_status_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_demo_status_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_demo_status_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_demo_status_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_demo_status_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_demo_status_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_departments" TO "anon";
GRANT ALL ON TABLE "public"."ref_departments" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_departments" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_departments_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_departments_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_departments_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_flag_for_attention_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_flag_for_attention_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_flag_for_attention_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_goodnow_event _participation_status" TO "anon";
GRANT ALL ON TABLE "public"."ref_goodnow_event _participation_status" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_goodnow_event _participation_status" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_goodnow_event _participation_status_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_goodnow_event _participation_status_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_goodnow_event _participation_status_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_billing_terms_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_billing_terms_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_billing_terms_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_hh_billing_terms_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_hh_billing_terms_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_hh_billing_terms_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_community_expert_services_offered" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_community_expert_services_offered" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_community_expert_services_offered" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_contact_source_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_contact_source_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_contact_source_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_hh_contact_source_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_hh_contact_source_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_hh_contact_source_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_customer_status" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_customer_status" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_customer_status" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_hh_customer_status_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_hh_customer_status_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_hh_customer_status_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_expert_services_offered" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_expert_services_offered" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_expert_services_offered" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_how_found_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_how_found_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_how_found_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_hh_how_found_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_hh_how_found_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_hh_how_found_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_lead_source" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_lead_source" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_lead_source" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_payment_status_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_payment_status_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_payment_status_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_hh_payment_status_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_hh_payment_status_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_hh_payment_status_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_hh_user_role_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_hh_user_role_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_hh_user_role_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_hh_user_role_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_hh_user_role_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_hh_user_role_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_industry_tag" TO "anon";
GRANT ALL ON TABLE "public"."ref_industry_tag" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_industry_tag" TO "service_role";
GRANT ALL ON TABLE "public"."ref_no_contact_details" TO "anon";
GRANT ALL ON TABLE "public"."ref_no_contact_details" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_no_contact_details" TO "service_role";
GRANT ALL ON TABLE "public"."ref_product_subcategory_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_product_subcategory_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_product_subcategory_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_product_subcategory_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_product_subcategory_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_product_subcategory_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_promo_delivery" TO "anon";
GRANT ALL ON TABLE "public"."ref_promo_delivery" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_promo_delivery" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_promo_delivery_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_promo_delivery_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_promo_delivery_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_promo_types" TO "anon";
GRANT ALL ON TABLE "public"."ref_promo_types" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_promo_types" TO "service_role";
GRANT ALL ON TABLE "public"."ref_prospect_status" TO "anon";
GRANT ALL ON TABLE "public"."ref_prospect_status" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_prospect_status" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_prospect_status_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_prospect_status_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_prospect_status_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_sos_calling_year" TO "anon";
GRANT ALL ON TABLE "public"."ref_sos_calling_year" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_sos_calling_year" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_sos_calling_year_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_sos_calling_year_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_sos_calling_year_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_sos_program_type" TO "anon";
GRANT ALL ON TABLE "public"."ref_sos_program_type" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_sos_program_type" TO "service_role";
GRANT ALL ON TABLE "public"."ref_task_type_enum" TO "anon";
GRANT ALL ON TABLE "public"."ref_task_type_enum" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_task_type_enum" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_task_type_enum_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_task_type_enum_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_task_type_enum_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ref_verification_status" TO "anon";
GRANT ALL ON TABLE "public"."ref_verification_status" TO "authenticated";
GRANT ALL ON TABLE "public"."ref_verification_status" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ref_verification_status_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ref_verification_status_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ref_verification_status_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."retailer_gnf_category_matching" TO "anon";
GRANT ALL ON TABLE "public"."retailer_gnf_category_matching" TO "authenticated";
GRANT ALL ON TABLE "public"."retailer_gnf_category_matching" TO "service_role";
GRANT ALL ON TABLE "public"."retailer_gnf_category_matching_migration" TO "anon";
GRANT ALL ON TABLE "public"."retailer_gnf_category_matching_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."retailer_gnf_category_matching_migration" TO "service_role";
GRANT ALL ON TABLE "public"."roles" TO "anon";
GRANT ALL ON TABLE "public"."roles" TO "authenticated";
GRANT ALL ON TABLE "public"."roles" TO "service_role";
GRANT ALL ON TABLE "public"."sample_shipment_tracking" TO "anon";
GRANT ALL ON TABLE "public"."sample_shipment_tracking" TO "authenticated";
GRANT ALL ON TABLE "public"."sample_shipment_tracking" TO "service_role";
GRANT ALL ON TABLE "public"."sku_account_distribution" TO "anon";
GRANT ALL ON TABLE "public"."sku_account_distribution" TO "authenticated";
GRANT ALL ON TABLE "public"."sku_account_distribution" TO "service_role";
GRANT ALL ON TABLE "public"."sku_images" TO "anon";
GRANT ALL ON TABLE "public"."sku_images" TO "authenticated";
GRANT ALL ON TABLE "public"."sku_images" TO "service_role";
GRANT ALL ON TABLE "public"."sku_placements" TO "anon";
GRANT ALL ON TABLE "public"."sku_placements" TO "authenticated";
GRANT ALL ON TABLE "public"."sku_placements" TO "service_role";
GRANT ALL ON TABLE "public"."sku_product_category" TO "anon";
GRANT ALL ON TABLE "public"."sku_product_category" TO "authenticated";
GRANT ALL ON TABLE "public"."sku_product_category" TO "service_role";
GRANT ALL ON TABLE "public"."sos_authorizations" TO "anon";
GRANT ALL ON TABLE "public"."sos_authorizations" TO "authenticated";
GRANT ALL ON TABLE "public"."sos_authorizations" TO "service_role";
GRANT ALL ON TABLE "public"."sos_authorizations_migration" TO "anon";
GRANT ALL ON TABLE "public"."sos_authorizations_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."sos_authorizations_migration" TO "service_role";
GRANT ALL ON TABLE "public"."spec_price_sheet_migration" TO "anon";
GRANT ALL ON TABLE "public"."spec_price_sheet_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."spec_price_sheet_migration" TO "service_role";
GRANT ALL ON TABLE "public"."stat_card_table" TO "anon";
GRANT ALL ON TABLE "public"."stat_card_table" TO "authenticated";
GRANT ALL ON TABLE "public"."stat_card_table" TO "service_role";
GRANT ALL ON SEQUENCE "public"."stat_card_table_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."stat_card_table_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."stat_card_table_id_seq" TO "service_role";
GRANT ALL ON TABLE "public"."summarized_deadlines_for_calendar" TO "anon";
GRANT ALL ON TABLE "public"."summarized_deadlines_for_calendar" TO "authenticated";
GRANT ALL ON TABLE "public"."summarized_deadlines_for_calendar" TO "service_role";
GRANT ALL ON TABLE "public"."syncup_notes" TO "anon";
GRANT ALL ON TABLE "public"."syncup_notes" TO "authenticated";
GRANT ALL ON TABLE "public"."syncup_notes" TO "service_role";
GRANT ALL ON TABLE "public"."task_pipeline" TO "anon";
GRANT ALL ON TABLE "public"."task_pipeline" TO "authenticated";
GRANT ALL ON TABLE "public"."task_pipeline" TO "service_role";
GRANT ALL ON TABLE "public"."team_member_dept" TO "anon";
GRANT ALL ON TABLE "public"."team_member_dept" TO "authenticated";
GRANT ALL ON TABLE "public"."team_member_dept" TO "service_role";
GRANT ALL ON TABLE "public"."team_member_guide_migration" TO "anon";
GRANT ALL ON TABLE "public"."team_member_guide_migration" TO "authenticated";
GRANT ALL ON TABLE "public"."team_member_guide_migration" TO "service_role";
GRANT ALL ON TABLE "public"."test_brand_directory" TO "anon";
GRANT ALL ON TABLE "public"."test_brand_directory" TO "authenticated";
GRANT ALL ON TABLE "public"."test_brand_directory" TO "service_role";
GRANT ALL ON TABLE "public"."users_roles" TO "anon";
GRANT ALL ON TABLE "public"."users_roles" TO "authenticated";
GRANT ALL ON TABLE "public"."users_roles" TO "service_role";
GRANT ALL ON TABLE "public"."v_active_submission_opportunities" TO "anon";
GRANT ALL ON TABLE "public"."v_active_submission_opportunities" TO "authenticated";
GRANT ALL ON TABLE "public"."v_active_submission_opportunities" TO "service_role";
GRANT ALL ON TABLE "public"."v_activity_comments_with_profile" TO "anon";
GRANT ALL ON TABLE "public"."v_activity_comments_with_profile" TO "authenticated";
GRANT ALL ON TABLE "public"."v_activity_comments_with_profile" TO "service_role";
GRANT ALL ON TABLE "public"."v_brand_contacts" TO "anon";
GRANT ALL ON TABLE "public"."v_brand_contacts" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brand_contacts" TO "service_role";
GRANT ALL ON TABLE "public"."v_brand_distribution_grid" TO "anon";
GRANT ALL ON TABLE "public"."v_brand_distribution_grid" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brand_distribution_grid" TO "service_role";
GRANT ALL ON TABLE "public"."v_brand_promo_requests_with_skus" TO "anon";
GRANT ALL ON TABLE "public"."v_brand_promo_requests_with_skus" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brand_promo_requests_with_skus" TO "service_role";
GRANT ALL ON TABLE "public"."v_brand_promotions_with_skus" TO "anon";
GRANT ALL ON TABLE "public"."v_brand_promotions_with_skus" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brand_promotions_with_skus" TO "service_role";
GRANT ALL ON TABLE "public"."v_brand_submission_guide" TO "anon";
GRANT ALL ON TABLE "public"."v_brand_submission_guide" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brand_submission_guide" TO "service_role";
GRANT ALL ON TABLE "public"."v_brands_focus" TO "anon";
GRANT ALL ON TABLE "public"."v_brands_focus" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brands_focus" TO "service_role";
GRANT ALL ON TABLE "public"."v_brands_needing_attention" TO "anon";
GRANT ALL ON TABLE "public"."v_brands_needing_attention" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brands_needing_attention" TO "service_role";
GRANT ALL ON TABLE "public"."v_brands_view" TO "anon";
GRANT ALL ON TABLE "public"."v_brands_view" TO "authenticated";
GRANT ALL ON TABLE "public"."v_brands_view" TO "service_role";
GRANT ALL ON TABLE "public"."v_categories_with_brands" TO "anon";
GRANT ALL ON TABLE "public"."v_categories_with_brands" TO "authenticated";
GRANT ALL ON TABLE "public"."v_categories_with_brands" TO "service_role";
GRANT ALL ON TABLE "public"."v_category_review_calendar_data" TO "anon";
GRANT ALL ON TABLE "public"."v_category_review_calendar_data" TO "authenticated";
GRANT ALL ON TABLE "public"."v_category_review_calendar_data" TO "service_role";
GRANT ALL ON TABLE "public"."v_category_review_data" TO "anon";
GRANT ALL ON TABLE "public"."v_category_review_data" TO "authenticated";
GRANT ALL ON TABLE "public"."v_category_review_data" TO "service_role";
GRANT ALL ON TABLE "public"."v_category_review_summary" TO "anon";
GRANT ALL ON TABLE "public"."v_category_review_summary" TO "authenticated";
GRANT ALL ON TABLE "public"."v_category_review_summary" TO "service_role";
GRANT ALL ON TABLE "public"."v_category_reviews_with_matching_brands" TO "anon";
GRANT ALL ON TABLE "public"."v_category_reviews_with_matching_brands" TO "authenticated";
GRANT ALL ON TABLE "public"."v_category_reviews_with_matching_brands" TO "service_role";
GRANT ALL ON TABLE "public"."v_comments_with_author_details" TO "anon";
GRANT ALL ON TABLE "public"."v_comments_with_author_details" TO "authenticated";
GRANT ALL ON TABLE "public"."v_comments_with_author_details" TO "service_role";
GRANT ALL ON TABLE "public"."v_completed_demos" TO "anon";
GRANT ALL ON TABLE "public"."v_completed_demos" TO "authenticated";
GRANT ALL ON TABLE "public"."v_completed_demos" TO "service_role";
GRANT ALL ON TABLE "public"."v_daily_team_connects" TO "anon";
GRANT ALL ON TABLE "public"."v_daily_team_connects" TO "authenticated";
GRANT ALL ON TABLE "public"."v_daily_team_connects" TO "service_role";
GRANT ALL ON TABLE "public"."v_dashboard_summary" TO "anon";
GRANT ALL ON TABLE "public"."v_dashboard_summary" TO "authenticated";
GRANT ALL ON TABLE "public"."v_dashboard_summary" TO "service_role";
GRANT ALL ON TABLE "public"."v_deal_distribution" TO "anon";
GRANT ALL ON TABLE "public"."v_deal_distribution" TO "authenticated";
GRANT ALL ON TABLE "public"."v_deal_distribution" TO "service_role";
GRANT ALL ON TABLE "public"."v_deal_stage_history" TO "anon";
GRANT ALL ON TABLE "public"."v_deal_stage_history" TO "authenticated";
GRANT ALL ON TABLE "public"."v_deal_stage_history" TO "service_role";
GRANT ALL ON TABLE "public"."v_demo_calendar" TO "anon";
GRANT ALL ON TABLE "public"."v_demo_calendar" TO "authenticated";
GRANT ALL ON TABLE "public"."v_demo_calendar" TO "service_role";
GRANT ALL ON TABLE "public"."v_demo_check_ins" TO "anon";
GRANT ALL ON TABLE "public"."v_demo_check_ins" TO "authenticated";
GRANT ALL ON TABLE "public"."v_demo_check_ins" TO "service_role";
GRANT ALL ON TABLE "public"."v_full_contact" TO "anon";
GRANT ALL ON TABLE "public"."v_full_contact" TO "authenticated";
GRANT ALL ON TABLE "public"."v_full_contact" TO "service_role";
GRANT ALL ON TABLE "public"."v_gn_categories_with_retailer_mappings" TO "anon";
GRANT ALL ON TABLE "public"."v_gn_categories_with_retailer_mappings" TO "authenticated";
GRANT ALL ON TABLE "public"."v_gn_categories_with_retailer_mappings" TO "service_role";
GRANT ALL ON TABLE "public"."v_grouped_syncup_notes" TO "anon";
GRANT ALL ON TABLE "public"."v_grouped_syncup_notes" TO "authenticated";
GRANT ALL ON TABLE "public"."v_grouped_syncup_notes" TO "service_role";
GRANT ALL ON TABLE "public"."v_harvesthub_dashboard_stats" TO "anon";
GRANT ALL ON TABLE "public"."v_harvesthub_dashboard_stats" TO "authenticated";
GRANT ALL ON TABLE "public"."v_harvesthub_dashboard_stats" TO "service_role";
GRANT ALL ON TABLE "public"."v_harvesthub_prospect_customers_datagrid" TO "anon";
GRANT ALL ON TABLE "public"."v_harvesthub_prospect_customers_datagrid" TO "authenticated";
GRANT ALL ON TABLE "public"."v_harvesthub_prospect_customers_datagrid" TO "service_role";
GRANT ALL ON TABLE "public"."v_hh_customer_activity" TO "anon";
GRANT ALL ON TABLE "public"."v_hh_customer_activity" TO "authenticated";
GRANT ALL ON TABLE "public"."v_hh_customer_activity" TO "service_role";
GRANT ALL ON TABLE "public"."v_hh_upcoming_deadlines" TO "anon";
GRANT ALL ON TABLE "public"."v_hh_upcoming_deadlines" TO "authenticated";
GRANT ALL ON TABLE "public"."v_hh_upcoming_deadlines" TO "service_role";
GRANT ALL ON TABLE "public"."v_master_category_review_data" TO "anon";
GRANT ALL ON TABLE "public"."v_master_category_review_data" TO "authenticated";
GRANT ALL ON TABLE "public"."v_master_category_review_data" TO "service_role";
GRANT ALL ON TABLE "public"."v_my_internal_profile" TO "anon";
GRANT ALL ON TABLE "public"."v_my_internal_profile" TO "authenticated";
GRANT ALL ON TABLE "public"."v_my_internal_profile" TO "service_role";
GRANT ALL ON TABLE "public"."v_program_connects_by_month" TO "anon";
GRANT ALL ON TABLE "public"."v_program_connects_by_month" TO "authenticated";
GRANT ALL ON TABLE "public"."v_program_connects_by_month" TO "service_role";
GRANT ALL ON TABLE "public"."v_retailer_categories_with_gn_mappings" TO "anon";
GRANT ALL ON TABLE "public"."v_retailer_categories_with_gn_mappings" TO "authenticated";
GRANT ALL ON TABLE "public"."v_retailer_categories_with_gn_mappings" TO "service_role";
GRANT ALL ON TABLE "public"."v_review_data_comprehensive" TO "anon";
GRANT ALL ON TABLE "public"."v_review_data_comprehensive" TO "authenticated";
GRANT ALL ON TABLE "public"."v_review_data_comprehensive" TO "service_role";
GRANT ALL ON TABLE "public"."v_review_data_with_brands" TO "anon";
GRANT ALL ON TABLE "public"."v_review_data_with_brands" TO "authenticated";
GRANT ALL ON TABLE "public"."v_review_data_with_brands" TO "service_role";
GRANT ALL ON TABLE "public"."v_scheduled_demos" TO "anon";
GRANT ALL ON TABLE "public"."v_scheduled_demos" TO "authenticated";
GRANT ALL ON TABLE "public"."v_scheduled_demos" TO "service_role";
GRANT ALL ON TABLE "public"."v_sku_category_readable" TO "anon";
GRANT ALL ON TABLE "public"."v_sku_category_readable" TO "authenticated";
GRANT ALL ON TABLE "public"."v_sku_category_readable" TO "service_role";
GRANT ALL ON TABLE "public"."v_sos_authorizations_extended" TO "anon";
GRANT ALL ON TABLE "public"."v_sos_authorizations_extended" TO "authenticated";
GRANT ALL ON TABLE "public"."v_sos_authorizations_extended" TO "service_role";
GRANT ALL ON TABLE "public"."v_sos_authorizations_with_calculated_revenue" TO "anon";
GRANT ALL ON TABLE "public"."v_sos_authorizations_with_calculated_revenue" TO "authenticated";
GRANT ALL ON TABLE "public"."v_sos_authorizations_with_calculated_revenue" TO "service_role";
GRANT ALL ON TABLE "public"."v_spec_price_sheet" TO "anon";
GRANT ALL ON TABLE "public"."v_spec_price_sheet" TO "authenticated";
GRANT ALL ON TABLE "public"."v_spec_price_sheet" TO "service_role";
GRANT ALL ON TABLE "public"."v_tile_cards_total_sos_followups" TO "anon";
GRANT ALL ON TABLE "public"."v_tile_cards_total_sos_followups" TO "authenticated";
GRANT ALL ON TABLE "public"."v_tile_cards_total_sos_followups" TO "service_role";
GRANT ALL ON TABLE "public"."v_tile_cards_upcoming_reviews" TO "anon";
GRANT ALL ON TABLE "public"."v_tile_cards_upcoming_reviews" TO "authenticated";
GRANT ALL ON TABLE "public"."v_tile_cards_upcoming_reviews" TO "service_role";
GRANT ALL ON TABLE "public"."v_user_notifications_detail" TO "anon";
GRANT ALL ON TABLE "public"."v_user_notifications_detail" TO "authenticated";
GRANT ALL ON TABLE "public"."v_user_notifications_detail" TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";
drop extension if exists "pgjwt";
set check_function_bodies = off;
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
$function$;
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