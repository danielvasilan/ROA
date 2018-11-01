--------------------------------------------------------
--  DDL for Package PKG_WEB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_WEB" 
AS

--FUNCTION f_xml_lov      (   p_sql           VARCHAR2) RETURN typ_frm pipelined;


--FUNCTION f_lov          (   p_frm_name      VARCHAR2, 
--                            p_ctl_name      VARCHAR2) RETURN typ_frm pipelined;


FUNCTION f_json_form        (   p_grid_name     VARCHAR2, 
                                p_parameters    VARCHAR2, 
                                p_flag_meta     VARCHAR2,
                                p_max_records   INTEGER,
                                p_start_record  INTEGER
                            )   RETURN          typ_longinfo    pipelined;

FUNCTION f_json_lov         (   p_sql           VARCHAR2
                            )   RETURN          typ_cmb         pipelined;

FUNCTION f_json_lov_filter  (   p_lov_ctl       VARCHAR2,
                                p_ref_frm       VARCHAR2
                            )   RETURN          typ_cmb         pipelined;

PROCEDURE p_ora2mysql       (   p_flag_data     VARCHAR2);


END;
 

/

/
