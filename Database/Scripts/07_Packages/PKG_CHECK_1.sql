--------------------------------------------------------
--  DDL for Package Body PKG_CHECK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_CHECK" 
IS

/*********************************************************************************
    DDL: 21/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_organization(p_row IN OUT ORGANIZATION%ROWTYPE ,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0001';
BEGIN
    IF NOT Pkg_Get2.f_get_organization_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de organizatii (client/furnizori)'
                                    ||' nu exista in baza de date !!!',
             p_err_detail        =>  NVL(p_row.org_code,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 21/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_setup_receipt(p_row IN OUT SETUP_RECEIPT%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0002';
BEGIN
    IF NOT Pkg_Get2.f_get_setup_receipt_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste tipuri de receptii'
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.receipt_type,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_item(p_row IN OUT ITEM%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0003';
BEGIN
    IF NOT Pkg_Get2.f_get_item_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de articole'
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.org_code,'???') ||' / '||NVL(p_row.item_code,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_colour(p_row IN OUT COLOUR%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0004';
BEGIN
    IF NOT Pkg_Get2.f_get_colour_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de culori'
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.org_code,'???') ||' / '||NVL(p_row.colour_code,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_item_size(p_row IN OUT ITEM_SIZE%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0005';
BEGIN
    IF NOT Pkg_Get2.f_get_item_size_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste marimi '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.size_code,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_operation(p_row IN OUT OPERATION%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0006';
BEGIN
    IF NOT Pkg_Get2.f_get_operation_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste operatii '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.oper_code,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_work_season(p_row IN OUT WORK_SEASON%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0007';
BEGIN
    IF NOT Pkg_Get2.f_get_work_season_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste stagiuni '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.org_code,'???') ||' / '||NVL(p_row.season_code,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_warehouse(p_row IN OUT WAREHOUSE%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0008';
BEGIN
    IF NOT Pkg_Get2.f_get_warehouse_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste magazii '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.whs_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_work_order(p_row IN OUT WORK_ORDER%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0009';
BEGIN
    IF NOT Pkg_Get2.f_get_work_order_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste bole '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.org_code,'???') ||' / '|| NVL(p_row.order_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_custom(p_row IN OUT CUSTOM%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0010';
BEGIN
    IF NOT Pkg_Get2.f_get_custom_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri vamale '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.custom_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_country(p_row IN OUT COUNTRY%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0011';
BEGIN
    IF NOT Pkg_Get2.f_get_country_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de tari '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.country_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_primary_uom(p_row IN OUT PRIMARY_UOM%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0012';
BEGIN
    IF NOT Pkg_Get2.f_get_primary_uom_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste unitati de masura '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.puom ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_currency(p_row IN OUT CURRENCY%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0013';
BEGIN
    IF NOT Pkg_Get2.f_get_currency_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de valute '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.currency_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 23/02/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_delivery_condition(p_row IN OUT DELIVERY_CONDITION%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0014';
BEGIN
    IF NOT Pkg_Get2.f_get_delivery_condition_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste conditii INCOTERM '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.deliv_cond_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 09/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_cat_mat_type(p_row IN OUT CAT_MAT_TYPE%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0015';
BEGIN
    IF NOT Pkg_Get2.f_get_cat_mat_type_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste categorii de materiale '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.categ_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 09/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_sales_family(p_row IN OUT SALES_FAMILY%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0016';
BEGIN
    IF NOT Pkg_Get2.f_get_sales_family_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste familii de produse finite '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.org_code ,'???') ||' - '||NVL(p_row.family_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 10/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_work_group(p_row IN OUT WORK_GROUP%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0017';
BEGIN
    IF NOT Pkg_Get2.f_get_work_group_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste comenzi interne '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.group_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 16/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_movement_type(p_row IN OUT MOVEMENT_TYPE%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0018';
BEGIN
    IF NOT Pkg_Get2.f_get_movement_type_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste tipuri de miscari de magazie '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.trn_type ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 20/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_warehouse_categ(p_row IN OUT WAREHOUSE_CATEG%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0019';
BEGIN
    IF NOT Pkg_Get2.f_get_warehouse_categ_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste categorii de magazii '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.category_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 08/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_setup_shipment(p_row IN OUT SETUP_SHIPMENT%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0020';
BEGIN
    IF NOT Pkg_Get2.f_get_setup_shipment_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste tipuri de expeditii '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.ship_type ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 09/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_setup_acrec(p_row IN OUT SETUP_ACREC%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0021';
BEGIN
    IF NOT Pkg_Get2.f_get_setup_acrec_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste tipuri de facturi '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.acrec_type ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;

/*********************************************************************************
    DDL: 11/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_value_ad_tax(p_row IN OUT VALUE_AD_TAX%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0022';
BEGIN
    IF NOT Pkg_Get2.f_get_value_ad_tax_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de TVA '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.vat_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;

/*********************************************************************************
    DDL: 11/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_organization_loc(p_row IN OUT ORGANIZATION_LOC%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0023';
BEGIN
    IF NOT Pkg_Get2.f_get_organization_loc_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de destinatii '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        =>   p_row.org_code
                                    ||' / '  
                                    ||NVL(p_row.loc_code ,'???') 
                                    ||' - '
                                    || p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 11/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_macrorouting_header(p_row IN OUT MACROROUTING_HEADER%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0024';
BEGIN
    IF NOT Pkg_Get2.f_get_macrorouting_header_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de macrorouting '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.routing_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;
/*********************************************************************************
    DDL: 20/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_organization_sbu(p_row IN OUT ORGANIZATION%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0025';
    v_found     BOOLEAN;
BEGIN
    v_found :=  Pkg_Get2.f_get_organization_2(p_row);
    IF  NOT v_found  THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de gestiuni '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.org_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    ELSE
        IF p_row.flag_sbu = 'N' THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => C_ERR_CODE ,
                 p_err_header        => 'Aceste coduri nu sunt coduri '
                                        ||' de gestiuni !!!',
                 p_err_detail        => NVL(p_row.org_code ,'???') ||' - '|| p_note ,
                 p_flag_immediate    => 'N'
            );
        END IF;
    END IF;
END;
/*********************************************************************************
    DDL: 21/04/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_chk_app_user(p_row IN OUT APP_USER%ROWTYPE,p_note     VARCHAR2 DEFAULT NULL)
IS
    C_ERR_CODE  VARCHAR2(100)   :=  'CHK_0025';
BEGIN
    IF NOT Pkg_Get2.f_get_app_user_2(p_row) THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => C_ERR_CODE ,
             p_err_header        => 'Aceste coduri de utilizator '
                                    ||' nu exista in baza de date !!!',
             p_err_detail        => NVL(p_row.user_code ,'???') ||' - '|| p_note ,
             p_flag_immediate    => 'N'
        );
    END IF;
END;



END;

/

/
