--------------------------------------------------------
--  DDL for Package PKG_LOV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_LOV" 
IS


FUNCTION f_sql_lov_parameter                (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_parameter_value          (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_year                     (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_date                     (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;


FUNCTION f_sql_lov_item                     (p_item VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_organization             (p_org_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_organization_loc         (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_warehouse                (p_whs_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_movement_type            (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_primary_uom              (p_puom VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_work_order               (p_search   VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_work_group               (p_search   VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_item_size                (p_size_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_cat_mat_type             (p_categ_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_operation                (p_oper_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_colour                   (p_colour_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_app_user                 (p_user_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_work_season              (p_season_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;



FUNCTION f_sql_lov_warehuose_grp            (p_whs_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_operation_grp            (p_oper_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_custom                   (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_delivery_condition       (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_setup_shipment           (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_sales_family             (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;

FUNCTION f_sql_lov_shipment                 (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_cost                     (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_account_code             (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_currency                 (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_order_status             (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_year_month               (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_cost_center              (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_multi_table              (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
-- new development ------------------------------
FUNCTION f_sql_lov_country                  (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_setup_receipt            (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_routing                  (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_workcenter               (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_warehouse_categ          (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_setup_acrec              (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_value_ad_tax             (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;

FUNCTION f_sql_lov_teh_variable             (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_teh_value                (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;

FUNCTION f_sql_lov_receipt_fifo             (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_ord_status               (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_pkg_status               (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_item_type                (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_fixed_asset_categ        (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_fa_deprec_type           (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_fa_trn_type              (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_fa_status                (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;

FUNCTION f_sql_lov_inventory_status         (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_inventory_type           (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_inventory_attr           (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_cost_code                (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;

FUNCTION f_sql_lov_stg_file_type            (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;
FUNCTION f_sql_lov_ship_pack_mode           (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined;


END;

/

/
