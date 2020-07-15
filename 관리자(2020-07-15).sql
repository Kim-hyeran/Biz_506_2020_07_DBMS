-- sys 계정으로 접속한 화면입니다.

-- TableSpace와 사용자 계정을 등록하고 사용자 계정에 권한 부여

-- Oracle 공식 : Data 저장하기 전 TableSpace 생성
/*
    TableSpace를 생성하지 않고 Table 등을 만들고 Data를 저장하면 Oracle System 폴더, System TableSpace에 데이터가 저장되어 보안 및 관리 측면에서 좋지 않다.
    실무에서 데이터를 저장할 때 저장 기간, 기본 용량 등 여러가지 환경적인 요소를 분석하여 용량을 산정, 설계하여 TableSpace 생성
    생성된 TableSpace는 용량 변경 등의 일이 어렵다.
    
    이러한 이유로 DBA 중에서도 실무 경험이 많은 개발자가 다루는 분야이다.
    때문에 관련 서적에서는 TableSpace를 다루지 않는 경우가 많다.
*/

-- TableSpace 생성 시 고려 사항
-- 이름, 저장파일, 초기 용량, (용량)자동증가옵션
-- Oracle 11gXE는 max size를 지정하지 않아도 기본값인 11G로 설정된다.
-- 최대 저장공간인 11G를 초과하여 사용할 수 없다.

CREATE TABLESPACE gradeTS
DATAFILE 'C:/bizwork/workspace/oracle_data/gradeTS.dbf'
SIZE 1M AUTOEXTEND ON NEXT 500K;

-- 생성한 TableSpace를 관리하고 Data를 조작할 User 생성
-- : 사용자 ID, 초기 비밀번호, Default TableSpace
CREATE USER grade IDENTIFIED BY grade
DEFAULT TABLESPACE gradeTS;

-- grade 사용자가 DB를 조작할 수 있도록 권한 부여
-- 권한은 세부적으로 부여하는 것이 바람직하나 실습에서는 편의성을 고려해 DBA 권한 부여
-- GRANT(권한 부여) DBA(부여할 권한, DBA:관리자 권한) TO(뒤에 작성한 사용자에게) user(사용자명);
GRANT DBA TO grade;