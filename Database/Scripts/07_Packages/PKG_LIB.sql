--------------------------------------------------------
--  DDL for Package PKG_LIB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_LIB" 
IS





FUNCTION  f_read_pk                         RETURN INTEGER;
PROCEDURE p_set_pk                          (p_idriga INTEGER);
FUNCTION  f_read_dcn                        RETURN INTEGER;







FUNCTION f_normalise                        (p_token  VARCHAR2) RETURN VARCHAR2;

PROCEDURE   p_locking_service               (p_lock_code VARCHAR2);
PROCEDURE   p_set_locking                   (p_lock_code VARCHAR2);
PROCEDURE   p_reset_locking                 (p_lock_code VARCHAR2);

FUNCTION    f_instr                         (p_search VARCHAR2,p_what VARCHAR2) RETURN INTEGER;


PROCEDURE   p_rae                           (   p_message VARCHAR2);
PROCEDURE   p_rae                           (   p_errNo INTEGER, p_message VARCHAR2);
PROCEDURE   p_rae_m                         (   p_raise_type    VARCHAR2 := 'A');

FUNCTION    F_Sql_Inlist                   (p_inlist VARCHAR2,
                                            p_delim VARCHAR2 := NULL,
                                            p_null INTEGER := 0) RETURN typ_cmb;

FUNCTION    f_sql_session_info              RETURN typ_cmb pipelined;
FUNCTION    f_sql_taskuri                  (p_frm VARCHAR2) RETURN typ_frm pipelined;
FUNCTION    f_sql_taskuri2                  (p_frm VARCHAR2) RETURN typ_longinfo pipelined;

PROCEDURE   p_nl                            (p_string IN OUT VARCHAR2,p_number INTEGER DEFAULT 1);
PROCEDURE   p_add_line                      (p_string IN OUT VARCHAR2);
PROCEDURE   p_add_next                      (p_string IN OUT VARCHAR2, p_next VARCHAR2, p_length INTEGER DEFAULT 0);

FUNCTION    f_mod_n                         (p_old NUMBER,p_new NUMBER)         RETURN BOOLEAN;
FUNCTION    f_mod_d                         (p_old DATE,p_new DATE)             RETURN BOOLEAN;
FUNCTION    f_mod_c                         (p_old VARCHAR2,p_new VARCHAR2)     RETURN BOOLEAN;
FUNCTION    f_diff_c                        (p_1 VARCHAR2, p_2 VARCHAR2)        RETURN INTEGER;


FUNCTION    f_interval                       (p_low INTEGER, p_high INTEGER) RETURN typ_cmb;
PROCEDURE   p_set_environment                ;


FUNCTION    f_make_decimal_point            (p_number NUMBER) RETURN VARCHAR2;
FUNCTION    f_string_is_number              (p_number VARCHAR2) RETURN INTEGER;
FUNCTION    f_string_is_date                (p_date VARCHAR2) RETURN INTEGER;


FUNCTION f_str_idx                          (   p_par1  VARCHAR2 DEFAULT NULL,
                                                p_par2  VARCHAR2 DEFAULT NULL,
                                                p_par3  VARCHAR2 DEFAULT NULL,
                                                p_par4  VARCHAR2 DEFAULT NULL,
                                                p_par5  VARCHAR2 DEFAULT NULL,
                                                p_par6  VARCHAR2 DEFAULT NULL,
                                                p_par7  VARCHAR2 DEFAULT NULL,
                                                p_par8  VARCHAR2 DEFAULT NULL,
                                                p_par9  VARCHAR2 DEFAULT NULL,
                                                p_par10  VARCHAR2 DEFAULT NULL
                                            ) RETURN VARCHAR2;

PROCEDURE   p_load_app_parameters           (p_org_code VARCHAR2 );
PROCEDURE   p_parameter_iud                 (p_tip      VARCHAR2, p_row IN OUT PARAMETER%ROWTYPE);

FUNCTION F_Column_Other_Is_Modif            (p_column VARCHAR2) RETURN INTEGER;
FUNCTION F_Column_Is_Modif                  (p_column VARCHAR2) RETURN INTEGER;
FUNCTION F_Column_Other_Is_Modif2           (p_column VARCHAR2, p_mod_column VARCHAR2) RETURN INTEGER;
FUNCTION F_Column_Is_Modif2                 (p_column VARCHAR2, p_mod_column VARCHAR2) RETURN INTEGER;


FUNCTION  f_round                           (p_number NUMBER, p_decimals INTEGER) RETURN NUMBER;

FUNCTION  f_get_segment_from_string         (p_string VARCHAR2, p_separator VARCHAR2, p_segment INTEGER) RETURN VARCHAR2;

PROCEDURE p_increment_report_counter        (p_idriga INTEGER);
FUNCTION    f_get_dummy_sequence            RETURN INTEGER;


PROCEDURE who_called_me         (
                                    p_owner      OUT    VARCHAR2,
                                    p_name       OUT    VARCHAR2,
                                    p_lineno     OUT    NUMBER,
                                    p_caller_t   OUT    VARCHAR2 );

FUNCTION f_get_procedure_name   (
                                    p_pkg_name          VARCHAR2,
                                    p_current_line      INTEGER) RETURN VARCHAR2;


FUNCTION f_table_value  (   it_table        Pkg_Glb.typ_varchar_varchar,
                            p_idx           VARCHAR2,
                            pValueIfNull    VARCHAR2
                        )   RETURN          VARCHAR2;

FUNCTION f_table_value  (   it_table        Pkg_Glb.typ_number_varchar,
                            p_idx           VARCHAR2,
                            pValueIfNull    NUMBER
                        )   RETURN          NUMBER;

FUNCTION f_table_value  (   it_table        Pkg_Glb.typ_string,
                            p_idx           NUMBER,
                            pValueIfNull    VARCHAR2
                        )   RETURN          VARCHAR2;




PROCEDURE p_c                   (   old_value       VARCHAR2,   new_value   VARCHAR2,
                                    p_modif IN OUT  VARCHAR2,   p_colList   IN OUT VARCHAR2,
                                    p_colName       VARCHAR2
                                );

PROCEDURE p_n                   (   old_value       NUMBER,     new_value   NUMBER,
                                    p_modif IN OUT  VARCHAR2,   p_colList   IN OUT VARCHAR2,
                                    p_colName       VARCHAR2
                                );

PROCEDURE p_d                   (   old_value       DATE,       new_value   DATE,
                                    p_modif IN OUT  VARCHAR2,   p_colList   IN OUT VARCHAR2,
                                    p_colName       VARCHAR2
                                );
FUNCTION f_implode                          (   p_separator VARCHAR2,
                                                p_1         VARCHAR2,
                                                p_2         VARCHAR2 DEFAULT NULL,
                                                p_3         VARCHAR2 DEFAULT NULL,
                                                p_4         VARCHAR2 DEFAULT NULL,
                                                p_5         VARCHAR2 DEFAULT NULL,
                                                p_6         VARCHAR2 DEFAULT NULL,
                                                p_7         VARCHAR2 DEFAULT NULL,
                                                p_8         VARCHAR2 DEFAULT NULL,
                                                p_9         VARCHAR2 DEFAULT NULL,
                                                p_10        VARCHAR2 DEFAULT NULL
                                            )   RETURN VARCHAR2;


FUNCTION f_getAppParameter  (   p_parCode VARCHAR2, p_parKey VARCHAR2) RETURN VARCHAR2;


/* used for returning of different application's flags  or parameters */
FUNCTION  f_return_faudit        RETURN INTEGER;
FUNCTION  f_return_sbu_code      RETURN VARCHAR2;
FUNCTION  f_return_client_code   RETURN VARCHAR2;
FUNCTION  f_return_language_id   RETURN VARCHAR2;
FUNCTION  f_return_user_code     RETURN VARCHAR2;


PROCEDURE   p_load_mdim     (   p_it        IN OUT NOCOPY Pkg_Glb.type_dim_10,
                                p_number    NUMBER  ,
                                p_1         VARCHAR2    DEFAULT NULL,
                                p_2         VARCHAR2    DEFAULT NULL,
                                p_3         VARCHAR2    DEFAULT NULL,
                                p_4         VARCHAR2    DEFAULT NULL,
                                p_5         VARCHAR2    DEFAULT NULL,
                                p_6         VARCHAR2    DEFAULT NULL,
                                p_7         VARCHAR2    DEFAULT NULL,
                                p_8         VARCHAR2    DEFAULT NULL,
                                p_9         VARCHAR2    DEFAULT NULL,
                                p_10        VARCHAR2    DEFAULT NULL
                             );

FUNCTION   f_get_mdim      (   p_it        IN  Pkg_Glb.type_dim_10,
                                p_1         VARCHAR2    DEFAULT NULL,
                                p_2         VARCHAR2    DEFAULT NULL,
                                p_3         VARCHAR2    DEFAULT NULL,
                                p_4         VARCHAR2    DEFAULT NULL,
                                p_5         VARCHAR2    DEFAULT NULL,
                                p_6         VARCHAR2    DEFAULT NULL,
                                p_7         VARCHAR2    DEFAULT NULL,
                                p_8         VARCHAR2    DEFAULT NULL,
                                p_9         VARCHAR2    DEFAULT NULL,
                                p_10        VARCHAR2    DEFAULT NULL
                             ) RETURN NUMBER;

PROCEDURE   p_trav_mdim     (   p_it_in       IN OUT    NOCOPY      Pkg_Glb.type_dim_10,
                                p_it_out      OUT       NOCOPY      Pkg_Glb.type_rdima    
                            );
                             
                             
                             

FUNCTION f_rep_footer           RETURN      VARCHAR2;





END;
 

/

/
