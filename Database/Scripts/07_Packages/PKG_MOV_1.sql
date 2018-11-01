--------------------------------------------------------
--  DDL for Package Body PKG_MOV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_MOV" 
IS

-- pach 20061102

-------------------------------------------------------------------------------------
PROCEDURE   p_get_next_doc_number (     p_doc_type          VARCHAR,
                                        p_org_code          VARCHAR2,
                                        p_num_year          VARCHAR2,
                                        p_next_doc_number   OUT NUMBER
                                        )
IS
    CURSOR  C_LINES(p_doc_type  VARCHAR2,
                    p_org_code  VARCHAR2,
                    p_num_year  VARCHAR2) IS
                    SELECT  *
                    FROM    APP_DOC_NUMBER
                    WHERE       doc_type    =   p_doc_type
                            AND org_code    =   p_org_code
                            AND num_year    =   p_num_year
                    FOR UPDATE
                    ;


    v_row           C_LINES%ROWTYPE;
    v_org_code      VARCHAR2(10);
    v_found         BOOLEAN;
BEGIN
    --
    v_org_code      :=    NVL(p_org_code,'X');
    OPEN    C_LINES(p_doc_type, v_org_code,p_num_year);
    FETCH   C_LINES INTO    v_row;
    v_found     :=  C_LINES%FOUND;
    CLOSE   C_LINES;
    --
    IF v_found  THEN
        IF v_row.num_current < v_row.num_start THEN
            p_next_doc_number   :=  v_row.num_start;
        ELSE
            p_next_doc_number   :=  v_row.num_current + 1;
        END IF;
    ELSE
        p_next_doc_number   :=  0;
    END IF;
    --
    v_row.num_current   :=  p_next_doc_number;
    --
    UPDATE APP_DOC_NUMBER SET ROW = v_row WHERE idriga = v_row.idriga;
    --
END;

-------------------------------------------------------------------------
PROCEDURE p_item_stoc(      it_stoc         IN OUT Pkg_Mov.typ_stoc,
                            p_item          VARCHAR2,
                            p_org_code      VARCHAR2,
                            p_whs_code      VARCHAR2    DEFAULT NULL,
                            p_season_code   VARCHAR2    DEFAULT NULL,
                            p_size_code     VARCHAR2    DEFAULT NULL,
                            p_colour_code   VARCHAR2    DEFAULT NULL,
                            p_oper_code     VARCHAR2    DEFAULT NULL
                     )
IS
/*
        Pkg_Mov.p_item_stoc( it_stoc        =>  v_stoc,
                             p_item         =>  v_row_bgr.item_code,
                             p_org_code     =>  v_row_grp.client,
                             p_whs_code     =>  NULL, -- toate magaziile
                             p_season_code  =>  v_row_grp.season_code,
                             p_size_code    =>  v_row_bgr.size_code,
                             p_colour_code  =>  v_row_bgr.colour_code,
                             p_oper_code    =>  NULL  -- nu ma intereseaza
                            );
*/
    CURSOR C_STOC   (   p_item          VARCHAR2,
                        p_org_code      VARCHAR2,
                        p_whs_code      VARCHAR2,
                        p_season_code   VARCHAR2,
                        p_size_code     VARCHAR2,
                        p_colour_code   VARCHAR2,
                        p_oper_code     VARCHAR2) IS
                                   SELECT *
                                   FROM   STOC_ONLINE
                                   WHERE      item_code                       =     p_item
                                          AND org_code                        =     p_org_code
                                          AND whs_code                        LIKE NVL(p_whs_code,      '%')
                                          AND season_code                     LIKE NVL(p_season_code,   '%')
                                          AND NVL(size_code  ,Pkg_Glb.C_RN)   LIKE NVL(p_size_code,     '%')
                                          AND NVL(colour_code,Pkg_Glb.C_RN)   LIKE NVL(p_colour_code,   '%')
                                          AND NVL(oper_code_item,  Pkg_Glb.C_RN)   LIKE NVL(p_oper_code,     '%')
                                          AND qty                             <>   0 -- numai cele diferite
                                   ORDER BY whs_code,size_code,colour_code,season_code;
    v_index     VARCHAR2(1000);

BEGIN
    it_stoc.DELETE;
    FOR x IN C_STOC(    p_item          ,
                        p_org_code      ,
                        p_whs_code      ,
                        p_season_code   ,
                        p_size_code     ,
                        p_colour_code   ,
                        p_oper_code
                    )
    LOOP

        v_index := Pkg_Mov.f_get_idx_item_stoc
                   (   p_whs_code      =>  x.whs_code,
                       p_season_code   =>  x.season_code,
                       p_size_code     =>  x.size_code,
                       p_colour_code   =>  x.colour_code,
                       p_oper_code     =>  x.oper_code_item,
                       p_group_code    =>  x.group_code,
                       p_order_code    =>  x.order_code
                    );

         it_stoc(v_index) := x.qty;
    END LOOP;
END;

PROCEDURE p_item_stoc(      it_stoc         IN OUT NOCOPY Pkg_Glb.type_dim_10,
                            p_item          VARCHAR2,
                            p_org_code      VARCHAR2,
                            p_whs_code      VARCHAR2    DEFAULT NULL,
                            p_season_code   VARCHAR2    DEFAULT NULL,
                            p_size_code     VARCHAR2    DEFAULT NULL,
                            p_colour_code   VARCHAR2    DEFAULT NULL,
                            p_oper_code     VARCHAR2    DEFAULT NULL
                     )
IS
/*
        Pkg_Mov.p_item_stoc( it_stoc        =>  v_stoc,
                             p_item         =>  v_row_bgr.item_code,
                             p_org_code     =>  v_row_grp.client,
                             p_whs_code     =>  NULL, -- toate magaziile
                             p_season_code  =>  v_row_grp.season_code,
                             p_size_code    =>  v_row_bgr.size_code,
                             p_colour_code  =>  v_row_bgr.colour_code,
                             p_oper_code    =>  NULL  -- nu ma intereseaza
                            );
*/
    CURSOR C_STOC   (   p_item          VARCHAR2,
                        p_org_code      VARCHAR2,
                        p_whs_code      VARCHAR2,
                        p_season_code   VARCHAR2,
                        p_size_code     VARCHAR2,
                        p_colour_code   VARCHAR2,
                        p_oper_code     VARCHAR2) IS
                                   SELECT *
                                   FROM   STOC_ONLINE
                                   WHERE      item_code                       =     p_item
                                          AND org_code                        =     p_org_code
                                          AND whs_code                        LIKE NVL(p_whs_code,      '%')
                                          AND season_code                     LIKE NVL(p_season_code,   '%')
                                          AND NVL(size_code  ,Pkg_Glb.C_RN)   LIKE NVL(p_size_code,     '%')
                                          AND NVL(colour_code,Pkg_Glb.C_RN)   LIKE NVL(p_colour_code,   '%')
                                          AND NVL(oper_code_item,  Pkg_Glb.C_RN)   LIKE NVL(p_oper_code,     '%')
                                          AND qty                             <>   0 -- numai cele diferite
                                   ORDER BY whs_code,size_code,colour_code,season_code;
    v_index     VARCHAR2(1000);

BEGIN
    it_stoc.DELETE;
    FOR x IN C_STOC(    p_item          ,
                        p_org_code      ,
                        p_whs_code      ,
                        p_season_code   ,
                        p_size_code     ,
                        p_colour_code   ,
                        p_oper_code
                    )
    LOOP

        Pkg_Lib.p_load_mdim(    p_it        =>  it_stoc,
                                p_number    =>  x.qty,
                                p_1         =>  x.whs_code,
                                p_2         =>  x.season_code,
                                p_3         =>  x.size_code,
                                p_4         =>  x.colour_code,
                                p_5         =>  x.oper_code_item,
                                p_6         =>  x.group_code,
                                p_7         =>  x.order_code
                            );
     END LOOP;
END;




--------------------------------------------------------------------------------------------
FUNCTION f_get_idx_item_stoc    (   p_whs_code      VARCHAR2,
                                    p_season_code   VARCHAR2,
                                    p_size_code     VARCHAR2    DEFAULT NULL    ,
                                    p_colour_code   VARCHAR2    DEFAULT NULL    ,
                                    p_oper_code     VARCHAR2    DEFAULT NULL    ,
                                    p_group_code    VARCHAR2    DEFAULT NULL    ,
                                    p_order_code    VARCHAR2    DEFAULT NULL
                                 ) RETURN VARCHAR2
IS
 /*
     v_index := Pkg_Mov.f_get_idx_item_stoc
                (   p_whs_code      =>  ,
                    p_season_code   =>  ,
                    p_size_code     =>  ,
                    p_colour_code   =>  ,
                    p_oper_code     =>  ,
                    p_group_code    =>  ,
                    p_order_code    =>
                 );
 */
    v_rezultat      VARCHAR2(1000);
BEGIN
    v_rezultat  :=      p_whs_code
                    ||  p_season_code
                    ||  NVL(p_size_code     , Pkg_Glb.C_RN)
                    ||  NVL(p_colour_code   , Pkg_Glb.C_RN)
                    ||  NVL(p_oper_code     , Pkg_Glb.C_RN)
                    ||  NVL(p_group_code    , Pkg_Glb.C_RN)
                    ||  NVL(p_order_code    , Pkg_Glb.C_RN)
                    ;
    RETURN  v_rezultat;
END;


/*********************************************************************************
    DDL: 24/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_whs_trn_engine ( p_row_trn       IN OUT WHS_TRN%ROWTYPE  )
----------------------------------------------------------------------------------
--  PURPOSE:    movement engine
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    CURSOR  C_LINES IS
            SELECT          t.*,
                            w.category_code
            FROM            VW_BLO_PREPARE_TRN  t
            INNER   JOIN    WAREHOUSE           w
                                ON  w.whs_code  =   t.whs_code
            ORDER BY    t.trn_sign ASC,
                        t.item_code,t.colour_code,t.size_code,t.oper_code_item
            ;

    v_row_trh           WHS_TRN%ROWTYPE;
    v_row_trd           WHS_TRN_DETAIL%ROWTYPE;

    it_det              Pkg_Rtype.ta_whs_trn_detail;
    TYPE type_stc       IS TABLE OF STOC_ONLINE%ROWTYPE INDEX BY Pkg_Glb.type_index;
    it_stc              type_stc;
    it_new_stc          type_stc;
    it_stoc             Pkg_Mov.typ_stoc;
    v_str_idx           Pkg_Glb.type_index;
    v_stoc              NUMBER;
    C_DOC_TYPE          VARCHAR2(32000) :=  'WHSTRN';
    C_ERR_CODE          VARCHAR2(32000) :=  'CHCK_STOC';
    C_LOCK_CODE         VARCHAR2(32000) :=  'WHSTRN';

    v_t                 BOOLEAN;

BEGIN
    -- serialize the movement creation
    Pkg_Lib.p_locking_service(C_LOCK_CODE);
    --
    Pkg_Err.p_reset_error_message();
    --
    v_row_trh   :=  p_row_trn;
    --
    v_row_trh.trn_date  :=  v_row_trh.date_legal;
    v_row_trh.trn_year  :=  TO_CHAR(v_row_trh.date_legal,'YYYY');
    --
    -- check the date legal
    Pkg_Mov.p_check_date_legal(
                                p_date_legal    =>  v_row_trh.date_legal,
                                p_note          =>  'Tip miscare : '
                                                    ||v_row_trh.trn_type
                               );
    Pkg_Err.p_raise_error_message();

    --
    v_row_trh.trn_code  :=  Pkg_Env.f_get_app_doc_number
                            (   p_org_code      =>  v_row_trh.org_code  ,
                                p_doc_type      =>  C_DOC_TYPE          ,
                                p_doc_subtype   =>  v_row_trh.trn_type  ,
                                p_num_year      =>  v_row_trh.trn_year
                             );

    -- create movement header
    Pkg_Iud.p_whs_trn_iud('I',v_row_trh);
    v_row_trh.idriga    :=  Pkg_Lib.f_read_pk();
    ---- reset the parameter
    p_row_trn   :=  v_row_trh;
    -- create movement detail
    FOR x IN C_LINES LOOP
        v_row_trd.ref_trn           :=      v_row_trh.idriga ;
        v_row_trd.org_code          :=      x.org_code;
        v_row_trd.item_code         :=      x.item_code;
        v_row_trd.trn_sign          :=      x.trn_sign;
        v_row_trd.qty               :=      x.qty;
        v_row_trd.whs_code          :=      x.whs_code;
        v_row_trd.colour_code       :=      x.colour_code;
        v_row_trd.size_code         :=      x.size_code;
        v_row_trd.order_code        :=      x.order_code;
        v_row_trd.group_code        :=      x.group_code;
        v_row_trd.puom              :=      x.puom;
        v_row_trd.season_code       :=      x.season_code;
        v_row_trd.wc_code           :=      x.wc_code;
        v_row_trd.cost_center       :=      x.cost_center;
        v_row_trd.account_code      :=      NULL;
        v_row_trd.ref_receipt        :=      x.ref_receipt;
        v_row_trd.oper_code_item    :=      x.oper_code_item ;
        v_row_trd.reason_code       :=      x.reason_code ;

        it_det(it_det.COUNT+1)  :=      v_row_trd;






        IF v_row_trd.trn_sign > 0 THEN
            -- for the in movements acumuleit the quantities to take into
            -- consideration for the checking of the stocs for the
            -- out movements !!!!!!!!

            v_str_idx   :=  Pkg_Lib.f_str_idx(
                                              v_row_trd.org_code        ,
                                              v_row_trd.item_code       ,
                                              v_row_trd.colour_code     ,
                                              v_row_trd.size_code       ,
                                              v_row_trd.order_code      ,
                                              v_row_trd.whs_code        ,
                                              v_row_trd.season_code     ,
                                              v_row_trd.oper_code_item  ,
                                              v_row_trd.group_code
                                              );
           IF it_new_stc.EXISTS(v_str_idx) THEN
                it_new_stc(v_str_idx).qty   :=  it_new_stc(v_str_idx).qty + x.qty;
           ELSE
                it_new_stc(v_str_idx).qty   :=  x.qty;
           END IF;

        ELSIF
            -- for checking the stocs
            -- check the stoc only for certain warehouse categories
             v_row_trd.trn_sign  <   0
            AND (
                    (
                    x.category_code     IN
                                       (    Pkg_Glb.C_WHS_MPC,
                                            Pkg_Glb.C_WHS_MPP,
                                            Pkg_Glb.C_WHS_PAT,
                                            Pkg_Glb.C_WHS_SHP
                                       )
                    )
                    OR -- this is for storno of declaration of production and versamento
                    (
                    x.category_code     IN
                                       (    Pkg_Glb.C_WHS_CTL,
                                            Pkg_Glb.C_WHS_WIP
                                       )
                    AND  v_row_trh.trn_type IN (
                                                Pkg_Glb.C_TRN_PROD,
                                                Pkg_Glb.C_TRN_TRN_FIN
                                                )
                    ---------------------------------------------------
                    --- TO CHECK !!!!!!!!!!!!!!!!!!!
                    ---------------------------------------------------
                    AND v_row_trd.order_code IS NOT NULL
                    AND v_row_trh.flag_storno   =   'S'
                    )
                    OR
                    -- this is the not allocated in WIP to not let go into negative
                    (
                       x.category_code     IN
                                          (    Pkg_Glb.C_WHS_CTL,
                                               Pkg_Glb.C_WHS_WIP
                                          )
                       AND
                       x.group_code     IS NULL
                    )
                )
        THEN
            --

            v_str_idx   :=  Pkg_Lib.f_str_idx(
                                              v_row_trd.org_code        ,
                                              v_row_trd.item_code       ,
                                              v_row_trd.colour_code     ,
                                              v_row_trd.size_code       ,
                                              v_row_trd.order_code      ,
                                              v_row_trd.whs_code        ,
                                              v_row_trd.season_code     ,
                                              v_row_trd.oper_code_item  ,
                                              v_row_trd.group_code
                                              );
           IF it_stc.EXISTS(v_str_idx) THEN
                it_stc(v_str_idx).qty   :=  it_stc(v_str_idx).qty + x.qty;
           ELSE
                it_stc(v_str_idx).org_code      :=  v_row_trd.org_code;
                it_stc(v_str_idx).item_code     :=  v_row_trd.item_code;
                it_stc(v_str_idx).colour_code   :=  v_row_trd.colour_code;
                it_stc(v_str_idx).size_code     :=  v_row_trd.size_code;
                it_stc(v_str_idx).order_code    :=  v_row_trd.order_code;
                it_stc(v_str_idx).whs_code      :=  v_row_trd.whs_code;
                it_stc(v_str_idx).season_code   :=  v_row_trd.season_code;
                it_stc(v_str_idx).oper_code_item:=  v_row_trd.oper_code_item;
                it_stc(v_str_idx).group_code    :=  v_row_trd.group_code;
                it_stc(v_str_idx).qty           :=  x.qty;
           END IF;
        END IF;
    END LOOP;
    -- now check the stoc
    v_str_idx   :=  it_stc.FIRST;
    WHILE v_str_idx IS NOT NULL LOOP

        Pkg_Mov.p_item_stoc( it_stoc        =>  it_stoc,
                             p_item         =>  it_stc(v_str_idx).item_code,
                             p_org_code     =>  it_stc(v_str_idx).org_code
                            );


        v_stoc  :=       Pkg_Mov.f_item_stoc (  it_stoc         =>  it_stoc,
                                                p_whs_code      =>  it_stc(v_str_idx).whs_code,
                                                p_season_code   =>  it_stc(v_str_idx).season_code,
                                                p_size_code     =>  it_stc(v_str_idx).size_code,
                                                p_colour_code   =>  it_stc(v_str_idx).colour_code,
                                                p_oper_code     =>  it_stc(v_str_idx).oper_code_item,
                                                p_group_code    =>  it_stc(v_str_idx).group_code,
                                                p_order_code    =>  it_stc(v_str_idx).order_code
                                             );

        -- there is an accumulated stock in this movement from the in movements
        -- take it into consideration
        IF it_new_stc.EXISTS(v_str_idx) THEN
            v_stoc  :=  v_stoc  + it_new_stc(v_str_idx).qty;
        END IF;

        -- if we want to download more give an error
        v_t     :=  it_stc(v_str_idx).qty > v_stoc;

       --- v_t     :=  FALSE;

        IF v_t THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => C_ERR_CODE,
                  p_err_header        => 'Pentru miscare de tip '
                                        ||v_row_trh.trn_type
                                        ||' pentru urmatoarele pozitii nu exista stoc '
                                        ||' in magazia din care vreti sa descarcati ('||it_stc(v_str_idx).whs_code||') !!!',
                  p_err_detail        => it_stc(v_str_idx).org_code||'-'
                                        ||RPAD(it_stc(v_str_idx).item_code ,15)
                                        ||'stoc :'||LPAD(v_stoc,10)
                                        ||', misc :  '||LPAD(it_stc(v_str_idx).qty,10)     ||Pkg_Glb.C_NL
                                        ||'---------------------------------------------------'||Pkg_Glb.C_NL
                                        ||'magazie : '||it_stc(v_str_idx).whs_code        ||Pkg_Glb.C_NL
                                        ||'stagiune: '||it_stc(v_str_idx).season_code     ||Pkg_Glb.C_NL
                                        ||'comanda : '||it_stc(v_str_idx).group_code      ||Pkg_Glb.C_NL
                                        ||'culoare : '||it_stc(v_str_idx).colour_code     ||Pkg_Glb.C_NL
                                        ||'marime  : '||it_stc(v_str_idx).size_code       ||Pkg_Glb.C_NL
                                        ||'operatie: '||it_stc(v_str_idx).oper_code_item  ||Pkg_Glb.C_NL
                                        ||'bola    : '||it_stc(v_str_idx).order_code      ||Pkg_Glb.C_NL
                                            ,
                  p_flag_immediate    => 'N'
             );
        END IF;
        --
        v_str_idx   :=  it_stc.NEXT(v_str_idx);
    END LOOP;
    --
    Pkg_Err.p_raise_error_message();
    --
    Pkg_Iud.p_whs_trn_detail_miud('I',it_det);
    --
    EXCEPTION
    WHEN OTHERS THEN
           Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
------------------------------------------------------------------------------------------------
FUNCTION f_item_stoc (  it_stoc         IN Pkg_Mov.typ_stoc,
                        p_whs_code      VARCHAR2,
                        p_season_code   VARCHAR2,
                        p_size_code     VARCHAR2    DEFAULT NULL,
                        p_colour_code   VARCHAR2    DEFAULT NULL,
                        p_oper_code     VARCHAR2    DEFAULT NULL,
                        p_group_code    VARCHAR2    DEFAULT NULL,
                        p_order_code    VARCHAR2    DEFAULT NULL
                        ) RETURN NUMBER
IS

/*
    Pkg_mov.f_item_stoc (  it_stoc      =>  ,
                        p_whs_code      =>  ,
                        p_season_code   =>  ,
                        p_size_code     =>  ,
                        p_colour_code   =>  ,
                        p_oper_code     =>  ,
                        p_group_code    =>  ,
                        p_order_code    =>
                        );
*/



    v_result        NUMBER;
    v_index         VARCHAR2(1000);
BEGIN
    --
    v_index := Pkg_Mov.f_get_idx_item_stoc
                (   p_whs_code      =>  p_whs_code,
                    p_season_code   =>  p_season_code,
                    p_size_code     =>  p_size_code,
                    p_colour_code   =>  p_colour_code,
                    p_oper_code     =>  p_oper_code,
                    p_group_code    =>  p_group_code,
                    p_order_code    =>  p_order_code
                 );
    --
    IF it_stoc.EXISTS(v_index) THEN
        v_result    :=  it_stoc(v_index);
    ELSE
        v_result    :=  0;
    END IF;
    RETURN  v_result;
END;

/*********************************************************************************
    DDL: 16/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_trn_plan_header(
                                p_line_id       INTEGER ,
                                p_org_code      VARCHAR2 DEFAULT NULL
                               )  RETURN typ_longinfo  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the TRN_PLAN_HEADER
--
--  PREREQ:
--
--  INPUT:      ORG_CODE        = client
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_line_id  INTEGER, p_org_code VARCHAR2)   IS
                 SELECT
                        h.idriga, h.dcn,
                        h.plan_code, h.plan_date, h.trn_type, h.org_code, h.whs_code,
                        h.group_code, h.order_code, h.item_code, h.colour_code,
                        h.size_code, h.oper_code_item, h.season_code, h.partner_code,
                        h.doc_code, h.doc_date, h.date_legal, h.employee_code,
                        h.note, h.oper_code, h.suppl_code, h.status,
                        h.pick_parameter h_pick_parameter, h.joly_parameter ,
                        --
                        s.description, s.flag_plan, s.seq_no,
                        s.pick_parameter s_pick_parameter,
                        s.pick_form_index
                FROM        TRN_PLAN_HEADER      h
                INNER JOIN  MOVEMENT_TYPE        s
                                ON  h.trn_type     =   s.trn_type
                WHERE       h.org_code      LIKE    NVL(p_org_code, '%')
                        AND h.status        =       'I'
                        AND p_line_id       IS      NULL
                ---------
                UNION ALL
                ---------
                 SELECT
                        h.idriga, h.dcn,
                        h.plan_code, h.plan_date, h.trn_type, h.org_code, h.whs_code,
                        h.group_code, h.order_code, h.item_code, h.colour_code,
                        h.size_code, h.oper_code_item, h.season_code, h.partner_code,
                        h.doc_code, h.doc_date, h.date_legal, h.employee_code,
                        h.note, h.oper_code, h.suppl_code, h.status,
                        h.pick_parameter h_pick_parameter, h.joly_parameter ,
                        --
                        s.description, s.flag_plan, s.seq_no,
                        s.pick_parameter s_pick_parameter,
                        s.pick_form_index
                FROM        TRN_PLAN_HEADER      h
                INNER JOIN  MOVEMENT_TYPE        s
                                ON  h.trn_type     =   s.trn_type
                WHERE       h.idriga          =       p_line_id
                -------------
                ORDER BY plan_code DESC
                ;
    --
    v_row               tmp_longinfo             :=  tmp_longinfo();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --




    FOR x IN C_LINES(p_line_id, p_org_code) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.plan_code ;
        v_row.txt02         :=  x.trn_type  ;
        v_row.txt03         :=  x.org_code  ;
        v_row.txt04         :=  x.whs_code  ;
        v_row.txt05         :=  x.h_pick_parameter;
        v_row.txt06         :=  x.order_code  ;
        v_row.txt08         :=  x.colour_code  ;
        v_row.txt09         :=  x.size_code  ;
        v_row.txt10         :=  x.oper_code_item  ;
        v_row.txt11         :=  x.season_code   ;
        v_row.txt12         :=  x.partner_code   ;
        v_row.txt13         :=  x.doc_code   ;
        v_row.txt14         :=  x.employee_code   ;
        v_row.txt15         :=  x.note    ;
        v_row.txt16         :=  x.oper_code;
        v_row.txt17         :=  x.suppl_code;
        v_row.txt18         :=  x.joly_parameter;
        v_row.txt19         :=  x.description;
        v_row.txt20         :=  x.pick_form_index;
        v_row.txt21         :=  x.s_pick_parameter;


        v_row.txt49         :=  x.group_code  ;
        v_row.txt50         :=  x.item_code  ;



        --
        v_row.data01        :=  x.plan_date ;
        v_row.data02        :=  x.doc_date  ;
        v_row.data03        :=  x.date_legal  ;

        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
-----------------------------------------------------------------------------------------------------------------
/*********************************************************************************
    DDL: 16/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_trn_plan_detail(     p_line_id   INTEGER,
                                    p_ref_plan  INTEGER  DEFAULT NULL
                              )  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the TRN_PLAN_DETAIL
--
--  PREREQ:
--
--  INPUT:      REF_PLAN        = IDRIGA from TRN_PLAN_HEADER
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_line_id INTEGER,p_ref_plan INTEGER)   IS
                SELECT          d.dcn, d.idriga, d.ref_plan, d.org_code, d.item_code,
                                d.colour_code, d.size_code, d.oper_code_item, d.whs_code_out,
                                d.whs_code_in, d.season_code_out, d.season_code_in,
                                d.group_code_out, d.order_code, d.cost_center,
                                d.account_code, d.qty, d.uom, d.note, d.qty_puom,
                                d.puom, d.group_code_in  ,
                                ---
                                i.description   i_description,
                                ---
                                c.description   c_description
                FROM            TRN_PLAN_DETAIL     d
                INNER JOIN      ITEM                i
                                    ON  i.org_code  =   d.org_code
                                    AND i.item_code =   d.item_code
                LEFT JOIN       COLOUR              c
                                    ON  c.org_code      =   d.org_code
                                    AND c.colour_code   =   d.colour_code
                WHERE       d.ref_plan      =   p_ref_plan
                        AND p_line_id       IS      NULL
                -----
                UNION ALL
                ---
                SELECT          d.dcn, d.idriga, d.ref_plan, d.org_code, d.item_code,
                                d.colour_code, d.size_code, d.oper_code_item, d.whs_code_out,
                                d.whs_code_in, d.season_code_out, d.season_code_in,
                                d.group_code_out, d.order_code, d.cost_center,
                                d.account_code, d.qty, d.uom, d.note, d.qty_puom,
                                d.puom, d.group_code_in  ,
                                ---
                                i.description   i_description,
                                ---
                                c.description   c_description
                FROM            TRN_PLAN_DETAIL     d
                INNER JOIN      ITEM                i
                                    ON  i.org_code  =   d.org_code
                                    AND i.item_code =   d.item_code
                LEFT JOIN       COLOUR              c
                                    ON  c.org_code      =   d.org_code
                                    AND c.colour_code   =   d.colour_code
                WHERE       d.idriga    =   p_line_id
                ---
                ORDER BY    idriga ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES(p_line_id,p_ref_plan) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code          ;
        v_row.txt02         :=  x.item_code         ;
        v_row.txt03         :=  x.i_description       ;
        v_row.txt04         :=  x.colour_code       ;
        v_row.txt05         :=  x.size_code         ;
        v_row.txt06         :=  x.oper_code_item    ;
        v_row.txt07         :=  x.whs_code_out   ;
        v_row.txt08         :=  x.whs_code_in   ;
        v_row.txt09         :=  x.season_code_out   ;
        v_row.txt10         :=  x.season_code_in   ;
        v_row.txt11         :=  x.group_code_out    ;
        v_row.txt12         :=  x.order_code    ;
        v_row.txt13         :=  x.cost_center    ;
        v_row.txt14         :=  x.account_code    ;
        v_row.txt15         :=  x.uom     ;
        v_row.txt16         :=  x.puom     ;
        v_row.txt17         :=  x.note      ;
        v_row.txt18         :=  x.group_code_in   ;
        v_row.txt19         :=  x.c_description   ;

        --
        v_row.numb01        :=  x.ref_plan;
        v_row.numb02        :=  x.qty;
        v_row.numb03        :=  x.qty_puom;

        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
-----------------------------------------------------------------------------------------------------------------
/*********************************************************************************
    DDL: 16/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_trn_plan_header_iud(p_tip VARCHAR2, p_row TRN_PLAN_HEADER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               TRN_PLAN_HEADER%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Mov.p_trn_plan_header_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_trn_plan_header_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 16/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_trn_plan_header_blo(p_tip VARCHAR2, p_row IN OUT TRN_PLAN_HEADER%ROWTYPE)
/*----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted

                * Pkg_Glb.C_TRN_TRN_CNS
                       - required parameters:
                            - SUPPL_CODE - the organization has to be FTY
                            - WORK_GROUP - a list of work groups

                       - check if WORK_GROUP exists in the sistem
                       - check if WORK_GROUP has operations for FTY
                       - check if specified operations exists in FTY for WORK_GROUP

                * Pkg_Glb.C_TRN_SHP_CTL
                       - required parameters:
                            - SUPPL_CODE - the organization has to be outside processing
                            - WHS_CODE   - from which to send the items (has to be MPC,MPP)
                            - SEASON_CODE

                * Pkg_Glb.C_TRN_REC_CTL
                       - required parameters:
                            - SUPPL_CODE - the organization has to be outside processing
                            - WHS_CODE   - from which to receive items (has to be associated to the supplier)
                            - SEASON_CODE
                            - JOLY_PARAMETER - that specify
                                    MP  - for return of raw materials or
                                    SP  - for receiving of processed items



                * pkg_glb.C_TRN_TRN_RET
                        - required parameters
                            - WHS_CODE - should be WIP
                            - SEASON_CODE


                * pkg_glb.C_TRN_TRN_SEA
                        - required parameters
                            - WHS_CODE -
                            - SEASON_CODE


--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------*/
IS

    C_DOC_TYPE          VARCHAR2(32000) :=  'TRNPLAN';

    v_mod_col           VARCHAR2(32000);
    v_detail_count      INTEGER;

    v_row_old           TRN_PLAN_HEADER%ROWTYPE;

    v_row_cli           ORGANIZATION%ROWTYPE;
    v_row_sup           ORGANIZATION%ROWTYPE;
    v_row_grp           WORK_GROUP%ROWTYPE;
    v_row_opr           OPERATION%ROWTYPE;
    v_row_whs           WAREHOUSE%ROWTYPE;
    v_row_sea           WORK_SEASON%ROWTYPE;

    v_t                 BOOLEAN;

    C_MOD_COL_I         VARCHAR2(32000) :=      'TRN_TYPE,';
    C_ERR_CODE          VARCHAR2(32000) :=      'TRN_PLAN_HEADER';
    C_SEGMENT_CODE      VARCHAR2(32000) :=      'VW_PREP_GROUP_CODE';


    C_REC_CTL_MP        VARCHAR2(100)   :=      'REC_CTL-MP';
    C_REC_CTL_SP        VARCHAR2(100)   :=      'REC_CTL-SP';
    C_WHS_WIP           VARCHAR2(100)   :=      'WIP';

    v_error             BOOLEAN ;



    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS

        it_rout         Pkg_Mov.type_rout3;
        it_oper         Pkg_Glb.typ_string;




        ------------------------------------------------------------------------------
        PROCEDURE p_check_group_oper_org
        /*
            --

        */
        IS
        BEGIN
            -- load the routing for every workorder
            DELETE FROM VW_PREP_GROUP_CODE;
            FOR x IN Pkg_Cur.C_SQL_INLIST(p_row.group_code) LOOP
                INSERT INTO VW_PREP_GROUP_CODE
                VALUES      (x.txt01,C_SEGMENT_CODE);
            END LOOP;
            --
            FOR x IN Pkg_Mov.C_GROUP_ROUTING LOOP
                it_rout(x.group_code)(x.org_code_curr)(x.oper_code_curr)    :=  x;
            END LOOP;
            -- load the operation specifed
            OPEN    Pkg_Cur.C_SQL_INLIST(p_row.oper_code);
            FETCH   Pkg_Cur.C_SQL_INLIST    BULK COLLECT INTO it_oper;
            CLOSE   Pkg_Cur.C_SQL_INLIST;
            -- cycle for every workorder and check if it has
            -- operation for the organization specified
            FOR x IN Pkg_Cur.C_SQL_INLIST(p_row.group_code) LOOP
                -- check if workorder group exists in the sistem
                v_row_grp.group_code  :=  x.txt01;
                Pkg_Check.p_chk_work_group(v_row_grp);
                --
                IF it_rout.EXISTS(x.txt01) THEN -- if workorder group exists
                    IF NOT it_rout(x.txt01).EXISTS(p_row.suppl_code) THEN
                        -- for this work order does NOT exists operation made in this organization
                        Pkg_Err.p_set_error_message
                       (    p_err_code          => 'XX1' ,
                            p_err_header        => 'Pentru urmatoarele comenzi '
                                                 ||'nu exista operatii care se efectueaza '
                                                 ||'in organizatia '
                                                 ||NVL(p_row.suppl_code,'???')
                                                 ||' !!!',
                            p_err_detail        => x.txt01 ,
                            p_flag_immediate    => 'N'
                       );
                    ELSE
                        -- so for this workorder we have operations executed at the organization
                        -- specified
                        -- now check if all the operations specified are executed at
                        -- this organization
                        FOR i IN 1..it_oper.COUNT LOOP
                            -- check if this operation exists in the sistem defined
                            v_row_opr.oper_code :=  it_oper(i);
                            Pkg_Check.p_chk_operation(v_row_opr);
                            --
                            IF NOT  it_rout(x.txt01)(p_row.suppl_code).EXISTS(it_oper(i)) THEN
                                 Pkg_Err.p_set_error_message
                                (    p_err_code          => 'XX2' ,
                                     p_err_header        => 'Pentru urmatoarele comenzi '
                                                          ||'urmatoarele operatii nu se efectueaza '
                                                          ||'in organizatia '
                                                          ||p_row.suppl_code
                                                          ||' !!!',
                                     p_err_detail        => x.txt01
                                                            ||' - '
                                                            ||it_oper(i),
                                     p_flag_immediate    => 'N'
                                );
                            END IF;
                        END LOOP;
                    END IF;
                END IF;
            END LOOP;
        END;
        ------------------------------------------------------------------------------
    BEGIN
        v_row_cli.org_code  :=  SUBSTR(p_row.org_code,1,10);
        Pkg_Check.p_chk_organization_sbu(v_row_cli);
        --
        -- if flag PICK_PARAMETER = N we should not have anny parameter specified
        v_t :=  p_row.pick_parameter = 'N'
                AND ( p_row.whs_code      IS NOT NULL
                      OR
                      p_row.group_code    IS NOT NULL
                      OR
                      p_row.item_code     IS NOT NULL
                      OR
                      p_row.colour_code   IS NOT NULL
                      OR
                      p_row.size_code     IS NOT NULL
                      OR
                      p_row.suppl_code    IS NOT NULL
                      OR
                      p_row.oper_code     IS NOT NULL
                      OR
                      p_row.joly_parameter IS NOT NULL
                      );
        IF v_t THEN P_Sen('150',
         'Acest plan nu poate avea parametrii de picking !!!',
          NULL
        );END IF;
        -- if there is no pick parameter specified we need no more checks
        IF p_row.pick_parameter = 'N' THEN
            GOTO SHORT_CIRCUIT;
        END IF;

        -- Busines logic depending on the type of movement
        -- for picking
        ----------------------------------------------------------------------------------
        CASE
                ----------------------------------------------------------------------------------------
                WHEN    p_row.trn_type  IN  (Pkg_Glb.C_TRN_TRN_CNS) THEN
                ----------------------------------------------------------------------------------------
                   -- when transfer material to wip

                   -- the organization where production is made
                    p_row.suppl_code    :=  Pkg_Glb.C_MYSELF;
                    --
                    v_t :=      p_row.suppl_code    IS  NULL
                            OR  p_row.season_code   IS  NULL
                            OR (
                                    p_row.item_code IS  NULL
                                AND p_row.group_code IS NULL
                                );
                    IF v_t THEN P_Sen('X100',
                     'Pentru tipul de miscare '||p_row.trn_type||' trebuie sa precizati obligatoriu : '
                      ||Pkg_Glb.C_NL
                      ||' 1_ stagiunea '
                      ||Pkg_Glb.C_NL
                      ||' 2_ articol sau comanda '
                      ||'!!!',
                      NULL
                    );END IF;
                    --
                    IF v_t THEN
                          GOTO SHORT_CIRCUIT;
                    END IF;
                    --
                    v_row_sup.org_code  :=  SUBSTR(p_row.suppl_code,1,10);
                    Pkg_Check.p_chk_organization(v_row_sup);
                    --
                    v_row_sea.org_code      :=  p_row.org_code;
                    v_row_sea.season_code   :=  SUBSTR(p_row.season_code,1,20);
                    Pkg_Check.p_chk_work_season(v_row_sea);
                    --
                    -- it the organization is specified it has to be myself
                    v_t := v_row_sup.flag_myself  =   'N';
                    IF v_t THEN P_Sen('X200',
                     'Pentru tipul de miscare '||p_row.trn_type||' organizatia precizata trebuie '||Pkg_Glb.C_MYSELF||' !!!',
                      NULL
                    );END IF;
                    -- chek if work group has operation in location specified
                    p_check_group_oper_org;
            ------------------------------------------------------------------------------------------
                WHEN    p_row.trn_type  IN  (Pkg_Glb.C_TRN_SHP_CTL ) THEN
            ------------------------------------------------------------------------------------------
                    -- this is to transfer items in aoutside processing
                    GOTO SHORT_CIRCUIT;

                    v_t :=      p_row.whs_code      IS NULL
                            OR  p_row.suppl_code    IS NULL
                            OR  p_row.season_code   IS NULL
                            ;
                    IF v_t THEN P_Sen('X100',
                     'Pentru tipul de miscare '||p_row.trn_type||' trebuie sa precizati obligatoriu : '
                      ||Pkg_Glb.C_NL
                      ||' 1_ magazia din care se preda '
                      ||Pkg_Glb.C_NL
                      ||' 2_ tertul unde se expedieaza '
                      ||Pkg_Glb.C_NL
                      ||' 3_ stagiunea '
                      ||'!!!',
                      NULL
                    );END IF;
                    --
                    IF v_t THEN
                          GOTO SHORT_CIRCUIT;
                    END IF;
                    --
                    v_row_whs.whs_code      :=  SUBSTR(p_row.whs_code,1,10);
                    Pkg_Check.p_chk_warehouse(v_row_whs);
                    --
                    v_t :=  v_row_whs.category_code NOT IN (    Pkg_Glb.C_WHS_MPC,
                                                                Pkg_Glb.C_WHS_MPP,
                                                                Pkg_Glb.C_WHS_WIP );
                    IF v_t THEN P_Sen('X200',
                     'Pentru tipul de miscare '||p_row.trn_type||' magazia din care se expedieaza '
                     ||'trebuie sa fie de categoria MPC/MPP/WIP '
                     ||'materie prima lohn, materie prima proprietate '
                     ||'sau sectie !!!',
                      NULL
                    );END IF;
                    --
                    v_row_sup.org_code        :=  SUBSTR(p_row.suppl_code,1,10);
                    Pkg_Check.p_chk_organization(v_row_sup,v_row_sup.org_code);
                    v_t :=  v_row_sup.flag_lohn  =   'N';
                    IF v_t THEN P_Sen('X300',
                     'Pentru tipul de miscare '||p_row.trn_type||' organizatia precizata trebuie '
                     ||'sa aiba calitatea de tert !!!',
                      NULL
                    );END IF;
                    --
                    v_row_sea.org_code      :=  p_row.org_code;
                    v_row_sea.season_code   :=  SUBSTR(p_row.season_code,1,20);
                    Pkg_Check.p_chk_work_season(v_row_sea);
                    --

            ------------------------------------------------------------------------------------------
                 WHEN    p_row.trn_type  IN  (Pkg_Glb.C_TRN_REC_CTL ) THEN
            ------------------------------------------------------------------------------------------
                    v_t :=      p_row.whs_code          IS NULL
                            OR  p_row.season_code       IS NULL
                            OR  p_row.joly_parameter    IS NULL
                            ;
                    IF v_t THEN P_Sen('X100',
                     'Pentru tipul de miscare '||p_row.trn_type||' trebuie sa precizati obligatoriu : '
                      ||Pkg_Glb.C_NL
                      ||' 1_ magazia asociata tertului '
                      ||Pkg_Glb.C_NL
                      ||' 2_ stagiunea '
                      ||Pkg_Glb.C_NL
                      ||' 3_ parametru suplimentar pentru semiprocesate / materie prima '
                      ||'!!!',
                      NULL
                    );END IF;
                    --
                    IF v_t THEN
                          GOTO SHORT_CIRCUIT;
                    END IF;
                    --
                    v_row_whs.whs_code      :=  SUBSTR(p_row.whs_code,1,10);
                    Pkg_Check.p_chk_warehouse(v_row_whs);
                    --
                    v_t :=  v_row_whs.category_code NOT IN (Pkg_Glb.C_WHS_CTL );
                    IF v_t THEN P_Sen('X200',
                     'Pentru tipul de miscare '||p_row.trn_type||' magazia precizata trebuie sa fie '
                     ||'de tip prelucrare la terti - '||Pkg_Glb.C_WHS_CTL||' !!!',
                      NULL
                    );END IF;
                    --
                    p_row.suppl_code    :=  v_row_whs.org_code;
                    --
                    v_row_sea.org_code      :=  p_row.org_code;
                    v_row_sea.season_code   :=  SUBSTR(p_row.season_code,1,20);
                    Pkg_Check.p_chk_work_season(v_row_sea);
                    --
                    v_t :=  p_row.joly_parameter NOT IN (C_REC_CTL_MP,C_REC_CTL_SP);
                    IF v_t THEN P_Sen('X300',
                     'Pentru tipul de miscare '||p_row.trn_type||' parametrul suplimentar '
                     ||'trebuie sa fie '||C_REC_CTL_MP||' sau '||C_REC_CTL_SP||' !!!',
                      NULL
                    );END IF;
                    -- chek if work group has operation in location specified
                    p_check_group_oper_org;

            ------------------------------------------------------------------------------------------
                 WHEN    p_row.trn_type  IN  (Pkg_Glb.C_TRN_TRN_RET ) THEN
            ------------------------------------------------------------------------------------------
                  -- this is returning of raw material from WIP
                    v_t :=  p_row.season_code       IS NULL ;
                    IF v_t THEN P_Sen('X100',
                     'Pentru tipul de miscare '||p_row.trn_type||' trebuie sa precizati obligatoriu : '
                      ||Pkg_Glb.C_NL
                      ||' 1_ stagiunea '
                      ||'!!!',
                      NULL
                    );END IF;
                    --
                    IF v_t THEN
                          GOTO SHORT_CIRCUIT;
                    END IF;
                    --
                    p_row.whs_code  :=    C_WHS_WIP;
                    --
                    v_row_sea.org_code      :=  p_row.org_code;
                    v_row_sea.season_code   :=  SUBSTR(p_row.season_code,1,20);
                    Pkg_Check.p_chk_work_season(v_row_sea);
            ------------------------------------------------------------------------------------------
                 WHEN    p_row.trn_type  IN  (Pkg_Glb.C_TRN_TRN_SEA ) THEN
            ------------------------------------------------------------------------------------------
                  -- this is to change season code
                    v_t :=      p_row.whs_code          IS NULL
                            OR  p_row.season_code       IS NULL
                            ;
                    IF v_t THEN P_Sen('X100',
                     'Pentru tipul de miscare '||p_row.trn_type||' trebuie sa precizati obligatoriu : '
                      ||Pkg_Glb.C_NL
                      ||' 1_ magazia in care se gasesc articolele '
                      ||Pkg_Glb.C_NL
                      ||' 2_ stagiunea de pe care vreti sa schimbati '
                      ||'!!!',
                      NULL
                    );END IF;
                    --
                    IF v_t THEN
                          GOTO SHORT_CIRCUIT;
                    END IF;
                    --
                    v_row_whs.whs_code      :=  SUBSTR(p_row.whs_code,1,10);
                    Pkg_Check.p_chk_warehouse(v_row_whs);
                    --
                    v_row_sea.org_code      :=  p_row.org_code;
                    v_row_sea.season_code   :=  SUBSTR(p_row.season_code,1,20);
                    Pkg_Check.p_chk_work_season(v_row_sea);
            ------------------------------------------------------------------------------------------
                 WHEN    p_row.trn_type  IN  (Pkg_Glb.C_TRN_REM_ORD ) THEN
            ------------------------------------------------------------------------------------------
                    v_t :=      p_row.whs_code          IS NULL
                            OR  p_row.season_code       IS NULL
                            ;
                    IF v_t THEN P_Sen('X100',
                     'Pentru tipul de miscare '||p_row.trn_type||' trebuie sa precizati obligatoriu : '
                      ||Pkg_Glb.C_NL
                      ||' 1_ magazia in care vreti sa dezalocati '
                      ||Pkg_Glb.C_NL
                      ||' 2_ stagiunea '
                      ||'!!!',
                      NULL
                    );END IF;
                    --
                    IF v_t THEN
                          GOTO SHORT_CIRCUIT;
                    END IF;
                    --
                    v_row_whs.whs_code      :=  SUBSTR(p_row.whs_code,1,10);
                    Pkg_Check.p_chk_warehouse(v_row_whs);
                    --
                    v_t :=  v_row_whs.category_code NOT IN  (
                                                        Pkg_Glb.C_WHS_WIP,
                                                        Pkg_Glb.C_WHS_CTL,
                                                        Pkg_Glb.C_WHS_MPC,
                                                        Pkg_Glb.C_WHS_MPP
                                                        );
                    IF v_t THEN P_Sen('X200',
                     'Pentru tipul de miscare '||p_row.trn_type||' magazia din care se poate dezaloca '
                     ||'trebuie sa fie de categoria WIP,CTL sau de stoc materie prima !!!',
                      NULL
                    );END IF;
                    --
                    v_row_sea.org_code      :=  p_row.org_code;
                    v_row_sea.season_code   :=  SUBSTR(p_row.season_code,1,20);
                    Pkg_Check.p_chk_work_season(v_row_sea);
                ----------------------------------------------------------------------------------------
                WHEN    p_row.trn_type  IN  (Pkg_Glb.C_TRN_ALC_ORD) THEN
                ----------------------------------------------------------------------------------------
                   -- alocating to work group
                    v_t :=      p_row.whs_code          IS NULL
                            OR  p_row.season_code       IS NULL
                            ;
                    IF v_t THEN P_Sen('X100',
                     'Pentru tipul de miscare '||p_row.trn_type||' trebuie sa precizati obligatoriu : '
                      ||Pkg_Glb.C_NL
                      ||' 1_ magazia in care vreti sa alocati '
                      ||Pkg_Glb.C_NL
                      ||' 3_ stagiunea '
                      ||'!!!',
                      NULL
                    );END IF;
                    --
                    IF v_t THEN
                          GOTO SHORT_CIRCUIT;
                    END IF;
                    --
                    v_row_whs.whs_code      :=  SUBSTR(p_row.whs_code,1,10);
                    Pkg_Check.p_chk_warehouse(v_row_whs);
                    --
                    v_t :=  v_row_whs.category_code NOT IN (Pkg_Glb.C_WHS_WIP,Pkg_Glb.C_WHS_CTL );
                    IF v_t THEN P_Sen('X200',
                     'Pentru tipul de miscare '||p_row.trn_type||' magazia precizata trebuie sa fie '
                     ||'de tip sectie local sau prelucrare la terti  !!!',
                      NULL
                    );END IF;
                    --
                    p_row.suppl_code    :=  v_row_whs.org_code;
                    --
                    v_row_sea.org_code      :=  p_row.org_code;
                    v_row_sea.season_code   :=  SUBSTR(p_row.season_code,1,20);
                    Pkg_Check.p_chk_work_season(v_row_sea);
                ELSE
                ------------------------------------------------------------------------------------


                -------------------------------------------------------------------------------------
                    NULL;
        END CASE;


        <<SHORT_CIRCUIT>>
        NULL;

    END;
    ---------------------------------------------------------------------------
BEGIN
    --
    v_row_old.idriga    :=  p_row.idriga;
    IF Pkg_Get.f_get_trn_plan_header(v_row_old) THEN NULL; END IF;
    --
    CASE    p_tip
        WHEN    'I' THEN
                --
                p_row.plan_date         :=  TRUNC(SYSDATE);
                p_row.plan_code         :=  Pkg_Env.f_get_app_doc_number
                                             (
                                                 p_org_code     =>   Pkg_Glb.C_MYSELF   ,
                                                 p_doc_type     =>   C_DOC_TYPE         ,
                                                 p_doc_subtype  =>   C_DOC_TYPE         ,
                                                 p_num_year     =>   TO_CHAR(p_row.plan_date,'YYYY')
                                             );
                p_row.status        :=  'I';
                --
                p_check_integrity();
                --
        WHEN    'U' THEN
                v_error     :=  FALSE;
                --
                v_mod_col   :=  Pkg_Mod_Col.f_trn_plan_header(v_row_old, p_row);
                -- check if there is detail lines on the plan
                -- if there are some information not modifyable
                FOR x IN Pkg_Mov.C_TRN_PLAN_DETAIL(p_row.idriga) LOOP
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
                                     p_err_header        => 'Planul are detaliu, '
                                                            ||'nu mai puteti modifica '
                                                            ||'UNELE informatii (tip_miscare) '
                                                            ||'din antet !!!',
                                     p_err_detail        => NULL,
                                     p_flag_immediate    => 'N'
                                );
                                ---
                                v_error :=  TRUE;
                                ---
                            END IF;
                            ----------
                         WHEN   v_row_old.status    IN  ('F','X') THEN
                               Pkg_Err.p_set_error_message
                               (    p_err_code          => C_ERR_CODE ,
                                    p_err_header        => 'Planul a fost executat / anulat, '
                                                           ||'nu mai puteti modifica informatiile de antet !!!',
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
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 16/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_trn_plan_detail_iud(p_tip VARCHAR2, p_row TRN_PLAN_DETAIL%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               TRN_PLAN_DETAIL%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Mov.p_trn_plan_detail_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_trn_plan_detail_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL:    16/03/2008  z   Create procedure
            02/12/2008  d   for TRN_CNS must let the group_code to be null, even if the work_order is not
            15/11/2009  d   TRN_CNS must let the seasons to be different (In <-> OUT) 
/*********************************************************************************/
PROCEDURE p_trn_plan_detail_blo(    p_tip           VARCHAR2,
                                    p_row           IN OUT TRN_PLAN_DETAIL%ROWTYPE,
                                    p_check_only    IN VARCHAR2 DEFAULT  'N'
                                )
/*----------------------------------------------------------------------------------
--  PURPOSE:
            -- pkg_glb.C_TRN_TRN_CNS  transfer to WIP/CONSUMPTION
                    * source warehouse must exists
                    * source warehouse must be of category Pkg_Glb.C_WHS_MPC,Pkg_Glb.C_WHS_MPP,Pkg_Glb.C_WHS_PAT
                    * if source warehouse is category Pkg_Glb.C_WHS_PAT there should be
                      NO destination warehouse, this is direct consumption
                    * if source warehouse is NOT category Pkg_Glb.C_WHS_PAT the destination warehouse
                      should exists and should be of type Pkg_Glb.C_WHS_WIP
                    * if workorders are indicated for both warehouse they have to be the same
                      workorder
                    * if destination warehuse is specified (and this implies that is category WIP)
                      the destination workorder must be specified

            -- PKG_GLB.C_TRN_TRN_RET return from WIP to stock warehouse
                    * if warehouse destination is of type Pkg_Glb.C_WHS_MPC,Pkg_Glb.C_WHS_MPP
                      the source warehouse should exists and be of type Pkg_Glb.C_WHS_WIP
                    * if the destination warehouse is of type Pkg_Glb.C_WHS_PAT the source
                      warehouse should be absent

            -- Pkg_Glb.C_TRN_ALC_ORD allocation ro work order
                    * the source warehouse and destination warehouse must exists
                      and has to be the same and
                    * has to be of category Pkg_Glb.C_WHS_MPC,Pkg_Glb.C_WHS_MPP
                    * destination workorder must exists and the source workorder must be null

            -- Pkg_Glb.C_TRN_REM_ORD remove allocation from work order
                    * the source warehouse and destination warehouse must exists
                      and has to be the same and
                    * has to be of category Pkg_Glb.C_WHS_MPC,Pkg_Glb.C_WHS_MPP
                    * destination workorder must be null exists and the source workorder
                      must exists


            -- Pkg_Glb.C_TRN_INV_STC inventory corrections
                    * either the source warehouse or destination warehouse should be
                      present


           -- PKG_GLB.C_TRN_INI_STC   stock initialization
                * the source warehouse must be null
                * the destination warehouse must not be null
                * the workorders (source/ destination should be null)







--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    v_row_hed       TRN_PLAN_HEADER%ROWTYPE;
    v_row_old       TRN_PLAN_DETAIL%ROWTYPE;

    v_row_itm       ITEM%ROWTYPE;
    v_row_col       COLOUR%ROWTYPE;
    v_row_siz       ITEM_SIZE%ROWTYPE;
    v_row_ope       OPERATION%ROWTYPE;
    v_row_seo       WORK_SEASON%ROWTYPE;
    v_row_sei       WORK_SEASON%ROWTYPE;
    v_row_who       WAREHOUSE%ROWTYPE;
    v_row_whi       WAREHOUSE%ROWTYPE;
    v_row_mot       MOVEMENT_TYPE%ROWTYPE;
    v_row_wco       WAREHOUSE_CATEG%ROWTYPE;
    v_row_wci       WAREHOUSE_CATEG%ROWTYPE;


    v_row_wct       WAREHOUSE_CATEG%ROWTYPE;
    v_row_ord       WORK_ORDER%ROWTYPE;
    v_row_pum       PRIMARY_UOM%ROWTYPE;
    v_row_wgo       WORK_GROUP%ROWTYPE;
    v_row_wgi       WORK_GROUP%ROWTYPE;

    v_mod_col       VARCHAR2(32000);
    v_error         BOOLEAN;
    C_ERR_CODE      VARCHAR2(32000) :=  'TRN_PLAN_DETAIL';
    C_PRECISION     NUMBER          :=  3;
    v_t             BOOLEAN;

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN


        v_row_itm.org_code      :=  p_row.org_code;
        v_row_itm.item_code     :=  p_row.item_code;
        Pkg_Check.p_chk_item(v_row_itm);
        --
        p_row.uom               :=  NVL(p_row.uom,v_row_itm.puom);
        v_row_pum.puom          :=  p_row.uom;
        Pkg_Check.p_chk_primary_uom(v_row_pum,p_row.item_code);
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
        IF p_row.whs_code_out IS NOT NULL THEN
            v_row_who.whs_code  :=  p_row.whs_code_out;
            Pkg_Check.p_chk_warehouse(v_row_who,p_row.item_code);
        END IF;
        IF p_row.whs_code_in IS NOT NULL THEN
            v_row_whi.whs_code  :=  p_row.whs_code_in;
            Pkg_Check.p_chk_warehouse(v_row_whi,p_row.item_code);
        END IF;
        --
        IF p_row.season_code_out IS NOT NULL THEN
            v_row_seo.org_code      :=  p_row.org_code;
            v_row_seo.season_code   :=  p_row.season_code_out;
            Pkg_Check.p_chk_work_season(v_row_seo,p_row.item_code);
        END IF;
        --
        IF p_row.season_code_in IS NOT NULL THEN
            v_row_sei.org_code      :=  p_row.org_code;
            v_row_sei.season_code   :=  p_row.season_code_in;
            Pkg_Check.p_chk_work_season(v_row_sei,p_row.item_code);
        END IF;
        --
        IF p_row.order_code IS NOT NULL THEN
            v_row_ord.org_code          :=  p_row.org_code;
            v_row_ord.order_code        :=  p_row.order_code;
            Pkg_Check.p_chk_work_order(v_row_ord,p_row.item_code);
        END IF;
        --
        IF p_row.group_code_out IS NOT NULL THEN
            v_row_wgo.group_code    :=  p_row.group_code_out;
            Pkg_Check.p_chk_work_group(v_row_wgo,p_row.item_code);
        END IF;
        --
        IF p_row.group_code_in IS NOT NULL THEN
            v_row_wgi.group_code    :=  p_row.group_code_in;
            Pkg_Check.p_chk_work_group(v_row_wgi,p_row.item_code);
        END IF;

        -- bussines logic
        -- check the colour and size
        Pkg_Item.p_check_colour_size(
                p_org_code       =>     p_row.org_code,
                p_item_code      =>     p_row.item_code,
                p_flag_colour    =>     v_row_itm.flag_colour ,
                p_colour_code    =>     p_row.colour_code,
                p_flag_size      =>     v_row_itm.flag_size,
                p_size_code      =>     p_row.size_code
                );

        -- the oper_code_item should go only with make_by = P - production item
        v_t :=  v_row_itm.make_buy = 'A' AND v_row_ope.oper_code IS NOT NULL;
        IF v_t THEN P_Sen('070',
         'Nu nu puteti preciza faza numai pentru articole care sunt de productie !!!',
          v_row_itm.item_code
        );
        END IF;
        --
        v_t :=  v_row_itm.make_buy = 'P' AND v_row_ope.oper_code IS NULL;
        IF v_t THEN P_Sen('075',
         'Pentru articole care sunt de productie trebuie sa precizati faza !!!',
          v_row_itm.item_code
        );
        END IF;
        --if the warehouse exists then the season shoul exists too
        v_t := v_row_who.whs_code IS NOT NULL AND v_row_seo.season_code IS NULL;
        IF v_t THEN P_Sen('080',
         'Nu ati precizati stagiunea sursa !!!',
          v_row_itm.item_code
        );
        END IF;
        --
        v_t := v_row_whi.whs_code IS NOT NULL AND v_row_sei.season_code IS NULL;
        IF v_t THEN P_Sen('090',
         'Nu ati precizati stagiunea destinatie !!!',
          v_row_itm.item_code
        );
        END IF;
        -- should be the same season apart from the type of movement
        -- PKG_GLB.C_TRN_TRN_SEA
        v_t :=  v_row_hed.trn_type NOT IN (Pkg_Glb.C_TRN_TRN_SEA )
                AND v_row_seo.season_code   IS NOT NULL
                AND v_row_sei.season_code   IS NOT NULL
                AND v_row_seo.season_code <> v_row_sei.season_code;
        /* 15/11/2009 - commented by Daniel 
        IF v_t THEN P_Sen('095',
         'Pentru tipul de miscare '||v_row_hed.trn_type ||' stagiunea sursa trebuie sa fie identica cu '
         ||' stagiunea destinatie !!!',
          v_row_itm.item_code
        );
        END IF;
        */
        ---
        v_t :=  v_row_hed.trn_type NOT IN (Pkg_Glb.C_TRN_TRN_SEA )
                AND v_row_seo.season_code   IS NOT NULL
                AND v_row_sei.season_code   IS NOT NULL
                AND (
                        v_row_seo.season_code <> NVL(v_row_wgi.season_code, v_row_seo.season_code)
                    OR  v_row_seo.season_code <> NVL(v_row_wgo.season_code, v_row_seo.season_code)
                    OR  v_row_seo.season_code <> NVL(v_row_ord.season_code, v_row_seo.season_code)
                    )
                ;
        /* 15/11/2009 - commented by Daniel 
        IF v_t THEN P_Sen('095',
         'Pentru tipul de miscare '||v_row_hed.trn_type||' comenzile / bola trebuie sa aiba stagiunea identica '
         ||'cu stagiunea sursa si destinatie !!!',
          v_row_itm.item_code
        );
        END IF;
        */
         --
        -- quantity has to be positiv and maximum x decimals
        p_row.qty   :=  NVL(p_row.qty,0);
        --
        v_t :=      p_row.qty <= 0
                OR  p_row.qty - TRUNC(p_row.qty,C_PRECISION) > 0;
        IF v_t THEN P_Sen('100',
         'Cantitatea trebuie sa fie pozitiva si sa aiba precizie maxim '||C_PRECISION ||' zecimale !!!',
          v_row_itm.item_code
        );
        END IF;
        -- check the unit of measure problem
        v_t :=  p_row.uom NOT IN (v_row_itm.puom, NVL(v_row_itm.suom,v_row_itm.puom));
        IF v_t THEN P_Sen('110',
         'Unitatea de masura trebuie sa fie cea primara sau secundara pentru acest cod !!!',
          v_row_itm.item_code
        );
        END IF;
        -- transform in primary unit of measure
        IF p_check_only = 'N' THEN
            --
            p_row.puom  := v_row_itm.puom;
            --
            IF p_row.uom <> p_row.puom THEN
                --
                p_row.qty_puom      :=  p_row.qty * v_row_itm.uom_conv;
                p_row.qty_puom      :=  ROUND(p_row.qty_puom ,C_PRECISION);
            ELSE
                p_row.qty_puom      :=  p_row.qty ;
            END IF;
        END IF;



        -- Specific Business Logic Depending Of Trn_Type
        CASE
           /*------------------------------------------------------------------------------
           -- in the case of transfer to WIP
           ------------------------------------------------------------------------------*/
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_TRN_CNS ) THEN
                --
                v_t :=      v_row_who.whs_code IS NULL
                        OR  v_row_who.category_code NOT IN (    Pkg_Glb.C_WHS_MPC,
                                                                Pkg_Glb.C_WHS_MPP,
                                                                Pkg_Glb.C_WHS_PAT );
                IF v_t THEN P_Sen('120',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' magazia sursa trebuie sa existe '
                ||' si trebuie sa fie de tip stoc !!!',
                v_row_itm.item_code
                ); END IF;
                --
/*                v_t :=      v_row_who.category_code IN (Pkg_Glb.C_WHS_PAT)
                        AND v_row_whi.whs_code  IS NOT NULL;
*/
                v_t :=      v_row_itm.type_code =   'CO'
                        AND v_row_whi.whs_code  IS NOT NULL;
                IF v_t THEN P_Sen('140',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca se elibereaza consumabile,'
                ||' magazia destinatie trebuie lasat libera !!!',
                v_row_itm.item_code
                );END IF;
                ---
                v_t :=  v_row_who.category_code NOT IN (Pkg_Glb.C_WHS_PAT)
                        AND v_row_itm.type_code <> 'CO'
                        AND (       v_row_whi.whs_code  IS NULL
                                OR  v_row_whi.category_code NOT IN (Pkg_Glb.C_WHS_WIP )
                            );
                IF v_t THEN P_Sen('150',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca se dau in consum materii prime '
                ||'magazia destinatie trebuie sa fie precizata si trebuie sa fie de tip sectie (WIP) !!!',
                v_row_itm.item_code
                );END IF;
                --- if there are workorders indicated for both the warehouses they have to be the
                -- same
                v_t :=      p_row.group_code_out    IS NOT NULL
                        AND Pkg_Lib.f_mod_c(p_row.group_code_out,p_row.group_code_in);
                IF v_t THEN P_Sen('160',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' stocul alocat pe o comanda poate '
                ||'fi transferat in sectie (WIP) numai pe aceeasi comanda !!!',
                v_row_itm.item_code
                );END IF;
                --
                -- if transfer is on client order we must have the item code equal to that of
                -- the orde item code
                v_t :=      v_row_ord.order_code IS NOT NULL
                        AND
                           ( v_row_itm.item_code  <> v_row_ord.item_code
                             OR
                             --v_row_wgo.group_code IS NULL
                             --OR
                             Pkg_Lib.f_mod_c(v_row_wgi.group_code,v_row_wgo.group_code)
                             OR
                             (
                                Pkg_Order.f_chk_order_in_group(v_row_ord.org_code,
                                                            v_row_ord.order_code,
                                                            v_row_wgo.group_code) = 'N'
                                AND
                                v_row_wgo.group_code IS NOT NULL
                             )
                            );
                IF v_t THEN P_Sen('999',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca ati precizat bola client inseamna '
                ||'ca vreti sa transferati semiprocesate deci : ' || Pkg_Glb.C_NL
                ||' - produsul corespunzator acestei bole '||v_row_ord.item_code||' trebuie sa fie identica cu codul articolului;'|| Pkg_Glb.C_NL
                ||' - comanda sursa si comanda destinatie trebuie sa existe si sa fie identice ;'||Pkg_Glb.C_NL
                ||' - bola trebuie sa fie asociata cu aceste comenzi ',
                v_row_itm.item_code
                );END IF;



           ------------------------------------------------------------------------------
             -- Pkg_Glb.C_TRN_ALC_ORD allocation to work order
          ------------------------------------------------------------------------------
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_ALC_ORD ) THEN
                --
                -- the source warehouse and destination warehouse must exists and
                -- has to be the same
                v_t :=  v_row_who.whs_code  IS NULL
                    OR  v_row_whi.whs_code  IS NULL
                    OR  Pkg_Lib.f_mod_c(v_row_who.whs_code,v_row_whi.whs_code);
                IF v_t THEN P_Sen('170',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' trebuie sa precizati aceeasi magazia '
                ||'sursa si destinatie !!!',
                v_row_itm.item_code
                );END IF;
                -- has to be of type MPC, MPP,WIP,CTL
                v_t :=   v_row_who.category_code NOT IN (
                                                       --     Pkg_Glb.C_WHS_MPC,
                                                       --     Pkg_Glb.C_WHS_MPP,
                                                            Pkg_Glb.C_WHS_WIP,
                                                            Pkg_Glb.C_WHS_CTL
                                                       );
                IF v_t THEN P_Sen('180',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' trebuie sa precizati magazii de tip '
                ||'sectie sau stoc la terti (CTL) !!!',
                v_row_itm.item_code
                );END IF;
                -- destination work order must exists, source workorder must be null
                v_t :=  v_row_wgo.group_code    IS NOT NULL
                    OR  v_row_wgi.group_code    IS NULL;
                IF v_t THEN P_Sen('190',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' trebuie sa lasati liber comanda sursa '
                ||'si sa precizati comanda destinatie pe care vreti sa alocati !!!',
                v_row_itm.item_code
                );END IF;
           /*------------------------------------------------------------------------------
           -- PKG_GLB.C_TRN_INV_STC   inventory corrections
           ------------------------------------------------------------------------------*/
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_INV_STC ) THEN
                v_t :=  (v_row_who.whs_code IS NOT NULL AND v_row_whi.whs_code IS NOT NULL)
                        OR
                        (v_row_who.whs_code IS  NULL AND v_row_whi.whs_code IS NULL );
                IF v_t THEN P_Sen('200',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' trebuie sa precizati or magazia '
                ||'sursa ori magazia destinatie dar NU ambele de o data !!!',
                v_row_itm.item_code
                );END IF;
           /*------------------------------------------------------------------------------
            -- PKG_GLB.C_TRN_TRN_RET return from WIP to stock warehouse
           ------------------------------------------------------------------------------*/
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_TRN_RET ) THEN
                --
                v_t :=  v_row_whi.whs_code   IS NULL
                    OR  v_row_whi.category_code NOT IN (Pkg_Glb.C_WHS_MPC,
                                                        Pkg_Glb.C_WHS_MPP,
                                                        Pkg_Glb.C_WHS_PAT
                                                        );
                IF v_t THEN P_Sen('250',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' trebuie sa precizati magazia '
                ||'destinatie si acesta trebuie sa fie de categorie stoc !!!',
                v_row_itm.item_code
                );END IF;
                ---
                v_t :=      v_row_whi.category_code      IN (
                                                                Pkg_Glb.C_WHS_MPC,
                                                                Pkg_Glb.C_WHS_MPP
                                                            )
                        AND (       v_row_who.whs_code      IS NULL
                                OR  v_row_who.category_code NOT IN (Pkg_Glb.C_WHS_WIP)
                            );
                IF v_t THEN P_Sen('260',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca magazia de destinatie este '
                ||'magazie de stoc materie prima atunci trebuie sa precizati si magazia de sursa '
                ||'si aceasta trebuie sa fie de tip sectie (WIP) !!!',
                v_row_itm.item_code
                );END IF;
                --
                v_t :=      v_row_whi.category_code IN (Pkg_Glb.C_WHS_PAT)
                        AND v_row_who.whs_code   IS NOT NULL;
                IF v_t THEN P_Sen('270',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca magazia de destinatie este '
                ||'magazie de stoc patrimoniu care NU este de materie prima atunci NU trebuie sa '
                ||'precizati magazie sursa !!!',
                v_row_itm.item_code
                );END IF;
                ---
                v_t :=      v_row_wgi.group_code IS NOT NULL
                        AND v_row_ord.order_code IS NULL;
                IF v_t THEN P_Sen('280',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' nu se poate face retur pentru materii '
                ||'prime pe comanda !!! ',
                v_row_itm.item_code
                );END IF;
           /*------------------------------------------------------------------------------
           -- PKG_GLB.C_TRN_INI_STC   stock initialization
           ------------------------------------------------------------------------------*/
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_INT_STC ) THEN
                --
                v_t :=      v_row_who.whs_code   IS NOT NULL
                        OR  v_row_whi.whs_code   IS NULL;
                IF v_t THEN P_Sen('300',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' magazia sursa trebuia sa fie libera '
                ||'iar magazia destinatie trebuie sa fie completata !!! ',
                v_row_itm.item_code
                );END IF;
                --
                v_t :=      v_row_wgo.group_code   IS NOT NULL
                        OR  v_row_wgi.group_code   IS NOT NULL;
                IF v_t THEN P_Sen('310',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' campurile Comanda_sursa/Comanda_destin '
                ||'trebuie lasate libere !!! ',
                v_row_itm.item_code
                );END IF;
           ------------------------------------------------------------------------------
             -- Pkg_Glb.C_TRN_REM_ORD allocation ro work order
          ------------------------------------------------------------------------------
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_REM_ORD ) THEN
                -- the source warehouse and destination warehouse must exists and
                -- has to be the same and has to be of type MPC, MPP
                v_t :=      v_row_who.whs_code  IS NULL
                        OR  v_row_whi.whs_code  IS NULL
                        OR  Pkg_Lib.f_mod_c(v_row_who.whs_code,v_row_whi.whs_code);
                IF v_t THEN P_Sen('400',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' trebuie sa precizati aceeasi magazia '
                ||'sursa si destinatie !!! ',
                v_row_itm.item_code
                );END IF;
                --
                v_t :=  v_row_who.category_code NOT IN (
                                                     --       Pkg_Glb.C_WHS_MPC,
                                                     --       Pkg_Glb.C_WHS_MPP,
                                                            Pkg_Glb.C_WHS_CTL,
                                                            Pkg_Glb.C_WHS_WIP
                                                       );
                IF v_t THEN P_Sen('410',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' trebuie sa precizati magazii de tip '
                ||'stoc la terti sau sectie !!! ',
                v_row_itm.item_code
                );END IF;
                -- destination must be null, source workorder must exists
                v_t :=      v_row_wgo.group_code    IS NULL
                        OR  v_row_wgi.group_code    IS NOT NULL;
                IF v_t THEN P_Sen('410',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' trebuie sa lasati liber comanda destinatie '
                ||'si sa precizati comanda sursa de pe care vreti sa dezalocati !!! ',
                v_row_itm.item_code
                );END IF;
           ------------------------------------------------------------------------------
             -- Pkg_Glb.C_TRN_SHP_CTL send to outside processing
          ------------------------------------------------------------------------------
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_SHP_CTL ) THEN
                --
                v_t :=      v_row_who.whs_code  IS NULL
                        OR  v_row_whi.whs_code  IS NULL
                        OR  v_row_who.category_code NOT IN (
                                                    Pkg_Glb.C_WHS_MPC,
                                                    Pkg_Glb.C_WHS_MPP,
                                                    Pkg_Glb.C_WHS_WIP
                                                  )
                        OR  v_row_whi.category_code NOT IN (
                                                    Pkg_Glb.C_WHS_CTL
                                                  );
                IF v_t THEN P_Sen('500',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' magazia sursa trebuie sa existe '
                ||'si sa fie de tip stoc iar magazia destinatie trebuie sa existe si sa fie de tip '
                ||'conto lavoro (CTL) !!! ',
                v_row_itm.item_code
                );END IF;
                -- if sending semiprocessed items they have to go out from WIP
                v_t :=      v_row_ord.order_code IS NOT NULL
                        AND v_row_who.category_code <> Pkg_Glb.C_WHS_WIP;
                IF v_t THEN P_Sen('510',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca expediati semiprocesate '
                ||'magazia sursa trebuie sa fie de categoria sectie (WIP) !!! ',
                v_row_itm.item_code
                );END IF;
                --
                -- I assume when they introduce an oper_code_item they want to transfer
                -- semiprocessed item that was previously processed in Filty
                -- If there are semiprocessed items that was received from the client
                -- we have to see how to manage it
                v_t :=      v_row_ope.oper_code IS NOT NULL
                        AND v_row_ord.order_code IS NULL   ;
                IF v_t THEN P_Sen('610',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca transferati produse finite pe faza trebuie '
                ||'sa precizati si bola client corespunzatoare !!!',
                v_row_itm.item_code
                );END IF;
                --
                -- if transfer is on client order we must have the item code equal to that of
                -- the orde item code
                v_t :=      v_row_ord.order_code IS NOT NULL
                        AND
                           ( v_row_itm.item_code  <> v_row_ord.item_code
                             OR
                             v_row_wgo.group_code IS NULL
                             OR
                             Pkg_Lib.f_mod_c(v_row_wgi.group_code,v_row_wgo.group_code)
                             OR
                             Pkg_Order.f_chk_order_in_group(v_row_ord.org_code,
                                                            v_row_ord.order_code,
                                                            v_row_wgo.group_code) = 'N'
                            );
                IF v_t THEN P_Sen('999',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca ati precizat bola client inseamna '
                ||'ca vreti sa transferati semiprocesate deci : ' || Pkg_Glb.C_NL
                ||' - produsul corespunzator acestei bole '||v_row_ord.item_code||' trebuie sa fie identica cu codul articolului;'|| Pkg_Glb.C_NL
                ||' - comanda sursa si comanda destinatie trebuie sa existe si sa fie identice ;'||Pkg_Glb.C_NL
                ||' - bola trebuie sa fie asociata cu aceste comenzi ',
                v_row_itm.item_code
                );END IF;
           ------------------------------------------------------------------------------
             -- Pkg_Glb.C_TRN_REC_CTL send to outside processing
          ------------------------------------------------------------------------------
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_REC_CTL ) THEN
                --
                v_t :=      v_row_who.whs_code  IS NULL
                        OR  v_row_whi.whs_code  IS NULL
                        OR  v_row_who.category_code NOT IN (
                                                    Pkg_Glb.C_WHS_CTL
                                                    )
                        OR  v_row_whi.category_code NOT IN (
                                                    Pkg_Glb.C_WHS_MPC,
                                                    Pkg_Glb.C_WHS_MPP,
                                                    Pkg_Glb.C_WHS_WIP,
                                                    Pkg_Glb.C_WHS_SHP
                                                  );
                IF v_t THEN P_Sen('700',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' magazia sursa trebuie precizat si '
                ||'trebuie sa fie de tip conto lavoro (CTL), magazia destinatie trebuie precizat si '
                ||'trebuie sa fie de tip stoc,expeditie sau sectie !!!',
                v_row_itm.item_code
                );END IF;
                ---
                v_t   :=        v_row_ope.oper_code     IS NOT NULL
                            AND v_row_ord.order_code    IS NULL;
                IF v_t THEN P_Sen('710',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca ati precizat faza inseamna '
                ||'ca vreti sa receptionati semiprocesate deci trebie sa precizati si bola  !!!',
                v_row_itm.item_code
                );END IF;
                --
                v_t :=      v_row_ord.order_code IS NULL
                        AND v_row_wgi.group_code IS NOT NULL;
                IF v_t THEN P_Sen('820',
                'Pentru tipul de miscare '||v_row_hed.trn_type||', receptia se va face cu dezalocare, adica comanda '
                ||'destinatie trebuie sa lasati liber  !!!',
                v_row_itm.item_code
                );END IF;
                --
                -- if transfer is on client order we must have the item code equal to that of
                -- the orde item code
                v_t :=      v_row_ord.order_code IS NOT NULL
                        AND
                           ( v_row_itm.item_code  <> v_row_ord.item_code
                             OR
                             (
                                v_row_wgo.group_code IS NOT NULL
                                AND
                                Pkg_Lib.f_mod_c(v_row_wgi.group_code,v_row_wgo.group_code)
                             )
                             OR
                             (  v_row_wgo.group_code IS NOT NULL
                                AND
                                Pkg_Order.f_chk_order_in_group(v_row_ord.org_code,
                                                            v_row_ord.order_code,
                                                            v_row_wgo.group_code) = 'N'
                              )
                             );
                IF v_t THEN P_Sen('999',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' daca ati precizat bola client inseamna '
                ||'ca vreti sa transferati semiprocesate deci : ' || Pkg_Glb.C_NL
                ||' - produsul corespunzator acestei bole '||v_row_ord.item_code||' trebuie sa fie identica cu codul articolului;'|| Pkg_Glb.C_NL
                ||' - comanda sursa si comanda destinatie trebuie sa existe si sa fie identice ;'||Pkg_Glb.C_NL
                ||' - bola trebuie sa fie asociata cu aceste comenzi ',
                v_row_itm.item_code
                );END IF;
           ------------------------------------------------------------------------------
             -- Pkg_Glb.C_TRN_TRN_SEA CHANGE SEASON
          ------------------------------------------------------------------------------
            WHEN    v_row_hed.trn_type  IN (Pkg_Glb.C_TRN_TRN_SEA ) THEN
                --
                v_t :=  v_row_seo.season_code = v_row_sei.season_code;
                IF v_t THEN P_Sen('900',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' stagiunea destinatie trebuie sa fie diferita '
                ||'de stagiunea sursa !!! ',
                v_row_itm.item_code
                );END IF;
                --
                v_t :=      v_row_wgo.group_code    IS NOT NULL
                        OR  v_row_wgi.group_code    IS NOT NULL
                        OR  v_row_ord.order_code    IS NOT NULL ;
                IF v_t THEN P_Sen('910',
                'Pentru tipul de miscare '||v_row_hed.trn_type||' nu se poate face pentru materiale alocate '
                ||'si nici pe materiale semiprocesate !!! ',
                v_row_itm.item_code
                );END IF;

            --///////////////////////////////////////////////////////////////////////////////////////
            -- others
            ELSE
                NULL;

        END CASE;

    END;
    ---------------------------------------------------------------------------
BEGIN
    -- this is to show if we have errors directly in the header
    -- so we have no NEED to go in p_check_integrity();
    v_error     :=  FALSE;
    --
    IF p_row.ref_plan IS NULL THEN
        v_error :=  TRUE;
        ---
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Nu sunteti pozitionat pe un antet valid !!!',
             p_err_detail        => NULL,
             p_flag_immediate    => 'N'
        );
    END IF;
    --
    v_row_hed.idriga    :=  p_row.ref_plan;
    IF NOT Pkg_Get.f_get_trn_plan_header(v_row_hed) THEN
        v_error :=  TRUE;
        --
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Antetul de plan cu identificatorul'
                                    ||' intern (IDRIGA) :'||v_row_hed.idriga
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => v_row_hed.idriga,
             p_flag_immediate    => 'N'
        );
    END IF;
    ---
    IF v_row_hed.status <> 'I' THEN
        v_error :=  TRUE;
        --
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Acest plan :'||v_row_hed.plan_code
                                    ||' a fost executat/anulat deja,'
                                    ||' nu mai puteti modifica !!!',
             p_err_detail        => v_row_hed.plan_code,
             p_flag_immediate    => 'N'
        );
    END IF;
    --
    IF NOT v_error THEN
        --
        CASE    p_tip
            WHEN    'I' THEN
                    --
                    p_check_integrity();
                    --
            WHEN    'U' THEN
                    --
                    p_check_integrity();
                    --
                    --
            WHEN    'D' THEN
                    NULL;
        END CASE;
    END IF;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 16/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_execute_trn_plan( p_idriga  INTEGER)
/*----------------------------------------------------------------------------------
--  PURPOSE:
--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    CURSOR  C_LINES(p_ref_plan INTEGER)   IS
        SELECT *
        FROM    TRN_PLAN_DETAIL m
        WHERE   ref_plan    =   p_ref_plan
        ORDER BY m.idriga
        ;

   CURSOR   C_REGROUP_LINES IS
        SELECT
                    org_code, item_code, colour_code, size_code,
                    oper_code_item, season_code, order_code, group_code,
                    whs_code, cost_center, puom, reason_code, wc_code,
                    SUM(qty) qty,
                    trn_sign, ref_receipt, segment_code
        FROM        VW_BLO_PREPARE_TRN
        GROUP BY    org_code, item_code, colour_code, size_code,
                    oper_code_item, season_code, order_code, group_code,
                    whs_code, cost_center, wc_code, puom, reason_code,
                    trn_sign, ref_receipt, segment_code
        ORDER BY    trn_sign ASC,item_code, colour_code, size_code,oper_code_item
        ;

    v_row_hed               TRN_PLAN_HEADER%ROWTYPE;
    v_row_tro               VW_BLO_PREPARE_TRN%ROWTYPE;
    v_row_tri               VW_BLO_PREPARE_TRN%ROWTYPE;
    v_row_trh               WHS_TRN%ROWTYPE;
    v_row_who               WAREHOUSE%ROWTYPE;
    v_row_whi               WAREHOUSE%ROWTYPE;


    it_pln                  Pkg_Rtype.ta_trn_plan_detail;
    it_det                  Pkg_Rtype.ta_vw_blo_prepare_trn ;
    z                       TRN_PLAN_DETAIL%ROWTYPE;

    C_SEGMENT_CODE          VARCHAR2(32000) :=  'VW_BLO_PREPARE_TRN';

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_idriga IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe un plan de miscare valid !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the plan header
    v_row_hed.idriga    :=  p_idriga;
    IF NOT Pkg_Get.f_get_trn_plan_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Planul de miscare cu identificatorul intern '
                                    || p_idriga ||' nu exista in sistem !!!',
              p_err_detail        => p_idriga,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- if the plan was processed already
    IF v_row_hed.status <> 'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan a fost deja executat/anulat '
                                    || '!!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- the plan can be executed if it is not shipment for outside processing or
    -- receipt from outside processing
    IF v_row_hed.trn_type IN (
                                    Pkg_Glb.C_TRN_SHP_CTL,
                                    Pkg_Glb.C_TRN_REC_CTL
                             ) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan nu se poate executa '
                                    || 'direct, este plan de receptie/expeditie '
                                    ||'de la/la terti !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- read al plan detail lines in memory
    OPEN    C_LINES(p_idriga);
    FETCH   C_LINES  BULK COLLECT INTO it_pln;
    CLOSE   C_LINES;
    -- check if there are detail lines
    IF it_pln.COUNT = 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan nu are nici o linie de '
                                    ||' detaliu !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check consistency
    -- call the same routin that checks the detail line when the line
    -- is created with the I - insert parameter
    FOR i IN 1..it_pln.COUNT LOOP
        Pkg_Mov.p_trn_plan_detail_blo(  p_tip           =>  'I',
                                        p_row           =>  it_pln(i),
                                        p_check_only    =>  'Y'
                                      );
    END LOOP;
    Pkg_Err.p_raise_error_message();
    -----
    v_row_trh.org_code      :=  v_row_hed.org_code;
    v_row_trh.trn_type      :=  v_row_hed.trn_type;
    v_row_trh.flag_storno   :=  'N';
    v_row_trh.partner_code  :=  v_row_hed.partner_code;
    v_row_trh.doc_year      :=  TO_CHAR(v_row_hed.doc_date,'YYYY');
    v_row_trh.doc_code      :=  v_row_hed.doc_code;
    v_row_trh.doc_date      :=  v_row_hed.doc_date;
    v_row_trh.date_legal    :=  v_row_hed.date_legal; --

    FOR i IN 1..it_pln.COUNT    LOOP

        z           :=  it_pln(i);

        v_row_tro.segment_code          :=  C_SEGMENT_CODE;

        v_row_tro.org_code              :=  z.org_code;
        v_row_tro.item_code             :=  z.item_code;
        v_row_tro.colour_code           :=  z.colour_code;
        v_row_tro.size_code             :=  z.size_code;
        v_row_tro.oper_code_item        :=  z.oper_code_item;
        v_row_tro.season_code           :=  z.season_code_out;
        v_row_tro.order_code            :=  z.order_code;
        v_row_tro.group_code            :=  z.group_code_out;
        v_row_tro.whs_code              :=  z.whs_code_out;
        v_row_tro.cost_center           :=  z.cost_center;
        v_row_tro.puom                  :=  z.puom;
        v_row_tro.qty                   :=  z.qty_puom;
        v_row_tro.trn_sign              :=  -1;

        v_row_tri                       :=  v_row_tro;
        v_row_tri.season_code           :=  z.season_code_in;
        v_row_tri.whs_code              :=  z.whs_code_in;
        v_row_tri.group_code            :=  z.group_code_in;

        v_row_tri.trn_sign              :=  +1;

        CASE
            -- inventory corrections
            WHEN v_row_trh.trn_type IN (Pkg_Glb.C_TRN_INV_STC  ) THEN
                ----------------------------------------------------------
                IF v_row_tro.whs_code IS NOT NULL THEN
                    v_row_who.whs_code  :=  v_row_tro.whs_code;
                    IF Pkg_Get2.f_get_warehouse_2(v_row_who) THEN NULL; END IF;
                    IF
                        (
                            v_row_who.category_code IN (
                                                    Pkg_Glb.C_WHS_MPP,
                                                    Pkg_Glb.C_WHS_PAT
                                                    )
                        OR
                            -- or the organization is myself
                            v_row_trh.org_code  =   Pkg_Glb.C_MYSELF
                        )

                    THEN
                        v_row_tro.reason_code   :=  Pkg_Glb.C_M_OINVPATR;
                    ELSE
                        v_row_tro.reason_code   :=  Pkg_Glb.C_M_OINVCUST;
                    END IF;
                    it_det(it_det.COUNT+1)          :=  v_row_tro;
                ELSE
                    v_row_whi.whs_code  :=  v_row_tri.whs_code;
                    IF Pkg_Get2.f_get_warehouse_2(v_row_whi) THEN NULL; END IF;
                    IF
                        (
                            v_row_whi.category_code IN (
                                                    Pkg_Glb.C_WHS_MPP,
                                                    Pkg_Glb.C_WHS_PAT
                                                    )
                        OR
                            -- or the organization is myself
                            v_row_trh.org_code  =   Pkg_Glb.C_MYSELF
                        )
                    THEN
                        v_row_tri.reason_code   :=  Pkg_Glb.C_P_IINVPATR;
                    ELSE
                        v_row_tri.reason_code   :=  Pkg_Glb.C_P_IINVCUST;
                    END IF;
                    it_det(it_det.COUNT+1)          :=  v_row_tri;
                END IF;
            -- stoc initialisation
            WHEN v_row_trh.trn_type IN (Pkg_Glb.C_TRN_INT_STC  ) THEN
                ----------------------------------------------------------
                    v_row_whi.whs_code  :=  v_row_tri.whs_code;
                    IF Pkg_Get2.f_get_warehouse_2(v_row_whi) THEN NULL; END IF;
                    IF
                        (
                            v_row_whi.category_code IN (
                                                    Pkg_Glb.C_WHS_MPP,
                                                    Pkg_Glb.C_WHS_PAT
                                                    )
                        OR
                            -- or the organization is myself
                            v_row_trh.org_code  =   Pkg_Glb.C_MYSELF
                        )
                    THEN
                        v_row_tri.reason_code   :=  Pkg_Glb.C_P_IINIPATR  ;
                    ELSE
                        v_row_tri.reason_code   :=  Pkg_Glb.C_P_IINICUST;
                    END IF;
                    it_det(it_det.COUNT+1)      :=  v_row_tri;




            -- change season code
            WHEN v_row_trh.trn_type IN (Pkg_Glb.C_TRN_TRN_SEA ) THEN
                ----------------------------------------------------------
                    v_row_tro.reason_code       :=  Pkg_Glb.C_M_TSEA;
                    it_det(it_det.COUNT+1)      :=  v_row_tro;
                    v_row_tri.reason_code       :=  Pkg_Glb.C_P_TSEA;
                    it_det(it_det.COUNT+1)      :=  v_row_tri;


            -- allocate to order
            WHEN v_row_trh.trn_type IN (Pkg_Glb.C_TRN_ALC_ORD ) THEN
                ----------------------------------------------------------
                    v_row_tro.reason_code       :=  Pkg_Glb.C_M_TALCMF  ;
                    it_det(it_det.COUNT+1)      :=  v_row_tro;
                    v_row_tri.reason_code       :=  Pkg_Glb.C_P_TALCMO   ;
                    it_det(it_det.COUNT+1)      :=  v_row_tri;

            -- deallocate from order
            WHEN v_row_trh.trn_type IN (Pkg_Glb.C_TRN_REM_ORD ) THEN
                ----------------------------------------------------------
                    v_row_tro.reason_code       :=  Pkg_Glb.C_M_TALCMO  ;
                    it_det(it_det.COUNT+1)      :=  v_row_tro;
                    v_row_tri.reason_code       :=  Pkg_Glb.C_P_TALCMF  ;
                    it_det(it_det.COUNT+1)      :=  v_row_tri;

            -- transfer to WIP
            WHEN v_row_trh.trn_type IN (Pkg_Glb.C_TRN_TRN_CNS ) THEN
                ----------------------------------------------------------
                -- we always should have a source warehouse
                v_row_who.whs_code  :=  v_row_tro.whs_code;
                IF Pkg_Get2.f_get_warehouse_2(v_row_who) THEN NULL; END IF;

                IF
                    v_row_who.category_code IN (Pkg_Glb.C_WHS_PAT)
                    AND
                    v_row_whi.whs_code  IS NULL
                THEN
                    -- here we have simply consumption material from
                    -- property warehouse, it is not moved to WIP
                    -- it is a simply consumption
                    v_row_tro.reason_code           :=  Pkg_Glb.C_M_OAUXPATR;
                    it_det(it_det.COUNT+1)          :=  v_row_tro;
                ELSE
                    IF v_row_tro.group_code IS NOT NULL THEN
                        -- we already are on order and the downloading of
                        -- the source warehouse will be with order
                        CASE    v_row_who.category_code
                            WHEN    Pkg_Glb.C_WHS_MPC   THEN
                                v_row_tro.reason_code   :=  Pkg_Glb.C_M_TWIPCUST;
                            WHEN    Pkg_Glb.C_WHS_MPP   THEN
                                v_row_tro.reason_code   :=  Pkg_Glb.C_M_TWIPPATR;
                        END CASE;
                        it_det(it_det.COUNT+1)          :=  v_row_tro;
                        --
                        v_row_tri.reason_code           :=  Pkg_Glb.C_P_TWIPAO;
                        it_det(it_det.COUNT+1)          :=  v_row_tri;
                    ELSE
                        IF v_row_tri.group_code IS NULL THEN
                            -- here we transfer in the free stock
                            CASE    v_row_who.category_code
                                WHEN    Pkg_Glb.C_WHS_MPC   THEN
                                    v_row_tro.reason_code   :=  Pkg_Glb.C_M_TWIPCUST;
                                WHEN    Pkg_Glb.C_WHS_MPP   THEN
                                    v_row_tro.reason_code   :=  Pkg_Glb.C_M_TWIPPATR;
                            END CASE;
                            it_det(it_det.COUNT+1)          :=  v_row_tro;
                            --
                            v_row_tri.reason_code           :=  Pkg_Glb.C_P_TWIPMF;
                            it_det(it_det.COUNT+1)          :=  v_row_tri;
                        ELSE
                            -- here we have to do first an alocation on the same
                            -- warehouse and after that a transfer the already
                            --allocated materials to WIP
                            v_row_tro.reason_code           :=  Pkg_Glb.C_M_TALCMF;
                            it_det(it_det.COUNT+1)          :=  v_row_tro;
                            --
                            v_row_tro.group_code            :=  v_row_tri.group_code;
                            v_row_tro.trn_sign              :=  +1; --
                            v_row_tro.reason_code           :=  Pkg_Glb.C_P_TALCMO;
                            it_det(it_det.COUNT+1)          :=  v_row_tro;
                            --
                            v_row_tro.trn_sign              :=  -1;
                            --
                            CASE    v_row_who.category_code
                                WHEN    Pkg_Glb.C_WHS_MPC   THEN
                                    v_row_tro.reason_code   :=  Pkg_Glb.C_M_TWIPCUST;
                                WHEN    Pkg_Glb.C_WHS_MPP   THEN
                                    v_row_tro.reason_code   :=  Pkg_Glb.C_M_TWIPPATR;
                            END CASE;
                            it_det(it_det.COUNT+1)          :=  v_row_tro;
                            --
                            v_row_tri.reason_code           :=  Pkg_Glb.C_P_TWIPAO;
                            it_det(it_det.COUNT+1)          :=  v_row_tri;

                        END IF;
                    END IF;
                END IF;


            -------------------------------------------------------------------
            -- Return from  WIP
            WHEN v_row_trh.trn_type IN (Pkg_Glb.C_TRN_TRN_RET ) THEN
                ----------------------------------------------------------
                IF v_row_tro.whs_code IS NOT NULL THEN
                    IF v_row_tro.group_code IS NOT NULL THEN
                        v_row_tro.reason_code   :=  Pkg_Glb.C_M_TRETMO;
                    ELSE
                        v_row_tro.reason_code   :=  Pkg_Glb.C_M_TRETMF;
                    END IF;
                    it_det(it_det.COUNT+1)          :=  v_row_tro;
                END IF;
                -- we should always have a destination warehouse
                v_row_whi.whs_code  :=  v_row_tri.whs_code;
                IF Pkg_Get2.f_get_warehouse_2(v_row_whi) THEN NULL; END IF;
                CASE
                    WHEN    v_row_whi.category_code =   Pkg_Glb.C_WHS_PAT   THEN
                        v_row_tri.reason_code   :=  Pkg_Glb.C_P_IAUXPATR;
                    WHEN    v_row_whi.category_code =   Pkg_Glb.C_WHS_MPP   THEN
                        v_row_tri.reason_code   :=  Pkg_Glb.C_P_TRETPATR;
                    WHEN    v_row_whi.category_code =   Pkg_Glb.C_WHS_MPC   THEN
                        v_row_tri.reason_code   :=  Pkg_Glb.C_P_TRETCUST;
                END CASE;
                it_det(it_det.COUNT+1)          :=  v_row_tri;

            -- Generic movement 
            WHEN v_row_trh.trn_type IN (Pkg_Glb.C_TRN_TRN_GEN) THEN

                    v_row_tro.reason_code       :=  Pkg_Glb.C_M_TTRAN;
                    it_det(it_det.COUNT+1)      :=  v_row_tro;
                    v_row_tri.reason_code       :=  Pkg_Glb.C_P_TTRAN;
                    it_det(it_det.COUNT+1)      :=  v_row_tri;

            ELSE
                NULL;

        END CASE;

    END LOOP;
    --
    Pkg_Err.p_raise_error_message();
    --
    DELETE FROM VW_BLO_PREPARE_TRN;
    --
    FORALL i IN 1..it_det.COUNT
    INSERT INTO VW_BLO_PREPARE_TRN
    VALUES      it_det(i);
    -- make a regrouping of the lines
    
    it_det.DELETE;
    FOR x IN C_REGROUP_LINES LOOP
        it_det(it_det.COUNT + 1)    :=  x;
    END LOOP;
    ---
    DELETE FROM VW_BLO_PREPARE_TRN;
    --
    FORALL i IN 1..it_det.COUNT
    INSERT INTO VW_BLO_PREPARE_TRN
    VALUES      it_det(i);

    --
    commit;

    --//////////////////////////////////////////////////////////////////////
    -- call the movement engine
    Pkg_Mov.p_whs_trn_engine(
                                p_row_trn   => v_row_trh
                            );

    --//////////////////////////////////////////////////////////////////////

    -- mark the receipt header as registered
    v_row_hed.status := 'F';
    Pkg_Iud.p_trn_plan_header_iud('U',v_row_hed);
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 12/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_ship_trn_plan( p_idriga  INTEGER)
/*----------------------------------------------------------------------------------
--  PURPOSE:
--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    CURSOR  C_LINES(p_ref_plan INTEGER)   IS
        SELECT  *
        FROM    TRN_PLAN_DETAIL m
        WHERE   ref_plan    =   p_ref_plan
        ORDER BY m.idriga
        ;

    CURSOR  C_ORGANIZATION_LOC(p_org_code VARCHAR2) IS
        SELECT  *
        FROM    ORGANIZATION_LOC
        WHERE   org_code    =   p_org_code
        ORDER BY loc_code DESC
        ;



    v_row_hed               TRN_PLAN_HEADER%ROWTYPE;
    v_row_she               SHIPMENT_HEADER%ROWTYPE;
    it_whs                  Pkg_Rtype.tas_warehouse;
    it_chk_whs              Pkg_Glb.typ_varchar_varchar;

    it_pln                  Pkg_Rtype.ta_trn_plan_detail;
    it_sde                  Pkg_Rtype.ta_shipment_detail;
    v_row                   SHIPMENT_DETAIL%ROWTYPE;
    v_row_olo               ORGANIZATION_LOC%ROWTYPE;

    C_SHIP_TYPE             VARCHAR2(32000)     :=  'TP1';


BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_idriga IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe un plan de miscare valid !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the plan header
    v_row_hed.idriga    :=  p_idriga;
    IF NOT Pkg_Get.f_get_trn_plan_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Planul de miscare cu identificatorul intern '
                                    || p_idriga ||' nu exista in sistem !!!',
              p_err_detail        => p_idriga,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- if the plan was processed already
    IF v_row_hed.status <> 'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan a fost deja executat '
                                    || ' !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check the correct trn_type
    IF v_row_hed.trn_type <> Pkg_Glb.C_TRN_SHP_CTL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan nu este de tip '
                                    || 'expeditie la terti !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --- load the warehouses in the array
    FOR x IN Pkg_Nomenc.C_WAREHOUSE LOOP
        it_whs(x.whs_code)  :=  x;
    END LOOP;

    -- read al plan detail lines in memory
    OPEN    C_LINES(p_idriga);
    FETCH   C_LINES  BULK COLLECT INTO it_pln;
    CLOSE   C_LINES;
    -- check if there are detail lines
    IF it_pln.COUNT = 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan nu are nici o linie de '
                                    ||' detaliu !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check consistency
    -- call the same routin that checks the detail line when the line
    -- is created with the I - insert parameter
    FOR i IN 1..it_pln.COUNT LOOP
        Pkg_Mov.p_trn_plan_detail_blo(  p_tip           =>  'I',
                                        p_row           =>  it_pln(i),
                                        p_check_only    =>  'Y'
                                      );
        -- check how many outside processing warehouses exists
        -- should be only one
        it_chk_whs(it_pln(i).whs_code_in)   :=  NULL;

    END LOOP;
    Pkg_Err.p_raise_error_message();
    --
    IF it_chk_whs.COUNT > 1 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'In detaliile de plan exista linii '
                                    ||'cu diferite magazii de destinatie, '
                                    ||'ar trebuii sa exista numai o singura '
                                    ||'magazie de destinatie '
                                    ||'!!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;

    -----
    -- build the shipment header line

    v_row_she.sbu_code          :=  NULL;
    v_row_she.ship_year         :=  NULL;
    v_row_she.ship_code         :=  NULL;
    v_row_she.ship_date         :=  NULL;
    v_row_she.org_code          :=  v_row_hed.org_code;
    v_row_she.ship_type         :=  C_SHIP_TYPE;
    -- detremin the client to wich to send

    v_row_she.org_client        :=  it_whs(it_pln(1).whs_code_in).org_code ;
    v_row_she.org_delivery      :=  v_row_she.org_client;

    -- get the firts destination code for this organization
    OPEN    C_ORGANIZATION_LOC(v_row_she.org_client);
    FETCH   C_ORGANIZATION_LOC  INTO v_row_olo;
    CLOSE   C_ORGANIZATION_LOC;

    v_row_she.destin_code       :=  v_row_olo.loc_code; -- the first destin code
    v_row_she.status            :=  'I';
    v_row_she.whs_code          :=  it_pln(1).whs_code_in;
    v_row_she.incoterm          :=  NULL;
    v_row_she.note              :=  NULL;
    v_row_she.package_number    :=  0;
    v_row_she.ref_acrec         :=  NULL;
    v_row_she.truck_number      :=  NULL;
    v_row_she.weight_net        :=  0;
    v_row_she.weight_brut       :=  0;

    -- create the shipment header
    Pkg_Shipment.p_shipment_header_blo('I',v_row_she);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_shipment_header_iud('I',v_row_she);
    -- recover the idriga of the line
    v_row_she.idriga    :=  Pkg_Lib.f_read_pk();

    -- build the shipment detail line
    FOR i IN 1..it_pln.COUNT LOOP


        v_row.ref_shipment          :=      v_row_she.idriga;
        v_row.org_code              :=      it_pln(i).org_code;
        v_row.item_code             :=      it_pln(i).item_code;
        v_row.colour_code           :=      it_pln(i).colour_code;
        v_row.size_code             :=      it_pln(i).size_code;
        v_row.oper_code_item        :=      it_pln(i).oper_code_item;
        v_row.description_item      :=      NULL;
        v_row.whs_code              :=      it_pln(i).whs_code_out;
        v_row.order_code            :=      it_pln(i).order_code;
        v_row.group_code            :=      it_pln(i).group_code_in;
        v_row.group_code_out        :=      it_pln(i).group_code_out;
        v_row.season_code           :=      it_pln(i).season_code_out;
        v_row.custom_code           :=      NULL;
        v_row.origin_code           :=      NULL;
        v_row.qty_doc               :=      it_pln(i).qty;
        v_row.uom_shipment          :=      it_pln(i).uom;
        v_row.qty_doc_puom          :=      NULL;
        v_row.puom                  :=      it_pln(i).puom;
        v_row.weight_net            :=      0;
        v_row.package_code          :=      NULL;
        v_row.quality               :=      NULL;
        v_row.note                  :=      NULL;

        it_sde(it_sde.COUNT+1)      :=      v_row;
    END LOOP;

    -- pass trough the bussines logic of the sipment detail table
    FOR i IN 1..it_sde.COUNT LOOP
        Pkg_Shipment.p_shipment_detail_blo('I',it_sde(i));
    END LOOP;
    Pkg_Err.p_raise_error_message();
    --
    -- create the  shipment detail lines
    Pkg_Iud.p_shipment_detail_miud('I',it_sde);
    -- mark the receipt header as registered
    v_row_hed.status := 'F';
    Pkg_Iud.p_trn_plan_header_iud('U',v_row_hed);
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 12/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_receive_trn_plan( p_idriga  INTEGER)
/*----------------------------------------------------------------------------------
--  PURPOSE:
--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    CURSOR  C_LINES(p_ref_plan INTEGER)   IS
        SELECT  *
        FROM    TRN_PLAN_DETAIL m
        WHERE   ref_plan    =   p_ref_plan
        ORDER BY m.idriga
        ;


    v_row_hed               TRN_PLAN_HEADER%ROWTYPE;
    v_row_rhe               RECEIPT_HEADER%ROWTYPE;
    it_whs                  Pkg_Rtype.tas_warehouse;
    it_chk_whs              Pkg_Glb.typ_varchar_varchar;
    it_chk_ord              Pkg_Glb.typ_varchar_varchar;

    it_pln                  Pkg_Rtype.ta_trn_plan_detail;
    it_rde                  Pkg_Rtype.ta_receipt_detail;
    v_row                   RECEIPT_DETAIL%ROWTYPE;
    v_row_sre               SETUP_RECEIPT%ROWTYPE;
    v_row_sup               ORGANIZATION%ROWTYPE;

    C_RECEIPT_TYPE_M        VARCHAR2(32000)     :=  'MIR';
    C_RECEIPT_TYPE_S        VARCHAR2(32000)     :=  'SI1';


BEGIN
    --
    Pkg_Err.p_reset_error_message();
    -- check if we have idriga
    IF p_idriga IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe un plan de miscare valid !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the plan header
    v_row_hed.idriga    :=  p_idriga;
    IF NOT Pkg_Get.f_get_trn_plan_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Planul de miscare cu identificatorul intern '
                                    || p_idriga ||' nu exista in sistem !!!',
              p_err_detail        => p_idriga,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- if the plan was processed already
    IF v_row_hed.status <> 'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan a fost deja executat '
                                    || ' !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check the correct trn_type
    IF v_row_hed.trn_type <> Pkg_Glb.C_TRN_REC_CTL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan nu este de tip '
                                    || 'receptie de la terti !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --- load the warehouses in the array
    FOR x IN Pkg_Nomenc.C_WAREHOUSE LOOP
        it_whs(x.whs_code)  :=  x;
    END LOOP;

    -- read al plan detail lines in memory
    OPEN    C_LINES(p_idriga);
    FETCH   C_LINES  BULK COLLECT INTO it_pln;
    CLOSE   C_LINES;
    -- check if there are detail lines
    IF it_pln.COUNT = 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan nu are nici o linie de '
                                    ||' detaliu !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- check consistency
    -- call the same routin that checks the detail line when the line
    -- is created with the I - insert parameter
    FOR i IN 1..it_pln.COUNT LOOP
        Pkg_Mov.p_trn_plan_detail_blo(  p_tip           =>  'I',
                                        p_row           =>  it_pln(i),
                                        p_check_only    =>  'Y'
                                      );
        -- check how many outside processing warehouses exists
        -- should be only one
        it_chk_whs(it_pln(i).whs_code_out)   :=  NULL;
        -- check if plan has a mix of raw material return an processed
        -- items return
        IF it_pln(i).order_code IS NOT NULL THEN
            it_chk_ord(C_RECEIPT_TYPE_S) :=  NULL;
        ELSE
            it_chk_ord(C_RECEIPT_TYPE_M) :=  NULL;
        END IF;

    END LOOP;
    Pkg_Err.p_raise_error_message();
    --
    IF it_chk_whs.COUNT > 1 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'In detaliile de plan exista linii '
                                    ||'cu diferite magazii sursa la terti, '
                                    ||'ar trebuii sa exista numai o singura '
                                    ||'magazie sursa asociata cu un singur tert '
                                    ||'!!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --- check if we have mixed (raw material + semiprocessed ) in the plan
    IF it_chk_ord.COUNT > 1 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Pe aceeasi receptie de la terti '
                                    ||'nu poate exista in acelasi timp '
                                    ||'si retur de materiale si receptie '
                                    ||'de semiprocesate prelucrate de tert '
                                    ||'!!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -----
    -- build the receipt header line
    v_row_sre.receipt_type          :=  it_chk_ord.FIRST;
    IF Pkg_Get2.f_get_setup_receipt_2(v_row_sre) THEN NULL ; END IF;


    v_row_rhe.receipt_year          :=  NULL;
    v_row_rhe.receipt_code          :=  NULL;
    v_row_rhe.receipt_date          :=  NULL;
    v_row_rhe.org_code              :=  v_row_hed.org_code;
    v_row_rhe.receipt_type          :=  v_row_sre.receipt_type;
    v_row_rhe.suppl_code            :=  it_whs(it_chk_whs.FIRST).org_code;
    v_row_rhe.doc_number            :=  NULL;
    v_row_rhe.doc_date              :=  NULL;
    v_row_rhe.incoterm              :=  NULL;
    v_row_rhe.currency_code         :=  v_row_sre.currency_code;

    v_row_sup.org_code              :=  v_row_rhe.suppl_code;
    IF Pkg_Get2.f_get_organization_2(v_row_sup) THEN NULL; END IF;

    v_row_rhe.country_from          :=  v_row_sup.country_code;
    v_row_rhe.note                  :=  NULL;
    v_row_rhe.whs_code              :=  it_chk_whs.FIRST;
    v_row_rhe.status                :=  'I';

    -- create the receipt header
    Pkg_Receipt.p_receipt_header_blo('I',v_row_rhe);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_receipt_header_iud('I',v_row_rhe);
    -- recover the idriga of the line
    v_row_rhe.idriga    :=  Pkg_Lib.f_read_pk();

    -- build the receipt detail line
    FOR i IN 1..it_pln.COUNT LOOP

        v_row.ref_receipt       :=  v_row_rhe.idriga;
        v_row.uom_receipt       :=  it_pln(i).uom;
        v_row.qty_doc           :=  it_pln(i).qty;
        v_row.qty_count         :=  it_pln(i).qty;
        v_row.puom              :=  it_pln(i).uom;
        v_row.qty_doc_puom      :=  NULL;
        v_row.qty_count_puom    :=  NULL;
        v_row.org_code          :=  it_pln(i).org_code;
        v_row.item_code         :=  it_pln(i).item_code;
        v_row.colour_code       :=  it_pln(i).colour_code;
        v_row.size_code         :=  it_pln(i).size_code;
        v_row.oper_code_item    :=  it_pln(i).oper_code_item;
        v_row.season_code       :=  it_pln(i).season_code_out;
        v_row.whs_code          :=  it_pln(i).whs_code_in;
        v_row.order_code        :=  it_pln(i).order_code;
        v_row.custom_code       :=  NULL;
        v_row.origin_code       :=  NULL;
        v_row.weight_net        :=  0;
        v_row.weight_brut       :=  0;
        v_row.price_doc         :=  0;
        v_row.price_doc_puom    :=  NULL;
        v_row.note              :=  NULL;
        v_row.group_code        :=  it_pln(i).group_code_out;
        v_row.weight_pack       :=  0;

        it_rde(it_rde.COUNT+1)      :=      v_row;
    END LOOP;

    -- pass trough the bussines logic of the receipt detail table
    FOR i IN 1..it_rde.COUNT LOOP
        Pkg_Receipt.p_receipt_detail_blo('I',it_rde(i));
    END LOOP;
    Pkg_Err.p_raise_error_message();
    --
    -- create the  receipt detail lines
    Pkg_Iud.p_receipt_detail_miud('I',it_rde);
    -- mark the receipt header as registered
    v_row_hed.status := 'F';
    Pkg_Iud.p_trn_plan_header_iud('U',v_row_hed);
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;






/***********************************************************************************************
    DDL:    20/03/2008  d   moved from Pkg_Ecl_Ang
/***********************************************************************************************/
FUNCTION f_sql_whs_trn      (    p_org_code      VARCHAR2,
                                p_trn_year      VARCHAR2,
                                p_trn_type      VARCHAR2,
                                p_start_date    DATE,
                                p_end_date      DATE
                            )   RETURN typ_frm  pipelined
-------------------------------------------------------------------------------------------------
--  PURPOSE:    record-source for warehouse movement analysis
-------------------------------------------------------------------------------------------------
IS

    CURSOR  C_LINES     (   p_org_code      VARCHAR2    ,
                            p_trn_year      VARCHAR2    ,
                            p_trn_type      VARCHAR2    ,
                            p_start_date    DATE        ,
                            p_end_date      DATE        )
            IS
            SELECT
                        h.idriga,
                        MAX(h.dcn)             dcn,
                        MAX(h.datagg)          datagg,
                        MAX(h.trn_code)        trn_code,
                        MAX(h.trn_date)        trn_date,
                        MAX(h.date_legal)      date_legal,
                        MAX(h.trn_type)        trn_type,
                        MAX(h.partner_code)    partner_code,
                        MAX(h.doc_year)        doc_year,
                        MAX(h.doc_code)        doc_code,
                        MAX(h.doc_date)        doc_date,
                        --
                        COUNT(DISTINCT d.whs_code)                      whs_count,
                        MIN(DECODE(d.trn_sign, -1,d.whs_code,NULL))     whs_out_1,
                        MAX(DECODE(d.trn_sign, -1,d.whs_code,NULL))     whs_out_2,
                        MIN(DECODE(d.trn_sign,  1,DECODE(r.show_user,'N',NULL,d.whs_code),NULL))     whs_in_1,
                        MAX(DECODE(d.trn_sign,  1,DECODE(r.show_user,'N',NULL,d.whs_code),NULL))     whs_in_2,
                        COUNT(DISTINCT d.item_code)                     item_count,
                        SUM(DECODE(d.trn_sign, -1,d.qty     ,NULL))     qty_out,
                        SUM(DECODE(d.trn_sign,  1,d.qty     ,NULL))     qty_in,
                        MIN(d.order_code)                               order_code_min,
                        MAX(d.order_code)                               order_code_max,
                        COUNT(DISTINCT d.order_code)                    order_count,
                        MAX(h.employee_code)                            employee_code,
                        MAX(u.nume)                                     nume,
                        MAX(u.prenume)                                  prenume,
                        COUNT(DISTINCT d.season_code)                   season_count,
                        MIN(d.season_code)                              season_min,
                        MAX(d.season_code)                              season_max,
                        MAX(h.note)                                     note,
                        MAX(h.flag_storno)                              flag_storno,
                        MAX(h.ref_storno)                               ref_storno
            -----------------------------------------------------------------------------------
            FROM        WHS_TRN             h
            LEFT JOIN   WHS_TRN_DETAIL      d   ON  d.ref_trn       =   h.idriga
            LEFT JOIN   APP_USER            u   ON  u.user_code     =   h.employee_code
            LEFT JOIN   WHS_TRN_REASON      r   ON  r.reason_code   =   d.reason_code
            -----------------------------------------------------------------------------------
            WHERE       h.trn_year          =       p_trn_year
                AND     h.org_code          =       p_org_code
                AND     h.trn_type          LIKE    NVL(p_trn_type, '%')
                AND     h.date_legal        BETWEEN NVL(p_start_date, Pkg_Glb.C_PAST    )
                                                AND NVL(p_end_date  , Pkg_Glb.C_FUTURE  )
            GROUP BY h.idriga
            ORDER BY trn_date DESC,h.idriga DESC
            ;

    v_row       tmp_frm := tmp_frm();
    v_row_trh   WHS_TRN%ROWTYPE;

BEGIN

    FOR X IN C_LINES    (       p_org_code    ,
                                p_trn_year    ,
                                p_trn_type    ,
                                p_start_date  ,
                                p_end_date    )
    LOOP

        v_row.idriga    :=  X.idriga;
        v_row.dcn       :=  X.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  X.trn_code;
        v_row.txt02     :=  X.trn_type;
        v_row.txt03     :=  p_trn_year;
        v_row.txt04     :=  X.partner_code;
        v_row.txt05     :=  X.doc_year;
        v_row.txt06     :=  X.doc_code;

        v_row.txt07     :=  NULL;
        IF X.whs_out_1 IS NOT NULL THEN
            v_row.txt07 :=  X.whs_out_1;
            IF X.whs_out_1 <> X.whs_out_2 THEN
                 v_row.txt07 := v_row.txt07 ||','||X.whs_out_2 ;
            END IF;
        END IF;
        v_row.txt07 := v_row.txt07 ||' ==> ';

        IF X.whs_in_1 IS NOT NULL THEN
            v_row.txt07 :=  v_row.txt07 || X.whs_in_1;
            IF X.whs_in_1 <> X.whs_in_2 THEN
                 v_row.txt07 := v_row.txt07 ||','||X.whs_in_2 ;
            END IF;
        END IF;
        v_row.txt08     := X.employee_code;
        v_row.txt09     := X.nume ||' '|| X.prenume;

        v_row.txt10     := X.season_min;
        IF X.season_max <> X.season_min THEN
            v_row.txt10     := v_row.txt10 ||', ' || X.season_max;
        END IF;

        v_row.txt11     :=  p_org_code;
        v_row.txt12     :=  X.note;
        v_row.txt13     :=  X.flag_storno;
        IF x.flag_storno <> 'N' THEN
            v_row_trh.idriga    :=  x.ref_storno;
            Pkg_Get.p_get_whs_trn(v_row_trh,0);
            v_row.txt14         :=  v_row_trh.trn_code;
        ELSE
            v_row.txt14         :=  '';
        END IF;
        v_row.txt15     :=  x.order_code_min;
        IF x.order_code_max <> x.order_code_min THEN
            v_row.txt15 :=  v_row.txt15 || ','||x.order_code_max;
        END IF;

        v_row.data01    :=  X.trn_date;
        v_row.data02    :=  X.doc_date;
        v_row.data03    :=  X.date_legal;

        v_row.numb01    :=  X.whs_count;
        v_row.numb02    :=  X.item_count;
        v_row.numb03    :=  X.qty_out;
        v_row.numb04    :=  X.qty_in;
        v_row.numb05    :=  X.season_count;
        v_row.numb06    :=  0;
        v_row.numb07    :=  x.order_count;

        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/***********************************************************************************************
    DDL:    20/03/2008  d   moved from Pkg_Ecl_Ang
/***********************************************************************************************/
FUNCTION f_sql_whs_trn_detail       (   p_ref_trn       INTEGER ,
                                        p_show_user     VARCHAR2
                                    )   RETURN          typ_frm     pipelined
-------------------------------------------------------------------------------------------------
--  PURPOSE:    record-source for warehouse movement analysis
-------------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (   p_ref_trn       INTEGER,
                        p_show_user     VARCHAR2
                    )
                    IS
                    SELECT
                                d.idriga,d.org_code,
                                d.item_code, d.oper_code_item, i.description,d.puom,
                                d.trn_sign,d.qty,
                                d.whs_code,d.colour_code,d.size_code,d.order_code,
                                d.group_code,
                                d.season_code,d.cost_center, d.wc_code,
                                d.reason_code,
                                --
                                c.description   c_description
                    ---------------------------------------------------------------------------
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  ITEM                i
                                    ON  i.org_code      =   d.org_code
                                    AND i.item_code     =   d.item_code
                    INNER JOIN  WHS_TRN_REASON      r
                                    ON  d.reason_code   =   r.reason_code
                    LEFT JOIN   COLOUR              c
                                    ON  c.org_code      =   d.org_code
                                    AND c.colour_code   =   d.colour_code
                    ---------------------------------------------------------------------------
                    WHERE           d.ref_trn           =   p_ref_trn
                                AND r.show_user         LIKE DECODE(p_show_user,'N','%',NULL,'%','Y')
                    ---------------------------------------------------------------------------
                    ORDER BY    d.trn_sign  ASC,
                                i.make_buy  DESC,
                                d.whs_code  ,
                                d.reason_code,
                                d.group_code NULLS FIRST,
                                d.item_code ,
                                d.size_code
                    ;


    v_row      tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES    (p_ref_trn,p_show_user)         LOOP

        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  0;
        v_row.seq_no    :=  c_lines%rowcount;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.item_code;
        v_row.txt03     :=  x.description;
        v_row.txt04     :=  x.whs_code;
        v_row.txt05     :=  x.colour_code;
        v_row.txt06     :=  x.size_code;
        v_row.txt07     :=  x.order_code;
        v_row.txt08     :=  x.group_code;
        v_row.txt09     :=  x.puom;
        v_row.txt10     :=  x.season_code;
        v_row.txt11     :=  x.cost_center;
        v_row.txt12     :=  x.oper_code_item;
        v_row.txt13     :=  x.reason_code;
        v_row.txt14     :=  x.c_description;
        v_row.txt15     :=  x.wc_code;


        v_row.numb01    :=  p_ref_trn;
        v_row.numb02    :=  x.trn_sign;
        v_row.numb03    :=  x.qty;


        pipe ROW(v_row);
    END LOOP;
    RETURN;
END;

/***********************************************************************************************

/***********************************************************************************************/
FUNCTION  f_sql_whs_situation(  p_org_code      VARCHAR2,
                                p_whs_code      VARCHAR2,
                                p_season_code   VARCHAR2
                             ) RETURN typ_frm  pipelined
IS

    CURSOR  C_LINES (p_org_code VARCHAR2, p_whs_code VARCHAR2, p_season_code VARCHAR2)
        IS
        SELECT      s.*,
                    i.description, i.suom,i.flag_size,i.flag_range,i.flag_colour,
                    w.description   w_description,
                    i.puom
        FROM        STOC_ONLINE      s
        INNER JOIN  ITEM                i
                        ON  i.org_code  =   s.org_code
                        AND i.item_code =   s.item_code
        INNER JOIN  WAREHOUSE           w
                        ON  w.whs_code  =   s.whs_code
        WHERE   s.org_code      =   p_org_code
            AND s.whs_code      =   p_whs_code
            AND s.season_code   LIKE NVL(p_season_code, '%')
        ORDER BY    s.season_code,s.whs_code,s.item_code,s.size_code,s.colour_code
        ;

    v_row               tmp_frm := tmp_frm();

BEGIN

/*    Pkg_Mov.P_Stoc_Online(
                                p_org_code      =>  p_org_code,
                                p_whs_code      =>  p_whs_code,
                                p_season_code   =>  p_season_code
                         );
*/

    FOR X IN C_LINES (p_org_code, p_whs_code, p_season_code) 
    LOOP

        v_row.idriga    :=      c_lines%rowcount;
        v_row.dcn       :=      0;
        v_row.seq_no    :=      c_lines%rowcount;

        v_row.txt01     :=      x.item_code;
        v_row.txt02     :=      x.description;
        v_row.txt03     :=      x.puom;
        v_row.txt04     :=      x.whs_code;
        v_row.txt05     :=      x.w_description;
        v_row.txt06     :=      x.size_code;
        v_row.txt07     :=      x.colour_code;
        v_row.txt08     :=      x.org_code;
        v_row.txt09     :=      x.suom;
        v_row.txt10     :=      x.order_code;
        v_row.txt11     :=      x.season_code;
        v_row.txt12     :=      x.oper_code_item;
        v_row.txt13     :=      x.group_code;


        v_row.numb01    :=      x.flag_size;
        v_row.numb02    :=      x.flag_colour;
        v_row.numb03    :=      x.qty;

        v_row.data01   := SYSDATE;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 23/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_prepare_pick_plan_2(p_ref_plan   INTEGER)
----------------------------------------------------------------------------------
--  PURPOSE:
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    PRAGMA AUTONOMOUS_TRANSACTION;


    CURSOR  C_LINES(    p_item_code     VARCHAR2,
                        p_whs_code      VARCHAR2,
                        p_group_code    VARCHAR2,
                        p_season_code   VARCHAR2
                    )   IS
                SELECT *
                FROM
                    (
                     SELECT
                             --+ USE_NL(t i c) ORDERED
                             t.*,
                             ---
                             i.description   i_description, i.whs_stock,
                             ---
                             c.description   c_description
                     FROM        VW_STOC_ONLINE  t
                     INNER JOIN  ITEM            i
                                     ON  t.org_code      =   i.org_code
                                     AND t.item_code     =   i.item_code
                     LEFT JOIN   COLOUR          c
                                     ON  c.org_code      =   t.org_code
                                     AND c.colour_code   =   t.colour_code
                     WHERE      t.qty > 0
                    ) x
                 WHERE
                            item_code       IN ( SELECT txt01
                                                -- we need to specify a certain separator for f_sql_inlist
                                                -- bcause otherwise the function takes any seperator
                                                -- and the item codes has characters like point
                                                FROM TABLE(Pkg_Lib.F_Sql_Inlist(NVL(p_item_code,x.item_code ),',')))
                        AND whs_code        IN ( SELECT txt01
                                                FROM TABLE(Pkg_Lib.F_Sql_Inlist(NVL(p_whs_code,x.whs_code ))))
                        AND (
                                p_group_code    IS NULL
                                OR
                                group_code      IN ( SELECT txt01
                                                FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_group_code)))
                            )
                        AND season_code     IN ( SELECT txt01
                                                FROM TABLE(Pkg_Lib.F_Sql_Inlist(NVL(p_season_code,x.season_code ))))
                  ORDER BY group_code,oper_code_item,item_code,size_code,colour_code
                  ;


    CURSOR  C_ALREADY_PICKED(p_ref_plan INTEGER) IS
        SELECT  *
        FROM    TRN_PLAN_DETAIL
        WHERE   ref_plan    =   p_ref_plan
        ;


    it_apk                  Pkg_Glb.type_dim_10;
    v_qty                   NUMBER;

    v_row_tpl               TRN_PLAN_HEADER%ROWTYPE;
    v_row                   VW_PREP_PICK_PLAN%ROWTYPE;
    v_insert                BOOLEAN;
    v_no_data               BOOLEAN;

    C_REC_CTL_MP            VARCHAR2(100)   :=  'REC_CTL-MP';
    C_REC_CTL_SP            VARCHAR2(100)   :=  'REC_CTL-SP';
    C_REC_INTO_WHS          VARCHAR2(100)   :=  'MPLOHN';

    C_SEGMENT_CODE          VARCHAR2(32000) :=  'VW_PREP_PICK_PLAN';
    C_SEGMENT_CODE2         VARCHAR2(32000) :=  'VW_PREP_GROUP_CODE';

BEGIN
    Pkg_Err.p_reset_error_message();
    --
    v_row_tpl.idriga    :=  p_ref_plan;
    IF Pkg_Get.f_get_trn_plan_header(v_row_tpl) THEN NULL; END IF;

    -- load the already picked quantities
    FOR x IN C_ALREADY_PICKED(p_ref_plan) LOOP

            v_qty   := Pkg_Lib.f_get_mdim
                            (   p_it    =>  it_apk          ,
                                p_1     =>  x.org_code      ,
                                p_2     =>  x.item_code     ,
                                p_3     =>  x.oper_code_item  ,
                                p_4     =>  x.colour_code  ,
                                p_5     =>  x.size_code  ,
                                p_6     =>  x.season_code_out,
                                p_7     =>  x.whs_code_out,
                                p_8     =>  x.group_code_out   ,
                                p_9     =>  x.order_code
                            );

            v_qty   := v_qty +  x.qty_puom;

            Pkg_Lib.p_load_mdim(                it_apk          ,
                                                v_qty           ,
                                    p_1     =>  x.org_code      ,
                                    p_2     =>  x.item_code     ,
                                    p_3     =>  x.oper_code_item,
                                    p_4     =>  x.colour_code   ,
                                    p_5     =>  x.size_code     ,
                                    p_6     =>  x.season_code_out,
                                    p_7     =>  x.whs_code_out   ,
                                    p_8     =>  x.group_code_out ,
                                    p_9     =>  x.order_code
                                );
    END LOOP;
    ---

    Pkg_Mov.P_Stoc_Online(
                            p_org_code  =>  v_row_tpl.org_code,
                            p_item_code =>  v_row_tpl.item_code,
                            p_group_code=>  v_row_tpl.group_code,
                            p_whs_code  =>  v_row_tpl.whs_code
                         );

    --
    DELETE FROM VW_PREP_PICK_PLAN;

    v_row.segment_code  :=  C_SEGMENT_CODE;

    v_no_data       :=  TRUE;

    FOR x IN  C_LINES(
                        p_item_code     =>  v_row_tpl.item_code ,
                        p_whs_code      =>  v_row_tpl.whs_code  ,
                        p_group_code    =>  v_row_tpl.group_code,
                        p_season_code   =>  v_row_tpl.season_code
                    )
    LOOP

        v_row.org_code              :=  x.org_code;
        v_row.group_code_out        :=  x.group_code;
        v_row.group_code_in         :=  NULL;
        v_row.item_code             :=  x.item_code;
        v_row.oper_code_item        :=  x.oper_code_item;
        v_row.colour_code           :=  x.colour_code;
        v_row.size_code             :=  x.size_code;
        v_row.start_size            :=  NULL;
        v_row.end_size              :=  NULL;
        v_row.season_code_out       :=  x.season_code;
        v_row.season_code_in        :=  x.season_code;
        v_row.puom                  :=  x.puom;
        v_row.whs_code_out          :=  x.whs_code;
        v_row.whs_code_in           :=  NULL;
        v_row.order_code            :=  x.order_code;
        v_row.oper_code             :=  NULL;
        v_row.description           :=  x.i_description;
        v_row.description_colour    :=  x.c_description;
        v_row.ref_plan              :=  p_ref_plan;
        v_row.flag_total_line       :=  'X';
        v_row.flag_dirty            :=  'N';

        v_row.idriga                :=  C_LINES%rowcount;
        v_row.seq_no                :=  v_row.idriga;
        v_row.seq_no2               :=  0;

        v_row.qty_demand_ini        :=  0;
        v_row.qty_demand_now        :=  0;

        v_row.qty_apick          :=   Pkg_Lib.f_get_mdim
                                 (   p_it    =>  it_apk           ,
                                     p_1     =>  x.org_code        ,
                                     p_2     =>  x.item_code       ,
                                     p_3     =>  x.oper_code_item  ,
                                     p_4     =>  x.colour_code     ,
                                     p_5     =>  x.size_code       ,
                                     p_6     =>  x.season_code     ,
                                     p_7     =>  x.whs_code        ,
                                     p_8     =>  x.group_code      ,
                                     p_9     =>  x.order_code
                                 );




        v_row.qty_stock             :=  x.qty - v_row.qty_apick;
        v_row.qty_pick              :=  0;

        v_insert                    :=  FALSE;
        CASE
            ---------------------------------------------------------------
            WHEN v_row_tpl.trn_type  = Pkg_Glb.C_TRN_REC_CTL THEN
            ---------------------------------------------------------------
                -- for receit from outside processing
                IF v_row_tpl.joly_parameter =   C_REC_CTL_MP THEN
                    IF x.order_code IS NULL THEN
                        v_insert := TRUE;
                    END IF;
                    -- also set the destination warehouse to the default stock
                    -- warehouse of the raw material
                    v_row.whs_code_in   :=  x.whs_stock;
                    -- when returning material from outside processing we are allways
                    -- deallocating it
                    v_row.group_code_in :=  NULL;
                ELSIF v_row_tpl.joly_parameter =   C_REC_CTL_SP THEN
                    IF x.order_code IS NOT NULL THEN
                        -- show only the items that are in the last fase in this location
                        DELETE FROM VW_PREP_GROUP_CODE;
                        INSERT INTO VW_PREP_GROUP_CODE VALUES(x.group_code,C_SEGMENT_CODE2);
                        FOR z IN Pkg_Mov.C_GROUP_ROUTING LOOP
                            IF      z.oper_code_curr = x.oper_code_item
                                AND Pkg_Lib.f_mod_c(z.org_code_curr ,z.org_code_next)
                            THEN
                                v_insert := TRUE;
                            END IF;
                        END LOOP;
                    END IF;
                    -- in this case the destination warehouse is mandatory
                    -- MPLOHN
                    v_row.whs_code_in   :=   C_REC_INTO_WHS;
                    v_row.group_code_in :=   v_row.group_code_out;
                END IF;

            ---------------------------------------------------------------
            WHEN v_row_tpl.trn_type  = Pkg_Glb.C_TRN_TRN_RET THEN
            ---------------------------------------------------------------
                -- return of raw material from WIP
                IF x.order_code IS NULL THEN
                    v_insert := TRUE;
                END IF;
                -- also set the destination warehouse to the default stock
                -- warehouse of the raw material
                v_row.whs_code_in   :=  x.whs_stock;
                -- when returning material from outside processing we are allways
                -- deallocating it
                v_row.group_code_in :=  NULL;

            ---------------------------------------------------------------
            WHEN v_row_tpl.trn_type  = Pkg_Glb.C_TRN_TRN_SEA THEN
            ---------------------------------------------------------------
                -- it is possible to chaneg the season only for raw materials
                IF      x.order_code    IS NULL
                    AND x.group_code    IS NULL
                THEN
                    v_insert := TRUE;
                END IF;
                -- also set the destination warehouse to the same warehouse
                -- we do not move material phisicaly
                -- only change the season
                v_row.whs_code_in       := v_row.whs_code_out ;
                -- we set the destination season code to NULL, has to be specfied
                -- by the user
                v_row.season_code_in    :=  NULL;

            ---------------------------------------------------------------
            WHEN v_row_tpl.trn_type  = Pkg_Glb.C_TRN_REM_ORD THEN
            ---------------------------------------------------------------
                IF      x.order_code    IS NULL
                    AND x.group_code    IS NOT NULL
                THEN
                    v_insert := TRUE;
                END IF;
                -- also set the destination warehouse to the same warehouse
                -- we do not move material phisicaly
                -- only change the season
                v_row.whs_code_in       := v_row.whs_code_out ;
                --
                v_row.group_code_in     :=  NULL;


            ELSE
                v_insert    :=  FALSE;
        END CASE;

        IF v_insert THEN
            v_no_data   :=  FALSE;
            INSERT INTO VW_PREP_PICK_PLAN VALUES      v_row;
        END IF;
    END LOOP;
    --
    IF v_no_data THEN
          Pkg_Err.p_set_error_message
          (    p_err_code          => '00' ,
               p_err_header        => 'Nu exista stocuri pentru criteriile de picking'
                                      ||' precizate !!!',
               p_err_detail        => NULL ,
               p_flag_immediate    => 'Y'
          );
    END IF;
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;




/*********************************************************************************
    DDL: 22/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_pick_plan    (   p_ref_plan              INTEGER,
                                p_force_qty_pick_zero   VARCHAR2
                             )  RETURN typ_frm  pipelined
----------------------------------------------------------------------------------
--  PURPOSE:
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    CURSOR     C_LINES    IS
                SELECT  *
                FROM    VW_PREP_PICK_PLAN
                ORDER BY seq_no ASC, seq_no2 ASC
                ;
    --
    v_row_tpl           TRN_PLAN_HEADER%ROWTYPE;
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_ref_plan IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe un plan de miscare valid !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the plan header
    v_row_tpl.idriga    :=  p_ref_plan;
    IF NOT Pkg_Get.f_get_trn_plan_header(v_row_tpl) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Planul de miscare cu identificatorul intern '
                                    || p_ref_plan ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_plan,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- if the plan was processed already
    IF v_row_tpl.status <> 'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Acest plan a fost deja executat '
                                    || ' !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --- if there were NO parameters selected
    IF v_row_tpl.pick_parameter = 'N' THEN
          Pkg_Err.p_set_error_message
          (    p_err_code          => '00' ,
               p_err_header        => 'Nu ati precizat parametrii de '
                                      ||'picking  !!!',
               p_err_detail        => NULL ,
               p_flag_immediate    => 'Y'
          );
    END IF;

    -- make a dispatch logic to build the picking form recordsource
    -- depending on the movement type

    CASE
        WHEN v_row_tpl.trn_type     IN (
                                            Pkg_Glb.C_TRN_ALC_ORD,
                                            Pkg_Glb.C_TRN_TRN_CNS
                                       ) THEN
              Pkg_Mov.p_prepare_pick_plan_1(p_ref_plan, p_force_qty_pick_zero);

        WHEN v_row_tpl.trn_type     IN (    Pkg_Glb.C_TRN_TRN_RET,
                                            Pkg_Glb.C_TRN_REM_ORD,
                                            Pkg_Glb.C_TRN_REC_CTL,
                                            Pkg_Glb.C_TRN_TRN_SEA
                                        ) THEN
              Pkg_Mov.p_prepare_pick_plan_2(p_ref_plan);
        WHEN v_row_tpl.trn_type     IN (
                                            Pkg_Glb.C_TRN_SHP_CTL
                                        ) THEN
              Pkg_Mov.p_prepare_pick_plan_3(p_ref_plan);
        ELSE
              Pkg_Err.p_set_error_message
              (    p_err_code          => '00' ,
                   p_err_header        => 'Pentru tipul de miscare '
                                          ||v_row_tpl.trn_type
                                          ||' nu exista prevazut o modalitate '
                                          ||'de picking '
                                          ||'!!!',
                   p_err_detail        => NULL ,
                   p_flag_immediate    => 'Y'
              );
    END CASE;
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  0;
        v_row.seq_no        :=  C_LINES%rowcount;
        --
        v_row.numb01        :=  p_ref_plan   ;
        v_row.numb02        :=  x.seq_no2     ;
        v_row.numb03        :=  x.qty_demand_ini ;
        v_row.numb04        :=  x.qty_demand_now ;
        v_row.numb05        :=  x.qty_stock ;
        v_row.numb06        :=  x.qty_pick ;
        v_row.numb07        :=  x.seq_group ;
        v_row.numb08        :=  x.qty_free ;
        v_row.numb09        :=  x.qty_apick ;

        --
        v_row.txt01         :=  x.org_code      ;
        v_row.txt02         :=  x.item_code     ;
        v_row.txt03         :=  x.description   ;
        v_row.txt04         :=  x.oper_code_item   ;
        v_row.txt05         :=  x.colour_code   ;
        v_row.txt06         :=  x.size_code     ;
        v_row.txt07         :=  x.start_size     ;
        v_row.txt08         :=  x.end_size     ;
        v_row.txt09         :=  x.season_code_in     ;
        v_row.txt10         :=  x.puom     ;
        v_row.txt11         :=  x.whs_code_out  ;
        v_row.txt12         :=  x.oper_code     ;
        v_row.txt13         :=  x.group_code_out     ;
        v_row.txt14         :=  x.group_code_in     ;
        v_row.txt15         :=  x.flag_total_line;
        v_row.txt16         :=  x.description_colour;
        v_row.txt17         :=  x.whs_code_in;
        v_row.txt18         :=  x.season_code_out;

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
    DDL: 22/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_plan_from_picking(p_ref_plan INTEGER)
----------------------------------------------------------------------------------
--  PURPOSE:    creates the receipt lines from picking
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    CURSOR  C_SET_DEMAND(p_ref_plan  INTEGER)   IS
            SELECT  *
            FROM    VW_PREP_PICK_PLAN
            WHERE   ref_plan    =   p_ref_plan
            ORDER BY seq_no ASC
            ;


    CURSOR     C_LINES (p_ref_plan  INTEGER)   IS
            SELECT
                        v.org_code, v.group_code_in, v.item_code, v.oper_code_item,
                        v.colour_code, v.size_code, v.start_size, v.end_size,
                        v.puom, v.whs_code_out,
                        v.oper_code, v.description, v.group_code_out, v.season_code_out,
                        v.flag_total_line, v.description_colour, v.flag_dirty,
                        v.order_code, v.idriga, v.dcn, v.ref_plan, v.seq_no, v.seq_no2,
                        v.seq_group, v.qty_demand_ini, v.qty_demand_now, v.qty_stock,
                        v.qty_free, v.qty_apick,
                        ---
                        NVL(t.numb03,v.qty_pick      )   qty_pick,
                        NVL(t.txt01 ,v.whs_code_in   )   whs_code_in,
                        NVL(t.txt02 ,v.season_code_in)   season_code_in
                        --
            FROM        VW_PREP_PICK_PLAN       v
            LEFT JOIN   VW_TRANSFER_ORACLE      t
                            ON  v.idriga        =   t.numb01
                            AND v.ref_plan      =   t.numb02
            WHERE       v.ref_plan              =   p_ref_plan
                    AND v.flag_total_line       IN  ('N','X')
                    AND NVL(t.numb03,v.qty_pick) >   0
            ORDER BY v.seq_no
            ;


    CURSOR      C_CHECK_DETAIL (p_ref_plan INTEGER) IS
            SELECT  *
            FROM    TRN_PLAN_DETAIL
            WHERE   ref_plan    =   p_ref_plan
            ;


    v_row_hed       TRN_PLAN_HEADER%ROWTYPE;
    v_row_det       TRN_PLAN_DETAIL%ROWTYPE;
    v_found         BOOLEAN;

    it              Pkg_Rtype.ta_trn_plan_detail;
    it_pck          Pkg_Rtype.ta_vw_prep_pick_plan;
    it_grp          Pkg_Glb.typ_number_varchar;
    it_acm          Pkg_Rtype.tas_trn_plan_detail;
    it_chk          Pkg_Glb.typ_varchar_varchar;
    v_idx           Pkg_Glb.type_index;
    z               VW_PREP_PICK_PLAN%ROWTYPE;

BEGIN

    Pkg_Err.p_reset_error_message();
    --
    -- check if we have idriga
    IF p_ref_plan IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu sunteti pozitionat pe un plan valid !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    -- get the plan header
    v_row_hed.idriga    :=  p_ref_plan;
    IF NOT Pkg_Get.f_get_trn_plan_header(v_row_hed,-1) THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Planul cu identificatorul intern '
                                    || p_ref_plan ||' nu exista in sistem !!!',
              p_err_detail        => p_ref_plan,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    IF v_row_hed.status <> 'I' THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Planul cu identificatorul '
                                    || v_row_hed.plan_code ||' a fost executat / anulat deja'
                                    ||' , nu mai puteti modifica !!!',
              p_err_detail        => v_row_hed.plan_code,
              p_flag_immediate    => 'Y'
         );
    END IF;

    -- the following is necesary when transfer to WIP in the
    -- cases when there are more warehouses that has stocs for
    -- the same item !!!!!!!!!!!!!!!!!!!!!!
    -- this is to build a progressive demand and put in the column
    -- qty_demand_now to provide the next processing
    -- to compare the qty_pick to the qty_demand_now and generate
    -- lines that will enter in WIP without group code (exceding respect to demand)
    IF v_row_hed.trn_type = Pkg_Glb.C_TRN_TRN_CNS THEN
        --
        OPEN    C_SET_DEMAND(p_ref_plan);
        FETCH   C_SET_DEMAND BULK COLLECT INTO it_pck;
        CLOSE   C_SET_DEMAND;
        ---
        FOR i IN 1..it_pck.COUNT LOOP
            -- this cycles on every line in the VW_PREP_PICK_PLAN not only
            -- the lines that has qty_pick > 0 !!!!!!!! - only to not get confused
            --

            z   :=  it_pck(i);

            IF z.qty_demand_now IS NOT NULL THEN
                it_grp(z.group_code_in) := z.qty_demand_now;
            ELSE
                z.qty_demand_now    := it_grp(z.group_code_in);
            END IF;
            --
            it_grp(z.group_code_in) :=  it_grp(z.group_code_in) - z.qty_pick;
            it_grp(z.group_code_in) :=  GREATEST(
                                                    it_grp(z.group_code_in),
                                                    0
                                                );
            --
            it_pck(i)   :=  z;
        END LOOP;
        --
        Pkg_Iud.p_vw_prep_pick_plan_miud('U',it_pck);
        --
    END IF;
    ---
    -- for this kind of movement I do not let to add new lines if
    -- already there are lines for the same item code....
    -- because there is a danger they transfer mor times the same quantity
    IF v_row_hed.trn_type IN (
                                Pkg_Glb.C_TRN_TRN_CNS,
                                Pkg_Glb.C_TRN_ALC_ORD
                             )
    THEN
        FOR x IN C_CHECK_DETAIL (p_ref_plan) LOOP
            v_idx   :=  Pkg_Lib.f_str_idx(  p_par1      =>  x.item_code,
                                            p_par2      =>  x.oper_code_item,
                                            p_par3      =>  x.size_code,
                                            p_par4      =>  x.colour_code
                                         );
            it_chk(v_idx)   :=  NULL;
        END LOOP;
    END IF;
    ---
    FOR x IN C_LINES(p_ref_plan)    LOOP

        v_idx   :=  Pkg_Lib.f_str_idx(  p_par1      =>  x.item_code,
                                        p_par2      =>  x.oper_code_item,
                                        p_par3      =>  x.size_code,
                                        p_par4      =>  x.colour_code
                                     );
        IF it_chk.EXISTS(v_idx) THEN P_Sen('X10',
         'Urmatoarele componente exista deja in plan, nu mai puteti sa puneti inca o data !!!',
          v_idx
        );END IF;

        v_row_det.ref_plan          :=  p_ref_plan;
        v_row_det.org_code          :=  x.org_code;
        v_row_det.item_code         :=  x.item_code;
        v_row_det.colour_code       :=  x.colour_code;
        v_row_det.size_code         :=  x.size_code;
        v_row_det.oper_code_item    :=  x.oper_code_item;
        v_row_det.whs_code_out      :=  x.whs_code_out;
        v_row_det.whs_code_in       :=  x.whs_code_in;
        v_row_det.season_code_out   :=  x.season_code_out;
        v_row_det.season_code_in    :=  x.season_code_in;
        v_row_det.group_code_out    :=  x.group_code_out;
        v_row_det.group_code_in     :=  x.group_code_in;
        v_row_det.order_code        :=  x.order_code;
        v_row_det.cost_center       :=  NULL;
        v_row_det.account_code      :=  NULL;
        v_row_det.uom               :=  x.puom;
        v_row_det.note              :=  NULL;
        v_row_det.qty_puom          :=  NULL;
        v_row_det.puom              :=  NULL;



        IF v_row_hed.trn_type = Pkg_Glb.C_TRN_TRN_CNS THEN
            IF x.group_code_out IS NOT NULL THEN
                -- in this case we have already allocated quantities
                v_row_det.qty                   :=  x.qty_pick;
                Pkg_Mov.p_trn_plan_detail_blo('I',v_row_det,'N');
                it(it.COUNT+1)                  :=  v_row_det;

            ELSIF x.qty_pick > x.qty_demand_now THEN
                IF x.qty_demand_now > 0 THEN
                    v_row_det.qty                   :=  x.qty_demand_now;
                    Pkg_Mov.p_trn_plan_detail_blo('I',v_row_det,'N');
                    it(it.COUNT+1)                  :=  v_row_det;
                END IF;
                --- for the exceding quantity has to be going into WIP without allocation
                v_row_det.qty                   :=  x.qty_pick - x.qty_demand_now;
                v_row_det.group_code_in         :=  NULL;

                v_idx := Pkg_Lib.f_str_idx(
                                           p_par1   =>  v_row_det.item_code     ,
                                           p_par2   =>  v_row_det.oper_code_item,
                                           p_par3   =>  v_row_det.size_code     ,
                                           p_par4   =>  v_row_det.colour_code   ,
                                           p_par5   =>  v_row_det.whs_code_out
                                          );
                IF it_acm.EXISTS(v_idx) THEN
                    it_acm(v_idx).qty   :=  it_acm(v_idx).qty + v_row_det.qty;
                ELSE
                    it_acm(v_idx)       :=  v_row_det;
                END IF;
            ELSE
                v_row_det.qty                   :=  x.qty_pick;
                Pkg_Mov.p_trn_plan_detail_blo('I',v_row_det,'N');
                it(it.COUNT+1)                  :=  v_row_det;
            END IF;
        ELSE
            v_row_det.qty                   :=  x.qty_pick;
            Pkg_Mov.p_trn_plan_detail_blo('I',v_row_det,'N');
            it(it.COUNT+1)                  :=  v_row_det;
        END IF;

    END LOOP;
    --
    -- append the regrouped quantities for a warhouse
    v_idx   :=  it_acm.FIRST;
    WHILE v_idx IS NOT NULL LOOP
        Pkg_Mov.p_trn_plan_detail_blo('I',it_acm(v_idx),'N');
        it(it.COUNT+1)  :=  it_acm(v_idx);
        v_idx   :=  it_acm.NEXT(v_idx);
    END LOOP;
    --
    Pkg_Err.p_raise_error_message();
    --
    Pkg_Iud.p_trn_plan_detail_miud('I',it);
    --
    DELETE FROM VW_TRANSFER_ORACLE;
    DELETE FROM VW_PREP_PICK_PLAN;

    COMMIT;

    IF it.COUNT = 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Nu s-a adugat nici o linie de plan'
                                    ||' !!!',
              p_err_detail        => v_row_hed.plan_code,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DELETE FROM VW_TRANSFER_ORACLE;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 22/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_prepare_pick_plan_1(p_ref_plan              INTEGER,
                                p_force_qty_pick_zero   VARCHAR2
                                )
----------------------------------------------------------------------------------
--  PURPOSE:
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR  C_BOM_GROUP(    p_selector      VARCHAR2,
                            p_org_code      VARCHAR2,
                            p_suppl_code    VARCHAR2,
                            p_oper_code     VARCHAR2,
                            p_item_code     VARCHAR2,
                            p_season_code   VARCHAR2

                       ) IS
                SELECT
                            g.item_code, g.size_code, g.colour_code, g.qta,
                            g.whs_supply, g.oper_code, g.start_size, g.end_size,
                            g.qta_demand, g.org_code, g.group_code, g.oper_code_item,
                            --
                            i.puom, i.description,
                            r.whs_cons,
                            w.season_code,
                            c.description  description_colour,
                            o.oper_seq
                -------------------------------------------------
                FROM        VW_PREP_GROUP_CODE  t
                INNER JOIN  BOM_GROUP       g
                                    ON  g.group_code    =   t.group_code
                INNER JOIN  VW_PREP_ITEM_CODE   a
                                    ON  a.item_code     =   g.item_code
                                    AND a.org_code      =   g.org_code
                INNER JOIN  WORK_GROUP      w
                                    ON  w.group_code    =   g.group_code
                INNER JOIN  GROUP_ROUTING   r
                                    ON  r.group_code    =   g.group_code
                                    AND r.oper_code     =   g.oper_code
                INNER JOIN  ITEM            i
                                    ON  g.org_code      =   i.org_code
                                    AND g.item_code     =   i.item_code
                INNER JOIN  WAREHOUSE       m
                                    ON  m.whs_code      =   r.whs_cons
                LEFT JOIN   COLOUR           c
                                    ON  c.colour_code   =   g.colour_code
                                    AND c.org_code      =   g.org_code
                INNER JOIN  OPERATION       o
                                    ON  o.oper_code     =   r.oper_code
                -------------------------------------------------
                WHERE
                                p_selector      =   'A'
                            AND g.org_code      =   p_org_code
                            AND m.org_code      =   p_suppl_code
                            AND w.season_code   =   p_season_code
                            AND g.oper_code     IN
                                    (SELECT txt01
                                    FROM TABLE(Pkg_Lib.F_Sql_Inlist(NVL(p_oper_code,g.oper_code))))
                ----------------
                UNION ALL
                ----------------
                SELECT
                            g.item_code, g.size_code, g.colour_code, g.qta,
                            g.whs_supply, g.oper_code, g.start_size, g.end_size,
                            g.qta_demand, g.org_code, g.group_code, g.oper_code_item,
                            --
                            i.puom, i.description,
                            r.whs_cons,
                            w.season_code,
                            c.description  description_colour,
                            o.oper_seq
                -------------------------------------------------
                FROM        VW_PREP_GROUP_CODE  t
                INNER JOIN  BOM_GROUP       g
                                    ON  g.group_code    =   t.group_code
                INNER JOIN  WORK_GROUP      w
                                    ON  w.group_code    =   g.group_code
                INNER JOIN  GROUP_ROUTING   r
                                    ON  r.group_code    =   g.group_code
                                    AND r.oper_code     =   g.oper_code
                INNER JOIN  ITEM            i
                                    ON  g.org_code      =   i.org_code
                                    AND g.item_code     =   i.item_code
                INNER JOIN  WAREHOUSE       m
                                    ON  m.whs_code      =   r.whs_cons
                LEFT JOIN   COLOUR           c
                                    ON  c.colour_code   =   g.colour_code
                                    AND c.org_code      =   g.org_code
                INNER JOIN  OPERATION       o
                                    ON  o.oper_code     =   r.oper_code
                -------------------------------------------------
                WHERE
                                p_selector      =   'B'
                            AND g.org_code      =   p_org_code
                            AND m.org_code      =   p_suppl_code
                            AND w.season_code   =   p_season_code
                            AND g.oper_code     IN
                                    (SELECT txt01
                                    FROM TABLE(Pkg_Lib.F_Sql_Inlist(NVL(p_oper_code,g.oper_code))))
                ------------------------------------
                ORDER BY oper_seq,item_code,oper_code_item,colour_code,size_code,
                         group_code
                ;

    CURSOR  C_SEMIPROCESSED(    p_selector      VARCHAR2,
                                p_org_code      VARCHAR2
                           ) IS
                SELECT
                        s.org_code,s.item_code,s.oper_code_item,s.colour_code,
                        s.size_code,s.whs_code,s.season_code,s.order_code,
                        s.group_code,s.qty,
                        i.description, i.puom
                FROM        VW_PREP_GROUP_CODE      t
                INNER JOIN  STOC_ONLINE             s
                                ON  s.group_code    =   t.group_code
                INNER JOIN  VW_PREP_ITEM_CODE       a
                                ON  a.item_code     =   s.item_code
                                AND a.org_code      =   s.org_code
                INNER JOIN  ITEM            i
                                ON  i.org_code      =   s.org_code
                                AND i.item_code     =   s.item_code
                INNER JOIN  WAREHOUSE       w
                                ON w.whs_code       =   s.whs_code
                WHERE       p_selector      =       'A'
                        AND s.org_code      =       p_org_code
                        AND w.category_code IN (
                                                    Pkg_Glb.C_WHS_MPC,
                                                    Pkg_Glb.C_WHS_MPP
                                               )
                -------------
                UNION ALL
                -------------
                SELECT
                        s.org_code,s.item_code,s.oper_code_item,s.colour_code,
                        s.size_code,s.whs_code,s.season_code,s.order_code,
                        s.group_code,s.qty,
                        i.description, i.puom
                FROM        VW_PREP_GROUP_CODE      t
                INNER JOIN  STOC_ONLINE             s
                                ON  s.group_code    =   t.group_code
                INNER JOIN  ITEM            i
                                ON  i.org_code      =   s.org_code
                                AND i.item_code     =   s.item_code
                INNER JOIN  WAREHOUSE       w
                                ON w.whs_code       =   s.whs_code
                WHERE       p_selector      =       'B'
                        AND s.org_code      =       p_org_code
                        AND w.category_code IN (
                                                    Pkg_Glb.C_WHS_MPC,
                                                    Pkg_Glb.C_WHS_MPP
                                               )
                ----------
                ORDER BY order_code,size_code
                ;

    cursor C_SEASON (p_org_code VARCHAr2)
                IS
                SELECT  *
                FROM    WORK_SEASON
                WHERE   org_code    =   p_org_code
                    AND flag_active =   'Y'
                ORDER BY season_code
                ;

    v_row_tpl               TRN_PLAN_HEADER%ROWTYPE;

    it_flx                  Pkg_Glb.type_dim_10;
    it_sto                  Pkg_Glb.type_dim_10;
    it_rout                 Pkg_Mov.type_rout3;
    it_oper                 Pkg_Glb.typ_varchar_varchar;
    it_chk_stc              Pkg_Glb.typ_varchar_varchar;

    TYPE type_whs           IS TABLE OF WAREHOUSE%ROWTYPE   INDEX BY   Pkg_Glb.type_index ;
    it_whs                  type_whs;
    it_sea                  Pkg_Rtype.tas_work_season;
    ix_sea                  VARCHAR2(50);
    TYPE type_it            IS TABLE OF Pkg_Rtype.ta_vw_prep_pick_plan  INDEX BY Pkg_Glb.type_index ;
    it                      type_it;
    it2                     type_it;

    v_idx                   Pkg_Glb.type_index ;
    v_idx_whs               Pkg_Glb.type_index ;

    v_row                   VW_PREP_PICK_PLAN%ROWTYPE;
    v_row_ini               VW_PREP_PICK_PLAN%ROWTYPE;
    v_row_tot               VW_PREP_PICK_PLAN%ROWTYPE;
    v_qty_demand            NUMBER;
    v_qty_demand_now        NUMBER;
    v_qty_stock_alloc       NUMBER;
    v_qty_stock_free        NUMBER;
    v_qty_stock_free_ini    NUMBER;
    v_count                 NUMBER;
    v_qty_pick              NUMBER;
    v_seq_group             INTEGER;
    v_row_grp               VW_PREP_GROUP_CODE%ROWTYPE;
    v_row_itm               VW_PREP_ITEM_CODE%ROWTYPE;
    v_selector              VARCHAR2(1)     ;

    C_WHS_WIP               VARCHAR2(32000) :=  'WIP';
    C_SEGMENT_CODE          VARCHAR2(32000) :=  'VW_PREP_PICK_PLAN';
    C_SEGMENT_CODE2         VARCHAR2(32000) :=  'VW_PREP_GROUP_CODE';
    C_SEGMENT_CODE3         VARCHAR2(32000) :=  'VW_PREP_ITEM_CODE';


BEGIN
    Pkg_Err.p_reset_error_message();
    --
    v_row_tpl.idriga    :=  p_ref_plan;
    IF Pkg_Get.f_get_trn_plan_header(v_row_tpl) THEN NULL; END IF;
    ---
    -- if there were no work group specified get all work groups in status L (released)
    DELETE FROM VW_PREP_GROUP_CODE;
    IF v_row_tpl.group_code IS NULL THEN
        FOR x IN C_ACTIVE_ORDERS(
                                    p_org_code   =>     v_row_tpl.org_code  ,
                                    p_suppl_code =>     v_row_tpl.suppl_code
                                )
        LOOP
            v_row_grp.group_code    :=  x.group_code;
            v_row_grp.segment_code  :=  C_SEGMENT_CODE2;
            INSERT INTO VW_PREP_GROUP_CODE VALUES v_row_grp;
        END LOOP;
    ELSE
        FOR x IN Pkg_Cur.C_SQL_INLIST(v_row_tpl.group_code) LOOP
            v_row_grp.group_code    :=  x.txt01;
            v_row_grp.segment_code  :=  C_SEGMENT_CODE2;
            INSERT INTO VW_PREP_GROUP_CODE VALUES v_row_grp;
        END LOOP;
    END IF;

    DELETE FROM VW_PREP_ITEM_CODE;
    IF v_row_tpl.item_code IS NULL THEN
        v_selector  :=  'B';
    ELSE
        v_selector  :=  'A';
        FOR x IN Pkg_Cur.C_SQL_INLIST(v_row_tpl.item_code) LOOP
            v_row_itm.item_code     :=  x.txt01;
            v_row_itm.org_code      :=  v_row_tpl.org_code;
            v_row_itm.segment_code  :=  C_SEGMENT_CODE3;
            INSERT INTO VW_PREP_ITEM_CODE VALUES v_row_itm;
        END LOOP;
    END IF;

    -- load the the flux of allocated
    FOR x IN Pkg_Mov.C_ALLOCATED LOOP
        Pkg_Lib.p_load_mdim(it_flx          ,
                            x.qty           ,
                            x.group_code    ,
                            x.item_code     ,
                            x.org_code      ,
                            x.oper_code_item,
                            x.size_code     ,
                            x.colour_code
                           );
    END LOOP;

    -- load the warehouses
    FOR x IN Pkg_Nomenc.C_WAREHOUSE LOOP
        it_whs(x.whs_code)  :=  x;
    END LOOP;

    -- load work seasons 
    FOR x IN C_SEASON(v_row_tpl.org_code)
    LOOP
        it_sea(x.season_code)   :=  x;
    END LOOP;
    
    -- cycle on the bill of material lines for work group
    FOR x IN C_BOM_GROUP(   p_selector      =>  v_selector              ,
                            p_org_code      =>  v_row_tpl.org_code      ,
                            p_suppl_code    =>  v_row_tpl.suppl_code    ,
                            p_oper_code     =>  v_row_tpl.oper_code     ,
                            p_item_code     =>  v_row_tpl.item_code     ,
                            p_season_code   =>  v_row_tpl.season_code
                        )
    LOOP
        v_row.org_code              :=  x.org_code;
        v_row.group_code_in         :=  x.group_code;
        v_row.item_code             :=  x.item_code;
        v_row.oper_code_item        :=  x.oper_code_item;
        v_row.colour_code           :=  x.colour_code;
        v_row.description_colour    :=  x.description_colour;
        v_row.size_code             :=  x.size_code;
        v_row.start_size            :=  x.start_size;
        v_row.end_size              :=  x.end_size;
        v_row.season_code_in        :=  x.season_code;
        v_row.season_code_out       :=  x.season_code;
        v_row.puom                  :=  x.puom;


        v_row.whs_code_out          :=  NVL(v_row_tpl.whs_code, x.whs_supply);

        -- establish the destination warehouse
        CASE
            WHEN    v_row_tpl.trn_type IN   (
                                                Pkg_Glb.C_TRN_TRN_CNS,
                                                Pkg_Glb.C_TRN_SHP_CTL
                                            ) THEN
                    v_row.whs_code_in           :=  x.whs_cons;
            WHEN    v_row_tpl.trn_type IN   (
                                                Pkg_Glb.C_TRN_ALC_ORD
                                            ) THEN
                    v_row.whs_code_in           :=  v_row.whs_code_out;
        END CASE;

        v_row.oper_code             :=  x.oper_code;
        v_row.description           :=  x.description;
        v_row.ref_plan              :=  v_row_tpl.idriga;

        v_row.qty_demand_ini        :=  x.qta_demand;
        v_row.qty_demand_now        :=  0;
        v_row.qty_stock             :=  0;
        v_row.qty_pick              :=  0;


        v_row.qty_demand_now        :=  Pkg_Lib.f_get_mdim
                                            (it_flx,
                                             v_row.group_code_in    ,
                                             v_row.item_code        ,
                                             v_row.org_code         ,
                                             v_row.oper_code_item   ,
                                             v_row.size_code        ,
                                             v_row.colour_code
                                             );
        v_row.qty_demand_now        :=   NVL(v_row.qty_demand_now,0);
        v_row.qty_demand_now        :=   GREATEST(v_row.qty_demand_now,0);
        v_row.qty_demand_now        :=   v_row.qty_demand_ini
                                         - v_row.qty_demand_now;
        v_row.qty_demand_now        :=   GREATEST(v_row.qty_demand_now,0);

        -- we are making a partition for the same:
            -- item_code
            -- oper_code_item
            -- size_code
            -- colour_code

        v_idx       :=  Pkg_Lib.f_str_idx(  p_par1    =>  x.oper_seq,
                                            p_par2    =>  v_row.item_code,
                                            p_par3    =>  v_row.oper_code_item,
                                            p_par4    =>  v_row.size_code,
                                            p_par5    =>  v_row.colour_code
                                         );

        IF it.EXISTS(v_idx) THEN
            it(v_idx)(it(v_idx).COUNT+1)    :=  v_row;
        ELSE
            it(v_idx)(1)                    :=  v_row;
        END IF;

    END LOOP;
    --
    --

    v_idx   :=  it.FIRST;
    WHILE v_idx IS NOT NULL LOOP

        -- load the stocs for item if it already was not loaded
        -- for this item
        IF NOT it_chk_stc.EXISTS(it(v_idx)(1).item_code) THEN -- this is only a performance improving thing
            Pkg_Mov.p_item_stoc
                ( it_stoc        =>  it_sto,
                  p_item         =>  it(v_idx)(1).item_code,
                  p_org_code     =>  it(v_idx)(1).org_code
                );
        END IF;
        it_chk_stc(it(v_idx)(1).item_code) := NULL;
        ---

        --to acumuleit the demand that remains from every workorder line
        v_qty_demand_now    :=  0;
        ---
        -- cycle for evey line in the work order bill of material
        FOR i IN 1..it(v_idx).COUNT LOOP

                v_row   := it(v_idx)(i);

                v_qty_stock_alloc   :=  Pkg_Lib.f_get_mdim
                                        (   p_it    =>  it_sto,
                                            p_1     =>  v_row.whs_code_out,
                                            p_2     =>  v_row.season_code_in,
                                            p_3     =>  v_row.size_code,
                                            p_4     =>  v_row.colour_code,
                                            p_5     =>  v_row.oper_code_item,
                                            p_6     =>  v_row.group_code_in,
                                            p_7     =>  NULL -- order code
                                        );


                v_qty_stock_free   :=  Pkg_Lib.f_get_mdim
                                        (   p_it    =>  it_sto,
                                            p_1     =>  v_row.whs_code_out,
                                            p_2     =>  v_row.season_code_in,
                                            p_3     =>  v_row.size_code,
                                            p_4     =>  v_row.colour_code,
                                            p_5     =>  v_row.oper_code_item,
                                            p_6     =>  NULL, -- group code
                                            p_7     =>  NULL -- order code
                                        );

                IF i= 1 THEN
                    v_qty_stock_free_ini    :=  v_qty_stock_free;
                END IF;

                ---
                -- for transfer to wip check if there is allocated material on the
                -- default supply warehouse
                -- if it is it is created a picking line
                IF      v_row_tpl.trn_type IN (
                                                Pkg_Glb.C_TRN_TRN_CNS,
                                                Pkg_Glb.C_TRN_SHP_CTL
                                              )
                    AND v_qty_stock_alloc > 0
                THEN
                    v_row.qty_stock     :=  v_qty_stock_alloc;
                    v_row.qty_pick      :=  LEAST(v_row.qty_demand_now,v_row.qty_stock);

                    -- there is a parameter p_force_qty_pick_zero
                    -- for Y we have to propouse 0 quantity for picking
                    IF p_force_qty_pick_zero = 'Y' THEN
                        v_row.qty_pick      :=  0;
                    END IF;

                    v_row.group_code_out:=  v_row.group_code_in;

                    --
                    IF it2.EXISTS(v_idx) THEN
                        it2(v_idx)(it2(v_idx).COUNT+1)  :=  v_row;
                    ELSE
                        it2(v_idx)(1)                   :=  v_row;
                    END IF;
                    -- this is to clear the two columns and will be set at
                    -- the end of the procedures
                    -- it is related to the problem to put the demand to only
                    -- the first line if there are more warehouses for a work group
                    it2(v_idx)(it2(v_idx).COUNT).qty_demand_ini :=  NULL;
                    it2(v_idx)(it2(v_idx).COUNT).qty_demand_now :=  NULL;
                    --
                END IF; -- end with the allocated quantity line for the default supply warehouse


                -- Not allocated stoc for the default supply warehouse
                v_row.qty_stock     :=  v_qty_stock_free;
                v_row.qty_pick      :=  0;

                v_row.group_code_out:=  NULL;
                --
                -- shouw this line only for this item there is stock in this default
                -- warehouse
                IF  v_row_tpl.trn_type IN (
                                                Pkg_Glb.C_TRN_ALC_ORD
                                         )
                    AND v_qty_stock_free_ini <= 0
                THEN
                        NULL;
                        -- do not create this line if we do not have not allocated quantities
                ELSE
                    IF it2.EXISTS(v_idx) THEN
                        it2(v_idx)(it2(v_idx).COUNT+1)  :=  v_row;
                    ELSE
                        it2(v_idx)(1)                   :=  v_row;
                    END IF;
                    ----
                    it2(v_idx)(it2(v_idx).COUNT).qty_demand_ini :=  NULL;
                    it2(v_idx)(it2(v_idx).COUNT).qty_demand_now :=  NULL;
                    --
                END IF;


                -- for this intersection of item + workorder we
                -- are looking for other stock warehouses that may have stocks for
                -- this item so we can generate more lines for a single
                -- combination of item + workorder

                IF       v_row_tpl.trn_type IN (
                                                Pkg_Glb.C_TRN_TRN_CNS,
                                                Pkg_Glb.C_TRN_SHP_CTL
                                               )
                THEN

                    v_idx_whs   :=  it_whs.FIRST;
                    WHILE v_idx_whs IS NOT NULL LOOP
                        -- loop on seasons 
                        ix_sea := it_sea.first;
                        WHILE ix_sea IS NOT NULL LOOP
                        -- we have to se only for the other warehouses not the current in v_row.whs_code_out

                            IF  (       v_idx_whs <> v_row.whs_code_out
                                    AND it_whs(v_idx_whs).category_code IN ( Pkg_Glb.C_WHS_MPC,Pkg_Glb.C_WHS_MPP )
                                )
                                OR
                                (       v_row.season_code_in <> ix_sea
                                    and v_idx_whs = v_row.whs_code_out
                                )
                            THEN
    
                                v_qty_stock_alloc   :=  Pkg_Lib.f_get_mdim
                                                        (   p_it    =>  it_sto,
                                                            p_1     =>  v_idx_whs,
                                                            p_2     =>  ix_sea,
                                                            p_3     =>  v_row.size_code,
                                                            p_4     =>  v_row.colour_code,
                                                            p_5     =>  v_row.oper_code_item,
                                                            p_6     =>  v_row.group_code_in,
                                                            p_7     =>  NULL -- order code
                                                        );
    
    
                                 v_qty_stock_free   :=  Pkg_Lib.f_get_mdim
                                                         (   p_it    =>  it_sto,
                                                             p_1     =>  v_idx_whs,
                                                             p_2     =>  ix_sea,
                                                             p_3     =>  v_row.size_code,
                                                             p_4     =>  v_row.colour_code,
                                                             p_5     =>  v_row.oper_code_item,
                                                             p_6     =>  NULL, -- group code
                                                             p_7     =>  NULL  -- order code
                                                         );
    
                                  ---
                                  IF    v_qty_stock_alloc > 0
                                  THEN
    
                                      v_row.qty_stock     :=  v_qty_stock_alloc;
                                      v_row.qty_pick      :=  0;
    
    
                                      v_row.group_code_out:=  v_row.group_code_in;
                                      --
                                      IF it2.EXISTS(v_idx) THEN
                                          it2(v_idx)(it2(v_idx).COUNT+1)  :=  v_row;
                                      ELSE
                                          it2(v_idx)(1)                   :=  v_row;
                                      END IF;
                                      -- set the warehouse to that in the cycle
                                      it2(v_idx)(it2(v_idx).COUNT).whs_code_out     :=  v_idx_whs;
                                      it2(v_idx)(it2(v_idx).COUNT).season_code_out  :=  ix_sea;
                                      it2(v_idx)(it2(v_idx).COUNT).qty_demand_ini :=  NULL;
                                      it2(v_idx)(it2(v_idx).COUNT).qty_demand_now :=  NULL;
    
                                  END IF;
                                  --
                                  IF  v_qty_stock_free > 0 THEN
    
                                      v_row.qty_stock     :=  v_qty_stock_free;
                                      v_row.qty_pick      :=  0;
    
                                      v_row.group_code_out:=    NULL;
                                      --
                                      IF it2.EXISTS(v_idx) THEN
                                          it2(v_idx)(it2(v_idx).COUNT+1)  :=  v_row;
                                      ELSE
                                          it2(v_idx)(1)                   :=  v_row;
                                      END IF;
                                      -- set the warehouse to that in the cycle
                                      it2(v_idx)(it2(v_idx).COUNT).whs_code_out     :=  v_idx_whs;
                                      it2(v_idx)(it2(v_idx).COUNT).season_code_out  :=  ix_sea;
                                      it2(v_idx)(it2(v_idx).COUNT).qty_demand_ini :=  NULL;
                                      it2(v_idx)(it2(v_idx).COUNT).qty_demand_now :=  NULL;
                                      --
                                  END IF;
                            END IF;

                            ix_sea  :=  it_sea.next(ix_sea);
                            
                        END LOOP; -- loop on seasons 
                        
                        v_idx_whs   :=  it_whs.NEXT(v_idx_whs);

                    END LOOP; -- loop on warehouses 
                    
                END IF; -- close if for TRN_CNS

                -- for the same workorder set the in the case if we have more warehouses
                -- to take quantity from , we should set the
                -- qty_demand_ini and qty_demand_now to NULL apart from the first line in the
                -- set for that workorder

                IF it2.EXISTS(v_idx) THEN
                    FOR a IN 1..it2(v_idx).COUNT LOOP
                        IF it2(v_idx)(a).group_code_in  = v_row.group_code_in THEN
                            it2(v_idx)(a).qty_demand_ini :=  v_row.qty_demand_ini;
                            it2(v_idx)(a).qty_demand_now :=  v_row.qty_demand_now;
                            EXIT ;
                        END IF;
                    END LOOP;
                END IF;
                ----- to acummuleit the demnad that has left for this item + work order
                v_qty_demand_now    :=  v_qty_demand_now    +   v_row.qty_demand_now;

        END LOOP; -- this is the loop for work groups for one item
        -- insert a total line
        -- the total line is for a partition of
            -- item_code,
            -- oper_code_item,
            -- colour_code,
            -- size_code
        IF it2.EXISTS(v_idx) THEN
            it2(v_idx)(it2(v_idx).COUNT+1).qty_demand_now  :=  v_qty_demand_now;
        END IF;
        --
        v_idx   :=  it.NEXT(v_idx);
    END LOOP; -- this is the loop on the partition of items


    DELETE FROM VW_PREP_PICK_PLAN;
    ----


    v_idx       :=  it2.FIRST;
    v_count     :=  0;
    v_seq_group :=  0;

    WHILE v_idx IS NOT NULL LOOP

        v_row_tot.qty_pick          :=  0;
        v_row_tot.qty_demand_ini    :=  0;
        v_seq_group                 :=  v_seq_group + 1;

        FOR i IN 1..it2(v_idx).COUNT LOOP

            v_count                 :=  v_count + 1;
            it2(v_idx)(i).idriga    :=  v_count;

            v_row_tot.qty_pick          :=  v_row_tot.qty_pick
                                            + NVL(it2(v_idx)(i).qty_pick,0);
            v_row_tot.qty_demand_ini    :=  v_row_tot.qty_demand_ini
                                            + NVL(it2(v_idx)(i).qty_demand_ini,0);

            it2(v_idx)(i).seq_no            :=  it2(v_idx)(i).idriga;
            it2(v_idx)(i).seq_no2           :=  i;
            it2(v_idx)(i).seq_group         :=  v_seq_group;

            it2(v_idx)(i).flag_total_line   :=  'N';
            it2(v_idx)(i).flag_dirty        :=  'N';

            it2(v_idx)(i).segment_code      :=  C_SEGMENT_CODE;
            it2(v_idx)(i).ref_plan          :=  p_ref_plan;

        END LOOP;
        -- for the last line in the group
        -- that is the total line
        -- put the totals
        it2(v_idx)(it2(v_idx).COUNT).flag_total_line    :=  'Y';
        it2(v_idx)(it2(v_idx).COUNT).qty_pick           :=  v_row_tot.qty_pick;
        it2(v_idx)(it2(v_idx).COUNT).qty_demand_ini     :=  v_row_tot.qty_demand_ini;

        -- put some visual partition separatrs
        it2(v_idx)(it2(v_idx).COUNT).org_code           :=  '============';
        it2(v_idx)(it2(v_idx).COUNT).item_code          :=  it2(v_idx)(it2(v_idx).COUNT-1).item_code;
        it2(v_idx)(it2(v_idx).COUNT).oper_code_item     :=  '===========================';
        it2(v_idx)(it2(v_idx).COUNT).description        :=  '===========================';
        it2(v_idx)(it2(v_idx).COUNT).description_colour :=  '===========================';
        it2(v_idx)(it2(v_idx).COUNT).org_code           :=  '============';
        it2(v_idx)(it2(v_idx).COUNT).colour_code        :=  '============';
        it2(v_idx)(it2(v_idx).COUNT).puom               :=  '============';
        it2(v_idx)(it2(v_idx).COUNT).size_code          :=  '============';
        it2(v_idx)(it2(v_idx).COUNT).oper_code          :=  '============';
        it2(v_idx)(it2(v_idx).COUNT).group_code_in      :=  '===========================';
        it2(v_idx)(it2(v_idx).COUNT).whs_code_out       :=  '============';


        it2(v_idx)(it2(v_idx).COUNT).group_code_out     :=  'TOTAL==================';

        -- insert into the view
        Pkg_Iud.p_vw_prep_pick_plan_miud('I',it2(v_idx));

        v_idx   :=  it2.NEXT(v_idx);
    END LOOP;


    --/////////////////////////////////////////////////////////////////////////////////////////////////
    --- manage the semiprocessed items only for transfer to wip

    IF       v_row_tpl.trn_type IN (
                                    Pkg_Glb.C_TRN_TRN_CNS
                                   )
    THEN

         it2.DELETE;

         FOR x IN  C_SEMIPROCESSED(  p_selector      =>  v_selector          ,
                                     p_org_code      =>  v_row_tpl.org_code
                                  )
         LOOP
             v_idx   :=  x.group_code;

             v_row   :=  v_row_ini;

             v_row.org_code              :=  x.org_code;
             v_row.group_code_in         :=  x.group_code;
             v_row.item_code             :=  x.item_code;
             v_row.oper_code_item        :=  x.oper_code_item;
             v_row.colour_code           :=  x.colour_code;
             v_row.size_code             :=  x.size_code;
             v_row.start_size            :=  NULL;
             v_row.end_size              :=  NULL;
             v_row.season_code_in        :=  x.season_code;
             v_row.puom                  :=  x.puom;
             v_row.whs_code_out          :=  x.whs_code;
             v_row.whs_code_in           :=  C_WHS_WIP ;
             v_row.oper_code             :=  NULL;
             v_row.description           :=  x.description;
             v_row.group_code_out        :=  x.group_code;
             v_row.season_code_out       :=  x.season_code;
             v_row.flag_total_line       :=  NULL;
             v_row.description_colour    :=  NULL;
             v_row.flag_dirty            :=  NULL;
             v_row.order_code            :=  x.order_code;
             v_row.idriga                :=  NULL;
             v_row.dcn                   :=  NULL;
             v_row.ref_plan              :=  NULL;
             v_row.seq_no                :=  NULL;
             v_row.seq_no2               :=  NULL;
             v_row.seq_group             :=  NULL;
             v_row.qty_demand_ini        :=  0;
             v_row.qty_demand_now        :=  0;
             v_row.qty_stock             :=  x.qty;
             v_row.qty_pick              :=  0;
             v_row.qty_free              :=  0;
             v_row.qty_apick             :=  0;

             IF it2.EXISTS(v_idx) THEN
                 it2(v_idx)(it2(v_idx).COUNT + 1)   :=  v_row;
             ELSE
                 it2(v_idx)(1)               :=  v_row;
             END IF;
         END LOOP;
         ---

         v_idx       :=  it2.FIRST;
         WHILE v_idx IS NOT NULL LOOP
             v_row_tot.qty_stock    :=  0;
             v_seq_group            :=  v_seq_group + 1;

             FOR i IN 1..it2(v_idx).COUNT + 1 LOOP -- I put one more to create a last total line !!!!!!!!!!

                 v_count                 :=  v_count + 1;
                 it2(v_idx)(i).idriga    :=  v_count;

                 v_row_tot.qty_stock           :=  v_row_tot.qty_stock
                                                   + NVL(it2(v_idx)(i).qty_stock,0);

                 it2(v_idx)(i).seq_no            :=  it2(v_idx)(i).idriga;
                 it2(v_idx)(i).seq_no2           :=  i;
                 it2(v_idx)(i).seq_group         :=  v_seq_group;

                 it2(v_idx)(i).flag_total_line   :=  'N';
                 it2(v_idx)(i).flag_dirty        :=  'S';

                 it2(v_idx)(i).segment_code      :=  C_SEGMENT_CODE;
                 it2(v_idx)(i).ref_plan          :=  p_ref_plan;

             END LOOP;
             -- for the last line in the group
             -- that is the total line

             -- put the totals
             -- for semiprocessed do not put total lines
             it2(v_idx)(it2(v_idx).COUNT).flag_total_line    :=  'Y';
             it2(v_idx)(it2(v_idx).COUNT).qty_pick           :=  0;
             it2(v_idx)(it2(v_idx).COUNT).qty_demand_ini     :=  0;
             it2(v_idx)(it2(v_idx).COUNT).qty_stock          :=  v_row_tot.qty_stock;

             -- put some visual partition separatrs
             it2(v_idx)(it2(v_idx).COUNT).org_code           :=  '============';
             it2(v_idx)(it2(v_idx).COUNT).item_code          :=  it2(v_idx)(it2(v_idx).COUNT-1).item_code;
             it2(v_idx)(it2(v_idx).COUNT).oper_code_item     :=  '===========================';
             it2(v_idx)(it2(v_idx).COUNT).description        :=  '===========================';
             it2(v_idx)(it2(v_idx).COUNT).description_colour :=  '===========================';
             it2(v_idx)(it2(v_idx).COUNT).org_code           :=  '============';
             it2(v_idx)(it2(v_idx).COUNT).colour_code        :=  '============';
             it2(v_idx)(it2(v_idx).COUNT).puom               :=  '============';
             it2(v_idx)(it2(v_idx).COUNT).size_code          :=  '============';
             it2(v_idx)(it2(v_idx).COUNT).oper_code          :=  '============';
             it2(v_idx)(it2(v_idx).COUNT).group_code_in      :=  '===========================';
             it2(v_idx)(it2(v_idx).COUNT).whs_code_out       :=  '============';


             it2(v_idx)(it2(v_idx).COUNT).group_code_out     :=  'TOTAL==================';

             -- insert into the view
             Pkg_Iud.p_vw_prep_pick_plan_miud('I',it2(v_idx));

             v_idx   :=  it2.NEXT(v_idx);
         END LOOP;
    END IF;
    --
    Pkg_Err.p_raise_error_message();
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 28/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_vw_prep_pick_plan_iud(p_tip VARCHAR2, p_row VW_PREP_PICK_PLAN%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row  when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    CURSOR  C_LINES(p_seq_group INTEGER) IS
            SELECT  *
            FROM    VW_PREP_PICK_PLAN
            WHERE       seq_group   =   p_seq_group
            ORDER BY seq_no2
            ;

    it_stc              Pkg_Glb.typ_number_varchar;
    v_idx_stc           Pkg_Glb.type_index;
    v_qty_demand_now    NUMBER;
    v_qty_pick          NUMBER;

    v_row               VW_PREP_PICK_PLAN%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row               :=  p_row;

    IF NVL(p_row.qty_pick,-1) < 0 THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00',
              p_err_header        => 'Campul cu cantitatea propusa'
                                    ||' trebuie sa fie completata si  poate fi'
                                    ||' zero sau o valoare pozitiva !!!',
              p_err_detail        => NULL,
              p_flag_immediate    => 'Y'
         );
    END IF;
    --

    Pkg_Iud.p_vw_prep_pick_plan_iud('U', v_row);
    --

    v_qty_pick  :=  0;
    FOR x IN C_LINES(v_row.seq_group) LOOP

        v_idx_stc   :=  Pkg_Lib.f_str_idx(
                                            p_par1  =>  x.whs_code_out,
                                            p_par2  =>  x.group_code_out,
                                            p_par3  =>  x.season_code_out
                                            );

        IF NOT it_stc.EXISTS(v_idx_stc) THEN
            it_stc(v_idx_stc)   :=  x.qty_stock;
        END IF;

        -- for semiprocessed items do NOT modify the stock
        IF x.flag_dirty = 'N' THEN
            x.qty_stock         :=  it_stc(v_idx_stc);
        END IF;
        -- rearange the stoc and the demand
        it_stc(v_idx_stc)   :=  it_stc(v_idx_stc)   - x.qty_pick;

        IF x.flag_total_line =   'N' THEN
             v_qty_pick  :=  v_qty_pick  +   x.qty_pick;
        ELSE
            x.qty_pick          :=  v_qty_pick;
        END IF;

        Pkg_Iud.p_vw_prep_pick_plan_iud('U', x);

    END LOOP;

    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 30/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_check_date_legal    (   p_date_legal DATE, p_note VARCHAR2 DEFAULT NULL)
----------------------------------------------------------------------------------
--  PURPOSE:    verify if the date is OK :
--                  =>  exists in the CALENDAR
--                  =>  is not from the FUTURE
--                  =>  the ACCOUNTING month is not closed
--  PREREQ:
--
--  INPUT:      DATE_LEGAL  =   date to check
--              NOTE        =   context - for error message
----------------------------------------------------------------------------------
IS
    CURSOR  C_LINES(p_date_legal DATE) IS
            SELECT  *
            FROM    CALENDAR
            WHERE   calendar_day   =   p_date_legal
            ;

    v_row           C_LINES%ROWTYPE;
    v_row_per       AC_PERIOD%ROWTYPE;
    C_ERR_CODE_1    VARCHAR2(100)   :=  'CHK_DATE_LEGAL_1';
    C_ERR_CODE_2    VARCHAR2(100)   :=  'CHK_DATE_LEGAL_2';
    C_ERR_CODE_3    VARCHAR2(100)   :=  'CHK_DATE_LEGAL_3';

BEGIN

    -- date legal must be a value
    IF p_date_legal IS NULL THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => C_ERR_CODE_1,
              p_err_header        => 'Nu ati precizat data competentei pentru '
                                    || 'inregistrarea documentului !!!',
              p_err_detail        => p_note,
              p_flag_immediate    => 'N'
         );
    ELSE

        -- verify if the accounting period is closed
        v_row_per.period_type   :=  'MONTH';
        v_row_per.period_code   :=  TO_CHAR(p_date_legal, 'YYYYMM');
        Pkg_Get2.p_get_ac_period_2(v_row_per);
        IF v_row_per.status = 'C' THEN
            Pkg_Err.p_rae('Luna '||v_row_per.description||' este inchisa! Nu se mai pot efectua tranzactii de magazie!');
        END IF;

       OPEN     C_LINES(p_date_legal);
       FETCH    C_LINES INTO v_row;
       IF C_LINES%NOTFOUND THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => C_ERR_CODE_2,
                  p_err_header        => 'Data competentei precizate nu exista '
                                        || 'definita in tabela calendar din sistem !!!',
                  p_err_detail        => p_note,
                  p_flag_immediate    => 'N'
             );
       END IF;
       CLOSE    C_LINES;
       --
       IF p_date_legal > TRUNC(SYSDATE) THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => C_ERR_CODE_3,
                  p_err_header        => 'Data competentei precizate nu poate '
                                        || 'sa fie mai mare decat data curenta !!!',
                  p_err_detail        => p_note,
                  p_flag_immediate    => 'N'
             );
       END IF;
    END IF;
--    EXCEPTION
--    WHEN OTHERS THEN
--        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/********************************************************************************************
    DDL:    04/04/2008 z Create
/********************************************************************************************/
PROCEDURE p_whs_trn_storno     (
                                    p_ref_trn           NUMBER,
                                    p_flag_commit       BOOLEAN
                                )
---------------------------------------------------------------------------------------------
--  PURPOSE:    Cancel a warehouse transaction (STORNO)
--              the procedure should be called and not used directly
---------------------------------------------------------------------------------------------
IS
    CURSOR C_TRND       (p_ref_trn  NUMBER)
                        IS
                        SELECT      *
                        FROM        WHS_TRN_DETAIL  d
                        WHERE       ref_trn         =   p_ref_trn
                        ;

    it_trnd             Pkg_Rtype.ta_whs_trn_detail;
    v_row_trh           WHS_TRN%ROWTYPE;
    it_prep_trn         Pkg_Rtype.ta_vw_blo_prepare_trn;
    v_row_trh_s         WHS_TRN%ROWTYPE;

    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_BLO_PREPARE_TRN';
BEGIN

    -- block the STORNED transaction
    v_row_trh.idriga    :=  p_ref_trn;
    Pkg_Get.p_get_whs_trn(v_row_trh, -1);

    --load the STORNED transaction details in a PL/SQL table
    OPEN C_TRND(p_ref_trn); FETCH C_TRND BULK COLLECT INTO it_trnd; CLOSE C_TRND;

    -- prepaire the STORNO transaction details
    FOR i IN 1..it_trnd.COUNT
    LOOP
        it_prep_trn(i).org_code         :=  it_trnd(i).org_code;
        it_prep_trn(i).item_code        :=  it_trnd(i).item_code;
        it_prep_trn(i).colour_code      :=  it_trnd(i).colour_code;
        it_prep_trn(i).size_code        :=  it_trnd(i).size_code;
        it_prep_trn(i).oper_code_item   :=  it_trnd(i).oper_code_item;
        it_prep_trn(i).season_code      :=  it_trnd(i).season_code;
        it_prep_trn(i).order_code       :=  it_trnd(i).order_code;
        it_prep_trn(i).group_code       :=  it_trnd(i).group_code;
        it_prep_trn(i).whs_code         :=  it_trnd(i).whs_code;
        it_prep_trn(i).cost_center      :=  it_trnd(i).cost_center;
        it_prep_trn(i).puom             :=  it_trnd(i).puom;
        it_prep_trn(i).reason_code      :=  it_trnd(i).reason_code;
        it_prep_trn(i).qty              :=  it_trnd(i).qty;
        it_prep_trn(i).trn_sign         :=  it_trnd(i).trn_sign * (-1);
        it_prep_trn(i).ref_receipt      :=  it_trnd(i).ref_receipt;
        it_prep_trn(i).segment_code     :=  C_SEGMENT_CODE;

    END LOOP;

    -- call the transaction engine and set the storned informations on
    IF it_prep_trn.COUNT > 0 THEN
        -- delete from VW_BLO_PREPARE_TRN
        DELETE FROM VW_BLO_PREPARE_TRN;
        -- insert into the view
        Pkg_Iud.p_vw_blo_prepare_trn_miud('I',it_prep_trn);
        --prepare the storno transaction header
        -- cleare the fields to be set correctly by the trigger
        v_row_trh_s                 :=  v_row_trh;
        v_row_trh_s.ref_storno      :=  v_row_trh.idriga;
        v_row_trh_s.idriga          :=  NULL;
        v_row_trh_s.datagg          :=  NULL;
        v_row_trh_s.workst          :=  NULL;
        v_row_trh_s.osuser          :=  NULL;
        v_row_trh_s.nuser           :=  NULL;
        v_row_trh_s.iduser          :=  NULL;
        -- this is the STORNO transaction
        v_row_trh_s.flag_storno     :=  'S';
        -- call the transaction engine
        Pkg_Mov.p_whs_trn_engine(v_row_trh_s);
        -- the old header is flagged as storned with character C
        v_row_trh.flag_storno       :=  'C';
        -- put the storn
        v_row_trh.ref_storno        :=  v_row_trh_s.idriga;
        Pkg_Iud.p_whs_trn_iud('U', v_row_trh);
    END IF;
    --

    IF  p_flag_commit THEN  COMMIT; END IF;
    --
    EXCEPTION WHEN OTHERS THEN
        IF  p_flag_commit THEN ROLLBACK; END IF;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;
/********************************************************************************************
    DDL:    12/04/2008 z Create
/********************************************************************************************/
PROCEDURE P_Stoc_Online (    p_org_code     VARCHAR2    ,
                             p_item_code    VARCHAR2    DEFAULT NULL,
                             p_group_code   VARCHAR2    DEFAULT NULL,
                             p_whs_code     VARCHAR2    DEFAULT NULL,
                             p_season_code  VARCHAR2    DEFAULT NULL
                            )
/*----------------------------------------------------------------------------------
--  PURPOSE:    to determine the stocs using different access paths (indexes)
                according to the parameter combinations that are sent

--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    PRAGMA autonomous_transaction;

    CURSOR  C_LINES(        p_selector      VARCHAR2    ,
                            p_org_code      VARCHAR2    ,
                            p_item_code     VARCHAR2    ,
                            p_group_code    VARCHAR2    ,
                            p_whs_code      VARCHAR2    ,
                            p_season_code   VARCHAR2
                    ) IS
                    ------------------------------------------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,
                            puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'A'
                            AND org_code    =   p_org_code
                            AND item_code   IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_item_code,',;')))
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'B'
                            AND org_code    =   p_org_code
                            AND item_code   IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_item_code,',;')))
                            AND whs_code    IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_whs_code ,',;')))
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'C'
                            AND org_code    =   p_org_code
                            AND item_code   IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_item_code,',;')))
                            AND season_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_season_code ,',;')))
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'D'
                            AND org_code    =   p_org_code
                            AND item_code   IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_item_code,',;')))
                            AND whs_code    IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_whs_code ,',;')))
                            AND season_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_season_code ,',;')))
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'E'
                            AND org_code    =   p_org_code
                            AND group_code  IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_group_code,',;')))
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'G'
                            AND org_code    =   p_org_code
                            AND whs_code    IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_whs_code,',;')))
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'H'
                            AND org_code    =   p_org_code
                            AND season_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_season_code,',;')))
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'I'
                            AND org_code    =   p_org_code
                            AND whs_code    IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_whs_code,',;')))
                            AND season_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_season_code,',;')))
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT  org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom,
                            SUM(trn_sign * qty) qty
                    FROM    WHS_TRN_DETAIL
                    WHERE       p_selector  =   'J'
                            AND org_code    =   p_org_code
                    GROUP BY org_code,item_code,oper_code_item,
                            colour_code,size_code,whs_code,season_code,
                            order_code,group_code,puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    ;




    v_row               VW_STOC_ONLINE%ROWTYPE;
    v_selector          VARCHAR2(1);

    C_SEGMENT_CODE      VARCHAR2(32000) :=  'VW_STOC_ONLINE';

BEGIN

    -- determin the selector
    CASE
        WHEN        p_group_code    IS NULL
                AND p_item_code     IS NOT NULL
                AND p_whs_code      IS NULL
                AND p_season_code   IS NULL
                THEN
                    v_selector  :=  'A';
        WHEN        p_group_code    IS NULL
                AND p_item_code     IS NOT NULL
                AND p_whs_code      IS NOT NULL
                AND p_season_code   IS NULL
                THEN
                    v_selector  :=  'B';
        WHEN        p_group_code    IS NULL
                AND p_item_code     IS NOT NULL
                AND p_whs_code      IS NULL
                AND p_season_code   IS NOT NULL
                THEN
                    v_selector  :=  'C';
        WHEN        p_group_code    IS NULL
                AND p_item_code     IS NOT NULL
                AND p_whs_code      IS NOT NULL
                AND p_season_code   IS NOT NULL
                THEN
                    v_selector  :=  'D';
        WHEN        p_group_code    IS NOT NULL
                THEN
                    v_selector  :=  'E';
        WHEN        p_whs_code      IS NOT NULL
                AND p_season_code   IS NOT NULL
                THEN
                    v_selector  :=  'I';
        WHEN        p_whs_code      IS NOT NULL
                THEN
                    v_selector  :=  'G';
        WHEN        p_season_code   IS NOT NULL
                THEN
                    v_selector  :=  'H';


        ELSE
                    v_selector  :=  'J';
    END CASE;


    DELETE FROM VW_STOC_ONLINE;

    FOR x IN C_LINES(       v_selector      ,
                            p_org_code      ,
                            p_item_code     ,
                            p_group_code    ,
                            p_whs_code      ,
                            p_season_code )
    LOOP

        v_row.segment_code          :=      C_SEGMENT_CODE;
        v_row.ref_date              :=      TRUNC(SYSDATE) ;

        v_row.org_code              :=      x.org_code;
        v_row.item_code             :=      x.item_code;
        v_row.oper_code_item        :=      x.oper_code_item;
        v_row.colour_code           :=      x.colour_code;
        v_row.size_code             :=      x.size_code;
        v_row.whs_code              :=      x.whs_code;
        v_row.season_code           :=      x.season_code;
        v_row.order_code            :=      x.order_code;
        v_row.group_code            :=      x.group_code;
        v_row.puom                  :=      x.puom;
        v_row.qty                   :=      x.qty;

        INSERT INTO VW_STOC_ONLINE VALUES v_row;
    END LOOP;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
           ROLLBACK;
           Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/********************************************************************************************
    DDL:    29/05/2008  d   Create
/********************************************************************************************/
PROCEDURE p_stoc_past (    p_org_code     VARCHAR2    ,
                           p_item_code    VARCHAR2    DEFAULT NULL,
                           p_group_code   VARCHAR2    DEFAULT NULL,
                           p_whs_code     VARCHAR2    DEFAULT NULL,
                           p_season_code  VARCHAR2    DEFAULT NULL,
                           p_ref_date     DATE        DEFAULT NULL
                       )
/*----------------------------------------------------------------------------------
--  PURPOSE:    to determine the stocs using different access paths (indexes)
                according to the parameter combinations that are sent

--  PREREQ:

--  INPUT:
----------------------------------------------------------------------------------*/
IS
    PRAGMA autonomous_transaction;

    CURSOR  C_LINES(        p_selector      VARCHAR2    ,
                            p_org_code      VARCHAR2    ,
                            p_item_code     VARCHAR2    ,
                            p_group_code    VARCHAR2    ,
                            p_whs_code      VARCHAR2    ,
                            p_season_code   VARCHAR2    ,
                            p_ref_date      VARCHAR2
                    ) IS
                    ------------------------------------------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'A'
                            AND d.org_code  =   p_org_code
                            AND d.item_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_item_code,',;')))
                            AND h.date_legal<=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'B'
                            AND d.org_code  =   p_org_code
                            AND d.item_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_item_code,',;')))
                            AND d.whs_code  IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_whs_code,',;' )))
                            AND h.date_legal <=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'C'
                            AND d.org_code    =   p_org_code
                            AND d.item_code   IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_item_code,',;')))
                            AND d.season_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_season_code,',;' )))
                            AND h.date_legal<=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'D'
                            AND d.org_code    =   p_org_code
                            AND d.item_code   IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_item_code,',;')))
                            AND d.whs_code    IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_whs_code ,',;')))
                            AND d.season_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_season_code,',;' )))
                            AND h.date_legal<=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'E'
                            AND d.org_code    =   p_org_code
                            AND d.group_code  IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_group_code,',;')))
                            AND h.date_legal<=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'G'
                            AND d.org_code    =   p_org_code
                            AND d.whs_code    IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_whs_code,',;')))
                            AND h.date_legal<=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'H'
                            AND d.org_code    =   p_org_code
                            AND d.season_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_season_code,',;')))
                            AND h.date_legal<=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0
                    --------------------
                    UNION ALL
                    --------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'I'
                            AND d.org_code    =   p_org_code
                            AND d.whs_code    IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_whs_code,',;')))
                            AND d.season_code IN  (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_season_code,',;')))
                            AND h.date_legal<=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0

                    --------------------
                    UNION ALL
                    --------------------
                    SELECT      d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,
                                d.puom,
                                SUM(d.trn_sign * d.qty)     qty
                    FROM        WHS_TRN_DETAIL      d
                    INNER JOIN  WHS_TRN             h   ON  h.idriga    =   d.ref_trn
                    WHERE       p_selector  =   'J'
                            AND d.org_code    =   p_org_code
                            AND h.date_legal<=  p_ref_date
                    GROUP BY    d.org_code,d.item_code,d.oper_code_item,
                                d.colour_code,d.size_code,d.whs_code,d.season_code,
                                d.order_code,d.group_code,d.puom
                    HAVING  SUM(trn_sign * qty) <> 0

                    ;




    v_row               VW_STOC_ONLINE%ROWTYPE;
    v_selector          VARCHAR2(1);

    C_SEGMENT_CODE      VARCHAR2(32000) :=  'VW_STOC_ONLINE';

BEGIN

    -- determin the selector
    CASE
        WHEN        p_group_code    IS NULL
                AND p_item_code     IS NOT NULL
                AND p_whs_code      IS NULL
                AND p_season_code   IS NULL
                THEN
                    v_selector  :=  'A';
        WHEN        p_group_code    IS NULL
                AND p_item_code     IS NOT NULL
                AND p_whs_code      IS NOT NULL
                AND p_season_code   IS NULL
                THEN
                    v_selector  :=  'B';
        WHEN        p_group_code    IS NULL
                AND p_item_code     IS NOT NULL
                AND p_whs_code      IS NULL
                AND p_season_code   IS NOT NULL
                THEN
                    v_selector  :=  'C';
        WHEN        p_group_code    IS NULL
                AND p_item_code     IS NOT NULL
                AND p_whs_code      IS NOT NULL
                AND p_season_code   IS NOT NULL
                THEN
                    v_selector  :=  'D';
        WHEN        p_group_code    IS NOT NULL
                THEN
                    v_selector  :=  'E';
        WHEN        p_whs_code      IS NOT NULL
                AND p_season_code   IS NOT NULL
                THEN
                    v_selector  :=  'I';
        WHEN        p_whs_code      IS NOT NULL
                THEN
                    v_selector  :=  'G';
        WHEN        p_season_code   IS NOT NULL
                THEN
                    v_selector  :=  'H';


        ELSE
                    v_selector  :=  'J';
    END CASE;


    DELETE FROM VW_STOC_ONLINE;

    FOR x IN C_LINES(       v_selector      ,
                            p_org_code      ,
                            p_item_code     ,
                            p_group_code    ,
                            p_whs_code      ,
                            p_season_code   ,
                            NVL(p_ref_date, SYSDATE))
    LOOP

        v_row.segment_code          :=      C_SEGMENT_CODE;

        v_row.org_code              :=      x.org_code;
        v_row.item_code             :=      x.item_code;
        v_row.oper_code_item        :=      x.oper_code_item;
        v_row.colour_code           :=      x.colour_code;
        v_row.size_code             :=      x.size_code;
        v_row.whs_code              :=      x.whs_code;
        v_row.season_code           :=      x.season_code;
        v_row.order_code            :=      x.order_code;
        v_row.group_code            :=      x.group_code;
        v_row.puom                  :=      x.puom;
        v_row.qty                   :=      x.qty;
        v_row.ref_date              :=      p_ref_date;

        INSERT INTO VW_STOC_ONLINE VALUES v_row;
    END LOOP;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
           ROLLBACK;
           Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/********************************************************************************************
    DDL:    19/04/2008  d   Create
/********************************************************************************************/
PROCEDURE p_storno      (   p_ref_trn       NUMBER,
                            p_commit        BOOLEAN,
                            p_note          VARCHAR2 DEFAULT NULL
                        )
---------------------------------------------------------------------------------------------
--  PURPOSE:    general storno procedure,
--              depending on the transaction type, will do different actions
---------------------------------------------------------------------------------------------
IS

    v_row_trh              WHS_TRN%ROWTYPE;

BEGIN

    -- SECURITY
    Pkg_App_Secur.p_test_grant('MOV_STORNO');

    -- get the transaction header row and block it
    v_row_trh.idriga       :=  p_ref_trn;
    Pkg_Get.p_get_whs_trn(v_row_trh, -1);

    IF v_row_trh.flag_storno = 'S' THEN
        Pkg_Lib.p_rae('Nu se poate storna o miscare de STORNARE !!!');
    END IF;
    IF v_row_trh.flag_storno = 'C' THEN
        Pkg_Lib.p_rae('Aceasta tranzactie de magazie a fost deja stornata. Nu se mai poate storna !!!');
    END IF;


    -- PROD
    IF v_row_trh.trn_type IN ('PROD', 'TRN_FIN') THEN

        Pkg_Prod.p_dpr_undo     (   p_row_trh   =>  v_row_trh,
                                    p_commit    =>  FALSE
                                );

    -- receipt transactions

    ELSIF v_row_trh.trn_type IN ('TRN_GEN','TRN_TRN') THEN
        UPDATE  PACKAGE_TRN_HEADER SET status = 'X'
        WHERE   ref_whs_trn =   p_ref_trn ;

        Pkg_Mov.p_whs_trn_storno (
                                    p_ref_trn   ,
                                    p_commit
                                );


    ELSIF v_row_trh.trn_type IN ('REC_CTL','REC_CUST','REC_PATR') THEN
        Pkg_Lib.p_rae('Nu se poate storna o miscare de receptie din acest formular! Pentru aceasta, utilizati formukarul de Gestiune Receptii !');

    -- Others
    ELSE
        Pkg_Lib.p_rae('Pentru tipul de miscare '||v_row_trh.trn_type||' nu sunt reguli de STORNARE stabilite!');
    END IF;

    IF p_commit THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_commit THEN ROLLBACK; END IF;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 25/04/2008  d  Create procedure
/*********************************************************************************/
PROCEDURE p_whs_trn_iud     (   p_tip VARCHAR2, p_row WHS_TRN%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    IUD for WHS_TRN table
----------------------------------------------------------------------------------
IS
    v_row               WHS_TRN%ROWTYPE;
BEGIN
    v_row   :=  p_row;

    Pkg_Mov.p_whs_trn_blo(p_tip, v_row);

    Pkg_Iud.p_whs_trn_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;

/*********************************************************************************************
    25/04/2008  d   created
/*********************************************************************************************/
PROCEDURE p_whs_trn_blo     (   p_tip               VARCHAR2,
                                p_row   IN OUT      WHS_TRN%ROWTYPE
                            )
----------------------------------------------------------------------------------------------
--  PURPOSE:    Row level BLO for WHS_TRN table
----------------------------------------------------------------------------------------------
IS

BEGIN

    IF p_tip IN ('I', 'D') THEN
        Pkg_Lib.p_rae('Nu se poate insera sau sterge o miscare de magazie, ci doar se pot modifica anumite informatii !');
    ELSE
        Pkg_Mov.p_check_date_legal(p_row.date_legal, 'Tranzactii de magazii');
    END IF;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 28/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_prepare_pick_plan_3(p_ref_plan   INTEGER)
/*----------------------------------------------------------------------------------
--  PURPOSE:
            - This is used for SHP_CTL - ship to outside processing picking list

            1_  for source warehouse of category MPC and MPP (raw material) it shows
            the list of all the materials that has stock in that warehouse presenting
                * quantity already in the plan (picked before)
                * the stock - qty already picked in the source warehouse
                * the free (not allocated) quantity in the destination warehouse (CTL)
                * the demand (nominal - net allocated) quantity for the material for active
                  workorders (status L)

                --ATENTION in these warehouse it si NOT shown the stocks that are for
                semiprocessed items (these are shown only from WIP warehouse)

                -- the calculation of the net demand is a little trickier it is made
                with some arrays in witch we load the total demnad on workorder level,
                after that the net flux of allocation to match with these workorders
                after that we make an agregation on the level of item (loose the work order
                detail) and lod a third array for the net demand on item level


            2_  for source warehouse of category WIP it shows the list of the semiprocessed
             items that are on work order that is active for this CTL warehouse and has
             the fase (oper_code_item) that is the previous phase for the fase that is executed
             in the CTL location





--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------*/
IS

    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR C_MATERIAL_NEED (    p_org_code      VARCHAR2,
                                p_suppl_code    VARCHAR2,
                                p_season_code   VARCHAR2
                           ) IS
        SELECT      b.org_code,b.group_code,b.item_code,b.oper_code_item,b.colour_code,b.size_code,
                    b.qta_demand qty_demand,
                    g.season_code
        FROM        WORK_GROUP      g
        INNER JOIN  GROUP_ROUTING   r
                        ON  r.group_code    =   g.group_code
        INNER JOIN  BOM_GROUP       b
                        ON  b.group_code    =   r.group_code
                        AND b.oper_code     =   r.oper_code
        INNER JOIN  WAREHOUSE       w
                        ON  w.whs_code      =   r.whs_cons
        WHERE       g.status        =   'L'
                AND w.org_code      =   p_suppl_code
                AND g.org_code      =   p_org_code
                AND g.season_code   =   p_season_code
        ORDER BY    b.group_code,b.item_code
        ;


    CURSOR  C_WHS_LOHN(p_suppl_code VARCHAR2, p_category_code VARCHAR2) IS
        SELECT *
        FROM    WAREHOUSE
        WHERE       org_code        =   p_suppl_code
                AND category_code   =   p_category_code
        ;

    CURSOR  C_WHS_STOC IS
        SELECT          s.*,
                        i.description   i_description,
                        c.description   c_description,
                        g.group_code    g_group_code
        FROM            VW_STOC_ONLINE      s
        INNER JOIN      ITEM                i
                            ON  i.org_code      =   s.org_code
                            AND i.item_code     =   s.item_code
        LEFT JOIN       VW_PREP_GROUP_CODE  g
                            ON  g.group_code    =   s.group_code
        LEFT JOIN       COLOUR              c
                            ON  c.colour_code   =   s.colour_code
                            AND c.org_code      =   s.org_code
        WHERE           s.qty   > 0
        ORDER BY        s.whs_code,s.item_code,s.oper_code_item,
                        s.colour_code,s.size_code
        ;

    CURSOR  C_ALREADY_PICKED(p_ref_plan INTEGER) IS
        SELECT  *
        FROM    TRN_PLAN_DETAIL
        WHERE   ref_plan    =   p_ref_plan
        ;




    it_dem                  Pkg_Glb.type_dim_10;
    it_dem2                 Pkg_Glb.type_rdima;
    it_dem3                 Pkg_Glb.type_dim_10;
    it_flx                  Pkg_Glb.type_dim_10;
    it_fre                  Pkg_Glb.type_dim_10;
    it_apk                  Pkg_Glb.type_dim_10;

    it_grp                  Pkg_Glb.typ_varchar_varchar;
    it                      Pkg_Rtype.ta_vw_prep_pick_plan;

    it_rout                 Pkg_Mov.type_rout3;
    it_whs                  Pkg_Rtype.tas_warehouse;

    v_row_whs               WAREHOUSE%ROWTYPE;
    v_row_grp               VW_PREP_GROUP_CODE%ROWTYPE;

    v_qty                   NUMBER;
    v_idx_group             Pkg_Glb.type_index;
    v_whs_code              Pkg_Glb.type_index;
    v_oper_code             Pkg_Glb.type_index;


    v_row_tpl               TRN_PLAN_HEADER%ROWTYPE;
    v_row                   VW_PREP_PICK_PLAN%ROWTYPE;
    v_count_demand          INTEGER;
    v_seq_no1               INTEGER;
    v_seq_no2               INTEGER;

    v_insert                BOOLEAN;

    C_SEGMENT_CODE          VARCHAR2(32000) :=  'VW_PREP_PICK_PLAN';
    C_SEGMENT_CODE2         VARCHAR2(32000) :=  'VW_PREP_GROUP_CODE';


BEGIN
    Pkg_Err.p_reset_error_message();
    --
    v_row_tpl.idriga    :=  p_ref_plan;
    IF Pkg_Get.f_get_trn_plan_header(v_row_tpl) THEN NULL; END IF;
    ---
    -- determine the warehouse associated to this supplier
    OPEN    C_WHS_LOHN(v_row_tpl.suppl_code, Pkg_Glb.C_WHS_CTL );
    FETCH   C_WHS_LOHN INTO v_row_whs;
    CLOSE   C_WHS_LOHN;
    ---
    -- get the active work groups in this organization

    DELETE FROM VW_PREP_GROUP_CODE;
    FOR x IN Pkg_Mov.C_ACTIVE_ORDERS(
                                    p_org_code      =>  v_row_tpl.org_code,
                                    p_suppl_code    =>  v_row_tpl.suppl_code
                                )
    LOOP
        v_row_grp.group_code    :=  x.group_code;
        v_row_grp.segment_code  :=  C_SEGMENT_CODE2;
        INSERT INTO VW_PREP_GROUP_CODE VALUES v_row_grp;
    END LOOP;
    -- load the warhouses
    FOR x IN Pkg_Nomenc.C_WAREHOUSE LOOP
        it_whs(x.whs_code)  :=  x;
    END LOOP;

    -- load the already picked quantities
    FOR x IN C_ALREADY_PICKED(p_ref_plan) LOOP

            v_qty   := Pkg_Lib.f_get_mdim
                            (   p_it    =>  it_apk          ,
                                p_1     =>  x.org_code      ,
                                p_2     =>  x.item_code     ,
                                p_3     =>  x.oper_code_item  ,
                                p_4     =>  x.colour_code  ,
                                p_5     =>  x.size_code  ,
                                p_6     =>  x.season_code_out,
                                p_7     =>  x.whs_code_out,
                                p_8     =>  x.group_code_out   ,
                                p_9     =>  x.order_code
                            );

            v_qty   := v_qty +  x.qty_puom;

            Pkg_Lib.p_load_mdim(                it_apk          ,
                                                v_qty           ,
                                    p_1     =>  x.org_code      ,
                                    p_2     =>  x.item_code     ,
                                    p_3     =>  x.oper_code_item,
                                    p_4     =>  x.colour_code   ,
                                    p_5     =>  x.size_code     ,
                                    p_6     =>  x.season_code_out,
                                    p_7     =>  x.whs_code_out   ,
                                    p_8     =>  x.group_code_out ,
                                    p_9     =>  x.order_code
                                );
    END LOOP;


    -- if the picking warehouse is category MPP, MPC go on with the logic for
    -- raw material
    IF it_whs(v_row_tpl.whs_code).category_code IN (
                                           Pkg_Glb.C_WHS_MPC,
                                           Pkg_Glb.C_WHS_MPP
                                          )
    THEN

        FOR x IN C_MATERIAL_NEED(
                                    p_org_code      =>  v_row_tpl.org_code,
                                    p_suppl_code    =>  v_row_tpl.suppl_code   ,
                                    p_season_code   =>  v_row_tpl.season_code
                                )
        LOOP

            v_qty   :=      Pkg_Lib.f_get_mdim
                                (   p_it    =>  it_dem          ,
                                    p_1     =>  x.org_code      ,
                                    p_2     =>  x.group_code    ,
                                    p_3     =>  x.item_code     ,
                                    p_4     =>  x.oper_code_item,
                                    p_5     =>  x.colour_code   ,
                                    p_6     =>  x.size_code     ,
                                    p_7     =>  x.season_code
                                );

            v_qty   :=  v_qty + x.qty_demand;

            Pkg_Lib.p_load_mdim(                it_dem          ,
                                                v_qty           ,
                                    p_1     =>  x.org_code      ,
                                    p_2     =>  x.group_code    ,
                                    p_3     =>  x.item_code     ,
                                    p_4     =>  x.oper_code_item,
                                    p_5     =>  x.colour_code   ,
                                    p_6     =>  x.size_code     ,
                                    p_7     =>  x.season_code
                                );

        END LOOP;


        -- load the allocation fluxes for these work groups
        FOR x IN Pkg_Mov.C_ALLOCATED LOOP
            Pkg_Lib.p_load_mdim(                it_flx          ,
                                                x.qty           ,
                                    p_1     =>  x.org_code      ,
                                    p_2     =>  x.group_code    ,
                                    p_3     =>  x.item_code     ,
                                    p_4     =>  x.oper_code_item,
                                    p_5     =>  x.colour_code   ,
                                    p_6     =>  x.size_code
                               );
        END LOOP;
        -- determin the demand that has left for these materials + workgroups
        -- this procedure traverse the tree structure that was built in it_dem
        -- and retursn a linear structure in it_dem2 (that is an array of x1,..x10,value record)
        Pkg_Lib.p_trav_mdim(it_dem,it_dem2);
        FOR i IN 1..it_dem2.COUNT LOOP
            v_qty   :=      Pkg_Lib.f_get_mdim
                                (   p_it    =>  it_flx          ,
                                    p_1     =>  it_dem2(i).d_1  , -- orgcode
                                    p_2     =>  it_dem2(i).d_2  , -- group code
                                    p_3     =>  it_dem2(i).d_3  , -- item_code
                                    p_4     =>  it_dem2(i).d_4  , -- oper code item
                                    p_5     =>  it_dem2(i).d_5  , -- colour code
                                    p_6     =>  it_dem2(i).d_6    -- size code
                                );
            --
            v_qty   :=  it_dem2(i).val - v_qty;
            v_qty   :=  GREATEST(v_qty, 0);
            --
            -- here we cumuleit the values for item s in it_dem3 (group by items, loose the detail of
            -- work groups !!!!!!!!)
            v_qty   :=  v_qty +   Pkg_Lib.f_get_mdim
                                (   p_it    =>  it_dem3         ,
                                    p_1     =>  it_dem2(i).d_1  , -- org code
                                    p_2     =>  it_dem2(i).d_3  , -- item code
                                    p_3     =>  it_dem2(i).d_4  , -- oper_code_item
                                    p_4     =>  it_dem2(i).d_5  , -- colour_code
                                    p_5     =>  it_dem2(i).d_6  , -- size_code
                                    p_6     =>  it_dem2(i).d_7    -- season code
                                );
            ----
            Pkg_Lib.p_load_mdim(                it_dem3         ,
                                                v_qty           ,
                                    p_1     =>  it_dem2(i).d_1  , -- org code
                                    p_2     =>  it_dem2(i).d_3  , -- item code
                                    p_3     =>  it_dem2(i).d_4  , -- oper_code_item
                                    p_4     =>  it_dem2(i).d_5  , -- colour code
                                    p_5     =>  it_dem2(i).d_6  , -- size code
                                    p_6     =>  it_dem2(i).d_7    -- season code
                                );
        END LOOP;
        -- generate the stocs
        Pkg_Mov.P_Stoc_Online(
                                p_org_code      =>  v_row_tpl.org_code,
                                p_whs_code      =>  v_row_tpl.whs_code
                                                    -- add here also the CTL warehouse
                                                    -- to have access for the not allocated
                                                    -- quantities in the same loop
                                                    ||','
                                                    ||v_row_whs.whs_code,
                                p_season_code   => v_row_tpl.season_code
                             );


        --

        v_row.segment_code  :=  C_SEGMENT_CODE;
        v_count_demand      :=  0;
        -- cycle on the stoc
        FOR x IN C_WHS_STOC LOOP
            -- load the free (not allocated) stock in ana array
            IF      x.whs_code      = v_row_whs.whs_code
                AND x.group_code    IS NULL
            THEN
                Pkg_Lib.p_load_mdim(                it_fre          ,
                                                    x.qty           ,
                                        p_1     =>  x.org_code      ,
                                        p_2     =>  x.item_code     ,
                                        p_3     =>  x.oper_code_item,
                                        p_4     =>  x.colour_code   ,
                                        p_5     =>  x.size_code     ,
                                        p_6     =>  x.season_code
                                    );
            END IF;
            ---

            v_insert    :=  FALSE;

            --
            IF  v_row_tpl.whs_code = x.whs_code THEN
                IF      x.group_code IS NULL
                    AND x.order_code IS NULL
                THEN
                    -- if the material is not allocated we present this line
                    v_insert    :=  TRUE;
                ELSE
                    -- if the material is allocated check if it is semifinished
                    IF      x.order_code    IS NULL
                        AND x.g_group_code  IS NOT NULL -- this is to check only active orders in suppl location
                    THEN
                        v_insert    :=  TRUE;
                    END IF;
                END IF;
            END IF;


            IF v_insert THEN
                v_row.org_code          :=  v_row_tpl.org_code;
                v_row.item_code         :=  x.item_code;
                v_row.oper_code_item    :=  x.oper_code_item;
                v_row.colour_code       :=  x.colour_code;
                v_row.size_code         :=  x.size_code;
                v_row.start_size        :=  NULL;
                v_row.end_size          :=  NULL;
                v_row.season_code_in    :=  x.season_code;
                v_row.puom              :=  x.puom;
                v_row.whs_code_out      :=  x.whs_code;
                v_row.whs_code_in       :=  v_row_whs.whs_code;
                v_row.oper_code         :=  NULL;
                v_row.description       :=  x.i_description;
                v_row.season_code_out   :=  x.season_code;
                v_row.flag_total_line   :=  'N';
                v_row.description_colour:=  x.c_description;
                v_row.flag_dirty        :=  'N';
                v_row.order_code        :=  NULL;
                v_row.idriga            :=  C_WHS_STOC%rowcount;
                v_row.dcn               :=  0;
                v_row.ref_plan          :=  p_ref_plan;
                v_row.seq_no            :=  NULL;
                v_row.seq_no2           :=  NULL;
                v_row.seq_group         :=  NULL;
                v_row.qty_demand_ini    :=  0;

                v_row.group_code_out    :=  x.group_code;
                v_row.group_code_in     :=  v_row.group_code_out;


                v_row.qty_apick          :=   Pkg_Lib.f_get_mdim
                                          (   p_it    =>  it_apk           ,
                                              p_1     =>  x.org_code        ,
                                              p_2     =>  x.item_code       ,
                                              p_3     =>  x.oper_code_item  ,
                                              p_4     =>  x.colour_code     ,
                                              p_5     =>  x.size_code       ,
                                              p_6     =>  x.season_code     ,
                                              p_7     =>  x.whs_code        ,
                                              p_8     =>  x.group_code      ,
                                              p_9     =>  x.order_code
                                          );

                -- if we are on a line without work group than associate
                -- the total demand left
                IF v_row.group_code_out IS NULL THEN
                    v_row.qty_demand_now    :=   Pkg_Lib.f_get_mdim
                                              (   p_it    =>  it_dem3           ,
                                                  p_1     =>  x.org_code        ,
                                                  p_2     =>  x.item_code       ,
                                                  p_3     =>  x.oper_code_item  ,
                                                  p_4     =>  x.colour_code     ,
                                                  p_5     =>  x.size_code       ,
                                                  p_6     =>  x.season_code
                                              );
                ELSE
                    -- if we are on a line with work order consider the demand egal to
                    -- the stock that was allocated to that work order
                    v_row.qty_demand_now    := x.qty ;
                END IF;

                v_row.qty_stock         :=  x.qty - v_row.qty_apick;

                v_row.qty_pick          :=  0;

                it(it.COUNT + 1)        :=  v_row;

                IF v_row.qty_demand_now > 0 THEN
                    v_count_demand  :=  v_count_demand + 1;
                END IF ;
            END IF;
        END LOOP;
        --
        -- loop trough again to associate the not allocated stoc
        v_seq_no1   :=  0;
        v_seq_no2   :=  v_count_demand ;

        FOR i IN 1..it.COUNT LOOP

            -- show the not allocated  stocs only for lines without
            -- work group information
            IF it(i).group_code_out IS NULL THEN
                it(i).qty_free :=   Pkg_Lib.f_get_mdim
                                              (   p_it    =>  it_fre           ,
                                                  p_1     =>  it(i).org_code        ,
                                                  p_2     =>  it(i).item_code       ,
                                                  p_3     =>  it(i).oper_code_item  ,
                                                  p_4     =>  it(i).colour_code     ,
                                                  p_5     =>  it(i).size_code       ,
                                                  p_6     =>  it(i).season_code_in
                                              );
            ELSE
                it(i).qty_free := 0;
            END IF;

           IF  it(i).qty_demand_now > 0 THEN
                v_seq_no1       :=  v_seq_no1 + 1;
                it(i).seq_no    :=  v_seq_no1;
           ELSE
                v_seq_no2       :=  v_seq_no2 + 1;
                it(i).seq_no    :=  v_seq_no2 ;
           END IF;
        END LOOP;

    ELSE
        ------------------------------------------------------------------
        -- here for warehouse category WIP for semiprocessed material

        FOR x IN Pkg_Mov.C_GROUP_ROUTING LOOP
            IF      x.org_code_curr         =   v_row_tpl.suppl_code    -- the operatio to be for the seelected suplier
                AND x.seq_no_abs            <>  1                       -- not to be the first operation on the routing
                AND x.category_code_prev    <>  x.category_code_curr    -- the previous whs categ to be different from the current
            THEN
                it_rout(x.group_code)(x.org_code_curr)(x.oper_code_curr) :=  x;
            END IF;
        END LOOP;

        -- generate the stocs
        Pkg_Mov.P_Stoc_Online(
                                p_org_code      =>  v_row_tpl.org_code,
                                p_whs_code      =>  v_row_tpl.whs_code,
                                p_season_code   =>  v_row_tpl.season_code
                             );

        FOR x IN C_WHS_STOC LOOP

            v_insert    :=  FALSE;

            IF x.order_code IS NOT NULL THEN
                IF it_rout.EXISTS(x.group_code) THEN
                    v_oper_code :=  it_rout(x.group_code)(v_row_tpl.suppl_code).FIRST;
                    WHILE v_oper_code IS NOT NULL LOOP
                        IF x.oper_code_item = it_rout(x.group_code        )
                                                     (v_row_tpl.suppl_code)
                                                     (v_oper_code         ).oper_code_prev
                        THEN
                            v_insert := TRUE;
                            EXIT;
                        END IF;
                        v_oper_code :=  it_rout(x.group_code)(v_row_tpl.suppl_code).NEXT(v_oper_code);
                    END LOOP;
                END IF  ;
            END IF;
            --
            IF v_insert THEN

                v_row.segment_code  :=  C_SEGMENT_CODE;

                v_row.org_code          :=  v_row_tpl.org_code;
                v_row.item_code         :=  x.item_code;
                v_row.oper_code_item    :=  x.oper_code_item;
                v_row.colour_code       :=  x.colour_code;
                v_row.size_code         :=  x.size_code;
                v_row.start_size        :=  NULL;
                v_row.end_size          :=  NULL;
                v_row.season_code_in    :=  x.season_code;
                v_row.puom              :=  x.puom;
                v_row.whs_code_out      :=  x.whs_code;
                v_row.whs_code_in       :=  v_row_whs.whs_code;
                v_row.oper_code         :=  NULL;
                v_row.description       :=  x.i_description;
                v_row.season_code_out   :=  x.season_code;
                v_row.flag_total_line   :=  'N';
                v_row.description_colour:=  x.c_description;
                v_row.flag_dirty        :=  'N';
                v_row.order_code        :=  x.order_code;
                v_row.idriga            :=  C_WHS_STOC%rowcount;
                v_row.dcn               :=  0;
                v_row.ref_plan          :=  p_ref_plan;
                v_row.seq_no            :=  C_WHS_STOC%rowcount;
                v_row.seq_no2           :=  NULL;
                v_row.seq_group         :=  NULL;
                v_row.qty_demand_ini    :=  0;

                v_row.group_code_out    :=  x.group_code;
                v_row.group_code_in     :=  v_row.group_code_out;


                v_row.qty_demand_now    := 0 ;

                v_row.qty_apick          :=   Pkg_Lib.f_get_mdim
                                          (   p_it    =>  it_apk           ,
                                              p_1     =>  x.org_code        ,
                                              p_2     =>  x.item_code       ,
                                              p_3     =>  x.oper_code_item  ,
                                              p_4     =>  x.colour_code     ,
                                              p_5     =>  x.size_code       ,
                                              p_6     =>  x.season_code     ,
                                              p_7     =>  x.whs_code        ,
                                              p_8     =>  x.group_code      ,
                                              p_9     =>  x.order_code
                                          );



                v_row.qty_stock         :=  x.qty - v_row.qty_apick ;
                v_row.qty_free          :=  0;
                v_row.qty_pick          :=  0;

                it(it.COUNT + 1)        :=  v_row;
            END IF;
        END LOOP;
    END IF;



    ---
    DELETE FROM VW_PREP_PICK_PLAN;
    Pkg_Iud.p_vw_prep_pick_plan_miud('I',it);
    --
    IF it.COUNT = 0 THEN
          Pkg_Err.p_set_error_message
          (    p_err_code          => '00' ,
               p_err_header        => 'Nu exista stocuri pentru criteriile de picking'
                                      ||' precizate !!!',
               p_err_detail        => NULL ,
               p_flag_immediate    => 'Y'
          );
    END IF;
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 09/05/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_distribute_pick_qty(
                                    p_seq_group         INTEGER ,
                                    p_whs_code          VARCHAR2,
                                    p_qty               NUMBER  ,
                                    p_flag_total_line   VARCHAR2
                               )
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row  when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    CURSOR  C_LINES(p_seq_group INTEGER) IS
            SELECT  *
            FROM    VW_PREP_PICK_PLAN
            WHERE   seq_group   =   p_seq_group
            ORDER BY seq_no2
            ;

    it                  Pkg_Rtype.ta_vw_prep_pick_plan;

    v_qty_demand_now    NUMBER;
    v_qty_pick          NUMBER;
    v_qty_distribute    NUMBER;
    v_qty_stock         NUMBER  :=  0;
    z                   VW_PREP_PICK_PLAN%ROWTYPE;
    v_idx_last          INTEGER;

BEGIN
    Pkg_Err.p_reset_error_message();
    --
    IF p_seq_group IS NULL THEN
          Pkg_Err.p_set_error_message
          (    p_err_code          => '00' ,
               p_err_header        => 'Nu ati pozitionat cursorul '
                                      ||'pe o linie din formular !!!',
               p_err_detail        => NULL ,
               p_flag_immediate    => 'Y'
          );
    END IF;
    --
    IF p_flag_total_line = 'Y' THEN
          Pkg_Err.p_set_error_message
          (    p_err_code          => '00' ,
               p_err_header        => 'Ati selectat o linie de total '
                                      ||' !!!',
               p_err_detail        => NULL ,
               p_flag_immediate    => 'Y'
          );
    END IF;
    ---
    IF NVL(p_qty,0) <= 0  THEN
          Pkg_Err.p_set_error_message
          (    p_err_code          => '00' ,
               p_err_header        => 'Nu ati precizat o cantitate pozitiva '
                                      ||'de distribuit !!!',
               p_err_detail        => NULL ,
               p_flag_immediate    => 'Y'
          );
    END IF;
    --
    -- load the lines for the group (that means an item definition )
    FOR x IN C_LINES(p_seq_group) LOOP
        it(x.idriga)    :=  x;
        ---check if there is qty_pick for this group and warehouse, in this
        -- case give an error
        IF      it(x.idriga).whs_code_out = p_whs_code
            AND it(x.idriga).qty_pick > 0
        THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => '00' ,
                  p_err_header        => 'Nu se poate folosi procedura '
                                         ||'de distributie numai '
                                         ||'daca NU exista cantitati deja '
                                         ||'propuse '
                                         ||'!!!',
                  p_err_detail        => NULL ,
                  p_flag_immediate    => 'Y'
             );
        END IF;
        --- check if there is enough stoc in warehouse to distribute the
        -- all quantity
        IF      it(x.idriga).whs_code_out  =   p_whs_code
            AND it(x.idriga).group_code_out IS NULL
        THEN
            --
            v_qty_stock := v_qty_stock + it(x.idriga).qty_stock;
            --
/*
            IF  v_qty_stock  <   p_qty  THEN
                 Pkg_Err.p_set_error_message
                 (    p_err_code          => '00' ,
                      p_err_header        => 'Nu se poate distribui intreaga '
                                             ||'cantitate '
                                             ||p_qty
                                             ||' deoarece nu exista stoc destul '
                                             ||'in magazia '
                                             ||p_whs_code
                                             ||' ( stoc '
                                             || v_qty_stock
                                             ||' )'
                                             ||' !!!',
                      p_err_detail        => NULL ,
                      p_flag_immediate    => 'Y'
                 );
             END IF;
*/
        END IF;
    END LOOP;

    --
    IF  v_qty_stock  <   p_qty  THEN
         Pkg_Err.p_set_error_message
         (    p_err_code          => '00' ,
              p_err_header        => 'Nu se poate distribui intreaga '
                                     ||'cantitate '
                                     ||p_qty
                                     ||' deoarece nu exista stoc destul '
                                     ||'in magazia '
                                     ||p_whs_code
                                     ||' ( stoc '
                                     || v_qty_stock
                                     ||' )'
                                     ||' !!!',
              p_err_detail        => NULL ,
              p_flag_immediate    => 'Y'
         );
     END IF;
    
    
    --
    v_qty_distribute    :=  p_qty;
    v_qty_pick          :=  0;
    FOR i IN it.FIRST..it.LAST LOOP
        z   :=  it(i);
        --
        IF z.qty_demand_now IS NOT NULL THEN
            v_qty_demand_now    :=  z.qty_demand_now;
        END IF;
        --
        IF      z.whs_code_out      =   p_whs_code
            AND z.group_code_out    IS  NULL
        THEN
            --
            --z.qty_stock :=  v_qty_stock;
            z.qty_pick  :=  LEAST (
                                        v_qty_demand_now,
                                        z.qty_stock     ,
                                        v_qty_distribute
                                  );
            z.qty_pick  :=  GREATEST(z.qty_pick ,0 );

            v_qty_stock         :=  v_qty_stock         -   z.qty_pick ;
            v_qty_distribute    :=  v_qty_distribute    -   z.qty_pick ;
            v_qty_demand_now    :=  v_qty_demand_now    -   z.qty_pick ;

            v_qty_pick          :=  v_qty_pick + z.qty_pick;

        END IF;
        ---
        it(i)   :=  z;
    END LOOP;
    --
    -- if there ia quantity to distribute put that quantity on the firts line
    -- that has qty_pick

    IF v_qty_distribute > 0 THEN
        IF v_qty_pick = 0 THEN
             Pkg_Err.p_set_error_message
             (    p_err_code          => '00' ,
                  p_err_header        => 'Nu exista necesar pe nici o '
                                         ||'pozitie '
                                         ||'!!!',
                  p_err_detail        => NULL ,
                  p_flag_immediate    => 'Y'
             );
        END IF;
        --
        -- put the remaining on the last record that is for this warehouse
        -- and has qty picked set
        -- so determin the last index
        FOR i IN it.FIRST..it.LAST LOOP
            IF      it(i).whs_code_out  =   p_whs_code
                AND it(i).qty_pick      >   0
            THEN
                v_idx_last  :=  i;
            END IF;
        END LOOP;
        -- put the exceding here
        it(v_idx_last).qty_pick  :=  it(v_idx_last).qty_pick + v_qty_distribute;
        -- readjust the progressive stoc for the next records for the same warehouse
        v_qty_stock := it(v_idx_last).qty_stock - v_qty_distribute;
        FOR i IN it.NEXT(v_idx_last)..it.LAST LOOP
            IF it(i).whs_code_out = p_whs_code THEN
                it(i).qty_stock :=  v_qty_stock;
            END IF;
        END LOOP;
    END IF;
    --
    v_qty_pick  := v_qty_pick + v_qty_distribute;
    -- put on the last line
    -- the totals
    it(it.LAST).qty_pick    :=  v_qty_pick;
    --
    Pkg_Iud.p_vw_prep_pick_plan_miud('U',it);
    --
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;




END;

/

/
