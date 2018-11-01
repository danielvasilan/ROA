--------------------------------------------------------
--  DDL for Package Body PKG_WEB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_WEB" 
AS

CURSOR C_TEST           IS SELECT * FROM TABLE(Pkg_App_Secur.f_sk_app_user ()); 
CURSOR C_LONG           IS SELECT * FROM TABLE(Pkg_Ac_Faio.f_sql_fixed_asset (NULL,NULL,NULL));

FUNCTION f_decode_type(p_type INT) RETURN VARCHAR2
IS
    v_rez   VARCHAR2(20);
BEGIN
    CASE p_type
        WHEN    0   THEN    v_rez   := '"string"';
        WHEN    1   THEN    v_rez   := '"float"';
        WHEN    2   THEN    v_rez   := '"date"';
    END CASE;

    RETURN v_rez;
END;

--------------------------------------------------------------------------------------------------------
--  02.08.2007 d Creation date 
--------------------------------------------------------------------------------------------------------
FUNCTION f_decode_yesno(p_type VARCHAR2) RETURN VARCHAR2
IS
    v_rez   VARCHAR2(20);
BEGIN
    CASE p_type
        WHEN    'Y'   THEN    v_rez   := '"true"';
        WHEN    'N'   THEN    v_rez   := '"false"';
    END CASE;

    RETURN v_rez;
END;


--------------------------------------------------------------------------------------------------------
--  27.08.2007 d Creation date 
--------------------------------------------------------------------------------------------------------
FUNCTION f_decode_filter_value(p_source_type VARCHAR2, p_source_value VARCHAR2) RETURN VARCHAR2
--------------------------------------------------------------------------------------------------------
--  returns the result of the p_source_value expression  
--------------------------------------------------------------------------------------------------------

IS
    v_rez   VARCHAR2(200);
    vc      Pkg_Global.ref_cursor;
BEGIN
    CASE p_source_type 
        WHEN    'C' THEN    v_rez   :=  p_source_value;
        WHEN    'O' THEN    OPEN vc FOR p_source_value; FETCH vc INTO v_rez; CLOSE vc; 
        ELSE                v_rez   :=  '???';
    END CASE;
    RETURN v_rez;

EXCEPTION WHEN OTHERS THEN 
    RETURN '?ERROR?';
END;

PROCEDURE p_transform_frm_table (   p_row               C_TEST%ROWTYPE, 
                                    it          IN OUT  Pkg_Global.t_a_varchar_varchar)
IS
BEGIN
    it.DELETE;
    
    it('IDRIGA'):= p_row.idriga;
    it('DCN')   :=  p_row.dcn;
    it('SEQ_NO'):=  p_row.seq_no;

    it('TXT01') :=  p_row.TXT01;
    it('TXT02') :=  p_row.TXT02;
    it('TXT03') :=  p_row.TXT03;
    it('TXT04') :=  p_row.TXT04;
    it('TXT05') :=  p_row.TXT05;
    it('TXT06') :=  p_row.TXT06;
    it('TXT07') :=  p_row.TXT07;
    it('TXT08') :=  p_row.TXT08;
    it('TXT09') :=  p_row.TXT09;
    it('TXT10') :=  p_row.TXT10;
    it('TXT11') :=  p_row.TXT11;
    it('TXT12') :=  p_row.TXT12;
    it('TXT13') :=  p_row.TXT13;
    it('TXT14') :=  p_row.TXT14;
    it('TXT15') :=  p_row.TXT15;
    it('TXT16') :=  p_row.TXT16;
    it('TXT17') :=  p_row.TXT17;
    it('TXT18') :=  p_row.TXT18;
    it('TXT19') :=  p_row.TXT19;
    it('TXT20') :=  p_row.TXT20;

    it('NUMB01') := p_row.NUMB01;
    it('NUMB02') := p_row.NUMB02;
    it('NUMB03') := p_row.NUMB03;
    it('NUMB04') := p_row.NUMB04;
    it('NUMB05') := p_row.NUMB05;
    it('NUMB06') := p_row.NUMB06;
    it('NUMB07') := p_row.NUMB07;
    it('NUMB08') := p_row.NUMB08;
    it('NUMB09') := p_row.NUMB09;
    it('NUMB10') := p_row.NUMB10;
    it('NUMB11') := p_row.NUMB11;
    it('NUMB12') := p_row.NUMB12;
    it('NUMB13') := p_row.NUMB13;
    it('NUMB14') := p_row.NUMB14;
    it('NUMB15') := p_row.NUMB15;
    it('NUMB16') := p_row.NUMB16;
    it('NUMB17') := p_row.NUMB17;
    it('NUMB18') := p_row.NUMB18;
    it('NUMB19') := p_row.NUMB19;
    it('NUMB20') := p_row.NUMB20;

    it('DATA01') := TO_CHAR(p_row.DATA01,'dd/mm/yyyy');
    it('DATA02') := p_row.DATA02;
    it('DATA03') := p_row.DATA03;
    it('DATA04') := p_row.DATA04;
    it('DATA05') := p_row.DATA05;
    it('DATA06') := p_row.DATA06;
    it('DATA07') := p_row.DATA07;
    it('DATA08') := p_row.DATA08;
    it('DATA09') := p_row.DATA09;
    it('DATA10') := p_row.DATA10;

END;

PROCEDURE p_transform_frm_table (   p_row               C_LONG%ROWTYPE, 
                                    it          IN OUT  Pkg_Global.t_a_varchar_varchar)
IS
BEGIN
    it.DELETE;
    
    it('IDRIGA'):=  p_row.idriga;
    it('DCN')   :=  p_row.dcn;
    it('SEQ_NO'):=  p_row.seq_no;

    it('TXT01') :=  p_row.TXT01;
    it('TXT02') :=  p_row.TXT02;
    it('TXT03') :=  p_row.TXT03;
    it('TXT04') :=  p_row.TXT04;
    it('TXT05') :=  p_row.TXT05;
    it('TXT06') :=  p_row.TXT06;
    it('TXT07') :=  p_row.TXT07;
    it('TXT08') :=  p_row.TXT08;
    it('TXT09') :=  p_row.TXT09;
    it('TXT10') :=  p_row.TXT10;
    it('TXT11') :=  p_row.TXT11;
    it('TXT12') :=  p_row.TXT12;
    it('TXT13') :=  p_row.TXT13;
    it('TXT14') :=  p_row.TXT14;
    it('TXT15') :=  p_row.TXT15;
    it('TXT16') :=  p_row.TXT16;
    it('TXT17') :=  p_row.TXT17;
    it('TXT18') :=  p_row.TXT18;
    it('TXT19') :=  p_row.TXT19;
    it('TXT20') :=  p_row.TXT20;
    it('TXT21') :=  p_row.TXT21;
    it('TXT22') :=  p_row.TXT22;
    it('TXT23') :=  p_row.TXT23;
    it('TXT24') :=  p_row.TXT24;
    it('TXT25') :=  p_row.TXT25;
    it('TXT26') :=  p_row.TXT26;
    it('TXT27') :=  p_row.TXT27;
    it('TXT28') :=  p_row.TXT28;
    it('TXT29') :=  p_row.TXT29;
    it('TXT30') :=  p_row.TXT30;
    it('TXT31') :=  p_row.TXT31;
    it('TXT32') :=  p_row.TXT32;
    it('TXT33') :=  p_row.TXT33;
    it('TXT34') :=  p_row.TXT34;
    it('TXT35') :=  p_row.TXT35;
    it('TXT36') :=  p_row.TXT36;
    it('TXT37') :=  p_row.TXT37;
    it('TXT38') :=  p_row.TXT38;
    it('TXT39') :=  p_row.TXT39;
    it('TXT40') :=  p_row.TXT40;


    it('NUMB01') := p_row.NUMB01;
    it('NUMB02') := p_row.NUMB02;
    it('NUMB03') := p_row.NUMB03;
    it('NUMB04') := p_row.NUMB04;
    it('NUMB05') := p_row.NUMB05;
    it('NUMB06') := p_row.NUMB06;
    it('NUMB07') := p_row.NUMB07;
    it('NUMB08') := p_row.NUMB08;
    it('NUMB09') := p_row.NUMB09;
    it('NUMB10') := p_row.NUMB10;
    it('NUMB11') := p_row.NUMB11;
    it('NUMB12') := p_row.NUMB12;
    it('NUMB13') := p_row.NUMB13;
    it('NUMB14') := p_row.NUMB14;
    it('NUMB15') := p_row.NUMB15;
    it('NUMB16') := p_row.NUMB16;
    it('NUMB17') := p_row.NUMB17;
    it('NUMB18') := p_row.NUMB18;
    it('NUMB19') := p_row.NUMB19;
    it('NUMB20') := p_row.NUMB20;

    it('DATA01') := TO_CHAR(p_row.DATA01,'dd/mm/yyyy');
    it('DATA02') := p_row.DATA02;
    it('DATA03') := p_row.DATA03;
    it('DATA04') := p_row.DATA04;
    it('DATA05') := p_row.DATA05;
    it('DATA06') := p_row.DATA06;
    it('DATA07') := p_row.DATA07;
    it('DATA08') := p_row.DATA08;
    it('DATA09') := p_row.DATA09;
    it('DATA10') := p_row.DATA10;

END;


/*************************************************************************************************
    05/07/2007d  Creation date 

*************************************************************************************************/
/*
FUNCTION f_lov (p_frm_name VARCHAR2, p_ctl_name VARCHAR2) RETURN typ_frm pipelined
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
IS

    CURSOR C_LOV            (p_client_code VARCHAR2, p_frm_name VARCHAR2, p_ctl_name VARCHAR2)
                            IS
                            SELECT      lov_function
                            FROM        APP_LOV_SETUP
                            WHERE       lov_type        =   'FORM'
                                AND     lov_form_name   =   p_frm_name
                                AND     lov_control_name=   p_ctl_name
                            ;


    v_row                   tmp_frm     := tmp_frm();
    v_found                 BOOLEAN     := TRUE;
    v_sql                   VARCHAR2(1000);
    v_cursor                Pkg_Global.ref_cursor;
    v_txt01                 VARCHAR2(500);
    v_txt02                 VARCHAR2(500);
    v_client_code           APP_CLIENT.client_code%TYPE;

BEGIN

    v_client_code           :=  Pkg_Lib.f_return_client_code();

    v_row.txt01             :=  '<userList> <recCount> 0 </recCount> <recordDefinition> <IDX header="IDX" /> <DESCRIPTION header="DESCRIPTION" /> </recordDefinition> ';
    pipe ROW(v_row);

    v_row.txt01             :=  '<data>';
    PIPE ROW(v_row);

    OPEN C_LOV( v_client_code, p_frm_name, p_ctl_name); FETCH C_LOV INTO v_sql; v_found := C_LOV%FOUND; CLOSE C_LOV; 
    IF v_found THEN
        v_sql   := 'select txt01, txt02 from table(' || v_sql || '(''''))';
        OPEN v_cursor FOR v_sql;
        LOOP
            FETCH v_cursor INTO v_txt01, v_txt02;            
            v_found :=  v_cursor%FOUND;
            EXIT WHEN NOT V_found;
            v_row.txt01     :=  '<LOV> <IDX> ' || v_txt01 || '</IDX> <DESCRIPTION> ' || v_txt02 || ' </DESCRIPTION> </LOV> '; 
            PIPE ROW(v_row);
        END LOOP;

    END IF;

    v_row.txt01             :=  '</data> </userList>';
    PIPE ROW(v_row);

    RETURN;
END;
*/



/*************************************************************************************************
    05/07/2007d  Creation date 

*************************************************************************************************/
FUNCTION f_xml_lov (p_sql   VARCHAR2) RETURN typ_frm pipelined
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
IS

    v_row                   tmp_frm     := tmp_frm();
    v_found                 BOOLEAN     := TRUE;
    v_sql                   VARCHAR2(1000);
    v_cursor                Pkg_Global.ref_cursor;
    v_txt01                 VARCHAR2(500);
    v_txt02                 VARCHAR2(500);
    v_client_code           VARCHAR2(30);

BEGIN

    v_row.txt01             :=  '<userList> <recCount> 0 </recCount> <recordDefinition> <IDX header="IDX" /> <DESCRIPTION header="DESCRIPTION" /> </recordDefinition> ';
    pipe ROW(v_row);

    v_row.txt01             :=  '<data>';
    PIPE ROW(v_row);

    v_sql   := 'select txt01, txt02 from table(' || p_sql || ')';

    Pkg_App_Tools.P_Log('L',v_sql,'');

    OPEN v_cursor FOR v_sql;
    LOOP
        FETCH v_cursor INTO v_txt01, v_txt02;            
        v_found :=  v_cursor%FOUND;
        EXIT WHEN NOT V_found;
        v_row.txt01     :=  '<LOV> <IDX> ' || v_txt01 || '</IDX> <DESCRIPTION> ' || v_txt02 || ' </DESCRIPTION> </LOV> '; 
        PIPE ROW(v_row);
    END LOOP;

    v_row.txt01             :=  '</data> </userList>';
    PIPE ROW(v_row);

    RETURN;
END;


/*************************************************************************************************
    14/08/2008 d  Creation date 
*************************************************************************************************/
FUNCTION f_json_lov_filter  (   p_lov_ctl   VARCHAR2,
                                p_ref_frm   VARCHAR2
                            )   RETURN      typ_cmb pipelined
--------------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------------
IS

    CURSOR C_SQL            IS
                            SELECT      lov_function
                            FROM        APP_LOV_SETUP
                            WHERE       lov_form_name   =   'FRM_FILTER'
                                AND     lov_control_name=   p_lov_ctl
                                AND     object_id1         =   p_ref_frm
                            ;
    
    CURSOR c IS SELECT TXT01,txt02 FROM TMP_GENERAL;
    v_row                   tmp_cmb     := tmp_cmb();
    v_row_data              c%ROWTYPE;
    v_cursor                Pkg_Global.ref_cursor;
    v_index                 INTEGER;
    v_rez                   VARCHAR2(4000);
    v_rowcount              INTEGER := 0;
    v_sql                   VARCHAR2(1000);

BEGIN

    v_rez           :=  '{ "rows":[';

    OPEN C_SQL; FETCH C_SQL INTO v_sql; CLOSE C_SQL;

    IF v_sql IS NOT NULL THEN 
    
        v_sql           := 'select txt01,txt02 from table(cast('||v_sql||' as typ_cmb))';
    
        OPEN v_cursor FOR v_sql; 
    
        LOOP
            FETCH v_cursor INTO v_row_data;
            EXIT WHEN v_cursor%NOTFOUND;
            v_rowcount  := v_rowcount + 1;    
            EXIT WHEN (v_rowcount > 1000);
            
            -- return row if the LENGTH is too high 
            -- !!! this statement MUST remain HERE !!! don't move it after the v_rez SET 
            IF LENGTH(v_rez) > 3000 THEN 
                v_row.txt01 := v_rez;
                PIPE ROW(v_row);
                v_rez       := '';
            END IF;
    
            v_rez   := v_rez || Pkg_Global.C_NL || '{value:"' || v_row_data.txt01 || '", description:"' || v_row_data.txt02||'"},';
    
        END LOOP;
    
        CLOSE v_cursor;
        -- eliminate the last comma 
        v_rez   := SUBSTR(v_rez,1,LENGTH(v_rez)-1);
    
    END IF;
    
    v_rez             := v_rez || ']}';
    
    v_row.txt01 := v_rez;
    PIPE ROW(v_row);
        
    RETURN;
--EXCEPTION WHEN OTHERS THEN Pkg_Lib.p_rae(0,SQLERRM);
END;



/*************************************************************************************************
    04/10/2007 d  Creation DATE 

*************************************************************************************************/
FUNCTION f_json_form    (   p_grid_name     VARCHAR2, 
                            p_parameters    VARCHAR2, 
                            p_flag_meta     VARCHAR2,
                            p_max_records   INTEGER,
                            p_start_record  INTEGER
                        )   RETURN          typ_longinfo    pipelined
--------------------------------------------------------------------------------------------------
--  PURPOSE:    returns in TXT01 a multiline json formatted string with the meta information 
--              for a grid and the data that match the parameters
--  INPUT:      GRID_NAME   =   name of the grid 
--              PARAMETERS  =   comma separated list of parameters. 
--                              are used when the data for the grid is fetched by the sql function 
--              FLAG_META   =   if Y the meta information is sent 
--              MAX_RECORDS =   maximum number of records fetched (will appear in the page) 
--              START_RECORD=   first record to be fetched       
--------------------------------------------------------------------------------------------------
IS

    CURSOR C_CTL            (p_client_code VARCHAR2, p_grid_code VARCHAR2)
                            IS
                            SELECT      c.*,
                                        l.lov_function
                            FROM        WEB_GRID_CM         c
                            LEFT JOIN   APP_LOV_SETUP       l   ON  l.client_code         =   c.client_code
                                                                AND l.lov_form_name       =   c.grid_name
                                                                AND l.lov_control_name    =   c.control_name
                            WHERE       c.client_code       =   p_client_code
                                AND     c.grid_name         =   p_grid_code
                            ORDER BY    c.seq_no 
                            ;


    CURSOR C_GRID           (p_client_code VARCHAR2, p_grid_name VARCHAR2)
                            IS
                            SELECT      grid_name, caption, note, oracle_table, download_function, ret_type
                            FROM        WEB_GRID
                            WHERE       grid_name       =   p_grid_name
                                AND     client_code     =   p_client_code
                            ;

    CURSOR C_LOV            (p_client_code  VARCHAR2, p_form_name VARCHAR2, p_control_name VARCHAR2)
                            IS
                            SELECT      lov_function
                            FROM        APP_LOV_SETUP
                            WHERE       client_code         =   p_client_code
                                AND     lov_form_name       =   p_form_name
                                AND     lov_control_name    =   p_control_name
                            ;

    CURSOR C_FILTER         (p_client_code VARCHAR2, p_form_name VARCHAR2)
                            IS
                            SELECT      f.form_name, f.filter_order, f.filter_label, f.filter_type,
                                        f.user_editable, f.source_type, f.source_value, l.lov_function
                            FROM        
                                        APP_FORM_FILTER     f,
                                        APP_LOV_SETUP       l
                            WHERE       
                                        f.client_code       =   l.client_code   (+)
                                AND     f.form_name         =   l.object_id1    (+)
                                AND     f.client_code       =   p_client_code       
                                AND     f.form_name         =   p_form_name
                                AND     l.lov_type   (+)    =   'FILTER'                              
                            ;

    v_client_code           VARCHAR2(30);
    v_row                   tmp_longinfo     := tmp_longinfo();
    v_found                 BOOLEAN     := TRUE;
    it_ctl                  Pkg_Global.t_a_varchar_varchar;
    it_ctlord               Pkg_Global.t_a_varchar_integer;
    v_row_grid              C_GRID%ROWTYPE;
    v_row_data_f            C_TEST%ROWTYPE;
    v_row_data_l            C_LONG%ROWTYPE;
    it_data                 Pkg_Global.t_a_varchar_varchar;
    v_sql                   VARCHAR2(2000);
    v_cursor                Pkg_Global.ref_cursor;
    v_index                 INTEGER;
    v_lov_select            VARCHAR2(500);
    v_rez                   VARCHAR2(4000);
    v_value                 VARCHAR2(1000);
    v_rowcount              INTEGER := 0;

BEGIN

    v_client_code           :=  NVL(Pkg_Lib.f_return_client_code(), 'FTY');

    v_rez                   :=  '{';

    ---------------------------------------------------------------------------------------------------------------------    
    -- META DATA 
    ---------------------------------------------------------------------------------------------------------------------
    IF (p_flag_meta = 'Y') THEN
        v_rez       :=  v_rez || '"metaData":{'||Pkg_Glb.C_NL;
        v_rez       :=  v_rez || '"root":"rows",'||Pkg_Glb.C_NL;
        v_rez       :=  v_rez || '"id":0,'||Pkg_Glb.C_NL;
        v_rez       :=  v_rez || '"totalProperty":"totalCount",'||Pkg_Glb.C_NL;

        v_rez       :=  v_rez || '"fields":['||Pkg_Glb.C_NL;

        FOR x IN C_CTL  (v_client_code, p_grid_name)
        LOOP

            IF LENGTH(v_rez) > 3500 THEN 
                v_row.txt01 := v_rez;
                PIPE ROW(v_row);
                v_rez       := '';
            END IF;

            it_ctl(UPPER(x.controlsource))  :=  x.control_name;
            it_ctlord(C_CTL%rowcount) := UPPER(x.controlsource);

            v_rez   :=  v_rez || '{ "name":"'||x.control_name||'", "header":"'||x.caption||'", ';
            v_rez   :=  v_rez || ' "align":"'||x.align||'", ';
            v_rez   :=  v_rez || ' "iseditable":"'||NVL(x.iseditable,'false')||'", ';

--            "locked":'||NVL(x.islocked,'false')||', ';
            v_rez   :=  v_rez || ' "width":' ||NVL(x.width,100)||', "hidden":'||NVL(x.ishidden,'false')||',';
/*
            IF (x.controlsource LIKE 'TXT%') THEN   v_rez := v_rez || ' "fieldtype":"0","type":"string",'; END IF;
            IF (x.controlsource LIKE 'NUMB%') THEN   v_rez := v_rez || ' "fieldtype":"1","type":"number",'; END IF;
            IF (x.controlsource LIKE 'DAT%') THEN   v_rez := v_rez || ' "fieldtype":"2","type":"date",'; END IF;
*/
            IF (x.controlsource LIKE 'TXT%') THEN   v_rez := v_rez || ' "fieldtype":"0",'; END IF;
            IF (x.controlsource LIKE 'NUMB%') THEN   v_rez := v_rez || ' "fieldtype":"1",'; END IF;
            IF (x.controlsource LIKE 'IDRIGA') THEN   v_rez := v_rez || ' "fieldtype":"1",'; END IF;
            IF (x.controlsource LIKE 'DAT%') THEN   v_rez := v_rez || ' "fieldtype":"2",'; END IF;
            v_rez   :=  v_rez || ' "renderer":' ||NVL(x.renderer,'""')||',';
            v_rez   :=  v_rez || ' "lov_function":"'||x.lov_function||'"';

--            v_rez   :=  v_rez || ' "fixed":' ||NVL(x.isfixed,'false');
            v_rez   :=  v_rez || '},'||Pkg_Global.C_NL;

       END LOOP;
        v_rez   := SUBSTR(v_rez,1,LENGTH(v_rez)-3)||Pkg_Global.C_NL;            

        v_rez := v_rez || ']},'||Pkg_Global.C_NL;

    END IF;

    v_row.txt01 :=  v_rez;
    pipe ROW    (v_row);
    v_rez       :='';

 
/*    ---------------------------------------------------------------------------------------------------------------------
    --  filter definition 
    ---------------------------------------------------------------------------------------------------------------------
    v_row.txt01     :=  ' <filter>'||CHR(10);
    FOR x IN C_FILTER(v_client_code, p_frm_name)
    LOOP
        v_row.txt01 := v_row.txt01 || ' <S'||x.filter_order||' caption="'||x.filter_label||'"';
        v_row.txt01 := v_row.txt01 || ' type=' ||f_decode_type(x.filter_type);
        v_row.txt01 := v_row.txt01 || ' editable=' ||f_decode_yesno(x.user_editable);
        v_row.txt01 := v_row.txt01 || ' lov_sql="' ||x.lov_function||'"';
        v_row.txt01 := v_row.txt01 || ' value="'||f_decode_filter_value(x.source_type, x.source_value)||'"'; 

        v_row.txt01 := v_row.txt01 || ' />'||CHR(10);

    END LOOP;
    v_row.txt01     :=  v_row.txt01 || ' </filter>'||CHR(10);
    pipe ROW(v_row);
*/
    ---------------------------------------------------------------------------------------------------------------------
    -- ROWS  
    ---------------------------------------------------------------------------------------------------------------------
    v_rez             := v_rez||' "rows":[  '||CHR(10);

    OPEN C_GRID  (v_client_code, p_grid_name); FETCH C_GRID INTO v_row_grid; v_found := C_GRID%FOUND; CLOSE C_GRID;
    IF v_found THEN
        v_sql := 'select * from table('||v_row_grid.download_function||'('|| p_parameters ||'))';
    
        OPEN v_cursor FOR v_sql; 

        Pkg_App_Tools.P_Log('L',v_sql,'');

        -- loop on the grid function 
        LOOP

 
            -- fetch in the proper v_row_data, depending on the return type of the function
            IF v_row_grid.ret_type = 'FRM' THEN
                FETCH v_cursor INTO v_row_data_f;
            ELSE
                FETCH v_cursor INTO v_row_data_l;
            END IF;
            v_found :=  v_cursor%FOUND;
            EXIT WHEN NOT v_found;
            v_rowcount  := v_rowcount + 1;    
--            EXIT WHEN (v_rowcount >= p_max_records+p_start_record);
            
            -- fetch only the records between p_start_record and p_start_record+p_max_records 
            IF v_rowcount BETWEEN p_start_record AND (p_start_record + p_max_records -1) THEN

                -- return row if the LENGTH is too high 
                -- !!! this statement MUST remain HERE !!! don't move it after the v_rez SET 
                IF LENGTH(v_rez) > 3000 THEN 
                    v_row.txt01 := v_rez;
                    PIPE ROW(v_row);
                    v_rez       := '';
                END IF;
                
                IF v_row_grid.ret_type = 'FRM' THEN
                    p_transform_frm_table(v_row_data_f, it_data);
                ELSE
                    p_transform_frm_table(v_row_data_l, it_data);
                END IF;    
    
                v_rez   := v_rez ||'{';
                v_index     := it_ctlord.FIRST;
                WHILE v_index IS NOT NULL 
                LOOP
                    
                    IF it_data.EXISTS(it_ctlord(v_index)) THEN 
                        v_value := TRANSLATE(it_data(it_ctlord(v_index)),'''"',' '); 
                    ELSE 
                        v_value := ''; 
                    END IF;
    
                    v_rez   := v_rez || ' "'||it_ctl(it_ctlord(v_index))||'": "'||v_value||'",'||Pkg_Global.C_NL;
                    v_index := it_ctlord.NEXT(v_index);
                END LOOP;
--                v_rez   :=  SUBSTR(v_rez,1,LENGTH(v_rez)-3);
                v_rez   :=  v_rez||' LINENO:'||v_rowcount;
                v_rez   :=  v_rez||'},'||Pkg_Global.C_NL;

            END IF; -- //   IF v_rowcount >= p_start_record

        END LOOP;
        CLOSE v_cursor;
        -- eliminate the last comma 
        v_rez   := SUBSTR(v_rez,1,LENGTH(v_rez)-3);

    END IF;

    Pkg_App_Tools.P_Log('L','AFTER'||LENGTH(v_rez),'');

    v_rez             := v_rez || ']';

    -- add the total count property 
    v_rez       :=v_rez || ',totalCount: '||v_rowcount||'}';
    
    v_row.txt01 := v_rez;
    PIPE ROW(v_row);

    RETURN;
--EXCEPTION WHEN OTHERS THEN Pkg_Lib.p_rae(0,SQLERRM);
END;





/*************************************************************************************************
    23/10/2007 d  Creation DATE 

*************************************************************************************************/
FUNCTION f_json_lov (p_sql VARCHAR2) RETURN typ_cmb pipelined
--------------------------------------------------------------------------------------------------
-- returns a JSON formated result from the p_SQL fetch 
--------------------------------------------------------------------------------------------------
IS

    CURSOR c IS SELECT TXT01,txt02 FROM TMP_GENERAL;
    v_row                   tmp_cmb     := tmp_cmb();
    v_row_data              c%ROWTYPE;
    v_cursor                Pkg_Global.ref_cursor;
    v_index                 INTEGER;
    v_rez                   VARCHAR2(4000);
    v_rowcount              INTEGER := 0;
    v_sql                   VARCHAR2(500);

BEGIN

    v_rez           :=  '{ "rows":[';
    v_sql           := 'select txt01,txt02 from table(cast('||p_sql||' as typ_cmb))';

    OPEN v_cursor FOR v_sql; 

    LOOP
        FETCH v_cursor INTO v_row_data;
        EXIT WHEN v_cursor%NOTFOUND;
        v_rowcount  := v_rowcount + 1;    
        EXIT WHEN (v_rowcount > 1000);
        
        -- return row if the LENGTH is too high 
        -- !!! this statement MUST remain HERE !!! don't move it after the v_rez SET 
        IF LENGTH(v_rez) > 3000 THEN 
            v_row.txt01 := v_rez;
            PIPE ROW(v_row);
            v_rez       := '';
        END IF;

        v_rez   := v_rez || Pkg_Global.C_NL || '{value:"' || v_row_data.txt01 || '", description:"' || v_row_data.txt02||'"},';
--        v_rez   := SUBSTR(v_rez,1,LENGTH(v_rez)-3);

    END LOOP;

    CLOSE v_cursor;
    -- eliminate the last comma 
    v_rez   := SUBSTR(v_rez,1,LENGTH(v_rez)-1);


    v_rez             := v_rez || ']}';
    
    v_row.txt01 := v_rez;
    PIPE ROW(v_row);

    RETURN;
--EXCEPTION WHEN OTHERS THEN Pkg_Lib.p_rae(0,SQLERRM);
END;

/***************************************************************************************
    DDL:    24/08/2008 d Create    
/***************************************************************************************/
PROCEDURE p_ora2mysql (p_flag_data VARCHAR2)
----------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------
IS
    CURSOR C_TBL    IS  
                    SELECT      table_name
                    FROM        user_tables
--                    WHERE       table_name IN ()
                    ORDER BY    table_name
                    ;
    CURSOR C_COL    (p_table_name VARCHAR2)
                    IS
                    SELECT      column_name,data_type, data_length, nullable,column_id
                    FROM        cols
                    WHERE       table_name  =   p_table_name
                    ORDER BY    column_id
                    ;

    v_sql           VARCHAR2(2000);
    v_dml           VARCHAR2(4000);
    v_data_type     VARCHAR2(20);
    v_colName       VARCHAR2(30);
    v_seq_no        NUMBER:=0;
    v_colNames      Pkg_Glb.typ_string;
    v_colValues     Pkg_Glb.typ_string;

 selcols      DBMS_SQL.DESC_TAB;
 v_nrcol      INTEGER; 
 v_cursor      INTEGER;    
    i                           INTEGER;
    fdbk                        INTEGER;
    v_num           NUMBER;
    v_text          CLOB;--VARCHAR2(2000);
    v_data          DATE;
    it_sql          Pkg_Glb.typ_string;

BEGIN

    DELETE FROM TMP_GENERAL;

    IF p_flag_data <> 'Y' THEN

        FOR x IN C_TBL
        LOOP
            v_sql := 'CREATE TABLE '||x.table_name||'(';
            FOR xx IN C_COL(x.table_name)
            LOOP
                IF LENGTH(v_sql) > 200 THEN
                    INSERT INTO TMP_GENERAL(txt50, numb01) VALUES(v_sql, v_seq_no);
                    v_sql := '';
                    v_seq_no := v_seq_no + 1;
                END IF;
    
                CASE xx.data_type
                    WHEN 'VARCHAR2' THEN    v_data_type :=  'varchar('||xx.data_length||')';
                    WHEN 'NUMBER'   THEN    v_data_type :=  'numeric';
                    WHEN 'CLOB'     THEN    v_data_type :=  'text';
                    ELSE                    v_data_type :=  LOWER(xx.data_type);
                END CASE;
                v_sql := v_sql||xx.column_name||' '||v_data_type||',';
            END LOOP;
            v_sql   :=  RTRIM(v_sql,',');
            v_sql   :=  v_sql ||');';
            INSERT INTO TMP_GENERAL(txt50,numb01) VALUES(v_sql,v_seq_no);
            v_seq_no := v_seq_no + 1;
        END LOOP;

    END IF;

    --***********************************************************************************
    -- DATA 
    --***********************************************************************************

    it_sql(1)   :=  'SELECT * FROM FIXED_ASSET';
    it_sql(2)   :=  'SELECT * FROM FIXED_ASSET_CATEG';
    it_sql(3)   :=  'SELECT * FROM FA_TRN';
    it_sql(4)   :=  'SELECT * FROM FA_TRN_TYPE';
    it_sql(5)   :=  'SELECT * FROM MULTI_TABLE';
    it_sql(6)   :=  'SELECT * FROM APP_LOV_SETUP';

    IF p_flag_data = 'Y' THEN

        v_sql := 'SELECT * FROM APP_LOV_SETUP';-- WHERE org_code = ''FTY'' '; 
        v_cursor := DBMS_SQL.OPEN_CURSOR;
     DBMS_SQL.PARSE(v_cursor, v_sql,1);
     DBMS_SQL.DESCRIBE_COLUMNS (v_cursor ,v_nrcol , selcols);

        FOR i IN 1..v_nrcol 
        LOOP
            CASE  selcols(i).col_type 
                WHEN 2 THEN DBMS_SQL.DEFINE_COLUMN (v_cursor, i,v_num);
                WHEN 1 THEN DBMS_SQL.DEFINE_COLUMN (v_cursor, i,v_text);
                WHEN 12 THEN DBMS_SQL.DEFINE_COLUMN (v_cursor, i,v_data);
                ELSE NULL;    
            END CASE;
        END LOOP;
    
        v_dml := '';
    
        fdbk:= DBMS_SQL.EXECUTE (v_cursor);
        LOOP
    
            EXIT WHEN DBMS_SQL.FETCH_ROWS (v_cursor) = 0;
            
            v_colValues.DELETE;
            v_colNames.DELETE;
            v_colNames(0) := ' INSERT INTO '||'APP_LOV_SETUP(';
            v_colValues(0) := ' VALUES(';
            FOR i IN 1..v_nrcol 
            LOOP
                CASE selcols(i).col_type 
                    WHEN 2 THEN 
                        DBMS_SQL.COLUMN_VALUE (v_cursor, i, v_num);
                        v_colValues(i)   :=  NVL(TRANSLATE(TO_CHAR(v_num),',','.'),'null');
                    WHEN 1 THEN 
                        DBMS_SQL.COLUMN_VALUE (v_cursor, i, v_text);
                        v_colValues(i)   :=  ''''||SUBSTR(v_text,1,2000)||'''';
                    WHEN 12 THEN 
                        DBMS_SQL.COLUMN_VALUE (v_cursor, i, v_data);
                        v_colValues(i)   :=  ''''||TO_CHAR(v_data,'yyyy/mm/dd')||'''';
                    ELSE 
                        v_colValues(i) := '???';
                END CASE;
    
                v_colNames(i)   :=  selcols(i).col_name;
                IF i <> v_nrcol THEN 
                    v_colNames(i)   :=  v_colNames(i)||',';
                    v_colValues(i)  :=  v_colValues(i)||',';
                ELSE
                    v_colNames(i)   :=  v_colNames(i)||')';
                    v_colValues(i)  :=  v_colValues(i)||');'; 
                END IF;
    
            END LOOP;
        
            -- load data in the table  
            FOR i IN v_colNames.FIRST .. v_colNames.LAST
            LOOP
                IF LENGTH(v_dml) > 2000 THEN 
                    INSERT INTO TMP_GENERAL (numb01,txt50) VALUES(v_seq_no,v_dml);
                    v_seq_no := v_seq_no + 1;
                    v_dml := '';
                END IF;
                v_dml := v_dml ||v_colNames(i);
            END LOOP;    

            FOR i IN v_colValues.FIRST .. v_colValues.LAST
            LOOP
                IF LENGTH(v_dml) > 2000 THEN 
                    INSERT INTO TMP_GENERAL (numb01,txt50) VALUES(v_seq_no,v_dml);
                    v_seq_no := v_seq_no + 1;
                    v_dml := '';
                END IF;
                v_dml := v_dml ||v_colValues(i);
                IF i = v_colValues.LAST THEN 
                    INSERT INTO TMP_GENERAL (numb01,txt50) VALUES(v_seq_no,v_dml);
                    v_seq_no := v_seq_no + 1;
                    v_dml := '';
                END IF;
            END LOOP;

        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(v_cursor);

    END IF;

--    v_row.txt01 := dbms_lob.SUBSTR(v_text,2000,1);
 --   pipe ROW(v_row);


    RETURN;


END;

END;

/

/
