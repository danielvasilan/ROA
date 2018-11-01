--------------------------------------------------------
--  DDL for Package PKG_NOMENC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_NOMENC" 
IS

/*********************************************************************************
    DDL: 28/04/2008  z Create
/*********************************************************************************/
CURSOR  C_WAREHOUSE IS
        SELECT  *
        FROM    WAREHOUSE
        ORDER  BY whs_code
        ;




FUNCTION f_sql_warehouse_categ                          RETURN typ_frm  pipelined;
FUNCTION f_sql_warehouse                                RETURN typ_frm  pipelined;
PROCEDURE p_warehouse_categ_iud                         (p_tip VARCHAR2, p_row WAREHOUSE_CATEG%ROWTYPE);
FUNCTION f_sql_whs_trn_reason                           RETURN typ_frm  pipelined;
PROCEDURE p_whs_trn_reason_iud                          (p_tip VARCHAR2, p_row WHS_TRN_REASON%ROWTYPE);
PROCEDURE p_warehouse_iud                               (p_tip VARCHAR2, p_row WAREHOUSE%ROWTYPE);
FUNCTION f_sql_movement_type                            RETURN typ_frm  pipelined;
PROCEDURE p_movement_type_iud                           (p_tip VARCHAR2, p_row MOVEMENT_TYPE%ROWTYPE);
FUNCTION f_sql_organization                             RETURN typ_longinfo  pipelined;
PROCEDURE p_organization_iud                            (p_tip VARCHAR2, p_row ORGANIZATION%ROWTYPE);
PROCEDURE p_organization_blo                            (p_tip VARCHAR2, p_row IN OUT ORGANIZATION%ROWTYPE);
FUNCTION f_sql_organization_loc                         (p_org_code VARCHAR2)  RETURN typ_frm  pipelined;
PROCEDURE p_organization_loc_iud                        (p_tip VARCHAR2, p_row ORGANIZATION_LOC%ROWTYPE);
PROCEDURE p_warehouse_blo                               (p_tip VARCHAR2, p_row IN OUT WAREHOUSE%ROWTYPE);
FUNCTION f_sql_calendar                                 (p_year VARCHAR2)  RETURN typ_frm  pipelined;
FUNCTION f_sql_currency_rate                            (p_calendar_day VARCHAR2)  RETURN typ_frm  pipelined;
PROCEDURE p_calendar_iud                                (p_tip VARCHAR2, p_row CALENDAR%ROWTYPE);
PROCEDURE p_currency_rate_iud                           (p_tip VARCHAR2, p_row CURRENCY_RATE%ROWTYPE);
PROCEDURE p_currency_rate_blo                           (p_tip VARCHAR2, p_row IN OUT CURRENCY_RATE%ROWTYPE);
FUNCTION f_sql_primary_uom                              RETURN typ_frm  pipelined;
FUNCTION f_sql_item_size                                RETURN typ_frm  pipelined;
FUNCTION f_sql_cat_mat_type                             RETURN typ_frm  pipelined;
FUNCTION f_sql_colour                                   (p_org_code VARCHAR2)  RETURN typ_frm  pipelined;
FUNCTION f_sql_operation                                RETURN typ_frm  pipelined;
FUNCTION f_sql_work_season                              (p_org_code VARCHAR2)  RETURN typ_frm  pipelined;
FUNCTION f_sql_custom                                   RETURN typ_frm  pipelined;
FUNCTION f_sql_sales_family                             (p_org_code VARCHAR2)  RETURN typ_frm  pipelined;
PROCEDURE p_primary_uom_iud                             (p_tip VARCHAR2, p_row PRIMARY_UOM%ROWTYPE);
PROCEDURE p_item_size_iud                               (p_tip VARCHAR2, p_row ITEM_SIZE%ROWTYPE);
PROCEDURE p_cat_mat_type_iud                            (p_tip VARCHAR2, p_row CAT_MAT_TYPE%ROWTYPE);
PROCEDURE p_colour_iud                                   (p_tip VARCHAR2, p_row COLOUR%ROWTYPE);
PROCEDURE p_operation_iud                               (p_tip VARCHAR2, p_row OPERATION%ROWTYPE);
PROCEDURE p_work_season_iud                             (p_tip VARCHAR2, p_row WORK_SEASON%ROWTYPE);
PROCEDURE p_custom_iud                                  (p_tip VARCHAR2, p_row CUSTOM%ROWTYPE);
PROCEDURE p_sales_family_iud                            (p_tip VARCHAR2, p_row SALES_FAMILY%ROWTYPE);
PROCEDURE p_primary_uom_blo                             (p_tip VARCHAR2, p_row IN OUT PRIMARY_UOM%ROWTYPE);
PROCEDURE p_item_size_blo                               (p_tip VARCHAR2, p_row IN OUT ITEM_SIZE%ROWTYPE);
FUNCTION f_sql_multi_table                              (
                                                            p_line_id       INTEGER ,
                                                            p_table_name    VARCHAR2 DEFAULT NULL
                                                        )  RETURN typ_frm  pipelined;
PROCEDURE p_multi_table_iud                             (p_tip VARCHAR2, p_row MULTI_TABLE%ROWTYPE);

























FUNCTION f_sql_costcenter                                   RETURN              typ_frm     pipelined;

FUNCTION f_sql_workcenter                               (   p_costcenter_code   VARCHAR2
                                                        )   RETURN              typ_frm     pipelined;

PROCEDURE p_costcenter_iud                              (   p_tip               VARCHAR2,
                                                            p_row               COSTCENTER%ROWTYPE);

PROCEDURE p_workcenter_iud                              (   p_tip               VARCHAR2,
                                                            p_row               WORKCENTER%ROWTYPE);

FUNCTION f_get_myself_org                                   RETURN              VARCHAR2;

PROCEDURE p_workcenter_oper_iud                         (   p_tip               VARCHAR2,
                                                            p_row               WORKCENTER_OPER%ROWTYPE);

FUNCTION f_sql_workcenter_oper                          (   p_workcenter_code   VARCHAR2)
                                                            RETURN              typ_frm     pipelined;





END;
 

/

/
