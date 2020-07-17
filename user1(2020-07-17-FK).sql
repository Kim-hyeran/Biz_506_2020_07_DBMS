-- user1 접속 화면입니다.

/* 외래키(Foreign Key)

- 두 개(이상)의 Table 간에 Relation을 강제로 설정하여 Table에 추가되는 데이터의 무결성을 보증하는 제약조건 설정
- JOIN을 사용하여 두 개의 Table에 Relation을 설정하기도 하지만 차이점이 존재한다.
    JOIN은 단순히 View의 편리함(필요한 정보를 Projection에 포함)을 위해서 사용
    FK는 데이터를 추가하는 단계부터 잘못된 데이터가 추가되는 것을 방지하기 위한 목적
- FK는 Table을 생성할 때 만들기도 하지만, 일반적으로 Table을 생성한 후 Table 변경을 통해 만드는 것이 좋다.
- 가장 좋은 경우는 Table을 생성하고 데이터를 한 개도 추가하지 않은 상태로 설정하는 것이다.
    하지만 App을 사용하기 시작하는 초기 단계에서는 다량의 데이터를 추가해야하는 일이 많아 FK가 설정되어 있으면 Sub Table에 데이터를 추가하는 데 애로사항이 발생한다.
    이런 경우 초기에 FK를 설정하지 않거나 제거하고 데이터를 입력(추가)하는 방식을 사용한다.
- FK 관계의 Table을 부모-자식 Table로 분류하는데, FK 설정은 자식 Table에서 실시한다.
*/

-- 현재 스키마에 있는 학생정보와 성적정보 Table을 FK 관계로 설정
-- 학생정보 Table에 학생정보가 없으면 성적정보를 입력할 수 없도록 설정
-- 학생정보 Table을 부모 Table, 성적정보 Table을 자식 Table로 설정
SELECT * FROM tbl_score;

-- 학생 정보에 없는 20200 학생의 국어 성적 추가
-- 20200 학생의 국어점수가 학적정보에 이상이 없는 학생의 성적인지 확신할 수 있는 방법이 없다.
-- 따라서 이 데이터는 무결성 원칙에 위배되는 데이터일 수도 있다.
INSERT INTO tbl_score(sc_num, sc_kor) VALUES ('20200', 100);

DELETE FROM tbl_score
WHERE sc_num='20200';

/*
FK 설정이 된 두 Table 간의 관계
학생정보 st_num 데이터             성적정보 st_num 데이터
    값 추가(존재)         >>         값 존재(추가 가능)
    값 없음               >>         값 절대 없음(추가 불가)
    값이 있어야 함        <<         값 존재(추가되어 있음)

- 만약 학생정보 데이터가 필요 없어 삭제하는 경우
    1. 성적정보에서 삭제하고자 하는 학번의 성적 데이터를 모두 삭제
- 학생의 학번(st_num)을 변경할 경우
    1. 성적정보에서 변경할 학번의 성적 데이터 모두 삭제
    2. 학생정보의 학번 변경
    3. 변경된 학번으로 성적 데이터 추가

ALTER TABLE 명령은 신중하게 적용한다.
- ALTER TABLE 명령을 수행하게 되면, 명령이 시작되는 순간 Table의 모든 데이터에 접근이 금지된다.
- 저장된 데이터의 양이 매우 많다면 상당한 시간이 소요되고, Table의 데이터를 필요로하는 App은 실행이 중단된다.
- 칼럼 추가, 삭제, 이름 및 타입 변경 등의 명령은 수행할 수 있다.
    칼럼을 삭제, 변경하는 경우 기존 데이터가 손상될 위험이 존재한다.
*/

-- 생성된 FK 제약조건 삭제
ALTER TABLE tbl_score
DROP CONSTRAINT fk_st_sc CASCADE;

-- 사후(Table 생성 후) FK 설정
ALTER TABLE tbl_score           -- tbl_score(자식) Table의 설정 변경
ADD CONSTRAINT fk_st_sc         -- 제약조건(정책, policy)을 추가(add)
FOREIGN KEY(sc_num)             -- 외래키를 sc_num 칼럼을 기준으로
REFERENCES tbl_student(st_num)  -- 부모 Table : tbl_student, 연동(연결)할 부모 칼럼 : st_num
ON DELETE CASCADE;              -- 만약 부모 Table에서 데이터를 삭제할 때 지워지는 키 값의 데이터가 자식 Table에 존재하는 경우 함께 삭제

DELETE FROM tbl_student WHERE st_num='20001';

/* Oracle 미지원 코드(표준 문법에서는 사용 가능)
ON DELETE CASCADE SET NULL : 제약조건을 삭제하고 남은 공간을 NULL 값으로 설정
ON UPDATE CASCADE : 부모 Table에서 키 값이 변경되면 자식 Table의 모든 데이터를 찾아 같은 값으로 변경
*/

/*
FK를 설정하는 대상
- Table 간의 데이터가 1:N인 경우 : N 상태의 Table
    REFERENCES : 1에 해당하는 Table
- Table 간의 데이터가 1:1dls ruddn : Work Table
    REFERENCES : Master Table
*/

/*
학생정보, 학과정보 간 FK 설정
- 부모 Table : 1에 해당하는 Table, 학과정보
    학과정보는 학과명(코드)이 유일한 값으로 정해져있고, 같은 이름의 학과는 존재할 수 없다.
- 자식 Table : N에 해당하는 Table, 학생정보
    학생정보는 학생마다 학과가 다르거나 같을 수 있어 수없이 많은 중복 데이터가 존재한다.
*/
ALTER TABLE tbl_student
ADD CONSTRAINT FK_D_ST      --한 스키마 내에서 유일한 이름을 지어야 한다.
FOREIGN KEY (st_dept)
REFERENCES tbl_dept(d_code);