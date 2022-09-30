# 레코드와 컬렉션
> 키워드
```
+ 레코드의 의미와 사용 방법
+ 연관 배열의 의미와 사용 방법
```
## 자료형이 다른 여러 데이터를 저장하는 레코드
### `레코드란`
```
레코드는 자료형이 각기 다른 데이터를 하나의 변수에 저장하는데 사용
```
> 기본 형식
```
TYPE 레코드 이름 IS RECORD(
    변수 이름 자료형 NOT NULL := (또는 DEFUALT) 값 또는 값이 도출되는 여러 표현식
)

자료형에 %TYPE , %ROWTYPE도 가능
```
_예_
```
SET SERVEROUTPUT ON;
DECLARE
    TYPE RECO IS RECORD(
        NO NUMBER(2) NOT NULL := 99,
        NAME2 EMPLOYEES.FIRST_NAME%TYPE,
        MANAGER2 employees.manager_id%TYPE
    );
    sub_reco RECO;
BEGIN
    sub_reco.NO := 88;
    sub_reco.NAME2 := 'KAMSER';
    sub_reco.MANAGER2 := 22;
    DBMS_OUTPUT.PUT_LINE('NO : '||sub_reco.NO);
    DBMS_OUTPUT.PUT_LINE('NAME : '||sub_reco.NAME2);
    DBMS_OUTPUT.PUT_LINE('MANAGER : '||sub_reco.MANAGER2);
END;
/

NO : 88
NAME : KAMSER
MANAGER : 22
```

### `레코드를 사용한 INSERT`
> 테이블에 데이터를 삽입,수정할대도 사용가능하다.   

_예_
```
DECLARE
    TYPE REC_HOME IS RECORD(
        NO HOO.CUSTOMER_ID%TYPE,
        NAME HOO.NAME%TYPE,
        LIMIT HOO.CREDIT_LIMIT%TYPE
        );
        rec_hoo REC_HOME;
    BEGIN
        rec_hoo.no := 10;
        rec_hoo.name := 'khkkd';
        reC_hoo.limit := 5500;
        
    INSERT INTO hoo
    VALUES rec_hoo;
    END;
    /
    SELECT * FROM HOO;
```
### `레코드를 사용한 UPDATE`   
> ROW키워드와 함께 레코드 이름을 명시   
 
```
DECLARE
    TYPE REC_HOME IS RECORD(
        NO HOO.CUSTOMER_ID%TYPE,
        NAME HOO.NAME%TYPE,
        LIMIT HOO.CREDIT_LIMIT%TYPE
    );
    rec REC_HOME;
    BEGIN
        rec.no := 88;
        rec.name := 'shy';
        rec.LIMIT := 3000;
        
        UPDATE HOO
        SET ROW = rec
        WHERE CUSTOMER_ID=10;
    END;
/

```
