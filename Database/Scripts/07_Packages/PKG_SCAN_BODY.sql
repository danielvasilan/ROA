--------------------------------------------------------
--  DDL for Package Body PKG_SCAN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_SCAN" 
AS

/*****************************************************************************************************
    DDL:    19/05/2008  d   Create
/*****************************************************************************************************/
PROCEDURE p_generate_package_id (   p_org_code      VARCHAR2,
                                    p_number        NUMBER
                                )
------------------------------------------------------------------------------------------------------
--  PURPOSE :   generates lines in PACKAGE_HEADER , representing the big packages information
------------------------------------------------------------------------------------------------------
IS
    CURSOR C_LAST_PACKAGE_CODE  (p_org_code VARCHAR2, p_prefix VARCHAR2)
                                IS
                                SELECT      h.package_code              package_code
                                FROM        PACKAGE_HEADER              h
                                WHERE       h.org_code                  =   p_org_code
                                    AND     h.package_code              LIKE p_prefix || '%'
                                ORDER BY    h.package_code DESC
                                ;

    C_PACKAGE_PREFIX            VARCHAR2(5) := 'K';
    v_row_lpk                   C_LAST_PACKAGE_CODE%ROWTYPE;
    v_found                     BOOLEAN;
    v_pkg_code                  NUMBER;
    it_pkh                      Pkg_Rtype.ta_package_header;

BEGIN

    -- get the last package_code used
    OPEN C_LAST_PACKAGE_CODE    (   p_org_code  =>  p_org_code,
                                    p_prefix    =>  C_PACKAGE_PREFIX || p_org_code
                                );
    FETCH C_LAST_PACKAGE_CODE   INTO v_row_lpk;
    v_found:=   C_LAST_PACKAGE_CODE%FOUND;
    CLOSE C_LAST_PACKAGE_CODE;

    IF v_found THEN
        v_pkg_code              :=  TO_NUMBER(SUBSTR(v_row_lpk.package_code,5));
    ELSE
        v_pkg_code              :=  0;
    END IF;

    -- insert in PACKAGE_HEADER p_number records
    FOR i IN 1..p_number
    LOOP
        it_pkh(it_pkh.COUNT+1).package_code :=  C_PACKAGE_PREFIX||p_org_code||LPAD(v_pkg_code+i,6,'0');
--        it_pkh(it_pkh.COUNT).description    :=  'Colet seria '||p_org_code||' numarul '||(v_pkg_code+i);
        it_pkh(it_pkh.COUNT).description    :=  'Colet '||(v_pkg_code+i);
        it_pkh(it_pkh.COUNT).status         :=  'I';
        it_pkh(it_pkh.COUNT).max_capacity   :=  15;
        it_pkh(it_pkh.COUNT).org_code       :=  p_org_code;
    END LOOP;

    IF it_pkh.COUNT >0 THEN Pkg_Iud.p_package_header_miud('I',it_pkh); END IF;

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/***************************************************************************************
    DDL:    23/10/2008 d Create date
/***************************************************************************************/
PROCEDURE p_scan_trn            (   p_scanned_value             VARCHAR2,
                                    p_org_code          IN OUT  VARCHAR2
                                )
IS

    CURSOR C_GET_H              (p_org_code VARCHAR2)
                                IS
                                SELECT      *
                                FROM        PACKAGE_TRN_HEADER
                                WHERE       status              =   'I'
                                    AND     org_code            =   p_org_code
                                ORDER BY    idriga DESC
                                ;

    CURSOR C_GET_STOCK          (p_package_code VARCHAR2)
                                IS
                                SELECT      d.whs_code      , 
                                            SUM(d.trn_sign) stock      
                                FROM        PACKAGE_TRN_DETAIL  d
                                INNER JOIN  PACKAGE_TRN_HEADER  h   ON  h.idriga    =   d.ref_trn
                                WHERE       h.status            =   'V'
                                    AND     d.package_code      =   p_package_code
                                GROUP BY    d.whs_code
                                HAVING      SUM(d.trn_sign) <> 0
                                ;

    CURSOR C_EX     (p_org_code VARCHAR2, p_package_code VARCHAR2, p_ref_trn NUMBER)
                    IS
                    SELECT      *
                    FROM        PACKAGE_TRN_DETAIL
                    WHERE       ref_trn             =   p_ref_trn
                            AND org_code            =   p_org_code
                            AND package_code        =   p_package_code
                    ;     
                    
    v_row_crs       C_EX%ROWTYPE;
    --v_found         BOOLEAN;                

                                
    v_row_trh                   PACKAGE_TRN_HEADER%ROWTYPE;
    v_row_trd                   PACKAGE_TRN_DETAIL%ROWTYPE;
    v_row_pkg                   PACKAGE_HEADER%ROWTYPE;
    v_row_stk                   C_GET_STOCK%ROWTYPE;
    v_found_stk                 BOOLEAN;
    v_found_ex                  BOOLEAN;
    v_str_err                   VARCHAR2(200);
    v_org_code                  VARCHAR2(30);
    
BEGIN

    -- get the package row
    v_row_pkg.package_code  :=  p_scanned_value;
    IF NOT Pkg_Get2.f_get_package_header_2(v_row_pkg) THEN 
        v_org_code :=   NVL(SUBSTR(p_scanned_value,2,3),Pkg_Nomenc.f_get_myself_org()); 
    ELSE
        v_org_code :=   v_row_pkg.org_code;
    END IF;
    p_org_code      :=  v_org_code;
    
    -- see if a transaction header exists 
    OPEN    C_GET_H(v_org_code);
    FETCH   C_GET_H INTO v_row_trh;
    v_found_ex := C_GET_H%FOUND;
    CLOSE   C_GET_H;
    
    -- add header if it doesn't exist  
    IF NOT v_found_ex THEN
        v_row_trh.trn_date  :=  TRUNC(SYSDATE);
        v_row_trh.empl_code :=  NULL;
        v_row_trh.status    :=  'I';
        v_row_trh.org_code  :=  v_org_code;
        v_row_trh.trn_type  :=  'TRN';
        Pkg_Iud.p_package_trn_header_iud('I', v_row_trh);
        v_row_trh.idriga    :=  Pkg_Lib.f_read_pk;
    END IF;

    -- determine the "stock" 
    OPEN    C_GET_STOCK( p_scanned_value);
    FETCH   C_GET_STOCK INTO v_row_stk;
    v_found_stk :=  C_GET_STOCK%FOUND;
    CLOSE   C_GET_STOCK;
    
    -- check if the package has been already scanned 
    OPEN    C_EX(v_org_code, v_row_pkg.package_code, v_row_trh.idriga);
    FETCH   C_EX INTO v_row_crs;
    v_found_ex :=  C_EX%FOUND;
    CLOSE   C_EX;
    IF v_found_ex THEN
        v_str_err   :=  'Colet deja citit!!!';
    END IF;

    
    -- checks 
    IF v_row_pkg.idriga   IS NULL THEN v_str_err := 'Colet neidentificat!!!'; END IF;
    IF v_row_pkg.status         ='M' THEN v_str_err := 'Colet deja expediat!!!'; END IF;
    
    -- transaction detail(s) 
    v_row_trd.ref_trn       :=  v_row_trh.idriga;
    v_row_trd.org_code      :=  v_row_pkg.org_code;
    v_row_trd.package_code  :=  v_row_pkg.package_code;
    v_row_trd.whs_code      :=  Pkg_Order.f_get_default_whs_fin(Pkg_Nomenc.f_get_myself_org());
    IF v_str_err IS NULL THEN
        v_row_trd.trn_sign      :=  +1;
    ELSE
        v_row_trd.trn_sign      :=  0;
        v_row_trd.error_log     :=  v_str_err;
    END IF;
    Pkg_Iud.p_package_trn_detail_iud('I',v_row_trd);
    
    -- if stock found, generate a negative transaction 
    IF v_found_stk AND v_str_err IS NULL THEN
        v_row_trd.trn_sign  :=  -1;
        v_row_trd.whs_code  :=  v_row_stk.whs_code;
        Pkg_Iud.p_package_trn_detail_iud('I',v_row_trd);
    END IF;
    
    COMMIT;
    
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;



/***************************************************************************************
    DDL:    19/05/2008 d Create date
/***************************************************************************************/
PROCEDURE p_scan_event  (   p_scanner_code      VARCHAR2,
                            p_context_code      VARCHAR2,
                            p_scanned_value     VARCHAR2)
----------------------------------------------------------------------------------------
--  insert in SCAN_EVENT table the scanned value and trigger the proper procedure
----------------------------------------------------------------------------------------
IS

    v_row_scn           SCAN_EVENT%ROWTYPE;
    v_scanned_value     VARCHAR2(1000);
    v_org_code          VARCHAR2(30);
    
BEGIN
    -- insert the info in the SCAN_EVENT table
    v_row_scn.scanner_code  :=  p_scanner_code;
    v_row_scn.context_code  :=  p_context_code;
    v_row_scn.scanned_value :=  p_scanned_value;
    v_row_scn.status        :=  'I';

    Pkg_Iud.p_scan_event_iud('I', v_row_scn);

    v_row_scn.idriga        :=  Pkg_Lib.f_read_pk;

    COMMIT;

    -- set the status for the scanned line as PROCESSED
    v_row_scn.status    :=  'P';
    v_scanned_value     :=  F_Str_Filter(UPPER(p_scanned_value),'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-');

    CASE SUBSTR(v_scanned_value,1,1)
        WHEN    'K' THEN
                    CASE p_context_code 
                        WHEN 'PKG' THEN
                            -- collet header reading 
                            Pkg_Glb.v_curr_pkg_code     :=  v_scanned_value;
                            Pkg_Scan.p_prep_package     (NULL);
                        WHEN 'TRN' THEN
                            -- collet transactions reading 
                            Pkg_Scan.p_scan_trn         (   p_scanned_value =>  v_scanned_value,
                                                            p_org_code      =>  v_org_code
                                                        );
                            Pkg_Scan.p_prep_trn         (NULL, v_org_code);
                        ELSE
                            -- spedition 
                            Pkg_Scan.p_scan_ship        (   p_ship_code     =>  Pkg_Glb.v_curr_ship_code,
                                                            p_ref_shipment  =>  NULL,
                                                            p_scanned_value =>  v_scanned_value
                                                        );
                            Pkg_Scan.p_prep_ship        (NULL);
                    END CASE;

        WHEN    'B' THEN
                        -- package
                        Pkg_Scan.p_scan_pkg_detail  (   p_package_code  =>  Pkg_Glb.v_curr_pkg_code,
                                                        p_scanned_value =>  v_scanned_value
                                                    );
                        Pkg_Scan.p_prep_package     (NULL);

        WHEN    'S' THEN
                    --  spedition code scanned
                    IF v_scanned_value = 'S' THEN
                        Pkg_Glb.v_curr_ship_code    :=  NULL;
                    ELSE
                        Pkg_Glb.v_curr_ship_code    :=  v_scanned_value;
                    END IF;
                    Pkg_Scan.p_prep_ship        (NULL);

        ELSE
                -- ORPHAN SCANNING (no rules established for it)
                    v_row_scn.status        :=  'E';
                    v_row_scn.error_log     :=  'No rule for the scanning->no action to take !!!';
    END CASE;

    Pkg_Iud.p_scan_event_iud('U', v_row_scn);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    v_row_scn.status        :=  'E';
    v_row_scn.error_log     :=  SQLERRM;
    Pkg_Iud.p_scan_event_iud('U', v_row_scn);
    COMMIT;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/***************************************************************************************
    DDL:    19/05/2008 d Create date
/***************************************************************************************/
PROCEDURE p_prep_package    (   p_package_code      VARCHAR2)
----------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for a package (for the Package sheet and for the scanning form )
----------------------------------------------------------------------------------------
IS
    CURSOR C_LINES          (p_package_code     VARCHAR2)
                            IS
                            SELECT      pd.*,
                                        o.item_code         o_item_code,
                                        o.season_code       o_season_code,
                                        i.description       i_description
                            ---------------------------------------------------------------------------
                            FROM        PACKAGE_DETAIL      pd
                            LEFT JOIN   WORK_ORDER          o   ON  o.org_code      =   pd.org_code
                                                                AND o.order_code    =   pd.order_code
                            LEFT JOIN   ITEM                i   ON  i.org_code      =   o.org_code
                                                                AND i.item_code     =   o.item_code
                            ---------------------------------------------------------------------------
                            WHERE       pd.package_code     =   p_package_code
                            ORDER BY    pd.seq_no
                            ;

    CURSOR C_GET_QUEUE      (p_org_code VARCHAR2)
                            IS
                            SELECT      COUNT(DISTINCT package_code)
                            FROM        VW_QRP_PKG_SHEET
                            WHERE       user_code           =   Pkg_Lib.f_return_user_code
                                AND     report_code         =   'PKG_SHEET'
                                AND     org_code            =   p_org_code
                            ;

    CURSOR C_IN_QUEUE       (p_package_code VARCHAR2)
                            IS
                            SELECT      COUNT(1)
                            FROM        VW_QRP_PKG_SHEET
                            WHERE       user_code           =   Pkg_Lib.f_return_user_code
                                AND     report_code         =   'PKG_SHEET'
                                AND     package_code        =   p_package_code
                            ;


    C_SEGMENT_CODE          VARCHAR2(100)   :=  'VW_PREP_PACKAGE';
    v_row                   VW_PREP_PACKAGE%ROWTYPE;
    v_package_code          VARCHAR2(30);
    v_rowcount              NUMBER          :=  0;
    v_row_pkh               PACKAGE_HEADER%ROWTYPE;
    v_queue_count           PLS_INTEGER;
    v_in_queue              PLS_INTEGER;

BEGIN

    v_package_code          :=  NVL(p_package_code, Pkg_Glb.v_curr_pkg_code);

    DELETE FROM VW_PREP_PACKAGE;

    v_row_pkh.package_code  :=  v_package_code;
    IF NOT Pkg_Get2.f_get_package_header_2(v_row_pkh) THEN NULL; END IF;

    OPEN C_GET_QUEUE(v_row_pkh.org_code);   FETCH C_GET_QUEUE INTO v_queue_count;   CLOSE C_GET_QUEUE;
    OPEN    C_IN_QUEUE(v_package_code);
    FETCH   C_IN_QUEUE  INTO v_in_queue;      CLOSE C_IN_QUEUE;


    v_row.segment_code  :=  C_SEGMENT_CODE;
    v_row.package_code  :=  v_package_code;
    v_row.package_info  :=  '('||v_row_pkh.status||')  '||v_row_pkh.description;
    v_row.error_log_h   :=  v_row_pkh.error_log;
    v_row.status_h      :=  v_row_pkh.status;
    IF v_queue_count > 0 THEN
        v_row.printing_status   :=  v_queue_count||' colete in asteptare !';
    ELSE
        v_row.printing_status   :=  '';
    END IF;
    IF v_in_queue > 0 THEN
        v_row.package_info   :=  v_row.package_info ||' --> in asteptare !!!';
    END IF;

    FOR x IN C_LINES(v_package_code)
    LOOP
        v_rowcount          :=  C_LINES%rowcount;

        v_row.ref_pkg_detail:=  x.idriga;
        v_row.org_code      :=  x.org_code;
        v_row.order_code    :=  x.order_code;
        v_row.order_info    :=  RPAD(x.o_season_code,7,' ') ||
                                RPAD(x.o_item_code,15,' ')  ||
                                x.i_description;
        v_row.size_code     :=  x.size_code;
        v_row.quality       :=  x.quality;
        v_row.qty           :=  x.qty;
        v_row.seq_no        :=  x.seq_no;
        v_row.status        :=  x.status;
        v_row.error_log     :=  x.error_log;

        INSERT INTO VW_PREP_PACKAGE VALUES v_row;
    END LOOP;

    IF v_rowcount = 0 THEN
        v_row.org_code      :=  NULL;
        v_row.order_code    :=  NULL;
        v_row.size_code     :=  NULL;
        v_row.quality       :=  NULL;
        v_row.qty           :=  NULL;
        v_row.seq_no        :=  0;

        INSERT INTO VW_PREP_PACKAGE VALUES v_row;
    END IF;

END;


/***************************************************************************************
    DDL:    19/05/2008 d Create date
/***************************************************************************************/
PROCEDURE p_scan_pkg_detail     (   p_package_code      VARCHAR2,
                                    p_scanned_value     VARCHAR2
                                )
IS

    CURSOR C_EXPL               (p_string   VARCHAR2)
                                IS
                                SELECT  ROWNUM      col_seq,
                                        txt01       col_text
                                -------------------------------------------------
                                FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_string,'-', -1))
                                ;

    v_row_pkh                   PACKAGE_HEADER%ROWTYPE;
    v_row_pkd                   PACKAGE_DETAIL%ROWTYPE;
    it_line                     Pkg_Glb.typ_string;


BEGIN

    -- get the PACKAGE HEADER row
    v_row_pkh.package_code      :=  p_package_code;
    IF Pkg_Get2.f_get_package_header_2(v_row_pkh,0) THEN NULL; END IF;

    FOR x IN C_EXPL(p_scanned_value)
    LOOP
        it_line(x.col_seq)     :=  x.col_text;
    END LOOP;

    v_row_pkd.package_code      :=  p_package_code;
    v_row_pkd.org_code          :=  v_row_pkh.org_code;
    v_row_pkd.order_code        :=  Pkg_Lib.f_table_value(it_line, 3,'');
    v_row_pkd.size_code         :=  Pkg_Lib.f_table_value(it_line, 4,'');
    v_row_pkd.quality           :=  Pkg_Lib.f_table_value(it_line, 5,'1');
    IF v_row_pkd.order_code IS NULL OR v_row_pkd.size_code IS NULL THEN
        v_row_pkd.qty               :=  0;
    ELSE
        v_row_pkd.qty               :=  1;
    END IF;

    Pkg_Scan.p_package_detail_iud('I', v_row_pkd);

    COMMIT;

    Pkg_Scan.p_pkg_validate(p_package_code);

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************************
    19/05/2008  d   Create

/*********************************************************************************************/
FUNCTION f_sql_package      (p_package_code  VARCHAR2)         RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for PAcakge management form
----------------------------------------------------------------------------------------------
IS

    CURSOR     C_LINES      IS
                            SELECT      *
                            FROM        VW_PREP_PACKAGE
                            ORDER BY    order_code,size_code,quality
                            ;

    v_row      tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES LOOP

        v_row.idriga    :=  NVL(x.ref_pkg_detail,0);
        v_row.dcn       :=  0;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.package_code;
        v_row.txt03     :=  x.package_info;
        v_row.txt04     :=  x.order_code;
        v_row.txt05     :=  x.order_info;
        v_row.txt06     :=  '';
        v_row.txt07     :=  x.size_code;
        v_row.txt08     :=  x.quality;
        v_row.txt09     :=  x.status;
        v_row.txt10     :=  x.error_log;
        v_row.txt11     :=  x.error_log_h;
        v_row.txt12     :=  x.status_h;
        v_row.txt13     :=  x.printing_status;
        v_row.numb01    :=  x.qty;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    22/05/2008  d   Create

/*********************************************************************************************/
FUNCTION f_sql_package_header   (p_org_code VARCHAR2, p_status  VARCHAR2)         RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for Package header form
----------------------------------------------------------------------------------------------
IS

    CURSOR     C_LINES      (           p_status                VARCHAR2)
                            IS
                            SELECT      h.idriga                ,
                                        MAX(h.dcn)              dcn,
                                        MAX(h.org_code)         org_code,
                                        MAX(h.package_code)     package_code,
                                        MAX(h.description)      description,
                                        MAX(h.status)           status,
                                        MAX(h.error_log)        error_log,
                                        MAX(h.employee_pack)    employee_pack,
                                        MAX(h.employee_verif)   employee_verif,
                                        MAX(h.MAX_CAPACITY)     max_capacity,
                                        SUM(d.qty)              qty,
                                        MAX(d.order_code)       max_order_code,
                                        MIN(d.order_code)       min_order_code,
                                        COUNT(DISTINCT d.order_code)       nr_order_code,
                                        MAX(d.datagg)           last_scan,
                                        MAX(s.whs_code)         stock_whs_code
                            ----------------------------------------------------------------------------
                            FROM        PACKAGE_HEADER      h
                            LEFT JOIN   PACKAGE_DETAIL      d   ON  d.package_code  =   h.package_code
                            LEFT JOIN   STOC_ONLINE_PKG     s   ON  s.org_code      =   h.org_code
                                                                AND s.package_code  =   h.package_code
                            ----------------------------------------------------------------------------
                            WHERE       h.status            IN  (SELECT txt01
                                                                 FROM   TABLE(Pkg_Lib.F_Sql_Inlist(p_status,',')))
                                AND     h.org_code          LIKE NVL(p_org_code,'%')
                            ----------------------------------------------------------------------------
                            GROUP BY    h.idriga
                            ORDER BY    3,4
                            ;

    v_row      tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES    (p_status)
    LOOP

        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.package_code;
        v_row.txt03     :=  x.description;
        v_row.txt04     :=  x.status;
        v_row.txt05     :=  x.error_log;
        v_row.txt06     :=  x.employee_pack;
        v_row.txt07     :=  x.employee_verif;
        v_row.txt08     :=  TO_CHAR(x.last_scan,'dd/mm/yyyy');
        v_row.txt09     :=  TO_CHAR(x.last_scan,'hh24:mi');
        v_row.txt10     :=  x.min_order_code;
        IF x.min_order_code <> x.max_order_code THEN
            v_row.txt10     :=  v_row.txt10 || ', '||x.max_order_code;
        END IF;
        v_row.txt11     :=  x.stock_whs_code;
        
        v_row.numb01    :=  x.max_capacity;
        v_row.numb02    :=  x.qty;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    22/05/2008  d   Create

/*********************************************************************************************/
FUNCTION f_sql_package_detail   (   p_idriga        NUMBER,
                                    p_package_code  VARCHAR2
                                )   RETURN          typ_frm     pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for Package header form
----------------------------------------------------------------------------------------------
IS

    CURSOR     C_LINES      IS
                            SELECT      d.idriga,d.dcn,d.org_code,d.status,d.qty,
                                        d.order_code,d.size_code,d.package_code, d.quality,
                                        d.error_log,
                                        o.item_code         o_item_code,
                                        i.description       i_description
                            ---------------------------------------------------------------------------
                            FROM        PACKAGE_DETAIL      d
                            LEFT JOIN   WORK_ORDER          o   ON  o.org_code      =   d.org_code
                                                                AND o.order_code    =   d.order_code
                            LEFT JOIN   ITEM                i   ON  i.org_code      =   o.org_code
                                                                AND i.item_code     =   o.item_code
                            ----------------------------------------------------------------------------
                            WHERE       d.package_code      =   p_package_code
                                AND     p_idriga            IS NULL
                            ----
                            UNION ALL
                            ----
                            SELECT      d.idriga,d.dcn,d.org_code,d.status,d.qty,
                                        d.order_code,d.size_code,d.package_code, d.quality,
                                        d.error_log,
                                        o.item_code         o_item_code,
                                        i.description       i_description
                            ---------------------------------------------------------------------------
                            FROM        PACKAGE_DETAIL      d
                            LEFT JOIN   WORK_ORDER          o   ON  o.org_code      =   d.org_code
                                                                AND o.order_code    =   d.order_code
                            LEFT JOIN   ITEM                i   ON  i.org_code      =   o.org_code
                                                                AND i.item_code     =   o.item_code
                            ----------------------------------------------------------------------------
                            WHERE       d.idriga            =   p_idriga
                                AND     p_idriga            IS NOT NULL
                            ORDER BY    order_code, size_code
                            ;

    v_row      tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES
    LOOP

        v_row.idriga    :=  x.idriga;
        v_row.dcn       :=  x.dcn;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.package_code;
        v_row.txt03     :=  x.order_code;
        v_row.txt04     :=  x.size_code;
        v_row.txt05     :=  x.quality;
        v_row.txt06     :=  x.status;
        v_row.txt07     :=  x.error_log;
        v_row.txt08     :=  x.o_item_code;
        v_row.txt09     :=  x.i_description;
        v_row.numb01    :=  x.qty;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    19/05/2008  d   Create

/*********************************************************************************************/
PROCEDURE p_rep_pkg_order_size   (   p_org_code      VARCHAR2,
                                    p_order_code    VARCHAR2
                                 )
----------------------------------------------------------------------------------------------
--  PURPOSE:    loads data for the report with order's barcodes on size
----------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (p_ref_wo   NUMBER)
                    IS
                    SELECT      *
                    FROM        WO_DETAIL   d
                    WHERE       d.ref_wo    =   p_ref_wo
                    ORDER BY    size_code
                    ;

    v_row_ord       WORK_ORDER%ROWTYPE;
    v_row_rep       VW_REP_PKG_ORDER_SIZE%ROWTYPE;
    v_row_rep_2     VW_REP_PKG_ORDER_SIZE%ROWTYPE;

    TYPE typ_rep    IS TABLE OF VW_REP_PKG_ORDER_SIZE%ROWTYPE INDEX BY PLS_INTEGER;
    it_rep          typ_rep;
    it_rep2         typ_rep;
    C_SEPAR         VARCHAR2(1) := '-';

BEGIN

    DELETE FROM VW_REP_PKG_ORDER_SIZE;

    -- get the ORDER row
    v_row_ord.org_code      :=  p_org_code;
    v_row_ord.order_code    :=  p_order_code;
    IF NOT Pkg_Get2.f_get_work_order_2(v_row_ord) THEN NULL; END IF;

    v_row_REP.rep_title  :=  'Lista coduri de bare pe marime';
    v_row_rep.rep_info   := 'Gestiune:  '||p_org_code||Pkg_Glb.C_NL||
                            'Comanda:   '||p_order_code;
    v_row_rep.segment_code  :=  'VW_REP_PKG_ORDER_SIZE';
    v_row_rep_2             :=  v_row_rep;

    FOR x IN C_LINES(v_row_ord.idriga)
    LOOP
        -- first quality
        v_row_rep.quality       :=  '1';
        IF MOD(C_LINES%rowcount,2) = 1 THEN
            v_row_rep.size_code_1   :=  x.size_code;
            v_row_rep.barcode_1     :=  '('||
                                        Pkg_Lib.f_implode(C_SEPAR,  'B',
                                                                p_org_code,
                                                                p_order_code,
                                                                x.size_code,
                                                                '1')||
                                        ')';
            v_row_rep.size_code_2   :=  NULL;
            v_row_rep.barcode_2     :=  NULL;
        ELSE
            v_row_rep.size_code_2   :=  x.size_code;
            v_row_rep.barcode_2     :=  '('||
                                        Pkg_Lib.f_implode(C_SEPAR,  'B',
                                                                p_org_code,
                                                                p_order_code,
                                                                x.size_code,
                                                                '1')||
                                         ')';
        END IF;
        Pkg_App_Tools.P_Log('L',v_row_rep.barcode_1 || ' ** '||v_row_rep.barcode_2|| ' ** '||C_LINES%rowcount,'');

        it_rep  (TRUNC((C_LINES%rowcount - 1) / 2) + 1) :=  v_row_rep;

        -- second quality
        v_row_rep_2.quality       :=  '2';
        IF MOD(C_LINES%rowcount,2) = 1 THEN
            v_row_rep_2.size_code_1   :=  x.size_code;
            v_row_rep_2.barcode_1     :=  '('||
                                        Pkg_Lib.f_implode(C_SEPAR,  'B',
                                                                p_org_code,
                                                                p_order_code,
                                                                x.size_code,
                                                                '2')||
                                        ')';
            v_row_rep_2.size_code_2   :=  NULL;
            v_row_rep_2.barcode_2     :=  NULL;

        ELSE
            v_row_rep_2.size_code_2   :=  x.size_code;
            v_row_rep_2.barcode_2     :=  '('||
                                        Pkg_Lib.f_implode(C_SEPAR,  'B',
                                                                p_org_code,
                                                                p_order_code,
                                                                x.size_code,
                                                                '2')||
                                         ')';
        END IF;
        Pkg_App_Tools.P_Log('L',v_row_rep_2.barcode_1 || ' ** '||v_row_rep_2.barcode_2|| ' ** '||C_LINES%rowcount,'2');
        it_rep2  (TRUNC((C_LINES%rowcount - 1) / 2) + 1) :=  v_row_rep_2;
    END LOOP;

    FORALL i IN it_rep.FIRST..it_rep.LAST INSERT INTO VW_REP_PKG_ORDER_SIZE VALUES it_rep(i);
    FORALL i IN it_rep2.FIRST..it_rep2.LAST INSERT INTO VW_REP_PKG_ORDER_SIZE VALUES it_rep2(i);

END;

/*********************************************************************************************
    20/05/2008  d   Create

/*********************************************************************************************/
PROCEDURE p_rep_pkg_sheet       (   p_package_code      VARCHAR2
                                )
----------------------------------------------------------------------------------------------
--  PURPOSE:    sheet for the big box
----------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES  (   p_package_code VARCHAR2)
                    IS
                    SELECT      d.org_code          ,
                                d.package_code      ,
                                d.order_code        ,
                                d.size_code         ,
                                SUM(d.qty)          qty,
                                SUM(DECODE(d.quality,1,d.qty,0)) qty_1,
                                SUM(DECODE(d.quality,2,d.qty,0)) qty_2,
                                MAX(o.item_code)    o_item_code,
                                MAX(i.description)  i_description,
                                MAX(i.root_code)    i_root_code,
                                MAX(o.client_code)  o_client_code,
                                MAX(n.org_name)     n_org_name,
                                MAX(n.country_code) n_country_code,
                                MAX(n.city)         n_city,
                                MAX(n.address)      n_address,
                                MAX(h.description)  h_description
                    -------------------------------------------------------------------------
                    FROM        PACKAGE_DETAIL      d
                    INNER JOIN  PACKAGE_HEADER      h   ON  h.org_code      =   d.org_code
                                                        AND h.package_code  =   d.package_code
                    INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   d.org_code
                                                        AND o.order_code    =   d.order_code
                    INNER JOIN  ITEM                i   ON  i.org_code      =   o.org_code
                                                        AND i.item_code     =   o.item_code
                    LEFT JOIN   ORGANIZATION        n   ON  n.org_code      =   o.client_code
                    ---------------------------------------------------------------------------
                    WHERE       d.package_code      LIKE NVL(p_package_code,'%')
--                        AND     h.status            <>   'M'
                    -------------------------------------------------------------------------
                    GROUP BY    d.package_code,d.org_code, d.order_code, d.size_code
                    ORDER BY    1,2,3,4
                    ;

    CURSOR C_PICTURE_PATH   IS
                            SELECT  description
                            FROM    MULTI_TABLE     m
                            WHERE   m.table_name    =   'SYSPAR'
                                AND m.table_key     =   'PICTURE_PATH'
                            ;                    
                    
    TYPE typ_rep_s  IS TABLE OF VW_REP_PKG_SHEET%ROWTYPE INDEX BY VARCHAR2(1000);
    it_rep          typ_rep_s;
    v_row_rep       VW_REP_PKG_SHEET%ROWTYPE;
    v_idx           VARCHAR2(1000);
    v_row_pkh       PACKAGE_HEADER%ROWTYPE;
    v_picture_path  VARCHAR2(1000);
    
BEGIN

    DELETE FROM VW_REP_PKG_SHEET;
    
    OPEN C_PICTURE_PATH; FETCH C_PICTURE_PATH INTO v_picture_path; CLOSE C_PICTURE_PATH;
    
    FOR x IN C_LINES (p_package_code)
    LOOP
        v_idx   :=  Pkg_Lib.f_implode('$', x.org_code, x.package_code, x.order_code);
        -- if the order was not inserted in the structure , insert it now
        IF NOT it_rep.EXISTS(v_idx) THEN
            it_rep(v_idx).segment_code      :=  'VW_REP_PKG_SHEET';
            it_rep(v_idx).rep_title         :=  x.h_description;
            it_rep(v_idx).rep_info          :=  x.n_org_name||Pkg_Glb.C_NL||
                                                RPAD('Adresa:',15)||x.n_country_code||', '||x.n_city||', '||x.n_address;
            it_rep(v_idx).package_code      :=  x.package_code;
            it_rep(v_idx).package_code_bc   :=  '('||x.package_code||')';
            it_rep(v_idx).org_code          :=  x.org_code;
            it_rep(v_idx).order_code        :=  x.order_code;
            it_rep(v_idx).item_code         :=  x.o_item_code;
            it_rep(v_idx).description       :=  x.i_description;
            it_rep(v_idx).picture_path      :=  v_picture_path||x.org_code||'\'||x.i_root_code||'.jpg';
        END IF;
        -- set the size + qty values
        it_rep(v_idx).wo_size   :=  it_rep(v_idx).wo_size       || LPAD(x.size_code,4,' ');
        IF x.qty_1 <> 0 THEN
            it_rep(v_idx).wo_qty_1  :=  it_rep(v_idx).wo_qty_1      || LPAD(x.qty_1,    4,' ');
        ELSE
            it_rep(v_idx).wo_qty_1  :=  it_rep(v_idx).wo_qty_1      || LPAD(' ',        4,' ');
        END IF;
        IF x.qty_2 <> 0 THEN
            it_rep(v_idx).wo_qty_2  :=  it_rep(v_idx).wo_qty_2      || LPAD(x.qty_2,    4,' ');
        ELSE
            it_rep(v_idx).wo_qty_2  :=  it_rep(v_idx).wo_qty_2      || LPAD(' ',        4,' ');
        END IF;
    END LOOP;

    -- insert the data from PL?SQL table in VW_REP_PKG_SHEET view
    v_idx   :=  it_rep.FIRST;
    IF v_idx IS NULL THEN Pkg_Lib.p_rae('Nu exista date pentru parametrii specificati!'); END IF;
    WHILE v_idx IS NOT NULL
    LOOP
        INSERT INTO VW_REP_PKG_SHEET VALUES it_rep(v_idx);
        v_idx       :=  it_rep.NEXT(v_idx);
    END LOOP;


END;

/*********************************************************************************************
    20/05/2008  d   Create

/*********************************************************************************************/
PROCEDURE p_pkg_validate    (   p_package_code      VARCHAR2)
----------------------------------------------------------------------------------------------
--  PURPOSE:    sheet for the big box
----------------------------------------------------------------------------------------------
IS

    CURSOR C_PKD    (p_package_code VARCHAR2)
                    IS
                    SELECT      d.*,
                                o.order_code    o_order_code,
                                w.size_code     w_size_code
                    ------------------------------------------------------------------
                    FROM        PACKAGE_DETAIL  d
                    LEFT JOIN   WORK_ORDER      o   ON  o.org_code  =   d.org_code
                                                    AND o.order_code=   d.order_code
                    LEFT JOIN   WO_DETAIL       w   ON  w.ref_wo    =   o.idriga
                                                    AND w.size_code =   d.size_code
                    ------------------------------------------------------------------
                    WHERE       d.package_code  =   p_package_code
                    ;

/*    CURSOR C_STK    (p_org_code VARCHAR2, p_package_code VARCHAR2)
                    IS
                    SELECT      s.*
                    FROM        STOC_ONLINE_PKG     s
                    WHERE       s.org_code          =   p_org_code
                        AND     s.package_code      =   p_package_code
                    ;
*/                    
    v_row_pkh       PACKAGE_HEADER%ROWTYPE;
    v_row_pkd       PACKAGE_DETAIL%ROWTYPE;
    v_rowcount      NUMBER;
    v_err           VARCHAR2(1000);
    v_row_ptd       PACKAGE_TRN_DETAIL%ROWTYPE;
--    v_row_stk       STOC_ONLINE_PKG%ROWTYPE;
    
BEGIN

    -- get the PACKAGE HEADER row
    v_row_pkh.package_code      :=  p_package_code;
    IF Pkg_Get2.f_get_package_header_2(v_row_pkh,-1) THEN NULL; END IF;

    -- if the package is in I status => generate stock 
    IF v_row_pkh.status =   'I' THEN
        v_row_ptd.org_code      :=  v_row_pkh.org_code;
        v_row_ptd.package_code  :=  v_row_pkh.package_code;
        v_row_ptd.whs_code      :=  'WIP';
        v_row_ptd.trn_sign      :=  1;
        v_row_ptd.ref_trn       :=  0;
        Pkg_Iud.p_package_trn_detail_iud('I',v_row_ptd);
    END IF;
    
    -- checks on detail only if the package is not expedited yet
    IF v_row_pkh.status <> 'M' THEN

        -- cycle the package detail
        FOR x IN C_PKD  (p_package_code)
        LOOP
            v_rowcount  :=  C_PKD%rowcount;
            -- check if order is set, size is set, order exists
            v_err := '';
            IF x.size_code      IS NULL THEN v_err :=          'Marime Nula;';      END IF;
            IF x.order_code     IS NULL THEN v_err := v_err || 'Comanda Nula;';     END IF;
            IF x.o_order_code   IS NULL THEN v_err := v_err || 'Comanda NC;';      END IF;
            IF x.w_size_code    IS NULL THEN v_err := v_err || 'Marime NC pt com;';END IF;
            IF NOT v_err IS NULL THEN
                v_row_pkd.idriga    :=  x.idriga;
                Pkg_Get.p_get_package_detail(v_row_pkd,-1);
                v_row_pkd.status    :=  'E';
                v_row_pkd.error_log :=  v_err;
                Pkg_Iud.p_package_detail_iud('U',v_row_pkd);
            ELSE
                v_row_pkd.idriga    :=  x.idriga;
                Pkg_Get.p_get_package_detail(v_row_pkd,-1);
                v_row_pkd.status    :=  'V';
                v_row_pkd.error_log :=  '';
                Pkg_Iud.p_package_detail_iud('U',v_row_pkd);
            END IF;
        END LOOP;

        -- check if the number of rows (detail) is greater than the box capacity
        IF v_rowcount > v_row_pkh.max_capacity THEN
            v_row_pkh.status        :=  'E';
            v_row_pkh.error_log     :=  'Depasire capac.';
            Pkg_Iud.p_package_header_iud('U', v_row_pkh);
        ELSE
            v_row_pkh.status        :=  'V';
            v_row_pkh.error_log     :=  '';
            Pkg_Iud.p_package_header_iud('U', v_row_pkh);
        END IF;
        
    END IF; -- status M

    COMMIT;

    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE, SQLERRM));
END;


/*********************************************************************************************************
    DDL:    22/05/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_package_header_iud      (   p_tip       VARCHAR2,
                                        p_row       PACKAGE_HEADER%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on package_header table
-----------------------------------------------------------------------------------------------------------
IS
    v_row       PACKAGE_HEADER%ROWTYPE;
BEGIN

    v_row       :=  p_row;

    IF v_row.status = 'M' THEN
        Pkg_Err.p_rae('Acest colet a fost deja descarcat din magazie! Nu se mai poate modifica');
    END IF;

    Pkg_Iud.p_package_header_iud(p_tip, v_row);

    Pkg_App_Secur.p_test_table_iud(p_tip, 'PACKAGE_HEADER');

    COMMIT;

    Pkg_Scan.p_pkg_validate(p_row.package_code);

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************
    06/03/2008  d   created

/*********************************************************************************************/
PROCEDURE p_package_detail_blo  (   p_tip           VARCHAR2,
                                    p_row   IN OUT  PACKAGE_DETAIL%ROWTYPE)
----------------------------------------------------------------------------------------------
--  PURPOSE:    Row level BLO for work order
----------------------------------------------------------------------------------------------
IS
    v_row_pkh       PACKAGE_HEADER%ROWTYPE;
BEGIN

    -- get the Header row
    v_row_pkh.org_code      :=  p_row.org_code;
    v_row_pkh.package_code  :=  p_row.package_code;
    IF Pkg_Get2.f_get_package_header_2(v_row_pkh) THEN NULL; END IF;

    p_row.qty       :=  NVL(p_row.qty, 1);
    p_row.quality   :=  NVL(p_row.quality, '1');

    IF v_row_pkh.status = 'M' THEN
        p_row.status    :=  'E';
        p_row.error_log :=  'Coletul este deja descarcat din magazie !!!';
    END IF;

END;

/*********************************************************************************************************
    DDL:    22/05/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_package_detail_iud      (   p_tip       VARCHAR2,
                                        p_row       PACKAGE_DETAIL%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on package_header table
-----------------------------------------------------------------------------------------------------------
IS
    v_row           PACKAGE_DETAIL%ROWTYPE;
BEGIN

    v_row           :=  p_row;

    -- BLO
    p_package_detail_blo    (p_tip, v_row);

    --IUD
    Pkg_Iud.p_package_detail_iud(p_tip, v_row);

    -- SECUR
    Pkg_App_Secur.p_test_table_iud(p_tip, 'PACKAGE_DETAIL');

    COMMIT;

    Pkg_Scan.p_pkg_validate(p_row.package_code);

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/***************************************************************************************
    DDL:    07/07/2008 d Create date
/***************************************************************************************/
PROCEDURE p_prep_ship       (   p_ref_shipment      NUMBER)
----------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for a package (for the Package sheet and for the scanning form )
----------------------------------------------------------------------------------------
IS
    CURSOR C_LINES          (p_ref_shipment    VARCHAR2)
                            IS
                            SELECT      s.idriga,
                                        MAX(s.package_code) package_code,
                                        MAX(s.seq_no)       seq_no,
                                        SUM(d.qty)          qty,
                                        MAX(d.order_code)   max_order_code,
                                        MIN(d.order_code)   min_order_code
                            ---------------------------------------------------------------------------
                            FROM        SHIPMENT_PACKAGE    s
                            LEFT JOIN   PACKAGE_HEADER      h   ON  s.org_code      =   h.org_code
                                                                AND s.package_code  =   h.package_code
                            LEFT JOIN   PACKAGE_DETAIL      d   ON  d.package_code  =   h.package_code
                            ---------------------------------------------------------------------------
                            WHERE       s.ref_shipment      =   p_ref_shipment
                            GROUP BY    s.idriga
                            ;

    CURSOR C_GET_SHP        (p_ship_code    VARCHAR2)
                            IS
                            SELECT      *
                            FROM        SHIPMENT_HEADER     h
                            WHERE       h.ship_code         LIKE    NVL(p_ship_code,'%')
                                AND     h.status            =       'I'
                                AND     h.ship_type         =       'CL1'
                            ORDER BY    idriga DESC
                            ;

    C_SEGMENT_CODE          VARCHAR2(100)   :=  'VW_PREP_SCAN_SHIP';
    v_row                   VW_PREP_SCAN_SHIP%ROWTYPE;
    v_rowcount              NUMBER          :=  0;
    v_row_shp               SHIPMENT_HEADER%ROWTYPE;

BEGIN

    DELETE FROM VW_PREP_SCAN_SHIP;

    IF p_ref_shipment IS NULL THEN
        OPEN    C_GET_SHP(Pkg_Glb.v_curr_ship_code);
        FETCH   C_GET_SHP INTO v_row_shp;
        CLOSE   C_GET_SHP;
    ELSE
        v_row_shp.idriga        :=  p_ref_shipment;
        IF NOT Pkg_Get.f_get_shipment_header(v_row_shp) THEN NULL; END IF;
    END IF;

    Pkg_Glb.v_curr_ship_code    :=  v_row_shp.ship_code;

    v_row.segment_code  :=  C_SEGMENT_CODE;
    v_row.ship_code     :=  v_row_shp.ship_code;
    v_row.ship_info     :=  v_row_shp.ship_type|| '  '||
                            TO_CHAR(v_row_shp.ship_date,'dd/mm/yyyy')|| ' '||
                            v_row_shp.org_delivery
                            ;
    v_row.org_code      :=  v_row_shp.org_code;
    v_row.ref_ship      :=  v_row_shp.idriga;

    v_row.error_log_h   :=  '';--v_row_pkh.error_log;
    v_row.status_h      :=  v_row_shp.status;

    FOR x IN C_LINES(v_row_shp.idriga)
    LOOP
        v_rowcount          :=  C_LINES%rowcount;

        v_row.ref_ship_pkg  :=  x.idriga;
        v_row.package_code  :=  x.package_code;
        v_row.package_info  :=  x.min_order_code;
        IF x.min_order_code <> x.max_order_code THEN
             v_row.package_info := v_row.package_info||' '||x.max_order_code;
        END IF;
        v_row.pkg_qty       :=  x.qty;

        v_row.seq_no        :=  x.seq_no;
        v_row.status        :=  '';--x.status;
        v_row.error_log     :=  '';--x.error_log;

        INSERT INTO VW_PREP_SCAN_SHIP VALUES v_row;
    END LOOP;

    IF v_rowcount = 0 THEN
        v_row.org_code      :=  NULL;
        v_row.seq_no        :=  0;
        v_row.ref_ship_pkg  :=  0;
        v_row.package_code  :=  '';
        v_row.package_info  :=  '';
        INSERT INTO VW_PREP_SCAN_SHIP VALUES v_row;
    END IF;

END;


/***************************************************************************************
    DDL:    23/10/2008 d Create date
/***************************************************************************************/
PROCEDURE p_prep_trn       (   p_ref_trn      NUMBER, p_org_code VARCHAR2)
----------------------------------------------------------------------------------------
--  PURPOSE:    prepaires data for a package (for the Package sheet and for the scanning form )
----------------------------------------------------------------------------------------
IS
    CURSOR C_LINES          (p_ref_trn    NUMBER)
                            IS
                            SELECT      t.idriga,
                                        MAX(h.org_code)     org_code,
                                        MAX(t.package_code) package_code,
                                        MAX(t.error_log)    error_log,
                                        MAX(t.whs_code)     whs_code,
                                        MAX(t.ref_trn)      ref_trn,
                                        MAX(t.trn_sign)     trn_sign,
                                        MAX(h.status)       h_status,
                                        SUM(d.qty)          qty,
                                        MAX(d.order_code)   max_order_code,
                                        MIN(d.order_code)   min_order_code
                            ---------------------------------------------------------------------------
                            FROM        PACKAGE_TRN_DETAIL  t
                            LEFT JOIN   PACKAGE_HEADER      h   ON  t.package_code  =   h.package_code
                            LEFT JOIN   PACKAGE_DETAIL      d   ON  d.package_code  =   h.package_code
                            ---------------------------------------------------------------------------
                            WHERE       t.ref_trn           =   p_ref_trn
                                    AND t.trn_sign             IN(1,0)
                            GROUP BY    t.idriga
                            ;

    CURSOR C_GET_H              (p_org_code VARCHAR2)
                                IS
                                SELECT      *
                                FROM        PACKAGE_TRN_HEADER
                                WHERE       status              =   'I'
                                    AND     org_code            =   p_org_code
                                ORDER BY    idriga DESC
                                ;

    C_SEGMENT_CODE          VARCHAR2(100)   :=  'VW_PREP_SCAN_TRN';
    v_row                   VW_PREP_SCAN_TRN%ROWTYPE;
    v_rowcount              NUMBER          :=  0;
    v_row_trh               PACKAGE_TRN_HEADER%ROWTYPE;
    v_found                 BOOLEAN;
    
BEGIN

    DELETE FROM VW_PREP_SCAN_TRN;

    IF p_ref_trn IS NULL THEN
        -- see if a transaction header exists 
        OPEN    C_GET_H(p_org_code);
        FETCH   C_GET_H INTO v_row_trh;
        v_found := C_GET_H%FOUND;
        CLOSE   C_GET_H;
        -- if no transaction header found then generate a new one 
        IF NOT v_found THEN
            v_row_trh.trn_date      :=  TRUNC(SYSDATE);
            v_row_trh.empl_code     :=  Pkg_Lib.f_return_user_code;
            v_row_trh.status        :=  'I';
            Pkg_Iud.p_package_trn_header_iud('I',v_row_trh);
            COMMIT;
            v_row_trh.idriga        :=  Pkg_Lib.f_read_pk;
        END IF;
    ELSE
        v_row_trh.idriga    :=  p_ref_trn;
        Pkg_Get.p_get_package_trn_header(v_row_trh);
    END IF;
    
    v_row.segment_code  :=  C_SEGMENT_CODE;

    FOR x IN C_LINES(v_row_trh.idriga)
    LOOP
        v_rowcount              :=  C_LINES%rowcount;
        v_row.ref_trn           :=  v_row_trh.idriga;
        v_row.ref_trn_d         :=  x.idriga;
        
        v_row.trn_info          :=      'Transfer colete '  
                                    ||  Pkg_Glb.C_NL||TO_CHAR(v_row_trh.trn_date,'dd/mm/yyyy')
                                    ||' angajat: '||v_row_trh.empl_code;
        v_row.org_code          :=  x.org_code;
        v_row.package_code      :=  x.package_code; 
        v_row.package_info      :=  '( '||x.h_status||' ) ';
        v_row.package_info      :=  v_row.package_info||x.min_order_code;
        IF x.min_order_code <> x.max_order_code THEN
             v_row.package_info := v_row.package_info||' '||x.max_order_code;
        END IF;
        v_row.whs_in            :=  x.whs_code;
        v_row.error_log         :=  x.error_log;
        IF x.error_log IS NOT NULL THEN
            v_row.status        :=  'E';
            v_row.package_info  :=  'ERROR! '||x.error_log;
            v_row.trn_qty       :=  0;
        ELSE
            v_row.status        :=  '';
            v_row.trn_qty       :=  x.qty;
        END IF;
        v_row.trn_sign          :=  x.trn_sign;
        
        INSERT INTO VW_PREP_SCAN_TRN VALUES v_row;
    END LOOP;

    IF v_rowcount = 0 THEN
        v_row.ref_trn_d     :=  0;
        v_row.org_code      :=  NULL;
        v_row.package_code  :=  '';
        v_row.package_info  :=  '';
        INSERT INTO VW_PREP_SCAN_TRN VALUES v_row;
    END IF;

END;


/***************************************************************************************
    DDL:    07/07/2008 d Create date
/***************************************************************************************/
PROCEDURE p_scan_ship           (   p_ref_shipment      NUMBER,
                                    p_ship_code         VARCHAR2,
                                    p_scanned_value     VARCHAR2
                                )
IS

    CURSOR C_EX_SHIP_PKG        (p_ref_shipment VARCHAR2, p_package_code VARCHAR2)
                                IS
                                SELECT      1
                                FROM        SHIPMENT_PACKAGE
                                WHERE       ref_shipment    =   p_ref_shipment
                                    AND     package_code    =   p_package_code
                                ;

    v_row_shh                   SHIPMENT_HEADER%ROWTYPE;
    v_row_spk                   SHIPMENT_PACKAGE%ROWTYPE;
    it_line                     Pkg_Glb.typ_string;
    v_test                      PLS_INTEGER;
    v_found                     BOOLEAN;

BEGIN

    IF p_ref_shipment IS NOT NULL THEN
        -- get the SHIPMENT HEADER row
        v_row_shh.idriga            :=  p_ref_shipment;
        IF Pkg_Get.f_get_shipment_header(v_row_shh,-1) THEN NULL; END IF;
    ELSE
        -- get the SHIPMENT HEADER row
        v_row_shh.ship_code         :=  p_ship_code;
        IF Pkg_Get2.f_get_shipment_header_2(v_row_shh,-1) THEN NULL; END IF;
    END IF;

    OPEN    C_EX_SHIP_PKG(v_row_shh.idriga, p_scanned_value);
    FETCH   C_EX_SHIP_PKG INTO v_test;
    v_found := C_EX_SHIP_PKG%FOUND;
    CLOSE   C_EX_SHIP_PKG;

    IF NOT v_found THEN

        v_row_spk.ref_shipment      :=  v_row_shh.idriga;
        v_row_spk.seq_no            :=  1;
        v_row_spk.package_type      :=  'BOX';
        v_row_spk.weight_net        :=  0;
        v_row_spk.weight_brut       :=  0;
        v_row_spk.volume            :=  0;
        v_row_spk.org_code          :=  v_row_shh.org_code;
        v_row_spk.package_code      :=  p_scanned_value;

        Pkg_Iud.p_shipment_package_iud('I', v_row_spk);
        
        -- set sipment header -> flag_package to "N" 
        v_row_shh.flag_package      :=  'N';
        
        COMMIT;
    END IF;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************
    07/07/2008  d   Create
/*********************************************************************************************/
FUNCTION f_sql_ship      (p_ship_code  VARCHAR2)         RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for PAcakge management form
----------------------------------------------------------------------------------------------
IS

    CURSOR     C_LINES      IS
                            SELECT      *
                            FROM        VW_PREP_SCAN_SHIP
                            ;

    v_row      tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES LOOP

        v_row.idriga    :=  NVL(x.ref_ship_pkg,0);
        v_row.dcn       :=  0;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.ship_code;
        v_row.txt03     :=  x.ship_info;
        v_row.txt04     :=  x.package_code;
        v_row.txt05     :=  x.package_info;
        v_row.txt06     :=  '';
        v_row.txt09     :=  x.status;
        v_row.txt10     :=  x.error_log;
        v_row.txt11     :=  x.error_log_h;
        v_row.txt12     :=  x.status_h;
        v_row.numb01    :=  x.ref_ship;
        v_row.numb02    :=  x.pkg_qty;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/*********************************************************************************************
    23/10/2008  d   Create
/*********************************************************************************************/
FUNCTION f_sql_trn               RETURN typ_frm  pipelined
----------------------------------------------------------------------------------------------
--  PURPOSE:    returns the record-source for PAcakge management form
----------------------------------------------------------------------------------------------
IS

    CURSOR     C_LINES      IS
                            SELECT      *
                            FROM        VW_PREP_SCAN_TRN
                            ;

    v_row      tmp_frm := tmp_frm();

BEGIN

    FOR X IN C_LINES LOOP

        v_row.idriga    :=  x.ref_trn_d;
        v_row.dcn       :=  0;
        v_row.seq_no    :=  C_LINES%rowcount;

        v_row.txt01     :=  x.org_code;
        v_row.txt02     :=  x.package_code;
        v_row.txt03     :=  x.package_info;
        v_row.txt04     :=  x.package_content;
        v_row.txt05     :=  x.whs_out;
        v_row.txt06     :=  x.whs_in;
        v_row.txt09     :=  x.status;
        v_row.txt10     :=  x.error_log;
        v_row.txt11     :=  x.empl_code;
        v_row.txt12     :=  x.trn_info;
        v_row.numb01    :=  x.ref_trn;
        v_row.numb02    :=  x.trn_sign;
        v_row.numb04    :=  x.trn_qty;
        v_row.data01    :=  x.trn_date;
        
        pipe ROW(v_row);
    END LOOP;

    RETURN;

END;

/**********************************************************************************************
    DDL:    08/07/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_prep_ord_pkg_qty    (   p_org_code      VARCHAR2,
                                    p_order_code    VARCHAR2
                                )
---------------------------------------------------------------------------------------------------
--  PURPOSE:    loads in VW_PREP_ORD_PKG_QTY the packed quantities
---------------------------------------------------------------------------------------------------
IS
PRAGMA autonomous_transaction;

    CURSOR C_ORD_PKG_QTY        (   p_org_code      VARCHAR2,
                                    p_order_code    VARCHAR2)
                                IS
                                SELECT      d.org_code          ,
                                            d.order_code        ,
                                            d.size_code         ,
                                            SUM(d.qty)          pkg_qty
                                --------------------------------------------------------
                                FROM        PACKAGE_DETAIL      d
                                --------------------------------------------------------
                                WHERE       d.org_code          =       p_org_code
                                        AND d.order_code        =       p_order_code
                                --------------------------------------------------------
                                GROUP BY    d.org_code,d.order_code, d.size_code
                                ;

    v_row                       VW_PREP_ORD_PKG_QTY%ROWTYPE;
    C_SEGMENT_CODE              CONSTANT VARCHAR2(30)   :=  'VW_PREP_ORD_PKG_QTY';

BEGIN
    DELETE FROM VW_PREP_ORD_PKG_QTY;

    -- load the production declarations
    FOR x IN C_ORD_PKG_QTY  (p_org_code, p_order_code)
    LOOP
        v_row.org_code      :=  x.org_code;
        v_row.order_code    :=  x.order_code;
        v_row.size_code     :=  x.size_code;
        v_row.pkg_qty       :=  x.pkg_qty;
        v_row.segment_code  :=  C_SEGMENT_CODE;
        INSERT INTO VW_PREP_ORD_PKG_QTY VALUES  v_row;
    END LOOP;

    COMMIT;
END;


/**********************************************************************************************
    DDL:    08/07/2008  d   Create
/**********************************************************************************************/
PROCEDURE p_queue_pkg_sheet     (   p_package_code  VARCHAR2, p_force_print VARCHAR2 := 'N')
---------------------------------------------------------------------------------------------------
--  PURPOSE:    loads in VW_PREP_ORD_PKG_QTY the packed quantities
---------------------------------------------------------------------------------------------------
IS

    CURSOR C_LINES      IS
                        SELECT  *
                        FROM    VW_REP_PKG_SHEET
                        ;

    CURSOR C_GET_NOL    (p_user_code VARCHAR2, p_org_code VARCHAR2)
                        IS
                        SELECT  COUNT(DISTINCT package_code)
                        FROM    VW_QRP_PKG_SHEET
                        WHERE   user_code   =   p_user_code
                            AND org_code    =   p_org_code
                        ;

    CURSOR C_GET_RQH    (p_report_code VARCHAR2, p_user_code VARCHAR2)
                        IS
                        SELECT  *
                        FROM    REPORT_QUEUE_HEADER
                        WHERE   report_code     =   p_report_code
                            AND user_code       =   p_user_code
                        ;

    CURSOR C_EX_PKG     (p_package_code VARCHAR2, p_user_code VARCHAR2)
                        IS
                        SELECT  1
                        FROM    VW_QRP_PKG_SHEET
                        WHERE   user_code           =   p_user_code
                            AND package_code        =   p_package_code
                        ;

    v_row               VW_QRP_PKG_SHEET%ROWTYPE;
    v_row_rqh           REPORT_QUEUE_HEADER%ROWTYPE;
    v_row_pkh           PACKAGE_HEADER%ROWTYPE;
    v_found             BOOLEAN;
    v_nol               INTEGER;
    v_user_code         VARCHAR2(30);
    C_REPORT_CODE       VARCHAR2(30) := 'PKG_SHEET';

BEGIN

    v_user_code         :=  NVL(Pkg_Lib.f_return_user_code,'-');

    -- test if the package_code is not null => try to add it, otherwise, just force the QUEUE status
    IF p_package_code IS NOT NULL THEN
        -- get the PACKAGE HEADER row
        v_row_pkh.package_code      :=  p_package_code;
        IF Pkg_Get2.f_get_package_header_2(v_row_pkh,-1) THEN NULL; END IF;

        -- test if the package is in QUEUE already
        OPEN    C_EX_PKG    (p_package_code, v_user_code);
        FETCH   C_EX_PKG    INTO v_nol;
        v_found :=  C_EX_PKG%FOUND;
        CLOSE   C_EX_PKG;
END IF;
    IF NOT v_found THEN

        -- get the QUEUE HEADER , if exists
        OPEN    C_GET_RQH(C_REPORT_CODE, v_user_code);
        FETCH   C_GET_RQH INTO v_row_rqh;
        v_found :=  C_GET_RQH%FOUND;
        CLOSE C_GET_RQH;

        IF v_found THEN
            IF v_row_rqh.status = 'P' THEN
                DELETE
                FROM    REPORT_QUEUE_DETAIL
                WHERE   report_code =   C_REPORT_CODE
                    AND user_code   =   v_user_code;

                v_row_rqh.status := 'I';
                Pkg_Iud.p_report_queue_header_iud('U',v_row_rqh);

            END IF;
        ELSE
            v_row_rqh.status        :=  'I';
            v_row_rqh.report_code   :=  C_REPORT_CODE;
            v_row_rqh.description   :=  'Raport eticheta colectiva';
            v_row_rqh.user_code     :=  v_user_code;
            Pkg_Iud.p_report_queue_header_iud('I',v_row_rqh);
        END IF;

        Pkg_Scan.p_rep_pkg_sheet(p_package_code);

        v_row.txt_pkg_content       :=  RPAD('Bola',20,' ')     ||
                                        RPAD('Cal' ,4 ,' ')     ||
                                        RPAD('Marimi',50,' ')   ;

        FOR x IN C_LINES
        LOOP
            v_row.rep_title         :=  x.rep_title;
            v_row.rep_info          :=  x.rep_info;
            v_row.org_code          :=  x.org_code;
            v_row.package_code      :=  x.package_code;
            v_row.order_code        :=  x.order_code;
            v_row.item_code         :=  x.item_code;
            v_row.description       :=  x.description;
            v_row.wo_size           :=  x.wo_size;
            v_row.wo_qty_1          :=  x.wo_qty_1;
            v_row.wo_qty_2          :=  x.wo_qty_2;
            v_row.package_code_bc   :=  x.package_code_bc;
            v_row.picture_path      :=  x.picture_path;
            v_row.user_code         :=  v_user_code;
            v_row.report_code       :=  C_REPORT_CODE;
            v_row.txt_pkg_content   :=      v_row.txt_pkg_content ||Pkg_Glb.C_NL
                                        ||  RPAD(x.order_code,  20,' ')
                                        ||  RPAD(x.description,54)||Pkg_Glb.C_NL
                                        ||  RPAD(' ', 24)
                                        ||  RPAD(x.wo_size,   50,' ') || Pkg_Glb.C_NL
                                        ||  RPAD(' ',20,' ')
                                        ||  RPAD('1',4, ' ')
                                        ||  RPAD(x.wo_qty_1,50,' ')     || Pkg_Glb.C_NL;

            IF trim(x.wo_qty_2) IS NOT NULL THEN
                v_row.txt_pkg_content   :=      v_row.txt_pkg_content
                                            ||  RPAD(' ',20,' ')
                                            ||  RPAD('2',4, ' ')
                                            ||  RPAD(x.wo_qty_2,50,' ')     || Pkg_Glb.C_NL;

            END IF;

        END LOOP;

        INSERT INTO VW_QRP_PKG_SHEET VALUES v_row;

        -- put the report status on READY, if report lines = 8
        OPEN C_GET_NOL(v_user_code,v_row_pkh.org_code); FETCH C_GET_NOL INTO v_nol; CLOSE C_GET_NOL;

    END IF; --// if the package is not in the QUEUE already

    -- test if the number of lines in the report is >=8 or the FORCE argument was sent
    IF v_nol >= 8 OR p_force_print = 'Y' THEN
        v_row_rqh.status    :=  'R';
        Pkg_Iud.p_report_queue_header_iud('U',v_row_rqh);
    END IF;

    COMMIT;

EXCEPTION WHEN OTHERS THEN NULL;

END;

PROCEDURE p_flush_queue (p_flag_all VARCHAR2 DEFAULT 'N')
IS
    v_user_code         VARCHAR2(30);
BEGIN

    v_user_code         :=  Pkg_App_Secur.f_return_user();

    DELETE
    FROM    REPORT_QUEUE_DETAIL d
    WHERE   EXISTS (SELECT  1
                    FROM    REPORT_QUEUE_HEADER h
                    WHERE   h.user_code         =   d.user_code
                        AND h.report_code       =   d.report_code
                        AND (
                            h.status            IN  ('P','R')
                            OR
                            p_flag_all          =   'Y'
                            )
                        AND h.USER_CODE         =   v_user_code
                    )
    ;

    DELETE
    FROM    REPORT_QUEUE_HEADER h
    WHERE   (
            h.status            IN  ('P','R')
            OR
            p_flag_all          =   'Y'
            )
        AND user_code   =   v_user_code
    ;

    COMMIT;

END;


PROCEDURE p_pseudo_login
IS
BEGIN
    -- get the computer name
    Pkg_Glb.gv_user_code    :=  SUBSTR(SYS_CONTEXT('USERENV','HOST'),INSTR(SYS_CONTEXT('USERENV','HOST'),'\')+1);
    -- substract the last part of the computer name
    Pkg_Glb.gv_user_code    :=  SUBSTR(Pkg_Glb.gv_user_code, -10);
END;

/*******************************************************************************
    DDL:    25/09/2008 d create 
/*******************************************************************************/
PROCEDURE p_queue_pkg_sheet_multi(  p_org_code      VARCHAR2, 
                                    p_pkg_list      VARCHAR2,
                                    p_force         VARCHAR2)

IS

    CURSOR C_PKG    (   p_pkg_list VARCHAR2)
                    IS  
                    SELECT  txt01 package_code,
                            COUNT(1) OVER() nr_pkg 
                    FROM    TABLE(Pkg_Lib.F_Sql_Inlist(p_pkg_list,','))
                    ;

BEGIN

    Pkg_Scan.p_flush_queue('Y');

    FOR x IN C_PKG (p_pkg_list)
    LOOP
        IF x.nr_pkg < 8 AND NVL(p_force,'N') <> 'Y' THEN
            Pkg_Err.p_rae('ALLAH e mare si va vede! Nu consumati hartia !'); 
        END IF;
        Pkg_Scan.p_queue_pkg_sheet(x.package_code, 'N');

    END LOOP;
END;

/*********************************************************************************************
    DDL:    14/11/2008  d   Create   
/*********************************************************************************************/
PROCEDURE p_package_mov (   p_ref_trn NUMBER, p_whs_code_in VARCHAR2,p_commit VARCHAR2)
IS

    CURSOR C_LINES      (p_ref_trn NUMBER)
                        IS
                        SELECT      t.*
                        FROM        PACKAGE_TRN_DETAIL  t
                        INNER JOIN  PACKAGE_DETAIL      p   ON  p.org_code      =   t.org_code
                                                            AND p.package_code  =   t.package_code
                        WHERE       t.ref_trn           =   p_ref_trn
                            AND     t.whs_code  IS NULL
                        ;
    
    
    -- check the negative transaction lines (packages that are discharged from the warehouse) 
    CURSOR C_CHK_STOCK  (p_ref_trn NUMBER)
                        IS
                        SELECT      k.org_code,
                                    k.order_code,
                                    k.size_code,
                                    k.whs_code              whs_code_out,
                                    MAX(k.item_code)        item_code,
                                    MAX(k.season_code)      season_code,                                   
                                    MAX(k.puom)             puom,
                                    MAX(k.oper_code_item)   oper_code_item,
                                    SUM(k.qty)              trn_qty,
                                    SUM(NVL(s.qty,0))       stock_qty
                        ----------------------------------------------------------------------------                                    
                        FROM
                                    (SELECT     p.org_code,
                                                p.order_code,
                                                p.size_code,
                                                t.whs_code,
                                                MAX(o.item_code)        item_code,
                                                MAX(o.season_code)      season_code,
                                                MAX(i.puom)             puom,
                                                MAX(o.oper_code_item)   oper_code_item,
                                                SUM(p.qty)              qty 
                                    ----
                                    FROM        PACKAGE_TRN_DETAIL  t
                                    INNER JOIN  PACKAGE_DETAIL      p   ON  p.org_code      =   t.org_code
                                                                        AND p.package_code  =   t.package_code
                                    INNER JOIN  WORK_ORDER          o   ON  o.org_code      =   p.org_code
                                                                        AND o.order_code    =   p.order_code
                                    INNER JOIN  ITEM                i   ON  i.org_code      =   o.org_code
                                                                        AND i.item_code     =   o.item_code
                                    ----
                                    WHERE       t.ref_trn           =   p_ref_trn
                                        AND     t.trn_sign          =   (-1)
                                    ----
                                    GROUP BY    p.org_code, p.order_code, p.size_code, t.whs_code
                                    ) k
                        LEFT JOIN   STOC_ONLINE      s      ON  s.org_code      =   k.org_code
                                                            AND s.order_code    =   k.order_code
                                                            AND s.size_code     =   k.size_code
                                                            AND s.whs_code      =   k.whs_code
                                                            AND s.oper_code_item=   k.oper_code_item
                                                            AND s.qty           >   0
                        -----------------------------------------------------------------------------
                        GROUP BY    k.org_code,
                                    k.order_code,
                                    k.size_code,
                                    k.whs_code
                        ;

    v_row_trh           PACKAGE_TRN_HEADER%ROWTYPE;
    v_row_trd           PACKAGE_TRN_DETAIL%ROWTYPE;
    
    it_ptd              Pkg_Rtype.ta_package_trn_detail;
    idx_ptd             PLS_INTEGER;
    v_row_trn_h         WHS_TRN%ROWTYPE;
    it_prep_trn         Pkg_Rtype.ta_vw_blo_prepare_trn;    
    idx_wtd             PLS_INTEGER;
    v_flag_err          BOOLEAN;
    C_SEGMENT_CODE      CONSTANT VARCHAR2(30)   :=  'VW_BLO_PREPARE_TRN';

BEGIN

    -- get TRN_HEADER row 
    v_row_trh.idriga    :=  p_ref_trn;
    Pkg_Get.p_get_package_trn_header(v_row_trh);
    
    -- checks 
    IF v_row_trh.status <> 'I' THEN
        Pkg_Err.p_rae('Starea acestei tranzactii nu permite actiunea de inregistrare in magazie!'); 
    END IF;
    
    -- check the stocks for the discharged quantities 
    v_flag_err      :=  FALSE;
    FOR x IN C_CHK_STOCK(p_ref_trn)
    LOOP
            IF NOT v_flag_err THEN
                idx_wtd :=  it_prep_trn.COUNT + 1;
                
                it_prep_trn(idx_wtd).segment_code       :=  C_SEGMENT_CODE;
                it_prep_trn(idx_wtd).org_code           :=  x.org_code;
                it_prep_trn(idx_wtd).item_code          :=  x.item_code;
                it_prep_trn(idx_wtd).colour_code        :=  NULL;
                it_prep_trn(idx_wtd).size_code          :=  x.size_code;
                it_prep_trn(idx_wtd).season_code        :=  x.season_code;
                it_prep_trn(idx_wtd).order_code         :=  x.order_code;
                it_prep_trn(idx_wtd).puom               :=  x.puom;
                it_prep_trn(idx_wtd).qty                :=  x.trn_qty;
                it_prep_trn(idx_wtd).oper_code_item     :=  x.oper_code_item;
                it_prep_trn(idx_wtd).group_code         :=  NULL;
                it_prep_trn(idx_wtd).whs_code           :=  x.whs_code_out;
                it_prep_trn(idx_wtd).cost_center        :=  NULL;
                it_prep_trn(idx_wtd).trn_sign           :=  -1;
                it_prep_trn(idx_wtd).reason_code        :=  Pkg_Glb.C_M_TTRAN;
                
                idx_wtd :=  it_prep_trn.COUNT + 1;
                it_prep_trn(idx_wtd)                    :=  it_prep_trn(idx_wtd-1);
                it_prep_trn(idx_wtd).whs_code           :=  p_whs_code_in;
                it_prep_trn(idx_wtd).cost_center        :=  NULL;
                it_prep_trn(idx_wtd).trn_sign           :=  1;
                it_prep_trn(idx_wtd).reason_code        :=  Pkg_Glb.C_P_TTRAN;

            END IF;

        
    END LOOP;
    
    Pkg_Err.p_rae();
    
    IF NOT v_flag_err AND it_prep_trn.COUNT > 0 THEN
        
        DELETE FROM VW_BLO_PREPARE_TRN;

        -- transaction header for TRANSFER 
        v_row_trn_h.org_code        :=  it_prep_trn(1).org_code;
        v_row_trn_h.trn_year        :=  TO_CHAR(SYSDATE, 'YYYY');
        v_row_trn_h.trn_type        :=  Pkg_Glb.C_TRN_TRN_TRN;
        v_row_trn_h.flag_storno     :=  'N';
        v_row_trn_h.date_legal      :=  v_row_trh.trn_date;
        v_row_trn_h.employee_code   :=  v_row_trh.empl_code;

        Pkg_Iud.p_vw_blo_prepare_trn_miud('I',it_prep_trn);
        Pkg_Mov.p_whs_trn_engine(v_row_trn_h);

    END IF;

    
    
    -- generate EXP stock for the moved packages 
    FOR x IN C_LINES(p_ref_trn)
    LOOP
        v_row_trd               :=  x;
        v_row_trd.whs_code      :=  p_whs_code_in;
        Pkg_Iud.p_package_trn_detail_iud('U',v_row_trd);
    END LOOP;
    v_row_trh.status        :=  'V';
    v_row_trh.ref_whs_trn   :=  v_row_trn_h.idriga;
    Pkg_Iud.p_package_trn_header_iud('U',v_row_trh);
    
    IF p_commit = 'Y' THEN COMMIT; END IF;

EXCEPTION WHEN OTHERS THEN
    IF p_commit = 'Y' THEN ROLLBACK; END IF;
    it_prep_trn.DELETE;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************************
    DDL:    15/11/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_package_trn_detail_iud  (   p_tip       VARCHAR2,
                                        p_row       PACKAGE_TRN_DETAIL%ROWTYPE)
-----------------------------------------------------------------------------------------------------------
--  PURPOSE:    IUD on package_header table
-----------------------------------------------------------------------------------------------------------
IS
    CURSOR C_EX     (p_org_code VARCHAR2, p_package_code VARCHAR2, p_ref_trn NUMBER)
                    IS
                    SELECT      *
                    FROM        PACKAGE_TRN_DETAIL
                    WHERE       ref_trn             =   p_ref_trn
                            AND org_code            =   p_org_code
                            AND package_code        =   p_package_code
                    ;     
                    
    v_row_crs       C_EX%ROWTYPE;
    v_found         BOOLEAN;                
    v_row           PACKAGE_TRN_DETAIL%ROWTYPE;
    v_row_pth       PACKAGE_TRN_HEADER%ROWTYPE;
BEGIN

    v_row               :=  p_row;

    IF p_tip = 'I' THEN
        -- check if the package has been already scanned 
        OPEN    C_EX(v_row.org_code, v_row.package_code, v_row.ref_trn);
        FETCH   C_EX INTO v_row_crs;
        v_found :=  C_EX%FOUND;
        CLOSE   C_EX;
        IF v_found THEN RETURN; END IF;
    END IF;
    
    v_row_pth.idriga    :=  v_row.ref_trn;
    Pkg_Get.p_get_package_trn_header(v_row_pth);
    IF v_row_pth.status <> 'I' THEN
        Pkg_Err.p_rae('Aceasta tranzactie a fost deja executata! Nu se mai pot modifca detaliile!');
    END IF;    
    
    -- BLO

    --IUD
    Pkg_Iud.p_package_trn_detail_iud(p_tip, v_row);

    --delete all the lines that refer to this package
    IF p_tip = 'D' THEN
        DELETE 
        FROM    PACKAGE_TRN_DETAIL
        WHERE   ref_trn         =   v_row.ref_trn
            AND package_code    =   v_row.package_code
            AND org_code        =   v_row.org_code
        ;
    END IF;
    
    COMMIT;

    Pkg_Scan.p_pkg_validate(p_row.package_code);

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************************************
    DDL:    18/11/2008 d Create procedure
/*********************************************************************************************************/
PROCEDURE p_rep_pkg_key
IS
    CURSOR C_KEY    IS
                    SELECT      description
                    FROM        MULTI_TABLE
                    WHERE       table_name      =   'SYSPAR'
                        AND     table_key       =   'PWD_CHANGE_PACKAGE'
                    ;
                    
    v_row_rep       VW_REP_PKG_KEY%ROWTYPE;
    C_SEGMENT_CODE  VARCHAR2(50)    :=  'VW_REP_PKG_KEY';
BEGIN

    Pkg_App_Secur.p_test_grant('APP_ADMIN');

    DELETE FROM VW_REP_PKG_KEY;
    v_row_rep.rep_title     :=  'Cheie deblocare coletaje';
    v_row_rep.rep_info      :=  '';
    v_row_rep.segment_code  :=  C_SEGMENT_CODE;
    OPEN C_KEY; FETCH C_KEY INTO v_row_rep.key_code; CLOSE C_KEY;
    INSERT INTO VW_REP_PKG_KEY VALUES v_row_rep;
END;


PROCEDURE p_gen_package_trn (   p_ref_shipment          NUMBER, 
                                p_whs_in                VARCHAR2, 
                                p_ref_trn       IN OUT  NUMBER)
----------------------------------------------------------------------------------
--  PURPOSE:    generates a package transaction for the packages associated with 
--              a shipment that are located in whs_out for moving them in whs_in   
----------------------------------------------------------------------------------
IS
    CURSOR C_LINES  (p_ref_shipment NUMBER)
                    IS
                    SELECT      p.org_code, p.PACKAGE_CODE, s.whs_code
                    FROM        SHIPMENT_PACKAGE    p
                    LEFT JOIN   STOC_ONLINE_PKG     s   ON  s.package_code  =   p.package_code
                    WHERE       p.ref_shipment      =   p_ref_shipment
                    ;        

    v_row_shp       SHIPMENT_HEADER%ROWTYPE;
    v_row_pth       PACKAGE_TRN_HEADER%ROWTYPE;                    
    it_ptd          Pkg_Rtype.ta_package_trn_detail;
    idx_ptd         PLS_INTEGER;       
BEGIN

    v_row_shp.idriga    :=  p_ref_shipment;
    Pkg_Get.p_get_shipment_header(v_row_shp);
    
    v_row_pth.org_code  :=  v_row_shp.org_code;
    v_row_pth.trn_date  :=  TRUNC(SYSDATE);
    v_row_pth.status    :=  'I';
    v_row_pth.trn_type  :=  'SHP';
    v_row_pth.ref_shipment  :=  p_ref_shipment;
    Pkg_Iud.p_package_trn_header_iud('I',v_row_pth);
    v_row_pth.idriga    :=  Pkg_Lib.f_read_pk;
    p_ref_trn           :=  v_row_pth.idriga;  
    
    FOR x IN C_LINES(p_ref_shipment)
    LOOP
        -- generate transaction only if the source and destination warehouse are different 
        IF Pkg_Lib.f_mod_c(x.whs_code, p_whs_in) THEN
            --  generate positive transaction only if destination warehouse exists  
            IF p_whs_in IS NOT NULL THEN
                idx_ptd                         :=  it_ptd.COUNT + 1;
                it_ptd(idx_ptd).org_code        :=  x.org_code;
                it_ptd(idx_ptd).package_code    :=  x.package_code;
                it_ptd(idx_ptd).whs_code        :=  p_whs_in;
                it_ptd(idx_ptd).ref_trn         :=  v_row_pth.idriga;
                it_ptd(idx_ptd).trn_sign        :=  +1;
            END IF;
        
            --  generate negative transaction only for the packages that have stock in 
            --  the source warehouse                         
            IF NOT x.whs_code IS NULL THEN
                idx_ptd                     :=  it_ptd.COUNT + 1;
                it_ptd(idx_ptd)             :=  it_ptd(idx_ptd - 1);
                it_ptd(idx_ptd).trn_sign    :=  -1;
                it_ptd(idx_ptd).whs_code    :=  x.whs_code;
            END IF;
        END IF;
    END LOOP;
    
    Pkg_Iud.p_package_trn_detail_miud('I',it_ptd);
    
END;





END;

/

/
