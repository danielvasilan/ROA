--------------------------------------------------------
--  DDL for Package PKG_AC_FAIO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_AC_FAIO" 
AS
-----------------------------------------------------------------------------------------------
--  DDL:        29.07.2008 d Create package
--   
--  PURPOSE:    Fixed-assets + Inventory Objects logics 
-----------------------------------------------------------------------------------------------

FUNCTION f_sql_fixed_asset      (   p_idriga            NUMBER, 
                                    p_org_code          VARCHAR2,
                                    p_status            VARCHAR2
                                )   RETURN              typ_longinfo    pipelined;


PROCEDURE p_fixed_asset_iud     (   p_tip               VARCHAR2,
                                    p_row               FIXED_ASSET%ROWTYPE);

FUNCTION f_sql_fa_trn           (   p_idriga            NUMBER,
                                    p_fa_code           VARCHAR2
                                )   RETURN              typ_frm     pipelined;

FUNCTION f_sql_depreciation     (   p_curr_value        NUMBER,
                                    p_start_date        DATE,
                                    p_curr_date         DATE,
                                    p_deprec_months     INTEGER,
                                    p_deprec_type       VARCHAR2
                                )   RETURN              typ_frm     pipelined;

PROCEDURE p_fa_trn_iud          (   p_tip               VARCHAR2,
                                    p_row               FA_TRN%ROWTYPE);

PROCEDURE p_acquisition         (   p_org_code          VARCHAR2,
                                    p_fa_code           VARCHAR2, 
                                    p_trn_type          VARCHAR2,
                                    p_doc_date          DATE,
                                    p_doc_code          VARCHAR2, 
                                    p_supplier_code     VARCHAR2, 
                                    p_price             NUMBER,
                                    p_currency_code     VARCHAR2,
                                    p_user_rec          VARCHAR2);

PROCEDURE p_transfer            (   p_org_code          VARCHAR2,
                                    p_fa_code           VARCHAR2, 
                                    p_trn_date          DATE, 
                                    p_resp_user         VARCHAR2,
                                    p_resp_cdc          VARCHAR2);


PROCEDURE p_fa_sheet            (   p_org_code          VARCHAR2, 
                                    p_fa_code           VARCHAR2);

PROCEDURE p_depreciate          (   p_org_code          VARCHAR2, 
                                    p_month             VARCHAR2, 
                                    p_year              VARCHAR2);


END;
 

/

/
