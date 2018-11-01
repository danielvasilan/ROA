--------------------------------------------------------
--  DDL for Package PKG_ENV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_ENV" 
IS

FUNCTION f_sql_app_doc_number                                RETURN typ_frm  pipelined;

FUNCTION f_get_app_doc_number                               (
                                                            p_org_code      VARCHAR2,
                                                            p_doc_type      VARCHAR2,
                                                            p_doc_subtype   VARCHAR2,
                                                            p_num_year      VARCHAR2
                                                            ) RETURN VARCHAR2;


PROCEDURE p_app_doc_number_iud                              (
                                                                p_tip   VARCHAR2, 
                                                                p_row   APP_DOC_NUMBER%ROWTYPE
                                                            );


PROCEDURE p_app_doc_number_blo                              (   p_tip  VARCHAR2, 
                                                                p_row   IN OUT APP_DOC_NUMBER%ROWTYPE
                                                            );


FUNCTION f_get_picture_path                                 (   p_org_code  VARCHAR2) RETURN VARCHAR2;


END;
 

/

/
