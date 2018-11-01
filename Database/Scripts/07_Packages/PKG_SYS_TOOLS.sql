--------------------------------------------------------
--  DDL for Package PKG_SYS_TOOLS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_SYS_TOOLS" 
IS


/* reconstruieste toate indexurile din schema ZIRDB */
PROCEDURE p_rebuild_indexes;
PROCEDURE p_create_public_synonym               (p_schema VARCHAR2);
PROCEDURE p_free_mem;
PROCEDURE p_kill_users;
PROCEDURE p_init_sess_time_model;
PROCEDURE p_kill_library_lock;
FUNCTION  f_sql_read_file                       (p_directory VARCHAR2, p_file_name VARCHAR2) RETURN typ_longinfo pipelined;
PROCEDURE p_alter_constraint                    (p_type VARCHAR2, p_state VARCHAR2);
FUNCTION  f_sql_sys_user_views                   RETURN typ_clob pipelined;
FUNCTION  f_sql_user_source                      RETURN typ_longinfo pipelined;

PROCEDURE   p_read_constraint_definition        ;
PROCEDURE   p_read_index_definition             ;
PROCEDURE   p_create_ref_constraint             ;


PROCEDURE p_upload_metadata_to_filty            ;
PROCEDURE p_upload_activity_report              ;


END;
 

/

/
