-- MySQL에서 사용자는 기본적으로 root 계정으로 시작
/*오라클과의 차이점
구분			Oracle					MySQL
저장소		TableSpace				DataBase
Schema		User					DataBase
데이터저장		User.Table형식			Table
User		Schema					login하는 Account

1. MySQL 데이터를 저장하기 위해서 최초로 DataBase 생성
2. 생성된 Database를 사용 가능하도록 Open
3. 사용자 login 권한과 접속 용도의 Account
*/

drop database myDB;

-- MySQL character set : 저장하는 문자열의 코드길이(Byte) 관련 설정
-- MySQL 5.x(5.7)에서는 문자 Locale 설정 기본값이 Lathin이어서 한글과 같은 unicode 저장에 상당한 문제가 존재하였음
-- 최근에는 기본 문자 Locale UTF8M4 방식으로 대부분 통일되었다.
-- 따라서 별도의 character set을 지정하지 않아도 문제 없다.
-- 오래된 MySQL 버전에서는 Database를 생성할 때 character set을 명시해주었으나 최근 버전에서는 경고를 출력한다.
# #기호를 사용하여 주석을 달 수도 있다.

-- 현재 PC에 설치된 MySQL 서버에 myDB라고 하는  Schema(Database)를 생성
create database myDB; -- default character set utf8;

-- MySQL에서는 데이터와 관련된 DDL, DML, DCL 등의 명령을 수행하기 전 사용할 Schema를 Open하는 절차 필요
-- myDB DataBase Open
use myDB;

/* MySQL 칼럼 Type
- 문자열 : CHAR(갯수), VARCHAR(갯수)
	CHAR : 고정된 문자열을 저장하는 칼럼(코드 등의 데이터) (255자 까지)
	VARCHAR : 한글을 포함한 가변형 문자열을 저장하는 칼럼(655365자 까지)
- 정수형 : INT(4byte, 2의 32승), BIGINT(8byte, 무제한), TINYINT(1byte, (-128)~(+127), 0~255), SMALLINT(0~65535), MEDINT(0~1677215)
	자릿수를 명시하지 않으면 최대 지원 크기까지 저장 가능
    -> 실제 저장 시 INT형은 정수 11자리를 넘어가면 저장 불가
- 실수형 : FLOAT(길이, 소수점, 4byte), DECIMAL(길이, 소수점), DOUBLE(길이,소수점, 8byte)
*/

drop table tbl_student;
create table tbl_student
(
	st_num CHAR(5) PRIMARY KEY,
	st_name VARCHAR(20) NOT NULL,
	st_dept VARCHAR(20),
	st_grade INT,
	st_tel CHAR(20),
	st_addr VARCHAR(125),
	st_age INT
);

desc tbl_student;

select * from tbl_student;

drop table tbl_score;

create table tbl_score
(
sc_num CHAR(5) NOT NULL,
sc_scode CHAR(4) NOT NULL,
sc_sname VARCHAR(30),
sc_score INT
);

-- PROJECTION
select st_num, st_name, st_tel
from tbl_student;

-- SELECTION
select st_num, st_name
from tbl_student
where st_num between '20001' and '20010';

select * from tbl_dept;

select st.st_num, st.st_name, st.st_dept, d.d_name, d.d_prof
from tbl_student ST
	left join tbl_dept D
		on st.st_dept=d.d_code;

select count(*) from tbl_iolist;

select io_bcode from tbl_iolist;

-- decode()
select io_bcode, 
	sum(case when io_inout='매입' then io_amt else 0 end) as '매입합계',
	sum(case when io_inout='매출' then io_amt else 0 end) as '매출합계'
from tbl_iolist
group by io_bcode;

select 
	sum(case when io_inout='매입' then io_amt else 0 end) as '매입합계',
	sum(case when io_inout='매출' then io_amt else 0 end) as '매출합계',
    sum(case when io_inout='매출' then io_amt else 0 end)-sum(case when io_inout='매입' then io_amt else 0 end) as '이익금'
from tbl_iolist;

-- 현재 schema의 table list
show tables;

-- 현재 MySQL Server에 생성된 Schema(Database) list
show databases;

desc tbl_score;

-- tbl_score table에 데이터 추가
-- 학번 20001인 학생의 국어(D001), 영어(D002), 수학(D003) 점수를 입력한다면
insert into tbl_score(sc_num, sc_scode, sc_sname, sc_score)
values ('20001','D001','국어', 80);
insert into tbl_score(sc_num, sc_scode, sc_sname, sc_score)
values ('20001','D002','영어', 70);
insert into tbl_score(sc_num, sc_scode, sc_sname, sc_score)
values ('20001','D003','수학', 75);

insert into tbl_score(sc_num, sc_scode, sc_sname, sc_score)
values ('20002','D001','국어', 75);
insert into tbl_score(sc_num, sc_scode, sc_sname, sc_score)
values ('20002','D002','영어', 80);
insert into tbl_score(sc_num, sc_scode, sc_sname, sc_score)
values ('20002','D003','수학', 60);

delete from tbl_score;

select * from tbl_score;

-- 한 개의 칼럼으로 PK를 만들 때는 설계 단계에서부터 고려를 하고, table을 생성할 때 만드는 것이 편리
-- 두 개 이상의 복합키를 만들 때는 보통 테이블 설계가 왼료되고 table을 만들고 데이터가 추가되는 과정에서 생성되는 경우가 다수
-- 두 개 이상의 후보키를 묶어서 PK로 설정하는 복합키 PK
alter table tbl_score add primary key(sc_num, sc_scode);

-- pk 삭제
alter table tbl_score drop primary key;

select * from tbl_score;

-- 임의의 table 생성 후 pk를 설정하는 과정에서 단일키로 pk 설정이 어려워 복합키로 설정해야하는 상황에서, 복합키를 사용하지 않기 위해서
-- 실제 데이터와는 관계 없는, pk 설정만을 위한 별도의 칼럼을 생성해 일련번호와 같은 값을 넣어 pk로 설정하기
-- 		-> insert보다는 update, delete의 무결을 위한 설정

-- auto_increment, auto increment
-- pk를 점진적으로(1씩 증가하도록) 자동 생성하는 명령어

-- 이미 사용중인 테이블에 일련번호를 채울 pk만을 위한 칼럼을 생성하는 방법
alter table tbl_score add sc_seq bigint primary key auto_increment;

desc tbl_score;
select * from tbl_score;

-- 설계를 하면서 일련번호를 채울 pk만을 위한 칼럼을 생성하는 방법
create table tbl_score
(
sc_seq BIGINT PRIMARY KEY AUTO_INCREMENT,
sc_num CHAR(5) NOT NULL,
sc_scode CHAR(4) NOT NULL,
sc_sname VARCHAR(30),
sc_score INT
);

select * from tbl_score;

insert into tbl_score(sc_num, sc_scode, sc_sname, sc_score)
values('20003', 'D001', '국어', 90);
insert into tbl_score(sc_seq, sc_num, sc_scode, sc_sname, sc_score)
values(0,'20003', 'D001', '국어', 90);