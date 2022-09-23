# 서브쿼리(SUBQUERY)
```
SQL문을 실행하는데 필요한 데이터를 추가로 조회하기 위해
SQL문 내부에서 사용하는 SELECT문을 의미한다.
```
> 서브쿼리의 결과 값을사용하여 기능을 수행하는 영역은 메인쿼리라고 한다   
```
서브쿼리는
INSERT문 , UPDATE문 , DELETE 문 , CREATE문등 다양한 SQL에서 사용한다.
```

> 두개의 SELECT문을 하나의 SELECT문으로
```
사원 Rose 보다 나중에 입사한 사람들을 찾아보기.

1.Rose의 입사날짜 찾기
SELECT HIRE_DATE 
    FROM EMPLOYEES 
WHERE FIRST_NAME='Rose';
--16/06/07

2.직원 테이블에서 16/06/07보다 나중에 입사한 사람 추출
SELECT
    FIRST_NAME,
    HIRE_DATE
    FROM EMPLOYEES
WHERE HIRE_DATE>'16/06/07';
```
> 위 두 SELECT문을 하나로 합치면 된다.   
> JAVA로 비유하면
```
Random ran = new Random();
int ranNum = ran.nextInt(10);
           v
int ranNum = new Random().nextInt(10);
```
```
SELECT
    FIRST_NAME,
    HIRE_DATE
    FROM EMPLOYEES
WHERE HIRE_DATE>(SELECT HIRE_DATE 
                    FROM EMPLOYEES 
                WHERE FIRST_NAME='Rose')
```
> 작성 순서
1. WHERE절의 조건식에 들어간 기준 날짜(Rose)가 서브쿼리
2. 기준 날짜와 비교하여 기준 날짜보다 늦은 날짜에   
 입사한 사원을 조회하는게 메인쿼리로 작성된다.   

### `서브쿼리 특징`
```
1. 서브쿼리는 연사자와 같은 비교 또는 조회 대상의 오른쪽에 놓이며
    괄호()로 묶어서 사용한다.

2. 특수한 몇몇 경우를 제외한 대부분의 
    서브쿼리에는 ORDER BY절을 사용할수가 없다.

3. 서브쿼리의 SELECT절에 명시한 "열"은 
    메인쿼리의 "비교 대상과 같은 자료형"과"같은 개수"로 지정해야한다.
    즉 메인쿼리의 비교 대상 데이터가 하나라면
        서브쿼리의 SELECT절 역시 같은 자료형인 열을 하나 지정해야한다.
        (비교를 하려면 데이터 타입과 개수가 같아야 한다는 말)

4. 서브쿼리에 있는 SELECT문의 결과 행 수는 함께 사용하는 
    메인쿼리의 연산자 종류와 호환이 가능해야 한다.
    예) 메인쿼리에 사용한 연산자가 
        단 하나의 데이터로만 연산이 가능한 연산자면
        서브쿼리의 결과 행 수는 반드시 하나여야 한다.
        (비교 개수가 같아야 한다는 말)
```

## 실행결과가 하나인 단일행 서브쿼리
# 단일행 서브쿼리(single-row subquery)
```
실행 결과가 단 하나의 행으로 나오는 서브쿼리를 뜻한다.
```
> 단일행 연산자
```
 >    >=    =    <=    <    <>    !=    ^=
```
> 주의사항
```
Rose의 이름이 여러명 일경우에 문제가 발생한다.
    결과로 여러행을 반환할 때는 다중행 서브쿼리를 사용한다.

해당 테이블의 PK로 지정해서 사용하면 된다.
```

### `단일행 서브쿼리와 날짜형 데이트`
```
SELECT *
FROM EMPLOYEES
WHERE HIRE_DATE>(
        SELECT HIRE_DATE
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID=16
    );
```

### `단일행 서브쿼리와 함수`
> 서브쿼리에서 특정 함수 결과 행이 하나일때   
단일행 서브쿼리로 사용 가능하다.
```
예) 물품중에서 평균 가격보다 높은 물건을 조회하시오
SELECT *
FROM PRODUCTS
WHERE LIST_PRICE > (
    SELECT AVG(LIST_PRICE)
    FROM PRODUCTS
    )

//JOIN과 같이도 사용이 가능하다
SELECT
    A.EMPLOYEE_ID,
    A.FIRST_NAME,
    A.HIRE_DATE,
    A.MANAGER_ID,
    B.FIRST_NAME AS MANAGER_NAME
    FROM EMPLOYEES A
    JOIN EMPLOYEES B
    ON A.MANAGER_ID = B.EMPLOYEE_ID
    WHERE A.HIRE_DATE>(
            SELECT HIRE_DATE
            FROM EMPLOYEES
            WHERE EMPLOYEE_ID=6
            );
```
## 실행 결과가 여러 개인 다중행 서브쿼리
# 다중행 서브쿼리 (multiple-row subquery)
```
서브쿼리 결과가 여러 개이므로 단일행 연산자는 사용할수 없고,
다중행 연산자를 사용해야 메인쿼리와 비교할수 있다.

다중행연산자               설명
    --                    ----
    IN              메인쿼리의 데이터가 서브쿼리의 결과 중 
                    하나라도 일치한 데이터가 있다면 true
                    -
  ANY,SOME          메인쿼리의 조건식을 만족하는 
                    서브쿼리의 결과가 하나 이상이면 true
                    -
    ALL             메인쿼리의 조건식을 
                    서브쿼리의 결과 모두 만족하면 true
                    -
   EXISTS           서브쿼리의 결과가 존재하면
                    (행이 1개이상일때) true
```

### `IN연산자`
> WHERE (해당 열) IN ( 조건1,조건2,...조건N )
```
물건의 카테고리별 최고 금액과 물품의 정보를 출력하시오
SELECT 
    CATEGORY_ID,C.CATEGORY_NAME,
    P.PRODUCT_NAME,P.LIST_PRICE
    FROM PRODUCTS P 
    JOIN product_categories C
    USING (CATEGORY_ID)
    WHERE LIST_PRICE IN (
        SELECT MAX(LIST_PRICE)
        FROM PRODUCTS
        GROUP BY category_id
    );

IN 같은 경우에는 값이 같아야된다.
```

### `ANY,SOME연산자`
```
서브쿼리가 반환한 여러 결과중 
        메인 쿼리와 조건식을 사용한 결과가
하나라도 true라면 
        메인쿼리 조건식을 true로 반환해주는 연산자
```
```
ANY,SOME 뒤에 나오는 서브쿼리의 결과가
서브쿼리1 값 : { A }
서브쿼리2 값 : { A , B , C , D }
라고 한다면

서브쿼리 값이 하나일때는 단일행 서브쿼리와 같다

하지만 서브쿼리2 경우에는 
         A,B,C,D결과값중에서 하나라도 연산 결과가 true라면 ture로 반환된다
         A || B || C || D 와 비슷하다.
```
```
예)
SELECT 
    CATEGORY_ID,C.CATEGORY_NAME,
    P.PRODUCT_NAME,P.LIST_PRICE
    FROM PRODUCTS P 
    JOIN product_categories C
    USING (CATEGORY_ID)
    WHERE LIST_PRICE > ANY (
        SELECT LIST_PRICE
        FROM PRODUCTS
        WHERE category_id = 1
    );

설명 )
서브 쿼리의 결과값은
물품중에 카테고리 값이 1인 물품이 결과중에서
하나라도 크다면 true이다.

서브쿼리 결과의 최소값보다 크면 된다는 말이된다.
SELECT 
    CATEGORY_ID,C.CATEGORY_NAME,
    P.PRODUCT_NAME,P.LIST_PRICE
    FROM PRODUCTS P 
    JOIN product_categories C
    USING (CATEGORY_ID)
    WHERE LIST_PRICE > (
        SELECT MIN(LIST_PRICE)
        FROM PRODUCTS
        WHERE category_id = 1
    );
```

### `ALL 연산자`
```
ALL 연산자는 서브쿼리의 모든 결과가 조건식에 다 맞아야한다
    서브쿼리 행의 값이 A && B && C && D 일 경우에 true
```
```
ANY와는 반대의 결과이다.

WHERE COLUMN < ANY (서브쿼리 다중행) 이면
WHERE COLUMN < ( MAX(서브쿼리) ) 뜻이고

ALL은

WHERE COLUMN < ALL (서브쿼리 다중행) 이면
WHERE COLUMN < ALL ( MIN(서브쿼리) ) 이다.
```

### `EXISTS 연산자`  

```
서브쿼리의 결과 값이 하나 이상 존재하면 조건식이 모두 true
                    존재하지 않으면 모두 false
```
```
특정 서브쿼리 결과 값이 존재 유무를 통해 
메인쿼리의 데이터 노출 여부를 결정해야 할때 간혹 사용한다
```
```
SELECT *
FROM EMPLOYEES
WHERE EXISTS (
    SELECT FIRST_NAME
    FROM EMPLOYEES
    WHERE FIRST_NAME = 'NIA'
    );
서브쿼리에 NIA가 없으므로
전부 false이 된다.
```

## 비교할 열이 여러 개인 다중열 서브쿼리
# 다중열 서브쿼리(multiple-column subquery)
> 복수열 서브쿼리라고도 한다.
```
서브쿼리의 SELECT절에 비교할 데이터를 여러개 지정하는 방식
SELECT *
FROM PRODUCTS
WHERE (CATEGORY_ID,LIST_PRICE) 
        IN (SELECT CATEGORY_ID,MAX(LIST_PRICE)
            FROM PRODUCTS
            GROUP BY CATEGORY_ID)

```

# FROM절에 사용하는 서브쿼리와 WITH절
> FROM절에 사용하는 서브쿼리는 인라인 뷰(inline view)라 한다.   

```
인라인 뷰는 특정 테이블 전체 데이터가 아닌
        SELECT문을 통해 일부 데이터를 먼저 추출해 온후
        별칭을 주어 사용한다.
```
```
--카테고리 1번을 구매한 유저목록을 알고싶다.

SELECT CT.NAME,C1NAME.PRODUCT_NAME
FROM (SELECT I1.*,C1.PRODUCT_NAME,C1.CATEGORY_ID
            FROM (SELECT * FROM PRODUCTS WHERE category_id=1) C1,
                 (SELECT * FROM ORDER_ITEMS) I1
      WHERE C1.PRODUCT_ID = I1.PRODUCT_ID) C1NAME,
     (SELECT * FROM ORDERS ) O1,
     (SELECT * FROM CUSTOMERS ) CT
WHERE O1.ORDER_ID = C1NAME.ORDER_ID 
AND CT.CUSTOMER_ID=O1.CUSTOMER_ID;

별칭을 여러번 쓰니까 식이 지저분해 지고 알수가 없다
이때 WITH절을 사용하기도 한다.
```
> WITH   
```
WITH
[별칭1] AS (SELECT 문1),
[별칭2] AS (SELECT 문2),
[별칭3] AS (SELECT 문3)
SELECT
    FORM 별칭1,별칭2,별칭3
.....
```
> 직접 만들어본 예제
```
WITH
C1 AS (SELECT * FROM PRODUCTS WHERE category_id=1),
I1 AS (SELECT * FROM ORDER_ITEMS),
C1NAME AS (SELECT I1.*,C1.PRODUCT_NAME,C1.CATEGORY_ID
            FROM C1, I1
      WHERE C1.PRODUCT_ID = I1.PRODUCT_ID),
O1 AS (SELECT * FROM ORDERS ),
CT AS (SELECT * FROM CUSTOMERS )
SELECT CT.NAME,C1NAME.PRODUCT_NAME
FROM O1,CT,C1NAME
WHERE O1.ORDER_ID = C1NAME.ORDER_ID 
AND CT.CUSTOMER_ID=O1.CUSTOMER_ID;
```

## `상호 연관 서브쿼리 `
> 재귀함수와 비슷한 느낌
```
메인쿼리에 사용한 데이터를 서브쿼리에서 사용하고
서브쿼리의 결과값을 다시 메인쿼리로 돌려주는 방식
```
```
SELECT *
 FROM EMP E1
WHERE SAL > (SELECT MIN(SAL)
                FROM EMP E2
                WHERE E2.DEPTNO=E1.DEPTNO)
ORDER BY DEPTNO,SAL;
```
## SELECT절에 사용하는 서브쿼리
# 스칼라 서브쿼리(scalar subquery)
```
SELECT절에 하나의 열 영역으로 결과를 출력할수도 있다.
```
### `반드시 하나의 결과만 반환하도록 한다`
<br>  

> 예시
```
SELECT 
    (SELECT GRADE 
        FROM LIMITGRADE 
     WHERE C.CREDIT_LIMIT 
     BETWEEN LOWLIMIT 
     AND HILIMIT) AS GRADE,
    C.CUSTOMER_ID,C.NAME,C.CREDIT_LIMIT
FROM CUSTOMERS C
ORDER BY GRADE;

이게 가능한 이유는 진행순서가

FROM 이 제일 먼저 실행되고
SELECT가 뒤에 실행되기 때문이다.
```

