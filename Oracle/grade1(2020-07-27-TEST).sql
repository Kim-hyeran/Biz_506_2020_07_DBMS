CREATE TABLE tbl_student (
    st_num CHAR(5) PRIMARY KEY,
    st_name nVARCHAR2(5) NOT NULL,
    st_tel CHAR(20) NOT NULL,
    st_addr NVARCHAR2(125),
    st_grade NUMBER NOT NULL,
    st_dept CHAR(3) NOT NULL	
);

CREATE TABLE tbl_dept (
    d_code CHAR(3),
    d_name nVARCHAR2(10) UNIQUE,
    d_prof nVARCHAR2(10)
);

CREATE TABLE tbl_score (
    sc_num CHAR(5) NOT NULL,
    sc_sub nVARCHAR2(10) NOT NULL,
    sc_score NUMBER(3) NOT NULL
);

-- 데이터 입력
INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_grade, st_dept)
VALUES ('20001', '갈한수', '010-2127-7851', '경남 김해시 어방동 1088-7', 3, '008');

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_grade, st_dept)
VALUES ('20002', '강이찬', '010-4311-1533', '강원도 속초시 대포동 956-5', 1, '006');

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_grade, st_dept)
VALUES ('20003', '개원훈', '010-6262-7441', '경북 영천시 문외동 38-3번지', 1, '009');

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_grade, st_dept)
VALUES ('20004', '경시현', '010-9794-9856', '서울시 구로구 구로동 3-35번지', 1, '006');

INSERT INTO tbl_student(st_num, st_name, st_tel, st_addr, st_grade, st_dept)
VALUES ('20005', '공동영', '010-8811-7761', '강원도 동해시 천곡동 1077-3', 2, '010');

INSERT INTO tbl_dept(d_code, d_name, d_prof) VALUES ('001', '컴퓨터공학', '토발즈');
INSERT INTO tbl_dept(d_code, d_name, d_prof) VALUES ('002', '전자공학', '이철기');
INSERT INTO tbl_dept(d_code, d_name, d_prof) VALUES ('003', '법학', '킹스필드');

INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20001', '데이터베이스', 71);
INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20001', '수학', 63);
INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20001', '미술', 50);

INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20002', '데이터베이스', 84);
INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20002', '음악', 75);
INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20002', '국어', 52);

INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20003', '수학', 89);
INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20003', '영어', 63);
INSERT INTO tbl_score(sc_num, sc_sub, sc_score) VALUES ('20003', '국어', 70);

-- 테이블 전체 조회
SELECT * FROM tbl_student;

-- 성적 60점 미만 학생 조회
SELECT sc_num FROM tbl_score
WHERE sc_score<60;

-- 데이터 수정
UPDATE tbl_student
SET st_addr='광주광역시 북구 중흥동 경양로 170번지'
WHERE st_name='공동영';

-- 데이터 삭제
DELETE tbl_student
WHERE st_name='개원훈';

-- 학생정보 테이블에서 학과명과 교과교수 함께 보기
SELECT ST.st_num, ST.st_name, ST.st_tel, ST.st_addr, ST.st_grade, ST.st_dept, DT.d_name, DT.d_prof
FROM tbl_student ST
    LEFT JOIN tbl_dept DT
        ON st.st_dept=dt.d_code
ORDER BY ST.st_num;

-- 학번별 총점과 평균 계산

SELECT sc_num AS 학번,
        SUM(sc_score) AS 총점,
        ROUND((SUM(sc_score)/7),2) AS 평균
FROM tbl_score
GROUP BY sc_num
ORDER BY sc_num;

SELECT * FROM tbl_score;

-- 총점, 평균 계산 후 학생 이름과 전화번호 포함하여 출력
SELECT SC.sc_num AS 학번, ST.st_name AS 이름, ST.st_tel AS 전화번호,
        SUM(SC.sc_score) AS 총점,
        ROUND((SUM(SC.sc_score)/7),2) AS 평균
FROM tbl_score SC
    LEFT JOIN tbl_student ST
        ON SC.sc_num=ST.st_num
GROUP BY SC.sc_num, ST.st_name, ST.st_tel
ORDER BY SC.sc_num;

-- pivot 1 : 학번별 각각의 과목 성적 펼쳐보기
SELECT SC.sc_num AS 학번,
    SUM(DECODE(SC.sc_sub, '국어', SC.sc_score, 0)) AS 국어,
    SUM(DECODE(SC.sc_sub, '영어', SC.sc_score, 0)) AS 영어,
    SUM(DECODE(SC.sc_sub, '수학', SC.sc_score, 0)) AS 수학,
    SUM(DECODE(SC.sc_sub, '음악', SC.sc_score, 0)) AS 음악,
    SUM(DECODE(SC.sc_sub, '미술', SC.sc_score, 0)) AS 미술,
    SUM(DECODE(SC.sc_sub, '소프트웨어공학', SC.sc_score, 0)) AS 소프트웨어공학,
    SUM(DECODE(SC.sc_sub, '데이터베이스', SC.sc_score, 0)) AS 데이터베이스,
    SUM(SC.sc_score) AS 총점,
    ROUND((SUM(SC.sc_score)/7),2) AS 평균
FROM tbl_score SC
GROUP BY SC.sc_num
ORDER BY SC.sc_num;

-- pivot 2 : 1에 학생정보 join
SELECT SC.sc_num AS 학번, ST.st_name AS 이름, ST.st_tel AS 전화번호, ST.st_dept AS 학과코드,
    SUM(DECODE(SC.sc_sub, '국어', SC.sc_score, 0)) AS 국어,
    SUM(DECODE(SC.sc_sub, '영어', SC.sc_score, 0)) AS 영어,
    SUM(DECODE(SC.sc_sub, '수학', SC.sc_score, 0)) AS 수학,
    SUM(DECODE(SC.sc_sub, '음악', SC.sc_score, 0)) AS 음악,
    SUM(DECODE(SC.sc_sub, '미술', SC.sc_score, 0)) AS 미술,
    SUM(DECODE(SC.sc_sub, '소프트웨어공학', SC.sc_score, 0)) AS 소프트웨어공학,
    SUM(DECODE(SC.sc_sub, '데이터베이스', SC.sc_score, 0)) AS 데이터베이스,
    SUM(SC.sc_score) AS 총점,
    ROUND((SUM(SC.sc_score)/7),2) AS 평균
FROM tbl_score SC
    LEFT JOIN tbl_student ST
        ON SC.sc_num=ST.st_num
GROUP BY SC.sc_num, ST.st_name, ST.st_tel, ST.st_dept
ORDER BY SC.sc_num;

-- pivot 3 : 2에 학과정보 join
SELECT ST.st_num AS 학번, ST.st_name AS 이름, ST.st_tel AS 전화번호, ST.st_dept AS 학과코드, DT.d_name AS 학과명,
    SUM(DECODE(SC.sc_sub, '국어', SC.sc_score, 0)) AS 국어,
    SUM(DECODE(SC.sc_sub, '영어', SC.sc_score, 0)) AS 영어,
    SUM(DECODE(SC.sc_sub, '수학', SC.sc_score, 0)) AS 수학,
    SUM(DECODE(SC.sc_sub, '음악', SC.sc_score, 0)) AS 음악,
    SUM(DECODE(SC.sc_sub, '미술', SC.sc_score, 0)) AS 미술,
    SUM(DECODE(SC.sc_sub, '소프트웨어공학', SC.sc_score, 0)) AS 소프트웨어공학,
    SUM(DECODE(SC.sc_sub, '데이터베이스', SC.sc_score, 0)) AS 데이터베이스,
    SUM(SC.sc_score) AS 총점,
    ROUND((SUM(SC.sc_score)/7),2) AS 평균
FROM tbl_student ST
    LEFT JOIN tbl_score SC
        ON SC.sc_num=ST.st_num
    LEFT JOIN tbl_dept DT
        ON ST.st_dept=DT.d_code
GROUP BY ST.st_num, ST.st_name, ST.st_tel, ST.st_dept, DT.d_name
ORDER BY ST.st_num;