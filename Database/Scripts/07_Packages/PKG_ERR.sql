--------------------------------------------------------
--  DDL for Package PKG_ERR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_ERR" 
IS

FUNCTION    f_err_msg                   (p_sqlcode INTEGER,p_sqlerrm VARCHAR2) RETURN VARCHAR2;

PROCEDURE   p_reset_error_message       ;
PROCEDURE   p_set_error_message         (    p_err_code          VARCHAR2, 
                                             p_err_header        VARCHAR2, 
                                             p_err_detail        VARCHAR2,
                                             p_flag_immediate    VARCHAR2 DEFAULT 'N'
                                        );
                                        
PROCEDURE   p_dump_error_message        (   p_flag_clear_array  VARCHAR2 DEFAULT 'Y');
PROCEDURE   p_raise_error_message       (   p_err_code          VARCHAR2 DEFAULT NULL);
FUNCTION    f_check_error_message       (   p_err_code          VARCHAR2 DEFAULT NULL) RETURN BOOLEAN;


PROCEDURE p_err                         (   p_errmsg            VARCHAR2, 
                                            p_context           VARCHAR2);

PROCEDURE p_rae                         ;
PROCEDURE p_rae                         (   p_errstr            VARCHAR2);



END;
 

/

/
