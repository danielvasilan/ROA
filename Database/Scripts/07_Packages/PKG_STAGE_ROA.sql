--------------------------------------------------------
--  DDL for Package PKG_STAGE_ROA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_STAGE_ROA" 
AS
    
    PROCEDURE p_process_rec_ALT   ( p_row_file STG_FILE_MANAGER%ROWTYPE);
    PROCEDURE p_process_bom_alt   ( p_row_file STG_FILE_MANAGER%ROWTYPE);
    PROCEDURE p_process_ship_fifo ( p_row_file STG_FILE_MANAGER%ROWTYPE);
    PROCEDURE p_process_wo_decl   ( p_row_file STG_FILE_MANAGER%ROWTYPE);
    procedure p_process_rec_pkl   ( p_row_file STG_FILE_MANAGER%ROWTYPE);

    PROCEDURE p_validate_ship_fifo( p_file_id NUMBER);
    PROCEDURE p_validate_wo_decl  ( p_file_id NUMBER);

    PROCEDURE p_load_ship_fifo    ( p_file_id NUMBER);
    PROCEDURE p_load_wo_decl      ( p_file_id NUMBER);

    PROCEDURE p_create_material_for_fifo (p_stg_file_id number);
    
    FUNCTION f_get_rm_operation_for_phase (rm_phase varchar2) RETURN VARCHAR2;

END;

/

/
