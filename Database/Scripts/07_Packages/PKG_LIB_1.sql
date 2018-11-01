--------------------------------------------------------
--  DDL for Package Body PKG_LIB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_LIB" 
IS

PROCEDURE p_rae     (   p_message VARCHAR2)
IS
BEGIN
    Pkg_App_Tools.P_Log('E',p_message,'');
    RAISE_APPLICATION_ERROR(-20001,'<<'||p_message||'>>');
END;

PROCEDURE p_rae     (   p_errNo INTEGER, p_message VARCHAR2)
IS
BEGIN
    RAISE_APPLICATION_ERROR(p_errNo,'<<'||p_message||'>>');
END;

PROCEDURE p_rae_m   (   p_raise_type    VARCHAR2 := 'A')
--------------------------------------------------------------------------------
--  PURPOSE:    raise error based on the APP_LOG table
--  INPUT :     RAISE_TYPE  =   A -> normal raise -20001 with concatenated text
--                          =   B -> insert in VW_ERROR , raise -20999
--                                  with logic on client to get the errors
--------------------------------------------------------------------------------
IS
PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR C_ME_LOG     (p_audsid   INTEGER)
                        IS
                        SELECT      *
                        FROM        APP_LOG
                        WHERE       audsid      =   p_audsid
                            AND     msg_type    =   'M'
                        ORDER BY    line_id
                        ;

    v_err_text      VARCHAR2(2000);
    v_audsid        INTEGER;
    v_rowcount      PLS_INTEGER;
    v_context       VARCHAR2(250)   :=  'X';

BEGIN
    v_audsid            :=  SYS_CONTEXT('USERENV','SESSIONID');

    IF p_raise_type = 'A' THEN
        FOR x IN C_ME_LOG   ( v_audsid)
        LOOP
            v_err_text      :=  v_err_text || x.msg_context || Pkg_Glb.C_NL;
            v_err_text      :=  v_err_text || Pkg_Glb.C_NL || x.msg_text ;
            Pkg_App_Tools.p_reset_Mlog(x.line_id);
        END LOOP;
        IF NOT v_err_text IS NULL THEN
            p_rae (v_err_text);
        END IF;
    ELSE
        DELETE FROM VW_ERROR;
        v_rowcount  :=  0;
        FOR x IN C_ME_LOG   ( v_audsid)
        LOOP
            v_rowcount      :=  v_rowcount+ 1;
            IF v_context <> x.msg_context THEN
                INSERT INTO VW_ERROR    (message, seq_no)
                            VALUES      ( '*******************************************',v_rowcount);

                INSERT INTO VW_ERROR    (message, seq_no)
                            VALUES      ( x.msg_context, v_rowcount +1);

                v_context   :=  x.msg_context;
                v_rowcount  :=  v_rowcount + 2;
            END IF;

            INSERT INTO VW_ERROR (message, seq_no)
            VALUES  ( x.msg_text,v_rowcount);
            Pkg_App_Tools.p_reset_Mlog(x.line_id);
        END LOOP;

        IF v_rowcount > 0 THEN
            COMMIT;
            RAISE_APPLICATION_ERROR(-20999,NULL);
        ELSE
            COMMIT;
        END IF;

    END IF;

END;


/*------------------------------------------------------------------------------------------*/
FUNCTION F_Sql_Inlist
    (p_inlist VARCHAR2, p_delim VARCHAR2 := NULL, p_null INTEGER := 0) RETURN typ_cmb
---------------------------------------------------------------------------------------------
-- explodeaza un sir intr-un tablou , folosind delimitatorul p_delim sau implicit ,.;
-- daca p_null e setat, ia in considerare si campurile nule
---------------------------------------------------------------------------------------------
IS
 it        typ_cmb :=typ_cmb();
 v_idx        PLS_INTEGER:=0;
 v_row    tmp_cmb := tmp_cmb();
 v_token    VARCHAR2(32000);
 v_inlist   VARCHAR2(32000);
 v_char   VARCHAR2(1);
 v_delim   VARCHAR2(100);
BEGIN
  v_inlist := trim(p_inlist);
 v_delim  := NVL(p_delim, '.,;');
 WHILE v_inlist IS NOT NULL LOOP
  -- parcurg secvential sirul
  v_char := SUBSTR(v_inlist,1,1);
  -- verificare: caracterul curent este delimitator?
  IF INSTR (v_delim,v_char) >0 THEN
      -- delimitator -> inserez in tablou si resetez token-ul
      IF  (p_null = -1) OR (v_token IS NOT NULL) THEN
     v_idx := v_idx +1;
    it.EXTEND;
    it(v_idx) := tmp_cmb();
    it(v_idx).txt01 := trim(v_token);
    v_token :=NULL;
    END IF;
    ELSE
      -- nu e delimitator -> concatenez la token
      v_token := v_token || v_char;
    END IF;
    v_inlist := SUBSTR(v_inlist,2);
 END LOOP;
 -- ultimele caractere ...
 IF v_token IS NOT NULL THEN
     v_idx := v_idx +1;
    it.EXTEND;
    it(v_idx) := tmp_cmb();
    it(v_idx).txt01 := trim(v_token);
 END IF;
 RETURN it;
END;

----------------------------------------------------------------
FUNCTION f_sql_session_info RETURN typ_cmb pipelined
IS
 v_row tmp_cmb := tmp_cmb();
BEGIN
 v_row.txt01 := TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS');
    v_row.txt02 := SUBSTR(Pkg_App_Secur.f_return_numeuser,1,20);
 pipe ROW(v_row);
 RETURN;
END;
-----------------------------------------------------------------------------
FUNCTION f_sql_taskuri(p_frm VARCHAR2) RETURN typ_frm pipelined
IS
v_row tmp_frm := tmp_frm();
CURSOR      C IS    SELECT *
                    FROM   TASKS
                    WHERE  form_name = p_frm
                    ORDER BY task_order ASC;
BEGIN
  FOR x IN C LOOP
            v_row.idriga := x.idriga;
            v_row.txt20  := x.task_name;
            v_row.txt19  := x.task_order;
            v_row.txt01  := x.par_label1;
            v_row.txt02  := x.par_label2;
            v_row.txt03  := x.par_label3;
            v_row.txt04  := x.par_label4;
            v_row.txt05  := x.par_label5;
            v_row.txt06  := x.par_sql1;
            v_row.txt07  := x.par_sql2;
            v_row.txt08  := x.par_sql3;
            v_row.txt09  := x.par_sql4;
            v_row.txt10  := x.par_sql5;
            v_row.txt11  := x.par_type1;
            v_row.txt12  := x.par_type2;
            v_row.txt13  := x.par_type3;
            v_row.txt14  := x.par_type4;
            v_row.txt15  := x.par_type5;

            pipe ROW(v_row);
  END LOOP;
  RETURN;
END;
------------------------------------------------------------------------
FUNCTION f_sql_taskuri2(p_frm VARCHAR2) RETURN typ_longinfo pipelined
IS
v_row tmp_longinfo := tmp_longinfo();
CURSOR      C_LINES (p_frm  VARCHAR2) IS
                    SELECT *
                    FROM   TASKS
                    WHERE  form_name = p_frm
                    ORDER BY task_order ASC;
BEGIN
  FOR x IN C_LINES(p_frm) LOOP
            v_row.idriga := x.idriga;
            v_row.txt01  := x.task_order;
            v_row.txt02  := x.task_name;
            -- label
            v_row.txt03  := x.par_label1;
            v_row.txt04  := x.par_label2;
            v_row.txt05  := x.par_label3;
            v_row.txt06  := x.par_label4;
            v_row.txt07  := x.par_label5;
            v_row.txt08  := x.par_label6;
            v_row.txt09  := x.par_label7;
            v_row.txt10  := x.par_label8;
            v_row.txt11  := x.par_label9;
            v_row.txt12  := x.par_label10;
            --- sql
            v_row.txt13  := x.par_sql1;
            v_row.txt14  := x.par_sql2;
            v_row.txt15  := x.par_sql3;
            v_row.txt16  := x.par_sql4;
            v_row.txt17  := x.par_sql5;
            v_row.txt18  := x.par_sql6;
            v_row.txt19  := x.par_sql7;
            v_row.txt20  := x.par_sql8;
            v_row.txt21  := x.par_sql9;
            v_row.txt22  := x.par_sql10;
            -- type
            v_row.txt23  := x.par_type1;
            v_row.txt24  := x.par_type2;
            v_row.txt25  := x.par_type3;
            v_row.txt26  := x.par_type4;
            v_row.txt27  := x.par_type5;
            v_row.txt28  := x.par_type6;
            v_row.txt29  := x.par_type7;
            v_row.txt30  := x.par_type8;
            v_row.txt31  := x.par_type9;
            v_row.txt32  := x.par_type10;


            pipe ROW(v_row);
  END LOOP;
  RETURN;
END;
----------------------------------------------------------------------------------
PROCEDURE p_nl(p_string IN OUT VARCHAR2,p_number INTEGER DEFAULT 1)
IS
BEGIN
FOR i IN 1..p_number LOOP   p_string := p_string || Pkg_Glb.C_NL; END LOOP;
END;
------------------------------------------------------------------------
PROCEDURE p_add_line(p_string IN OUT VARCHAR2)
IS
BEGIN
p_string := p_string ||Pkg_Glb.C_NL;
p_string := p_string ||RPAD('-',50,'-');
p_string := p_string ||Pkg_Glb.C_NL;
END;
------------------------------------------------------------------------
PROCEDURE p_add_next(p_string IN OUT VARCHAR2, p_next VARCHAR2, p_length INTEGER DEFAULT 0)
IS
BEGIN
IF p_length = 0 THEN
    p_string := p_string|| p_next;
ELSE
    p_string := p_string ||RPAD(p_next, p_length);
END IF;
END;
------------------------------------------------------------------------------------
FUNCTION f_mod_n(p_old NUMBER,p_new NUMBER) RETURN BOOLEAN
IS
v_rezultat   BOOLEAN := FALSE;
BEGIN
CASE
 WHEN p_old IS NULL AND p_new IS NULL THEN     v_rezultat := FALSE;
 WHEN p_old IS NULL AND p_new IS NOT NULL THEN v_rezultat := TRUE;
 WHEN p_old IS NOT NULL AND p_new IS NULL THEN v_rezultat := TRUE;
 WHEN p_old <> p_new THEN v_rezultat := TRUE;
 ELSE NULL;
END CASE;
RETURN v_rezultat;
END;

FUNCTION f_mod_d(p_old DATE,p_new DATE) RETURN BOOLEAN
IS
v_rezultat   BOOLEAN := FALSE;
BEGIN

CASE
 WHEN p_old IS NULL AND p_new IS NULL THEN     v_rezultat := FALSE;
 WHEN p_old IS NULL AND p_new IS NOT NULL THEN v_rezultat := TRUE;
 WHEN p_old IS NOT NULL AND p_new IS NULL THEN v_rezultat := TRUE;
 WHEN p_old <> p_new THEN v_rezultat := TRUE;
 ELSE NULL;
END CASE;
RETURN v_rezultat;
END;

FUNCTION f_mod_c(p_old VARCHAR2,p_new VARCHAR2) RETURN BOOLEAN
IS
v_rezultat   BOOLEAN := FALSE;
BEGIN
CASE
 WHEN p_old IS NULL AND p_new IS NULL THEN     v_rezultat := FALSE;
 WHEN p_old IS NULL AND p_new IS NOT NULL THEN v_rezultat := TRUE;
 WHEN p_old IS NOT NULL AND p_new IS NULL THEN v_rezultat := TRUE;
 WHEN p_old <> p_new THEN v_rezultat := TRUE;
 ELSE NULL;
END CASE;
RETURN v_rezultat;
END;


FUNCTION f_interval (p_low INTEGER, p_high INTEGER) RETURN typ_cmb
IS
    it   typ_cmb:=typ_cmb();
    v_idx  PLS_INTEGER:=0;
BEGIN
    FOR x IN p_low .. p_high
    LOOP
        v_idx :=v_idx +1;
        it.EXTEND;
        it(v_idx)      := tmp_cmb();
        it(v_idx).txt01  := x;
    END LOOP;
    RETURN it;
END;
---------------------------------------------------------------------------------------
PROCEDURE p_set_environment
IS
BEGIN

    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE  = ITALIAN';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_SORT      = ASCII7' ;
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_TERRITORY = ITALY' ;
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '',.'' ';
    -- load the parameter table
    Pkg_Lib.p_load_app_parameters('ECL');

END;
----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
FUNCTION  f_make_decimal_point(p_number NUMBER) RETURN VARCHAR2
IS
v_rezultat  VARCHAR2(1000);
BEGIN
v_rezultat  := TO_CHAR(p_number);
v_rezultat  := REPLACE(v_rezultat, ',','.');
RETURN v_rezultat;
END;
-------------------------------------------------------------------------------------------
PROCEDURE p_locking_service(p_lock_code VARCHAR2)
IS

CURSOR      C_LOCK_CODE(p_lock_code VARCHAR2) IS
                SELECT *
                FROM   SYS_LOCKING
                WHERE   lock_code = p_lock_code;

CURSOR      C_LOCK_APPLY(p_lock_code VARCHAR2) IS
                SELECT *
                FROM   SYS_LOCKING
                WHERE   lock_code = p_lock_code
                FOR UPDATE NOWAIT;
v_rezultat      SYS_LOCKING%ROWTYPE;
v_not_found     BOOLEAN;
BEGIN

OPEN    C_LOCK_CODE(p_lock_code);
FETCH   C_LOCK_CODE INTO v_rezultat;
v_not_found := C_LOCK_CODE%NOTFOUND;
CLOSE   C_LOCK_CODE;
IF v_not_found THEN Pkg_Lib.p_rae('Eroare de programare, acest cod de locking NU EXISTA !!!'); END IF;

OPEN    C_LOCK_APPLY(p_lock_code);
FETCH   C_LOCK_APPLY INTO v_rezultat;
CLOSE   C_LOCK_APPLY;

EXCEPTION
 WHEN OTHERS THEN
   CASE SQLCODE
                WHEN -54 THEN Pkg_Lib.p_rae('Resursa blocata de alt utilizator: '||v_rezultat.lock_code||' - '||v_rezultat.description ||'');
                ELSE  RAISE;
         END CASE;
END;
-------------------------------------------------------------------------------------------
PROCEDURE p_set_locking(p_lock_code VARCHAR2)
IS

CURSOR      C_LOCK_APPLY(p_lock_code VARCHAR2) IS
                SELECT *
                FROM   SYS_LOCKING
                WHERE   lock_code = p_lock_code
                FOR UPDATE NOWAIT;
v_rezultat      SYS_LOCKING%ROWTYPE;
v_not_found     BOOLEAN;
BEGIN

OPEN    C_LOCK_APPLY(p_lock_code);
FETCH   C_LOCK_APPLY INTO v_rezultat;
v_not_found := C_LOCK_APPLY%NOTFOUND;
CLOSE   C_LOCK_APPLY;
IF v_not_found THEN Pkg_Lib.p_rae('Eroare de programare, acest cod de locking NU EXISTA !!!'); END IF;
IF v_rezultat.flag_locked = -1 THEN Pkg_Lib.p_rae('Un alt utilizator executa o comanda identica, aceste comenzi pot fi rulate numai succesiv si nu paralel !!!'); END IF;
v_rezultat.flag_locked := -1;
UPDATE SYS_LOCKING SET ROW = v_rezultat WHERE lock_code = v_rezultat.lock_code;
COMMIT;
EXCEPTION
 WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
-------------------------------------------------------------------------------------------
PROCEDURE p_reset_locking(p_lock_code VARCHAR2)
IS

CURSOR      C_LOCK_APPLY(p_lock_code VARCHAR2) IS
                SELECT *
                FROM   SYS_LOCKING
                WHERE   lock_code = p_lock_code
                FOR UPDATE NOWAIT;
v_rezultat      SYS_LOCKING%ROWTYPE;
v_not_found     BOOLEAN;
BEGIN

OPEN    C_LOCK_APPLY(p_lock_code);
FETCH   C_LOCK_APPLY INTO v_rezultat;
v_not_found := C_LOCK_APPLY%NOTFOUND;
CLOSE   C_LOCK_APPLY;
IF v_not_found THEN Pkg_Lib.p_rae('Eroare de programare, acest cod de locking NU EXISTA !!!'); END IF;
v_rezultat.flag_locked := 0;
UPDATE SYS_LOCKING SET ROW = v_rezultat WHERE lock_code = v_rezultat.lock_code;
COMMIT;
EXCEPTION
 WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
---------------------------------------------------------------------------------------
FUNCTION f_string_is_number(p_number VARCHAR2) RETURN INTEGER
IS
v_rezultat      NUMBER;
BEGIN
    BEGIN
        v_rezultat      := TO_NUMBER(p_number);
        v_rezultat      := -1;
    EXCEPTION
        WHEN OTHERS THEN v_rezultat := 0;
    END;

    RETURN v_rezultat;
END;
------------------------------------------------------------------------------------
FUNCTION f_string_is_date(p_date VARCHAR2) RETURN INTEGER
IS
v_rezultat      INTEGER;
v_date          DATE;
BEGIN
    BEGIN
        v_date          := TO_DATE(p_date, 'YYYYMMDD');
        v_rezultat      := -1;
    EXCEPTION
        WHEN OTHERS THEN v_rezultat := 0;
    END;

    RETURN v_rezultat;
END;
---------------------------------------------------------------------------------
FUNCTION f_str_idx          (   p_par1  VARCHAR2 DEFAULT NULL,
                                p_par2  VARCHAR2 DEFAULT NULL,
                                p_par3  VARCHAR2 DEFAULT NULL,
                                p_par4  VARCHAR2 DEFAULT NULL,
                                p_par5  VARCHAR2 DEFAULT NULL,
                                p_par6  VARCHAR2 DEFAULT NULL,
                                p_par7  VARCHAR2 DEFAULT NULL,
                                p_par8  VARCHAR2 DEFAULT NULL,
                                p_par9  VARCHAR2 DEFAULT NULL,
                                p_par10 VARCHAR2 DEFAULT NULL
                            ) RETURN VARCHAR2
IS
    C_SEPARATOR     CONSTANT VARCHAR2(1) := '^';
    v_result        VARCHAR2(1000);
BEGIN
    v_result        :=      v_result||C_SEPARATOR
                        ||  p_par1  ||C_SEPARATOR
                        ||  p_par2  ||C_SEPARATOR
                        ||  p_par3  ||C_SEPARATOR
                        ||  p_par4  ||C_SEPARATOR
                        ||  p_par5  ||C_SEPARATOR
                        ||  p_par6  ||C_SEPARATOR
                        ||  p_par7  ||C_SEPARATOR
                        ||  p_par8  ||C_SEPARATOR
                        ||  p_par9  ||C_SEPARATOR
                        ||  p_par10;

    RETURN v_result;
END;
----------------------------------------------------------------------------------------------------
PROCEDURE   p_load_app_parameters(p_org_code VARCHAR2 )
IS
/*
Loads parameter lines from PARAMETER coresponding to par_code (should be APP_PAR) into global
varchar index by table PKG_GLB.it_par
*/
CURSOR      C_LINES(p_org_code VARCHAR2) IS
                SELECT  *
                FROM    PARAMETER
                WHERE       org_code    =   p_org_code
                ORDER BY par_code,par_key
                ;
BEGIN
    -- delete thr ptivious content of the table
    Pkg_Glb.it_par.DELETE;
    FOR x IN C_LINES(p_org_code) LOOP
        Pkg_Glb.it_par(x.par_code)(x.par_key)   :=  x;
    END LOOP;
END;
--------------------------------------------------------------------------------------------------------
PROCEDURE p_parameter_iud               (p_tip              VARCHAR2,
                                         p_row              IN OUT PARAMETER%ROWTYPE)
IS

CURSOR      C_PARAMETER(p_idriga INTEGER) IS
                SELECT *
                FROM    PARAMETER
                WHERE   idriga  =   p_idriga
                ;


CURSOR      C_PARAMETER_ATTR(p_org_code VARCHAR2, p_par_code VARCHAR2) IS
                SELECT  *
                FROM    PARAMETER_ATTR
                WHERE       org_code    =   p_org_code
                        AND par_code    =   p_par_code
                ORDER BY attr_id ASC;

v_row_old       PARAMETER%ROWTYPE;
v_old_attr      PARAMETER.attribute01%TYPE;
v_new_attr      PARAMETER.attribute01%TYPE;




        --- procedura de validare -------------------------------------
        PROCEDURE p_validate_attribute( p_old_attr          PARAMETER.attribute01%TYPE,
                                        p_new_attr          PARAMETER.attribute01%TYPE,
                                        p_parameter_attr    PARAMETER_ATTR%ROWTYPE)
        IS
        BEGIN
               IF Pkg_Lib.f_mod_c(v_old_attr, p_new_attr) THEN
                   -- verific tipul datei
                   CASE p_parameter_attr.attr_type
                       WHEN 0 THEN
                               -- caracter nu fac nici o verificare
                               NULL;
                       WHEN 1 THEN
                               -- numar
                               IF Pkg_Lib.f_string_is_number(p_new_attr) = 0 THEN
                                   Pkg_Lib.p_rae('Proprietatea '||p_parameter_attr.attr_name||' trebuie sa fie valoare numerica (despartitorul zecimal fiind virgula) !!!');
                               END IF;
                       WHEN 2 THEN
                               -- data calendarsitica
                               IF Pkg_Lib.f_string_is_date(p_new_attr) = 0 THEN
                                   Pkg_Lib.p_rae('Proprietatea '||p_parameter_attr.attr_name||' trebuie sa fie data calendaristica corecta (valida, reala) in formatul AAAALLZZ (ex. 20060813, fara despartitori) !!!');
                               END IF;
                   END CASE;

                   -- validez daca exista inlist
                   IF p_new_attr IS NOT NULL AND p_parameter_attr.attr_inlist IS NOT NULL THEN
                        IF Pkg_Lib.f_instr(p_parameter_attr.attr_inlist,p_new_attr) = 0 THEN
                             Pkg_Lib.p_rae('Proprietatea '||p_parameter_attr.attr_name||' trebuie sa aiba valorile din lista '||p_parameter_attr.attr_inlist||' !!!');
                        END IF;
                   END IF;

                   -- not null
                   IF  p_parameter_attr.attr_notnull = -1 THEN
                        IF p_new_attr IS NULL THEN
                             Pkg_Lib.p_rae('Proprietatea '||p_parameter_attr.attr_name||' trebuie sa aiba o valoare !!!');
                        END IF;
                   END IF;

                   -- validez pe range daca exista
                   IF p_new_attr IS NOT NULL AND p_parameter_attr.attr_from IS NOT NULL THEN
                        CASE p_parameter_attr.attr_type
                            WHEN 0 THEN
                                    -- caracter nu fac nici o verificare
                                    IF p_new_attr NOT BETWEEN p_parameter_attr.attr_from AND p_parameter_attr.attr_to THEN
                                           Pkg_Lib.p_rae('Proprietatea '||p_parameter_attr.attr_name||' trebuie sa aiba valoare in plaja '||p_parameter_attr.attr_from||' --> '||p_parameter_attr.attr_to||' !!!');
                                    END IF;
                            WHEN 1 THEN
                                    -- numar
                                    IF p_new_attr NOT BETWEEN TO_NUMBER(p_parameter_attr.attr_from) AND TO_NUMBER(p_parameter_attr.attr_to) THEN
                                           Pkg_Lib.p_rae('Proprietatea '||p_parameter_attr.attr_name||' trebuie sa aiba valoare in plaja '||p_parameter_attr.attr_from||' --> '||p_parameter_attr.attr_to||' !!!');
                                    END IF;
                            WHEN 2 THEN
                                    -- data calendarsitica
                                    IF p_new_attr NOT BETWEEN p_parameter_attr.attr_from AND p_parameter_attr.attr_to THEN
                                           Pkg_Lib.p_rae('Proprietatea '||p_parameter_attr.attr_name||' trebuie sa aiba valoare in plaja '||p_parameter_attr.attr_from||' --> '||p_parameter_attr.attr_to||' !!!');
                                    END IF;
                        END CASE;
                   END IF;
               END IF;
        END;
        -----------------------------------------------------------------------



BEGIN

OPEN    C_PARAMETER(p_row.idriga);
FETCH   C_PARAMETER INTO v_row_old;
CLOSE   C_PARAMETER;


IF p_tip IN ('I') THEN
    -- fac asta ca la inserare sa pot sa testez conditia not null adica sa intra in functia f_mod_c !!!!
    v_row_old.attribute01   := Pkg_Glb.C_RN;
    v_row_old.attribute02   := Pkg_Glb.C_RN;
    v_row_old.attribute03   := Pkg_Glb.C_RN;
    v_row_old.attribute04   := Pkg_Glb.C_RN;
    v_row_old.attribute05   := Pkg_Glb.C_RN;
    v_row_old.attribute06   := Pkg_Glb.C_RN;
    v_row_old.attribute07   := Pkg_Glb.C_RN;
    v_row_old.attribute08   := Pkg_Glb.C_RN;
    v_row_old.attribute09   := Pkg_Glb.C_RN;
    v_row_old.attribute10   := Pkg_Glb.C_RN;
END IF;


IF p_tip IN ('I','U') THEN

     -- elimin eventualele spatii existente la manipularea de cater useri
     p_row.attribute01   := trim(p_row.attribute01);
     p_row.attribute02   := trim(p_row.attribute02);
     p_row.attribute03   := trim(p_row.attribute03);
     p_row.attribute04   := trim(p_row.attribute04);
     p_row.attribute05   := trim(p_row.attribute05);
     p_row.attribute06   := trim(p_row.attribute06);
     p_row.attribute07   := trim(p_row.attribute07);
     p_row.attribute08   := trim(p_row.attribute08);
     p_row.attribute09   := trim(p_row.attribute09);
     p_row.attribute10   := trim(p_row.attribute10);


    FOR x IN C_PARAMETER_ATTR(p_row.org_code, p_row.par_code) LOOP
        CASE x.attr_id
            WHEN 'ATTRIBUTE01' THEN
                    v_old_attr              := v_row_old.attribute01;
                    v_new_attr              := p_row.attribute01;
            WHEN 'ATTRIBUTE02' THEN
                    v_old_attr              := v_row_old.attribute02;
                    v_new_attr              := p_row.attribute02;
            WHEN 'ATTRIBUTE03' THEN
                    v_old_attr              := v_row_old.attribute03;
                    v_new_attr              := p_row.attribute03;
            WHEN 'ATTRIBUTE04' THEN
                    v_old_attr              := v_row_old.attribute04;
                    v_new_attr              := p_row.attribute04;
            WHEN 'ATTRIBUTE05' THEN
                    v_old_attr              := v_row_old.attribute05;
                    v_new_attr              := p_row.attribute05;
            WHEN 'ATTRIBUTE06' THEN
                    v_old_attr              := v_row_old.attribute06;
                    v_new_attr              := p_row.attribute06;
            WHEN 'ATTRIBUTE07' THEN
                    v_old_attr              := v_row_old.attribute07;
                    v_new_attr              := p_row.attribute07;
            WHEN 'ATTRIBUTE08' THEN
                    v_old_attr              := v_row_old.attribute08;
                    v_new_attr              := p_row.attribute08;
            WHEN 'ATTRIBUTE09' THEN
                    v_old_attr              := v_row_old.attribute09;
                    v_new_attr              := p_row.attribute09;
            WHEN 'ATTRIBUTE10' THEN
                    v_old_attr              := v_row_old.attribute10;
                    v_new_attr              := p_row.attribute10;
        END CASE;

        p_validate_attribute(v_old_attr,v_new_attr, x);

    END LOOP;
END IF;

UPDATE PARAMETER SET ROW = p_row WHERE idriga = p_row.idriga;

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
 ROLLBACK;
 RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

--------------------------------------------------------------------------------------------------------
FUNCTION f_instr(p_search VARCHAR2,p_what VARCHAR2) RETURN INTEGER
IS
v_search    VARCHAR2(32000);
v_what      VARCHAR2(32000);
v_rezultat  INTEGER := 0;
BEGIN
v_search    := NVL(p_search,Pkg_Glb.C_RN)||',';
v_what      := NVL(p_what  ,Pkg_Glb.C_RN)||',';
v_rezultat  := INSTR(v_search,v_what,1,1);
RETURN v_rezultat;
END;
-------------------------------------------------------------------------------------------------------
FUNCTION F_Column_Is_Modif(p_column VARCHAR2) RETURN INTEGER
IS
v_found   BOOLEAN := FALSE;
BEGIN
 FOR x IN (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(Pkg_Glb.v_g_txt01))) LOOP
  FOR y IN (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_column)))
  LOOP
   IF y.txt01 = x.txt01 THEN -- am gasit coloana printre cele modificate
      v_found := TRUE;
      EXIT;
   END IF;
  END LOOP;
  IF v_found THEN
      EXIT;
  END IF;
 END LOOP;

 --RETURN v_found;

 IF v_found THEN RETURN -1; ELSE RETURN 0; END IF;
END;
-----------------------------------------------------------------------------------------------------
FUNCTION F_Column_Other_Is_Modif(p_column VARCHAR2) RETURN INTEGER
IS

CURSOR      C_LINES (p_column VARCHAR2, p_trigger_column VARCHAR2) IS
                    SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_trigger_column))
                    MINUS
                    SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_column        ))
                    ;
v_row       C_LINES%ROWTYPE;
v_found     BOOLEAN;
v_result    INTEGER ;
BEGIN
    OPEN    C_LINES(p_column, Pkg_Glb.v_g_txt01);
    FETCH   C_LINES  INTO v_row;
    v_found     :=  C_LINES%FOUND;
    CLOSE   C_LINES;

    IF v_found THEN v_result := -1; ELSE v_result := 0; END IF;
    RETURN v_result;
END;
-------------------------------------------------------------------------------------------------------
FUNCTION F_Column_Is_Modif2(p_column VARCHAR2, p_mod_column VARCHAR2) RETURN INTEGER
/*----------------------------------------------------------------------------------
--  PURPOSE:    - returns -1 if at least 1 column in the column list in p_column
                is found in the column list p_mod_column (the modified columns list)
--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    CURSOR  C_LINES(p_column VARCHAR2,p_mod_column VARCHAR2) IS
               SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_mod_column    ))
               INTERSECT
               SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_column        ))
               ;

    v_result   INTEGER;
BEGIN
    v_result    :=  0;
    FOR x IN C_LINES(p_column,p_mod_column) LOOP
        v_result    :=  -1;
    END LOOP;
    RETURN v_result;
END;
-----------------------------------------------------------------------------------------------------
FUNCTION F_Column_Other_Is_Modif2(p_column VARCHAR2, p_mod_column VARCHAR2) RETURN INTEGER
IS

CURSOR      C_LINES (p_column VARCHAR2, p_mod_column VARCHAR2) IS
                    SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_mod_column    ))
                    MINUS
                    SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_column        ))
                    ;
v_row       C_LINES%ROWTYPE;
v_found     BOOLEAN;
v_result    INTEGER ;
BEGIN
    OPEN    C_LINES(p_column, p_mod_column);
    FETCH   C_LINES  INTO v_row;
    v_found     :=  C_LINES%FOUND;
    CLOSE   C_LINES;

    IF v_found THEN v_result := -1; ELSE v_result := 0; END IF;
    RETURN v_result;
END;
-----------------------------------------------------------------------------------------------
FUNCTION  f_round(p_number NUMBER, p_decimals INTEGER) RETURN NUMBER
IS
BEGIN
RETURN  ROUND(p_number,p_decimals);
END;
-----------------------------------------------------------------------------------------------
FUNCTION    f_get_segment_from_string(p_string VARCHAR2, p_separator VARCHAR2, p_segment INTEGER) RETURN VARCHAR2
IS
    v_result        VARCHAR2(32000);
    v_position      INTEGER;
    v_segment       INTEGER := p_segment - 1;
BEGIN
    IF v_segment = 0 THEN
        v_position  :=  INSTR(p_string, p_separator);
        v_result := SUBSTR(p_string , 0, v_position - 1);
    ELSE
        v_position  :=  INSTR(p_string, p_separator, 1, v_segment);
        v_result    :=  SUBSTR(p_string , v_position + 1);
        v_position  :=  INSTR(v_result, p_separator, 1, 1 );
        IF v_position   = 0 THEN
            v_position  :=  32000;
        END IF;
        v_result    :=  SUBSTR(v_result ,1,  v_position - 1);
    END IF;
    RETURN v_result;
END;
---------------------------------------------------------------------------------------------------
PROCEDURE p_increment_report_counter(p_idriga INTEGER)
IS
BEGIN
    UPDATE REPORTS SET counter = counter + 1 WHERE idriga = p_idriga;
    COMMIT;
END;
---------------------------------------------------------------------------------------------------
FUNCTION f_get_dummy_sequence RETURN INTEGER
IS
    CURSOR  C_LINE IS
            SELECT  sc_dummy.NEXTVAL dummy_sequence
            FROM    dual
            ;
    v_result    INTEGER;
BEGIN
    FOR x IN C_LINE LOOP
        v_result    :=  x.dummy_sequence;
    END LOOP;
    RETURN v_result;
END;
/*********************************************************************************
    DDL: 28/02/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_normalise(p_token  VARCHAR2) RETURN VARCHAR2
----------------------------------------------------------------------------------
--  PURPOSE: converts to upper case and removes spaces and other punctuation characters
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_result    VARCHAR2(32000);
BEGIN
    v_result    :=  TRANSLATE(p_token,'A:''";','A');
    v_result    :=  REGEXP_REPLACE(v_result, '[ ]+', ' ');
    v_result    :=  UPPER(v_result);
    RETURN  v_result;
END;


/***************************************************************************************************************
    return by its OUT parameters the OWNER the name of the PACKAGE/PROCEDURE that called it
    and the LINE NUMBER
***************************************************************************************************************/
PROCEDURE who_called_me( p_owner      OUT VARCHAR2,
                         p_name       OUT VARCHAR2,
                         p_lineno     OUT NUMBER,
                         p_caller_t   OUT VARCHAR2 )
IS
    call_stack  VARCHAR2(4096) DEFAULT DBMS_UTILITY.FORMAT_CALL_STACK;
    n           NUMBER;
    found_stack BOOLEAN DEFAULT FALSE;
    LINE        VARCHAR2(255);
    cnt         NUMBER := 0;
BEGIN
--
    LOOP
        n := INSTR( call_stack, CHR(10) );
        EXIT WHEN ( cnt = 3 OR n IS NULL OR n = 0 );
--
        LINE := SUBSTR( call_stack, 1, n-1 );
        call_stack := SUBSTR( call_stack, n+1 );
--
        IF ( NOT found_stack ) THEN
            IF ( LINE LIKE '%handle%number%name%' ) THEN
                found_stack := TRUE;
            END IF;
        ELSE
            cnt := cnt + 1;
            -- cnt = 1 is ME
            -- cnt = 2 is MY Caller
            -- cnt = 3 is Their Caller
            IF ( cnt = 3 ) THEN
                p_lineno := TO_NUMBER(SUBSTR( LINE, 13, 6 ));
                LINE   := SUBSTR( LINE, 21 );
                IF ( LINE LIKE 'pr%' ) THEN
                    n := LENGTH( 'procedure ' );
                ELSIF ( LINE LIKE 'fun%' ) THEN
                    n := LENGTH( 'function ' );
                ELSIF ( LINE LIKE 'package body%' ) THEN
                    n := LENGTH( 'package body ' );
                ELSIF ( LINE LIKE 'pack%' ) THEN
                    n := LENGTH( 'package ' );
                ELSIF ( LINE LIKE 'anonymous%' ) THEN
                    n := LENGTH( 'anonymous block ' );
                ELSE
                    n := NULL;
                END IF;
                IF ( n IS NOT NULL ) THEN
                   p_caller_t := LTRIM(RTRIM(UPPER(SUBSTR( LINE, 1, n-1 ))));
                ELSE
                   p_caller_t := 'TRIGGER';
                END IF;

                LINE := SUBSTR( LINE, NVL(n,1) );
                n := INSTR( LINE, '.' );
                p_owner := LTRIM(RTRIM(SUBSTR( LINE, 1, n-1 )));
                p_name  := LTRIM(RTRIM(SUBSTR( LINE, n+1 )));
            END IF;
        END IF;
    END LOOP;
END;


FUNCTION f_get_procedure_name(p_pkg_name VARCHAR2, p_current_line INTEGER) RETURN VARCHAR2
IS
    CURSOR C_GET    IS
                    SELECT  *
                    FROM    USER_SOURCE
                    WHERE   TYPE    =   'PACKAGE BODY'
                        AND NAME    =   p_pkg_name
                        AND LINE    <   p_current_line
                        AND (UPPER(text) LIKE 'PROCEDURE%' OR UPPER(text) LIKE 'FUNCTION%')
                    ORDER BY LINE DESC;

    v_row           C_GET%ROWTYPE;
    v_rez           VARCHAR2(100);
    v_poz           INTEGER;

BEGIN
    OPEN C_GET; FETCH C_GET INTO v_row; CLOSE C_GET;
    v_rez   := UPPER(v_row.text);
    v_rez   := SUBSTR(v_rez, 10);
    v_poz   := INSTR(v_rez,'(');
    IF v_poz > 0 THEN
        v_rez   := trim(SUBSTR(v_rez,1,v_poz - 1));
    END IF;

    RETURN v_rez;
END;


/**********************************************************************************************************
    DDL:    29/02/2008  d   Create
**********************************************************************************************************/
FUNCTION f_table_value  (   it_table        Pkg_Glb.typ_varchar_varchar,
                            p_idx           VARCHAR2,
                            pValueIfNull    VARCHAR2
                        )   RETURN          VARCHAR2
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    return the value from a PL/SQL indexed by varchar2 table, or an alternative value
--  INPUT:      IT_TABLE        table
--              IDX :           index to look for
--              VALUEiFnULL:    alternative value
-----------------------------------------------------------------------------------------------------------
IS
    v_result            VARCHAR2(500);
BEGIN
    IF it_table.EXISTS(p_idx) THEN
        v_result        :=  it_table(p_idx);
    ELSE
        v_result        :=  pValueIfNull;
    END IF;
    RETURN v_result;
END;

/**********************************************************************************************************
    DDL:    22/03/2008  d   Create
**********************************************************************************************************/
FUNCTION f_table_value  (   it_table        Pkg_Glb.typ_string,
                            p_idx           NUMBER,
                            pValueIfNull    VARCHAR2
                        )   RETURN          VARCHAR2
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    return the value from a PL/SQL indexed by varchar2 table, or an alternative value
--  INPUT:      IT_TABLE        table
--              IDX :           index to look for
--              VALUEiFnULL:    alternative value
-----------------------------------------------------------------------------------------------------------
IS
    v_result            VARCHAR2(1000);
BEGIN
    IF it_table.EXISTS(p_idx) THEN
        v_result        :=  it_table(p_idx);
    ELSE
        v_result        :=  pValueIfNull;
    END IF;
    RETURN v_result;
END;



/**********************************************************************************************************
    DDL:    22/03/2008  d   Create
**********************************************************************************************************/
FUNCTION f_table_value  (   it_table        Pkg_Glb.typ_number_varchar,
                            p_idx           VARCHAR2,
                            pValueIfNull    NUMBER
                        )   RETURN          NUMBER
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    return the value from a PL/SQL indexed by varchar2 table, or an alternative value
--  INPUT:      IT_TABLE        table
--              IDX :           index to look for
--              VALUEiFnULL:    alternative value
-----------------------------------------------------------------------------------------------------------
IS
    v_result            NUMBER;
BEGIN
    IF it_table.EXISTS(p_idx) THEN
        v_result        :=  it_table(p_idx);
    ELSE
        v_result        :=  pValueIfNull;
    END IF;
    RETURN v_result;
END;


PROCEDURE p_c(  old_value       VARCHAR2,
                new_value       VARCHAR2,
                p_modif         IN OUT VARCHAR2,
                p_colList       IN OUT VARCHAR2,
                p_colName       VARCHAR2)
IS
BEGIN
    IF Pkg_Lib.f_mod_c(old_value,new_value) THEN
        p_modif     :=  p_modif||';'||p_colName||':'||old_value||'->'||new_value;
        p_colList   :=  p_colList||p_colName||',';
    END IF;
END;

PROCEDURE p_n(  old_value       NUMBER,
                new_value       NUMBER,
                p_modif         IN OUT VARCHAR2,
                p_colList       IN OUT VARCHAR2,
                p_colName       VARCHAR2)
IS
BEGIN
    IF Pkg_Lib.f_mod_n(old_value,new_value) THEN
        p_modif     :=  p_modif||';'||p_colName||':'||old_value||'->'||new_value;
        p_colList   :=  p_colList||p_colName||',';
    END IF;
END;

PROCEDURE p_d(  old_value       DATE,
                new_value       DATE,
                p_modif         IN OUT VARCHAR2,
                p_colList       IN OUT VARCHAR2,
                p_colName       VARCHAR2)
IS
BEGIN
    IF Pkg_Lib.f_mod_d(old_value,new_value) THEN
        p_modif     :=  p_modif||';'||p_colName||':'||old_value||'->'||new_value;
        p_colList   :=  p_colList||p_colName||',';
    END IF;
END;

/***********************************************************************************************************

***********************************************************************************************************/
FUNCTION f_implode  (   p_separator VARCHAR2,
                        p_1         VARCHAR2,
                        p_2         VARCHAR2 DEFAULT NULL,
                        p_3         VARCHAR2 DEFAULT NULL,
                        p_4         VARCHAR2 DEFAULT NULL,
                        p_5         VARCHAR2 DEFAULT NULL,
                        p_6         VARCHAR2 DEFAULT NULL,
                        p_7         VARCHAR2 DEFAULT NULL,
                        p_8         VARCHAR2 DEFAULT NULL,
                        p_9         VARCHAR2 DEFAULT NULL,
                        p_10        VARCHAR2 DEFAULT NULL
                    )   RETURN VARCHAR2
-------------------------------------------------------------------------------------------------------------
--    implode all the parameters into one string with a separation  character
--    not a cleaver function, maybe we'll find another solution
-------------------------------------------------------------------------------------------------------------
IS
    v_rez       VARCHAR2(1000);
    v_sep       VARCHAR2(10);
BEGIN
    v_sep       := NVL(p_separator,'^');

    IF p_1 IS NOT NULL THEN   v_rez       := v_rez ||        p_1;  END IF;
    IF p_2 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_2;  END IF;
    IF p_3 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_3;  END IF;
    IF p_4 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_4;  END IF;
    IF p_5 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_5;  END IF;
    IF p_6 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_6;  END IF;
    IF p_7 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_7;  END IF;
    IF p_8 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_8;  END IF;
    IF p_9 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_9;  END IF;
    IF p_10 IS NOT NULL THEN   v_rez       := v_rez ||v_sep|| p_10;  END IF;

    RETURN v_rez;
END;

/**********************************************************************************************************
    DDL:    02/03/2008  Z   Create
**********************************************************************************************************/
FUNCTION  f_read_pk RETURN INTEGER
IS
BEGIN
    RETURN Pkg_Glb.v_idriga;
END;
/**********************************************************************************************************
    DDL:    02/03/2008  Z   Create
**********************************************************************************************************/
PROCEDURE p_set_pk(p_idriga INTEGER)
IS
BEGIN
    Pkg_Glb.v_idriga := p_idriga;
END;
/**********************************************************************************************************
    DDL:    02/03/2008  Z   Create
**********************************************************************************************************/
FUNCTION  f_read_dcn RETURN INTEGER
IS
BEGIN
    RETURN Pkg_Glb.v_dcn;
END;


/*******************************************************************************************
    20/02/2008 d Created

/*******************************************************************************************/
FUNCTION f_getAppParameter  (   p_parCode VARCHAR2, p_parKey VARCHAR2) RETURN VARCHAR2
---------------------------------------------------------------------------------------------
-- returns the value for the application level parameter from PARAMETER table
---------------------------------------------------------------------------------------------
IS
    CURSOR C_GET_PARAM  (p_parCode VARCHAR2, p_ParKey VARCHAR2)
                        IS
                        SELECT      attribute01
                        FROM        PARAMETER
                        WHERE       par_code    =   p_parCode
                                AND par_key     =   p_parKey
                        ;

    v_result        VARCHAR2(2000);

BEGIN
    OPEN  C_GET_PARAM   (p_parCode, p_ParKey);
    FETCH C_GET_PARAM   INTO v_result;
    CLOSE C_GET_PARAM;

    RETURN v_result;
END;


/**********************************************************************************************************

**********************************************************************************************************/
FUNCTION f_return_sbu_code RETURN VARCHAR2
-----------------------------------------------------------------------------------------------------------
--    returns the CURRENT COMPANY global variable
-----------------------------------------------------------------------------------------------------------
IS
    v_rez       VARCHAR2(20);
BEGIN
    v_rez       := NVL(Pkg_Glb.gv_sbu_code, 'N/A');

    IF v_rez    IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'<<You must re-login! >>');
    END IF;

    RETURN v_rez;
END;

/**********************************************************************************************************

**********************************************************************************************************/
FUNCTION f_return_user_code RETURN VARCHAR2
-----------------------------------------------------------------------------------------------------------
--    returns the CURRENT CLIENT global variable
-----------------------------------------------------------------------------------------------------------
IS
    v_rez       VARCHAR2(10);
BEGIN
    v_rez       := Pkg_Glb.gv_user_code;
    RETURN v_rez;
END;


/**********************************************************************************************************

**********************************************************************************************************/
FUNCTION f_return_language_id RETURN VARCHAR2
-----------------------------------------------------------------------------------------------------------
--    returns the  LANGUAGE ID global variable
-----------------------------------------------------------------------------------------------------------
IS
    v_rez       VARCHAR2(5);
BEGIN
    v_rez       := Pkg_Glb.gv_language_id;
    RETURN v_rez;
END;


/**********************************************************************************************************

**********************************************************************************************************/
FUNCTION f_return_faudit RETURN INTEGER
-----------------------------------------------------------------------------------------------------------
--    returns 0 if the global variable FLAG_AUDIT is not set or set to 0
-----------------------------------------------------------------------------------------------------------
IS
    v_rez       INTEGER;
BEGIN
    v_rez       := NVL(Pkg_Glb.gv_flag_audit,0);
    RETURN v_rez;
END;

/**********************************************************************************************************

**********************************************************************************************************/
FUNCTION f_return_client_code RETURN VARCHAR2
-----------------------------------------------------------------------------------------------------------
--    returns the CURRENT CLIENT global variable
-----------------------------------------------------------------------------------------------------------
IS
    v_rez       VARCHAR2(10);
BEGIN
    v_rez       := Pkg_Glb.gv_client_code;
    RETURN v_rez;
END;
/*********************************************************************************
    DDL: 22/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE   p_load_mdim     (   p_it        IN OUT NOCOPY Pkg_Glb.type_dim_10,
                                p_number    NUMBER  ,
                                p_1         VARCHAR2    DEFAULT NULL,
                                p_2         VARCHAR2    DEFAULT NULL,
                                p_3         VARCHAR2    DEFAULT NULL,
                                p_4         VARCHAR2    DEFAULT NULL,
                                p_5         VARCHAR2    DEFAULT NULL,
                                p_6         VARCHAR2    DEFAULT NULL,
                                p_7         VARCHAR2    DEFAULT NULL,
                                p_8         VARCHAR2    DEFAULT NULL,
                                p_9         VARCHAR2    DEFAULT NULL,
                                p_10        VARCHAR2    DEFAULT NULL
                             )
IS
    v_1     VARCHAR2(100);
    v_2     VARCHAR2(100);
    v_3     VARCHAR2(100);
    v_4     VARCHAR2(100);
    v_5     VARCHAR2(100);
    v_6     VARCHAR2(100);
    v_7     VARCHAR2(100);
    v_8     VARCHAR2(100);
    v_9     VARCHAR2(100);
    v_10    VARCHAR2(100);

BEGIN

    v_1     :=  NVL(p_1 ,Pkg_Glb.C_RN );
    v_2     :=  NVL(p_2 ,Pkg_Glb.C_RN );
    v_3     :=  NVL(p_3 ,Pkg_Glb.C_RN );
    v_4     :=  NVL(p_4 ,Pkg_Glb.C_RN );
    v_5     :=  NVL(p_5 ,Pkg_Glb.C_RN );
    v_6     :=  NVL(p_6 ,Pkg_Glb.C_RN );
    v_7     :=  NVL(p_7 ,Pkg_Glb.C_RN );
    v_8     :=  NVL(p_8 ,Pkg_Glb.C_RN );
    v_9     :=  NVL(p_9 ,Pkg_Glb.C_RN );
    v_10    :=  NVL(p_10,Pkg_Glb.C_RN );


    p_it(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7)(v_8)(v_9)(v_10)    :=  p_number;

END;
/*********************************************************************************
    DDL: 22/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION   f_get_mdim      (   p_it        IN  Pkg_Glb.type_dim_10,
                                p_1         VARCHAR2    DEFAULT NULL,
                                p_2         VARCHAR2    DEFAULT NULL,
                                p_3         VARCHAR2    DEFAULT NULL,
                                p_4         VARCHAR2    DEFAULT NULL,
                                p_5         VARCHAR2    DEFAULT NULL,
                                p_6         VARCHAR2    DEFAULT NULL,
                                p_7         VARCHAR2    DEFAULT NULL,
                                p_8         VARCHAR2    DEFAULT NULL,
                                p_9         VARCHAR2    DEFAULT NULL,
                                p_10        VARCHAR2    DEFAULT NULL
                             ) RETURN NUMBER
IS
    v_1     VARCHAR2(100);
    v_2     VARCHAR2(100);
    v_3     VARCHAR2(100);
    v_4     VARCHAR2(100);
    v_5     VARCHAR2(100);
    v_6     VARCHAR2(100);
    v_7     VARCHAR2(100);
    v_8     VARCHAR2(100);
    v_9     VARCHAR2(100);
    v_10    VARCHAR2(100);
    v_result    NUMBER;
BEGIN

    v_1     :=  NVL(p_1 ,Pkg_Glb.C_RN );
    v_2     :=  NVL(p_2 ,Pkg_Glb.C_RN );
    v_3     :=  NVL(p_3 ,Pkg_Glb.C_RN );
    v_4     :=  NVL(p_4 ,Pkg_Glb.C_RN );
    v_5     :=  NVL(p_5 ,Pkg_Glb.C_RN );
    v_6     :=  NVL(p_6 ,Pkg_Glb.C_RN );
    v_7     :=  NVL(p_7 ,Pkg_Glb.C_RN );
    v_8     :=  NVL(p_8 ,Pkg_Glb.C_RN );
    v_9     :=  NVL(p_9 ,Pkg_Glb.C_RN );
    v_10    :=  NVL(p_10,Pkg_Glb.C_RN );

    BEGIN
        v_result    :=  p_it(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7)(v_8)(v_9)(v_10);
    EXCEPTION
        WHEN OTHERS THEN
            v_result    :=  0;
    END;
    RETURN v_result;
END;
/*********************************************************************************
    DDL: 28/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE   p_trav_mdim     (   p_it_in       IN OUT    NOCOPY      Pkg_Glb.type_dim_10,
                                p_it_out      OUT       NOCOPY      Pkg_Glb.type_rdima
                            )
IS
    v_1     VARCHAR2(100);
    v_2     VARCHAR2(100);
    v_3     VARCHAR2(100);
    v_4     VARCHAR2(100);
    v_5     VARCHAR2(100);
    v_6     VARCHAR2(100);
    v_7     VARCHAR2(100);
    v_8     VARCHAR2(100);
    v_9     VARCHAR2(100);
    v_10    VARCHAR2(100);

    v_row   Pkg_Glb.type_rdim;
BEGIN

    v_1     :=  p_it_in.FIRST;
    WHILE v_1 IS NOT NULL LOOP
        v_2     :=  p_it_in(v_1).FIRST;
        WHILE v_2 IS NOT NULL LOOP
            v_3     :=  p_it_in(v_1)(v_2).FIRST;
            WHILE v_3 IS NOT NULL LOOP

                v_4     :=  p_it_in(v_1)(v_2)(v_3).FIRST;
                WHILE v_4 IS NOT NULL LOOP

                    v_5     :=  p_it_in(v_1)(v_2)(v_3)(v_4).FIRST;
                    WHILE v_5 IS NOT NULL LOOP

                        v_6     :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5).FIRST;
                        WHILE v_6 IS NOT NULL LOOP

                            v_7     :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6).FIRST;
                            WHILE v_7 IS NOT NULL LOOP

                                v_8     :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7).FIRST;
                                WHILE v_8 IS NOT NULL LOOP

                                    v_9     :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7)(v_8).FIRST;
                                    WHILE v_9 IS NOT NULL LOOP

                                        v_10     :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7)(v_8)(v_9).FIRST;
                                        WHILE v_10 IS NOT NULL LOOP
                                            v_row.d_1   :=  v_1;
                                            v_row.d_2   :=  v_2;
                                            v_row.d_3   :=  v_3;
                                            v_row.d_4   :=  v_4;
                                            v_row.d_5   :=  v_5;
                                            v_row.d_6   :=  v_6;
                                            v_row.d_7   :=  v_7;
                                            v_row.d_8   :=  v_8;
                                            v_row.d_9   :=  v_9;
                                            v_row.d_10  :=  v_10;

                                            v_row.val   :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7)(v_8)(v_9)(v_10);

                                            p_it_out(p_it_out.COUNT +1) :=  v_row;

                                            v_10 :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7)(v_8)(v_9).NEXT(v_10);
                                        END LOOP;

                                        v_9 :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7)(v_8).NEXT(v_9);
                                    END LOOP;


                                    v_8 :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6)(v_7).NEXT(v_8);
                                END LOOP;

                                v_7 :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5)(v_6).NEXT(v_7);
                            END LOOP;


                            v_6 :=  p_it_in(v_1)(v_2)(v_3)(v_4)(v_5).NEXT(v_6);
                        END LOOP;

                        v_5 :=  p_it_in(v_1)(v_2)(v_3)(v_4).NEXT(v_5);
                    END LOOP;

                    v_4 :=  p_it_in(v_1)(v_2)(v_3).NEXT(v_4);
                END LOOP;

                v_3 :=  p_it_in(v_1)(v_2).NEXT(v_3);
            END LOOP;
            v_2 :=  p_it_in(v_1).NEXT(v_2);
        END LOOP;
        v_1 :=  p_it_in.NEXT(v_1);
    END LOOP;




END;






/**********************************************************************************************************
    DDL:    22/03/2008  d   Create
**********************************************************************************************************/
FUNCTION f_rep_footer       RETURN VARCHAR2
-----------------------------------------------------------------------------------------------------------
--    returns the CURRENT CLIENT global variable
-----------------------------------------------------------------------------------------------------------
IS
    v_rez       VARCHAR2(500);
BEGIN
    v_rez       :=  'Easy Logistic Software - Raport printat de '||Pkg_Lib.f_return_user_code;
    v_rez       :=   v_rez || ' la data de '||TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi');
    RETURN v_rez;
END;


/**********************************************************************************************************
    DDL:    26/06/2008  d   Create
**********************************************************************************************************/
FUNCTION f_diff_c (  p_1 VARCHAR2, p_2 VARCHAR2)       RETURN INTEGER
-----------------------------------------------------------------------------------------------------------
--    returns the CURRENT CLIENT global variable
-----------------------------------------------------------------------------------------------------------
IS
    v_rez       INTEGER;
BEGIN
    IF Pkg_Lib.f_mod_c(p_1, p_2) THEN
        v_rez := -1;
    ELSE
        v_rez := 0;
    END IF;
    RETURN v_rez;
END;



END;

/

/
