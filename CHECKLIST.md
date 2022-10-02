# 놓쳤던 부분 다시 짚어보기

### 추가 수당이 없는 사원의 추가 수당은 N/A로 변경
```
//틀린곳
SELECT
    EMPNO,
    ENAME,
    HIREDATE,
    TO_CHAR(NEXT_DAY(ADD_MONTHS(HIREDATE,3),'월요일'),'YYYY-MM-DD') AS R_JOB,
    //
    NVL(COMM,'N/A') AS COMM
    // 여기서 NVL 인자 두개는 타입이 같아야한다.
    // COMM의 타입은 NUMBER
    // 변환되는 타입은 CHAR
    // 타입이 불일치하므로
    // 실수를 했다.
    >> 변경후
    NVL(TO_CHAR(COMM),'N/A') AS COMM
FROM EMP;
```

### 문자열 함수는 문자열 데이터
```
SELECT SUBSTR('문자열데이터',OFFSET,LENGTH)

```

### SELECT절의 * 사용
```
SELECT절에서 출력할 열을 * 로 표시한다면,
어떤 열이 어떤 순서로 출력될지 명시적으로 알수 없을뿐만아니라
특정 열이 생기거나 수정되었을 경우에는 그 변화를 찾기 어렵다
급하게 조회하려고 사용할때에는 유용하지만

프로그램내부에서는 명시적으로 열거하는게 좋다

SELECT E.EMPNO,E.NAME,E.JOB,E.MGR
       D.DNAME,D.LOC
    FROM EMP E,DEPT D
WHERE E.DEPTNO = D.DEPTNO
ORDER BY DEMPNO;
```

### CASE문에서 비교대상을 넣어줬을때
```
SELECT CUSTOMER_ID,NAME,CREDIT_LIMIT,
    CASE CREDIT_LIMIT
        WHEN A THEN 'BRONZE'
        WHEN B THEN 'SILVER'
        WHEN C THEN 'GOLD'
        ELSE 'DIA'
    END
FROM CUSTOMERS;

A에는 부등호가 들어올수가 없다.
처음에 이해한건 A가 TRUE 일때 THEN 문장이 실행되는걸로 이해했는데
반은 맞고 반은 틀리다.
왜냐하면
CASE 비교할 대상을 넣어줬을때
A,B,C는 자기 자신이 TRUE이면 이 아니라
비교대상과 비교했을때 TRUE가 되는 
조건식이 THEN 뒷문장으로 되기때문이다,

A,B,C에 조건식을 넣어줘서 분할하고 싶다면
SELECT CUSTOMER_ID,NAME,CREDIT_LIMIT,
    CASE 
        WHEN A<1500 THEN 'BRONZE'
        WHEN B<2000 THEN 'SILVER'
        WHEN C<3000> THEN 'GOLD'
        ELSE 'DIA'
    END
FROM CUSTOMERS;

추가로 값을 변경하는거기때문에
SELECT,
UPDATE,
DELETE,
SELECT-WHERE,
      -HAVING,
      -ORDDER BY
구절에서 사용이 가능하고

전체적인 값을 변경할때에도 사용이 가능하다

UPDATE
    CUSTOMERS
    SET
    CUSTOMER_LIMIT =
    CASE
        WHEN ROUND((LIST_PRICE-STANDARD_COST)*100/LIST_PRICE,2)<15
        THEN (STANDARD_COST)*1.15
    END --마진이 15이하인 물건을 마진을 15%로 올리리는 문낭
WHERE
    ROUND((LIST_PRICE-STANDARD_COST)*100/LIST_PRICE,2)<15;

WHEN 조건에 두개 이상의 비교대상이 있으면
비교대상 인자를 제거하고
WHEN 구절에 WHERE 구절에 사용하듯이 사용해야한다.

SELECT
    CASE 
    WHEN EXTRACT(MONTH FROM HIRE_DATE)IN(2,4,6) THEN '짝수'
    END
FROM EMPLOYEES;
```
> 애매한 상태
+ SUBQUERY - 다중서브쿼리 (재복습 필요)
+ 상호 연관 서브쿼리 - 계속 불발남.   
+ MARGE - 두세번더 보기
+ INDEX

> 테이블과 같은 열 구조를 갖고 데이터는 복사하기 싫을때   
```
CREATE TABLE COPY_TMP
    AS SELECT *
        FROM EMP
        WHERE 1<>1;
테이블을 카피해서 가져오지만
옵션이 항상 FALSE이기 때문에 구조만 가져온다.
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
C##OT      SYS_C008344◆        C  CUSTOMERS
C##OT      SYS_C008345          C  CUSTOMERS
C##OT      SYS_C008346★        P  CUSTOMERS
C##OT      SYS_C008353          C  ORDERS
C##OT      SYS_C008354          C  ORDERS
C##OT      SYS_C008355          C  ORDERS
C##OT      SYS_C008356          C  ORDERS
C##OT      SYS_C008357          P  ORDERS
C##OT      FK_ORDERS_CUSTOMERS  R  ORDERS     C##OT      SYS_C008346★
C##OT      FK_ORDERS_EMPLOYEES  R  ORDERS     C##OT      SYS_C008334◆
```

> 사용자 생성시 등장하는 TABLESPACE 알아보기
```
DBMS_USER.md 참조
```

## EXCEPTION 이름없는 예외 처리시
> 예외 번호를 확인하고 추가하자.
```SQL
CREATE PROCEDURE EMP_TMP_INSERT
(
    ID EMP_TMP.EMPLOYEE_ID%TYPE,
    NAME2 EMP_TMP.EMPLOYEE_ID%TYPE
)
IS
    --DECLARE 대신
    PK_ERROR EXCEPTION;
    PRAGMA EXCEPTION_INIT(PK_ERROR,-1);
    /*
    ORA-00001: 무결성 제약 조건(C##OT.PK_EMP_ID)에 위배됩니다
    여기서 ORA-00001이 예외 번호인줄 알았는데
    TO_CHAR(SQLCODE) 예외 처리 함수로 코드 번호를 따로 받아서
    그걸 입력해야 한다.
    */
BEGIN
    INSERT INTO EMP_TMP VALUES(ID,NAME2);
    DBMS_OUTPUT.PUT_LINE('값 입력 완료');
EXCEPTION
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('에러발생');
--        DBMS_OUTPUT.PUT_LINE('SQLCORE : '||TO_CHAR(SQLCODE));
--        DBMS_OUTPUT.PUT_LINE('SQLERRM : '||TO_CHAR(SQLERRM));
      WHEN PK_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('에러발생');
END;
/
```
## 테이블 생성시 IN