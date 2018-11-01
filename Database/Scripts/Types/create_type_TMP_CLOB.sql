--------------------------------------------------------
--  DDL for Type TMP_CLOB
--------------------------------------------------------

  CREATE OR REPLACE TYPE "APP_ROA"."TMP_CLOB" AS OBJECT
(
  idriga  INTEGER,
  dcn   INTEGER,
  seq_no    INTEGER,
  txt01 VARCHAR2(250),
  txt02 VARCHAR2(250),
  txt03 VARCHAR2(250),
  txt04 VARCHAR2(250),
  txt05 VARCHAR2(250),
  txt06 VARCHAR2(250),
  txt07 VARCHAR2(250),
  txt08 VARCHAR2(250),
  txt09 VARCHAR2(250),
  txt10 VARCHAR2(250),
  txt11 VARCHAR2(250),
  txt12 VARCHAR2(250),
  txt13 VARCHAR2(250),
  txt14 VARCHAR2(250),
  txt15 VARCHAR2(250),
  txt16 VARCHAR2(250),
  txt17 VARCHAR2(250),
  txt18 VARCHAR2(250),
  txt19 VARCHAR2(250),
  txt20 VARCHAR2(250),
  numb01 NUMBER,
  numb02 NUMBER,
  numb03 NUMBER,
  numb04 NUMBER,
  numb05 NUMBER,
  numb06 NUMBER,
  numb07 NUMBER,
  numb08 NUMBER,
  numb09 NUMBER,
  numb10 NUMBER,
  numb11 NUMBER,
  numb12 NUMBER,
  numb13 NUMBER,
  numb14 NUMBER,
  numb15 NUMBER,
  numb16 NUMBER,
  numb17 NUMBER,
  numb18 NUMBER,
  numb19 NUMBER,
  numb20 NUMBER,
  data01 DATE,
  data02 DATE,
  data03 DATE,
  data04 DATE,
  data05 DATE,
  data06 DATE,
  data07 DATE,
  data08 DATE,
  data09 DATE,
  data10 DATE,
  clob01    CLOB,
  clob02    CLOB,
  CONSTRUCTOR FUNCTION TMP_CLOB
  RETURN SELF AS RESULT

)
/
CREATE OR REPLACE TYPE BODY "APP_ROA"."TMP_CLOB" AS
CONSTRUCTOR FUNCTION TMP_CLOB
RETURN SELF AS RESULT
AS
BEGIN
self.idriga:=NULL;
self.dcn:=NULL;
self.seq_no:=NULL;
self.txt01:=NULL;
self.txt02:=NULL;
self.txt03:=NULL;
self.txt04:=NULL;
self.txt05:=NULL;
self.txt06:=NULL;
self.txt07:=NULL;
self.txt08:=NULL;
self.txt09:=NULL;
self.txt10:=NULL;
self.txt11:=NULL;
self.txt12:=NULL;
self.txt13:=NULL;
self.txt14:=NULL;
self.txt15:=NULL;
self.txt16:=NULL;
self.txt17:=NULL;
self.txt18:=NULL;
self.txt19:=NULL;
self.txt20:=NULL;
self.numb01:=NULL;
self.numb02:=NULL;
self.numb03:=NULL;
self.numb04:=NULL;
self.numb05:=NULL;
self.numb06:=NULL;
self.numb07:=NULL;
self.numb08:=NULL;
self.numb09:=NULL;
self.numb10:=NULL;
self.numb11:=NULL;
self.numb12:=NULL;
self.numb13:=NULL;
self.numb14:=NULL;
self.numb15:=NULL;
self.numb16:=NULL;
self.numb17:=NULL;
self.numb18:=NULL;
self.numb19:=NULL;
self.numb20:=NULL;
self.data01:=NULL;
self.data02:=NULL;
self.data03:=NULL;
self.data04:=NULL;
self.data05:=NULL;
self.data06:=NULL;
self.data07:=NULL;
self.data08:=NULL;
self.data09:=NULL;
self.data10:=NULL;
self.clob01:= NULL;
self.clob02:= NULL;
RETURN;
END;
END;

/
