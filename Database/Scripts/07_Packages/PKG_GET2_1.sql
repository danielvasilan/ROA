--------------------------------------------------------
--  DDL for Package Body PKG_GET2
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_GET2" 
IS 
--------------------------------------------------------------------
FUNCTION f_get_acrec_header_2(p_row IN OUT ACREC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row ACREC_HEADER%ROWTYPE) IS  
                    SELECT * FROM ACREC_HEADER WHERE acrec_code = p_row.acrec_code;
    CURSOR          C_BLOCK (p_row ACREC_HEADER%ROWTYPE) IS  
                    SELECT * FROM ACREC_HEADER WHERE acrec_code = p_row.acrec_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_acrec_header_2(p_row IN OUT ACREC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_acrec_header_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_ac_account_2(p_row IN OUT AC_ACCOUNT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row AC_ACCOUNT%ROWTYPE) IS  
                    SELECT * FROM AC_ACCOUNT WHERE account_code = p_row.account_code;
    CURSOR          C_BLOCK (p_row AC_ACCOUNT%ROWTYPE) IS  
                    SELECT * FROM AC_ACCOUNT WHERE account_code = p_row.account_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_account_2(p_row IN OUT AC_ACCOUNT%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_ac_account_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_ac_document_2(p_row IN OUT AC_DOCUMENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row AC_DOCUMENT%ROWTYPE) IS  
                    SELECT * FROM AC_DOCUMENT WHERE doc_type = p_row.doc_type;
    CURSOR          C_BLOCK (p_row AC_DOCUMENT%ROWTYPE) IS  
                    SELECT * FROM AC_DOCUMENT WHERE doc_type = p_row.doc_type FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_document_2(p_row IN OUT AC_DOCUMENT%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_ac_document_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_ac_header_2(p_row IN OUT AC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row AC_HEADER%ROWTYPE) IS  
                    SELECT * FROM AC_HEADER WHERE doc_code = p_row.doc_code AND doc_type = p_row.doc_type AND doc_year = p_row.doc_year AND org_code = p_row.org_code;
    CURSOR          C_BLOCK (p_row AC_HEADER%ROWTYPE) IS  
                    SELECT * FROM AC_HEADER WHERE doc_code = p_row.doc_code AND doc_type = p_row.doc_type AND doc_year = p_row.doc_year AND org_code = p_row.org_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_header_2(p_row IN OUT AC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_ac_header_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_ac_period_2(p_row IN OUT AC_PERIOD%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row AC_PERIOD%ROWTYPE) IS  
                    SELECT * FROM AC_PERIOD WHERE period_code = p_row.period_code AND period_type = p_row.period_type;
    CURSOR          C_BLOCK (p_row AC_PERIOD%ROWTYPE) IS  
                    SELECT * FROM AC_PERIOD WHERE period_code = p_row.period_code AND period_type = p_row.period_type FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_period_2(p_row IN OUT AC_PERIOD%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_ac_period_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_app_doc_number_2(p_row IN OUT APP_DOC_NUMBER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row APP_DOC_NUMBER%ROWTYPE) IS  
                    SELECT * FROM APP_DOC_NUMBER WHERE doc_subtype = p_row.doc_subtype AND doc_type = p_row.doc_type AND num_year = p_row.num_year AND org_code = p_row.org_code;
    CURSOR          C_BLOCK (p_row APP_DOC_NUMBER%ROWTYPE) IS  
                    SELECT * FROM APP_DOC_NUMBER WHERE doc_subtype = p_row.doc_subtype AND doc_type = p_row.doc_type AND num_year = p_row.num_year AND org_code = p_row.org_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_doc_number_2(p_row IN OUT APP_DOC_NUMBER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_app_doc_number_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_app_securitem_2(p_row IN OUT APP_SECURITEM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row APP_SECURITEM%ROWTYPE) IS  
                    SELECT * FROM APP_SECURITEM WHERE securitem_code = p_row.securitem_code;
    CURSOR          C_BLOCK (p_row APP_SECURITEM%ROWTYPE) IS  
                    SELECT * FROM APP_SECURITEM WHERE securitem_code = p_row.securitem_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_securitem_2(p_row IN OUT APP_SECURITEM%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_app_securitem_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_app_user_2(p_row IN OUT APP_USER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row APP_USER%ROWTYPE) IS  
                    SELECT * FROM APP_USER WHERE user_code = p_row.user_code;
    CURSOR          C_BLOCK (p_row APP_USER%ROWTYPE) IS  
                    SELECT * FROM APP_USER WHERE user_code = p_row.user_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_user_2(p_row IN OUT APP_USER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_app_user_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_app_user_grant_2(p_row IN OUT APP_USER_GRANT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row APP_USER_GRANT%ROWTYPE) IS  
                    SELECT * FROM APP_USER_GRANT WHERE securitem_code = p_row.securitem_code AND user_code = p_row.user_code;
    CURSOR          C_BLOCK (p_row APP_USER_GRANT%ROWTYPE) IS  
                    SELECT * FROM APP_USER_GRANT WHERE securitem_code = p_row.securitem_code AND user_code = p_row.user_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_user_grant_2(p_row IN OUT APP_USER_GRANT%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_app_user_grant_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_bom_std_2(p_row IN OUT BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row BOM_STD%ROWTYPE) IS  
                    SELECT * FROM BOM_STD WHERE child_code = p_row.child_code AND colour_code = p_row.colour_code AND father_code = p_row.father_code AND org_code = p_row.org_code;
    CURSOR          C_BLOCK (p_row BOM_STD%ROWTYPE) IS  
                    SELECT * FROM BOM_STD WHERE child_code = p_row.child_code AND colour_code = p_row.colour_code AND father_code = p_row.father_code AND org_code = p_row.org_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_bom_std_2(p_row IN OUT BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_bom_std_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_calendar_2(p_row IN OUT CALENDAR%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row CALENDAR%ROWTYPE) IS  
                    SELECT * FROM CALENDAR WHERE calendar_day = p_row.calendar_day;
    CURSOR          C_BLOCK (p_row CALENDAR%ROWTYPE) IS  
                    SELECT * FROM CALENDAR WHERE calendar_day = p_row.calendar_day FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_calendar_2(p_row IN OUT CALENDAR%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_calendar_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_cat_mat_type_2(p_row IN OUT CAT_MAT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row CAT_MAT_TYPE%ROWTYPE) IS  
                    SELECT * FROM CAT_MAT_TYPE WHERE categ_code = p_row.categ_code;
    CURSOR          C_BLOCK (p_row CAT_MAT_TYPE%ROWTYPE) IS  
                    SELECT * FROM CAT_MAT_TYPE WHERE categ_code = p_row.categ_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_cat_mat_type_2(p_row IN OUT CAT_MAT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_cat_mat_type_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_colour_2(p_row IN OUT COLOUR%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row COLOUR%ROWTYPE) IS  
                    SELECT * FROM COLOUR WHERE colour_code = p_row.colour_code AND org_code = p_row.org_code;
    CURSOR          C_BLOCK (p_row COLOUR%ROWTYPE) IS  
                    SELECT * FROM COLOUR WHERE colour_code = p_row.colour_code AND org_code = p_row.org_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_colour_2(p_row IN OUT COLOUR%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_colour_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_costcenter_2(p_row IN OUT COSTCENTER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row COSTCENTER%ROWTYPE) IS  
                    SELECT * FROM COSTCENTER WHERE costcenter_code = p_row.costcenter_code;
    CURSOR          C_BLOCK (p_row COSTCENTER%ROWTYPE) IS  
                    SELECT * FROM COSTCENTER WHERE costcenter_code = p_row.costcenter_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_costcenter_2(p_row IN OUT COSTCENTER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_costcenter_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_cost_type_2(p_row IN OUT COST_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row COST_TYPE%ROWTYPE) IS  
                    SELECT * FROM COST_TYPE WHERE cost_code = p_row.cost_code;
    CURSOR          C_BLOCK (p_row COST_TYPE%ROWTYPE) IS  
                    SELECT * FROM COST_TYPE WHERE cost_code = p_row.cost_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_cost_type_2(p_row IN OUT COST_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_cost_type_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_country_2(p_row IN OUT COUNTRY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row COUNTRY%ROWTYPE) IS  
                    SELECT * FROM COUNTRY WHERE country_code = p_row.country_code;
    CURSOR          C_BLOCK (p_row COUNTRY%ROWTYPE) IS  
                    SELECT * FROM COUNTRY WHERE country_code = p_row.country_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_country_2(p_row IN OUT COUNTRY%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_country_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_currency_2(p_row IN OUT CURRENCY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row CURRENCY%ROWTYPE) IS  
                    SELECT * FROM CURRENCY WHERE currency_code = p_row.currency_code;
    CURSOR          C_BLOCK (p_row CURRENCY%ROWTYPE) IS  
                    SELECT * FROM CURRENCY WHERE currency_code = p_row.currency_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_currency_2(p_row IN OUT CURRENCY%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_currency_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_currency_rate_2(p_row IN OUT CURRENCY_RATE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row CURRENCY_RATE%ROWTYPE) IS  
                    SELECT * FROM CURRENCY_RATE WHERE calendar_day = p_row.calendar_day AND currency_from = p_row.currency_from AND currency_to = p_row.currency_to;
    CURSOR          C_BLOCK (p_row CURRENCY_RATE%ROWTYPE) IS  
                    SELECT * FROM CURRENCY_RATE WHERE calendar_day = p_row.calendar_day AND currency_from = p_row.currency_from AND currency_to = p_row.currency_to FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_currency_rate_2(p_row IN OUT CURRENCY_RATE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_currency_rate_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_custom_2(p_row IN OUT CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row CUSTOM%ROWTYPE) IS  
                    SELECT * FROM CUSTOM WHERE custom_code = p_row.custom_code;
    CURSOR          C_BLOCK (p_row CUSTOM%ROWTYPE) IS  
                    SELECT * FROM CUSTOM WHERE custom_code = p_row.custom_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_custom_2(p_row IN OUT CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_custom_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_delivery_condition_2(p_row IN OUT DELIVERY_CONDITION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row DELIVERY_CONDITION%ROWTYPE) IS  
                    SELECT * FROM DELIVERY_CONDITION WHERE deliv_cond_code = p_row.deliv_cond_code;
    CURSOR          C_BLOCK (p_row DELIVERY_CONDITION%ROWTYPE) IS  
                    SELECT * FROM DELIVERY_CONDITION WHERE deliv_cond_code = p_row.deliv_cond_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_delivery_condition_2(p_row IN OUT DELIVERY_CONDITION%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_delivery_condition_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_fa_trn_type_2(p_row IN OUT FA_TRN_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row FA_TRN_TYPE%ROWTYPE) IS  
                    SELECT * FROM FA_TRN_TYPE WHERE trn_type = p_row.trn_type;
    CURSOR          C_BLOCK (p_row FA_TRN_TYPE%ROWTYPE) IS  
                    SELECT * FROM FA_TRN_TYPE WHERE trn_type = p_row.trn_type FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fa_trn_type_2(p_row IN OUT FA_TRN_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_fa_trn_type_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_fixed_asset_2(p_row IN OUT FIXED_ASSET%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row FIXED_ASSET%ROWTYPE) IS  
                    SELECT * FROM FIXED_ASSET WHERE fa_code = p_row.fa_code;
    CURSOR          C_BLOCK (p_row FIXED_ASSET%ROWTYPE) IS  
                    SELECT * FROM FIXED_ASSET WHERE fa_code = p_row.fa_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fixed_asset_2(p_row IN OUT FIXED_ASSET%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_fixed_asset_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_fixed_asset_categ_2(p_row IN OUT FIXED_ASSET_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row FIXED_ASSET_CATEG%ROWTYPE) IS  
                    SELECT * FROM FIXED_ASSET_CATEG WHERE category_code = p_row.category_code;
    CURSOR          C_BLOCK (p_row FIXED_ASSET_CATEG%ROWTYPE) IS  
                    SELECT * FROM FIXED_ASSET_CATEG WHERE category_code = p_row.category_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fixed_asset_categ_2(p_row IN OUT FIXED_ASSET_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_fixed_asset_categ_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_inventory_setup_2(p_row IN OUT INVENTORY_SETUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row INVENTORY_SETUP%ROWTYPE) IS  
                    SELECT * FROM INVENTORY_SETUP WHERE attr_code = p_row.attr_code AND ref_inventory = p_row.ref_inventory;
    CURSOR          C_BLOCK (p_row INVENTORY_SETUP%ROWTYPE) IS  
                    SELECT * FROM INVENTORY_SETUP WHERE attr_code = p_row.attr_code AND ref_inventory = p_row.ref_inventory FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_inventory_setup_2(p_row IN OUT INVENTORY_SETUP%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_inventory_setup_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_item_2(p_row IN OUT ITEM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row ITEM%ROWTYPE) IS  
                    SELECT * FROM ITEM WHERE item_code = p_row.item_code AND org_code = p_row.org_code;
    CURSOR          C_BLOCK (p_row ITEM%ROWTYPE) IS  
                    SELECT * FROM ITEM WHERE item_code = p_row.item_code AND org_code = p_row.org_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_2(p_row IN OUT ITEM%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_item_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_item_size_2(p_row IN OUT ITEM_SIZE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row ITEM_SIZE%ROWTYPE) IS  
                    SELECT * FROM ITEM_SIZE WHERE size_code = p_row.size_code;
    CURSOR          C_BLOCK (p_row ITEM_SIZE%ROWTYPE) IS  
                    SELECT * FROM ITEM_SIZE WHERE size_code = p_row.size_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_size_2(p_row IN OUT ITEM_SIZE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_item_size_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_item_type_2(p_row IN OUT ITEM_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row ITEM_TYPE%ROWTYPE) IS  
                    SELECT * FROM ITEM_TYPE WHERE type_code = p_row.type_code;
    CURSOR          C_BLOCK (p_row ITEM_TYPE%ROWTYPE) IS  
                    SELECT * FROM ITEM_TYPE WHERE type_code = p_row.type_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_type_2(p_row IN OUT ITEM_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_item_type_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_macrorouting_header_2(p_row IN OUT MACROROUTING_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row MACROROUTING_HEADER%ROWTYPE) IS  
                    SELECT * FROM MACROROUTING_HEADER WHERE routing_code = p_row.routing_code;
    CURSOR          C_BLOCK (p_row MACROROUTING_HEADER%ROWTYPE) IS  
                    SELECT * FROM MACROROUTING_HEADER WHERE routing_code = p_row.routing_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_macrorouting_header_2(p_row IN OUT MACROROUTING_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_macrorouting_header_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_movement_type_2(p_row IN OUT MOVEMENT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row MOVEMENT_TYPE%ROWTYPE) IS  
                    SELECT * FROM MOVEMENT_TYPE WHERE trn_type = p_row.trn_type;
    CURSOR          C_BLOCK (p_row MOVEMENT_TYPE%ROWTYPE) IS  
                    SELECT * FROM MOVEMENT_TYPE WHERE trn_type = p_row.trn_type FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_movement_type_2(p_row IN OUT MOVEMENT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_movement_type_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_operation_2(p_row IN OUT OPERATION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row OPERATION%ROWTYPE) IS  
                    SELECT * FROM OPERATION WHERE oper_code = p_row.oper_code;
    CURSOR          C_BLOCK (p_row OPERATION%ROWTYPE) IS  
                    SELECT * FROM OPERATION WHERE oper_code = p_row.oper_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_operation_2(p_row IN OUT OPERATION%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_operation_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_organization_2(p_row IN OUT ORGANIZATION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row ORGANIZATION%ROWTYPE) IS  
                    SELECT * FROM ORGANIZATION WHERE org_code = p_row.org_code;
    CURSOR          C_BLOCK (p_row ORGANIZATION%ROWTYPE) IS  
                    SELECT * FROM ORGANIZATION WHERE org_code = p_row.org_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_organization_2(p_row IN OUT ORGANIZATION%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_organization_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_organization_loc_2(p_row IN OUT ORGANIZATION_LOC%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row ORGANIZATION_LOC%ROWTYPE) IS  
                    SELECT * FROM ORGANIZATION_LOC WHERE loc_code = p_row.loc_code AND org_code = p_row.org_code;
    CURSOR          C_BLOCK (p_row ORGANIZATION_LOC%ROWTYPE) IS  
                    SELECT * FROM ORGANIZATION_LOC WHERE loc_code = p_row.loc_code AND org_code = p_row.org_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_organization_loc_2(p_row IN OUT ORGANIZATION_LOC%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_organization_loc_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_package_header_2(p_row IN OUT PACKAGE_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row PACKAGE_HEADER%ROWTYPE) IS  
                    SELECT * FROM PACKAGE_HEADER WHERE package_code = p_row.package_code;
    CURSOR          C_BLOCK (p_row PACKAGE_HEADER%ROWTYPE) IS  
                    SELECT * FROM PACKAGE_HEADER WHERE package_code = p_row.package_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_package_header_2(p_row IN OUT PACKAGE_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_package_header_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_patch_header_2(p_row IN OUT PATCH_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row PATCH_HEADER%ROWTYPE) IS  
                    SELECT * FROM PATCH_HEADER WHERE patch_code = p_row.patch_code;
    CURSOR          C_BLOCK (p_row PATCH_HEADER%ROWTYPE) IS  
                    SELECT * FROM PATCH_HEADER WHERE patch_code = p_row.patch_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_patch_header_2(p_row IN OUT PATCH_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_patch_header_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_po_ord_header_2(p_row IN OUT PO_ORD_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row PO_ORD_HEADER%ROWTYPE) IS  
                    SELECT * FROM PO_ORD_HEADER WHERE po_code = p_row.po_code;
    CURSOR          C_BLOCK (p_row PO_ORD_HEADER%ROWTYPE) IS  
                    SELECT * FROM PO_ORD_HEADER WHERE po_code = p_row.po_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_po_ord_header_2(p_row IN OUT PO_ORD_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_po_ord_header_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_primary_uom_2(p_row IN OUT PRIMARY_UOM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row PRIMARY_UOM%ROWTYPE) IS  
                    SELECT * FROM PRIMARY_UOM WHERE puom = p_row.puom;
    CURSOR          C_BLOCK (p_row PRIMARY_UOM%ROWTYPE) IS  
                    SELECT * FROM PRIMARY_UOM WHERE puom = p_row.puom FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_primary_uom_2(p_row IN OUT PRIMARY_UOM%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_primary_uom_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_sales_family_2(p_row IN OUT SALES_FAMILY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row SALES_FAMILY%ROWTYPE) IS  
                    SELECT * FROM SALES_FAMILY WHERE family_code = p_row.family_code;
    CURSOR          C_BLOCK (p_row SALES_FAMILY%ROWTYPE) IS  
                    SELECT * FROM SALES_FAMILY WHERE family_code = p_row.family_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_sales_family_2(p_row IN OUT SALES_FAMILY%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_sales_family_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_setup_acrec_2(p_row IN OUT SETUP_ACREC%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row SETUP_ACREC%ROWTYPE) IS  
                    SELECT * FROM SETUP_ACREC WHERE acrec_type = p_row.acrec_type;
    CURSOR          C_BLOCK (p_row SETUP_ACREC%ROWTYPE) IS  
                    SELECT * FROM SETUP_ACREC WHERE acrec_type = p_row.acrec_type FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_setup_acrec_2(p_row IN OUT SETUP_ACREC%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_setup_acrec_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_setup_receipt_2(p_row IN OUT SETUP_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row SETUP_RECEIPT%ROWTYPE) IS  
                    SELECT * FROM SETUP_RECEIPT WHERE receipt_type = p_row.receipt_type;
    CURSOR          C_BLOCK (p_row SETUP_RECEIPT%ROWTYPE) IS  
                    SELECT * FROM SETUP_RECEIPT WHERE receipt_type = p_row.receipt_type FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_setup_receipt_2(p_row IN OUT SETUP_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_setup_receipt_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_setup_shipment_2(p_row IN OUT SETUP_SHIPMENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row SETUP_SHIPMENT%ROWTYPE) IS  
                    SELECT * FROM SETUP_SHIPMENT WHERE ship_type = p_row.ship_type;
    CURSOR          C_BLOCK (p_row SETUP_SHIPMENT%ROWTYPE) IS  
                    SELECT * FROM SETUP_SHIPMENT WHERE ship_type = p_row.ship_type FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_setup_shipment_2(p_row IN OUT SETUP_SHIPMENT%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_setup_shipment_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_shipment_header_2(p_row IN OUT SHIPMENT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row SHIPMENT_HEADER%ROWTYPE) IS  
                    SELECT * FROM SHIPMENT_HEADER WHERE ship_code = p_row.ship_code;
    CURSOR          C_BLOCK (p_row SHIPMENT_HEADER%ROWTYPE) IS  
                    SELECT * FROM SHIPMENT_HEADER WHERE ship_code = p_row.ship_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_shipment_header_2(p_row IN OUT SHIPMENT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_shipment_header_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_shipment_package_2(p_row IN OUT SHIPMENT_PACKAGE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row SHIPMENT_PACKAGE%ROWTYPE) IS  
                    SELECT * FROM SHIPMENT_PACKAGE WHERE ref_shipment = p_row.ref_shipment AND seq_no = p_row.seq_no;
    CURSOR          C_BLOCK (p_row SHIPMENT_PACKAGE%ROWTYPE) IS  
                    SELECT * FROM SHIPMENT_PACKAGE WHERE ref_shipment = p_row.ref_shipment AND seq_no = p_row.seq_no FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_shipment_package_2(p_row IN OUT SHIPMENT_PACKAGE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_shipment_package_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_teh_variable_2(p_row IN OUT TEH_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row TEH_VARIABLE%ROWTYPE) IS  
                    SELECT * FROM TEH_VARIABLE WHERE org_code = p_row.org_code AND var_code = p_row.var_code;
    CURSOR          C_BLOCK (p_row TEH_VARIABLE%ROWTYPE) IS  
                    SELECT * FROM TEH_VARIABLE WHERE org_code = p_row.org_code AND var_code = p_row.var_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_teh_variable_2(p_row IN OUT TEH_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_teh_variable_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_trn_plan_header_2(p_row IN OUT TRN_PLAN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row TRN_PLAN_HEADER%ROWTYPE) IS  
                    SELECT * FROM TRN_PLAN_HEADER WHERE plan_code = p_row.plan_code;
    CURSOR          C_BLOCK (p_row TRN_PLAN_HEADER%ROWTYPE) IS  
                    SELECT * FROM TRN_PLAN_HEADER WHERE plan_code = p_row.plan_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_trn_plan_header_2(p_row IN OUT TRN_PLAN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_trn_plan_header_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_value_ad_tax_2(p_row IN OUT VALUE_AD_TAX%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row VALUE_AD_TAX%ROWTYPE) IS  
                    SELECT * FROM VALUE_AD_TAX WHERE vat_code = p_row.vat_code;
    CURSOR          C_BLOCK (p_row VALUE_AD_TAX%ROWTYPE) IS  
                    SELECT * FROM VALUE_AD_TAX WHERE vat_code = p_row.vat_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_value_ad_tax_2(p_row IN OUT VALUE_AD_TAX%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_value_ad_tax_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_warehouse_2(p_row IN OUT WAREHOUSE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row WAREHOUSE%ROWTYPE) IS  
                    SELECT * FROM WAREHOUSE WHERE whs_code = p_row.whs_code;
    CURSOR          C_BLOCK (p_row WAREHOUSE%ROWTYPE) IS  
                    SELECT * FROM WAREHOUSE WHERE whs_code = p_row.whs_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_warehouse_2(p_row IN OUT WAREHOUSE%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_warehouse_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_warehouse_categ_2(p_row IN OUT WAREHOUSE_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row WAREHOUSE_CATEG%ROWTYPE) IS  
                    SELECT * FROM WAREHOUSE_CATEG WHERE category_code = p_row.category_code;
    CURSOR          C_BLOCK (p_row WAREHOUSE_CATEG%ROWTYPE) IS  
                    SELECT * FROM WAREHOUSE_CATEG WHERE category_code = p_row.category_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_warehouse_categ_2(p_row IN OUT WAREHOUSE_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_warehouse_categ_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_whs_trn_reason_2(p_row IN OUT WHS_TRN_REASON%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row WHS_TRN_REASON%ROWTYPE) IS  
                    SELECT * FROM WHS_TRN_REASON WHERE reason_code = p_row.reason_code;
    CURSOR          C_BLOCK (p_row WHS_TRN_REASON%ROWTYPE) IS  
                    SELECT * FROM WHS_TRN_REASON WHERE reason_code = p_row.reason_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_whs_trn_reason_2(p_row IN OUT WHS_TRN_REASON%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_whs_trn_reason_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_workcenter_2(p_row IN OUT WORKCENTER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row WORKCENTER%ROWTYPE) IS  
                    SELECT * FROM WORKCENTER WHERE workcenter_code = p_row.workcenter_code;
    CURSOR          C_BLOCK (p_row WORKCENTER%ROWTYPE) IS  
                    SELECT * FROM WORKCENTER WHERE workcenter_code = p_row.workcenter_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_workcenter_2(p_row IN OUT WORKCENTER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_workcenter_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_work_group_2(p_row IN OUT WORK_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row WORK_GROUP%ROWTYPE) IS  
                    SELECT * FROM WORK_GROUP WHERE group_code = p_row.group_code;
    CURSOR          C_BLOCK (p_row WORK_GROUP%ROWTYPE) IS  
                    SELECT * FROM WORK_GROUP WHERE group_code = p_row.group_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_work_group_2(p_row IN OUT WORK_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_work_group_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_work_order_2(p_row IN OUT WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row WORK_ORDER%ROWTYPE) IS  
                    SELECT * FROM WORK_ORDER WHERE order_code = p_row.order_code AND org_code = p_row.org_code;
    CURSOR          C_BLOCK (p_row WORK_ORDER%ROWTYPE) IS  
                    SELECT * FROM WORK_ORDER WHERE order_code = p_row.order_code AND org_code = p_row.org_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_work_order_2(p_row IN OUT WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_work_order_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

--------------------------------------------------------------------
FUNCTION f_get_work_season_2(p_row IN OUT WORK_SEASON%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_row WORK_SEASON%ROWTYPE) IS  
                    SELECT * FROM WORK_SEASON WHERE org_code = p_row.org_code AND season_code = p_row.season_code;
    CURSOR          C_BLOCK (p_row WORK_SEASON%ROWTYPE) IS  
                    SELECT * FROM WORK_SEASON WHERE org_code = p_row.org_code AND season_code = p_row.season_code FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_work_season_2(p_row IN OUT WORK_SEASON%ROWTYPE, p_block INTEGER DEFAULT 0)
IS
    v_found         BOOLEAN;
BEGIN
    v_found :=  pkg_get2.f_get_work_season_2(p_row);
    IF NOT v_found THEN Pkg_Err.p_rae('Informatie negasita');
    END IF;
END;

END; 

/

/
