--------------------------------------------------------
--  DDL for Package Body PKG_TRG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_TRG" 
IS 
--------------------------------------------------------------------
PROCEDURE p_acrec_detail(p_tip VARCHAR2, p_ro IN OUT ACREC_DETAIL%ROWTYPE, p_rn IN OUT ACREC_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ACREC_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.ref_acrec                     := NVL(p_rn.ref_acrec,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.description_item              := NVL(p_rn.description_item,NULL); 
            p_rn.family_code                   := NVL(p_rn.family_code,NULL); 
            p_rn.custom_code                   := NVL(p_rn.custom_code,NULL); 
            p_rn.uom                           := NVL(p_rn.uom,NULL); 
            p_rn.unit_price                    := NVL(p_rn.unit_price,NULL); 
            p_rn.qty_doc                       := NVL(p_rn.qty_doc,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.routing_code                  := NVL(p_rn.routing_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_acrec,p_rn.ref_acrec,m,c,'REF_ACREC'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.description_item,p_rn.description_item,m,c,'DESCRIPTION_ITEM'); 
                 Pkg_Lib.p_c(p_ro.family_code,p_rn.family_code,m,c,'FAMILY_CODE'); 
                 Pkg_Lib.p_c(p_ro.custom_code,p_rn.custom_code,m,c,'CUSTOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.uom,p_rn.uom,m,c,'UOM'); 
                 Pkg_Lib.p_n(p_ro.unit_price,p_rn.unit_price,m,c,'UNIT_PRICE'); 
                 Pkg_Lib.p_n(p_ro.qty_doc,p_rn.qty_doc,m,c,'QTY_DOC'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.routing_code,p_rn.routing_code,m,c,'ROUTING_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ACREC_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'ref_acrec:'||p_ro.ref_acrec||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'description_item:'||p_ro.description_item||','; 
                m   :=  m ||'family_code:'||p_ro.family_code||','; 
                m   :=  m ||'custom_code:'||p_ro.custom_code||','; 
                m   :=  m ||'uom:'||p_ro.uom||','; 
                m   :=  m ||'unit_price:'||p_ro.unit_price||','; 
                m   :=  m ||'qty_doc:'||p_ro.qty_doc||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'routing_code:'||p_ro.routing_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ACREC_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_acrec_header(p_tip VARCHAR2, p_ro IN OUT ACREC_HEADER%ROWTYPE, p_rn IN OUT ACREC_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ACREC_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.acrec_code                    := NVL(p_rn.acrec_code,NULL); 
            p_rn.acrec_date                    := NVL(p_rn.acrec_date,NULL); 
            p_rn.acrec_year                    := NVL(p_rn.acrec_year,NULL); 
            p_rn.acrec_type                    := NVL(p_rn.acrec_type,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.protocol_code                 := NVL(p_rn.protocol_code,NULL); 
            p_rn.protocol_date                 := NVL(p_rn.protocol_date,NULL); 
            p_rn.org_client                    := NVL(p_rn.org_client,NULL); 
            p_rn.org_delivery                  := NVL(p_rn.org_delivery,NULL); 
            p_rn.destin_code                   := NVL(p_rn.destin_code,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.incoterm                      := NVL(p_rn.incoterm,NULL); 
            p_rn.due_date                      := NVL(p_rn.due_date,NULL); 
            p_rn.paymant_type                  := NVL(p_rn.paymant_type,NULL); 
            p_rn.paymant_cond                  := NVL(p_rn.paymant_cond,NULL); 
            p_rn.employee_code                 := NVL(p_rn.employee_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.vat_code                      := NVL(p_rn.vat_code,NULL); 
            p_rn.truck_number                  := NVL(p_rn.truck_number,NULL); 
            p_rn.org_billto                    := NVL(p_rn.org_billto,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.acrec_code,p_rn.acrec_code,m,c,'ACREC_CODE'); 
                 Pkg_Lib.p_d(p_ro.acrec_date,p_rn.acrec_date,m,c,'ACREC_DATE'); 
                 Pkg_Lib.p_c(p_ro.acrec_year,p_rn.acrec_year,m,c,'ACREC_YEAR'); 
                 Pkg_Lib.p_c(p_ro.acrec_type,p_rn.acrec_type,m,c,'ACREC_TYPE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.protocol_code,p_rn.protocol_code,m,c,'PROTOCOL_CODE'); 
                 Pkg_Lib.p_d(p_ro.protocol_date,p_rn.protocol_date,m,c,'PROTOCOL_DATE'); 
                 Pkg_Lib.p_c(p_ro.org_client,p_rn.org_client,m,c,'ORG_CLIENT'); 
                 Pkg_Lib.p_c(p_ro.org_delivery,p_rn.org_delivery,m,c,'ORG_DELIVERY'); 
                 Pkg_Lib.p_c(p_ro.destin_code,p_rn.destin_code,m,c,'DESTIN_CODE'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_c(p_ro.incoterm,p_rn.incoterm,m,c,'INCOTERM'); 
                 Pkg_Lib.p_d(p_ro.due_date,p_rn.due_date,m,c,'DUE_DATE'); 
                 Pkg_Lib.p_c(p_ro.paymant_type,p_rn.paymant_type,m,c,'PAYMANT_TYPE'); 
                 Pkg_Lib.p_c(p_ro.paymant_cond,p_rn.paymant_cond,m,c,'PAYMANT_COND'); 
                 Pkg_Lib.p_c(p_ro.employee_code,p_rn.employee_code,m,c,'EMPLOYEE_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.vat_code,p_rn.vat_code,m,c,'VAT_CODE'); 
                 Pkg_Lib.p_c(p_ro.truck_number,p_rn.truck_number,m,c,'TRUCK_NUMBER'); 
                 Pkg_Lib.p_c(p_ro.org_billto,p_rn.org_billto,m,c,'ORG_BILLTO'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ACREC_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ACREC_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'acrec_code:'||p_ro.acrec_code||','; 
                m   :=  m ||'acrec_date:'||p_ro.acrec_date||','; 
                m   :=  m ||'acrec_year:'||p_ro.acrec_year||','; 
                m   :=  m ||'acrec_type:'||p_ro.acrec_type||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'protocol_code:'||p_ro.protocol_code||','; 
                m   :=  m ||'protocol_date:'||p_ro.protocol_date||','; 
                m   :=  m ||'org_client:'||p_ro.org_client||','; 
                m   :=  m ||'org_delivery:'||p_ro.org_delivery||','; 
                m   :=  m ||'destin_code:'||p_ro.destin_code||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'incoterm:'||p_ro.incoterm||','; 
                m   :=  m ||'due_date:'||p_ro.due_date||','; 
                m   :=  m ||'paymant_type:'||p_ro.paymant_type||','; 
                m   :=  m ||'paymant_cond:'||p_ro.paymant_cond||','; 
                m   :=  m ||'employee_code:'||p_ro.employee_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'vat_code:'||p_ro.vat_code||','; 
                m   :=  m ||'truck_number:'||p_ro.truck_number||','; 
                m   :=  m ||'org_billto:'||p_ro.org_billto||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ACREC_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ACREC_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_ac_account(p_tip VARCHAR2, p_ro IN OUT AC_ACCOUNT%ROWTYPE, p_rn IN OUT AC_ACCOUNT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_AC_ACCOUNT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.account_code                  := NVL(p_rn.account_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.father_code                   := NVL(p_rn.father_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.account_code,p_rn.account_code,m,c,'ACCOUNT_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.father_code,p_rn.father_code,m,c,'FATHER_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'AC_ACCOUNT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ACCOUNT_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'account_code:'||p_ro.account_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'father_code:'||p_ro.father_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'AC_ACCOUNT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ACCOUNT_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_ac_detail(p_tip VARCHAR2, p_ro IN OUT AC_DETAIL%ROWTYPE, p_rn IN OUT AC_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_AC_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.ref_ac                        := NVL(p_rn.ref_ac,NULL); 
            p_rn.ref_trn_detail                := NVL(p_rn.ref_trn_detail,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.trn_sign                      := NVL(p_rn.trn_sign,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.qty_doc                       := NVL(p_rn.qty_doc,NULL); 
            p_rn.qty_puom                      := NVL(p_rn.qty_puom,NULL); 
            p_rn.qty_doc_puom                  := NVL(p_rn.qty_doc_puom,NULL); 
            p_rn.unit_price                    := NVL(p_rn.unit_price,NULL); 
            p_rn.unit_price_puom               := NVL(p_rn.unit_price_puom,NULL); 
            p_rn.uom                           := NVL(p_rn.uom,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.account_code                  := NVL(p_rn.account_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_ac,p_rn.ref_ac,m,c,'REF_AC'); 
                 Pkg_Lib.p_n(p_ro.ref_trn_detail,p_rn.ref_trn_detail,m,c,'REF_TRN_DETAIL'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_n(p_ro.trn_sign,p_rn.trn_sign,m,c,'TRN_SIGN'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_n(p_ro.qty_doc,p_rn.qty_doc,m,c,'QTY_DOC'); 
                 Pkg_Lib.p_n(p_ro.qty_puom,p_rn.qty_puom,m,c,'QTY_PUOM'); 
                 Pkg_Lib.p_n(p_ro.qty_doc_puom,p_rn.qty_doc_puom,m,c,'QTY_DOC_PUOM'); 
                 Pkg_Lib.p_n(p_ro.unit_price,p_rn.unit_price,m,c,'UNIT_PRICE'); 
                 Pkg_Lib.p_n(p_ro.unit_price_puom,p_rn.unit_price_puom,m,c,'UNIT_PRICE_PUOM'); 
                 Pkg_Lib.p_c(p_ro.uom,p_rn.uom,m,c,'UOM'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.account_code,p_rn.account_code,m,c,'ACCOUNT_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'AC_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ITEM_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'ref_ac:'||p_ro.ref_ac||','; 
                m   :=  m ||'ref_trn_detail:'||p_ro.ref_trn_detail||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'trn_sign:'||p_ro.trn_sign||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'qty_doc:'||p_ro.qty_doc||','; 
                m   :=  m ||'qty_puom:'||p_ro.qty_puom||','; 
                m   :=  m ||'qty_doc_puom:'||p_ro.qty_doc_puom||','; 
                m   :=  m ||'unit_price:'||p_ro.unit_price||','; 
                m   :=  m ||'unit_price_puom:'||p_ro.unit_price_puom||','; 
                m   :=  m ||'uom:'||p_ro.uom||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'account_code:'||p_ro.account_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'AC_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ITEM_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_ac_document(p_tip VARCHAR2, p_ro IN OUT AC_DOCUMENT%ROWTYPE, p_rn IN OUT AC_DOCUMENT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_AC_DOCUMENT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.doc_type                      := NVL(p_rn.doc_type,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.report_object                 := NVL(p_rn.report_object,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.doc_type,p_rn.doc_type,m,c,'DOC_TYPE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.report_object,p_rn.report_object,m,c,'REPORT_OBJECT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'AC_DOCUMENT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.DOC_TYPE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'doc_type:'||p_ro.doc_type||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'report_object:'||p_ro.report_object||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'AC_DOCUMENT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.DOC_TYPE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_ac_header(p_tip VARCHAR2, p_ro IN OUT AC_HEADER%ROWTYPE, p_rn IN OUT AC_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_AC_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.date_legal                    := NVL(p_rn.date_legal,NULL); 
            p_rn.doc_code                      := NVL(p_rn.doc_code,NULL); 
            p_rn.doc_year                      := NVL(p_rn.doc_year,NULL); 
            p_rn.doc_type                      := NVL(p_rn.doc_type,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.ref_trn                       := NVL(p_rn.ref_trn,NULL); 
            p_rn.ref_org_code                  := NVL(p_rn.ref_org_code,NULL); 
            p_rn.ref_doc_code                  := NVL(p_rn.ref_doc_code,NULL); 
            p_rn.ref_doc_year                  := NVL(p_rn.ref_doc_year,NULL); 
            p_rn.ref_doc_date                  := NVL(p_rn.ref_doc_date,NULL); 
            p_rn.ref_doc_type                  := NVL(p_rn.ref_doc_type,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.employee_code_in              := NVL(p_rn.employee_code_in,NULL); 
            p_rn.employee_code_out             := NVL(p_rn.employee_code_out,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_d(p_ro.date_legal,p_rn.date_legal,m,c,'DATE_LEGAL'); 
                 Pkg_Lib.p_c(p_ro.doc_code,p_rn.doc_code,m,c,'DOC_CODE'); 
                 Pkg_Lib.p_c(p_ro.doc_year,p_rn.doc_year,m,c,'DOC_YEAR'); 
                 Pkg_Lib.p_c(p_ro.doc_type,p_rn.doc_type,m,c,'DOC_TYPE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_n(p_ro.ref_trn,p_rn.ref_trn,m,c,'REF_TRN'); 
                 Pkg_Lib.p_c(p_ro.ref_org_code,p_rn.ref_org_code,m,c,'REF_ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.ref_doc_code,p_rn.ref_doc_code,m,c,'REF_DOC_CODE'); 
                 Pkg_Lib.p_c(p_ro.ref_doc_year,p_rn.ref_doc_year,m,c,'REF_DOC_YEAR'); 
                 Pkg_Lib.p_d(p_ro.ref_doc_date,p_rn.ref_doc_date,m,c,'REF_DOC_DATE'); 
                 Pkg_Lib.p_c(p_ro.ref_doc_type,p_rn.ref_doc_type,m,c,'REF_DOC_TYPE'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_c(p_ro.employee_code_in,p_rn.employee_code_in,m,c,'EMPLOYEE_CODE_IN'); 
                 Pkg_Lib.p_c(p_ro.employee_code_out,p_rn.employee_code_out,m,c,'EMPLOYEE_CODE_OUT'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'AC_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.DOC_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'date_legal:'||p_ro.date_legal||','; 
                m   :=  m ||'doc_code:'||p_ro.doc_code||','; 
                m   :=  m ||'doc_year:'||p_ro.doc_year||','; 
                m   :=  m ||'doc_type:'||p_ro.doc_type||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'ref_trn:'||p_ro.ref_trn||','; 
                m   :=  m ||'ref_org_code:'||p_ro.ref_org_code||','; 
                m   :=  m ||'ref_doc_code:'||p_ro.ref_doc_code||','; 
                m   :=  m ||'ref_doc_year:'||p_ro.ref_doc_year||','; 
                m   :=  m ||'ref_doc_date:'||p_ro.ref_doc_date||','; 
                m   :=  m ||'ref_doc_type:'||p_ro.ref_doc_type||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'employee_code_in:'||p_ro.employee_code_in||','; 
                m   :=  m ||'employee_code_out:'||p_ro.employee_code_out||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'AC_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.DOC_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_ac_period(p_tip VARCHAR2, p_ro IN OUT AC_PERIOD%ROWTYPE, p_rn IN OUT AC_PERIOD%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_AC_PERIOD.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.period_type                   := NVL(p_rn.period_type,NULL); 
            p_rn.period_code                   := NVL(p_rn.period_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.start_date                    := NVL(p_rn.start_date,NULL); 
            p_rn.end_date                      := NVL(p_rn.end_date,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.period_type,p_rn.period_type,m,c,'PERIOD_TYPE'); 
                 Pkg_Lib.p_c(p_ro.period_code,p_rn.period_code,m,c,'PERIOD_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_d(p_ro.start_date,p_rn.start_date,m,c,'START_DATE'); 
                 Pkg_Lib.p_d(p_ro.end_date,p_rn.end_date,m,c,'END_DATE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'AC_PERIOD',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.PERIOD_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'period_type:'||p_ro.period_type||','; 
                m   :=  m ||'period_code:'||p_ro.period_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'start_date:'||p_ro.start_date||','; 
                m   :=  m ||'end_date:'||p_ro.end_date||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'AC_PERIOD',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.PERIOD_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_audit(p_tip VARCHAR2, p_ro IN OUT APP_AUDIT%ROWTYPE, p_rn IN OUT APP_AUDIT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_AUDIT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.tbl_name                      := NVL(p_rn.tbl_name,NULL); 
            p_rn.tbl_idriga                    := NVL(p_rn.tbl_idriga,NULL); 
            p_rn.tbl_idx1                      := NVL(p_rn.tbl_idx1,NULL); 
            p_rn.tbl_idx2                      := NVL(p_rn.tbl_idx2,NULL); 
            p_rn.tbl_oper                      := NVL(p_rn.tbl_oper,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.tbl_name,p_rn.tbl_name,m,c,'TBL_NAME'); 
                 Pkg_Lib.p_n(p_ro.tbl_idriga,p_rn.tbl_idriga,m,c,'TBL_IDRIGA'); 
                 Pkg_Lib.p_c(p_ro.tbl_idx1,p_rn.tbl_idx1,m,c,'TBL_IDX1'); 
                 Pkg_Lib.p_c(p_ro.tbl_idx2,p_rn.tbl_idx2,m,c,'TBL_IDX2'); 
                 Pkg_Lib.p_c(p_ro.tbl_oper,p_rn.tbl_oper,m,c,'TBL_OPER'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_AUDIT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'tbl_name:'||p_ro.tbl_name||','; 
                m   :=  m ||'tbl_idriga:'||p_ro.tbl_idriga||','; 
                m   :=  m ||'tbl_idx1:'||p_ro.tbl_idx1||','; 
                m   :=  m ||'tbl_idx2:'||p_ro.tbl_idx2||','; 
                m   :=  m ||'tbl_oper:'||p_ro.tbl_oper||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_AUDIT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_doc_number(p_tip VARCHAR2, p_ro IN OUT APP_DOC_NUMBER%ROWTYPE, p_rn IN OUT APP_DOC_NUMBER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_DOC_NUMBER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.doc_type                      := NVL(p_rn.doc_type,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.num_year                      := NVL(p_rn.num_year,NULL); 
            p_rn.num_start                     := NVL(p_rn.num_start,NULL); 
            p_rn.num_end                       := NVL(p_rn.num_end,NULL); 
            p_rn.num_current                   := NVL(p_rn.num_current,NULL); 
            p_rn.doc_subtype                   := NVL(p_rn.doc_subtype,NULL); 
            p_rn.num_prefix                    := NVL(p_rn.num_prefix,NULL); 
            p_rn.num_lenght                    := NVL(p_rn.num_lenght,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.doc_type,p_rn.doc_type,m,c,'DOC_TYPE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.num_year,p_rn.num_year,m,c,'NUM_YEAR'); 
                 Pkg_Lib.p_n(p_ro.num_start,p_rn.num_start,m,c,'NUM_START'); 
                 Pkg_Lib.p_n(p_ro.num_end,p_rn.num_end,m,c,'NUM_END'); 
                 Pkg_Lib.p_n(p_ro.num_current,p_rn.num_current,m,c,'NUM_CURRENT'); 
                 Pkg_Lib.p_c(p_ro.doc_subtype,p_rn.doc_subtype,m,c,'DOC_SUBTYPE'); 
                 Pkg_Lib.p_c(p_ro.num_prefix,p_rn.num_prefix,m,c,'NUM_PREFIX'); 
                 Pkg_Lib.p_n(p_ro.num_lenght,p_rn.num_lenght,m,c,'NUM_LENGHT'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_DOC_NUMBER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.DOC_TYPE,
                        p_tbl_idx2     =>  p_ro.DOC_SUBTYPE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'doc_type:'||p_ro.doc_type||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'num_year:'||p_ro.num_year||','; 
                m   :=  m ||'num_start:'||p_ro.num_start||','; 
                m   :=  m ||'num_end:'||p_ro.num_end||','; 
                m   :=  m ||'num_current:'||p_ro.num_current||','; 
                m   :=  m ||'doc_subtype:'||p_ro.doc_subtype||','; 
                m   :=  m ||'num_prefix:'||p_ro.num_prefix||','; 
                m   :=  m ||'num_lenght:'||p_ro.num_lenght||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_DOC_NUMBER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.DOC_TYPE,
                        p_tbl_idx2     =>  p_ro.DOC_SUBTYPE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_exceptions(p_tip VARCHAR2, p_ro IN OUT APP_EXCEPTIONS%ROWTYPE, p_rn IN OUT APP_EXCEPTIONS%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_EXCEPTIONS.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sqlcode                       := NVL(p_rn.sqlcode,NULL); 
            p_rn.num_excep                     := NVL(p_rn.num_excep,NULL); 
            p_rn.num_tabel                     := NVL(p_rn.num_tabel,NULL); 
            p_rn.num_col                       := NVL(p_rn.num_col,NULL); 
            p_rn.err_msg                       := NVL(p_rn.err_msg,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.sqlcode,p_rn.sqlcode,m,c,'SQLCODE'); 
                 Pkg_Lib.p_c(p_ro.num_excep,p_rn.num_excep,m,c,'NUM_EXCEP'); 
                 Pkg_Lib.p_c(p_ro.num_tabel,p_rn.num_tabel,m,c,'NUM_TABEL'); 
                 Pkg_Lib.p_c(p_ro.num_col,p_rn.num_col,m,c,'NUM_COL'); 
                 Pkg_Lib.p_c(p_ro.err_msg,p_rn.err_msg,m,c,'ERR_MSG'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_EXCEPTIONS',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sqlcode:'||p_ro.sqlcode||','; 
                m   :=  m ||'num_excep:'||p_ro.num_excep||','; 
                m   :=  m ||'num_tabel:'||p_ro.num_tabel||','; 
                m   :=  m ||'num_col:'||p_ro.num_col||','; 
                m   :=  m ||'err_msg:'||p_ro.err_msg||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_EXCEPTIONS',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_securitem(p_tip VARCHAR2, p_ro IN OUT APP_SECURITEM%ROWTYPE, p_rn IN OUT APP_SECURITEM%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_SECURITEM.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.securitem_code                := NVL(p_rn.securitem_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.securitem_type                := NVL(p_rn.securitem_type,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.securitem_code,p_rn.securitem_code,m,c,'SECURITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.securitem_type,p_rn.securitem_type,m,c,'SECURITEM_TYPE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_SECURITEM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'securitem_code:'||p_ro.securitem_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'securitem_type:'||p_ro.securitem_type||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_SECURITEM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_task(p_tip VARCHAR2, p_ro IN OUT APP_TASK%ROWTYPE, p_rn IN OUT APP_TASK%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_TASK.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.form_name                     := NVL(p_rn.form_name,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.task_code                     := NVL(p_rn.task_code,NULL); 
            p_rn.caption                       := NVL(p_rn.caption,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.form_name,p_rn.form_name,m,c,'FORM_NAME'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.task_code,p_rn.task_code,m,c,'TASK_CODE'); 
                 Pkg_Lib.p_c(p_ro.caption,p_rn.caption,m,c,'CAPTION'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_TASK',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'form_name:'||p_ro.form_name||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'task_code:'||p_ro.task_code||','; 
                m   :=  m ||'caption:'||p_ro.caption||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_TASK',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_task_param(p_tip VARCHAR2, p_ro IN OUT APP_TASK_PARAM%ROWTYPE, p_rn IN OUT APP_TASK_PARAM%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_TASK_PARAM.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.task_code                     := NVL(p_rn.task_code,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.caption                       := NVL(p_rn.caption,NULL); 
            p_rn.field_value                   := NVL(p_rn.field_value,NULL); 
            p_rn.field_type                    := NVL(p_rn.field_type,NULL); 
            p_rn.src_form                      := NVL(p_rn.src_form,NULL); 
            p_rn.editable                      := NVL(p_rn.editable,NULL); 
            p_rn.lov_select                    := NVL(p_rn.lov_select,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.task_code,p_rn.task_code,m,c,'TASK_CODE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.caption,p_rn.caption,m,c,'CAPTION'); 
                 Pkg_Lib.p_c(p_ro.field_value,p_rn.field_value,m,c,'FIELD_VALUE'); 
                 Pkg_Lib.p_c(p_ro.field_type,p_rn.field_type,m,c,'FIELD_TYPE'); 
                 Pkg_Lib.p_c(p_ro.src_form,p_rn.src_form,m,c,'SRC_FORM'); 
                 Pkg_Lib.p_c(p_ro.editable,p_rn.editable,m,c,'EDITABLE'); 
                 Pkg_Lib.p_c(p_ro.lov_select,p_rn.lov_select,m,c,'LOV_SELECT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_TASK_PARAM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'task_code:'||p_ro.task_code||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'caption:'||p_ro.caption||','; 
                m   :=  m ||'field_value:'||p_ro.field_value||','; 
                m   :=  m ||'field_type:'||p_ro.field_type||','; 
                m   :=  m ||'src_form:'||p_ro.src_form||','; 
                m   :=  m ||'editable:'||p_ro.editable||','; 
                m   :=  m ||'lov_select:'||p_ro.lov_select||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_TASK_PARAM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_task_step(p_tip VARCHAR2, p_ro IN OUT APP_TASK_STEP%ROWTYPE, p_rn IN OUT APP_TASK_STEP%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_TASK_STEP.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.task_code                     := NVL(p_rn.task_code,NULL); 
            p_rn.action_type                   := NVL(p_rn.action_type,NULL); 
            p_rn.action_value                  := NVL(p_rn.action_value,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.action_par1                   := NVL(p_rn.action_par1,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.task_code,p_rn.task_code,m,c,'TASK_CODE'); 
                 Pkg_Lib.p_c(p_ro.action_type,p_rn.action_type,m,c,'ACTION_TYPE'); 
                 Pkg_Lib.p_c(p_ro.action_value,p_rn.action_value,m,c,'ACTION_VALUE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.action_par1,p_rn.action_par1,m,c,'ACTION_PAR1'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_TASK_STEP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'task_code:'||p_ro.task_code||','; 
                m   :=  m ||'action_type:'||p_ro.action_type||','; 
                m   :=  m ||'action_value:'||p_ro.action_value||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'action_par1:'||p_ro.action_par1||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_TASK_STEP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_user(p_tip VARCHAR2, p_ro IN OUT APP_USER%ROWTYPE, p_rn IN OUT APP_USER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_USER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.user_code                     := NVL(p_rn.user_code,NULL); 
            p_rn.nume                          := NVL(p_rn.nume,NULL); 
            p_rn.prenume                       := NVL(p_rn.prenume,NULL); 
            p_rn.pwd                           := NVL(p_rn.pwd,NULL); 
            p_rn.default_oper                  := NVL(p_rn.default_oper,NULL); 
            p_rn.pairs_per_day                 := NVL(p_rn.pairs_per_day,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.user_code,p_rn.user_code,m,c,'USER_CODE'); 
                 Pkg_Lib.p_c(p_ro.nume,p_rn.nume,m,c,'NUME'); 
                 Pkg_Lib.p_c(p_ro.prenume,p_rn.prenume,m,c,'PRENUME'); 
                 Pkg_Lib.p_c(p_ro.pwd,p_rn.pwd,m,c,'PWD'); 
                 Pkg_Lib.p_c(p_ro.default_oper,p_rn.default_oper,m,c,'DEFAULT_OPER'); 
                 Pkg_Lib.p_n(p_ro.pairs_per_day,p_rn.pairs_per_day,m,c,'PAIRS_PER_DAY'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_USER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.USER_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'user_code:'||p_ro.user_code||','; 
                m   :=  m ||'nume:'||p_ro.nume||','; 
                m   :=  m ||'prenume:'||p_ro.prenume||','; 
                m   :=  m ||'pwd:'||p_ro.pwd||','; 
                m   :=  m ||'default_oper:'||p_ro.default_oper||','; 
                m   :=  m ||'pairs_per_day:'||p_ro.pairs_per_day||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_USER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.USER_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_app_user_grant(p_tip VARCHAR2, p_ro IN OUT APP_USER_GRANT%ROWTYPE, p_rn IN OUT APP_USER_GRANT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_APP_USER_GRANT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.securitem_code                := NVL(p_rn.securitem_code,NULL); 
            p_rn.user_code                     := NVL(p_rn.user_code,NULL); 
            p_rn.flag_insert                   := NVL(p_rn.flag_insert,0); 
            p_rn.flag_update                   := NVL(p_rn.flag_update,0); 
            p_rn.flag_delete                   := NVL(p_rn.flag_delete,0); 
            p_rn.flag_execute                  := NVL(p_rn.flag_execute,0); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.securitem_code,p_rn.securitem_code,m,c,'SECURITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.user_code,p_rn.user_code,m,c,'USER_CODE'); 
                 Pkg_Lib.p_n(p_ro.flag_insert,p_rn.flag_insert,m,c,'FLAG_INSERT'); 
                 Pkg_Lib.p_n(p_ro.flag_update,p_rn.flag_update,m,c,'FLAG_UPDATE'); 
                 Pkg_Lib.p_n(p_ro.flag_delete,p_rn.flag_delete,m,c,'FLAG_DELETE'); 
                 Pkg_Lib.p_n(p_ro.flag_execute,p_rn.flag_execute,m,c,'FLAG_EXECUTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'APP_USER_GRANT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.USER_CODE,
                        p_tbl_idx2     =>  p_ro.SECURITEM_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'securitem_code:'||p_ro.securitem_code||','; 
                m   :=  m ||'user_code:'||p_ro.user_code||','; 
                m   :=  m ||'flag_insert:'||p_ro.flag_insert||','; 
                m   :=  m ||'flag_update:'||p_ro.flag_update||','; 
                m   :=  m ||'flag_delete:'||p_ro.flag_delete||','; 
                m   :=  m ||'flag_execute:'||p_ro.flag_execute||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'APP_USER_GRANT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.USER_CODE,
                        p_tbl_idx2     =>  p_ro.SECURITEM_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_bom_group(p_tip VARCHAR2, p_ro IN OUT BOM_GROUP%ROWTYPE, p_rn IN OUT BOM_GROUP%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_BOM_GROUP.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_group                     := NVL(p_rn.ref_group,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.qta                           := NVL(p_rn.qta,NULL); 
            p_rn.status                        := NVL(p_rn.status,'A' ); 
            p_rn.whs_supply                    := NVL(p_rn.whs_supply,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.qta_picked                    := NVL(p_rn.qta_picked,0 ); 
            p_rn.scrap_perc                    := NVL(p_rn.scrap_perc,0 ); 
            p_rn.start_size                    := NVL(p_rn.start_size,NULL); 
            p_rn.end_size                      := NVL(p_rn.end_size,NULL); 
            p_rn.qta_demand                    := NVL(p_rn.qta_demand,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_group,p_rn.ref_group,m,c,'REF_GROUP'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta,p_rn.qta,m,c,'QTA'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.whs_supply,p_rn.whs_supply,m,c,'WHS_SUPPLY'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta_picked,p_rn.qta_picked,m,c,'QTA_PICKED'); 
                 Pkg_Lib.p_n(p_ro.scrap_perc,p_rn.scrap_perc,m,c,'SCRAP_PERC'); 
                 Pkg_Lib.p_c(p_ro.start_size,p_rn.start_size,m,c,'START_SIZE'); 
                 Pkg_Lib.p_c(p_ro.end_size,p_rn.end_size,m,c,'END_SIZE'); 
                 Pkg_Lib.p_n(p_ro.qta_demand,p_rn.qta_demand,m,c,'QTA_DEMAND'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'BOM_GROUP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.GROUP_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_group:'||p_ro.ref_group||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'qta:'||p_ro.qta||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'whs_supply:'||p_ro.whs_supply||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'qta_picked:'||p_ro.qta_picked||','; 
                m   :=  m ||'scrap_perc:'||p_ro.scrap_perc||','; 
                m   :=  m ||'start_size:'||p_ro.start_size||','; 
                m   :=  m ||'end_size:'||p_ro.end_size||','; 
                m   :=  m ||'qta_demand:'||p_ro.qta_demand||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'BOM_GROUP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.GROUP_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_bom_std(p_tip VARCHAR2, p_ro IN OUT BOM_STD%ROWTYPE, p_rn IN OUT BOM_STD%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_BOM_STD.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.father_code                   := NVL(p_rn.father_code,NULL); 
            p_rn.qta                           := NVL(p_rn.qta,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.child_code                    := NVL(p_rn.child_code,NULL); 
            p_rn.qta_std                       := NVL(p_rn.qta_std,0 ); 
            p_rn.start_size                    := NVL(p_rn.start_size,NULL); 
            p_rn.end_size                      := NVL(p_rn.end_size,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.father_code,p_rn.father_code,m,c,'FATHER_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta,p_rn.qta,m,c,'QTA'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.child_code,p_rn.child_code,m,c,'CHILD_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta_std,p_rn.qta_std,m,c,'QTA_STD'); 
                 Pkg_Lib.p_c(p_ro.start_size,p_rn.start_size,m,c,'START_SIZE'); 
                 Pkg_Lib.p_c(p_ro.end_size,p_rn.end_size,m,c,'END_SIZE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'BOM_STD',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.FATHER_CODE,
                        p_tbl_idx2     =>  p_ro.CHILD_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'father_code:'||p_ro.father_code||','; 
                m   :=  m ||'qta:'||p_ro.qta||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'child_code:'||p_ro.child_code||','; 
                m   :=  m ||'qta_std:'||p_ro.qta_std||','; 
                m   :=  m ||'start_size:'||p_ro.start_size||','; 
                m   :=  m ||'end_size:'||p_ro.end_size||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'BOM_STD',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.FATHER_CODE,
                        p_tbl_idx2     =>  p_ro.CHILD_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_bom_wo(p_tip VARCHAR2, p_ro IN OUT BOM_WO%ROWTYPE, p_rn IN OUT BOM_WO%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_BOM_WO.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_wo                        := NVL(p_rn.ref_wo,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.qta                           := NVL(p_rn.qta,NULL); 
            p_rn.wip_supply                    := NVL(p_rn.wip_supply,0 ); 
            p_rn.status                        := NVL(p_rn.status,'A' ); 
            p_rn.whs_supply                    := NVL(p_rn.whs_supply,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.qta_picked                    := NVL(p_rn.qta_picked,0 ); 
            p_rn.flag_type                     := NVL(p_rn.flag_type,'N' ); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_wo,p_rn.ref_wo,m,c,'REF_WO'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta,p_rn.qta,m,c,'QTA'); 
                 Pkg_Lib.p_n(p_ro.wip_supply,p_rn.wip_supply,m,c,'WIP_SUPPLY'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.whs_supply,p_rn.whs_supply,m,c,'WHS_SUPPLY'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta_picked,p_rn.qta_picked,m,c,'QTA_PICKED'); 
                 Pkg_Lib.p_c(p_ro.flag_type,p_rn.flag_type,m,c,'FLAG_TYPE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'BOM_WO',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_wo:'||p_ro.ref_wo||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'qta:'||p_ro.qta||','; 
                m   :=  m ||'wip_supply:'||p_ro.wip_supply||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'whs_supply:'||p_ro.whs_supply||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'qta_picked:'||p_ro.qta_picked||','; 
                m   :=  m ||'flag_type:'||p_ro.flag_type||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'BOM_WO',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_calendar(p_tip VARCHAR2, p_ro IN OUT CALENDAR%ROWTYPE, p_rn IN OUT CALENDAR%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_CALENDAR.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.calendar_day                  := NVL(p_rn.calendar_day,NULL); 
            p_rn.flag_work                     := NVL(p_rn.flag_work,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_d(p_ro.calendar_day,p_rn.calendar_day,m,c,'CALENDAR_DAY'); 
                 Pkg_Lib.p_c(p_ro.flag_work,p_rn.flag_work,m,c,'FLAG_WORK'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'CALENDAR',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CALENDAR_DAY,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'calendar_day:'||p_ro.calendar_day||','; 
                m   :=  m ||'flag_work:'||p_ro.flag_work||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'CALENDAR',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CALENDAR_DAY,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_cat_custom(p_tip VARCHAR2, p_ro IN OUT CAT_CUSTOM%ROWTYPE, p_rn IN OUT CAT_CUSTOM%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_CAT_CUSTOM.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.custom_code                   := NVL(p_rn.custom_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.custom_tax                    := NVL(p_rn.custom_tax,0 ); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.custom_code,p_rn.custom_code,m,c,'CUSTOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_n(p_ro.custom_tax,p_rn.custom_tax,m,c,'CUSTOM_TAX'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'CAT_CUSTOM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'custom_code:'||p_ro.custom_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'custom_tax:'||p_ro.custom_tax||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'CAT_CUSTOM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_cat_mat_type(p_tip VARCHAR2, p_ro IN OUT CAT_MAT_TYPE%ROWTYPE, p_rn IN OUT CAT_MAT_TYPE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_CAT_MAT_TYPE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.categ_code                    := NVL(p_rn.categ_code,NULL); 
            p_rn.whs_stock                     := NVL(p_rn.whs_stock,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.category                      := NVL(p_rn.category,NULL); 
            p_rn.flag_virtual                  := NVL(p_rn.flag_virtual,'N' ); 
            p_rn.fifo_round_unit               := NVL(p_rn.fifo_round_unit,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.categ_code,p_rn.categ_code,m,c,'CATEG_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_stock,p_rn.whs_stock,m,c,'WHS_STOCK'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.category,p_rn.category,m,c,'CATEGORY'); 
                 Pkg_Lib.p_c(p_ro.flag_virtual,p_rn.flag_virtual,m,c,'FLAG_VIRTUAL'); 
                 Pkg_Lib.p_c(p_ro.fifo_round_unit,p_rn.fifo_round_unit,m,c,'FIFO_ROUND_UNIT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'CAT_MAT_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CATEG_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'categ_code:'||p_ro.categ_code||','; 
                m   :=  m ||'whs_stock:'||p_ro.whs_stock||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'category:'||p_ro.category||','; 
                m   :=  m ||'flag_virtual:'||p_ro.flag_virtual||','; 
                m   :=  m ||'fifo_round_unit:'||p_ro.fifo_round_unit||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'CAT_MAT_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CATEG_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_colour(p_tip VARCHAR2, p_ro IN OUT COLOUR%ROWTYPE, p_rn IN OUT COLOUR%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_COLOUR.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.category                      := NVL(p_rn.category,NULL); 
            p_rn.colour_code2                  := NVL(p_rn.colour_code2,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.category,p_rn.category,m,c,'CATEGORY'); 
                 Pkg_Lib.p_c(p_ro.colour_code2,p_rn.colour_code2,m,c,'COLOUR_CODE2'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'COLOUR',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.COLOUR_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'category:'||p_ro.category||','; 
                m   :=  m ||'colour_code2:'||p_ro.colour_code2||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'COLOUR',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.COLOUR_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_costcenter(p_tip VARCHAR2, p_ro IN OUT COSTCENTER%ROWTYPE, p_rn IN OUT COSTCENTER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_COSTCENTER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.costcenter_code               := NVL(p_rn.costcenter_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.flag_intern                   := NVL(p_rn.flag_intern,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.manpower_cost                 := NVL(p_rn.manpower_cost,0); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.costcenter_code,p_rn.costcenter_code,m,c,'COSTCENTER_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.flag_intern,p_rn.flag_intern,m,c,'FLAG_INTERN'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_n(p_ro.manpower_cost,p_rn.manpower_cost,m,c,'MANPOWER_COST'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'COSTCENTER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.COSTCENTER_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'costcenter_code:'||p_ro.costcenter_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'flag_intern:'||p_ro.flag_intern||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'manpower_cost:'||p_ro.manpower_cost||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'COSTCENTER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.COSTCENTER_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_cost_detail(p_tip VARCHAR2, p_ro IN OUT COST_DETAIL%ROWTYPE, p_rn IN OUT COST_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_COST_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_cost                      := NVL(p_rn.ref_cost,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.lot_size                      := NVL(p_rn.lot_size,NULL); 
            p_rn.cost_lot                      := NVL(p_rn.cost_lot,NULL); 
            p_rn.qty_stoc                      := NVL(p_rn.qty_stoc,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_cost,p_rn.ref_cost,m,c,'REF_COST'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_n(p_ro.lot_size,p_rn.lot_size,m,c,'LOT_SIZE'); 
                 Pkg_Lib.p_n(p_ro.cost_lot,p_rn.cost_lot,m,c,'COST_LOT'); 
                 Pkg_Lib.p_n(p_ro.qty_stoc,p_rn.qty_stoc,m,c,'QTY_STOC'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'COST_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_cost:'||p_ro.ref_cost||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'lot_size:'||p_ro.lot_size||','; 
                m   :=  m ||'cost_lot:'||p_ro.cost_lot||','; 
                m   :=  m ||'qty_stoc:'||p_ro.qty_stoc||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'COST_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_cost_header(p_tip VARCHAR2, p_ro IN OUT COST_HEADER%ROWTYPE, p_rn IN OUT COST_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_COST_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.cost_type                     := NVL(p_rn.cost_type,NULL); 
            p_rn.cost_year                     := NVL(p_rn.cost_year,NULL); 
            p_rn.cost_month                    := NVL(p_rn.cost_month,NULL); 
            p_rn.currency                      := NVL(p_rn.currency,NULL); 
            p_rn.date_start                    := NVL(p_rn.date_start,NULL); 
            p_rn.date_end                      := NVL(p_rn.date_end,NULL); 
            p_rn.date_create                   := NVL(p_rn.date_create,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.cost_type,p_rn.cost_type,m,c,'COST_TYPE'); 
                 Pkg_Lib.p_c(p_ro.cost_year,p_rn.cost_year,m,c,'COST_YEAR'); 
                 Pkg_Lib.p_c(p_ro.cost_month,p_rn.cost_month,m,c,'COST_MONTH'); 
                 Pkg_Lib.p_c(p_ro.currency,p_rn.currency,m,c,'CURRENCY'); 
                 Pkg_Lib.p_d(p_ro.date_start,p_rn.date_start,m,c,'DATE_START'); 
                 Pkg_Lib.p_d(p_ro.date_end,p_rn.date_end,m,c,'DATE_END'); 
                 Pkg_Lib.p_d(p_ro.date_create,p_rn.date_create,m,c,'DATE_CREATE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'COST_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'cost_type:'||p_ro.cost_type||','; 
                m   :=  m ||'cost_year:'||p_ro.cost_year||','; 
                m   :=  m ||'cost_month:'||p_ro.cost_month||','; 
                m   :=  m ||'currency:'||p_ro.currency||','; 
                m   :=  m ||'date_start:'||p_ro.date_start||','; 
                m   :=  m ||'date_end:'||p_ro.date_end||','; 
                m   :=  m ||'date_create:'||p_ro.date_create||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'COST_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_cost_type(p_tip VARCHAR2, p_ro IN OUT COST_TYPE%ROWTYPE, p_rn IN OUT COST_TYPE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_COST_TYPE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.cost_code                     := NVL(p_rn.cost_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.flag_period                   := NVL(p_rn.flag_period,NULL); 
            p_rn.flag_updatable                := NVL(p_rn.flag_updatable,NULL); 
            p_rn.cost_category                 := NVL(p_rn.cost_category,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.cost_code,p_rn.cost_code,m,c,'COST_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.flag_period,p_rn.flag_period,m,c,'FLAG_PERIOD'); 
                 Pkg_Lib.p_c(p_ro.flag_updatable,p_rn.flag_updatable,m,c,'FLAG_UPDATABLE'); 
                 Pkg_Lib.p_c(p_ro.cost_category,p_rn.cost_category,m,c,'COST_CATEGORY'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'COST_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.COST_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'cost_code:'||p_ro.cost_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'flag_period:'||p_ro.flag_period||','; 
                m   :=  m ||'flag_updatable:'||p_ro.flag_updatable||','; 
                m   :=  m ||'cost_category:'||p_ro.cost_category||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'COST_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.COST_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_country(p_tip VARCHAR2, p_ro IN OUT COUNTRY%ROWTYPE, p_rn IN OUT COUNTRY%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_COUNTRY.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.country_code                  := NVL(p_rn.country_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.flag_eu                       := NVL(p_rn.flag_eu,NULL); 
            p_rn.intrastat                     := NVL(p_rn.intrastat,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.country_code,p_rn.country_code,m,c,'COUNTRY_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.flag_eu,p_rn.flag_eu,m,c,'FLAG_EU'); 
                 Pkg_Lib.p_c(p_ro.intrastat,p_rn.intrastat,m,c,'INTRASTAT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'COUNTRY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'country_code:'||p_ro.country_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'flag_eu:'||p_ro.flag_eu||','; 
                m   :=  m ||'intrastat:'||p_ro.intrastat||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'COUNTRY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_currency(p_tip VARCHAR2, p_ro IN OUT CURRENCY%ROWTYPE, p_rn IN OUT CURRENCY%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_CURRENCY.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'CURRENCY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'CURRENCY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_currency_rate(p_tip VARCHAR2, p_ro IN OUT CURRENCY_RATE%ROWTYPE, p_rn IN OUT CURRENCY_RATE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_CURRENCY_RATE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.calendar_day                  := NVL(p_rn.calendar_day,NULL); 
            p_rn.currency_from                 := NVL(p_rn.currency_from,NULL); 
            p_rn.currency_to                   := NVL(p_rn.currency_to,NULL); 
            p_rn.exchange_rate                 := NVL(p_rn.exchange_rate,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_d(p_ro.calendar_day,p_rn.calendar_day,m,c,'CALENDAR_DAY'); 
                 Pkg_Lib.p_c(p_ro.currency_from,p_rn.currency_from,m,c,'CURRENCY_FROM'); 
                 Pkg_Lib.p_c(p_ro.currency_to,p_rn.currency_to,m,c,'CURRENCY_TO'); 
                 Pkg_Lib.p_n(p_ro.exchange_rate,p_rn.exchange_rate,m,c,'EXCHANGE_RATE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'CURRENCY_RATE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CALENDAR_DAY,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'calendar_day:'||p_ro.calendar_day||','; 
                m   :=  m ||'currency_from:'||p_ro.currency_from||','; 
                m   :=  m ||'currency_to:'||p_ro.currency_to||','; 
                m   :=  m ||'exchange_rate:'||p_ro.exchange_rate||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'CURRENCY_RATE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CALENDAR_DAY,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_custom(p_tip VARCHAR2, p_ro IN OUT CUSTOM%ROWTYPE, p_rn IN OUT CUSTOM%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_CUSTOM.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.custom_code                   := NVL(p_rn.custom_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.supl_um                       := NVL(p_rn.supl_um,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.custom_code,p_rn.custom_code,m,c,'CUSTOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.supl_um,p_rn.supl_um,m,c,'SUPL_UM'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'CUSTOM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CUSTOM_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'custom_code:'||p_ro.custom_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'supl_um:'||p_ro.supl_um||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'CUSTOM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CUSTOM_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_delivery_condition(p_tip VARCHAR2, p_ro IN OUT DELIVERY_CONDITION%ROWTYPE, p_rn IN OUT DELIVERY_CONDITION%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_DELIVERY_CONDITION.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.deliv_cond_code               := NVL(p_rn.deliv_cond_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.deliv_cond_code,p_rn.deliv_cond_code,m,c,'DELIV_COND_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'DELIVERY_CONDITION',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'deliv_cond_code:'||p_ro.deliv_cond_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'DELIVERY_CONDITION',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_efficiency(p_tip VARCHAR2, p_ro IN OUT EFFICIENCY%ROWTYPE, p_rn IN OUT EFFICIENCY%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_EFFICIENCY.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.team_code                     := NVL(p_rn.team_code,NULL); 
            p_rn.work_date                     := NVL(p_rn.work_date,NULL); 
            p_rn.work_hours                    := NVL(p_rn.work_hours,NULL); 
            p_rn.product_hours                 := NVL(p_rn.product_hours,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.team_code,p_rn.team_code,m,c,'TEAM_CODE'); 
                 Pkg_Lib.p_d(p_ro.work_date,p_rn.work_date,m,c,'WORK_DATE'); 
                 Pkg_Lib.p_n(p_ro.work_hours,p_rn.work_hours,m,c,'WORK_HOURS'); 
                 Pkg_Lib.p_n(p_ro.product_hours,p_rn.product_hours,m,c,'PRODUCT_HOURS'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'EFFICIENCY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'team_code:'||p_ro.team_code||','; 
                m   :=  m ||'work_date:'||p_ro.work_date||','; 
                m   :=  m ||'work_hours:'||p_ro.work_hours||','; 
                m   :=  m ||'product_hours:'||p_ro.product_hours||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'EFFICIENCY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_fa_trn(p_tip VARCHAR2, p_ro IN OUT FA_TRN%ROWTYPE, p_rn IN OUT FA_TRN%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_FA_TRN.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.fa_code                       := NVL(p_rn.fa_code,NULL); 
            p_rn.trn_type                      := NVL(p_rn.trn_type,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.trn_date                      := NVL(p_rn.trn_date,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.doc_code                      := NVL(p_rn.doc_code,NULL); 
            p_rn.supplier_code                 := NVL(p_rn.supplier_code,NULL); 
            p_rn.trn_sign                      := NVL(p_rn.trn_sign,NULL); 
            p_rn.trn_value                     := NVL(p_rn.trn_value,NULL); 
            p_rn.trn_currency                  := NVL(p_rn.trn_currency,NULL); 
            p_rn.weight_diff                   := NVL(p_rn.weight_diff,NULL); 
            p_rn.resp_user                     := NVL(p_rn.resp_user,NULL); 
            p_rn.resp_cdc                      := NVL(p_rn.resp_cdc,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.fa_code,p_rn.fa_code,m,c,'FA_CODE'); 
                 Pkg_Lib.p_c(p_ro.trn_type,p_rn.trn_type,m,c,'TRN_TYPE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_d(p_ro.trn_date,p_rn.trn_date,m,c,'TRN_DATE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.doc_code,p_rn.doc_code,m,c,'DOC_CODE'); 
                 Pkg_Lib.p_c(p_ro.supplier_code,p_rn.supplier_code,m,c,'SUPPLIER_CODE'); 
                 Pkg_Lib.p_n(p_ro.trn_sign,p_rn.trn_sign,m,c,'TRN_SIGN'); 
                 Pkg_Lib.p_n(p_ro.trn_value,p_rn.trn_value,m,c,'TRN_VALUE'); 
                 Pkg_Lib.p_c(p_ro.trn_currency,p_rn.trn_currency,m,c,'TRN_CURRENCY'); 
                 Pkg_Lib.p_n(p_ro.weight_diff,p_rn.weight_diff,m,c,'WEIGHT_DIFF'); 
                 Pkg_Lib.p_c(p_ro.resp_user,p_rn.resp_user,m,c,'RESP_USER'); 
                 Pkg_Lib.p_c(p_ro.resp_cdc,p_rn.resp_cdc,m,c,'RESP_CDC'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'FA_TRN',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.FA_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'fa_code:'||p_ro.fa_code||','; 
                m   :=  m ||'trn_type:'||p_ro.trn_type||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'trn_date:'||p_ro.trn_date||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'doc_code:'||p_ro.doc_code||','; 
                m   :=  m ||'supplier_code:'||p_ro.supplier_code||','; 
                m   :=  m ||'trn_sign:'||p_ro.trn_sign||','; 
                m   :=  m ||'trn_value:'||p_ro.trn_value||','; 
                m   :=  m ||'trn_currency:'||p_ro.trn_currency||','; 
                m   :=  m ||'weight_diff:'||p_ro.weight_diff||','; 
                m   :=  m ||'resp_user:'||p_ro.resp_user||','; 
                m   :=  m ||'resp_cdc:'||p_ro.resp_cdc||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'FA_TRN',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.FA_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_fa_trn_type(p_tip VARCHAR2, p_ro IN OUT FA_TRN_TYPE%ROWTYPE, p_rn IN OUT FA_TRN_TYPE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_FA_TRN_TYPE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.trn_type                      := NVL(p_rn.trn_type,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.trn_sign                      := NVL(p_rn.trn_sign,NULL); 
            p_rn.trn_iot                       := NVL(p_rn.trn_iot,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.trn_type,p_rn.trn_type,m,c,'TRN_TYPE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_n(p_ro.trn_sign,p_rn.trn_sign,m,c,'TRN_SIGN'); 
                 Pkg_Lib.p_c(p_ro.trn_iot,p_rn.trn_iot,m,c,'TRN_IOT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'FA_TRN_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.TRN_TYPE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'trn_type:'||p_ro.trn_type||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'trn_sign:'||p_ro.trn_sign||','; 
                m   :=  m ||'trn_iot:'||p_ro.trn_iot||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'FA_TRN_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.TRN_TYPE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_fifo_exceding(p_tip VARCHAR2, p_ro IN OUT FIFO_EXCEDING%ROWTYPE, p_rn IN OUT FIFO_EXCEDING%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_FIFO_EXCEDING.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.ref_shipment                  := NVL(p_rn.ref_shipment,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.ship_subcat                   := NVL(p_rn.ship_subcat,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_shipment,p_rn.ref_shipment,m,c,'REF_SHIPMENT'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_c(p_ro.ship_subcat,p_rn.ship_subcat,m,c,'SHIP_SUBCAT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'FIFO_EXCEDING',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'ref_shipment:'||p_ro.ref_shipment||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'ship_subcat:'||p_ro.ship_subcat||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'FIFO_EXCEDING',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_fifo_material(p_tip VARCHAR2, p_ro IN OUT FIFO_MATERIAL%ROWTYPE, p_rn IN OUT FIFO_MATERIAL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_FIFO_MATERIAL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.ref_receipt                   := NVL(p_rn.ref_receipt,NULL); 
            p_rn.ref_shipment                  := NVL(p_rn.ref_shipment,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.flag_manual                   := NVL(p_rn.flag_manual,NULL); 
            p_rn.ship_subcat                   := NVL(p_rn.ship_subcat,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_n(p_ro.ref_receipt,p_rn.ref_receipt,m,c,'REF_RECEIPT'); 
                 Pkg_Lib.p_n(p_ro.ref_shipment,p_rn.ref_shipment,m,c,'REF_SHIPMENT'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.flag_manual,p_rn.flag_manual,m,c,'FLAG_MANUAL'); 
                 Pkg_Lib.p_c(p_ro.ship_subcat,p_rn.ship_subcat,m,c,'SHIP_SUBCAT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'FIFO_MATERIAL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'ref_receipt:'||p_ro.ref_receipt||','; 
                m   :=  m ||'ref_shipment:'||p_ro.ref_shipment||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'flag_manual:'||p_ro.flag_manual||','; 
                m   :=  m ||'ship_subcat:'||p_ro.ship_subcat||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'FIFO_MATERIAL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_fixed_asset(p_tip VARCHAR2, p_ro IN OUT FIXED_ASSET%ROWTYPE, p_rn IN OUT FIXED_ASSET%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_FIXED_ASSET.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.fa_code                       := NVL(p_rn.fa_code,NULL); 
            p_rn.inventory_code                := NVL(p_rn.inventory_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.category_code                 := NVL(p_rn.category_code,NULL); 
            p_rn.deprec_months                 := NVL(p_rn.deprec_months,0 ); 
            p_rn.deprec_type                   := NVL(p_rn.deprec_type,NULL); 
            p_rn.resp_user                     := NVL(p_rn.resp_user,NULL); 
            p_rn.resp_costcenter               := NVL(p_rn.resp_costcenter,NULL); 
            p_rn.whs_stock                     := NVL(p_rn.whs_stock,NULL); 
            p_rn.weight                        := NVL(p_rn.weight,NULL); 
            p_rn.status                        := NVL(p_rn.status,'I' ); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.date_in                       := NVL(p_rn.date_in,NULL); 
            p_rn.date_start                    := NVL(p_rn.date_start,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.fa_code,p_rn.fa_code,m,c,'FA_CODE'); 
                 Pkg_Lib.p_c(p_ro.inventory_code,p_rn.inventory_code,m,c,'INVENTORY_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.category_code,p_rn.category_code,m,c,'CATEGORY_CODE'); 
                 Pkg_Lib.p_n(p_ro.deprec_months,p_rn.deprec_months,m,c,'DEPREC_MONTHS'); 
                 Pkg_Lib.p_c(p_ro.deprec_type,p_rn.deprec_type,m,c,'DEPREC_TYPE'); 
                 Pkg_Lib.p_c(p_ro.resp_user,p_rn.resp_user,m,c,'RESP_USER'); 
                 Pkg_Lib.p_c(p_ro.resp_costcenter,p_rn.resp_costcenter,m,c,'RESP_COSTCENTER'); 
                 Pkg_Lib.p_c(p_ro.whs_stock,p_rn.whs_stock,m,c,'WHS_STOCK'); 
                 Pkg_Lib.p_n(p_ro.weight,p_rn.weight,m,c,'WEIGHT'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_d(p_ro.date_in,p_rn.date_in,m,c,'DATE_IN'); 
                 Pkg_Lib.p_d(p_ro.date_start,p_rn.date_start,m,c,'DATE_START'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'FIXED_ASSET',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.FA_CODE,
                        p_tbl_idx2     =>  p_ro.INVENTORY_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'fa_code:'||p_ro.fa_code||','; 
                m   :=  m ||'inventory_code:'||p_ro.inventory_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'category_code:'||p_ro.category_code||','; 
                m   :=  m ||'deprec_months:'||p_ro.deprec_months||','; 
                m   :=  m ||'deprec_type:'||p_ro.deprec_type||','; 
                m   :=  m ||'resp_user:'||p_ro.resp_user||','; 
                m   :=  m ||'resp_costcenter:'||p_ro.resp_costcenter||','; 
                m   :=  m ||'whs_stock:'||p_ro.whs_stock||','; 
                m   :=  m ||'weight:'||p_ro.weight||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'date_in:'||p_ro.date_in||','; 
                m   :=  m ||'date_start:'||p_ro.date_start||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'FIXED_ASSET',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.FA_CODE,
                        p_tbl_idx2     =>  p_ro.INVENTORY_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_fixed_asset_categ(p_tip VARCHAR2, p_ro IN OUT FIXED_ASSET_CATEG%ROWTYPE, p_rn IN OUT FIXED_ASSET_CATEG%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_FIXED_ASSET_CATEG.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.category_code                 := NVL(p_rn.category_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.parent_code                   := NVL(p_rn.parent_code,NULL); 
            p_rn.min_months                    := NVL(p_rn.min_months,NULL); 
            p_rn.max_months                    := NVL(p_rn.max_months,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.extended_code                 := NVL(p_rn.extended_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.category_code,p_rn.category_code,m,c,'CATEGORY_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.parent_code,p_rn.parent_code,m,c,'PARENT_CODE'); 
                 Pkg_Lib.p_n(p_ro.min_months,p_rn.min_months,m,c,'MIN_MONTHS'); 
                 Pkg_Lib.p_n(p_ro.max_months,p_rn.max_months,m,c,'MAX_MONTHS'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.extended_code,p_rn.extended_code,m,c,'EXTENDED_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'FIXED_ASSET_CATEG',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CATEGORY_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'category_code:'||p_ro.category_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'parent_code:'||p_ro.parent_code||','; 
                m   :=  m ||'min_months:'||p_ro.min_months||','; 
                m   :=  m ||'max_months:'||p_ro.max_months||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'extended_code:'||p_ro.extended_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'FIXED_ASSET_CATEG',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CATEGORY_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_group_routing(p_tip VARCHAR2, p_ro IN OUT GROUP_ROUTING%ROWTYPE, p_rn IN OUT GROUP_ROUTING%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_GROUP_ROUTING.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_group                     := NVL(p_rn.ref_group,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.whs_cons                      := NVL(p_rn.whs_cons,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.team_code                     := NVL(p_rn.team_code,NULL); 
            p_rn.sched_date                    := NVL(p_rn.sched_date,NULL); 
            p_rn.workcenter_code               := NVL(p_rn.workcenter_code,NULL); 
            p_rn.whs_dest                      := NVL(p_rn.whs_dest,NULL); 
            p_rn.milestone                     := NVL(p_rn.milestone,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_group,p_rn.ref_group,m,c,'REF_GROUP'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_cons,p_rn.whs_cons,m,c,'WHS_CONS'); 
                 Pkg_Lib.p_c(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.team_code,p_rn.team_code,m,c,'TEAM_CODE'); 
                 Pkg_Lib.p_d(p_ro.sched_date,p_rn.sched_date,m,c,'SCHED_DATE'); 
                 Pkg_Lib.p_c(p_ro.workcenter_code,p_rn.workcenter_code,m,c,'WORKCENTER_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_dest,p_rn.whs_dest,m,c,'WHS_DEST'); 
                 Pkg_Lib.p_c(p_ro.milestone,p_rn.milestone,m,c,'MILESTONE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'GROUP_ROUTING',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.GROUP_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_group:'||p_ro.ref_group||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'whs_cons:'||p_ro.whs_cons||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'team_code:'||p_ro.team_code||','; 
                m   :=  m ||'sched_date:'||p_ro.sched_date||','; 
                m   :=  m ||'workcenter_code:'||p_ro.workcenter_code||','; 
                m   :=  m ||'whs_dest:'||p_ro.whs_dest||','; 
                m   :=  m ||'milestone:'||p_ro.milestone||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'GROUP_ROUTING',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.GROUP_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_import_text_file(p_tip VARCHAR2, p_ro IN OUT IMPORT_TEXT_FILE%ROWTYPE, p_rn IN OUT IMPORT_TEXT_FILE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_IMPORT_TEXT_FILE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.file_name                     := NVL(p_rn.file_name,NULL); 
            p_rn.file_id                       := NVL(p_rn.file_id,NULL); 
            p_rn.line_seq                      := NVL(p_rn.line_seq,NULL); 
            p_rn.line_text                     := NVL(p_rn.line_text,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.file_name,p_rn.file_name,m,c,'FILE_NAME'); 
                 Pkg_Lib.p_n(p_ro.file_id,p_rn.file_id,m,c,'FILE_ID'); 
                 Pkg_Lib.p_n(p_ro.line_seq,p_rn.line_seq,m,c,'LINE_SEQ'); 
                 Pkg_Lib.p_c(p_ro.line_text,p_rn.line_text,m,c,'LINE_TEXT'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'IMPORT_TEXT_FILE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'file_name:'||p_ro.file_name||','; 
                m   :=  m ||'file_id:'||p_ro.file_id||','; 
                m   :=  m ||'line_seq:'||p_ro.line_seq||','; 
                m   :=  m ||'line_text:'||p_ro.line_text||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'IMPORT_TEXT_FILE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_inventory(p_tip VARCHAR2, p_ro IN OUT INVENTORY%ROWTYPE, p_rn IN OUT INVENTORY%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_INVENTORY.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.inv_code                      := NVL(p_rn.inv_code,NULL); 
            p_rn.inv_date                      := NVL(p_rn.inv_date,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.date_legal                    := NVL(p_rn.date_legal,NULL); 
            p_rn.inv_type                      := NVL(p_rn.inv_type,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.status                        := NVL(p_rn.status,0 ); 
            p_rn.ref_whs_trn                   := NVL(p_rn.ref_whs_trn,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.inv_code,p_rn.inv_code,m,c,'INV_CODE'); 
                 Pkg_Lib.p_d(p_ro.inv_date,p_rn.inv_date,m,c,'INV_DATE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_d(p_ro.date_legal,p_rn.date_legal,m,c,'DATE_LEGAL'); 
                 Pkg_Lib.p_c(p_ro.inv_type,p_rn.inv_type,m,c,'INV_TYPE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_n(p_ro.ref_whs_trn,p_rn.ref_whs_trn,m,c,'REF_WHS_TRN'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'INVENTORY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'inv_code:'||p_ro.inv_code||','; 
                m   :=  m ||'inv_date:'||p_ro.inv_date||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'date_legal:'||p_ro.date_legal||','; 
                m   :=  m ||'inv_type:'||p_ro.inv_type||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'ref_whs_trn:'||p_ro.ref_whs_trn||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'INVENTORY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_inventory_detail(p_tip VARCHAR2, p_ro IN OUT INVENTORY_DETAIL%ROWTYPE, p_rn IN OUT INVENTORY_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_INVENTORY_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.ref_inventory                 := NVL(p_rn.ref_inventory,NULL); 
            p_rn.sheet_id                      := NVL(p_rn.sheet_id,NULL); 
            p_rn.position_id                   := NVL(p_rn.position_id,NULL); 
            p_rn.inv_type                      := NVL(p_rn.inv_type,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.free_text                     := NVL(p_rn.free_text,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_inventory,p_rn.ref_inventory,m,c,'REF_INVENTORY'); 
                 Pkg_Lib.p_n(p_ro.sheet_id,p_rn.sheet_id,m,c,'SHEET_ID'); 
                 Pkg_Lib.p_n(p_ro.position_id,p_rn.position_id,m,c,'POSITION_ID'); 
                 Pkg_Lib.p_c(p_ro.inv_type,p_rn.inv_type,m,c,'INV_TYPE'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.free_text,p_rn.free_text,m,c,'FREE_TEXT'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'INVENTORY_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'ref_inventory:'||p_ro.ref_inventory||','; 
                m   :=  m ||'sheet_id:'||p_ro.sheet_id||','; 
                m   :=  m ||'position_id:'||p_ro.position_id||','; 
                m   :=  m ||'inv_type:'||p_ro.inv_type||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'free_text:'||p_ro.free_text||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'INVENTORY_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_inventory_setup(p_tip VARCHAR2, p_ro IN OUT INVENTORY_SETUP%ROWTYPE, p_rn IN OUT INVENTORY_SETUP%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_INVENTORY_SETUP.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_inventory                 := NVL(p_rn.ref_inventory,NULL); 
            p_rn.attr_code                     := NVL(p_rn.attr_code,NULL); 
            p_rn.attr_value                    := NVL(p_rn.attr_value,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_inventory,p_rn.ref_inventory,m,c,'REF_INVENTORY'); 
                 Pkg_Lib.p_c(p_ro.attr_code,p_rn.attr_code,m,c,'ATTR_CODE'); 
                 Pkg_Lib.p_c(p_ro.attr_value,p_rn.attr_value,m,c,'ATTR_VALUE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'INVENTORY_SETUP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_inventory:'||p_ro.ref_inventory||','; 
                m   :=  m ||'attr_code:'||p_ro.attr_code||','; 
                m   :=  m ||'attr_value:'||p_ro.attr_value||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'INVENTORY_SETUP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_inventory_stoc(p_tip VARCHAR2, p_ro IN OUT INVENTORY_STOC%ROWTYPE, p_rn IN OUT INVENTORY_STOC%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_INVENTORY_STOC.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.ref_inventory                 := NVL(p_rn.ref_inventory,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.inv_date                      := NVL(p_rn.inv_date,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_inventory,p_rn.ref_inventory,m,c,'REF_INVENTORY'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_d(p_ro.inv_date,p_rn.inv_date,m,c,'INV_DATE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'INVENTORY_STOC',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'ref_inventory:'||p_ro.ref_inventory||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'inv_date:'||p_ro.inv_date||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'INVENTORY_STOC',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_item(p_tip VARCHAR2, p_ro IN OUT ITEM%ROWTYPE, p_rn IN OUT ITEM%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ITEM.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.weight_net                    := NVL(p_rn.weight_net,0 ); 
            p_rn.weight_brut                   := NVL(p_rn.weight_brut,0 ); 
            p_rn.make_buy                      := NVL(p_rn.make_buy,NULL); 
            p_rn.custom_code                   := NVL(p_rn.custom_code,NULL); 
            p_rn.custom_category               := NVL(p_rn.custom_category,NULL); 
            p_rn.reorder_point                 := NVL(p_rn.reorder_point,0 ); 
            p_rn.min_qta                       := NVL(p_rn.min_qta,0 ); 
            p_rn.max_qta                       := NVL(p_rn.max_qta,0 ); 
            p_rn.obs                           := NVL(p_rn.obs,NULL); 
            p_rn.flag_size                     := NVL(p_rn.flag_size,0 ); 
            p_rn.flag_colour                   := NVL(p_rn.flag_colour,0 ); 
            p_rn.flag_range                    := NVL(p_rn.flag_range,0 ); 
            p_rn.start_size                    := NVL(p_rn.start_size,NULL); 
            p_rn.end_size                      := NVL(p_rn.end_size,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL ); 
            p_rn.whs_stock                     := NVL(p_rn.whs_stock,NULL); 
            p_rn.mat_type                      := NVL(p_rn.mat_type,'NECLASIFICAT' ); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.suom                          := NVL(p_rn.suom,NULL); 
            p_rn.uom_conv                      := NVL(p_rn.uom_conv,NULL); 
            p_rn.scrap_perc                    := NVL(p_rn.scrap_perc,0 ); 
            p_rn.uom_receit                    := NVL(p_rn.uom_receit,NULL); 
            p_rn.root_code                     := NVL(p_rn.root_code,NULL); 
            p_rn.item_code2                    := NVL(p_rn.item_code2,NULL); 
            p_rn.valuation_price               := NVL(p_rn.valuation_price,0 ); 
            p_rn.account_code                  := NVL(p_rn.account_code,NULL); 
            p_rn.type_code                     := NVL(p_rn.type_code,NULL); 
            p_rn.account_analytic              := NVL(p_rn.account_analytic,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_n(p_ro.weight_net,p_rn.weight_net,m,c,'WEIGHT_NET'); 
                 Pkg_Lib.p_n(p_ro.weight_brut,p_rn.weight_brut,m,c,'WEIGHT_BRUT'); 
                 Pkg_Lib.p_c(p_ro.make_buy,p_rn.make_buy,m,c,'MAKE_BUY'); 
                 Pkg_Lib.p_c(p_ro.custom_code,p_rn.custom_code,m,c,'CUSTOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.custom_category,p_rn.custom_category,m,c,'CUSTOM_CATEGORY'); 
                 Pkg_Lib.p_n(p_ro.reorder_point,p_rn.reorder_point,m,c,'REORDER_POINT'); 
                 Pkg_Lib.p_n(p_ro.min_qta,p_rn.min_qta,m,c,'MIN_QTA'); 
                 Pkg_Lib.p_n(p_ro.max_qta,p_rn.max_qta,m,c,'MAX_QTA'); 
                 Pkg_Lib.p_c(p_ro.obs,p_rn.obs,m,c,'OBS'); 
                 Pkg_Lib.p_n(p_ro.flag_size,p_rn.flag_size,m,c,'FLAG_SIZE'); 
                 Pkg_Lib.p_n(p_ro.flag_colour,p_rn.flag_colour,m,c,'FLAG_COLOUR'); 
                 Pkg_Lib.p_n(p_ro.flag_range,p_rn.flag_range,m,c,'FLAG_RANGE'); 
                 Pkg_Lib.p_c(p_ro.start_size,p_rn.start_size,m,c,'START_SIZE'); 
                 Pkg_Lib.p_c(p_ro.end_size,p_rn.end_size,m,c,'END_SIZE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_stock,p_rn.whs_stock,m,c,'WHS_STOCK'); 
                 Pkg_Lib.p_c(p_ro.mat_type,p_rn.mat_type,m,c,'MAT_TYPE'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.suom,p_rn.suom,m,c,'SUOM'); 
                 Pkg_Lib.p_n(p_ro.uom_conv,p_rn.uom_conv,m,c,'UOM_CONV'); 
                 Pkg_Lib.p_n(p_ro.scrap_perc,p_rn.scrap_perc,m,c,'SCRAP_PERC'); 
                 Pkg_Lib.p_c(p_ro.uom_receit,p_rn.uom_receit,m,c,'UOM_RECEIT'); 
                 Pkg_Lib.p_c(p_ro.root_code,p_rn.root_code,m,c,'ROOT_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code2,p_rn.item_code2,m,c,'ITEM_CODE2'); 
                 Pkg_Lib.p_n(p_ro.valuation_price,p_rn.valuation_price,m,c,'VALUATION_PRICE'); 
                 Pkg_Lib.p_c(p_ro.account_code,p_rn.account_code,m,c,'ACCOUNT_CODE'); 
                 Pkg_Lib.p_c(p_ro.type_code,p_rn.type_code,m,c,'TYPE_CODE'); 
                 Pkg_Lib.p_c(p_ro.account_analytic,p_rn.account_analytic,m,c,'ACCOUNT_ANALYTIC'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ITEM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ITEM_CODE,
                        p_tbl_idx2     =>  p_ro.ORG_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'weight_net:'||p_ro.weight_net||','; 
                m   :=  m ||'weight_brut:'||p_ro.weight_brut||','; 
                m   :=  m ||'make_buy:'||p_ro.make_buy||','; 
                m   :=  m ||'custom_code:'||p_ro.custom_code||','; 
                m   :=  m ||'custom_category:'||p_ro.custom_category||','; 
                m   :=  m ||'reorder_point:'||p_ro.reorder_point||','; 
                m   :=  m ||'min_qta:'||p_ro.min_qta||','; 
                m   :=  m ||'max_qta:'||p_ro.max_qta||','; 
                m   :=  m ||'obs:'||p_ro.obs||','; 
                m   :=  m ||'flag_size:'||p_ro.flag_size||','; 
                m   :=  m ||'flag_colour:'||p_ro.flag_colour||','; 
                m   :=  m ||'flag_range:'||p_ro.flag_range||','; 
                m   :=  m ||'start_size:'||p_ro.start_size||','; 
                m   :=  m ||'end_size:'||p_ro.end_size||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'whs_stock:'||p_ro.whs_stock||','; 
                m   :=  m ||'mat_type:'||p_ro.mat_type||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'suom:'||p_ro.suom||','; 
                m   :=  m ||'uom_conv:'||p_ro.uom_conv||','; 
                m   :=  m ||'scrap_perc:'||p_ro.scrap_perc||','; 
                m   :=  m ||'uom_receit:'||p_ro.uom_receit||','; 
                m   :=  m ||'root_code:'||p_ro.root_code||','; 
                m   :=  m ||'item_code2:'||p_ro.item_code2||','; 
                m   :=  m ||'valuation_price:'||p_ro.valuation_price||','; 
                m   :=  m ||'account_code:'||p_ro.account_code||','; 
                m   :=  m ||'type_code:'||p_ro.type_code||','; 
                m   :=  m ||'account_analytic:'||p_ro.account_analytic||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ITEM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ITEM_CODE,
                        p_tbl_idx2     =>  p_ro.ORG_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_item_cost(p_tip VARCHAR2, p_ro IN OUT ITEM_COST%ROWTYPE, p_rn IN OUT ITEM_COST%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ITEM_COST.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.family_code                   := NVL(p_rn.family_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.routing_code                  := NVL(p_rn.routing_code,NULL); 
            p_rn.quality                       := NVL(p_rn.quality,NULL); 
            p_rn.partner_code                  := NVL(p_rn.partner_code,NULL); 
            p_rn.unit_cost                     := NVL(p_rn.unit_cost,NULL); 
            p_rn.uom_code                      := NVL(p_rn.uom_code,NULL); 
            p_rn.discount_formula              := NVL(p_rn.discount_formula,NULL); 
            p_rn.condition_formula             := NVL(p_rn.condition_formula,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.cost_code                     := NVL(p_rn.cost_code,NULL); 
            p_rn.start_date                    := NVL(p_rn.start_date,NULL); 
            p_rn.end_date                      := NVL(p_rn.end_date,NULL); 
            p_rn.period_code                   := NVL(p_rn.period_code,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.family_code,p_rn.family_code,m,c,'FAMILY_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.routing_code,p_rn.routing_code,m,c,'ROUTING_CODE'); 
                 Pkg_Lib.p_c(p_ro.quality,p_rn.quality,m,c,'QUALITY'); 
                 Pkg_Lib.p_c(p_ro.partner_code,p_rn.partner_code,m,c,'PARTNER_CODE'); 
                 Pkg_Lib.p_n(p_ro.unit_cost,p_rn.unit_cost,m,c,'UNIT_COST'); 
                 Pkg_Lib.p_c(p_ro.uom_code,p_rn.uom_code,m,c,'UOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.discount_formula,p_rn.discount_formula,m,c,'DISCOUNT_FORMULA'); 
                 Pkg_Lib.p_c(p_ro.condition_formula,p_rn.condition_formula,m,c,'CONDITION_FORMULA'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.cost_code,p_rn.cost_code,m,c,'COST_CODE'); 
                 Pkg_Lib.p_d(p_ro.start_date,p_rn.start_date,m,c,'START_DATE'); 
                 Pkg_Lib.p_d(p_ro.end_date,p_rn.end_date,m,c,'END_DATE'); 
                 Pkg_Lib.p_c(p_ro.period_code,p_rn.period_code,m,c,'PERIOD_CODE'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ITEM_COST',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ITEM_CODE,
                        p_tbl_idx2     =>  p_ro.FAMILY_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'family_code:'||p_ro.family_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'routing_code:'||p_ro.routing_code||','; 
                m   :=  m ||'quality:'||p_ro.quality||','; 
                m   :=  m ||'partner_code:'||p_ro.partner_code||','; 
                m   :=  m ||'unit_cost:'||p_ro.unit_cost||','; 
                m   :=  m ||'uom_code:'||p_ro.uom_code||','; 
                m   :=  m ||'discount_formula:'||p_ro.discount_formula||','; 
                m   :=  m ||'condition_formula:'||p_ro.condition_formula||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'cost_code:'||p_ro.cost_code||','; 
                m   :=  m ||'start_date:'||p_ro.start_date||','; 
                m   :=  m ||'end_date:'||p_ro.end_date||','; 
                m   :=  m ||'period_code:'||p_ro.period_code||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ITEM_COST',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ITEM_CODE,
                        p_tbl_idx2     =>  p_ro.FAMILY_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_item_cycle_time(p_tip VARCHAR2, p_ro IN OUT ITEM_CYCLE_TIME%ROWTYPE, p_rn IN OUT ITEM_CYCLE_TIME%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ITEM_CYCLE_TIME.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.oper_time                     := NVL(p_rn.oper_time,0 ); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_n(p_ro.oper_time,p_rn.oper_time,m,c,'OPER_TIME'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ITEM_CYCLE_TIME',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'oper_time:'||p_ro.oper_time||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ITEM_CYCLE_TIME',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_item_mapping(p_tip VARCHAR2, p_ro IN OUT ITEM_MAPPING%ROWTYPE, p_rn IN OUT ITEM_MAPPING%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ITEM_MAPPING.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.org_code_src                  := NVL(p_rn.org_code_src,NULL); 
            p_rn.item_code_src                 := NVL(p_rn.item_code_src,NULL); 
            p_rn.org_code_dst                  := NVL(p_rn.org_code_dst,NULL); 
            p_rn.item_code_dst                 := NVL(p_rn.item_code_dst,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.puom_dst                      := NVL(p_rn.puom_dst,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code_src,p_rn.org_code_src,m,c,'ORG_CODE_SRC'); 
                 Pkg_Lib.p_c(p_ro.item_code_src,p_rn.item_code_src,m,c,'ITEM_CODE_SRC'); 
                 Pkg_Lib.p_c(p_ro.org_code_dst,p_rn.org_code_dst,m,c,'ORG_CODE_DST'); 
                 Pkg_Lib.p_c(p_ro.item_code_dst,p_rn.item_code_dst,m,c,'ITEM_CODE_DST'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_c(p_ro.puom_dst,p_rn.puom_dst,m,c,'PUOM_DST'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ITEM_MAPPING',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'org_code_src:'||p_ro.org_code_src||','; 
                m   :=  m ||'item_code_src:'||p_ro.item_code_src||','; 
                m   :=  m ||'org_code_dst:'||p_ro.org_code_dst||','; 
                m   :=  m ||'item_code_dst:'||p_ro.item_code_dst||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'puom_dst:'||p_ro.puom_dst||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ITEM_MAPPING',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_item_size(p_tip VARCHAR2, p_ro IN OUT ITEM_SIZE%ROWTYPE, p_rn IN OUT ITEM_SIZE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ITEM_SIZE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ITEM_SIZE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.SIZE_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ITEM_SIZE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.SIZE_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_item_type(p_tip VARCHAR2, p_ro IN OUT ITEM_TYPE%ROWTYPE, p_rn IN OUT ITEM_TYPE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ITEM_TYPE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.type_code                     := NVL(p_rn.type_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.type_code,p_rn.type_code,m,c,'TYPE_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ITEM_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.TYPE_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'type_code:'||p_ro.type_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ITEM_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.TYPE_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_item_variable(p_tip VARCHAR2, p_ro IN OUT ITEM_VARIABLE%ROWTYPE, p_rn IN OUT ITEM_VARIABLE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ITEM_VARIABLE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.var_code                      := NVL(p_rn.var_code,NULL); 
            p_rn.var_value                     := NVL(p_rn.var_value,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.var_code,p_rn.var_code,m,c,'VAR_CODE'); 
                 Pkg_Lib.p_c(p_ro.var_value,p_rn.var_value,m,c,'VAR_VALUE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ITEM_VARIABLE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'var_code:'||p_ro.var_code||','; 
                m   :=  m ||'var_value:'||p_ro.var_value||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ITEM_VARIABLE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_line(p_tip VARCHAR2, p_ro IN OUT LINE%ROWTYPE, p_rn IN OUT LINE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_LINE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.line_code                     := NVL(p_rn.line_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.line_code,p_rn.line_code,m,c,'LINE_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'LINE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'line_code:'||p_ro.line_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'LINE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_macrorouting_detail(p_tip VARCHAR2, p_ro IN OUT MACROROUTING_DETAIL%ROWTYPE, p_rn IN OUT MACROROUTING_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_MACROROUTING_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.routing_code                  := NVL(p_rn.routing_code,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.workcenter_code               := NVL(p_rn.workcenter_code,NULL); 
            p_rn.flag_selected                 := NVL(p_rn.flag_selected,'Y' ); 
            p_rn.flag_milestone                := NVL(p_rn.flag_milestone,'N' ); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.routing_code,p_rn.routing_code,m,c,'ROUTING_CODE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.workcenter_code,p_rn.workcenter_code,m,c,'WORKCENTER_CODE'); 
                 Pkg_Lib.p_c(p_ro.flag_selected,p_rn.flag_selected,m,c,'FLAG_SELECTED'); 
                 Pkg_Lib.p_c(p_ro.flag_milestone,p_rn.flag_milestone,m,c,'FLAG_MILESTONE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'MACROROUTING_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ROUTING_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'routing_code:'||p_ro.routing_code||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'workcenter_code:'||p_ro.workcenter_code||','; 
                m   :=  m ||'flag_selected:'||p_ro.flag_selected||','; 
                m   :=  m ||'flag_milestone:'||p_ro.flag_milestone||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'MACROROUTING_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ROUTING_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_macrorouting_header(p_tip VARCHAR2, p_ro IN OUT MACROROUTING_HEADER%ROWTYPE, p_rn IN OUT MACROROUTING_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_MACROROUTING_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.routing_code                  := NVL(p_rn.routing_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.routing_code,p_rn.routing_code,m,c,'ROUTING_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'MACROROUTING_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ROUTING_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'routing_code:'||p_ro.routing_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'MACROROUTING_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ROUTING_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_movement_type(p_tip VARCHAR2, p_ro IN OUT MOVEMENT_TYPE%ROWTYPE, p_rn IN OUT MOVEMENT_TYPE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_MOVEMENT_TYPE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.trn_type                      := NVL(p_rn.trn_type,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.flag_plan                     := NVL(p_rn.flag_plan,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.pick_form_index               := NVL(p_rn.pick_form_index,NULL); 
            p_rn.pick_parameter                := NVL(p_rn.pick_parameter,NULL); 
            p_rn.accounting                    := NVL(p_rn.accounting,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.trn_type,p_rn.trn_type,m,c,'TRN_TYPE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.flag_plan,p_rn.flag_plan,m,c,'FLAG_PLAN'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.pick_form_index,p_rn.pick_form_index,m,c,'PICK_FORM_INDEX'); 
                 Pkg_Lib.p_c(p_ro.pick_parameter,p_rn.pick_parameter,m,c,'PICK_PARAMETER'); 
                 Pkg_Lib.p_c(p_ro.accounting,p_rn.accounting,m,c,'ACCOUNTING'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'MOVEMENT_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.TRN_TYPE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'trn_type:'||p_ro.trn_type||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'flag_plan:'||p_ro.flag_plan||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'pick_form_index:'||p_ro.pick_form_index||','; 
                m   :=  m ||'pick_parameter:'||p_ro.pick_parameter||','; 
                m   :=  m ||'accounting:'||p_ro.accounting||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'MOVEMENT_TYPE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.TRN_TYPE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_multi_table(p_tip VARCHAR2, p_ro IN OUT MULTI_TABLE%ROWTYPE, p_rn IN OUT MULTI_TABLE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_MULTI_TABLE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.table_name                    := NVL(p_rn.table_name,NULL); 
            p_rn.table_key                     := NVL(p_rn.table_key,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.flag_active                   := NVL(p_rn.flag_active,NULL); 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.table_name,p_rn.table_name,m,c,'TABLE_NAME'); 
                 Pkg_Lib.p_c(p_ro.table_key,p_rn.table_key,m,c,'TABLE_KEY'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.flag_active,p_rn.flag_active,m,c,'FLAG_ACTIVE'); 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'MULTI_TABLE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'table_name:'||p_ro.table_name||','; 
                m   :=  m ||'table_key:'||p_ro.table_key||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'flag_active:'||p_ro.flag_active||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'MULTI_TABLE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_operation(p_tip VARCHAR2, p_ro IN OUT OPERATION%ROWTYPE, p_rn IN OUT OPERATION%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_OPERATION.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.oper_seq                      := NVL(p_rn.oper_seq,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.oper_seq,p_rn.oper_seq,m,c,'OPER_SEQ'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'OPERATION',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.OPER_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'oper_seq:'||p_ro.oper_seq||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'OPERATION',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.OPER_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_organization(p_tip VARCHAR2, p_ro IN OUT ORGANIZATION%ROWTYPE, p_rn IN OUT ORGANIZATION%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ORGANIZATION.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.org_name                      := NVL(p_rn.org_name,NULL); 
            p_rn.flag_client                   := NVL(p_rn.flag_client,NULL); 
            p_rn.flag_supply                   := NVL(p_rn.flag_supply,NULL); 
            p_rn.country_code                  := NVL(p_rn.country_code,NULL); 
            p_rn.city                          := NVL(p_rn.city,NULL); 
            p_rn.address                       := NVL(p_rn.address,NULL); 
            p_rn.phone                         := NVL(p_rn.phone,NULL); 
            p_rn.fax                           := NVL(p_rn.fax,NULL); 
            p_rn.email                         := NVL(p_rn.email,NULL); 
            p_rn.contact_pers                  := NVL(p_rn.contact_pers,NULL); 
            p_rn.bank                          := NVL(p_rn.bank,NULL); 
            p_rn.bank_account                  := NVL(p_rn.bank_account,NULL); 
            p_rn.fiscal_code                   := NVL(p_rn.fiscal_code,NULL); 
            p_rn.regist_code                   := NVL(p_rn.regist_code,NULL); 
            p_rn.transp_ltime                  := NVL(p_rn.transp_ltime,0 ); 
            p_rn.flag_grp_omog                 := NVL(p_rn.flag_grp_omog,0 ); 
            p_rn.flag_myself                   := NVL(p_rn.flag_myself,NULL); 
            p_rn.flag_lohn                     := NVL(p_rn.flag_lohn,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.flag_sbu                      := NVL(p_rn.flag_sbu,NULL); 
            p_rn.county                        := NVL(p_rn.county,NULL); 
            p_rn.flag_q2                       := NVL(p_rn.flag_q2,'Y'); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_name,p_rn.org_name,m,c,'ORG_NAME'); 
                 Pkg_Lib.p_c(p_ro.flag_client,p_rn.flag_client,m,c,'FLAG_CLIENT'); 
                 Pkg_Lib.p_c(p_ro.flag_supply,p_rn.flag_supply,m,c,'FLAG_SUPPLY'); 
                 Pkg_Lib.p_c(p_ro.country_code,p_rn.country_code,m,c,'COUNTRY_CODE'); 
                 Pkg_Lib.p_c(p_ro.city,p_rn.city,m,c,'CITY'); 
                 Pkg_Lib.p_c(p_ro.address,p_rn.address,m,c,'ADDRESS'); 
                 Pkg_Lib.p_c(p_ro.phone,p_rn.phone,m,c,'PHONE'); 
                 Pkg_Lib.p_c(p_ro.fax,p_rn.fax,m,c,'FAX'); 
                 Pkg_Lib.p_c(p_ro.email,p_rn.email,m,c,'EMAIL'); 
                 Pkg_Lib.p_c(p_ro.contact_pers,p_rn.contact_pers,m,c,'CONTACT_PERS'); 
                 Pkg_Lib.p_c(p_ro.bank,p_rn.bank,m,c,'BANK'); 
                 Pkg_Lib.p_c(p_ro.bank_account,p_rn.bank_account,m,c,'BANK_ACCOUNT'); 
                 Pkg_Lib.p_c(p_ro.fiscal_code,p_rn.fiscal_code,m,c,'FISCAL_CODE'); 
                 Pkg_Lib.p_c(p_ro.regist_code,p_rn.regist_code,m,c,'REGIST_CODE'); 
                 Pkg_Lib.p_n(p_ro.transp_ltime,p_rn.transp_ltime,m,c,'TRANSP_LTIME'); 
                 Pkg_Lib.p_c(p_ro.flag_grp_omog,p_rn.flag_grp_omog,m,c,'FLAG_GRP_OMOG'); 
                 Pkg_Lib.p_c(p_ro.flag_myself,p_rn.flag_myself,m,c,'FLAG_MYSELF'); 
                 Pkg_Lib.p_c(p_ro.flag_lohn,p_rn.flag_lohn,m,c,'FLAG_LOHN'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.flag_sbu,p_rn.flag_sbu,m,c,'FLAG_SBU'); 
                 Pkg_Lib.p_c(p_ro.county,p_rn.county,m,c,'COUNTY'); 
                 Pkg_Lib.p_c(p_ro.flag_q2,p_rn.flag_q2,m,c,'FLAG_Q2'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ORGANIZATION',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ORG_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'org_name:'||p_ro.org_name||','; 
                m   :=  m ||'flag_client:'||p_ro.flag_client||','; 
                m   :=  m ||'flag_supply:'||p_ro.flag_supply||','; 
                m   :=  m ||'country_code:'||p_ro.country_code||','; 
                m   :=  m ||'city:'||p_ro.city||','; 
                m   :=  m ||'address:'||p_ro.address||','; 
                m   :=  m ||'phone:'||p_ro.phone||','; 
                m   :=  m ||'fax:'||p_ro.fax||','; 
                m   :=  m ||'email:'||p_ro.email||','; 
                m   :=  m ||'contact_pers:'||p_ro.contact_pers||','; 
                m   :=  m ||'bank:'||p_ro.bank||','; 
                m   :=  m ||'bank_account:'||p_ro.bank_account||','; 
                m   :=  m ||'fiscal_code:'||p_ro.fiscal_code||','; 
                m   :=  m ||'regist_code:'||p_ro.regist_code||','; 
                m   :=  m ||'transp_ltime:'||p_ro.transp_ltime||','; 
                m   :=  m ||'flag_grp_omog:'||p_ro.flag_grp_omog||','; 
                m   :=  m ||'flag_myself:'||p_ro.flag_myself||','; 
                m   :=  m ||'flag_lohn:'||p_ro.flag_lohn||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'flag_sbu:'||p_ro.flag_sbu||','; 
                m   :=  m ||'county:'||p_ro.county||','; 
                m   :=  m ||'flag_q2:'||p_ro.flag_q2||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ORGANIZATION',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ORG_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_organization_loc(p_tip VARCHAR2, p_ro IN OUT ORGANIZATION_LOC%ROWTYPE, p_rn IN OUT ORGANIZATION_LOC%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_ORGANIZATION_LOC.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.loc_code                      := NVL(p_rn.loc_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.country_code                  := NVL(p_rn.country_code,NULL); 
            p_rn.city                          := NVL(p_rn.city,NULL); 
            p_rn.address                       := NVL(p_rn.address,NULL); 
            p_rn.phone                         := NVL(p_rn.phone,NULL); 
            p_rn.fax                           := NVL(p_rn.fax,NULL); 
            p_rn.email                         := NVL(p_rn.email,NULL); 
            p_rn.contact_pers                  := NVL(p_rn.contact_pers,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.loc_code,p_rn.loc_code,m,c,'LOC_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.country_code,p_rn.country_code,m,c,'COUNTRY_CODE'); 
                 Pkg_Lib.p_c(p_ro.city,p_rn.city,m,c,'CITY'); 
                 Pkg_Lib.p_c(p_ro.address,p_rn.address,m,c,'ADDRESS'); 
                 Pkg_Lib.p_c(p_ro.phone,p_rn.phone,m,c,'PHONE'); 
                 Pkg_Lib.p_c(p_ro.fax,p_rn.fax,m,c,'FAX'); 
                 Pkg_Lib.p_c(p_ro.email,p_rn.email,m,c,'EMAIL'); 
                 Pkg_Lib.p_c(p_ro.contact_pers,p_rn.contact_pers,m,c,'CONTACT_PERS'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'ORGANIZATION_LOC',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ORG_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'loc_code:'||p_ro.loc_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'country_code:'||p_ro.country_code||','; 
                m   :=  m ||'city:'||p_ro.city||','; 
                m   :=  m ||'address:'||p_ro.address||','; 
                m   :=  m ||'phone:'||p_ro.phone||','; 
                m   :=  m ||'fax:'||p_ro.fax||','; 
                m   :=  m ||'email:'||p_ro.email||','; 
                m   :=  m ||'contact_pers:'||p_ro.contact_pers||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'ORGANIZATION_LOC',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ORG_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_package_detail(p_tip VARCHAR2, p_ro IN OUT PACKAGE_DETAIL%ROWTYPE, p_rn IN OUT PACKAGE_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PACKAGE_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.package_code                  := NVL(p_rn.package_code,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.quality                       := NVL(p_rn.quality,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.package_code,p_rn.package_code,m,c,'PACKAGE_CODE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.quality,p_rn.quality,m,c,'QUALITY'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PACKAGE_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.PACKAGE_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'package_code:'||p_ro.package_code||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'quality:'||p_ro.quality||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PACKAGE_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.PACKAGE_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_package_header(p_tip VARCHAR2, p_ro IN OUT PACKAGE_HEADER%ROWTYPE, p_rn IN OUT PACKAGE_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PACKAGE_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.package_code                  := NVL(p_rn.package_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.employee_pack                 := NVL(p_rn.employee_pack,NULL); 
            p_rn.employee_verif                := NVL(p_rn.employee_verif,NULL); 
            p_rn.max_capacity                  := NVL(p_rn.max_capacity,NULL); 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
            p_rn.whs_stock                     := NVL(p_rn.whs_stock,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.package_code,p_rn.package_code,m,c,'PACKAGE_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.employee_pack,p_rn.employee_pack,m,c,'EMPLOYEE_PACK'); 
                 Pkg_Lib.p_c(p_ro.employee_verif,p_rn.employee_verif,m,c,'EMPLOYEE_VERIF'); 
                 Pkg_Lib.p_n(p_ro.max_capacity,p_rn.max_capacity,m,c,'MAX_CAPACITY'); 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                 Pkg_Lib.p_c(p_ro.whs_stock,p_rn.whs_stock,m,c,'WHS_STOCK'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PACKAGE_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.PACKAGE_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'package_code:'||p_ro.package_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'employee_pack:'||p_ro.employee_pack||','; 
                m   :=  m ||'employee_verif:'||p_ro.employee_verif||','; 
                m   :=  m ||'max_capacity:'||p_ro.max_capacity||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                m   :=  m ||'whs_stock:'||p_ro.whs_stock||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PACKAGE_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.PACKAGE_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_package_trn_detail(p_tip VARCHAR2, p_ro IN OUT PACKAGE_TRN_DETAIL%ROWTYPE, p_rn IN OUT PACKAGE_TRN_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PACKAGE_TRN_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.package_code                  := NVL(p_rn.package_code,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.trn_sign                      := NVL(p_rn.trn_sign,NULL); 
            p_rn.ref_trn                       := NVL(p_rn.ref_trn,NULL); 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.package_code,p_rn.package_code,m,c,'PACKAGE_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_n(p_ro.trn_sign,p_rn.trn_sign,m,c,'TRN_SIGN'); 
                 Pkg_Lib.p_n(p_ro.ref_trn,p_rn.ref_trn,m,c,'REF_TRN'); 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PACKAGE_TRN_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'package_code:'||p_ro.package_code||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'trn_sign:'||p_ro.trn_sign||','; 
                m   :=  m ||'ref_trn:'||p_ro.ref_trn||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PACKAGE_TRN_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_package_trn_header(p_tip VARCHAR2, p_ro IN OUT PACKAGE_TRN_HEADER%ROWTYPE, p_rn IN OUT PACKAGE_TRN_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PACKAGE_TRN_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.trn_date                      := NVL(p_rn.trn_date,NULL); 
            p_rn.empl_code                     := NVL(p_rn.empl_code,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.ref_whs_trn                   := NVL(p_rn.ref_whs_trn,NULL); 
            p_rn.ref_shipment                  := NVL(p_rn.ref_shipment,NULL); 
            p_rn.trn_type                      := NVL(p_rn.trn_type,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_d(p_ro.trn_date,p_rn.trn_date,m,c,'TRN_DATE'); 
                 Pkg_Lib.p_c(p_ro.empl_code,p_rn.empl_code,m,c,'EMPL_CODE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_whs_trn,p_rn.ref_whs_trn,m,c,'REF_WHS_TRN'); 
                 Pkg_Lib.p_n(p_ro.ref_shipment,p_rn.ref_shipment,m,c,'REF_SHIPMENT'); 
                 Pkg_Lib.p_c(p_ro.trn_type,p_rn.trn_type,m,c,'TRN_TYPE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PACKAGE_TRN_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'trn_date:'||p_ro.trn_date||','; 
                m   :=  m ||'empl_code:'||p_ro.empl_code||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'ref_whs_trn:'||p_ro.ref_whs_trn||','; 
                m   :=  m ||'ref_shipment:'||p_ro.ref_shipment||','; 
                m   :=  m ||'trn_type:'||p_ro.trn_type||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PACKAGE_TRN_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_parameter(p_tip VARCHAR2, p_ro IN OUT PARAMETER%ROWTYPE, p_rn IN OUT PARAMETER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PARAMETER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.audsid                        := NVL(p_rn.audsid,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.par_code                      := NVL(p_rn.par_code,NULL); 
            p_rn.attribute01                   := NVL(p_rn.attribute01,NULL); 
            p_rn.attribute02                   := NVL(p_rn.attribute02,NULL); 
            p_rn.attribute03                   := NVL(p_rn.attribute03,NULL); 
            p_rn.attribute04                   := NVL(p_rn.attribute04,NULL); 
            p_rn.attribute05                   := NVL(p_rn.attribute05,NULL); 
            p_rn.attribute06                   := NVL(p_rn.attribute06,NULL); 
            p_rn.attribute07                   := NVL(p_rn.attribute07,NULL); 
            p_rn.attribute08                   := NVL(p_rn.attribute08,NULL); 
            p_rn.attribute09                   := NVL(p_rn.attribute09,NULL); 
            p_rn.attribute10                   := NVL(p_rn.attribute10,NULL); 
            p_rn.attribute11                   := NVL(p_rn.attribute11,NULL); 
            p_rn.attribute12                   := NVL(p_rn.attribute12,NULL); 
            p_rn.attribute13                   := NVL(p_rn.attribute13,NULL); 
            p_rn.attribute14                   := NVL(p_rn.attribute14,NULL); 
            p_rn.attribute15                   := NVL(p_rn.attribute15,NULL); 
            p_rn.attribute16                   := NVL(p_rn.attribute16,NULL); 
            p_rn.attribute17                   := NVL(p_rn.attribute17,NULL); 
            p_rn.attribute18                   := NVL(p_rn.attribute18,NULL); 
            p_rn.attribute19                   := NVL(p_rn.attribute19,NULL); 
            p_rn.attribute20                   := NVL(p_rn.attribute20,NULL); 
            p_rn.par_key                       := NVL(p_rn.par_key,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.audsid,p_rn.audsid,m,c,'AUDSID'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.par_code,p_rn.par_code,m,c,'PAR_CODE'); 
                 Pkg_Lib.p_c(p_ro.attribute01,p_rn.attribute01,m,c,'ATTRIBUTE01'); 
                 Pkg_Lib.p_c(p_ro.attribute02,p_rn.attribute02,m,c,'ATTRIBUTE02'); 
                 Pkg_Lib.p_c(p_ro.attribute03,p_rn.attribute03,m,c,'ATTRIBUTE03'); 
                 Pkg_Lib.p_c(p_ro.attribute04,p_rn.attribute04,m,c,'ATTRIBUTE04'); 
                 Pkg_Lib.p_c(p_ro.attribute05,p_rn.attribute05,m,c,'ATTRIBUTE05'); 
                 Pkg_Lib.p_c(p_ro.attribute06,p_rn.attribute06,m,c,'ATTRIBUTE06'); 
                 Pkg_Lib.p_c(p_ro.attribute07,p_rn.attribute07,m,c,'ATTRIBUTE07'); 
                 Pkg_Lib.p_c(p_ro.attribute08,p_rn.attribute08,m,c,'ATTRIBUTE08'); 
                 Pkg_Lib.p_c(p_ro.attribute09,p_rn.attribute09,m,c,'ATTRIBUTE09'); 
                 Pkg_Lib.p_c(p_ro.attribute10,p_rn.attribute10,m,c,'ATTRIBUTE10'); 
                 Pkg_Lib.p_c(p_ro.attribute11,p_rn.attribute11,m,c,'ATTRIBUTE11'); 
                 Pkg_Lib.p_c(p_ro.attribute12,p_rn.attribute12,m,c,'ATTRIBUTE12'); 
                 Pkg_Lib.p_c(p_ro.attribute13,p_rn.attribute13,m,c,'ATTRIBUTE13'); 
                 Pkg_Lib.p_c(p_ro.attribute14,p_rn.attribute14,m,c,'ATTRIBUTE14'); 
                 Pkg_Lib.p_c(p_ro.attribute15,p_rn.attribute15,m,c,'ATTRIBUTE15'); 
                 Pkg_Lib.p_c(p_ro.attribute16,p_rn.attribute16,m,c,'ATTRIBUTE16'); 
                 Pkg_Lib.p_c(p_ro.attribute17,p_rn.attribute17,m,c,'ATTRIBUTE17'); 
                 Pkg_Lib.p_c(p_ro.attribute18,p_rn.attribute18,m,c,'ATTRIBUTE18'); 
                 Pkg_Lib.p_c(p_ro.attribute19,p_rn.attribute19,m,c,'ATTRIBUTE19'); 
                 Pkg_Lib.p_c(p_ro.attribute20,p_rn.attribute20,m,c,'ATTRIBUTE20'); 
                 Pkg_Lib.p_c(p_ro.par_key,p_rn.par_key,m,c,'PAR_KEY'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PARAMETER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'audsid:'||p_ro.audsid||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'par_code:'||p_ro.par_code||','; 
                m   :=  m ||'attribute01:'||p_ro.attribute01||','; 
                m   :=  m ||'attribute02:'||p_ro.attribute02||','; 
                m   :=  m ||'attribute03:'||p_ro.attribute03||','; 
                m   :=  m ||'attribute04:'||p_ro.attribute04||','; 
                m   :=  m ||'attribute05:'||p_ro.attribute05||','; 
                m   :=  m ||'attribute06:'||p_ro.attribute06||','; 
                m   :=  m ||'attribute07:'||p_ro.attribute07||','; 
                m   :=  m ||'attribute08:'||p_ro.attribute08||','; 
                m   :=  m ||'attribute09:'||p_ro.attribute09||','; 
                m   :=  m ||'attribute10:'||p_ro.attribute10||','; 
                m   :=  m ||'attribute11:'||p_ro.attribute11||','; 
                m   :=  m ||'attribute12:'||p_ro.attribute12||','; 
                m   :=  m ||'attribute13:'||p_ro.attribute13||','; 
                m   :=  m ||'attribute14:'||p_ro.attribute14||','; 
                m   :=  m ||'attribute15:'||p_ro.attribute15||','; 
                m   :=  m ||'attribute16:'||p_ro.attribute16||','; 
                m   :=  m ||'attribute17:'||p_ro.attribute17||','; 
                m   :=  m ||'attribute18:'||p_ro.attribute18||','; 
                m   :=  m ||'attribute19:'||p_ro.attribute19||','; 
                m   :=  m ||'attribute20:'||p_ro.attribute20||','; 
                m   :=  m ||'par_key:'||p_ro.par_key||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PARAMETER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_parameter_attr(p_tip VARCHAR2, p_ro IN OUT PARAMETER_ATTR%ROWTYPE, p_rn IN OUT PARAMETER_ATTR%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PARAMETER_ATTR.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.audsid                        := NVL(p_rn.audsid,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.par_code                      := NVL(p_rn.par_code,NULL); 
            p_rn.attr_id                       := NVL(p_rn.attr_id,NULL); 
            p_rn.attr_name                     := NVL(p_rn.attr_name,NULL); 
            p_rn.attr_type                     := NVL(p_rn.attr_type,NULL); 
            p_rn.attr_inlist                   := NVL(p_rn.attr_inlist,NULL); 
            p_rn.attr_notnull                  := NVL(p_rn.attr_notnull,0); 
            p_rn.attr_locked                   := NVL(p_rn.attr_locked,0); 
            p_rn.attr_from                     := NVL(p_rn.attr_from,NULL); 
            p_rn.attr_to                       := NVL(p_rn.attr_to,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.audsid,p_rn.audsid,m,c,'AUDSID'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.par_code,p_rn.par_code,m,c,'PAR_CODE'); 
                 Pkg_Lib.p_c(p_ro.attr_id,p_rn.attr_id,m,c,'ATTR_ID'); 
                 Pkg_Lib.p_c(p_ro.attr_name,p_rn.attr_name,m,c,'ATTR_NAME'); 
                 Pkg_Lib.p_n(p_ro.attr_type,p_rn.attr_type,m,c,'ATTR_TYPE'); 
                 Pkg_Lib.p_c(p_ro.attr_inlist,p_rn.attr_inlist,m,c,'ATTR_INLIST'); 
                 Pkg_Lib.p_n(p_ro.attr_notnull,p_rn.attr_notnull,m,c,'ATTR_NOTNULL'); 
                 Pkg_Lib.p_n(p_ro.attr_locked,p_rn.attr_locked,m,c,'ATTR_LOCKED'); 
                 Pkg_Lib.p_c(p_ro.attr_from,p_rn.attr_from,m,c,'ATTR_FROM'); 
                 Pkg_Lib.p_c(p_ro.attr_to,p_rn.attr_to,m,c,'ATTR_TO'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PARAMETER_ATTR',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'audsid:'||p_ro.audsid||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'par_code:'||p_ro.par_code||','; 
                m   :=  m ||'attr_id:'||p_ro.attr_id||','; 
                m   :=  m ||'attr_name:'||p_ro.attr_name||','; 
                m   :=  m ||'attr_type:'||p_ro.attr_type||','; 
                m   :=  m ||'attr_inlist:'||p_ro.attr_inlist||','; 
                m   :=  m ||'attr_notnull:'||p_ro.attr_notnull||','; 
                m   :=  m ||'attr_locked:'||p_ro.attr_locked||','; 
                m   :=  m ||'attr_from:'||p_ro.attr_from||','; 
                m   :=  m ||'attr_to:'||p_ro.attr_to||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PARAMETER_ATTR',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_parameter_code(p_tip VARCHAR2, p_ro IN OUT PARAMETER_CODE%ROWTYPE, p_rn IN OUT PARAMETER_CODE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PARAMETER_CODE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.audsid                        := NVL(p_rn.audsid,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.par_code                      := NVL(p_rn.par_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.audsid,p_rn.audsid,m,c,'AUDSID'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.par_code,p_rn.par_code,m,c,'PAR_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PARAMETER_CODE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'audsid:'||p_ro.audsid||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'par_code:'||p_ro.par_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PARAMETER_CODE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_patch_detail(p_tip VARCHAR2, p_ro IN OUT PATCH_DETAIL%ROWTYPE, p_rn IN OUT PATCH_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PATCH_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.patch_code                    := NVL(p_rn.patch_code,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.line_text                     := NVL(p_rn.line_text,NULL); 
            p_rn.source_object                 := NVL(p_rn.source_object,NULL); 
            p_rn.ddl_seq                       := NVL(p_rn.ddl_seq,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.patch_code,p_rn.patch_code,m,c,'PATCH_CODE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.line_text,p_rn.line_text,m,c,'LINE_TEXT'); 
                 Pkg_Lib.p_c(p_ro.source_object,p_rn.source_object,m,c,'SOURCE_OBJECT'); 
                 Pkg_Lib.p_n(p_ro.ddl_seq,p_rn.ddl_seq,m,c,'DDL_SEQ'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PATCH_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'patch_code:'||p_ro.patch_code||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'line_text:'||p_ro.line_text||','; 
                m   :=  m ||'source_object:'||p_ro.source_object||','; 
                m   :=  m ||'ddl_seq:'||p_ro.ddl_seq||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PATCH_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_patch_header(p_tip VARCHAR2, p_ro IN OUT PATCH_HEADER%ROWTYPE, p_rn IN OUT PATCH_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PATCH_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.patch_code                    := NVL(p_rn.patch_code,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.patch_code,p_rn.patch_code,m,c,'PATCH_CODE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PATCH_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'patch_code:'||p_ro.patch_code||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PATCH_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_po_ord_header(p_tip VARCHAR2, p_ro IN OUT PO_ORD_HEADER%ROWTYPE, p_rn IN OUT PO_ORD_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PO_ORD_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.po_code                       := NVL(p_rn.po_code,NULL); 
            p_rn.po_type                       := NVL(p_rn.po_type,NULL); 
            p_rn.doc_code                      := NVL(p_rn.doc_code,NULL); 
            p_rn.doc_date                      := NVL(p_rn.doc_date,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.suppl_code                    := NVL(p_rn.suppl_code,NULL); 
            p_rn.accept_date                   := NVL(p_rn.accept_date,NULL); 
            p_rn.po_date                       := NVL(p_rn.po_date,NULL); 
            p_rn.estimated_date                := NVL(p_rn.estimated_date,NULL); 
            p_rn.delivery_date                 := NVL(p_rn.delivery_date,NULL); 
            p_rn.suppl_loc                     := NVL(p_rn.suppl_loc,NULL); 
            p_rn.delivery_loc                  := NVL(p_rn.delivery_loc,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.exchange_rate                 := NVL(p_rn.exchange_rate,NULL); 
            p_rn.payment_cond                  := NVL(p_rn.payment_cond,NULL); 
            p_rn.delivery_cond                 := NVL(p_rn.delivery_cond,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.empl_request                  := NVL(p_rn.empl_request,NULL); 
            p_rn.delivery_org                  := NVL(p_rn.delivery_org,NULL); 
            p_rn.ship_via                      := NVL(p_rn.ship_via,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.po_code,p_rn.po_code,m,c,'PO_CODE'); 
                 Pkg_Lib.p_c(p_ro.po_type,p_rn.po_type,m,c,'PO_TYPE'); 
                 Pkg_Lib.p_c(p_ro.doc_code,p_rn.doc_code,m,c,'DOC_CODE'); 
                 Pkg_Lib.p_d(p_ro.doc_date,p_rn.doc_date,m,c,'DOC_DATE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.suppl_code,p_rn.suppl_code,m,c,'SUPPL_CODE'); 
                 Pkg_Lib.p_d(p_ro.accept_date,p_rn.accept_date,m,c,'ACCEPT_DATE'); 
                 Pkg_Lib.p_d(p_ro.po_date,p_rn.po_date,m,c,'PO_DATE'); 
                 Pkg_Lib.p_d(p_ro.estimated_date,p_rn.estimated_date,m,c,'ESTIMATED_DATE'); 
                 Pkg_Lib.p_d(p_ro.delivery_date,p_rn.delivery_date,m,c,'DELIVERY_DATE'); 
                 Pkg_Lib.p_c(p_ro.suppl_loc,p_rn.suppl_loc,m,c,'SUPPL_LOC'); 
                 Pkg_Lib.p_c(p_ro.delivery_loc,p_rn.delivery_loc,m,c,'DELIVERY_LOC'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_n(p_ro.exchange_rate,p_rn.exchange_rate,m,c,'EXCHANGE_RATE'); 
                 Pkg_Lib.p_c(p_ro.payment_cond,p_rn.payment_cond,m,c,'PAYMENT_COND'); 
                 Pkg_Lib.p_c(p_ro.delivery_cond,p_rn.delivery_cond,m,c,'DELIVERY_COND'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.empl_request,p_rn.empl_request,m,c,'EMPL_REQUEST'); 
                 Pkg_Lib.p_c(p_ro.delivery_org,p_rn.delivery_org,m,c,'DELIVERY_ORG'); 
                 Pkg_Lib.p_c(p_ro.ship_via,p_rn.ship_via,m,c,'SHIP_VIA'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PO_ORD_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.PO_CODE,
                        p_tbl_idx2     =>  p_ro.SUPPL_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'po_code:'||p_ro.po_code||','; 
                m   :=  m ||'po_type:'||p_ro.po_type||','; 
                m   :=  m ||'doc_code:'||p_ro.doc_code||','; 
                m   :=  m ||'doc_date:'||p_ro.doc_date||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'suppl_code:'||p_ro.suppl_code||','; 
                m   :=  m ||'accept_date:'||p_ro.accept_date||','; 
                m   :=  m ||'po_date:'||p_ro.po_date||','; 
                m   :=  m ||'estimated_date:'||p_ro.estimated_date||','; 
                m   :=  m ||'delivery_date:'||p_ro.delivery_date||','; 
                m   :=  m ||'suppl_loc:'||p_ro.suppl_loc||','; 
                m   :=  m ||'delivery_loc:'||p_ro.delivery_loc||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'exchange_rate:'||p_ro.exchange_rate||','; 
                m   :=  m ||'payment_cond:'||p_ro.payment_cond||','; 
                m   :=  m ||'delivery_cond:'||p_ro.delivery_cond||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'empl_request:'||p_ro.empl_request||','; 
                m   :=  m ||'delivery_org:'||p_ro.delivery_org||','; 
                m   :=  m ||'ship_via:'||p_ro.ship_via||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PO_ORD_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.PO_CODE,
                        p_tbl_idx2     =>  p_ro.SUPPL_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_po_ord_line(p_tip VARCHAR2, p_ro IN OUT PO_ORD_LINE%ROWTYPE, p_rn IN OUT PO_ORD_LINE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PO_ORD_LINE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_po                        := NVL(p_rn.ref_po,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.routing_code                  := NVL(p_rn.routing_code,NULL); 
            p_rn.line_type                     := NVL(p_rn.line_type,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.unit_price                    := NVL(p_rn.unit_price,NULL); 
            p_rn.costcenter_code               := NVL(p_rn.costcenter_code,NULL); 
            p_rn.ref_po_req                    := NVL(p_rn.ref_po_req,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_po,p_rn.ref_po,m,c,'REF_PO'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.routing_code,p_rn.routing_code,m,c,'ROUTING_CODE'); 
                 Pkg_Lib.p_c(p_ro.line_type,p_rn.line_type,m,c,'LINE_TYPE'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_n(p_ro.unit_price,p_rn.unit_price,m,c,'UNIT_PRICE'); 
                 Pkg_Lib.p_c(p_ro.costcenter_code,p_rn.costcenter_code,m,c,'COSTCENTER_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_po_req,p_rn.ref_po_req,m,c,'REF_PO_REQ'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PO_ORD_LINE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.REF_PO,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_po:'||p_ro.ref_po||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'routing_code:'||p_ro.routing_code||','; 
                m   :=  m ||'line_type:'||p_ro.line_type||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'unit_price:'||p_ro.unit_price||','; 
                m   :=  m ||'costcenter_code:'||p_ro.costcenter_code||','; 
                m   :=  m ||'ref_po_req:'||p_ro.ref_po_req||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PO_ORD_LINE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.REF_PO,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_price_list(p_tip VARCHAR2, p_ro IN OUT PRICE_LIST%ROWTYPE, p_rn IN OUT PRICE_LIST%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PRICE_LIST.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.price                         := NVL(p_rn.price,NULL); 
            p_rn.start_date                    := NVL(p_rn.start_date,NULL); 
            p_rn.end_date                      := NVL(p_rn.end_date,NULL); 
            p_rn.flag_default                  := NVL(p_rn.flag_default,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.currency                      := NVL(p_rn.currency,NULL); 
            p_rn.type_code                     := NVL(p_rn.type_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_n(p_ro.price,p_rn.price,m,c,'PRICE'); 
                 Pkg_Lib.p_d(p_ro.start_date,p_rn.start_date,m,c,'START_DATE'); 
                 Pkg_Lib.p_d(p_ro.end_date,p_rn.end_date,m,c,'END_DATE'); 
                 Pkg_Lib.p_c(p_ro.flag_default,p_rn.flag_default,m,c,'FLAG_DEFAULT'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.currency,p_rn.currency,m,c,'CURRENCY'); 
                 Pkg_Lib.p_c(p_ro.type_code,p_rn.type_code,m,c,'TYPE_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PRICE_LIST',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'price:'||p_ro.price||','; 
                m   :=  m ||'start_date:'||p_ro.start_date||','; 
                m   :=  m ||'end_date:'||p_ro.end_date||','; 
                m   :=  m ||'flag_default:'||p_ro.flag_default||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'currency:'||p_ro.currency||','; 
                m   :=  m ||'type_code:'||p_ro.type_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PRICE_LIST',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_price_list_sales(p_tip VARCHAR2, p_ro IN OUT PRICE_LIST_SALES%ROWTYPE, p_rn IN OUT PRICE_LIST_SALES%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PRICE_LIST_SALES.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.family_code                   := NVL(p_rn.family_code,NULL); 
            p_rn.routing_code                  := NVL(p_rn.routing_code,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.date_start                    := NVL(p_rn.date_start,NULL); 
            p_rn.date_end                      := NVL(p_rn.date_end,NULL); 
            p_rn.unit_price                    := NVL(p_rn.unit_price,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.flag_default                  := NVL(p_rn.flag_default,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.family_code,p_rn.family_code,m,c,'FAMILY_CODE'); 
                 Pkg_Lib.p_c(p_ro.routing_code,p_rn.routing_code,m,c,'ROUTING_CODE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_d(p_ro.date_start,p_rn.date_start,m,c,'DATE_START'); 
                 Pkg_Lib.p_d(p_ro.date_end,p_rn.date_end,m,c,'DATE_END'); 
                 Pkg_Lib.p_n(p_ro.unit_price,p_rn.unit_price,m,c,'UNIT_PRICE'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_c(p_ro.flag_default,p_rn.flag_default,m,c,'FLAG_DEFAULT'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PRICE_LIST_SALES',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'family_code:'||p_ro.family_code||','; 
                m   :=  m ||'routing_code:'||p_ro.routing_code||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'date_start:'||p_ro.date_start||','; 
                m   :=  m ||'date_end:'||p_ro.date_end||','; 
                m   :=  m ||'unit_price:'||p_ro.unit_price||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'flag_default:'||p_ro.flag_default||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PRICE_LIST_SALES',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_primary_uom(p_tip VARCHAR2, p_ro IN OUT PRIMARY_UOM%ROWTYPE, p_rn IN OUT PRIMARY_UOM%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_PRIMARY_UOM.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.flag_si                       := NVL(p_rn.flag_si,NULL); 
            p_rn.si_conversion                 := NVL(p_rn.si_conversion,NULL); 
            p_rn.si_uom                        := NVL(p_rn.si_uom,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.flag_si,p_rn.flag_si,m,c,'FLAG_SI'); 
                 Pkg_Lib.p_n(p_ro.si_conversion,p_rn.si_conversion,m,c,'SI_CONVERSION'); 
                 Pkg_Lib.p_c(p_ro.si_uom,p_rn.si_uom,m,c,'SI_UOM'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'PRIMARY_UOM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'flag_si:'||p_ro.flag_si||','; 
                m   :=  m ||'si_conversion:'||p_ro.si_conversion||','; 
                m   :=  m ||'si_uom:'||p_ro.si_uom||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'PRIMARY_UOM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_receipt_detail(p_tip VARCHAR2, p_ro IN OUT RECEIPT_DETAIL%ROWTYPE, p_rn IN OUT RECEIPT_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_RECEIPT_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.ref_receipt                   := NVL(p_rn.ref_receipt,NULL); 
            p_rn.uom_receipt                   := NVL(p_rn.uom_receipt,NULL); 
            p_rn.qty_doc                       := NVL(p_rn.qty_doc,NULL); 
            p_rn.qty_count                     := NVL(p_rn.qty_count,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.qty_doc_puom                  := NVL(p_rn.qty_doc_puom,NULL); 
            p_rn.qty_count_puom                := NVL(p_rn.qty_count_puom,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.custom_code                   := NVL(p_rn.custom_code,NULL); 
            p_rn.origin_code                   := NVL(p_rn.origin_code,NULL); 
            p_rn.weight_net                    := NVL(p_rn.weight_net,NULL); 
            p_rn.weight_brut                   := NVL(p_rn.weight_brut,NULL); 
            p_rn.price_doc                     := NVL(p_rn.price_doc,NULL); 
            p_rn.price_doc_puom                := NVL(p_rn.price_doc_puom,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.weight_pack                   := NVL(p_rn.weight_pack,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_receipt,p_rn.ref_receipt,m,c,'REF_RECEIPT'); 
                 Pkg_Lib.p_c(p_ro.uom_receipt,p_rn.uom_receipt,m,c,'UOM_RECEIPT'); 
                 Pkg_Lib.p_n(p_ro.qty_doc,p_rn.qty_doc,m,c,'QTY_DOC'); 
                 Pkg_Lib.p_n(p_ro.qty_count,p_rn.qty_count,m,c,'QTY_COUNT'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_n(p_ro.qty_doc_puom,p_rn.qty_doc_puom,m,c,'QTY_DOC_PUOM'); 
                 Pkg_Lib.p_n(p_ro.qty_count_puom,p_rn.qty_count_puom,m,c,'QTY_COUNT_PUOM'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.custom_code,p_rn.custom_code,m,c,'CUSTOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.origin_code,p_rn.origin_code,m,c,'ORIGIN_CODE'); 
                 Pkg_Lib.p_n(p_ro.weight_net,p_rn.weight_net,m,c,'WEIGHT_NET'); 
                 Pkg_Lib.p_n(p_ro.weight_brut,p_rn.weight_brut,m,c,'WEIGHT_BRUT'); 
                 Pkg_Lib.p_n(p_ro.price_doc,p_rn.price_doc,m,c,'PRICE_DOC'); 
                 Pkg_Lib.p_n(p_ro.price_doc_puom,p_rn.price_doc_puom,m,c,'PRICE_DOC_PUOM'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_n(p_ro.weight_pack,p_rn.weight_pack,m,c,'WEIGHT_PACK'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'RECEIPT_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'ref_receipt:'||p_ro.ref_receipt||','; 
                m   :=  m ||'uom_receipt:'||p_ro.uom_receipt||','; 
                m   :=  m ||'qty_doc:'||p_ro.qty_doc||','; 
                m   :=  m ||'qty_count:'||p_ro.qty_count||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'qty_doc_puom:'||p_ro.qty_doc_puom||','; 
                m   :=  m ||'qty_count_puom:'||p_ro.qty_count_puom||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'custom_code:'||p_ro.custom_code||','; 
                m   :=  m ||'origin_code:'||p_ro.origin_code||','; 
                m   :=  m ||'weight_net:'||p_ro.weight_net||','; 
                m   :=  m ||'weight_brut:'||p_ro.weight_brut||','; 
                m   :=  m ||'price_doc:'||p_ro.price_doc||','; 
                m   :=  m ||'price_doc_puom:'||p_ro.price_doc_puom||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'weight_pack:'||p_ro.weight_pack||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'RECEIPT_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_receipt_header(p_tip VARCHAR2, p_ro IN OUT RECEIPT_HEADER%ROWTYPE, p_rn IN OUT RECEIPT_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_RECEIPT_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.receipt_year                  := NVL(p_rn.receipt_year,NULL ); 
            p_rn.receipt_code                  := NVL(p_rn.receipt_code,NULL); 
            p_rn.receipt_date                  := NVL(p_rn.receipt_date,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.receipt_type                  := NVL(p_rn.receipt_type,NULL); 
            p_rn.suppl_code                    := NVL(p_rn.suppl_code,NULL); 
            p_rn.doc_number                    := NVL(p_rn.doc_number,NULL); 
            p_rn.doc_date                      := NVL(p_rn.doc_date,NULL); 
            p_rn.incoterm                      := NVL(p_rn.incoterm,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.country_from                  := NVL(p_rn.country_from,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.fifo                          := NVL(p_rn.fifo,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.receipt_year,p_rn.receipt_year,m,c,'RECEIPT_YEAR'); 
                 Pkg_Lib.p_c(p_ro.receipt_code,p_rn.receipt_code,m,c,'RECEIPT_CODE'); 
                 Pkg_Lib.p_d(p_ro.receipt_date,p_rn.receipt_date,m,c,'RECEIPT_DATE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.receipt_type,p_rn.receipt_type,m,c,'RECEIPT_TYPE'); 
                 Pkg_Lib.p_c(p_ro.suppl_code,p_rn.suppl_code,m,c,'SUPPL_CODE'); 
                 Pkg_Lib.p_c(p_ro.doc_number,p_rn.doc_number,m,c,'DOC_NUMBER'); 
                 Pkg_Lib.p_d(p_ro.doc_date,p_rn.doc_date,m,c,'DOC_DATE'); 
                 Pkg_Lib.p_c(p_ro.incoterm,p_rn.incoterm,m,c,'INCOTERM'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_c(p_ro.country_from,p_rn.country_from,m,c,'COUNTRY_FROM'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.fifo,p_rn.fifo,m,c,'FIFO'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'RECEIPT_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'receipt_year:'||p_ro.receipt_year||','; 
                m   :=  m ||'receipt_code:'||p_ro.receipt_code||','; 
                m   :=  m ||'receipt_date:'||p_ro.receipt_date||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'receipt_type:'||p_ro.receipt_type||','; 
                m   :=  m ||'suppl_code:'||p_ro.suppl_code||','; 
                m   :=  m ||'doc_number:'||p_ro.doc_number||','; 
                m   :=  m ||'doc_date:'||p_ro.doc_date||','; 
                m   :=  m ||'incoterm:'||p_ro.incoterm||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'country_from:'||p_ro.country_from||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'fifo:'||p_ro.fifo||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'RECEIPT_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_reports(p_tip VARCHAR2, p_ro IN OUT REPORTS%ROWTYPE, p_rn IN OUT REPORTS%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_REPORTS.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.report_name                   := NVL(p_rn.report_name,NULL); 
            p_rn.id_categ                      := NVL(p_rn.id_categ,NULL); 
            p_rn.sql_proc                      := NVL(p_rn.sql_proc,NULL); 
            p_rn.sql_select                    := NVL(p_rn.sql_select,NULL); 
            p_rn.cod_rap                       := NVL(p_rn.cod_rap,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.counter                       := NVL(p_rn.counter,0); 
            p_rn.querydef                      := NVL(p_rn.querydef,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.report_name,p_rn.report_name,m,c,'REPORT_NAME'); 
                 Pkg_Lib.p_n(p_ro.id_categ,p_rn.id_categ,m,c,'ID_CATEG'); 
                 Pkg_Lib.p_c(p_ro.sql_proc,p_rn.sql_proc,m,c,'SQL_PROC'); 
                 Pkg_Lib.p_c(p_ro.sql_select,p_rn.sql_select,m,c,'SQL_SELECT'); 
                 Pkg_Lib.p_c(p_ro.cod_rap,p_rn.cod_rap,m,c,'COD_RAP'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_n(p_ro.counter,p_rn.counter,m,c,'COUNTER'); 
                 Pkg_Lib.p_c(p_ro.querydef,p_rn.querydef,m,c,'QUERYDEF'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'REPORTS',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'report_name:'||p_ro.report_name||','; 
                m   :=  m ||'id_categ:'||p_ro.id_categ||','; 
                m   :=  m ||'sql_proc:'||p_ro.sql_proc||','; 
                m   :=  m ||'sql_select:'||p_ro.sql_select||','; 
                m   :=  m ||'cod_rap:'||p_ro.cod_rap||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'counter:'||p_ro.counter||','; 
                m   :=  m ||'querydef:'||p_ro.querydef||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'REPORTS',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_reports_category(p_tip VARCHAR2, p_ro IN OUT REPORTS_CATEGORY%ROWTYPE, p_rn IN OUT REPORTS_CATEGORY%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_REPORTS_CATEGORY.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.categ_name                    := NVL(p_rn.categ_name,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.categ_name,p_rn.categ_name,m,c,'CATEG_NAME'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'REPORTS_CATEGORY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'categ_name:'||p_ro.categ_name||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'REPORTS_CATEGORY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_reports_parameter(p_tip VARCHAR2, p_ro IN OUT REPORTS_PARAMETER%ROWTYPE, p_rn IN OUT REPORTS_PARAMETER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_REPORTS_PARAMETER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.label                         := NVL(p_rn.label,NULL); 
            p_rn.id_report                     := NVL(p_rn.id_report,NULL); 
            p_rn.ord                           := NVL(p_rn.ord,NULL); 
            p_rn.tippar                        := NVL(p_rn.tippar,NULL); 
            p_rn.strsql                        := NVL(p_rn.strsql,NULL); 
            p_rn.bloc                          := NVL(p_rn.bloc,0); 
            p_rn.ord_procedure                 := NVL(p_rn.ord_procedure,0 ); 
            p_rn.control_name                  := NVL(p_rn.control_name,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.label,p_rn.label,m,c,'LABEL'); 
                 Pkg_Lib.p_n(p_ro.id_report,p_rn.id_report,m,c,'ID_REPORT'); 
                 Pkg_Lib.p_n(p_ro.ord,p_rn.ord,m,c,'ORD'); 
                 Pkg_Lib.p_n(p_ro.tippar,p_rn.tippar,m,c,'TIPPAR'); 
                 Pkg_Lib.p_c(p_ro.strsql,p_rn.strsql,m,c,'STRSQL'); 
                 Pkg_Lib.p_n(p_ro.bloc,p_rn.bloc,m,c,'BLOC'); 
                 Pkg_Lib.p_n(p_ro.ord_procedure,p_rn.ord_procedure,m,c,'ORD_PROCEDURE'); 
                 Pkg_Lib.p_c(p_ro.control_name,p_rn.control_name,m,c,'CONTROL_NAME'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'REPORTS_PARAMETER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'label:'||p_ro.label||','; 
                m   :=  m ||'id_report:'||p_ro.id_report||','; 
                m   :=  m ||'ord:'||p_ro.ord||','; 
                m   :=  m ||'tippar:'||p_ro.tippar||','; 
                m   :=  m ||'strsql:'||p_ro.strsql||','; 
                m   :=  m ||'bloc:'||p_ro.bloc||','; 
                m   :=  m ||'ord_procedure:'||p_ro.ord_procedure||','; 
                m   :=  m ||'control_name:'||p_ro.control_name||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'REPORTS_PARAMETER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_report_queue_detail(p_tip VARCHAR2, p_ro IN OUT REPORT_QUEUE_DETAIL%ROWTYPE, p_rn IN OUT REPORT_QUEUE_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_REPORT_QUEUE_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.report_code                   := NVL(p_rn.report_code,NULL); 
            p_rn.txt01                         := NVL(p_rn.txt01,NULL); 
            p_rn.txt02                         := NVL(p_rn.txt02,NULL); 
            p_rn.txt03                         := NVL(p_rn.txt03,NULL); 
            p_rn.txt04                         := NVL(p_rn.txt04,NULL); 
            p_rn.txt05                         := NVL(p_rn.txt05,NULL); 
            p_rn.txt06                         := NVL(p_rn.txt06,NULL); 
            p_rn.txt07                         := NVL(p_rn.txt07,NULL); 
            p_rn.txt08                         := NVL(p_rn.txt08,NULL); 
            p_rn.txt09                         := NVL(p_rn.txt09,NULL); 
            p_rn.txt10                         := NVL(p_rn.txt10,NULL); 
            p_rn.txt11                         := NVL(p_rn.txt11,NULL); 
            p_rn.txt12                         := NVL(p_rn.txt12,NULL); 
            p_rn.txt13                         := NVL(p_rn.txt13,NULL); 
            p_rn.txt14                         := NVL(p_rn.txt14,NULL); 
            p_rn.txt15                         := NVL(p_rn.txt15,NULL); 
            p_rn.txt16                         := NVL(p_rn.txt16,NULL); 
            p_rn.txt17                         := NVL(p_rn.txt17,NULL); 
            p_rn.txt18                         := NVL(p_rn.txt18,NULL); 
            p_rn.txt19                         := NVL(p_rn.txt19,NULL); 
            p_rn.txt20                         := NVL(p_rn.txt20,NULL); 
            p_rn.txt21                         := NVL(p_rn.txt21,NULL); 
            p_rn.txt22                         := NVL(p_rn.txt22,NULL); 
            p_rn.txt23                         := NVL(p_rn.txt23,NULL); 
            p_rn.txt24                         := NVL(p_rn.txt24,NULL); 
            p_rn.txt25                         := NVL(p_rn.txt25,NULL); 
            p_rn.txt26                         := NVL(p_rn.txt26,NULL); 
            p_rn.txt27                         := NVL(p_rn.txt27,NULL); 
            p_rn.txt28                         := NVL(p_rn.txt28,NULL); 
            p_rn.txt29                         := NVL(p_rn.txt29,NULL); 
            p_rn.txt30                         := NVL(p_rn.txt30,NULL); 
            p_rn.txt31                         := NVL(p_rn.txt31,NULL); 
            p_rn.txt32                         := NVL(p_rn.txt32,NULL); 
            p_rn.txt33                         := NVL(p_rn.txt33,NULL); 
            p_rn.txt34                         := NVL(p_rn.txt34,NULL); 
            p_rn.txt35                         := NVL(p_rn.txt35,NULL); 
            p_rn.txt36                         := NVL(p_rn.txt36,NULL); 
            p_rn.txt37                         := NVL(p_rn.txt37,NULL); 
            p_rn.txt38                         := NVL(p_rn.txt38,NULL); 
            p_rn.txt39                         := NVL(p_rn.txt39,NULL); 
            p_rn.txt40                         := NVL(p_rn.txt40,NULL); 
            p_rn.txt41                         := NVL(p_rn.txt41,NULL); 
            p_rn.txt42                         := NVL(p_rn.txt42,NULL); 
            p_rn.txt43                         := NVL(p_rn.txt43,NULL); 
            p_rn.txt44                         := NVL(p_rn.txt44,NULL); 
            p_rn.txt45                         := NVL(p_rn.txt45,NULL); 
            p_rn.txt46                         := NVL(p_rn.txt46,NULL); 
            p_rn.txt47                         := NVL(p_rn.txt47,NULL); 
            p_rn.txt48                         := NVL(p_rn.txt48,NULL); 
            p_rn.txt49                         := NVL(p_rn.txt49,NULL); 
            p_rn.txt50                         := NVL(p_rn.txt50,NULL); 
            p_rn.data01                        := NVL(p_rn.data01,NULL); 
            p_rn.data02                        := NVL(p_rn.data02,NULL); 
            p_rn.data03                        := NVL(p_rn.data03,NULL); 
            p_rn.data04                        := NVL(p_rn.data04,NULL); 
            p_rn.data05                        := NVL(p_rn.data05,NULL); 
            p_rn.data06                        := NVL(p_rn.data06,NULL); 
            p_rn.data07                        := NVL(p_rn.data07,NULL); 
            p_rn.data08                        := NVL(p_rn.data08,NULL); 
            p_rn.data09                        := NVL(p_rn.data09,NULL); 
            p_rn.data10                        := NVL(p_rn.data10,NULL); 
            p_rn.numb01                        := NVL(p_rn.numb01,NULL); 
            p_rn.numb02                        := NVL(p_rn.numb02,NULL); 
            p_rn.numb03                        := NVL(p_rn.numb03,NULL); 
            p_rn.numb04                        := NVL(p_rn.numb04,NULL); 
            p_rn.numb05                        := NVL(p_rn.numb05,NULL); 
            p_rn.numb06                        := NVL(p_rn.numb06,NULL); 
            p_rn.numb07                        := NVL(p_rn.numb07,NULL); 
            p_rn.numb08                        := NVL(p_rn.numb08,NULL); 
            p_rn.numb09                        := NVL(p_rn.numb09,NULL); 
            p_rn.numb10                        := NVL(p_rn.numb10,NULL); 
            p_rn.numb11                        := NVL(p_rn.numb11,NULL); 
            p_rn.numb12                        := NVL(p_rn.numb12,NULL); 
            p_rn.numb13                        := NVL(p_rn.numb13,NULL); 
            p_rn.numb14                        := NVL(p_rn.numb14,NULL); 
            p_rn.numb15                        := NVL(p_rn.numb15,NULL); 
            p_rn.numb16                        := NVL(p_rn.numb16,NULL); 
            p_rn.numb17                        := NVL(p_rn.numb17,NULL); 
            p_rn.numb18                        := NVL(p_rn.numb18,NULL); 
            p_rn.numb19                        := NVL(p_rn.numb19,NULL); 
            p_rn.numb20                        := NVL(p_rn.numb20,NULL); 
            p_rn.numb21                        := NVL(p_rn.numb21,NULL); 
            p_rn.numb22                        := NVL(p_rn.numb22,NULL); 
            p_rn.numb23                        := NVL(p_rn.numb23,NULL); 
            p_rn.numb24                        := NVL(p_rn.numb24,NULL); 
            p_rn.numb25                        := NVL(p_rn.numb25,NULL); 
            p_rn.numb26                        := NVL(p_rn.numb26,NULL); 
            p_rn.numb27                        := NVL(p_rn.numb27,NULL); 
            p_rn.numb28                        := NVL(p_rn.numb28,NULL); 
            p_rn.numb29                        := NVL(p_rn.numb29,NULL); 
            p_rn.numb30                        := NVL(p_rn.numb30,NULL); 
            p_rn.numb31                        := NVL(p_rn.numb31,NULL); 
            p_rn.numb32                        := NVL(p_rn.numb32,NULL); 
            p_rn.numb33                        := NVL(p_rn.numb33,NULL); 
            p_rn.numb34                        := NVL(p_rn.numb34,NULL); 
            p_rn.numb35                        := NVL(p_rn.numb35,NULL); 
            p_rn.numb36                        := NVL(p_rn.numb36,NULL); 
            p_rn.numb37                        := NVL(p_rn.numb37,NULL); 
            p_rn.numb38                        := NVL(p_rn.numb38,NULL); 
            p_rn.numb39                        := NVL(p_rn.numb39,NULL); 
            p_rn.numb40                        := NVL(p_rn.numb40,NULL); 
            p_rn.numb41                        := NVL(p_rn.numb41,NULL); 
            p_rn.numb42                        := NVL(p_rn.numb42,NULL); 
            p_rn.numb43                        := NVL(p_rn.numb43,NULL); 
            p_rn.numb44                        := NVL(p_rn.numb44,NULL); 
            p_rn.numb45                        := NVL(p_rn.numb45,NULL); 
            p_rn.numb46                        := NVL(p_rn.numb46,NULL); 
            p_rn.numb47                        := NVL(p_rn.numb47,NULL); 
            p_rn.numb48                        := NVL(p_rn.numb48,NULL); 
            p_rn.numb49                        := NVL(p_rn.numb49,NULL); 
            p_rn.numb50                        := NVL(p_rn.numb50,NULL); 
            p_rn.user_code                     := NVL(p_rn.user_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.report_code,p_rn.report_code,m,c,'REPORT_CODE'); 
                 Pkg_Lib.p_c(p_ro.txt01,p_rn.txt01,m,c,'TXT01'); 
                 Pkg_Lib.p_c(p_ro.txt02,p_rn.txt02,m,c,'TXT02'); 
                 Pkg_Lib.p_c(p_ro.txt03,p_rn.txt03,m,c,'TXT03'); 
                 Pkg_Lib.p_c(p_ro.txt04,p_rn.txt04,m,c,'TXT04'); 
                 Pkg_Lib.p_c(p_ro.txt05,p_rn.txt05,m,c,'TXT05'); 
                 Pkg_Lib.p_c(p_ro.txt06,p_rn.txt06,m,c,'TXT06'); 
                 Pkg_Lib.p_c(p_ro.txt07,p_rn.txt07,m,c,'TXT07'); 
                 Pkg_Lib.p_c(p_ro.txt08,p_rn.txt08,m,c,'TXT08'); 
                 Pkg_Lib.p_c(p_ro.txt09,p_rn.txt09,m,c,'TXT09'); 
                 Pkg_Lib.p_c(p_ro.txt10,p_rn.txt10,m,c,'TXT10'); 
                 Pkg_Lib.p_c(p_ro.txt11,p_rn.txt11,m,c,'TXT11'); 
                 Pkg_Lib.p_c(p_ro.txt12,p_rn.txt12,m,c,'TXT12'); 
                 Pkg_Lib.p_c(p_ro.txt13,p_rn.txt13,m,c,'TXT13'); 
                 Pkg_Lib.p_c(p_ro.txt14,p_rn.txt14,m,c,'TXT14'); 
                 Pkg_Lib.p_c(p_ro.txt15,p_rn.txt15,m,c,'TXT15'); 
                 Pkg_Lib.p_c(p_ro.txt16,p_rn.txt16,m,c,'TXT16'); 
                 Pkg_Lib.p_c(p_ro.txt17,p_rn.txt17,m,c,'TXT17'); 
                 Pkg_Lib.p_c(p_ro.txt18,p_rn.txt18,m,c,'TXT18'); 
                 Pkg_Lib.p_c(p_ro.txt19,p_rn.txt19,m,c,'TXT19'); 
                 Pkg_Lib.p_c(p_ro.txt20,p_rn.txt20,m,c,'TXT20'); 
                 Pkg_Lib.p_c(p_ro.txt21,p_rn.txt21,m,c,'TXT21'); 
                 Pkg_Lib.p_c(p_ro.txt22,p_rn.txt22,m,c,'TXT22'); 
                 Pkg_Lib.p_c(p_ro.txt23,p_rn.txt23,m,c,'TXT23'); 
                 Pkg_Lib.p_c(p_ro.txt24,p_rn.txt24,m,c,'TXT24'); 
                 Pkg_Lib.p_c(p_ro.txt25,p_rn.txt25,m,c,'TXT25'); 
                 Pkg_Lib.p_c(p_ro.txt26,p_rn.txt26,m,c,'TXT26'); 
                 Pkg_Lib.p_c(p_ro.txt27,p_rn.txt27,m,c,'TXT27'); 
                 Pkg_Lib.p_c(p_ro.txt28,p_rn.txt28,m,c,'TXT28'); 
                 Pkg_Lib.p_c(p_ro.txt29,p_rn.txt29,m,c,'TXT29'); 
                 Pkg_Lib.p_c(p_ro.txt30,p_rn.txt30,m,c,'TXT30'); 
                 Pkg_Lib.p_c(p_ro.txt31,p_rn.txt31,m,c,'TXT31'); 
                 Pkg_Lib.p_c(p_ro.txt32,p_rn.txt32,m,c,'TXT32'); 
                 Pkg_Lib.p_c(p_ro.txt33,p_rn.txt33,m,c,'TXT33'); 
                 Pkg_Lib.p_c(p_ro.txt34,p_rn.txt34,m,c,'TXT34'); 
                 Pkg_Lib.p_c(p_ro.txt35,p_rn.txt35,m,c,'TXT35'); 
                 Pkg_Lib.p_c(p_ro.txt36,p_rn.txt36,m,c,'TXT36'); 
                 Pkg_Lib.p_c(p_ro.txt37,p_rn.txt37,m,c,'TXT37'); 
                 Pkg_Lib.p_c(p_ro.txt38,p_rn.txt38,m,c,'TXT38'); 
                 Pkg_Lib.p_c(p_ro.txt39,p_rn.txt39,m,c,'TXT39'); 
                 Pkg_Lib.p_c(p_ro.txt40,p_rn.txt40,m,c,'TXT40'); 
                 Pkg_Lib.p_c(p_ro.txt41,p_rn.txt41,m,c,'TXT41'); 
                 Pkg_Lib.p_c(p_ro.txt42,p_rn.txt42,m,c,'TXT42'); 
                 Pkg_Lib.p_c(p_ro.txt43,p_rn.txt43,m,c,'TXT43'); 
                 Pkg_Lib.p_c(p_ro.txt44,p_rn.txt44,m,c,'TXT44'); 
                 Pkg_Lib.p_c(p_ro.txt45,p_rn.txt45,m,c,'TXT45'); 
                 Pkg_Lib.p_c(p_ro.txt46,p_rn.txt46,m,c,'TXT46'); 
                 Pkg_Lib.p_c(p_ro.txt47,p_rn.txt47,m,c,'TXT47'); 
                 Pkg_Lib.p_c(p_ro.txt48,p_rn.txt48,m,c,'TXT48'); 
                 Pkg_Lib.p_c(p_ro.txt49,p_rn.txt49,m,c,'TXT49'); 
                 Pkg_Lib.p_c(p_ro.txt50,p_rn.txt50,m,c,'TXT50'); 
                 Pkg_Lib.p_d(p_ro.data01,p_rn.data01,m,c,'DATA01'); 
                 Pkg_Lib.p_d(p_ro.data02,p_rn.data02,m,c,'DATA02'); 
                 Pkg_Lib.p_d(p_ro.data03,p_rn.data03,m,c,'DATA03'); 
                 Pkg_Lib.p_d(p_ro.data04,p_rn.data04,m,c,'DATA04'); 
                 Pkg_Lib.p_d(p_ro.data05,p_rn.data05,m,c,'DATA05'); 
                 Pkg_Lib.p_d(p_ro.data06,p_rn.data06,m,c,'DATA06'); 
                 Pkg_Lib.p_d(p_ro.data07,p_rn.data07,m,c,'DATA07'); 
                 Pkg_Lib.p_d(p_ro.data08,p_rn.data08,m,c,'DATA08'); 
                 Pkg_Lib.p_d(p_ro.data09,p_rn.data09,m,c,'DATA09'); 
                 Pkg_Lib.p_d(p_ro.data10,p_rn.data10,m,c,'DATA10'); 
                 Pkg_Lib.p_n(p_ro.numb01,p_rn.numb01,m,c,'NUMB01'); 
                 Pkg_Lib.p_n(p_ro.numb02,p_rn.numb02,m,c,'NUMB02'); 
                 Pkg_Lib.p_n(p_ro.numb03,p_rn.numb03,m,c,'NUMB03'); 
                 Pkg_Lib.p_n(p_ro.numb04,p_rn.numb04,m,c,'NUMB04'); 
                 Pkg_Lib.p_n(p_ro.numb05,p_rn.numb05,m,c,'NUMB05'); 
                 Pkg_Lib.p_n(p_ro.numb06,p_rn.numb06,m,c,'NUMB06'); 
                 Pkg_Lib.p_n(p_ro.numb07,p_rn.numb07,m,c,'NUMB07'); 
                 Pkg_Lib.p_n(p_ro.numb08,p_rn.numb08,m,c,'NUMB08'); 
                 Pkg_Lib.p_n(p_ro.numb09,p_rn.numb09,m,c,'NUMB09'); 
                 Pkg_Lib.p_n(p_ro.numb10,p_rn.numb10,m,c,'NUMB10'); 
                 Pkg_Lib.p_n(p_ro.numb11,p_rn.numb11,m,c,'NUMB11'); 
                 Pkg_Lib.p_n(p_ro.numb12,p_rn.numb12,m,c,'NUMB12'); 
                 Pkg_Lib.p_n(p_ro.numb13,p_rn.numb13,m,c,'NUMB13'); 
                 Pkg_Lib.p_n(p_ro.numb14,p_rn.numb14,m,c,'NUMB14'); 
                 Pkg_Lib.p_n(p_ro.numb15,p_rn.numb15,m,c,'NUMB15'); 
                 Pkg_Lib.p_n(p_ro.numb16,p_rn.numb16,m,c,'NUMB16'); 
                 Pkg_Lib.p_n(p_ro.numb17,p_rn.numb17,m,c,'NUMB17'); 
                 Pkg_Lib.p_n(p_ro.numb18,p_rn.numb18,m,c,'NUMB18'); 
                 Pkg_Lib.p_n(p_ro.numb19,p_rn.numb19,m,c,'NUMB19'); 
                 Pkg_Lib.p_n(p_ro.numb20,p_rn.numb20,m,c,'NUMB20'); 
                 Pkg_Lib.p_n(p_ro.numb21,p_rn.numb21,m,c,'NUMB21'); 
                 Pkg_Lib.p_n(p_ro.numb22,p_rn.numb22,m,c,'NUMB22'); 
                 Pkg_Lib.p_n(p_ro.numb23,p_rn.numb23,m,c,'NUMB23'); 
                 Pkg_Lib.p_n(p_ro.numb24,p_rn.numb24,m,c,'NUMB24'); 
                 Pkg_Lib.p_n(p_ro.numb25,p_rn.numb25,m,c,'NUMB25'); 
                 Pkg_Lib.p_n(p_ro.numb26,p_rn.numb26,m,c,'NUMB26'); 
                 Pkg_Lib.p_n(p_ro.numb27,p_rn.numb27,m,c,'NUMB27'); 
                 Pkg_Lib.p_n(p_ro.numb28,p_rn.numb28,m,c,'NUMB28'); 
                 Pkg_Lib.p_n(p_ro.numb29,p_rn.numb29,m,c,'NUMB29'); 
                 Pkg_Lib.p_n(p_ro.numb30,p_rn.numb30,m,c,'NUMB30'); 
                 Pkg_Lib.p_n(p_ro.numb31,p_rn.numb31,m,c,'NUMB31'); 
                 Pkg_Lib.p_n(p_ro.numb32,p_rn.numb32,m,c,'NUMB32'); 
                 Pkg_Lib.p_n(p_ro.numb33,p_rn.numb33,m,c,'NUMB33'); 
                 Pkg_Lib.p_n(p_ro.numb34,p_rn.numb34,m,c,'NUMB34'); 
                 Pkg_Lib.p_n(p_ro.numb35,p_rn.numb35,m,c,'NUMB35'); 
                 Pkg_Lib.p_n(p_ro.numb36,p_rn.numb36,m,c,'NUMB36'); 
                 Pkg_Lib.p_n(p_ro.numb37,p_rn.numb37,m,c,'NUMB37'); 
                 Pkg_Lib.p_n(p_ro.numb38,p_rn.numb38,m,c,'NUMB38'); 
                 Pkg_Lib.p_n(p_ro.numb39,p_rn.numb39,m,c,'NUMB39'); 
                 Pkg_Lib.p_n(p_ro.numb40,p_rn.numb40,m,c,'NUMB40'); 
                 Pkg_Lib.p_n(p_ro.numb41,p_rn.numb41,m,c,'NUMB41'); 
                 Pkg_Lib.p_n(p_ro.numb42,p_rn.numb42,m,c,'NUMB42'); 
                 Pkg_Lib.p_n(p_ro.numb43,p_rn.numb43,m,c,'NUMB43'); 
                 Pkg_Lib.p_n(p_ro.numb44,p_rn.numb44,m,c,'NUMB44'); 
                 Pkg_Lib.p_n(p_ro.numb45,p_rn.numb45,m,c,'NUMB45'); 
                 Pkg_Lib.p_n(p_ro.numb46,p_rn.numb46,m,c,'NUMB46'); 
                 Pkg_Lib.p_n(p_ro.numb47,p_rn.numb47,m,c,'NUMB47'); 
                 Pkg_Lib.p_n(p_ro.numb48,p_rn.numb48,m,c,'NUMB48'); 
                 Pkg_Lib.p_n(p_ro.numb49,p_rn.numb49,m,c,'NUMB49'); 
                 Pkg_Lib.p_n(p_ro.numb50,p_rn.numb50,m,c,'NUMB50'); 
                 Pkg_Lib.p_c(p_ro.user_code,p_rn.user_code,m,c,'USER_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'REPORT_QUEUE_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'report_code:'||p_ro.report_code||','; 
                m   :=  m ||'txt01:'||p_ro.txt01||','; 
                m   :=  m ||'txt02:'||p_ro.txt02||','; 
                m   :=  m ||'txt03:'||p_ro.txt03||','; 
                m   :=  m ||'txt04:'||p_ro.txt04||','; 
                m   :=  m ||'txt05:'||p_ro.txt05||','; 
                m   :=  m ||'txt06:'||p_ro.txt06||','; 
                m   :=  m ||'txt07:'||p_ro.txt07||','; 
                m   :=  m ||'txt08:'||p_ro.txt08||','; 
                m   :=  m ||'txt09:'||p_ro.txt09||','; 
                m   :=  m ||'txt10:'||p_ro.txt10||','; 
                m   :=  m ||'txt11:'||p_ro.txt11||','; 
                m   :=  m ||'txt12:'||p_ro.txt12||','; 
                m   :=  m ||'txt13:'||p_ro.txt13||','; 
                m   :=  m ||'txt14:'||p_ro.txt14||','; 
                m   :=  m ||'txt15:'||p_ro.txt15||','; 
                m   :=  m ||'txt16:'||p_ro.txt16||','; 
                m   :=  m ||'txt17:'||p_ro.txt17||','; 
                m   :=  m ||'txt18:'||p_ro.txt18||','; 
                m   :=  m ||'txt19:'||p_ro.txt19||','; 
                m   :=  m ||'txt20:'||p_ro.txt20||','; 
                m   :=  m ||'txt21:'||p_ro.txt21||','; 
                m   :=  m ||'txt22:'||p_ro.txt22||','; 
                m   :=  m ||'txt23:'||p_ro.txt23||','; 
                m   :=  m ||'txt24:'||p_ro.txt24||','; 
                m   :=  m ||'txt25:'||p_ro.txt25||','; 
                m   :=  m ||'txt26:'||p_ro.txt26||','; 
                m   :=  m ||'txt27:'||p_ro.txt27||','; 
                m   :=  m ||'txt28:'||p_ro.txt28||','; 
                m   :=  m ||'txt29:'||p_ro.txt29||','; 
                m   :=  m ||'txt30:'||p_ro.txt30||','; 
                m   :=  m ||'txt31:'||p_ro.txt31||','; 
                m   :=  m ||'txt32:'||p_ro.txt32||','; 
                m   :=  m ||'txt33:'||p_ro.txt33||','; 
                m   :=  m ||'txt34:'||p_ro.txt34||','; 
                m   :=  m ||'txt35:'||p_ro.txt35||','; 
                m   :=  m ||'txt36:'||p_ro.txt36||','; 
                m   :=  m ||'txt37:'||p_ro.txt37||','; 
                m   :=  m ||'txt38:'||p_ro.txt38||','; 
                m   :=  m ||'txt39:'||p_ro.txt39||','; 
                m   :=  m ||'txt40:'||p_ro.txt40||','; 
                m   :=  m ||'txt41:'||p_ro.txt41||','; 
                m   :=  m ||'txt42:'||p_ro.txt42||','; 
                m   :=  m ||'txt43:'||p_ro.txt43||','; 
                m   :=  m ||'txt44:'||p_ro.txt44||','; 
                m   :=  m ||'txt45:'||p_ro.txt45||','; 
                m   :=  m ||'txt46:'||p_ro.txt46||','; 
                m   :=  m ||'txt47:'||p_ro.txt47||','; 
                m   :=  m ||'txt48:'||p_ro.txt48||','; 
                m   :=  m ||'txt49:'||p_ro.txt49||','; 
                m   :=  m ||'txt50:'||p_ro.txt50||','; 
                m   :=  m ||'data01:'||p_ro.data01||','; 
                m   :=  m ||'data02:'||p_ro.data02||','; 
                m   :=  m ||'data03:'||p_ro.data03||','; 
                m   :=  m ||'data04:'||p_ro.data04||','; 
                m   :=  m ||'data05:'||p_ro.data05||','; 
                m   :=  m ||'data06:'||p_ro.data06||','; 
                m   :=  m ||'data07:'||p_ro.data07||','; 
                m   :=  m ||'data08:'||p_ro.data08||','; 
                m   :=  m ||'data09:'||p_ro.data09||','; 
                m   :=  m ||'data10:'||p_ro.data10||','; 
                m   :=  m ||'numb01:'||p_ro.numb01||','; 
                m   :=  m ||'numb02:'||p_ro.numb02||','; 
                m   :=  m ||'numb03:'||p_ro.numb03||','; 
                m   :=  m ||'numb04:'||p_ro.numb04||','; 
                m   :=  m ||'numb05:'||p_ro.numb05||','; 
                m   :=  m ||'numb06:'||p_ro.numb06||','; 
                m   :=  m ||'numb07:'||p_ro.numb07||','; 
                m   :=  m ||'numb08:'||p_ro.numb08||','; 
                m   :=  m ||'numb09:'||p_ro.numb09||','; 
                m   :=  m ||'numb10:'||p_ro.numb10||','; 
                m   :=  m ||'numb11:'||p_ro.numb11||','; 
                m   :=  m ||'numb12:'||p_ro.numb12||','; 
                m   :=  m ||'numb13:'||p_ro.numb13||','; 
                m   :=  m ||'numb14:'||p_ro.numb14||','; 
                m   :=  m ||'numb15:'||p_ro.numb15||','; 
                m   :=  m ||'numb16:'||p_ro.numb16||','; 
                m   :=  m ||'numb17:'||p_ro.numb17||','; 
                m   :=  m ||'numb18:'||p_ro.numb18||','; 
                m   :=  m ||'numb19:'||p_ro.numb19||','; 
                m   :=  m ||'numb20:'||p_ro.numb20||','; 
                m   :=  m ||'numb21:'||p_ro.numb21||','; 
                m   :=  m ||'numb22:'||p_ro.numb22||','; 
                m   :=  m ||'numb23:'||p_ro.numb23||','; 
                m   :=  m ||'numb24:'||p_ro.numb24||','; 
                m   :=  m ||'numb25:'||p_ro.numb25||','; 
                m   :=  m ||'numb26:'||p_ro.numb26||','; 
                m   :=  m ||'numb27:'||p_ro.numb27||','; 
                m   :=  m ||'numb28:'||p_ro.numb28||','; 
                m   :=  m ||'numb29:'||p_ro.numb29||','; 
                m   :=  m ||'numb30:'||p_ro.numb30||','; 
                m   :=  m ||'numb31:'||p_ro.numb31||','; 
                m   :=  m ||'numb32:'||p_ro.numb32||','; 
                m   :=  m ||'numb33:'||p_ro.numb33||','; 
                m   :=  m ||'numb34:'||p_ro.numb34||','; 
                m   :=  m ||'numb35:'||p_ro.numb35||','; 
                m   :=  m ||'numb36:'||p_ro.numb36||','; 
                m   :=  m ||'numb37:'||p_ro.numb37||','; 
                m   :=  m ||'numb38:'||p_ro.numb38||','; 
                m   :=  m ||'numb39:'||p_ro.numb39||','; 
                m   :=  m ||'numb40:'||p_ro.numb40||','; 
                m   :=  m ||'numb41:'||p_ro.numb41||','; 
                m   :=  m ||'numb42:'||p_ro.numb42||','; 
                m   :=  m ||'numb43:'||p_ro.numb43||','; 
                m   :=  m ||'numb44:'||p_ro.numb44||','; 
                m   :=  m ||'numb45:'||p_ro.numb45||','; 
                m   :=  m ||'numb46:'||p_ro.numb46||','; 
                m   :=  m ||'numb47:'||p_ro.numb47||','; 
                m   :=  m ||'numb48:'||p_ro.numb48||','; 
                m   :=  m ||'numb49:'||p_ro.numb49||','; 
                m   :=  m ||'numb50:'||p_ro.numb50||','; 
                m   :=  m ||'user_code:'||p_ro.user_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'REPORT_QUEUE_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_report_queue_header(p_tip VARCHAR2, p_ro IN OUT REPORT_QUEUE_HEADER%ROWTYPE, p_rn IN OUT REPORT_QUEUE_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_REPORT_QUEUE_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.report_code                   := NVL(p_rn.report_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.user_code                     := NVL(p_rn.user_code,NULL); 
            p_rn.print_when                    := NVL(p_rn.print_when,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.report_code,p_rn.report_code,m,c,'REPORT_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.user_code,p_rn.user_code,m,c,'USER_CODE'); 
                 Pkg_Lib.p_d(p_ro.print_when,p_rn.print_when,m,c,'PRINT_WHEN'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'REPORT_QUEUE_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'report_code:'||p_ro.report_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'user_code:'||p_ro.user_code||','; 
                m   :=  m ||'print_when:'||p_ro.print_when||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'REPORT_QUEUE_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_sales_family(p_tip VARCHAR2, p_ro IN OUT SALES_FAMILY%ROWTYPE, p_rn IN OUT SALES_FAMILY%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SALES_FAMILY.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.family_code                   := NVL(p_rn.family_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.weight_net                    := NVL(p_rn.weight_net,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.family_code,p_rn.family_code,m,c,'FAMILY_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_n(p_ro.weight_net,p_rn.weight_net,m,c,'WEIGHT_NET'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SALES_FAMILY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'family_code:'||p_ro.family_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'weight_net:'||p_ro.weight_net||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SALES_FAMILY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_sales_order(p_tip VARCHAR2, p_ro IN OUT SALES_ORDER%ROWTYPE, p_rn IN OUT SALES_ORDER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SALES_ORDER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.order_date                    := NVL(p_rn.order_date,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.customer_code                 := NVL(p_rn.customer_code,NULL); 
            p_rn.customer_po                   := NVL(p_rn.customer_po,NULL); 
            p_rn.currency                      := NVL(p_rn.currency,NULL); 
            p_rn.order_status                  := NVL(p_rn.order_status,'I' ); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_d(p_ro.order_date,p_rn.order_date,m,c,'ORDER_DATE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.customer_code,p_rn.customer_code,m,c,'CUSTOMER_CODE'); 
                 Pkg_Lib.p_c(p_ro.customer_po,p_rn.customer_po,m,c,'CUSTOMER_PO'); 
                 Pkg_Lib.p_c(p_ro.currency,p_rn.currency,m,c,'CURRENCY'); 
                 Pkg_Lib.p_c(p_ro.order_status,p_rn.order_status,m,c,'ORDER_STATUS'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SALES_ORDER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'order_date:'||p_ro.order_date||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'customer_code:'||p_ro.customer_code||','; 
                m   :=  m ||'customer_po:'||p_ro.customer_po||','; 
                m   :=  m ||'currency:'||p_ro.currency||','; 
                m   :=  m ||'order_status:'||p_ro.order_status||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SALES_ORDER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_scan_event(p_tip VARCHAR2, p_ro IN OUT SCAN_EVENT%ROWTYPE, p_rn IN OUT SCAN_EVENT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SCAN_EVENT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.scanner_code                  := NVL(p_rn.scanner_code,NULL); 
            p_rn.context_code                  := NVL(p_rn.context_code,NULL); 
            p_rn.scanned_value                 := NVL(p_rn.scanned_value,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.scanner_code,p_rn.scanner_code,m,c,'SCANNER_CODE'); 
                 Pkg_Lib.p_c(p_ro.context_code,p_rn.context_code,m,c,'CONTEXT_CODE'); 
                 Pkg_Lib.p_c(p_ro.scanned_value,p_rn.scanned_value,m,c,'SCANNED_VALUE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SCAN_EVENT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'scanner_code:'||p_ro.scanner_code||','; 
                m   :=  m ||'context_code:'||p_ro.context_code||','; 
                m   :=  m ||'scanned_value:'||p_ro.scanned_value||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SCAN_EVENT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_setup_acrec(p_tip VARCHAR2, p_ro IN OUT SETUP_ACREC%ROWTYPE, p_rn IN OUT SETUP_ACREC%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SETUP_ACREC.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.acrec_type                    := NVL(p_rn.acrec_type,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.extern                        := NVL(p_rn.extern,NULL); 
            p_rn.service                       := NVL(p_rn.service,NULL); 
            p_rn.report_object                 := NVL(p_rn.report_object,NULL); 
            p_rn.type_description              := NVL(p_rn.type_description,NULL); 
            p_rn.ship_material                 := NVL(p_rn.ship_material,NULL); 
            p_rn.item_description              := NVL(p_rn.item_description,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.acrec_type,p_rn.acrec_type,m,c,'ACREC_TYPE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_c(p_ro.extern,p_rn.extern,m,c,'EXTERN'); 
                 Pkg_Lib.p_c(p_ro.service,p_rn.service,m,c,'SERVICE'); 
                 Pkg_Lib.p_c(p_ro.report_object,p_rn.report_object,m,c,'REPORT_OBJECT'); 
                 Pkg_Lib.p_c(p_ro.type_description,p_rn.type_description,m,c,'TYPE_DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.ship_material,p_rn.ship_material,m,c,'SHIP_MATERIAL'); 
                 Pkg_Lib.p_c(p_ro.item_description,p_rn.item_description,m,c,'ITEM_DESCRIPTION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SETUP_ACREC',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'acrec_type:'||p_ro.acrec_type||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'extern:'||p_ro.extern||','; 
                m   :=  m ||'service:'||p_ro.service||','; 
                m   :=  m ||'report_object:'||p_ro.report_object||','; 
                m   :=  m ||'type_description:'||p_ro.type_description||','; 
                m   :=  m ||'ship_material:'||p_ro.ship_material||','; 
                m   :=  m ||'item_description:'||p_ro.item_description||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SETUP_ACREC',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_setup_movement(p_tip VARCHAR2, p_ro IN OUT SETUP_MOVEMENT%ROWTYPE, p_rn IN OUT SETUP_MOVEMENT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SETUP_MOVEMENT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.move_code                     := NVL(p_rn.move_code,NULL); 
            p_rn.whs_source                    := NVL(p_rn.whs_source,NULL); 
            p_rn.whs_destin                    := NVL(p_rn.whs_destin,NULL); 
            p_rn.flag_demand                   := NVL(p_rn.flag_demand,0 ); 
            p_rn.flag_differ_season            := NVL(p_rn.flag_differ_season,0 ); 
            p_rn.flag_cost_center              := NVL(p_rn.flag_cost_center,NULL); 
            p_rn.flag_size_colour              := NVL(p_rn.flag_size_colour,NULL); 
            p_rn.flag_account_code             := NVL(p_rn.flag_account_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.move_code,p_rn.move_code,m,c,'MOVE_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_source,p_rn.whs_source,m,c,'WHS_SOURCE'); 
                 Pkg_Lib.p_c(p_ro.whs_destin,p_rn.whs_destin,m,c,'WHS_DESTIN'); 
                 Pkg_Lib.p_n(p_ro.flag_demand,p_rn.flag_demand,m,c,'FLAG_DEMAND'); 
                 Pkg_Lib.p_n(p_ro.flag_differ_season,p_rn.flag_differ_season,m,c,'FLAG_DIFFER_SEASON'); 
                 Pkg_Lib.p_c(p_ro.flag_cost_center,p_rn.flag_cost_center,m,c,'FLAG_COST_CENTER'); 
                 Pkg_Lib.p_c(p_ro.flag_size_colour,p_rn.flag_size_colour,m,c,'FLAG_SIZE_COLOUR'); 
                 Pkg_Lib.p_c(p_ro.flag_account_code,p_rn.flag_account_code,m,c,'FLAG_ACCOUNT_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SETUP_MOVEMENT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'move_code:'||p_ro.move_code||','; 
                m   :=  m ||'whs_source:'||p_ro.whs_source||','; 
                m   :=  m ||'whs_destin:'||p_ro.whs_destin||','; 
                m   :=  m ||'flag_demand:'||p_ro.flag_demand||','; 
                m   :=  m ||'flag_differ_season:'||p_ro.flag_differ_season||','; 
                m   :=  m ||'flag_cost_center:'||p_ro.flag_cost_center||','; 
                m   :=  m ||'flag_size_colour:'||p_ro.flag_size_colour||','; 
                m   :=  m ||'flag_account_code:'||p_ro.flag_account_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SETUP_MOVEMENT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_setup_receipt(p_tip VARCHAR2, p_ro IN OUT SETUP_RECEIPT%ROWTYPE, p_rn IN OUT SETUP_RECEIPT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SETUP_RECEIPT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.receipt_type                  := NVL(p_rn.receipt_type,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.property                      := NVL(p_rn.property,NULL); 
            p_rn.extern                        := NVL(p_rn.extern,NULL); 
            p_rn.service                       := NVL(p_rn.service,NULL); 
            p_rn.flag_return                   := NVL(p_rn.flag_return,NULL); 
            p_rn.trn_type                      := NVL(p_rn.trn_type,NULL); 
            p_rn.fifo                          := NVL(p_rn.fifo,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.receipt_type,p_rn.receipt_type,m,c,'RECEIPT_TYPE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_c(p_ro.property,p_rn.property,m,c,'PROPERTY'); 
                 Pkg_Lib.p_c(p_ro.extern,p_rn.extern,m,c,'EXTERN'); 
                 Pkg_Lib.p_c(p_ro.service,p_rn.service,m,c,'SERVICE'); 
                 Pkg_Lib.p_c(p_ro.flag_return,p_rn.flag_return,m,c,'FLAG_RETURN'); 
                 Pkg_Lib.p_c(p_ro.trn_type,p_rn.trn_type,m,c,'TRN_TYPE'); 
                 Pkg_Lib.p_c(p_ro.fifo,p_rn.fifo,m,c,'FIFO'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SETUP_RECEIPT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'receipt_type:'||p_ro.receipt_type||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'property:'||p_ro.property||','; 
                m   :=  m ||'extern:'||p_ro.extern||','; 
                m   :=  m ||'service:'||p_ro.service||','; 
                m   :=  m ||'flag_return:'||p_ro.flag_return||','; 
                m   :=  m ||'trn_type:'||p_ro.trn_type||','; 
                m   :=  m ||'fifo:'||p_ro.fifo||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SETUP_RECEIPT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_setup_shipment(p_tip VARCHAR2, p_ro IN OUT SETUP_SHIPMENT%ROWTYPE, p_rn IN OUT SETUP_SHIPMENT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SETUP_SHIPMENT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.ship_type                     := NVL(p_rn.ship_type,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.property                      := NVL(p_rn.property,NULL); 
            p_rn.extern                        := NVL(p_rn.extern,NULL); 
            p_rn.nature                        := NVL(p_rn.nature,NULL); 
            p_rn.trn_type                      := NVL(p_rn.trn_type,NULL); 
            p_rn.custom_code                   := NVL(p_rn.custom_code,NULL); 
            p_rn.out_proc                      := NVL(p_rn.out_proc,NULL); 
            p_rn.fifo                          := NVL(p_rn.fifo,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.ship_type,p_rn.ship_type,m,c,'SHIP_TYPE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.property,p_rn.property,m,c,'PROPERTY'); 
                 Pkg_Lib.p_c(p_ro.extern,p_rn.extern,m,c,'EXTERN'); 
                 Pkg_Lib.p_c(p_ro.nature,p_rn.nature,m,c,'NATURE'); 
                 Pkg_Lib.p_c(p_ro.trn_type,p_rn.trn_type,m,c,'TRN_TYPE'); 
                 Pkg_Lib.p_c(p_ro.custom_code,p_rn.custom_code,m,c,'CUSTOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.out_proc,p_rn.out_proc,m,c,'OUT_PROC'); 
                 Pkg_Lib.p_c(p_ro.fifo,p_rn.fifo,m,c,'FIFO'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SETUP_SHIPMENT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'ship_type:'||p_ro.ship_type||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'property:'||p_ro.property||','; 
                m   :=  m ||'extern:'||p_ro.extern||','; 
                m   :=  m ||'nature:'||p_ro.nature||','; 
                m   :=  m ||'trn_type:'||p_ro.trn_type||','; 
                m   :=  m ||'custom_code:'||p_ro.custom_code||','; 
                m   :=  m ||'out_proc:'||p_ro.out_proc||','; 
                m   :=  m ||'fifo:'||p_ro.fifo||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SETUP_SHIPMENT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_shipment_detail(p_tip VARCHAR2, p_ro IN OUT SHIPMENT_DETAIL%ROWTYPE, p_rn IN OUT SHIPMENT_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SHIPMENT_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.ref_shipment                  := NVL(p_rn.ref_shipment,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.description_item              := NVL(p_rn.description_item,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.custom_code                   := NVL(p_rn.custom_code,NULL); 
            p_rn.origin_code                   := NVL(p_rn.origin_code,NULL); 
            p_rn.qty_doc                       := NVL(p_rn.qty_doc,NULL); 
            p_rn.uom_shipment                  := NVL(p_rn.uom_shipment,NULL); 
            p_rn.qty_doc_puom                  := NVL(p_rn.qty_doc_puom,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.weight_net                    := NVL(p_rn.weight_net,NULL); 
            p_rn.package_code                  := NVL(p_rn.package_code,NULL); 
            p_rn.quality                       := NVL(p_rn.quality,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.group_code_out                := NVL(p_rn.group_code_out,NULL); 
            p_rn.line_source                   := NVL(p_rn.line_source,'MAN' ); 
            p_rn.package_number                := NVL(p_rn.package_number,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_shipment,p_rn.ref_shipment,m,c,'REF_SHIPMENT'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.description_item,p_rn.description_item,m,c,'DESCRIPTION_ITEM'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.custom_code,p_rn.custom_code,m,c,'CUSTOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.origin_code,p_rn.origin_code,m,c,'ORIGIN_CODE'); 
                 Pkg_Lib.p_n(p_ro.qty_doc,p_rn.qty_doc,m,c,'QTY_DOC'); 
                 Pkg_Lib.p_c(p_ro.uom_shipment,p_rn.uom_shipment,m,c,'UOM_SHIPMENT'); 
                 Pkg_Lib.p_n(p_ro.qty_doc_puom,p_rn.qty_doc_puom,m,c,'QTY_DOC_PUOM'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_n(p_ro.weight_net,p_rn.weight_net,m,c,'WEIGHT_NET'); 
                 Pkg_Lib.p_n(p_ro.package_code,p_rn.package_code,m,c,'PACKAGE_CODE'); 
                 Pkg_Lib.p_c(p_ro.quality,p_rn.quality,m,c,'QUALITY'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.group_code_out,p_rn.group_code_out,m,c,'GROUP_CODE_OUT'); 
                 Pkg_Lib.p_c(p_ro.line_source,p_rn.line_source,m,c,'LINE_SOURCE'); 
                 Pkg_Lib.p_n(p_ro.package_number,p_rn.package_number,m,c,'PACKAGE_NUMBER'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SHIPMENT_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'ref_shipment:'||p_ro.ref_shipment||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'description_item:'||p_ro.description_item||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'custom_code:'||p_ro.custom_code||','; 
                m   :=  m ||'origin_code:'||p_ro.origin_code||','; 
                m   :=  m ||'qty_doc:'||p_ro.qty_doc||','; 
                m   :=  m ||'uom_shipment:'||p_ro.uom_shipment||','; 
                m   :=  m ||'qty_doc_puom:'||p_ro.qty_doc_puom||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'weight_net:'||p_ro.weight_net||','; 
                m   :=  m ||'package_code:'||p_ro.package_code||','; 
                m   :=  m ||'quality:'||p_ro.quality||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'group_code_out:'||p_ro.group_code_out||','; 
                m   :=  m ||'line_source:'||p_ro.line_source||','; 
                m   :=  m ||'package_number:'||p_ro.package_number||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SHIPMENT_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_shipment_header(p_tip VARCHAR2, p_ro IN OUT SHIPMENT_HEADER%ROWTYPE, p_rn IN OUT SHIPMENT_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SHIPMENT_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.ship_year                     := NVL(p_rn.ship_year,NULL); 
            p_rn.ship_code                     := NVL(p_rn.ship_code,NULL); 
            p_rn.ship_date                     := NVL(p_rn.ship_date,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.ship_type                     := NVL(p_rn.ship_type,NULL); 
            p_rn.org_client                    := NVL(p_rn.org_client,NULL); 
            p_rn.org_delivery                  := NVL(p_rn.org_delivery,NULL); 
            p_rn.destin_code                   := NVL(p_rn.destin_code,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.incoterm                      := NVL(p_rn.incoterm,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.package_number                := NVL(p_rn.package_number,NULL); 
            p_rn.ref_acrec                     := NVL(p_rn.ref_acrec,NULL); 
            p_rn.truck_number                  := NVL(p_rn.truck_number,NULL); 
            p_rn.weight_net                    := NVL(p_rn.weight_net,NULL); 
            p_rn.weight_brut                   := NVL(p_rn.weight_brut,NULL); 
            p_rn.protocol_code                 := NVL(p_rn.protocol_code,NULL); 
            p_rn.protocol_date                 := NVL(p_rn.protocol_date,NULL); 
            p_rn.flag_package                  := NVL(p_rn.flag_package,'N' ); 
            p_rn.protocol_code2                := NVL(p_rn.protocol_code2,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.ship_year,p_rn.ship_year,m,c,'SHIP_YEAR'); 
                 Pkg_Lib.p_c(p_ro.ship_code,p_rn.ship_code,m,c,'SHIP_CODE'); 
                 Pkg_Lib.p_d(p_ro.ship_date,p_rn.ship_date,m,c,'SHIP_DATE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.ship_type,p_rn.ship_type,m,c,'SHIP_TYPE'); 
                 Pkg_Lib.p_c(p_ro.org_client,p_rn.org_client,m,c,'ORG_CLIENT'); 
                 Pkg_Lib.p_c(p_ro.org_delivery,p_rn.org_delivery,m,c,'ORG_DELIVERY'); 
                 Pkg_Lib.p_c(p_ro.destin_code,p_rn.destin_code,m,c,'DESTIN_CODE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.incoterm,p_rn.incoterm,m,c,'INCOTERM'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_n(p_ro.package_number,p_rn.package_number,m,c,'PACKAGE_NUMBER'); 
                 Pkg_Lib.p_n(p_ro.ref_acrec,p_rn.ref_acrec,m,c,'REF_ACREC'); 
                 Pkg_Lib.p_c(p_ro.truck_number,p_rn.truck_number,m,c,'TRUCK_NUMBER'); 
                 Pkg_Lib.p_n(p_ro.weight_net,p_rn.weight_net,m,c,'WEIGHT_NET'); 
                 Pkg_Lib.p_n(p_ro.weight_brut,p_rn.weight_brut,m,c,'WEIGHT_BRUT'); 
                 Pkg_Lib.p_c(p_ro.protocol_code,p_rn.protocol_code,m,c,'PROTOCOL_CODE'); 
                 Pkg_Lib.p_d(p_ro.protocol_date,p_rn.protocol_date,m,c,'PROTOCOL_DATE'); 
                 Pkg_Lib.p_c(p_ro.flag_package,p_rn.flag_package,m,c,'FLAG_PACKAGE'); 
                 Pkg_Lib.p_c(p_ro.protocol_code2,p_rn.protocol_code2,m,c,'PROTOCOL_CODE2'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SHIPMENT_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'ship_year:'||p_ro.ship_year||','; 
                m   :=  m ||'ship_code:'||p_ro.ship_code||','; 
                m   :=  m ||'ship_date:'||p_ro.ship_date||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'ship_type:'||p_ro.ship_type||','; 
                m   :=  m ||'org_client:'||p_ro.org_client||','; 
                m   :=  m ||'org_delivery:'||p_ro.org_delivery||','; 
                m   :=  m ||'destin_code:'||p_ro.destin_code||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'incoterm:'||p_ro.incoterm||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'package_number:'||p_ro.package_number||','; 
                m   :=  m ||'ref_acrec:'||p_ro.ref_acrec||','; 
                m   :=  m ||'truck_number:'||p_ro.truck_number||','; 
                m   :=  m ||'weight_net:'||p_ro.weight_net||','; 
                m   :=  m ||'weight_brut:'||p_ro.weight_brut||','; 
                m   :=  m ||'protocol_code:'||p_ro.protocol_code||','; 
                m   :=  m ||'protocol_date:'||p_ro.protocol_date||','; 
                m   :=  m ||'flag_package:'||p_ro.flag_package||','; 
                m   :=  m ||'protocol_code2:'||p_ro.protocol_code2||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SHIPMENT_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_shipment_order(p_tip VARCHAR2, p_ro IN OUT SHIPMENT_ORDER%ROWTYPE, p_rn IN OUT SHIPMENT_ORDER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SHIPMENT_ORDER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.ref_shipment                  := NVL(p_rn.ref_shipment,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_shipment,p_rn.ref_shipment,m,c,'REF_SHIPMENT'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SHIPMENT_ORDER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'ref_shipment:'||p_ro.ref_shipment||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SHIPMENT_ORDER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_shipment_package(p_tip VARCHAR2, p_ro IN OUT SHIPMENT_PACKAGE%ROWTYPE, p_rn IN OUT SHIPMENT_PACKAGE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SHIPMENT_PACKAGE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.ref_shipment                  := NVL(p_rn.ref_shipment,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.package_code                  := NVL(p_rn.package_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.package_type                  := NVL(p_rn.package_type,NULL); 
            p_rn.weight_net                    := NVL(p_rn.weight_net,NULL); 
            p_rn.weight_brut                   := NVL(p_rn.weight_brut,NULL); 
            p_rn.volume                        := NVL(p_rn.volume,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_shipment,p_rn.ref_shipment,m,c,'REF_SHIPMENT'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.package_code,p_rn.package_code,m,c,'PACKAGE_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.package_type,p_rn.package_type,m,c,'PACKAGE_TYPE'); 
                 Pkg_Lib.p_n(p_ro.weight_net,p_rn.weight_net,m,c,'WEIGHT_NET'); 
                 Pkg_Lib.p_n(p_ro.weight_brut,p_rn.weight_brut,m,c,'WEIGHT_BRUT'); 
                 Pkg_Lib.p_n(p_ro.volume,p_rn.volume,m,c,'VOLUME'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SHIPMENT_PACKAGE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'ref_shipment:'||p_ro.ref_shipment||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'package_code:'||p_ro.package_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'package_type:'||p_ro.package_type||','; 
                m   :=  m ||'weight_net:'||p_ro.weight_net||','; 
                m   :=  m ||'weight_brut:'||p_ro.weight_brut||','; 
                m   :=  m ||'volume:'||p_ro.volume||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SHIPMENT_PACKAGE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_so_detail(p_tip VARCHAR2, p_ro IN OUT SO_DETAIL%ROWTYPE, p_rn IN OUT SO_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_SO_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_so                        := NVL(p_rn.ref_so,NULL); 
            p_rn.item                          := NVL(p_rn.item,NULL); 
            p_rn.qta                           := NVL(p_rn.qta,NULL); 
            p_rn.unit_price                    := NVL(p_rn.unit_price,NULL); 
            p_rn.request_date                  := NVL(p_rn.request_date,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_so,p_rn.ref_so,m,c,'REF_SO'); 
                 Pkg_Lib.p_c(p_ro.item,p_rn.item,m,c,'ITEM'); 
                 Pkg_Lib.p_n(p_ro.qta,p_rn.qta,m,c,'QTA'); 
                 Pkg_Lib.p_n(p_ro.unit_price,p_rn.unit_price,m,c,'UNIT_PRICE'); 
                 Pkg_Lib.p_d(p_ro.request_date,p_rn.request_date,m,c,'REQUEST_DATE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'SO_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_so:'||p_ro.ref_so||','; 
                m   :=  m ||'item:'||p_ro.item||','; 
                m   :=  m ||'qta:'||p_ro.qta||','; 
                m   :=  m ||'unit_price:'||p_ro.unit_price||','; 
                m   :=  m ||'request_date:'||p_ro.request_date||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'SO_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_status_history(p_tip VARCHAR2, p_ro IN OUT STATUS_HISTORY%ROWTYPE, p_rn IN OUT STATUS_HISTORY%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STATUS_HISTORY.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_line_id                   := NVL(p_rn.ref_line_id,NULL); 
            p_rn.old_status                    := NVL(p_rn.old_status,NULL); 
            p_rn.new_status                    := NVL(p_rn.new_status,NULL); 
            p_rn.empl_code                     := NVL(p_rn.empl_code,NULL); 
            p_rn.reason_code                   := NVL(p_rn.reason_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_line_id,p_rn.ref_line_id,m,c,'REF_LINE_ID'); 
                 Pkg_Lib.p_c(p_ro.old_status,p_rn.old_status,m,c,'OLD_STATUS'); 
                 Pkg_Lib.p_c(p_ro.new_status,p_rn.new_status,m,c,'NEW_STATUS'); 
                 Pkg_Lib.p_c(p_ro.empl_code,p_rn.empl_code,m,c,'EMPL_CODE'); 
                 Pkg_Lib.p_c(p_ro.reason_code,p_rn.reason_code,m,c,'REASON_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STATUS_HISTORY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_line_id:'||p_ro.ref_line_id||','; 
                m   :=  m ||'old_status:'||p_ro.old_status||','; 
                m   :=  m ||'new_status:'||p_ro.new_status||','; 
                m   :=  m ||'empl_code:'||p_ro.empl_code||','; 
                m   :=  m ||'reason_code:'||p_ro.reason_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STATUS_HISTORY',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_stg_bom_std(p_tip VARCHAR2, p_ro IN OUT STG_BOM_STD%ROWTYPE, p_rn IN OUT STG_BOM_STD%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STG_BOM_STD.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
            p_rn.father_code                   := NVL(p_rn.father_code,NULL); 
            p_rn.qta                           := NVL(p_rn.qta,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.child_code                    := NVL(p_rn.child_code,NULL); 
            p_rn.qta_std                       := NVL(p_rn.qta_std,0 ); 
            p_rn.start_size                    := NVL(p_rn.start_size,NULL); 
            p_rn.end_size                      := NVL(p_rn.end_size,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.uom                           := NVL(p_rn.uom,NULL); 
            p_rn.file_id                       := NVL(p_rn.file_id,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.stg_status                    := NVL(p_rn.stg_status,'I' ); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                 Pkg_Lib.p_c(p_ro.father_code,p_rn.father_code,m,c,'FATHER_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta,p_rn.qta,m,c,'QTA'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.child_code,p_rn.child_code,m,c,'CHILD_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta_std,p_rn.qta_std,m,c,'QTA_STD'); 
                 Pkg_Lib.p_c(p_ro.start_size,p_rn.start_size,m,c,'START_SIZE'); 
                 Pkg_Lib.p_c(p_ro.end_size,p_rn.end_size,m,c,'END_SIZE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.uom,p_rn.uom,m,c,'UOM'); 
                 Pkg_Lib.p_n(p_ro.file_id,p_rn.file_id,m,c,'FILE_ID'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.stg_status,p_rn.stg_status,m,c,'STG_STATUS'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STG_BOM_STD',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                m   :=  m ||'father_code:'||p_ro.father_code||','; 
                m   :=  m ||'qta:'||p_ro.qta||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'child_code:'||p_ro.child_code||','; 
                m   :=  m ||'qta_std:'||p_ro.qta_std||','; 
                m   :=  m ||'start_size:'||p_ro.start_size||','; 
                m   :=  m ||'end_size:'||p_ro.end_size||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'uom:'||p_ro.uom||','; 
                m   :=  m ||'file_id:'||p_ro.file_id||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'stg_status:'||p_ro.stg_status||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STG_BOM_STD',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_stg_file_manager(p_tip VARCHAR2, p_ro IN OUT STG_FILE_MANAGER%ROWTYPE, p_rn IN OUT STG_FILE_MANAGER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STG_FILE_MANAGER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.file_info                     := NVL(p_rn.file_info,NULL); 
            p_rn.file_name                     := NVL(p_rn.file_name,NULL); 
            p_rn.file_name_original            := NVL(p_rn.file_name_original,NULL); 
            p_rn.file_date                     := NVL(p_rn.file_date,NULL); 
            p_rn.flag_processed                := NVL(p_rn.flag_processed,0 ); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.file_info,p_rn.file_info,m,c,'FILE_INFO'); 
                 Pkg_Lib.p_c(p_ro.file_name,p_rn.file_name,m,c,'FILE_NAME'); 
                 Pkg_Lib.p_c(p_ro.file_name_original,p_rn.file_name_original,m,c,'FILE_NAME_ORIGINAL'); 
                 Pkg_Lib.p_d(p_ro.file_date,p_rn.file_date,m,c,'FILE_DATE'); 
                 Pkg_Lib.p_n(p_ro.flag_processed,p_rn.flag_processed,m,c,'FLAG_PROCESSED'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STG_FILE_MANAGER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'file_info:'||p_ro.file_info||','; 
                m   :=  m ||'file_name:'||p_ro.file_name||','; 
                m   :=  m ||'file_name_original:'||p_ro.file_name_original||','; 
                m   :=  m ||'file_date:'||p_ro.file_date||','; 
                m   :=  m ||'flag_processed:'||p_ro.flag_processed||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STG_FILE_MANAGER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_stg_item(p_tip VARCHAR2, p_ro IN OUT STG_ITEM%ROWTYPE, p_rn IN OUT STG_ITEM%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STG_ITEM.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.weight_net                    := NVL(p_rn.weight_net,0); 
            p_rn.weight_brut                   := NVL(p_rn.weight_brut,0); 
            p_rn.make_buy                      := NVL(p_rn.make_buy,NULL); 
            p_rn.custom_code                   := NVL(p_rn.custom_code,NULL); 
            p_rn.custom_category               := NVL(p_rn.custom_category,NULL); 
            p_rn.reorder_point                 := NVL(p_rn.reorder_point,0); 
            p_rn.min_qta                       := NVL(p_rn.min_qta,0); 
            p_rn.max_qta                       := NVL(p_rn.max_qta,0); 
            p_rn.obs                           := NVL(p_rn.obs,NULL); 
            p_rn.flag_size                     := NVL(p_rn.flag_size,0); 
            p_rn.flag_colour                   := NVL(p_rn.flag_colour,0); 
            p_rn.flag_range                    := NVL(p_rn.flag_range,0); 
            p_rn.start_size                    := NVL(p_rn.start_size,NULL); 
            p_rn.end_size                      := NVL(p_rn.end_size,NULL); 
            p_rn.default_org                   := NVL(p_rn.default_org,NULL); 
            p_rn.default_whs                   := NVL(p_rn.default_whs,NULL); 
            p_rn.mat_type                      := NVL(p_rn.mat_type,'NECLASIFICAT'); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.suom                          := NVL(p_rn.suom,NULL); 
            p_rn.uom_conv                      := NVL(p_rn.uom_conv,0); 
            p_rn.scrap_perc                    := NVL(p_rn.scrap_perc,0); 
            p_rn.uom_receit                    := NVL(p_rn.uom_receit,NULL); 
            p_rn.root_code                     := NVL(p_rn.root_code,NULL); 
            p_rn.item_code2                    := NVL(p_rn.item_code2,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.file_id                       := NVL(p_rn.file_id,NULL); 
            p_rn.stg_status                    := NVL(p_rn.stg_status,'N'); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_n(p_ro.weight_net,p_rn.weight_net,m,c,'WEIGHT_NET'); 
                 Pkg_Lib.p_n(p_ro.weight_brut,p_rn.weight_brut,m,c,'WEIGHT_BRUT'); 
                 Pkg_Lib.p_c(p_ro.make_buy,p_rn.make_buy,m,c,'MAKE_BUY'); 
                 Pkg_Lib.p_c(p_ro.custom_code,p_rn.custom_code,m,c,'CUSTOM_CODE'); 
                 Pkg_Lib.p_c(p_ro.custom_category,p_rn.custom_category,m,c,'CUSTOM_CATEGORY'); 
                 Pkg_Lib.p_n(p_ro.reorder_point,p_rn.reorder_point,m,c,'REORDER_POINT'); 
                 Pkg_Lib.p_n(p_ro.min_qta,p_rn.min_qta,m,c,'MIN_QTA'); 
                 Pkg_Lib.p_n(p_ro.max_qta,p_rn.max_qta,m,c,'MAX_QTA'); 
                 Pkg_Lib.p_c(p_ro.obs,p_rn.obs,m,c,'OBS'); 
                 Pkg_Lib.p_n(p_ro.flag_size,p_rn.flag_size,m,c,'FLAG_SIZE'); 
                 Pkg_Lib.p_n(p_ro.flag_colour,p_rn.flag_colour,m,c,'FLAG_COLOUR'); 
                 Pkg_Lib.p_n(p_ro.flag_range,p_rn.flag_range,m,c,'FLAG_RANGE'); 
                 Pkg_Lib.p_c(p_ro.start_size,p_rn.start_size,m,c,'START_SIZE'); 
                 Pkg_Lib.p_c(p_ro.end_size,p_rn.end_size,m,c,'END_SIZE'); 
                 Pkg_Lib.p_c(p_ro.default_org,p_rn.default_org,m,c,'DEFAULT_ORG'); 
                 Pkg_Lib.p_c(p_ro.default_whs,p_rn.default_whs,m,c,'DEFAULT_WHS'); 
                 Pkg_Lib.p_c(p_ro.mat_type,p_rn.mat_type,m,c,'MAT_TYPE'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.suom,p_rn.suom,m,c,'SUOM'); 
                 Pkg_Lib.p_n(p_ro.uom_conv,p_rn.uom_conv,m,c,'UOM_CONV'); 
                 Pkg_Lib.p_n(p_ro.scrap_perc,p_rn.scrap_perc,m,c,'SCRAP_PERC'); 
                 Pkg_Lib.p_c(p_ro.uom_receit,p_rn.uom_receit,m,c,'UOM_RECEIT'); 
                 Pkg_Lib.p_c(p_ro.root_code,p_rn.root_code,m,c,'ROOT_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code2,p_rn.item_code2,m,c,'ITEM_CODE2'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.file_id,p_rn.file_id,m,c,'FILE_ID'); 
                 Pkg_Lib.p_c(p_ro.stg_status,p_rn.stg_status,m,c,'STG_STATUS'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STG_ITEM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'weight_net:'||p_ro.weight_net||','; 
                m   :=  m ||'weight_brut:'||p_ro.weight_brut||','; 
                m   :=  m ||'make_buy:'||p_ro.make_buy||','; 
                m   :=  m ||'custom_code:'||p_ro.custom_code||','; 
                m   :=  m ||'custom_category:'||p_ro.custom_category||','; 
                m   :=  m ||'reorder_point:'||p_ro.reorder_point||','; 
                m   :=  m ||'min_qta:'||p_ro.min_qta||','; 
                m   :=  m ||'max_qta:'||p_ro.max_qta||','; 
                m   :=  m ||'obs:'||p_ro.obs||','; 
                m   :=  m ||'flag_size:'||p_ro.flag_size||','; 
                m   :=  m ||'flag_colour:'||p_ro.flag_colour||','; 
                m   :=  m ||'flag_range:'||p_ro.flag_range||','; 
                m   :=  m ||'start_size:'||p_ro.start_size||','; 
                m   :=  m ||'end_size:'||p_ro.end_size||','; 
                m   :=  m ||'default_org:'||p_ro.default_org||','; 
                m   :=  m ||'default_whs:'||p_ro.default_whs||','; 
                m   :=  m ||'mat_type:'||p_ro.mat_type||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'suom:'||p_ro.suom||','; 
                m   :=  m ||'uom_conv:'||p_ro.uom_conv||','; 
                m   :=  m ||'scrap_perc:'||p_ro.scrap_perc||','; 
                m   :=  m ||'uom_receit:'||p_ro.uom_receit||','; 
                m   :=  m ||'root_code:'||p_ro.root_code||','; 
                m   :=  m ||'item_code2:'||p_ro.item_code2||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'file_id:'||p_ro.file_id||','; 
                m   :=  m ||'stg_status:'||p_ro.stg_status||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STG_ITEM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_stg_parser(p_tip VARCHAR2, p_ro IN OUT STG_PARSER%ROWTYPE, p_rn IN OUT STG_PARSER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STG_PARSER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.file_info                     := NVL(p_rn.file_info,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.stmt_text                     := NVL(p_rn.stmt_text,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.file_info,p_rn.file_info,m,c,'FILE_INFO'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.stmt_text,p_rn.stmt_text,m,c,'STMT_TEXT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STG_PARSER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'file_info:'||p_ro.file_info||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'stmt_text:'||p_ro.stmt_text||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STG_PARSER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_stg_receipt(p_tip VARCHAR2, p_ro IN OUT STG_RECEIPT%ROWTYPE, p_rn IN OUT STG_RECEIPT%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STG_RECEIPT.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.file_id                       := NVL(p_rn.file_id,NULL); 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
            p_rn.stg_status                    := NVL(p_rn.stg_status,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.receipt_type                  := NVL(p_rn.receipt_type,NULL); 
            p_rn.doc_number                    := NVL(p_rn.doc_number,NULL); 
            p_rn.doc_date                      := NVL(p_rn.doc_date,NULL); 
            p_rn.currency_code                 := NVL(p_rn.currency_code,NULL); 
            p_rn.country_from                  := NVL(p_rn.country_from,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.qty_doc                       := NVL(p_rn.qty_doc,NULL); 
            p_rn.uom_receipt                   := NVL(p_rn.uom_receipt,NULL); 
            p_rn.unit_price                    := NVL(p_rn.unit_price,NULL); 
            p_rn.line_no                       := NVL(p_rn.line_no,NULL); 
            p_rn.net_weight                    := NVL(p_rn.net_weight,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.file_id,p_rn.file_id,m,c,'FILE_ID'); 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                 Pkg_Lib.p_c(p_ro.stg_status,p_rn.stg_status,m,c,'STG_STATUS'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.receipt_type,p_rn.receipt_type,m,c,'RECEIPT_TYPE'); 
                 Pkg_Lib.p_c(p_ro.doc_number,p_rn.doc_number,m,c,'DOC_NUMBER'); 
                 Pkg_Lib.p_d(p_ro.doc_date,p_rn.doc_date,m,c,'DOC_DATE'); 
                 Pkg_Lib.p_c(p_ro.currency_code,p_rn.currency_code,m,c,'CURRENCY_CODE'); 
                 Pkg_Lib.p_c(p_ro.country_from,p_rn.country_from,m,c,'COUNTRY_FROM'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_n(p_ro.qty_doc,p_rn.qty_doc,m,c,'QTY_DOC'); 
                 Pkg_Lib.p_c(p_ro.uom_receipt,p_rn.uom_receipt,m,c,'UOM_RECEIPT'); 
                 Pkg_Lib.p_n(p_ro.unit_price,p_rn.unit_price,m,c,'UNIT_PRICE'); 
                 Pkg_Lib.p_n(p_ro.line_no,p_rn.line_no,m,c,'LINE_NO'); 
                 Pkg_Lib.p_n(p_ro.net_weight,p_rn.net_weight,m,c,'NET_WEIGHT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STG_RECEIPT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'file_id:'||p_ro.file_id||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                m   :=  m ||'stg_status:'||p_ro.stg_status||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'receipt_type:'||p_ro.receipt_type||','; 
                m   :=  m ||'doc_number:'||p_ro.doc_number||','; 
                m   :=  m ||'doc_date:'||p_ro.doc_date||','; 
                m   :=  m ||'currency_code:'||p_ro.currency_code||','; 
                m   :=  m ||'country_from:'||p_ro.country_from||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'qty_doc:'||p_ro.qty_doc||','; 
                m   :=  m ||'uom_receipt:'||p_ro.uom_receipt||','; 
                m   :=  m ||'unit_price:'||p_ro.unit_price||','; 
                m   :=  m ||'line_no:'||p_ro.line_no||','; 
                m   :=  m ||'net_weight:'||p_ro.net_weight||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STG_RECEIPT',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_stg_ship_fifo(p_tip VARCHAR2, p_ro IN OUT STG_SHIP_FIFO%ROWTYPE, p_rn IN OUT STG_SHIP_FIFO%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STG_SHIP_FIFO.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.file_id                       := NVL(p_rn.file_id,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.ship_subcat                   := NVL(p_rn.ship_subcat,NULL); 
            p_rn.stg_status                    := NVL(p_rn.stg_status,NULL); 
            p_rn.ship_date                     := NVL(p_rn.ship_date,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_n(p_ro.file_id,p_rn.file_id,m,c,'FILE_ID'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.ship_subcat,p_rn.ship_subcat,m,c,'SHIP_SUBCAT'); 
                 Pkg_Lib.p_c(p_ro.stg_status,p_rn.stg_status,m,c,'STG_STATUS'); 
                 Pkg_Lib.p_d(p_ro.ship_date,p_rn.ship_date,m,c,'SHIP_DATE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STG_SHIP_FIFO',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'file_id:'||p_ro.file_id||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'ship_subcat:'||p_ro.ship_subcat||','; 
                m   :=  m ||'stg_status:'||p_ro.stg_status||','; 
                m   :=  m ||'ship_date:'||p_ro.ship_date||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STG_SHIP_FIFO',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_stg_work_order(p_tip VARCHAR2, p_ro IN OUT STG_WORK_ORDER%ROWTYPE, p_rn IN OUT STG_WORK_ORDER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STG_WORK_ORDER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.priority                      := NVL(p_rn.priority,'N'); 
            p_rn.date_client                   := NVL(p_rn.date_client,NULL); 
            p_rn.client_lot                    := NVL(p_rn.client_lot,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.file_id                       := NVL(p_rn.file_id,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.stg_status                    := NVL(p_rn.stg_status,'I' ); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.package_number                := NVL(p_rn.package_number,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.priority,p_rn.priority,m,c,'PRIORITY'); 
                 Pkg_Lib.p_d(p_ro.date_client,p_rn.date_client,m,c,'DATE_CLIENT'); 
                 Pkg_Lib.p_c(p_ro.client_lot,p_rn.client_lot,m,c,'CLIENT_LOT'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_n(p_ro.file_id,p_rn.file_id,m,c,'FILE_ID'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.stg_status,p_rn.stg_status,m,c,'STG_STATUS'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_n(p_ro.package_number,p_rn.package_number,m,c,'PACKAGE_NUMBER'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STG_WORK_ORDER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'priority:'||p_ro.priority||','; 
                m   :=  m ||'date_client:'||p_ro.date_client||','; 
                m   :=  m ||'client_lot:'||p_ro.client_lot||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'file_id:'||p_ro.file_id||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'stg_status:'||p_ro.stg_status||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'package_number:'||p_ro.package_number||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STG_WORK_ORDER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_stg_wo_decl(p_tip VARCHAR2, p_ro IN OUT STG_WO_DECL%ROWTYPE, p_rn IN OUT STG_WO_DECL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_STG_WO_DECL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.file_id                       := NVL(p_rn.file_id,NULL); 
            p_rn.stg_status                    := NVL(p_rn.stg_status,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.wo_code                       := NVL(p_rn.wo_code,NULL); 
            p_rn.decl_date                     := NVL(p_rn.decl_date,NULL); 
            p_rn.operation                     := NVL(p_rn.operation,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.package_number                := NVL(p_rn.package_number,NULL); 
            p_rn.error_log                     := NVL(p_rn.error_log,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.file_id,p_rn.file_id,m,c,'FILE_ID'); 
                 Pkg_Lib.p_c(p_ro.stg_status,p_rn.stg_status,m,c,'STG_STATUS'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.wo_code,p_rn.wo_code,m,c,'WO_CODE'); 
                 Pkg_Lib.p_d(p_ro.decl_date,p_rn.decl_date,m,c,'DECL_DATE'); 
                 Pkg_Lib.p_c(p_ro.operation,p_rn.operation,m,c,'OPERATION'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_n(p_ro.package_number,p_rn.package_number,m,c,'PACKAGE_NUMBER'); 
                 Pkg_Lib.p_c(p_ro.error_log,p_rn.error_log,m,c,'ERROR_LOG'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'STG_WO_DECL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'file_id:'||p_ro.file_id||','; 
                m   :=  m ||'stg_status:'||p_ro.stg_status||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'wo_code:'||p_ro.wo_code||','; 
                m   :=  m ||'decl_date:'||p_ro.decl_date||','; 
                m   :=  m ||'operation:'||p_ro.operation||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'package_number:'||p_ro.package_number||','; 
                m   :=  m ||'error_log:'||p_ro.error_log||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'STG_WO_DECL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_tasks(p_tip VARCHAR2, p_ro IN OUT TASKS%ROWTYPE, p_rn IN OUT TASKS%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_TASKS.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.form_name                     := NVL(p_rn.form_name,NULL); 
            p_rn.task_order                    := NVL(p_rn.task_order,NULL); 
            p_rn.task_name                     := NVL(p_rn.task_name,NULL); 
            p_rn.par_label1                    := NVL(p_rn.par_label1,NULL); 
            p_rn.par_sql1                      := NVL(p_rn.par_sql1,NULL); 
            p_rn.par_type1                     := NVL(p_rn.par_type1,NULL); 
            p_rn.par_label2                    := NVL(p_rn.par_label2,NULL); 
            p_rn.par_sql2                      := NVL(p_rn.par_sql2,NULL); 
            p_rn.par_type2                     := NVL(p_rn.par_type2,NULL); 
            p_rn.par_label3                    := NVL(p_rn.par_label3,NULL); 
            p_rn.par_sql3                      := NVL(p_rn.par_sql3,NULL); 
            p_rn.par_type3                     := NVL(p_rn.par_type3,NULL); 
            p_rn.par_label4                    := NVL(p_rn.par_label4,NULL); 
            p_rn.par_sql4                      := NVL(p_rn.par_sql4,NULL); 
            p_rn.par_type4                     := NVL(p_rn.par_type4,NULL); 
            p_rn.par_label5                    := NVL(p_rn.par_label5,NULL); 
            p_rn.par_sql5                      := NVL(p_rn.par_sql5,NULL); 
            p_rn.par_type5                     := NVL(p_rn.par_type5,NULL); 
            p_rn.par_label6                    := NVL(p_rn.par_label6,NULL); 
            p_rn.par_sql6                      := NVL(p_rn.par_sql6,NULL); 
            p_rn.par_type6                     := NVL(p_rn.par_type6,NULL); 
            p_rn.par_label7                    := NVL(p_rn.par_label7,NULL); 
            p_rn.par_sql7                      := NVL(p_rn.par_sql7,NULL); 
            p_rn.par_type7                     := NVL(p_rn.par_type7,NULL); 
            p_rn.par_label8                    := NVL(p_rn.par_label8,NULL); 
            p_rn.par_sql8                      := NVL(p_rn.par_sql8,NULL); 
            p_rn.par_type8                     := NVL(p_rn.par_type8,NULL); 
            p_rn.par_label9                    := NVL(p_rn.par_label9,NULL); 
            p_rn.par_sql9                      := NVL(p_rn.par_sql9,NULL); 
            p_rn.par_type9                     := NVL(p_rn.par_type9,NULL); 
            p_rn.par_label10                   := NVL(p_rn.par_label10,NULL); 
            p_rn.par_sql10                     := NVL(p_rn.par_sql10,NULL); 
            p_rn.par_type10                    := NVL(p_rn.par_type10,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.form_name,p_rn.form_name,m,c,'FORM_NAME'); 
                 Pkg_Lib.p_c(p_ro.task_order,p_rn.task_order,m,c,'TASK_ORDER'); 
                 Pkg_Lib.p_c(p_ro.task_name,p_rn.task_name,m,c,'TASK_NAME'); 
                 Pkg_Lib.p_c(p_ro.par_label1,p_rn.par_label1,m,c,'PAR_LABEL1'); 
                 Pkg_Lib.p_c(p_ro.par_sql1,p_rn.par_sql1,m,c,'PAR_SQL1'); 
                 Pkg_Lib.p_n(p_ro.par_type1,p_rn.par_type1,m,c,'PAR_TYPE1'); 
                 Pkg_Lib.p_c(p_ro.par_label2,p_rn.par_label2,m,c,'PAR_LABEL2'); 
                 Pkg_Lib.p_c(p_ro.par_sql2,p_rn.par_sql2,m,c,'PAR_SQL2'); 
                 Pkg_Lib.p_n(p_ro.par_type2,p_rn.par_type2,m,c,'PAR_TYPE2'); 
                 Pkg_Lib.p_c(p_ro.par_label3,p_rn.par_label3,m,c,'PAR_LABEL3'); 
                 Pkg_Lib.p_c(p_ro.par_sql3,p_rn.par_sql3,m,c,'PAR_SQL3'); 
                 Pkg_Lib.p_n(p_ro.par_type3,p_rn.par_type3,m,c,'PAR_TYPE3'); 
                 Pkg_Lib.p_c(p_ro.par_label4,p_rn.par_label4,m,c,'PAR_LABEL4'); 
                 Pkg_Lib.p_c(p_ro.par_sql4,p_rn.par_sql4,m,c,'PAR_SQL4'); 
                 Pkg_Lib.p_n(p_ro.par_type4,p_rn.par_type4,m,c,'PAR_TYPE4'); 
                 Pkg_Lib.p_c(p_ro.par_label5,p_rn.par_label5,m,c,'PAR_LABEL5'); 
                 Pkg_Lib.p_c(p_ro.par_sql5,p_rn.par_sql5,m,c,'PAR_SQL5'); 
                 Pkg_Lib.p_n(p_ro.par_type5,p_rn.par_type5,m,c,'PAR_TYPE5'); 
                 Pkg_Lib.p_c(p_ro.par_label6,p_rn.par_label6,m,c,'PAR_LABEL6'); 
                 Pkg_Lib.p_c(p_ro.par_sql6,p_rn.par_sql6,m,c,'PAR_SQL6'); 
                 Pkg_Lib.p_n(p_ro.par_type6,p_rn.par_type6,m,c,'PAR_TYPE6'); 
                 Pkg_Lib.p_c(p_ro.par_label7,p_rn.par_label7,m,c,'PAR_LABEL7'); 
                 Pkg_Lib.p_c(p_ro.par_sql7,p_rn.par_sql7,m,c,'PAR_SQL7'); 
                 Pkg_Lib.p_n(p_ro.par_type7,p_rn.par_type7,m,c,'PAR_TYPE7'); 
                 Pkg_Lib.p_c(p_ro.par_label8,p_rn.par_label8,m,c,'PAR_LABEL8'); 
                 Pkg_Lib.p_c(p_ro.par_sql8,p_rn.par_sql8,m,c,'PAR_SQL8'); 
                 Pkg_Lib.p_n(p_ro.par_type8,p_rn.par_type8,m,c,'PAR_TYPE8'); 
                 Pkg_Lib.p_c(p_ro.par_label9,p_rn.par_label9,m,c,'PAR_LABEL9'); 
                 Pkg_Lib.p_c(p_ro.par_sql9,p_rn.par_sql9,m,c,'PAR_SQL9'); 
                 Pkg_Lib.p_n(p_ro.par_type9,p_rn.par_type9,m,c,'PAR_TYPE9'); 
                 Pkg_Lib.p_c(p_ro.par_label10,p_rn.par_label10,m,c,'PAR_LABEL10'); 
                 Pkg_Lib.p_c(p_ro.par_sql10,p_rn.par_sql10,m,c,'PAR_SQL10'); 
                 Pkg_Lib.p_n(p_ro.par_type10,p_rn.par_type10,m,c,'PAR_TYPE10'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'TASKS',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'form_name:'||p_ro.form_name||','; 
                m   :=  m ||'task_order:'||p_ro.task_order||','; 
                m   :=  m ||'task_name:'||p_ro.task_name||','; 
                m   :=  m ||'par_label1:'||p_ro.par_label1||','; 
                m   :=  m ||'par_sql1:'||p_ro.par_sql1||','; 
                m   :=  m ||'par_type1:'||p_ro.par_type1||','; 
                m   :=  m ||'par_label2:'||p_ro.par_label2||','; 
                m   :=  m ||'par_sql2:'||p_ro.par_sql2||','; 
                m   :=  m ||'par_type2:'||p_ro.par_type2||','; 
                m   :=  m ||'par_label3:'||p_ro.par_label3||','; 
                m   :=  m ||'par_sql3:'||p_ro.par_sql3||','; 
                m   :=  m ||'par_type3:'||p_ro.par_type3||','; 
                m   :=  m ||'par_label4:'||p_ro.par_label4||','; 
                m   :=  m ||'par_sql4:'||p_ro.par_sql4||','; 
                m   :=  m ||'par_type4:'||p_ro.par_type4||','; 
                m   :=  m ||'par_label5:'||p_ro.par_label5||','; 
                m   :=  m ||'par_sql5:'||p_ro.par_sql5||','; 
                m   :=  m ||'par_type5:'||p_ro.par_type5||','; 
                m   :=  m ||'par_label6:'||p_ro.par_label6||','; 
                m   :=  m ||'par_sql6:'||p_ro.par_sql6||','; 
                m   :=  m ||'par_type6:'||p_ro.par_type6||','; 
                m   :=  m ||'par_label7:'||p_ro.par_label7||','; 
                m   :=  m ||'par_sql7:'||p_ro.par_sql7||','; 
                m   :=  m ||'par_type7:'||p_ro.par_type7||','; 
                m   :=  m ||'par_label8:'||p_ro.par_label8||','; 
                m   :=  m ||'par_sql8:'||p_ro.par_sql8||','; 
                m   :=  m ||'par_type8:'||p_ro.par_type8||','; 
                m   :=  m ||'par_label9:'||p_ro.par_label9||','; 
                m   :=  m ||'par_sql9:'||p_ro.par_sql9||','; 
                m   :=  m ||'par_type9:'||p_ro.par_type9||','; 
                m   :=  m ||'par_label10:'||p_ro.par_label10||','; 
                m   :=  m ||'par_sql10:'||p_ro.par_sql10||','; 
                m   :=  m ||'par_type10:'||p_ro.par_type10||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'TASKS',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_teh_variable(p_tip VARCHAR2, p_ro IN OUT TEH_VARIABLE%ROWTYPE, p_rn IN OUT TEH_VARIABLE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_TEH_VARIABLE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.var_code                      := NVL(p_rn.var_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.sql_lov                       := NVL(p_rn.sql_lov,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.var_code,p_rn.var_code,m,c,'VAR_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.sql_lov,p_rn.sql_lov,m,c,'SQL_LOV'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'TEH_VARIABLE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'var_code:'||p_ro.var_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'sql_lov:'||p_ro.sql_lov||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'TEH_VARIABLE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_trn_plan_detail(p_tip VARCHAR2, p_ro IN OUT TRN_PLAN_DETAIL%ROWTYPE, p_rn IN OUT TRN_PLAN_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_TRN_PLAN_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_plan                      := NVL(p_rn.ref_plan,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.whs_code_out                  := NVL(p_rn.whs_code_out,NULL); 
            p_rn.whs_code_in                   := NVL(p_rn.whs_code_in,NULL); 
            p_rn.season_code_out               := NVL(p_rn.season_code_out,NULL); 
            p_rn.season_code_in                := NVL(p_rn.season_code_in,NULL); 
            p_rn.group_code_out                := NVL(p_rn.group_code_out,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.cost_center                   := NVL(p_rn.cost_center,NULL); 
            p_rn.account_code                  := NVL(p_rn.account_code,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.uom                           := NVL(p_rn.uom,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.qty_puom                      := NVL(p_rn.qty_puom,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.group_code_in                 := NVL(p_rn.group_code_in,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_plan,p_rn.ref_plan,m,c,'REF_PLAN'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.whs_code_out,p_rn.whs_code_out,m,c,'WHS_CODE_OUT'); 
                 Pkg_Lib.p_c(p_ro.whs_code_in,p_rn.whs_code_in,m,c,'WHS_CODE_IN'); 
                 Pkg_Lib.p_c(p_ro.season_code_out,p_rn.season_code_out,m,c,'SEASON_CODE_OUT'); 
                 Pkg_Lib.p_c(p_ro.season_code_in,p_rn.season_code_in,m,c,'SEASON_CODE_IN'); 
                 Pkg_Lib.p_c(p_ro.group_code_out,p_rn.group_code_out,m,c,'GROUP_CODE_OUT'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.cost_center,p_rn.cost_center,m,c,'COST_CENTER'); 
                 Pkg_Lib.p_c(p_ro.account_code,p_rn.account_code,m,c,'ACCOUNT_CODE'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_c(p_ro.uom,p_rn.uom,m,c,'UOM'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_n(p_ro.qty_puom,p_rn.qty_puom,m,c,'QTY_PUOM'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_c(p_ro.group_code_in,p_rn.group_code_in,m,c,'GROUP_CODE_IN'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'TRN_PLAN_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_plan:'||p_ro.ref_plan||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'whs_code_out:'||p_ro.whs_code_out||','; 
                m   :=  m ||'whs_code_in:'||p_ro.whs_code_in||','; 
                m   :=  m ||'season_code_out:'||p_ro.season_code_out||','; 
                m   :=  m ||'season_code_in:'||p_ro.season_code_in||','; 
                m   :=  m ||'group_code_out:'||p_ro.group_code_out||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'cost_center:'||p_ro.cost_center||','; 
                m   :=  m ||'account_code:'||p_ro.account_code||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'uom:'||p_ro.uom||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'qty_puom:'||p_ro.qty_puom||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'group_code_in:'||p_ro.group_code_in||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'TRN_PLAN_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_trn_plan_header(p_tip VARCHAR2, p_ro IN OUT TRN_PLAN_HEADER%ROWTYPE, p_rn IN OUT TRN_PLAN_HEADER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_TRN_PLAN_HEADER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.plan_code                     := NVL(p_rn.plan_code,NULL); 
            p_rn.plan_date                     := NVL(p_rn.plan_date,NULL); 
            p_rn.trn_type                      := NVL(p_rn.trn_type,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.partner_code                  := NVL(p_rn.partner_code,NULL); 
            p_rn.doc_code                      := NVL(p_rn.doc_code,NULL); 
            p_rn.doc_date                      := NVL(p_rn.doc_date,NULL); 
            p_rn.date_legal                    := NVL(p_rn.date_legal,NULL); 
            p_rn.employee_code                 := NVL(p_rn.employee_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.suppl_code                    := NVL(p_rn.suppl_code,NULL); 
            p_rn.status                        := NVL(p_rn.status,NULL); 
            p_rn.pick_parameter                := NVL(p_rn.pick_parameter,NULL); 
            p_rn.joly_parameter                := NVL(p_rn.joly_parameter,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.plan_code,p_rn.plan_code,m,c,'PLAN_CODE'); 
                 Pkg_Lib.p_d(p_ro.plan_date,p_rn.plan_date,m,c,'PLAN_DATE'); 
                 Pkg_Lib.p_c(p_ro.trn_type,p_rn.trn_type,m,c,'TRN_TYPE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.partner_code,p_rn.partner_code,m,c,'PARTNER_CODE'); 
                 Pkg_Lib.p_c(p_ro.doc_code,p_rn.doc_code,m,c,'DOC_CODE'); 
                 Pkg_Lib.p_d(p_ro.doc_date,p_rn.doc_date,m,c,'DOC_DATE'); 
                 Pkg_Lib.p_d(p_ro.date_legal,p_rn.date_legal,m,c,'DATE_LEGAL'); 
                 Pkg_Lib.p_c(p_ro.employee_code,p_rn.employee_code,m,c,'EMPLOYEE_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_c(p_ro.suppl_code,p_rn.suppl_code,m,c,'SUPPL_CODE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.pick_parameter,p_rn.pick_parameter,m,c,'PICK_PARAMETER'); 
                 Pkg_Lib.p_c(p_ro.joly_parameter,p_rn.joly_parameter,m,c,'JOLY_PARAMETER'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'TRN_PLAN_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'plan_code:'||p_ro.plan_code||','; 
                m   :=  m ||'plan_date:'||p_ro.plan_date||','; 
                m   :=  m ||'trn_type:'||p_ro.trn_type||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'partner_code:'||p_ro.partner_code||','; 
                m   :=  m ||'doc_code:'||p_ro.doc_code||','; 
                m   :=  m ||'doc_date:'||p_ro.doc_date||','; 
                m   :=  m ||'date_legal:'||p_ro.date_legal||','; 
                m   :=  m ||'employee_code:'||p_ro.employee_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'suppl_code:'||p_ro.suppl_code||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'pick_parameter:'||p_ro.pick_parameter||','; 
                m   :=  m ||'joly_parameter:'||p_ro.joly_parameter||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'TRN_PLAN_HEADER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_value_ad_tax(p_tip VARCHAR2, p_ro IN OUT VALUE_AD_TAX%ROWTYPE, p_rn IN OUT VALUE_AD_TAX%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_VALUE_AD_TAX.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.vat_code                      := NVL(p_rn.vat_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.vat_value                     := NVL(p_rn.vat_value,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.vat_code,p_rn.vat_code,m,c,'VAT_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_n(p_ro.vat_value,p_rn.vat_value,m,c,'VAT_VALUE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'VALUE_AD_TAX',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'vat_code:'||p_ro.vat_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'vat_value:'||p_ro.vat_value||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'VALUE_AD_TAX',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_virtual_table(p_tip VARCHAR2, p_ro IN OUT VIRTUAL_TABLE%ROWTYPE, p_rn IN OUT VIRTUAL_TABLE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_VIRTUAL_TABLE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.segment_code                  := NVL(p_rn.segment_code,NULL); 
            p_rn.txt01                         := NVL(p_rn.txt01,NULL); 
            p_rn.txt02                         := NVL(p_rn.txt02,NULL); 
            p_rn.txt03                         := NVL(p_rn.txt03,NULL); 
            p_rn.txt04                         := NVL(p_rn.txt04,NULL); 
            p_rn.txt05                         := NVL(p_rn.txt05,NULL); 
            p_rn.txt06                         := NVL(p_rn.txt06,NULL); 
            p_rn.txt07                         := NVL(p_rn.txt07,NULL); 
            p_rn.txt08                         := NVL(p_rn.txt08,NULL); 
            p_rn.txt09                         := NVL(p_rn.txt09,NULL); 
            p_rn.txt10                         := NVL(p_rn.txt10,NULL); 
            p_rn.txt11                         := NVL(p_rn.txt11,NULL); 
            p_rn.txt12                         := NVL(p_rn.txt12,NULL); 
            p_rn.txt13                         := NVL(p_rn.txt13,NULL); 
            p_rn.txt14                         := NVL(p_rn.txt14,NULL); 
            p_rn.txt15                         := NVL(p_rn.txt15,NULL); 
            p_rn.txt16                         := NVL(p_rn.txt16,NULL); 
            p_rn.txt17                         := NVL(p_rn.txt17,NULL); 
            p_rn.txt18                         := NVL(p_rn.txt18,NULL); 
            p_rn.txt19                         := NVL(p_rn.txt19,NULL); 
            p_rn.txt20                         := NVL(p_rn.txt20,NULL); 
            p_rn.txt21                         := NVL(p_rn.txt21,NULL); 
            p_rn.txt22                         := NVL(p_rn.txt22,NULL); 
            p_rn.txt23                         := NVL(p_rn.txt23,NULL); 
            p_rn.txt24                         := NVL(p_rn.txt24,NULL); 
            p_rn.txt25                         := NVL(p_rn.txt25,NULL); 
            p_rn.txt26                         := NVL(p_rn.txt26,NULL); 
            p_rn.txt27                         := NVL(p_rn.txt27,NULL); 
            p_rn.txt28                         := NVL(p_rn.txt28,NULL); 
            p_rn.txt29                         := NVL(p_rn.txt29,NULL); 
            p_rn.txt30                         := NVL(p_rn.txt30,NULL); 
            p_rn.numb01                        := NVL(p_rn.numb01,NULL); 
            p_rn.numb02                        := NVL(p_rn.numb02,NULL); 
            p_rn.numb03                        := NVL(p_rn.numb03,NULL); 
            p_rn.numb04                        := NVL(p_rn.numb04,NULL); 
            p_rn.numb05                        := NVL(p_rn.numb05,NULL); 
            p_rn.numb06                        := NVL(p_rn.numb06,NULL); 
            p_rn.numb07                        := NVL(p_rn.numb07,NULL); 
            p_rn.numb08                        := NVL(p_rn.numb08,NULL); 
            p_rn.numb09                        := NVL(p_rn.numb09,NULL); 
            p_rn.numb10                        := NVL(p_rn.numb10,NULL); 
            p_rn.numb11                        := NVL(p_rn.numb11,NULL); 
            p_rn.numb12                        := NVL(p_rn.numb12,NULL); 
            p_rn.numb13                        := NVL(p_rn.numb13,NULL); 
            p_rn.numb14                        := NVL(p_rn.numb14,NULL); 
            p_rn.numb15                        := NVL(p_rn.numb15,NULL); 
            p_rn.numb16                        := NVL(p_rn.numb16,NULL); 
            p_rn.numb17                        := NVL(p_rn.numb17,NULL); 
            p_rn.numb18                        := NVL(p_rn.numb18,NULL); 
            p_rn.numb19                        := NVL(p_rn.numb19,NULL); 
            p_rn.numb20                        := NVL(p_rn.numb20,NULL); 
            p_rn.data01                        := NVL(p_rn.data01,NULL); 
            p_rn.data02                        := NVL(p_rn.data02,NULL); 
            p_rn.data03                        := NVL(p_rn.data03,NULL); 
            p_rn.data04                        := NVL(p_rn.data04,NULL); 
            p_rn.data05                        := NVL(p_rn.data05,NULL); 
            p_rn.data06                        := NVL(p_rn.data06,NULL); 
            p_rn.data07                        := NVL(p_rn.data07,NULL); 
            p_rn.data08                        := NVL(p_rn.data08,NULL); 
            p_rn.data09                        := NVL(p_rn.data09,NULL); 
            p_rn.data10                        := NVL(p_rn.data10,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.segment_code,p_rn.segment_code,m,c,'SEGMENT_CODE'); 
                 Pkg_Lib.p_c(p_ro.txt01,p_rn.txt01,m,c,'TXT01'); 
                 Pkg_Lib.p_c(p_ro.txt02,p_rn.txt02,m,c,'TXT02'); 
                 Pkg_Lib.p_c(p_ro.txt03,p_rn.txt03,m,c,'TXT03'); 
                 Pkg_Lib.p_c(p_ro.txt04,p_rn.txt04,m,c,'TXT04'); 
                 Pkg_Lib.p_c(p_ro.txt05,p_rn.txt05,m,c,'TXT05'); 
                 Pkg_Lib.p_c(p_ro.txt06,p_rn.txt06,m,c,'TXT06'); 
                 Pkg_Lib.p_c(p_ro.txt07,p_rn.txt07,m,c,'TXT07'); 
                 Pkg_Lib.p_c(p_ro.txt08,p_rn.txt08,m,c,'TXT08'); 
                 Pkg_Lib.p_c(p_ro.txt09,p_rn.txt09,m,c,'TXT09'); 
                 Pkg_Lib.p_c(p_ro.txt10,p_rn.txt10,m,c,'TXT10'); 
                 Pkg_Lib.p_c(p_ro.txt11,p_rn.txt11,m,c,'TXT11'); 
                 Pkg_Lib.p_c(p_ro.txt12,p_rn.txt12,m,c,'TXT12'); 
                 Pkg_Lib.p_c(p_ro.txt13,p_rn.txt13,m,c,'TXT13'); 
                 Pkg_Lib.p_c(p_ro.txt14,p_rn.txt14,m,c,'TXT14'); 
                 Pkg_Lib.p_c(p_ro.txt15,p_rn.txt15,m,c,'TXT15'); 
                 Pkg_Lib.p_c(p_ro.txt16,p_rn.txt16,m,c,'TXT16'); 
                 Pkg_Lib.p_c(p_ro.txt17,p_rn.txt17,m,c,'TXT17'); 
                 Pkg_Lib.p_c(p_ro.txt18,p_rn.txt18,m,c,'TXT18'); 
                 Pkg_Lib.p_c(p_ro.txt19,p_rn.txt19,m,c,'TXT19'); 
                 Pkg_Lib.p_c(p_ro.txt20,p_rn.txt20,m,c,'TXT20'); 
                 Pkg_Lib.p_c(p_ro.txt21,p_rn.txt21,m,c,'TXT21'); 
                 Pkg_Lib.p_c(p_ro.txt22,p_rn.txt22,m,c,'TXT22'); 
                 Pkg_Lib.p_c(p_ro.txt23,p_rn.txt23,m,c,'TXT23'); 
                 Pkg_Lib.p_c(p_ro.txt24,p_rn.txt24,m,c,'TXT24'); 
                 Pkg_Lib.p_c(p_ro.txt25,p_rn.txt25,m,c,'TXT25'); 
                 Pkg_Lib.p_c(p_ro.txt26,p_rn.txt26,m,c,'TXT26'); 
                 Pkg_Lib.p_c(p_ro.txt27,p_rn.txt27,m,c,'TXT27'); 
                 Pkg_Lib.p_c(p_ro.txt28,p_rn.txt28,m,c,'TXT28'); 
                 Pkg_Lib.p_c(p_ro.txt29,p_rn.txt29,m,c,'TXT29'); 
                 Pkg_Lib.p_c(p_ro.txt30,p_rn.txt30,m,c,'TXT30'); 
                 Pkg_Lib.p_n(p_ro.numb01,p_rn.numb01,m,c,'NUMB01'); 
                 Pkg_Lib.p_n(p_ro.numb02,p_rn.numb02,m,c,'NUMB02'); 
                 Pkg_Lib.p_n(p_ro.numb03,p_rn.numb03,m,c,'NUMB03'); 
                 Pkg_Lib.p_n(p_ro.numb04,p_rn.numb04,m,c,'NUMB04'); 
                 Pkg_Lib.p_n(p_ro.numb05,p_rn.numb05,m,c,'NUMB05'); 
                 Pkg_Lib.p_n(p_ro.numb06,p_rn.numb06,m,c,'NUMB06'); 
                 Pkg_Lib.p_n(p_ro.numb07,p_rn.numb07,m,c,'NUMB07'); 
                 Pkg_Lib.p_n(p_ro.numb08,p_rn.numb08,m,c,'NUMB08'); 
                 Pkg_Lib.p_n(p_ro.numb09,p_rn.numb09,m,c,'NUMB09'); 
                 Pkg_Lib.p_n(p_ro.numb10,p_rn.numb10,m,c,'NUMB10'); 
                 Pkg_Lib.p_n(p_ro.numb11,p_rn.numb11,m,c,'NUMB11'); 
                 Pkg_Lib.p_n(p_ro.numb12,p_rn.numb12,m,c,'NUMB12'); 
                 Pkg_Lib.p_n(p_ro.numb13,p_rn.numb13,m,c,'NUMB13'); 
                 Pkg_Lib.p_n(p_ro.numb14,p_rn.numb14,m,c,'NUMB14'); 
                 Pkg_Lib.p_n(p_ro.numb15,p_rn.numb15,m,c,'NUMB15'); 
                 Pkg_Lib.p_n(p_ro.numb16,p_rn.numb16,m,c,'NUMB16'); 
                 Pkg_Lib.p_n(p_ro.numb17,p_rn.numb17,m,c,'NUMB17'); 
                 Pkg_Lib.p_n(p_ro.numb18,p_rn.numb18,m,c,'NUMB18'); 
                 Pkg_Lib.p_n(p_ro.numb19,p_rn.numb19,m,c,'NUMB19'); 
                 Pkg_Lib.p_n(p_ro.numb20,p_rn.numb20,m,c,'NUMB20'); 
                 Pkg_Lib.p_d(p_ro.data01,p_rn.data01,m,c,'DATA01'); 
                 Pkg_Lib.p_d(p_ro.data02,p_rn.data02,m,c,'DATA02'); 
                 Pkg_Lib.p_d(p_ro.data03,p_rn.data03,m,c,'DATA03'); 
                 Pkg_Lib.p_d(p_ro.data04,p_rn.data04,m,c,'DATA04'); 
                 Pkg_Lib.p_d(p_ro.data05,p_rn.data05,m,c,'DATA05'); 
                 Pkg_Lib.p_d(p_ro.data06,p_rn.data06,m,c,'DATA06'); 
                 Pkg_Lib.p_d(p_ro.data07,p_rn.data07,m,c,'DATA07'); 
                 Pkg_Lib.p_d(p_ro.data08,p_rn.data08,m,c,'DATA08'); 
                 Pkg_Lib.p_d(p_ro.data09,p_rn.data09,m,c,'DATA09'); 
                 Pkg_Lib.p_d(p_ro.data10,p_rn.data10,m,c,'DATA10'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'VIRTUAL_TABLE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'segment_code:'||p_ro.segment_code||','; 
                m   :=  m ||'txt01:'||p_ro.txt01||','; 
                m   :=  m ||'txt02:'||p_ro.txt02||','; 
                m   :=  m ||'txt03:'||p_ro.txt03||','; 
                m   :=  m ||'txt04:'||p_ro.txt04||','; 
                m   :=  m ||'txt05:'||p_ro.txt05||','; 
                m   :=  m ||'txt06:'||p_ro.txt06||','; 
                m   :=  m ||'txt07:'||p_ro.txt07||','; 
                m   :=  m ||'txt08:'||p_ro.txt08||','; 
                m   :=  m ||'txt09:'||p_ro.txt09||','; 
                m   :=  m ||'txt10:'||p_ro.txt10||','; 
                m   :=  m ||'txt11:'||p_ro.txt11||','; 
                m   :=  m ||'txt12:'||p_ro.txt12||','; 
                m   :=  m ||'txt13:'||p_ro.txt13||','; 
                m   :=  m ||'txt14:'||p_ro.txt14||','; 
                m   :=  m ||'txt15:'||p_ro.txt15||','; 
                m   :=  m ||'txt16:'||p_ro.txt16||','; 
                m   :=  m ||'txt17:'||p_ro.txt17||','; 
                m   :=  m ||'txt18:'||p_ro.txt18||','; 
                m   :=  m ||'txt19:'||p_ro.txt19||','; 
                m   :=  m ||'txt20:'||p_ro.txt20||','; 
                m   :=  m ||'txt21:'||p_ro.txt21||','; 
                m   :=  m ||'txt22:'||p_ro.txt22||','; 
                m   :=  m ||'txt23:'||p_ro.txt23||','; 
                m   :=  m ||'txt24:'||p_ro.txt24||','; 
                m   :=  m ||'txt25:'||p_ro.txt25||','; 
                m   :=  m ||'txt26:'||p_ro.txt26||','; 
                m   :=  m ||'txt27:'||p_ro.txt27||','; 
                m   :=  m ||'txt28:'||p_ro.txt28||','; 
                m   :=  m ||'txt29:'||p_ro.txt29||','; 
                m   :=  m ||'txt30:'||p_ro.txt30||','; 
                m   :=  m ||'numb01:'||p_ro.numb01||','; 
                m   :=  m ||'numb02:'||p_ro.numb02||','; 
                m   :=  m ||'numb03:'||p_ro.numb03||','; 
                m   :=  m ||'numb04:'||p_ro.numb04||','; 
                m   :=  m ||'numb05:'||p_ro.numb05||','; 
                m   :=  m ||'numb06:'||p_ro.numb06||','; 
                m   :=  m ||'numb07:'||p_ro.numb07||','; 
                m   :=  m ||'numb08:'||p_ro.numb08||','; 
                m   :=  m ||'numb09:'||p_ro.numb09||','; 
                m   :=  m ||'numb10:'||p_ro.numb10||','; 
                m   :=  m ||'numb11:'||p_ro.numb11||','; 
                m   :=  m ||'numb12:'||p_ro.numb12||','; 
                m   :=  m ||'numb13:'||p_ro.numb13||','; 
                m   :=  m ||'numb14:'||p_ro.numb14||','; 
                m   :=  m ||'numb15:'||p_ro.numb15||','; 
                m   :=  m ||'numb16:'||p_ro.numb16||','; 
                m   :=  m ||'numb17:'||p_ro.numb17||','; 
                m   :=  m ||'numb18:'||p_ro.numb18||','; 
                m   :=  m ||'numb19:'||p_ro.numb19||','; 
                m   :=  m ||'numb20:'||p_ro.numb20||','; 
                m   :=  m ||'data01:'||p_ro.data01||','; 
                m   :=  m ||'data02:'||p_ro.data02||','; 
                m   :=  m ||'data03:'||p_ro.data03||','; 
                m   :=  m ||'data04:'||p_ro.data04||','; 
                m   :=  m ||'data05:'||p_ro.data05||','; 
                m   :=  m ||'data06:'||p_ro.data06||','; 
                m   :=  m ||'data07:'||p_ro.data07||','; 
                m   :=  m ||'data08:'||p_ro.data08||','; 
                m   :=  m ||'data09:'||p_ro.data09||','; 
                m   :=  m ||'data10:'||p_ro.data10||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'VIRTUAL_TABLE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_warehouse(p_tip VARCHAR2, p_ro IN OUT WAREHOUSE%ROWTYPE, p_rn IN OUT WAREHOUSE%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WAREHOUSE.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.account_code                  := NVL(p_rn.account_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.category_code                 := NVL(p_rn.category_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.account_code,p_rn.account_code,m,c,'ACCOUNT_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.category_code,p_rn.category_code,m,c,'CATEGORY_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WAREHOUSE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.WHS_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'account_code:'||p_ro.account_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'category_code:'||p_ro.category_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WAREHOUSE',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.WHS_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_warehouse_categ(p_tip VARCHAR2, p_ro IN OUT WAREHOUSE_CATEG%ROWTYPE, p_rn IN OUT WAREHOUSE_CATEG%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WAREHOUSE_CATEG.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.category_code                 := NVL(p_rn.category_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.valuation_type                := NVL(p_rn.valuation_type,NULL); 
            p_rn.qty_on_hand                   := NVL(p_rn.qty_on_hand,NULL); 
            p_rn.custody                       := NVL(p_rn.custody,NULL); 
            p_rn.intern                        := NVL(p_rn.intern,NULL); 
            p_rn.virtual                       := NVL(p_rn.virtual,NULL); 
            p_rn.allow_negative                := NVL(p_rn.allow_negative,NULL); 
            p_rn.accounting                    := NVL(p_rn.accounting,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.category_code,p_rn.category_code,m,c,'CATEGORY_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.valuation_type,p_rn.valuation_type,m,c,'VALUATION_TYPE'); 
                 Pkg_Lib.p_c(p_ro.qty_on_hand,p_rn.qty_on_hand,m,c,'QTY_ON_HAND'); 
                 Pkg_Lib.p_c(p_ro.custody,p_rn.custody,m,c,'CUSTODY'); 
                 Pkg_Lib.p_c(p_ro.intern,p_rn.intern,m,c,'INTERN'); 
                 Pkg_Lib.p_c(p_ro.virtual,p_rn.virtual,m,c,'VIRTUAL'); 
                 Pkg_Lib.p_c(p_ro.allow_negative,p_rn.allow_negative,m,c,'ALLOW_NEGATIVE'); 
                 Pkg_Lib.p_c(p_ro.accounting,p_rn.accounting,m,c,'ACCOUNTING'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WAREHOUSE_CATEG',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CATEGORY_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'category_code:'||p_ro.category_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'valuation_type:'||p_ro.valuation_type||','; 
                m   :=  m ||'qty_on_hand:'||p_ro.qty_on_hand||','; 
                m   :=  m ||'custody:'||p_ro.custody||','; 
                m   :=  m ||'intern:'||p_ro.intern||','; 
                m   :=  m ||'virtual:'||p_ro.virtual||','; 
                m   :=  m ||'allow_negative:'||p_ro.allow_negative||','; 
                m   :=  m ||'accounting:'||p_ro.accounting||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WAREHOUSE_CATEG',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.CATEGORY_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_web_grid_cm(p_tip VARCHAR2, p_ro IN OUT WEB_GRID_CM%ROWTYPE, p_rn IN OUT WEB_GRID_CM%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WEB_GRID_CM.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.grid_name                     := NVL(p_rn.grid_name,NULL); 
            p_rn.control_name                  := NVL(p_rn.control_name,NULL); 
            p_rn.seq_no                        := NVL(p_rn.seq_no,NULL); 
            p_rn.caption                       := NVL(p_rn.caption,NULL); 
            p_rn.width                         := NVL(p_rn.width,NULL); 
            p_rn.controlsource                 := NVL(p_rn.controlsource,NULL); 
            p_rn.iseditable                    := NVL(p_rn.iseditable,NULL); 
            p_rn.ishidden                      := NVL(p_rn.ishidden,NULL); 
            p_rn.renderer                      := NVL(p_rn.renderer,NULL); 
            p_rn.client_code                   := NVL(p_rn.client_code,NULL); 
            p_rn.align                         := NVL(p_rn.align,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.grid_name,p_rn.grid_name,m,c,'GRID_NAME'); 
                 Pkg_Lib.p_c(p_ro.control_name,p_rn.control_name,m,c,'CONTROL_NAME'); 
                 Pkg_Lib.p_n(p_ro.seq_no,p_rn.seq_no,m,c,'SEQ_NO'); 
                 Pkg_Lib.p_c(p_ro.caption,p_rn.caption,m,c,'CAPTION'); 
                 Pkg_Lib.p_n(p_ro.width,p_rn.width,m,c,'WIDTH'); 
                 Pkg_Lib.p_c(p_ro.controlsource,p_rn.controlsource,m,c,'CONTROLSOURCE'); 
                 Pkg_Lib.p_c(p_ro.iseditable,p_rn.iseditable,m,c,'ISEDITABLE'); 
                 Pkg_Lib.p_c(p_ro.ishidden,p_rn.ishidden,m,c,'ISHIDDEN'); 
                 Pkg_Lib.p_c(p_ro.renderer,p_rn.renderer,m,c,'RENDERER'); 
                 Pkg_Lib.p_c(p_ro.client_code,p_rn.client_code,m,c,'CLIENT_CODE'); 
                 Pkg_Lib.p_c(p_ro.align,p_rn.align,m,c,'ALIGN'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WEB_GRID_CM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'grid_name:'||p_ro.grid_name||','; 
                m   :=  m ||'control_name:'||p_ro.control_name||','; 
                m   :=  m ||'seq_no:'||p_ro.seq_no||','; 
                m   :=  m ||'caption:'||p_ro.caption||','; 
                m   :=  m ||'width:'||p_ro.width||','; 
                m   :=  m ||'controlsource:'||p_ro.controlsource||','; 
                m   :=  m ||'iseditable:'||p_ro.iseditable||','; 
                m   :=  m ||'ishidden:'||p_ro.ishidden||','; 
                m   :=  m ||'renderer:'||p_ro.renderer||','; 
                m   :=  m ||'client_code:'||p_ro.client_code||','; 
                m   :=  m ||'align:'||p_ro.align||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WEB_GRID_CM',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_whs_trn(p_tip VARCHAR2, p_ro IN OUT WHS_TRN%ROWTYPE, p_rn IN OUT WHS_TRN%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WHS_TRN.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.trn_year                      := NVL(p_rn.trn_year,NULL); 
            p_rn.trn_code                      := NVL(p_rn.trn_code,NULL); 
            p_rn.trn_date                      := NVL(p_rn.trn_date,NULL); 
            p_rn.trn_type                      := NVL(p_rn.trn_type,NULL); 
            p_rn.reason_code                   := NVL(p_rn.reason_code,NULL); 
            p_rn.flag_storno                   := NVL(p_rn.flag_storno,NULL); 
            p_rn.ref_shipment                  := NVL(p_rn.ref_shipment,NULL); 
            p_rn.ref_storno                    := NVL(p_rn.ref_storno,NULL); 
            p_rn.partner_code                  := NVL(p_rn.partner_code,NULL); 
            p_rn.doc_year                      := NVL(p_rn.doc_year,NULL); 
            p_rn.doc_code                      := NVL(p_rn.doc_code,NULL); 
            p_rn.doc_date                      := NVL(p_rn.doc_date,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.employee_code                 := NVL(p_rn.employee_code,NULL); 
            p_rn.date_legal                    := NVL(p_rn.date_legal,NULL); 
            p_rn.ref_master                    := NVL(p_rn.ref_master,NULL); 
            p_rn.ref_receipt                   := NVL(p_rn.ref_receipt,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.trn_year,p_rn.trn_year,m,c,'TRN_YEAR'); 
                 Pkg_Lib.p_c(p_ro.trn_code,p_rn.trn_code,m,c,'TRN_CODE'); 
                 Pkg_Lib.p_d(p_ro.trn_date,p_rn.trn_date,m,c,'TRN_DATE'); 
                 Pkg_Lib.p_c(p_ro.trn_type,p_rn.trn_type,m,c,'TRN_TYPE'); 
                 Pkg_Lib.p_c(p_ro.reason_code,p_rn.reason_code,m,c,'REASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.flag_storno,p_rn.flag_storno,m,c,'FLAG_STORNO'); 
                 Pkg_Lib.p_n(p_ro.ref_shipment,p_rn.ref_shipment,m,c,'REF_SHIPMENT'); 
                 Pkg_Lib.p_n(p_ro.ref_storno,p_rn.ref_storno,m,c,'REF_STORNO'); 
                 Pkg_Lib.p_c(p_ro.partner_code,p_rn.partner_code,m,c,'PARTNER_CODE'); 
                 Pkg_Lib.p_c(p_ro.doc_year,p_rn.doc_year,m,c,'DOC_YEAR'); 
                 Pkg_Lib.p_c(p_ro.doc_code,p_rn.doc_code,m,c,'DOC_CODE'); 
                 Pkg_Lib.p_d(p_ro.doc_date,p_rn.doc_date,m,c,'DOC_DATE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.employee_code,p_rn.employee_code,m,c,'EMPLOYEE_CODE'); 
                 Pkg_Lib.p_d(p_ro.date_legal,p_rn.date_legal,m,c,'DATE_LEGAL'); 
                 Pkg_Lib.p_n(p_ro.ref_master,p_rn.ref_master,m,c,'REF_MASTER'); 
                 Pkg_Lib.p_n(p_ro.ref_receipt,p_rn.ref_receipt,m,c,'REF_RECEIPT'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WHS_TRN',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'trn_year:'||p_ro.trn_year||','; 
                m   :=  m ||'trn_code:'||p_ro.trn_code||','; 
                m   :=  m ||'trn_date:'||p_ro.trn_date||','; 
                m   :=  m ||'trn_type:'||p_ro.trn_type||','; 
                m   :=  m ||'reason_code:'||p_ro.reason_code||','; 
                m   :=  m ||'flag_storno:'||p_ro.flag_storno||','; 
                m   :=  m ||'ref_shipment:'||p_ro.ref_shipment||','; 
                m   :=  m ||'ref_storno:'||p_ro.ref_storno||','; 
                m   :=  m ||'partner_code:'||p_ro.partner_code||','; 
                m   :=  m ||'doc_year:'||p_ro.doc_year||','; 
                m   :=  m ||'doc_code:'||p_ro.doc_code||','; 
                m   :=  m ||'doc_date:'||p_ro.doc_date||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'employee_code:'||p_ro.employee_code||','; 
                m   :=  m ||'date_legal:'||p_ro.date_legal||','; 
                m   :=  m ||'ref_master:'||p_ro.ref_master||','; 
                m   :=  m ||'ref_receipt:'||p_ro.ref_receipt||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WHS_TRN',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_whs_trn_detail(p_tip VARCHAR2, p_ro IN OUT WHS_TRN_DETAIL%ROWTYPE, p_rn IN OUT WHS_TRN_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WHS_TRN_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_trn                       := NVL(p_rn.ref_trn,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.trn_sign                      := NVL(p_rn.trn_sign,NULL); 
            p_rn.qty                           := NVL(p_rn.qty,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
            p_rn.colour_code                   := NVL(p_rn.colour_code,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.puom                          := NVL(p_rn.puom,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.cost_center                   := NVL(p_rn.cost_center,NULL); 
            p_rn.account_code                  := NVL(p_rn.account_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.reason_code                   := NVL(p_rn.reason_code,NULL); 
            p_rn.ref_receipt                   := NVL(p_rn.ref_receipt,NULL); 
            p_rn.wc_code                       := NVL(p_rn.wc_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_trn,p_rn.ref_trn,m,c,'REF_TRN'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_n(p_ro.trn_sign,p_rn.trn_sign,m,c,'TRN_SIGN'); 
                 Pkg_Lib.p_n(p_ro.qty,p_rn.qty,m,c,'QTY'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                 Pkg_Lib.p_c(p_ro.colour_code,p_rn.colour_code,m,c,'COLOUR_CODE'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.puom,p_rn.puom,m,c,'PUOM'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.cost_center,p_rn.cost_center,m,c,'COST_CENTER'); 
                 Pkg_Lib.p_c(p_ro.account_code,p_rn.account_code,m,c,'ACCOUNT_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.reason_code,p_rn.reason_code,m,c,'REASON_CODE'); 
                 Pkg_Lib.p_n(p_ro.ref_receipt,p_rn.ref_receipt,m,c,'REF_RECEIPT'); 
                 Pkg_Lib.p_c(p_ro.wc_code,p_rn.wc_code,m,c,'WC_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WHS_TRN_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_trn:'||p_ro.ref_trn||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'trn_sign:'||p_ro.trn_sign||','; 
                m   :=  m ||'qty:'||p_ro.qty||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                m   :=  m ||'colour_code:'||p_ro.colour_code||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'puom:'||p_ro.puom||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'cost_center:'||p_ro.cost_center||','; 
                m   :=  m ||'account_code:'||p_ro.account_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'reason_code:'||p_ro.reason_code||','; 
                m   :=  m ||'ref_receipt:'||p_ro.ref_receipt||','; 
                m   :=  m ||'wc_code:'||p_ro.wc_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WHS_TRN_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_whs_trn_reason(p_tip VARCHAR2, p_ro IN OUT WHS_TRN_REASON%ROWTYPE, p_rn IN OUT WHS_TRN_REASON%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WHS_TRN_REASON.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.sbu_code                      := NVL(p_rn.sbu_code,NULL); 
            p_rn.reason_code                   := NVL(p_rn.reason_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.reason_type                   := NVL(p_rn.reason_type,NULL); 
            p_rn.trn_sign                      := NVL(p_rn.trn_sign,NULL); 
            p_rn.property                      := NVL(p_rn.property,NULL); 
            p_rn.alloc_wo                      := NVL(p_rn.alloc_wo,NULL); 
            p_rn.accounting                    := NVL(p_rn.accounting,NULL); 
            p_rn.business_flow                 := NVL(p_rn.business_flow,NULL); 
            p_rn.show_user                     := NVL(p_rn.show_user,'Y' ); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.sbu_code,p_rn.sbu_code,m,c,'SBU_CODE'); 
                 Pkg_Lib.p_c(p_ro.reason_code,p_rn.reason_code,m,c,'REASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.reason_type,p_rn.reason_type,m,c,'REASON_TYPE'); 
                 Pkg_Lib.p_n(p_ro.trn_sign,p_rn.trn_sign,m,c,'TRN_SIGN'); 
                 Pkg_Lib.p_c(p_ro.property,p_rn.property,m,c,'PROPERTY'); 
                 Pkg_Lib.p_c(p_ro.alloc_wo,p_rn.alloc_wo,m,c,'ALLOC_WO'); 
                 Pkg_Lib.p_c(p_ro.accounting,p_rn.accounting,m,c,'ACCOUNTING'); 
                 Pkg_Lib.p_n(p_ro.business_flow,p_rn.business_flow,m,c,'BUSINESS_FLOW'); 
                 Pkg_Lib.p_c(p_ro.show_user,p_rn.show_user,m,c,'SHOW_USER'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WHS_TRN_REASON',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'sbu_code:'||p_ro.sbu_code||','; 
                m   :=  m ||'reason_code:'||p_ro.reason_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'reason_type:'||p_ro.reason_type||','; 
                m   :=  m ||'trn_sign:'||p_ro.trn_sign||','; 
                m   :=  m ||'property:'||p_ro.property||','; 
                m   :=  m ||'alloc_wo:'||p_ro.alloc_wo||','; 
                m   :=  m ||'accounting:'||p_ro.accounting||','; 
                m   :=  m ||'business_flow:'||p_ro.business_flow||','; 
                m   :=  m ||'show_user:'||p_ro.show_user||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WHS_TRN_REASON',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_wiz_control(p_tip VARCHAR2, p_ro IN OUT WIZ_CONTROL%ROWTYPE, p_rn IN OUT WIZ_CONTROL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WIZ_CONTROL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.wiz_code                      := NVL(p_rn.wiz_code,NULL); 
            p_rn.control_name                  := NVL(p_rn.control_name,NULL); 
            p_rn.width                         := NVL(p_rn.width,NULL); 
            p_rn.controlsource                 := NVL(p_rn.controlsource,NULL); 
            p_rn.editable                      := NVL(p_rn.editable,NULL); 
            p_rn.align                         := NVL(p_rn.align,NULL); 
            p_rn.sql_lov                       := NVL(p_rn.sql_lov,NULL); 
            p_rn.label                         := NVL(p_rn.label,NULL); 
            p_rn.step_no                       := NVL(p_rn.step_no,NULL); 
            p_rn.backcolor                     := NVL(p_rn.backcolor,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.wiz_code,p_rn.wiz_code,m,c,'WIZ_CODE'); 
                 Pkg_Lib.p_c(p_ro.control_name,p_rn.control_name,m,c,'CONTROL_NAME'); 
                 Pkg_Lib.p_n(p_ro.width,p_rn.width,m,c,'WIDTH'); 
                 Pkg_Lib.p_c(p_ro.controlsource,p_rn.controlsource,m,c,'CONTROLSOURCE'); 
                 Pkg_Lib.p_c(p_ro.editable,p_rn.editable,m,c,'EDITABLE'); 
                 Pkg_Lib.p_c(p_ro.align,p_rn.align,m,c,'ALIGN'); 
                 Pkg_Lib.p_c(p_ro.sql_lov,p_rn.sql_lov,m,c,'SQL_LOV'); 
                 Pkg_Lib.p_c(p_ro.label,p_rn.label,m,c,'LABEL'); 
                 Pkg_Lib.p_n(p_ro.step_no,p_rn.step_no,m,c,'STEP_NO'); 
                 Pkg_Lib.p_n(p_ro.backcolor,p_rn.backcolor,m,c,'BACKCOLOR'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WIZ_CONTROL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'wiz_code:'||p_ro.wiz_code||','; 
                m   :=  m ||'control_name:'||p_ro.control_name||','; 
                m   :=  m ||'width:'||p_ro.width||','; 
                m   :=  m ||'controlsource:'||p_ro.controlsource||','; 
                m   :=  m ||'editable:'||p_ro.editable||','; 
                m   :=  m ||'align:'||p_ro.align||','; 
                m   :=  m ||'sql_lov:'||p_ro.sql_lov||','; 
                m   :=  m ||'label:'||p_ro.label||','; 
                m   :=  m ||'step_no:'||p_ro.step_no||','; 
                m   :=  m ||'backcolor:'||p_ro.backcolor||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WIZ_CONTROL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  NULL,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_workcenter(p_tip VARCHAR2, p_ro IN OUT WORKCENTER%ROWTYPE, p_rn IN OUT WORKCENTER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WORKCENTER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.workcenter_code               := NVL(p_rn.workcenter_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.costcenter_code               := NVL(p_rn.costcenter_code,NULL); 
            p_rn.whs_code                      := NVL(p_rn.whs_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.workcenter_code,p_rn.workcenter_code,m,c,'WORKCENTER_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.costcenter_code,p_rn.costcenter_code,m,c,'COSTCENTER_CODE'); 
                 Pkg_Lib.p_c(p_ro.whs_code,p_rn.whs_code,m,c,'WHS_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WORKCENTER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.WORKCENTER_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'workcenter_code:'||p_ro.workcenter_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'costcenter_code:'||p_ro.costcenter_code||','; 
                m   :=  m ||'whs_code:'||p_ro.whs_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WORKCENTER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.WORKCENTER_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_workcenter_oper(p_tip VARCHAR2, p_ro IN OUT WORKCENTER_OPER%ROWTYPE, p_rn IN OUT WORKCENTER_OPER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WORKCENTER_OPER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.workcenter_code               := NVL(p_rn.workcenter_code,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.workcenter_code,p_rn.workcenter_code,m,c,'WORKCENTER_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WORKCENTER_OPER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.WORKCENTER_CODE,
                        p_tbl_idx2     =>  p_ro.OPER_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'workcenter_code:'||p_ro.workcenter_code||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WORKCENTER_OPER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.WORKCENTER_CODE,
                        p_tbl_idx2     =>  p_ro.OPER_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_work_group(p_tip VARCHAR2, p_ro IN OUT WORK_GROUP%ROWTYPE, p_rn IN OUT WORK_GROUP%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WORK_GROUP.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.status                        := NVL(p_rn.status,'I' ); 
            p_rn.date_launch                   := NVL(p_rn.date_launch,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_d(p_ro.date_launch,p_rn.date_launch,m,c,'DATE_LAUNCH'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WORK_GROUP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.GROUP_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'date_launch:'||p_ro.date_launch||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WORK_GROUP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.GROUP_CODE,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_work_order(p_tip VARCHAR2, p_ro IN OUT WORK_ORDER%ROWTYPE, p_rn IN OUT WORK_ORDER%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WORK_ORDER.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.item_code                     := NVL(p_rn.item_code,NULL); 
            p_rn.status                        := NVL(p_rn.status,'I' ); 
            p_rn.line                          := NVL(p_rn.line,NULL); 
            p_rn.priority                      := NVL(p_rn.priority,'N' ); 
            p_rn.date_create                   := NVL(p_rn.date_create,NULL); 
            p_rn.date_launch                   := NVL(p_rn.date_launch,NULL); 
            p_rn.date_complet                  := NVL(p_rn.date_complet,NULL); 
            p_rn.date_client                   := NVL(p_rn.date_client,NULL); 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.client_lot                    := NVL(p_rn.client_lot,NULL); 
            p_rn.client_location               := NVL(p_rn.client_location,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.note                          := NVL(p_rn.note,NULL); 
            p_rn.routing_code                  := NVL(p_rn.routing_code,NULL); 
            p_rn.oper_code_item                := NVL(p_rn.oper_code_item,NULL); 
            p_rn.client_code                   := NVL(p_rn.client_code,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.item_code,p_rn.item_code,m,c,'ITEM_CODE'); 
                 Pkg_Lib.p_c(p_ro.status,p_rn.status,m,c,'STATUS'); 
                 Pkg_Lib.p_c(p_ro.line,p_rn.line,m,c,'LINE'); 
                 Pkg_Lib.p_c(p_ro.priority,p_rn.priority,m,c,'PRIORITY'); 
                 Pkg_Lib.p_d(p_ro.date_create,p_rn.date_create,m,c,'DATE_CREATE'); 
                 Pkg_Lib.p_d(p_ro.date_launch,p_rn.date_launch,m,c,'DATE_LAUNCH'); 
                 Pkg_Lib.p_d(p_ro.date_complet,p_rn.date_complet,m,c,'DATE_COMPLET'); 
                 Pkg_Lib.p_d(p_ro.date_client,p_rn.date_client,m,c,'DATE_CLIENT'); 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.client_lot,p_rn.client_lot,m,c,'CLIENT_LOT'); 
                 Pkg_Lib.p_c(p_ro.client_location,p_rn.client_location,m,c,'CLIENT_LOCATION'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.note,p_rn.note,m,c,'NOTE'); 
                 Pkg_Lib.p_c(p_ro.routing_code,p_rn.routing_code,m,c,'ROUTING_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code_item,p_rn.oper_code_item,m,c,'OPER_CODE_ITEM'); 
                 Pkg_Lib.p_c(p_ro.client_code,p_rn.client_code,m,c,'CLIENT_CODE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WORK_ORDER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ORDER_CODE,
                        p_tbl_idx2     =>  p_ro.ORG_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'item_code:'||p_ro.item_code||','; 
                m   :=  m ||'status:'||p_ro.status||','; 
                m   :=  m ||'line:'||p_ro.line||','; 
                m   :=  m ||'priority:'||p_ro.priority||','; 
                m   :=  m ||'date_create:'||p_ro.date_create||','; 
                m   :=  m ||'date_launch:'||p_ro.date_launch||','; 
                m   :=  m ||'date_complet:'||p_ro.date_complet||','; 
                m   :=  m ||'date_client:'||p_ro.date_client||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'client_lot:'||p_ro.client_lot||','; 
                m   :=  m ||'client_location:'||p_ro.client_location||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'note:'||p_ro.note||','; 
                m   :=  m ||'routing_code:'||p_ro.routing_code||','; 
                m   :=  m ||'oper_code_item:'||p_ro.oper_code_item||','; 
                m   :=  m ||'client_code:'||p_ro.client_code||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WORK_ORDER',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.ORDER_CODE,
                        p_tbl_idx2     =>  p_ro.ORG_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_work_season(p_tip VARCHAR2, p_ro IN OUT WORK_SEASON%ROWTYPE, p_rn IN OUT WORK_SEASON%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WORK_SEASON.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.season_code                   := NVL(p_rn.season_code,NULL); 
            p_rn.description                   := NVL(p_rn.description,NULL); 
            p_rn.flag_active                   := NVL(p_rn.flag_active,NULL); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.season_code,p_rn.season_code,m,c,'SEASON_CODE'); 
                 Pkg_Lib.p_c(p_ro.description,p_rn.description,m,c,'DESCRIPTION'); 
                 Pkg_Lib.p_c(p_ro.flag_active,p_rn.flag_active,m,c,'FLAG_ACTIVE'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WORK_SEASON',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.SEASON_CODE,
                        p_tbl_idx2     =>  p_ro.ORG_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'season_code:'||p_ro.season_code||','; 
                m   :=  m ||'description:'||p_ro.description||','; 
                m   :=  m ||'flag_active:'||p_ro.flag_active||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WORK_SEASON',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.SEASON_CODE,
                        p_tbl_idx2     =>  p_ro.ORG_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_wo_detail(p_tip VARCHAR2, p_ro IN OUT WO_DETAIL%ROWTYPE, p_rn IN OUT WO_DETAIL%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WO_DETAIL.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.ref_wo                        := NVL(p_rn.ref_wo,NULL); 
            p_rn.size_code                     := NVL(p_rn.size_code,NULL); 
            p_rn.qta                           := NVL(p_rn.qta,NULL); 
            p_rn.qta_complet                   := NVL(p_rn.qta_complet,0 ); 
            p_rn.qta_scrap                     := NVL(p_rn.qta_scrap,0 ); 
            p_rn.qta_ship_good                 := NVL(p_rn.qta_ship_good,0 ); 
            p_rn.qta_ship_scrap                := NVL(p_rn.qta_ship_scrap,0 ); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_n(p_ro.ref_wo,p_rn.ref_wo,m,c,'REF_WO'); 
                 Pkg_Lib.p_c(p_ro.size_code,p_rn.size_code,m,c,'SIZE_CODE'); 
                 Pkg_Lib.p_n(p_ro.qta,p_rn.qta,m,c,'QTA'); 
                 Pkg_Lib.p_n(p_ro.qta_complet,p_rn.qta_complet,m,c,'QTA_COMPLET'); 
                 Pkg_Lib.p_n(p_ro.qta_scrap,p_rn.qta_scrap,m,c,'QTA_SCRAP'); 
                 Pkg_Lib.p_n(p_ro.qta_ship_good,p_rn.qta_ship_good,m,c,'QTA_SHIP_GOOD'); 
                 Pkg_Lib.p_n(p_ro.qta_ship_scrap,p_rn.qta_ship_scrap,m,c,'QTA_SHIP_SCRAP'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WO_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.REF_WO,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'ref_wo:'||p_ro.ref_wo||','; 
                m   :=  m ||'size_code:'||p_ro.size_code||','; 
                m   :=  m ||'qta:'||p_ro.qta||','; 
                m   :=  m ||'qta_complet:'||p_ro.qta_complet||','; 
                m   :=  m ||'qta_scrap:'||p_ro.qta_scrap||','; 
                m   :=  m ||'qta_ship_good:'||p_ro.qta_ship_good||','; 
                m   :=  m ||'qta_ship_scrap:'||p_ro.qta_ship_scrap||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WO_DETAIL',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.REF_WO,
                        p_tbl_idx2     =>  NULL,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

--------------------------------------------------------------------
PROCEDURE p_wo_group(p_tip VARCHAR2, p_ro IN OUT WO_GROUP%ROWTYPE, p_rn IN OUT WO_GROUP%ROWTYPE )
IS
    CURSOR  C_LINE IS  
            SELECT SC_WO_GROUP.nextval AS result FROM DUAL; 
    c VARCHAR2(30000);
    m VARCHAR2(32000);
BEGIN

    CASE p_tip 
        WHEN 'I' THEN 
            IF p_rn.IDRIGA IS NULL THEN 
                OPEN  C_LINE;
                FETCH C_LINE INTO p_rn.IDRIGA;
                CLOSE C_LINE;
            END IF; 
            p_rn.datagg                        :=  NVL(p_rn.datagg,SYSDATE); 
            p_rn.workst                        :=  NVL(p_rn.workst,SYS_CONTEXT('USERENV','HOST')); 
            p_rn.osuser                        :=  NVL(p_rn.osuser,UPPER(SYS_CONTEXT('USERENV','OS_USER'))); 
            p_rn.nuser                         :=  NVL(p_rn.nuser,USER); 
            p_rn.iduser                        :=  NVL(p_rn.iduser,Pkg_App_Secur.f_return_user()); 
            p_rn.dcn                           :=  0; 
            p_rn.group_code                    := NVL(p_rn.group_code,NULL); 
            p_rn.org_code                      := NVL(p_rn.org_code,NULL); 
            p_rn.order_code                    := NVL(p_rn.order_code,NULL); 
            p_rn.oper_code                     := NVL(p_rn.oper_code,NULL); 
            p_rn.row_version                   := NVL(p_rn.row_version,0); 
        WHEN 'U' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                 Pkg_Lib.p_c(p_ro.group_code,p_rn.group_code,m,c,'GROUP_CODE'); 
                 Pkg_Lib.p_c(p_ro.org_code,p_rn.org_code,m,c,'ORG_CODE'); 
                 Pkg_Lib.p_c(p_ro.order_code,p_rn.order_code,m,c,'ORDER_CODE'); 
                 Pkg_Lib.p_c(p_ro.oper_code,p_rn.oper_code,m,c,'OPER_CODE'); 
                 Pkg_Lib.p_n(p_ro.row_version,p_rn.row_version,m,c,'ROW_VERSION'); 
                IF c IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'UPDATE',
                        p_tbl_name     =>  'WO_GROUP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.GROUP_CODE,
                        p_tbl_idx2     =>  p_ro.ORDER_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
        WHEN 'D' THEN 
            IF Pkg_Audit.f_return_faudit() = 0 THEN 
                m   :=  m ||'datagg:'||p_ro.datagg||','; 
                m   :=  m ||'workst:'||p_ro.workst||','; 
                m   :=  m ||'osuser:'||p_ro.osuser||','; 
                m   :=  m ||'nuser:'||p_ro.nuser||','; 
                m   :=  m ||'iduser:'||p_ro.iduser||','; 
                m   :=  m ||'dcn:'||p_ro.dcn||','; 
                m   :=  m ||'idriga:'||p_ro.idriga||','; 
                m   :=  m ||'group_code:'||p_ro.group_code||','; 
                m   :=  m ||'org_code:'||p_ro.org_code||','; 
                m   :=  m ||'order_code:'||p_ro.order_code||','; 
                m   :=  m ||'oper_code:'||p_ro.oper_code||','; 
                m   :=  m ||'row_version:'||p_ro.row_version||','; 
                IF m IS NOT NULL THEN 
                    Pkg_Audit.p_app_audit_insert(
                        p_tbl_oper     =>  'DELETE',
                        p_tbl_name     =>  'WO_GROUP',
                        p_tbl_idriga   =>  p_ro.IDRIGA,
                        p_tbl_idx1     =>  p_ro.GROUP_CODE,
                        p_tbl_idx2     =>  p_ro.ORDER_CODE,
                        p_note         =>  m 
                    );
                END IF;
            END IF; 
    END CASE; 
END;

END; 

/

/
