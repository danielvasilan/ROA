--------------------------------------------------------
--  DDL for Package PKG_PROD
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_PROD" 
AS

/****************  ROUTING *****************************************************************/

FUNCTION f_sql_frm_rou_header               RETURN          typ_frm     pipelined;

FUNCTION f_sql_frm_rou_detail           (   p_routing_code  VARCHAR2)
                                            RETURN          typ_frm     pipelined;

PROCEDURE p_macrorouting_header_iud     (   p_tip   VARCHAR2,
                                            p_row   MACROROUTING_HEADER%ROWTYPE);

PROCEDURE p_macrorouting_detail_iud     (   p_tip   VARCHAR2,
                                            p_row   MACROROUTING_DETAIL%ROWTYPE);


FUNCTION f_get_routing_oper             (   p_routing_code  VARCHAR2)
                                            RETURN          VARCHAR2;

/****************  DPR   *******************************************************************/

FUNCTION f_get_dpr_qty                  (   it_dpr_qty      Pkg_Glb.typ_number_varchar,
                                            p_order_code    VARCHAR2,
                                            p_oper_code     VARCHAR2,
                                            p_size_code     VARCHAR2
                                        )   RETURN          NUMBER;

FUNCTION f_get_exp_qty                  (   it_exp_qty      Pkg_Glb.typ_number_varchar,
                                            p_org_code      VARCHAR2,
                                            p_order_code    VARCHAR2,
                                            p_size_code     VARCHAR2
                                        )   RETURN          NUMBER;


PROCEDURE   p_wo_get_prod_qty           (   p_org_code      VARCHAR2,
                                            p_order_code    VARCHAR2,
                                            it_prod_qty     OUT Pkg_Glb.typ_varchar_varchar
                                        );


PROCEDURE p_prep_grp_dpr_qty            (   p_group_code    VARCHAR2,
                                            p_oper_code     VARCHAR2
                                        );

PROCEDURE p_prep_ord_exp_qty            (   p_org_code      VARCHAR2,
                                            p_order_code    VARCHAR2
                                        );

PROCEDURE p_prep_ord_exp_qty            (   p_org_code              VARCHAR2,
                                            p_order_code            VARCHAR2,
                                            it_exp_qty      IN OUT  Pkg_Glb.typ_number_varchar
                                        );
                                        
PROCEDURE p_prep_ord_fin_qty            (   p_org_code      VARCHAR2,
                                            p_order_code    VARCHAR2
                                        );

PROCEDURE p_dpr_grp                     (   p_org_code      VARCHAR2,
                                            p_group_code    VARCHAR2,
                                            p_size_code     VARCHAR2,
                                            p_order_code    VARCHAR2,
                                            p_oper_code     VARCHAR2,
                                            p_employee_code VARCHAR2,
                                            p_wc_code       VARCHAR2,
                                            p_date_legal    DATE,
                                            p_qty           NUMBER
                                        );


FUNCTION f_sql_frm_dpr_list             (   p_org_code      VARCHAR2
                                        )   RETURN          typ_frm         pipelined;

FUNCTION f_sql_frm_dpr_dpr              (   p_org_code      VARCHAR2,
                                            p_group_code    VARCHAR2,
                                            p_order_code    VARCHAR2,
                                            p_oper_code     VARCHAR2
                                        )   RETURN          typ_frm     pipelined;
                                        
FUNCTION f_sql_frm_dpr_hist             (   p_org_code      VARCHAR2, 
                                            p_group_code    VARCHAR2
                                        )   RETURN          typ_frm     pipelined;
                                        

PROCEDURE p_dpr_manual                  (   p_org_code      VARCHAR2,
                                            p_group_code    VARCHAR2,
                                            p_oper_code     VARCHAR2,
                                            p_wc_code       VARCHAR2,
                                            p_employee_code VARCHAR2,
                                            p_date_legal    DATE
                                        );

PROCEDURE p_dpr_undo                    (   p_row_trh       WHS_TRN%ROWTYPE,
                                            p_commit        BOOLEAN
                                        );

FUNCTION f_format_half_size             (   p_size_code     VARCHAR2,
                                            p_org_code      VARCHAR2
                                        )
                                            RETURN          VARCHAR2;


PROCEDURE p_rep_ac_wip                  (   p_year_month    VARCHAR2, 
                                            p_org_code      VARCHAR2);
                                            
PROCEDURE p_rep_ac_wip_io               (   p_org_code      VARCHAR2, 
                                            p_date_ini      DATE    , 
                                            p_date_end      DATE    ,
                                            p_oper_code     VARCHAR2,
                                            p_whs_code      VARCHAR2);

PROCEDURE p_rep_wip                     (   p_org_code      VARCHAR2, 
                                            p_year_month    VARCHAR2);

PROCEDURE p_rep_wip_grouped             (   p_org_code      VARCHAR2, 
                                            p_year_month    VARCHAR2,
                                            p_grp_by_wo     VARCHAR2    DEFAULT 'N');

                                            
PROCEDURE   p_rep_daily_prod            (   p_org_code      VARCHAR2, 
                                            p_dpr_date      DATE,
                                            p_season_code   VARCHAR2,
                                            p_status        VARCHAR2,
                                            p_root_code     VARCHAR2);


PROCEDURE p_rep_prod_period             (   p_org_code      VARCHAR2, 
                                            p_start_date    DATE, 
                                            p_end_date      DATE, 
                                            p_oper_code     VARCHAR2,
                                            p_per_type      VARCHAR2);

PROCEDURE p_rep_order_situation         (   p_org_code      VARCHAR2, 
                                            p_season_code   VARCHAR2);
                                            
                                            
-- This cursor returns info about a GROUP ROUTING operation
--  including
    CURSOR C_INFO_OPER  (   p_ref_group     VARCHAR2,
                            p_oper_code     VARCHAR2)
                        IS
                        SELECT      A.*
                        FROM
                            (
                            SELECT      lag (r.oper_code) OVER(ORDER BY r.seq_no) prev_oper,
                                        lead(r.oper_code) OVER(ORDER BY r.seq_no) next_oper,
                                        r.oper_code         ,
                                        r.whs_cons          ,
                                        r.whs_dest          ,
                                        r.workcenter_code   ,
                                        r.milestone         ,
                                        r.seq_no            ,
                                        w.costcenter_code   ,
                                        w.description       wc_description,
                                        w.whs_code          ,
                                        wh.description      wh_description,
                                        c.org_code
                            ---------------------------------------------------------
                            FROM        GROUP_ROUTING       r
                            LEFT JOIN   WORKCENTER          w   ON  w.workcenter_code   =   r.workcenter_code
                            LEFT JOIN   COSTCENTER          c   ON  c.costcenter_code   =   w.costcenter_code
                            LEFT JOIN   WAREHOUSE           wh  ON  wh.whs_code         =   w.whs_code
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


END;
 

/

/
