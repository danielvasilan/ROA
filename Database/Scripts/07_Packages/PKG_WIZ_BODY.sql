--------------------------------------------------------
--  DDL for Package Body PKG_WIZ
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_WIZ" 
AS

/*********************************************************************************
    DDL: 23/06/2008  d Create procedure 
/*********************************************************************************/
PROCEDURE p_get_step_values (   p_wiz_code          VARCHAR2, 
                                p_step_no           NUMBER,
                                it_step     IN OUT  Pkg_Glb.typ_varchar_varchar)
-----------------------------------------------------------------------------------
--  PURPOSE:    get the step values of a wizard in a PL/SQL table 
-----------------------------------------------------------------------------------
IS

    CURSOR C_GET_STEP       (       p_wiz_code      VARCHAR2,
                                    p_step_no       NUMBER)
                            IS
                            SELECT  *
                            FROM    VW_WIZ
                            WHERE   wiz_code    =   p_wiz_code
                                AND step_no     =   p_step_no
                            ;

BEGIN

    it_step.DELETE;

    FOR x IN C_GET_STEP     (p_wiz_code, p_step_no)
    LOOP
        it_step(x.row_key)  :=  x.row_value;
    END LOOP;

END;

/*********************************************************************************
    DDL: 23/06/2008  d Create procedure 
/*********************************************************************************/
PROCEDURE p_mov_pick_stock  (   p_wiz_code  VARCHAR2,
                                p_step_no   NUMBER,
                                p_org_code  VARCHAR2
                            )
---------------------------------------------------------------------------------------------
--  STEPS:  1)  warehouse to pick from  
--          2)  season code 
--          3)  stocks 
---------------------------------------------------------------------------------------------
IS

    CURSOR C_WHS            IS
                            SELECT      *
                            FROM        WAREHOUSE
                            ;

    CURSOR C_STOCK          IS
                            SELECT      v.*,
                                        i.description   i_description
                            FROM        vw_stoc_online  v
                            INNER JOIN  ITEM            i   ON  v.org_code  =   i.org_code
                                                            AND v.item_code =   i.item_code
                            ;

    CURSOR C_STEP           (p_wiz_code VARCHAR2, p_step_no NUMBER)
                            IS
                            SELECT      *
                            FROM        VW_WIZ
                            WHERE       wiz_code    =   p_wiz_code
                                AND     step_no     =   p_step_no
                            ;

    it_step                 Pkg_Glb.typ_varchar_varchar;
    v_row_trh               WHS_TRN%ROWTYPE;
    it_vw                   Pkg_Rtype.ta_vw_wiz;
    C_SEGMENT_CODE          VARCHAR2(30)    := 'VW_WIZ';
    v_whs_list              VARCHAR2(100);

BEGIN

    CASE p_step_no  WHEN    1   THEN

                            DELETE FROM vw_wiz;

                            --****************************************************************
                            -- verify the previous step (loading) 
                            --****************************************************************
                            p_get_step_values(p_wiz_code, 0, it_step);
                            -- verify the WHS_TRN where the details must be appended 
                            v_row_trh.idriga    :=  Pkg_Lib.f_table_value(it_step,'TRH_ID',0);
                            --Pkg_Get.p_get_whs_trn(v_row_trh);

                            --****************************************************************
                            -- load the next step ()   
                            --****************************************************************
                            FOR x IN C_WHS
                            LOOP
                                it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                                it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                                it_vw(it_vw.COUNT   ).row_key       :=  x.whs_code;
                                it_vw(it_vw.COUNT   ).row_value     :=  'N';
                                it_vw(it_vw.COUNT   ).txt11         :=  x.whs_code;
                                it_vw(it_vw.COUNT   ).txt12         :=  x.description;
                                it_vw(it_vw.COUNT   ).txt20         :=  'N';
                                it_vw(it_vw.COUNT   ).curr_info     :=  'Selectati magaziile pentru care vreti sa descarcati stocurile';
                                it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;
                            END LOOP;
                            Pkg_Iud.p_vw_wiz_miud('I', it_vw);

                    WHEN    2   THEN

                            --****************************************************************
                            -- verify the previous step (loading) 
                            --****************************************************************
                            p_get_step_values(p_wiz_code, 0, it_step);

                            --****************************************************************
                            -- load the next step ()   
                            --****************************************************************
                            FOR x IN C_STEP(p_wiz_code => p_wiz_code, p_step_no => 1)
                            LOOP
                                IF x.row_value = 'Y' THEN
                                    v_whs_list  :=  v_whs_list || x.row_key||',';
                                END IF;
                            END LOOP;

                            Pkg_Mov.P_Stoc_Online(  p_org_code      =>  p_org_code,
                                                    p_item_code     =>  NULL,
                                                    p_group_code    =>  NULL,
                                                    p_whs_code      =>  v_whs_list,
                                                    p_season_code   =>  NULL);
                            FOR x IN C_STOCK
                            LOOP
                                it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                                it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                                it_vw(it_vw.COUNT   ).row_key       :=  RPAD(x.item_code,20,' ')||
                                                                        RPAD(SUBSTR(x.i_description,1,19),20,' ')||
                                                                        RPAD(x.season_code,5,' ')||
                                                                        RPAD(NVL(x.colour_code,'-'),10,' ')||
                                                                        RPAD(NVL(x.size_code,'-')   ,5,' ') ||
                                                                        RPAD(x.qty,10,' ')
                                                                    ;
                                it_vw(it_vw.COUNT   ).txt11         :=  x.item_code;
                                it_vw(it_vw.COUNT   ).txt12         :=  x.oper_code_item;
                                it_vw(it_vw.COUNT   ).txt13         :=  x.i_description;
                                it_vw(it_vw.COUNT   ).txt14         :=  x.season_code;
                                it_vw(it_vw.COUNT   ).txt15         :=  x.colour_code;
                                it_vw(it_vw.COUNT   ).txt16         :=  x.size_code;
                                it_vw(it_vw.COUNT   ).txt17         :=  x.qty;

                                it_vw(it_vw.COUNT   ).prev_info     :=  'Magazii pas anterior:'||v_whs_list;
                                it_vw(it_vw.COUNT   ).curr_info     :=  'Setati cantitatile pe care vreti sa le descarcati si apasati NEXT';
                                it_vw(it_vw.COUNT   ).row_value     :=  x.qty;
                                it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;
                            END LOOP;
                            Pkg_Iud.p_vw_wiz_miud('I', it_vw);

                    ELSE
                            Pkg_Err.p_rae(p_wiz_code||' - '||p_step_no||' Pas neimplementat !!!');
    END CASE;

END;


/*********************************************************************************
    DDL: 24/06/2008  d Create procedure 
/*********************************************************************************/
PROCEDURE p_rec_ord_size    (   p_wiz_code  VARCHAR2,
                                p_step_no   NUMBER,
                                p_org_code  VARCHAR2
                            )
---------------------------------------------------------------------------------------------
--  STEPS:  1)  orders to pick on 
--          2)  oper_code_item  
--          3)  order sizes  
---------------------------------------------------------------------------------------------
IS

    CURSOR C_ORD            (p_org_code     VARCHAR2)
                            IS
                            SELECT      MAX(o.org_code)     org_code, 
                                        MAX(o.order_code)   order_code, 
                                        MAX(o.item_code)    item_code,
                                        MAX(i.description)  i_description,
                                        SUM(d.qta)          qty
                            -------------------------------------------------------------
                            FROM        WORK_ORDER      o
                            INNER JOIN  ITEM            i   ON  i.org_code  =   o.org_code
                                                            AND i.item_code =   o.item_code
                            LEFT JOIN   WO_DETAIL       d   ON  d.ref_wo    =   o.idriga
                            -------------------------------------------------------------
                            WHERE       o.org_code      =   p_org_code
                                AND     o.status        IN  ('I','L')
                            GROUP BY    o.idriga
                            ORDER BY    1,2
                            ;

    CURSOR C_DET            (p_org_code VARCHAR2, p_order_list  VARCHAR2)
                            IS
                            SELECT      o.org_code, o.order_code, o.item_code, 
                                        i.description   i_description,
                                        d.size_code, d.qta
                            ---------------------------------------------------------------
                            FROM        WORK_ORDER      o
                            INNER JOIN  ITEM            i   ON  i.org_code  =   o.org_code
                                                            AND i.item_code =   o.item_code
                            INNER JOIN  WO_DETAIL       d   ON  d.ref_wo    =   o.idriga
                            ---------------------------------------------------------------
                            WHERE       o.org_code      =   p_org_code
                                AND     o.order_code    IN  (   SELECT  txt01 
                                                                FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_order_list,'$')))
                            ;

    CURSOR C_STEP           (p_wiz_code VARCHAR2, p_step_no NUMBER)
                            IS
                            SELECT      *
                            FROM        VW_WIZ
                            WHERE       wiz_code    =   p_wiz_code
                                AND     step_no     =   p_step_no
                            ;

    it_step                 Pkg_Glb.typ_varchar_varchar;
    v_row_trh               WHS_TRN%ROWTYPE;
    it_vw                   Pkg_Rtype.ta_vw_wiz;
    C_SEGMENT_CODE          VARCHAR2(30)    := 'VW_WIZ';
    v_order_list            VARCHAR2(1000);

BEGIN

    CASE p_step_no  
        WHEN 1  THEN
  
                DELETE FROM vw_wiz;
  
                --****************************************************************
                -- verify the previous step (loading) 
                --****************************************************************
                p_get_step_values(p_wiz_code, 0, it_step);
                -- verify the WHS_TRN where the details must be appended 
                v_row_trh.idriga    :=  Pkg_Lib.f_table_value(it_step,'TRH_ID',0);
                --Pkg_Get.p_get_whs_trn(v_row_trh);
  
                --****************************************************************
                -- load the next step ()   
                --****************************************************************
                FOR x IN C_ORD(p_org_code)
                LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  Pkg_Lib.f_implode(  '$',
                                                                                x.org_code,
                                                                                x.order_code);
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.order_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.item_code;
                    it_vw(it_vw.COUNT   ).txt13         :=  x.i_description;
                    it_vw(it_vw.COUNT   ).txt14         :=  x.item_code;
                    it_vw(it_vw.COUNT   ).txt15         :=  x.qty;
  
                    it_vw(it_vw.COUNT   ).txt20         :=  'N';
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Selectati bola/bolele';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;
                END LOOP;
                Pkg_Iud.p_vw_wiz_miud('I', it_vw);
  
        WHEN    2   THEN
  
                --****************************************************************
                -- verify the previous step (loading) 
                --****************************************************************
                p_get_step_values(p_wiz_code, 0, it_step);
  
                --****************************************************************
                -- load the next step ()   
                --****************************************************************
                FOR x IN C_STEP(p_wiz_code => p_wiz_code, p_step_no => 1)
                LOOP
                    IF x.row_value = 'Y' THEN
                        v_order_list  :=  v_order_list || x.row_key||',';
                    END IF;
                END LOOP;
  
                FOR x IN C_DET (p_org_code      => p_org_code, 
                                p_order_list    => v_order_list)
                LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  Pkg_Lib.f_implode(  '$',
                                                                                x.org_code,
                                                                                x.order_code,
                                                                                x.size_code);
  
/*                    it_vw(it_vw.COUNT   ).txt11         :=  x.item_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.oper_code_item;
                    it_vw(it_vw.COUNT   ).txt13         :=  x.i_description;
                    it_vw(it_vw.COUNT   ).txt14         :=  x.season_code;
                    it_vw(it_vw.COUNT   ).txt15         :=  x.colour_code;
                    it_vw(it_vw.COUNT   ).txt16         :=  x.size_code;
                    it_vw(it_vw.COUNT   ).txt17         :=  x.qty;
  
                    it_vw(it_vw.COUNT   ).prev_info     :=  'Comenzi pas anterior:'||v_order_list;
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Setati cantitatile pe care vreti sa le descarcati si apasati NEXT';
                    it_vw(it_vw.COUNT   ).row_value     :=  x.qty;
*/
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;
                END LOOP;
                Pkg_Iud.p_vw_wiz_miud('I', it_vw);
  
        ELSE
                Pkg_Err.p_rae(p_wiz_code||' - '||p_step_no||' Pas neimplementat !!!');
    END CASE;

END;


/*********************************************************************************************
    23/06/2008 d create 
/*********************************************************************************************/
FUNCTION f_sql_vw_wiz   (   p_wiz_code  VARCHAR2,p_step_no  NUMBER)    RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for WIZ_PICK subform
----------------------------------------------------------------------------------------------
IS
    CURSOR     C_LINES      IS
                            SELECT  *
                            FROM    VW_WIZ
                            WHERE   wiz_code    =   p_wiz_code
                                AND step_no     =   p_step_no
                            ;

    v_row      tmp_frm      := tmp_frm();

BEGIN

    FOR X IN C_LINES LOOP

        v_row.idriga    :=  C_LINES%rowcount;
        v_row.dcn       :=  0;

        v_row.txt01     :=  p_wiz_code;
        v_row.txt02     :=  p_step_no;
        v_row.txt03     :=  x.row_key;
        v_row.txt04     :=  x.row_value;
        v_row.txt05     :=  x.curr_info;
        v_row.txt06     :=  x.prev_info;
        v_row.txt07     :=  x.flag_selected;
        v_row.txt11     :=  x.txt11;
        v_row.txt12     :=  x.txt12;
        v_row.txt13     :=  x.txt13;
        v_row.txt14     :=  x.txt14;
        v_row.txt15     :=  x.txt15;
        v_row.txt16     :=  x.txt16;
        v_row.txt17     :=  x.txt17;
        v_row.txt18     :=  x.txt18;
        v_row.txt19     :=  x.txt19;
        v_row.txt20     :=  x.txt20;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    23/06/2008 d create 
/*********************************************************************************************/
PROCEDURE p_vw_wiz_u    ( p_row   VW_wiz%ROWTYPE)
IS
BEGIN
    UPDATE  VW_WIZ 
    SET     row_value   =   p_row.row_value
    WHERE   wiz_code    =   p_row.wiz_code
        AND step_no     =   p_row.step_no
        AND row_key     =   p_row.row_key
    ;
    COMMIT;

END;

/*********************************************************************************************
    07/12/2008 d create 
/*********************************************************************************************/
PROCEDURE p_force_fin   (   p_wiz_code VARCHAR2, p_step_no   VARCHAR2)
-----------------------------------------------------------------------------------------------
--  
-----------------------------------------------------------------------------------------------
IS
    CURSOR C_1      IS
                    SELECT      *
                    FROM        ORGANIZATION
                    WHERE       flag_sbu        =   'Y'
                    ;

    CURSOR C_2      IS
                    SELECT      o.idriga,o.org_code, o.order_code, o.item_code,
                                i.description   i_description
                    FROM        WORK_ORDER  o
                    INNER JOIN  VW_WIZ      v   ON  v.row_key   =   o.org_code
                                                AND v.step_no   =   1
                    INNER JOIN  ITEM        i   ON  i.org_code  =   o.org_code
                                                AND i.item_code =   o.item_code   
                    WHERE       o.status        =   'L'
                        AND     v.row_value     =   'Y'
                    ORDER BY    o.order_code
                    ;

    CURSOR C_3      IS
                    SELECT      o.idriga            ,
                                d.size_code         , 
                                MAX(o.org_code)     org_code, 
                                MAX(o.order_code)   order_code, 
                                MAX(o.item_code)    item_code, 
                                MAX(o.oper_code_item)  oper_code_item,
                                MAX(s.qty)          qty_stock,
                                MAX(s.whs_code)     whs_stock,
                                MAX(s.oper_code_item)   s_oper_code_item,
                                MAX(d.qta)          qty_nom,
                                SUM(t.qty)          qty_fin
                    -----
                    FROM        WORK_ORDER      o
                    INNER JOIN  VW_WIZ          v   ON  v.row_key       =   o.idriga
                                                    AND v.step_no       =   2
                    INNER JOIN  WO_DETAIL       d   ON  d.ref_wo        =   o.idriga
                    LEFT JOIN   WHS_TRN_DETAIL  t   ON  t.org_code      =   o.org_code
                                                    AND t.order_code    =   o.order_code
                                                    AND t.size_code     =   d.size_code
                                                    AND t.reason_code   IN  (   Pkg_Glb.C_P_TFINPF,
                                                                                Pkg_Glb.C_P_TFINSP
                                                                            )
                    LEFT JOIN   STOC_ONLINE     s   ON  s.org_code      =   o.org_code
                                                    AND s.order_code    =   o.order_code
                                                    AND s.item_code     =   o.item_code
                                                    AND s.size_code     =   d.size_code
                                                    AND s.group_code    IS NOT NULL
                    -----
                    WHERE       v.row_value     =   'Y'
                    GROUP BY    o.idriga, d.size_code
                    ;

    CURSOR C_4      IS
                    SELECT      w.whs_code      , 
                                w.description   ,
                                k.description   k_description
                    FROM        WAREHOUSE       w
                    INNER JOIN  WAREHOUSE_CATEG k   ON  k.category_code =   w.category_code
                    WHERE       k.category_code IN  ('SHP','WIP','QLT')
                    ORDER BY    3,1
                    ;
                    
    it_step                 Pkg_Glb.typ_varchar_varchar;                    
    it_vw                   Pkg_Rtype.ta_vw_wiz;
    C_SEGMENT_CODE          VARCHAR2(30)    := 'VW_WIZ';
                    
BEGIN
    CASE p_step_no
        WHEN    1   THEN
            -- organizations 
            FOR x IN C_1
            LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  x.org_code;
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.org_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.org_name;
  
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Selectati gestiunea';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;

            END LOOP;
            Pkg_Iud.p_vw_wiz_miud('I', it_vw);
 
        WHEN    2   THEN
            -- 
            FOR x IN C_2
            LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  x.idriga;
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.org_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.order_code;
                    it_vw(it_vw.COUNT   ).txt13         :=  x.item_code;
                    it_vw(it_vw.COUNT   ).txt14         :=  x.i_description;
  
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Selectati bola';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;

            END LOOP;
            Pkg_Iud.p_vw_wiz_miud('I', it_vw);

        WHEN    3   THEN
            -- 
            FOR x IN C_3
            LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  x.idriga;
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.org_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.order_code;
                    it_vw(it_vw.COUNT   ).txt13         :=  x.item_code;
                    it_vw(it_vw.COUNT   ).txt14         :=  x.oper_code_item;
                    it_vw(it_vw.COUNT   ).txt15         :=  x.qty_nom;
                    it_vw(it_vw.COUNT   ).txt16         :=  x.qty_fin;
                    it_vw(it_vw.COUNT   ).txt17         :=  x.qty_stock;  
                    it_vw(it_vw.COUNT   ).txt18         :=  x.whs_stock;  
                    it_vw(it_vw.COUNT   ).txt19         :=  x.S_OPER_CODE_ITEM;  
  
  
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Completati cantitatile pentru pozitiile pe care '||
                                                            'doriti sa le fortati ca finite !!!';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;

            END LOOP;
            Pkg_Iud.p_vw_wiz_miud('I', it_vw);

        WHEN    4   THEN
            -- 
            FOR x IN C_4
            LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  x.whs_code;
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.whs_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.description;
                    it_vw(it_vw.COUNT   ).txt13         :=  x.k_description;  
  
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Completati cantitatile pentru pozitiile pe care '||
                                                            'doriti sa le fortati ca finite !!!';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;

            END LOOP;
            Pkg_Iud.p_vw_wiz_miud('I', it_vw);
        
        ELSE        
                    
            NULL;        
 
    END CASE;
END;

/*********************************************************************************************
    07/12/2008 d create 
/*********************************************************************************************/
PROCEDURE p_rec_ord_size   (   p_wiz_code VARCHAR2, p_step_no   VARCHAR2)
-----------------------------------------------------------------------------------------------
--  
-----------------------------------------------------------------------------------------------
IS
    -- SBU organizations 
    CURSOR C_1      IS
                    SELECT      *
                    FROM        ORGANIZATION
                    WHERE       flag_sbu        =   'Y'
                    ;

    -- launched work orders 
    CURSOR C_2      IS
                    SELECT      o.idriga,o.org_code, o.order_code, o.item_code,
                                i.description   i_description
                    FROM        WORK_ORDER  o
                    INNER JOIN  VW_WIZ      v   ON  v.row_key   =   o.org_code
                                                AND v.step_no   =   1
                    INNER JOIN  ITEM        i   ON  i.org_code  =   o.org_code
                                                AND i.item_code =   o.item_code   
                    WHERE       o.status        =   'L'
                        AND     v.row_value     =   'Y'
                    ORDER BY    o.order_code
                    ;

    -- sizes on WO 
    CURSOR C_3      IS
                    SELECT      o.idriga            ,
                                d.size_code         , 
                                MAX(o.org_code)     org_code, 
                                MAX(o.order_code)   order_code, 
                                MAX(o.item_code)    item_code, 
                                MAX(o.oper_code_item)  oper_code_item,
                                MAX(s.qty)          qty_stock,
                                MAX(s.whs_code)     whs_stock,
                                MAX(s.oper_code_item)   s_oper_code_item,
                                MAX(d.qta)          qty_nom,
                                SUM(t.qty)          qty_fin
                    -----
                    FROM        WORK_ORDER      o
                    INNER JOIN  VW_WIZ          v   ON  v.row_key       =   o.idriga
                                                    AND v.step_no       =   2
                    INNER JOIN  WO_DETAIL       d   ON  d.ref_wo        =   o.idriga
                    LEFT JOIN   WHS_TRN_DETAIL  t   ON  t.org_code      =   o.org_code
                                                    AND t.order_code    =   o.order_code
                                                    AND t.size_code     =   d.size_code
                                                    AND t.reason_code   IN  (   Pkg_Glb.C_P_TFINPF,
                                                                                Pkg_Glb.C_P_TFINSP
                                                                            )
                    LEFT JOIN   STOC_ONLINE     s   ON  s.org_code      =   o.org_code
                                                    AND s.order_code    =   o.order_code
                                                    AND s.item_code     =   o.item_code
                                                    AND s.size_code     =   d.size_code
                    -----
                    WHERE       v.row_value     =   'Y'
                    GROUP BY    o.idriga, d.size_code
                    ;

    CURSOR C_4      IS
                    SELECT      w.whs_code      , 
                                w.description   ,
                                k.description   k_description
                    FROM        WAREHOUSE       w
                    INNER JOIN  WAREHOUSE_CATEG k   ON  k.category_code =   w.category_code
                    WHERE       k.category_code IN  ('SHP','WIP','QLT')
                    ORDER BY    3,1
                    ;
                    
    it_step                 Pkg_Glb.typ_varchar_varchar;                    
    it_vw                   Pkg_Rtype.ta_vw_wiz;
    C_SEGMENT_CODE          VARCHAR2(30)    := 'VW_WIZ';
                    
BEGIN
    CASE p_step_no
        WHEN    1   THEN
            -- organizations 
            FOR x IN C_1
            LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  x.org_code;
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.org_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.org_name;
  
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Selectati gestiunea';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;

            END LOOP;
            Pkg_Iud.p_vw_wiz_miud('I', it_vw);
 
        WHEN    2   THEN
            -- 
            FOR x IN C_2
            LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  x.idriga;
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.org_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.order_code;
                    it_vw(it_vw.COUNT   ).txt13         :=  x.item_code;
                    it_vw(it_vw.COUNT   ).txt14         :=  x.i_description;
  
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Selectati bola';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;

            END LOOP;
            Pkg_Iud.p_vw_wiz_miud('I', it_vw);

        WHEN    3   THEN
            -- 
            FOR x IN C_3
            LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  x.idriga;
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.org_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.order_code;
                    it_vw(it_vw.COUNT   ).txt13         :=  x.item_code;
                    it_vw(it_vw.COUNT   ).txt14         :=  x.oper_code_item;
                    it_vw(it_vw.COUNT   ).txt15         :=  x.qty_nom;
                    it_vw(it_vw.COUNT   ).txt16         :=  x.qty_fin;
                    it_vw(it_vw.COUNT   ).txt17         :=  x.qty_stock;  
                    it_vw(it_vw.COUNT   ).txt18         :=  x.whs_stock;  
                    it_vw(it_vw.COUNT   ).txt19         :=  x.S_OPER_CODE_ITEM;  
  
  
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Completati cantitatile pentru pozitiile pe care '||
                                                            'doriti sa le fortati ca finite !!!';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;

            END LOOP;
            Pkg_Iud.p_vw_wiz_miud('I', it_vw);

        WHEN    4   THEN
            -- 
            FOR x IN C_4
            LOOP
                    it_vw(it_vw.COUNT+1 ).wiz_code      :=  p_wiz_code;
                    it_vw(it_vw.COUNT   ).step_no       :=  p_step_no;
                    it_vw(it_vw.COUNT   ).row_key       :=  x.whs_code;
                    it_vw(it_vw.COUNT   ).row_value     :=  'N';
                    it_vw(it_vw.COUNT   ).txt11         :=  x.whs_code;
                    it_vw(it_vw.COUNT   ).txt12         :=  x.description;
                    it_vw(it_vw.COUNT   ).txt13         :=  x.k_description;  
  
                    it_vw(it_vw.COUNT   ).curr_info     :=  'Completati cantitatile pentru pozitiile pe care '||
                                                            'doriti sa le fortati ca finite !!!';
                    it_vw(it_vw.COUNT   ).segment_code  :=  C_SEGMENT_CODE;

            END LOOP;
            Pkg_Iud.p_vw_wiz_miud('I', it_vw);
        
        ELSE        
                    
            NULL;        
 
    END CASE;
END;


/*********************************************************************************************
    07/12/2008  d   create 
/*********************************************************************************************/
PROCEDURE p_load_engine (   p_wiz_code  VARCHAR2, p_step_no INTEGER)
IS
BEGIN
    IF p_step_no = 1 THEN 
        DELETE FROM vw_wiz;
    END IF;
    
    CASE p_wiz_code
        -- force 
        WHEN    'WIZ_FORCE_FIN' THEN
            p_force_fin(p_wiz_code, p_step_no);
        ELSE
            NULL;
        
        
    END CASE;
    
END;





END;

/

/
