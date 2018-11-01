--------------------------------------------------------
--  DDL for Package Body PKG_ERR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_ERR" 
IS

TYPE    type_err_msg1       IS TABLE OF VW_ERROR%ROWTYPE  INDEX BY BINARY_INTEGER       ;
TYPE    type_err_msg2       IS TABLE OF type_err_msg1     INDEX BY Pkg_Glb.type_index   ;
it_err_msg                  type_err_msg2;

---------------------------------------------------------------------------------------
FUNCTION f_err_msg(p_sqlcode INTEGER,p_sqlerrm VARCHAR2) RETURN VARCHAR2
IS
 
    CURSOR C_EXCEPTION1(p_sqlcode INTEGER, p_num_tabel VARCHAR2, p_num_col VARCHAR2) IS
        SELECT  *
        FROM    APP_EXCEPTIONS
        WHERE       SQLCODE     = p_sqlcode
                AND num_tabel   = p_num_tabel
                AND num_col     = p_num_col
    ;   
 
    CURSOR C_EXCEPTION2(p_sqlcode INTEGER, p_num_excep VARCHAR2) IS
        SELECT  *
        FROM    APP_EXCEPTIONS
        WHERE       SQLCODE  = p_sqlcode
                AND num_excep = p_num_excep
    ;   
 
 
    v_row_exc           APP_EXCEPTIONS%ROWTYPE;
    v_token             VARCHAR2(32000);
    v_errmsg            VARCHAR2(32000);
    v_num_tabel         VARCHAR2(30);
    v_num_col           VARCHAR2(30);
    v_num_excep         VARCHAR2(30);
    v_found             BOOLEAN;

BEGIN
 
    IF p_sqlcode = -20001 THEN
        -- if user reaised error I do not do annything with it !!!
        v_errmsg := p_sqlerrm;
    ELSE 
        v_token  :=  SUBSTR(p_sqlerrm,INSTR(p_sqlerrm,'(',1) +1);
        v_token  :=  SUBSTR(v_token,1,INSTR(v_token,')',1)-1);
        v_token  := REPLACE(v_token,'"',NULL);
  
        IF p_sqlcode IN (-1400,-1407) THEN  -- insert/update cu valoare nula 
     
            v_num_tabel:=SUBSTR(v_token,INSTR(v_token,'.',1,1) +1, (INSTR(v_token,'.',1,2) - INSTR(v_token,'.',1,1) -1));
            v_num_col  :=SUBSTR(v_token,INSTR(v_token,'.',1,2) +1);
      
            OPEN  C_EXCEPTION1(-1400, v_num_tabel, v_num_col);
            FETCH C_EXCEPTION1 INTO v_row_exc;
            v_found  := C_EXCEPTION1%FOUND;
            CLOSE C_EXCEPTION1;
       
            IF v_found THEN
                v_errmsg := v_row_exc.err_msg;
            ELSE
                v_errmsg := 'Nu se poate insera o valoare nula in coloana '||v_num_col||' din tabela '||v_num_tabel||'!!!';
            END IF;  
      
        ELSIF p_sqlcode IN (-2290,-2291,-2292,-1) THEN
     
            v_num_excep :=SUBSTR(v_token,INSTR(v_token,'.',1,1) +1);
         
            OPEN  C_EXCEPTION2(p_sqlcode, v_num_excep);
            FETCH C_EXCEPTION2 INTO v_row_exc;
            v_found  := C_EXCEPTION2%FOUND;
            CLOSE C_EXCEPTION2;
     
            IF v_found THEN
                v_errmsg := v_row_exc.err_msg;
            END IF;
      
        ELSIF p_sqlcode IN (-6502,-1438) THEN
     
            v_errmsg := 'Valoare incorecta !!!';
      
        ELSE   
     
          NULL;  
     
        END IF;
      
        v_errmsg := v_errmsg ||Pkg_Glb.C_NL||Pkg_Glb.C_NL 
                    || ' ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE()||p_sqlerrm||')';
        v_errmsg := SUBSTR(v_errmsg,1,2040);
        v_errmsg := '<<'|| v_errmsg || '>>';
    END IF;
 
    RETURN  v_errmsg;

END;



-----------------------------------------------------------------------------------------
PROCEDURE   p_reset_error_message
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    Pkg_Err.it_err_msg.DELETE;
    DELETE FROM VW_ERROR;
    COMMIT;
END;
-----------------------------------------------------------------------------------------
/*
pkg_err.p_set_error_message(    p_err_code          =>, 
                                p_err_header        =>, 
                                p_err_detail        =>,
                                p_flag_immediate    => 'N'
                           );
*/

PROCEDURE   p_set_error_message(    p_err_code          VARCHAR2, 
                                    p_err_header        VARCHAR2, 
                                    p_err_detail        VARCHAR2,
                                    p_flag_immediate    VARCHAR2 DEFAULT 'N'
                               )
IS

BEGIN
    IF Pkg_Err.it_err_msg.EXISTS(p_err_code) THEN
        IF p_err_detail IS NOT NULL THEN
            Pkg_Err.it_err_msg(p_err_code)
                    (Pkg_Err.it_err_msg(p_err_code).COUNT + 1).message  :=  p_err_detail;    
        END IF;
    ELSE
        Pkg_Err.it_err_msg(p_err_code)(1).message   :=  RPAD('-',90,'-');
        Pkg_Err.it_err_msg(p_err_code)(2).message   :=  p_err_header;
        IF p_err_detail IS NOT NULL THEN
            Pkg_Err.it_err_msg(p_err_code)(3).message   :=  p_err_detail;        
        END IF;
    END IF;
    
    IF p_flag_immediate = 'Y' THEN 
        Pkg_Err.p_raise_error_message(); 
    END IF;

END;
------------------------------------------------------------------------------------------
PROCEDURE  p_dump_error_message(p_flag_clear_array  VARCHAR2 DEFAULT 'Y')
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_idx       Pkg_Glb.type_index;
    v_idx2      PLS_INTEGER         := 0;
    v_row       VW_ERROR%ROWTYPE;
BEGIN
    v_idx   :=  Pkg_Err.it_err_msg.FIRST;
    WHILE v_idx IS NOT NULL LOOP
        FOR i IN 1..Pkg_Err.it_err_msg(v_idx).COUNT LOOP
            v_idx2   :=  v_idx2   + 1;
            v_row.message       :=  Pkg_Err.it_err_msg(v_idx)(i).message;
            v_row.seq_no        :=  v_idx2;
           
            INSERT INTO VW_ERROR 
            VALUES      v_row;
        END LOOP;
        v_idx   :=  Pkg_Err.it_err_msg.NEXT(v_idx);
    END LOOP;
    -- there are cases when the p_raise_error_message is called in the ACCESS interface
    -- but the error are dumped in PLSQL before, in this case we need NOT clear the array
    IF p_flag_clear_array = 'Y' THEN
        Pkg_Err.it_err_msg.DELETE;
    END IF;
    COMMIT;
END;
--------------------------------------------------------------------------------------------
PROCEDURE p_raise_error_message( p_err_code          VARCHAR2 DEFAULT NULL)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    
    v_idx       Pkg_Glb.type_index;
    v_idx2      PLS_INTEGER         := 0;
    v_row       VW_ERROR%ROWTYPE;
    v_row_log   APP_LOG%ROWTYPE;
    v_raise     BOOLEAN;
BEGIN
    v_raise :=  FALSE;
    IF p_err_code IS NULL THEN
        IF  Pkg_Err.it_err_msg.COUNT > 0 THEN
            v_raise     :=  TRUE;
        END IF;
    ELSE
        IF Pkg_Err.it_err_msg.EXISTS(p_err_code) THEN
            v_raise     :=  TRUE;
        END IF;
    END IF;
    --
    IF v_raise  THEN
        v_idx   :=  Pkg_Err.it_err_msg.FIRST;
        WHILE v_idx IS NOT NULL LOOP
            FOR i IN 1..Pkg_Err.it_err_msg(v_idx).COUNT LOOP
                v_idx2   :=  v_idx2   + 1;
                v_row.message       :=  Pkg_Err.it_err_msg(v_idx)(i).message;
                v_row.seq_no        :=  v_idx2;
                --
                INSERT INTO VW_ERROR 
                VALUES      v_row;
                --
                IF v_row.message <> RPAD('-',90,'-') THEN
                    v_row_log.msg_type      :=  'L';
                    v_row_log.msg_text      :=  v_row.message;
                    v_row_log.msg_context   :=  v_idx;
                    --
                    INSERT --+ APPEND
                    INTO APP_LOG
                    VALUES  v_row_log;
                END IF;
                --                
            END LOOP;
            v_idx   :=  Pkg_Err.it_err_msg.NEXT(v_idx);
        END LOOP;
        --
        Pkg_Err.it_err_msg.DELETE;
        --
    END IF;
    --
    COMMIT;    
    --  
    IF v_raise THEN 
        RAISE_APPLICATION_ERROR(-20999,NULL);  
    END IF;
END;
--------------------------------------------------------------------------------------------
FUNCTION    f_check_error_message ( p_err_code          VARCHAR2 DEFAULT NULL) RETURN BOOLEAN
IS
v_result    BOOLEAN :=  FALSE;
BEGIN
    IF p_err_code IS NULL THEN
        IF Pkg_Err.it_err_msg.COUNT > 0 THEN 
            v_result    :=   TRUE;
        END IF;    
    ELSE
        IF Pkg_Err.it_err_msg.EXISTS(p_err_code) THEN
            v_result    :=   TRUE;
        END IF;
    END IF;
    RETURN v_result;
END;

/*************************************************************************
    DDL:    17/06/2008  d   Create
/*************************************************************************/
PROCEDURE p_err (   p_errmsg VARCHAR2, p_context VARCHAR2)
--------------------------------------------------------------------------
--  PURPOSE:    insert the error message in the log, for further raise  
--------------------------------------------------------------------------
IS
BEGIN
    Pkg_App_Tools.P_Log(    'M',
                            p_errmsg,
                            p_context);
END;

/*************************************************************************
    DDL:    17/06/2008  d   Create
/*************************************************************************/
PROCEDURE p_rae
--------------------------------------------------------------------------
--  PURPOSE:    raise a multiple error   
--------------------------------------------------------------------------
IS
BEGIN
    Pkg_Lib.p_rae_m('B');
END;

/*************************************************************************
    DDL:    17/06/2008  d   Create
/*************************************************************************/
PROCEDURE p_rae (   p_errstr    VARCHAR2)
--------------------------------------------------------------------------
--  PURPOSE:    raise a single error    
--------------------------------------------------------------------------
IS
BEGIN
    Pkg_Lib.p_rae(p_errstr);
END;



END;

/

/
