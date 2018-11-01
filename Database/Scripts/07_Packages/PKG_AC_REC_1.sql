--------------------------------------------------------
--  DDL for Package Body PKG_AC_REC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_AC_REC" 
IS

/*********************************************************************************
    DDL: 09/04/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_acrec_header(        p_line_id       INTEGER ,
                                    p_org_code      VARCHAR2    DEFAULT NULL,
                                    p_acrec_year     VARCHAR2    DEFAULT NULL
                              )  RETURN typ_longinfo  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the ACREC_HEADER
--
--  PREREQ:
--
--  INPUT:      ORG_CODE        = client
--              RECEIPT_YEAR    = the year in which the receipt was regisetered in the sistem
----------------------------------------------------------------------------------
    CURSOR     C_LINES (    p_line_id       INTEGER,
                            p_org_code      VARCHAR2,
                            p_acrec_year  VARCHAR2
                        )   IS

                SELECT
                        h.idriga, h.dcn,
                        h.org_code, h.acrec_code, h.acrec_date, h.acrec_year,
                        h.acrec_type, h.status, h.protocol_code,
                        h.protocol_date, h.org_client, h.org_delivery,
                        h.destin_code, h.currency_code, h.incoterm,
                        h.due_date, h.paymant_type, h.paymant_cond,
                        h.employee_code, h.note, h.vat_code,h.truck_number,
                        h.org_billto,
                        -------
                        a.description description_acrec,
                        -------
                        o.org_name client_name, o.country_code, o.city,
                        o.address, o.fiscal_code, o.regist_code,
                        -----
                        l.description description_destin, l.country_code country_code_destin,
                        l.city city_destin, l.address address_destin  ,
                        -----
                        u.nume, u.prenume,
                        -----
                        b.org_name  b_org_name,
                        ----
                        j.org_name  j_org_name,j.fiscal_code j_fiscal_code, j.regist_code j_regist_code
                -------------------
                FROM        ACREC_HEADER        h
                INNER JOIN  SETUP_ACREC         a
                                ON  a.acrec_type    =   h.acrec_type
                INNER JOIN  ORGANIZATION        o
                                ON  o.org_code      =   h.org_client
                INNER JOIN  ORGANIZATION        j
                                ON  j.org_code      =   h.org_billto
                INNER JOIN  ORGANIZATION_LOC    l
                                ON  l.org_code      =   h.org_delivery
                                AND l.loc_code      =   h.destin_code
                INNER JOIN  ORGANIZATION        b
                                ON  b.org_code      =   h.org_delivery
                LEFT JOIN   APP_USER            u
                                ON  u.user_code     =   h.employee_code
                ----------------
                WHERE       h.org_code      LIKE    NVL(p_org_code, '%')
                        AND h.acrec_year    =       p_acrec_year
                        AND p_line_id       IS      NULL
                ---------
                UNION ALL
                ---------
                SELECT
                        h.idriga, h.dcn,
                        h.org_code, h.acrec_code, h.acrec_date, h.acrec_year,
                        h.acrec_type, h.status, h.protocol_code,
                        h.protocol_date, h.org_client, h.org_delivery,
                        h.destin_code, h.currency_code, h.incoterm,
                        h.due_date, h.paymant_type, h.paymant_cond,
                        h.employee_code, h.note, h.vat_code,h.truck_number,
                        h.org_billto,
                        -------
                        a.description description_acrec,
                        -------
                        o.org_name client_name, o.country_code, o.city,
                        o.address, o.fiscal_code, o.regist_code,
                        -----
                        l.description description_destin, l.country_code country_code_destin,
                        l.city city_destin, l.address address_destin  ,
                        -----
                        u.nume, u.prenume,
                        -----
                        b.org_name  b_org_name,
                        ----
                        j.org_name  j_org_name,j.fiscal_code j_fiscal_code, j.regist_code j_regist_code
                -------------------
                FROM        ACREC_HEADER        h
                INNER JOIN  SETUP_ACREC         a
                                ON  a.acrec_type    =   h.acrec_type
                INNER JOIN  ORGANIZATION        o
                                ON  o.org_code      =   h.org_client
                INNER JOIN  ORGANIZATION        j
                                ON  j.org_code      =   h.org_billto
                INNER JOIN  ORGANIZATION_LOC    l
                                ON  l.org_code      =   h.org_delivery
                                AND l.loc_code      =   h.destin_code
                INNER JOIN  ORGANIZATION        b
                                ON  b.org_code      =   h.org_delivery
                LEFT JOIN   APP_USER            u
                                ON  u.user_code     =   h.employee_code
                ----------------
                WHERE       h.idriga          =       p_line_id
                -------------
                ORDER BY acrec_code DESC
                ;
    --
    v_row               tmp_longinfo             :=  tmp_longinfo();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_acrec_year IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Trebuie sa precizati anul facturii !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_line_id,p_org_code,p_acrec_year) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.acrec_year;
        v_row.txt02         :=  x.org_code;
        v_row.txt03         :=  x.acrec_code;
        v_row.txt04         :=  x.acrec_type;
        v_row.txt05         :=  x.status;
        v_row.txt06         :=  x.protocol_code;
        v_row.txt07         :=  x.org_client;
        v_row.txt08         :=  x.org_delivery;
        v_row.txt09         :=  x.destin_code;
        v_row.txt10         :=  x.currency_code;
        v_row.txt11         :=  x.incoterm;
        v_row.txt12         :=  x.paymant_type;
        v_row.txt13         :=  x.paymant_cond;
        v_row.txt14         :=  x.employee_code;
        v_row.txt15         :=  x.vat_code;
        v_row.txt16         :=  x.description_acrec;
        v_row.txt17         :=  x.client_name;
        v_row.txt18         :=  x.fiscal_code;
        v_row.txt19         :=  x.regist_code;
        v_row.txt20         :=  x.description_destin;
        v_row.txt21         :=  x.nume ||' '||x.prenume;

        IF x.address IS NOT NULL THEN
            v_row.txt22         :=  x.address;
        END IF;
        IF x.city IS NOT NULL THEN
            v_row.txt22         :=  v_row.txt22||', '|| x.city;
        END IF;
        IF x.country_code IS NOT NULL THEN
            v_row.txt22         :=  v_row.txt22||', '|| x.country_code;
        END IF;

        IF x.address_destin IS NOT NULL THEN
            v_row.txt23         :=  x.address_destin;
        END IF;
        IF x.city_destin IS NOT NULL THEN
            v_row.txt23         :=  v_row.txt23||', '|| x.city_destin;
        END IF;
        IF x.country_code_destin IS NOT NULL THEN
            v_row.txt23         :=  v_row.txt23||', '|| x.country_code_destin;
        END IF;
        v_row.txt24         :=  x.note;
        v_row.txt25         :=  x.b_org_name;
        v_row.txt26         :=  x.truck_number;
        v_row.txt27         :=  x.j_org_name;
        v_row.txt28         :=  x.j_fiscal_code;
        v_row.txt29         :=  x.j_regist_code;
        v_row.txt30         :=  x.org_billto;


        v_row.data01        :=  x.acrec_date;
        v_row.data02        :=  x.protocol_date;
        v_row.data03        :=  x.due_date;

        FOR x IN Pkg_Ac_Rec.C_ACREC_DETAIL(v_row.idriga) LOOP
            v_row.numb01    :=  x.line_count;
            v_row.numb02    :=  x.total_value;
            v_row.numb03    :=  x.total_qty;
        END LOOP;




        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 09/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_acrec_header_iud(p_tip VARCHAR2, p_row ACREC_HEADER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in shipment_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               ACREC_HEADER%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Ac_Rec.p_acrec_header_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_acrec_header_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 09/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_acrec_header_blo(p_tip VARCHAR2, p_row IN OUT ACREC_HEADER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    CURSOR C_CHECK_PROTOCOL_CODE  ( p_acrec_year        VARCHAR2,
                                    p_protocol_code     VARCHAR2,
                                    p_ref_acrec         INTEGER
                                  ) IS
            SELECT  COUNT(*)  line_count
            FROM    ACREC_HEADER
            WHERE       acrec_year      =   p_acrec_year
                    AND protocol_code   =   p_protocol_code
                    AND idriga          <>  NVL(p_ref_acrec,-1)
            ;



    C_DOC_TYPE          VARCHAR2(32000) :=  'ACREC';
    C_MOD_COL_I         VARCHAR2(32000) :=  'ACREC_TYPE,'
                                            ||'ORG_CODE,';

    v_mod_col           VARCHAR2(32000);
    v_detail_count      INTEGER;

    v_row_old           ACREC_HEADER%ROWTYPE;

    v_row_cli           ORGANIZATION%ROWTYPE;
    v_row_org           ORGANIZATION%ROWTYPE;
    v_row_thr           ORGANIZATION%ROWTYPE;
    v_row_sac           SETUP_ACREC%ROWTYPE;
    v_row_inc           DELIVERY_CONDITION%ROWTYPE;
    v_row_des           ORGANIZATION_LOC%ROWTYPE;
    v_row_cur           CURRENCY%ROWTYPE;
    v_row_vat           VALUE_AD_TAX%ROWTYPE;
    v_row_usr           APP_USER%ROWTYPE;

    C_ERR_CODE          VARCHAR2(32000)     :=  'ACREC_HEADER';

    v_error             BOOLEAN;

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN

        v_row_org.org_code  :=  p_row.org_code;
        Pkg_Check.p_chk_organization_sbu(v_row_org);

        v_row_cli.org_code  :=  p_row.org_client;
        Pkg_Check.p_chk_organization(v_row_cli);

        v_row_thr.org_code  :=  p_row.org_delivery;
        Pkg_Check.p_chk_organization(v_row_thr);
        --
        v_row_des.org_code  :=  p_row.org_delivery;
        v_row_des.loc_code  :=  p_row.destin_code;
        Pkg_Check.p_chk_organization_loc(v_row_des);
        --
        v_row_sac.acrec_type  :=  p_row.acrec_type;
        Pkg_Check.p_chk_setup_acrec(v_row_sac);
        --
        v_row_cur.currency_code :=  p_row.currency_code;
        Pkg_Check.p_chk_currency(v_row_cur);
        --
        v_row_vat.vat_code      :=  p_row.vat_code;
        Pkg_Check.p_chk_value_ad_tax(v_row_vat);
        --
        v_row_usr.user_code     :=  p_row.employee_code;
        Pkg_Check.p_chk_app_user(v_row_usr);
        --

        IF p_row.incoterm IS NOT NULL THEN
            v_row_inc.deliv_cond_code  :=  p_row.incoterm;
            Pkg_Check.p_chk_delivery_condition(v_row_inc);
        END IF;
        --
        -- the currency code should be the same with the setup currency
        IF p_row.currency_code <> v_row_sac.currency_code THEN
              Pkg_Err.p_set_error_message
              (    p_err_code          => '100',
                   p_err_header        => 'Ati precizat o alta valuta fata '
                                         ||'de valuta setata pentru acest tip '
                                         ||'de factura !!!',
                   p_err_detail        => NULL,
                   p_flag_immediate    => 'N'
              );
        END IF;

        -- the protocol date should not fall in a mount that is closed
        IF p_row.protocol_date IS NOT NULL THEN
            Pkg_Mov.p_check_date_legal(p_row.protocol_date,'Factura vanzare');
        END IF;

        -- check protocol number
        p_row.protocol_code   :=  trim(p_row.protocol_code);
        IF p_row.protocol_code IS NOT NULL THEN
            IF LENGTH(p_row.protocol_code) > 8 THEN
                Pkg_Err.p_set_error_message
                (    p_err_code          => '200',
                     p_err_header        => 'Numarul facturii trebuie sa fie '
                                           ||'de maxim 8 caractere '
                                           ||' !!!',
                     p_err_detail        => NULL,
                     p_flag_immediate    => 'N'
                );
            END IF;
            ---
            FOR x IN  C_CHECK_PROTOCOL_CODE(
                                                p_row.acrec_year    ,
                                                p_row.protocol_code ,
                                                p_row.idriga
                                             )
            LOOP
                   v_detail_count   :=  x.line_count;
            END LOOP;
            --
            IF v_detail_count > 0 THEN
                Pkg_Err.p_set_error_message
                (    p_err_code          => '300',
                     p_err_header        => 'Acest numar de factura, pentru '
                                           ||'acest an exista deja in sistem '
                                           ||' !!!',
                     p_err_detail        => NULL,
                     p_flag_immediate    => 'N'
                );
            END IF;
        END IF;
        -- the due date is specified should be greater than the protocol date
        IF      p_row.due_date IS NOT NULL
            AND p_row.due_date < p_row.protocol_date
        THEN
                Pkg_Err.p_set_error_message
                (    p_err_code          => '400',
                     p_err_header        => 'Data de scadenta a facturii '
                                           ||'trebuie sa fie mai mare decat '
                                           ||'data facturii '
                                           ||' !!!',
                     p_err_detail        => NULL,
                     p_flag_immediate    => 'N'
                );
        END IF;





    END;
    ---------------------------------------------------------------------------
BEGIN

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_row.acrec_date      :=  TRUNC(SYSDATE);
                p_row.acrec_year      :=  TO_CHAR(p_row.acrec_date,'YYYY');
                p_row.acrec_code      :=  Pkg_Env.f_get_app_doc_number
                                             (
                                                 p_org_code     =>   Pkg_Glb.C_MYSELF   ,
                                                 p_doc_type     =>   C_DOC_TYPE         ,
                                                 p_doc_subtype  =>   C_DOC_TYPE         ,
                                                 p_num_year     =>   p_row.acrec_year
                                             );
                 p_row.status           :=  'I';
                 --
                 p_check_integrity();
                 --
        WHEN    'U' THEN
                --
                v_error     :=  FALSE;
                --
                v_row_old.idriga    :=  p_row.idriga;
                IF Pkg_Get.f_get_acrec_header(v_row_old) THEN NULL; END IF;
                v_mod_col   :=  Pkg_Mod_Col.f_acrec_header(v_row_old, p_row);
                -- check if there is detail lines on the receipt
                -- if there are some information not modifyable
                FOR x IN Pkg_Ac_Rec.C_ACREC_DETAIL(p_row.idriga) LOOP
                    v_detail_count :=  x.line_count;
                END LOOP;
                v_detail_count  :=  NVL(v_detail_count,0);

                -- check status of account receivable
                CASE
                        WHEN    v_row_old.status = 'I' THEN
                            ---------
                            IF      v_detail_count > 0
                                AND Pkg_Lib.F_Column_Is_Modif2(C_MOD_COL_I,v_mod_col) = -1
                            THEN
                                Pkg_Err.p_set_error_message
                                (    p_err_code          => C_ERR_CODE ,
                                     p_err_header        => 'Factura are detaliu, '
                                                            ||'nu mai puteti modifica '
                                                            ||'UNELE informatii (tip_factura, gestiune) '
                                                            ||'din antet !!!',
                                     p_err_detail        => NULL,
                                     p_flag_immediate    => 'N'
                                );
                                ---
                                v_error :=  TRUE;
                                ---
                            END IF;
                            ----------
                         WHEN   v_row_old.status    IN  ('C','X') THEN
                               Pkg_Err.p_set_error_message
                               (    p_err_code          => C_ERR_CODE ,
                                    p_err_header        => 'Factura a fost contabilizata / anulata, '
                                                           ||'nu mai puteti modifica informatiile '
                                                           ||'de antet !!!',
                                    p_err_detail        => NULL,
                                    p_flag_immediate    => 'N'
                               );
                                ---
                                v_error :=  TRUE;
                                ---
                END CASE;
                --
                IF NOT v_error THEN
                    p_check_integrity();
                END IF;
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 07/04/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_acrec_detail(p_line_id INTEGER,p_ref_acrec INTEGER DEFAULT NULL)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the ACREC_DETAIL
--              for a receipt identified by ref_receipt
--  PREREQ:
--
--  INPUT:      REF_RECEIPT     =   an integer that is IDRIGA of the receipt
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_line_id INTEGER,p_ref_acrec INTEGER)   IS
                SELECT
                        d.idriga,d.dcn,
                        d.org_code, d.ref_acrec, d.item_code, d.colour_code,
                        d.size_code, d.oper_code_item, d.description_item,
                        d.family_code, d.custom_code, d.uom,
                        d.unit_price, d.qty_doc,d.note,d.routing_code,
                        d.pack_mode, d.package_number, d.weight_net,
                        ---
                        i.description   description_item_join,
                        ---
                        c.description   description_colour,
                        ---
                        v.description   description_custom
                FROM        ACREC_DETAIL        d
                LEFT JOIN   ITEM                i
                                ON  i.item_code     =   d.item_code
                                AND i.org_code      =   d.org_code
                LEFT JOIN   COLOUR              c
                                ON  c.colour_code   =   d.colour_code
                                AND c.org_code      =   d.org_code
                LEFT JOIN   CUSTOM              v
                                ON  v.custom_code   =   d.custom_code
                WHERE       d.ref_acrec     =   p_ref_acrec
                        AND p_line_id       IS  NULL
                ----------
                UNION ALL
                ---------
                SELECT
                        d.idriga,d.dcn,
                        d.org_code, d.ref_acrec, d.item_code, d.colour_code,
                        d.size_code, d.oper_code_item, d.description_item,
                        d.family_code, d.custom_code, d.uom,
                        d.unit_price, d.qty_doc,d.note,d.routing_code,
                        d.pack_mode, d.package_number, d.weight_net,
                        ---
                        i.description   description_item_join,
                        ---
                        c.description   description_colour,
                        ---
                        v.description   description_custom
                FROM        ACREC_DETAIL        d
                LEFT JOIN   ITEM                i
                                ON  i.item_code     =   d.item_code
                                AND i.org_code      =   d.org_code
                LEFT JOIN   COLOUR              c
                                ON  c.colour_code   =   d.colour_code
                                AND c.org_code      =   d.org_code
                LEFT JOIN   CUSTOM              v
                                ON  v.custom_code   =   d.custom_code
                WHERE   d.idriga    =  p_line_id
                ---------------------------
                ORDER BY item_code
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_ref_acrec IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Nu sunteti pozitionat pe o factura valida !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_line_id,p_ref_acrec) LOOP

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.item_code;
        v_row.txt03         :=  x.description_item_join;
        v_row.txt04         :=  x.colour_code;
        v_row.txt05         :=  x.description_colour;
        v_row.txt06         :=  x.size_code;
        v_row.txt07         :=  x.oper_code_item;
        v_row.txt08         :=  x.description_item;
        v_row.txt09         :=  x.family_code;
        v_row.txt10         :=  x.custom_code;
        v_row.txt11         :=  x.description_custom;
        v_row.txt12         :=  x.uom;
        v_row.txt13         :=  x.note;
        v_row.txt14         :=  x.routing_code;
        v_row.txt15         :=  x.pack_mode;

        v_row.numb01        :=  x.ref_acrec;
        v_row.numb02        :=  x.qty_doc;
        v_row.numb03        :=  x.unit_price;
        v_row.numb04        :=  x.package_number;
        v_row.numb05        :=  x.weight_net;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 09/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_acrec_detail_iud(p_tip VARCHAR2, p_row ACREC_DETAIL%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_detail when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               ACREC_DETAIL%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Ac_Rec.p_acrec_detail_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_acrec_detail_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 09/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_acrec_detail_blo( p_tip   VARCHAR2, p_row IN OUT ACREC_DETAIL%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in shipment_detail when is created , updated, deleted
                - fields that must be filed: ITEM_CODE, SEASON_CODE, WHS_CODE
--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    v_row_hed       ACREC_HEADER%ROWTYPE;
    v_row_ssh       SETUP_ACREC%ROWTYPE;
    v_row_old       ACREC_DETAIL%ROWTYPE;

    v_row_itm       ITEM%ROWTYPE;
    v_row_col       COLOUR%ROWTYPE;
    v_row_siz       ITEM_SIZE%ROWTYPE;
    v_row_ope       OPERATION%ROWTYPE;
    v_row_cst       CUSTOM%ROWTYPE;
    v_row_pum       PRIMARY_UOM%ROWTYPE;

    v_t             BOOLEAN;
    v_err           BOOLEAN     :=  FALSE;
    v_mod_col       VARCHAR2(32000);
    C_ERR_CODE      VARCHAR2(32000) :=  'ACREC_DETAIL';
 --   C_MOD_COL       VARCHAR2(32000) :=  'CUSTOM_CODE,ORIGIN_CODE,WEIGHT_NET,WEIGHT_BRUT';

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        IF p_row.item_code IS NOT NULL THEN
            v_row_itm.org_code      :=  p_row.org_code;
            v_row_itm.item_code     :=  p_row.item_code;
            Pkg_Check.p_chk_item(v_row_itm);
        END IF;
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
        p_row.custom_code   :=  NVL(p_row.custom_code,v_row_itm.custom_code);
        --
        IF p_row.custom_code IS NOT NULL THEN
            v_row_cst.custom_code   :=  p_row.custom_code;
            Pkg_Check.p_chk_custom(v_row_cst,p_row.item_code);
        END IF;
        --

        -- get the invoice type
        v_row_ssh.acrec_type  :=  v_row_hed.acrec_type;
        IF  Pkg_Get2.f_get_setup_acrec_2(v_row_ssh) THEN NULL; END IF;
        -- if external I need origin end custom code


        v_t :=      v_row_ssh.extern        =   'Y'
                AND v_row_ssh.ship_material =   'Y'
                AND p_row.custom_code IS NULL   ;
        IF v_t THEN P_Sen('080',
         'Pentru expeditii in extern este obligatoriu codul vamal !!!',
          v_row_itm.item_code
        );END IF;
        --
        p_row.uom  :=  NVL(p_row.uom, v_row_itm.puom);
        --
        v_row_pum.puom   :=  p_row.uom;
        Pkg_Check.p_chk_primary_uom(v_row_pum);
    END;
    ---------------------------------------------------------------------------
BEGIN
    --
    v_t :=  p_row.ref_acrec IS NULL;
    IF v_t THEN P_Sen(C_ERR_CODE,
        'Nu sunteti pozitionat pe o factura valida !!!',
        NULL
        );
        v_err   :=  TRUE;
    END IF;
    --
    v_row_hed.idriga    :=  p_row.ref_acrec;
    v_t :=  NOT Pkg_Get.f_get_acrec_header(v_row_hed);
    IF v_t THEN P_Sen(C_ERR_CODE,
        'Antetul de factura cu identificatorul intern (IDRIGA) :'||v_row_hed.idriga ||' nu exista in baza de date !!!',
        NULL
        );
        v_err   :=  TRUE;
    END IF;
    --
    v_t     :=  v_row_hed.status IN ('F','X');
    IF v_t THEN P_Sen(C_ERR_CODE,
        'Nu puteti modifica factura, aceasta a fost blocata sau anulata  !!!',
        NULL
        );
        v_err   :=  TRUE;
    END IF;
    --
    CASE    p_tip
        WHEN    'I' THEN
                --
                NULL;
                --
        WHEN    'U' THEN
                --
                NULL;
         /*
                -- if regisetered to warehouse only some information can be modified
                -- on detail (weight, origin, custom)
                v_row_old.idriga    :=  p_row.idriga;
                IF Pkg_Get.f_get_receipt_detail(v_row_old) THEN NULL; END IF;
                v_mod_col   :=  Pkg_Mod_Col.f_receipt_detail(v_row_old, p_row);
                IF v_row_hed.status = 'R' THEN
                   IF Pkg_Lib.F_Column_Other_Is_Modif2(C_MOD_COL,v_mod_col) = -1 THEN
                       Pkg_Err.p_set_error_message
                       (    p_err_code          => 'RECEIPT_DETAIL' ,
                            p_err_header        => 'Nu puteti modifica receptia, '
                                                   ||' aceasta a fost inregistrata in magazie !!!',
                            p_err_detail        => NULL,
                            p_flag_immediate    => 'N'
                       );
                   END IF;
                END IF;
                --
        */
        WHEN    'D' THEN
                NULL;
    END CASE;
    --
    IF NOT v_err THEN
        p_check_integrity;
    END IF;
    --
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 10/04/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_setup_acrec  RETURN typ_frm  pipelined
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
                FROM    SETUP_ACREC  h
                ORDER BY h.acrec_type ASC
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
        v_row.txt01         :=  x.acrec_type;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.currency_code;
        v_row.txt04         :=  x.extern;
        v_row.txt05         :=  x.service;
        v_row.txt06         :=  x.type_description;
        v_row.txt07         :=  x.ship_material;
        v_row.txt08         :=  x.report_object;
        v_row.txt09         :=  x.item_description;


        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 11/04/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_price_list_sales(p_line_id INTEGER,p_org_code VARCHAR2 DEFAULT NULL)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the ACREC_DETAIL
--              for a receipt identified by ref_receipt
--  PREREQ:
--
--  INPUT:      REF_RECEIPT     =   an integer that is IDRIGA of the receipt
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_line_id INTEGER,p_org_code VARCHAR2)   IS
                SELECT
                        d.idriga,d.dcn,
                        d.org_code, d.item_code, d.family_code, d.routing_code,
                        d.seq_no, d.date_start, d.date_end, d.unit_price,
                        d.currency_code, d.flag_default, d.note ,
                        ---
                        i.description   i_description,
                        --
                        f.description   f_description,
                        --
                        h.description   h_description
                FROM        PRICE_LIST_SALES    d
                LEFT JOIN   ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT JOIN   SALES_FAMILY        f
                                ON  f.org_code      =   d.org_code
                                AND f.family_code   =   d.family_code
                LEFT JOIN   MACROROUTING_HEADER h
                                ON  h.routing_code  =   d.routing_code
                WHERE       d.org_code      =   p_org_code
                        AND p_line_id       IS  NULL
                ----------
                UNION ALL
                ---------
                SELECT
                        d.idriga,d.dcn,
                        d.org_code, d.item_code, d.family_code, d.routing_code,
                        d.seq_no, d.date_start, d.date_end, d.unit_price,
                        d.currency_code, d.flag_default, d.note  ,
                        ---
                        i.description   i_description,
                        --
                        f.description   f_description,
                        --
                        h.description   h_description
                FROM        PRICE_LIST_SALES    d
                LEFT JOIN   ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT JOIN   SALES_FAMILY        f
                                ON  f.org_code      =   d.org_code
                                AND f.family_code   =   d.family_code
                LEFT JOIN   MACROROUTING_HEADER h
                                ON  h.routing_code  =   d.routing_code
                WHERE   d.idriga    =  p_line_id
                ---------------------------
                ORDER BY item_code,family_code,seq_no
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_org_code IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Nu ati selectat organizatia !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_line_id,p_org_code) LOOP

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.item_code;
        v_row.txt03         :=  x.family_code;
        v_row.txt04         :=  x.routing_code;
        v_row.txt05         :=  x.currency_code;
        v_row.txt06         :=  x.flag_default;
        v_row.txt07         :=  x.note;
        v_row.txt08         :=  x.i_description;
        v_row.txt09         :=  x.f_description;
        v_row.txt10         :=  x.h_description;


        v_row.data01        :=  x.date_start;
        v_row.data02        :=  x.date_end;

        v_row.numb01        :=  x.seq_no;
        v_row.numb02        :=  x.unit_price;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 09/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_price_list_sales_iud(p_tip VARCHAR2, p_row PRICE_LIST_SALES%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_detail when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               PRICE_LIST_SALES%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Ac_Rec.p_price_list_sales_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_price_list_sales_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));

END;
/*********************************************************************************
    DDL: 11/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_price_list_sales_blo(p_tip VARCHAR2, p_row IN OUT PRICE_LIST_SALES%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    C_DOC_TYPE          VARCHAR2(32000) :=  'ACREC';
--    C_CATEGORY_CODE     VARCHAR2(32000) :=  'CTL';
--    C_MOD_COL_1         VARCHAR2(32000) :=  'DOC_NUMBER,DOC_DATE,INCOTERM,CURRENCY_CODE,COUNTRY_FROM,NOTE';
--    C_MOD_COL_2         VARCHAR2(32000) :=  'INCOTERM,COUNTRY_FROM,NOTE';

    v_mod_col           VARCHAR2(32000);

    v_row_old           PRICE_LIST_SALES%ROWTYPE;

    v_row_org           ORGANIZATION%ROWTYPE;
    v_row_cur           CURRENCY%ROWTYPE;
    v_row_itm           ITEM%ROWTYPE;
    v_row_sfm           SALES_FAMILY%ROWTYPE;
    v_row_rot           MACROROUTING_HEADER%ROWTYPE;


    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN

        v_row_org.org_code  :=  p_row.org_code;
        Pkg_Check.p_chk_organization(v_row_org);
        --
        IF p_row.item_code IS NOT NULL THEN
            v_row_itm.org_code  :=  p_row.org_code;
            v_row_itm.item_code  :=  p_row.item_code;
            Pkg_Check.p_chk_item(v_row_itm);
        END IF;
        --
        IF p_row.family_code IS NOT NULL THEN
            v_row_sfm.org_code  :=  p_row.org_code;
            v_row_sfm.family_code  :=  p_row.family_code;
            Pkg_Check.p_chk_sales_family(v_row_sfm);
        END IF;
        --
        IF p_row.routing_code IS NOT NULL THEN
            v_row_rot.routing_code  :=  p_row.routing_code;
            Pkg_Check.p_chk_macrorouting_header(v_row_rot);
        END IF;
        --
        v_row_cur.currency_code :=  p_row.currency_code;
        Pkg_Check.p_chk_currency(v_row_cur);
        --
        IF NVL(p_row.unit_price,0) <= 0  THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '100',
                 p_err_header        => 'Nu ati precizat pretul unitar corect !!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;
        ---
        IF p_row.date_start IS NULL OR p_row.date_end IS NULL THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '200',
                 p_err_header        => 'Nu ati precizat data de inceput/sfarsit '
                                        ||'de valabilitate a pretului !!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;
       --
        IF p_row.date_start > p_row.date_end  THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '300',
                 p_err_header        => 'Data de inceput trebuie sa fie '
                                        ||'mai mica sau egala cu data sfarsit !!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;
        ---
        IF p_row.seq_no IS NULL THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '400',
                 p_err_header        => 'Nu ati precizat numarul de secventa '
                                        ||'a pretului pentru acest cod !!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;
        --
        IF  (p_row.item_code IS NOT NULL AND p_row.family_code IS NOT NULL)
            OR
            (p_row.item_code IS NULL AND p_row.family_code IS NULL)
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '500',
                 p_err_header        => 'Pe o linie trebuie precizat '
                                        ||'ori codul articolului '
                                        ||'ori familia de vanzare !!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;



    END;
    ---------------------------------------------------------------------------
BEGIN

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --

        WHEN    'U' THEN
                --
                p_check_integrity();
                --

                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL:    14/04/2008  z   Create procedure
            05/12/2008  d   restrict list to payable shipments (nature=S)
/*********************************************************************************/
FUNCTION f_sql_pick_acrec(p_ref_acrec INTEGER, p_org_code VARCHAR2)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the ACREC_DETAIL
--              for a receipt identified by ref_receipt
--  PREREQ:
--
--  INPUT:      REF_RECEIPT     =   an integer that is IDRIGA of the receipt
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_org_code VARCHAR2)   IS
                SELECT
                            h.idriga,h.dcn,
                            h.org_code,h.ship_code,h.ship_date,h.ship_type,
                            h.org_client,
                            --
                            s.description,
                            --
                            t.date_legal
                FROM        SHIPMENT_HEADER h
                INNER JOIN  SETUP_SHIPMENT  s
                                ON  s.ship_type     =   h.ship_type
                LEFT JOIN  WHS_TRN         t
                                ON  t.ref_shipment  =   h.idriga
                                AND t.flag_storno   =   'N'
                WHERE       h.status    =   'M'
                        AND h.org_code  =   p_org_code
                        AND s.nature    IN  ('S','R')
                ORDER BY t.date_legal ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF  p_org_code IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Nu sunteti pozitionat pe o organizatie '
                                    ||'valida !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_org_code) LOOP

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.ship_code;
        v_row.txt03         :=  x.ship_type;
        v_row.txt04         :=  x.description;
        v_row.txt05         :=  x.org_client;
        v_row.txt06         :=  'N';

        v_row.data01        :=  x.ship_date;
        v_row.data02        :=  x.date_legal;

        v_row.numb01        :=  p_ref_acrec;
        FOR z IN Pkg_Shipment.C_SHIPMENT_DETAIL(x.idriga) LOOP
            v_row.numb02    :=  z.qty_total;
        END LOOP;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 14/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_acrec_from_picking(p_ref_acrec INTEGER, p_ref_shipment VARCHAR2)
/*----------------------------------------------------------------------------------
--  PURPOSE:    - creates the ACREC_DETAIL lines
                  ---->>>>>>>
                - starts from the shipments specified by p_ref_shipment
                - check if shipment header is in correct state (M)
                - set the new state for shipment header (F)
                - set the ref_acrec
                - load the prices for this org code , this currency valid at
                  the day of the registration of invoice ACREC_DATE
                - load in 2 diferent array, one for the item level and one for the family
                  level price
                - give error message if dublicate price lines are found
                - cycle on the agregate line of shipment detail and look
                        * first for the item level price - if exists create a record
                          for item level
                        * if not exists item level look for family level but agregate
                          for the same family codes !!!!!
                - pass trough the busines logic of ACREC_DETAIL every line created
                - insert the lines created
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------*/
IS
    CURSOR   C_LINES(p_ref_shipment VARCHAR2)    IS
            SELECT  *
            FROM    SHIPMENT_HEADER
            WHERE   idriga  IN  (SELECT TO_NUMBER(txt01)
                                 FROM TABLE(Pkg_Lib.f_sql_inlist(p_ref_shipment)))
            ORDER BY    ship_code
            FOR UPDATE
            ;

    CURSOR  C_ACREC_DETAIL(
                                p_selector      VARCHAR2,
                                p_ref_shipment  VARCHAR2
                          ) IS
            SELECT     d.org_code,d.item_code,
                       NULL colour_code ,
                       NULL size_code   ,
                       i.root_code family_code, w.routing_code,
                       nvl(f.custom_code, s.custom_code) custom_code,
                       MAX(d.uom_shipment)   uom,
                       SUM(d.qty_doc)   qty,
                       d.pack_mode,
                       SUM(d.package_number) package_number,
                       SUM(d.weight_net) weight_net
            -----
            FROM        SHIPMENT_HEADER     h
            INNER JOIN  SHIPMENT_DETAIL     d
                            ON  d.ref_shipment  =   h.idriga
            INNER JOIN  ITEM                i
                            ON  i.org_code      =   d.org_code
                            AND i.item_code     =   d.item_code
            LEFT JOIN SALES_FAMILY          f
                            ON  f.org_code    = i.org_code
                            AND f.family_code = i.root_code
            INNER JOIN  SETUP_SHIPMENT      s
                            ON  s.ship_type     =   h.ship_type
            INNER JOIN  WORK_ORDER          w
                            ON  w.org_code      =   d.org_code
                            AND w.order_code    =   d.order_code
            ---
            WHERE           p_selector  =       'S'
                        AND s.nature    =       'S'     -- sales
                        AND h.idriga  IN  (SELECT TO_NUMBER(txt01)
                                      FROM TABLE(Pkg_Lib.f_sql_inlist(p_ref_shipment)))
            ---
            GROUP BY   d.org_code,d.item_code,i.root_code,w.routing_code,
                       nvl(f.custom_code, s.custom_code), d.pack_mode
            --------------------------------------------------------------
            UNION ALL
            --------------------------------------------------------------
            SELECT      d.org_code,d.item_code,
                        d.colour_code ,
                        d.size_code   ,
                        NULL family_code,
                        NULL routing_code,
                        d.custom_code,
                        d.uom_shipment   uom,
                        SUM(d.qty_doc)   qty,
                        d.pack_mode,
                        SUM(d.package_number) package_number,
                        SUM(d.weight_net) weight_net
            FROM        SHIPMENT_HEADER     h
            INNER JOIN  SHIPMENT_DETAIL     d
                            ON  d.ref_shipment  =   h.idriga
            INNER JOIN  ITEM                i
                            ON  i.org_code      =   d.org_code
                            AND i.item_code     =   d.item_code
            INNER JOIN  SETUP_SHIPMENT      s
                            ON  s.ship_type     =   h.ship_type
            ---
            WHERE           p_selector       =       'T'
                        AND s.nature         IN     ('R')     -- sales
                        AND h.idriga  IN  (SELECT TO_NUMBER(txt01)
                                      FROM TABLE(Pkg_Lib.f_sql_inlist(p_ref_shipment)))
            ---
            GROUP BY   d.org_code, d.item_code, d.colour_code, d.size_code,
                       d.custom_code, d.uom_shipment, d.pack_mode
            ----
            ORDER BY   item_code,colour_code,size_code,family_code,routing_code
            ;


    CURSOR  C_PRICE_LIST_SALES(  p_org_code      VARCHAR2,
                                p_acrec_date    DATE,
                                p_currency_code VARCHAR2) IS
/*            SELECT  *
            FROM    PRICE_LIST_SALES
            WHERE       org_code        =   p_org_code
                    AND p_acrec_date    BETWEEN date_start AND date_end
                    AND currency_code   =   p_currency_code
            ORDER BY item_code,family_code,routing_code,seq_no
            ;*/
            SELECT  c.*, unit_cost unit_price
            FROM    ITEM_COST c
            WHERE       org_code        =   p_org_code
                    AND p_acrec_date    BETWEEN start_date AND nvl(end_date, p_acrec_date + 1)
                    AND currency_code   =   p_currency_code
                    AND c.cost_code = 'MAN_SEL'
            ORDER BY item_code,family_code,routing_code--,seq_no
            ;

   CURSOR   C_PRICE_LIST_TRANSFER(
                                    p_ref_shipment    VARCHAR2
                                 ) IS
            SELECT  d.org_code,d.item_code,d.colour_code,d.size_code,
                    AVG(d.price_doc_puom) unit_price
            FROM            FIFO_MATERIAL   f
            INNER   JOIN    RECEIPT_DETAIL  d
                                ON  f.ref_receipt   =   d.idriga
            WHERE       f.ref_shipment IN   (SELECT TO_NUMBER(txt01)
                                      FROM TABLE(Pkg_Lib.f_sql_inlist(p_ref_shipment)))
            GROUP BY    d.org_code,d.item_code,d.colour_code,d.size_code
            ;



    TYPE    type_it     IS  TABLE OF ACREC_DETAIL%ROWTYPE   INDEX BY Pkg_Glb.type_index;
    it_acrec            type_it;

    v_row_hed           ACREC_HEADER%ROWTYPE;
    v_row               ACREC_DETAIL%ROWTYPE;
    v_row_ini           ACREC_DETAIL%ROWTYPE;
    v_row_sar           SETUP_ACREC%ROWTYPE;
    it_det              Pkg_Rtype.ta_acrec_detail;
    it_hed              Pkg_Rtype.ta_shipment_header;

    v_selector          VARCHAR2(1);

    it_pit              Pkg_Glb.typ_number_varchar;
    it_pfm              Pkg_Glb.typ_number_varchar;
    it_ptr              Pkg_Glb.typ_number_varchar;

    v_idx               Pkg_Glb.type_index;
    v_idx_aux           Pkg_Glb.type_index;

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_acrec IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o factura valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the receit header
    v_row_hed.idriga    :=  p_ref_acrec;
    IF NOT Pkg_Get.f_get_acrec_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Factura cu identificatorul intern '
                                    || p_ref_acrec ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_acrec,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- is not posible to append to a registered receipt
    IF v_row_hed.status <>   'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu mai puteti adauga la aceasta factura, '
                                    ||' aceasta a fost anulata / contabilizata !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    -- get the setup_acrec line
    v_row_sar.acrec_type    :=  v_row_hed.acrec_type;
    IF Pkg_Get2.f_get_setup_acrec_2(v_row_sar) THEN NULL; END IF;

    IF v_row_sar.service = 'Y' THEN
        v_selector  :=  'S' ;
    ELSE
        v_selector  :=  'T' ;
    END IF;

    --

    OPEN    C_LINES(p_ref_shipment);
    FETCH   C_LINES BULK COLLECT INTO it_hed;
    CLOSE   C_LINES;
    ---
    IF it_hed.COUNT = 0  THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu ati ales nici o expeditie, '
                                    ||' de importat !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;

    FOR i IN 1..it_hed.COUNT  LOOP
        IF it_hed(i).status <> 'M' THEN
              Pkg_Err.p_set_error_message
              (    p_err_code          => '100',
                   p_err_header        => 'Urmatoarele expeditii nu sunt in faza '
                                         ||'corecta pentru facturare (trebuie M) !!!',
                   p_err_detail        => it_hed(i).ship_code,
                   p_flag_immediate    => 'N'
              );
        ELSE
            it_hed(i).status    := 'F';
            it_hed(i).ref_acrec :=  p_ref_acrec;
            Pkg_Iud.p_shipment_header_iud('U',it_hed(i));
        END IF;
    END LOOP;
    --
    Pkg_Err.p_raise_error_message();
    --

    IF v_selector   =   'S' THEN
    ----------------------------------------------------------------------------
        FOR x IN C_PRICE_LIST_SALES (   p_org_code      =>  v_row_hed.org_code ,
                                        p_acrec_date    =>  v_row_hed.acrec_date,
                                        p_currency_code =>  v_row_hed.currency_code
                                    )
        LOOP
            IF x.item_code IS NOT NULL THEN
                v_idx   :=  Pkg_Lib.f_str_idx(x.item_code,x.routing_code);
                IF it_pit.EXISTS(v_idx) THEN
                     Pkg_Err.p_set_error_message
                     (    p_err_code          => '200',
                          p_err_header        => 'Pentru urmatoarele articole/routing '
                                                ||'pentru data de '
                                                ||TO_CHAR(v_row_hed.acrec_date,'dd/mm/yyyy')
                                                ||' exista mai multe preturi in vigoare !!!',
                          p_err_detail        => x.item_code||' / '||x.routing_code,
                          p_flag_immediate    => 'N'
                     );
                END IF;
                it_pit(v_idx)   :=  x.unit_price;
            ELSE
                v_idx   :=  Pkg_Lib.f_str_idx(x.family_code,x.routing_code);
                IF it_pfm.EXISTS(v_idx) THEN
                     Pkg_Err.p_set_error_message
                     (    p_err_code          => '300',
                          p_err_header        => 'Pentru urmatoarele familii/routing '
                                                ||'pentru data de '
                                                ||TO_CHAR(v_row_hed.acrec_date,'dd/mm/yyyy')
                                                ||' exista mai multe preturi in vigoare !!!',
                          p_err_detail        => x.family_code||' / '||x.routing_code,
                          p_flag_immediate    => 'N'
                     );
                END IF;
                it_pfm(v_idx)   :=  x.unit_price;
            END IF;
        END LOOP;

        -- cycle on the agregated shipment lines

        FOR x IN C_ACREC_DETAIL(
                                v_selector      ,
                                p_ref_shipment
                                ) LOOP

            v_row       :=  v_row_ini;

            v_row.ref_acrec     :=  v_row_hed.idriga;
            v_row.org_code      :=  v_row_hed.org_code;

            v_idx :=    Pkg_Lib.f_str_idx(x.item_code,x.routing_code);

            --check if there is price on the item level
            IF it_pit.EXISTS(v_idx) THEN

                v_row.item_code     :=  x.item_code;
                v_row.family_code   :=  x.family_code;
                v_row.custom_code   :=  x.custom_code;
                v_row.uom           :=  x.uom;
                v_row.unit_price    :=  it_pit(v_idx);
                v_row.qty_doc       :=  x.qty;
                v_row.routing_code  :=  x.routing_code;
                v_row.pack_mode     :=  NVL(x.pack_mode, 'COLET');
                v_row.package_number:=  x.package_number;
                v_row.weight_net    :=  x.weight_net; 

                v_idx_aux   :=  Pkg_Lib.f_str_idx(
                                                  x.item_code   ,
                                                  x.family_code ,
                                                  x.custom_code ,
                                                  x.routing_code
                                                  );
                it_acrec(v_idx_aux) :=  v_row;
            END IF;
            --
            IF v_row.unit_price IS NULL THEN

                v_idx :=    Pkg_Lib.f_str_idx(x.family_code,x.routing_code);

                IF it_pfm.EXISTS(v_idx) THEN
                    v_idx_aux   :=  Pkg_Lib.f_str_idx(
                                                      NULL              , -- no item
                                                      x.family_code ,
                                                      x.custom_code ,
                                                      x.routing_code
                                                      );
                    ---
                    v_row.unit_price    :=  it_pfm(v_idx);
                    ---
                    IF it_acrec.EXISTS(v_idx_aux) THEN
                        it_acrec(v_idx_aux).qty_doc :=  it_acrec(v_idx_aux).qty_doc
                                                        + x.qty;
                        it_acrec(v_idx_aux).package_number := NVL(it_acrec(v_idx_aux).package_number, 0) 
                                                        + x.package_number;

                    ELSE
                        v_row.item_code     :=  NULL;
                        v_row.family_code   :=  x.family_code;
                        v_row.custom_code   :=  x.custom_code;
                        v_row.uom           :=  x.uom;
                        v_row.qty_doc       :=  x.qty;
                        v_row.routing_code  :=  x.routing_code;
                        v_row.pack_mode     :=  NVL(x.pack_mode, 'COLET');
                        v_row.package_number:=  x.package_number;
                        v_row.weight_net    :=  x.weight_net; 

                        it_acrec(v_idx_aux) :=  v_row;

                    END IF;
                END IF;
            END IF;

            --
            IF v_row.unit_price IS NULL THEN
                 Pkg_Err.p_set_error_message
                 (    p_err_code          => '400',
                      p_err_header        => 'Pentru urmatoarele articole/familii/routing '
                                            ||'pentru data de '
                                            ||TO_CHAR(v_row_hed.acrec_date,'dd/mm/yyyy')
                                            ||' NU exista preturi in vigoare !!!',
                      p_err_detail        => x.item_code
                                            ||' / '||x.family_code
                                            ||' / '||x.routing_code,
                      p_flag_immediate    => 'N'
                 );
            END IF;
        END LOOP;
        --
        Pkg_Err.p_raise_error_message();

    ELSE -- transfer

        FOR x IN C_PRICE_LIST_TRANSFER(p_ref_shipment) LOOP
                v_idx_aux   :=  Pkg_Lib.f_str_idx(
                                                  x.org_code   ,
                                                  x.item_code ,
                                                  x.colour_code ,
                                                  x.size_code
                                                  );

                it_ptr(v_idx_aux)   := x.unit_price;
        END LOOP;

        -- cycle on the agregated shipment lines

        FOR x IN C_ACREC_DETAIL(
                                v_selector      ,
                                p_ref_shipment
                                ) LOOP

            v_row       :=  v_row_ini;

            v_row.ref_acrec     :=  v_row_hed.idriga;
            v_row.org_code      :=  x.org_code;
            v_row.item_code     :=  x.item_code;
            v_row.colour_code   :=  x.colour_code;
            v_row.size_code     :=  x.size_code;
            v_row.custom_code   :=  x.custom_code;
            v_row.uom           :=  x.uom;
            v_row.qty_doc       :=  x.qty;
            v_row.pack_mode     :=  NVL(x.pack_mode, 'COLET');
            v_row.package_number:=  x.package_number;
            v_row.weight_net    :=  x.weight_net; 

            v_idx_aux   :=  Pkg_Lib.f_str_idx(
                                              x.org_code   ,
                                              x.item_code ,
                                              x.colour_code ,
                                              x.size_code
                                              );
            v_row.unit_price    := 0;
            IF it_ptr.EXISTS(v_idx_aux) THEN
                v_row.unit_price    :=  it_ptr(v_idx_aux);
            END IF;
            -- could be the same value but different custom codes !!!!!!!!!!
            -- we need to adjust this aggain later !!!!!!!!!!!!!!!!
            v_idx_aux   :=  v_idx_aux ||'^'||C_ACREC_DETAIL%rowcount;

            it_acrec(v_idx_aux) :=  v_row;
        END LOOP;
    END IF;

    --
    v_idx_aux   :=  it_acrec.FIRST;
    WHILE v_idx_aux IS NOT NULL LOOP
        it_det(it_det.COUNT+1)  :=  it_acrec(v_idx_aux);
        -- pass trough the bussines logic of the ACREC_DETAIL
        Pkg_Ac_Rec.p_acrec_detail_blo('I',it_det(it_det.COUNT));
        v_idx_aux   :=  it_acrec.NEXT(v_idx_aux);
    END LOOP;
    --
    Pkg_Err.p_raise_error_message();

    -- create the detail lines
    Pkg_Iud.p_acrec_detail_miud('I',it_det);
    --

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


PROCEDURE p_acrec_print_02 (p_ref_acrec INTEGER, p_lang_code varchar2)
IS

BEGIN

    delete from vw_rep_acrec_invoice_02_h;
    delete from vw_rep_acrec_invoice_02_d;
    
    insert into vw_rep_acrec_invoice_02_h 
    (
        ref_acrec, acrec_type, protocol_code, protocol_date, incoterm, incoterm_description, due_date, vat_code, truck_number, 
        currency_code, exchange_rate, note,
        --
        client_code, client_name, client_address, client_bank, client_bank_acc, client_city, client_country,
        client_phone, client_fax, client_fiscal_code, client_note, client_regist_code,
        destin_name, destin_address, destin_city, destin_country,
        destin_phone, destin_fax, destin_fiscal_code, destin_note, destin_regist_code,
        my_code, my_name, my_address, my_bank, my_bank_acc, my_city, my_country,
        my_phone, my_fax, my_fiscal_code, my_note, my_regist_code,
        segment_code 
    )
    select ah.idriga ref_acrec, ah.acrec_type, ah.protocol_code, ah.protocol_date, ah.incoterm, inc.description incoterm_description, 
        ah.due_date, ah.vat_code, ah.truck_number, ah.currency_code, cr.exchange_rate, ah.note,
        -- client
        os.org_code client_code, os.org_name client_name, os.address client_address, os.bank client_bank, os.bank_account client_bank_acc, 
        os.city client_city, nvl(ccy.description, os.country_code) client_country, os.phone client_phone, os.fax client_fax, 
        os.fiscal_code client_fiscal_code, os.note client_note, os.regist_code client_regist_code,
        -- destination
        od.org_name destin_name, nvl(odl.address, od.address) destin_address, 
        od.city destin_city, nvl(dcy.description, od.country_code) destin_country, 
        nvl(odl.phone, od.phone) destin_phone, nvl(odl.fax, od.fax) destin_fax, od.fiscal_code destin_fical_code, 
        od.note destin_note, od.regist_code destin_regist_code,
        -- myself
        my.org_code my_code, my.org_name my_name, my.address my_address, my.bank my_bank, my.bank_account my_bank_acc, 
        my.city my_city, nvl(mcy.description, my.country_code) my_country, my.phone my_phone, my.fax my_fax, 
        my.fiscal_code my_fiscal_code, my.note my_note, my.regist_code my_regist_code,
        'VW_REP_ACREC_INVOICE_02_H' segment_code
    from acrec_header ah
    inner join organization os on os.org_code = ah.org_client
    inner join organization od on od.org_code = ah.org_delivery
    left join organization_loc odl on odl.org_code = ah.org_delivery and odl.loc_code = ah.destin_code
    left join delivery_condition inc on inc.deliv_cond_code = ah.incoterm 
    cross join organization my 
    left join country mcy on mcy.country_code = my.country_code
    left join country dcy on dcy.country_code = od.country_code
    left join country ccy on ccy.country_code = os.country_code
    left join currency_rate cr on cr.calendar_day = ah.protocol_date and cr.currency_from = ah.currency_code and cr.currency_to = 'RON'
    where my.flag_myself = 'Y'
        and ah.idriga = p_ref_acrec;

    insert into vw_rep_acrec_invoice_02_d
    (
        org_code, ref_acrec,
        custom_code, custom_description,
        uom, unit_price, qty_doc, tot_amount, 
        tot_weight, tot_packages, pack_mode, pack_mode_desc, 
        suppl_code, suppl_name, receipt_type, doc_number, doc_date, fifo_price, 
        inv_tot_amount, inv_tot_weight, inv_tot_packages, inv_qty_doc, 
        service_description,
        rn, segment_code
    )
        select 
            ar.org_code, ar.ref_acrec,
            -- FG grouped on custom code
            ar.custom_code, 
            ar.custom_description,
            ar.uom, ar.unit_price, ar.qty_doc, ar.tot_amount, 
            ar.tot_weight, ar.tot_packages, ar.pack_mode, pm.description,
            -- receipt materials included
            suppl_code, suppl_name, fi.receipt_type, fi.doc_number, fi.doc_date, fi.fifo_price, 
            ar.inv_tot_amount, ar.inv_tot_weight, ar.inv_tot_packages, ar.inv_qty_doc,
            case when acrec_type = 'CTL' then (case when p_lang_code = 'IT' then 'manodopera' else 'manopera' end) end service_description,
            ar.rn, 'VW_REP_ACREC_INVOICE_02_D' segment_code
        from
            (
            select ar.*, 
                sum(tot_amount) over (partition by ref_acrec) inv_tot_amount,
                sum(tot_weight) over (partition by ref_acrec) inv_tot_weight,
                sum(tot_packages) over (partition by ref_acrec) inv_tot_packages,
                sum(qty_doc) over (partition by ref_acrec) inv_qty_doc,
                row_number() over(partition by ref_acrec, custom_code order by pack_mode) rn
            from
            (
                select ah.org_code, ad.ref_acrec, 
                    NVL(CASE WHEN p_lang_code = 'IT' THEN nvl(c.description_it, ad.custom_code) else ad.custom_code END, '???') custom_code, 
                    max(case when p_lang_code = 'IT' then nvl(c.description_It, c.description) else c.description end) custom_description,
                    max(ah.protocol_code) invoice_code,
                    max(ah.protocol_date) invoice_date,
                    max(nvl(c.SUPL_UM, ad.uom)) uom,
                    avg(ad.unit_price) unit_price, sum(ad.qty_doc) qty_doc, 
                    sum(ad.unit_price * ad.qty_doc) tot_amount,
                    round(sum(nvl(ad.weight_net, ad.qty_doc * sf.weight_net))) tot_weight,
                    ad.pack_mode,
                    sum(ad.package_number) tot_packages,
                    max(ah.currency_code) currency_code, max(cr.exchange_rate) exchange_rate,
                    max(acrec_type) acrec_type
                from acrec_detail ad
                inner join acrec_header ah on ah.idriga = ad.ref_acrec
                left join item it on it.org_code = ad.org_code and it.item_code = ad.item_code
                left join sales_family sf on sf.org_code = ad.org_code and sf.family_code = nvl(ad.family_code, it.root_code)
                left join currency_rate cr on cr.calendar_day = ah.protocol_date and cr.currency_from = ah.currency_code and cr.currency_to = 'RON'
                left join custom c on c.custom_code = ad.custom_code
                where ah.idriga = p_ref_acrec
                group by 
                    ah.org_code, 
                    ad.ref_acrec, 
                    NVL(CASE WHEN p_lang_code = 'IT' THEN nvl(c.description_it, ad.custom_code) else ad.custom_code END, '???'), 
                    ad.pack_mode
                ) ar
            )ar
        left join
            (
            select ref_acrec, 
                NVL(CASE WHEN p_lang_code = 'IT' THEN c.description_it else ship_subcat END, '???') custom_code, 
                max(suppl_code) suppl_code, max(suppl_name) suppl_name,
                receipt_type, max(doc_number) doc_number, max(doc_date) doc_date,
                trunc(sum(fifo_price), 2) fifo_price
            from VW_REP_SHIP_FIFO f
            left join custom c on c.custom_code = f.custom_code
            group by 
                ref_acrec, 
                receipt_type, 
                receipt_code, 
                NVL(CASE WHEN p_lang_code = 'IT' THEN c.description_it else ship_subcat END, '???')
            ) fi 
            on fi.ref_acrec = ar.ref_acrec and fi.custom_code = ar.custom_code and ar.rn = 1
        left join multi_table pm on pm.table_name = 'SHIP_PACK_MODE' 
                                and pm.table_key = ar.pack_mode || (CASE WHEN p_lang_code <> 'RO' THEN '_'||p_lang_code END) 
        ;


END;


/*********************************************************************************
    DDL: 15/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_acrec_print(p_ref_acrec INTEGER)
/*----------------------------------------------------------------------------------
--  PURPOSE:    -


--  PREREQ:



--  INPUT:
----------------------------------------------------------------------------------*/
IS
    CURSOR   C_LINES(p_ref_acrec INTEGER, p_currency_to VARCHAR2)    IS
            SELECT
                        h.*,
                        ---
                        d.item_code, d.colour_code, d.size_code, d.oper_code_item,
                        d.description_item, d.family_code, d.custom_code, d.uom,
                        d.unit_price, d.qty_doc, d.routing_code   ,
                        --
                        o.org_name, o.country_code o_country_code, o.city o_city,
                        o.address o_address, o.bank,
                        o.bank_account, o.fiscal_code, o.regist_code,
                        --
                        l.description l_description, l.country_code l_country_code,
                        l.city l_city,l.address l_address,
                        --
                        c.description   c_description,
                        --
                        u.nume, u.prenume,
                        --
                        s.description s_description, s.extern, s.service,
                        s.type_description, s.item_description,
                        --
                        r.exchange_rate,
                        --
                        i.description   i_description,
                        --
                        b.org_name b_org_name, b.country_code b_country_code, b.city b_city,
                        b.address b_address, b.bank b_bank,
                        b.bank_account b_bank_account, b.fiscal_code b_fiscal_code,
                        b.regist_code b_regist_code,
                        --
                        z1.description  z1_description,
                        z2.description  z2_description,
                        z3.description  z3_description,
                        --
                        m.description   m_description
            FROM        ACREC_HEADER        h
            INNER JOIN  SETUP_ACREC         s
                            ON  s.acrec_type    =   h.acrec_type
            INNER JOIN  ACREC_DETAIL        d
                            ON  d.ref_acrec     =   h.idriga
            INNER JOIN  ORGANIZATION        o
                            ON  o.org_code      =   h.org_client
            INNER JOIN  ORGANIZATION        b
                            ON  b.org_code      =   h.org_billto
            INNER JOIN  ORGANIZATION_LOC    l
                            ON  l.org_code      =   h.org_delivery
                            AND l.loc_code      =   h.destin_code
            LEFT  JOIN  ITEM                i
                            ON  i.org_code      =   d.org_code
                            AND i.item_code     =   d.item_code
            LEFT  JOIN  COLOUR              m
                            ON  m.org_code      =   d.org_code
                            AND m.colour_code   =   d.colour_code
            LEFT  JOIN  CUSTOM              c
                            ON c.custom_code    =   d.custom_code
            LEFT JOIN   CURRENCY_RATE       r
                            ON  r.calendar_day  =   h.protocol_date
                            AND r.currency_from =   h.currency_code
                            AND r.currency_to   =   p_currency_to
            LEFT JOIN   COUNTRY             z1
                            ON  z1.country_code =   o.country_code
            LEFT JOIN   COUNTRY             z2
                            ON  z2.country_code =   l.country_code
            LEFT JOIN   COUNTRY             z3
                            ON  z3.country_code =   b.country_code
            LEFT JOIN   APP_USER            u
                            ON u.user_code      =   h.employee_code
            WHERE       h.idriga    =   p_ref_acrec
            ORDER BY d.item_code,d.family_code
            ;

      CURSOR    C_MATERIAL_VALUE (p_ref_acrec INTEGER, p_currency_from VARCHAR2) IS
                  SELECT        NVL(s.custom_code,Pkg_Glb.C_RN) custom_code ,
                                r.suppl_code,o.org_name,
                                d.org_code,
                                d.item_code,
                                t.property,r.currency_code,
                                z.qty,
                                d.price_doc_puom,
                                w.date_legal,
                                c.exchange_rate
                  FROM          SHIPMENT_HEADER     h
                  INNER JOIN    SETUP_SHIPMENT      s
                                    ON s.ship_type      =   h.ship_type
                  INNER JOIN    FIFO_MATERIAL       z
                                    ON  z.ref_shipment  =   h.idriga
                  INNER JOIN    RECEIPT_DETAIL      d
                                    ON  d.idriga        =   z.ref_receipt
                  INNER JOIN    RECEIPT_HEADER      r
                                    ON  r.idriga        =   d.ref_receipt
                  INNER JOIN    SETUP_RECEIPT       t
                                    ON t.receipt_type   =   r.receipt_type
                  INNER JOIN    ORGANIZATION        o
                                    ON o.org_code       =   r.suppl_code
                  INNER JOIN    WHS_TRN             w
                                    ON w.ref_receipt    =   r.idriga
                  LEFT  JOIN    CURRENCY_RATE       c
                                    ON  c.calendar_day  =   w.date_legal
                                    AND c.currency_to   =   r.currency_code
                                    AND c.currency_from =   p_currency_from
                  WHERE         h.ref_acrec     =   p_ref_acrec
                            AND t.property      =   'N'     -- only client material
                            AND w.flag_storno   =   'N'
                  ;

    CURSOR    C_MATERIAL_VALUE_AUX IS
                SELECT  custom_code,property,suppl_code,
                        MAX(org_name)       org_name,
                        SUM(value_line_eur) value_line_eur
                FROM    VW_PREP_ACREC_MAT_VALUE
                GROUP BY custom_code,property,suppl_code
                ORDER BY custom_code,property,suppl_code
                ;



    CURSOR  C_SHIPMENT_HEADER(p_ref_acrec   INTEGER)    IS
                SELECT      NVL(s.custom_code,Pkg_Glb.C_RN) custom_code ,
                            h.*
                FROM        SHIPMENT_HEADER     h
                INNER JOIN  SETUP_SHIPMENT      s
                                ON  s.ship_type     =   h.ship_type
                WHERE       h.ref_acrec =   p_ref_acrec
                ;


    TYPE    type_it1        IS TABLE OF C_LINES%ROWTYPE INDEX BY BINARY_INTEGER;
    it1                     type_it1;
    x                       C_LINES%ROWTYPE;
    TYPE    type_it2        IS TABLE OF  VW_ACREC_PRINT%ROWTYPE INDEX BY BINARY_INTEGER;
    it2                     type_it2;
    v_idx                   PLS_INTEGER :=  0;
    TYPE    type_it3        IS TABLE OF  C_SHIPMENT_HEADER%ROWTYPE INDEX BY BINARY_INTEGER;
    it3                     type_it3;

    it_mvp                  Pkg_Glb.typ_number_varchar;
    it_mvc                  Pkg_Glb.typ_number_varchar;
    it_mvs                  Pkg_Glb.typ_number_varchar;
    it_spl                  Pkg_Glb.typ_varchar_varchar;

    v_row                   VW_ACREC_PRINT%ROWTYPE;
    v_row_org               ORGANIZATION%ROWTYPE;
    v_row_hed               ACREC_HEADER%ROWTYPE;
    v_inv_total             NUMBER;
    v_value_mat_property    NUMBER;
    v_value_mat_client      NUMBER;
    v_weight_brut           NUMBER;
    v_weight_net            NUMBER;
    v_package_number        NUMBER;
    it_wnt                  Pkg_Glb.typ_number_varchar;
    v_str_idx               Pkg_Glb.type_index;
    v_custom_code           Pkg_Glb.type_index;
    v_description           VARCHAR2(32000);

    C_SEGMENT_CODE          VARCHAR2(32000) :=  'VW_ACREC_PRINT';
    C_CURRENCY_RON          VARCHAR2(32000) :=  'RON';
    C_ITEM_DESCRIPTION      VARCHAR2(32000) :=  'Manopera produs . ';
    C_INDENT                INTEGER         :=  20;

    -----------------------------------------------------------------------------------------
    PROCEDURE p_organization_data(  p_org_identification IN OUT VARCHAR2,
                                    p_name          VARCHAR2,
                                    p_regist_code   VARCHAR2,
                                    p_address       VARCHAR2,
                                    p_city          VARCHAR2,
                                    p_country       VARCHAR2,
                                    p_bank_account  VARCHAR2,
                                    p_bank          VARCHAR2,
                                    p_phone         VARCHAR2,
                                    p_fax           VARCHAR2,
                                    p_email         VARCHAR2,
                                    p_fiscal_code   VARCHAR2
                                 )
    IS
        C_INDENT        INTEGER :=  10;
    BEGIN
        p_org_identification     :=  p_name;
        Pkg_Lib.p_nl(p_org_identification,2);
        IF p_regist_code IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD('Nr.ord.reg.com :',C_INDENT)
                                        || p_regist_code;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;
        IF p_address IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD('Sediul :',C_INDENT)
                                        || p_address;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;
        IF p_city IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD(' ',C_INDENT)
                                        || p_city;
            IF p_country IS NOT NULL THEN
                p_org_identification     :=  p_org_identification
                                            ||', '||p_country;
            END IF;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;
        IF p_bank_account IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD('Cod IBAN:',C_INDENT)
                                        || p_bank_account
                                        ;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;

        IF p_bank IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD('Banca:',C_INDENT)
                                        || p_bank
                                        ;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;
        IF p_phone IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD('Tel:',C_INDENT)
                                        || p_phone
                                        ;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;
        IF p_fax IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD('Fax:',C_INDENT)
                                        || p_fax
                                        ;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;
        IF p_email IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD('Email:',C_INDENT)
                                        || p_email
                                        ;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;
        IF p_fiscal_code IS NOT NULL THEN
            p_org_identification     :=  p_org_identification
                                        ||RPAD('Cod TVA intracom.:',C_INDENT)
                                        || p_fiscal_code
                                        ;
            Pkg_Lib.p_nl(p_org_identification);
        END IF;
    END;
    -----------------------------------------------------------------------------------------
    PROCEDURE p_prep_acrec_material_value
    IS
        PRAGMA autonomous_transaction;
        v_row               VW_PREP_ACREC_MAT_VALUE%ROWTYPE;
        C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_PREP_ACREC_MAT_VALUE';
        C_CURRENCY_CODE     VARCHAR2(32000)     :=  'EUR,RON';
        C_CURRENCY_EUR      VARCHAR2(32000)     :=  'EUR';
        C_CURRENCY_RON      VARCHAR2(32000)     :=  'RON';

    BEGIN
        DELETE FROM VW_PREP_ACREC_MAT_VALUE;
        FOR x IN C_MATERIAL_VALUE (p_ref_acrec,C_CURRENCY_EUR) LOOP

            v_row.segment_code          :=  C_SEGMENT_CODE;
            v_row.custom_code           :=  x.custom_code;
            v_row.suppl_code            :=  x.suppl_code;
            v_row.org_name              :=  x.org_name;
            v_row.org_code              :=  x.org_code;
            v_row.item_code             :=  x.item_code;
            v_row.property              :=  x.property;
            v_row.currency_code         :=  x.currency_code;
            v_row.qty                   :=  x.qty;
            v_row.price_doc_puom        :=  x.price_doc_puom;
            v_row.date_legal            :=  x.date_legal;
            v_row.exchange_rate         :=  NVL(x.exchange_rate,0);

            IF Pkg_Lib.f_instr(C_CURRENCY_CODE,v_row.currency_code) = 0 THEN
                Pkg_Err.p_set_error_message
                (    p_err_code          => 'ACREC_PRINT_01',
                     p_err_header        => 'Exista receptii care au alta valuta '
                                            ||'decate EUR si RON  !!!',
                     p_err_detail        => x.suppl_code
                                            ||' - '
                                            ||TO_CHAR(x.date_legal,'DD/MM/YY'),
                     p_flag_immediate    => 'N'
                );
            END IF;
            --
            IF  v_row.currency_code =  C_CURRENCY_RON THEN
                IF v_row.exchange_rate = 0 THEN
                     Pkg_Err.p_set_error_message
                     (    p_err_code          => TO_CHAR(x.date_legal,'YYYYMMDD'),
                          p_err_header        => 'Transf. valoare materiale in EUR. '
                                                 ||'Nu exista curs de schimb valutar '
                                                 ||'intre EUR si RON  pentru data: '
                                                 ||TO_CHAR(x.date_legal,'DD/MM/YY')
                                                 ||'  !!!',
                          p_err_detail        => NULL,
                          p_flag_immediate    => 'N'
                     );
                ELSE
                    v_row.price_doc_puom    :=  v_row.price_doc_puom / v_row.exchange_rate ;
                END IF;
            END IF;
            --
            v_row.value_line_eur    :=   v_row.qty * v_row.price_doc_puom;
            --
            INSERT INTO VW_PREP_ACREC_MAT_VALUE VALUES v_row;
        END LOOP;
        COMMIT;
    END;


BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_acrec IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o factura valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the invoice header
    v_row_hed.idriga    :=  p_ref_acrec;
    IF NOT Pkg_Get.f_get_acrec_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Factura cu identificatorul intern '
                                    || p_ref_acrec ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_acrec,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    IF v_row_hed.status = 'X' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Factura a fost anulata TOTAL '
                                    ||' nu se mai poate vizualiza !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check if protocol number/date is filled
    IF      v_row_hed.protocol_code     IS NULL
        OR  v_row_hed.protocol_date     IS NULL
    THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Factura nu are numar / data '
                                    ||' !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --- get the lines of the invoice with the aditional join informations
    OPEN    C_LINES(p_ref_acrec, C_CURRENCY_RON);
    FETCH   C_LINES BULK COLLECT INTO it1;
    CLOSE   C_LINES;
    --
    IF it1.COUNT = 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Factura nu are nici o linie de  '
                                    ||'detaliu !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the shipment lines associated
    OPEN    C_SHIPMENT_HEADER(p_ref_acrec);
    FETCH   C_SHIPMENT_HEADER BULK COLLECT INTO it3;
    CLOSE   C_SHIPMENT_HEADER;
    -- make checks on the shipment lines
    v_weight_brut       :=  0;
    v_weight_net        :=  0;
    v_package_number    :=  0;
    --
    FOR i IN 1..it3.COUNT LOOP
        v_weight_brut       :=  v_weight_brut       +   it3(i).weight_brut;
        v_weight_net        :=  v_weight_net        +   it3(i).weight_net;
        v_package_number    :=  v_package_number    +   it3(i).package_number;

        v_custom_code       :=  it3(i).custom_code;
        IF it_wnt.EXISTS(v_custom_code) THEN
            it_wnt(v_custom_code)  :=  it_wnt(v_custom_code) +  it3(i).weight_net;
        ELSE
            it_wnt(v_custom_code)  :=  it3(i).weight_net;
        END IF;
    END LOOP;

    -- get the first line to have access to the comon information
    x :=  it1(1);
    --get the information for myself
    v_row_org.org_code  :=  Pkg_Glb.C_MYSELF ;
    IF Pkg_Get2.f_get_organization_2(v_row_org) THEN NULL; END IF;
     -- meke setup for constant information
    v_row.segment_code              :=  C_SEGMENT_CODE;
    v_row.myself_name               :=  v_row_org.org_name;
    v_row.document_name             :=  x.type_description;
    --
    v_row.document_identification   :=     'Nr.        '|| x.protocol_code;
    Pkg_Lib.p_nl(v_row.document_identification);
    v_row.document_identification   :=  v_row.document_identification
                                        || 'Doc date.  '
                                        || TO_CHAR(x.protocol_date,'DD/MM/YY');

    IF      x.service   = 'Y'
    THEN
        IF x.due_date IS NULL THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => '00',
                  p_err_header        => 'Factura nu are precizata '
                                        ||'data de scadenta !!!',
                  p_err_detail        => NULL,
                  p_flag_immediate    => 'Y'
             );
        END IF;
        Pkg_Lib.p_nl(v_row.document_identification);
        v_row.document_identification   :=  v_row.document_identification
                                        || 'Due date.  '
                                        || TO_CHAR(x.due_date,'DD/MM/YY');
    END IF;



     -- identificatio for myself
     p_organization_data(
                                    v_row.myself_identification,
                                    p_name          => v_row_org.org_name     ,
                                    p_regist_code   => v_row_org.regist_code  ,
                                    p_address       => v_row_org.address      ,
                                    p_city          => v_row_org.city         ,
                                    p_country       => 'ROMANIA'              ,
                                    p_bank_account  => v_row_org.bank_account ,
                                    p_bank          => v_row_org.bank         ,
                                    p_phone         => v_row_org.phone        ,
                                    p_fax           => v_row_org.fax          ,
                                    p_email         => v_row_org.email        ,
                                    p_fiscal_code   => v_row_org.fiscal_code
                         );

     -- client information
     p_organization_data(
                                    v_row.client_identification,
                                    p_name          => x.b_org_name     ,
                                    p_regist_code   => x.b_regist_code  ,
                                    p_address       => x.b_address      ,
                                    p_city          => x.b_city         ,
                                    p_country       => x.z3_description             ,
                                    p_bank_account  => x.b_bank_account ,
                                    p_bank          => x.b_bank         ,
                                    p_phone         => NULL        ,
                                    p_fax           => NULL          ,
                                    p_email         => NULL        ,
                                    p_fiscal_code   => x.b_fiscal_code
                         );

    -- delivery identification
     p_organization_data(
                                    v_row.delivery_identification,
                                    p_name          => x.l_description     ,
                                    p_regist_code   => NULL  ,
                                    p_address       => x.l_address      ,
                                    p_city          => x.l_city         ,
                                    p_country       => x.z2_description             ,
                                    p_bank_account  => NULL ,
                                    p_bank          => NULL         ,
                                    p_phone         => NULL        ,
                                    p_fax           => NULL          ,
                                    p_email         => NULL        ,
                                    p_fiscal_code   => x.fiscal_code
                         );


     -- other header information
     v_row.header_information        :=   'Incoterm     :     '
                                        || x.incoterm ;
     Pkg_Lib.p_nl(v_row.header_information);
     v_row.header_information        := v_row.header_information
                                        ||'Truck number :     '
                                        || x.truck_number ;

     --
     v_row.currency_code            :=  x.currency_code;
     v_row.exchange_rate            :=  x.exchange_rate;
     v_row.employee_name            :=  x.nume || ' '||x.prenume;
     -- load material value
     v_value_mat_property  :=  0;
     v_value_mat_client    :=  0;
     ---
     p_prep_acrec_material_value();
     Pkg_Err.p_raise_error_message();
     ----
     FOR x IN C_MATERIAL_VALUE_AUX LOOP
        x.value_line_eur    :=  ROUND(x.value_line_eur,2);
        --
        IF x.property   =   'Y' THEN
            IF it_mvp.EXISTS(x.custom_code) THEN
                it_mvp(x.custom_code)   :=  it_mvp(x.custom_code) + x.value_line_eur;
            ELSE
                it_mvp(x.custom_code)   :=  x.value_line_eur;
            END IF;
            ---
            v_value_mat_property    := v_value_mat_property + x.value_line_eur;
        ELSE
            IF it_mvc.EXISTS(x.custom_code) THEN
                it_mvc(x.custom_code)   :=  it_mvc(x.custom_code) + x.value_line_eur;
            ELSE
                it_mvc(x.custom_code)   :=  x.value_line_eur;
            END IF;
            ---
            v_value_mat_client      := v_value_mat_client + x.value_line_eur ;
        END IF;

        IF it_mvs.EXISTS(x.suppl_code) THEN
            it_mvs(x.suppl_code)   :=  it_mvs(x.suppl_code) + x.value_line_eur;
        ELSE
            it_mvs(x.suppl_code)    :=  x.value_line_eur;
            it_spl(x.suppl_code)    :=  x.org_name;
        END IF;
     END LOOP;
     --
     -- gather line level information
     v_inv_total    := 0;
     FOR i IN 1..it1.COUNT LOOP

         x  :=  it1(i);

         v_idx                            :=     v_idx   + 1;
         it2(v_idx)                       :=     v_row;
         it2(v_idx).line_order            :=     i;

         it2(v_idx).description           :=     NVL(x.item_code,x.family_code);
         it2(v_idx).description           :=     NVL(it2(v_idx).description,x.description_item);

         v_description                    :=     NVL(x.item_description,x.i_description);
         IF     v_description   IS NOT NULL
            AND x.m_description IS NOT NULL
         THEN
                v_description   :=  v_description;-- ||'-'||x.m_description;
         END IF;
         --
         IF v_description IS NOT NULL THEN
            it2(v_idx).description        :=    v_description
                                                ||' - '
                                                ||it2(v_idx).description ;
         END IF;

         it2(v_idx).um                    :=     x.uom;
         it2(v_idx).custom_code           :=     x.custom_code;
         it2(v_idx).quantity              :=     x.qty_doc;
         it2(v_idx).unit_price            :=     x.unit_price;
         it2(v_idx).total_value           :=     it2(v_idx).quantity
                                                 * it2(v_idx).unit_price;
         it2(v_idx).total_value           :=     ROUND(it2(v_idx).total_value,2);
         it2(v_idx).material_value        :=     0;
         it2(v_idx).vat_percent           :=     0;

         IF it_wnt.EXISTS(x.custom_code) THEN
            it2(v_idx).weight_net            :=     it_wnt(x.custom_code);
         ELSE
            it2(v_idx).weight_net            :=     0;
         END IF;
         it2(v_idx).weight_brut           :=     v_weight_brut;
         it2(v_idx).weight_net_total      :=     v_weight_net;

         it2(v_idx).custom_description    :=     x.c_description;
         it2(v_idx).package_number        :=     v_package_number;
         --
         it2(v_idx).value_mat_client      :=     0;
         it2(v_idx).value_mat_property    :=     0;

         IF it_mvc.EXISTS(x.custom_code) THEN
            it2(v_idx).value_mat_client      := it_mvc(x.custom_code);
         END IF;
         IF it_mvp.EXISTS(x.custom_code) THEN
            it2(v_idx).value_mat_property    := it_mvp(x.custom_code);
         END IF;
         --
         it2(v_idx).value_mat_client_all  :=     v_value_mat_client;
         it2(v_idx).value_mat_property_all:=     v_value_mat_property;

         -- here accumulate the invoice value for service (manopera)
         v_inv_total                     :=     v_inv_total + it2(v_idx).total_value;

         -- check if we have price for every line
         IF it2(v_idx).unit_price <= 0 THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => '100',
                  p_err_header        => 'La urmatoarele pozitii nu exista  '
                                        ||'precizat pret unitar !!!',
                  p_err_detail        => x.item_code
                                        ||x.qty_doc,
                  p_flag_immediate    => 'Y'
             );
         END IF;
     END LOOP;
     -- raise error for unit price zero
     Pkg_Err.p_reset_error_message();

     -- get the first line to have access to the comon information
     x :=  it1(1);

     IF x.service = 'Y' THEN
         -- check the exchange rate
         IF     v_row.currency_code <> C_CURRENCY_RON
            AND x.exchange_rate     IS  NULL
         THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => '00',
                  p_err_header        => 'Nu exista rata de schimb '
                                        ||'pentru valuta '||v_row.currency_code
                                        ||' in data de '||TO_CHAR(x.protocol_date,'DD/MM/YY')
                                        ||' !!!',
                  p_err_detail        => NULL,
                  p_flag_immediate    => 'Y'
             );
         END IF;

         -- footer information
         v_row.footer_information        := 'Curs valutar :     '
                                            || TO_CHAR(v_row.exchange_rate)
                                            || '  '
                                            || 'RON / '
                                            || v_row.currency_code;
         Pkg_Lib.p_nl(v_row.footer_information,1);

         v_inv_total    :=  v_inv_total * v_row.exchange_rate;
         v_inv_total    :=  ROUND(v_inv_total,2); -- round to 2 decimals
         v_row.footer_information        :=  v_row.footer_information
                                            || 'Valoare RON factura :     '
                                            || TO_CHAR(v_inv_total)
                                            || '   RON.' ;
        Pkg_Lib.p_nl(v_row.footer_information,2);
     END IF;
     --- add the situation of the material value for every supplier

     v_str_idx  :=  it_mvs.FIRST;
     IF  v_str_idx IS NOT NULL THEN
        v_row.footer_information    :=  v_row.footer_information
                                        ||'Statistical material value / supplier (EUR):';
        Pkg_Lib.p_nl(v_row.footer_information,2);
     END IF;
     WHILE v_str_idx IS NOT NULL LOOP
        v_row.footer_information := v_row.footer_information
                                    ||RPAD(it_spl(v_str_idx),30)
                                    ||'  : '
                                    ||LPAD(it_mvs(v_str_idx),15);
        Pkg_Lib.p_nl(v_row.footer_information);
        v_str_idx   :=  it_mvs.NEXT(v_str_idx);
     END LOOP;
     ---
     Pkg_Lib.p_nl(v_row.footer_information,2);
     v_row.footer_information        :=  v_row.footer_information || x.note;
     -- add the footer information for every line
     FOR i IN 1..it2.COUNT LOOP
            it2(i).footer_information := v_row.footer_information ;
     END LOOP;
     --
     DELETE FROM VW_ACREC_PRINT;
     FORALL i IN 1..it2.COUNT INSERT INTO VW_ACREC_PRINT VALUES it2(i);


    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 22/04/2008  z CREATE PROCEDURE
/*********************************************************************************/
PROCEDURE p_acrec_clear(p_ref_acrec INTEGER, p_flag_confirm      VARCHAR2)
/*----------------------------------------------------------------------------------
--  PURPOSE:
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------*/
IS


    v_row_hed           ACREC_HEADER%ROWTYPE;

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_acrec IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o factura valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the invoice header
    v_row_hed.idriga    :=  p_ref_acrec;
    IF NOT Pkg_Get.f_get_acrec_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Factura cu identificatorul intern '
                                    || p_ref_acrec ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_acrec,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- is not posible to clear the invoice if it is NOT in status I
    IF v_row_hed.status <>   'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu puteti sterge detaliile de factura, '
                                    ||' aceasta a fost anulata / contabilizata !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    IF Pkg_Lib.f_mod_c(p_flag_confirm, 'Y')  THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu ati confirmat stergerea '
                                    ||' cu caracterul Y !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;

    ---delete the detail lines
    DELETE FROM ACREC_DETAIL WHERE ref_acrec = p_ref_acrec;
    -- reset the refrence in shipment header
    UPDATE  SHIPMENT_HEADER
    SET     ref_acrec   =   NULL,
            status      =   'M'
    WHERE   ref_acrec   =   p_ref_acrec
    ;

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 22/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_acrec_cancel(p_ref_acrec INTEGER, p_flag_confirm      VARCHAR2)
/*----------------------------------------------------------------------------------
--  PURPOSE:
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------*/
IS
   CURSOR   C_CHECK_SHIPMENT(p_ref_acrec INTEGER) IS
            SELECT  COUNT(*) shipment_count
            FROM    SHIPMENT_HEADER
            WHERE   ref_acrec   =   p_ref_acrec
            ;
    v_shipment_count    INTEGER;
    v_row_hed           ACREC_HEADER%ROWTYPE;

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_acrec IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o factura valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the invoice header
    v_row_hed.idriga    :=  p_ref_acrec;
    IF NOT Pkg_Get.f_get_acrec_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Factura cu identificatorul intern '
                                    || p_ref_acrec ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_acrec,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- is not posible to clear the invoice if it is NOT in status I
    IF v_row_hed.status <>   'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu puteti anula factura, '
                                    ||' aceasta a fost deja anulata / contabilizata !!!',
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
    -- it is not possible to cancel invoice if there are shipment documents assocated
    FOR x IN C_CHECK_SHIPMENT(p_ref_acrec) LOOP
        v_shipment_count    :=  x.shipment_count;
    END LOOP;
    ---
    IF v_shipment_count > 0  THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu puteti anula total factura, '
                                    ||'exista documente de expeditii '
                                    ||'asociate la aceasta !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;

    v_row_hed.status    :=  'X';
    Pkg_Iud.p_acrec_header_iud('U',v_row_hed);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;









END;

/

/
