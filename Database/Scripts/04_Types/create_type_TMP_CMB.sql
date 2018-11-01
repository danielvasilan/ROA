--------------------------------------------------------
--  DDL for Type TMP_CMB
--------------------------------------------------------

  CREATE OR REPLACE TYPE "APP_ROA"."TMP_CMB" AS OBJECT
(
  txt01 VARCHAR2(32000),
  txt02 VARCHAR2(32000),
  txt03 VARCHAR2(32000),
  txt04 VARCHAR2(32000),
  txt05 VARCHAR2(32000),

  CONSTRUCTOR FUNCTION TMP_CMB
  RETURN SELF AS RESULT

)
/
CREATE OR REPLACE TYPE BODY "APP_ROA"."TMP_CMB" AS
CONSTRUCTOR FUNCTION TMP_CMB
RETURN SELF AS RESULT
AS
BEGIN
self.txt01:=NULL;
self.txt02:=NULL;
self.txt03:=NULL;
self.txt04:=NULL;
self.txt05:=NULL;
RETURN;
END;
END;

/
