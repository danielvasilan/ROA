create or replace 
PROCEDURE           "P_LOG" (x VARCHAR2)
IS
BEGIN
    Pkg_App_Tools.P_Log(p_msg_type => 'E',p_msg_text => x,p_msg_context => NULL);
END;
/
