--------------------------------------------------------
--  DDL for Package PKG_APP_SECUR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_APP_SECUR" 
AS

PROCEDURE p_login_user          (   p_user_code         VARCHAR2, 
                                    p_pwd               VARCHAR2);
PROCEDURE p_logout_user         ;

FUNCTION f_return_user              RETURN              VARCHAR2;
FUNCTION f_return_numeuser          RETURN              VARCHAR2;
FUNCTION f_return_menu              RETURN              VARCHAR2;

FUNCTION f_test_grant           (   p_securitem_code    VARCHAR2,
                                    p_flag              VARCHAR2,
                                    p_securitem_global  VARCHAR2
                                )   RETURN              INTEGER;

FUNCTION f_message_grant        (   p_securitem_code    VARCHAR2, 
                                    p_flag              VARCHAR2,
                                    p_securitem_global  VARCHAR2
                                )   RETURN              VARCHAR2;


PROCEDURE p_test_table_iud      (   p_tip               VARCHAR2, 
                                    p_table             VARCHAR2);

PROCEDURE p_test_grant          (   p_securitem         VARCHAR2);

FUNCTION f_sk_app_user              RETURN              typ_frm     pipelined;

FUNCTION f_sk_grants            (   p_user_code         VARCHAR2, 
                                    p_type              VARCHAR2 
                                )   RETURN              typ_frm     pipelined;

PROCEDURE p_app_user_grant_iud  (   p_row               APP_USER_GRANT%ROWTYPE);

PROCEDURE p_app_user_iud        (   p_tip               VARCHAR2,   
                                    p_row IN OUT        APP_USER%ROWTYPE);

PROCEDURE p_test_table_iud      (   p_tip               VARCHAR2, 
                                    p_table             VARCHAR2, 
                                    p_mod_col           VARCHAR2);


END;
 

/

/
