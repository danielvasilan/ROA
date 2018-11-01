--------------------------------------------------------
--  DDL for Package PKG_CHECK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_CHECK" 
IS

PROCEDURE p_chk_organization                        (p_row IN OUT ORGANIZATION%ROWTYPE  ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_setup_receipt                       (p_row IN OUT SETUP_RECEIPT%ROWTYPE ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_item                                (p_row IN OUT ITEM%ROWTYPE          ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_colour                              (p_row IN OUT COLOUR%ROWTYPE        ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_item_size                           (p_row IN OUT ITEM_SIZE%ROWTYPE     ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_operation                           (p_row IN OUT OPERATION%ROWTYPE     ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_work_season                         (p_row IN OUT WORK_SEASON%ROWTYPE   ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_warehouse                           (p_row IN OUT WAREHOUSE%ROWTYPE     ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_work_order                          (p_row IN OUT WORK_ORDER%ROWTYPE    ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_custom                              (p_row IN OUT CUSTOM%ROWTYPE        ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_country                             (p_row IN OUT COUNTRY%ROWTYPE        ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_primary_uom                         (p_row IN OUT PRIMARY_UOM%ROWTYPE   ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_currency                            (p_row IN OUT CURRENCY%ROWTYPE      ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_delivery_condition                  (p_row IN OUT DELIVERY_CONDITION%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_cat_mat_type                        (p_row IN OUT CAT_MAT_TYPE%ROWTYPE  ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_sales_family                        (p_row IN OUT SALES_FAMILY%ROWTYPE  ,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_work_group                          (p_row IN OUT WORK_GROUP%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_movement_type                       (p_row IN OUT MOVEMENT_TYPE%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_warehouse_categ                     (p_row IN OUT WAREHOUSE_CATEG%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_setup_shipment                      (p_row IN OUT SETUP_SHIPMENT%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_setup_acrec                         (p_row IN OUT SETUP_ACREC%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_organization_loc                    (p_row IN OUT ORGANIZATION_LOC%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_value_ad_tax                        (p_row IN OUT VALUE_AD_TAX%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_macrorouting_header                 (p_row IN OUT MACROROUTING_HEADER%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_organization_sbu                    (p_row IN OUT ORGANIZATION%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);
PROCEDURE p_chk_app_user                            (p_row IN OUT APP_USER%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL);






END;
 

/

/
