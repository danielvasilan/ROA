--------------------------------------------------------
--  DDL for Package Body PKG_PO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_PO" 
AS



/*********************************************************************************************
    30/12/2008  d   Create date

/*********************************************************************************************/
FUNCTION f_sql_po_ord_header    (   p_line_id           NUMBER,
                                    p_suppl_code        VARCHAR2)
                                    RETURN              typ_frm         pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for PURCHASE ORDER HEADER subform 
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINES      (p_suppl_code    VARCHAR2, p_line_ID NUMBER)
                            IS
                            SELECT      po.idriga           ,
                                        po.dcn              ,
                                        po.po_code          ,
                                        po.description       ,
                                        po.po_type          ,
                                        po.doc_code         ,
                                        po.doc_date         ,
                                        po.status           ,
                                        po.suppl_code       ,
                                        po.accept_date      ,
                                        po.po_date          ,
                                        po.estimated_date   ,
                                        po.delivery_date    ,
                                        po.suppl_loc        ,
                                        po.delivery_loc     ,
                                        po.currency_code    ,
                                        po.exchange_rate    ,
                                        po.payment_cond     ,
                                        po.delivery_cond    ,
                                        po.empl_request     ,
                                        po.note             ,
                                        po.delivery_org     ,
                                        po.ship_via         ,
                                        o.org_name          o_org_name,
                                        od.org_name         od_org_name,
                                        ol.description      ol_description
                            ---------------------------------------------------------------------
                            FROM        PO_ORD_HEADER       po
                            LEFT JOIN   ORGANIZATION        o   ON  o.org_code          =   po.suppl_code
                            LEFT JOIN   ORGANIZATION        od  ON  od.org_code         =   po.delivery_org
                            LEFT JOIN   ORGANIZATION_LOC    ol  ON  ol.loc_code         =   po.DELIVERY_LOC
                                                                AND ol.org_code         =   po.delivery_org
                            ---------------------------------------------------------------------
                            WHERE       po.suppl_code       LIKE   NVL(p_suppl_code,'%')
                                AND     p_line_id           IS NULL
                            ---------------------------------------------------------------------
                            ---     LINE ID
                            ---------------------------------------------------------------------
                            UNION ALL   
                            SELECT      po.idriga           ,
                                        po.dcn              ,
                                        po.po_code          ,
                                        po.description       ,
                                        po.po_type          ,
                                        po.doc_code         ,
                                        po.doc_date         ,
                                        po.status           ,
                                        po.suppl_code       ,
                                        po.accept_date      ,
                                        po.po_date          ,
                                        po.estimated_date   ,
                                        po.delivery_date    ,
                                        po.suppl_loc        ,
                                        po.delivery_loc     ,
                                        po.currency_code    ,
                                        po.exchange_rate    ,
                                        po.payment_cond     ,
                                        po.delivery_cond    ,
                                        po.empl_request     ,
                                        po.note             ,
                                        po.delivery_org     ,
                                        po.ship_via         ,
                                        o.org_name          o_org_name,
                                        od.org_name         od_org_name,
                                        ol.description      ol_description
                            ---------------------------------------------------------------------
                            FROM        PO_ORD_HEADER       po
                            LEFT JOIN   ORGANIZATION        o   ON  o.org_code          =   po.suppl_code
                            LEFT JOIN   ORGANIZATION        od  ON  od.org_code         =   po.delivery_org
                            LEFT JOIN   ORGANIZATION_LOC    ol  ON  ol.loc_code         =   po.DELIVERY_LOC
                                                                AND ol.org_code         =   po.delivery_org                            
                            ---------------------------------------------------------------------
                            WHERE       po.idriga           =   p_line_id
                                AND     p_line_id           IS NOT NULL
                            ---------------------------------------------------------------------
                            ORDER BY    po_code
                            ;

    v_row                   tmp_frm      := tmp_frm();

BEGIN


    FOR X IN C_LINES(p_suppl_code, p_line_id)
    LOOP

        v_row.idriga    :=  X.idriga;
        v_row.dcn       :=  X.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.po_code;
        v_row.txt02     :=  x.po_type;
        v_row.txt03     :=  x.doc_code;
        v_row.txt04     :=  x.status;
        v_row.txt05     :=  x.description;
        v_row.txt06     :=  x.suppl_code;
        v_row.txt07     :=  x.o_org_name;
        v_row.txt08     :=  x.suppl_loc;
        v_row.txt09     :=  x.delivery_loc;
        v_row.txt10     :=  x.currency_code;
        v_row.txt11     :=  x.payment_cond;
        v_row.txt12     :=  x.delivery_cond;
        v_row.txt13     :=  x.empl_request;
        v_row.txt14     :=  x.note;
        v_row.txt15     :=  x.delivery_org;
        v_row.txt16     :=  x.od_org_name;
        v_row.txt17     :=  x.ol_description;
        v_row.txt18     :=  x.ship_via;
        
        v_row.numb01    :=  x.exchange_rate;        
        
        v_row.data01    :=  x.doc_date;
        v_row.data02    :=  x.accept_date;
        v_row.data03    :=  x.po_date;
        v_row.data04    :=  x.estimated_date;
        v_row.data05    :=  x.delivery_date;
        
        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;


/*********************************************************************************************
    30/12/2008  d   Create date

/*********************************************************************************************/
FUNCTION f_sql_po_ord_line      (   p_line_id           NUMBER,
                                    p_ref_po            NUMBER)
                                    RETURN              typ_frm         pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for PURCHASE ORDER LINE subform 
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINES      (p_ref_po    NUMBER, p_line_ID NUMBER)
                            IS
                            SELECT      po.idriga           ,
                                        po.dcn              ,
                                        po.ref_po           ,
                                        po.seq_no           ,
                                        i.description       i_description,
                                        po.status           ,
                                        po.org_code         ,
                                        po.item_code        ,
                                        po.oper_code_item   ,
                                        po.routing_code     ,
                                        po.line_type        ,
                                        po.qty              ,
                                        po.unit_price       ,
                                        po.costcenter_code  ,
                                        po.ref_po_req       ,
                                        i.puom              i_puom
                            ---------------------------------------------------------------------
                            FROM        PO_ORD_LINE         po
                            INNER JOIN  ITEM                i   ON  i.org_code  =   po.org_code
                                                                AND i.item_code =   po.item_code
                            ---------------------------------------------------------------------
                            WHERE       po.ref_po           =   p_ref_po
                                AND     p_line_id           IS NULL
                            ---------------------------------------------------------------------
                            ---     LINE ID
                            ---------------------------------------------------------------------
                            UNION ALL   
                            SELECT      po.idriga           ,
                                        po.dcn              ,
                                        po.ref_po           ,
                                        po.seq_no           ,
                                        i.description       i_description,
                                        po.status           ,
                                        po.org_code         ,
                                        po.item_code        ,
                                        po.oper_code_item   ,
                                        po.routing_code     ,
                                        po.line_type        ,
                                        po.qty              ,
                                        po.unit_price       ,
                                        po.costcenter_code  ,
                                        po.ref_po_req       ,
                                        i.puom              i_puom
                            ---------------------------------------------------------------------
                            FROM        PO_ORD_LINE         po
                            INNER JOIN  ITEM                i   ON  i.org_code  =   po.org_code
                                                                AND i.item_code =   po.item_code
                            ---------------------------------------------------------------------
                            WHERE       po.idriga           =   p_line_id
                                AND     p_line_id           IS NOT NULL
                            ---------------------------------------------------------------------
                            ORDER BY    seq_no
                            ;

    v_row                   tmp_frm      := tmp_frm();

BEGIN


    FOR X IN C_LINES(p_ref_po, p_line_id)
    LOOP

        v_row.idriga    :=  X.idriga;
        v_row.dcn       :=  X.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.status;
        v_row.txt02     :=  x.org_code;
        v_row.txt03     :=  x.item_code;
        v_row.txt04     :=  x.oper_code_item;
        v_row.txt05     :=  x.i_description;
        v_row.txt06     :=  x.routing_code;
        v_row.txt07     :=  x.line_type;
        v_row.txt08     :=  x.costcenter_code;

        v_row.numb01    :=  x.ref_po;    
        v_row.numb02    :=  x.seq_no;
        v_row.numb03    :=  x.qty;
        v_row.numb04    :=  x.unit_price;
        v_row.numb05    :=  x.ref_po_req;    
        
        
        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    30/12/2008  d   created

/*********************************************************************************************/
PROCEDURE p_po_ord_header_blo      (   p_tip   VARCHAR2, p_row IN OUT PO_ORD_HEADER%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    IUD for WO_DETAIL
----------------------------------------------------------------------------------------------
IS
    v_row_old       PO_ORD_HEADER%ROWTYPE;
BEGIN

    v_row_old           :=  p_row;

    IF p_tip = 'I' THEN
        p_row.po_code   :=  Pkg_Env.f_get_app_doc_number
                                (
                                p_org_code      =>  'ALL',
                                p_doc_type      =>  'PO',
                                p_doc_subtype   =>  'ORD',
                                p_num_year      =>  TO_CHAR(SYSDATE,'YYYY')
                                );
        p_row.status    :=  'I';
        p_row.po_type   :=  NVL(p_row.po_type,'S');

    END IF;

END;


/*********************************************************************************************
    30/12/2008  d   created

/*********************************************************************************************/
PROCEDURE p_po_ord_header_iud      (   p_tip   VARCHAR2, p_row PO_ORD_HEADER%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    IUD for WO_DETAIL
----------------------------------------------------------------------------------------------
IS
    v_row_new       PO_ORD_HEADER%ROWTYPE;

BEGIN

    v_row_new           :=  p_row;

    p_po_ord_header_blo(p_tip, v_row_new);

    Pkg_Iud.p_po_ord_header_iud (p_tip, v_row_new);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************
    30/12/2008  d   created

/*********************************************************************************************/
PROCEDURE p_po_ord_line_iud      (   p_tip   VARCHAR2, p_row PO_ORD_LINE%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    IUD for WO_DETAIL
----------------------------------------------------------------------------------------------
IS
    v_row_new       PO_ORD_LINE%ROWTYPE;

BEGIN

    v_row_new           :=  p_row;

--    p_work_order_blo(p_tip, v_row_new);

    Pkg_Iud.p_po_ord_line_iud (p_tip, v_row_new);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************
    30/12/2008  d   created

/*********************************************************************************************/
PROCEDURE p_rep_po_order    (   p_idriga NUMBER)
----------------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for the REP_PO_ORDER report 
----------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (p_ref_po NUMBER)
                    IS
                    SELECT      l.*,
                                i.description       i_description,
                                i.puom              i_puom
                    FROM        PO_ORD_LINE     l
                    INNER JOIN  ITEM            i   ON  i.org_code      =   l.org_code
                                                    AND i.item_code     =   l.item_code
                    WHERE       l.ref_po        =   p_ref_po
                    ORDER BY    l.seq_no
                    ;
                    
    C_SEGMENT       VARCHAR2(30)    :=  'VW_REP_PO_ORDER';
    v_row_po        PO_ORD_HEADER%ROWTYPE;
    v_row_my        ORGANIZATION%ROWTYPE;
    v_row_suppl     ORGANIZATION%ROWTYPE;
    v_row_dest      ORGANIZATION%ROWTYPE;
    v_row_ship      ORGANIZATION%ROWTYPE;
    v_row_empl      APP_USER%ROWTYPE;
    it_rep          Pkg_Rtype.ta_vw_rep_po_order;
    v_idx           PLS_INTEGER;
    
BEGIN

    DELETE FROM VW_REP_PO_ORDER;

    -- get PO HEADER info 
    v_row_po.idriga         :=  p_idriga;
    Pkg_Get.p_get_po_ord_header(v_row_po,0);
    -- get MYSELF organization row 
    v_row_my.org_code       :=  Pkg_Nomenc.f_get_myself_org;
    Pkg_Get2.p_get_organization_2(v_row_my);
    -- get SUPPLIER organization row 
    v_row_suppl.org_code    :=  v_row_po.suppl_code;
    Pkg_Get2.p_get_organization_2(v_row_suppl);
    -- get DELIVERY organization row 
    v_row_dest.org_code     :=  v_row_po.delivery_org;
    Pkg_Get2.p_get_organization_2(v_row_dest);
    -- get SHIP_VIA organization row 
    v_row_ship.org_code     :=  v_row_po.ship_via;
    Pkg_Get2.p_get_organization_2(v_row_ship);
    
    -- get employee row 
    v_row_empl.user_code    :=  v_row_po.empl_request;
    Pkg_Get2.p_get_app_user_2(v_row_empl,0);
    
    -- header info 
    it_rep(1).segment_code  :=  C_SEGMENT;
    it_rep(1).rep_title     :=  'ORDIN DE ACHIZITIE';
    it_rep(1).rep_info      :=  'Data:  '||v_row_po.po_date||Pkg_Glb.C_NL||
                                'ODA #  '||v_row_po.po_code;
    it_rep(1).myself_name   :=  v_row_my.org_name;
    it_rep(1).myself_info   :=  'Adresa:    '||v_row_my.address||Pkg_Glb.C_NL||
                                'Localitate:'||v_row_my.city||','||
                                v_row_my.country_code||Pkg_Glb.C_NL;
    -- buyer 
    it_rep(1).buyer_name    :=  v_row_empl.nume||' '||v_row_empl.prenume;
    it_rep(1).buyer_info    :=  'Pentru orice intrebari si nelamuriri legate de acest '||
                                'Ordin de achizitie, va rugam sa contactati '||
                                v_row_empl.nume||' '||v_row_empl.prenume;    
    -- supplier 
    it_rep(1).suppl_name    :=  v_row_suppl.org_name;
    it_rep(1).suppl_info    :=  'Adresa:    '||v_row_suppl.address||Pkg_Glb.C_NL||
                                'Localitate:'||v_row_suppl.city||','||
                                v_row_suppl.country_code||Pkg_Glb.C_NL;
    
    -- ship to 
    it_rep(1).shipto_name   :=  NVL(v_row_dest.org_name,v_row_dest.org_code);
    it_rep(1).shipto_info   :=  'Adresa:    '||v_row_dest.address||Pkg_Glb.C_NL||
                                'Localitate:'||v_row_dest.city||','||
                                v_row_dest.country_code||Pkg_Glb.C_NL;
    --
    it_rep(1).currency_code :=  v_row_po.currency_code;
    it_rep(1).exchange_rate :=  v_row_po.exchange_rate;
    it_rep(1).ship_incoterm :=  v_row_po.delivery_cond;
    it_rep(1).ship_via      :=  v_row_ship.org_name;    
    
    FOR x IN C_LINES(p_idriga)
    LOOP
        v_idx                               :=  it_rep.COUNT +1;
        it_rep(v_idx).seq_no                :=  v_idx;
        it_rep(v_idx).segment_code          :=  C_SEGMENT;
        it_rep(v_idx).item_code_suppl       :=  x.item_code;
        it_rep(v_idx).item_descr_suppl      :=  x.i_description;
        it_rep(v_idx).item_uom_suppl        :=  x.i_puom;
        it_rep(v_idx).qty                   :=  NVL(x.qty,0);
        it_rep(v_idx).unit_price            :=  NVL(x.unit_price,0);
        it_rep(v_idx).line_price            :=  NVL(x.unit_price * x.qty, 0);
        it_rep(v_idx).line_tax              :=  TRUNC(it_rep(v_idx).line_price * 0.19 ,4);
        it_rep(v_idx).currency_code         :=  v_row_po.currency_code;
    END LOOP;

    IF it_rep.COUNT > 0 THEN
        Pkg_Iud.p_vw_rep_po_order_miud('I',it_rep);
    
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

END;

/

/
