drop table z_ext_gest_lh;

create table z_ext_gest_lh ( 
CR_DVI VARCHAR2(10),
NR_DVI VARCHAR2(20),
DT_DVI VARCHAR2(10),
REGIM VARCHAR2(10),
FURNIZ VARCHAR2(20),
MP VARCHAR2(5),
PAG VARCHAR2(5),
POZ VARCHAR2(5),
POZ_S VARCHAR2(5),
FACT VARCHAR2(20),
POZ_F VARCHAR2(5),
COD_V VARCHAR2(20),
RATAR VARCHAR2(20),
COD_ART VARCHAR2(10),
COD_MAG VARCHAR2(20),
VAL VARCHAR2(20),
P_TV VARCHAR2(20),
V_TV VARCHAR2(20),
V_TVV VARCHAR2(20),
P_CV VARCHAR2(20),
V_CV VARCHAR2(20),
V_CVV VARCHAR2(20),
P_TVA VARCHAR2(20),
V_TVA VARCHAR2(20),
V_TVAV VARCHAR2(20),
CANT_I VARCHAR2(50),
CANT_R VARCHAR2(50),
CANT_E0 VARCHAR2(50),
CANT_E1 VARCHAR2(50),
CANT_E2 VARCHAR2(50),
CANT_E3 VARCHAR2(50),
CANT_E4 VARCHAR2(50),
CANT_E5 VARCHAR2(50),
CANT_E6 VARCHAR2(50),
CANT_E7 VARCHAR2(50),
CANT_E8 VARCHAR2(50),
CANT_E9 VARCHAR2(50),
CANT_E10 VARCHAR2(50),
CANT_E11 VARCHAR2(50),
CANT_E12 VARCHAR2(50),
CANT_E13 VARCHAR2(50),
CANT_E14 VARCHAR2(50),
CANT_E15 VARCHAR2(50),
CANT_E16 VARCHAR2(50),
CANT_E17 VARCHAR2(50),
CANT_E18 VARCHAR2(50),
CANT_E19 VARCHAR2(50),
CANT_E20 VARCHAR2(50),
CANT_E21 VARCHAR2(50),
CANT_E22 VARCHAR2(50),
CANT_E23 VARCHAR2(50),
CANT_E24 VARCHAR2(50),
CANT_E25 VARCHAR2(50),
CANT_E26 VARCHAR2(50),
CANT_E27 VARCHAR2(50),
CANT_E28 VARCHAR2(50),
CANT_E29 VARCHAR2(50),
CANT_E30 VARCHAR2(50),
CANT_E31 VARCHAR2(50),
CANT_E32 VARCHAR2(50),
CANT_E33 VARCHAR2(50),
CANT_E34 VARCHAR2(50),
CANT_E35 VARCHAR2(50),
CANT_E36 VARCHAR2(50),
CANT_E37 VARCHAR2(50),
CANT_E38 VARCHAR2(50),
CANT_E39 VARCHAR2(50),
CANT_E40 VARCHAR2(50),
CANT_E41 VARCHAR2(50),
CANT_E42 VARCHAR2(50),
CANT_DB VARCHAR2(50),
SOLD VARCHAR2(50),
TOTC VARCHAR2(50),
EF1 VARCHAR2(50),
EF2 VARCHAR2(50),
EF3 VARCHAR2(50),
EF4 VARCHAR2(50),
EF5 VARCHAR2(50),
EF6 VARCHAR2(50),
EF7 VARCHAR2(50),
EF8 VARCHAR2(50),
EF9 VARCHAR2(50),
EF10 VARCHAR2(50),
EFRET VARCHAR2(50)
) 
organization external (
  type oracle_loader
  default directory import_file
  access parameters (
    records delimited by newline skip 1
    fields terminated by ',' 
  )
  location ('gest_lh.csv')
  )
--reject limit unlimited
;


drop table z_ext_cat_matl;

create table z_ext_cat_matl ( 
  COD_V varchar2(50),
  COD_ART varchar2(50),
  UM varchar2(50),
  DEN varchar2(200),
  MONEDA varchar2(50),
  PRET varchar2(50),
  RR varchar2(50),
  CODV_DES varchar2(200),
  DEN_DES varchar2(200),
  CURS varchar2(50)
)
organization external (
  type oracle_loader
  default directory import_file
  access parameters (
    records delimited by newline skip 1
    fields terminated by ',' 
  )
  location ('cat_matl.csv')
  )
--reject limit unlimited
;


select * from z_ext_cat_matl;

select *--count(1) 
from Z_EXT_GEST_LH
where dt_dvi like '%2018';


select count(1) from Z_EXT_GEST_LH;
where totc <> 0;



select distinct replace(replace(replace(den, '.', ''), ' ', ''),'-','') den
  --x.*, lh.totc
  --distinct den 
from z_ext_cat_matl x
inner join (select cod_art, sum(totc) totc from Z_EXT_GEST_LH where regim = '5100' group by cod_art) lh on lh.cod_art = x.cod_art and lh.totc > 0 
--where exists (select 1 from Z_EXT_GEST_LH lh where lh.cod_art = x.cod_art and lh.totc > 0 and lh.regim = '5100')
--where x.moneda <>'EUR'
order by 1;

select cod_v, count(distinct den) 
from z_ext_cat_matl
group by cod_v;

with dt as (
select x.*,  
cant_e0+ 
cant_e1+
cant_e2+
cant_e3+
cant_e4+
cant_e5+
cant_e6+
cant_e7+
cant_e8+
cant_e9+
cant_e10+
cant_e11+
cant_e12+
cant_e13+
cant_e14+
cant_e15+
cant_e16+
cant_e17+
cant_e18+
cant_e19+
cant_e20+
cant_e21+
cant_e22+
cant_e23+
cant_e24+
cant_e25+
cant_e26+
cant_e27+
cant_e28+
cant_e29+
cant_e30+
cant_e31+
cant_e32+
cant_e33+
cant_e34+
cant_e35+
cant_e36+
cant_e37+
cant_e38+
cant_e39+
cant_e40+
cant_e41+ 
cant_e42 cant_sum_e
from Z_EXT_GEST_LH x where regim = '5100')
,dt2 as
  (select x.*, ef1+ef2+ef3+ef4+ef5+ef6+ef7+ef8+ef9+ef10+efret cant_sum_ef from dt x)
select 
    --cant_i, cant_sum_e, totc, sold, cant_sum_e + totc, cant_sum_e + sold, cant_sum_ef,
    x.*,
    cant_sum_e + totc, cant_sum_e + sold, x.cant_i q_i
from dt2 x 
where 1=1
--and cant_i <> cant_sum_e + totc
--and cant_i <> cant_sum_e + sold
--and cant_i <> cant_sum_e + sold+totc
--and sold > 0 
--and totc > 0
and cant_i <> cant_sum_e+cant_sum_ef + sold
order by to_date(dt_dvi, 'dd.mm.yyyy')
;

select * from ;

select nr_dvi, dt_dvi, cod_art, count(1) 
from Z_EXT_GEST_LH x where regim = '5100'
group by nr_dvi, dt_dvi, cod_art
having count(1)>1;




-- update the custom code of the PRO items with the ones set for ALT
select i.*, (select custom_code from item ii where ii.org_code= 'ALT' and ii.item_code = i.item_code) 
from ITEM i
where org_code = 'PRO'
;

select i.custom_code, max(c.description), count(1) 
from item i
inner join custom c on c.custom_code = i.custom_code
where i.org_code = 'ALT'
group by i.custom_code
;


-- insert the distinct DEN from the 


select * from calendar order by calendar_day;
