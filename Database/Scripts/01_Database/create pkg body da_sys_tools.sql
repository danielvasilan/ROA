CREATE OR REPLACE PACKAGE BODY "PKG_SYS_TOOLS" AS




-------------------------------------------------------------------------------------------------

PROCEDURE p_export_stop(p_job_name VARCHAR2)
IS
    h   NUMBER;
BEGIN
    h := Dbms_Datapump.attach(p_job_name,'DA');
    Dbms_Datapump.stop_job(h,1,0);
    Dbms_Datapump.detach(h);
END;
----------------------------------------------------------------------------------------------
PROCEDURE p_export_dmp_schemas  (   p_schemas   VARCHAR2,
                                    p_dmp_dir   VARCHAR2 DEFAULT 'DATA_PUMP_DIR')
IS
    v_date          VARCHAR2(100);
    h               NUMBER;
BEGIN

    IF p_schemas IS NULL            THEN RAISE_APPLICATION_ERROR(-20000,'Nu ati precizat schemele de exportat !!!'); END IF;
    IF p_dmp_dir IS NULL      THEN RAISE_APPLICATION_ERROR(-20000,'Nu ati precizat obictul director pentru export !!!'); END IF;


    h := Dbms_Datapump.OPEN( 'EXPORT', 'SCHEMA',
                            job_name  => 'EXPORT_SCHEMAS4',
                            VERSION   => 'LATEST'
        );

    Dbms_Datapump.ADD_FILE(h,'SCHEMAS%U.DMP'    ,p_dmp_dir, '1500M');
    Dbms_Datapump.ADD_FILE(h,'EXPORT.LOG'       ,p_dmp_dir, NULL, Dbms_Datapump.KU$_FILE_TYPE_LOG_FILE);
    Dbms_Datapump.SET_PARALLEL(h,1);
    v_date := 'TO_TIMESTAMP('''||TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SS')||''', ''DD-MM-YYYY HH24:MI:SS'')';
    --DBMS_DATAPUMP.SET_PARAMETER(h,'FLASHBACK_TIME',v_date);
    Dbms_Datapump.METADATA_FILTER(h,'SCHEMA_LIST',p_schemas);

    Dbms_Datapump.START_JOB(h);
    Dbms_Datapump.DETACH(h);

END;

------------------------------------------------------------------------------------------------
PROCEDURE p_import_dmp_schemas 
                (   p_schemas   VARCHAR2,
                    p_dir       VARCHAR2 DEFAULT 'DATA_PUMP_DIR',
                    p_only_meta BOOLEAN  DEFAULT FALSE,
                    p_remap_sch VARCHAR2 DEFAULT '')
IS
    h               NUMBER;
BEGIN

    IF p_schemas IS NULL  THEN 
        RAISE_APPLICATION_ERROR(-20000,'Nu ati precizat schemele de importat !!!'); 
    END IF;
    IF p_dir IS NULL THEN 
        RAISE_APPLICATION_ERROR(-20000,'Nu ati precizat obiectul director pentru import !!!'); 
    END IF;

    h := Dbms_Datapump.OPEN( 'IMPORT', 'SCHEMA',
                            job_name  => 'IMPORT_SCHEMAS5',
                            VERSION   => 'LATEST');

    Dbms_Datapump.ADD_FILE( h, 'SCHEMAS%U.DMP'    ,p_dir);
    Dbms_Datapump.ADD_FILE( h, 'IMPORT.LOG'       ,p_dir, NULL, 
                            Dbms_Datapump.KU$_FILE_TYPE_LOG_FILE);
    Dbms_Datapump.SET_PARALLEL(h, 1);
    Dbms_Datapump.METADATA_FILTER(h, 'SCHEMA_LIST', p_schemas);
    IF p_only_meta THEN
        Dbms_Datapump.DATA_FILTER(h,'INCLUDE_ROWS', 0);
    END IF;
    IF p_remap_sch IS NOT NULL THEN
        DBMS_DATAPUMP.METADATA_REMAP(   h,
                                        'REMAP_SCHEMA', 
                                        replace(p_schemas, '''',''), 
                                        p_remap_sch);
        DBMS_DATAPUMP.METADATA_TRANSFORM    (h,'OID',0);
    END IF;
    
    Dbms_Datapump.START_JOB(h);
    Dbms_Datapump.DETACH(h);

END;


-----------------------------------------------------------------------------------------------
/************************************************************************************************
-- created 07.08.2007
*************************************************************************************************/
PROCEDURE p_export_engine(p_data_pump_dir VARCHAR2 )
-----------------------------------------------------------------------------------------------
-- make a full database export with datapump in the directory designed with p_data_pump_dir
-- first tries to delete the previous datapump files
-- launch the datapump job for ful export
-- the job should be launched as owner DA
-----------------------------------------------------------------------------------------------
IS


 CURSOR  C_CHECK_JOB(p_job_schema VARCHAR2,p_job_name VARCHAR2 ) IS 
                 SELECT *
                 FROM   DBA_DATAPUMP_JOBS
                 WHERE       owner_name  =   p_job_schema
                         AND job_name    =   p_job_name
     ;   

 v_count            INTEGER := 0;
 v_file_name        VARCHAR2(100);
 v_exception        BOOLEAN := FALSE;
 v_job_name         VARCHAR2(30);
 v_date             VARCHAR2(100);
 v_found            BOOLEAN;
 h                  NUMBER;
 C_ROOT_FILE_NAME   CONSTANT VARCHAR2(32000) := 'SCHEMAS';
 C_JOB_NAME         CONSTANT VARCHAR2(32000) := 'EXPORT_ENGINE';
 C_JOB_SCHEMA       CONSTANT VARCHAR2(32000) := 'DA';
 
 v_row_tst          C_CHECK_JOB%ROWTYPE;

BEGIN
   
    -- sterg fisierele din locatia respectiva
    
    WHILE NOT v_exception LOOP
        v_count  := v_count +1;     
        v_file_name := C_ROOT_FILE_NAME || LPAD(v_count,2,'0')||'.DMP';
        
        BEGIN
            UTL_FILE.fremove(p_data_pump_dir, v_file_name);    
         EXCEPTION
             WHEN OTHERS THEN
                 v_exception := TRUE;
        END;
    END LOOP;
    
    v_job_name := C_JOB_NAME;
     
    -- verific daca jobul nu exista deja, daca exista sterg !!!!!!!!
    OPEN    C_CHECK_JOB(C_JOB_SCHEMA, v_job_name);
    FETCH   C_CHECK_JOB INTO v_row_tst;
    v_found  := C_CHECK_JOB%FOUND;
    CLOSE C_CHECK_JOB;
    
    IF  v_found THEN
         IF v_row_tst.state = 'NOT RUNNING' THEN
            EXECUTE IMMEDIATE 'DROP TABLE '||C_JOB_SCHEMA||'.'||v_job_name||' PURGE';
         ELSE   
            h := DBMS_DATAPUMP.ATTACH(v_job_name,C_JOB_SCHEMA);
            DBMS_DATAPUMP.STOP_JOB (h,1,0);
            DBMS_DATAPUMP.DETACH(h);
         END IF;   
    END IF;
    
    -- creez noul job de export
    
    h := DBMS_DATAPUMP.OPEN( 'EXPORT', 'FULL',
                                job_name  => v_job_name,
                                VERSION   => 'LATEST'
    );
    
    DBMS_DATAPUMP.ADD_FILE(h,C_ROOT_FILE_NAME||'%U.DMP'    ,p_data_pump_dir,'1500M');
    DBMS_DATAPUMP.ADD_FILE(h,'EXPORT.LOG'       ,p_data_pump_dir,NULL,DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE);
    DBMS_DATAPUMP.SET_PARALLEL(h,1);
    v_date := 'TO_TIMESTAMP('''||TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SS')||''', ''DD-MM-YYYY HH24:MI:SS'')';
    DBMS_DATAPUMP.SET_PARAMETER(h,'FLASHBACK_TIME',v_date);
    DBMS_DATAPUMP.START_JOB(h);
    DBMS_DATAPUMP.DETACH(h);
    
     EXCEPTION 
         WHEN OTHERS THEN DBMS_DATAPUMP.DETACH(h);
END;




END Pkg_Sys_Tools;
/
