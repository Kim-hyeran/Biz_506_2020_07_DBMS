-- user1 독서록 프로젝트

create table tbl_books (
    seq NUMBER PRIMARY KEY,
    title nVARCHAR2(125) NOT NULL,
    link nVARCHAR2(255),
    image nVARCHAR2(255),
    author nVARCHAR2(125),
    price NUMBER,
    discount NUMBER,
    publisher nVARCHAR2(125),
    isbn CHAR(13),
    description nVARCHAR2(2000),
    pubdate CHAR(15),
    buydate CHAR(10),
    buyprice NUMBER,
    buystore nVARCHAR2(50)
);

create sequence seq_books
start with 1 increment by 1;

insert into tbl_books (seq, title, author, publisher)
values(seq_books.nextval, '자바입문', '박은종', '이지스퍼블리싱');

insert into tbl_books (seq, title, author, publisher)
values(seq_books.nextval, '오라클데이터베이스', '이지훈', '이지스퍼블리싱');

delete from tbl_books;

commit;