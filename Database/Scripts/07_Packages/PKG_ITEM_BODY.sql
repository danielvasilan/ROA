--------------------------------------------------------
--  DDL for Package Body PKG_ITEM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_ITEM" 
IS


/*********************************************************************************
    DDL:    09/03/2008  z   Create procedure
            08/07/2008  d   added the technical inf in the main list  
            17/07/2008  d   added the item_type parameter + item_type column  
            29/09/2008  d   added the item picture path 
/*********************************************************************************/
FUNCTION    f_sql_item  (   p_line_id       NUMBER,
                            p_org_code      VARCHAR2, 
                            p_make_buy      VARCHAR2, 
                            p_mat_type      VARCHAR2,
                            p_type_code     VARCHAR2
                        )     
                            RETURN          typ_longinfo  pipelined
/*----------------------------------------------------------------------------------
--  PURPOSE:    rowsource for the main list with ITEMS in the interface 
----------------------------------------------------------------------------------*/
IS

    CURSOR  C_LINE  (p_org_code VARCHAR2, p_make_buy VARCHAR2, p_mat_type VARCHAR2, p_type_code VARCHAR2) 
                    IS
                    SELECT      *
                    FROM        ITEM
                    WHERE       org_code        =       p_org_code
                            AND make_buy        LIKE    NVL(p_make_buy, '%')
                            AND mat_type        LIKE    NVL(p_mat_type, '%')
                            AND type_code       IN      (SELECT txt01 FROM TABLE(Pkg_Lib.f_sql_inlist(p_type_code)))
                    ORDER  BY   item_code
                    ;

    -- get the number of components in BOM 
    CURSOR  C_BOM_STD (p_org_code   VARCHAR2, p_item_code   VARCHAR2) 
                    IS
                    SELECT      COUNT(*)        number_component
                    FROM        BOM_STD
                    WHERE       org_code        =   p_org_code
                            AND father_code     =   p_item_code
                    ;

    -- get the Tehnical variable values for the finished good  
    CURSOR C_TEH        (p_org_code VARCHAR2, p_item_code   VARCHAR2)
                        IS
                        SELECT      v.var_code, v.var_value
                        FROM        ITEM_VARIABLE   v
                        WHERE       v.org_code      =   p_org_code
                            AND     v.item_code     =   p_item_code
                        ;

    v_row               tmp_longinfo := tmp_longinfo();
    v_row_ini           tmp_longinfo := tmp_longinfo();
    v_picture_path      VARCHAR2(1000);
    
BEGIN

    v_picture_path      :=  Pkg_Env.f_get_picture_path(p_org_code);

    FOR x IN C_LINE(p_org_code, p_make_buy, p_mat_type, p_type_code)  
    LOOP
        v_row           :=  v_row_ini;

        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINE%rowcount;

        v_row.txt01     :=  x.item_code;
        v_row.txt02     :=  x.description;
        v_row.txt03     :=  x.puom;
        v_row.txt04     :=  x.make_buy;
        v_row.txt05     :=  x.custom_code;
        v_row.txt06     :=  x.custom_category;
        v_row.txt07     :=  x.obs;
        v_row.txt08     :=  x.start_size;
        v_row.txt09     :=  x.end_size;
        v_row.txt10     :=  x.org_code;
        v_row.txt11     :=  x.mat_type;
        v_row.txt12     :=  x.whs_stock;
        v_row.txt13     :=  x.oper_code;
        v_row.txt14     :=  x.suom;
        v_row.txt15     :=  x.uom_receit;
        v_row.txt16     :=  x.root_code;
        v_row.txt17     :=  x.item_code2;
        v_row.txt18     :=  x.account_code;
        v_row.txt24     :=  x.type_code;
        v_row.txt25     :=  v_picture_path||x.root_code||'.jpg';
        v_row.txt26     :=  x.account_analytic;
        v_row.txt28     :=  x.description_alt;
        
        v_row.txt50     :=  x.obs;

        v_row.numb01   := x.flag_size;
        v_row.numb02   := x.flag_colour;
        v_row.numb03   := x.flag_range;
        v_row.numb04   := x.uom_conv;
        v_row.numb05   := x.scrap_perc;
        v_row.numb06   := x.weight_net;
        v_row.numb07   := x.weight_brut;
        v_row.numb08    := NULL;                                -- cycle time, not used
        v_row.numb09   := x.valuation_price;
        --
        v_row.numb10 := 0;
        IF x.make_buy = 'P' THEN
            OPEN    C_BOM_STD   (   p_org_code  =>  x.org_code,
                                    p_item_code =>  x.item_code
                                );
            FETCH   C_BOM_STD   INTO v_row.numb10;
            CLOSE   C_BOM_STD;

            -- technical characteristics 
            FOR xx IN C_TEH(x.org_code, x.item_code)
            LOOP
                CASE xx.var_code
                    WHEN    'FBC'       THEN    v_row.txt19     :=  xx.var_value;
                    WHEN    'SORTIMENT' THEN    v_row.txt20     :=  xx.var_value;
                    WHEN    'CALAPOD'   THEN    v_row.txt21     :=  xx.var_value;
                    WHEN    'MATTYPE'   THEN    v_row.txt22     :=  xx.var_value;
                    WHEN    'SIGLA'     THEN    v_row.txt23     :=  xx.var_value;
                    WHEN    'TIPTALPA'  THEN    v_row.txt27     :=  xx.var_value;
                    ELSE                NULL;
                END CASE;
            END LOOP;

        END IF;
        --
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/*********************************************************************************
 DDL:   09/03/2008  z Create procedure 
        17/06/2008  d added Note from BOM_STD    
/*********************************************************************************/
FUNCTION f_sql_item_component   (   p_line_id       NUMBER,
                                    p_org_code      VARCHAR2,
                                    p_item_code     VARCHAR2
                                )   RETURN          typ_frm     pipelined
/*----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the standard bill
--  INPUT:      ORG_CODE    =   client 
--              ITEM_CODE   =   item     
----------------------------------------------------------------------------------*/
IS
    CURSOR C_LINES  IS
                    SELECT      s.*,
                                i.description   i_description, 
                                i.puom          i_puom, 
                                i.flag_range    i_flag_range, 
                                i.oper_code     i_oper_code,
                                i.start_size    i_start_size, 
                                i.end_size      i_end_size
                    -------------------------------------------------------------------------
                    FROM        BOM_STD     s
                    INNER JOIN  ITEM        i   ON  i.org_code  =   s.org_code
                                                AND i.item_code =   s.child_code
                    LEFT JOIN   OPERATION   o   ON  o.oper_code =   NVL(s.oper_code,i.oper_code)
                    --------------------------------------------------------------------------                   
                    WHERE       s.father_code   =   p_item_code
                            AND s.org_code      =   p_org_code
                    --------------------------------------------------------------------------
                    ORDER BY o.oper_seq, s.child_code, s.colour_code
                    ;

    v_row    tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES 
    LOOP

        v_row.idriga    :=      x.idriga;
        v_row.dcn       :=      x.dcn;
        v_row.seq_no    :=      c_lines%rowcount;

        v_row.txt01     :=      x.father_code;
        v_row.txt02     :=      x.org_code;
        v_row.txt03     :=      x.colour_code;
        v_row.txt04     :=      x.oper_code;
        v_row.txt05     :=      x.child_code;
        v_row.txt06     :=      x.start_size;
        v_row.txt07     :=      x.end_size;
        v_row.txt09     :=      SUBSTR(x.i_description,1,30);
        v_row.txt09     :=      RPAD(v_row.txt09,30);

        v_row.txt09     :=  v_row.txt09 
                            ||' ' 
                            ||SUBSTR(x.i_oper_code,1,2); 

        
        IF x.i_flag_range = -1 THEN
            v_row.txt09 := v_row.txt09 
                            ||' '||x.i_start_size
                            ||'->'
                            ||x.i_end_size;
        END IF;

        v_row.txt10     :=      x.i_puom;
        v_row.txt11     :=      x.note;

        v_row.numb01    :=      x.qta;
        v_row.numb02    :=      x.qta_std;

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;
/*********************************************************************************
    DDL:    09/03/2008  z   Create procedure 
            20/08/2008  d   added P_LINE_ID parameter 
/*********************************************************************************/
FUNCTION f_sql_item_parent  (   p_line_id       NUMBER,
                                p_org_code      VARCHAR2,
                                p_item_code     VARCHAR2
                            )   RETURN          typ_frm         pipelined
/*----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the parents of
--               an item based on BOM_STD
--  PREREQ:
--
--  INPUT:      ORG_CODE        = client

----------------------------------------------------------------------------------*/
IS
    CURSOR C_LINES  (p_org_code VARCHAR2, p_item_code VARCHAR2)  
    IS
                    SELECT      s.*,
                                i.description, i.puom
                    ---------------------------------------------------------------
                    FROM        BOM_STD     s
                    INNER JOIN  ITEM        i   ON  i.org_code  =   s.org_code
                                                AND i.item_code =   s.father_code
                    ---------------------------------------------------------------
                    WHERE       s.child_code    =   p_item_code
                            AND s.org_code      =   p_org_code
                    ORDER BY    s.father_code, s.colour_code
                    ;
    v_row    tmp_frm := tmp_frm();

BEGIN
    FOR X IN C_LINES(p_org_code, p_item_code) 
    LOOP

        v_row.idriga    :=      x.idriga;
        v_row.dcn       :=      x.dcn;
        v_row.seq_no    :=      C_LINES%rowcount;

        v_row.txt01     :=      x.child_code;
        v_row.txt03     :=      x.colour_code;
        v_row.txt04     :=      x.oper_code;
        v_row.txt05     :=      x.father_code;
        v_row.txt06     :=      x.start_size;
        v_row.txt07     :=      x.end_size;
        v_row.txt08     :=      x.org_code;
        v_row.txt09     :=      x.description;
        v_row.txt10     :=      x.puom;

        v_row.numb01    :=      x.qta;
        v_row.numb02    :=      x.qta_std;

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/*********************************************************************************
    DDL:    09/03/2008  z   Create procedure 
            12/06/2008  d   added colour description + ORDER + GROUP
            20/08/2008  d   added LINE_ID parameter 
                            + added OPER_CODE_ITEM in returned info 
/*********************************************************************************/
FUNCTION f_sql_item_stock   (   p_line_id       NUMBER,
                                p_org_code      VARCHAR2,
                                p_item_code     VARCHAR2
                            )   RETURN          typ_frm     pipelined
/*----------------------------------------------------------------------------------
--  PURPOSE:    returns stock lines for an item 
--  INPUT:      ORG_CODE  + ITEM_CODE 
----------------------------------------------------------------------------------*/
IS

    CURSOR C_LINES  (   p_org_code VARCHAR2, p_item_code VARCHAR2) 
                        IS
                        SELECT      s.*, 
                                    w.description   w_description,
                                    c.description   c_description
                        ----------------------------------------------------------------------------
                        FROM        STOC_ONLINE     s
                        INNER JOIN  WAREHOUSE       w   ON  w.whs_code      =   s.whs_code
                        INNER JOIN  WAREHOUSE_CATEG k   ON  k.category_code =   w.category_code
                        LEFT JOIN   COLOUR          c   ON  c.colour_code   =   s.colour_code
                                                        AND c.org_code      =   s.org_code
                        ----------------------------------------------------------------------------
                        WHERE       s.item_code     =   p_item_code
                            AND     s.org_code      =   p_org_code
                            AND     s.qty           <>  0
                            AND     k.virtual       =   'N'
                        ORDER BY   s.whs_code, s.season_code,s.colour_code
                        ;

     v_row      tmp_frm := tmp_frm();

BEGIN
    FOR x IN C_LINES    (p_org_code,p_item_code) 
    LOOP
        v_row.idriga    :=  C_LINES%ROWCOUNT;
        v_row.dcn       :=  0;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.item_code;
        v_row.txt02     :=  x.whs_code;
        v_row.txt03     :=  x.w_description;
        v_row.txt04     :=  x.colour_code || ' - ' || x.c_description;
        v_row.txt05     :=  x.size_code;
        v_row.txt06     :=  x.season_code;
        v_row.txt07     :=  x.org_code;
        v_row.txt08     :=  x.order_code;
        v_row.txt09     :=  x.group_code;
        v_row.txt10     :=  x.oper_code_item;

        v_row.numb01    :=  x.qty;

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/*********************************************************************************
    DDL: 09/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_item_cycle_time(p_item_code VARCHAR2) RETURN typ_frm pipelined
/*----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the cycle time
--
--  PREREQ:
--
--  INPUT:      ORG_CODE        = client

----------------------------------------------------------------------------------*/
IS
     CURSOR C_LINII  IS
                SELECT   *
                FROM  ITEM_CYCLE_TIME
                WHERE  item_code = p_item_code
                ORDER BY seq_no
                ;

     v_row tmp_frm := tmp_frm();

BEGIN
    FOR x IN C_LINII LOOP
        v_row.idriga   := x.idriga;
        v_row.dcn      := x.dcn;
        v_row.txt01    := x.item_code;
        v_row.txt02    := x.seq_no;
        v_row.txt03    := x.oper_code;
        v_row.numb01   := x.oper_time;
        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/*********************************************************************************
    DDL:    09/03/2008  z   Create procedure
            20/08/2008  d   added P_LINE_ID parameter 
/*********************************************************************************/
FUNCTION f_sql_item_demand  (   p_line_id       NUMBER,
                                p_org_code      VARCHAR2,
                                p_item_code     VARCHAR2
                            )   RETURN          typ_frm         pipelined
/*----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the item demand
----------------------------------------------------------------------------------*/
IS

    CURSOR  C_LAUNCHED          (p_org_code VARCHAR2,    p_item_code VARCHAR2) 
            IS
            SELECT  a.org_code,a.season_code, a.item_code,a.colour_code,a.size_code,a.status,
                    SUM(a.qty_demand)           qty_demand,
                    SUM(a.qty_picked)           qty_picked
            FROM
                (
                    SELECT      b.org_code,g.season_code, b.item_code,b.colour_code,b.size_code,
                                g.group_code        ,
                                MAX(g.status)       status,
                                MAX(b.qta_demand)   qty_demand,
                                SUM(t.qty)          qty_picked
                    ---------------------------------------------------------------------------
                    FROM        WORK_GROUP      g
                    INNER JOIN  BOM_GROUP       b   ON  b.ref_group     =   g.idriga
                    LEFT JOIN   WHS_TRN_DETAIL  t   ON  t.org_code      =   b.org_code
                                                    AND t.item_code     =   b.item_code
                                                    AND t.season_code   =   g.season_code
                                                    AND t.group_code    =   g.group_code   
                                                    AND Pkg_Lib.f_diff_c(t.size_code,   b.size_code)    = 0
                                                    AND Pkg_Lib.f_diff_c(t.colour_code, b.colour_code)  = 0
                                                    AND t.reason_code   =   Pkg_Glb.C_P_TALCMO
                    ---------------------------------------------------------------------------
                    WHERE       g.status        IN  ('L','V')
                            AND b.item_code     =   p_item_code
                            AND b.org_code      =   p_org_code
                    ---------------------------------------------------------------------------
                    GROUP BY    b.org_code, g.group_code, g.season_code,
                                b.item_code,b.colour_code,b.size_code
                )   a
            GROUP BY a.org_code,A.season_code, a.item_code,a.colour_code,a.size_code,a.status
            ;

--  CURSOR      C_NOT_LAUNCHED(p_item_code VARCHAR2) IS
--                     SELECT  w.client org_code,w.season_code, b.child_code item_code,b.colour_code,
--                             DECODE(i.flag_size,-1,d.size_code,NULL) size_code,
--                             SUM(b.qta * d.qta)  qta
--                     FROM     WORK_ORDER     w
--
--                              WO_DETAIL      d,
--                              BOM_STD        b,
--                              ITEM           i,
--                              WO_GROUP       g
--                     WHERE       w.item_code         =   b.father_code
--                             AND w.client            =   b.org_code
--                             AND w.idriga            =   d.ref_wo
--                             AND b.child_code        =   i.item_code
--                             AND b.org_code          =   i.default_org
--                             AND w.client            =   g.client        (+)
--                             AND w.group_code        =   g.group_code    (+)
--                             AND b.child_code        =   p_item_code
--                             AND w.status            NOT IN  ('A')
--                             AND NVL(g.status,'I')   =  'I'
--                             AND d.size_code     BETWEEN NVL(NVL(b.start_size,i.start_size),Pkg_Glb.C_SIZE_MIN)
--                                                         AND
--                                                         NVL(NVL(b.end_size,i.end_size), Pkg_Glb.C_SIZE_MAX)
--                     GROUP BY w.client,w.season_code,b.child_code,b.colour_code,DECODE(i.flag_size,-1,d.size_code,NULL)
--         ;

 v_row      tmp_frm := tmp_frm();

BEGIN

    v_row.idriga    := 0;
    v_row.dcn       := 0;

    FOR X IN C_LAUNCHED(p_org_code,p_item_code) LOOP
        v_row.txt01    :=   x.item_code;
        v_row.txt02    :=   x.colour_code;
        v_row.txt03    :=   x.size_code;
        v_row.txt04    :=   (CASE WHEN x.status = 'L' THEN 'LANSATE' ELSE 'VALIDATE' END );
        v_row.txt05    :=   x.season_code;
        v_row.txt06    :=   x.org_code;

        v_row.numb01   :=   x.qty_demand - NVL(x.qty_picked,0);
        IF v_row.numb01 > 0 THEN
            pipe ROW(v_row);
        END IF;
    END LOOP;

--  FOR X IN C_NOT_LAUNCHED(p_item_code) LOOP
--
--          v_row.numb01   := Pkg_Mov.f_round_qta(X.qta);
--
--          v_row.txt01    :=  X.item_code;
--          v_row.txt02    :=  X.colour_code;
--          v_row.txt03    :=  X.size_code;
--          v_row.txt04    :=  'NELANSATE';
--          v_row.txt05    :=  X.season_code;
--          v_row.txt06    :=  X.org_code;
--
--          IF v_row.numb01  > 0 THEN
--             pipe ROW(v_row);
--          END IF;
--  END LOOP;
    RETURN;
END;

/*********************************************************************************
    DDL: 09/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_item_blo(p_tip VARCHAR2, p_row IN OUT ITEM%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the item demand
--
--  PREREQ:
--
--  INPUT:      ORG_CODE        = client

----------------------------------------------------------------------------------*/
IS

    v_row_uom           PRIMARY_UOM%ROWTYPE;
    v_row_cst           CUSTOM%ROWTYPE;
    v_row_isz           ITEM_SIZE%ROWTYPE;
    v_row_cli           ORGANIZATION%ROWTYPE;
    v_row_whs           WAREHOUSE%ROWTYPE;
    v_row_cmt           CAT_MAT_TYPE%ROWTYPE;
    v_row_ope           OPERATION%ROWTYPE;
    v_row_sfm           SALES_FAMILY%ROWTYPE;
    v_row_wct           WAREHOUSE_CATEG%ROWTYPE;


    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        v_row_cli.org_code  :=  p_row.org_code;
        Pkg_Check.p_chk_organization(v_row_cli);
        --
        v_row_uom.puom  :=  p_row.puom;
        Pkg_Check.p_chk_primary_uom(v_row_uom,'Unitatea de masura PRIMARA');
        --
        IF p_row.custom_code IS NOT NULL THEN
            v_row_cst.custom_code  :=  p_row.custom_code;
            Pkg_Check.p_chk_custom(v_row_cst);
        END IF;
        --
        IF p_row.start_size IS NOT NULL THEN
            v_row_isz.size_code  :=  p_row.start_size;
            Pkg_Check.p_chk_item_size(v_row_isz,'Marimea de la ');
        END IF;
        IF p_row.end_size IS NOT NULL THEN
           v_row_isz.size_code  :=  p_row.end_size;
           Pkg_Check.p_chk_item_size(v_row_isz,'Marimea pana la ');
        END IF;
        --
        v_row_whs.whs_code  :=  p_row.whs_stock;
        Pkg_Check.p_chk_warehouse(v_row_whs);
        --
        v_row_cmt.categ_code  :=  p_row.mat_type;
        Pkg_Check.p_chk_cat_mat_type(v_row_cmt);
        --
        IF p_row.oper_code IS NOT NULL THEN
            v_row_ope.oper_code  :=  p_row.oper_code;
            Pkg_Check.p_chk_operation(v_row_ope);
        END IF;
        --
        IF p_row.suom IS NOT NULL THEN
            v_row_uom.puom  :=  p_row.suom;
            Pkg_Check.p_chk_primary_uom(v_row_uom,'Unitatea de masura SECUNDARA');
        END IF;
        --
        IF p_row.uom_receit IS NOT NULL THEN
            v_row_uom.puom  :=  p_row.uom_receit;
            Pkg_Check.p_chk_primary_uom(v_row_uom,'Unitatea de masura RECEPTIE');
        END IF;
        --
        IF p_row.root_code IS NOT NULL THEN
            v_row_sfm.org_code      :=  p_row.org_code;
            v_row_sfm.family_code   :=  p_row.root_code;
            Pkg_Check.p_chk_sales_family(v_row_sfm);
        END IF;

        --------------------------------------------------------------------------
        -- other logics
        -- set production or prurches
        IF  NVL(p_row.make_buy,Pkg_Glb.C_RN) NOT IN ('A','P') THEN
                Pkg_Err.p_set_error_message
                (    p_err_code          => '090' ,
                     p_err_header        => 'Nu ati precizat daca codul este'
                                            ||' de productie sau de achizitie (P/A) !!!',
                     p_err_detail        => NULL ,
                     p_flag_immediate    => 'N'
                );
        END IF;
        -- check consistency for range
        IF p_row.flag_range = -1 THEN
            IF p_row.start_size IS NULL OR p_row.end_size IS NULL THEN
                Pkg_Err.p_set_error_message
                (    p_err_code          => '100' ,
                     p_err_header        => 'Codul este controlat pe plaja'
                                            ||' trebuie sa precizati marimea'
                                            ||' de inceput si cea de sfarsit !!!',
                     p_err_detail        => NULL ,
                     p_flag_immediate    => 'N'
                );
            END IF;
            --
            IF p_row.start_size > p_row.end_size THEN
                Pkg_Err.p_set_error_message
                (    p_err_code          => '105' ,
                     p_err_header        => 'Marimea de capat plaja trebuie'
                                            ||' sa fie mai mare decat cea'
                                            ||' de inceput de plaja !!!',
                     p_err_detail        => NULL ,
                     p_flag_immediate    => 'N'
                );
            END IF;
        ELSE
            IF p_row.start_size IS NOT NULL OR p_row.end_size IS NOT NULL THEN
                Pkg_Err.p_set_error_message
                (    p_err_code          => '110' ,
                     p_err_header        => 'Codul NU este controlat pe plaja'
                                            ||' deci nu trebuie precizat'
                                            ||' marime de inceput si cea de sfarsit !!!',
                     p_err_detail        => NULL ,
                     p_flag_immediate    => 'N'
                );
            END IF;
        END IF;
        -- check the warehouse if can be stock
        IF v_row_whs.category_code IS NOT NULL THEN
            v_row_wct.category_code     :=  v_row_whs.category_code;
            IF Pkg_Get2.f_get_warehouse_categ_2(v_row_wct) THEN NULL; END IF;
            IF v_row_wct.qty_on_hand = 'N' THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '120' ,
                         p_err_header        => 'Magazia aceasta '
                                                ||' nu poate fi de stock !!!',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
            END IF;
        END IF;
        -- an item ca NOT be controled at same time also by range and by size
        IF p_row.flag_size = -1 AND p_row.flag_range = -1 THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '130' ,
                         p_err_header        => 'Un articol nu poate fi gestionat '
                                                ||' in acelasi timp si pe marime si pe plaja !!!',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
        END IF;
        -- if we have secondary unit we need a conversion
        IF      p_row.suom IS NOT NULL AND p_row.uom_conv = 0
            OR  p_row.suom IS NULL AND p_row.uom_conv <> 0
        THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '140' ,
                         p_err_header        => 'Daca ati precizat unitate de masura secundara '
                                                ||' trebuie sa preciati si un factor de conversie, '
                                                ||' daca NU ati precizat unitate secundara factorul '
                                                ||' de conversie trebuie sa fie ZERO !!! ',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
        END IF;
        -- the receipt uom has to be the primary or the secondary unit of measure
        IF p_row.uom_receit IS NOT NULL THEN
            IF p_row.uom_receit NOT IN (p_row.puom, NVL(p_row.suom,p_row.puom)) THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '150' ,
                         p_err_header        => 'Unitatea de masura de receptie '
                                                ||' trebuie sa fie ori cea principala ori '
                                                ||' cea secundara !!! ',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
            END IF;
        END IF;
    END;
    ---------------------------------------------------------------------------
BEGIN

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --

        WHEN    'U' THEN
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    13/06/2008  z   Create procedure
            01/07/2008  d   replaced MYSELF with a dynamic computed variable
                            check the unicity in both directions 
/*********************************************************************************/
PROCEDURE p_item_mapping_blo(p_tip VARCHAR2, p_row IN OUT ITEM_MAPPING%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    
----------------------------------------------------------------------------------*/
IS
    v_row_its       ITEM%ROWTYPE;
    v_row_itd       ITEM%ROWTYPE;
    
    v_t             BOOLEAN;
    v_org_myself    VARCHAR2(20);

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        
        v_row_its.org_code      :=  p_row.org_code_src;
        v_row_its.item_code     :=  p_row.item_code_src;
        Pkg_Check.p_chk_item(v_row_its,p_row.item_code_src);
        ---
        v_row_itd.org_code      :=  p_row.org_code_dst;
        v_row_itd.item_code     :=  p_row.item_code_dst;
        Pkg_Check.p_chk_item(v_row_itd,p_row.item_code_dst);
        --
        p_row.puom              :=  v_row_its.puom;
        p_row.puom_dst          :=  v_row_itd.puom;

--         --
--         IF v_row_its.puom <> v_row_itd.puom THEN
--             Pkg_Err.p_err('Unitatea de masura difera intre cele 2 coduri !','Informatii eronate');
--         END IF;

--        IF p_row.org_code_src = v_org_myself OR  p_row.org_code_dst  <>  v_org_myself THEN
--            Pkg_Err.p_err(  'Gestiunea sursa trebuie sa difere de '||v_org_myself ||
--                            ' si gestiunea destinatie trebuie sa fie '||v_org_myself ||' !!!',
--                            'Informatii eronate');
--        END IF;
        
    END;
    ---------------------------------------------------------------------------
BEGIN

    v_org_myself    :=  Pkg_Nomenc.f_get_myself_org;

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --

        WHEN    'U' THEN
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    Pkg_Err.p_rae;

    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 13/06/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_item_mapping_iud(p_tip VARCHAR2, p_row ITEM_MAPPING%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in item when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               ITEM_MAPPING%ROWTYPE;
BEGIN

    -- BLO 
    v_row   :=  p_row;
    Pkg_Item.p_item_mapping_blo(p_tip, v_row);

    --IUD 
    Pkg_Iud.p_item_mapping_iud(p_tip, v_row);
    
    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 09/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_item_iud(p_tip VARCHAR2, p_row ITEM%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in item when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               ITEM%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Item.p_item_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_item_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 10/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_bom_std_iud(p_tip VARCHAR2, p_row IN OUT BOM_STD%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the BOM STD
--
--  PREREQ:
--
--  INPUT:

----------------------------------------------------------------------------------*/
IS

    v_row_itm           ITEM%ROWTYPE;
    v_row_col           COLOUR%ROWTYPE;
    v_row_ope           OPERATION%ROWTYPE;
    v_row_isz           ITEM_SIZE%ROWTYPE;
    v_row_cli           ORGANIZATION%ROWTYPE;


    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        v_row_cli.org_code  :=  p_row.org_code;
        Pkg_Check.p_chk_organization(v_row_cli);
        --
        v_row_itm.item_code :=  p_row.father_code;
        v_row_itm.org_code  :=  p_row.org_code;
        Pkg_Check.p_chk_item(v_row_itm,'Cod PARINTE');
        --
        v_row_itm.item_code :=  p_row.child_code;
        v_row_itm.org_code  :=  p_row.org_code;
        Pkg_Check.p_chk_item(v_row_itm,'Cod COMPONENTA');
        --
        IF p_row.oper_code IS NOT NULL THEN
            v_row_ope.oper_code  :=  p_row.oper_code;
            Pkg_Check.p_chk_operation(v_row_ope);
        END IF;
        --
        IF p_row.start_size IS NOT NULL THEN
            v_row_isz.size_code  :=  p_row.start_size;
            Pkg_Check.p_chk_item_size(v_row_isz,'Marimea de la ');
        END IF;
        IF p_row.end_size IS NOT NULL THEN
           v_row_isz.size_code  :=  p_row.end_size;
           Pkg_Check.p_chk_item_size(v_row_isz,'Marimea pana la ');
        END IF;
        --
        IF p_row.colour_code IS NOT NULL THEN
            v_row_col.org_code      :=  p_row.org_code;
            v_row_col.colour_code   :=  p_row.colour_code;
            Pkg_Check.p_chk_colour(v_row_col);
        END IF;
        --------------------------------------------------------------------------
        -- other logics
        -- set production or purchase 
        IF NVL(p_row.qta,0) <= 0 OR NVL(p_row.qta_std,0) <= 0 THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '100' ,
                         p_err_header        => 'Nu ati precizat o valoare pozitiva '
                                                ||' pentru cantitatea standard / cantitatea masurata !!! ',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
        END IF;

        -- check if the colour is mandatory
        IF      v_row_itm.flag_colour = -1 AND p_row.colour_code IS NULL
        THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '110' ,
                         p_err_header        => 'Acest cod este controlat pe culoare '
                                                ||' trebuie sa introduceti o culoare !!! ',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
        END IF;
        IF      v_row_itm.flag_colour = 0 AND p_row.colour_code IS NOT NULL THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '120' ,
                         p_err_header        => 'Acest cod NU este controlat pe culoare '
                                                ||' NU trebuie sa introduceti culoarea !!! ',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
        END IF;
        -- check the range logic
        IF      p_row.start_size IS NOT NULL AND p_row.end_size IS NULL
            OR  p_row.start_size IS NULL AND p_row.end_size IS NOT NULL
        THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '130' ,
                         p_err_header        => 'Trebuie sa precizati ambele marimi '
                                                ||' sau nici unul !!! ',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
        END IF;
        --
        IF p_row.start_size > p_row.end_size THEN
                    Pkg_Err.p_set_error_message
                    (    p_err_code          => '140' ,
                         p_err_header        => 'Marimea de start a plajei  '
                                                ||' trebuie sa fie mai mica sau egala '
                                                ||' cu marimea de sfarsit !!! ',
                         p_err_detail        => NULL ,
                         p_flag_immediate    => 'N'
                    );
        END IF;
        --






    END;
    ---------------------------------------------------------------------------
BEGIN

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --

        WHEN    'U' THEN
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 10/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_bom_std_iud(p_tip VARCHAR2, p_row BOM_STD%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in BOM_STD when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------*/
IS
    v_row               BOM_STD%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Item.p_chk_bom_std_iud(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_bom_std_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 10/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_check_colour_size (     p_org_code       VARCHAR2,
                                    p_item_code      VARCHAR2,
                                    p_flag_colour    INTEGER ,
                                    p_colour_code    VARCHAR2,
                                    p_flag_size      INTEGER,
                                    p_size_code      VARCHAR2
                              )
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in BOM_STD when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------*/
IS
   C_ERR_CODE1  VARCHAR2(100)   :=  'CHK_CM';
   C_ERR_CODE2  VARCHAR2(100)   :=  'CHK_CP';
   C_ERR_CODE3  VARCHAR2(100)   :=  'CHK_SM';
   C_ERR_CODE4  VARCHAR2(100)   :=  'CHK_SP';

BEGIN
     -- check if they are controle by colour
     IF p_colour_code IS NULL THEN
         IF p_flag_colour   = -1 THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => C_ERR_CODE1,
                  p_err_header        => 'Urmatoarele coduri trebuie introduse '
                                        ||'pe culoare !!!',
                  p_err_detail        =>  p_org_code ||' - '||p_item_code,
                  p_flag_immediate    => 'N'
              );
         END IF;
     END IF;
     --
     IF p_colour_code IS NOT NULL THEN
         IF p_flag_colour   = 0 THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => C_ERR_CODE2,
                  p_err_header        => 'Urmatoarele coduri NU trebuie introduse '
                                        ||'pe culoare !!!',
                  p_err_detail        =>  p_org_code ||' - '||p_item_code,
                  p_flag_immediate    => 'N'
             );
         END IF;
     END IF;
     --
     IF p_size_code IS NULL THEN
         IF p_flag_size   = -1 THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => C_ERR_CODE3,
                  p_err_header        => 'Urmatoarele coduri trebuie introduse '
                                        ||'pe marime !!!',
                  p_err_detail        =>  p_org_code ||' - '||p_item_code,
                  p_flag_immediate    => 'N'
              );
         END IF;
     END IF;
     --
     IF p_size_code IS NOT NULL THEN
         IF p_flag_size   = 0 THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => C_ERR_CODE4,
                  p_err_header        => 'Urmatoarele coduri NU trebuie introduse '
                                        ||'pe marime !!!',
                  p_err_detail        =>  p_org_code ||' - '||p_item_code,
                  p_flag_immediate    => 'N'
             );
         END IF;
     END IF;
END;


/*********************************************************************************
    DDL: 22/11/2008  d Create procedure
/*********************************************************************************/
PROCEDURE p_check_item_attr (       p_row_it            ITEM%ROWTYPE,
                                    p_colour_code       VARCHAR2,
                                    p_size_code         VARCHAR2
                            )
/*------------------------------------------------------------------------------------------
--  PURPOSE:    checks if the attributes correspond with the item flags  
--              can be used by procedures like the ones for warehouse transactions details 
--              the accounting details, inventory details, etc  
--  OUTPUT:     if errors found => silent errors (Pkg_err.p_err)  
-------------------------------------------------------------------------------------------*/
IS
    v_err       VARCHAR2(500);
BEGIN
     -- COLOUR 
    IF p_colour_code IS NULL AND p_row_it.flag_colour   = -1 THEN
        v_err   :=  'Se gestioneaza pe culoare !';
    END IF;
    IF p_colour_code IS NOT NULL AND p_row_it.flag_colour   = 0 THEN
        v_err   :=  'NU se gestioneaza pe culoare !';
    END IF;
    -- SIZE 
    IF p_size_code IS NULL AND p_row_it.flag_size   = -1 THEN
        v_err   :=  'Se gestioneaza pe marime!';
    END IF;
    IF p_size_code IS NOT NULL AND p_row_it.flag_size   = 0 THEN
        v_err   :=  'NU se gestioneaza pe marime!';
    END IF;
    --  RAE 
    IF v_err IS NOT NULL THEN
        v_err   :=  'Codul '||p_row_it.org_code||' - '||p_row_it.item_code||' ';
        Pkg_Err.p_err(v_err,'Atribute setate gresit:');
    END IF;
END;

/*********************************************************************************
    DDL:    24/03/2008  z   Create procedure
            09/04/2008  d   re-checked; added the COPY BOM parameter
/*********************************************************************************/
PROCEDURE p_duplicate_item      (   p_ref_item          INTEGER,
                                    p_new_item_code     VARCHAR2,
                                    p_copy_bom          VARCHAR2)
----------------------------------------------------------------------------------
--  PURPOSE:    creates a new ITEM starting from an existing one; copies its BOM, too
--  INPUT:      REF_ITEM        =   original Item line identifier
--              NEW_ITEM_CODE   =   item code for the new item
--              COPY_BOM        =   if Y, copies item's BOM, too
----------------------------------------------------------------------------------
IS
    CURSOR C_BOM_STD            (p_org_code VARCHAR2, p_father_code VARCHAR2)
                                IS
                                SELECT      b.*
                                FROM        BOM_STD     b
                                WHERE       org_code    =   p_org_code
                                    AND     father_code =   p_father_code
                                ;

    v_row_src                   ITEM%ROWTYPE;
    v_row_dest                  ITEM%ROWTYPE;
    it_bom                      Pkg_Rtype.ta_bom_std;
    v_idx                       PLS_INTEGER;

BEGIN

    Pkg_Err.p_reset_error_message();
    --
    IF p_new_item_code IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu ati precizat noul cod de articol !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check if we have idriga
    IF p_ref_item IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe un cod vechi valid !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;

    -- get the SRC item row
    v_row_src.idriga    :=  p_ref_item;
    Pkg_Get.p_get_item(v_row_src,-1);

    --
    v_row_dest              :=  v_row_src;
    v_row_dest.idriga        :=  NULL;
    v_row_dest.item_code     :=  Pkg_Lib.f_normalise(p_new_item_code);

    -- check if everything OK, by calling the BLO procedure on row item
    Pkg_Item.p_item_blo('I',v_row_dest);
    Pkg_Err.p_raise_error_message();
    -- insert the code
    Pkg_Iud.p_item_iud('I',v_row_dest);

    -- copy the BOM if requested
    IF NVL(p_copy_bom,'Y') = 'Y' THEN
        FOR x IN C_BOM_STD(v_row_src.org_code, v_row_src.item_code)
        LOOP
            v_idx                       :=  it_bom.COUNT + 1;
            it_bom(v_idx)               :=  x;
            it_bom(v_idx).father_code   :=  p_new_item_code;
            it_bom(v_idx).idriga        :=  NULL;

        END LOOP;
    END IF;
    Pkg_Iud.p_bom_std_miud('I', it_bom);


    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/********************************************************************************************
    DDL:    02/06/2008  z   Create procedure
/********************************************************************************************/
PROCEDURE p_item_replace    (   p_org_code      VARCHAR2, 
                                p_item_orig     VARCHAR2,
                                p_item_dest     VARCHAR2 
                            )
---------------------------------------------------------------------------------------------
--  PURPOSE:    replace an item code with a new code in all the structures that refers it 
---------------------------------------------------------------------------------------------
IS
    v_row_dest              ITEM%ROWTYPE;
    v_row_orig              ITEM%ROWTYPE;

BEGIN
    
    -- check if the destination item code already exists 
    v_row_dest.org_code      :=  p_org_code;
    v_row_dest.item_code     :=  p_item_dest;
    IF Pkg_Get2.f_get_item_2(v_row_dest) THEN
        Pkg_App_Tools.P_Log (   'M', 
                                'Codul '||p_item_dest||' exista deja definit !',
                                'Nu se poate inlocui codul'
                            );
    END IF;
    
    -- check if the source code exists 
    v_row_orig.org_code     :=  p_org_code;
    v_row_orig.item_code     :=  p_item_orig;
    IF NOT Pkg_Get2.f_get_item_2(v_row_orig) THEN
        Pkg_App_Tools.P_Log (   'M', 
                                'Codul '||p_item_orig||' nu este definit !',
                                'Nu se poate inlocui codul'
                            );
    END IF;

    Pkg_Lib.p_rae_m ('B');

    v_row_dest              :=  v_row_orig;
    v_row_dest.item_code    :=  p_item_dest;
    v_row_dest.idriga       :=  NULL;
    v_row_dest.workst       :=  NULL;
    v_row_dest.datagg       :=  NULL;
    v_row_dest.osuser       :=  NULL;
    v_row_dest.nuser        :=  NULL;
    v_row_dest.iduser       :=  NULL;
    v_row_dest.dcn          :=  NULL;

    Pkg_Iud.p_item_iud('I', v_row_dest);

    -- ACREC_DETAIL 
    UPDATE  ACREC_DETAIL
    SET     item_code       =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND item_code       =   p_item_orig
    ;

    -- BOM_GROUP 
    UPDATE  BOM_GROUP 
    SET     item_code       =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND item_code       =   p_item_orig
    ;
    
    -- BOM_STD - father column  
    UPDATE  BOM_STD
    SET     father_code     =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND father_code     =   p_item_orig
    ;

    -- BOM_STD - child column  
    UPDATE  BOM_STD
    SET     child_code      =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND child_code      =   p_item_orig
    ;

    -- PRIST_LIST_SALES   
    UPDATE  PRICE_LIST_SALES
    SET     item_code       =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND item_code       =   p_item_orig
    ;
    
    -- receipt_detail  
    UPDATE  RECEIPT_DETAIL 
    SET     item_code       =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND item_code       =   p_item_orig
    ;

    -- SHIPMENT_detail  
    UPDATE  SHIPMENT_DETAIL 
    SET     item_code       =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND item_code       =   p_item_orig
    ;

    -- WHS_TRN_detail  
    UPDATE  WHS_TRN_DETAIL 
    SET     item_code       =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND item_code       =   p_item_orig
    ;

    -- work_order  
    UPDATE  WORK_ORDER 
    SET     item_code       =   p_item_dest
    WHERE   org_code        =   p_org_code
        AND item_code       =   p_item_orig
    ;

    -- update 

    -- delete the old item 
    Pkg_Iud.p_item_iud('D',v_row_orig);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    11/06/2008  z Create procedure
            12/07/2008  d added the UM info (dst,src, conversion) 
/*********************************************************************************/
FUNCTION f_sql_item_mapping(    p_line_id       INTEGER,
                                p_org_code_src  VARCHAR2 DEFAULT NULL,
                                p_org_code_dst  VARCHAR2 DEFAULT NULL)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
    CURSOR C_LINES  (   p_line_id       INTEGER,
                        p_org_code_src  VARCHAR2,
                        p_org_code_dst  VARCHAR2)   
                    IS
                    SELECT      m.idriga,m.dcn,
                                m.org_code_src, m.item_code_src,
                                m.org_code_dst, m.item_code_dst,
                                m.note,m.puom,
                                --
                                s.description       s_description,
                                d.description       d_description,
                                s.puom              s_puom,
                                d.puom              d_puom,
                                su.si_uom           su_si_uom,
                                su.si_conversion    su_si_conversion,
                                du.si_uom           du_si_uom,
                                du.si_conversion    du_si_conversion
                    ---
                    FROM        ITEM_MAPPING    m
                    INNER JOIN  ITEM            s   ON  s.org_code      =   m.org_code_src
                                                    AND s.item_code     =   m.item_code_src
                    INNER JOIN  ITEM            d   ON  d.org_code      =   m.org_code_dst
                                                    AND d.item_code     =   m.item_code_dst
                    LEFT JOIN   PRIMARY_UOM     su  ON  su.puom         =   s.puom
                    LEFT JOIN   PRIMARY_UOM     du  ON  du.puom         =   d.puom  
                    ---
                    WHERE       m.org_code_src      =   p_org_code_src
                            AND m.org_code_dst      =   p_org_code_dst
                            AND p_line_id           IS  NULL
                    ----------
                    UNION ALL
                    ---------
                    SELECT      m.idriga,m.dcn,
                                m.org_code_src, m.item_code_src,
                                m.org_code_dst, m.item_code_dst,
                                m.note,m.puom,
                                --
                                s.description       s_description,
                                d.description       d_description,
                                s.puom              s_puom,
                                d.puom              d_puom,
                                su.si_uom           su_si_uom,
                                su.si_conversion    su_si_conversion,
                                du.si_uom           du_si_uom,
                                du.si_conversion    du_si_conversion
                    ---
                    FROM        ITEM_MAPPING    m
                    INNER JOIN  ITEM            s   ON  s.org_code      =   m.org_code_src
                                                    AND s.item_code     =   m.item_code_src
                    INNER JOIN  ITEM            d   ON  d.org_code      =   m.org_code_dst
                                                    AND d.item_code     =   m.item_code_dst
                    LEFT JOIN   PRIMARY_UOM     su  ON  su.puom         =   s.puom
                    LEFT JOIN   PRIMARY_UOM     du  ON  du.puom         =   d.puom  
                    ---
                    WHERE       m.idriga    =  p_line_id
                    ---------------------------
                    ORDER BY item_code_src, item_code_dst
                ;

    v_row               tmp_frm             :=  tmp_frm();
    v_t                 BOOLEAN;
BEGIN

    IF  p_line_id  IS NULL
        AND 
            (   p_org_code_src  IS NULL
                OR
                p_org_code_dst  IS NULL
             ) THEN
        Pkg_Err.p_rae('Nu ati selectat gestiunea sursa / destinatie !!!');
    END IF;
                
    FOR x IN C_LINES(p_line_id,p_org_code_src,p_org_code_dst) 
    LOOP

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;

        v_row.txt01         :=  x.org_code_src;
        v_row.txt02         :=  x.item_code_src;
        v_row.txt03         :=  x.s_description;
        v_row.txt04         :=  x.org_code_dst;
        v_row.txt05         :=  x.item_code_dst;
        v_row.txt06         :=  x.d_description;
        v_row.txt07         :=  x.note;
        v_row.txt08         :=  x.puom;
        v_row.txt09         :=  x.s_puom||'='||x.su_si_uom||'*'||x.su_si_conversion;
        v_row.txt10         :=  x.d_puom||'='||x.du_si_uom||'*'||x.du_si_conversion;


        pipe ROW(v_row);
    END LOOP;

    RETURN;

    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************
    DDL: 05/01/2009  d Create procedure
/*********************************************************************************/
PROCEDURE p_item_cost_blo   (p_tip VARCHAR2, p_row IN OUT ITEM_COST%ROWTYPE)
----------------------------------------------------------------------------------
--  BLO on ITEM_COST table 
----------------------------------------------------------------------------------
IS
    v_row_cst       COST_TYPE%ROWTYPE;
    v_context       VARCHAR2(200);
BEGIN
    -- get the COST TYPE row 
    v_row_cst.cost_code     :=  p_row.cost_code;
    Pkg_Get2.p_get_cost_type_2(v_row_cst);
    
    --
    v_context := 'Verificari care se refera la categoria de cost';
    IF v_row_cst.flag_updatable =   'N' THEN
        Pkg_Err.p_err('Acest tip de cost articol nu este modificabil direct de catre utilizator!', v_context);
    END IF;
    IF v_row_cst.flag_period = 'N' AND p_row.period_code IS NOT NULL THEN
        Pkg_Err.p_err('Pentru acest ti de cost nu se poate seta PERIOADA!',v_context);
    END IF;
    
    v_context := 'Verificari asupra datelor';
    IF p_row.end_date < TRUNC(SYSDATE) THEN
        Pkg_Err.p_err('- Acest cost este expirat. NU mai poate fi modificat!', v_context);
    END IF;
    IF p_row.family_code IS NULL AND p_row.item_code IS NULL THEN
        Pkg_Err.p_err('- Trebuie completat fie campul FAMILIE, fie campul ARTICOL!', v_context);
    END IF;
    IF p_row.family_code IS NOT NULL AND p_row.item_code IS NOT NULL THEN
        Pkg_Err.p_err('- Trebuie completat fie campul FAMILIE, fie campul ARTICOL!', v_context);
    END IF;
    IF p_row.unit_cost IS NULL OR p_row.unit_cost <= 0 THEN
        Pkg_Err.p_err('- Campul PRET UNITAR trebuie completat cu valori pozitive!', v_context);
    END IF;
    IF p_row.currency_code IS NULL THEN
        Pkg_Err.p_err('- Precizati VALUTA in care este exprimat costul!', v_context);
    END IF;
    IF p_row.start_date IS NULL THEN
        Pkg_Err.p_err('- Precizati DATA START pentru cost!', v_context);
    END IF;
    
    
    -- verificari pentru SERVICE  - production 
    CASE v_row_cst.cost_category 
        WHEN    'S' THEN
            v_context := 'Pentru servicii de prelucrare la terti';
            IF p_row.routing_code IS NULL THEN
                Pkg_Err.p_err('- Introduceti routing-ul care va fi efectuat ',v_context);
            END IF;
        WHEN    'MP' THEN
            v_context := 'Pentru oferte de pret de la furnizori ';
            IF p_row.routing_code IS NOT NULL THEN
                Pkg_Err.p_err('- Lasati campul ROUTING necompletat ',v_context);
            END IF;
        WHEN    'PF' THEN
            v_context := 'Pentru vanzare de produs finit ';
            IF p_row.routing_code IS NOT NULL THEN
                Pkg_Err.p_err('- Lasati campul ROUTING necompletat ',v_context);
            END IF;
        ELSE
            NULL;
--            v_context := 'CAz netratat';
--            Pkg_Err.p_err('- Categoria de cost '||v_row_cst.cost_category ,v_context);
    END CASE;
    
    Pkg_Err.p_rae;
    
END;

/*********************************************************************************
    DDL: 05/01/2009  d Create procedure
/*********************************************************************************/
PROCEDURE p_item_cost_iud   (p_tip VARCHAR2, p_row ITEM_COST%ROWTYPE)
----------------------------------------------------------------------------------
--  IUD on ITEM_COST table 
----------------------------------------------------------------------------------
IS
    v_row               ITEM_COST%ROWTYPE;
BEGIN
    v_row   :=  p_row;
    
    p_item_cost_blo(p_tip, v_row);
    
    Pkg_Iud.p_item_cost_iud(p_tip, v_row);
    
    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************
    DDL:    05/01/2008  d  
/*********************************************************************************/
FUNCTION f_sql_item_cost    (   p_line_id       INTEGER,
                                p_cost_code     VARCHAR2,
                                p_org_code      VARCHAR2,
                                p_partner_code  VARCHAR2,
                                p_only_active   VARCHAR2
                            )   RETURN          typ_frm     pipelined
IS
----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
    CURSOR C_LINES  (           p_line_id       INTEGER,
                                p_cost_code     VARCHAR2,
                                p_org_code      VARCHAR2,
                                p_partner_code  VARCHAR2,
                                p_only_active   VARCHAR2)   
                    IS
                    SELECT      c.idriga,c.dcn,
                                c.org_code          ,
                                c.item_code         ,
                                c.family_code       ,
                                c.oper_code_item    ,
                                c.routing_code      ,
                                c.quality           ,
                                c.partner_code      ,
                                c.unit_cost         ,
                                c.uom_code          ,
                                c.colour_code       ,
                                c.size_code         ,
                                c.season_code       ,
                                c.start_date        ,
                                c.end_date          ,
                                c.period_code       ,
                                c.currency_code     ,
                                i.description       i_description
                    ---
                    FROM        ITEM_COST       c
                    LEFT JOIN   ITEM            i   ON  i.org_code      =   c.org_code
                                                    AND i.item_code     =   c.item_code
                    ---
                    WHERE       c.org_code          =   p_org_code
                            AND c.cost_code         =   p_cost_code
                            AND p_line_id           IS  NULL
                    ----------
                    UNION ALL
                    ---------
                    SELECT      c.idriga,c.dcn,
                                c.org_code          ,
                                c.item_code         ,
                                c.family_code       ,
                                c.oper_code_item    ,
                                c.routing_code      ,
                                c.quality           ,
                                c.partner_code      ,
                                c.unit_cost         ,
                                c.uom_code          ,
                                c.colour_code       ,
                                c.size_code         ,
                                c.season_code       ,
                                c.start_date        ,
                                c.end_date          ,
                                c.period_code       ,
                                c.currency_code     ,
                                i.description       i_description
                    ---
                    FROM        ITEM_COST       c
                    INNER JOIN  ITEM            i   ON  i.org_code      =   c.org_code
                                                    AND i.item_code     =   c.item_code
                    ---
                    WHERE       c.idriga    =  p_line_id
                    ---------------------------
                    ;

    v_row               tmp_frm             :=  tmp_frm();
    v_t                 BOOLEAN;
BEGIN

    IF  p_line_id  IS NULL
        AND 
            (   p_org_code  IS NULL
                OR
                p_cost_code  IS NULL
             ) THEN
        Pkg_Err.p_rae('Parametri obligatorii: GESTIUNEA si TIP COST !!!');
    END IF;

    FOR x IN C_LINES(p_line_id, p_cost_code, p_org_code, p_partner_code, p_only_active) 
    LOOP
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;

        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.item_code;
        v_row.txt03         :=  x.i_description;
        v_row.txt04         :=  x.family_code;
        v_row.txt05         :=  x.oper_code_item;
        v_row.txt06         :=  x.routing_code;
        v_row.txt07         :=  x.partner_code;
        
        v_row.txt09         :=  x.uom_code;
        v_row.txt10         :=  x.colour_code;
        v_row.txt11         :=  x.size_code;
        v_row.txt12         :=  x.season_code;
        v_row.txt13         :=  p_cost_code;
        v_row.txt14         :=  x.period_code;
        v_row.txt15         :=  x.currency_code;
        
        v_row.numb01        :=  x.unit_cost;
        
        v_row.data01        :=  x.start_date;
        v_row.data02        :=  x.end_date;

        pipe ROW(v_row);
        
    END LOOP;

    RETURN;

EXCEPTION WHEN OTHERS THEN
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/***************************************************************************************
    DDL:21/07/2009 d create 
        13/11/2009 d added picture path 
/***************************************************************************************/
PROCEDURE p_rep_bom_std (   p_org_code      varchar2, 
                            p_father_code   varchar2, 
                            p_valued        varchar2, 
                            p_ref_size      varchar2)
-----------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------
IS

    CURSOR  C_BOM (p_org_code varchar2, p_father_code varchar2)
            IS
            SELECT      s.*,
                        i.description   i_description, 
                        i.puom          i_puom, 
                        i.flag_range    i_flag_range, 
                        i.oper_code     i_oper_code,
                        i.start_size    i_start_size, 
                        i.end_size      i_end_size,
                        o.oper_seq
            -------------------------------------------------------------------------
            FROM        BOM_STD     s
            INNER JOIN  ITEM        i   ON  i.org_code  =   s.org_code
                                        AND i.item_code =   s.child_code
            LEFT JOIN   OPERATION   o   ON  o.oper_code =   NVL(s.oper_code,i.oper_code)
            --------------------------------------------------------------------------                   
            WHERE       s.father_code   =   p_father_code
                    AND s.org_code      =   p_org_code
            --------------------------------------------------------------------------
            ORDER BY o.oper_seq, s.child_code, s.colour_code
            ;

    CURSOR C_COST (p_org_code varchar2, p_item_code varchar2, p_colour_code varchar2,
                    p_size_code varchar2)
            IS
            SELECT      k.unit_cost
            FROM        ITEM_COST   k
            WHERE       k.org_code  =   p_org_code
                AND     k.item_code =   p_item_code
                AND     k.cost_code =   'STD_PRICE'
                AND     k.start_date <  sysdate
                AND     NVL(k.end_date, sysdate+1) > sysdate
                AND     (
                        Pkg_Lib.f_diff_c(k.colour_code, p_colour_code)   = 0
                        OR
                        k.colour_code   IS NULL
                        )  
                AND     (
                        Pkg_Lib.f_diff_c(k.size_code, p_size_code)   = 0
                        OR
                        k.colour_code   IS NULL
                        )
             ORDER BY k.colour_code, k.size_code NULLS LAST
            ;
            
            
    C_SEGMENT constant VARCHAR2(30) := 'VW_REP_BOM_STD';            
    it_rep      Pkg_rtype.ta_vw_rep_bom_std;
    ix_rep      PLS_INTEGER;
    v_cost      NUMBER;
    v_found     BOOLEAN; 
    v_picture_path varchar2(200);
    rw_fth      ITEM%rowtype;
    
BEGIN

    DELETE FROM VW_REP_BOM_STD;

    rw_fth.org_code     :=  p_org_code;
    rw_fth.item_code    :=  p_father_code;
    Pkg_Get2.p_get_item_2(rw_fth);
    
    v_picture_path := Pkg_Env.f_get_picture_path(p_org_code);
    
    FOR x IN C_BOM (p_org_code, p_father_code) 
    LOOP
        IF p_valued = 'Y' THEN
            -- get the COST 
            OPEN C_COST(p_org_code, x.child_code, x.colour_code, null);
            FETCH C_COST INTO v_cost; IF C_COST%NOTFOUND THEN v_cost := 0; END IF;
            CLOSE C_COST;
        ELSE
            v_cost  :=  NULL;
        END IF;
        
        ix_rep                          :=  it_rep.count + 1;
        it_rep(ix_rep).org_code         :=  x.org_code;
        it_rep(ix_rep).father_code      :=  x.father_code;
        it_rep(ix_rep).father_desc      :=  null;
        it_rep(ix_rep).child_code       :=  x.child_code;
        it_rep(ix_rep).child_desc       :=  RPAD(SUBSTR(x.i_description,1,30), 30);
        it_rep(ix_rep).child_desc       :=  it_rep(ix_rep).child_desc 
                                        ||' ' 
                                        ||SUBSTR(x.i_oper_code,1,2); 

        IF x.i_flag_range = -1 THEN
            it_rep(ix_rep).child_desc   := it_rep(ix_rep).child_desc 
                                        ||' '||x.i_start_size
                                        ||'->'
                                        ||x.i_end_size;
        END IF;

        it_rep(ix_rep).colour_code      :=  x.colour_code;
        it_rep(ix_rep).start_size       :=  x.start_size;
        it_rep(ix_rep).end_size         :=  x.end_size;
        it_rep(ix_rep).child_uom        :=  x.i_puom;
        it_rep(ix_rep).oper_code        :=  NVL(x.oper_code, x.i_oper_code);
        it_rep(ix_rep).oper_seq         :=  x.oper_seq;
        it_rep(ix_rep).unit_qty         :=  x.qta;
        it_rep(ix_rep).unit_price       :=  v_cost;
        it_rep(ix_rep).child_price      :=  it_rep(ix_rep).unit_qty 
                                            *   
                                            it_rep(ix_rep).unit_price;
        -- set the total column 
        IF  (
            x.i_flag_range = -1 
            AND 
            p_ref_size between NVL(x.start_size, x.i_start_size) AND NVL(x.end_size, x.i_end_size) 
            )
            OR
            x.i_flag_range = 0
        THEN
            it_rep(ix_rep).tot_price := it_rep(ix_rep).child_price;
        END IF;

        it_rep(ix_rep).segment_code     :=  C_SEGMENT;  
        it_rep(ix_rep).rep_title        :=  'Norma de consum ';
        IF p_valued = 'Y' THEN 
            it_rep(ix_rep).rep_title:= it_rep(ix_rep).rep_title||'valorizata';
        ELSE 
            it_rep(ix_rep).rep_title:= it_rep(ix_rep).rep_title||'nevalorizata'; 
        END IF;
        it_rep(ix_rep).rep_info :=  'Gestiune:  '||p_org_code||Pkg_Glb.C_NL||
                                    'Articol:   '||p_father_code||Pkg_Glb.C_NL||
                                    'Marime Ref:'||p_ref_size;
        it_rep(ix_rep).picture_path := v_picture_path||rw_fth.root_code||'.jpg';
    END LOOP;

    
    Pkg_iud.p_vw_rep_bom_std_miud('I', it_rep);
    
END;

END;

/

/
