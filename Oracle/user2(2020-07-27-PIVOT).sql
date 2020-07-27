--  user2 접속 화면입니다.

CREATE TABLE tbl_성적 (
    학번 CHAR(5),
    과목명 nVARCHAR2(20),
    점수 NUMBER
);

SELECT * FROM "TBL_성적";

-- 표준 SQL을 이용한 PIVOT
/*
1. 어떤 칼럼을 기준 칼럼을 설정할 것인가 : 학번
    기준 칼럼에 대해 GROUP BY 설정
2. 어떤 칼럼을 GROUP BY로 설정하게 되면 나머지 함수는 통계함수로 감싸거나, GROUP BY에 칼럼을 포함시켜야 한다.
    통계함수 SUM : 여러 개 저장된 학번을 1개만 보이도록 하기 위해 계산되는 각 과목의 점수를 학번을 GROUP BY로 묶음
                    현재 테이블 구조에서 학번+과목의 점수는 전체 데이터에서 1개의 레코드만 존재한다.
                    SUM 함수는 덧셈 연산을 수행하는 용도가 아니라 단순히 GROUP BY를 수행하기 위해 도움을 주는 함수이다.
*/
SELECT 학번,
    SUM(CASE WHEN 과목명='국어' THEN 점수 ELSE 0 END) AS 국어,
    SUM(CASE WHEN 과목명='영어' THEN 점수 ELSE 0 END) AS 영어,
    SUM(CASE WHEN 과목명='수학' THEN 점수 ELSE 0 END) AS 수학
FROM tbl_성적
GROUP BY 학번;

-- Oracle에서 제공하는 DECODE 함수 이용하기
SELECT 학번,
    SUM(DECODE(과목명, '국어', 점수, 0)) AS 국어,
    SUM(DECODE(과목명, '영어', 점수, 0)) AS 영어,
    SUM(DECODE(과목명, '수학', 점수, 0)) AS 수학
FROM tbl_성적
GROUP BY 학번;

-- Oracle 11g부터 지원하는 PIVOT 기능
/*
PIVOT() : 특정한 칼럼을 기준으로 데이터를 PIVOT View로 나타내는 내장 함수
PIVOT(SUM(값)) : PIVOT으로 나열할 데이터 값이 들어있는 칼럼을 SUM()으로 묶어서 표시
FOR 칼럼 : '칼럼'에 '칼럼값'으로 가로(COLUMN)방향 나열하여 가상 칼럼 생성
*/
SELECT 학번, 국어, 영어, 수학
FROM "TBL_성적"
PIVOT (SUM(점수)
    FOR 과목명 IN ('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)) 성적;

CREATE TABLE tbl_학생정보 (
    학번 CHAR(5) PRIMARY KEY,
    학생이름 nVARCHAR2(30) NOT NULL,
    전화번호 VARCHAR2(20),
    주소 nVARCHAR2(125),
    학년 NUMBER,
    학과 CHAR(3)
);

/*
ORA-00918: column ambiguously defined
- 칼럼명 '학번'을 사용하였을 때, 어떤 table에 있는 칼럼인지 알 수 없는 경우
- JOIN을 수행하여 다수의 table이 Relation되었을 때, 다수의 table에 같은 이름의 칼럼이 존재하는 경우 발생하는 오류
- 칼럼명을 영문을 설정할 때 칼럼에 prefix를 붙여 이런 오류를 막을 수 있다.
- 실제 프로젝트에서 여러 table에 DOMAIN 설정(같은 정보를 담는 칼럼)을 생성할 경우 prefix를 통일하기도 한다.

- 이 오류를 방지하기 위해 두 개 이상의 table을 JOIN할 때는 table에 Alias를 설정
- AS.칼럼 형식으로 표기하여 어떤 table의 칼럼인지 명확히 지정하도록 한다.
- JOIN, SUBQUERY를 만들 때 한 개의 table을 여러 번 사용할 경우 반드시 Alias를 설정하고, 칼럼을 명확히 지정한다.
*/
-- 통계함수로 감싸지 않은 칼럼은 반드시 GROUP BY에 명시
SELECT sc."학번", ST.학생이름, ST.전화번호,
    SUM(DECODE(sc.과목명, '국어', sc.점수, 0)) AS 국어,
    SUM(DECODE(sc.과목명, '영어', sc.점수, 0)) AS 영어,
    SUM(DECODE(sc.과목명, '수학', sc.점수, 0)) AS 수학
FROM tbl_성적 SC
    LEFT JOIN "TBL_학생정보" ST
        ON sc."학번"=st."학번"
GROUP BY sc.학번, st.학생이름, st.전화번호;

CREATE VIEW view_성적PIVOT
AS (
    SELECT 학번, 국어, 영어, 수학
    FROM "TBL_성적"
    PIVOT (SUM(점수)
        FOR 과목명 IN ('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)) 성적
);

SELECT * FROM "VIEW_성적PIVOT";

SELECT SC.학번, ST.학생이름, SC.국어, SC.영어, SC.수학
FROM (
    SELECT SC.학번, ST.학생이름, SC.국어, SC.영어, SC.수학
    FROM "VIEW_성적PIVOT" SC
        LEFT JOIN "TBL_학생정보" ST
            ON st."학번"=sc."학번"
) SC
    LEFT JOIN tbl_학생정보 ST
        ON ST.학번=SC.학번
ORDER BY SC.학번;

SELECT SC.학번, ST.학생이름, SC.국어, SC.영어, SC.수학
FROM (
    SELECT 학번, 국어, 영어, 수학
    FROM tbl_성적
        PIVOT (SUM(점수)
        FOR 과목명 IN ('국어' AS 국어, '영어' AS 영어, '수학' AS 수학))
) SC
    LEFT JOIN tbl_학생정보 ST
        ON ST.학번=SC.학번
ORDER BY SC.학번;