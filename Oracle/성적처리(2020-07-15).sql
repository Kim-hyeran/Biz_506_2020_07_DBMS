-- grade user로 접속한 화면입니다.

-- 사용자가 다른 경우에는 Table명이 중복되어도 괜찮다.
CREATE TABLE tbl_student (
    st_num	CHAR(5) PRIMARY KEY,
    st_name	nVARCHAR2(20) NOT NULL,
    st_dept	nVARCHAR2(10),
    st_grade NUMBER(1) CHECK(st_grade>0 AND st_grade<=4),
    st_tel	nVARCHAR2(20),
    st_addr	nVARCHAR2(125),
    st_age	NUMBER(3)
);
/*
- CONSTRAINTS : 제약조건, 제약사항, Valid Option
- Data를 INSERT 수행할 때, DBMS 차원에서 유효성검사를 하고 통과하지 못하면 INSERT 명령에 오류가 발생하도록 함
      ->INSERT 명령을 수행하지 않음(데이터의 무결성 유지)
- PRIMARY KEY : 중복될 수 없고, NULL 값이 아닌 값만 유효
            UNIQUE와 NOT NULL을 포함한 제약 조건이 설정
            SELECT로 Data 조회 시 PK로 설정된 칼럼을 기준으로 오름차순 정렬
            PK 칼럼으로 기본 INDEX 설정
- NOT NULL : NULL 값이 아닌 값만 유효
- UNIQUE : 중복되지 않은 값만 유효, 해당 칼럼에 추가하고자 하는 데이터가 이미 저장되어 있으면 추가로 저장할 수 없음
- CHECK : 어떤 값이 해당 범위에서 유효한 경우만 추가 가능

문자열 칼럼의 Type
- CHAR(자릿수) : 저장하는 Data의 길이가 모두 일정할 경우 사용하는 Type
                저장하는 Data의 자릿수가 같지 않으면 부족한 부분을 공백으로 대체
                DB에 따라 문자열의 앞, 뒤에 공백을 추가하는 경우가 발생해 간혹 조회가 어려울 수 있음
- VARCHAR2(자릿수) : 저장하는 Data의 길이가 일정하지 않을 경우 사용하는 Type
                    저장하는 Data가 설정한 자릿수보다 작으면 칼럼의 실제 크기를 줄여서 저장
                    저장하는 데 CHAR보다 다소 시간이 소요되지만 현재에는 큰 차이 없음
                    저장할 Data를 잘 분석하여 자릿수를 데이터의 최대 크기만큼 지정
                    저장할 DAta의 길이가 자릿수보다 크면 저장되지 않음
- nVARCHAR2(자릿수) : VARCHAR2(자릿수)와 성질이 같은 Type
                    한글, 한자 등 알파벳 이외의 문자를 저장할 때 사용
                    UNICODE 문자열을 위해 특별히 마련
                    영문자 1글자와 한글 1글자를 같은 자릿수로 취급
                    키보드에 기본적으로 존재하는 문자가 아닌 문자를 저장하는 경우 무조건 사용

- NUMBER(자릿수, 소수점) : Oracle에서는 숫자형일 경우 별도의 Type을 명시하지 않고 NUMBER(자릿수, 소수점) 형식으로 사용
                        NUMBER(자릿수) : 정수형 표현
                        NUMBER(자릿수, 소수점) : 실수형 표현
                        자릿수 생략 시 최대 38자리 정수 표현 가능
*/

DROP TABLE tbl_student CASCADE CONSTRAINTS;

-- Data 추가 1
INSERT INTO tbl_student (
    ST_NUM,
    ST_NAME,
    ST_DEPT,
    ST_GRADE,
    ST_TEL,
    ST_ADDR,
    ST_AGE
) VALUES(
    '10001',
    '홍길동',
    '컴퓨터공학',
    3,
    '010-111-1111',
    '서울특별시',
    33
);
-- INSERT 수행 후 자주 발생하는 오류 1
/*
unique constraint (GRADE.SYS_C007009) violated
    : PK나, UNIQUE로 설정된 칼럼에 이미 저장된 값을 또 저장하려고 할 때 발생
*/

-- Data 추가 2
INSERT INTO tbl_student (
    ST_NUM,
    ST_NAME,
    ST_DEPT,
    ST_GRADE,
    ST_TEL,
    ST_ADDR,
    ST_AGE
) VALUES(
    '10002',
    '홍길동',
    -- '컴퓨터공학',
    3,
    '010-111-1111',
    '서울특별시',
    33
);
-- INSERT 수행 후 자주 발생하는 오류 2
/*
not enough values : INTO에 나열한 칼럼에 저장할 데이터가 누락된 경우
    예 : 나열된 칼럼 갯수가 6개일 때, VALUES 데이터는 6개 미만으로 설정된 경우
*/

-- Data 추가 3
INSERT INTO tbl_student (
    ST_NUM,
    -- ST_NAME,
    ST_DEPT,
    ST_GRADE,
    ST_TEL,
    ST_ADDR,
    ST_AGE
) VALUES(
    '10003',
    -- '홍길동',
    '컴퓨터공학',
    3,
    '010-111-1111',
    '서울특별시',
    33
);
-- INSERT 수행 후 자주 발생하는 오류 3
/*
cannot insert NULL into ("사용자"."테이블"."칼럼")
    : NOT NULL로 설정된 칼럼이 누락되는 경우 발생하는 오류
*/

-- Data 추가 4
INSERT INTO tbl_student (
    ST_NUM,
    ST_NAME,
    ST_DEPT,
    ST_GRADE,
    ST_TEL,
    ST_ADDR,
    ST_AGE
) VALUES(
    '10004',
    '홍길동',
    '컴퓨터공학',
    '3A',
    '010-111-1111',
    '서울특별시',
    33
);
-- INSERT 수행 후 자주 발생하는 오류 4
/*
invalid number : NUMBER로 설정된 칼럼에 문자열을 저장하려고 시도한 경우
                만약 NUMBER로 설정된 칼럼에 숫자를 따옴표로 묶어 지정하면 내부에서 문자열->숫자 형식으로 변환되어 저장(자동형변환)
                문자열->숫자로 자동형변환 시도 시, 숫자로 변환할 수 없는 문자열이 포함되는 경우 발생하는 오류
*/

-- Data 추가 5
INSERT INTO tbl_student (
    ST_NUM,
    ST_NAME,
    ST_DEPT,
    ST_GRADE,
    ST_TEL,
    ST_ADDR,
    ST_AGE
) VALUES(
    '10004',
    '홍길동',
    '컴퓨터공학',
    5,
    '010-111-1111',
    '서울특별시',
    33
);
-- INSERT 수행 후 자주 발생하는 오류 5
/*
check constraint : CHECK로 유효성 검사를 설정한 칼럼의 범위(Valid)를 통과하지 못한 경우 발생
*/

-- INSERT를 수행한 후 반드시 데이터 확인
-- INSERT 후 데이터 확인은 모든 데이터를 조회하는 것보다 현재 입력한 데이터의 PK를 기준으로 조회하는 것이 정확도가 높음
SELECT * FROM tbl_student WHERE st_num='10001';