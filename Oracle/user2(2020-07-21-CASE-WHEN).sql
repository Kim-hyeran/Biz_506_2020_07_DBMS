-- user1 접속 화면입니다.

-- CASE WHEN 조건문 THEN true일때값 ELSE false일때값 END
-- DECODE(칼럼, 조건값, true일때값, false일때값)
select io_bcode, 
	sum(case when io_inout='매입' then io_amt else 0 end) 매입합계,
	sum(case when io_inout='매출' then io_amt else 0 end) 매출합계
from tbl_iolist
group by io_bcode;

-- Oracle에서 차후에 PK 생성 방법
-- 기존의 PK가 있으면 중복 생성되지 않음
-- pk_iolist : Oracle에서만 사용되는, pk를 찾는 별명
--              pk를 삭제할 일이 발생할 때 필요
alter table tbl_iolist add constraint pk_iolist primary key (io_seq, io_date);
-- pk 삭제
alter table tbl_iolist drop primary key;

create table tbl_test
(
    t_seq NUMBER PRIMARY KEY,
    t_name  nVARCHAR2(20)
);

-- Oracle에는 table에 auto_increment 명령어 설정이 존재하지 않는다.
-- 만약 일련번호와 같은 칼럼을 사용하여 pk를 생성하고 싶을 경우 곤란한 상황 발생
--    : insert를 수행할 때마다 이전에 저장된 일련번호 값을 조회하고 +1을 수행하여 다시 insert 수행하는 일을 반복해야하기 때문에
-- 대신 Oracle에는 sequence라는 특별한 객체가 존재
--      객체.NEXTVAL이라는 호출자를 사용할 때마다(select, update등에서) 내부에 가지고 있는 변수값을 사전에 정의한 규칙에 따라 자동 증가시켜 보관
-- 객체.NEXTVAL이 가지고 있는 값을 INSERT를 수행할 때 PK인 SEQ 칼럼에 주입하면 AUTO_INCREMENT와 같은 효과
CREATE SEQUENCE seq_test
START WITH 1        -- 최초 시작하는 값 설정
INCREMENT BY 1;     -- 호출될 때마다의 증가량

INSERT INTO tbl_test(t_seq, t_name)
VALUES(seq_test.NEXTVAL, '홍길동');

select * from tbl_test;