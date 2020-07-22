-- user2 접속 화면입니다.

/*
주문번호,고객번호,상품코드
O00001  C0032   P00001
O00001  C0032   P00002
O00001  C0032   P00003
*/

SELECT * FROM "TBL_주문서원장"
ORDER BY "주문번호";

CREATE TABLE tbl_order (
    o_seq	NUMBER PRIMARY KEY,
    o_num	CHAR(6) NOT NULL,
    o_date	CHAR(10) NOT NULL,
    o_cnum	CHAR(5) NOT NULL,
    o_pcode	CHAR(6) NOT NULL,
    o_pname	nVARCHAR2(125),
    o_price	NUMBER,
    o_qty	NUMBER,
    o_total	NUMBER
);

-- tbl_order table을 만들면서, 여기에 추가될 데이터 중 1개의 칼럼으로는 pk 생성이 불가능해서 임의의 일련번호 칼럼을 추가해 pk로 선언
-- 이런 상황의 경우 데이터를 추가할 때 일일이 o_seq 칼럼에 저장된 데이터들을 살펴보고, 등록되지 않은 숫자를 생성해 seq를 정하고 insert 수행
--      ->이런 방식은 코드를 매우 불편하게 만드는 결과 초래
-- 이러한 불편을 방지하기 위해 SEQUENCE라는 객체 사용, 자동으로 일련번호 생성

CREATE SEQUENCE seq_order
START WITH 1 INCREMENT BY 1;

-- 표준 SQL에서 간단한 계산을 할 때 SELECT 3+4; 와 같은 명령문으로 3+4의 결과 확인 가능
-- Oracle에서는 SELECT 명령문에 FROM [table] 절이 없으면 문법 오류 발생
-- 이런 경우 시스템에 이미 준비되어 있는 DUAL이라는 DUMMY table을 사용하여 코딩
SELECT 3+4 FROM DUAL;

-- seq_order 객체의 nextval이라는 모듈(함수 역할)을 호출하여 변화되는 일련번호를 출력하는 코드
SELECT SEQ_ORDER.nextval FROM DUAL;

-- 이 seq_order의 nextval 모듈을 사용하여 INSERT 수행 시 일련번호를 자동으로 부여할 수 있다.

/*
주문번호,고객번호,상품코드
O00001  C0032   P00001
O00001  C0032   P00002
O00001  C0032   P00003
*/
INSERT INTO tbl_order(o_seq, o_date, o_num, o_cnum, o_pcode)
VALUES (SEQ_ORDER.nextval, '2020-07-21', 'O00001', 'C0032', 'P00001');
INSERT INTO tbl_order(o_seq, o_date, o_num, o_cnum, o_pcode)
VALUES (SEQ_ORDER.nextval, '2020-07-21', 'O00001', 'C0032', 'P00002');
INSERT INTO tbl_order(o_seq, o_date, o_num, o_cnum, o_pcode)
VALUES (SEQ_ORDER.nextval, '2020-07-21', 'O00001', 'C0032', 'P00003');

SELECT o_num, o_cnum, o_pcode FROM tbl_order;

/*
tbl_order table에 위와 같은 데이터가 있을 때
    O00001  C0031   P00001
이러한 데이터를 추가한다면 아무런 제약 없이 값이 추가된다.
*/
INSERT INTO tbl_order(o_seq, o_date, o_num, o_cnum, o_pcode)
VALUES (SEQ_ORDER.nextval, '2020-07-21', 'O00001', 'C0032', 'P00001');

/*
주문번호, 고객번호, 상품코드 이 3개의 칼럼 묶음의 값이 중복되면 INSERT가 수행되지 않도록 제약조건을 설정해야 한다.
UNIQUE : 칼럼에 값이 중복되어 INSERT가 수행되는 것을 방지
주문테이블에 UNIQUE 제약조건 추가하기
*/
ALTER TABLE tbl_order ADD CONSTRAINT UQ_ORDER UNIQUE (o_num, o_cnum, o_pcode);
-- UNIQUE를 추가하는데 이미 UNIQUE 조건에 위배되는 값이 있으면 제약조건이 추가되지 않는다.
-- duplicate keys found : PK, UNIQUE로 설정된 칼럼에 값을 추가하거나, 이미 중복 값이 존재하는 경우에 PK, UNIQUE를 설정하려 할 때 발생

-- UNIQUE 제약조건을 추가하기 위해 마지막에 추가된 데이터를 제거하는 명령문을 실행
--      -> 삭제되어서는 안 되는 중요한 주문정보 1건이 같이 삭제
--      이 Table의 데이터는 무결성을 상실하게 된다 : 삭제 이상
DELETE FROM tbl_order
WHERE o_num='O00001' AND o_cnum='C0032' AND o_pcode='P00001';

-- 현재 일련번호 칼럼이 생성되어 있기 때문에 PK를 기준으로 값을 삭제할 수 있다.
SELECT * FROM tbl_order;

DELETE FROM tbl_order WHERE o_seq=14;

ALTER TABLE tbl_order ADD CONSTRAINT UQ_ORDER UNIQUE (o_num, o_cnum, o_pcode);

/*
후보키 중 단일 칼럼으로 PK를 설정할 수 없는 상황이 발생하면 복수의 칼럼으로 PK를 설정하는데 UPDATE나 DELETE를 수행할 때, 
    WHERE 칼럼1=값 AND 칼럼2=값 AND 칼럼3=값 ... 과 같은 조건을 부여해야 한다.
    -> 데이터의 무결성을 유지하는 데 매우 좋지 않은 환경
이런 경우 데이터와 상관 없는 SEQ 칼럼을 만들어 PK로 설정한다.
*/

select * from tbl_order;

INSERT INTO tbl_order(o_seq, o_date, o_num, o_cnum, o_pcode)
    VALUES (SEQ_ORDER.nextval, '2020-07-21', 'O00003', 'C0022', 'P00001');