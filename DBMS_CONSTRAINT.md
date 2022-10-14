# 제약 조건
> 익혀야하는것
```
-제약 조건의 종류와 의미
-테이블을 생성할 때 제약 조건 지정방법
```
## 제약 조건 종류
### `제약 조건이란?`
```
테이블의 특정 열에 지정
제약 조건에 부합하는 데이터만 저장가능
```
> 제약 조건
```
    종류            설명
    ----            ----
  NOT NULL      지정한 열에 NULL을 허용하지 않고,데이터 중복 가능
   UNIQUE       지정한 열에 NULL을 허용,  데이터 중복 불가능
PRIMARY KEY     지정한 열에 NULL을 허용하지 않고,데이터 중복 불가능
FOREIGN KEY     다른 테이블을 참조하여 존재하는 값만 입력
   CHECK        설정한 조건식을 만족하는 데이터만 입력가능
```
> 데이터 무결성(data intigrity)
```
데이터 베이스에 저장되는 데이터의 정확성과 일관성을 보장한다는 의미
-이를 유지해야하는 규칙을 가지고 있다.
제약 조건은 무결성을 지키기 위한 중요한 안정장치이고
데이터 삽입(INSERT),데이터 수정(UPDATE),데이터 삭제(DELETE)등
모든 과정에서 지켜야 한다.
```
> 데이터 무결성의 종류
```
    종류                            설명
    ----                            ----
영역 무결성                 열에 저장되는 값의 적정 여부를 확인 .자료형,적절한 형식의 데이터 NULL여부
(domain integrity)          같은 정해놓은 범위를 만족하는 데이터임을 규정
개체 무결성                 테이블 데이터를 유일하게 식별할 수 있는 기본키는 반드시 값을 가지고
(entity integrity)          NULL이 될 수 없고 중복될 수도 없음을 규정
참조 무결성                 참조 테이블의 외래키 값은 참조 테이블의 기본키로서 존재
(referential integrity)     NULL이 가능
```

## 빈 값을 허락하지 않는 NOT NULL   
### `테이블을 생성시 제약 조건 지정`
```
 반드시 값이 있어야하며 중복은 허용됨
 ```
> 테이블 생성시
```
CREATE TABLE TABLE_NOT_NULL
(
    NAME  VARCHAR2(20) NOT NULL,
    AGE   NUMBER(3)   NOT NULL
    EMAIL VARCHAR2(50)
);

이 테이블의 기존 데이터가 있다고 할때
UPDATE로 값을 NULL을 줄수가 없다

제약 조건은 생성뿐만 아니라 수정및 삭제에도 영향을 준다.
```

### `제약 조건 확인하기`
> 데이터사전 USER_CONSTRAINTS 활용
```
    열 이름                 설명
    ------                  ---
    OWNER               제약 조건 소유 계정
 CONSTRAINT_NAME        제약 조건 이름(미 지정이 오라클이 자동 지정)
                -   -   -
                        제약 조건 종류
                        C:CHECK,NOT NULL
 CONSTRAINT_TYPE        U:UNIQUE
                        P:PRIMARY KEY
                        R:FOREIGN KEY 

                -   -   -
  TABLE_NAME            제약 조건을 지정한 테이블 이름
```
```
SELECT SUBSTR(OWNER,4),CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME 
FROM USER_CONSTRAINTS;
```

### `제약 조건 이름 직접 지정`
> CONSTRAINT
```
제약 조건에 이름을 붙이는 방법

CREATE TABLE A_CONST
(
    ID VARCHAR2(20) CONSTRAINT A_CONST_ID_NN    NOT NULL,
    PW VARCHAR2(20) CONSTRAINT A_CONST_PW_NN    NOT NULL,
    PHONE           VARCHAR2(20)
);
```

### `이미 생성한테이블에 제약조건 지정`
> 생성한 테이블에 제약 조건 추가하기
`NOT NULL 제약조건 추가시`
```
ALTER TABLE TEST1 
MODIFY(PW NOT NULL);

ALTER TABLE TEST1 
MODIFY PW NOT NULL;
둘다 사용이 가능하다.

단 기존 데이터에 NULL값이 없어야 변경이 가능하다.
```
> 생성한 테이블에 제약 조건 이름을 직접 지정하기
```
ALTER TABLE TEST1 
MODIFY PW CONSTRAINT TEST1_PW_NN NOT NULL;

CONSTRAINT 뒤에 제약 조건 이름이 붙는다.
```
> 제약 조건 이름 변경하기
```
ALTER TABLE TEST1 
RENAME CONSTRAINT TEST1_PW_NN TO NN_PW_TEST1;
```
> 제약 조건 삭제
```
ALTER TABLE TEST1 
DROP CONSTRAINT NN_PW_TEST1;
```

## 중복되지 않는 값 UNIQUE
> UNIQUE 지정 방법은 NOT NULL과 동일
### `테이블을 생성하며 제약조건 지정`
```
CREATE TABLE TEST1
(
    ID NUMBER UNIQUE,
    PW NUMBER,
    EMAIL VARCHAR2(20)
);
```
### `중복을 허락하지 않는 UNIQUE`
```
INSERT INTO TEST1 (ID,PW) VALUES(5,5);
//OK
INSERT INTO TEST1 (ID,PW) VALUES(5,6);
//에러 발생

//무결성 제약 조건(C##OT.SYS_C008662)에 위배됩니다
```

### `이미 생선한 테이블에 제약 조건 지정`
```
ALTER TABLE TEST1 MODIFY PW NUMBER UNIQUE;

ALTER TABLE TEST1 
ADD CONSTRAINT PK_TEST1_ID UNIQUE(ID);
```
> 중복만 없으면 수정이 가능하다
```
UPDATE TEST1
    SET EMAIL = NULL;

후 변경하면된다.
```

## 유일하게 하나만 있는 값 PRIMARY KEY
```
PRIMARY KEY 제약조건

[NOT NULL UNION UNIQUE]
1. 데이터 중복허용하지 않는다.
2. 반드시 값이 들어가야한다.
3. 테이블에 하나밖에 지정을 못한다.
4. 특정열에 지정시 자동으로 인덱스를 생성한다.
```
### `테이블 생성하며 제약 조건 지정하기`
```
CREATE TABLE TEST1
(
    ID VARCHAR2(20) PRIMARY KEY,
    PW VARCHAR2(20) NOT NULL
);
```
> 자동으로 추가된 인덱스 확인해보기
```
SELECT * 
FROM USER_IND_COLUMNS WHERE TABLE_NAME='TEST1';

> 이제 DML명령어로 COLUMN ID를 찾는 경우에
    검색속도가 빨라진다
> 단 인덱스가 무조건 빠른건 아니라고 하는데
    자세한건 나중에 배우도록 하자.
```
> 주의사항
```
PK는 다른 제약 조건과 다르게 생성 시점에 확정되는 경우가 많다.
이미 PK가 테이블에 지정되어있으면 추가 제약을 못하고
또한 특정 열에 제약조건을 추가하려고하더라도
NULL,중복값이 있으면 추가할수가 없다.
```
### `CREATE문에서 제약 조건을 지정하는 다른 방식`
> 인라인 , 열 레벨 제약 조건 정의
```
CREATE TABLE TEST1
(
    ID VARCHAR2(20) CONSTRAINT PK_TEST1_ID PRIMARY KEY,
    PW VARCHAR2(20) NOT NULL
);

열 바로 옆에 제약조건을 작성하는 형식

모든 제약 조건 사용 가능
```
> 아웃오브라인 ,테이블 레벨 제약 조건 정의
```
CREATE TABLE TEST1
(
    ID VARCHAR2(20),
    PW VARCHAR2(20) NOT NULL,
    EMAIL VARCHAR2(50),
    PRIMARY KEY(ID), -- 이름 미 지정
    CONSTRAINT [제약 조건 이름] UNIQUE(PW) -- 이름 지정
)
단 NOT NULL은 테이블 레벨 제약 조건 정의를 할수가 없다.
```
## 다른 테이블과 관계를 맺는 FOREIGN KEY
> 외래키,외부키로 불리며 서로 다른 테이블 간 관계를 정의한다.
```
특정 테이블에서 PRIMARY KEY 제약조건을 지정한 열을
다른 테이블의 특정 열에서 참조하겠다는 의미로 지정할 수 있다.
```
> 참조하는 테이블간 제약 조건 살펴보기
```
SELECT OWNER,CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME,
       R_OWNER,R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('CUSTOMERS','ORDERS');

OWNER      CONSTRAINT_NAME      CO TABLE_NAME R_OWNER    R_CONSTRAINT_NAME
---------- -------------------- -- ---------- ---------- ------------------
C##OT      SYS_C008344          C  CUSTOMERS
C##OT      SYS_C008345          C  CUSTOMERS
C##OT      SYS_C008346★        P  CUSTOMERS
C##OT      SYS_C008353          C  ORDERS
C##OT      SYS_C008354          C  ORDERS
C##OT      SYS_C008355          C  ORDERS
C##OT      SYS_C008356          C  ORDERS
C##OT      SYS_C008357          P  ORDERS
C##OT      FK_ORDERS_CUSTOMERS  R  ORDERS     C##OT      SYS_C008346★
C##OT      FK_ORDERS_EMPLOYEES  R  ORDERS     C##OT      SYS_C008334

ORDERS의 테이블의 CUSTOMER_ID 열은 
                        V
    CUSTOMERS의 CUSTOMER_ID를 참조하여 저장하기에

ORDERS.CUSTOMER_ID의 값은 NULL 이거나 
                        CUSTOMERS.CUSTOMER_ID에 존재하는 값만 저장가능하다.
```
### `FOREIGN KEY 지정하기`
> 방법 1
```
CREATE TABLE 테이블 명
(
    ...
    열 자료형 CONSTRAINT [제약 조건 이름] REFERENCES 참조 테이블명[참조할 열]
);
```
> 방법 2
```
CREATE TABLE 테이블 명
(
    ...
    열 자료형 REFERENCES 참조테이블(참조할 열)
);
```
> 방법 3
```
CREATE TABLE 테이블 명
(
    ...
    열 자료형
    CONSTRAINT [제약 조건 이름] FOREIGN KEY(열)
    REFERENCES 참조테이블(참조할 열)
)
```
> FOREIGN KEY 지정시 유의할것
```
참조할 테이블,참조할 열에 데이터가 없으면 오류가 발생하기때문에
먼저 참조할 테이블과 참조할 열에 데이터가 들어가 있어야 한다.
```
## `FOREIGN KEY로 참조 행 데이터 삭제하기`
> 참조하고 있는 열의 데이터를 삭제할수가 없다.
```
삭제하려는 해당 열의 값을 다른 테이블의 특정 열이 사용하고 있기 때문이고
방법은 3가지로 해결해야된다.

1.참조하고 있는 데이터를 삭제한다.
2.참조하고 있는 데이터를 수정한다
3.FOREIGN KEY를 해제한다.

이미 참조된 특정 열을 삭제하는건 까다롭다.
따라서 추가 옵션을 지정하여서 해결한다.
```

## `테이블 생성후 FOREIGN KEY 추가하기`
```
ALTER TABLE child_table 
ADD CONSTRAINT [fk_name]
FOREIGN KEY (col1,col2) REFERENCES parent_table(col1,col2);
```
## `FOREIGN KEY 비활성화`
```
ALTER TABLE child_table
DISABLE CONSTRAINT fk_name;

//일시적으로 비활성화한다.
SELECT TABLE_NAME,CONSTRAINT_TYPE,STATUS 
    FROM USER_CONSTRAINTS 
WHERE TABLE_NAME IN('SUB','SUPER');

//조회했을 경우에
TABLE_NAME CO STATUS
---------- -- ----------------
SUPER      C  ENABLED
SUPER      P  ENABLED
SUB        C  ENABLED
SUB        R  DISABLED

상태에서 비활성화 라고 나온다.

이때 참조 열이 삭제 되었을때 어떻게 될까?

DELETE SUPER WHERE GRADE =1; //LEVEL2가 참조하고있다.

NAME       LEVEL2
------ ----------
A               1  << 데이터가 유지중 >>
C               3
D               4
E               5

```
## `FOREIGN KEY 활성화`
```
ALTER TABLE child_table
ENABLE CONSTRAINT fk_name;


TABLE_NAME CO STATUS
---------- -- ----------------
SUPER      C  ENABLED
SUPER      P  ENABLED
SUB        C  ENABLED
SUB        R  ENABLED

다시 활성화로 변경되었다.

비활성화 하고서 참조열의 데이터를 삭제하면
FK의 값은 유지가 되는데 

이때 다시 활성화를 하면
나오면서 오류가 발생한다.
제약 (C##OT.SYS_C008678)을 사용 가능하게 할 수 없음 - 부모 키가 없습니다

```


> ### 방법 1 열 데이터 삭제시 참조하고 있는 데이터 행도 함께 삭제
```
CONSTRAINT [제약조건이름] REFERENCES 참조 테이블(참조할 열) ON DELETE CASCADE

부모의 행이 삭제되면 제거된 행을 참조하는 자식 테이블의 모든 행이 삭제됩니다.

```
> ### 방법 2 열 데이터를 삭제할때 이 데이터를 참조하는 데이터를 NULL로 수정
```
CONSTRAINT [제약조건이름] REFERENCES 참조 테이블(참조할 열) ON DELETE SET NULL

부모의 행이 삭제되면 제거된 행을 참조하는 자식 테이블의 모든 행이 외래 키 열에 대해 NULL로 설정됩니다.
```

## 데이터 형태와 범위를 정하는 CHECK
> 열에 저장할 수 있는 값의 범위,패턴을 정의할때 사용한다
```
CREATE TABLE USER_INFO
(
    ID VARCHAR2(20) PRIMARY KEY,
    -- 길이로 제약조건
    PWD VARCHAR2(50) CONSTRAINT INFO_PWD_CK CHECK(LENGTH(PWD)>3),
    -- 문자로 제약조건
    GENDER NCHAR(2) CHECK(GENDER IN ('남자' ,'여자')) NOT NULL,
    -- 정규식으로 제약조건
    PHONE CHAR(13) CHECK(REGEXP_LIKE(PHONE,'^01[016-9]-\d{3,4}-\d{4}$')) NOT NULL
);
```
> 테이블 생성후 제약조건 추가시
```
-- 정규식
ALTER TABLE TEST1
ADD CONSTRAINT CK_TEST1_PHONE 
    CHECK(REGEXP_LIKE(PHONE,'^01[016-9]-\d{3,4}-\d{4}$'));

-- LIKE
ALTER TABLE TEST 
ADD CONSTRAINT CK_TEST_PHONE
CHECK(PHONE LIKE '010-%-____');

-- 문자
ALTER TABLE USER_INFO
ADD CONSTRAINT CK_USER_INFO_PHONE
CHECK(GENDER IN ('남자' ,'여자'));

등등 CHECK 안에 다양한 연산자를 사용할수 있다.
```

## 기본값을 정하는 DEFAULT
> 제약 조건과 특정 열에 저장할 값이 지정이 되지 않을 경우 사용한다
```
CREATE TABLE TEST2
(
    ID VARCHAR2(15),
    PW VARCHAR2(20) DEFAULT '0000',
    PHONE CHAR(13) CHECK(REGEXP_LIKE(PHONE,'01[016-9]-\d{3,4}-\d{4}')),
    CONSTRAINT PK_TEST_ID PRIMARY KEY(ID),
    CONSTRAINT UK_TEST_ID UNIQUE(PHONE)
);
```
> 예시
```
INSERT INTO TEST2 (ID,PHONE) VALUES ('둘리','011-9987-1234');

SELECT * FROM TEST2;

ID         PW         PHONE
---------- ---------- --------------------
둘리       0000       011-9987-1234

값을 안넣을경우 디폴트값이 들어간다.
```