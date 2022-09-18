/*
    SELECT 구절
    [SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY]
    >>>>>>> 이 순서대로 작성을 해야하며, 반드시 암기.
    
    FROM 절
    데이터를 가공처리할건데 데이터 구조에 대해서 연산하는 공간.
    테이블이 올수도있고 레코드 합산이 올수도 잇다.
    격자형 데이터를 마련하는것
    FROM [조회할 2차원 형식의 테이블]
    
    WHERE 절
    FROM 절에서 필터링
    WHERE [조회할 행을 선별하기 위한 조건식];
    
    GROUP BY
    거기서 필요한 거만 집계함수
    
    HAVING
    집계된 결과에서 필터링 하고싶을때
    
    ORDER BY
    다 완성된 데이터를 마지막에 정렬하는 방법
        ASC - 오름차순 /
        DESC - 내림차순 \
    이름을 기준으로 역순으로 정렬해서 조회하시오.
        SELECT * FROM EMPLOYEES ORDER BY FIRST_NAME DESC;
    기본 정렬은 ASC = DEFAULT;
    회원 중에서 '박'씨 성을 가진 회원을 조회하시오(나이 오름차순으로 정렬)
    SELECT * FROM employees WHERE FIRST_NAME LIKE '박%' ORDER BY AGE;
    여기 ->>>>> 구절 순서를 바꾸면 안된다.
    
    IF - 정렬할때 기준값이 같으면 2차정렬은 어떻게 할것인가?

    SELECT * 
    FROM EMPLOYEES 
    WHERE PHONE LIKE '650%' 
    ORDER BY MANAGER_ID DESC,
             EMPLOYEE_ID DESC;
    , 뒤에 추가 정렬할 값을 넣어준다.

    이때 정렬마다 오름차순 내림차순을 다르게 할수있다.

    SELECT * 
    FROM EMPLOYEES 
    WHERE PHONE LIKE '650%' 
    ORDER BY MANAGER_ID DESC,
    EMPLOYEE_ID;

    **꼭 필요한 경우가 아니라면 사용하지 않는것이 좋다**
    여기저기 흩어져있는 자원을 가지런히 순서를 맞추는건
    많은 자원을 소모하게 되고 데이터의 양에 따라
    효율과 서비스 응답 시간이 느려지기 때문이다.

    
    집계 함수
    [SUM , MIN , MAX , COUNT , AVG]
    
    *COUNT
        SELECT COUNT(*) FROM EMPLOYEES; //107
        SELECT COUNT(MANAGER_ID) FROM EMPLOYEES;  //106 
        즉 COUNT 는 NULL값을 제외하고 개수를 센다.
        SELECT COUNT(NVL(MANAGER_ID,0)) FROM EMPLOYEES; // 107
        여기서 NULL 함수로 NULL을 0으로 변경하면 상관없이 다 세어진다.
        ++ 여기서 COUNT(*)을 넣으면 속도가 저하되므로 확실한 PK값이 잇느걸로 세는게 좋다.
        SELECT COUNT(ROWNUM) FROM EMPLOYEES; //이것도 가능하다.
    
    *SUM
        SELECT SUM(QUANTITY) FROM ORDER_ITEMS; // 총 수량 /59606개
    *AVG
        SELECT AVG(QUANTITY) FROM ORDER_ITEMS; // 평균 수량 / 89.6개
    
    전체 COLUMN의 합이 아니라 그룹으로 묶어서 집계하고 싶을땐
    SELECT COUNT(QUANTITY) FROM ORDER_ITEMS GROUP BY ITEM_ID;
    SELECT TABLE_NAME FROM USER_TABLES;
    
    //아이템별 ID카운트,수량 총합,평균을 출력
    //여기서 평균 수량이 높은순서대로 출력해봤다.
    SELECT 
    ITEM_ID,
    COUNT(QUANTITY) COUNT,
    TO_CHAR(AVG(QUANTITY),'999.9') AVG,
    TO_CHAR(SUM(QUANTITY),'9,999') SUM
    FROM ORDER_ITEMS 
    GROUP BY ITEM_ID
    ORDER BY AVG DESC;
    *주의 할점,GROUP BY된 COLUMN이 아닌건 SELECT 구절에 들어올수없다.
    *별칭으로도 사용이 가능하다.
    
    **중요
    SELECT 구절에서 실행되는 순서
    1. FROM절 실행 결정된 별칭이 모든곳에서 사용된다.
    2. CONNECT BY
    3. WHERE
    4. GROUP BY
    5. HAVING
    6. SELECT 에서 별칭을 만든건 위에 있는곳에서 사용을 할수가없다.
    7. ORDER BY

    *열과 연산식
    SELECT PRODUCT_ID , QUANTITY*UNIT_PRICE AS TOTAL 
    FROM ORDER_ITEMS;

    이렇게 COLUMN끼리도 연산이 가능하지만
    COLUMN값이 NULL인 경우 값이 존재하지 않기때문에
    항상 값은 NULL이 나온다.


    *별칭을 지정하는 방식
    [컬럼명] [별칭명] :연산및 가공후 한칸 띄고 별칭 지정
    [컬럼명] "[별칭명]"" :연산및 가공후 한칸 띄고 큰따음표로 지정
                         별칭명이 예약어일때 " "를 붙인다.
    [컬럼명] AS [별칭명] :연산및 가공후 한칸 띄고 AS 별칭 지정
    [컬럼명] AS "[별칭명]":연산및 가공후 한칸 띄고 별칭 지정

    ex) SEL*12 AS YEARS;
    ex) SEL*12 "YEARS";

    + 출력되기를 원하는 열의 이름을 직접 지정할때 주로 사용
    + 긴 글씨의 불편함도 있고
    + 데이터 노출(진행과정) 문제 때문에 별칭을 사용할수도 있다. 


    *실무에서는 주로 3번째를 사용한다.
    --AS를 선호하는 이유
    1.조회해야하는 열이 수십,수백개 일경우
      어떤단어가 별칭인지 알아보기 편하기 때문
    
    2. 큰따옴표를 사용하지 않으려는 프로그래머 습관때문
    프로그래밍에서 큰따옴표는 문자열의 시작과 끝을 알림

    자바에서 SQL을 가져올때
    String sql = "SELECT NAME,SAL,SAL*12 AS ANNSAL FROM EMP";

    4번째 방법일 경우
    sql = "SELECT NAME,SAL,SAL*12 AS "ANNSAL" FROM EMP";

    이렇게 읟하지 않은 오류나 예외 상황이 발생할수 있기때문에
    추가작업을 해야하는 번거로움이 생긴다.


*/ 
