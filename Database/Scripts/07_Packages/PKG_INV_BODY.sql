--------------------------------------------------------
--  DDL for Package Body PKG_INV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_INV" 
IS


CURSOR C_DIFF_INV   (p_ref_inventory NUMBER, p_whs_code VARCHAR2)   
                IS
                SELECT              a.whs_code,a.org_code, a.item_code, 
                                    a.season_code, a.colour_code, a.size_code, 
                                    a.oper_code_item, a.order_code, a.group_code,
                                    SUM(a.qty_inv)          qty_inv,
                                    SUM(a.qty_stock)        qty_stock,
                                    MAX(i.description)      i_description,
                                    MAX(i.puom)             i_puom,
                                    MAX(w.category_code)    w_category_code,
                                    MAX(k.custody)          k_custody
                FROM
                            ( 
                            SELECT      whs_code,org_code, item_code, season_code, colour_code, size_code, 
                                        oper_code_item, order_code, group_code,
                                        0                   qty_inv,
                                        qty                 qty_stock
                            FROM        INVENTORY_STOC      s
                            WHERE       ref_inventory       =   p_ref_inventory
                                AND     whs_code            LIKE   NVL(p_whs_code,'%')
                            UNION ALL
                            SELECT      whs_code,org_code, item_code, season_code, colour_code, size_code, 
                                        oper_code_item, order_code, group_code,
                                        qty                 qty_inv,
                                        0                   qty_stock
                            FROM        INVENTORY_DETAIL    s
                            WHERE       ref_inventory       =       p_ref_inventory
                                AND     whs_code            LIKE    NVL(p_whs_code, '%')
                            )    a
                -- 
                INNER JOIN  ITEM            i       ON  i.org_code      =   a.org_code
                                                    AND i.item_code     =   a.item_code
                INNER JOIN  WAREHOUSE       w       ON  w.whs_code      =   a.whs_code
                INNER JOIN  WAREHOUSE_CATEG k       ON  k.category_code =   w.category_code
                --                    
                GROUP BY    a.whs_code, a.org_code, a.item_code, a.season_code, a.colour_code, a.size_code, 
                                    a.oper_code_item, a.order_code, a.group_code
                ;


/****************************************************************************************************
    DDL:    24/11/2008  d   Create 
/****************************************************************************************************/
PROCEDURE p_inventory_blo(p_tip VARCHAR2, p_row IN OUT INVENTORY%ROWTYPE)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD logic for INVENTORY;
-----------------------------------------------------------------------------------------------------
IS
BEGIN

    -- CHECKS 
    IF p_row.inv_date IS NULL THEN Pkg_Err.p_rae('Nu ati completat Data Inventarului !'); END IF;

    IF p_tip = 'I' THEN
        p_row.inv_code  :=  Pkg_Env.f_get_app_doc_number(   p_org_code      =>  p_row.org_code,
                                                            p_doc_type      =>  'INV',
                                                            p_doc_subtype   =>  p_row.inv_type,
                                                            p_num_year      =>  TO_CHAR(p_row.inv_date,'YYYY'));
        p_row.date_legal    :=  NVL(p_row.date_legal, p_row.inv_date);
        p_row.status        :=  'I';
    END IF;
    
    IF p_tip = 'D' THEN
        Pkg_Err.p_rae('Nu se pot sterge INVENTARE! Incercati sa-l anulati!');
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/****************************************************************************************************
    DDL:    22/11/2008  d   Create 
/****************************************************************************************************/
PROCEDURE p_inventory_iud(p_tip VARCHAR2, p_row INVENTORY%ROWTYPE)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD logic for INVENTORY;
-----------------------------------------------------------------------------------------------------
IS
    v_row       INVENTORY%ROWTYPE;
BEGIN

    v_row       :=  p_row;
    
    p_inventory_blo(p_tip, v_row);

    Pkg_Iud.p_inventory_iud(p_tip, v_row);

    COMMIT;
    
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/****************************************************************************************************
    DDL:    23/11/2008  d   Create 
/****************************************************************************************************/
PROCEDURE p_inventory_setup_iud(p_tip VARCHAR2, p_row INVENTORY_SETUP%ROWTYPE)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD logic for INVENTORY_SETUP;
-----------------------------------------------------------------------------------------------------
IS
BEGIN

    Pkg_Iud.p_inventory_setup_iud(p_tip, p_row);

    COMMIT;
    
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/****************************************************************************************************
    DDL:    22/11/2008  d   Create 
/****************************************************************************************************/
PROCEDURE p_inventory_detail_iud(p_tip VARCHAR2, p_row INVENTORY_DETAIL%ROWTYPE)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD logic for INVENTORY_DETAIL ;
-----------------------------------------------------------------------------------------------------
IS

    v_found         BOOLEAN;
    v_test          PLS_INTEGER;
    
    v_row_old       INVENTORY_DETAIL%ROWTYPE;
    v_row_inv       INVENTORY%ROWTYPE;
    v_row_itm       ITEM%ROWTYPE;

BEGIN

    v_row_old.idriga    := p_row.idriga;
    IF Pkg_Get.f_get_inventory_detail(v_row_old) THEN NULL;     END IF;

    v_row_inv.idriga    := NVL(p_row.ref_inventory, v_row_old.ref_inventory);
    Pkg_Get.p_get_inventory(v_row_inv, -1);

    -- get ITEM row 
    v_row_itm.org_code  :=  p_row.org_code;
    v_row_itm.item_code :=  p_row.item_code;
    Pkg_Get2.p_get_item_2(v_row_itm);
    
    IF v_row_inv.status NOT IN ('L','F') THEN 
        Pkg_Lib.p_rae('Inventarul nu este in stare (L)ansata sau cu stoc inghetat (F), nu se poate modifica !!!'); 
    END IF;

    IF p_tip IN ('I','U') THEN
        -- check item attributes 
        Pkg_Item.p_check_item_attr(v_row_itm, p_row.colour_code, p_row.size_code);
        
    END IF;
    
    -- IUD 
    Pkg_Iud.p_inventory_detail_iud(p_tip, p_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/****************************************************************************************************
    DDL:    22/11/2008  d   Create 
/****************************************************************************************************/
FUNCTION f_sql_inventory_detail (   p_line_id           NUMBER,
                                    p_ref_inventory     NUMBER)
                                    RETURN              typ_frm     pipelined  
----------------------------------------------------------------------------------------------------
--  PURPOSE:    SQl function for INVENTORY_DETAIL ;
-----------------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (           p_line_id   NUMBER, p_ref_inventory NUMBER)
                    IS
                    SELECT      d.*,
                                s.qty               s_qty,
                                i.description       i_description,
                                i.puom              i_puom
                    --------------------------------------
                    FROM        INVENTORY_DETAIL    d
                    INNER JOIN  ITEM                i   ON  i.org_code      =   d.org_code
                                                        AND i.item_code     =   d.item_code
                    LEFT JOIN   INVENTORY_STOC      s   ON  s.org_code      =   d.org_code
                                                        AND s.item_code     =   d.item_code
                                                        AND s.whs_code      =   d.whs_code
                                                        AND s.season_code   =   d.season_code
                                                        AND Pkg_Lib.f_diff_c(s.colour_code, d.colour_code)  = 0
                                                        AND Pkg_Lib.f_diff_c(s.size_code,   d.size_code)    = 0
                                                        AND Pkg_Lib.f_diff_c(s.order_code,  d.order_code)   = 0
                                                        AND Pkg_Lib.f_diff_c(s.group_code,  d.group_code)   = 0
                                                        AND Pkg_Lib.f_diff_c(s.colour_code, d.colour_code)  = 0
                                                        AND Pkg_Lib.f_diff_c(s.oper_code_item, d.oper_code_item) = 0
                    -----------------------------------------
                    WHERE       p_line_id           IS NULL
                        AND     d.ref_inventory     =   p_ref_inventory
                    UNION ALL
                    SELECT      d.*,
                                s.qty               s_qty,
                                i.description       i_description,
                                i.puom              i_puom
                    --------------------------------------
                    FROM        INVENTORY_DETAIL    d
                    INNER JOIN  ITEM                i   ON  i.org_code      =   d.org_code
                                                        AND i.item_code     =   d.item_code
                    LEFT JOIN   INVENTORY_STOC      s   ON  s.org_code      =   d.org_code
                                                        AND s.item_code     =   d.item_code
                                                        AND s.whs_code      =   d.whs_code
                                                        AND s.season_code   =   d.season_code
                                                        AND Pkg_Lib.f_diff_c(s.colour_code, d.colour_code)  = 0
                                                        AND Pkg_Lib.f_diff_c(s.size_code,   d.size_code)    = 0
                                                        AND Pkg_Lib.f_diff_c(s.order_code,  d.order_code)   = 0
                                                        AND Pkg_Lib.f_diff_c(s.group_code,  d.group_code)   = 0
                                                        AND Pkg_Lib.f_diff_c(s.colour_code, d.colour_code)  = 0
                                                        AND Pkg_Lib.f_diff_c(s.oper_code_item, d.oper_code_item) = 0
                    -----------------------------------------
                    WHERE       p_line_id           IS NOT NULL
                        AND     d.idriga            =   p_line_id
                    ;

    v_row         tmp_frm := tmp_frm();

BEGIN
    FOR X IN C_LINES(p_line_id, p_ref_inventory) 
    LOOP

        v_row.idriga    :=      x.idriga;
        v_row.dcn       :=      x.dcn;
        v_row.seq_no    :=      C_LINES%rowcount;

        v_row.txt01     :=      x.org_code;
        v_row.txt02     :=      x.item_code;
        v_row.txt03     :=      x.i_description;
        v_row.txt04     :=      x.oper_code_item;
        v_row.txt05     :=      x.colour_code;
        v_row.txt06     :=      x.size_code;
        v_row.txt07     :=      x.order_code;
        v_row.txt08     :=      x.group_code;
        v_row.txt09     :=      x.season_code;
        v_row.txt10     :=      x.i_puom;
        v_row.txt19     :=      x.free_text;
        
        v_row.numb01    :=      x.qty;
        v_row.numb02    :=      x.s_qty;
        v_row.numb03    :=      p_ref_inventory;

        pipe ROW(v_row);
    END LOOP;
    RETURN;                    

END;

/****************************************************************************************************
    DDL:    22/11/2008  d   Create 
/****************************************************************************************************/
FUNCTION f_sql_inventory        (   p_line_id           NUMBER,
                                    p_org_code          VARCHAR2)
                                    RETURN              typ_frm     pipelined  
----------------------------------------------------------------------------------------------------
--  PURPOSE:    SQl function for INVENTORY header  ;
-----------------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (           p_line_id   NUMBER, p_org_code VARCHAR2)
                    IS
                    SELECT      h.*
                    --------------------------------------
                    FROM        INVENTORY           h
                    -----------------------------------------
                    WHERE       p_line_id           IS NULL
                        AND     h.org_code          =   p_org_code
                    UNION ALL
                    SELECT      h.*
                    --------------------------------------
                    FROM        INVENTORY           h
                    -----------------------------------------
                    WHERE       p_line_id           IS NOT NULL
                        AND     h.idriga            =   p_line_id
                    ;

    v_row         tmp_frm := tmp_frm();

BEGIN
    FOR X IN C_LINES(p_line_id, p_org_code) 
    LOOP

        v_row.idriga    :=      x.idriga;
        v_row.dcn       :=      x.dcn;
        v_row.seq_no    :=      C_LINES%rowcount;

        v_row.txt01     :=      x.org_code;
        v_row.txt02     :=      x.inv_type;
        v_row.txt03     :=      x.description;
        v_row.txt04     :=      x.inv_code;
        v_row.txt05     :=      x.status;
        v_row.txt06     :=      x.note;
        
        v_row.data01    :=      x.inv_date;
        v_row.DATA02    :=      x.date_legal;
        
        pipe ROW(v_row);
    END LOOP;
    RETURN;                    

END;


/****************************************************************************************************
    DDL:    22/11/2008  d   Create 
/****************************************************************************************************/
FUNCTION f_sql_inventory_setup  (   p_line_id           NUMBER,
                                    p_ref_inventory     NUMBER)
                                    RETURN              typ_frm     pipelined  
----------------------------------------------------------------------------------------------------
--  PURPOSE:    SQl function for INVENTORY setup   ;
-----------------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (           p_line_id   NUMBER, p_ref_inventory NUMBER)
                    IS
                    SELECT      h.*,
                                m.description       m_description
                    --------------------------------------
                    FROM        INVENTORY_SETUP     h
                    LEFT JOIN   MULTI_TABLE         m   ON  m.table_key     =   h.attr_code
                                                        AND m.table_name    =   'INVENTORY_ATTR'
                    -----------------------------------------
                    WHERE       p_line_id           IS NULL
                        AND     h.ref_inventory     =   p_ref_inventory
                    UNION ALL
                    SELECT      h.*,
                                m.description       m_description                    
                    --------------------------------------
                    FROM        INVENTORY_SETUP     h
                    LEFT JOIN   MULTI_TABLE         m   ON  m.table_key     =   h.attr_code
                                                        AND m.table_name    =   'INVENTORY_ATTR'
                    -----------------------------------------
                    WHERE       p_line_id           IS NOT NULL
                        AND     h.idriga            =   p_line_id
                    ;

    v_row         tmp_frm := tmp_frm();

BEGIN
    FOR X IN C_LINES(p_line_id, p_ref_inventory) 
    LOOP

        v_row.idriga    :=      x.idriga;
        v_row.dcn       :=      x.dcn;
        v_row.seq_no    :=      C_LINES%rowcount;

        v_row.txt01     :=      x.attr_code;
        v_row.txt02     :=      x.attr_value;
        v_row.txt03     :=      x.m_description;
        
        v_row.numb01    :=      x.ref_inventory;
        pipe ROW(v_row);
    END LOOP;
    RETURN;                    

END;

/****************************************************************************************************
    DDL:    22/11/2008  d   Create 
/****************************************************************************************************/
PROCEDURE p_freeze_stock    (   p_ref_inventory     NUMBER, p_commit VARCHAR2)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    freeze the stocks in INVENTORY_STOC  ;
-----------------------------------------------------------------------------------------------------
IS

    CURSOR C_ATTR   (p_ref_inventory NUMBER)
                    IS
                    SELECT      *
                    FROM        INVENTORY_SETUP
                    WHERE       ref_inventory   =   p_ref_inventory
                    ;

    CURSOR C_STOC   (p_org_code VARCHAR2)
                    IS
                    SELECT      s.*, 
                                i.type_code    i_type_code
                    FROM        VW_STOC_ONLINE  s
                    INNER JOIN  ITEM            i   ON  i.org_code      =   s.org_code
                                                    AND i.item_code     =   s.item_code 
                    WHERE       s.org_code      =   p_org_code
                    ;

    v_row_inv       INVENTORY%ROWTYPE;
    v_freeze_date   DATE;
    it_stk          Pkg_Rtype.ta_inventory_stoc;
    idx_stk         INTEGER;
    v_whs_list      VARCHAR2(500);      
    v_item_type     VARCHAR2(500);
    v_season_list   VARCHAR2(500);
    
BEGIN
    -- get inventory rowtype 
    v_row_inv.idriga    :=  p_ref_inventory;
    Pkg_Get.p_get_inventory(v_row_inv, -1);
    -- check inventory status 
    IF v_row_inv.status NOT IN('L','I') THEN
        Pkg_Err.p_rae('Inventarul nu este in stare Initiala sau Lansata! Stocul nu poate fi inghetat!');
    END IF;
    
    -- inventoy additional attributes 
    FOR x IN C_ATTR(p_ref_inventory)
    LOOP
        IF x.attr_code = 'WHS' THEN
            v_whs_list  :=  v_whs_list || x.attr_value ||',';
        END IF;
        IF x.attr_code = 'ITEMTYPE' THEN
            v_item_type  :=  v_item_type || x.attr_value ||',';
        END IF;
        IF x.attr_code = 'SEASON' THEN
            v_season_list  :=  v_season_list || x.attr_value ||',';
        END IF;
    END LOOP;
    
    -- determine the stocks 
    v_freeze_date   :=  v_row_inv.inv_date;--TRUNC(SYSDATE);
    Pkg_Mov.p_stoc_past(    p_org_code      =>  v_row_inv.org_code,
                            p_item_code     =>  NULL,
                            p_group_code    =>  NULL,
                            p_whs_code      =>  v_whs_list,
                            p_season_code   =>  v_season_list,
                            p_ref_date      =>  v_freeze_date);
    
    -- memorize the stocks in INVENTORY_STOC 
    FOR x IN C_STOC(v_row_inv.org_code)
    LOOP
        IF v_item_type IS NULL OR INSTR(v_item_type,x.i_type_code) > 0 THEN
            idx_stk                 :=  it_stk.COUNT + 1;
            it_stk(idx_stk).org_code        :=  x.org_code;
            it_stk(idx_stk).ref_inventory   :=  p_ref_inventory;
            it_stk(idx_stk).whs_code        :=  x.whs_code;
            it_stk(idx_stk).season_code     :=  x.season_code;
            it_stk(idx_stk).item_code       :=  x.item_code;
            it_stk(idx_stk).colour_code     :=  x.colour_code;
            it_stk(idx_stk).size_code       :=  x.size_code;
            it_stk(idx_stk).order_code      :=  x.order_code;
            it_stk(idx_stk).group_code      :=  x.group_code;
            it_stk(idx_stk).oper_code_item  :=  x.oper_code_item;
            it_stk(idx_stk).qty             :=  x.qty;
            it_stk(idx_stk).inv_date        :=  v_freeze_date;
        END IF;
    END LOOP;
    
    Pkg_Iud.p_inventory_stoc_miud('I',it_stk);
    
    v_row_inv.status    :=  'F';
    Pkg_Iud.p_inventory_iud('U',v_row_inv);
    
    IF p_commit = 'Y' THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_commit ='Y' THEN ROLLBACK; END IF;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));    
END;


/****************************************************************************************************
    DDL:    22/11/2008  d   Create 
/****************************************************************************************************/
PROCEDURE p_detail_from_stock   (   p_ref_inventory NUMBER, p_commit VARCHAR2)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    freeze the stocks in INVENTORY_STOC  ;
-----------------------------------------------------------------------------------------------------
IS
  
    CURSOR C_LINES  (p_ref_inventory NUMBER)
                    IS
                    SELECT      *
                    FROM        INVENTORY_STOC
                    WHERE       ref_inventory   =   p_ref_inventory
                    ;
    
    it_ind          Pkg_Rtype.ta_inventory_detail;
    idx_ind         INTEGER;
    v_row_inv       INVENTORY%ROWTYPE;
                    
BEGIN

    -- get inventory rowtype 
    v_row_inv.idriga    :=  p_ref_inventory;
    Pkg_Get.p_get_inventory(v_row_inv, -1);
    -- check inventory status 
    IF v_row_inv.status <> 'F' THEN
        Pkg_Err.p_rae('Nu se pot genera detalii din stoc, decat dupa inghetarea stocurilor!');
    END IF;

    FOR x IN C_LINES    (p_ref_inventory)
    LOOP
        idx_ind     :=  it_ind.COUNT + 1;
        it_ind(idx_ind).org_code        :=  x.org_code;
        it_ind(idx_ind).ref_inventory   :=  p_ref_inventory;
        it_ind(idx_ind).whs_code        :=  x.whs_code;
        it_ind(idx_ind).item_code       :=  x.item_code;
        it_ind(idx_ind).colour_code     :=  x.colour_code;
        it_ind(idx_ind).size_code       :=  x.size_code;
        it_ind(idx_ind).order_code      :=  x.order_code;
        it_ind(idx_ind).group_code      :=  x.group_code;
        it_ind(idx_ind).season_code     :=  x.season_code;
        it_ind(idx_ind).oper_code_item  :=  x.oper_code_item;
        it_ind(idx_ind).qty             :=  0;
        it_ind(idx_ind).sheet_id        :=  1;
        it_ind(idx_ind).position_id     :=  1;
        it_ind(idx_ind).inv_type        :=  'A';
    END LOOP;

    Pkg_Iud.p_inventory_detail_miud('I',it_ind);
    
    IF p_commit = 'Y' THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_commit = 'Y' THEN ROLLBACK; END IF;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));    
END;

/****************************************************************************************************
    DDL:    23/11/2008  d   Create 
            17/12/2008  d   added the report type parameter (for different output formats ) 
/****************************************************************************************************/
PROCEDURE p_rep_inv_list    (   p_ref_inventory     NUMBER, 
                                p_whs_code          VARCHAR2, 
                                p_rep_type          VARCHAR2)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    INVENTORY LIST report  ;
-----------------------------------------------------------------------------------------------------
IS

    it_rep              Pkg_Rtype.ta_VW_REP_INV_LIST;
    idx_rep             INTEGER;
    C_SEGMENT_CODE      VARCHAR2(30)    :=  'VW_REP_INV_LIST';
    v_row_org_my        ORGANIZATION%ROWTYPE;
    v_row_org           ORGANIZATION%ROWTYPE;
    v_row_inv           INVENTORY%ROWTYPE;
    
BEGIN

    DELETE FROM VW_REP_INV_LIST;

    v_row_inv.idriga        :=  p_ref_inventory;
    Pkg_Get.p_get_inventory(v_row_inv);
    
    v_row_org_my.org_code   :=  Pkg_Nomenc.f_get_myself_org();
    Pkg_Get2.p_get_organization_2(v_row_org_my);
    
    v_row_org.org_code      :=  v_row_inv.org_code;
    Pkg_Get2.p_get_organization_2(v_row_org);
    
    FOR x IN C_DIFF_INV(p_ref_inventory, p_whs_code)
    LOOP
        idx_rep                         :=  it_rep.COUNT + 1;
        it_rep(idx_rep).segment_code    :=  C_SEGMENT_CODE;
        it_rep(idx_rep).rep_title       :=  'LISTA DE INVENTARIERE '||Pkg_Glb.C_NL||
                                            'Data '||TO_CHAR(v_row_inv.inv_date,'dd/mm/yyyy')||
                                            '   Cod Inventar '||v_row_inv.inv_code||
                                            ' Stare inventar: '||v_row_inv.status||Pkg_Glb.C_NL||
                                            v_row_inv.description;
        it_rep(idx_rep).org_myself      :=  'Unitatea'||Pkg_Glb.C_NL||v_row_org_my.org_name;
        it_rep(idx_rep).org_descr       :=  'Gestiunea'||Pkg_Glb.C_NL||v_row_org.org_name;
        it_rep(idx_rep).whs_code        :=  p_whs_code;
        it_rep(idx_rep).inv_date        :=  v_row_inv.inv_date;
        it_rep(idx_rep).item_code       :=  x.item_code||' '||x.oper_code_item;
        it_rep(idx_rep).oper_code_item  :=  x.oper_code_item;
        it_rep(idx_rep).stock_attr      :=  RPAD(NVL(x.season_code, ' '),5)||
                                            RPAD(NVL(x.size_code,   ' '),4)||
                                            x.colour_code||' '||
                                            x.order_code;
        it_rep(idx_rep).item_descr      :=  x.i_description;
        it_rep(idx_rep).puom            :=  x.i_puom;
        it_rep(idx_rep).qty_stock       :=  x.qty_stock;
        
        -- output quantities depending on the report type 
        IF p_rep_type = '1' THEN
            it_rep(idx_rep).qty_inv         :=  NULL;
        ELSE
            it_rep(idx_rep).qty_inv         :=  x.qty_inv;
        
            IF x.qty_inv > x.qty_stock THEN
                it_rep(idx_rep).qty_plus        :=  x.qty_inv - x.qty_stock;
                it_rep(idx_rep).qty_minus       :=  0;
            ELSE
                it_rep(idx_rep).qty_minus       :=  x.qty_stock - x.qty_inv;
                it_rep(idx_rep).qty_plus        :=  0;
            END IF;
        END IF;
    END LOOP;
    
    Pkg_Iud.p_vw_rep_inv_list_miud('I',it_rep);
    
END;

/****************************************************************************************************
    DDL:    27/11/2008  d   Create 
/****************************************************************************************************/
PROCEDURE p_inventory_launch    (   p_ref_inventory NUMBER)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    INVENTORY launch  ;
-----------------------------------------------------------------------------------------------------
IS
    v_row_inv               INVENTORY%ROWTYPE;
BEGIN
    v_row_inv.idriga        :=  p_ref_inventory;
    Pkg_Get.p_get_inventory(v_row_inv, -1);
    
    IF v_row_inv.status <> 'I' THEN
        Pkg_Err.p_rae('Inventarul nu este in stare Initiala! Nu poate fi Lansat!');
    END IF;

    Pkg_Inv.p_freeze_stock      (   p_ref_inventory     =>  p_ref_inventory, 
                                    p_commit            =>  'N');
    
    Pkg_Inv.p_detail_from_stock (   p_ref_inventory     =>  p_ref_inventory, 
                                    p_commit            =>  'N');
    
    v_row_inv.status    :=  'L';
    
    COMMIT;

EXCEPTION WHEN OTHERS THEN 
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
    
END;

/****************************************************************************************************
    DDL:    27/11/2008  d   Create 
/****************************************************************************************************/
PROCEDURE p_inventory_apply  (   p_ref_inventory NUMBER)
----------------------------------------------------------------------------------------------------
--  PURPOSE:    INVENTORY correction  ;
-----------------------------------------------------------------------------------------------------
IS
    v_row_inv               INVENTORY%ROWTYPE;
    v_row_trh               WHS_TRN%ROWTYPE;
    it_pre                  Pkg_Rtype.ta_vw_blo_prepare_trn;
    idx_pre                 INTEGER;
    C_SEGMENT_CODE          VARCHAR2(30)    :=  'VW_BLO_PREPARE_TRN';
    
BEGIN

    Pkg_App_Secur.p_test_grant('APP_ADMIN');

    v_row_inv.idriga        :=  p_ref_inventory;
    Pkg_Get.p_get_inventory(v_row_inv,-1);
    
    FOR x IN C_DIFF_INV(p_ref_inventory, NULL)
    LOOP
        idx_pre                         :=  it_pre.COUNT + 1;
        it_pre(idx_pre).segment_code    :=  C_SEGMENT_CODE;
        it_pre(idx_pre).org_code        :=  x.org_code;
        it_pre(idx_pre).item_code       :=  x.item_code;
        it_pre(idx_pre).colour_code     :=  x.colour_code;
        it_pre(idx_pre).size_code       :=  x.size_code;
        it_pre(idx_pre).oper_code_item  :=  x.oper_code_item;
        it_pre(idx_pre).season_code     :=  x.season_code;
        it_pre(idx_pre).order_code      :=  x.order_code;
        it_pre(idx_pre).group_code      :=  x.group_code;
        it_pre(idx_pre).whs_code        :=  x.whs_code;
        it_pre(idx_pre).puom            :=  x.i_puom;
        
        IF x.qty_inv > x.qty_stock THEN
            -- PLUS correction 
            it_pre(idx_pre).trn_sign    :=  +1;
            it_pre(idx_pre).qty         :=  x.qty_inv - x.qty_stock;
            IF x.k_custody = 'Y' THEN
                it_pre(idx_pre).reason_code     :=  Pkg_Glb.C_P_IINVCUST;
            ELSE    
                it_pre(idx_pre).reason_code     :=  Pkg_Glb.C_P_IINVPATR;
            END IF;
        ELSE
            -- MINUS correction 
            it_pre(idx_pre).trn_sign    :=  -1;
            it_pre(idx_pre).qty         :=  x.qty_stock - x.qty_inv;
            IF x.k_custody = 'Y' THEN
                it_pre(idx_pre).reason_code     :=  Pkg_Glb.C_M_OINVCUST;
            ELSE    
                it_pre(idx_pre).reason_code     :=  Pkg_Glb.C_M_OINVPATR;
            END IF;
        END IF;
    END LOOP;
    
    -- if differences found make a correction transaction  
    IF it_pre.COUNT > 0 THEN
        v_row_trh.org_code      :=  v_row_inv.org_code;
        v_row_trh.trn_year      :=  TO_CHAR(v_row_inv.inv_date,'YYYY');
        v_row_trh.trn_date      :=  v_row_inv.inv_date;
        v_row_trh.trn_type      :=  Pkg_Glb.C_TRN_INV_STC;
        v_row_trh.date_legal    :=  v_row_inv.inv_date;
        v_row_trh.flag_storno   :=  'N';
        Pkg_Iud.p_vw_blo_prepare_trn_miud('I',it_pre);
        Pkg_Mov.p_whs_trn_engine(v_row_trh);
        --  set INVEntory status to (T)erminate and connect it to the warehouse transaction 
        --  that corrected the differences 
        v_row_inv.status        :=  'T';
        v_row_inv.ref_whs_trn   :=  v_row_trh.idriga;
    ELSE
        Pkg_Err.p_rae('Nu sunt corectii de aplicat!');
    END IF;
    
    
    COMMIT;
    
EXCEPTION WHEN OTHERS THEN 
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));    
END;

END;

/

/
