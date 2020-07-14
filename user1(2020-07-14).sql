-- user1 사용자의 명령 공간입니다.
-- user1은 DBA 권한을 부여받았으므로 Table 생성, CRUD 등의 명령을 사용 가능

-- DB에 데이터 저장
/*
DB를 대상으로 업무를 수행할 때, 데이터가 있어야만 여러가지 업무를 수행 가능
Create(형 명령) : CRUD 중 가장 먼저 수행해야 할 명령
DML CRUD Create DDL CREATE 명령과 구분 필요

DDL CREATE : 생성, 운영체제와 밀접한 관련이 있거나 물리적인 요소
        CREATE TABLESPACE(저장공간), CREATE USER(사용자)와 같은 Schema 등을 생성하는 명령 절차

DML(Data Manuplation Language, Data Management Language) CREATE
        물리적 저장공간에 실제 발생된 Data 추가 저장
        아직 저장되지 않은 논리적 개념의 데이터를 로컬 스토리에 보관
        DML에서 Create형 명령 키워드 "INSERT"

RDBMS(Relationship DataBase Management System, 관계형 데이터베이스 시스템)
        데이터를 추가하려면 먼저 데이터 저장공간에 대한 정의 선행
        데이터 저장 공간 : 논리적으로 Entity, 물리적으로 Table

Table : 표준 SQL(ANSI SQL)에서 데이터를 추가하는 저장 공간
        저장할 데이터의 각 필드(칼럼) 항목의 type 결정
        저장할 데이터의 최대 길이(크기) 졀정
        데이터 key 지정
        
PRIMARY KEY : 데이터의 key 중 가장 중요한 항목
        데이터를 조회할 때, 프라이머리 키로 조건을 부여하면 유일한 값이 추출
        PK는 절대 중복값이 존재할 수 없음(존재해선 안됨)
        PK는 절대 null값이 존재할 수 없음
*/

-- Table 명명규칙
--    보통 tbl_ 접두사로 시작 : snake_case 형식으로 작성

-- 학생 데이터를 저장하기 위해 학생정보 Table 생성
CREATE TABLE tbl_student (
-- 칼럼(Field) 명명규칙 : 보통 table 이름을 줄여서 접두사 시작, snake_case 형식
/*     문자열 칼럼의 type
        CHAR : 고정길이 문자열, 칼럼에 저장되는 데이터의 길이가 모두 같은 경우
                저장되는 데이터가 설정한 크기보다 작으면 남는 공간에 공백 할당
        VARCHAR2 : 가변길이 문자열, 칼럼에 저장되는 데이터의 길이가 일정하지 않은 경우
                저장되는 데이터가 설정한 크기보다 작으면 저장공간을 줄여서 저장
                저장되는 데이터가 설정한 크기보다 크면 오류 발생
*/
st_num CHAR(5) PRIMARY KEY,
st_name VARCHAR2(20),
st_dept VARCHAR2(20),
st_grade CHAR(1),
st_tel VARCHAR2(20),
st_addr VARCHAR2(125),
st_age NUMBER(3)
);

-- Table을 생성하는 DDL
CREATE TABLE tbl_student (
st_num CHAR(5) PRIMARY KEY,
st_name VARCHAR2(20),
st_dept VARCHAR2(20),
st_grade CHAR(1),
st_tel VARCHAR2(20),
st_addr VARCHAR2(125),
st_age NUMBER(3)
);

-- Table 삭제
DROP TABLE tbl_student;

-- DML의 Create
INSERT INTO tbl_student     -- tbl_student 테이블에 데이터 추가
    (st_num, st_name, st_dept, st_grade, st_tel, st_addr, st_age)   -- 칼럼 나열
VALUES
    ('00001', '홍길동', '무역학과', 3, '010-111-1111', '서울특별시', 30);   -- 데이터
-- 데이터를 INSERT할 때, 실수로 PK 칼럼에 이미 저장된 데이터를  다시 INSERT를 시도하면 UNIQUE 오류 발생(데이터 저장 불가)
--      PK 칼럼의 값이 중복되는 것을 방지하여 데이터 무결성 유지
CREATE TABLE tbl_student (
st_num	CHAR(5)		PRIMARY KEY,
st_name	VARCHAR2(20)	NOT NULL,
st_dept	VARCHAR2(10),
st_grade	NUMBER(1),
st_tel	VARCHAR2(20),
st_addr	VARCHAR2(125),
st_age	NUMBER(3)
);

INSERT INTO tbl_student (st_num, st_name) VALUES ('00001', '홍길동');
INSERT INTO tbl_student (st_num, st_name) VALUES ('00002', '이몽룡');
INSERT INTO tbl_student (st_num, st_name) VALUES ('00003', '성춘향');
INSERT INTO tbl_student (st_num, st_name) VALUES ('00004', '장보고');
INSERT INTO tbl_student (st_num, st_name) VALUES ('00005', '임꺽정');
INSERT INTO tbl_student (st_num, st_name) VALUES ('00006', '장길산');

-- 추출하여 확인 : 조회(Retrive), 읽기(Read)
SELECT *
FROM tbl_student;

-- 두 개의 칼럼을 나열하고 values를 두 개가 아닌 값을 지정하면 INSERT 오류 발생
INSERT INTO tbl_student (st_num, st_name) VALUES ('00007');
INSERT INTO tbl_student (st_num, st_name) VALUES ('00007', '홍길동', 33);

-- 학번만 데이터를 지정하고 INSERT 수행
-- st_name 칼럼이 NOT NULL constraint 설정이 되어있기 때문에 st_name 칼럼과 데이터는 반드시 지정하여 INSERT 수행
INSERT INTO tbl_student (st_num) VALUES ('00007');

-- PK 칼럼과 NOT NULL 칼럼은 반드시 데이터를 지정하여 INSERT 수행
INSERT INTO tbl_student (st_num, st_name) VALUES ('00007', '이자홍');

SELECT * FROM tbl_student;

-- CRUD : Update
/*
tbl_student에 있는 모든 데이터(모든 행=row=record)의 st_dept 칼럼의 값을 컴공과로 변경 명령
    -> 데이터의 갯수에 관계 없이 명령이 수행됨
아래의 UPDATE 명령은 매우 위험하기 때문에 신중히 사용
*/
UPDATE tbl_student
SET st_dept='컴공과';

-- UPDATE 명령은 특별한 경우가 아니면 항상 PK를 기준으로 실행
UPDATE tbl_student
SET st_dept='무역과'
WHERE st_num='00004';

-- 학생 이름(st_name) 칼럼의 값이 성춘향인 모든 데이터를 찾아서 st_dept 칼럼 값을 음악과로 변경 명령
/*
만약 동명이인의 학생이 다수라면 결과 전체가 변경되는(변조) 위험 존재
해당 이름을 가진 학생이 1명이어서 원하는 결과를 얻었더라도 사용해서는 안 되는 명령
모종의 이유로 SELECT를 수행했을 때 보이지 않는(감춰진) 데이터가 존재한다면 변경 명령을 수행해버림
*/
UPDATE tbl_student
SET st_dept='음악과'
WHERE st_name='성춘향';

-- 학번이 00004, 00007, 00001인 핛갱의 학과를 물리학과로 변경하고 싶을 때,
-- 가능하면 PK를 기준으로 한 번에 한 개씩 데이터를 변경하는 명령을 수행하는 것이 좋음
UPDATE tbl_student
SET st_dept='물리학'
WHERE st_num='00004';

UPDATE tbl_student
SET st_dept='물리학'
WHERE st_num='00007';

UPDATE tbl_student
SET st_dept='물리학'
WHERE st_num='00001';

-- 학번이 00002, 00003, 00005, 00006인 학생의 학과를 화학과로 변경하고 싶을 경우
-- 여러 번의 명령을 수행하지 않고 한 번에 변경할 수 있는 방법
UPDATE tbl_student
SET st_dept='화학과'
WHERE st_num='00002' OR
    st_num='00003' OR
    st_num='00005' OR
    st_num='00006';

-- WHERE 칼럼 IN (데이터)
-- 칼럼의 값이 데이터에 나타나면 SET 명령 수행
UPDATE tbl_student
SET st_dept='화학과'
WHERE st_num IN('00002', '00003', '00005', '00006');

SELECT * FROM tbl_student;

-- tbl_student 데이블에 저장된 학생 정보 중 '장보고' 학생의 데이터가 필요 없어 삭제 희망
-- 실무에서 Master Table의 데이터는 함부로 삭제하지 않음
-- 필요 없어진 데이터는 특정 칼럼에 값을 세팅하여 칼럼 값을 기준으로 필요한 데이터, 필요 없는 데이터 구분

-- CRUD DELETE : table에서 데이터 삭제
-- DELETE 명령도 UPDATE 명령과 마찬가지로 반드시 WHERE 절을 동반하는 형태로 명령 수행
--      그렇지 않으면 모든 데이터가 삭제될 수 있음
DELETE FROM tbl_student
WHERE st_num='00004';

-- INSERT, UPDATE, DELETE 명령 수행 후, 명령을 확정
-- COMMIT 이후에는 ROLLBACK으로 해당 명령 취소 불가
COMMIT;

-- 명령 취소
-- INSERT, UPDATE, DELETE 명령 수행을 취소
ROLLBACK;

-- 데이터를 Table 형식으로 출력할 때 모든(*) 칼럼을 전부 출력
-- SELECTION type으로 table 보기
SELECT * FROM tbl_student;

-- 데이터를 Table 형식으로 출력할 때 나열된 칼럼만 출력
-- projection 지정 : SELECT 명령을 수행할 때 원하는 칼럼만 나열하는 것
SELECT
    st_num,
    st_dept,
    st_name,
    st_age
FROM tbl_student;

SELECT st_name FROM tbl_student;

-- SELECTION type 조회
-- 특정 칼럼에 조건을 부여하여 레코드를 제한하는 것
SELECT * FROM tbl_student
WHERE st_name='장길산';

UPDATE tbl_student
SET st_dept='음악과'
WHERE st_num IN('00001', '00003', '00006');

-- st_name+"는"+st_dept+"학과 학생 입니다."
SELECT st_name || '은(는) ' || st_dept || ' 학생입니다.'
FROM tbl_student
WHERE st_dept='음악과';

-- SELECT문을 이요한 사칙연산 구현
SELECT 3+4 FROM DUAL;
SELECT 30*40 FROM DUAL;
SELECT 30-10 FROM DUAL;
SELECT 30/2 FROM DUAL;

-- LIKE 연산자 : 문자열 칼럼에서 특정 문자를 포함한 검색 기능을 구현할 때 사용
SELECT *
FROM tbl_student
WHERE st_name LIKE '%몽%';

-- Table의 구조를 확인하는 명령
DESC tbl_student;

INSERT INTO tbl_student(st_num, st_name, st_dept)
VALUES('00007', '임사홍', '컴퓨터공학');

DROP TABLE tbl_student;

-- 문자열 데이터를 저장하는 칼럼
/*
CHAR : 데이터의 길이가 고정된 칼럼으로, 코드(검색하는 용도의 칼럼) 등을 저장하는 칼럼
VARCHAR2 : 가변문자열, 데이터의 길이가 일정하지 않은 칼럼으로 크기를 지정할 때 가장 길이가 긴 데이터를 기준으로 삼음
nVARCHAR2 : 가변문자열, 유니코드 문자열을 수용하는 칼럼으로 영문자 1글자와 한글 등 1글자를 같은 크기로 취급
*/
CREATE TABLE tbl_student (
st_num	CHAR(5)		PRIMARY KEY,
st_name	nVARCHAR2(20)	NOT NULL,	
st_dept	nVARCHAR2(10),
st_grade	NUMBER(1),
st_tel	nVARCHAR2(20),
st_addr	nVARCHAR2(125),
st_age	NUMBER(3)
);

INSERT INTO tbl_student(st_num, st_name, st_dept)
VALUES('00007', '임사홍', '컴퓨터공학');

SELECT * FROM tbl_student;

DESC tbl_student;

-- SELECT type으로 데이터를 제한하여 보기

-- 학과가 컴퓨터공학인 학생만 출력
SELECT *
FROM tbl_student
WHERE st_dept='컴퓨터공학';

-- 학과가 컴퓨터공학이고, 3학년인 학생만 출력
SELECT *
FROM tbl_student
WHERE st_dept='컴퓨터공학' AND st_grade=3;

-- 학과가 컴퓨터공학이거나 법학인 학생만 출력
SELECT *
FROM tbl_student
WHERE st_dept='컴퓨터공학' OR st_dept='법학';

-- SELECTION으로 레코드를 제한하고 PROJECTION으로 칼럼을 제한하여 보여주기
-- 학과가 컴퓨터공학 또는 법학인 학생들의 정보 중 이름과 학과만 나열
SELECT st_name, st_dept
FROM tbl_student
WHERE st_dept='컴퓨터공학' OR st_dept='법학';

-- IN(포함) 연산자를 사용하여 칼럼에 다수의 조건을 부여하여 값을 가져오기
SELECT st_name, st_dept
FROM tbl_student
WHERE st_dept IN ('컴퓨터공학', '법학');

-- 학년이 2나 3인 학생들
SELECT st_name, st_dept, st_grade
FROM tbl_student
WHERE st_grade>=2 AND st_grade<=3;

SELECT st_name, st_dept, st_grade
FROM tbl_student
WHERE st_grade>1 AND st_grade<4;

-- 시작값과 종료값을 포함한 범위의 데이터 조회
SELECT st_name, st_dept, st_grade
FROM tbl_student
WHERE st_grade BETWEEN 2 AND 3;

-- 문자열 칼럼에 저장된 데이터가 같은 길이이며 format이 같은 경우 부등호(범위연산)를 포함하여 조회 가능
-- 일반 프로그래밍 코드에서는 문자열의 경우 사용 불가
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student
WHERE st_num>='20010' AND st_num<='20020';

/*
칼럼에 날짜가 문자열로 저장되어 있을 경우, 날짜 범위를 설정하여 데이터 조회 가능
WHERE st_num>='2020-01-01' AND st_num<='2020-10-31';
*/

-- 시작값과 종료값이 포함된 범위를 조회하는 코드는 BETWEEN 연산자를 사용하여 조회할 코드로 변환하여 사용 가능
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student
WHERE st_num BETWEEN '20010' AND '20020';