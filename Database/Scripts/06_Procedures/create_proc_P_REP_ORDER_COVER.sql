create or replace 
PROCEDURE "P_REP_ORDER_COVER" (   p_org_code      VARCHAR2,
                                                    p_season_code   VARCHAR2,
                                                    p_group_list    VARCHAR2,
                                                    p_status        VARCHAR2 := 'L,V',
                                                    p_item_code     VARCHAR2 := '')
IS

    CURSOR C_LINES  (p_org_code VARCHAR2,
                     p_group_list VARCHAR2, p_status VARCHAR2,
                     p_item_code VARCHAR2)
                    IS
                    SELECT      MAX(o.oper_seq)         oper_seq,
                                a.item_code,
                                MAX(a.description)      description,
                                MAX(a.oper_code)        oper_code,
                                a.size_code,
                                a.colour_code,
                                a.oper_code_item        ,
                                SUM(a.qty_tot)          qty_tot,
                                SUM(a.qty_demand)       qty_demand,
                                MAX(i.puom)             i_puom,
                                MAX(i.start_size)       i_start_size,
                                MAX(i.end_size)         i_end_size,
                                (   SELECT  SUM(v.qty)
                                    FROM    vw_stoc_online          v
                                    WHERE   v.org_code                  =   a.org_code
                                        AND v.item_code                 =   a.item_code
                                        AND NVL(v.oper_code_item,'-')   =   NVL(a.oper_code_item,'-')
                                        AND NVL(v.size_code,'-')        =   NVL(a.size_code,'-')
                                        AND NVL(v.colour_code,'-')      =   NVL(a.colour_code,'-')
                                        AND v.season_code   =           a.season_code
                                        AND v.group_code                IS NULL
                                )   qty_stock
                    -------------------------------------------------------------------------
                    FROM        VW_PREP_WORK_DEMAND     a
                    INNER JOIN  OPERATION               o   ON  o.oper_code     =   a.oper_code
                    INNER JOIN  ITEM                    i   ON  i.org_code      =   a.org_code
                                                            AND i.item_code     =   a.item_code
                    INNER JOIN  WORK_ORDER              w   ON  w.org_code      =   a.org_code
                                                            AND w.order_code    =   SUBSTR(a.order_code,5)
                    -------------------------------------------------------------------------
                    WHERE       (
                                a.order_code            IN  (SELECT txt01 FROM TABLE(Pkg_Lib.f_sql_inlist(p_group_list)))
                                OR
                                p_group_list IS NULL
                                )
                        AND     (
                                a.status                IN  (SELECT txt01 FROM TABLE(Pkg_Lib.f_sql_inlist(p_status)))
                                OR
                                p_status IS NULL
                                )
                        AND     a.org_code              =   p_org_code
                        AND     w.item_code             LIKE NVL(p_item_code,'%')
                    GROUP BY    a.org_code,a.item_code, a.season_code,a.size_code, a.colour_code,a.oper_code_item
                    ORDER BY    1
                    ;

    CURSOR C_OTH    (p_org_code VARCHAR2, p_group_list VARCHAR2)
                    IS
                    SELECT      a.item_code,
                                a.size_code,
                                a.colour_code,
                                a.oper_code_item        ,
                                SUM(a.qty_tot)          qty_tot,
                                SUM(a.qty_demand)       qty_demand
                    ------------------------------------------------------------------------------------------------------
                    FROM        VW_PREP_WORK_DEMAND     a
                    ------------------------------------------------------------------------------------------------------
                    WHERE       a.order_code            NOT IN  (SELECT txt01 FROM TABLE(Pkg_Lib.f_sql_inlist(p_group_list)))
                        AND     a.status                NOT IN  (SELECT txt01 FROM TABLE(Pkg_Lib.f_sql_inlist(p_status)))
--                        AND     a.status IN ('V','L')
                    ------------------------------------------------------------------------------------------------------
                    GROUP BY    a.item_code, a.size_code, a.colour_code,a.oper_code_item
                    ;

    TYPE typ_rep    IS TABLE OF VW_REP_GRP_DEMAND%ROWTYPE INDEX BY VARCHAR2(1000);
    v_idx           VARCHAR2(1000);
    it_rep          typ_rep;

BEGIN

    DELETE FROM VW_REP_GRP_DEMAND;

    IF      p_org_code IS NULL OR  p_season_code IS NULL THEN
        Pkg_Err.p_err('Gestiunea si stagiunea sunt obligatorii !', 'Parametri eronati');
    END IF;
    IF (p_status IS NOT NULL AND p_group_list IS NOT NULL) OR (p_status IS NULL AND p_group_list IS NULL) THEN
        Pkg_Err.p_err('Trebuie completat fie status-ul, fie lista de comenzi !', 'Parametri eronati');
    END IF;
    Pkg_Err.p_rae;

    -- call the procedure that prepaires data
    Pkg_Order.p_prep_work_demand(p_org_code, p_season_code);
    -- prepaire the stocks
    Pkg_Mov.P_Stoc_Online(p_org_code,NULL,NULL,NULL,p_season_code);

    FOR x IN C_LINES (p_org_code, p_group_list, p_status, p_item_code)
    LOOP
        v_idx := Pkg_Lib.f_implode('$',x.item_code,x.oper_code_item,x.size_code, x.colour_code);

        it_rep(v_idx).org_code          :=  p_org_code;
        it_rep(v_idx).group_code        :=  p_group_list;
        it_rep(v_idx).item_code         :=  x.item_code;
        it_rep(v_idx).description       :=  x.description;
        it_rep(v_idx).um                :=  x.i_puom;
        it_rep(v_idx).size_code         :=  NVL(x.size_code, x.i_start_size||'-'||x.i_end_size);
        it_rep(v_idx).colour_code       :=  x.colour_code;
        it_rep(v_idx).oper_code_item    :=  x.oper_code_item;
        it_rep(v_idx).qty_tot           :=  x.qty_tot;
        it_rep(v_idx).qty_demand        :=  x.qty_demand;
        it_rep(v_idx).qty_stock         :=  x.qty_stock;
        it_rep(v_idx).oper_seq          :=  x.oper_seq;
        it_rep(v_idx).oper_code         :=  x.oper_code;
        it_rep(v_idx).segment_code      :=  'VW_REP_GRP_DEMAND';

    END LOOP;

    -- compute the demanded quantities for the other orders
    FOR x IN C_OTH(p_org_code, p_group_list)
    LOOP
        v_idx := Pkg_Lib.f_implode('$',x.item_code,x.oper_code_item,x.size_code, x.colour_code);
        -- insert only the components that exists in the BOM of the groups sent as parameter
        IF it_rep.EXISTS(v_idx) THEN
            it_rep(v_idx).qty_demand_oth     :=  x.qty_demand;
        END IF;
    END LOOP;

    -- insert in the view
    v_idx   :=  it_rep.FIRST;
    WHILE v_idx IS NOT NULL
    LOOP
        INSERT INTO VW_REP_GRP_DEMAND VALUES it_rep(v_idx);
        v_idx       :=  it_rep.NEXT(v_idx);
    END LOOP;

    COMMIT;

    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
 