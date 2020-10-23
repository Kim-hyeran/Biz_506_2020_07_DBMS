-- user1의 접속 화면입니다

-- blog table 생성
create table tbl_blogs (
    bl_seq NUMBER PRIMARY KEY,
    bl_user nVARCHAR2(20) NOT NULL,
    bl_date VARCHAR2(10) NOT NULL,
    bl_time VARCHAR2(10) NOT NULL,
    bl_title nVARCHAR2(125) NOT NULL,
    bl_contents nVARCHAR2(2000) NOT NULL
);

-- 일련번호 생성을 위하여 sequence 생성
-- 시작값을 1로 설정하고 1씩 증가하는 조건
create sequence seq_blog
start with 1 increment by 1;

/*
 SQL Developer와 기타 다른 프로그래밍 프로젝트를 연동할 때
 SQL Developer에서 insert, update, delete를 수행했음에도 불구하고 프로젝트에서 조회되는 데이터에 반영이 안되는 경우 존재
    *원인*
    SQL Developer에서 CUD(insert, update, delete)를 수행하면 실제 로컬 스토리지의 Data에 직접 적용이 되지 않는다.
    프로그래밍 프로젝트에서 반영된 결과를 가져다 사용하려면 commit 명령을 수행해주어야 한다.
*/

insert into tbl_blogs(bl_seq, bl_user, bl_date, bl_time, bl_title, bl_contents)
values (seq_blog.nextval, '홍길동', '2020-08-14', '09:47', '나의 블로그', '블로그 만들기');

insert into tbl_blogs(bl_seq, bl_user, bl_date, bl_time, bl_title, bl_contents)
values (seq_blog.nextval, '이몽룡', '2020-08-14', '09:48', '축하합니다', '블로그 개설');

insert into tbl_blogs(bl_seq, bl_user, bl_date, bl_time, bl_title, bl_contents)
values (seq_blog.nextval, '성춘향', '2020-08-14', '09:48', '축하합니다', '블로그가 개설되었어요');

commit;

select * from tbl_blogs;