-- user1 접속화면입니다

select * from tbl_product;

select min(p_code) from tbl_product;
select max(p_code) from tbl_product;

insert into tbl_product (p_code, p_name)
values ('P001', '테스트상품');

select * from tbl_product where p_code=RPAD('P001', 6, ' ');

commit;

select RPAD('가', 10, 'P') from dual;

/*
 테이블에서 1개의 칼럼으로 PK를 설정할 수 없을 경우 2개 이상의 칼럼을 묶어서 PK로 설정한다.
 하지만 아래 테이블에서 sc_num, sc_subject를 묶어서 PK로 설정할 경우 sc_subject 칼럼이 가변문자열인 관계로 추후 문제 발생 가능성이 있다.
 이러한 테이블에서는 데이터와 별도로 SEQ(ID)라는 칼럼을 만들어 일련번호 등을 부여하고 PK로 설정하는 것이 좋다.
*/
create table tbl_score(
    sc_num char(5),
    sc_subject nvarchar2(20),
    sc_score number
);