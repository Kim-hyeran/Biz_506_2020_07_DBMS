-- USER1 독서록 프로젝트

drop table tbl_member;

create table tbl_member (
    M_USER_ID VARCHAR2(30) PRIMARY KEY,
    M_PASSWORD nVARCHAR2(255) NOT NULL,
    M_NAME nVARCHAR2(30),
    M_TEL VARCHAR2(30),
    M_EMAIL VARCHAR2(30),
    M_ADDRESS nVARCHAR2(125),
    M_ROLE VARCHAR2(20),
    -- ENABLE 칼럼에 문자열 0 또는 1 이외의 값은 저장하지 않도록 하는 명령어
    -- CHECK 제약사항 등록
    ENABLED CHAR(1) DEFAULT '0' CONSTRAINT enable_veri CHECK(ENABLED='0' OR ENABLED='1'),
    AccountNonExpired CHAR(1),
    AccountNonLocked CHAR(1),
    CredentialsNonExpired CHAR(1)
);

create table tbl_authority (
    seq NUMBER 	PRIMARY KEY,
    M_USERID VARCHAR2(30) NOT NULL,	
    M_ROLE VARCHAR2(30) NOT NULL
);

create sequence seq_authority
start with 1 increment by 1;

SELECT * FROM tbl_member;

delete from tbl_member;
delete from tbl_authority;

commit;

SELECT * FROM tbl_authority;

-- 한 개의 table에 여러 개의 데이터를 insert 할 때 사용하는 다중 insert sql이다.
-- seq 값으로 PK를 설정하면 SQL이 작동하지 않는다.
insert all
    into tbl_member (m_user_id, m_password) values ('user1', 1)
    into tbl_member (m_user_id, m_password) values ('user2', 1)
    into tbl_member (m_user_id, m_password) values ('user3', 1)
    into tbl_member (m_user_id, m_password) values ('user4', 1)
    into tbl_member (m_user_id, m_password) values ('user5', 1)
select * from dual;

-- seq 값을 시퀀스의 nextval 값으로 설정하는 table의 경우 다중 insert에 오류가 발생한다.
insert all
    into tbl_authority (m_userid, m_role) values ('admin', 'ADMIN')
    into tbl_authority (m_userid, m_role) values ('admin1', 'ADMIN')
    into tbl_authority (m_userid, m_role) values ('admin2', 'ADMIN')
    into tbl_authority (m_userid, m_role) values ('admin3', 'ADMIN')
select * from dual;

delete from tbl_authority;

-- oracle에서 seq PK 칼럼을 가진 table dp 다중 insert문 수행
-- 1. 추가할 데이터를 갖는 가상의 table 생성
-- 2. 가상 table 생성 sql을 subquery로 묶는다.
-- 3. subquery 부모 sql에서 seq.nextval을 실행하여 unique한 seq 생성
-- 4. 생성된 가상테이블 데이터를 insert문을 사용하여 table에 추가
-- 5. 생성된 가상테이블의 데이터를 tbl_authority table에 복사하는 코드
insert into tbl_authority (seq, m_userid, m_role)
select seq_authority.nextval, sub.* from (
-- 가상테이블
    select 'user11' as username, 'ROLE_ADMIN' as authority from dual
    union all
    select 'user11' as username, 'ROLE_USER' as authority from dual
    union all
    select 'user12' as username, 'ROLE_ADMIN' as authority from dual
    union all
    select 'user12' as username, 'ROLE_USER' as authority from dual
) sub;

select * from tbl_authority;

delete from tbl_member;
delete from tbl_authority;

select * from tbl_member;
select * from tbl_authority;

commit;

select * from tbl_member M
    left join tbl_authority A
        on m.m_user_id=a.m_userid;
        
update tbl_member set enabled=1 where m_user_id='user';