--------------------------------------------------------
--  DDL for Package PKG_ORDER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_ORDER" 
IS

    TYPE typ_routing                            IS TABLE OF GROUP_ROUTING%ROWTYPE INDEX BY BINARY_INTEGER;

    CURSOR C_WG_INFO    (   p_group_code    VARCHAR2)
                        IS
                        SELECT      gr.seq_no,
                                    gr.oper_code             ,
                                    COUNT(DISTINCT wg.order_code)
                                                            order_no,
                                    SUM(d.qta)              nom_qty
                        -----------------------------------------------------------------------------
                        FROM        WORK_GROUP          g
                        INNER JOIN  WO_GROUP            wg  ON  wg.group_code   =   g.group_code
                        INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   wg.org_code
                                                            AND o.order_code    =   wg.order_code
                        LEFT JOIN   WO_DETAIL           d   ON  d.ref_wo        =   o.idriga
                        INNER JOIN  GROUP_ROUTING       gr  ON  gr.ref_group    =   g.idriga
                                                            AND gr.oper_code    =   wg.oper_code
                        -----------------------------------------------------------------------------
                        WHERE       g.group_code       =   p_group_code
                        GROUP BY    gr.seq_no,gr.oper_code
                        ORDER BY    1
                        ;


CURSOR  C_GROUP_CONSUM  (   p_idriga NUMBER) --RETURN Pkg_Order.C_GROUP_CONSUM%ROWTYPE;/*
                        IS
                        ---------------------------------------------------------------------------------
                        SELECT      b.child_code                                item_code,
                                    MAX(i.description)                          description,
                                    b.org_code                                  org_code,
                                    DECODE(i.flag_size,-1, d.size_code,NULL)    size_code,
                                    MIN(NVL(b.start_size, i.start_size))        start_size,
                                    MAX(NVL(b.end_size ,  i.end_size ))         end_size,
                                    b.colour_code                               colour_code,
                                    SUM(d.qta * b.qta)                          qta,
                                    NVL(b.oper_code,i.oper_code)                oper_code,
                                    MAX(b.note)                                 note
                        -------------------------------------------------------------------------------
                        FROM        WORK_GROUP      g
                        INNER JOIN  WO_GROUP        wg  ON  g.group_code    = wg.group_code
                        INNER JOIN  WORK_ORDER      w   ON  w.order_code    = wg.order_code
                                                        AND w.org_code      = wg.org_code
                        INNER JOIN  WO_DETAIL       d   ON  d.ref_wo        = w.idriga
                        INNER JOIN  BOM_STD         b   ON  b.org_code      = w.org_code
                                                        AND b.father_code   = w.item_code
                        INNER JOIN  ITEM            i   ON  i.org_code      = b.org_code
                                                        AND i.item_code     = b.child_code
                        ------------------------------------------------------------------------------
                        WHERE       g.idriga        =   p_idriga
                                    -- daca componenta este pe plaja de marime ramane numai aceea pentru care marimea perechii se incadreaza in plaja
                                    -- are prioritate plaja precizata in norma standard, un cod pe norme standard diferite pot sa aiba plaje diferite
                                AND d.size_code    BETWEEN  NVL(NVL(b.start_size,i.start_size) ,  Pkg_Glb.C_SIZE_MIN  )
                                                    AND     NVL(NVL(b.end_size,i.end_size)  , Pkg_Glb.C_SIZE_MAX )
                                AND NVL(b.oper_code,i.oper_code)     = wg.oper_code
                        ------------------------------------------------------------------------------
                        GROUP BY    b.child_code, b.org_code,
                                    NVL(b.oper_code,i.oper_code),
                                    -- daca codul este controlat pe marime se face gruparea pe marime altfel se face abstarctie de marime
                                    DECODE(i.flag_size,-1, d.size_code,NULL),
                                    b.colour_code
                        ------------------------------------------------------------------------------
                        ORDER BY    b.child_code
                        ;

-- used functions
FUNCTION f_demand_for_item              (   p_org_code      VARCHAR2,
                                            p_item_code     VARCHAR2,
                                            p_season_code   VARCHAR2,
                                            p_size_code     VARCHAR2,
                                            p_colour_code   VARCHAR2,
                                            p_type          VARCHAR2
                                        )   RETURN NUMBER;

FUNCTION f_exists_material_for_group    (   p_idriga            WO_GROUP.idriga%TYPE,
                                            p_type              VARCHAR2
                                        )   RETURN              INTEGER;

FUNCTION f_get_default_season           (   p_org_code          VARCHAR2    )
                                            RETURN              VARCHAR2;

FUNCTION f_get_default_whs_fin          (   p_org_code          VARCHAR2    )
                                            RETURN              VARCHAR2;


FUNCTION f_get_routing_prev_oper        (   p_routing_code      VARCHAR2,
                                            p_oper_code         VARCHAR2
                                        )   RETURN              VARCHAR2;

FUNCTION    f_rout_get_oper_seq         (   p_routing_code      VARCHAR2,
                                            p_oper_code         VARCHAR2
                                        )   RETURN              NUMBER;

FUNCTION f_str_wo_associated_groups     (   p_org_code          VARCHAR2,
                                            p_order_code        VARCHAR2
                                        )   RETURN              VARCHAR2;

FUNCTION f_str_grp_routing              (   p_ref_group         NUMBER          )
                                            RETURN              VARCHAR2;

FUNCTION f_str_grp_rout_loc             (   p_ref_group         NUMBER,
                                            p_milestone         VARCHAR2
                                        )   RETURN              VARCHAR2;


-- WORK ORDER management
PROCEDURE p_ord_duplicate               (   p_idriga            NUMBER,
                                            p_order_code        VARCHAR2,
                                            p_flag_detail       VARCHAR2        );

-- GROUP MANAGEMENT
PROCEDURE p_grp_generate                (   p_org_code          VARCHAR2,
                                            p_season_code       VARCHAR2,
                                            p_start_oper        VARCHAR2,
                                            p_end_oper          VARCHAR2,
                                            p_org_code_work     VARCHAR2,
                                            p_flag_validate     BOOLEAN,
                                            p_flag_launch       BOOLEAN,
                                            p_flag_commit       BOOLEAN);

PROCEDURE p_grp_associate_undo          (   p_group_code        VARCHAR2,
                                            p_flag_commit       BOOLEAN);

PROCEDURE p_grp_generate_bom            (   p_row_grp           WORK_GROUP%ROWTYPE,
                                            p_regenerate        BOOLEAN,
                                            p_commit            BOOLEAN,
                                            p_apply             BOOLEAN         );

PROCEDURE p_grp_generate_bom            (   p_group_code        WORK_GROUP.group_code%TYPE,
                                            p_regenerate        BOOLEAN,
                                            p_commit            BOOLEAN,
                                            p_apply             BOOLEAN
                                        );

PROCEDURE p_grp_authorize               (   p_idriga            WORK_GROUP.idriga%TYPE);

PROCEDURE p_grp_authorize_undo          (   p_idriga            WORK_GROUP.idriga%TYPE );

PROCEDURE p_grp_validate                (   p_group_code        VARCHAR2,
                                            p_flag_commit       BOOLEAN);

PROCEDURE p_grp_validate_undo           (   p_group_code        VARCHAR2,
                                            p_flag_commit       BOOLEAN);

PROCEDURE p_grp_launch                  (   p_group_code        VARCHAR2,
                                            p_flag_commit       BOOLEAN);

PROCEDURE p_grp_launch_undo             (   p_group_code        VARCHAR2,
                                            p_flag_commit       BOOLEAN);

PROCEDURE p_grp_associate_checks        (   p_start_oper        VARCHAR2,
                                            p_end_oper          VARCHAR2,
                                            p_flag_rae          BOOLEAN);

PROCEDURE p_group_routing_iud           (   p_tip               VARCHAR2,
                                            p_row               GROUP_ROUTING%ROWTYPE   );

PROCEDURE p_bom_group_iud               (   p_tip               VARCHAR2,
                                            p_row               BOM_GROUP%ROWTYPE       );



PROCEDURE p_prepare_work_order          (   p_line_id           NUMBER,
                                            p_org_code          VARCHAR2,
                                            p_season_code       VARCHAR2,
                                            p_status            VARCHAR2);


FUNCTION f_sql_sk_work_order            (   p_line_id           NUMBER,
                                            p_org_code          VARCHAR2,
                                            p_season_code       VARCHAR2,
                                            p_status            VARCHAR2
                                        )   RETURN              typ_longinfo    pipelined;

PROCEDURE p_prepare_work_group          (   p_org_code          VARCHAR2,
                                            p_season_code       VARCHAR2,
                                            p_status            VARCHAR2);

FUNCTION f_sql_sk_work_group            (   p_org_code          VARCHAR2,
                                            p_status            VARCHAR2,
                                            p_season_code       VARCHAR2
                                        )   RETURN              typ_frm         pipelined;


FUNCTION f_sql_sk_work_order_s4         (   p_ref_wo            INTEGER)
                                            RETURN              typ_frm         pipelined;

FUNCTION f_sql_sk_item_size                 RETURN              typ_longinfo    pipelined;

PROCEDURE p_wo_detail_iud               (   p_tip               VARCHAR2,
                                            p_row               WO_DETAIL%ROWTYPE   );

PROCEDURE p_work_order_iud              (   p_tip               VARCHAR2,
                                            p_row               WORK_ORDER%ROWTYPE  );

FUNCTION f_sql_sk_grp_assoc_wo          (   p_group_code        VARCHAR2)
                                            RETURN              typ_frm         pipelined;

FUNCTION f_sql_sk_grp_rout              (   p_line_id           NUMBER,
                                            p_ref_group         NUMBER)
                                            RETURN              typ_frm         pipelined;

FUNCTION f_sql_sk_grp_bom               (   p_line_id           NUMBER,
                                            p_ref_group         NUMBER)
                                            RETURN              typ_frm         pipelined;

PROCEDURE p_prep_grp_nom_qty            (   p_group_code        VARCHAR2,
                                            p_oper_code         VARCHAR2);


FUNCTION f_get_default_whs_cons         (   p_org_code          VARCHAR2)
                                            RETURN              VARCHAR2;


PROCEDURE p_bom_range_distribution      (   p_org_code          VARCHAR2,
                                            p_item_code         VARCHAR2,
                                            p_start_size        VARCHAR2,
                                            p_end_size          VARCHAR2);

PROCEDURE p_work_group_iud              (   p_tip               VARCHAR2,
                                            p_row               WORK_GROUP%ROWTYPE);


PROCEDURE p_rep_grp_sheet               (   p_group_code        VARCHAR2);
PROCEDURE p_rep_grp_sheet               (   p_ref_group         NUMBER);

PROCEDURE p_ord_validate                (   p_ref_ord           NUMBER,
                                            p_org_code_work     VARCHAR2);

PROCEDURE p_ord_validate_undo           (   p_ref_ord           NUMBER);

PROCEDURE p_ord_launch                  (   p_ref_ord           NUMBER);

PROCEDURE p_ord_launch_undo             (   p_ref_ord           NUMBER);


FUNCTION f_ord_get_ref_group            (   p_org_code          VARCHAR2,
                                            p_order_code        VARCHAR2)
                                            RETURN              NUMBER;

PROCEDURE p_grp_bom_distribution        (   p_group_code        VARCHAR2,
                                            p_start_size        VARCHAR2,
                                            p_end_size          VARCHAR2);

PROCEDURE p_prep_work_demand            (   p_org_code          VARCHAR2,
                                            p_season_code       VARCHAR2);


PROCEDURE p_rep_work_demand             (   p_org_code          VARCHAR2,
                                            p_season_code       VARCHAR2);


PROCEDURE p_rep_ord_label               (   p_org_code          VARCHAR2,
                                            p_order_code        VARCHAR2);

PROCEDURE p_ord_close                   (   p_org_code          VARCHAR2,
                                            p_order_code        VARCHAR2,
                                            p_force             VARCHAR2);


FUNCTION f_chk_order_in_group           (   p_org_code          VARCHAR2,
                                            p_order_code        VARCHAR2,
                                            p_group_code        VARCHAR2
                                        )   RETURN              VARCHAR2;

PROCEDURE p_rep_grplist_sheet           (   p_group_list        VARCHAR2);

PROCEDURE p_rep_grplist_sheet           ;

PROCEDURE p_ord_close_undo  (   p_org_code      VARCHAR2,
                                p_order_code    VARCHAR2,
                                p_force         VARCHAR2);

END;

/

/
