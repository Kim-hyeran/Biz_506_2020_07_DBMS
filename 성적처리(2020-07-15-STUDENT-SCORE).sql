-- grade 화면입니다.

--------------------------------------------------------------------------------
-- 성적일람표 출력
--------------------------------------------------------------------------------
/*
성적 정보 Table(tbl_score)에는 학번과 각 과목별 점수가 저장되어 있다.
학생 정보 Table(tbl_student)에는 학번과 이름 등이 저장되어 있다.
성적일람표에 학생의 학번과 이름이 포함된 리스트를 작성하고 싶을 경우, 두 개의 Table을 연동하여 리스트 조회
다수의 Table을 연동하는 방법 : JOIN
*/

SELECT * FROM tbl_score
WHERE sc_num BETWEEN '20001' AND '20010';

-- EQ(완전) JOIN
/*
tbl_score table에 있는 학번의 정보는 반드시 tbl_student에 존재한다는 전제 하
FROM 다음에 JOIN할 table을 나열하고, WHERE절에 두 table의 연결점 칼럼 설정
*/
SELECT sc_num, st_name, sc_kor, sc_eng, sc_math, sc_music, sc_art
FROM tbl_score, tbl_student
WHERE --sc_num BETWEEN '20001' AND '20010' AND
sc_num=st_num;

-- OUTER JOIN
/*
성적 Table에는 1부터 100까지의 데이터가 있고, 학생 Table에는 1부터 50까지의 데이터만 존재한다는 조건
성적리스트를 학생정보와 연동하여 확인하고 싶을 때, EQ JOIN을 사용하게 되면 실제 데이터가 1~50만 나타나는 현상 발생
이런 상황에서 성적 Table의 데이터는 모두 확인하면서, 학생 Table에 있는 정보만 연결해 보여주는 방식의 JOIN
*/

DELETE FROM tbl_student
WHERE st_num>'20050';

SELECT * FROM tbl_student;

-- EQ JOIN
SELECT sc_num, st_name, sc_kor, sc_eng, sc_math, sc_music, sc_art
FROM tbl_score, tbl_student
WHERE sc_num=st_num;

-- INNER JOIN(=EQ JOIN과 같은 기능)
SELECT sc_num, st_name, sc_kor, sc_eng, sc_math, sc_music, sc_art
FROM tbl_score
    INNER JOIN tbl_student  -- INNER 키워드 생략 가능
        ON sc_num=st_num;

-- LEFT JOIN
SELECT sc_num, st_name, sc_kor, sc_eng, sc_math, sc_music, sc_art
FROM tbl_score
    LEFT JOIN tbl_student
        ON sc_num=st_num;
/*
OUTER JOIN의 대표적인 JOIN Query
1. JOIN 키워드 왼쪽에는 모드 리스트업할 table을 위치
2. 이 table과 연동하여 정보를 보조적으로 가져올 table을 join 다음(오른쪽)에 위치
3. 두 talbe의 연결점(key)를 on 키워드 다음에 작성

JOIN 왼쪽 table의 데이터를 모두 보여주고, 키값으로 오른쪽 table에서 값을 찾은 후,
    있을 경우 : PROJECTION에 나열된 칼럼 위치에 값 표시
    없을 경우 : (NULL) 표시
    
왼쪽 table의 데이터가 잘 입력되었는지 검증하는 용도로 많이 사용
아직 FK 설정이 되지 않은 table 간에 정보를 리스트업하는 용도로 사용
*/