--------------------------------------------------------
--  DDL for Package PKG_AUDIT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_AUDIT" 
IS

--   functie de returnare flag
FUNCTION f_return_faudit            RETURN INTEGER;
PROCEDURE p_set_audit               (p_val INTEGER);
PROCEDURE p_app_audit_insert ( p_tbl_oper   VARCHAR2,
                               p_tbl_name   VARCHAR2,
                               p_tbl_idriga INTEGER,
                               p_tbl_idx1   VARCHAR2,
                               p_tbl_idx2   VARCHAR2,
                               p_note       VARCHAR2
                              );

FUNCTION f_sql_audit_tables    RETURN       typ_frm         pipelined;

FUNCTION f_sql_audit_list   (   p_tbl_name  VARCHAR2,
                                p_idx1      VARCHAR2,
                                p_idx2      VARCHAR2,
                                p_datain    DATE,
                                p_datasf    DATE,
                                p_note      VARCHAR2,
                                p_line_id   NUMBER          DEFAULT NULL
                            )   RETURN      typ_frm         pipelined;

FUNCTION f_sql_audit_line   (   p_idriga NUMBER,p_tbl_name  VARCHAR2,
                                p_line_id   NUMBER          
                            )   RETURN      typ_frm         pipelined;


END;
 

/

/
