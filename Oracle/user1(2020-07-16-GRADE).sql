-- user1으로 접속한 화면입니다.

SELECT * FROM tbl_student;

/* SELECTION 연산
전체 데이터에서 필요한 레코드만 추출하기 */

-- PK 칼럼에 1개의 조건을 부여하여 조회
-- 이 경우 반드시 1개의 레코드(결과값)만 나타나게 된다.
SELECT * FROM tbl_student
WHERE st_num='20010';

-- KEY로 사용되지 않는 칼럼에 1개의 조건을 부여하여 조회
-- 이 경우 1개의 레코드만 보일지라도 리스트(복수)형으로 춮력된다.
SELECT * FROM tbl_student
WHERE st_name='남동예';

-- PK 칼럼에 2개 이상의 조건을 부여하여 조회
-- 만약 결과가 1개의 레코드만 보일지라도 리스트(복수)형으로 출력된다.
SELECT * FROM tbl_student
WHERE st_num='20010' OR st_num='20020' OR st_num='20030';

-- 1개의 칼럼에 다수의 OR 조건을 부여하여 SELETION할 때는 IN 연산자를 사용할 수 있다.
SELECT * FROM tbl_student
WHERE st_num IN ('20010', '20020', '20030');

-- 1개의 칼럼 값을 범위로 제한하는 SELECTION
-- 부등호연산은 숫자 칼럼에만 적용되는 것이 원칙이지만, 문자열로 저장된 데이터의 길이와 패턴이 같으면 부등호 연산이 가능하다.
SELECT * FROM tbl_student
WHERE st_num>='20010' AND st_num<='20030';

-- 범위를 지정할 때 시작값과 종료값이 포함되는 연산(이상, 이하)을 수행하는 경우 BETWEEN 연산자 사용이 가능하다.
SELECT * FROM tbl_student
WHERE st_num BETWEEN '20010' AND '20020';

/* PROJECTION
table에 있는 칼럼 중 내가 원하는 칼럼만 출력되도록 제한하는 것*/

SELECT st_num, st_name, st_dept
FROM tbl_student;

SELECT * FROM tbl_score;

-- PROJECTION 연산
SELECT sc_num, sc_kor, sc_eng, sc_math, sc_music, sc_art,
    (sc_kor+sc_eng+sc_math+sc_music+sc_art) AS 총점,
    /*ROUND : 실수(float)를 반올림하는 함수
      ROUND(값) : 소수점 이하를 반올림하고 정수로 표현
      ROUNT(값, 자릿수) : 자릿수+1에서 반올림하여 자릿수까지 표현*/
    ROUND ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) AS 평균
    
    /*무조건 자르기(절사)
    TRUNC(값) : 소수점 이하를 모두 버리는 함수
    TRUNC(값, 자릿수) : 자릿수+1 이하 모두 버리기*/
    -- TRUNC ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) AS 평균1
FROM tbl_score;

SELECT SUM(sc_kor) AS 국어총점,
        SUM(sc_eng) AS 영어총점,
        SUM(sc_math) AS 수학총점,
        SUM(sc_music) AS 음악총점,
        SUM(sc_art) AS 미술총점,
        SUM((sc_kor+sc_eng+sc_math+sc_music+sc_art)) AS 총점,
        AVG(ROUND ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5)) AS 평균
FROM tbl_score;

-- sc_kor 칼럼의 값을 기준으로 전체 리스트를 오름차순 정렬
SELECT * FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010'
ORDER BY sc_kor;

SELECT * FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010'
ORDER BY sc_eng;

-- 계산을 위한 '총점' 칼럼을 PROJECTION에서 선언하고, '총점' 칼럼을 기준으로 오름차순 정렬
-- ASCENDING : 오름차순 정렬(생략 가능)
SELECT sc_num, sc_kor, sc_eng, sc_math, sc_music, sc_art, (sc_kor+sc_eng+sc_math+sc_music+sc_art) AS 총점
FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010'
ORDER BY 총점 ASC;

-- 계산을 위한 '총점' 칼럼을 PROJECTION에서 선언하고, '총점' 칼럼을 기준으로 내림차순 정렬
-- DESCENDING : 내림차순 정렬
SELECT sc_num, sc_kor, sc_eng, sc_math, sc_music, sc_art, (sc_kor+sc_eng+sc_math+sc_music+sc_art) AS 총점
FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010'
ORDER BY 총점 DESC;

-- 학생 이름 칼럼을 오름차순으로 정렬하여 전체 리스트 출력
-- ORDER BY 명령어는 어떤 칼럼이든 가능하지만, 데이터의 길이와 패턴이 일정하지 않다면 정확한 결과를 보지 못 할 수도 있다.
SELECT * FROM tbl_student
WHERE st_num BETWEEN '20001' AND '20010'
ORDER BY st_name;

-- 2개 이상의 칼럼 정렬
-- st_dept 칼럼으로 먼저 정렬을 수행하고, st_dept 칼럼 값이 같은 경우 그 범위(그룹, 파티션) 내에서 st_name을 기준으로 정렬
SELECT * FROM tbl_student
WHERE st_num BETWEEN '20001' AND '20010'
ORDER BY st_dept, st_name;

-- 부분합 연산
-- st_dept 칼럼 값이 같은 레코드끼리 묶고(그룹화), 그룹의 레코드 갯수 세기
SELECT st_dept, COUNT(st_dept)
FROM tbl_student
GROUP BY st_dept;

-- 그룹 COUNT를 수행하고, st_dept 칼럼을 기준으로 오름차순 정렬
SELECT st_dept, COUNT(st_dept)
FROM tbl_student
GROUP BY st_dept
ORDER BY st_dept;

/* SUBSTR
Oracle에서만 사용하는 문자열 함수
sc_num 칼럼에 담긴 문자열을 1번째부터 4번째 글자까지 잘라서 출력
*/
SELECT SUBSTR(sc_num, 1, 4)
FROM tbl_score;

SELECT SUBSTR(sc_num, 1, 4)
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4);

/* 
DB에서의 코드(코드블록)
학번을 20001~20100으로 구성하고 어떤 칼럼의 값을 정할 때
규칙을 만들고 해당 칼럼을 PK로 삼아서 레코드의 유일함을 보증하는 용도로 사용하는 값들

(학과)코드
학과 D001~D010
규칙을 정해서 만들고, 학과 레코드의 유일함을 보증하는 용도로 사용한다.
*/

SELECT SUBSTR(sc_num, 1, 4) AS 반,
        SUM(sc_kor) AS 국어총점,
        SUM(sc_eng) AS 영어총점
FROM tbl_score
WHERE 1=1 -- WHERE절은 FROM절 바로 다음에 위치하여야 한다.
-- 1=1은 항상 true이기 때문에 전체를 지칭하는 것과 같다
GROUP BY SUBSTR(sc_num, 1, 4)
ORDER BY 반; -- SELECT 명령문의 가장 마지막에 작성하여야 한다.