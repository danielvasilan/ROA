--------------------------------------------------------
--  DDL for Package PKG_MOV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_MOV" 
IS


/*********************************************************************************
    DDL: 06/04/2008  z Create
    -- to have the information for the previous and next operation for the
    -- current operation in the routing , using the functions LAG and LEAD
/*********************************************************************************/
CURSOR  C_GROUP_ROUTING IS
    SELECT  row_number() OVER (PARTITION BY r.group_code ORDER BY r.seq_no)    seq_no_abs,
            r.group_code, r.seq_no, r.whs_cons, r.whs_dest, r.workcenter_code,
            -- orgaization code
            LAG(w.org_code)
                OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) org_code_prev ,
            w.org_code                                              org_code_curr,
            LEAD(w.org_code)
                OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) org_code_next,
            -- whs categoy
            LAG(w.category_code)
                OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) category_code_prev ,
            w.category_code                                         category_code_curr,
            LEAD(w.category_code)
                OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) category_code_next,
            -- operation
            LAG(r.oper_code)
                OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) oper_code_prev ,
            r.oper_code                                             oper_code_curr,
            LEAD(r.oper_code)
                OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) oper_code_next
    FROM        (SELECT DISTINCT group_code FROM VW_PREP_GROUP_CODE) g
    INNER JOIN  GROUP_ROUTING   r
                    ON r.group_code =   g.group_code
    INNER JOIN  WAREHOUSE       w
                    ON  w.whs_code  =   r.whs_cons
    ORDER BY group_code,seq_no
    ;

/*********************************************************************************
    DDL: 28/04/2008  z Create
    -- this gives the net flux that was allocated for a work order independently
    -- from tha case that those allocation were made in the stoc warehouses or
    -- were made with transfer movement into WIP
/*********************************************************************************/
CURSOR  C_ALLOCATED IS
                SELECT  --+ USE_NL(t m)
                        m.group_code,m.item_code,m.org_code,m.oper_code_item,
                        m.size_code,m.colour_code,
                        SUM(m.qty * m.trn_sign) qty
                FROM       (SELECT DISTINCT group_code FROM VW_PREP_GROUP_CODE)  t
                INNER JOIN  WHS_TRN_DETAIL      m
                                ON m.group_code     =   t.group_code
                INNER JOIN  WHS_TRN_REASON      r
                                ON  r.reason_code   =   m.reason_code
                WHERE       r.alloc_wo      =   'Y'
                GROUP BY    m.group_code,m.item_code,m.org_code,
                            m.oper_code_item,m.size_code,m.colour_code
                ;
    
/*********************************************************************************
    DDL: 29/04/2008  z Create
/*********************************************************************************/
CURSOR  C_GROUP_ORDER_SIZE(p_group_code VARCHAR2) IS
               SELECT      MAX(w.org_code)      org_code    ,
                           g.group_code                     ,
                           MAX(g.order_code)    order_code  ,
                           MAX(w.item_code)     item_code   ,
                           MAX(i.description)   description_item,
                           MAX(w.season_code)   season_code ,
                           MAX(i.puom)          puom        ,
                           d.size_code                      ,
                           MAX(d.qta)           qty
               ----
               FROM             WO_GROUP    g
               INNER    JOIN    WORK_ORDER  w
                                    ON  w.org_code      =   g.org_code
                                    AND w.order_code    =   g.order_code
               INNER    JOIN    WO_DETAIL   d
                                    ON  d.ref_wo        =   w.idriga
               INNER    JOIN    ITEM        i
                                    ON  i.org_code      =   w.org_code
                                    AND i.item_code     =   w.item_code
               ---
               WHERE   g.group_code    IN
                            (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_group_code) ))
               GROUP BY  w.idriga,g.group_code,d.size_code
               ORDER BY   g.group_code, MAX(g.order_code),d.size_code
               ; 

               
/*********************************************************************************
    DDL: 07/05/2008  z Create
/*********************************************************************************/                              
CURSOR  C_ACTIVE_ORDERS(p_org_code VARCHAR2, p_suppl_code VARCHAR2) IS
        SELECT DISTINCT r.group_code
        FROM        GROUP_ROUTING   r
        INNER JOIN  WORK_GROUP      g
                        ON  g.group_code    =   r.group_code
        INNER JOIN  WAREHOUSE       w
                        ON  w.whs_code      =   r.whs_cons
        WHERE       w.org_code      =   p_suppl_code
                AND g.org_code      =   p_org_code
                AND g.status        =   'L'
        ;                                           
               
/*********************************************************************************
    DDL: 29/04/2008  z Create
/*********************************************************************************/               
CURSOR  C_TRN_PLAN_DETAIL(p_ref_plan INTEGER) IS
            SELECT  COUNT(*)                        line_count
            FROM    TRN_PLAN_DETAIL  d
            WHERE   d.ref_plan   =   p_ref_plan
            ;
               
               
               
               
    
    
    
TYPE    type_rout1                  IS TABLE OF  C_GROUP_ROUTING%ROWTYPE    INDEX BY VARCHAR2(100);
TYPE    type_rout2                  IS TABLE OF  type_rout1    INDEX BY VARCHAR2(100);
TYPE    type_rout3                  IS TABLE OF  type_rout2    INDEX BY VARCHAR2(100);



TYPE typ_stoc                       IS TABLE OF NUMBER INDEX BY VARCHAR2(1000);
TYPE typ_vw_move                    IS TABLE OF VW_MOVEMENT%ROWTYPE INDEX BY BINARY_INTEGER;


PROCEDURE   p_get_next_doc_number (     p_doc_type          VARCHAR,
                                        p_org_code          VARCHAR2,
                                        p_num_year          VARCHAR2,
                                        p_next_doc_number   OUT NUMBER
                                        );


PROCEDURE p_check_date_legal            (p_date_legal DATE, p_note VARCHAR2 DEFAULT NULL);

PROCEDURE p_whs_trn_engine              ( p_row_trn       IN OUT WHS_TRN%ROWTYPE  );
PROCEDURE p_whs_trn_storno              (
                                            p_ref_trn           NUMBER,
                                            p_flag_commit       BOOLEAN
                                        );




PROCEDURE p_item_stoc               (   it_stoc         IN OUT Pkg_Mov.typ_stoc,
                                        p_item          VARCHAR2,
                                        p_org_code      VARCHAR2,
                                        p_whs_code      VARCHAR2    DEFAULT NULL,
                                        p_season_code   VARCHAR2    DEFAULT NULL,
                                        p_size_code     VARCHAR2    DEFAULT NULL,
                                        p_colour_code   VARCHAR2    DEFAULT NULL,
                                        p_oper_code     VARCHAR2    DEFAULT NULL
                                    );


PROCEDURE p_item_stoc               (   it_stoc         IN OUT NOCOPY Pkg_Glb.type_dim_10,
                                        p_item          VARCHAR2,
                                        p_org_code      VARCHAR2,
                                        p_whs_code      VARCHAR2    DEFAULT NULL,
                                        p_season_code   VARCHAR2    DEFAULT NULL,
                                        p_size_code     VARCHAR2    DEFAULT NULL,
                                        p_colour_code   VARCHAR2    DEFAULT NULL,
                                        p_oper_code     VARCHAR2    DEFAULT NULL
                                    );



FUNCTION  f_get_idx_item_stoc      (    p_whs_code      VARCHAR2,
                                        p_season_code   VARCHAR2,
                                        p_size_code     VARCHAR2    DEFAULT NULL,
                                        p_colour_code   VARCHAR2    DEFAULT NULL,
                                        p_oper_code     VARCHAR2    DEFAULT NULL,
                                        p_group_code    VARCHAR2    DEFAULT NULL,
                                        p_order_code    VARCHAR2    DEFAULT NULL
                                     )  RETURN VARCHAR2;

FUNCTION  f_item_stoc               (   it_stoc         IN Pkg_Mov.typ_stoc,
                                        p_whs_code      VARCHAR2,
                                        p_season_code   VARCHAR2,
                                        p_size_code     VARCHAR2    DEFAULT NULL,
                                        p_colour_code   VARCHAR2    DEFAULT NULL,
                                        p_oper_code     VARCHAR2    DEFAULT NULL,
                                        p_group_code    VARCHAR2    DEFAULT NULL,
                                        p_order_code    VARCHAR2    DEFAULT NULL
                                        ) RETURN NUMBER;





FUNCTION f_sql_trn_plan_header      (
                                        p_line_id       INTEGER ,
                                        p_org_code      VARCHAR2 DEFAULT NULL
                                    )  RETURN typ_longinfo  pipelined;
FUNCTION f_sql_trn_plan_detail      (   
                                        p_line_id   INTEGER,
                                        p_ref_plan  INTEGER  DEFAULT NULL
                                    )  RETURN typ_frm  pipelined;
PROCEDURE p_trn_plan_header_iud     (p_tip VARCHAR2, p_row TRN_PLAN_HEADER%ROWTYPE);
PROCEDURE p_trn_plan_header_blo     (p_tip VARCHAR2, p_row IN OUT TRN_PLAN_HEADER%ROWTYPE);
PROCEDURE p_trn_plan_detail_iud     (p_tip VARCHAR2, p_row TRN_PLAN_DETAIL%ROWTYPE);
PROCEDURE p_trn_plan_detail_blo     (   p_tip           VARCHAR2,
                                        p_row           IN OUT TRN_PLAN_DETAIL%ROWTYPE,
                                        p_check_only    IN VARCHAR2 DEFAULT  'N'
                                    );

PROCEDURE p_execute_trn_plan        ( p_idriga  INTEGER);
PROCEDURE p_ship_trn_plan           ( p_idriga  INTEGER);
PROCEDURE p_receive_trn_plan        ( p_idriga  INTEGER);


FUNCTION f_sql_whs_trn              (   p_org_code      VARCHAR2    ,
                                        p_trn_year      VARCHAR2    ,
                                        p_trn_type      VARCHAR2    ,
                                        p_start_date    DATE        ,
                                        p_end_date      DATE        )
                                        RETURN          typ_frm     pipelined;

FUNCTION f_sql_whs_trn_detail       (   p_ref_trn       INTEGER  ,
                                        p_show_user     VARCHAR2 
                                    )
                                        RETURN          typ_frm     pipelined;

FUNCTION f_sql_whs_situation            (   p_org_code          VARCHAR2,
                                            p_whs_code          VARCHAR2,
                                            p_season_code       VARCHAR2  )
                                            RETURN              typ_frm     pipelined;

PROCEDURE p_prepare_pick_plan_1         (   p_ref_plan              INTEGER,
                                            p_force_qty_pick_zero   VARCHAR2);

PROCEDURE p_prepare_pick_plan_2         (   p_ref_plan              INTEGER);

PROCEDURE p_prepare_pick_plan_3         (   p_ref_plan              INTEGER);


FUNCTION f_sql_pick_plan                (   p_ref_plan              INTEGER,
                                            p_force_qty_pick_zero   VARCHAR2
                                        )   RETURN                  typ_frm     pipelined;

PROCEDURE p_plan_from_picking           (   p_ref_plan          INTEGER);


PROCEDURE p_vw_prep_pick_plan_iud       (   p_tip               VARCHAR2,
                                            p_row               VW_PREP_PICK_PLAN%ROWTYPE);

PROCEDURE P_Stoc_Online                 (   p_org_code          VARCHAR2    ,
                                            p_item_code         VARCHAR2    DEFAULT NULL,
                                            p_group_code        VARCHAR2    DEFAULT NULL,
                                            p_whs_code          VARCHAR2    DEFAULT NULL,
                                            p_season_code       VARCHAR2    DEFAULT NULL
                                        );

PROCEDURE p_stoc_past                   (    p_org_code         VARCHAR2    ,
                                             p_item_code        VARCHAR2    DEFAULT NULL,
                                             p_group_code       VARCHAR2    DEFAULT NULL,
                                             p_whs_code         VARCHAR2    DEFAULT NULL,
                                             p_season_code      VARCHAR2    DEFAULT NULL,
                                             p_ref_date         DATE        DEFAULT NULL
                                         );
                                        
                                        
PROCEDURE p_storno                      (   p_ref_trn           NUMBER,
                                            p_commit            BOOLEAN,
                                            p_note              VARCHAR2    DEFAULT NULL                                           
                                        );

PROCEDURE p_whs_trn_blo                 (   p_tip               VARCHAR2,
                                            p_row   IN OUT      WHS_TRN%ROWTYPE
                                        );

PROCEDURE p_whs_trn_iud                 (   p_tip               VARCHAR2,
                                            p_row               WHS_TRN%ROWTYPE
                                        );


PROCEDURE p_distribute_pick_qty         (                                    
                                            p_seq_group         INTEGER ,
                                            p_whs_code          VARCHAR2,
                                            p_qty               NUMBER  ,
                                            p_flag_total_line   VARCHAR2   
                                        );       

                                        
                                        
                                        
END;
 

/

/
