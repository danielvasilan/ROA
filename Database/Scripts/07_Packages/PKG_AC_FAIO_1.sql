--------------------------------------------------------
--  DDL for Package Body PKG_AC_FAIO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_AC_FAIO" 
AS
-----------------------------------------------------------------------------------------------
--  DDL:        29.07.2008 d Create package
--   
--  PURPOSE:    Fixed-assets + Inventory Objects logics 
-----------------------------------------------------------------------------------------------

/*********************************************************************************************
    22/05/2008  d   Create 

/*********************************************************************************************/
FUNCTION f_sql_fixed_asset      (   p_idriga        NUMBER, 
                                    p_org_code      VARCHAR2,
                                    p_status        VARCHAR2
                                )   RETURN          typ_longinfo     pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for fixed-asset form 
----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES          (           p_idriga            NUMBER,
                                        p_status            VARCHAR2)
                            IS
                            SELECT      f.*,
                                        c.description       c_description
                            ---------------------------------------------------------------------------
                            FROM        FIXED_ASSET         f
                            INNER JOIN  FIXED_ASSET_CATEG   c   ON  c.category_code =   f.category_code
                            ----------------------------------------------------------------------------
                            WHERE       f.status            IN( SELECT txt01 
                                                                FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_status,',')))
                                AND     p_idriga            IS NULL
                            ----
                            UNION ALL
                            ----
                            SELECT      f.*,
                                        c.description       c_description
                            ---------------------------------------------------------------------------
                            FROM        FIXED_ASSET         f
                            INNER JOIN  FIXED_ASSET_CATEG   c   ON  c.category_code =   f.category_code
                            ----------------------------------------------------------------------------
                            WHERE       f.idriga            =   p_idriga
                                AND     p_idriga            IS NOT NULL
                            ;
   
    CURSOR C_DEPREC         (           p_curr_value    NUMBER, 
                                        p_start_date    DATE, 
                                        p_deprec_months NUMBER,
                                        p_deprec_type   VARCHAR2
                            )
                            IS
                            SELECT      *
                            FROM        TABLE(Pkg_Ac_Faio.f_sql_depreciation
                                                (   p_curr_value,
                                                    p_start_date,
                                                    SYSDATE,
                                                    p_deprec_months,
                                                    p_deprec_type)
                                                )
                            ;

    -- return the current value for the FA, including the initial value, over-tinme
    CURSOR C_GET_VALUE      (p_fa_code  VARCHAR2)
                            IS
                            SELECT      SUM(t.trn_sign*t.trn_value) curr_value
                            FROM        FA_TRN      t
                            WHERE       fa_code     =   p_fa_code
                            ;

    v_row                   tmp_longinfo := tmp_longinfo();
    v_txt_deprec            VARCHAR2(2000);
    v_curr_value            NUMBER;

BEGIN

    FOR X IN C_LINES (p_idriga, p_status)
    LOOP
        -- get the current value of the FA  
        OPEN C_GET_VALUE(x.fa_code); FETCH C_GET_VALUE INTO v_curr_value; CLOSE C_GET_VALUE;
        -- get the depreciation for the future 
        v_txt_deprec    :=  RPAD('Data',6,' ')||LPAD('Rata',10,' ')||LPAD('Ramas',10,' ')||Pkg_Glb.C_NL;
        IF x.date_start IS NOT NULL THEN
            FOR xx IN C_DEPREC (v_curr_value, x.date_start, x.deprec_months, x.deprec_type)
            LOOP
                IF LENGTH(v_txt_deprec) > 1500 THEN
                    v_txt_deprec:=  v_txt_deprec||'..................';
                    EXIT;
                ELSE
                    v_txt_deprec:=  v_txt_deprec||
                                    RPAD(TO_CHAR(xx.data01,'mm/yy'),6)||
                                    LPAD(TRUNC(xx.numb01,2),10)||
                                    LPAD(TRUNC(xx.numb02,2),10)||
                                    Pkg_Glb.C_NL;
                END IF;
            END LOOP;
        ELSE
                v_txt_deprec:=  v_txt_deprec||
                                RPAD('??/??',6)||
                                LPAD('???',10)||
                                LPAD(v_curr_value,10)||
                                Pkg_Glb.C_NL;            
        END IF;

        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;
        
        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.fa_code;
        v_row.txt03     :=  x.inventory_code;
        v_row.txt04     :=  x.description;
        v_row.txt05     :=  x.category_code;
        v_row.txt06     :=  x.deprec_type;
        v_row.txt07     :=  x.resp_user;
        v_row.txt08     :=  x.resp_costcenter;
        v_row.txt09     :=  x.whs_stock;
        v_row.txt10     :=  x.status;
        v_row.txt11     :=  x.c_description;
        v_row.txt50     :=  v_txt_deprec;
        v_row.numb01    :=  x.deprec_months;
        v_row.numb02    :=  v_curr_value;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    DDL:    31/07/2008  d   created 
/*********************************************************************************************/
PROCEDURE p_fixed_asset_blo (   p_tip           VARCHAR2,
                                p_row   IN OUT  FIXED_ASSET%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    Row level BLO for fixed_asset 
----------------------------------------------------------------------------------------------
IS
    v_row_fac               FIXED_ASSET_CATEG%ROWTYPE;
    v_found                 BOOLEAN;
BEGIN

    CASE p_tip 
        WHEN    'I' THEN
                    -- get the category_code 
                    v_row_fac.category_code :=  p_row.category_code;
                    v_found :=  Pkg_Get2.f_get_fixed_asset_categ_2(v_row_fac);
                    IF NOT v_found THEN Pkg_Err.p_rae('Categoria este necunoscuta !'); END IF;
                    -- set initial values 
                    p_row.status            :=  'I';
                    p_row.deprec_months     :=  NVL(p_row.deprec_months, v_row_fac.min_months);

        WHEN    'U' THEN
                    NULL;
        WHEN    'D' THEN
                    NULL;
        ELSE
                    Pkg_Err.p_rae('p_fixed_asset_blo: Case condition NN ='||p_tip);
    END CASE;
    
END;

/*********************************************************************************************************
    DDL:    31/07/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_fixed_asset_iud     (   p_tip       VARCHAR2,
                                    p_row       FIXED_ASSET%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on FIXED_ASSET table
-----------------------------------------------------------------------------------------------------------
IS
    v_row       FIXED_ASSET%ROWTYPE;
BEGIN

    v_row       :=  p_row;

    -- BLO 
    p_fixed_asset_blo(p_tip, v_row);

    -- IUD 
    Pkg_Iud.p_fixed_asset_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************
    DDL:    01/08/2008  d   created 
/*********************************************************************************************/
PROCEDURE p_fa_trn_blo      (   p_tip           VARCHAR2,
                                p_row   IN OUT  FA_TRN%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    Row level BLO for fa_trn  
----------------------------------------------------------------------------------------------
IS
    CURSOR C_GET_SEQ    (p_fa_code VARCHAR2)
                        IS
                        SELECT  MAX(seq_no)
                        FROM    FA_TRN
                        WHERE   fa_code     =   p_fa_code
                        ;

    v_row               FA_TRN%ROWTYPE;
    v_row_fa            FIXED_ASSET%ROWTYPE;
    v_found             BOOLEAN;
    v_seq_no            INTEGER;
BEGIN

    -- get the 
    v_row_fa.fa_code:=  p_row.fa_code;
    v_found         :=  Pkg_Get2.f_get_fixed_asset_2(v_row_fa);

    -- checks 


    -- 
    CASE p_tip 
        WHEN    'I' THEN    
                        OPEN    C_GET_SEQ(p_row.fa_code);
                        FETCH   C_GET_SEQ INTO v_seq_No;
                        CLOSE   C_GET_SEQ;
                        p_row.seq_no    :=  NVL(v_seq_no, 0) + 10;
        WHEN    'U' THEN
                        IF v_row.trn_type = 'ACHIZ' THEN
                            v_row_fa.date_in    :=  v_row.trn_date;
                            Pkg_Iud.p_fixed_asset_iud('U',v_row_fa);
                        END IF;
                        -- 
                        IF v_row.trn_type = 'USE' THEN
                            v_row_fa.date_start :=  v_row.trn_date;
                            Pkg_Iud.p_fixed_asset_iud('U',v_row_fa);
                        END IF;
        ELSE
                        NULL;
    END CASE;

END;
/*********************************************************************************************************
    DDL:    31/07/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_fa_trn_iud          (   p_tip       VARCHAR2,
                                    p_row       FA_TRN%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on FA_TRN table
-----------------------------------------------------------------------------------------------------------
IS
    v_row       FA_TRN%ROWTYPE;
BEGIN

    v_row       :=  p_row;

    -- BLO 
    p_fa_trn_blo(p_tip, v_row);

    -- IUD 
    Pkg_Iud.p_fa_trn_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************
    31/07/2008  d   Create 
/*********************************************************************************************/
FUNCTION f_sql_fa_trn           (   p_idriga            NUMBER,
                                    p_fa_code           VARCHAR2
                                )   RETURN              typ_frm     pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the amortizations for a fixed asset, from the date when is in use  
--              - used by the FRM_FA_DEPREC subform 
--                  and by any procedure that wnats to determine the amortization details  
----------------------------------------------------------------------------------------------
IS

    CURSOR C_TRN        (   p_idriga NUMBER, p_fa_code   VARCHAR2)
                        IS
                        SELECT      t.*,
                                    f.deprec_type, f.deprec_months,
                                    o.org_name      o_org_name
                        ---------------------------------------------------------------------
                        FROM        FA_TRN          t
                        INNER JOIN  FIXED_ASSET     f   ON  f.fa_code   =   t.fa_code
                        LEFT JOIN   ORGANIZATION    o   ON  o.org_code  =   t.supplier_code
                        ---------------------------------------------------------------------
                        WHERE       t.fa_code       =   p_fa_code
                            AND     p_idriga        IS NULL
                        -- 
                        UNION ALL
                        --
                        SELECT      t.*,
                                    f.deprec_type, f.deprec_months,
                                    o.org_name      o_org_name
                        ---------------------------------------------------------------------
                        FROM        FA_TRN          t
                        INNER JOIN  FIXED_ASSET     f   ON  f.fa_code   =   t.fa_code
                        LEFT JOIN   ORGANIZATION    o   ON  o.org_code  =   t.supplier_code
                        ---------------------------------------------------------------------
                        WHERE       t.idriga        =   p_idriga
                            AND     p_idriga        IS NOT NULL
                        ;   

    v_row_fa            FIXED_ASSET%ROWTYPE;
    v_row               tmp_frm := tmp_frm();
    v_found             BOOLEAN;
    v_amort_rate        NUMBER;
    v_remained          NUMBER;
    v_start_date        DATE;

BEGIN
    
        FOR x IN C_TRN(p_idriga, p_fa_code)
        LOOP

            IF x.trn_type = 'USE' THEN
                v_start_date    :=  x.trn_date;
            END IF;

            v_remained      :=  NVL(v_remained, 0) + x.trn_sign * x.trn_value;

            v_row.idriga    :=  x.idriga;
            v_row.dcn       :=  x.dcn;
            v_row.seq_no    :=  x.seq_no;

            v_row.txt01     :=  x.fa_code;
            v_row.txt02     :=  x.trn_type;
            v_row.txt03     :=  x.description;
            v_row.txt04     :=  x.doc_code;
            v_row.txt05     :=  x.supplier_code;
            v_row.txt06     :=  x.o_org_name;
            v_row.txt07     :=  x.trn_currency; 
            v_row.txt08     :=  x.resp_user;
            v_row.txt09     :=  x.resp_cdc;

            v_row.numb01    :=  x.seq_no;
            v_row.numb02    :=  x.trn_sign;
            v_row.numb03    :=  TRUNC(x.trn_value,2);
            v_row.numb04    :=  TRUNC(x.weight_diff,2);
            v_row.numb05    :=  TRUNC(v_remained,2);

            v_row.data01    :=  x.trn_date;

            pipe ROW (v_row);

        END LOOP;

    RETURN;

END;


/*********************************************************************************************
    31/07/2008  d   Create 
/*********************************************************************************************/
FUNCTION f_sql_depreciation     (   p_curr_value        NUMBER,
                                    p_start_date        DATE,
                                    p_curr_date         DATE,
                                    p_deprec_months     INTEGER,
                                    p_deprec_type       VARCHAR2
                                )   RETURN              typ_frm     pipelined
IS
    
    v_start_date        DATE;   -- first day after the FA was put in production 
    v_next_date         DATE;   -- next depreciation date (first day of the folowing month) 
    v_row               tmp_frm := tmp_frm();
    v_remained_months   NUMBER(3);
    v_idx               PLS_INTEGER;

BEGIN

    v_start_date        :=  TO_DATE('01'||TO_CHAR(p_start_date,'mmyyyy'), 'ddmmyyyy');
    v_next_date         :=  LAST_DAY(TRUNC(p_curr_date))+1;

    v_remained_months   :=  p_deprec_months - MONTHS_BETWEEN(v_next_date, v_start_date);

    FOR v_idx IN 1..v_remained_months
    LOOP
        v_row.data01    :=  ADD_MONTHS(v_start_date,v_idx);
        v_row.numb01    :=  p_curr_value / v_remained_months;
        v_row.numb02    :=  TRUNC(p_curr_value - v_row.numb01 * v_idx, 4);
        pipe ROW (v_row);
    END LOOP;

    RETURN;
END;


/*********************************************************************************************
    04/08/2008  d   Create 
/*********************************************************************************************/
PROCEDURE p_acquisition (   p_org_code          VARCHAR2,
                            p_fa_code           VARCHAR2, 
                            p_trn_type          VARCHAR2,
                            p_doc_date          DATE,
                            p_doc_code          VARCHAR2, 
                            p_supplier_code     VARCHAR2, 
                            p_price             NUMBER,
                            p_currency_code     VARCHAR2,
                            p_user_rec          VARCHAR2)
IS

    CURSOR C_EX_TRN     (       p_fa_code   VARCHAR2)
                        IS
                        SELECT  1
                        FROM    FA_TRN
                        WHERE   fa_code     =   p_fa_code
                        ;

    v_row_ft            FA_TRN%ROWTYPE;
    v_row_fa            FIXED_ASSET%ROWTYPE;

BEGIN

    -- check if there are other transactions on the code 
    FOR x IN C_EX_TRN   (p_fa_code)
    LOOP
        Pkg_Err.p_rae('Exista deja miscari pe acest Mijloc Fix !');
    END LOOP;

    -- get the fixed asset row 
    v_row_fa.fa_code    :=  p_fa_code;
    v_row_fa.org_code   :=  p_org_code;
    IF NOT Pkg_Get2.f_get_fixed_asset_2(v_row_fa) THEN
        Pkg_Err.p_rae('Codul de Mijloc Fix este incorect !');
    END IF;

    -- transaction details 
    v_row_ft.fa_code        :=  p_fa_code;
    v_row_ft.trn_type       :=  'ACHIZ';
    v_row_ft.seq_no         :=  10;
    v_row_ft.trn_date       :=  p_doc_date;
    v_row_ft.doc_code       :=  p_doc_code;
    v_row_ft.supplier_code  :=  p_supplier_code;
    v_row_ft.trn_sign       :=  +1;
    v_row_ft.trn_value      :=  p_price;
    v_row_ft.trn_currency   :=  p_currency_code;
    v_row_ft.weight_diff    :=  0;
    v_row_ft.resp_user      :=  p_user_rec;

    Pkg_Iud.p_fa_trn_iud('I',v_row_ft);

    -- put the fixed asset status in M = magazie 
    v_row_fa.status         :=  'M';
    v_row_fa.date_in        :=  p_doc_date;
    Pkg_Iud.p_fixed_asset_iud('U', v_row_fa);

    COMMIT;

    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM)); 
END;


/*********************************************************************************************
    04/08/2008  d   Create 
/*********************************************************************************************/
PROCEDURE p_transfer    (   p_org_code          VARCHAR2,
                            p_fa_code           VARCHAR2, 
                            p_trn_date          DATE, 
                            p_resp_user         VARCHAR2,
                            p_resp_cdc          VARCHAR2)
IS

    CURSOR C_GET_SEQ    (p_fa_code VARCHAR2)
                        IS
                        SELECT  MAX(seq_no)
                        FROM    FA_TRN
                        WHERE   fa_code     =   p_fa_code
                        ;

    v_row_ft            FA_TRN%ROWTYPE;
    v_row_fa            FIXED_ASSET%ROWTYPE;
    v_seq_no            PLS_INTEGER;

BEGIN

    -- get the fixed asset row 
    v_row_fa.fa_code    :=  p_fa_code;
    v_row_fa.org_code   :=  p_org_code;
    IF NOT Pkg_Get2.f_get_fixed_asset_2(v_row_fa) THEN
        Pkg_Err.p_rae('Codul de Mijloc Fix este incorect !');
    END IF;
    IF v_row_fa.status  NOT IN ('M','P') THEN
        Pkg_Err.p_rae('Mijlocul Fix nu este in starea corecta pt transfer: M(agazie) sau in P(roductie)');
    END IF;

    OPEN    C_GET_SEQ(p_fa_code);
    FETCH   C_GET_SEQ INTO v_seq_no;
    CLOSE   C_GET_SEQ;

    -- transaction details 
    v_row_ft.fa_code        :=  p_fa_code;
    v_row_ft.trn_type       :=  'TRN';
    v_row_ft.seq_no         :=  NVL(v_seq_no, 0) + 10;
    v_row_ft.trn_date       :=  p_trn_date;
    v_row_ft.trn_sign       :=  0;
    v_row_ft.trn_value      :=  0;
    v_row_ft.weight_diff    :=  0;
    v_row_ft.resp_user      :=  p_resp_user;
    v_row_ft.resp_cdc       :=  p_resp_cdc;


    Pkg_Iud.p_fa_trn_iud('I',v_row_ft);

    -- put the fixed asset status in M = magazie 
    v_row_fa.status         :=  'P';
    v_row_fa.resp_user      :=  p_resp_user;
    v_row_fa.resp_costcenter:=  p_resp_cdc;
    v_row_fa.date_start     :=  NVL(v_row_fa.date_start, p_trn_date);
    Pkg_Iud.p_fixed_asset_iud('U', v_row_fa);

    COMMIT;

    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM)); 
END;


/*********************************************************************************************
    05/08/2008  d   Create 
/*********************************************************************************************/
PROCEDURE p_fa_sheet    (   p_org_code      VARCHAR2, p_fa_code VARCHAR2)
IS
    CURSOR C_LINES      (p_org_code VARCHAR2, p_fa_code VARCHAR2)
                        IS
                        SELECT      t.*,
                                    tt.description  tt_description,
                                    tt.trn_iot      tt_trn_iot
                        FROM        FA_TRN          t
                        INNER JOIN  FA_TRN_TYPE     tt  ON  tt.trn_type    =   t.trn_type
                        WHERE       t.fa_code       =   p_fa_code
                        ORDER BY    t.seq_no
                        ;

    CURSOR C_DEPREC         (           p_curr_value    NUMBER, 
                                        p_start_date    DATE, 
                                        p_deprec_months NUMBER,
                                        p_deprec_type   VARCHAR2
                            )
                            IS
                            SELECT      *
                            FROM        TABLE(Pkg_Ac_Faio.f_sql_depreciation
                                                (   p_curr_value,
                                                    p_start_date,
                                                    SYSDATE,
                                                    p_deprec_months,
                                                    p_deprec_type)
                                                )
                            ;

    v_row_fa            FIXED_ASSET%ROWTYPE;
    v_found             BOOLEAN;
    v_row_org           ORGANIZATION%ROWTYPE;
    v_row_fac           FIXED_ASSET_CATEG%ROWTYPE;
    C_SEGMENT_CODE      VARCHAR2(100)       :=  'VW_REP_FA_SHEET';
    v_row_rep           VW_REP_FA_SHEET%ROWTYPE;
    it_rep              Pkg_Rtype.ta_vw_rep_fa_sheet;
    v_curr_value        NUMBER;
    v_initial_value     NUMBER;
    v_monthly_deprec    NUMBER;
    v_deprec_date       DATE;
    v_txt_acq_info      VARCHAR2(200);
    v_currency_code     VARCHAR2(30);

BEGIN
    DELETE FROM VW_REP_FA_SHEET;

    -- get the fixed asset row 
    v_row_fa.org_code       :=  p_org_code;
    v_row_fa.fa_code        :=  p_fa_code;
    v_found     :=  Pkg_Get2.f_get_fixed_asset_2(v_row_fa);
    IF NOT v_found THEN Pkg_Err.p_rae('Mijlocul fix inexistent: '||p_fa_code);END IF;

    -- get the fixed asset category row 
    v_row_fac.category_code :=  v_row_fa.category_code;
    v_found     :=  Pkg_Get2.f_get_fixed_asset_categ_2(v_row_fac);
    IF NOT v_found THEN Pkg_Err.p_rae('Categorie MF necunoscuta: '||v_row_fa.category_code);END IF;

    -- get the organization row 
    v_row_org.org_code      :=  p_org_code;
    v_found     :=  Pkg_Get2.f_get_organization_2(v_row_org);
    IF NOT v_found THEN Pkg_Err.p_rae('Organizatie necunoscuta: '||p_org_code);END IF;

    -- set the header informations 
    v_row_rep.rep_title         :=  'Fisa MIJLOCULUI FIX (cod 14-2-2/a)';
    v_row_rep.rep_info          :=  'Gestiune:  '||p_org_code||' '||v_row_org.org_name||Pkg_Glb.C_NL||
                                    'Cod MF:    '||p_fa_code;
    v_row_rep.segment_code      :=  C_SEGMENT_CODE;
    v_row_rep.inventory_code    :=  v_row_fa.inventory_code;
    v_row_rep.deprec_months     :=  v_row_fa.deprec_months;
    v_row_rep.txt_description   :=  NVL(v_row_fa.description,RPAD('_',100,'_'));
    v_row_rep.txt_auxiliar      :=  NVL('',RPAD('. ',100,'. '));
    v_row_rep.txt_group         :=  NVL('',RPAD('. ',50,'. '));
    v_row_rep.txt_category      :=  v_row_fa.category_code ||Pkg_Glb.C_NL||v_row_fac.description;
    v_row_rep.usage_date        :=  TO_CHAR(v_row_fa.date_start,'dd/mm/yyyy');
    v_row_rep.deprec_type       :=  v_row_fa.deprec_type;

    -- loop on the fixed asset transactions 
    FOR x IN C_LINES(p_org_code, p_fa_code)
    LOOP
        -- if the transaction is IN type=> store the initial value for FA 
        IF x.tt_trn_iot = 'I' THEN
            v_initial_value     :=  x.trn_value;
            v_txt_acq_info      :=  x.doc_code||' '||TO_CHAR(x.trn_date,'dd/mm/yyyy');
            v_currency_code     :=  x.trn_currency;
        END IF;
        -- add the transaction value to the current FA value 
        v_curr_value    :=  NVL(v_curr_value, 0) + x.trn_sign * x.trn_value;

        v_row_rep.d_txt_doc     :=  x.doc_code||' '||TO_CHAR(x.trn_date,'dd/mm/yyyy');
        v_row_rep.d_txt_tranz   :=  '('||x.tt_trn_iot||') '||x.tt_description;
        IF x.tt_trn_iot = 'T' THEN
            v_row_rep.d_txt_tranz   :=  v_row_rep.d_txt_tranz||' '||x.resp_user||' '||x.resp_cdc;
        END IF;

        IF x.trn_sign = 1 THEN 
            v_row_rep.d_debit   :=  TRUNC(x.trn_value,2);
            v_row_rep.d_credit  :=  0;
        ELSE 
            v_row_rep.d_credit  :=  TRUNC(x.trn_value,2);
            v_row_rep.d_debit   :=  0;
        END IF;
        v_row_rep.d_sold        :=  TRUNC(v_curr_value,2);

        it_rep(it_rep.COUNT + 1):=  v_row_rep;
    END LOOP;

    IF v_row_fa.date_start IS NOT NULL THEN
        -- depreciation 
        FOR x IN C_DEPREC(v_curr_value, v_row_fa.date_start, v_row_fa.deprec_months, v_row_fa.deprec_type)
        LOOP   
            v_deprec_date           :=  x.data01;
            v_monthly_deprec        :=  TRUNC(x.numb01,2);
        END LOOP;
    END IF;

    it_rep(1).deprec_date       :=  TO_CHAR(v_deprec_date, 'dd/mm/yyyy');
    it_rep(1).deprec_percent    :=  100 * TRUNC(1 - v_curr_value/v_initial_value,4);
    it_rep(1).inventory_value   :=  v_initial_value;
    it_rep(1).monthly_deprec    :=  v_monthly_deprec;
    it_rep(1).txt_acq_info      :=  v_txt_acq_info;
    it_rep(1).currency_code     :=  v_currency_code;

    Pkg_Iud.p_vw_rep_fa_sheet_miud('I',it_rep);

END;


/*********************************************************************************************
    05/08/2008  d   Create 
/*********************************************************************************************/
PROCEDURE p_depreciate      (   p_org_code  VARCHAR2, p_month VARCHAR2, p_year VARCHAR2)
----------------------------------------------------------------------------------------------
--  PURPOSE:    computes the depreciations for the active fixed assets 
--              and inserts them in FA_TRN table     
----------------------------------------------------------------------------------------------
IS
    CURSOR C_FA     (p_org_code VARCHAR2)
                    IS
                    SELECT      a.fa_code,
                                MAX(a.deprec_type)              deprec_type,
                                MAX(a.deprec_months)            deprec_months,
                                MAX(a.date_start)               date_start,
                                SUM(t.trn_sign * t.trn_value)   curr_value,
                                MAX(t.seq_no)                   max_seq_no
                    --------------------------------------------------------------
                    FROM        FIXED_ASSET     a
                    LEFT JOIN   FA_TRN          t   ON  t.fa_code   =   a.fa_code
                    --------------------------------------------------------------
                    WHERE       a.org_code      =   p_org_code
                        AND     a.status        =   'P'
                    GROUP BY    a.fa_code
                    ;

    CURSOR C_DEPREC         (           p_curr_value    NUMBER, 
                                        p_start_date    DATE, 
                                        p_deprec_months NUMBER,
                                        p_deprec_type   VARCHAR2
                            )
                            IS
                            SELECT      *
                            FROM        TABLE(Pkg_Ac_Faio.f_sql_depreciation
                                                (   p_curr_value,
                                                    p_start_date,
                                                    SYSDATE,
                                                    p_deprec_months,
                                                    p_deprec_type)
                                                )
                            ;

    it_trn          Pkg_Rtype.ta_fa_trn;
    v_row_crs       C_DEPREC%ROWTYPE;

BEGIN

    FOR x IN C_FA   (p_org_code)
    LOOP
        --- 
        OPEN    C_DEPREC(x.curr_value, x.date_start, x.deprec_months, x.deprec_type);
        FETCH   C_DEPREC INTO v_row_crs;
        CLOSE   C_DEPREC;
        ---
        it_trn(it_trn.COUNT+1).fa_code      :=  x.fa_code;
        it_trn(it_trn.COUNT  ).trn_type     :=  'AMORT';
        it_trn(it_trn.COUNT  ).seq_no       :=  NVL(x.max_seq_no,0)+10;
        it_trn(it_trn.COUNT  ).trn_date     :=  TO_DATE('01'||p_month||p_year, 'ddmmyyyy');
        it_trn(it_trn.COUNT  ).trn_sign     :=  -1;
        it_trn(it_trn.COUNT  ).trn_value    :=  v_row_crs.numb01;
      
    END LOOP;

    Pkg_Iud.p_fa_trn_miud('I', it_trn);

    COMMIT;

    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));         
END;

END;

/

/
