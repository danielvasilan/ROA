--------------------------------------------------------
--  DDL for Package PKG_TEH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_TEH" 
AS

FUNCTION f_sql_item_variable    (   p_line_id       NUMBER,
                                    p_org_code      VARCHAR2, 
                                    p_item_code     VARCHAR2)         
                                    RETURN          typ_frm    pipelined;

PROCEDURE p_item_variable_iud   (   p_tip           VARCHAR2,
                                    p_row           ITEM_VARIABLE%ROWTYPE);

FUNCTION f_str_item_variable    (   p_org_code      VARCHAR2, 
                                    p_item_code     VARCHAR2)
                                    RETURN          VARCHAR2;

FUNCTION f_sql_all_item_variable(   p_line_id       NUMBER,
                                    p_org_code      VARCHAR2, 
                                    p_var_code      VARCHAR2)         
                                    RETURN          typ_frm    pipelined;
                                    
END;
 

/

/
