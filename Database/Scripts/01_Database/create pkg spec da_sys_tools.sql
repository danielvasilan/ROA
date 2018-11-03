CREATE OR REPLACE PACKAGE "PKG_SYS_TOOLS" AS

PROCEDURE p_export_stop         (p_job_name VARCHAR2);


PROCEDURE p_export_dmp_schemas  (   p_schemas   VARCHAR2,
                                    p_dmp_dir   VARCHAR2 DEFAULT 'DATA_PUMP_DIR');
                                    
PROCEDURE p_import_dmp_schemas  (   p_schemas   VARCHAR2,
                                    p_dir       VARCHAR2 DEFAULT 'DATA_PUMP_DIR',
                                    p_only_meta BOOLEAN  DEFAULT FALSE,
                                    p_remap_sch VARCHAR2 DEFAULT '');

PROCEDURE p_export_engine      (p_data_pump_dir VARCHAR2 );

END;
/
