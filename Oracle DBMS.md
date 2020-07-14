## Oracle DBMS
1. 표준 SQL을 사용하는 데이터베이스 소프트웨어
2. 대용량, 분산, 고신뢰성을 보여주는 대표적인 DBMS SW
3. DBMS SW에서의 스키마 : 저장공간 단위, 그룹
4. DBMS마다 기본 스키마를 관리하는 방법에 조금씩 차이 존재
	Oracle : 사용자의 ID가 스키마의 기본 단위
5. 로그인(DB 접속)하는 사용자의 ID에 따라 관리할 수 있는 DB가 다름
6. Table Space : 데이터를 저장하는 기본 공간(로컬디스크에 저장되는 물리적 공간)
7. 사용자를 등록하면 사용자 자체가 Schema가 되며, 사용자별로 데이터를 저장하는 물리적 공간을 OS에서 관리하는 파일 단위 개념으로 사용
8. Table Space : DB를 저장하는 논리적인 개념보다는 실제 데이터가 저장되는 파일
9. 사용자를 등록하기 전 Table Space를 만들고, 사용자를 등록하면서 생성한 Table Space에 데이터를 저장하도록 연결하는 작업 필요
10. Oracle DBMS로 실습을 하면서 혹시 물리적인 DB가 저장되는 폴더나 Table Space와 연결된 파일을 git에 업로드하지 않도록 함
11. Oracle DBMS Table Space와 연결된 파일은 용량이 상대적으로 매우 커서 git에 업로드하게 되면 문제 발생 가능성

### sys 사용자 접속 설정
1. Oracle DBMS SW를 설치하면 기본적으로 DB Administer 사용자가 이미 등록되어 있음
2. System DBA : Oracle DBMS를 관리하는 최상위등급의 사용자
3. id가 sys인 user는 SQL Developer를 통해 Oracle DBMS에 접속하여 Schema, User, Table 등을 생성 및 삭제 권한 보유
4. sys user는 Oracle DBMS를 설치할 때 설정한 비밀번호로 접속 가능

### Oracle 사용자 생성
1. sys로 접속하여 SQL 실습, 개발, 운용하는 것은 보안상, 안전상 좋지 않음
2. 사용자를 등록하고, 그 사용자 ID로 접속하여 명령을 수행하도록 함

### Oracle의 사용자 생성 절차
1. 사용자를 사용(관리)할 TableSpace 생성
2. user를 생성하면서 TableSpace를 dafault로 설정
3. Oracle에서는 새로운 사용자 등록 시(기본값) 아무런 권한을 주지 않음
4. 새로운 사용자가 DB에 접속하여 무언가 업무를 수행하기 위해서는 관리자(sys)가 새로운 사용자에게 권한을 부여

### NULL
* 프로그램 코딩이나 DBMS에서 사용되는 값
* 문자열형 : 공백, 빈 칸처럼 보이지는 않지만 Code 값으로 인식되는 데이터와 구분하기 위하여 사용하는, **"아무것도 아닌 값"**이라는 개념
* String s=" ";, String s="", String=null
* DB에서 NULL 값은 칼럼에 데이터가 추가되지 않은 상태
	- INSERT를 수행하면서 해당 칼럼의 데이터를 지정하지 않았을 때
* DBMS에서 PK로 지정된 칼럼이나, NOT NULL로 지정된 칼럼은 데이터를 지정하지 않은 상태로 INSERT 명령 수행 불가

### DataBase Language
* DB Language에는 DDL, DML, DCL 명령 세트가 존재
1. DDL(Data Definition Language) : CREATE, DROP, ALTER
2. DML(Data Maniplation Language) : INSERT, SELECT, UPDATE, DELETE
3. DCL(Data Control Language) : GRANT, REVOKE, COMMIT, ROLLBACK