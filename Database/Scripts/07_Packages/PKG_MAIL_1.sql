--------------------------------------------------------
--  DDL for Package Body PKG_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PKG_MAIL" 
AS

TYPE    t_a_virtual_table       IS TABLE OF VARCHAR2(32000) INDEX BY PLS_INTEGER;
TYPE    t_a_varchar_integer     IS TABLE OF VARCHAR2(32000) INDEX BY PLS_INTEGER;



----------------------- Customizable Section -----------------------
/*    -- clagi MAIL SERVER 
    smtp_host           VARCHAR2(256) := '88.158.8.126';
    smtp_port           PLS_INTEGER   := 25;
    smtp_domain         VARCHAR2(256) := 'clagi.ro';
*/

    -- ZIR MAIL SERVER 
    smtp_host           VARCHAR2(256) := '10.2.1.4';
    smtp_port           PLS_INTEGER   := 25;
    smtp_domain         VARCHAR2(256) := 'filty.ro';

    -- ITALIAN MAIL SERVER 
    smtp_host_com       VARCHAR2(256) := '10.2.1.4';
    smtp_port_com       PLS_INTEGER   := 25;
    smtp_domain_com     VARCHAR2(256) := 'filty.com';

    -- Customize the signature that will appear in the email's MIME header.
    -- Useful for versioning.
    MAILER_ID   CONSTANT VARCHAR2(256) := 'Mailer by Oracle UTL_SMTP';
  
    --------------------- End Customizable Section ---------------------
    -- A unique string that demarcates boundaries of parts in a multi-part email
    -- The string should not appear inside the body of any part of the email.
    -- Customize this if needed or generate this randomly dynamically.
    BOUNDARY        CONSTANT VARCHAR2(256) := '-----7D81B75CCC90D2974F7A1CBD';

    FIRST_BOUNDARY  CONSTANT VARCHAR2(256) := '--' || BOUNDARY || utl_tcp.CRLF;
    LAST_BOUNDARY   CONSTANT VARCHAR2(256) := '--' || BOUNDARY || '--' || utl_tcp.CRLF;


    -- A MIME type that denotes multi-part email (MIME) messages.
    MULTIPART_MIME_TYPE CONSTANT VARCHAR2(256)  := 'multipart/mixed; boundary="'||
                                                  BOUNDARY || '"';
    MAX_BASE64_LINE_WIDTH CONSTANT PLS_INTEGER  := 76 / 4 * 3;
    MAX_QUOTP_LINE_WIDTH CONSTANT PLS_INTEGER   := 76;

------------------------------------------------------------------------------------------
FUNCTION begin_mail		        (p_sender     	IN VARCHAR2,
					            p_recipients 	IN VARCHAR2,
						        p_cc			IN VARCHAR2,
						        p_bcc			IN VARCHAR2,
					            p_subject    	IN VARCHAR2,
					            p_mime_type  	IN VARCHAR2     DEFAULT 'text/plain',
					            p_priority   	IN PLS_INTEGER  DEFAULT NULL,
                                p_mail_server   IN VARCHAR2     DEFAULT NULL)
					            RETURN utl_smtp.connection;
FUNCTION begin_session 	        RETURN utl_smtp.connection;
FUNCTION begin_session          (p_smtp_host    VARCHAR2, 
                                p_smtp_port     PLS_INTEGER, 
                                p_smtp_domain   VARCHAR2) 		RETURN utl_smtp.connection; 

PROCEDURE end_session	        (p_conn IN OUT NOCOPY utl_smtp.connection);
PROCEDURE write_text	        (p_conn    	IN OUT NOCOPY utl_smtp.connection,
		       			        p_message 	IN VARCHAR2);
PROCEDURE begin_mail_in_session	(p_conn       	IN OUT NOCOPY utl_smtp.connection,
				  				p_sender     	IN VARCHAR2,
				  				p_recipients 	IN VARCHAR2,
								p_cc			IN VARCHAR2,
								p_bcc			IN VARCHAR2,
				  				p_subject    	IN VARCHAR2,
				  				p_mime_type  	IN VARCHAR2  	DEFAULT 'text/plain',
				  				p_priority   	IN PLS_INTEGER 	DEFAULT NULL) ;
PROCEDURE end_mail_in_session	(p_conn IN OUT NOCOPY utl_smtp.connection);

PROCEDURE begin_attachment		(p_conn         IN OUT NOCOPY utl_smtp.connection,
			     				p_mime_type    	IN VARCHAR2 DEFAULT 'text/plain',
			     				p_inline       	IN BOOLEAN  DEFAULT TRUE,
			     				p_filename     	IN VARCHAR2 DEFAULT NULL,
			     				p_transfer_enc 	IN VARCHAR2 DEFAULT NULL);
PROCEDURE end_attachment	    (p_conn 	IN OUT NOCOPY utl_smtp.connection,
			   				    p_last 		IN BOOLEAN DEFAULT FALSE);
PROCEDURE end_mail			    (p_conn IN OUT NOCOPY utl_smtp.connection);
FUNCTION p_read_file_lob        (p_file VARCHAR2, p_blob IN OUT BLOB) RETURN INTEGER;


-- Return the next email address in the list of email addresses, separated
-- by either a "," or a ";".  The format of mailbox may be in one of these:
--   someone@some-domain
--   "Someone at some domain" <someone@some-domain>
--   Someone at some domain <someone@some-domain>
FUNCTION get_address(addr_list IN OUT VARCHAR2) RETURN VARCHAR2 IS

    addr VARCHAR2(256);
    i    PLS_INTEGER;

    FUNCTION lookup_unquoted_char(str  IN VARCHAR2,
				  chrs IN VARCHAR2) RETURN PLS_INTEGER AS
      c            VARCHAR2(5);
      i            PLS_INTEGER;
      len          PLS_INTEGER;
      inside_quote BOOLEAN;
    BEGIN
       inside_quote := FALSE;
       i := 1;
       len := LENGTH(str);
       WHILE (i <= len) LOOP

	 c := SUBSTR(str, i, 1);

	 IF (inside_quote) THEN
	   IF (c = '"') THEN
	     inside_quote := FALSE;
	   ELSIF (c = '\') THEN
	     i := i + 1; -- Skip the quote character
	   END IF;
	   GOTO next_char;
	 END IF;
	 
	 IF (c = '"') THEN
	   inside_quote := TRUE;
	   GOTO next_char;
	 END IF;
      
	 IF (INSTR(chrs, c) >= 1) THEN
	    RETURN i;
	 END IF;
      
	 <<next_char>>
	 i := i + 1;

       END LOOP;
    
       RETURN 0;
    
    END;

BEGIN

    addr_list := LTRIM(addr_list);
    i := lookup_unquoted_char(addr_list, ',;');
    IF (i >= 1) THEN
      addr      := SUBSTR(addr_list, 1, i - 1);
      addr_list := SUBSTR(addr_list, i + 1);
    ELSE
      addr := addr_list;
      addr_list := '';
    END IF;
   
    i := lookup_unquoted_char(addr, '<');
    IF (i >= 1) THEN
      addr := SUBSTR(addr, i + 1);
      i := INSTR(addr, '>');
      IF (i >= 1) THEN
	addr := SUBSTR(addr, 1, i - 1);
      END IF;
    END IF;

    RETURN addr;
END;


-- Write a MIME header
PROCEDURE write_mime_header	(p_conn  	IN OUT NOCOPY utl_smtp.connection,
			      			p_NAME  	IN VARCHAR2,
			      			p_VALUE 	IN VARCHAR2) IS
BEGIN
	utl_smtp.write_data(p_conn, p_NAME || ': ' || p_VALUE || utl_tcp.CRLF);
END;


-- Mark a message-part boundary.  Set <last> to TRUE for the last boundary.
PROCEDURE write_boundary(p_conn  IN OUT NOCOPY utl_smtp.connection,
			   p_LAST  IN            BOOLEAN DEFAULT FALSE) AS
BEGIN
    IF (p_LAST) THEN
      utl_smtp.write_data(p_conn, LAST_BOUNDARY);
    ELSE
      utl_smtp.write_data(p_conn, FIRST_BOUNDARY);
    END IF;
END;


------------------------------------------------------------------------
FUNCTION begin_mail		(p_sender     	IN VARCHAR2,
					    p_recipients 	IN VARCHAR2,
						p_cc			IN VARCHAR2,
						p_bcc			IN VARCHAR2,
					    p_subject    	IN VARCHAR2,
					    p_mime_type  	IN VARCHAR2     DEFAULT 'text/plain',
					    p_priority   	IN PLS_INTEGER  DEFAULT NULL,
                        p_mail_server   IN VARCHAR2     DEFAULT NULL) 
					    RETURN utl_smtp.connection 
IS
    v_conn 		utl_smtp.connection;
BEGIN
    IF p_mail_server IS NULL THEN
        v_conn := begin_session(smtp_host,smtp_port,smtp_domain);
    ELSE
        v_conn := begin_session(smtp_host_com,smtp_port_com,smtp_domain_com);
    END IF;
    begin_mail_in_session(v_conn, p_sender, p_recipients,p_cc,p_bcc, p_subject, p_mime_type, p_priority);
    RETURN v_conn;
END;

------------------------------------------------------------------------
PROCEDURE write_text	(p_conn    	IN OUT NOCOPY utl_smtp.connection,
		       			p_message 	IN VARCHAR2) IS
BEGIN
    utl_smtp.write_data(p_conn, p_message);
END;

------------------------------------------------------------------------
PROCEDURE write_mb_text	(p_conn    	IN OUT NOCOPY utl_smtp.connection,
			  			p_message 	IN            VARCHAR2) IS
BEGIN
    utl_smtp.write_raw_data(p_conn, utl_raw.cast_to_raw(p_message));
END;

------------------------------------------------------------------------
PROCEDURE write_raw		(p_conn    	IN OUT NOCOPY utl_smtp.connection,
		      			p_message 	IN RAW) 
IS
BEGIN
    utl_smtp.write_raw_data(p_conn, p_message);
END;

------------------------------------------------------------------------
PROCEDURE attach_text	(p_conn         IN OUT NOCOPY utl_smtp.connection,
						p_data         IN VARCHAR2,
						p_mime_type    IN VARCHAR2 DEFAULT 'text/plain',
						p_inline       IN BOOLEAN  DEFAULT TRUE,
						p_filename     IN VARCHAR2 DEFAULT NULL,
		        		p_last         IN BOOLEAN  DEFAULT FALSE) 
IS
BEGIN
    begin_attachment(p_conn, p_mime_type, p_inline, p_filename);
    write_text(p_conn, p_DATA);
    end_attachment(p_conn, p_LAST);
END;

------------------------------------------------------------------------
PROCEDURE mail		(p_sender     	IN VARCHAR2,
		 			p_recipients 	IN VARCHAR2,
		 			p_subject    	IN VARCHAR2,
		 			p_message    	IN VARCHAR2) IS
    				p_conn 			utl_smtp.connection;
BEGIN
    p_conn := begin_mail(p_sender, p_recipients,NULL,NULL, p_subject,NULL);
    write_text(p_conn, p_message);
    end_mail(p_conn);
END;


------------------------------------------------------------------------
PROCEDURE ATTACH_BASE64
						 (p_conn      IN OUT NOCOPY utl_smtp.connection,
						 p_data      IN BLOB,
						 p_mime_type IN VARCHAR2 := 'application/octet',
						 p_inline    IN BOOLEAN := TRUE,
						 p_filename  IN VARCHAR2 := NULL,
						 p_last      IN BOOLEAN := FALSE)
IS
	v_data		BLOB;
   	i           PLS_INTEGER;
   	len         PLS_INTEGER;
BEGIN
   	BEGIN_ATTACHMENT(p_conn, p_mime_type, p_inline, p_filename, 'base64');

	DBMS_LOB.CREATETEMPORARY(v_data, FALSE);

	IF p_filename IS NOT NULL THEN
		IF p_read_file_lob (p_fileNAME, v_data) = 0 THEN 
			GOTO exit_atas; 
		END IF;
	END IF;

   	-- Split the Base64-encoded attachment into multiple lines
   	i   := 1;
   	len := DBMS_LOB.getLength(v_data);

   	WHILE (i < len) LOOP
      	IF(i + MAX_BASE64_LINE_WIDTH < len)THEN
         	UTL_SMTP.Write_Raw_Data (p_conn, UTL_ENCODE.base64_encode(
                                        DBMS_LOB.SUBSTR(v_data, MAX_BASE64_LINE_WIDTH, i)
                                                          )
                                 );
      ELSE
         UTL_SMTP.Write_Raw_Data (p_conn, UTL_ENCODE.base64_encode(
                                        DBMS_LOB.SUBSTR(v_data, (len - i) +1,  i)
                                                          )
                                 );
      END IF;

      UTL_SMTP.Write_Data(p_conn, UTL_TCP.CRLF);
      i := i + MAX_BASE64_LINE_WIDTH;
   END LOOP;

	<<EXIT_ATAS>>

   DBMS_LOB.FREETEMPORARY(v_data);

   END_ATTACHMENT(p_conn, p_last);
END;


------------------------------------------------------------------------
PROCEDURE ATTACH_QUOTED_PRINTABLE
						 (p_conn      IN OUT NOCOPY utl_smtp.connection,
						 p_data      IN BLOB,
						 p_mime_type IN VARCHAR2 := 'application/octet',
						 p_inline    IN BOOLEAN := TRUE,
						 p_filename  IN VARCHAR2 := NULL,
						 p_last      IN BOOLEAN := FALSE)
IS
	v_data		BLOB;
   	i           PLS_INTEGER;
   	len         PLS_INTEGER;
BEGIN
   	BEGIN_ATTACHMENT(p_conn, p_mime_type, p_inline, p_filename, 'quoted-printable');

	DBMS_LOB.CREATETEMPORARY(v_data, FALSE);

	IF p_filename IS NOT NULL THEN
		IF p_read_file_lob (p_fileNAME, v_data) = 0 THEN 
			GOTO exit_atas; 
		END IF;
	END IF;

   	-- Split the Base64-encoded attachment into multiple lines
   	i   := 1;
   	len := DBMS_LOB.getLength(v_data);

   	WHILE (i < len) LOOP
      	IF(i + MAX_QUOTP_LINE_WIDTH < len)THEN
         	UTL_SMTP.Write_Raw_Data (p_conn, UTL_ENCODE.quoted_printable_encode(
                                        DBMS_LOB.SUBSTR(v_data, MAX_QUOTP_LINE_WIDTH, i)
                                                          )
                                 );
      ELSE
         UTL_SMTP.Write_Raw_Data (p_conn, UTL_ENCODE.quoted_printable_encode(
                                        DBMS_LOB.SUBSTR(v_data, (len - i) +1,  i)
                                                          )
                                 );
      END IF;

      UTL_SMTP.Write_Data(p_conn, UTL_TCP.CRLF);
      i := i + MAX_QUOTP_LINE_WIDTH;
   END LOOP;

	<<EXIT_ATAS>>

   DBMS_LOB.FREETEMPORARY(v_data);

   END_ATTACHMENT(p_conn, p_last);
END;



------------------------------------------------------------------------
PROCEDURE ATTACH_CLOB
						 (p_conn      IN OUT NOCOPY utl_smtp.connection,
						 p_data      IN CLOB,
						 p_mime_type IN VARCHAR2 := 'text/html',
						 p_inline    IN BOOLEAN := TRUE,
						 p_filename  IN VARCHAR2 := NULL,
						 p_last      IN BOOLEAN := FALSE)
IS
	v_data		CLOB;
   	i           INTEGER;
   	len         INTEGER;
	v_maxlen	INTEGER := 3000;
	v_chunk		VARCHAR2(4000);

BEGIN
   	begin_attachment(p_conn, p_mime_type, p_inline, p_filename);

   	i   := 1;
   	len := DBMS_LOB.getLength(p_data);

	--RAISE_APPLICATION_ERROR (-20001,len);

   	WHILE (i < len) LOOP
      	IF(i + v_maxlen < len)THEN
			v_chunk		:= DBMS_LOB.SUBSTR(p_data, v_maxlen, i);
      	ELSE
			v_chunk		:= DBMS_LOB.SUBSTR(p_data, (len - i) + 1, i);
      	END IF;

		write_text(p_conn, v_chunk);

		--INSERT INTO V_TMP_GENERAL(clob01,numb01,numb02) VALUES(v_chunk,len,i);

      	i := i + v_maxlen;
   	END LOOP;

   	END_ATTACHMENT(p_conn, p_last);
END;

------------------------------------------------------------------------
PROCEDURE begin_attachment		(p_conn         IN OUT NOCOPY utl_smtp.connection,
			     				p_mime_type    	IN VARCHAR2 DEFAULT 'text/plain',
			     				p_inline       	IN BOOLEAN  DEFAULT TRUE,
			     				p_filename     	IN VARCHAR2 DEFAULT NULL,
			     				p_transfer_enc 	IN VARCHAR2 DEFAULT NULL) IS
BEGIN
    write_boundary(p_conn);
    write_mime_header(p_conn, 'Content-Type', p_mime_type);
    write_mime_header(p_conn, 'charset','ISO-8859-1');

    IF (p_transfer_enc IS NOT NULL) THEN
      	write_mime_header(p_conn, 'Content-Transfer-Encoding', p_transfer_enc);
    END IF;
    

    IF (p_filename IS NOT NULL) THEN
    	IF (p_inline) THEN
	  		write_mime_header(p_conn, 'Content-Disposition','inline; filename="'||p_filename||'"');
       	ELSE
	  		write_mime_header(p_conn, 'Content-Disposition','attachment; filename="'||p_filename||'"');
       	END IF;
    END IF;

    utl_smtp.write_data(p_conn, utl_tcp.CRLF);
END;

------------------------------------------------------------------------
PROCEDURE end_attachment	(p_conn 	IN OUT NOCOPY utl_smtp.connection,
			   				p_last 		IN BOOLEAN DEFAULT FALSE) 
IS
BEGIN
    utl_smtp.write_data(p_conn, utl_tcp.CRLF);
    IF (p_last) THEN
      	write_boundary(p_conn, p_last);
    END IF;
END;

------------------------------------------------------------------------
PROCEDURE end_mail			(p_conn IN OUT NOCOPY utl_smtp.connection) 
IS
BEGIN
    end_mail_in_session(p_conn);
    end_session(p_conn);
END;

------------------------------------------------------------------------
FUNCTION begin_session 		RETURN utl_smtp.connection 
IS
    v_conn 		utl_smtp.connection;
BEGIN
    -- open SMTP connection
    v_conn := utl_smtp.open_connection(smtp_host, smtp_port);
    utl_smtp.helo(v_conn, smtp_domain);
    RETURN v_conn;
END;

------------------------------------------------------------------------
FUNCTION begin_session( p_smtp_host     VARCHAR2, 
                        p_smtp_port     PLS_INTEGER, 
                        p_smtp_domain   VARCHAR2) 		RETURN utl_smtp.connection 
IS
    v_conn 		utl_smtp.connection;
BEGIN
    -- open SMTP connection 
    v_conn := utl_smtp.open_connection  (p_smtp_host, p_smtp_port);
    utl_smtp.helo(v_conn, p_smtp_domain);
    RETURN v_conn;
END;


------------------------------------------------------------------------
PROCEDURE begin_mail_in_session	(p_conn       	IN OUT NOCOPY utl_smtp.connection,
				  				p_sender     	IN VARCHAR2,
				  				p_recipients 	IN VARCHAR2,
								p_cc			IN VARCHAR2,
								p_bcc			IN VARCHAR2,
				  				p_subject    	IN VARCHAR2,
				  				p_mime_type  	IN VARCHAR2  	DEFAULT 'text/plain',
				  				p_priority   	IN PLS_INTEGER 	DEFAULT NULL) 
IS
	p_my_recipients VARCHAR2(32767) := p_recipients;
	p_my_sender     VARCHAR2(32767) := p_sender;
    v_found         BOOLEAN:= FALSE;
BEGIN

    -- Specify sender's address (our server allows bogus address
    -- as long as it is a full email address (xxx@yyy.com).
    utl_smtp.mail(p_conn, get_address(p_my_sender));

    -- setez adresantii mail-ului 
    FOR x IN (SELECT trim(txt01) adresa FROM TABLE(pkg_lib.F_Sql_Inlist(p_recipients,';'))) LOOP
		IF x.adresa IS NOT NULL THEN utl_smtp.rcpt(p_conn, x.adresa); END IF;
        v_found     := TRUE;
	END LOOP;
    IF NOT v_found THEN Pkg_Lib.p_rae(0,'Fara adresant!'); END IF;

    -- setez Carbon Copy  
    FOR x IN (SELECT trim(txt01) adresa FROM TABLE(pkg_lib.F_Sql_Inlist(p_cc,';'))) LOOP
		IF x.adresa IS NOT NULL THEN utl_smtp.rcpt(p_conn, x.adresa); END IF;
	END LOOP;

    -- setez Blind Carbon Copy  
    FOR x IN (SELECT trim(txt01) adresa FROM TABLE(pkg_lib.F_Sql_Inlist(p_bcc,';'))) LOOP
		IF x.adresa IS NOT NULL THEN utl_smtp.rcpt(p_conn, x.adresa); END IF;
	END LOOP;

    -- Start body of email
    utl_smtp.open_data(p_conn);

    write_mime_header(p_conn, 'From', p_sender);

    write_mime_header(p_conn, 'To', p_recipients);

    write_mime_header(p_conn, 'Cc', p_cc);

    write_mime_header(p_conn, 'Bcc', p_bcc);

    write_mime_header(p_conn, 'Subject', p_subject);

    write_mime_header(p_conn, 'Content-Type', p_mime_type);

    write_mime_header(p_conn, 'X-Mailer', mailer_id);

    --   High      Normal       Low
    --   1     2     3     4     5
    IF (p_priority IS NOT NULL) THEN
      	write_mime_header(p_conn, 'X-Priority', p_priority);
    END IF;

    -- Send an empty line to denotes end of MIME headers and
    -- beginning of message body.
    utl_smtp.write_data(p_conn, utl_tcp.CRLF);

    IF (p_mime_type LIKE 'multipart/mixed%') THEN
      	write_text(p_conn, 'This is a multi-part message in MIME format.' || utl_tcp.crlf);
	END IF;

END;

------------------------------------------------------------------------
PROCEDURE end_mail_in_session	(p_conn IN OUT NOCOPY utl_smtp.connection) 
IS
BEGIN
    utl_smtp.close_data(p_conn);
END;
    
------------------------------------------------------------------------
PROCEDURE end_session			(p_conn IN OUT NOCOPY utl_smtp.connection) 
IS
BEGIN
    utl_smtp.quit(p_conn);
END;

------------------------------------------------------------------------
FUNCTION p_read_file_lob (p_file VARCHAR2, p_blob IN OUT BLOB) RETURN INTEGER
IS
	fil 		BFILE;
	file_len 	INTEGER;
	v_exists	INTEGER;

BEGIN

    fil 		:= BFILENAME('DIR_MAIL', p_file);
	v_exists	:= dbms_lob.fileexists(fil); 

	IF v_exists = 1 THEN 

	    file_len := dbms_lob.getlength(fil);
	
		dbms_lob.fileopen(fil,dbms_lob.file_readonly);
	
		dbms_lob.loadfromfile(p_blob,fil,file_len);
	
		dbms_lob.fileclose(fil);

	ELSE

		p_blob	:= EMPTY_BLOB;

	END IF;

	RETURN v_exists;

END;



-------------------------------------------------------------------------------------------------
PROCEDURE p_add_email_queue	(p_receipt			VARCHAR2,
							p_sender			VARCHAR2,
							p_sender_email		VARCHAR2,
							p_cc				VARCHAR2,
							p_bcc				VARCHAR2,
							p_subject			VARCHAR2,
							p_message			CLOB,
							p_attachments		VARCHAR2	DEFAULT NULL,
							p_priority			NUMBER		DEFAULT 1,
							p_html_title		VARCHAR2	DEFAULT NULL,
							p_html_sql			VARCHAR2	DEFAULT NULL,
							p_html_specline		VARCHAR2	DEFAULT NULL,
                            p_attach_result     VARCHAR2    DEFAULT NULL)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
------------------------------------------------------------------------------------------------
-- procedura de inserare mailuri in SS_EMAIL_QUEUE 
-- un job periodic goleste aceasta coada 
------------------------------------------------------------------------------------------------
	v_row					EMAIL_QUEUE%ROWTYPE;
	v_message				CLOB;
	v_html_title			VARCHAR2(100);
    v_filename              VARCHAR2(100);

BEGIN
	
	v_message				:= p_message;
	IF p_html_title IS NOT NULL THEN
		v_html_title 			:= '<h1 align=center>' || p_html_title || '</h1>';
		dbms_lob.writeappend(v_message,LENGTH(v_html_title),v_html_title);
	END IF;

    -- insert the query result 
    IF p_html_sql IS NOT NULL THEN
        FOR x IN (SELECT txt01 FROM TABLE(Pkg_Mail.F_Html_Table(p_html_sql,p_html_specline))) LOOP
            dbms_lob.writeappend(v_message,LENGTH(x.txt01),x.txt01);
        END LOOP;
        IF p_attach_result IS NOT NULL THEN
            v_filename  := p_attach_result || TO_CHAR(SYSDATE,'_yyyymmdd_hh24mi')||'.slk';
            Pkg_Mail.p_sy_make('DIR_MAIL',v_filename,p_html_sql,'Y','Y');
            v_row.attachments := v_row.attachments || ';'||v_filename;
        END IF; 
    END IF;

    v_row.sender			:= p_sender;
    v_row.sender_email		:= p_sender_email;
    v_row.receipt			:= p_receipt;	
    v_row.cc				:= p_cc;
    v_row.bcc				:= p_bcc;
    v_row.subject			:= p_subject;
    v_row.message			:= v_message; 
    v_row.receipt			:= p_receipt;
	v_row.attachments		:= v_row.attachments ||';'||p_attachments;	
	v_row.priority			:= p_priority;

	INSERT INTO EMAIL_QUEUE VALUES v_row;
    
	COMMIT;
    
END;

-------------------------------------------------------------------------------------------------
PROCEDURE p_add_email_queue	(p_row  			EMAIL_QUEUE%ROWTYPE,
							p_html_title		VARCHAR2	DEFAULT NULL,
							p_html_sql			VARCHAR2	DEFAULT NULL,
							p_html_specline		VARCHAR2	DEFAULT NULL,
                            p_attach_result     VARCHAR2    DEFAULT NULL)
IS
PRAGMA AUTONOMOUS_TRANSACTION;
------------------------------------------------------------------------------------------------
-- procedura de inserare mailuri in SS_EMAIL_QUEUE (suprainvcarcata)  
-- un job periodic goleste aceasta coada 
------------------------------------------------------------------------------------------------
	v_row					EMAIL_QUEUE%ROWTYPE;
	v_message				CLOB;
	v_html_title			VARCHAR2(500);
    v_filename              VARCHAR2(100);

BEGIN
	
    v_row                   := p_row;

    v_row.message       := NVL(v_row.message, ' ');
    v_row.sender        := NVL(v_row.sender,'MailAutomat');
    v_row.sender_email  := NVL(v_row.sender_email,'daniel.vasilan@zoppas.ro');

    -- inserez in mesaj titlu 
	IF p_html_title IS NOT NULL THEN
		v_html_title 			:= '<h1 align=center>' || p_html_title || '</h1>';
		dbms_lob.writeappend(v_row.message,LENGTH(v_html_title),v_html_title);
	END IF;

    -- inserez rezultatul query-ului formatat   
    IF p_html_sql IS NOT NULL THEN
        FOR x IN (SELECT txt01 FROM TABLE(Pkg_Mail.F_Html_Table(p_html_sql,p_html_specline))) LOOP
            dbms_lob.writeappend(v_row.message,LENGTH(x.txt01),x.txt01);
        END LOOP;
        IF p_attach_result IS NOT NULL THEN
            v_filename  := p_attach_result || TO_CHAR(SYSDATE,'_yyyymmdd_hh24mi')||'.slk';
            Pkg_Mail.p_sy_make('DIR_MAIL',v_filename,p_html_sql,'Y','Y');
            v_row.attachments := v_row.attachments || ';'||v_filename;
        END IF; 
    END IF;

	INSERT INTO EMAIL_QUEUE VALUES v_row;
    
	COMMIT;
    
END;



--------------------------------------------------------------------------------
PROCEDURE job_flush_email_queue
--------------------------------------------------------------------------------
-- goleste COADA de mailuri  
-------------------------------------------------------------------------------- 
IS
	CURSOR C_QUEUE 	IS
					SELECT 		*
					FROM		EMAIL_QUEUE
					WHERE		flag_sent = 0
                            AND receipt IS NOT NULL
					ORDER BY 	line_id;

	v_row		EMAIL_QUEUE%ROWTYPE;                

BEGIN
	FOR x IN C_QUEUE LOOP
		-----------------------------------------------------------------------
        -- trimit mail intr-un sub-bloc!!! 
		-- altfel, o linie poate avea eroare => va bloca pe toate celelalte !!  
		-----------------------------------------------------------------------
    	BEGIN

			v_row				:= x;
        
			Pkg_Mail.P_Send_Mail(	x.sender,
									x.sender_email,
									x.receipt,
									x.cc,
									x.bcc,
									x.subject,
									x.message,
									x.attachments,
									x.priority,
									-1,
                                    x.mail_server);
			-- 
			v_row.flag_sent		:= -1;
			
			UPDATE EMAIL_QUEUE SET ROW = v_row WHERE line_id = x.line_id;
            
			COMMIT;
            
			EXCEPTION WHEN OTHERS THEN 
                v_row.last_error    := SUBSTR(SQLERRM,1,200);
                UPDATE EMAIL_QUEUE SET ROW = v_row WHERE line_id = x.line_id;
                COMMIT;
		END;    
        
	END LOOP;
EXCEPTION	WHEN OTHERS THEN RAISE;
END;

/*********************************************************************************
Procedura de trimitere mail 

**********************************************************************************/
PROCEDURE P_Send_Mail 	(p_sender		VARCHAR2, 
						p_sender_mail	VARCHAR2,
						p_recipients	VARCHAR2,
						p_cc			VARCHAR2,
						p_bcc			VARCHAR2,
						p_subject		VARCHAR2,
						p_message		CLOB,
						p_attachments	VARCHAR2,
						p_priority		INTEGER,
						p_flag_err		INTEGER,
                        p_mail_server   VARCHAR2 DEFAULT NULL)
IS
   	t_conn              UTL_SMTP.Connection;
   	t_blob              BLOB;
	v_inline            BOOLEAN;

BEGIN

  	-- start mail
   	t_conn := Pkg_Mail.Begin_Mail(p_sender,p_recipients,p_cc,p_bcc,p_subject,Pkg_Mail.MULTIPART_MIME_TYPE,p_priority,p_mail_server);

    -- 
    IF UPPER(p_mail_server) LIKE '%.COM' THEN
        v_inline    :=  FALSE;
    ELSE
        v_inline    :=  TRUE;
    END IF;

   	-- load BLOB
	DBMS_LOB.CREATETEMPORARY(t_blob, FALSE);

	-- inserez mesajul 
	IF p_message IS NOT NULL THEN
		Pkg_Mail.ATTACH_CLOB(t_conn, p_message, 'text/html', TRUE, '');
	END IF;

	-- inserez atasamentele 
	FOR x IN (SELECT txt01 FROM TABLE(Pkg_Lib.F_Sql_Inlist(p_attachments,';'))) LOOP
		Pkg_Mail.Attach_Base64(t_conn, t_blob, 'application/octet-stream', TRUE, x.txt01);
        --ATTACH_QUOTED_PRINTABLE(t_conn, t_blob, 'application/octet-stream', FALSE, x.txt01);
	END LOOP;

   	-- end connection
   	Pkg_Mail.End_Mail(t_conn);

   	DBMS_LOB.FREETEMPORARY(t_blob);

EXCEPTION WHEN OTHERS THEN
	IF p_flag_err = -1 THEN  
		RAISE;
	ELSE
		NULL;
	END IF;
END;


/************************************************************************************/
FUNCTION F_Html_Table   (p_sql VARCHAR2, p_special VARCHAR2) 
			            RETURN typ_frm pipelined
-------------------------------------------------------------------------------------
--  Functie care genereaza sursa pentru un mesaj HTML  
-- parametri: 
--    a) SQL = query pentru generarea tabelei HTML 
--    b) SPECIAL = conditie sql pentru evidentiarea unor anumite linii din tabel  
-------------------------------------------------------------------------------------
IS
	selcols 					DBMS_SQL.DESC_TAB;
	v_nrcol						INTEGER; 
	v_cursor 					INTEGER; 			
    i                           INTEGER;
    fdbk                        INTEGER;
    v_test                      CLOB;
    v_data                      DATE;
    v_num                       NUMBER;
    v_row                       tmp_frm := tmp_frm;
    v_colvalue                  VARCHAR2(500);

    v_text                      CLOB := EMPTY_CLOB; 

    v_bgcolor                   VARCHAR2(10);
    v_sql                       VARCHAR2(2000);
    v_relcol                    VARCHAR2(1000);
    v_css                       VARCHAR2(2000);

BEGIN

    v_css := '            <style TYPE="text/css">            <!--            .style1 {
            	font-SIZE: 16px;
            	font-family: Verdana, Arial, Helvetica, sans-serif;
            	font-weight: bold;
            }
            .CLASS {
            	font-family: Verdana, Arial, Helvetica, sans-serif;
            	font-SIZE: 10px;
            }
            -->            </style>            ';

    IF p_special IS NOT NULL THEN 
        v_relcol := '(                          CASE
                            WHEN xyz.'
                            ||p_special||
                            '                                 THEN -1 
                                ELSE 0 
                            END)' ;
    ELSE
        v_relcol := '0';
    
    END IF;
    
    v_sql := '                SELECT '  
                    || v_relcol ||
                        '                         flag_special, 
                    ROWNUM CRT,xyz.*
                FROM (
                    '
                    || p_sql ||
                    '                    ) xyz';

--    RAISE_APPLICATION_ERROR (-20001,v_sql);

    v_cursor := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(v_cursor, v_sql,1);
	DBMS_SQL.DESCRIBE_COLUMNS (v_cursor ,v_nrcol , selcols);

    v_text      := v_text || v_css;
    -- generez header-ul tabelei 
    v_text := v_text || '<TABLE border=1 cellpadding="1" cellspacing="0" class="class"><TR>';
    FOR i IN 1..v_nrcol LOOP
        IF selcols(i).col_name <> 'FLAG_SPECIAL' THEN
            v_text := v_text || '<TD bgcolor = lightblue>' || selcols(i).col_name;
           -- v_text := v_text || ' ' || selcols(i).col_type;
        END IF;

        CASE  selcols(i).col_type 
            WHEN 2 THEN DBMS_SQL.DEFINE_COLUMN (v_cursor, i,v_num);
            WHEN 1 THEN DBMS_SQL.DEFINE_COLUMN (v_cursor, i,v_test);
            WHEN 12 THEN DBMS_SQL.DEFINE_COLUMN (v_cursor, i,v_data);
            ELSE NULL;    
        END CASE;
    END LOOP;

    fdbk:= DBMS_SQL.EXECUTE (v_cursor);
    LOOP

        EXIT WHEN DBMS_SQL.FETCH_ROWS (v_cursor) = 0;

        v_text := v_text || CHR(9)||CHR(10)||'<tr>';
 

        FOR i IN 1..v_nrcol LOOP

            IF selcols(i).col_name = 'FLAG_SPECIAL' THEN
                DBMS_SQL.COLUMN_VALUE (v_cursor, i, v_num);
                IF v_num = -1 THEN 
                    v_bgcolor := 'lightgreen';
                ELSE
                    v_bgcolor := 'white';
                END IF;

            ELSE

                CASE selcols(i).col_type 
                WHEN 2 THEN 
                    DBMS_SQL.COLUMN_VALUE (v_cursor, i, v_num);
                    v_colvalue := '<td bgcolor='||v_bgcolor||' align=right>'||NVL(TO_CHAR(v_num),'&nbsp;');
                WHEN 1 THEN 
                    DBMS_SQL.COLUMN_VALUE (v_cursor, i, v_test);
                    v_colvalue := '<td bgcolor='||v_bgcolor||' align=left>'||NVL(TO_CHAR(v_test),'&nbsp;');
                WHEN 12 THEN 
                    DBMS_SQL.COLUMN_VALUE (v_cursor, i, v_data);
                    v_colvalue := '<td bgcolor='||v_bgcolor||' align=left>'||NVL(TO_CHAR(v_data,'dd/mm/yyyy'),'&nbsp;');
                ELSE v_colvalue := '???';
                END CASE;
                
                v_text := v_text || v_colvalue || '</td>';
    
                IF dbms_lob.getlength(v_text) > 1000 THEN
                    
                    v_row.txt01 := dbms_lob.SUBSTR(v_text,2000,1);
                    v_text      := EMPTY_CLOB;
                    pipe ROW(v_row);
                END IF;

            END IF;
        END LOOP;
    

    END LOOP;

    v_text := v_text || '</TABLE>';
    
    v_row.txt01 := dbms_lob.SUBSTR(v_text,2000,1);
    pipe ROW(v_row);

    DBMS_SQL.CLOSE_CURSOR(v_cursor);

    RETURN;

-- EXCEPTION 
--     WHEN OTHERS THEN DBMS_SQL.CLOSE_CURSOR(v_cursor);
--     RAISE;
END;


--------------------------------------------------------------------------------
--   SYNK (SYMBOLIC LINK ) 
--   
--------------------------------------------------------------------------------

PROCEDURE pl(p_file UTL_FILE.FILE_TYPE, p_str IN VARCHAR2 ) IS
--------------------------------------------------------------------------------
-- procedura de simplificare a codului PL = UTL_FILE.PUT_LINE 
--------------------------------------------------------------------------------
BEGIN
    UTL_FILE.PUT_LINE( p_file, p_str );
EXCEPTION WHEN OTHERS THEN NULL;
END;

--------------------------------------------------------------------------------
PROCEDURE p_sy_write_header
                            (p_file     UTL_FILE.FILE_TYPE, 
                            p_desc_t    DBMS_SQL.DESC_TAB,
                            p_font      VARCHAR2, 
                            p_grid      VARCHAR2, 
                            p_head      VARCHAR2,
                            p_col_len   IN OUT t_a_varchar_integer)
--------------------------------------------------------------------------------
-- scrie header-ul fisierului (identificare + formatare, fonturi, cap de tabel) 
--------------------------------------------------------------------------------
IS
    v_grid      VARCHAR2(5);
    v_head      VARCHAR2(5);
    i           PLS_INTEGER;
    v_align     VARCHAR2(1);
BEGIN
    -- inceput de fisier 
    pl(p_file, 'ID;ORACLE');
    -- fonturi 
    pl(p_file, 'P;F' || p_font || ';M200');
    pl(p_file, 'P;F' || p_font || ';M200;SB' );
    pl(p_file, 'P;F' || p_font || ';M200;SUB' );
    -- Formatari  
    IF p_grid = 'Y' THEN v_grid := ''; ELSE v_grid := ';G'; END IF;
    IF p_head = 'Y' THEN v_head := ''; ELSE v_head := ';H'; END IF;
    pl(p_file, 'F;C1;FG0R;SM1' || v_grid || v_head);

    FOR i IN 1 .. p_desc_t.COUNT LOOP
        IF p_desc_t(i).col_type = 2 THEN v_align := 'R'; ELSE v_align := 'L'; END IF;
        pl(p_file, 'F;C' || TO_CHAR(i) || ';FG0'||v_align||';SM0' );
        p_col_len(i)    := p_desc_t(i).col_name_len;
    END LOOP;

    -- cap de tabel  
    pl(p_file, 'F;R1;FG0C;SM2' );
    FOR i IN 1 .. p_desc_t.COUNT LOOP
        IF i = 1 THEN
            pl(p_file, 'C;Y1;X1;K"' || p_desc_t(i).col_name || '"' );
        ELSE
            pl(p_file, 'C;X' || TO_CHAR(i) || ';K"' || p_desc_t(i).col_name || '"' );
        END IF;
    END LOOP;
END;

--------------------------------------------------------------------------------
PROCEDURE p_sy_write_rows  (p_file      UTL_FILE.FILE_TYPE, 
                            p_desc_t    DBMS_SQL.DESC_TAB,
                            p_cursor    INTEGER,
                            p_max_rows  NUMBER,
                            p_col_len   IN OUT t_a_varchar_integer)
--------------------------------------------------------------------------------
-- parcurge query-ul si insereaza liniile in fisier 
--------------------------------------------------------------------------------
IS
    row_cnt     NUMBER          := 0;
    v_line      VARCHAR2(32767) := NULL;
    v_row       VARCHAR2(32767) := NULL;
BEGIN
    LOOP
        EXIT WHEN ( row_cnt >= p_max_rows OR DBMS_SQL.FETCH_ROWS( p_cursor ) <= 0 );
        row_cnt := row_cnt + 1;
        
        pl(p_file, 'C;Y' || TO_CHAR(row_cnt+2) );

        FOR i IN 1 .. p_desc_t.COUNT LOOP
            DBMS_SQL.COLUMN_VALUE( p_cursor, i, v_row);
            v_line  := 'C;X' || TO_CHAR(i) || ';K';
            ----------------------------------------------
            v_line  := v_line || '"' || v_row || '"';
/*
            IF p_desc_t(i).col_type = 2 THEN 
                v_line  := v_line || v_row;
            ELSE
                v_line  := v_line || '"' || v_row || '"';
            END IF;*/ 
            pl(p_file, v_line);
            -- memorez in tabloul cu lungimile coloanelor 
            p_col_len(i) := GREATEST(p_col_len(i), LENGTH(v_row));

        END LOOP;
    END LOOP;
END;

--------------------------------------------------------------------------------
PROCEDURE p_sy_write_tail   
                            (p_file     UTL_FILE.FILE_TYPE, 
                            p_col_len   t_a_varchar_integer)
--------------------------------------------------------------------------------
-- scrie sfarsitul de fisier - latimile coloanelor, caracterul de EOF   
--------------------------------------------------------------------------------
IS
BEGIN
--    pl(p_file, 'F;W1 1 7' );
    FOR i IN 1 .. p_col_len.COUNT LOOP
        pl(p_file,'F;W' || TO_CHAR(i) || ' ' || TO_CHAR(i+1) || ' ' || TO_CHAR(TO_NUMBER(p_col_len(i))) );
    END LOOP;
    pl(p_file,'E');
END;

--------------------------------------------------------------------------------
PROCEDURE p_sy_make(
                    p_dir       VARCHAR2,
                    p_filename  VARCHAR2,
                    p_sql       VARCHAR2,
                    p_show_head VARCHAR2    DEFAULT 'Y',
                    p_show_grid VARCHAR2    DEFAULT 'Y',
                    p_max_rows  NUMBER      DEFAULT 1000)
--------------------------------------------------------------------------------
-- genereaza fisierul SYLK 
-- parametri: 
--      1) numele obiectului DIRECTOR din BD, 
--      2) numele sub care va fi salvat fisierul, 
--      3) sql-ul sursa,
--      4) flag ARATA CAP DE TABEL, -- Y or else 
--      5) flag ARATA GRID  -- Y or else     
--------------------------------------------------------------------------------
IS

    v_cursor    NUMBER := DBMS_SQL.OPEN_CURSOR;
    v_file      UTL_FILE.FILE_TYPE;
    v_desc_t    DBMS_SQL.DESC_TAB;
    v_col_cnt   NUMBER;
    v_cvalue    VARCHAR2(32767);
    v_status    NUMBER;
    v_font      VARCHAR2(50) := 'Courier New';
    v_col_len   t_a_varchar_integer;

BEGIN
    v_file      := UTL_FILE.FOPEN( p_dir, p_filename, 'w',32000 );

    DBMS_SQL.PARSE( v_cursor, p_sql, dbms_sql.native );


    DBMS_SQL.DESCRIBE_COLUMNS( v_cursor, v_col_cnt, v_desc_t );
    --
    FOR i IN 1 .. v_desc_t.COUNT LOOP
        DBMS_SQL.DEFINE_COLUMN( v_cursor, i, v_cvalue, 32765);
    END LOOP;
    --
    p_sy_write_header(v_file, v_desc_t, v_font, p_show_grid, p_show_head, v_col_len);

    v_status := DBMS_SQL.EXECUTE( v_cursor );
        
    p_sy_write_rows(v_file, v_desc_t, v_cursor,p_max_rows, v_col_len);

    p_sy_write_tail(v_file, v_col_len);

    DBMS_SQL.CLOSE_CURSOR( v_cursor );
    UTL_FILE.FCLOSE( v_file );

END;




END;

/

/
