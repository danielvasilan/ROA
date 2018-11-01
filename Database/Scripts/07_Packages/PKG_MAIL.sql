--------------------------------------------------------
--  DDL for Package PKG_MAIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PKG_MAIL" 
AS

PROCEDURE p_add_email_queue (   p_receipt   VARCHAR2,
           p_sender   VARCHAR2,
           p_sender_email  VARCHAR2,
           p_cc    VARCHAR2,
           p_bcc    VARCHAR2,
           p_subject   VARCHAR2,
           p_message   CLOB,
           p_attachments  VARCHAR2 DEFAULT NULL,
           p_priority   NUMBER  DEFAULT 1,
           p_html_title  VARCHAR2 DEFAULT NULL,
           p_html_sql   VARCHAR2 DEFAULT NULL,
           p_html_specline  VARCHAR2 DEFAULT NULL,
                                p_attach_result     VARCHAR2    DEFAULT NULL
                            )
                                ;

FUNCTION F_Html_Table       (   p_sql               VARCHAR2, 
                                p_special           VARCHAR2
                            ) 
                       RETURN              typ_frm pipelined;


PROCEDURE p_sy_make         (
                                p_dir               VARCHAR2,
                                p_filename          VARCHAR2,
                                p_sql               VARCHAR2,
                                p_show_head         VARCHAR2    DEFAULT 'Y',
                                p_show_grid         VARCHAR2    DEFAULT 'Y',
                                p_max_rows          NUMBER      DEFAULT 1000
                            );


PROCEDURE P_Send_Mail      (   p_sender      VARCHAR2, 
              p_sender_mail     VARCHAR2,
              p_recipients     VARCHAR2,
              p_cc       VARCHAR2,
              p_bcc       VARCHAR2,
              p_subject      VARCHAR2,
              p_message      CLOB,
              p_attachments     VARCHAR2,
              p_priority      INTEGER,
              p_flag_err      INTEGER,
                                p_mail_server       VARCHAR2 DEFAULT NULL);

PROCEDURE job_flush_email_queue;


END;
 

/

/
