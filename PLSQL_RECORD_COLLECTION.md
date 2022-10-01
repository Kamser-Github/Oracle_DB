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

//여러개도 가능하다.

--수정하기
DECLARE
    TYPE REC_HOO IS RECORD(
        NO HOO.CUSTOMER_ID%TYPE,
        NAME HOO.NAME%TYPE,
        LIMIT HOO.CREDIT_LIMIT%TYPE
    );
    rec REC_HOO;
    BEGIN
        rec.no := 30;
        rec.name := 'roro';
        rec.limit := 3500;
        
        UPDATE HOO
        SET ROW = rec
        WHERE CUSTOMER_ID=88;
        
        rec.no := 55;
        rec.name := '해해';
        rec.limit := 4400;
        
        UPDATE HOO
        SET ROW = rec
        WHERE CUSTOMER_ID=200;
        
    END;
/

SELECT * FROM HOO;
```
### `레코드를 포함한 레코드`
```
--레코드 안에 레코드
--CUSTOMER의 아이디중 한명이 멀 주문햇는지 알고싶다.
DECLARE
    TYPE CUST IS RECORD(
        CU_NO CUSTOMERS.CUSTOMER_ID%TYPE,
        CU_NAME CUSTOMERS.NAME%TYPE
    );
    TYPE ORDERA IS RECORD(
        OR_ID ORDERS.ORDER_ID%TYPE,
        OR_ST ORDERS.STATUS%TYPE,
        OR_CU CUST
    );
    orderNew ORDERA;
BEGIN
     SELECT C.NAME,C.CUSTOMER_ID,O.ORDER_ID,O.STATUS 
         INTO orderNew.OR_CU.CU_NAME,orderNew.OR_CU.CU_NO,orderNew.OR_ID,orderNew.OR_ST
     FROM CUSTOMERS C,ORDERS O
     WHERE C.CUSTOMER_ID=o.customer_id
     AND O.ORDER_ID=1;
        DBMS_OUTPUT.PUT_LINE(orderNew.OR_CU.CU_NO||'번 ');
        DBMS_OUTPUT.PUT_LINE(orderNew.OR_CU.CU_NAME||' 고객님');
        DBMS_OUTPUT.PUT_LINE(orderNew.OR_ID||'주문번호');
        DBMS_OUTPUT.PUT_LINE(orderNew.OR_ST||'배송상태');
    END;
/

//즉 java로 치면 포함 클래스다
레코드명 하나로 여러 레코드의 변수를 가져와서 사용할수가 있다
```

## 자료형이 같은 여러 데이터를 저장하는 컬렉션
> 특정 자료형이 데이터를 여러개를 저장하는 복합 자료형이다.
```
레코드 : 여러 종류의 데이터를 하나로 묶어서 하나의 행처럼 사용
컬렉션 : 열 또는 테이블과 같은 형태로 사용

+ 연관 배열
+ 중첩 테이블
+ VARRAY
```
### `연관배열`
> 연관 배열은 키(KEY),값(VALUE)으로 구성된 컬렉션이다.   
> 중복되지 않는 키를 통해 값을 불러오는 방식을 사용.
```
TYPE 연관 배열 이름 IS TABLE OF 자료형[NOT NULL]
INDEX BY 인덱스형;

자료형[NOT NULL]
- 단일 자료형(VARCHAR2등)을 지정가능
- 참조 자료형(%TYPE,%ROWTYPE)도 지정가능
+ NOT NULL 옵션을 사용가능, 생략가능

인덱스형
- 키로 사용할 인덱스의 자료형을 지정
+ BINARY_INTEGER , PLS_INTEGER 같은 정수 혹은
+ VARCHAR2같은 문자 자료형도 가능하다.

특수변수 자료형으로 사용된다.
```
`PLS_INTEGER란?`
```
- PLS_INTEGER은 PL/SQL에서 사용가능한 데이터 타입. 
    속도가 BINARY_INTEGER, NUMBER와 비교하여 빠르다.  
- BINARY_INTEGER와 NUMBER 타입이 "라이브러리를 이용" 하여 
    수치 연산을 하는 반면, 
+ PLS_INTEGER는 실제 기계적인 연산(Machine arithmetic)을 
    수행하기 때문에 빠르다. 
-2147483647과 2147483647 사이의 signed 정수
```

> 연관배열 사용해보기
```
DECLARE
    TYPE ITAB_EX IS TABLE OF VARCHAR2(20)
    INDEX BY PLS_INTEGER;
    
    text_arr ITAB_EX;
    NUM NUMBER(2);
BEGIN
    text_arr(1) := '1st data';
    text_arr(2) := '2nd data';
    text_arr(3) := '3rd data';
    text_arr(4) := '4th data';
    text_arr(5) := '5th data';
    text_arr(6) := '6th data';
    NUM := 1;
    WHILE NUM<7 LOOP
        DBMS_OUTPUT.PUT_LINE('test_arr('||NUM||') : '||text_arr(NUM));
        NUM := NUM+1;
    END LOOP;
END;
/
test_arr(1) : 1st data
test_arr(2) : 2nd data
test_arr(3) : 3rd data
test_arr(4) : 4th data
test_arr(5) : 5th data
test_arr(6) : 6th data

출력이된다.
```

> 레코드를 활용한 연관 배열   
   
```
DECLARE
    TYPE REC IS RECORD(
        no employees.employee_id%TYPE,
        first_name employees.first_name%TYPE
    );
    
    TYPE ITAB IS TABLE OF REC
        INDEX BY PLS_INTEGER;
    
    emp_arr ITAB;
    idx PLS_INTEGER := 0;

BEGIN
    FOR i IN (SELECT EMPLOYEE_ID,FIRST_NAME FROM EMPLOYEES) LOOP
        idx := idx+1;
        emp_arr(idx).no := i.EMPLOYEE_ID;
        emp_arr(idx).first_name := i.FIRST_NAME;

    DBMS_OUTPUT.PUT_LINE(
        emp_arr(idx).no|| ':' || emp_arr(idx).first_name);
        
     END LOOP;
END;
/

DECLARE
    TYPE REC IS RECORD(
        no employees.employee_id%TYPE,
        first_name employees.first_name%TYPE
    );
    
    TYPE ITAB IS TABLE OF REC
        INDEX BY PLS_INTEGER;
    
    emp_arr ITAB;
    idx PLS_INTEGER := 0;

BEGIN
    FOR i IN (SELECT EMPLOYEE_ID,FIRST_NAME FROM EMPLOYEES) LOOP
        idx := idx+1;
        emp_arr(idx).no := i.EMPLOYEE_ID;
        emp_arr(idx).first_name := i.FIRST_NAME;
     END LOOP;
    FOR i IN 1..emp_arr.COUNT LOOP
        IF MOD(emp_arr(i).no,4)=0 THEN
            DBMS_OUTPUT.PUT_LINE(emp_arr(i).first_name);
        END IF;
    END LOOP;
END;
/

무한 배열이고
배열안에는 레코드 자료형이 있어서

연관 배열(NUM) = {레코드 자료형1,2,3...,N};
java 배열에서 처럼
arr[1] = new int[] {"a","b"} 느낌처럼 사용하면된다.

```
> %ROWTYPE도 적용해보기
```
DECLARE
//여기서 주의할점 OF 뒤에는 자료형이 와야한다.
//변수가 올수 없다는것
     TYPE ITAB IS TABLE OF EMPLOYEES%ROWTYPE
    INDEX BY PLS_INTEGER;
     emp_arr ITAB;
     inum INTEGER := 0;
BEGIN
    FOR i IN (SELECT EMPLOYEE_ID,FIRST_NAME,HIRE_DATE FROM EMPLOYEES) LOOP
        inum := inum+1;
        emp_arr(inum).EMPLOYEE_ID := i.EMPLOYEE_ID;
        emp_arr(inum).FIRST_NAME := i.FIRST_NAME;
        emp_arr(inum).HIRE_DATE := i.HIRE_DATE;
        
        DBMS_OUTPUT.PUT_LINE(
            emp_arr(inum).EMPLOYEE_ID||','||
            emp_arr(inum).FIRST_NAME||','||
            emp_arr(inum).HIRE_DATE
        );
    END LOOP;
END;
/
```

### `컬렉션 메서드`
```
  매서드            설명
  -----             ---
EXISTS(n)   컬렉션에서 n인덱스의 데이터 존재 여부를 true/false로 반환.
COUNT       컬렉션에 포함되어 있는 요소 개수를 반환.
LIMIT       현재 컬렉션의 최대 크기를 반환합니다.최대 크기가없으면 NULL반환
FIRST       컬렉션의 첫 번째 인덱스를 반환합니다.
LAST        켈렉션의 마지막 인덱스 번호를 반환합니다.
PRIOR(n)    컬렉션에서 n인덱스 바로 앞 인덱스 값을 반환
            없을 경우 NULL을 반환한다.
NEXT(n)     컬렉션에서 n인덱스 바로 다음 인덱스 값을 반환
            없을 경우 NULL을 반환한다.
DELETE      컬렉션에 저장된 요소를 지우는데 사용
            +DELETE : 모든 요소 제거
            +DELETE(n) : n인덱스의 컬렉션 요소를 삭제
            +DELETE(n,m) : n인덱스부터 m인덱스까지 삭제
EXTEND      컬렉션의 크기를 증가시킨다,중첩테이블과 VARRAY에서 사용
TRIM      컬렉션의 크기를 감소시킨다,중첩테이블과 VARRAY에서 사용
```
` 주의사항 `
> BOOLEAN 타입은 OUTPUT.PUT_LINE으로 출력이 안된다.   
 
```
SQL에는 없는 타입이기 때문에 출력이 안되므로
따로 변수에 결과물을 변수에 담아서 출력해야한다.
DECLARE
    CHECK2 BOOLEAN := false;
    TMP VARCHAR2(10);
BEGIN
    IF CHECK2 THEN
        TMP:= 'true';
    ELSE
        TMP:= 'false';
    END IF;
    DBMS_OUTPUT.PUT_LINE(TMP);
END;
 /
 ```
 