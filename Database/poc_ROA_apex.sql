create or replace view roa.shipment_header
as
select idriga, sbu_code, ship_year, ship_date, ship_code, ship_type
from APP_ROA.shipment_header;

CREATE OR REPLACE TRIGGER ROA_SHIPMENT_HEADER
INSTEAD OF UPDATE ON SHIPMENT_HEADER
FOR EACH ROW
DECLARE
    rw APP_ROA.SHIPMENT_HEADER%ROWTYPE;
BEGIN
    rw.idriga := :new.idriga;
    APP_ROA.pkg_get.p_get_shipment_header(rw);
    rw.ship_year := :new.ship_year;
    rw.ship_date := :new.ship_date;
    rw.ship_type := :new.ship_type;
    
    APP_ROA.pkg_shipment.p_shipment_header_blo('U', rw); 
    APP_ROA.pkg_iud.p_shipment_header_iud('U', rw); 
END;
/


select * from APP_ROA.shipment_header where idriga = 4949;


create or replace view roa.shipment_detail
as
select idriga, ref_shipment, org_code, item_code
from APP_ROA.shipment_detail;


CREATE OR REPLACE TRIGGER ROA_SHIPMENT_DETAIL
INSTEAD OF UPDATE ON SHIPMENT_DETAIL
FOR EACH ROW
DECLARE
    rw APP_ROA.SHIPMENT_DETAIL%ROWTYPE;
BEGIN
    rw.idriga := :new.idriga;
    APP_ROA.pkg_get.p_get_shipment_DETAIL(rw);
    rw.item_code := :new.item_code;
    
    APP_ROA.pkg_shipment.p_shipment_DETAIL_blo('U', rw); 
    APP_ROA.pkg_iud.p_shipment_DETAIL_iud('U', rw); 
END;
/


