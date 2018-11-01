--------------------------------------------------------
--  DDL for Package Body PKG_LOV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_LOV" 
IS

FUNCTION f_sql_lov_item (p_item VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR  C_LINES(        p_selector      VARCHAR2,
                            p_org_code      VARCHAR2,
                            p_description   VARCHAR2,
                            p_make_buy      VARCHAR2
                             ) IS
                SELECT  item_code, description, flag_size, flag_colour, flag_range, make_buy
                FROM    ITEM
                WHERE       org_code         =       p_org_code
                        AND (
                            UPPER(description)     LIKE    UPPER('%'||p_description ||'%')
                            OR
                            UPPER(item_code  )     LIKE    UPPER('%'||p_description ||'%')
                            OR
                            UPPER(mat_type  )      LIKE    UPPER('%'||p_description ||'%')
                            )
                        AND p_selector      =       'A'
                UNION ALL
                SELECT  item_code, description, flag_size, flag_colour, flag_range, make_buy
                FROM    ITEM
                WHERE       org_code     =       p_org_code
                        AND (
                            UPPER(description)     LIKE    UPPER('%'||p_description ||'%')
                            OR
                            UPPER(item_code  )     LIKE    UPPER('%'||p_description ||'%')
                            OR
                            UPPER(mat_type  )      LIKE    UPPER('%'||p_description ||'%')
                            )
                        AND make_buy        =       p_make_buy
                        AND p_selector      =       'B'
                ORDER BY make_buy,item_code
                ;

    v_row      tmp_cmb := tmp_cmb();
    v_selector          VARCHAR2(32000);

BEGIN

    CASE
        WHEN p_lov_par1 IS NOT NULL AND p_lov_par2 IS NULL      THEN
            v_selector  :=  'A';
        WHEN p_lov_par1 IS NOT NULL AND p_lov_par2 IS NOT NULL  THEN
            v_selector  :=  'B';
        ELSE    NULL;

    END CASE;

    FOR X IN C_LINES(v_selector,p_lov_par1,p_item, p_lov_par2) LOOP

        v_row.txt01    := x.item_code;
        v_row.txt02    := RPAD(SUBSTR(x.description,1,40),40,' ');
        IF x.flag_size = -1 THEN
           v_row.txt02    := v_row.txt02 || ' - MAR ' ;
        END IF;

        IF x.flag_colour = -1 THEN
           v_row.txt02    := v_row.txt02 || ' - CUL ' ;
        END IF;

        IF x.flag_range = -1 THEN
           v_row.txt02    := v_row.txt02 || ' - PLA ' ;
        END IF;

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
----------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_organization (p_org_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR     C_LINII(p_selector   VARCHAR2)  IS
                    SELECT  org_code, org_name, flag_myself, flag_lohn
                    FROM    ORGANIZATION
                    WHERE   
                            is_deleted = 'N'
                        AND
                        (   
                              (p_selector = 'C' AND (flag_client = 'Y' OR flag_myself = 'Y')) -- clients
                            OR
                              (p_selector = 'S' AND (flag_supply = 'Y' OR flag_lohn = 'Y')) -- suppliers
                            OR
                              (p_selector = 'A') -- select ALL
                            OR
                              (p_selector = 'L' AND flag_lohn = 'Y') -- lohn 
                            OR
                              (p_selector = 'P' AND (flag_myself = 'Y' OR flag_lohn = 'Y')) -- 
                            OR
                              (p_selector = 'B' AND flag_sbu = 'Y') -- business units
                        )

                    ORDER BY  flag_myself DESC , org_code
                    ;
    v_row           tmp_cmb := tmp_cmb();
    v_selector      VARCHAR2(32000) ;
BEGIN
    v_selector  :=  NVL(p_lov_par1,'A');
    FOR X IN C_LINII(v_selector) LOOP
        v_row.txt01    := X.org_code;
        v_row.txt02    := X.org_name;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/**********************************************************************************************************
    DDL:    07/12/2008  d   added category filter on lov_par2 
/**********************************************************************************************************/
FUNCTION f_sql_lov_warehouse (p_whs_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
-----------------------------------------------------------------------------------------------------------
--  INPUT:  p_lov_par1  =   selector    ->  NULL    =   all 
--                                      ->  S       =   stock warehouses (qty_on_hand) 
--                                      ->  P       =   production (WIP)
--             
--          p_lov_par2  =   category    if selector is null 
-----------------------------------------------------------------------------------------------------------
IS

    CURSOR  C_LINES(p_selector  VARCHAR2, p_category VARCHAR2) 
            IS
            SELECT  w.whs_code,w.description, c.intern, c.qty_on_hand
            FROM        WAREHOUSE       w
            INNER JOIN  WAREHOUSE_CATEG c   ON c.category_code  =   w.category_code
            WHERE       p_selector      =       'A'
                AND     w.category_code LIKE    NVL(p_category, '%')
            UNION ALL
            SELECT  w.whs_code,w.description, c.intern, c.qty_on_hand
            FROM        WAREHOUSE       w
            INNER JOIN  WAREHOUSE_CATEG c   ON c.category_code  =   w.category_code
            WHERE       c.qty_on_hand   =   'Y'
                    AND p_selector      =   'S'
            UNION ALL
            SELECT  w.whs_code,w.description, c.intern, c.qty_on_hand
            FROM        WAREHOUSE       w
            INNER JOIN  WAREHOUSE_CATEG c   ON c.category_code  =   w.category_code
            WHERE   (
                        c.intern        =   'N'
                    OR  c.category_code =   'WIP'
                    )
                    AND p_selector   =       'P'
            ORDER BY whs_code ASC
            ;

    v_row           tmp_cmb := tmp_cmb();
    v_selector      VARCHAR2(32000);
BEGIN

   CASE
       WHEN p_lov_par1 IS NULL THEN       v_selector  :=   'A';
       ELSE                               v_selector  :=   p_lov_par1;
   END CASE;

   FOR X IN C_LINES(v_selector, p_lov_par2) 
   LOOP
        v_row.txt01    := X.whs_code;
        v_row.txt02    := X.description ;
        pipe ROW(v_row);
   END LOOP;
   RETURN;
END;
---------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_movement_type (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR     C_LINII (p_trn_type VARCHAR2, p_selector VARCHAR2) IS
                    SELECT  trn_type, description,seq_no
                    FROM    MOVEMENT_TYPE
                    WHERE       trn_type LIKE p_trn_type ||'%'
                            AND p_selector  =   'A'
                    ---
                    UNION ALL
                    --
                    SELECT  trn_type, description, seq_no
                    FROM    MOVEMENT_TYPE
                    WHERE       trn_type LIKE p_trn_type ||'%'
                            AND flag_plan   =   'Y'
                            AND p_selector  =   'P'
                    --
                    ORDER BY seq_no, trn_type
                    ;

    v_row           tmp_cmb := tmp_cmb();
    v_selector      VARCHAR2(32000);
BEGIN

    v_selector  :=  NVL(p_lov_par1,'A');

    FOR x IN C_LINII(p_search, v_selector) LOOP
        v_row.txt01    := x.trn_type;
        v_row.txt02    := x.description;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
--------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_primary_uom (p_puom VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR  C_LINII  IS
                SELECT  *
                FROM    PRIMARY_UOM
                WHERE   puom LIKE p_puom ||'%';
    v_row   tmp_cmb := tmp_cmb();
    v_row_item  ITEM%ROWTYPE;
BEGIN
    IF p_lov_par1 IS NULL THEN
        FOR X IN C_LINII LOOP
            v_row.txt01    := X.puom;
            v_row.txt02    := X.description;

            pipe ROW(v_row);
        END LOOP;
    ELSE
        v_row_item.item_code    :=  p_lov_par1;
        v_row_item.org_code     :=  p_lov_par2;
        IF Pkg_Get2.f_get_item_2(v_row_item) THEN NULL; END IF;
        v_row.txt01    :=   '-';
        v_row.txt02    :=   'STERGERE';
        pipe ROW(v_row);
        v_row.txt01    :=   v_row_item.puom;
        v_row.txt02    :=   'UM primara';
        pipe ROW(v_row);
        IF v_row_item.suom IS NOT NULL THEN
            v_row.txt01   := v_row_item.suom;
            v_row.txt02   := 'UM secundara';
            pipe ROW(v_row);
        END IF;
    END IF;
    RETURN;
    EXCEPTION WHEN OTHERS THEN NULL;
END;

-------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_work_order (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
CURSOR     C_LINES(p_search VARCHAR2, p_org_code VARCHAR2, p_item_code VARCHAR2) IS
                    SELECT  *
                    FROM    WORK_ORDER
                    WHERE       org_code        =   p_org_code
                            AND item_code   LIKE    '%'||p_search ||'%'
                            AND item_code   LIKE    '%'||p_item_code ||'%'
                    ORDER BY order_code DESC
                    ;
v_row      tmp_cmb := tmp_cmb();

BEGIN
   FOR x IN C_LINES(p_search, p_lov_par1,p_lov_par2) LOOP
       v_row.txt01    := x.order_code;
       v_row.txt02    := x.item_code;
       pipe ROW(v_row);
   END LOOP;
   RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_work_group (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR     C_LINES(p_search VARCHAR2, p_org_code VARCHAR2,p_status VARCHAR2) IS
                            SELECT  g.group_code,
                                    MAX(w.item_code)  item_code,
                                    MAX(w.season_code) season_code,
                                    MAX(g.status)   status
                            FROM        WORK_GROUP      g
                            INNER JOIN  WO_GROUP        i
                                            ON  g.org_code      =   i.org_code
                                            AND g.group_code    =   i.group_code
                            INNER JOIN  WORK_ORDER      w
                                            ON  i.org_code      =   w.org_code
                                            AND i.order_code    =   w.order_code
                            WHERE       g.org_code      =       p_org_code
                                    AND g.status        LIKE    NVL(p_status,'%')
                                    AND
                                        (g.group_code   LIKE    '%'||UPPER(p_search)||'%'
                                         OR
                                         g.season_code  LIKE    '%'||UPPER(p_search)||'%'
                                         OR
                                         w.item_code    LIKE    '%'||UPPER(p_search)||'%'
                                        )
                            GROUP BY g.group_code
                            ORDER BY group_code DESC
                            ;

    v_row      tmp_cmb := tmp_cmb();
BEGIN
    FOR x IN C_LINES(p_search, p_lov_par1, p_lov_par2) LOOP
         v_row.txt01    := x.group_code;
         v_row.txt02    :=      RPAD(x.item_code,25)
                            ||'  -  '
                            ||  RPAD(x.season_code,10)
                            ||'  -  '
                            ||x.status;

         pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
-----------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_item_size (p_size_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
v_row      tmp_cmb := tmp_cmb();
CURSOR     C_LINII IS  SELECT * FROM ITEM_SIZE WHERE size_code LIKE p_size_code ||'%' ORDER BY size_code;
BEGIN
FOR X IN C_LINII LOOP
 v_row.txt01    := X.size_code;
 v_row.txt02    := X.description;

 pipe ROW(v_row);
END LOOP;
RETURN;
END;
----------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_cat_mat_type (p_categ_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR C_LINII  (p_selector VARCHAR2)
                    IS
                    SELECT      c.categ_code
                    FROM        CAT_MAT_TYPE    c
                    WHERE       c.categ_code    LIKE p_categ_code ||'%'
                        AND     c.flag_virtual  =   'N'
                        AND     p_selector      =   'N'
                    UNION ALL
                    SELECT      c.categ_code
                    FROM        CAT_MAT_TYPE    c
                    WHERE       c.categ_code    LIKE p_categ_code ||'%'
                        AND     flag_virtual    =   'Y'
                        AND     p_selector      =   'V'
                    UNION ALL
                    SELECT      c.categ_code
                    FROM        CAT_MAT_TYPE    c
                    WHERE       c.categ_code    LIKE p_categ_code ||'%'
                        AND     p_selector      =   'A'
                    ORDER BY    1
                    ;

    v_row      tmp_cmb := tmp_cmb();
BEGIN
    FOR X IN C_LINII(NVL(p_lov_par1,'N'))
    LOOP
        v_row.txt01    := X.categ_code;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
--------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_operation (p_oper_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
--
v_row      tmp_cmb := tmp_cmb();
CURSOR     C_LINII IS
                        SELECT *
                        FROM    OPERATION
                        WHERE   oper_code LIKE p_oper_code ||'%' ORDER BY oper_seq ASC;
BEGIN
FOR X IN C_LINII LOOP
 v_row.txt01    := X.oper_code;
 v_row.txt02    := X.description;

 pipe ROW(v_row);
END LOOP;
RETURN;
END;

--------------------------------------------------------------------------------------------------------
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
                                    AND
                                    (
                                        CATEGORY IS NULL
                                        OR
                                    CATEGORY        LIKE    NVL(p_category,'%')
                                    )
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
                        p_category =>   NULL
                    )
    LOOP
        v_row.txt01    := x.colour_code;
        v_row.txt02    := RPAD(x.description,25)|| ' - !!! '|| x.CATEGORY||' !!!';

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
----------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_app_user (p_user_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
v_row      tmp_cmb := tmp_cmb();
CURSOR     C_LINII IS
        SELECT  *
        FROM    APP_USER
        WHERE   NVL(default_oper,Pkg_Glb.C_RN) LIKE  p_LOV_PAR1 ||'%';

BEGIN
FOR X IN C_LINII LOOP
 v_row.txt01    := X.user_code;
 v_row.txt02    := RPAD(X.nume,15) ||X.prenume;

 pipe ROW(v_row);
END LOOP;
RETURN;
END;

--------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_operation_grp (p_oper_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
 v_row      tmp_cmb := tmp_cmb();
 CURSOR     C_LINII IS
      SELECT DISTINCT oper_code
      FROM GROUP_ROUTING
      WHERE ref_group IN (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_lov_par1)));

BEGIN
FOR X IN C_LINII LOOP

 v_row.txt01    := X.oper_code;

 pipe ROW(v_row);
END LOOP;
RETURN;
END;

---------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_warehuose_grp (p_whs_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
---------------------------------------------------------------------------------------------------------
-- magaziile pentru mai multe grupuri
---------------------------------------------------------------------------------------------------------
IS
 v_row      tmp_cmb := tmp_cmb();
 v_row_whs WAREHOUSE%ROWTYPE;
 CURSOR     C_LINII  IS
      SELECT DISTINCT whs_cons
      FROM GROUP_ROUTING
      WHERE ref_group IN (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_lov_par1)));
BEGIN
 FOR X IN C_LINII LOOP
  v_row_whs.whs_code := X.whs_cons;
  IF Pkg_Get2.f_get_warehouse_2(v_row_whs) THEN NULL; END IF;

  v_row.txt01  := X.whs_cons;
  v_row.txt02  := v_row_whs.description;

  pipe ROW(v_row);
 END LOOP;
 RETURN;
END;
---------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_work_season (p_season_code VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
v_row      tmp_cmb := tmp_cmb();
CURSOR     C_LINII IS  SELECT * FROM WORK_SEASON
                                WHERE season_code LIKE  p_season_code ||'%'
                                      AND org_code  =   p_lov_par1
                                      AND (
                                              (p_lov_par2 IS NULL)
                                              OR
                                              (p_lov_par2 IS NOT NULL AND flag_active=-1)
                                           );
BEGIN
FOR X IN C_LINII LOOP
 v_row.txt01    := X.season_code;
 v_row.txt02    := X.description;

 pipe ROW(v_row);
END LOOP;
RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_parameter (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
v_row      tmp_cmb := tmp_cmb();

CURSOR     C_LINII(p_org_code VARCHAR2) IS
                SELECT  *
                FROM    PARAMETER_CODE
                WHERE       org_code     =  p_org_code
                ORDER BY par_code ASC
                ;

BEGIN
FOR X IN C_LINII(p_lov_par1) LOOP
 v_row.txt01    := X.par_code;
 v_row.txt02    := SUBSTR(X.description,1,40) ;
 pipe ROW(v_row);
END LOOP;
RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_parameter_value (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

 CURSOR     C_LINII(p_org_code VARCHAR2, p_par_code VARCHAR2) IS
                 SELECT  *
                 FROM    PARAMETER
                 WHERE      org_code        =   p_org_code
                        AND par_code        =   p_par_code
                 ORDER BY attribute01 ASC
                 ;
 v_row      tmp_cmb := tmp_cmb();
BEGIN
 FOR X IN C_LINII(p_lov_par1, p_lov_par2) LOOP
   v_row.txt01    :=  X.par_key;
   v_row.txt02    :=  X.attribute01 ; -- || x.attribute03 || x.attribute04 ;
   pipe ROW(v_row);
 END LOOP;
 RETURN;
END;





------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_custom (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
v_row      tmp_cmb := tmp_cmb();

CURSOR     C_LINII(p_search VARCHAR2) IS
                SELECT  *
                FROM    CUSTOM
                WHERE   UPPER(description)      LIKE '%'||UPPER(p_search)||'%'
                        OR
                        UPPER(custom_code)      LIKE '%'||UPPER(p_search)||'%'
                ORDER BY custom_code ASC
                ;

BEGIN
FOR X IN C_LINII(p_search) LOOP
 v_row.txt01    := X.custom_code;
 v_row.txt02    := SUBSTR(X.description,1,100) ;
 pipe ROW(v_row);
END LOOP;
RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_delivery_condition (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
v_row      tmp_cmb := tmp_cmb();

CURSOR     C_LINII IS
                SELECT  *
                FROM    DELIVERY_CONDITION
                ORDER BY deliv_cond_code ASC
                ;

BEGIN
FOR X IN C_LINII LOOP
 v_row.txt01    := X.deliv_cond_code;
 v_row.txt02    := SUBSTR(X.description,1,50) ;
 pipe ROW(v_row);
END LOOP;
RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_setup_shipment (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
v_row      tmp_cmb := tmp_cmb();

CURSOR     C_LINII IS
                SELECT  *
                FROM    SETUP_SHIPMENT
                ORDER BY ship_type ASC
                ;

BEGIN
    FOR x IN c_linii LOOP
        v_row.txt01    := x.ship_type;
        v_row.txt02    := x.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_sales_family (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
v_row      tmp_cmb := tmp_cmb();

CURSOR     C_LINII(p_org_code VARCHAR2) IS
                SELECT  *
                FROM    SALES_FAMILY
                WHERE       org_code    =   p_org_code
                ORDER BY family_code ASC
                ;

BEGIN
FOR X IN C_LINII(p_lov_par1) LOOP
 v_row.txt01    := X.family_code;
 v_row.txt02    := X.description ;
 pipe ROW(v_row);
END LOOP;
RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_shipment (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR     C_LINII(p_org_code VARCHAR2) IS
                    SELECT  *
                    FROM    SHIPMENT_HEADER
                    WHERE       org_code    =   p_org_code
                            AND status      =   'I'
                    ORDER BY ship_code DESC
                    ;
    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR X IN C_LINII(p_lov_par1) LOOP
        v_row.txt01    := X.idriga;
        v_row.txt02    := X.ship_code || ' - ' ||to_char(x.ship_date);
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_year (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR     C_LINII IS
               SELECT DISTINCT TO_CHAR(calendar_day,'YYYY') lov_year
               FROM    CALENDAR
               ORDER BY lov_year
               ;

    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR X IN C_LINII LOOP
        v_row.txt01    := X.lov_year;
        v_row.txt02    := X.lov_year ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/******************************************************************************************
-- DDL: 04/01/2008 d added the possibility to return the MYSELF organization locations 
********************************************************************************************/
FUNCTION f_sql_lov_organization_loc (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
-------------------------------------------------------------------------------------------
--  PAR1 = if set, filter only the locations for ORG_CODE = PAR1 
--          otherwise, the myself locations 
-------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (p_org_code VARCHAR2) 
                    IS
                    SELECT      *
                    FROM        ORGANIZATION_LOC
                    WHERE       org_code    =   p_org_code
                    ORDER BY    loc_code
                    ;

    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN c_lines(NVL(p_lov_par1,Pkg_Nomenc.f_get_myself_org)) 
    LOOP
        v_row.txt01    := x.loc_code;
        v_row.txt02    := x.description ;
        IF x.city IS NOT NULL THEN
            v_row.txt02    := v_row.txt02 ||', '||x.city;
        END IF;
        IF x.address IS NOT NULL THEN
            v_row.txt02    := v_row.txt02 ||', '||x.address;
        END IF;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_cost (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    v_row           tmp_cmb := tmp_cmb();
    C_TABLE_NAME    VARCHAR2(32000)     :=  'COST';
BEGIN
    FOR X IN Pkg_Cur.C_MULTI_TABLE(C_TABLE_NAME) LOOP
        v_row.txt01    :=   X.table_key;
        v_row.txt02    :=   X.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_account_code (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    v_row           tmp_cmb := tmp_cmb();
    C_TABLE_NAME    VARCHAR2(32000)     :=  'ACC_CODE';
BEGIN
    FOR X IN Pkg_Cur.C_MULTI_TABLE(C_TABLE_NAME) LOOP
        v_row.txt01    :=   X.table_key;
        v_row.txt02    :=   X.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_date (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR  C_LINES IS
        SELECT  calendar_day
        FROM    CALENDAR
        ORDER BY 1 DESC
        ;
    v_row           tmp_cmb := tmp_cmb();
BEGIN

    v_row.txt01    :=   TO_CHAR(TRUNC(SYSDATE),'dd/mm/yy');
    v_row.txt02    :=   '>>' ;
    pipe ROW(v_row);
    v_row.txt01    :=   '-----------------------------------';
    v_row.txt02    :=   '>>' ;
    pipe ROW(v_row);
    FOR X IN C_LINES LOOP
        v_row.txt01    :=   TO_CHAR(X.calendar_day,'dd/mm/yy');
        v_row.txt02    :=   '>>' ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
------------------------------------------------------------------------------------------------------------
-- FUNCTION f_sql_lov_currency (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
-- IS
--
--     v_row           tmp_cmb := tmp_cmb();
--     C_TABLE_NAME    VARCHAR2(32000)     :=  'CURRENCY';
-- BEGIN
--     FOR X IN Pkg_Cur.C_MULTI_TABLE(C_TABLE_NAME) LOOP
--         v_row.txt01    :=   X.table_key;
--         v_row.txt02    :=   X.description ;
--         pipe ROW(v_row);
--     END LOOP;
--     RETURN;
-- END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_order_status (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    v_row           tmp_cmb := tmp_cmb();
    C_TABLE_NAME    VARCHAR2(32000)     :=  'ORD_STATUS';
BEGIN
    FOR X IN Pkg_Cur.C_MULTI_TABLE(C_TABLE_NAME) LOOP
        v_row.txt01    :=   X.table_key;
        v_row.txt02    :=   X.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_year_month (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    v_row           tmp_cmb := tmp_cmb();
    v_year          VARCHAR2(10);
    i               PLS_INTEGER;
    
BEGIN

    v_year  :=  NVL(p_lov_par1,TO_CHAR(SYSDATE,'YYYY'));

    FOR i IN 1..12
    LOOP
        v_row.txt01    :=   v_year || LPAD(i,2,'0');

        IF i = 1 THEN
            v_row.txt02    :=   v_year || ' ' ||TO_CHAR(TO_DATE(i,'mm'),'month');
        ELSE
            v_row.txt02    :=   '    ' || ' ' ||TO_CHAR(TO_DATE(i,'mm'),'month');
        END IF;
        pipe ROW(v_row);        
    END LOOP;

    v_year  := v_year - 1;
    FOR i IN 1..12
    LOOP
        v_row.txt01    :=   v_year || LPAD(i,2,'0');

        IF i = 1 THEN
            v_row.txt02    :=   v_year || ' ' ||TO_CHAR(TO_DATE(i,'mm'),'month');
        ELSE
            v_row.txt02    :=   '    ' || ' ' ||TO_CHAR(TO_DATE(i,'mm'),'month');
        END IF;
        pipe ROW(v_row);        
    END LOOP;

    RETURN;
END;
-------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_cost_center (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR C_LINES  (p_org_code VARCHAR2)
                    IS
                    SELECT      *
                    FROM        COSTCENTER
                    WHERE       org_code    LIKE    NVL(p_org_code, '%')
                    ;
    v_row           tmp_cmb             :=  tmp_cmb();
BEGIN
    FOR X IN C_LINES(p_lov_par1) 
    LOOP
        v_row.txt01    :=   X.costcenter_code;
        v_row.txt02    :=   x.org_code||'  '||X.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
-------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_multi_table (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    v_row           tmp_cmb := tmp_cmb();
BEGIN
    FOR X IN Pkg_Cur.C_MULTI_TABLE(NVL(p_lov_par1,'MULTI_TABLE')) LOOP
        v_row.txt01    :=   X.table_key;
        v_row.txt02    :=   X.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
/*********************************************************************************
    DDL: 19/02/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_lov_country (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR     C_LINES(p_search VARCHAR2) IS
               SELECT   country_code,description, flag_eu
               FROM     COUNTRY
               WHERE    UPPER(description) LIKE '%'||UPPER(p_search)||'%'
               ORDER BY country_code
               ;

    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINes(p_search) LOOP
        v_row.txt01    := x.country_code;
        v_row.txt02    := x.flag_eu ||' - '||x.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
/*********************************************************************************
    DDL: 20/02/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_lov_currency (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR     C_LINES(p_search VARCHAR2) IS
               SELECT   currency_code, description
               FROM     CURRENCY
               WHERE    description LIKE '%'||p_search||'%'
               ORDER BY currency_code
               ;

    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINes(p_search) LOOP
        v_row.txt01    := x.currency_code;
        v_row.txt02    := x.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
/*********************************************************************************
    DDL: 20/02/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_lov_setup_receipt (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR     C_LINES(p_search VARCHAR2) IS
               SELECT   i.*
               FROM     SETUP_RECEIPT i
               WHERE    description LIKE '%'||p_search||'%'
               ORDER BY receipt_type
               ;

    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINes(p_search) LOOP
        v_row.txt01    := x.receipt_type;
        v_row.txt02    := RPAD(x.description,35) ;
        IF x.whs_code IS NOT NULL THEN
            v_row.txt02    := v_row.txt02 ||' - '||x.whs_code;
        END IF;
        IF x.currency_code IS NOT NULL THEN
            v_row.txt02    := v_row.txt02 ||' - '||x.currency_code;
        END IF;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

------------------------------------------------------------------------------------------------------------
FUNCTION f_sql_lov_routing  (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    v_row      tmp_cmb := tmp_cmb();

    CURSOR C_LINES
                    IS
                    SELECT      *
                    FROM        MACROROUTING_HEADER     m
                    ORDER BY    m.routing_code
                    ;

BEGIN
    FOR X IN C_LINES
    LOOP
        v_row.txt01    :=   x.routing_code;
        v_row.txt02    :=   Pkg_Prod.f_get_routing_oper(x.routing_code);
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;


/****************************************************************************************************
    DDL:    added the OPERATION parameter
/****************************************************************************************************/
FUNCTION f_sql_lov_workcenter  (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
------------------------------------------------------------------------------------------------
--  PURPOSE:    WORKCENTERS list + description + location warehouse description
--  INPUT:      LOV_PAR1    =   If not null => Operation code.
--                              Will be shown only the workcenters that have the OPER_CODE
--                          = NULL => no filter, all the workcenters are shown
------------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (p_selector     VARCHAR2, p_oper_code    VARCHAR2)
                    IS
                    --  A => all the WORKCENTERS
                    SELECT      wc.workcenter_code  ,
                                wc.description      ,
                                wh.description      wh_description
                    FROM        WORKCENTER          wc
                    LEFT JOIN   WAREHOUSE           wh  ON  wh.whs_code     =   wc.whs_code
                    WHERE       p_selector          =   'A'
                    UNION ALL
                    --- O => select only the WORKCENTERS that have the OPER_CODE
                    SELECT      wc.workcenter_code  ,
                                wc.description      ,
                                wh.description      wh_description
                    FROM        WORKCENTER          wc
                    INNER JOIN  WORKCENTER_OPER     wo  ON  wo.workcenter_code  =   wc.workcenter_code
                    LEFT JOIN   WAREHOUSE           wh  ON  wh.whs_code         =   wc.whs_code
                    WHERE       p_selector          =   'O'
                        AND     wo.oper_code        =   p_oper_code
                    ORDER BY    workcenter_code
                    ;

    v_row           tmp_cmb := tmp_cmb();
    v_selector      VARCHAR2(10);

BEGIN

    IF p_lov_par1 IS NULL THEN
        v_selector  :=  'A';
    ELSE
        v_selector  :=  'O';
    END IF;

    FOR X IN C_LINES     (v_selector, p_lov_par1)
    LOOP
        v_row.txt01    :=   x.workcenter_code;
        v_row.txt02    :=   RPAD(x.description,30,' ') || ' ==> '||x.wh_description;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/*********************************************************************************
    DDL: 17/03/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_lov_warehouse_categ (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR     C_LINES(p_search VARCHAR2) IS
               SELECT   i.*
               FROM     WAREHOUSE_CATEG i
               ORDER BY category_code
               ;

    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINes(p_search) LOOP
        v_row.txt01    := x.category_code;
        v_row.txt02    := x.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
/*********************************************************************************
    DDL: 09/04/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_lov_setup_acrec (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR     C_LINES(p_search VARCHAR2) IS
               SELECT   i.*
               FROM     SETUP_ACREC i
               WHERE    description LIKE '%'||p_search||'%'
               ORDER BY acrec_type
               ;

    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINes(p_search) LOOP
        v_row.txt01    := x.acrec_type;
        v_row.txt02    := x.description ;
        IF x.currency_code IS NOT NULL THEN
            v_row.txt02    := v_row.txt02 ||' - '||x.currency_code;
        END IF;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/*********************************************************************************
    DDL: 10/04/2008  z Create procedure

/*********************************************************************************/
FUNCTION f_sql_lov_value_ad_tax (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR     C_LINES(p_search VARCHAR2) IS
               SELECT   i.*
               FROM     VALUE_AD_TAX i
               ORDER BY vat_code
               ;

    v_row      tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINes(p_search) LOOP
        v_row.txt01    := x.vat_code;
        v_row.txt02    := x.description ;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/*********************************************************************************
    DDL: 30/05/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_teh_variable (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  (p_org_code VARCHAR2) 
                    IS
                    SELECT      v.*
                    FROM        TEH_VARIABLE    v
                    WHERE       v.org_code      =   p_org_code
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    (p_lov_par1) 
    LOOP
        v_row.txt01     := x.var_code;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;


/*********************************************************************************
    DDL: 31/05/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_teh_value (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
----------------------------------------------------------------------------------
--  PURPOSE:    LOV with values corresponding to P_LOV_PAR1 organization code 
--              and P_LOV_PAR2 VAR_CODE  
----------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (p_org_code VARCHAR2, p_var_code VARCHAR2) 
                    IS
                    SELECT      item_code, description
                    FROM        ITEM            i
                    WHERE       i.org_code      =   p_org_code
                        AND     i.mat_type      =   'CALAPOD'
                        AND     p_var_code      =   'CALAPOD'
						AND     (
								description LIKE '%'||p_search||'%'
								OR
								item_code LIKE '%'||p_search||'%'
								)
                    --
                    UNION ALL
                    --
                    SELECT      *
                    FROM
                    (
                    SELECT      table_key, description
                    FROM        MULTI_TABLE
                    WHERE       table_name      =   'TEHVAR_'||p_var_code
                        AND     p_var_code      <>  'CALAPOD'
                    ORDER BY    seq_no
                    );

    v_row           tmp_cmb := tmp_cmb();

BEGIN

    FOR x IN C_LINES    (p_lov_par1, p_lov_par2) 
    LOOP
        v_row.txt01     := x.item_code;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;

/*********************************************************************************
    DDL: 31/05/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_receipt_fifo (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  (   p_org_code          VARCHAR2,
                        p_item_code         VARCHAR2,
                        p_colour_code       VARCHAR2,
                        p_size_code         VARCHAR2
                    ) 
                    IS
                    SELECT
                                MAX(d.idriga)           ref_receipt,
                                MAX(d.season_code)      season_code,
                                MAX(d.qty_doc_puom) - SUM(NVL(f.qty,0))   qty_stoc,
                                MAX(h.doc_number)       doc_number,
                                MAX(h.doc_date)         doc_date,
                                MAX(t.date_legal)       date_legal,
                                MAX(d.price_doc_puom)   price_doc_puom,
                                MAX(h.currency_code)    currency_code
                    ---
                    FROM          RECEIPT_DETAIL      d
                    INNER JOIN    RECEIPT_HEADER      h
                                      ON h.idriga         =   d.ref_receipt
                    LEFT JOIN     WHS_TRN             t
                                      ON  t.ref_receipt   =   h.idriga
                                      AND t.flag_storno   =   'N'
                    LEFT  JOIN    FIFO_MATERIAL       f
                                      ON  f.ref_receipt   =   d.idriga
                    WHERE         h.status                          IN  ('M','F')
                              AND d.org_code                        =   p_org_code
                              AND d.item_code                       =   p_item_code
                              AND NVL(d.colour_code,Pkg_Glb.C_RN)   =   NVL(p_colour_code,Pkg_Glb.C_RN)
                              AND NVL(d.size_code  ,Pkg_Glb.C_RN)   =   NVL(p_size_code  ,Pkg_Glb.C_RN)
                    GROUP BY    d.idriga
                    HAVING      MAX(d.qty_doc_puom) > SUM(NVL(f.qty,0))
                    ORDER BY    MAX(d.season_code),
                                MAX(t.date_legal), MAX(h.receipt_code), d.idriga
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    (
                            p_org_code          =>      p_lov_par1,
                            p_item_code         =>      p_lov_par2,
                            p_colour_code       =>      p_lov_par3,
                            p_size_code         =>      p_lov_par4 
                        ) 
    LOOP
        v_row.txt01     := x.ref_receipt;
        v_row.txt02     := x.season_code
                            ||' - '
                            ||LPAD(x.doc_number,10) 
                            ||' - '
                            ||TO_CHAR(x.doc_date,'dd/mm/yy')
                            ||' - '
                            ||TO_CHAR(x.date_legal,'dd/mm/yy')
                            ||' - '
                            ||LPAD(x.qty_stoc,10)
                            ||' - '
                            ||LPAD(x.price_doc_puom,10)||' '||x.currency_code
                            ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;


/*********************************************************************************
    DDL: 10/06/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_ord_status (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      m.table_key, m.description
                    FROM        MULTI_TABLE     m
                    WHERE       m.table_name    =   'STATUS_WORK_ORDER'
                        AND     m.flag_active   =   'Y'
                    ORDER BY    m.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.table_key;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;

/*********************************************************************************
    DDL: 14/07/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_pkg_status (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      m.table_key, m.description
                    FROM        MULTI_TABLE     m
                    WHERE       m.table_name    =   'STATUS_PKG'
                        AND     m.flag_active   =   'Y'
                    ORDER BY    m.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.table_key;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;

/*********************************************************************************
    DDL: 17/07/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_item_type (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR C_LINES  IS
                    SELECT      t.type_code, t.description
                    FROM        ITEM_TYPE       t
                    order by idriga
                    ;
    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.type_code;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;    
    RETURN;
END;

/*********************************************************************************
    DDL: 24/07/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_fixed_asset_categ (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR C_LINES  (p_filter VARCHAR2)
                    IS
                    SELECT      t.category_code, t.description,
                                LENGTH(t.category_code) - 
                                LENGTH(REPLACE(t.category_code,'.','')) nr_dots
                    ----------------------------------------------------------------
                    FROM        FIXED_ASSET_CATEG       t
                    ----------------------------------------------------------------
                    WHERE       t.CATEGORY_CODE         LIKE    '%'||p_filter||'%'
                                OR
                                UPPER(t.description)    LIKE    '%'||p_filter||'%'
                    ORDER BY    t.extended_code
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES (UPPER(p_search))   
    LOOP
        v_row.txt01     :=  x.category_code;
        v_row.txt02     :=  '';
        FOR i IN 1..x.nr_dots  LOOP
            v_row.txt02     := v_row.txt02|| '___';
        END LOOP;
        v_row.txt02     := v_row.txt02 || SUBSTR(x.description,1,100);
        v_row.txt02     := REPLACE(v_row.txt02,CHR(10),' ');
        v_row.txt02     := REPLACE(v_row.txt02,CHR(13),' ');

        pipe ROW(v_row);
    END LOOP;    
    RETURN;
END;

/*********************************************************************************
    DDL: 29/07/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_fa_deprec_type (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR C_LINES  IS
                    SELECT      t.table_key, t.description
                    FROM        MULTI_TABLE     t
                    WHERE       t.table_name    =   'FA_DEPREC_METHOD'
                    ORDER BY    t.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     :=  x.table_key;
        v_row.txt02     :=  x.description;
        pipe ROW(v_row);
    END LOOP;    
    RETURN;
END;

/*********************************************************************************
    DDL: 04/08/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_fa_trn_type (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS
    CURSOR C_LINES  (p_trn_iot VARCHAR2)
                    IS
                    SELECT      t.trn_type, t.description
                    FROM        FA_TRN_TYPE     t
--                    WHERE       t.trn_iot       LIKE    NVL(p_trn_iot, '%')
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    (p_lov_par1)
    LOOP
        v_row.txt01     :=  x.trn_type;
        v_row.txt02     :=  x.description;
        pipe ROW(v_row);
    END LOOP;    
    RETURN;
END;

/*********************************************************************************
    DDL: 14/08/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_fa_status (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      m.table_key, m.description
                    FROM        MULTI_TABLE     m
                    WHERE       m.table_name    =   'STATUS_FA'
                        AND     m.flag_active   =   'Y'
                    ORDER BY    m.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.table_key;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;

/*********************************************************************************
    DDL: 24/11/2008  d Create procedure
/*********************************************************************************/
FUNCTION f_sql_lov_inventory_type (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      m.table_key, m.description
                    FROM        MULTI_TABLE     m
                    WHERE       m.table_name    =   'INVENTORY_TYPE'
                        AND     m.flag_active   =   'Y'
                    ORDER BY    m.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.table_key;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;

/*********************************************************************************
    DDL: 12/11/2008  d CREATE PROCEDURE
/*********************************************************************************/
FUNCTION f_sql_lov_inventory_status (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      m.table_key, m.description
                    FROM        MULTI_TABLE     m
                    WHERE       m.table_name    =   'INVENTORY_STATUS'
                        AND     m.flag_active   =   'Y'
                    ORDER BY    m.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.table_key;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;
    
/*********************************************************************************
    DDL: 23/11/2008  d CREATE PROCEDURE
/*********************************************************************************/
FUNCTION f_sql_lov_inventory_attr (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      m.table_key, m.description
                    FROM        MULTI_TABLE     m
                    WHERE       m.table_name    =   'INVENTORY_ATTR'
                        AND     m.flag_active   =   'Y'
                    ORDER BY    m.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.table_key;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;
        
/*********************************************************************************
    DDL: 05/01/2009  d CREATE PROCEDURE
/*********************************************************************************/
FUNCTION f_sql_lov_cost_code (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      c.cost_code, c.description, c.cost_category
                    FROM        COST_TYPE       c
                    ORDER BY 3,1
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.cost_code;
        v_row.txt02     := x.cost_category||' => '||x.description;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;    

FUNCTION f_sql_lov_stg_file_type (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      m.table_key, m.description
                    FROM        MULTI_TABLE     m
                    WHERE       m.table_name    =   'STG_FILE_TYPE'
                        AND     m.flag_active   =   'Y'
                    ORDER BY    m.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.table_key;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;

FUNCTION f_sql_lov_ship_pack_mode (p_search VARCHAR2,p_lov_par1 VARCHAR2, p_lov_par2 VARCHAR2,p_lov_par3 VARCHAR2,p_lov_par4 VARCHAR2) RETURN typ_cmb  pipelined
IS

    CURSOR C_LINES  IS
                    SELECT      m.table_key, m.description
                    FROM        MULTI_TABLE     m
                    WHERE       m.table_name    =   'SHIP_PACK_MODE'
                        AND     m.flag_active   =   'Y'
                        AND     m.table_key     NOT LIKE '%IT'
                    ORDER BY    m.seq_no
                    ;

    v_row           tmp_cmb := tmp_cmb();

BEGIN
    FOR x IN C_LINES    
    LOOP
        v_row.txt01     := x.table_key;
        v_row.txt02     := x.description ;
        pipe ROW(v_row);
    END LOOP;
    
    RETURN;
END;


    
END;

/

/
