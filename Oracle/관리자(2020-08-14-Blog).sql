-- 여기는 관리자 화면입니다

-- 블로그를 위한 TableSpace 생성
create tablespace blogTS
datafile 'C:/bizwork/oracle_dbms/blog.dbf'
size 1m autoextend on next 1k;

-- user1 사용자 생성
create user user1 identified by user1
default tablespace blogTS;

-- user1에 권한 부여
grant dba to user1;