-- user1 접속 화면입니다.

-- @@매입 매출 관리 프로젝트@@

-- OO회사의 매입매출관리 프로젝트 수행
-- 이 회사는 기존에 엑셀을 이용하여 거래처벌 매입매출관리를 수행하였는데, 최근 app을 개발하여 데이터베이스화하고 관리를 수행 예정
-- 엑셀 데이터를 받아 데이터베이스로 보내기 위한 변환 작업 수행

-- 엑셀의 매입매출원장을 DB로 만들기 위해 매입과 매출을 분리하고, 날짜를 문자열화
-- 데이터를 저장하기 위해 임포트를 시도했으나 PK로 지정할만한 칼럼이 존재하지 않음
-- 이러한 경우(Work DB인 경우)에는 실제 데이터와 별도로 임의의 PK

-- 매입매출 원장 Table
CREATE TABLE tbl_iolist (
    io_seq NUMBER PRIMARY KEY,
    io_date VARCHAR2(10) NOT NULL,
    io_pname nVARCHAR2(125) NOT NULL,
    io_dname nVARCHAR2(125) NOT NULL,
    io_dceo nVARCHAR2(125) NOT NULL,
    io_inout nVARCHAR2(2) NOT NULL,
    io_qty NUMBER DEFAULT 0,
    io_price NUMBER DEFAULT 0,
    io_amt NUMBER DEFAULT 0
);

-- 전체 데이터 갯수
SELECT COUNT(*) FROM tbl_iolist;

-- 매입과 매출을 구분하여 갯수 세기
SELECT io_inout, COUNT(*) FROM tbl_iolist
GROUP BY io_inout;

-- 매입 데이터만 출력
SELECT * FROM tbl_iolist
WHERE io_inout='매입';

-- 매출 데이터만 출력
SELECT * FROM tbl_iolist
WHERE io_inout='매출';

-- 거래 수량이 90개 이상인 데이터만 출력
SELECT * FROM tbl_iolist
WHERE io_qty>=90;

-- 데이터 확인 중 단가와 금액이 0인 데이터 발견
SELECT * FROM tbl_iolist
WHERE io_price=0 OR io_amt=0;

/*
투니스, 7+8칫솔, 레종블루
위의 세 가지 데이터가 거래된 5, 10, 28 SEQ 데이터 칼럼 값이 0
이 데이터의 단가, 금액을 수정하기 위해 동일한 상품 데이터가 존재하는지 확인
*/
SELECT * FROM tbl_iolist
WHERE io_pname IN ('투니스', '7+8칫솔', '레종블루');
-- 상품 거래 내역에 중복값 없음
-- 다른 곳에서 값을 찾아 입력해야 함
-- 투니스:1000, 칫솔:2500, 레종블루:4500원으로 설정

-- 투니스 거래 내용의 단가, 금액 변경 시
-- WHERE io_pname='투니스'와 같이 지정하는 경우, 다른 매입, 매출 데이터가 있을 경우 막대한 문제 발생 가능성
-- 반드시 PK 칼럼의 값을 조회하고 PK 칼럼으로 WHERE절을 작성
UPDATE tbl_iolist
SET io_price=1000, io_amt=io_qty*1000
WHERE io_seq=5;

UPDATE tbl_iolist
SET io_price=2500, io_amt=io_qty*2500
WHERE io_seq=10;

UPDATE tbl_iolist
SET io_price=4500, io_amt=io_qty*4500
WHERE io_seq=28;

SELECT * FROM tbl_iolist
WHERE io_price=0 OR io_amt=0;

SELECT * FROM tbl_iolist
WHERE io_qty=0 OR io_amt=0;

-- 원본 데이터는 수량, 단가, 매입단가, 매출단가, 매입금액, 매출금액으로 칼럼 분리
-- 이러한 형태의 데이터는 각 칼럼에 NULL값이 존재하여 다양한 연산을 수행할 때 문제가 발생할 수 있다.
-- 변환된 데이터는 수량, 단가, 금액 형식으로 칼럼을 통합하는 작업 수행
-- 칼럼으로 분리된 값들을 공통 칼럼으로 선정하고 데이터를 통합하는 것 : 제 3 정규화
-- 변환된 데이터를 참조하여 매입과 매출을 구분하여 출력하고 싶을 경우
--      (거래처, 수량, 매입단가, 매입금액, 매출단가, 매출금액 형식) -> 피벗 형태로 변환

SELECT * FROM tbl_iolist
WHERE (io_seq>0 AND io_seq<=10) OR (io_seq>=300 AND io_seq<=310)
ORDER BY io_dname;

SELECT io_dname, io_inout, io_qty, io_price, io_amt FROM tbl_iolist
-- WHERE (io_seq>0 AND io_seq<=10) OR (io_seq>=300 AND io_seq<=310)
ORDER BY io_dname;

/* PIVOT으로 데이터 펼쳐보기
매입, 매출 단가가 단가 칼럼(io_price)에 같이 저장되어 있는 상태
이 값은 io_inout 칼럼의 값을 모르면 매입인지 매출인지 구분하기가 어려움 -> 매번 io_inout 칼럼의 값을 표시해야만 구분 가능
이러한 불편 해소를 위하여 io_inout 칼럼의 값을 조건으로 하는 decode함수를 사용하여 단가를 매입, 매출로 분리하여 출력*/
-- PIVOT을 사용하였기 때문에 io_inout 칼럼을 표기하지 않아도 데이터 확인 가능
SELECT io_dname, io_qty,
-- 매입단가(출력을 위한 가상칼럼) 칼럼의 데이터를 출력할 때
-- io_inout 칼럼의 값이 '매입'이면 io_price 칼럼의 값을 표시하고, 그렇지 않으면 0 표시
        DECODE(io_inout, '매입', io_price, 0) AS 매입단가,
        DECODE(io_inout, '매출', io_price, 0) AS 매출단가,
        DECODE(io_inout, '매입', io_amt, 0) AS 매입합계,
        DECODE(io_inout, '매출', io_amt, 0) AS 매출합계
FROM tbl_iolist
WHERE (io_seq>0 AND io_seq<=10) OR (io_seq>=300 AND io_seq<=310)
ORDER BY io_dname;

-- 일 년 간의 거래내역 데이터에서 "거래처 별" 총 매입금액, 총 매출금액 출력
/*
1. "거래처 별" 거래내역이 여러 번 반복되었으므로 거래처명이 중북 출력 -> 데이터를 거래별로 묶기(GROUP BY io_dname)
2. 전체 매출금액과 매입금액을 표시하는 가상 칼럼(매입, 매출금액 계산)을 통계함수로 묶기
*/
SELECT io_dname,
        SUM(DECODE(io_inout, '매입', io_amt, 0)) AS 매입합계,
        SUM(DECODE(io_inout, '매출', io_amt, 0)) AS 매출합계
FROM tbl_iolist
--WHERE (io_seq>0 AND io_seq<=10) OR (io_seq>=300 AND io_seq<=310)
GROUP BY io_dname
ORDER BY io_dname;

-- 각 거래처 별로 얼마만큼의 이익이 발생했는지 출력
-- 이익금=매출합계-매입합계
SELECT io_dname,
        SUM(DECODE(io_inout, '매입', io_amt, 0)) AS 매입합계,
        SUM(DECODE(io_inout, '매출', io_amt, 0)) AS 매출합계,
        SUM(DECODE(io_inout, '매출', io_amt, 0))-SUM(DECODE(io_inout, '매입', io_amt, 0)) AS 이익금
FROM tbl_iolist
--WHERE (io_seq>0 AND io_seq<=10) OR (io_seq>=300 AND io_seq<=310)
GROUP BY io_dname
ORDER BY io_dname;

-- OO회사에서 2019년 1년 동안 총매입, 총매출, 총이익이 얼마나 발생했는지 출력
SELECT SUM(DECODE(io_inout, '매입', io_amt, 0)) AS 매입합계,
        SUM(DECODE(io_inout, '매출', io_amt, 0)) AS 매출합계,
        SUM(DECODE(io_inout, '매출', io_amt, 0))-SUM(DECODE(io_inout, '매입', io_amt, 0)) AS 이익금
FROM tbl_iolist
--WHERE (io_seq>0 AND io_seq<=10) OR (io_seq>=300 AND io_seq<=310)
ORDER BY io_dname;