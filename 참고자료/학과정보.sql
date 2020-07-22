--------------------------------------------------------
--  파일이 생성됨 - 화요일-7월-21-2020   
--------------------------------------------------------
use myDB;
-- 만약 tbl_dept가 존재한다면 삭제하고 재생성
drop table if exists tbl_dept;
-- 만약 table이 존재하지 않는다면 생성
create table if not exists TBL_DEPT (
		d_code char(4) primary key,
		d_name varchar(30) not null,
		d_prof varchar(30())
		);
Insert into USER1.TBL_DEPT (D_CODE,D_NAME,D_PROF) values ('D001','관광정보학','홍길동');
Insert into USER1.TBL_DEPT (D_CODE,D_NAME,D_PROF) values ('D002','국어국문','이몽룡');
Insert into USER1.TBL_DEPT (D_CODE,D_NAME,D_PROF) values ('D003','법학','성춘향');
Insert into USER1.TBL_DEPT (D_CODE,D_NAME,D_PROF) values ('D004','전자공학','임꺽정');
Insert into USER1.TBL_DEPT (D_CODE,D_NAME,D_PROF) values ('D005','컴퓨터공학','장보고');
Insert into USER1.TBL_DEPT (D_CODE,D_NAME,D_PROF) values ('D006','무역학','장길산');
