create or replace 
function f_clean_nr (p_str varchar2) return varchar2
is
begin
    return replace(replace(trim(p_str), '.', ''), ',', '.');
end;
/
