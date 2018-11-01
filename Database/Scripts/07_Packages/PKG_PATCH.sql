--------------------------------------------------------
--  DDL for Package PKG_PATCH
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_PATCH" 
AS


PROCEDURE p_extract_package                 (   p_patch_code        VARCHAR2,
                                                p_package_name      VARCHAR2);

PROCEDURE p_patch_header_iud                (   p_tip               VARCHAR2,
                                                p_row               PATCH_HEADER%ROWTYPE);


PROCEDURE p_apply_patch                     (   p_patch_code        VARCHAR2);

FUNCTION f_patch_info                       (   p_patch_code        VARCHAR2)
                                                RETURN              VARCHAR2;

PROCEDURE p_insert_patch                    (   p_patch_code        VARCHAR2,
                                                p_description       VARCHAR2);

PROCEDURE p_extract_script                  (   p_patch_code        VARCHAR2,
                                                p_script_text       VARCHAR2);


END;
 

/

/
