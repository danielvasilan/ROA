--------------------------------------------------------
--  DDL for Package PKG_PO
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_PO" 
AS

-- SQL functions 
FUNCTION f_sql_po_ord_header            (   p_line_id           NUMBER,
                                            p_suppl_code        VARCHAR2
                                        )   RETURN              typ_frm     pipelined;

FUNCTION f_sql_po_ord_line              (   p_line_id           NUMBER,
                                            p_ref_po            NUMBER
                                        )   RETURN              typ_frm     pipelined;

PROCEDURE p_po_ord_header_iud           (   p_tip               VARCHAR2, 
                                            p_row               PO_ORD_HEADER%ROWTYPE);
                                            
PROCEDURE p_po_ord_line_iud             (   p_tip               VARCHAR2, 
                                            p_row               PO_ORD_LINE%ROWTYPE);

PROCEDURE p_rep_po_order                (   p_idriga            NUMBER);

                                            
END;
 

/

/
