create or replace 
function f_gen_parse(v_sql varchar2) return typ_frm pipelined
as
	selcols 		DBMS_SQL.DESC_TAB;
	v_nrcol			INTEGER; 
	v_cursor 		INTEGER; 			
  v_text      varchar2(2000);
  fdbk        int;
  v_row       tmp_frm := tmp_frm();    
begin 
      v_cursor := DBMS_SQL.OPEN_CURSOR;
    	DBMS_SQL.PARSE(v_cursor, v_sql, 1);
	    DBMS_SQL.DESCRIBE_COLUMNS (v_cursor, v_nrcol, selcols);
      
      v_row.idriga := 0;
      v_row.seq_no := 0;
      v_row.txt01 := selcols(1).col_name;
      if v_nrcol > 1 then 
          v_row.txt02 := selcols(2).col_name;
      end if;
      if v_nrcol > 2 then 
          v_row.txt03 := selcols(3).col_name;
      end if;
      if v_nrcol > 3 then 
          v_row.txt04 := selcols(4).col_name;
      end if;
      if v_nrcol > 4 then 
          v_row.txt05 := selcols(5).col_name;
      end if;
      if v_nrcol > 5 then 
          v_row.txt06 := selcols(6).col_name;
      end if;
      if v_nrcol > 6 then 
          v_row.txt07 := selcols(7).col_name;
      end if;
      if v_nrcol > 7 then 
          v_row.txt08 := selcols(8).col_name;
      end if;
      if v_nrcol > 8 then 
          v_row.txt09 := selcols(9).col_name;
      end if;
      if v_nrcol > 9 then 
          v_row.txt10 := selcols(10).col_name;
      end if;
      if v_nrcol > 10 then 
          v_row.txt11 := selcols(11).col_name;
      end if;
      if v_nrcol > 11 then 
          v_row.txt12 := selcols(12).col_name;
      end if;
      if v_nrcol > 12 then 
          v_row.txt13 := selcols(13).col_name;
      end if;
      if v_nrcol > 13 then 
          v_row.txt14 := selcols(14).col_name;
      end if;
      if v_nrcol > 14 then 
          v_row.txt15 := selcols(15).col_name;
      end if;
      if v_nrcol > 15 then 
          v_row.txt16 := selcols(16).col_name;
      end if;
      if v_nrcol > 16 then 
          v_row.txt17 := selcols(17).col_name;
      end if;
      if v_nrcol > 17 then 
          v_row.txt18 := selcols(18).col_name;
      end if;
      if v_nrcol > 18 then 
          v_row.txt19 := selcols(19).col_name;
      end if;
      if v_nrcol > 19 then 
          v_row.txt20 := selcols(20).col_name;
      end if;
      
      pipe row(v_row);
      
        FOR i IN 1..v_nrcol LOOP
            DBMS_SQL.DEFINE_COLUMN (v_cursor, i, v_text, 2000);
        END LOOP;

        fdbk:= DBMS_SQL.EXECUTE (v_cursor);
        LOOP
            EXIT WHEN DBMS_SQL.FETCH_ROWS (v_cursor) = 0;
            v_row.seq_no := v_row.seq_no + 1;
            
            DBMS_SQL.COLUMN_VALUE (v_cursor, 1, v_row.txt01);
            if v_nrcol > 1 then 
                 DBMS_SQL.COLUMN_VALUE (v_cursor, 2, v_row.txt02);
            end if;
            if v_nrcol > 2 then 
                 DBMS_SQL.COLUMN_VALUE (v_cursor, 3, v_row.txt03);
            end if;
            if v_nrcol > 3 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 4, v_row.txt04);
            end if;
            if v_nrcol > 4 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 5, v_row.txt05);
            end if;
            if v_nrcol > 5 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 6, v_row.txt06);
            end if;
            if v_nrcol > 6 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 7, v_row.txt07);
            end if;
            if v_nrcol > 7 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 8, v_row.txt08);
            end if;
            if v_nrcol > 8 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 9, v_row.txt09);
            end if;
            if v_nrcol > 9 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 10, v_row.txt10);
            end if;
            if v_nrcol > 10 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 11, v_row.txt11);
            end if;
            if v_nrcol > 11 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 12, v_row.txt12);
            end if;
            if v_nrcol > 12 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 13, v_row.txt13);
            end if;
            if v_nrcol > 13 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 14, v_row.txt14);
            end if;
            if v_nrcol > 14 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 15, v_row.txt15);
            end if;
            if v_nrcol > 15 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 16, v_row.txt16);
            end if;
            if v_nrcol > 16 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 17, v_row.txt17);
            end if;
            if v_nrcol > 17 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 18, v_row.txt18);
            end if;
            if v_nrcol > 18 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 19, v_row.txt19);
            end if;
            if v_nrcol > 19 then 
                DBMS_SQL.COLUMN_VALUE (v_cursor, 20, v_row.txt20);
            end if;
      
            pipe row(v_row);
            
        END LOOP;
            
        DBMS_SQL.CLOSE_CURSOR(v_cursor);
    
end;
/
