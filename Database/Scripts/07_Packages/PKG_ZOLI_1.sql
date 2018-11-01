--------------------------------------------------------
--  DDL for Package Body PKG_ZOLI
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_ZOLI" 
IS

/*********************************************************************************
    DDL: 22/03/2008  z Create procedure 
/*********************************************************************************/
PROCEDURE p_duplicate_item(p_idriga INTEGER, p_item_code VARCHAR2) 
----------------------------------------------------------------------------------
--  PURPOSE:    creates 
--               
--  PREREQ:     
--               
--  INPUT:         
----------------------------------------------------------------------------------
IS
    v_row_itm       ITEM%ROWTYPE;

BEGIN
    
    Pkg_Err.p_reset_error_message();
    --    
    IF p_item_code IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu ati precizat noul cod de articol !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check if we have idriga
    IF p_idriga IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe un cod vechi valid !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the receit header
    v_row_itm.idriga    :=  p_idriga;
    IF NOT Pkg_Get.f_get_item(v_row_itm,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Articolul cu identificatorul intern '
                                    || p_idriga ||' nu exista in sistem !!!',
              p_err_detail        => p_idriga,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    v_row_itm.idriga        :=   NULL;
    v_row_itm.item_code     :=   Pkg_Lib.f_normalise(p_item_code);  
    
    Pkg_Item.p_item_blo('I',v_row_itm);
    Pkg_Err.p_raise_error_message();
    --
    Pkg_Iud.p_item_iud('I',v_row_itm);
    --    
    COMMIT;
    --
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
-----------------
FUNCTION f_sql_lov_colour (p_colour_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR     C_LINES(p_org_code VARCHAR2,p_category VARCHAR2) IS   
                            SELECT  *
                            FROM    COLOUR
                            WHERE   (    
                                        (UPPER(colour_code)     LIKE p_colour_code ||'%')
                                        OR
                                        (UPPER(description)     LIKE p_colour_code ||'%')
                                    )
                                    AND org_code        =       p_org_code
                                    AND CATEGORY        LIKE NVL(p_category,'%')        
                            ORDER BY  CATEGORY DESC, colour_code ;

    v_row       tmp_cmb := tmp_cmb();
    v_row_itm   ITEM%ROWTYPE;
    
    
BEGIN
    IF p_lov_par1 IS NOT NULL AND p_lov_par2 IS NOT NULL THEN
        v_row_itm.org_code      :=  p_lov_par1;
        v_row_itm.item_code     :=  p_lov_par2;
        IF Pkg_Get2.f_get_item_2(v_row_itm) THEN NULL; END IF;
    END IF;

    FOR x IN C_LINES(   p_org_code =>   p_lov_par1 ,
                        p_category =>   v_row_itm.mat_type
                    ) 
    LOOP
        v_row.txt01    := x.colour_code;
        v_row.txt02    := RPAD(x.description,25)|| ' - !!! '|| x.CATEGORY||' !!!';
       
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;



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
                        s.type_description,
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
        C_INDENT        INTEGER :=  20;
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


         IF x.service = 'Y' THEN
             it2(v_idx).description           :=     NVL(x.item_code,x.family_code);
             it2(v_idx).description           :=     C_ITEM_DESCRIPTION
                                                     ||it2(v_idx).description;
         ELSE
             it2(v_idx).description           :=     x.item_code
                                                     || ' - '
                                                     ||x.i_description  ;
             IF x.m_description IS NOT NULL THEN
                  it2(v_idx).description           :=     it2(v_idx).description 
                                                          || ' - '
                                                          ||x.m_description  ;
             END IF;                                        
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
                                            || 'Valoare RON manopera facturata :     '
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






END;

/

/
