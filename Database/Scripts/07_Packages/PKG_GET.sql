--------------------------------------------------------
--  DDL for Package PKG_GET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_GET" 
IS 
FUNCTION f_get_acrec_detail                       (p_row IN OUT ACREC_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_acrec_detail                      (p_row IN OUT ACREC_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_acrec_header                       (p_row IN OUT ACREC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_acrec_header                      (p_row IN OUT ACREC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_ac_account                         (p_row IN OUT AC_ACCOUNT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_ac_account                        (p_row IN OUT AC_ACCOUNT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_ac_detail                          (p_row IN OUT AC_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_ac_detail                         (p_row IN OUT AC_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_ac_document                        (p_row IN OUT AC_DOCUMENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_ac_document                       (p_row IN OUT AC_DOCUMENT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_ac_header                          (p_row IN OUT AC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_ac_header                         (p_row IN OUT AC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_ac_period                          (p_row IN OUT AC_PERIOD%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_ac_period                         (p_row IN OUT AC_PERIOD%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_app_audit                          (p_row IN OUT APP_AUDIT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_app_audit                         (p_row IN OUT APP_AUDIT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_app_doc_number                     (p_row IN OUT APP_DOC_NUMBER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_app_doc_number                    (p_row IN OUT APP_DOC_NUMBER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_app_securitem                      (p_row IN OUT APP_SECURITEM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_app_securitem                     (p_row IN OUT APP_SECURITEM%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_app_task                           (p_row IN OUT APP_TASK%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_app_task                          (p_row IN OUT APP_TASK%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_app_task_param                     (p_row IN OUT APP_TASK_PARAM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_app_task_param                    (p_row IN OUT APP_TASK_PARAM%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_app_task_step                      (p_row IN OUT APP_TASK_STEP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_app_task_step                     (p_row IN OUT APP_TASK_STEP%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_app_user                           (p_row IN OUT APP_USER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_app_user                          (p_row IN OUT APP_USER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_app_user_grant                     (p_row IN OUT APP_USER_GRANT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_app_user_grant                    (p_row IN OUT APP_USER_GRANT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_bom_group                          (p_row IN OUT BOM_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_bom_group                         (p_row IN OUT BOM_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_bom_std                            (p_row IN OUT BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_bom_std                           (p_row IN OUT BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_bom_wo                             (p_row IN OUT BOM_WO%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_bom_wo                            (p_row IN OUT BOM_WO%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_calendar                           (p_row IN OUT CALENDAR%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_calendar                          (p_row IN OUT CALENDAR%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_cat_custom                         (p_row IN OUT CAT_CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_cat_custom                        (p_row IN OUT CAT_CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_cat_mat_type                       (p_row IN OUT CAT_MAT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_cat_mat_type                      (p_row IN OUT CAT_MAT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_colour                             (p_row IN OUT COLOUR%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_colour                            (p_row IN OUT COLOUR%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_costcenter                         (p_row IN OUT COSTCENTER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_costcenter                        (p_row IN OUT COSTCENTER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_cost_detail                        (p_row IN OUT COST_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_cost_detail                       (p_row IN OUT COST_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_cost_header                        (p_row IN OUT COST_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_cost_header                       (p_row IN OUT COST_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_cost_type                          (p_row IN OUT COST_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_cost_type                         (p_row IN OUT COST_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_country                            (p_row IN OUT COUNTRY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_country                           (p_row IN OUT COUNTRY%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_currency                           (p_row IN OUT CURRENCY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_currency                          (p_row IN OUT CURRENCY%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_currency_rate                      (p_row IN OUT CURRENCY_RATE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_currency_rate                     (p_row IN OUT CURRENCY_RATE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_custom                             (p_row IN OUT CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_custom                            (p_row IN OUT CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_delivery_condition                 (p_row IN OUT DELIVERY_CONDITION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_delivery_condition                (p_row IN OUT DELIVERY_CONDITION%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_efficiency                         (p_row IN OUT EFFICIENCY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_efficiency                        (p_row IN OUT EFFICIENCY%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_fa_trn                             (p_row IN OUT FA_TRN%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_fa_trn                            (p_row IN OUT FA_TRN%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_fa_trn_type                        (p_row IN OUT FA_TRN_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_fa_trn_type                       (p_row IN OUT FA_TRN_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_fifo_exceding                      (p_row IN OUT FIFO_EXCEDING%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_fifo_exceding                     (p_row IN OUT FIFO_EXCEDING%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_fifo_material                      (p_row IN OUT FIFO_MATERIAL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_fifo_material                     (p_row IN OUT FIFO_MATERIAL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_fixed_asset                        (p_row IN OUT FIXED_ASSET%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_fixed_asset                       (p_row IN OUT FIXED_ASSET%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_fixed_asset_categ                  (p_row IN OUT FIXED_ASSET_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_fixed_asset_categ                 (p_row IN OUT FIXED_ASSET_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_group_routing                      (p_row IN OUT GROUP_ROUTING%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_group_routing                     (p_row IN OUT GROUP_ROUTING%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_import_text_file                   (p_row IN OUT IMPORT_TEXT_FILE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_import_text_file                  (p_row IN OUT IMPORT_TEXT_FILE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_inventory                          (p_row IN OUT INVENTORY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_inventory                         (p_row IN OUT INVENTORY%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_inventory_detail                   (p_row IN OUT INVENTORY_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_inventory_detail                  (p_row IN OUT INVENTORY_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_inventory_setup                    (p_row IN OUT INVENTORY_SETUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_inventory_setup                   (p_row IN OUT INVENTORY_SETUP%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_inventory_stoc                     (p_row IN OUT INVENTORY_STOC%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_inventory_stoc                    (p_row IN OUT INVENTORY_STOC%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_item                               (p_row IN OUT ITEM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_item                              (p_row IN OUT ITEM%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_item_cost                          (p_row IN OUT ITEM_COST%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_item_cost                         (p_row IN OUT ITEM_COST%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_item_cycle_time                    (p_row IN OUT ITEM_CYCLE_TIME%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_item_cycle_time                   (p_row IN OUT ITEM_CYCLE_TIME%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_item_mapping                       (p_row IN OUT ITEM_MAPPING%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_item_mapping                      (p_row IN OUT ITEM_MAPPING%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_item_size                          (p_row IN OUT ITEM_SIZE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_item_size                         (p_row IN OUT ITEM_SIZE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_item_type                          (p_row IN OUT ITEM_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_item_type                         (p_row IN OUT ITEM_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_item_variable                      (p_row IN OUT ITEM_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_item_variable                     (p_row IN OUT ITEM_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_line                               (p_row IN OUT LINE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_line                              (p_row IN OUT LINE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_macrorouting_detail                (p_row IN OUT MACROROUTING_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_macrorouting_detail               (p_row IN OUT MACROROUTING_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_macrorouting_header                (p_row IN OUT MACROROUTING_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_macrorouting_header               (p_row IN OUT MACROROUTING_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_movement_type                      (p_row IN OUT MOVEMENT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_movement_type                     (p_row IN OUT MOVEMENT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_multi_table                        (p_row IN OUT MULTI_TABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_multi_table                       (p_row IN OUT MULTI_TABLE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_operation                          (p_row IN OUT OPERATION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_operation                         (p_row IN OUT OPERATION%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_organization                       (p_row IN OUT ORGANIZATION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_organization                      (p_row IN OUT ORGANIZATION%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_organization_loc                   (p_row IN OUT ORGANIZATION_LOC%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_organization_loc                  (p_row IN OUT ORGANIZATION_LOC%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_package_detail                     (p_row IN OUT PACKAGE_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_package_detail                    (p_row IN OUT PACKAGE_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_package_header                     (p_row IN OUT PACKAGE_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_package_header                    (p_row IN OUT PACKAGE_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_package_trn_detail                 (p_row IN OUT PACKAGE_TRN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_package_trn_detail                (p_row IN OUT PACKAGE_TRN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_package_trn_header                 (p_row IN OUT PACKAGE_TRN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_package_trn_header                (p_row IN OUT PACKAGE_TRN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_parameter                          (p_row IN OUT PARAMETER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_parameter                         (p_row IN OUT PARAMETER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_parameter_attr                     (p_row IN OUT PARAMETER_ATTR%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_parameter_attr                    (p_row IN OUT PARAMETER_ATTR%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_parameter_code                     (p_row IN OUT PARAMETER_CODE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_parameter_code                    (p_row IN OUT PARAMETER_CODE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_patch_detail                       (p_row IN OUT PATCH_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_patch_detail                      (p_row IN OUT PATCH_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_patch_header                       (p_row IN OUT PATCH_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_patch_header                      (p_row IN OUT PATCH_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_po_ord_header                      (p_row IN OUT PO_ORD_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_po_ord_header                     (p_row IN OUT PO_ORD_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_po_ord_line                        (p_row IN OUT PO_ORD_LINE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_po_ord_line                       (p_row IN OUT PO_ORD_LINE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_price_list                         (p_row IN OUT PRICE_LIST%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_price_list                        (p_row IN OUT PRICE_LIST%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_price_list_sales                   (p_row IN OUT PRICE_LIST_SALES%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_price_list_sales                  (p_row IN OUT PRICE_LIST_SALES%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_primary_uom                        (p_row IN OUT PRIMARY_UOM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_primary_uom                       (p_row IN OUT PRIMARY_UOM%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_receipt_detail                     (p_row IN OUT RECEIPT_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_receipt_detail                    (p_row IN OUT RECEIPT_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_receipt_header                     (p_row IN OUT RECEIPT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_receipt_header                    (p_row IN OUT RECEIPT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_reports                            (p_row IN OUT REPORTS%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_reports                           (p_row IN OUT REPORTS%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_reports_category                   (p_row IN OUT REPORTS_CATEGORY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_reports_category                  (p_row IN OUT REPORTS_CATEGORY%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_reports_parameter                  (p_row IN OUT REPORTS_PARAMETER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_reports_parameter                 (p_row IN OUT REPORTS_PARAMETER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_sales_family                       (p_row IN OUT SALES_FAMILY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_sales_family                      (p_row IN OUT SALES_FAMILY%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_sales_order                        (p_row IN OUT SALES_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_sales_order                       (p_row IN OUT SALES_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_scan_event                         (p_row IN OUT SCAN_EVENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_scan_event                        (p_row IN OUT SCAN_EVENT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_setup_acrec                        (p_row IN OUT SETUP_ACREC%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_setup_acrec                       (p_row IN OUT SETUP_ACREC%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_setup_movement                     (p_row IN OUT SETUP_MOVEMENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_setup_movement                    (p_row IN OUT SETUP_MOVEMENT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_setup_receipt                      (p_row IN OUT SETUP_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_setup_receipt                     (p_row IN OUT SETUP_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_setup_shipment                     (p_row IN OUT SETUP_SHIPMENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_setup_shipment                    (p_row IN OUT SETUP_SHIPMENT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_shipment_detail                    (p_row IN OUT SHIPMENT_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_shipment_detail                   (p_row IN OUT SHIPMENT_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_shipment_header                    (p_row IN OUT SHIPMENT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_shipment_header                   (p_row IN OUT SHIPMENT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_shipment_order                     (p_row IN OUT SHIPMENT_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_shipment_order                    (p_row IN OUT SHIPMENT_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_shipment_package                   (p_row IN OUT SHIPMENT_PACKAGE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_shipment_package                  (p_row IN OUT SHIPMENT_PACKAGE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_so_detail                          (p_row IN OUT SO_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_so_detail                         (p_row IN OUT SO_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_stg_bom_std                        (p_row IN OUT STG_BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_stg_bom_std                       (p_row IN OUT STG_BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_stg_file_manager                   (p_row IN OUT STG_FILE_MANAGER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_stg_file_manager                  (p_row IN OUT STG_FILE_MANAGER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_stg_item                           (p_row IN OUT STG_ITEM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_stg_item                          (p_row IN OUT STG_ITEM%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_stg_parser                         (p_row IN OUT STG_PARSER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_stg_parser                        (p_row IN OUT STG_PARSER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_stg_receipt                        (p_row IN OUT STG_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_stg_receipt                       (p_row IN OUT STG_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_stg_ship_fifo                      (p_row IN OUT STG_SHIP_FIFO%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_stg_ship_fifo                     (p_row IN OUT STG_SHIP_FIFO%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_stg_work_order                     (p_row IN OUT STG_WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_stg_work_order                    (p_row IN OUT STG_WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_stg_wo_decl                        (p_row IN OUT STG_WO_DECL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_stg_wo_decl                       (p_row IN OUT STG_WO_DECL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_teh_variable                       (p_row IN OUT TEH_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_teh_variable                      (p_row IN OUT TEH_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_trn_plan_detail                    (p_row IN OUT TRN_PLAN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_trn_plan_detail                   (p_row IN OUT TRN_PLAN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_trn_plan_header                    (p_row IN OUT TRN_PLAN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_trn_plan_header                   (p_row IN OUT TRN_PLAN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_value_ad_tax                       (p_row IN OUT VALUE_AD_TAX%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_value_ad_tax                      (p_row IN OUT VALUE_AD_TAX%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_virtual_table                      (p_row IN OUT VIRTUAL_TABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_virtual_table                     (p_row IN OUT VIRTUAL_TABLE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_vw_prep_pick_plan                  (p_row IN OUT VW_PREP_PICK_PLAN%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_vw_prep_pick_plan                 (p_row IN OUT VW_PREP_PICK_PLAN%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_warehouse                          (p_row IN OUT WAREHOUSE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_warehouse                         (p_row IN OUT WAREHOUSE%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_warehouse_categ                    (p_row IN OUT WAREHOUSE_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_warehouse_categ                   (p_row IN OUT WAREHOUSE_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_web_grid_cm                        (p_row IN OUT WEB_GRID_CM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_web_grid_cm                       (p_row IN OUT WEB_GRID_CM%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_whs_trn                            (p_row IN OUT WHS_TRN%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_whs_trn                           (p_row IN OUT WHS_TRN%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_whs_trn_detail                     (p_row IN OUT WHS_TRN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_whs_trn_detail                    (p_row IN OUT WHS_TRN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_whs_trn_reason                     (p_row IN OUT WHS_TRN_REASON%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_whs_trn_reason                    (p_row IN OUT WHS_TRN_REASON%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_wiz_control                        (p_row IN OUT WIZ_CONTROL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_wiz_control                       (p_row IN OUT WIZ_CONTROL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_workcenter                         (p_row IN OUT WORKCENTER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_workcenter                        (p_row IN OUT WORKCENTER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_workcenter_oper                    (p_row IN OUT WORKCENTER_OPER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_workcenter_oper                   (p_row IN OUT WORKCENTER_OPER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_work_group                         (p_row IN OUT WORK_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_work_group                        (p_row IN OUT WORK_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_work_order                         (p_row IN OUT WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_work_order                        (p_row IN OUT WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_work_season                        (p_row IN OUT WORK_SEASON%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_work_season                       (p_row IN OUT WORK_SEASON%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_wo_detail                          (p_row IN OUT WO_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_wo_detail                         (p_row IN OUT WO_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0);
FUNCTION f_get_wo_group                           (p_row IN OUT WO_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;
PROCEDURE p_get_wo_group                          (p_row IN OUT WO_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0);
END; 

/

/