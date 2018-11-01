--------------------------------------------------------
--  DDL for Package PKG_DOC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_DOC" 
IS
/*

-- 20.04.2008
    -- delete from item_size the sizes foe shirets
    -- setup the FIFO_ROUND_UNIT in CAT_MAT_TYPE
    -- delete from  CAT_MAT_TYPE the NECLASIFICATE and put ???
    -- do not forget SYS_LOCKING to put FIFO
    -- introduce WHS_CATEGORY SHP change the association for the EXP warehouse
    -- update country description to upper case
    -- extend TMP_SEGMENT some varchar2 column to 4000
    -- extend VW_ERROR message column to 1000

-- 25.04.2008
    -- check routing for null in workcenter
    -- change for client DUN from AU to AT

-- 26.04.2008
    -- modify season for some declaration due to workorder season modification after launch
    -- modify consumption warehouse from WIP to CTL_CLUJ and wice versa fore some declaration of production    
    -- SERIOUS DISCASSION ON PRECISION !!!!!!! do we need 4 decimals in the bill of material for work group ?
    -- do not forget the reason codes to append to the WHS_TRN_REASON
    -- in SETUP_RECEIPT populate the TRN_TYPE
    -- reactivat verificarea de stocuri la DPR
   
--07.05.2008
    -- apply constraint the item code and order code CAN NOT contain coma because we have o problem then with
       the f_sql_inlist function   
   

--20.05.2008
    -- exists receipt that has oper_code_item filled, is this correct ?

--24.05.2008 
    -- introduce new receipt type in SETUP_RECEIPT change between ME1 and ME2
    -- introduce new warehouses
    -- upgrade the MOVEMENT_TYPE table



--26.05.2008 
    --  delete all from app_user_grant@FTY + delete all from app_securitem@FTY + insert in FTY from app_securitem@LOCAL 
    --  

-- 29.05.08
    -- check the receipt types MI1 and MI3
    -- change the property for SI1 to N
    -- update in MOVEMENT_TYPE joly_parameter to TRN_CNS

-- 02.06.08
    -- remove the warehouse from receipt SI1
    
-- 03.06.08
    -- applying in ACCESS in the receipt from with the round - sum thing    
    -- setup accrec from
    -- introduce new in setup acrec
    -- introduce in APP_SECURITEM SYS_TAB
    -- take MULTI_TABLE
    -- modified invoice reports, create a new invoice report  
    -- change in SETUP_ACCREC the invoice objects name

-- 07.06.08
    -- modify for TRN_CNS,REC_CTL,TRN_RET in MOVEMENT_TYPE
    -- modify multi table
    -- modify movement plan header form

-- 09.06.08
    -- modify SK_ITEM from
    -- modify FRM_SETUP_RECEIPT_S1
    -- modify FRM_RECEIPT_HEADER
    -- chek the problem of calapod receipt_type instead ME1 should be MI3
    
--14.06.08
    -- set the flag for whs_trn_reason - accouting
    -- set up the APP_DOC_NUMBER
    -- delete from whs_trn_detail where qty = 0
    -- there are whs_trn_detail lines with ref_receipt is null 
    -- modify FRM_RECEIPT to allow for filty to register other org_code
    -- modify SK_WHS_TRN for link field took off ORG_CODE

    
    
*/

/*
*******************************************************************************************
SCRIPT RECUPERARE DATE DIN APP_AUDIT 

*******************************************************************************************

DECLARE
CURSOR C_COL (p_col VARCHAR2)IS SELECT  data_type FROM cols WHERE table_name ='SHIPMENT_DETAIL' AND column_name = p_col; 
v_sql1 VARCHAR2(2000);
v_sql2 VARCHAR2(2000);
v_poz INTEGER;
v_type VARCHAR2(50);
v_data VARCHAR2(1000);
BEGIN
DELETE FROM TMP_GENERAL;
FOR x IN (
          SELECT note
          FROM APP_AUDIT
          WHERE tbl_name = 'SHIPMENT_DETAIL'
          AND TRUNC(datagg) = TO_DATE('11112008','ddmmyyyy')
          AND tbl_oper = 'DELETE'
          AND note LIKE '%ref_shipment:433%' 
)
LOOP
    v_sql1 := 'insert into SHIPMENT_DETAIL(';
    v_sql2  :=  '';
    FOR xx IN   (
                SELECT ROWNUM row_num,txt01 
                FROM TABLE(Pkg_Lib.F_Sql_Inlist(x.note,',',-1))
                )
    LOOP
        v_poz := INSTR(xx.txt01,':');
        IF v_poz = 0 THEN
            v_sql2 := RTRIM(v_sql2,',')||'.'||xx.txt01||',';
        ELSE
            OPEN C_COL (UPPER(SUBSTR(xx.txt01,1,v_poz-1))); FETCH C_COL INTO v_type;
            CLOSE C_COL;
            v_sql1 := v_sql1 || SUBSTR(xx.txt01,1,v_poz-1)||',';
            v_data := SUBSTR(xx.txt01,v_poz+1);
            CASE v_type
                WHEN    'VARCHAR2' THEN
                    v_sql2 := v_sql2 || '''' ||SUBSTR(xx.txt01,v_poz+1)||''',';
                WHEN    'DATE' THEN
                    IF v_data IS NULL THEN
                        v_sql2 := v_sql2||'null,'; 
                    ELSE
                        v_sql2 := v_sql2 || 'to_date(''' ||SUBSTR(xx.txt01,v_poz+1)||''',''DD-MON-YY''),';
                    END IF;
                WHEN    'NUMBER' THEN
                    IF v_data IS NULL THEN
                        v_sql2 := v_sql2 ||'0,';
                    ELSE
                        v_sql2 := v_sql2 || SUBSTR(xx.txt01,v_poz+1)||',';
                    END IF;
                ELSE
                    v_sql2 := v_sql2 || SUBSTR(xx.txt01,v_poz+1)||'???,';
            END CASE;
        END IF;
    END LOOP;
    v_sql1 := RTRIM(v_sql1,',')||')';
    v_sql2 := ' VALUES('||RTRIM(v_sql2,',')||')';
    INSERT INTO TMP_GENERAL(txt36,txt37) VALUES (v_sql1, v_sql2);
    EXECUTE IMMEDIATE v_sql1||v_sql2;
END LOOP;
END; 

*/

END;
 

/

/
