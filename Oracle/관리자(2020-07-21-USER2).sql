-- 관리자 접속 화면입니다.

-- 새로운 TableSpace와 사용자
-- TableSpace : user2Ts
-- user : user2, password : user2

CREATE TABLESPACE user2Ts
DATAFILE 'C:/bizwork/workspace/oracle_data/user2.dbf'
SIZE 1M AUTOEXTEND ON NEXT 10K;

CREATE USER user2 IDENTIFIED BY user2
DEFAULT TABLESPACE user2Ts;

GRANT DBA TO user2;