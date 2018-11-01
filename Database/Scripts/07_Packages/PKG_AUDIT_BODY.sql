--------------------------------------------------------
--  DDL for Package Body PKG_AUDIT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_AUDIT" AS

FUNCTION f_return_faudit RETURN INTEGER
IS
 v_rezultat    INTEGER;
BEGIN
 IF sys_context('APP_AUDIT_CONTEXT','AUDIT') IS NULL THEN
  v_rezultat := 0;
 ELSE
  v_rezultat := -1;
 END IF;
 RETURN v_rezultat;
END;

----------------------------------------------------------------------------------------
PROCEDURE p_set_audit (p_val INTEGER)
----------------------------------------------------------------------------------------
-- seteaza FLAG-ul de audit (variabila de context)
----------------------------------------------------------------------------------------
IS
BEGIN
 IF p_val <> 0 THEN
   dbms_session.set_context('APP_AUDIT_CONTEXT','AUDIT','OFF');
 ELSE
   dbms_session.clear_context('APP_AUDIT_CONTEXT',NULL,'AUDIT');
 END IF;
END;

------------------------------------------------------------------------------------------
PROCEDURE p_app_audit_insert ( p_tbl_oper   VARCHAR2,
                               p_tbl_name   VARCHAR2,
                               p_tbl_idriga INTEGER,
                               p_tbl_idx1   VARCHAR2,
                               p_tbl_idx2   VARCHAR2,
                               p_note       VARCHAR2
                              )
IS
    v_row   APP_AUDIT%ROWTYPE;
BEGIN

    v_row.tbl_name      :=  UPPER(trim(p_tbl_name));
    v_row.tbl_idriga    :=  p_tbl_idriga;
    v_row.tbl_idx1      :=  p_tbl_idx1;
    v_row.tbl_idx2      :=  p_tbl_idx2;
    v_row.tbl_oper      :=  p_tbl_oper;
    v_row.note          :=  SUBSTR(p_note,1,4000);

    INSERT --+ APPEND
    INTO    APP_AUDIT
    VALUES  v_row;

END;


/***********************************************************************************/
FUNCTION f_sql_audit_tables     RETURN typ_frm pipelined
IS
    CURSOR  C_LINII IS
                    SELECT      *
                    FROM        APP_TABLE
                    WHERE       object_type     =   'T'
                    ORDER BY    tbl_name
                    ;

    v_row tmp_frm := tmp_frm();

BEGIN
    FOR X IN C_LINII LOOP
        v_row.idriga := X.idriga;
        v_row.txt01  := x.tbl_name;
        v_row.txt02  := x.descr_audit_idx1;
        v_row.txt03  := x.descr_audit_idx2;

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;




FUNCTION f_sql_audit_list   (   p_tbl_name  VARCHAR2,
                                p_idx1      VARCHAR2,
                                p_idx2      VARCHAR2,
                                p_datain    DATE,
                                p_datasf    DATE,
                                p_note      VARCHAR2,
                                p_line_id   NUMBER          DEFAULT NULL
                            )   RETURN      typ_frm         pipelined
IS

    CURSOR  C_LINES (           p_tbl_name      VARCHAR2,
                                p_idx1          VARCHAR2,
                                p_idx2          VARCHAR2,
                                p_datain        DATE,
                                p_datasf        DATE,
                                p_note          VARCHAR2,
                                p_line_id       NUMBER
                    )
                    IS
                    SELECT      *
                    FROM        APP_AUDIT
                    WHERE       tbl_name        =       p_tbl_name
                        AND     (
                                tbl_idx1        IS NULL
                                OR
                                tbl_idx1 LIKE    NVL(p_idx1,'%')
                                )
                        AND     (
                                tbl_idx2        IS NULL
                                OR
                                tbl_idx2        LIKE    NVL(p_idx2,'%')
                                )
                        AND     TRUNC(datagg)   BETWEEN NVL(p_datain, SYSDATE-100)
                                                    AND NVL(p_datasf, TRUNC(SYSDATE))
                        AND     note            LIKE    '%' || p_note ||'%'
                        AND     (
                                (
                                p_line_id IS NOT NULL
                                AND
                                tbl_idriga          =   p_line_id
                                )
                                OR
                                p_line_id IS NULL
                                )
                   ORDER BY datagg DESC
                   ;

    v_row  tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES(UPPER(p_tbl_name), p_idx1,p_idx2,p_datain, p_datasf, p_note,p_line_id)
    LOOP
        v_row.idriga := X.idriga;
        v_row.seq_no    :=  C_LINES%rowcount;
        
        v_row.txt01  := TO_CHAR(X.datagg,'yyyy/mm/dd hh24:mi');
        v_row.txt02  := X.workst;
        v_row.txt03  := X.iduser;
        v_row.txt04  := X.tbl_idriga;
        v_row.txt05  := X.tbl_idx1;
        v_row.txt06  := X.tbl_idx2;
        v_row.txt07  := X.tbl_oper;
        v_row.txt08  := X.tbl_name;
        
        v_row.txt20  := X.note;

        pipe ROW(v_row);
    END LOOP;

    RETURN;
END;


FUNCTION f_sql_audit_line   (   p_idriga    NUMBER, 
                                p_tbl_name  VARCHAR2,
                                p_line_id   NUMBER          
                            )   RETURN      typ_frm         pipelined
IS

    CURSOR  C_LINES (           p_tbl_name      VARCHAR2,
                                p_line_id       NUMBER
                    )
                    IS
                    SELECT      *
                    FROM        APP_AUDIT
                    WHERE       tbl_name        =   p_tbl_name
                        AND     tbl_idriga      =   p_line_id
                    ORDER BY    datagg DESC
                    ;

    v_row  tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES(UPPER(p_tbl_name), p_line_id)
    LOOP
        v_row.idriga := X.idriga;
        v_row.seq_no    :=  C_LINES%rowcount;
        
        v_row.txt01  := TO_CHAR(X.datagg,'yyyy/mm/dd hh24:mi');
        v_row.txt02  := X.workst;
        v_row.txt03  := X.iduser;
        v_row.txt04  := X.tbl_idriga;
        v_row.txt05  := X.tbl_idx1;
        v_row.txt06  := X.tbl_idx2;
        v_row.txt07  := X.tbl_oper;
        v_row.txt08  := X.tbl_name;
        
        v_row.txt20  := X.note;

        pipe ROW(v_row);
    END LOOP;

    RETURN;
END;


END;

/

/
