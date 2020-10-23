-- USER1 접속 화면입니다.

create table tbl_member (
    M_USER_ID VARCHAR2(50) PRIMARY KEY,
    M_PASSWORD VARCHAR2(125) NOT NULL,
    M_NAME nVARCHAR2(30) NOT NULL,
    M_TEL VARCHAR2(20),
    M_ADDRESS nVARCHAR2(255),
    M_ROLE VARCHAR2(20)
);

select * from tbl_member;