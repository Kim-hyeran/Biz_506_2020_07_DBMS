-- user1 접속 화면입니다.

/*
- tbl_iolist에는 상품명, 거래처명, 거래처CEO 칼럼의 데이터가 일반 문자열 형태로 저장되어 있다.
- 이 데이터에는 같은 칼럼의 중복된 데이터가 존재하여 데이터 관리 측면에서 상당한 불편함이 존재한다.
- 어떤 상품의 상품명 변경이 필요한 경우
    상품명 UPDATE시 2개 이상의 레코드를 대상으로 UPDATE 과정 필요
    2개 이상의 레코드 UPDATE 수행은 데이터의 무결성을 해칠 수 있음
    
정규화 실행
- 상품명 정보를 별도의 테이블로 분리하고 상품정보에 상품코드를 부여한 후, tbl_iolist와 연동하는 방식으로 정규화 실행
- tbl_iolist로부터 상품명 리스트 출력 : 상품명 칼럼을 GROUP BY로 묶어 중복되지 않은 상품명 리스트만 추출
*/
SELECT io_pname,
    MIN(DECODE(io_inout, '매입', io_price, 0)) AS 매입단가,
    MAX(DECODE(io_inout, '매출', io_price, 0)) AS 매출단가
FROM tbl_iolist
GROUP BY io_pname
ORDER BY io_pname;

CREATE TABLE tbl_product
(
p_code CHAR(5) PRIMARY KEY,
p_name nVARCHAR2(125) NOT NULL,
p_iprice NUMBER,
p_oprice NUMBER,
p_vat CHAR(1) DEFAULT '1'
);

SELECT * FROM tbl_product;

/*
- 매입매출 테이블에서 상품정보(이름, 단가) 부분을 추출하여 상품정보 테이블 생성
- 매입매출 테이블에서 상품명 칼럼을 제거하고, 상품정보 테이블과 JOIN 설정
- 매입매출 테이블 : 상품명 존재, 상품정보 테일 : 상품코드, 상품이름, 매입/매출단가 존재
- 매입매출 테이블의 상품명에 해당하는 상품코드를 매입매출 테이블에 UPDATE하고, 매입매출 테이블의 상품명 칼럼을 제거 후 JOIN을 수행하여 데이터 확인
*/

-- 매입매출 테이블의 상품명과 상품정보 테이블의 상품명을 JOIN해서 매입매출 테이블의 상품명이 상품정보에 모두 존재하는지 확인
SELECT io.io_pname, p.p_name
FROM tbl_iolist IO
    LEFT JOIN tbl_product P
        ON io.io_pname=p.p_name;
-- 위의 Query를 실행하여 P.p_name 항목에 (null)값이 존재한다면 상품정보 테이블이 잘못 생성된 것
-- 이런 경우 상품정보 테이블을 삭제하고 생성 과정을 다시 수행해야 한다.

-- Query 결과 중 P.p_name 항목의 값이 null인 리스트만 출력
-- 결과가 정상이라면 리스트 항목이 한 개도 존재해선 안된다.
SELECT io.io_pname, p.p_name
FROM tbl_iolist IO
    LEFT JOIN tbl_product P
        ON io.io_pname=p.p_name
WHERE p.p_name IS NULL;     -- 해당 칼럼의 값이 null인가? : IS NOT NULL

-- 상품정보 데이터에 이상이 없으면 매입매출 테이블에 상품코드를 저장할 "칼럼 추가"
-- ALTER TABLE : 테이블의 구조 변경(칼럼 추가, 삭제), 칼럼의 타입 변경 등을 수행하는 명령
-- 상품테이블의 p_code 칼럼과 같은 타입으로 io_pcode 칼럼 추가
ALTER TABLE tbl_iolist ADD io_pcode CHAR(5);

-- 칼럼 삭제하기
ALTER TABLE tbl_iolist DROP COLUMN io_pcode;

-- ALTER TABLE을 할 때 이미 많은 데이터가 INSERT 되어있는 상태에서 칼럼을 추가하면 해당 칼럼은 초기값이 NULL이 되기 때문에 아래 명령문 실행 시 오류가 발생한다
-- (이미 NULL 값으로 지정되어 있기 때문)
-- 아래 명령문은 데이터가 1개도 존재하지 않을 경우 사용 가능
ALTER TABLE tbl_iolist ADD (io_pcode CHAR(5) NOT NULL);

-- 새로 생성한 칼럼에 NOT NULL 조건 추가하기
-- 1. io_pcode 칼럼을 새로 생성, 기본값으로 빈 칸(칼럼이 문자열형이기 때문, NULL이 아닌 어떤 값도 가능) 추가(숫자의 경우는 0)
ALTER TABLE tbl_iolist ADD (io_pcode CHAR(5) DEFAULT ' ');
-- 2. p_code 칼럼의 제약조건을 NOT NULL 설정(칼럼에 NOT NULL 조건 추가하기)
ALTER TABLE tbl_iolist MODIFY (io_pcode CONSTRAINT io_pcode NOT NULL);

-- 칼럼의 타입 변경하기 
ALTER TABLE tbl_iolist MODIFY (io_pcode CHAR(10));
/* 칼럼의 타입 변경 시 주의사항
- 칼럼의 타입을 변경할 때 문자열<-->숫자와 같이 타입이 완전히 다른 경우는 오류가 발생하거나 데이터를 전부 소실할 수 있다.
- CHAR<-->(n)VARCHAR2의 경우 문자열의 길이가 같으면 데이터 변환이 이루어진다.
- CHAR<-->nVARCHAR2는 저장된 문자열이 UNICODE(한글 등)이면 주의가 필요하다.
-   길이가 다른 경우 오류가 발생하지만, 명령이 정상적으로 수행되더라도 데이터가 잘리거나 문자열이 알 수 없는 값으로 변형되는 경우가 발생할 수 있다.
*/

-- 칼럼의 이름 변경하기(io_pcode -> io_pcode1)
ALTER TABLE tbl_iolist RENAME COLUMN (io_pcode TO io_pcode1);

-- 상품정보에서 매입매출장의 각 레코드에 존재하는 상품명과 일치하는 상품코드를 찾아 매입매출장의 상품코드(io_pcode) 칼럼에 UPDATE
/* UPDATE 명령이 SubQuery를 만나면
1. SubQuery에서 현재 iolist의 io_pname 칼럼의 값을 요구
2. tbl_iolist의 레코드 전체를 SELECT 수행
3. SELECT된 List에서 io_name 칼럼 값을 SubQuery로 전달
4. SubQuery는 전닯다은 io_pname 값을 tbl_product 테이블에서 조회
    이 때 SubQuery는 반드시 1개의 칼럼, 1개의 VO만 추출하여야 한다.
5. 결과를 현재 iolist의 레코드 io_pcode 칼럼에 UPDATE 수행
*/
UPDATE tbl_iolist IO
SET io_pcode=
(
    SELECT p_code
    FROM tbl_product P
    WHERE p_name=io.io_pname
);

SELECT io_pcode FROM tbl_iolist;

-- iolist에 pcode가 정상적으로 UPDATE 되었는지 검증
SELECT io_pcode, io_pname, p.p_name
FROM tbl_iolist IO
    LEFT JOIN tbl_product P
        ON IO.io_pcode=P.p_code
WHERE P.p_name IS NULL;

-- @@거래처 데이터 정규화@@
-- 거래처명, CEO 칼럼이 테이블에 들어있는데, 이 칼럼을 추출하여 거래처 정보 생성
-- 추출된 데이터 중 거래처명은 같고 CEO가 다르면 다른 회사로 보고, 거래처명과 CEO가 같으면 같은 회사로 인식해 데이터 생성
SELECT io_dname, io_dceo
FROM tbl_iolist
GROUP BY io_dname, io_dceo
ORDER BY io_dname;

CREATE TABLE tbl_buyer
(
b_code CHAR(4) PRIMARY KEY,
b_name nVARCHAR2(125) NOT NULL,
b_ceo nVARCHAR2(50) NOT NULL,
b_tel nVARCHAR2(20)
);

SELECT * FROM tbl_buyer;

-- b_tel 칼럼의 값이 중복된(2개 이상) 레코드 존재 여부 확인
SELECT b_tel, COUNT(*) FROM tbl_buyer
GROUP BY b_tel
HAVING COUNT(*)>1;

-- iolist에 저장된 dname, dceo 칼럼으로 거래처정보에서 데이터를 조회하고 iolist의 거래처 코드 칼럼으로 UPDATE
ALTER TABLE tbl_iolist ADD (io_bcode CHAR(4) DEFAULT ' ');
ALTER TABLE tbl_iolist MODIFY (io_bcode CONSTRAINT io_bcode NOT NULL);

DESC tbl_iolist;

-- iolist와 buyer 테이블 간의 거래처명, 대표자명 칼럼으로 JOIN을 수행하여 데이터 검증
-- 데이터가 1개도 출력되지 않아야한다.
SELECT *
FROM tbl_iolist IO
    LEFT JOIN tbl_buyer B
        ON io.io_dname=b.b_name
WHERE b.b_name IS NULL;

-- iolist에 거래처 코드 UPDATE
/* 지금 생성한 tbl_buyer 테이블에는 거래처명이 같고 대표자가 다른 데이터가 존재하는데,
거래처명으로 조회하면 출력되는 레코드(row값)가 2개 이상인 경우 발생
따라서 아래 Query를 살행하면 single-row subquery returns more than one row 오류가 발생한다.
    -> AND b.b_ceo=io.io_dceo절을 추가, 거래처명과 ceo 값을 동시에 제한하여 1개의 row 값만 subquery에서 생성되도록 조치를 취한다. */
UPDATE tbl_iolist IO
SET io_bcode=
(
    SELECT b_code
    FROM tbl_buyer B
    WHERE b.b_name=io.io_dname AND b.b_ceo=io.io_dceo
);

SELECT io_bcode, io_dname, b_code, b_name
FROM tbl_iolist IO
    LEFT JOIN tbl_buyer B
        ON io.io_bcode=b.b_code
WHERE b_code IS NULL OR b_name IS NULL;

-- 데이터를 tbl_product, tbl_buyer 테이블로 분리하였기 때문에 tbl_iolist에서 io_pname, io_dname, iodceo 칼럼은 불필요하므로 삭제
ALTER TABLE tbl_iolist DROP COLUMN io_pname;
ALTER TABLE tbl_iolist DROP COLUMN io_dname;
ALTER TABLE tbl_iolist DROP COLUMN io_dceo;

SELECT * FROM tbl_iolist;

CREATE VIEW view_iolist
AS
(
SELECT io_seq, io_date,
    io_bcode, b_name, b_ceo, b_tel,
    io_pcode, p_name, p_iprice, p_oprice,
    io_inout,
    DECODE(io_inout, '매입', io_price, 0) AS 매입단가,
    DECODE(io_inout, '매입', io_amt, 0) AS 매입금액,
    DECODE(io_inout, '매출', io_price, 0) AS 매출단가,
    DECODE(io_inout, '매출', io_amt, 0) AS 매출금액
FROM tbl_iolist IO
    LEFT JOIN tbl_product P
        ON io.io_pcode=p.p_code
    LEFT JOIN tbl_buyer B
        ON io.io_bcode=b.b_code
);

SELECT * FROM view_iolist
WHERE io_date BETWEEN '2019-01-01' AND '2019-01-31'
ORDER BY io_date;