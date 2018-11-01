--------------------------------------------------------
--  DDL for Package PKG_SYS_CHECK
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_SYS_CHECK" 
IS
    -- for a receipt or a shipment we must have only 1 line with flag_storno = N in WHS_TRN


    CURSOR C_CHK_REASON_SIGN
    IS
    SELECT      d.*
    FROM        WHS_TRN_DETAIL d
    INNER JOIN  WHS_TRN t ON t.idriga = d.ref_trn
    WHERE       d.reason_code LIKE '-%'
        AND     d.trn_sign = 1
        AND     t.flag_storno = 'N'
    UNION ALL
        SELECT      d.*
    FROM        WHS_TRN_DETAIL d
    INNER JOIN  WHS_TRN t ON t.idriga = d.ref_trn
    WHERE       d.reason_code LIKE '+%'
        AND     d.trn_sign = -1
        AND     t.flag_storno = 'N'
    ;


END;
 

/

/
