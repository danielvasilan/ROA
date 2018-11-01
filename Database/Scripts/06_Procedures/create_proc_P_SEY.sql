create or replace 
PROCEDURE           "P_SEY" (     p_err_code    VARCHAR2  ,
                                        p_err_header  VARCHAR2  ,
                                        p_err_detail  VARCHAR2  DEFAULT NULL
                                 )
IS
BEGIN
    Pkg_Err.p_set_error_message
    (    p_err_code          => p_err_code ,
         p_err_header        => p_err_header,
         p_err_detail        => p_err_detail ,
         p_flag_immediate    => 'Y'
    );
END;
/
