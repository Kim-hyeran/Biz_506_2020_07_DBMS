-- grade 화면입니다.

-- DEFAULT
/*
해당하는 칼럼의 데이터를 지정하지 않고 INSERT를 수행하면 DEFAULT로 설정된 값을 지정한 것으로 인식, INSERT 수행
*/
CREATE TABLE tbl_score(
    sc_num	CHAR(5)	PRIMARY KEY,
    sc_kor	NUMBER(3) DEFAULT 0,
    sc_eng	NUMBER(3) DEFAULT 0,
    sc_math	NUMBER(3) DEFAULT 0,
    sc_music   NUMBER(3) DEFAULT 0,
    sc_art	NUMBER(3) DEFAULT 0
);

DROP TABLE tbl_score;

INSERT INTO tbl_score(sc_num) VALUES('20001');
SELECT * FROM tbl_score;

SELECT * FROM tbl_score;
SELECT COUNT(*) FROM tbl_score;

--------------------------------------------------------------------------------

-- 성적 정보 table을 활용한 SELECT

-- 학생별 성적의 총점과 평균을 계산하여 리스트로 확인
-- AS(Alias) : Table의 칼럼명, 연산수식 등에 별명을 부여
SELECT sc_num, sc_kor, sc_eng, sc_math, sc_music, sc_art,
    (sc_kor+sc_eng+sc_math+sc_music+sc_art) AS 총점,
    (sc_kor+sc_eng+sc_math+sc_music+sc_art)/5 AS 평균
FROM tbl_score;

-- 각 과목별 총점 계산 -> 집계, 통계 수행
SELECT SUM(sc_kor) as 국어총점,
        SUM(sc_eng) as 영어총점,
        SUM(sc_math) as 수학총점,
        SUM(sc_music) as 음악총점,
        SUM(sc_art) as 미술총점
FROM tbl_score;

-- 각 과목별 평균 계산 -> 집계, 통계 수행
SELECT AVG(sc_kor) as 국어평균,
        AVG(sc_eng) as 영어평균,
        AVG(sc_math) as 수학평균,
        AVG(sc_music) as 음악평균,
        AVG(sc_art) as 미술평균
FROM tbl_score;

-- SELECTION을 적용하여 구현
-- 학번 20001~20010인 학생의 리스트만 출력
SELECT * FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010';

-- 학번 20001~20010인 학생의 과목별 총점 계산
SELECT SUM(sc_kor) as 국어총점,
        SUM(sc_eng) as 영어총점,
        SUM(sc_math) as 수학총점,
        SUM(sc_music) as 음악총점,
        SUM(sc_art) as 미술총점
FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010';

-- 학번 20001~20010인 학생의 과목별 평균 계산
SELECT AVG(sc_kor) as 국어평균,
        AVG(sc_eng) as 영어평균,
        AVG(sc_math) as 수학평균,
        AVG(sc_music) as 음악평균,
        AVG(sc_art) as 미술평균
FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010';

SELECT sc_num,
        sc_kor as 국어,
        sc_eng as 영어,
        sc_math as 수학,
        sc_music as 음악,
        sc_art as 미술
FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010'

UNION ALL

-- SUM() 함수를 이용하여 각 과목별 총점을 계산하면서, 의미 없는(DUMY) 칼럼을 생성하여 칼럼의 총 갯수를 맞추어 준다.
-- 통계, 집계 함수를 사용할 때 통계, 집계함수로 묶이지 않은 칼럼은 무조건 GROUP BY절에 칼럼을 나열해주어야 한다.
SELECT '==과목총점==',
        SUM(sc_kor) as 국어,
        SUM(sc_eng) as 영어,
        SUM(sc_math) as 수학,
        SUM(sc_music) as 음악,
        SUM(sc_art) as 미술
FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010'
GROUP BY '==과목총점=='

UNION ALL

SELECT '==과목평균==',
        AVG(sc_kor) as 국어,
        AVG(sc_eng) as 영어,
        AVG(sc_math) as 수학,
        AVG(sc_music) as 음악,
        AVG(sc_art) as 미술
FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010'
GROUP BY '==과목평균==';