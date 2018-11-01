--------------------------------------------------------
--  DDL for Package PKG_RECEIPT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_RECEIPT" 
IS

CURSOR  C_RECEIPT_DETAIL(p_ref_receipt INTEGER) IS
            SELECT  COUNT(*)                                        line_count,
                    NVL(SUM(ROUND(d.qty_doc * d.price_doc,2)),0)    total_value,
                    NVL(SUM(ROUND(d.weight_net,2)),0)                total_weight_net,
                    NVL(SUM(ROUND(d.weight_brut,2)),0)               total_weight_brut,
                    NVL(SUM(ROUND(d.weight_pack,2)),0)               total_weight_pack,
                    MIN(d.season_code)                              min_season,
                    MAX(d.season_code)                              max_season
            FROM    RECEIPT_DETAIL  d
            WHERE   d.ref_receipt   =   p_ref_receipt
            ;



FUNCTION f_sql_setup_receipt                    RETURN typ_frm  pipelined;
FUNCTION f_sql_receipt_header                   (   p_line_id       INTEGER ,
                                                    p_org_code      VARCHAR2    DEFAULT NULL,
                                                    p_receipt_year  VARCHAR2    DEFAULT NULL
                                                )  RETURN typ_frm  pipelined;
FUNCTION f_sql_receipt_detail                   (p_line_id INTEGER,p_ref_receipt INTEGER DEFAULT NULL)  RETURN typ_frm  pipelined;
PROCEDURE p_receipt_header_blo                  (p_tip VARCHAR2, p_row IN OUT RECEIPT_HEADER%ROWTYPE);
PROCEDURE p_receipt_header_iud                  (p_tip VARCHAR2, p_row RECEIPT_HEADER%ROWTYPE);
PROCEDURE p_receipt_detail_blo                  (p_tip VARCHAR2, p_row IN OUT RECEIPT_DETAIL%ROWTYPE);
PROCEDURE p_receipt_detail_iud                  (p_tip VARCHAR2, p_row RECEIPT_DETAIL%ROWTYPE);
PROCEDURE p_receipt_to_warehouse                (   p_idriga            INTEGER ,
                                                    p_date_legal        DATE    ,
                                                    p_force_qty_dif     VARCHAR2
                                                 )  ;

PROCEDURE p_receipt_undo                        (   p_ref_receipt       INTEGER,
                                                    p_flag_confirm      VARCHAR2
                                                );

PROCEDURE p_receipt_to_transit                  (   p_idriga            INTEGER)  ;

PROCEDURE p_auto_distribute_weight              (   p_ref_receipt       INTEGER,
                                                    p_weight_net        NUMBER,
                                                    p_flag_confirm      VARCHAR2
                                                );

PROCEDURE p_receipt_cancel                      (
                                                    p_ref_receipt       INTEGER,
                                                    p_flag_confirm      VARCHAR2
                                                );

PROCEDURE p_get_trn_header                      (   p_row       IN OUT  WHS_TRN%ROWTYPE, 
                                                    p_found     IN OUT  BOOLEAN
                                                );




END;
 

/

/
