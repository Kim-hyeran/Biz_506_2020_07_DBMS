-- user1 접속화면입니다.

create table tbl_bbs (
    b_seq NUMBER PRIMARY KEY,
    b_date VARCHAR2(10) NOT NULL,
    b_time VARCHAR2(10) NOT NULL,
    b_writer nVARCHAR2(30) NOT NULL,
    b_subject nVARCHAR2(125) NOT NULL,
    b_content nVARCHAR2(2000) NOT NULL,
    b_count NUMBER,
    b_file nVARCHAR2(125)
);

create sequence seq_bbs
start with 1 increment by 1;

delete from tbl_bbs;

commit;