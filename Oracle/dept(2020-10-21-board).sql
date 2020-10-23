create table tbl_cs_free (
    cs_free_seq NUMBER PRIMARY KEY,
    cs_free_title nVARCHAR2(125) NOT NULL,
    cs_free_writer nVARCHAR2(30),
    cs_free_date nVARCHAR2(10),
    cs_free_time nVARCHAR2(10),
    cs_free_text nVARCHAR2(2000),
    cs_free_image VARCHAR2(125),
    cs_free_reco NUMBER,
    cs_free_notify NUMBER,
    cs_free_count NUMBER
);

create table tbl_cs_info (
    cs_info_seq NUMBER PRIMARY KEY,
    cs_info_title nVARCHAR2(125) NOT NULL,
    cs_info_cate nVARCHAR2(10),
    cs_info_writer nVARCHAR2(30),
    cs_info_date nVARCHAR2(10),
    cs_info_time nVARCHAR2(10),
    cs_info_text nVARCHAR2(2000),
    cs_info_image VARCHAR2(125),
    cs_info_reco NUMBER,
    cs_info_notify NUMBER,
    cs_info_count NUMBER
);

create table tbl_cs_noti (
    cs_noti_seq NUMBER PRIMARY KEY,
    cs_noti_title nVARCHAR2(125) NOT NULL,
    cs_noti_writer nVARCHAR2(30),
    cs_noti_date nVARCHAR2(10),
    cs_noti_time nVARCHAR2(10),
    cs_noti_text nVARCHAR2(2000),
    cs_noti_count NUMBER
);

drop table tbl_cs_noti;

create sequence cs_free_seq
increment by 1 start with 1;

create sequence cs_info_seq
increment by 1 start with 1;

create sequence cs_noti_seq
increment by 1 start with 1;

drop tablespace tsdept
including contents and datafiles
cascade constraints;

CREATE TABLESPACE tsDEPT
DATAFILE 'C:/bizwork/oracle_dbms/tsDEPT.dbf'
SIZE 1M AUTOEXTEND ON NEXT 500K;