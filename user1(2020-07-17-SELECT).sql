<<<<<<< HEAD
-- user1 접속 화면입니다.

SELECT * FROM tbl_dept;

/*
PROJECTION과 SELECTION

DB공학에서 사용하는 논리적인 차원의 DB 관련 용어로, 실무에서는 별로 사용하지 않는 단어이다.
*/
-- PROJECTION
SELECT d_code, d_name, d_prof
FROM tbl_dept;

-- SELECTION
SELECT * FROM tbl_dept
WHERE d_name='관광학';

-- 현재 학과테이블의 학과명 중 관광학과를 관광정보학으로 변경
-- 1. 내가 변경하고자 하는 조건과 일치하는 데이터 존재여부 확인
SELECT * FROM tbl_dept
WHERE d_name='관광학';

-- 2. SELECTION 결과가 1개의 레코드만 출력되어도 d_name은 PK가 아니다.
--    출력된 데이터는 리스트기 때문에 d_name='관광학' 조건으로 UPDATE를 실행해선 안된다.
--    코드 예시 : UPDATE tbl_dept SET d_name='관광정보학' WHERE d_name='관광학'
-- 3. 조회된 결과에서 PK가 무엇인지 파악해야 한다.
-- 4. PK를 조건으로 데이터 UPDATE를 수행하여야 한다.
UPDATE tbl_dept
SET d_name='관광정보학'
WHERE d_code='D001';

SELECT * FROM tbl_dept;

INSERT INTO tbl_dept(d_code, d_name, d_prof)
VALUES ('D006', '무역학', '장길산');

/* DELETE

- DBMS의 스키마에 포함된 Table 중 여러 업무를 수행하는 데 필요한 Table을 보통 Master Data Table이라고 한다.
    예 : 학생정보, 학과정보
    Master Data는 초기에 INSERT가 수행된 후 업무가 진행되는 동안 가급적 데이터를 변경, 삭제하는 일이 최소화되어야 한다.
    Master Data와 Relation하여 생성되는 여러 데이터들의 무결성을 위해서 Master Data는 변경을 최소화하면서 유지해야 한다.
- DBMS의 스키마에 포함된 Table 중에 수시로 데이터의 추가, 변경, 삭제가 필요한 Table을 보통 Work Data Table이라고 한다.
    예 : 성적정보
    Work Data는 수시로 데이터가 추가되고, 여러가지 연산을 수행하여 통계 및 집계 보고서를 작성하는 기본 데이터가 된다.
    통계 및 집계 보고서를 작성한 후 데이터를 검증하였을 때 이상이 있으면 데이터를 수정, 삭제하여 정정하는 과정이 이루어진다.
    Work Data는 Master Table과 Relation을 잘 연동하여 데이터를 INSERT하는 단계부터 잘못된 데이터의 추가를 막아줄 필요가 있다.
    이 때 설정하는 조건 중 외래키 연관 조건이 있다.
*/

SELECT * FROM tbl_score;

INSERT INTO tbl_score(sc_num) VALUES(100);

COMMIT;

UPDATE tbl_score        -- 변경할 테이블
SET sc_kor=90           -- 변경 대상 = 값
WHERE sc_num='20015';   -- 조건(UPDATE에서 WHERE절은 선택사항이지만 실무에서는 필수로 인식)

UPDATE tbl_score
SET sc_kor=90, sc_math=90   -- 다수의 칼럼 값을 변경하고자 할때(칼럼1=값, 칼럼2=값)
WHERE sc_num='20015';

SELECT * FROM tbl_score;

SELECT * FROM tbl_score
WHERE sc_num='20015';

UPDATE tbl_score
SET sc_kor=100;

SELECT * FROM tbl_score;

-- 보통 SQL문으로 CUD를 수행하고 난 직후에는 Table의 변경된 데이터가 물리적(스토리지)으로 반영되지 않은 상태
-- 스토리지에 데이터 변경이 반영되기 전에 ROLLBACK 명령을 수행하면 변경 내용이 모두 제거(취소)된다.
-- ROLLBACK 명령을 잘못 수행하면, 정상적으로 변경(CUD)이 필요한 데이터마저 변경이 취소되어 문제를 일으킬 수 있다.
-- INSERT를 수행하고 난 직후에는 데이터의 변경이 물리적으로 반영될 수 있도록 COMMIT 명령을 수행해준다.
-- UPDATE나 DELETE는 수행 직후 반드시 SELECT를 수행하여 원하는 결과가 잘 반영되었는지 확인하는 것이 좋다.
ROLLBACK;

SELECT * FROM tbl_score;

-- 20020 학번의 학생이 시험 당일 결석하여 미응시 상태인데 성적이 입력된 경우 성적데이터는 삭제되어야 한다.
-- 이 경우 20020 학생이 정말 시험일에 결석하였는지 확인하는 절차가 필요하다.
-- 20020 학생의 학생정보를 확인하고, 만약 학생의 성적정보가 등록되어 있다면 삭제 명령을 수행한다.
SELECT * FROM tbl_student
WHERE st_num='20020';

-- 아래 Query문을 실행했을 때, 학생정보는 출력되고 성적정보 칼럼 값들이 모두 NULL로 나타나는 경우 이 학생의 성적 정보는 등록되지 않은 것
--  따라서 데이터 삭제 과정이 필요하지 않다.
-- 학생정보와 함께 성적정보 칼럼의 값들이 1개라도 NULL이 아닌 경우, 학생의 성적정보는 등록된 것
--  따라서 데이터 삭제 과정이 필요하다.
SELECT *
FROM tbl_student ST
    LEFT JOIN tbl_score SC
        ON st.st_num=sc.sc_num
WHERE ST.ST_NUM='20020';

-- sc_num 데이터에 없는 조건을 부여하면 DELETE를 수행하지 않을 뿐 오류가 발생하지는 않는다.
DELETE FROM tbl_score
WHERE sc_num='20020';

ROLLBACK;

-- 성적데이터의 국어점수가 가장 높은 값과 가장 낮은 값 추출
SELECT MAX(sc_kor), MIN(sc_kor)
FROM tbl_score;

INSERT INTO tbl_score(sc_num, sc_kor) VALUES('20101', 49);
INSERT INTO tbl_student(st_num) VALUES('20101');

-- 최고점 100점, 최저점 50점을 추출한 상태에서 이 점수를 받은 학생이 누구인지 출력
SELECT ST.st_num, ST.st_name, SC.sc_kor
FROM tbl_student ST
    LEFT JOIN tbl_score SC
        ON ST.st_num=SC.sc_num
WHERE SC.sc_kor=100 OR SC.sc_kor=50;

/* SubQuery
- 두 번 이상 SELECT를 수행해서 결과를 출력해야 하는 경우
- 첫 번째 SELECT 결과를 두 번째 SELECT에 주입하여 동시에 두 번 이상의 SELECT를 수행하는 방법
- SubQuery는 JOIN으로 모두 구현 가능하다.
    간단한 동작을 요구할 때는 SubQuery를 사용하는 것이 쉬운 방법
- Oracle 관련 정보들(구글링) 중에 JOIN보다는 SubQuery를 사용한 예제가 많아 코딩에 다소 유리한 면 존재
- SubQuery를 사용하게 되면 SELECT가 여러번 실행되기 때문에 코드가 약간만 변경되어도 결과 출력이 느려진다.
*/
-- WHERE절에서 SubQuery 사용하기
-- 형식 :WHERE 칼럼명 괄호를 포함한 SELECT Query
-- SubQuery로 작동되는 SELECT문은 기본적으로 1개의 결과만 출력되어야 한다.
-- SubQuery에 의해 연산된 결과값을 기준으로 칼럼에 조건문을 부여하는 방식
-- SubQuery는 method나 함수를 호출하는 것과 같이 SubQuery가 return해주는 값을 칼럼과 비교하여 최종 결과값을 출력
SELECT ST.st_num, ST.st_name, SC.sc_kor
FROM tbl_student ST
    LEFT JOIN tbl_score SC
        ON ST.st_num=SC.sc_num
WHERE SC.sc_kor=
    (
        SELECT MAX(sc_kor) FROM tbl_score
    )
OR SC.sc_kor=
    (
        SELECT MIN(sc_kor) FROM tbl_score
    );
    
-- 국어점수의 평균을 구하고, 평균 이상의 점수를 얻은 학생의 리스트 출력
SELECT AVG(sc_kor) FROM tbl_score;

SELECT *
FROM tbl_score
WHERE sc_kor>=77.99;

SELECT *
FROM tbl_score
WHERE sc_kor>=
(
    SELECT AVG(sc_kor) FROM tbl_score
);

-- 각 학생의 점수 평균을 구하고 전체 학생의 평균을 구하여 전체 평균점수보다 높은 평균점수의 학생 리스트 출력
-- 전체 학생 평균
SELECT AVG((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5)
FROM tbl_score;
-- 약 75.2

-- 학생별 평균
SELECT sc_num, ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5)
FROM tbl_score;

/* SELECT SubQuery문이 실행되는 순서
1. FROM절이 실행되어 tbl_score Table의 정보(칼럼정보)를 가져오기
2. WHERE절이 싱행되어 실제 가져올 데이터 선별
3. GROUP BY절이 실행되어 중복된 데이터를 묶어서 하나로 만들기
4. SELECT에 나열된 칼럼에 값 채워넣기
5. SELECT에 정의된 수식을 연산, 결과 출력 준비
6. ORDER BY는 모든 Query가 실행된후 가장 마지막에 수행

따라서 WHERE절과 GROUP BY절에서는 Alias로 설정된 칼럼 이름을 사용할 수 없다(ORDER BY에서는 사용 가능). */

-- 전체 평균점수보다 높은 평균점수의 학생
SELECT sc_num, sc_kor, sc_eng, sc_math, sc_music, sc_art, ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) AS 평균
FROM tbl_score
WHERE ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) >=
(
    SELECT AVG((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) FROM tbl_score
);

-- 위의 Query를 활용하여 평균을 구하는 조건은 그대로 유지하고, 학번이 20020 이전인 학생들만 추출
SELECT sc_num, sc_kor, sc_eng, sc_math, sc_music, sc_art, ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) AS 평균
FROM tbl_score
WHERE ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) >=
(
    SELECT AVG((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) FROM tbl_score
)
AND sc_num<'20020';

-- 성적테이블에서 학번의 문자열 자르기를 수행하여 반 명칭만 추출


-- 추출된 반 명칭이 '2006'보다 작은 값을 갖는 반만 추출
/* HAVING
- WHERE절과 비슷한 성질을 가진다.
- GROUP BY로 묶이거나 통계함수로 생성된 값을 대상으로 WHERE연산을 수행하는 명령어 */
SELECT SUBSTR(sc_num, 1, 4) AS 반
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4)
HAVING SUBSTR(sc_num, 1, 4)<'2006'
ORDER BY 반;

-- 각 반의 평균을 구하고 특정 범위의 평균 점수를 가지는 반 구하기
SELECT SUBSTR(sc_num, 1, 4) AS 반, ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) AS 반평균
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4)
HAVING ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) > 75   -- 반 평균이 75점 이상인 반만 출력
ORDER BY 반;

SELECT SUBSTR(sc_num, 1, 4) AS 반, ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) AS 반평균
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4)
HAVING ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) >=
(
    SELECT ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) FROM tbl_score
);
ORDER BY 반;

-- 2000~2005은 A그룹, 2006~2010은 B그룹일 때
-- 반 이름이 '2005' 이하인 A그룹의 반의 평균 구하기
SELECT SUBSTR(sc_num, 1, 4) AS 반, ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) AS 반평균
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4)
HAVING SUBSTR(sc_num, 1, 4) <= '2005'
ORDER BY 반;
/*
HAVING과 WHERE
- 두 가지 모두 결과를 SELECTION하는 조건문 설정 방식이다.
    HAVING : 그룹으로 묶이거나 통계함수로 연산된 결과를 조건으로 설정하는 방식
    WHERE : 어떤 연산이 수행되기 전 원본 데이터를 조건으로 제한하는 방식
- 어쩔 수 없이 통계 결과를 제한할 때는 HAVING 사용
- WHERE절에서 조건을 설정하여 데이터를 제한한 후 연산 수행이 가능하다면 WHERE 사용을 우선 조건으로 설정
- HAVING, WHERE조건이 없으면 전체 데이터를 상대로 상당한 연산을 수행한 후 조건을 설정하므로
    WHERE 조건을 설정할 때보다 처리가 상대적으로 느리다.

- ORDER BY 연산이 가장 늦게 실행되고 처리 속도도 가장 느리다.
*/
SELECT SUBSTR(sc_num, 1, 4) AS 반, ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) AS 반평균
FROM tbl_score
WHERE SUBSTR(sc_num, 1, 4) <= '2005'
GROUP BY SUBSTR(sc_num, 1, 4)
=======
-- user1 접속 화면입니다.

SELECT * FROM tbl_dept;

/*
PROJECTION과 SELECTION

DB공학에서 사용하는 논리적인 차원의 DB 관련 용어로, 실무에서는 별로 사용하지 않는 단어이다.
*/
-- PROJECTION
SELECT d_code, d_name, d_prof
FROM tbl_dept;

-- SELECTION
SELECT * FROM tbl_dept
WHERE d_name='관광학';

-- 현재 학과테이블의 학과명 중 관광학과를 관광정보학으로 변경
-- 1. 내가 변경하고자 하는 조건과 일치하는 데이터 존재여부 확인
SELECT * FROM tbl_dept
WHERE d_name='관광학';

-- 2. SELECTION 결과가 1개의 레코드만 출력되어도 d_name은 PK가 아니다.
--    출력된 데이터는 리스트기 때문에 d_name='관광학' 조건으로 UPDATE를 실행해선 안된다.
--    코드 예시 : UPDATE tbl_dept SET d_name='관광정보학' WHERE d_name='관광학'
-- 3. 조회된 결과에서 PK가 무엇인지 파악해야 한다.
-- 4. PK를 조건으로 데이터 UPDATE를 수행하여야 한다.
UPDATE tbl_dept
SET d_name='관광정보학'
WHERE d_code='D001';

SELECT * FROM tbl_dept;

INSERT INTO tbl_dept(d_code, d_name, d_prof)
VALUES ('D006', '무역학', '장길산');

/* DELETE

- DBMS의 스키마에 포함된 Table 중 여러 업무를 수행하는 데 필요한 Table을 보통 Master Data Table이라고 한다.
    예 : 학생정보, 학과정보
    Master Data는 초기에 INSERT가 수행된 후 업무가 진행되는 동안 가급적 데이터를 변경, 삭제하는 일이 최소화되어야 한다.
    Master Data와 Relation하여 생성되는 여러 데이터들의 무결성을 위해서 Master Data는 변경을 최소화하면서 유지해야 한다.
- DBMS의 스키마에 포함된 Table 중에 수시로 데이터의 추가, 변경, 삭제가 필요한 Table을 보통 Work Data Table이라고 한다.
    예 : 성적정보
    Work Data는 수시로 데이터가 추가되고, 여러가지 연산을 수행하여 통계 및 집계 보고서를 작성하는 기본 데이터가 된다.
    통계 및 집계 보고서를 작성한 후 데이터를 검증하였을 때 이상이 있으면 데이터를 수정, 삭제하여 정정하는 과정이 이루어진다.
    Work Data는 Master Table과 Relation을 잘 연동하여 데이터를 INSERT하는 단계부터 잘못된 데이터의 추가를 막아줄 필요가 있다.
    이 때 설정하는 조건 중 외래키 연관 조건이 있다.
*/

SELECT * FROM tbl_score;

INSERT INTO tbl_score(sc_num) VALUES(100);

COMMIT;

UPDATE tbl_score        -- 변경할 테이블
SET sc_kor=90           -- 변경 대상 = 값
WHERE sc_num='20015';   -- 조건(UPDATE에서 WHERE절은 선택사항이지만 실무에서는 필수로 인식)

UPDATE tbl_score
SET sc_kor=90, sc_math=90   -- 다수의 칼럼 값을 변경하고자 할때(칼럼1=값, 칼럼2=값)
WHERE sc_num='20015';

SELECT * FROM tbl_score;

SELECT * FROM tbl_score
WHERE sc_num='20015';

UPDATE tbl_score
SET sc_kor=100;

SELECT * FROM tbl_score;

-- 보통 SQL문으로 CUD를 수행하고 난 직후에는 Table의 변경된 데이터가 물리적(스토리지)으로 반영되지 않은 상태
-- 스토리지에 데이터 변경이 반영되기 전에 ROLLBACK 명령을 수행하면 변경 내용이 모두 제거(취소)된다.
-- ROLLBACK 명령을 잘못 수행하면, 정상적으로 변경(CUD)이 필요한 데이터마저 변경이 취소되어 문제를 일으킬 수 있다.
-- INSERT를 수행하고 난 직후에는 데이터의 변경이 물리적으로 반영될 수 있도록 COMMIT 명령을 수행해준다.
-- UPDATE나 DELETE는 수행 직후 반드시 SELECT를 수행하여 원하는 결과가 잘 반영되었는지 확인하는 것이 좋다.
ROLLBACK;

SELECT * FROM tbl_score;

-- 20020 학번의 학생이 시험 당일 결석하여 미응시 상태인데 성적이 입력된 경우 성적데이터는 삭제되어야 한다.
-- 이 경우 20020 학생이 정말 시험일에 결석하였는지 확인하는 절차가 필요하다.
-- 20020 학생의 학생정보를 확인하고, 만약 학생의 성적정보가 등록되어 있다면 삭제 명령을 수행한다.
SELECT * FROM tbl_student
WHERE st_num='20020';

-- 아래 Query문을 실행했을 때, 학생정보는 출력되고 성적정보 칼럼 값들이 모두 NULL로 나타나는 경우 이 학생의 성적 정보는 등록되지 않은 것
--  따라서 데이터 삭제 과정이 필요하지 않다.
-- 학생정보와 함께 성적정보 칼럼의 값들이 1개라도 NULL이 아닌 경우, 학생의 성적정보는 등록된 것
--  따라서 데이터 삭제 과정이 필요하다.
SELECT *
FROM tbl_student ST
    LEFT JOIN tbl_score SC
        ON st.st_num=sc.sc_num
WHERE ST.ST_NUM='20020';

-- sc_num 데이터에 없는 조건을 부여하면 DELETE를 수행하지 않을 뿐 오류가 발생하지는 않는다.
DELETE FROM tbl_score
WHERE sc_num='20020';

ROLLBACK;

-- 성적데이터의 국어점수가 가장 높은 값과 가장 낮은 값 추출
SELECT MAX(sc_kor), MIN(sc_kor)
FROM tbl_score;

INSERT INTO tbl_score(sc_num, sc_kor) VALUES('20101', 49);
INSERT INTO tbl_student(st_num) VALUES('20101');

-- 최고점 100점, 최저점 50점을 추출한 상태에서 이 점수를 받은 학생이 누구인지 출력
SELECT ST.st_num, ST.st_name, SC.sc_kor
FROM tbl_student ST
    LEFT JOIN tbl_score SC
        ON ST.st_num=SC.sc_num
WHERE SC.sc_kor=100 OR SC.sc_kor=50;

/* SubQuery
- 두 번 이상 SELECT를 수행해서 결과를 출력해야 하는 경우
- 첫 번째 SELECT 결과를 두 번째 SELECT에 주입하여 동시에 두 번 이상의 SELECT를 수행하는 방법
- SubQuery는 JOIN으로 모두 구현 가능하다.
    간단한 동작을 요구할 때는 SubQuery를 사용하는 것이 쉬운 방법
- Oracle 관련 정보들(구글링) 중에 JOIN보다는 SubQuery를 사용한 예제가 많아 코딩에 다소 유리한 면 존재
- SubQuery를 사용하게 되면 SELECT가 여러번 실행되기 때문에 코드가 약간만 변경되어도 결과 출력이 느려진다.
*/
-- WHERE절에서 SubQuery 사용하기
-- 형식 :WHERE 칼럼명 괄호를 포함한 SELECT Query
-- SubQuery로 작동되는 SELECT문은 기본적으로 1개의 결과만 출력되어야 한다.
-- SubQuery에 의해 연산된 결과값을 기준으로 칼럼에 조건문을 부여하는 방식
-- SubQuery는 method나 함수를 호출하는 것과 같이 SubQuery가 return해주는 값을 칼럼과 비교하여 최종 결과값을 출력
SELECT ST.st_num, ST.st_name, SC.sc_kor
FROM tbl_student ST
    LEFT JOIN tbl_score SC
        ON ST.st_num=SC.sc_num
WHERE SC.sc_kor=
    (
        SELECT MAX(sc_kor) FROM tbl_score
    )
OR SC.sc_kor=
    (
        SELECT MIN(sc_kor) FROM tbl_score
    );
    
-- 국어점수의 평균을 구하고, 평균 이상의 점수를 얻은 학생의 리스트 출력
SELECT AVG(sc_kor) FROM tbl_score;

SELECT *
FROM tbl_score
WHERE sc_kor>=77.99;

SELECT *
FROM tbl_score
WHERE sc_kor>=
(
    SELECT AVG(sc_kor) FROM tbl_score
);

-- 각 학생의 점수 평균을 구하고 전체 학생의 평균을 구하여 전체 평균점수보다 높은 평균점수의 학생 리스트 출력
-- 전체 학생 평균
SELECT AVG((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5)
FROM tbl_score;
-- 약 75.2

-- 학생별 평균
SELECT sc_num, ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5)
FROM tbl_score;

/* SELECT SubQuery문이 실행되는 순서
1. FROM절이 실행되어 tbl_score Table의 정보(칼럼정보)를 가져오기
2. WHERE절이 싱행되어 실제 가져올 데이터 선별
3. GROUP BY절이 실행되어 중복된 데이터를 묶어서 하나로 만들기
4. SELECT에 나열된 칼럼에 값 채워넣기
5. SELECT에 정의된 수식을 연산, 결과 출력 준비
6. ORDER BY는 모든 Query가 실행된후 가장 마지막에 수행

따라서 WHERE절과 GROUP BY절에서는 Alias로 설정된 칼럼 이름을 사용할 수 없다(ORDER BY에서는 사용 가능). */

-- 전체 평균점수보다 높은 평균점수의 학생
SELECT sc_num, sc_kor, sc_eng, sc_math, sc_music, sc_art, ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) AS 평균
FROM tbl_score
WHERE ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) >=
(
    SELECT AVG((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) FROM tbl_score
);

-- 위의 Query를 활용하여 평균을 구하는 조건은 그대로 유지하고, 학번이 20020 이전인 학생들만 추출
SELECT sc_num, sc_kor, sc_eng, sc_math, sc_music, sc_art, ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) AS 평균
FROM tbl_score
WHERE ((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) >=
(
    SELECT AVG((sc_kor+sc_eng+sc_math+sc_music+sc_art)/5) FROM tbl_score
)
AND sc_num<'20020';

-- 성적테이블에서 학번의 문자열 자르기를 수행하여 반 명칭만 추출


-- 추출된 반 명칭이 '2006'보다 작은 값을 갖는 반만 추출
/* HAVING
- WHERE절과 비슷한 성질을 가진다.
- GROUP BY로 묶이거나 통계함수로 생성된 값을 대상으로 WHERE연산을 수행하는 명령어 */
SELECT SUBSTR(sc_num, 1, 4) AS 반
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4)
HAVING SUBSTR(sc_num, 1, 4)<'2006'
ORDER BY 반;

-- 각 반의 평균을 구하고 특정 범위의 평균 점수를 가지는 반 구하기
SELECT SUBSTR(sc_num, 1, 4) AS 반, ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) AS 반평균
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4)
HAVING ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) > 75   -- 반 평균이 75점 이상인 반만 출력
ORDER BY 반;

SELECT SUBSTR(sc_num, 1, 4) AS 반, ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) AS 반평균
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4)
HAVING ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) >=
(
    SELECT ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) FROM tbl_score
);
ORDER BY 반;

-- 2000~2005은 A그룹, 2006~2010은 B그룹일 때
-- 반 이름이 '2005' 이하인 A그룹의 반의 평균 구하기
SELECT SUBSTR(sc_num, 1, 4) AS 반, ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) AS 반평균
FROM tbl_score
GROUP BY SUBSTR(sc_num, 1, 4)
HAVING SUBSTR(sc_num, 1, 4) <= '2005'
ORDER BY 반;
/*
HAVING과 WHERE
- 두 가지 모두 결과를 SELECTION하는 조건문 설정 방식이다.
    HAVING : 그룹으로 묶이거나 통계함수로 연산된 결과를 조건으로 설정하는 방식
    WHERE : 어떤 연산이 수행되기 전 원본 데이터를 조건으로 제한하는 방식
- 어쩔 수 없이 통계 결과를 제한할 때는 HAVING 사용
- WHERE절에서 조건을 설정하여 데이터를 제한한 후 연산 수행이 가능하다면 WHERE 사용을 우선 조건으로 설정
- HAVING, WHERE조건이 없으면 전체 데이터를 상대로 상당한 연산을 수행한 후 조건을 설정하므로
    WHERE 조건을 설정할 때보다 처리가 상대적으로 느리다.

- ORDER BY 연산이 가장 늦게 실행되고 처리 속도도 가장 느리다.
*/
SELECT SUBSTR(sc_num, 1, 4) AS 반, ROUND(AVG((sc_kor+sc_eng+sc_math)/3)) AS 반평균
FROM tbl_score
WHERE SUBSTR(sc_num, 1, 4) <= '2005'
GROUP BY SUBSTR(sc_num, 1, 4)
>>>>>>> 7f2c4a511c3155817e54714db99b97f6f7934a92
ORDER BY 반;