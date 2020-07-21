-- grade 사용자 화면입니다.

-- EXCEL 파일에서 학생 데이터를 IMPORT한 후 SELECT 실습

-- 모든 데이터 전체 출력
SELECT * FROM tbl_student;

-- SELECTION
/*
데이터 중에서 조건을 부여하여 조건에 맞는 리스트만 출력
Record의 제한(전체 데이터 갯수 > 조건에 맞는 데이터 갯수)
WHERE절에 조건을 설정하여 데이터 조회
PK, UNIQUE로 설정된 칼럼을 단일 조건으로 SELECTION할 때는 이 데이터를 1개의 객체로 취급(=VO에 담는다)
*/
SELECT * FROM tbl_student
WHERE st_num='20001';

-- st_num에 저장된 값이 '20001' 이상이며(AND) '20010' 이하인 조건에 맞는 데이터 리스트(Record)출력 명령
-- PK, UNIQUE로 설정된 칼럼을 조건절로 SELECTION할 때는 레코드가 한 개만 나타날지라도 리스트로 취급
SELECT * FROM tbl_student
WHERE st_num>='20001' AND st_num<='20010';

-- st_name에 저장된 값이 독고예준인 리스트만 출력
-- PK, UNIQUE로 설정된 칼럼이 아닌 경우, SELECTION을 수행했을 때 나타나는 레코드가 1개일지라도 리스트로 취급
SELECT * FROM tbl_student
WHERE st_name='독고예준';

-- PROJECTION
/*
SELECTION된 레코드의 갯수와 무관하게, 특정 칼럼만 리스트에 포함하는 조회
레코드 갯수와 관계 없이 보이는 칼럼을 제한하는 조회
*/
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student;

-- SELECTION & PROJECTION
/*
WHERE 조건절을 사용하여 레코드를 제한하고, 칼럼명을 나열하여 필요한 항목(필드)만 출력
    칼럼 리스트를 제한
*/
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student WHERE st_name='남동예';

-- 비교연산자(>,=,<)와 관계연산자(AND, OR)를 사용하여 SELECTION 구현
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student WHERE st_num>='20001' AND st_num<='20010';
-- '20001' <= st_num >= '20010' : 이러한 방식은 사용할 수 없음(Python은 가능)

-- BETWEEN 연산자를 사용하여 범위를 제한하는(이상, 미만일 경우만 가능) SELECTION 구현
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student
WHERE st_num BETWEEN '20001' AND '20010';

-- 비교연산자 =과 관계연산자 OR를 조합하여 SELECTION 구현
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student
WHERE st_num='20001' OR st_num='20003' OR st_num='20006';

-- 한 개의 칼럼에 다수의 OR 조건을 부여하여 SELECTION을 수행할 때는 IN이라는 연산자를 사용하여 구현 가능
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student
WHERE st_num IN ('20001', '20003', '20006');

-- 문자열(VARCHAR2, nVARCHAR2) 칼럼의 경우
-- 문자열 전체가 아닌 부분만 일치하는 조건을 부여하여 SELECTION 구현

-- LIKE 연산자를 사용하여 부분 문자열 검색(조회)
/*
'%' : 문자열의 포함여부를 제한
    '%찾기' : '찾기' 문자열로 끝나는 모든 데이터 레코드
    '찾기%' : '찾기' 문자열로 시작하는 모든 데이터 레코드
    '%찾기%' : '찾기' 문자열이 포함되는 모든 데이터 레코드
LIKE 연산자를 사용하여 조회(검색)를 수행하면 DB에 설정된 모든 INDEX를 무시하고, 무조건 처음부터 전부 탐색하는 연산 수행
    : Full Text Searh
*/
SELECT st_num, st_name, st_dept, st_grade
FROM tbl_student
WHERE st_num LIKE '%7';