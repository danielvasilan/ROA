--------------------------------------------------------
--  DDL for Package PKG_SCAN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_SCAN" 
AS

-- sql functions for forms record-source 
FUNCTION f_sql_package              (   p_package_code      VARCHAR2    )         
                                        RETURN              typ_frm     pipelined;

FUNCTION f_sql_package_header       (   p_org_code          VARCHAR2,
                                        p_status            VARCHAR2    )         
                                        RETURN              typ_frm     pipelined;

FUNCTION f_sql_package_detail       (   p_idriga            NUMBER,
                                        p_package_code      VARCHAR2    )         
                                        RETURN              typ_frm     pipelined;
                                        

-- generate package headers automatically for a range 
PROCEDURE p_generate_package_id     (   p_org_code          VARCHAR2,
                                        p_number            NUMBER      );

-- scan controller (call the proper procedure, depending on some rules )  
PROCEDURE p_scan_event              (   p_scanner_code      VARCHAR2,
                                        p_context_code      VARCHAR2,
                                        p_scanned_value     VARCHAR2    );


-- procedure that treats the scanning of a package detail 
PROCEDURE p_scan_pkg_detail         (   p_package_code      VARCHAR2,
                                        p_scanned_value     VARCHAR2    );

-- validate an entire package                                         
PROCEDURE p_pkg_validate            (   p_package_code      VARCHAR2    );
                                        

PROCEDURE p_package_header_iud      (   p_tip               VARCHAR2,
                                        p_row               PACKAGE_HEADER%ROWTYPE);

PROCEDURE p_package_detail_iud      (   p_tip               VARCHAR2,
                                        p_row               PACKAGE_DETAIL%ROWTYPE);

PROCEDURE p_package_trn_detail_iud  (   p_tip               VARCHAR2,
                                        p_row               PACKAGE_TRN_DETAIL%ROWTYPE);

PROCEDURE p_prep_package            (   p_package_code      VARCHAR2    );                                        
                                        
PROCEDURE p_rep_pkg_order_size      (   p_org_code          VARCHAR2,
                                        p_order_code        VARCHAR2    );

PROCEDURE p_rep_pkg_sheet           (   p_package_code      VARCHAR2    );

                                
PROCEDURE p_scan_ship               (   p_ref_shipment      NUMBER,
                                        p_ship_code         VARCHAR2,
                                        p_scanned_value     VARCHAR2    );

PROCEDURE p_prep_ship               (   p_ref_shipment      NUMBER      );

FUNCTION f_sql_ship                 (   p_ship_code         VARCHAR2    )         
                                        RETURN              typ_frm         pipelined;

PROCEDURE p_prep_trn                (   p_ref_trn           NUMBER      , 
                                        p_org_code          VARCHAR2    );

FUNCTION f_sql_trn                      RETURN              typ_frm         pipelined;
                                        
PROCEDURE p_prep_ord_pkg_qty        (   p_org_code          VARCHAR2,
                                        p_order_code        VARCHAR2        );

PROCEDURE p_queue_pkg_sheet         (   p_package_code      VARCHAR2        , 
                                        p_force_print       VARCHAR2 := 'N' ); 

PROCEDURE p_queue_pkg_sheet_multi   (   p_org_code          VARCHAR2, 
                                        p_pkg_list          VARCHAR2,
                                        p_force             VARCHAR2);

                                        
PROCEDURE p_flush_queue             (   p_flag_all          VARCHAR2 DEFAULT 'N');

PROCEDURE p_pseudo_login            ;

PROCEDURE p_package_mov             (   p_ref_trn           NUMBER, 
                                        p_whs_code_in       VARCHAR2    ,
                                        p_commit            VARCHAR2);

PROCEDURE p_rep_pkg_key;

PROCEDURE p_gen_package_trn         (   p_ref_shipment          NUMBER, 
                                        p_whs_in                VARCHAR2, 
                                        p_ref_trn       IN OUT  NUMBER  );
                                
END;
 

/

/
