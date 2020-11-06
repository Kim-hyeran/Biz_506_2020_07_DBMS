-- ems oneday project

create table tbl_ems (
    ems_id NUMBER PRIMARY KEY,
    from_email nVARCHAR2(30) NOT NULL,
    to_email nVARCHAR2(30) NOT NULL,
    s_date nVARCHAR2(10),
    s_time nVARCHAR2(10),
    s_subject nVARCHAR2(125),
    s_content nVARCHAR2(2000),
    s_file1 nVARCHAR2(125),
    s_file2 nVARCHAR2(125)
);

drop table tbl_ems;

create sequence ems_id
start with 1 increment by 1;

SELECT * FROM tbl_ems;

delete from tbl_ems;

commit;