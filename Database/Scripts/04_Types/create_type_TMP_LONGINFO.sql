--------------------------------------------------------
--  DDL for Type TMP_LONGINFO
--------------------------------------------------------

  CREATE OR REPLACE TYPE "APP_ROA"."TMP_LONGINFO" AS OBJECT
(
  idriga INTEGER,
  dcn  INTEGER,
  seq_no INTEGER,
  txt01 VARCHAR2(32000),
  txt02 VARCHAR2(32000),
  txt03 VARCHAR2(32000),
  txt04 VARCHAR2(32000),
  txt05 VARCHAR2(32000),
  txt06 VARCHAR2(32000),
  txt07 VARCHAR2(32000),
  txt08 VARCHAR2(32000),
  txt09 VARCHAR2(32000),
  txt10 VARCHAR2(32000),
  txt11 VARCHAR2(32000),
  txt12 VARCHAR2(32000),
  txt13 VARCHAR2(32000),
  txt14 VARCHAR2(32000),
  txt15 VARCHAR2(32000),
  txt16 VARCHAR2(32000),
  txt17 VARCHAR2(32000),
  txt18 VARCHAR2(32000),
  txt19 VARCHAR2(32000),
  txt20 VARCHAR2(32000),
  txt21 VARCHAR2(32000),
  txt22 VARCHAR2(32000),
  txt23 VARCHAR2(32000),
  txt24 VARCHAR2(32000),
  txt25 VARCHAR2(32000),
  txt26 VARCHAR2(32000),
  txt27 VARCHAR2(32000),
  txt28 VARCHAR2(32000),
  txt29 VARCHAR2(32000),
  txt30 VARCHAR2(32000),
  txt31 VARCHAR2(32000),
  txt32 VARCHAR2(32000),
  txt33 VARCHAR2(32000),
  txt34 VARCHAR2(32000),
  txt35 VARCHAR2(32000),
  txt36 VARCHAR2(32000),
  txt37 VARCHAR2(32000),
  txt38 VARCHAR2(32000),
  txt39 VARCHAR2(32000),
  txt40 VARCHAR2(32000),
  txt41 VARCHAR2(32000),
  txt42 VARCHAR2(32000),
  txt43 VARCHAR2(32000),
  txt44 VARCHAR2(32000),
  txt45 VARCHAR2(32000),
  txt46 VARCHAR2(32000),
  txt47 VARCHAR2(32000),
  txt48 VARCHAR2(32000),
  txt49 VARCHAR2(32000),
  txt50 VARCHAR2(32000),
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
  data11 DATE,
  data12 DATE,
  data13 DATE,
  data14 DATE,
  data15 DATE,
  data16 DATE,
  data17 DATE,
  data18 DATE,
  data19 DATE,
  data20 DATE,
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
  numb21 NUMBER,
  numb22 NUMBER,
  numb23 NUMBER,
  numb24 NUMBER,
  numb25 NUMBER,
  numb26 NUMBER,
  numb27 NUMBER,
  numb28 NUMBER,
  numb29 NUMBER,
  numb30 NUMBER,
  numb31 NUMBER,
  numb32 NUMBER,
  numb33 NUMBER,
  numb34 NUMBER,
  numb35 NUMBER,
  numb36 NUMBER,
  numb37 NUMBER,
  numb38 NUMBER,
  numb39 NUMBER,
  numb40 NUMBER,
  numb41 NUMBER,
  numb42 NUMBER,
  numb43 NUMBER,
  numb44 NUMBER,
  numb45 NUMBER,
  numb46 NUMBER,
  numb47 NUMBER,
  numb48 NUMBER,
  numb49 NUMBER,
  numb50 NUMBER,
  numb51 NUMBER,
  numb52 NUMBER,
  numb53 NUMBER,
  numb54 NUMBER,
  numb55 NUMBER,
  numb56 NUMBER,
  numb57 NUMBER,
  numb58 NUMBER,
  numb59 NUMBER,
  numb60 NUMBER,
  numb61 NUMBER,
  numb62 NUMBER,
  numb63 NUMBER,
  numb64 NUMBER,
  numb65 NUMBER,
  numb66 NUMBER,
  numb67 NUMBER,
  numb68 NUMBER,
  numb69 NUMBER,
  numb70 NUMBER,
  numb71 NUMBER,
  numb72 NUMBER,
  numb73 NUMBER,
  numb74 NUMBER,
  numb75 NUMBER,
  numb76 NUMBER,
  numb77 NUMBER,
  numb78 NUMBER,
  numb79 NUMBER,
  numb80 NUMBER,
  numb81 NUMBER,
  numb82 NUMBER,
  numb83 NUMBER,
  numb84 NUMBER,
  numb85 NUMBER,
  numb86 NUMBER,
  numb87 NUMBER,
  numb88 NUMBER,
  numb89 NUMBER,
  numb90 NUMBER,
  numb91 NUMBER,
  numb92 NUMBER,
  numb93 NUMBER,
  numb94 NUMBER,
  numb95 NUMBER,
  numb96 NUMBER,
  numb97 NUMBER,
  numb98 NUMBER,
  numb99 NUMBER,

  CONSTRUCTOR FUNCTION TMP_LONGINFO
  RETURN SELF AS RESULT
)
/
CREATE OR REPLACE TYPE BODY "APP_ROA"."TMP_LONGINFO" AS
CONSTRUCTOR FUNCTION TMP_LONGINFO
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
self.txt21:=NULL;
self.txt22:=NULL;
self.txt23:=NULL;
self.txt24:=NULL;
self.txt25:=NULL;
self.txt26:=NULL;
self.txt27:=NULL;
self.txt28:=NULL;
self.txt29:=NULL;
self.txt30:=NULL;
self.txt31:=NULL;
self.txt32:=NULL;
self.txt33:=NULL;
self.txt34:=NULL;
self.txt35:=NULL;
self.txt36:=NULL;
self.txt37:=NULL;
self.txt38:=NULL;
self.txt39:=NULL;
self.txt40:=NULL;
self.txt41:=NULL;
self.txt42:=NULL;
self.txt43:=NULL;
self.txt44:=NULL;
self.txt45:=NULL;
self.txt46:=NULL;
self.txt47:=NULL;
self.txt48:=NULL;
self.txt49:=NULL;
self.txt50:=NULL;
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
self.data11:=NULL;
self.data12:=NULL;
self.data13:=NULL;
self.data14:=NULL;
self.data15:=NULL;
self.data16:=NULL;
self.data17:=NULL;
self.data18:=NULL;
self.data19:=NULL;
self.data20:=NULL;
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
self.numb21:=NULL;
self.numb22:=NULL;
self.numb23:=NULL;
self.numb24:=NULL;
self.numb25:=NULL;
self.numb26:=NULL;
self.numb27:=NULL;
self.numb28:=NULL;
self.numb29:=NULL;
self.numb30:=NULL;
self.numb31:=NULL;
self.numb32:=NULL;
self.numb33:=NULL;
self.numb34:=NULL;
self.numb35:=NULL;
self.numb36:=NULL;
self.numb37:=NULL;
self.numb38:=NULL;
self.numb39:=NULL;
self.numb40:=NULL;
self.numb41:=NULL;
self.numb42:=NULL;
self.numb43:=NULL;
self.numb44:=NULL;
self.numb45:=NULL;
self.numb46:=NULL;
self.numb47:=NULL;
self.numb48:=NULL;
self.numb49:=NULL;
self.numb50:=NULL;
self.numb51:=NULL;
self.numb52:=NULL;
self.numb53:=NULL;
self.numb54:=NULL;
self.numb55:=NULL;
self.numb56:=NULL;
self.numb57:=NULL;
self.numb58:=NULL;
self.numb59:=NULL;
self.numb60:=NULL;
self.numb61:=NULL;
self.numb62:=NULL;
self.numb63:=NULL;
self.numb64:=NULL;
self.numb65:=NULL;
self.numb66:=NULL;
self.numb67:=NULL;
self.numb68:=NULL;
self.numb69:=NULL;
self.numb70:=NULL;
self.numb71:=NULL;
self.numb72:=NULL;
self.numb73:=NULL;
self.numb74:=NULL;
self.numb75:=NULL;
self.numb76:=NULL;
self.numb77:=NULL;
self.numb78:=NULL;
self.numb79:=NULL;
self.numb80:=NULL;
self.numb81:=NULL;
self.numb82:=NULL;
self.numb83:=NULL;
self.numb84:=NULL;
self.numb85:=NULL;
self.numb86:=NULL;
self.numb87:=NULL;
self.numb88:=NULL;
self.numb89:=NULL;
self.numb90:=NULL;
self.numb91:=NULL;
self.numb92:=NULL;
self.numb93:=NULL;
self.numb94:=NULL;
self.numb95:=NULL;
self.numb96:=NULL;
self.numb97:=NULL;
self.numb98:=NULL;
self.numb99:=NULL;

RETURN;
END;
END;

/
