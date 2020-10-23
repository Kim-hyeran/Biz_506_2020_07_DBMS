-- user1 접속 화면입니다.

-- 빛나리 쇼핑몰 기본정보 테이블
-- 상품정보 테이블
create table tbl_product (
    P_CODE	CHAR(6)		PRIMARY KEY,
    P_NAME	nVARCHAR2(30)	NOT NULL,
    P_DCODE	CHAR(6),
    P_STD	nVARCHAR2(20),
    P_IIPRICE	NUMBER,
    P_OPRICE	NUMBER,
    P_IMAGE	nVARCHAR2(125)
);

-- 거래처정보 테이블
create table tbl_dept (
    D_CODE	CHAR(6)		PRIMARY KEY,
    D_NAME	nVARCHAR2(50)	NOT NULL,
    D_CEO	nVARCHAR2(30)	NOT NULL,
    D_TEL	VARCHAR2(20),
    D_ADDR	nVARCHAR2(255),
    D_MANAGER	nVARCHAR2(50),
    D_MN_TEL	VARCHAR2(20)		
);