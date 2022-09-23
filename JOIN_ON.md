## 여러 테이블을 하나의 테이블처럼 사용
# JOIN ON
> 여러 테이블의 데이터를 조합하여 출력해야하는 경우에 사용한다.   

`이 장에서 꼭 익혀야 할 것` 
```
-조인의 뜻과.WHERE절 조건식의 사용
-등가 조인,자체 조인,외부 조인
```

## 조인
> ### 집합 연산자와 조인의 차이점
```
집합연산자 (UNION)    |  로 합쳐진다
-열갯수와 열의 타입이 일치해야한다.
-아래로 합쳐지는 테이블은 컬럼명이 안보인다.

JOIN                 ㅡ 로 합쳐진다.
```

<br> 
 
> ### 여러 테이블을 사용 할 때의 FROM절
```
SELECT
    FROM 테이블1,테이블2,테이블3,....테이블N

SELECT 구문과 마찬가지로
여러개의 테이블을 가져올수있는데 문제가 생긴다.
```
> CROSS 조인 또는 교차 조인이라 한다.
```
문제점
FROM 테이블 1, 테이블 2

합쳐지는 행의 개수는 테이블1 행 * 테이블2 행 이된다.

이때 합쳐지는 행의 공통점이나 같은 값을 사용하는걸 찾아서
필터링을 해줘야하는데 이때 WHERE절이 사용이 가능하다

SELECT *
FROM CUSTOMERS,ORDERS
WHERE customers.customer_id = orders.customer_id;
```
`두 테이블의 컬럼명(개체)를 구분하는 방법`
### 1. 테이블명.열 이름   
    단 테이블 명이 같을시 구분이 어려움
### 2. 테이블' '별칭
    테이블에서 별칭을 지정할 때는 한칸 띄어쓰고 별칭을 쓴다
    FROM TABLE A,TABLE2 B,TABLE3 C...

<br>

## 조인 종류

### `등가조인`   

> 두 테이블을 연결후 특정 열의 값이 같을때 사용한다.

```
각 조인되는 두 데이블에 겹치는 이름이 있다면 
누구의 테이블 정보인지 알수가 없어 에러발생한다.
또한 테이블에 겹치는 컬럼명이 있어도
명시해주는것이 좋다 
```
```
예제)

SELECE A.employee_id
       A.first,    
       B.manager_Id, 
       B.first_name
FROM EMPLOYEES A,EMPLOYEES B
WHERE A.manager_id=B.manager_id

//추가로 조건을 더 붙이고 싶다면
WHERE A.manager_id=B.manager_id
AND   SAL>=3000;
 :        :
 ```
> 두 테이블을 연결할때는 연결해주는 열이 필요.   
A,B를 연결한다면 연결해주는 열 1개 이상
A,B,C를 연결해준다면 A,B에 연결된 상태에서   
C를 연결해줄 열 하나가 필요하다.    

### `비등가조인`
> 등가 조인 방식외의 방식을 말한다.   

```
GRADE LOSAL HISAL
    1   700  1200
    2  1201  1400
    3  1401  2000
    4  2001  3000
    5  3001  4000
    -  ----  ----
이 TABLE에 GRADE를 직원 테이블에 붙이고 싶은데
급여가 저 사이에 들어있을 경우에는 등가조인을 할수가 없다.

이때에는 범위를 지정해서 연결되는 열을 만들어준다

SELECT *
    FROM EMPLOYEES E,SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;

SELECT C.NAME , C.CREDIT_LIMIT,
       L.GRADE
FROM CUSTOMERS C,LIMITGRADE L
WHERE C.CREDIT_LIMIT BETWEEN L.LOWLIMIT AND L.HILIMIT;
```
   

### `자체조인`
```
SELECT 로는 같은 테이블에서 연결점을 만들어서 이어서 붙여줄수가 없다.

이때 자체조인으로 하나의 테이블을 더 불러와서
등가조인처럼 사용하면된다.

SELECT *
    FROM EMPLOYEES A , EMPLOYEES B
WHERE A.MANANGER_ID = B.EMPLOYEE_ID;
```
### `외부조인`   
> 연결된 열이 없으면 NULL값이나 연결된것이 없으면 NULL로 처리가 된다,   
 우리는 그런데 전부를 보고싶다면 어떻게 해야할까?

```
외부 조인을 사용하지 않는 등가,자체 조인은 연결된 행만,
외부 조인의 핵심은 추가하는 배열과 둘 중에서

SELECT *
    FROM EMPLOYEES A, EMPLOYEES B
WHERE A.MANAGER_ID = B.EMPLYOISSE;

SELECT * 
FROM EMPLOYEES A ,employees B
WHERE A.EMPLOYEE_ID = B.MANAGER_Id(+);

간단하게 (+)를 붙인족에 반대편에 NULL값이 출력

A.EMPLOYEE_ID가 연결된게 NULL, MANAGER_Id가 없다면
우리가 필요한 전체 직원의 정보를 알수없다
따라서 WHERE NULL값을 출력해도 된다.

LEFT_TABLE = RIGHT_TABLE(+)

자체시 할인을 받은경우에는 더 할인이 가능하다
```

## SQL-표준
```
ISO/ANSI 에서 SQL문이 데이터베이스 표준 언어로 지정(SQL-82)된 후
SQL-92 > SQL-99 표준문법 등장,
오라클은 9i버전부터 SQL-99버전을 지원
```

### `NATURAL JOIN`
> 등가 조인을 대신해서 사용할수 있는 조인방식   
조인 대상이 되는 두 테이블에 이름과 자료형이 같은 열을 찾은후   
그 열을 기준으로 등가 조인을 하는 방식   

```
SELECT O.ORDER_ID,
        <<<customer_id,>>>
        C.NAME,O.STATUS,
        O.SALESMAN_ID
FROM ORDERS O NATURAL JOIN CUSTOMERS C;

조인에 사용된 열은 식별자를 사용할수가 없다.
C.customer_id라고 붙일경우
"NATURAL 조인에 사용된 열은 식별자를 가질 수 없음" 에러 발생

대신 안쓰는건 괜찬다.
```
두 테이블에서 <U>`이름과 자료형이 같은 열`</U>이 있어야한다.

### `JOIN ~USING`   
> 등가 조인을 대신하는 조인 방식   
> USING 키워드에 조인 기준으로 사용할 열을 명시하여 사용   
```
FROM TABLE1 JOIN TABLE2 USING(조인에 사용한 기준열)
```
```
SELECT O.ORDER_ID,
        --CUSTOMER_ID,
        C.NAME,O.STATUS,
        O.SALESMAN_ID
FROM ORDERS O 
    JOIN CUSTOMERS C 
    USING(customer_id)
WHERE SALESMAN_ID<60;

방식은 비슷하고 NATURAL과는 다르게 명시적이다.
```

### `JOIN ~ ON`   
> 조인의 기준을 ON 뒤에 명시한다.   
그밖에 출력행을 걸러내려면 WHERE 조건식을 따로 사용한다.
```
FROM TABLE1 JOIN TABLE2 ON (연결될 행 조건식)
```
```
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.MANAGER_ID,
    M.FIRST_NAME AS MANAGER_NAME,
    E.HIRE_DATE
    FROM EMPLOYEES E
JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID
WHERE E.HIRE_DATE>(SELECT ADD_MONTHS(MAX(SYSDATE),-3) FROM EMPLOYEES);

금일 기준으로 3개월이 안되는 직원을 찾는다면
위 방식을 구할수가 있다.
```

### `OUTER JOIN`
> 기존 방식과 SQL-99방식 조인의 차이점
```
왼쪽 외부 조인       기존   WHERE TABLE1.COL1=TABLE2.COL2(+)
(LEFT OUTER JOIN) SQL-99   FROM TABLE1 LEFT JOIN TABLE2 ON (조인조건식)

ㄴ TABLE1의 데이터는 모두 출력이 되는것,TABLE2는 연결된 열만 출력

-   -   -
오른쪽 외부 조인       기존   WHERE TABLE1.COL1(+)=TABLE2.COL2
(RIGHT OUTER JOIN)  SQL-99   FROM TABLE1 RIGHT JOIN TABLE2 ON (조인조건식)

ㄴ TABLE2의 데이터는 모두 출력이 되는것,TALBE2도 마찬가지로 연결된 열만 출력

-   -   -
전체 외부 조인        기존   기존 문법이 없음(UNION 사용)
(FULL OUTER JOIN)  SQL-99   FROM TABLE1 FULL JOIN TABLE2 ON (조인조건식)
```

### `3개이상의 테이블을 조인할때`
> 기존 방식 (WHERE 절에 조건식을 넣을때)
```
FROM TABLE1,TABLE2,TABLE3
WHERE TABLE1.COL = TABLE2.COL
AND TABLE2.COL = TABLE3.COL;
```
> SQL-99 방식(FROM에 조건을때)
```
FROM TABLE1 JOIN TABLE2 ON(조건식)
JOIN TABLE3 ON(조건식)
```
```
SELECT
    ORD.ORDER_ID,ORD.ORDER_DATE,ORD.STATUS,
    CUS.CUSTOMER_ID,CUS.NAME,
    ITM.UNIT_PRICE
    FROM ORDERS ORD 
    RIGHT OUTER JOIN CUSTOMERS CUS   <<첫번째 JOIN>>
    ON ORD.CUSTOMER_ID=CUS.CUSTOMER_ID
    LEFT OUTER JOIN ORDER_ITEMS ITM <<두번째 JOIN>>
    ON ORD.ORDER_ID = ITM.ORDER_ID
ORDER BY ORDER_ID;

 
FROM JOIN<1> JOIN<2>

기준을 어디로 잡는지에 따라 LEFT RIGHT가 나뉜다.
여기서 기준을 JOIN<1>으로 잡았기 때문에
JOIN<1>을 기준으로 왼쪽 LEFT = FROM     RIGHT = JOIN<1>
JOIN<1>을 기준으로 왼쪽 LEFT = JOIN<1>  RIGHT = JOIN<2>
```