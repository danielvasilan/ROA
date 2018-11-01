--------------------------------------------------------
--  DDL for Package Body PKG_NOMENC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_NOMENC" 
IS
----------------------------------------------------------------------------------
-- DDL: 18/02/2008  d Create package
--
--
----------------------------------------------------------------------------------
/*********************************************************************************
    DDL: 08/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_warehouse_categ  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the WAREHOUSE_CATEG
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*
                FROM    WAREHOUSE_CATEG m
                ORDER BY m.category_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.category_code;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.valuation_type;
        v_row.txt04         :=  x.qty_on_hand;
        v_row.txt05         :=  x.custody;
        v_row.txt06         :=  x.intern;
        v_row.txt07         :=  x.virtual;
        v_row.txt08         :=  x.allow_negative;
        v_row.txt09         :=  x.accounting;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 08/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_warehouse  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the WAREHOUSE
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*,
                        o.org_name
                FROM        WAREHOUSE       m
                LEFT  JOIN  ORGANIZATION    o
                            ON  o.org_code  =   m.org_code
                ORDER BY m.category_code, m.whs_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.category_code;
        v_row.txt02         :=  x.whs_code;
        v_row.txt03         :=  x.description;
        v_row.txt04         :=  x.account_code;
        v_row.txt05         :=  x.org_code;
        v_row.txt06         :=  x.org_name;

        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL:    08/03/2008  z   Create procedure
            18/11/2008  d   SECURITY 
/*********************************************************************************/
PROCEDURE p_warehouse_categ_iud(p_tip VARCHAR2, p_row WAREHOUSE_CATEG%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in WAREHOUSE_CATEG when is created , updated, deleted
----------------------------------------------------------------------------------
IS
    v_row               WAREHOUSE_CATEG%ROWTYPE;
BEGIN

    -- ONLY APP admins 
    Pkg_App_Secur.p_test_grant('APP_ADMIN');

    v_row   :=  p_row;

    Pkg_Iud.p_warehouse_categ_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;

/*********************************************************************************
    DDL: 08/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_whs_trn_reason  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the WHS_TRN_REASON
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*
                FROM    WHS_TRN_REASON m
                ORDER BY m.business_flow ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.reason_code;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.reason_type;
        v_row.txt04         :=  x.property;
        v_row.txt05         :=  x.alloc_wo;
        v_row.txt06         :=  x.accounting;
        v_row.txt07         :=  x.show_user;
        --
        v_row.numb01            :=  x.trn_sign;
        v_row.numb02            :=  x.business_flow;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 08/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_whs_trn_reason_iud(p_tip VARCHAR2, p_row WHS_TRN_REASON%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in WHS_TRN_REASON when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               WHS_TRN_REASON%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    --Pkg_Receipt.p_chk_warehouse_categ_iud(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_whs_trn_reason_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 08/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_warehouse_iud(p_tip VARCHAR2, p_row WAREHOUSE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in WAREHOUSE when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               WAREHOUSE%ROWTYPE;
BEGIN

    -- only APP administrator(s) 
    Pkg_App_Secur.p_test_grant('APP_ADMIN');

    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Nomenc.p_warehouse_blo(p_tip,v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_warehouse_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    Pkg_Err.p_dump_error_message();
    ROLLBACK;
    RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 20/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_warehouse_blo(p_tip VARCHAR2, p_row IN OUT WAREHOUSE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row_old           WAREHOUSE%ROWTYPE;

    v_row_wct           WAREHOUSE_CATEG%ROWTYPE;
    v_row_org           ORGANIZATION%ROWTYPE;
    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        v_row_wct.category_code  :=  p_row.category_code;
        Pkg_Check.p_chk_warehouse_categ(v_row_wct) ;
        --
        v_row_org.org_code      :=  p_row.org_code;
        Pkg_Check.p_chk_organization(v_row_org);

        IF p_row.whs_code IS NULL THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '100' ,
                 p_err_header        => 'Nu ati precizat codul de magazie '
                                        ||' !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;
        -- do not let to change category code after the warehouse was introduced
        -- if is needed first has to be deleted and introduced with the correct
        -- category
        IF Pkg_Lib.f_mod_c(v_row_old.category_code,p_row.category_code) THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '150' ,
                 p_err_header        => 'Odata definita magazia nu mai'
                                        ||' puteti modifica categoria magaziei,'
                                        ||' daca vreti sa modificati categoria'
                                        ||' trebuie sa stergeti magazia si sa o'
                                        ||' redefiniti'
                                        ||' !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;


    END;
    ---------------------------------------------------------------------------
BEGIN

    v_row_old    :=  p_row;
    IF Pkg_Get.f_get_warehouse(v_row_old,-1) THEN NULL ; END IF;

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --
        WHEN    'U' THEN
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;



/*********************************************************************************
    DDL: 14/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_movement_type  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the MOVEMENT_TYPE
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*
                FROM    MOVEMENT_TYPE m
                ORDER BY m.trn_type ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.trn_type;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.flag_plan;
        v_row.txt04         :=  x.pick_parameter;
        v_row.txt05         :=  x.pick_form_index;
        v_row.txt06         :=  x.accounting;
        --
        v_row.numb01        :=  x.seq_no;        


        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 14/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_movement_type_iud(p_tip VARCHAR2, p_row MOVEMENT_TYPE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in MOVEMENT_TYPE when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               MOVEMENT_TYPE%ROWTYPE;
BEGIN

    -- only APP admins 
    Pkg_App_Secur.p_test_grant('APP_ADMIN');

    v_row   :=  p_row;
    Pkg_Iud.p_movement_type_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 14/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_organization  RETURN typ_longinfo  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the ORGANIZATION
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*
                FROM    ORGANIZATION m
                ORDER BY m.flag_myself DESC,m.flag_sbu DESC, m.org_code ASC
                ;
    --
    v_row               tmp_longinfo             :=  tmp_longinfo();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code ;
        v_row.txt02         :=  x.org_name ;
        v_row.txt03         :=  x.flag_client  ;
        v_row.txt04         :=  x.flag_supply  ;
        v_row.txt05         :=  x.country_code ;
        v_row.txt06         :=  x.city  ;
        v_row.txt07         :=  x.address  ;
        v_row.txt08         :=  x.phone  ;
        v_row.txt09         :=  x.fax  ;
        v_row.txt10         :=  x.email  ;
        v_row.txt11         :=  x.contact_pers   ;
        v_row.txt12         :=  x.bank   ;
        v_row.txt13         :=  x.bank_account   ;
        v_row.txt14         :=  x.fiscal_code    ;
        v_row.txt15         :=  x.regist_code    ;
        v_row.txt16         :=  x.flag_myself    ;
        v_row.txt17         :=  x.flag_lohn    ;
        v_row.txt18         :=  x.flag_grp_omog     ;
        v_row.txt19         :=  x.note     ;
        v_row.txt20         :=  x.flag_sbu     ;
        v_row.txt21         :=  x.county     ;
        
        



        v_row.numb01        :=  x.transp_ltime     ;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 14/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_organization_iud(p_tip VARCHAR2, p_row ORGANIZATION%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in ORGANIZATION when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               ORGANIZATION%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Nomenc.p_organization_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_organization_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL: 20/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_organization_blo(p_tip VARCHAR2, p_row IN OUT ORGANIZATION%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row_cot           COUNTRY%ROWTYPE;

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        v_row_cot.country_code  :=  p_row.country_code;
        Pkg_Check.p_chk_country(v_row_cot);
        --
        IF p_row.org_code IS NULL THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '100' ,
                 p_err_header        => 'Nu ati precizat codificarea '
                                        ||'organizatiei !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;
        ---
        IF p_row.org_name IS NULL THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '200' ,
                 p_err_header        => 'Nu ati precizat denumirea '
                                        ||'organizatiei !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;
        --
        IF      p_row.flag_myself IS NULL
            OR  p_row.flag_client IS NULL
            OR  p_row.flag_supply IS NULL
            OR  p_row.flag_lohn   IS NULL
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '300' ,
                 p_err_header        => 'Nu ati precizat informatia de '
                                        ||' client/furnizor/tert !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;
        -- client has to be coded with length of 3
        IF      p_row.flag_client = 'Y'
            AND LENGTH(p_row.org_code) <> 3
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '400' ,
                 p_err_header        => 'Daca organizatia este client '
                                        ||' acesta trebuie codificata pe o '
                                        ||' lungime de 3 caractere !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;
    END;
    ---------------------------------------------------------------------------
BEGIN

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --
        WHEN    'U' THEN
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 14/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_organization_loc(p_org_code VARCHAR2)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the ORGANIZATION_LOC
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES(p_org_code VARCHAR2)    IS
                SELECT  m.*
                FROM    ORGANIZATION_LOC m
                WHERE   org_code    =   p_org_code
                ORDER BY m.loc_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES(p_org_code) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code ;
        v_row.txt02         :=  x.loc_code  ;
        v_row.txt03         :=  x.description   ;
        v_row.txt04         :=  x.country_code    ;
        v_row.txt05         :=  x.city  ;
        v_row.txt06         :=  x.address   ;
        v_row.txt07         :=  x.phone   ;
        v_row.txt08         :=  x.fax   ;
        v_row.txt09         :=  x.email   ;
        v_row.txt10         :=  x.contact_pers   ;


        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 14/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_organization_loc_iud(p_tip VARCHAR2, p_row ORGANIZATION_LOC%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in ORGANIZATION when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               ORGANIZATION_LOC%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    --Pkg_Receipt.p_chk_warehouse_categ_iud(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_organization_loc_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));

END;
/*********************************************************************************
    DDL:    18/03/2008  z   Create procedure
            10/04/2008  d   added exchange rate 
/*********************************************************************************/
FUNCTION f_sql_calendar(p_year VARCHAR2)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the CALENDAR
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES      (p_year VARCHAR2)
                            IS
                            SELECT      m.*                 ,
                                        r.currency_from     ,
                                        r.currency_to       ,
                                        exchange_rate
                            ----------------------------------------------------------------------------
                            FROM        CALENDAR            m
                            LEFT JOIN   CURRENCY_RATE       r   ON  r.calendar_day  =   m.calendar_day
                            ----------------------------------------------------------------------------
                            WHERE       TO_CHAR(m.calendar_day,'YYYY')    =  p_year
                            ORDER BY    m.calendar_day ASC
                            ;

    v_row               tmp_frm             :=  tmp_frm();

BEGIN
    --
    Pkg_Err.p_reset_error_message();
    ---
    IF p_year IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Nu ati precizat anul'
                                    ||' !!!',
             p_err_detail        => NULL ,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_year) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.flag_work ;
        v_row.txt02         :=  x.note  ;
        v_row.txt03         :=  TO_CHAR(x.calendar_day,'MM');
        v_row.txt04         :=  TO_CHAR(x.calendar_day, 'DAY','NLS_DATE_LANGUAGE = romanian');
        IF x.currency_from IS NOT NULL THEN
            v_row.txt05     :=  '1 '||x.currency_from||' = '||x.exchange_rate||' '||x.currency_to;
        ELSE
            v_row.txt05     :=  '';
        END IF;
        --
        v_row.data01        :=  x.calendar_day;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_currency_rate(p_calendar_day VARCHAR2)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the CURRENCY_RATE
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES (p_year VARCHAR2)   IS
                SELECT  m.*
                FROM    CURRENCY_RATE m
                WHERE   calendar_day    =   p_calendar_day
                ORDER BY m.currency_from ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES(p_calendar_day) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.currency_from ;
        v_row.txt02         :=  x.currency_to ;
        --
        v_row.numb01        :=  x.exchange_rate;
        --
        v_row.data01        :=  x.calendar_day;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL:    18/03/2008  z   Create procedure
            18/11/2008  d   added SECURITY + reformatting code     
/*********************************************************************************/
PROCEDURE p_calendar_iud(p_tip VARCHAR2, p_row CALENDAR%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CALENDAR when is created , updated, deleted
----------------------------------------------------------------------------------
IS
    v_row               CALENDAR%ROWTYPE;
    v_row_old           CALENDAR%ROWTYPE;
BEGIN

    Pkg_App_Secur.p_test_grant('APP_ADMIN');
    
    v_row   :=  p_row;
    
    Pkg_Iud.p_calendar_iud(p_tip, v_row);
    
    COMMIT;
    
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_currency_rate_iud(p_tip VARCHAR2, p_row CURRENCY_RATE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CURRENCY_RATE when is created , updated, deleted
----------------------------------------------------------------------------------
IS
    v_row               CURRENCY_RATE%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Nomenc.p_currency_rate_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_currency_rate_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_currency_rate_blo(p_tip VARCHAR2, p_row IN OUT CURRENCY_RATE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    v_row_cur       CURRENCY%ROWTYPE;

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        v_row_cur.currency_code  :=  p_row.currency_from;
        Pkg_Check.p_chk_currency(v_row_cur,'Valuta sursa');
        --
        v_row_cur.currency_code  :=  p_row.currency_to;
        Pkg_Check.p_chk_currency(v_row_cur,'Valuta destinatie');
        --
        -- currency_from should difer from currency_to
        IF p_row.currency_from = p_row.currency_to THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '100' ,
                 p_err_header        => 'Valuta sursa trebuie sa fie diferita'
                                        ||' de valuta destinatie !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;
        -- the exchange rate should be positiv and at most 4 decimals
        p_row.exchange_rate     :=  NVL(p_row.exchange_rate,0);
        IF      p_row.exchange_rate  <= 0
            OR  p_row.exchange_rate - TRUNC(p_row.exchange_rate,4) > 0
        THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '110' ,
                 p_err_header        => 'Cursul de schimb trebuie sa fie o valoare'
                                        ||' pozitiva si cel mult 4 zecimale !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;
        --
        -- the currency to should be RON
        IF p_row.currency_to <> 'RON' THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '120' ,
                 p_err_header        => 'Valuta destinatie trebuie '
                                        ||'sa fie RON !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;
    
    END;
    ---------------------------------------------------------------------------
BEGIN

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --
        WHEN    'U' THEN
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/************************************************************************************************
    DDL: 17/03/2008  d Create procedure
/************************************************************************************************/
FUNCTION f_sql_costcenter   RETURN typ_frm  pipelined
-------------------------------------------------------------------------------------------------
--  PURPOSE:      RECORDSOURCE for COSTCENTER form
------------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES      IS
                        SELECT      c.*                 ,
                                    o.org_name
                        -------------------------------------------------------------------------
                        FROM        COSTCENTER          c
                        INNER JOIN  ORGANIZATION        o   ON  o.org_code      =   c.org_code
                        -------------------------------------------------------------------------
                        ORDER BY    c.costcenter_code
                        ;

    v_row               tmp_frm             :=  tmp_frm();

BEGIN

    FOR x IN C_LINES LOOP
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;

        v_row.txt01         :=  x.costcenter_code;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.org_code;
        v_row.txt04         :=  x.org_name;
        v_row.txt05         :=  x.flag_intern;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/************************************************************************************************
    DDL: 17/03/2008  d Create procedure
/************************************************************************************************/
FUNCTION f_sql_workcenter       (p_costcenter_code  VARCHAR2)  RETURN typ_frm  pipelined
-------------------------------------------------------------------------------------------------
--  PURPOSE:      RECORDSOURCE for WORKCENTER form
------------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES      (   p_costcenter_code    VARCHAR2)
                        IS
                        SELECT      w.*,
                                    wh.description      wh_description
                        -------------------------------------------------------------------------
                        FROM        WORKCENTER          w
                        LEFT JOIN   WAREHOUSE           wh  ON  wh.whs_code     =   w.whs_code
                        -------------------------------------------------------------------------
                        WHERE       w.costcenter_code   =   p_costcenter_code
                        ORDER BY    w.costcenter_code
                        ;

    CURSOR C_OPER       (   p_workcenter_code   VARCHAR2)
                        IS
                        SELECT      wo.oper_code
                        FROM        WORKCENTER_OPER     wo
                        WHERE       workcenter_code     =   p_workcenter_code
                        ;

    v_row               tmp_frm             :=  tmp_frm();
    v_oper              VARCHAR2(200);

BEGIN

    FOR x IN C_LINES(p_costcenter_code)
    LOOP

        v_oper              :=  '';
        FOR xx IN C_OPER(x.workcenter_code)
        LOOP
            v_oper          :=  v_oper || xx.oper_code || ' ';
        END LOOP;

        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;

        v_row.txt01         :=  x.costcenter_code;
        v_row.txt02         :=  x.workcenter_code;
        v_row.txt03         :=  x.description;
        v_row.txt04         :=  x.whs_code;
        v_row.txt05         :=  x.wh_description;
        v_row.txt06         :=  v_oper;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


/*********************************************************************************
    DDL:    17/03/2008  d   Create procedure
/*********************************************************************************/
PROCEDURE p_costcenter_blo  (   p_tip           VARCHAR2,
                                p_row IN OUT    COSTCENTER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    IUD for COSTCENTER
----------------------------------------------------------------------------------
IS
    v_org_myself    VARCHAR2(30);
BEGIN

    v_org_myself    :=  Pkg_Nomenc.f_get_myself_org;
    IF p_row.flag_intern = 'Y' AND p_row.org_code <> v_org_myself THEN
        Pkg_App_Tools.P_Log('M','Centrul de cost este INTERN, dar are setata locatie EXTERNA !','Inconsistente');
    END IF;
    IF p_row.flag_intern = 'N' AND p_row.org_code = v_org_myself THEN
        Pkg_App_Tools.P_Log('M','Centrul de cost este EXTERN, dar are setata locatie '||v_org_myself||'!','Inconsistente');
    END IF;

    Pkg_Lib.p_rae_m('B');

    p_row.org_code      :=  NVL(p_row.org_code, v_org_myself);
    p_row.flag_intern   :=  NVL(p_row.flag_intern,'Y');


EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    17/03/2008  d   Create procedure
/*********************************************************************************/
PROCEDURE p_costcenter_iud  (   p_tip VARCHAR2, p_row COSTCENTER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    IUD for COSTCENTER
----------------------------------------------------------------------------------
IS
    v_row           COSTCENTER%ROWTYPE;
BEGIN

    v_row               :=  p_row;
    p_costcenter_blo    (p_tip, v_row);

    Pkg_Iud.p_costcenter_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    17/03/2008  d   Create procedure
/*********************************************************************************/
PROCEDURE p_workcenter_blo  (   p_tip           VARCHAR2,
                                p_row IN OUT    WORKCENTER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    BLO for WORKCENTER
----------------------------------------------------------------------------------
IS
    v_row_cc        COSTCENTER%ROWTYPE;

BEGIN

--    IF p_row.whs_code IS NULL THEN
    v_row_cc.costcenter_code    :=  p_row.costcenter_code;
    IF NOT Pkg_Get2.f_get_costcenter_2(v_row_cc) THEN
        Pkg_Lib.p_rae('Costcenter '||p_row.costcenter_code||' is not defined!');
    END IF;
    p_row.whs_code      :=  NVL(p_row.whs_code, Pkg_Order.f_get_default_whs_cons(v_row_cc.org_code));
--    Pkg_Lib.p_rae(v_row_cc.org_code||'##'||p_row.whs_code||'$$');


EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    17/03/2008  d   Create procedure
/*********************************************************************************/
PROCEDURE p_workcenter_iud  (   p_tip VARCHAR2, p_row WORKCENTER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    IUD for WORKCENTER
----------------------------------------------------------------------------------
IS
    v_row       WORKCENTER%ROWTYPE;
BEGIN

    v_row               :=  p_row;
    p_workcenter_blo    (   p_tip, v_row);

    Pkg_Iud.p_workcenter_iud(p_tip, v_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    17/03/2008  d   Create procedure
/*********************************************************************************/
PROCEDURE p_workcenter_oper_iud  (   p_tip VARCHAR2, p_row WORKCENTER_OPER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    IUD for WORKCENTER
----------------------------------------------------------------------------------
IS
BEGIN

    Pkg_Iud.p_workcenter_oper_iud(p_tip, p_row);

    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    17/03/2008  d   Create procedure
/*********************************************************************************/
FUNCTION f_get_myself_org       RETURN VARCHAR2
-----------------------------------------------------------------------------------
--  PURPOSE:    return the ORG_CODE for the organization that has the MYSELF flag set
--              (it should be only one )
-----------------------------------------------------------------------------------
IS
    CURSOR C_ORG        IS
                        SELECT      org_code
                        FROM        ORGANIZATION
                        WHERE       flag_myself     =   'Y'
                        ;

    v_rez               VARCHAR2(30);
BEGIN
    OPEN C_ORG;FETCH C_ORG INTO v_rez; CLOSE C_ORG;
    RETURN v_rez;
END;


/************************************************************************************************
    DDL: 17/03/2008  d Create procedure
/************************************************************************************************/
FUNCTION f_sql_workcenter_oper  (   p_workcenter_code   VARCHAR2)  RETURN typ_frm  pipelined
-------------------------------------------------------------------------------------------------
--  PURPOSE:      RECORDSOURCE for WORKCENTER form
------------------------------------------------------------------------------------------------
IS
    CURSOR C_LINES      (   p_workcenter_code    VARCHAR2)
                        IS
                        SELECT      w.*
                        -------------------------------------------------------------------------
                        FROM        WORKCENTER_OPER     w
                        -------------------------------------------------------------------------
                        WHERE       w.workcenter_code   =   p_workcenter_code
                        ;

    v_row               tmp_frm             :=  tmp_frm();

BEGIN

    FOR x IN C_LINES(p_workcenter_code) LOOP
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;

        v_row.txt01         :=  x.workcenter_code;
        v_row.txt02         :=  x.oper_code;
        v_row.txt03         :=  '';

        pipe ROW(v_row);
    END LOOP;

    RETURN;

EXCEPTION WHEN OTHERS THEN
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:18/03/2008  z Create procedure
        13/07/2008  d added SI fields 
/*********************************************************************************/
FUNCTION f_sql_primary_uom  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the PRIMARY_UOM
----------------------------------------------------------------------------------
    CURSOR C_LINES  IS
                    SELECT      m.*
                    FROM        PRIMARY_UOM     m
                    ORDER BY    m.puom ASC
                    ;
    
    v_row           tmp_frm     :=  tmp_frm();
    
BEGIN
    
    FOR x IN C_LINES 
    LOOP
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;

        v_row.txt01         :=  x.puom;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.si_uom;
        v_row.txt04         :=  x.flag_si;
        v_row.numb01        :=  x.si_conversion;

        pipe ROW(v_row);
    END LOOP;

    RETURN;

EXCEPTION WHEN OTHERS THEN
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_item_size  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the ITEM_SIZE
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*
                FROM    ITEM_SIZE m
                ORDER BY m.size_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.size_code;
        v_row.txt02         :=  x.description;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_cat_mat_type  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the ITEM_SIZE
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*
                FROM    CAT_MAT_TYPE m
                ORDER BY m.flag_virtual,m.categ_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.categ_code;
        v_row.txt02         :=  x.whs_stock;
        v_row.txt03         :=  x.oper_code;
        v_row.txt04         :=  x.CATEGORY;
        v_row.txt05         :=  x.fifo_round_unit;
        v_row.txt06         :=  x.flag_virtual;
        
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_colour(p_org_code VARCHAR2)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the COLOUR
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES(p_org_code VARCHAR2)    IS
                SELECT  m.*
                FROM    COLOUR m
                WHERE   org_code    =   p_org_code
                ORDER BY m.colour_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_org_code IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Nu ati precizat clientul '
                                    ||' !!!',
             p_err_detail        => NULL ,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_org_code) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.colour_code;
        v_row.txt03         :=  x.description;
        v_row.txt04         :=  x.CATEGORY;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_operation  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the COLOUR
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*
                FROM    OPERATION m
                ORDER BY m.oper_seq ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.oper_code;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.oper_seq;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_work_season(p_org_code VARCHAR2)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the COLOUR
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES(p_org_code VARCHAR2)    IS
                SELECT  m.*
                FROM    WORK_SEASON m
                WHERE   org_code    =   p_org_code
                ORDER BY m.season_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_org_code IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Nu ati precizat clientul '
                                    ||' !!!',
             p_err_detail        => NULL ,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_org_code) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.season_code;
        v_row.txt03         :=  x.description;
        v_row.txt04         :=  x.flag_active;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_custom  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the COLOUR
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS
                SELECT  m.*
                FROM    CUSTOM m
                ORDER BY m.custom_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    FOR x IN C_LINES LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.custom_code;
        v_row.txt02         :=  x.description;
        v_row.txt03         :=  x.supl_um;
        v_row.txt04         :=  x.description_it;
        
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_sales_family(p_org_code VARCHAR2)  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the COLOUR
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES(p_org_code VARCHAR2)    IS
                SELECT  m.*
                FROM    SALES_FAMILY m
                WHERE   m.org_code      =   p_org_code
                ORDER BY m.family_code ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_org_code IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Nu ati precizat clientul '
                                    ||' !!!',
             p_err_detail        => NULL ,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_org_code) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.family_code;
        v_row.txt03         :=  x.description;
        v_row.txt04         :=  x.custom_code;
        
        v_row.numb01        :=  x.weight_net;
        --
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_primary_uom_iud(p_tip VARCHAR2, p_row PRIMARY_UOM%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CALENDAR when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               PRIMARY_UOM%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Nomenc.p_primary_uom_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_primary_uom_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 20/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_primary_uom_blo(p_tip VARCHAR2, p_row IN OUT PRIMARY_UOM%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    v_row_old   PRIMARY_UOM%ROWTYPE;       

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        --
        IF p_row.puom IS NULL THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '00' ,
                 p_err_header        => 'Nu ati precizat codul unitatii de masura '
                                        ||' !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;

    END;


BEGIN

    IF p_tip = 'U' THEN
        v_row_old.idriga    :=  p_row.idriga;
        Pkg_Get.p_get_primary_uom(v_row_old);
    END IF;

    Pkg_App_Secur.p_test_table_iud  (   p_tip       =>  p_tip, 
                                        p_table     =>  'PRIMARY_UOM', 
                                        p_mod_col   =>  Pkg_Mod_Col.f_primary_uom(v_row_old,p_row));

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --
        WHEN    'U' THEN
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_item_size_iud(p_tip VARCHAR2, p_row ITEM_SIZE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CALENDAR when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               ITEM_SIZE%ROWTYPE;
BEGIN

    -- ONLY APP admins 
    Pkg_App_Secur.p_test_grant('APP_ADMIN');

    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Nomenc.p_item_size_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_item_size_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 20/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_item_size_blo(p_tip VARCHAR2, p_row IN OUT ITEM_SIZE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS

    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        --
        IF p_row.size_code IS NULL THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '00' ,
                 p_err_header        => 'Nu ati precizat codul marimii '
                                        ||' !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );
        END IF;

    END;
    ---------------------------------------------------------------------------
BEGIN

    CASE    p_tip
        WHEN    'I' THEN
                --
                p_check_integrity();
                --
        WHEN    'U' THEN
                --
                p_check_integrity();
                --
        WHEN    'D' THEN
                NULL;
    END CASE;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_cat_mat_type_iud(p_tip VARCHAR2, p_row CAT_MAT_TYPE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CALENDAR when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               CAT_MAT_TYPE%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    --Pkg_Receipt.p_cat_mat_type_iud(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_cat_mat_type_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_colour_iud(p_tip VARCHAR2, p_row COLOUR%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CALENDAR when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row               COLOUR%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    --Pkg_Receipt.p_colour_iud(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_colour_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    18/03/2008  z   Create procedure
            18/11/2008  d   Security + reformat code 
/*********************************************************************************/
PROCEDURE p_operation_iud(p_tip VARCHAR2, p_row OPERATION%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    IUD procedure for OPERATION table 
----------------------------------------------------------------------------------
IS
    v_row               OPERATION%ROWTYPE;
BEGIN

    -- only APP administrator can do this 
    Pkg_App_Secur.p_test_grant('APP_ADMIN');

    v_row   :=  p_row;

    Pkg_Iud.p_operation_iud(p_tip, v_row);

    COMMIT;
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Err.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_work_season_iud(p_tip VARCHAR2, p_row WORK_SEASON%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CALENDAR when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row              WORK_SEASON%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    --Pkg_Receipt.p_work_season_iud(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_work_season_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_custom_iud(p_tip VARCHAR2, p_row CUSTOM%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CALENDAR when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row              CUSTOM%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    --Pkg_Receipt.p_custom_iud(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_custom_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 18/03/2008  z Create procedure
/*********************************************************************************/
PROCEDURE p_sales_family_iud(p_tip VARCHAR2, p_row SALES_FAMILY%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in CALENDAR when is created , updated, deleted
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
IS
    v_row              SALES_FAMILY%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    --Pkg_Receipt.p_sales_family_iud(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_sales_family_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL: 12/04/2008  z Create procedure
/*********************************************************************************/
FUNCTION f_sql_multi_table(     
                                p_line_id       INTEGER , 
                                p_table_name    VARCHAR2 DEFAULT NULL
                          )  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the COLOUR
--
--  PREREQ:
--
--  INPUT:
----------------------------------------------------------------------------------
    CURSOR     C_LINES(p_line_id  INTEGER, p_table_name VARCHAR2)    IS
                SELECT  
                        h.idriga, h.dcn,
                        h.table_name, h.table_key, h.seq_no, 
                        h.description, h.flag_active                        
                -------------------
                FROM        MULTI_TABLE        h
                ----------------
                WHERE       h.table_name    =   p_table_name
                        AND p_line_id       IS      NULL
                ---------
                UNION ALL
                ---------
                SELECT  
                        h.idriga, h.dcn,
                        h.table_name, h.table_key, h.seq_no, 
                        h.description, h.flag_active                        
                -------------------
                FROM        MULTI_TABLE        h
                ----------------
                WHERE       h.idriga          =       p_line_id
                -------------
                ORDER BY seq_no ASC
                ;
    --
    v_row               tmp_frm             :=  tmp_frm();
    --
BEGIN
    --
    Pkg_Err.p_reset_error_message();
    --
    IF p_line_id IS NULL AND p_table_name IS NULL THEN
        Pkg_Err.p_set_error_message
        (    p_err_code          => '00' ,
             p_err_header        => 'Nu ati precizat tabelul '
                                    ||' !!!',
             p_err_detail        => NULL ,
             p_flag_immediate    => 'Y'
        );
    END IF;
    --
    FOR x IN C_LINES(p_line_id, p_table_name) LOOP
        --
        v_row.idriga        :=  x.idriga;
        v_row.dcn           :=  x.dcn;
        v_row.seq_no        :=  c_lines%rowcount;
        --
        v_row.txt01         :=  x.table_name;
        v_row.txt02         :=  x.table_key;
        v_row.txt03         :=  x.description;
        v_row.txt04         :=  x.flag_active;
        --
        v_row.numb01        :=  x.seq_no;
        
        pipe ROW(v_row);
    END LOOP;
    --
    RETURN;
    --
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

/*********************************************************************************
    DDL:    12/04/2008  z   Create procedure
            18/11/2208  d   Security 
/*********************************************************************************/
PROCEDURE p_multi_table_iud(p_tip VARCHAR2, p_row MULTI_TABLE%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    BLO for MULTI_TABLE 
----------------------------------------------------------------------------------
IS
    v_row               MULTI_TABLE%ROWTYPE;
BEGIN

    -- ONLY APP admins 
    Pkg_App_Secur.p_test_grant('APP_ADMIN');

    v_row   :=  p_row;
    Pkg_Iud.p_multi_table_iud(p_tip, v_row);
    
    COMMIT;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;











END;

/

/
