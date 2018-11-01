--------------------------------------------------------
--  DDL for Package PKG_SHIPMENT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_SHIPMENT" 
IS


CURSOR  C_SHIPMENT_DETAIL(p_ref_shipment INTEGER) IS
            SELECT  COUNT(*)                        line_count,
                    SUM(d.weight_net)               weight_net,
                    SUM(d.qty_doc)                  qty_total
            FROM    SHIPMENT_DETAIL  d
            WHERE   d.ref_shipment   =   p_ref_shipment
            ;

FUNCTION f_sql_setup_shipment                       RETURN typ_frm  pipelined;


FUNCTION f_sql_shipment_header                      (       p_line_id       INTEGER ,
                                                            p_org_code      VARCHAR2    DEFAULT NULL,
                                                            p_ship_year     VARCHAR2    DEFAULT NULL
                                                    )  RETURN typ_frm  pipelined;

FUNCTION f_sql_shipment_detail                      (       p_line_id       INTEGER ,
                                                            p_ref_shipment  INTEGER DEFAULT NULL
                                                     )  RETURN typ_longinfo  pipelined;

FUNCTION f_sql_shipment_fifo                        (       p_line_id       INTEGER,
                                                            p_ref_shipment  INTEGER DEFAULT NULL
                                                    )  RETURN typ_frm  pipelined;


PROCEDURE p_shipment_header_iud                     (p_tip VARCHAR2, p_row SHIPMENT_HEADER%ROWTYPE);
PROCEDURE p_shipment_header_blo                     (p_tip VARCHAR2, p_row IN OUT SHIPMENT_HEADER%ROWTYPE);


PROCEDURE p_shipment_detail_iud                     (p_tip VARCHAR2, p_row SHIPMENT_DETAIL%ROWTYPE);
PROCEDURE p_shipment_detail_blo                     ( p_tip   VARCHAR2, p_row IN OUT SHIPMENT_DETAIL%ROWTYPE);

FUNCTION f_sql_shipment_package                     (p_line_id INTEGER,p_ref_shipment INTEGER DEFAULT NULL)  RETURN typ_frm  pipelined;
PROCEDURE p_shipment_package_iud                    (p_tip VARCHAR2, p_row SHIPMENT_PACKAGE%ROWTYPE);



PROCEDURE p_prepare_pick_shipment                   (   p_ref_shipment  INTEGER,
                                                        p_org_code      VARCHAR2,
                                                        p_whs_code      VARCHAR2);

PROCEDURE p_shipment_from_picking                   (   p_ref_shipment  NUMBER);

FUNCTION f_sql_pick_shipment                        (   p_ref_shipment  INTEGER     ,
                                                        p_whs_code      VARCHAR2    )
                                                        RETURN          typ_frm     pipelined;

PROCEDURE p_shipment_order_iud                      (   p_tip           VARCHAR2,
                                                        p_row           SHIPMENT_ORDER%ROWTYPE);


PROCEDURE p_prep_packlist                           (   p_ref_shipment  INTEGER);

FUNCTION f_sql_shipment_order                       (   p_line_id       INTEGER     ,
                                                        p_ref_shipment  INTEGER     DEFAULT NULL,
                                                        p_ship_year     VARCHAR2    DEFAULT NULL
                                                    )   RETURN          typ_frm     pipelined;
PROCEDURE p_shipment_from_warehouse                 (   p_ref_shipment      INTEGER ,
                                                        p_date_legal        DATE    ,
                                                        p_ignore_error      VARCHAR2
                                                    );
PROCEDURE p_download_fifo                           (   p_ref_shipment   INTEGER,
                                                        p_ignore_error   VARCHAR2,
                                                        p_flag_commit    BOOLEAN DEFAULT TRUE,
                                                        p_flag_from_stage   BOOLEAN DEFAULT FALSE
                                                    );



PROCEDURE p_shipment_undo                           (
                                                        p_ref_shipment      INTEGER,
                                                        p_flag_confirm      VARCHAR2
                                                    );


PROCEDURE p_shipment_cancel                         (
                                                        p_ref_shipment      INTEGER,
                                                        p_flag_confirm      VARCHAR2
                                                    );

PROCEDURE p_fifo_material_iud                       (   p_tip           VARCHAR2, 
                                                        p_row           FIFO_MATERIAL%ROWTYPE);

PROCEDURE p_fifo_material_blo                       (   p_tip           VARCHAR2, 
                                                        p_row IN OUT    FIFO_MATERIAL%ROWTYPE);

PROCEDURE p_shipment_print                          (   p_ref_shipment  INTEGER);


FUNCTION f_sql_fifo_header    (     p_line_id       INTEGER ,
                                    p_org_code      VARCHAR2    DEFAULT NULL,
                                    p_yyyymm_start  VARCHAR2    DEFAULT NULL,
                                    p_yyyymm_end    VARCHAR2    DEFAULT NULL,
                                    p_suppl_code    VARCHAR2    DEFAULT NULL,
                                    p_season_code   VARCHAR2    DEFAULT NULL,
                                    p_description   VARCHAR2    DEFAULT NULL,
                                    p_flag_stock    VARCHAR2    DEFAULT NULL
                              )  RETURN typ_frm  pipelined;


FUNCTION f_sql_fifo_detail                          (   p_line_id       INTEGER ,
                                                        p_ref_receipt   INTEGER     DEFAULT NULL
                                                    )   RETURN typ_frm  pipelined;
                                                    
                                                    
PROCEDURE p_shipment_from_package                   (   p_ref_shipment  NUMBER,
                                                        p_force         VARCHAR2);

PROCEDURE p_shipment_order_generate                 (   p_ref_shipment  INTEGER );

PROCEDURE p_rep_deliv_order                         (   p_ref_ship      NUMBER  );

PROCEDURE p_rep_fifo_reg                            (   p_org_code      VARCHAR2, 
                                                        p_start_date    DATE, 
                                                        p_end_date      DATE);    
END;

/

/
