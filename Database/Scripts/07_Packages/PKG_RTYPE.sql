--------------------------------------------------------
--  DDL for Package PKG_RTYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_RTYPE" 
IS 
TYPE ta_acrec_detail                              IS TABLE OF acrec_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_acrec_detail                             IS TABLE OF acrec_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_acrec_header                              IS TABLE OF acrec_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_acrec_header                             IS TABLE OF acrec_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_ac_account                                IS TABLE OF ac_account%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_ac_account                               IS TABLE OF ac_account%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_ac_detail                                 IS TABLE OF ac_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_ac_detail                                IS TABLE OF ac_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_ac_document                               IS TABLE OF ac_document%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_ac_document                              IS TABLE OF ac_document%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_ac_header                                 IS TABLE OF ac_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_ac_header                                IS TABLE OF ac_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_ac_period                                 IS TABLE OF ac_period%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_ac_period                                IS TABLE OF ac_period%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_app_audit                                 IS TABLE OF app_audit%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_app_audit                                IS TABLE OF app_audit%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_app_doc_number                            IS TABLE OF app_doc_number%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_app_doc_number                           IS TABLE OF app_doc_number%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_app_securitem                             IS TABLE OF app_securitem%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_app_securitem                            IS TABLE OF app_securitem%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_app_task                                  IS TABLE OF app_task%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_app_task                                 IS TABLE OF app_task%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_app_task_param                            IS TABLE OF app_task_param%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_app_task_param                           IS TABLE OF app_task_param%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_app_task_step                             IS TABLE OF app_task_step%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_app_task_step                            IS TABLE OF app_task_step%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_app_user                                  IS TABLE OF app_user%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_app_user                                 IS TABLE OF app_user%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_app_user_grant                            IS TABLE OF app_user_grant%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_app_user_grant                           IS TABLE OF app_user_grant%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_bom_group                                 IS TABLE OF bom_group%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_bom_group                                IS TABLE OF bom_group%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_bom_std                                   IS TABLE OF bom_std%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_bom_std                                  IS TABLE OF bom_std%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_bom_wo                                    IS TABLE OF bom_wo%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_bom_wo                                   IS TABLE OF bom_wo%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_calendar                                  IS TABLE OF calendar%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_calendar                                 IS TABLE OF calendar%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_cat_custom                                IS TABLE OF cat_custom%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_cat_custom                               IS TABLE OF cat_custom%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_cat_mat_type                              IS TABLE OF cat_mat_type%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_cat_mat_type                             IS TABLE OF cat_mat_type%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_colour                                    IS TABLE OF colour%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_colour                                   IS TABLE OF colour%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_costcenter                                IS TABLE OF costcenter%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_costcenter                               IS TABLE OF costcenter%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_cost_detail                               IS TABLE OF cost_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_cost_detail                              IS TABLE OF cost_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_cost_header                               IS TABLE OF cost_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_cost_header                              IS TABLE OF cost_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_cost_type                                 IS TABLE OF cost_type%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_cost_type                                IS TABLE OF cost_type%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_country                                   IS TABLE OF country%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_country                                  IS TABLE OF country%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_currency                                  IS TABLE OF currency%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_currency                                 IS TABLE OF currency%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_currency_rate                             IS TABLE OF currency_rate%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_currency_rate                            IS TABLE OF currency_rate%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_custom                                    IS TABLE OF custom%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_custom                                   IS TABLE OF custom%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_delivery_condition                        IS TABLE OF delivery_condition%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_delivery_condition                       IS TABLE OF delivery_condition%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_efficiency                                IS TABLE OF efficiency%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_efficiency                               IS TABLE OF efficiency%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_fa_trn                                    IS TABLE OF fa_trn%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_fa_trn                                   IS TABLE OF fa_trn%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_fa_trn_type                               IS TABLE OF fa_trn_type%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_fa_trn_type                              IS TABLE OF fa_trn_type%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_fifo_exceding                             IS TABLE OF fifo_exceding%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_fifo_exceding                            IS TABLE OF fifo_exceding%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_fifo_material                             IS TABLE OF fifo_material%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_fifo_material                            IS TABLE OF fifo_material%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_fixed_asset                               IS TABLE OF fixed_asset%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_fixed_asset                              IS TABLE OF fixed_asset%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_fixed_asset_categ                         IS TABLE OF fixed_asset_categ%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_fixed_asset_categ                        IS TABLE OF fixed_asset_categ%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_group_routing                             IS TABLE OF group_routing%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_group_routing                            IS TABLE OF group_routing%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_import_text_file                          IS TABLE OF import_text_file%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_import_text_file                         IS TABLE OF import_text_file%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_inventory                                 IS TABLE OF inventory%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_inventory                                IS TABLE OF inventory%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_inventory_detail                          IS TABLE OF inventory_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_inventory_detail                         IS TABLE OF inventory_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_inventory_setup                           IS TABLE OF inventory_setup%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_inventory_setup                          IS TABLE OF inventory_setup%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_inventory_stoc                            IS TABLE OF inventory_stoc%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_inventory_stoc                           IS TABLE OF inventory_stoc%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_item                                      IS TABLE OF item%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_item                                     IS TABLE OF item%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_item_cost                                 IS TABLE OF item_cost%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_item_cost                                IS TABLE OF item_cost%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_item_cycle_time                           IS TABLE OF item_cycle_time%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_item_cycle_time                          IS TABLE OF item_cycle_time%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_item_mapping                              IS TABLE OF item_mapping%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_item_mapping                             IS TABLE OF item_mapping%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_item_size                                 IS TABLE OF item_size%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_item_size                                IS TABLE OF item_size%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_item_type                                 IS TABLE OF item_type%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_item_type                                IS TABLE OF item_type%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_item_variable                             IS TABLE OF item_variable%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_item_variable                            IS TABLE OF item_variable%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_line                                      IS TABLE OF line%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_line                                     IS TABLE OF line%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_macrorouting_detail                       IS TABLE OF macrorouting_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_macrorouting_detail                      IS TABLE OF macrorouting_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_macrorouting_header                       IS TABLE OF macrorouting_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_macrorouting_header                      IS TABLE OF macrorouting_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_movement_type                             IS TABLE OF movement_type%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_movement_type                            IS TABLE OF movement_type%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_multi_table                               IS TABLE OF multi_table%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_multi_table                              IS TABLE OF multi_table%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_operation                                 IS TABLE OF operation%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_operation                                IS TABLE OF operation%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_organization                              IS TABLE OF organization%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_organization                             IS TABLE OF organization%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_organization_loc                          IS TABLE OF organization_loc%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_organization_loc                         IS TABLE OF organization_loc%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_package_detail                            IS TABLE OF package_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_package_detail                           IS TABLE OF package_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_package_header                            IS TABLE OF package_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_package_header                           IS TABLE OF package_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_package_trn_detail                        IS TABLE OF package_trn_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_package_trn_detail                       IS TABLE OF package_trn_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_package_trn_header                        IS TABLE OF package_trn_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_package_trn_header                       IS TABLE OF package_trn_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_parameter                                 IS TABLE OF parameter%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_parameter                                IS TABLE OF parameter%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_parameter_attr                            IS TABLE OF parameter_attr%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_parameter_attr                           IS TABLE OF parameter_attr%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_parameter_code                            IS TABLE OF parameter_code%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_parameter_code                           IS TABLE OF parameter_code%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_patch_detail                              IS TABLE OF patch_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_patch_detail                             IS TABLE OF patch_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_patch_header                              IS TABLE OF patch_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_patch_header                             IS TABLE OF patch_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_po_ord_header                             IS TABLE OF po_ord_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_po_ord_header                            IS TABLE OF po_ord_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_po_ord_line                               IS TABLE OF po_ord_line%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_po_ord_line                              IS TABLE OF po_ord_line%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_price_list                                IS TABLE OF price_list%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_price_list                               IS TABLE OF price_list%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_price_list_sales                          IS TABLE OF price_list_sales%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_price_list_sales                         IS TABLE OF price_list_sales%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_primary_uom                               IS TABLE OF primary_uom%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_primary_uom                              IS TABLE OF primary_uom%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_receipt_detail                            IS TABLE OF receipt_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_receipt_detail                           IS TABLE OF receipt_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_receipt_header                            IS TABLE OF receipt_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_receipt_header                           IS TABLE OF receipt_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_reports                                   IS TABLE OF reports%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_reports                                  IS TABLE OF reports%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_reports_category                          IS TABLE OF reports_category%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_reports_category                         IS TABLE OF reports_category%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_reports_parameter                         IS TABLE OF reports_parameter%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_reports_parameter                        IS TABLE OF reports_parameter%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_report_queue_detail                       IS TABLE OF report_queue_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_report_queue_detail                      IS TABLE OF report_queue_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_report_queue_header                       IS TABLE OF report_queue_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_report_queue_header                      IS TABLE OF report_queue_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_sales_family                              IS TABLE OF sales_family%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_sales_family                             IS TABLE OF sales_family%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_sales_order                               IS TABLE OF sales_order%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_sales_order                              IS TABLE OF sales_order%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_scan_event                                IS TABLE OF scan_event%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_scan_event                               IS TABLE OF scan_event%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_setup_acrec                               IS TABLE OF setup_acrec%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_setup_acrec                              IS TABLE OF setup_acrec%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_setup_movement                            IS TABLE OF setup_movement%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_setup_movement                           IS TABLE OF setup_movement%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_setup_receipt                             IS TABLE OF setup_receipt%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_setup_receipt                            IS TABLE OF setup_receipt%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_setup_shipment                            IS TABLE OF setup_shipment%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_setup_shipment                           IS TABLE OF setup_shipment%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_shipment_detail                           IS TABLE OF shipment_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_shipment_detail                          IS TABLE OF shipment_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_shipment_header                           IS TABLE OF shipment_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_shipment_header                          IS TABLE OF shipment_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_shipment_order                            IS TABLE OF shipment_order%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_shipment_order                           IS TABLE OF shipment_order%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_shipment_package                          IS TABLE OF shipment_package%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_shipment_package                         IS TABLE OF shipment_package%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_so_detail                                 IS TABLE OF so_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_so_detail                                IS TABLE OF so_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_status_history                            IS TABLE OF status_history%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_status_history                           IS TABLE OF status_history%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stg_bom_std                               IS TABLE OF stg_bom_std%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stg_bom_std                              IS TABLE OF stg_bom_std%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stg_file_manager                          IS TABLE OF stg_file_manager%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stg_file_manager                         IS TABLE OF stg_file_manager%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stg_item                                  IS TABLE OF stg_item%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stg_item                                 IS TABLE OF stg_item%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stg_parser                                IS TABLE OF stg_parser%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stg_parser                               IS TABLE OF stg_parser%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stg_receipt                               IS TABLE OF stg_receipt%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stg_receipt                              IS TABLE OF stg_receipt%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stg_ship_fifo                             IS TABLE OF stg_ship_fifo%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stg_ship_fifo                            IS TABLE OF stg_ship_fifo%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stg_work_order                            IS TABLE OF stg_work_order%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stg_work_order                           IS TABLE OF stg_work_order%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stg_wo_decl                               IS TABLE OF stg_wo_decl%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stg_wo_decl                              IS TABLE OF stg_wo_decl%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_teh_variable                              IS TABLE OF teh_variable%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_teh_variable                             IS TABLE OF teh_variable%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_tmp_general                               IS TABLE OF tmp_general%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_tmp_general                              IS TABLE OF tmp_general%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_tmp_segment                               IS TABLE OF tmp_segment%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_tmp_segment                              IS TABLE OF tmp_segment%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_trn_plan_detail                           IS TABLE OF trn_plan_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_trn_plan_detail                          IS TABLE OF trn_plan_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_trn_plan_header                           IS TABLE OF trn_plan_header%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_trn_plan_header                          IS TABLE OF trn_plan_header%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_value_ad_tax                              IS TABLE OF value_ad_tax%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_value_ad_tax                             IS TABLE OF value_ad_tax%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_virtual_table                             IS TABLE OF virtual_table%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_virtual_table                            IS TABLE OF virtual_table%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_warehouse                                 IS TABLE OF warehouse%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_warehouse                                IS TABLE OF warehouse%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_warehouse_categ                           IS TABLE OF warehouse_categ%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_warehouse_categ                          IS TABLE OF warehouse_categ%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_web_grid_cm                               IS TABLE OF web_grid_cm%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_web_grid_cm                              IS TABLE OF web_grid_cm%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_whs_trn                                   IS TABLE OF whs_trn%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_whs_trn                                  IS TABLE OF whs_trn%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_whs_trn_detail                            IS TABLE OF whs_trn_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_whs_trn_detail                           IS TABLE OF whs_trn_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_whs_trn_reason                            IS TABLE OF whs_trn_reason%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_whs_trn_reason                           IS TABLE OF whs_trn_reason%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_wiz_control                               IS TABLE OF wiz_control%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_wiz_control                              IS TABLE OF wiz_control%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_workcenter                                IS TABLE OF workcenter%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_workcenter                               IS TABLE OF workcenter%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_workcenter_oper                           IS TABLE OF workcenter_oper%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_workcenter_oper                          IS TABLE OF workcenter_oper%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_work_group                                IS TABLE OF work_group%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_work_group                               IS TABLE OF work_group%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_work_order                                IS TABLE OF work_order%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_work_order                               IS TABLE OF work_order%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_work_season                               IS TABLE OF work_season%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_work_season                              IS TABLE OF work_season%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_wo_detail                                 IS TABLE OF wo_detail%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_wo_detail                                IS TABLE OF wo_detail%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_wo_group                                  IS TABLE OF wo_group%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_wo_group                                 IS TABLE OF wo_group%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_x_work_bench                              IS TABLE OF x_work_bench%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_x_work_bench                             IS TABLE OF x_work_bench%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stoc_online                               IS TABLE OF stoc_online%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stoc_online                              IS TABLE OF stoc_online%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_stoc_online_previous                      IS TABLE OF stoc_online_previous%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_stoc_online_previous                     IS TABLE OF stoc_online_previous%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_blo_grp_assoc_chk                      IS TABLE OF vw_blo_grp_assoc_chk%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_blo_grp_assoc_chk                     IS TABLE OF vw_blo_grp_assoc_chk%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_blo_import_wo                          IS TABLE OF vw_blo_import_wo%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_blo_import_wo                         IS TABLE OF vw_blo_import_wo%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_blo_prepare_trn                        IS TABLE OF vw_blo_prepare_trn%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_blo_prepare_trn                       IS TABLE OF vw_blo_prepare_trn%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_blo_work_group                         IS TABLE OF vw_blo_work_group%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_blo_work_group                        IS TABLE OF vw_blo_work_group%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_blo_work_order                         IS TABLE OF vw_blo_work_order%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_blo_work_order                        IS TABLE OF vw_blo_work_order%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_excel_operations                       IS TABLE OF vw_excel_operations%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_excel_operations                      IS TABLE OF vw_excel_operations%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_prep_pick_plan                         IS TABLE OF vw_prep_pick_plan%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_prep_pick_plan                        IS TABLE OF vw_prep_pick_plan%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_bom_std                            IS TABLE OF vw_rep_bom_std%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_bom_std                           IS TABLE OF vw_rep_bom_std%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_deliv                              IS TABLE OF vw_rep_deliv%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_deliv                             IS TABLE OF vw_rep_deliv%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_fa_sheet                           IS TABLE OF vw_rep_fa_sheet%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_fa_sheet                          IS TABLE OF vw_rep_fa_sheet%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_fifo_reg                           IS TABLE OF vw_rep_fifo_reg%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_fifo_reg                          IS TABLE OF vw_rep_fifo_reg%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_grp_sheet                          IS TABLE OF vw_rep_grp_sheet%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_grp_sheet                         IS TABLE OF vw_rep_grp_sheet%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_inv_list                           IS TABLE OF vw_rep_inv_list%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_inv_list                          IS TABLE OF vw_rep_inv_list%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_order_situation                    IS TABLE OF vw_rep_order_situation%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_order_situation                   IS TABLE OF vw_rep_order_situation%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_pkg_sit                            IS TABLE OF vw_rep_pkg_sit%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_pkg_sit                           IS TABLE OF vw_rep_pkg_sit%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_po_order                           IS TABLE OF vw_rep_po_order%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_po_order                          IS TABLE OF vw_rep_po_order%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_wip                                IS TABLE OF vw_rep_wip%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_wip                               IS TABLE OF vw_rep_wip%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_rep_wip_grouped                        IS TABLE OF vw_rep_wip_grouped%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_rep_wip_grouped                       IS TABLE OF vw_rep_wip_grouped%ROWTYPE INDEX BY VARCHAR2(1000);
TYPE ta_vw_wiz                                    IS TABLE OF vw_wiz%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE tas_vw_wiz                                   IS TABLE OF vw_wiz%ROWTYPE INDEX BY VARCHAR2(1000);
END; 

/

/
