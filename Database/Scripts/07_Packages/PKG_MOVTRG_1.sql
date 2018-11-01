--------------------------------------------------------
--  DDL for Package Body PKG_MOVTRG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_MOVTRG" AS

TYPE typ_stk_n IS TABLE OF STOCK_ONLINE%ROWTYPE INDEX BY BINARY_INTEGER; 
it_stk typ_stk_n;

/***********************************************************************************
    DDL: 18/06/2010 Daniel V create procedure 
    Purpose: used by WHS_TRN_DETAIL trigger to compute diff between old and new 
        prepairing the update of STOCK_ONLINE table 
/***********************************************************************************/
PROCEDURE p_trg_stk_add (   p_new   WHS_TRN_DETAIL%ROWTYPE, 
                            p_old   WHS_TRN_DETAIL%ROWTYPE,
                            p_tip   VARCHAR2)
IS
    v_rw_stk    STOCK_ONLINE%ROWTYPE;
BEGIN
    IF p_tip IN ('I', 'U') THEN
        v_rw_stk.org_code       :=  p_new.org_code;
        v_rw_stk.item_code      :=  p_new.item_code;
        v_rw_stk.oper_code_item :=  p_new.oper_code_item;
        v_rw_stk.colour_code    :=  p_new.colour_code;
        v_rw_stk.size_code      :=  p_new.size_code;
        v_rw_stk.season_code    :=  p_new.season_code;
        v_rw_stk.whs_code       :=  p_new.whs_code;
        v_rw_stk.order_code     :=  p_new.order_code;
        v_rw_stk.group_code     :=  p_new.group_code;
        v_rw_stk.qty            :=  p_new.qty * p_new.trn_sign;
        it_stk(it_stk.count + 1) := v_rw_stk;
    END IF; 
    IF p_tip IN ('D', 'U') THEN
        v_rw_stk.org_code       :=  p_old.org_code;
        v_rw_stk.item_code      :=  p_old.item_code;
        v_rw_stk.oper_code_item :=  p_old.oper_code_item;
        v_rw_stk.colour_code    :=  p_old.colour_code;
        v_rw_stk.size_code      :=  p_old.size_code;
        v_rw_stk.season_code    :=  p_old.season_code;
        v_rw_stk.whs_code       :=  p_old.whs_code;
        v_rw_stk.order_code     :=  p_old.order_code;
        v_rw_stk.group_code     :=  p_old.group_code;
        v_rw_stk.qty            :=  (-1) * p_old.qty * p_old.trn_sign;
        it_stk(it_stk.count + 1) := v_rw_stk;
    END IF; 
END;

PROCEDURE p_trg_stk_ini 
IS
BEGIN
    it_stk.delete;
END;

PROCEDURE p_trg_stk_apply
IS
    it_org  Pkg_Glb.typ_string;
    it_itm  Pkg_Glb.typ_string;
    it_opr  Pkg_Glb.typ_string;
    it_col  Pkg_Glb.typ_string;
    it_siz  Pkg_Glb.typ_string;
    it_whs  Pkg_Glb.typ_string;
    it_sea  Pkg_Glb.typ_string;
    it_ord  Pkg_Glb.typ_string;
    it_grp  Pkg_Glb.typ_string;
    it_qty  Pkg_Glb.typ_number;
    
BEGIN

    FOR i In 1..it_stk.count 
    LOOP
        it_org(i)   :=  it_stk(i).org_code;
        it_itm(i)   :=  it_stk(i).item_code;
        it_opr(i)   :=  it_stk(i).oper_code_item;
        it_col(i)   :=  it_stk(i).colour_code;
        it_siz(i)   :=  it_stk(i).size_code;
        it_whs(i)   :=  it_stk(i).whs_code;
        it_sea(i)   :=  it_stk(i).season_code;
        it_ord(i)   :=  it_stk(i).order_code;
        it_grp(i)   :=  it_stk(i).group_code;
        it_qty(i)   :=  it_stk(i).qty;
    END LOOP;

    FORALL i IN 1..it_org.COUNT
        MERGE INTO STOCK_ONLINE a
        USING   (SELECT it_org(i)   org_code,
                        it_itm(i)   item_code,
                        it_opr(i)   oper_code_item,
                        it_col(i)   colour_code,
                        it_siz(i)   size_code,
                        it_whs(i)   whs_code,
                        it_sea(i)   season_code,
                        it_ord(i)   order_code,
                        it_grp(i)   group_code,
                        it_qty(i)   qty
                FROM dual) x
        ON (
                a.org_code          =   x.org_code
            AND a.item_code         =   x.item_code
            AND a.whs_code          =   x.whs_code
            AND a.season_code       =   x.season_code
            AND Pkg_Lib.f_diff_c(a.oper_code_item, x.oper_code_item) = 0
            AND Pkg_Lib.f_diff_c(a.colour_code,  x.colour_code) = 0
            AND Pkg_Lib.f_diff_c(a.size_code, x.size_code) = 0
            AND Pkg_Lib.f_diff_c(a.order_code, x.order_code) = 0
            AND Pkg_Lib.f_diff_c(a.group_code, x.group_code) = 0
            )
        WHEN MATCHED THEN UPDATE SET a.qty = a.qty + x.qty
        DELETE WHERE a.qty = 0
        WHEN NOT MATCHED THEN INSERT
            (   a.org_code, a.item_code, a.oper_code_item, a.colour_code, a.size_code,
                a.whs_code, a.season_code, a.order_code, a.group_code, a.qty)
        VALUES  
            (   x.org_code, x.item_code, x.oper_code_item, x.colour_code, x.size_code,
                x.whs_code, x.season_code, x.order_code, x.group_code, x.qty)
        ;
END;


END;

/

/
