-- ����� ������ ȭ���Դϴ�

-- ��α׸� ���� TableSpace ����
create tablespace blogTS
datafile 'C:/bizwork/oracle_dbms/blog.dbf'
size 1m autoextend on next 1k;

-- user1 ����� ����
create user user1 identified by user1
default tablespace blogTS;

-- user1�� ���� �ο�
grant dba to user1;