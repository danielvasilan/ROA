--------------------------------------------------------
--  DDL for Package Body PKG_APP_TOOLS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_APP_TOOLS" 
AS
-- patch 20061101

/*
declare
v_sql  varchar2(32000);
begin

v_sql := '


';

pkg_app_tools.p_create_table(
          '', -- schema
         '', -- table name
         v_sql, -- column list
         NULL -- cace secventa
       );

end;

*/

PROCEDURE p_create_table (p_schema VARCHAR2, p_tbl_name VARCHAR2, p_column_list VARCHAR2, p_sec_cache INTEGER)
IS

v_sql  VARCHAR2(32000);


BEGIN

IF p_schema      IS NULL THEN RAISE_APPLICATION_ERROR(-20001,'<<Nu ati precizat numele schemei !!!>>'); END IF;
IF p_tbl_name    IS NULL THEN RAISE_APPLICATION_ERROR(-20001,'<<Nu ati precizat numele tabelei !!!>>'); END IF;
IF p_column_list IS NULL THEN RAISE_APPLICATION_ERROR(-20001,'<<Nu ati precizat lista de coloane !!!>>'); END IF;
IF p_sec_cache   IS NULL THEN RAISE_APPLICATION_ERROR(-20001,'<<Nu ati precizat cat sa chasuiasca secventa !!!>>'); END IF;


v_sql   := 'CREATE TABLE '|| p_schema ||'.'|| p_tbl_name;
v_sql   := v_sql ||' (';
v_sql   := v_sql ||'   DATAGG DATE, WORKST VARCHAR2(30 BYTE),OSUSER VARCHAR2(30 BYTE), NUSER VARCHAR2(30 BYTE), IDUSER VARCHAR2(10),DCN NUMBER(10) DEFAULT 0,IDRIGA NUMBER(10), ';
v_sql   := v_sql || RTRIM(p_column_list,',');
v_sql   := v_sql ||' )';
v_sql   := v_sql ||' TABLESPACE USERS';

EXECUTE IMMEDIATE v_sql;

-- creez secventa

v_sql   := 'CREATE SEQUENCE '|| p_schema ||'.'||'SC_'|| p_tbl_name;
v_sql   :=  v_sql || ' START WITH  1';
v_sql   :=  v_sql || ' MINVALUE    1';
v_sql   :=  v_sql || ' NOCYCLE ';
IF p_sec_cache > 0 THEN
   v_sql   :=  v_sql || ' CACHE ' || p_sec_cache;
ELSE
   v_sql   :=  v_sql || ' NOCACHE ' ;
END IF;

EXECUTE IMMEDIATE  v_sql;

-- creez cheie primara

v_sql  := 'CREATE INDEX   '|| p_schema ||'.'||'IN_'|| p_tbl_name||'_PK';
v_sql  := v_sql || ' ON '|| p_schema ||'.'|| p_tbl_name ;
v_sql  := v_sql || ' (IDRIGA) ';
v_sql  := v_sql || ' TABLESPACE INDX ';

EXECUTE IMMEDIATE  v_sql;

-- constrangerea cheie primara

v_sql  := 'ALTER TABLE '|| p_schema ||'.'|| p_tbl_name;
v_sql  := v_sql || ' ADD (  CONSTRAINT ' ||p_tbl_name|| '_PK';
v_sql  := v_sql || ' PRIMARY KEY (IDRIGA))';

EXECUTE IMMEDIATE  v_sql;



END;

----------------------------------------------------------------------------------------
PROCEDURE p_create_pkg_mod_col
IS

    CURSOR  C_LINES IS
        SELECT  i.table_name,i.column_name, i.data_type,i.column_id
        FROM    USER_TAB_COLS   i,
                APP_TABLE       t
        WHERE       i.table_name     =  t.tbl_name
                AND t.flag_mod_col   =  'Y'
                AND i.virtual_column =  'NO'
                AND i.data_type      IN ('DATE','VARCHAR','VARCHAR2','NUMBER')
                AND i.column_name    NOT IN ('IDRIGA','DCN','DATAGG')
        ;

    TYPE type_it    IS TABLE OF  Pkg_Glb.typ_general_varchar INDEX BY Pkg_Glb.type_index;
    it              type_it;
    v_mod_fnc       VARCHAR2(32000);
    v_table         Pkg_Glb.type_index;
    v_column        Pkg_Glb.type_index;

    v_cursor_name           INTEGER;
    v_ret                   INTEGER;
    it_sql                  DBMS_SQL.VARCHAR2A;
    it_sql2                 DBMS_SQL.VARCHAR2A;


BEGIN

    Pkg_App_Tools.p_delete_non_existent_object();

    FOR x IN C_LINES LOOP
        CASE x.data_type
            WHEN    'DATE'      THEN    v_mod_fnc   :=  'PKG_LIB.f_mod_d';
            WHEN    'VARCHAR2'  THEN    v_mod_fnc   :=  'PKG_LIB.f_mod_c';
            WHEN    'VARCHAR'   THEN    v_mod_fnc   :=  'PKG_LIB.f_mod_c';
            WHEN    'NUMBER'    THEN    v_mod_fnc   :=  'PKG_LIB.f_mod_n';
        END CASE;

        it(x.table_name)(x.column_name).txt01  :=  v_mod_fnc;
    END LOOP;

    --
    v_cursor_name := DBMS_SQL.OPEN_CURSOR;
    --
    it_sql(it_sql.COUNT+1) :='CREATE OR REPLACE PACKAGE BODY PKG_MOD_COL '||Pkg_Glb.C_LF ;
    it_sql(it_sql.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --
    it_sql2(it_sql2.COUNT+1) :='CREATE OR REPLACE PACKAGE PKG_MOD_COL '||Pkg_Glb.C_LF  ;
    it_sql2(it_sql2.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --
    v_table     :=  it.FIRST;
    WHILE v_table IS NOT NULL LOOP

        it_sql2(it_sql2.COUNT+1) :=RPAD('FUNCTION f_'||LOWER(v_table),50 )||'(p_row_old '||v_table||'%ROWTYPE, p_row_new '||v_table||'%ROWTYPE) RETURN VARCHAR2;'||Pkg_Glb.C_LF;
        --
        it_sql(it_sql.COUNT+1) :='--------------------------------------------------------------------'||Pkg_Glb.C_LF;
        it_sql(it_sql.COUNT+1) :='FUNCTION f_'||LOWER(v_table)||'(p_row_old '||v_table||'%ROWTYPE, p_row_new '||v_table||'%ROWTYPE)'||Pkg_Glb.C_LF;
        it_sql(it_sql.COUNT+1) :='RETURN VARCHAR2 '||Pkg_Glb.C_LF;
        it_sql(it_sql.COUNT+1) :='IS'||Pkg_Glb.C_LF;
        it_sql(it_sql.COUNT+1) :='  v_result    VARCHAR2(32000);'||Pkg_Glb.C_LF;
        it_sql(it_sql.COUNT+1) :='BEGIN'||Pkg_Glb.C_LF;

        v_column    :=  it(v_table).FIRST;
        WHILE v_column IS NOT NULL LOOP
            it_sql(it_sql.COUNT+1) :='  IF '||it(v_table)(v_column).txt01||'(p_row_old.'||v_column||',p_row_new.'||v_column||') THEN '||Pkg_Glb.C_LF;
            it_sql(it_sql.COUNT+1) :='      v_result    :=  v_result||'''||v_column||'''||'','';'||Pkg_Glb.C_LF;
            it_sql(it_sql.COUNT+1) :='  END IF;'||Pkg_Glb.C_LF;

            v_column    :=  it(v_table).NEXT(v_column);
        END LOOP;
        it_sql(it_sql.COUNT+1) :='      RETURN v_result ;'||Pkg_Glb.C_LF;
        it_sql(it_sql.COUNT+1) :='END;'||Pkg_Glb.C_LF;
        v_table :=  it.NEXT(v_table);
    END LOOP;
    --
    it_sql(it_sql.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    --
    it_sql2(it_sql2.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    -- create specification
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_sql2,
                    lb              =>  1,
                    ub              =>  it_sql2.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);
    -- create body
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_sql,
                    lb              =>  1,
                    ub              =>  it_sql.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);
    DBMS_SQL.CLOSE_CURSOR(v_cursor_name);
END;
----------------------------------------------------------------------------------------
PROCEDURE p_create_pkg_iud
IS

    CURSOR C_LINES   IS
                    SELECT  tbl_name    table_name, m.*
                    FROM    APP_TABLE m
                    WHERE       flag_iud            <> 'N'
                            AND LENGTH(tbl_name)    <= 20
                    ORDER BY table_name
                    ;

    v_cursor_name           INTEGER;
    v_ret                   INTEGER;
    it_body                 DBMS_SQL.VARCHAR2A;
    it_spec                 DBMS_SQL.VARCHAR2A;

    C_PACKAGE_NAME          VARCHAR2(32000)      :=  'PKG_IUD';

BEGIN

    Pkg_App_Tools.p_delete_non_existent_object();

    it_spec(it_spec.COUNT+1) :='CREATE OR REPLACE PACKAGE '|| C_PACKAGE_NAME||Pkg_Glb.C_LF  ;
    it_spec(it_spec.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --
    it_body(it_body.COUNT+1) :='CREATE OR REPLACE PACKAGE BODY '|| C_PACKAGE_NAME||Pkg_Glb.C_LF ;
    it_body(it_body.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --


    FOR x IN C_LINES
    LOOP

        CASE x.flag_iud
            WHEN 'A' THEN
                it_spec(it_spec.COUNT+1) :=RPAD('PROCEDURE p_'||LOWER(x.table_name)||'_iud',50 )||'(p_tip   VARCHAR2, p_row IN '||x.table_name||'%ROWTYPE,p_set_line_id BOOLEAN default TRUE);'||Pkg_Glb.C_LF;

                it_body(it_body.COUNT+1) :='PROCEDURE p_'||LOWER(x.table_name)||'_iud(p_tip   VARCHAR2, p_row IN '||x.table_name||'%ROWTYPE,p_set_line_id BOOLEAN default TRUE)'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='IS'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='BEGIN '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    CASE p_tip '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''U'' THEN'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            UPDATE '||x.table_name||' SET ROW = p_row  WHERE '||x.tbl_idriga||' = p_row.'||x.tbl_idriga||';'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''I'' THEN'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            IF p_set_line_id THEN'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='                INSERT INTO '||x.table_name||' VALUES p_row RETURNING '||x.tbl_idriga||' INTO Pkg_Glb.v_idriga;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            ELSE '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='                INSERT INTO '||x.table_name||' VALUES p_row ;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            END IF; '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''D'' THEN '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            DELETE FROM '||x.table_name||' WHERE '||x.tbl_idriga||' = p_row.'||x.tbl_idriga||'; '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    END CASE;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='END;'||Pkg_Glb.C_LF;

                it_spec(it_spec.COUNT+1) :=RPAD('PROCEDURE p_'||LOWER(x.table_name)||'_miud',50 )||'(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_'||x.table_name||');'||Pkg_Glb.C_LF;

                it_body(it_body.COUNT+1) :='PROCEDURE p_'||LOWER(x.table_name)||'_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_'||x.table_name||')'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='IS'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    it_idriga   Pkg_Glb.typ_integer;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='BEGIN '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    IF p_it_row.COUNT=0 THEN RETURN; END IF;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    CASE p_tip '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''U'' THEN'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).'||x.tbl_idriga||'; END LOOP;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            FORALL i IN p_it_row.first..p_it_row.last UPDATE '||x.table_name||' SET ROW =p_it_row(i) WHERE '||x.tbl_idriga||'=it_idriga(i);'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''I'' THEN'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO '||x.table_name||' VALUES p_it_row(i);'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''D'' THEN '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM '||x.table_name||' WHERE '||x.tbl_idriga||'=it_idriga(i);'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    END CASE;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='END;'||Pkg_Glb.C_LF;
        WHEN    'I' THEN
                it_spec(it_spec.COUNT+1) :=RPAD('PROCEDURE p_'||LOWER(x.table_name)||'_miud',50 )||'(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_'||x.table_name||');'||Pkg_Glb.C_LF;

                it_body(it_body.COUNT+1) :='PROCEDURE p_'||LOWER(x.table_name)||'_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_'||x.table_name||')'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='IS'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    it_idriga   Pkg_Glb.typ_integer;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='BEGIN '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    IF p_it_row.COUNT=0 THEN RETURN; END IF;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    CASE p_tip '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''U'' THEN'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            NULL;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''I'' THEN'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO '||x.table_name||' VALUES p_it_row(i);'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='        WHEN ''D'' THEN '||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='            NULL;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='    END CASE;'||Pkg_Glb.C_LF;
                it_body(it_body.COUNT+1) :='END;'||Pkg_Glb.C_LF;
        WHEN    'N' THEN
                NULL;
        END CASE;
    END LOOP;
    --
    v_cursor_name := DBMS_SQL.OPEN_CURSOR;
    --
    it_spec(it_spec.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    it_body(it_body.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    -- create body
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_body,
                    lb              =>  1,
                    ub              =>  it_body.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);
    -- create specification
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_spec,
                    lb              =>  1,
                    ub              =>  it_spec.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);

    DBMS_SQL.CLOSE_CURSOR(v_cursor_name);
END;
----------------------------------------------------------------------------------------
PROCEDURE p_create_pkg_get
IS


    CURSOR C_LINES   IS
                    SELECT  tbl_name    table_name, m.*
                    FROM    APP_TABLE m
                    WHERE       flag_get            <> 'N'
                            AND LENGTH(tbl_name)    <= 20
                    ORDER BY table_name
                    ;

    v_cursor_name           INTEGER;
    v_ret                   INTEGER;
    it_body                 DBMS_SQL.VARCHAR2A;
    it_spec                 DBMS_SQL.VARCHAR2A;

    C_PACKAGE_NAME          VARCHAR2(32000)      :=  'PKG_GET';

BEGIN

    Pkg_App_Tools.p_delete_non_existent_object();

    it_spec(it_spec.COUNT+1) :='CREATE OR REPLACE PACKAGE '|| C_PACKAGE_NAME||Pkg_Glb.C_LF  ;
    it_spec(it_spec.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --
    it_body(it_body.COUNT+1) :='CREATE OR REPLACE PACKAGE BODY '|| C_PACKAGE_NAME||Pkg_Glb.C_LF ;
    it_body(it_body.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --


    FOR x IN C_LINES
    LOOP

        it_spec(it_spec.COUNT+1) :=RPAD('FUNCTION f_get_'||LOWER(x.table_name),50 )||'(p_row IN OUT '||x.table_name||'%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;'||Pkg_Glb.C_LF;

        it_body(it_body.COUNT+1) :='--------------------------------------------------------------------'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='FUNCTION f_get_'||LOWER(x.table_name)||'(p_row IN OUT '||x.table_name||'%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='IS'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                    SELECT * FROM '||x.table_name||' WHERE '||x.tbl_idriga||' = p_idriga;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    CURSOR          C_BLOCK (p_idriga INTEGER) IS  '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                    SELECT * FROM '||x.table_name||' WHERE '||x.tbl_idriga||' = p_idriga  FOR UPDATE;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    v_found         BOOLEAN;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='BEGIN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    IF p_block = 0 THEN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        OPEN    C_NO_BLOCK(p_row.'||x.tbl_idriga||');'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        FETCH   C_NO_BLOCK  INTO p_row;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        v_found := C_NO_BLOCK%FOUND;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        CLOSE   C_NO_BLOCK;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    ELSE'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        OPEN    C_BLOCK(p_row.'||x.tbl_idriga||');'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        FETCH   C_BLOCK  INTO p_row;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        v_found := C_BLOCK%FOUND;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        CLOSE   C_BLOCK;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    END IF;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    RETURN v_found;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='END;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) := Pkg_Glb.C_LF;


        it_spec(it_spec.COUNT+1) :=RPAD('PROCEDURE p_get_'||LOWER(x.table_name),50)||'(p_row IN OUT '||x.table_name||'%ROWTYPE, p_block INTEGER DEFAULT 0);'||Pkg_Glb.C_LF;

        it_body(it_body.COUNT+1) :='PROCEDURE p_get_'||LOWER(x.table_name)||'(p_row IN OUT '||x.table_name||'%ROWTYPE, p_block INTEGER DEFAULT 0) '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='IS'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='BEGIN '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    IF NOT Pkg_Get.f_get_'||LOWER(x.table_name)||'(p_row, p_block) THEN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        Pkg_Lib.p_rae(''Acest cod nu este definit in sistem: ''||p_row.idriga||'' - '||x.table_name||''');'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    END IF;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='END;'||Pkg_Glb.C_LF;

    END LOOP;

    --
    v_cursor_name := DBMS_SQL.OPEN_CURSOR;
    --
    it_spec(it_spec.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    it_body(it_body.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    -- create body
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_body,
                    lb              =>  1,
                    ub              =>  it_body.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);
    -- create specification
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_spec,
                    lb              =>  1,
                    ub              =>  it_spec.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);

    DBMS_SQL.CLOSE_CURSOR(v_cursor_name);
END;
-------------------------------------------------------------------------------------------------------------
PROCEDURE p_create_pkg_get2
IS


    CURSOR C_LINES   IS
                    SELECT  tbl_name    table_name, m.*
                    FROM    APP_TABLE m
                    WHERE   get2_columns            IS NOT NULL
                            AND LENGTH(tbl_name)    <= 20
                    ORDER BY table_name
                    ;

    CURSOR  C_WHERE(p_get2_columns VARCHAR2) IS
                    SELECT  txt01 column_name,
                            COUNT(*) OVER() column_number
                    FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_get2_columns))
                    ORDER BY txt01
                    ;


    v_cursor_name           INTEGER;
    v_ret                   INTEGER;
    it_body                 DBMS_SQL.VARCHAR2A;
    it_spec                 DBMS_SQL.VARCHAR2A;
    v_where                 VARCHAR2(32000);

    C_PACKAGE_NAME          VARCHAR2(32000)      :=  'PKG_GET2';

BEGIN

    Pkg_App_Tools.p_delete_non_existent_object();

    it_spec(it_spec.COUNT+1) :='CREATE OR REPLACE PACKAGE '|| C_PACKAGE_NAME||Pkg_Glb.C_LF  ;
    it_spec(it_spec.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --
    it_body(it_body.COUNT+1) :='CREATE OR REPLACE PACKAGE BODY '|| C_PACKAGE_NAME||Pkg_Glb.C_LF ;
    it_body(it_body.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --


    FOR x IN C_LINES
    LOOP

        v_where     :=  NULL;
        FOR z IN C_WHERE(x.get2_columns) LOOP
            v_where :=  v_where  ||LOWER(z.column_name)||' = p_row.'||LOWER(z.column_name);
            IF z.column_number > C_WHERE%rowcount THEN
                v_where :=  v_where  ||' AND ';
            END IF;
        END LOOP;

        it_spec(it_spec.COUNT+1) :=RPAD('FUNCTION f_get_'||LOWER(x.table_name)||'_2',50 )||'(p_row IN OUT '||x.table_name||'%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN;'||Pkg_Glb.C_LF;

        it_body(it_body.COUNT+1) :='--------------------------------------------------------------------'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='FUNCTION f_get_'||LOWER(x.table_name)||'_2(p_row IN OUT '||x.table_name||'%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='IS'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    CURSOR          C_NO_BLOCK (p_row '||x.table_name||'%ROWTYPE) IS  '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                    SELECT * FROM '||x.table_name
                                                        ||' WHERE '|| v_where||';'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    CURSOR          C_BLOCK (p_row '||x.table_name||'%ROWTYPE) IS  '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                    SELECT * FROM '||x.table_name
                                                        ||' WHERE '|| v_where||' FOR UPDATE;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    v_found         BOOLEAN;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='BEGIN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    IF p_block = 0 THEN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        OPEN    C_NO_BLOCK(p_row);'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        FETCH   C_NO_BLOCK  INTO p_row;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        v_found := C_NO_BLOCK%FOUND;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        CLOSE   C_NO_BLOCK;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    ELSE'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        OPEN    C_BLOCK(p_row);'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        FETCH   C_BLOCK  INTO p_row;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        v_found := C_BLOCK%FOUND;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        CLOSE   C_BLOCK;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    END IF;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    RETURN v_found;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='END;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) := Pkg_Glb.C_LF;

        it_spec(it_spec.COUNT+1) := RPAD('PROCEDURE p_get_'||LOWER(x.table_name)||'_2',50 )||'(p_row IN OUT '||x.table_name||'%ROWTYPE, p_block INTEGER DEFAULT 0);'||Pkg_Glb.C_LF;

        it_body(it_body.COUNT+1) :='PROCEDURE p_get_'||LOWER(x.table_name)||'_2(p_row IN OUT '||x.table_name||'%ROWTYPE, p_block INTEGER DEFAULT 0)'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='IS'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    v_found         BOOLEAN;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='BEGIN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    v_found :=  pkg_get2.f_get_'||LOWER(x.table_name)||'_2(p_row);'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    IF NOT v_found THEN Pkg_Err.p_rae(''Informatie negasita'');'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    END IF;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='END;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) := Pkg_Glb.C_LF;
        

    END LOOP;

    --
    v_cursor_name := DBMS_SQL.OPEN_CURSOR;
    --
    it_spec(it_spec.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    it_body(it_body.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    -- create body
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_body,
                    lb              =>  1,
                    ub              =>  it_body.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);
    -- create specification
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_spec,
                    lb              =>  1,
                    ub              =>  it_spec.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);

    DBMS_SQL.CLOSE_CURSOR(v_cursor_name);
END;
-------------------------------------------------------------------------------------------------------------
PROCEDURE p_create_pkg_trg
IS


    CURSOR C_LINES   IS
                    SELECT  tbl_name    table_name, m.*
                    FROM    APP_TABLE m
                    WHERE   flag_insert_trg     =   'Y'
                    ORDER BY table_name
                    ;
    CURSOR C_COLUMNS(p_table_name VARCHAR2) IS
                    SELECT  *
                    FROM    USER_TAB_COLS
                    WHERE       table_name      =   p_table_name
                            AND hidden_column   =   'NO'
                            AND virtual_column  =   'NO'
                    ORDER BY    column_id
                    ;

    v_cursor_name           INTEGER;
    v_ret                   INTEGER;
    it_trg                  DBMS_SQL.VARCHAR2A;
    it_body                 DBMS_SQL.VARCHAR2A;
    it_spec                 DBMS_SQL.VARCHAR2A;
    v_line                  VARCHAR2(32000);
    v_mod_func              VARCHAR2(32000);


    C_PACKAGE_NAME          VARCHAR2(32000)      :=  'PKG_TRG';

BEGIN

    Pkg_App_Tools.p_delete_non_existent_object();

    --
    v_cursor_name := DBMS_SQL.OPEN_CURSOR;
    --
    it_spec(it_spec.COUNT+1) :='CREATE OR REPLACE PACKAGE '|| C_PACKAGE_NAME||Pkg_Glb.C_LF  ;
    it_spec(it_spec.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --
    it_body(it_body.COUNT+1) :='CREATE OR REPLACE PACKAGE BODY '|| C_PACKAGE_NAME||Pkg_Glb.C_LF ;
    it_body(it_body.COUNT+1) :='IS '||Pkg_Glb.C_LF;
    --
    FOR x IN C_LINES
    LOOP

        it_trg.DELETE;

        it_trg(it_trg.COUNT+1)  :=  'CREATE OR REPLACE TRIGGER TRG_'||x.table_name||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :=  'BEFORE INSERT OR UPDATE OR DELETE '||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :=  'ON '||x.table_name||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :=  'REFERENCING NEW AS NEW OLD AS OLD ' ||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :=  'FOR EACH ROW ' ||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :=  'DECLARE ' ||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :=  '    vo   '||x.table_name||'%ROWTYPE; '||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :=  '    vn   '||x.table_name||'%ROWTYPE; '||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :=  'BEGIN '||Pkg_Glb.C_LF ;


        v_line  :=      NULL;
        FOR z IN C_COLUMNS(x.table_name) LOOP
            v_line  :=  v_line||'vo.'||LOWER(z.column_name)||' := :old.'||LOWER(z.column_name)||';';
            IF MOD(C_COLUMNS%rowcount,5) = 0 THEN
                it_trg(it_trg.COUNT + 1)   := '    '||v_line||Pkg_Glb.C_LF ;
                v_line      :=  NULL;
            END IF;
        END LOOP;
        it_trg(it_trg.COUNT + 1)   := '    '||v_line||Pkg_Glb.C_LF ;
        v_line  :=      NULL;
        FOR z IN C_COLUMNS(x.table_name) LOOP
            v_line  :=  v_line||'vn.'||LOWER(z.column_name)||' := :new.'||LOWER(z.column_name)||';';
            IF MOD(C_COLUMNS%rowcount,5) = 0 THEN
                it_trg(it_trg.COUNT + 1)   := '    '||v_line||Pkg_Glb.C_LF ;
                v_line      :=  NULL;
            END IF;
        END LOOP;
        it_trg(it_trg.COUNT + 1)   := '    '||v_line||Pkg_Glb.C_LF ;

        it_trg(it_trg.COUNT+1)  := Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :='    IF INSERTING THEN '||Pkg_Glb.C_LF ;
        it_trg(it_trg.COUNT+1)  :='        PKG_TRG.p_'||LOWER(x.table_name)||'(''I'', vo, vn) ; '||Pkg_Glb.C_LF ;

        v_line  :=      NULL;
        FOR z IN C_COLUMNS(x.table_name) LOOP
            v_line  :=  v_line||':new.'||LOWER(z.column_name)||' := vn.'||LOWER(z.column_name)||';';
            IF MOD(C_COLUMNS%rowcount,5) = 0 THEN
                it_trg(it_trg.COUNT + 1)   := '        '||v_line||Pkg_Glb.C_LF ;
                v_line      :=  NULL;
            END IF;
        END LOOP;
        it_trg(it_trg.COUNT + 1)   := '        '||v_line||Pkg_Glb.C_LF ;

        IF x.flag_audit_trg =   'Y' THEN
             it_trg(it_trg.COUNT+1)  :='    ELSIF DELETING THEN '||Pkg_Glb.C_LF ;
             it_trg(it_trg.COUNT+1)  :='        PKG_TRG.p_'||LOWER(x.table_name)||'(''D'', vo, vn) ; '||Pkg_Glb.C_LF ;
             it_trg(it_trg.COUNT+1)  :='    ELSE '||Pkg_Glb.C_LF ;
             it_trg(it_trg.COUNT+1)  :='        PKG_TRG.p_'||LOWER(x.table_name)||'(''U'', vo, vn) ; '||Pkg_Glb.C_LF ;
             it_trg(it_trg.COUNT+1)  :='    END IF; '||Pkg_Glb.C_LF ;
        ELSE
             it_trg(it_trg.COUNT+1)  :='    END IF; '||Pkg_Glb.C_LF ;
        END IF;

        it_trg(it_trg.COUNT+1)  :='END;'||Pkg_Glb.C_LF ;


        DBMS_SQL.PARSE(
                        c               =>  v_cursor_name,
                        STATEMENT       =>  it_trg,
                        lb              =>  1,
                        ub              =>  it_trg.COUNT,
                        lfflg           =>  FALSE,
                        language_flag   =>  DBMS_SQL.NATIVE
                      );
        v_ret := DBMS_SQL.EXECUTE(v_cursor_name);

        it_spec(it_spec.COUNT+1) :=RPAD('PROCEDURE p_'||LOWER(x.table_name),50 )||'(p_tip VARCHAR2, p_ro IN OUT '||x.table_name||'%ROWTYPE, p_rn IN OUT '||x.table_name||'%ROWTYPE ) ;'||Pkg_Glb.C_LF;

        it_body(it_body.COUNT+1) :='--------------------------------------------------------------------'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='PROCEDURE p_'||LOWER(x.table_name)||'(p_tip VARCHAR2, p_ro IN OUT '||x.table_name||'%ROWTYPE, p_rn IN OUT '||x.table_name||'%ROWTYPE )' ||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='IS'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    CURSOR  C_LINE IS  '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='            SELECT SC_'||x.table_name||'.nextval AS result FROM DUAL; '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    c VARCHAR2(30000);'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    m VARCHAR2(32000);'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='BEGIN'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :=Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    CASE p_tip '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        WHEN ''I'' THEN '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='            IF p_rn.'||x.tbl_idriga||' IS NULL THEN '   ||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                OPEN  C_LINE;'   ||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                FETCH C_LINE INTO p_rn.'||x.tbl_idriga||';'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                CLOSE C_LINE;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='            END IF; '   ||Pkg_Glb.C_LF;
        FOR z IN C_COLUMNS(x.table_name) LOOP
            CASE z.column_name
                    WHEN    x.tbl_idriga   THEN
                                NULL;
                    WHEN    'DCN'   THEN
                        it_body(it_body.COUNT+1) :='            p_rn.dcn                           :=  0; '   ||Pkg_Glb.C_LF;
                    WHEN    'NUSER'   THEN
                        it_body(it_body.COUNT+1) :='            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); '   ||Pkg_Glb.C_LF;
                    WHEN    'DATAGG'   THEN
                        it_body(it_body.COUNT+1) :='            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); '   ||Pkg_Glb.C_LF;
                    WHEN    'WORKST'   THEN
                        it_body(it_body.COUNT+1) :='            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT(''USERENV'',''HOST'')); '   ||Pkg_Glb.C_LF;
                    WHEN    'OSUSER'   THEN
                        it_body(it_body.COUNT+1) :='            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT(''USERENV'',''OS_USER''))); '   ||Pkg_Glb.C_LF;
                    WHEN    'IDUSER'   THEN
                        it_body(it_body.COUNT+1) :='            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); '   ||Pkg_Glb.C_LF;
                    ELSE
                    -- default values for columns
                    it_body(it_body.COUNT+1) :='            '||RPAD('p_rn.'||LOWER(z.column_name),35)||':= NVL(p_rn.'||LOWER(z.column_name)
                                                             ||','||NVL(z.data_default,'NULL')||'); ' ||Pkg_Glb.C_LF;
            END CASE;
        END LOOP;

        it_body(it_body.COUNT+1) :='        WHEN ''U'' THEN '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='            IF Pkg_Audit.f_return_faudit() = 0 THEN '||Pkg_Glb.C_LF;
        FOR z IN C_COLUMNS(x.table_name) LOOP
            IF z.column_name NOT IN ('IDRIGA','DCN','NUSER','DATAGG','WORKST','OSUSER','IDUSER') THEN
                CASE z.data_type
                    WHEN    'NUMBER'    THEN    v_mod_func  :=  'Pkg_Lib.p_n';
                    WHEN    'VARCHAR2'  THEN    v_mod_func  :=  'Pkg_Lib.p_c';
                    WHEN    'CHAR'      THEN    v_mod_func  :=  'Pkg_Lib.p_c';
                    WHEN    'DATE'      THEN    v_mod_func  :=  'Pkg_Lib.p_d';
                    ELSE                        v_mod_func  :=  NULL;
                END CASE;
                IF v_mod_func IS NOT NULL THEN
                     it_body(it_body.COUNT+1) :='                 '
                                                ||v_mod_func||'(p_ro.'||LOWER(z.column_name)
                                                ||',p_rn.'||LOWER(z.column_name)
                                                ||',m,c,'''||z.column_name||'''); '
                                                ||Pkg_Glb.C_LF;
                END IF;
            END IF;
        END LOOP;
        it_body(it_body.COUNT+1) :='                IF c IS NOT NULL THEN '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                    Pkg_Audit.p_app_audit_insert('||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                        p_tbl_oper     =>  ''UPDATE'','||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                        p_tbl_name     =>  '''||x.table_name||''','||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                        p_tbl_idriga   =>  p_ro.'||x.tbl_idriga||','||Pkg_Glb.C_LF;
        IF x.tbl_audit_idx1 IS NULL THEN
            it_body(it_body.COUNT+1) :='                        p_tbl_idx1     =>  NULL,'||Pkg_Glb.C_LF;
        ELSE
            it_body(it_body.COUNT+1) :='                        p_tbl_idx1     =>  p_ro.'||x.tbl_audit_idx1||','||Pkg_Glb.C_LF;
        END IF;
        IF x.tbl_audit_idx2 IS NULL THEN
            it_body(it_body.COUNT+1) :='                        p_tbl_idx2     =>  NULL,'||Pkg_Glb.C_LF;
        ELSE
            it_body(it_body.COUNT+1) :='                        p_tbl_idx2     =>  p_ro.'||x.tbl_audit_idx2||','||Pkg_Glb.C_LF;
        END IF;
        it_body(it_body.COUNT+1) :='                        p_note         =>  m '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                    );'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                END IF;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='            END IF; '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='        WHEN ''D'' THEN '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='            IF Pkg_Audit.f_return_faudit() = 0 THEN '||Pkg_Glb.C_LF;
        FOR z IN C_COLUMNS(x.table_name) LOOP
            it_body(it_body.COUNT+1) :='                m   :=  m ||'''||LOWER(z.column_name)
                                                        ||':''||p_ro.'||LOWER(z.column_name)||'||'','''
                                                        ||'; '||Pkg_Glb.C_LF;
        END LOOP;
        it_body(it_body.COUNT+1) :='                IF m IS NOT NULL THEN '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                    Pkg_Audit.p_app_audit_insert('||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                        p_tbl_oper     =>  ''DELETE'','||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                        p_tbl_name     =>  '''||x.table_name||''','||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                        p_tbl_idriga   =>  p_ro.'||x.tbl_idriga||','||Pkg_Glb.C_LF;
        IF x.tbl_audit_idx1 IS NULL THEN
            it_body(it_body.COUNT+1) :='                        p_tbl_idx1     =>  NULL,'||Pkg_Glb.C_LF;
        ELSE
            it_body(it_body.COUNT+1) :='                        p_tbl_idx1     =>  p_ro.'||x.tbl_audit_idx1||','||Pkg_Glb.C_LF;
        END IF;
        IF x.tbl_audit_idx2 IS NULL THEN
            it_body(it_body.COUNT+1) :='                        p_tbl_idx2     =>  NULL,'||Pkg_Glb.C_LF;
        ELSE
            it_body(it_body.COUNT+1) :='                        p_tbl_idx2     =>  p_ro.'||x.tbl_audit_idx2||','||Pkg_Glb.C_LF;
        END IF;
        it_body(it_body.COUNT+1) :='                        p_note         =>  m '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                    );'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='                END IF;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='            END IF; '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='    END CASE; '||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) :='END;'||Pkg_Glb.C_LF;
        it_body(it_body.COUNT+1) := Pkg_Glb.C_LF;

    END LOOP;
    --
    it_spec(it_spec.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    it_body(it_body.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    -- create body
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_body,
                    lb              =>  1,
                    ub              =>  it_body.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);
    -- create specification
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_spec,
                    lb              =>  1,
                    ub              =>  it_spec.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);


    DBMS_SQL.CLOSE_CURSOR(v_cursor_name);
END;
---------------------------------------------------------------------------------------------------------------
PROCEDURE p_create_pkg_rtype
IS

    CURSOR  C_LINES IS
            SELECT  tbl_name object_name
            FROM    APP_TABLE
            WHERE       LENGTH(tbl_name)    <= 27
                    AND flag_rtype          =   'Y'
            ORDER BY   object_type, object_name
            ;

    v_cursor_name           INTEGER;
    v_ret                   INTEGER;
    it_body                 DBMS_SQL.VARCHAR2A;
    it_spec                 DBMS_SQL.VARCHAR2A;

    C_PACKAGE_NAME          VARCHAR2(32000)      :=  'PKG_RTYPE';

BEGIN

    Pkg_App_Tools.p_delete_non_existent_object();

    it_spec(it_spec.COUNT+1) :='CREATE OR REPLACE PACKAGE '|| C_PACKAGE_NAME||Pkg_Glb.C_LF  ;
    it_spec(it_spec.COUNT+1) :='IS '||Pkg_Glb.C_LF;

    FOR x IN C_LINES LOOP
        it_spec(it_spec.COUNT+1) :=RPAD('TYPE ta_'||LOWER(x.object_name),50 )||'IS TABLE OF '||LOWER(x.object_name)||'%ROWTYPE INDEX BY BINARY_INTEGER;'||Pkg_Glb.C_LF;
        it_spec(it_spec.COUNT+1) :=RPAD('TYPE tas_'||LOWER(x.object_name),50 )||'IS TABLE OF '||LOWER(x.object_name)||'%ROWTYPE INDEX BY VARCHAR2(1000);'||Pkg_Glb.C_LF;
    END LOOP;


    --
    v_cursor_name := DBMS_SQL.OPEN_CURSOR;
    --
    it_spec(it_spec.COUNT+1) :='END; '||Pkg_Glb.C_LF;
    -- create specification
    DBMS_SQL.PARSE(
                    c               =>  v_cursor_name,
                    STATEMENT       =>  it_spec,
                    lb              =>  1,
                    ub              =>  it_spec.COUNT,
                    lfflg           =>  FALSE,
                    language_flag   =>  DBMS_SQL.NATIVE
                  );
    v_ret := DBMS_SQL.EXECUTE(v_cursor_name);

    DBMS_SQL.CLOSE_CURSOR(v_cursor_name);
END;







/***********************************************************************************************************
    - 15/11/2006 Creation date

***********************************************************************************************************/
PROCEDURE p_dbg_start   (p_parameter_list VARCHAR2)
-----------------------------------------------------------------------------------------------------------
--      simple procedure that sets the debugging variables with procedure name and the list of parameters
-----------------------------------------------------------------------------------------------------------
IS
    CURSOR C_GET_COLUMNS     (p_pkg_name VARCHAR2, p_procedure VARCHAR2)
                             IS
                             SELECT  argument_name
                             FROM    USER_ARGUMENTS
                             WHERE   NVL(package_name,' ')   = NVL(p_pkg_name,' ')
                                 AND OBJECT_name             = p_procedure
                                 AND data_level              = 0;

    v_owner     VARCHAR2(100);
    v_name      VARCHAR2(100);
    v_lineno    NUMBER;
    v_caller_t  VARCHAR2(100);
    v_proc_par  VARCHAR2(2000);
    v_msg_text  VARCHAR2(2000);
    v_context   VARCHAR2(1000);
    v_proc_name VARCHAR2(100);

BEGIN
    -- determine the OWNER, PACKAGE NAME, LINE in package from the logged procedure
    Pkg_Lib.who_called_me   (v_owner, v_name, v_lineno, v_caller_t);
    -- determine the current procedure name
    v_proc_name         := Pkg_Lib.f_get_procedure_name (v_name,v_lineno);
    -- determine the procedure parameters names
    FOR x IN C_GET_COLUMNS(v_name, v_proc_name) LOOP
        v_proc_par := v_proc_par || x.argument_name || '^';
    END LOOP;
    -- logging the start as procedure
    v_msg_text      := 'Starting Procedure '|| v_owner ||'.'||v_name||'.'||v_proc_name || ' ('||v_proc_par||') at line '||v_lineno;
    v_context       := p_parameter_list;
    Pkg_App_Tools.P_Log('T',v_msg_text,v_context);
END;

PROCEDURE p_dbg_stop    (   p_flag_error BOOLEAN DEFAULT FALSE, p_err VARCHAR2 DEFAULT NULL)
IS
    v_owner     VARCHAR2(100);
    v_name      VARCHAR2(100);
    v_lineno    NUMBER;
    v_caller_t  VARCHAR2(100);
    v_proc_name VARCHAR2(100);
BEGIN
    -- determine the OWNER, PACKAGE NAME, LINE in package from the logged procedure
    Pkg_Lib.who_called_me   (v_owner, v_name, v_lineno, v_caller_t);
    -- determine the current procedure name
    v_proc_name         := Pkg_Lib.f_get_procedure_name (v_name,v_lineno);
    -- logging the procedure completion
    IF p_flag_error THEN
        Pkg_App_Tools.P_Log('T','Procedure: ' || v_proc_name  || ' completed succesfull','');
    ELSE
        Pkg_App_Tools.P_Log('T','Procedure: ' || v_proc_name  || ' terminated with error :'||p_err,'');
    END IF;
END;

/*************************************************************************************************************
    - 15/11/2006 - creation date

*************************************************************************************************************/
PROCEDURE p_set_flag_debug(p_value INTEGER)
--------------------------------------------------------------------------------------------------------------
--     SETS/RESETS the boolean DEBUG flag
--    If this flag is TRUE => the logging ptocedure will insert a log into the APP_LOG table
--------------------------------------------------------------------------------------------------------------
IS
BEGIN
    IF p_value = 0 THEN
        Pkg_Glb.gv_flag_debug   := FALSE;
    ELSE
        Pkg_Glb.gv_flag_debug   := TRUE;
    END IF;
END;


/**************************************************************************
    LOG every message (warning, error, silent error, normal operations) in an autonomous transaction
***********************************************************************************************************/
PROCEDURE P_Log (p_msg_type VARCHAR2, p_msg_text VARCHAR2, p_msg_context VARCHAR2)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    IF Pkg_Glb.gv_flag_debug THEN
        INSERT INTO APP_LOG(msg_type, msg_text, msg_context) VALUES(p_msg_type, p_msg_text, p_msg_context);
    END IF;
    COMMIT;
END;

/**************************************************************************

***********************************************************************************************************/
PROCEDURE p_reset_Mlog (p_ref_app_log INTEGER)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    UPDATE APP_LOG SET msg_type = 'L' WHERE line_id = p_ref_app_log;
    COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;

END;


/**********************************************************************************************************
    21/02/2008 d create date

***********************************************************************************************************/
PROCEDURE p_audit   (   p_tbl_oper      VARCHAR2,
                        p_tbl_name      VARCHAR2,
                        p_tbl_line_id   NUMBER,
                        p_tbl_idx1      VARCHAR2,
                        p_tbl_idx2      VARCHAR2,
                        p_note          VARCHAR2
                    )
-----------------------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------------------
IS
BEGIN
    INSERT INTO APP_AUDIT   (TBL_OPER,  TBL_NAME,   TBL_IDRIGA,     TBL_IDX1,   TBL_IDX2,   note)
    VALUES                  (p_tbl_oper,p_tbl_name, p_tbl_line_id,  p_tbl_idx1, p_tbl_idx2, p_note);
END;

/**********************************************************************************************************
    08/03/2008 z create date

***********************************************************************************************************/
PROCEDURE p_load_app_table
-----------------------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------------------
IS
    CURSOR  C_LINES IS
        SELECT  object_name, SUBSTR(object_type,1,1) object_type
        FROM    USER_OBJECTS
        WHERE       object_type IN ('TABLE','VIEW')
                AND object_name NOT IN (SELECT tbl_name FROM APP_TABLE)
        ORDER BY object_type, object_name
        ;

    v_row       APP_TABLE%ROWTYPE;
BEGIN

    FOR x IN C_LINES LOOP

        v_row.tbl_name                  :=  x.object_name;
        v_row.object_type               :=  x.object_type;
        v_row.description               :=  NULL;

        IF v_row.object_type = 'T' THEN
            v_row.flag_insert_trg       :=  'Y';
            v_row.flag_audit_trg        :=  'Y';
            v_row.flag_dcn_trg          :=  'Y';
        ELSE
            v_row.flag_insert_trg       :=  'N';
            v_row.flag_audit_trg        :=  'N';
            v_row.flag_dcn_trg          :=  'N';
        END IF;

        v_row.tbl_idriga                :=  'IDRIGA';
        v_row.tbl_audit_idx1            :=  NULL;
        v_row.tbl_audit_idx2            :=  NULL;
        v_row.descr_audit_idx1          :=  NULL;
        v_row.descr_audit_idx2          :=  NULL;
        v_row.flag_rtype                :=  'Y' ;
        v_row.flag_iud                  :=  'Y' ;
        v_row.flag_get                  :=  'Y' ;
        v_row.get2_columns              :=  NULL;

        INSERT INTO APP_TABLE
        VALUES      v_row;

    END LOOP;

    COMMIT;
END;
/**********************************************************************************************************
    08/03/2008 z create date

***********************************************************************************************************/
PROCEDURE p_recreate_table_environment
/*----------------------------------------------------------------
- Table APP_TABLE manages:
    - FLAG_INSERT_TRG creates the TRG_....(table name)
      with the insert staff (IDRIGA, DATAGG .. etc), possible
      values Y, N
    - FLAG_AUDIT_TRG includes in the previous TRG_....
      trigger also the audit staff for UPDATE and DELETE, possible
      values Y, N
    - the above 2 thing is maanaged by p_create_pkg_trg procedure
    - TBL_IDRIGA - this indicates the ID of the table,  has to be
      filed, the majority of tables has IDRIGA but can be other
    - FLAG_RTYPE - creates the PKG_RTYPE, possible values Y, N
      with procedure p_create_pkg_rtype
    - FLAG_IUD - creates the PKG_IUD,with procedure p_create_pkg_iud
      possible values are
       N - do not create IUD
       A - create all inclusive update and delete
       I - only the multi insert version (for example some views)
    - FLAG_GET - creates the PKG_GET with procedure p_create_pkg_get,
      possible values N, Y
    - GET2_COLUMNS - should be filled with the list of column names
      separeted by coma for witch the procedure p_create_pkg_get2
      will create an entry in PKG_GET2, if NULL does not create any
------------------------------------------------------------------*/
IS
BEGIN
    Pkg_App_Tools.p_create_pkg_trg  ();
    Pkg_App_Tools.p_create_pkg_rtype();
    Pkg_App_Tools.p_create_pkg_get  ();
    Pkg_App_Tools.p_create_pkg_iud  ();
    Pkg_App_Tools.p_create_pkg_get2 ();
    Pkg_App_Tools.p_create_pkg_mod_col();
END;
------------------------------------------------------------------------------------
PROCEDURE p_delete_non_existent_object
IS
BEGIN
    DELETE FROM APP_TABLE
    WHERE   tbl_name NOT IN
            ( SELECT  object_name
              FROM    USER_OBJECTS
              WHERE   object_type IN ('TABLE','VIEW')
    );
    COMMIT;
END;


/*****************************************************************************************************************
    - 17/10/2006d creation date

******************************************************************************************************************/
PROCEDURE p_trigger_iud     (   p_schema        VARCHAR2,
                                p_table         VARCHAR2,
                                p_flag_audit    INTEGER     DEFAULT 0,
                                p_audidx1       VARCHAR2    DEFAULT NULL,
                                p_audidx2       VARCHAR2    DEFAULT NULL
                            )
IS

    CURSOR              C_EX_COL (p_schema VARCHAR2, p_table VARCHAR2, p_col_name VARCHAR2) IS
                        SELECT  1
                        FROM    DBA_TAB_COLS
                        WHERE   owner = p_schema AND table_name = UPPER(p_table) AND column_name = p_col_name;

    CURSOR              C_SEL_COLS (p_schema VARCHAR2, p_table VARCHAR2) IS
                        SELECT  column_name,data_type,data_default
                        FROM    DBA_TAB_COLS
                        WHERE   owner       = p_schema
                            AND table_name  = p_table
                            AND column_name NOT IN ('LINE_ID','DCN','USER_ID','INSERT_DATE','OSUSER','WORKSTATION','AUDSID')
                            AND data_type   NOT IN ('CLOB','LONG','RAW','ROWID');

 v_sql          VARCHAR2(32000);
 v_data_default  VARCHAR2(100);
    v_idx1              VARCHAR2(50);
    v_idx2              VARCHAR2(50);

BEGIN

 -- debug
--    Pkg_App_Tools.p_dbg_start(Pkg_Lib.f_implode('^',p_schema,p_table,p_flag_audit,p_audidx1,p_audidx2));


 IF p_table IS NULL THEN RETURN ; END IF;

    IF p_audidx1 IS NULL THEN
       v_idx1       := 'NULL';
    ELSE
     v_idx1      := ':OLD.' || p_audidx1;
    END IF;
    IF p_audidx2 IS NULL THEN
       v_idx2       := 'NULL ';
    ELSE
       v_idx2       := ':OLD.' || p_audidx2;
    END IF;

 -- header-ul trigger-ului + initializare tmpVar
 v_sql := 'CREATE OR REPLACE TRIGGER '|| p_schema || '.TRG_' || p_table || CHR(10);
 v_sql := v_sql || 'BEFORE INSERT OR UPDATE OR DELETE ' || CHR(10);
 v_sql := v_sql || 'ON ' || p_schema || '.' || p_table  || CHR(10);
 v_sql := v_sql || 'REFERENCING NEW AS NEW OLD AS OLD' || CHR(10);
 v_sql := v_sql || 'FOR EACH ROW' || CHR(10);
 v_sql := v_sql || 'DECLARE' || CHR(10);
 v_sql := v_sql || ' tmpVar NUMBER;' || CHR(10);
 v_sql := v_sql || ' c varchar2(30000);' || CHR(10);
    v_sql := v_sql || ' m VARCHAR2(32000);' ||CHR(10);
 v_sql := v_sql || 'BEGIN' || CHR(10);
 v_sql := v_sql || ' tmpVar := 0;' || CHR(10);
 v_sql := v_sql || ' Pkg_Glb.v_modified_columns := NULL;'||CHR(10);

    v_sql := v_sql || 'IF INSERTING THEN '|| CHR(10);

 -- setari implicite
 v_sql := v_sql || ' IF :NEW.LINE_ID IS NULL THEN' || CHR(10);
 v_sql := v_sql || '  SELECT ' || p_schema|| '.SC_' || p_table ||'.NEXTVAL INTO tmpVar FROM dual;' || CHR(10);
 v_sql := v_sql || '  :NEW.LINE_ID:=tmpVar;' || CHR(10);
 v_sql := v_sql || ' END IF;'       || CHR(10);
 v_sql := v_sql || ' :NEW.DCN := 0;' || CHR(10);
 v_sql := v_sql || ' :NEW.INSERT_DATE:= SYSDATE;' || CHR(10);
 v_sql := v_sql || ' :NEW.WORKSTATION :=substr(SYS_CONTEXT(''USERENV'',''HOST''),1,30);' || CHR(10);
 v_sql := v_sql || ' :NEW.OSUSER := substr(UPPER(SYS_CONTEXT(''USERENV'',''OS_USER'')),1,30);' || CHR(10);
    v_sql := v_sql || ' :NEW.USER_ID := pkg_lib.f_return_user_code;' || CHR(10);
    v_sql := v_sql || ' :NEW.AUDSID := SYS_CONTEXT(''USERENV'',''SESSIONID'');' || CHR(10);
    v_sql := v_sql || ' :NEW.SBU_CODE := pkg_lib.f_return_sbu_code();' || CHR(10);

 v_sql := v_sql || CHR(10);

 -- parcurg coloanele tabelului
    FOR x IN C_SEL_COLS (p_schema, p_table) LOOP
        IF x.data_default IS NULL
      THEN v_data_default := 'NULL ';
        ELSE v_data_default := x.data_default;
       -- daca am Default Value => introduc logica si in trigger
       v_sql    := v_sql || ' :NEW.'|| x.column_name || ':=';
      v_sql    := v_sql || 'NVL(:NEW.'||x.column_name||','||x.data_default||');'||CHR(10);
        END IF;
   -- determin numele coloanelor modificate
   CASE
    WHEN  x.data_type IN ('VARCHAR2','NVARCHAR2','CHAR') THEN
      v_sql := v_sql || ' IF Pkg_Lib.f_mod_c(:NEW.' || x.column_name || ','||v_data_default ||') THEN ';
    WHEN  x.data_type IN ('DATE') THEN
      v_sql := v_sql || ' IF Pkg_Lib.f_mod_d(:NEW.' || x.column_name || ','||v_data_default ||') THEN ';
    WHEN  x.data_type IN ('NUMBER','INTEGER') THEN
      v_sql := v_sql || ' IF Pkg_Lib.f_mod_n(:NEW.' || x.column_name || ','||v_data_default ||') THEN ';
   END CASE;
   v_sql := v_sql || 'c:=c||''' || x.column_name || ';'';';
   v_sql := v_sql || 'END IF;' || CHR(10)||CHR(10);
 END LOOP;

    /***********************************************************************************************************
     DELETE
    ***********************************************************************************************************/

    v_sql   := v_sql || 'ELSIF DELETING THEN'|| CHR(10);
    v_sql   := v_sql || ' IF PKG_Lib.F_RETURN_FAUDIT=0 THEN'|| CHR(10);
    FOR x IN C_SEL_COLS (p_schema, p_table) LOOP
        v_sql :=v_sql || '  m:=m || '''||x.column_name ||':''||:old.'||x.column_name || '||'';'';';
        v_sql :=v_sql || CHR(10);
    END LOOP;
    v_sql := v_sql || CHR(10) || ' IF m IS NOT NULL THEN' ||CHR(10);
    v_sql := v_sql || '   Pkg_App_Tools.p_audit (''D'',''' || UPPER(p_table) || ''',:OLD.LINE_ID,'||v_idx1||','||v_idx2||', m);  ' ||CHR(10);
    v_sql := v_sql || '  END IF;' ||CHR(10);
    v_sql := v_sql || CHR(10);
    v_sql := v_sql || ' END IF;' || CHR(10);

    /***********************************************************************************************************
     UPDATE
    ***********************************************************************************************************/

    v_sql   := v_sql || 'ELSE '|| CHR(10);

    v_sql := v_sql || ' :NEW.AUDSID := SYS_CONTEXT(''USERENV'',''SESSIONID'');' || CHR(10);
    v_sql := v_sql || ' IF Pkg_Lib.f_mod_n(:NEW.DCN,:OLD.DCN) AND Pkg_Lib.f_mod_n(:NEW.AUDSID, :OLD.AUDSID) THEN'|| CHR(10);
    v_sql := v_sql || '  Pkg_Lib.p_rae(-20001,''Un alt utilizator a modificat inregistrarea! Reincarcati linia curenta !'');'|| CHR(10);
    v_sql := v_sql || ' END IF;'|| CHR(10);
    v_sql := v_sql || ' :NEW.dcn:=NVL(:OLD.dcn,0)+1;'|| CHR(10)|| CHR(10);
    FOR x IN C_SEL_COLS (p_schema, p_table) LOOP
        IF x.data_type ='DATE' THEN
            v_sql :=v_sql || ' Pkg_Lib.p_d(:old.'||x.column_name||',:new.'|| x.column_name ||',m,c,'''||x.column_name||''');' || CHR(10);
        ELSIF x.data_type ='NUMBER' THEN
            v_sql :=v_sql || ' Pkg_Lib.p_n(:old.'||x.column_name||',:new.'|| x.column_name ||',m,c,'''||x.column_name||''');' || CHR(10);
        ELSE
            v_sql :=v_sql || ' Pkg_Lib.p_c(:old.'||x.column_name||',:new.'|| x.column_name ||',m,c,'''||x.column_name||''');' || CHR(10);
        END IF;
    END LOOP;
    v_sql := v_sql || ' IF Pkg_Lib.F_RETURN_FAUDIT = 0 AND m IS NOT NULL THEN ' ||CHR(10);
    v_sql := v_sql || '  Pkg_App_Tools.p_audit(''U'',''' || UPPER(p_table) || ''',:OLD.LINE_ID,'||v_idx1||','||v_idx2||',m);  ' ||CHR(10);
    v_sql := v_sql || ' END IF;' ||CHR(10);

    v_sql   := v_sql || 'END IF;' || CHR(10);

 -- memorez intr-o variabila globala numele coloanelor modificate
 v_sql := v_sql || 'Pkg_Glb.v_modified_columns := c;'||CHR(10);

    /************************************************************************************************************
     EXCEPTION HANDLER
    ***********************************************************************************************************/

 v_sql := v_sql || 'EXCEPTION WHEN OTHERS THEN RAISE;'||CHR(10);
 v_sql := v_sql || 'END;' || CHR(10);


 EXECUTE IMMEDIATE v_sql;

    -- debug STOP
--    Pkg_App_Tools.p_dbg_stop;

EXCEPTION WHEN OTHERS THEN RAISE;

END;












END;

/

/
