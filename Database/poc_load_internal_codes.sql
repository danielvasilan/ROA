--- load the scheda file and extract the item codes

select distinct --item_code, description , 
substr(description, 1, instr(description, ' '))
from item
where type_code = 'MP'

