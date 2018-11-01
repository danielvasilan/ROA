create or replace 
FUNCTION           "F_STR_FILTER" (p_string VARCHAR2, p_charset VARCHAR2)
    RETURN VARCHAR2
IS
    v_tmp       VARCHAR2(2000);
    v_result    VARCHAR2(2000);
BEGIN
    v_tmp       :=  p_string;
    FOR i IN 1..LENGTH(p_string)
    LOOP
        IF INSTR(p_charset, SUBSTR(p_string,i,1)) > 0 THEN
            v_result    :=  v_result||SUBSTR(p_string,i,1);
        END IF;
    END LOOP;
    RETURN v_result;

END;
 