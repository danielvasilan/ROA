--------------------------------------------------------
--  DDL for Package PKG_APP_TOOLS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_APP_TOOLS" 
 AS
 /* Scop : salvarea de interogari specifice aplicatiilor */
-- patch 20061101


PROCEDURE p_recreate_table_environment              ;


PROCEDURE p_create_table                           (p_schema VARCHAR2, p_tbl_name VARCHAR2, p_column_list VARCHAR2, p_sec_cache INTEGER);

PROCEDURE p_load_app_table                          ;
PROCEDURE p_delete_non_existent_object              ;




PROCEDURE p_create_pkg_mod_col                      ;
PROCEDURE p_create_pkg_iud                          ;
PROCEDURE p_create_pkg_rtype                        ;
PROCEDURE p_create_pkg_get                          ;
PROCEDURE p_create_pkg_get2                         ;
PROCEDURE p_create_pkg_trg                          ;

PROCEDURE P_Log                             (   p_msg_type          VARCHAR2,
                                                p_msg_text          VARCHAR2,
                                                p_msg_context       VARCHAR2);

PROCEDURE p_reset_Mlog                      (   p_ref_app_log INTEGER);

PROCEDURE p_dbg_start                       (   p_parameter_list    VARCHAR2);

PROCEDURE p_dbg_stop                        (   p_flag_error    BOOLEAN     DEFAULT FALSE,
                                                p_err           VARCHAR2    DEFAULT NULL);

PROCEDURE p_set_flag_debug                  (   p_value         INTEGER);

PROCEDURE p_audit                           (   p_tbl_oper      VARCHAR2,
                                                p_tbl_name      VARCHAR2,
                                                p_tbl_line_id   NUMBER,
                                                p_tbl_idx1      VARCHAR2,
                                                p_tbl_idx2      VARCHAR2,
                                                p_note          VARCHAR2
                                            );

PROCEDURE p_trigger_iud                     (   p_schema        VARCHAR2, 
                                                p_table         VARCHAR2,
                                                p_flag_audit    INTEGER     DEFAULT 0, 
                                                p_audidx1       VARCHAR2    DEFAULT NULL,
                                                p_audidx2       VARCHAR2    DEFAULT NULL
                                            );

                                            
                                            
                                            
                                            
END;
 

/

/
