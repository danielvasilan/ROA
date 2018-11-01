--------------------------------------------------------
--  DDL for Package Body PKG_ORDER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_ORDER" 
IS


/*********************************************************************************
-- DDL: 18/02/2008  d   Create package
--                  d   added       p_generate_work_group
--      19/02/2008  d   added       f_get_default_whs_cons
--      20/02/2008  d   added       f_get_default_workcenter
--                      modified    p_generate_work_group
--      21/02/2008  d   added       p_grp_generate_bom
--      24/02/2008  d   added       p_duplicate_work_order
--                  d   added       p_grp_associate_undo
--                  d   added       p_grp_authorize
--                  d   added       p_grp_authorize_undo
--                  d   added       p_grp_close
--                  d   added       f_get_routing_prev_oper
--                  d   added       f_rout_get_oper_seq
--      25/02/2008  d   added       f_grp_get_status_description
--                  d   added       p_grp_launch
--                  d   added       p_grp_launch_undo
--                  d   added       p_grp_generate_bom_undo
--      29/02/2008  d   added       p_prepare_work_order
/*********************************************************************************/

----------------------------------------------------------------------------------
-- This package will have the ORDER BLO (WORK_ORDER + GROUP)
--
--
----------------------------------------------------------------------------------



-- to be moved in Pkg_Cursor   ????

-- work orders without BOM (in ITEM ) for a WORK_GROUP
CURSOR C_GRP_WO_WITHOUT_BOM     (p_group_code   VARCHAR2)
                                IS
                                SELECT      DISTINCT o.order_code, o.item_code, i.make_buy
                                FROM        WO_GROUP    wg
                                INNER JOIN  WORK_ORDER  o   ON  o.order_code    =   wg.order_code
                                INNER JOIN  ITEM        i   ON  i.org_code      =   o.org_code
                                                            AND i.item_code     =   o.item_code
                                WHERE       wg.group_code   =   p_group_code
                                    AND     NOT EXISTS( SELECT  1
                                                        FROM    BOM_STD         b
                                                        WHERE   b.org_code      = o.org_code
                                                            AND b.father_code   = o.item_code
                                                        )
                                ;

/*********************************************************************************
    DDL: 19/02/2008  d Create FUNCTION

/*********************************************************************************/
FUNCTION f_get_default_whs_cons (   p_org_code  VARCHAR2) RETURN VARCHAR2
----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
IS

    CURSOR C_WHS_CONS       (p_org_code VARCHAR2)
                            IS
                            SELECT      whs_code
                            FROM        WAREHOUSE
                            WHERE       org_code        =   p_org_code
                                AND     category_code   IN  (   Pkg_Glb.C_WHS_WIP,
                                                                Pkg_Glb.C_WHS_CTL
                                                            )
                            ;

    v_found                 BOOLEAN;
    v_whs_cons              VARCHAR2(30);

BEGIN

    -- get the first WIP warehouse for organization
    OPEN        C_WHS_CONS(p_org_code);
    FETCH       C_WHS_CONS INTO v_whs_cons;
    v_found :=  C_WHS_CONS%FOUND;
    CLOSE       C_WHS_CONS;

    RETURN v_whs_cons;
END;

/*********************************************************************************
    DDL: 19/02/2008  d Create FUNCTION

/*********************************************************************************/
FUNCTION f_get_default_whs_fin (   p_org_code  VARCHAR2) RETURN VARCHAR2
----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
IS

    CURSOR C_WHS_FIN        (   p_org_code VARCHAR2)
                            IS
                            SELECT      whs_code
                            FROM        WAREHOUSE
                            WHERE       org_code        =   p_org_code
                                AND     category_code   IN  (Pkg_Glb.C_WHS_SHP,Pkg_Glb.C_WHS_CTL)
                            ORDER BY    category_code, whs_code
                            ;

    v_found                 BOOLEAN;
    v_whs_fin               VARCHAR2(30);

BEGIN

    -- get the first WIP warehouse for organization
    OPEN        C_WHS_FIN(p_org_code);
    FETCH       C_WHS_FIN INTO v_whs_fin;
    v_found :=  C_WHS_FIN%FOUND;
    CLOSE       C_WHS_FIN;

    RETURN v_whs_fin;
END;

/*********************************************************************************
    DDL: 07/03/2008  d moved from Pkg_Ord

/*********************************************************************************/
FUNCTION f_get_default_season   (   p_org_code      VARCHAR2 )
                                    RETURN          VARCHAR2
-----------------------------------------------------------------------------------
--  PURPOSE:    get the default SEASON for an organization
-----------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (p_org_code VARCHAR2)
                    IS
                    SELECT      season_code
                    FROM        WORK_SEASON
                    WHERE       org_code        =   p_org_code
                        AND     flag_active     =   'Y'
                    ORDER BY    season_code     DESC
                    ;

    v_row_sea   C_LINES%ROWTYPE;

BEGIN
    OPEN  C_LINES(p_org_code);
    FETCH C_LINES INTO v_row_sea;
    CLOSE C_LINES;
    RETURN v_row_sea.season_code;
END;

/*********************************************************************************
    DDL: 20/02/2008  d Create FUNCTION

/*********************************************************************************/
FUNCTION f_get_default_workcenter   (   p_org_code      VARCHAR2,
                                        p_oper_code     VARCHAR2
                                    )
                                        RETURN          VARCHAR2
----------------------------------------------------------------------------------
--  PURPOSE:    returns the first workcenter that it finds for the organization
--              and the operation
--  INPUT:
--              - ORG_CODE  = organization for which we're looking for the workcenter
--              - OPER_CODE = operation
--  OUTPUT:
--              - WORKCENTER_CODE that matches the ORG + OPER combination
----------------------------------------------------------------------------------
IS

    CURSOR C_WORKCENTER     (p_org_code VARCHAR2, p_oper_code VARCHAR2)
                            IS
                            SELECT      wk.workcenter_code
                            FROM        WORKCENTER      wk
                            INNER JOIN  WORKCENTER_OPER wo  ON wo.workcenter_code   = wk.workcenter_code
                                                            AND wo.oper_code        = p_oper_code
                            INNER JOIN  COSTCENTER      cc  ON cc.costcenter_code   = wk.costcenter_code
                                                            AND cc.org_code         = p_org_code
                            ;

    v_found         BOOLEAN;
    v_workcenter    VARCHAR2(30);

BEGIN

    -- get the first WIP warehouse for organization
    OPEN        C_WORKCENTER(p_org_code, p_oper_code);
    FETCH       C_WORKCENTER INTO v_workcenter;
    v_found :=  C_WORKCENTER%FOUND;
    CLOSE       C_WORKCENTER;

    RETURN v_workcenter;
END;


/*****************************************************************************************************
    DDL: 24/02/2008  d Create FUNCTION

/*****************************************************************************************************/
FUNCTION f_get_routing_prev_oper    (   p_routing_code      VARCHAR2,
                                        p_oper_code         VARCHAR2
                                    )
                                    RETURN VARCHAR2
-----------------------------------------------------------------------------------------------------
--  RETURN the previous OPER_CODE in a routing
--  INPUT:      ROUTING_CODE    = code of the macrorouting
--              OPER_CODE       = relative to this operation will be retrieved the previous one
-----------------------------------------------------------------------------------------------------
IS

    CURSOR C            (   p_routing_code VARCHAR2, p_oper_code VARCHAR2)
                        IS
                        SELECT      oper_code
                        FROM        MACROROUTING_DETAIL     e
                        WHERE       e.routing_code          = p_routing_code
                            AND     e.seq_no <
                                    (
                                    SELECT      seq_no
                                    FROM        MACROROUTING_DETAIL     m
                                    WHERE       m.routing_code          =   e.routing_code
                                        AND     oper_code               =   p_oper_code
                                    )
                        ORDER BY    seq_no DESC
                        ;

    v_result            VARCHAR2(30);

BEGIN
    OPEN C (p_routing_code, p_oper_code); FETCH C INTO v_result; CLOSE C;
    RETURN v_result;
END;


/*****************************************************************************************************
    DDL: 24/02/2008  d Create FUNCTION

/*****************************************************************************************************/
FUNCTION    f_rout_get_oper_seq     (   p_routing_code  VARCHAR2,
                                        p_oper_code     VARCHAR2
                                    )   RETURN NUMBER
-----------------------------------------------------------------------------------------------------
--  PURPOSE:    RETURN the sequence for an OPER_CODE inside a ROUTING
--  INPUT:      ROUTING_CODE    = code of the macrorouting
--              OPER_CODE       = Operation
-----------------------------------------------------------------------------------------------------
IS
    CURSOR C            (   p_routing_code  VARCHAR2, p_oper_code VARCHAR2)
                        IS
                        SELECT      m.seq_no
                        FROM        MACROROUTING_DETAIL m
                        WHERE       m.routing_code  =   p_routing_code
                            AND     m.oper_code     =   p_oper_code
                        ;

    v_result    NUMBER;

BEGIN
    OPEN C  (p_routing_code, p_oper_code); FETCH C INTO v_result; CLOSE C;
    RETURN v_result;
END;


/*********************************************************************************
    DDL: 25/02/2008  d Create procedure

/*********************************************************************************/
FUNCTION    f_grp_get_status_description    (   p_status_code VARCHAR2) RETURN VARCHAR2
---------------------------------------------------------------------------------------------------
--  return the description of the Group status
---------------------------------------------------------------------------------------------------
IS
    CURSOR  C       (p_status_code VARCHAR2)
                    IS
                    SELECT  description
                    FROM    MULTI_TABLE
                    WHERE   table_name      =   'GRP_STATUS'
                        AND table_key       =   p_status_code
                    ;

    v_result        VARCHAR2(100);

BEGIN
    OPEN    C(p_status_code); FETCH C INTO v_result; CLOSE C;
    RETURN  NVL(v_result,p_status_code);
END;


/*********************************************************************************
    DDL: 25/02/2008  d Create procedure

/*********************************************************************************/
PROCEDURE p_grp_associate_checks    (   p_start_oper        VARCHAR2,
                                        p_end_oper          VARCHAR2,
                                        p_flag_rae          BOOLEAN
                                    )
-------------------------------------------------------------------------------------------------------------
--  PURPOSE:    checks a list of work orders in order to associate them to a group order
--              uses a temporary structure where inserts data and makes different checks on it
-------------------------------------------------------------------------------------------------------------
IS

    CURSOR  C_VW_BLO_GRP_ASSOC_CHK  (p_start_oper VARCHAR2, p_end_oper VARCHAR2)
            IS
            SELECT      numb01 ref_wo, o.org_code org_code,o.order_code, o.item_code,
                        o.routing_code, m.oper_code, m.seq_no,
                        ROW_NUMBER() OVER(PARTITION BY o.order_code,m.routing_code ORDER BY m.seq_no) seq_no_glb,
                        wg.group_code group_code_assoc,'VW_BLO_GRP_ASSOC_CHK' segment_code
            ---------------------------------------------------------------------------------------------
            FROM        VW_TRANSFER_ORACLE  t
            INNER JOIN  WORK_ORDER          o ON o.idriga       = t.numb01
            LEFT JOIN   MACROROUTING_DETAIL m ON m.routing_code = o.routing_code
                        AND m.seq_no    BETWEEN
                                            Pkg_Order.f_rout_get_oper_seq(o.routing_code,p_start_oper)
                                        AND Pkg_Order.f_rout_get_oper_seq(o.routing_code,p_end_oper)
            LEFT JOIN   WO_GROUP    wg  ON  wg.order_code   = o.order_code
                                        AND wg.org_code     = o.org_code
                                        AND wg.oper_code    = m.oper_code
            ---------------------------------------------------------------------------------------------
            ;

    CURSOR C_CHK_DIFF_ITEM  IS
                            SELECT      DISTINCT wo.item_code, wo.season_code,
                                        COUNT(1) OVER (PARTITION BY wo.item_code, wo.season_code)   ite_nr,
                                        COUNT(1) OVER ()                                            tot_nr
                            FROM        VW_TRANSFER_ORACLE  t
                            INNER JOIN  WORK_ORDER          wo ON t.numb01 = wo.idriga
                            ;


    CURSOR C_CHK_WO_ASSOC   IS
                            SELECT      *
                            FROM        VW_BLO_GRP_ASSOC_CHK
                            WHERE       group_code_assoc IS NOT NULL
                            ORDER BY    order_code, seq_no
                            ;

    CURSOR C_CHK_OPER_SEQ   IS
                            SELECT      *
                            FROM        (
                                        SELECT      order_code, oper_code, seq_no_glb,
                                                    MIN(seq_no_glb) OVER(PARTITION BY oper_code) min_seq_no
                                        FROM        VW_BLO_GRP_ASSOC_CHK
                                        WHERE       group_code_assoc    IS NOT NULL
                                        ORDER BY    order_code, seq_no
                                        )
                            WHERE       seq_no_glb <> min_seq_no
                            ;

    CURSOR C_CHK_WO_ROUT    IS
                            SELECT      *
                            FROM        VW_BLO_GRP_ASSOC_CHK
                            WHERE       routing_code    IS NULL
                            ;

    CURSOR C_CHK_NODET      IS
                            SELECT      o.*
                            FROM        VW_TRANSFER_ORACLE  t
                            INNER JOIN  WORK_ORDER          o   ON  o.idriga      =   t.numb01
                            LEFT JOIN   WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                            WHERE       d.qta   IS NULL
                            ;

    v_row_chk               VW_BLO_GRP_ASSOC_CHK%ROWTYPE;
    v_err_wo_ass            VARCHAR2(2000);
    v_err_oper_seq          VARCHAR2(2000);
    v_err_wo_rout           VARCHAR2(2000);
    v_errstr                VARCHAR2(2000);
    v_rowcount              PLS_INTEGER :=  0;

BEGIN
    -- reset the temporary structure
    DELETE FROM VW_BLO_GRP_ASSOC_CHK;

    -- insert in the view all the needed informations
    FOR x IN C_VW_BLO_GRP_ASSOC_CHK (p_start_oper, p_end_oper)
    LOOP
        INSERT INTO VW_BLO_GRP_ASSOC_CHK VALUES x;
        v_rowcount  :=  C_VW_BLO_GRP_ASSOC_CHK%rowcount;
    END LOOP;
    IF v_rowcount   = 0 THEN Pkg_App_Tools.P_Log('M', '0 Bole gasite ','Nu sunt bole de asociat!');END IF;

    -- pre-verifications  (more than 1 PF, more than 1 season)
    FOR x IN C_CHK_DIFF_ITEM
    LOOP
        IF x.tot_nr <> x.ite_nr THEN
            Pkg_App_Tools.P_Log('M',x.item_code||'  {'||x.season_code||'}','LISTA DE BOLE NEOMOGENA!');
        END IF;
    END LOOP;

    -- check the work order with no routing
    FOR x IN C_CHK_WO_ROUT
    LOOP
        Pkg_App_Tools.P_Log('M','Bola: '||x.order_code,'BOLE FARA ROUTING:');
    END LOOP;

    -- check the work orders already associated on other groups for at least one of the operations
    --  between START_OPER and END_OPER
    FOR x IN C_CHK_WO_ASSOC
    LOOP
        v_err_wo_ass    := 'Bola: '||x.order_code || ' , operatia '||x.oper_code;
        v_err_wo_ass    := v_err_wo_ass || ' pe Gruparea: '||x.group_code_assoc;
        Pkg_App_Tools.P_Log('M', v_err_wo_ass,'BOLE ASOCIATE DEJA');
    END LOOP;

    -- check if every operation is at the same sequence in the work orders sub-routing
    FOR x IN C_CHK_OPER_SEQ
    LOOP
        v_err_oper_seq  :=  'Operatia: '||x.oper_code||' Bola:'||x.order_code;
        v_err_oper_seq  :=  v_err_oper_seq  || ' Pozitia: '||x.seq_no_glb||' Pozitia minima: '||x.min_seq_no;
        Pkg_App_Tools.P_Log('M', v_err_oper_seq,'OPERATII CU POZITII DIFERITE');
    END LOOP;

    -- check if all the Orders have a size list (detail)
    FOR x IN C_CHK_NODET
    LOOP
        v_err_oper_seq  :=  'Bola: '||x.order_code;
        Pkg_App_Tools.P_Log('M', v_err_oper_seq,'BOLE FARA PONTAJ');
    END LOOP;

    IF p_flag_rae THEN Pkg_Lib.p_rae_m('B'); END IF;

END;

/*********************************************************************************
    DDL: 18/02/2008  d Create procedure

/*********************************************************************************/
PROCEDURE p_grp_generate        (   p_org_code      VARCHAR2,
                                    p_season_code   VARCHAR2,
                                    p_start_oper    VARCHAR2,
                                    p_end_oper      VARCHAR2,
                                    p_org_code_work VARCHAR2,
                                    p_flag_validate BOOLEAN,
                                    p_flag_launch   BOOLEAN,
                                    p_flag_commit   BOOLEAN
                                )
----------------------------------------------------------------------------------
--  PURPOSE:    generates a new work_group and associate to it the work_orders
--              it finds in VW_TRANSFER
--  PREREQ:     the VW_TRANSFER temporary structure must contain only the work order
--              to associate in the new group
--  INPUT:      ORG_CODE        = org_code
--              START_OPER      = start operation for the routing
--              END_OPER        = end operation for the routing
--              ORG_CODE_WORK   = organization where the order will be issued
----------------------------------------------------------------------------------
IS
    CURSOR  C_WORK_ORDER    IS
                            SELECT      wo.*
                            FROM        VW_TRANSFER_ORACLE  t
                            INNER JOIN  WORK_ORDER          wo ON t.numb01 = wo.idriga
                            ;

    CURSOR  C_OPERATION     (p_start_oper   VARCHAR2, p_end_oper VARCHAR2)
                            IS
                            SELECT      o.oper_seq, o.oper_code
                            FROM        OPERATION   o
                            WHERE       o.oper_code IN (p_start_oper, p_end_oper)
                            ORDER BY    o.oper_seq
                            ;

    CURSOR C_GROUP_ROUTING  (p_group_code VARCHAR2)
                            IS
                            SELECT      gr.oper_code
                            FROM        GROUP_ROUTING   gr
                            INNER JOIN  WORK_GROUP      wg ON wg.idriga = gr.ref_group AND wg.group_code = p_group_code
                            ORDER BY    gr.seq_no
                            ;

    CURSOR C_MACROROUTING   (   p_start_oper    VARCHAR2,
                                p_end_oper      VARCHAR2)
                            IS
                            SELECT  seq_no_glb, oper_code, MAX(flag_milestone) flag_milestone
                            FROM
                            (
                                SELECT  routing_code, oper_code, seq_no, flag_milestone,
                                        ROW_NUMBER() OVER(PARTITION BY routing_code ORDER BY seq_no) seq_no_glb
                                -------------------------------------------------------------------------------
                                FROM    MACROROUTING_DETAIL     e
                                -------------------------------------------------------------------------------
                                WHERE   e.seq_no        >=      Pkg_Order.f_rout_get_oper_seq   (e.routing_code, p_start_oper)
                                    AND e.seq_no        <=      Pkg_Order.f_rout_get_oper_seq   (e.routing_code, p_end_oper)
                                    AND e.routing_code  IN  (   SELECT      wo.routing_code
                                                                FROM        VW_TRANSFER_ORACLE  t
                                                                INNER JOIN  WORK_ORDER          wo ON t.numb01 = wo.idriga
                                                            )
                            )
                            GROUP BY seq_no_glb, oper_code
                            ;

    v_found                 BOOLEAN;
    v_rowcount              INT;
    v_row_oper              C_OPERATION%ROWTYPE;
    v_row_grp               WORK_GROUP%ROWTYPE;
    v_row_wog               WO_GROUP%ROWTYPE;
    v_group_code            VARCHAR2(30);
    v_row_gr_r              GROUP_ROUTING%ROWTYPE;
    it_wo                   Pkg_Rtype.ta_work_order;
    v_org_code_work         VARCHAR2(30);
    v_org_myself            VARCHAR2(30);

BEGIN

    -- if ORG_CODE_WORK not set, put MYSELF
    v_org_code_work         :=  NVL(p_org_code_work, Pkg_Nomenc.f_get_myself_org());

    Pkg_App_Tools.p_dbg_start(Pkg_Lib.f_implode (   ';',
                                                    p_org_code,
                                                    p_season_code,
                                                    p_start_oper,
                                                    p_end_oper,
                                                    p_org_code_work
                                                ));

    IF p_start_oper IS NULL OR p_end_oper IS NULL THEN
        Pkg_Lib.p_rae('Nu ati precizat Operatia START sau END');
    END IF;

    -- verify if the start operation <= end operation
    FOR x IN C_OPERATION  (p_start_oper, p_end_oper)
    LOOP
        v_rowcount      :=  C_OPERATION%rowcount;
        IF v_rowcount   = 2 AND x.oper_code <> p_end_oper THEN
            Pkg_Lib.p_rae(p_start_oper||' se afla dupa '||p_end_oper||' in nomenclatorul de operatii!');
        END IF;
    END LOOP;
    IF v_rowcount <> 2 AND p_start_oper <> p_end_oper THEN
        Pkg_Lib.p_rae('Operatia START sau END nu exista definite in nomenclatorul de operatii!');
    END IF;

    OPEN    C_OPERATION(p_start_oper, p_end_oper);
    FETCH   C_OPERATION INTO v_row_oper; v_found := C_OPERATION%FOUND;
    CLOSE   C_OPERATION;
    IF p_start_oper <> v_row_oper.oper_code THEN
        Pkg_Lib.p_rae('Ati setat eronat: START OPER='||p_start_oper||' si END_OPER='||p_end_oper);
    END IF;

    Pkg_Order.p_grp_associate_checks    (   p_start_oper    =>  p_start_oper,
                                            p_end_oper      =>  p_end_oper,
                                            p_flag_rae      =>  TRUE
                                        );

    OPEN C_WORK_ORDER; FETCH C_WORK_ORDER BULK COLLECT INTO it_wo; CLOSE C_WORK_ORDER;

    IF it_wo.COUNT > 1 THEN
        -- generate the new work group
        v_group_code    :=  Pkg_Env.f_get_app_doc_number
                                        (   p_org_code      =>  p_org_code,
                                            p_doc_type      =>  'WOGRP',
                                            p_doc_subtype   =>  'WOGRP',
                                            p_num_year      =>  TO_CHAR(SYSDATE,'YYYY')
                                        );
    ELSE
        v_group_code    :=  it_wo(1).org_code||'/'||it_wo(1).order_code;
    END IF;

    v_row_grp.org_code      :=  p_org_code;
    v_row_grp.group_code    :=  v_group_code;
    v_row_grp.status        :=  'I';
    v_row_grp.season_code   :=  p_season_code;
    Pkg_Iud.p_work_group_iud('I',v_row_grp);
    v_row_grp.idriga        :=  Pkg_Lib.f_read_pk;

    -- generate the ROUTING for the GROUP routing
    FOR xx IN C_MACROROUTING (p_start_oper, p_end_oper)
    LOOP
        -- get MYSELF organization code
        v_org_myself                :=  Pkg_Nomenc.f_get_myself_org();

        v_row_gr_r.ref_group        :=  v_row_grp.idriga;
        v_row_gr_r.group_code       :=  v_row_grp.group_code;
        v_row_gr_r.oper_code        :=  xx.oper_code;
        v_row_gr_r.seq_no           :=  xx.seq_no_glb;
        v_row_gr_r.workcenter_code  :=  f_get_default_workcenter(v_org_code_work, xx.oper_code);
        -- if no workcenter code found for the operation, the MYSELF wc will be issued
        IF v_row_gr_r.workcenter_code IS NULL THEN
            v_row_gr_r.workcenter_code  :=  f_get_default_workcenter(v_org_myself, xx.oper_code);
            v_row_gr_r.whs_cons         :=  f_get_default_whs_cons  (v_org_myself);
            v_row_gr_r.whs_dest         :=  f_get_default_whs_cons  (v_org_myself);
        ELSE
            v_row_gr_r.whs_cons         :=  f_get_default_whs_cons  (v_org_code_work);
            v_row_gr_r.whs_dest         :=  f_get_default_whs_cons  (v_org_code_work);
        END IF;
        v_row_gr_r.milestone        :=  xx.flag_milestone;

        Pkg_Iud.p_group_routing_iud('I', v_row_gr_r);

    END LOOP;

    --
    FOR i IN 1..it_wo.COUNT
    LOOP
        --
        v_row_wog.group_code    :=  v_group_code;
        v_row_wog.order_code    :=  it_wo(i).order_code;
        v_row_wog.org_code      :=  it_wo(i).org_code;

        -- loop on workorder routing
        FOR xx IN C_GROUP_ROUTING  (v_row_grp.group_code)
        LOOP
            -- insert a new line for every operation from GROUP macrorouting
            -- in the WORKORDER  <-> GROUP link table
            v_row_wog.oper_code := xx.oper_code;
            Pkg_Iud.p_wo_group_iud('I',v_row_wog);
        END LOOP;
    END LOOP;

    -- LAUNCH the GROUP
    IF p_flag_validate THEN
        Pkg_Order.p_grp_validate(   p_group_code    =>  v_group_code,
                                    p_flag_commit   =>  FALSE);
    END IF;

    -- LAUNCH the GROUP
    IF p_flag_launch THEN
        Pkg_Order.p_grp_launch  (   p_group_code    =>  v_group_code,
                                    p_flag_commit   =>  FALSE);
    END IF;

    Pkg_App_Tools.p_dbg_stop();

    IF p_flag_commit THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_flag_commit THEN ROLLBACK; END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/*********************************************************************************
    DDL: 27/02/2008  d Create procedure

/*********************************************************************************/
PROCEDURE p_grp_get_size_qty    (   p_group_code            VARCHAR2,
                                    p_oper_code             VARCHAR2,
                                    it_size_qty     IN OUT  Pkg_Glb.typ_number_varchar)
----------------------------------------------------------------------------------
--  PURPOSE:    RETURN  a PL/SQL table with nominal quantities for every size of
--              a GROUP
----------------------------------------------------------------------------------
IS
    CURSOR C_GRP_SIZE_QTY   (   p_group_code    VARCHAR2    ,
                                p_oper_code     VARCHAR2)
                            IS
                            SELECT      gr.seq_no                       ,
                                        gr.oper_code                    ,
                                        d.size_code                     ,
                                        SUM(d.qta)                      nom_qty
                            -----------------------------------------------------------------------------
                            FROM        WORK_GROUP          g
                            INNER JOIN  WO_GROUP            wg  ON  wg.group_code   =   g.group_code
                            INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   wg.org_code
                                                                AND o.order_code    =   wg.order_code
                            LEFT JOIN   WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                            INNER JOIN  GROUP_ROUTING       gr  ON  gr.ref_group    =   g.idriga
                                                                AND gr.oper_code    =   wg.oper_code
                            -----------------------------------------------------------------------------
                            WHERE       g.group_code        =       p_group_code
                                AND     gr.oper_code        LIKE    NVL(p_oper_code, '%')
                            -----------------------------------------------------------------------------
                            GROUP BY    gr.seq_no,gr.oper_code, d.size_code
                            ORDER BY    1,3
                            ;

BEGIN

    it_size_qty.DELETE;

    FOR x IN C_GRP_SIZE_QTY (p_group_code, p_oper_code)
    LOOP
        it_size_qty (x.oper_code||x.size_code)    :=  x.nom_qty;
    END LOOP;

END;

/*********************************************************************************
    DDL: 27/02/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_grp_get_range_qty    (   it_size_qty     Pkg_Glb.typ_number_varchar,
                                    p_oper_code     VARCHAR2,
                                    p_flag_range    INTEGER,
                                    p_flag_size     INTEGER,
                                    p_size_code     VARCHAR2,
                                    p_size_start    VARCHAR2,
                                    p_size_end      VARCHAR2
                                )   RETURN          NUMBER
------------------------------------------------------------------------------------
--  PURPOSE:    return the nominal quantity for
------------------------------------------------------------------------------------
IS
    v_result                    NUMBER;
    v_str_idx                   VARCHAR2(30);
BEGIN
    Pkg_App_Tools.p_dbg_start(Pkg_Lib.f_implode('$',p_oper_code,p_flag_range,p_flag_size,p_size_start,p_size_end));
    IF p_flag_size = -1 THEN
        v_str_idx   :=  p_oper_code||p_size_code;
        v_result    :=  Pkg_Lib.f_table_value(it_size_qty, v_str_idx, 0);
    ELSE
        v_result            :=  0;
        v_str_idx           :=  it_size_qty.FIRST;
        WHILE v_str_idx IS NOT NULL
        LOOP
            IF p_flag_range = 0  AND p_flag_size = 0 THEN
                -- return all the quantity
                IF v_str_idx LIKE p_oper_code||'%' THEN
                    v_result       :=  v_result + Pkg_Lib.f_table_value(it_size_qty, v_str_idx, 0);
                END IF;
            ELSE
                IF v_str_idx >= p_oper_code||p_size_start AND v_str_idx <= p_oper_code||p_size_end THEN
                    v_result       :=  v_result + Pkg_Lib.f_table_value(it_size_qty, v_str_idx, 0);
                END IF;
            END IF;
            v_str_idx       :=  it_size_qty.NEXT(v_str_idx);
        END LOOP;
    END IF;

    Pkg_App_Tools.P_Log('L','RETURN '||v_result,'F_GRP_GET_RANGE_QTY');

    RETURN v_result;
END;

/*********************************************************************************
    DDL: 21/02/2008  d Create procedure
/*********************************************************************************/
PROCEDURE p_grp_generate_bom    (   p_row_grp       WORK_GROUP%ROWTYPE,
                                    p_regenerate    BOOLEAN,
                                    p_commit        BOOLEAN,
                                    p_apply         BOOLEAN
                                )
----------------------------------------------------------------------------------
--  PURPOSE:    generate the GROUP BOM
--  PREREQ:     the VW_TRANSFER temporary structure must contain only the work order
--              to associate in the new group
--  INPUT:      ROW_GRP         =   group row
--              REGENERATE      =   if TRUE, will regenerate the BOM, if exists
--              COMMIT          =   if TRUE, will commit the transaction
--              APPLY           =   if FALSE, will insert the result in a temporary structure,
--                              not in the BOM_GRP table (Not functional)
----------------------------------------------------------------------------------
IS

    CURSOR C_GRP_ITM_SIZE   (   p_group_code VARCHAR2)
                            IS
                            SELECT      o.item_code, o.routing_code, d.size_code, SUM(d.qta) qty
                            FROM        WO_DETAIL   d
                            INNER JOIN  WORK_ORDER  o   ON o.idriga     = d.ref_wo
                            WHERE
                                EXISTS  (   SELECT  1
                                            FROM    WO_GROUP        wg
                                            WHERE   wg.org_code     = o.org_code
                                                AND wg.order_code   = o.order_code
                                                AND wg.group_code   = p_group_code
                                        )
                            GROUP BY    o.item_code, o.routing_code, d.size_code
                            ;

    CURSOR C_GRP_ROUT       (   p_ref_group    NUMBER)
                            IS
                            SELECT      r.*
                            FROM        GROUP_ROUTING   r
                            WHERE       r.ref_group     =   p_ref_group
                            ORDER BY    r.seq_no
                            ;

    CURSOR C_CHK_EXBOM      (   p_ref_group     NUMBER)
                            IS
                            SELECT      1
                            FROM        BOM_GROUP       bg
                            WHERE       bg.ref_group    =   p_ref_group
                            ;

    -- positions in BOM without consum operation
    CURSOR C_CHK_CONS_OPER  (   p_group_code    VARCHAR2)
                            IS
                            SELECT      o.org_code          ,
                                        o.item_code         ,
                                        b.child_code        ,
                                        MAX(i.description)  b_description
                            -----------------------------------------------------------------------
                            FROM        WO_GROUP        wg
                            INNER JOIN  WORK_ORDER      o   ON  o.org_code      =   wg.org_code
                                                            AND o.order_code    =   wg.order_code
                            INNER JOIN  BOM_STD         b   ON  b.org_code      =   o.org_code
                                                            AND b.father_code   =   o.item_code
                            INNER JOIN  ITEM            i   ON  i.org_code      =   b.org_code
                                                            AND i.item_code     =   b.child_code
                            -----------------------------------------------------------------------
                            WHERE       b.oper_code     IS NULL
                                AND     i.oper_code     IS NULL
                            -----------------------------------------------------------------------
                            GROUP BY    o.org_code          ,
                                        o.item_code         ,
                                        b.child_code
                            ;


--    v_row_grp               WORK_GROUP%ROWTYPE;
    it_bom                  Pkg_Rtype.ta_bom_group;
    it_size_qty             Pkg_Glb.typ_number_varchar;
    v_str_idx               VARCHAR2(30);
    v_idx                   PLS_INTEGER :=0;
    v_row_itm               ITEM%ROWTYPE;
    v_row_ctg               CAT_MAT_TYPE%ROWTYPE;
    v_row_grp_r             C_GRP_ROUT%ROWTYPE;
    v_prev_oper_code        VARCHAR2(30);
    v_row_chk_exbom         C_CHK_EXBOM%ROWTYPE;
    v_found                 BOOLEAN;
    v_test                  PLS_INTEGER;
    v_context               VARCHAR2(250);
    v_err                   VARCHAR2(250);
    v_row_wginfo            Pkg_Order.C_WG_INFO%ROWTYPE;
    v_tot_qty               NUMBER;
    v_nom_qty               NUMBER;

BEGIN

    IF p_regenerate THEN
        -- delete the old BOM
        DELETE
        FROM        BOM_GROUP
        WHERE       ref_group   =   p_row_grp.idriga
        ;
    ELSE
        -- check if the GROUP has already a BOM
        OPEN C_CHK_EXBOM(p_row_grp.idriga); FETCH C_CHK_EXBOM INTO v_test; v_found := C_CHK_EXBOM%FOUND; CLOSE C_CHK_EXBOM;
        IF v_found THEN Pkg_Lib.p_rae('Comanda '||p_row_grp.group_code||' are deja o norma de consum !!!'); END IF;
    END IF;

    -- check if all the FG of the GROUP have a BOM
    v_context       :=  'Exista produse fara norma de consum';
    FOR x IN C_GRP_WO_WITHOUT_BOM(p_row_grp.group_code)
    LOOP
        IF x.make_buy = 'P' AND 1=2 THEN
            Pkg_App_Tools.P_Log('M',x.item_code ||' (Bolla '||x.order_code||')',v_context);
        END IF;
    END LOOP;

    -- check if the BOM components
    v_context       :=  'Componente fara operatie de consum pe reteta Bolei sau in Anagrafica';
    FOR x IN C_CHK_CONS_OPER  (   p_row_grp.group_code)
    LOOP
        v_err   :=          '  Produs   --> '||RPAD(x.item_code,       20);
        v_err   :=  v_err|| '  Material --> '||RPAD(x.child_code,      20);
        v_err   :=  v_err|| '  Descr    --> '||x.b_description;
        Pkg_App_Tools.P_Log('M', v_err, v_context);
    END LOOP;
    Pkg_Lib.p_rae_m('B');

    Pkg_App_Tools.P_Log('L','Passed the checks!','');

    --
    OPEN  Pkg_Order.C_WG_INFO(p_row_grp.group_code);
    FETCH Pkg_Order.C_WG_INFO INTO v_row_wginfo; v_found :=  Pkg_Order.C_WG_INFO%FOUND;
    CLOSE Pkg_Order.C_WG_INFO;
    IF NOT v_found THEN
        Pkg_Lib.p_rae('Cantitatea pe Grupare este 0 !');
    END IF;
    v_tot_qty           :=  v_row_wginfo.nom_qty;
    Pkg_App_Tools.P_Log('L','Qta Request -> '||v_tot_qty,'');

    -- get the quantities for every SIZE + OPERATION in a PL/SQL table
    p_grp_get_size_qty  (   p_group_code    =>  p_row_grp.group_code,
                            p_oper_code     =>  '%',
                            it_size_qty     =>  it_size_qty);

    ----------------------------------------------------------------------------------------------------
    -- Insert the raw materials from the GROUP -> WORK_ORDER -> ITEM -> BOM for the Group routing operations
    ----------------------------------------------------------------------------------------------------
    v_idx := 0;
    FOR x IN Pkg_Order.C_GROUP_CONSUM(p_row_grp.idriga) LOOP

        -- recuperez item
        v_row_itm.item_code         :=  x.item_code;
        v_row_itm.org_code          :=  x.org_code;
        IF NOT Pkg_Get2.f_get_item_2(v_row_itm,-1) THEN
            Pkg_Lib.p_rae('Codul '||x.org_code||' / '||x.item_code||' nu exista');
        END IF;

        v_idx                       :=      v_idx +1;

        ---- aplic coeficientul de reducere -----------------------
        it_bom(v_idx).qta_demand    :=      x.qta * (100 - v_row_itm.scrap_perc)/100;

        -- compute the unit quantity
        v_nom_qty           :=  f_grp_get_range_qty (   it_size_qty     =>  it_size_qty,
                                                        p_oper_code     =>  x.oper_code,
                                                        p_size_code     =>  x.size_code,
                                                        p_size_start    =>  x.start_size,
                                                        p_size_end      =>  x.end_size,
                                                        p_flag_range    =>  v_row_itm.flag_range,
                                                        p_flag_size     =>  v_row_itm.flag_size);

        it_bom(v_idx).qta       :=  Pkg_Lib.f_round(    p_number    =>  it_bom(v_idx).qta_demand / v_nom_qty,
                                                        p_decimals  =>  4
                                                   );

        -- pun coeficientul pentru pierderi (mod normal rebutul neprevazut)
        it_bom(v_idx).scrap_perc    :=      v_row_itm.scrap_perc;

        it_bom(v_idx).ref_group     :=      p_row_grp.idriga;
        it_bom(v_idx).group_code    :=      p_row_grp.group_code;
        it_bom(v_idx).org_code      :=      p_row_grp.org_code;

        it_bom(v_idx).item_code     :=      x.item_code;
        it_bom(v_idx).size_code     :=      x.size_code;
        it_bom(v_idx).start_size    :=      x.start_size;
        it_bom(v_idx).end_size      :=      x.end_size;
        it_bom(v_idx).colour_code   :=      x.colour_code;
        it_bom(v_idx).note          :=      x.note;

        -- setez operatia de consum , are prioritate operatia setata la nivelul normei standard,
        -- daca nu exista iau din anagrafica item
        it_bom(v_idx).oper_code     :=      NVL(x.oper_code, v_row_itm.oper_code);

        -- setez magazia de prelevare (de fapt ar trebui sa fie identica cu magazia de receptie)
        -- are prioritate magazia de la nivelul anagrafica item, daca nu exista iau din categoria de materiale
        it_bom(v_idx).whs_supply    :=  v_row_itm.whs_stock;
        IF it_bom(v_idx).whs_supply IS NULL THEN
            NULL;
            v_row_ctg.categ_code    :=  v_row_itm.mat_type;
            IF NOT Pkg_Get2.f_get_cat_mat_type_2(v_row_ctg) THEN
                Pkg_Lib.p_rae('Codul de material '||v_row_itm.mat_type||' nu exista definit in sistem!');
            END IF;
            it_bom(v_idx).whs_supply :=  v_row_ctg.whs_stock;
        END IF;

        -- ERROR COLLECTOR
        IF  it_bom(v_idx).oper_code  IS NULL THEN
            Pkg_Err.p_err(x.item_code||' -- '||v_row_itm.description,'Materiale fara operatie de consum');
        END IF;
        IF  it_bom(v_idx).whs_supply IS NULL THEN
            Pkg_Err.p_err(x.item_code||'  -- '||v_row_itm.description,  'Materiale fara Magazie de receptie');
        END IF;

    END LOOP;

    Pkg_Err.p_rae;

    --------------------------------------------------------------------------------------------------------------
    -- INSERT the subassemblies (PF + OPER) if the operation is not the first in the routing
    --------------------------------------------------------------------------------------------------------------

    -- get the first operation from the Group Routing
    OPEN C_GRP_ROUT (p_row_grp.idriga); FETCH C_GRP_ROUT INTO v_row_grp_r; CLOSE C_GRP_ROUT;

    FOR x IN C_GRP_ITM_SIZE(p_row_grp.group_code)
    LOOP

        -- get the previous operation
        v_prev_oper_code        :=  f_get_routing_prev_oper(x.routing_code, v_row_grp_r.oper_code);

        -- generate the subassembly lines IF the previous operation exists !!!
        IF NOT v_prev_oper_code IS NULL THEN
            v_idx       := v_idx + 1;

            it_bom(v_idx).qta_demand    :=  x.qty;
            it_bom(v_idx).qta           :=  1   ;
            it_bom(v_idx).scrap_perc    :=  0   ;

            it_bom(v_idx).ref_group     :=  p_row_grp.idriga;
            it_bom(v_idx).group_code    :=  p_row_grp.group_code;
            it_bom(v_idx).org_code      :=  p_row_grp.org_code;
            it_bom(v_idx).item_code     :=  x.item_code;
            it_bom(v_idx).oper_code_item:=  f_get_routing_prev_oper(x.routing_code, v_row_grp_r.oper_code);
            it_bom(v_idx).size_code     :=  x.size_code;
            it_bom(v_idx).start_size    :=  '';
            it_bom(v_idx).end_size      :=  '';
            it_bom(v_idx).colour_code   :=  '';
            it_bom(v_idx).oper_code     :=  v_row_grp_r.oper_code;

            it_bom(v_idx).whs_supply    :=  'MPLOHN'; -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        END IF;
    END LOOP;

    Pkg_Iud.p_bom_group_miud    ('I',it_bom     );

    IF p_commit THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_commit THEN ROLLBACK; END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/*********************************************************************************
    DDL: 25/02/2008  d Create procedure

/*********************************************************************************/
PROCEDURE p_grp_generate_bom_undo   (   p_row_grp       WORK_GROUP%ROWTYPE,
                                        p_commit        BOOLEAN
                                    )
-----------------------------------------------------------------------------------
--  PURPOSE:    UNDO the generate BOM action; makes the checks for this
--  INPUT       COMMIT:     if TRUE, commit the transaction
--              ROW_GRP:    Group line for which to cancel the BOM
-----------------------------------------------------------------------------------
IS

    CURSOR C_GRP_BOM    (   p_ref_group    NUMBER)
                        IS
                        SELECT      *
                        FROM        BOM_GROUP
                        WHERE       ref_group       =   p_ref_group
                        ;

    v_row_grp   BOM_GROUP%ROWTYPE;

BEGIN
    -- possible, some checks .... no material was already isued ??????


    -- deleting from BOM
    FOR x IN C_GRP_BOM  (p_row_grp.idriga)
    LOOP
        v_row_grp       :=  x;
        Pkg_Iud.p_bom_group_iud('D', v_row_grp);
    END LOOP;

    IF p_commit THEN COMMIT; END IF;
END;

/*********************************************************************************
    DDL: 21/02/2008  d Create procedure

/*********************************************************************************/
PROCEDURE p_grp_generate_bom    (   p_group_code    WORK_GROUP.group_code%TYPE,
                                    p_regenerate    BOOLEAN,
                                    p_commit        BOOLEAN,
                                    p_apply         BOOLEAN
                                )
----------------------------------------------------------------------------------
--  PURPOSE:    generate the GROUP BOM
--  PREREQ:     the VW_TRANSFER temporary structure must contain only the work order
--              to associate in the new group
--  INPUT:      GRP_CODE        = group code
--              COMMIT          = if TRUE, will commit the transaction
--              APPLY           = if FALSE, will insert the result in a temporary structure,
--                              not in the BOM_GRP table
----------------------------------------------------------------------------------
IS
    v_row_grp       WORK_GROUP%ROWTYPE;
BEGIN
    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp,0) THEN Pkg_Lib.p_rae('Gruparea '||p_group_code||' nu exista!!!'); END IF;
    p_grp_generate_bom(v_row_grp, p_regenerate, p_commit, p_apply);

END;


/*********************************************************************************************************
    DDL:    24/02/2008 d moved here from Pkg_Ord

/*********************************************************************************************************/
PROCEDURE p_grp_authorize   (   p_idriga WORK_GROUP.idriga%TYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    SET a Group in the (A)uthorized status; useful in some reports;
--              This action succeeds only if the Group is in (I)nitial status, not launched, finished, etc
--              and if all the materials for the Group exists in the warehouse
-----------------------------------------------------------------------------------------------------------
IS
    v_row_grp    WORK_GROUP%ROWTYPE;
BEGIN
    IF p_idriga IS NULL THEN Pkg_Lib.p_rae('Nu sunteti pozitionat pe o comanda valida !!!'); END IF;

    v_row_grp.idriga := p_idriga;
    IF Pkg_Get.f_get_work_group(v_row_grp, -1) THEN
        Pkg_Lib.p_rae('Nedefinit: '||p_idriga);
    END IF;

    IF v_row_grp.status <> 'I' THEN
        Pkg_Lib.p_rae('Grupul nu este in starea corespunzatoare pentru autorizare (deja autorizata/lansata/terminata) !!!');
    END IF;

    IF Pkg_Order.f_exists_material_for_group(v_row_grp.idriga,'X') = 0 THEN
        Pkg_Lib.p_rae('Nu exista materiale disponibile pentru toate componentele comenzii !!! Verificati cu raportul de detaliu !!!');
    END IF;

    v_row_grp.status := 'A';

    Pkg_Iud.p_work_group_iud('U',v_row_grp);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************************
    DDL:    24/02/2008 d moved here from Pkg_Ord

/*********************************************************************************************************/
PROCEDURE p_grp_authorize_undo  (   p_idriga WORK_GROUP.idriga%TYPE )
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    SET a Group in the (I)nitial status if it was in (A)uthorized
-----------------------------------------------------------------------------------------------------------
IS
    v_row_grp  WORK_GROUP%ROWTYPE;
BEGIN

    IF p_idriga IS NULL THEN Pkg_Lib.p_rae('Nu sunteti pozitionat pe o comanda valida !!!'); END IF;

    v_row_grp.idriga  := p_idriga;
    Pkg_Get.p_get_work_group(v_row_grp,-1);

    IF v_row_grp.status <> 'A' THEN
        Pkg_Lib.p_rae('Comanda nu este in stare corecta (A - autorizata), este in starea '||v_row_grp.status||' !!!');
    END IF;
    -- pun inapoi in initiata
    v_row_grp.status := 'I';
    Pkg_Iud.p_work_group_iud('U',v_row_grp);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************************
    DDL:    24/02/2008 d moved here from Pkg_Ord

/*********************************************************************************************************/
FUNCTION f_demand_for_item(     p_org_code      VARCHAR2,
                                p_item_code     VARCHAR2,
                                p_season_code   VARCHAR2,
                                p_size_code     VARCHAR2,
                                p_colour_code   VARCHAR2,
                                p_type          VARCHAR2) RETURN NUMBER
IS
--------------------------------------------
-- p_type =
--     L -- necesar nestins la cele lansate
--    A -- necesar pentru cele autorizate
--              X -- ambele 2
--------------------------------------------

    -- get the total qty still needed for an item, for the launched groups
    CURSOR C_DEMAND_LAUNCHED(   p_org_code      VARCHAR2,
                                p_item_code     VARCHAR2,
                                p_season_code   VARCHAR2,
                                p_size_code     VARCHAR2,
                                p_colour_code   VARCHAR2 )
                IS
                SELECT      SUM(GREATEST(b.qta_demand - b.qta_picked,0)) qta
                FROM
                            WORK_GROUP          g,
                            BOM_GROUP           b
                WHERE
                            g.idriga            =   b.ref_group
                        AND g.status            =   'L'
                        AND b.item_code         =   p_item_code
                        AND g.org_code          =   p_org_code
                        AND g.season_code       =   p_season_code
                        -- selectie pe item size culoare
                        AND NVL(b.size_code,Pkg_Glb.c_rn ) = NVL(p_size_code,Pkg_Glb.c_rn )
                        AND NVL(b.colour_code,Pkg_Glb.c_rn)= NVL(p_colour_code,Pkg_Glb.c_rn )
                ;

    -- get the total qty  needed for an item, for the authorized groups
    CURSOR C_DEMAND_AUTORIZED   (   p_org_code      VARCHAR2,
                                    p_item_code     VARCHAR2,
                                    p_season_code   VARCHAR2,
                                    p_size_code     VARCHAR2,
                                    p_colour_code VARCHAR2 )
                IS
                SELECT      SUM(b.qta * d.qta)
                FROM
                            WORK_GROUP        g ,
                            WORK_ORDER      w,
                            WO_DETAIL       d,
                            BOM_STD         b,
                            ITEM            i
                WHERE
                            g.group_code    =   w.group_code
                        AND w.item_code     =   b.father_code
                        AND w.org_code        =   b.org_code
                        AND w.idriga        =   d.ref_wo
                        AND b.child_code    =   i.item_code
                        AND b.org_code      =   i.org_code
                        AND g.org_code      =   p_org_code
                        AND g.season_code   =   p_season_code
                        AND g.status        =   'A' -- grupurile autorizate
                        AND d.size_code     BETWEEN   NVL(NVL(b.start_size,i.start_size)  ,  Pkg_Glb.C_SIZE_MIN   )
                                                      AND
                                                      NVL(NVL(b.end_size,i.end_size)      , Pkg_Glb.C_SIZE_MAX    )
                        -- selectie pe item size culoare
                        AND b.child_code     =  p_item_code
                        AND (
                                p_size_code     IS NULL
                                OR
                                d.size_code     =   p_size_code
                            )
                        AND NVL(b.colour_code,Pkg_Glb.c_rn)     =   NVL(p_colour_code,Pkg_Glb.c_rn )
                        ;

    v_result        NUMBER;
    v_qty_auth      NUMBER;
    v_qty_laun      NUMBER;

BEGIN

    CASE p_type
        WHEN 'L' THEN   OPEN  C_DEMAND_LAUNCHED(p_org_code,p_item_code,p_season_code,p_size_code,p_colour_code);
                        FETCH C_DEMAND_LAUNCHED INTO v_qty_laun;
                        CLOSE C_DEMAND_LAUNCHED;
                        v_result    := NVL(v_qty_laun, 0);
        WHEN 'A' THEN   OPEN  C_DEMAND_AUTORIZED(p_org_code,p_item_code,p_season_code,p_size_code,p_colour_code);
                        FETCH C_DEMAND_AUTORIZED INTO v_qty_auth;
                        CLOSE C_DEMAND_AUTORIZED;
                        v_result    := NVL(v_qty_auth, 0);
        WHEN 'X' THEN   OPEN  C_DEMAND_LAUNCHED(p_org_code,p_item_code,p_season_code,p_size_code,p_colour_code);
                        FETCH C_DEMAND_LAUNCHED INTO v_qty_laun;
                        CLOSE C_DEMAND_LAUNCHED;

                        OPEN  C_DEMAND_AUTORIZED(p_org_code,p_item_code,p_season_code,p_size_code,p_colour_code);
                        FETCH C_DEMAND_AUTORIZED INTO v_qty_auth;
                        CLOSE C_DEMAND_AUTORIZED;
                        v_result    := NVL(v_qty_auth, 0) + NVL(v_qty_laun, 0);
    END CASE;

    v_result    := v_result;
    RETURN      v_result;
END;


/*********************************************************************************************************
    DDL:    24/02/2008 d moved here from Pkg_Ord

/*********************************************************************************************************/
FUNCTION f_exists_material_for_group    (   p_idriga    WO_GROUP.idriga%TYPE,
                                            p_type      VARCHAR2
                                        )
                                        RETURN INTEGER
----------------------------------------------------------------------------------------------------------
--  PURPOSE:    checks if for a GROUP exists stocks for all the GROUP BOM components
--  INPUT:      IDRIGA  = group's line identifier
--              TYPE    =
--  RETURN:     -1  = exists enough material
--              0   = not enough stock
----------------------------------------------------------------------------------------------------------
IS
    PRAGMA autonomous_transaction;

    TYPE it_type        IS TABLE OF VW_RAP_CHECK_MATERIAL%ROWTYPE INDEX BY BINARY_INTEGER;
    it                  it_type;
    v_idx               PLS_INTEGER := 0;
    v_rezultat          INTEGER := -1;
    v_row_grp           WORK_GROUP%ROWTYPE;
    v_stoc              Pkg_Mov.typ_stoc;
    C_SEGMENT_CODE      VARCHAR2(32000) :=  'VW_RAP_CHECK_MATERIAL';

BEGIN

   v_row_grp.idriga := p_idriga;
   Pkg_Get.p_get_work_group(v_row_grp);

   DELETE FROM VW_RAP_CHECK_MATERIAL;

   FOR x IN Pkg_Cur.C_GROUP_CONSUM(p_idriga) LOOP

       v_idx      := v_idx + 1;

       it(v_idx).segment_code       :=      C_SEGMENT_CODE;
       it(v_idx).org_code           :=      v_row_grp.org_code;
       it(v_idx).item_code          :=      x.item_code;
       it(v_idx).size_code          :=      x.size_code;
       it(v_idx).colour_code        :=      x.colour_code;
       it(v_idx).demand_current     :=      x.qta;
       it(v_idx).season_code        :=      v_row_grp.season_code;

       it(v_idx).demand_launched  := Pkg_Order.f_demand_for_item(
                                                               p_org_code   =>   v_row_grp.org_code,
                                                               p_item_code  =>   x.item_code     ,
                                                               p_season_code=>   v_row_grp.season_code,
                                                               p_size_code  =>   x.size_code     ,
                                                               p_colour_code=>   x.colour_code   ,
                                                               p_type       =>   'L');

       IF p_type = 'L' THEN
           it(v_idx).demand_autorized := 0;
       ELSE
           it(v_idx).demand_autorized := Pkg_Order.f_demand_for_item(
                                                                   p_org_code   =>   v_row_grp.org_code,
                                                                   p_item_code  =>   x.item_code     ,
                                                                   p_season_code=>   v_row_grp.season_code,
                                                                   p_size_code  =>   x.size_code     ,
                                                                   p_colour_code=>   x.colour_code   ,
                                                                   p_type       =>   'A');
       END IF;

       it(v_idx).demand_all  := it(v_idx).demand_current
                                + it(v_idx).demand_autorized
                                + it(v_idx).demand_launched ;

       -------------------------------------------------
       -- pun cantitatea on hand in magazile pentru care FLAG_MRP = -1
       -------------------------------------------------
        Pkg_Mov.p_item_stoc( it_stoc        =>  v_stoc,
                             p_item         =>  x.item_code,
                             p_org_code     =>  x.org_code,
                             p_whs_code     =>  NULL, -- toate magaziile
                             p_season_code  =>  v_row_grp.season_code,
                             p_size_code    =>  x.size_code,
                             p_colour_code  =>  x.colour_code,
                             p_oper_code    =>  NULL  -- nu ma intereseaza
                            );


       it(v_idx).qta_on_hand := Pkg_Mov.f_item_stoc(
                                    it_stoc         =>  v_stoc,
                                    p_whs_code      =>  'MPCPC',
                                    p_season_code   =>  v_row_grp.season_code,
                                    p_colour_code   =>  x.colour_code,
                                    p_size_code     =>  x.size_code
                                    );

       it(v_idx).qta_on_hand :=     it(v_idx).qta_on_hand
                                    +   Pkg_Mov.f_item_stoc(
                                        it_stoc         =>  v_stoc,
                                        p_whs_code      =>  'MPTLP',
                                        p_season_code   =>  v_row_grp.season_code,
                                        p_colour_code   =>  x.colour_code,
                                        p_size_code     =>  x.size_code
                                        );

       it(v_idx).qta_tranzit :=        Pkg_Mov.f_item_stoc(
                                        it_stoc         =>  v_stoc,
                                        p_whs_code      =>  'TRZ',
                                        p_season_code   =>  v_row_grp.season_code,
                                        p_colour_code   =>  x.colour_code,
                                        p_size_code     =>  x.size_code
                                        );

       -------------------------------------------------
       -- daca exista pozitie unde total necesar > cantitatea disponibila setez alertul
       -------------------------------------------------
       it(v_idx).flag_alert := -1;
       IF it(v_idx).demand_all > it(v_idx).qta_on_hand + it(v_idx).qta_tranzit THEN
           it(v_idx).flag_alert :=  0;
           v_rezultat     :=  0;
       END IF;
    END LOOP;

    IF v_idx = 0 THEN
        Pkg_Lib.p_rae('Nu exista norma de consum pentru nici o bola din grupare / gruparea nu a fost asociata cu bole !!!');
    END IF;

    IF it.COUNT > 0 THEN FORALL i IN 1..it.COUNT INSERT INTO VW_RAP_CHECK_MATERIAL VALUES it(i); END IF;

    COMMIT;

    RETURN v_rezultat;

END;

/*********************************************************************************************************
    DDL:    24/02/2008 d moved here from Pkg_Ord

/*********************************************************************************************************/
PROCEDURE p_ord_duplicate           (   p_idriga        NUMBER,
                                        p_order_code    VARCHAR2,
                                        p_flag_detail   VARCHAR2
                                    )
-------------------------------------------------------------------------------------------------------
--  PURPOSE:    makes a new work_order, starting from an existing one
--              copies the order details, too
--  INPUT:      IDRIGA      =   line identifier for the source work order
--              ORDER_CODE  =   code for the new order
--              FLAG_DETAIL =   if "Y" means the porcedure must copy the source WORK ORDER details, too
-------------------------------------------------------------------------------------------------------
IS
    v_row_old  WORK_ORDER%ROWTYPE;
    v_row_wrk  WORK_ORDER%ROWTYPE;
BEGIN

    IF p_idriga     IS NULL THEN Pkg_Lib.p_rae('Nu sunteti pozitionati pe o bola valida !!!'); END IF;
    IF p_order_code IS NULL THEN Pkg_Lib.p_rae('Nu ati precizat numarul noii bole !!!'); END IF;

    v_row_old.idriga  := p_idriga;
    Pkg_Get.p_get_work_order(v_row_old);

    v_row_wrk              := v_row_old;
    v_row_wrk.idriga       := NULL;
    v_row_wrk.order_code   := p_order_code;
    v_row_wrk.status       := 'I';
    v_row_wrk.date_create  := TRUNC(SYSDATE);
    v_row_wrk.date_launch  := NULL;
    v_row_wrk.date_complet := NULL;
    v_row_wrk.date_client  := NULL;
    v_row_wrk.group_code   := NULL;

    Pkg_Iud.p_work_order_iud('I',v_row_wrk);
    v_row_wrk.idriga := Pkg_Lib.f_read_pk();

    -- copy details
    IF p_flag_detail = 'Y' THEN
        INSERT INTO WO_DETAIL(REF_WO, SIZE_CODE, QTA)
            SELECT  v_row_wrk.idriga, size_code, qta
            FROM    WO_DETAIL
            WHERE   ref_wo = v_row_old.idriga;
    END IF;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************************
    DDL:    24/02/2008  d moved here from Pkg_Ord
                        d renamed from p_close_wo_group to p_grp_close

/*********************************************************************************************************/
PROCEDURE p_grp_close       (   p_idriga    WO_GROUP.idriga%TYPE,
                                p_force     VARCHAR2)
----------------------------------------------------------------------------------------------------------
--  PURPOSE:    set the group to (C)losed status
--  INPUT:      IDRIGA  = Group line identifier
--              FORCE   = if YES, close the GROUP even if not all the BOM quantities were picked
----------------------------------------------------------------------------------------------------------
IS
    v_row_grp               WORK_GROUP%ROWTYPE;
    v_row_dem               Pkg_Cur.C_SIT_DEMAND_GROUP%ROWTYPE;
    v_demand_not_issued     VARCHAR2(32000);
    v_errstr                VARCHAR2(2000);

BEGIN

    -- securitate
    Pkg_App_Secur.p_test_grant('CLOSE_GRP');

    IF p_idriga IS NULL THEN
        Pkg_Lib.p_rae('Nu sunteti pozitionat pe o comanda valida !!!');
    END IF;

    v_row_grp.idriga  := p_idriga;
    Pkg_Get.p_get_work_group(v_row_grp,-1);

    -- only the WORK GROUPS in (L)aunched status can be closed
    IF v_row_grp.status <> 'L' THEN
        Pkg_Lib.p_rae('Comanda nu este in stare corecta (L - lansata), este in starea '||v_row_grp.status||' !!!');
    END IF;

    -- verific daca exista material nepredat scriptic pe comanda:
    FOR x IN Pkg_Cur.C_SIT_DEMAND_GROUP(v_row_grp.idriga) LOOP
        x.qta_demand_nominal    :=  Pkg_Lib.f_round(x.qta_demand_nominal, 3);
        x.qta_picked            :=  Pkg_Lib.f_round(x.qta_picked,3);

        IF  x.qta_demand_nominal > x.qta_picked THEN
            v_errstr := v_errstr || x.item_code ||' - cantit : ' ||TO_CHAR(x.qta_demand_nominal - x.qta_picked )|| Pkg_Glb.C_NL;
        END IF;
    END LOOP;

    -- daca nu forteaza sa inchiede dau mesaj daca exista materiale nepredate
    IF NOT v_errstr IS NULL THEN Pkg_App_Tools.P_Log('M', v_errstr, 'Materiale la care nu s-a predat toata cantitatea'); END IF;
    IF p_force      IS NULL THEN Pkg_Lib.p_rae_m(); END IF;

    -- pun in starea inchisa
    v_row_grp.status := 'T';
    Pkg_Iud.p_work_group_iud('U',v_row_grp);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;




/*********************************************************************************************************
    DDL:    24/02/2008 d Create procedure

/*********************************************************************************************************/
PROCEDURE p_grp_associate_undo      (   p_group_code    VARCHAR2,
                                        p_flag_commit   BOOLEAN )
----------------------------------------------------------------------------------------------------------------------
--  PURPOSE:    cancel a work order association, if still possible (not launched)
--  INPUT:      GROUP_CODE  = group code
----------------------------------------------------------------------------------------------------------------------
IS
    v_row_grp       WORK_GROUP%ROWTYPE;
BEGIN

    -- get the WORK_GROUP
    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp,0) THEN
        Pkg_Lib.p_rae('Comanda '||p_group_code||' nu exista!');
    END IF;

    -- cannot cancel a WORK GROUP if it's not in status I(nitial)
    IF v_row_grp.status <> 'I' THEN
        Pkg_Lib.p_rae('Pentru a anula o grupare de bolle, aceasta trebuie sa fie in stare I !!!');
    END IF;

    -- cancel the link between the group and the work_orders
    DELETE      FROM        WO_GROUP
                WHERE       group_code  =   p_group_code
                ;

    -- cancel the Group ROUTING
    DELETE      FROM        GROUP_ROUTING
                WHERE       group_code  =   p_group_code
                ;

    -- cancel the Group BOM 
    DELETE      FROM        BOM_GROUP
                WHERE       group_code  =   p_group_code
                ;

                
    -- anulate the group
    Pkg_Iud.p_work_group_iud('D',v_row_grp);

    IF p_flag_commit THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_flag_commit THEN ROLLBACK; END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;



/*********************************************************************************************************
    DDL:    25/02/2008 d Create procedure

/*********************************************************************************************************/
PROCEDURE p_grp_launch      (   p_group_code    VARCHAR2,
                                p_flag_commit   BOOLEAN)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    launch the work group, generating its BOM
--  INPUT:      GROUP CODE
-----------------------------------------------------------------------------------------------------------
IS

    v_row_grp       WORK_GROUP%ROWTYPE;

BEGIN

    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp,0) THEN
        Pkg_Lib.p_rae(p_group_code || ' nu exista definit in sistem!');
    END IF;

    -- securitate
--    Pkg_App_Secur.p_test_grant('LAUNCH_GRP');

    -- daca comanda a fost deja lansata nu se mai poate inca o data !!
    IF v_row_grp.status NOT IN ('V') THEN
        Pkg_Lib.p_rae('Comanda NU SE POATE LANSA, deoarece este in starea '||f_grp_get_status_description (v_row_grp.status));
    END IF;

    -- set the (L)aunched status
    v_row_grp.status       :=  'L';
    v_row_grp.date_launch  :=  TRUNC(SYSDATE);

    Pkg_Iud.p_work_group_iud      ('U',v_row_grp);

    IF p_flag_commit THEN COMMIT;END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_flag_commit THEN ROLLBACK; END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;



/*********************************************************************************************************
    DDL:    25/02/2008 d Create procedure

/*********************************************************************************************************/
PROCEDURE p_grp_launch_undo         (   p_group_code    VARCHAR2,
                                        p_flag_commit   BOOLEAN)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    launch the work group, generating its BOM
--  INPUT:      GROUP CODE
-----------------------------------------------------------------------------------------------------------
IS
    CURSOR C_CHK_PRD        IS
                            SELECT      *
                            FROM        VW_PREP_GRP_DPR_QTY
                            ;

    v_row_grp               WORK_GROUP%ROWTYPE;
    v_context               VARCHAR2(250);

BEGIN

    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp,0) THEN
        Pkg_Lib.p_rae('eroare');
    END IF;

    -- securitate
--    Pkg_App_Secur.p_test_grant('LAUNCH_GRP');

    -- the Group is not launched
    IF v_row_grp.status NOT IN ('L') THEN
        Pkg_Lib.p_rae('Comanda '|| v_row_grp.group_code ||' este in starea '||f_grp_get_status_description (v_row_grp.status));
    END IF;

    v_context   :=  'Sunt declaratii de productie efectuate pe comanda';
    -- check if there are PROD declarations on GROUP
    Pkg_Prod.p_prep_grp_dpr_qty     (   p_group_code    =>  v_row_grp.group_code,
                                        p_oper_code     =>  NULL);
    FOR x IN C_CHK_PRD
    LOOP
        Pkg_App_Tools.P_Log('M','Operatia: '||x.oper_code||' Marime:'||x.size_code||' Cantitate:'||x.dpr_qty,v_context);
    END LOOP;
    Pkg_Lib.p_rae_m('B');

    v_row_grp.status       :=  'V';
    v_row_grp.date_launch  :=  NULL;

    Pkg_Iud.p_work_group_iud      ('U',v_row_grp);

    IF p_flag_commit THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_flag_commit THEN ROLLBACK;END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************************
    DDL:    10/06/2008 d Create procedure

/*********************************************************************************************************/
PROCEDURE p_grp_validate    (   p_group_code    VARCHAR2,
                                p_flag_commit   BOOLEAN)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    validate the work group, generating its BOM + ROUT
--  INPUT:      GROUP CODE
-----------------------------------------------------------------------------------------------------------
IS

    CURSOR  C_CHK_NODET     (   p_group_code    VARCHAR2)
                            IS
                            SELECT      DISTINCT wg.order_code
                            --------------------------------------------------------------------
                            FROM        WO_GROUP    wg
                            INNER JOIN  WORK_ORDER  o   ON  o.org_code      =   wg.org_code
                                                        AND o.order_code    =   wg.order_code
                            LEFT JOIN   WO_DETAIL   d   ON  d.ref_wo        =   o.idriga
                            ---------------------------------------------------------------------
                            WHERE       wg.group_code   =   p_group_code
                                AND     d.qta IS NULL
                            ;

    v_row_grp       WORK_GROUP%ROWTYPE;

BEGIN

    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp,0) THEN
        Pkg_Lib.p_rae(p_group_code || ' nu exista definit in sistem!');
    END IF;

    -- securitate
--    Pkg_App_Secur.p_test_grant('LAUNCH_GRP');

    -- daca comanda a fost deja lansata nu se mai poate inca o data !!
    IF v_row_grp.status NOT IN ('I','A') THEN
        Pkg_Lib.p_rae('Comanda NU SE POATE VALIDA deoarece este in starea '||f_grp_get_status_description (v_row_grp.status));
    END IF;

    -- check if all the orders have details
    FOR x IN C_CHK_NODET (p_group_code)
    LOOP
        Pkg_App_Tools.P_Log('M','Bola '||x.order_code, 'Bole fara detaliere pe marimi !');
    END LOOP;
    Pkg_Lib.p_rae_m('B');

    -- generate the GROUP BOM
    Pkg_Order.p_grp_generate_bom(   p_row_grp   =>  v_row_grp,
                                    p_regenerate=>  TRUE,
                                    p_commit    =>  FALSE    ,
                                    p_apply     =>  TRUE);

    -- set the (L)aunched status
    v_row_grp.status            :=  'V';
    Pkg_Iud.p_work_group_iud    ('U',v_row_grp);

    IF p_flag_commit THEN COMMIT;END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_flag_commit THEN ROLLBACK; END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************************
    DDL:    10/06/2008 d Create procedure

/*********************************************************************************************************/
PROCEDURE p_grp_validate_undo       (   p_group_code    VARCHAR2,
                                        p_flag_commit   BOOLEAN)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    UNDO the Validate action on GROUP
--  INPUT:      GROUP_CODE
-----------------------------------------------------------------------------------------------------------
IS

    v_row_grp               WORK_GROUP%ROWTYPE;
    v_context               VARCHAR2(250);

BEGIN

    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp,0) THEN
        Pkg_Lib.p_rae('eroare');
    END IF;

    -- securitate
--    Pkg_App_Secur.p_test_grant('LAUNCH_GRP');

    -- the Group is not launched
    IF v_row_grp.status NOT IN ('V') THEN
        Pkg_Lib.p_rae('Comanda '|| v_row_grp.group_code ||' este in starea '||f_grp_get_status_description (v_row_grp.status));
    END IF;

    p_grp_generate_bom_undo(v_row_grp,FALSE);

    v_row_grp.status       :=  'I';
    v_row_grp.date_launch  :=  NULL;

    Pkg_Iud.p_work_group_iud      ('U',v_row_grp);

    IF p_flag_commit THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_flag_commit THEN ROLLBACK;END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************************
    DDL:    25/02/2008 d Create procedure
            14/01/2008 d check DPR only on ROW.oper_code
/*********************************************************************************************************/
PROCEDURE p_group_routing_iud   (   p_tip       VARCHAR2,
                                    p_row       GROUP_ROUTING%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on GROUP_ROUTING table
-----------------------------------------------------------------------------------------------------------
IS

    CURSOR C_EX_DPR     (p_group_code   VARCHAR2, p_oper_code VARCHAR2)
                        IS
                        SELECT      1
                        FROM        WHS_TRN_DETAIL  d
                        INNER JOIN  WHS_TRN         h   ON  h.idriga = d.ref_trn
                        WHERE       d.reason_code   =   Pkg_Glb.C_P_IPRDSP
                            AND     d.group_code    =   p_group_code
                            AND     d.oper_code_item=   p_oper_code
                            AND     h.flag_storno   =   'N'
                        ;

    v_row_old       GROUP_ROUTING%ROWTYPE;
    v_row           GROUP_ROUTING%ROWTYPE;
    v_row_wc        WORKCENTER%ROWTYPE;
    v_test          PLS_INTEGER;
    v_found         BOOLEAN;

BEGIN

    -- check if there are DPRs for the work_group
    OPEN    C_EX_DPR    (p_row.group_code, p_row.oper_code);
    FETCH   C_EX_DPR    INTO    v_test;
    v_found :=  C_EX_DPR%FOUND;
    CLOSE   C_EX_DPR;
    IF v_found THEN
        Pkg_App_Tools.P_Log(    'M',
                                'Exista declaratii de productie pe aceasta faza a comenzii',
                                'Nu se poate modifica routing-ul comenzii');
    END IF;
    Pkg_Lib.p_rae_m('B');

    CASE p_tip
        WHEN 'U' THEN   v_row               :=  p_row;
                        v_row_old.idriga    :=  p_row.idriga;
                        Pkg_Get.p_get_group_routing(v_row_old);
                        IF Pkg_Lib.f_mod_c( v_row_old.workcenter_code, p_row.workcenter_code) THEN
                            v_row_wc.workcenter_code    :=  p_row.workcenter_code;
                            IF NOT Pkg_Get2.f_get_workcenter_2(v_row_wc) THEN NULL; END IF;
                            v_row.whs_cons              :=  v_row_wc.whs_code;
                            v_row.whs_dest              :=  v_row_wc.whs_code;

                        END IF;

        ELSE
                        Pkg_Lib.p_rae('Nu se pot face stergeri sau adaugari manuale de linii in routing-ul Gruparii !');
    END CASE;

    Pkg_Iud.p_group_routing_iud(p_tip, v_row);

--    Pkg_App_Secur.p_test_table_iud(p_tip, 'GROUP_ROUTING');

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************************
    DDL:    25/02/2008 d Create procedure

/*********************************************************************************************************/
PROCEDURE p_bom_group_blo       (   p_tip           VARCHAR2,
                                    p_row IN OUT    BOM_GROUP%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on BOM_GROUP table
-----------------------------------------------------------------------------------------------------------
IS

    CURSOR C_EX_DPR     (p_group_code   VARCHAR2)
                        IS
                        SELECT      1
                        FROM        WHS_TRN_DETAIL  d
                        WHERE       reason_code     =   Pkg_Glb.C_P_IPRDSP
                            AND     d.group_code    =   p_group_code
                        ;

    v_row_old           BOM_GROUP%ROWTYPE;
    v_row_grp           WORK_GROUP%ROWTYPE;
    v_context           VARCHAR2(250);
    v_row_itm           ITEM%ROWTYPE;
    it_size_qty         Pkg_Glb.typ_number_varchar;
    v_nom_qty           NUMBER;
    v_test              PLS_INTEGER;
    v_found             BOOLEAN;

BEGIN

    -- get the WORK_GROUP
    v_row_grp.idriga    :=  p_row.ref_group;
    Pkg_Get.p_get_work_group(v_row_grp);

    v_row_itm.org_code  :=  p_row.org_code;
    v_row_itm.item_code :=  p_row.item_code;
    IF NOT Pkg_Get2.f_get_item_2(v_row_itm) THEN
        Pkg_Lib.p_rae('Codul '||p_row.org_code||'/'||p_row.item_code||' nu este definit in sistem!');
    END IF;

    -- default values
    IF v_row_itm.flag_range = -1 THEN
        p_row.start_size    :=  NVL(p_row.start_size,   v_row_itm.start_size);
        p_row.end_size      :=  NVL(p_row.end_size,     v_row_itm.end_size);
    END IF;

    -- //// CHECK ZONE

    -- get the quantities for every SIZE + OPERATION in a PL/SQL table
    p_grp_get_size_qty  (   p_group_code    =>  v_row_grp.group_code,
                            p_oper_code     =>  p_row.oper_code,
                            it_size_qty     =>  it_size_qty);

    v_nom_qty           :=  f_grp_get_range_qty (   it_size_qty     =>  it_size_qty,
                                                    p_oper_code     =>  p_row.oper_code,
                                                    p_size_code     =>  p_row.size_code,
                                                    p_size_start    =>  p_row.start_size,
                                                    p_size_end      =>  p_row.end_size,
                                                    p_flag_range    =>  v_row_itm.flag_range,
                                                    p_flag_size     =>  v_row_itm.flag_size);


    IF p_tip IN ('U') THEN
        v_row_old.idriga    :=  p_row.idriga;
        Pkg_Get.p_get_bom_group(v_row_old);
    END IF;

    v_context   :=  'Nu se poate modifica reteta !';

    -- check if the work_group is launched; if NOT, cannot modify its BOM
    IF v_row_grp.status NOT IN ('V','L') THEN
        Pkg_App_Tools.P_Log(    'M',
                                'Gruparea NU este in stare LANSATA !',
                                v_context);
    END IF;

    -- 2008.06.07 -- deactivate , we have to let them
    -- to modify also if there are declaration
    -- check if there are DPRs for the work_group
--    OPEN    C_EX_DPR    (v_row_grp.group_code);
--    FETCH   C_EX_DPR    INTO    v_test;
--    v_found :=  C_EX_DPR%FOUND;
--    CLOSE   C_EX_DPR;
--    IF v_found THEN
--        Pkg_App_Tools.P_Log(    'M',
--                                'Exista declaratii de productie pe comanda',
--                                v_context);
--    END IF;

    v_context   :=  'Date lipsa';
    IF p_row.item_code IS NULL THEN
        Pkg_App_Tools.P_Log('M','Nu ati precizat CODUL materialului !',v_context);
    END IF;
    IF p_row.qta_demand IS NULL THEN
        Pkg_App_Tools.P_Log('M','Nu ati precizat Cantitatea !',v_context);
    END IF;
    IF v_row_itm.flag_colour = -1 AND p_row.colour_code IS NULL THEN
        Pkg_App_Tools.P_Log('M','Codul trebuie gestionat pe CULOARE !',v_context);
    END IF;
    IF v_row_itm.flag_size = -1 AND p_row.size_code IS NULL THEN
        Pkg_App_Tools.P_Log('M','Codul trebuie gestionat pe MARIME !',v_context);
    END IF;
    IF v_row_itm.flag_colour = 0 AND p_row.colour_code IS NOT NULL THEN
        Pkg_App_Tools.P_Log('M','Codul NU este gestionat pe CULOARE !',v_context);
    END IF;
    IF v_row_itm.flag_size = 0 AND p_row.size_code IS NOT NULL THEN
        Pkg_App_Tools.P_Log('M','Codul NU este gestionat pe MARIME !',v_context);
    END IF;
    IF v_row_itm.flag_range = 0 AND (p_row.start_size IS NOT NULL OR p_row.end_size IS NOT NULL) THEN
        Pkg_App_Tools.P_Log('M','Acest cod NU este gestionat pe plaja de marimi !',v_context);
    END IF;
    IF p_row.whs_supply IS NULL THEN
        Pkg_App_Tools.P_Log('M','Nu ati precizat MAGAZIA de eliberare !',v_context);
    END IF;
    IF p_row.oper_code IS NULL THEN
        Pkg_App_Tools.P_Log('M','Nu ati precizat OPERATIA de consum !',v_context);
    END IF;
    --
    IF v_row_itm.make_buy = 'A' AND p_row.oper_code_item IS NOT NULL THEN
        Pkg_App_Tools.P_Log('M','Pentru materie prima NU se precizeaza faza !',NULL);
    END IF;

    -- verify if the function returned value is 0
    IF v_nom_qty = 0 THEN
        IF v_row_itm.flag_size = -1 THEN
            Pkg_App_Tools.P_Log('M','Pentru marimea '||p_row.size_code||' nu exista cantitati de produs in Pontajul Bolei!', v_context);
        ELSIF v_row_itm.flag_range = -1 THEN
            Pkg_App_Tools.P_Log('M','Pentru plaja de marimi: '||NVL(p_row.start_size, v_row_itm.start_size)||' - '||NVL(p_row.end_size,v_row_itm.end_size)||' nu exista cantitati de produs IN Pontajul Bolei!', v_context);
        END IF;
    END IF;

    Pkg_Lib.p_rae_m('B');

    IF p_tip IN ('U') THEN
        -- check if both QTA and QTA_DEMAND are modified
        IF Pkg_Lib.f_mod_n(v_row_old.qta, p_row.qta) AND Pkg_Lib.f_mod_n(v_row_old.qta_demand, p_row.qta_demand) THEN
            IF p_row.qta_demand <> (p_row.qta * v_nom_qty) THEN
                Pkg_App_Tools.P_Log('M','QtaTotal = QtaUnit * QtaNom --> '||p_row.qta_demand||'='||p_row.qta||'*'||v_nom_qty,'');
            END IF;
        END IF;


    END IF;

    Pkg_Lib.p_rae_m('B');

    IF p_tip IN ('U') THEN
        IF (NOT Pkg_Lib.f_mod_n(v_row_old.qta, p_row.qta)) AND Pkg_Lib.f_mod_n(v_row_old.qta_demand, p_row.qta_demand) THEN
            p_row.qta           :=  Pkg_Lib.f_round (   p_number    => p_row.qta_demand / v_nom_qty,
                                                        p_decimals  => 4);
        END IF;
        IF Pkg_Lib.f_mod_n(v_row_old.qta, p_row.qta) AND NOT Pkg_Lib.f_mod_n(v_row_old.qta_demand, p_row.qta_demand) THEN
            p_row.qta_demand    :=  Pkg_Lib.f_round (   p_number    =>  p_row.qta * v_nom_qty,
                                                        p_decimals  =>  2);
        END IF;
    END IF;

    IF p_tip = 'I' THEN
            p_row.qta           :=  Pkg_Lib.f_round (   p_number    => p_row.qta_demand / v_nom_qty,
                                                        p_decimals  => 4);
    END IF;
    p_row.group_code    :=  v_row_grp.group_code;



EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************************
    DDL:    25/02/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_bom_group_iud       (   p_tip       VARCHAR2,
                                    p_row       BOM_GROUP%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on BOM_GROUP table
-----------------------------------------------------------------------------------------------------------
IS
    v_row       BOM_GROUP%ROWTYPE;
BEGIN

    v_row       :=  p_row;

    p_bom_group_blo (p_tip, v_row);
    Pkg_Iud.p_bom_group_iud(p_tip, v_row);

    Pkg_App_Secur.p_test_table_iud(p_tip, 'BOM_GROUP');

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/***********************************************************************************************************
    29/02/2008  d   Create

/***********************************************************************************************************/
FUNCTION f_str_wo_associated_groups     (   p_org_code      VARCHAR2,
                                            p_order_code    VARCHAR2
                                        )   RETURN          VARCHAR2
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    returns a string with all the Groups in which the order is included + operations
-----------------------------------------------------------------------------------------------------------
IS
    CURSOR C_WO_ASSOC_GRP   (p_org_code VARCHAR2, p_order_code VARCHAR2)
                            IS
                            SELECT      md.seq_no,wg.oper_code, g.group_code, g.status
                            --------------------------------------------------------------------
                            FROM        WORK_GROUP          g
                            INNER JOIN  WO_GROUP            wg  ON  wg.group_code   =   g.group_code
                            INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   wg.org_code
                                                                AND o.order_code    =   wg.order_code
                            INNER JOIN  MACROROUTING_DETAIL md  ON  md.routing_code =   o.routing_code
                                                                AND md.oper_code    =   wg.oper_code
                            --------------------------------------------------------------------
                            WHERE       wg.org_code     =   p_org_code
                                AND     wg.order_code   =   p_order_code
                            ORDER BY    md.seq_no
                            ;

    v_result        VARCHAR2(200);
    v_curr_group    VARCHAR2(30)    :=  '-';
BEGIN

    FOR x IN C_WO_ASSOC_GRP (p_org_code, p_order_code)
    LOOP
        IF v_curr_group <> x.group_code THEN
            v_result        :=  v_result || ' '||x.group_code || '->' || x.oper_code;
            v_curr_group    :=  x.group_code;
        ELSE
            v_result        :=  v_result || ';' || x.oper_code;
        END IF;
    END LOOP;

    RETURN v_result;
END;

/***********************************************************************************************************
    07/03/2008  d   Create

/***********************************************************************************************************/
FUNCTION f_str_grp_routing      (   p_ref_group     NUMBER
                                )   RETURN          VARCHAR2
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    returns a string with all the operations of the group + the situation on each operation
-----------------------------------------------------------------------------------------------------------
IS
    CURSOR C_GRP_ROUT       (p_ref_group    NUMBER)
                            IS
                            SELECT      gr.seq_no,
                                        MAX(gr.oper_code)               oper_code,
                                        MAX(gr.whs_cons)                whs_cons,
                                        MAX(gr.workcenter_code)         workcenter_code,
                                        COUNT(DISTINCT o.ORDER_CODE)    no_order,
                                        SUM(d.qta)                      tot_qty
                            ------------------------------------------------------------------------
                            FROM        GROUP_ROUTING       gr
                            INNER JOIN  WORK_GROUP          g   ON  g.idriga        =   gr.ref_group
                            LEFT JOIN   WO_GROUP            wg  ON  wg.group_code   =   g.group_code
                                                                AND wg.oper_code    =   gr.oper_code
                                                                AND wg.row_version  =   0
                            LEFT JOIN   WORK_ORDER          o   ON  o.org_code      =   wg.org_code
                                                                AND o.order_code    =   wg.order_code
                            LEFT JOIN   WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                            -----------------------------------------------------------------------
                            WHERE       gr.ref_group        =   p_ref_group
                            -----------------------------------------------------------------------
                            GROUP BY    gr.seq_no
                            ORDER BY    gr.seq_no
                            ;

    v_result        VARCHAR2(500);
BEGIN

    FOR x IN C_GRP_ROUT (p_ref_group)
    LOOP
        v_result    :=  v_result    ||  x.oper_code || '('||NVL(x.workcenter_code,'?')||' ';
        v_result    :=  v_result    ||  x.no_order || ' / '||x.tot_qty||') -> ';
    END LOOP;

    RETURN v_result;
END;

/***********************************************************************************************************
    04/06/2008  d   Create
/***********************************************************************************************************/
FUNCTION f_str_grp_rout_loc     (   p_ref_group     NUMBER,
                                    p_milestone     VARCHAR2
                                )   RETURN          VARCHAR2
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    returns a string with all the operations of the group + the locations
-----------------------------------------------------------------------------------------------------------
IS
    CURSOR C_GRP_ROUT       (p_ref_group    NUMBER)
                            IS
                            SELECT      r.oper_code         oper_code,
                                        o.org_name          ,
                                        o.flag_myself       ,
                                        p.description       p_description
                            ------------------------------------------------------------------------
                            FROM        GROUP_ROUTING       r
                            LEFT JOIN   WAREHOUSE           w   ON  w.whs_code      =   r.whs_cons
                            LEFT JOIN   ORGANIZATION        o   ON  o.org_code      =   w.org_code
                            INNER JOIN  OPERATION           p   ON  p.oper_code     =   r.oper_code
                            -----------------------------------------------------------------------
                            WHERE       r.ref_group         =       p_ref_group
                                AND     r.milestone         LIKE    NVL(p_milestone,'%')
                            -----------------------------------------------------------------------
                            ORDER BY    r.seq_no
                            ;

    v_res_1         VARCHAR2(500);
    v_res_2         VARCHAR2(500);
    v_res_3         VARCHAR2(500);

BEGIN

    FOR x IN C_GRP_ROUT (p_ref_group)
    LOOP
        v_res_1     :=  v_res_1 ||  RPAD(SUBSTR(NVL(x.p_description,x.oper_code),1,14),  15,' ');
        v_res_2     :=  v_res_2 ||  RPAD(SUBSTR(x.org_name,1,14),   15,' ');
        IF x.flag_myself = 'Y' THEN
            v_res_3     :=  v_res_3 ||  RPAD(' ',           15,' ');
        ELSE
            v_res_3     :=  v_res_3 ||  RPAD('* extern',      15,' ');
        END IF;
    END LOOP;
    v_res_1 :=  v_res_1 || Pkg_Glb.C_NL||v_res_2||Pkg_Glb.C_NL||v_res_3||Pkg_Glb.C_NL;

    RETURN v_res_1;
END;

/*******************************************************************************************
    26/02/2008 d Moved here FROM Pkg_Ecl_Ang

/*******************************************************************************************/
FUNCTION f_sql_sk_work_order    (   p_line_id       NUMBER,
                                    p_org_code      VARCHAR2,
                                    p_season_code   VARCHAR2,
                                    p_status        VARCHAR2
                                )   RETURN          typ_longinfo     pipelined
--------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------
IS

    CURSOR  C_LINES IS
                    SELECT  *
                    FROM    VW_BLO_WORK_ORDER
                    ORDER   BY 1
                    ;

    v_row         tmp_longinfo := tmp_longinfo();

BEGIN

    Pkg_Order.p_prepare_work_order  (   p_line_id       =>  p_line_id,
                                        p_org_code      =>  p_org_code,
                                        p_season_code   =>  p_season_code,
                                        p_status        =>  p_status
                                    );

    FOR X IN C_LINES LOOP

            v_row.idriga    :=   X.idriga;
            v_row.dcn       :=   X.dcn;

            v_row.txt01     :=  X.order_code;
            v_row.txt02     :=  X.item_code;
      --  v_row.txt03    := x.description;
            v_row.txt04     :=  X.status;
            v_row.txt06     :=  X.priority;
            v_row.txt07     :=  X.org_code;
            v_row.txt08     :=  X.group_code;
            v_row.txt09     :=  X.whs_cons;
            v_row.txt10     :=  X.client_lot;
            v_row.txt11     :=  X.client_location;
            v_row.txt12     :=  X.description;
            v_row.txt13     :=  X.root_code;
            v_row.txt14     :=  X.season_code;
            v_row.txt15     :=  X.status_wo;
            v_row.txt16     :=  x.oper_code_item;
            v_row.txt17     :=  x.routing_code;
            v_row.txt18     :=  x.client_code;

            v_row.txt20     :=  X.note;

            v_row.txt21     :=  x.tehvar_fbc;
            v_row.txt22     :=  x.tehvar_sortiment;
            v_row.txt23     :=  x.tehvar_calapod;
            v_row.txt24     :=  x.tehvar_mattype;
            v_row.txt25     :=  x.tehvar_sigla;

            v_row.data01    :=  X.date_create;
            v_row.data02    :=  X.date_launch;
            v_row.data03    :=  X.date_complet;
            v_row.data04    :=  X.date_client;
            v_row.data05    :=  X.date_ship;

            v_row.numb01    :=  X.qta           ;
            v_row.numb02    :=  X.qta_complet   ;
            v_row.numb03    :=  X.qta_scrap     ;
            v_row.numb04    :=  X.qta_ship      ;

            v_row.numb05    :=  0; -- selectie default pun tot neselectate

            -- pentru ordinele de lucru lansate pun cantitatile declarate pe fiecare operatie

            v_row.numb06    :=  X.qta_oper1;
            v_row.numb07    :=  X.qta_oper2;
            v_row.numb08    :=  X.qta_oper3;
            v_row.numb09    :=  X.qta_oper4;

            v_row.numb10    :=  Pkg_Order.f_ord_get_ref_group(X.org_code, x.order_code);
            v_row.numb11    :=  X.qta_oper5;

            pipe ROW(v_row);

       END LOOP;

 RETURN;
END;

/*************************************************************************************************
    DDL:    29/02/2008  d   create

/*************************************************************************************************/
PROCEDURE p_prepare_work_order      (   p_line_id       NUMBER,
                                        p_org_code      VARCHAR2,
                                        p_season_code   VARCHAR2,
                                        p_status        VARCHAR2)
--------------------------------------------------------------------------------------------------
--  PURPOSE:    prepare data for WORK ORDER interface in a temporary view
--  INPUT:      ORG CODE
--              SEASON CODE
--              STATUS
--------------------------------------------------------------------------------------------------
IS
    PRAGMA autonomous_transaction;


    CURSOR  C_LINES (   p_org_code VARCHAR2, p_status VARCHAR2, p_season_code VARCHAR2)
                        IS
                        SELECT  /*+ use_hash(w d g i) index(d IN_WO_DETAIL_01) index(i IN_ITEM_01)  */
                                    w.idriga,
                                    MAX(w.dcn)                  dcn,
                                    MAX(w.order_code)           order_code,
                                    MAX(w.org_code)               org_code,
                                    MAX(w.item_code)            item_code,
                                    MAX(w.oper_code_item)       oper_code_item,
                                    MAX(i.root_code)            root_code,
                                    MAX(w.routing_code)         routing_code,
                                    MAX(i.description)          description,
                                    MAX(w.priority)             priority,
                                    MAX(w.date_create)          date_create,
                                    MAX(w.date_launch)          date_launch,
                                    MAX(w.date_complet)         date_complet,
                                    MAX(w.date_client)          date_client,
                                    SUM(d.qta)                  qta,
                                    SUM(d.qta_complet)          qta_complet,
                                    SUM(d.qta_scrap)            qta_scrap,
                                    SUM(d.qta_ship_good)        qta_ship,
                                    MAX(w.client_lot)           client_lot,
                                    MAX(w.client_location)      client_location,
                                    MAX(w.season_code)          season_code,
                                    MAX(w.status)               status_wo,
                                    MAX(w.note)                 note,
                                    MAX(w.client_code)          client_code
                                    ---------------------------------------------------------
                        FROM        WORK_ORDER  w
                        LEFT JOIN   WO_DETAIL   d ON    d.ref_wo        =   w.idriga
                        INNER JOIN  ITEM        i ON    i.org_code      =   w.org_code
                                                    AND i.item_code     =   w.item_code
                                    ---------------------------------------------------------
                        WHERE       p_line_id                   IS NULL
                                AND w.season_code               =    p_season_code
                                AND w.org_code                  =    p_org_code
                                AND NVL(w.status,'N')           IN  (   SELECT  txt01
                                                                        FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_status)))
                                    ---------------------------------------------------------
                        GROUP BY    w.idriga
                        /*******************************************************************************/
                        UNION ALL
                        SELECT
                                    w.idriga,
                                    MAX(w.dcn)                  dcn,
                                    MAX(w.order_code)           order_code,
                                    MAX(w.org_code)               org_code,
                                    MAX(w.item_code)            item_code,
                                    MAX(w.oper_code_item)       oper_code_item,
                                    MAX(i.root_code)            root_code,
                                    MAX(w.routing_code)         routing_code,
                                    MAX(i.description)          description,
                                    MAX(w.priority)             priority,
                                    MAX(w.date_create)          date_create,
                                    MAX(w.date_launch)          date_launch,
                                    MAX(w.date_complet)         date_complet,
                                    MAX(w.date_client)          date_client,
                                    SUM(d.qta)                  qta,
                                    SUM(d.qta_complet)          qta_complet,
                                    SUM(d.qta_scrap)            qta_scrap,
                                    SUM(d.qta_ship_good)        qta_ship,
                                    MAX(w.client_lot)           client_lot,
                                    MAX(w.client_location)      client_location,
                                    MAX(w.season_code)          season_code,
                                    MAX(w.status)               status_wo,
                                    MAX(w.note)                 note,
                                    MAX(w.client_code)          client_code
                                    ---------------------------------------------------------
                        FROM        WORK_ORDER  w
                        LEFT JOIN   WO_DETAIL   d ON    d.ref_wo        =   w.idriga
                        INNER JOIN  ITEM        i ON    i.org_code      =   w.org_code
                                                    AND i.item_code     =   w.item_code
                                    ---------------------------------------------------------
                        WHERE       w.idriga    =   p_line_id
                            AND     p_line_id   IS NOT NULL
                                    ---------------------------------------------------------
                        GROUP BY    w.idriga
                        ;

    -- get the produced quantities (versamento)
    CURSOR C_FIN        (p_org_code     VARCHAR2, p_order_code  VARCHAR2)
                        IS
                        SELECT      SUM(d.qty * d.trn_sign) qty_fin
                        FROM        WHS_TRN_DETAIL          d
                        WHERE       org_code                =   p_org_code
                            AND     order_code              =   p_order_code
                            AND     reason_code             =   Pkg_Glb.C_P_TFINPF
                        ;

    -- get the expedited quantities
    CURSOR C_EXP        (p_org_code     VARCHAR2, p_order_code  VARCHAR2)
                        IS
                        SELECT      SUM(d.qty * d.trn_sign)
                                    *
                                    (-1)                    qty_exp,
                                    MAX(h.date_legal)       min_date_legal
                        FROM        WHS_TRN_DETAIL          d
                        INNER JOIN  WHS_TRN                 h   ON  h.idriga    =   d.ref_trn
                        WHERE       d.org_code                =   p_org_code
                            AND     d.order_code              =   p_order_code
                            AND     d.reason_code             =   Pkg_Glb.C_M_OSHPPF
                        ;

    -- get the Tehnical variable values for the finished good
    CURSOR C_TEH        (p_org_code VARCHAR2, p_item_code   VARCHAR2)
                        IS
                        SELECT      v.var_code, v.var_value, i.description
                        FROM        ITEM_VARIABLE   v
                        LEFT JOIN   ITEM            i   ON  i.org_code      =   v.org_code
                                                        AND i.item_code     =   v.var_value
                                                        AND v.var_code      =   'CALAPOD'                        
                        WHERE       v.org_code      =   p_org_code
                            AND     v.item_code     =   p_item_code
                        ;


    v_row_ini           VW_BLO_WORK_ORDER%ROWTYPE;
    v_row               VW_BLO_WORK_ORDER%ROWTYPE;
    it_qty_prod         Pkg_Glb.typ_varchar_varchar;
    it_ord              Pkg_Rtype.ta_vw_blo_work_order;
    v_row_fin           C_FIN%ROWTYPE;
    v_row_exp           C_EXP%ROWTYPE;

    C_SEGMENT_CODE      VARCHAR2(32000) := 'VW_BLO_WORK_ORDER' ;

BEGIN

    IF p_line_id IS NULL THEN
        IF p_org_code IS NULL THEN Pkg_Lib.p_rae('Nu ati precizat Organizatia !!!'); END IF;
    END IF;

    DELETE FROM VW_BLO_WORK_ORDER;

    v_row_ini.segment_code          :=      C_SEGMENT_CODE;
    v_row_ini.present_date          :=      SYSDATE;

    FOR x IN C_LINES(p_org_code, p_status, p_season_code) LOOP
        v_row   :=  v_row_ini;

        -- get the FINISHED quantity
        OPEN    C_FIN   (x.org_code, x.order_code);
        FETCH   C_FIN   INTO v_row_fin;
        CLOSE   C_FIN;

        -- get the EXPEDITED quantity
        OPEN    C_EXP   (x.org_code, x.order_code);
        FETCH   C_EXP   INTO v_row_exp;
        CLOSE   C_EXP;

        -- get the work order producted quantities on each operation
        Pkg_Prod.p_wo_get_prod_qty  (   p_org_code      =>  x.org_code,
                                        p_order_code    =>  x.order_code,
                                        it_prod_qty     =>  it_qty_prod);

        -- technical variables
        FOR xx IN C_TEH(x.org_code, x.item_code)
        LOOP
            CASE xx.var_code
                WHEN    'FBC'       THEN    v_row.tehvar_fbc        :=  xx.var_value;
                WHEN    'SORTIMENT' THEN    v_row.tehvar_sortiment  :=  xx.var_value;
                WHEN    'CALAPOD'   THEN    v_row.tehvar_calapod    :=  nvl(xx.description, xx.var_value);
                WHEN    'MATTYPE'   THEN    v_row.tehvar_mattype    :=  xx.var_value;
                WHEN    'SIGLA'     THEN    v_row.tehvar_sigla      :=  xx.var_value;
                ELSE                NULL;
            END CASE;
        END LOOP;

        v_row.idriga                :=      x.idriga;
        v_row.dcn                   :=      x.dcn;
        v_row.seq_no                :=      C_LINES%rowcount;

        v_row.qta                   :=      x.qta;
        v_row.qta_complet           :=      x.qta_complet;
        v_row.qta_scrap             :=      x.qta_scrap;
        v_row.order_code            :=      x.order_code;
        v_row.routing_code          :=      x.routing_code;
        v_row.group_code            :=      Pkg_Order.f_str_wo_associated_groups(x.org_code, x.order_code);
        v_row.org_code              :=      x.org_code;
        v_row.item_code             :=      x.item_code;
        v_row.oper_code_item        :=      x.oper_code_item;
        v_row.root_code             :=      x.root_code;
        v_row.description           :=      x.description;
        v_row.priority              :=      x.priority;
        v_row.client_lot            :=      x.client_lot;
        v_row.client_location       :=      x.client_location;
        v_row.season_code           :=      x.season_code;
        v_row.status_wo             :=      x.status_wo;
        v_row.note                  :=      x.note;
        v_row.date_create           :=      x.date_create;
        v_row.date_launch           :=      x.date_launch;
        v_row.date_complet          :=      x.date_complet;
        v_row.date_client           :=      x.date_client;
        v_row.client_code           :=      x.client_code;

        v_row.qta_complet           :=      v_row_fin.qty_fin;

        v_row.qta_ship              :=      v_row_exp.qty_exp;--NVL(v_row_ship.qta,0);
        v_row.date_ship             :=      v_row_exp.min_date_legal;  -- first shipment date

        v_row.qta_oper1             :=      Pkg_Lib.f_table_value(it_qty_prod,'CROIT',0);
        v_row.qta_oper2             :=      Pkg_Lib.f_table_value(it_qty_prod,'PRECUSUT',0);
        v_row.qta_oper3             :=      Pkg_Lib.f_table_value(it_qty_prod,'CUSUT',0);
        v_row.qta_oper4             :=      Pkg_Lib.f_table_value(it_qty_prod,'TRAS',0);
        v_row.qta_oper5             :=      Pkg_Lib.f_table_value(it_qty_prod,'AMBALAT',0);

        it_ord(it_ord.COUNT + 1)    :=      v_row;

    END LOOP;

    Pkg_Iud.p_vw_blo_work_order_miud('I', it_ord);

    COMMIT;

--EXCEPTION WHEN OTHERS THEN
--    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************
    05/03/2008 d Moved from Pkg_Ecl_Ang

/*********************************************************************************************/
FUNCTION f_sql_sk_work_order_s4(p_ref_wo INTEGER)    RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINES      (p_org_code VARCHAR2, p_order_code VARCHAR2, p_ref_wo NUMBER)
                            IS
                            SELECT      d.idriga, d.dcn,
                                        d.size_code             ,
                                        d.qta                   nom_qty,
                                        e.exp_qty               ,
                                        k.pkg_qty,
                                        f.fin_qty
                            ------------------------------------------------------------------------------
                            FROM        WO_DETAIL               d
                            LEFT JOIN   VW_PREP_ORD_EXP_QTY     e   ON  e.org_code      =   p_org_code
                                                                    AND e.order_code    =   p_order_code
                                                                    AND e.size_code     =   d.size_code
                            LEFT JOIN   VW_PREP_ORD_PKG_QTY     k   ON  k.org_code      =   p_org_code
                                                                    AND k.order_code    =   p_order_code
                                                                    AND k.size_code     =   d.size_code
                            LEFT JOIN   VW_PREP_ORD_FIN_QTY     f   ON  f.org_code      =   p_org_code
                                                                    AND f.order_code    =   p_order_code
                                                                    AND f.size_code     =   d.size_code
                            ------------------------------------------------------------------------------
                            WHERE       d.ref_wo                =   p_ref_wo
                            ;

    v_row                   tmp_frm      := tmp_frm();
    v_row_ord               WORK_ORDER%ROWTYPE;

BEGIN

    v_row_ord.idriga        :=  p_ref_wo;
    Pkg_Get.p_get_work_order(v_row_ord);

    -- call the procedure that insert in a temporary view the exported quantities for the order
    Pkg_Prod.p_prep_ord_exp_qty (   p_org_code      =>  v_row_ord.org_code,
                                    p_order_code    =>  v_row_ord.order_code
                                );

    -- call the procedure that insert in a temporary view the finished quantities for the order
    Pkg_Prod.p_prep_ord_fin_qty (   p_org_code      =>  v_row_ord.org_code,
                                    p_order_code    =>  v_row_ord.order_code
                                );

    Pkg_Scan.p_prep_ord_pkg_qty (   p_org_code      =>  v_row_ord.org_code,
                                    p_order_code    =>  v_row_ord.order_code
                                );
    --
    FOR X IN C_LINES (v_row_ord.org_code, v_row_ord.order_code, v_row_ord.idriga)
    LOOP

        v_row.idriga    :=  X.idriga;
        v_row.dcn       :=  X.dcn;

        v_row.txt01     :=  X.size_code;

        v_row.numb01    :=  X.nom_qty;
        v_row.numb02    :=  X.fin_qty;
        v_row.numb03    :=  0;--X.qta_scrap;
        v_row.numb04    :=  p_ref_wo;
        v_row.numb05    :=  X.exp_qty;
        v_row.numb06    :=  X.pkg_qty;


        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    05/03/2008 d Moved from Pkg_Ecl_Ang

/*********************************************************************************************/
FUNCTION f_sql_sk_item_size      RETURN typ_longinfo  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINII      IS
                            SELECT  *
                            FROM    ITEM_SIZE
                            ;

    v_row      tmp_longinfo := tmp_longinfo();

BEGIN

    FOR X IN C_LINII LOOP

        v_row.idriga   := X.idriga;
        v_row.dcn    := X.dcn;

        v_row.txt01    := X.size_code;
        v_row.txt02    := X.description;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    05/03/2008  d   created
    21/11/2008  d   rules for modifying details even after the order was launched
/*********************************************************************************************/
PROCEDURE p_wo_detail_blo   (   p_tip   VARCHAR2, p_row IN OUT WO_DETAIL%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    IUD for WO_DETAIL
----------------------------------------------------------------------------------------------
IS
    CURSOR C_GET_DET        (   p_ref_wo    NUMBER,
                                p_size_code VARCHAR2    )
                            IS
                            SELECT      *
                            FROM        WO_DETAIL       d
                            WHERE       d.ref_wo        =   p_ref_wo
                                AND     d.size_code     =   p_size_code
                            ;

    v_found                 BOOLEAN;
    v_row_ord               WORK_ORDER%ROWTYPE;
    v_row_old               WO_DETAIL%ROWTYPE;

BEGIN

    -- read the WORK ORDER info, for checking the order status, etc
    v_row_ord.idriga        :=  p_row.ref_wo;
    Pkg_Get.p_get_work_order(v_row_ord, 0);

    IF v_row_ord.status = 'T' THEN
        Pkg_Err.p_rae('Bola este TERMINATA, nu se poate modifica pontajul!');
    END IF;

    IF p_tip = 'I' THEN

        IF v_row_ord.status <> 'I' THEN
            Pkg_Err.p_rae('Inserari de noi marimi pe PONTAJUL unei Bole se pot face doar daca aceasta este in stare (I)nitiala !');
        END IF;

        -- verify if the size already exists
        OPEN    C_GET_DET(p_row.ref_wo, p_row.size_code);
        FETCH   C_GET_DET INTO v_row_old; v_found  :=  C_GET_DET%FOUND;
        CLOSE   C_GET_DET;
        IF v_found THEN
            Pkg_Err.p_err('Marimea '||p_row.size_code||' deja exista pe Pontajul Bolei !','Verificari');
        END IF;
    END IF;

    -- UPDATE
    IF p_tip = 'U' THEN
        v_row_old.idriga :=  p_row.idriga;
        Pkg_Get.p_get_wo_detail(v_row_old);
        IF p_row.size_code <> v_row_old.size_code THEN
            Pkg_Err.p_err('Nu se poate modifica marimea ! Daca ati gresit, stergeti si reintroduceti!', 'Verificari');
        END IF;
        IF p_row.qta < v_row_old.qta THEN
            Pkg_Err.p_err('Nu se poate micsora pontajul unei marimi!','Verificari');
        ELSE
            Pkg_App_Secur.p_test_grant('APP_ADMIN');
        END IF;
    END IF;

    Pkg_Err.p_rae;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************
    05/03/2008  d   created

/*********************************************************************************************/
PROCEDURE p_wo_detail_iud   (   p_tip   VARCHAR2, p_row WO_DETAIL%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    IUD for WO_DETAIL
----------------------------------------------------------------------------------------------
IS
    v_row       WO_DETAIL%ROWTYPE;
BEGIN

    v_row               :=  p_row;

    p_wo_detail_blo     (p_tip, v_row);

    Pkg_Iud.p_wo_detail_iud (p_tip, p_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************
    06/03/2008  d   created

/*********************************************************************************************/
PROCEDURE p_work_order_blo  (   p_tip               VARCHAR2,
                                p_row   IN OUT      WORK_ORDER%ROWTYPE
                            )
----------------------------------------------------------------------------------------------
--  PURPOSE:    Row level BLO for work order
----------------------------------------------------------------------------------------------
IS
    CURSOR C_ROUTING        (p_routing_code     VARCHAR2)
                            IS
                            SELECT      *
                            FROM        MACROROUTING_DETAIL     d
                            WHERE       routing_code            =   p_routing_code
                                AND     flag_selected           =   'Y'
                            ORDER BY    seq_no DESC
                            ;

    CURSOR C_ASSOC          (   p_org_code      VARCHAR2,
                                p_order_code    VARCHAR2)
                            IS
                            SELECT      group_code, COUNT(1) grp_number
                            FROM        WO_GROUP        wg
                            WHERE       org_code        =   p_org_code
                                AND     order_code      =   p_order_code
                                AND     row_version     =   0
                            GROUP BY    group_code
                            ;

    v_row_old               WORK_ORDER%ROWTYPE;
    v_row_rou               C_ROUTING%ROWTYPE;
    v_found                 BOOLEAN;
    v_errstr                VARCHAR2(1000);
    v_assoc_grp             VARCHAR2(200);
    v_context               VARCHAR2(250);

BEGIN

    -- get the groups where the order is associated (if any)
    IF p_tip IN ('U', 'D') THEN
        v_row_old.idriga    :=  p_row.idriga;
        Pkg_Get.p_get_work_order(v_row_old,0);

        FOR x IN C_ASSOC (p_row.org_code, p_row.order_code)
        LOOP
            v_assoc_grp     :=  x.group_code ||'('|| x.grp_number ||')';
        END LOOP;
    END IF;

    IF p_tip = 'U' THEN
        -- checks when the order is already associated in Groups
        IF NOT v_assoc_grp IS NULL THEN
            v_context   :=  'MODIFICARI NEPERMISE deoarece Bola a fost asociata pe comenzi interne --> '||v_assoc_grp;
            IF p_row.item_code      <> v_row_old.item_code THEN
                Pkg_Err.p_err('Nu puteti schimba Produsul Finit al bolei !',v_context);
            END IF;
            IF p_row.routing_code   <> v_row_old.routing_code THEN
                Pkg_Err.p_err('Nu puteti schimba Routing-ul bolei !',v_context);
            END IF;
            IF p_row.org_code       <> v_row_old.org_code THEN
                Pkg_Err.p_err('Nu puteti schimba Proprietarul bolei !',v_context);
            END IF;
            IF p_row.season_code    <> v_row_old.season_code THEN
                Pkg_Err.p_err('Nu puteti schimba Stagiunea bolei !',v_context);
            END IF;
            IF p_row.oper_code_item is null  THEN
                Pkg_Err.p_err('Completati faza comenzii !',v_context);
            END IF;
        END IF;

    END IF;

    IF p_tip = 'I' OR p_tip = 'U' THEN

        -- check if the ROUTING CODE and OPER_CODE_ITEM match
        OPEN    C_ROUTING  (p_row.routing_code);
        FETCH   C_ROUTING   INTO v_row_rou;
        v_found :=  C_ROUTING%FOUND;
        CLOSE   C_ROUTING;
        IF v_row_rou.oper_code <> p_row.oper_code_item THEN
            v_errstr    :=  'Operatia finala a bolei:'||p_row.oper_code_item;
            v_errstr    :=  v_errstr || ' *** Operatia finala a routing-ului: '||v_row_rou.oper_code;
            Pkg_Err.p_err(v_errstr,'Operatia finala a bolei nu coincide cu operatia finala a routing-ului asociat !');
        END IF;

    ELSE
        NULL;
    END IF;

    -- delete checks
    IF p_tip    = 'D'  THEN
        IF NOT v_assoc_grp IS NULL THEN
            Pkg_Err.p_err('Asociata pe ' || v_assoc_grp, 'Nu se poate sterge Bola !');
        END IF;
    END IF;

    Pkg_Err.p_rae;

    -- default values for INSERT
    IF p_tip = 'I' THEN
        p_row.date_create       :=  NVL(p_row.date_create,      TRUNC(SYSDATE));
        p_row.oper_code_item    :=  NVL(p_row.oper_code_item,   'FINIT');
        p_row.routing_code      :=  NVL(p_row.routing_code,     '001');
    END IF;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************
    06/03/2008  d   created

/*********************************************************************************************/
PROCEDURE p_work_order_iud      (   p_tip   VARCHAR2, p_row WORK_ORDER%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    IUD for WO_DETAIL
----------------------------------------------------------------------------------------------
IS
    v_row_new       WORK_ORDER%ROWTYPE;

BEGIN

    v_row_new           :=  p_row;

    p_work_order_blo(p_tip, v_row_new);

    Pkg_Iud.p_work_order_iud (p_tip, v_row_new);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************
    06/03/2008  d   created

/*********************************************************************************************/
PROCEDURE p_work_group_iud      (   p_tip   VARCHAR2, p_row WORK_GROUP%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    IUD for WO_DETAIL
----------------------------------------------------------------------------------------------
IS
    v_row_new       WORK_GROUP%ROWTYPE;

BEGIN

    v_row_new           :=  p_row;

    Pkg_Iud.p_work_group_iud (p_tip, v_row_new);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/**********************************************************************************************************
    DDL:    07/03/2008  d   Create date
/**********************************************************************************************************/
PROCEDURE p_prepare_work_group  (   p_org_code      VARCHAR2,
                                    p_season_code   VARCHAR2,
                                    p_status        VARCHAR2
                                )
--------------------------------------------------------------------------------------------------------------
--  PURPOSE:    prepare the data for the WORK_GROUP interface
--  INPUT:      ORG_CODE    =   organization
--              SEASON_CODE =   season
--              STATUS      =   list of group status, separated by ";"
--------------------------------------------------------------------------------------------------------------
IS
    PRAGMA autonomous_transaction;

    CURSOR C_LINES(p_org_code VARCHAR2,p_season_code VARCHAR2, p_status VARCHAR2)
                IS
                SELECT      g.idriga            ref_group,
                            MAX(g.dcn)          dcn,
                            MAX(g.org_code)     org_code,
                            MAX(g.season_code)  season_code,
                            MAX(g.group_code)   group_code,
                            MAX(g.description)  description,
                            MAX(g.status)       status,
                            MAX(g.datagg)       datagg,
                            MAX(g.date_launch)  date_launch,
                            MAX(g.note)         note
                --------------------------------------------------------------------------------
                FROM        WORK_GROUP          g
                --------------------------------------------------------------------------------
                WHERE       g.org_code          =  p_org_code
                        AND g.season_code       LIKE NVL(p_season_code,'%')
                        AND g.status            IN  (SELECT txt01 FROM TABLE( Pkg_Lib.f_sql_inlist(p_status)))
                GROUP BY    g.idriga
                ;

    CURSOR C_WG_INFO    (   p_group_code    VARCHAR2, p_ref_group NUMBER)
                        IS
                        SELECT      gr.oper_code             ,
                                    COUNT(DISTINCT wg.order_code)
                                                            order_no,
                                    SUM(d.qta)              nom_qty
                        -----------------------------------------------------------------------------
                        FROM        WO_GROUP            wg
                        INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   wg.org_code
                                                            AND o.order_code    =   wg.order_code
                        LEFT JOIN   WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                        INNER JOIN  GROUP_ROUTING       gr  ON  gr.ref_group    =   p_ref_group
                                                            AND gr.oper_code    =   wg.oper_code
                        -----------------------------------------------------------------------------
                        WHERE       wg.group_code       =   p_group_code
                        GROUP BY    gr.oper_code
                        ;

    v_row               VW_BLO_WORK_GROUP%ROWTYPE;
    v_row_ini           VW_BLO_WORK_GROUP%ROWTYPE;
    x                   C_LINES%ROWTYPE;
    v_mat_issue         INTEGER;
    C_SEGMENT_CODE      VARCHAR2(32000) := 'VW_BLO_WORK_GROUP' ;
    v_row_wgi           C_WG_INFO%ROWTYPE;
    v_found             BOOLEAN;

BEGIN

    DELETE FROM VW_BLO_WORK_GROUP;

    OPEN C_LINES(   p_org_code      => p_org_code  ,
                    p_season_code   => p_season_code ,
                    p_status        => p_status
                );

    LOOP

        FETCH   C_LINES INTO x;
        EXIT WHEN C_LINES%NOTFOUND;

        v_row                       :=      v_row_ini;

        OPEN C_WG_INFO(x.group_code, x.ref_group);
        FETCH C_WG_INFO INTO v_row_wgi; v_found := C_WG_INFO%FOUND;
        CLOSE C_WG_INFO;

        v_row.segment_code          :=      C_SEGMENT_CODE;
        v_row.idriga                :=      x.ref_group;
        v_row.dcn                   :=      x.dcn;

        v_row.org_code              :=      x.org_code;
        v_row.season_code           :=      x.season_code;
        v_row.group_code            :=      x.group_code;
        v_row.description           :=      x.description;
        v_row.status                :=      x.status;
        v_row.date_create           :=      TRUNC(x.datagg);
        v_row.date_launch           :=      x.date_launch;
        v_row.grp_routing           :=      Pkg_Order.f_str_grp_routing(x.ref_group);
        v_row.note                  :=      x.note;
        IF v_found THEN
            v_row.qty_total         :=      v_row_wgi.nom_qty;
            v_row.order_no          :=      v_row_wgi.order_no;
        ELSE
            v_row.qty_total         :=      0;
            v_row.order_no          :=      0;
        END IF;

--      v_mat_issue  :=  Pkg_Order.f_exists_material_issued(v_row.idriga);
        CASE NVL(v_mat_issue,0)
            WHEN  0 THEN  v_row.component_issue := 'FARA MAT.';
            WHEN -1 THEN  v_row.component_issue := 'PARTIAL';
            WHEN -2 THEN  v_row.component_issue := 'TOT';
            WHEN -3 THEN  v_row.component_issue := 'NIMIC';
        END CASE;

        INSERT
        INTO    VW_BLO_WORK_GROUP
        VALUES  v_row;

    END LOOP;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/**********************************************************************************************************
    DDL:    07/03/2008  d   Create date
/**********************************************************************************************************/
FUNCTION f_sql_sk_work_group    (   p_org_code      VARCHAR2,
                                    p_status        VARCHAR2,
                                    p_season_code   VARCHAR2
                                )
                                    RETURN          typ_frm  pipelined
--------------------------------------------------------------------------------------------------------------
--  PURPOSE:    returns the data for the WORK_GROUP interface
--------------------------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES      IS
                        SELECT      *
                        FROM        VW_BLO_WORK_GROUP
                        ORDER BY    group_code ASC
                        ;

    v_row           tmp_frm := tmp_frm();

BEGIN

    IF p_org_code IS NULL OR p_season_code IS NULL OR p_status IS NULL THEN
        Pkg_Lib.p_rae('Nu ati precizat org_codeul/stagiunea/starea !!!');
    END IF;

    Pkg_Order.p_prepare_work_group( p_org_code      => p_org_code,
                                    p_season_code   => p_season_code,
                                    p_status        => p_status
                                    );

    FOR X IN C_LINES LOOP

        v_row.idriga    :=  X.idriga;
        v_row.dcn       :=  X.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  X.group_code;
        v_row.txt02     :=  X.org_code;
        v_row.txt03     :=  X.description;
        v_row.txt04     :=  X.status;
        v_row.txt05     :=  X.grp_routing;
        v_row.txt06     :=  X.season_code;
        v_row.txt07     :=  X.component_issue;
        v_row.txt08     :=  x.note;

        v_row.data01    :=  X.date_create;
        v_row.data02    :=  X.date_launch;
        v_row.data04    :=  X.date_client;

        v_row.numb02    :=  X.qty_total;
        v_row.numb03    :=  x.order_no;

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;


/*********************************************************************************************
    07/03/2008  d   Create date

/*********************************************************************************************/
FUNCTION f_sql_sk_grp_assoc_wo  (   p_group_code    VARCHAR2)    RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WO_DETAIL subform
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINII      (p_group_code   VARCHAR2)
                            IS
                            SELECT
                                        wg.idriga,
                                        MAX(wg.group_code)      group_code,
                                        MAX(wg.oper_code)       oper_code,
                                        MAX(wg.dcn)             dcn,
                                        MAX(o.item_code)        item_code,
                                        MAX(o.oper_code_item)   oper_code_item,
                                        MAX(o.routing_code)     routing_code,
                                        MAX(wg.org_code)        org_code,
                                        MAX(wg.order_code)      order_code,
                                        MAX(i.description)      item_description,
                                        MAX(o.season_code)      season_code,
                                        SUM(d.qta)              nom_qty
                            --------------------------------------------------------------------
                            FROM        WO_GROUP        wg
                            INNER JOIN  WORK_ORDER      o   ON  o.order_code    =   wg.order_code
                                                            AND o.org_code      =   wg.org_code
                            INNER JOIN  ITEM            i   ON  i.org_code      =   o.org_code
                                                            AND i.item_code     =   o.item_code
                            LEFT JOIN   WO_DETAIL       d   ON  d.ref_wo        =   o.idriga
                            --------------------------------------------------------------------
                            WHERE       wg.group_code   =   p_group_code
                            --------------------------------------------------------------------
                            GROUP BY    wg.idriga
                            ORDER BY    order_code
                            ;

    v_row      tmp_frm      := tmp_frm();

BEGIN

    FOR X IN C_LINII(p_group_code)
    LOOP

        v_row.idriga    :=  X.idriga;
        v_row.dcn       :=  X.dcn;
        v_row.seq_no    :=  C_LINII%rowcount;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.group_code;
        v_row.txt03     :=  x.order_code;
        v_row.txt04     :=  x.season_code;
        v_row.txt05     :=  x.item_code;
        v_row.txt06     :=  x.oper_code;
        v_row.txt07     :=  x.item_description;
        v_row.txt08     :=  x.routing_code;
        v_row.txt09     :=  Pkg_Prod.f_get_routing_oper(x.routing_code);
        v_row.numb01    :=  x.nom_qty;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;


/*********************************************************************************************
    08/03/2008  d   Create date

/*********************************************************************************************/
FUNCTION f_sql_sk_grp_rout      (   p_line_id           NUMBER,
                                    p_ref_group         NUMBER)
                                    RETURN              typ_frm         pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for GROUP ROUTING subform
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINES      (p_ref_group    NUMBER, p_line_ID NUMBER)
                            IS
                            SELECT      gr.idriga           ,
                                        gr.dcn              ,
                                        gr.ref_group        ,
                                        gr.seq_no           ,
                                        gr.oper_code        ,
                                        gr.workcenter_code  ,
                                        wc.description      wc_description,
                                        wc.costcenter_code  ,
                                        cc.description      cc_description,
                                        cc.org_code         cc_org_code,
                                        og.flag_myself      og_flag_myself,
                                        gr.whs_cons         ,
                                        whc.description     whc_description,
                                        gr.whs_dest         ,
                                        whd.description     whd_description,
                                        gr.milestone        ,
                                        gr.note
                            ---------------------------------------------------------------------
                            FROM        GROUP_ROUTING       gr
                            LEFT JOIN   WORKCENTER          wc  ON  wc.workcenter_code  =   gr.workcenter_code
                            LEFT JOIN   COSTCENTER          cc  ON  cc.costcenter_code  =   wc.costcenter_code
                            LEFT JOIN   ORGANIZATION        og  ON  og.org_code         =   cc.org_code
                            LEFT JOIN   WAREHOUSE           whc ON  whc.whs_code        =   gr.whs_cons
                            LEFT JOIN   WAREHOUSE           whd ON  whd.whs_code        =   gr.whs_dest
                            ---------------------------------------------------------------------
                            WHERE       gr.ref_group        =   p_ref_group
                                AND     p_line_id           IS NULL
                            ---------------------------------------------------------------------
                            ---     LINE ID
                            ---------------------------------------------------------------------
                            UNION ALL
                            SELECT      gr.idriga           ,
                                        gr.dcn              ,
                                        gr.ref_group        ,
                                        gr.seq_no           ,
                                        gr.oper_code        ,
                                        gr.workcenter_code  ,
                                        wc.description      wc_description,
                                        wc.costcenter_code  ,
                                        cc.description      cc_description,
                                        cc.org_code         cc_org_code,
                                        og.flag_myself      og_flag_myself,
                                        gr.whs_cons         ,
                                        whc.description     whc_description,
                                        gr.whs_dest         ,
                                        whd.description     whd_description,
                                        gr.milestone        ,
                                        gr.note
                            ---------------------------------------------------------------------
                            FROM        GROUP_ROUTING       gr
                            LEFT JOIN   WORKCENTER          wc  ON  wc.workcenter_code  =   gr.workcenter_code
                            LEFT JOIN   COSTCENTER          cc  ON  cc.costcenter_code  =   wc.costcenter_code
                            LEFT JOIN   ORGANIZATION        og  ON  og.org_code         =   cc.org_code
                            LEFT JOIN   WAREHOUSE           whc ON  whc.whs_code        =   gr.whs_cons
                            LEFT JOIN   WAREHOUSE           whd ON  whd.whs_code        =   gr.whs_dest
                            ---------------------------------------------------------------------
                            WHERE       gr.idriga           =   p_line_id
                                AND     p_line_id           IS NOT NULL
                            ---------------------------------------------------------------------
                            ORDER BY    seq_no
                            ;

    v_row                   tmp_frm      := tmp_frm();

BEGIN


    FOR X IN C_LINES(p_ref_group, p_line_id)
    LOOP

        v_row.idriga    :=  X.idriga;
        v_row.dcn       :=  X.dcn;
        v_row.seq_no    :=  x.seq_no;

        v_row.txt01     :=  x.oper_code;
        v_row.txt02     :=  x.workcenter_code;
        v_row.txt03     :=  x.wc_description;
        v_row.txt04     :=  x.costcenter_code;
        v_row.txt05     :=  x.cc_description;
        v_row.txt06     :=  x.whs_cons;
        v_row.txt07     :=  x.whc_description;
        v_row.txt08     :=  x.whs_dest;
        v_row.txt09     :=  x.whd_description;
        v_row.txt10     :=  x.milestone;
        v_row.txt11     :=  x.note;
        v_row.txt12     :=  x.cc_org_code;
        v_row.txt13     :=  NVL(x.og_flag_myself,'Y');

        v_row.numb01    :=  x.ref_group;
        v_row.numb02    :=  x.seq_no;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;


/*********************************************************************************************
    08/03/2008  d   Create date

/*********************************************************************************************/
FUNCTION f_sql_sk_grp_bom       (   p_line_id       NUMBER,
                                    p_ref_group     NUMBER)
                                    RETURN          typ_frm         pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for GROUP ROUTING subform
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINES      (           p_line_id           NUMBER,
                                        p_ref_group         NUMBER)
                            IS
                            -- MULTIPLE RECORDS
                            SELECT      bg.idriga,
                                        bg.dcn,
                                        bg.ref_group        ,
                                        bg.status           ,
                                        bg.org_code         ,
                                        bg.item_code        ,
                                        bg.oper_code_item   ,
                                        i.description       ,
                                        bg.size_code        ,
                                        bg.colour_code      ,
                                        bg.start_size       ,
                                        bg.end_size         ,
                                        bg.qta              ,
                                        bg.qta_demand       ,
                                        bg.qta_picked       ,
                                        i.puom              ,
                                        bg.whs_supply       ,
                                        bg.oper_code        ,
                                        bg.scrap_perc       ,
                                        bg.note
                            ------------------------------------------------------------------------
                            FROM        BOM_GROUP           bg
                            INNER JOIN  ITEM                i   ON  i.ORG_code      =   bg.org_code
                                                                AND i.item_code     =   bg.item_code
                            ------------------------------------------------------------------------
                            WHERE       ref_group           =   p_ref_group
                                AND     p_line_id           IS NULL
                            UNION ALL
                            -- SINGLE RECORD
                            SELECT      bg.idriga,
                                        bg.dcn,
                                        bg.ref_group        ,
                                        bg.status           ,
                                        bg.org_code         ,
                                        bg.item_code        ,
                                        bg.oper_code_item   ,
                                        i.description       ,
                                        bg.size_code        ,
                                        bg.colour_code      ,
                                        bg.start_size       ,
                                        bg.end_size         ,
                                        bg.qta              ,
                                        bg.qta_demand       ,
                                        bg.qta_picked       ,
                                        i.puom              ,
                                        bg.whs_supply       ,
                                        bg.oper_code        ,
                                        bg.scrap_perc       ,
                                        bg.note
                            ------------------------------------------------------------------------
                            FROM        BOM_GROUP           bg
                            INNER JOIN  ITEM                i   ON  i.ORG_code      =   bg.org_code
                                                                AND i.item_code     =   bg.item_code
                            ------------------------------------------------------------------------
                            WHERE       bg.idriga           =   p_line_id
                                AND     p_line_id           IS NOT NULL
                            ;

    v_row                   tmp_frm      := tmp_frm();

BEGIN


    FOR X IN C_LINES(p_line_id, p_ref_group)
    LOOP

        v_row.idriga    :=  X.idriga;
        v_row.dcn       :=  X.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  X.item_code;
        v_row.txt02     :=  X.size_code;
        v_row.txt03     :=  X.colour_code;
        v_row.txt04     :=  X.oper_code;
        v_row.txt05     :=  X.whs_supply;
        v_row.txt06     :=  X.start_size;
        v_row.txt07     :=  X.end_size;
        v_row.txt08     :=  X.org_code;
        v_row.txt09     :=  X.description;
        v_row.txt10     :=  X.puom;
        v_row.txt11     :=  x.oper_code_item;
        v_row.txt12     :=  x.note;

        v_row.numb01    :=  p_ref_group;
        v_row.numb02    :=  X.qta;
        v_row.numb03    :=  X.qta_picked;
        v_row.numb04    :=  X.qta_demand;
        v_row.numb05   := X.scrap_perc;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/***************************************************************************************************
    DDL:    09/03/2008  d   Create
/***************************************************************************************************/
PROCEDURE p_prep_grp_nom_qty        (   p_group_code        VARCHAR2,
                                        p_oper_code         VARCHAR2)
-----------------------------------------------------------------------------------------------------
--  PURPOSE:    loads the nominal quantities for all the ORDERS associated with the GROUP
-----------------------------------------------------------------------------------------------------
IS
    CURSOR C_GRP_NOM        (   p_group_code    VARCHAR2, p_oper_code VARCHAR2)
                            IS
                            SELECT      wg.org_code     ,
                                        wg.order_code   ,
                                        wg.oper_code    ,
                                        d.size_code     ,
                                        SUM(d.qta)      nom_qty
                            -----------------------------------------------------------------------
                            FROM        WO_GROUP        wg
                            INNER JOIN  WORK_ORDER      o   ON  o.org_code      =   wg.org_code
                                                            AND o.order_code    =   wg.order_code
                            INNER JOIN  WO_DETAIL       d   ON  d.ref_wo        =   o.idriga
                            -----------------------------------------------------------------------
                            WHERE       wg.group_code   =       p_group_code
                                AND     wg.oper_code    LIKE    NVL(p_oper_code,'%')
                            -----------------------------------------------------------------------
                            GROUP BY    wg.org_code,wg.order_code, wg.oper_code,d.size_code
                            ;

    v_row                   VW_PREP_GRP_NOM_QTY%ROWTYPE;
    C_SEGMENT_CODE          CONSTANT VARCHAR2(30) :=    'VW_PREP_GRP_NOM_QTY';

BEGIN
    DELETE FROM VW_PREP_GRP_NOM_QTY;

    FOR x IN C_GRP_NOM      (p_group_code, p_oper_code)
    LOOP
        v_row.org_code      :=  x.org_code;
        v_row.group_code    :=  p_group_code;
        v_row.order_code    :=  x.order_code;
        v_row.size_code     :=  x.size_code;
        v_row.oper_code     :=  x.oper_code;
        v_row.nom_qty       :=  x.nom_qty;
        v_row.segment_code  :=  C_SEGMENT_CODE;

        INSERT INTO VW_PREP_GRP_NOM_QTY VALUES v_row;
    END LOOP;

END;

/***************************************************************************************************
    DDL:    18/03/2008  d   Create
/***************************************************************************************************/
FUNCTION f_get_grp_nom_qty      (   p_group_code        VARCHAR2,
                                    p_oper_code         VARCHAR2
                                )   RETURN              NUMBER
IS
    CURSOR C_NOM_QTY        (   p_group_code   VARCHAR2, p_oper_code VARCHAR2)
                            IS
                            SELECT      *
                            FROM        WORK_GROUP      g
                            ;

    v_result        NUMBER;
BEGIN

    RETURN v_result;
END;

--******************************
--- to be moved in Pkg_Item
--******************************

PROCEDURE p_bom_range_distribution(p_org_code VARCHAR2, p_item_code VARCHAR2, p_start_size VARCHAR2, p_end_size VARCHAR2)
IS

CURSOR C_SIZE       IS
                    SELECT size_code
                    FROM ITEM_SIZE   z
                    WHERE size_code BETWEEN  p_start_size AND p_end_size
                    ORDER BY 1
                    ;

CURSOR C IS
        SELECT      a.*, (CASE WHEN a.size_code BETWEEN a.start_size AND a.end_size THEN TO_CHAR(a.qta) ELSE ' ' END)  qty
        FROM        (
                    SELECT      b.father_code, b.child_code, i.description,i.puom, i.MAT_TYPE, i.start_size, i.end_size, z.size_code,b.qta
                    FROM        BOM_STD     b
                    INNER JOIN  ITEM        i ON i.org_code = b.org_code AND i.item_code = b.child_code AND i.flag_range = -1
                    CROSS JOIN  ITEM_SIZE   z
                    WHERE       b.FATHER_CODE= p_item_code
                        AND     z.size_code BETWEEN p_start_size AND p_end_size
                    ) a
        ORDER BY a.CHILD_CODE, a.size_code
        ;

v_row       TMP_GENERAL%ROWTYPE;
v_row_empty TMP_GENERAL%ROWTYPE;

BEGIN
    DELETE FROM TMP_GENERAL;

    FOR x IN C_SIZE
    LOOP
        v_row.txt50 := v_row.txt50 || SUBSTR(RPAD(x.size_code,3,' '),1,3);
    END LOOP;
    INSERT INTO TMP_GENERAL VALUES v_row;
    v_row_empty.txt49 := v_row.txt50;
    v_row   := v_row_empty;

    FOR x IN C
    LOOP
        IF v_row.txt01 IS NOT NULL AND x.child_code <> v_row.txt01 THEN
            -- must insert and reset the row variable
            INSERT INTO TMP_GENERAL VALUES v_row;
            v_row   :=  v_row_empty;
        END IF;

        v_row.txt01 := x.child_code;
        v_row.txt02 := x.description;
        v_row.txt03 := x.puom;
        v_row.txt04 := x.mat_type;
        v_row.txt05 := x.start_size;
        v_row.txt06 := x.end_size;
        v_row.txt50 := v_row.txt50 || SUBSTR(RPAD(x.qty,3,' '),1,3);

    END LOOP;

    IF v_row.txt01 IS NOT NULL THEN
            INSERT INTO TMP_GENERAL VALUES v_row;
    END IF;

END;


PROCEDURE p_grp_bom_distribution    (   p_group_code        VARCHAR2,
                                        p_start_size        VARCHAR2,
                                        p_end_size          VARCHAR2)

IS

    CURSOR C_SIZE       IS
                        SELECT size_code
                        FROM ITEM_SIZE   z
                        WHERE size_code BETWEEN  p_start_size AND p_end_size
                        ORDER BY 1
                        ;

    CURSOR C        (p_group_code VARCHAR2, p_start_size VARCHAR2, p_end_size VARCHAR2)
                    IS
                    SELECT      b.item_code,
                                i.description,
                                i.puom,
                                i.MAT_TYPE,
                                i.start_size,
                                i.end_size, z.size_code,b.qta,
                                i.flag_range
                    --------------------------------------------------------------------------------
                    FROM        BOM_GROUP   b
                    INNER JOIN  ITEM        i   ON  i.org_code      =   b.org_code
                                                AND i.item_code     =   b.item_code
                    CROSS JOIN  ITEM_SIZE   z
                    --------------------------------------------------------------------------------
                    WHERE       b.group_code    =       p_group_code
                        AND     z.size_code     BETWEEN p_start_size AND p_end_size
                    --------------------------------------------------------------------------------
                    ORDER BY b.item_code, z.size_code
                    ;

    v_row       TMP_GENERAL%ROWTYPE;
    v_row_empty TMP_GENERAL%ROWTYPE;
    v_txt_qty   VARCHAR2(10);

BEGIN
    DELETE FROM TMP_GENERAL;

    FOR x IN C_SIZE
    LOOP
        v_row.txt50 := v_row.txt50 || SUBSTR(RPAD(x.size_code,3,' '),1,3);
    END LOOP;
    INSERT INTO TMP_GENERAL VALUES v_row;
    v_row_empty.txt49 := v_row.txt50;
    v_row   := v_row_empty;

    FOR x IN C(p_group_code, p_start_size, p_end_size)
    LOOP
        IF v_row.txt01 IS NOT NULL AND x.item_code <> v_row.txt01 THEN
            -- must insert and reset the row variable
            INSERT INTO TMP_GENERAL VALUES v_row;
            v_row   :=  v_row_empty;
        END IF;

        IF x.flag_range = 0 THEN
            v_txt_qty   :=  SUBSTR(RPAD(TO_CHAR(x.qta),3,' '),1,3);
        ELSE
            IF x.size_code BETWEEN x.start_size AND x.end_size THEN
                v_txt_qty   :=  SUBSTR(RPAD(TO_CHAR(x.qta),3,' '),1,3);
            ELSE
                v_txt_qty   :=  RPAD(' ',3,' ');
            END IF;
        END IF;

        v_row.txt01 := x.item_code;
        v_row.txt02 := x.description;
        v_row.txt03 := x.puom;
        v_row.txt04 := x.mat_type;
        v_row.txt05 := x.start_size;
        v_row.txt06 := x.end_size;
        v_row.txt50 := v_row.txt50 || v_txt_qty;

    END LOOP;

    IF v_row.txt01 IS NOT NULL THEN
            INSERT INTO TMP_GENERAL VALUES v_row;
    END IF;

END;


PROCEDURE p_rep_grp_sheet_size_distr    (   p_group_code VARCHAR2)
IS

    CURSOR C_LINES      (   p_group_code    VARCHAR2)
                        IS
                        SELECT      o.idriga,
                                    d.size_code         ,
                                    MAX(o.order_code)   order_code,
                                    MAX(o.item_code)    item_code,
                                    MAX(i.description)  description,
                                    MAX(i.root_code)    root_code,
                                    MAX(d.qta)          qta,
                                    SUM(MAX(d.qta)) OVER (PARTITION BY MAX(o.order_code)) total_bola,
                                    MAX(o.client_lot)   client_lot,
                                    MAX(o.note)         order_note,
                                    MAX(o.client_code)  client_code,
                                    MAX(n.flag_Q2)      n_flag_Q2,
                                    MAX(o.season_code)  season_code
                        ------------------------------------------------------------------------
                        FROM        WO_GROUP        wg
                        INNER JOIN  WORK_ORDER      o   ON  o.org_code      =   wg.org_code
                                                        AND o.order_code    =   wg.order_code
                        INNER JOIN  WO_DETAIL       d   ON  d.ref_wo        =   o.idriga
                        INNER JOIN  ITEM            i   ON  i.org_code      =   o.org_code
                                                        AND i.item_code     =   o.item_code
                        LEFT JOIN   ORGANIZATION    n   ON  n.org_code      =   o.client_code
                        ------------------------------------------------------------------------
                        WHERE       wg.group_code   =   p_group_code
                        GROUP BY    o.idriga, d.size_code
                        ORDER BY    order_code,size_code
                       ;


    CURSOR  C_GROUP_PIECES_SIZE (   p_group_code    VARCHAR2)
                        IS
                        SELECT      d.size_code             size_code,
                                    SUM(d.qta)              qta,
                                    SUM(d.qta_complet)      qta_complet
                        -------------------------------------------------------------------------
                        FROM        WORK_ORDER      o
                        INNER JOIN  WO_DETAIL       d   ON  d.ref_wo    =   o.idriga
                        -------------------------------------------------------------------------
                        WHERE       EXISTS  (   SELECT      1
                                                FROM        WO_GROUP        wg
                                                WHERE       wg.group_code   =   p_group_code
                                                    AND     wg.org_code     =   o.org_code
                                                    AND     wg.order_code   =   o.order_code
                                            )
                        GROUP BY d.size_code
                        ORDER BY d.size_code
                        ;

    TYPE type_it2       IS TABLE OF INTEGER INDEX BY ITEM_SIZE.size_code%TYPE;
    its                 type_it2;
    TYPE type_it1       IS TABLE OF  VW_REP_GRP_SHEET_SIZE_DISTR%ROWTYPE INDEX BY BINARY_INTEGER;
    it                  type_it1;
    v_row_com           WORK_GROUP%ROWTYPE;
    v_row_org           ORGANIZATION%ROWTYPE;
    v_idx               PLS_INTEGER := 0;
    v_order_code        WORK_ORDER.order_code%TYPE;
    v_total             INTEGER := 0;
    v_item_var          VARCHAR2(1000);
    v_picture_path      VARCHAR2(1000);

    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_REP_GRP_SHEET_SIZE_DISTR';

BEGIN

    IF p_group_code IS NULL THEN Pkg_Lib.p_rae('Nu sunteti pozitionat pe o comanda valida !!!'); END IF;

    v_row_com.group_code := p_group_code;
    IF Pkg_Get2.f_get_work_group_2(v_row_com) THEN NULL ; END IF;
    v_row_org.org_code := v_row_com.org_code;
    IF Pkg_Get2.f_get_organization_2(v_row_org) THEN NULL; END IF ;
    v_picture_path := Pkg_Env.f_get_picture_path(v_row_com.org_code);


    it(0).line_order    := 0;
    it(0).order_code    := 'NUMAR BOLA';
    it(0).total_bola    := 'TOTAL';
    it(0).description   := 'DESCRIERE';
    it(0).item_code     := 'COD PRODUS';
    it(0).client_lot    := 'LOT CLIENT';

    v_idx := -1;
    FOR x IN C_GROUP_PIECES_SIZE(p_group_code) LOOP

        v_idx := v_idx + 1;
        IF v_idx > 30 THEN Pkg_Lib.p_rae('Raportul poate afisa pana la 31 de marimi, pe aceasta comanda aveti mai mult de 31 de marimi !!!'); END IF;
        its(x.size_code) := v_idx;

        it(0).segment_code      :=  C_SEGMENT_CODE;


        CASE v_idx
            WHEN 0 THEN it(0).s00     := x.size_code;
            WHEN 1 THEN it(0).s01     := x.size_code;
            WHEN 2 THEN it(0).s02     := x.size_code;
            WHEN 3 THEN it(0).s03     := x.size_code;
            WHEN 4 THEN it(0).s04     := x.size_code;
            WHEN 5 THEN it(0).s05     := x.size_code;
            WHEN 6 THEN it(0).s06     := x.size_code;
            WHEN 7 THEN it(0).s07     := x.size_code;
            WHEN 8 THEN it(0).s08     := x.size_code;
            WHEN 9 THEN it(0).s09     := x.size_code;
            WHEN 10 THEN it(0).s10    := x.size_code;
            WHEN 11 THEN it(0).s11    := x.size_code;
            WHEN 12 THEN it(0).s12    := x.size_code;
            WHEN 13 THEN it(0).s13    := x.size_code;
            WHEN 14 THEN it(0).s14    := x.size_code;
            WHEN 15 THEN it(0).s15    := x.size_code;
            WHEN 16 THEN it(0).s16    := x.size_code;
            WHEN 17 THEN it(0).s17    := x.size_code;
            WHEN 18 THEN it(0).s18    := x.size_code;
            WHEN 19 THEN it(0).s19    := x.size_code;
            WHEN 20 THEN it(0).s20    := x.size_code;
            WHEN 21 THEN it(0).s21    := x.size_code;
            WHEN 22 THEN it(0).s22    := x.size_code;
            WHEN 23 THEN it(0).s23    := x.size_code;
            WHEN 24 THEN it(0).s24    := x.size_code;
            WHEN 25 THEN it(0).s25    := x.size_code;
            WHEN 26 THEN it(0).s26    := x.size_code;
            WHEN 27 THEN it(0).s27    := x.size_code;
            WHEN 28 THEN it(0).s28    := x.size_code;
            WHEN 29 THEN it(0).s29    := x.size_code;
            WHEN 30 THEN it(0).s30    := x.size_code;

        END CASE;
    END LOOP;

    IF v_idx = -1 THEN Pkg_Lib.p_rae('Comanda nu este asociata cu nici o bola sau bolele nu au introduse marimi !!!'); END IF;

    v_idx := 0;
    FOR x IN C_LINES(p_group_code) LOOP
        IF Pkg_Lib.f_mod_c(v_order_code,x.order_code) THEN
            v_idx := v_idx +1;

            it(v_idx).segment_code  :=  C_SEGMENT_CODE;

            it(v_idx).line_order    :=  v_idx;
            it(v_idx).order_code    :=  x.order_code;
            it(v_idx).total_bola    :=  x.total_bola;
            it(v_idx).item_code     :=  x.item_code;
            it(v_idx).description   :=  x.description;
            it(v_idx).client_lot    :=  x.client_lot;
            it(v_idx).routing_text  :=  Pkg_Order.f_str_grp_rout_loc(v_row_com.idriga,'Y');
            it(v_idx).tehvar_text   :=  Pkg_Teh.f_str_item_variable(v_row_org.org_code,x.item_code);
            it(v_idx).order_note    :=  'Stagiunea:     '|| x.season_code||Pkg_Glb.C_NL||
                                        'Client final:  '|| x.client_code||
                                        (   CASE WHEN   x.n_flag_Q2 = 'N' THEN ' --> Nu se admite calitatea II '
                                            ELSE        NULL
                                            END )||
                                        Pkg_Glb.C_NL||
                                        x.order_note;
            it(0).picture_path   :=  v_picture_path||x.root_code||'.jpg';

        END IF;

        CASE its(x.size_code)
            WHEN 0 THEN it(v_idx).s00     := x.qta;
            WHEN 1 THEN it(v_idx).s01     := x.qta;
            WHEN 2 THEN it(v_idx).s02     := x.qta;
            WHEN 3 THEN it(v_idx).s03     := x.qta;
            WHEN 4 THEN it(v_idx).s04     := x.qta;
            WHEN 5 THEN it(v_idx).s05     := x.qta;
            WHEN 6 THEN it(v_idx).s06     := x.qta;
            WHEN 7 THEN it(v_idx).s07     := x.qta;
            WHEN 8 THEN it(v_idx).s08     := x.qta;
            WHEN 9 THEN it(v_idx).s09     := x.qta;
            WHEN 10 THEN it(v_idx).s10    := x.qta;
            WHEN 11 THEN it(v_idx).s11    := x.qta;
            WHEN 12 THEN it(v_idx).s12    := x.qta;
            WHEN 13 THEN it(v_idx).s13    := x.qta;
            WHEN 14 THEN it(v_idx).s14    := x.qta;
            WHEN 15 THEN it(v_idx).s15    := x.qta;
            WHEN 16 THEN it(v_idx).s16    := x.qta;
            WHEN 17 THEN it(v_idx).s17    := x.qta;
            WHEN 18 THEN it(v_idx).s18    := x.qta;
            WHEN 19 THEN it(v_idx).s19    := x.qta;
            WHEN 20 THEN it(v_idx).s20    := x.qta;
            WHEN 21 THEN it(v_idx).s21    := x.qta;
            WHEN 22 THEN it(v_idx).s22    := x.qta;
            WHEN 23 THEN it(v_idx).s23    := x.qta;
            WHEN 24 THEN it(v_idx).s24    := x.qta;
            WHEN 25 THEN it(v_idx).s25    := x.qta;
            WHEN 26 THEN it(v_idx).s26    := x.qta;
            WHEN 27 THEN it(v_idx).s27    := x.qta;
            WHEN 28 THEN it(v_idx).s28    := x.qta;
            WHEN 29 THEN it(v_idx).s29    := x.qta;
            WHEN 30 THEN it(v_idx).s30    := x.qta;

        END CASE;

        v_order_code := x.order_code;
        v_total      := v_total + x.qta;
    END LOOP;

    it(0).total  := v_total;

    DELETE FROM VW_REP_GRP_SHEET_SIZE_DISTR;

    IF v_idx > 0 THEN FORALL i IN 0..v_idx INSERT INTO VW_REP_GRP_SHEET_SIZE_DISTR VALUES it(i); END IF;

    COMMIT;
    EXCEPTION
       WHEN OTHERS THEN
       ROLLBACK;
       RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/***************************************************************************************************
    DDL:    22/03/2008  d   Create
/***************************************************************************************************/
PROCEDURE p_rep_grp_sheet   (   p_group_code    VARCHAR2)
---------------------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for the group worksheet in 2 views
--              VW_REP_GRP_SHEET - with information on the BOM and ROUTING
--
---------------------------------------------------------------------------------------------------
IS
    CURSOR C_REP            (   p_group_code    VARCHAR2)
                            IS
                            SELECT      r.seq_no        ,
                                        r.oper_code     ,
                                        r.note          r_note,
                                        r.whs_cons      r_whs_cons,
                                        r.milestone     r_milestone,
                                        b.org_code      ,
                                        b.item_code     ,
                                        b.oper_code_item,
                                        i.description   i_description,
                                        i.puom          i_puom,
                                        b.size_code     ,
                                        b.colour_code   ,
                                        c.description   c_description,
                                        b.start_size    ,
                                        b.end_size      ,
                                        b.qta_demand    ,
                                        b.qta           ,
                                        b.note          b_note,
                                        o.description   o_description
                            ------------------------------------------------------------------------
                            FROM        GROUP_ROUTING   r
                            LEFT JOIN   BOM_GROUP       b   ON  b.ref_group     =   r.ref_group
                                                            AND b.oper_code     =   r.oper_code
                            LEFT JOIN   ITEM            i   ON  i.org_code      =   b.org_code
                                                            AND i.item_code     =   b.item_code
                            LEFT JOIN   COLOUR          c   ON  c.org_code      =   b.org_code
                                                            AND c.colour_code   =   b.colour_code
                            INNER JOIN  OPERATION       o   ON  o.oper_code     =   r.oper_code
                            ------------------------------------------------------------------------
                            WHERE       r.group_code    =   p_group_code
                            ;

    v_row                   VW_REP_GRP_SHEET%ROWTYPE;
    C_SEGMENT               CONSTANT VARCHAR2(30) := 'VW_REP_GRP_SHEET';
    v_row_grp               WORK_GROUP%ROWTYPE;
    it_rep                  Pkg_Rtype.ta_vw_rep_grp_sheet;
    v_picture_path          VARCHAR2(1000);

BEGIN

    DELETE FROM VW_REP_GRP_SHEET;
    v_row_grp.group_code    :=  p_group_code;
    IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp) THEN
        Pkg_Lib.p_rae('Comanda '||p_group_code||' nu este definita in sistem!');
    END IF;


    v_row.segment_code          :=  C_SEGMENT;
    v_row.rep_title             :=  'Fisa comenzii';
    v_row.date_launch           :=  TO_CHAR(v_row_grp.date_launch,'dd/mm/yyyy');
    v_row.org_code              :=  v_row_grp.org_code;
    v_row.group_code            :=  p_group_code;
    v_row.group_code_barc       :=  '('||p_group_code||')';

    FOR x IN C_REP(p_group_code)
    LOOP
        IF x.r_milestone = 'N' AND x.item_code IS NULL AND x.r_note IS NULL THEN
            NULL;
        ELSE
            v_row.seq_no                :=  x.seq_no;
            v_row.oper_code             :=  NVL(x.o_description, x.oper_code);
            v_row.child_code            :=  x.item_code;
            v_row.child_oper            :=  x.oper_code_item;
            v_row.child_descr           :=  x.i_description;
            v_row.um                    :=  x.i_puom;
            v_row.size_code             :=  NVL(x.size_code,x.start_size||'-'||x.end_size);
            v_row.size_code             :=  Pkg_Prod.f_format_half_size(v_row.size_code,v_row_grp.org_code);
            v_row.colour_code           :=  x.colour_code||' '||x.c_description;
            v_row.start_size            :=  x.start_size;
            v_row.end_size              :=  x.end_size;
            v_row.whs_stock             :=  '';
            v_row.note_rout             :=  x.r_note;
            v_row.note_bom              :=  x.b_note;
            v_row.qty_unit              :=  x.qta;
            v_row.qty_tot               :=  x.qta_demand;
            v_row.qty_picked            :=  NULL;

            it_rep(it_rep.COUNT + 1)    :=  v_row;

        END IF;
    END LOOP;

    Pkg_Iud.p_vw_rep_grp_sheet_miud     ('I', it_rep);

    -- call the procedure that prepaires data for the subreport (orders/sizes + routing + teh)
    p_rep_grp_sheet_size_distr    (   p_group_code  =>  p_group_code);

END;


/***************************************************************************************************
    DDL:    26/03/2008  d   Create
/***************************************************************************************************/
PROCEDURE p_rep_grp_sheet   (   p_ref_group     NUMBER)
---------------------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for the group worksheet in 2 views
--              VW_REP_GRP_SHEET - with information on the BOM and ROUTING
--
---------------------------------------------------------------------------------------------------
IS
    v_row_grp               WORK_GROUP%ROWTYPE;
BEGIN

    IF p_ref_group IS NULL THEN
        Pkg_Lib.p_rae('Bola nu este Lansata!');
    END IF;

    v_row_grp.idriga        :=  p_ref_group;
    Pkg_Get.p_get_work_group(v_row_grp);

    Pkg_Order.p_rep_grp_sheet(v_row_grp.group_code);

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;

/**************************************************************************************************
    DDL:    24/03/2008  d Create
/**************************************************************************************************/
PROCEDURE p_ord_launch              (   p_ref_ord            NUMBER
                                    )
---------------------------------------------------------------------------------------------------
--  PURPOSE:    AUTO generate a GROUP for an ORDER     (1-1 situation )
---------------------------------------------------------------------------------------------------
IS

    v_row_ord       WORK_ORDER%ROWTYPE;
    v_ref_group     NUMBER;
    v_row_grp       WORK_GROUP%ROWTYPE;

BEGIN

    -- get ORDER info
    v_row_ord.idriga                        :=  p_ref_ord;
    Pkg_Get.p_get_work_order(v_row_ord,-1);

    IF v_row_ord.status <> 'V' THEN
        Pkg_App_Tools.P_Log('M','Bola '||v_row_ord.order_code||' nu este in stare Validata!','Nu se poate lansa');
    END IF;
    Pkg_Lib.p_rae_m('B');

    v_ref_group             :=  Pkg_Order.f_ord_get_ref_group(v_row_ord.org_code, v_row_ord.order_code);

    -- if it's a 1-1 situation
    IF v_ref_group IS NOT NULL THEN
        -- get the WORK_GROUP row
        v_row_grp.idriga        :=  v_ref_group;
        Pkg_Get.p_get_work_group(v_row_grp);

        Pkg_Order.p_grp_launch  (v_row_grp.group_code, FALSE);
    ELSE
        Pkg_Lib.p_rae('Bola nu este in relatie 1-1 cu o comanda interna !!!');
    END IF;

    -- put the order status in Launched
    v_row_ord.status            :=  'L';
    Pkg_Iud.p_work_order_iud('U', v_row_ord);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLERRM, SQLCODE));
END;


/*******************************************************************************************************
    DDL:    26/03/2008 d Create
/*******************************************************************************************************/
PROCEDURE p_ord_launch_undo     (   p_ref_ord  NUMBER)
--------------------------------------------------------------------------------------------------------
--  PURPOSE:    UNDO the 1-1 order launch
--------------------------------------------------------------------------------------------------------
IS
    v_ref_group             NUMBER;
    v_row_ord               WORK_ORDER%ROWTYPE;
    v_row_grp               WORK_GROUP%ROWTYPE;
BEGIN

    v_row_ord.idriga        :=  p_ref_ord;
    Pkg_Get.p_get_work_order(v_row_ord, -1);

    -- verify if the ORDER is Launched
    IF v_row_ord.status <> 'L' THEN
        Pkg_App_Tools.P_Log('M','Bola '||v_row_ord.order_code||' nu este in stare Lansata!','Nu se poate anula lansarea');
    END IF;
    Pkg_Lib.p_rae_m('B');

    v_ref_group             :=  Pkg_Order.f_ord_get_ref_group(v_row_ord.org_code, v_row_ord.order_code);

    -- if it's a 1-1 situation
    IF v_ref_group IS NOT NULL THEN
        v_row_grp.idriga    :=  v_ref_group;
        Pkg_Get.p_get_work_group(v_row_grp);

        -- UNDO Launch
        Pkg_Order.p_grp_launch_undo     (   p_group_code        =>  v_row_grp.group_code,
                                            p_flag_commit       =>  FALSE);

        -- put the ORDER in Initial status
        v_row_ord.status        :=  'V';
        Pkg_Iud.p_work_order_iud('U', v_row_ord);

    END IF;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/**************************************************************************************************
    DDL:    10/06/2008  d Create
/**************************************************************************************************/
PROCEDURE p_ord_validate            (   p_ref_ord            NUMBER,
                                        p_org_code_work     VARCHAR2
                                    )
---------------------------------------------------------------------------------------------------
--  PURPOSE:    AUTO generate a GROUP for an ORDER     (1-1 situation )
---------------------------------------------------------------------------------------------------
IS

    CURSOR C_ROUT       (p_routing_code VARCHAR2)
                        IS
                        SELECT      seq_no,
                                    MAX(md.oper_code) KEEP (DENSE_RANK  FIRST ORDER BY seq_no)
                                         OVER (PARTITION BY routing_code ) first_oper,
                                    MAX(md.oper_code) KEEP (DENSE_RANK  LAST ORDER BY seq_no)
                                         OVER (PARTITION BY routing_code ) last_oper
                        FROM        MACROROUTING_DETAIL     md
                        WHERE       md.routing_code         =   p_routing_code
                            AND     md.flag_selected        =   'Y'
                        ;

    v_row_rout      C_ROUT%ROWTYPE;
    v_row_ord       WORK_ORDER%ROWTYPE;
    v_found         BOOLEAN;
    v_org_code_work VARCHAR2(30);

BEGIN

    -- if no ORG_CODE_WORK set, put MYSELF organization
    v_org_code_work :=  NVL(p_org_code_work, Pkg_Nomenc.f_get_myself_org());

    -- get ORDER info
    v_row_ord.idriga                        :=  p_ref_ord;
    Pkg_Get.p_get_work_order(v_row_ord,-1);

    IF v_row_ord.status <> 'I' THEN
        Pkg_App_Tools.P_Log('M','Bola '||v_row_ord.order_code||' nu este in stare Initiala!','Nu se poate Valida');
    END IF;
    Pkg_Lib.p_rae_m('B');

    -- get the FIRST+LAST routing operation
    OPEN    C_ROUT(v_row_ord.routing_code);
    FETCH   C_ROUT INTO v_row_rout; v_found := C_ROUT%FOUND;
    CLOSE   C_ROUT;

    -- insert in VW_TRANSFER_ORACLE the ORDER line id
    DELETE FROM VW_TRANSFER_ORACLE;
    INSERT INTO VW_TRANSFER_ORACLE(numb01, segment_code) VALUES(v_row_ord.idriga, 'VW_TRANSFER_ORACLE');

    Pkg_Order.p_grp_generate    (   p_org_code      =>  v_row_ord.org_code,
                                    p_season_code   =>  v_row_ord.season_code,
                                    p_start_oper    =>  v_row_rout.first_oper,
                                    p_end_oper      =>  v_row_rout.last_oper,
                                    p_org_code_work =>  v_org_code_work,
                                    p_flag_validate =>  TRUE,
                                    p_flag_launch   =>  FALSE,
                                    p_flag_commit   =>  FALSE);

    -- put the order status in Launched
    v_row_ord.status            :=  'V';
    Pkg_Iud.p_work_order_iud('U', v_row_ord);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLERRM, SQLCODE));
END;

/*******************************************************************************************************
    DDL:    10/06/2008 d Create
/*******************************************************************************************************/
PROCEDURE p_ord_validate_undo     (   p_ref_ord  NUMBER)
--------------------------------------------------------------------------------------------------------
--  PURPOSE:    UNDO the 1-1 order validate action
--------------------------------------------------------------------------------------------------------
IS
    v_ref_group             NUMBER;
    v_row_ord               WORK_ORDER%ROWTYPE;
    v_row_grp               WORK_GROUP%ROWTYPE;
BEGIN

    v_row_ord.idriga        :=  p_ref_ord;
    Pkg_Get.p_get_work_order(v_row_ord, -1);

    -- verify if the ORDER is Launched
    IF v_row_ord.status <> 'V' THEN
        Pkg_App_Tools.P_Log('M','Bola '||v_row_ord.order_code||' nu este in stare Validata!','Nu se poate anula validarea');
    END IF;
    Pkg_Lib.p_rae_m('B');

    v_ref_group             :=  Pkg_Order.f_ord_get_ref_group(v_row_ord.org_code, v_row_ord.order_code);

    -- if it's a 1-1 situation
    IF v_ref_group IS NOT NULL THEN
        v_row_grp.idriga    :=  v_ref_group;
        Pkg_Get.p_get_work_group(v_row_grp);

        -- UNDO Launch
        Pkg_Order.p_grp_validate_undo   (   p_group_code        =>  v_row_grp.group_code,
                                            p_flag_commit       =>  FALSE);

        -- UNDO associate
        Pkg_Order.p_grp_associate_undo  (   p_group_code        =>  v_row_grp.group_code,
                                            p_flag_commit       =>  FALSE);

        -- put the ORDER in Initial status
        v_row_ord.status        :=  'I';
        Pkg_Iud.p_work_order_iud('U', v_row_ord);

    END IF;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;

/**********************************************************************************************
    DDL:    26/03/2008 d Create
/**********************************************************************************************/
FUNCTION f_ord_get_ref_group    (   p_org_code      VARCHAR2,
                                    p_order_code    VARCHAR2)
                                    RETURN          NUMBER
------------------------------------------------------------------------------------------------
--  PURPOSE:    return the REF_GROUP of the associated group for an ORDER, if
--              a) ORDER is associated on only one GROUP
--              b) on GROUP is associated only ORDER
------------------------------------------------------------------------------------------------
IS

    CURSOR C_WG             (p_org_code VARCHAR2, p_order_code VARCHAR2)
                            IS
                            SELECT      DISTINCT org_code, order_code, group_code
                            FROM        WO_GROUP    g
                            WHERE       group_code IN
                                        (
                                        SELECT      DISTINCT group_code
                                        FROM        WO_GROUP
                                        WHERE       order_code  =   p_order_code
                                            AND     org_code    =   p_org_code
                                        )
                            ;

    v_row_grp               WORK_GROUP%ROWTYPE;
    v_ref_grp               NUMBER;
    v_count                 PLS_INTEGER := 0;
    v_row_wg                C_WG%ROWTYPE;

BEGIN

    FOR x IN C_WG(p_org_code, p_order_code)
    LOOP
        v_count             :=  C_WG%rowcount;
        v_row_wg            :=  x;
    END LOOP;

    IF v_count <> 1 THEN
        v_ref_grp         :=  NULL;
    ELSE
        v_row_grp.org_code      :=  v_row_wg.org_code;
        v_row_grp.group_code    :=  v_row_wg.group_code;
        IF NOT Pkg_Get2.f_get_work_group_2(v_row_grp) THEN Pkg_Lib.p_rae('');END IF;
        v_ref_grp               :=  v_row_grp.idriga;
    END IF;

    RETURN v_ref_grp;
END;




PROCEDURE p_prep_work_demand    (p_org_code     VARCHAR2, p_season_code VARCHAR2)
IS

    CURSOR C_WORK_DEMAND    (   p_org_code  VARCHAR2, p_season_code VARCHAR2)
                            IS
                            -- demand on LAUNCHED ORDERS
                            SELECT      gr.org_code             org_code,
                                        gr.group_code           order_code,
                                        MAX(gr.status)          status,
                                        bg.item_code            item_code,
                                        bg.oper_code_item       oper_code_item,
                                        MAX(i.description)      i_description,
                                        gr.season_code          season_code,
                                        bg.size_code            size_code,
                                        bg.colour_code          colour_code,
                                        MAX(bg.qta_demand)      qty_tot,
                                        NVL(SUM(td.qty),0)      qty_cons,
                                        MAX(bg.oper_code)       oper_code
                            ---------------------------------------------------------------------------------
                            FROM        WORK_GROUP      gr
                            INNER JOIN  BOM_GROUP       bg  ON  bg.group_code   =   gr.group_code
                            INNER JOIN  ITEM            i   ON  i.org_code      =   bg.org_code
                                                            AND i.item_code     =   bg.item_code
                            LEFT JOIN   WHS_TRN_DETAIL  td  ON  td.group_code   =   gr.group_code
                                                            AND td.org_code     =   bg.org_code
                                                            AND td.item_code    =   bg.item_code
                                                            AND NVL(td.size_code,'-')
                                                                                =   NVL(bg.size_code,'-')
                                                            AND NVL(td.colour_code,'-')
                                                                                =   NVL(bg.colour_code,'-')
                                                            AND td.reason_code  =   Pkg_Glb.C_M_OPRDMP
                            ----------------------------------------------------------------------------------
                            WHERE       gr.status           IN  ('L','V')
                                AND     gr.season_code      =   p_season_code
                                AND     gr.org_code         =   p_org_code
                            ----------------------------------------------------------------------------------
                            GROUP BY    gr.org_code, gr.group_code,
                                        bg.item_code, bg.oper_code_item,
                                        gr.season_code,
                                        bg.size_code, bg.colour_code
                            UNION ALL
                            -- necesar pe bole nelansate
                            SELECT      w.org_code                                  org_code,
                                        w.order_code                                order_code,
                                        MAX(w.status)                               status,
                                        b.child_code                                item_code,
                                        NULL                                        oper_code_item,
                                        MAX(i.description),
                                        w.season_code                               season_code,
                                        DECODE(i.flag_size,-1, d.size_code,NULL)    size_code,
                                        b.colour_code                               colour_code,
                                        SUM(d.qta * b.qta)                          qty_tot,
                                        0                                           qty_tot,
                                        MAX(NVL(b.oper_code,i.oper_code))           oper_code
                            -------------------------------------------------------------------------------
                            FROM        WORK_ORDER      w
                            INNER JOIN  WO_DETAIL       d   ON  d.ref_wo        = w.idriga
                            INNER JOIN  BOM_STD         b   ON  b.org_code      = w.org_code
                                                            AND b.father_code   = w.item_code
                            INNER JOIN  ITEM            i   ON  i.org_code      = b.org_code
                                                            AND i.item_code     = b.child_code
                            ------------------------------------------------------------------------------
                            WHERE       w.status        =   'I'
                                    AND w.org_code      =   p_org_code
                                    AND w.season_code   =   p_season_code
                                    AND d.size_code     BETWEEN     NVL(NVL(b.start_size,i.start_size)  ,'00')
                                                        AND         NVL(NVL(b.end_size,i.end_size)      ,'99')
                            ------------------------------------------------------------------------------
                            GROUP BY    w.org_code,
                                        w.order_code,
                                        b.child_code,
                                        w.season_code,
                                        DECODE(i.flag_size,-1, d.size_code,NULL),
                                        b.colour_code
                            ORDER BY org_code, item_code
                            ;

    v_row   VW_PREP_WORK_DEMAND%ROWTYPE;

BEGIN
    DELETE FROM VW_PREP_WORK_DEMAND;

    FOR x IN C_WORK_DEMAND(p_org_code, p_season_code)
    LOOP
        v_row.season_code       :=  x.season_code;
        v_row.org_code          :=  x.org_code;
        v_row.order_code        :=  x.order_code;
        v_row.status            :=  x.status;
        v_row.item_code         :=  x.item_code;
        v_row.oper_code_item    :=  x.oper_code_item;
        v_row.description       :=  x.i_description;
        v_row.size_code         :=  x.size_code;
        v_row.colour_code       :=  x.colour_code;
        v_row.oper_code         :=  x.oper_code;
        v_row.qty_tot           :=  x.qty_tot;
        v_row.qty_demand        :=  GREATEST(x.qty_tot - x.qty_cons, 0);
        v_row.segment_code      :=  'VW_PREP_WORK_DEMAND';

        INSERT INTO VW_PREP_WORK_DEMAND VALUES v_row;
    END LOOP;

END;


PROCEDURE p_rep_work_demand     (   p_org_code      VARCHAR2,
                                    p_season_code   VARCHAR2)
IS
CURSOR C_LINES  IS
                SELECT      i.org_code, i.item_code, i.description, i.puom, i.oper_code,i.mat_type,
                            i.flag_size, i.flag_range, i.flag_colour,
                            A.season_code,A.colour_code,A.size_code,
                            A.qty_launched, A.qty_ini,A.qty_aloc, A.qty_notaloc,
                            A.qty_transit
                FROM        ITEM                i
                LEFT JOIN   (
                            SELECT      org_code,
                                        item_code,
                                        oper_code_item,
                                        season_code,
                                        size_code,
                                        colour_code,
                                        SUM(qty_launched)       qty_launched,
                                        SUM(qty_ini)            qty_ini,
                                        SUM(qty_notaloc)        qty_notaloc,
                                        SUM(qty_aloc)           qty_aloc,
                                        SUM(qty_transit)        qty_transit
                            FROM
                            (
                            -- DEMAND QUANTITIES ON LAUNCHED GROUPS
                            SELECT      org_code,
                                        item_code,
                                        oper_code_item,
                                        season_code,
                                        size_code,
                                        colour_code,
                                        qty_demand          qty_launched,
                                        0                   qty_ini,
                                        0                   qty_notaloc,
                                        0                   qty_aloc,
                                        0                   qty_transit
                            FROM        VW_PREP_WORK_DEMAND
                            WHERE       status              =   'L'
                                AND     season_code         =   p_season_code
                            UNION ALL
                            -- DEMAND QUANTITIES ON NOT LAUNCHED ORDERS
                            SELECT      org_code,
                                        item_code,
                                        oper_code_item,
                                        season_code,
                                        size_code,
                                        colour_code,
                                        0                   qty_launched,
                                        qty_demand          qty_ini,
                                        0                   qty_notaloc,
                                        0                   qty_aloc,
                                        0                   qty_transit
                            FROM        VW_PREP_WORK_DEMAND
                            WHERE       status              <>   'L'
                                AND     season_code         =   p_season_code
                            -- NOT ALOCATED STOCK
                            UNION ALL
                            SELECT      org_code,
                                        item_code,
                                        oper_code_item,
                                        season_code,
                                        size_code,
                                        colour_code,
                                        0                   qty_launched,
                                        0                   qty_ini,
                                        qty                 qty_notaloc,
                                        0                   qty_aloc,
                                        0                   qty_transit
                            FROM        STOC_ONLINE
                            WHERE       group_code          IS NULL
                                AND     season_code         =   p_season_code
                                AND     org_code            =   p_org_code
                            -- ALOCATED STOCK
                            UNION ALL
                            SELECT      org_code,
                                        item_code,
                                        oper_code_item,
                                        season_code,
                                        size_code,
                                        colour_code,
                                        0                   qty_launched,
                                        0                   qty_ini,
                                        0                   qty_notaloc,
                                        qty                 qty_aloc,
                                        0                   qty_transit
                            FROM        STOC_ONLINE
                            WHERE       group_code          IS NOT NULL
                                AND     season_code         =   p_season_code
                                AND     org_code            =   p_org_code
                            -- TRANSIT
                            UNION ALL
                            SELECT      d.org_code,
                                        d.item_code,
                                        d.oper_code_item,
                                        season_code,
                                        size_code,
                                        colour_code,
                                        0                   qty_launched,
                                        0                   qty_ini,
                                        0                   qty_notaloc,
                                        0                   qty_aloc,
                                        qty_doc             qty_transit
                            FROM        RECEIPT_DETAIL  d
                            INNER JOIN  RECEIPT_HEADER  h   ON  h.idriga    =   d.ref_receipt
                            WHERE       h.status            =   'I'
                                AND     d.season_code       =   p_season_code
                                AND     h.org_code          =   p_org_code
                            )
                            GROUP BY    org_code, item_code, oper_code_item,
                                        season_code,size_code, colour_code
                            ) A         ON  A.org_code      =   i.org_code
                                        AND A.item_code    =   i.item_code
                            -----------------------------------------------------------------------
                WHERE       i.make_buy          =   'A'
                    AND     i.org_code          =   p_org_code
                ;

    v_row       VW_REP_MATERIAL_DEMAND%ROWTYPE;

BEGIN

    -- CHECKS
    IF p_org_code IS NULL       THEN Pkg_App_Tools.P_Log('M','Nu ati precizat CLIENTUL!','Date lipsa'); END IF;
    IF p_season_code IS NULL    THEN Pkg_App_Tools.P_Log('M','Nu ati precizat STAGIUNEA!','Date lipsa'); END IF;
    Pkg_Lib.p_rae_m('B');

    DELETE FROM VW_REP_MATERIAL_DEMAND;

    -- prepair the demand quantities for ORG + SEASON
    p_prep_work_demand  (   p_org_code      =>  p_org_code,
                            p_season_code   =>  p_season_code);

    FOR x IN C_LINES
    LOOP
        v_row.org_code      :=  x.org_code;
        v_row.item_code     :=  x.item_code;
        v_row.description   :=  x.description;
        v_row.mat_type      :=  x.mat_type;
        v_row.puom          :=  x.puom;
        v_row.flag_size     :=  x.flag_size;
        v_row.flag_range    :=  x.flag_range;
        v_row.flag_colour   :=  x.flag_colour;

        v_row.oper_code     :=  x.oper_code;
        v_row.season_code   :=  p_season_code;
        v_row.colour_code   :=  x.colour_code;
        v_row.size_code     :=  x.size_code;
        v_row.qty_launched  :=  x.qty_launched;
        v_row.qty_ini       :=  x.qty_ini;
        v_row.qty_aloc      :=  x.qty_aloc;
        v_row.qty_notaloc   :=  x.qty_notaloc;
        v_row.qty_transit   :=  x.qty_transit;

        v_row.segment_code  :=  'VW_REP_MATERIAL_DEMAND';

        INSERT INTO VW_REP_MATERIAL_DEMAND VALUES v_row;
    END LOOP;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/**********************************************************************************************************
    DDL:    07/04/2008  d   Create date
/**********************************************************************************************************/
PROCEDURE p_rep_ord_label   ( p_org_code  VARCHAR2, p_order_code VARCHAR2)
------------------------------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for the LABELS printed on boxes, with ART_NO DESCRIPTIOn and SIZE
--  INPUT:      ORG + ORDER
--  OUTPUT:     view VW_REP_ORD_LABEL will have one line for every piece of FG
------------------------------------------------------------------------------------------------------------
IS
    CURSOR C_DETAIL     (   p_ref_wo   NUMBER)
                        IS
                        SELECT      *
                        FROM        WO_DETAIL
                        WHERE       ref_wo      =   p_ref_wo
                        ORDER BY    size_code
                        ;

    v_row_ord           WORK_ORDER%ROWTYPE;
    v_row_itm           ITEM%ROWTYPE;
    v_row               VW_REP_ORD_LABEL%ROWTYPE;

BEGIN

    DELETE FROM VW_REP_ORD_LABEL;

    v_row_ord.org_code      :=  p_org_code;
    v_row_ord.order_code    :=  p_order_code;
    v_row.segment_code      :=  'VW_REP_ORD_LABEL';
    IF NOT Pkg_Get2.f_get_work_order_2(v_row_ord) THEN
        Pkg_Lib.p_rae('Bola ' ||p_order_code||' nu exista in baza de date!');
    END IF;
    v_row_itm.org_code      :=  p_org_code;
    v_row_itm.item_code     :=  v_row_ord.item_code;
    IF NOT Pkg_Get2.f_get_item_2(v_row_itm) THEN
        Pkg_Lib.p_rae('Codul ' ||v_row.item_code||' nu exista in baza de date!');
    END IF;

    v_row.org_code          :=  p_org_code;
    v_row.order_code        :=  p_order_code;
    v_row.item_code         :=  v_row_ord.item_code;
    v_row.description       :=  v_row_itm.description;

    FOR x IN C_DETAIL   (v_row_ord.idriga)
    LOOP
            v_row.size_code :=  x.size_code;
        FOR i IN 1..x.qta
        LOOP
            INSERT INTO VW_REP_ORD_LABEL VALUES v_row;

        END LOOP;
    END LOOP;

END;


/**********************************************************************************************************
    DDL:    20/04/2008  d   Create date
/**********************************************************************************************************/
PROCEDURE p_ord_close   (       p_org_code      VARCHAR2,
                                p_order_code    VARCHAR2,
                                p_force         VARCHAR2)
------------------------------------------------------------------------------------------------------------
--  PURPOSE:    CLOSES an work order , verifying if all the quantities were already exported on it
------------------------------------------------------------------------------------------------------------
IS
    -- get the expedited quantity for an order
    CURSOR C_ORD_SIT    (   p_org_code      VARCHAR2,
                            p_order_code    VARCHAR2,
                            p_ref_wo        NUMBER)
                        IS
                        SELECT      MAX(nom_qty)        nom_qty,
                                    MAX(exp_qty)        exp_qty
                        FROM
                        (
                        SELECT      SUM(qta)            nom_qty,
                                    0                   exp_qty
                        ------------------------------------------------------------
                        FROM        WO_DETAIL           d
                        ------------------------------------------------------------
                        WHERE       d.ref_wo            =   p_ref_wo
                        --
                        UNION ALL
                        SELECT      0                   nom_qty,
                                    SUM(td.qty
                                        *
                                        td.trn_sign) exp_qty
                        ------------------------------------------------------------
                        FROM        WHS_TRN_DETAIL      td
                        ------------------------------------------------------------
                        WHERE       td.org_code         =   p_org_code
                            AND     td.order_code       =   p_order_code
                            AND     td.reason_code      =   Pkg_Glb.C_M_OSHPPF
                        )
                        ;

    v_row_ord           WORK_ORDER%ROWTYPE;
    v_row_grp           WORK_GROUP%ROWTYPE;
    v_row_sit           C_ORD_SIT%ROWTYPE;
    v_err_context       VARCHAR2(500) := 'Verificati';

BEGIN

    -- get WORK ORDER
    v_row_ord.org_code      :=  p_org_code;
    v_row_ord.order_code    :=  p_order_code;
    IF NOT Pkg_Get2.f_get_work_order_2(v_row_ord, -1) THEN NULL; END IF;

    -- get WORK GROUP
    v_row_grp.idriga        :=  f_ord_get_ref_group(p_org_code, p_order_code);
    Pkg_Get.p_get_work_group(v_row_grp, -1);

    OPEN    C_ORD_SIT(p_org_code, p_order_code, v_row_ord.idriga);
    FETCH   C_ORD_SIT INTO v_row_sit;
    CLOSE   C_ORD_SIT;

    -- checks
    v_err_context   :=  'Bola nu poate fi inchisa. Verificati: ';
    IF v_row_ord.status <> 'L' THEN
        Pkg_App_Tools.P_Log('M','Bola '||p_order_code||' nu este in stare (L)ansata !',v_err_context);
    END IF;
    IF v_row_grp.status <> 'L' THEN
        Pkg_App_Tools.P_Log('M','Comanda '||v_row_grp.group_code||'nu este in stare (L)ansata !',v_err_context);
    END IF;

    IF p_force <> 'Y' THEN
        -- verify if all the nominal quantity was shipped to the client
        IF v_row_sit.nom_qty > v_row_sit.exp_qty THEN
            Pkg_App_Tools.P_Log('M','Cantitatea expediata pana in acest moment nu a acoperit pontajul Bolei!',v_err_context);
        END IF;
    END IF;

    Pkg_Lib.p_rae_m('B');

    -- IUD
    v_row_ord.status            :=  'T';
    Pkg_Iud.p_work_order_iud    ('U',v_row_ord);

    v_row_grp.status            :=  'T';
    Pkg_Iud.p_work_group_iud    ('U',v_row_grp);


    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/**********************************************************************************************************
    DDL:    29/01/2009  d   Create date
/**********************************************************************************************************/
PROCEDURE p_ord_close_undo  (   p_org_code      VARCHAR2,
                                p_order_code    VARCHAR2,
                                p_force         VARCHAR2)
------------------------------------------------------------------------------------------------------------
--  PURPOSE:    UNOD CLOSES an work order
------------------------------------------------------------------------------------------------------------
IS

    v_row_ord           WORK_ORDER%ROWTYPE;
    v_row_grp           WORK_GROUP%ROWTYPE;
    v_err_context       VARCHAR2(500) := 'Verificati';

BEGIN

    -- get WORK ORDER
    v_row_ord.org_code      :=  p_org_code;
    v_row_ord.order_code    :=  p_order_code;
    IF NOT Pkg_Get2.f_get_work_order_2(v_row_ord, -1) THEN NULL; END IF;

    -- get WORK GROUP
    v_row_grp.idriga        :=  f_ord_get_ref_group(p_org_code, p_order_code);
    Pkg_Get.p_get_work_group(v_row_grp, -1);

    -- checks
    v_err_context   :=  'Bola nu poate fi redeschisa. Verificati: ';
    IF v_row_ord.status <> 'T' THEN
        Pkg_App_Tools.P_Log('M','Bola '||p_order_code||' nu este in stare (T)erminata !',v_err_context);
    END IF;
    IF v_row_grp.status <> 'T' THEN
        Pkg_App_Tools.P_Log('M','Comanda '||v_row_grp.group_code||'nu este in stare (T)erminata !',v_err_context);
    END IF;

    Pkg_Lib.p_rae_m('B');

    -- IUD
    v_row_ord.status            :=  'L';
    Pkg_Iud.p_work_order_iud    ('U',v_row_ord);

    v_row_grp.status            :=  'L';
    Pkg_Iud.p_work_group_iud    ('U',v_row_grp);


    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;

/**********************************************************************************************************
    DDL:    27/05/2008  z   Create date
/**********************************************************************************************************/
FUNCTION f_chk_order_in_group   (       p_org_code      VARCHAR2,
                                        p_order_code    VARCHAR2,
                                        p_group_code    VARCHAR2
                                   ) RETURN VARCHAR2
------------------------------------------------------------------------------------------------------------
--  PURPOSE:
------------------------------------------------------------------------------------------------------------
IS
    CURSOR  C_LINES( p_org_code      VARCHAR2,
                     p_order_code    VARCHAR2,
                     p_group_code    VARCHAR2)
            IS
            SELECT  1
            FROM    WO_GROUP
            WHERE       org_code    =   p_org_code
                    AND order_code  =   p_order_code
                    AND group_code  =   p_group_code
            ;

    v_result    VARCHAR2(1);
BEGIN
    v_result    :=  'N';
    FOR x IN  C_LINES(  p_org_code    ,
                        p_order_code  ,
                        p_group_code
                    )
    LOOP
        v_result    :=  'Y';
        EXIT;
    END LOOP;
    RETURN v_result;
END;

/***************************************************************************************************
    DDL:    02/12/2008  d   Create
/***************************************************************************************************/
PROCEDURE p_rep_grplist_sheet_sizes    (   p_group_list VARCHAR2)
IS

    CURSOR  C_REP        (p_grp_list VARCHAR2)
            IS
            SELECT      o.order_code,d.size_code,d.qta,
                        DENSE_RANK() OVER(ORDER BY d.size_code)     size_rank,
                        DENSE_RANK() OVER(ORDER BY o.order_code)    order_rank,
                        SUM(d.qta) OVER(PARTITION BY o.order_code)  tot_order_qty,
                        o.item_code, i.description
            FROM        WO_DETAIL       d
            INNER JOIN  WORK_ORDER      o   ON  o.idriga    =   d.ref_wo
            INNER JOIN  ITEM            i   ON  i.org_code  =   o.org_code
                                            AND i.item_code =   o.item_code
            WHERE       EXISTS  (
                                SELECT  1
                                FROM    WO_GROUP        wg
                                WHERE   wg.order_code   =   o.order_code
                                    AND wg.org_code     =   o.org_code
                                    AND wg.group_code   IN  (SELECT txt01
                                                            FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_grp_list,','))
                                                            )
                               )
            ORDER BY    o.order_code,d.size_code
            ;

    CURSOR C_LINES      (   p_group_code    VARCHAR2)
                        IS
                        SELECT      o.idriga,
                                    d.size_code         ,
                                    MAX(o.order_code)   order_code,
                                    MAX(o.item_code)    item_code,
                                    MAX(i.description)  description,
                                    MAX(i.root_code)    root_code,
                                    MAX(d.qta)          qta,
                                    SUM(MAX(d.qta)) OVER (PARTITION BY MAX(o.order_code)) total_bola,
                                    MAX(o.client_lot)   client_lot,
                                    MAX(o.note)         order_note,
                                    MAX(o.client_code)  client_code,
                                    MAX(n.flag_Q2)      n_flag_Q2,
                                    MAX(o.season_code)  season_code
                        ------------------------------------------------------------------------
                        FROM        WO_GROUP        wg
                        INNER JOIN  WORK_ORDER      o   ON  o.org_code      =   wg.org_code
                                                        AND o.order_code    =   wg.order_code
                        INNER JOIN  WO_DETAIL       d   ON  d.ref_wo        =   o.idriga
                        INNER JOIN  ITEM            i   ON  i.org_code      =   o.org_code
                                                        AND i.item_code     =   o.item_code
                        LEFT JOIN   ORGANIZATION    n   ON  n.org_code      =   o.client_code
                        ------------------------------------------------------------------------
                        WHERE       wg.group_code   =   p_group_code
                        GROUP BY    o.idriga, d.size_code
                        ORDER BY    order_code,size_code
                       ;


    CURSOR  C_GROUP_PIECES_SIZE (   p_group_code    VARCHAR2)
                        IS
                        SELECT      d.size_code             size_code,
                                    SUM(d.qta)              qta,
                                    SUM(d.qta_complet)      qta_complet
                        -------------------------------------------------------------------------
                        FROM        WORK_ORDER      o
                        INNER JOIN  WO_DETAIL       d   ON  d.ref_wo    =   o.idriga
                        -------------------------------------------------------------------------
                        WHERE       EXISTS  (   SELECT      1
                                                FROM        WO_GROUP        wg
                                                WHERE       wg.group_code   =   p_group_code
                                                    AND     wg.org_code     =   o.org_code
                                                    AND     wg.order_code   =   o.order_code
                                            )
                        GROUP BY d.size_code
                        ORDER BY d.size_code
                        ;

    TYPE type_it2       IS TABLE OF INTEGER INDEX BY ITEM_SIZE.size_code%TYPE;
    its                 type_it2;
    TYPE type_it1       IS TABLE OF  VW_REP_GRP_SHEET_SIZE_DISTR%ROWTYPE INDEX BY BINARY_INTEGER;
    it                  type_it1;
    v_row_com           WORK_GROUP%ROWTYPE;
    v_row_org           ORGANIZATION%ROWTYPE;
    v_idx               PLS_INTEGER := 0;
    v_order_code        WORK_ORDER.order_code%TYPE;
    v_total             INTEGER := 0;
    v_item_var          VARCHAR2(1000);
    v_picture_path      VARCHAR2(1000);

    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_REP_GRP_SHEET_SIZE_DISTR';

BEGIN

    it(0).line_order    := 0;
    it(0).order_code    := 'NUMAR BOLA';
    it(0).total_bola    := 'TOTAL';
    it(0).description   := 'DESCRIERE';
    it(0).item_code     := 'COD PRODUS';
    it(0).client_lot    := 'LOT CLIENT';
    it(0).segment_code      :=  C_SEGMENT_CODE;

    FOR x IN C_REP(p_group_list)
    LOOP

        IF x.size_rank > 30 THEN Pkg_Lib.p_rae('Raportul poate afisa pana la 31 de marimi, pe aceasta lista de comenzi aveti mai mult de 31 de marimi !!!'); END IF;


        -- order
        IF NOT it.EXISTS(x.order_rank) THEN
            it(x.order_rank).segment_code   :=  C_SEGMENT_CODE;
            it(x.order_rank).line_order     :=  x.order_rank;
            it(x.order_rank).order_code     :=  x.order_code;
            it(x.order_rank).total_bola     :=  x.tot_order_qty;
            it(x.order_rank).item_code      :=  x.item_code;
            it(x.order_rank).description    :=  x.description;
            it(x.order_rank).client_lot     :=  NULL;
            it(x.order_rank).routing_text   :=  NULL;
            it(x.order_rank).tehvar_text    :=  NULL;
            it(x.order_rank).order_note     :=  NULL;
            it(x.order_rank).picture_path   :=  '';
        END IF;


        CASE x.size_rank
            WHEN 0 THEN it(0).s00     := x.size_code;   it(x.order_rank).s00    :=  x.qta;
            WHEN 1 THEN it(0).s01     := x.size_code;   it(x.order_rank).s01    :=  x.qta;
            WHEN 2 THEN it(0).s02     := x.size_code;   it(x.order_rank).s02    :=  x.qta;
            WHEN 3 THEN it(0).s03     := x.size_code;   it(x.order_rank).s03    :=  x.qta;
            WHEN 4 THEN it(0).s04     := x.size_code;   it(x.order_rank).s04    :=  x.qta;
            WHEN 5 THEN it(0).s05     := x.size_code;   it(x.order_rank).s05    :=  x.qta;
            WHEN 6 THEN it(0).s06     := x.size_code;   it(x.order_rank).s06    :=  x.qta;
            WHEN 7 THEN it(0).s07     := x.size_code;   it(x.order_rank).s07    :=  x.qta;
            WHEN 8 THEN it(0).s08     := x.size_code;   it(x.order_rank).s08    :=  x.qta;
            WHEN 9 THEN it(0).s09     := x.size_code;   it(x.order_rank).s09    :=  x.qta;
            WHEN 10 THEN it(0).s10    := x.size_code;   it(x.order_rank).s10    :=  x.qta;
            WHEN 11 THEN it(0).s11    := x.size_code;   it(x.order_rank).s11    :=  x.qta;
            WHEN 12 THEN it(0).s12    := x.size_code;   it(x.order_rank).s12    :=  x.qta;
            WHEN 13 THEN it(0).s13    := x.size_code;   it(x.order_rank).s13    :=  x.qta;
            WHEN 14 THEN it(0).s14    := x.size_code;   it(x.order_rank).s14    :=  x.qta;
            WHEN 15 THEN it(0).s15    := x.size_code;   it(x.order_rank).s15    :=  x.qta;
            WHEN 16 THEN it(0).s16    := x.size_code;   it(x.order_rank).s16    :=  x.qta;
            WHEN 17 THEN it(0).s17    := x.size_code;   it(x.order_rank).s17    :=  x.qta;
            WHEN 18 THEN it(0).s18    := x.size_code;   it(x.order_rank).s18    :=  x.qta;
            WHEN 19 THEN it(0).s19    := x.size_code;   it(x.order_rank).s19    :=  x.qta;
            WHEN 20 THEN it(0).s20    := x.size_code;   it(x.order_rank).s20    :=  x.qta;
            WHEN 21 THEN it(0).s21    := x.size_code;   it(x.order_rank).s21    :=  x.qta;
            WHEN 22 THEN it(0).s22    := x.size_code;   it(x.order_rank).s22    :=  x.qta;
            WHEN 23 THEN it(0).s23    := x.size_code;   it(x.order_rank).s23    :=  x.qta;
            WHEN 24 THEN it(0).s24    := x.size_code;   it(x.order_rank).s24    :=  x.qta;
            WHEN 25 THEN it(0).s25    := x.size_code;   it(x.order_rank).s25    :=  x.qta;
            WHEN 26 THEN it(0).s26    := x.size_code;   it(x.order_rank).s26    :=  x.qta;
            WHEN 27 THEN it(0).s27    := x.size_code;   it(x.order_rank).s27    :=  x.qta;
            WHEN 28 THEN it(0).s28    := x.size_code;   it(x.order_rank).s28    :=  x.qta;
            WHEN 29 THEN it(0).s29    := x.size_code;   it(x.order_rank).s29    :=  x.qta;
            WHEN 30 THEN it(0).s30    := x.size_code;   it(x.order_rank).s30    :=  x.qta;

        END CASE;



    END LOOP;


    it(0).total  := v_total;

    DELETE FROM VW_REP_GRP_SHEET_SIZE_DISTR;

    IF it.COUNT > 0 THEN FORALL i IN 0..it.COUNT-1 INSERT INTO VW_REP_GRP_SHEET_SIZE_DISTR VALUES it(i); END IF;

    COMMIT;
    EXCEPTION
       WHEN OTHERS THEN
       ROLLBACK;
       RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/***************************************************************************************************
    DDL:    02/12/2008  d   Create
/***************************************************************************************************/
PROCEDURE p_rep_grplist_sheet   (   p_group_list    VARCHAR2)
---------------------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for the group worksheet in 2 views
--              VW_REP_GRP_SHEET - with information on the BOM and ROUTING
--
---------------------------------------------------------------------------------------------------
IS
    CURSOR C_REP            (   p_group_list   VARCHAR2)
                            IS
                            SELECT      r.oper_code         ,
                                        MAX(o.oper_seq)     o_oper_seq,
                                        MAX(r.milestone)    r_milestone,
                                        b.org_code          ,
                                        b.item_code         ,
                                        b.oper_code_item    ,
                                        MAX(i.description)  i_description,
                                        MAX(i.puom)         i_puom,
                                        b.size_code         ,
                                        b.colour_code       ,
                                        MAX(c.description)  c_description,
                                        MIN(b.start_size)   min_start_size,
                                        MAX(b.start_size)   max_start_size,
                                        MIN(b.end_size)     min_end_size,
                                        MIN(b.end_size)     max_end_size,
                                        SUM(b.qta_demand)   qta_demand,
                                        SUM(b.qta)          qta,
                                        MAX(o.description)  o_description
                            ------------------------------------------------------------------------
                            FROM        GROUP_ROUTING   r
                            LEFT JOIN   BOM_GROUP       b   ON  b.ref_group     =   r.ref_group
                                                            AND b.oper_code     =   r.oper_code
                            LEFT JOIN   ITEM            i   ON  i.org_code      =   b.org_code
                                                            AND i.item_code     =   b.item_code
                            LEFT JOIN   COLOUR          c   ON  c.org_code      =   b.org_code
                                                            AND c.colour_code   =   b.colour_code
                            INNER JOIN  OPERATION       o   ON  o.oper_code     =   r.oper_code
                            ------------------------------------------------------------------------
                            WHERE       r.group_code    IN (SELECT txt01
                                                            FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_group_list,',')))
                            GROUP BY    r.oper_code, b.org_code, b.item_code,
                                        b.oper_code_item, b.size_code, b.colour_code
                            ;

    CURSOR C_CHK            (p_grp_list VARCHAR)
                            IS
                            SELECT      MAX(g.org_code)     max_org_code,
                                        MIN(g.org_code)     min_org_code
                            FROM        TABLE(Pkg_Lib.F_Sql_Inlist(p_grp_list,',')) gl
                            INNER JOIN  WORK_GROUP  g   ON  g.group_code   =    gl.txt01
                            ;

    v_row                   VW_REP_GRP_SHEET%ROWTYPE;
    C_SEGMENT               CONSTANT VARCHAR2(30) := 'VW_REP_GRP_SHEET';
    it_rep                  Pkg_Rtype.ta_vw_rep_grp_sheet;
    v_picture_path          VARCHAR2(1000);
    v_row_chk               C_CHK%ROWTYPE;

BEGIN

    DELETE FROM VW_REP_GRP_SHEET;

    OPEN C_CHK (p_group_list); FETCH C_CHK INTO v_row_chk; CLOSE C_CHK;
    IF v_row_chk.min_org_code <> v_row_chk.max_org_code THEN
        Pkg_Err.p_rae('Raportul poate fi rulat doar pentru comenzi din aceeasi gestiune!');
    END IF;

    v_row.segment_code          :=  C_SEGMENT;
    v_row.rep_title             :=  'Fisa colectiva a comenzilor';
    v_row.date_launch           :=  'N/A';
    v_row.org_code              :=  v_row_chk.min_org_code;
    v_row.group_code            :=  'Vezi lista de mai jos';
    v_row.group_code_barc       :=  '';

    FOR x IN C_REP(p_group_list)
    LOOP
        IF x.r_milestone = 'N' AND x.item_code IS NULL THEN
            NULL;
        ELSE
            v_row.seq_no                :=  x.o_oper_seq;
            v_row.oper_code             :=  NVL(x.o_description, x.oper_code);
            v_row.child_code            :=  x.item_code;
            v_row.child_oper            :=  x.oper_code_item;
            v_row.child_descr           :=  x.i_description;
            v_row.um                    :=  x.i_puom;
            v_row.size_code             :=  NVL(x.size_code,x.min_start_size||'-'||x.max_end_size);
            v_row.size_code             :=  Pkg_Prod.f_format_half_size(v_row.size_code,x.org_code);
            v_row.colour_code           :=  x.colour_code||' '||x.c_description;
            v_row.start_size            :=  x.min_start_size;
            v_row.end_size              :=  x.max_end_size;
            v_row.whs_stock             :=  '';
            v_row.note_rout             :=  NULL;
            v_row.note_bom              :=  NULL;
            v_row.qty_unit              :=  x.qta;
            v_row.qty_tot               :=  x.qta_demand;
            v_row.qty_picked            :=  NULL;

            it_rep(it_rep.COUNT + 1)    :=  v_row;

        END IF;
    END LOOP;

    Pkg_Iud.p_vw_rep_grp_sheet_miud     ('I', it_rep);

    -- call the procedure that prepaires data for the subreport (orders/sizes + routing + teh)
    p_rep_grplist_sheet_sizes    (   p_group_list  =>  p_group_list);

END;

/***************************************************************************************************
    DDL:    03/12/2008  d   Create
/***************************************************************************************************/
PROCEDURE p_rep_grplist_sheet
---------------------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for the group worksheet in 2 views
--              VW_REP_GRP_SHEET - with information on the BOM and ROUTING
---------------------------------------------------------------------------------------------------
IS
    CURSOR C_GRP_LIST   IS
                        SELECT      distinct wg.group_code
                        FROM        WO_GROUP            wg
                        INNER JOIN  VW_TRANSFER_ORACLE  ol  ON  wg.order_code       =   ol.txt01
                        ;

    v_grp_list          VARCHAR2(2000);
BEGIN
    FOR x IN C_GRP_LIST
    LOOP
        v_grp_list      :=  v_grp_list || x.group_code||',';
    END LOOP;
    Pkg_Order.p_rep_grplist_sheet(v_grp_list);
END;

END;

/

/
