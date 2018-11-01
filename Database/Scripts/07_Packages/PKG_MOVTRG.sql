--------------------------------------------------------
--  DDL for Package PKG_MOVTRG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_MOVTRG" 
AS

PROCEDURE p_trg_stk_ini     ;

PROCEDURE p_trg_stk_add     (   p_new   WHS_TRN_DETAIL%ROWTYPE, 
                                p_old   WHS_TRN_DETAIL%ROWTYPE,
                                p_tip   VARCHAR2);
                            
PROCEDURE p_trg_stk_apply   ;

                            
END Pkg_MovTrg;
 

/

/
