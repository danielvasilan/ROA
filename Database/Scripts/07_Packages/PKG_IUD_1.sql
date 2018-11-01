--------------------------------------------------------
--  DDL for Package Body PKG_IUD
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_IUD" 
IS 
PROCEDURE p_acrec_detail_iud(p_tip   VARCHAR2, p_row IN ACREC_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ACREC_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ACREC_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ACREC_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ACREC_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_acrec_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ACREC_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ACREC_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ACREC_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ACREC_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_acrec_header_iud(p_tip   VARCHAR2, p_row IN ACREC_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ACREC_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ACREC_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ACREC_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ACREC_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_acrec_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ACREC_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ACREC_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ACREC_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ACREC_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_ac_account_iud(p_tip   VARCHAR2, p_row IN AC_ACCOUNT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE AC_ACCOUNT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO AC_ACCOUNT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO AC_ACCOUNT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM AC_ACCOUNT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_ac_account_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_AC_ACCOUNT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE AC_ACCOUNT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO AC_ACCOUNT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM AC_ACCOUNT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_ac_detail_iud(p_tip   VARCHAR2, p_row IN AC_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE AC_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO AC_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO AC_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM AC_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_ac_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_AC_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE AC_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO AC_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM AC_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_ac_document_iud(p_tip   VARCHAR2, p_row IN AC_DOCUMENT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE AC_DOCUMENT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO AC_DOCUMENT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO AC_DOCUMENT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM AC_DOCUMENT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_ac_document_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_AC_DOCUMENT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE AC_DOCUMENT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO AC_DOCUMENT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM AC_DOCUMENT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_ac_header_iud(p_tip   VARCHAR2, p_row IN AC_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE AC_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO AC_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO AC_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM AC_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_ac_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_AC_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE AC_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO AC_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM AC_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_ac_period_iud(p_tip   VARCHAR2, p_row IN AC_PERIOD%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE AC_PERIOD SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO AC_PERIOD VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO AC_PERIOD VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM AC_PERIOD WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_ac_period_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_AC_PERIOD)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE AC_PERIOD SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO AC_PERIOD VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM AC_PERIOD WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_app_audit_iud(p_tip   VARCHAR2, p_row IN APP_AUDIT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE APP_AUDIT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO APP_AUDIT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO APP_AUDIT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM APP_AUDIT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_app_audit_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_APP_AUDIT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE APP_AUDIT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO APP_AUDIT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM APP_AUDIT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_app_doc_number_iud(p_tip   VARCHAR2, p_row IN APP_DOC_NUMBER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE APP_DOC_NUMBER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO APP_DOC_NUMBER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO APP_DOC_NUMBER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM APP_DOC_NUMBER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_app_doc_number_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_APP_DOC_NUMBER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE APP_DOC_NUMBER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO APP_DOC_NUMBER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM APP_DOC_NUMBER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_app_securitem_iud(p_tip   VARCHAR2, p_row IN APP_SECURITEM%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE APP_SECURITEM SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO APP_SECURITEM VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO APP_SECURITEM VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM APP_SECURITEM WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_app_securitem_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_APP_SECURITEM)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE APP_SECURITEM SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO APP_SECURITEM VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM APP_SECURITEM WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_app_task_iud(p_tip   VARCHAR2, p_row IN APP_TASK%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE APP_TASK SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO APP_TASK VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO APP_TASK VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM APP_TASK WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_app_task_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_APP_TASK)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE APP_TASK SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO APP_TASK VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM APP_TASK WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_app_task_param_iud(p_tip   VARCHAR2, p_row IN APP_TASK_PARAM%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE APP_TASK_PARAM SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO APP_TASK_PARAM VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO APP_TASK_PARAM VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM APP_TASK_PARAM WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_app_task_param_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_APP_TASK_PARAM)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE APP_TASK_PARAM SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO APP_TASK_PARAM VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM APP_TASK_PARAM WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_app_task_step_iud(p_tip   VARCHAR2, p_row IN APP_TASK_STEP%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE APP_TASK_STEP SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO APP_TASK_STEP VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO APP_TASK_STEP VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM APP_TASK_STEP WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_app_task_step_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_APP_TASK_STEP)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE APP_TASK_STEP SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO APP_TASK_STEP VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM APP_TASK_STEP WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_app_user_iud(p_tip   VARCHAR2, p_row IN APP_USER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE APP_USER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO APP_USER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO APP_USER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM APP_USER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_app_user_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_APP_USER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE APP_USER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO APP_USER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM APP_USER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_app_user_grant_iud(p_tip   VARCHAR2, p_row IN APP_USER_GRANT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE APP_USER_GRANT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO APP_USER_GRANT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO APP_USER_GRANT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM APP_USER_GRANT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_app_user_grant_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_APP_USER_GRANT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE APP_USER_GRANT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO APP_USER_GRANT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM APP_USER_GRANT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_bom_group_iud(p_tip   VARCHAR2, p_row IN BOM_GROUP%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE BOM_GROUP SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO BOM_GROUP VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO BOM_GROUP VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM BOM_GROUP WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_bom_group_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_BOM_GROUP)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE BOM_GROUP SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO BOM_GROUP VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM BOM_GROUP WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_bom_std_iud(p_tip   VARCHAR2, p_row IN BOM_STD%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE BOM_STD SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO BOM_STD VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO BOM_STD VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM BOM_STD WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_bom_std_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_BOM_STD)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE BOM_STD SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO BOM_STD VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM BOM_STD WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_bom_wo_iud(p_tip   VARCHAR2, p_row IN BOM_WO%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE BOM_WO SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO BOM_WO VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO BOM_WO VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM BOM_WO WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_bom_wo_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_BOM_WO)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE BOM_WO SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO BOM_WO VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM BOM_WO WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_calendar_iud(p_tip   VARCHAR2, p_row IN CALENDAR%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE CALENDAR SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO CALENDAR VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO CALENDAR VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM CALENDAR WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_calendar_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_CALENDAR)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE CALENDAR SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO CALENDAR VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM CALENDAR WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_cat_custom_iud(p_tip   VARCHAR2, p_row IN CAT_CUSTOM%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE CAT_CUSTOM SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO CAT_CUSTOM VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO CAT_CUSTOM VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM CAT_CUSTOM WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_cat_custom_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_CAT_CUSTOM)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE CAT_CUSTOM SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO CAT_CUSTOM VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM CAT_CUSTOM WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_cat_mat_type_iud(p_tip   VARCHAR2, p_row IN CAT_MAT_TYPE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE CAT_MAT_TYPE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO CAT_MAT_TYPE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO CAT_MAT_TYPE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM CAT_MAT_TYPE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_cat_mat_type_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_CAT_MAT_TYPE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE CAT_MAT_TYPE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO CAT_MAT_TYPE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM CAT_MAT_TYPE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_colour_iud(p_tip   VARCHAR2, p_row IN COLOUR%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE COLOUR SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO COLOUR VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO COLOUR VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM COLOUR WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_colour_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_COLOUR)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE COLOUR SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO COLOUR VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM COLOUR WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_costcenter_iud(p_tip   VARCHAR2, p_row IN COSTCENTER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE COSTCENTER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO COSTCENTER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO COSTCENTER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM COSTCENTER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_costcenter_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_COSTCENTER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE COSTCENTER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO COSTCENTER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM COSTCENTER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_cost_detail_iud(p_tip   VARCHAR2, p_row IN COST_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE COST_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO COST_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO COST_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM COST_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_cost_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_COST_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE COST_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO COST_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM COST_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_cost_header_iud(p_tip   VARCHAR2, p_row IN COST_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE COST_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO COST_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO COST_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM COST_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_cost_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_COST_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE COST_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO COST_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM COST_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_cost_type_iud(p_tip   VARCHAR2, p_row IN COST_TYPE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE COST_TYPE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO COST_TYPE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO COST_TYPE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM COST_TYPE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_cost_type_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_COST_TYPE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE COST_TYPE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO COST_TYPE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM COST_TYPE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_country_iud(p_tip   VARCHAR2, p_row IN COUNTRY%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE COUNTRY SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO COUNTRY VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO COUNTRY VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM COUNTRY WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_country_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_COUNTRY)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE COUNTRY SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO COUNTRY VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM COUNTRY WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_currency_iud(p_tip   VARCHAR2, p_row IN CURRENCY%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE CURRENCY SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO CURRENCY VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO CURRENCY VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM CURRENCY WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_currency_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_CURRENCY)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE CURRENCY SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO CURRENCY VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM CURRENCY WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_currency_rate_iud(p_tip   VARCHAR2, p_row IN CURRENCY_RATE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE CURRENCY_RATE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO CURRENCY_RATE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO CURRENCY_RATE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM CURRENCY_RATE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_currency_rate_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_CURRENCY_RATE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE CURRENCY_RATE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO CURRENCY_RATE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM CURRENCY_RATE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_custom_iud(p_tip   VARCHAR2, p_row IN CUSTOM%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE CUSTOM SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO CUSTOM VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO CUSTOM VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM CUSTOM WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_custom_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_CUSTOM)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE CUSTOM SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO CUSTOM VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM CUSTOM WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_delivery_condition_iud(p_tip   VARCHAR2, p_row IN DELIVERY_CONDITION%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE DELIVERY_CONDITION SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO DELIVERY_CONDITION VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO DELIVERY_CONDITION VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM DELIVERY_CONDITION WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_delivery_condition_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_DELIVERY_CONDITION)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE DELIVERY_CONDITION SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO DELIVERY_CONDITION VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM DELIVERY_CONDITION WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_efficiency_iud(p_tip   VARCHAR2, p_row IN EFFICIENCY%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE EFFICIENCY SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO EFFICIENCY VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO EFFICIENCY VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM EFFICIENCY WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_efficiency_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_EFFICIENCY)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE EFFICIENCY SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO EFFICIENCY VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM EFFICIENCY WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_fa_trn_iud(p_tip   VARCHAR2, p_row IN FA_TRN%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE FA_TRN SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO FA_TRN VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO FA_TRN VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM FA_TRN WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_fa_trn_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_FA_TRN)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE FA_TRN SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO FA_TRN VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM FA_TRN WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_fa_trn_type_iud(p_tip   VARCHAR2, p_row IN FA_TRN_TYPE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE FA_TRN_TYPE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO FA_TRN_TYPE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO FA_TRN_TYPE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM FA_TRN_TYPE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_fa_trn_type_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_FA_TRN_TYPE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE FA_TRN_TYPE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO FA_TRN_TYPE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM FA_TRN_TYPE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_fifo_exceding_iud(p_tip   VARCHAR2, p_row IN FIFO_EXCEDING%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE FIFO_EXCEDING SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO FIFO_EXCEDING VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO FIFO_EXCEDING VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM FIFO_EXCEDING WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_fifo_exceding_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_FIFO_EXCEDING)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE FIFO_EXCEDING SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO FIFO_EXCEDING VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM FIFO_EXCEDING WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_fifo_material_iud(p_tip   VARCHAR2, p_row IN FIFO_MATERIAL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE FIFO_MATERIAL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO FIFO_MATERIAL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO FIFO_MATERIAL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM FIFO_MATERIAL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_fifo_material_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_FIFO_MATERIAL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE FIFO_MATERIAL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO FIFO_MATERIAL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM FIFO_MATERIAL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_fixed_asset_iud(p_tip   VARCHAR2, p_row IN FIXED_ASSET%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE FIXED_ASSET SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO FIXED_ASSET VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO FIXED_ASSET VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM FIXED_ASSET WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_fixed_asset_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_FIXED_ASSET)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE FIXED_ASSET SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO FIXED_ASSET VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM FIXED_ASSET WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_fixed_asset_categ_iud(p_tip   VARCHAR2, p_row IN FIXED_ASSET_CATEG%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE FIXED_ASSET_CATEG SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO FIXED_ASSET_CATEG VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO FIXED_ASSET_CATEG VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM FIXED_ASSET_CATEG WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_fixed_asset_categ_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_FIXED_ASSET_CATEG)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE FIXED_ASSET_CATEG SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO FIXED_ASSET_CATEG VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM FIXED_ASSET_CATEG WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_group_routing_iud(p_tip   VARCHAR2, p_row IN GROUP_ROUTING%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE GROUP_ROUTING SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO GROUP_ROUTING VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO GROUP_ROUTING VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM GROUP_ROUTING WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_group_routing_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_GROUP_ROUTING)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE GROUP_ROUTING SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO GROUP_ROUTING VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM GROUP_ROUTING WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_import_text_file_iud(p_tip   VARCHAR2, p_row IN IMPORT_TEXT_FILE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE IMPORT_TEXT_FILE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO IMPORT_TEXT_FILE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO IMPORT_TEXT_FILE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM IMPORT_TEXT_FILE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_import_text_file_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_IMPORT_TEXT_FILE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE IMPORT_TEXT_FILE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO IMPORT_TEXT_FILE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM IMPORT_TEXT_FILE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_inventory_iud(p_tip   VARCHAR2, p_row IN INVENTORY%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE INVENTORY SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO INVENTORY VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO INVENTORY VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM INVENTORY WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_inventory_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_INVENTORY)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE INVENTORY SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO INVENTORY VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM INVENTORY WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_inventory_detail_iud(p_tip   VARCHAR2, p_row IN INVENTORY_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE INVENTORY_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO INVENTORY_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO INVENTORY_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM INVENTORY_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_inventory_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_INVENTORY_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE INVENTORY_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO INVENTORY_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM INVENTORY_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_inventory_setup_iud(p_tip   VARCHAR2, p_row IN INVENTORY_SETUP%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE INVENTORY_SETUP SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO INVENTORY_SETUP VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO INVENTORY_SETUP VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM INVENTORY_SETUP WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_inventory_setup_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_INVENTORY_SETUP)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE INVENTORY_SETUP SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO INVENTORY_SETUP VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM INVENTORY_SETUP WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_inventory_stoc_iud(p_tip   VARCHAR2, p_row IN INVENTORY_STOC%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE INVENTORY_STOC SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO INVENTORY_STOC VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO INVENTORY_STOC VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM INVENTORY_STOC WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_inventory_stoc_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_INVENTORY_STOC)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE INVENTORY_STOC SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO INVENTORY_STOC VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM INVENTORY_STOC WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_item_iud(p_tip   VARCHAR2, p_row IN ITEM%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ITEM SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ITEM VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ITEM VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ITEM WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_item_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ITEM)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ITEM SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ITEM VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ITEM WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_item_cost_iud(p_tip   VARCHAR2, p_row IN ITEM_COST%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ITEM_COST SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ITEM_COST VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ITEM_COST VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ITEM_COST WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_item_cost_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ITEM_COST)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ITEM_COST SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ITEM_COST VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ITEM_COST WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_item_cycle_time_iud(p_tip   VARCHAR2, p_row IN ITEM_CYCLE_TIME%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ITEM_CYCLE_TIME SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ITEM_CYCLE_TIME VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ITEM_CYCLE_TIME VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ITEM_CYCLE_TIME WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_item_cycle_time_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ITEM_CYCLE_TIME)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ITEM_CYCLE_TIME SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ITEM_CYCLE_TIME VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ITEM_CYCLE_TIME WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_item_mapping_iud(p_tip   VARCHAR2, p_row IN ITEM_MAPPING%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ITEM_MAPPING SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ITEM_MAPPING VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ITEM_MAPPING VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ITEM_MAPPING WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_item_mapping_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ITEM_MAPPING)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ITEM_MAPPING SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ITEM_MAPPING VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ITEM_MAPPING WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_item_size_iud(p_tip   VARCHAR2, p_row IN ITEM_SIZE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ITEM_SIZE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ITEM_SIZE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ITEM_SIZE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ITEM_SIZE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_item_size_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ITEM_SIZE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ITEM_SIZE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ITEM_SIZE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ITEM_SIZE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_item_type_iud(p_tip   VARCHAR2, p_row IN ITEM_TYPE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ITEM_TYPE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ITEM_TYPE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ITEM_TYPE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ITEM_TYPE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_item_type_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ITEM_TYPE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ITEM_TYPE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ITEM_TYPE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ITEM_TYPE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_item_variable_iud(p_tip   VARCHAR2, p_row IN ITEM_VARIABLE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ITEM_VARIABLE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ITEM_VARIABLE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ITEM_VARIABLE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ITEM_VARIABLE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_item_variable_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ITEM_VARIABLE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ITEM_VARIABLE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ITEM_VARIABLE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ITEM_VARIABLE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_line_iud(p_tip   VARCHAR2, p_row IN LINE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE LINE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO LINE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO LINE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM LINE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_line_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_LINE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE LINE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO LINE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM LINE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_macrorouting_detail_iud(p_tip   VARCHAR2, p_row IN MACROROUTING_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE MACROROUTING_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO MACROROUTING_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO MACROROUTING_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM MACROROUTING_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_macrorouting_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_MACROROUTING_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE MACROROUTING_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO MACROROUTING_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM MACROROUTING_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_macrorouting_header_iud(p_tip   VARCHAR2, p_row IN MACROROUTING_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE MACROROUTING_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO MACROROUTING_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO MACROROUTING_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM MACROROUTING_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_macrorouting_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_MACROROUTING_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE MACROROUTING_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO MACROROUTING_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM MACROROUTING_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_movement_type_iud(p_tip   VARCHAR2, p_row IN MOVEMENT_TYPE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE MOVEMENT_TYPE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO MOVEMENT_TYPE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO MOVEMENT_TYPE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM MOVEMENT_TYPE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_movement_type_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_MOVEMENT_TYPE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE MOVEMENT_TYPE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO MOVEMENT_TYPE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM MOVEMENT_TYPE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_multi_table_iud(p_tip   VARCHAR2, p_row IN MULTI_TABLE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE MULTI_TABLE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO MULTI_TABLE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO MULTI_TABLE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM MULTI_TABLE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_multi_table_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_MULTI_TABLE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE MULTI_TABLE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO MULTI_TABLE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM MULTI_TABLE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_operation_iud(p_tip   VARCHAR2, p_row IN OPERATION%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE OPERATION SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO OPERATION VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO OPERATION VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM OPERATION WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_operation_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_OPERATION)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE OPERATION SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO OPERATION VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM OPERATION WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_organization_iud(p_tip   VARCHAR2, p_row IN ORGANIZATION%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ORGANIZATION SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ORGANIZATION VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ORGANIZATION VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ORGANIZATION WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_organization_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ORGANIZATION)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ORGANIZATION SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ORGANIZATION VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ORGANIZATION WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_organization_loc_iud(p_tip   VARCHAR2, p_row IN ORGANIZATION_LOC%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE ORGANIZATION_LOC SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO ORGANIZATION_LOC VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO ORGANIZATION_LOC VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM ORGANIZATION_LOC WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_organization_loc_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_ORGANIZATION_LOC)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE ORGANIZATION_LOC SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO ORGANIZATION_LOC VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM ORGANIZATION_LOC WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_package_detail_iud(p_tip   VARCHAR2, p_row IN PACKAGE_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PACKAGE_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PACKAGE_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PACKAGE_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PACKAGE_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_package_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PACKAGE_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PACKAGE_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PACKAGE_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PACKAGE_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_package_header_iud(p_tip   VARCHAR2, p_row IN PACKAGE_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PACKAGE_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PACKAGE_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PACKAGE_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PACKAGE_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_package_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PACKAGE_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PACKAGE_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PACKAGE_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PACKAGE_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_package_trn_detail_iud(p_tip   VARCHAR2, p_row IN PACKAGE_TRN_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PACKAGE_TRN_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PACKAGE_TRN_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PACKAGE_TRN_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PACKAGE_TRN_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_package_trn_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PACKAGE_TRN_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PACKAGE_TRN_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PACKAGE_TRN_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PACKAGE_TRN_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_package_trn_header_iud(p_tip   VARCHAR2, p_row IN PACKAGE_TRN_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PACKAGE_TRN_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PACKAGE_TRN_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PACKAGE_TRN_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PACKAGE_TRN_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_package_trn_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PACKAGE_TRN_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PACKAGE_TRN_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PACKAGE_TRN_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PACKAGE_TRN_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_parameter_iud(p_tip   VARCHAR2, p_row IN PARAMETER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PARAMETER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PARAMETER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PARAMETER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PARAMETER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_parameter_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PARAMETER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PARAMETER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PARAMETER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PARAMETER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_parameter_attr_iud(p_tip   VARCHAR2, p_row IN PARAMETER_ATTR%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PARAMETER_ATTR SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PARAMETER_ATTR VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PARAMETER_ATTR VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PARAMETER_ATTR WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_parameter_attr_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PARAMETER_ATTR)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PARAMETER_ATTR SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PARAMETER_ATTR VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PARAMETER_ATTR WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_parameter_code_iud(p_tip   VARCHAR2, p_row IN PARAMETER_CODE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PARAMETER_CODE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PARAMETER_CODE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PARAMETER_CODE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PARAMETER_CODE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_parameter_code_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PARAMETER_CODE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PARAMETER_CODE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PARAMETER_CODE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PARAMETER_CODE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_patch_detail_iud(p_tip   VARCHAR2, p_row IN PATCH_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PATCH_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PATCH_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PATCH_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PATCH_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_patch_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PATCH_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PATCH_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PATCH_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PATCH_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_patch_header_iud(p_tip   VARCHAR2, p_row IN PATCH_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PATCH_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PATCH_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PATCH_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PATCH_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_patch_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PATCH_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PATCH_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PATCH_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PATCH_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_po_ord_header_iud(p_tip   VARCHAR2, p_row IN PO_ORD_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PO_ORD_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PO_ORD_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PO_ORD_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PO_ORD_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_po_ord_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PO_ORD_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PO_ORD_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PO_ORD_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PO_ORD_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_po_ord_line_iud(p_tip   VARCHAR2, p_row IN PO_ORD_LINE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PO_ORD_LINE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PO_ORD_LINE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PO_ORD_LINE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PO_ORD_LINE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_po_ord_line_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PO_ORD_LINE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PO_ORD_LINE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PO_ORD_LINE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PO_ORD_LINE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_price_list_iud(p_tip   VARCHAR2, p_row IN PRICE_LIST%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PRICE_LIST SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PRICE_LIST VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PRICE_LIST VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PRICE_LIST WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_price_list_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PRICE_LIST)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PRICE_LIST SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PRICE_LIST VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PRICE_LIST WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_price_list_sales_iud(p_tip   VARCHAR2, p_row IN PRICE_LIST_SALES%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PRICE_LIST_SALES SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PRICE_LIST_SALES VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PRICE_LIST_SALES VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PRICE_LIST_SALES WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_price_list_sales_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PRICE_LIST_SALES)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PRICE_LIST_SALES SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PRICE_LIST_SALES VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PRICE_LIST_SALES WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_primary_uom_iud(p_tip   VARCHAR2, p_row IN PRIMARY_UOM%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE PRIMARY_UOM SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO PRIMARY_UOM VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO PRIMARY_UOM VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM PRIMARY_UOM WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_primary_uom_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_PRIMARY_UOM)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE PRIMARY_UOM SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO PRIMARY_UOM VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM PRIMARY_UOM WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_receipt_detail_iud(p_tip   VARCHAR2, p_row IN RECEIPT_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE RECEIPT_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO RECEIPT_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO RECEIPT_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM RECEIPT_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_receipt_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_RECEIPT_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE RECEIPT_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO RECEIPT_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM RECEIPT_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_receipt_header_iud(p_tip   VARCHAR2, p_row IN RECEIPT_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE RECEIPT_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO RECEIPT_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO RECEIPT_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM RECEIPT_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_receipt_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_RECEIPT_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE RECEIPT_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO RECEIPT_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM RECEIPT_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_reports_iud(p_tip   VARCHAR2, p_row IN REPORTS%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE REPORTS SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO REPORTS VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO REPORTS VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM REPORTS WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_reports_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_REPORTS)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE REPORTS SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO REPORTS VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM REPORTS WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_reports_category_iud(p_tip   VARCHAR2, p_row IN REPORTS_CATEGORY%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE REPORTS_CATEGORY SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO REPORTS_CATEGORY VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO REPORTS_CATEGORY VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM REPORTS_CATEGORY WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_reports_category_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_REPORTS_CATEGORY)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE REPORTS_CATEGORY SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO REPORTS_CATEGORY VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM REPORTS_CATEGORY WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_reports_parameter_iud(p_tip   VARCHAR2, p_row IN REPORTS_PARAMETER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE REPORTS_PARAMETER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO REPORTS_PARAMETER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO REPORTS_PARAMETER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM REPORTS_PARAMETER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_reports_parameter_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_REPORTS_PARAMETER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE REPORTS_PARAMETER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO REPORTS_PARAMETER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM REPORTS_PARAMETER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_report_queue_detail_iud(p_tip   VARCHAR2, p_row IN REPORT_QUEUE_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE REPORT_QUEUE_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO REPORT_QUEUE_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO REPORT_QUEUE_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM REPORT_QUEUE_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_report_queue_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_REPORT_QUEUE_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE REPORT_QUEUE_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO REPORT_QUEUE_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM REPORT_QUEUE_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_report_queue_header_iud(p_tip   VARCHAR2, p_row IN REPORT_QUEUE_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE REPORT_QUEUE_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO REPORT_QUEUE_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO REPORT_QUEUE_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM REPORT_QUEUE_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_report_queue_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_REPORT_QUEUE_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE REPORT_QUEUE_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO REPORT_QUEUE_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM REPORT_QUEUE_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_sales_family_iud(p_tip   VARCHAR2, p_row IN SALES_FAMILY%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SALES_FAMILY SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SALES_FAMILY VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SALES_FAMILY VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SALES_FAMILY WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_sales_family_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SALES_FAMILY)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SALES_FAMILY SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SALES_FAMILY VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SALES_FAMILY WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_sales_order_iud(p_tip   VARCHAR2, p_row IN SALES_ORDER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SALES_ORDER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SALES_ORDER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SALES_ORDER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SALES_ORDER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_sales_order_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SALES_ORDER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SALES_ORDER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SALES_ORDER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SALES_ORDER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_scan_event_iud(p_tip   VARCHAR2, p_row IN SCAN_EVENT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SCAN_EVENT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SCAN_EVENT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SCAN_EVENT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SCAN_EVENT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_scan_event_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SCAN_EVENT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SCAN_EVENT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SCAN_EVENT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SCAN_EVENT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_setup_acrec_iud(p_tip   VARCHAR2, p_row IN SETUP_ACREC%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SETUP_ACREC SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SETUP_ACREC VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SETUP_ACREC VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SETUP_ACREC WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_setup_acrec_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SETUP_ACREC)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SETUP_ACREC SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SETUP_ACREC VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SETUP_ACREC WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_setup_movement_iud(p_tip   VARCHAR2, p_row IN SETUP_MOVEMENT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SETUP_MOVEMENT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SETUP_MOVEMENT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SETUP_MOVEMENT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SETUP_MOVEMENT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_setup_movement_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SETUP_MOVEMENT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SETUP_MOVEMENT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SETUP_MOVEMENT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SETUP_MOVEMENT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_setup_receipt_iud(p_tip   VARCHAR2, p_row IN SETUP_RECEIPT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SETUP_RECEIPT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SETUP_RECEIPT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SETUP_RECEIPT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SETUP_RECEIPT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_setup_receipt_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SETUP_RECEIPT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SETUP_RECEIPT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SETUP_RECEIPT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SETUP_RECEIPT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_setup_shipment_iud(p_tip   VARCHAR2, p_row IN SETUP_SHIPMENT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SETUP_SHIPMENT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SETUP_SHIPMENT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SETUP_SHIPMENT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SETUP_SHIPMENT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_setup_shipment_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SETUP_SHIPMENT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SETUP_SHIPMENT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SETUP_SHIPMENT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SETUP_SHIPMENT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_shipment_detail_iud(p_tip   VARCHAR2, p_row IN SHIPMENT_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SHIPMENT_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SHIPMENT_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SHIPMENT_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SHIPMENT_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_shipment_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SHIPMENT_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SHIPMENT_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SHIPMENT_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SHIPMENT_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_shipment_header_iud(p_tip   VARCHAR2, p_row IN SHIPMENT_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SHIPMENT_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SHIPMENT_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SHIPMENT_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SHIPMENT_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_shipment_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SHIPMENT_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SHIPMENT_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SHIPMENT_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SHIPMENT_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_shipment_order_iud(p_tip   VARCHAR2, p_row IN SHIPMENT_ORDER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SHIPMENT_ORDER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SHIPMENT_ORDER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SHIPMENT_ORDER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SHIPMENT_ORDER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_shipment_order_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SHIPMENT_ORDER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SHIPMENT_ORDER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SHIPMENT_ORDER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SHIPMENT_ORDER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_shipment_package_iud(p_tip   VARCHAR2, p_row IN SHIPMENT_PACKAGE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SHIPMENT_PACKAGE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SHIPMENT_PACKAGE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SHIPMENT_PACKAGE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SHIPMENT_PACKAGE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_shipment_package_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SHIPMENT_PACKAGE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SHIPMENT_PACKAGE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SHIPMENT_PACKAGE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SHIPMENT_PACKAGE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_so_detail_iud(p_tip   VARCHAR2, p_row IN SO_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE SO_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO SO_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO SO_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM SO_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_so_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_SO_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE SO_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO SO_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM SO_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_status_history_iud(p_tip   VARCHAR2, p_row IN STATUS_HISTORY%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STATUS_HISTORY SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STATUS_HISTORY VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STATUS_HISTORY VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STATUS_HISTORY WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_status_history_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STATUS_HISTORY)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STATUS_HISTORY SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STATUS_HISTORY VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STATUS_HISTORY WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_stg_bom_std_iud(p_tip   VARCHAR2, p_row IN STG_BOM_STD%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STG_BOM_STD SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STG_BOM_STD VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STG_BOM_STD VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STG_BOM_STD WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_stg_bom_std_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STG_BOM_STD)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STG_BOM_STD SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STG_BOM_STD VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STG_BOM_STD WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_stg_file_manager_iud(p_tip   VARCHAR2, p_row IN STG_FILE_MANAGER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STG_FILE_MANAGER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STG_FILE_MANAGER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STG_FILE_MANAGER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STG_FILE_MANAGER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_stg_file_manager_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STG_FILE_MANAGER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STG_FILE_MANAGER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STG_FILE_MANAGER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STG_FILE_MANAGER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_stg_item_iud(p_tip   VARCHAR2, p_row IN STG_ITEM%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STG_ITEM SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STG_ITEM VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STG_ITEM VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STG_ITEM WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_stg_item_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STG_ITEM)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STG_ITEM SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STG_ITEM VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STG_ITEM WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_stg_parser_iud(p_tip   VARCHAR2, p_row IN STG_PARSER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STG_PARSER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STG_PARSER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STG_PARSER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STG_PARSER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_stg_parser_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STG_PARSER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STG_PARSER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STG_PARSER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STG_PARSER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_stg_receipt_iud(p_tip   VARCHAR2, p_row IN STG_RECEIPT%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STG_RECEIPT SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STG_RECEIPT VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STG_RECEIPT VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STG_RECEIPT WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_stg_receipt_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STG_RECEIPT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STG_RECEIPT SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STG_RECEIPT VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STG_RECEIPT WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_stg_ship_fifo_iud(p_tip   VARCHAR2, p_row IN STG_SHIP_FIFO%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STG_SHIP_FIFO SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STG_SHIP_FIFO VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STG_SHIP_FIFO VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STG_SHIP_FIFO WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_stg_ship_fifo_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STG_SHIP_FIFO)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STG_SHIP_FIFO SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STG_SHIP_FIFO VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STG_SHIP_FIFO WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_stg_work_order_iud(p_tip   VARCHAR2, p_row IN STG_WORK_ORDER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STG_WORK_ORDER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STG_WORK_ORDER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STG_WORK_ORDER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STG_WORK_ORDER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_stg_work_order_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STG_WORK_ORDER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STG_WORK_ORDER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STG_WORK_ORDER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STG_WORK_ORDER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_stg_wo_decl_iud(p_tip   VARCHAR2, p_row IN STG_WO_DECL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE STG_WO_DECL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO STG_WO_DECL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO STG_WO_DECL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM STG_WO_DECL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_stg_wo_decl_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_STG_WO_DECL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE STG_WO_DECL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO STG_WO_DECL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM STG_WO_DECL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_teh_variable_iud(p_tip   VARCHAR2, p_row IN TEH_VARIABLE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE TEH_VARIABLE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO TEH_VARIABLE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO TEH_VARIABLE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM TEH_VARIABLE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_teh_variable_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_TEH_VARIABLE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE TEH_VARIABLE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO TEH_VARIABLE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM TEH_VARIABLE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_trn_plan_detail_iud(p_tip   VARCHAR2, p_row IN TRN_PLAN_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE TRN_PLAN_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO TRN_PLAN_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO TRN_PLAN_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM TRN_PLAN_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_trn_plan_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_TRN_PLAN_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE TRN_PLAN_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO TRN_PLAN_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM TRN_PLAN_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_trn_plan_header_iud(p_tip   VARCHAR2, p_row IN TRN_PLAN_HEADER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE TRN_PLAN_HEADER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO TRN_PLAN_HEADER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO TRN_PLAN_HEADER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM TRN_PLAN_HEADER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_trn_plan_header_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_TRN_PLAN_HEADER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE TRN_PLAN_HEADER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO TRN_PLAN_HEADER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM TRN_PLAN_HEADER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_value_ad_tax_iud(p_tip   VARCHAR2, p_row IN VALUE_AD_TAX%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE VALUE_AD_TAX SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO VALUE_AD_TAX VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO VALUE_AD_TAX VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM VALUE_AD_TAX WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_value_ad_tax_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VALUE_AD_TAX)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE VALUE_AD_TAX SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VALUE_AD_TAX VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM VALUE_AD_TAX WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_virtual_table_iud(p_tip   VARCHAR2, p_row IN VIRTUAL_TABLE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE VIRTUAL_TABLE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO VIRTUAL_TABLE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO VIRTUAL_TABLE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM VIRTUAL_TABLE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_virtual_table_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VIRTUAL_TABLE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE VIRTUAL_TABLE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VIRTUAL_TABLE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM VIRTUAL_TABLE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_vw_blo_grp_assoc_chk_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_BLO_GRP_ASSOC_CHK)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_BLO_GRP_ASSOC_CHK VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_blo_import_wo_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_BLO_IMPORT_WO)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_BLO_IMPORT_WO VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_blo_prepare_trn_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_BLO_PREPARE_TRN)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_BLO_PREPARE_TRN VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_blo_work_group_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_BLO_WORK_GROUP)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_BLO_WORK_GROUP VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_blo_work_order_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_BLO_WORK_ORDER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_BLO_WORK_ORDER VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_excel_operations_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_EXCEL_OPERATIONS)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_EXCEL_OPERATIONS VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_prep_pick_plan_iud(p_tip   VARCHAR2, p_row IN VW_PREP_PICK_PLAN%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE VW_PREP_PICK_PLAN SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO VW_PREP_PICK_PLAN VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO VW_PREP_PICK_PLAN VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM VW_PREP_PICK_PLAN WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_vw_prep_pick_plan_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_PREP_PICK_PLAN)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE VW_PREP_PICK_PLAN SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_PREP_PICK_PLAN VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM VW_PREP_PICK_PLAN WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_vw_rep_bom_std_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_BOM_STD)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_BOM_STD VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_deliv_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_DELIV)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_DELIV VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_fa_sheet_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_FA_SHEET)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_FA_SHEET VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_fifo_reg_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_FIFO_REG)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_FIFO_REG VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_grp_sheet_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_GRP_SHEET)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_GRP_SHEET VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_inv_list_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_INV_LIST)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_INV_LIST VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_pkg_sit_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_PKG_SIT)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_PKG_SIT VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_po_order_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_PO_ORDER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_PO_ORDER VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_wip_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_WIP)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_WIP VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_rep_wip_grouped_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_REP_WIP_GROUPED)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_REP_WIP_GROUPED VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_vw_wiz_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_VW_WIZ)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            NULL;
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO VW_WIZ VALUES p_it_row(i);
        WHEN 'D' THEN 
            NULL;
    END CASE;
END;
PROCEDURE p_warehouse_iud(p_tip   VARCHAR2, p_row IN WAREHOUSE%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WAREHOUSE SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WAREHOUSE VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WAREHOUSE VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WAREHOUSE WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_warehouse_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WAREHOUSE)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WAREHOUSE SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WAREHOUSE VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WAREHOUSE WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_warehouse_categ_iud(p_tip   VARCHAR2, p_row IN WAREHOUSE_CATEG%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WAREHOUSE_CATEG SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WAREHOUSE_CATEG VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WAREHOUSE_CATEG VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WAREHOUSE_CATEG WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_warehouse_categ_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WAREHOUSE_CATEG)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WAREHOUSE_CATEG SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WAREHOUSE_CATEG VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WAREHOUSE_CATEG WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_web_grid_cm_iud(p_tip   VARCHAR2, p_row IN WEB_GRID_CM%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WEB_GRID_CM SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WEB_GRID_CM VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WEB_GRID_CM VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WEB_GRID_CM WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_web_grid_cm_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WEB_GRID_CM)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WEB_GRID_CM SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WEB_GRID_CM VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WEB_GRID_CM WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_whs_trn_iud(p_tip   VARCHAR2, p_row IN WHS_TRN%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WHS_TRN SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WHS_TRN VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WHS_TRN VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WHS_TRN WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_whs_trn_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WHS_TRN)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WHS_TRN SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WHS_TRN VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WHS_TRN WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_whs_trn_detail_iud(p_tip   VARCHAR2, p_row IN WHS_TRN_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WHS_TRN_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WHS_TRN_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WHS_TRN_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WHS_TRN_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_whs_trn_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WHS_TRN_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WHS_TRN_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WHS_TRN_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WHS_TRN_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_whs_trn_reason_iud(p_tip   VARCHAR2, p_row IN WHS_TRN_REASON%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WHS_TRN_REASON SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WHS_TRN_REASON VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WHS_TRN_REASON VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WHS_TRN_REASON WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_whs_trn_reason_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WHS_TRN_REASON)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WHS_TRN_REASON SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WHS_TRN_REASON VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WHS_TRN_REASON WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_wiz_control_iud(p_tip   VARCHAR2, p_row IN WIZ_CONTROL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WIZ_CONTROL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WIZ_CONTROL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WIZ_CONTROL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WIZ_CONTROL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_wiz_control_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WIZ_CONTROL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WIZ_CONTROL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WIZ_CONTROL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WIZ_CONTROL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_workcenter_iud(p_tip   VARCHAR2, p_row IN WORKCENTER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WORKCENTER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WORKCENTER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WORKCENTER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WORKCENTER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_workcenter_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WORKCENTER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WORKCENTER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WORKCENTER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WORKCENTER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_workcenter_oper_iud(p_tip   VARCHAR2, p_row IN WORKCENTER_OPER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WORKCENTER_OPER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WORKCENTER_OPER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WORKCENTER_OPER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WORKCENTER_OPER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_workcenter_oper_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WORKCENTER_OPER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WORKCENTER_OPER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WORKCENTER_OPER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WORKCENTER_OPER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_work_group_iud(p_tip   VARCHAR2, p_row IN WORK_GROUP%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WORK_GROUP SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WORK_GROUP VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WORK_GROUP VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WORK_GROUP WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_work_group_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WORK_GROUP)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WORK_GROUP SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WORK_GROUP VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WORK_GROUP WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_work_order_iud(p_tip   VARCHAR2, p_row IN WORK_ORDER%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WORK_ORDER SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WORK_ORDER VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WORK_ORDER VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WORK_ORDER WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_work_order_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WORK_ORDER)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WORK_ORDER SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WORK_ORDER VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WORK_ORDER WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_work_season_iud(p_tip   VARCHAR2, p_row IN WORK_SEASON%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WORK_SEASON SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WORK_SEASON VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WORK_SEASON VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WORK_SEASON WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_work_season_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WORK_SEASON)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WORK_SEASON SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WORK_SEASON VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WORK_SEASON WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_wo_detail_iud(p_tip   VARCHAR2, p_row IN WO_DETAIL%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WO_DETAIL SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WO_DETAIL VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WO_DETAIL VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WO_DETAIL WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_wo_detail_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WO_DETAIL)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WO_DETAIL SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WO_DETAIL VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WO_DETAIL WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
PROCEDURE p_wo_group_iud(p_tip   VARCHAR2, p_row IN WO_GROUP%ROWTYPE,p_set_line_id BOOLEAN default TRUE)
IS
BEGIN 
    CASE p_tip 
        WHEN 'U' THEN
            UPDATE WO_GROUP SET ROW = p_row  WHERE IDRIGA = p_row.IDRIGA;
        WHEN 'I' THEN
            IF p_set_line_id THEN
                INSERT INTO WO_GROUP VALUES p_row RETURNING IDRIGA INTO Pkg_Glb.v_idriga;
            ELSE 
                INSERT INTO WO_GROUP VALUES p_row ;
            END IF; 
        WHEN 'D' THEN 
            DELETE FROM WO_GROUP WHERE IDRIGA = p_row.IDRIGA; 
    END CASE;
END;
PROCEDURE p_wo_group_miud(p_tip   VARCHAR2, p_it_row IN OUT  NOCOPY PKG_RTYPE.ta_WO_GROUP)
IS
    it_idriga   Pkg_Glb.typ_integer;
BEGIN 
    IF p_it_row.COUNT=0 THEN RETURN; END IF;
    CASE p_tip 
        WHEN 'U' THEN
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).IDRIGA; END LOOP;
            FORALL i IN p_it_row.first..p_it_row.last UPDATE WO_GROUP SET ROW =p_it_row(i) WHERE IDRIGA=it_idriga(i);
        WHEN 'I' THEN
            FORALL i IN p_it_row.first..p_it_row.last INSERT INTO WO_GROUP VALUES p_it_row(i);
        WHEN 'D' THEN 
            FOR i IN p_it_row.first..p_it_row.last LOOP it_idriga(i) :=p_it_row(i).idriga; END LOOP; 
            FORALL i IN p_it_row.first..p_it_row.last DELETE FROM WO_GROUP WHERE IDRIGA=it_idriga(i);
    END CASE;
END;
END; 

/

/
