--------------------------------------------------------
--  File created - Thursday-November-01-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View STOC_ONLINE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "STOC_ONLINE" ("ORG_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "COLOUR_CODE", "SIZE_CODE", "WHS_CODE", "SEASON_CODE", "ORDER_CODE", "GROUP_CODE", "QTY") AS 
  select "ORG_CODE","ITEM_CODE","OPER_CODE_ITEM","COLOUR_CODE","SIZE_CODE","WHS_CODE","SEASON_CODE","ORDER_CODE","GROUP_CODE","QTY" from stock_online
 ;
/
--------------------------------------------------------
--  DDL for View STOC_ONLINE_PKG
--------------------------------------------------------

  CREATE OR REPLACE VIEW "STOC_ONLINE_PKG" ("ORG_CODE", "PACKAGE_CODE", "WHS_CODE", "STOCK") AS 
  SELECT      d.org_code, d.package_code, d.whs_code, SUM(d.trn_sign) stock 
FROM        PACKAGE_TRN_DETAIL  d 
INNER JOIN  PACKAGE_TRN_HEADER  h   ON  h.idriga        =   d.ref_trn 
INNER JOIN  PACKAGE_HEADER      p   ON  p.package_code  =   d.package_code 
WHERE       d.error_log     IS NULL 
    AND     h.status        =   'V' 
    AND     p.status        IN  ('E','V') 
GROUP BY    d.org_code, d.package_code, d.whs_code 
HAVING      SUM(d.trn_sign) <> 0
 ;
/
--------------------------------------------------------
--  DDL for View STOC_ONLINE_PREVIOUS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "STOC_ONLINE_PREVIOUS" ("ORG_CODE", "ITEM_CODE", "WHS_CODE", "SEASON_CODE", "COLOUR_CODE", "SIZE_CODE", "WO_MAKE", "OPER_CODE", "QTA", "DATE_LEGAL", "SEGMENT_CODE") AS 
  SELECT 
            txt01       org_code, 
            txt02       item_code, 
            txt03       whs_code, 
            txt04       season_code, 
            txt05       colour_code, 
            txt06       size_code, 
            txt07       wo_make, 
            txt08       oper_code, 
            numb01      qta, 
            data01      date_legal, 
            segment_code 
     FROM   TMP_SEGMENT 
     WHERE  segment_code    =   'STOC_ONLINE_PREVIOUS' 
     WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_ACREC_PRINT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_ACREC_PRINT" ("MYSELF_NAME", "DOCUMENT_NAME", "DOCUMENT_IDENTIFICATION", "DESCRIPTION", "UM", "EMPLOYEE_NAME", "CURRENCY_CODE", "CUSTOM_DESCRIPTION", "CUSTOM_CODE", "TRUCK_NUMBER", "MYSELF_IDENTIFICATION", "CLIENT_IDENTIFICATION", "DELIVERY_IDENTIFICATION", "HEADER_INFORMATION", "FOOTER_INFORMATION", "QUANTITY", "UNIT_PRICE", "TOTAL_VALUE", "MATERIAL_VALUE", "VAT_PERCENT", "VAT_VALUE", "LINE_ORDER", "WEIGHT_NET", "WEIGHT_NET_TOTAL", "WEIGHT_BRUT", "PACKAGE_NUMBER", "EXCHANGE_RATE", "VALUE_MAT_CLIENT", "VALUE_MAT_PROPERTY", "VALUE_MAT_CLIENT_ALL", "VALUE_MAT_PROPERTY_ALL", "SEGMENT_CODE") AS 
  SELECT 
txt01    MYSELF_NAME, 
txt02    DOCUMENT_NAME, 
txt03    DOCUMENT_IDENTIFICATION, 
txt04    DESCRIPTION, 
txt05    UM, 
txt06    EMPLOYEE_NAME, 
txt07    CURRENCY_CODE, 
txt08    CUSTOM_DESCRIPTION, 
txt09    CUSTOM_CODE, 
txt10    TRUCK_NUMBER, 
txt40    MYSELF_IDENTIFICATION, 
txt41    CLIENT_IDENTIFICATION, 
txt42    DELIVERY_IDENTIFICATION, 
txt43    HEADER_INFORMATION, 
txt44    FOOTER_INFORMATION, 
---------- 
numb01   QUANTITY, 
numb02   UNIT_PRICE, 
numb03   TOTAL_VALUE, 
numb04   MATERIAL_VALUE, 
numb05   VAT_PERCENT, 
numb06   VAT_VALUE, 
numb07   LINE_ORDER, 
numb08   WEIGHT_NET, 
numb09   WEIGHT_NET_TOTAL, 
numb10   WEIGHT_BRUT, 
numb11   PACKAGE_NUMBER, 
numb12   EXCHANGE_RATE, 
numb13   value_mat_client, 
numb14   value_mat_property, 
numb15   value_mat_client_all, 
numb16   value_mat_property_all, 
------------- 
segment_code 
FROM  TMP_SEGMENT 
WHERE segment_code  =  'VW_ACREC_PRINT' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_APP_AUDIT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_APP_AUDIT" ("NOTE", "DATAGG", "OSUSER", "WORKST", "TBL_OPER", "TBL_IDRIGA", "TBL_IDX1", "TBL_IDX2", "TBL_NAME", "IDRIGA") AS 
  SELECT 
NOTE,DATAGG,OSUSER,workst,tbl_oper,tbl_idriga,tbl_idx1,tbl_idx2,tbl_name, idriga 
FROM APP_AUDIT 
ORDER BY idriga DESC
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_APP_AUDIT_REF
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_APP_AUDIT_REF" ("IDRIGA", "DESCRIPTION", "TBL_AUDIT", "TBL_IDX1", "TBL_IDX2", "DESCR_IDX1", "DESCR_IDX2", "TBL_IDRIGA", "FLAG_INS_TRIG") AS 
  SELECT 
       idriga, 
       description, 
       tbl_audit, 
       tbl_idx1, 
       tbl_idx2, 
       descr_idx1, 
       descr_idx2, 
       tbl_idriga, 
       flag_ins_trig 
FROM   APP_AUDIT_REF    e 
WHERE  NOT EXISTS (SELECT tbl_audit FROM APP_AUDIT_REF MINUS SELECT table_name FROM USER_TABLES) 
        AND EXISTS (SELECT 1 FROM USER_TABLES i WHERE i.table_name = e.tbl_audit ) 
WITH CHECK OPTION
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_APP_DOC_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_APP_DOC_NUMBER" ("IDRIGA", "DOC_TYPE", "ORG_CODE", "NUM_YEAR", "NUM_START", "NUM_END", "NUM_CURRENT") AS 
  SELECT 
t.IDRIGA, t.DOC_TYPE, t.ORG_CODE, t.NUM_YEAR, t.NUM_START, t.NUM_END, t.NUM_CURRENT
FROM APP_DOC_NUMBER t
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_APP_EXCEPTIONS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_APP_EXCEPTIONS" ("IDRIGA", "SQLCODE", "NUM_EXCEP", "NUM_TABEL", "NUM_COL", "ERR_MSG") AS 
  SELECT 
IDRIGA, 
SQLCODE, 
NUM_EXCEP, 
NUM_TABEL, 
NUM_COL, 
ERR_MSG 
FROM   APP_EXCEPTIONS
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_APP_HELP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_APP_HELP" ("SEQ_NO", "HELP_HEADER", "HELP_DETAIL") AS 
  SELECT 
  seq_no, 
  help_header, 
  help_detail 
FROM   APP_HELP
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_APP_LOG
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_APP_LOG" ("MSG_TEXT", "INSERT_DATE", "LINE_ID") AS 
  SELECT  msg_text,insert_date,line_id 
FROM    APP_LOG 
WHERE   msg_type = 'E' 
ORDER BY line_id DESC
 ;
/
--------------------------------------------------------
--  DDL for View VW_APP_SECURITEM
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_APP_SECURITEM" ("IDRIGA", "SECURITEM_CODE", "DESCRIPTION", "SECURITEM_TYPE") AS 
  SELECT 
t.IDRIGA, t.SECURITEM_CODE, t.DESCRIPTION, t.SECURITEM_TYPE 
FROM    APP_SECURITEM t
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_APP_TABLE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_APP_TABLE" ("IDRIGA", "TBL_NAME", "OBJECT_TYPE", "DESCRIPTION", "FLAG_INSERT_TRG", "TBL_IDRIGA", "FLAG_AUDIT_TRG", "FLAG_RTYPE", "FLAG_IUD", "FLAG_GET", "GET2_COLUMNS", "FLAG_MOD_COL", "TBL_AUDIT_IDX1", "TBL_AUDIT_IDX2", "DESCR_AUDIT_IDX1", "DESCR_AUDIT_IDX2", "FLAG_DCN_TRG", "TBL_NAME_USER", "REF_CONST_TEXT", "UN_CONST_TEXT") AS 
  SELECT 
/*---------------------------------------------------------------- 
- Table APP_TABLE manages: 
    - FLAG_INSERT_TRG creates the TRG_....(table name) 
      with the insert staff (IDRIGA, DATAGG .. etc), possible 
      values Y, N 
    - FLAG_AUDIT_TRG includes in the previous TRG_.... 
      trigger also the audit staff for UPDATE and DELETE, possible 
      values Y, N 
    - the above 2 thing is maanaged by p_create_pkg_trg procedure 
    - TBL_IDRIGA - this indicates the ID of the table,  has to be 
      filed, the majority of tables has IDRIGA but can be other 
    - FLAG_RTYPE - creates the PKG_RTYPE, possible values Y, N 
      with procedure p_create_pkg_rtype 
    - FLAG_IUD - creates the PKG_IUD,with procedure p_create_pkg_iud 
      possible values are 
       N - do not create IUD 
       A - create all inclusive update and delete 
       I - only the multi insert version (for example some views) 
    - FLAG_GET - creates the PKG_GET with procedure p_create_pkg_get, 
      possible values N, Y 
    - GET2_COLUMNS - should be filled with the list of column names 
      separeted by coma for witch the procedure p_create_pkg_get2 
      will create an entry in PKG_GET2, if NULL does not create any 
    - FLAG_MOD_COL - creates the PKG_MOD_COL to list the modified 
      colums 
------------------------------------------------------------------*/ 
        t.idriga, t.tbl_name, t.object_type, t.description, 
        t.flag_insert_trg, t.tbl_idriga, t.flag_audit_trg, 
        t.flag_rtype, t.flag_iud, t.flag_get,t.get2_columns, 
        t.flag_mod_col, t.tbl_audit_idx1, t.tbl_audit_idx2, 
        t.descr_audit_idx1, t.descr_audit_idx2,  t.flag_dcn_trg , 
        t.tbl_name_user,t.ref_const_text,t.un_const_text 
    FROM    APP_TABLE    t
 ;
/
--------------------------------------------------------
--  DDL for View VW_BLO_GRP_ASSOC_CHK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BLO_GRP_ASSOC_CHK" ("REF_WO", "ORG_CODE", "ORDER_CODE", "ITEM_CODE", "ROUTING_CODE", "OPER_CODE", "SEQ_NO", "SEQ_NO_GLB", "GROUP_CODE_ASSOC", "SEGMENT_CODE") AS 
  SELECT  numb01  ref_wo, txt01 org_code, txt02 order_code, txt03 item_code, txt04 routing_code,
        txt05 oper_code, numb02 seq_no, numb03 seq_no_glb, txt06 group_code_assoc, segment_code
FROM
TMP_SEGMENT
WHERE segment_code = 'VW_BLO_GRP_ASSOC_CHK'

 
 ;
/
--------------------------------------------------------
--  DDL for View VW_BLO_IMPORT_WO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BLO_IMPORT_WO" ("ORG_CODE", "ORDER_CODE", "ITEM_CODE", "SIZE_CODE", "QTA", "DATE_CLIENT", "SEGMENT_CODE") AS 
  SELECT 
        txt01       org_code, 
        txt02       order_code, 
        txt03       item_code, 
        txt04       size_code, 
        numb01      qta, 
        data01      date_client, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_BLO_IMPORT_WO' 
WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_BLO_PICK_SHIPMENT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BLO_PICK_SHIPMENT" ("ORG_CODE", "ORDER_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "DESCRIPTION", "COLOUR_CODE", "SIZE_CODE", "SEASON_CODE", "PUOM", "GROUP_CODE", "WHS_CODE", "IDRIGA", "SELECTION", "SEQ_NO", "NOM_QTY", "QTY", "QTY_Q1", "QTY_Q2", "QTY_PICK", "SEGMENT_CODE") AS 
  SELECT
            txt01           org_code    ,
            txt02           order_code  ,
            txt03           item_code   ,
            txt04           oper_code_item   ,
            txt05           description ,
            txt06           colour_code ,
            txt07           size_code   ,
            txt08           season_code ,
            txt09           puom        ,
            txt10           group_code  ,
            txt11           whs_code    ,
            numb01          idriga      ,
            numb02          selection   ,
            numb03          seq_no      ,
            numb04          nom_qty     ,
            numb05          qty         ,
            numb06          qty_q1      ,
            numb07          qty_q2      ,
            numb08          qty_pick    ,
            segment_code
    FROM    TMP_SEGMENT
    WHERE   segment_code    =   'VW_BLO_PICK_SHIPMENT'
    WITH CHECK OPTION

 ;
/
--------------------------------------------------------
--  DDL for View VW_BLO_PREPARE_TRN
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BLO_PREPARE_TRN" ("ORG_CODE", "ITEM_CODE", "COLOUR_CODE", "SIZE_CODE", "OPER_CODE_ITEM", "SEASON_CODE", "ORDER_CODE", "GROUP_CODE", "WHS_CODE", "COST_CENTER", "PUOM", "REASON_CODE", "WC_CODE", "QTY", "TRN_SIGN", "REF_RECEIPT", "SEGMENT_CODE") AS 
  SELECT 
            txt01       org_code    , 
            txt02       item_code   , 
            txt03       colour_code , 
            txt04       size_code   , 
            txt05       oper_code_item   , 
            txt06       season_code , 
            txt07       order_code  , 
            txt08       group_code  , 
            txt09       whs_code    , 
            txt10       cost_center , 
            txt11       puom        , 
            txt12       reason_code , 
            txt13       wc_code, 
            numb01      qty         , 
            numb02      trn_sign    , 
            numb03      ref_receipt , 
            --- 
            segment_code 
     FROM   TMP_SEGMENT 
     WHERE  segment_code    =   'VW_BLO_PREPARE_TRN' 
     WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_BLO_WORK_GROUP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BLO_WORK_GROUP" ("IDRIGA", "DCN", "QTY_TOTAL", "ORDER_NO", "ORG_CODE", "SEASON_CODE", "GROUP_CODE", "DESCRIPTION", "STATUS", "GRP_ROUTING", "PRODUCTION", "COMPONENT_ISSUE", "COMPONENT_COUNT", "NOTE", "DATE_CREATE", "DATE_LAUNCH", "DATE_CLIENT", "SEGMENT_CODE") AS 
  SELECT 
        numb01  idriga, 
        numb02  dcn, 
        numb03  qty_total, 
        numb04  order_no, 
        -- 
        txt01   org_code, 
        txt02   season_code, 
        txt03   group_code, 
        txt04   description, 
        txt05   status, 
        txt06   grp_routing, 
        txt07   production, 
        txt08   component_issue, 
        txt09   component_count, 
        txt10   note, 
        -- 
        data01  date_create, 
        data02  date_launch, 
        data03  date_client, 
        -- 
        segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_BLO_WORK_GROUP' 
WITH CHECK OPTION

 
 ;
/
--------------------------------------------------------
--  DDL for View VW_BLO_WORK_ORDER
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BLO_WORK_ORDER" ("IDRIGA", "DCN", "QTA", "QTA_COMPLET", "QTA_SCRAP", "QTA_SHIP", "QTA_OPER1", "QTA_OPER2", "QTA_OPER3", "QTA_OPER4", "QTA_OPER5", "REF_GROUP", "SEQ_NO", "ORDER_CODE", "GROUP_CODE", "ORG_CODE", "ITEM_CODE", "ROOT_CODE", "DESCRIPTION", "PRIORITY", "CLIENT_LOT", "CLIENT_LOCATION", "STATUS", "SEASON_CODE", "STATUS_WO", "NOTE", "WHS_CONS", "ROUTING_CODE", "OPER_CODE_ITEM", "CLIENT_CODE", "TEHVAR_FBC", "TEHVAR_SORTIMENT", "TEHVAR_CALAPOD", "TEHVAR_MATTYPE", "TEHVAR_SIGLA", "DATE_CREATE", "DATE_LAUNCH", "DATE_COMPLET", "DATE_CLIENT", "DATE_SHIP", "PRESENT_DATE", "SEGMENT_CODE") AS 
  SELECT 
            numb01      idriga, 
            numb02      dcn, 
            numb03      qta, 
            numb04      qta_complet, 
            numb05      qta_scrap, 
            numb06      qta_ship, 
            numb07      qta_oper1, 
            numb08      qta_oper2, 
            numb09      qta_oper3, 
            numb10      qta_oper4, 
            numb11      qta_oper5, 
            numb12      ref_group, 
            numb13      seq_no, 
            ---------------------------- 
            txt01       order_code, 
            txt02       group_code, 
            txt03       org_code, 
            txt04       item_code, 
            txt05       root_code, 
            txt06       description, 
            txt07       priority, 
            txt08       client_lot, 
            txt09       client_location, 
            txt10       status, 
            txt11       season_code, 
            txt12       status_wo, 
            txt13       note, 
            txt14       whs_cons, 
            txt15       routing_code, 
            txt16       oper_code_item, 
            txt17       client_code, 
            txt18       tehvar_fbc, 
            txt19       tehvar_sortiment, 
            txt20       tehvar_calapod, 
            txt21       tehvar_mattype, 
            txt22       tehvar_sigla, 
            ---------------------------------- 
            data01      date_create, 
            data02      date_launch, 
            data03      date_complet, 
            data04      date_client, 
            data05      date_ship, 
            data06      present_date, 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_BLO_WORK_ORDER' 
    WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_BLO_WORK_ORDER_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BLO_WORK_ORDER_U" ("Nr_crt", "Stagiune", "Gestiune", "Bola", "Flux", "Articol", "Faza", "Descriere", "Familie vanzare", "Client", "Lancio", "Stare", "Data inreg", "Data lansarii", "Cant NOM", "Cant CROIT", "Cant CUSUT", "Cant TRAS", "Cant Ambalat", "Cant Produsa", "Cant EXP", "Data EXP", "F/B/C", "Sortiment", "Calapod", "Tip Material") AS 
  SELECT
seq_no      "Nr_crt",
season_code "Stagiune",
org_code    "Gestiune",
order_code  "Bola",
routing_code    "Flux",
item_code   "Articol",
oper_code_item  "Faza",
description "Descriere",
root_code   "Familie vanzare",
client_code "Client",
client_lot  "Lancio",
status      "Stare",
date_create "Data inreg",
date_launch "Data lansarii",
Qta         "Cant NOM",
Qta_oper1   "Cant CROIT",
Qta_oper3   "Cant CUSUT",
Qta_oper4   "Cant TRAS",
Qta_oper5   "Cant Ambalat",
Qta_complet "Cant Produsa",
Qta_ship    "Cant EXP",
date_ship   "Data EXP" ,
TEHVAR_FBC  "F/B/C",
TEHVAR_SORTIMENT    "Sortiment",
TEHVAR_CALAPOD      "Calapod",
TEHVAR_MATTYPE      "Tip Material"
FROM    VW_BLO_WORK_ORDER
 ;
/
--------------------------------------------------------
--  DDL for View VW_BOM_GROUP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BOM_GROUP" ("IDRIGA", "REF_GROUP", "ORG_CODE", "GROUP_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "SIZE_CODE", "COLOUR_CODE", "START_SIZE", "END_SIZE", "QTA", "QTA_DEMAND", "STATUS", "WHS_SUPPLY", "OPER_CODE", "QTA_PICKED", "SCRAP_PERC") AS 
  SELECT 
t.IDRIGA,t.REF_GROUP,t.ORG_CODE, t.GROUP_CODE, 
 t.ITEM_CODE, t.OPER_CODE_ITEM, t.SIZE_CODE, t.COLOUR_CODE, t.START_SIZE, t.END_SIZE, 
 t.QTA, t.QTA_DEMAND, t.STATUS, t.WHS_SUPPLY, t.OPER_CODE, t.QTA_PICKED, 
 t.SCRAP_PERC 
FROM BOM_GROUP t
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_BOM_STD
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_BOM_STD" ("IDRIGA", "ORG_CODE", "FATHER_CODE", "QTA", "COLOUR_CODE", "OPER_CODE", "CHILD_CODE", "QTA_STD", "START_SIZE", "END_SIZE") AS 
  SELECT 
IDRIGA, 
ORG_CODE, 
FATHER_CODE, 
QTA, 
COLOUR_CODE, 
OPER_CODE, 
CHILD_CODE, 
QTA_STD, 
START_SIZE, 
END_SIZE 
FROM BOM_STD
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_CHK_PKG_VS_WHS_STOCK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_CHK_PKG_VS_WHS_STOCK" ("WHS_CODE", "ORG_CODE", "ORDER_CODE", "SIZE_CODE", "PKG_STOCK", "WHS_STOCK") AS 
  SELECT      whs_code, org_code, order_code,size_code, SUM(pkg_stock) pkg_stock, MAX(qty) whs_stock 
FROM 
( 
SELECT      sp.whs_code, sp.org_code,d.order_code, d.size_code, d.qty pkg_stock, s.qty 
FROM        stoc_online_pkg     sp 
INNER JOIN  PACKAGE_DETAIL      d   ON  d.package_code  =   sp.package_code 
LEFT JOIN   stoc_online         s   ON  s.org_code      =   d.org_code 
                                    AND s.order_code    =   d.order_code 
                                    AND s.size_code     =   d.size_code 
                                    AND s.whs_code      =   sp.whs_code 
                                    AND s.group_code    IS NULL 
) 
GROUP BY whs_code, org_code, order_code,size_code 
HAVING SUM(pkg_stock) > NVL(MAX(qty),0)
 ;
/
--------------------------------------------------------
--  DDL for View VW_COLOUR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_COLOUR" ("IDRIGA", "ORG_CODE", "COLOUR_CODE", "DESCRIPTION", "CATEGORY", "COLOUR_CODE2") AS 
  SELECT 
IDRIGA, 
ORG_CODE, 
COLOUR_CODE, 
DESCRIPTION, 
CATEGORY, 
COLOUR_CODE2 
FROM COLOUR
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_EXCEL_OPERATIONS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_EXCEL_OPERATIONS" ("TIP_INFO", "LINE_ORDER", "COLUMN_LIMIT", "FONT_SIZE", "BACKGROUND_COLOUR", "FOREGROUND_COLOUR", "FONT_UNDERLINE", "FONT_BOLD", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK", "AL", "AM", "AN", "AO", "AP", "AQ", "AR") AS 
  SELECT 
tipinf  TIP_INFO, 
numb01  LINE_ORDER, 
numb02  COLUMN_LIMIT, 
TXT50   FONT_SIZE, 
TXT02   BACKGROUND_COLOUR, 
TXT03   FOREGROUND_COLOUR, 
TXT04   FONT_UNDERLINE, 
TXT05   FONT_BOLD, 
TXT06   A, 
TXT07   B, 
TXT08   C, 
TXT09   D, 
TXT10   E, 
TXT11   F, 
TXT12   G, 
TXT13   H, 
TXT14   I, 
TXT15   J, 
TXT16   K, 
TXT17   L, 
TXT18   M, 
TXT19   N, 
TXT20   O, 
TXT21   P, 
TXT22   Q, 
TXT23   R, 
TXT24   S, 
TXT25   T, 
TXT26   U, 
TXT27   V, 
TXT28   W, 
TXT29   X, 
TXT30   Y, 
TXT31   Z, 
TXT32   AA, 
TXT33   AB, 
TXT34   AC, 
TXT35   AD, 
TXT36   AE, 
TXT37   AF, 
TXT38   AG, 
TXT39   AH, 
TXT40   AI, 
TXT41   AJ, 
TXT42   AK, 
TXT43   AL, 
TXT44   AM, 
TXT45   AN, 
TXT46   AO, 
TXT47   AP, 
TXT48   AQ, 
TXT49   AR 
FROM    TMP_GENERAL
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_FIFO_MATERIAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_FIFO_MATERIAL" ("IDRIGA", "REF_RECEIT", "REF_INVOICE", "INV_CODE", "INV_DATE", "QTA", "NOTE", "FLAG_MANUAL", "CUSTOM_CODE") AS 
  SELECT 
t.IDRIGA, t.REF_RECEIT, t.REF_INVOICE, t.INV_CODE, t.INV_DATE, t.QTA, t.NOTE ,t.flag_manual ,t.custom_code 
FROM FIFO_MATERIAL t
 ;
/
--------------------------------------------------------
--  DDL for View VW_GROUP_BOM_ON_SIZE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_GROUP_BOM_ON_SIZE" ("REF_WO", "WO_SIZE_CODE", "ORG_CODE", "CHILD_CODE", "CHILD_DESCRIPTION", "SIZE_CODE", "START_SIZE", "END_SIZE", "COLOUR_CODE", "QTA", "OPER_CODE") AS 
  SELECT    g.idriga                                    ref_wo,
                    d.size_code                                 wo_size_code,
                    b.org_code                                  org_code,
                    b.child_code                                child_code,
                    i.description                               child_description,
                    DECODE(i.flag_size,-1, d.size_code,NULL)    size_code,
                    NVL(b.start_size, i.start_size)             start_size,
                    NVL(b.end_size ,  i.end_size )              end_size,
                    b.colour_code                               colour_code,
                    d.qta * b.qta                               qta, -- calculul se face cu cantitatea masurata si NU standard
                    b.oper_code                                 oper_code
        FROM        WORK_GROUP      g
        INNER JOIN  WO_GROUP        wg  ON g.group_code = wg.group_code
        INNER JOIN  WORK_ORDER      w   ON w.order_code = wg.order_code AND w.org_code = wg.org_code
        INNER JOIN  WO_DETAIL       d   ON d.ref_wo     = w.idriga
        INNER JOIN  BOM_STD         b   ON b.org_code   = w.org_code AND b.father_code = w.item_code AND b.oper_code = wg.oper_code
        INNER JOIN  ITEM            i   ON i.org_code = b.org_code AND i.item_code = b.child_code
        WHERE
                g.idriga        =   34
                -- daca componenta este pe plaja de marime ramane numai aceea pentru care marimea perechii se incadreaza in plaja
                -- are prioritate plaja precizata in norma standard, un cod pe norme standard diferite pot sa aiba plaje diferite
                AND d.size_code    BETWEEN NVL(NVL(b.start_size,i.start_size) ,  '00'  )
                  AND  NVL(NVL(b.end_size,i.end_size)  , '99'  )
        ORDER BY 1,child_code,2
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_GROUP_ROUTING
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_GROUP_ROUTING" ("IDRIGA", "REF_GROUP", "GROUP_CODE", "OPER_CODE", "WHS_CONS", "WHS_DEST", "SEQ_NO", "WORKCENTER_CODE", "MILESTONE", "TEAM_CODE", "SCHED_DATE") AS 
  SELECT 
IDRIGA, 
REF_GROUP, 
GROUP_CODE  , 
OPER_CODE, 
WHS_CONS, 
WHS_DEST , 
SEQ_NO, 
WORKCENTER_CODE , 
milestone, 
TEAM_CODE, 
SCHED_DATE 
FROM GROUP_ROUTING
 ;
/
--------------------------------------------------------
--  DDL for View VW_INVOICE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_INVOICE" ("IDRIGA", "INV_CODE", "INV_DATE", "DATE_LEGAL", "TYPE_IO", "SUB_TYPE", "ORG_CODE", "PAY_DATE", "PLATE_NUMBER", "FLAG_TRANZIT", "FLAG_RECEIT", "CUSTOM_DEC", "CUSTOM_DATE", "INV_YEAR", "PARTNER_NAME", "FISCAL_CODE", "PARTNER_CODE", "REGISTRATION_CODE", "COUNTRY", "LOCATION_NAME", "ADDRESS", "EMPLOYEE_CODE", "FREE_TEXT_PRINT", "NOTE", "DELIVERY_CONDITION", "DELIVERY_CONDITION_AUX", "CURRENCY", "FLAG_BLOCKED") AS 
  SELECT
IDRIGA,
INV_CODE,
INV_DATE,
DATE_LEGAL,
TYPE_IO,
SUB_TYPE,
ORG_CODE,
PAY_DATE,
PLATE_NUMBER,
FLAG_TRANZIT,
FLAG_RECEIT,
CUSTOM_DEC,
CUSTOM_DATE,
INV_YEAR,
PARTNER_NAME,
FISCAL_CODE,
PARTNER_CODE,
REGISTRATION_CODE,
COUNTRY,
LOCATION_NAME,
ADDRESS,
EMPLOYEE_CODE,
FREE_TEXT_PRINT,
NOTE,
DELIVERY_CONDITION,
DELIVERY_CONDITION_AUX,
CURRENCY ,
FLAG_BLOCKED
FROM INVOICE

 ;
/
--------------------------------------------------------
--  DDL for View VW_INVOICE_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_INVOICE_DETAIL" ("IDRIGA", "REF_INVOICE", "ITEM_CODE", "SIZE_CODE", "COLOUR_CODE", "CUSTOM_CODE", "ORIGIN_CODE", "CUSTOM_REF", "UOM", "QTA", "QTA_RECEIT", "UNIT_PRICE", "PRIMARY_UM", "QTA_PUM", "QTA_RECEIT_PUM", "UNIT_PRICE_PUM", "CUSTOM_TAX", "CUSTOM_COM", "WEIGHT_NET", "WEIGHT_BRUT", "WHS_CODE", "ORG_CODE", "SEASON_CODE", "MATERIAL_VALUE", "ORDER_CODE", "TYPE_IO", "FREE_TEXT", "VAT_PERCENT", "LINE_ORDER", "FAMILY_CODE") AS 
  SELECT
t.IDRIGA, t.REF_INVOICE, t.ITEM_CODE, t.SIZE_CODE, t.COLOUR_CODE, t.CUSTOM_CODE,
t.ORIGIN_CODE, t.CUSTOM_REF,t.UOM, t.QTA,t.QTA_RECEIT,t.UNIT_PRICE,t.PRIMARY_UM,t.QTA_PUM,t.QTA_RECEIT_PUM,  t.UNIT_PRICE_PUM,  t.CUSTOM_TAX, t.CUSTOM_COM, t.WEIGHT_NET, t.WEIGHT_BRUT,
t.WHS_CODE,   t.ORG_CODE, t.SEASON_CODE, t.MATERIAL_VALUE, t.ORDER_CODE, t.TYPE_IO,
 t.FREE_TEXT, t.VAT_PERCENT, t.LINE_ORDER, t.FAMILY_CODE
FROM INVOICE_DETAIL t

 ;
/
--------------------------------------------------------
--  DDL for View VW_INVOICE_MATERIAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_INVOICE_MATERIAL" ("IDRIGA", "QTA", "QTA_DEMAND", "QTA_GROUP", "QTA_SPEC", "LINE_VALUE", "QTA_UNIT", "QTA_CONS", "MEDIUM_PRICE", "ORG_CODE", "ITEM_CODE", "COLOUR_CODE", "SIZE_CODE", "PUOM", "SEASON_CODE", "CUSTOM_CODE", "SEGMENT_CODE") AS 
  SELECT 
    numb01      idriga, 
    numb02      qta, 
    numb03      qta_demand, 
    numb04      qta_group, 
    numb05      qta_spec, 
    numb06      line_value, 
    numb07      qta_unit, 
    numb08      qta_cons, 
    numb09      medium_price, 
    txt01       org_code, 
    txt02       item_code, 
    txt03       colour_code, 
    txt04       size_code, 
    txt05       puom, 
    txt06       season_code, 
    txt08       custom_code, 
    segment_code 
FROM  TMP_SEGMENT 
WHERE segment_code  =   'VW_INVOICE_MATERIAL' 
WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_ITEM
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_ITEM" ("IDRIGA", "ORG_CODE", "ITEM_CODE", "DESCRIPTION", "PUOM", "WEIGHT_NET", "WEIGHT_BRUT", "MAKE_BUY", "CUSTOM_CODE", "CUSTOM_CATEGORY", "REORDER_POINT", "MIN_QTA", "MAX_QTA", "OBS", "FLAG_SIZE", "FLAG_COLOUR", "FLAG_RANGE", "START_SIZE", "END_SIZE", "DEFAULT_WHS", "MAT_TYPE", "OPER_CODE", "SUOM", "UOM_CONV", "SCRAP_PERC", "UOM_RECEIT", "ROOT_CODE", "ITEM_CODE2", "VALUATION_PRICE", "ACCOUNT_CODE") AS 
  SELECT 
IDRIGA, 
ORG_CODE, 
ITEM_CODE, 
DESCRIPTION, 
PUOM, 
WEIGHT_NET, 
WEIGHT_BRUT, 
MAKE_BUY, 
CUSTOM_CODE, 
CUSTOM_CATEGORY, 
REORDER_POINT, 
MIN_QTA, 
MAX_QTA, 
OBS, 
FLAG_SIZE, 
FLAG_COLOUR, 
FLAG_RANGE, 
START_SIZE, 
END_SIZE, 
WHS_STOCK, 
MAT_TYPE, 
OPER_CODE, 
SUOM, 
UOM_CONV, 
SCRAP_PERC, 
UOM_RECEIT, 
ROOT_CODE, 
ITEM_CODE2, 
VALUATION_PRICE, 
ACCOUNT_CODE 
FROM ITEM
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_JOIN_BOM_GROUP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_JOIN_BOM_GROUP" ("ORG_CODE", "GROUP_CODE", "B_IDRIGA", "REF_GROUP", "ITEM_CODE", "SIZE_CODE", "COLOUR_CODE", "QTA", "B_STATUS", "WHS_SUPPLY", "OPER_CODE", "QTA_PICKED", "SCRAP_PERC", "START_SIZE", "END_SIZE", "QTA_DEMAND", "OPER_CODE_ITEM", "B_NOTE", "G_IDRIGA", "G_DESCRIPTION", "G_STATUS", "DATE_LAUNCH", "SEASON_CODE", "G_NOTE", "I_IDRIGA", "I_DESCRIPTION", "PUOM", "WEIGHT_NET", "WEIGHT_BRUT", "MAKE_BUY", "CUSTOM_CODE", "CUSTOM_CATEGORY", "REORDER_POINT", "MIN_QTA", "MAX_QTA", "OBS", "FLAG_SIZE", "FLAG_COLOUR", "FLAG_RANGE", "I_START_SIZE", "I_END_SIZE", "WHS_STOCK", "MAT_TYPE", "I_OPER_CODE", "SUOM", "UOM_CONV", "I_SCRAP_PERC", "UOM_RECEIT", "ROOT_CODE", "ITEM_CODE2", "VALUATION_PRICE", "ACCOUNT_CODE", "R_IDRIGA", "R_REF_GROUP", "R_OPER_CODE", "R_WHS_CONS", "SEQ_NO", "TEAM_CODE", "SCHED_DATE", "WORKCENTER_CODE", "WHS_DEST", "MILESTONE", "R_NOTE", "W_WHS_CODE", "W_DESCRIPTION", "W_ACCOUNT_CODE", "W_ORG_CODE", "CATEGORY_CODE") AS 
  SELECT 
       -- BOM_GROUP 
       b.org_code, b.group_code, 
       b.idriga b_idriga, b.ref_group, b.item_code, b.size_code, 
       b.colour_code, b.qta, b.status b_status, b.whs_supply, 
       b.oper_code, b.qta_picked, b.scrap_perc, b.start_size, 
       b.end_size, b.qta_demand, b.oper_code_item, b.note b_note, 
       --WORK_GROUP 
       g.idriga g_idriga, g.description g_description, 
       g.status g_status, g.date_launch, g.season_code, 
       g.note g_note, 
       --ITEM 
       i.idriga i_idriga, i.description i_description, i.puom, 
       i.weight_net, i.weight_brut, i.make_buy, i.custom_code, 
       i.custom_category, i.reorder_point, i.min_qta, i.max_qta, 
       i.obs, i.flag_size, i.flag_colour, i.flag_range, 
       i.start_size i_start_size, i.end_size i_end_size,i.whs_stock, 
       i.mat_type, i.oper_code i_oper_code, i.suom, i.uom_conv, 
       i.scrap_perc i_scrap_perc, i.uom_receit, i.root_code, 
       i.item_code2, i.valuation_price, i.account_code , 
       --GROUP_ROUTING 
       r.idriga r_idriga, r.ref_group r_ref_group, 
       r.oper_code r_oper_code, r.whs_cons r_whs_cons, r.seq_no, 
       r.team_code, 
       r.sched_date, r.workcenter_code, r.whs_dest, r.milestone, 
       r.note r_note, 
       --WAREHOUSE 
       w.whs_code w_whs_code, w.description w_description, 
       w.account_code w_account_code, w.org_code w_org_code, 
       w.category_code 
FROM            BOM_GROUP       b 
INNER JOIN      WORK_GROUP      g 
                    ON  g.org_code      =   b.org_code 
                    AND g.group_code    =   b.group_code 
INNER JOIN      ITEM            i 
                    ON  i.org_code      =   b.org_code 
                    AND i.item_code     =   b.item_code 
LEFT JOIN       GROUP_ROUTING   r 
                    ON  r.group_code    =   b.group_code 
                    AND r.oper_code     =   b.oper_code 
LEFT JOIN       WAREHOUSE       w 
                    ON  r.whs_cons      =   w.whs_code
 ;
/
--------------------------------------------------------
--  DDL for View VW_JOIN_RECEIPT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_JOIN_RECEIPT" ("H_IDRIGA", "RECEIPT_YEAR", "RECEIPT_CODE", "RECEIPT_DATE", "ORG_CODE", "RECEIPT_TYPE", "SUPPL_CODE", "DOC_NUMBER", "DOC_DATE", "INCOTERM", "CURRENCY_CODE", "COUNTRY_FROM", "H_NOTE", "WHS_CODE", "STATUS", "D_IDRIGA", "REF_RECEIPT", "UOM_RECEIPT", "QTY_DOC", "QTY_COUNT", "PUOM", "QTY_DOC_PUOM", "QTY_COUNT_PUOM", "ITEM_CODE", "COLOUR_CODE", "SIZE_CODE", "OPER_CODE_ITEM", "SEASON_CODE", "D_WHS_CODE", "ORDER_CODE", "CUSTOM_CODE", "ORIGIN_CODE", "WEIGHT_NET", "WEIGHT_BRUT", "PRICE_DOC", "PRICE_DOC_PUOM", "D_NOTE", "GROUP_CODE", "WEIGHT_PACK", "DESCRIPTION", "S_WHS_CODE", "S_CURRENCY_CODE", "PROPERTY", "EXTERN", "SERVICE", "FLAG_RETURN", "TRN_TYPE", "I_ITEM_CODE", "I_DESCRIPTION", "I_PUOM", "I_WEIGHT_NET", "I_WEIGT_BRUT", "MAKE_BUY", "I_CUSTOM_CODE", "CUSTOM_CATEGORY", "REORDER_POINT", "MIN_QTA", "MAX_QTA", "OBS", "FLAG_SIZE", "FLAG_COLOUR", "FLAG_RANGE", "START_SIZE", "END_SIZE", "I_ORG_CODE", "WHS_STOCK", "MAT_TYPE", "OPER_CODE", "I_SUOM", "UOM_CONV", "SCRAP_PERC", "UOM_RECEIT", "ROOT_CODE", "ITEM_CODE2", "VALUATION_PRICE", "ACCOUNT_CODE", "T_ORG_CODE", "TRN_YEAR", "TRN_CODE", "TRN_DATE", "T_TRN_TYPE", "REASON_CODE", "FLAG_STORNO", "REF_SHIPMENT", "REF_STORNO", "PARTNER_CODE", "DOC_YEAR", "T_DOC_CODE", "T_DOC_DATE", "NOTE", "EMPLOYEE_CODE", "DATE_LEGAL", "REF_MASTER", "T_REF_RECEIPT", "DATE_LEGAL_YYYYMM") AS 
  SELECT 
    --RECEIPT_HEADER 
    h.idriga h_idriga, h.receipt_year, h.receipt_code, 
    h.receipt_date, h.org_code, h.receipt_type, h.suppl_code, 
    h.doc_number, h.doc_date, h.incoterm, h.currency_code, 
    h.country_from, h.note h_note, h.whs_code, h.status, 
    --RECEIPT_DETAIL 
    d.idriga d_idriga, d.ref_receipt, d.uom_receipt, 
    d.qty_doc, d.qty_count, d.puom, d.qty_doc_puom, 
    d.qty_count_puom,  d.item_code, d.colour_code, 
    d.size_code, d.oper_code_item, d.season_code, 
    d.whs_code d_whs_code, d.order_code, d.custom_code, d.origin_code, 
    d.weight_net, d.weight_brut, d.price_doc, d.price_doc_puom, 
    d.note d_note, d.group_code, d.weight_pack, 
    --SETUP_RECEIPT 
    s.description , s.whs_code s_whs_code, 
    s.currency_code s_currency_code, 
    s.property,s.extern, s.service, s.flag_return, s.trn_type , 
    --ITEM 
    i.item_code i_item_code, i.description i_description, 
    i.puom i_puom, i.weight_net i_weight_net, i.weight_brut 
    i_weigt_brut, i.make_buy, i.custom_code i_custom_code, 
    i.custom_category, i.reorder_point, i.min_qta, i.max_qta, 
    i.obs, i.flag_size, i.flag_colour, i.flag_range, i.start_size, 
    i.end_size, i.org_code i_org_code, i.whs_stock, i.mat_type, 
    i.oper_code, i.suom i_suom, i.uom_conv, i.scrap_perc, 
    i.uom_receit, i.root_code, i.item_code2, i.valuation_price, 
    i.account_code, 
    -- WHS_TRN 
    t.org_code t_org_code, t.trn_year, t.trn_code, t.trn_date, 
    t.trn_type t_trn_type, t.reason_code, t.flag_storno, t.ref_shipment, 
    t.ref_storno, t.partner_code, t.doc_year, t.doc_code t_doc_code, 
    t.doc_date t_doc_date, 
    t.note, t.employee_code, t.date_legal, t.ref_master, 
    t.ref_receipt t_ref_receipt , 
    --!!!!!!!!!! 
    TO_CHAR(t.date_legal,'YYYYMM') date_legal_yyyymm 
    --- 
FROM        RECEIPT_HEADER  h 
INNER JOIN  RECEIPT_DETAIL  d 
                ON  d.ref_receipt   =   h.idriga 
INNER JOIN  SETUP_RECEIPT   s 
                ON  h.receipt_type  =   s.receipt_type 
INNER JOIN  ITEM            i 
                ON  d.org_code      =   i.org_code 
                AND d.item_code     =   i.item_code 
LEFT JOIN   WHS_TRN         t 
                ON  t.ref_receipt   =   h.idriga 
                AND t.flag_storno   =   'N'
 ;
/
--------------------------------------------------------
--  DDL for View VW_JOIN_WHS_TRN
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_JOIN_WHS_TRN" ("IDRIGA_T", "ORG_CODE", "TRN_YEAR", "TRN_CODE", "TRN_DATE", "TRN_TYPE", "REASON_CODE_T", "FLAG_STORNO", "REF_SHIPMENT", "REF_STORNO", "PARTNER_CODE", "DOC_YEAR", "DOC_CODE", "DOC_DATE", "NOTE", "EMPLOYEE_CODE", "DATE_LEGAL", "REF_MASTER", "REF_RECEIPT_T", "IDRIGA_D", "REF_TRN", "ITEM_CODE", "TRN_SIGN_D", "QTY", "WHS_CODE", "COLOUR_CODE", "SIZE_CODE", "GROUP_CODE", "ORDER_CODE", "PUOM", "SEASON_CODE", "COST_CENTER", "ACCOUNT_CODE", "OPER_CODE_ITEM", "REASON_CODE_D", "REF_RECEIPT_D", "DESCRIPTION_R", "REASON_TYPE", "TRN_SIGN_R", "PROPERTY", "ALLOC_WO", "ACCOUNTING", "BUSINESS_FLOW", "DESCRIPTION_I", "PIOM_I", "WEIGHT_NET", "WEIGHT_BRUT", "MAKE_BUY", "CUSTOM_CODE", "CUSTOM_CATEGORY", "REORDER_POINT", "MIN_QTA", "MAX_QTA", "OBS", "FLAG_SIZE", "FLAG_COLOUR", "FLAG_RANGE", "START_SIZE", "END_SIZE", "WHS_STOCK", "MAT_TYPE", "OPER_CODE", "SUOM", "UOM_CONV", "SCRAP_PERC", "UOM_RECEIT", "ROOT_CODE", "ITEM_CODE2", "VALUATION_PRICE", "ACCOUNT_CODE_I", "DESCRIPTION_C", "CATEGORY", "COLOUR_CODE2") AS 
  SELECT 
    --WHS_TRN 
    t.idriga idriga_t, t.org_code, t.trn_year, t.trn_code, 
    t.trn_date, t.trn_type, t.reason_code reason_code_t, 
    t.flag_storno, 
    t.ref_shipment, t.ref_storno, t.partner_code, t.doc_year, 
    t.doc_code, t.doc_date, t.note, t.employee_code, 
    t.date_legal, t.ref_master, t.ref_receipt ref_receipt_t, 
    --WHS_TRN_DETAIL 
    d.idriga idriga_d, d.ref_trn, d.item_code, 
    d.trn_sign trn_sign_d, d.qty, d.whs_code, d.colour_code, 
    d.size_code, 
    d.group_code, d.order_code, d.puom, d.season_code, 
    d.cost_center, d.account_code, d.oper_code_item, 
    d.reason_code reason_code_d, d.ref_receipt ref_receipt_d, 
    --WHS_TRN_REASON 
    r.description description_r, r.reason_type, 
    r.trn_sign trn_sign_r, 
    r.property, r.alloc_wo, r.accounting, r.business_flow , 
    --ITEM 
    i.description description_i, i.puom piom_i, i.weight_net, 
    i.weight_brut, i.make_buy, i.custom_code, i.custom_category, 
    i.reorder_point, i.min_qta, i.max_qta, i.obs, i.flag_size, 
    i.flag_colour, i.flag_range, i.start_size, i.end_size, 
    i.whs_stock, i.mat_type, i.oper_code, i.suom, i.uom_conv, 
    i.scrap_perc, i.uom_receit, i.root_code, i.item_code2, 
    i.valuation_price, i.account_code account_code_i, 
    --COLOUR 
    c.description description_c, c.CATEGORY, c.colour_code2 
    -- 
FROM            WHS_TRN         t 
INNER   JOIN    WHS_TRN_DETAIL  d 
                    ON  d.ref_trn       =   t.idriga 
INNER   JOIN    WHS_TRN_REASON  r 
                    ON  r.reason_code   =   d.reason_code 
INNER   JOIN    ITEM            i 
                    ON  i.org_code      =   d.org_code 
                    AND i.item_code     =   d.item_code 
LEFT    JOIN    COLOUR          c 
                    ON  c.org_code      =   d.org_code 
                    AND c.colour_code   =   d.colour_code
 ;
/
--------------------------------------------------------
--  DDL for View VW_MOVEMENT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_MOVEMENT" ("ITEM_CODE", "SIZE_CODE", "COLOUR_CODE", "REASON", "ORDER_CODE", "GROUP_CODE", "WHS_CODE", "OPER_CODE", "QTA", "UNIT_PRICE", "IDRIGA_GENERIC1", "IDRIGA_GENERIC2", "IDRIGA_GENERIC3", "REF_INVOICE") AS 
  SELECT 
txt01   ITEM_CODE, 
txt02   SIZE_CODE, 
txt03   COLOUR_CODE, 
txt04   REASON, 
txt05   ORDER_CODE, 
txt06   GROUP_CODE, 
txt07   WHS_CODE, 
txt08   OPER_CODE, 
numb01  QTA, 
numb02  UNIT_PRICE, 
numb03 IDRIGA_GENERIC1, 
numb04 IDRIGA_GENERIC2, 
numb05 IDRIGA_GENERIC3, 
numb06  ref_invoice 
FROM VW_TRANSFER_ORACLE
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_MOVEMENT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_MOVEMENT_TYPE" ("TRN_TYPE", "DESCRIPTION") AS 
  SELECT 
t.trn_type, t.DESCRIPTION 
FROM  MOVEMENT_TYPE t
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_MULTI_TABLE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_MULTI_TABLE" ("IDRIGA", "TABLE_NAME", "TABLE_KEY", "DESCRIPTION", "SEQ_NO", "FLAG_ACTIVE") AS 
  SELECT 
IDRIGA, TABLE_NAME, TABLE_KEY,DESCRIPTION, SEQ_NO , flag_active 
FROM    MULTI_TABLE
 ;
/
--------------------------------------------------------
--  DDL for View VW_ORGANIZATION
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_ORGANIZATION" ("ORG_CODE", "ORG_NAME", "FLAG_CLIENT", "FLAG_SUPPLY", "COUNTRY", "CITY", "ADDRESS", "PHONE", "FAX", "EMAIL", "CONTACT_PERS", "BANK", "BANK_ACCOUNT", "FISCAL_CODE", "REGIST_CODE", "TRANSP_LTIME", "FLAG_GRP_OMOG") AS 
  SELECT 
T.ORG_CODE, T.ORG_NAME, T.FLAG_CLIENT, T.FLAG_SUPPLY, T.COUNTRY, T.CITY, T.ADDRESS, T.PHONE, T.FAX, T.EMAIL, T.CONTACT_PERS, T.BANK, T.BANK_ACCOUNT, T.FISCAL_CODE, T.REGIST_CODE, T.TRANSP_LTIME, T.FLAG_GRP_OMOG 
FROM   ORGANIZATION t
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_PARAMETER
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PARAMETER" ("IDRIGA", "ORG_CODE", "PAR_CODE", "PAR_KEY", "ATTRIBUTE01", "ATTRIBUTE02", "ATTRIBUTE03", "ATTRIBUTE04", "ATTRIBUTE05", "ATTRIBUTE06", "ATTRIBUTE07", "ATTRIBUTE08", "ATTRIBUTE09", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "ATTRIBUTE16", "ATTRIBUTE17", "ATTRIBUTE18", "ATTRIBUTE19", "ATTRIBUTE20") AS 
  SELECT 
t.IDRIGA, t.ORG_CODE, t.PAR_CODE, t.par_key,t.ATTRIBUTE01, t.ATTRIBUTE02, t.ATTRIBUTE03, t.ATTRIBUTE04, t.ATTRIBUTE05, t.ATTRIBUTE06, t.ATTRIBUTE07, t.ATTRIBUTE08, t.ATTRIBUTE09, t.ATTRIBUTE10, t.ATTRIBUTE11, t.ATTRIBUTE12, t.ATTRIBUTE13, t.ATTRIBUTE14, t.ATTRIBUTE15, t.ATTRIBUTE16, t.ATTRIBUTE17, t.ATTRIBUTE18, t.ATTRIBUTE19, t.ATTRIBUTE20 
FROM    PARAMETER t
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_ACREC_MAT_VALUE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_ACREC_MAT_VALUE" ("CUSTOM_CODE", "SUPPL_CODE", "ORG_NAME", "ORG_CODE", "ITEM_CODE", "PROPERTY", "CURRENCY_CODE", "QTY", "PRICE_DOC_PUOM", "VALUE_LINE_EUR", "EXCHANGE_RATE", "DATE_LEGAL", "SEGMENT_CODE") AS 
  SELECT  txt01       custom_code , 
            txt02       suppl_code  , 
            txt03       org_name    , 
            txt04       org_code    , 
            txt05       item_code   , 
            txt06       property    , 
            txt07       currency_code, 
            numb01      qty, 
            numb02      price_doc_puom, 
            numb03      value_line_eur, 
            numb04      exchange_rate , 
            data01      date_legal  , 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_PREP_ACREC_MAT_VALUE' 
    WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_BOM_FIFO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_BOM_FIFO" ("ORG_CODE", "ORDER_CODE", "ITEM_CODE", "SIZE_CODE", "COLOUR_CODE", "OPER_CODE_ITEM", "START_SIZE", "END_SIZE", "OPER_CODE", "PUOM", "FIFO_ROUND_UNIT", "QTY", "SEGMENT_CODE") AS 
  SELECT 
            txt01       org_code        , 
            txt02       order_code      , 
            txt03       item_code       , 
            txt04       size_code       , 
            txt05       colour_code     , 
            txt06       oper_code_item  , 
            txt07       start_size      , 
            txt08       end_size        , 
            txt09       oper_code       , 
            txt10       puom            , 
            txt11       fifo_round_unit , 
            numb01      qty, 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_PREP_BOM_FIFO' 
    WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_DPR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_DPR" ("ORG_CODE", "ORDER_CODE", "SIZE_CODE", "PROD_QTY", "SEGMENT_CODE") AS 
  SELECT  txt01 org_code, txt02 order_code, txt03 size_code,numb01 prod_qty,segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code = 'VW_PREP_DPR' 
WITH CHECK OPTION
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_GROUP_CODE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_GROUP_CODE" ("GROUP_CODE", "SEGMENT_CODE") AS 
  SELECT 
            txt01       group_code, 
            -- 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_PREP_GROUP_CODE' 
    WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_GRP_DPR_QTY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_GRP_DPR_QTY" ("ORG_CODE", "GROUP_CODE", "ORDER_CODE", "SIZE_CODE", "OPER_CODE", "DPR_QTY", "SEGMENT_CODE") AS 
  SELECT  txt01   org_code, 
        txt02   group_code, 
        txt03   order_code, 
        txt04   size_code, 
        txt05   oper_code, 
        numb01  dpr_qty , 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code = 'VW_PREP_GRP_DPR_QTY' 
WITH CHECK OPTION
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_GRP_NOM_QTY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_GRP_NOM_QTY" ("ORG_CODE", "GROUP_CODE", "ORDER_CODE", "SIZE_CODE", "OPER_CODE", "NOM_QTY", "SEGMENT_CODE") AS 
  SELECT  txt01   org_code, 
        txt02   group_code, 
        txt03   order_code, 
        txt04   size_code, 
        txt05   oper_code, 
        numb01  nom_qty, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code = 'VW_PREP_GRP_NOM_QTY' 
WITH CHECK OPTION
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_ITEM_CODE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_ITEM_CODE" ("ITEM_CODE", "ORG_CODE", "SEGMENT_CODE") AS 
  SELECT 
            txt01       item_code   , 
            txt02       org_code    , 
            -- 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_PREP_ITEM_CODE' 
    WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_LOG_VS_AC
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_LOG_VS_AC" ("DATE_LEGAL", "ORG_CODE", "REF_TRN", "TRN_YEAR", "TRN_CODE", "TRN_DATE", "TRN_TYPE", "FLAG_STORNO", "LOG_DOC_INFO", "AC_DATE_LEGAL", "AC_DOC_CODE", "AC_DOC_YEAR", "AC_DOC_TYPE", "AC_STATUS", "CURRENCY_CODE", "REPORT_OBJECT", "AC_ORG_CODE", "SEGMENT_CODE") AS 
  SELECT 
data01  DATE_LEGAL, 
txt01   ORG_CODE, 
numb01  REF_TRN, 
txt02   TRN_YEAR, 
txt03   TRN_CODE, 
txt04   TRN_DATE, 
txt05   TRN_TYPE, 
txt06   FLAG_STORNO, 
txt07   LOG_DOC_INFO, 
data02  AC_DATE_LEGAL, 
txt08   AC_DOC_CODE, 
txt09   AC_DOC_YEAR, 
txt10   AC_DOC_TYPE, 
txt11   AC_STATUS, 
txt12   CURRENCY_CODE, 
txt13   REPORT_OBJECT, 
txt14   AC_ORG_CODE, 
segment_code 
FROM TMP_SEGMENT 
WHERE 
segment_code = 'VW_PREP_LOG_VS_AC'
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_MATERIAL_FIFO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_MATERIAL_FIFO" ("ORG_CODE", "ITEM_CODE", "SIZE_CODE", "COLOUR_CODE", "OPER_CODE_ITEM", "SEASON_CODE", "PUOM", "FIFO_ROUND_UNIT", "SHIP_SUBCAT", "QTY", "SEGMENT_CODE") AS 
  SELECT txt01 org_code ,
    txt02 item_code ,
    txt03 size_code ,
    txt04 colour_code ,
    txt05 oper_code_item ,
    txt06 season_code ,
    txt08 puom ,
    txt09 fifo_round_unit ,
    txt10 ship_subcat,
    numb01 qty,
    segment_code
  FROM TMP_SEGMENT
  WHERE segment_code = 'VW_PREP_MATERIAL_FIFO'
WITH CHECK OPTION;
/
--------------------------------------------------------
--  DDL for View VW_PREP_ORD_EXP_QTY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_ORD_EXP_QTY" ("ORG_CODE", "ORDER_CODE", "SIZE_CODE", "OPER_CODE", "EXP_QTY", "SEGMENT_CODE") AS 
  SELECT  txt01   org_code, 
        txt02   order_code, 
        txt03   size_code, 
        txt04   oper_code, 
        numb01  exp_qty , 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code = 'VW_PREP_ORD_EXP_QTY' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_ORD_FIN_QTY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_ORD_FIN_QTY" ("ORG_CODE", "ORDER_CODE", "SIZE_CODE", "FIN_QTY", "SEGMENT_CODE") AS 
  SELECT  txt01   org_code, 
        txt02   order_code, 
        txt03   size_code, 
        numb01  fin_qty , 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code = 'VW_PREP_ORD_FIN_QTY' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_ORD_PKG_QTY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_ORD_PKG_QTY" ("ORG_CODE", "ORDER_CODE", "SIZE_CODE", "PKG_QTY", "SEGMENT_CODE") AS 
  SELECT  txt01   org_code, 
        txt02   order_code, 
        txt03   size_code, 
        numb01  pkg_qty , 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code = 'VW_PREP_ORD_PKG_QTY' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_PACKAGE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_PACKAGE" ("ORG_CODE", "PACKAGE_CODE", "PACKAGE_INFO", "ORDER_CODE", "ORDER_INFO", "SIZE_CODE", "QUALITY", "STATUS", "ERROR_LOG", "ERROR_LOG_H", "STATUS_H", "PRINTING_STATUS", "QTY", "SEQ_NO", "REF_PKG_DETAIL", "SEGMENT_CODE") AS 
  SELECT  txt01   org_code, 
        txt02   package_code, 
        txt03   package_info, 
        txt04   order_code, 
        txt05   order_info, 
        txt06   size_code, 
        txt07   quality, 
        txt08   status, 
        txt09   error_log, 
        txt10   error_log_h, 
        txt11   status_h, 
        txt12   printing_status, 
        numb01  qty, 
        numb02  seq_no, 
        numb03  ref_pkg_detail, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_PREP_PACKAGE' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_PACKLIST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_PACKLIST" ("ORG_CODE", "ITEM_CODE", "DESCRIPTION", "ORDER_CODE", "IDRIGA", "NOM_QTY", "UM", "PAST_SHIP", "SHIP_QTY", "DETAILED_Q1", "DETAILED_Q2", "COLLET", "NOTE", "SHIP_CODE_BC", "SHIP_INFO", "SEGMENT_CODE") AS 
  SELECT  txt01   org_code, 
        txt02   item_code, 
        txt03   description, 
        txt04   order_code, 
        numb01  idriga, 
        numb02  nom_qty, 
        txt05   um, 
        txt06   past_ship, 
        numb03  ship_qty, 
        txt07   detailed_q1, 
        txt08   detailed_q2, 
        txt09   collet, 
        txt10   note, 
        txt11   ship_code_bc, 
        txt50   ship_info, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_PREP_PACKLIST' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_PICK_PLAN
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_PICK_PLAN" ("ORG_CODE", "GROUP_CODE_IN", "ITEM_CODE", "OPER_CODE_ITEM", "COLOUR_CODE", "SIZE_CODE", "START_SIZE", "END_SIZE", "SEASON_CODE_IN", "PUOM", "WHS_CODE_OUT", "WHS_CODE_IN", "OPER_CODE", "DESCRIPTION", "GROUP_CODE_OUT", "SEASON_CODE_OUT", "FLAG_TOTAL_LINE", "DESCRIPTION_COLOUR", "FLAG_DIRTY", "ORDER_CODE", "IDRIGA", "DCN", "REF_PLAN", "SEQ_NO", "SEQ_NO2", "SEQ_GROUP", "QTY_DEMAND_INI", "QTY_DEMAND_NOW", "QTY_STOCK", "QTY_PICK", "QTY_FREE", "QTY_APICK", "SEGMENT_CODE") AS 
  SELECT 
            txt01       org_code, 
            txt02       group_code_in, 
            txt03       item_code, 
            txt04       oper_code_item, 
            txt05       colour_code, 
            txt06       size_code, 
            txt07       start_size, 
            txt08       end_size, 
            txt09       season_code_in, 
            txt10       puom, 
            txt11       whs_code_out, 
            txt12       whs_code_in, 
            txt13       oper_code, 
            txt14       description, 
            txt15       group_code_out, 
            txt16       season_code_out, 
            txt17       flag_total_line, 
            txt18       description_colour, 
            txt19       flag_dirty, 
            txt20       order_code, 
            -- 
            numb01      idriga  , 
            numb02      dcn, 
            numb03      ref_plan, 
            numb04      seq_no, 
            numb05      seq_no2, 
            numb06      seq_group, 
            numb07      qty_demand_ini, 
            numb08      qty_demand_now, 
            numb09      qty_stock, 
            numb10      qty_pick, 
            numb11      qty_free, 
            numb12      qty_apick, 
            -- 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_PREP_PICK_PLAN' 
    WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_RECEIPT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_RECEIPT" ("RECEIPT_CODE", "RECEIPT_TYPE", "SUPPL_CODE", "DOC_NUMBER", "INCOTERM", "CURRENCY_CODE", "COUNTRY_FROM", "STATUS", "DESCRIPTION_RECEIPT", "UOM_RECEIPT", "PUOM", "ORG_CODE", "ITEM_CODE", "COLOUR_CODE", "SIZE_CODE", "OPER_CODE_ITEM", "SEASON_CODE", "CUSTOM_CODE", "ORIGIN_CODE", "GROUP_CODE", "DESCRIPTION_ITEM", "DESCRIPTION_COLOUR", "DESCRIPTION_CUSTOM", "YEAR_MONTH_DOC", "YEAR_MONTH_RECEIPT", "SUPL_UM", "EXTERN", "SERVICE", "QTY_DOC", "QTY_COUNT", "QTY_DOC_PUOM", "QTY_COUNT_PUOM", "PRICE_DOC", "PRICE_DOC_PUOM", "WEIGHT_NET", "WEIGHT_BRUT", "EXCHANGE_RATE", "SEQ_NO", "QTY_FIFO", "RECEIPT_DATE", "DOC_DATE", "DATE_LEGAL", "SEGMENT_CODE") AS 
  SELECT 
            txt01   receipt_code, 
            txt02   receipt_type, 
            txt03   suppl_code  , 
            txt04   doc_number, 
            txt05   incoterm, 
            txt06   currency_code, 
            txt07   country_from, 
            txt08   status, 
            txt09   description_receipt, 
            txt10   uom_receipt, 
            txt11   puom, 
            txt12   org_code, 
            txt13   item_code, 
            txt14   colour_code, 
            txt15   size_code, 
            txt16   oper_code_item, 
            txt17   season_code, 
            txt18   custom_code, 
            txt19   origin_code, 
            txt20   group_code, 
            txt21   description_item, 
            txt22   description_colour, 
            txt23   description_custom, 
            txt24   year_month_doc, 
            txt25   year_month_receipt, 
            txt26   supl_um, 
            txt27   extern, 
            txt28   service, 
            --- 
            numb01  qty_doc, 
            numb02  qty_count, 
            numb03  qty_doc_puom, 
            numb04  qty_count_puom, 
            numb05  price_doc, 
            numb06  price_doc_puom, 
            numb07  weight_net, 
            numb08  weight_brut, 
            numb09  exchange_rate, 
            numb10  seq_no, 
            numb11  qty_fifo, 
            --- 
            data01  receipt_date, 
            data02  doc_date, 
            data03  date_legal, 
            --- 
            segment_code 
     FROM   TMP_SEGMENT 
     WHERE  segment_code    =   'VW_PREP_RECEIPT' 
     WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_SCAN_SHIP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_SCAN_SHIP" ("ORG_CODE", "SHIP_CODE", "SHIP_INFO", "PACKAGE_CODE", "PACKAGE_INFO", "STATUS", "ERROR_LOG", "ERROR_LOG_H", "STATUS_H", "REF_SHIP", "REF_SHIP_PKG", "SEQ_NO", "PKG_QTY", "SEGMENT_CODE") AS 
  SELECT  txt01   org_code, 
        txt02   ship_code, 
        txt03   ship_info, 
        txt04   package_code, 
        txt05   package_info, 
        txt08   status, 
        txt09   error_log, 
        txt10   error_log_h, 
        txt11   status_h, 
        numb01  ref_ship, 
        numb02  ref_ship_pkg, 
        numb03  seq_no, 
        numb04  pkg_qty, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_PREP_SCAN_SHIP' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_SCAN_TRN
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_SCAN_TRN" ("ORG_CODE", "PACKAGE_CODE", "PACKAGE_INFO", "PACKAGE_CONTENT", "WHS_OUT", "WHS_IN", "ERROR_LOG", "EMPL_CODE", "STATUS", "TRN_INFO", "TRN_SIGN", "REF_TRN", "REF_TRN_D", "TRN_QTY", "TRN_DATE", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code, 
txt02   package_code, 
txt03   package_info, 
txt04   package_content, 
txt05   whs_out, 
txt06   whs_in, 
txt07   error_log, 
txt08   empl_code, 
txt09   status, 
txt10   trn_info, 
numb01  trn_sign, 
numb02  ref_trn, 
numb03  ref_trn_d, 
numb04  trn_qty, 
data01  trn_date, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_PREP_SCAN_TRN' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_PREP_WORK_DEMAND
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PREP_WORK_DEMAND" ("ORG_CODE", "ORDER_CODE", "STATUS", "ITEM_CODE", "OPER_CODE_ITEM", "DESCRIPTION", "SEASON_CODE", "SIZE_CODE", "COLOUR_CODE", "OPER_CODE", "QTY_TOT", "QTY_DEMAND", "SEGMENT_CODE") AS 
  SELECT      txt01   org_code,
            txt02   order_code,
            txt03   status,
            txt04   item_code,
            txt05   oper_code_item,
            txt06   description,
            txt07   season_code,
            txt08   size_code,
            txt09   colour_code,
            txt10   oper_code,
            numb01  qty_tot,
            numb02  qty_demand,
            segment_code
FROM        TMP_SEGMENT
WHERE       segment_code     =   'VW_PREP_WORK_DEMAND'
WITH CHECK OPTION

 ;
/
--------------------------------------------------------
--  DDL for View VW_PROGRESS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_PROGRESS" ("ORG_CODE", "GROUP_CODE", "ORDER_CODE", "REF_ROUTING", "REF_DETAIL", "QTA_ENTRY", "QTA_COMPLET", "SEGMENT_CODE") AS 
  SELECT 
txt01 org_code, 
txt02 group_code, 
txt03 order_code, 
numb01  ref_routing, 
numb02  ref_detail, 
numb03  qta_entry, 
numb04  qta_complet, 
segment_code 
FROM  TMP_SEGMENT 
WHERE segment_code = 'VW_PROGRESS' 
WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_QRP_PKG_SHEET
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_QRP_PKG_SHEET" ("REP_TITLE", "REP_INFO", "ORG_CODE", "PACKAGE_CODE", "ORDER_CODE", "ITEM_CODE", "DESCRIPTION", "WO_SIZE", "WO_QTY_1", "WO_QTY_2", "PACKAGE_CODE_BC", "PICTURE_PATH", "TXT_PKG_CONTENT", "REPORT_CODE", "USER_CODE") AS 
  SELECT  txt01   rep_title, 
        txt02   rep_info, 
        txt03   org_code, 
        txt04   package_code, 
        txt05   order_code, 
        txt06   item_code, 
        txt07   description, 
        txt09   wo_size, 
        txt10   wo_qty_1, 
        txt11   wo_qty_2, 
        txt12   package_code_bc, 
        txt13   picture_path, 
        txt36   txt_pkg_content, 
        report_code, 
        user_code 
FROM REPORT_QUEUE_DETAIL 
WHERE report_code = 'PKG_SHEET'
 ;
/
--------------------------------------------------------
--  DDL for View VW_RAP_ACTIVITY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RAP_ACTIVITY_REPORT" ("SEQ_NO", "REQUEST_DATE", "DESCRIPTION", "DEADLINE", "IMPLEMENT_TIME") AS 
  SELECT  numb01  seq_no, 
        data01  request_date, 
        txt50   description, 
        data02  deadline, 
        numb02  implement_time 
FROM   TMP_GENERAL
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_RAP_CHECK_MATERIAL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RAP_CHECK_MATERIAL" ("ORG_CODE", "ITEM_CODE", "SIZE_CODE", "COLOUR_CODE", "SEASON_CODE", "DEMAND_CURRENT", "DEMAND_AUTORIZED", "DEMAND_LAUNCHED", "DEMAND_ALL", "QTA_ON_HAND", "QTA_TRANZIT", "FLAG_ALERT", "SEGMENT_CODE") AS 
  SELECT 
txt01       org_code, 
txt02     item_code, 
txt03     size_code, 
txt04     colour_code, 
txt05       season_code, 
numb01     demand_current, 
numb02     demand_autorized, 
numb03     demand_launched, 
numb04     demand_all, 
numb05      qta_on_hand, 
numb06      qta_tranzit, 
numb07     flag_alert, 
segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_RAP_CHECK_MATERIAL' 
WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_RAP_CHECK_MATERIAL_GROUP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RAP_CHECK_MATERIAL_GROUP" ("ORG_CODE", "ITEM_CODE", "SIZE_CODE", "COLOUR_CODE", "DESCRIPTION", "PUOM", "DEMAND_CURRENT", "DEMAND_AUTORIZED", "DEMAND_LAUNCHED", "DEMAND_ALL", "QTA_ON_HAND", "QTA_TRANZIT", "FLAG_ALERT", "LINE_ORDER", "PRODUCT_INFO", "NOW", "SEGMENT_CODE") AS 
  SELECT 
txt01       org_code, 
txt02     item_code, 
txt03     size_code, 
txt04     colour_code, 
txt05     description, 
txt06       puom, 
numb01     demand_current, 
numb02     demand_autorized, 
numb03     demand_launched, 
numb04     demand_all, 
numb05      qta_on_hand, 
numb06      qta_tranzit, 
numb07     flag_alert, 
numb08     line_order, 
clob01     product_info, 
data01     now , 
segment_code 
FROM TMP_SEGMENT 
WHERE   segment_code    =   'VW_RAP_CHECK_MATERIAL_GROUP' 
WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_RAP_DIF_PHISIC_SCRIPTIC
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RAP_DIF_PHISIC_SCRIPTIC" ("ORG_CODE", "ITEM_CODE", "WHS_CODE", "SEASON_CODE", "COLOUR_CODE", "SIZE_CODE", "WO_MAKE", "PUOM", "CORECT", "DESCRIPTION", "QTY_PHISIC", "QTY_SCRIPTIC", "QTY_DIF_PS", "QTY_DIF_ABS", "DATE_LEGAL", "SEGMENT_CODE") AS 
  SELECT 
            txt01       org_code, 
            txt02       item_code, 
            txt03       whs_code, 
            txt04       season_code, 
            txt05       colour_code, 
            txt06       size_code, 
            txt07       wo_make, 
            txt08       puom, 
            txt09       corect, 
            txt10       description, 
            numb01      qty_phisic, 
            numb02      qty_scriptic, 
            numb03      qty_dif_ps, 
            numb04      qty_dif_abs, 
            data01      date_legal, 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_RAP_DIF_PHISIC_SCRIPTIC' 
    WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_REPORTS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REPORTS" ("IDRIGA", "REPORT_NAME", "ID_CATEG", "SQL_PROC", "SQL_SELECT", "COD_RAP", "NOTE", "COUNTER") AS 
  SELECT 
t.IDRIGA, t.REPORT_NAME, t.ID_CATEG, t.SQL_PROC, t.SQL_SELECT, t.COD_RAP, t.NOTE, t.COUNTER 
FROM    REPORTS t
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_REPORTS_PARAMETER
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REPORTS_PARAMETER" ("ID_REPORT", "IDRIGA", "LABEL", "ORD", "ORD_PROCEDURE", "TIPPAR", "STRSQL", "BLOC", "CONTROL_NAME") AS 
  SELECT 
t.ID_REPORT,t.IDRIGA, t.LABEL,  t.ORD,t.ord_procedure, t.TIPPAR, t.STRSQL, t.BLOC, t.control_name 
FROM  REPORTS_PARAMETER t
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_ACREC_INVOICE_02
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_ACREC_INVOICE_02" ("CLIENT_CODE", "CLIENT_NAME", "CLIENT_ADDRESS", "CLIENT_BANK", "CLIENT_BANK_ACC", "CLIENT_CITY", "CLIENT_COUNTRY", "CLIENT_PHONE", "CLIENT_FAX", "CLIENT_FISCAL_CODE", "CLIENT_NOTE", "CLIENT_REGIST_CODE", "DESTIN_NAME", "DESTIN_ADDRESS", "DESTIN_CITY", "DESTIN_COUNTRY", "DESTIN_PHONE", "DESTIN_FAX", "DESTIN_FISCAL_CODE", "DESTIN_NOTE", "DESTIN_REGIST_CODE", "MY_CODE", "MY_NAME", "MY_ADDRESS", "MY_BANK", "MY_BANK_ACC", "MY_CITY", "MY_COUNTRY", "MY_PHONE", "MY_FAX", "MY_FISCAL_CODE", "MY_NOTE", "MY_REGIST_CODE", "ACREC_TYPE", "PROTOCOL_CODE", "INCOTERM", "INCOTERM_DESCRIPTION", "VAT_CODE", "TRUCK_NUMBER", "CURRENCY_CODE", "REF_ACREC", "EXCHANGE_RATE", "PROTOCOL_DATE", "DUE_DATE", "ORG_CODE", "CUSTOM_CODE", "UOM", "SUPPL_CODE", "SUPPL_NAME", "PACK_MODE", "RECEIPT_TYPE", "DOC_NUMBER", "CUSTOM_DESCRIPTION", "INVOICE_CODE", "PACK_MODE_DESC", "UNIT_PRICE", "QTY_DOC", "TOT_AMOUNT", "TOT_WEIGHT", "TOT_PACKAGES", "FIFO_PRICE", "INV_TOT_AMOUNT", "INV_TOT_WEIGHT", "INV_TOT_PACKAGES", "INV_QTY_DOC", "DOC_DATE", "SERVICE_DESCRIPTION", "NOTE", "RN") AS 
  SELECT h.CLIENT_CODE,
    h.CLIENT_NAME,
    CLIENT_ADDRESS,
    CLIENT_BANK,
    CLIENT_BANK_ACC,
    CLIENT_CITY,
    CLIENT_COUNTRY,
    CLIENT_PHONE,
    CLIENT_FAX,
    CLIENT_FISCAL_CODE,
    CLIENT_NOTE,
    CLIENT_REGIST_CODE,
    DESTIN_NAME,
    DESTIN_ADDRESS,
    DESTIN_CITY,
    DESTIN_COUNTRY,
    DESTIN_PHONE,
    DESTIN_FAX,
    DESTIN_FISCAL_CODE,
    DESTIN_NOTE,
    DESTIN_REGIST_CODE,
    MY_CODE,
    MY_NAME,
    MY_ADDRESS,
    MY_BANK,
    MY_BANK_ACC,
    MY_CITY,
    MY_COUNTRY,
    MY_PHONE,
    MY_FAX,
    MY_FISCAL_CODE,
    MY_NOTE,
    MY_REGIST_CODE,
    ACREC_TYPE,
    PROTOCOL_CODE,
    INCOTERM,
    INCOTERM_DESCRIPTION,
    VAT_CODE,
    TRUCK_NUMBER,
    h.CURRENCY_CODE,
    h.REF_ACREC,
    h.EXCHANGE_RATE,
    h.PROTOCOL_DATE,
    DUE_DATE,
    ORG_CODE,
    CUSTOM_CODE,
    UOM,
    SUPPL_CODE,
    SUPPL_NAME,
    PACK_MODE,
    RECEIPT_TYPE,
    d.DOC_NUMBER,
    CUSTOM_DESCRIPTION,
    INVOICE_CODE,
    PACK_MODE_DESC,
    UNIT_PRICE,
    QTY_DOC,
    TOT_AMOUNT,
    TOT_WEIGHT,
    TOT_PACKAGES,
    FIFO_PRICE,
    INV_TOT_AMOUNT,
    INV_TOT_WEIGHT,
    INV_TOT_PACKAGES,
    INV_QTY_DOC,
    DOC_DATE,
    SERVICE_DESCRIPTION,
    h.note,
    rn
  FROM vw_rep_acrec_invoice_02_h h
  INNER JOIN vw_rep_acrec_invoice_02_d d
  ON d.ref_acrec = h.ref_acrec;
/
--------------------------------------------------------
--  DDL for View VW_REP_ACREC_INVOICE_02_D
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_ACREC_INVOICE_02_D" ("ORG_CODE", "CUSTOM_CODE", "UOM", "SUPPL_CODE", "SUPPL_NAME", "PACK_MODE", "CURRENCY_CODE", "RECEIPT_TYPE", "DOC_NUMBER", "CUSTOM_DESCRIPTION", "INVOICE_CODE", "PACK_MODE_DESC", "SERVICE_DESCRIPTION", "UNIT_PRICE", "QTY_DOC", "TOT_AMOUNT", "TOT_WEIGHT", "TOT_PACKAGES", "FIFO_PRICE", "INV_TOT_AMOUNT", "INV_TOT_WEIGHT", "INV_TOT_PACKAGES", "INV_QTY_DOC", "REF_ACREC", "RN", "DOC_DATE", "SEGMENT_CODE") AS 
  SELECT txt01 org_code,
    txt02 custom_code,
    txt03 uom,
    txt04 suppl_code,
    txt05 suppl_name,
    txt06 pack_mode,
    txt07 currency_code,
    txt08 receipt_type,
    txt09 doc_number,
    txt10 custom_description,
    txt11 invoice_code,
    txt12 pack_mode_desc,
    txt13 service_description,
    numb01 unit_price,
    numb02 qty_doc,
    numb03 tot_amount,
    numb04 tot_weight,
    numb05 tot_packages,
    numb06 fifo_price,
    numb08 inv_tot_amount,
    numb09 inv_tot_weight,
    numb10 inv_tot_packages,
    numb11 inv_qty_doc,
    numb12 ref_acrec,
    numb13 rn,
    data01 doc_date,
    segment_code
  FROM tmp_segment
  WHERE segment_code = 'VW_REP_ACREC_INVOICE_02_D';
/
--------------------------------------------------------
--  DDL for View VW_REP_ACREC_INVOICE_02_H
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_ACREC_INVOICE_02_H" ("CLIENT_CODE", "CLIENT_NAME", "CLIENT_ADDRESS", "CLIENT_BANK", "CLIENT_BANK_ACC", "CLIENT_CITY", "CLIENT_COUNTRY", "CLIENT_PHONE", "CLIENT_FAX", "CLIENT_FISCAL_CODE", "CLIENT_NOTE", "CLIENT_REGIST_CODE", "DESTIN_NAME", "DESTIN_ADDRESS", "DESTIN_CITY", "DESTIN_COUNTRY", "DESTIN_PHONE", "DESTIN_FAX", "DESTIN_FISCAL_CODE", "DESTIN_NOTE", "DESTIN_REGIST_CODE", "MY_CODE", "MY_NAME", "MY_ADDRESS", "MY_BANK", "MY_BANK_ACC", "MY_CITY", "MY_COUNTRY", "MY_PHONE", "MY_FAX", "MY_FISCAL_CODE", "MY_NOTE", "MY_REGIST_CODE", "ACREC_TYPE", "PROTOCOL_CODE", "INCOTERM", "INCOTERM_DESCRIPTION", "VAT_CODE", "TRUCK_NUMBER", "CURRENCY_CODE", "NOTE", "REF_ACREC", "EXCHANGE_RATE", "PROTOCOL_DATE", "DUE_DATE", "SEGMENT_CODE") AS 
  SELECT txt01 client_code,
    txt02 client_name,
    txt03 client_address,
    txt04 client_bank,
    txt05 client_bank_acc,
    txt06 client_city,
    txt07 client_country,
    txt08 client_phone,
    txt09 client_fax,
    txt10 client_fiscal_code,
    txt11 client_note,
    txt12 client_regist_code,
    txt13 destin_name,
    txt14 destin_address,
    txt15 destin_city,
    txt16 destin_country,
    txt17 destin_phone,
    txt18 destin_fax,
    txt19 destin_fiscal_code,
    txt20 destin_note,
    txt21 destin_regist_code,
    txt22 my_code,
    txt23 my_name,
    txt24 my_address,
    txt25 my_bank,
    txt26 my_bank_acc,
    txt27 my_city,
    txt29 my_country,
    txt30 my_phone,
    txt31 my_fax,
    txt32 my_fiscal_code,
    txt33 my_note,
    txt34 my_regist_code,
    txt35 acrec_type,
    txt36 protocol_code,
    txt37 incoterm,
    txt38 incoterm_description,
    txt39 vat_code,
    txt40 truck_number,
    txt41 currency_code,
    txt42 note,
    numb01 ref_acrec,
    numb02 exchange_rate,
    data01 protocol_date,
    data02 due_date,
    segment_code
  FROM tmp_segment
  WHERE segment_code = 'VW_REP_ACREC_INVOICE_02_H';
/
--------------------------------------------------------
--  DDL for View VW_REP_ACREC_INVOICE_02_S
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_ACREC_INVOICE_02_S" ("REF_ACREC", "SUPPL_CODE", "SUPPL_NAME", "CUSTOM_CODE", "CUSTOM_DESCRIPTION", "PUOM", "UOM_DESCRIPTION", "FIFO_QTY", "FIFO_PRICE", "CURRENCY_CODE") AS 
  select f.ref_acrec, f.suppl_code, max(f.suppl_name) suppl_name, 
    f.custom_code, nvl(max(cu.description), 'Alte coduri vamale') custom_description, 
    nvl(cu.SUPL_UM, f.puom) puom, max(uom.description) uom_description,
    sum(f.fifo_qty) fifo_qty, 
    trunc(sum(f.fifo_price), 2) fifo_price, 
    max(f.currency_code) currency_code
from VW_REP_SHIP_FIFO f
left join custom cu on cu.custom_code = f.custom_code
inner join primary_uom uom on uom.puom = f.puom
where suppl_code <> org_code
group by f.ref_acrec, f.suppl_code, f.custom_code, nvl(cu.SUPL_UM, f.puom);
/
--------------------------------------------------------
--  DDL for View VW_REP_AC_BALANCE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_AC_BALANCE" ("REP_TITLE", "REP_INFO", "ORG_CODE", "ORG_NAME", "ITEM_CODE", "DESCRIPTION", "UOM_CODE", "CURRENCY_CODE", "ITEM_ATTRIB", "STOCK_QTY_INI", "STOCK_VAL_INI", "STOCK_QTY_FIN", "STOCK_VAL_FIN", "MOV_QTY_IN", "MOV_VAL_IN", "MOV_QTY_OUT", "MOV_VAL_OUT", "CMP", "SEGMENT_CODE") AS 
  SELECT txt01 rep_title, 
    txt02 rep_info, 
    txt03   org_code, 
    txt04   org_name, 
    txt05   item_code, 
    txt06   description, 
    txt07   uom_code, 
    txt08   currency_code, 
    txt09   item_attrib, 
    numb01  stock_qty_ini, 
    numb02  stock_val_ini, 
    numb03  stock_qty_fin, 
    numb04  stock_val_fin, 
    numb05  mov_qty_in, 
    numb06  mov_val_in, 
    numb07  mov_qty_out, 
    numb08  mov_val_out, 
    numb09  cmp, 
    segment_code 
FROM TMP_SEGMENT 
WHERE SEGMENT_code = 'VW_REP_AC_BALANCE' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_AC_WIP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_AC_WIP" ("REPORT_TITLE", "REPORT_INFO", "OPER_CODE", "WHS_CODE", "ORG_CODE", "LINE_SEQ", "STOCK_INI", "QTY_IN", "QTY_OUT", "STOCK_FIN", "SEGMENT_CODE") AS 
  SELECT  txt01           report_title, 
        txt02           report_info, 
        txt03           oper_code, 
        txt04           whs_code, 
        txt05           org_code, 
        numb01          line_seq, 
        numb02          stock_ini, 
        numb03          qty_in, 
        numb04          qty_out, 
        numb05          stock_fin, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_REP_AC_WIP' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_AC_WIP_IO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_AC_WIP_IO" ("DATE_LEGAL", "OPER_CODE", "ORG_CODE", "ORDER_CODE", "ITEM_CODE", "ITEM_DESCR", "WHS_CODE", "REP_TITLE", "REP_INFO", "REASON_DESCR", "LINE_SEQ", "QTY_IN", "QTY_OUT", "OPER_SEQ", "SEGMENT_CODE") AS 
  SELECT 
data01      date_legal, 
txt01       oper_code, 
txt02       org_code, 
txt03       order_code, 
txt04       item_code, 
txt05       item_descr, 
txt06       whs_code, 
txt07       rep_title, 
txt08       rep_info, 
txt09       reason_descr, 
numb01      line_seq, 
numb02      qty_in, 
numb03      qty_out, 
numb04      oper_seq, 
segment_code 
FROM TMP_SEGMENT 
WHERE   segment_code    = 'VW_REP_AC_WIP_IO' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_BC
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_BC" ("ORG_CODE", "ORG_NAME", "DOC_CODE", "DOC_DAY", "DOC_MONTH", "DOC_YEAR", "GROUP_CODE_F", "GROUP_INFO", "DOC_DATE", "EMPL_ISSUER", "EMPL_RECEIVER", "EMPL_RESPONSABLE", "EMPL_DEPT_CHIEF", "SEQ_NO", "ITEM_CODE", "ITEM_DESCRIPTION", "PUOM", "QTY_DEMAND", "QTY", "UNIT_PRICE", "LINE_VALUE", "GROUP_CODE", "ACCOUNT_CODE", "COSTCENTER_CODE", "CURRENCY_CODE", "ACCOUNT_ANALYTIC", "WHS_ISSUE", "WHS_RECEIVE", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code, 
txt02   org_name, 
txt03   doc_code, 
txt04   doc_day, 
txt05   doc_month, 
txt06   doc_year, 
txt07   group_code_f, 
txt08   group_info, 
txt09   doc_date, 
txt10   empl_issuer, 
txt11   empl_receiver, 
txt12   empl_responsable, 
txt13   empl_dept_chief, 
numb01  seq_no, 
txt14   item_code, 
txt15   item_description, 
txt16   puom, 
numb02  qty_demand, 
numb03  qty, 
numb04  unit_price, 
numb05  line_value, 
txt17   group_code, 
txt18   account_code, 
txt19   costcenter_code, 
txt20   currency_code, 
txt21   account_analytic, 
txt22   whs_issue, 
txt23   whs_receive, 
segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code = 'VW_REP_BC' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_BOM_STD
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_BOM_STD" ("ORG_CODE", "FATHER_CODE", "FATHER_DESC", "CHILD_CODE", "CHILD_DESC", "COLOUR_CODE", "START_SIZE", "END_SIZE", "CHILD_UOM", "OPER_CODE", "OPER_SEQ", "REP_TITLE", "REP_INFO", "PICTURE_PATH", "UNIT_QTY", "UNIT_PRICE", "CHILD_PRICE", "TOT_PRICE", "SEGMENT_CODE") AS 
  select 
txt01 org_code, 
txt02 father_code, 
txt03 father_desc, 
txt04 child_code, 
txt05 child_desc, 
txt06 colour_code, 
txt07 start_size, 
txt08 end_size, 
txt09 child_uom, 
txt10 oper_code, 
txt11 oper_seq, 
txt12 rep_title, 
txt13 rep_info, 
txt14 picture_path, 
numb01 unit_qty, 
numb02 unit_price, 
numb03 child_price, 
numb04 tot_price, 
segment_code 
from tmp_segment
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_DAILY_PROD
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_DAILY_PROD" ("SEASON_CODE", "ORG_CODE", "ORDER_CODE", "ITEM_CODE", "ITEM_DESCR", "ROUTING_INFO", "UM", "FINAL_CLIENT", "OPER_CODE_1", "OPER_CODE_2", "OPER_CODE_3", "OPER_CODE_4", "WORKCENTER_1", "WORKCENTER_2", "WORKCENTER_3", "WORKCENTER_4", "REP_TITLE", "REP_INFO", "FAMILY_CODE", "ORDER_STATUS", "OPER_HIST_1", "OPER_HIST_2", "OPER_HIST_3", "OPER_HIST_4", "EXP_HIST", "NOM_QTY", "QTY_1", "QTY_2", "QTY_3", "QTY_4", "QTY_HIST_1", "QTY_HIST_2", "QTY_HIST_3", "QTY_HIST_4", "EXP_QTY", "LAUNCH_DATE", "SEGMENT_CODE") AS 
  SELECT  txt01   season_code, 
        txt02   org_code, 
        txt03   order_code, 
        txt04   item_code, 
        txt05   item_descr, 
        txt06   routing_info, 
        txt07   um, 
        txt08   final_client, 
        txt09   oper_code_1, 
        txt10   oper_code_2, 
        txt11   oper_code_3, 
        txt12   oper_code_4, 
        txt13   workcenter_1, 
        txt14   workcenter_2, 
        txt15   workcenter_3, 
        txt16   workcenter_4, 
        txt17   rep_title, 
        txt18   rep_info, 
        txt19   family_code, 
        txt20   order_status, 
        txt36   oper_hist_1, 
        txt37   oper_hist_2, 
        txt38   oper_hist_3, 
        txt39   oper_hist_4, 
        txt40   exp_hist, 
        numb01  nom_qty, 
        numb02  qty_1, 
        numb03  qty_2, 
        numb04  qty_3, 
        numb05  qty_4, 
        numb06  qty_hist_1, 
        numb07  qty_hist_2, 
        numb08  qty_hist_3, 
        numb09  qty_hist_4, 
        numb10  exp_qty, 
        data01  launch_date, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_REP_DAILY_PROD' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_DELIV
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_DELIV" ("ORG_CODE", "ORG_NAME", "DOC_NUMBER", "CLIENT_NAME", "DELEG_TEXT", "ITEM_CODE", "ITEM_DESCR", "PUOM_CODE", "CURR_CODE", "ACCOUNT_CODE", "LINE_SEQ", "QTY_DISPOSE", "QTY_DELIVER", "UNIT_PRICE", "EXCHANGE_RATE", "DOC_DATE", "SEGMENT_CODE") AS 
  SELECT 
txt01 org_code, 
txt02 org_name, 
txt03 doc_number, 
txt04 client_name, 
txt05 deleg_text, 
txt06 item_code, 
txt07 item_descr, 
txt08 puom_code, 
txt09 curr_code, 
txt10 account_code, 
numb01 line_seq, 
numb02 qty_dispose, 
numb03 qty_deliver, 
numb04 unit_price, 
numb05 exchange_rate, 
data01 doc_date, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code= 'VW_REP_DELIV' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_FA_SHEET
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_FA_SHEET" ("REP_TITLE", "REP_INFO", "INVENTORY_CODE", "TXT_ACQ_INFO", "INVENTORY_VALUE", "MONTHLY_DEPREC", "DEPREC_MONTHS", "DEPREC_PERCENT", "TXT_DESCRIPTION", "TXT_AUXILIAR", "TXT_GROUP", "TXT_CATEGORY", "USAGE_DATE", "DEPREC_DATE", "D_INV_NUMBER", "D_TXT_DOC", "D_TXT_TRANZ", "CURRENCY_CODE", "DEPREC_TYPE", "D_QTY", "D_DEBIT", "D_CREDIT", "D_SOLD", "SEGMENT_CODE") AS 
  SELECT 
txt01   rep_title, 
txt02   rep_info, 
txt03   inventory_code, 
txt04   txt_acq_info, 
numb01  inventory_value, 
numb02  monthly_deprec, 
numb03  deprec_months, 
numb04  deprec_percent, 
txt05   txt_description, 
txt06   txt_auxiliar, 
txt07   txt_group, 
txt08   txt_category, 
txt09   usage_date, 
txt10   deprec_date, 
-- 
txt11   d_inv_number, 
txt12   d_txt_doc, 
txt13   d_txt_tranz, 
txt14   currency_code, 
txt15   deprec_type, 
numb05  d_qty, 
numb06  d_debit, 
numb07  d_credit, 
numb08  d_sold, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_FA_SHEET' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_FIFO_EXCEDING
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_FIFO_EXCEDING" ("ORG_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "SIZE_CODE", "COLOUR_CODE", "SEASON_CODE", "PUOM", "I_DESCRIPTION", "C_DESCRIPTION", "SHIP_SUBCAT", "SEQ_NO", "QTY", "SEGMENT_CODE") AS 
  SELECT txt01 org_code,
    txt02 item_code,
    txt03 oper_code_item,
    txt04 size_code,
    txt05 colour_code,
    txt06 season_code,
    txt07 puom,
    txt08 i_description,
    txt09 c_description,
    txt10 ship_subcat,
    numb01 seq_no,
    numb02 qty,
    segment_code
  FROM TMP_SEGMENT
  WHERE segment_code = 'VW_REP_FIFO_EXCEDING';
/
--------------------------------------------------------
--  DDL for View VW_REP_FIFO_EXCEDING_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_FIFO_EXCEDING_U" ("Gest", "Articol", "Faza", "Mar", "Culoare", "Stagiune", "Um", "Descr_art", "Descr_cul", "Cant", "SHIP_SUBCAT") AS 
  SELECT org_code "Gest",
    item_code "Articol",
    oper_code_item "Faza",
    size_code "Mar",
    colour_code "Culoare",
    season_code "Stagiune",
    puom "Um",
    i_description "Descr_art",
    c_description "Descr_cul",
    qty "Cant",
    ship_subcat
  FROM VW_REP_FIFO_EXCEDING
  ORDER BY seq_no;
/
--------------------------------------------------------
--  DDL for View VW_REP_FIFO_REG
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_FIFO_REG" ("INOUT", "PARTNER_NAME", "PARTNER_ADDR", "ITEM_CODE", "ITEM_DESCR", "UOM", "DOC_CODE", "SEQ_NO", "QTY", "VAL", "DATA_DOC", "DATA_INOUT", "SEGMENT_CODE") AS 
  select 
txt01 inout, 
txt02 partner_name, 
txt03 partner_addr, 
txt04 item_code, 
txt05 item_descr, 
txt06 uom, 
txt07 doc_code, 
numb01 seq_no, 
numb02 qty, 
numb03 val, 
data01 data_doc, 
data02 data_inout, 
segment_code 
from TMP_SEGMENT 
where segment_code = 'VW_REP_FIFO_REG' 
with check option
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_GRP_DEMAND
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_GRP_DEMAND" ("ORG_CODE", "ITEM_CODE", "DESCRIPTION", "UM", "SIZE_CODE", "COLOUR_CODE", "OPER_CODE_ITEM", "OPER_CODE", "GROUP_CODE", "QTY_TOT", "QTY_DEMAND", "QTY_DEMAND_OTH", "QTY_STOCK", "OPER_SEQ", "SEGMENT_CODE") AS 
  SELECT
txt01   org_code,
txt03   item_code,
txt04   description,
txt05   um,
txt06   size_code,
txt07   colour_code,
txt08   oper_code_item,
txt09   oper_code,
txt36   group_code,
numb01  qty_tot,
numb02  qty_demand,
numb03  qty_demand_oth,
numb04  qty_stock,
numb05  oper_seq,
segment_code
FROM    TMP_SEGMENT
WHERE   segment_code = 'VW_REP_GRP_DEMAND'
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_GRP_DEMAND_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_GRP_DEMAND_U" ("Gestiune", "Lista comenzi", "SeqOp", "Oper Consum", "Material", "Faza", "Descriere", "Marime", "Culoare", "UM", "Necesar Initial", "Necesar activ", "Necesar alte comenzi", "Stoc") AS 
  SELECT  org_code    "Gestiune",
        group_code  "Lista comenzi",
        oper_seq    "SeqOp",
        oper_code   "Oper Consum",
        item_code   "Material",
        oper_code_item "Faza",
        description "Descriere",
        size_code   "Marime",
        colour_code "Culoare",
        um          "UM",
        Qty_tot     "Necesar Initial",
        qty_demand  "Necesar activ",
        qty_demand_oth "Necesar alte comenzi",
        qty_stock   "Stoc"
FROM VW_REP_GRP_DEMAND
ORDER BY oper_seq, item_code
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_GRP_SHEET
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_GRP_SHEET" ("ORG_CODE", "GROUP_CODE", "OPER_CODE", "CHILD_CODE", "CHILD_OPER", "CHILD_DESCR", "UM", "SIZE_CODE", "COLOUR_CODE", "START_SIZE", "END_SIZE", "WHS_STOCK", "NOTE_ROUT", "NOTE_BOM", "DATE_CREATE", "GROUP_CODE_BARC", "DATE_LAUNCH", "PICTURE_PATH", "REP_TITLE", "QTY_UNIT", "QTY_TOT", "QTY_PICKED", "SEQ_NO", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code, 
txt02   group_code, 
txt03   oper_code, 
txt04   child_code, 
txt05   child_oper, 
txt06   child_descr, 
txt07   um, 
txt08   size_code, 
txt09   colour_code, 
txt10   start_size, 
txt11   end_size, 
txt12   whs_stock, 
txt13   note_rout, 
txt14   note_bom, 
txt15   date_create, 
txt16   group_code_barc, 
txt17   date_launch, 
txt18   picture_path, 
txt19   rep_title, 
numb01  qty_unit, 
numb02  qty_tot, 
numb03  qty_picked, 
numb04  seq_no, 
segment_code 
FROM TMP_SEGMENT 
WHERE   segment_code = 'VW_REP_GRP_SHEET' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_GRP_SHEET_SIZE_DISTR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_GRP_SHEET_SIZE_DISTR" ("LINE_ORDER", "ORDER_CODE", "CLIENT_CODE", "ITEM_CODE", "TOTAL", "TOTAL_BOLA", "DESCRIPTION", "CLIENT_LOT", "ROUTING_TEXT", "TEHVAR_TEXT", "ORDER_NOTE", "S00", "S01", "S02", "S03", "S04", "S05", "S06", "S07", "S08", "S09", "S10", "S11", "S12", "S13", "S14", "S15", "S16", "S17", "S18", "S19", "S20", "S21", "S22", "S23", "S24", "S25", "S26", "S27", "S28", "S29", "S30", "PICTURE_PATH", "SEGMENT_CODE") AS 
  SELECT 
numb01      line_order, 
txt01       order_code, 
txt02       client_code, 
txt04       item_code, 
numb02      total, 
txt05       total_bola, 
txt07       description, 
txt08       client_lot, 
txt48       routing_text, 
txt49       tehvar_text, 
txt50       order_note, 
txt10    s00, 
txt11    s01, 
txt12    s02, 
txt13    s03, 
txt14    s04, 
txt15    s05, 
txt16    s06, 
txt17    s07, 
txt18    s08, 
txt19    s09, 
txt20    s10, 
txt21    s11, 
txt22    s12, 
txt23    s13, 
txt24    s14, 
txt25    s15, 
txt26    s16, 
txt27    s17, 
txt28    s18, 
txt29    s19, 
txt30    s20, 
txt31    s21, 
txt32    s22, 
txt33    s23, 
txt34    s24, 
txt35    s25, 
txt36    s26, 
txt37    s27, 
txt38    s28, 
txt39    s29, 
txt40    s30, 
txt41   picture_path, 
segment_code 
FROM TMP_SEGMENT 
WHERE   segment_code    =   'VW_REP_GRP_SHEET_SIZE_DISTR' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_INTRASTAT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_INTRASTAT" ("YEAR_MONTH", "CUSTOM_CODE", "DESCRIPTION_CUSTOM", "COUNTRY_FROM", "ORIGIN_CODE", "SUPL_UM", "RECEIPT_TYPE", "RECEIPT_TYPE_DESCR", "ORG_CODE", "SEQ_NO", "QTY_DOC", "VALUE_DOC", "VALUE_EUR", "WEIGHT_NET", "WEIGHT_BRUT", "SEGMENT_CODE") AS 
  SELECT      txt01       year_month,
            txt02       custom_code,
            txt03       description_custom,
            txt04       country_from,
            txt05       origin_code,
            txt06       supl_um,
            txt07       receipt_type,
            txt08       receipt_type_descr,
            txt09       org_code,
            numb01      seq_no,
            numb02      qty_doc,
            numb03      value_doc,
            numb04      value_eur,
            numb05      weight_net,
            numb06      weight_brut,
            segment_code
    FROM   TMP_SEGMENT
    WHERE  segment_code    =   'VW_REP_INTRASTAT'
    WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_INTRASTAT_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_INTRASTAT_U" ("An_luna", "Gestiune", "Nr_seq", "Tip Rec", "Descr Rec", "Cod_vam", "Descriere", "Tara_exp", "Tara_orig", "Greu_net", "Greu_brut", "Um_supl", "Cant_doc", "Val_RON", "Val_EUR") AS 
  SELECT
            year_month      "An_luna",
            org_code        "Gestiune",
            seq_no          "Nr_seq",
            receipt_type    "Tip Rec",
            receipt_type_descr    "Descr Rec",
            custom_code     "Cod_vam",
            description_custom  "Descriere",
            country_from    "Tara_exp",
            origin_code     "Tara_orig",
            weight_net      "Greu_net",
            weight_brut     "Greu_brut",
            supl_um         "Um_supl",
            qty_doc         "Cant_doc",
            value_doc       "Val_RON",
            value_eur       "Val_EUR"
    FROM    VW_REP_INTRASTAT
    ORDER BY seq_no ASC
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_INV_LIST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_INV_LIST" ("ORG_MYSELF", "ORG_DESCR", "WHS_CODE", "INV_DATE", "ITEM_CODE", "STOCK_ATTR", "ITEM_DESCR", "PUOM", "REP_TITLE", "OPER_CODE_ITEM", "QTY_INV", "QTY_STOCK", "QTY_PLUS", "QTY_MINUS", "UNIT_PRICE", "VALUE_INV", "VALUE_PLUS", "VALUE_MINUS", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_myself, 
txt02   org_descr, 
txt03   whs_code, 
data01  inv_date, 
txt04   item_code, 
txt05   stock_attr, 
txt06   item_descr, 
txt07   puom, 
txt08   rep_title, 
txt09   oper_code_item, 
numb01  qty_inv, 
numb02  qty_stock, 
numb03  qty_plus, 
numb04  qty_minus, 
numb05  unit_price, 
numb06  value_inv, 
numb07  value_plus, 
numb08  value_minus, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_INV_LIST' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_ITEM_TRANSACTION
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_ITEM_TRANSACTION" ("TRN_YEAR", "TRN_CODE", "TRN_TYPE", "FLAG_STORNO", "PARTNER_CODE", "DOC_CODE", "ORG_CODE", "SEASON_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "DESCRIPTION", "WHS_CODE", "COLOUR_CODE", "SIZE_CODE", "GROUP_CODE", "ORDER_CODE", "REASON_CODE", "REASON_DESCRIPTION", "COLOUR_DESCRIPTION", "PUOM", "TRN_DATE", "DOC_DATE", "DATE_LEGAL", "SEQ_NO", "QTY", "QTY_PROG", "BUSINESS_FLOW", "SEGMENT_CODE") AS 
  SELECT 
            txt01   trn_year, 
            txt02   trn_code, 
            txt03   trn_type, 
            txt04   flag_storno, 
            txt05   partner_code, 
            txt06   doc_code, 
            txt07   org_code, 
            txt08   season_code, 
            txt09   item_code, 
            txt10   oper_code_item, 
            txt11   description, 
            txt12   whs_code, 
            txt13   colour_code, 
            txt14   size_code, 
            txt15   group_code, 
            txt16   order_code, 
            txt17   reason_code, 
            txt18   reason_description, 
            txt19   colour_description, 
            txt20   puom, 
            data01  trn_date, 
            data02  doc_date, 
            data03  date_legal, 
            numb01  seq_no, 
            numb02  qty, 
            numb03  qty_prog, 
            numb04  business_flow, 
            segment_code 
FROM        TMP_SEGMENT 
WHERE       segment_code    =   'VW_REP_ITEM_TRANSACTION' 
 WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_ITEM_TRANSACTION_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_ITEM_TRANSACTION_U" ("Cant", "Sto", "Tip_misc", "Mag", "Dt_conta", "Stag", "Causale", "Desc_caus", "Bola", "Comanda", "Articol", "Faza", "Cod_cul", "Desc_cul", "Marime", "Um", "Descr", "Bola_mag", "Data_bola") AS 
  SELECT 
    QTY                 "Cant", 
    FLAG_STORNO         "Sto", 
    TRN_TYPE            "Tip_misc", 
    WHS_CODE            "Mag", 
    DATE_LEGAL          "Dt_conta", 
    SEASON_CODE         "Stag", 
    REASON_CODE         "Causale", 
    REASON_DESCRIPTION  "Desc_caus", 
    ORDER_CODE          "Bola", 
    GROUP_CODE          "Comanda", 
    ITEM_CODE           "Articol", 
    OPER_CODE_ITEM      "Faza", 
    COLOUR_CODE         "Cod_cul", 
    COLOUR_DESCRIPTION  "Desc_cul", 
    SIZE_CODE           "Marime", 
    PUOM                "Um", 
    DESCRIPTION         "Descr" , 
    TRN_CODE            "Bola_mag", 
    TRN_DATE            "Data_bola" 
    FROM    VW_REP_ITEM_TRANSACTION 
    ORDER BY seq_no
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_MATERIAL_DEMAND
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_MATERIAL_DEMAND" ("ORG_CODE", "ITEM_CODE", "DESCRIPTION", "PUOM", "OPER_CODE", "SEASON_CODE", "COLOUR_CODE", "SIZE_CODE", "MAT_TYPE", "QTY_LAUNCHED", "QTY_INI", "QTY_ALOC", "QTY_NOTALOC", "QTY_TRANSIT", "FLAG_SIZE", "FLAG_COLOUR", "FLAG_RANGE", "SEGMENT_CODE") AS 
  SELECT      txt01   org_code,
            txt02   item_code,
            txt03   description,
            txt04   puom,
            txt05   oper_code,
            txt06   season_code,
            txt07   colour_code,
            txt08   size_code,
            txt09   mat_type,
            numb01  qty_launched,
            numb02  qty_ini,
            numb03  qty_aloc,
            numb04  qty_notaloc,
            numb05  qty_transit,
            numb06  flag_size,
            numb07  flag_colour,
            numb08  flag_range,
            segment_code
FROM        TMP_SEGMENT
WHERE       segment_code    =   'VW_REP_MATERIAL_DEMAND'
WITH CHECK OPTION

 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_MATERIAL_DEMAND_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_MATERIAL_DEMAND_U" ("Organizatia", "Cod Material", "Descriere Material", "UM", "Operatie Consum", "Stagiune", "Culoare", "Marime", "Tip Material", "Necesar Lansat", "Necesar Nelansat", "Cant alocata", "Cant libera", "Cant NeRecept", "Gest_MAR", "Gest_CUL", "Gest_PLJ") AS 
  SELECT      org_code    "Organizatia", 
            item_code   "Cod Material", 
            description "Descriere Material", 
            puom        "UM", 
            oper_code   "Operatie Consum", 
            season_code "Stagiune", 
            colour_code "Culoare", 
            size_code   "Marime", 
            mat_type    "Tip Material", 
            qty_launched "Necesar Lansat", 
            qty_ini     "Necesar Nelansat", 
            qty_aloc    "Cant alocata", 
            qty_notaloc "Cant libera", 
            qty_transit "Cant NeRecept", 
            flag_size   "Gest_MAR", 
            flag_colour "Gest_CUL", 
            flag_range  "Gest_PLJ" 
FROM        VW_REP_MATERIAL_DEMAND
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_NIR
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_NIR" ("ORG_CODE", "ORG_NAME", "DOC_CODE", "DOC_DAY", "DOC_MONTH", "DOC_YEAR", "SUPPLIER_DOC", "DECLARATION", "SEQ_NO", "ITEM_DESCRIPTION", "UOM", "QTY", "QTY_RECEIPT", "UNIT_PRICE", "LINE_VALUE", "CURRENCY_CODE", "ACCOUNT_CODE", "ACCOUNT_ANALYTIC", "EXCHANGE_RATE", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code, 
txt02   org_name, 
txt03   doc_code, 
txt04   doc_day, 
txt05   doc_month, 
txt06   doc_year, 
txt07   supplier_doc, 
txt36   declaration, 
numb01  seq_no, 
txt09   item_description, 
txt10   uom, 
numb02  qty, 
numb03  qty_receipt, 
numb04  unit_price, 
numb05  line_value, 
txt11   currency_code, 
txt12   account_code, 
txt13   account_analytic, 
numb06  exchange_rate, 
segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code = 'VW_REP_NIR' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_ORDER_SITUATION
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_ORDER_SITUATION" ("ORG_CODE", "ORDER_CODE", "ITEM_CODE", "DESCRIPTION", "OPER_1", "OPER_2", "OPER_3", "OPER_4", "FAMILY_CODE", "QTY_NOM", "QTY_NOTVALIDATED", "QTY_NOTLAUNCHED", "QTY_1", "QTY_2", "QTY_3", "QTY_4", "QTY_FIN", "QTY_EXP", "QTY_CANCEL", "QTY_CANCELPARTIAL", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code, 
txt02   order_code, 
txt03   item_code, 
txt04   description, 
txt05   oper_1, 
txt06   oper_2, 
txt07   oper_3, 
txt08   oper_4, 
txt09   family_code, 
numb01  qty_nom, 
numb02  qty_notvalidated, 
numb03  qty_notlaunched, 
numb04  qty_1, 
numb05  qty_2, 
numb06  qty_3, 
numb07  qty_4, 
numb08  qty_fin, 
numb09  qty_exp, 
numb10  qty_cancel, 
numb11  qty_cancelpartial, 
segment_code 
FROM TMP_SEGMENT 
WHERE SEGMENT_code = 'VW_REP_ORDER_SITUATION' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_ORD_LABEL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_ORD_LABEL" ("ORDER_CODE", "ITEM_CODE", "DESCRIPTION", "SIZE_CODE", "ORG_CODE", "SEGMENT_CODE") AS 
  SELECT
       txt01    order_code,
       txt02    item_code,
       txt03    description,
       txt04    size_code,
       txt05    org_code,
       segment_code
FROM TMP_SEGMENT
WHERE segment_code       =  'VW_REP_ORD_LABEL'
WITH CHECK OPTION

 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_PKG_KEY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_PKG_KEY" ("REP_TITLE", "REP_INFO", "KEY_CODE", "SEGMENT_CODE") AS 
  SELECT 
txt01   rep_title, 
txt02   rep_info, 
txt03   key_code, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_PKG_KEY' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_PKG_ORDER_SIZE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_PKG_ORDER_SIZE" ("REP_TITLE", "REP_INFO", "SIZE_CODE_1", "BARCODE_1", "SIZE_CODE_2", "BARCODE_2", "QUALITY", "SEGMENT_CODE") AS 
  SELECT  txt01   rep_title, 
        txt02   rep_info, 
        txt03   size_code_1, 
        txt04   barcode_1, 
        txt05   size_code_2, 
        txt06   barcode_2, 
        txt07   quality, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_REP_PKG_ORDER_SIZE' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_PKG_SHEET
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_PKG_SHEET" ("REP_TITLE", "REP_INFO", "ORG_CODE", "PACKAGE_CODE", "ORDER_CODE", "ITEM_CODE", "DESCRIPTION", "WO_SIZE", "WO_QTY_1", "WO_QTY_2", "PACKAGE_CODE_BC", "PICTURE_PATH", "SEGMENT_CODE") AS 
  SELECT  txt01   rep_title, 
        txt02   rep_info, 
        txt03   org_code, 
        txt04   package_code, 
        txt05   order_code, 
        txt06   item_code, 
        txt07   description, 
        txt09   wo_size, 
        txt10   wo_qty_1, 
        txt11   wo_qty_2, 
        txt12   package_code_bc, 
        txt13   picture_path, 
        segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_PKG_SHEET' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_PKG_SIT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_PKG_SIT" ("STATUS", "DATE_LAUNCH", "ORG_CODE", "ORDER_CODE", "ITEM_CODE", "DESCRIPTION", "SIZE_CODE", "WARNING", "QTA", "QTY_PKG", "QTY_PKG_M", "FIN_QTY", "EXP_QTY", "SEGMENT_CODE") AS 
  SELECT 
txt01 status, 
data01            date_launch, 
txt02            org_code, 
txt03            order_code, 
txt04			item_code         , 
txt05            description      , 
txt06            size_code        , 
txt07           warning, 
numb01            qta             , 
numb02            qty_pkg         , 
numb03            qty_pkg_m       , 
numb04            fin_qty             , 
numb05            exp_qty         , 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_PKG_SIT' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_PKG_SIT_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_PKG_SIT_U" ("STATUS", "Data Lans", "Gestiune", "Ordin", "Cod", "Descriere", "Marime", "Cant NOM", "Cant ambal", "Cant ambal trimisa", "Cant magazie", "Cant expediata", "Atentionari") AS 
  SELECT      status, 
            date_launch       "Data Lans", 
            org_code          "Gestiune", 
            order_code        "Ordin", 
			item_code         "Cod", 
            description       "Descriere", 
            size_code         "Marime", 
            qta               "Cant NOM", 
            qty_pkg           "Cant ambal", 
            qty_pkg_m         "Cant ambal trimisa", 
            fin_qty           "Cant magazie", 
            exp_qty           "Cant expediata", 
            warning           "Atentionari" 
FROM vw_rep_pkg_sit
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_PO_ORDER
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_PO_ORDER" ("REP_TITLE", "REP_INFO", "MYSELF_NAME", "MYSELF_INFO", "BUYER_NAME", "BUYER_INFO", "SUPPL_NAME", "SUPPL_INFO", "SHIPTO_INFO", "EMPL_REQUEST", "SHIP_VIA", "SHIP_INCOTERM", "PAYMENT_TERMS", "CURRENCY_CODE", "SHIPTO_NAME", "ITEM_CODE_SUPPL", "ITEM_DESCR_SUPPL", "ITEM_UOM_SUPPL", "SEQ_NO", "QTY", "UNIT_PRICE", "LINE_PRICE", "LINE_TAX", "EXCHANGE_RATE", "SEGMENT_CODE") AS 
  SELECT 
txt01 rep_title, 
txt02 rep_info, 
txt03 myself_name, 
txt04 myself_info, 
txt05 buyer_name, 
txt06 buyer_info, 
txt07 suppl_name, 
txt08 suppl_info, 
txt09 shipto_info, 
txt10 empl_request, 
txt11 ship_via, 
txt12 ship_incoterm, 
txt13 payment_terms, 
txt14 currency_code, 
txt15 shipto_name, 
-- 
txt16 item_code_suppl, 
txt17 item_descr_suppl, 
txt18 item_uom_suppl, 
-- 
numb01 seq_no, 
numb02 qty, 
numb03 unit_price, 
numb04 line_price, 
numb05 line_tax, 
numb06 exchange_rate, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_PO_ORDER' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_PROD_PERIOD
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_PROD_PERIOD" ("ORG_CODE", "ORDER_CODE", "ITEM_CODE", "ITEM_DESCRIPTION", "ROUTING_CODE", "OPER_CODE", "REP_TITLE", "REP_INFO", "START_DATE", "END_DATE", "QTY_NOM", "WEEK_START", "SEQ_NO", "QTY_1", "QTY_2", "QTY_3", "QTY_4", "QTY_5", "QTY_6", "QTY_7", "QTY_8", "QTY_9", "QTY_10", "QTY_11", "QTY_12", "QTY_13", "QTY_14", "QTY_15", "QTY_16", "QTY_17", "QTY_18", "QTY_19", "QTY_20", "QTY_21", "QTY_22", "QTY_23", "QTY_24", "QTY_25", "QTY_26", "QTY_27", "QTY_28", "QTY_29", "QTY_30", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code, 
txt02   order_code, 
txt03   item_code, 
txt04   item_description, 
txt05   routing_code, 
txt06   oper_code, 
txt07   rep_title, 
txt08   rep_info, 
data01  start_date, 
data02  end_date, 
numb01  qty_nom, 
numb02  week_start, 
numb03  seq_no, 
numb11  qty_1, 
numb12  qty_2, 
numb13  qty_3, 
numb14  qty_4, 
numb15  qty_5, 
numb16  qty_6, 
numb17  qty_7, 
numb18  qty_8, 
numb19  qty_9, 
numb20  qty_10, 
numb21  qty_11, 
numb22  qty_12, 
numb23  qty_13, 
numb24  qty_14, 
numb25  qty_15, 
numb26  qty_16, 
numb27  qty_17, 
numb28  qty_18, 
numb29  qty_19, 
numb30  qty_20, 
numb31  qty_21, 
numb32  qty_22, 
numb33  qty_23, 
numb34  qty_24, 
numb35  qty_25, 
numb36  qty_26, 
numb37  qty_27, 
numb38  qty_28, 
numb39  qty_29, 
numb40  qty_30, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_PROD_PERIOD' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_RECEIPT_DIFFERENCE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_RECEIPT_DIFFERENCE" ("ORG_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "COLOUR_CODE", "SIZE_CODE", "DESCRIPTION_ITEM", "DESCRIPTION_COLOUR", "PUOM", "SEQ_NO", "QTY", "QTY_DOC", "QTY_COUNT", "QTY_DOC_COUNT", "QTY_COUNT_COUNT", "SEGMENT_CODE") AS 
  SELECT 
            txt01   org_code, 
            txt02   item_code, 
            txt03   oper_code_item, 
            txt04   colour_code, 
            txt05   size_code, 
            txt06   description_item, 
            txt07   description_colour, 
            txt08   puom, 
            numb01  seq_no, 
            numb02  qty, 
            numb03  qty_doc, 
            numb04  qty_count, 
            numb05  qty_doc_count, 
            numb06  qty_count_count, 
            segment_code 
FROM        TMP_SEGMENT 
WHERE       segment_code    =   'VW_REP_RECEIPT_DIFFERENCE' 
 WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_RECEIPT_DIFFERENCE_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_RECEIPT_DIFFERENCE_U" ("Gest", "Articol", "Descr_art", "Culoare", "Descr_cul", "Mar", "Faza", "Um", "Cant_Dif", "Pls_doc", "Pls_fiz", "Poz_pls_doc", "Poz_pls_fiz") AS 
  SELECT 
            org_code            "Gest", 
            item_code           "Articol", 
            description_item    "Descr_art", 
            colour_code         "Culoare", 
            description_colour  "Descr_cul", 
            size_code           "Mar", 
            oper_code_item      "Faza", 
            puom                "Um", 
            qty                 "Cant_Dif", 
            qty_doc             "Pls_doc", 
            qty_count           "Pls_fiz", 
            qty_doc_count       "Poz_pls_doc", 
            qty_count_count     "Poz_pls_fiz" 
    FROM VW_REP_RECEIPT_DIFFERENCE 
    ORDER BY seq_no
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_RECEIPT_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_RECEIPT_U" ("Doc_furn", "Data_furn", "Cod_furn", "Data_rec", "AnLu_rec", "Cant_doc", "Cant_fizic", "Stoc_fifo", "Um", "Articol", "Descr_art", "Cod_cul", "Descr_cul", "Marime", "Cod_vam", "Descr_vam", "Pret_doc", "Rata_sch", "Valuta", "Numar_rec", "Data_inreg", "Tip_rec", "Descr_rec", "Faza", "Extern") AS 
  SELECT 
            DOC_NUMBER              "Doc_furn", 
            DOC_DATE                "Data_furn", 
            SUPPL_CODE              "Cod_furn", 
            DATE_LEGAL              "Data_rec", 
            YEAR_MONTH_RECEIPT      "AnLu_rec", 
            QTY_DOC                 "Cant_doc", 
            QTY_COUNT               "Cant_fizic", 
            QTY_FIFO                "Stoc_fifo", 
            PUOM                    "Um", 
            ITEM_CODE               "Articol", 
            DESCRIPTION_ITEM        "Descr_art", 
            COLOUR_CODE             "Cod_cul", 
            DESCRIPTION_COLOUR      "Descr_cul", 
            SIZE_CODE               "Marime", 
            CUSTOM_CODE             "Cod_vam", 
            DESCRIPTION_CUSTOM      "Descr_vam", 
            PRICE_DOC               "Pret_doc", 
            EXCHANGE_RATE           "Rata_sch", 
            CURRENCY_CODE           "Valuta", 
            RECEIPT_CODE            "Numar_rec", 
            RECEIPT_DATE            "Data_inreg" , 
            RECEIPT_TYPE            "Tip_rec", 
            DESCRIPTION_RECEIPT     "Descr_rec" , 
            OPER_CODE_ITEM          "Faza" , 
            EXTERN                  "Extern" 
    FROM    VW_PREP_RECEIPT 
    ORDER BY seq_no
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_RECEIPT_VALUES
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_RECEIPT_VALUES" ("REF_RECEIPT", "RECEIPT_TYPE", "DOC_DATE", "DOC_NUMBER", "RECEIPT_DATE", "SUPPL_CODE", "SUPPL_NAME", "CUSTOM_CODE", "ITEM_CODE", "ITEM_DESC", "UNIT_PRICE", "QTY_REC", "PUOM", "SEASON_CODE", "LINE_PRICE_CURR", "LINE_PRICE_RON", "EXCHANGE_RATE", "LINE_SEQ") AS 
  SELECT rh.idriga ref_receipt,
    rh.receipt_type,
    rh.doc_date,
    rh.doc_number,
    rh.receipt_date,
    rh.suppl_code,
    su.org_name suppl_name,
    NVL(it.custom_code, rd.custom_code) custom_code,
    rd.item_code,
    it.description item_desc,
    rd.price_doc unit_price,
    rd.qty_count qty_rec,
    rd.uom_receipt puom,
    rd.season_code,
    rd.price_doc * rd.qty_count line_price_curr,
    rd.price_doc_puom * rd.qty_count_puom * cr.exchange_rate line_price_ron,
    cr.exchange_rate,
    rd.line_seq
  FROM receipt_header rh
  INNER JOIN organization su
  ON su.org_code = rh.suppl_code
  INNER JOIN receipt_detail rd
  ON rd.ref_receipt = rh.idriga
  INNER JOIN item it
  ON it.org_code   = rd.org_code
  AND it.item_code = rd.item_code
  LEFT JOIN currency_rate cr
  ON cr.calendar_day   = rh.receipt_date
  AND cr.currency_from = rh.currency_code
  AND cr.currency_to   = 'RON';
/
--------------------------------------------------------
--  DDL for View VW_REP_RET
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_RET" ("ORG_CODE", "ORG_NAME", "DOC_CODE", "DOC_DAY", "DOC_MONTH", "DOC_YEAR", "GROUP_CODE_F", "GROUP_INFO", "DOC_DATE", "EMPL_ISSUER", "EMPL_RECEIVER", "EMPL_RESPONSABLE", "EMPL_DEPT_CHIEF", "SEQ_NO", "ITEM_CODE", "ITEM_DESCRIPTION", "PUOM", "QTY_DEMAND", "QTY", "UNIT_PRICE", "LINE_VALUE", "GROUP_CODE", "ACCOUNT_CODE", "COSTCENTER_CODE", "CURRENCY_CODE", "ACCOUNT_ANALYTIC", "WHS_ISSUE", "WHS_RECEIVE", "SEGMENT_CODE") AS 
  SELECT  "ORG_CODE","ORG_NAME","DOC_CODE","DOC_DAY","DOC_MONTH","DOC_YEAR","GROUP_CODE_F","GROUP_INFO","DOC_DATE","EMPL_ISSUER","EMPL_RECEIVER","EMPL_RESPONSABLE","EMPL_DEPT_CHIEF","SEQ_NO","ITEM_CODE","ITEM_DESCRIPTION","PUOM","QTY_DEMAND","QTY","UNIT_PRICE","LINE_VALUE","GROUP_CODE","ACCOUNT_CODE","COSTCENTER_CODE","CURRENCY_CODE", 
ACCOUNT_ANALYTIC, WHS_ISSUE, WHS_RECEIVE, 
"SEGMENT_CODE" 
FROM    vw_rep_bc
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_SHIPMENT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_SHIPMENT" ("MYSELF_IDENTIFICATION", "CLIENT_IDENTIFICATION", "DOCUMENT_IDENTIFICATION", "FOOTER_IDENTIFICATION", "DESCRIPTION", "UOM", "NOTE", "SEQ_NO", "QTY", "UNIT_PRICE", "LINE_VALUE", "TOTAL_VALUE", "SEGMENT_CODE") AS 
  SELECT    txt37   myself_identification, 
            txt38   client_identification, 
            txt39   document_identification, 
            txt40   footer_identification, 
            txt41   description, 
            txt06   uom, 
            txt50   note, 
            numb01  seq_no, 
            numb02  qty, 
            numb03  unit_price, 
            numb04  line_value, 
            numb05  total_value, 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_REP_SHIPMENT' 
    WITH CHECK OPTION;
/
--------------------------------------------------------
--  DDL for View VW_REP_SHIP_FIFO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_SHIP_FIFO" ("REF_ACREC", "REF_SHIPMENT", "ORG_CODE", "PROTOCOL_CODE", "PROTOCOL_DATE", "SHIP_CODE", "SHIP_SUBCAT", "ITEM_CODE", "ORIGIN_CODE", "SIZE_CODE", "ITEM_DESC", "PUOM", "CUSTOM_CATEGORY", "CUSTOM_CODE", "FIFO_QTY", "UNIT_PRICE", "FIFO_PRICE", "FIFO_PRICE_RON", "RECEIPT_TYPE", "RECEIPT_CODE", "RECEIPT_DATE", "DOC_NUMBER", "DOC_DATE", "CURRENCY_CODE", "SEASON_DESC", "SUPPL_CODE", "SUPPL_NAME", "CUSTOM_CATEGORY_DESC") AS 
  SELECT a."REF_ACREC",
    a."REF_SHIPMENT",
    a."ORG_CODE",
    a."PROTOCOL_CODE",
    a."PROTOCOL_DATE",
    a."SHIP_CODE",
    a."SHIP_SUBCAT",
    a."ITEM_CODE",
    a."ORIGIN_CODE",
    a."SIZE_CODE",
    a."ITEM_DESC",
    a."PUOM",
    a."CUSTOM_CATEGORY",
    a."CUSTOM_CODE",
    a."FIFO_QTY",
    a."UNIT_PRICE",
    a."FIFO_PRICE",
    a."FIFO_PRICE_RON",
    a."RECEIPT_TYPE",
    a."RECEIPT_CODE",
    a.receipt_date,
    a."DOC_NUMBER",
    a."DOC_DATE",
    a."CURRENCY_CODE",
    a."SEASON_DESC",
    a."SUPPL_CODE",
    a."SUPPL_NAME",
    cat.description custom_category_desc
  FROM
    (SELECT sh.ref_acrec,
      sh.idriga ref_shipment,
      sh.org_code,
      sh.protocol_code,
      sh.protocol_date,
      sh.ship_code,
      fm.ship_subcat,
      rd.item_code,
      rd.origin_code,
      rd.size_code,
      it.description item_desc,
      rd.uom_receipt puom,
      NVL(it.custom_category,
      CASE it.type_code
        WHEN 'MP'
        THEN '5100'
        WHEN 'AUX'
        THEN '5300'
      END) custom_category,
      NVL(it.custom_code, rd.custom_code) custom_code,
      fm.qty * rd.qty_count / rd.qty_count_puom fifo_qty,
      rd.price_doc unit_price,
      rd.price_doc_puom * fm.qty fifo_price,
      rd.price_doc_puom * fm.qty * cr.exchange_rate fifo_price_ron,
      rh.receipt_type,
      rh.receipt_code,
      rh.receipt_date,
      rh.doc_number,
      rh.doc_date,
      rh.currency_code,
      ws.description season_desc,
      rh.suppl_code,
      su.org_name suppl_name
    FROM shipment_header sh
    INNER JOIN fifo_material fm
    ON fm.ref_shipment = sh.idriga
    INNER JOIN receipt_detail rd
    ON rd.idriga = fm.ref_receipt
    INNER JOIN receipt_header rh
    ON rh.idriga = rd.ref_receipt
    INNER JOIN item it
    ON it.org_code   = rd.org_code
    AND it.item_code = rd.item_code
    LEFT JOIN work_season ws
    ON ws.org_code     = rd.org_code
    AND ws.season_code = rd.season_code
    LEFT JOIN currency_rate cr
    ON cr.calendar_day   = rh.receipt_date
    AND cr.currency_from = rh.currency_code
    AND cr.currency_to   = 'RON'
    LEFT JOIN organization su
    ON su.org_code = rh.suppl_code
    )a
  LEFT JOIN cat_custom cat
  ON cat.custom_code = a.custom_category;
/
--------------------------------------------------------
--  DDL for View VW_REP_SHIP_PACKLIST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_SHIP_PACKLIST" ("REF_SHIPMENT", "SHIP_CODE", "ORG_CODE", "ORG_CLIENT", "PROTOCOL_CODE", "PROTOCOL_DATE", "ORDER_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "ORIGIN_CODE", "PACKAGE_NUMBER", "PUOM", "QTY_DOC", "SEASON_CODE", "SIZE_CODE", "ITEM_DESC", "WO_DESC", "CLIENT_LOT", "CLIENT_CODE", "SEASON_DESC", "PACK_MODE_RO", "PACK_MODE_IT", "PACK_MODE_COUNT") AS 
  SELECT sh.idriga ref_shipment,
    sh.ship_code,
    sh.org_code,
    sh.org_client,
    sh.protocol_code,
    sh.protocol_date,
    sd.order_code,
    sd.item_code,
    sd.oper_code_item,
    sd.origin_code,
    sd.package_number,
    sd.puom,
    sd.qty_doc,
    sd.season_code,
    sd.size_code,
    it.description item_desc,
    NVL(wo.note, it.description) wo_desc,
    wo.client_lot,
    wo.client_code,
    ws.description season_desc,
    pm_ro.description pack_mode_ro,
    pm_it.description pack_mode_it,
    sd.pack_mode_count
  FROM shipment_header sh
  INNER JOIN shipment_detail sd
      ON sd.ref_shipment = sh.idriga
  INNER JOIN item it
      ON it.org_code   = sd.org_code
      AND it.item_code = sd.item_code
  LEFT JOIN work_order wo
      ON wo.org_code    = sd.org_code
      AND wo.order_code = sd.order_code
  LEFT JOIN work_season ws
      ON ws.org_code     = sd.org_code
      AND ws.season_code = sd.season_code
  LEFT JOIN MULTI_TABLE pm_ro
      ON pm_ro.table_name = 'SHIP_PACK_MODE'
      AND pm_ro.flag_active = 'Y'
      AND pm_ro.table_key = sd.pack_mode
  LEFT JOIN MULTI_TABLE pm_it
      ON pm_it.table_name = 'SHIP_PACK_MODE'
      AND pm_it.flag_active = 'Y'
      AND pm_it.table_key = sd.pack_mode||'_IT';
/
--------------------------------------------------------
--  DDL for View VW_REP_TRN
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_TRN" ("ORG_CODE", "ORG_NAME", "DOC_CODE", "DOC_DAY", "DOC_MONTH", "DOC_YEAR", "GROUP_CODE_F", "GROUP_INFO", "DOC_DATE", "EMPL_ISSUER", "EMPL_RECEIVER", "EMPL_RESPONSABLE", "EMPL_DEPT_CHIEF", "SEQ_NO", "ITEM_CODE", "ITEM_DESCRIPTION", "PUOM", "QTY_DEMAND", "QTY", "UNIT_PRICE", "LINE_VALUE", "GROUP_CODE", "ACCOUNT_CODE", "COSTCENTER_CODE", "CURRENCY_CODE", "ACCOUNT_ANALYTIC", "WHS_ISSUE", "WHS_RECEIVE", "SEGMENT_CODE") AS 
  SELECT  "ORG_CODE","ORG_NAME","DOC_CODE","DOC_DAY","DOC_MONTH","DOC_YEAR","GROUP_CODE_F","GROUP_INFO","DOC_DATE","EMPL_ISSUER","EMPL_RECEIVER","EMPL_RESPONSABLE","EMPL_DEPT_CHIEF","SEQ_NO","ITEM_CODE","ITEM_DESCRIPTION","PUOM","QTY_DEMAND","QTY","UNIT_PRICE","LINE_VALUE","GROUP_CODE","ACCOUNT_CODE","COSTCENTER_CODE","CURRENCY_CODE", 
ACCOUNT_ANALYTIC, WHS_ISSUE, WHS_RECEIVE, 
"SEGMENT_CODE" 
FROM    vw_rep_bc
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_WHS_STOC
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_WHS_STOC" ("ORG_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "COLOUR_CODE", "SIZE_CODE", "WHS_CODE", "SEASON_CODE", "ORDER_CODE", "GROUP_CODE", "PUOM", "I_DESCRIPTION", "C_DESCRIPTION", "MAT_TYPE", "NOTE", "SEQ_NO", "QTY", "REF_DATE", "SEGMENT_CODE") AS 
  SELECT 
            txt01       org_code, 
            txt02       item_code, 
            txt03       oper_code_item, 
            txt04       colour_code, 
            txt05       size_code, 
            txt06       whs_code, 
            txt07       season_code, 
            txt08       order_code, 
            txt09       group_code, 
            txt10       puom, 
            txt11       i_description, 
            txt12       c_description, 
            txt13       mat_type, 
            txt14       note, 
            numb01      seq_no, 
            numb02      qty, 
            data01      REF_DATE, 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_REP_WHS_STOC'
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_WHS_STOC_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_WHS_STOC_U" ("Cant", "Bola", "Gest", "Articol", "Desc_art", "Faza", "Mar", "Cul", "Desc_cul", "Magazie", "Stagiune", "Comanda", "Um", "Familie", "Data_ref", "Obs") AS 
  SELECT 
            QTY             "Cant", 
            ORDER_CODE      "Bola", 
            ORG_CODE        "Gest", 
            ITEM_CODE       "Articol", 
            I_DESCRIPTION   "Desc_art", 
            OPER_CODE_ITEM  "Faza"  , 
            SIZE_CODE       "Mar", 
            COLOUR_CODE     "Cul", 
            C_DESCRIPTION   "Desc_cul", 
            WHS_CODE        "Magazie", 
            SEASON_CODE     "Stagiune", 
            GROUP_CODE      "Comanda", 
            PUOM            "Um", 
            MAT_TYPE        "Familie", 
            REF_DATE        "Data_ref", 
            NOTE            "Obs" 
    FROM    VW_REP_WHS_STOC 
    ORDER BY seq_no
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_WIP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_WIP" ("ORG_CODE", "ORG_CODE_LOC", "ORDER_CODE", "PERIOD", "FIRST_OPER", "OPER_CODE", "SEASON_CODE", "ITEM_CODE", "QTY", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code, 
txt02   org_code_loc, 
txt03   order_code, 
txt04   period, 
txt05   first_oper, 
txt06   oper_code, 
txt07   season_code, 
txt08   item_code, 
numb01  qty, 
segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    =   'VW_REP_WIP' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_WIP_GROUPED
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_WIP_GROUPED" ("ORG_CODE_LOC", "OPER_CODE", "SEASON_CODE", "ORDER_CODE", "ITEM_CODE", "STOCK_INI", "QTY_IN", "QTY_OUT", "STOCK_FIN", "OPER_SEQ", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code_loc, 
txt02   oper_code, 
txt03   season_code, 
txt04   order_code, 
txt05   item_code, 
numb01  stock_ini, 
numb02  qty_in, 
numb03  qty_out, 
numb04  stock_fin, 
numb05  oper_seq, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_WIP_GROUPED' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_WIP_GROUPED_U
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_WIP_GROUPED_U" ("Stagiune", "Bola", "ARticol", "Locatie", "SecvOp", "Operatie", "Stoc Initial", "Cant Intrata", "Cant Iesita", "Stoc Final") AS 
  SELECT  season_code "Stagiune", 
  order_code "Bola", 
  item_code "ARticol", 
  org_code_loc "Locatie", 
        oper_seq "SecvOp", 
        oper_code "Operatie", 
        stock_ini "Stoc Initial", 
        qty_in "Cant Intrata", 
        qty_out "Cant Iesita", 
        stock_fin "Stoc Final" 
FROM    vw_rep_wip_grouped 
WHERE   ( 
        stock_ini <> 0 
        OR 
        qty_in <> 0 
        OR 
        qty_out <> 0 
        OR 
        stock_fin > 0 
        ) 
ORDER BY 1,2,3
 ;
/
--------------------------------------------------------
--  DDL for View VW_REP_WIP_GRP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_REP_WIP_GRP" ("ORG_CODE_LOC", "OPER_CODE", "STOCK_INI", "QTY_IN", "QTY_OUT", "STOCK_FIN", "OPER_SEQ", "SEGMENT_CODE") AS 
  SELECT 
txt01   org_code_loc, 
txt02   oper_code, 
numb01  stock_ini, 
numb02  qty_in, 
numb03  qty_out, 
numb04  stock_fin, 
numb05  oper_seq, 
segment_code 
FROM TMP_SEGMENT 
WHERE segment_code = 'VW_REP_WIP_GRP' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_RP_SHIP_FIFO_02
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RP_SHIP_FIFO_02" ("REF_SHIPMENT", "SHIP_DATE", "PROTOCOL_CODE", "PROTOCOL_DATE", "SUPPL_NAME", "SUPPL_CODE", "DOC_NUMBER", "DOC_DATE", "RECEIPT_DATE", "ITEM_CODE", "ITEM_DESC", "QTY", "PUOM", "UNIT_PRICE") AS 
  SELECT fm.ref_shipment,
    sh.ship_date,
    sh.protocol_code,
    sh.protocol_date,
    sup.org_name suppl_name,
    rh.suppl_code,
    rh.doc_number,
    rh.doc_date,
    rh.receipt_date,
    rd.item_code,
    NVL(it.description_alt, it.description) item_desc,
    fm.qty * rd.qty_count / rd.qty_count_puom qty,
    rd.uom_receipt puom,
    rd.price_doc unit_price
  FROM fifo_material fm
  INNER JOIN receipt_detail rd
  ON rd.idriga = fm.ref_receipt
  INNER JOIN receipt_header rh
  ON rh.idriga = rd.ref_receipt
  INNER JOIN item it
  ON it.org_code   = rd.org_code
  AND it.item_code = rd.item_code
  INNER JOIN shipment_header sh
  ON sh.idriga = fm.ref_shipment
  INNER JOIN organization sup
  ON sup.org_code    = rh.suppl_code
  WHERE rh.org_code <> rh.suppl_code;
/
--------------------------------------------------------
--  DDL for View VW_RP_SHIP_FIFO_PROPOSE_MAT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RP_SHIP_FIFO_PROPOSE_MAT" ("REF_SHIPMENT", "PROTOCOL_CODE", "PROTOCOL_DATE", "SHIP_QTY", "CHILD_CODE", "ITEM_DESC", "PUOM", "MAT_UNIT_QTY", "MAT_TOT_QTY", "FIFO_NEEDED", "FIFO_STOCK", "REC_LIST") AS 
  with 
ship_fifo as 
    (
    select ref_shipment, org_code, item_code, sum(fm.qty) fifo_qty
    from fifo_material fm
    inner join receipt_detail rd on rd.idriga = fm.ref_receipt
    group by ref_shipment, org_code, item_code
    ),
active_fifo as
    (
    select org_code, item_code, sum(qty_doc_puom - qty_fifo) fifo_stock,
    LISTAGG(receipt_type||'-'||sf.doc_number||' - '||to_char(sf.doc_date, 'dd.mm.yyyy')
            ||': '||to_char(qty_doc_puom - qty_fifo)||' '
            ||'('||sf.price_doc_puom||' E)'
        , chr(13)||chr(10)) 
        WITHIN GROUP (ORDER BY item_code, sf.doc_number) rec_list
    from v_stoc_fifo sf
    where qty_doc_puom - qty_fifo > 0
    group by org_code, item_code
    )
select sd.ref_shipment, sd.protocol_code, sd.protocol_date, sd.ship_qty, bom.child_code, it.description item_desc, it.puom,
    bom.qta mat_unit_qty, sd.ship_qty * bom.qta mat_tot_qty,
    greatest ((sd.ship_qty * bom.qta - nvl(sf.fifo_qty, 0)), 0) fifo_needed,
    stk.fifo_stock, stk.rec_list
from bom_std bom
inner join item it on it.org_code = bom.org_code and it.item_code = bom.child_code
cross join (
    select ref_shipment, max(sh.protocol_code) protocol_code, max(sh.protocol_date) protocol_date, sum(qty_doc) ship_qty 
    from shipment_detail sd
    inner join shipment_header sh on sh.idriga = sd.ref_shipment
    group by ref_shipment) sd
left join ship_fifo sf on sf.ref_shipment = sd.ref_shipment and sf.org_code = bom.org_code and sf.item_code = bom.child_code
left join active_fifo stk on stk.org_code = bom.org_code and stk.item_code = bom.child_code
where bom.father_code ='FAM.FG'
--and sd.ref_shipment = 4937;
/
--------------------------------------------------------
--  DDL for View VW_RP_SHIP_SPECIF
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RP_SHIP_SPECIF" ("REF_SHIPMENT", "ORG_CODE", "PROTOCOL_CODE", "PROTOCOL_DATE", "SHIP_TYPE", "SEASON_DESC", "ROOT_CODE", "VAR_VALUE", "QTY", "PACKAGE_NUMBER") AS 
  select sd.ref_shipment, sh.org_code, sh.protocol_code, sh.protocol_date, sh.ship_type,
    ws.description season_desc, it.root_code, iv.var_value, sum(sd.qty_doc) qty, sum(sd.package_number) package_number
from shipment_header sh
inner join shipment_detail sd on sd.ref_shipment = sh.idriga
inner join item it on it.org_code = sd.org_code and it.item_code = sd.item_code
left join item_variable iv on iv.org_code = it.org_code and iv.item_code = it.item_code and iv.var_code = 'TIPTALPA'
left join work_season ws on ws.org_code = sd.org_code and ws.season_code = sd.season_code
group by sd.ref_shipment, sh.org_code, sh.protocol_code, sh.protocol_date, sh.ship_type, sd.ref_shipment, 
    ws.description, it.root_code, iv.var_value;
/
--------------------------------------------------------
--  DDL for View VW_RP_STOCK_FIFO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_RP_STOCK_FIFO" ("ORG_CODE", "SUPPL_CODE", "ITEM_CODE", "TYPE_CODE", "ITEM_DESC", "UOM_RECEIPT", "UNIT_PRICE_EUR", "UNIT_PRICE_RON", "STOCK_QTY", "STOCK_VALUE_EUR", "STOCK_VALUE_RON") AS 
  SELECT org_code, suppl_code, item_code, max(type_code) type_code, max(item_desc) item_desc, uom_receipt, 
    round(in_value_eur) unit_price_eur,
    round(sum(in_value_ron)/sum(in_qty), 5) unit_price_ron,
    sum(in_qty) - sum(out_qty) stock_qty,
    round(sum(in_value_eur)/sum(in_qty) * (sum(in_qty) - sum(out_qty)), 2) stock_value_eur,
    round(sum(in_value_ron)/sum(in_qty) * (sum(in_qty) - sum(out_qty)), 2) stock_value_ron
from
    (
    SELECT 
        h.org_code, h.suppl_code, d.item_code, i.type_code, i.description  item_desc, d.uom_receipt, 
        d.qty_count in_qty, 
        d.price_doc unit_price_eur,
        d.qty_count * d.price_doc in_value_eur,
        d.qty_count * d.price_doc * cr.exchange_rate in_value_ron,
        (
            SELECT NVL(SUM(f.qty), 0) 
             FROM   FIFO_MATERIAL f
             WHERE  f.ref_receipt = d.idriga
        ) * (d.qty_count / d.qty_count_puom) out_qty
    FROM            RECEIPT_HEADER      h
    INNER   JOIN    WHS_TRN             t
                    ON  t.ref_receipt   =   h.idriga
                    AND t.flag_storno   =   'N'
    INNER   JOIN    RECEIPT_DETAIL      d
                    ON  d.ref_receipt   =   h.idriga
    INNER   JOIN    SETUP_RECEIPT       s
                    ON  s.receipt_type  =   h.receipt_type
    INNER   JOIN    ITEM                i
                    ON  i.org_code      =   d.org_code
                    AND i.item_code     =   d.item_code
    LEFT    JOIN    CURRENCY_RATE cr
                    ON cr.calendar_day  =   h.receipt_date
                    AND cr.currency_from =  h.currency_code
                    AND cr.currency_to  =   'RON'
    WHERE           h.status    <> 'X'
            AND     h.org_code      =   'ALT'
            AND     s.fifo          =   'Y'
            AND     d.qty_doc_puom  >   0
    )
group by org_code, suppl_code, item_code, uom_receipt, round(in_value_eur)
having sum(in_qty) > sum(out_qty);
/
--------------------------------------------------------
--  DDL for View VW_SETUP_INVOICE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SETUP_INVOICE" ("TYPE_CODE", "DESCRIPTION", "TYPE_IO", "WHS_RECEIT", "FLAG_SUPPLIER", "DOCUMENT_NAME", "CURRENCY", "FLAG_PROPERTY") AS 
  SELECT
    t.TYPE_CODE, t.DESCRIPTION, t.TYPE_IO, t.WHS_RECEIT, t.FLAG_SUPPLIER, t.DOCUMENT_NAME, t.CURRENCY, t.FLAG_PROPERTY
    FROM    SETUP_INVOICE t

 ;
/
--------------------------------------------------------
--  DDL for View VW_SETUP_MOVEMENT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SETUP_MOVEMENT" ("IDRIGA", "MOVE_CODE", "WHS_SOURCE", "WHS_DESTIN", "FLAG_DEMAND", "FLAG_DIFFER_SEASON", "FLAG_COST_CENTER", "FLAG_SIZE_COLOUR", "FLAG_ACCOUNT_CODE") AS 
  SELECT 
t.IDRIGA, t.MOVE_CODE, t.WHS_SOURCE, t.WHS_DESTIN, t.FLAG_DEMAND, t.FLAG_DIFFER_SEASON , t.flag_cost_center, 
T.FLAG_SIZE_COLOUR, t.flag_account_code 
FROM  SETUP_MOVEMENT t
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_SHIPMENT_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SHIPMENT_DETAIL" ("REF_SHIPMENT", "ORDER_CODE", "ITEM_CODE", "COLOUR_CODE", "SIZE_CODE", "QTA", "PALLET", "WEIGHT_NET", "WEIGHT_BRUT", "VOLUME", "PACKAGE_CODE", "QUALITY", "ORG_CODE") AS 
  SELECT
REF_SHIPMENT,
ORDER_CODE,
ITEM_CODE,
COLOUR_CODE,
SIZE_CODE,
QTA,
PALLET,
WEIGHT_NET,
WEIGHT_BRUT,
VOLUME,
PACKAGE_CODE,
QUALITY,
ORG_CODE
FROM SHIPMENT_DETAIL

 ;
/
--------------------------------------------------------
--  DDL for View VW_STG_BOM_RUCO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_STG_BOM_RUCO" ("ORG_CODE", "FTH_ITEM_CODE", "FTH_DESCRIPTION", "FTH_COLOUR_CODE", "FTH_COLOUR_DESC", "CHL_ITEM_CODE", "CHL_DESCRIPTION", "CHL_UOM_CODE", "CHL_COLOUR_CODE", "CHL_COLOUR_DESC", "FTH_SIZE_CODE", "CHL_SIZE_CODE", "NOTE_1", "NOTE_2", "CHL_UNIT_QTY", "SEGMENT_CODE") AS 
  select txt01 org_code, txt02 fth_item_code, txt03 fth_description, txt04 fth_colour_code, txt05 fth_colour_desc, 
    txt06 chl_item_code, txt07 chl_description, txt08 chl_uom_code, txt09 chl_colour_code, txt10 chl_colour_desc, 
    txt11 fth_size_code, txt12 chl_size_code, txt13 note_1, txt14 note_2, 
    numb01 chl_unit_qty, 
    segment_code 
from TMP_SEGMENT 
    WHERE   segment_code    =   'VW_STG_BOM_RUCO' 
    WITH CHECK OPTION;
/
--------------------------------------------------------
--  DDL for View VW_STOC_ONLINE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_STOC_ONLINE" ("ORG_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "COLOUR_CODE", "SIZE_CODE", "WHS_CODE", "SEASON_CODE", "ORDER_CODE", "GROUP_CODE", "PUOM", "QTY", "REF_DATE", "SEGMENT_CODE") AS 
  SELECT 
            txt01       org_code, 
            txt02       item_code, 
            txt03       oper_code_item, 
            txt04       colour_code, 
            txt05       size_code, 
            txt06       whs_code, 
            txt07       season_code, 
            txt08       order_code, 
            txt09       group_code, 
            txt10       puom, 
            numb01      qty, 
            data01      REF_DATE, 
            segment_code 
    FROM    TMP_SEGMENT 
    WHERE   segment_code    =   'VW_STOC_ONLINE'
 ;
/
--------------------------------------------------------
--  DDL for View VW_STOC_PKG
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_STOC_PKG" ("ORG_CODE", "ORDER_CODE", "SIZE_CODE", "QTY", "QTY_Q1", "QTY_Q2", "QTY_PKG_M", "QTY_PKG", "SEGMENT_CODE") AS 
  SELECT
txt01   org_code,
txt02   order_code,
txt03   size_code,
numb01  qty,
numb02  qty_q1,
numb03  qty_q2,
numb04  qty_pkg_m,
numb05  qty_pkg,
segment_code
FROM TMP_SEGMENT
WHERE   segment_code = 'VW_STOC_PKG'
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_ALERT_LOG
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_ALERT_LOG" ("LINE", "TEXT") AS 
  SELECT numb01 LINE, txt50 text 
FROM TABLE(Pkg_Sys_Tools.f_sql_read_file('BDUMP','alert_xe.log')  ) 
ORDER BY numb01 DESC
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_APP_PATCH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_APP_PATCH" ("PATCH_ID", "STATEMENT_ID", "SEQ_NO", "TEXT", "SEGMENT_CODE") AS 
  SELECT 
            txt01       patch_id    , 
            txt02       STATEMENT_ID, 
            numb01      seq_no      , 
            txt50       text        , 
            segment_code 
    FROM    X_WORK_BENCH 
    WHERE   segment_code    =   'VW_SYS_APP_PATCH' 
    WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_CONSTRAINT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_CONSTRAINT" ("OWNER", "TABLE_NAME", "CONSTRAINT_NAME", "CONSTRAINT_TYPE", "SEARCH_CONDITION", "R_CONSTRAINT_NAME") AS 
  SELECT  owner,table_name, constraint_name,constraint_type,search_condition , r_constraint_name 
FROM    DBA_CONSTRAINTS 
WHERE   constraint_name NOT LIKE 'SYS_%' 
ORDER BY  table_name, constraint_type,constraint_name
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_CONSTRAINT_DEF
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_CONSTRAINT_DEF" ("CONSTRAINT_NAME", "CONSTRAINT_TYPE", "CONSTRAINT_TABLE", "CONSTRAINT_COLUMN", "REF_TABLE", "REF_COLUMN", "SEARCH_CONDITION", "SEGMENT_CODE") AS 
  SELECT 
            txt01       constraint_name, 
            txt02       constraint_type, 
            txt03       constraint_table, 
            txt04       constraint_column, 
            txt05       ref_table, 
            txt06       ref_column, 
            txt07       search_condition, 
            segment_code 
    FROM    X_WORK_BENCH 
    WHERE   segment_code    = 'VW_SYS_CONSTRAINT_DEF' 
    WITH    CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_CONSTRAINT_DEF_AUX
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_CONSTRAINT_DEF_AUX" ("CONSTRAINT_TYPE", "CONSTRAINT_TABLE", "CONSTRAINT_NAME", "DEFINITION_TEXT") AS 
  SELECT 
            constraint_type, 
            constraint_table, 
            constraint_name, 
            (CASE 
                WHEN constraint_type = 'R' THEN 
                    'ALTER TABLE '||constraint_table||' ADD ( CONSTRAINT '||constraint_name 
                    || ' FOREIGN KEY ('||constraint_column||') REFERENCES '||ref_table ||' ('||ref_column||'));' 
                WHEN constraint_type = 'U' THEN 
                    'ALTER TABLE '||constraint_table||' ADD ( CONSTRAINT '||constraint_name 
                    || ' UNIQUE ('||constraint_column||') USING INDEX IN_'||constraint_table ||'_01) ;' 
                WHEN constraint_type = 'P' THEN 
                    'ALTER TABLE '||constraint_table||' ADD ( CONSTRAINT '||constraint_name 
                    || ' PRIMARY KEY ('||constraint_column||') USING INDEX IN_'||constraint_table ||'_PK) ;' 
            END)        definition_text 
FROM    VW_SYS_CONSTRAINT_DEF
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_CONSTRAINT_DIFFERENCE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_CONSTRAINT_DIFFERENCE" ("CONSTRAINT_NAME", "FLAG_SYS", "FLAG_EXC") AS 
  SELECT constraint_name, MAX(flag_sys) flag_sys, MAX(flag_exc) flag_exc 
FROM 
( 
SELECT constraint_name, 1 flag_sys, 0 flag_exc 
FROM USER_CONSTRAINTS 
WHERE constraint_name NOT LIKE 'SYS_%' AND constraint_name NOT LIKE '%_PK' 
UNION ALL 
SELECT index_name ,1 flag_sys, 0 flag_exc 
FROM USER_INDEXES 
WHERE  index_type = 'FUNCTION-BASED NORMAL' 
UNION ALL 
SELECT num_excep      , 0 flag_sys, 1 flag_exc FROM   APP_EXCEPTIONS  WHERE SQLCODE <> -1400 
) 
GROUP BY constraint_name 
HAVING MAX(flag_sys) <>  MAX(flag_exc) 
ORDER BY constraint_name
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_CREATE_IUD
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_CREATE_IUD" ("TEXT") AS 
  SELECT  clob01   text 
FROM    TMP_GENERAL
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_INDEX_DEF
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_INDEX_DEF" ("TABLE_NAME", "INDEX_NAME", "UNIQUENESS", "INDEX_COLUMN", "SEGMENT_CODE") AS 
  SELECT 
            txt01       table_name, 
            txt02       index_name, 
            txt03       uniqueness, 
            txt04       index_column, 
            segment_code 
    FROM    X_WORK_BENCH 
    WHERE   segment_code    = 'VW_SYS_INDEX_DEF' 
    WITH    CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_INDEX_DEF_AUX
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_INDEX_DEF_AUX" ("INDEX_DEFINITION") AS 
  SELECT
            'CREATE INDEX '||index_name||' ON '||table_name||' ('||index_column||') TABLESPACE INDX;' index_definition
    FROM    VW_SYS_INDEX_DEF

 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_MSACCESS_SOURCE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_MSACCESS_SOURCE" ("MODULE_TYPE", "MODULE_NAME", "SEQ_NO", "TEXT", "TEXT_UPPER", "PROCEDURE_NAME", "DATAGG") AS 
  SELECT  txt01           module_type, 
        txt02           module_name, 
        numb01          seq_no, 
        txt03           text, 
        UPPER(txt03)    text_upper, 
        txt04           procedure_name, 
        datagg 
FROM    APP_MSACCESS_SOURCE
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_USER_SOURCE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_USER_SOURCE" ("TYPE", "NAME", "PROC", "TEXT", "LINE") AS 
  SELECT  txt01  TYPE, 
  txt02 NAME, 
  txt03 proc, 
  txt04 text, 
  numb01 LINE 
FROM TABLE(Pkg_Sys_Tools.f_sql_user_source())
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_USER_VIEWS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_USER_VIEWS" ("VIEW_NAME", "TEXT") AS 
  SELECT   txt01 view_name,clob01 text 
FROM TABLE (Pkg_Sys_Tools.f_sql_sys_user_views())
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_SYS_USER_VIEWS_AUX
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_SYS_USER_VIEWS_AUX" ("VIEW_NAME", "TEXT", "SEGMENT_CODE") AS 
  SELECT txt01 view_name, 
  clob01 text, 
  segment_code 
FROM   TMP_SEGMENT 
WHERE  SEGMENT_CODE = 'VW_SYS_USER_VIEWS_AUX' 
WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_TASKS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_TASKS" ("IDRIGA", "FORM_NAME", "TASK_ORDER", "TASK_NAME", "PAR_LABEL1", "PAR_SQL1", "PAR_TYPE1", "PAR_LABEL2", "PAR_SQL2", "PAR_TYPE2", "PAR_LABEL3", "PAR_SQL3", "PAR_TYPE3", "PAR_LABEL4", "PAR_SQL4", "PAR_TYPE4", "PAR_LABEL5", "PAR_SQL5", "PAR_TYPE5", "PAR_LABEL6", "PAR_SQL6", "PAR_TYPE6", "PAR_LABEL7", "PAR_SQL7", "PAR_TYPE7", "PAR_LABEL8", "PAR_SQL8", "PAR_TYPE8", "PAR_LABEL9", "PAR_SQL9", "PAR_TYPE9", "PAR_LABEL10", "PAR_SQL10", "PAR_TYPE10") AS 
  SELECT 
        t.IDRIGA, 
        t.FORM_NAME, 
        t.TASK_ORDER, 
        t.TASK_NAME, 
        t.PAR_LABEL1, 
        t.PAR_SQL1, 
        t.PAR_TYPE1, 
        t.PAR_LABEL2, 
        t.PAR_SQL2, 
        t.PAR_TYPE2, 
        t.PAR_LABEL3, 
        t.PAR_SQL3, 
        t.PAR_TYPE3, 
        t.PAR_LABEL4, 
        t.PAR_SQL4, 
        t.PAR_TYPE4, 
        t.PAR_LABEL5, 
        t.PAR_SQL5, 
        t.PAR_TYPE5, 
        t.PAR_LABEL6, 
        t.PAR_SQL6, 
        t.PAR_TYPE6, 
        t.PAR_LABEL7, 
        t.PAR_SQL7, 
        t.PAR_TYPE7, 
        t.PAR_LABEL8, 
        t.PAR_SQL8, 
        t.PAR_TYPE8, 
        t.PAR_LABEL9, 
        t.PAR_SQL9, 
        t.PAR_TYPE9, 
        t.PAR_LABEL10, 
        t.PAR_SQL10, 
        t.PAR_TYPE10 
FROM  TASKS t
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_TEMPORARY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_TEMPORARY" ("GROUP_CODE", "SEQ_NO", "OPER_CODE", "WHS_CONS", "WHS_DEST", "WORKCENTER_CODE", "ORG_CODE_PREV", "ORG_CODE_CURR", "ORG_CODE_NEXT", "CATEGORY_CODE_PREV", "CATEGORY_CODE_CURR", "CATEGORY_CODE_NEXT") AS 
  SELECT
        r.group_code, r.seq_no, r.oper_code, r.whs_cons, r.whs_dest, r.workcenter_code,
        LAG(w.org_code)         OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) org_code_prev ,
        w.org_code                                                                  org_code_curr,
        LEAD(w.org_code)        OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) org_code_next,
        LAG(w.category_code)    OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) category_code_prev ,
        w.category_code                                                             category_code_curr,
        LEAD(w.category_code)   OVER (PARTITION BY r.group_code ORDER BY r.seq_no ) category_code_next
FROM        GROUP_ROUTING   r
INNER JOIN  WAREHOUSE       w
                ON  w.whs_code  =   r.whs_cons
ORDER BY group_code,seq_no

 ;
/
--------------------------------------------------------
--  DDL for View VW_TRANSFER_ORACLE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_TRANSFER_ORACLE" ("TXT01", "TXT02", "TXT03", "TXT04", "TXT05", "TXT06", "TXT07", "TXT08", "TXT09", "TXT10", "TXT11", "TXT12", "TXT13", "TXT14", "TXT15", "TXT16", "TXT17", "TXT18", "TXT19", "TXT20", "DATA01", "DATA02", "DATA03", "DATA04", "DATA05", "DATA06", "DATA07", "DATA08", "DATA09", "DATA10", "NUMB01", "NUMB02", "NUMB03", "NUMB04", "NUMB05", "NUMB06", "NUMB07", "NUMB08", "NUMB09", "NUMB10", "NUMB11", "NUMB12", "NUMB13", "NUMB14", "NUMB15", "NUMB16", "NUMB17", "NUMB18", "NUMB19", "NUMB20", "SEGMENT_CODE") AS 
  SELECT 
TXT01, TXT02, TXT03, TXT04, TXT05, TXT06, TXT07, TXT08, TXT09, TXT10, TXT11, TXT12, TXT13, TXT14, TXT15, TXT16, TXT17, TXT18, TXT19, TXT20, 
DATA01, DATA02, DATA03, DATA04, DATA05, DATA06, DATA07, DATA08, DATA09, DATA10, 
NUMB01, NUMB02, NUMB03, NUMB04, NUMB05, NUMB06, NUMB07, NUMB08, NUMB09, NUMB10, NUMB11, NUMB12, NUMB13, NUMB14, NUMB15, NUMB16, NUMB17, NUMB18, NUMB19, NUMB20 , 
segment_code 
FROM    TMP_SEGMENT 
WHERE   segment_code    = 'VW_TRANSFER_ORACLE' 
WITH CHECK OPTION
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_VIRTUAL_TABLE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_VIRTUAL_TABLE" ("IDRIGA", "SEGMENT_CODE", "TXT01", "TXT02", "TXT03", "TXT04", "TXT05", "TXT06", "TXT07", "TXT08", "TXT09", "TXT10", "TXT11", "TXT12", "TXT13", "TXT14", "TXT15", "TXT16", "TXT17", "TXT18", "TXT19", "TXT20", "TXT21", "TXT22", "TXT23", "TXT24", "TXT25", "TXT26", "TXT27", "TXT28", "TXT29", "TXT30", "NUMB01", "NUMB02", "NUMB03", "NUMB04", "NUMB05", "NUMB06", "NUMB07", "NUMB08", "NUMB09", "NUMB10", "NUMB11", "NUMB12", "NUMB13", "NUMB14", "NUMB15", "NUMB16", "NUMB17", "NUMB18", "NUMB19", "NUMB20", "DATA01", "DATA02", "DATA03", "DATA04", "DATA05", "DATA06", "DATA07", "DATA08", "DATA09", "DATA10") AS 
  SELECT 
idriga, segment_code, 
txt01, txt02, txt03, txt04, txt05, txt06, txt07, txt08, txt09, txt10, txt11, txt12, txt13, txt14, txt15, txt16, txt17, txt18, txt19, txt20, txt21, txt22, txt23, txt24, txt25, txt26, txt27, txt28, txt29, txt30, 
numb01, numb02, numb03, numb04, numb05, numb06, numb07, numb08, numb09, numb10, numb11, numb12, numb13, numb14, numb15, numb16, numb17, numb18, numb19, numb20, 
data01, data02, data03, data04, data05, data06, data07, data08, data09, data10 
FROM  VIRTUAL_TABLE
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_WHS_TRN
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_WHS_TRN" ("IDRIGA", "ORG_CODE", "TRN_YEAR", "TRN_CODE", "TRN_DATE", "TRN_TYPE", "REASON_CODE", "FLAG_STORNO", "REF_SHIPMENT", "REF_RECEIT", "REF_STORNO", "PARTNER_CODE", "DOC_YEAR", "DOC_CODE", "DOC_DATE", "NOTE", "EMPLOYEE_CODE", "DATE_LEGAL") AS 
  SELECT
t.IDRIGA, t.ORG_CODE, t.TRN_YEAR, t.TRN_CODE, t.TRN_DATE, t.TRN_TYPE, t.REASON_CODE, t.FLAG_STORNO,
t.REF_SHIPMENT, t.REF_RECEIT, t.REF_STORNO, t.PARTNER_CODE, t.DOC_YEAR, t.DOC_CODE, t.DOC_DATE, t.NOTE, t.employee_code ,
t.date_legal
FROM    WHS_TRN t

 ;
/
--------------------------------------------------------
--  DDL for View VW_WHS_TRN_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_WHS_TRN_DETAIL" ("IDRIGA", "REF_TRN", "REASON_CODE", "QTY", "OPER_CODE_ITEM", "ORDER_CODE", "QTY_SIGN", "WHS_CODE", "GROUP_CODE", "ITEM_CODE", "TRN_SIGN", "COLOUR_CODE", "SIZE_CODE", "ORG_CODE", "PUOM", "SEASON_CODE", "COST_CENTER", "REF_RECEIPT", "ACCOUNT_CODE") AS 
  SELECT 
    t.idriga, t.ref_trn,t.reason_code, t.qty,t.oper_code_item,t.order_code, 
    t.qty*t.trn_sign qty_sign, t.whs_code, t.group_code, 
    t.item_code, 
    t.trn_sign,t.colour_code, 
    t.size_code, 
    t.org_code, t.puom,t.season_code, t.cost_center, 
    t.ref_receipt, t.account_code 
FROM    WHS_TRN_DETAIL t
 ;
/
--------------------------------------------------------
--  DDL for View VW_WHS_TRN_REASON
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_WHS_TRN_REASON" ("REASON_CODE", "DESCRIPTION", "REASON_TYPE", "TRN_SIGN", "PROPERTY", "ALLOC_WO", "ACCOUNTING", "BUSINESS_FLOW") AS 
  SELECT 
        r.reason_code, r.description, r.reason_type, r.trn_sign, 
        r.property, r.alloc_wo, r.accounting, r.business_flow 
    FROM    WHS_TRN_REASON r 
    ORDER BY r.business_flow
 ;
/
--------------------------------------------------------
--  DDL for View VW_WIZ
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_WIZ" ("WIZ_CODE", "STEP_NO", "IDRIGA", "FLAG_SELECTED", "ROW_KEY", "CURR_INFO", "PREV_INFO", "ROW_VALUE", "TXT11", "TXT12", "TXT13", "TXT14", "TXT15", "TXT16", "TXT17", "TXT18", "TXT19", "TXT20", "SEGMENT_CODE") AS 
  SELECT  txt01   wiz_code, 
        numb01  step_no, 
        numb02  idriga, 
        numb03  flag_selected, 
        txt36   row_key, 
        txt37   curr_info, 
        txt38   prev_info, 
        txt03   row_value, 
        txt11   txt11, 
        txt12   txt12, 
        txt13   txt13, 
        txt14   txt14, 
        txt15   txt15, 
        txt16   txt16, 
        txt17   txt17, 
        txt18   txt18, 
        txt19   txt19, 
        txt20   txt20, 
        segment_code 
FROM    TMP_SEGMENT 
WHERE segment_code = 'VW_WIZ' 
WITH CHECK OPTION
 ;
/
--------------------------------------------------------
--  DDL for View VW_WORK_ORDER
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_WORK_ORDER" ("IDRIGA", "ORG_CODE", "ORDER_CODE", "ITEM_CODE", "STATUS", "LINE", "PRIORITY", "DATE_CREATE", "DATE_LAUNCH", "DATE_COMPLET", "DATE_CLIENT", "GROUP_CODE", "CLIENT_LOT", "CLIENT_LOCATION", "SEASON_CODE", "NOTE") AS 
  SELECT 
IDRIGA, 
org_code, 
ORDER_CODE, 
ITEM_CODE, 
STATUS, 
LINE, 
PRIORITY, 
DATE_CREATE, 
DATE_LAUNCH, 
DATE_COMPLET, 
DATE_CLIENT, 
GROUP_CODE, 
CLIENT_LOT, 
CLIENT_LOCATION, 
SEASON_CODE, 
NOTE 
FROM WORK_ORDER
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_WO_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_WO_DETAIL" ("IDRIGA", "REF_WO", "SIZE_CODE", "QTA", "QTA_COMPLET", "QTA_SCRAP", "QTA_SHIP_GOOD", "QTA_SHIP_SCRAP") AS 
  SELECT 
IDRIGA, 
REF_WO, 
SIZE_CODE, 
QTA, 
QTA_COMPLET, 
QTA_SCRAP, 
QTA_SHIP_GOOD, 
QTA_SHIP_SCRAP 
FROM WO_DETAIL
 
 
 ;
/
--------------------------------------------------------
--  DDL for View VW_WO_GROUP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "VW_WO_GROUP" ("GROUP_CODE", "ORG_CODE", "ORDER_CODE", "OPER_CODE", "ROW_VERSION") AS 
  SELECT 
            t.group_code, t.org_code, t.order_code, 
            t.oper_code, t.row_version 
    FROM    WO_GROUP t
 
 ;
/
--------------------------------------------------------
--  DDL for View V_FIFO_REC
--------------------------------------------------------

  CREATE OR REPLACE VIEW "V_FIFO_REC" ("IDRIGA", "DCN", "PUOM", "QTY_DOC_PUOM", "QTY_COUNT_PUOM", "ITEM_CODE", "COLOUR_CODE", "SIZE_CODE", "OPER_CODE_ITEM", "SEASON_CODE", "PRICE_DOC_PUOM", "RECEIPT_CODE", "RECEIPT_DATE", "ORG_CODE", "RECEIPT_TYPE", "SUPPL_CODE", "DOC_NUMBER", "DOC_DATE", "CURRENCY_CODE", "FIFO", "DATE_LEGAL", "S_DESCRIPTION", "I_DESCRIPTION", "C_DESCRIPTION", "QTY_FIFO") AS 
  SELECT
                        d.idriga, d.dcn,
                        d.puom, d.qty_doc_puom, d.qty_count_puom,
                        d.item_code, d.colour_code, d.size_code,
                        d.oper_code_item, d.season_code,d.price_doc_puom,
                        --
                        h.receipt_code, h.receipt_date, h.org_code, h.receipt_type,
                        h.suppl_code, h.doc_number, h.doc_date, h.currency_code, h.fifo,
                        --
                        t.date_legal,
                        --
                        s.description  s_description,
                        --
                        i.description  i_description,
                        --
                        c.description   c_description,
                        --
                        (SELECT NVL(SUM(f.qty),0)
                         FROM   FIFO_MATERIAL f
                         WHERE  f.ref_receipt = d.idriga) qty_fifo
                FROM            RECEIPT_HEADER      h
                INNER   JOIN    WHS_TRN             t
                                ON  t.ref_receipt   =   h.idriga
                                AND t.flag_storno   =   'N'
                INNER   JOIN    RECEIPT_DETAIL      d
                                ON  d.ref_receipt   =   h.idriga
                INNER   JOIN    SETUP_RECEIPT       s
                                ON  s.receipt_type  =   h.receipt_type
                INNER   JOIN    ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT    JOIN    COLOUR              c
                                ON  c.org_code      =   d.org_code
                                AND c.colour_code   =   d.colour_code
                WHERE           h.status    <> 'X'
                        AND     s.fifo          =   'Y'
                        AND     d.qty_doc_puom  >   0;
/
--------------------------------------------------------
--  DDL for View V_SHIP_PACK_MODE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "V_SHIP_PACK_MODE" ("SEQ_NO", "PACK_MODE", "DESCRIPTION_RO", "DESCRIPTION_IT") AS 
  select seq_no, 
      min(table_key) pack_mode,
      max(case when table_key not like '%IT' then description end) description_ro,
      max(case when table_key like '%IT' then description end) description_it 
from multi_table
where table_name = 'SHIP_PACK_MODE'
group by seq_no;
/
--------------------------------------------------------
--  DDL for View V_STOC_FIFO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "V_STOC_FIFO" ("IDRIGA", "DCN", "PUOM", "QTY_DOC_PUOM", "QTY_COUNT_PUOM", "ITEM_CODE", "COLOUR_CODE", "SIZE_CODE", "OPER_CODE_ITEM", "SEASON_CODE", "PRICE_DOC_PUOM", "RECEIPT_CODE", "RECEIPT_DATE", "ORG_CODE", "RECEIPT_TYPE", "SUPPL_CODE", "DOC_NUMBER", "DOC_DATE", "CURRENCY_CODE", "FIFO", "DATE_LEGAL", "S_DESCRIPTION", "I_DESCRIPTION", "C_DESCRIPTION", "QTY_FIFO") AS 
  SELECT
                        d.idriga, d.dcn,
                        d.puom, d.qty_doc_puom, d.qty_count_puom,
                        d.item_code, d.colour_code, d.size_code,
                        d.oper_code_item, d.season_code,d.price_doc_puom,
                        --
                        h.receipt_code, h.receipt_date, h.org_code, h.receipt_type,
                        h.suppl_code, h.doc_number, h.doc_date, h.currency_code, h.fifo,
                        --
                        t.date_legal,
                        --
                        s.description  s_description,
                        --
                        i.description  i_description,
                        --
                        c.description   c_description,
                        --
                        (SELECT NVL(SUM(f.qty),0)
                         FROM   FIFO_MATERIAL f
                         WHERE  f.ref_receipt = d.idriga) qty_fifo
                FROM            RECEIPT_HEADER      h
                INNER   JOIN    WHS_TRN             t
                                ON  t.ref_receipt   =   h.idriga
                                AND t.flag_storno   =   'N'
                INNER   JOIN    RECEIPT_DETAIL      d
                                ON  d.ref_receipt   =   h.idriga
                INNER   JOIN    SETUP_RECEIPT       s
                                ON  s.receipt_type  =   h.receipt_type
                INNER   JOIN    ITEM                i
                                ON  i.org_code      =   d.org_code
                                AND i.item_code     =   d.item_code
                LEFT    JOIN    COLOUR              c
                                ON  c.org_code      =   d.org_code
                                AND c.colour_code   =   d.colour_code
                WHERE           h.status    <> 'X'
                        AND     s.fifo          =   'Y'
                        AND     d.qty_doc_puom  >   0;
/
--------------------------------------------------------
--  DDL for View V_STOC_ONLINE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "V_STOC_ONLINE" ("ORG_CODE", "ITEM_CODE", "OPER_CODE_ITEM", "COLOUR_CODE", "SIZE_CODE", "WHS_CODE", "SEASON_CODE", "ORDER_CODE", "GROUP_CODE", "QTY") AS 
  SELECT 
                m.org_code              , 
                m.item_code             , 
                m.oper_code_item        , 
                m.colour_code           , 
                m.size_code             , 
                m.whs_code              , 
                m.season_code           , 
                m.order_code            , 
                m.group_code            , 
                SUM(m.trn_sign  *   m.qty) qty 
FROM            WHS_TRN_DETAIL  m 
GROUP BY        m.org_code, m.item_code,m.whs_code, 
                m.season_code, m.colour_code, 
                m.size_code ,m.order_code,m.group_code, 
                m.oper_code_item 
HAVING          SUM(m.trn_sign *m.qty) <> 0
 ;
/
