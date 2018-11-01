--------------------------------------------------------
--  DDL for Package Body PKG_RECEIPT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_RECEIPT" 
IS

-- testing

/*********************************************************************************
    DDL: 18/02/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_receipt_header   (   p_line_id       INTEGER     ,
                                    p_org_code      VARCHAR2    DEFAULT NULL,
                                    p_receipt_year  VARCHAR2    DEFAULT NULL
                                )   RETURN          typ_frm     pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the RECEIPT_HEADER
--
--  PREREQ:
--
--  INPUT:      ORG_CODE        = client
--              RECEIPT_YEAR    = the year in which the receipt was regisetered in the sistem
----------------------------------------------------------------------------------
    CURSOR     C_LINES (    p_line_id       INTEGER,
                            p_org_code      VARCHAR2,
                            p_receipt_year  VARCHAR2
                       )
                IS
                SELECT  h.idriga, h.dcn,
                        h.receipt_year, h.receipt_code, h.receipt_date, h.org_code,
                        h.receipt_type, h.suppl_code, h.doc_number, h.doc_date,
                        h.incoterm, h.currency_code, h.country_from, h.note,
                        h.whs_code, h.status  ,h.fifo,
                        s.description,
                        t.date_legal
                FROM        RECEIPT_HEADER      h
                INNER JOIN  SETUP_RECEIPT       s
                                ON h.receipt_type   =   s.receipt_type
                LEFT JOIN   WHS_TRN             t
                                ON h.idriga         =   t.ref_receipt
                                AND t.flag_storno   =   'N'
                WHERE       h.org_code      LIKE    NVL(p_org_code, '%')
                        AND h.receipt_year  =       p_receipt_year
                        AND p_line_id       IS      NULL
                ---------
                UNION ALL
                ---------
                SELECT  h.idriga, h.dcn,
                        h.receipt_year, h.receipt_code, h.receipt_date, h.org_code,
                        h.receipt_type, h.suppl_code, h.doc_number, h.doc_date,
                        h.incoterm, h.currency_code, h.country_from, h.note,
                        h.whs_code, h.status,h.fifo,
                        s.description,
                        t.date_legal
                FROM        RECEIPT_HEADER      h
                INNER JOIN  SETUP_RECEIPT       s
                                ON h.receipt_type   =   s.receipt_type
                LEFT JOIN   WHS_TRN             t
                                ON  h.idriga         =   t.ref_receipt
                                AND t.flag_storno    =   'N'
                WHERE       h.idriga          =       p_line_id
                -------------
                ORDER BY receipt_code DESC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_receipt_year IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Trebuie sa precizati anul receptiei !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_line_id,p_org_code,p_receipt_year) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.receipt_year;
        v_row.txt02         :=  x.receipt_code;
        v_row.txt03         :=  x.org_code;
        v_row.txt04         :=  x.receipt_type;
        v_row.txt05         :=  x.suppl_code;
        v_row.txt06         :=  x.doc_number;
        v_row.txt07         :=  x.status;
--      v_row.txt08         :=  x.registered; -- 20080220 Z -  coloumn canceled from table
        v_row.txt09         :=  x.incoterm;
        v_row.txt10         :=  x.currency_code;
        v_row.txt11         :=  x.country_from;
        v_row.txt12         :=  x.note;
        v_row.txt13         :=  x.whs_code;
        v_row.txt14         :=  x.description;
     -- v_row.txt15 is set below !!!!
        v_row.txt16         :=  x.fifo;
        
        --
        v_row.data01        :=  x.receipt_date;
        v_row.data02        :=  x.doc_date;
        v_row.data03        :=  x.date_legal;
        --
        FOR x IN Pkg_Receipt.C_RECEIPT_DETAIL(v_row.idriga) LOOP
            v_row.numb01    :=  x.line_count;
            v_row.numb02    :=  x.total_value;
            v_row.numb03    :=  x.total_weight_net;
            v_row.numb04    :=  x.total_weight_brut;
            v_row.numb05    :=  x.total_weight_pack;
            IF x.min_season = x.max_season THEN
                v_row.txt15 :=  x.min_season;
            ELSE
                v_row.txt15     :=  x.min_season || ' ' || x.max_season;
            END IF;
        END LOOP;

        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
-----------------------------------------------------------------------------------------------------------------
/*********************************************************************************
    DDL: 18/02/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_receipt_detail(p_line_id INTEGER,p_ref_receipt INTEGER DEFAULT NULL)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the RECEIPT_DETAIL
--              for a receipt identified by ref_receipt
--  PREREQ:
--
--  INPUT:      REF_RECEIPT     =   an integer that is IDRIGA of the receipt
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_line_id INTEGER,p_ref_receipt INTEGER)   IS
                SELECT
                        d.dcn, d.idriga, d.ref_receipt, d.uom_receipt, d.qty_doc,
                        d.qty_count, d.puom, d.qty_doc_puom, d.qty_count_puom,
                        d.org_code, d.item_code, d.colour_code, d.size_code,
                        d.oper_code_item, d.season_code, d.whs_code, d.order_code,
                        d.custom_code, d.origin_code, d.weight_net, d.weight_brut,d.weight_pack,
                        d.price_doc, d.price_doc_puom, d.note, d.group_code, d.line_seq,
                        i.description   description_item,
                        c.description   description_colour,
                        v.description   description_custom
                FROM        RECEIPT_DETAIL      d
                INNER JOIN  ITEM                i
                                ON  i.item_code     =   d.item_code
                                AND i.org_code      =   d.org_code
                LEFT JOIN  COLOUR              c
                                ON  c.colour_code   =   d.colour_code
                                AND c.org_code      =   d.org_code
                LEFT JOIN  CUSTOM              v
                                ON  v.custom_code   =   d.custom_code
                WHERE       d.ref_receipt   =   p_ref_receipt
                        AND p_line_id       IS  NULL
                ----------
                UNION ALL
                ---------
                SELECT
                        d.dcn, d.idriga, d.ref_receipt, d.uom_receipt, d.qty_doc,
                        d.qty_count, d.puom, d.qty_doc_puom, d.qty_count_puom,
                        d.org_code, d.item_code, d.colour_code, d.size_code,
                        d.oper_code_item, d.season_code, d.whs_code, d.order_code,
                        d.custom_code, d.origin_code, d.weight_net, d.weight_brut,d.weight_pack,
                        d.price_doc, d.price_doc_puom, d.note, d.group_code, d.line_seq,
                        i.description   description_item,
                        c.description   description_colour,
                        v.description   description_custom
                FROM        RECEIPT_DETAIL      d
                INNER JOIN  ITEM                i
                                ON  i.item_code     =   d.item_code
                                AND i.org_code      =   d.org_code
                LEFT JOIN  COLOUR              c
                                ON  c.colour_code   =   d.colour_code
                                AND c.org_code      =   d.org_code
                LEFT JOIN  CUSTOM              v
                                ON  v.custom_code   =   d.custom_code
                WHERE   d.idriga    =  p_line_id
                ---------------------------
                ORDER BY idriga
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_ref_receipt IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Nu sunteti pozitionat pe o receptie valida !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_line_id,p_ref_receipt) LOOP

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.uom_receipt;
        v_row.txt02         :=  x.puom;
        v_row.txt03         :=  x.org_code;
        v_row.txt04         :=  x.item_code;
        v_row.txt05         :=  x.colour_code;
        v_row.txt06         :=  x.size_code;
        v_row.txt07         :=  x.oper_code_item;
        v_row.txt08         :=  x.season_code;
        v_row.txt09         :=  x.whs_code;
        v_row.txt10         :=  x.order_code;
        v_row.txt11         :=  x.custom_code;
        v_row.txt12         :=  x.origin_code;
        v_row.txt13         :=  x.note;
        v_row.txt14         :=  x.description_item;
        v_row.txt15         :=  x.group_code;
        v_row.txt16         :=  x.description_colour;
        v_row.txt17         :=  x.description_custom;


        --
        v_row.numb01        :=  x.ref_receipt;
        v_row.numb02        :=  x.qty_doc;
        v_row.numb03        :=  x.qty_count;
        v_row.numb04        :=  x.qty_doc_puom;
        v_row.numb05        :=  x.qty_count_puom;
        v_row.numb06        :=  x.weight_net;
        v_row.numb07        :=  x.weight_brut;
        v_row.numb08        :=  x.price_doc;
        v_row.numb09        :=  x.price_doc_puom;
        v_row.numb10        :=  x.weight_pack;
        v_row.numb11        :=  x.line_seq;
        
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 20/02/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_setup_receipt  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the SETUP_RECEIPT
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  h.*
                FROM    SETUP_RECEIPT  h
                ORDER BY h.receipt_type ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.receipt_type;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.whs_code;
        v_row.txt04         :=  x.currency_code;
        v_row.txt05         :=  x.property;
        v_row.txt06         :=  x.extern;
        v_row.txt07         :=  x.service;
        v_row.txt08         :=  x.flag_return;
        v_row.txt09         :=  x.trn_type;
        v_row.txt10         :=  x.fifo;


        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 21/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receipt_header_iud(p_tip VARCHAR2, p_row RECEIPT_HEADER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               RECEIPT_HEADER%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Receipt.p_receipt_header_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_receipt_header_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receipt_header_blo(p_tip VARCHAR2, p_row IN OUT RECEIPT_HEADER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    C_DOC_TYPE          VARCHAR2(32000) :=  'RECEIPT';
    C_CATEGORY_CODE     VARCHAR2(32000) :=  'CTL';
    C_MOD_COL_1         VARCHAR2(32000) :=    'DOC_NUMBER,'
                                            ||'DOC_DATE,'
                                            ||'INCOTERM,'
                                            ||'CURRENCY_CODE,'
                                            ||'COUNTRY_FROM,'
                                            ||'NOTE,'
                                            ||'SUPPL_CODE,'
                                            ||'FIFO'
                                            ;
    C_MOD_COL_2         VARCHAR2(32000) :=  'INCOTERM,COUNTRY_FROM,NOTE,FIFO';
    C_MOD_COL_3         VARCHAR2(32000) :=  'RECEIPT_TYPE';

    
    v_mod_col           VARCHAR2(32000);
    v_detail_count      INTEGER;
    C_ERR_CODE          VARCHAR2(32000) :=  'RECEIPT_HEADER_01';
    v_t                 BOOLEAN;
    
    v_row_old           RECEIPT_HEADER%ROWTYPE;

    v_row_cli           ORGANIZATION%ROWTYPE;
    v_row_sup           ORGANIZATION%ROWTYPE;
    v_row_sre           SETUP_RECEIPT%ROWTYPE;
    v_row_inc           DELIVERY_CONDITION%ROWTYPE;
    v_row_cot           COUNTRY%ROWTYPE;
    v_row_cur           CURRENCY%ROWTYPE;
    v_row_whs           WAREHOUSE%ROWTYPE;
    v_row_wct           WAREHOUSE_CATEG%ROWTYPE;
    v_row_ach           AC_HEADER%ROWTYPE;

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        v_row_cli.org_code  :=  p_row.org_code;
        Pkg_Check.p_chk_organization(v_row_cli);
        --
        v_row_sup.org_code  :=  p_row.suppl_code;
        Pkg_Check.p_chk_organization(v_row_sup);
        --
        v_row_sre.receipt_type  :=  p_row.receipt_type;
        Pkg_Check.p_chk_setup_receipt(v_row_sre);
        --
        v_row_cur.currency_code  :=  p_row.currency_code;
        Pkg_Check.p_chk_currency(v_row_cur);
        --
        v_row_cot.country_code  :=  p_row.country_from;
        Pkg_Check.p_chk_country(v_row_cot);
        --
        IF p_row.whs_code IS NOT NULL THEN
            v_row_whs.whs_code  :=  p_row.whs_code;
            Pkg_Check.p_chk_warehouse(v_row_whs);
        END IF;
        --
        IF p_row.incoterm IS NOT NULL THEN
            v_row_inc.deliv_cond_code  :=  p_row.incoterm;
            Pkg_Check.p_chk_delivery_condition(v_row_inc);
        END IF;
        --
        --when creating receipt header the fifo field must be left null
        -- it will be set to the in this procedure to the default from SETUP_RECEIPT
        v_t :=      p_tip       =   'I'
                AND p_row.fifo  IS NOT NULL
                ;
        IF v_t THEN P_Sen('090',
         'La crearea antetului de receptie campul FIFO desc trebuie lasat gol !!!'
        );
        END IF;
        --
        IF       p_tip = 'I' 
            OR  (p_tip = 'U' AND Pkg_Lib.F_Column_Is_Modif2(C_MOD_COL_3,v_mod_col) = -1)
        THEN
            p_row.fifo  :=  v_row_sre.fifo;        
        END IF;
        --
        -- check if currency is forced by receipt type
        v_t :=      v_row_sre.currency_code IS NOT NULL
                AND v_row_sre.currency_code <> p_row.currency_code
                ;
        IF v_t THEN P_Sen('100',
         'Valuta este fortat de tipul receptiei si trebuie sa fie !!!',
         v_row_sre.currency_code
        ); END IF;
        -- if external document has to be specified country_from and incoterm
        v_t :=      v_row_sre.extern    =  'Y'
                AND p_row.incoterm      IS  NULL
                ;
        IF v_t THEN P_Sen('110',
         'Pentru documente externe trebuie sa precizati incoterm !!!'
        ); END IF;
        --
        v_t :=     (v_row_sre.extern    =  'Y'   AND p_row.country_from = 'RO')
                    OR
                   (v_row_sre.extern    =  'N'   AND p_row.country_from <> 'RO')
                   ;
        IF v_t THEN P_Sen('115',
         'Pentru documente externe Tara exped trebuie sa difera de RO si invers !!!'
        ); END IF;
                     
        -- if receipt is service of type 'S' or return of material from conto lavoro
            -- the supplier should be with flag_lohn = 'Y'
            -- the warehouse should be specified
            -- the warehouse should be of categ CTL
            -- the owner of the warehouse should be the supplier specified
        v_t :=  (
                        v_row_sre.service       = 'S' 
                    OR  v_row_sre.flag_return   = 'Y'
                )
                AND
                v_row_sup.flag_lohn = 'N';
        IF v_t THEN P_Sen('120',
         'Documentul este de tip receptie de la Terti, trebuie sa precizati un tert in locatia de furnizor !!!'
        ); END IF;
        -- must be a warehouse specified
        v_t :=  (
                        v_row_sre.service       = 'S' 
                    OR  v_row_sre.flag_return   = 'Y'
                )
                AND
                p_row.whs_code IS NULL;
        IF v_t THEN P_Sen('130',
         'Documentul este de tip receptie de la Terti, trebuie sa precizati magazia asociata tertului !!!'
        ); END IF;
        -- 
        v_t :=  (
                        v_row_sre.service       = 'S' 
                    OR  v_row_sre.flag_return   = 'Y'
                )
                AND
                v_row_whs.category_code <> C_CATEGORY_CODE;
        IF v_t THEN P_Sen('140',
         'Magazia asociata tertului trebuie sa fie de tip CTL !!!'
        ); END IF;
        ---
        v_t :=  (
                        v_row_sre.service       = 'S' 
                    OR  v_row_sre.flag_return   = 'Y'
                )
                AND
                v_row_whs.org_code <> p_row.suppl_code;
        IF v_t THEN P_Sen('150',
         'Magazia precizata nu corespunde tertului precizat !!!'
        ); END IF;


    END;
    ---------------------------------------------------------------------------
BEGIN

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --
                p_row.receipt_date      :=  TRUNC(SYSDATE);
                p_row.receipt_year      :=  NVL(p_row.receipt_year,TO_CHAR(p_row.receipt_date,'YYYY'));
                p_row.receipt_code      :=  Pkg_Env.f_get_app_doc_number
                                             (
                                                 p_org_code     =>   Pkg_Glb.C_MYSELF   ,
                                                 p_doc_type     =>   C_DOC_TYPE         ,
                                                 p_doc_subtype  =>   C_DOC_TYPE         ,
                                                 p_num_year     =>   p_row.receipt_year
                                             );
                 p_row.status           :=  'I';

        WHEN    'U' THEN
                -- check if the accounting informations were generated based on this receipt 
                --  if so, cannot modify it 
                v_row_ach.ref_trn   :=  p_row.idriga;
                Pkg_Ac.p_get_ac_header(v_row_ach, v_t);
                IF v_t THEN P_Sey(C_ERR_CODE,
                'Documentul contabil pentru aceasta receptie a fost tiparit. Nu mai puteti modifica datele !!! '
                );END IF;
                -- 
                v_row_old.idriga    :=  p_row.idriga;
                IF Pkg_Get.f_get_receipt_header(v_row_old) THEN NULL; END IF;
                v_mod_col   :=  Pkg_Mod_Col.f_receipt_header(v_row_old, p_row);
                -- check if there is detail lines on the receipt
                -- if there are some information not modifyable
                FOR x IN Pkg_Receipt.C_RECEIPT_DETAIL(p_row.idriga) LOOP
                    v_detail_count :=  x.line_count;
                END LOOP;
                v_detail_count  :=  NVL(v_detail_count,0);
                
                v_t :=      v_detail_count > 0
                        AND Pkg_Lib.F_Column_Other_Is_Modif2(C_MOD_COL_1,v_mod_col) = -1
                        ;
                IF v_t THEN P_Sey(C_ERR_CODE,
                'Receptia are detalii,nu mai puteti modifica unele informatii de antet !!! '
                );END IF;
                -- check if receiot regisetered
                IF v_row_old.status <> 'I' THEN
                    v_t :=  Pkg_Lib.F_Column_Other_Is_Modif2(C_MOD_COL_2,v_mod_col) = -1
                    ;
                    IF v_t THEN P_Sey(C_ERR_CODE,
                    'Receptia a fost anulata / inregistrata in magazie,nu mai puteti modifica informatiile de antet !!! '
                    );END IF;
                END IF;
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receipt_detail_iud(p_tip VARCHAR2, p_row RECEIPT_DETAIL%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_detail when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               RECEIPT_DETAIL%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Receipt.p_receipt_detail_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_receipt_detail_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receipt_detail_blo( p_tip   VARCHAR2, p_row IN OUT RECEIPT_DETAIL%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_detail when is created , updated, deleted
                - fields that must be filed: ITEM_CODE, SEASON_CODE, WHS_CODE
                - if type is extern the fields CUSTOM_CODE, ORIGIN_CODE must be filed
                - check if warehouse is forced by receipt type
                - check if warehouse is with FLAG_QTY_ON_HAND
                - if type = service 'S' then OPER_CODE_ITEM and ORDER_CODE must be filed
                - check if colour and size are managed correctly acording to FLAG_COLOUR, FLAG_SIZE
                - check if UOM_RECEIPT is egal to PUOM or SUOM, and if SUOM exists
                - check if quantities are not null and >=0 and at least one is > 0
                - check if price is not NULL but can be 0
                - transfor in PUOM if necesary and fill QTY_DOC_PUOM,QTY_COUNT_PUOM,PRICE_DOC_PUOM
--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    v_row_hed       RECEIPT_HEADER%ROWTYPE;
    v_row_sre       SETUP_RECEIPT%ROWTYPE;
    v_row_old       RECEIPT_DETAIL%ROWTYPE;

    v_row_itm       ITEM%ROWTYPE;
    v_row_col       COLOUR%ROWTYPE;
    v_row_siz       ITEM_SIZE%ROWTYPE;
    v_row_ope       OPERATION%ROWTYPE;
    v_row_stg       WORK_SEASON%ROWTYPE;
    v_row_whs       WAREHOUSE%ROWTYPE;
    v_row_wct       WAREHOUSE_CATEG%ROWTYPE;
    v_row_ord       WORK_ORDER%ROWTYPE;
    v_row_cst       CUSTOM%ROWTYPE;
    v_row_cot       COUNTRY%ROWTYPE;
    v_row_pum       PRIMARY_UOM%ROWTYPE;
    v_row_wgr       WORK_GROUP%ROWTYPE;
    v_row_wg2       WORK_GROUP%ROWTYPE;
 
    v_row_trh       WHS_TRN%ROWTYPE;
    v_row_ach       AC_HEADER%ROWTYPE;
    v_found         BOOLEAN;

    it_rot          Pkg_Mov.type_rout1;
 
    v_mod_col       VARCHAR2(32000);
    v_t             BOOLEAN ;
    C_ERR_CODE      VARCHAR2(32000) :=  'RECEIPT_DETAIL';
    v_error         BOOLEAN;
    -- colomns that can be modified even when the receipt is registered to warehouse
    C_MOD_COL       VARCHAR2(32000) :=    'CUSTOM_CODE,'
                                        ||'ORIGIN_CODE,'
                                        ||'WEIGHT_NET,'
                                        ||'WEIGHT_BRUT,'
                                        ||'PRICE_DOC,'
                                        ||'NOTE,'
                                        ||'WEIGHT_PACK'
                                        ;

    C_MOD_COL_AC    VARCHAR2(32000) :=    'CUSTOM_CODE,'
                                        ||'ORIGIN_CODE,'
                                        ||'WEIGHT_NET,'
                                        ||'WEIGHT_BRUT,'
                                        ||'NOTE,'
                                        ||'WEIGHT_PACK'
                                        ;

    C_DECIMAL       INTEGER         :=  4;     
    C_SEGMENT_CODE  VARCHAR2(32000) :=  'VW_PREP_GROUP_CODE';                
                                   
    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        v_row_itm.org_code      :=  p_row.org_code;
        v_row_itm.item_code     :=  p_row.item_code;
        Pkg_Check.p_chk_item(v_row_itm);
        --
        IF p_row.colour_code IS NOT NULL THEN
           v_row_col.org_code      :=  p_row.org_code;
           v_row_col.colour_code   :=  p_row.colour_code;
           Pkg_Check.p_chk_colour(v_row_col,p_row.item_code);
        END IF;
        --
        IF p_row.size_code IS NOT NULL THEN
           v_row_siz.size_code      :=  p_row.size_code;
           Pkg_Check.p_chk_item_size(v_row_siz,p_row.item_code);
        END IF;
        --
        IF p_row.oper_code_item IS NOT NULL THEN
           v_row_ope.oper_code      :=  p_row.oper_code_item;
           Pkg_Check.p_chk_operation(v_row_ope,p_row.item_code);
        END IF;
        --
        IF p_row.order_code IS NOT NULL THEN
            v_row_ord.org_code          :=  p_row.org_code;
            v_row_ord.order_code        :=  p_row.order_code;
            Pkg_Check.p_chk_work_order(v_row_ord,p_row.item_code);
        END IF;
        --
        p_row.season_code       :=  COALESCE( p_row.season_code, 
                                              v_row_ord.season_code, 
                                              pkg_order.f_get_default_season(p_row.org_code));
        v_row_stg.org_code      :=  p_row.org_code;
        v_row_stg.season_code   :=  p_row.season_code;
        Pkg_Check.p_chk_work_season(v_row_stg, p_row.item_code);
        --
        v_row_whs.whs_code      :=  p_row.whs_code;
        Pkg_Check.p_chk_warehouse(v_row_whs,p_row.item_code);
        --
        p_row.custom_code := COALESCE(p_row.custom_code, v_row_itm.custom_code);
        IF p_row.custom_code IS NOT NULL THEN
            v_row_cst.custom_code   :=  p_row.custom_code;
            Pkg_Check.p_chk_custom(v_row_cst,p_row.item_code);
        END IF;
        --
        p_row.origin_code := coalesce(p_row.origin_code, v_row_hed.country_from);
        IF p_row.origin_code IS NOT NULL THEN
            v_row_cot.country_code   :=  p_row.origin_code;
            Pkg_Check.p_chk_country(v_row_cot,p_row.item_code);
        END IF;
        --
        IF p_row.group_code IS NOT NULL THEN
            v_row_wgr.group_code    :=  p_row.group_code;
            Pkg_Check.p_chk_work_group(v_row_wgr,p_row.item_code);
        END IF;
        -- check the colour and size
        Pkg_Item.p_check_colour_size(
                p_org_code       =>     p_row.org_code,
                p_item_code      =>     p_row.item_code,
                p_flag_colour    =>     v_row_itm.flag_colour ,
                p_colour_code    =>     p_row.colour_code,
                p_flag_size      =>     v_row_itm.flag_size,
                p_size_code      =>     p_row.size_code
                );
        -- get the receipt type
        v_row_sre.receipt_type  :=  v_row_hed.receipt_type;
        IF  Pkg_Get2.f_get_setup_receipt_2(v_row_sre) THEN NULL; END IF;
        -- if the org_code in RECEIPT_HEADER is not C_MYSELF the lines in 
        -- RECEIPT_DETAIL canot have other ORG_CODE than in the header
        v_t     :=      v_row_hed.org_code  <> Pkg_Glb.C_MYSELF
                    AND p_row.org_code      <>  v_row_hed.org_code
                    ;
        IF v_t THEN P_Sen('040',
         'Pentru receptii care nu au antetul pe '||Pkg_Glb.C_MYSELF ||' nu se pot inregistra in detalii '
         ||' numai aceeasi gestiune ca si in antetul documentului adica '||v_row_hed.org_code||' !!!',
          v_row_itm.item_code
        );END IF;
        -- if the item is buy it cannot have oper_code_item set
        v_t :=  v_row_itm.make_buy = 'A' AND p_row.oper_code_item IS NOT NULL;
        IF v_t THEN P_Sen('050',
         'Nu puteti preciza faza numai pentru articole care sunt de productie !!!',
          v_row_itm.item_code
        );END IF;
        -- if external I need origin end custom code
        v_t :=      v_row_sre.extern ='Y'
                AND (p_row.custom_code IS NULL OR p_row.origin_code IS NULL);
        IF v_t THEN P_Sen('060',
         'Pentru receptii din extern este obligatoriu codul vamal si tara origine !!!',
          v_row_itm.item_code
        );END IF;
        -- check if stoc warehouse is forced by the receipt type
        v_t :=      v_row_sre.whs_code IS NOT NULL
                AND p_row.whs_code <> v_row_sre.whs_code;
        IF v_t THEN P_Sen('070',
         'Pentru acest tip de receptie magazia de stoc este fortata si trebuie sa fie '||v_row_sre.whs_code||' !!!',
          v_row_itm.item_code
        );END IF;
        -- check if warehouse is of correct type
        v_t :=  v_row_whs.category_code NOT IN (
                                           Pkg_Glb.C_WHS_MPC,
                                           Pkg_Glb.C_WHS_MPP,
                                           Pkg_Glb.C_WHS_PAT,
                                           Pkg_Glb.C_WHS_WIP,
                                           Pkg_Glb.C_WHS_SHP
                                          );
        IF v_t THEN P_Sen('075',
         'Ati precizat o magazie care nu poate fi de receptie !!!',
          v_row_itm.item_code
        );END IF;
        -- check if the property goods enters only into property warehouse
        -- and vice versa
        v_t :=      v_row_sre.property = 'Y'
                AND v_row_whs.category_code NOT IN (
                                                Pkg_Glb.C_WHS_MPP,
                                                Pkg_Glb.C_WHS_PAT,
                                                Pkg_Glb.C_WHS_SHP
                                                );
        IF v_t THEN P_Sen('086',
         'Pentru acest tip de receptie magazia de stoc trebuie sa fie magazie de proprietate !!!',
          v_row_itm.item_code
        );END IF;
        ---
        v_t :=      v_row_sre.property = 'N'
                AND v_row_whs.category_code NOT IN (
                                                Pkg_Glb.C_WHS_MPC,
                                                Pkg_Glb.C_WHS_WIP,
                                                Pkg_Glb.C_WHS_SHP
                                                );
        IF v_t THEN P_Sen('087',
         'Pentru acest tip de receptie magazia de receptie nu poate fi de proprietate !!!',
          v_row_itm.item_code
        );END IF;
        -- if service type S (return of processed products from CTL) we have to have an OPER_CODE_ITEM
        v_t :=      v_row_sre.service = 'S'
                AND (p_row.oper_code_item IS NULL OR p_row.order_code IS NULL)  ;  
        IF v_t THEN P_Sen('088',
         'Receptie e de tip semifabricate de la TERT, in acest caz trebuie sa precizati ultima operatie '
         ||'realizata la tert si bola client aferenta !!!',
          v_row_itm.item_code
        );END IF;
        ---
        v_t :=      v_row_sre.service = 'S'
                AND v_row_ord.item_code <> p_row.item_code;
        IF v_t THEN P_Sen('090',
         'Receptie e de tip semifabricate de la TERT, in acest caz codul articolului trebuie sa fie '
         ||'identic cu codul produsului de pe bola care este '||v_row_ord.item_code||' !!!',
          v_row_itm.item_code
        );END IF;
        ---
        v_t :=      v_row_sre.service = 'S'
                AND v_row_ord.season_code  <> p_row.season_code;
        IF v_t THEN P_Sen('092',
         'Receptie e de tip semifabricate de la TERT, in acest caz stagiunea articolului trebuie sa fie '
         ||'identic cu stagiunea bolei care este '||v_row_ord.season_code||' !!!',
          v_row_itm.item_code
        );END IF;
        -- if service type S (return of processed products from CTL) we have to check:
        -- if item is a final product when the movement has to be done without group_code
        -- if the item is semiproduct it has to be moved with group_code
        v_t:=       v_row_sre.service       = 'S'
                AND p_row.oper_code_item    IS NOT NULL 
                AND p_row.order_code        IS NOT NULL  ;
        IF v_t THEN
            v_row_wg2.idriga    := Pkg_Order.f_ord_get_ref_group(
                                                                 p_row.org_code,
                                                                 p_row.order_code
                                                                );                                                                 
            Pkg_Get.p_get_work_group(v_row_wg2);
            --
            DELETE FROM VW_PREP_GROUP_CODE;
            INSERT INTO VW_PREP_GROUP_CODE VALUES (v_row_wg2.group_code,C_SEGMENT_CODE);
            FOR x IN Pkg_Mov.C_GROUP_ROUTING LOOP            
                it_rot(x.oper_code_curr)    :=  x;                                                                                                                                            
            END LOOP;                                                                                                                      
            --
            v_t :=  NOT it_rot.EXISTS(p_row.oper_code_item);
            IF v_t THEN P_Sen('092',
             'Aceasta faza nu se regaseste pe routingul comenzii, '
             ||'trebuie sa introduceti o faza de pe routingul comenzii !!',
              v_row_itm.item_code
            );END IF;
            --
            IF NOT v_t THEN
                v_t :=  it_rot(p_row.oper_code_item).oper_code_next IS NULL;
                IF v_t THEN
                    v_t :=  p_row.group_code IS NOT NULL;
                    IF v_t THEN P_Sen('095',
                     'Aceasta faza este ultimul pe routingul comenzii, '
                     ||'in acest caz receptia se face numai pe bola fara a se introduce comanda !!',
                      v_row_itm.item_code
                    );END IF;
                ELSE
                    p_row.group_code    :=  NVL(p_row.group_code,v_row_wg2.group_code);
                    v_t :=  p_row.group_code <> v_row_wg2.group_code;
                    IF v_t THEN P_Sen('098',
                     'Receptie e de tip semifabricate de la TERT, in acest caz comanda asociata cu bola '
                     ||'trebuie sa fie identica cu comanda introdusa in formular !!!',
                      v_row_itm.item_code
                    );END IF;
                END IF;
            END IF;
        END IF;
        --  
  
        v_row_pum.puom   :=  p_row.uom_receipt;
        Pkg_Check.p_chk_primary_uom(v_row_pum);
        -- check the unit of measure of receit
        v_t :=  p_row.uom_receipt  NOT IN (v_row_itm.puom, NVL(v_row_itm.suom,v_row_itm.puom));
        IF v_t THEN P_Sen('100',
         'Unitatea de masura trebuie sa fie cea primara sau secundara pentru acest cod !!!',
          v_row_itm.item_code
          ||', PUOM :'||v_row_itm.puom
          ||', SUOM: '||v_row_itm.suom 
        );END IF;
        -- chck on quantities
        p_row.qty_doc   :=  NVL(p_row.qty_doc,0);
        p_row.qty_count :=  NVL(p_row.qty_count,0);
        --
        v_t :=  (p_row.qty_doc < 0 OR p_row.qty_count < 0)
                OR
                (p_row.qty_doc = 0 AND p_row.qty_count = 0);
        IF v_t THEN P_Sen('110',
         'Campurile cu cantitati trebuie completate,acestea trebuie sa fie pozitive sau zero, '
         ||'cel putin o cantitate (document/receptionata) trebuie sa fie pozitiva !!!',
          v_row_itm.item_code
        );END IF;
        -- cuantity have max x decimals
        v_t :=      (p_row.qty_doc - TRUNC(p_row.qty_doc,C_DECIMAL) > 0)
                OR  (p_row.qty_count - TRUNC(p_row.qty_count,C_DECIMAL) > 0);
        IF v_t THEN P_Sen('120',
         'Cantitatile pot avea maxim '||C_DECIMAL||' zecimale !!!',
          v_row_itm.item_code
        );END IF;
        -- price have not be NULL
        p_row.price_doc :=  NVL(p_row.price_doc,0);
        -- transform in primary unit of measure
        p_row.puom  :=  v_row_itm.puom;
        --
        v_t :=  p_row.uom_receipt <> v_row_itm.puom;
        IF v_t THEN
            -- if I had an error previously for the secondary unit of measure
            -- the v_row_itm.uom_conv is 0 so ONLY to avoid the division by 0
            -- error I force it = 1
            IF v_row_itm.uom_conv = 0 THEN
                v_row_itm.uom_conv      :=  1;
            END IF;
            --
            p_row.qty_doc_puom      :=  p_row.qty_doc * v_row_itm.uom_conv;
            p_row.qty_doc_puom      :=  ROUND(p_row.qty_doc_puom,2);
            p_row.qty_count_puom    :=  p_row.qty_count * v_row_itm.uom_conv;
            p_row.qty_count_puom    :=  ROUND(p_row.qty_count_puom,2);
            p_row.price_doc_puom    :=  p_row.price_doc / v_row_itm.uom_conv;
            p_row.price_doc_puom    :=  ROUND(p_row.price_doc_puom,4);
        ELSE
            p_row.qty_doc_puom      :=  p_row.qty_doc ;
            p_row.qty_count_puom    :=  p_row.qty_count;
            p_row.price_doc_puom    :=  p_row.price_doc;
        END IF;
    END;
    ---------------------------------------------------------------------------
BEGIN
    --
    v_t :=  p_row.ref_receipt IS NULL;
    IF v_t THEN P_Sey(C_ERR_CODE,
     'Nu sunteti pozitionat pe o receptie valida  !!!'
    );END IF;
    --
    v_row_hed.idriga    :=  p_row.ref_receipt;
    v_t :=  NOT Pkg_Get.f_get_receipt_header(v_row_hed);
    IF v_t THEN P_Sey(C_ERR_CODE,
     'Antetul de receptie cu identificatorul intern (IDRIGA) :'||v_row_hed.idriga
     ||' nu exista in baza de dat !!!'
    );END IF;
    --
    v_row_old.idriga    :=  p_row.idriga;
    IF Pkg_Get.f_get_receipt_detail(v_row_old) THEN NULL; END IF;
    v_mod_col   :=  Pkg_Mod_Col.f_receipt_detail(v_row_old, p_row);

    CASE    p_tip
        WHEN    'I' THEN
                --
                v_t :=  v_row_hed.status <> 'I';
                IF v_t THEN P_Sey(C_ERR_CODE,
                 'Nu puteti modifica receptia, aceasta a fost inregistrata in magazie/anulata !!!' 
                );END IF;
                --                
        WHEN    'U' THEN
                --
                v_t     :=  v_row_hed.status = 'X';
                IF v_t THEN P_Sey(C_ERR_CODE,
                 'Nu puteti modifica receptia, aceasta este anulata (X) !!!' 
                );END IF;
                --
                v_t     :=  v_row_hed.status IN ('F','M');
                IF v_t  THEN
                    -- check if the accounting informations were generated based on this receipt 
                    --  if so, cannot modify it 
                    v_row_trh.ref_receipt       :=  p_row.ref_receipt;
                    Pkg_Receipt.p_get_trn_header(v_row_trh, v_t);
                    v_row_ach.ref_trn           :=  v_row_trh.idriga;
                    Pkg_Ac.p_get_ac_header(v_row_ach, v_t);
                    v_t    :=  Pkg_Lib.F_Column_Other_Is_Modif2(C_MOD_COL_AC,v_mod_col) = -1;
                    --
                    IF v_t THEN P_Sey(C_ERR_CODE,
                     'Documentul contabil pentru aceasta receptie a fost generat !. Nu mai puteti modifica datele!!!'
                    );END IF;
                END IF;
                --
                v_t     :=  v_row_hed.status IN ('F','M');
                IF v_t  THEN
                     -- if regisetered to warehouse only some information can be modified
                     -- on detail (weight, origin, custom)
                     v_t    :=  Pkg_Lib.F_Column_Other_Is_Modif2(C_MOD_COL,v_mod_col) = -1;
                     --
                    IF v_t THEN P_Sey(C_ERR_CODE,
                     'Nu puteti modifica receptia, aceasta a fost inregistrata in magazie !!!' 
                    );END IF;
                END IF;
                --
        WHEN    'D' THEN
                v_t :=  v_row_hed.status <> 'I';
                IF v_t THEN P_Sey(C_ERR_CODE,
                 'Nu puteti sterge din receptie, aceasta a fost inregistrata in magazie/anulata !!!' 
                );END IF;
    END CASE;
    --
    IF p_tip <> 'D' THEN
        p_check_integrity();
    END IF;
    ---
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 24/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receipt_to_warehouse (  p_idriga            INTEGER ,
                                    p_date_legal        DATE    ,
                                    p_force_qty_dif     VARCHAR2)
/*----------------------------------------------------------------------------------
--  PURPOSE:    creates warehouse movement for a receit
                cleare what wil be the date legal
                cleare if we give a message for the differente between qty_doc and qty_count

                Description of SETUP_RECEIPT
                - whs_code      : intended to force a specific warehouse to receive
                                  not depending what warehouse the user introduces
                                 (ex materials that are in property should go into a specifica warehouse)
                - currency_code : force to a specific currency, not depending what the user specifies
                - property      : a flag that indicates that this is a property material
                - extern        : indicates if the goods are coming from outside Romania
                - service       : indicates that the receipt:
                                    N - material
                                    S - service of outside processing items based on the material that
                                        was sent to the processer
                                    Y - service of other kind (transportation, consultancy )
                - flag_return   : return of raw material sent to outside processing

--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS

    CURSOR  C_LINES         (       p_idriga        INTEGER)
                            IS
                            SELECT  *
                            FROM    RECEIPT_DETAIL
                            WHERE       ref_receipt     =   p_idriga
                            ;

    v_row_hed               RECEIPT_HEADER%ROWTYPE;
    v_row_trn               VW_BLO_PREPARE_TRN%ROWTYPE;
    v_row_trh               WHS_TRN%ROWTYPE;
    v_row_sre               SETUP_RECEIPT%ROWTYPE;
    v_row_chk               Pkg_Receipt.C_RECEIPT_DETAIL%ROWTYPE;

    it_rec                  Pkg_Rtype.ta_receipt_detail;
    it_det                  Pkg_Rtype.ta_vw_blo_prepare_trn ;

    C_SEGMENT_CODE          VARCHAR2(32000) :=  'VW_BLO_PREPARE_TRN';

BEGIN

    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_idriga IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o receptie valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the receit header
    v_row_hed.idriga    :=  p_idriga;
    IF NOT Pkg_Get.f_get_receipt_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Receptia cu identificatorul intern '
                                    || p_idriga ||' nu exista in sistem !!!',
              p_err_detail        => p_idriga,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- if receipt was introduced in warehouse already
    IF v_row_hed.status <> 'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Receptia a nu este in stare corecta '
                                    || 'pentru a inregistra in magazie '
                                    ||'(trebue sa fie in starea I ) !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check if supplier document number / date is present
    IF v_row_hed.doc_number IS NULL OR v_row_hed.doc_date IS NULL  THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '00' ,
                 p_err_header        => 'Nu ati precizat numarul si data'
                                        ||' documentului de furnizor !!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'Y'
            );
    END IF;
    -- read  the receipt type line
    v_row_sre.receipt_type  :=  v_row_hed.receipt_type;
    IF Pkg_Get2.f_get_setup_receipt_2(v_row_sre) THEN NULL; END IF;
    -- read al receipt lines in memory
    OPEN    C_LINES(p_idriga);
    FETCH   C_LINES  BULK COLLECT INTO it_rec;
    CLOSE   C_LINES;
    -- check if there are detail lines
    IF it_rec.COUNT = 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Receptia nu are nici o linie de '
                                    ||' detaliu cu cantitatea receptionata mai mare de zero !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;

    -- check the weights (BRUT WEIGHT = NET WEIGHT + PACK WEIGHT )
/*    OPEN    Pkg_Receipt.C_RECEIPT_DETAIL(p_idriga);
    FETCH   Pkg_Receipt.C_RECEIPT_DETAIL INTO v_row_chk;
    CLOSE   Pkg_Receipt.C_RECEIPT_DETAIL;
    IF (v_row_chk.total_weight_net + v_row_chk.total_weight_pack) <> v_row_chk.total_weight_brut THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          =>    '00',
              p_err_header        =>    'Greutatea BRUTA trebuie sa fie egala cu greutatea NETA + greutatea AMBALAJ!',
              p_err_detail        =>    'Brut='||v_row_chk.total_weight_brut||' Net='||v_row_chk.total_weight_net||
                                        ' Ambalaj='||v_row_chk.total_weight_pack,
              p_flag_immediate    => 'Y'
         );
    END IF;
*/

    -- check consistency
    -- call the same routin that checks the detail line when the line
    -- is created with the I - insert parameter
    FOR i IN 1..it_rec.COUNT LOOP
        Pkg_Receipt.p_receipt_detail_blo('I',it_rec(i));
    END LOOP;
    Pkg_Err.p_raise_error_message();
    --
    -- decide movement type
    v_row_trh.trn_type      :=  v_row_sre.trn_type;

    v_row_trh.org_code      :=  v_row_hed.org_code;
    v_row_trh.flag_storno   :=  'N';
    v_row_trh.ref_receipt   :=  v_row_hed.idriga;
    v_row_trh.partner_code  :=  v_row_hed.suppl_code;
    v_row_trh.doc_year      :=  TO_CHAR(v_row_hed.doc_date,'YYYY');
    v_row_trh.doc_code      :=  v_row_hed.doc_number;
    v_row_trh.doc_date      :=  v_row_hed.doc_date;
    
    v_row_trh.date_legal    :=  p_date_legal;

    -- prepare the transaction detail data
    FOR i IN 1..it_rec.COUNT LOOP

        v_row_trn.segment_code          :=  C_SEGMENT_CODE;

        v_row_trn.org_code              :=  it_rec(i).org_code;
        v_row_trn.item_code             :=  it_rec(i).item_code;
        v_row_trn.colour_code           :=  it_rec(i).colour_code;
        v_row_trn.size_code             :=  it_rec(i).size_code;
        v_row_trn.oper_code_item        :=  it_rec(i).oper_code_item;
        v_row_trn.season_code           :=  it_rec(i).season_code;
        v_row_trn.order_code            :=  it_rec(i).order_code;
        v_row_trn.group_code            :=  NULL;
        v_row_trn.whs_code              :=  it_rec(i).whs_code;
        v_row_trn.cost_center           :=  NULL;
        v_row_trn.puom                  :=  it_rec(i).puom;

        CASE
            WHEN    v_row_sre.service       =   'S' THEN

                    v_row_trn.reason_code   := Pkg_Glb.C_P_TRECCTLSP;
                    -- the return of semiprocessed items is with group code
                    v_row_trn.group_code    :=  it_rec(i).group_code ;

            WHEN    v_row_sre.flag_return   =   'Y' THEN

                    v_row_trn.reason_code   := Pkg_Glb.C_P_TRECCTLMF;

            WHEN        v_row_sre.service   =   'N'
                    AND v_row_sre.property  =   'Y'    THEN

                    v_row_trn.reason_code   := Pkg_Glb.C_P_IRECPATR;

            WHEN        v_row_sre.service   =   'N'
                    AND v_row_sre.property  =   'N'    THEN

                    v_row_trn.reason_code   := Pkg_Glb.C_P_IRECCUST;

        END CASE;

        v_row_trn.qty                   :=  it_rec(i).qty_count_puom;
        v_row_trn.trn_sign              :=  +1;
        v_row_trn.ref_receipt           :=  it_rec(i).idriga;

        -- if p_force_qty_dif is NULL or N check if there are difference between qty_doc and qty_count
        IF NVL(p_force_qty_dif,'N') = 'N' THEN
            IF it_rec(i).qty_doc <> it_rec(i).qty_count THEN
                 Pkg_Err.p_set_error_message
                 (    p_err_code          => '100',
                      p_err_header        => 'La urmatoarele pozitii cantitatea  '
                                            ||' de pe document este diferita fata de cea receptionata !!!',
                      p_err_detail        => it_rec(i).item_code||' - '||it_rec(i).qty_doc||' fata de '||it_rec(i).qty_count,
                      p_flag_immediate    => 'N'
                 );
            END IF;
        END IF;
        --
        it_det(it_det.COUNT+1)          :=  v_row_trn;
        --
        IF v_row_trh.trn_type = Pkg_Glb.C_TRN_REC_CTL THEN
            -- this is a receipt from outside processing we have to prepare download lines
            v_row_trn.trn_sign              :=  -1;
            v_row_trn.whs_code              :=  v_row_hed.whs_code;
            CASE  v_row_trn.reason_code
                WHEN    Pkg_Glb.C_P_TRECCTLSP   THEN
                        v_row_trn.reason_code   :=  Pkg_Glb.C_M_TRECCTLSP;
                WHEN    Pkg_Glb.C_P_TRECCTLMF   THEN
                        v_row_trn.group_code    :=  it_rec(i).group_code;
                        IF v_row_trn.group_code IS NULL THEN
                            v_row_trn.reason_code   :=  Pkg_Glb.C_M_TRECCTLMF;
                        ELSE
                            v_row_trn.reason_code   :=  Pkg_Glb.C_M_TRECCTLMO;
                        END IF;
            END CASE;
            it_det(it_det.COUNT+1)          :=  v_row_trn;
        END IF;
    END LOOP;
    --
    Pkg_Err.p_raise_error_message();
    --
    DELETE FROM VW_BLO_PREPARE_TRN;
    --
    FORALL i IN 1..it_det.COUNT
    INSERT INTO VW_BLO_PREPARE_TRN
    VALUES      it_det(i);
 
    --
    --//////////////////////////////////////////////////////////////////////
    -- call the movement engine
    Pkg_Mov.p_whs_trn_engine(
                                p_row_trn   => v_row_trh
                            );

    --//////////////////////////////////////////////////////////////////////

    -- mark the receipt header as registered
    v_row_hed.status := 'M';
    v_row_hed.receipt_date  :=  p_date_legal;
    Pkg_Iud.p_receipt_header_iud('U',v_row_hed);
    --
    COMMIT;
--    EXCEPTION
--    WHEN OTHERS THEN
--        ROLLBACK;
--        raise;
--        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 26/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receipt_to_transit (p_idriga INTEGER)
----------------------------------------------------------------------------------
--  PURPOSE:    creates warehouse movement for transit
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    CURSOR  C_LINES(p_idriga INTEGER)   IS
            SELECT  *
            FROM    RECEIPT_DETAIL
            WHERE   ref_receipt     =   p_idriga
            ;


    v_row_hed               RECEIPT_HEADER%ROWTYPE;
    v_row_trn               VW_BLO_PREPARE_TRN%ROWTYPE;
    it_rec                  Pkg_Rtype.ta_receipt_detail;
    v_row_trh               WHS_TRN%ROWTYPE;
    v_trn_type              VARCHAR2(32000);
    it_det                  Pkg_Rtype.ta_vw_blo_prepare_trn;

    C_SEGMENT_CODE          VARCHAR2(32000) :=  'VW_BLO_PREPARE_TRN';
    C_TRN_TYPE_TRZ          VARCHAR2(32000) :=  'TRZ';
    C_WHS_TRANSIT           VARCHAR2(32000) :=  'TRZ';
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_idriga IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o receptie valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the receit header
    v_row_hed.idriga    :=  p_idriga;
    IF NOT Pkg_Get.f_get_receipt_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Receptia cu identificatorul intern '
                                    || p_idriga ||' nu exista in sistem !!!',
              p_err_detail        => p_idriga,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- if receipt was introduced in warehouse already
    IF v_row_hed.status <> 'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu se poate inregistra in tranzit '
                                    || 'numai o receptie in stare I !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- read al receipt lines in memory
    OPEN    C_LINES(p_idriga);
    FETCH   C_LINES  BULK COLLECT INTO it_rec;
    CLOSE   C_LINES;
    -- check if there are detail lines
    IF it_rec.COUNT = 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Receptia nu are nici o linie de '
                                    ||' detaliu !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check consistency
    -- call the same routin that checks the detail line when the line
    -- is created with the I - insert parameter
    FOR i IN 1..it_rec.COUNT LOOP
        Pkg_Receipt.p_receipt_detail_blo('I',it_rec(i));
    END LOOP;
    Pkg_Err.p_raise_error_message();
    --

    v_row_trh.org_code      :=  v_row_hed.org_code;
    v_row_trh.trn_type      :=  C_TRN_TYPE_TRZ;
    v_row_trh.flag_storno   :=  'N';
    v_row_trh.ref_receipt    :=  v_row_hed.idriga;
    v_row_trh.partner_code  :=  v_row_hed.suppl_code;
    v_row_trh.doc_year      :=  TO_CHAR(v_row_hed.doc_date,'YYYY');
    v_row_trh.doc_code      :=  v_row_hed.doc_number;
    v_row_trh.doc_date      :=  v_row_hed.doc_date;
    v_row_trh.date_legal    :=  v_row_hed.doc_date; --

    -- prepare the transaction detail data
    FOR i IN 1..it_rec.COUNT LOOP

        v_row_trn.segment_code       :=  C_SEGMENT_CODE;
        v_row_trn.org_code           :=  it_rec(i).org_code;
        v_row_trn.item_code          :=  it_rec(i).item_code;
        v_row_trn.colour_code        :=  it_rec(i).colour_code;
        v_row_trn.size_code          :=  it_rec(i).size_code;
        v_row_trn.oper_code_item     :=  it_rec(i).oper_code_item;
        v_row_trn.season_code        :=  it_rec(i).season_code;
        v_row_trn.order_code         :=  it_rec(i).order_code;
        v_row_trn.group_code         :=  NULL;
        v_row_trn.whs_code           :=  C_WHS_TRANSIT;
        v_row_trn.cost_center        :=  NULL;
        v_row_trn.puom               :=  it_rec(i).puom;
        v_row_trn.qty                :=  it_rec(i).qty_count_puom;
        v_row_trn.trn_sign           :=  +1;
        v_row_trn.ref_receipt        :=  it_rec(i).idriga;


        it_det(it_det.COUNT + 1)              :=  v_row_trn;

    END LOOP;

    ---
    DELETE FROM VW_BLO_PREPARE_TRN;
    --
    FORALL i IN 1..it_det.COUNT
    INSERT INTO VW_BLO_PREPARE_TRN
    VALUES      it_det(i);

    -- call the movement engine
    Pkg_Mov.p_whs_trn_engine(
                                 p_row_trn   => v_row_trh
                            );

    -- mark the receipt header as in transit
    v_row_hed.status := 'T';
    Pkg_Iud.p_receipt_header_iud('U',v_row_hed);
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 04/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receipt_undo(
                            p_ref_receipt   INTEGER,
                            p_flag_confirm  VARCHAR2
                        )
----------------------------------------------------------------------------------
--  PURPOSE:    creates the receipt lines from picking
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    -- this should return 1 line for the movement header asociated to
    -- the receipt that was not storned
    CURSOR     C_LINES(p_ref_receipt INTEGER)    IS
                SELECT  *
                FROM    WHS_TRN
                WHERE       ref_receipt  =   p_ref_receipt
                        AND flag_storno =   'N'
                ;


    v_row_hed       RECEIPT_HEADER%ROWTYPE;
    it_wht          Pkg_Rtype.ta_whs_trn;

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_receipt IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o receptie valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the receit header
    v_row_hed.idriga    :=  p_ref_receipt;
    IF NOT Pkg_Get.f_get_receipt_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Receptia cu identificatorul intern '
                                    || p_ref_receipt ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_receipt,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- is not posible to undo a receipt that was not registered
    IF v_row_hed.status <>   'M' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu se poate storna numai o receptie '
                                    ||' ce a fost inregistrata in magazie (stare M) !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    IF Pkg_Lib.f_mod_c(p_flag_confirm, 'Y')  THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu ati confirmat stornarea '
                                    ||' cu caracterul Y !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;

    -- get the movement header asociated with this receipt
    OPEN    C_LINES(p_ref_receipt);
    FETCH   C_LINES BULK COLLECT INTO it_wht;
    CLOSE   C_LINES;
    --
    IF it_wht.COUNT <> 1 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'EROARE SYSTEM (contactati furnizorul aplicatiei) '
                                    ||'!!!',
              p_err_detail        => 'Exista mai multe linii in WHS_TRN pentru receptia '
                                    ||v_row_hed.receipt_code
                                    ||' cu FLAG_STORNO egal cu N',
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    Pkg_Mov.p_whs_trn_storno(
                                p_ref_trn       =>  it_wht(1).idriga,
                                p_flag_commit   =>  FALSE
                            );

    v_row_hed.status    :=  'I';
    Pkg_Iud.p_receipt_header_iud('U',v_row_hed);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;



/*********************************************************************************
    DDL: 07/04/2008  d Create procedure
/*********************************************************************************/
PROCEDURE p_auto_distribute_weight  (   p_ref_receipt       INTEGER,
                                        p_weight_net        NUMBER,
                                        p_flag_confirm      VARCHAR2
                                    )
----------------------------------------------------------------------------------
--  PURPOSE:    makes an automatic distribution of WEIGHT_NET and WEIGHT_BRUT on
--              receipt details
--  INPUT:      REF_RECEIPT     =>  receipt line id
--              WEIGHT_BRUT     =>  set by user
--              WEIGHT_NET      =>  set by user
--              FLAG_CONFIRM    => force the action, even the weights already exists
----------------------------------------------------------------------------------
IS

    CURSOR C_REC_DET    (   p_ref_receipt   INTEGER)
                        IS
                        SELECT      COUNT(1) OVER()                             lines_nr,
                                    d.*,
                                    i.weight_net                                i_weight_net,
                                    i.weight_brut                               i_weight_brut,
                                    i.description                               i_description,
                                    SUM(d.qty_doc * i.weight_net)   OVER()      tot_net,
                                    SUM(d.qty_doc * i.weight_brut)  OVER()      tot_brut,
                                    SUM(d.weight_pack)              OVER()      tot_pack
                        ------------------------------------------------------------------------
                        FROM        RECEIPT_DETAIL      d
                        INNER JOIN  ITEM                i   ON  i.org_code      =   d.org_code
                                                            AND i.item_code     =   d.item_code
                        ------------------------------------------------------------------------
                        WHERE       d.ref_receipt       =   p_ref_receipt
                        ORDER BY    i.weight_net
                        ;

    v_context           VARCHAR2(50);
    v_row_rec           RECEIPT_DETAIL%ROWTYPE;
    v_row_rec_h         RECEIPT_HEADER%ROWTYPE;
    v_distrib_weight    NUMBER;

BEGIN

    -- check if the RECEIPT was phisically registered
    v_row_rec_h.idriga  :=  p_ref_receipt;
    Pkg_Get.p_get_receipt_header(v_row_rec_h);
    IF v_row_rec_h.status = 'R' THEN
        Pkg_Lib.p_rae('ACeasta receptie a fost inregistrata in magazie! Nu se mai poate modifica !');
    END IF;

    -- check the INPUT parameters
    v_context           :=  'Parametri eronati!';
    IF NVL(p_weight_net,0)  = 0 THEN Pkg_App_Tools.P_Log('M','Greutatea neta fara valoare, sau cu valoare 0 !', v_context); END IF;
    Pkg_Lib.p_rae_m('B');

    --
    v_distrib_weight        :=  0;
    FOR x IN C_REC_DET(p_ref_receipt)
    LOOP
        IF NVL(x.weight_net,0) <> 0 AND NVL(p_flag_confirm,'N') <> 'Y' THEN
            Pkg_App_Tools.P_Log('M',x.item_code,'Pozitii cu greutati setate deja!');
        ELSE
            -- verify if all the ITEMS have a NET weight
            IF NVL(x.i_weight_net,0) = 0 THEN
                Pkg_App_Tools.P_Log('M',x.item_code,'Coduri fara greutate neta !');
            ELSE
                -- GET the RECEIPT_DETAIL row
                v_row_rec.idriga        :=  x.idriga;
                Pkg_Get.p_get_receipt_detail(v_row_rec, -1);

                -- compute the NET WEIGHT
                IF x.lines_nr = C_REC_DET%rowcount THEN
                    -- we're on the last line => put all the remaining weight
                    v_row_rec.weight_net    :=  p_weight_net - v_distrib_weight;
                ELSE
                    -- NOT last line => proportionally distribution
                    v_row_rec.weight_net    :=  x.qty_doc * x.i_weight_net * (p_weight_net / x.tot_net);
                END IF;
                -- add the distributed weight to the colector variable
                v_distrib_weight            :=  v_distrib_weight + v_row_rec.weight_net;
                -- brut weight is the net weight + package weight
                v_row_rec.weight_brut       :=  v_row_rec.weight_net + NVL(x.weight_pack,0);
                Pkg_Iud.p_receipt_detail_iud('U', v_row_rec);
            END IF;
        END IF;
    END LOOP;

    Pkg_Lib.p_rae_m('B');

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;

/*********************************************************************************
    DDL: 24/05/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receipt_cancel (
                                p_ref_receipt       INTEGER,
                                p_flag_confirm      VARCHAR2
                             )
----------------------------------------------------------------------------------
--  PURPOSE:    creates the receipt lines from picking
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    v_row_hed       RECEIPT_HEADER%ROWTYPE;

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_receipt IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o receptie valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the receit header
    v_row_hed.idriga    :=  p_ref_receipt;
    IF NOT Pkg_Get.f_get_receipt_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Receptia cu identificatorul intern '
                                    || p_ref_receipt ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_receipt,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- is not posible to cancel a receipt unles it is in status I
    IF v_row_hed.status NOT IN ('I') THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu se poate anula receptia '
                                    ||' numai daca este in stare I (inserata) !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    IF Pkg_Lib.f_mod_c(p_flag_confirm, 'Y')  THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu ati confirmat anularea '
                                    ||' cu caracterul Y !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    v_row_hed.status    :=  'X';
    Pkg_Iud.p_receipt_header_iud('U',v_row_hed);
    --


    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/*********************************************************************************
    DDL: 29/05/2008  d Create procedure
/*********************************************************************************/
PROCEDURE p_get_trn_header   (  p_row   IN OUT WHS_TRN%ROWTYPE, p_found IN OUT BOOLEAN)
IS

    CURSOR C_GET_TRN    (p_ref_receipt  NUMBER)
                        IS
                        SELECT      *
                        FROM        WHS_TRN
                        WHERE       ref_receipt     =   p_ref_receipt
                            AND     flag_storno     =   'N'
                        ;

    v_found             BOOLEAN;

BEGIN

    -- get whs_trn row 
    OPEN    C_GET_TRN   (p_row.ref_receipt);
    FETCH   C_GET_TRN   INTO    p_row;
    p_found :=  C_GET_TRN%FOUND;
    CLOSE   C_GET_TRN;
END;

END;

/

/
