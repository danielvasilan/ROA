--------------------------------------------------------
--  DDL for Package Body PKG_GET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_GET" 
IS 
--------------------------------------------------------------------
FUNCTION f_get_acrec_detail(p_row IN OUT ACREC_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ACREC_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ACREC_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_acrec_detail(p_row IN OUT ACREC_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_acrec_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ACREC_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_acrec_header(p_row IN OUT ACREC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ACREC_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ACREC_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_acrec_header(p_row IN OUT ACREC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_acrec_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ACREC_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_ac_account(p_row IN OUT AC_ACCOUNT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_ACCOUNT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_ACCOUNT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_account(p_row IN OUT AC_ACCOUNT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_ac_account(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - AC_ACCOUNT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_ac_detail(p_row IN OUT AC_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_detail(p_row IN OUT AC_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_ac_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - AC_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_ac_document(p_row IN OUT AC_DOCUMENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_DOCUMENT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_DOCUMENT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_document(p_row IN OUT AC_DOCUMENT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_ac_document(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - AC_DOCUMENT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_ac_header(p_row IN OUT AC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_header(p_row IN OUT AC_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_ac_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - AC_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_ac_period(p_row IN OUT AC_PERIOD%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_PERIOD WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM AC_PERIOD WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_ac_period(p_row IN OUT AC_PERIOD%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_ac_period(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - AC_PERIOD');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_app_audit(p_row IN OUT APP_AUDIT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_AUDIT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_AUDIT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_audit(p_row IN OUT APP_AUDIT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_app_audit(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - APP_AUDIT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_app_doc_number(p_row IN OUT APP_DOC_NUMBER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_DOC_NUMBER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_DOC_NUMBER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_doc_number(p_row IN OUT APP_DOC_NUMBER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_app_doc_number(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - APP_DOC_NUMBER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_app_securitem(p_row IN OUT APP_SECURITEM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_SECURITEM WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_SECURITEM WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_securitem(p_row IN OUT APP_SECURITEM%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_app_securitem(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - APP_SECURITEM');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_app_task(p_row IN OUT APP_TASK%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_TASK WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_TASK WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_task(p_row IN OUT APP_TASK%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_app_task(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - APP_TASK');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_app_task_param(p_row IN OUT APP_TASK_PARAM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_TASK_PARAM WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_TASK_PARAM WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_task_param(p_row IN OUT APP_TASK_PARAM%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_app_task_param(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - APP_TASK_PARAM');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_app_task_step(p_row IN OUT APP_TASK_STEP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_TASK_STEP WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_TASK_STEP WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_task_step(p_row IN OUT APP_TASK_STEP%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_app_task_step(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - APP_TASK_STEP');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_app_user(p_row IN OUT APP_USER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_USER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_USER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_user(p_row IN OUT APP_USER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_app_user(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - APP_USER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_app_user_grant(p_row IN OUT APP_USER_GRANT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_USER_GRANT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM APP_USER_GRANT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_app_user_grant(p_row IN OUT APP_USER_GRANT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_app_user_grant(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - APP_USER_GRANT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_bom_group(p_row IN OUT BOM_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM BOM_GROUP WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM BOM_GROUP WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_bom_group(p_row IN OUT BOM_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_bom_group(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - BOM_GROUP');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_bom_std(p_row IN OUT BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM BOM_STD WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM BOM_STD WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_bom_std(p_row IN OUT BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_bom_std(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - BOM_STD');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_bom_wo(p_row IN OUT BOM_WO%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM BOM_WO WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM BOM_WO WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_bom_wo(p_row IN OUT BOM_WO%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_bom_wo(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - BOM_WO');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_calendar(p_row IN OUT CALENDAR%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CALENDAR WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CALENDAR WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_calendar(p_row IN OUT CALENDAR%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_calendar(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - CALENDAR');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_cat_custom(p_row IN OUT CAT_CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CAT_CUSTOM WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CAT_CUSTOM WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_cat_custom(p_row IN OUT CAT_CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_cat_custom(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - CAT_CUSTOM');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_cat_mat_type(p_row IN OUT CAT_MAT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CAT_MAT_TYPE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CAT_MAT_TYPE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_cat_mat_type(p_row IN OUT CAT_MAT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_cat_mat_type(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - CAT_MAT_TYPE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_colour(p_row IN OUT COLOUR%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COLOUR WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COLOUR WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_colour(p_row IN OUT COLOUR%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_colour(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - COLOUR');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_costcenter(p_row IN OUT COSTCENTER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COSTCENTER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COSTCENTER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_costcenter(p_row IN OUT COSTCENTER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_costcenter(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - COSTCENTER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_cost_detail(p_row IN OUT COST_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COST_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COST_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_cost_detail(p_row IN OUT COST_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_cost_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - COST_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_cost_header(p_row IN OUT COST_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COST_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COST_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_cost_header(p_row IN OUT COST_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_cost_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - COST_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_cost_type(p_row IN OUT COST_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COST_TYPE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COST_TYPE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_cost_type(p_row IN OUT COST_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_cost_type(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - COST_TYPE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_country(p_row IN OUT COUNTRY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COUNTRY WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM COUNTRY WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_country(p_row IN OUT COUNTRY%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_country(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - COUNTRY');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_currency(p_row IN OUT CURRENCY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CURRENCY WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CURRENCY WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_currency(p_row IN OUT CURRENCY%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_currency(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - CURRENCY');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_currency_rate(p_row IN OUT CURRENCY_RATE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CURRENCY_RATE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CURRENCY_RATE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_currency_rate(p_row IN OUT CURRENCY_RATE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_currency_rate(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - CURRENCY_RATE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_custom(p_row IN OUT CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CUSTOM WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM CUSTOM WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_custom(p_row IN OUT CUSTOM%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_custom(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - CUSTOM');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_delivery_condition(p_row IN OUT DELIVERY_CONDITION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM DELIVERY_CONDITION WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM DELIVERY_CONDITION WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_delivery_condition(p_row IN OUT DELIVERY_CONDITION%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_delivery_condition(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - DELIVERY_CONDITION');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_efficiency(p_row IN OUT EFFICIENCY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM EFFICIENCY WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM EFFICIENCY WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_efficiency(p_row IN OUT EFFICIENCY%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_efficiency(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - EFFICIENCY');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_fa_trn(p_row IN OUT FA_TRN%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FA_TRN WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FA_TRN WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fa_trn(p_row IN OUT FA_TRN%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_fa_trn(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - FA_TRN');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_fa_trn_type(p_row IN OUT FA_TRN_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FA_TRN_TYPE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FA_TRN_TYPE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fa_trn_type(p_row IN OUT FA_TRN_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_fa_trn_type(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - FA_TRN_TYPE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_fifo_exceding(p_row IN OUT FIFO_EXCEDING%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FIFO_EXCEDING WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FIFO_EXCEDING WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fifo_exceding(p_row IN OUT FIFO_EXCEDING%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_fifo_exceding(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - FIFO_EXCEDING');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_fifo_material(p_row IN OUT FIFO_MATERIAL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FIFO_MATERIAL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FIFO_MATERIAL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fifo_material(p_row IN OUT FIFO_MATERIAL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_fifo_material(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - FIFO_MATERIAL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_fixed_asset(p_row IN OUT FIXED_ASSET%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FIXED_ASSET WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FIXED_ASSET WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fixed_asset(p_row IN OUT FIXED_ASSET%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_fixed_asset(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - FIXED_ASSET');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_fixed_asset_categ(p_row IN OUT FIXED_ASSET_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FIXED_ASSET_CATEG WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM FIXED_ASSET_CATEG WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_fixed_asset_categ(p_row IN OUT FIXED_ASSET_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_fixed_asset_categ(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - FIXED_ASSET_CATEG');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_group_routing(p_row IN OUT GROUP_ROUTING%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM GROUP_ROUTING WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM GROUP_ROUTING WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_group_routing(p_row IN OUT GROUP_ROUTING%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_group_routing(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - GROUP_ROUTING');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_import_text_file(p_row IN OUT IMPORT_TEXT_FILE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM IMPORT_TEXT_FILE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM IMPORT_TEXT_FILE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_import_text_file(p_row IN OUT IMPORT_TEXT_FILE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_import_text_file(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - IMPORT_TEXT_FILE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_inventory(p_row IN OUT INVENTORY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM INVENTORY WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM INVENTORY WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_inventory(p_row IN OUT INVENTORY%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_inventory(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - INVENTORY');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_inventory_detail(p_row IN OUT INVENTORY_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM INVENTORY_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM INVENTORY_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_inventory_detail(p_row IN OUT INVENTORY_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_inventory_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - INVENTORY_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_inventory_setup(p_row IN OUT INVENTORY_SETUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM INVENTORY_SETUP WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM INVENTORY_SETUP WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_inventory_setup(p_row IN OUT INVENTORY_SETUP%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_inventory_setup(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - INVENTORY_SETUP');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_inventory_stoc(p_row IN OUT INVENTORY_STOC%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM INVENTORY_STOC WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM INVENTORY_STOC WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_inventory_stoc(p_row IN OUT INVENTORY_STOC%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_inventory_stoc(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - INVENTORY_STOC');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_item(p_row IN OUT ITEM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item(p_row IN OUT ITEM%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_item(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ITEM');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_item_cost(p_row IN OUT ITEM_COST%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_COST WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_COST WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_cost(p_row IN OUT ITEM_COST%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_item_cost(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ITEM_COST');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_item_cycle_time(p_row IN OUT ITEM_CYCLE_TIME%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_CYCLE_TIME WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_CYCLE_TIME WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_cycle_time(p_row IN OUT ITEM_CYCLE_TIME%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_item_cycle_time(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ITEM_CYCLE_TIME');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_item_mapping(p_row IN OUT ITEM_MAPPING%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_MAPPING WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_MAPPING WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_mapping(p_row IN OUT ITEM_MAPPING%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_item_mapping(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ITEM_MAPPING');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_item_size(p_row IN OUT ITEM_SIZE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_SIZE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_SIZE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_size(p_row IN OUT ITEM_SIZE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_item_size(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ITEM_SIZE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_item_type(p_row IN OUT ITEM_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_TYPE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_TYPE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_type(p_row IN OUT ITEM_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_item_type(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ITEM_TYPE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_item_variable(p_row IN OUT ITEM_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_VARIABLE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ITEM_VARIABLE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_item_variable(p_row IN OUT ITEM_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_item_variable(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ITEM_VARIABLE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_line(p_row IN OUT LINE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM LINE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM LINE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_line(p_row IN OUT LINE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_line(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - LINE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_macrorouting_detail(p_row IN OUT MACROROUTING_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM MACROROUTING_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM MACROROUTING_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_macrorouting_detail(p_row IN OUT MACROROUTING_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_macrorouting_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - MACROROUTING_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_macrorouting_header(p_row IN OUT MACROROUTING_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM MACROROUTING_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM MACROROUTING_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_macrorouting_header(p_row IN OUT MACROROUTING_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_macrorouting_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - MACROROUTING_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_movement_type(p_row IN OUT MOVEMENT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM MOVEMENT_TYPE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM MOVEMENT_TYPE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_movement_type(p_row IN OUT MOVEMENT_TYPE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_movement_type(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - MOVEMENT_TYPE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_multi_table(p_row IN OUT MULTI_TABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM MULTI_TABLE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM MULTI_TABLE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_multi_table(p_row IN OUT MULTI_TABLE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_multi_table(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - MULTI_TABLE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_operation(p_row IN OUT OPERATION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM OPERATION WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM OPERATION WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_operation(p_row IN OUT OPERATION%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_operation(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - OPERATION');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_organization(p_row IN OUT ORGANIZATION%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ORGANIZATION WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ORGANIZATION WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_organization(p_row IN OUT ORGANIZATION%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_organization(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ORGANIZATION');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_organization_loc(p_row IN OUT ORGANIZATION_LOC%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ORGANIZATION_LOC WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM ORGANIZATION_LOC WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_organization_loc(p_row IN OUT ORGANIZATION_LOC%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_organization_loc(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - ORGANIZATION_LOC');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_package_detail(p_row IN OUT PACKAGE_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PACKAGE_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PACKAGE_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_package_detail(p_row IN OUT PACKAGE_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_package_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PACKAGE_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_package_header(p_row IN OUT PACKAGE_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PACKAGE_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PACKAGE_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_package_header(p_row IN OUT PACKAGE_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_package_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PACKAGE_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_package_trn_detail(p_row IN OUT PACKAGE_TRN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PACKAGE_TRN_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PACKAGE_TRN_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_package_trn_detail(p_row IN OUT PACKAGE_TRN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_package_trn_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PACKAGE_TRN_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_package_trn_header(p_row IN OUT PACKAGE_TRN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PACKAGE_TRN_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PACKAGE_TRN_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_package_trn_header(p_row IN OUT PACKAGE_TRN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_package_trn_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PACKAGE_TRN_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_parameter(p_row IN OUT PARAMETER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PARAMETER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PARAMETER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_parameter(p_row IN OUT PARAMETER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_parameter(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PARAMETER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_parameter_attr(p_row IN OUT PARAMETER_ATTR%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PARAMETER_ATTR WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PARAMETER_ATTR WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_parameter_attr(p_row IN OUT PARAMETER_ATTR%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_parameter_attr(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PARAMETER_ATTR');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_parameter_code(p_row IN OUT PARAMETER_CODE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PARAMETER_CODE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PARAMETER_CODE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_parameter_code(p_row IN OUT PARAMETER_CODE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_parameter_code(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PARAMETER_CODE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_patch_detail(p_row IN OUT PATCH_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PATCH_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PATCH_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_patch_detail(p_row IN OUT PATCH_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_patch_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PATCH_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_patch_header(p_row IN OUT PATCH_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PATCH_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PATCH_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_patch_header(p_row IN OUT PATCH_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_patch_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PATCH_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_po_ord_header(p_row IN OUT PO_ORD_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PO_ORD_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PO_ORD_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_po_ord_header(p_row IN OUT PO_ORD_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_po_ord_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PO_ORD_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_po_ord_line(p_row IN OUT PO_ORD_LINE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PO_ORD_LINE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PO_ORD_LINE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_po_ord_line(p_row IN OUT PO_ORD_LINE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_po_ord_line(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PO_ORD_LINE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_price_list(p_row IN OUT PRICE_LIST%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PRICE_LIST WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PRICE_LIST WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_price_list(p_row IN OUT PRICE_LIST%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_price_list(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PRICE_LIST');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_price_list_sales(p_row IN OUT PRICE_LIST_SALES%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PRICE_LIST_SALES WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PRICE_LIST_SALES WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_price_list_sales(p_row IN OUT PRICE_LIST_SALES%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_price_list_sales(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PRICE_LIST_SALES');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_primary_uom(p_row IN OUT PRIMARY_UOM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PRIMARY_UOM WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM PRIMARY_UOM WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_primary_uom(p_row IN OUT PRIMARY_UOM%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_primary_uom(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - PRIMARY_UOM');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_receipt_detail(p_row IN OUT RECEIPT_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM RECEIPT_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM RECEIPT_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_receipt_detail(p_row IN OUT RECEIPT_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_receipt_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - RECEIPT_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_receipt_header(p_row IN OUT RECEIPT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM RECEIPT_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM RECEIPT_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_receipt_header(p_row IN OUT RECEIPT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_receipt_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - RECEIPT_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_reports(p_row IN OUT REPORTS%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM REPORTS WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM REPORTS WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_reports(p_row IN OUT REPORTS%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_reports(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - REPORTS');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_reports_category(p_row IN OUT REPORTS_CATEGORY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM REPORTS_CATEGORY WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM REPORTS_CATEGORY WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_reports_category(p_row IN OUT REPORTS_CATEGORY%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_reports_category(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - REPORTS_CATEGORY');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_reports_parameter(p_row IN OUT REPORTS_PARAMETER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM REPORTS_PARAMETER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM REPORTS_PARAMETER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_reports_parameter(p_row IN OUT REPORTS_PARAMETER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_reports_parameter(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - REPORTS_PARAMETER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_sales_family(p_row IN OUT SALES_FAMILY%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SALES_FAMILY WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SALES_FAMILY WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_sales_family(p_row IN OUT SALES_FAMILY%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_sales_family(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SALES_FAMILY');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_sales_order(p_row IN OUT SALES_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SALES_ORDER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SALES_ORDER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_sales_order(p_row IN OUT SALES_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_sales_order(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SALES_ORDER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_scan_event(p_row IN OUT SCAN_EVENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SCAN_EVENT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SCAN_EVENT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_scan_event(p_row IN OUT SCAN_EVENT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_scan_event(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SCAN_EVENT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_setup_acrec(p_row IN OUT SETUP_ACREC%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SETUP_ACREC WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SETUP_ACREC WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_setup_acrec(p_row IN OUT SETUP_ACREC%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_setup_acrec(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SETUP_ACREC');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_setup_movement(p_row IN OUT SETUP_MOVEMENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SETUP_MOVEMENT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SETUP_MOVEMENT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_setup_movement(p_row IN OUT SETUP_MOVEMENT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_setup_movement(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SETUP_MOVEMENT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_setup_receipt(p_row IN OUT SETUP_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SETUP_RECEIPT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SETUP_RECEIPT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_setup_receipt(p_row IN OUT SETUP_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_setup_receipt(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SETUP_RECEIPT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_setup_shipment(p_row IN OUT SETUP_SHIPMENT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SETUP_SHIPMENT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SETUP_SHIPMENT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_setup_shipment(p_row IN OUT SETUP_SHIPMENT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_setup_shipment(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SETUP_SHIPMENT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_shipment_detail(p_row IN OUT SHIPMENT_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SHIPMENT_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SHIPMENT_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_shipment_detail(p_row IN OUT SHIPMENT_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_shipment_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SHIPMENT_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_shipment_header(p_row IN OUT SHIPMENT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SHIPMENT_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SHIPMENT_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_shipment_header(p_row IN OUT SHIPMENT_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_shipment_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SHIPMENT_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_shipment_order(p_row IN OUT SHIPMENT_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SHIPMENT_ORDER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SHIPMENT_ORDER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_shipment_order(p_row IN OUT SHIPMENT_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_shipment_order(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SHIPMENT_ORDER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_shipment_package(p_row IN OUT SHIPMENT_PACKAGE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SHIPMENT_PACKAGE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SHIPMENT_PACKAGE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_shipment_package(p_row IN OUT SHIPMENT_PACKAGE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_shipment_package(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SHIPMENT_PACKAGE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_so_detail(p_row IN OUT SO_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SO_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM SO_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_so_detail(p_row IN OUT SO_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_so_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - SO_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_stg_bom_std(p_row IN OUT STG_BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_BOM_STD WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_BOM_STD WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_stg_bom_std(p_row IN OUT STG_BOM_STD%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_stg_bom_std(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - STG_BOM_STD');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_stg_file_manager(p_row IN OUT STG_FILE_MANAGER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_FILE_MANAGER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_FILE_MANAGER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_stg_file_manager(p_row IN OUT STG_FILE_MANAGER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_stg_file_manager(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - STG_FILE_MANAGER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_stg_item(p_row IN OUT STG_ITEM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_ITEM WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_ITEM WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_stg_item(p_row IN OUT STG_ITEM%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_stg_item(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - STG_ITEM');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_stg_parser(p_row IN OUT STG_PARSER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_PARSER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_PARSER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_stg_parser(p_row IN OUT STG_PARSER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_stg_parser(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - STG_PARSER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_stg_receipt(p_row IN OUT STG_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_RECEIPT WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_RECEIPT WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_stg_receipt(p_row IN OUT STG_RECEIPT%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_stg_receipt(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - STG_RECEIPT');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_stg_ship_fifo(p_row IN OUT STG_SHIP_FIFO%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_SHIP_FIFO WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_SHIP_FIFO WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_stg_ship_fifo(p_row IN OUT STG_SHIP_FIFO%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_stg_ship_fifo(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - STG_SHIP_FIFO');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_stg_work_order(p_row IN OUT STG_WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_WORK_ORDER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_WORK_ORDER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_stg_work_order(p_row IN OUT STG_WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_stg_work_order(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - STG_WORK_ORDER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_stg_wo_decl(p_row IN OUT STG_WO_DECL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_WO_DECL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM STG_WO_DECL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_stg_wo_decl(p_row IN OUT STG_WO_DECL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_stg_wo_decl(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - STG_WO_DECL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_teh_variable(p_row IN OUT TEH_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM TEH_VARIABLE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM TEH_VARIABLE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_teh_variable(p_row IN OUT TEH_VARIABLE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_teh_variable(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - TEH_VARIABLE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_trn_plan_detail(p_row IN OUT TRN_PLAN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM TRN_PLAN_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM TRN_PLAN_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_trn_plan_detail(p_row IN OUT TRN_PLAN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_trn_plan_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - TRN_PLAN_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_trn_plan_header(p_row IN OUT TRN_PLAN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM TRN_PLAN_HEADER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM TRN_PLAN_HEADER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_trn_plan_header(p_row IN OUT TRN_PLAN_HEADER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_trn_plan_header(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - TRN_PLAN_HEADER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_value_ad_tax(p_row IN OUT VALUE_AD_TAX%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM VALUE_AD_TAX WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM VALUE_AD_TAX WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_value_ad_tax(p_row IN OUT VALUE_AD_TAX%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_value_ad_tax(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - VALUE_AD_TAX');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_virtual_table(p_row IN OUT VIRTUAL_TABLE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM VIRTUAL_TABLE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM VIRTUAL_TABLE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_virtual_table(p_row IN OUT VIRTUAL_TABLE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_virtual_table(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - VIRTUAL_TABLE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_vw_prep_pick_plan(p_row IN OUT VW_PREP_PICK_PLAN%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM VW_PREP_PICK_PLAN WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM VW_PREP_PICK_PLAN WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_vw_prep_pick_plan(p_row IN OUT VW_PREP_PICK_PLAN%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_vw_prep_pick_plan(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - VW_PREP_PICK_PLAN');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_warehouse(p_row IN OUT WAREHOUSE%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WAREHOUSE WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WAREHOUSE WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_warehouse(p_row IN OUT WAREHOUSE%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_warehouse(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WAREHOUSE');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_warehouse_categ(p_row IN OUT WAREHOUSE_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WAREHOUSE_CATEG WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WAREHOUSE_CATEG WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_warehouse_categ(p_row IN OUT WAREHOUSE_CATEG%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_warehouse_categ(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WAREHOUSE_CATEG');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_web_grid_cm(p_row IN OUT WEB_GRID_CM%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WEB_GRID_CM WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WEB_GRID_CM WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_web_grid_cm(p_row IN OUT WEB_GRID_CM%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_web_grid_cm(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WEB_GRID_CM');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_whs_trn(p_row IN OUT WHS_TRN%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WHS_TRN WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WHS_TRN WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_whs_trn(p_row IN OUT WHS_TRN%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_whs_trn(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WHS_TRN');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_whs_trn_detail(p_row IN OUT WHS_TRN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WHS_TRN_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WHS_TRN_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_whs_trn_detail(p_row IN OUT WHS_TRN_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_whs_trn_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WHS_TRN_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_whs_trn_reason(p_row IN OUT WHS_TRN_REASON%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WHS_TRN_REASON WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WHS_TRN_REASON WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_whs_trn_reason(p_row IN OUT WHS_TRN_REASON%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_whs_trn_reason(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WHS_TRN_REASON');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_wiz_control(p_row IN OUT WIZ_CONTROL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WIZ_CONTROL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WIZ_CONTROL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_wiz_control(p_row IN OUT WIZ_CONTROL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_wiz_control(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WIZ_CONTROL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_workcenter(p_row IN OUT WORKCENTER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORKCENTER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORKCENTER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_workcenter(p_row IN OUT WORKCENTER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_workcenter(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WORKCENTER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_workcenter_oper(p_row IN OUT WORKCENTER_OPER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORKCENTER_OPER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORKCENTER_OPER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_workcenter_oper(p_row IN OUT WORKCENTER_OPER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_workcenter_oper(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WORKCENTER_OPER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_work_group(p_row IN OUT WORK_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORK_GROUP WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORK_GROUP WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_work_group(p_row IN OUT WORK_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_work_group(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WORK_GROUP');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_work_order(p_row IN OUT WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORK_ORDER WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORK_ORDER WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_work_order(p_row IN OUT WORK_ORDER%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_work_order(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WORK_ORDER');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_work_season(p_row IN OUT WORK_SEASON%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORK_SEASON WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WORK_SEASON WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_work_season(p_row IN OUT WORK_SEASON%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_work_season(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WORK_SEASON');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_wo_detail(p_row IN OUT WO_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WO_DETAIL WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WO_DETAIL WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_wo_detail(p_row IN OUT WO_DETAIL%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_wo_detail(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WO_DETAIL');
    END IF;
END;
--------------------------------------------------------------------
FUNCTION f_get_wo_group(p_row IN OUT WO_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) RETURN BOOLEAN
IS
    CURSOR          C_NO_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WO_GROUP WHERE IDRIGA = p_idriga;
    CURSOR          C_BLOCK (p_idriga INTEGER) IS  
                    SELECT * FROM WO_GROUP WHERE IDRIGA = p_idriga  FOR UPDATE;
    v_found         BOOLEAN;
BEGIN
    IF p_block = 0 THEN
        OPEN    C_NO_BLOCK(p_row.IDRIGA);
        FETCH   C_NO_BLOCK  INTO p_row;
        v_found := C_NO_BLOCK%FOUND;
        CLOSE   C_NO_BLOCK;
    ELSE
        OPEN    C_BLOCK(p_row.IDRIGA);
        FETCH   C_BLOCK  INTO p_row;
        v_found := C_BLOCK%FOUND;
        CLOSE   C_BLOCK;
    END IF;
    RETURN v_found;
END;

PROCEDURE p_get_wo_group(p_row IN OUT WO_GROUP%ROWTYPE, p_block INTEGER DEFAULT 0) 
IS
BEGIN 
    IF NOT Pkg_Get.f_get_wo_group(p_row, p_block) THEN
        Pkg_Lib.p_rae('Acest cod nu este definit in sistem: '||p_row.idriga||' - WO_GROUP');
    END IF;
END;
END; 

/

/
