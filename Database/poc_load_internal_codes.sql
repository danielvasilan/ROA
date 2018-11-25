-- step 0)
-- cleanup after tests
delete from multi_table where table_name = 'TEHVAR_FIFOFAMILY';
delete from item_variable where item_code like 'ROA%';
delete from receipt_detail where ;
delete from receipt_header where sbu_code = 'PRO';
delete from item where item_code like 'ROA%';


-- step 1)
-- delete from the input file the " characters

-- step 2)
-- generate the fifo family codes (in multi_table) as the distinct "den" of internal codes
-- since the count difference is small => all the distinct descriptions will be considered (no text changes)

insert into multi_table (table_key, description, table_name, flag_active, seq_no)
with dt as (
    select distinct replace(den, ' ', '_') den
    from z_ext_cat_matl x
    inner join (select cod_art, sum(sold) sold from Z_EXT_GEST_LH where regim = '5100' group by cod_art) lh on lh.cod_art = x.cod_art and lh.sold > 0 
    )
select den, den, 'TEHVAR_FIFOFAMILY', 'Y', 0 from dt
order by 1;


select table_name, count(1) from multi_table group by table_name order by 1;
select * from multi_table order by 1;

-- step 3.1) 
-- load the UOMs that are not yet in the system
insert into primary_uom (puom, description)
with new_uom as (select um from z_ext_cat_matl minus select puom from primary_uom)
select um, um from new_uom
;


select * from primary_uom ;

-- step 3.2 )
-- load the custom codes that are not yet in the system
insert into custom (custom_code, description)
with new_cst as (select cod_v from z_ext_cat_matl minus select custom_code from custom)
select cod_v, cod_v || ' ????' from new_cst
;



select * from custom;


-- step 3.3 )
-- load the internal codes as they are (only the last cod_art for the same description)

insert into item (item_code, description, puom, suom, uom_conv, make_buy, custom_code, custom_category, flag_size, flag_colour, flag_range, org_code, whs_stock, mat_type, uom_receit, type_code)
with dt as (
    select replace(den, ' ', '_') den, x.cod_v, x.cod_art, x.um, x.moneda, x.pret, x.rr
    from z_ext_cat_matl x
    inner join (select cod_art, sum(sold) sold from Z_EXT_GEST_LH where regim = '5100' group by cod_art) lh on lh.cod_art = x.cod_art and lh.sold > 0 
    )
select 'ROA.' || max(cod_art) item_code, den description, max(um) puom, 
    CASE WHEN min(um) = max(um) THEN NULL ELSE min(um) END suom, CASE WHEN min(um) = max(um) THEN 0 ELSE 1 END uom_conv,
    'A' make_buy, max(cod_v) custom_code, '5100' custom_category, 0 flag_size, 0 flag_colour, 0 flag_range, 'PRO' org_code, 'MPLOHN' whs_stock, '???' mat_type, max(um) um_receit, 'MP' type_code
from dt
group by den
;

select * from item where org_code = 'PRO';

-- step 4) 
-- add the FIFO_FAMILY to the internal codes as teh_variable
insert into item_variable (org_code, item_code, var_code, var_value)
with dt as (
    select distinct replace(den, ' ', '_') den
    from z_ext_cat_matl x
    inner join (select cod_art, sum(sold) sold from Z_EXT_GEST_LH where regim = '5100' group by cod_art) lh on lh.cod_art = x.cod_art and lh.sold > 0 
    )
, dt2 as (
  select i.* 
  from dt 
  inner join item i on i.org_code = 'PRO' and i.description = dt.den
  )
select org_code, item_code, 'FIFOFAMILY' var_code, description var_value from dt2
;

select * from item_variable where var_code = 'FIFOFAMILY';

delete from item_variable where var_code = 'FIFOFAMILY';

-- step 5)
-- load receipts with fifo_stock
-- 7135 lines - 69588 regim - 16271 qty - 1287 dist dvi

insert into receipt_header(sbu_code, receipt_year, receipt_code, receipt_date, org_code, receipt_type, suppl_code, doc_number, doc_date,
    incoterm, currency_code, country_from, note, whs_code, status, fifo)
with dt as (select distinct nr_dvi, dt_dvi, furniz from Z_EXT_GEST_LH where regim='5100' and sold>0)
select 'PRO' sbu_code, substr(dt_dvi, 7,4) receipt_year,  'X'||to_char(to_date(dt_dvi,'dd.mm.yyyy'), 'yy')||'-'||nr_dvi receipt_code, 
    to_date(dt_dvi, 'dd.mm.yyyy') receipt_date, 'PRO' org_code, 'ME3' receipt_type, 'ALT' suppl_code, nr_dvi doc_number, to_date(dt_dvi, 'dd.mm.yyyy') doc_date,
    'CIP' incoterm, 'EUR' currency_code, 'IT' country_from, 'foxpro' note, 'MPLOHN' whs_code, 'I' status, 'Y' fifo
from dt;

select sbu_code, count(1) from receipt_header group by sbu_code;

select * from receipt_header ;

with dt as (select * from Z_EXT_GEST_LH where regim='5100' and sold > 0)
, dt2 as 
    (select dt.* , h.idriga h_idriga, m.um, i.item_code, i.custom_code
    from dt 
    left join receipt_header h on h.sbu_code = 'PRO' and h.receipt_date = to_date(dt_dvi, 'dd.mm.yyyy') and h.doc_number = dt.nr_dvi
    left join z_ext_cat_matl m on m.cod_art = dt.cod_art
    left join item i on i.description = replace(m.den, ' ', '_') and i.org_code = 'PRO'
    )
select 'PRO' sbu_code, h_idriga ref_receipt,
    um uom_receipt, sold qty_doc, sold qty_count, um puom, sold qty_doc_puom, sold qty_count_puom, 'PRO' org_code, item_code,
    '' season_code, 'MPLOHN' whs_code, custom_code, 'IT' origin_code, round(val/cant_i, 5) price_doc, 0 price_doc_puom, 0 line_seq
from dt2;

select * from receipt_detail;

select * from Z_EXT_GEST_LH where regim='5100' and sold>0;

-- CHECK !!!

-- old receipts with remaining fifo stock
select  nr_dvi, dt_dvi, count(1) from Z_EXT_GEST_LH where regim = '5100' and (totc > 0 or sold > 0)
group by nr_dvi, dt_dvi
order by to_date(dt_dvi, 'dd.mm.yyyy'), nr_dvi;

select * from Z_EXT_GEST_LH;
where nr_dvi = '46638' and dt_dvi = '03.05.2006';


select * from Z_EXT_GEST_LH where regim='5100' and totc>0;




select distinct replace(replace(replace(replace(den, '.', ''), ' ', ''),'-',''), 'INCALATAMINTE', 'INCALTAMINTE') den
  --x.*, lh.totc
  --distinct den 
from z_ext_cat_matl x
inner join (select cod_art, sum(totc) totc from Z_EXT_GEST_LH where regim = '5100' group by cod_art) lh on lh.cod_art = x.cod_art and lh.totc > 0 
--where exists (select 1 from Z_EXT_GEST_LH lh where lh.cod_art = x.cod_art and lh.totc > 0 and lh.regim = '5100')
--where x.moneda <>'EUR'
order by 1;


select 
    count(distinct replace(replace(replace(replace(den, '.', ''), ' ', ''),'-',''), 'INCALATAMINTE', 'INCALTAMINTE')) cnt_den,
    count(distinct den) cnt_den_2
from z_ext_cat_matl x
inner join (select cod_art, sum(totc) totc from Z_EXT_GEST_LH where regim = '5100' group by cod_art) lh on lh.cod_art = x.cod_art and lh.totc > 0 
--where exists (select 1 from Z_EXT_GEST_LH lh where lh.cod_art = x.cod_art and lh.totc > 0 and lh.regim = '5100')
--where x.moneda <>'EUR'
order by 1;



with dt as (
    select replace(den, ' ', '_') den, x.cod_v, x.cod_art, x.um, x.moneda, x.pret, x.rr
    from z_ext_cat_matl x
    inner join (select cod_art, sum(totc) totc from Z_EXT_GEST_LH where regim = '5100' group by cod_art) lh on lh.cod_art = x.cod_art and lh.totc > 0 
    )
select den, count(cod_art) , max(cod_art) , count(distinct um), count(distinct cod_v)
from dt
group by den
having count(distinct um) > 2
order by 5 desc
/*
select * from dt where den = 'BANDA_TEXTILA'
order by um
*/
;

BANDA_TEXTILA
HARTIE_PT._STAMPILAT
MAT._LUSTRUIT_-_CREMA
ETICHETE_HARTIE_AUTOADEZIVE
BANDA_PLASTIC
CUIE_PT._INCALTAMINTE;

select * from custom
where custom_code in ('59061000', '58063900');
