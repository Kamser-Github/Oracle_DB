/*
    **** 굉장히 중요한 ****
    
    데이터를 모아놓고 중복을 없애는고 참조하는 방식으로 결함이 없게 한다.
    합쳐서 원래 모양으로 갖춰서 사용할 필요가 생겼다.
    
    **** 조인의 종류 ****
    [INNER JOIN , OUTER JOIN , SELF JOIN , CROSS JOIN(cartesian Product)]
    
    SQL문에서 합치는 방법
    둘의 참조관계가 키,참조하는 키가 관계가 있어야한다.
    테이블 두개가 있다면 둘의 차이점을 식별할수있어야한다.
    부모는 하나쪽에 있고 여러개를 만드는 자식
    
    참조하고 있는 데이터 수 만큼 복제를 한다.
    그 다음 격자 데이터를 합친다.
    
    반복되는건 제거하고 저장하고,IO 작업이 줄어든다.
    메모리를 복사하는건 읽는것보다 빠르다.
    
    --INNER JOIN ON 관계
    SELECT * FROM customers;--CUSTOMER_ID 부모
    SELECT table_name FROM user_tables;
    SELECT * FROM ORDERS;--CUSTOMER_ID 자식
    SELECT 
    CUSTOMERS.CUSTOMER_ID, CUSTOMERS.NAME,
    ORDERS.STATUS
    FROM CUSTOMERS 
    INNER JOIN ORDERS 
    ON CUSTOMERS.CUSTOMER_ID=ORDERS.CUSTOMER_ID;
    관계가 있는것만 합치는것을 INNER JOIN ON 이다.
    그 관계를 ON 절 뒤에 표시를 한다.
    --관계가 없는건 양쪽에서 서로 제거한다.
    --관계가 있는건 부모는 참조하는 수만큼 복제되고 합쳐진다.
    --ANSI SQL에서 범용적으로 사용하는 표준 SQL이다.
    
    *** OUTER JOIN ***
    참조키를 기준으로 일치하지 않는 행도 포함시키는 조인.
        MEMBER(USER 정보) LEFT/RIGHT/FULL OUTER JOIN NOTICE(게시글)
        ON MEMBER."ID" = NOTICE.WRITE
        JOIN을 기준으로.
        LEFT = MEMBER
        RIGHT = NOTICE
        FULL = MEMBER,NOTICE 둘다
        를 포함시키겠다는것.
        SELECT
        CT.NAME,CT.CUSTOMER_ID,
        ord.ORDER_ID,ord.STATUS
        FROM customers CT
        LEFT JOIN orders ord
        ON CT.customer_id=ord.customer_id
        ORDER BY CT.customer_id;
    -- LEFT 는 FROM에 있는 격자 OUTER 데이터를 가져오고
    -- RIGHT 는 JOIN에 있는 격자 OUTER 데이터를 가져오겠다.
    --여기서 LEFT,FULL,RIGHT를 넣건 결과값은 RIGHT 제외하고 같다
    --이유는 ORDERS는 CUSTOMERS를 참조하고 있기때문에
    --ORDERS에 있고, CUSTOMERS에 없는건 없기때문이다.
    
    --LEFT JOIN ON 의 COUNT 결과
    SELECT
    COUNT(*)
    FROM customers CT
    LEFT JOIN orders ord
    ON CT.customer_id=ord.customer_id
    ORDER BY CT.customer_id; 
    --LEFT JOIN 주문하지않은 회원도 포함시킨 개수 : 377
    
    --
    SELECT
    COUNT(*)
    FROM customers CT  
    --총 등록된 고객의 수는  : CUSTOMER 319
    JOIN orders ord
    ON CT.customer_id=ord.customer_id
    ORDER BY CT.customer_id; 
    --총 주문된 ORDER의 수는 : JOIN ON 105;
    
    SELECT
    COUNT(DISTINCT CUSTOMER_ID)
    FROM ORDERS; 
    --주문한 고객의 수는 : 47명
    
    -- LEFT로 합치면 (주문한 수 + 등록된 고객의 수 - 중복된 주문한 고객의수)
    -- LEFT의 개수는 377개가 되어야한다. 정답!
    
    --FULL OUTER의 ROWNUM은
    INNER JOIN으로 공통된게 복제되서 합쳐지고 A
    LEFT 테이블 OUTER B
    RIGHT 테이블 OUTER C
    COUNT(FULL OUTER) = A+B+C;
    
    OUTER JOIN을 이용한 게시글 목록 쿼리
    --INNER JOIN보다 OUTER JOIN을 더 많이 사용하는 이유?
    JOIN을 한다는건 두 COLUMN을 합친다는것.
    COLUMN 명이 같을 경우 식별자 에러가 발생
    쿼리명이 복잡하더라도 테이블명이 컬럼에 들어가면 안된다.
    
    1.테이블 명을 명시적으로 사용
        SELECT
        customers.NAME, customers.CUSTOMER_ID,
        orders.ORDER_ID,orders.STATUS
        FROM customers
        JOIN orders
        ON customers.customer_id = orders.customer_id
        ORDER BY customers.customer_id;
        --테이블 명이 너무 길어진다.
    2.테이블의 별칭을 사용
        SELECT
        CT.NAME,CT.CUSTOMER_ID,
        ord.ORDER_ID,ord.STATUS
        FROM customers CT
        LEFT JOIN orders ord
        ON CT.customer_id=ord.customer_id
        ORDER BY CT.customer_id;
    
    INNER JOIN 
    (단점, 공통점이 있는것만 볼수있다.)
    
    고객별 구매한 물품의 수를 조회하시오.
    SELECT
    CT.NAME,
    COUNT(ord.order_id)
    FROM customers CT
    LEFT JOIN orders ord
    ON CT.customer_id=ord.customer_id
    GROUP BY CT.NAME
    ORDER BY CT.NAME;
    
    //메인은 고객이면 고객이 다 나와야한다.
    //OUTER JOIN은 메인을 정하는것.
    //거기서 관련된 정보를 붙여넣는것이다.
    
    **** SELF JOIN ****
    서로 다른 테이블을 합치는건 JOIN
    SELF JOIN은 같은 테이블을 합치는것.
    
    이유 ? 같은 테이블 내에 관계가 있는 정보를 MAPPing해서 새 만드는것
    관계가 있는데 관계명?
    employee_id , manager_id 같이 참조를 한다.
    같은 테이블의 pk값을 다시 자기 컬럼에서 사용한다.
    SELECT M.*,
    B.first_name MANGER_NAME
    FROM employees M
    LEFT OUTER JOIN employees B
    ON M.manager_id = B.employee_id;
    --사원이 주인공.
    
    //지금까지는 표준 SQL
    //오라클만의 쿼리
    --ANSI INNER JOIN
        SELECT N.ID , N.TITLE , M.NAME
        FROM MEMBER M
        INNER JOIN NOTICE N
        ON M.ID = N.WRITER_ID
        --깔끔하게 구분이 된다.
        WHERE M.ID = 'userid';
        서로 범위를 넘나들지 않는다.
    --Oracle INNER JOIN
        SELECT N.ID , N.TITLE , M.NAME
        FROM MEMBER M ,NOTICE N
        WHERE M.ID = N.WRITER_ID
              AND M.ID='userid';
        이미 WHERE가 있기때문에 AND로 추가를 한다.
    //예시
    SELECT
    A.employee_id, A.first_name , A.manager_id,
    B.first_name manager_name
    FROM employees A
    LEFT OUTER JOIN employees B
    ON A.manager_id = B.employee_id
    ORDER BY A.employee_id;
    --위 방법이 ANSI 표준 방법
    SELECT
    A.employee_id, A.first_name , A.manager_id,
    B.first_name manager_name
    FROM employees A,employees B
    WHERE A.manager_id = B.employee_id(+)
    ORDER BY A.employee_id;
    --위 방법이 ORACLE JOIN 방법
    --오른쪽에 NULL값이 들어간다는걸 표시한다
    --ANSI 방법과 반대방법으로 표시를 한다.
    --FULL OUTER JOIN은 지원하지 않는다.
    
    --ANSI CROSS JOIN
        SELECT
        A.*,
        B.first_name manager_name
        FROM employees A
        CROSS JOIN employees B;
        --A가 3개 B가2개 정보가 있다면.
        --3 * 2 6개 결과를 만들어낸다. 
        --의미가 있는 데이터가 아니다.
    
    --Oracle CROSS JOIN
        SELECT
        A.*,
        B.first_name manager_name
        FROM employees A,employees B;
        
    --오라클이 과거문장이 보고 당황하지말라고 하는것.
*/


