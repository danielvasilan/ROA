--------------------------------------------------------
--  DDL for Package Body PKG_SHIPMENT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_SHIPMENT" 
IS

/*********************************************************************************
DDL:    07/04/2008  z Create procedure
        01/07/2009  d add protocole_code2
/*********************************************************************************/
FUNCTION f_sql_shipment_header(     p_line_id       INTEGER ,
                                    p_org_code      VARCHAR2    DEFAULT NULL,
                                    p_ship_year     VARCHAR2    DEFAULT NULL
                              )  RETURN typ_frm  pipelined
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
                            p_ship_year  VARCHAR2
                        )   IS

                SELECT
                        h.idriga, h.dcn,
                        h.ship_year, h.ship_code, h.ship_date,
                        h.org_code, h.ship_type, h.org_client,
                        h.org_delivery, h.destin_code, h.status, h.whs_code,
                        h.incoterm, h.note, h.package_number, h.ref_acrec,
                        h.truck_number,h.weight_net,h.weight_brut,
                        h.protocol_code h_protocol_code, h.protocol_date h_protocol_date,
                        h.protocol_code2 h_protocol_code2,
                        --
                        s.description  description_ship,
                        --
                        t.date_legal,
                        --
                        o.org_name      client_name,
                        --
                        a.org_name      third_party_name,
                        --
                        b.description description_destination, b.country_code,b.city,b.address ,
                        --
                        i.protocol_date, i.protocol_code
                FROM        SHIPMENT_HEADER      h
                INNER JOIN  SETUP_SHIPMENT       s
                                ON  h.ship_type     =   s.ship_type
                INNER JOIN  ORGANIZATION         o
                                ON  o.org_code      =   h.org_client
                INNER JOIN  ORGANIZATION         a
                                ON  a.org_code      =   h.org_delivery
                INNER JOIN  ORGANIZATION_LOC     b
                                ON  b.org_code      =   h.org_delivery
                                AND b.loc_code      =   h.destin_code
                LEFT  JOIN  ACREC_HEADER         i
                                ON  i.idriga        =   h.ref_acrec
                LEFT JOIN   WHS_TRN              t
                                ON h.idriga         =   t.ref_shipment
                                AND t.flag_storno   =   'N'
                WHERE       h.org_code      LIKE    NVL(p_org_code, '%')
                        AND h.ship_year     =       p_ship_year
                        AND p_line_id       IS      NULL
                ---------
                UNION ALL
                ---------
                SELECT
                        h.idriga, h.dcn,
                        h.ship_year, h.ship_code, h.ship_date,
                        h.org_code, h.ship_type, h.org_client,
                        h.org_delivery, h.destin_code, h.status, h.whs_code,
                        h.incoterm, h.note, h.package_number, h.ref_acrec,
                        h.truck_number,h.weight_net,h.weight_brut,
                        h.protocol_code h_protocol_code, h.protocol_date h_protocol_date,
                        h.protocol_code2 h_protocol_code2,
                        --
                        s.description  description_ship,
                        --
                        t.date_legal,
                        --
                        o.org_name      client_name,
                        --
                        a.org_name      third_party_name,
                        --
                        b.description description_destination, b.country_code,b.city,b.address ,
                        --
                        i.protocol_date, i.protocol_code
                FROM        SHIPMENT_HEADER      h
                INNER JOIN  SETUP_SHIPMENT       s
                                ON  h.ship_type     =   s.ship_type
                INNER JOIN  ORGANIZATION         o
                                ON  o.org_code      =   h.org_client
                INNER JOIN  ORGANIZATION         a
                                ON  a.org_code      =   h.org_delivery
                INNER JOIN  ORGANIZATION_LOC     b
                                ON  b.org_code      =   h.org_delivery
                                AND b.loc_code      =   h.destin_code
                LEFT JOIN  ACREC_HEADER         i
                                ON  i.idriga        =   h.ref_acrec
                LEFT JOIN   WHS_TRN             t
                                ON h.idriga         =   t.ref_shipment
                                AND t.flag_storno   =   'N'
                WHERE       h.idriga          =       p_line_id
                -------------
                ORDER BY ship_code DESC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    v_address   VARCHAR2(1000);
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_ship_year IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Trebuie sa precizati anul expeditiei !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_line_id,p_org_code,p_ship_year) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.ship_year;
        v_row.txt02         :=  x.ship_code;
        v_row.txt03         :=  x.org_code;
        v_row.txt04         :=  x.ship_type;
        v_row.txt05         :=  x.org_client;
        v_row.txt06         :=  x.org_delivery;
        v_row.txt07         :=  x.destin_code;
        v_row.txt08         :=  x.status;
        v_row.txt09         :=  x.whs_code;
        v_row.txt10         :=  x.incoterm;
        v_row.txt11         :=  SUBSTR(x.note,1,250);
        v_row.txt12         :=  x.description_ship;
        v_row.txt13         :=  x.client_name;
        v_row.txt14         :=  x.third_party_name;

        v_address := '';
        IF x.address IS NOT NULL THEN
            v_address       :=  x.address ;
        END IF;
        IF x.city IS NOT NULL THEN
            v_address     :=  v_address ||', '||x.city;
        END IF;
        IF x.country_code IS NOT NULL THEN
            v_address     :=  v_address ||', '||x.country_code;
        END IF;
        v_row.txt15         :=  SUBSTR(v_address, 1, 245);
        v_row.txt16         :=  x.description_destination;
        v_row.txt17         :=  x.protocol_code;
        v_row.txt18         :=  x.truck_number;
        v_row.txt19         :=  x.h_protocol_code;
        v_row.txt20         :=  x.h_protocol_code2;

        v_row.data01        :=  x.ship_date;
        v_row.data02        :=  x.date_legal;
        v_row.data03        :=  x.protocol_date;
        v_row.data04        :=  x.h_protocol_date;

        FOR x IN Pkg_Shipment.C_SHIPMENT_DETAIL(v_row.idriga) LOOP
            v_row.numb01    :=  x.line_count;
            v_row.numb05    :=  x.qty_total;

        END LOOP;
        v_row.numb02        :=  x.package_number;
        v_row.numb03        :=  x.weight_net;
        v_row.numb04        :=  x.weight_brut;


        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
DDL:07/04/2008  z   Create procedure
    30/06/2009  d   add stock for the shipment detail
/*********************************************************************************/
FUNCTION f_sql_shipment_detail(p_line_id INTEGER, p_ref_shipment INTEGER DEFAULT NULL)  RETURN typ_longinfo  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the SHIPMENT_DETAIL
--              for a receipt identified by ref_receipt
--  PREREQ:
--
--  INPUT:      REF_RECEIPT     =   an integer that is IDRIGA of the receipt
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_line_id INTEGER,p_ref_shipment INTEGER)   IS
                SELECT
                        d.idriga,d.dcn,
                        d.ref_shipment, d.org_code, d.item_code, d.colour_code,
                        d.size_code, d.oper_code_item, d.description_item,
                        d.season_code, d.whs_code, d.order_code, d.group_code,
                        d.custom_code, d.origin_code, d.qty_doc, d.uom_shipment,
                        d.qty_doc_puom, d.puom, d.weight_net,
                        d.package_code, d.quality, d.note,d.group_code_out,
                        ----
                        i.description   description_item_join,
                        sf.family_code,
                        sf.description family_description,
                        --
                        c.description   description_colour,
                        --
                        v.description   description_custom,
                        s.qty           s_qty,
                        d.package_number, d.pack_mode, d.pack_mode_count,
                        sf.custom_code family_custom_code
                FROM        SHIPMENT_DETAIL     d
                LEFT JOIN   ITEM                i
                                ON  i.item_code     =   d.item_code
                                AND i.org_code      =   d.org_code
                LEFT JOIN   SALES_FAMILY        sf
                                ON sf.family_code   =   i.root_code
                                AND sf.org_code     =   i.org_code
                LEFT JOIN   COLOUR              c
                                ON  c.colour_code   =   d.colour_code
                                AND c.org_code      =   d.org_code
                LEFT JOIN   CUSTOM              v
                                ON  v.custom_code   =   d.custom_code
                LEFT JOIn   STOC_ONLINE         s
                                ON  s.org_code      =   d.org_code
                                AND s.item_code     =   d.item_code
                                AND s.whs_code      =   d.whs_code
                                AND s.season_code   =   d.season_code
                                AND Pkg_Lib.f_diff_c(s.oper_code_item,  d.oper_code_item) = 0
                                AND Pkg_Lib.f_diff_c(s.colour_code,     d.colour_code) = 0
                                AND Pkg_Lib.f_diff_c(s.size_code,       d.size_code) = 0
                                AND Pkg_Lib.f_diff_c(s.order_code,      d.order_code) = 0
                                AND Pkg_Lib.f_diff_c(s.group_code,      d.group_code) = 0
                WHERE       d.ref_shipment   =   p_ref_shipment
                        AND p_line_id       IS  NULL
                ----------
                UNION ALL
                ---------
                SELECT
                        d.idriga,d.dcn,
                        d.ref_shipment, d.org_code, d.item_code, d.colour_code,
                        d.size_code, d.oper_code_item, d.description_item,
                        d.season_code, d.whs_code, d.order_code, d.group_code,
                        d.custom_code, d.origin_code, d.qty_doc, d.uom_shipment,
                        d.qty_doc_puom, d.puom, d.weight_net,
                        d.package_code, d.quality, d.note,d.group_code_out,
                        ----
                        i.description   description_item_join,
                        sf.family_code,
                        sf.description family_description,
                        --
                        c.description   description_colour,
                        --
                        v.description   description_custom,
                        s.qty           s_qty,
                        d.package_number, d.pack_mode, d.pack_mode_count,
                        sf.custom_code family_custom_code
                FROM        SHIPMENT_DETAIL     d
                LEFT JOIN   ITEM                i
                                ON  i.item_code     =   d.item_code
                                AND i.org_code      =   d.org_code
                LEFT JOIN   SALES_FAMILY        sf
                                ON sf.family_code   =   i.root_code
                                AND sf.org_code     =   i.org_code
                LEFT JOIN   COLOUR              c
                                ON  c.colour_code   =   d.colour_code
                                AND c.org_code      =   d.org_code
                LEFT JOIN  CUSTOM              v
                                ON  v.custom_code   =   d.custom_code
                LEFT JOIn   STOC_ONLINE         s
                                ON  s.org_code      =   d.org_code
                                AND s.item_code     =   d.item_code
                                AND s.whs_code      =   d.whs_code
                                AND s.season_code   =   d.season_code
                                AND Pkg_Lib.f_diff_c(s.oper_code_item,  d.oper_code_item) = 0
                                AND Pkg_Lib.f_diff_c(s.colour_code,     d.colour_code) = 0
                                AND Pkg_Lib.f_diff_c(s.size_code,       d.size_code) = 0
                                AND Pkg_Lib.f_diff_c(s.order_code,      d.order_code) = 0
                                AND Pkg_Lib.f_diff_c(s.group_code,      d.group_code) = 0
                WHERE   d.idriga    =  p_line_id
                ---------------------------
                ORDER BY item_code
                ;
    --
    v_row           tmp_longinfo             :=  tmp_longinfo();
    v_idx varchar2(100);
    tas_man_price   Pkg_Glb.typ_number_varchar;
    tas_prd_price   Pkg_Glb.typ_number_varchar;
    row_sh          SHIPMENT_HEADER%ROWTYPE;
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_ref_shipment IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Nu sunteti pozitionat pe o expeditie valida !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    
    IF p_ref_shipment is not null then
        row_sh.idriga := p_ref_shipment;
        Pkg_Get.p_get_shipment_header(row_sh);
        -- get the MAN / PROD costs for the families
        FOR x IN(
                SELECT family_code, unit_cost, season_code, cost_code
                FROM ITEM_COST 
                where partner_code = 'ALT' 
                    and cost_code in ('MAN_PROD', 'MAN_SEL')
                    and currency_code = 'EUR'
                    and sysdate between start_date and nvl(end_date, sysdate + 1)
                )
        LOOP
            v_idx := x.family_code||'|'||x.season_code;
            IF x.cost_code = 'MAN_PROD' THEN
                tas_prd_price(v_idx) := x.unit_cost;
            ELSE
                tas_man_price(v_idx) := x.unit_cost;
            END IF;        
        END LOOP;
    END IF;
    --
    FOR x IN C_LINES(p_line_id,p_ref_shipment) LOOP

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
        v_row.txt09         :=  x.season_code;
        v_row.txt10         :=  x.whs_code;
        v_row.txt11         :=  x.order_code;
        v_row.txt12         :=  x.group_code;
        v_row.txt13         :=  x.custom_code;
        v_row.txt14         :=  x.description_custom;
        v_row.txt15         :=  x.origin_code;
        v_row.txt16         :=  x.uom_shipment;
        v_row.txt17         :=  x.puom;
        v_row.txt18         :=  x.quality;
        v_row.txt20         :=  x.note;
        v_row.txt21         :=  x.group_code_out;
        v_row.txt22         :=  x.family_code;
        v_row.txt23         :=  x.family_custom_code;
        v_row.txt24         :=  x.pack_mode;

        v_row.numb01        :=  x.ref_shipment;
        v_row.numb02        :=  x.qty_doc;
        v_row.numb03        :=  x.qty_doc_puom;
        v_row.numb04        :=  x.weight_net;
        v_row.numb05        :=  x.package_code;
        v_row.numb06        :=  x.s_qty;
        v_row.numb07        :=  x.package_number;
        
        v_idx := x.family_code||'|'||x.season_code;
        v_row.numb08        := 0;
        v_row.numb09        := 0;    
        IF tas_man_price.exists(v_idx) THEN
            v_row.numb08    := tas_man_price(v_idx);
        END IF;    
        IF tas_prd_price.exists(v_idx) THEN
            v_row.numb09    := tas_prd_price(v_idx);
        END IF;
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
    DDL:    07/04/2008  z   Create procedure
            10/07/2008  d   added the package quantity (total + quality1 + quality2)
/*********************************************************************************/
FUNCTION f_sql_shipment_package(p_line_id INTEGER,p_ref_shipment INTEGER DEFAULT NULL)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_line_id INTEGER,p_ref_shipment INTEGER)   IS
                SELECT      p.idriga,
                            MAX(d.dcn)          dcn,
                            MAX(p.ref_shipment) ref_shipment,
                            MAX(p.org_code)     org_code,
                            MAX(p.seq_no)       seq_no,
                            MAX(p.package_code) package_code,
                            MAX(h.description)  description,
                            MAX(p.package_type) package_type,
                            MAX(p.weight_net)   weight_net,
                            MAX(p.weight_brut)  weight_brut,
                            MAX(p.volume)       volume,
                            SUM(d.qty)          qty,
                            SUM(CASE    WHEN    d.quality = '1' THEN d.qty ELSE 0 END) qty_q1,
                            SUM(CASE    WHEN    d.quality = '2' THEN d.qty ELSE 0 END) qty_q2,
                            MIN(d.order_code)   min_order_code,
                            MAX(d.order_code)   max_order_code,
                            COUNT(DISTINCT d.order_code)    count_order
                ---
                FROM        SHIPMENT_PACKAGE    p
                LEFT JOIN   PACKAGE_HEADER      h   ON  h.package_code  =   p.package_code
                LEFT JOIN   PACKAGE_DETAIL      d   ON  d.package_code  =   h.package_code
                ---
                WHERE       p.ref_shipment      =   p_ref_shipment
                        AND p_line_id           IS  NULL
                GROUP BY    p.idriga
                ----------
                UNION ALL
                ---------
                SELECT      p.idriga,
                            MAX(d.dcn)          dcn,
                            MAX(p.ref_shipment) ref_shipment,
                            MAX(p.org_code)     org_code,
                            MAX(p.seq_no)       seq_no,
                            MAX(p.package_code) package_code,
                            MAX(h.description)  description,
                            MAX(p.package_type) package_type,
                            MAX(p.weight_net)   weight_net,
                            MAX(p.weight_brut)  weight_brut,
                            MAX(p.volume)       volume,
                            SUM(d.qty)          qty,
                            SUM(CASE    WHEN    d.quality = '1' THEN d.qty ELSE 0 END) qty_q1,
                            SUM(CASE    WHEN    d.quality = '2' THEN d.qty ELSE 0 END) qty_q2,
                            MIN(d.order_code)   min_order_code,
                            MAX(d.order_code)   max_order_code,
                            COUNT(DISTINCT d.order_code)    count_order
                ---
                FROM        SHIPMENT_PACKAGE    p
                LEFT JOIN   PACKAGE_HEADER      h   ON  h.package_code  =   p.package_code
                LEFT JOIN   PACKAGE_DETAIL      d   ON  d.package_code  =   h.package_code
                ---
                WHERE       d.idriga    =  p_line_id
                GROUP BY    p.idriga
                ---------------------------
                ORDER BY seq_no
                ;

    CURSOR  C_ORD   (p_package_code VARCHAR2)
                IS
                SELECT  DISTINCT order_code
                FROM    PACKAGE_DETAIL  d
                WHERE   d.package_code  =   p_package_code
                ;


    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN

    IF p_line_id IS NULL AND p_ref_shipment IS NULL THEN
        Pkg_Err.p_rae('Nu sunteti pozitionat pe o expeditie valida !!!');
    END IF;

    --
    FOR x IN C_LINES(p_line_id,p_ref_shipment) LOOP

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.package_code;
        v_row.txt03         :=  x.description;
        v_row.txt04         :=  x.package_type;
        IF x.count_order > 2 THEN
            v_row.txt05     :=  '';
            FOR xx IN C_ORD(x.package_code)
            LOOP
                v_row.txt05 :=  v_row.txt05 || ' ' ||xx.order_code;
            END LOOP;
        ELSE
            v_row.txt05         :=  x.min_order_code;
            IF x.min_order_code <> x.max_order_code THEN
                v_row.txt05     :=  v_row.txt05 || ' ' ||x.max_order_code;
            END IF;
        END IF;

        v_row.numb01        :=  x.ref_shipment;
        v_row.numb02        :=  x.seq_no;
        v_row.numb03        :=  x.weight_net;
        v_row.numb04        :=  x.weight_brut;
        v_row.numb05        :=  x.volume;
        v_row.numb06        :=  x.qty;
        v_row.numb07        :=  x.qty_q1;
        v_row.numb08        :=  x.qty_q2;

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
    DDL: 08/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_shipment_header_iud(p_tip VARCHAR2, p_row SHIPMENT_HEADER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in shipment_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               SHIPMENT_HEADER%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Shipment.p_shipment_header_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_shipment_header_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
DDL:    23/02/2008  z Create procedure
        01/07/2009  d add PROTOCOLE_CODE2 as modifiable columns, even when shipment is unloaded
/*********************************************************************************/
PROCEDURE p_shipment_header_blo(p_tip VARCHAR2, p_row IN OUT SHIPMENT_HEADER%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in shipment_header when is created , updated, deleted
                - for insert sets the next shipment number (internal number)
                - for update cheks the status of the header
                    * if I - and there are detail lines then not permited to modify
                      WHS_CODE and SHIP_TYPE
                    * if M, F - only some fields are permited to modify
                    * if X - NO modification are permited
                -   if setup shipment OUT_PROC = Y then the client / third party has to
                    be with FLAG_LOHN = Y
                -   if setup shipment NATURE = S - sale the client has to be with FLAG_CLIENT = Y
                -   if setup shipment NATURE = S - sale no destination warehouse is permited
                -   if setup shipment OUT_PROC = Y then destination warehouse is needed
                    and the destination warehouse must be asociated with the client
                -   if setup shipment EXTERN = Y the incoterm must be indicated
--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS

    C_DOC_TYPE          VARCHAR2(32000) :=  'SHIPMENT';
    C_MOD_COL_I         VARCHAR2(32000) :=    'SHIP_TYPE,'
                                            ||'WHS_CODE';
    C_MOD_COL_M         VARCHAR2(32000) :=    'INCOTERM,'
                                            ||'NOTE,'
                                            ||'PACKAGE_NUMBER,'
                                            ||'TRUCK_NUMBER,'
                                            ||'WEIGHT_NET,'
                                            ||'WEIGHT_BRUT,'
                                            ||'PROTOCOL_CODE,'
                                            ||'PROTOCOL_DATE,'
                                            ||'PROTOCOL_CODE2,'
                                            ;

    C_ERR_CODE          VARCHAR2(32000) := 'SHIPMENT_HEADER';

    v_mod_col           VARCHAR2(32000);
    v_detail_count      INTEGER;

    v_row_old           SHIPMENT_HEADER%ROWTYPE;

    v_row_cli           ORGANIZATION%ROWTYPE;
    v_row_org           ORGANIZATION%ROWTYPE;
    v_row_thr           ORGANIZATION%ROWTYPE;

    v_row_ssh           SETUP_SHIPMENT%ROWTYPE;
    v_row_inc           DELIVERY_CONDITION%ROWTYPE;
    v_row_whs           WAREHOUSE%ROWTYPE;
    v_row_wct           WAREHOUSE_CATEG%ROWTYPE;
    v_row_des           ORGANIZATION_LOC%ROWTYPE;

    v_error             BOOLEAN ;
    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN

        v_row_org.org_code  :=  p_row.org_code;
        Pkg_Check.p_chk_organization(v_row_org);
        --
        v_row_ssh.ship_type  :=  p_row.ship_type;
        Pkg_Check.p_chk_setup_shipment(v_row_ssh);
        --
        v_row_cli.org_code  :=  p_row.org_client;
        Pkg_Check.p_chk_organization(v_row_cli);
        --
        v_row_thr.org_code  :=  p_row.org_delivery;
        Pkg_Check.p_chk_organization(v_row_thr);
        --
        v_row_des.org_code  :=  p_row.org_delivery;
        v_row_des.loc_code  :=  p_row.destin_code;
        Pkg_Check.p_chk_organization_loc(v_row_des);
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
        --if shipment outside processing the client and third party has to be
        -- with FLAG_LOHN = Y
        IF      v_row_ssh.out_proc  =   'Y'
            AND (
                v_row_cli.flag_lohn =   'N'
                OR
                v_row_thr.flag_lohn =   'N'
                )
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '100' ,
                 p_err_header        => 'Pentru acest tip de expeditie '
                                        ||'destinatarul si tertul trebuie '
                                        ||'sa aiba calitatea de tert '
                                        ||'!!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;
        -- if nature of transaction is S - sales the client has to be with
        -- FLAG_CLIENT = 'Y'
        IF      v_row_ssh.nature        =   'S'
            AND v_row_cli.flag_client   =   'N'
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '150' ,
                 p_err_header        => 'Pentru acest tip de expeditie '
                                        ||'destinatarul trebuie '
                                        ||'sa aiba calitatea de client '
                                        ||'!!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;
        -- if nature = S sales we do not need the destination warehouse
        IF      v_row_ssh.nature        =   'S'
            AND v_row_whs.whs_code      IS NOT NULL
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '200' ,
                 p_err_header        => 'Pentru expeditie cu vanzare '
                                        ||'magazia destinatie trebuie '
                                        ||'sa fie liber '
                                        ||'!!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;
        -- if out_proc = Y the destination warehouse has to be specified
        -- and the organization associated to the warehouse has to be the
        -- same with the client
        IF      v_row_ssh.out_proc      =   'Y'
            AND (
                v_row_whs.whs_code IS NULL
                OR
                v_row_whs.org_code <> p_row.org_client
                OR
                v_row_whs.org_code <> p_row.org_delivery
                )
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '250' ,
                 p_err_header        => 'Pentru transfer la terti '
                                        ||'magazia destinatie trebuie '
                                        ||'precizata si trebuie '
                                        ||'sa fie o magazie asociata cu '
                                        ||'acest destinatar/tert '
                                        ||'!!!',
                 p_err_detail        => NULL,
                 p_flag_immediate    => 'N'
            );
        END IF;
        -- for shipment outside country the delivery condition must be specified
        IF      v_row_ssh.extern        =   'Y'
            AND v_row_inc.deliv_cond_code IS NULL
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '300' ,
                 p_err_header        => 'Pentru expeditii in extern '
                                        ||'trebuie precizata conditia '
                                        ||'de livrare (INCOTERM) '
                                        ||'!!!',
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
                p_row.ship_date      :=  TRUNC(SYSDATE);
                p_row.ship_year      :=  TO_CHAR(p_row.ship_date,'YYYY');
                p_row.ship_code      :=  Pkg_Env.f_get_app_doc_number
                                             (
                                                 p_org_code     =>   Pkg_Glb.C_MYSELF   ,
                                                 p_doc_type     =>   C_DOC_TYPE         ,
                                                 p_doc_subtype  =>   C_DOC_TYPE         ,
                                                 p_num_year     =>   p_row.ship_year
                                             );
                 p_row.status           :=  'I';
                 p_row.flag_package     :=  'V';

        WHEN    'U' THEN

                v_error     :=  FALSE;
                --
                v_row_old.idriga    :=  p_row.idriga;
                IF Pkg_Get.f_get_shipment_header(v_row_old) THEN NULL; END IF;
                v_mod_col   :=  Pkg_Mod_Col.f_shipment_header(v_row_old, p_row);
                -- check if there is detail lines on the shipment
                -- if there are some information not modifyable
                FOR x IN Pkg_Shipment.C_SHIPMENT_DETAIL(p_row.idriga) LOOP
                    v_detail_count :=  x.line_count;
                END LOOP;
                v_detail_count  :=  NVL(v_detail_count,0);
                -- check status of shipment
                CASE
                        WHEN    v_row_old.status = 'I' THEN
                            ---------
                            IF      v_detail_count > 0
                                AND Pkg_Lib.F_Column_Is_Modif2(C_MOD_COL_I,v_mod_col) = -1
                            THEN
                                Pkg_Err.p_set_error_message
                                (    p_err_code          => C_ERR_CODE ,
                                     p_err_header        => 'Expeditia are detaliu, '
                                                            ||'nu mai puteti modifica '
                                                            ||'UNELE informatii (tip_exped,magazie_destin) '
                                                            ||'din antet !!!',
                                     p_err_detail        => NULL,
                                     p_flag_immediate    => 'N'
                                );
                                ---
                                v_error :=  TRUE;
                                ---
                            END IF;
                            ----------
                         WHEN   v_row_old.status    IN  ('M','F') THEN
                            IF Pkg_Lib.F_Column_Other_Is_Modif2(C_MOD_COL_M,v_mod_col) = -1 THEN
                               Pkg_Err.p_set_error_message
                               (    p_err_code          => C_ERR_CODE ,
                                    p_err_header        => 'Expeditia a fost descarcata din magazie, '
                                                           ||'nu mai puteti modifica informatiile de antet !!!',
                                    p_err_detail        => NULL,
                                    p_flag_immediate    => 'N'
                               );
                                ---
                                v_error :=  TRUE;
                                ---
                            END IF;
                         WHEN   v_row_old.status    IN  ('X') THEN
                               Pkg_Err.p_set_error_message
                               (    p_err_code          => C_ERR_CODE ,
                                    p_err_header        => 'Expeditia a fost anulata, '
                                                           ||'nu mai puteti modifica !!!',
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
    DDL: 08/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_shipment_detail_iud(p_tip VARCHAR2, p_row SHIPMENT_DETAIL%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_detail when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               SHIPMENT_DETAIL%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Shipment.p_shipment_detail_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_shipment_detail_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;

/*********************************************************************************
    DDL: 08/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_shipment_detail_blo( p_tip   VARCHAR2, p_row IN OUT SHIPMENT_DETAIL%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in shipment_detail when is created , updated, deleted
                - fields that must be filed:ORG_CODE, ITEM_CODE, WHS_CODE,QTY_DOC,UOM_SHIPMENT,
                  SEASON_CODE
                - for shipment type = EXTERNAL and nature = T we need custom code
                - for other kind of shipment the custom code has to be null
                - chechk the colour / size
                - check the unit of measure of shipment
                - convert qty in PUOM quantity if it is necesary
                - qty must exist, be positiv and maximum 4 decimals;
                - for sales shipment the source warehouse has to be of category
                  CTL / SHP


--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    v_row_hed       SHIPMENT_HEADER%ROWTYPE;
    v_row_ssh       SETUP_SHIPMENT%ROWTYPE;
    v_row_old       SHIPMENT_DETAIL%ROWTYPE;

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
    v_row_wgo       WORK_GROUP%ROWTYPE;

    v_mod_col       VARCHAR2(32000);
    C_ERR_CODE      VARCHAR2(32000) :=  'SHIPMENT_DETAIL';
    C_MOD_COL       VARCHAR2(32000) :=  'DESCRIPTION_ITEM,'
                                        ||'CUSTOM_CODE,'
                                        ||'ORIGIN_CODE,'
                                        ||'WEIGHT_NET,'
                                        ||'PACKAGE_CODE,'
                                        ||'QUALITY,'
                                        ||'NOTE';
    v_err           BOOLEAN     :=  FALSE;
    v_t             BOOLEAN;
    C_PRECISION     NUMBER          :=  3;

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        -- get the shipment type
        v_row_ssh.ship_type  :=  v_row_hed.ship_type;
        IF  Pkg_Get2.f_get_setup_shipment_2(v_row_ssh) THEN NULL; END IF;
        --
        v_row_itm.org_code      :=  p_row.org_code;
        v_row_itm.item_code     :=  p_row.item_code;
        Pkg_Check.p_chk_item(v_row_itm,p_row.item_code);
        --
        p_row.uom_shipment      :=  NVL(p_row.uom_shipment, v_row_itm.puom);
        v_row_pum.puom          :=  p_row.uom_shipment;
        Pkg_Check.p_chk_primary_uom(v_row_pum,p_row.item_code);
        --
        v_row_whs.whs_code      :=  p_row.whs_code;
        Pkg_Check.p_chk_warehouse(v_row_whs,p_row.item_code);
        --
        v_row_stg.org_code      :=  p_row.org_code;
        v_row_stg.season_code   :=  p_row.season_code;
        Pkg_Check.p_chk_work_season(v_row_stg,p_row.item_code);
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
        IF p_row.origin_code IS NOT NULL THEN
            v_row_cot.country_code   :=  p_row.origin_code;
            Pkg_Check.p_chk_country(v_row_cot,p_row.item_code);
        END IF;
        --
        IF p_row.group_code IS NOT NULL THEN
            v_row_wgr.group_code    :=  p_row.group_code;
            Pkg_Check.p_chk_work_group(v_row_wgr,p_row.item_code);
        END IF;
        --
        IF p_row.group_code_out IS NOT NULL THEN
            v_row_wgo.group_code    :=  p_row.group_code_out;
            Pkg_Check.p_chk_work_group(v_row_wgo,p_row.item_code);
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
        -- check the unit of measure of shipment
        v_t :=  p_row.uom_shipment NOT IN (v_row_itm.puom, NVL(v_row_itm.suom,v_row_itm.puom));
        IF v_t THEN P_Sen('050',
        'Ati precizat unitate de masura  '
        ||'sa precizati si bola client corespunzatoare care nu este nici primara nici secundara '
        ||'pentru acest cod !!!',
        v_row_itm.item_code
        ||', PUOM :'||v_row_itm.puom
        ||', SUOM: '||v_row_itm.suom
        );END IF;
        -- chck on quantities
        p_row.qty_doc   :=  NVL(p_row.qty_doc,0);
        v_t :=      p_row.qty_doc <= 0
                OR  p_row.qty_doc - TRUNC(p_row.qty_doc,C_PRECISION) > 0;
        IF v_t THEN P_Sen('060',
         'Cantitatea trebuie sa fie pozitiva si sa aiba precizie maxim '||C_PRECISION ||' zecimale !!!',
          v_row_itm.item_code
        );END IF;
        -- transform in primary unit of measure
        p_row.puom  :=  v_row_itm.puom;
        v_t :=  p_row.uom_shipment <> v_row_itm.puom;
        IF v_t THEN
            p_row.qty_doc_puom      :=  p_row.qty_doc * v_row_itm.uom_conv;
            p_row.qty_doc_puom      :=  ROUND(p_row.qty_doc_puom,C_PRECISION);
        ELSE
            p_row.qty_doc_puom      :=  p_row.qty_doc ;
        END IF;
        -- for external shipment that is transfer we
        -- need the custom code (for sale we have the custom code
        -- in the setup_shipment)
        v_t :=      v_row_ssh.extern    =   'Y'
                AND v_row_ssh.nature    =   'T'  ;
        IF v_t THEN
            p_row.custom_code       :=  NVL(p_row.custom_code,v_row_itm.custom_code);
            v_row_cst.custom_code   :=  p_row.custom_code;
            Pkg_Check.p_chk_custom(v_row_cst,p_row.item_code);
        END IF;
        --
/* Daniel - disabled on 26.05.2016 
        v_t :=  NOT (       v_row_ssh.extern    =   'Y'
                        AND v_row_ssh.nature    =   'T')
                AND p_row.custom_code IS NOT NULL;
        IF v_t THEN P_Sen('090',
        'Pentru acest tip de expeditie campul cu codul vamal trebuie lasat liber !!! ',
        v_row_itm.item_code
        );END IF;
*/
        -- check if the season code coresponds to the orders if they exists
        v_t :=      v_row_ord.order_code IS NOT NULL
                AND v_row_stg.season_code <> v_row_ord.season_code;
        IF v_t THEN P_Sen('093',
        'Stagiunea trebuie sa fie identica cu cea a bolei !!! ',
        v_row_itm.item_code
        );END IF;
        -- for shipment that is not outside processing it is not possible to
        -- specify work groups (internal orders)
        v_t :=      v_row_ssh.out_proc = 'N'
                AND (   p_row.group_code        IS NOT NULL
                     OR p_row.group_code_out    IS NOT NULL)
                ;
        IF v_t THEN P_Sen('100',
        'Pe expeditii care nu sunt catre terti nu poate apare comanda interna !!! ',
        v_row_itm.item_code
        );END IF;
        --
        v_t :=        v_row_ssh.out_proc    = 'Y'
                AND   v_row_ord.order_code  IS NOT NULL
                AND ( v_row_itm.item_code  <> v_row_ord.item_code
                      OR
                      v_row_wgo.group_code IS NULL
                      OR
                      Pkg_Lib.f_mod_c(v_row_wgo.group_code,v_row_wgr.group_code)
                      OR
                      Pkg_Order.f_chk_order_in_group(v_row_ord.org_code,
                                                     v_row_ord.order_code,
                                                     v_row_wgo.group_code) = 'N'
                     );
        IF v_t THEN P_Sen('110',
        'Pentru expeditie la tert daca ati precizat bola client inseamna '
        ||'ca vreti sa transferati semiprocesate deci : ' || Pkg_Glb.C_NL
        ||' - produsul corespunzator acestei bole '||v_row_ord.item_code||' trebuie sa fie identica cu codul articolului;'|| Pkg_Glb.C_NL
        ||' - comanda sursa si comanda destinatie trebuie sa existe si sa fie identice ;'||Pkg_Glb.C_NL
        ||' - bola trebuie sa fie asociata cu aceste comenzi ',
        v_row_itm.item_code
        );END IF;
        ---
        v_t :=       v_row_ssh.out_proc    = 'Y'
                AND  v_row_whs.category_code NOT IN (
                                                    Pkg_Glb.C_WHS_MPC,
                                                    Pkg_Glb.C_WHS_MPP,
                                                    Pkg_Glb.C_WHS_WIP
                                                    );
        IF v_t THEN P_Sen('120',
        'Pentru expeditie la tert magazia sursa trebuie sa fie de tip stoc sau sectie (WIP) !!!',
        v_row_itm.item_code
        );END IF;
        --
        v_t :=      v_row_ssh.out_proc      = 'Y'
                AND v_row_ord.order_code    IS NOT NULL
                AND v_row_whs.category_code <> Pkg_Glb.C_WHS_WIP;
        IF v_t THEN P_Sen('130',
        'Pentru expeditie la terti daca expediati semiprocesate adica ati precizat bola '
        ||'magazia sursa trebuie sa fie de categoria sectie (WIP) !!! ',
        v_row_itm.item_code
        );END IF;
        -- I assume when they introduce an oper_code_item they want to transfer
        -- semiprocessed item that was previously processed in Filty
        -- If there are semiprocessed items that was received from the client
        -- we have to see how to manage it
        v_t :=      v_row_ssh.out_proc      = 'Y'
                AND v_row_ope.oper_code     IS NOT NULL
                AND v_row_ord.order_code    IS NULL   ;
        IF v_t THEN P_Sen('140',
        'Pentru expeditie la terti daca transferati produse finite pe faza trebuie '
        ||'sa precizati si bola client corespunzatoare !!!',
        v_row_itm.item_code
        );END IF;
        -- for sales shipment is it possible to ship only from warehouse category
        -- SHP and CTL
        v_t :=      v_row_ssh.nature        =   'S'
                AND v_row_whs.category_code NOT IN (    Pkg_Glb.C_WHS_SHP,
                                                        Pkg_Glb.C_WHS_CTL);
        IF v_t THEN P_Sen('200',
        'In cazul unei expeditii cu vanzare magazia sursa trebuie sa fie de categoria expeditie SHP '
        ||'sau conto lavoro CTL !!!',
        v_row_itm.item_code
        );END IF;

    END;
    ---------------------------------------------------------------------------
BEGIN
    --
    IF p_row.ref_shipment IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Nu sunteti pozitionat pe o expeditie valida !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'N'
        );
        --
        v_err   :=  TRUE;
        --
    END IF;
    --
    v_row_hed.idriga    :=  p_row.ref_shipment;
    IF NOT Pkg_Get.f_get_shipment_header(v_row_hed) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Antetul de expeditie cu identificatorul'
                                    ||' intern (IDRIGA) :'||v_row_hed.idriga
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => v_row_hed.idriga,
             p_flag_immediate    => 'N'
        );
        --
        v_err   :=  TRUE;
        --
    END IF;

    -- cannot modify the line if it's not manually generated
    IF p_tip = 'I' THEN
        p_row.line_source := 'MAN';
    ELSE
        IF p_row.line_source <> 'MAN' THEN
            Pkg_Err.p_rae('Nu se pot modifica liniile unei expeditii, decat daca au fost inserate manual!');
        END IF;
    END IF;

    CASE    p_tip
        WHEN    'I' THEN
                --
                IF v_row_hed.status <> 'I' THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => C_ERR_CODE ,
                         p_err_header        => 'Nu puteti modifica expeditia, '
                                                ||' aceasta nu este in starea I (inserat) !!!',
                         p_err_detail        => NULL,
                         p_flag_immediate    => 'N'
                    );
                    --
                    v_err   :=  TRUE;
                    --
                END IF;
                --
        WHEN    'U' THEN
                CASE
                    WHEN    v_row_hed.status = 'X' THEN
                        Pkg_Err.p_set_error_message
                        (    p_err_code          => C_ERR_CODE ,
                             p_err_header        => 'Nu puteti modifica expeditia, '
                                                    ||' aceasta este anulata (X) !!!',
                             p_err_detail        => NULL,
                             p_flag_immediate    => 'N'
                        );
                        --
                        v_err   :=  TRUE;
                        --
                    WHEN    v_row_hed.status IN ('M','F') THEN
                        v_row_old.idriga    :=  p_row.idriga;
                        IF Pkg_Get.f_get_shipment_detail(v_row_old) THEN NULL; END IF;
                        v_mod_col   :=  Pkg_Mod_Col.f_shipment_detail(v_row_old, p_row);
                        IF Pkg_Lib.F_Column_Other_Is_Modif2(C_MOD_COL,v_mod_col) = -1 THEN
                            Pkg_Err.p_set_error_message
                            (    p_err_code          => C_ERR_CODE  ,
                                 p_err_header        => 'Nu puteti modifica expeditia, '
                                                        ||' aceasta a fost descarcata din magazie !!!',
                                 p_err_detail        => NULL,
                                 p_flag_immediate    => 'N'
                            );
                            --
                            v_err   :=  TRUE;
                            --
                        END IF;
                    WHEN   v_row_hed.status IN  ('I')   THEN
                         NULL;
                END CASE;
        WHEN    'D' THEN
                IF v_row_hed.status <> 'I' THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => C_ERR_CODE ,
                         p_err_header        => 'Nu puteti modifica expeditia, '
                                                ||' aceasta nu este in starea inserata (I) !!!',
                         p_err_detail        => NULL,
                         p_flag_immediate    => 'N'
                    );
                    --
                    v_err   :=  TRUE;
                    --
                END IF;
    END CASE;
    --
    IF p_tip <> 'D' AND NOT v_err THEN
        p_check_integrity();
    END IF;
    --
--    EXCEPTION
--    WHEN OTHERS THEN
--        ROLLBACK;
--        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 09/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_shipment_package_iud(p_tip VARCHAR2, p_row SHIPMENT_PACKAGE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_detail when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               SHIPMENT_PACKAGE%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
   -- Pkg_Shipment.p_shipment_detail_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_shipment_package_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;

/*********************************************************************************
    DDL: 10/04/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_setup_shipment  RETURN typ_frm  pipelined
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
                FROM    SETUP_SHIPMENT  h
                ORDER BY h.ship_type ASC
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
        v_row.txt01         :=  x.ship_type;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.whs_code;
        v_row.txt04         :=  x.property;
        v_row.txt05         :=  x.extern;
        v_row.txt06         :=  x.out_proc;
        v_row.txt07         :=  x.custom_code;
        v_row.txt08         :=  x.nature;
        v_row.txt09         :=  x.trn_type;
        v_row.txt10         :=  x.fifo;

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
    DDL: 10/04/2008  d Create procedure
/*********************************************************************************/
PROCEDURE p_prepare_pick_shipment   (   p_ref_shipment  INTEGER,
                                        p_org_code      VARCHAR2,
                                        p_whs_code      VARCHAR2)
----------------------------------------------------------------------------------
--  PURPOSE:    prepares the picking list for making the shipment
--  INPUT:      WHS_CODE    =   warehouse for which to show items
--                              (can be more than 1, comma separated)
----------------------------------------------------------------------------------
IS
    PRAGMA autonomous_transaction;

    CURSOR C_LINES      (p_whs_code VARCHAR2)
                        IS
                        SELECT      s.org_code, s.season_code,s.order_code,
                                    s. item_code, s.oper_code_item,
                                    s.size_code, s.colour_code,s.puom, s.qty,
                                    s.group_code,
                                    s.whs_code              ,
                                    i.description,
                                    o.oper_code_item        o_oper_code_item
                        -------------------------------------------------------------------------
                        FROM        VW_STOC_ONLINE      s
                        LEFT JOIN   WORK_ORDER          o   ON  o.org_code      =   s.org_code
                                                            AND o.order_code    =   s.order_code
                        INNER JOIN  ITEM                i
                                                            ON  i.org_code      =   s.org_code
                                                            AND i.item_code     =   s.item_code
                        -------------------------------------------------------------------------
                        WHERE       s.qty       >   0
--AND s.season_code = 'AI08'
                        ORDER BY    s.order_code, s.size_code
                        ;

    CURSOR  C_ALREADY_PICKED(p_ref_shipment INTEGER) IS
                        SELECT  *
                        FROM    SHIPMENT_DETAIL
                        WHERE   ref_shipment    =   p_ref_shipment
                        ;

    it_apk              Pkg_Glb.typ_number_varchar;
    v_idx               Pkg_Glb.type_index;
    v_row               VW_BLO_PICK_SHIPMENT%ROWTYPE;
    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_BLO_PICK_SHIPMENT';

BEGIN

    -- empty the BLO view for shipment
    DELETE FROM VW_BLO_PICK_SHIPMENT;

    -- generate the STOCKS
    Pkg_Mov.P_Stoc_Online(
                            p_org_code      =>  p_org_code,
                            p_whs_code      =>  p_whs_code
                         );

    FOR x IN C_ALREADY_PICKED(p_ref_shipment) LOOP
           v_idx    :=  Pkg_Lib.f_str_idx(
                                            p_par1  => x.org_code ,
                                            p_par2  => x.item_code,
                                            p_par3  => x.oper_code_item,
                                            p_par4  => x.colour_code,
                                            p_par5  => x.size_code,
                                            p_par6  => x.order_code,
                                            p_par7  => x.season_code,
                                            p_par8  => x.group_code,
                                            p_par9  => x.whs_code
                                          );
           IF it_apk.EXISTS(v_idx) THEN
                it_apk(v_idx)   :=  it_apk(v_idx) + x.qty_doc;
           ELSE
                it_apk(v_idx)   :=  x.qty_doc;
           END IF;
    END LOOP;




    FOR x IN C_LINES(p_whs_code)
    LOOP

            v_idx    :=  Pkg_Lib.f_str_idx(
                                            p_par1  => x.org_code ,
                                            p_par2  => x.item_code,
                                            p_par3  => x.oper_code_item,
                                            p_par4  => x.colour_code,
                                            p_par5  => x.size_code,
                                            p_par6  => x.order_code,
                                            p_par7  => x.season_code,
                                            p_par8  => x.group_code,
                                            p_par9  => x.whs_code
                                          );

            v_row.org_code          :=  x.org_code;
            v_row.order_code        :=  x.order_code;
            v_row.item_code         :=  x.item_code;
            v_row.oper_code_item    :=  x.oper_code_item;
            v_row.description       :=  x.description;
            v_row.colour_code       :=  x.colour_code;
            v_row.size_code         :=  x.size_code;
            v_row.season_code       :=  x.season_code;
            v_row.puom              :=  x.puom;
            v_row.group_code        :=  x.group_code;
            v_row.whs_code          :=  x.whs_code;
            v_row.idriga            :=  C_LINES%rowcount;
            v_row.selection         :=  0;
            v_row.seq_no            :=  C_LINES%rowcount;

            v_row.qty_pick          :=  0;
            IF it_apk.EXISTS(v_idx) THEN
                v_row.qty_pick      :=  it_apk(v_idx);
            END IF;

            v_row.qty               :=  x.qty - v_row.qty_pick;
            v_row.qty_q1            :=  0;
            v_row.qty_q2            :=  0;
            v_row.segment_code      :=  C_SEGMENT_CODE;

        INSERT INTO VW_BLO_PICK_SHIPMENT
        VALUES      v_row;

    END LOOP;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
   Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;



/*********************************************************************************
    DDL: 10/04/2008  d Create procedure
/*********************************************************************************/
PROCEDURE p_shipment_from_picking   (   p_ref_shipment  NUMBER)
----------------------------------------------------------------------------------
--  PURPOSE:    generates the SHIPMENT DETAIL from the
--  PREREQ:     in VW_TRANSFER_ORACLE must be loaded the informations set by the user
--                  =>  numb01  -   idriga from the VW_BLO_PICK_SHIPMENT
--                  =>  numb02  -   qty quality 1
--                  =>  numb03  -   qty quality 2
--  INPUT:
----------------------------------------------------------------------------------
IS

    CURSOR C_LINES          IS
                            SELECT      a.numb02            qty_pick_q1,
                                        a.numb03            qty_pick_q2,
                                        a.numb04            package_number,
                                        t.*,
                                        i.custom_code       i_custom_code,
                                        i.weight_net        i_weight_net
                            ----------------------------------------------------------------
                            FROM        VW_TRANSFER_ORACLE      a
                            INNER JOIN  VW_BLO_PICK_SHIPMENT    t   ON  t.idriga    =   a.numb01
                            INNER JOIN  ITEM                    i   ON  i.org_code  =   t.org_code
                                                                    AND i.item_code =   t.item_code
                            ;

    CURSOR C_SHIP_ORD       (           p_ref_shipment INTEGER)
                            IS
                            SELECT      sd.ref_shipment     ,
                                        sd.org_code         ,
                                        sd.order_code       ,
                                        SUM(sd.qty_doc)     qty_ship,
                                        SUM(d.qta)          qty_nom
                            --------------------------------------------------------------------------
                            FROM        SHIPMENT_DETAIL     sd
                            INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   sd.org_code
                                                                AND o.order_code    =   sd.order_code
                            LEFT JOIN   WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                            --------------------------------------------------------------------------
                            WHERE       sd.ref_shipment     =   p_ref_shipment
                            --------------------------------------------------------------------------
                            GROUP BY    sd.ref_shipment, sd.org_code, sd.order_code
                            ;

    CURSOR C_SHIP_PAST      (           p_org_code          VARCHAR2,
                                        p_order_code        VARCHAR2)
                            IS
                            SELECT      NVL(SUM(td.qty),0)  ship_qty
                            ---------------------------------------------------------------------------
                            FROM        WHS_TRN_DETAIL      td
                            ---------------------------------------------------------------------------
                            WHERE       td.org_code         =   p_org_code
                                AND     td.order_code       =   p_order_code
                                AND     td.reason_code      =   Pkg_Glb.C_M_OSHPPF
                            ;

    v_row_shp_h             SHIPMENT_HEADER%ROWTYPE;
    v_row_shp_d             SHIPMENT_DETAIL%ROWTYPE;
    v_row_ssh               SETUP_SHIPMENT%ROWTYPE;
    it_shp_d                Pkg_Rtype.ta_shipment_detail;
    it_shp_ord              Pkg_Rtype.ta_shipment_order;
    v_found                 BOOLEAN;
    v_ship_past             C_SHIP_PAST%ROWTYPE;
    v_idx                   PLS_INTEGER;

BEGIN

    Pkg_Err.p_reset_error_message();

    -- get the Shipment HEADER info
    v_row_shp_h.idriga  :=  p_ref_shipment;
    Pkg_Get.p_get_shipment_header(v_row_shp_h,-1);

    v_row_ssh.ship_type := v_row_shp_h.ship_type;
    IF Pkg_Get2.f_get_setup_shipment_2(v_row_ssh) THEN NULL; END IF;
    -- loop on the BLO_PICK_SHIPMENT
    FOR x IN C_LINES
    LOOP
        v_row_shp_d.ref_shipment        :=  p_ref_shipment;
        v_row_shp_d.org_code            :=  x.org_code;
        v_row_shp_d.item_code           :=  x.item_code;
        v_row_shp_d.colour_code         :=  x.colour_code;
        v_row_shp_d.size_code           :=  x.size_code;
        v_row_shp_d.oper_code_item      :=  x.oper_code_item;
        v_row_shp_d.description_item    :=  '';
        v_row_shp_d.season_code         :=  x.season_code;
        v_row_shp_d.whs_code            :=  x.whs_code;
        v_row_shp_d.order_code          :=  x.order_code;
        v_row_shp_d.group_code          :=  x.group_code;
        v_row_shp_d.group_code_out      :=  x.group_code;

        IF      v_row_ssh.extern    =   'Y'
            AND v_row_ssh.nature    =   'S' OR v_row_ssh.nature = 'T'
        THEN
            v_row_shp_d.custom_code         :=  NULL;
        ELSE
            v_row_shp_d.custom_code         :=  x.i_custom_code;
        END IF;

        v_row_shp_d.origin_code         :=  NULL;
        v_row_shp_d.uom_shipment        :=  x.puom;
        v_row_shp_d.puom                :=  x.puom;
        v_row_shp_d.package_code        :=  NULL;
        v_row_shp_d.note                :=  NULL;
        v_row_shp_d.package_number      :=  x.package_number;
        
        -- insert the quality 1 record
        IF NVL(x.qty_pick_q1,0) <> 0 THEN
            v_row_shp_d.qty_doc             :=  x.qty_pick_q1;
            v_row_shp_d.qty_doc_puom        :=  x.qty_pick_q1;
            v_row_shp_d.quality             :=  '1';
            v_row_shp_d.weight_net          :=  x.i_weight_net * x.qty_pick_q1;
            it_shp_d(it_shp_d.COUNT + 1)    :=  v_row_shp_d;
        END IF;
        -- insert the quality 2 record
        IF NVL(x.qty_pick_q2,0) <> 0 THEN
            v_row_shp_d.qty_doc             :=  x.qty_pick_q2;
            v_row_shp_d.qty_doc_puom        :=  x.qty_pick_q2;
            v_row_shp_d.quality             :=  '2';
            v_row_shp_d.weight_net          :=  x.i_weight_net * x.qty_pick_q2;
            it_shp_d(it_shp_d.COUNT + 1)    :=  v_row_shp_d;
        END IF;


        --pass trough the business logic
        Pkg_Shipment.p_shipment_detail_blo('I',it_shp_d(it_shp_d.COUNT));
        --
    END LOOP;
    --
    Pkg_Err.p_raise_error_message();
    --
    -- everything gone well => insert all the records in the SHIPMENT_DETAIL table
    Pkg_Iud.p_shipment_detail_miud('I',it_shp_d);

    -- SHIPMENT_ORDER structure
/*    v_idx   :=  0;
    FOR x IN C_SHIP_ORD (p_ref_shipment)
    LOOP
        v_idx   :=  v_idx + 1;

        it_shp_ord(v_idx).ref_shipment      :=  x.ref_shipment;
        it_shp_ord(v_idx).org_code          :=  x.org_code;
        it_shp_ord(v_idx).order_code        :=  x.order_code;

        -- determine the Past shipped quantity for the shipment work orders
        IF x.qty_ship <> x.qty_nom THEN
            OPEN    C_SHIP_PAST(x.org_code, x.order_code);
            FETCH   C_SHIP_PAST INTO v_ship_past; v_found:=C_SHIP_PAST%FOUND;
            CLOSE   C_SHIP_PAST;
            IF NOT v_found THEN v_ship_past.ship_qty := 0 ;END IF;
            -- if the past qty + the current shiped quantity doesn't fill the request => INCOMPLETE
            IF v_ship_past.ship_qty + x.qty_ship < x.qty_nom THEN
                it_shp_ord(v_idx).note  :=  'INCOMPLETE';
            ELSE
                it_shp_ord(v_idx).note  :=  'COMPLETE';
            END IF;
        ELSE
            it_shp_ord(v_idx).note  :=  'COMPLETE';
        END IF;
    END LOOP;
    Pkg_Iud.p_shipment_order_miud('I', it_shp_ord);
*/

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 10/04/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_pick_shipment    (   p_ref_shipment  INTEGER     ,
                                    p_whs_code      VARCHAR2    )
                                    RETURN          typ_frm     pipelined
----------------------------------------------------------------------------------
--  PURPOSE:    downloads the picking list for a shipment
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    CURSOR     C_LINES  IS
                        SELECT      *
                        FROM        VW_BLO_PICK_SHIPMENT
                        ORDER BY    seq_no ASC
                        ;

    v_row               tmp_frm             :=  tmp_frm();
    v_row_shp_h         SHIPMENT_HEADER%ROWTYPE;
    v_whs_code          VARCHAR2(100);

BEGIN

    v_row_shp_h.idriga  :=  p_ref_shipment;
    Pkg_Get.p_get_shipment_header(v_row_shp_h);

    --
    v_whs_code          :=  NVL(p_whs_code, 'EXP'); --- TEMPORARY !!!!!!!!!
    Pkg_Shipment.p_prepare_pick_shipment(   p_ref_shipment      ,
                                            v_row_shp_h.org_code,
                                            v_whs_code
                                         );
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  0;
        v_row.seq_no        :=  x.seq_no;
        --
        v_row.numb01        :=  p_ref_shipment  ;
        v_row.numb02        :=  x.selection     ;
        v_row.numb03        :=  x.qty           ;
        v_row.numb04        :=  x.qty_q1        ;   -- selected quantities
        v_row.numb05        :=  x.qty_q2        ;
        v_row.numb06        :=  x.qty_pick      ;
        --
        v_row.txt01         :=  x.org_code      ;
        v_row.txt02         :=  x.item_code     ;
        v_row.txt03         :=  x.description   ;
        v_row.txt04         :=  x.colour_code   ;
        v_row.txt05         :=  x.size_code     ;
        v_row.txt06         :=  x.order_code    ;
        v_row.txt07         :=  x.oper_code_item;
        v_row.txt08         :=  x.puom          ;
        v_row.txt09         :=  v_whs_code      ;
        v_row.txt10         :=  x.group_code    ;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************
    DDL: 11/04/2008  d Create procedure
/*********************************************************************************/
PROCEDURE p_shipment_order_iud  (p_tip VARCHAR2, p_row SHIPMENT_ORDER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in SHIPMENT_ORDER when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               SHIPMENT_ORDER%ROWTYPE;
BEGIN

    v_row   :=  p_row;

    Pkg_Iud.p_shipment_order_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;

/*********************************************************************************
    DDL: 11/04/2008  d Create procedure
/*********************************************************************************/
PROCEDURE p_prep_packlist   (   p_ref_shipment     INTEGER)
----------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for the PACKINGLIST report
--              and for the SHIPMENT_ORDER interface
----------------------------------------------------------------------------------
IS
    PRAGMA autonomous_TRANSACTION;

    CURSOR C_LINES          (           p_ref_shipment INTEGER)
                            IS
                            SELECT      sd.ref_shipment     ,
                                        so.idriga           ,
                                        MAX(sd.dcn)         dcn,
                                        MAX(sd.org_code)    org_code,
                                        MAX(sd.order_code)  order_code,
                                        MAX(sd.item_code)   item_code,
                                        MAX(sd.puom)        puom,
                                        SUM(sd.qty_doc)     qty_ship,
                                        MAX(so.note)        note,
                                        MAX(i.description)  i_description,
                                        (
                                            SELECT          SUM(d.qta)  qty_nom
                                            FROM            WO_DETAIL   d
                                            WHERE           d.ref_wo    =   o.idriga
                                        )                   qty_nom
                            --------------------------------------------------------------------------
                            FROM        SHIPMENT_DETAIL     sd
                            INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   sd.org_code
                                                                AND o.order_code    =   sd.order_code
                            LEFT JOIN   SHIPMENT_ORDER      so  ON  so.ref_shipment =   sd.ref_shipment
                                                                AND so.order_code   =   sd.order_code
                            INNER JOIN  ITEM                i   ON  i.org_code      =   o.org_code
                                                                AND i.item_code     =   o.item_code
                            --------------------------------------------------------------------------
                            WHERE       sd.ref_shipment     =   p_ref_shipment
                            --------------------------------------------------------------------------
                            GROUP BY    so.idriga,sd.ref_shipment, o.idriga
                            ;

    CURSOR C_PAST_SHIP      (           p_org_code          VARCHAR2,
                                        p_order_code        VARCHAR2,
                                        p_curr_ref_ship     NUMBER,
                                        p_curr_ship_date    DATE)
                            IS
                            SELECT      sh.ship_date        ,
                                        SUM(sd.qty_doc)     qty_doc
                            ---------------------------------------------------------------------------
                            FROM        SHIPMENT_DETAIL     sd
                            INNER JOIN  SHIPMENT_HEADER     sh  ON  sh.idriga   =   sd.ref_shipment
                            ---------------------------------------------------------------------------
                            WHERE       sh.status           NOT IN  ('I','C')
                                AND     sd.ORG_CODE         =   p_org_code
                                AND     sh.ship_type        IN  ('CL1')
                                AND     sd.order_code       =   p_order_code
                                AND     sd.ref_shipment     <>  p_curr_ref_ship
                                AND     sh.ship_date        <   p_curr_ship_date
                            GROUP BY    sh.ship_date
                            ORDER BY    sh.ship_date
                            ;

    CURSOR C_DET_Q          (   p_ref_shipment  INTEGER,
                                p_org_code      VARCHAR2,
                                p_order_code    VARCHAR2,
                                p_quality       VARCHAR2)
                            IS
                            SELECT      sd.size_code, sd.qty_doc
                            FROM        SHIPMENT_DETAIL     sd
                            WHERE       sd.ref_shipment     =   p_ref_shipment
                                AND     sd.order_code       =   p_order_code
                                AND     sd.org_code         =   p_org_code
                                AND     sd.quality          =   p_quality
                            ORDER BY size_code
                            ;

    CURSOR C_SHIP_INFO      (p_ref_shipment     NUMBER)
                            IS
                            SELECT      sh.*,
                                        os.org_name         os_org_name,
                                        ol.description      ol_description,
                                        ol.city             ol_city,
                                        ol.address          ol_address,
                                        ah.protocol_code    ah_protocol_code,
                                        ah.protocol_date    ah_protocol_date,
                                        ah.acrec_year       ah_acrec_year
                            ---------------------------------------------------------------------------
                            FROM        SHIPMENT_HEADER     sh
                            LEFT JOIN   ORGANIZATION        os  ON  os.org_code =   sh.org_code
                            LEFT JOIN   ORGANIZATION_LOC    ol  ON  ol.org_code =   sh.org_delivery
                                                                AND ol.loc_code =   sh.DESTIN_CODE
                            LEFT JOIN   ACREC_HEADER        ah  ON  ah.idriga   =   sh.ref_acrec
                            ---------------------------------------------------------------------------
                            WHERE       sh.idriga       =   p_ref_shipment
                            ;

    v_row                   VW_PREP_PACKLIST%ROWTYPE;
    v_past_ship             VARCHAR2(300);
    v_det_q2_1              VARCHAR2(300);
    v_det_q2_2              VARCHAR2(300);
    v_det_q1_1              VARCHAR2(300);
    v_det_q1_2              VARCHAR2(300);
    v_row_ish               C_SHIP_INFO%ROWTYPE;
    C_SEGMENT_CODE          VARCHAR2(32000)     :=  'VW_PREP_PACKLIST';

BEGIN

    DELETE FROM VW_PREP_PACKLIST;

    -- get SHIPMENT_HEADER info
    OPEN    C_SHIP_INFO     (p_ref_shipment);
    FETCH   C_SHIP_INFO     INTO    v_row_ish;
    CLOSE   C_SHIP_INFO     ;


    FOR x IN C_LINES(p_ref_shipment)
    LOOP

        -- Past shipments on the order
        v_past_ship         :=  '';
        FOR xx IN C_PAST_SHIP (x.org_code, x.order_code, p_ref_shipment,v_row_ish.ship_date)
        LOOP
            v_past_ship:=v_past_ship || xx.qty_doc||'P/'||TO_CHAR(xx.ship_date,'dd/mm/yyyy')||Pkg_Glb.C_NL;
        END LOOP;

        -- quality detailed
        v_det_q1_1      :=  '';
        v_det_q1_2      :=  '';
        v_det_q2_1      :=  '';
        v_det_q2_2      :=  '';

        FOR xx IN C_DET_Q (p_ref_shipment, x.org_code, x.order_code, '1')
        LOOP
            v_det_q1_1  :=  v_det_q1_1||LPAD(xx.size_code,  4,' ');
            v_det_q1_2  :=  v_det_q1_2||LPAD(xx.qty_doc,    4,' ');
        END LOOP;

        FOR xx IN C_DET_Q (p_ref_shipment, x.org_code, x.order_code, '2')
        LOOP
            v_det_q2_1  :=  v_det_q2_1||LPAD(xx.size_code,  4,' ');
            v_det_q2_2  :=  v_det_q2_2||LPAD(xx.qty_doc,    4,' ');
        END LOOP;

        v_row.idriga        :=  x.idriga;
        v_row.org_code      :=  x.org_code;
        v_row.item_code     :=  x.item_code;
        v_row.description   :=  x.i_description;
        v_row.order_code    :=  x.order_code;
        v_row.nom_qty       :=  x.qty_nom;
        v_row.um            :=  x.puom;
        v_row.past_ship     :=  v_past_ship;
        v_row.ship_qty      :=  x.qty_ship;
        v_row.detailed_q1   :=  v_det_q1_1 || Pkg_Glb.C_NL||v_det_q1_2;
        v_row.detailed_q2   :=  v_det_q2_1 || Pkg_Glb.C_NL||v_det_q2_2;
        v_row.segment_code  :=  C_SEGMENT_CODE;
        v_row.note          :=  x.note;
        v_row.ship_code_bc  :=  '('||v_row_ish.ship_code||')';
        v_row.ship_info     :=  RPAD('CLIENT:',15)      ||
                                v_row_ish.os_org_name   ||  Pkg_Glb.C_NL        ||
                                RPAD('SHIPMENT:',15)    ||
                                v_row_ish.ship_code     ||  ' / '               ||
                                TO_CHAR(v_row_ish.ship_date, 'dd-mm-yyyy')      ||Pkg_Glb.C_NL||
                                RPAD('Destination:',15) ||
                                v_row_ish.org_delivery  || ' / '||
                                v_row_ish.ol_description|| ' '                  ||Pkg_Glb.C_NL||
                                RPAD('Address:',15)     ||
                                v_row_ish.ol_city       || ' '  ||
                                v_row_ish.ol_address    ||      Pkg_Glb.C_NL    ||
                                RPAD('Invoice:',15)     ||
                                v_row_ish.ah_protocol_code      ||  ' / '       ||
                                TO_CHAR(v_row_ish.ah_protocol_date,'dd-mm-yyyy')||  ' / '   ||
                                v_row_ish.ah_acrec_year ||      Pkg_Glb.C_NL    ||
                                RPAD('Package:',15)     ||
                                'Nr ' || v_row_ish.package_number   || ' ' ||
                                'WeightNet ' || v_row_ish.weight_net       || ' ' ||
                                'WeightBrut ' || v_row_ish.weight_brut
                                ;


        INSERT INTO VW_PREP_PACKLIST VALUES  v_row;

    END LOOP;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 12/04/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_shipment_order   (   p_line_id       INTEGER     ,
                                    p_ref_shipment  INTEGER     DEFAULT NULL,
                                    p_ship_year     VARCHAR2    DEFAULT NULL
                                )   RETURN          typ_frm     pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    SHIPMENT ORDER data-source
--  INPUT:      REF_SHIPEMNT        = shipment id
----------------------------------------------------------------------------------
    CURSOR C_LINES  (p_line_id   INTEGER)
                    IS
                    SELECT      *
                    FROM        VW_PREP_PACKLIST    v
                    WHERE       v.idriga            =    NVL(p_line_id, v.idriga)
                    ORDER BY    order_code
                    ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN

    -- prepaire the informations for the SHIPMENT_ORDER form
    Pkg_Shipment.p_prep_packlist    (p_ref_shipment);

    --
    FOR x IN C_LINES(p_line_id)
    LOOP

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  0;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.item_code;
        v_row.txt03         :=  x.description;
        v_row.txt04         :=  x.order_code;
        v_row.txt05         :=  x.um;
        v_row.txt06         :=  x.past_ship;
        v_row.txt07         :=  x.detailed_q1;
        v_row.txt08         :=  x.detailed_q2;
        v_row.txt09         :=  x.collet;
        v_row.txt10         :=  x.note;
        v_row.numb01        :=  p_ref_shipment;
        v_row.numb02        :=  x.nom_qty;
        v_row.numb03        :=  x.ship_qty;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/******************************************************************************************************************
    DDL:    24/02/2008  z   Create procedure
            11/07/2008  d   modified the PACKAGE part (external function for SHIPMENT_ORDER + PACKAGE_HEADER update)
/*****************************************************************************************************************/
PROCEDURE p_shipment_from_warehouse (   p_ref_shipment      INTEGER ,
                                        p_date_legal        DATE    ,
                                        p_ignore_error      VARCHAR2
                                     )
/*----------------------------------------------------------------------------------
--  PURPOSE:    creates warehouse movement for a receit
                cleare what wil be the date legal
                cleare if we give a message for the differente between qty_doc and qty_count

                Description of SETUP_SHIPMENT

--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS

    CURSOR  C_LINES         (       p_idriga        INTEGER)
                            IS
                            SELECT  d.*
                            FROM        SHIPMENT_DETAIL     d
                            WHERE   ref_shipment     =   p_idriga
                            ;



    v_row_hed               SHIPMENT_HEADER%ROWTYPE;
    v_row_trn               VW_BLO_PREPARE_TRN%ROWTYPE;
    v_row_trh               WHS_TRN%ROWTYPE;
    v_row_ssh               SETUP_SHIPMENT%ROWTYPE;
    v_row_who               WAREHOUSE%ROWTYPE;
--    v_row_wrk               WORK_ORDER%ROWTYPE;
--    v_row_grp               WORK_GROUP%ROWTYPE;

    it_shp                  Pkg_Rtype.ta_shipment_detail;
    it_det                  Pkg_Rtype.ta_vw_blo_prepare_trn ;


    v_found                 BOOLEAN;
    v_idx                   PLS_INTEGER;
    C_SEGMENT_CODE          VARCHAR2(32000) :=  'VW_BLO_PREPARE_TRN';

    FUNCTION f_pkg_number (p_qty INTEGER) RETURN VARCHAR2
    IS
        v_rez   VARCHAR2(100);
    BEGIN
        v_rez   :=  TRUNC(p_qty / 12) || ' X 12';
        IF MOD(p_qty, 12) <> 0 THEN
            v_rez := v_rez || ' + '||MOD(p_qty, 12);
        END IF;
        RETURN v_rez;
    END;


BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_shipment IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o expeditie valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the shipment header
    v_row_hed.idriga    :=  p_ref_shipment;
    IF NOT Pkg_Get.f_get_shipment_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Expeditia cu identificatorul intern '
                                    || p_ref_shipment ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_shipment,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- if shipment was introduced in warehouse already
    IF v_row_hed.status <> 'I' THEN
        Pkg_Err.p_set_error_message
        (   p_err_code          => '00',
            p_err_header        => 'Expeditia nu este in starea corecta '
                                || 'pentru a descarca din magazie '
                                ||'(descarcat deja / facturat) '
                                ||'(trebuie sa fie in starea I ) !!!',
            p_err_detail        => NULL,
            p_flag_immediate    => 'Y'
        );
    END IF;
    --
    IF v_row_hed.status = 'I' AND v_row_hed.flag_package = 'N' THEN
        Pkg_Err.p_set_error_message
        (   p_err_code          => '00',
            p_err_header        => 'Detaliile expeditiei sunt nealiniate cu coletajul!!!',
            p_err_detail        => NULL,
            p_flag_immediate    => 'Y'
        );
    END IF;

    -- read  the shipment type line
    v_row_ssh.ship_type  :=  v_row_hed.ship_type;
    IF Pkg_Get2.f_get_setup_shipment_2(v_row_ssh) THEN NULL; END IF;
    -- read al shipment lines in memory
    OPEN    C_LINES(p_ref_shipment);
    FETCH   C_LINES  BULK COLLECT INTO it_shp;
    CLOSE   C_LINES;
    -- check if there are detail lines
    IF it_shp.COUNT = 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Expeditia nu are nici o linie de '
                                    ||' detaliu !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;

    -- check consistency
    -- call the same routin that checks the detail line when the line
    -- is created with the I - insert parameter
    FOR i IN 1..it_shp.COUNT LOOP
        Pkg_Shipment.p_shipment_detail_blo('I',it_shp(i));
    END LOOP;
    Pkg_Err.p_raise_error_message();
    --
    -- if this shipment type is with fifo processing do it
    IF v_row_ssh.fifo = 'Y' THEN
        Pkg_Shipment.p_download_fifo(
                                     p_ref_shipment     ,
                                     p_ignore_error     ,
                                     p_flag_commit  =>  FALSE
                                     );
    END IF;
    -- decide movement type
    v_row_trh.trn_type   :=     v_row_ssh.trn_type;

    v_row_trh.org_code      :=  v_row_hed.org_code;
    v_row_trh.flag_storno   :=  'N';
    v_row_trh.ref_shipment  :=  v_row_hed.idriga;
    v_row_trh.partner_code  :=  v_row_hed.org_client;
    v_row_trh.doc_year      :=  TO_CHAR(v_row_hed.ship_date,'YYYY');
    v_row_trh.doc_code      :=  v_row_hed.ship_code;
    v_row_trh.doc_date      :=  v_row_hed.ship_date;

    v_row_trh.date_legal    :=  p_date_legal;

    -- prepare the transaction detail data
    FOR i IN 1..it_shp.COUNT LOOP

        v_row_trn.segment_code          :=  C_SEGMENT_CODE;

        v_row_trn.org_code              :=  it_shp(i).org_code;
        v_row_trn.item_code             :=  it_shp(i).item_code;
        v_row_trn.colour_code           :=  it_shp(i).colour_code;
        v_row_trn.size_code             :=  it_shp(i).size_code;
        v_row_trn.oper_code_item        :=  it_shp(i).oper_code_item;
        v_row_trn.order_code            :=  it_shp(i).order_code;
        v_row_trn.group_code            :=  it_shp(i).group_code_out;
        v_row_trn.whs_code              :=  it_shp(i).whs_code;
        v_row_trn.season_code           :=  it_shp(i).season_code;

        v_row_trn.cost_center           :=  NULL;
        v_row_trn.puom                  :=  it_shp(i).puom;


        -- to determine the season code
        -- determin the reason code
        CASE
            WHEN    v_row_ssh.nature   =   'S' THEN
                 -- this is sales , we should have here the phinished products
                    v_row_trn.reason_code   :=  Pkg_Glb.C_M_OSHPPF;
            WHEN    v_row_ssh.nature   IN('T','R') THEN
                 -- this is transfer
                   IF v_row_ssh.out_proc = 'Y' THEN
                       -- here is transfer in outside processing
                       v_row_who.whs_code  :=  v_row_trn.whs_code;
                       IF Pkg_Get2.f_get_warehouse_2(v_row_who) THEN NULL; END IF;
                       CASE
                           WHEN v_row_who.category_code IN (Pkg_Glb.C_WHS_MPC ) THEN
                                    v_row_trn.reason_code   :=  Pkg_Glb.C_M_TSHPCTLCUST  ;
                           WHEN v_row_who.category_code IN (Pkg_Glb.C_WHS_MPP) THEN
                                    v_row_trn.reason_code   :=  Pkg_Glb.C_M_TSHPCTLPATR;
                           WHEN v_row_who.category_code IN (Pkg_Glb.C_WHS_PAT) THEN
                                    v_row_trn.reason_code   :=  Pkg_Glb.C_M_OAUXPATR;
                           WHEN     v_row_who.category_code IN (Pkg_Glb.C_WHS_WIP )
                                AND v_row_trn.order_code IS NOT NULL           THEN
                                    v_row_trn.reason_code   :=  Pkg_Glb.C_M_TSHPCTLSP;
                           WHEN     v_row_who.category_code IN (Pkg_Glb.C_WHS_WIP )
                                AND v_row_trn.order_code IS NULL           THEN
                                    v_row_trn.reason_code   :=  Pkg_Glb.C_M_TSHPCTLCUST;
                       END CASE;
                   ELSE
                        IF v_row_ssh.property = 'Y' THEN
                            v_row_trn.reason_code   :=  Pkg_Glb.C_M_OSHPMPP;
                        ELSE
                            -- here should be the back transfer to che client
                            v_row_trn.reason_code   :=  Pkg_Glb.C_M_OSHPMP;
                        END IF;
                   END IF;
            ELSE
                Pkg_Err.p_rae('Optiune CASE neimplementata: Shipment from warehouse -> reason_code');
        END CASE;

        v_row_trn.qty                   :=  it_shp(i).qty_doc_puom;
        v_row_trn.trn_sign              :=  -1;
        v_row_trn.ref_receipt           :=  NULL;

        it_det(it_det.COUNT+1)          :=  v_row_trn;
        --
        IF v_row_trh.trn_type = Pkg_Glb.C_TRN_SHP_CTL THEN
            -- this is a shipment to outside processing we have to prepare
            -- upload lines
            v_row_trn.trn_sign              :=  +1;
            v_row_trn.whs_code              :=  v_row_hed.whs_code;
            v_row_trn.group_code            :=  it_shp(i).group_code;
            -- determin the reason code
            CASE
                WHEN    v_row_trn.order_code IS NULL        THEN
                        IF v_row_trn.group_code IS NULL THEN
                            v_row_trn.reason_code   :=  Pkg_Glb.C_P_TSHPCTLMF;
                        ELSE
                            IF it_shp(i).group_code_out    IS  NULL THEN
                                v_row_trn.reason_code   :=  Pkg_Glb.C_P_TSHPCTLMO;
                            ELSE
                                v_row_trn.reason_code   :=  Pkg_Glb.C_P_TSHPCTLAO;
                            END IF;
                        END IF;
                WHEN    v_row_trn.order_code IS NOT NULL   THEN
                        v_row_trn.reason_code   :=  Pkg_Glb.C_P_TSHPCTLSP;
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
    Pkg_Mov.p_whs_trn_engine    (   p_row_trn   => v_row_trh    );

    --//////////////////////////////////////////////////////////////////////

    -- mark the shipment header as registered
    v_row_hed.status := 'M';
    Pkg_Iud.p_shipment_header_iud('U',v_row_hed);


    -- SHIPMENT_ORDER structure has to be filled only for sales shipment
    IF v_row_ssh.nature   =   'S' THEN
        Pkg_Shipment.p_shipment_order_generate(p_ref_shipment);
    END IF;

    -- update the discarded packages in M status
    UPDATE  PACKAGE_HEADER  h
    SET     h.status        =   'M'
    WHERE   EXISTS (SELECT  1
                    FROM    SHIPMENT_PACKAGE    p
                    WHERE   p.package_code      =   h.package_code
                        AND p.ref_shipment      =   p_ref_shipment)
    ;

    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:15/04/2008  z Create procedure
        29/05/2009  d canceled season_code matching for FIFO
        22/07/2009  d modify check if already FIFO for this shipment
                        -> only for Automatic created lines
/*********************************************************************************/
PROCEDURE p_download_fifo   (   p_ref_shipment      INTEGER,
                                p_ignore_error      VARCHAR2,
                                p_flag_commit       BOOLEAN DEFAULT TRUE,
                                p_flag_from_stage   BOOLEAN DEFAULT FALSE
                             )
/*----------------------------------------------------------------------------------
--  PURPOSE:    - makes the FIFO downloading for materials that are entered into the
                  organization(FILTY) by RECEIPT_HEADER/DETAIL and goes out from it by
                  SHIPMENT_HEADER/DETAIL
                - in SETUP_SHIPMENT there is a flag FIFO, the processing is made only
                  if FIFO = Y
                - there is a check if the shipment was already processed FIFO
                - in SHIPMENT_HEADER/DETAIL we can have:
                        * plain material return
                        * processed material return (items that has components)
                - based on the flag NATURE = S - sale or T - transfer in SETUP_SHIPMENT
                  we decide if we have to obtain the :
                        - list of components of the items (explode) -  S
                        - go on directly with the the items in SHIPMENT_DETAIL - T
                - for case S we use the bill of material associated to the WORK_GROUP,
                  BOM_GROUP, preparing in a view  VW_PREP_BOM_FIFO the bill of material
                  for every WORK_ORDER that will be used to explode the SHIPMENT_DETAIL lines
                - after that we prepare the list of items that will be downloaded in another
                  view VW_PREP_MATERIAL_FIFO;
                - there is a call to serialize the processing so at a time only 1 process
                  can read the FIFO stocks
                - the list of materials is loaded in a varchar2 indexed array, where a rounding
                  logic is applied, first there is a rounding to 4 decimals, after that for
                  materials that are pieces and are flaged FIFO_ROUND_UNIT = Y in the family
                  they are rounded to unit
                - the fifo stocs for these items are loaded in an other array, but only for receipt
                  that are registered (M or F) taking into consideration the QTY_DOC_PUOM !!!
                - after that there is a cycling on the list of material to download and for every
                  record quantity the process splits this quantity for available FIFO stocs and create
                  the download movement
                - if there are not stocks at all or enough stocks the system gathers these errors

--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS

    CURSOR  C_CHECK_PROCESSED(p_ref_shipment INTEGER) IS
            SELECT  COUNT(*) row_count
            FROM    FIFO_MATERIAL
            WHERE   ref_shipment    =   p_ref_shipment
                AND flag_manual     =   'N'
            ;

    CURSOR  C_CREATE_BOM (p_ref_shipment INTEGER) IS
            SELECT      t.org_code,t.order_code,
                        b.item_code,b.size_code,b.colour_code,b.oper_code_item,
                        b.start_size,b.end_size,
                        b.qta qty, b.oper_code,
                        i.puom,
                        m.fifo_round_unit
            FROM
                        (
                        SELECT  DISTINCT org_code,order_code
                        FROM    SHIPMENT_DETAIL
                        WHERE       ref_shipment    =   p_ref_shipment
                        )   t
            INNER JOIN  WO_GROUP    g
                            ON  g.org_code          =   t.org_code
                            AND g.order_code        =   t.order_code
            INNER JOIN  BOM_GROUP   b
                            ON  b.org_code          =   g.org_code
                            AND b.group_code        =   g.group_code
                            AND b.oper_code         =   g.oper_code
            INNER JOIN  ITEM        i
                            ON  i.org_code          =   b.org_code
                            AND i.item_code         =   b.item_code
            LEFT JOIN   CAT_MAT_TYPE m
                            ON  m.categ_code        =   i.mat_type
            ORDER BY    t.org_code,t.order_code,b.item_code,b.size_code,
                        b.colour_code,b.oper_code_item
            ;


    CURSOR  C_MATERIAL_TO_DOWNLOAD (
                                        p_selector     VARCHAR2,
                                        p_ref_shipment INTEGER
                                   ) IS
              SELECT      b.org_code,b.item_code,
                          b.colour_code         ,
                          b.size_code           ,
                          b.oper_code_item      ,
                          d.season_code         ,
                          MAX(b.puom)               puom,
                          MAX(b.fifo_round_unit)    fifo_round_unit,
                          SUM(d.qty_doc_puom * b.qty) qty,
                          max(nvl(d.custom_code, i.custom_code)) ship_subcat
              --------
              FROM        SHIPMENT_DETAIL       d
              INNER JOIN ITEM i ON i.org_code = d.org_code and i.item_code = d.item_code
              INNER JOIN  VW_PREP_BOM_FIFO      b
                                ON  b.org_code      =   d.org_code
                                AND b.order_code    =   d.order_code
                                AND d.size_code     BETWEEN NVL(b.start_size , Pkg_Glb.C_SIZE_MIN )
                                                            AND
                                                            NVL(b.end_size   , Pkg_Glb.C_SIZE_MAX )
                                AND d.size_code     LIKE NVL(b.size_code,'%')
              ----
              WHERE
                          p_selector          =   'S' -- finished products
                      AND d.ref_shipment      =   p_ref_shipment
              ----
              GROUP BY     b.org_code,
                           b.item_code,
                           b.colour_code,
                           b.size_code,
                           b.oper_code_item,
                           d.season_code
              ---------------------------------------------------------
              UNION ALL
              ---------------------------------------------------------
              SELECT    d.org_code,d.item_code,d.colour_code,d.size_code,
                        d.oper_code_item,
                        d.season_code,
                        d.puom,
                        'N' fifo_round_unit,
                        SUM(d.qty_doc_puom) qty,
                        max(nvl(d.custom_code, i.custom_code)) ship_subcat
              FROM      SHIPMENT_DETAIL     d
              INNER JOIN ITEM i ON i.org_code = d.org_code and i.item_code = d.item_code
              WHERE     p_selector          IN  ( 'T', 'R' ) -- plain material
                    AND d.ref_shipment      =   p_ref_shipment
              GROUP BY  d.org_code,d.item_code,d.colour_code,d.size_code ,
                        d.oper_code_item,d.puom,d.season_code
              -------------------------
              ORDER BY    org_code,item_code,colour_code,size_code,oper_code_item
              ;


    CURSOR  C_MATERIAL_TO_DOWNLOAD_AUX IS
              SELECT    *
              FROM      VW_PREP_MATERIAL_FIFO
              ORDER BY  org_code,item_code,colour_code,size_code,oper_code_item
              ;


    CURSOR  C_FIFO_STOC IS
              SELECT
                          MAX(d.idriga)           ref_receipt ,
                          MAX(d.org_code)         org_code    ,
                          MAX(d.item_code)        item_code   ,
                          MAX(d.colour_code)      colour_code ,
                          MAX(d.size_code)        size_code   ,
                          MAX(d.oper_code_item)   oper_code_item,
                          MAX(d.season_code)      season_code   ,
                          MAX(d.qty_doc_puom)     qty_in      ,
                          SUM(NVL(f.qty,0))       qty_out     ,
                          MAX(d.qty_doc_puom)
                          -   SUM(NVL(f.qty,0))   qty_stoc
              ---
              FROM
                        (
                         SELECT DISTINCT org_code, item_code
                         FROM  VW_PREP_MATERIAL_FIFO
                         ) s
              INNER JOIN    RECEIPT_DETAIL      d
                                ON  d.org_code      =   s.org_code
                                AND d.item_code     =   s.item_code
              INNER JOIN    RECEIPT_HEADER      h
                                ON h.idriga         =   d.ref_receipt
              INNER JOIN     WHS_TRN             t
                                ON  t.ref_receipt   =   h.idriga
              LEFT  JOIN    FIFO_MATERIAL       f
                                ON  f.ref_receipt   =   d.idriga
              WHERE             h.status        IN  ('M','F')
                            AND t.flag_storno   =   'N'
                            AND h.fifo          =   'Y'
              GROUP BY    d.idriga
              HAVING      MAX(d.qty_doc_puom) > SUM(NVL(f.qty,0))
              ORDER BY    MAX(d.item_code),MAX(d.colour_code),MAX(d.size_code),
                          MAX(d.oper_code_item),MAX(d.season_code),
                          MAX(t.date_legal), MAX(h.receipt_code), d.idriga
              ;


    v_count                 INTEGER;
    v_selector              VARCHAR2(1);

    TYPE    type_it         IS TABLE OF C_FIFO_STOC%ROWTYPE  INDEX BY BINARY_INTEGER;
    TYPE    type_it2        IS TABLE OF type_it  INDEX BY Pkg_Glb.type_index ;
    it_stoc                 type_it2;
    v_s                     C_FIFO_STOC%ROWTYPE;

    it_expl                 Pkg_Rtype.tas_fifo_exceding;
    it_fifo                 Pkg_Rtype.ta_fifo_material;

    v_row_hed               SHIPMENT_HEADER%ROWTYPE;
    v_row_ssh               SETUP_SHIPMENT%ROWTYPE;
    v_row                   FIFO_MATERIAL%ROWTYPE;
    v_part                  Pkg_Glb.type_index;

    C_DECIMALS              INTEGER         :=  4;
    C_FIFO_ROUND_UM1        VARCHAR2(10)    :=  'BC';
    C_FIFO_ROUND_UM2        VARCHAR2(10)    :=  'PZ';
  
    v_ship_stage            VARCHAR2(1);

    -------------------------------------------------------------------------------------------------------
    PROCEDURE   p_create_bom_for_fifo
    IS
        PRAGMA autonomous_transaction;

        v_row               VW_PREP_BOM_FIFO%ROWTYPE;
        C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_PREP_BOM_FIFO';
    BEGIN
        DELETE FROM VW_PREP_BOM_FIFO;

        FOR x IN C_CREATE_BOM (p_ref_shipment) LOOP

            v_row.org_code              :=  x.org_code;
            v_row.order_code            :=  x.order_code;
            v_row.item_code             :=  x.item_code;
            v_row.size_code             :=  x.size_code;
            v_row.colour_code           :=  x.colour_code;
            v_row.oper_code_item        :=  x.oper_code_item;
            v_row.start_size            :=  x.start_size;
            v_row.end_size              :=  x.end_size;
            v_row.oper_code             :=  x.oper_code;
            v_row.puom                  :=  x.puom;
            v_row.fifo_round_unit       :=  x.fifo_round_unit;
            v_row.qty                   :=  x.qty;
            v_row.segment_code          :=  C_SEGMENT_CODE;

            INSERT INTO VW_PREP_BOM_FIFO VALUES v_row;
        END LOOP;
        COMMIT;
    END;

    -------------------------------------------------------------------------------------------------------
    PROCEDURE   p_create_material_for_fifo
    IS
        PRAGMA autonomous_transaction;

        v_row               VW_PREP_MATERIAL_FIFO%ROWTYPE;
        C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_PREP_MATERIAL_FIFO';
    BEGIN
        DELETE FROM VW_PREP_MATERIAL_FIFO;

        FOR x IN C_MATERIAL_TO_DOWNLOAD (
                                            v_selector  ,
                                            p_ref_shipment
                                        )
        LOOP

            v_row.org_code              :=  x.org_code;
            v_row.item_code             :=  x.item_code;
            v_row.size_code             :=  x.size_code;
            v_row.colour_code           :=  x.colour_code;
            v_row.oper_code_item        :=  x.oper_code_item;
            v_row.season_code           :=  x.season_code;
            v_row.puom                  :=  x.puom;
            v_row.fifo_round_unit       :=  x.fifo_round_unit;
            v_row.qty                   :=  x.qty;
            v_row.ship_subcat           :=  x.ship_subcat;
            v_row.segment_code          :=  C_SEGMENT_CODE;

            INSERT INTO VW_PREP_MATERIAL_FIFO VALUES v_row;
        END LOOP;
        COMMIT;
    END;

    -------------------------------------------------------------------------------------------------------

BEGIN

    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_shipment IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o expeditie valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the shipment header
    v_row_hed.idriga    :=  p_ref_shipment;
    IF NOT Pkg_Get.f_get_shipment_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Expeditia cu identificatorul intern '
                                    || p_ref_shipment ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_shipment,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    -- read  the shipment type line
    v_row_ssh.ship_type  :=  v_row_hed.ship_type;
    IF Pkg_Get2.f_get_setup_shipment_2(v_row_ssh) THEN NULL; END IF;
    --
    IF      v_row_ssh.fifo    =   'N'
    THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Pentru acest tip de expeditie NU '
                                    || 'este valabila procedura FIFO '
                                    ||' !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    
    select nvl(max(description), 'N') into v_ship_stage from multi_table 
    where table_name = 'SYSPAR' and table_key = 'FLAG_SHIP_STAGE' and v_row_ssh.nature = 'S';
    --
    -- check if already was procesed
    IF NOT p_flag_from_stage AND v_ship_stage = 'N' THEN
        FOR x IN C_CHECK_PROCESSED(p_ref_shipment) LOOP
            v_count :=  x.row_count;
        END LOOP;
        IF v_count > 0 THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => '00',
                  p_err_header        => 'Expeditia a fost deja procesata '
                                        || 'FIFO '
                                        ||' !!!',
                  p_err_detail        => NULL,
                  p_flag_immediate    => 'Y'
             );
        END IF;
    END IF;
    -- establish what kind of shipment is to be processed
        -- with explosion
        -- with flat material
    v_selector  :=  v_row_ssh.nature;
    -- if shipment is for sales we have to prepare the bill of material
    IF  v_selector  = 'S' THEN
        p_create_bom_for_fifo();
    END IF;
    
    IF NOT p_flag_from_stage AND v_ship_stage = 'N' THEN
        -- create list of materials that are going to be downloaded
        p_create_material_for_fifo();
    END IF;

    -- lock the processing
    Pkg_Lib.p_locking_service('FIFO');    
    
    -- load the material that is going to be downloaded in FIFO
    FOR x IN C_MATERIAL_TO_DOWNLOAD_AUX LOOP

        v_part  :=  Pkg_Lib.f_str_idx(
                                        p_par1    =>    x.org_code      ,
                                        p_par2    =>    x.item_code     ,
                                        p_par3    =>    x.colour_code   ,
                                        p_par4    =>    x.size_code     ,
                                        p_par5    =>    x.oper_code_item /*,
                                        p_par6    =>    x.season_code */
                                     );
        IF it_expl.exists(v_part) THEN
            it_expl(v_part).qty             :=  NVL(it_expl(v_part).qty, 0) + x.qty;
        ELSE
            it_expl(v_part).qty             :=  x.qty;
        END IF;
        it_expl(v_part).ref_shipment    :=  p_ref_shipment;
        it_expl(v_part).org_code        :=  x.org_code;
        it_expl(v_part).item_code       :=  x.item_code;
        it_expl(v_part).oper_code_item  :=  x.oper_code_item;
        it_expl(v_part).size_code       :=  x.size_code;
        it_expl(v_part).colour_code     :=  x.colour_code;
        it_expl(v_part).season_code     :=  x.season_code;
        it_expl(v_part).puom            :=  x.puom;
        it_expl(v_part).ship_subcat     :=  x.ship_subcat;

        -- examine a logic of rounding for certain material types ?????????
        it_expl(v_part).qty :=  Pkg_Lib.f_round(it_expl(v_part).qty,C_DECIMALS);
        -- if primary unit is BC or PZ and there is flag
        -- FIFO_ROUND_UNIT for this material category then
        -- round to unit
        IF      x.puom IN (C_FIFO_ROUND_UM1,C_FIFO_ROUND_UM2)
            AND x.fifo_round_unit   =   'Y'
        THEN
            it_expl(v_part).qty :=  ROUND(it_expl(v_part).qty);
        END IF;


    END LOOP;
    ---
    -- load the fifo stocks
    FOR x IN C_FIFO_STOC LOOP

        v_part  :=  Pkg_Lib.f_str_idx(
                                        p_par1    =>    x.org_code      ,
                                        p_par2    =>    x.item_code     ,
                                        p_par3    =>    x.colour_code   ,
                                        p_par4    =>    x.size_code     ,
                                        p_par5    =>    x.oper_code_item /*,
                                        p_par6    =>    x.season_code */
                                     );

        IF it_stoc.EXISTS(v_part) THEN
            it_stoc(v_part)(it_stoc(v_part).COUNT + 1)    :=  x;
        ELSE
            it_stoc(v_part)(1)    :=  x;
        END IF;

    END LOOP;
    -----
    ---
    -- start the FIFO processing
    v_part  :=  it_expl.FIRST;
    WHILE v_part IS NOT NULL LOOP

        IF it_stoc.EXISTS(v_part) THEN
            FOR i IN 1..it_stoc(v_part).COUNT LOOP
                v_s :=  it_stoc(v_part)(i);
                --
                v_row.qty   :=  LEAST(v_s.qty_stoc, it_expl(v_part).qty);
                --
                it_expl(v_part).qty :=  it_expl(v_part).qty -   v_row.qty;
                v_s.qty_stoc        :=  v_s.qty_stoc        -   v_row.qty;
                it_stoc(v_part)(i)  :=  v_s;
                --
                IF v_row.qty    > 0 THEN
                    v_row.ref_shipment  :=  p_ref_shipment;
                    v_row.ref_receipt   :=  v_s.ref_receipt;
                    v_row.ship_subcat   :=  it_expl(v_part).ship_subcat;
                    v_row.flag_manual   :=  'N';
                    it_fifo(it_fifo.COUNT+1)    :=  v_row;
                END IF;
                --
            END LOOP;

            -- if remains material to download but there is no further stoc
            IF it_expl(v_part).qty > 0 THEN
                P_Sen('100',
                'Exista cantitati EXCEDENTARE in urma procesarii FIFO !!!',
                NULL
                );
            END IF;
        ELSE
            P_Sen('100',
            'Exista cantitati EXCEDENTARE in urma procesarii FIFO !!!',
            NULL
            );
        END IF;
        --
        v_part  :=  it_expl.NEXT(v_part);
        --
    END LOOP;
    --
    IF NVL(p_ignore_error,'N') = 'N' THEN
        Pkg_Err.p_raise_error_message();
    ELSE
        Pkg_Err.p_reset_error_message();
    END IF;
    --
    -- create the fifo lines
    Pkg_Iud.p_fifo_material_miud('I',it_fifo);
    --
    -- register the exceding quantities in FIFO_EXCEDING
    v_part  :=  it_expl.FIRST;
    WHILE v_part IS NOT NULL LOOP
        IF it_expl(v_part).qty > 0 THEN
            Pkg_Iud.p_fifo_exceding_iud('I',it_expl(v_part));
        END IF;
        v_part  :=  it_expl.NEXT(v_part);
    END LOOP;
    --

    IF p_flag_commit THEN  COMMIT; END IF;
    EXCEPTION
    WHEN OTHERS THEN
        IF p_flag_commit THEN ROLLBACK; END IF;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************
 DDL:   17/04/2008  z   Create procedure
        11/07/2008  d   added the update to V on PACKAGE_HEADER
        22/07/2009  d   delete from FIFO only the AUTO rows, let the MANUAL rows
/*********************************************************************************/
PROCEDURE p_shipment_undo   (   p_ref_shipment      INTEGER,
                                p_flag_confirm      VARCHAR2    )
----------------------------------------------------------------------------------
--  PURPOSE:    undo on shipment discharge from warehouse
--  INPUT:      REF_SHIPMENT  - id of the shipment to be storned
--              FLAG_CONFIRM
----------------------------------------------------------------------------------
IS

    -- this should return 1 line for the movement header asociated to
    -- the receipt that was not storned
    CURSOR C_LINES  (p_ref_shipment INTEGER)
                    IS
                    SELECT      *
                    FROM        WHS_TRN
                    WHERE       ref_shipment    =   p_ref_shipment
                        AND     flag_storno     =   'N'
                    ;

    v_row_hed       SHIPMENT_HEADER%ROWTYPE;
    it_wht          Pkg_Rtype.ta_whs_trn;
    v_row_ssh       SETUP_SHIPMENT%ROWTYPE;

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_shipment IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o expeditie valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the receit header
    v_row_hed.idriga    :=  p_ref_shipment;
    IF NOT Pkg_Get.f_get_shipment_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Expeditia cu identificatorul intern '
                                    || p_ref_shipment ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_shipment,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- is not posible to undo a receipt that was not registered
    IF v_row_hed.status <>   'M' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu se poate storna numai o expeditie '
                                    ||' care este in starea descarcata din magazie (stare M) !!!',
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
    --
    -- get the shipment type
    v_row_ssh.ship_type :=  v_row_hed.ship_type;
    IF Pkg_Get2.f_get_setup_shipment_2(v_row_ssh) THEN NULL; END IF;
    --
    -- get the movement header asociated with this receipt
    OPEN    C_LINES(p_ref_shipment);
    FETCH   C_LINES BULK COLLECT INTO it_wht;
    CLOSE   C_LINES;
    --
    IF it_wht.COUNT <> 1 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'EROARE SYSTEM (contactati furnizorul aplicatiei) '
                                    ||'!!!',
              p_err_detail        => 'Exista mai multe linii in WHS_TRN pentru expeditia '
                                    ||v_row_hed.ship_code
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
    Pkg_Iud.p_shipment_header_iud('U',v_row_hed);
    --
    -- if this shipment is with FIFO management delete the FIFO downloading
    IF v_row_ssh.fifo = 'Y' THEN
        DELETE FROM FIFO_MATERIAL
        WHERE       ref_shipment    =   p_ref_shipment
            AND     flag_manual     =   'N';
        ---
        DELETE FROM FIFO_EXCEDING
        WHERE       ref_shipment    =   p_ref_shipment;
    END IF;

    -- delete from
    DELETE
    FROM    SHIPMENT_ORDER
    WHERE   ref_shipment    =   p_ref_shipment;

    -- update the discarded packages in V status
    UPDATE  PACKAGE_HEADER  h
    SET     h.status        =   'V'
    WHERE   EXISTS (SELECT  1
                    FROM    SHIPMENT_PACKAGE    p
                    WHERE   p.package_code      =   h.package_code
                        AND p.ref_shipment      =   p_ref_shipment)
    ;


    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
/*********************************************************************************
 DDL: 19/04/2008  z Create procedure
      22/07/2009  d cancel from FIFO_MATERIAL
/*********************************************************************************/
PROCEDURE p_shipment_cancel (
                                p_ref_shipment      INTEGER,
                                p_flag_confirm      VARCHAR2
                            )
----------------------------------------------------------------------------------
--  PURPOSE:    cancel a SHIPMENT
--  INPUT:
----------------------------------------------------------------------------------
IS

    v_row_hed       SHIPMENT_HEADER%ROWTYPE;

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_ref_shipment IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe o expeditie valida !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the receit header
    v_row_hed.idriga    :=  p_ref_shipment;
    IF NOT Pkg_Get.f_get_shipment_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Expeditia cu identificatorul intern '
                                    || p_ref_shipment ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_shipment,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- is not posible to cancel a shipment unles it is in status I
    IF v_row_hed.status NOT IN ('I') THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu se poate anula expeditie '
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

    -- cancel from FIFO MATERIAL
    DELETE FROM FIFO_MATERIAL
    WHERE ref_shipment = p_ref_shipment;

    v_row_hed.status    :=  'X';
    Pkg_Iud.p_shipment_header_iud('U',v_row_hed);
    --


    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
/*********************************************************************************
    DDL: 07/04/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_shipment_fifo(p_line_id INTEGER,p_ref_shipment INTEGER DEFAULT NULL)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the SHIPMENT_DETAIL
--              for a receipt identified by ref_receipt
--  PREREQ:
--
--  INPUT:      REF_RECEIPT     =   an integer that is IDRIGA of the receipt
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_line_id INTEGER,p_ref_shipment INTEGER)   IS
                SELECT
                            f.idriga, f.dcn,
                            f.qty, f.flag_manual,f.ref_shipment,f.ref_receipt, f.ship_subcat, 
                            ---
                            h.receipt_code, h.receipt_date, h.org_code, h.receipt_type,
                            h.suppl_code, h.doc_number, h.doc_date, h.currency_code,
                            ---
                            d.puom, d.qty_doc_puom, d.item_code, d.colour_code,
                            d.size_code, d.oper_code_item, d.season_code, d.price_doc_puom ,
                            --
                            i.description   i_description,
                            --
                            c.description   c_description,
                            --
                            s.description   s_description ,s.property
                FROM        FIFO_MATERIAL       f
                INNER JOIN  RECEIPT_DETAIL      d
                                ON d.idriga         =   f.ref_receipt
                INNER JOIN  RECEIPT_HEADER      h
                                ON  h.idriga        =   d.ref_receipt
                INNER JOIN  SETUP_RECEIPT       s
                                ON  s.receipt_type  =   h.receipt_type
                INNER JOIN  ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT  JOIN  COLOUR              c
                                ON  c.org_code      =   d.org_code
                                AND c.colour_code   =   d.colour_code
                WHERE       f.ref_shipment      =   p_ref_shipment
                        AND p_line_id           IS  NULL
                ----------
                UNION ALL
                ---------
                SELECT
                            f.idriga, f.dcn,
                            f.qty, f.flag_manual,f.ref_shipment,f.ref_receipt, f.ship_subcat,
                            ---
                            h.receipt_code, h.receipt_date, h.org_code, h.receipt_type,
                            h.suppl_code, h.doc_number, h.doc_date, h.currency_code,
                            ---
                            d.puom, d.qty_doc_puom, d.item_code, d.colour_code,
                            d.size_code, d.oper_code_item, d.season_code, d.price_doc_puom ,
                            --
                            i.description   i_description,
                            --
                            c.description   c_description,
                            --
                            s.description   s_description ,s.property
                FROM        FIFO_MATERIAL       f
                INNER JOIN  RECEIPT_DETAIL      d
                                ON d.idriga         =   f.ref_receipt
                INNER JOIN  RECEIPT_HEADER      h
                                ON  h.idriga        =   d.ref_receipt
                INNER JOIN  SETUP_RECEIPT       s
                                ON  s.receipt_type  =   h.receipt_type
                INNER JOIN  ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT  JOIN  COLOUR              c
                                ON  c.org_code      =   d.org_code
                                AND c.colour_code   =   d.colour_code
                WHERE       f.idriga    =  p_line_id
                ---------------------------
                ORDER BY item_code, receipt_code
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_ref_shipment IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00',
             p_err_header        => 'Nu sunteti pozitionat pe o expeditie valida !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_line_id,p_ref_shipment) LOOP

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.item_code;
        v_row.txt03         :=  x.i_description;
        v_row.txt04         :=  x.colour_code;
        v_row.txt05         :=  x.c_description;
        v_row.txt06         :=  x.size_code;
        v_row.txt07         :=  x.oper_code_item;
        v_row.txt08         :=  x.season_code;
        v_row.txt09         :=  x.puom;
        v_row.txt10         :=  x.s_description;
        v_row.txt11         :=  x.receipt_code;
        v_row.txt12         :=  x.receipt_type;
        v_row.txt13         :=  x.suppl_code;
        v_row.txt14         :=  x.doc_number;
        v_row.txt15         :=  x.currency_code;
        v_row.txt16         :=  x.flag_manual;
        v_row.txt17         :=  x.property;
        v_row.txt18         :=  x.ship_subcat;

        v_row.numb01        :=  x.ref_shipment;
        v_row.numb02        :=  x.qty;
        v_row.numb03        :=  x.price_doc_puom;
        v_row.numb04        :=  x.ref_receipt;

        v_row.data01        :=  x.receipt_date;
        v_row.data02        :=  x.doc_date;

        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 19/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_fifo_material_iud(p_tip VARCHAR2, p_row FIFO_MATERIAL%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in shipment_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               FIFO_MATERIAL%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Shipment.p_fifo_material_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_fifo_material_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
  DDL:19/04/2008  z Create procedure
      22/07/2009  d let user introduce MANUAL rows for shipments in I
/*********************************************************************************/
PROCEDURE p_fifo_material_blo( p_tip   VARCHAR2, p_row IN OUT FIFO_MATERIAL%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in shipment_detail when is created , updated, deleted

--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    CURSOR      C_CHECK_FIFO_STOCK(p_ref_receipt INTEGER, p_idriga INTEGER) IS
                    SELECT  NVL(SUM(qty),0)    qty_out
                    FROM    FIFO_MATERIAL
                    WHERE       ref_receipt     =   p_ref_receipt
                            AND idriga          <>  NVL(p_idriga,-1)
                    ;



    v_row_hed       SHIPMENT_HEADER%ROWTYPE;
    v_row_ssh       SETUP_SHIPMENT%ROWTYPE;
    v_row_rec       RECEIPT_DETAIL%ROWTYPE;
    v_t             BOOLEAN;
    v_fifo_stock    NUMBER;

BEGIN
    --
    v_t :=  p_row.ref_shipment IS NULL;
    IF v_t THEN P_Sen('100',
     'Nu sunteti pozitionat pe o expeditie valida !!!',
      NULL
    );END IF;
    --
    v_row_hed.idriga    :=  p_row.ref_shipment;
    v_t :=  NOT Pkg_Get.f_get_shipment_header(v_row_hed);
    IF v_t THEN P_Sen('110',
     'Antetul de expeditie cu identificatorul '||v_row_hed.idriga||'nu exista in baza de date  !!!',
      v_row_hed.idriga
    );END IF;
    --
    v_t :=  v_row_hed.status NOT IN  ('I','M');
    IF v_t THEN P_Sen('120',
     'Nu puteti modifica descarcarile FIFO, expeditia nu este in stare corespunzatoare (trebuie sa fie in stare M sau I) !!!',
      v_row_hed.idriga
    );END IF;
    --
    IF p_tip IN ('I','U') THEN
        -- get the shipment type
        v_row_ssh.ship_type  :=  v_row_hed.ship_type;
        IF  Pkg_Get2.f_get_setup_shipment_2(v_row_ssh) THEN NULL; END IF;
        --
        v_t :=  v_row_ssh.fifo = 'N';
        IF v_t THEN P_Sen('130',
         'Acest tip de expeditie nu poate avea descarcari FIFO  !!!',
          v_row_hed.idriga
        );END IF;
        ----
        v_row_rec.idriga    :=  p_row.ref_receipt;
        v_t :=  NOT Pkg_Get.f_get_receipt_detail(v_row_rec);
        IF v_t THEN P_Sen('140',
         'Detaliu de receptie cu identificatorul intern (IDRIGA) :'||v_row_rec.idriga
         ||' nu exista in baza de date  !!!',
          v_row_hed.idriga
        );END IF;
        --
        v_t :=  NVL(p_row.qty,0) <= 0;
        IF v_t THEN P_Sen('150',
         'Nu se poate insera o cantitate zero sau negativa in descarcari FIFO !!!',
          v_row_hed.idriga
        );END IF;
        ---
        FOR x IN C_CHECK_FIFO_STOCK(p_row.ref_receipt , p_row.idriga) LOOP
            v_fifo_stock    :=  x.qty_out;
        END LOOP;
        v_fifo_stock    :=  NVL(v_fifo_stock,0);
        v_fifo_stock    :=  v_row_rec.qty_doc_puom - v_fifo_stock;
        v_t :=  p_row.qty > v_fifo_stock;
        IF v_t THEN P_Sen('160',
         'Pentru urmatoarele pozitii vreti sa descarcati mai mult decat stocul FIFO existent !!!',
          v_row_rec.item_code
          ||'  STOCK : '||v_fifo_stock
          ||'  DESC  : '||p_row.qty
        );END IF;
        ---
        p_row.flag_manual   :=   'Y';

    END IF;

    --
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 19/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_shipment_print( p_ref_shipment INTEGER)
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in shipment_detail when is created , updated, deleted

--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS

    CURSOR  C_LINES(p_ref_shipment INTEGER) IS
            SELECT      h.*,
                        ---
                        s.out_proc,
                        --
                        d.item_code,d.size_code,d.colour_code,d.oper_code_item,
                        d.season_code,d.qty_doc,d.uom_shipment,
                        --
                        i.description   i_description, i.mat_type,
                        --
                        c.org_name c_org_name,c.city c_city,c.address c_address,
                        c.fiscal_code c_fiscal_code,c.regist_code c_regist_code,
                        c.bank c_bank,c.bank_account c_bank_account,c.county c_county,
                        --
                        m.org_name m_org_name,m.city m_city,m.address m_address,
                        m.fiscal_code m_fiscal_code,m.regist_code m_regist_code,
                        m.bank m_bank,m.bank_account m_bank_account, m.county m_county,
                        --
                        r.description   r_description
            FROM        SHIPMENT_HEADER     h
            INNER JOIN  SETUP_SHIPMENT      s
                            ON  s.ship_type     =   h.ship_type
            INNER JOIN  SHIPMENT_DETAIL     d
                            ON  d.ref_shipment  =   h.idriga
            INNER JOIN  ITEM                i
                            ON  i.org_code      =   d.org_code
                            AND i.item_code     =   d.item_code
            LEFT JOIN   COLOUR              r
                            ON  r.org_code      =   d.org_code
                            AND r.colour_code   =   d.colour_code
            INNER JOIN  ORGANIZATION        c
                            ON  c.org_code      =   h.org_client
            INNER JOIN  ORGANIZATION_LOC    l
                            ON  l.org_code      =   h.org_delivery
                            AND l.loc_code      =   h.destin_code
            LEFT JOIN   ORGANIZATION        m
                            ON  m.org_code      =   Pkg_Glb.C_MYSELF
            WHERE       h.idriga  =   p_ref_shipment
            ORDER BY    d.oper_code_item, d.item_code,d.size_code
            ;

    v_row_hed           SHIPMENT_HEADER%ROWTYPE;

    x                   C_LINES%ROWTYPE;
    TYPE    type_it     IS TABLE OF     C_LINES%ROWTYPE     INDEX BY BINARY_INTEGER;
    it                  type_it;
    v_row               VW_REP_SHIPMENT%ROWTYPE;
    C_SEGMENT_CODE      VARCHAR2(32000) :=  'VW_REP_SHIPMENT';
    C_INDENT            INTEGER :=  15;
BEGIN
    --
    IF p_ref_shipment IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Nu sunteti pozitionat pe o expeditie valida !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    v_row_hed.idriga    :=  p_ref_shipment;
    IF NOT Pkg_Get.f_get_shipment_header(v_row_hed) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Antetul de expeditie cu identificatorul'
                                    ||' intern (IDRIGA) :'||v_row_hed.idriga
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => v_row_hed.idriga,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    IF v_row_hed.status NOT IN  ('M','F') THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Nu puteti tipari avizul de expeditie,  '
                                    ||'expeditia nu este descarcata din magazie '
                                    ||'!!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    OPEN    C_LINES(p_ref_shipment);
    FETCH   C_LINES BULK COLLECT INTO it;
    CLOSE   C_LINES;
    --
    IF it.COUNT = 0  THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Documentul de expeditie nu contine,  '
                                    ||'nici o linie de detaliu '
                                    ||'!!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    IF      v_row_hed.protocol_code  IS NULL
        OR  v_row_hed.protocol_date IS NULL
    THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Nu ati precizat data sau/si numarul ,  '
                                    ||'avizului de insotire marfa '
                                    ||'!!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'Y'
        );
    END IF;
    ---
    x   :=  it(1);

    Pkg_Lib.p_add_next(v_row.myself_identification,'Furnizor:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.myself_identification,x.m_org_name);
    Pkg_Lib.p_nl(v_row.myself_identification);
    Pkg_Lib.p_add_next(v_row.myself_identification,'Nr reg.com.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.myself_identification,x.m_regist_code);
    Pkg_Lib.p_nl(v_row.myself_identification);
    Pkg_Lib.p_add_next(v_row.myself_identification,'Nr inreg.fisc.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.myself_identification,x.m_fiscal_code);
    Pkg_Lib.p_nl(v_row.myself_identification);
    Pkg_Lib.p_add_next(v_row.myself_identification,'Sediul:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.myself_identification,x.m_address);
    Pkg_Lib.p_add_next(v_row.myself_identification,', '||x.m_city);
    Pkg_Lib.p_nl(v_row.myself_identification);
    Pkg_Lib.p_add_next(v_row.myself_identification,'Judetul.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.myself_identification,x.m_county);
    Pkg_Lib.p_nl(v_row.myself_identification);
    Pkg_Lib.p_add_next(v_row.myself_identification,'Contul.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.myself_identification,x.m_bank_account);
    Pkg_Lib.p_nl(v_row.myself_identification);
    Pkg_Lib.p_add_next(v_row.myself_identification,'Banca.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.myself_identification,x.m_bank);
    Pkg_Lib.p_nl(v_row.myself_identification);

    Pkg_Lib.p_add_next(v_row.client_identification,'Destinatar:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.client_identification,x.c_org_name);
    Pkg_Lib.p_nl(v_row.client_identification);
    Pkg_Lib.p_add_next(v_row.client_identification,'Nr reg.com.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.client_identification,x.c_regist_code);
    Pkg_Lib.p_nl(v_row.client_identification);
    Pkg_Lib.p_add_next(v_row.client_identification,'Nr inreg.fisc.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.client_identification,x.c_fiscal_code);
    Pkg_Lib.p_nl(v_row.client_identification);
    Pkg_Lib.p_add_next(v_row.client_identification,'Sediul:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.client_identification,x.c_address);
    Pkg_Lib.p_add_next(v_row.client_identification,', '||x.c_city);
    Pkg_Lib.p_nl(v_row.client_identification);
    Pkg_Lib.p_add_next(v_row.client_identification,'Judetul.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.client_identification,x.c_county);
    Pkg_Lib.p_nl(v_row.client_identification);
    Pkg_Lib.p_add_next(v_row.client_identification,'Contul.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.client_identification,x.c_bank_account);
    Pkg_Lib.p_nl(v_row.client_identification);
    Pkg_Lib.p_add_next(v_row.client_identification,'Banca.:',C_INDENT);
    Pkg_Lib.p_add_next(v_row.client_identification,x.c_bank);
    Pkg_Lib.p_nl(v_row.client_identification);


    Pkg_Lib.p_add_next(v_row.footer_identification,'Date privind expeditia:');
    Pkg_Lib.p_nl(v_row.footer_identification);
    Pkg_Lib.p_add_next(v_row.footer_identification,'Numele delegat:',20);
    Pkg_Lib.p_add_next(v_row.footer_identification,'...................');
    Pkg_Lib.p_nl(v_row.footer_identification);
    Pkg_Lib.p_add_next(v_row.footer_identification,'BI seria / numar:',20);
    Pkg_Lib.p_add_next(v_row.footer_identification,'...................');
    Pkg_Lib.p_nl(v_row.footer_identification);
    Pkg_Lib.p_add_next(v_row.footer_identification,'Mijloc transp :',20);
    Pkg_Lib.p_add_next(v_row.footer_identification,x.truck_number);
    Pkg_Lib.p_nl(v_row.footer_identification);
    Pkg_Lib.p_add_next(v_row.footer_identification,'Expedierea s-a efectuat in prezenta ');
    Pkg_Lib.p_nl(v_row.footer_identification);
    Pkg_Lib.p_add_next(v_row.footer_identification,'noastra la data de ');
    Pkg_Lib.p_add_next(v_row.footer_identification,TO_CHAR(x.protocol_date,'DD/MM/YYYY'));
    Pkg_Lib.p_nl(v_row.footer_identification);
    Pkg_Lib.p_add_next(v_row.footer_identification,'Semnaturile:',20);
    Pkg_Lib.p_add_next(v_row.footer_identification,'...................');

    Pkg_Lib.p_add_next(v_row.document_identification,'Numar:',10);
    Pkg_Lib.p_add_next(v_row.document_identification,x.protocol_code);
    Pkg_Lib.p_nl(v_row.document_identification);
    Pkg_Lib.p_add_next(v_row.document_identification,'Data:',10);
    Pkg_Lib.p_add_next(v_row.document_identification,TO_CHAR(x.protocol_date,'DD/MM/YYYY'));

    IF x.note IS NOT NULL THEN
        v_row.note  := 'OBSERVATII';
        Pkg_Lib.p_nl(v_row.note);
        v_row.note  := v_row.note|| '----------------------------';
        Pkg_Lib.p_nl(v_row.note,2);
        v_row.note  :=  v_row.note
                        ||x.note;
    END IF;

    DELETE FROM VW_REP_SHIPMENT;
    v_row.segment_code  :=  C_SEGMENT_CODE;
    FOR i IN 1..it.COUNT LOOP
        x   :=  it(i);

        v_row.seq_no        :=  i;
        v_row.description   :=  RPAD(x.item_code,15);

        IF x.oper_code_item IS NOT NULL THEN
            v_row.description   := v_row.description
                                ||' - '
                                ||x.oper_code_item;
            IF x.size_code IS NOT NULL THEN
                v_row.description   := v_row.description
                                    ||' - '
                                    ||'Mar:'
                                    ||x.size_code;
            END IF;
            v_row.description   := v_row.description
                                ||' - '
                                ||x.i_description;
        ELSE
            v_row.description   := v_row.description
                                    ||' - '
                                    ||x.mat_type;

            IF x.colour_code IS NOT NULL THEN
                v_row.description   := v_row.description
                                        ||' - '
                                        ||x.r_description;
            END IF;

            v_row.description   := v_row.description
                                    ||' - '
                                    ||x.i_description;
        END IF;

        v_row.uom           :=  x.uom_shipment;
        v_row.qty           :=  x.qty_doc;
        v_row.unit_price    :=  NULL;
        v_row.line_value    :=  NULL;
        v_row.total_value   :=  NULL;

        INSERT INTO VW_REP_SHIPMENT VALUES v_row;
    END LOOP;

    --
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 15/06/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_fifo_header    (     p_line_id       INTEGER ,
                                    p_org_code      VARCHAR2    DEFAULT NULL,
                                    p_yyyymm_start  VARCHAR2    DEFAULT NULL,
                                    p_yyyymm_end    VARCHAR2    DEFAULT NULL,
                                    p_suppl_code    VARCHAR2    DEFAULT NULL,
                                    p_season_code   VARCHAR2    DEFAULT NULL,
                                    p_description   VARCHAR2    DEFAULT NULL,
                                    p_flag_stock    VARCHAR2    DEFAULT NULL
                              )  RETURN typ_frm  pipelined
IS
    CURSOR     C_LINES (    p_line_id       INTEGER,
                            p_org_code      VARCHAR2,
                            p_start_Date    DATE,
                            p_end_Date      DATE, 
                            p_suppl_code    VARCHAR2,
                            p_season_code   VARCHAR2,
                            p_description   VARCHAR2
                        )   IS

                SELECT
                        d.idriga, d.dcn,
                        d.puom, d.qty_doc_puom, d.qty_count_puom, 
                        d.item_code, d.colour_code, d.size_code, 
                        d.oper_code_item, d.season_code, d.price_doc_puom,
                        d.uom_receipt, d.qty_doc, d.qty_count, d.price_doc,
                        --
                        h.receipt_code, h.receipt_date, h.org_code, h.receipt_type,
                        h.suppl_code, h.doc_number, h.doc_date, h.currency_code, h.fifo,
                        --
                        t.date_legal,
                        --
                        s.description  s_description,
                        --
                        i.description  i_description,
                        --
                        c.description   c_description,
                        --
                        (SELECT NVL(SUM(f.qty), 0)
                         FROM   FIFO_MATERIAL f
                         WHERE  f.ref_receipt = d.idriga) qty_fifo,
                        cr.exchange_rate
                FROM            RECEIPT_HEADER      h
                INNER   JOIN    WHS_TRN             t
                                ON  t.ref_receipt   =   h.idriga
                                AND t.flag_storno   =   'N'
                INNER   JOIN    RECEIPT_DETAIL      d
                                ON  d.ref_receipt   =   h.idriga
                INNER   JOIN    SETUP_RECEIPT       s
                                ON  s.receipt_type  =   h.receipt_type
                INNER   JOIN    ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT    JOIN    COLOUR              c
                                ON  c.org_code      =   d.org_code
                                AND c.colour_code   =   d.colour_code
                LEFT    JOIN    CURRENCY_RATE cr
                                ON cr.calendar_day  =   h.receipt_date
                                AND cr.currency_from =  h.currency_code
                                AND cr.currency_to  =   'RON'
                WHERE           h.status    <> 'X'
                        AND     t.date_legal between p_start_date and p_end_date
                        AND     h.org_code      =   p_org_code
                        AND     s.fifo          =   'Y'
                        AND     h.suppl_code    like p_suppl_code || '%'
                        AND     d.season_code   like NVL(p_season_code, '%')
                        AND     i.description   like p_description || '%'
                        AND     d.qty_doc_puom  >   0
                ---
                UNION ALL
                ---
                SELECT
                        d.idriga, d.dcn,
                        d.puom, d.qty_doc_puom, d.qty_count_puom,
                        d.item_code, d.colour_code, d.size_code, 
                        d.oper_code_item, d.season_code,d.price_doc_puom,
                        d.uom_receipt, d.qty_doc, d.qty_count, d.price_doc,
                        --
                        h.receipt_code, h.receipt_date, h.org_code, h.receipt_type,
                        h.suppl_code, h.doc_number, h.doc_date, h.currency_code, h.fifo,
                        --
                        t.date_legal,
                        --
                        s.description  s_description,
                        --
                        i.description  i_description,
                        --
                        c.description   c_description,
                        --
                        (SELECT NVL(SUM(f.qty),0)
                         FROM   FIFO_MATERIAL f
                         WHERE  f.ref_receipt = d.idriga) qty_fifo,
                        cr.exchange_rate
                FROM            RECEIPT_HEADER      h
                INNER   JOIN    WHS_TRN             t
                                ON  t.ref_receipt   =   h.idriga
                                AND t.flag_storno   =   'N'
                INNER   JOIN    RECEIPT_DETAIL      d
                                ON  d.ref_receipt   =   h.idriga
                INNER   JOIN    SETUP_RECEIPT       s
                                ON  s.receipt_type  =   h.receipt_type
                INNER   JOIN    ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT    JOIN    COLOUR              c
                                ON  c.org_code      =   d.org_code
                                AND c.colour_code   =   d.colour_code
                LEFT    JOIN    CURRENCY_RATE cr
                                ON cr.calendar_day  =   h.receipt_date
                                AND cr.currency_from =  h.currency_code
                                AND cr.currency_to  =   'RON'
                WHERE           d.idriga    =   p_line_id
                -------------
                ORDER BY date_legal, receipt_code,idriga
                ;
    --
    r                   tmp_frm             :=  tmp_frm();
    v_start_date  DATE;
    v_end_date    DATE;
    v_is_uom_diff   BOOLEAN;
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_org_code IS NULL THEN 
        P_Sey('00', 'Nu ati precizati gestiunea or anul_luna !!!'); 
    END IF;
    IF p_yyyymm_start IS NULL THEN 
        v_start_date := to_date('20000101', 'YYYYMMDD');
    ELSE
        v_start_Date := to_date(p_yyyymm_start||'01', 'YYYYMMDD');
    END IF;
    IF p_yyyymm_end IS NULL THEN 
        v_end_date := SYSDATE;
    ELSE
        v_end_Date := LAST_DAY(to_date(p_yyyymm_end||'01', 'YYYYMMDD'));
    END IF;
    --
    FOR x IN C_LINES( p_line_id,
                      p_org_code,
                      v_start_Date,
                      v_end_Date, 
                      p_suppl_code,
                      p_season_code,
                      p_description) 
    LOOP
        IF NVL(p_flag_stock, 'Y') = 'Y' OR x.qty_doc_puom > x.qty_fifo THEN
            v_is_uom_diff   := x.uom_receipt <> x.puom;
            --
            r.idriga        :=  x.idriga;
            r.dcn           :=  x.dcn;
            r.seq_no        :=  c_lines%rowcount;
            --
            r.txt01         :=  x.org_code;
            r.txt02         :=  TO_CHAR(x.date_legal, 'YYYYMM');
            r.txt03         :=  x.puom;
            r.txt04         :=  x.item_code;
            r.txt05         :=  x.colour_code;
            r.txt06         :=  x.size_code;
            r.txt07         :=  x.receipt_code;
            r.txt08         :=  x.receipt_type;
            r.txt09         :=  x.suppl_code;
            r.txt10         :=  x.doc_number;
            r.txt11         :=  x.currency_code;
            r.txt12         :=  x.fifo;
            r.txt13         :=  x.s_description;
            r.txt14         :=  x.i_description;
            r.txt15         :=  x.c_description;
            r.txt16         :=  x.season_code;
            r.txt17         :=  CASE WHEN v_is_uom_diff THEN x.uom_receipt END;
    
            r.numb01        :=  x.qty_doc_puom;
            r.numb02        :=  x.qty_fifo;
            r.numb03        :=  x.qty_doc_puom  -   x.qty_fifo;
            r.numb04        :=  r.numb03 * x.price_doc_puom;
            r.numb05        :=  r.numb04 * x.exchange_rate;
            r.numb06        :=  x.price_doc_puom;
            r.numb07        :=  CASE WHEN v_is_uom_diff THEN x.qty_doc END;
            r.numb08        :=  CASE WHEN v_is_uom_diff THEN x.price_doc END;
            r.numb09        :=  CASE WHEN v_is_uom_diff THEN (x.qty_doc_puom - x.qty_fifo) * x.qty_doc / x.qty_doc_puom END;
    
            r.data01        :=  x.doc_date;
            r.data02        :=  x.date_legal;
    
            pipe ROW(r);
        END IF;
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 15/06/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_fifo_detail    (     p_line_id       INTEGER ,
                                    p_ref_receipt   INTEGER     DEFAULT NULL
                              )  RETURN typ_frm  pipelined
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
                            p_ref_receipt   INTEGER
                        )   IS

                SELECT
                        f.idriga, f.dcn,
                        f.qty, f.ref_receipt, f.ref_shipment, f.note, f.flag_manual,
                        --
                        s.ship_code, s.ship_date, s.org_client, s.protocol_code s_protocol_code,
                        s.protocol_date s_protocol_date,s.ship_type,
                        --
                        h.acrec_code, h.acrec_date, h.protocol_code h_protocol_code,
                        h.protocol_date h_protocol_date,
                        --
                        e.description
                FROM            FIFO_MATERIAL       f
                INNER   JOIN    SHIPMENT_HEADER     s
                                ON  s.idriga        =   f.ref_shipment
                INNER   JOIN    SETUP_SHIPMENT      e
                                ON  e.ship_type     =   s.ship_type
                LEFT    JOIN    ACREC_HEADER        h
                                ON  h.idriga        =   s.ref_acrec
                WHERE       f.ref_receipt   =   p_ref_receipt
                ---
                UNION ALL
                --
                SELECT
                        f.idriga, f.dcn,
                        f.qty, f.ref_receipt, f.ref_shipment, f.note, f.flag_manual,
                        --
                        s.ship_code, s.ship_date, s.org_client, s.protocol_code,
                        s.protocol_date,s.ship_type,
                        --
                        h.acrec_code, h.acrec_date, h.protocol_code, h.protocol_date,
                        --
                        e.description
                FROM            FIFO_MATERIAL       f
                INNER   JOIN    SHIPMENT_HEADER     s
                                ON  s.idriga        =   f.ref_shipment
                INNER   JOIN    SETUP_SHIPMENT      e
                                ON  e.ship_type     =   s.ship_type
                LEFT    JOIN    ACREC_HEADER        h
                                ON  h.idriga        =   s.ref_acrec
                WHERE       f.idriga   =   p_line_id
                -------------
                ORDER BY ship_code
                ;
    --
    v_t                 BOOLEAN;
    r                   tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
--     v_t :=      p_line_id       IS NULL
--             AND (
--                 p_year_month    IS NULL
--                 OR
--                 p_org_code      IS NULL
--                 );
--     IF v_t THEN P_Sey('00',
--      'Nu ati precizati gestiunea or anul_luna !!!'
--     ); END IF;
    --
    FOR x IN C_LINES(p_line_id,p_ref_receipt) LOOP
        --
        r.idriga        :=  x.idriga;
        r.dcn           :=  x.dcn;
        r.seq_no        :=  c_lines%rowcount;
        --
        r.txt01         :=  x.note;
        r.txt02         :=  x.flag_manual;
        r.txt03         :=  x.ship_code;
        r.txt04         :=  x.org_client;
        r.txt05         :=  x.s_protocol_code;
        r.txt06         :=  x.acrec_code;
        r.txt07         :=  x.h_protocol_code;
        r.txt08         :=  x.ship_type;
        r.txt09         :=  x.description;

        r.numb01        :=  x.ref_receipt;
        r.numb02        :=  x.ref_shipment;
        r.numb03        :=  x.qty;

        r.data01        :=  x.ship_date;
        r.data02        :=  x.s_protocol_date;
        r.data03        :=  x.h_protocol_date;


        pipe ROW(r);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/************************************************************************************************
    DDL:    10/07/2008  d   Create procedure
/************************************************************************************************/
PROCEDURE p_shipment_from_package   (   p_ref_shipment  NUMBER,
                                        p_force         VARCHAR2)
--------------------------------------------------------------------------------------------------
--  PURPOSE:    creates the detail shipment lines, starting from the packages associated to the shipment
--------------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES      (p_ref_shipment NUMBER)
                        IS
                        SELECT      p.org_code, d.order_code, d.size_code, d.quality,
                                    MAX(o.item_code)        item_code,
                                    MAX(o.season_code)      season_code,
                                    MAX(i.puom)             i_puom,
                                    MAX(o.oper_code_item)   oper_code_item,
                                    SUM(d.qty)              qty_pkg,
                                    s.whs_code
                        --------------------------------------------------------------------
                        FROM        SHIPMENT_PACKAGE    p
                        INNER JOIN  PACKAGE_DETAIL      d   ON  d.package_code  =   p.package_code
                        INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   d.org_code
                                                            AND o.order_code    =   d.order_code
                        INNER JOIN  ITEM                i   ON  i.org_code      =   o.org_code
                                                            AND i.item_code     =   o.item_code
                        LEFT JOIN   STOC_ONLINE_PKG     s   ON  s.package_code  =   p.package_code
                        -----------------------------------------------------------------
                        WHERE       p.ref_shipment      =   p_ref_shipment
                        GROUP BY    p.org_code, d.order_code, d.size_code, d.quality, s.whs_code
                        ;

    CURSOR C_EX_DETAIL  (   p_ref_shipment  NUMBER)
                        IS
                        SELECT      *
                        FROM        SHIPMENT_DETAIL d
                        WHERE       ref_shipment    =   p_ref_shipment
                        ;

    CURSOR C_WHS_TRN    (p_ref_shipment NUMBER)
                        IS
                        SELECT      wth.idriga          wth_idriga
                        FROM        PACKAGE_TRN_HEADER  pth
                        INNER JOIN  WHS_TRN             wth ON  wth.idriga  =   pth.ref_whs_trn
                        WHERE       pth.ref_shipment    =   p_ref_shipment
                            AND     pth.trn_type        =   'TRN_SHIP'
                        ;

    v_row_shd           SHIPMENT_DETAIL%ROWTYPE;
    v_found             BOOLEAN;
    it_shd              Pkg_Rtype.ta_shipment_detail;
    v_idx               PLS_INTEGER;
    v_whs_exp           VARCHAR2(30);
    v_row_shh           SHIPMENT_HEADER%ROWTYPE;
    v_ref_trn_pkg       NUMBER;

BEGIN

    -- check if the shipment has already discharged the warehouse or an invoice was generated
    v_row_shh.idriga    :=  p_ref_shipment;
    Pkg_Get.p_get_shipment_header(v_row_shh,-1);
    IF v_row_shh.status NOT IN ('I') THEN
        Pkg_Err.p_rae('Expeditia este descarcata sau chiar facturata! Nu se mai pot modifica datele!');
    END IF;

    OPEN    C_EX_DETAIL(p_ref_shipment);
    FETCH   C_EX_DETAIL INTO v_row_shd;
    v_found :=  C_EX_DETAIL%FOUND;
    CLOSE   C_EX_DETAIL;

    IF v_found THEN
        IF NVL(p_force,'N') = 'N' THEN
            Pkg_Err.p_rae('Aveti deja linii in detaliile de expeditie !');
        ELSE
            -- delete the PKG generated lines from PACKAGE detail
            DELETE
            FROM    SHIPMENT_DETAIL
            WHERE   ref_shipment    =   p_ref_shipment
                AND line_source     =   'PKG'
            ;

            -- UNDO the transaction movements generated by this shipment
            FOR x IN C_WHS_TRN (p_ref_shipment)
            LOOP
                Pkg_Mov.p_storno(p_ref_trn => x.wth_idriga, p_commit => FALSE);
            END LOOP;
        END IF;
    END IF;

    v_whs_exp  :=  Pkg_Order.f_get_default_whs_fin(Pkg_Nomenc.f_get_myself_org());


    -- generate the EXP stock !!!
    Pkg_Scan.p_gen_package_trn(p_ref_shipment,v_whs_exp,v_ref_trn_pkg);
    Pkg_Scan.p_package_mov(v_ref_trn_pkg,v_whs_exp,'N');


    FOR x IN C_LINES (p_ref_shipment)
    LOOP
        v_idx                       :=  it_shd.COUNT + 1;
        it_shd(v_idx).ref_shipment  :=  p_ref_shipment;
        it_shd(v_idx).org_code      :=  x.org_code;
        it_shd(v_idx).item_code     :=  x.item_code;
        it_shd(v_idx).oper_code_item:=  x.oper_code_item;
        it_shd(v_idx).size_code     :=  x.size_code;
        it_shd(v_idx).season_code   :=  x.season_code;
        it_shd(v_idx).whs_code      :=  v_whs_exp;
        it_shd(v_idx).order_code    :=  x.order_code;
        it_shd(v_idx).qty_doc       :=  x.qty_pkg;
        it_shd(v_idx).uom_shipment  :=  x.i_puom;
        it_shd(v_idx).qty_doc_puom  :=  x.qty_pkg;
        it_shd(v_idx).puom          :=  x.i_puom;
        it_shd(v_idx).quality       :=  x.quality;
        it_shd(v_idx).weight_net    :=  0;
        it_shd(v_idx).line_source   :=  'PKG';

    END LOOP;

    Pkg_Iud.p_shipment_detail_miud('I',it_shd);

    -- generate the packing list informations (SHIPMENT ORDER structure )
    Pkg_Shipment.p_shipment_order_generate(p_ref_shipment);

    -- set the Shipment_header.FLAG_PACKAGE to processed (Valid)
    v_row_shh.flag_package := 'V';

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/************************************************************************************************
    DDL:    10/07/2008  d   Create procedure
/************************************************************************************************/
PROCEDURE p_shipment_order_generate     (p_ref_shipment INTEGER)
IS

    CURSOR C_SHIP_ORD       (           p_ref_shipment INTEGER)
                            IS
                            SELECT      sd.ref_shipment     ,
                                        sd.org_code         ,
                                        sd.order_code       ,
                                        SUM(sd.qty_doc)     qty_ship,
                                        (   SELECT      SUM(d.qta)
                                            FROM        WO_DETAIL d
                                            WHERE       ref_wo = o.idriga)   qty_nom
                            --------------------------------------------------------------------------
                            FROM        SHIPMENT_DETAIL     sd
                            INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   sd.org_code
                                                                AND o.order_code    =   sd.order_code
                            --------------------------------------------------------------------------
                            WHERE       sd.ref_shipment     =   p_ref_shipment
                            --------------------------------------------------------------------------
                            GROUP BY    sd.ref_shipment, sd.org_code, sd.order_code, o.idriga
                            ;

    CURSOR C_SHIP_PAST      (           p_org_code          VARCHAR2,
                                        p_order_code        VARCHAR2)
                            IS
                            SELECT      NVL(SUM(td.qty),0)  ship_qty
                            ---------------------------------------------------------------------------
                            FROM        WHS_TRN_DETAIL      td
                            ---------------------------------------------------------------------------
                            WHERE       td.org_code         =   p_org_code
                                AND     td.order_code       =   p_order_code
                                AND     td.reason_code      =   Pkg_Glb.C_M_OSHPPF
                            ;

    CURSOR C_PKG            (           p_org_code          VARCHAR2,
                                        p_order_code        VARCHAR2,
                                        p_ref_shipment      NUMBER
                            )
                            IS
                            SELECT      qty, COUNT(1) pkg_number
                            FROM
                            (
                            SELECT      p.package_code, SUM(d.qty)  qty
                            FROM        SHIPMENT_PACKAGE    p
                            INNER JOIN  PACKAGE_DETAIL      d   ON  d.package_code  =   p.package_code
                            WHERE       d.org_code          =   p_org_code
                                AND     d.order_code        =   p_order_code
                                AND     p.ref_shipment      =   p_ref_shipment
                            GROUP BY    p.package_code
                            )
                            GROUP BY    qty
                            ;


    it_shp_ord              Pkg_Rtype.ta_shipment_order;
    v_ship_past             C_SHIP_PAST%ROWTYPE;
    v_idx                   PLS_INTEGER;
    v_found                 BOOLEAN;
BEGIN

    -- first, delete the existing rows for this shipment, if exists
    DELETE
    FROM    SHIPMENT_ORDER
    WHERE   ref_shipment    =   p_ref_shipment
    ;

    v_idx   :=  0;
    FOR x IN C_SHIP_ORD (p_ref_shipment)
    LOOP
        v_idx   :=  v_idx + 1;

        it_shp_ord(v_idx).ref_shipment      :=  x.ref_shipment;
        it_shp_ord(v_idx).org_code          :=  x.org_code;
        it_shp_ord(v_idx).order_code        :=  x.order_code;

        -- determine the Past shipped quantity for the shipment work orders
        IF x.qty_ship <> x.qty_nom THEN
            OPEN    C_SHIP_PAST(x.org_code, x.order_code);
            FETCH   C_SHIP_PAST INTO v_ship_past; v_found:=C_SHIP_PAST%FOUND;
            CLOSE   C_SHIP_PAST;
            IF NOT v_found THEN v_ship_past.ship_qty := 0 ;END IF;
            -- if the past qty + the current shiped quantity doesn't fill the request => INCOMPLETE
            IF NVL(v_ship_past.ship_qty, 0) + x.qty_ship < x.qty_nom THEN
                it_shp_ord(v_idx).note  :=  'INCOMPLETE';
            ELSE
                it_shp_ord(v_idx).note  :=  'COMPLETE';
            END IF;
        ELSE
            it_shp_ord(v_idx).note  :=  'COMPLETE';
        END IF;
        -- add the packages number to NOTE
        --it_shp_ord(v_idx).note  :=  it_shp_ord(v_idx).note || Pkg_Glb.C_NL || f_pkg_number(x.qty_ship);
        FOR xx IN C_PKG (x.org_code, x.order_code,x.ref_shipment)
        LOOP
            it_shp_ord(v_idx).note := it_shp_ord(v_idx).note || Pkg_Glb.C_NL ||xx.pkg_number||' X '||xx.qty;
        END LOOP;

    END LOOP;
    Pkg_Iud.p_shipment_order_miud('I', it_shp_ord);
END;

/************************************************************************************************
    DDL:    20/01/2009  d   Create procedure
/************************************************************************************************/
PROCEDURE p_rep_deliv_order (   p_ref_ship NUMBER)
IS
    CURSOR C_EXP    (p_ref_ship NUMBER)
                    IS
                    SELECT      d.org_code, d.item_code,
                                '-' size_code,
                                SUM(d.qty_doc)      qty_doc,
                                MAX(i.puom)         i_puom,
                                MAX(i.description)  i_descr,
                                MAX(i.root_code)    i_family,
                                MAX(i.account_analytic) i_acc_an
                    FROM        SHIPMENT_DETAIL d
                    INNER JOIN  ITEM            i   ON  i.org_code      =   d.org_code
                                                    AND i.item_code     =   d.item_code
                    WHERE       d.ref_shipment  =   p_ref_ship
                    GROUP BY    d.org_code, d.item_code
                    ORDER BY    1, 2
                    ;

    CURSOR C_CST        (   p_org_code      VARCHAR2,
                            p_item_code     VARCHAR2,
                            p_family_code   VARCHAR2,
                            p_client_code   VARCHAR2,
                            p_ref_date      DATE)
                        IS
                        SELECT      k.unit_cost
                        FROM        ITEM_COST       k
                        WHERE       k.cost_code     =   'PF_SEL'
                            AND     k.org_code      =   p_org_code
                            AND     k.item_code     =   p_item_code
                            AND     p_client_code   =   NVL(k.partner_code, p_client_code)
                            AND     p_ref_date  BETWEEN k.start_date AND NVL(k.end_date, p_ref_date + 1)
                        UNION ALL
                        SELECT      k.unit_cost
                        FROM        ITEM_COST       k
                        WHERE       k.cost_code     =   'PF_SEL'
                            AND     k.org_code      =   p_org_code
                            AND     k.family_code   =   p_family_code
                            AND     p_client_code   =   NVL(k.partner_code, p_client_code)
                            AND     p_ref_date  BETWEEN k.start_date AND NVL(k.end_date, p_ref_date + 1)
                        ;

    v_row_shh       SHIPMENT_HEADER%ROWTYPE;
    v_row_my        ORGANIZATION%ROWTYPE;
    v_row_cl        ORGANIZATION%ROWTYPE;
    it_rep          Pkg_Rtype.ta_vw_rep_deliv;
    idx             PLS_INTEGER;
    ix_cst          VARCHAR2(50);
    it_cst          Pkg_Glb.typ_number_varchar;
    C_segment_code  VARCHAR2(100)   :=  'VW_REP_DELIV';
BEGIN
    DELETE FROM VW_REP_DELIV;

    v_row_shh.idriga        :=  p_ref_ship;
    Pkg_Get.p_get_shipment_header(v_row_shh,0);
    v_row_my.org_code       :=  Pkg_Nomenc.f_get_myself_org;
    Pkg_Get2.p_get_organization_2(v_row_my);
    v_row_cl.org_code       :=  v_row_shh.org_client;
    Pkg_Get2.p_get_organization_2(v_row_cl);

    idx                     :=  1;
    it_rep(idx).line_seq    :=  idx;
    it_rep(idx).org_code    :=  v_row_my.org_code;
    it_rep(idx).org_name    :=  v_row_my.org_name;
    it_rep(idx).doc_number  :=  NVL(v_row_shh.protocol_code2, NVL(v_row_shh.protocol_code, v_row_shh.ship_code));
    it_rep(idx).client_name :=  v_row_shh.org_client;
    it_rep(idx).deleg_text  :=  ' Veti elibera produsele de mai jos catre '
                                ||NVL(v_row_cl.org_name,'_______________________________')--||Pkg_Glb.C_NL
                                ||' prin delegatul_'
                                ||NVL(NULL,'_______________________________')
                                ||' cu delegatia_'
                                ||NVL(NULL,'____________')--||Pkg_Glb.C_NL
                                ||' buletin de identitate seria_'
                                ||NVL(NULL,'______')
                                ||' nr_'
                                ||NVL(NULL,'_____________')--||Pkg_Glb.C_NL
                                ||' emis de_'
                                ||NVL(NULL,'_____________');
    it_rep(idx).doc_date    :=  v_row_shh.ship_date;
    it_rep(idx).SEGMENT_CODE    :=  C_SEGMENT_CODE;

    FOR x IN C_EXP(p_ref_ship)
    LOOP
        ix_cst  :=  x.item_code;
        IF NOT it_cst.EXISTS(ix_cst) THEN
            OPEN C_CST( p_org_code      =>  x.org_code,
                        p_item_code     =>  x.item_code,
                        p_family_code   =>  x.i_family,
                        p_client_code   =>  v_row_shh.org_client,
                        p_ref_date      =>  v_row_shh.ship_date);
            FETCH   C_CST INTO it_cst(ix_cst);
            CLOSE   C_CST;
        END IF;

        idx                     :=  C_EXP%rowcount;
        it_rep(idx).line_seq    :=  idx;
        it_rep(idx).item_code   :=  x.item_code;
        IF x.org_code = 'ALT' THEN
            it_rep(idx).item_descr  :=  RPAD(x.item_code, 30, ' ') || ' - ' || x.i_family;
        ELSE
            it_rep(idx).item_descr  :=  RPAD(x.i_descr,60,' ')||x.size_code;
        END IF;
        it_rep(idx).puom_code   :=  x.i_puom;
        it_rep(idx).account_code:=  x.i_acc_an;
        it_rep(idx).qty_dispose :=  x.qty_doc;
        it_rep(idx).qty_deliver :=  x.qty_doc;
        it_rep(idx).unit_price  :=  Pkg_Lib.f_table_value(it_cst,ix_cst,0);
        --if it_rep(idx).unit_price = 0 then it_rep(idx).unit_price := null; end if;

        it_rep(idx).SEGMENT_CODE    :=  C_SEGMENT_CODE;
    END LOOP;

    Pkg_Iud.p_vw_rep_deliv_miud('I',it_rep);

END;

/*******************************************************************************
    DDL:    13/07/2009 d Create
/*******************************************************************************/
PROCEDURE p_rep_fifo_reg    (   p_org_code      VARCHAR2,
                                p_start_date    DATE,
                                p_end_date      DATE)
--------------------------------------------------------------------------------
IS

    CURSOR C_IN (p_org_code VARCHAR2, p_start_date DATE, p_end_date DATE)
                IS
                select      h.receipt_date, h.doc_number, h.doc_date, d.qty_doc_puom,
                            d.uom_receipt, d.item_code, d.custom_code, d.price_doc_puom,
                            i.description item_descr, d.colour_code, d.size_code,d.season_code,
                            i.puom
                from        RECEIPT_HEADER  h
                INNER JOIN  RECEIPT_DETAIL  d   ON  d.ref_receipt   =   h.idriga
                INNER JOIN  ITEM            i   ON  i.org_code      =   d.org_code
                                                AND i.item_code     =   d.item_code
                WHERE       h.org_code      =   p_org_code
                    AND     h.receipt_date  BETWEEN p_start_date
                                            AND     p_end_date
                    AND     h.FIFO          =   'Y'
                    AND     h.status        =   'M'
                ORDER BY    h.receipt_date, h.doc_number, d.item_code
                ;

    CURSOR C_OUT (p_org_code VARCHAR2, p_start_date DATE, p_end_date DATE)
                IS
                select      f.qty, s.ship_date, rd.item_code, i.description item_descr,
                            rd.size_code, rd.colour_code, rd.season_code,
                            rd.price_doc_puom, ar.protocol_code, ar.protocol_date,
                            i.puom
                from        FIFO_MATERIAL       f
                inner join  SHIPMENT_HEADER     s   ON  s.idriga    =   f.ref_shipment
                inner join  RECEIPT_DETAIL      rd  ON  rd.idriga   =   f.ref_receipt
                inner join  ACREC_HEADER        ar  ON  ar.idriga   =   s.ref_acrec
                inner join  ITEM                i   ON  i.org_code  =   rd.ORG_CODE
                                                    AND i.item_code =   rd.item_code
                where       s.ship_date between  p_start_date
                                            AND  p_end_date
                    AND     s.org_code  =   p_org_code
                ORDER BY    s.ship_date, s.ship_code, rd.item_code
                ;

    it_rep      Pkg_Rtype.ta_vw_rep_fifo_reg;
    ix_rep      PLS_INTEGER;
    C_SEGMENT   VARCHAR2(30)    :=  'VW_REP_FIFO_REG';
BEGIN
    DELETE from VW_REP_FIFO_REG;
    FOR x IN C_IN (p_org_code, p_start_date, p_end_date)
    LOOP
        ix_rep      :=  it_rep.count + 1;
        it_rep(ix_rep).seq_no       :=  C_IN%ROWCOUNT;
        it_rep(ix_rep).segment_code :=  C_SEGMENT;
        it_rep(ix_rep).inout        :=  'IN';
        it_rep(ix_rep).partner_name :=  p_org_code;
        it_rep(ix_rep).partner_addr :=  NULL;
        it_rep(ix_rep).item_code    :=  x.item_code;
        it_rep(ix_rep).item_descr   :=  x.item_descr;
        it_rep(ix_rep).uom          :=  x.puom;
        it_rep(ix_rep).doc_code     :=  x.doc_number;
        it_rep(ix_rep).data_doc     :=  x.doc_date;
        it_rep(ix_rep).data_inout   :=  x.receipt_date;
        it_rep(ix_rep).qty          :=  x.qty_doc_puom;
        it_rep(ix_rep).val          :=  x.qty_doc_puom * x.price_doc_puom;
    END LOOP;
    Pkg_iud.p_vw_rep_fifo_reg_miud('I', it_rep);
    it_rep.delete;

    FOR x IN C_OUT (p_org_code, p_start_date, p_end_date)
    LOOP
        ix_rep      :=  it_rep.count + 1;
        it_rep(ix_rep).seq_no       :=  C_OUT%ROWCOUNT;
        it_rep(ix_rep).segment_code :=  C_SEGMENT;
        it_rep(ix_rep).inout        :=  'OUT';
        it_rep(ix_rep).partner_name :=  p_org_code;
        it_rep(ix_rep).partner_addr :=  NULL;
        it_rep(ix_rep).item_code    :=  x.item_code;
        it_rep(ix_rep).item_descr   :=  x.item_descr;
        it_rep(ix_rep).uom          :=  x.puom;
        it_rep(ix_rep).doc_code     :=  x.protocol_code;
        it_rep(ix_rep).data_doc     :=  x.protocol_date;
        it_rep(ix_rep).data_inout   :=  x.ship_date;
        it_rep(ix_rep).qty          :=  x.qty;
        it_rep(ix_rep).val          :=  x.qty * x.price_doc_puom;
    END LOOP;
    Pkg_iud.p_vw_rep_fifo_reg_miud('I', it_rep);
    it_rep.delete;


END;



END;

/

/
