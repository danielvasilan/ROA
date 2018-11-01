--------------------------------------------------------
--  DDL for Package PKG_GLB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_GLB" 
IS

--patch 20060830
---- specificatii de tipuri ----------------------------------

TYPE typ_string             IS TABLE OF VARCHAR2(30000)                 INDEX BY BINARY_INTEGER;
TYPE typ_number             IS TABLE OF NUMBER                          INDEX BY BINARY_INTEGER;
TYPE typ_integer            IS TABLE OF INTEGER                         INDEX BY BINARY_INTEGER;
TYPE typ_data               IS TABLE OF DATE                            INDEX BY BINARY_INTEGER;
TYPE typ_rowid              IS TABLE OF ROWID                           INDEX BY BINARY_INTEGER;
TYPE typ_number_varchar     IS TABLE OF NUMBER                          INDEX BY VARCHAR2(32000);
TYPE typ_varchar_varchar    IS TABLE OF VARCHAR2(32700)                 INDEX BY VARCHAR2(32000);
TYPE typ_error_message_aux  IS TABLE OF VW_ERROR%ROWTYPE                INDEX BY BINARY_INTEGER;
TYPE typ_error_message      IS TABLE OF typ_error_message_aux           INDEX BY BINARY_INTEGER;
TYPE typ_general_varchar    IS TABLE OF TMP_GENERAL%ROWTYPE             INDEX BY VARCHAR2(32000);


SUBTYPE type_index          IS VARCHAR2(32000);


TYPE type_rdim              IS RECORD
                            (
                                d_1     VARCHAR2(100)   ,
                                d_2     VARCHAR2(100)   , 
                                d_3     VARCHAR2(100)   ,
                                d_4     VARCHAR2(100)   ,
                                d_5     VARCHAR2(100)   ,
                                d_6     VARCHAR2(100)   ,
                                d_7     VARCHAR2(100)   ,
                                d_8     VARCHAR2(100)   ,
                                d_9     VARCHAR2(100)   ,
                                d_10    VARCHAR2(100)   ,
                                val     NUMBER
                            );
                            
TYPE type_rdima             IS TABLE OF type_rdim                       INDEX BY BINARY_INTEGER;

TYPE type_dim_1             IS TABLE OF NUMBER                          INDEX BY VARCHAR2(100);
TYPE type_dim_2             IS TABLE OF type_dim_1                      INDEX BY VARCHAR2(100);
TYPE type_dim_3             IS TABLE OF type_dim_2                      INDEX BY VARCHAR2(100);
TYPE type_dim_4             IS TABLE OF type_dim_3                      INDEX BY VARCHAR2(100);
TYPE type_dim_5             IS TABLE OF type_dim_4                      INDEX BY VARCHAR2(100);
TYPE type_dim_6             IS TABLE OF type_dim_5                      INDEX BY VARCHAR2(100);
TYPE type_dim_7             IS TABLE OF type_dim_6                      INDEX BY VARCHAR2(100);
TYPE type_dim_8             IS TABLE OF type_dim_7                      INDEX BY VARCHAR2(100);
TYPE type_dim_9             IS TABLE OF type_dim_8                      INDEX BY VARCHAR2(100);
TYPE type_dim_10            IS TABLE OF type_dim_9                      INDEX BY VARCHAR2(100);

TYPE type_dim_1a            IS TABLE OF TMP_SEGMENT%ROWTYPE             INDEX BY VARCHAR2(100);
TYPE type_dim_2a            IS TABLE OF type_dim_1                      INDEX BY VARCHAR2(100);
TYPE type_dim_3a            IS TABLE OF type_dim_2                      INDEX BY VARCHAR2(100);
TYPE type_dim_4a            IS TABLE OF type_dim_3                      INDEX BY VARCHAR2(100);
TYPE type_dim_5a            IS TABLE OF type_dim_4                      INDEX BY VARCHAR2(100);
TYPE type_dim_6a            IS TABLE OF type_dim_5                      INDEX BY VARCHAR2(100);
TYPE type_dim_7a            IS TABLE OF type_dim_6                      INDEX BY VARCHAR2(100);
TYPE type_dim_8a            IS TABLE OF type_dim_7                      INDEX BY VARCHAR2(100);
TYPE type_dim_9a            IS TABLE OF type_dim_8                      INDEX BY VARCHAR2(100);
TYPE type_dim_10a           IS TABLE OF type_dim_9                      INDEX BY VARCHAR2(100);





-- for a two dimenzional parameter array
-- the 1 dimension is the major type of parameter = PAR_CODE
-- the 2 dimension is the major type of parameter = KEY_CODE

TYPE typ_parameter_1        IS TABLE OF PARAMETER%ROWTYPE               INDEX BY VARCHAR2(32000);
TYPE typ_parameter_2        IS TABLE OF typ_parameter_1                 INDEX BY VARCHAR2(32000);
it_par                      typ_parameter_2 ;

TYPE ref_cursor             IS REF CURSOR;


-- VARIABILE GLOBALE
-- pachet PKG_IUD
v_idriga                    INTEGER;
v_dcn                       INTEGER;
gv_string                   VARCHAR2(2000);

--variabile INDEX BY TABLE --------------------------------------------------
it_txt01                    typ_string;
it_txt02                    typ_string;
it_txt03                    typ_string;
it_txt04                    typ_string;
it_txt05                    typ_string;
it_txt06                    typ_string;
it_txt07                    typ_string;
it_txt08                    typ_string;
it_txt09                    typ_string;

it_numb01                   typ_number;
it_numb02                   typ_number;
it_numb03                   typ_number;
it_numb04                   typ_number;
it_numb05                   typ_number;
it_numb06                   typ_number;
it_numb07                   typ_number;
it_numb08                   typ_number;
it_numb09                   typ_number;

it_int01                    typ_integer;
it_int02                    typ_integer;
it_int03                    typ_integer;
it_int04                    typ_integer;
it_int05                    typ_integer;

--------------------------------------------------------------------------
v_g_txt01               VARCHAR2(32000);
v_idx                   PLS_INTEGER:=(0);
----
C_DATA_FORMAT           CONSTANT VARCHAR2(10) :='DD-MM-YYYY';
C_TIME_FORMAT           CONSTANT VARCHAR2(5) :='HH.MI';
--
faudit                  INTEGER;
--
C_NL                    CONSTANT VARCHAR2(2) := CHR(13)||CHR(10);
C_LF                    CONSTANT VARCHAR2(2) := CHR(10);


C_RN                    CONSTANT VARCHAR2(5) := '@#$()';
C_PAST                  CONSTANT DATE := TO_DATE('19000101','YYYYMMDD');
C_FUTURE                CONSTANT DATE := TO_DATE('29990101','YYYYMMDD');

---------------------------------------------------------------------------


C_SIZE_MIN              CONSTANT    WO_DETAIL.size_code%TYPE        :=   '00';
C_SIZE_MAX              CONSTANT    WO_DETAIL.size_code%TYPE        :=   '99';
C_NULL_DATE             CONSTANT    DATE                            :=   TO_DATE('01011900','ddmmyyyy');
C_NULL_CHAR             CONSTANT    VARCHAR2(1)                     :=   '-';
C_HALF_SIZE             CONSTANT    VARCHAR2(1)                     :=   CHR(189);


----new development ---------------------------------
C_MYSELF                CONSTANT    VARCHAR2(10)                :=   'ROA';
C_MY_CURRENCY           CONSTANT    VARCHAR2(10)                :=   'RON';              


--  warehouse categories
C_WHS_CTL           CONSTANT    VARCHAR2(100)       :=  'CTL';
C_WHS_INV           CONSTANT    VARCHAR2(100)       :=  'INV';
C_WHS_MPC           CONSTANT    VARCHAR2(100)       :=  'MPC';
C_WHS_MPP           CONSTANT    VARCHAR2(100)       :=  'MPP';
C_WHS_PAT           CONSTANT    VARCHAR2(100)       :=  'PAT';
C_WHS_WIP           CONSTANT    VARCHAR2(100)       :=  'WIP';
C_WHS_SHP           CONSTANT    VARCHAR2(100)       :=  'SHP';

-- movement types
C_TRN_ALC_ORD       CONSTANT    VARCHAR2(100)       :=  'ALC_ORD';
C_TRN_INT_STC       CONSTANT    VARCHAR2(100)       :=  'INT_STC';
C_TRN_INV_STC       CONSTANT    VARCHAR2(100)       :=  'INV_STC';
C_TRN_PROD          CONSTANT    VARCHAR2(100)       :=  'PROD';
C_TRN_REC_CTL       CONSTANT    VARCHAR2(100)       :=  'REC_CTL';
C_TRN_REC_CUST      CONSTANT    VARCHAR2(100)       :=  'REC_CUST';
C_TRN_REC_PATR      CONSTANT    VARCHAR2(100)       :=  'REC_PATR';
C_TRN_REM_ORD       CONSTANT    VARCHAR2(100)       :=  'REM_ORD';
C_TRN_SHP_CTL       CONSTANT    VARCHAR2(100)       :=  'SHP_CTL';
C_TRN_SHP_CUST      CONSTANT    VARCHAR2(100)       :=  'SHP_CUST';
C_TRN_SHP_PROP      CONSTANT    VARCHAR2(100)       :=  'SHP_PROP';
C_TRN_SHP_PRD       CONSTANT    VARCHAR2(100)       :=  'SHP_PRD';
C_TRN_TRN_CNS       CONSTANT    VARCHAR2(100)       :=  'TRN_CNS';
C_TRN_TRN_FIN       CONSTANT    VARCHAR2(100)       :=  'TRN_FIN';
C_TRN_TRN_RET       CONSTANT    VARCHAR2(100)       :=  'TRN_RET';
C_TRN_TRN_SEA       CONSTANT    VARCHAR2(100)       :=  'TRN_SEA';
C_TRN_TRN_GEN       CONSTANT    VARCHAR2(100)       :=  'TRN_GEN';
C_TRN_TRN_TRN       CONSTANT    VARCHAR2(100)       :=  'TRN_TRN';

-- 2008.06.11 - z accounting document types
C_AC_NIR            CONSTANT    VARCHAR2(100)       :=  'NIR';
C_AC_BC             CONSTANT    VARCHAR2(100)       :=  'BC';
C_AC_RET            CONSTANT    VARCHAR2(100)       :=  'RET';
C_AC_TRN            CONSTANT    VARCHAR2(100)       :=  'TRN';





-- reason type
C_P_IINICUST        VARCHAR2(32000)     :=  '+IINICUST';   --Initializare stoc LOHN
C_P_IINIPATR        VARCHAR2(32000)     :=  '+IINIPATR';  --Initializare stoc PATRIMONIU
C_P_IINVCUST        VARCHAR2(32000)     :=  '+IINVCUST';   --Corectie in plus material LOHN
C_P_IINVPATR        VARCHAR2(32000)     :=  '+IINVPATR';   --Corectie in plus material PATRIMONIU
C_P_IPRDSP          VARCHAR2(32000)     :=  '+IPRDSP' ;  --Intrare semifabricat in faza curenta
C_P_IRECCUST        VARCHAR2(32000)     :=  '+IRECCUST';   --Receptie materie prima LOHN
C_P_IRECPATR        VARCHAR2(32000)     :=  '+IRECPATR';   --Receptie material in PATRIMONIU
C_P_TALCMF          VARCHAR2(32000)     :=  '+TALCMF' ;  --Dezalocare de pe comanda si pus pe liber
C_P_TALCMO          VARCHAR2(32000)     :=  '+TALCMO' ;  --Alocare pe comanda din stoc liber
C_P_IAUXPATR        VARCHAR2(32000)     :=  '+IAUXPATR';   --Retur in magazie mater PATRIMONIU - auxiliar
C_P_TFINPF          VARCHAR2(32000)     :=  '+TFINPF';   --Versamento produs final in magazie PF
C_P_TFINSP          VARCHAR2(32000)     :=  '+TFINSP';   --Versamento fortat semiprocesat in mag PF
C_P_TRECCTLMF       VARCHAR2(32000)     :=  '+TRECCTLMF';   --Retur din CTL material
C_P_TRECCTLSP       VARCHAR2(32000)     :=  '+TRECCTLSP';   --Receptie din CTL PROCESATE
C_P_TRETCUST        VARCHAR2(32000)     :=  '+TRETCUST';   --Retur din WIP materie prima LOHN
C_P_TRETPATR        VARCHAR2(32000)     :=  '+TRETPATR';   --Retur din WIP matereie prima PATRIMONIU
C_P_TSEA            VARCHAR2(32000)     :=  '+TSEA';   --Incarcare pe o alta stagiune
C_P_TSHPCTLMF       VARCHAR2(32000)     :=  '+TSHPCTLMF';   --Exped in CTL, incarcare in stoc liber (nealocat)
C_P_TSHPCTLMO       VARCHAR2(32000)     :=  '+TSHPCTLMO';   --Exped in CTL, incarcare pe comanda (alocat)
C_P_TSHPCTLAO       VARCHAR2(32000)     :=  '+TSHPCTLAO';   --Exped in CTL, deja alocat
C_P_TSHPCTLSP       VARCHAR2(32000)     :=  '+TSHPCTLSP';   --Exped in CTL, deja alocat
C_P_TWIPMF          VARCHAR2(32000)     :=  '+TWIPMF';      --Transfer in WIP in stoc liber
C_P_TWIPMO          VARCHAR2(32000)     :=  '+TWIPMO';      --Transfer in WIP alocat pe comanda
C_P_TWIPAO          VARCHAR2(32000)     :=  '+TWIPAO';      --Transfer in WIP alocat pe comanda
C_P_TTRAN           VARCHAR2(32000)     :=  '+TTRAN';       -- Transfer liber intra-organizatie 
C_M_OAUXPATR        VARCHAR2(32000)     :=  '-OAUXPATR';   --Consum materie PATRIMONIU auxiliare
C_M_OCTLAUX         VARCHAR2(32000)     :=  '-OCTLAUX';   --Consum materie PATRIMONIU auxiliare catre CTL
C_M_OINVCUST        VARCHAR2(32000)     :=  '-OINVCUST';   --Corectie in minus material LOHN
C_M_OINVPATR        VARCHAR2(32000)     :=  '-OINVPATR';   --Corectie in minus material PATRIMONIU
C_M_OPRDMP          VARCHAR2(32000)     :=  '-OPRDMP';   --Consum materie prima PRODUCTIE
C_M_OPRDSP          VARCHAR2(32000)     :=  '-OPRDSP';   --Consum semifabricat PRODUCTIE
C_M_OSHPMP          VARCHAR2(32000)     :=  '-OSHPMP';   --Expeditie client materie prima LOHN
C_M_OSHPMPP         VARCHAR2(32000)     :=  '-OSHPMPP';   --Expeditie furnizor materie prima proprietate (retur) 
C_M_OSHPPF          VARCHAR2(32000)     :=  '-OSHPPF';   --VANZARE articol procesat la client
C_M_TALCMF          VARCHAR2(32000)     :=  '-TALCMF';   --Iesire de pe stoc liber si allocare pe comanda
C_M_TALCMO          VARCHAR2(32000)     :=  '-TALCMO';   --Dezalocare e pe comanda si pus pe liber
C_M_TFINPF          VARCHAR2(32000)     :=  '-TFINPF';   --Versamento produs FINIT iesire din WIP
C_M_TFINSP          VARCHAR2(32000)     :=  '-TFINSP';   --Versamento fortat semiprocesat iesire din WIP
C_M_TRECCTLMF       VARCHAR2(32000)     :=  '-TRECCTLMF';   --Iesire din CTL material de pe stoc liber
C_M_TRECCTLMO       VARCHAR2(32000)     :=  '-TRECCTLMO';   --Iesire din CTL material din alocat
C_M_TRECCTLSP       VARCHAR2(32000)     :=  '-TRECCTLSP';   --Iesire din CTL articol procesat
C_M_TRETMF          VARCHAR2(32000)     :=  '-TRETMF';      --Transfer din WIP in magazie din stoc liber
C_M_TRETMO          VARCHAR2(32000)     :=  '-TRETMO';      --Transfer din WIP in magazie de pe alocat
C_M_TSEA            VARCHAR2(32000)     :=  '-TSEA';        --Scaderea de pe o stagiune
C_M_TSHPCTLCUST     VARCHAR2(32000)     :=  '-TSHPCTLCUST'; --Transfer in CTL material LOHN
C_M_TSHPCTLPATR     VARCHAR2(32000)     :=  '-TSHPCTLPATR'; --Transfer in CTL material PATRIMONIU
C_M_TSHPCTLSP       VARCHAR2(32000)     :=  '-TSHPCTLSP';   --Exped in CTL semiprocesate
C_M_TWIPCUST        VARCHAR2(32000)     :=  '-TWIPCUST';    --Transfer in WIP pentru consum materie LOHN
C_M_TWIPPATR        VARCHAR2(32000)     :=  '-TWIPPATR';    --Transfer in WIP pentru consum materie PATRIMONIU
C_M_TTRAN           VARCHAR2(32000)     :=  '-TTRAN';       -- Transfer liber intra-organizatie 

-- environment variables
gv_client_code                  VARCHAR2(10);
gv_sbu_code                     VARCHAR2(20);
gv_language_id                  VARCHAR2(2);
gv_user_code                    VARCHAR2(20);

-- all purpose variable
gv_string                       VARCHAR2(2000);

-- flags
gv_flag_audit                   INTEGER    := 0;
gv_flag_debug                   BOOLEAN    := TRUE;

v_modified_columns              VARCHAR2(1000);

C_WHS_TRN_ROUND                 CONSTANT    INTEGER :=  2; 

v_curr_pkg_code                 VARCHAR2(30);
v_curr_ship_code                VARCHAR2(30);
v_pkg_pwd                       VARCHAR2(200); -- password for package detail modifications 

END;

/

/
