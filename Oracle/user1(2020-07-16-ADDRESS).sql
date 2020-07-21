-- user1 화면입니다.

CREATE TABLE tbl_address (
ad_seq	CHAR(5) PRIMARY KEY,
ad_name	nVARCHAR2(20) NOT NULL,
ad_tel	VARCHAR2(20),
ad_addr	nVARCHAR2(125)		
);

CREATE TABLE tbl_hobby (
ad_seq	CHAR(5) NOT NULL,
ho_name	nVARCHAR2(20) NOT NULL
);

--------------------------------------------------------------------------------
-- 2개의 테이블(주소, 취미)이 1:N(다수) 관계의 상태

-- 보조테이블에 있는 데이터가 주테이블의 PK값을 다수 가지고 있는 경우, 두 테이블을 JOIN하면
--    보조테이블의 레코드 갯수만큼 주테이블의 데이터가 더 추가된 것처럼 보인다.
SELECT *
FROM tbl_address AD
    LEFT JOIN tbl_hobby HO
        ON ad.ad_seq=ho.ad_seq
ORDER BY ad.ad_name;

/*
    등산
    낚시
    여행
    독서
    음악감상
    묵묵부답
    기타
    노래
    음주
    가무
*/


/*
DECODE와 비슷한 JAVA 코드
1.  if(ho_name=='등산') {
        return O;
    } else {
        return ' ';
        
2. str=ho_name=='등산'? 'O':' ';
*/
--취미(ho_name의 값이)가 '등산'인 경우에는 O, 아닌 경우에는 공백으로 표시
SELECT DECODE(ho_name, '등산', 'O', ' ')
FROM tbl_hobby;

/*
ad_seq 값은 한 사람이 여러가지 취미를 가지고 있는 경우, 같은 ad_seq가 다수 출력된다.
    A0001 등산
    A0001 낚시
이러한 형태의 리스가 출력되면 ad_seq값을 그룹으로 묶고, 취미부분을 가상의 칼럼으로 변환하여
    A0001 등산    낚시
와 같은 형식의 리스트로 보이기 위한 방법이 아래 명령어이다.
이러한 형식으로 데이터를 리스트업하는 것을 피벗(PIVOT)이라고 한다.
*/
CREATE VIEW view_hobby
AS (
    SELECT ad_seq,
        MAX(DECODE(ho_name, '등산', 'O', ' ')) AS 등산,
        MAX(DECODE(ho_name, '낚시', 'O', ' ')) AS 낚시,
        MAX(DECODE(ho_name, '여행', 'O', ' ')) AS 여행,
        MAX(DECODE(ho_name, '독서', 'O', ' ')) AS 독서,
        MAX(DECODE(ho_name, '음악감상', 'O', ' ')) AS 음악감상,
        MAX(DECODE(ho_name, '묵묵부답', 'O', ' ')) AS 묵묵부답,
        MAX(DECODE(ho_name, '기타', 'O', ' ')) AS 기타,
        MAX(DECODE(ho_name, '노래', 'O', ' ')) AS 노래,
        MAX(DECODE(ho_name, '음주', 'O', ' ')) AS 음주,
        MAX(DECODE(ho_name, '가무', 'O', ' ')) AS 가무
    FROM tbl_hobby
    WHERE ho_name IS NOT NULL
    GROUP BY ad_seq
);

SELECT ad.ad_seq, ad.ad_name, HO.*
FROM tbl_address AD
    LEFT JOIN view_hobby HO
        ON ad.ad_seq=ho.ad_seq;

/*
피벗을 사용하는 이유

- 주소록 table에 취미 항목을 필요로 하는 경우
- 한 사람이 여러가지 취미를 가질 수 있고, 경우에 따라 아무도 가지지 않은 새로운 취미가 필요할 수 있다.
- 칼럼을 취미의 갯수만큼 만들어 사용하면 초기에는 매우 쉽게 table 생성이 가능하다.
  여기서 취미가 새로이 추가되는 경우는 그 table의 물리적 구조를 변경해야하는 상황이 발생한다.
  table의 물리적 구조를 변경하는 것은 매우 위험하고, 불합리한 방법 : 데이터의 무결성 유지에 치명적
- 이런 경우가 발생할 수 있기 때문에 취미를 담는 table을 별도로 생성하여 주소록 정보와 분리하고.
  취미정보 table에는 주소정보의 값이 취미 갯수만큼 레코드로 저장하게 명령을 내린다.
- 이 데이터를 리스트업 할 때, 주소정보값 1개에 취미정보가 마치 칼럼으로 구성된 것처럼 데이터를 출력한다
*/