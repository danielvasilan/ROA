--------------------------------------------------------
--  DDL for Package PKG_ITEM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_ITEM" 
IS

FUNCTION f_sql_item                             (   p_line_id           NUMBER,
                                                    p_org_code          VARCHAR2, 
                                                    p_make_buy          VARCHAR2, 
                                                    p_mat_type          VARCHAR2,
                                                    p_type_code         VARCHAR2)     
                                                    RETURN              typ_longinfo    pipelined;

FUNCTION f_sql_item_component                   (   p_line_id           NUMBER,
                                                    p_org_code          VARCHAR2,
                                                    p_item_code         VARCHAR2) 
                                                    RETURN              typ_frm         pipelined;

FUNCTION f_sql_item_parent                      (   p_line_id           NUMBER,
                                                    p_org_code          VARCHAR2,
                                                    p_item_code         VARCHAR2) 
                                                    RETURN              typ_frm         pipelined;

FUNCTION f_sql_item_stock                       (   p_line_id           NUMBER,
                                                    p_org_code          VARCHAR2,
                                                    p_item_code         VARCHAR2)     
                                                    RETURN              typ_frm         pipelined;

FUNCTION f_sql_item_cycle_time                  (   p_item_code         VARCHAR2) 
                                                    RETURN              typ_frm         pipelined;

FUNCTION f_sql_item_demand                      (   p_line_id           NUMBER,
                                                    p_org_code          VARCHAR2,
                                                    p_item_code         VARCHAR2)     
                                                    RETURN              typ_frm         pipelined;

PROCEDURE p_item_blo                            (p_tip VARCHAR2, p_row IN OUT ITEM%ROWTYPE);
PROCEDURE p_item_iud                            (p_tip VARCHAR2, p_row ITEM%ROWTYPE);
PROCEDURE p_chk_bom_std_iud                     (p_tip VARCHAR2, p_row IN OUT BOM_STD%ROWTYPE);
PROCEDURE p_bom_std_iud                         (p_tip VARCHAR2, p_row BOM_STD%ROWTYPE);

PROCEDURE p_check_colour_size                   (   p_org_code          VARCHAR2,
                                                    p_item_code         VARCHAR2,
                                                    p_flag_colour       INTEGER ,
                                                    p_colour_code       VARCHAR2,
                                                    p_flag_size         INTEGER,
                                                    p_size_code         VARCHAR2
                                                );

PROCEDURE p_duplicate_item                      (   p_ref_item          INTEGER,
                                                    p_new_item_code     VARCHAR2,
                                                    p_copy_bom          VARCHAR2);

PROCEDURE p_item_replace                        (   p_org_code          VARCHAR2, 
                                                    p_item_orig         VARCHAR2,
                                                    p_item_dest         VARCHAR2);


FUNCTION f_sql_item_mapping                     (   p_line_id           INTEGER,
                                                    p_org_code_src      VARCHAR2    DEFAULT NULL,
                                                    p_org_code_dst      VARCHAR2    DEFAULT NULL
                                                )   RETURN              typ_frm     pipelined;
                                                
PROCEDURE p_item_mapping_iud                    (   p_tip               VARCHAR2, 
                                                    p_row               ITEM_MAPPING%ROWTYPE);

PROCEDURE p_check_item_attr                     (   p_row_it            ITEM%ROWTYPE,
                                                    p_colour_code       VARCHAR2,
                                                    p_size_code         VARCHAR2);

FUNCTION f_sql_item_cost                        (   p_line_id           INTEGER,
                                                    p_cost_code         VARCHAR2,
                                                    p_org_code          VARCHAR2,
                                                    p_partner_code      VARCHAR2,
                                                    p_only_active       VARCHAR2
                                                )   RETURN              typ_frm     pipelined;   
                                                                                                 
PROCEDURE p_item_cost_iud                       (   p_tip               VARCHAR2, 
                                                    p_row               ITEM_COST%ROWTYPE);

PROCEDURE p_rep_bom_std                         (   p_org_code          varchar2, 
                                                    p_father_code       varchar2, 
                                                    p_valued            varchar2,
                                                    p_ref_size          varchar2);
                                                    
                                                    
END;
 

/

/
