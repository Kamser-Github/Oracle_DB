# 객체의 종류
> 핵심포인트
```
1.USER_,ALL_접두어를 사진 데이터 사전 뷰의 의미와 사용법
2.인덱스 의미와 생성방법
3.뷰 생성 방법과 사용 이유
4.시퀸스 사용 방법
```
## 데이터 베이스를 위한 데이터를 저장한 데이터 사전
### `데이터 사전이란?`
```
오라클 데이터베이스 테이블
1.사용자 테이블(USER TABLE) : Normal Table
2.데이터 사전(data dictionary) : Base Table

사용자 테이블 : 데이터 베이스를 통해 관리할 데이터를 저장하는 테이블
 즉 ) DB를 통해서 데이터를 테이블 형식에 넣는것(INSERT,CREATE등)

데이터 사전 : 데이터베이스를 구성,운영하는데 필요한 정보를 저장한 테이블
 즉 ) 데이터베이스를 굴릴수 있게 정보를 저장한것
              데이터베이스 메모리,성능,사용자,권한,객체등도 보관되어있다.
따라서,
직접 사용자가 데이터 사전에 접근하여 수정을 할수는 없지만
VIEW를 제공, SELECT로 정보 열람이 가능하다.

```
> 데이터 사전 뷰 
```
   접두어                       설명
   -----                        ---
 USER_XXXX         현재 데이터베이스에 접속한 사용자가 보유한 객체 정보

 ALL_XXXXX         현재 데이터베이스에 접속한 사용자가 소유한 객체 또는
                   다른 사용자가 소유한 객체중 사용허가를 받는 객체
                   사용 가능한 모든 객체 정보

 DBA_XXXXX         데이터베이스 관리를 위한 정보(데이터베이스 관리 권한을 가진
                   SYSTEM,SYS 사용자만 열람 가능)

 V$_XXXXXX         데이터베이스 성능 관련 정보(X$_XXXX 테이블 뷰)
 ```
 > 사용 가능한 데이터 사전을 조회
 ```
 SELECT * FROM DICT;
 ```
 ```
 SELECT * FROM DICTIONARY;
 ```
 <br><br>

 ## 더 빠른 검색을 위한 인덱스
 ### `인덱스란?`
```
데이터베이스 검색 성능의 향상을 위해서 테이블 열에 사용하는 객체
테이블에 특정 행 데이터 주소,위치 정보를 책 목록처럼 만들어 놓은것

인덱스 사용에 따라
Table Full Scan : 테이블 데이터를 처음부터 끝까지 검색하여 원하는 정보를 찾는것
Index Scan      : 인덱스를 통해서 데이터를 찾는 방식

인덱스도 오라클 데이터베이스 객체이므로 사용자와 사용권한이 존재한다.
```
> 소유한 계정의 인덱스 정보를 알기   

```
SELECT * FROM USER_INDEX;
```
> 소유한 계정의 컬럼명 알기
```
SELECT * FROM USER_ID_COLUMNS;
```   

 ### `인덱스 생성?`
```
자동으로 생성되는거 인덱스가 이나라
  사용자가 직접 인덱스를 만들다.
```
```
CREATE INDEX [인덱스이름]
  or 테이블이름( 열이름1 ASC OR DESC,
                열이름2 ASC OR DESC,
                열이름3 ASC OR DESC,
              )
```
> 추가 정보 확인후 추가할 파트

> 인덱스 생성하기
```
CREATE INDEX IDX_VIP_GRADE;
```
> 생성된 인덱스 살펴보기
```
SELECT * FROM USER_IND_COLUMNS;
```
### `인덱스를 사용했는지 확인해보기`
```
EXPLAIN PLAN FOR 
SELECT * 
  FROM TEST1 
WHERE ID = 1;

//PLAN 테이블에 FOR 뒤에 문장이 어떻게 실행되고있는지 정보가 작성된다.

SELECT 
    PLAN_TABLE_OUTPUT 
FROM 
    TABLE(DBMS_XPLAN.DISPLAY());

그후 위 명령어를 사용하면 INDEXFMF 사용햇는지 알려준다.
```
`인덱스 사용 여부`
```SQL
--인덱스를 사용한 경우
EXPLAIN PLAN FOR 
SELECT * FROM CUSTOMERS WHERE CUSTOMER_ID<500 AND ROWNUM<6;

--인덱스를 사용하지 않은경우
EXPLAIN PLAN FOR 
SELECT * FROM CUSTOMERS WHERE CREDIT_LIMIT<9000 AND ROWNUM<6;

SELECT 
    PLAN_TABLE_OUTPUT 
FROM 
    TABLE(DBMS_XPLAN.DISPLAY());

--인덱스를 사용한 경우
|*  3 |    INDEX RANGE SCAN  | SYS_C008346 | | | 1 (0)| 00:00:01 |

--인덱스를 사용하지 않은 경우
|*  2 |   TABLE ACCESS FULL| CUSTOMERS | 5 |385 |2 (0)| 00:00:01 |
```
> 인덱스 삭제
DROP INDEX 인덱스 이름;
```
DROP INDEX IDX_VIP_GRADE;
```
> 인덱스 생성은 항상 좋은 결과가 아니다.
```
데이터 분석에 기반을 두지 않은 인덱스 생성은 성능을 오히려 떨어뜨린다.
데이터의 종류,분포도,조회하는 SQL의 구성,
데이터 조작 관련SQL문의 작업빈도,검색 결과가 전체 데이터에 차지하는 비중

자세한건 SQL 튜닝(tunning) 관련 서적,인테넷 참고
```

## 테이블처럼 사용하는 뷰

### `뷰란?`
```
가상 테이블(virtual table)로 부르는 뷰는 
하나 이상의 테이블을 조회하는 SELECT 문을 저장한 객체를 말한다.
-
SELECT문을 저장하기 때문에 물리적 데이터를 저장하지 않는다.
```

### `뷰의 사용목적(편리성)`
1. 편리성 : SELECT문의 복잡도를 완화
2. 보안성 : 테이블의 특정 열을 노출하고 싶지않은 경우

### `뷰의 사용 목적(보안성)`
```
특정 테이블에서 개인정보가 들어있는 경우라면
테이블을 검색하게되면 개인정보가 노출이된다

이때 VIEW를 통해서 특정 열만 열람할수 있게된다면
특정 컬럼의 정보를 노출을 없앨수가 있다.
```

### `뷰의 생성`
> 뷰 생성은 권한이 필요하다
```
SYSTEM, SYS로 로그인후
GRANT CREATE VIEW TO (사용자 명);
```
> 기본 양식
```
                         또는
CREATE [OR REPLACE][FORCE | NOFORCE] VIEW [뷰 이름](열 이름 , 열 이름2.,...)
        AS(저장할 SELECT문)
[WITH CHECK OPTION][(CONSTRIANT 제약조건)]
[WITH READ ONLY][(CONSTRIANT 제약조건)];

      요소                  설명
      ---                   ---
  OR REPLACE        같은 이름의 뷰가 존재할경우 이걸로 생성
  FORCE             뷰가 저장할 SELECT가 테이블이 존재안해도 생성.
  NOFORCE           뷰가 저장할 SELECT가 테이블이 존재할 경우애만(기본)
  뷰 이름           생성할 뷰 이름을 지정(필수)
  열 이름           SELECT문에 명시된 이름 대신 "사용할 열 이름" 지정
  저장할 SELECT문   생성한 뷰에 저장할 SELECT문 지문지정(필수)
WITH CHECK OPTION   지정한 제약 조건을 만족하는 데이터에 한해
                    DML, 작업이 가능하도록 뷰 생성(선택)
WITH READ ONLY      뷰의 열람,SELECT만 가능하도록 뷰 생성(선택)
```
> 예시
```
CREATE VIEW PR( A,B,C)
    AS(SELECT EMPLOYEE_ID,FIRST_NAME,MANAGER_ID FROM EMPLOYEES WHERE MANAGER_ID=1)
    WITH READ ONLY;
    
SELECT * FROM PR;

         A B                   C
---------- ---------- ----------
         3 Blake               1
         2 Jude                1
       102 Emma                1
        15 Rory                1
        49 Isabella            1
        48 Jessica             1
        47 Ella                1
        46 Ava                 1
        50 Mia                 1
        25 Ronnie              1
        24 Callum              1
        23 Jackson             1
        22 Liam                1
        21 Jaxon               1
```
> 생성한 뷰 확인하기   
```
SELECT VIEW_NAME,TEXT_LENGTH,TEXT
FROM USER_VIEWS;
```
> 뷰 삭제
```
DROP VIEW PR;
```

### `인라인 뷰를 사용한 TOP-N SQL문`
```
CREATE 문으로 객체만들어지는 뷰 외에 일회성으로 생기는 뷰를 말함
```
> 인라인 뷰와 ROWNUM을 사용하여 순서대로 순위매기기
```
ROWNUM을 추가로 조회하기

SELECT ROWNUM,E.*
  FROM EMP E;

ROWNUM은 FROM이 테이블을 가져오고 저장순서대로 차곡차곡
데이터를 쌓을때마다 번호를 지정하는 열이다.

따라서 WHERE절로 ROWNUM>5 이렇게 지정할 경우
데이터를 가져오고 ROWNUMD는 1을 갖게 되는데
WHERE절이 ROWNUM>5이기 때문에 해당 행 데이터는 제외된다

따라서 ROWNUM으로 다태롭게 사용하려면 
ROWNUM을 서브쿼리로 묶어서 사용을 하는데
여기서 별칭을 지어주지 않고 ROWNUM을 부르면

다시 해당 메인 SELECT문의 ROWNUM이 불러와져서
별칭으로 불러와야한다

```
> 예시 (서브쿼리)
```
SELECT * 
FROM(SELECT ROWNUM A,E.* 
    FROM (SELECT * 
        FROM EMPLOYEES 
        ORDER BY MANAGER_ID,EMPLOYEE_ID) E)
WHERE A>5;   
```
> 예시 (WITH절)
```
WITH
E AS (SELECT * FROM EMPLOYEES ORDER BY MANAGER_ID,EMPLOYEE_ID),
A AS (SELECT ROWNUM R,E.* FROM E)
SELECT *
    FROM A
WHERE R>5;
```
## 규칙에 따라 순번을 생성하는 시퀸스
### `시퀸스란 ?`
```
오라클 데이터베이스에서 특정 규칙에 맞는 연속 숫자를 생성하는 객체
다음 사용자의 번호를 계속 만들어 준다

다음 숫자를 추출하는거라면 MAX로 최대값을 구하고 거기에 1을 더하면되는데

데이터가 많아 질수록 번호를 계산하는 시간이 늘고
사용하는 사람이 동시에 사용할경우 번호가 겹칠수도 있다.
```
> 시퀸스 사용가능한 영역
```
[사용규칙]
  * NEXTVAL, CURRVAL을 사용할 수 있는 경우   
  - subquery가 아닌 select문   
  - insert문의 select절   
  - insert문의 value절   
  - update문의 set절
  
  * NEXTVAL, CURRVAL을 사용할 수 없는 경우   
  - view의 select절   
  - distinct 키워드가 있는 select문   
  - group by, having, order by절이 있는 select문   
  - select, delete, update의 subquery   
  - create table, alter table 명령의 default값
  
  ** CMD에서는 자동으로 추가할수 없지만
  프로그램에서는 자동으로 추가할수있다
  테이블 -> 테이블명 클릭 -> 
  열 -> 편집 우측하단 -> 
  ID열 -> 열 시퀀스 -> 시퀀스 추가
  **
```

### `시퀸스 생성`
> 단순 번호 생성 객체이지만 효율적으로 번호 생성이 가능하다.
```
CREATE SEQUENCE 시퀸스 이름
[INCREMENT BY n] (필수) 증가값 , 기본 = 1
[START WIRH n] (선택) 시작값 , 기본 = 1
[MAXVALUE n | NOMAXVALUE] (선택) 최댓값 , 내림차순일땐 -1
[MINVALUE n | NOMINVALUE] (선택) 최솟값 , 오름차순일때 1
[CYCLE | NOCYCLE] 최대,최소로 갈경우 다시 초기화,안할경우 에러발생
[CACHE n | NOCACHE] 미리 번호생성,속도 향상에 도움됨
```
> 시퀸스 생성
```
CREATE SEQUENCE JUMP10
INCREMENT BY 10
START WITH 10
MAXVALUE 90
MINVALUE 0
NOCYCLE
CACHE 2;

// 시작 10 누적 10 최대/최소 90/0 
   최대/최소에 도착후 한번더 사용시 에러
   미리 만들어놓은 값 2개씩
```
### `SEQUENCE 사용`
```
[시퀸스 이름.CURRVAL] => 마지막에 생성된 번호를 반환
                        단 한번도 안쓰고 이걸쓰면 만든적이 없으로 에러발생
[시퀸스 이름.NEXTVAL] => 다음 생성번호를 반환.
```
> 예시
```
INSERT INTO SEQUENCE_A VALUES(JUMP10.NEXTVAL);
```
> 마지막 번호 확인
```
SELECT JUMP10.CURRVAL FROM DUAL;
```

### `시퀸스 수정`
```
ALTER,DROP으로 수정,삭제한다
단 START WITH값 (시작값) 은 변경이 안된다.
```
> 양식
```
CREATE SEQUENCE 시퀸스 이름
[INCREMENT BY n] <필수>
[MAXVALUE n | NOMAXVALUE] <선택>
[MINVALUE n | NOMINVALUE] <선택>
[CYCLE | NOCYCLE] <선택>
[CACHE n | NOCACHE] <선택>
```
> 예시
```
ALTER SEQUENCE JUMP10
INCREMENT BY 3
MAXVALUE 9999
NOMINVALUE
CYCLE
CACHE 10;

CYCLE 옵션을 사용할경우 

오름차순일땐 MAX값을 지정
내림차순일땐 MIN값을 지정
```
> 시퀸스 옵션 조회하기
```
SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME='JUMP10';
여기서 WHERE로 조건을 걸지 않았을 경우
사용자의 시퀸스가 전부 조회가 된다.
```
### `시퀸스 삭제`
```
DROP SEQUENCE [시퀸스 명]

단 시퀸스로 추가된 데이터 행들은 삭제 되지 않는다.
```
### `





## 공식 별칭을 지정하는 동의어
### `동의어란 ?`
```
동의어(synonym)는 데이블,뷰,시퀸스등 
  객체 이름 대신 사용할 수 있는 다른 이름을 부여하는 객체

테이블의 이름이 길어 사용이 불편할때 간단하고 짧은 이름을 만들어주는것
```
> 생성
```
CREATE [PUBLIC] SYNONYM 동의어 이름
FOR [사용자.][객체이름];

PUBLIC      동의어를 데이터베이스 내 모든 사용자가 사용할수 있도록 설정
            생략할 경우 동의어를 생성한 사용자만 사용가능(선택)
       -
동의어 이름  생성할 동의어 이름(필수)
사용자.      객체 소유자를 지정,미지정시 접속한 사용자로 지정(선택)
객체이름     동의어를 생성할 대상 객체이름(필수)

일회성이 아니라는점이 별칭과 차이점이다.
```
> 동의어 생성 권한 필요,PUBLIC 권한 부여도 선택
```
SYSTEM으로 접속
GRANT CREATE SYNONYM TO 사용자;
GRANT CREATE PUBLIC SYNONYM TO 사용자;
```
### `동의어 생성`
```
CREATE SYNONYM EMP
FOR EMPLOYEES;

SELECT * FROM EMP;
```
### `동의어 삭제`
```
DROP SYNONYM EMP;
```
