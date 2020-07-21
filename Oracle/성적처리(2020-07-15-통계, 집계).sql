-- grade 화면입니다.

-- @@집계, 통계 함수@@
-- SQL에서는 기본적인 명령어, 연산자 등과 함께 많이 사용되는 집계함수가 있다.
/*
SUM() : 합계
COUNT() : 갯수
AVG() : 평균
MAX() : 최댓값
MIN() : 최솟값
    숫자형(일반적)으로 되어있는 칼럼에 저장된 값을 추출하여 집계, 통계를 수행하는 함수
    SELECT 칼럼을 감싸는 형태로 사용
*/

--tbl_student에 저장된 전체 레코드가 몇 개인지 출력
SELECT COUNT(*) FROM tbl_student;
SELECT COUNT(st_num) FROM tbl_student;
SELECT COUNT(st_name) FROM tbl_student;

-- tbl_student의 칼럼 중 st_grade와 st_age는 숫자 칼럼인데, 이 칼럼에 저장된 값의 합계 구하기
SELECT st_grade FROM tbl_student;
SELECT SUM(st_grade) FROM tbl_student;
SELECT SUM(st_grade), SUM(st_age) FROM tbl_student;

-- tbl_student의 칼럼 중 st_grade 칼럼에 저장된 값들의 평균 구하기
SELECT AVG(st_grade), AVG(st_age) FROM tbl_student;

-- tbl_student의 st_grade 칼럼에 저장된 값 중에서 최댓값과 최솟값 구하기
SELECT MAX(st_grade), MIN(st_grade) FROM tbl_student;

--------------------------------------------------------------------------------------------------

-- @@데이터를 조건별로 묶어서 보기@@

-- tbl_student 데이터 중에서 학과가 어떠한 학과가 있는지 알고싶을 경우
-- 학과 이름이 중복된 경우가 많은 상황에서 학과명을 한 개씩 추출하여 리스트로 출력
-- st_dept 칼럼에 저장된 값들을 같은 값끼리 그룹짓고, 이름을 한 개씩만 나열하도록 하는 명령
SELECT st_dept FROM tbl_student
GROUP BY st_dept;

SELECT st_grade FROM tbl_student
GROUP BY st_grade;

-- st_name 칼럼에 저장된 값들 중 중복값이 없어 GROUP BY가 의미 없는 경우
SELECT st_name FROM tbl_student
GROUP BY st_name;

-- 데이터의 학과 이름을 그룹짓고, 각 학과에 소속된 학생 수 파악
-- st_dept 칼럼으로 그룹을 만들고, 그룹에 속하는 레코드가 몇 개인지 세어(count) 출력
SELECT st_dept, COUNT(*) FROM tbl_student
GROUP BY st_dept;

-- 학년별 학생 수 파악
-- st_grade 칼럼으로 그룹을 만들고, 그룹에 속하는 레코드가 몇 개인지 세어(count) 출력
SELECT st_grade, COUNT(*) FROM tbl_student
GROUP BY st_grade;

-- COUNT에 기호 * 대신, 특정 칼럼을 입력하여도 같은 결과가 출력된다.
SELECT st_grade, COUNT(st_num), COUNT(st_name) FROM tbl_student
GROUP BY st_grade;

-- COUNT(칼럼명) 문법에서 칼럼명은 중요하지 않다(어떤 칼럼명을 사용하여도 결과는 같음).
SELECT st_grade, COUNT(st_grade) FROM tbl_student
GROUP BY st_grade;

-- 각 학과별 소속 학생들의 나이 합계 파악
SELECT st_dept, SUM(st_age) FROM tbl_student
GROUP BY st_dept;

-- 각 학과별 소속 학생들의 나이 평균 파악
SELECT st_dept, AVG(st_age) FROM tbl_student
GROUP BY st_dept;

-- 각 학과별 소속 학생 중 최연장자와 최연소자 파악
-- 단, 최연장(소)자의 이름은 현재 SQL 구문으로 파악하기 어려움
SELECT st_dept, MAX(st_age), MIN(st_age) FROM tbl_student
GROUP BY st_dept;

-- SQL 명령문 : Query(질의)문