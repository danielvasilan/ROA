--------------------------------------------------------
--  DDL for Package PKG_AC_REC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_AC_REC" 
IS

CURSOR  C_ACREC_DETAIL(p_ref_acrec INTEGER) IS
            SELECT  COUNT(*)                                line_count,
                    ROUND(SUM(d.qty_doc * d.unit_price),2)  total_value,
                    SUM(d.qty_doc)                          total_qty
            FROM    ACREC_DETAIL  d
            WHERE   d.ref_acrec   =   p_ref_acrec
            ;


FUNCTION f_sql_setup_acrec              RETURN typ_frm  pipelined;



FUNCTION f_sql_acrec_header             (           p_line_id       INTEGER ,
                                                    p_org_code      VARCHAR2    DEFAULT NULL,
                                                    p_acrec_year     VARCHAR2    DEFAULT NULL
                                        )  RETURN typ_longinfo  pipelined;
FUNCTION f_sql_acrec_detail             (p_line_id INTEGER,p_ref_acrec INTEGER DEFAULT NULL)  RETURN typ_frm  pipelined;

FUNCTION f_sql_pick_acrec               (p_ref_acrec INTEGER, p_org_code VARCHAR2)  RETURN typ_frm  pipelined;


PROCEDURE p_acrec_header_iud            (p_tip VARCHAR2, p_row ACREC_HEADER%ROWTYPE);
PROCEDURE p_acrec_header_blo            (p_tip VARCHAR2, p_row IN OUT ACREC_HEADER%ROWTYPE);

PROCEDURE p_acrec_detail_iud            (p_tip  VARCHAR2, p_row ACREC_DETAIL%ROWTYPE);
PROCEDURE p_acrec_detail_blo            ( p_tip VARCHAR2, p_row IN OUT ACREC_DETAIL%ROWTYPE);
     
FUNCTION f_sql_price_list_sales         (p_line_id INTEGER,p_org_code VARCHAR2 DEFAULT NULL)  RETURN typ_frm  pipelined;
PROCEDURE p_price_list_sales_blo        (p_tip VARCHAR2, p_row IN OUT PRICE_LIST_SALES%ROWTYPE);
PROCEDURE p_price_list_sales_iud        (p_tip VARCHAR2, p_row PRICE_LIST_SALES%ROWTYPE);

PROCEDURE p_acrec_from_picking          (p_ref_acrec INTEGER, p_ref_shipment VARCHAR2);

PROCEDURE p_acrec_print                 (p_ref_acrec INTEGER);
PROCEDURE p_acrec_print_02              (p_ref_acrec INTEGER, p_lang_code varchar2);

PROCEDURE p_acrec_clear                 (p_ref_acrec INTEGER, p_flag_confirm   VARCHAR2);
PROCEDURE p_acrec_cancel                (p_ref_acrec INTEGER, p_flag_confirm   VARCHAR2);
                                        

END;

/

/
