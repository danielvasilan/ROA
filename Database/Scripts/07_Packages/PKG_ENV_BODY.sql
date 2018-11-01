--------------------------------------------------------
--  DDL for Package Body PKG_ENV
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_ENV" 
IS


/*********************************************************************************
    DDL: 20/02/2008  z Create procedure 
/*********************************************************************************/
FUNCTION f_sql_app_doc_number  RETURN typ_frm  pipelined
IS
----------------------------------------------------------------------------------
--  PURPOSE:    it is row source to transfer to user ACCESS proccess the APP_DOC_NUMBER 
--               
--  PREREQ:     
--               
--  INPUT:         
----------------------------------------------------------------------------------
    CURSOR     C_LINES    IS 
                SELECT  h.*
                FROM    APP_DOC_NUMBER  h
                ORDER BY h.org_code,h.doc_type,h.doc_subtype,h.num_year         
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
        v_row.txt01         :=  x.org_code;
        v_row.txt02         :=  x.doc_type;
        v_row.txt03         :=  x.doc_subtype;
        v_row.txt04         :=  x.num_year;
        v_row.txt05         :=  x.num_prefix;
        v_row.txt06         :=  x.note;
        --
        v_row.numb01        :=  x.num_current;
        v_row.numb02        :=  x.num_start;
        v_row.numb03        :=  x.num_end;  
        v_row.numb04        :=  x.num_lenght;                

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
    DDL: 20/02/2008  z Create procedure 
/*********************************************************************************/
FUNCTION f_get_app_doc_number (
                                p_org_code      VARCHAR2,
                                p_doc_type      VARCHAR2,
                                p_doc_subtype   VARCHAR2,
                                p_num_year      VARCHAR2
                               ) RETURN VARCHAR2
----------------------------------------------------------------------------------
--  PURPOSE:    gets the next document number for an entity (movement header, work order etc) 
--              it locks the line when it reads the line to serialise 
--  PREREQ:     
--               
--  INPUT:      p_org_code      - the org code if it is managed separatelly on client 
--                              - if not it is given myself that is FTY
--              p_doc_type      - identifies the major entity (RECEIPT, etc)
--              p_doc_subtype   - identifies the subentity - for ex in case of movement
--              p_num_year      - the year of competence  
----------------------------------------------------------------------------------
IS
    CURSOR  C_LINES(
                     p_org_code      VARCHAR2,
                     p_doc_type      VARCHAR2,
                     p_doc_subtype   VARCHAR2,
                     p_num_year      VARCHAR2
                    )
                IS
                SELECT      *
                FROM        APP_DOC_NUMBER
                WHERE       org_code    =   p_org_code
                        AND doc_type    =   p_doc_type
                        AND doc_subtype =   p_doc_subtype
                        AND num_year    =   p_num_year
                FOR UPDATE
                ;            

                
                
                    
    v_row       APP_DOC_NUMBER%ROWTYPE; 
    v_found     BOOLEAN;                   
    v_result    VARCHAR2(32000);
    C_ALL       VARCHAR2(32000) :=  'ALL';                
BEGIN
    --
    OPEN    C_LINES (   p_org_code      =>  p_org_code      ,
                        p_doc_type      =>  p_doc_type      ,
                        p_doc_subtype   =>  p_doc_subtype   ,
                        p_num_year      =>  p_num_year
                    );
    FETCH   C_LINES INTO v_row;
    v_found :=  C_LINES%FOUND;
    CLOSE   C_LINES;
    --
    IF NOT v_found THEN
        OPEN    C_LINES (   p_org_code      =>  C_ALL           ,
                            p_doc_type      =>  p_doc_type      ,
                            p_doc_subtype   =>  p_doc_subtype   ,
                            p_num_year      =>  p_num_year
                        );
        FETCH   C_LINES INTO v_row;
        v_found :=  C_LINES%FOUND;
        CLOSE   C_LINES;
        
        IF NOT v_found THEN        
            -- if there is no setup line I give a message
            Pkg_Lib.p_rae(-20001,
                                'Nu exista numarator definit pentru '
                            ||  'ORG_CODE = '|| p_org_code||', '
                            ||  'DOC_TYPE = '|| p_doc_type||', '
                            ||  'DOC_SUBTYPE = '|| p_doc_subtype||', '
                            ||  'NUM_YEAR = '|| p_num_year
                          );    
        END IF;
    END IF;

    v_row.num_current    :=  v_row.num_current + 1;
    -- check if we are in the range
    IF NOT v_row.num_current BETWEEN v_row.num_start AND v_row.num_end THEN
       Pkg_Lib.p_rae(
                           'Numaratorul definit pentru '
                       ||  'ORG_CODE = '|| p_org_code||', '
                       ||  'DOC_TYPE = '|| p_doc_type||', '
                       ||  'DOC_SUBTYPE = '|| p_doc_subtype||', '
                       ||  'NUM_YEAR = '|| p_num_year || ' '
                       ||  ' a depasit scala alocata !!! '
                     );    
    END IF;
    --        
    v_result :=  v_row.num_prefix; 
    v_result :=  v_result || LPAD(v_row.num_current,v_row.num_lenght,'0');
    -- update the table
    Pkg_Iud.p_app_doc_number_iud('U',v_row);         
    --
    RETURN v_result;                 
    --                    
    EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;                               
/*********************************************************************************
    DDL: 20/03/2008  z Create procedure 
/*********************************************************************************/
PROCEDURE p_app_doc_number_iud(p_tip VARCHAR2, p_row APP_DOC_NUMBER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in APP_DOC_NUMBER when is created , updated, deleted
--               
--  PREREQ:     
--               
--  INPUT:         
----------------------------------------------------------------------------------
IS
    v_row               APP_DOC_NUMBER%ROWTYPE;
BEGIN
    Pkg_Err.p_reset_error_message();
    v_row   :=  p_row;
    Pkg_Env.p_app_doc_number_blo(p_tip, v_row);
    Pkg_Err.p_raise_error_message();
    Pkg_Iud.p_app_doc_number_iud(p_tip, v_row);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        Pkg_Err.p_dump_error_message();
        RAISE_APPLICATION_ERROR(-20001,Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;
/*********************************************************************************
    DDL: 20/03/2008  z Create procedure 
/*********************************************************************************/
PROCEDURE p_app_doc_number_blo(p_tip VARCHAR2, p_row IN OUT APP_DOC_NUMBER%ROWTYPE)
----------------------------------------------------------------------------------
--  PURPOSE:    manages the row in receipt_header when is created , updated, deleted
--               
--  PREREQ:     
--               
--  INPUT:         
----------------------------------------------------------------------------------
IS   
    C_ALL           VARCHAR2(32000) :=  'ALL';
    
    v_row_org       ORGANIZATION%ROWTYPE;
    
        
    --------------------------------------------------------------------------
    PROCEDURE p_check_integrity
    IS
    BEGIN
        --
        IF p_row.org_code IS NULL THEN
            Pkg_Err.p_set_error_message
            (    p_err_code          => '100' , 
                 p_err_header        => 'Nu ati precizat codul organizatiei '
                                        ||' !!!',
                 p_err_detail        => NULL ,
                 p_flag_immediate    => 'N'
            );                                                  
        END IF;
        --
        IF p_row.org_code <> C_ALL  THEN
            v_row_org.org_code  :=  p_row.org_code;
            Pkg_Check.p_chk_organization(v_row_org);        
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
    DDL: 29/09/2008  d Create function  
/*********************************************************************************/
FUNCTION f_get_picture_path (   p_org_code  VARCHAR2) RETURN VARCHAR2
----------------------------------------------------------------------------------
--  PURPOSE:    return the application path for item picture files 
----------------------------------------------------------------------------------
IS

    CURSOR C_PATH           IS
                            SELECT  description
                            FROM    MULTI_TABLE     m
                            WHERE   m.table_name    =   'SYSPAR'
                                AND m.table_key     =   'PICTURE_PATH'
                            ;

    v_path      VARCHAR2(1000);

BEGIN
    OPEN C_PATH; FETCH C_PATH INTO v_path; CLOSE C_PATH;
    IF p_org_code IS NOT NULL THEN 
        v_path  :=  v_path || p_org_code || '\';
    END IF;
    RETURN v_path;
END;












END;

/

/
