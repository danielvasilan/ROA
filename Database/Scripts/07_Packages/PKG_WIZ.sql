--------------------------------------------------------
--  DDL for Package PKG_WIZ
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_WIZ" 
AS


FUNCTION f_sql_vw_wiz               (   p_wiz_code      VARCHAR2,
                                        p_step_no       NUMBER)    
                                        RETURN          typ_frm     pipelined;

PROCEDURE p_vw_wiz_u                (   p_row           VW_wiz%ROWTYPE);


PROCEDURE p_load_engine             (   p_wiz_code      VARCHAR2, 
                                        p_step_no       INTEGER);


END;
 

/

/
