--------------------------------------------------------
--  DDL for Package Body PKG_SYS_TOOLS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_SYS_TOOLS" 
IS

PROCEDURE p_rebuild_indexes
IS
    CURSOR C_LINES IS
          SELECT    *
          FROM      USER_INDEXES
          WHERE     index_type IN ('NORMAL','BITMAP')
          AND       duration IS NULL
          ORDER BY  table_name ASC
          ;

    v_sql    VARCHAR2(32000);
BEGIN
    FOR x IN C_LINES LOOP
        v_sql := 'ALTER INDEX '|| x.index_name ||' REBUILD TABLESPACE INDX NOLOGGING COMPUTE STATISTICS';
        BEGIN
            EXECUTE IMMEDIATE v_sql;
       EXCEPTION
        WHEN OTHERS THEN
            NULL;
        END;
    END LOOP;
END;

------------------------------------------------------------------------------------------
PROCEDURE p_create_public_synonym (p_schema VARCHAR2)
IS
v_sql   VARCHAR2(32000);
BEGIN

FOR x IN (SELECT * FROM DBA_OBJECTS WHERE object_type IN ('FUNCTION','MATERIALIZED VIEW', 'PACKAGE','PROCEDURE','TABLE','VIEW') AND owner=p_schema)
LOOP
 v_sql := 'CREATE PUBLIC SYNONYM '||x.object_name ||' FOR '||p_schema||'.'||x.object_name;
 BEGIN
   EXECUTE IMMEDIATE v_sql;
 EXCEPTION WHEN OTHERS THEN NULL;
 END;
END LOOP;
END;

----------------------------------------------------------------------------------------------------
PROCEDURE p_free_mem
IS
BEGIN
  DBMS_SESSION.FREE_UNUSED_USER_MEMORY;
END;
-------------------------------------------------------------------
PROCEDURE p_kill_users
IS

CURSOR C IS SELECT *
       FROM   v$session
   WHERE  TYPE='USER'
       AND SID NOT IN (SELECT SID FROM v$mystat);
BEGIN
 FOR x IN c LOOP
  EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || x.SID||','|| x.serial#||'''';
 END LOOP;

END;
-----------------------------------------------------------------------------------------
PROCEDURE p_init_sess_time_model
IS
/*
SELECT SID,stat_id,stat_name,ROUND(SUM(value_actual)/1000000,3) - ROUND(SUM(value_referinta)/1000000,3) diferenta
FROM
(
SELECT SID,stat_id,stat_name, VALUE value_actual, 0 value_referinta FROM v$sess_time_model
UNION ALL
SELECT SID,stat_id,stat_name, 0 value_actual, value_referinta FROM vw_time_model
)
GROUP BY SID,stat_id,stat_name
HAVING ROUND(SUM(value_actual)/1000000,3) <> ROUND(SUM(value_referinta)/1000000,3)
    AND SID=150
ORDER BY diferenta DESC


SELECT SID,serial#,username,osuser,terminal,event,wait_class, program FROM v$session
WHERE
--wait_class NOT IN ( 'Idle')
--AND
SID=453

*/
BEGIN
-- DELETE FROM VW_TIME_MODEL;
-- INSERT INTO VW_TIME_MODEL
--SELECT * FROM v$sess_time_model;
NULL;
END;


-----------------------------------------------------------------------------------------------
PROCEDURE p_kill_library_lock
IS
CURSOR C IS SELECT * FROM v$session WHERE event IN ('library cache lock','library cache pin');
BEGIN

FOR x IN C LOOP
 BEGIN
    EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '''|| x.SID ||','|| x.serial# ||'''';
    EXCEPTION WHEN OTHERS THEN NULL;
 END;
END LOOP;
----------------------------------------------------------------------------------------------
END;

FUNCTION  f_sql_read_file (p_directory VARCHAR2, p_file_name VARCHAR2) RETURN typ_longinfo pipelined
IS
v_row           tmp_longinfo := tmp_longinfo();
v_buffer        VARCHAR2(32767);
f               UTL_FILE.FILE_TYPE;
v_exit          BOOLEAN;
v_line_count    INTEGER := 0;
BEGIN

IF p_directory IS NULL THEN Pkg_Lib.p_rae('Nu ati precizat obiectul de director unde este localizat fisierul !!!'); END IF;
IF p_file_name IS NULL THEN Pkg_Lib.p_rae('Nu ati precizat numele fisierului !!!'); END IF;

f:= UTL_FILE.FOPEN(p_directory, p_file_name, 'r',32767 );

v_exit := FALSE;

WHILE NOT v_exit LOOP
    BEGIN
        UTL_FILE.GET_LINE(f, v_buffer);

        v_line_count := v_line_count +1;

        v_row.numb01 := v_line_count;
        v_row.txt50  := SUBSTR(v_buffer,1,2000);

        pipe ROW(v_row);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_exit := TRUE;
    END;
END LOOP;
UTL_FILE.FCLOSE(f);
RETURN;
END;
----------------------------------------------------------------------------------------------------
PROCEDURE p_alter_constraint(p_type VARCHAR2, p_state VARCHAR2)
IS

CURSOR  C_CONSTRAINTS(p_type VARCHAR2) IS
                SELECT *
                FROM    USER_CONSTRAINTS
                WHERE       constraint_type     =   p_type
                ;

v_sql   VARCHAR2(32000);

BEGIN

DELETE FROM EXCEPTIONS ;
COMMIT;

FOR x IN C_CONSTRAINTS(p_type) LOOP

       v_sql    :=  'ALTER TABLE '|| x.table_name ||' ';
       v_sql    :=  v_sql   || 'MODIFY CONSTRAINT '|| x.constraint_name ||' ';
       v_sql    :=  v_sql   || p_state ||' ';

       IF p_state IN ('ENABLE') THEN
            v_sql    :=  v_sql   || 'EXCEPTIONS INTO EXCEPTIONS';
       END IF;

       BEGIN
            EXECUTE IMMEDIATE v_sql;
       EXCEPTION
            WHEN OTHERS THEN
                NULL;
       END;
END LOOP;
END;
-------------------------------------------------------------------------------------------------
PROCEDURE p_upload_metadata_to_filty
IS

    v_db_link   VARCHAR2(32000)     :=  'FILTY';

BEGIN


    
    BEGIN 
    
        EXECUTE IMMEDIATE 'DROP TRIGGER TRG_APP_EXCEPTIONS@'|| v_db_link;
        EXECUTE IMMEDIATE 'DROP TRIGGER TRG_REPORTS_PARAMETER@'|| v_db_link;
        EXECUTE IMMEDIATE 'DROP TRIGGER TRG_REPORTS@'|| v_db_link;
        EXECUTE IMMEDIATE 'DROP TRIGGER TRG_REPORTS_CATEGORY@'|| v_db_link;
        EXECUTE IMMEDIATE 'DROP TRIGGER TRG_TASKS@'|| v_db_link;
        EXECUTE IMMEDIATE 'DROP TRIGGER TRG_APP_TABLE@'|| v_db_link;
        EXECUTE IMMEDIATE 'DROP TRIGGER TRG_MULTI_TABLE@'|| v_db_link;

        EXCEPTION 
                WHEN OTHERS THEN NULL;  
    
    END;     
        
    
    EXECUTE IMMEDIATE 'DELETE FROM APP_EXCEPTIONS@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO APP_EXCEPTIONS@'|| v_db_link||' SELECT * FROM APP_EXCEPTIONS';


--    EXECUTE IMMEDIATE 'DELETE FROM APP_SECURITEM@'|| v_db_link;
--    EXECUTE IMMEDIATE 'INSERT INTO APP_SECURITEM@'|| v_db_link||' SELECT * FROM APP_SECURITEM';

    EXECUTE IMMEDIATE 'DELETE FROM REPORTS_PARAMETER@'|| v_db_link;
    EXECUTE IMMEDIATE 'DELETE FROM REPORTS@'|| v_db_link;
    EXECUTE IMMEDIATE 'DELETE FROM REPORTS_CATEGORY@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO REPORTS_CATEGORY@'|| v_db_link||' SELECT * FROM REPORTS_CATEGORY';
    EXECUTE IMMEDIATE 'INSERT INTO REPORTS@'|| v_db_link||' SELECT * FROM REPORTS';
    EXECUTE IMMEDIATE 'INSERT INTO REPORTS_PARAMETER@'|| v_db_link||' SELECT * FROM REPORTS_PARAMETER';

    EXECUTE IMMEDIATE 'DELETE FROM TASKS@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO TASKS@'|| v_db_link||' SELECT * FROM TASKS';

    EXECUTE IMMEDIATE 'DELETE FROM APP_TABLE@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO APP_TABLE@'|| v_db_link||' SELECT * FROM APP_TABLE';

    EXECUTE IMMEDIATE 'DELETE FROM WIZ_HEADER@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO WIZ_HEADER@'|| v_db_link||' SELECT * FROM WIZ_HEADER';

    EXECUTE IMMEDIATE 'DELETE FROM WIZ_CONTROL@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO WIZ_CONTROL@'|| v_db_link||' SELECT * FROM WIZ_CONTROL';

    EXECUTE IMMEDIATE 'DELETE FROM WIZ_STEP@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO WIZ_STEP@'|| v_db_link||' SELECT * FROM WIZ_STEP';
    
    EXECUTE IMMEDIATE 'DELETE FROM APP_TASK@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO APP_TASK@'|| v_db_link||' SELECT * FROM APP_TASK';

    EXECUTE IMMEDIATE 'DELETE FROM APP_TASK_PARAM@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO APP_TASK_PARAM@'|| v_db_link||' SELECT * FROM APP_TASK_PARAM';

    EXECUTE IMMEDIATE 'DELETE FROM APP_TASK_STEP@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO APP_TASK_STEP@'|| v_db_link||' SELECT * FROM APP_TASK_STEP';
    
 --   EXECUTE IMMEDIATE 'DELETE FROM MULTI_TABLE@'|| v_db_link;
 --   EXECUTE IMMEDIATE 'INSERT INTO MULTI_TABLE@'|| v_db_link||' SELECT * FROM MULTI_TABLE';

    COMMIT;
END;
------------------------------------------------------------------------------------------------------------------
PROCEDURE p_upload_activity_report
IS

    v_db_link   VARCHAR2(32000)     :=  'ECLIPSA';

BEGIN

    EXECUTE IMMEDIATE 'DELETE FROM APP_ACTIVITY_REPORT@'|| v_db_link;
    EXECUTE IMMEDIATE 'INSERT INTO APP_ACTIVITY_REPORT@'|| v_db_link||' SELECT * FROM APP_ACTIVITY_REPORT';


    COMMIT;

END;
---------------------------------------------------------------------------------------------------
FUNCTION f_sql_sys_user_views RETURN typ_clob pipelined
IS
--------------------------------------------------------------------------------------------
-- SQL function that gives all the user views in txt01 and the definition
-- string in clob01
-- in this way can be done operations on the clob01 column
-- otherwise it is not posibble to manipulate in USER_VIEWS the column text because it is long
--------------------------------------------------------------------------------------------

 CURSOR  C_LINES IS  SELECT  view_name,text
      FROM  VW_SYS_USER_VIEWS_AUX
      ;
 v_row      tmp_clob := tmp_clob();

 --/*
 PROCEDURE p
 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
  DELETE FROM VW_SYS_USER_VIEWS_AUX;

  INSERT INTO VW_SYS_USER_VIEWS_AUX(view_name,text, segment_code)
  SELECT   view_name, TO_LOB(text), 'VW_SYS_USER_VIEWS_AUX'
  FROM   USER_VIEWS;

  COMMIT;
 END;
 --*/
BEGIN
 p();
 FOR x IN C_LINES LOOP
   v_row.txt01  := x.view_name;
   v_row.clob01 := x.text;
   pipe ROW(v_row);
 END LOOP;

 RETURN;
END;
---------------------------------------------------------------------------------------------------
FUNCTION f_sql_user_source RETURN typ_longinfo pipelined
IS
        CURSOR  C_LINES IS
                SELECT  *
                FROM    USER_SOURCE
                ORDER BY TYPE, NAME,LINE
      ;
    v_row       tmp_longinfo := tmp_longinfo();
    v_tmp       VARCHAR2(32000);
    v_type      VARCHAR2(32000);
    v_name      VARCHAR2(32000);
    v_lenght    NUMBER;
    v_start     NUMBER;
    v_name2     VARCHAR2(32000);
BEGIN
    FOR x IN C_LINES LOOP
        v_tmp   := trim(UPPER(x.text));
        v_type   := NULL;
        IF x.TYPE IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY') THEN
            IF Pkg_Lib.f_mod_c(v_name2,x.NAME) THEN
                v_name := NULL;
            END IF;
            v_name2  := x.NAME;
            CASE
                WHEN  v_tmp LIKE 'PROCEDURE%'  THEN v_type := 'PROCEDURE';
                WHEN  v_tmp LIKE 'FUNCTION%'  THEN v_type := 'FUNCTION';
                ELSE       NULL;
            END CASE;
            IF v_type IS NOT NULL THEN
                v_lenght    :=  LENGTH(v_type);
                v_start     :=  INSTR(v_tmp, v_type) + v_lenght;
                v_name      :=  SUBSTR(v_tmp, v_start);
                v_name      :=  trim(v_name);
                v_name      :=  REPLACE(v_name,'"',NULL);
                --v_name    :=  REPLACE(v_name,' ',NULL);
                v_lenght    :=  INSTR(v_name,'(');
                IF v_lenght = 0 THEN
                    v_name  := v_name ||' ';
                    v_lenght := INSTR(v_name,' ');
                    v_lenght := v_lenght - 1;
                    v_name  := SUBSTR(v_name,1,v_lenght);
                    v_name  := trim(v_name);
                ELSE
                    v_lenght := v_lenght - 1;
                    v_name  := SUBSTR(v_name,1,v_lenght);
                    v_name  := trim(v_name);
                END IF;
            END IF;
        ELSE
            v_name :=  NULL;
        END IF;
        ---
        v_name   :=  LOWER(v_name);
        v_name   := REPLACE(v_name,CHR(10),NULL);
        v_name   := REPLACE(v_name,CHR(13),NULL);
        v_name   := REPLACE(v_name,CHR(9) ,NULL);
        --
        v_row.txt01  := x.TYPE;
        v_row.txt02  := x.NAME;
        v_row.txt03  := v_name;
        v_row.txt04  := x.text;
        v_row.numb01 := x.LINE;
        --
        pipe ROW(v_row);
    END LOOP;
END;
-----------------------------------------------------------------------------------
PROCEDURE   p_read_constraint_definition
IS

    CURSOR  C_CONSTRAINT    IS
            SELECT  *
            FROM    USER_CONSTRAINTS
            WHERE   constraint_name NOT LIKE 'SYS%'
            ORDER   BY constraint_type, table_name, constraint_name
            ;

    CURSOR  C_CONS_COLUMNS IS
            SELECT  *
            FROM    USER_CONS_COLUMNS
            ORDER BY constraint_name, position
            ;

    TYPE type_it    IS TABLE OF USER_CONS_COLUMNS%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE type_it2   IS TABLE OF type_it INDEX BY VARCHAR2(200);

    it              type_it2;
    v_row           VW_SYS_CONSTRAINT_DEF%ROWTYPE;

BEGIN

    FOR x IN C_CONS_COLUMNS LOOP
        IF it.EXISTS(x.constraint_name) THEN
            it(x.constraint_name)(it(x.constraint_name).COUNT+1)    :=  x;
        ELSE
            it(x.constraint_name)(1)    :=  x;
        END IF;


    END LOOP;

    DELETE FROM VW_SYS_CONSTRAINT_DEF;

    FOR x IN C_CONSTRAINT LOOP

        v_row.constraint_name           :=  x.CONSTRAINT_NAME ;
        v_row.constraint_type           :=  x.CONSTRAINT_TYPE ;
        v_row.constraint_table          :=  x.TABLE_NAME ;
        v_row.search_condition          :=  x.SEARCH_CONDITION ;

        v_row.constraint_column         :=  NULL;

        IF it.EXISTS(x.constraint_name) THEN
            FOR i IN 1..it(x.constraint_name).COUNT LOOP
                v_row.constraint_column := v_row.constraint_column
                                            ||it(x.constraint_name)(i).column_name
                                            ||',';
            END LOOP;
        END IF;
        v_row.constraint_column := RTRIM(v_row.constraint_column,',');

        v_row.ref_column                :=  NULL;
        IF it.EXISTS(x.r_constraint_name) THEN
            FOR i IN 1..it(x.r_constraint_name).COUNT LOOP
                v_row.ref_column := v_row.ref_column
                                            ||it(x.r_constraint_name)(i).column_name
                                            ||',';
            END LOOP;
            v_row.ref_table    := it(x.r_constraint_name)(1).table_name;
        END IF;
        v_row.ref_column  := RTRIM(v_row.ref_column,',');

        v_row.segment_code  :=  'VW_SYS_CONSTRAINT_DEF';

        INSERT INTO VW_SYS_CONSTRAINT_DEF
        VALUES  v_row;

    END LOOP;


    COMMIT;
END;
--------------------------------------------------------------------------------------
PROCEDURE p_read_index_definition
IS

    CURSOR  C_INDEX    IS
            SELECT  *
            FROM    USER_INDEXES
            WHERE   INDEX_TYPE = 'NORMAL'
            ORDER   BY table_name
            ;

    CURSOR  C_IND_COLUMNS IS
            SELECT  *
            FROM    USER_IND_COLUMNS
            ORDER BY index_name, column_position
            ;

    TYPE type_it    IS TABLE OF USER_IND_COLUMNS%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE type_it2   IS TABLE OF type_it INDEX BY VARCHAR2(200);

    it              type_it2;
    v_row           VW_SYS_INDEX_DEF%ROWTYPE;


BEGIN

    DELETE FROM VW_SYS_INDEX_DEF;

    FOR x IN C_IND_COLUMNS LOOP
        IF it.EXISTS(x.index_name) THEN
            it(x.index_name)(it(x.index_name).COUNT+1)    :=  x;
        ELSE
            it(x.index_name)(1)    :=  x;
        END IF;
    END LOOP;


    FOR x IN C_INDEX  LOOP

        v_row.table_name           :=  x.table_NAME ;
        v_row.index_name           :=  x.index_name ;
        v_row.uniqueness          :=  x.uniqueness ;

        v_row.index_column         :=  NULL;

        IF it.EXISTS(x.index_name) THEN
            FOR i IN 1..it(x.index_name).COUNT LOOP
                v_row.index_column := v_row.index_column
                                            ||it(x.index_name)(i).column_name
                                            ||',';
            END LOOP;
        END IF;
        v_row.index_column := RTRIM(v_row.index_column,',');

        v_row.segment_code  :=  'VW_SYS_INDEX_DEF';

        INSERT INTO VW_SYS_INDEX_DEF
        VALUES  v_row;

    END LOOP;
END;
--------------------------------------------------------------------------------------------------------------
PROCEDURE   p_create_ref_constraint
IS

    CURSOR  C_LINES IS
            SELECT      c1.constraint_name,
                        c1.table_name constraint_table, a1.tbl_name_user constraint_user_name,
                        c2.table_name ref_table, a2.tbl_name_user   ref_user_name
            FROM        USER_CONSTRAINTS    c1
            INNER JOIN  USER_CONSTRAINTS    c2
                            ON c2.constraint_name   =   c1.r_constraint_name
            LEFT JOIN   APP_TABLE           a1
                            ON  a1.tbl_name  =  c1.table_name
            LEFT JOIN   APP_TABLE           a2
                            ON  a2.tbl_name  =  c2.table_name
            WHERE       c1.constraint_type  =   'R'
            ORDER BY    c1.table_name
            ;

    v_row       APP_EXCEPTIONS%ROWTYPE;

BEGIN

    DELETE FROM APP_EXCEPTIONS WHERE SQLCODE IN (-2292,-2291);

    FOR x IN C_LINES LOOP
        v_row.SQLCODE           :=  -2291;
        v_row.num_excep         :=  x.constraint_name;
        v_row.num_tabel         :=  x.constraint_table;
        v_row.num_col           :=  NULL;
        v_row.err_msg           := 'Nu puteti insera/modifica inregistrarea in tabela '
                                    ||NVL(x.constraint_user_name,x.constraint_table)
                                    ||' deoarece nu exista aceste informatii '
                                    ||' introduse in tabela '
                                    ||NVL(x.ref_user_name,x.ref_table)
                                    ||' !!!'
                                    ;

        INSERT INTO APP_EXCEPTIONS VALUES v_row;

        v_row.SQLCODE           :=  -2292;
        v_row.num_excep         :=  x.constraint_name;
        v_row.num_tabel         :=  x.constraint_table;
        v_row.num_col           :=  NULL;
        v_row.err_msg           := 'Nu puteti sterge/modifica inregistrarea in tabela '
                                    ||NVL(x.ref_user_name,x.ref_table)
                                    ||' deoarece exista inregistrari in tabela '
                                    ||NVL(x.constraint_user_name,x.constraint_table)
                                    ||' care refera acestea !!!'
                                    ;

        INSERT INTO APP_EXCEPTIONS VALUES v_row;


    END LOOP;

    COMMIT;

END;






END;

/

/
