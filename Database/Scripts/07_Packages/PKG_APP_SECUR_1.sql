--------------------------------------------------------
--  DDL for Package Body PKG_APP_SECUR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_APP_SECUR" 
AS
--------------------------------------------------------------------------------------------------
-- folosesc context pentru memorarea variabilelor de securitate
-- CREATE CONTEXT APP_SECUR_CONTEXT USING APP_GES_REF.pkg_app_secur
--------------------------------------------------------------------------------------------------

PROCEDURE p_login_user(p_user_code VARCHAR2, p_pwd VARCHAR2)
IS
    v_found   BOOLEAN;
    v_row_user  APP_USER%ROWTYPE;
BEGIN
     -- citesc linia user-ului
    v_row_user.user_code  :=  trim(UPPER(p_user_code));
    IF Pkg_Get2.f_get_app_user_2(v_row_user) THEN NULL; END IF;
    
    IF Pkg_Lib.f_mod_c(UPPER(p_pwd), UPPER(v_row_user.pwd)) THEN
        Pkg_Lib.p_rae('Parola eronata !');
    END IF;
   
    Pkg_Glb.gv_user_code   :=  v_row_user.user_code;     
END;

--------------------------------------------------------------------------------------
FUNCTION f_return_user RETURN VARCHAR2
IS
BEGIN
    RETURN Pkg_Glb.gv_user_code;
END;

---------------------------------------------------------------------------------------
FUNCTION f_return_numeuser RETURN VARCHAR2
IS
    v_row_user APP_USER%ROWTYPE;
BEGIN
    v_row_user.user_code :=  Pkg_Glb.gv_user_code ;  --sys_context('APP_SECUR_CONTEXT', 'USER_CODE');
    IF Pkg_Get2.f_get_app_user_2(v_row_user) THEN NULL; END IF;
    RETURN v_row_user.nume || ' ' || v_row_user.prenume;
EXCEPTION
    WHEN OTHERS THEN RETURN NULL;
END;

---------------------------------------------------------------------------------------
PROCEDURE p_logout_user
IS
BEGIN
    Pkg_Glb.gv_user_code  := NULL;
END;

---------------------------------------------------------------------------------------
FUNCTION f_return_menu RETURN VARCHAR2
IS
    CURSOR  C_MENU(p_selector VARCHAR2,p_user_code VARCHAR2)  IS
            SELECT  i.securitem_code
            FROM
                    APP_SECURITEM  i,
                    APP_USER_GRANT g
            WHERE
                    i.securitem_code    =   g.securitem_code
                AND g.user_code         =   p_user_code 
                AND g.flag_execute      =   -1
                AND i.securitem_type    = 'MENU'
                AND p_selector          =   '1'
            --
            UNION ALL
            --     
            SELECT  i.securitem_code
            FROM
                    APP_SECURITEM  i
            WHERE       i.securitem_type    = 'MENU'
                    AND p_selector          = '2'
            ;        
                
    v_rez           VARCHAR2(1000)      :='$';
    v_user_code     VARCHAR2(32000)     :=  Pkg_App_Secur.f_return_user();
    v_selector      VARCHAR2(32000) ;
    C_ADMN          VARCHAR2(32000)     :=  'ADMN';
BEGIN

    IF v_user_code = C_ADMN THEN
        v_selector :=   '2';
    ELSE
        v_selector :=   '1';
    END IF; 
    
    FOR x IN C_MENU(v_selector, v_user_code) LOOP
        v_rez := v_rez ||x.securitem_code ||'$';
    END LOOP;

    RETURN v_rez;
END;

-------------------------------------------------------------------------------------------
FUNCTION f_test_grant
  (p_securitem_code VARCHAR2, p_flag VARCHAR2,p_securitem_global VARCHAR2) RETURN INTEGER
--------------------------------------------------------------------------------------------
-- verific daca exista SECURITEM-ul asociat cu userul
-- SECURITEM_GLOBAL se ia in considerare daca nu exista definit primul parametru
--------------------------------------------------------------------------------------------
IS
    CURSOR C_GRANT  (p_securitem_code VARCHAR2)
    IS
        SELECT  *
        FROM    APP_USER_GRANT
        WHERE
                user_code = Pkg_App_Secur.f_return_user()
            AND securitem_code = p_securitem_code;

    CURSOR C_GET_SECIT (p_securitem_code VARCHAR2)
    IS
        SELECT  *
        FROM    APP_SECURITEM
        WHERE   securitem_code = p_securitem_code;

    v_row       C_GRANT%ROWTYPE;
    v_rez       PLS_INTEGER;
    v_row_secit APP_SECURITEM%ROWTYPE;
    v_found     BOOLEAN;

BEGIN

 -- verific daca este un utilizator cu drepturi de ADMIN
IF Pkg_App_Secur.f_return_user IN ('XXY', 'ADMN') THEN
    v_rez := -1;
ELSE
    -- testez daca exista SECURITEM-ul in sistem definit
    OPEN  C_GET_SECIT(p_securitem_code);
    FETCH  C_GET_SECIT INTO v_row_secit;
    v_found := C_GET_SECIT%FOUND;
    CLOSE  C_GET_SECIT;

    -- daca nu exista, testez SECURITEM-ul global
    IF NOT v_found THEN
        OPEN  C_GET_SECIT(p_securitem_global);
        FETCH  C_GET_SECIT INTO v_row_secit;
        v_found := C_GET_SECIT%FOUND;
        CLOSE  C_GET_SECIT;
    END IF;

    -- daca s-a gasit definit macar unul din SECURITEM-uri, testez drepturile
    IF v_found THEN
        OPEN C_GRANT (v_row_secit.securitem_code);
        FETCH C_GRANT INTO v_row;

        IF C_GRANT%NOTFOUND THEN
            v_rez := 0;
        ELSE
            CASE p_flag
                WHEN   'I' THEN v_rez := v_row.flag_insert;
                WHEN  'U' THEN v_rez := v_row.flag_update;
                WHEN   'D' THEN v_rez := v_row.flag_delete;
                WHEN  'X' THEN v_rez := v_row.flag_execute;
            END CASE;
        END IF;
        CLOSE C_GRANT;
    -- daca nu exista definitiile => returnez FALSE
    ELSE
        v_rez := -1;
    END IF;
END IF;

RETURN v_rez;

END;


--------------------------------------------------------------------------------------------
FUNCTION f_message_grant
        (p_securitem_code VARCHAR2, p_flag VARCHAR2,p_securitem_global VARCHAR2) RETURN VARCHAR2
--------------------------------------------------------------------------------------------
-- verific daca exista SECURITEM-ul asociat cu userul
-- SECURITEM_GLOBAL se ia in considerare daca nu exista definit primul parametru
-- returneaza mesajul de eroare daca nu este asociata functionalitatea sau
-- NULL daca utilizatorul are drepturi
--------------------------------------------------------------------------------------------
IS
    CURSOR C_GRANT  (p_securitem_code VARCHAR2)
    IS
        SELECT  *
        FROM    APP_USER_GRANT
        WHERE
                user_code = Pkg_App_Secur.f_return_user()
            AND securitem_code = p_securitem_code;

    CURSOR C_GET_SECIT (p_securitem_code VARCHAR2)
    IS
        SELECT  *
        FROM    APP_SECURITEM
        WHERE   securitem_code = p_securitem_code;

    v_row       C_GRANT%ROWTYPE;
    v_rez       VARCHAR2(500);
    v_row_secit APP_SECURITEM%ROWTYPE;
    v_found     BOOLEAN;
    v_grant     PLS_INTEGER := 0;

BEGIN

 -- verific daca este un utilizator cu drepturi de ADMIN
IF Pkg_App_Secur.f_return_user = 'ADMN' THEN
    v_grant := -1;
ELSE
    -- testez daca exista SECURITEM-ul in sistem definit
    OPEN  C_GET_SECIT(p_securitem_code);
    FETCH  C_GET_SECIT INTO v_row_secit;
    v_found := C_GET_SECIT%FOUND;
    CLOSE  C_GET_SECIT;

    -- daca nu exista, testez SECURITEM-ul global
    IF NOT v_found THEN
        OPEN  C_GET_SECIT(p_securitem_global);
        FETCH  C_GET_SECIT INTO v_row_secit;
        v_found := C_GET_SECIT%FOUND;
        CLOSE  C_GET_SECIT;
    END IF;

    -- daca s-a gasit definit macar unul din SECURITEM-uri, testez drepturile
    IF v_found THEN
        OPEN C_GRANT (v_row_secit.securitem_code);
        FETCH C_GRANT INTO v_row;

        IF C_GRANT%NOTFOUND THEN
            v_grant := 0;
        ELSE
            CASE p_flag
                WHEN    'I' THEN v_grant := v_row.flag_insert;
                WHEN    'U' THEN v_grant := v_row.flag_update;
                WHEN    'D' THEN v_grant := v_row.flag_delete;
                WHEN    'X' THEN v_grant := v_row.flag_execute;
            END CASE;
        END IF;
        CLOSE C_GRANT;
    -- daca nu exista definitiile => returnez FALSE
    ELSE
        v_grant := -1;
    END IF;
END IF;

IF v_grant = -1 THEN v_rez := NULL;
ELSE
    CASE p_flag
        WHEN 'I' THEN v_rez := 'Nu aveti drept de inserare date ! ';
        WHEN 'U' THEN v_rez := 'Nu aveti drept de modificare date ! ';
        WHEN 'D' THEN v_rez := 'Nu aveti drept de stergere date ! ';
        WHEN 'X' THEN v_rez := 'Nu aveti drept de executie ! ';
    END CASE;
    v_rez := v_rez || CHR(10)||CHR(13) ||v_row_secit.description;
END IF;
RETURN v_rez;

END;

----------------------------------------------------------------------------------------------
PROCEDURE p_test_table_iud(p_tip VARCHAR2, p_table VARCHAR2)
IS
 v_errmsg VARCHAR2(500);
 v_err  BOOLEAN;

BEGIN

FOR x IN (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(Pkg_Glb.v_g_txt01))) LOOP
    v_errmsg := f_message_grant(p_table || '*' ||x.txt01,p_tip, p_table);
    IF v_errmsg IS NOT NULL THEN
        Pkg_Lib.p_rae(v_errmsg);
    END IF;
END LOOP;

END;

/******************************************************************************************
    DDL 19/03/2008  d     
/******************************************************************************************/
PROCEDURE p_test_table_iud  (   p_tip               VARCHAR2, 
                                p_table             VARCHAR2, 
                                p_mod_col           VARCHAR2)
IS
    v_errmsg    VARCHAR2(500);
    v_err       BOOLEAN;
BEGIN

    FOR x IN (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_mod_col))) 
    LOOP
        v_errmsg := f_message_grant(p_table || '*' ||x.txt01,p_tip, p_table);
        IF v_errmsg IS NOT NULL THEN Pkg_Err.p_err(v_errmsg,''); END IF;
    END LOOP;
    Pkg_Err.p_rae;

END;

PROCEDURE p_test_grant(p_securitem VARCHAR2)
IS
    v_msg   VARCHAR2(1000);
BEGIN
    v_msg   := Pkg_App_Secur.f_message_grant(p_securitem,'X','');
    IF NOT v_msg IS NULL THEN
        Pkg_Err.p_rae(v_msg);
    END IF;
END;

/******************************************************************************************
    19/03/2008  d   moved from Pkg_Ecl_ANg  
/******************************************************************************************/
FUNCTION f_sk_app_user       RETURN typ_frm pipelined
-------------------------------------------------------------------------------------------
--  RecordSource for APP_USER 
-------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES              IS 
                                SELECT      * 
                                FROM        APP_USER
                                ;

    v_row                       tmp_frm := tmp_frm();

BEGIN
    FOR X IN C_LINES 
    LOOP
        v_row.idriga := X.idriga;
        v_row.dcn  := X.dcn;

        v_row.txt01  := X.user_code;
        v_row.txt02  := X.nume;
        v_row.txt03  := X.prenume;
        v_row.txt04  := X.default_oper;
        v_row.txt05  := X.pwd;

        v_row.numb01 := X.pairs_per_day;
        pipe ROW(v_row);
    END LOOP;

    RETURN;
END;

/******************************************************************************************
    19/03/2008  d   moved from Pkg_Ecl_ANg  
/******************************************************************************************/
FUNCTION f_sk_grants(p_user_code VARCHAR2, p_type VARCHAR2 ) RETURN typ_frm pipelined
-------------------------------------------------------------------------------------------
--  RecordSource for USer Grants  
-------------------------------------------------------------------------------------------
IS
    CURSOR C_GRANT      IS
                        SELECT      i.*,
                                    g.flag_insert,
                                    g.flag_update,
                                    g.flag_delete,
                                    g.flag_execute
                        ----------------------------------------------------------------------------------
                        FROM        APP_SECURITEM       i
                        LEFT JOIN   APP_USER_GRANT      g   ON  g.securitem_code    =   i.securitem_code
                                                            AND g.user_code         =   p_user_code
                        ----------------------------------------------------------------------------------
                        WHERE       i.securitem_type    =   p_type
                        ORDER BY    i.securitem_code;

    v_row    tmp_frm := tmp_frm();

BEGIN
    FOR x IN C_GRANT LOOP
        v_row.idriga    :=  1;
        v_row.seq_no    :=  C_GRANT%rowcount;
        v_row.txt01     :=  x.securitem_code;
        v_row.txt02     :=  x.description;
        v_row.txt03     :=  p_user_code;

        v_row.numb01    :=  NVL(x.flag_execute,0);
        v_row.numb02    :=  NVL(x.flag_insert,0);
        v_row.numb03    :=  NVL(x.flag_update,0);
        v_row.numb04    :=  NVL(x.flag_delete,0);

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/******************************************************************************************
    19/03/2008  d   moved from Pkg_Ecl_ANg  
/******************************************************************************************/
PROCEDURE p_app_user_iud        (   p_tip       VARCHAR2,   p_row IN OUT APP_USER%ROWTYPE)
-------------------------------------------------------------------------------------------
--  IUD for APP_USER 
-------------------------------------------------------------------------------------------
IS
    v_row_old       APP_USER%ROWTYPE;
    v_mod_col       VARCHAR2(1000);
BEGIN


    IF p_tip = 'U' THEN 
        v_row_old.idriga    :=  p_row.idriga;
        Pkg_Get.p_get_app_user(v_row_old);

        IF Pkg_Lib.f_mod_c(p_row.pwd, v_row_old.pwd) AND p_row.user_code <> Pkg_Lib.f_return_user_code() THEN
            Pkg_Lib.p_rae('Nu se poate modifica decat parola proprie !');
        END IF;

        -- check if the current user has the grant to modify 
        v_mod_col   :=  Pkg_Mod_Col.f_app_user(v_row_old, p_row);
        IF Pkg_Lib.F_Column_Other_Is_Modif2('PWD',v_mod_col) =-1 THEN
            Pkg_App_Secur.p_test_grant('USER_GRANT');
        END IF;
    ELSE
        Pkg_App_Secur.p_test_grant('USER_GRANT');
    END IF;

    Pkg_Iud.p_app_user_iud(p_tip,p_row);


    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/******************************************************************************************
    19/03/2008  d   moved from Pkg_Ecl_ANg  
/******************************************************************************************/
PROCEDURE p_app_user_grant_iud (p_row APP_USER_GRANT%ROWTYPE)
-------------------------------------------------------------------------------------------
--  IUD for USer Grants  
-------------------------------------------------------------------------------------------
IS

    CURSOR C_GET_GRANT      (p_user_code VARCHAR2, p_securitem_code VARCHAR2)
                            IS
                            SELECT  *
                            FROM    APP_USER_GRANT
                            WHERE
                                    user_code   = p_user_code
                                AND securitem_code = p_securitem_code
                            ;

    v_row           APP_USER_GRANT%ROWTYPE;
    v_msg           VARCHAR2(1000);

BEGIN

    Pkg_App_Secur.p_test_grant('USER_GRANT');

    OPEN  C_GET_GRANT (p_row.user_code, p_row.securitem_code);
    FETCH C_GET_GRANT INTO v_row;
    CLOSE C_GET_GRANT;

    -- daca nu gasesc grant-ul il inserez
    IF v_row.idriga IS NULL THEN
        v_row := p_row;
        Pkg_Iud.p_app_user_grant_iud('I', v_row);
        -- daca exista, setez flagurile
    ELSE
        v_row.flag_execute  := NVL(p_row.flag_execute,0);
        v_row.flag_insert   := NVL(p_row.flag_insert,0);
        v_row.flag_update   := NVL(p_row.flag_update,0);
        v_row.flag_delete   := NVL(p_row.flag_delete,0);
        Pkg_Iud.p_app_user_grant_iud('U', v_row);
    END IF;

    v_msg   := Pkg_App_Secur.f_message_grant('SEC_GRANT','X','');
    IF NOT v_msg IS NULL   THEN Pkg_Lib.p_rae(v_msg); END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;






END;

/

/
