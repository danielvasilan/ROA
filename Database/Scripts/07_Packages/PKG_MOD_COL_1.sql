--------------------------------------------------------
--  DDL for Package Body PKG_MOD_COL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_MOD_COL" 
IS 
--------------------------------------------------------------------
FUNCTION f_acrec_detail(p_row_old ACREC_DETAIL%ROWTYPE, p_row_new ACREC_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CODE,p_row_new.CUSTOM_CODE) THEN 
      v_result    :=  v_result||'CUSTOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION_ITEM,p_row_new.DESCRIPTION_ITEM) THEN 
      v_result    :=  v_result||'DESCRIPTION_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FAMILY_CODE,p_row_new.FAMILY_CODE) THEN 
      v_result    :=  v_result||'FAMILY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_DOC,p_row_new.QTY_DOC) THEN 
      v_result    :=  v_result||'QTY_DOC'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_ACREC,p_row_new.REF_ACREC) THEN 
      v_result    :=  v_result||'REF_ACREC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ROUTING_CODE,p_row_new.ROUTING_CODE) THEN 
      v_result    :=  v_result||'ROUTING_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.UNIT_PRICE,p_row_new.UNIT_PRICE) THEN 
      v_result    :=  v_result||'UNIT_PRICE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM,p_row_new.UOM) THEN 
      v_result    :=  v_result||'UOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_acrec_header(p_row_old ACREC_HEADER%ROWTYPE, p_row_new ACREC_HEADER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACREC_CODE,p_row_new.ACREC_CODE) THEN 
      v_result    :=  v_result||'ACREC_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.ACREC_DATE,p_row_new.ACREC_DATE) THEN 
      v_result    :=  v_result||'ACREC_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ACREC_TYPE,p_row_new.ACREC_TYPE) THEN 
      v_result    :=  v_result||'ACREC_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ACREC_YEAR,p_row_new.ACREC_YEAR) THEN 
      v_result    :=  v_result||'ACREC_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_CODE,p_row_new.CURRENCY_CODE) THEN 
      v_result    :=  v_result||'CURRENCY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESTIN_CODE,p_row_new.DESTIN_CODE) THEN 
      v_result    :=  v_result||'DESTIN_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DUE_DATE,p_row_new.DUE_DATE) THEN 
      v_result    :=  v_result||'DUE_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMPLOYEE_CODE,p_row_new.EMPLOYEE_CODE) THEN 
      v_result    :=  v_result||'EMPLOYEE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INCOTERM,p_row_new.INCOTERM) THEN 
      v_result    :=  v_result||'INCOTERM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_BILLTO,p_row_new.ORG_BILLTO) THEN 
      v_result    :=  v_result||'ORG_BILLTO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CLIENT,p_row_new.ORG_CLIENT) THEN 
      v_result    :=  v_result||'ORG_CLIENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_DELIVERY,p_row_new.ORG_DELIVERY) THEN 
      v_result    :=  v_result||'ORG_DELIVERY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PAYMANT_COND,p_row_new.PAYMANT_COND) THEN 
      v_result    :=  v_result||'PAYMANT_COND'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PAYMANT_TYPE,p_row_new.PAYMANT_TYPE) THEN 
      v_result    :=  v_result||'PAYMANT_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PROTOCOL_CODE,p_row_new.PROTOCOL_CODE) THEN 
      v_result    :=  v_result||'PROTOCOL_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.PROTOCOL_DATE,p_row_new.PROTOCOL_DATE) THEN 
      v_result    :=  v_result||'PROTOCOL_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRUCK_NUMBER,p_row_new.TRUCK_NUMBER) THEN 
      v_result    :=  v_result||'TRUCK_NUMBER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.VAT_CODE,p_row_new.VAT_CODE) THEN 
      v_result    :=  v_result||'VAT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_ac_account(p_row_old AC_ACCOUNT%ROWTYPE, p_row_new AC_ACCOUNT%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNT_CODE,p_row_new.ACCOUNT_CODE) THEN 
      v_result    :=  v_result||'ACCOUNT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FATHER_CODE,p_row_new.FATHER_CODE) THEN 
      v_result    :=  v_result||'FATHER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_ac_detail(p_row_old AC_DETAIL%ROWTYPE, p_row_new AC_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNT_CODE,p_row_new.ACCOUNT_CODE) THEN 
      v_result    :=  v_result||'ACCOUNT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_DOC,p_row_new.QTY_DOC) THEN 
      v_result    :=  v_result||'QTY_DOC'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_DOC_PUOM,p_row_new.QTY_DOC_PUOM) THEN 
      v_result    :=  v_result||'QTY_DOC_PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_PUOM,p_row_new.QTY_PUOM) THEN 
      v_result    :=  v_result||'QTY_PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_AC,p_row_new.REF_AC) THEN 
      v_result    :=  v_result||'REF_AC'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_TRN_DETAIL,p_row_new.REF_TRN_DETAIL) THEN 
      v_result    :=  v_result||'REF_TRN_DETAIL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.TRN_SIGN,p_row_new.TRN_SIGN) THEN 
      v_result    :=  v_result||'TRN_SIGN'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.UNIT_PRICE,p_row_new.UNIT_PRICE) THEN 
      v_result    :=  v_result||'UNIT_PRICE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.UNIT_PRICE_PUOM,p_row_new.UNIT_PRICE_PUOM) THEN 
      v_result    :=  v_result||'UNIT_PRICE_PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM,p_row_new.UOM) THEN 
      v_result    :=  v_result||'UOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_ac_document(p_row_old AC_DOCUMENT%ROWTYPE, p_row_new AC_DOCUMENT%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_TYPE,p_row_new.DOC_TYPE) THEN 
      v_result    :=  v_result||'DOC_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REPORT_OBJECT,p_row_new.REPORT_OBJECT) THEN 
      v_result    :=  v_result||'REPORT_OBJECT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_ac_header(p_row_old AC_HEADER%ROWTYPE, p_row_new AC_HEADER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_CODE,p_row_new.CURRENCY_CODE) THEN 
      v_result    :=  v_result||'CURRENCY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_LEGAL,p_row_new.DATE_LEGAL) THEN 
      v_result    :=  v_result||'DATE_LEGAL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_CODE,p_row_new.DOC_CODE) THEN 
      v_result    :=  v_result||'DOC_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_TYPE,p_row_new.DOC_TYPE) THEN 
      v_result    :=  v_result||'DOC_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_YEAR,p_row_new.DOC_YEAR) THEN 
      v_result    :=  v_result||'DOC_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMPLOYEE_CODE_IN,p_row_new.EMPLOYEE_CODE_IN) THEN 
      v_result    :=  v_result||'EMPLOYEE_CODE_IN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMPLOYEE_CODE_OUT,p_row_new.EMPLOYEE_CODE_OUT) THEN 
      v_result    :=  v_result||'EMPLOYEE_CODE_OUT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REF_DOC_CODE,p_row_new.REF_DOC_CODE) THEN 
      v_result    :=  v_result||'REF_DOC_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.REF_DOC_DATE,p_row_new.REF_DOC_DATE) THEN 
      v_result    :=  v_result||'REF_DOC_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REF_DOC_TYPE,p_row_new.REF_DOC_TYPE) THEN 
      v_result    :=  v_result||'REF_DOC_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REF_DOC_YEAR,p_row_new.REF_DOC_YEAR) THEN 
      v_result    :=  v_result||'REF_DOC_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REF_ORG_CODE,p_row_new.REF_ORG_CODE) THEN 
      v_result    :=  v_result||'REF_ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_TRN,p_row_new.REF_TRN) THEN 
      v_result    :=  v_result||'REF_TRN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_ac_period(p_row_old AC_PERIOD%ROWTYPE, p_row_new AC_PERIOD%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.END_DATE,p_row_new.END_DATE) THEN 
      v_result    :=  v_result||'END_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PERIOD_CODE,p_row_new.PERIOD_CODE) THEN 
      v_result    :=  v_result||'PERIOD_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PERIOD_TYPE,p_row_new.PERIOD_TYPE) THEN 
      v_result    :=  v_result||'PERIOD_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.START_DATE,p_row_new.START_DATE) THEN 
      v_result    :=  v_result||'START_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_app_doc_number(p_row_old APP_DOC_NUMBER%ROWTYPE, p_row_new APP_DOC_NUMBER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DOC_SUBTYPE,p_row_new.DOC_SUBTYPE) THEN 
      v_result    :=  v_result||'DOC_SUBTYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_TYPE,p_row_new.DOC_TYPE) THEN 
      v_result    :=  v_result||'DOC_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUM_CURRENT,p_row_new.NUM_CURRENT) THEN 
      v_result    :=  v_result||'NUM_CURRENT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUM_END,p_row_new.NUM_END) THEN 
      v_result    :=  v_result||'NUM_END'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUM_LENGHT,p_row_new.NUM_LENGHT) THEN 
      v_result    :=  v_result||'NUM_LENGHT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUM_PREFIX,p_row_new.NUM_PREFIX) THEN 
      v_result    :=  v_result||'NUM_PREFIX'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUM_START,p_row_new.NUM_START) THEN 
      v_result    :=  v_result||'NUM_START'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUM_YEAR,p_row_new.NUM_YEAR) THEN 
      v_result    :=  v_result||'NUM_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_app_user(p_row_old APP_USER%ROWTYPE, p_row_new APP_USER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DEFAULT_OPER,p_row_new.DEFAULT_OPER) THEN 
      v_result    :=  v_result||'DEFAULT_OPER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUME,p_row_new.NUME) THEN 
      v_result    :=  v_result||'NUME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PAIRS_PER_DAY,p_row_new.PAIRS_PER_DAY) THEN 
      v_result    :=  v_result||'PAIRS_PER_DAY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PRENUME,p_row_new.PRENUME) THEN 
      v_result    :=  v_result||'PRENUME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PWD,p_row_new.PWD) THEN 
      v_result    :=  v_result||'PWD'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.USER_CODE,p_row_new.USER_CODE) THEN 
      v_result    :=  v_result||'USER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_app_user_grant(p_row_old APP_USER_GRANT%ROWTYPE, p_row_new APP_USER_GRANT%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_DELETE,p_row_new.FLAG_DELETE) THEN 
      v_result    :=  v_result||'FLAG_DELETE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_EXECUTE,p_row_new.FLAG_EXECUTE) THEN 
      v_result    :=  v_result||'FLAG_EXECUTE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_INSERT,p_row_new.FLAG_INSERT) THEN 
      v_result    :=  v_result||'FLAG_INSERT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_UPDATE,p_row_new.FLAG_UPDATE) THEN 
      v_result    :=  v_result||'FLAG_UPDATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SECURITEM_CODE,p_row_new.SECURITEM_CODE) THEN 
      v_result    :=  v_result||'SECURITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.USER_CODE,p_row_new.USER_CODE) THEN 
      v_result    :=  v_result||'USER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_bom_group(p_row_old BOM_GROUP%ROWTYPE, p_row_new BOM_GROUP%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.END_SIZE,p_row_new.END_SIZE) THEN 
      v_result    :=  v_result||'END_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA,p_row_new.QTA) THEN 
      v_result    :=  v_result||'QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_DEMAND,p_row_new.QTA_DEMAND) THEN 
      v_result    :=  v_result||'QTA_DEMAND'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_PICKED,p_row_new.QTA_PICKED) THEN 
      v_result    :=  v_result||'QTA_PICKED'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_GROUP,p_row_new.REF_GROUP) THEN 
      v_result    :=  v_result||'REF_GROUP'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SCRAP_PERC,p_row_new.SCRAP_PERC) THEN 
      v_result    :=  v_result||'SCRAP_PERC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.START_SIZE,p_row_new.START_SIZE) THEN 
      v_result    :=  v_result||'START_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_SUPPLY,p_row_new.WHS_SUPPLY) THEN 
      v_result    :=  v_result||'WHS_SUPPLY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_bom_std(p_row_old BOM_STD%ROWTYPE, p_row_new BOM_STD%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CHILD_CODE,p_row_new.CHILD_CODE) THEN 
      v_result    :=  v_result||'CHILD_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.END_SIZE,p_row_new.END_SIZE) THEN 
      v_result    :=  v_result||'END_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FATHER_CODE,p_row_new.FATHER_CODE) THEN 
      v_result    :=  v_result||'FATHER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA,p_row_new.QTA) THEN 
      v_result    :=  v_result||'QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_STD,p_row_new.QTA_STD) THEN 
      v_result    :=  v_result||'QTA_STD'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.START_SIZE,p_row_new.START_SIZE) THEN 
      v_result    :=  v_result||'START_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_bom_wo(p_row_old BOM_WO%ROWTYPE, p_row_new BOM_WO%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_TYPE,p_row_new.FLAG_TYPE) THEN 
      v_result    :=  v_result||'FLAG_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA,p_row_new.QTA) THEN 
      v_result    :=  v_result||'QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_PICKED,p_row_new.QTA_PICKED) THEN 
      v_result    :=  v_result||'QTA_PICKED'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_WO,p_row_new.REF_WO) THEN 
      v_result    :=  v_result||'REF_WO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_SUPPLY,p_row_new.WHS_SUPPLY) THEN 
      v_result    :=  v_result||'WHS_SUPPLY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WIP_SUPPLY,p_row_new.WIP_SUPPLY) THEN 
      v_result    :=  v_result||'WIP_SUPPLY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_calendar(p_row_old CALENDAR%ROWTYPE, p_row_new CALENDAR%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_d(p_row_old.CALENDAR_DAY,p_row_new.CALENDAR_DAY) THEN 
      v_result    :=  v_result||'CALENDAR_DAY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_WORK,p_row_new.FLAG_WORK) THEN 
      v_result    :=  v_result||'FLAG_WORK'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_cat_custom(p_row_old CAT_CUSTOM%ROWTYPE, p_row_new CAT_CUSTOM%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CODE,p_row_new.CUSTOM_CODE) THEN 
      v_result    :=  v_result||'CUSTOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.CUSTOM_TAX,p_row_new.CUSTOM_TAX) THEN 
      v_result    :=  v_result||'CUSTOM_TAX'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_cat_mat_type(p_row_old CAT_MAT_TYPE%ROWTYPE, p_row_new CAT_MAT_TYPE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CATEGORY,p_row_new.CATEGORY) THEN 
      v_result    :=  v_result||'CATEGORY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CATEG_CODE,p_row_new.CATEG_CODE) THEN 
      v_result    :=  v_result||'CATEG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FIFO_ROUND_UNIT,p_row_new.FIFO_ROUND_UNIT) THEN 
      v_result    :=  v_result||'FIFO_ROUND_UNIT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_VIRTUAL,p_row_new.FLAG_VIRTUAL) THEN 
      v_result    :=  v_result||'FLAG_VIRTUAL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_STOCK,p_row_new.WHS_STOCK) THEN 
      v_result    :=  v_result||'WHS_STOCK'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_colour(p_row_old COLOUR%ROWTYPE, p_row_new COLOUR%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CATEGORY,p_row_new.CATEGORY) THEN 
      v_result    :=  v_result||'CATEGORY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE2,p_row_new.COLOUR_CODE2) THEN 
      v_result    :=  v_result||'COLOUR_CODE2'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_costcenter(p_row_old COSTCENTER%ROWTYPE, p_row_new COSTCENTER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COSTCENTER_CODE,p_row_new.COSTCENTER_CODE) THEN 
      v_result    :=  v_result||'COSTCENTER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_INTERN,p_row_new.FLAG_INTERN) THEN 
      v_result    :=  v_result||'FLAG_INTERN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.MANPOWER_COST,p_row_new.MANPOWER_COST) THEN 
      v_result    :=  v_result||'MANPOWER_COST'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_cost_detail(p_row_old COST_DETAIL%ROWTYPE, p_row_new COST_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.COST_LOT,p_row_new.COST_LOT) THEN 
      v_result    :=  v_result||'COST_LOT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.LOT_SIZE,p_row_new.LOT_SIZE) THEN 
      v_result    :=  v_result||'LOT_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_STOC,p_row_new.QTY_STOC) THEN 
      v_result    :=  v_result||'QTY_STOC'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_COST,p_row_new.REF_COST) THEN 
      v_result    :=  v_result||'REF_COST'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_cost_header(p_row_old COST_HEADER%ROWTYPE, p_row_new COST_HEADER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COST_MONTH,p_row_new.COST_MONTH) THEN 
      v_result    :=  v_result||'COST_MONTH'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COST_TYPE,p_row_new.COST_TYPE) THEN 
      v_result    :=  v_result||'COST_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COST_YEAR,p_row_new.COST_YEAR) THEN 
      v_result    :=  v_result||'COST_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY,p_row_new.CURRENCY) THEN 
      v_result    :=  v_result||'CURRENCY'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_CREATE,p_row_new.DATE_CREATE) THEN 
      v_result    :=  v_result||'DATE_CREATE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_END,p_row_new.DATE_END) THEN 
      v_result    :=  v_result||'DATE_END'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_START,p_row_new.DATE_START) THEN 
      v_result    :=  v_result||'DATE_START'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_cost_type(p_row_old COST_TYPE%ROWTYPE, p_row_new COST_TYPE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COST_CATEGORY,p_row_new.COST_CATEGORY) THEN 
      v_result    :=  v_result||'COST_CATEGORY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COST_CODE,p_row_new.COST_CODE) THEN 
      v_result    :=  v_result||'COST_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_PERIOD,p_row_new.FLAG_PERIOD) THEN 
      v_result    :=  v_result||'FLAG_PERIOD'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_UPDATABLE,p_row_new.FLAG_UPDATABLE) THEN 
      v_result    :=  v_result||'FLAG_UPDATABLE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_country(p_row_old COUNTRY%ROWTYPE, p_row_new COUNTRY%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COUNTRY_CODE,p_row_new.COUNTRY_CODE) THEN 
      v_result    :=  v_result||'COUNTRY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_EU,p_row_new.FLAG_EU) THEN 
      v_result    :=  v_result||'FLAG_EU'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INTRASTAT,p_row_new.INTRASTAT) THEN 
      v_result    :=  v_result||'INTRASTAT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_currency(p_row_old CURRENCY%ROWTYPE, p_row_new CURRENCY%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_CODE,p_row_new.CURRENCY_CODE) THEN 
      v_result    :=  v_result||'CURRENCY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_currency_rate(p_row_old CURRENCY_RATE%ROWTYPE, p_row_new CURRENCY_RATE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_d(p_row_old.CALENDAR_DAY,p_row_new.CALENDAR_DAY) THEN 
      v_result    :=  v_result||'CALENDAR_DAY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_FROM,p_row_new.CURRENCY_FROM) THEN 
      v_result    :=  v_result||'CURRENCY_FROM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_TO,p_row_new.CURRENCY_TO) THEN 
      v_result    :=  v_result||'CURRENCY_TO'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.EXCHANGE_RATE,p_row_new.EXCHANGE_RATE) THEN 
      v_result    :=  v_result||'EXCHANGE_RATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_custom(p_row_old CUSTOM%ROWTYPE, p_row_new CUSTOM%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CODE,p_row_new.CUSTOM_CODE) THEN 
      v_result    :=  v_result||'CUSTOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SUPL_UM,p_row_new.SUPL_UM) THEN 
      v_result    :=  v_result||'SUPL_UM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_delivery_condition(p_row_old DELIVERY_CONDITION%ROWTYPE, p_row_new DELIVERY_CONDITION%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DELIV_COND_CODE,p_row_new.DELIV_COND_CODE) THEN 
      v_result    :=  v_result||'DELIV_COND_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_efficiency(p_row_old EFFICIENCY%ROWTYPE, p_row_new EFFICIENCY%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PRODUCT_HOURS,p_row_new.PRODUCT_HOURS) THEN 
      v_result    :=  v_result||'PRODUCT_HOURS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TEAM_CODE,p_row_new.TEAM_CODE) THEN 
      v_result    :=  v_result||'TEAM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.WORK_DATE,p_row_new.WORK_DATE) THEN 
      v_result    :=  v_result||'WORK_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WORK_HOURS,p_row_new.WORK_HOURS) THEN 
      v_result    :=  v_result||'WORK_HOURS'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_fa_trn(p_row_old FA_TRN%ROWTYPE, p_row_new FA_TRN%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_CODE,p_row_new.DOC_CODE) THEN 
      v_result    :=  v_result||'DOC_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FA_CODE,p_row_new.FA_CODE) THEN 
      v_result    :=  v_result||'FA_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RESP_CDC,p_row_new.RESP_CDC) THEN 
      v_result    :=  v_result||'RESP_CDC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RESP_USER,p_row_new.RESP_USER) THEN 
      v_result    :=  v_result||'RESP_USER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SUPPLIER_CODE,p_row_new.SUPPLIER_CODE) THEN 
      v_result    :=  v_result||'SUPPLIER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_CURRENCY,p_row_new.TRN_CURRENCY) THEN 
      v_result    :=  v_result||'TRN_CURRENCY'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.TRN_DATE,p_row_new.TRN_DATE) THEN 
      v_result    :=  v_result||'TRN_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.TRN_SIGN,p_row_new.TRN_SIGN) THEN 
      v_result    :=  v_result||'TRN_SIGN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_TYPE,p_row_new.TRN_TYPE) THEN 
      v_result    :=  v_result||'TRN_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.TRN_VALUE,p_row_new.TRN_VALUE) THEN 
      v_result    :=  v_result||'TRN_VALUE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_DIFF,p_row_new.WEIGHT_DIFF) THEN 
      v_result    :=  v_result||'WEIGHT_DIFF'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_fa_trn_type(p_row_old FA_TRN_TYPE%ROWTYPE, p_row_new FA_TRN_TYPE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_IOT,p_row_new.TRN_IOT) THEN 
      v_result    :=  v_result||'TRN_IOT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.TRN_SIGN,p_row_new.TRN_SIGN) THEN 
      v_result    :=  v_result||'TRN_SIGN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_TYPE,p_row_new.TRN_TYPE) THEN 
      v_result    :=  v_result||'TRN_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_fifo_exceding(p_row_old FIFO_EXCEDING%ROWTYPE, p_row_new FIFO_EXCEDING%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_SHIPMENT,p_row_new.REF_SHIPMENT) THEN 
      v_result    :=  v_result||'REF_SHIPMENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHIP_SUBCAT,p_row_new.SHIP_SUBCAT) THEN 
      v_result    :=  v_result||'SHIP_SUBCAT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_fifo_material(p_row_old FIFO_MATERIAL%ROWTYPE, p_row_new FIFO_MATERIAL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_MANUAL,p_row_new.FLAG_MANUAL) THEN 
      v_result    :=  v_result||'FLAG_MANUAL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_RECEIPT,p_row_new.REF_RECEIPT) THEN 
      v_result    :=  v_result||'REF_RECEIPT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_SHIPMENT,p_row_new.REF_SHIPMENT) THEN 
      v_result    :=  v_result||'REF_SHIPMENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHIP_SUBCAT,p_row_new.SHIP_SUBCAT) THEN 
      v_result    :=  v_result||'SHIP_SUBCAT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_fixed_asset(p_row_old FIXED_ASSET%ROWTYPE, p_row_new FIXED_ASSET%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CATEGORY_CODE,p_row_new.CATEGORY_CODE) THEN 
      v_result    :=  v_result||'CATEGORY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_IN,p_row_new.DATE_IN) THEN 
      v_result    :=  v_result||'DATE_IN'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_START,p_row_new.DATE_START) THEN 
      v_result    :=  v_result||'DATE_START'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.DEPREC_MONTHS,p_row_new.DEPREC_MONTHS) THEN 
      v_result    :=  v_result||'DEPREC_MONTHS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DEPREC_TYPE,p_row_new.DEPREC_TYPE) THEN 
      v_result    :=  v_result||'DEPREC_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FA_CODE,p_row_new.FA_CODE) THEN 
      v_result    :=  v_result||'FA_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INVENTORY_CODE,p_row_new.INVENTORY_CODE) THEN 
      v_result    :=  v_result||'INVENTORY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RESP_COSTCENTER,p_row_new.RESP_COSTCENTER) THEN 
      v_result    :=  v_result||'RESP_COSTCENTER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RESP_USER,p_row_new.RESP_USER) THEN 
      v_result    :=  v_result||'RESP_USER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT,p_row_new.WEIGHT) THEN 
      v_result    :=  v_result||'WEIGHT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_STOCK,p_row_new.WHS_STOCK) THEN 
      v_result    :=  v_result||'WHS_STOCK'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_fixed_asset_categ(p_row_old FIXED_ASSET_CATEG%ROWTYPE, p_row_new FIXED_ASSET_CATEG%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CATEGORY_CODE,p_row_new.CATEGORY_CODE) THEN 
      v_result    :=  v_result||'CATEGORY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EXTENDED_CODE,p_row_new.EXTENDED_CODE) THEN 
      v_result    :=  v_result||'EXTENDED_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.MAX_MONTHS,p_row_new.MAX_MONTHS) THEN 
      v_result    :=  v_result||'MAX_MONTHS'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.MIN_MONTHS,p_row_new.MIN_MONTHS) THEN 
      v_result    :=  v_result||'MIN_MONTHS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PARENT_CODE,p_row_new.PARENT_CODE) THEN 
      v_result    :=  v_result||'PARENT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_group_routing(p_row_old GROUP_ROUTING%ROWTYPE, p_row_new GROUP_ROUTING%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.MILESTONE,p_row_new.MILESTONE) THEN 
      v_result    :=  v_result||'MILESTONE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_GROUP,p_row_new.REF_GROUP) THEN 
      v_result    :=  v_result||'REF_GROUP'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.SCHED_DATE,p_row_new.SCHED_DATE) THEN 
      v_result    :=  v_result||'SCHED_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TEAM_CODE,p_row_new.TEAM_CODE) THEN 
      v_result    :=  v_result||'TEAM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CONS,p_row_new.WHS_CONS) THEN 
      v_result    :=  v_result||'WHS_CONS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_DEST,p_row_new.WHS_DEST) THEN 
      v_result    :=  v_result||'WHS_DEST'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKCENTER_CODE,p_row_new.WORKCENTER_CODE) THEN 
      v_result    :=  v_result||'WORKCENTER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_import_text_file(p_row_old IMPORT_TEXT_FILE%ROWTYPE, p_row_new IMPORT_TEXT_FILE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_n(p_row_old.FILE_ID,p_row_new.FILE_ID) THEN 
      v_result    :=  v_result||'FILE_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FILE_NAME,p_row_new.FILE_NAME) THEN 
      v_result    :=  v_result||'FILE_NAME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.LINE_SEQ,p_row_new.LINE_SEQ) THEN 
      v_result    :=  v_result||'LINE_SEQ'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.LINE_TEXT,p_row_new.LINE_TEXT) THEN 
      v_result    :=  v_result||'LINE_TEXT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_inventory(p_row_old INVENTORY%ROWTYPE, p_row_new INVENTORY%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_d(p_row_old.DATE_LEGAL,p_row_new.DATE_LEGAL) THEN 
      v_result    :=  v_result||'DATE_LEGAL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INV_CODE,p_row_new.INV_CODE) THEN 
      v_result    :=  v_result||'INV_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.INV_DATE,p_row_new.INV_DATE) THEN 
      v_result    :=  v_result||'INV_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INV_TYPE,p_row_new.INV_TYPE) THEN 
      v_result    :=  v_result||'INV_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_WHS_TRN,p_row_new.REF_WHS_TRN) THEN 
      v_result    :=  v_result||'REF_WHS_TRN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_inventory_detail(p_row_old INVENTORY_DETAIL%ROWTYPE, p_row_new INVENTORY_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FREE_TEXT,p_row_new.FREE_TEXT) THEN 
      v_result    :=  v_result||'FREE_TEXT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INV_TYPE,p_row_new.INV_TYPE) THEN 
      v_result    :=  v_result||'INV_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.POSITION_ID,p_row_new.POSITION_ID) THEN 
      v_result    :=  v_result||'POSITION_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_INVENTORY,p_row_new.REF_INVENTORY) THEN 
      v_result    :=  v_result||'REF_INVENTORY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SHEET_ID,p_row_new.SHEET_ID) THEN 
      v_result    :=  v_result||'SHEET_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_inventory_stoc(p_row_old INVENTORY_STOC%ROWTYPE, p_row_new INVENTORY_STOC%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.INV_DATE,p_row_new.INV_DATE) THEN 
      v_result    :=  v_result||'INV_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_INVENTORY,p_row_new.REF_INVENTORY) THEN 
      v_result    :=  v_result||'REF_INVENTORY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_item(p_row_old ITEM%ROWTYPE, p_row_new ITEM%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNT_ANALYTIC,p_row_new.ACCOUNT_ANALYTIC) THEN 
      v_result    :=  v_result||'ACCOUNT_ANALYTIC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNT_CODE,p_row_new.ACCOUNT_CODE) THEN 
      v_result    :=  v_result||'ACCOUNT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CATEGORY,p_row_new.CUSTOM_CATEGORY) THEN 
      v_result    :=  v_result||'CUSTOM_CATEGORY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CODE,p_row_new.CUSTOM_CODE) THEN 
      v_result    :=  v_result||'CUSTOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.END_SIZE,p_row_new.END_SIZE) THEN 
      v_result    :=  v_result||'END_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_COLOUR,p_row_new.FLAG_COLOUR) THEN 
      v_result    :=  v_result||'FLAG_COLOUR'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_RANGE,p_row_new.FLAG_RANGE) THEN 
      v_result    :=  v_result||'FLAG_RANGE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_SIZE,p_row_new.FLAG_SIZE) THEN 
      v_result    :=  v_result||'FLAG_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE2,p_row_new.ITEM_CODE2) THEN 
      v_result    :=  v_result||'ITEM_CODE2'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.MAKE_BUY,p_row_new.MAKE_BUY) THEN 
      v_result    :=  v_result||'MAKE_BUY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.MAT_TYPE,p_row_new.MAT_TYPE) THEN 
      v_result    :=  v_result||'MAT_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.MAX_QTA,p_row_new.MAX_QTA) THEN 
      v_result    :=  v_result||'MAX_QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.MIN_QTA,p_row_new.MIN_QTA) THEN 
      v_result    :=  v_result||'MIN_QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OBS,p_row_new.OBS) THEN 
      v_result    :=  v_result||'OBS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REORDER_POINT,p_row_new.REORDER_POINT) THEN 
      v_result    :=  v_result||'REORDER_POINT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ROOT_CODE,p_row_new.ROOT_CODE) THEN 
      v_result    :=  v_result||'ROOT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SCRAP_PERC,p_row_new.SCRAP_PERC) THEN 
      v_result    :=  v_result||'SCRAP_PERC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.START_SIZE,p_row_new.START_SIZE) THEN 
      v_result    :=  v_result||'START_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SUOM,p_row_new.SUOM) THEN 
      v_result    :=  v_result||'SUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TYPE_CODE,p_row_new.TYPE_CODE) THEN 
      v_result    :=  v_result||'TYPE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.UOM_CONV,p_row_new.UOM_CONV) THEN 
      v_result    :=  v_result||'UOM_CONV'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM_RECEIT,p_row_new.UOM_RECEIT) THEN 
      v_result    :=  v_result||'UOM_RECEIT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.VALUATION_PRICE,p_row_new.VALUATION_PRICE) THEN 
      v_result    :=  v_result||'VALUATION_PRICE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_BRUT,p_row_new.WEIGHT_BRUT) THEN 
      v_result    :=  v_result||'WEIGHT_BRUT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_NET,p_row_new.WEIGHT_NET) THEN 
      v_result    :=  v_result||'WEIGHT_NET'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_STOCK,p_row_new.WHS_STOCK) THEN 
      v_result    :=  v_result||'WHS_STOCK'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_item_cost(p_row_old ITEM_COST%ROWTYPE, p_row_new ITEM_COST%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CONDITION_FORMULA,p_row_new.CONDITION_FORMULA) THEN 
      v_result    :=  v_result||'CONDITION_FORMULA'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COST_CODE,p_row_new.COST_CODE) THEN 
      v_result    :=  v_result||'COST_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_CODE,p_row_new.CURRENCY_CODE) THEN 
      v_result    :=  v_result||'CURRENCY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DISCOUNT_FORMULA,p_row_new.DISCOUNT_FORMULA) THEN 
      v_result    :=  v_result||'DISCOUNT_FORMULA'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.END_DATE,p_row_new.END_DATE) THEN 
      v_result    :=  v_result||'END_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FAMILY_CODE,p_row_new.FAMILY_CODE) THEN 
      v_result    :=  v_result||'FAMILY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PARTNER_CODE,p_row_new.PARTNER_CODE) THEN 
      v_result    :=  v_result||'PARTNER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PERIOD_CODE,p_row_new.PERIOD_CODE) THEN 
      v_result    :=  v_result||'PERIOD_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.QUALITY,p_row_new.QUALITY) THEN 
      v_result    :=  v_result||'QUALITY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ROUTING_CODE,p_row_new.ROUTING_CODE) THEN 
      v_result    :=  v_result||'ROUTING_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.START_DATE,p_row_new.START_DATE) THEN 
      v_result    :=  v_result||'START_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.UNIT_COST,p_row_new.UNIT_COST) THEN 
      v_result    :=  v_result||'UNIT_COST'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM_CODE,p_row_new.UOM_CODE) THEN 
      v_result    :=  v_result||'UOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_item_cycle_time(p_row_old ITEM_CYCLE_TIME%ROWTYPE, p_row_new ITEM_CYCLE_TIME%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.OPER_TIME,p_row_new.OPER_TIME) THEN 
      v_result    :=  v_result||'OPER_TIME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_item_mapping(p_row_old ITEM_MAPPING%ROWTYPE, p_row_new ITEM_MAPPING%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE_DST,p_row_new.ITEM_CODE_DST) THEN 
      v_result    :=  v_result||'ITEM_CODE_DST'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE_SRC,p_row_new.ITEM_CODE_SRC) THEN 
      v_result    :=  v_result||'ITEM_CODE_SRC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE_DST,p_row_new.ORG_CODE_DST) THEN 
      v_result    :=  v_result||'ORG_CODE_DST'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE_SRC,p_row_new.ORG_CODE_SRC) THEN 
      v_result    :=  v_result||'ORG_CODE_SRC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM_DST,p_row_new.PUOM_DST) THEN 
      v_result    :=  v_result||'PUOM_DST'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_item_size(p_row_old ITEM_SIZE%ROWTYPE, p_row_new ITEM_SIZE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_item_type(p_row_old ITEM_TYPE%ROWTYPE, p_row_new ITEM_TYPE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TYPE_CODE,p_row_new.TYPE_CODE) THEN 
      v_result    :=  v_result||'TYPE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_item_variable(p_row_old ITEM_VARIABLE%ROWTYPE, p_row_new ITEM_VARIABLE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.VAR_CODE,p_row_new.VAR_CODE) THEN 
      v_result    :=  v_result||'VAR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.VAR_VALUE,p_row_new.VAR_VALUE) THEN 
      v_result    :=  v_result||'VAR_VALUE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_line(p_row_old LINE%ROWTYPE, p_row_new LINE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.LINE_CODE,p_row_new.LINE_CODE) THEN 
      v_result    :=  v_result||'LINE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_macrorouting_detail(p_row_old MACROROUTING_DETAIL%ROWTYPE, p_row_new MACROROUTING_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_MILESTONE,p_row_new.FLAG_MILESTONE) THEN 
      v_result    :=  v_result||'FLAG_MILESTONE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_SELECTED,p_row_new.FLAG_SELECTED) THEN 
      v_result    :=  v_result||'FLAG_SELECTED'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ROUTING_CODE,p_row_new.ROUTING_CODE) THEN 
      v_result    :=  v_result||'ROUTING_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKCENTER_CODE,p_row_new.WORKCENTER_CODE) THEN 
      v_result    :=  v_result||'WORKCENTER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_macrorouting_header(p_row_old MACROROUTING_HEADER%ROWTYPE, p_row_new MACROROUTING_HEADER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ROUTING_CODE,p_row_new.ROUTING_CODE) THEN 
      v_result    :=  v_result||'ROUTING_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_movement_type(p_row_old MOVEMENT_TYPE%ROWTYPE, p_row_new MOVEMENT_TYPE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNTING,p_row_new.ACCOUNTING) THEN 
      v_result    :=  v_result||'ACCOUNTING'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_PLAN,p_row_new.FLAG_PLAN) THEN 
      v_result    :=  v_result||'FLAG_PLAN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PICK_FORM_INDEX,p_row_new.PICK_FORM_INDEX) THEN 
      v_result    :=  v_result||'PICK_FORM_INDEX'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PICK_PARAMETER,p_row_new.PICK_PARAMETER) THEN 
      v_result    :=  v_result||'PICK_PARAMETER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_TYPE,p_row_new.TRN_TYPE) THEN 
      v_result    :=  v_result||'TRN_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_multi_table(p_row_old MULTI_TABLE%ROWTYPE, p_row_new MULTI_TABLE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_ACTIVE,p_row_new.FLAG_ACTIVE) THEN 
      v_result    :=  v_result||'FLAG_ACTIVE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TABLE_KEY,p_row_new.TABLE_KEY) THEN 
      v_result    :=  v_result||'TABLE_KEY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TABLE_NAME,p_row_new.TABLE_NAME) THEN 
      v_result    :=  v_result||'TABLE_NAME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_operation(p_row_old OPERATION%ROWTYPE, p_row_new OPERATION%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_SEQ,p_row_new.OPER_SEQ) THEN 
      v_result    :=  v_result||'OPER_SEQ'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_organization(p_row_old ORGANIZATION%ROWTYPE, p_row_new ORGANIZATION%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ADDRESS,p_row_new.ADDRESS) THEN 
      v_result    :=  v_result||'ADDRESS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.BANK,p_row_new.BANK) THEN 
      v_result    :=  v_result||'BANK'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.BANK_ACCOUNT,p_row_new.BANK_ACCOUNT) THEN 
      v_result    :=  v_result||'BANK_ACCOUNT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CITY,p_row_new.CITY) THEN 
      v_result    :=  v_result||'CITY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CONTACT_PERS,p_row_new.CONTACT_PERS) THEN 
      v_result    :=  v_result||'CONTACT_PERS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COUNTRY_CODE,p_row_new.COUNTRY_CODE) THEN 
      v_result    :=  v_result||'COUNTRY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COUNTY,p_row_new.COUNTY) THEN 
      v_result    :=  v_result||'COUNTY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMAIL,p_row_new.EMAIL) THEN 
      v_result    :=  v_result||'EMAIL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FAX,p_row_new.FAX) THEN 
      v_result    :=  v_result||'FAX'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FISCAL_CODE,p_row_new.FISCAL_CODE) THEN 
      v_result    :=  v_result||'FISCAL_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_CLIENT,p_row_new.FLAG_CLIENT) THEN 
      v_result    :=  v_result||'FLAG_CLIENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_GRP_OMOG,p_row_new.FLAG_GRP_OMOG) THEN 
      v_result    :=  v_result||'FLAG_GRP_OMOG'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_LOHN,p_row_new.FLAG_LOHN) THEN 
      v_result    :=  v_result||'FLAG_LOHN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_MYSELF,p_row_new.FLAG_MYSELF) THEN 
      v_result    :=  v_result||'FLAG_MYSELF'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_Q2,p_row_new.FLAG_Q2) THEN 
      v_result    :=  v_result||'FLAG_Q2'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_SBU,p_row_new.FLAG_SBU) THEN 
      v_result    :=  v_result||'FLAG_SBU'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_SUPPLY,p_row_new.FLAG_SUPPLY) THEN 
      v_result    :=  v_result||'FLAG_SUPPLY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_NAME,p_row_new.ORG_NAME) THEN 
      v_result    :=  v_result||'ORG_NAME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PHONE,p_row_new.PHONE) THEN 
      v_result    :=  v_result||'PHONE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REGIST_CODE,p_row_new.REGIST_CODE) THEN 
      v_result    :=  v_result||'REGIST_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.TRANSP_LTIME,p_row_new.TRANSP_LTIME) THEN 
      v_result    :=  v_result||'TRANSP_LTIME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_organization_loc(p_row_old ORGANIZATION_LOC%ROWTYPE, p_row_new ORGANIZATION_LOC%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ADDRESS,p_row_new.ADDRESS) THEN 
      v_result    :=  v_result||'ADDRESS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CITY,p_row_new.CITY) THEN 
      v_result    :=  v_result||'CITY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CONTACT_PERS,p_row_new.CONTACT_PERS) THEN 
      v_result    :=  v_result||'CONTACT_PERS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COUNTRY_CODE,p_row_new.COUNTRY_CODE) THEN 
      v_result    :=  v_result||'COUNTRY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMAIL,p_row_new.EMAIL) THEN 
      v_result    :=  v_result||'EMAIL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FAX,p_row_new.FAX) THEN 
      v_result    :=  v_result||'FAX'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.LOC_CODE,p_row_new.LOC_CODE) THEN 
      v_result    :=  v_result||'LOC_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PHONE,p_row_new.PHONE) THEN 
      v_result    :=  v_result||'PHONE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_package_detail(p_row_old PACKAGE_DETAIL%ROWTYPE, p_row_new PACKAGE_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ERROR_LOG,p_row_new.ERROR_LOG) THEN 
      v_result    :=  v_result||'ERROR_LOG'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PACKAGE_CODE,p_row_new.PACKAGE_CODE) THEN 
      v_result    :=  v_result||'PACKAGE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.QUALITY,p_row_new.QUALITY) THEN 
      v_result    :=  v_result||'QUALITY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_package_header(p_row_old PACKAGE_HEADER%ROWTYPE, p_row_new PACKAGE_HEADER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMPLOYEE_PACK,p_row_new.EMPLOYEE_PACK) THEN 
      v_result    :=  v_result||'EMPLOYEE_PACK'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMPLOYEE_VERIF,p_row_new.EMPLOYEE_VERIF) THEN 
      v_result    :=  v_result||'EMPLOYEE_VERIF'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ERROR_LOG,p_row_new.ERROR_LOG) THEN 
      v_result    :=  v_result||'ERROR_LOG'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.MAX_CAPACITY,p_row_new.MAX_CAPACITY) THEN 
      v_result    :=  v_result||'MAX_CAPACITY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PACKAGE_CODE,p_row_new.PACKAGE_CODE) THEN 
      v_result    :=  v_result||'PACKAGE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_STOCK,p_row_new.WHS_STOCK) THEN 
      v_result    :=  v_result||'WHS_STOCK'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_parameter(p_row_old PARAMETER%ROWTYPE, p_row_new PARAMETER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE01,p_row_new.ATTRIBUTE01) THEN 
      v_result    :=  v_result||'ATTRIBUTE01'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE02,p_row_new.ATTRIBUTE02) THEN 
      v_result    :=  v_result||'ATTRIBUTE02'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE03,p_row_new.ATTRIBUTE03) THEN 
      v_result    :=  v_result||'ATTRIBUTE03'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE04,p_row_new.ATTRIBUTE04) THEN 
      v_result    :=  v_result||'ATTRIBUTE04'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE05,p_row_new.ATTRIBUTE05) THEN 
      v_result    :=  v_result||'ATTRIBUTE05'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE06,p_row_new.ATTRIBUTE06) THEN 
      v_result    :=  v_result||'ATTRIBUTE06'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE07,p_row_new.ATTRIBUTE07) THEN 
      v_result    :=  v_result||'ATTRIBUTE07'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE08,p_row_new.ATTRIBUTE08) THEN 
      v_result    :=  v_result||'ATTRIBUTE08'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE09,p_row_new.ATTRIBUTE09) THEN 
      v_result    :=  v_result||'ATTRIBUTE09'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE10,p_row_new.ATTRIBUTE10) THEN 
      v_result    :=  v_result||'ATTRIBUTE10'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE11,p_row_new.ATTRIBUTE11) THEN 
      v_result    :=  v_result||'ATTRIBUTE11'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE12,p_row_new.ATTRIBUTE12) THEN 
      v_result    :=  v_result||'ATTRIBUTE12'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE13,p_row_new.ATTRIBUTE13) THEN 
      v_result    :=  v_result||'ATTRIBUTE13'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE14,p_row_new.ATTRIBUTE14) THEN 
      v_result    :=  v_result||'ATTRIBUTE14'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE15,p_row_new.ATTRIBUTE15) THEN 
      v_result    :=  v_result||'ATTRIBUTE15'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE16,p_row_new.ATTRIBUTE16) THEN 
      v_result    :=  v_result||'ATTRIBUTE16'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE17,p_row_new.ATTRIBUTE17) THEN 
      v_result    :=  v_result||'ATTRIBUTE17'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE18,p_row_new.ATTRIBUTE18) THEN 
      v_result    :=  v_result||'ATTRIBUTE18'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE19,p_row_new.ATTRIBUTE19) THEN 
      v_result    :=  v_result||'ATTRIBUTE19'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTRIBUTE20,p_row_new.ATTRIBUTE20) THEN 
      v_result    :=  v_result||'ATTRIBUTE20'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.AUDSID,p_row_new.AUDSID) THEN 
      v_result    :=  v_result||'AUDSID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PAR_CODE,p_row_new.PAR_CODE) THEN 
      v_result    :=  v_result||'PAR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PAR_KEY,p_row_new.PAR_KEY) THEN 
      v_result    :=  v_result||'PAR_KEY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_parameter_attr(p_row_old PARAMETER_ATTR%ROWTYPE, p_row_new PARAMETER_ATTR%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ATTR_FROM,p_row_new.ATTR_FROM) THEN 
      v_result    :=  v_result||'ATTR_FROM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTR_ID,p_row_new.ATTR_ID) THEN 
      v_result    :=  v_result||'ATTR_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTR_INLIST,p_row_new.ATTR_INLIST) THEN 
      v_result    :=  v_result||'ATTR_INLIST'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.ATTR_LOCKED,p_row_new.ATTR_LOCKED) THEN 
      v_result    :=  v_result||'ATTR_LOCKED'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTR_NAME,p_row_new.ATTR_NAME) THEN 
      v_result    :=  v_result||'ATTR_NAME'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.ATTR_NOTNULL,p_row_new.ATTR_NOTNULL) THEN 
      v_result    :=  v_result||'ATTR_NOTNULL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ATTR_TO,p_row_new.ATTR_TO) THEN 
      v_result    :=  v_result||'ATTR_TO'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.ATTR_TYPE,p_row_new.ATTR_TYPE) THEN 
      v_result    :=  v_result||'ATTR_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.AUDSID,p_row_new.AUDSID) THEN 
      v_result    :=  v_result||'AUDSID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PAR_CODE,p_row_new.PAR_CODE) THEN 
      v_result    :=  v_result||'PAR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_parameter_code(p_row_old PARAMETER_CODE%ROWTYPE, p_row_new PARAMETER_CODE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_n(p_row_old.AUDSID,p_row_new.AUDSID) THEN 
      v_result    :=  v_result||'AUDSID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PAR_CODE,p_row_new.PAR_CODE) THEN 
      v_result    :=  v_result||'PAR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_price_list(p_row_old PRICE_LIST%ROWTYPE, p_row_new PRICE_LIST%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY,p_row_new.CURRENCY) THEN 
      v_result    :=  v_result||'CURRENCY'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.END_DATE,p_row_new.END_DATE) THEN 
      v_result    :=  v_result||'END_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_DEFAULT,p_row_new.FLAG_DEFAULT) THEN 
      v_result    :=  v_result||'FLAG_DEFAULT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PRICE,p_row_new.PRICE) THEN 
      v_result    :=  v_result||'PRICE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.START_DATE,p_row_new.START_DATE) THEN 
      v_result    :=  v_result||'START_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TYPE_CODE,p_row_new.TYPE_CODE) THEN 
      v_result    :=  v_result||'TYPE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_price_list_sales(p_row_old PRICE_LIST_SALES%ROWTYPE, p_row_new PRICE_LIST_SALES%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_CODE,p_row_new.CURRENCY_CODE) THEN 
      v_result    :=  v_result||'CURRENCY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_END,p_row_new.DATE_END) THEN 
      v_result    :=  v_result||'DATE_END'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_START,p_row_new.DATE_START) THEN 
      v_result    :=  v_result||'DATE_START'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FAMILY_CODE,p_row_new.FAMILY_CODE) THEN 
      v_result    :=  v_result||'FAMILY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_DEFAULT,p_row_new.FLAG_DEFAULT) THEN 
      v_result    :=  v_result||'FLAG_DEFAULT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ROUTING_CODE,p_row_new.ROUTING_CODE) THEN 
      v_result    :=  v_result||'ROUTING_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.UNIT_PRICE,p_row_new.UNIT_PRICE) THEN 
      v_result    :=  v_result||'UNIT_PRICE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_primary_uom(p_row_old PRIMARY_UOM%ROWTYPE, p_row_new PRIMARY_UOM%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_SI,p_row_new.FLAG_SI) THEN 
      v_result    :=  v_result||'FLAG_SI'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SI_CONVERSION,p_row_new.SI_CONVERSION) THEN 
      v_result    :=  v_result||'SI_CONVERSION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SI_UOM,p_row_new.SI_UOM) THEN 
      v_result    :=  v_result||'SI_UOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_receipt_detail(p_row_old RECEIPT_DETAIL%ROWTYPE, p_row_new RECEIPT_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CODE,p_row_new.CUSTOM_CODE) THEN 
      v_result    :=  v_result||'CUSTOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORIGIN_CODE,p_row_new.ORIGIN_CODE) THEN 
      v_result    :=  v_result||'ORIGIN_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PRICE_DOC,p_row_new.PRICE_DOC) THEN 
      v_result    :=  v_result||'PRICE_DOC'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PRICE_DOC_PUOM,p_row_new.PRICE_DOC_PUOM) THEN 
      v_result    :=  v_result||'PRICE_DOC_PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_COUNT,p_row_new.QTY_COUNT) THEN 
      v_result    :=  v_result||'QTY_COUNT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_COUNT_PUOM,p_row_new.QTY_COUNT_PUOM) THEN 
      v_result    :=  v_result||'QTY_COUNT_PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_DOC,p_row_new.QTY_DOC) THEN 
      v_result    :=  v_result||'QTY_DOC'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_DOC_PUOM,p_row_new.QTY_DOC_PUOM) THEN 
      v_result    :=  v_result||'QTY_DOC_PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_RECEIPT,p_row_new.REF_RECEIPT) THEN 
      v_result    :=  v_result||'REF_RECEIPT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM_RECEIPT,p_row_new.UOM_RECEIPT) THEN 
      v_result    :=  v_result||'UOM_RECEIPT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_BRUT,p_row_new.WEIGHT_BRUT) THEN 
      v_result    :=  v_result||'WEIGHT_BRUT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_NET,p_row_new.WEIGHT_NET) THEN 
      v_result    :=  v_result||'WEIGHT_NET'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_PACK,p_row_new.WEIGHT_PACK) THEN 
      v_result    :=  v_result||'WEIGHT_PACK'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_receipt_header(p_row_old RECEIPT_HEADER%ROWTYPE, p_row_new RECEIPT_HEADER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COUNTRY_FROM,p_row_new.COUNTRY_FROM) THEN 
      v_result    :=  v_result||'COUNTRY_FROM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_CODE,p_row_new.CURRENCY_CODE) THEN 
      v_result    :=  v_result||'CURRENCY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DOC_DATE,p_row_new.DOC_DATE) THEN 
      v_result    :=  v_result||'DOC_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_NUMBER,p_row_new.DOC_NUMBER) THEN 
      v_result    :=  v_result||'DOC_NUMBER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FIFO,p_row_new.FIFO) THEN 
      v_result    :=  v_result||'FIFO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INCOTERM,p_row_new.INCOTERM) THEN 
      v_result    :=  v_result||'INCOTERM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RECEIPT_CODE,p_row_new.RECEIPT_CODE) THEN 
      v_result    :=  v_result||'RECEIPT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.RECEIPT_DATE,p_row_new.RECEIPT_DATE) THEN 
      v_result    :=  v_result||'RECEIPT_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RECEIPT_TYPE,p_row_new.RECEIPT_TYPE) THEN 
      v_result    :=  v_result||'RECEIPT_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RECEIPT_YEAR,p_row_new.RECEIPT_YEAR) THEN 
      v_result    :=  v_result||'RECEIPT_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SUPPL_CODE,p_row_new.SUPPL_CODE) THEN 
      v_result    :=  v_result||'SUPPL_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_sales_family(p_row_old SALES_FAMILY%ROWTYPE, p_row_new SALES_FAMILY%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FAMILY_CODE,p_row_new.FAMILY_CODE) THEN 
      v_result    :=  v_result||'FAMILY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_NET,p_row_new.WEIGHT_NET) THEN 
      v_result    :=  v_result||'WEIGHT_NET'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_sales_order(p_row_old SALES_ORDER%ROWTYPE, p_row_new SALES_ORDER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY,p_row_new.CURRENCY) THEN 
      v_result    :=  v_result||'CURRENCY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOMER_CODE,p_row_new.CUSTOMER_CODE) THEN 
      v_result    :=  v_result||'CUSTOMER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOMER_PO,p_row_new.CUSTOMER_PO) THEN 
      v_result    :=  v_result||'CUSTOMER_PO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.ORDER_DATE,p_row_new.ORDER_DATE) THEN 
      v_result    :=  v_result||'ORDER_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_STATUS,p_row_new.ORDER_STATUS) THEN 
      v_result    :=  v_result||'ORDER_STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_scan_event(p_row_old SCAN_EVENT%ROWTYPE, p_row_new SCAN_EVENT%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CONTEXT_CODE,p_row_new.CONTEXT_CODE) THEN 
      v_result    :=  v_result||'CONTEXT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ERROR_LOG,p_row_new.ERROR_LOG) THEN 
      v_result    :=  v_result||'ERROR_LOG'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SCANNED_VALUE,p_row_new.SCANNED_VALUE) THEN 
      v_result    :=  v_result||'SCANNED_VALUE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SCANNER_CODE,p_row_new.SCANNER_CODE) THEN 
      v_result    :=  v_result||'SCANNER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_setup_acrec(p_row_old SETUP_ACREC%ROWTYPE, p_row_new SETUP_ACREC%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACREC_TYPE,p_row_new.ACREC_TYPE) THEN 
      v_result    :=  v_result||'ACREC_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_CODE,p_row_new.CURRENCY_CODE) THEN 
      v_result    :=  v_result||'CURRENCY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EXTERN,p_row_new.EXTERN) THEN 
      v_result    :=  v_result||'EXTERN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_DESCRIPTION,p_row_new.ITEM_DESCRIPTION) THEN 
      v_result    :=  v_result||'ITEM_DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REPORT_OBJECT,p_row_new.REPORT_OBJECT) THEN 
      v_result    :=  v_result||'REPORT_OBJECT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SERVICE,p_row_new.SERVICE) THEN 
      v_result    :=  v_result||'SERVICE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHIP_MATERIAL,p_row_new.SHIP_MATERIAL) THEN 
      v_result    :=  v_result||'SHIP_MATERIAL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TYPE_DESCRIPTION,p_row_new.TYPE_DESCRIPTION) THEN 
      v_result    :=  v_result||'TYPE_DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_setup_movement(p_row_old SETUP_MOVEMENT%ROWTYPE, p_row_new SETUP_MOVEMENT%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_ACCOUNT_CODE,p_row_new.FLAG_ACCOUNT_CODE) THEN 
      v_result    :=  v_result||'FLAG_ACCOUNT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_COST_CENTER,p_row_new.FLAG_COST_CENTER) THEN 
      v_result    :=  v_result||'FLAG_COST_CENTER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_DEMAND,p_row_new.FLAG_DEMAND) THEN 
      v_result    :=  v_result||'FLAG_DEMAND'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_DIFFER_SEASON,p_row_new.FLAG_DIFFER_SEASON) THEN 
      v_result    :=  v_result||'FLAG_DIFFER_SEASON'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_SIZE_COLOUR,p_row_new.FLAG_SIZE_COLOUR) THEN 
      v_result    :=  v_result||'FLAG_SIZE_COLOUR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.MOVE_CODE,p_row_new.MOVE_CODE) THEN 
      v_result    :=  v_result||'MOVE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_DESTIN,p_row_new.WHS_DESTIN) THEN 
      v_result    :=  v_result||'WHS_DESTIN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_SOURCE,p_row_new.WHS_SOURCE) THEN 
      v_result    :=  v_result||'WHS_SOURCE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_setup_receipt(p_row_old SETUP_RECEIPT%ROWTYPE, p_row_new SETUP_RECEIPT%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CURRENCY_CODE,p_row_new.CURRENCY_CODE) THEN 
      v_result    :=  v_result||'CURRENCY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EXTERN,p_row_new.EXTERN) THEN 
      v_result    :=  v_result||'EXTERN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FIFO,p_row_new.FIFO) THEN 
      v_result    :=  v_result||'FIFO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_RETURN,p_row_new.FLAG_RETURN) THEN 
      v_result    :=  v_result||'FLAG_RETURN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PROPERTY,p_row_new.PROPERTY) THEN 
      v_result    :=  v_result||'PROPERTY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RECEIPT_TYPE,p_row_new.RECEIPT_TYPE) THEN 
      v_result    :=  v_result||'RECEIPT_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SERVICE,p_row_new.SERVICE) THEN 
      v_result    :=  v_result||'SERVICE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_TYPE,p_row_new.TRN_TYPE) THEN 
      v_result    :=  v_result||'TRN_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_setup_shipment(p_row_old SETUP_SHIPMENT%ROWTYPE, p_row_new SETUP_SHIPMENT%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CODE,p_row_new.CUSTOM_CODE) THEN 
      v_result    :=  v_result||'CUSTOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EXTERN,p_row_new.EXTERN) THEN 
      v_result    :=  v_result||'EXTERN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FIFO,p_row_new.FIFO) THEN 
      v_result    :=  v_result||'FIFO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NATURE,p_row_new.NATURE) THEN 
      v_result    :=  v_result||'NATURE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OUT_PROC,p_row_new.OUT_PROC) THEN 
      v_result    :=  v_result||'OUT_PROC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PROPERTY,p_row_new.PROPERTY) THEN 
      v_result    :=  v_result||'PROPERTY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHIP_TYPE,p_row_new.SHIP_TYPE) THEN 
      v_result    :=  v_result||'SHIP_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_TYPE,p_row_new.TRN_TYPE) THEN 
      v_result    :=  v_result||'TRN_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_shipment_detail(p_row_old SHIPMENT_DETAIL%ROWTYPE, p_row_new SHIPMENT_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CODE,p_row_new.CUSTOM_CODE) THEN 
      v_result    :=  v_result||'CUSTOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION_ITEM,p_row_new.DESCRIPTION_ITEM) THEN 
      v_result    :=  v_result||'DESCRIPTION_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE_OUT,p_row_new.GROUP_CODE_OUT) THEN 
      v_result    :=  v_result||'GROUP_CODE_OUT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.LINE_SOURCE,p_row_new.LINE_SOURCE) THEN 
      v_result    :=  v_result||'LINE_SOURCE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORIGIN_CODE,p_row_new.ORIGIN_CODE) THEN 
      v_result    :=  v_result||'ORIGIN_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PACKAGE_CODE,p_row_new.PACKAGE_CODE) THEN 
      v_result    :=  v_result||'PACKAGE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PACKAGE_NUMBER,p_row_new.PACKAGE_NUMBER) THEN 
      v_result    :=  v_result||'PACKAGE_NUMBER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_DOC,p_row_new.QTY_DOC) THEN 
      v_result    :=  v_result||'QTY_DOC'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_DOC_PUOM,p_row_new.QTY_DOC_PUOM) THEN 
      v_result    :=  v_result||'QTY_DOC_PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.QUALITY,p_row_new.QUALITY) THEN 
      v_result    :=  v_result||'QUALITY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_SHIPMENT,p_row_new.REF_SHIPMENT) THEN 
      v_result    :=  v_result||'REF_SHIPMENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM_SHIPMENT,p_row_new.UOM_SHIPMENT) THEN 
      v_result    :=  v_result||'UOM_SHIPMENT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_NET,p_row_new.WEIGHT_NET) THEN 
      v_result    :=  v_result||'WEIGHT_NET'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_shipment_header(p_row_old SHIPMENT_HEADER%ROWTYPE, p_row_new SHIPMENT_HEADER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESTIN_CODE,p_row_new.DESTIN_CODE) THEN 
      v_result    :=  v_result||'DESTIN_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_PACKAGE,p_row_new.FLAG_PACKAGE) THEN 
      v_result    :=  v_result||'FLAG_PACKAGE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INCOTERM,p_row_new.INCOTERM) THEN 
      v_result    :=  v_result||'INCOTERM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CLIENT,p_row_new.ORG_CLIENT) THEN 
      v_result    :=  v_result||'ORG_CLIENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_DELIVERY,p_row_new.ORG_DELIVERY) THEN 
      v_result    :=  v_result||'ORG_DELIVERY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PACKAGE_NUMBER,p_row_new.PACKAGE_NUMBER) THEN 
      v_result    :=  v_result||'PACKAGE_NUMBER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PROTOCOL_CODE,p_row_new.PROTOCOL_CODE) THEN 
      v_result    :=  v_result||'PROTOCOL_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PROTOCOL_CODE2,p_row_new.PROTOCOL_CODE2) THEN 
      v_result    :=  v_result||'PROTOCOL_CODE2'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.PROTOCOL_DATE,p_row_new.PROTOCOL_DATE) THEN 
      v_result    :=  v_result||'PROTOCOL_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_ACREC,p_row_new.REF_ACREC) THEN 
      v_result    :=  v_result||'REF_ACREC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHIP_CODE,p_row_new.SHIP_CODE) THEN 
      v_result    :=  v_result||'SHIP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.SHIP_DATE,p_row_new.SHIP_DATE) THEN 
      v_result    :=  v_result||'SHIP_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHIP_TYPE,p_row_new.SHIP_TYPE) THEN 
      v_result    :=  v_result||'SHIP_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHIP_YEAR,p_row_new.SHIP_YEAR) THEN 
      v_result    :=  v_result||'SHIP_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRUCK_NUMBER,p_row_new.TRUCK_NUMBER) THEN 
      v_result    :=  v_result||'TRUCK_NUMBER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_BRUT,p_row_new.WEIGHT_BRUT) THEN 
      v_result    :=  v_result||'WEIGHT_BRUT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_NET,p_row_new.WEIGHT_NET) THEN 
      v_result    :=  v_result||'WEIGHT_NET'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_shipment_order(p_row_old SHIPMENT_ORDER%ROWTYPE, p_row_new SHIPMENT_ORDER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_SHIPMENT,p_row_new.REF_SHIPMENT) THEN 
      v_result    :=  v_result||'REF_SHIPMENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_shipment_package(p_row_old SHIPMENT_PACKAGE%ROWTYPE, p_row_new SHIPMENT_PACKAGE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PACKAGE_CODE,p_row_new.PACKAGE_CODE) THEN 
      v_result    :=  v_result||'PACKAGE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PACKAGE_TYPE,p_row_new.PACKAGE_TYPE) THEN 
      v_result    :=  v_result||'PACKAGE_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_SHIPMENT,p_row_new.REF_SHIPMENT) THEN 
      v_result    :=  v_result||'REF_SHIPMENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.VOLUME,p_row_new.VOLUME) THEN 
      v_result    :=  v_result||'VOLUME'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_BRUT,p_row_new.WEIGHT_BRUT) THEN 
      v_result    :=  v_result||'WEIGHT_BRUT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_NET,p_row_new.WEIGHT_NET) THEN 
      v_result    :=  v_result||'WEIGHT_NET'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_so_detail(p_row_old SO_DETAIL%ROWTYPE, p_row_new SO_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM,p_row_new.ITEM) THEN 
      v_result    :=  v_result||'ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA,p_row_new.QTA) THEN 
      v_result    :=  v_result||'QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_SO,p_row_new.REF_SO) THEN 
      v_result    :=  v_result||'REF_SO'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.REQUEST_DATE,p_row_new.REQUEST_DATE) THEN 
      v_result    :=  v_result||'REQUEST_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.UNIT_PRICE,p_row_new.UNIT_PRICE) THEN 
      v_result    :=  v_result||'UNIT_PRICE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_stg_bom_std(p_row_old STG_BOM_STD%ROWTYPE, p_row_new STG_BOM_STD%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CHILD_CODE,p_row_new.CHILD_CODE) THEN 
      v_result    :=  v_result||'CHILD_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.END_SIZE,p_row_new.END_SIZE) THEN 
      v_result    :=  v_result||'END_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ERROR_LOG,p_row_new.ERROR_LOG) THEN 
      v_result    :=  v_result||'ERROR_LOG'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FATHER_CODE,p_row_new.FATHER_CODE) THEN 
      v_result    :=  v_result||'FATHER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FILE_ID,p_row_new.FILE_ID) THEN 
      v_result    :=  v_result||'FILE_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA,p_row_new.QTA) THEN 
      v_result    :=  v_result||'QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_STD,p_row_new.QTA_STD) THEN 
      v_result    :=  v_result||'QTA_STD'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.START_SIZE,p_row_new.START_SIZE) THEN 
      v_result    :=  v_result||'START_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STG_STATUS,p_row_new.STG_STATUS) THEN 
      v_result    :=  v_result||'STG_STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM,p_row_new.UOM) THEN 
      v_result    :=  v_result||'UOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_stg_file_manager(p_row_old STG_FILE_MANAGER%ROWTYPE, p_row_new STG_FILE_MANAGER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_d(p_row_old.FILE_DATE,p_row_new.FILE_DATE) THEN 
      v_result    :=  v_result||'FILE_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FILE_INFO,p_row_new.FILE_INFO) THEN 
      v_result    :=  v_result||'FILE_INFO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FILE_NAME,p_row_new.FILE_NAME) THEN 
      v_result    :=  v_result||'FILE_NAME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FILE_NAME_ORIGINAL,p_row_new.FILE_NAME_ORIGINAL) THEN 
      v_result    :=  v_result||'FILE_NAME_ORIGINAL'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_PROCESSED,p_row_new.FLAG_PROCESSED) THEN 
      v_result    :=  v_result||'FLAG_PROCESSED'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_stg_item(p_row_old STG_ITEM%ROWTYPE, p_row_new STG_ITEM%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CATEGORY,p_row_new.CUSTOM_CATEGORY) THEN 
      v_result    :=  v_result||'CUSTOM_CATEGORY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTOM_CODE,p_row_new.CUSTOM_CODE) THEN 
      v_result    :=  v_result||'CUSTOM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DEFAULT_ORG,p_row_new.DEFAULT_ORG) THEN 
      v_result    :=  v_result||'DEFAULT_ORG'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DEFAULT_WHS,p_row_new.DEFAULT_WHS) THEN 
      v_result    :=  v_result||'DEFAULT_WHS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.END_SIZE,p_row_new.END_SIZE) THEN 
      v_result    :=  v_result||'END_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ERROR_LOG,p_row_new.ERROR_LOG) THEN 
      v_result    :=  v_result||'ERROR_LOG'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FILE_ID,p_row_new.FILE_ID) THEN 
      v_result    :=  v_result||'FILE_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_COLOUR,p_row_new.FLAG_COLOUR) THEN 
      v_result    :=  v_result||'FLAG_COLOUR'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_RANGE,p_row_new.FLAG_RANGE) THEN 
      v_result    :=  v_result||'FLAG_RANGE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FLAG_SIZE,p_row_new.FLAG_SIZE) THEN 
      v_result    :=  v_result||'FLAG_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE2,p_row_new.ITEM_CODE2) THEN 
      v_result    :=  v_result||'ITEM_CODE2'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.MAKE_BUY,p_row_new.MAKE_BUY) THEN 
      v_result    :=  v_result||'MAKE_BUY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.MAT_TYPE,p_row_new.MAT_TYPE) THEN 
      v_result    :=  v_result||'MAT_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.MAX_QTA,p_row_new.MAX_QTA) THEN 
      v_result    :=  v_result||'MAX_QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.MIN_QTA,p_row_new.MIN_QTA) THEN 
      v_result    :=  v_result||'MIN_QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OBS,p_row_new.OBS) THEN 
      v_result    :=  v_result||'OBS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REORDER_POINT,p_row_new.REORDER_POINT) THEN 
      v_result    :=  v_result||'REORDER_POINT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ROOT_CODE,p_row_new.ROOT_CODE) THEN 
      v_result    :=  v_result||'ROOT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SCRAP_PERC,p_row_new.SCRAP_PERC) THEN 
      v_result    :=  v_result||'SCRAP_PERC'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.START_SIZE,p_row_new.START_SIZE) THEN 
      v_result    :=  v_result||'START_SIZE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STG_STATUS,p_row_new.STG_STATUS) THEN 
      v_result    :=  v_result||'STG_STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SUOM,p_row_new.SUOM) THEN 
      v_result    :=  v_result||'SUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.UOM_CONV,p_row_new.UOM_CONV) THEN 
      v_result    :=  v_result||'UOM_CONV'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM_RECEIT,p_row_new.UOM_RECEIT) THEN 
      v_result    :=  v_result||'UOM_RECEIT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_BRUT,p_row_new.WEIGHT_BRUT) THEN 
      v_result    :=  v_result||'WEIGHT_BRUT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WEIGHT_NET,p_row_new.WEIGHT_NET) THEN 
      v_result    :=  v_result||'WEIGHT_NET'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_stg_ship_fifo(p_row_old STG_SHIP_FIFO%ROWTYPE, p_row_new STG_SHIP_FIFO%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ERROR_LOG,p_row_new.ERROR_LOG) THEN 
      v_result    :=  v_result||'ERROR_LOG'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FILE_ID,p_row_new.FILE_ID) THEN 
      v_result    :=  v_result||'FILE_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.SHIP_DATE,p_row_new.SHIP_DATE) THEN 
      v_result    :=  v_result||'SHIP_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHIP_SUBCAT,p_row_new.SHIP_SUBCAT) THEN 
      v_result    :=  v_result||'SHIP_SUBCAT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STG_STATUS,p_row_new.STG_STATUS) THEN 
      v_result    :=  v_result||'STG_STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_stg_work_order(p_row_old STG_WORK_ORDER%ROWTYPE, p_row_new STG_WORK_ORDER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CLIENT_LOT,p_row_new.CLIENT_LOT) THEN 
      v_result    :=  v_result||'CLIENT_LOT'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_CLIENT,p_row_new.DATE_CLIENT) THEN 
      v_result    :=  v_result||'DATE_CLIENT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ERROR_LOG,p_row_new.ERROR_LOG) THEN 
      v_result    :=  v_result||'ERROR_LOG'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FILE_ID,p_row_new.FILE_ID) THEN 
      v_result    :=  v_result||'FILE_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PACKAGE_NUMBER,p_row_new.PACKAGE_NUMBER) THEN 
      v_result    :=  v_result||'PACKAGE_NUMBER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PRIORITY,p_row_new.PRIORITY) THEN 
      v_result    :=  v_result||'PRIORITY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STG_STATUS,p_row_new.STG_STATUS) THEN 
      v_result    :=  v_result||'STG_STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_stg_wo_decl(p_row_old STG_WO_DECL%ROWTYPE, p_row_new STG_WO_DECL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_d(p_row_old.DECL_DATE,p_row_new.DECL_DATE) THEN 
      v_result    :=  v_result||'DECL_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ERROR_LOG,p_row_new.ERROR_LOG) THEN 
      v_result    :=  v_result||'ERROR_LOG'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.FILE_ID,p_row_new.FILE_ID) THEN 
      v_result    :=  v_result||'FILE_ID'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPERATION,p_row_new.OPERATION) THEN 
      v_result    :=  v_result||'OPERATION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.PACKAGE_NUMBER,p_row_new.PACKAGE_NUMBER) THEN 
      v_result    :=  v_result||'PACKAGE_NUMBER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STG_STATUS,p_row_new.STG_STATUS) THEN 
      v_result    :=  v_result||'STG_STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WO_CODE,p_row_new.WO_CODE) THEN 
      v_result    :=  v_result||'WO_CODE'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_teh_variable(p_row_old TEH_VARIABLE%ROWTYPE, p_row_new TEH_VARIABLE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SQL_LOV,p_row_new.SQL_LOV) THEN 
      v_result    :=  v_result||'SQL_LOV'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.VAR_CODE,p_row_new.VAR_CODE) THEN 
      v_result    :=  v_result||'VAR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_trn_plan_detail(p_row_old TRN_PLAN_DETAIL%ROWTYPE, p_row_new TRN_PLAN_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNT_CODE,p_row_new.ACCOUNT_CODE) THEN 
      v_result    :=  v_result||'ACCOUNT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COST_CENTER,p_row_new.COST_CENTER) THEN 
      v_result    :=  v_result||'COST_CENTER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE_IN,p_row_new.GROUP_CODE_IN) THEN 
      v_result    :=  v_result||'GROUP_CODE_IN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE_OUT,p_row_new.GROUP_CODE_OUT) THEN 
      v_result    :=  v_result||'GROUP_CODE_OUT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY_PUOM,p_row_new.QTY_PUOM) THEN 
      v_result    :=  v_result||'QTY_PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_PLAN,p_row_new.REF_PLAN) THEN 
      v_result    :=  v_result||'REF_PLAN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE_IN,p_row_new.SEASON_CODE_IN) THEN 
      v_result    :=  v_result||'SEASON_CODE_IN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE_OUT,p_row_new.SEASON_CODE_OUT) THEN 
      v_result    :=  v_result||'SEASON_CODE_OUT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.UOM,p_row_new.UOM) THEN 
      v_result    :=  v_result||'UOM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE_IN,p_row_new.WHS_CODE_IN) THEN 
      v_result    :=  v_result||'WHS_CODE_IN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE_OUT,p_row_new.WHS_CODE_OUT) THEN 
      v_result    :=  v_result||'WHS_CODE_OUT'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_trn_plan_header(p_row_old TRN_PLAN_HEADER%ROWTYPE, p_row_new TRN_PLAN_HEADER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_LEGAL,p_row_new.DATE_LEGAL) THEN 
      v_result    :=  v_result||'DATE_LEGAL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_CODE,p_row_new.DOC_CODE) THEN 
      v_result    :=  v_result||'DOC_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DOC_DATE,p_row_new.DOC_DATE) THEN 
      v_result    :=  v_result||'DOC_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMPLOYEE_CODE,p_row_new.EMPLOYEE_CODE) THEN 
      v_result    :=  v_result||'EMPLOYEE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.JOLY_PARAMETER,p_row_new.JOLY_PARAMETER) THEN 
      v_result    :=  v_result||'JOLY_PARAMETER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PARTNER_CODE,p_row_new.PARTNER_CODE) THEN 
      v_result    :=  v_result||'PARTNER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PICK_PARAMETER,p_row_new.PICK_PARAMETER) THEN 
      v_result    :=  v_result||'PICK_PARAMETER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PLAN_CODE,p_row_new.PLAN_CODE) THEN 
      v_result    :=  v_result||'PLAN_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.PLAN_DATE,p_row_new.PLAN_DATE) THEN 
      v_result    :=  v_result||'PLAN_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SUPPL_CODE,p_row_new.SUPPL_CODE) THEN 
      v_result    :=  v_result||'SUPPL_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_TYPE,p_row_new.TRN_TYPE) THEN 
      v_result    :=  v_result||'TRN_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_value_ad_tax(p_row_old VALUE_AD_TAX%ROWTYPE, p_row_new VALUE_AD_TAX%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.VAT_CODE,p_row_new.VAT_CODE) THEN 
      v_result    :=  v_result||'VAT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.VAT_VALUE,p_row_new.VAT_VALUE) THEN 
      v_result    :=  v_result||'VAT_VALUE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_virtual_table(p_row_old VIRTUAL_TABLE%ROWTYPE, p_row_new VIRTUAL_TABLE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_d(p_row_old.DATA01,p_row_new.DATA01) THEN 
      v_result    :=  v_result||'DATA01'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA02,p_row_new.DATA02) THEN 
      v_result    :=  v_result||'DATA02'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA03,p_row_new.DATA03) THEN 
      v_result    :=  v_result||'DATA03'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA04,p_row_new.DATA04) THEN 
      v_result    :=  v_result||'DATA04'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA05,p_row_new.DATA05) THEN 
      v_result    :=  v_result||'DATA05'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA06,p_row_new.DATA06) THEN 
      v_result    :=  v_result||'DATA06'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA07,p_row_new.DATA07) THEN 
      v_result    :=  v_result||'DATA07'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA08,p_row_new.DATA08) THEN 
      v_result    :=  v_result||'DATA08'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA09,p_row_new.DATA09) THEN 
      v_result    :=  v_result||'DATA09'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATA10,p_row_new.DATA10) THEN 
      v_result    :=  v_result||'DATA10'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB01,p_row_new.NUMB01) THEN 
      v_result    :=  v_result||'NUMB01'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB02,p_row_new.NUMB02) THEN 
      v_result    :=  v_result||'NUMB02'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB03,p_row_new.NUMB03) THEN 
      v_result    :=  v_result||'NUMB03'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB04,p_row_new.NUMB04) THEN 
      v_result    :=  v_result||'NUMB04'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB05,p_row_new.NUMB05) THEN 
      v_result    :=  v_result||'NUMB05'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB06,p_row_new.NUMB06) THEN 
      v_result    :=  v_result||'NUMB06'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB07,p_row_new.NUMB07) THEN 
      v_result    :=  v_result||'NUMB07'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB08,p_row_new.NUMB08) THEN 
      v_result    :=  v_result||'NUMB08'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB09,p_row_new.NUMB09) THEN 
      v_result    :=  v_result||'NUMB09'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB10,p_row_new.NUMB10) THEN 
      v_result    :=  v_result||'NUMB10'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB11,p_row_new.NUMB11) THEN 
      v_result    :=  v_result||'NUMB11'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB12,p_row_new.NUMB12) THEN 
      v_result    :=  v_result||'NUMB12'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB13,p_row_new.NUMB13) THEN 
      v_result    :=  v_result||'NUMB13'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB14,p_row_new.NUMB14) THEN 
      v_result    :=  v_result||'NUMB14'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB15,p_row_new.NUMB15) THEN 
      v_result    :=  v_result||'NUMB15'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB16,p_row_new.NUMB16) THEN 
      v_result    :=  v_result||'NUMB16'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB17,p_row_new.NUMB17) THEN 
      v_result    :=  v_result||'NUMB17'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB18,p_row_new.NUMB18) THEN 
      v_result    :=  v_result||'NUMB18'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB19,p_row_new.NUMB19) THEN 
      v_result    :=  v_result||'NUMB19'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.NUMB20,p_row_new.NUMB20) THEN 
      v_result    :=  v_result||'NUMB20'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEGMENT_CODE,p_row_new.SEGMENT_CODE) THEN 
      v_result    :=  v_result||'SEGMENT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT01,p_row_new.TXT01) THEN 
      v_result    :=  v_result||'TXT01'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT02,p_row_new.TXT02) THEN 
      v_result    :=  v_result||'TXT02'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT03,p_row_new.TXT03) THEN 
      v_result    :=  v_result||'TXT03'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT04,p_row_new.TXT04) THEN 
      v_result    :=  v_result||'TXT04'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT05,p_row_new.TXT05) THEN 
      v_result    :=  v_result||'TXT05'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT06,p_row_new.TXT06) THEN 
      v_result    :=  v_result||'TXT06'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT07,p_row_new.TXT07) THEN 
      v_result    :=  v_result||'TXT07'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT08,p_row_new.TXT08) THEN 
      v_result    :=  v_result||'TXT08'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT09,p_row_new.TXT09) THEN 
      v_result    :=  v_result||'TXT09'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT10,p_row_new.TXT10) THEN 
      v_result    :=  v_result||'TXT10'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT11,p_row_new.TXT11) THEN 
      v_result    :=  v_result||'TXT11'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT12,p_row_new.TXT12) THEN 
      v_result    :=  v_result||'TXT12'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT13,p_row_new.TXT13) THEN 
      v_result    :=  v_result||'TXT13'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT14,p_row_new.TXT14) THEN 
      v_result    :=  v_result||'TXT14'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT15,p_row_new.TXT15) THEN 
      v_result    :=  v_result||'TXT15'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT16,p_row_new.TXT16) THEN 
      v_result    :=  v_result||'TXT16'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT17,p_row_new.TXT17) THEN 
      v_result    :=  v_result||'TXT17'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT18,p_row_new.TXT18) THEN 
      v_result    :=  v_result||'TXT18'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT19,p_row_new.TXT19) THEN 
      v_result    :=  v_result||'TXT19'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT20,p_row_new.TXT20) THEN 
      v_result    :=  v_result||'TXT20'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT21,p_row_new.TXT21) THEN 
      v_result    :=  v_result||'TXT21'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT22,p_row_new.TXT22) THEN 
      v_result    :=  v_result||'TXT22'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT23,p_row_new.TXT23) THEN 
      v_result    :=  v_result||'TXT23'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT24,p_row_new.TXT24) THEN 
      v_result    :=  v_result||'TXT24'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT25,p_row_new.TXT25) THEN 
      v_result    :=  v_result||'TXT25'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT26,p_row_new.TXT26) THEN 
      v_result    :=  v_result||'TXT26'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT27,p_row_new.TXT27) THEN 
      v_result    :=  v_result||'TXT27'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT28,p_row_new.TXT28) THEN 
      v_result    :=  v_result||'TXT28'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT29,p_row_new.TXT29) THEN 
      v_result    :=  v_result||'TXT29'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TXT30,p_row_new.TXT30) THEN 
      v_result    :=  v_result||'TXT30'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_warehouse(p_row_old WAREHOUSE%ROWTYPE, p_row_new WAREHOUSE%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNT_CODE,p_row_new.ACCOUNT_CODE) THEN 
      v_result    :=  v_result||'ACCOUNT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CATEGORY_CODE,p_row_new.CATEGORY_CODE) THEN 
      v_result    :=  v_result||'CATEGORY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_warehouse_categ(p_row_old WAREHOUSE_CATEG%ROWTYPE, p_row_new WAREHOUSE_CATEG%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNTING,p_row_new.ACCOUNTING) THEN 
      v_result    :=  v_result||'ACCOUNTING'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ALLOW_NEGATIVE,p_row_new.ALLOW_NEGATIVE) THEN 
      v_result    :=  v_result||'ALLOW_NEGATIVE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CATEGORY_CODE,p_row_new.CATEGORY_CODE) THEN 
      v_result    :=  v_result||'CATEGORY_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CUSTODY,p_row_new.CUSTODY) THEN 
      v_result    :=  v_result||'CUSTODY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.INTERN,p_row_new.INTERN) THEN 
      v_result    :=  v_result||'INTERN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.QTY_ON_HAND,p_row_new.QTY_ON_HAND) THEN 
      v_result    :=  v_result||'QTY_ON_HAND'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.VALUATION_TYPE,p_row_new.VALUATION_TYPE) THEN 
      v_result    :=  v_result||'VALUATION_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.VIRTUAL,p_row_new.VIRTUAL) THEN 
      v_result    :=  v_result||'VIRTUAL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_web_grid_cm(p_row_old WEB_GRID_CM%ROWTYPE, p_row_new WEB_GRID_CM%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ALIGN,p_row_new.ALIGN) THEN 
      v_result    :=  v_result||'ALIGN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CAPTION,p_row_new.CAPTION) THEN 
      v_result    :=  v_result||'CAPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CLIENT_CODE,p_row_new.CLIENT_CODE) THEN 
      v_result    :=  v_result||'CLIENT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CONTROLSOURCE,p_row_new.CONTROLSOURCE) THEN 
      v_result    :=  v_result||'CONTROLSOURCE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CONTROL_NAME,p_row_new.CONTROL_NAME) THEN 
      v_result    :=  v_result||'CONTROL_NAME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GRID_NAME,p_row_new.GRID_NAME) THEN 
      v_result    :=  v_result||'GRID_NAME'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ISEDITABLE,p_row_new.ISEDITABLE) THEN 
      v_result    :=  v_result||'ISEDITABLE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ISHIDDEN,p_row_new.ISHIDDEN) THEN 
      v_result    :=  v_result||'ISHIDDEN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.RENDERER,p_row_new.RENDERER) THEN 
      v_result    :=  v_result||'RENDERER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.SEQ_NO,p_row_new.SEQ_NO) THEN 
      v_result    :=  v_result||'SEQ_NO'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.WIDTH,p_row_new.WIDTH) THEN 
      v_result    :=  v_result||'WIDTH'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_whs_trn(p_row_old WHS_TRN%ROWTYPE, p_row_new WHS_TRN%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_d(p_row_old.DATE_LEGAL,p_row_new.DATE_LEGAL) THEN 
      v_result    :=  v_result||'DATE_LEGAL'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_CODE,p_row_new.DOC_CODE) THEN 
      v_result    :=  v_result||'DOC_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DOC_DATE,p_row_new.DOC_DATE) THEN 
      v_result    :=  v_result||'DOC_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DOC_YEAR,p_row_new.DOC_YEAR) THEN 
      v_result    :=  v_result||'DOC_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.EMPLOYEE_CODE,p_row_new.EMPLOYEE_CODE) THEN 
      v_result    :=  v_result||'EMPLOYEE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_STORNO,p_row_new.FLAG_STORNO) THEN 
      v_result    :=  v_result||'FLAG_STORNO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PARTNER_CODE,p_row_new.PARTNER_CODE) THEN 
      v_result    :=  v_result||'PARTNER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REASON_CODE,p_row_new.REASON_CODE) THEN 
      v_result    :=  v_result||'REASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_MASTER,p_row_new.REF_MASTER) THEN 
      v_result    :=  v_result||'REF_MASTER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_RECEIPT,p_row_new.REF_RECEIPT) THEN 
      v_result    :=  v_result||'REF_RECEIPT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_SHIPMENT,p_row_new.REF_SHIPMENT) THEN 
      v_result    :=  v_result||'REF_SHIPMENT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_STORNO,p_row_new.REF_STORNO) THEN 
      v_result    :=  v_result||'REF_STORNO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_CODE,p_row_new.TRN_CODE) THEN 
      v_result    :=  v_result||'TRN_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.TRN_DATE,p_row_new.TRN_DATE) THEN 
      v_result    :=  v_result||'TRN_DATE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_TYPE,p_row_new.TRN_TYPE) THEN 
      v_result    :=  v_result||'TRN_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.TRN_YEAR,p_row_new.TRN_YEAR) THEN 
      v_result    :=  v_result||'TRN_YEAR'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_whs_trn_detail(p_row_old WHS_TRN_DETAIL%ROWTYPE, p_row_new WHS_TRN_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNT_CODE,p_row_new.ACCOUNT_CODE) THEN 
      v_result    :=  v_result||'ACCOUNT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COLOUR_CODE,p_row_new.COLOUR_CODE) THEN 
      v_result    :=  v_result||'COLOUR_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.COST_CENTER,p_row_new.COST_CENTER) THEN 
      v_result    :=  v_result||'COST_CENTER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PUOM,p_row_new.PUOM) THEN 
      v_result    :=  v_result||'PUOM'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTY,p_row_new.QTY) THEN 
      v_result    :=  v_result||'QTY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REASON_CODE,p_row_new.REASON_CODE) THEN 
      v_result    :=  v_result||'REASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_RECEIPT,p_row_new.REF_RECEIPT) THEN 
      v_result    :=  v_result||'REF_RECEIPT'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_TRN,p_row_new.REF_TRN) THEN 
      v_result    :=  v_result||'REF_TRN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.TRN_SIGN,p_row_new.TRN_SIGN) THEN 
      v_result    :=  v_result||'TRN_SIGN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WC_CODE,p_row_new.WC_CODE) THEN 
      v_result    :=  v_result||'WC_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_whs_trn_reason(p_row_old WHS_TRN_REASON%ROWTYPE, p_row_new WHS_TRN_REASON%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.ACCOUNTING,p_row_new.ACCOUNTING) THEN 
      v_result    :=  v_result||'ACCOUNTING'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ALLOC_WO,p_row_new.ALLOC_WO) THEN 
      v_result    :=  v_result||'ALLOC_WO'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.BUSINESS_FLOW,p_row_new.BUSINESS_FLOW) THEN 
      v_result    :=  v_result||'BUSINESS_FLOW'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PROPERTY,p_row_new.PROPERTY) THEN 
      v_result    :=  v_result||'PROPERTY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REASON_CODE,p_row_new.REASON_CODE) THEN 
      v_result    :=  v_result||'REASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.REASON_TYPE,p_row_new.REASON_TYPE) THEN 
      v_result    :=  v_result||'REASON_TYPE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SBU_CODE,p_row_new.SBU_CODE) THEN 
      v_result    :=  v_result||'SBU_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SHOW_USER,p_row_new.SHOW_USER) THEN 
      v_result    :=  v_result||'SHOW_USER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.TRN_SIGN,p_row_new.TRN_SIGN) THEN 
      v_result    :=  v_result||'TRN_SIGN'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_workcenter(p_row_old WORKCENTER%ROWTYPE, p_row_new WORKCENTER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.COSTCENTER_CODE,p_row_new.COSTCENTER_CODE) THEN 
      v_result    :=  v_result||'COSTCENTER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WHS_CODE,p_row_new.WHS_CODE) THEN 
      v_result    :=  v_result||'WHS_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKCENTER_CODE,p_row_new.WORKCENTER_CODE) THEN 
      v_result    :=  v_result||'WORKCENTER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_workcenter_oper(p_row_old WORKCENTER_OPER%ROWTYPE, p_row_new WORKCENTER_OPER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKCENTER_CODE,p_row_new.WORKCENTER_CODE) THEN 
      v_result    :=  v_result||'WORKCENTER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_work_group(p_row_old WORK_GROUP%ROWTYPE, p_row_new WORK_GROUP%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_d(p_row_old.DATE_LAUNCH,p_row_new.DATE_LAUNCH) THEN 
      v_result    :=  v_result||'DATE_LAUNCH'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_work_order(p_row_old WORK_ORDER%ROWTYPE, p_row_new WORK_ORDER%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.CLIENT_CODE,p_row_new.CLIENT_CODE) THEN 
      v_result    :=  v_result||'CLIENT_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CLIENT_LOCATION,p_row_new.CLIENT_LOCATION) THEN 
      v_result    :=  v_result||'CLIENT_LOCATION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.CLIENT_LOT,p_row_new.CLIENT_LOT) THEN 
      v_result    :=  v_result||'CLIENT_LOT'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_CLIENT,p_row_new.DATE_CLIENT) THEN 
      v_result    :=  v_result||'DATE_CLIENT'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_COMPLET,p_row_new.DATE_COMPLET) THEN 
      v_result    :=  v_result||'DATE_COMPLET'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_CREATE,p_row_new.DATE_CREATE) THEN 
      v_result    :=  v_result||'DATE_CREATE'||',';
  END IF;
  IF PKG_LIB.f_mod_d(p_row_old.DATE_LAUNCH,p_row_new.DATE_LAUNCH) THEN 
      v_result    :=  v_result||'DATE_LAUNCH'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ITEM_CODE,p_row_new.ITEM_CODE) THEN 
      v_result    :=  v_result||'ITEM_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.LINE,p_row_new.LINE) THEN 
      v_result    :=  v_result||'LINE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NOTE,p_row_new.NOTE) THEN 
      v_result    :=  v_result||'NOTE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE_ITEM,p_row_new.OPER_CODE_ITEM) THEN 
      v_result    :=  v_result||'OPER_CODE_ITEM'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.PRIORITY,p_row_new.PRIORITY) THEN 
      v_result    :=  v_result||'PRIORITY'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ROUTING_CODE,p_row_new.ROUTING_CODE) THEN 
      v_result    :=  v_result||'ROUTING_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.STATUS,p_row_new.STATUS) THEN 
      v_result    :=  v_result||'STATUS'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_work_season(p_row_old WORK_SEASON%ROWTYPE, p_row_new WORK_SEASON%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.DESCRIPTION,p_row_new.DESCRIPTION) THEN 
      v_result    :=  v_result||'DESCRIPTION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.FLAG_ACTIVE,p_row_new.FLAG_ACTIVE) THEN 
      v_result    :=  v_result||'FLAG_ACTIVE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SEASON_CODE,p_row_new.SEASON_CODE) THEN 
      v_result    :=  v_result||'SEASON_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_wo_detail(p_row_old WO_DETAIL%ROWTYPE, p_row_new WO_DETAIL%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA,p_row_new.QTA) THEN 
      v_result    :=  v_result||'QTA'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_COMPLET,p_row_new.QTA_COMPLET) THEN 
      v_result    :=  v_result||'QTA_COMPLET'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_SCRAP,p_row_new.QTA_SCRAP) THEN 
      v_result    :=  v_result||'QTA_SCRAP'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_SHIP_GOOD,p_row_new.QTA_SHIP_GOOD) THEN 
      v_result    :=  v_result||'QTA_SHIP_GOOD'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.QTA_SHIP_SCRAP,p_row_new.QTA_SHIP_SCRAP) THEN 
      v_result    :=  v_result||'QTA_SHIP_SCRAP'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.REF_WO,p_row_new.REF_WO) THEN 
      v_result    :=  v_result||'REF_WO'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.SIZE_CODE,p_row_new.SIZE_CODE) THEN 
      v_result    :=  v_result||'SIZE_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
--------------------------------------------------------------------
FUNCTION f_wo_group(p_row_old WO_GROUP%ROWTYPE, p_row_new WO_GROUP%ROWTYPE)
RETURN VARCHAR2 
IS
  v_result    VARCHAR2(32000);
BEGIN
  IF PKG_LIB.f_mod_c(p_row_old.GROUP_CODE,p_row_new.GROUP_CODE) THEN 
      v_result    :=  v_result||'GROUP_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.IDUSER,p_row_new.IDUSER) THEN 
      v_result    :=  v_result||'IDUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.NUSER,p_row_new.NUSER) THEN 
      v_result    :=  v_result||'NUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OPER_CODE,p_row_new.OPER_CODE) THEN 
      v_result    :=  v_result||'OPER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORDER_CODE,p_row_new.ORDER_CODE) THEN 
      v_result    :=  v_result||'ORDER_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.ORG_CODE,p_row_new.ORG_CODE) THEN 
      v_result    :=  v_result||'ORG_CODE'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.OSUSER,p_row_new.OSUSER) THEN 
      v_result    :=  v_result||'OSUSER'||',';
  END IF;
  IF PKG_LIB.f_mod_n(p_row_old.ROW_VERSION,p_row_new.ROW_VERSION) THEN 
      v_result    :=  v_result||'ROW_VERSION'||',';
  END IF;
  IF PKG_LIB.f_mod_c(p_row_old.WORKST,p_row_new.WORKST) THEN 
      v_result    :=  v_result||'WORKST'||',';
  END IF;
      RETURN v_result ;
END;
END; 

/

/
