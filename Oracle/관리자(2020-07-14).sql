-- Comment : 한 줄 주석
/*
여러 줄 주석
*/
/*
SQL 명령을 입력할 때 명령이 끝났음을 알리는 기호 : 세미콜론(;)

ctrl+Enter : 현재 커서가 있는 곳의 명령문을 DBMS로 보내고 결과 출력
*/

-- 현재 Oracle에 접속된 사용자(sys)가 관리하는 table 중에서 tab이라는 이름을 가진 table 정보를 가져와 출력 요청
-- Oracle의 tab table은 현재 접속된 사용자가 관리하는 DB Object(객체)의 정보를 보관하고 있는 table
SELECT *
FROM tab;

-- ALL_ALL_TABLES : Oracle system data dictionary의 자세한 정보를 보관하는 table
SELECT *
FROM all_all_tables;

-- SELECT Keyword는 FROM 절을 포함하는 명령문 형태로 작성
-- DBMS가 보관하고 있는 데이터를 table 형식으로 출력을 요청하는 명령
-- DBMS의 DML(Database Menuplation Language) 중에서  Read(조회)를 수행하는 명령
-- CRUD 중에서 R : Read, Retrive를 수행하는 명령문
SELECT *
FROM 주소록;

-- SQL 명령문을 통해서 DB 객체 생성, 삭제, 데이터 추가, 변경, 삭제 수행 시 sys 사용자로 접속하게 되면 중요한 정보를 삭제, 변경할 우려 존재

-- 사용자를 추가하는 순서
/*
1. 데이터를 저장할 물리적 공간(table space) 설정
2. 사용자(user) 생성 후 물리적 저장공간과 연결
*/

-- TableSpace 생성(Create)
/*
TableSpace : Oracle에서 Data를 저장할 물리적 공간을 설정하는 것
myTS : 앞으로 SQL을 통해서 사용할 TableSpace의 alias(이름)
'../myTS.dbf' : 저장할 파일 이름
SIZE : 성능의 효율성을 주기 위해 빈 공간을 일정 부분 설정
        크기는 최초에 저장할 데이터의 크기 등을 계산하여 설계 및 설정
        너무 작으면 효율성이 떨어지고, 너무 커도 불필요한 공간 낭비
        Oracle xe(Express Edition)에서는 TableSpace의 최대 크기를 11G로 제한
        만약 size를 10G로 지정하였을 때 용량이 초과되어 AUTO NEXT로 용량이 추가되는 경우 전체 SIZE가 11G를 넘어서면 오류 발생, 더 이상의 데이터 저장 불가
AUTO... NEXT... : 초기에 지정한 SIZE 공간에 데이터가 초과되면 자동으로 용량을 늘려 저장할 수 있도록 함
    SIZE 1M : 기본 크기를 1024*1024 byte 크기로 설정, 설정 시 1MB를 사용하지 않는다(단위기호만 사용)
    NEXT 500K : 자동으로 용량 확장(늘리기) 시 1024*500 크기로 설정, 설정 시 500KB를 사용하지 않는다(단위기호만 사용)
*/
-- CREATE로 시작되는 명령문 : DDL(Data Definition Language), 데이터 선언 및 생성
CREATE TABLESPACE myTS
DATAFILE 'C:/bizwork/workspace/oracle_data/myTS.dbf'
-- 최초 용량을 1mb로 설정해서 생성 후, 증량이 필요할 때마다 자동으로 500kb씩 늘리도록 하는 명령
SIZE 1M AUTOEXTEND ON NEXT 500K;

-- (실습)질의작성기에서 코드를 작성할 때의 약속
/*
DBMS의 SQL은 특별한 일부 경우를 제외하고 대소문자 구별을 하지 않음
DBMS, SQL, Oracle과 관련된 키워드는 전부 대문자로 작성
변수, 값, 내용 등은 소문자 사용
특별히 대소문자 구분이 필요한 경우는 별도 공지
*/

-- DROP : DDL 명령의 CREATE와 반대되는 개념의 명령문
--      데이터를 물리적으로 완전 삭제하는 개념이므로 매우 신중한 사용 필요
DROP TABLESPACE myTS    -- myTS TableSpace를 삭제하면서
INCLUDING CONTENTS AND DATAFILES    -- 연관된 정보와 data file도 함께 삭제
CASCADE CONSTRAINTS;    -- 설정된 권한, 역할 등이 있을 경우에도 일괄 삭제

-- 위에서 생성한 TableSpace관리 및 데이터를 다룰 사용자 생성
CREATE USER user1 IDENTIFIED BY 1234    -- 사용자 ID를 user1으로, 초기 비밀번호를 1234로 설정
DEFAULT TABLESPACE myTS;

-- DCL(Data Control Language)
-- 새로 생성된 user1에게 권한 부여
-- user1이 로그인만 할 수 있도록 하는 권한(역할) 부여
GRANT CONNECT to user1;

-- user1이 로그인할 수 있는 권한 회수
REVOKE CONNECT FROM user1;

-- user1이 로그인 수행 및 데이터를 관리할 수 있는 권한 부여
-- RESOURCE : Oracle에서 user에게 줄 수 있는 권한 중 상당히 많은 일을 수행할 수 있는 권한
-- 현재 시스템에 설치된 모든 TableSpace를 대상으로 무제한(TableSpace가 허용하는 범위 내) 저장
-- RESOURCE 권한은 Standard, Enterprise DBMS에서는 함부로 부여할 수 없음
-- CONNECT와 RESOURCE 권한을 부여하게 되면 DBA와 비슷한 수준의 권한을 가짐
GRANT CONNECT,RESOURCE TO user1;

-- 로그인과 table 생성 권한
GRANT CONNECT,CREATE TABLE TO user1;

-- 로그인과 table 생성, 학생정보 table에 데이터 추가 권한
GRANT CONNECT,CREATE TABLE,INSERT TABLE 학생정보 TO user1;

-- 로그인과 table 생성, 학생정보 추가 및 조회 권한
GRANT CONNECT,CREATE TABLE,INSERT TABLE 학생정보, SELECT TABLE 학생정보 TO user1;

-- 권한을 세부적으로 부여하는 것은 실무상에서 중요하고 또 필요한 일
-- 학습하는 입장에서는 권한 부여에 많은 신경을 기울일 필요가 없으므로 사용자에게 DBA 권한 부여, 실습 수행
GRANT DBA TO user1;

-- DBA 관리자 권한(Roll)은 sysDBA보다 한 단계 낮은 권한 등급을 가진다
-- 일반적으로 자신이 생성한 Table 등 DB Object에만 접근하여 명령 수행