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
