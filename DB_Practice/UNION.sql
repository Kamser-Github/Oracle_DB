/*
    # UNION
    -- 집합 연산자

    * * *
    주의 사항!!

    1.합치는 두 SELECT구절의 열의 갯수가 같아야하고!
    2.합치는 두 SELECT구절의 열의 자료형이 같아야한다.

    SELECT 
    EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,MANAGER_ID
    FROM EMPLOYEES
    UNION
    SELECT 
    CUSTOMER_ID,NAME,ADDRESS,WEBSITE,CREDIT_LIMIT
    FROM CUSTOMERS;

    자료형,열의 갯수만 맞으면 된다.
    키 유무,데이터의 크기는 상관이 없다.
    COLUMN명은 UNION 집합연산자 전위 SELECT문을 따라간다.


    -- JOIN은 COLUMN을 합치는것.
        주인공을 찾아서 합치는것.
        
    -- UNION은 RECORD를 합치는것.
        양쪽의 컬럼의 속성과 길이만 맞추면 그냥 합치는것,
    
    쓰는이유 ? 게시판이 3종류라면
        통합검색을 하고 싶을때.
        1.하나의 게시판처럼 사용하고 싶을때
        2.결과물을 하나로 보고싶을때
        
    SELECT employee_id ,first_name FROM employees --107
    UNION --426개
    SELECT customer_id ,name       FROM customers; --319
    
    UNION 두개를 합쳤을때 데이터가 같을때에는 합쳐진다
        --합집합 단 중복은 제거.
        SELECT employee_id ,first_name FROM employees --107
        UNION --107개
        SELECT employee_id ,first_name FROM employees; --107
    
    UNION ALL 두개를 뒤돌아보지도 않고 합친다.
        --합집합 단 중복도 표기.
        SELECT employee_id ,first_name FROM employees --107
        UNION ALL --214개
        SELECT employee_id ,first_name FROM employees; --107
        
    MINUS : 뒤에있는것이랑 공통된것을 빼는것
        --차잡합
        A {1,2,3,4} MINUS B {2,3,5}  결과는 {1, 4}
    
    INTERSECT : 두개의 테이블에 공통된것만 남기는것
        --교집합
        A {1,2,3,4} INTERSECT B{2,3,5} 결과는 {2,3}
    
    하나의 테이블에서도 사용이 가능하다.(SET과 같은 개념)


    **** 연산자 순위 ****
    *,/
    +,-
    =,!=,<>,>,<등
    IS (NOT) NULL,(NOT) LIKE,(NOT)IN
    BETWEEN A AND B
    NOT
    AND
    OR

    
*/