--------------------------------------------------------
--  DDL for Package Body PKG_PATCH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_PATCH" 
AS

/***********************************************************************************************
    DDL :   01/04/2008  d   Create
/***********************************************************************************************/
PROCEDURE p_apply_patch (   p_patch_code        VARCHAR2)
------------------------------------------------------------------------------------------------
--  PURPOSE:    run the PATCH --
--  PREREQ:     the patch details (code lines) must exist in PATCH_DETAIL
------------------------------------------------------------------------------------------------
IS

    CURSOR C_PATCH          (p_patch_code   VARCHAR2)
                            IS
                            SELECT      line_text, ddl_seq
                            FROM        PATCH_DETAIL
                            WHERE       patch_code      =   p_patch_code
                            ORDER BY    idriga
                            ;

    v_row                   PATCH_HEADER%ROWTYPE;
    v_cursor_name           INTEGER;
    v_ret                   INTEGER;
    TYPE typ_str_sql        IS TABLE OF DBMS_SQL.VARCHAR2A INDEX BY BINARY_INTEGER;
    it_line                 typ_str_sql;
    v_ddl_seq               INTEGER;
    i                       PLS_INTEGER;

BEGIN

    v_row.patch_code        :=  p_patch_code;
    IF NOT Pkg_Get2.f_get_patch_header_2(v_row) THEN Pkg_App_Tools.P_Log('L','???',''); END IF;

    IF v_row.status = 'S' THEN Pkg_Lib.p_rae('Acest PATCH a mai fost executat inainte !'); END IF;

    FOR x IN C_PATCH    (p_patch_code)
    LOOP
        Pkg_App_Tools.P_Log('L','ddl_seq '||x.ddl_seq,p_patch_code);
        IF it_line.EXISTS(x.ddl_seq) THEN
            it_line(x.ddl_seq)(it_line(x.ddl_seq).COUNT+1)      :=  x.line_text;
        ELSE
            it_line(x.ddl_seq)(1)                               :=  x.line_text;
        END IF;
    END LOOP;

    v_cursor_name := DBMS_SQL.OPEN_CURSOR;

    IF it_line.COUNT > 0 THEN

        FOR i IN 1..it_line.COUNT
        LOOP

            Pkg_App_Tools.P_Log('L','DDL-->'||i||' linii-->'||TO_CHAR(it_line(i).COUNT),'SHOWLOG');

            BEGIN

                it_line(i)(it_line(i).COUNT+1)    :=  Pkg_Glb.C_LF;

                -- run the code
                DBMS_SQL.PARSE(
                                c               =>  v_cursor_name,
                                STATEMENT       =>  it_line(i),
                                lb              =>  1,
                                ub              =>  it_line(i).COUNT,
                                lfflg           =>  FALSE,
                                language_flag   =>  DBMS_SQL.NATIVE
                              );
                v_ret := DBMS_SQL.EXECUTE(v_cursor_name);
            EXCEPTION WHEN OTHERS THEN
                Pkg_App_Tools.P_Log('L','Eroare --> '||SQLCODE||' '||SQLERRM||Pkg_Glb.C_NL,'SHOWLOG');
            END;

        END LOOP;
    ELSE
        Pkg_Lib.p_rae('PATCH-ul este gol !!!');
    END IF;

    DBMS_SQL.CLOSE_CURSOR(v_cursor_name);

    v_row.status            :=  'S';
    Pkg_Iud.p_patch_header_iud('U', v_row);

    COMMIT;

    Pkg_App_Tools.P_Log('L','Succesfully PATCHED -->'||p_patch_code,'SHOWLOG');


EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/***********************************************************************************************
    DDL :   01/04/2008  d   Create
/***********************************************************************************************/
PROCEDURE p_insert_patch        (   p_patch_code    VARCHAR2, p_description VARCHAR2)
IS
    v_row                       PATCH_HEADER%ROWTYPE;
BEGIN

    -- if the path exists
    v_row.patch_code        :=  p_patch_code;
    IF Pkg_Get2.f_get_patch_header_2(v_row) THEN
        IF v_row.status = 'S' THEN
            Pkg_Lib.p_rae('Acest PATCH a fost DEJA executat !');
        ELSE
            DELETE FROM PATCH_DETAIL WHERE patch_code   =   p_patch_code;
        END IF;
    ELSE
        -- doesn't exist
        v_row.patch_code        :=  p_patch_code;
        v_row.status            :=  'I';
        v_row.description       :=  p_description;
        Pkg_Iud.p_patch_header_iud('I', v_row);
    END IF;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;

/***********************************************************************************************
    DDL :   01/04/2008  d   Create
/***********************************************************************************************/
PROCEDURE p_patch_header_iud    (   p_tip       VARCHAR2,
                                    p_row       PATCH_HEADER%ROWTYPE)
------------------------------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------
IS
    v_row_old                   PATCH_HEADER%ROWTYPE;
BEGIN

    Pkg_Iud.p_patch_header_iud(p_tip, p_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/***********************************************************************************************
    DDL :   01/04/2008  d   Create
/***********************************************************************************************/
PROCEDURE p_extract_package (   p_patch_code    VARCHAR2, p_package_name    VARCHAR2)
------------------------------------------------------------------------------------------------
--  PURPOSE:    run the PATCH --
--  PREREQ:     the patch details (code lines) must exist in PATCH_DETAIL
------------------------------------------------------------------------------------------------
IS

    CURSOR C_PACKAGE        (p_pkg_name     VARCHAR2, p_type VARCHAR2)
                            IS
                            SELECT      *
                            FROM        user_source     s
                            WHERE       NAME            =   p_pkg_name
                                AND     TYPE            =   p_type
                            ORDER BY    TYPE, LINE
                            ;

    CURSOR C_GET_DDL_SEQ    (p_patch_code   VARCHAR2)
                            IS
                            SELECT      MAX(ddl_seq)
                            FROM        PATCH_DETAIL
                            WHERE       patch_code      =   p_patch_code
                            ;

    v_ddl_seq               NUMBER  :=  0;
    it_patch                Pkg_Rtype.ta_patch_detail;
    v_idx                   INTEGER;

BEGIN

    OPEN C_GET_DDL_SEQ(p_patch_code); FETCH C_GET_DDL_SEQ INTO v_ddl_seq; CLOSE C_GET_DDL_SEQ;
    v_ddl_seq := NVL(v_ddl_seq,0) +1 ;

    FOR x IN C_PACKAGE      (p_package_name, 'PACKAGE')
    LOOP
        v_idx               :=  it_patch.COUNT+1;

        IF C_PACKAGE%rowcount = 1 THEN
            it_patch(v_idx).line_text    :=  'CREATE OR REPLACE '||x.text;
        ELSE
            it_patch(v_idx).line_text    :=  x.text;
        END IF;
        it_patch(v_idx).patch_code       :=  p_patch_code;
        it_patch(v_idx).source_object    :=  p_package_name;
        it_patch(v_idx).ddl_seq          :=  v_ddl_seq;
    END LOOP;
    v_idx                       :=  it_patch.COUNT;
    it_patch(v_idx+1)           :=  it_patch(v_idx);
    it_patch(v_idx+1).line_text :=  '/';

    FOR x IN C_PACKAGE      (p_package_name, 'PACKAGE BODY')
    LOOP
        v_idx               :=  it_patch.COUNT+1;

        IF C_PACKAGE%rowcount = 1 THEN
            it_patch(v_idx).line_text    :=  'CREATE OR REPLACE '||x.text;
        ELSE
            it_patch(v_idx).line_text    :=  x.text;
        END IF;
        it_patch(v_idx).patch_code       :=  p_patch_code;
        it_patch(v_idx).source_object    :=  p_package_name;
        it_patch(v_idx).ddl_seq          :=  v_ddl_seq + 1;
    END LOOP;
    v_idx                       :=  it_patch.COUNT;
    it_patch(v_idx+1)           :=  it_patch(v_idx);
    it_patch(v_idx+1).line_text :=  '/';

    Pkg_Iud.p_patch_detail_miud('I',it_patch);

    COMMIT;

END;


/***********************************************************************************************
    DDL :   10/04/2008  d   Create
/***********************************************************************************************/
PROCEDURE p_extract_script  (   p_patch_code    VARCHAR2, p_script_text    VARCHAR2)
------------------------------------------------------------------------------------------------
--  PURPOSE:    run the PATCH --
--  PREREQ:     the patch details (code lines) must exist in PATCH_DETAIL
------------------------------------------------------------------------------------------------
IS

    CURSOR C_TEXT           (p_sql_text                 VARCHAR2)
                            IS
                            SELECT  txt01   text
                            FROM    TABLE   (
                                            Pkg_Lib.F_Sql_Inlist(p_sql_text, CHR(10))
                                            )
                            ;

    CURSOR C_GET_DDL_SEQ    (p_patch_code   VARCHAR2)
                            IS
                            SELECT      MAX(ddl_seq)
                            FROM        PATCH_DETAIL
                            WHERE       patch_code      =   p_patch_code
                            ;

    v_ddl_seq               NUMBER  :=  0;
    it_patch                Pkg_Rtype.ta_patch_detail;
    v_idx                   INTEGER;

BEGIN

    OPEN C_GET_DDL_SEQ(p_patch_code); FETCH C_GET_DDL_SEQ INTO v_ddl_seq; CLOSE C_GET_DDL_SEQ;
    v_ddl_seq := NVL(v_ddl_seq,0) +1 ;

    FOR x IN C_TEXT      (p_script_text)
    LOOP
        v_idx                               :=  it_patch.COUNT+1;
        it_patch(v_idx).patch_code          :=  p_patch_code;
        it_patch(v_idx).source_object       :=  'SCRIPT';
        it_patch(v_idx).line_text           :=  x.text;
        it_patch(v_idx).ddl_seq             :=  v_ddl_seq;
    END LOOP;

    Pkg_Iud.p_patch_detail_miud('I',it_patch);

    COMMIT;

END;

/***********************************************************************************************
    DDL :   01/04/2008  d   Create
/***********************************************************************************************/
FUNCTION f_patch_info   (   p_patch_code    VARCHAR2)
                            RETURN          VARCHAR2
------------------------------------------------------------------------------------------------
--  PURPOSE:    return a string with info about the PATCH + path log
------------------------------------------------------------------------------------------------
IS
    CURSOR C_LOG        (p_audsid   VARCHAR2)
                        IS
                        SELECT      *
                        FROM        APP_LOG     l
                        WHERE       audsid      =   p_audsid
                            AND     msg_context =   'SHOWLOG'
                        ORDER BY    line_id DESC
                        ;

    v_row               PATCH_HEADER%ROWTYPE;
    v_result            VARCHAR2(2000);
    v_audsid            VARCHAR2(100);
BEGIN
    v_audsid            :=  SYS_CONTEXT('USERENV','SESSIONID');

    v_row.patch_code    :=  p_patch_code;
    IF NOT Pkg_Get2.f_get_patch_header_2(v_row) THEN
        v_result    :=  'Nu exista patch-ul '||p_patch_code||Pkg_Glb.C_NL;
    ELSE
        v_result    :=  v_row.description||Pkg_Glb.C_NL||Pkg_Glb.C_NL;
        IF v_row.status = 'S' THEN
            v_result    :=  v_result || 'Acest patch a fost rulat in '||v_row.datagg||Pkg_Glb.C_NL;
        END IF;

    END IF;

    FOR x IN C_LOG  (v_audsid)
    LOOP

        EXIT WHEN C_LOG%rowcount > 10;

        v_result    :=  v_result    ||  TO_CHAR(x.insert_date,'dd/mm/yyyy hh24:mi:ss')||' ';
        v_result    :=  v_result    ||  x.msg_text||Pkg_Glb.C_NL;

    END LOOP;

    RETURN v_result;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


END;

/

/
