<<<<<<< HEAD
-- user1 화면입니다.

/*
- 이상현상
추가이상, 변경(수정)이상, 삭제이상
 : DBMS에 저장하는(저장된) 데이터를 관리할 때(SELECT 이외 CUD) 문제가 발생하여 원본 데이터가 무결성을 잃는 상황

- 추가이상 방지
PK, UNIQUE, NOT NULL 등의 제약조건을 설정하여 잘못된 데이터가 INSERT되는 현상 방지
PK로 설정된 칼럼은 불가항력(천재지변 등) 문제가 발생하지 않는 한 저장된 값의 변경, 삭제를 해선 안된다.
필요 없는 데이터가 발생하는 경우 데이터를 삭제하는 대신, 특정 칼럼을 하나 마련하여 데이터의 사용유무를 등록 및 관리(실무상 원칙)

- 변경, 삭제 이상 방지
특별한 경우가 아니면 2개 이상의 레코드에 변화가 발생하지 않도록 코드나 관리 설계

- 어떤 테이블에 변경될 가능성이 1이라도 존재하는 칼럼이 있다면 여기에 동일한 값이 중복되어 저장되어 있을 경우
    이 칼럼의 값은 여러 레코드가 변경, 삭제되는 일이 발생할 수 있다.
    더불어 이러한 변경, 삭제를 수행하는 동안 데이터에 문제가 발생할 가능성이 존재한다.

- 데이터베이스의 정규화 : 설계차원에서 변경, 삭제 이상을 막기 위한 조치
*/

-- 학과정보
CREATE TABLE tbl_dept (
d_code CHAR(4)	PRIMARY KEY,
d_name nVARCHAR2(20) NOT NULL,
d_prof nVARCHAR2(20),
d_assist nVARCHAR2(20),
d_tel VARCHAR2(20),
d_addr nVARCHAR2(125)
);

DROP TABLE tbl_dept;

SELECT * FROM tbl_dept;

-- 학생정보를 조회하면서 학과 테이블과 연결하여 조회

/*
1. 기본(*) SELECT 시작
2. FROM절에 출력을 원하는 주table(master)를 작성
3. LEFT JOIN절에 보조 정보가 담긴 Table 작성
4. ON절에 두 테이블의 연관관계를 설정하는 키 지칭
5. SELECT에 필요한 칼럼 나열
*/
SELECT st_num, st_name, st_dept, d_name, d_prof, d_tel, st_grade, st_tel, st_addr
FROM tbl_student
    LEFT JOIN tbl_dept
        ON st_dept=d_code;

-- JOIN이 된 후 보조테이블의 칼럼에 WHERE 조건설정을 하여 SELECTION을 수행할 수 있다.
SELECT st_num, st_name, st_dept, d_name, d_prof, d_tel, st_grade, st_tel, st_addr
FROM tbl_student
    LEFT JOIN tbl_dept
        ON st_dept=d_code
WHERE d_name='법학';

/*
SELECT TABLE에 Alias 설정하기
다수의 table을 JOIN으로 설정하다보면 다른 TABLE의 같은 칼럼명이 존재할 수 있다.
보통은 칼럼에 prefix를 붙여 구분을 명확히 하지만, table이 많아지다보면 같은 이름의 칼럼이 존재할 수 있다.
이러한 상황에서 JOIN을 수행하면 칼럼을 제대로 인식하지 못하여 오류가 발생하는 경우가 다수 존재한다.
이런 경우 table에 Alias를 붙여주면 오류를 막을 수 있다.
보통 [table] AS [alias] 형식으로 작성하지만 Oracle에서는 AS 키워드를 작성하지 않는다(작성 시 오류 발생).
*/
SELECT st_num, st_name, st_dept, d_name, d_prof, d_tel, st_grade, st_tel, st_addr
FROM tbl_student ST
    LEFT JOIN tbl_dept DT
        ON ST.st_dept=DT.d_code
WHERE d_name='법학';

/*
VIEW의 생성

- SELECT 명령문을 사용하여 복잡한 Query를 작성하고, 작성된 Query를 자주 사용하게 될 것으로 예상이 되면
이 Query를 View로 생성해 보관할 수 있다.
- View는 실제 Table과 똑같이 SELECT명령을 통해 데이터를 조회할 수 있지만 실제 데이터를 가지고있지는 않다.
- 원본 Table로부터 Query를 실행하여(보통 임시저장소에 저장) 결과를 보여주는 역할을 수행한다.
- view 내부에서는 정렬 명령을 실행할 수 없고, 조회할 때 정렬하여 출력해야 한다.
*/
CREATE VIEW view_score
AS (SELECT SC.sc_num, ST.st_name, ST.st_tel, ST.st_dept,
            dt.d_name, dt.d_prof, dt.d_tel,
            SC.sc_kor, SC.sc_eng, SC.sc_math, SC.sc_music, SC.sc_art
    FROM tbl_score SC
        LEFT JOIN tbl_student ST
            ON ST.st_num=SC.sc_num
        LEFT JOIN tbl_dept DT
            ON ST.st_dept=DT.d_code);
            
SELECT * FROM view_score;

SELECT * FROM view_score
WHERE sc_num BETWEEN '20001' AND '20010'
ORDER BY sc_num;

SELECT SUBSTR(sc_num, 1, 4) AS NUM,
    SUM(sc_kor), SUM(sc_eng), SUM(sc_math)
FROM view_score
GROUP BY SUBSTR(sc_num, 1, 4);

SELECT *
FROM tbl_student;

-- 중요한 정보를 봐서는 안 되는 사용자가 있을 때, 보여주어도 문제 없는 칼럼만 PROJECTION한 Query를 만들고, VIEW로 생성
-- 이 경우 권한이 제한된 사용자는 꼭 필요한 정보만을 보게되어 보안 및 개인정보보호 등의 용도로 사용할 수 있다.
CREATE VIEW simp_student
AS (SELECT ST.st_num, ST.st_name, ST.st_dept, DT.d_name
    FROM tbl_student ST
        LEFT JOIN tbl_dept DT
            ON st.st_dept=dt.d_code);

DROP VIEW simp_student;

SELECT * FROM simp_student
=======
-- user1 화면입니다.

/*
- 이상현상
추가이상, 변경(수정)이상, 삭제이상
 : DBMS에 저장하는(저장된) 데이터를 관리할 때(SELECT 이외 CUD) 문제가 발생하여 원본 데이터가 무결성을 잃는 상황

- 추가이상 방지
PK, UNIQUE, NOT NULL 등의 제약조건을 설정하여 잘못된 데이터가 INSERT되는 현상 방지
PK로 설정된 칼럼은 불가항력(천재지변 등) 문제가 발생하지 않는 한 저장된 값의 변경, 삭제를 해선 안된다.
필요 없는 데이터가 발생하는 경우 데이터를 삭제하는 대신, 특정 칼럼을 하나 마련하여 데이터의 사용유무를 등록 및 관리(실무상 원칙)

- 변경, 삭제 이상 방지
특별한 경우가 아니면 2개 이상의 레코드에 변화가 발생하지 않도록 코드나 관리 설계

- 어떤 테이블에 변경될 가능성이 1이라도 존재하는 칼럼이 있다면 여기에 동일한 값이 중복되어 저장되어 있을 경우
    이 칼럼의 값은 여러 레코드가 변경, 삭제되는 일이 발생할 수 있다.
    더불어 이러한 변경, 삭제를 수행하는 동안 데이터에 문제가 발생할 가능성이 존재한다.

- 데이터베이스의 정규화 : 설계차원에서 변경, 삭제 이상을 막기 위한 조치
*/

-- 학과정보
CREATE TABLE tbl_dept (
d_code CHAR(4)	PRIMARY KEY,
d_name nVARCHAR2(20) NOT NULL,
d_prof nVARCHAR2(20),
d_assist nVARCHAR2(20),
d_tel VARCHAR2(20),
d_addr nVARCHAR2(125)
);

DROP TABLE tbl_dept;

SELECT * FROM tbl_dept;

-- 학생정보를 조회하면서 학과 테이블과 연결하여 조회

/*
1. 기본(*) SELECT 시작
2. FROM절에 출력을 원하는 주table(master)를 작성
3. LEFT JOIN절에 보조 정보가 담긴 Table 작성
4. ON절에 두 테이블의 연관관계를 설정하는 키 지칭
5. SELECT에 필요한 칼럼 나열
*/
SELECT st_num, st_name, st_dept, d_name, d_prof, d_tel, st_grade, st_tel, st_addr
FROM tbl_student
    LEFT JOIN tbl_dept
        ON st_dept=d_code;

-- JOIN이 된 후 보조테이블의 칼럼에 WHERE 조건설정을 하여 SELECTION을 수행할 수 있다.
SELECT st_num, st_name, st_dept, d_name, d_prof, d_tel, st_grade, st_tel, st_addr
FROM tbl_student
    LEFT JOIN tbl_dept
        ON st_dept=d_code
WHERE d_name='법학';

/*
SELECT TABLE에 Alias 설정하기
다수의 table을 JOIN으로 설정하다보면 다른 TABLE의 같은 칼럼명이 존재할 수 있다.
보통은 칼럼에 prefix를 붙여 구분을 명확히 하지만, table이 많아지다보면 같은 이름의 칼럼이 존재할 수 있다.
이러한 상황에서 JOIN을 수행하면 칼럼을 제대로 인식하지 못하여 오류가 발생하는 경우가 다수 존재한다.
이런 경우 table에 Alias를 붙여주면 오류를 막을 수 있다.
보통 [table] AS [alias] 형식으로 작성하지만 Oracle에서는 AS 키워드를 작성하지 않는다(작성 시 오류 발생).
*/
SELECT st_num, st_name, st_dept, d_name, d_prof, d_tel, st_grade, st_tel, st_addr
FROM tbl_student ST
    LEFT JOIN tbl_dept DT
        ON ST.st_dept=DT.d_code
WHERE d_name='법학';

/*
VIEW의 생성

- SELECT 명령문을 사용하여 복잡한 Query를 작성하고, 작성된 Query를 자주 사용하게 될 것으로 예상이 되면
이 Query를 View로 생성해 보관할 수 있다.
- View는 실제 Table과 똑같이 SELECT명령을 통해 데이터를 조회할 수 있지만 실제 데이터를 가지고있지는 않다.
- 원본 Table로부터 Query를 실행하여(보통 임시저장소에 저장) 결과를 보여주는 역할을 수행한다.
- view 내부에서는 정렬 명령을 실행할 수 없고, 조회할 때 정렬하여 출력해야 한다.
*/
CREATE VIEW view_score
AS (SELECT SC.sc_num, ST.st_name, ST.st_tel, ST.st_dept,
            dt.d_name, dt.d_prof, dt.d_tel,
            SC.sc_kor, SC.sc_eng, SC.sc_math, SC.sc_music, SC.sc_art
    FROM tbl_score SC
        LEFT JOIN tbl_student ST
            ON ST.st_num=SC.sc_num
        LEFT JOIN tbl_dept DT
            ON ST.st_dept=DT.d_code);
            
SELECT * FROM view_score;

SELECT * FROM view_score
WHERE sc_num BETWEEN '20001' AND '20010'
ORDER BY sc_num;

SELECT SUBSTR(sc_num, 1, 4) AS NUM,
    SUM(sc_kor), SUM(sc_eng), SUM(sc_math)
FROM view_score
GROUP BY SUBSTR(sc_num, 1, 4);

SELECT *
FROM tbl_student;

-- 중요한 정보를 봐서는 안 되는 사용자가 있을 때, 보여주어도 문제 없는 칼럼만 PROJECTION한 Query를 만들고, VIEW로 생성
-- 이 경우 권한이 제한된 사용자는 꼭 필요한 정보만을 보게되어 보안 및 개인정보보호 등의 용도로 사용할 수 있다.
CREATE VIEW simp_student
AS (SELECT ST.st_num, ST.st_name, ST.st_dept, DT.d_name
    FROM tbl_student ST
        LEFT JOIN tbl_dept DT
            ON st.st_dept=dt.d_code);

DROP VIEW simp_student;

SELECT * FROM simp_student
>>>>>>> 7f2c4a511c3155817e54714db99b97f6f7934a92
ORDER BY st_num;