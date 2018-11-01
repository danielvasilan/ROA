--------------------------------------------------------
--  DDL for Package Body PKG_STAGE_ROA
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_STAGE_ROA" 
AS 

FUNCTION f_get_rm_operation_for_phase (rm_phase varchar2) RETURN VARCHAR2
IS
BEGIN
    RETURN case rm_phase 
              when '1' then 'CROIT'
              when '3' then 'CUSUT'
              when '4' then 'TRAS'
              when '5' then 'TRAS'
              when '6' then 'AMBALAT'
              else 'FINIT'
          end;
END;

FUNCTION f_get_def_stg_itm (p_file_id number, p_org_code varchar2, p_make_buy varchar2) 
    RETURN STG_ITEM%ROWTYPE
IS
    v_row_itm_0 STG_ITEM%ROWTYPE;
BEGIN
    v_row_itm_0.file_id       :=  p_file_id;
    v_row_itm_0.stg_status    := 'N';
    v_row_itm_0.org_code      :=  p_org_code;
    v_row_itm_0.make_buy      :=  'A';
    v_row_itm_0.flag_range    :=  0;
    v_row_itm_0.flag_size     :=  0;
    v_row_itm_0.flag_colour   :=  0;
    v_row_itm_0.start_size    :=  NULL;
    v_row_itm_0.end_size      :=  NULL;
    v_row_itm_0.make_buy      := p_make_buy;
    IF p_make_buy = 'A' THEN
        v_row_itm_0.default_whs := 'MPLOHN';
    ELSE
        v_row_itm_0.default_whs := Pkg_Order.f_get_default_whs_fin(Pkg_Nomenc.f_get_myself_org());
    END IF;
    RETURN v_row_itm_0;
END;


PROCEDURE p_process_bom_alt  (   p_row_file STG_FILE_MANAGER%ROWTYPE)
IS
    CURSOR C_LINES  (p_sql VARCHAR2)
    IS
        SELECT txt01 fg_code, txt02 fg_desc, txt03 fg_uom, txt04 rm_code, txt05 rm_desc, txt06 rm_uom, 
              to_number(txt07) rm_unit_qty, txt08 rm_oper_code, txt09 rm_note, 
              to_number(txt10) rn
        FROM table(f_gen_parse(p_sql))
        where seq_no > 0;
 
    v_idx_bom       VARCHAR2(50);
    it_bom          Pkg_Rtype.tas_stg_bom_std;   -- stg_bom_std
    it_itm          Pkg_Rtype.tas_stg_item;      -- stg_item
    v_idx_itm       VARCHAR2(50);
    v_row_itm       STG_ITEM%ROWTYPE;
    it_line         Pkg_Glb.typ_string;
    it_fase         Pkg_Glb.typ_string;
    v_err           VARCHAR2(1000);
    v_found         BOOLEAN;
    v_test          PLS_INTEGER;
    it_exc          Pkg_Glb.typ_varchar_varchar;
    V_FLAG_RANGE    BOOLEAN;
    v_child_code    VARCHAR2(50);
    v_father_code   VARCHAR2(50);
    v_line_seq      number;
    v_qta_str       varchar2(250);
    v_itm_tpl       VARCHAR2(30);
    v_fam_code      sales_family.family_code%type;
    
    v_stmt_text     stg_parser.stmt_text%type;
BEGIN
    SELECT max(stmt_text) into v_stmt_text FROM STG_PARSER WHERE file_info = p_row_file.file_info and status = 'A';
  
    FOR x IN C_LINES(replace(v_stmt_text, '<<file_id>>', p_row_file.idriga))
    LOOP
    
        -- insert the FG item, if this is the first occurence in the current file
        IF x.rn = 1 THEN 
            v_idx_itm     := x.fg_code;
            
            v_row_itm.org_code      :=  p_row_file.org_code;
            v_row_itm.item_code     :=  Pkg_Stage.f_item_code(x.fg_code);
            v_row_itm.description   :=  x.fg_desc;
            v_row_itm.puom          :=  x.fg_uom;
            v_row_itm.make_buy      :=  'P';
            v_row_itm.flag_size     :=  -1;
            v_row_itm.flag_colour   :=  0;
            v_row_itm.flag_range    :=  0;
            v_row_itm.start_size    :=  NULL;
            v_row_itm.end_size      :=  NULL;
            v_row_itm.oper_code     :=  NULL;
            v_row_itm.file_id       :=  p_row_file.idriga;
 
            it_itm(v_idx_itm)       :=  v_row_itm;
        END IF;
    
        --      CHILD
        v_idx_itm       :=  Pkg_Stage.f_item_code(x.rm_code);
        IF NOT it_itm.EXISTS(v_idx_itm) THEN
            v_row_itm.org_code      :=  p_row_file.org_code;
            v_row_itm.item_code     :=  Pkg_Stage.f_item_code(x.rm_code);
            v_row_itm.description   :=  x.rm_desc;
            v_row_itm.puom          :=  x.rm_uom;
            v_row_itm.make_buy      :=  'A';
            v_row_itm.flag_colour   :=  0;
            v_row_itm.file_id       :=  p_row_file.idriga;
            v_row_itm.start_size    :=  NULL;
            v_row_itm.end_size      :=  NULL;
            v_row_itm.flag_range    :=  0;
            v_row_itm.flag_size     :=  0;
            v_row_itm.oper_code     :=  x.rm_oper_code;
            -- load in memory
            it_itm(v_idx_itm)       :=  v_row_itm;
        END IF;

        -- BOM record 
        v_idx_bom       :=  Pkg_Lib.f_implode('$', x.fg_code, x.rm_code);
 
        IF NOT it_bom.EXISTS(v_idx_bom) THEN
            it_bom(v_idx_bom).file_id       :=  p_row_file.idriga;
            it_bom(v_idx_bom).father_code   :=  Pkg_Stage.f_item_code(x.fg_code);
            it_bom(v_idx_bom).child_code    :=  Pkg_Stage.f_item_code(x.rm_code);
            it_bom(v_idx_bom).qta           :=  x.rm_unit_qty;
            it_bom(v_idx_bom).colour_code   :=  NULL;
            it_bom(v_idx_bom).oper_code     :=  x.rm_oper_code;
            it_bom(v_idx_bom).qta_std       :=  it_bom(v_idx_bom).qta;
            it_bom(v_idx_bom).org_code      :=  p_row_file.org_code;
            it_bom(v_idx_bom).uom           :=  x.rm_uom;
            it_bom(v_idx_bom).note          :=  x.rm_note;
        ELSE
            -- if the item is already loaded in memory 
            it_bom(v_idx_bom).qta       :=  it_bom(v_idx_bom).qta + x.rm_unit_qty;
            it_bom(v_idx_bom).qta_std   :=  it_bom(v_idx_bom).qta;
        END IF;
        
        -- post-processing for ROA
        IF SUBSTR(x.rm_desc, 1, 4) = 'F.DO' THEN
            v_itm_tpl := substr(x.rm_desc, 6, INSTR(x.rm_desc, ' ', 6)-6);
            it_itm(Pkg_Stage.f_item_code(x.fg_code)).description := NVL(v_itm_tpl, x.rm_desc);
        END IF;
        
        IF it_itm(Pkg_Stage.f_item_code(x.fg_code)).root_code IS NULL THEN
             SELECT
                CASE
                    WHEN UPPER(x.fg_desc) like '%TRONCHETTO%' THEN 'GHETE'
                    WHEN UPPER(x.fg_desc) like '%TRONCHETO%' THEN 'GHETE'
                    WHEN UPPER(x.fg_desc) like '%SCARPA%' THEN 'PANTOFI'
                    WHEN UPPER(x.fg_desc) like '%MOCASSINO%' THEN 'PANTOFI'
                    WHEN UPPER(x.fg_desc) like '%STIVALETTO%' THEN 'CIZME_M'    
                    WHEN UPPER(x.fg_desc) like '%STIVALE%' THEN 'CIZME_L'
                    WHEN UPPER(x.fg_desc) like '%SCARPONCINO%' THEN 'CIZME_S'
                    WHEN UPPER(x.fg_desc) like '%SANDALO%' THEN 'SANDALE'
                    WHEN UPPER(x.fg_desc) like '%CIABATTA%' THEN 'SANDALE'
                    WHEN UPPER(x.fg_desc) like '%SABOT%' THEN 'SABOT'
                    
                END
            INTO it_itm(Pkg_Stage.f_item_code(x.fg_code)).root_code 
            FROM DUAL;
        END IF;
/*
CIZME_L	Cizme lungi
CIZME_M	Cizme medii
CIZME_S	Cizme scurte
GHETE	Ghete
PANTOFI	Pantofi
SABOTI	Saboti
SANDALE	Sandale        
*/
    END LOOP;

    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert in STG_BOM
    -- !!! disabled for ROA till the EXP FIFO is tested for not loading noth from DISPMAT and BOM 
    -- enabled for RAG - since this new setup will use the BOM
    IF p_row_file.org_code <> 'ALT' THEN
        v_idx_bom   :=  it_bom.FIRST;
        WHILE v_idx_bom IS NOT NULL
        LOOP
            Pkg_Iud.p_stg_bom_std_iud('I', it_bom(v_idx_bom));
            v_idx_bom       :=  it_bom.NEXT(v_idx_bom);
        END LOOP;
    END IF;
END;

PROCEDURE p_process_wo_decl   ( p_row_file STG_FILE_MANAGER%ROWTYPE)
IS

    CURSOR C_LINES  (p_sql VARCHAR2)
        IS
        select txt01 FG_CODE, txt02 CUST_CODE, txt03 CUST_DESC, txt04 STR_PELLAME, txt05 STR_CARTELLINO, to_number(txt06) QTY,
            to_number(txt07) cart, txt08 str_marchi, txt09 decl_date
        from table(f_gen_parse(p_sql))
        where seq_no > 0;
        
    v_stmt_text     stg_parser.stmt_text%type;
    
    it_wo           Pkg_Rtype.ta_stg_work_order;
    v_idx_wo        INTEGER;

    it_decl         Pkg_Rtype.ta_stg_wo_decl;
    v_idx_decl      INTEGER;
 
    v_row_itm       STG_ITEM%ROWTYPE;
    it_itm          Pkg_Rtype.tas_stg_item;
    v_idx_itm       VARCHAR2(50);
 
    it_line         Pkg_Glb.typ_string;
    v_row_fil       STG_FILE_MANAGER%ROWTYPE;

    v_def_season    WORK_SEASON.SEASON_CODE%TYPE;

BEGIN
    SELECT max(stmt_text) into v_stmt_text FROM STG_PARSER WHERE file_info = 'PROD' and status = 'A';
    
    SELECT MAX(season_code) into v_def_season from WORK_SEASON WHERE org_code = p_row_file.org_code and flag_active = 'Y';
    
    --FOR x IN C_LINES(p_row_file.idriga)
    FOR x IN C_LINES(replace(v_stmt_text, '<<file_id>>', p_row_file.idriga))
    LOOP

        v_idx_wo                        :=  it_wo.COUNT;
 
        IF     NOT it_wo.EXISTS(v_idx_wo)
            OR Pkg_Lib.f_mod_c(it_wo(v_idx_wo).order_code, Pkg_Lib.f_table_value(it_line, 5, ''))
        THEN
 
            -- insert the ITEM , if not present in STG_ITEM
            v_idx_itm   :=    x.fg_code;
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                it_itm(v_idx_itm).org_code      :=  p_row_file.org_code;
                it_itm(v_idx_itm).item_code     :=  pkg_stage.f_item_code(x.fg_code);
                it_itm(v_idx_itm).description   :=  x.fg_code;
                it_itm(v_idx_itm).puom          :=  'PA';
                it_itm(v_idx_itm).make_buy      :=  'P';
                it_itm(v_idx_itm).flag_size     :=  -1;
                it_itm(v_idx_itm).flag_colour   :=  0;
                it_itm(v_idx_itm).flag_range    :=  0;
                it_itm(v_idx_itm).start_size    :=  NULL;
                it_itm(v_idx_itm).end_size      :=  NULL;
                it_itm(v_idx_itm).oper_code     :=  NULL;
                it_itm(v_idx_itm).default_whs   :=  'EXP';
                it_itm(v_idx_itm).file_id       :=  p_row_file.idriga;
            END IF;
 
        END IF;
 
        -- work order
        v_idx_wo                        :=  it_wo.COUNT + 1;
        it_wo(v_idx_wo).file_id         :=  p_row_file.idriga;
        it_wo(v_idx_wo).org_code        :=  p_row_file.org_code;
        it_wo(v_idx_wo).order_code      :=  x.str_cartellino;
        it_wo(v_idx_wo).item_code       :=  x.fg_code;
        it_wo(v_idx_wo).season_code     :=  v_def_season;
        it_wo(v_idx_wo).size_code       :=  Pkg_Stage.C_DEFAULT_SIZE;
        it_wo(v_idx_wo).qty             :=  x.qty;
        it_wo(v_idx_wo).client_lot      :=  x.str_marchi;
        it_wo(v_idx_wo).package_number  :=  x.cart;
        it_wo(v_idx_wo).client_code     :=  x.cust_code;
        it_wo(v_idx_wo).note            :=  x.str_pellame;
 
        v_idx_decl                          :=  it_decl.COUNT + 1;
        it_decl(v_idx_decl).file_id         :=  p_row_file.idriga;
        it_decl(v_idx_decl).stg_status      :=  'N';
        it_decl(v_idx_decl).org_code        :=  p_row_file.org_code;
        it_decl(v_idx_decl).wo_code         :=  x.str_cartellino;
        --it_decl(v_idx_decl).size_code       :=  Pkg_Stage.C_DEFAULT_SIZE;
        it_decl(v_idx_decl).qty             :=  x.qty;
        it_decl(v_idx_decl).package_number  :=  x.cart;
        IF p_row_file.file_info = 'PROD' THEN
            it_decl(v_idx_decl).operation       :=  'FINIT';
        ELSE
            it_decl(v_idx_decl).operation       :=  'SHIP';
        END IF;
        it_decl(v_idx_decl).decl_date       :=  x.decl_date;
 
    END LOOP;
 
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert int STG_WORK_ORDER
    IF it_wo.COUNT  > 0 THEN Pkg_Iud.p_stg_work_order_miud ('I', it_wo); END IF;

    -- insert int STG_WO_DECL
    IF it_decl.COUNT  > 0 THEN Pkg_Iud.p_stg_wo_decl_miud ('I', it_decl); END IF;

 
END;


PROCEDURE p_process_rec_ALT   (   p_row_file STG_FILE_MANAGER%ROWTYPE)
IS
    CURSOR C_LINES  (p_sql VARCHAR2)
        IS
        select to_date(txt01) doc_date, txt02 doc_num, txt03 rm_code, txt04 rm_desc, txt05 rm_uom, 
            to_number(txt06) rm_qty, to_number(txt07) rm_unit_price, txt08 line_seq, txt09 line_no 
        from table(f_gen_parse(p_sql))
        where seq_no > 0
        ;
 
    it_rec          Pkg_Rtype.ta_stg_receipt;
    v_idx_rec       INTEGER;
 
    v_def_season    work_season.season_code%TYPE;
    
    v_row_itm       STG_ITEM%ROWTYPE;
    it_itm          Pkg_Rtype.tas_stg_item;
    v_idx_itm       VARCHAR2(50);
 
    v_err           VARCHAR2(1000);
    v_item_code     ITEM.ITEM_CODE%TYPE;
    v_stmt_text     STG_PARSER.STMT_TEXT%TYPE;
    
BEGIN
    SELECT max(stmt_text) into v_stmt_text FROM STG_PARSER WHERE file_info = p_row_file.file_info and status = 'A';

    SELECT MAX(season_code) into v_def_season from WORK_SEASON WHERE org_code = p_row_file.org_code and flag_active = 'Y';
 
    FOR x IN C_LINES(replace(v_stmt_text, '<<file_id>>', p_row_file.idriga))
    LOOP
        IF x.rm_code IN ('.MAT', '.ADE', '.CAR') THEN
            -- try to get an ITEM with the same description. If not found, the line number is added as suffix
            SELECT NVL(MAX(item_code), x.rm_code||'.'||to_char(x.line_no)) INTO v_item_code 
            FROM ITEM 
            WHERE description = x.rm_desc AND org_code = p_row_file.org_code;
        ELSE
            v_item_code := Pkg_Stage.f_item_code(x.rm_code);
        END IF;
        
        -- insert the ITEM , if not present in STG_ITEM 
        v_idx_itm   :=    v_item_code;
        IF NOT it_itm.EXISTS(v_idx_itm) THEN
            it_itm(v_idx_itm).file_id       :=  p_row_file.idriga;
            it_itm(v_idx_itm).stg_status    :=  'N';
            it_itm(v_idx_itm).org_code      :=  p_row_file.org_code;
            it_itm(v_idx_itm).description   :=  x.rm_desc;
            it_itm(v_idx_itm).puom          :=  x.rm_uom;
            it_itm(v_idx_itm).make_buy      :=  'A';
            it_itm(v_idx_itm).flag_range    :=  0;
            it_itm(v_idx_itm).flag_size     :=  0;
            it_itm(v_idx_itm).flag_colour   :=  0;
            it_itm(v_idx_itm).start_size    :=  NULL;
            it_itm(v_idx_itm).end_size      :=  NULL;
            it_itm(v_idx_itm).oper_code     :=  NULL;
            it_itm(v_idx_itm).default_whs   :=  'MPLOHN';
            it_itm(v_idx_itm).item_code     :=  v_item_code;
        END IF;

        -- RECEIPT DATA
        v_idx_rec                           :=  it_rec.COUNT + 1;
        it_rec(v_idx_rec).file_id           :=  p_row_file.idriga;
        it_rec(v_idx_rec).stg_status        :=  'N';
        it_rec(v_idx_rec).org_code          :=  p_row_file.org_code;
        it_rec(v_idx_rec).receipt_type      :=  'ME1';
        it_rec(v_idx_rec).doc_number        :=  x.doc_num;
        it_rec(v_idx_rec).doc_date          :=  x.doc_date;
        it_rec(v_idx_rec).currency_code     :=  'EUR';
        it_rec(v_idx_rec).country_from      :=  'IT';
        it_rec(v_idx_rec).line_no           :=  x.line_no;
        it_rec(v_idx_rec).item_code         :=  v_item_code;
        it_rec(v_idx_rec).season_code       :=  v_def_season;
        it_rec(v_idx_rec).colour_code       :=  NULL;
        it_rec(v_idx_rec).oper_code_item    :=  NULL;
        it_rec(v_idx_rec).uom_receipt       :=  it_itm(v_item_code).puom;

        it_rec(v_idx_rec).qty_doc           :=  x.rm_qty;
        it_rec(v_idx_rec).unit_price        :=  x.rm_unit_price;
      
    END LOOP;
 
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
 
    -- insert int STG_WORK_ORDER
    IF it_rec.COUNT  > 0 THEN
        Pkg_Iud.p_stg_receipt_miud ('I', it_rec); 
    END IF;

END;

PROCEDURE p_process_ship_fifo(  p_row_file STG_FILE_MANAGER%ROWTYPE)
IS
    CURSOR C_LINES(p_sql VARCHAR2)
        is
        select txt01 item_code, txt02 item_desc, txt03 rm_phase, txt04 item_uom, to_number(txt05) qty, to_date(txt06) ship_date
        from table(f_gen_parse(p_sql))
        where seq_no > 0
        ;

    v_row_itm     STG_ITEM%ROWTYPE;
    v_row_itm_0   STG_ITEM%ROWTYPE;
    it_itm        Pkg_Rtype.tas_stg_item;
    v_idx_itm     VARCHAR2(50);
    v_item_code     ITEM.ITEM_CODE%TYPE;
    
    it_fifo       Pkg_Rtype.ta_STG_SHIP_FIFO;
    v_idx_fifo    INTEGER;
    v_stmt_text   STG_PARSER.STMT_TEXT%TYPE;
BEGIN
    SELECT max(stmt_text) into v_stmt_text FROM STG_PARSER WHERE file_info = p_row_file.file_info and status = 'A';
    
    v_row_itm_0.file_id       :=  p_row_file.idriga;
    v_row_itm_0.stg_status    := 'N';
    v_row_itm_0.org_code      :=  p_row_file.org_code;
    v_row_itm_0.make_buy      :=  'A';
    v_row_itm_0.flag_range    :=  0;
    v_row_itm_0.flag_size     :=  0;
    v_row_itm_0.flag_colour   :=  0;
    v_row_itm_0.start_size    :=  NULL;
    v_row_itm_0.end_size      :=  NULL;
    
    FOR x IN C_LINES(replace(v_stmt_text, '<<file_id>>', p_row_file.idriga))
    LOOP
            v_item_code := Pkg_Stage.f_item_code(x.item_code);
 
            -- insert the ITEM , if not present in STG_ITEM 
            v_idx_itm   :=    v_item_code;
            IF NOT it_itm.EXISTS(v_idx_itm) THEN
                it_itm(v_idx_itm)               :=  v_row_itm_0;
                it_itm(v_idx_itm).description   :=  x.item_desc;
                it_itm(v_idx_itm).puom          :=  x.item_uom;
                it_itm(v_idx_itm).oper_code     :=  f_get_rm_operation_for_phase (x.rm_phase);
                it_itm(v_idx_itm).item_code     :=  v_item_code;
                
            END IF;
            
            -- SHIPMENT FIFO DATA
            v_idx_fifo                          :=  it_fifo.COUNT + 1;
            it_fifo(v_idx_fifo).file_id         :=  p_row_file.idriga;
            it_fifo(v_idx_fifo).stg_status      :=  'N';
            it_fifo(v_idx_fifo).org_code        :=  p_row_file.org_code;
            it_fifo(v_idx_fifo).item_code       :=  x.item_code;
            it_fifo(v_idx_fifo).qty             :=  x.qty;
            it_fifo(v_idx_fifo).ship_date       :=  x.ship_Date;
            it_fifo(v_idx_fifo).ship_subcat     :=  CASE  WHEN UPPER(p_row_file.file_name) LIKE '%PANTOF%' THEN '64039911'
                                                          WHEN UPPER(p_row_file.file_name) LIKE '%GHETE%' THEN '64039118'
                                                          WHEN UPPER(p_row_file.file_name) LIKE '%CIZM%' THEN '64039118'
                                                          WHEN UPPER(p_row_file.file_name) LIKE '%SANDA%' THEN '64039998'
                                                    END;
            
    END LOOP;
    
    -- insert in STG_ITEM
    v_idx_itm   :=  it_itm.FIRST;
    WHILE v_idx_itm IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I', it_itm(v_idx_itm));
        v_idx_itm       :=  it_itm.NEXT(v_idx_itm);
    END LOOP;
    
        -- insert int STG_WORK_ORDER
    IF it_fifo.COUNT  > 0 THEN
        Pkg_Iud.p_stg_ship_fifo_miud ('I', it_fifo); 
    END IF;
    
END;


PROCEDURE p_validate_ship_fifo (p_file_id NUMBER)
IS
 
    CURSOR C_LINES      (           p_file_id           NUMBER)
                        IS
                        SELECT      s.*
                        FROM        STG_SHIP_FIFO       s
                        WHERE       s.file_id           =   p_file_id
                            AND     s.stg_status        <>  'L'
                        ;
 
    v_row               STG_SHIP_FIFO%ROWTYPE;
    v_def_subcat        stg_ship_fifo.ship_subcat%TYPE;
  
BEGIN
 
    -- get a default subcategory for the ones that have nothing set
    SELECT MAX(ship_subcat) INTO v_def_subcat 
        from STG_SHIP_FIFO s
        WHERE s.file_id = p_file_id;
 
    -- cycle on the unloaded lines
    FOR x IN C_LINES (p_file_id)
    LOOP
        v_row               :=  x;
 
        -- set the status to Validated, will be changed if errors found, else remain validated
        v_row.stg_status    :=  'V';
        v_row.error_log     :=  NULL;
        v_row.ship_subcat   :=  NVL(v_row.ship_subcat, v_def_subcat);
 
        IF v_row.item_code IS NULL THEN
            v_row.stg_status    :=  'E';
            v_row.error_log     :=  '?Cod? ';
        END IF;
        IF v_row.ship_subcat IS NULL THEN
            v_row.stg_status    :=  'E';
            v_row.error_log     :=  v_row.error_log ||'?Categorie? ';            
        END IF;
 
        Pkg_Iud.p_stg_ship_fifo_iud('U', v_row);
    END LOOP;
 
END;

PROCEDURE p_validate_wo_decl (p_file_id NUMBER)
IS
 
    CURSOR C_LINES      (           p_file_id           NUMBER)
                        IS
                        SELECT      s.*
                        FROM        STG_WO_DECL         s
                        WHERE       s.file_id           =   p_file_id
                            AND     s.stg_status        <>  'L'
                        ;
 
    v_row               STG_WO_DECL%ROWTYPE;
  
BEGIN
 
    FOR x IN C_LINES (p_file_id)
    LOOP
        v_row               :=  x;
 
        -- set the status to Validated, will be changed if errors found, else remain validated
        v_row.stg_status    :=  'V';
        v_row.error_log     :=  NULL;
 
        IF v_row.wo_code IS NULL THEN
            v_row.stg_status    :=  'E';
            v_row.error_log     :=  '?Order? ';
        END IF;
        IF v_row.qty IS NULL THEN
            v_row.stg_status    :=  'E';
            v_row.error_log     :=  v_row.error_log ||'?Qty? ';            
        END IF;
 
        Pkg_Iud.p_stg_wo_decl_iud('U', v_row);
    END LOOP;
 
END;


PROCEDURE   p_create_material_for_fifo (p_stg_file_id number)
IS
PRAGMA autonomous_transaction;

    CURSOR C_MATERIAL_TO_DOWNLOAD (p_file_id number)
        IS
        SELECT s.org_code, s.item_code, s.qty, s.ship_subcat, i.puom
        FROM stg_ship_fifo s
        INNER JOIN ITEM i ON i.org_code = s.org_code and i.item_code = s.item_code
        WHERE s.file_id = p_file_id;

    v_row               VW_PREP_MATERIAL_FIFO%ROWTYPE;
    C_SEGMENT_CODE      VARCHAR2(32000)     :=  'VW_PREP_MATERIAL_FIFO';
    
    v_def_season    work_season.season_code%TYPE;

BEGIN
    DELETE FROM VW_PREP_MATERIAL_FIFO;

    SELECT MAX(season_code) into v_def_season from WORK_SEASON WHERE org_code = 'ALT' and flag_active = 'Y';

    FOR x IN C_MATERIAL_TO_DOWNLOAD ( p_stg_file_id )
        LOOP

            v_row.org_code              :=  x.org_code;
            v_row.item_code             :=  x.item_code;
            v_row.size_code             :=  null;
            v_row.colour_code           :=  NULL;
            v_row.oper_code_item        :=  NULL;
            v_row.season_code           :=  v_def_season;
            v_row.puom                  :=  x.puom;
            v_row.fifo_round_unit       :=  'N';
            v_row.qty                   :=  x.qty;
            v_row.ship_subcat           :=  x.ship_subcat;
            v_row.segment_code          :=  C_SEGMENT_CODE;

            INSERT INTO VW_PREP_MATERIAL_FIFO VALUES v_row;
        END LOOP;
        COMMIT;
END;

PROCEDURE p_load_ship_fifo (p_file_id NUMBER)
IS
    v_ref_shipment number;
BEGIN
    Pkg_Stage_ROA.p_create_material_for_fifo(p_file_id);
    
    select max(sh.idriga) into v_ref_shipment 
        from shipment_header sh
        inner join stg_ship_fifo f on f.org_code = sh.org_code
            and f.ship_date = sh.protocol_date
        where sh.status = 'I'
        and f.file_id = p_file_id; 

    Pkg_Shipment.p_download_fifo (   
                                p_ref_shipment => v_ref_shipment,
                                p_ignore_error      => 'Y',
                                p_flag_commit       => false,
                                p_flag_from_stage   => true
                             );
    commit;
       
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;


PROCEDURE p_load_wo_decl (p_file_id NUMBER)
IS
    CURSOR C_WO (p_file_id number)
        IS
        select s.*
        from STG_WO_DECL s
        WHERE s.file_id = p_file_id
            AND s.stg_status = 'V'
        ;
    
    CURSOR C_PROD_QTY (p_org_code varchar2, p_group_code varchar2)
        IS
        SELECT NVL(SUM(qty), 0)       qty
        --------------------------------------------------------
        FROM        WHS_TRN           th
        INNER JOIN  WHS_TRN_DETAIL    td ON td.ref_trn = th.idriga
        --------------------------------------------------------
        WHERE
                    th.flag_storno    =   'N'
            AND     td.reason_code    =   '+TFINPF'
            AND     td.org_code       =   p_org_code
            AND     td.group_code     =   p_group_code;
    
    v_ref_shipment number;
    v_row_grp WORK_GROUP%ROWTYPE;
    v_row_swd STG_WO_DECL%ROWTYPE;
    v_row_wo WORK_ORDER%ROWTYPE;
    v_row_prod_info C_PROD_QTY%ROWTYPE;
BEGIN
    
    -- get the shipment ID for the Shipment declaration
    select max(sh.idriga) into v_ref_shipment
    from shipment_header sh
    inner join stg_WO_DECL f on f.org_code = sh.org_code
        and f.DECL_date = sh.protocol_date
    where sh.status = 'I'
    and f.file_id = p_file_id; 
    
    -- 
    FOR x IN C_WO(p_file_id)
    LOOP
        BEGIN
            v_row_swd := x;
            
            -- get the Order
            v_row_wo.org_code := x.org_code;
            v_row_wo.order_code := x.wo_code;
            pkg_get2.p_get_work_order_2(v_row_wo, 0);
            
            -- validate and launch the Order
            IF v_row_wo.status = 'I' THEN 
                pkg_order.p_ord_validate(v_row_wo.idriga, x.org_code);
            END IF;
            IF v_row_wo.status IN ('I', 'V') THEN
                pkg_order.p_ord_launch(v_row_wo.idriga);
            END IF;
            
            -- get the WO Group
            v_row_grp.idriga :=  pkg_order.f_ord_get_ref_group(x.org_code, x.wo_code);
            pkg_get.p_get_work_group(v_row_grp, 0);
            
            -- make the PROD declarations, if nothing declared yet 
            OPEN C_PROD_QTY (x.org_code, v_row_grp.group_code);
            FETCH C_PROD_QTY INTO v_row_prod_info;
            CLOSE C_PROD_QTY;
            IF v_row_prod_info.qty = 0 THEN
                pkg_prod.p_dpr_grp( p_org_code => x.org_code,
                                    p_group_code => v_row_grp.group_code,
                                    p_size_code => Pkg_Stage.C_DEFAULT_SIZE,
                                    p_order_code => x.wo_code,
                                    p_oper_code => 'FINIT',
                                    p_employee_code => NULL,
                                    p_wc_code => NULL,
                                    p_date_legal => x.decl_date,
                                    p_qty => x.qty);
            END IF;
            
            -- for the SHIP declarations => add the details to the open shipment
            IF x.operation = 'SHIP' THEN
                if v_ref_shipment is null then pkg_LIB.p_rae('Nu exista nicio expeditie deschisa pentru data din fisier!'); end if;
                pkg_shipment.p_prepare_pick_shipment   
                    (   p_ref_shipment => v_ref_shipment,
                        p_org_code => x.org_code,
                        p_whs_code => pkg_order.f_get_default_whs_fin(x.org_code)
                    );
    
                update vw_blo_pick_shipment
                set qty_q1 = qty, qty_pick = qty, selection = 1 
                where order_code in (select wo_code from stg_wo_decl where idriga = x.idriga);
    
                delete from VW_TRANSFER_ORACLE;
                insert into VW_TRANSFER_ORACLE (numb01, numb02, numb03, numb04, segment_code)
                select idriga, qty_q1, qty_q2, x.package_number, 'VW_TRANSFER_ORACLE' from vw_blo_pick_shipment where selection = 1;            
    
                pkg_shipment.p_shipment_from_picking(p_ref_shipment => v_ref_shipment);
                
                update fifo_material set flag_manual = 'Y' where ref_shipment = v_ref_shipment;
            END IF;
            -- update the information on stage file
            v_row_swd.stg_status := 'L';
            v_row_swd.error_log := NULL;
            Pkg_Iud.p_stg_wo_decl_iud('U', v_row_swd);
    
            COMMIT;
    
            EXCEPTION WHEN OTHERS THEN
                rollback;
                v_row_swd.stg_status            :=  'E';
                v_row_swd.error_log             :=  SQLERRM;
                Pkg_Iud.p_stg_wo_decl_iud('U', v_row_swd);
                commit;
            END;
    END LOOP;
       
EXCEPTION  WHEN OTHERS THEN
        ROLLBACK;
        Pkg_Lib.p_rae(Pkg_Err.f_err_msg(SQLCODE,SQLERRM));
END;

procedure p_process_rec_pkl (p_row_file STG_FILE_MANAGER%ROWTYPE)
is
    
       CURSOR C_LINES(p_sql VARCHAR2)
        is
        select txt01 line_no, txt02 item_code, txt03 item_desc, to_number(txt04) line_weight, txt05 doc_num, to_date(txt06) doc_date
        from table(f_gen_parse(p_sql))
        where seq_no > 0
        ;

    CURSOR C_GET_REC_FILE_ID (p_org_code VARCHAR2)
        IS
        SELECT MAX(idriga) 
        FROM STG_FILE_MANAGER f 
        WHERE f.file_info = 'REC'
            AND f.org_code = p_org_code;
    
    CURSOR C_GET_STG_REC (p_rec_file_id number)
        IS
        SELECT r.*
        FROM STG_RECEIPT r
        WHERE file_id = p_rec_file_id
        order by r.line_no
        ;
    CURSOR C_GET_STG_ITM (p_rec_file_id number)
        IS
        SELECT r.*
        FROM STG_ITEM r
        WHERE file_id = p_rec_file_id
        ;
    type typ_pkl is table of C_LINES%ROWTYPE index by pls_integer;
    it_pkl typ_pkl;    
    v_rec_file_id number;
    it_rec Pkg_Rtype.ta_stg_receipt;
    it_itm Pkg_Rtype.tas_stg_item;
    v_item_code STG_ITEM.item_code%type;
    v_stmt_text stg_parser.stmt_text%type;
begin
    SELECT max(stmt_text) into v_stmt_text FROM STG_PARSER WHERE file_info = p_row_file.file_info and status = 'A';
    -- 
    FOR x IN C_LINES(replace(v_stmt_text, '<<file_id>>', p_row_file.idriga))
    loop
        it_pkl(it_pkl.count + 1) := x;
    end loop;
    if it_pkl.count = 0 then pkg_lib.p_rae('Nu exista linii de receptie gasite in fisier!'); end if;
    
    -- get a corresponding receipt staging file
    open C_GET_REC_FILE_ID (p_row_file.org_code);
    fetch C_GET_REC_FILE_ID into v_rec_file_id;
    close C_GET_REC_FILE_ID;
    
    -- 
    for x in C_GET_STG_REC(v_rec_file_id)
    loop
        it_rec(it_rec.count + 1) := x;
    end loop;    
    
    -- checks for similarities between PKL and REC
    if it_rec.count = 0 then 
        pkg_lib.p_rae('Nicio factura de receptie gasita pentru asociere!');
    end if;
    --
    if it_rec.count <> it_pkl.count then 
        pkg_lib.p_rae('Numarul de linii nu coincide in Packinglist fata de Factura de intrare!');
    end if;
    -- 
    for ix in 1..it_rec.count
    loop
        if substr(it_rec(ix).item_code, 1, 5) <> substr(it_pkl(ix).item_code, 1, 5) then
            pkg_lib.p_rae('Articolele de pe PKL si Rec nu au aceeasi radacina a codului');
        end if;
    end loop;
    
    -- update the receipt lines with info from packinglist
    for ix in 1..it_pkl.count
    loop
        v_item_code := pkg_stage.f_item_code(it_pkl(ix).item_code);
        it_rec(ix).item_code := v_item_code;
        it_rec(ix).net_weight := it_pkl(ix).line_weight;
        if not it_itm.exists(v_item_code) then
            it_itm(v_item_code) := f_get_def_stg_itm(v_rec_file_id, p_row_file.org_code, 'A');
            it_itm(v_item_code).item_code := v_item_code;
            it_itm(v_item_code).description := it_pkl(ix).item_desc;
            it_itm(v_item_code).puom := it_rec(ix).uom_receipt;
        end if;
    end loop;
    
    -- commit the changes to STG tables
    -- cleanup the STG ITEMs
    delete from STG_ITEM where file_id = v_rec_file_id; 
    -- insert in STG_ITEM
    v_item_code   :=  it_itm.FIRST;
    WHILE v_item_code IS NOT NULL
    LOOP
        Pkg_Iud.p_stg_item_iud('I',it_itm(v_item_code));
        v_item_code       :=  it_itm.NEXT(v_item_code);
    END LOOP;
    -- update the REC records
    Pkg_Iud.p_stg_receipt_miud ('U', it_rec); 

end;


END;

/

/
