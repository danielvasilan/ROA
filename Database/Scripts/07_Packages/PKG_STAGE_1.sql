--------------------------------------------------------
--  DDL for Package Body PKG_STAGE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_STAGE" 
AS
 
-----------------------------------------------------------------------------------------------
--  PURPOSE: THIS PACKAGE contains the logic for importing data from txt files
--
--  The STAGE tables    -   have the columns that can be read from txt files
--                      -   have a status   =   I initial
--                                              V validated
--                                              L loaded
--                                              E error
-----------------------------------------------------------------------------------------------
 
    FUNCTION f_item_code (p_item_code VARCHAR2) RETURN VARCHAR2
    IS
        v_res   VARCHAR2(30);
    BEGIN
        v_res   :=   REPLACE(
                        REGEXP_REPLACE(p_item_code, '[ ]+', ' ')
                        , ',', '.');
        RETURN v_res;
    END;
 
    FUNCTION f_transform_uom (   p_org_code  VARCHAR2, p_uom  VARCHAR2) RETURN VARCHAR2
    IS
        v_rez   VARCHAR2(50);
    BEGIN
        CASE    p_uom
            WHEN    'NR'    THEN    v_rez   :=  'PZ';
            WHEN    'NS'    THEN    v_rez   :=  'PZ';
            ELSE                    v_rez   :=  p_uom;
        END CASE;
        RETURN v_rez;
    END;
 

/**********************************************************************************************
    DDL:    16/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_import_file     (   p_dir       VARCHAR2,
                                p_filename  VARCHAR2,
                                p_org_code  VARCHAR2)
----------------------------------------------------------------------------------------------
--  PURPOSE:    import a file found in  DIR location in the IMPORT_TEXT_FILE table
----------------------------------------------------------------------------------------------
IS
    CURSOR  C_LINES         (   p_dir VARCHAR2, p_file_name VARCHAR2)
                            IS
                            SELECT  numb01      line_number,
                                    txt50       line_text
                            ---------------------------------------------------------------
                            FROM    TABLE(Pkg_Sys_Tools.f_sql_read_file(p_dir,p_file_name))
                            ;
 
    it_file                 Pkg_Rtype.ta_import_text_file;
    v_row_file              STG_FILE_MANAGER%ROWTYPE;
    v_idx                   INTEGER;

BEGIN
 
    -- INPUT parameters check
    IF p_dir IS NULL THEN Pkg_App_Tools.P_Log('M','Directorul sursa','Date lipsa:'); END IF;
    IF p_filename IS NULL THEN Pkg_App_Tools.P_Log('M','Numele fisierului','Date lipsa:'); END IF;
    IF p_org_code IS NULL THEN Pkg_App_Tools.P_Log('M','Clientul','Date lipsa:'); END IF;
 
    -- insert the imported file in the FILE_MANAGER table
    v_row_file.org_code             :=  p_org_code;
    v_row_file.file_name            :=  p_filename;
    v_row_file.file_name_original   :=  p_dir ||'/'||p_filename;
    v_row_file.file_date            :=  SYSDATE;
    v_row_file.flag_processed       :=  0;
    Pkg_Iud.p_stg_file_manager_iud('I', v_row_file, TRUE);
    v_row_file.idriga               :=  Pkg_Lib.f_read_pk;
 
    Pkg_App_Tools.P_Log('L', p_dir||p_filename, '');
 
    -- insert the file informations in IMPORT_TEXT_FILE table
    FOR x IN C_LINES(p_dir, p_filename)
    LOOP
 
/*        IF x.line_number = 1 THEN
            -- First line => useful for determine the file type (BOM, WO)
            IF x.line_text LIKE 'Priorita%' THEN
                v_row_file.file_info        :=  'WO';
            ELSIF x.line_text LIKE '%STAMPA RIEPILOGO CARTELLINI%' THEN
                v_row_file.file_info        :=  'WO';
                v_row_file.org_code         :=  'ALT';
            ELSIF   x.line_text LIKE '%PACKING%' 
                OR 
                    x.line_text like '%mod.fatture%' 
                OR
                    x.line_text LIKE '%Zeis Excelsa S.p.A.%'
                THEN     
                    v_row_file.file_info        :=  'REC';
            ELSIF UPPER(x.line_text) LIKE '%LANCIO PROD%' THEN
                v_row_file.org_code := 'RUC';
                v_row_file.file_info := 'BOM';
            ELSE
                --v_row_file.file_info        :=  'BOM';
                v_row_file.file_info := NULL;
            END IF;
            Pkg_Iud.p_stg_file_manager_iud('U',v_row_file,TRUE);
        END IF;
*/
        v_idx   :=  it_file.COUNT + 1;
        it_file(v_idx).file_name    := p_filename;
        it_file(v_idx).file_id      := v_row_file.idriga;
        it_file(v_idx).line_seq     := x.line_number;
        it_file(v_idx).line_text    := x.line_text;
        it_file(v_idx).org_code     := nvl(v_row_file.org_code, p_org_code);

    END LOOP;
    IF it_file.COUNT > 0 THEN
        Pkg_Iud.p_import_text_file_miud   ('I',it_file);
    END IF;
 
 
    COMMIT;

    -- if the file import successfully set the SBU and type => process it
    IF v_row_file.org_code IS NOT NULL AND v_row_file.file_info IS NOT NULL THEN 
        pkg_stage.p_process_file(v_row_file.idriga);
    END IF;
 
--EXCEPTION WHEN OTHERS THEN
--    ROLLBACK;
--    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
/**********************************************************************************************
    DDL:    16/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_process_bom     (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    process the file informations and loads them in intermediare tables
--              (STG_BOM, STG_ITEM)
-----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (p_file_id  NUMBER)
                    IS
                    SELECT      *
                    FROM        IMPORT_TEXT_FILE
                    ----------------------------------------------
                    WHERE       file_id             =   p_file_id
                        AND     line_seq            >   1
                    ORDER BY    line_seq
                    ;
 
    CURSOR C_EXPL   (p_line_text    VARCHAR2)
                    IS
                    SELECT  ROWNUM      col_seq,
                            txt01       col_text
                    -------------------------------------------------
                    FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_line_text,';', -1))
                    ;
 
    CURSOR C_EX_ITM_STG (p_org_code VARCHAR2, p_item_code VARCHAR2)
                        IS
                        SELECT      1
                        FROM        STG_ITEM    i
                        WHERE       org_code    =   p_org_code
                            AND     item_code   =   p_item_code
                        ;
 
    v_idx_bom       VARCHAR2(50);
    it_bom          Pkg_Rtype.tas_stg_bom_std;   -- stg_bom_std
    it_itm          Pkg_Rtype.tas_stg_item;      -- stg_item
    v_idx_itm       VARCHAR2(50);
    v_row_itm       STG_ITEM%ROWTYPE;
    it_line         Pkg_Glb.typ_string;
    it_fase         Pkg_Glb.typ_string;
    v_err           VARCHAR2(1000);
    v_found         BOOLEAN;
    v_test          PLS_INTEGER;
    v_row_fil       STG_FILE_MANAGER%ROWTYPE;
    it_exc          Pkg_Glb.typ_varchar_varchar;
    V_FLAG_RANGE    BOOLEAN;
    v_child_code    VARCHAR2(50);
 
    v_file_line_id number;
BEGIN
 
    it_fase (0)     :=  '';
    it_fase (10)    :=  'CROIT';
    it_fase (20)    :=  'CUSUT';
    it_fase (30)    :=  'TRAS';
 
    it_exc('FM')    :=  'S';
    it_exc('SL')    :=  'S';
 
 
    --  get the file row from STG_FILE_MANAGER ,
    --  verify if it was already loaded
    v_row_fil.idriga    :=  p_file_id;
    Pkg_Get.p_get_stg_file_manager(v_row_fil);
    IF v_row_fil.flag_processed = -1 THEN
        Pkg_Lib.p_rae('Fisierul cu id = '||p_file_id||' a mai fost procesat anterior!');
    END IF;
 
 
    FOR x IN C_LINES(p_file_id)
    LOOP
      v_file_line_id := x.idriga;
      
        it_line.DELETE;
        FOR xx IN C_EXPL (x.line_text)
        LOOP
            it_line(xx.col_seq)     :=  xx.col_text;
        END LOOP;
 
        -- exclude the lines for NOTE
        IF  (   Pkg_Lib.f_table_value(it_line, 13,'') LIKE 'ND%'
                AND 
                Pkg_Lib.f_table_value(it_line, 17, 0) = 0
            )
            OR
            (   /* exclude children with description of NOTE ... */
                Pkg_Lib.f_table_value(it_line, 15, '') like 'NOTE %'
            ) 
            THEN
            
            NULL;
 
        ELSE
 
            -- determine if the child is range controlled
            IF      Pkg_Lib.f_table_value(it_line, 14, '') IS NOT NULL
                AND NOT it_exc.EXISTS(SUBSTR(Pkg_Lib.f_table_value(it_line, 13,''),1,2))
            THEN
                v_flag_range    :=  TRUE;
                v_child_code    :=  f_item_code(
                                    Pkg_Lib.f_table_value(it_line, 13,'')||'.'||Pkg_Lib.f_table_value(it_line, 14,'??')
                                    );
            ELSE
                v_flag_range    :=  FALSE;
                v_child_code    :=  f_item_code(
                                    Pkg_Lib.f_table_value(it_line, 13,'?')
                                    );
            END IF;
 
            v_idx_bom       :=  Pkg_Lib.f_implode('$',Pkg_Lib.f_table_value(it_line, 4, ''), v_child_code);
 
            IF NOT it_bom.EXISTS(v_idx_bom) THEN
                it_bom(v_idx_bom).file_id       :=  p_file_id;
                it_bom(v_idx_bom).father_code   :=  f_item_code(Pkg_Lib.f_table_value(it_line, 4, ''));
                it_bom(v_idx_bom).child_code    :=  v_child_code;
                it_bom(v_idx_bom).qta           :=  ROUND(Pkg_Lib.f_table_value(it_line, 17, 0), 3);
                it_bom(v_idx_bom).colour_code   :=  NULL;
                it_bom(v_idx_bom).oper_code     :=  it_fase(Pkg_Lib.f_table_value(it_line, 11, 0));
                it_bom(v_idx_bom).qta_std       :=  it_bom(v_idx_bom).qta;
                it_bom(v_idx_bom).org_code      :=  x.org_code;
                it_bom(v_idx_bom).uom           :=  f_transform_uom(x.org_code,
                                                                    Pkg_Lib.f_table_value(it_line, 16, ''));
                it_bom(v_idx_bom).note          :=  RTRIM(
                                                    Pkg_Lib.f_table_value(it_line, 18, '')||Pkg_Glb.C_NL||
                                                    Pkg_Lib.f_table_value(it_line, 19, '')||Pkg_Glb.C_NL||
                                                    Pkg_Lib.f_table_value(it_line, 20, '')||Pkg_Glb.C_NL||
                                                    Pkg_Lib.f_table_value(it_line, 21, '')
                                                    ,CHR(13)||CHR(10));
                ELSE
                    -- if the item is already loaded in memory => only compute the media with the new value
                    it_bom(v_idx_bom).qta       :=  round((
                                                    it_bom(v_idx_bom).qta
                                                    +
                                                    Pkg_Lib.f_table_value(it_line, 17, 0)
                                                    ) / 2, 3) ;
 
                    it_bom(v_idx_bom).qta_std   :=  it_bom(v_idx_bom).qta;
 
                END IF;
 
            -- STG_ITEM
            --      FATHER
            v_idx_itm   :=  it_bom(v_idx_bom).father_code;
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                v_row_itm.org_code      :=  x.org_code;
                v_row_itm.item_code     :=  it_bom(v_idx_bom).father_code;
                v_row_itm.description   :=  NVL(Pkg_Lib.f_table_value(it_line, 6, 0), 'NULL');
                v_row_itm.puom          :=  'PA';
                v_row_itm.make_buy      :=  'P';
                v_row_itm.flag_size     :=  -1;
                v_row_itm.flag_colour   :=  0;
                v_row_itm.flag_range    :=  0;
                v_row_itm.start_size    :=  NULL;
                v_row_itm.end_size      :=  NULL;
                v_row_itm.oper_code     :=  NULL;
                v_row_itm.file_id       :=  p_file_id;
 
                it_itm(v_idx_itm)       :=  v_row_itm;
 
            END IF;
 
            --      CHILD
            v_idx_itm       :=  it_bom(v_idx_bom).child_code;
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                v_row_itm.org_code      :=  x.org_code;
                v_row_itm.item_code     :=  it_bom(v_idx_bom).child_code;
                v_row_itm.description   :=  NVL(Pkg_Lib.f_table_value(it_line, 15, 0), 'NULL');
                v_row_itm.puom          :=  f_transform_uom(x.org_code,Pkg_Lib.f_table_value(it_line, 16, 0));
                v_row_itm.make_buy      :=  'A';
                v_row_itm.flag_colour   :=  0;
                v_row_itm.oper_code     :=  it_bom(v_idx_bom).oper_code;
                v_row_itm.file_id       :=  p_file_id;
                v_row_itm.start_size    :=  NULL;
                v_row_itm.end_size      :=  NULL;
 
                IF v_flag_range THEN
                    v_row_itm.flag_range    :=  -1;
                    v_row_itm.start_size    :=  Pkg_Lib.f_table_value(it_line, 5, NULL);
                    v_row_itm.end_size      :=   Pkg_Lib.f_table_value(it_line, 5, NULL);
                    v_row_itm.flag_size     :=  0;
                ELSIF Pkg_Lib.f_table_value(it_line, 14, NULL) IS NOT NULL THEN
                    v_row_itm.flag_range    :=  0;
                    v_row_itm.flag_size     :=  -1;
                ELSE
                    v_row_itm.flag_range    :=  0;
                    v_row_itm.flag_size     :=  0;
                END IF;
 
                -- load in memory
                it_itm(v_idx_itm)       :=  v_row_itm;
            END IF;
 
            -- if the child is range controlled, modify its start-end limits
            IF v_flag_range  THEN
                IF Pkg_Lib.f_table_value(it_line, 5, '99') < it_itm(v_idx_itm).start_size THEN
                    it_itm(v_idx_itm).start_size    :=  Pkg_Lib.f_table_value(it_line, 5, '??');
                END IF;
                IF Pkg_Lib.f_table_value(it_line, 5, '00') > it_itm(v_idx_itm).end_size THEN
                    it_itm(v_idx_itm).end_size      :=  Pkg_Lib.f_table_value(it_line, 5, '??');
                END IF;
            END IF;
 
        END IF; -- exclude ND
 
    END LOOP;
 
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert in STG_BOM
    v_idx_bom   :=  it_bom.FIRST;
    WHILE v_idx_bom IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_bom_std_iud('I', it_bom(v_idx_bom));
        v_idx_bom       :=  it_bom.NEXT(v_idx_bom);
    END LOOP;
 
    -- update the file status to processed
    v_row_fil.flag_processed    :=  -1;
    Pkg_Iud.p_stg_file_manager_iud('U', v_row_fil);
 
    COMMIT;
 
    -- try to VALIDATE
    Pkg_Stage.p_validate_bom    (p_file_id);
    Pkg_Stage.p_validate_item   (p_file_id);
 
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM||' - '||to_char(v_file_line_id)||nvl(v_idx_bom, '#')||nvl(v_idx_itm,'@')));
END;
 
 
/**********************************************************************************************
    DDL:    17/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_validate_bom        (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    validate the data in STG_BOM
-----------------------------------------------------------------------------------------------
IS
    -- returns the lines for which exists a standard bom in production
    CURSOR C_CHK_EX_BOM (           p_org_code          VARCHAR2,
                                    p_father_code       VARCHAR2,
                                    p_child_code        VARCHAR2
                        )
                        IS
                        SELECT      s.child_code
                        FROM        BOM_STD         s
                        WHERE       s.org_code      =   p_org_code
                            AND     s.father_code   =   p_father_code
                            AND     s.child_code    =   p_child_code
                        UNION ALL
                        SELECT      s.child_code
                        FROM        BOM_STD         s
                        WHERE       s.org_code      =   p_org_code
                            AND     s.father_code   =   p_father_code
                        ;
 
    CURSOR C_UM         IS
                        SELECT      *
                        FROM        PRIMARY_UOM
                        ;
 
    CURSOR C_LINES      (           p_file_id           NUMBER)
                        IS
                        SELECT      *
                        FROM        STG_BOM_STD         sb
                        WHERE       sb.file_id          =   p_file_id
                            AND     sb.stg_status       <>  'L'
                        ;
 
    v_row               STG_BOM_STD%ROWTYPE;
    it_um               Pkg_Glb.typ_varchar_varchar;
    v_found             BOOLEAN;
    v_child_code        VARCHAR2(50);
 
BEGIN
 
    FOR x IN C_UM
    LOOP
        it_um(x.puom)   :=  x.description;
    END LOOP;
 
    DELETE FROM STG_BOM_STD WHERE file_id = p_file_id AND QTA = 0;
 
    FOR x IN C_LINES (p_file_id)
    LOOP
        v_row               :=  x;
 
        -- not guilty presumption :-)
        v_row.stg_status    :=  'V';
        v_row.error_log     :=  NULL;
 
        -- check if the BOM already exists
        OPEN    C_CHK_EX_BOM    (x.org_code, x.father_code, x.child_code);
        FETCH   C_CHK_EX_BOM    INTO v_child_code;
        v_found :=  C_CHK_EX_BOM%FOUND;
        CLOSE   C_CHK_EX_BOM;
        IF v_found  THEN
            v_row.error_log     :=  'Exista!';
            IF v_child_code <> x.child_code THEN
                v_row.error_log     :=  v_row.error_log||' NU exista mat !';
            END IF;
        END IF;
 
        -- check if the UM is defined in the system
        IF NOT it_um.EXISTS(x.uom) THEN
            v_row.error_log   :=  v_row.error_log || ' UM nec';
        END IF;
 
        -- valid
        IF v_row.error_log IS NULL THEN
            v_row.stg_status    := 'V';
        ELSE
            v_row.stg_status    :=  'E';
        END IF;
 
        Pkg_Iud.p_stg_bom_std_iud('U', v_row);
    END LOOP;
 
    -- put the status on E on the records that contain errors at child level
    UPDATE  STG_BOM_STD a
    SET     stg_status  =   'E'
    WHERE   file_id     =   p_file_id
        AND stg_status  =   'V'
        AND EXISTS (SELECT  1
                    FROM    STG_BOM_STD     b
                    WHERE   b.file_id       =   a.file_id
                        AND b.father_code   =   a.father_code
                        AND b.stg_status    =   'E')
    ;
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
 
/**********************************************************************************************
    DDL:    21/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_validate_item        (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    validate the data in STG_ITEM
-----------------------------------------------------------------------------------------------
IS
    -- returns the lines for which exists a standard bom in production
    CURSOR C_CHK_EX_ITM (           p_org_code          VARCHAR2,
                                    p_item_code         VARCHAR2
                        )
                        IS
                        SELECT  1
                        FROM    ITEM            i
                        WHERE   i.org_code      =   p_org_code
                            AND i.item_code     =   p_item_code
                        ;
 
    CURSOR C_UM         IS
                        SELECT      *
                        FROM        PRIMARY_UOM
                        ;
 
    CURSOR C_LINES      (           p_file_id           NUMBER)
                        IS
                        SELECT      *
                        FROM        STG_ITEM            si
                        WHERE       si.file_id          =   p_file_id
                            AND     si.stg_status       <>  'L'
                        ;
 
    v_row               STG_ITEM%ROWTYPE;
    it_um               Pkg_Glb.typ_varchar_varchar;
    v_found             BOOLEAN;
    v_test              PLS_INTEGER;
 
BEGIN
 
    -- load the system UM in a PL/SQL table
    FOR x IN C_UM
    LOOP
        it_um(x.puom)   :=  x.description;
    END LOOP;
 
    DELETE FROM STG_ITEM WHERE file_id = p_file_id AND DESCRIPTION LIKE 'NOTE %';
 
    UPDATE STG_ITEM set item_code = REGEXP_REPLACE(item_code, '[ ]+', ' ')
    WHERE file_id = p_file_id;
 
    -- cycle on the unloaded lines
    FOR x IN C_LINES (p_file_id)
    LOOP
        v_row               :=  x;
 
        -- set the status to Validated, will be changed if errors found, else remain validated
        v_row.stg_status    :=  'V';
        v_row.error_log     :=  NULL;
 
        -- check if itel already exists in ITEM table
        OPEN    C_CHK_EX_ITM(x.org_code,x.item_code);
        FETCH   C_CHK_EX_ITM INTO v_test;
        v_found :=  C_CHK_EX_ITM%FOUND;
        CLOSE   C_CHK_EX_ITM;
        IF v_found THEN
            v_row.stg_status    :=  'E';
            v_row.error_log     :=  'Exista !';
        END IF;
 
        -- check if the UM is defined in the system
        IF NOT it_um.EXISTS(x.puom) THEN
            v_row.stg_status        :=  'E';
            v_row.error_log         :=  v_row.error_log || ' UM necun';
        END IF;
 
        Pkg_Iud.p_stg_item_iud('U', v_row);
    END LOOP;
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
/**********************************************************************************************
    DDL:    21/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_validate_wo         (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    validate the data in STG_WORK_ORDER
-----------------------------------------------------------------------------------------------
IS
    -- returns the lines for which exists a standard bom in production
    CURSOR C_CHK_EX_WO  (           p_org_code          VARCHAR2,
                                    p_order_code        VARCHAR2,
                                    p_size_code         VARCHAR2)
                        IS
                        SELECT      o.order_code        ,
                                    d.size_code
                        --------------------------------------------------------------------------
                        FROM        WORK_ORDER          o
                        LEFT JOIN   WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                                                            AND d.size_code     =   p_size_code
                        --------------------------------------------------------------------------
                        WHERE       o.org_code          =   p_org_code
                            AND     o.order_code        =   p_order_code
                        ;
 
    CURSOR C_LINES      (           p_file_id           NUMBER)
                        IS
                        SELECT      *
                        FROM        STG_WORK_ORDER      so
                        WHERE       so.file_id          =   p_file_id
                            AND     so.stg_status       <>  'L'
                        ;
 
    v_row               STG_WORK_ORDER%ROWTYPE;
    v_row_chk           C_CHK_EX_WO%ROWTYPE;
    v_found             BOOLEAN;
 
BEGIN
 
    FOR x IN C_LINES    (p_file_id)
    LOOP
        -- check cursor
        OPEN    C_CHK_EX_WO(x.org_code, x.order_code, x.size_code);
        FETCH   C_CHK_EX_WO INTO v_row_chk;
        v_found :=  C_CHK_EX_WO%FOUND;
        CLOSE   C_CHK_EX_WO;
 
        v_row               :=  x;
 
        IF v_found THEN
            IF v_row_chk.size_code IS NULL THEN
                v_row.stg_status    :=  'E';
                v_row.error_log     :=  'Exista WO!Nu exista Marimea!';
            ELSE
                v_row.stg_status    :=  'E';
                v_row.error_log     :=  'Exista WO!';
            END IF;
        ELSE
            v_row.stg_status    :=  'V';
            v_row.error_log     :=  NULL;
        END IF;
 
        Pkg_Iud.p_stg_work_order_iud('U', v_row);
    END LOOP;
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
/**********************************************************************************************
    DDL:    22/10/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_validate_receipt        (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    validate the data in STG_RECEIPT
-----------------------------------------------------------------------------------------------
IS
 
    CURSOR C_UM         IS
                        SELECT      *
                        FROM        PRIMARY_UOM
                        ;
 
    CURSOR C_LINES      (           p_file_id           NUMBER)
                        IS
                        SELECT      *
                        FROM        STG_RECEIPT         s
                        WHERE       s.file_id           =   p_file_id
                            AND     s.stg_status        <>  'L'
                        ;
 
    v_row               STG_RECEIPT%ROWTYPE;
    it_um               Pkg_Glb.typ_varchar_varchar;
    v_found             BOOLEAN;
    v_test              PLS_INTEGER;
 
BEGIN
 
    -- load the system UM in a PL/SQL table
    FOR x IN C_UM
    LOOP
        it_um(x.puom)   :=  x.description;
    END LOOP;
 
    UPDATE STG_RECEIPT set item_code = REGEXP_REPLACE(item_code, '[ ]+', ' ')
    WHERE file_id = p_file_id;
 
 
    -- cycle on the unloaded lines
    FOR x IN C_LINES (p_file_id)
    LOOP
        v_row               :=  x;
 
        -- set the status to Validated, will be changed if errors found, else remain validated
        v_row.stg_status    :=  'V';
        v_row.error_log     :=  NULL;
 
        IF v_row.item_code IS NULL THEN
            v_row.stg_status    :=  'E';
            v_row.error_log     :=  '?Cod?';
        END IF;
 
        -- check if the UM is defined in the system
        IF NOT it_um.EXISTS(x.uom_receipt) THEN
            v_row.stg_status        :=  'E';
            v_row.error_log         :=  v_row.error_log || ' UM necun';
        END IF;
 
        Pkg_Iud.p_stg_receipt_iud('U', v_row);
    END LOOP;
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


PROCEDURE p_validate_ship_fifo (p_file_id NUMBER)
IS
BEGIN
    
    Pkg_Stage_ROA.p_validate_ship_fifo(p_file_id);
    
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;

PROCEDURE p_validate_wo_decl (p_file_id NUMBER)
IS
BEGIN
    
    Pkg_Stage_ROA.p_validate_wo_decl(p_file_id);
    
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
FUNCTION f_sql_stg_filelist   (p_org_code varchar2, p_file_type varchar2)      RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINII
        IS
        SELECT      f.*
        FROM        STG_FILE_MANAGER f
        WHERE       org_code like NVL(p_org_code, '%')
            AND     NVL(file_info, ' ') like NVL(p_file_type, '%')
        ORDER BY    idriga DESC
        ;
 
    v_row      tmp_frm := tmp_frm();
 
BEGIN
 
    FOR X IN C_LINII LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
 
        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.file_name;
        v_row.txt03     :=  x.file_name_original;
        v_row.txt04     :=  x.file_info;
        v_row.numb01    :=  x.idriga;
        v_row.numb02    :=  x.flag_processed;
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END;

FUNCTION f_sql_stg_parser         RETURN typ_longinfo  pipelined
IS
    CURSOR     C_LINES     
        IS
        SELECT      s.*
        FROM        STG_PARSER s
        ORDER BY    file_Info, idriga
        ;
 
    v_row      tmp_longinfo := tmp_longinfo();
 
BEGIN
 
    FOR X IN C_LINES LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
 
        v_row.txt01     :=  x.file_info;
        v_row.txt02     :=  x.status;
        v_row.txt03     :=  'description-'||x.status;
        
        v_row.txt49     :=  x.stmt_text;
        v_row.numb01    :=  length(x.stmt_text);
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END; 
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
FUNCTION f_sql_stg_fileline     (p_file_id  NUMBER)         RETURN typ_longinfo  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINES      IS
                            SELECT      *
                            FROM        IMPORT_TEXT_FILE
                            WHERE       file_id             =   p_file_id
                            ORDER BY    line_seq
                            ;
 
    v_row      tmp_longinfo := tmp_longinfo();
 
BEGIN
 
    FOR X IN C_LINES LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;
 
        v_row.txt50     :=  x.line_text;
        v_row.numb01    :=  x.file_id;
        v_row.numb02    :=  x.line_seq;
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END;
 
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
FUNCTION f_sql_stg_bomstd     (p_file_id  NUMBER)         RETURN typ_longinfo  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
 
    CURSOR     C_LINES      IS
                            SELECT      sb.*,
                                        i1.description      i1_description,
                                        i2.description      i2_description,
                                        s1.description      s1_description,
                                        s2.description      s2_description
                            -----------------------------------------------------------------------------
                            FROM        STG_BOM_STD         sb
                            LEFT JOIN   ITEM                i1  ON  i1.org_code     =   sb.org_code
                                                                AND i1.item_code    =   sb.father_code
                            LEFT JOIN   ITEM                i2  ON  i2.org_code     =   sb.org_code
                                                                AND i2.item_code    =   sb.child_code
                            LEFT JOIN   STG_ITEM            s1  ON  s1.file_id      =   sb.file_id
                                                                AND s1.org_code     =   sb.org_code
                                                                AND s1.item_code    =   sb.father_code
                            LEFT JOIN   STG_ITEM            s2  ON  s2.file_id      =   sb.file_id
                                                                AND s2.org_code     =   sb.org_code
                                                                AND s2.item_code    =   sb.child_code
                            -----------------------------------------------------------------------------
                            WHERE       sb.file_id          =   p_file_id
                            ORDER BY    father_code, child_code
                            ;
 
    v_row      tmp_longinfo := tmp_longinfo();
 
BEGIN
 
    FOR X IN C_LINES LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
 
        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.father_code;
        v_row.txt03     :=  x.child_code;
        v_row.txt04     :=  x.error_log;
        v_row.txt05     :=  NVL(x.i1_description, x.s1_description);
        v_row.txt06     :=  NVL(x.i2_description, x.s2_description);
        v_row.txt07     :=  x.start_size;
        v_row.txt08     :=  x.end_size;
        v_row.txt09     :=  x.oper_code;
        v_row.txt10     :=  x.uom;
        v_row.txt11     :=  x.colour_code;
        v_row.txt12     :=  x.stg_status;
        v_row.txt13     :=  x.note;
        v_row.numb01    :=  x.qta;
        v_row.numb02    :=  x.qta_std;
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END;
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
FUNCTION f_sql_stg_item         (p_file_id  NUMBER)         RETURN typ_longinfo  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
 
    CURSOR     C_LINES      IS
                            SELECT      si.*
                            -----------------------------------------------------------------------------
                            FROM        STG_ITEM         si
                            -----------------------------------------------------------------------------
                            WHERE       file_id             =   p_file_id
                            ORDER BY    item_code
                            ;
 
    v_row      tmp_longinfo := tmp_longinfo();
 
BEGIN
 
    FOR X IN C_LINES LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
 
        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.item_code;
        v_row.txt03     :=  x.description;
        v_row.txt04     :=  x.error_log;
        v_row.txt05     :=  x.puom;
        v_row.txt06     :=  x.make_buy;
        v_row.txt07     :=  x.start_size;
        v_row.txt08     :=  x.end_size;
        v_row.txt09     :=  x.oper_code;
        v_row.txt10     :=  x.stg_status;
        v_row.txt11     :=  x.root_code;
        v_row.numb01    :=  x.file_id;
        v_row.numb02    :=  x.flag_size;
        v_row.numb03    :=  x.flag_range;
        v_row.numb04    :=  x.flag_colour;
        
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END;
 
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
FUNCTION f_sql_stg_receipt  (p_file_id  NUMBER)         RETURN typ_longinfo  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for STG_RECEIPT subform
----------------------------------------------------------------------------------------------
IS
 
    CURSOR     C_LINES      
        IS
        SELECT      s.*,
                    NVL(si.description, i.description) i_description
        -----------------------------------------------------------------------------
        FROM        STG_RECEIPT         s
        LEFT JOIN   ITEM                i   ON  i.org_code  =   s.org_code
                                            AND i.item_code =   s.item_code
        LEFT JOIN   STG_ITEM            si  ON si.file_id   =   p_file_id
                                            AND si.org_code =   s.org_code
                                            AND si.item_code=   s.item_code
        -----------------------------------------------------------------------------
        WHERE       s.file_id           =   p_file_id
        order by s.line_no
        ;
 
    v_row      tmp_longinfo := tmp_longinfo();
 
BEGIN
 
    FOR X IN C_LINES
    LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
 
        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.stg_status;
        v_row.txt03     :=  x.error_log;
        v_row.txt04     :=  x.receipt_type;
        v_row.txt05     :=  x.doc_number;
        v_row.txt06     :=  x.currency_code;
        v_row.txt07     :=  x.country_from;
        v_row.txt08     :=  x.item_code;
        v_row.txt09     :=  x.season_code;
        v_row.txt10     :=  x.colour_code;
        v_row.txt11     :=  x.size_code;
        v_row.txt12     :=  x.oper_code_item;
        v_row.txt13     :=  x.uom_receipt;
        v_row.txt14     :=  x.i_description;
 
        v_row.numb01    :=  x.file_id;
        v_row.numb02    :=  x.qty_doc;
        v_row.numb03    :=  x.unit_price;
        v_row.numb04    :=  x.line_no;
        v_row.data01    :=  x.doc_date;
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END;

/*********************************************************************************************
    09/04/2016  d   Create
/*********************************************************************************************/
FUNCTION f_sql_stg_ship_fifo (p_file_id  NUMBER) RETURN typ_longinfo  pipelined
IS
 
    CURSOR C_LINES      
        IS
        SELECT      s.*, i.description, i.puom, 
                    f.tot_qty_rec_fifo, f.cnt_rec
        -----------------------------------------------------------------------------
        FROM        STG_SHIP_FIFO       s
        LEFT JOIN   ITEM                i   ON  i.org_code  =   s.org_code
                                            AND i.item_code =   s.item_code
        LEFT JOIN 
            (
                select org_code, item_code, 
                    sum(qty_doc_puom) tot_qty_rec_fifo, count(1) cnt_rec
                from v_fifo_rec
                where qty_doc_puom > qty_fifo
                group by org_code, item_code
            ) f 
                ON f.org_code = s.org_code
                AND f.item_code = s.item_code
        -----------------------------------------------------------------------------
        WHERE       s.file_id             =   p_file_id
        ORDER BY    s.item_code
        ;
 
    v_row      tmp_longinfo := tmp_longinfo();
 
BEGIN
 
    FOR X IN C_LINES LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
 
        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.item_code;
        v_row.txt03     :=  x.description;
        v_row.txt04     :=  x.error_log;
        v_row.txt05     :=  x.puom;
        v_row.txt06     :=  x.ship_subcat;
        v_row.txt10     :=  x.stg_status;
        v_row.numb01    :=  x.file_id;
        v_row.numb02    :=  x.qty;
        v_row.numb03    :=  x.tot_qty_rec_fifo;
        v_row.numb04    :=  x.cnt_rec;
        v_row.data01    :=  x.ship_date;
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END;

/*********************************************************************************************
    09/04/2016  d   Create
/*********************************************************************************************/
FUNCTION f_sql_stg_wo_decl (p_file_id  NUMBER) RETURN typ_longinfo  pipelined
IS
 
    CURSOR     C_LINES      (           p_file_id       NUMBER)
                            IS
                            SELECT      o.org_code, o.wo_code, wo.item_code, wo.season_code,
                                        i.description   i_description,
                                        o.operation     ,
                                        --o.size_code     ,
                                        o.qty           ,
                                        o.package_number,
                                        o.decl_date     ,
                                        o.idriga        ,
                                        o.dcn           ,
                                        o.error_log     ,
                                        o.stg_status
                            ----------------------------------------------------------------------
                            FROM        STG_WO_DECL     o
                            LEFT JOIN   work_order      wo  ON  wo.org_code     =   o.org_code
                                                            AND wo.order_code   =   o.wo_code
                            LEFT JOIN   ITEM            i   ON  i.org_code      =   wo.org_code
                                                            AND i.item_code     =   wo.item_code
                            ----------------------------------------------------------------------
                            WHERE       o.file_id       =   p_file_id
                            ----------------------------------------------------------------------
                            ORDER BY    o.idriga
                            ;
 
    v_row      tmp_longinfo := tmp_longinfo();
 
BEGIN
 
    FOR X IN C_LINES(p_file_id)
    LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;
 
        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.wo_code;
        v_row.txt03     :=  x.item_code;
        v_row.txt04     :=  x.error_log;
        v_row.txt05     :=  x.i_description;
        v_row.txt06     :=  'X';--x.size_code;
        v_row.txt07     :=  x.season_code;
        v_row.txt08     :=  x.stg_status;
        v_row.txt09     :=  x.operation;
        v_row.numb01    :=  p_file_id;
        v_row.numb02    :=  x.qty;
        v_row.numb03    :=  x.package_number;
        v_row.data01    :=  x.decl_date;
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END;
 

 
/**********************************************************************************************
    DDL:    16/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_process_WO      (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    process the file informations and loads them in intermediare tables
--              (STG_BOM, STG_ITEM)
-----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (p_file_id  NUMBER)
                    IS
                    SELECT      *
                    FROM        IMPORT_TEXT_FILE
                    ----------------------------------------------
                    WHERE       file_id             =   p_file_id
                        AND     line_seq            >   1
                    ORDER BY    line_seq
                    ;
 
    CURSOR C_EXPL   (p_line_text    VARCHAR2)
                    IS
                    SELECT  ROWNUM      col_seq,
                            txt01       col_text
                    -------------------------------------------------
                    FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_line_text,';', -1))
                    ;
 
 
    it_wo           Pkg_Rtype.ta_stg_work_order;    -- stg_work_order
    v_idx_wo        INTEGER;
 
    v_row_itm       STG_ITEM%ROWTYPE;
    it_itm          Pkg_Rtype.tas_stg_item;
    v_idx_itm       VARCHAR2(50);
 
    it_line         Pkg_Glb.typ_string;
    v_row_fil       STG_FILE_MANAGER%ROWTYPE;
    v_err           VARCHAR2(1000);
    v_found         BOOLEAN;
    v_test          PLS_INTEGER;
 
BEGIN
 
    --  get the file row from STG_FILE_MANAGER ,
    --  verify if it was already loaded
    v_row_fil.idriga    :=  p_file_id;
    Pkg_Get.p_get_stg_file_manager(v_row_fil);
    IF v_row_fil.flag_processed = -1 THEN
        Pkg_Lib.p_rae('Fisierul cu id = '||p_file_id||' a mai fost procesat anterior!');
    END IF;
 
 
    FOR x IN C_LINES(p_file_id)
    LOOP
        it_line.DELETE;
        FOR xx IN C_EXPL (x.line_text)
        LOOP
            it_line(xx.col_seq)     :=  xx.col_text;
        END LOOP;
 
        v_idx_wo                        :=  it_wo.COUNT;
 
        IF     NOT it_wo.EXISTS(v_idx_wo)
            OR Pkg_Lib.f_mod_c(it_wo(v_idx_wo).order_code, Pkg_Lib.f_table_value(it_line, 5, ''))
        THEN
 
            -- insert the ITEM , if not present in STG_ITEM
            v_idx_itm   :=    Pkg_Lib.f_table_value(it_line, 10, '');
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                it_itm(v_idx_itm).org_code      :=  x.org_code;
                it_itm(v_idx_itm).item_code     :=  f_item_code(Pkg_Lib.f_table_value(it_line, 10, ''));
                it_itm(v_idx_itm).description   :=  Pkg_Lib.f_table_value(it_line, 11, 0);
                it_itm(v_idx_itm).puom          :=  'PA';
                it_itm(v_idx_itm).make_buy      :=  'P';
                it_itm(v_idx_itm).flag_size     :=  -1;
                it_itm(v_idx_itm).flag_colour   :=  0;
                it_itm(v_idx_itm).flag_range    :=  0;
                it_itm(v_idx_itm).start_size    :=  NULL;
                it_itm(v_idx_itm).end_size      :=  NULL;
                it_itm(v_idx_itm).oper_code     :=  NULL;
                it_itm(v_idx_itm).file_id       :=  p_file_id;
            END IF;
 
        END IF;
 
        -- work order
        v_idx_wo                        :=  it_wo.COUNT + 1;
        it_wo(v_idx_wo).file_id         :=  p_file_id;
        it_wo(v_idx_wo).org_code        :=  x.org_code;
        it_wo(v_idx_wo).order_code      :=  Pkg_Lib.f_table_value(it_line, 5, '');
        it_wo(v_idx_wo).item_code       :=  f_item_code(Pkg_Lib.f_table_value(it_line, 10, ''));
        it_wo(v_idx_wo).season_code     :=  Pkg_Lib.f_table_value(it_line, 2, '');
        it_wo(v_idx_wo).size_code       :=  Pkg_Lib.f_table_value(it_line, 12, '');
        it_wo(v_idx_wo).qty             :=  Pkg_Lib.f_table_value(it_line, 13, '');
        it_wo(v_idx_wo).client_lot      :=  Pkg_Lib.f_table_value(it_line, 1, '');
 
    END LOOP;
 
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert int STG_WORK_ORDER
    IF it_wo.COUNT  > 0 THEN    Pkg_Iud.p_stg_work_order_miud   ('I',   it_wo); END IF;
 
    -- update the file status to processed
    v_row_fil.flag_processed    :=  -1;
    Pkg_Iud.p_stg_file_manager_iud('U', v_row_fil);
 
    COMMIT;
 
    -- try to VALIDATE
    Pkg_Stage.p_validate_wo     (p_file_id);
    Pkg_Stage.p_validate_item   (p_file_id);
 
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
/**********************************************************************************************
    DDL:    22/10/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_process_rec      (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    process the file informations and loads them in intermediare tables
--              (STG_BOM, STG_ITEM)
-----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (p_file_id  NUMBER)
                    IS
                    SELECT      *
                    FROM        IMPORT_TEXT_FILE
                    ----------------------------------------------
                    WHERE       file_id             =   p_file_id
                        AND     line_seq            >   1
                    ORDER BY    line_seq
                    ;
 
    CURSOR C_EXPL   (p_line_text    VARCHAR2)
                    IS
                    SELECT  ROWNUM      col_seq,
                            txt01       col_text
                    -------------------------------------------------
                    FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_line_text,CHR(9), -1))
                    ;
 
    CURSOR C_SEA    (p_org_code VARCHAR2)
                    IS
                    SELECT      *
                    FROM        WORK_SEASON
                    WHERE       org_code            =   p_org_code
                        AND     NVL(flag_active,'Y')=   'Y'
                    ORDER BY    season_code DESC
                    ;
 
    it_rec          Pkg_Rtype.ta_stg_receipt;
    v_idx_rec       INTEGER;
 
    v_row_itm       STG_ITEM%ROWTYPE;
    it_itm          Pkg_Rtype.tas_stg_item;
    v_idx_itm       VARCHAR2(50);
 
    v_row_sea       WORK_SEASON%ROWTYPE;
    it_line         Pkg_Glb.typ_string;
    v_row_fil       STG_FILE_MANAGER%ROWTYPE;
    v_err           VARCHAR2(1000);
    v_found         BOOLEAN;
    v_test          PLS_INTEGER;
    v_found_hdr     BOOLEAN; -- found table header -> lines follow
    it_exc          Pkg_Glb.typ_varchar_varchar;
 
    v_doc_number    VARCHAR2(50);
    v_doc_date      DATE;
    v_currency_code VARCHAR2(10);
    v_country_from  VARCHAR2(10);
    v_item_code     VARCHAR2(30);
    v_flag_size     INTEGER;
    v_flag_range    INTEGER;
 
BEGIN
 
    --  get the file row from STG_FILE_MANAGER ,
    --  verify if it was already loaded
    v_row_fil.idriga    :=  p_file_id;
    Pkg_Get.p_get_stg_file_manager(v_row_fil);
    IF v_row_fil.flag_processed = -1 THEN
        Pkg_Lib.p_rae('Fisierul cu id = '||p_file_id||' a mai fost procesat anterior!');
    END IF;
 
    -- get the last active season code for ORG
    OPEN    C_SEA(v_row_fil.org_code);
    FETCH   C_SEA INTO v_row_sea;
    CLOSE   C_SEA;
 
    -- DEFAULTS
    v_currency_code     :=  'EUR';
    v_country_from      :=  'IT';
 
    it_exc('FM')    :=  'S';
    it_exc('SL')    :=  'S';
 
 
    v_found_hdr     :=  FALSE;
    FOR x IN C_LINES(p_file_id)
    LOOP
        it_line.DELETE;
        FOR xx IN C_EXPL (x.line_text)
        LOOP
            it_line(xx.col_seq)     :=  xx.col_text;
        END LOOP;
 
        -- only after header was found
        IF v_found_hdr AND Pkg_Lib.f_table_value(it_line, 4, '') IS NOT NULL THEN
 
            v_item_code := f_item_code(Pkg_Lib.f_table_value(it_line, 4, ''));
            IF Pkg_Lib.f_table_value(it_line, 6, '') IS NOT NULL THEN
                    IF NOT it_exc.EXISTS(SUBSTR(v_item_code,1,2)) THEN
                        v_flag_range    :=  -1;
                        v_flag_size     :=  0;
                        v_item_code                     :=  v_item_code||'.'||Pkg_Lib.f_table_value(it_line, 6, '');
                    ELSE
                        v_flag_size     :=  -1;
                        v_flag_range    :=  0;
                    END IF;
            ELSE
                    v_flag_range    :=  0;
                    v_flag_size     :=  0;
            END IF;
 
            -- insert the ITEM , if not present in STG_ITEM
            v_idx_itm   :=    v_item_code;
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                it_itm(v_idx_itm).org_code      :=  x.org_code;
 
                it_itm(v_idx_itm).description   :=  Pkg_Lib.f_table_value(it_line, 5, '');
                it_itm(v_idx_itm).puom          :=  Pkg_Lib.f_table_value(it_line, 7, '');
                it_itm(v_idx_itm).make_buy      :=  'A';
                it_itm(v_idx_itm).flag_range    :=  v_flag_range;
                it_itm(v_idx_itm).flag_size     :=  v_flag_size;
                it_itm(v_idx_itm).flag_colour   :=  0;
                it_itm(v_idx_itm).start_size    :=  NULL;
                it_itm(v_idx_itm).end_size      :=  NULL;
                it_itm(v_idx_itm).oper_code     :=  NULL;
                it_itm(v_idx_itm).item_code     :=  v_item_code;
                it_itm(v_idx_itm).file_id       :=  p_file_id;
            END IF;
 
            -- RECEIPT DATA
            v_idx_rec                           :=  it_rec.COUNT + 1;
            it_rec(v_idx_rec).file_id           :=  p_file_id;
            it_rec(v_idx_rec).org_code          :=  x.org_code;
            it_rec(v_idx_rec).receipt_type      :=  'ME1';
            it_rec(v_idx_rec).doc_number        :=  v_doc_number;
            it_rec(v_idx_rec).doc_date          :=  v_doc_date;
            it_rec(v_idx_rec).currency_code     :=  v_currency_code;
            it_rec(v_idx_rec).country_from      :=  v_country_from;
            it_rec(v_idx_rec).item_code         :=  v_item_code;
            it_rec(v_idx_rec).season_code       :=  v_row_sea.season_code;
            it_rec(v_idx_rec).colour_code       :=  NULL;
            IF v_flag_size = -1 THEN
                it_rec(v_idx_rec).size_code         :=  Pkg_Lib.f_table_value(it_line, 6, '');
            ELSE
                it_rec(v_idx_rec).size_code         :=  NULL;
            END IF;
            it_rec(v_idx_rec).oper_code_item    :=  NULL;
            it_rec(v_idx_rec).uom_receipt        :=  Pkg_Lib.f_table_value(it_line, 7, '');
 
 
            Pkg_App_Tools.P_Log('L',Pkg_Lib.f_table_value(it_line, 11, 0),'QTY DOC');
 
            it_rec(v_idx_rec).qty_doc           :=  TRANSLATE(Pkg_Lib.f_table_value(it_line, 11, 0),'.',',');
 
        END IF;
 
        -- check if the table header found
        IF NOT v_found_hdr
            AND UPPER(Pkg_Lib.f_table_value(it_line, 4, '')) LIKE '%COD%MATERIAL%' THEN
            v_found_hdr := TRUE;
        END IF;
 
        -- check if the table footer found
        IF v_found_hdr
            AND UPPER(Pkg_Lib.f_table_value(it_line, 11, '')) LIKE '%FIRMA%%' THEN
            v_found_hdr := FALSE;
        END IF;
 
 
    END LOOP;
 
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert int STG_WORK_ORDER
    IF it_rec.COUNT  > 0 THEN    Pkg_Iud.p_stg_receipt_miud   ('I',   it_rec); END IF;
 
    -- update the file status to processed
    v_row_fil.flag_processed    :=  -1;
    Pkg_Iud.p_stg_file_manager_iud('U', v_row_fil);
 
    COMMIT;
 
    -- try to VALIDATE
    Pkg_Stage.p_validate_item       (p_file_id);
    Pkg_Stage.p_validate_receipt    (p_file_id);
 
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
/**********************************************************************************************
    DDL:    22/06/2010  d   Create
/**********************************************************************************************/
PROCEDURE p_process_rec_2    (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    process the file informations and loads them in intermediare tables
--              (STG_BOM, STG_ITEM)
-----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (p_file_id  NUMBER)
                    IS
                    SELECT      *
                    FROM        IMPORT_TEXT_FILE
                    ----------------------------------------------
                    WHERE       file_id             =   p_file_id
                        AND     line_seq            >   1
                        AND (
                            line_text like '%Tot.:%'
                            OR
                            length(line_text) IN( 177, 178)
                            OR
                            line_text LIKE 'PROFORMA %'
                            )
                    ORDER BY    line_seq
                    ;
 
    CURSOR C_SEA    (p_org_code VARCHAR2)
                    IS
                    SELECT      *
                    FROM        WORK_SEASON
                    WHERE       org_code            =   p_org_code
                        AND     NVL(flag_active,'Y')=   'Y'
                    ORDER BY    season_code DESC
                    ;
 
    it_rec          Pkg_Rtype.ta_stg_receipt;
    v_idx_rec       INTEGER;
 
    v_row_itm       STG_ITEM%ROWTYPE;
    it_itm          Pkg_Rtype.tas_stg_item;
    v_idx_itm       VARCHAR2(50);
 
    v_row_sea       WORK_SEASON%ROWTYPE;
    it_line         Pkg_Glb.typ_string;
    v_row_fil       STG_FILE_MANAGER%ROWTYPE;
    v_err           VARCHAR2(1000);
    v_test          PLS_INTEGER;
    it_exc          Pkg_Glb.typ_varchar_varchar;
 
    v_doc_number    VARCHAR2(50);
    v_doc_date      DATE;
    v_currency_code VARCHAR2(10);
    v_country_from  VARCHAR2(10);
    v_item_code     VARCHAR2(30);
    v_flag_size     INTEGER;
    v_flag_range    INTEGER;
 
BEGIN
 
    --  get the file row from STG_FILE_MANAGER ,
    --  verify if it was already loaded
    v_row_fil.idriga    :=  p_file_id;
    Pkg_Get.p_get_stg_file_manager(v_row_fil);
    IF v_row_fil.flag_processed = -1 THEN
        Pkg_Lib.p_rae('Fisierul cu id = '||p_file_id||' a mai fost procesat anterior!');
    END IF;
 
    -- get the last active season code for ORG
    OPEN    C_SEA(v_row_fil.org_code);
    FETCH   C_SEA INTO v_row_sea;
    CLOSE   C_SEA;
    v_row_sea.season_code := 'AI10';
 
    -- DEFAULTS
    v_currency_code     :=  'EUR';
    v_country_from      :=  'IT';
 
    it_exc('FM')    :=  'S';
    it_exc('SL')    :=  'S';
 
--    pkg_app_tools.P_Log('D', p_file_id, 'z');
 
    FOR x IN C_LINES(p_file_id)
    LOOP
--        pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '0');
        -- get the header infos
        IF x.line_text LIKE 'PROFORMA %' AND NVL(v_doc_number, ' ') <> substr(x.line_text, 41, 5) THEN
            v_doc_number    :=  substr(x.line_text, 41, 5);
            v_doc_date      :=  to_date(substr(x.line_text, 56, 10), 'dd/mm/yyyy');
        END IF;
 
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '1');
 
        IF      x.line_text NOT LIKE 'PROFORMA %'
            AND substr(x.line_text,1,1) <> ' '
            AND x.line_text NOT LIKE '%Tot.:%'
        THEN
 
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '2');
 
            v_item_code := f_item_code(TRIM(substr(x.line_text, 1, 18)));
 
            v_flag_range    :=  0;
            v_flag_size     :=  0;
 
            -- insert the ITEM , if not present in STG_ITEM
            v_idx_itm   :=    v_item_code;
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                it_itm(v_idx_itm).org_code      :=  x.org_code;
 
                it_itm(v_idx_itm).description   :=  TRIM(substr(x.line_text, 19, 48));
                it_itm(v_idx_itm).puom          :=  f_transform_uom
                                                    (x.org_code, TRIM(substr(x.line_text, 67, 3)));
                it_itm(v_idx_itm).make_buy      :=  'A';
                it_itm(v_idx_itm).flag_range    :=  v_flag_range;
                it_itm(v_idx_itm).flag_size     :=  v_flag_size;
                it_itm(v_idx_itm).flag_colour   :=  0;
                it_itm(v_idx_itm).start_size    :=  NULL;
                it_itm(v_idx_itm).end_size      :=  NULL;
                it_itm(v_idx_itm).oper_code     :=  NULL;
                it_itm(v_idx_itm).item_code     :=  v_item_code;
                it_itm(v_idx_itm).file_id       :=  p_file_id;
                it_itm(v_idx_itm).stg_status    :=  'N';
            END IF;
 
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '3');
 
            -- RECEIPT DATA
            v_idx_rec                           :=  it_rec.COUNT + 1;
            it_rec(v_idx_rec).file_id           :=  p_file_id;
            it_rec(v_idx_rec).stg_status        :=  'N';
            it_rec(v_idx_rec).org_code          :=  x.org_code;
            it_rec(v_idx_rec).receipt_type      :=  'ME1';
            it_rec(v_idx_rec).doc_number        :=  v_doc_number;
            it_rec(v_idx_rec).doc_date          :=  v_doc_date;
            it_rec(v_idx_rec).currency_code     :=  v_currency_code;
            it_rec(v_idx_rec).country_from      :=  v_country_from;
            it_rec(v_idx_rec).item_code         :=  v_item_code;
            it_rec(v_idx_rec).season_code       :=  v_row_sea.season_code;
            it_rec(v_idx_rec).colour_code       :=  NULL;
    /*        IF v_flag_size = -1 THEN
                it_rec(v_idx_rec).size_code         :=  Pkg_Lib.f_table_value(it_line, 6, '');
            ELSE
                it_rec(v_idx_rec).size_code         :=  NULL;
            END IF;
    */
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '4');
 
            it_rec(v_idx_rec).oper_code_item    :=  NULL;
            it_rec(v_idx_rec).uom_receipt       :=  f_transform_uom
                                                    (x.org_code, TRIM(substr(x.line_text, 67, 3)));
 
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '5');
            it_rec(v_idx_rec).qty_doc           :=  TO_NUMBER(TRANSLATE(TRIM(substr(x.line_text, 70, 14)),',.',','));
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '6');
            it_rec(v_idx_rec).unit_price        :=  TO_NUMBER(TRANSLATE(TRIM(substr(x.line_text, 101, 30)),',.',','))
                                                    / it_rec(v_idx_rec).qty_doc;
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '7');
        END IF;
--        pkg_app_tools.P_Log('D', p_file_id, 'y');
    END LOOP;
 
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert int STG_WORK_ORDER
    IF it_rec.COUNT  > 0 THEN    Pkg_Iud.p_stg_receipt_miud   ('I',   it_rec); END IF;
 
    -- update the file status to processed
    v_row_fil.flag_processed    :=  -1;
    Pkg_Iud.p_stg_file_manager_iud('U', v_row_fil);
 
    COMMIT;
 
    -- try to VALIDATE
    Pkg_Stage.p_validate_item       (p_file_id);
    Pkg_Stage.p_validate_receipt    (p_file_id);
 
 
--EXCEPTION WHEN OTHERS THEN
--    ROLLBACK;
--    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
FUNCTION f_sql_stg_wo     (p_file_id  NUMBER)         RETURN typ_longinfo  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
 
    CURSOR     C_LINES      (           p_file_id       NUMBER)
                            IS
                            SELECT      o.org_code, o.order_code, o.item_code,o.season_code,
                                        i.description   i_description,
                                        o.size_code     ,
                                        o.qty           ,
                                        o.idriga        ,
                                        o.dcn           ,
                                        o.error_log     ,
                                        o.stg_status    ,
                                        o.note          ,
                                        o.client_code
                            ----------------------------------------------------------------------
                            FROM        STG_WORK_ORDER  o
                            LEFT JOIN   ITEM            i   ON  i.org_code      =   o.org_code
                                                            AND i.item_code     =   o.item_code
                            ----------------------------------------------------------------------
                            WHERE       o.file_id       =   p_file_id
                            ----------------------------------------------------------------------
                            ORDER BY    o.idriga
                            ;
 
    v_row      tmp_longinfo := tmp_longinfo();
 
BEGIN
 
    FOR X IN C_LINES(p_file_id)
    LOOP
 
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;
 
        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.order_code;
        v_row.txt03     :=  x.item_code;
        v_row.txt04     :=  x.error_log;
        v_row.txt05     :=  x.i_description;
        v_row.txt06     :=  x.size_code;
        v_row.txt07     :=  x.season_code;
        v_row.txt08     :=  x.stg_status;
        v_row.txt09     :=  x.note;
        v_row.txt10     :=  x.client_code;
        
        v_row.numb01    :=  p_file_id;
        v_row.numb02    :=  x.qty;
 
        pipe ROW(v_row);
    END LOOP;
 
    RETURN;
 
END;
 
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
PROCEDURE p_load_item       (p_file_id      NUMBER)
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
    CURSOR C_ITEM   (p_file_id  NUMBER)
                    IS
                    SELECT      *
                    FROM        STG_ITEM
                    WHERE       file_id         =   p_file_id
                        AND     stg_status      =   'V'
                    ;
 
    v_row_sit       STG_ITEM%ROWTYPE;
    v_row_itm       ITEM%ROWTYPE;
 
BEGIN
 
    FOR x IN C_ITEM (p_file_id)
    LOOP
        BEGIN
            v_row_itm.org_code      :=  x.org_code;
            v_row_itm.item_code     :=  x.item_code;
            v_row_itm.description   :=  replace(replace(x.description, '"', ''), '''', '');
            v_row_itm.puom          :=  x.puom;
            v_row_itm.make_buy      :=  x.make_buy;
            v_row_itm.flag_size     :=  x.flag_size;
            v_row_itm.start_size    :=  x.start_size;
            v_row_itm.end_size      :=  x.end_size;
            v_row_itm.flag_colour   :=  x.flag_colour;
            v_row_itm.flag_range    :=  x.flag_range;
            v_row_itm.oper_code     :=  x.oper_code;
            v_row_itm.uom_conv      :=  0;
            v_row_itm.uom_receit    :=  x.puom;
            v_row_itm.mat_type      :=  '???';
            v_row_itm.root_code     :=  x.root_code;
            IF x.make_buy = 'A' THEN
                v_row_itm.type_code := 'MP';
                v_row_itm.whs_stock  := nvl(x.default_whs, 'MPLOHN');
            ELSE
                v_row_itm.type_code := 'PF';
                v_row_itm.whs_stock  := nvl(x.default_whs, 'EXP');
            END IF;
            Pkg_Iud.p_item_iud      ('I',v_row_itm);
 
            -- add TEH_variables from the template
            insert into item_variable(org_code, item_code, var_code, var_value)
                select org_code, x.item_code, var_code, var_value 
                from item_variable
                where var_code = 'TIPTALPA'
                    AND org_code = x.org_code
                    AND item_code = 'FAM.FG.' || x.description
                ;
 
            v_row_sit                       :=  x;
            v_row_sit.stg_status            :=  'L';
            Pkg_Iud.p_stg_item_iud  ('U', v_row_sit);
 
            COMMIT;
 
            EXCEPTION WHEN OTHERS THEN
                ROLLBACK;
                v_row_sit                       :=  x;
                v_row_sit.stg_status            :=  'E';
                v_row_sit.error_log             :=  v_row_sit.error_log || SQLERRM;
                Pkg_Iud.p_stg_item_iud('U', v_row_sit);
                COMMIT;
        END;
 
    END LOOP;
 
EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
PROCEDURE p_load_wo       (p_file_id      NUMBER)
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
 
    CURSOR C_WO     (p_file_id  NUMBER)
                    IS
                    SELECT      DISTINCT org_code, order_code, item_code, season_code,client_lot, client_code, note
                    FROM        STG_WORK_ORDER
                    WHERE       file_id         =   p_file_id
                        AND     stg_status      =   'V'
                    ORDER BY    order_code
                    ;
 
    CURSOR C_DET    (p_file_id  NUMBER, p_org_code VARCHAR2, p_order_code VARCHAR2)
                    IS
                    SELECT      *
                    FROM        STG_WORK_ORDER
                    WHERE       file_id     =   p_file_id
                        AND     org_code    =   p_org_code
                        AND     order_code  =   p_order_code
                        AND     stg_status  =   'V'
                    ORDER BY    size_code
                    ;
 
    v_row_wo        WORK_ORDER%ROWTYPE;
    v_row_det       WO_DETAIL%ROWTYPE;
    v_row_sit       STG_WORK_ORDER%ROWTYPE;
    v_flag_err      BOOLEAN;
    v_str_err       VARCHAR2(1000);
 
BEGIN
 
    FOR x IN C_WO (p_file_id)
    LOOP
 
        v_flag_err:=    FALSE;
 
        BEGIN
            -- insert in the ORDER table
            v_row_wo.idriga         :=  NULL;
            v_row_wo.org_code       :=  x.org_code;
            v_row_wo.order_code     :=  x.order_code;
            v_row_wo.item_code      :=  x.item_code;
            v_row_wo.season_code    :=  x.season_code;
            v_row_wo.client_lot     :=  x.client_lot;
            v_row_wo.client_code    :=  x.client_CODE;
            v_row_wo.date_create    :=  TRUNC(SYSDATE);
            v_row_wo.note           :=  x.note;
            v_row_wo.oper_code_item :=  'FINIT';
            v_row_wo.routing_code   :=  '012';
            Pkg_Iud.p_work_order_iud ('I', v_row_wo);
            v_row_wo.idriga         :=  Pkg_Lib.f_read_pk;
 
            EXCEPTION WHEN OTHERS THEN
                v_flag_err  :=  TRUE;
                v_str_err   :=  SQLERRM;
        END;
 
        FOR xx IN C_DET (p_file_id, x.org_code, x.order_code)
        LOOP
 
            BEGIN
                IF NOT v_flag_err THEN
                    v_row_det.ref_wo            :=  v_row_wo.idriga;
                    v_row_det.size_code         :=  xx.size_code;
                    v_row_det.qta               :=  xx.qty;
                    Pkg_Iud.p_wo_detail_iud ('I', v_row_det);
 
                    v_row_sit                       :=  xx;
                    v_row_sit.stg_status            :=  'L';
                    Pkg_Iud.p_stg_work_order_iud('U', v_row_sit);
 
                ELSE
                    v_row_sit                       :=  xx;
                    v_row_sit.stg_status            :=  'E';
                    v_row_sit.error_log             :=  v_str_err;
                    Pkg_Iud.p_stg_work_order_iud('U', v_row_sit);
 
                END IF;
 
            EXCEPTION WHEN OTHERS THEN
                v_row_sit                       :=  xx;
                v_row_sit.stg_status            :=  'E';
                v_row_sit.error_log             :=  SQLERRM;
                Pkg_Iud.p_stg_work_order_iud('U', v_row_sit);
            END;
 
        END LOOP;
 
        COMMIT;
 
 
    END LOOP;
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
/*********************************************************************************************
    21/04/2008  d   Create
 
/*********************************************************************************************/
PROCEDURE p_load_rec       (p_file_id      NUMBER)
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
 
    CURSOR C_RCH    (p_file_id NUMBER)
        IS
        SELECT      doc_number,
                    MAX(org_code)       org_code,
                    MAX(receipt_type)   receipt_type,
                    MAX(doc_date)       doc_date,
                    MAX(currency_code)  currency_code,
                    MAX(country_from)   country_from
        FROM        STG_RECEIPT     s
        WHERE       file_id         =   p_file_id
            AND     stg_status      =   'V'
            AND NOT EXISTS
                    (   SELECT  1
                        FROM    STG_RECEIPT     ss
                        WHERE   ss.file_id      = s.file_id
                            AND ss.stg_status   <> 'V')
        GROUP BY doc_number
        ;
 
    CURSOR C_RCD    (p_file_id  NUMBER, p_doc_number VARCHAR2)
                    IS
                    SELECT      s.*
                    FROM        STG_RECEIPT     s
                    left join   ITEM i  on  i.org_code  = s.org_code 
                                        and i.item_code = s.item_code
                    WHERE       file_id         =   p_file_id
                        AND     doc_number      =   p_doc_number
                    ;
 
    v_row_h         RECEIPT_HEADER%ROWTYPE;
    v_row_d         RECEIPT_DETAIL%ROWTYPE;
    v_row_it        ITEM%ROWTYPE;
    it_rec_d        Pkg_Rtype.ta_receipt_detail;
    it_stg_r        Pkg_Rtype.ta_stg_receipt;
    v_row_sit       STG_RECEIPT%ROWTYPE;
    v_flag_err      BOOLEAN;
    v_str_err       VARCHAR2(1000);
 
BEGIN
 
    FOR x IN C_RCH (p_file_id)
     loop
 
        v_flag_err:=    FALSE;
        v_row_h.idriga := NULL;
 
        BEGIN
            -- set the header data
            v_row_h.org_code        :=  x.org_code;
            v_row_h.receipt_type    :=  x.receipt_type;
            v_row_h.suppl_code      :=  x.org_code;
            v_row_h.doc_number      :=  x.doc_number;
            v_row_h.doc_date        :=  x.doc_date;
            v_row_h.currency_code   :=  x.currency_code;
            v_row_h.country_from    :=  x.country_from;
            v_row_h.status          :=  'I';
            v_row_h.incoterm        :=  'CIP';
 
            Pkg_Receipt.p_receipt_header_blo('I', v_row_h);
 
            Pkg_Iud.p_receipt_header_iud ('I', v_row_h);
            v_row_h.idriga         :=  Pkg_Lib.f_read_pk;
 
        EXCEPTION WHEN OTHERS THEN
            v_flag_err      :=  TRUE;
            v_str_err       :=  SQLERRM;
            raise;
        END;
 
        FOR xx IN C_RCD (p_file_id, x.doc_number)
        LOOP
            IF NOT v_flag_err THEN
                BEGIN
                    v_row_it.org_code       :=  xx.org_code;
                    v_row_it.item_code      :=  xx.item_code;
                    pkg_get2.p_get_item_2(v_row_it);
                
                    v_row_d.org_code        :=  xx.org_code;
                    v_row_d.ref_receipt     :=  v_row_h.idriga;
                    v_row_d.uom_receipt     :=  xx.uom_receipt;
                    v_row_d.qty_doc         :=  xx.qty_doc;
                    v_row_d.qty_count       :=  xx.qty_doc;
                    v_row_d.uom_receipt     :=  xx.uom_receipt;
                    v_row_d.price_doc       :=  xx.unit_price;
                    v_row_d.item_code       :=  xx.item_code;
                    v_row_d.colour_code     :=  xx.colour_code;
                    v_row_d.size_code       :=  xx.size_code;
                    v_row_d.season_code     :=  xx.season_code;
                    v_row_d.oper_code_item  :=  xx.oper_code_item;
                    v_row_d.custom_code     :=  NVL(v_row_it.custom_code, '59069990');
                    v_row_d.origin_code     :=  xx.country_from;
                    v_row_d.whs_code        :=  nvl(v_row_it.whs_stock, case when v_row_h.receipt_type = 'ME3' THEN 'AUXLOHN' ELSE 'MPLOHN' END);
                    v_row_d.weight_net      :=  nvl(xx.net_weight, 0);
                    v_row_d.weight_brut     :=  nvl(xx.net_weight, 0);
                    v_row_d.line_Seq        :=  nvl(xx.line_no, 0); 
 
                    Pkg_Receipt.p_receipt_detail_blo('I', v_row_d);
 
                    Pkg_Iud.p_receipt_detail_iud('I', v_row_d);
 
                    v_row_sit                       :=  xx;
                    v_row_sit.stg_status            :=  'L';
                    it_stg_r(it_stg_r.count + 1)    :=  v_row_sit;
                    --Pkg_Iud.p_stg_receipt_iud('U', v_row_sit);
 
                EXCEPTION WHEN OTHERS THEN
                    v_row_sit                       :=  xx;
                    v_row_sit.stg_status            :=  'E';
                    v_row_sit.error_log             :=  SQLERRM;
                    it_stg_r(it_stg_r.count + 1)    :=  v_row_sit;
 
--                    Pkg_Iud.p_stg_receipt_iud('U', v_row_sit);
                    v_flag_err      :=  TRUE;
                    v_str_err       :=  'Err on other lines';
                    raise;
                END;
            ELSE
                v_row_sit                       :=  xx;
                v_row_sit.stg_status            :=  'E';
                v_row_sit.error_log             :=  v_str_err;
                it_stg_r(it_stg_r.count + 1)    :=  v_row_sit;
--                Pkg_Iud.p_stg_receipt_iud('U', v_row_sit);
            END IF;
 
        END LOOP; -- on receipt details
 
        IF v_flag_err THEN
            ROLLBACK;
        ELSE
            COMMIT;
        END IF;
 
    END LOOP;-- on receipt headers
 
    IF it_stg_r.count > 0 THEN
        Pkg_Iud.p_stg_receipt_miud('U', it_stg_r);
    END IF;
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
/*********************************************************************************************
    29/05/2008  d   Create
 
/*********************************************************************************************/
PROCEDURE p_load_bom       (p_file_id      NUMBER)
----------------------------------------------------------------------------------------------
--  PURPOSE:    Loads STG_BOM valid informations in BOM_STD table
----------------------------------------------------------------------------------------------
IS
 
    CURSOR C_FATHER (p_file_id  NUMBER)
                    IS
                    SELECT      DISTINCT org_code, father_code
                    FROM        STG_BOM_STD
                    WHERE       file_id         =   p_file_id
                        AND     stg_status      =   'V'
                    ORDER BY    father_code
                    ;
 
    CURSOR C_BOM    (p_file_id  NUMBER, p_org_code VARCHAR2, p_father_code VARCHAR2)
                    IS
                    SELECT      *
                    FROM        STG_BOM_STD
                    WHERE       file_id         =   p_file_id
                        AND     org_code        =   p_org_code
                        AND     father_code     =   p_father_code
                        AND     stg_status      =   'V'
                    ORDER BY    child_code
                    ;
 
    v_row_bom       BOM_STD%ROWTYPE;
    v_row_sbom      STG_BOM_STD%ROWTYPE;
    it_bom          Pkg_Rtype.ta_bom_std;
    it_sbom         Pkg_Rtype.ta_stg_bom_std;
    v_flag_err      BOOLEAN;
    v_str_err       VARCHAR2(1000);
 
BEGIN
 
    FOR x IN C_FATHER (p_file_id)
    LOOP
 
        it_bom.DELETE;
        it_sbom.DELETE;
 
        BEGIN
 
            FOR xx IN C_BOM (p_file_id, x.org_code, x.father_code)
            LOOP
 
                    it_sbom(it_sbom.COUNT + 1)  :=  xx;
                    it_sbom(it_sbom.COUNT).stg_status   :=  'L';
 
                    v_row_bom.org_code      :=  xx.org_code;
                    v_row_bom.father_code   :=  xx.father_code;
                    v_row_bom.child_code    :=  xx.child_code;
                    v_row_bom.qta           :=  xx.qta;
                    v_row_bom.colour_code   :=  xx.colour_code;
                    v_row_bom.oper_code     :=  xx.oper_code;
                    v_row_bom.qta_std       :=  xx.qta_std;
                    v_row_bom.start_size    :=  xx.start_size;
                    v_row_bom.end_size      :=  xx.end_size;
 
                    it_bom(it_bom.COUNT + 1)    :=  v_row_bom;
 
            END LOOP;
 
            Pkg_Iud.p_bom_std_miud('I',it_bom);
            Pkg_Iud.p_stg_bom_std_miud('U', it_sbom);
 
            COMMIT;
 
        EXCEPTION WHEN OTHERS THEN
            ROLLBACK;
            Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
        END;
 
    END LOOP;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
PROCEDURE p_load            (p_ref_file NUMBER)
IS
    v_row_file              STG_FILE_MANAGER%ROWTYPE;
BEGIN
 
    v_row_file.idriga       :=  p_ref_file;
    Pkg_Get.p_get_stg_file_manager(v_row_file, -1);
 
    CASE v_row_file.file_info
        WHEN    'BOM'   THEN
                            p_load_item (p_ref_file);
                            p_load_bom  (p_ref_file);
        WHEN    'WO'    THEN
                            p_load_item     (p_ref_file);
                            p_load_wo       (p_ref_file);
        WHEN    'REC'   THEN
                            p_load_item     (p_ref_file);
                            p_load_rec      (p_ref_file);
        WHEN    'SHIPMAT' THEN
                            p_load_item     (p_ref_file);
                            Pkg_STage_ROA.p_load_ship_fifo (p_ref_file);
        WHEN    'SHIP' THEN
                            p_load_item     (p_ref_file);
                            p_load_wo       (p_ref_file);
                            Pkg_STage_ROA.p_load_wo_decl (p_ref_file);
        WHEN    'PROD' THEN
                            p_load_item     (p_ref_file);
                            p_load_wo       (p_ref_file);
                            Pkg_STage_ROA.p_load_wo_decl (p_ref_file);
        
        ELSE
                        Pkg_Err.p_rae('Caz netratat: '||v_row_file.file_info);
    END CASE;
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
PROCEDURE p_process_file    (   p_ref_file      NUMBER)
IS
    v_row_file              STG_FILE_MANAGER%ROWTYPE;
BEGIN

    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,'' ';    
 
    v_row_file.idriga       :=  p_ref_file;
    Pkg_Get.p_get_stg_file_manager(v_row_file, -1);
 
    IF v_row_file.flag_processed = -1 THEN
        Pkg_Lib.p_rae('Acest fisier e deja procesat! Nu se mai poate procesa!');
    ELSE
        CASE v_row_file.file_info
            WHEN    'BOM'   THEN    
                if v_row_file.org_code = 'RUC' then
                    p_process_bom_ruco   (p_ref_file);
                elsif v_row_file.org_code in( 'ALT', 'PRO') then
                    Pkg_Stage_ROA.p_process_bom_alt   (v_row_file);
                else     
                    p_process_bom   (p_ref_file);
                end if;
            WHEN    'WO'    THEN    
                IF v_row_file.org_code = 'ALT' THEN
                    Pkg_Stage_ROA.p_process_wo_decl (v_row_file);
                ELSE
                    p_process_wo    (p_ref_file);
                END IF;
            WHEN 'WO_PROD' THEN
                Pkg_Stage_ROA.p_process_wo_decl (v_row_file);
            WHEN 'SHIP' THEN
                Pkg_Stage_ROA.p_process_wo_decl (v_row_file);
            WHEN 'PROD' THEN
                Pkg_Stage_ROA.p_process_wo_decl (v_row_file);
            WHEN 'REC'   THEN    
                IF v_row_file.org_code = 'ALT' THEN
                    Pkg_Stage_ROA.p_process_rec_ALT (v_row_file);
                ELSE  
                    p_process_rec_3 (p_ref_file);
                END IF;
            WHEN 'SHIPMAT' THEN
                IF v_row_file.org_code = 'ALT' THEN
                    Pkg_Stage_ROA.p_process_ship_fifo (v_row_file);
                ELSE
                    Pkg_Err.p_rae('Procesare '||v_row_file.file_info||' neimplementata pentru organizatia:'||v_row_file.file_info);
                END IF;
            WHEN 'REC_PKL' THEN
                IF v_row_file.org_code = 'ALT' THEN
                    Pkg_Stage_ROA.p_process_rec_pkl (v_row_file);
                ELSE
                    Pkg_Err.p_rae('Procesare '||v_row_file.file_info||' neimplementata pentru organizatia:'||v_row_file.file_info);
                END IF;
            ELSE    Pkg_Err.p_rae('Optiune necunoscuta la procesarea fisierului:'||v_row_file.file_info);
        END CASE;
 
    END IF;

    -- update the file status to processed
    v_row_file.flag_processed    :=  -1;
    Pkg_Iud.p_stg_file_manager_iud('U', v_row_file);
 
    COMMIT;
     
    Pkg_Stage.p_revalidate_file(p_ref_file);
     
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
 
/*********************************************************************************************************
    DDL:    27/05/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_stg_item_iud        (   p_tip       VARCHAR2,
                                    p_row       STG_ITEM%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on STG_ITEM table
-----------------------------------------------------------------------------------------------------------
IS
    v_row       STG_ITEM%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_stg_item_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


PROCEDURE p_stg_receipt_iud (   p_tip       VARCHAR2,
                                p_row       STG_RECEIPT%ROWTYPE)
IS
    v_row       STG_RECEIPT%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_stg_receipt_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END; 
 
/*********************************************************************************************************
    DDL:    27/05/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_stg_bom_std_iud        (    p_tip       VARCHAR2,
                                        p_row       STG_BOM_STD%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on STG_ITEM table
-----------------------------------------------------------------------------------------------------------
IS
    v_row       STG_BOM_STD%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_stg_bom_std_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
 
 
/*********************************************************************************************************
    DDL:    27/05/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_stg_work_order_iud  (   p_tip       VARCHAR2,
                                    p_row       STG_WORK_ORDER%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on STG_WORK_ORDER table
-----------------------------------------------------------------------------------------------------------
IS
    v_row       STG_WORK_ORDER%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_stg_work_order_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
 

/*********************************************************************************************************
    DDL:    05/04/2016 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_stg_file_manager_iud(   p_tip       VARCHAR2,
                                    p_row       STG_FILE_MANAGER%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on STG_WORK_ORDER table
-----------------------------------------------------------------------------------------------------------
IS
    v_row       STG_FILE_MANAGER%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_stg_file_manager_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


PROCEDURE p_stg_parser_iud  (   p_tip       VARCHAR2,
                                p_row       STG_PARSER%ROWTYPE)
IS
    v_row       STG_PARSER%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_stg_parser_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


PROCEDURE p_stg_ship_fifo_iud(   p_tip       VARCHAR2,
                                    p_row       STG_SHIP_FIFO%ROWTYPE)
IS
    v_row       STG_SHIP_FIFO%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_stg_ship_fifo_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
 
PROCEDURE p_stg_wo_decl_iud(   p_tip       VARCHAR2,
                               p_row       STG_WO_DECL%ROWTYPE)
IS
    v_row       STG_WO_DECL%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_stg_wo_decl_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END; 

PROCEDURE p_import_text_file_iud(   p_tip       VARCHAR2,
                                    p_row       IMPORT_TEXT_FILE%ROWTYPE)
IS
    v_row       IMPORT_TEXT_FILE%ROWTYPE;
BEGIN
 
    v_row       :=  p_row;
 
    Pkg_Iud.p_import_text_file_iud(p_tip, v_row);
 
    COMMIT;
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
 
/*********************************************************************************************************
    DDL:    27/05/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_revalidate_file (   p_file_id   NUMBER)
IS
BEGIN
 
    -- try to VALIDATE
    Pkg_Stage.p_validate_item     (p_file_id);
    Pkg_Stage.p_validate_bom      (p_file_id);
    Pkg_Stage.p_validate_wo       (p_file_id);
    Pkg_Stage.p_validate_receipt  (p_file_id);
    Pkg_Stage.p_validate_ship_fifo(p_file_id);
    Pkg_Stage.p_validate_wo_decl  (p_file_id);
    
END;
 
/*********************************************************************************************************
    DDL:    16/06/2008 d Create procedure
/*********************************************************************************************************/
FUNCTION f_get_impdir_path      RETURN VARCHAR2
IS
 
    CURSOR C_GET_PATH
                        IS
                        SELECT  description
                        FROM    MULTI_TABLE
                        WHERE   table_name      =   'SYSPAR'
                            AND table_key       =   'IMPORT_FILE_PATH'
                        ;
 
    v_rez               VARCHAR2(500);
 
BEGIN
    OPEN C_GET_PATH; FETCH C_GET_PATH INTO v_rez; CLOSE C_GET_PATH;
    RETURN v_rez;
END;
 
 
/**********************************************************************************************
    DDL:    22/06/2010  d   Create
/**********************************************************************************************/
PROCEDURE p_process_rec_3    (   p_file_id       NUMBER)
IS
    CURSOR C_LINES  (p_file_id  NUMBER)
                    IS
                    SELECT      *
                    FROM        IMPORT_TEXT_FILE
                    ----------------------------------------------
                    WHERE       file_id             =   p_file_id
                    ORDER BY    line_seq
                    ;
 
    CURSOR C_SEA    (p_org_code VARCHAR2)
                    IS
                    SELECT      *
                    FROM        WORK_SEASON
                    WHERE       org_code            =   p_org_code
                        AND     NVL(flag_active,'Y')=   'Y'
                    ORDER BY    season_code DESC
                    ;
 
    it_rec          Pkg_Rtype.ta_stg_receipt;
    v_idx_rec       INTEGER;
 
    v_row_itm       STG_ITEM%ROWTYPE;
    it_itm          Pkg_Rtype.tas_stg_item;
    v_idx_itm       VARCHAR2(50);
 
    v_row_sea       WORK_SEASON%ROWTYPE;
    it_line         Pkg_Glb.typ_string;
    v_row_fil       STG_FILE_MANAGER%ROWTYPE;
    v_err           VARCHAR2(1000);
    v_test          PLS_INTEGER;
    it_exc          Pkg_Glb.typ_varchar_varchar;
    it_expl         Pkg_Glb.typ_string;
    
    v_doc_number    VARCHAR2(50);
    v_doc_date      DATE;
    v_currency_code VARCHAR2(10);
    v_country_from  VARCHAR2(10);
    v_item_code     VARCHAR2(30);
    v_flag_size     INTEGER;
    v_flag_range    INTEGER;
    v_valid         BOOLEAN;
    
    FUNCTION f_seg (x_line VARCHAR2, x_pos INTEGER) RETURN VARCHAR2
    IS
    BEGIN
        RETURN Pkg_Lib.f_get_segment_from_string(x_line, CHR(9), x_pos);
    END;
 
BEGIN
 
    --  get the file row from STG_FILE_MANAGER ,
    --  verify if it was already loaded
    v_row_fil.idriga    :=  p_file_id;
    Pkg_Get.p_get_stg_file_manager(v_row_fil);
    IF v_row_fil.flag_processed = -1 THEN
        Pkg_Lib.p_rae('Fisierul cu id = '||p_file_id||' a mai fost procesat anterior!');
    END IF;
 
    -- get the last active season code for ORG
    OPEN    C_SEA(v_row_fil.org_code);
    FETCH   C_SEA INTO v_row_sea;
    CLOSE   C_SEA;
    v_row_sea.season_code := 'AI10';
 
    -- DEFAULTS
    v_currency_code     :=  'EUR';
    v_country_from      :=  'IT';
 
    it_exc('FM')    :=  'S';
    it_exc('SL')    :=  'S';
 
--    pkg_app_tools.P_Log('D', p_file_id, 'z');
 
    v_valid     :=  FALSE;
    FOR x IN C_LINES(p_file_id)
    LOOP
--        pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '0');
        -- get the header infos
        IF x.line_text LIKE 'DOCUMENT DATE%' THEN
            v_doc_number    :=  f_seg(x.line_text, 4);
--            v_doc_date      :=  to_date(f_seg(x.line_text, 2), 'dd/mm/yyyy');
        END IF;
 
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '1');
        CASE 
            WHEN x.line_text LIKE '%Item code%' THEN
                v_valid :=  TRUE;
            WHEN    x.line_text LIKE '%TOTAL QUANTITY	INVOICE AMOUNT%'
                    OR 
                    x.line_text like 'DOCUMENTO%' 
                THEN
                v_valid :=  FALSE;
            
            WHEN v_valid THEN
                v_item_code := f_item_code(f_seg(x.line_text, 1));
 
                v_flag_range    :=  0;
                v_flag_size     :=  0;
 
                -- insert the ITEM , if not present in STG_ITEM 
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, v_item_code);
                v_idx_itm   :=    v_item_code;
                IF NOT it_itm.EXISTS(v_idx_itm) THEN
                    it_itm(v_idx_itm).org_code      :=  x.org_code;
 
                    it_itm(v_idx_itm).description   :=  TRIM(f_seg(x.line_text, 2));
                    it_itm(v_idx_itm).puom          :=  f_transform_uom
                                                    (x.org_code, TRIM(f_seg(x.line_text, 4)));
                    it_itm(v_idx_itm).make_buy      :=  'A';
                    it_itm(v_idx_itm).flag_range    :=  v_flag_range;
                    it_itm(v_idx_itm).flag_size     :=  v_flag_size;
                    it_itm(v_idx_itm).flag_colour   :=  0;
                    it_itm(v_idx_itm).start_size    :=  NULL;
                    it_itm(v_idx_itm).end_size      :=  NULL;
                    it_itm(v_idx_itm).oper_code     :=  NULL;
                    it_itm(v_idx_itm).item_code     :=  v_item_code;
                    it_itm(v_idx_itm).file_id       :=  p_file_id;
                    it_itm(v_idx_itm).stg_status    :=  'N';
                END IF;
 
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '3');
 
            -- RECEIPT DATA
            v_idx_rec                           :=  it_rec.COUNT + 1;
            it_rec(v_idx_rec).file_id           :=  p_file_id;
            it_rec(v_idx_rec).stg_status        :=  'N';
            it_rec(v_idx_rec).org_code          :=  x.org_code;
            it_rec(v_idx_rec).receipt_type      :=  'ME1';
            it_rec(v_idx_rec).doc_number        :=  v_doc_number;
            it_rec(v_idx_rec).doc_date          :=  v_doc_date;
            it_rec(v_idx_rec).currency_code     :=  v_currency_code;
            it_rec(v_idx_rec).country_from      :=  v_country_from;
            it_rec(v_idx_rec).item_code         :=  v_item_code;
            it_rec(v_idx_rec).season_code       :=  v_row_sea.season_code;
            it_rec(v_idx_rec).colour_code       :=  NULL;
    /*        IF v_flag_size = -1 THEN
                it_rec(v_idx_rec).size_code         :=  Pkg_Lib.f_table_value(it_line, 6, '');
            ELSE
                it_rec(v_idx_rec).size_code         :=  NULL;
            END IF;
    */
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '4');
 
            it_rec(v_idx_rec).oper_code_item    :=  NULL;
            it_rec(v_idx_rec).uom_receipt       :=  f_transform_uom
                                                    (x.org_code, TRIM(f_seg(x.line_text, 4)));
 
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '5');
            it_rec(v_idx_rec).qty_doc           :=  TO_NUMBER(TRANSLATE(TRIM(f_seg(x.line_text, 5)),',.',','));
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '6');
            it_rec(v_idx_rec).unit_price        :=  TO_NUMBER(TRANSLATE(TRIM(f_seg(x.line_text, 6)),',.',','));
                                                   -- / it_rec(v_idx_rec).qty_doc;
--pkg_app_tools.P_Log('D', C_LINES%ROWCOUNT, '7');
--        pkg_app_tools.P_Log('D', p_file_id, 'y');
            ELSE 
                NULL;
        END CASE;
    END LOOP;
 
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert int STG_WORK_ORDER
    IF it_rec.COUNT  > 0 THEN
        Pkg_Iud.p_stg_receipt_miud ('I', it_rec); 
    END IF;
 
    -- update the file status to processed
    v_row_fil.flag_processed    :=  -1;
    Pkg_Iud.p_stg_file_manager_iud('U', v_row_fil);
 
    COMMIT;
 
    -- try to VALIDATE
    Pkg_Stage.p_validate_item       (p_file_id);
    Pkg_Stage.p_validate_receipt    (p_file_id);
 
 
--EXCEPTION WHEN OTHERS THEN
--    ROLLBACK;
--    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 
 
 
 PROCEDURE p_process_bom_ruco_old    (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    process the file informations and loads them in intermediare tables
--              (STG_BOM, STG_ITEM)
-----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (p_file_id  NUMBER)
                    IS
                    SELECT      *
                    FROM        IMPORT_TEXT_FILE
                    ----------------------------------------------
                    WHERE       file_id             =   p_file_id
                        AND     line_seq            >   1
                    ORDER BY    line_seq
                    ;
 
    CURSOR C_EXPL   (p_line_text    VARCHAR2)
                    IS
                    SELECT  ROWNUM      col_seq,
                            txt01       col_text
                    -------------------------------------------------
                    FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_line_text,'|', -1))
                    ;
 
    CURSOR C_EX_ITM_STG (p_org_code VARCHAR2, p_item_code VARCHAR2)
                        IS
                        SELECT      1
                        FROM        STG_ITEM    i
                        WHERE       org_code    =   p_org_code
                            AND     item_code   =   p_item_code
                        ;
 
    v_idx_bom       VARCHAR2(50);
    it_bom          Pkg_Rtype.tas_stg_bom_std;   -- stg_bom_std
    it_itm          Pkg_Rtype.tas_stg_item;      -- stg_item
    v_idx_itm       VARCHAR2(50);
    v_row_itm       STG_ITEM%ROWTYPE;
    it_line         Pkg_Glb.typ_string;
    it_fase         Pkg_Glb.typ_string;
    v_err           VARCHAR2(1000);
    v_found         BOOLEAN;
    v_test          PLS_INTEGER;
    v_row_fil       STG_FILE_MANAGER%ROWTYPE;
    it_exc          Pkg_Glb.typ_varchar_varchar;
    V_FLAG_RANGE    BOOLEAN;
    v_child_code    VARCHAR2(50);
    v_father_code   VARCHAR2(50);
    v_line_seq      number;
    v_qta_str       varchar2(250);
BEGIN
 
    it_fase (0)     :=  '';
    it_fase (10)    :=  'CROIT';
    it_fase (20)    :=  'CUSUT';
    it_fase (30)    :=  'TRAS';
 
    --  get the file row from STG_FILE_MANAGER ,
    --  verify if it was already loaded
    v_row_fil.idriga    :=  p_file_id;
    Pkg_Get.p_get_stg_file_manager(v_row_fil);
    IF v_row_fil.flag_processed = -1 THEN
        Pkg_Lib.p_rae('Fisierul cu id = '||p_file_id||' a mai fost procesat anterior!');
    END IF;
 
    FOR x IN C_LINES(p_file_id)
    LOOP
        v_line_seq := x.line_seq;
        it_line.DELETE;
        FOR xx IN C_EXPL (x.line_text)
        LOOP
            it_line(xx.col_seq)     :=  xx.col_text;
        END LOOP;
 
        -- exclude the lines for NOTE
        IF  1 = 2 
            THEN
            
            NULL;
 
        ELSE
 
            -- determine if the child is range controlled 
            -- compare the CHILD size with the father size 
            IF      Pkg_Lib.f_table_value(it_line, 13, '') IS NOT NULL
                AND Pkg_Lib.f_table_value(it_line, 13, ' ') <> Pkg_Lib.f_table_value(it_line, 12, ' ')
            THEN
                v_flag_range    :=  TRUE;
                v_child_code    :=  f_item_code(
                                    Pkg_Lib.f_table_value(it_line, 8,'')||'/'||Pkg_Lib.f_table_value(it_line, 13,'??')
                                    );
            ELSE
                v_flag_range    :=  FALSE;
                v_child_code    :=  f_item_code(
                                    Pkg_Lib.f_table_value(it_line, 8,'')
                                    );
            END IF;
            -- add the colour code to the child item_code 
            if Pkg_Lib.f_table_value(it_line, 10, '') is not null then
                v_child_code := v_child_code || '/' || Pkg_Lib.f_table_value(it_line, 10, '');
            end if;
            v_father_code := replace(Pkg_Lib.f_table_value(it_line, 4, ''), '-', '/')
                            || (case when Pkg_Lib.f_table_value(it_line, 6, '') is not null
                                then '/' ||Pkg_Lib.f_table_value(it_line, 6, '')
                                end);
 
            v_idx_bom       :=  Pkg_Lib.f_implode('$', v_father_code, v_child_code);
 
            v_qta_str := replace(Pkg_Lib.f_table_value(it_line, 15, '0'), ',', '.');
            IF NOT it_bom.EXISTS(v_idx_bom) THEN
                it_bom(v_idx_bom).file_id       :=  p_file_id;
                it_bom(v_idx_bom).father_code   :=  v_father_code;
                it_bom(v_idx_bom).child_code    :=  v_child_code;
                it_bom(v_idx_bom).qta           :=  round(to_number(v_qta_str), 3);
                it_bom(v_idx_bom).colour_code   :=  NULL;
                it_bom(v_idx_bom).oper_code     :=  null;
                it_bom(v_idx_bom).qta_std       :=  it_bom(v_idx_bom).qta;
                it_bom(v_idx_bom).org_code      :=  x.org_code;
                it_bom(v_idx_bom).uom           :=  f_transform_uom(x.org_code,
                                                                    Pkg_Lib.f_table_value(it_line, 14, ''));
                it_bom(v_idx_bom).note          :=  RTRIM(
                                                    Pkg_Lib.f_table_value(it_line, 16, '')||Pkg_Glb.C_NL||
                                                    Pkg_Lib.f_table_value(it_line, 17, '')
                                                    ,CHR(13)||CHR(10));
                ELSE
                    -- if the item is already loaded in memory => only compute the media with the new value
                    it_bom(v_idx_bom).qta       :=  (
                                                    it_bom(v_idx_bom).qta
                                                    +
                                                    7--round(to_number(v_qta_str), 3)
                                                    ) / 2 ;
 
                    it_bom(v_idx_bom).qta_std   :=  it_bom(v_idx_bom).qta;
 
                END IF;
 
            -- STG_ITEM
            --      FATHER
            v_idx_itm   :=  it_bom(v_idx_bom).father_code;
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                v_row_itm.org_code      :=  x.org_code;
                v_row_itm.item_code     :=  it_bom(v_idx_bom).father_code;
                v_row_itm.description   :=  NVL(Pkg_Lib.f_table_value(it_line, 5, 0), 'NULL')
                                            || ' ' ||NVL(Pkg_Lib.f_table_value(it_line, 7, ''), '');
                v_row_itm.puom          :=  'PA';
                v_row_itm.make_buy      :=  'P';
                v_row_itm.flag_size     :=  -1;
                v_row_itm.flag_colour   :=  0;
                v_row_itm.flag_range    :=  0;
                v_row_itm.start_size    :=  NULL;
                v_row_itm.end_size      :=  NULL;
                v_row_itm.oper_code     :=  NULL;
                v_row_itm.file_id       :=  p_file_id;
 
                it_itm(v_idx_itm)       :=  v_row_itm;
 
            END IF;
 
            --      CHILD
            v_idx_itm       :=  it_bom(v_idx_bom).child_code;
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                v_row_itm.org_code      :=  x.org_code;
                v_row_itm.item_code     :=  it_bom(v_idx_bom).child_code;
                v_row_itm.description   :=  Pkg_Lib.f_table_value(it_line, 9, 'NULL')
                                        || ' ' ||Pkg_Lib.f_table_value(it_line, 11, '');
                v_row_itm.puom          :=  f_transform_uom(x.org_code,Pkg_Lib.f_table_value(it_line, 14, ''));
                v_row_itm.make_buy      :=  'A';
                v_row_itm.flag_colour   :=  0;
                v_row_itm.oper_code     :=  NULL;
                v_row_itm.file_id       :=  p_file_id;
                v_row_itm.start_size    :=  NULL;
                v_row_itm.end_size      :=  NULL;
 
                IF v_flag_range THEN
                    v_row_itm.flag_range    :=  -1;
                    v_row_itm.start_size    :=  Pkg_Lib.f_table_value(it_line, 12, NULL);
                    v_row_itm.end_size      :=   Pkg_Lib.f_table_value(it_line, 12, NULL);
                    v_row_itm.flag_size     :=  0;
                ELSIF Pkg_Lib.f_table_value(it_line, 12, NULL) IS NOT NULL THEN
                    v_row_itm.flag_range    :=  0;
                    v_row_itm.flag_size     :=  -1;
                ELSE
                    v_row_itm.flag_range    :=  0;
                    v_row_itm.flag_size     :=  0;
                END IF;
 
                -- load in memory
                it_itm(v_idx_itm)       :=  v_row_itm;
            END IF;
 
            -- if the child is range controlled, modify its start-end limits
            IF v_flag_range  THEN
                IF Pkg_Lib.f_table_value(it_line, 12, '99') < it_itm(v_idx_itm).start_size THEN
                    it_itm(v_idx_itm).start_size    :=  Pkg_Lib.f_table_value(it_line, 12, '??');
                END IF;
                IF Pkg_Lib.f_table_value(it_line, 12, '00') > it_itm(v_idx_itm).end_size THEN
                    it_itm(v_idx_itm).end_size      :=  Pkg_Lib.f_table_value(it_line, 12, '??');
                END IF;
            END IF;
 
        END IF; -- exclude ND
 
    END LOOP;
 
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert in STG_BOM
    v_idx_bom   :=  it_bom.FIRST;
    WHILE v_idx_bom IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_bom_std_iud('I', it_bom(v_idx_bom));
        v_idx_bom       :=  it_bom.NEXT(v_idx_bom);
    END LOOP;
 
    -- update the file status to processed
    v_row_fil.flag_processed    :=  -1;
    Pkg_Iud.p_stg_file_manager_iud('U', v_row_fil);
 
    COMMIT;
 
    -- try to VALIDATE
    Pkg_Stage.p_validate_bom    (p_file_id);
    Pkg_Stage.p_validate_item   (p_file_id);
 
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM)||v_line_seq||' '||v_qta_str);
END;
 

 PROCEDURE p_process_bom_ruco     (   p_file_id       NUMBER)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    process the file informations and loads them in intermediare tables
--              (STG_BOM, STG_ITEM)
-----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (p_file_id  NUMBER)
                    IS
                    SELECT      *
                    FROM        IMPORT_TEXT_FILE
                    ----------------------------------------------
                    WHERE       file_id             =   p_file_id
                        AND     line_seq            >   1
                    ORDER BY    line_seq
                    ;
 
    CURSOR C_EXPL   (p_line_text    VARCHAR2)
                    IS
                    SELECT  ROWNUM      col_seq,
                            txt01       col_text
                    -------------------------------------------------
                    FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_line_text,'|', -1))
                    ;
 
    CURSOR C_EX_ITM_STG (p_org_code VARCHAR2, p_item_code VARCHAR2)
                        IS
                        SELECT      1
                        FROM        STG_ITEM    i
                        WHERE       org_code    =   p_org_code
                            AND     item_code   =   p_item_code
                        ;
 
    v_idx_bom       VARCHAR2(50);
    it_bom          Pkg_Rtype.tas_stg_bom_std;   -- stg_bom_std
    it_itm          Pkg_Rtype.tas_stg_item;      -- stg_item
    v_idx_itm       VARCHAR2(50);
    v_row_itm       STG_ITEM%ROWTYPE;
    it_line         Pkg_Glb.typ_string;
    it_fase         Pkg_Glb.typ_string;
    v_err           VARCHAR2(1000);
    v_found         BOOLEAN;
    v_test          PLS_INTEGER;
    v_row_fil       STG_FILE_MANAGER%ROWTYPE;
    it_exc          Pkg_Glb.typ_varchar_varchar;
    V_FLAG_RANGE    BOOLEAN;
    v_child_code    VARCHAR2(50);
    v_father_code   VARCHAR2(50);
    v_line_seq      number;
    v_qta_str       varchar2(250);
    v_row_stg       VW_STG_BOM_RUCO%ROWTYPE;
    v_row_stg_new   VW_STG_BOM_RUCO%ROWTYPE;
    
BEGIN
  
  EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,'' ';    
  
    --  get the file row from STG_FILE_MANAGER ,
    --  verify if it was already loaded
    v_row_fil.idriga    :=  p_file_id;
    Pkg_Get.p_get_stg_file_manager(v_row_fil);
    IF v_row_fil.flag_processed = -1 THEN
        Pkg_Lib.p_rae('Fisierul cu id = '||p_file_id||' a mai fost procesat anterior!');
    END IF;
 
    delete from VW_STG_BOM_RUCO;

    /* Step 1: split the file lines into source columns (source format) */
    FOR x IN C_LINES(p_file_id)
    LOOP
        v_row_stg   := v_row_stg_new;
    
        it_line.DELETE;
        FOR xx IN C_EXPL (x.line_text)
        LOOP
            it_line(xx.col_seq)     :=  xx.col_text;
        END LOOP;
 
        v_row_stg.org_code          :=  v_row_fil.org_code;
        v_row_stg.fth_item_code     :=  Pkg_Lib.f_table_value(it_line, 4, '');
        v_row_stg.fth_description   :=  Pkg_Lib.f_table_value(it_line, 5, '');
        v_row_stg.fth_colour_code   :=  Pkg_Lib.f_table_value(it_line, 6, NULL);
        v_row_stg.fth_colour_desc   :=  Pkg_Lib.f_table_value(it_line, 7, NULL);
        v_row_stg.chl_item_code     :=  Pkg_Lib.f_table_value(it_line, 8, NULL);
        v_row_stg.chl_description   :=  Pkg_Lib.f_table_value(it_line, 9, NULL);
        v_row_stg.chl_colour_code   :=  Pkg_Lib.f_table_value(it_line, 10, NULL);
        v_row_stg.chl_colour_desc   :=  Pkg_Lib.f_table_value(it_line, 11, NULL);
        v_row_stg.fth_size_code     :=  Pkg_Lib.f_table_value(it_line, 12, NULL);
        v_row_stg.chl_size_code     :=  Pkg_Lib.f_table_value(it_line, 13, NULL);
        v_row_stg.chl_uom_code      :=  Pkg_Lib.f_table_value(it_line, 14, NULL);
        v_row_stg.chl_unit_qty      :=  Pkg_Lib.f_table_value(it_line, 15, NULL);
        v_row_stg.note_1            :=  Pkg_Lib.f_table_value(it_line, 16, NULL);
        v_row_stg.note_2            :=  Pkg_Lib.f_table_value(it_line, 17, NULL);
        v_row_stg.segment_code      :=  'VW_STG_BOM_RUCO';
        
        -- replace ",5" with "M" for size coding standards
        v_row_stg.fth_size_code := replace(v_row_stg.fth_size_code, ',5', 'M');
        v_row_stg.chl_size_code := replace(v_row_stg.chl_size_code, ',5', 'M');
        v_row_stg.fth_size_code := replace(v_row_stg.fth_size_code, '.5', 'M');
        v_row_stg.chl_size_code := replace(v_row_stg.chl_size_code, '.5', 'M');
        
        INSERT INTO VW_STG_BOM_RUCO VALUES v_row_stg;
        
    END LOOP;

    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '',.'' ';

    /* Step 2: insert in stage structures */
    INSERT INTO STG_ITEM 
        (   file_id, org_code, item_code, description, puom, make_buy,
            flag_size, flag_range, flag_colour, start_size, end_size, oper_code)
    SELECT p_file_id, org_code, 
        replace(fth_item_code, '-', '/')
        || (CASE WHEN fth_colour_code is not null then '/' || fth_colour_code end),
        max(fth_description)||' '||max(fth_colour_desc), 'PA', 'P',
        -1, 0, 0, NULL, NULL, NULL  
    from VW_STG_BOM_RUCO
    group by org_code, fth_item_code, fth_colour_code;
    

    INSERT INTO STG_ITEM 
        (   file_id, org_code, item_code, description, puom, make_buy,
            flag_size, flag_range, flag_colour, start_size, end_size, oper_code)
    WITH child_item as
        (select org_code, chl_item_code, chl_colour_code, 
            max(chl_description) chl_description, 
            max(chl_colour_desc) chl_colour_desc,
            min(fth_size_code) min_fth_size_code, 
            max(fth_size_code) max_fth_size_code,
            max(chl_unit_qty) chl_unit_qty,
            max(CHL_UOM_CODE) CHL_UOM_CODE,
            (case when is_range = 1 then chl_size_code else null end) range_size
        from(
            select v.*,
                max(case when chl_size_code <> fth_size_code then 1 else 0 end) 
                    over (partition by org_code, chl_item_code) is_range
            from VW_STG_BOM_RUCO v
            )
        group by org_code, chl_item_code, chl_colour_code, 
            (case when is_range = 1 then chl_size_code else null end)
            )
    SELECT p_file_id, org_code, 
        REPLACE(chl_item_code,'-', '/')
            || (CASE WHEN range_size is not null then '/'||range_size end)
            || (CASE WHEN chl_colour_code is not null then '/' || chl_colour_code end),
        chl_description||' '||chl_colour_desc description, 
        CHL_UOM_CODE, 'A', 
        (CASE WHEN range_size is null and min_fth_size_code is not null then -1 else 0 end) flag_size,
        (CASE WHEN range_size is not null then -1 else 0 end) flag_range, 
        0, 
        (CASE WHEN range_size is not null then min_fth_size_code end) start_size, 
        (CASE WHEN range_size is not null then max_fth_size_code end) end_size, 
        NULL oper_code
    from child_item c;
    

    INSERT INTO STG_BOM_STD 
        (   file_id, org_code, father_code, child_code, qta, qta_std, uom, note
        )
    SELECT p_file_id fff, v.org_code, sf.item_code father_code, sc.item_code child_code,
        sum(chl_unit_qty) / count(1) qta, sum(chl_unit_qty) / count(1) qta_std,
        max(sc.puom) uom, max(note_1||note_2) note
        FROM VW_STG_BOM_RUCO v
        INNER JOIN STG_ITEM sf 
            ON sf.file_id = p_file_id
            and sf.item_code = replace(v.fth_item_code, '-', '/')
                || (case when v.fth_colour_code is not null then '/' ||v.fth_colour_code end)
        INNER JOIN STG_ITEM sc 
            ON sc.file_id = p_file_id
            and sc.item_code like   replace(v.chl_item_code, '-', '/')||'%'
            and sc.item_code in (   replace(v.chl_item_code, '-', '/'), 
                                    replace(v.chl_item_code, '-', '/')||'/'||v.chl_size_code,
                                    replace(v.chl_item_code, '-', '/')||'/'||v.chl_colour_code,
                                    replace(v.chl_item_code, '-', '/')||'/'||v.chl_size_code||'/'||v.chl_colour_code
                                    )
        GROUP BY v.org_code, sf.item_code, sc.item_code;
        
  
    -- update the file status to processed
    v_row_fil.flag_processed    :=  -1;
    Pkg_Iud.p_stg_file_manager_iud('U', v_row_fil);
 
 --insert into xxx select * from VW_STG_BOM_RUCO;
 
    COMMIT;
 
    -- try to VALIDATE
    Pkg_Stage.p_validate_bom    (p_file_id);
    Pkg_Stage.p_validate_item   (p_file_id);
 
 
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM)||v_line_seq||' '||v_qta_str);
END;







 
END;

/

/
