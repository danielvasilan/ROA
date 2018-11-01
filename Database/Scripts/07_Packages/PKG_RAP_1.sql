--------------------------------------------------------
--  DDL for Package Body PKG_RAP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_RAP" 
IS



/**************************************************************************************************
    DDL:    d   moved from Pkg_Ecl_Ang
/**************************************************************************************************/
FUNCTION f_reports_category RETURN typ_cmb
---------------------------------------------------------------------------------------------------
--  PURPOSE:    list of report categories
---------------------------------------------------------------------------------------------------
IS
    CURSOR C        IS
                    SELECT      *                     FROM        REPORTS_CATEGORY
                    ORDER BY    idriga
                    ;

    it              typ_cmb         :=  typ_cmb();
    v_idx           PLS_INTEGER     :=  0;

BEGIN
    FOR X IN C
    LOOP
        v_idx            := v_idx + 1;
        it.EXTEND;
        it(v_idx)        := tmp_cmb();
        it(v_idx).txt01  := X.idriga;
        it(v_idx).txt02  := X.categ_name;
    END LOOP;
    RETURN it;
END;

/**************************************************************************************************
    DDL:    d   moved from Pkg_Ecl_Ang
/**************************************************************************************************/
FUNCTION f_reports (p_idcateg NUMBER) RETURN typ_cmb
---------------------------------------------------------------------------------------------------
--  PURPOSE:    list of reports for a specific category
---------------------------------------------------------------------------------------------------
IS
    CURSOR C    (   p_id_categ  NUMBER)
                IS
                SELECT      *                 FROM        REPORTS
                WHERE       id_categ        =   p_idcateg
                ORDER BY    report_name;

       it       typ_cmb         :=  typ_cmb();
       v_idx    PLS_INTEGER     :=  0;

BEGIN
    FOR X IN C  (p_idcateg)
    LOOP
          v_idx            := v_idx + 1;
          it.EXTEND;
          it(v_idx)        := tmp_cmb();
          it(v_idx).txt01  := X.idriga;
          it(v_idx).txt02  := X.report_name;
          it(v_idx).txt03  := X.counter;
    END LOOP;
    RETURN it;
END;

/**************************************************************************************************
    DDL:    d   moved from Pkg_Ecl_Ang
/**************************************************************************************************/
FUNCTION f_reports_parameter(p_idReport NUMBER, p_type VARCHAR2) RETURN typ_frm
---------------------------------------------------------------------------------------------------
--  PURPOSE:    list of reports for a specific category
---------------------------------------------------------------------------------------------------
IS
    CURSOR C    (   p_idreport NUMBER, p_type VARCHAR2)
                    IS
                    SELECT      LABEL , strsql,ord ord_interface, ord ord_procedure, bloc, tippar, control_name
                    FROM        REPORTS_PARAMETER
                    WHERE       id_report       =   p_idReport
                        AND     p_type          =   'INTERFACE'
                    --------
                    UNION ALL
                    --------
                    SELECT      LABEL , strsql,ord ord_interface,ord_procedure, bloc, tippar, control_name
                    FROM        REPORTS_PARAMETER
                    WHERE       id_report       =   p_idReport
                            AND ord_procedure   >   0
                            AND  p_type         =   'PROCEDURE'
                    --------
                    ORDER  BY   ord_interface
                    ;

    it    typ_frm      :=typ_frm();
    v_idx  PLS_INTEGER  :=0;

BEGIN
    FOR X IN C(p_idreport, p_type) LOOP
        v_idx               := v_idx + 1;
        it.EXTEND;
        it(v_idx)           := tmp_frm();
        it(v_idx).txt01     := X.LABEL;
        it(v_idx).txt02     := X.strsql;
        it(v_idx).txt03     := X.control_name;

        it(v_idx).numb01    := X.ord_interface;
        it(v_idx).numb02    := X.bloc;
        it(v_idx).numb03    := X.tippar;
        it(v_idx).numb04    := X.ord_procedure;

    END LOOP;
    RETURN it;
END;

/**************************************************************************************************
    DDL:    d   moved from Pkg_Ecl_Ang
/**************************************************************************************************/
FUNCTION f_loadrepcond   (p_idrep INTEGER, p_ord INTEGER, p_relcond VARCHAR2) RETURN typ_cmb
IS

    CURSOR C_LINES(p_id_report INTEGER, p_ord INTEGER) IS
                SELECT  strsql
                FROM    REPORTS_PARAMETER
                WHERE       id_report   =   p_idrep
                        AND ord         =   p_ord
                ;

    CURSOR  C_REPLACE(p_relcond VARCHAR2) IS
                SELECT  ROWNUM ord, txt01
                FROM    TABLE(Pkg_Lib.f_sql_inlist(p_relcond,'$',-1))
                ;

    it             typ_cmb:=typ_cmb();
    v_idx          PLS_INTEGER:=0;
    v_sql          VARCHAR2(4000);
    vc             Pkg_Glb.ref_cursor;
    v1             VARCHAR2(100);
    v2             VARCHAR2(100);
    v3             VARCHAR2(100);
    selcols        DBMS_SQL.DESC_TAB;
    v_nrcol        INTEGER;
    v_cursor       INTEGER;

BEGIN

  -- citesc linia conditiei active
    OPEN    C_LINES(p_id_report => p_idrep, p_ord => p_ord);
    FETCH   C_LINES INTO v_sql;
    CLOSE   C_LINES;

    IF v_sql IS NOT NULL THEN
        --determin numarul de coloane din StrSql
        v_cursor := DBMS_SQL.OPEN_CURSOR;
        DBMS_SQL.PARSE(v_cursor, v_sql,1);
        DBMS_SQL.DESCRIBE_COLUMNS (v_cursor ,v_nrcol , selcols);

        -- inlocuiesc variabilele cu valori
        FOR X IN C_REPLACE(p_relcond)  LOOP
            v_sql := REPLACE (v_sql,'~'||X.ord,X.txt01);
        END LOOP;

        -- citesc eventuala linie a conditiei relative
        OPEN vc FOR v_sql;

        LOOP
            CASE v_nrcol
                WHEN 1 THEN   FETCH vc INTO v1;
                        v2 := NULL; v3 := NULL;
                WHEN 2 THEN   FETCH vc INTO v1, v2;
                        v3 := NULL;
                WHEN 3 THEN   FETCH vc INTO v1, v2, v3;
            END CASE;

            EXIT WHEN vc%NOTFOUND;

            v_idx := v_idx + 1;
            it.EXTEND;
            it(v_idx)           := tmp_cmb();
            it(v_idx).txt01  := v1;
            it(v_idx).txt02  := v2;
            it(v_idx).txt03  := v3;
        END LOOP;

        CLOSE vc;
        DBMS_SQL.CLOSE_CURSOR(v_cursor);

    END IF;
    RETURN it;

    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    30/03/2008  z Create procedure
            25/11/2008  d f_sql_inlist on p_item_code had no p_selector parameter
/*********************************************************************************/
PROCEDURE p_prep_receipt(
                            p_item_code     VARCHAR2,
                            p_org_code      VARCHAR2,
                            p_receipt_type  VARCHAR2,
                            p_start_date    DATE,
                            p_end_date      DATE,
                            p_suppl_code    VARCHAR2,
                            p_only_dif      VARCHAR2
      )
----------------------------------------------------------------------------------
--  PURPOSE:
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR C_LINES  (   p_selector      VARCHAR2,
                        p_item_code     VARCHAR2,
                        p_org_code      VARCHAR2,
                        p_receipt_type  VARCHAR2,
                        p_start_date    DATE,
                        p_end_date      DATE,
                        p_suppl_code    VARCHAR2,
                        p_only_dif      VARCHAR2)
                    IS
                    SELECT
                            h.receipt_code, h.receipt_date,  h.receipt_type,
                            h.suppl_code, h.doc_number, h.doc_date, h.incoterm,
                            h.currency_code, h.country_from, h.status ,
                            ----
                            s.description   description_receipt,s.extern,s.service,
                            ----
                            t.date_legal,
                            ---
                            c.description   description_colour,
                            ---
                            v.description   description_custom, v.supl_um,
                            --
                            d.uom_receipt, d.qty_doc, d.qty_count, d.puom, d.qty_doc_puom,
                            d.qty_count_puom, d.org_code, d.item_code, d.colour_code,
                            d.size_code, d.oper_code_item, d.season_code, d.whs_code,
                            d.order_code, d.custom_code, d.origin_code, d.weight_net,
                            d.weight_brut, d.price_doc, d.price_doc_puom, d.note, d.group_code,
                            --
                            i.description   description_item ,
                            --
                            r.exchange_rate,
                            --
                            (SELECT SUM(i.qty)  FROM FIFO_MATERIAL i WHERE i.ref_receipt = d.idriga ) qty_fifo_out
                    ------------------------------------------------------------------------------
                    FROM        RECEIPT_HEADER      h
                    INNER JOIN  SETUP_RECEIPT       s   ON  s.receipt_type  =   h.receipt_type
                    --
                    LEFT JOIN   WHS_TRN             t   ON  t.ref_receipt    =   h.idriga
                                                        AND t.flag_storno   =   'N'
                    --
                    INNER JOIN  RECEIPT_DETAIL      d   ON  d.ref_receipt   =   h.idriga
                    --
                    LEFT  JOIN  COLOUR              c   ON  c.org_code      =   d.org_code
                                                        AND c.colour_code   =   d.colour_code
                    --
                    LEFT  JOIN  CUSTOM              v   ON  v.custom_code   =   d.custom_code
                    --
                    INNER JOIN  ITEM                i   ON  i.org_code      =   d.org_code
                                                        AND i.item_code     =   d.item_code
                    --
                    LEFT JOIN   CURRENCY_RATE       r   ON  r.calendar_day  =   h.doc_date
                                                        AND r.currency_from =   h.currency_code
                                                        AND r.currency_to   =   'RON'
                    ------------------------------------------------------------------------------
                    WHERE       p_selector          =           'A'
                            AND h.status            <>          'X'
                            AND     h.suppl_code        LIKE        NVL(p_suppl_code,'%')
                            AND     (
                                        p_receipt_type  IS NULL
                                    OR
                                        h.receipt_type  IN          (SELECT txt01 FROM TABLE( Pkg_Lib.f_sql_inlist(p_receipt_type) ) )
                                    )
                            -- modified by Daniel V. -> receipt date is confusing, use transaction.date_legal instead !!
                            -- AND h.receipt_date          BETWEEN     NVL(p_start_date,   Pkg_Glb.C_PAST   )
                            --                                    AND NVL(p_end_date  ,   Pkg_Glb.C_FUTURE )
                            AND t.date_legal            BETWEEN     NVL(p_start_date,   Pkg_Glb.C_PAST   )
                                                                AND NVL(p_end_date  ,   Pkg_Glb.C_FUTURE )
                            AND DECODE(p_only_dif,'N',1,ABS(d.qty_doc - d.qty_count))   > 0
                    ---
                    UNION ALL
                    --
                    SELECT
                        h.receipt_code, h.receipt_date,  h.receipt_type,
                        h.suppl_code, h.doc_number, h.doc_date, h.incoterm,
                        h.currency_code, h.country_from, h.status ,
                        ----
                        s.description   description_receipt,s.extern,s.service,
                        ----
                        t.date_legal,
                        ---
                        c.description   description_colour,
                        ---
                        v.description   description_custom, v.supl_um,
                        --
                        d.uom_receipt, d.qty_doc, d.qty_count, d.puom, d.qty_doc_puom,
                        d.qty_count_puom, d.org_code, d.item_code, d.colour_code,
                        d.size_code, d.oper_code_item, d.season_code, d.whs_code,
                        d.order_code, d.custom_code, d.origin_code, d.weight_net,
                        d.weight_brut, d.price_doc, d.price_doc_puom, d.note, d.group_code,
                        --
                        i.description   description_item,
                        --
                        r.exchange_rate,
                        --
                       (SELECT SUM(i.qty)  FROM FIFO_MATERIAL i WHERE i.ref_receipt = d.idriga ) qty_fifo_out
                FROM        RECEIPT_HEADER      h
                INNER JOIN  SETUP_RECEIPT       s
                                ON  s.receipt_type  =   h.receipt_type
                LEFT JOIN   WHS_TRN             t
                                ON  t.ref_receipt    =   h.idriga
                                AND t.flag_storno   =   'N'
                INNER JOIN  RECEIPT_DETAIL      d
                                ON  d.ref_receipt   =   h.idriga
                LEFT JOIN  COLOUR              c
                                ON  c.org_code      =   d.org_code
                                AND c.colour_code   =   d.colour_code
                LEFT  JOIN  CUSTOM              v
                                ON  v.custom_code   =   d.custom_code
                INNER JOIN  ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT JOIN   CURRENCY_RATE       r
                                ON  r.calendar_day  =   h.doc_date
                                AND r.currency_from =   h.currency_code
                                AND r.currency_to   =   'RON'
                WHERE       p_selector          =       'B'
                        AND h.status            <>      'X'
                        AND d.item_code         IN      (SELECT txt01 FROM TABLE( Pkg_Lib.f_sql_inlist(p_item_code,',;') ) )
                        AND d.org_code          =       p_org_code
                        AND h.suppl_code        LIKE    NVL(p_suppl_code,'%')
                        AND (   p_receipt_type  IS NULL
                             OR
                                h.receipt_type      IN      (SELECT txt01 FROM TABLE( Pkg_Lib.f_sql_inlist(p_receipt_type,',;') ) )
                            )
                            -- modified by Daniel V. -> receipt date is confusing, use transaction.date_legal instead !!
                            -- AND h.receipt_date          BETWEEN     NVL(p_start_date,   Pkg_Glb.C_PAST   )
                            --                                    AND NVL(p_end_date  ,   Pkg_Glb.C_FUTURE )
                            AND t.date_legal            BETWEEN     NVL(p_start_date,   Pkg_Glb.C_PAST   )
                                                                AND NVL(p_end_date  ,   Pkg_Glb.C_FUTURE )
                        AND DECODE(p_only_dif,'N',1,ABS(d.qty_doc - d.qty_count))   > 0
                --------------
                ORDER BY receipt_code,item_code
                ;


    v_selector          VARCHAR2(1) ;
    v_only_dif          VARCHAR2(1) ;
    v_row               VW_PREP_RECEIPT%ROWTYPE;

    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_PREP_RECEIPT';


BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_item_code IS NOT NULL AND p_org_code IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Daca ati precizat codul articlului '
                                    || 'trebuie sa precizati si clientul careia '
                                    ||'apartine articolul !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    ---
    IF p_item_code  IS NULL THEN
        v_selector  :=      'A';
    ELSE
        v_selector  :=      'B';
    END IF;
    ---
    v_only_dif      := NVL(p_only_dif,'N');
    ---
    DELETE FROM VW_PREP_RECEIPT;

    FOR x IN C_LINES (p_selector      =>    v_selector,
                      p_item_code     =>    p_item_code,
                      p_org_code      =>    p_org_code,
                      p_receipt_type  =>    p_receipt_type,
                      p_start_date    =>    p_start_date,
                      p_end_date      =>    p_end_date,
                      p_suppl_code    =>    p_suppl_code,
                      p_only_dif      =>    v_only_dif
                      )
    LOOP

        v_row.segment_code              :=  C_SEGMENT_CODE;
        v_row.seq_no                    :=  C_LINES%rowcount;

        v_row.receipt_code              :=  x.receipt_code;
        v_row.receipt_type              :=  x.receipt_type;
        v_row.suppl_code                :=  x.suppl_code;
        v_row.doc_number                :=  x.doc_number;
        v_row.incoterm                  :=  x.incoterm;
        v_row.currency_code             :=  x.currency_code;
        v_row.country_from              :=  x.country_from;
        v_row.status                    :=  x.status;
        v_row.description_receipt       :=  x.description_receipt;
        v_row.uom_receipt               :=  x.uom_receipt;
        v_row.puom                      :=  x.puom;
        v_row.org_code                  :=  x.org_code;
        v_row.item_code                 :=  x.item_code;
        v_row.colour_code               :=  x.colour_code ;
        v_row.size_code                 :=  x.size_code;
        v_row.oper_code_item            :=  x.oper_code_item;
        v_row.season_code               :=  x.season_code;
        v_row.custom_code               :=  x.custom_code;
        v_row.origin_code               :=  x.origin_code;
        v_row.group_code                :=  x.group_code;
        v_row.description_item          :=  x.description_item;
        v_row.description_colour        :=  x.description_colour;
        v_row.description_custom        :=  x.description_custom;
        v_row.supl_um                   :=  x.supl_um;
        v_row.extern                    :=  x.extern;
        v_row.service                   :=  x.service;
        v_row.qty_doc                   :=  x.qty_doc;
        v_row.qty_count                 :=  x.qty_count;
        v_row.qty_doc_puom              :=  x.qty_doc_puom;
        v_row.qty_count_puom            :=  x.qty_count_puom;
        v_row.price_doc                 :=  x.price_doc;
        v_row.price_doc_puom            :=  x.price_doc_puom;
        v_row.weight_net                :=  x.weight_net;
        v_row.weight_brut               :=  x.weight_brut;
        v_row.exchange_rate             :=  NVL(x.exchange_rate,0);
        v_row.receipt_date              :=  x.receipt_date;
        v_row.doc_date                  :=  x.doc_date;
        v_row.date_legal                :=  x.date_legal;
        v_row.year_month_doc            :=  TO_CHAR(v_row.doc_date,'YYYYMM');
        v_row.year_month_receipt        :=  TO_CHAR(v_row.date_legal,'YYYYMM');
        v_row.qty_fifo                  :=  v_row.qty_doc_puom - NVL(x.qty_fifo_out,0);

        INSERT INTO VW_PREP_RECEIPT VALUES v_row;
    END LOOP;
    --
    IF v_row.seq_no IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu exista date '
                                    ||'pentru parametrii de selectie '
                                    ||'precizati !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;




/*********************************************************************************
DDL: 30/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_rep_intrastat(
                            p_year_month      VARCHAR2
                         )
----------------------------------------------------------------------------------
--  PURPOSE:
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    CURSOR  C_LINES     (   p_year_month VARCHAR2)
                        IS
                        SELECT      t.*
                        -------------------------------------------------------------
                        FROM        VW_PREP_RECEIPT t
                        INNER JOIN  COUNTRY         c
                                        ON  t.country_from  =   c.country_code
                        -------------------------------------------------------------
                        WHERE       c.intrastat             =   'Y'
                                AND t.service               =   'N'
                                AND t.year_month_receipt    =   p_year_month
                        ;

    CURSOR C_INTRASTAT  (p_year_month VARCHAR2)
                        IS
                        SELECT      t.org_code                                      ,
                                    t.receipt_type                                  ,
                                    t.custom_code                                   ,
                                    t.country_from                                  ,
                                    t.origin_code                                   ,
                                    MAX(t.DESCRIPTION_RECEIPT)                      description_receipt,
                                    MAX(t.description_custom)                       description_custom,
                                    MAX(t.supl_um)                                  supl_um,
                                    SUM(t.qty_doc)                                  qty_doc,
                                    SUM(t.qty_doc * t.price_doc * t.exchange_rate)  value_doc,                                     SUM(t.qty_doc * t.price_doc)                    value_eur,                                     SUM(t.weight_net)                               weight_net,
                                    SUM(NVL(t.weight_brut,0))                       weight_brut
                        ----------------------------------------------------------------------------------
                        FROM        VW_PREP_RECEIPT         t
                        INNER JOIN  COUNTRY                 c
                                        ON  t.country_from  =   c.country_code
                        ----------------------------------------------------------------------------------
                        WHERE       c.intrastat             =   'Y'
                                AND t.service               =   'N'
                                AND t.year_month_receipt    =   p_year_month
                        ----------------------------------------------------------------------------------
                        GROUP BY    t.org_code, t.receipt_type, t.custom_code, t.country_from, t.origin_code
                        ORDER BY    t.org_code, t.receipt_type, t.custom_code, t.country_from, t.origin_code
                        ;

    v_start_date        DATE;
    v_end_date          DATE;
    v_row               VW_REP_INTRASTAT%ROWTYPE;
    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_REP_INTRASTAT';

BEGIN
    Pkg_Err.p_reset_error_message();
    ---
    v_start_date    :=  ADD_MONTHS(TO_DATE(p_year_month||'01','YYYYMMDD'),-3);
    --
    Pkg_Rap.p_prep_receipt(
                            p_item_code     =>  NULL,
                            p_org_code      =>  NULL,
                            p_receipt_type  =>  NULL,
                            p_start_date    =>  v_start_date,
                            p_end_date      =>  Pkg_Glb.C_FUTURE ,
                            p_suppl_code    =>  NULL,
                            p_only_dif      =>  NULL
                          );
    ---
    FOR x IN C_LINES(p_year_month) LOOP
        IF NVL(x.exchange_rate,0) = 0 THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => TO_CHAR(x.doc_date,'YYYY/MM/DD'),
                  p_err_header        => 'Nu exista schimb de curs valutar '
                                        ||'introdus pentru data de '||TO_CHAR(x.doc_date,'YYYY/MM/DD')
                                        ||'  !!!',
                  p_err_detail        => NULL,
                  p_flag_immediate    => 'N'
             );
        END IF;
    END LOOP;
    Pkg_Err.p_raise_error_message();
    ---
    DELETE FROM VW_REP_INTRASTAT;
    --
    FOR x IN C_INTRASTAT(p_year_month ) LOOP

        v_row.segment_code          :=  C_SEGMENT_CODE;
        v_row.year_month            :=  p_year_month;
        v_row.org_code              :=  x.org_code;
        v_row.receipt_type          :=  x.receipt_type;
        v_row.receipt_type_descr    :=  x.description_receipt;
        v_row.custom_code           :=  x.custom_code;
        v_row.description_custom    :=  x.description_custom;
        v_row.country_from          :=  x.country_from;
        v_row.origin_code           :=  x.origin_code;
        v_row.supl_um               :=  x.supl_um;
        v_row.seq_no                :=  C_INTRASTAT%rowcount;
        v_row.qty_doc               :=  x.qty_doc;
        v_row.value_doc             :=  ROUND(x.value_doc,2);
        v_row.value_eur             :=  ROUND(x.value_eur,2);
        v_row.weight_net            :=  ROUND(x.weight_net,2);
        v_row.weight_brut           :=  ROUND(x.weight_brut,2);

        INSERT INTO VW_REP_INTRASTAT VALUES v_row;
    END LOOP;

    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/***********************************************************************************************
    DDL:    12/04/2008  d   Create date
/***********************************************************************************************/
PROCEDURE p_rep_item_transactions   (   p_org_code          VARCHAR2,
                                        p_item_code         VARCHAR2,
                                        p_oper_code_item    VARCHAR2,
                                        p_size_code         VARCHAR2,
                                        p_colour_code       VARCHAR2,
                                        p_trn_type          VARCHAR2,
                                        p_whs_code          VARCHAR2,
                                        p_season_code       VARCHAR2,
                                        p_order_code        VARCHAR2,
                                        p_group_code        VARCHAR2,
                                        p_start_date        DATE    ,
                                        p_end_date          DATE
                                    )

-------------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------------
IS

    PRAGMA AUTONOMOUS_TRANSACTION;



    CURSOR C_TRN        (               p_org_code          VARCHAR2,
                                        p_item_code         VARCHAR2,
                                        p_oper_code_item    VARCHAR2,
                                        p_size_code         VARCHAR2,
                                        p_colour_code       VARCHAR2,
                                        p_trn_type          VARCHAR2,
                                        p_whs_code          VARCHAR2,
                                        p_season_code       VARCHAR2,
                                        p_order_code        VARCHAR2,
                                        p_group_code        VARCHAR2,
                                        p_start_date        DATE    ,
                                        p_end_date          DATE
                        )
                        IS
                        SELECT      t.trn_year, t.trn_code, t.trn_date, t.trn_type,
                                    t.flag_storno,t.partner_code, t.doc_code,t.doc_date,
                                    t.date_legal,
                                    ---
                                    d.org_code, d.item_code, d.oper_code_item,
                                    d.trn_sign, d.qty, d.whs_code, d.colour_code,d.size_code,
                                    d.group_code, d.order_code,d.season_code,
                                    d.reason_code,d.puom,
                                    --
                                    i.description   i_description,
                                    --
                                    r.description   r_description, r.business_flow,
                                    --
                                    c.description   c_description
                        ----------------------------------------------------------------------------
                        FROM        WHS_TRN_DETAIL  d
                        INNER JOIN  WHS_TRN         t
                                                ON  t.idriga    =   d.ref_trn
                        INNER JOIN  ITEM            i
                                                ON  i.org_code  =   d.org_code
                                                AND i.item_code =   d.item_code
                        INNER JOIN  WHS_TRN_REASON  r
                                                ON  r.reason_code   =   d.reason_code
                        LEFT JOIN   COLOUR          c
                                                ON  c.org_code       =      d.org_code
                                                AND c.colour_code    =      d.colour_code
                        ----------------------------------------------------------------------------
                        WHERE       d.org_code      =       p_org_code
                            AND     d.item_code     LIKE    p_item_code||'%'
                            AND     t.date_legal    BETWEEN NVL(p_start_date, Pkg_Glb.C_PAST)
                                                            AND
                                                            NVL(p_end_date  , Pkg_Glb.C_FUTURE )
                            AND     t.trn_type      LIKE   p_trn_type||'%'
                            AND     d.whs_code      LIKE   p_whs_code||'%'
                            AND     d.season_code   LIKE   p_season_code||'%'
                            -------
                            AND     NVL(d.oper_code_item,Pkg_Glb.C_RN)
                                                    LIKE   NVL(p_oper_code_item,'%')
                            AND     NVL(d.size_code     ,Pkg_Glb.C_RN)
                                                    LIKE   NVL(p_size_code,'%')
                            AND     NVL(d.colour_code   ,Pkg_Glb.C_RN)
                                                    LIKE   NVL(p_colour_code,'%')
                            AND     NVL(d.order_code    ,Pkg_Glb.C_RN)
                                                    LIKE   NVL(p_order_code,'%')
                            AND     NVL(d.group_code    ,Pkg_Glb.C_RN)
                                                    LIKE   NVL(p_group_code,'%')
                        ----------------------------------------------------------------------------
                        ORDER BY    t.date_legal DESC , d.idriga DESC
                        ;

    it_qty_prog         Pkg_Glb.typ_number_varchar;
    v_qty_prog          NUMBER;
    v_stock             NUMBER;
    v_row               VW_REP_ITEM_TRANSACTION%ROWTYPE;
    v_index             VARCHAR2(1000);
    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_REP_ITEM_TRANSACTION';

BEGIN

    DELETE FROM VW_REP_ITEM_TRANSACTION;

    v_stock :=  0;

    FOR x IN C_TRN      (
                                p_org_code          ,
                                p_item_code         ,
                                p_oper_code_item    ,
                                p_size_code         ,
                                p_colour_code       ,
                                p_trn_type          ,
                                p_whs_code          ,
                                p_season_code       ,
                                p_order_code        ,
                                p_group_code        ,
                                p_start_date        ,
                                p_end_date
                        )
    LOOP
        v_index := Pkg_Mov.f_get_idx_item_stoc
                        (   p_whs_code      =>  x.whs_code,
                            p_season_code   =>  x.season_code,
                            p_size_code     =>  x.size_code,
                            p_colour_code   =>  x.colour_code,
                            p_oper_code     =>  x.oper_code_item,
                            p_group_code    =>  x.group_code,
                            p_order_code    =>  x.order_code
                        );

        v_qty_prog              :=  Pkg_Lib.f_table_value(it_qty_prog,v_index,0) + ( x.trn_sign * x.qty);
        it_qty_prog(v_index)    :=  v_qty_prog;

        v_row.seq_no            :=  C_TRN%rowcount;
        v_row.trn_year          :=  x.trn_year;
        v_row.trn_code          :=  x.trn_code;
        v_row.trn_date          :=  x.trn_date;
        v_row.trn_type          :=  x.trn_type;
        v_row.flag_storno       :=  x.flag_storno;
        v_row.partner_code      :=  x.partner_code;
        v_row.doc_code          :=  x.doc_code;
        v_row.doc_date          :=  x.doc_date;
        v_row.org_code          :=  x.org_code;
        v_row.doc_date          :=  x.doc_date;
        v_row.season_code       :=  x.season_code;
        v_row.item_code         :=  x.item_code;
        v_row.oper_code_item    :=  x.oper_code_item;
        v_row.description       :=  x.i_description;
        v_row.whs_code          :=  x.whs_code;
        v_row.colour_code       :=  x.colour_code;
        v_row.colour_description:=  x.c_description;
        v_row.size_code         :=  x.size_code;
        v_row.group_code        :=  x.group_code;
        v_row.order_code        :=  x.order_code;
        v_row.reason_code       :=  x.reason_code;
        v_row.reason_description:=  x.r_description;
        v_row.puom              :=  x.puom;
        v_row.qty               :=  x.trn_sign * x.qty;
        v_row.qty_prog          :=  v_qty_prog;
        v_row.date_legal        :=  x.date_legal;
        v_row.business_flow     :=  x.business_flow;
        v_row.segment_code      :=  C_SEGMENT_CODE;

        INSERT INTO VW_REP_ITEM_TRANSACTION VALUES v_row;

        v_stock                 :=  v_stock + v_row.qty ;
    END LOOP;


        v_row.seq_no            :=  0;
        v_row.trn_year          :=  '=====================';
        v_row.trn_code          :=  '=====================';
        v_row.trn_date          :=  TRUNC(SYSDATE);
        v_row.trn_type          :=  '=====================';
        v_row.flag_storno       :=  '=====================';
        v_row.partner_code      :=  '=====================';
        v_row.doc_code          :=  '=====================';
        v_row.doc_date          :=  NULL;
        v_row.org_code          :=  '=====================';
        v_row.season_code       :=  '=====================';
        v_row.item_code         :=  '=====================';
        v_row.oper_code_item    :=  '=====================';
        v_row.description       :=  '=====================';
        v_row.whs_code          :=  '=====================';
        v_row.colour_code       :=  '=====================';
        v_row.colour_description:=  '=====================';
        v_row.size_code         :=  '=====================';
        v_row.group_code        :=  '=====================';
        v_row.order_code        :=  '=====================';
        v_row.reason_code       :=  '=====================';
        v_row.reason_description:=  '=====================';
        v_row.qty               :=  v_stock;
        v_row.qty_prog          :=  NULL;
        v_row.date_legal        :=  TRUNC(SYSDATE);
        v_row.segment_code      :=  C_SEGMENT_CODE;

        INSERT INTO VW_REP_ITEM_TRANSACTION VALUES v_row;





    COMMIT;
    EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 25/05/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_rep_receipt_difference(p_difference NUMBER)

----------------------------------------------------------------------------------
--  PURPOSE:
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR C_LINES (p_difference NUMBER) IS
        SELECT  d.org_code,d.item_code,d.oper_code_item,
                d.colour_code,d.size_code,
                SUM(d.qty_count - d.qty_doc) qty,
                MAX(i.description)  i_description,
                MAX(c.description)  c_description,
                SUM(GREATEST(d.qty_doc_puom   - d.qty_count_puom,0)) qty_doc,
                SUM(GREATEST(d.qty_count_puom - d.qty_doc_puom  ,0)) qty_count,
                SUM(DECODE(LEAST(d.qty_doc_puom   - d.qty_count_puom,0),0,1,0)) qty_doc_count,
                SUM(DECODE(LEAST(d.qty_count_puom - d.qty_doc_puom  ,0),0,1,0)) qty_count_count,
                MAX(d.puom) puom
        FROM        RECEIPT_DETAIL  d
        INNER JOIN  ITEM            i
                        ON  i.org_code  =   d.org_code
                        AND i.item_code =   d.item_code
        LEFT JOIN   COLOUR          c
                        ON  c.org_code      =   d.org_code
                        AND c.colour_code   =   d.colour_code
        WHERE    d.qty_count_puom - d.qty_doc_puom    <> 0
        GROUP BY d.org_code,d.item_code,d.oper_code_item,
                 d.colour_code,d.size_code
        HAVING  ABS(SUM(d.qty_count_puom - d.qty_doc_puom)) > p_difference
        ORDER BY d.org_code,d.item_code,d.colour_code,d.size_code
        ;

    v_row               VW_REP_RECEIPT_DIFFERENCE%ROWTYPE;

    v_difference        NUMBER  :=  NVL(p_difference,0);
    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_REP_RECEIPT_DIFFERENCE';



BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    v_row.segment_code  := C_SEGMENT_CODE ;

    DELETE FROM  VW_REP_RECEIPT_DIFFERENCE;

    FOR x IN  C_LINES(v_difference) LOOP

        v_row.seq_no                :=  C_LINES%rowcount;

        v_row.org_code              :=  x.org_code;
        v_row.item_code             :=  x.item_code;
        v_row.oper_code_item        :=  x.oper_code_item;
        v_row.colour_code           :=  x.colour_code;
        v_row.size_code             :=  x.size_code;
        v_row.description_item      :=  x.i_description;
        v_row.description_colour    :=  x.c_description;
        v_row.puom                  :=  x.puom;
        v_row.qty                   :=  x.qty;
        v_row.qty_doc               :=  x.qty_doc;
        v_row.qty_count             :=  x.qty_count;
        v_row.qty_doc_count         :=  x.qty_doc_count;
        v_row.qty_count_count       :=  x.qty_count_count;


        INSERT INTO  VW_REP_RECEIPT_DIFFERENCE
        VALUES  v_row;

    END LOOP;


    IF v_row.seq_no IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu exista date '
                                    ||'pentru parametrii de selectie '
                                    ||'precizati !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 29/05/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_rep_whs_stoc    (
                                p_org_code      VARCHAR2    ,
                                p_whs_code      VARCHAR2    ,
                                p_season_code   VARCHAR2    ,
                                p_family        VARCHAR2    ,
                                p_ref_date      DATE        ,
                                p_item_code     VARCHAR2    ,
                                p_selector      VARCHAR2
                        )

----------------------------------------------------------------------------------
--  PURPOSE:
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR  C_LINES (p_family VARCHAR2)
            IS
            SELECT      z.org_code, z.item_code, z.oper_code_item, z.colour_code,
                        z.size_code, z.whs_code, z.season_code, z.order_code,
                        z.group_code, z.puom, z.qty, z.ref_date,
                        --
                        i.description   i_description, i.mat_type,
                        c.description   c_description
            -----------------------------------------------------------------------
            FROM        VW_STOC_ONLINE  z
            INNER JOIN  ITEM            i   ON  i.org_code      =   z.org_code
                                            AND i.item_code     =   z.item_code
            LEFT JOIN   COLOUR          c   ON  c.org_code      =   z.org_code
                                            AND c.colour_code   =   z.colour_code
            -----------------------------------------------------------------------
            WHERE       i.mat_type      LIKE    NVL(p_family    ,'%')
            -----------------------------------------------------------------------
            ORDER BY order_code,item_code,size_code,colour_code
            ;

    v_row               VW_REP_WHS_STOC%ROWTYPE;

    TYPE   type_it      IS TABLE OF VW_REP_WHS_STOC%ROWTYPE INDEX BY Pkg_Glb.type_index;
    it                  type_it;
    v_idx               Pkg_Glb.type_index;

    v_ref_date          DATE                :=  NVL(p_ref_date, TRUNC(SYSDATE));
    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_REP_WHS_STOC';



BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF v_ref_date   =  TRUNC(SYSDATE) THEN
         Pkg_Mov.P_Stoc_Online  (   p_org_code      =>  p_org_code      ,
                                    p_whs_code      =>  p_whs_code      ,
                                    p_item_code     =>  p_item_code     ,
                                    p_season_code   =>  p_season_code
                                );
    ELSE
         Pkg_Mov.P_Stoc_past    (   p_org_code      =>  p_org_code      ,
                                    p_whs_code      =>  p_whs_code      ,
                                    p_item_code     =>  p_item_code     ,
                                    p_season_code   =>  p_season_code   ,
                                    p_ref_date      =>  v_ref_date
                                );
    END IF;


    DELETE FROM  VW_REP_WHS_STOC;

    v_row.segment_code  := C_SEGMENT_CODE ;
    FOR x IN  C_LINES   (p_family)
    LOOP

        v_row.seq_no                :=  C_LINES%rowcount;
        v_row.org_code              :=  x.org_code;
        v_row.item_code             :=  x.item_code;
        v_row.oper_code_item        :=  x.oper_code_item;
        v_row.colour_code           :=  x.colour_code;
        v_row.size_code             :=  x.size_code;
        v_row.whs_code              :=  x.whs_code;
        v_row.season_code           :=  x.season_code;
        v_row.order_code            :=  x.order_code;
        v_row.group_code            :=  x.group_code;
        v_row.puom                  :=  x.puom;
        v_row.i_description         :=  x.i_description;
        v_row.c_description         :=  x.c_description;
        v_row.mat_type              :=  x.mat_type;
        v_row.qty                   :=  x.qty;
        v_row.ref_date              :=  x.ref_date;


        CASE NVL(p_selector,'TOT')
            WHEN    'TOT'           THEN
                v_idx   :=  C_LINES%rowcount ;
                it(v_idx)       :=      v_row;
            WHEN    'BOLA_DETALIU'  THEN
                IF x.order_code IS NOT NULL THEN
                    v_idx       :=  C_LINES%rowcount ;
                    it(v_idx)   :=      v_row;
                END IF;
            WHEN    'BOLA_GRUPAT'   THEN
                IF x.order_code IS NOT NULL THEN

                    v_idx   :=  Pkg_Lib.f_str_idx(
                                    p_par1  =>  x.org_code,
                                    p_par2  =>  x.order_code,
                                    p_par3  =>  x.oper_code_item,
                                    p_par4  =>  x.colour_code,
                                    p_par5  =>  x.whs_code
                                 );

                    v_row.size_code :=  NULL;
                    --
                    IF it.EXISTS(v_idx) THEN
                        it(v_idx).qty   :=      it(v_idx).qty + v_row.qty;
                        it(v_idx).note  :=      it(v_idx).note
                                                ||x.size_code
                                                ||'->'
                                                ||x.qty
                                                ||'; ';
                    ELSE
                        it(v_idx)       :=      v_row;
                        it(v_idx).note  :=      x.size_code
                                                ||'->'
                                                ||x.qty
                                                ||'; ';
                    END IF;

                END IF;
            WHEN    'MAT_NEALOCAT'  THEN
                IF      x.order_code    IS NULL
                    AND x.group_code    IS NULL
                    AND x.qty           >   0
                THEN
                    v_idx       :=  C_LINES%rowcount ;
                    it(v_idx)   :=      v_row;
                END IF;

        END CASE;
    END LOOP;
    --
    v_idx   :=  it.FIRST;
    WHILE v_idx IS NOT NULL LOOP
        INSERT INTO  VW_REP_WHS_STOC
        VALUES  it(v_idx);
        v_idx   :=  it.NEXT(v_idx);
    END LOOP;
    --
    IF v_row.seq_no IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu exista date '
                                    ||'pentru parametrii de selectie '
                                    ||'precizati !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 29/05/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_rep_fifo_exceding(p_ref_shipment INTEGER)

----------------------------------------------------------------------------------
--  PURPOSE:
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR C_LINES (p_ref_shipment INTEGER) IS
        SELECT          f.*,
                        i.description   i_description,
                        c.description   c_description
        FROM            FIFO_EXCEDING       f
        INNER   JOIN    ITEM                i
                            ON  i.org_code      =   f.org_code
                            AND i.item_code     =   f.item_code
        LEFT    JOIN    COLOUR              c
                            ON  c.org_code      =   f.org_code
                            AND c.colour_code   =   f.colour_code
        WHERE           f.ref_shipment  =   p_ref_shipment
        ;

    v_row               VW_REP_FIFO_EXCEDING%ROWTYPE;

    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_REP_FIFO_EXCEDING';



BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --

    DELETE FROM  VW_REP_FIFO_EXCEDING;

    v_row.segment_code  := C_SEGMENT_CODE ;
    FOR x IN  C_LINES(p_ref_shipment) LOOP

        v_row.seq_no                :=  C_LINES%rowcount;
        v_row.org_code              :=  x.org_code;
        v_row.item_code             :=  x.item_code;
        v_row.oper_code_item        :=  x.oper_code_item;
        v_row.colour_code           :=  x.colour_code;
        v_row.size_code             :=  x.size_code;
        v_row.season_code           :=  x.season_code;
        v_row.puom                  :=  x.puom;
        v_row.i_description         :=  x.i_description;
        v_row.c_description         :=  x.c_description;
        v_row.qty                   :=  x.qty;
        v_row.ship_subcat      :=  x.ship_subcat;

        INSERT INTO  VW_REP_FIFO_EXCEDING
        VALUES  v_row;

    END LOOP;


    IF v_row.seq_no IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu exista date '
                                    ||'pentru parametrii de selectie '
                                    ||'precizati !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


END;

/

/
