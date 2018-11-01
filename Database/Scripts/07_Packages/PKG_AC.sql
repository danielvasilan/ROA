--------------------------------------------------------
--  DDL for Package PKG_AC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_AC" 
AS

PROCEDURE p_prep_log_vs_ac              (   p_year_month    VARCHAR2);

PROCEDURE p_generate_NIR                (   p_row_trh       WHS_TRN%ROWTYPE, 
                                            p_org_myself    VARCHAR2);

PROCEDURE p_generate_NIR_N              (   p_row_trh       WHS_TRN%ROWTYPE, 
                                            p_org_myself    VARCHAR2);

PROCEDURE p_generate_TRN                (   p_row_trh       WHS_TRN%ROWTYPE, 
                                            p_org_myself    VARCHAR2);

FUNCTION f_sql_frm_ac_analysis          (   p_ref_trn       NUMBER,
                                            p_year_month    VARCHAR2)
                                            RETURN          typ_frm     pipelined;

FUNCTION f_sql_frm_aca_detail           (   p_ref_trn       VARCHAR2)
                                            RETURN          typ_frm     pipelined;

PROCEDURE p_rep_nir                     (   p_org_code      VARCHAR2,
                                            p_doc_year      VARCHAR2,  
                                            p_doc_code      VARCHAR2);

PROCEDURE p_rep_bc                      (   p_org_code      VARCHAR2,
                                            p_doc_year      VARCHAR2,  
                                            p_doc_code      VARCHAR2,
                                            p_doc_type      VARCHAR2);

--PROCEDURE p_rep_nir                     (   p_ref_receipt   NUMBER);

PROCEDURE p_get_ac_header               (   p_row_ach       IN OUT  AC_HEADER%ROWTYPE,
                                            p_found         IN OUT  BOOLEAN);

PROCEDURE p_ac_engine                   (   p_ref_trn       NUMBER,
                                            p_force         VARCHAR2);

PROCEDURE p_auto_generate_doc           (   p_year_month    VARCHAR2);
                                            
PROCEDURE p_rep_engine                  (   p_org_code      VARCHAR2,
                                            p_doc_type      VARCHAR2,
                                            p_doc_year      VARCHAR2,  
                                            p_doc_code      VARCHAR2);

FUNCTION f_sql_frm_ac_period                RETURN          typ_frm     pipelined;
                                            

PROCEDURE p_generate_pmp                (   p_yearmonth     VARCHAR2,
                                            p_org_code      VARCHAR2,
                                            p_whs_code      VARCHAR2,
                                            p_item_type     VARCHAR2,
                                            p_season_code   VARCHAR2,
                                            p_only_rep      VARCHAR2, 
                                            p_commit        VARCHAR2    );

PROCEDURE p_close_month                 (   p_yearmonth     VARCHAR2    );

PROCEDURE p_open_month                  (   p_yearmonth     VARCHAR2    );
                                         
                                            
END;
 

/

/
