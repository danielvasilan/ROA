create or replace 
FUNCTION           "COLLECT_FUNC" (t IN varchar2_t) 
  RETURN VARCHAR2
AS 
  ret VARCHAR2(2000) := '';
  i   NUMBER;
BEGIN
  i := t.FIRST;
  WHILE i IS NOT NULL LOOP
    IF ret IS NOT NULL THEN
      ret := ret || ' - ';
    END IF;

    ret := ret || t(i);

    i := t.NEXT(i);
  END LOOP;

  RETURN ret;
END;
 