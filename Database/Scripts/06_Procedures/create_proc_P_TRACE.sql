create or replace 
PROCEDURE           "P_TRACE" (   p_text VARCHAR2, p_context VARCHAR2)
--------------------------------------------------------------------------------------------
--  PURPOSE: shortcut for logging Tracing messages in procedures 
--------------------------------------------------------------------------------------------
IS
BEGIN
    INSERT INTO TMP_GENERAL(txt36) VALUES (DBMS_UTILITY.FORMAT_CALL_STACK);
    Pkg_App_Tools.P_Log('T',p_text,p_context);
END;
/
