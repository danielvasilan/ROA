--------------------------------------------------------
--  DDL for Package Body PKG_PROD
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_PROD" 
AS

-----------------------------------------------------------------------------------------------------
--  Will have the Production logics: DPR, Quality, routings
--
-----------------------------------------------------------------------------------------------------


/****************************************************************************************************
    DDL:    27/02/2008  d   Create  package
            29/02/2008  d   added   p_wo_get_prod_qty

/****************************************************************************************************/

CURSOR C_MACROROUTING_DETAIL        (   p_routing_code  VARCHAR2)
                                    IS
                                    SELECT      m.*
                                    FROM        MACROROUTING_DETAIL     m
                                    WHERE       routing_code            =   p_routing_code
                                    ORDER BY    seq_no
                                    ;


/****************************************************************************************************
    DDL:    27/02/2008  d   Create

/****************************************************************************************************/
PROCEDURE p_macrorouting_detail_iud     (   p_tip   VARCHAR2,
                                            p_row   MACROROUTING_DETAIL%ROWTYPE)
-----------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD logic for macrorouting
--
-----------------------------------------------------------------------------------------------------
IS
    v_found_start       BOOLEAN;
    v_found_end         BOOLEAN;

BEGIN

    -- IUD
    Pkg_Iud.p_macrorouting_detail_iud(p_tip, p_row);

    v_found_start   :=  FALSE;
    v_found_end     :=  FALSE;

    -- post IUD CHECKS
    FOR x IN C_MACROROUTING_DETAIL  (p_row.routing_code)
    LOOP
        IF x.flag_selected = 'Y' AND v_found_end THEN
            Pkg_Lib.p_rae('Routing-ul este discontinuu! Verificati!');
        END IF;

        IF x.flag_selected = 'Y' AND NOT v_found_start THEN
            v_found_start   :=      TRUE;
        END IF;

        IF x.flag_selected = 'N' AND v_found_start THEN
            v_found_end     :=      TRUE;
        END IF;

    END LOOP;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/****************************************************************************************************
    DDL:    27/02/2008  d   Create

/****************************************************************************************************/
PROCEDURE p_macrorouting_header_iud     (   p_tip   VARCHAR2,
                                            p_row   MACROROUTING_HEADER%ROWTYPE)
-----------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD logic for macrorouting Header;
--              generates the DETAIL lines if it's a new ROUTING
-----------------------------------------------------------------------------------------------------
IS
    CURSOR C_OPERATION      IS
                            SELECT      *
                            FROM        OPERATION
                            ORDER BY    oper_seq
                            ;

    v_row_rout_d            MACROROUTING_DETAIL%ROWTYPE;
    it_rou_d                Pkg_Rtype.ta_macrorouting_detail;

BEGIN

    -- IUD
    Pkg_Iud.p_macrorouting_header_iud(p_tip, p_row);

    -- post IUD CHECKS

    IF p_tip = 'I' THEN
        -- insert in MACROROUTING_DETAIL all the operations
        FOR x IN C_OPERATION
        LOOP
            v_row_rout_d.routing_code       :=  p_row.routing_code;
            v_row_rout_d.seq_no             :=  x.oper_seq;
            v_row_rout_d.oper_code          :=  x.oper_code;
            v_row_rout_d.flag_selected      :=  'Y';
            v_row_rout_d.flag_milestone     :=  'Y';
            it_rou_d(it_rou_d.COUNT + 1)          :=  v_row_rout_d;
        END LOOP;
        Pkg_Iud.p_macrorouting_detail_miud(p_tip, it_rou_d);
    END IF;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/****************************************************************************************************
    DDL:    27/02/2008  d   Create

/****************************************************************************************************/
FUNCTION f_sql_frm_rou_header       RETURN          typ_frm     pipelined
--------------------------------------------------------------------------------------------
--  PURPOSE:    SQL function for MACROROUTING_HEADER
--------------------------------------------------------------------------------------------
IS

    CURSOR  C_LINES IS
                SELECT  *
                FROM    MACROROUTING_HEADER
                ORDER   BY routing_code
                ;

    v_row         tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES LOOP

        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  X.routing_code;
        v_row.txt02     :=  x.description;
        v_row.txt03     :=  Pkg_Prod.f_get_routing_oper(x.routing_code);
          pipe ROW(v_row);
       END LOOP;

    RETURN;
END;


/****************************************************************************************************
    DDL:    27/02/2008  d   Create

/****************************************************************************************************/
FUNCTION f_sql_frm_rou_detail       (   p_routing_code  VARCHAR2)
                                        RETURN          typ_frm     pipelined
--------------------------------------------------------------------------------------------
--  PURPOSE:    SQL function for MACROROUTING_HEADER
--------------------------------------------------------------------------------------------
IS

    v_row         tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_MACROROUTING_DETAIL(p_routing_code) LOOP

        v_row.idriga    :=      X.idriga;
        v_row.dcn       :=      X.dcn;
        v_row.seq_no    :=      x.seq_no;

        v_row.txt01     :=      X.routing_code;
        v_row.txt02     :=      X.oper_code;
        v_row.txt03     :=      x.flag_selected;
        v_row.txt04     :=      x.flag_milestone;
        v_row.numb01    :=      x.seq_no;

        pipe ROW(v_row);
    END LOOP;

    RETURN;
END;

/****************************************************************************************************
    DDL:    27/02/2008  d   Create

/****************************************************************************************************/
FUNCTION f_get_routing_oper     (   p_routing_code      VARCHAR2)
                                    RETURN              VARCHAR2
-----------------------------------------------------------------------------------------------------
--  PURPOSE:    returns a concatenated string with the routing operations
-----------------------------------------------------------------------------------------------------
IS
    v_result        VARCHAR2(500);
BEGIN

    FOR x IN C_MACROROUTING_DETAIL  (p_routing_code)
    LOOP
        IF x.flag_selected = 'Y' THEN
            v_result    :=  v_result||x.oper_code||'->';
        END IF;
    END LOOP;
    v_result        :=  RTRIM(v_result, '->');

    RETURN v_result;

--EXCEPTION WHEN OTHERS THEN
--    RETURN 'ERROR !!!!!';
END;


/****************************************************************************************************
    29/02/3008  d   Create date

/****************************************************************************************************/
PROCEDURE   p_wo_get_prod_qty       (   p_org_code      VARCHAR2,
                                        p_order_code    VARCHAR2,
                                        it_prod_qty     OUT Pkg_Glb.typ_varchar_varchar
                                    )
-----------------------------------------------------------------------------------------------------
--  PURPOSE:    return in a PL/SQL table the producted quantities for all the WO operations
--
-----------------------------------------------------------------------------------------------------
IS

    CURSOR C_PROD_QTY               (   p_org_code      VARCHAR2, p_order_code  VARCHAR2)
                                    IS
                                    SELECT      td.oper_code_item   ,
                                                SUM(qty)            qty
                                    --------------------------------------------------------
                                    FROM        WHS_TRN             th
                                    INNER JOIN  WHS_TRN_DETAIL      td ON td.ref_trn = th.idriga
                                    --------------------------------------------------------
                                    WHERE
                                                th.flag_storno      =   'N'
                                        AND     th.org_code         =   p_org_code
                                        AND     td.order_code       =   p_order_code
                                        AND     td.reason_code      =   '+IPRDSP'
                                    --------------------------------------------------------
                                    GROUP BY    td.oper_code_item
                                    ;

BEGIN
    it_prod_qty.DELETE;

    FOR x IN C_PROD_QTY (p_org_code, p_order_code)
    LOOP
            it_prod_qty (x.oper_code_item)  :=  x.qty;
    END LOOP;

END;

/*****************************************************************************************************
    DDL:    03/03/2008  d   Create
            23/05/2008  d   make DPR for all the operations that goes with the declared milestone
                            (In/OUT pairs)
            19/11/2998  d   TRN_FIN generates stock on WIP, no more in EXP
            02/12/2008  d   (bug fix) TRN_FIN generates stock on default organization consumption warehouse
/*****************************************************************************************************/
PROCEDURE p_dpr                     (   p_org_code      VARCHAR2,
                                        p_group_code    VARCHAR2,
                                        p_oper_code     VARCHAR2,
                                        p_employee_code VARCHAR2,
                                        p_wc_code       VARCHAR2,
                                        p_date_legal    DATE,
                                        p_commit        BOOLEAN
                                    )
------------------------------------------------------------------------------------------------------
--  PURPOSE:    DPR ENGINE = makes a production declaration at the lowest level : WORK_ORDER + SIZE
--
--  PREREQ:     in VW_PREP_DPR must exist the quantities to be declared
--
--  INPUT:      ORG_CODE        =>
--              GROUP_CODE      =>
--              OPER_CODE       =>
--              EMPLOYEE_CODE   =>
--              DATE_LEGAL      =>
--              COMMIT          =>
------------------------------------------------------------------------------------------------------
IS
    --
    CURSOR C_DPR    IS
                    SELECT      t.org_code,
                                t.order_code,
                                o.item_code,
                                o.season_code,
                                t.size_code,
                                MAX(t.prod_qty)         prod_qty,
                                MAX(i.puom)             puom
                    ----------------------------------------------------------------------------
                    FROM        VW_PREP_DPR             t
                    INNER JOIN  WORK_ORDER              o   ON  o.org_code      =   t.org_code
                                                            AND o.order_code    =   t.order_code
                    INNER JOIN  ITEM                    i   ON  i.org_code      =   o.org_code
                                                            AND i.item_code     =   o.item_code
                    ----------------------------------------------------------------------------
                    GROUP BY    t.org_code,
                                o.item_code,
                                t.order_code,
                                o.season_code,
                                t.size_code
                    ;

    CURSOR C_CONSUM (   p_group_code   VARCHAR2, p_oper_code VARCHAR2)
                    IS
                    SELECT      t.org_code              ,
                                g.season_code           ,
                                DECODE(bg.oper_code_item,NULL,NULL,t.order_code)
                                                        order_code,
                                bg.item_code            ,
                                bg.oper_code_item       ,
                                bg.size_code            ,
                                bg.colour_code          ,
                                SUM(bg.qta*t.prod_qty)  qty,
                                MAX(i.puom)             puom
                    ---------------------------------------------------------
                    FROM        WORK_GROUP      g
                    INNER JOIN  BOM_GROUP       bg      ON  bg.ref_group    = g.idriga
                    INNER JOIN  ITEM            i       ON  i.org_code      = bg.org_code
                                                        AND i.item_code     = bg.item_code
                    INNER JOIN  WO_GROUP        wg      ON  wg.group_code   = g.group_code
                                                        AND wg.oper_code    =   bg.oper_code
                    INNER JOIN  VW_PREP_DPR     t
                                                        ON  t.org_code      = wg.org_code
                                                        AND t.order_code    = wg.order_code
                    ---------------------------------------------------------
                    WHERE       g.group_code    =   p_group_code
                        AND     bg.oper_code    IN  (SELECT txt01 FROM TABLE(Pkg_Lib.f_sql_inlist(p_oper_code,',')))
                        AND     (
                                    (
                                    i.flag_range    =   -1
                                    AND
                                    t.size_code     BETWEEN NVL(NVL(bg.start_size,i.start_size),Pkg_Glb.C_SIZE_MIN)
                                                    AND NVL(NVL(bg.end_size,i.end_size),    Pkg_Glb.C_SIZE_MAX)
                                    )
                                OR
                                    (
                                    i.flag_size     =   -1
                                    AND
                                    t.size_code     =   bg.size_code
                                    )
                                )
                    GROUP BY    t.org_code          ,
                                g.season_code       ,
                                DECODE(bg.oper_code_item,NULL,NULL,t.order_code),
                                bg.item_code        ,
                                bg.oper_code_item   ,
                                bg.size_code        ,
                                bg.colour_code
                    ;

    CURSOR C_INFO_OPER  (   p_ref_group    VARCHAR2, p_oper_code VARCHAR2)
                        IS
                        SELECT      A.*
                        FROM
                            (
                            SELECT      lag (r.oper_code)   OVER(ORDER BY r.seq_no) prev_oper,
                                        lead(r.oper_code)   OVER(ORDER BY r.seq_no) next_oper,
                                        lag (r.seq_no)      OVER(ORDER BY r.seq_no) prev_seq,
                                        lead(r.seq_no)      OVER(ORDER BY r.seq_no) next_seq,
                                        r.oper_code         ,
                                        r.whs_cons          ,
                                        r.whs_dest          ,
                                        r.workcenter_code   ,
                                        r.milestone         ,
                                        r.seq_no            ,
                                        w.costcenter_code   ,
                                        w.whs_code          ,
                                        c.org_code          ,
                                        h.category_code     h_category_code
                            ---------------------------------------------------------
                            FROM        GROUP_ROUTING       r
                            LEFT JOIN   WORKCENTER          w   ON  w.workcenter_code   =   r.workcenter_code
                            LEFT JOIN   COSTCENTER          c   ON  c.costcenter_code   =   w.costcenter_code
                            LEFT JOIN   WAREHOUSE           h   ON  h.whs_code          =   w.whs_code
                            ---------------------------------------------------------
                            WHERE       r.ref_group         =   p_ref_group
                                AND     (
                                        r.oper_code         =   p_oper_code
                                        OR
                                        NVL(r.milestone,'Y')=   'Y'
                                        )
                            ---------------------------------------------------------
                            ORDER BY    r.seq_no
                            )   A
                        WHERE           A.oper_code         =   p_oper_code
                        ;

    CURSOR C_ORD_LAST_OPER
                        IS
                        SELECT      o.order_code,
                                    md.seq_no,
                                    md.oper_code,
                                    MAX(md.oper_code) KEEP (DENSE_RANK  LAST ORDER BY seq_no)
                                                      OVER (PARTITION BY order_code )
                                                            last_order_oper
                        ------------------------------------------------------------------------------
                        FROM        WORK_ORDER              o
                        INNER JOIN  MACROROUTING_DETAIL     md  ON  md.routing_code =   o.routing_code
                                                                AND flag_selected = 'Y'
                        WHERE       EXISTS  (   SELECT      1
                                                FROM        VW_PREP_DPR     v
                                                WHERE       v.org_code      =   o.org_code
                                                    AND     v.order_code    =   o.order_code
                                            )
                        ;

    --  select the operations that must be included with the milestone operation
    --      =>  the preceding operations, not milestone
    --      =>  the following operations, if the current operation is the last milestone
    CURSOR C_MILESTONE  (p_ref_group    INTEGER,    p_seq_no    INTEGER)
                        IS
                        SELECT      r.seq_no, r.oper_code
                        FROM        GROUP_ROUTING       r
                        WHERE       r.ref_group         =   p_ref_group
                            AND     r.seq_no            <   p_seq_no
                            AND     r.milestone         =   'N'
                            AND     NOT EXISTS (    SELECT      1
                                                    FROM        GROUP_ROUTING       a
                                                    WHERE       a.ref_group         =   r.ref_group
                                                        AND     a.milestone         =   'Y'
                                                        AND     a.seq_no            >   r.seq_no
                                                        AND     a.seq_no            <   p_seq_no)
                        UNION ALL
                        SELECT      r.seq_no, r.oper_code
                        FROM        GROUP_ROUTING       r
                        WHERE       r.ref_group         =   p_ref_group
                            AND     r.seq_no            >   p_seq_no
                            AND     r.milestone         =   'N'
                            AND     NOT EXISTS (    SELECT      1
                                                    FROM        GROUP_ROUTING       a
                                                    WHERE       a.ref_group         =   r.ref_group
                                                        AND     a.milestone         =   'Y'
                                                        AND     a.seq_no            >   p_seq_no)
                        ORDER BY    1
                        ;




    -- get the quantities that are smaller that the declared in the previous operation
    CURSOR C_CHK_QTY    (p_prev_oper    VARCHAR2)
                        IS
                        SELECT      p.order_code    ,
                                    p.size_code     ,
                                    p.prod_qty      qty_cur,
                                    NVL(s.qty,0)    qty_prev
                        FROM        VW_PREP_DPR     p
                        LEFT JOIN   STOC_ONLINE     s   ON  s.org_code      =   p.org_code
                                                        AND s.order_code    =   p.order_code
                                                        AND s.size_code     =   p.size_code
                                                        AND s.oper_code_item=   p_prev_oper
                        ;

    v_row_prep_trn      VW_BLO_PREPARE_TRN%ROWTYPE;

    -- production
    v_row_trn_h         WHS_TRN%ROWTYPE;
    it_prep_trn         Pkg_Rtype.ta_vw_blo_prepare_trn;
    v_idx               PLS_INTEGER;

    -- final (versamento)
    v_row_trnh_f        WHS_TRN%ROWTYPE;
    it_prep_trn_f       Pkg_Rtype.ta_vw_blo_prepare_trn;
    v_idx_f             PLS_INTEGER;

    v_row_grp           WORK_GROUP%ROWTYPE;
    v_info_oper         C_INFO_OPER%ROWTYPE;
    it_last_oper        Pkg_Glb.typ_varchar_varchar ;
    v_oper_milestone    VARCHAR2(300);
    it_stoc             Pkg_Mov.typ_stoc;
    v_stoc_aloc         NUMBER;
    v_stoc_free         NUMBER;

    v_def_whs_cons      VARCHAR2(30)    :=  'WIP';
    v_def_whs_dest      VARCHAR2(30)    :=  'WIP';
    v_whs_fin           VARCHAR2(30)    ;
    v_whs_cons          VARCHAR2(30)    ;
    v_whs_wc            VARCHAR2(30)    ; -- if a WC parameter was sent=> determine its whs 

    C_SEGMENT_CODE      CONSTANT VARCHAR2(30)   :=  'VW_BLO_PREPARE_TRN';

BEGIN

    DELETE FROM VW_BLO_PREPARE_TRN;

    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp, 0) THEN
        Pkg_Err.p_rae('Gruparea '||p_group_code||' nu exista definita!');
    END IF;

    -- get informations about the operation
    OPEN    C_INFO_OPER (v_row_grp.idriga, p_oper_code);
    FETCH   C_INFO_OPER INTO v_info_oper;
    CLOSE   C_INFO_OPER;

    -- if the operation is not MILESTONE => cannot make a declaration on it !!!
    IF v_info_oper.milestone = 'N' THEN
        Pkg_Err.p_rae('Pe operatia '||p_oper_code||' nu se pot face declaratii de productie !!!');
    END IF;

    -- if the operation is not the first in the routing
    -- check if the stock for the previous operation is greater than the declared quantities
/*
    IF v_info_oper.prev_oper IS NOT NULL THEN
        FOR x IN C_CHK_QTY(v_info_oper.prev_oper)
        LOOP
            IF x.qty_cur > x.qty_prev THEN
                Pkg_App_Tools.p_log(p_msg_type      => 'M',
                                    p_msg_text      =>'Bola: '  ||x.order_code||' Marimea: '||x.size_code||' '
                                                                ||x.qty_cur||' > '||x.qty_prev,
                                    p_msg_context   =>  'Nu exista declaratii suficiente pe operatia anterioara =>'
                                                                ||v_info_oper.prev_oper);
            END IF;

            NULL;
        END LOOP;
    END IF;
*/
    Pkg_Lib.p_rae_m('B');

    -- determine the WHS of the parameter workcenter 
    IF p_wc_code IS NOT NULL THEN
        SELECT MAX(whs_code) into v_whs_wc
        FROM WORKCENTER
        where workcenter_code = p_wc_code;
    END IF;
    
    -- if the operation is the last for the group routing, load the it_last_oper
    --  with last operation for everi ORDER
    IF v_info_oper.next_oper IS NULL THEN
        FOR x IN C_ORD_LAST_OPER
        LOOP
            it_last_oper(x.order_code)  :=  x.last_order_oper;
        END LOOP;
    END IF;

    v_idx           :=  0;
    v_idx_f         :=  0;

    --transaction details
    FOR x IN C_DPR
    LOOP

        v_row_prep_trn.segment_code     :=  C_SEGMENT_CODE;
        v_row_prep_trn.org_code         :=  p_org_code;
        v_row_prep_trn.item_code        :=  x.item_code;
        v_row_prep_trn.colour_code      :=  NULL;
        v_row_prep_trn.size_code        :=  x.size_code;
        v_row_prep_trn.season_code      :=  x.season_code;
        v_row_prep_trn.order_code       :=  x.order_code;
        v_row_prep_trn.puom             :=  x.puom;
        v_row_prep_trn.qty              :=  x.prod_qty;

        -- if a previous operation exists for the routing
        IF v_info_oper.prev_oper IS NOT NULL THEN
                v_idx                               :=  v_idx + 1;

                it_prep_trn(v_idx)                  :=  v_row_prep_trn;
                it_prep_trn(v_idx).oper_code_item   :=  v_info_oper.prev_oper;
                it_prep_trn(v_idx).group_code       :=  p_group_code;
                it_prep_trn(v_idx).whs_code         :=  NVL(v_whs_wc, NVL(v_info_oper.whs_code, v_def_whs_cons));
                it_prep_trn(v_idx).wc_code          :=  NVL(p_wc_code, v_info_oper.workcenter_code);
                it_prep_trn(v_idx).cost_center      :=  v_info_oper.costcenter_code;
                it_prep_trn(v_idx).trn_sign         :=  -1;
                it_prep_trn(v_idx).reason_code      :=  Pkg_Glb.C_M_OPRDSP;
        END IF;

        ------------------------------------------------------------------------------
        -- load on the new operation
        ------------------------------------------------------------------------------

        v_idx                               :=  v_idx + 1;

        it_prep_trn(v_idx)                  :=  v_row_prep_trn;
        it_prep_trn(v_idx).reason_code      :=  Pkg_Glb.C_P_IPRDSP;
        it_prep_trn(v_idx).trn_sign         :=  +1;

        it_prep_trn(v_idx).oper_code_item   :=  p_oper_code;
        it_prep_trn(v_idx).group_code       :=  p_group_code;
        it_prep_trn(v_idx).whs_code         :=  NVL(v_whs_wc, NVL(v_info_oper.whs_dest, v_def_whs_dest));
        it_prep_trn(v_idx).wc_code          :=  NVL(p_wc_code, v_info_oper.workcenter_code);
        it_prep_trn(v_idx).cost_center      :=  v_info_oper.costcenter_code;

        ------------------------------------------------------------------------------
        --  secondary operations declarations (not milestones)
        ------------------------------------------------------------------------------
        FOR xx IN C_MILESTONE (v_row_grp.idriga, v_info_oper.seq_no)
        LOOP
            v_idx                               :=  v_idx + 1;
            it_prep_trn(v_idx)                  :=  v_row_prep_trn;
            it_prep_trn(v_idx).reason_code      :=  Pkg_Glb.C_P_IPRDSP;
            it_prep_trn(v_idx).trn_sign         :=  +1;

            it_prep_trn(v_idx).oper_code_item   :=  xx.oper_code;
            it_prep_trn(v_idx).group_code       :=  p_group_code;
            it_prep_trn(v_idx).whs_code         :=  NVL(v_whs_wc, NVL(v_info_oper.whs_dest, v_def_whs_dest));
            it_prep_trn(v_idx).wc_code          :=  NVL(p_wc_code, v_info_oper.workcenter_code);
            it_prep_trn(v_idx).cost_center      :=  v_info_oper.costcenter_code;

            v_idx                               :=  v_idx + 1;
            it_prep_trn(v_idx)                  :=  it_prep_trn(v_idx - 1);
            it_prep_trn(v_idx).reason_code      :=  Pkg_Glb.C_M_OPRDSP;            
            it_prep_trn(v_idx).trn_sign         :=  -1;

        END LOOP;


        -- if the operation is the last in the routing => make the final declaration (versamento)
        IF v_info_oper.next_oper IS NULL THEN
                --  check if there is declared a FIN warehouse for the organization where the operation
                --  is declared
                v_whs_fin       :=  Pkg_Order.f_get_default_whs_fin(v_info_oper.org_code);
                IF v_whs_fin    IS NULL THEN
                    Pkg_App_Tools.P_Log('M',v_info_oper.org_code,'Nu este definita o magazie de produs finit pentru organizatia');
                END IF;

                    -- must check THIS !!!!!!!!!!!!!!!!!
                -- IF Pkg_Lib.f_table_value(it_last_oper, x.order_code, '') = p_oper_code THEN

                    v_idx_f                                 :=  v_idx_f + 1;

                    it_prep_trn_f(v_idx_f)                  :=  v_row_prep_trn;

                    it_prep_trn_f(v_idx_f).reason_code      :=  Pkg_Glb.C_M_TFINPF;
                    it_prep_trn_f(v_idx_f).trn_sign         :=  -1;
                    it_prep_trn_f(v_idx_f).oper_code_item   :=  p_oper_code;
                    it_prep_trn_f(v_idx_f).group_code       :=  p_group_code;
                    it_prep_trn_f(v_idx_f).whs_code         :=  NVL(v_whs_wc, NVL(v_info_oper.whs_code, v_def_whs_cons));
                    it_prep_trn_f(v_idx_f).wc_code          :=  NVL(p_wc_code, v_info_oper.workcenter_code);
                    it_prep_trn_f(v_idx_f).cost_center      :=  v_info_oper.costcenter_code;

                    -- load the Finish Product warehouse
                    v_idx_f                                 :=  v_idx_f + 1;

                    it_prep_trn_f(v_idx_f)                  :=  v_row_prep_trn;
                    it_prep_trn_f(v_idx_f).reason_code      :=  Pkg_Glb.C_P_TFINPF;
                    it_prep_trn_f(v_idx_f).trn_sign         :=  +1;
                    it_prep_trn_f(v_idx_f).oper_code_item   :=  Pkg_Lib.f_table_value(it_last_oper, x.order_code, '');
                    it_prep_trn_f(v_idx_f).group_code       :=  NULL;
                    -- TEMPORARY !!!
                    it_prep_trn_f(v_idx_f).whs_code         :=  v_whs_fin;--Pkg_Order.f_get_default_whs_cons(v_info_oper.org_code);--Pkg_Order.f_get_default_whs_fin(v_info_oper.org_code);
                    it_prep_trn_f(v_idx_f).cost_center      :=  v_info_oper.costcenter_code;
                    it_prep_trn_f(v_idx_f).wc_code          :=  NVL(p_wc_code, v_info_oper.workcenter_code);

                -- END IF;
        END IF;

    END LOOP;

    ------------------------------------------------------------------------------
    -- MATERIAL CONSUMPTION
    ------------------------------------------------------------------------------

    -- determine the operations that go with the MILESTONE
    v_oper_milestone    :=  v_info_oper.oper_code ||',';
    FOR x IN C_MILESTONE (v_row_grp.idriga, v_info_oper.seq_no)
    LOOP
        v_oper_milestone    :=  v_oper_milestone || x.oper_code || ',';
    END LOOP;

    --
    FOR x IN C_CONSUM   (p_group_code, v_oper_milestone)
    LOOP

            v_whs_cons                      :=  NVL(v_whs_wc, NVL(v_info_oper.whs_code,v_def_whs_cons));

            v_row_prep_trn.segment_code     :=  C_SEGMENT_CODE;
            v_row_prep_trn.org_code         :=  p_org_code;
            v_row_prep_trn.item_code        :=  x.item_code;
            v_row_prep_trn.colour_code      :=  x.colour_code;
            v_row_prep_trn.size_code        :=  x.size_code;
            v_row_prep_trn.oper_code_item   :=  x.oper_code_item;
            v_row_prep_trn.season_code      :=  x.season_code;
            v_row_prep_trn.order_code       :=  NULL;
            v_row_prep_trn.whs_code         :=  v_whs_cons;
            v_row_prep_trn.wc_code          :=  NVL(p_wc_code, v_info_oper.workcenter_code);            
            v_row_prep_trn.cost_center      :=  v_info_oper.costcenter_code;
            v_row_prep_trn.puom             :=  x.puom;

            -- FOR CTL warehouse,
            --      1)  allocate the needed quantity - already allocated
            --      2)  consume the allocated
            IF v_info_oper.h_category_code = Pkg_Glb.C_WHS_CTL THEN
                -- get the stock
                Pkg_Mov.p_item_stoc (   it_stoc        =>  it_stoc,
                                        p_item         =>  x.item_code,
                                        p_org_code     =>  p_org_code
                                    );
                -- allocated stock
                v_stoc_aloc     :=  Pkg_Mov.f_item_stoc
                                                (   it_stoc         =>  it_stoc,
                                                    p_whs_code      =>  v_whs_cons,
                                                    p_season_code   =>  x.season_code,
                                                    p_size_code     =>  x.size_code,
                                                    p_colour_code   =>  x.colour_code,
                                                    p_oper_code     =>  x.oper_code_item,
                                                    p_group_code    =>  p_group_code,
                                                    p_order_code    =>  NULL
                                                );

                -- not allocated stock (free)
                v_stoc_free     :=  Pkg_Mov.f_item_stoc
                                                (   it_stoc         =>  it_stoc,
                                                    p_whs_code      =>  v_whs_cons,
                                                    p_season_code   =>  x.season_code,
                                                    p_size_code     =>  x.size_code,
                                                    p_colour_code   =>  x.colour_code,
                                                    p_oper_code     =>  x.oper_code_item,
                                                    p_group_code    =>  NULL,
                                                    p_order_code    =>  NULL
                                                );

                -- allocation movement
                IF (x.qty > v_stoc_aloc) AND v_stoc_free > 0 THEN
                    -- decrease the not allocated stock
                    v_idx                               :=  v_idx  + 1;
                    it_prep_trn(v_idx)                  :=  v_row_prep_trn;
                    it_prep_trn(v_idx).group_code       :=  NULL;
                    it_prep_trn(v_idx).qty              :=  LEAST(x.qty - v_stoc_aloc, v_stoc_free);
                    it_prep_trn(v_idx).trn_sign         :=  -1;
                    it_prep_trn(v_idx).reason_code      :=  Pkg_Glb.C_M_TALCMF;

                    -- increase the allocated stock
                    v_idx                               :=  v_idx + 1;
                    it_prep_trn(v_idx)                  :=  v_row_prep_trn;
                    it_prep_trn(v_idx).group_code       :=  p_group_code;
                    it_prep_trn(v_idx).qty              :=  LEAST(x.qty - v_stoc_aloc, v_stoc_free);
                    it_prep_trn(v_idx).trn_sign         :=  +1;
                    it_prep_trn(v_idx).reason_code      :=  Pkg_Glb.C_P_TALCMO;

                END IF;

            END IF;

            -- consume from allocated stock
            v_idx                               :=  v_idx + 1;
            it_prep_trn(v_idx)                  :=  v_row_prep_trn;
            it_prep_trn(v_idx).group_code       :=  p_group_code;
            it_prep_trn(v_idx).qty              :=  x.qty;
            it_prep_trn(v_idx).trn_sign         :=  -1;
            it_prep_trn(v_idx).reason_code      :=  Pkg_Glb.C_M_OPRDMP;

    END LOOP;

    -- PROD declaration
    IF it_prep_trn.COUNT > 0 THEN

        DELETE FROM VW_BLO_PREPARE_TRN;

        -- transaction header for DPR
        v_row_trn_h.org_code        :=  p_org_code;
        v_row_trn_h.trn_year        :=  TO_CHAR(SYSDATE, 'YYYY');
        v_row_trn_h.trn_type        :=  Pkg_Glb.C_TRN_PROD;
        v_row_trn_h.flag_storno     :=  'N';
        v_row_trn_h.date_legal      :=  p_date_legal;
        v_row_trn_h.employee_code   :=  null;--p_employee_code;
        v_row_trn_h.note            :=  p_oper_code;

        Pkg_Iud.p_vw_blo_prepare_trn_miud('I',it_prep_trn);
        Pkg_Mov.p_whs_trn_engine(v_row_trn_h);
    ELSE
        Pkg_Err.p_rae('Nu exista cantitati de declarat!');
    END IF;

    -- FIN  declaration
    IF it_prep_trn_f.COUNT > 0 THEN

        DELETE FROM VW_BLO_PREPARE_TRN;

        -- prepaire the final declaration header
        v_row_trnh_f.org_code       :=  p_org_code;
        v_row_trnh_f.trn_year       :=  TO_CHAR(SYSDATE, 'YYYY');
        v_row_trnh_f.trn_type       :=  Pkg_Glb.C_TRN_TRN_FIN;
        v_row_trnh_f.flag_storno    :=  'N';
        v_row_trnh_f.date_legal     :=  p_date_legal;
        v_row_trnh_f.employee_code  :=  p_employee_code;

        Pkg_Iud.p_vw_blo_prepare_trn_miud('I',it_prep_trn_f);
        Pkg_Mov.p_whs_trn_engine(v_row_trnh_f);
    END IF;

    IF p_commit THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_commit THEN ROLLBACK; END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/******************************************************************************************************
    DDL:    d   Create
/******************************************************************************************************/
PROCEDURE p_dpr_grp                 (   p_org_code      VARCHAR2,
                                        p_group_code    VARCHAR2,
                                        p_size_code     VARCHAR2,
                                        p_order_code    VARCHAR2,
                                        p_oper_code     VARCHAR2,
                                        p_employee_code VARCHAR2,
                                        p_wc_code       VARCHAR2,
                                        p_date_legal    DATE,
                                        p_qty           NUMBER
                                    )
-------------------------------------------------------------------------------------------------------
--  PURPOSE:    automatically declares all the remaining quatities for a GROUP
--  INPUT:      ORG_CODE    =   Organization
--              GROUP_CODE  =   Group
--              SIZE_CODE   =   (optional)  if set, declares only for that size
--              ORDER_CODE  =   (optional)  if set, declares only for that order
--              OPER_CODE   =   Operation
--              EMPLOYEE    =   (optional)  employee that made the declaration
--              DATE_LEGAL  =   the date when the operation was made for real
-------------------------------------------------------------------------------------------------------
IS

    -- check if the operation is defined on GROUP ROUTING
    CURSOR C_CHK_OPER   (   p_group_code    VARCHAR2, p_oper_code VARCHAR2)
                        IS
                        SELECT      1
                        FROM        GROUP_ROUTING       r
                        INNER JOIN  WORK_GROUP          g   ON  g.idriga    =   r.ref_group
                        WHERE       g.group_code        =   p_group_code
                            AND     r.oper_code         =   p_oper_code
                        ;

    --
    CURSOR C_DPR        (           p_size_code             VARCHAR2,
                                    p_order_code            VARCHAR2
                        )
                        IS
                        SELECT      n.org_code              ,
                                    n.order_code            ,
                                    n.size_code             ,
                                    n.nom_qty               ,
                                    NVL(d.dpr_qty,0)        dpr_qty
                        ----------------------------------------------------------------------------
                        FROM        VW_PREP_GRP_NOM_QTY     n
                        LEFT JOIN   VW_PREP_GRP_DPR_QTY     d   ON  d.org_code      =   n.org_code
                                                                AND d.order_code    =   n.order_code
                                                                AND d.size_code     =   n.size_code
                        ----------------------------------------------------------------------------
                        WHERE       n.size_code             =   NVL(p_size_code, n.size_code)
                            AND     n.order_code            =   NVL(p_order_code, n.order_code)
                        ----------------------------------------------------------------------------
                        ORDER BY    n.order_code,
                                    n.size_code
                        ;

    v_row_pre           VW_PREP_DPR%ROWTYPE;
    C_SEGMENT_CODE      CONSTANT VARCHAR2(30)   :=  'VW_PREP_DPR';
    v_row_ckop          C_CHK_OPER%ROWTYPE;
    v_found             BOOLEAN;
    v_date_legal        DATE;
    v_qty_declare       NUMBER  :=  0;
    v_qty_prog          NUMBER  :=  0;

BEGIN

    -- check if the Operation exists on Group Routing
    OPEN    C_CHK_OPER  (p_group_code, p_oper_code);
    FETCH   C_CHK_OPER  INTO v_row_ckop; v_found   := C_CHK_OPER%FOUND;
    CLOSE   C_CHK_OPER;
    IF NOT v_found THEN
        Pkg_App_Tools.P_Log('M','Operatia '||p_oper_code||' nu exista definita pe routing-ul comenzii!','Date insuficiente');
    END IF;
    IF p_qty <= 0 THEN
        Pkg_App_Tools.P_Log('M','Cantitatea declarata trebuie sa fie mai mare decat 0 !','Date insuficiente');
    END IF;
    Pkg_Lib.p_rae_m('B');

    v_date_legal        :=  NVL(p_date_legal, TRUNC(SYSDATE));

    -- get the declared quantities for the OPER
    Pkg_Prod.p_prep_grp_dpr_qty(p_group_code, p_oper_code);

    -- prepaire data
    Pkg_Order.p_prep_grp_nom_qty(p_group_code, p_oper_code);

    DELETE FROM VW_PREP_DPR;

    --
    FOR x IN C_DPR  (p_size_code, p_order_code)
    LOOP
        -- determine the quantity to be declared
        IF p_qty IS NULL THEN
            v_qty_declare   :=  x.nom_qty - x.dpr_qty;
        ELSE
            v_qty_declare   :=  LEAST(x.nom_qty - x.dpr_qty, p_qty - v_qty_prog);
        END IF;

        -- debug
        Pkg_App_Tools.P_Log('L','ROW:'||C_DPR%rowcount||' NOM:'||x.nom_qty||' DPR:'||x.dpr_qty||' PROG:'||v_qty_prog||' DECL:'||v_qty_declare,'');

        --
        IF v_qty_declare > 0    THEN
            v_row_pre.org_code      :=  x.org_code;
            v_row_pre.order_code    :=  x.order_code;
            v_row_pre.size_code     :=  x.size_code;
            v_row_pre.prod_qty      :=  v_qty_declare;
            v_row_pre.segment_code  :=  C_SEGMENT_CODE;

            INSERT INTO VW_PREP_DPR VALUES v_row_pre;

            -- debug
            Pkg_App_Tools.P_Log('L','Insert in VW_PREP_DPR','');

            -- progressivo
            v_qty_prog              :=  v_qty_prog  + v_qty_declare;

        END IF;
    END LOOP;

    -- call the declaring engine
    p_dpr               (   p_org_code      =>  p_org_code      ,
                            p_group_code    =>  p_group_code    ,
                            p_oper_code     =>  p_oper_code     ,
                            p_employee_code =>  p_employee_code ,
                            p_wc_code       =>  p_wc_code,
                            p_date_legal    =>  v_date_legal,
                            p_commit        =>  FALSE
                        );


    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/******************************************************************************************************
    DDL:    14/03/2008  d   Create
/******************************************************************************************************/
PROCEDURE p_dpr_manual              (   p_org_code      VARCHAR2,
                                        p_group_code    VARCHAR2,
                                        p_oper_code     VARCHAR2,
                                        p_wc_code       VARCHAR2,
                                        p_employee_code VARCHAR2,
                                        p_date_legal    DATE
                                    )
-------------------------------------------------------------------------------------------------------
--  PURPOSE:    Manual production declarations (based on user input)
--  PREREQ :    in VW_TRANSFER_ORACLE must exist the declared values
-------------------------------------------------------------------------------------------------------
IS

    CURSOR C_DPR        IS
                        SELECT      t.txt01                 order_code,
                                    t.txt02                 size_code,
                                    t.numb01                dpr_qty,
                                    n.nom_qty               nom_qty,
                                    NVL(d.dpr_qty,0)        declared_qty
                        ------------------------------------------------------------------------------
                        FROM        VW_TRANSFER_ORACLE      t
                        INNER JOIN  VW_PREP_GRP_NOM_QTY     n   ON  n.org_code      =   p_org_code
                                                                AND n.order_code    =   t.txt01
                                                                AND n.size_code     =   t.txt02
                        LEFT JOIN   VW_PREP_GRP_DPR_QTY     d   ON  d.org_code      =   n.org_code
                                                                AND d.order_code    =   n.order_code
                                                                AND d.size_code     =   n.size_code
                        -------------------------------------------------------------------------------
                        WHERE       t.numb01 IS NOT NULL
                        ;

    v_row_pre           VW_PREP_DPR%ROWTYPE;
    C_SEGMENT_CODE      CONSTANT VARCHAR2(30)   :=  'VW_PREP_DPR';
    v_date_legal        DATE;
    v_qty_declare       NUMBER  :=  0;

BEGIN

    v_date_legal        :=  NVL(p_date_legal, TRUNC(SYSDATE));

    -- get the declared quantities for the OPER
    Pkg_Prod.p_prep_grp_dpr_qty(p_group_code, p_oper_code);

    -- prepaire data
    Pkg_Order.p_prep_grp_nom_qty(p_group_code, p_oper_code);

    DELETE FROM VW_PREP_DPR;

    FOR x IN C_DPR
    LOOP
        -- determine the quantity to be declared
        v_qty_declare   :=  LEAST(x.nom_qty - x.declared_qty, x.dpr_qty);

        -- debug
        Pkg_App_Tools.P_Log('L','ROW:'||C_DPR%rowcount||' NOM:'||x.nom_qty||' DPR:'||x.dpr_qty||' DECL:'||x.declared_qty,'');

        --
        IF v_qty_declare > 0    THEN
            v_row_pre.org_code      :=  p_org_code;
            v_row_pre.order_code    :=  x.order_code;
            v_row_pre.size_code     :=  x.size_code;
            v_row_pre.prod_qty      :=  v_qty_declare;
            v_row_pre.segment_code  :=  C_SEGMENT_CODE;

            INSERT INTO VW_PREP_DPR VALUES v_row_pre;

            -- debug
            Pkg_App_Tools.P_Log('L','Insert in VW_PREP_DPR','');


        END IF;
    END LOOP;

    -- call the declaring engine
    p_dpr               (   p_org_code      =>  p_org_code      ,
                            p_group_code    =>  p_group_code    ,
                            p_oper_code     =>  p_oper_code     ,
                            p_employee_code =>  p_employee_code ,
                            p_wc_code       =>  p_wc_code,
                            p_date_legal    =>  v_date_legal,
                            p_commit        =>  FALSE
                        );

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/**********************************************************************************************
    DDL:    09/03/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_prep_grp_dpr_qty    (   p_group_code    VARCHAR2,
                                    p_oper_code     VARCHAR2
                                )
---------------------------------------------------------------------------------------------------
--  PURPOSE:    loads in VW_PREP_GRP_DPR_QTY the declared quantities for a GROUP + OPER
---------------------------------------------------------------------------------------------------
IS
PRAGMA autonomous_transaction;

    CURSOR C_GRP_DPR_QTY        (   p_group_code    VARCHAR2,
                                    p_oper_code     VARCHAR2,
                                    p_reason_code   VARCHAR2)
                                IS
                                SELECT      td.org_code         ,
                                            td.order_code       ,
                                            td.size_code        ,
                                            td.oper_code_item   oper_code,
                                            SUM(qty*trn_sign)   dpr_qty
                                --------------------------------------------------------
                                FROM        WHS_TRN_DETAIL      td
--                                INNER JOIN  WHS_TRN             th  ON  th.idriga   =   td.ref_trn
                                --------------------------------------------------------
                                WHERE       td.group_code       =       p_group_code
                                        AND td.oper_code_item   LIKE    NVL(p_oper_code,'%')
                                        AND td.reason_code      =       p_reason_code
--                                        AND th.flag_storno      =       'N'
                                --------------------------------------------------------
                                GROUP BY    td.org_code,td.order_code, td.size_code,td.oper_code_item
                                ;

    v_row                       VW_PREP_GRP_DPR_QTY%ROWTYPE;
    C_REASON_DPR                CONSTANT VARCHAR2(30)   :=  Pkg_Glb.C_P_IPRDSP;
    C_REASON_EXP                CONSTANT VARCHAR2(30)   :=  Pkg_Glb.C_M_OSHPPF;
    C_SEGMENT_CODE              CONSTANT VARCHAR2(30)   :=  'VW_PREP_GRP_DPR_QTY';

BEGIN
    DELETE FROM VW_PREP_GRP_DPR_QTY;

    -- load the production declarations
    FOR x IN C_GRP_DPR_QTY  (p_group_code, p_oper_code, C_REASON_DPR)
    LOOP
        v_row.org_code      :=  x.org_code;
        v_row.group_code    :=  p_group_code;
        v_row.order_code    :=  x.order_code;
        v_row.oper_code     :=  x.oper_code;
        v_row.size_code     :=  x.size_code;
        v_row.dpr_qty       :=  x.dpr_qty;
        v_row.segment_code  :=  C_SEGMENT_CODE;
        INSERT INTO VW_PREP_GRP_DPR_QTY VALUES  v_row;
    END LOOP;

    COMMIT;
END;

/**********************************************************************************************
    DDL:    20/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_prep_ord_exp_qty    (   p_org_code      VARCHAR2,
                                    p_order_code    VARCHAR2
                                )
---------------------------------------------------------------------------------------------------
--  PURPOSE:    loads in VW_PREP_GRP_DPR_QTY the declared quantities for a GROUP + OPER
---------------------------------------------------------------------------------------------------
IS
PRAGMA autonomous_transaction;

    CURSOR C_ORD_EXP_QTY        (   p_org_code      VARCHAR2,
                                    p_order_code    VARCHAR2,
                                    p_reason_code   VARCHAR2)
                                IS
                                SELECT      td.org_code             ,
                                            td.order_code           ,
                                            td.size_code            ,
                                            SUM(qty)                exp_qty
                                --------------------------------------------------------
                                FROM        WHS_TRN_DETAIL      td
                                INNER JOIN  WHS_TRN             TH  ON TH.IDRIGA =  TD.REF_TRN
                                --------------------------------------------------------
                                WHERE       td.org_code         =       p_org_code
                                        AND td.order_code       LIKE    NVL(p_order_code,'%')
                                        AND td.reason_code      =       p_reason_code
                                        AND TH.FLAG_STORNO      =       'N'
                                --------------------------------------------------------
                                GROUP BY    td.org_code,td.order_code, td.size_code
                                ;

    v_row                       VW_PREP_ORD_EXP_QTY%ROWTYPE;
    C_REASON_EXP                CONSTANT VARCHAR2(30)   :=  Pkg_Glb.C_M_OSHPPF;
    C_SEGMENT_CODE              CONSTANT VARCHAR2(30)   :=  'VW_PREP_ORD_EXP_QTY';

BEGIN
    DELETE FROM VW_PREP_ORD_EXP_QTY;

    -- load the production declarations
    FOR x IN C_ORD_EXP_QTY  (p_org_code, p_order_code, C_REASON_EXP)
    LOOP
        v_row.org_code      :=  x.org_code;
        v_row.order_code    :=  x.order_code;
        v_row.size_code     :=  x.size_code;
        v_row.exp_qty       :=  x.exp_qty;
        v_row.segment_code  :=  C_SEGMENT_CODE;
        INSERT INTO VW_PREP_ORD_EXP_QTY VALUES  v_row;
    END LOOP;

    COMMIT;
END;


/**********************************************************************************************
    DDL:    20/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_prep_ord_exp_qty    (   p_org_code              VARCHAR2,
                                    p_order_code            VARCHAR2,
                                    it_exp_qty      IN OUT  Pkg_Glb.typ_number_varchar
                                )
------------------------------------------------------------------------------------------------
--  PURPOSE:    loads the shiped quantities for ORDER in a PL/SQL table
--              indexed by ORG+ORDER+SIZE
------------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES              IS
                                SELECT      *
                                FROM        VW_PREP_ORD_EXP_QTY
                                ;

    v_idx                       VARCHAR2(200);

BEGIN

    -- empty the PL/SQL table
    it_exp_qty.DELETE;

    -- prepare data in the temporary view
    Pkg_Prod.p_prep_ord_exp_qty (   p_org_code      =>  p_org_code,
                                    p_order_code    =>  p_order_code
                                );

    --- load the PL/SQL table
    FOR x IN C_LINES
    LOOP
        v_idx               :=  Pkg_Lib.f_implode('$', x.org_code,x.order_code,x.size_code);
        it_exp_qty(v_idx)   :=  x.exp_qty;
    END LOOP;

END;

/**********************************************************************************************
    DDL:    20/11/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_prep_ord_fin_qty    (   p_org_code      VARCHAR2,
                                    p_order_code    VARCHAR2
                                )
---------------------------------------------------------------------------------------------------
--  PURPOSE:    loads in VW_PREP_GRP_FIN_QTY the FINISHED quantities or an order
---------------------------------------------------------------------------------------------------
IS
PRAGMA autonomous_transaction;

    CURSOR C_ORD_FIN_QTY        (   p_org_code      VARCHAR2,
                                    p_order_code    VARCHAR2,
                                    p_reason_code   VARCHAR2)
                                IS
                                SELECT      td.org_code             ,
                                            td.order_code           ,
                                            td.size_code            ,
                                            SUM(qty)                fin_qty
                                --------------------------------------------------------
                                FROM        WHS_TRN_DETAIL      td
                                INNER JOIN  WHS_TRN             TH  ON TH.IDRIGA =  TD.REF_TRN
                                --------------------------------------------------------
                                WHERE       td.org_code         =       p_org_code
                                        AND td.order_code       LIKE    NVL(p_order_code,'%')
                                        AND td.reason_code      =       p_reason_code
                                        AND TH.FLAG_STORNO      =       'N'
                                --------------------------------------------------------
                                GROUP BY    td.org_code,td.order_code, td.size_code
                                ;

    v_row                       VW_PREP_ORD_FIN_QTY%ROWTYPE;
    C_REASON_FIN                CONSTANT VARCHAR2(30)   :=  Pkg_Glb.C_P_TFINPF;
    C_SEGMENT_CODE              CONSTANT VARCHAR2(30)   :=  'VW_PREP_ORD_FIN_QTY';

BEGIN
    DELETE FROM VW_PREP_ORD_FIN_QTY;

    -- load the production declarations
    FOR x IN C_ORD_FIN_QTY  (p_org_code, p_order_code, C_REASON_FIN)
    LOOP
        v_row.org_code      :=  x.org_code;
        v_row.order_code    :=  x.order_code;
        v_row.size_code     :=  x.size_code;
        v_row.fin_qty       :=  x.fin_qty;
        v_row.segment_code  :=  C_SEGMENT_CODE;
        INSERT INTO VW_PREP_ORD_FIN_QTY VALUES  v_row;
    END LOOP;

    COMMIT;
END;


/**********************************************************************************************
    DDL:    19/04/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_prep_grp_dpr_qty    (   p_group_code            VARCHAR2,
                                    p_oper_code             VARCHAR2,
                                    it_dpr_qty      IN OUT  Pkg_Glb.typ_number_varchar
                                )
IS

    CURSOR C_LINES              IS
                                SELECT      *
                                FROM        VW_PREP_GRP_DPR_QTY
                                ;

    v_idx                       VARCHAR2(200);

BEGIN
    -- prepare data in the temporary view
    Pkg_Prod.p_prep_grp_dpr_qty (   p_group_code    =>  p_group_code,
                                    p_oper_code     =>  p_oper_code
                                );

    --- load the PL/SQL table
    FOR x IN C_LINES
    LOOP
        v_idx               :=  Pkg_Lib.f_implode('$', x.order_code,x.oper_code,x.size_code);
        it_dpr_qty(v_idx)   :=  x.dpr_qty;
    END LOOP;

END;

/*********************************************************************************************
    14/03/2008  d   Create date

/*********************************************************************************************/
FUNCTION f_sql_frm_dpr_list         (   p_org_code      VARCHAR2
                                    )   RETURN          typ_frm     pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for list of orders subform /DPR form
----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES      (   p_org_code  VARCHAR2)
                        IS
                        SELECT      g.idriga                ref_group,
                                    o.idriga                ref_wo,
                                    MAX(wg.org_code)        org_code,
                                    MAX(wg.order_code)      order_code,
                                    MAX(wg.group_code)      group_code,
                                    MAX(o.item_code)        item_code,
                                    MAX(i.description)      i_description
                        -----------------------------------------------------------------------
                        FROM        WO_GROUP            wg
                        INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   wg.org_code
                                                            AND o.order_code    =   wg.order_code
                        INNER JOIN  ITEM                i   ON  i.org_code      =   o.org_code
                                                            AND i.item_code     =   o.item_code
                        INNER JOIN  WORK_GROUP          g   ON  g.org_code      =   wg.org_code
                                                            AND g.group_code    =   wg.group_code
                        -----------------------------------------------------------------------
                        WHERE       g.status            =   'L'
                            AND     g.org_code          =   p_org_code
                        -----------------------------------------------------------------------
                        GROUP BY    g.idriga, o.idriga
                        ;

    CURSOR C_DPR        (   p_org_code      VARCHAR2,
                            p_group_code    VARCHAR2,
                            p_order_code    VARCHAR2,
                            p_ref_group     NUMBER
                        )
                        IS
                        SELECT      gr.seq_no               ,
                                    gr.oper_code            ,
                                    MAX(gr.milestone)       milestone,
                                    SUM(NVL(v.dpr_qty,0))   dpr_qty
                        -----------------------------------------------------------------------
                        FROM        GROUP_ROUTING       gr
                        LEFT JOIN   VW_PREP_GRP_DPR_QTY v   ON  v.group_code    =   p_group_code
                                                            AND v.org_code      =   p_org_code
                                                            AND v.order_code    =   p_order_code
                                                            AND v.oper_code     =   gr.oper_code
                        -----------------------------------------------------------------------
                        WHERE       gr.ref_group        =   p_ref_group
                        -----------------------------------------------------------------------
                        GROUP BY    gr.seq_no, gr.oper_code
                        ORDER BY    gr.seq_no
                        ;

    CURSOR C_WO_DETAIL  (   p_ref_wo    NUMBER  )
                        IS
                        SELECT      SUM(qta)        nom_qty
                        FROM        WO_DETAIL       d
                        WHERE       d.ref_wo        =   p_ref_wo
                        ;

    v_row               tmp_frm      := tmp_frm();
    v_str_dpr           VARCHAR2(1000);
    v_row_det           C_WO_DETAIL%ROWTYPE;

BEGIN
    FOR x IN C_LINES (p_org_code)
    LOOP

        Pkg_Prod.p_prep_grp_dpr_qty (   p_group_code    =>  x.group_code,
                                        p_oper_code     =>  ''
                                    );
        v_str_dpr       :=  '';
        FOR xx IN C_DPR (x.org_code, x.group_code, x.order_code, x.ref_group)
        LOOP
            IF xx.milestone = 'Y' THEN
                v_str_dpr   :=  v_str_dpr || SUBSTR(xx.oper_code,1,2) || LPAD(xx.dpr_qty,4,' ')||' ';
            ELSE
                v_str_dpr   :=  v_str_dpr || SUBSTR(xx.oper_code,1,2) || LPAD('-',4,' ')||' ';
            END IF;
        END LOOP;

        OPEN C_WO_DETAIL(x.ref_wo); FETCH C_WO_DETAIL INTO v_row_det; CLOSE C_WO_DETAIL;

        v_row.idriga    :=  C_LINES%rowcount;
        v_row.dcn       :=  0;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.group_code;
        v_row.txt03     :=  x.order_code;
        v_row.txt04     :=  x.item_code;
        v_row.txt05     :=  x.i_description;
        v_row.txt06     :=  v_str_dpr;
        v_row.numb01    :=  v_row_det.nom_qty;
        v_row.numb02    :=  x.ref_group;

        pipe ROW (v_row);
    END LOOP;
    RETURN;
END;


/*********************************************************************************************
    14/03/2008  d   Create date

/*********************************************************************************************/
FUNCTION f_sql_frm_dpr_dpr          (   p_org_code      VARCHAR2,
                                        p_group_code    VARCHAR2,
                                        p_order_code    VARCHAR2,
                                        p_oper_code     VARCHAR2
                                    )   RETURN          typ_frm     pipelined
IS

    CURSOR C_LINES          (           p_org_code      VARCHAR2,
                                        p_group_code    VARCHAR2,
                                        p_order_code    VARCHAR2,
                                        p_oper_code     VARCHAR2,
                                        p_prev_oper     VARCHAR2)
                            IS
                            SELECT      d.size_code         ,
                                        d.qta               nom_qty,
                                        v.dpr_qty           dpr_qty,
                                        x.dpr_qty           dpr_qty_prev
                            ------------------------------------------------------------------------
                            FROM        WORK_ORDER          o
                            INNER JOIN  WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                            LEFT JOIN   VW_PREP_GRP_DPR_QTY v   ON  v.org_code      =   p_org_code
                                                                AND v.order_code    =   p_order_code
                                                                AND v.oper_code     =   p_oper_code
                                                                AND v.size_code     =   d.size_code
                            LEFT JOIN   VW_PREP_GRP_DPR_QTY x   ON  x.org_code      =   p_org_code
                                                                AND x.order_code    =   p_order_code
                                                                AND x.oper_code     =   p_prev_oper
                                                                AND x.size_code     =   d.size_code
                            ------------------------------------------------------------------------
                            WHERE       o.order_code        =   p_order_code
                                AND     o.org_code          =   p_org_code
                            ORDER BY    d.size_code
                            ;

    v_row                   tmp_frm      := tmp_frm();
    v_row_grp               WORK_GROUP%ROWTYPE;
    v_found                 BOOLEAN;
    it_qty_prod             Pkg_Glb.typ_varchar_varchar;
    v_row_iop               Pkg_Prod.C_INFO_OPER%ROWTYPE;

BEGIN

    -- check INPUT parameters
    IF p_order_code IS NULL THEN Pkg_Lib.p_rae('Nu sunteti pozitionat pe o bola !');END IF;
    IF p_oper_code  IS NULL THEN Pkg_Lib.p_rae('Completati campul OPERATIE !');END IF;

    -- get the GROUP row
    v_row_grp.org_code      :=  p_org_code;
    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp) THEN NULL; END IF;

    -- get informations about the operation
    OPEN    C_INFO_OPER         (   p_ref_group     =>  v_row_grp.idriga,
                                    p_oper_code     =>  p_oper_code);
    FETCH   C_INFO_OPER   INTO  v_row_iop;  v_found :=  C_INFO_OPER%FOUND;
    CLOSE   C_INFO_OPER;
    IF NOT v_found THEN
        Pkg_Lib. p_rae('Operatia '||p_oper_code||' nu este in Routing-ul Comenzii!');
    END IF;


    -- prepaire the declared quantities in VW_PREP_GRP_DPR_QTY
    Pkg_Prod.p_prep_grp_dpr_qty     (   p_group_code    =>  p_group_code,
                                        p_oper_code     =>  '' --
                                    );

    FOR x IN C_LINES    (p_org_code, p_group_code, p_order_code, p_oper_code,v_row_iop.prev_oper)
    LOOP
        v_row.idriga        :=  C_LINES%rowcount;
        v_row.dcn           :=  0;
        v_row.seq_no        :=  C_LINES%rowcount;

        v_row.txt01         :=  p_org_code;
        v_row.txt02         :=  p_group_code;
        v_row.txt03         :=  p_order_code;
        v_row.txt04         :=  x.size_code;
        v_row.txt05         :=  v_row_iop.wc_description;
        v_row.txt06         :=  v_row_iop.wh_description;
        v_row.txt07         :=  v_row_iop.milestone;
        v_row.numb01        :=  x.nom_qty;
        v_row.numb02        :=  NVL(x.dpr_qty,      0);
        v_row.numb03        :=  0; -- declared quantity (reserved for user input)
        IF v_row_iop.prev_oper IS NULL THEN
            v_row.numb04    :=  '';
        ELSE
            v_row.numb04    :=  NVL(x.dpr_qty_prev,0);
        END IF;
        pipe ROW (v_row);
    END LOOP;

    RETURN;
END;

/*********************************************************************************************
    28/09/2008  d   Create date 
    24/06/2010 d added workcenter info 
/*********************************************************************************************/
FUNCTION f_sql_frm_dpr_hist (   p_org_code VARCHAR2, p_group_code VARCHAR2) RETURN typ_frm pipelined
-----------------------------------------------------------------------------------------------
--  PURPOSE:    list the all-time production declarations for a work_group
-----------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (p_org_code VARCHAR2, p_group_code VARCHAR2)
                    IS
                    SELECT      d.idriga, d.dcn,
                                h.date_legal,d.datagg,d.workst,d.iduser,
                                d.size_code,d.qty,d.whs_code, d.oper_code_item,
                                d.wc_code, w.description w_description
                    --
                    FROM        WHS_TRN_DETAIL  d
                    INNER JOIN  WHS_TRN         h   ON  h.idriga    =   d.ref_trn
                    LEFT JOIN   WORKCENTER      w   ON  w.workcenter_code   =   d.wc_code
                    --
                    WHERE       d.reason_code       LIKE    Pkg_Glb.C_P_IPRDSP
                        AND     d.group_code        =       p_group_code
                        AND     d.org_code          =       p_org_code
                    ORDER BY    1,2
                    ;

    v_row           tmp_frm     :=  tmp_frm();

BEGIN

    FOR x IN C_LINES    (p_org_code, p_group_code)
    LOOP
        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINES%ROWCOUNT;

        v_row.txt01     :=  p_org_code;
        v_row.txt02     :=  p_group_code;
        v_row.txt03     :=  x.workst;
        v_row.txt04     :=  x.iduser;
        v_row.txt05     :=  x.size_code;
        v_row.txt06     :=  x.whs_code;
        v_row.txt07     :=  x.oper_code_item;
        v_row.txt08     :=  x.w_description;
        v_row.numb01    :=  x.qty;
        v_row.data01    :=  x.date_legal;
        v_row.data02    :=  x.datagg;

        pipe ROW (v_row);
    END LOOP;

    RETURN;
END;

/*********************************************************************************************
    19/03/2008  d   Create date
/*********************************************************************************************/
PROCEDURE p_dpr_undo        (   p_row_trh       WHS_TRN%ROWTYPE,
                                p_commit        BOOLEAN
                            )
-----------------------------------------------------------------------------------------------
--  PURPOSE:    STORNO a Production declaration, verifying the quantities in aval
--  INPUT:      ROW_TRH     =>  transaction header
--              COMMIT      =>  if TRUE, commit the modification in database
-----------------------------------------------------------------------------------------------
IS

    CURSOR C_PROD           (           p_ref_trn           NUMBER,
                                        p_reason_code       VARCHAR2
                            )
                            IS
                            SELECT      group_code          ,
                                        org_code            ,
                                        order_code          ,
                                        oper_code_item      ,
                                        size_code           ,
                                        SUM(qty)            qty
                            -------------------------------------------------------------
                            FROM        WHS_TRN_DETAIL      td
                            -------------------------------------------------------------
                            WHERE       td.ref_trn          =   p_ref_trn
                                AND     td.reason_code      =   p_reason_code
                            --------------------------------------------
                            GROUP BY    group_code          ,
                                        org_code            ,
                                        order_code          ,
                                        oper_code_item      ,
                                        size_code
                            ORDER BY    1,2,3,4
                            ;


    v_row_iop               Pkg_Prod.C_INFO_OPER%ROWTYPE;
    v_curr_oper             VARCHAR2(30);
    v_row_grp               WORK_GROUP%ROWTYPE;
    it_dpr_qty              Pkg_Glb.typ_number_varchar;
    it_exp_qty              Pkg_Glb.typ_number_varchar;
    v_idx                   VARCHAR2(200);
    v_curr_qty              NUMBER;
    v_next_qty              NUMBER;
    v_err_context           VARCHAR2(200);
    v_reason_code           VARCHAR2(100);
BEGIN

    IF p_row_trh.trn_type = 'PROD' THEN
        v_reason_code       :=  Pkg_Glb.C_P_IPRDSP;
    ELSE
        v_reason_code       :=  Pkg_Glb.C_P_TFINPF;
    END IF;

/*
    FOR x IN C_PROD(p_row_trh.idriga, v_reason_code)
    LOOP

        -- if first line in the cursor, or the operation is different (for no redudancy)
        IF          Pkg_Lib.f_mod_c(v_curr_oper, x.oper_code_item)
--                AND Pkg_Lib.f_mod_c(v_curr_oper, x.oper_code_item)
        THEN
            v_curr_oper     :=  x.oper_code_item;
            -- get GROUP row
            v_row_grp.org_code      :=  p_row_trh.org_code;
            v_row_grp.group_code    :=  x.group_code;
            IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp) THEN NULL; END IF;
            -- get the routing operation info
            OPEN    Pkg_Prod.C_INFO_OPER    (v_row_grp.idriga, x.oper_code_item);
            FETCH   Pkg_Prod.C_INFO_OPER    INTO v_row_iop;
            CLOSE   Pkg_Prod.C_INFO_OPER;

            -- prepaire the declared quantities in IT_DPR_QTY
            it_dpr_qty.DELETE;
            Pkg_Prod. p_prep_grp_dpr_qty    (   p_group_code    =>  x.group_code,
                                                p_oper_code     =>  NULL,       -- ALL the operations !!!
                                                it_dpr_qty      =>  it_dpr_qty);

            -- prepaire the shipped quantities
            IF v_row_iop.next_oper IS NULL THEN
                Pkg_Prod.p_prep_ord_exp_qty (   p_org_code      =>  x.org_code,
                                                p_order_code    =>  x.order_code,
                                                it_exp_qty      =>  it_exp_qty);
            END IF;
        END IF;

        -- check if the next operation in the routing has less then the remaining quantity on storned operation ,
        --  after storno !!!
        v_curr_qty      :=  Pkg_Prod.f_get_dpr_qty  (   it_dpr_qty      =>  it_dpr_qty,
                                                            p_order_code    =>  x.order_code,
                                                            p_oper_code     =>  x.oper_code_item,
                                                            p_size_code     =>  x.size_code
                                                        );


        IF v_row_iop.next_oper IS NOT NULL THEN
            v_next_qty      :=  Pkg_Prod.f_get_dpr_qty  (   it_dpr_qty      =>  it_dpr_qty,
                                                            p_order_code    =>  x.order_code,
                                                            p_oper_code     =>  v_row_iop.next_oper,
                                                            p_size_code     =>  x.size_code
                                                        );
            v_err_context   :=  'La urmatoarele pozitii, pe faza urmatoare sunt declarate mai multe perechi decat '||
                                'ar ramane prin efectuarea stornarii pe faza curenta !';
            IF v_curr_qty - x.qty < v_next_qty THEN
                Pkg_App_Tools.p_log(    'M',
                                        'Bola: '||x.order_code||' Marime: '||x.size_code,
                                        v_err_context);
            END IF;

        ELSE
            v_next_qty      :=  Pkg_Prod.f_get_exp_qty  (   it_exp_qty      =>  it_exp_qty,
                                                            p_org_code      =>  x.org_code,
                                                            p_order_code    =>  x.order_code,
                                                            p_size_code     =>  x.size_code);

            v_err_context   :=  'La urmatoarele pozitii, au fost expediate mai multe perechi decat '||
                                'ar ramane prin efectuarea stornarii pe faza curenta !';
            IF v_curr_qty - x.qty < v_next_qty THEN
                Pkg_App_Tools.p_log(    'M',
                                        'Bola: '||x.order_code||' Marime: '||x.size_code,
                                        v_err_context);
            ELSE
                Pkg_App_Tools.p_log(    'X',
                                        'Bola: '||x.order_code||' Marime: '||x.size_code,
                                        v_err_context);

            END IF;
        END IF;

    END LOOP;

    Pkg_Lib.p_rae_m('B');
*/

    Pkg_Mov.p_whs_trn_storno(   p_ref_trn       =>  p_row_trh.idriga,
                                p_flag_commit   =>  FALSE);

    IF p_commit THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_commit THEN ROLLBACK; END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************
    19/03/2008  d   Create date
/*********************************************************************************************/
FUNCTION f_get_dpr_qty  (   it_dpr_qty      Pkg_Glb.typ_number_varchar,
                            p_order_code    VARCHAR2,
                            p_oper_code     VARCHAR2,
                            p_size_code     VARCHAR2
                        )   RETURN          NUMBER
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the value from IT_DPR_QTY that corresponds
--              to ORDER_CODE, OPER_CODE,SIZE
----------------------------------------------------------------------------------------------
IS
    v_result            NUMBER;
    v_idx               VARCHAR2(200);
BEGIN
    v_idx       :=  Pkg_Lib.f_implode       ('$', p_order_code, p_oper_code, p_size_code);
    v_result    :=  Pkg_Lib.f_table_value   (it_dpr_qty, v_idx, 0);
    RETURN      v_result;
END;

/*********************************************************************************************
    20/03/2008  d   Create date
/*********************************************************************************************/
FUNCTION f_get_exp_qty  (   it_exp_qty      Pkg_Glb.typ_number_varchar,
                            p_org_code      VARCHAR2,
                            p_order_code    VARCHAR2,
                            p_size_code     VARCHAR2
                        )   RETURN          NUMBER
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the value from IT_EXP_QTY that corresponds
--              to ORG_CODE, ORDER_CODE, SIZE
----------------------------------------------------------------------------------------------
IS
    v_result            NUMBER;
    v_idx               VARCHAR2(500);
BEGIN
    v_idx       :=  Pkg_Lib.f_implode       ('$', p_org_code, p_order_code, p_size_code);
    v_result    :=  Pkg_Lib.f_table_value   (it_exp_qty, v_idx, 0);
    RETURN      v_result;
END;





/*********************************************************************************************
    25/04/2008  d   Create date
/*********************************************************************************************/
FUNCTION f_format_half_size     (   p_size_code     VARCHAR2,
                                    p_org_code      VARCHAR2
                                )
                                    RETURN          VARCHAR2
----------------------------------------------------------------------------------------------
--  PURPOSE:    format the size, replacing M with 1/2 character
----------------------------------------------------------------------------------------------
IS
    v_rez   VARCHAR2(20);
BEGIN
    v_rez       :=  REPLACE(p_size_code, 'M', Pkg_Glb.C_HALF_SIZE);
    RETURN v_rez;
END;


/**********************************************************************************************
    DDL:    20/04/2008  d   Create date
/*********************************************************************************************/
PROCEDURE p_rep_ac_wip      (   p_year_month  VARCHAR2, p_org_code  VARCHAR2)
---------------------------------------------------------------------------------------------
--  PURPOSE:    generates data for the accounting work-in-progress report
---------------------------------------------------------------------------------------------
IS

    CURSOR C_STOC_PAST  IS
                        SELECT      r.seq_no            oper_seq,
                                    v.oper_code_item    ,
                                    v.whs_code          ,
                                    SUM(v.qty)          qty
                        -------------------------------------------------------------------------
                        FROM        VW_STOC_online      v
                        INNER JOIN  GROUP_ROUTING       r   ON  r.oper_code =   v.oper_code_item
                                                            AND r.group_code=   v.group_code
                        ------------------------------------------------------------------------
                        WHERE       v.oper_code_item      IS NOT NULL
                            AND     v.group_code          IS NOT NULL
                        GROUP BY    r.seq_no, v.oper_code_item, v.whs_code
                        ORDER BY    1
                        ;

    CURSOR C_DPR        (           p_org_code          VARCHAR2,
                                    p_date_ini          DATE,
                                    p_date_end          DATE
                        )
                        IS
                        SELECT      r.seq_no            oper_seq,
                                    d.oper_code_item    ,
                                    d.trn_sign          ,
                                    d.whs_code          ,
                                    SUM(qty)            qty
                        -----------------------------------------------------------------------
                        FROM        WHS_TRN_DETAIL      d
                        INNER JOIN  WHS_TRN             t   ON  t.idriga    =   d.ref_trn
                        INNER JOIN  GROUP_ROUTING       r   ON  r.oper_code =   d.oper_code_item
                                                            AND r.group_code=   d.group_code
                        -----------------------------------------------------------------------
                        WHERE       d.org_code          =       p_org_code
--                            AND     d.reason_code       IN      ('+IPRDSP','-OPRDSP')
                            AND     t.flag_storno       =       'N'
                            AND     t.date_legal        BETWEEN p_date_ini AND p_date_end
                        -----------------------------------------------------------------------
                        GROUP BY    r.seq_no, d.oper_code_item, d.trn_sign, d.whs_code
                        ORDER BY    1
                        ;

    TYPE typ_rep_s  IS TABLE OF VW_REP_AC_WIP%ROWTYPE             INDEX BY VARCHAR2(32000);
    it_rep          typ_rep_s;
    v_row           VW_REP_AC_WIP%ROWTYPE;
    v_idx           VARCHAR2(200);
    v_date_ini      DATE;
    v_date_end      DATE;

BEGIN

    DELETE VW_REP_AC_WIP;

    IF p_org_code IS NULL THEN Pkg_Err.p_err('Nu ati precizat clientul','Date lipsa'); END IF;
    IF p_year_month IS NULL THEN Pkg_Err.p_err('Nu ati precizat luna si anul','Date lipsa'); END IF;
    Pkg_Err.p_rae;

    v_date_ini      :=  TO_DATE(p_year_month,'YYYYMM') ;

    Pkg_Mov.P_Stoc_past     (   p_org_code  =>  p_org_code,
                                p_ref_date  =>  v_date_ini - 1  -- preceding date
                            );

    -- initial stock (first day of the month )
    FOR x IN C_STOC_PAST
    LOOP
        v_idx                       :=  Pkg_Lib.f_implode('$',x.oper_code_item,x.whs_code);
        it_rep(v_idx).line_seq      :=  x.oper_seq;
        it_rep(v_idx).segment_code  :=  'VW_REP_AC_WIP';
        it_rep(v_idx).oper_code     :=  x.oper_code_item;
        it_rep(v_idx).whs_code      :=  x.whs_code;
        it_rep(v_idx).stock_ini     :=  x.qty;

    END LOOP;

    v_date_end          :=  LAST_DAY(TO_DATE(p_year_month,'YYYYMM'));
    Pkg_Mov.P_Stoc_past (   p_org_code  =>  p_org_code,
                            p_ref_date  =>  v_date_end
                        );

    -- get the stock for the last day of the month (final stock)
    FOR x IN C_STOC_PAST
    LOOP
        v_idx                       :=  Pkg_Lib.f_implode('$',x.oper_code_item,x.whs_code);
        it_rep(v_idx).line_seq      :=  x.oper_seq;
        it_rep(v_idx).segment_code  :=  'VW_REP_AC_WIP';
        it_rep(v_idx).oper_code     :=  x.oper_code_item;
        it_rep(v_idx).whs_code      :=  x.whs_code;
        it_rep(v_idx).stock_fin     :=  x.qty;
    END LOOP;

    -- in-out quantities
    FOR x IN C_DPR(p_org_code, v_date_ini, v_date_end)
    LOOP
        v_idx                       :=  Pkg_Lib.f_implode('$',x.oper_code_item,x.whs_code);
        it_rep(v_idx).line_seq      :=  x.oper_seq;
        it_rep(v_idx).segment_code  :=  'VW_REP_AC_WIP';
        it_rep(v_idx).oper_code     :=  x.oper_code_item;
        it_rep(v_idx).whs_code      :=  x.whs_code;
        IF x.trn_sign < 0 THEN
            -- OUT transaction
            it_rep(v_idx).qty_out   :=  x.qty;
        ELSE
            it_rep(v_idx).qty_in    :=  x.qty;
        END IF;
    END LOOP;

    v_idx   :=  it_rep.FIRST;
    WHILE v_idx IS NOT NULL
    LOOP
        INSERT INTO VW_REP_AC_WIP VALUES it_rep(v_idx);
        v_idx       :=  it_rep.NEXT(v_idx);
    END LOOP;


END;


/**********************************************************************************************
    DDL:    27/04/2008  d   Create date
/*********************************************************************************************/
PROCEDURE p_rep_ac_wip_io   (   p_org_code  VARCHAR2,
                                p_date_ini  DATE,
                                p_date_end  DATE,
                                p_oper_code VARCHAR2,
                                p_whs_code  VARCHAR2)
-----------------------------------------------------------------------------------------------
--  PURPOSE:    prepaires in VW_REP_AC_WIP_IO the production declarations for a period
--
-----------------------------------------------------------------------------------------------
IS

CURSOR C_LINES  (       p_org_code          VARCHAR2,
                        p_date_ini          DATE,
                        p_date_end          DATE,
                        p_oper_code         VARCHAR2,
                        p_whs_code          VARCHAR2)
            IS
            SELECT      r.seq_no            ,
                        d.oper_code_item    ,
                        t.date_legal        ,
                        d.org_code          ,
                        d.order_code        ,
                        d.reason_code       ,
                        MAX(d.item_code)    item_code,
                        MAX(i.description)  i_description,
                        d.whs_code          ,
                        MAX(x.description)  reason_descr,
                        SUM(CASE d.trn_sign
                                WHEN        1   THEN    d.qty
                                ELSE                    0
                            END)            qty_in,
                        SUM(CASE d.trn_sign
                                WHEN        -1 THEN     d.qty
                                ELSE                    0
                            END)            qty_out
            ----------------------------------------------------------------------
            FROM        WHS_TRN_DETAIL      d
            INNER JOIN  WHS_TRN             t   ON  t.idriga        =   d.ref_trn
            INNER JOIN  ITEM                i   ON  i.org_code      =   d.org_code
                                                AND i.item_code     =   d.item_code
            INNER JOIN  GROUP_ROUTING       r   ON  r.oper_code     =   d.oper_code_item
                                                AND r.group_code    =   d.group_code
            INNER JOIN  WHS_TRN_REASON      x   ON  x.reason_code   =   d.reason_code
            ----------------------------------------------------------------------
            WHERE       d.org_code          =       p_org_code
                AND     t.flag_storno       =       'N'
                AND     t.date_legal        BETWEEN p_date_ini
                                                AND p_date_end
--                AND     d.reason_code       IN      ('+IPRDSP','-OPRDSP')
                AND     d.oper_code_item    IN      (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_oper_code,',')))
                AND     d.whs_code          LIKE    NVL(p_whs_code,'%')
            ----------------------------------------------------------------------
            GROUP BY    r.seq_no,t.date_legal,
                        d.org_code, d.order_code, d.oper_code_item,d.reason_code, d.whs_code
            ORDER BY    r.seq_no, t.date_legal
            ;

    v_row   VW_REP_AC_WIP_IO%ROWTYPE;

BEGIN
    DELETE FROM VW_REP_AC_WIP_IO;

    v_row.rep_title             :=  'Raport Intrari-Iesiri Productia neterminata';
    v_row.rep_info              :=  'Gestiune:  '|| p_org_code||Pkg_Glb.C_NL||
                                    'Perioada:  '|| TO_CHAR(p_date_ini,'dd/mm/yyyy')||
                                    ' -> '       || TO_CHAR(p_date_end,'dd/mm/yyyy')
                                    ;

    FOR x IN C_LINES(p_org_code, p_date_ini, p_date_end, p_oper_code, p_whs_code)
    LOOP

        v_row.segment_code      :=  'VW_REP_AC_WIP_IO';
        v_row.date_legal        :=  x.date_legal;
        v_row.oper_code         :=  x.oper_code_item;
        v_row.org_code          :=  x.org_code;
        v_row.order_code        :=  x.order_code;
        v_row.item_code         :=  x.item_code;
        v_row.item_descr        :=  x.i_description;
        v_row.whs_code          :=  x.whs_code;
        v_row.qty_in            :=  x.qty_in;
        v_row.qty_out           :=  x.qty_out;
        v_row.oper_seq          :=  x.seq_no;
        v_row.reason_descr      :=  x.reason_descr;
        v_row.line_seq          :=  C_LINES%rowcount;

        INSERT INTO VW_REP_AC_WIP_IO VALUES v_row;
    END LOOP;

END;


/*********************************************************************************************
    20/03/2008  d   Create date
/*********************************************************************************************/
PROCEDURE   p_rep_daily_prod    (   p_org_code      VARCHAR2,
                                    p_dpr_date      DATE,
                                    p_season_code   VARCHAR2,
                                    p_status        VARCHAR2,
                                    p_root_code     VARCHAR2)
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the value from IT_EXP_QTY that corresponds
--              to ORG_CODE, ORDER_CODE, SIZE
----------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (   p_org_code VARCHAR2, p_dpr_date DATE, p_season_code VARCHAR2)
                    IS
                    SELECT      h.date_legal                        ,
                                d.season_code                       ,
                                d.org_code                          ,
                                d.order_code                        ,
                                o.oper_seq                          ,
                                d.oper_code_item                    ,
                                SUM(d.qty)                          dpr_qty,
                                MAX(d.puom)                         puom,
                                MAX(z.org_name)                     org_description
                    -------------------------------------------------------------------------------
                    FROM        WHS_TRN             h
                    INNER JOIN  WHS_TRN_DETAIL      d   ON  d.ref_trn       =   h.idriga
                    INNER JOIN  OPERATION           o   ON  o.oper_code     =   d.oper_code_item
                    INNER JOIN  WORK_ORDER          w   ON  w.org_code      =   d.org_code
                                                        AND w.order_code    =   d.order_code
                    INNER JOIN  GROUP_ROUTING       r   ON  r.group_code    =   d.group_code
                                                        AND r.oper_code     =   d.oper_code_item
                    LEFT JOIN   WORKCENTER          k   ON  k.workcenter_code   =   r.workcenter_code
                    LEFT JOIN   COSTCENTER          c   ON  c.costcenter_code   =   k.costcenter_code
                    LEFT JOIN   ORGANIZATION        z   ON  z.org_code          =   c.org_code
                    -------------------------------------------------------------------------------
                    WHERE       d.reason_code       =   Pkg_Glb.C_P_IPRDSP
                        AND     d.org_code          =   p_org_code
                        AND     h.flag_storno       =   'N'
                        AND     d.season_code       LIKE NVL(p_season_code, '%')
                        AND     h.date_legal        <=   p_dpr_date
                    ---------------------------------------------------------------------------
                    GROUP BY    h.date_legal,
                                d.season_code,
                                d.org_code,
                                d.order_code,
                                o.oper_seq,
                                d.oper_code_item
                    ORDER BY    1,2,3
                    ;

    CURSOR C_EXPED  (   p_org_code VARCHAR2, p_dpr_date DATE)
                    IS
                    SELECT      h.date_legal        ,
                                d.season_code       ,
                                d.org_code          ,
                                d.order_code        ,
                                SUM(d.qty)          exp_qty
                    -------------------------------------------------------------------------------
                    FROM        WHS_TRN             h
                    INNER JOIN  WHS_TRN_DETAIL      d   ON  d.ref_trn       =   h.idriga
                    -------------------------------------------------------------------------------
                    WHERE       d.reason_code       =   Pkg_Glb.C_M_OSHPPF
                        AND     h.flag_storno       =   'N'
                        AND     h.date_legal        <=   p_dpr_date
                    ---------------------------------------------------------------------------
                    GROUP BY    h.date_legal,
                                d.season_code,
                                d.org_code,
                                d.order_code
                    ORDER BY    1,2,3
                    ;

    CURSOR C_WO     (p_org_code VARCHAR2, p_status  VARCHAR2, p_season_code VARCHAR2)
                    IS
                    SELECT      MAX(o.org_code)         org_code,
                                MAX(o.season_code)      season_code,
                                MAX(o.order_code)       order_code,
                                MAX(o.item_code)        item_code,
                                MAX(i.description)      i_description,
                                MAX(i.root_code)        i_root_code,
                                MAX(i.puom)             i_puom,
                                MAX(o.routing_code)     routing_code,
                                MAX(o.status)           order_status,
                                MAX(m.description)      m_description,
                                SUM(d.qta)              nom_qty
                    ----------------------------------------------------------------------------
                    FROM        WORK_ORDER          o
                    INNER JOIN  ITEM                i   ON  i.org_code      =   o.org_code
                                                        AND i.item_code     =   o.item_code
                    LEFT JOIN   WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                    LEFT JOIN   MACROROUTING_HEADER m   ON  m.routing_code  =   o.routing_code
                    ----------------------------------------------------------------------------
                    WHERE       o.org_code          =       p_org_code
                        AND     o.status            LIKE    NVL(p_status,       '%')
                        AND     o.season_code       LIKE    NVL(p_season_code,  '%')
                        AND     i.root_code         LIKE    NVL(p_root_code,    '%')
                    GROUP BY    o.idriga
                    ;

    TYPE typ_rep_s  IS TABLE OF VW_REP_DAILY_PROD%ROWTYPE             INDEX BY VARCHAR2(32000);
    it_rep          typ_rep_s;
    v_idx           VARCHAR2(200);
    v_row           VW_REP_DAILY_PROD%ROWTYPE;
    v_row_ini       VW_REP_DAILY_PROD%ROWTYPE;
    it_fase         Pkg_Glb.typ_string;
    v_dpr_date      DATE;

BEGIN

    v_dpr_date      :=  NVL(p_dpr_date, TRUNC(SYSDATE));

    it_fase (1)     :=  'CROIT';
    it_fase (2)     :=  'CUSUT';
    it_fase (3)     :=  'TRAS';

    DELETE FROM VW_REP_DAILY_PROD;

    v_row_ini.rep_title     :=  'Productia zilnica';
    v_row_ini.rep_info      :=  'Gestiune:  '||p_org_code||Pkg_Glb.C_NL ||
                                'Data DPR:  '||TO_CHAR(v_dpr_date,  'dd/mm/yyyy')   ||Pkg_Glb.C_NL||
                                'Stagiune:  '||NVL(p_season_code,   'TOATE')        ||Pkg_Glb.C_NL||
                                'Familie:   '||NVL(p_root_code,     'TOATE')        ||Pkg_Glb.C_NL||
                                'Stare:     '||NVL(p_status,        'TOATE');
    v_row_ini.oper_code_1   :=  it_fase(1);
    v_row_ini.oper_code_2   :=  it_fase(2);
    v_row_ini.oper_code_3   :=  it_fase(3);
    v_row_ini.segment_code  :=  'VW_REP_DAILY_PROD';
    v_row_ini.qty_1         :=  0;
    v_row_ini.qty_2         :=  0;
    v_row_ini.qty_3         :=  0;
    v_row_ini.qty_hist_1    :=  0;
    v_row_ini.qty_hist_2    :=  0;
    v_row_ini.qty_hist_3    :=  0;

    -- load the existing work orders for the CLIENT + STATUS
    FOR x IN    C_WO(p_org_code, p_status, p_season_code)
    LOOP
        v_idx                       :=  Pkg_Lib.f_implode('$',x.org_code,x.order_code);
        it_rep(v_idx)               :=  v_row_ini;
        it_rep(v_idx).org_code      :=  x.org_code;
        it_rep(v_idx).order_code    :=  x.order_code;
        it_rep(v_idx).season_code   :=  x.season_code;
        it_rep(v_idx).item_code     :=  x.item_code;
        it_rep(v_idx).item_descr    :=  x.i_description;
        it_rep(v_idx).family_code   :=  x.i_root_code;
        it_rep(v_idx).routing_info  :=  x.m_description;
        it_rep(v_idx).order_status  :=  x.order_status;
        it_rep(v_idx).nom_qty       :=  x.nom_qty;
        it_rep(v_idx).um            :=  x.i_puom;
    END LOOP;

    FOR x IN C_LINES(p_org_code, v_dpr_date, p_season_code)
    LOOP
        v_idx   := Pkg_Lib.f_implode('$',x.org_code,x.order_code);

        -- if the Order wasn't found in the list yet, insert it in the PL/SQL table
        IF it_rep.EXISTS(v_idx) THEN
            v_row                   :=  it_rep(v_idx);
            -- quantity for DPR_DATE
            IF x.date_legal = NVL(v_dpr_date, x.date_legal) THEN
                CASE    x.oper_code_item
                    WHEN    it_fase(1)  THEN
                            v_row.qty_1         :=  v_row.qty_1 + x.dpr_qty;
                            v_row.workcenter_1  :=  x.org_description;
                    WHEN    it_fase(2)  THEN
                            v_row.qty_2 :=  v_row.qty_2 + x.dpr_qty;
                            v_row.workcenter_2  :=  x.org_description;
                    WHEN    it_fase(3)  THEN
                            v_row.qty_3 :=  v_row.qty_3 + x.dpr_qty;
                            v_row.workcenter_3  :=  x.org_description;
                    ELSE
                            NULL;
                END CASE;
            -- historical DPRs
            ELSE
                CASE    x.oper_code_item
                    WHEN    it_fase(1)  THEN
                            v_row.qty_hist_1    :=  v_row.qty_hist_1 + x.dpr_qty;
                            v_row.oper_hist_1   :=  LTRIM(
                                                    v_row.oper_hist_1 || Pkg_Glb.C_NL ||
                                                    RPAD(TO_CHAR(x.date_legal,'dd/mm/yyyy'),12)||
                                                    LPAD(x.dpr_qty,5),
                                                    Pkg_Glb.C_NL);
                            v_row.workcenter_1  :=  x.org_description;
                    WHEN    it_fase(2)  THEN
                            v_row.qty_hist_2    :=  v_row.qty_hist_2 + x.dpr_qty;
                            v_row.oper_hist_2   :=  LTRIM(
                                                    v_row.oper_hist_2 || Pkg_Glb.C_NL ||
                                                    RPAD(TO_CHAR(x.date_legal,'dd/mm/yyyy'),12)||
                                                    LPAD(x.dpr_qty,4),
                                                    Pkg_Glb.C_NL);
                            v_row.workcenter_2  :=  x.org_description;
                    WHEN    it_fase(3)  THEN
                            v_row.qty_hist_3    :=  v_row.qty_hist_3 + x.dpr_qty;
                            v_row.oper_hist_3   :=  LTRIM(
                                                            v_row.oper_hist_3 || Pkg_Glb.C_NL ||
                                                            RPAD(TO_CHAR(x.date_legal,'dd/mm/yyyy'),12)||
                                                            LPAD(x.dpr_qty,5),
                                                    Pkg_Glb.C_NL);
                            v_row.workcenter_3  :=  x.org_description;
                    ELSE
                            NULL;
                END CASE;
            END IF;

            it_rep(v_idx)   :=  v_row;

        END IF;
    END LOOP;

    -- Expedited quantities
    FOR x IN C_EXPED (p_org_code, v_dpr_date)
    LOOP
        v_idx   := Pkg_Lib.f_implode('$',x.org_code,x.order_code);
        IF it_rep.EXISTS(v_idx) THEN
            it_rep(v_idx).exp_qty   :=  NVL(it_rep(v_idx).exp_qty,0) + x.exp_qty;
            it_rep(v_idx).exp_hist  :=  LTRIM(
                                                it_rep(v_idx).exp_hist || Pkg_Glb.C_NL ||
                                                RPAD(TO_CHAR(x.date_legal,'dd/mm/yy'),10)||
                                                LPAD(x.exp_qty,4),
                                                Pkg_Glb.C_NL);
        END IF;
    END LOOP;

    -- insert the data from PL?SQL table in VW_REP_DAILY_PROD view
    v_idx   :=  it_rep.FIRST;
    IF v_idx IS NOT NULL THEN
        WHILE v_idx IS NOT NULL
        LOOP
            INSERT INTO VW_REP_DAILY_PROD VALUES it_rep(v_idx);
            v_idx       :=  it_rep.NEXT(v_idx);
        END LOOP;
    ELSE
        Pkg_Lib.p_rae('Nu exista date pentru parametrii precizati !');
    END IF;

END;


/*********************************************************************************************
    05/06/2008  d   Create date
    22/05/2009  d   add routing location to output 
/*********************************************************************************************/
PROCEDURE p_rep_prod_period (   p_org_code      VARCHAR2,
                                p_start_date    DATE,
                                p_end_date      DATE,
                                p_oper_code     VARCHAR2,
                                p_per_type      VARCHAR2)
IS

    CURSOR C_LINES  (           p_org_code      VARCHAR2,
                                p_start_date    DATE,
                                p_end_date      DATE,
                                p_oper_code     VARCHAR2,
                                p_flag_exp      VARCHAR2
                    )   IS
                    SELECT      *
                    FROM
                    (
                    SELECT      t.date_legal,
                                d.org_code,
                                d.order_code,
                                d.oper_code_item    ,
                                r.seq_no,
                                max(c.org_code)     oper_loc,
                                MAX(o.routing_code) routing_code,
                                MAX(d.item_code)    item_code,
                                MAX(i.description)  item_description,
                                MAX(i.puom)         um,
                                SUM(d.qty)          qty
                    ------------------------------------------------------------------------
                    FROM        WHS_TRN         t
                    INNER JOIN  WHS_TRN_DETAIL  d   ON  d.ref_trn       =   t.idriga
                    INNER JOIN  WORK_ORDER      o   ON  o.org_code      =   d.org_code
                                                    AND o.order_code    =   d.order_code
                    INNER JOIN  ITEM            i   ON  i.org_code      =   o.org_code
                                                    AND i.item_code     =   o.item_code
                    INNER JOIN  GROUP_ROUTING   r   ON  r.group_code    =   d.group_code
                                                    AND r.oper_code     =   d.oper_code_item
                    LEFT JOIN   WORKCENTER      w   ON  w.workcenter_code   =   r.workcenter_code
                    LEFT JOIN   COSTCENTER      c   ON  c.costcenter_code   =   w.costcenter_code                                                    
                    -----------------------------------------------------------------------
                    WHERE       d.reason_code       =       Pkg_Glb.C_P_IPRDSP
                        AND     d.org_code          =       p_org_code
                        AND     t.date_legal        BETWEEN p_start_date AND p_end_date
                        AND     d.oper_code_item    LIKE    NVL(p_oper_code,'%')
                        AND     r.milestone         =       'Y'
                        AND     t.flag_storno       =       'N'
                    GROUP BY    t.date_legal,
                                d.org_code,
                                d.order_code,
                                d.oper_code_item,
                                r.seq_no
                    -----
                    UNION ALL
                    -----
                    SELECT      t.date_legal,
                                d.org_code,
                                d.order_code,
                                'EXPEDIAT'          oper_code_item,
                                '9999'              seq_no,
                                ''                  oper_loc,
                                MAX(o.routing_code) routing_code,
                                MAX(d.item_code)    item_code,
                                MAX(i.description)  item_description,
                                MAX(i.puom)         um,
                                SUM(d.qty)          qty
                    ------------------------------------------------------------------------
                    FROM        WHS_TRN         t
                    INNER JOIN  WHS_TRN_DETAIL  d   ON  d.ref_trn       =   t.idriga
                    INNER JOIN  WORK_ORDER      o   ON  o.org_code      =   d.org_code
                                                    AND o.order_code    =   d.order_code
                    INNER JOIN  ITEM            i   ON  i.org_code      =   o.org_code
                                                    AND i.item_code     =   o.item_code
                    -----------------------------------------------------------------------
                    WHERE       d.reason_code       =       Pkg_Glb.C_M_OSHPPF
                        AND     d.org_code          =       p_org_code
                        AND     t.date_legal        BETWEEN p_start_date AND p_end_date
                        AND     t.flag_storno       =       'N'
                        AND     p_flag_exp          =       'Y'
                    GROUP BY    t.date_legal,
                                d.org_code,
                                d.order_code,
                                d.oper_code_item
                    )
                    ORDER BY    order_code, seq_no
                    ;

    C_SEGMENT       VARCHAR2(20)    :=  'VW_REP_PROD_PERIOD';
    TYPE typ_rep_s  IS TABLE OF VW_REP_PROD_PERIOD%ROWTYPE             INDEX BY VARCHAR2(32000);
    it_rep          typ_rep_s;
    v_idx           VARCHAR2(200);
    v_idx_t         VARCHAR2(200);
    v_row           VW_REP_PROD_PERIOD%ROWTYPE;
    v_row_ini       VW_REP_PROD_PERIOD%ROWTYPE;
    v_per_id        PLS_INTEGER;
    v_flag_exp      VARCHAR2(1);

BEGIN
    DELETE FROM vw_rep_prod_period;

    v_row_ini.segment_code      :=  C_SEGMENT;
    v_row_ini.rep_title         :=  'Raport productia intr-o perioada';
    v_row_ini.rep_info          :=  'Gestiune:  '||p_org_code                           ||Pkg_Glb.C_NL||
                                    'Data START:'||TO_CHAR(p_start_date,'dd/mm/yyyy')   ||Pkg_Glb.C_NL||
                                    'Data END:  '||TO_CHAR(p_end_date,'dd/mm/yyyy')     ||Pkg_Glb.C_NL||
                                    'Operatia:  '||NVL(p_oper_code,'TOATE')             ||Pkg_Glb.C_NL||
                                    'Tip Per:   '|| (   CASE p_per_type
                                                            WHEN 'Z' THEN   'Zilnic'
                                                            WHEN 'S' THEN   'Saptamanal '||
                                                                            TO_CHAR(p_start_date,'IW')||
                                                                            ' - ' ||
                                                                            TO_CHAR(p_end_date,'IW')
                                                        END
                                                    )
                                                    ||Pkg_Glb.C_NL
                                    ;
    v_row_ini.start_date        :=  p_start_date;
    v_row_ini.end_date          :=  p_end_date;
    IF p_per_type = 'S' THEN
        v_row_ini.week_start        :=  TO_CHAR(p_start_date, 'IW');
    END IF;

    IF p_oper_code = 'EXPEDIAT' THEN v_flag_exp := 'Y'; ELSE v_flag_exp := 'N'; END IF;

    FOR x IN C_LINES (p_org_code, p_start_date, p_end_date,p_oper_code, v_flag_exp)
    LOOP
        v_idx       :=  Pkg_Lib.f_implode('$',x.org_code, x.order_code, x.oper_code_item);
        v_idx_t     :=  Pkg_Lib.f_implode('$',x.org_code, 'Total '||x.oper_code_item, x.oper_code_item);
        IF it_rep.EXISTS(v_idx) THEN
            v_row           :=  it_rep(v_idx);
        ELSE
            v_row                   :=  v_row_ini;
            v_row.seq_no            :=  C_LINES%ROWcount;
            v_row.org_code          :=  x.org_code;
            v_row.order_code        :=  x.order_code;
            v_row.item_code         :=  x.item_code;
            v_row.item_description  :=  x.item_description;
            v_row.routing_code      :=  x.routing_code;
            v_row.oper_code         :=  x.oper_code_item||' '||x.oper_loc;
        END IF;

        IF NOT it_rep.EXISTS(v_idx_t) THEN
            it_rep(v_idx_t)             :=  v_row_ini;
            it_rep(v_idx_t).org_code    :=  x.org_code;
            it_rep(v_idx_t).order_code  :=  'TOTAL ';
            it_rep(v_idx_t).item_code   :=  ' ';
            it_rep(v_idx_t).oper_code   :=  x.oper_code_item;
            it_rep(v_idx_t).seq_no      :=  10000 + x.seq_no;
        END IF;

        IF NVL(p_per_type,'Z') = 'Z' THEN
            v_per_id    :=  x.date_legal - p_start_date + 1;
        ELSE
            v_per_id    :=  TO_CHAR(x.date_legal,'IW') - TO_CHAR(p_start_date,'IW') + 1;
        END IF;

        CASE v_per_id
            WHEN    1   THEN    v_row.qty_1 :=  NVL(v_row.qty_1,0) + x.qty;
                                it_rep(v_idx_t).qty_1 := NVL(it_rep(v_idx_t).qty_1,0) + x.qty;
            WHEN    2   THEN    v_row.qty_2 :=  NVL(v_row.qty_2,0) + x.qty;
                                it_rep(v_idx_t).qty_2 := NVL(it_rep(v_idx_t).qty_2,0) + x.qty;
            WHEN    3   THEN    v_row.qty_3 :=  NVL(v_row.qty_3,0) + x.qty;
                                it_rep(v_idx_t).qty_3 := NVL(it_rep(v_idx_t).qty_3,0) + x.qty;
            WHEN    4   THEN    v_row.qty_4 :=  NVL(v_row.qty_4,0) + x.qty;
                                it_rep(v_idx_t).qty_4 := NVL(it_rep(v_idx_t).qty_4,0) + x.qty;
            WHEN    5   THEN    v_row.qty_5 :=  NVL(v_row.qty_5,0) + x.qty;
                                it_rep(v_idx_t).qty_5 := NVL(it_rep(v_idx_t).qty_5,0) + x.qty;
            WHEN    6   THEN    v_row.qty_6 :=  NVL(v_row.qty_6,0) + x.qty;
                                it_rep(v_idx_t).qty_6 := NVL(it_rep(v_idx_t).qty_6,0) + x.qty;
            WHEN    7   THEN    v_row.qty_7 :=  NVL(v_row.qty_7,0) + x.qty;
                                it_rep(v_idx_t).qty_7 := NVL(it_rep(v_idx_t).qty_7,0) + x.qty;
            WHEN    8   THEN    v_row.qty_8 :=  NVL(v_row.qty_8,0) + x.qty;
                                it_rep(v_idx_t).qty_8 := NVL(it_rep(v_idx_t).qty_8,0) + x.qty;
            WHEN    9   THEN    v_row.qty_9 :=  NVL(v_row.qty_9,0) + x.qty;
                                it_rep(v_idx_t).qty_9 := NVL(it_rep(v_idx_t).qty_9,0) + x.qty;
            WHEN    10  THEN    v_row.qty_10 := NVL(v_row.qty_10,0) + x.qty;
                                it_rep(v_idx_t).qty_10 := NVL(it_rep(v_idx_t).qty_10,0) + x.qty;
            WHEN    11  THEN    v_row.qty_11 := NVL(v_row.qty_11,0) + x.qty;
                                it_rep(v_idx_t).qty_11 := NVL(it_rep(v_idx_t).qty_11,0) + x.qty;
            WHEN    12  THEN    v_row.qty_12 := NVL(v_row.qty_12,0) + x.qty;
                                it_rep(v_idx_t).qty_12 := NVL(it_rep(v_idx_t).qty_12,0) + x.qty;
            WHEN    13  THEN    v_row.qty_13 := NVL(v_row.qty_13,0) + x.qty;
                                it_rep(v_idx_t).qty_13 := NVL(it_rep(v_idx_t).qty_13,0) + x.qty;
            WHEN    14  THEN    v_row.qty_14 := NVL(v_row.qty_14,0) + x.qty;
                                it_rep(v_idx_t).qty_14 := NVL(it_rep(v_idx_t).qty_14,0) + x.qty;
            WHEN    15  THEN    v_row.qty_15 := NVL(v_row.qty_15,0) + x.qty;
                                it_rep(v_idx_t).qty_15 := NVL(it_rep(v_idx_t).qty_15,0) + x.qty;
            WHEN    16  THEN    v_row.qty_16 := NVL(v_row.qty_16,0) + x.qty;
                                it_rep(v_idx_t).qty_16 := NVL(it_rep(v_idx_t).qty_16,0) + x.qty;
            WHEN    17  THEN    v_row.qty_17 := NVL(v_row.qty_17,0) + x.qty;
                                it_rep(v_idx_t).qty_17 := NVL(it_rep(v_idx_t).qty_17,0) + x.qty;
            WHEN    18  THEN    v_row.qty_18 := NVL(v_row.qty_18,0) + x.qty;
                                it_rep(v_idx_t).qty_18 := NVL(it_rep(v_idx_t).qty_18,0) + x.qty;
            WHEN    19  THEN    v_row.qty_19 := NVL(v_row.qty_19,0) + x.qty;
                                it_rep(v_idx_t).qty_19 := NVL(it_rep(v_idx_t).qty_19,0) + x.qty;
            WHEN    20  THEN    v_row.qty_20 := NVL(v_row.qty_20,0) + x.qty;
                                it_rep(v_idx_t).qty_20 := NVL(it_rep(v_idx_t).qty_20,0) + x.qty;
            WHEN    21  THEN    v_row.qty_21 := NVL(v_row.qty_21,0) + x.qty;
                                it_rep(v_idx_t).qty_21 := NVL(it_rep(v_idx_t).qty_21,0) + x.qty;
            WHEN    22  THEN    v_row.qty_22 := NVL(v_row.qty_22,0) + x.qty;
                                it_rep(v_idx_t).qty_22 := NVL(it_rep(v_idx_t).qty_22,0) + x.qty;
            WHEN    23  THEN    v_row.qty_23 := NVL(v_row.qty_23,0) + x.qty;
                                it_rep(v_idx_t).qty_23 := NVL(it_rep(v_idx_t).qty_23,0) + x.qty;
            WHEN    24  THEN    v_row.qty_24 := NVL(v_row.qty_24,0) + x.qty;
                                it_rep(v_idx_t).qty_24 := NVL(it_rep(v_idx_t).qty_24,0) + x.qty;
            WHEN    25  THEN    v_row.qty_25 := NVL(v_row.qty_25,0) + x.qty;
                                it_rep(v_idx_t).qty_25 := NVL(it_rep(v_idx_t).qty_25,0) + x.qty;
            WHEN    26  THEN    v_row.qty_26 := NVL(v_row.qty_26,0) + x.qty;
                                it_rep(v_idx_t).qty_26 := NVL(it_rep(v_idx_t).qty_26,0) + x.qty;
            WHEN    27  THEN    v_row.qty_27 := NVL(v_row.qty_27,0) + x.qty;
                                it_rep(v_idx_t).qty_27 := NVL(it_rep(v_idx_t).qty_27,0) + x.qty;
            WHEN    28  THEN    v_row.qty_28 := NVL(v_row.qty_28,0) + x.qty;
                                it_rep(v_idx_t).qty_28 := NVL(it_rep(v_idx_t).qty_28,0) + x.qty;
            WHEN    29  THEN    v_row.qty_29 := NVL(v_row.qty_29,0) + x.qty;
                                it_rep(v_idx_t).qty_29 := NVL(it_rep(v_idx_t).qty_29,0) + x.qty;
            WHEN    30  THEN    v_row.qty_30 := NVL(v_row.qty_30,0) + x.qty;
                                it_rep(v_idx_t).qty_30 := NVL(it_rep(v_idx_t).qty_30,0) + x.qty;
            ELSE
                                Pkg_Lib.p_rae(v_per_id);
        END CASE;
        it_rep(v_idx)   :=  v_row;

    END LOOP;

    -- insert the data from PL?SQL table in VW_REP_DAILY_PROD view
    v_idx   :=  it_rep.FIRST;
    IF v_idx IS NOT NULL THEN
        WHILE v_idx IS NOT NULL
        LOOP
            INSERT INTO VW_REP_PROD_PERIOD VALUES it_rep(v_idx);
            v_idx       :=  it_rep.NEXT(v_idx);
        END LOOP;
    ELSE
        Pkg_Lib.p_rae('Nu exista date pentru parametrii precizati !');
    END IF;

END;

/*********************************************************************************************
    09/07/2008  d   Create date
    08/12/2008  d   added season code partition 
/*********************************************************************************************/
PROCEDURE p_rep_wip (   p_org_code  VARCHAR2, p_year_month    VARCHAR2)
----------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------
IS

    CURSOR C_LAUNCHED   (p_org_code VARCHAR2, p_start_date   DATE, p_end_date DATE)
                        IS
                        SELECT      org_code, group_code,
                                    MAX(season_code)    season_code,
                                    MAX(org_code_loc)   org_code_loc,
                                    MAX(date_launch)    date_launch,
                                    MAX(first_oper)     first_oper,
                                    MAX(first_loc)      first_loc,
                                    MAX(nom_qty)        nom_qty,
                                    MAX(item_code)      item_code
                        FROM
                        (
                        SELECT      o.org_code,g.group_code, r.oper_code, wh.org_code org_code_loc,
                                    g.date_launch,
                                    o.season_code       season_code,
                                    o.item_code         item_code,
                                    (SELECT SUM(d.qta) FROM WO_DETAIL d WHERE d.ref_wo = o.idriga) nom_qty,
                                    FIRST_VALUE(r.oper_code) OVER (PARTITION BY r.group_code ORDER BY r.seq_no) first_oper,
                                    FIRST_VALUE(wh.org_code) OVER (PARTITION BY r.group_code ORDER BY r.seq_no) first_loc
                        FROM        WORK_GROUP      g
                        INNER JOIN  WO_GROUP        w   ON  w.group_code    =   g.group_code
                        INNER JOIN  GROUP_ROUTING   r   ON  r.group_code    =   g.group_code
                                                        AND r.oper_code     =   w.oper_code
                        INNER JOIN  WORK_ORDER      o   ON  o.org_code      =   w.org_code
                                                        AND o.order_code    =   w.order_code
                        INNER JOIN  WAREHOUSE       wh  ON  wh.whs_code     =   r.whs_cons
                        WHERE       g.status        IN  ('L','T')
                            AND     g.date_launch   <=  p_end_date
/*                            AND     (
                                        o.date_complet  >=  p_start_date
                                        OR
                                        o.date_complet IS NULL
                                    )   
*/                            AND     g.org_code      =   p_org_code
                        )
                        GROUP BY org_code, group_code
                        ;

    CURSOR C_DPR        (p_start_date DATE , p_end_date DATE)
                        IS
                        SELECT      *
                        FROM
                        (
                        SELECT      d.org_code, d.group_code, r.oper_code,
                                    d.qty, r.whs_cons, h.date_legal,
                                    NVL(h.flag_storno,'N')  flag_storno,
                                    w.org_code          org_code_loc,
                                    o.season_code       ,
                                    o.item_code         ,
                                    FIRST_VALUE(r.oper_code) OVER (PARTITION BY r.group_code ORDER BY r.seq_no) first_oper
                        FROM        WORK_GROUP      g
                        INNER JOIN  WO_GROUP        wg  ON  wg.group_code   =   g.group_code
                        INNER JOIN  GROUP_ROUTING   r   ON  r.group_code    =   g.group_code
                                                        AND r.oper_code     =   wg.oper_code  
                        INNER JOIN  WORK_ORDER      o   ON  o.org_code      =   wg.org_code
                                                        AND o.order_code    =   wg.order_code                                                        
                        INNER JOIN  WAREHOUSE       w   ON  w.whs_code      =   r.whs_cons
                        LEFT JOIN   WHS_TRN_DETAIL  d   ON  d.group_code    =   r.group_code
                                                        AND d.oper_code_item=   r.oper_code
                                                        AND d.reason_code   =   Pkg_Glb.C_P_IPRDSP
                        LEFT JOIN   WHS_TRN         h   ON  h.idriga        =   d.ref_trn
                        WHERE
                                    g.org_code      =   p_org_code
/*                                AND (
                                        o.date_complet  >=  p_start_date
                                        OR
                                        o.date_complet IS NULL
                                    )                                       
*/                        )
                        WHERE       flag_storno     =   'N'
                            AND     date_legal      <=  p_end_date
                        ;

    CURSOR C_FIN        (p_end_date DATE)
                        IS
                        SELECT      d.org_code, d.group_code, d.season_code, h.date_legal, 
                                    SUM(qty)            qty,
                                    MAX(d.item_code)    item_code
                        FROM        WHS_TRN_DETAIL  d
                        INNER JOIN  WHS_TRN         h   ON  h.idriga    =   d.ref_trn
                        WHERE       d.org_code      =   p_org_code
                            AND     d.reason_code   IN  (Pkg_Glb.C_P_TFINPF,Pkg_Glb.C_P_TFINSP)
                        GROUP BY d.org_code, d.group_code, d.season_code, h.date_legal
                        ;


    it_rep              Pkg_Rtype.tas_vw_rep_wip;
    v_idx               VARCHAR2(200);
    v_start_date        DATE;
    v_end_date          DATE;
    v_period            VARCHAR2(200);
    C_SEGMENT_CODE      VARCHAR2(30)    :=  'VW_REP_WIP';

BEGIN

    DELETE FROM VW_REP_WIP;

    v_start_date        :=  TO_DATE(p_year_month||'01','yyyymmdd');
    v_end_date          :=  LAST_DAY(v_start_date);

    FOR x IN C_LAUNCHED(p_org_code, v_start_date, v_end_date)
    LOOP
        IF x.date_launch BETWEEN v_start_date AND v_end_date THEN
            v_period    :=  p_year_month;
        ELSE
            v_period    :=  'OLD';
        END IF;
        v_idx   :=  Pkg_Lib.f_implode('$',x.org_code,x.group_code,v_period,'LANSARE');
        it_rep(v_idx).segment_code  :=  C_SEGMENT_CODE;
        it_rep(v_idx).org_code      :=  x.org_code;
        it_rep(v_idx).order_code    :=  x.group_code;
        it_rep(v_idx).season_code   :=  x.season_code;
        it_rep(v_idx).item_code     :=  x.item_code;
        it_rep(v_idx).period        :=  v_period;
        it_rep(v_idx).first_oper    :=  x.first_oper;
        it_rep(v_idx).org_code_loc  :=  x.first_loc;
        it_rep(v_idx).oper_code     :=  'LANSARE';
        it_rep(v_idx).qty           :=  x.nom_qty;

    END LOOP;


    FOR x IN C_DPR (v_start_date, v_end_date)
    LOOP
        IF x.date_legal BETWEEN v_start_date AND v_end_date THEN
            v_period    :=  p_year_month;
        ELSE
            v_period    :=  'OLD';
        END IF;

        v_idx   :=  Pkg_Lib.f_implode('$',x.org_code, x.group_code,v_period, x.oper_code);
        IF NOT it_rep.EXISTS(v_idx) THEN
            it_rep(v_idx).segment_code  :=  C_SEGMENT_CODE;
            it_rep(v_idx).org_code      :=  x.org_code;
            it_rep(v_idx).order_code    :=  x.group_code;
            it_rep(v_idx).season_code   :=  x.season_code;
            it_rep(v_idx).item_code     :=  x.item_code;
            it_rep(v_idx).period        :=  v_period;
            it_rep(v_idx).oper_code     :=  x.oper_code;
            it_rep(v_idx).first_oper    :=  x.first_oper;
            it_rep(v_idx).org_code_loc      :=  x.org_code_loc;
        END IF;
        it_rep(v_idx).qty :=  NVL(it_rep(v_idx).qty,0) + x.qty;
    END LOOP;

    FOR x IN C_FIN (v_end_date)
    LOOP
        IF x.date_legal BETWEEN v_start_date AND v_end_date THEN
            v_period    :=  p_year_month;
        ELSE
            v_period    :=  'OLD';
        END IF;

        v_idx   :=  Pkg_Lib.f_implode('$',x.org_code, x.group_code, v_period, '-');
        it_rep(v_idx).segment_code  :=  C_SEGMENT_CODE;
        it_rep(v_idx).org_code      :=  x.org_code;
        it_rep(v_idx).order_code    :=  x.group_code;
        it_rep(v_idx).season_code   :=  x.season_code;
        it_rep(v_idx).item_code     :=  x.item_code;
        it_rep(v_idx).period        :=  v_period;
        it_rep(v_idx).oper_code     :=  '-';
        it_rep(v_idx).first_oper    :=  NULL;
        it_rep(v_idx).org_code_loc  :=  NULL;

    END LOOP;

    v_idx   :=  it_rep.FIRST;
    WHILE v_idx IS NOT NULL
    LOOP
        INSERT INTO VW_REP_WIP VALUES it_rep(v_idx);
        v_idx   :=  it_rep.NEXT(v_idx);
    END LOOP;

END;

/*********************************************************************************************
    16/07/2008  d   Create date 
    08/12/2008  d   added season code partition 
    15/01/2009  d   add item_code 
/*********************************************************************************************/
PROCEDURE p_rep_wip_grouped (   p_org_code      VARCHAR2, 
                                p_year_month    VARCHAR2,
                                p_grp_by_wo     VARCHAR2    DEFAULT 'N')
IS
    CURSOR  C_GET_QTY    (p_period VARCHAR2, p_curr_oper VARCHAR2, p_curr_eq VARCHAR2,p_prev_oper VARCHAR2)
            IS
            SELECT  org_code_loc    ,
                    season_code     ,
                    'ALL'           order_code,
                    'ALL'           item_code,
                    SUM(qty_in)     qty_in,
                    SUM(qty_out)    qty_out
            FROM
            (
            SELECT      org_code_loc, v.season_code,
                        SUM(qty)            qty_in, 
                        0                   qty_out
            FROM        vw_rep_wip  v
            WHERE       period      =   p_period
                AND     first_oper  IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_curr_eq,',')))
                AND     oper_code   =   'LANSARE'
            GROUP BY    org_code_loc,season_code
            UNION ALL
            SELECT      w.org_code org_code_loc, p.season_code,
                        SUM(p.qty)          qty_in, 
                        0                   qty_out
            FROM        vw_rep_wip      p
            INNER JOIN  GROUP_ROUTING   r   ON  p.order_code    =   r.group_code
                                            AND r.oper_code     =   p_curr_oper
            INNER JOIN  WAREHOUSE       w   ON  w.whs_code      =   r.whs_cons
            WHERE       p.period    =   p_period
            AND         p.oper_code =   p_prev_oper
            GROUP BY    w.ORG_CODE, p.season_code
            UNION ALL
            SELECT      c.org_code_loc, c.season_code,
                        0                   qty_in, 
                        SUM(c.qty)          qty_out
            FROM        vw_rep_wip  c
            WHERE       c.period      =     p_period
            AND         c.oper_code   =     p_curr_oper
            GROUP BY    c.org_code_loc, c.season_code
            )
            WHERE       p_grp_by_wo = 'N'
            GROUP BY    org_code_loc,season_code
            --
            UNION ALL 
            --
            SELECT  org_code_loc    ,
                    season_code     ,
                    order_code      ,
                    MAX(item_code)  item_code,
                    SUM(qty_in)     qty_in,
                    SUM(qty_out)    qty_out
            FROM
            (
            SELECT      org_code_loc, v.season_code, v.order_code,
                        SUM(qty)    qty_in, 0 qty_out,
                        MAX(v.item_code)    item_code                   
            FROM        vw_rep_wip  v
            WHERE       period      =   p_period
                AND     first_oper  IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_curr_eq,',')))
                AND     oper_code   =   'LANSARE'
            GROUP BY    org_code_loc,season_code, order_code
            UNION ALL
            SELECT      w.org_code org_code_loc, p.season_code, p.order_code, 
                        SUM(p.qty)    qty_in, 0 qty_out,
                        MAX(p.item_code)    item_code                      
            FROM        vw_rep_wip      p
            INNER JOIN  GROUP_ROUTING   r   ON  p.order_code    =   r.group_code
                                            AND r.oper_code     =   p_curr_oper
            INNER JOIN  WAREHOUSE       w   ON  w.whs_code      =   r.whs_cons
            WHERE       p.period    =   p_period
            AND         p.oper_code =   p_prev_oper
            GROUP BY    w.ORG_CODE, p.season_code, p.order_code
            UNION ALL
            SELECT      c.org_code_loc, c.season_code, c.order_code,
                        0    qty_in, SUM(c.qty) qty_out,
                        MAX(c.item_code)    item_code                    
            FROM        vw_rep_wip  c
            WHERE       c.period      =     p_period
            AND         c.oper_code   =     p_curr_oper
            GROUP BY    c.org_code_loc, c.season_code, c.order_code
            )
            WHERE       p_grp_by_wo = 'Y'  
                AND     qty_in + qty_out > 0
            GROUP BY    org_code_loc,season_code, order_code
            ;

    CURSOR  C_OPERATION
            IS
            SELECT      *
            FROM        OPERATION
            ;


    it_rep          Pkg_Rtype.tas_vw_rep_wip_grouped;
    v_idx           VARCHAR2(1000);
    v_oper_code     VARCHAR2(1000);
    it_prev         Pkg_Glb.typ_varchar_varchar;
    it_equiv        Pkg_Glb.typ_varchar_varchar;
    it_oper         Pkg_Glb.typ_number_varchar;
    C_SEGMENT_CODE  VARCHAR2(30) := 'VW_REP_WIP_GROUPED';

BEGIN

    DELETE FROM VW_REP_WIP_GROUPED;

    Pkg_Prod.p_rep_wip(p_org_code, p_year_month);

    FOR x IN C_OPERATION
    LOOP
        it_oper(x.oper_code)    :=  x.oper_seq;
    END LOOP;

    it_prev('CROIT')    :=  '';
    it_prev('CUSUT')    :=  'CROIT';
    it_prev('TRAS')     :=  'CUSUT';
    it_prev('AMBALAT')  :=  'TRAS';

    it_equiv('CROIT')   :=  'CROIT';
    it_equiv('CUSUT')    :=  'PRECUSUT,CUSUT';
    it_equiv('TRAS')     :=  'PRETRAS,TRAS';
    it_equiv('AMBALAT')  :=  'AMBALAT,FINIT';

    v_oper_code   :=  it_prev.FIRST;
    WHILE v_oper_code IS NOT NULL
    LOOP
        FOR x IN C_GET_QTY ('OLD', v_oper_code,it_equiv(v_oper_code), it_prev(v_oper_code))
        LOOP
            v_idx   :=  Pkg_Lib.f_implode('$',x.org_code_loc,v_oper_code, x.season_code, x.order_code);
            it_rep(v_idx).segment_code  :=  C_SEGMENT_CODE;
            it_rep(v_idx).org_code_loc  :=  x.org_code_loc;
            it_rep(v_idx).season_code   :=  x.season_code;
            it_rep(v_idx).order_code    :=  x.order_code;
            it_rep(v_idx).item_code     :=  x.item_code;            
            it_rep(v_idx).oper_seq      :=  it_oper(v_oper_code);
            it_rep(v_idx).oper_code     :=  v_oper_code;
            it_rep(v_idx).stock_ini     :=  x.qty_in - x.qty_out;
            it_rep(v_idx).qty_in        :=  0;
            it_rep(v_idx).qty_out       :=  0;
            it_rep(v_idx).stock_fin     :=  it_rep(v_idx).stock_ini;
        END LOOP;

        FOR x IN C_GET_QTY (p_year_month, v_oper_code, it_equiv(v_oper_code), it_prev(v_oper_code))
        LOOP
            v_idx   :=  Pkg_Lib.f_implode('$',x.org_code_loc,v_oper_code, x.season_code, x.order_code);
            it_rep(v_idx).segment_code  :=  C_SEGMENT_CODE;
            it_rep(v_idx).org_code_loc  :=  x.org_code_loc;
            it_rep(v_idx).season_code   :=  x.season_code;
            it_rep(v_idx).order_code    :=  x.order_code;
            it_rep(v_idx).item_code     :=  x.item_code;   
            it_rep(v_idx).oper_seq      :=  it_oper(v_oper_code);
            it_rep(v_idx).oper_code     :=  v_oper_code;
            it_rep(v_idx).qty_in        :=  x.qty_in;
            it_rep(v_idx).qty_out       :=  x.qty_out;
            it_rep(v_idx).stock_fin     :=  NVL(it_rep(v_idx).stock_ini, 0)
                                            +   it_rep(v_idx).qty_in
                                            -   it_rep(v_idx).qty_out       ;
        END LOOP;
        v_oper_code   :=  it_prev.NEXT(v_oper_code);
    END LOOP;

    v_idx   :=  it_rep.FIRST;
    WHILE v_idx IS NOT NULL
    LOOP
        INSERT INTO VW_REP_WIP_GROUPED VALUES it_rep(v_idx);
        v_idx   :=  it_rep.NEXT(v_idx);
    END LOOP;

END;


/*********************************************************************************************
    02/10/2008  d   Create date
/*********************************************************************************************/
PROCEDURE p_rep_order_situation (   p_org_code VARCHAR2, p_season_code VARCHAR2)
-----------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------
IS

    CURSOR C_WO     (   p_org_code  VARCHAR2, p_season_code VARCHAR2)
                    IS
                    SELECT      o.idriga,
                                MAX(o.org_code)     org_code,
                                MAX(o.order_code)   order_code,
                                MAX(o.item_code)    item_code,
                                MAX(o.season_code)  season_code,
                                MAX(i.description)  i_description,
                                MAX(i.root_code)    i_root_code,
                                MAX(o.status)       o_status,
                                SUM(d.qta)          qty_nom
                    FROM        WORK_ORDER      o
                    INNER JOIN  WO_DETAIL       d   ON  d.ref_wo    =   o.idriga
                    INNER JOIN  ITEM            i   ON  i.org_code  =   o.org_code
                                                    AND i.item_code =   o.item_code
                    WHERE       o.org_code      =   'RUC'
                        AND     o.season_code   =   'AI08'
                    GROUP BY    o.idriga
                    ;

    CURSOR C_STOCK_FIN  (p_org_code VARCHAR2, p_order_code VARCHAR2)
                    IS
                    SELECT      SUM(s.qty)      qty
                    FROM        STOC_ONLINE     s
                    INNER JOIN  WAREHOUSE       w   ON  w.whs_code  =   s.whs_code
                    WHERE       s.org_code      =   p_org_code
                        AND     s.order_code    =   p_order_code
                        AND     w.category_code =   Pkg_Glb.C_WHS_SHP
                    ;

    -- shipped quantities
    CURSOR C_SHIP   (p_org_code VARCHAR2, p_order_code VARCHAR2)
                    IS
                    SELECT      SUM((-1)*t.trn_sign * t.qty)      qty
                    FROM        WHS_TRN_DETAIL  t
                    WHERE       t.org_code      =   p_org_code
                        AND     t.order_code    =   p_order_code
                        AND     t.reason_code   =   Pkg_Glb.C_M_OSHPPF
                    ;

    -- produced quantities
    CURSOR C_PROD   (p_org_code VARCHAR2, p_order_code VARCHAR2)
                    IS
                    SELECT      r.seq_no                ,
                                MAX(r.oper_code)        oper_code,
                                SUM(d.qty*d.trn_sign)   qty
                    FROM        GROUP_ROUTING   r
                    LEFT JOIN   WHS_TRN_DETAIL  d   ON  d.group_code    =   r.group_code
                                                    AND d.oper_code_item=   r.oper_code
                                                    AND d.reason_code   =   Pkg_Glb.C_P_IPRDSP
                    WHERE       d.order_code        =   p_order_code
                        AND     d.org_code          =   p_org_code
                    GROUP BY    r.group_code, r.seq_no
                    ORDER BY    r.seq_no DESC
                    ;

    it_rep          Pkg_Rtype.tas_vw_rep_order_situation;
    v_row_ini       VW_REP_ORDER_SITUATION%ROWTYPE;
    v_idx           VARCHAR2(1000);
    C_SEGMENT_CODE  VARCHAR2(30)    :=  'VW_REP_ORDER_SITUATION';
    v_stock_fin     NUMBER;
    v_qty_remain    NUMBER;
    v_qty           NUMBER;

BEGIN

    DELETE FROM VW_REP_ORDER_SITUATION;

    v_row_ini.segment_code      :=  C_SEGMENT_CODE;
    v_row_ini.oper_1            :=  'CROIT';
    v_row_ini.oper_2            :=  'CUSUT';
    v_row_ini.oper_3            :=  'TRAS';
    v_row_ini.oper_4            :=  'AMBALAT';
    v_row_ini.qty_1             :=  0;
    v_row_ini.qty_2             :=  0;
    v_row_ini.qty_3             :=  0;
    v_row_ini.qty_4             :=  0;


    FOR x IN C_WO(p_org_code, p_season_code)
    LOOP
        v_idx   :=  Pkg_Lib.f_implode('$',x.org_code,x.order_code);
        it_rep(v_idx)               :=  v_row_ini;

        it_rep(v_idx).org_code      :=  x.org_code;
        it_rep(v_idx).order_code    :=  x.order_code;
        it_rep(v_idx).item_code     :=  x.item_code;
        it_rep(v_idx).description   :=  x.i_description;
        it_rep(v_idx).family_code   :=  x.i_root_code;
        it_rep(v_idx).qty_nom       :=  x.qty_nom;
        it_rep(v_idx).qty_fin       :=  v_stock_fin;

        v_qty_remain                :=  x.qty_nom;

        -- INITIAL ORDER
        CASE
            WHEN    x.o_status IN ('I') THEN
                it_rep(v_idx).qty_notvalidated  :=  v_qty_remain;
                v_qty_remain                    :=  0;
            -- validated only orders
            WHEN    x.o_status IN ('V') THEN
                it_rep(v_idx).qty_notlaunched   :=  v_qty_remain;
            -- open orders
            WHEN    x.o_status IN ('T','L') THEN

                -- determine the shipped quantity
                v_qty   :=  0;
                OPEN    C_SHIP(x.org_code, x.order_code);
                FETCH   C_SHIP INTO v_qty;
                CLOSE   C_SHIP;
                it_rep(v_idx).qty_exp   :=  NVL(v_qty,0);

                -- determine the FINISHED quantity (produced, but not shipped)
                v_qty   :=  0;
                OPEN C_STOCK_FIN(p_org_code, x.order_code);
                FETCH C_STOCK_FIN INTO v_qty;
                CLOSE C_STOCK_FIN;
                it_rep(v_idx).qty_fin   :=  NVL(v_qty,0);

                v_qty_remain    :=  GREATEST(x.qty_nom - it_rep(v_idx).qty_exp - it_rep(v_idx).qty_fin, 0);

                -- get the IN WORK quantities
                IF v_qty_remain > 0 THEN
                    FOR xx IN C_PROD(x.org_code, x.order_code)
                    LOOP
                        EXIT WHEN v_qty_remain <= 0;

                        CASE xx.oper_code
                            WHEN    v_row_ini.oper_3    THEN
                                    it_rep(v_idx).qty_4 :=  GREATEST(xx.qty - x.qty_nom + v_qty_remain,0);
                                    v_qty_remain        :=  GREATEST(v_qty_remain - it_rep(v_idx).qty_4, 0);
                            WHEN    v_row_ini.oper_2    THEN
                                    it_rep(v_idx).qty_3 :=  GREATEST(xx.qty - x.qty_nom + v_qty_remain,0);
                                    v_qty_remain        :=  GREATEST(v_qty_remain - it_rep(v_idx).qty_3, 0);
                            WHEN    v_row_ini.oper_1    THEN
                                    it_rep(v_idx).qty_2 :=  GREATEST(xx.qty - x.qty_nom + v_qty_remain,0);
                                    v_qty_remain        :=  GREATEST(v_qty_remain - it_rep(v_idx).qty_2, 0);
                            ELSE
                                    NULL;
                        END CASE;

                    END LOOP;
                    it_rep(v_idx).qty_1 := v_qty_remain;

                END IF;

        END CASE;




    END LOOP;

    v_idx   :=  it_rep.FIRST;
    WHILE v_idx IS NOT NULL
    LOOP
        INSERT INTO VW_REP_ORDER_SITUATION VALUES it_rep(v_idx);
        v_idx   :=  it_rep.NEXT(v_idx);
    END LOOP;


END;

END;

/

/
