--------------------------------------------------------
--  DDL for Package Body PKG_TEH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_TEH" 
AS

/*********************************************************************************************
    21/04/2008  d   Create

/*********************************************************************************************/
FUNCTION f_sql_item_variable    (   p_line_id       NUMBER,
                                    p_org_code      VARCHAR2, 
                                    p_item_code     VARCHAR2)         RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for ITEM_VARIABLE subform 
----------------------------------------------------------------------------------------------
IS

    CURSOR     C_LINES      (p_org_code VARCHAR2, p_item_code VARCHAR2)
                            IS
                            SELECT      iv.idriga,iv.dcn,
                                        iv.org_code, iv.item_code, iv.var_code, iv.var_value,
                                        v.description       v_description,
                                        m.description       m_description,
                                        i.description       i_description
                            -----------------------------------------------------------------------------
                            FROM        ITEM_VARIABLE   iv
                            INNER JOIN  TEH_VARIABLE    v   ON  v.org_code      =   iv.org_code
                                                            AND v.var_code      =   iv.var_code
                            LEFT JOIN   MULTI_TABLE     m   ON  m.table_name    =   'TEHVAR_'||iv.var_code
                                                            AND m.table_key     =   iv.var_value
                                                            AND v.var_code      <>  'CALAPOD'
                            LEFT JOIN   ITEM            i   ON  i.org_code      =   iv.org_code
                                                            AND i.item_code     =   iv.var_value
                                                            AND iv.var_code     =   'CALAPOD'
                            -----------------------------------------------------------------------------
                            WHERE       iv.org_code     =   p_org_code
                                AND     iv.item_code    =   p_item_code
                                AND     p_line_id       IS NULL
                            UNION ALL
                            SELECT      0,0,
                                        p_org_code, p_item_code, '', '',
                                        ''                  v_description,
                                        ''                  m_description,
                                        ''                  i_description
                            FROM        dual
                            WHERE       p_line_id       =   -1
                            ;

    v_row      tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES (p_org_code, p_item_code)
    LOOP

        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.item_code;
        v_row.txt03     :=  x.var_code;
        v_row.txt04     :=  x.v_description;
        v_row.txt05     :=  x.var_value;
        v_row.txt06     :=  NVL(x.i_description, x.m_description);

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************************
    DDL:    30/05/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_item_variable_iud       (   p_tip       VARCHAR2,
                                        p_row       ITEM_VARIABLE%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on ITEM_VARIABLE table 
-----------------------------------------------------------------------------------------------------------
IS
    v_row       ITEM_VARIABLE%ROWTYPE;
BEGIN

    v_row       :=  p_row;

    Pkg_Iud.p_item_variable_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

FUNCTION f_str_item_variable    (   p_org_code  VARCHAR2, p_item_code   VARCHAR2)
                                RETURN  VARCHAR2
IS

    CURSOR C_VAR    (p_org_code VARCHAR2, p_item_code VARCHAR2)
                    IS
                    SELECT      iv.var_code         , 
                                iv.var_value        , 
                                v.description       ,
                                m.description       m_description,
                                i.description       i_description
                    ----------------------------------------------------------------
                    FROM        ITEM_VARIABLE   iv
                    INNER JOIN  TEH_VARIABLE    v   ON  v.org_code      =   iv.org_code
                                                    AND v.var_code      =   iv.var_code
                    LEFT JOIN   MULTI_TABLE     m   ON  m.table_name    =   'TEHVAR_'||iv.var_code
                                                    AND m.table_key     =   iv.var_value
                                                    AND v.var_code      <>  'CALAPOD'
                    LEFT JOIN   ITEM            i   ON  i.org_code      =   iv.org_code
                                                    AND i.item_code     =   iv.var_value
                                                    AND iv.var_code     =   'CALAPOD'
                    ----------------------------------------------------------------
                    WHERE       iv.org_code        =   p_org_code
                        AND     iv.item_code       =   p_item_code
                    ORDER BY    v.sql_lov
                    ;

    v_rez_1         VARCHAR2(2000);
    v_rez_2         VARCHAR2(2000);
    v_length        INTEGER;

BEGIN

    FOR x IN C_VAR  (p_org_code, p_item_code)
    LOOP
        v_length    :=  GREATEST(LENGTH(x.description), LENGTH(NVL(x.m_description, x.i_description)));
        v_rez_1     :=  v_rez_1 ||  RPAD(x.description,v_length + 3,' ');
        v_rez_2     :=  v_rez_2 ||  RPAD(NVL(x.m_description, x.i_description),v_length + 3,' ');
    END LOOP;
    IF v_rez_1 IS NOT NULL AND v_rez_2 IS NOT NULL THEN 
        v_rez_2     :=  v_rez_1 || Pkg_Glb.C_NL || v_rez_2 || Pkg_Glb.C_NL;
    END IF;

    RETURN v_rez_2;
END;

END;

/

/
