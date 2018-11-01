--------------------------------------------------------
--  DDL for Package PKG_CUR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_CUR" 
IS

CURSOR  C_SQL_INLIST(p_inlist   VARCHAR2) IS
        SELECT  txt01
        FROM    TABLE(Pkg_Lib.f_sql_inlist(p_inlist))
        ORDER BY txt01
        ;


CURSOR  C_WORK_ORDER_PIECES_TOTAL    (p_idriga WORK_ORDER.idriga%TYPE) IS
          ------------------------------------
            SELECT  SUM(d.qta)          qta_request,
                    SUM(d.qta_complet)  qta_complet
            FROM     WO_DETAIL d
            WHERE   d.ref_wo    =    p_idriga;

CURSOR  C_SIT_DEMAND_GROUP(p_idriga WO_GROUP.idriga%TYPE) IS
   ---------------------------------------------
            SELECT  b.item_code,b.size_code,b.colour_code,b.scrap_perc,
                    b.qta_demand qta_demand_nominal,
                    b.qta_picked,
                    GREATEST(b.qta_demand - b.qta_picked,0) qta_demand
            FROM    BOM_GROUP b
            WHERE   b.ref_group = p_idriga;


----------------------------------------------------------------------------------
-- cantitatile de materiale din magazii care pot fi luate in considerare pt disponibil
-- de fapt au flag_mrp setat

CURSOR C_QTA_ON_HAND(p_org_code VARCHAR2,p_item_code VARCHAR2,p_season_code VARCHAR2, p_size_code VARCHAR2, p_colour_code VARCHAR2) IS
         SELECT  SUM(s.qty) qta
         FROM       STOC_ONLINE     s
         INNER JOIN WAREHOUSE       w   ON  w.whs_code      =   s.whs_code
         INNER JOIN WAREHOUSE_CATEG c   ON  c.category_code =   w.category_code
         WHERE s.org_code                       = p_org_code
           AND s.item_code                      = p_item_code
           AND s.season_code                    = p_season_code
           AND c.qty_on_hand                    = 'Y'
           AND NVL(s.size_code,Pkg_Glb.c_rn)    =   NVL(p_size_code, Pkg_Glb.c_rn)
           AND NVL(s.colour_code,Pkg_Glb.c_rn)  =   NVL(p_colour_code,Pkg_Glb.c_rn);




CURSOR  C_COLOUR    (p_org_code VARCHAR2, p_colour_code VARCHAR2)
        ------------------------------------------------------------
        IS
        SELECT * FROM COLOUR WHERE org_code = p_org_code AND colour_code = p_colour_code;

CURSOR  C_GROUP_CONSUM     (p_idriga WO_GROUP.idriga%TYPE) IS
             ------------------------------------
          SELECT    b.child_code                                    item_code,
                    MAX(i.description),
                    b.org_code                                      org_code,
                    DECODE(i.flag_size,-1, d.size_code,NULL)        size_code,
                    MIN(NVL(b.start_size, i.start_size))          start_size,
                    MAX(NVL(b.end_size ,  i.end_size ))          end_size,
                    b.colour_code                                   colour_code,
                    SUM(d.qta * b.qta)                              qta, -- calculul se face cu cantitatea masurata si NU standard
                    MAX(b.oper_code)                                oper_code
        FROM        WORK_GROUP      g
        INNER JOIN  WO_GROUP        wg  ON g.group_code = wg.group_code
        INNER JOIN  WORK_ORDER      w   ON w.order_code = wg.order_code AND w.org_code = wg.org_code
        INNER JOIN  WO_DETAIL       d   ON d.ref_wo     = w.idriga
        INNER JOIN  BOM_STD         b   ON b.org_code   = w.org_code AND b.father_code = w.item_code AND b.oper_code = wg.oper_code
        INNER JOIN  ITEM            i   ON i.org_code = b.org_code AND i.item_code = b.child_code
        WHERE
                g.idriga        =   p_idriga
                -- daca componenta este pe plaja de marime ramane numai aceea pentru care marimea perechii se incadreaza in plaja
                -- are prioritate plaja precizata in norma standard, un cod pe norme standard diferite pot sa aiba plaje diferite
                AND d.size_code    BETWEEN NVL(NVL(b.start_size,i.start_size) ,  Pkg_Glb.C_SIZE_MIN  )
                  AND  NVL(NVL(b.end_size,i.end_size)  , Pkg_Glb.C_SIZE_MAX )
           GROUP BY  b.child_code, b.org_code,
                     -- daca codul este controlat pe marime se face gruparea pe marime altfel se face abstarctie de marime
                     DECODE(i.flag_size,-1, d.size_code,NULL),
                     b.colour_code
           ORDER BY b.child_code
     ;









CURSOR  C_PARAMETER (p_org_code VARCHAR2, p_par_code VARCHAR2) IS
                SELECT  *
                FROM    PARAMETER
                WHERE       org_code    =   p_org_code
                        AND par_code    =   p_par_code
                ORDER BY attribute01
                ;





---------------------------------------------------------------------------
-- for processing the import material in fifo logic
--
---------------------------------------------------------------------------
--------------------------------------------------------------------------------
CURSOR  C_MULTI_TABLE(p_table_name VARCHAR2)    IS
                SELECT  table_key, description, seq_no
                FROM    MULTI_TABLE
                WHERE       flag_active =   'Y'
                        AND table_name  =   p_table_name
                ORDER BY seq_no ASC, table_key ASC
                ;



-------------------------------------------------------------------------------------------



    CURSOR C_EX_ITM_STG (p_org_code VARCHAR2, p_item_code VARCHAR2)
                        IS
                        SELECT      1
                        FROM        STG_ITEM    i
                        WHERE       org_code    =   p_org_code
                            AND     item_code   =   p_item_code
                        ;

    CURSOR C_EX_ITM     (p_org_code VARCHAR2, p_item_code VARCHAR2)
                        IS
                        SELECT      1
                        FROM        ITEM        i
                        WHERE       org_code    =   p_org_code
                            AND     item_code   =   p_item_code
                        ;


END;
 

/

/
