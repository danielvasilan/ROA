--------------------------------------------------------
--  DDL for Package PKG_STAGE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_STAGE" 
AS
-----------------------------------------------------------------------------------
-- PURPOSE: THIS PACKAGE contains the logic for importing data from txt files

C_DEFAULT_SIZE CONSTANT VARCHAR2(5) := 'X';  
    
FUNCTION f_item_code (p_item_code VARCHAR2) RETURN VARCHAR2;

PROCEDURE p_import_file             (   p_dir           VARCHAR2,
                                        p_filename      VARCHAR2,
                                        p_org_code      VARCHAR2);



PROCEDURE p_process_bom             (   p_file_id       NUMBER);

PROCEDURE p_process_bom_ruco        (   p_file_id       NUMBER);

PROCEDURE p_process_WO              (   p_file_id       NUMBER);

PROCEDURE p_process_rec_2           (   p_file_id       NUMBER);

PROCEDURE p_process_rec_3           (   p_file_id       NUMBER);

PROCEDURE p_validate_bom            (   p_file_id       NUMBER);

PROCEDURE p_validate_item           (   p_file_id       NUMBER);

FUNCTION f_sql_stg_parser               RETURN          typ_longinfo    pipelined;

FUNCTION f_sql_stg_filelist         (   p_org_code varchar2, 
                                        p_file_type varchar2)     
                                        RETURN          typ_frm         pipelined;

FUNCTION f_sql_stg_fileline         (   p_file_id       NUMBER)
                                        RETURN          typ_longinfo    pipelined;

FUNCTION f_sql_stg_bomstd           (   p_file_id       NUMBER)
                                        RETURN          typ_longinfo    pipelined;

FUNCTION f_sql_stg_item             (   p_file_id       NUMBER)
                                        RETURN          typ_longinfo    pipelined;

FUNCTION f_sql_stg_wo               (   p_file_id       NUMBER)
                                        RETURN          typ_longinfo    pipelined;

FUNCTION f_sql_stg_receipt          (   p_file_id       NUMBER)         
                                        RETURN          typ_longinfo    pipelined;

FUNCTION f_sql_stg_ship_fifo        (   p_file_id       NUMBER) 
                                        RETURN          typ_longinfo    pipelined;
                                        
FUNCTION f_sql_stg_wo_decl          (   p_file_id       NUMBER) 
                                        RETURN          typ_longinfo    pipelined;

PROCEDURE p_load_item               (   p_file_id       NUMBER);
PROCEDURE p_load_bom                (   p_file_id       NUMBER);

PROCEDURE p_process_file            (   p_ref_file      NUMBER);

PROCEDURE p_load                    (   p_ref_file      NUMBER);



-- IUD ON STG tables 

PROCEDURE p_stg_work_order_iud      (   p_tip           VARCHAR2,
                                        p_row           STG_WORK_ORDER%ROWTYPE);

PROCEDURE p_stg_wo_decl_iud         (   p_tip           VARCHAR2,
                                        p_row           STG_WO_DECL%ROWTYPE);

PROCEDURE p_stg_bom_std_iud        (    p_tip           VARCHAR2,
                                        p_row           STG_BOM_STD%ROWTYPE);
                                        
PROCEDURE p_stg_ship_fifo_iud      (    p_tip           VARCHAR2,
                                        p_row           STG_SHIP_FIFO%ROWTYPE);

PROCEDURE p_stg_item_iud            (   p_tip           VARCHAR2,
                                        p_row           STG_ITEM%ROWTYPE);

PROCEDURE p_stg_receipt_iud         (   p_tip           VARCHAR2,
                                        p_row           STG_RECEIPT%ROWTYPE);

PROCEDURE p_stg_file_manager_iud    (   p_tip           VARCHAR2,
                                        p_row           STG_FILE_MANAGER%ROWTYPE);

PROCEDURE p_stg_parser_iud          (   p_tip           VARCHAR2,
                                        p_row           STG_PARSER%ROWTYPE);
                                        
PROCEDURE p_import_text_file_iud    (   p_tip           VARCHAR2,
                                        p_row           IMPORT_TEXT_FILE%ROWTYPE);

PROCEDURE p_revalidate_file         (   p_file_id       NUMBER);

FUNCTION f_get_impdir_path              RETURN          VARCHAR2;



END;

/

/
