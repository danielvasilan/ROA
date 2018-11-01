--------------------------------------------------------
--  DDL for Package PKG_RAP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_RAP" 
IS

FUNCTION f_reports_category                         RETURN          typ_cmb;

FUNCTION f_reports                              (   p_idcateg       NUMBER      )
                                                    RETURN          typ_cmb;

FUNCTION f_reports_parameter                    (   p_idReport      NUMBER,
                                                    p_type          VARCHAR2    )
                                                    RETURN          typ_frm;

FUNCTION f_loadrepcond                          (   p_idrep         INTEGER,
                                                    p_ord           INTEGER,
                                                    p_relcond       VARCHAR2    )
                                                    RETURN          typ_cmb;




PROCEDURE p_prep_receipt                        (
                                                    p_item_code     VARCHAR2,
                                                    p_org_code      VARCHAR2,
                                                    p_receipt_type  VARCHAR2,
                                                    p_start_date    DATE,
                                                    p_end_date      DATE,
                                                    p_suppl_code    VARCHAR2,
                                                    p_only_dif      VARCHAR2
                                                );


PROCEDURE p_rep_intrastat                       (
                                                    p_year_month      VARCHAR2
                                                );

PROCEDURE p_rep_item_transactions               (   p_org_code          VARCHAR2,
                                                    p_item_code         VARCHAR2,
                                                    p_oper_code_item    VARCHAR2,
                                                    p_size_code         VARCHAR2,
                                                    p_colour_code       VARCHAR2,
                                                    p_trn_type          VARCHAR2,
                                                    p_whs_code          VARCHAR2,
                                                    p_season_code       VARCHAR2,
                                                    p_order_code        VARCHAR2,
                                                    p_group_code        VARCHAR2,
                                                    p_start_date        DATE    ,
                                                    p_end_date          DATE
                                                );

PROCEDURE p_rep_receipt_difference              (
                                                    p_difference NUMBER
                                                );

PROCEDURE p_rep_whs_stoc                        (
                                                 p_org_code     VARCHAR2    ,
                                                 p_whs_code     VARCHAR2    ,
                                                 p_season_code  VARCHAR2    ,
                                                 p_family       VARCHAR2    ,
                                                 p_ref_date     DATE        ,
                                                 p_item_code    VARCHAR2    ,
                                                 p_selector     VARCHAR2    
                                                );
                                                
PROCEDURE p_rep_fifo_exceding                   (p_ref_shipment INTEGER);
                                                
                                                
END;
 

/

/
