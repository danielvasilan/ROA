--------------------------------------------------------
--  DDL for Package PKG_INV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_INV" 
IS

PROCEDURE p_inventory_iud               (   p_tip VARCHAR2, p_row INVENTORY%ROWTYPE);
PROCEDURE p_inventory_detail_iud        (   p_tip VARCHAR2, p_row INVENTORY_DETAIL%ROWTYPE);
PROCEDURE p_inventory_setup_iud         (   p_tip VARCHAR2, p_row INVENTORY_SETUP%ROWTYPE);


FUNCTION f_sql_inventory_detail         (   p_line_id           NUMBER,
                                            p_ref_inventory     NUMBER)
                                            RETURN              typ_frm     pipelined;
                                              
FUNCTION f_sql_inventory                (   p_line_id           NUMBER,
                                            p_org_code          VARCHAR2)
                                            RETURN              typ_frm     pipelined;  

FUNCTION f_sql_inventory_setup          (   p_line_id           NUMBER,
                                            p_ref_inventory     NUMBER)
                                            RETURN              typ_frm     pipelined;
                                            
PROCEDURE p_freeze_stock                (   p_ref_inventory     NUMBER,
                                            p_commit            VARCHAR2);

PROCEDURE p_detail_from_stock           (   p_ref_inventory     NUMBER,
                                            p_commit            VARCHAR2);
                                            
PROCEDURE p_rep_inv_list                (   p_ref_inventory     NUMBER, 
                                            p_whs_code          VARCHAR2,
                                            p_rep_type          VARCHAR2);
                                            
PROCEDURE p_inventory_launch            (   p_ref_inventory     NUMBER);

PROCEDURE p_inventory_apply             (   p_ref_inventory     NUMBER);

END;
 

/

/
