create table tbl_images (
    i_seq	NUMBER		PRIMARY KEY,
    i_b_seq	NUMBER	NOT NULL,
    i_org_name	nVARCHAR2(255)	NOT NULL,
    i_file_name	nVARCHAR2(255)	NOT NULL,
    i_down	NUMBER
);

create sequence seq_images
start with 1 increment by 1;