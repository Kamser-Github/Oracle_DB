/*
    VIEW 뷰
    우리가 보고 있는 테이블을 
    때로는 좁게 볼수도 있고
    때로는 더 넓게 볼수도 있다.
    물리적인 데이터 구조 ( TABLE )
    개념적인 데이터 구조 ( VIEW  )
    TABLE은 데이터 무결성으로 서로 필요한 COLUMN으로 묶여진 데이터 집합
    이 테이블을 합쳐서 보거나, 필요한 정보나 추출해서 보거나 할때
    이때 OUTER JOIN ON을 사용할때 기준을 잡아야한다.
    SELECT
    C.NAME , C.CUSTOMER_ID,
    O.STATUS, O.ORDER_DATE,
    p.product_name,
    I.QUANTITY
    FROM CUSTOMERS C
    LEFT OUTER JOIN ORDERS O
    ON O.CUSTOMER_ID = C.CUSTOMER_ID
    LEFT OUTER JOIN ORDER_ITEMS I
    ON O.ORDER_ID = I.ORDER_ID
    LEFT OUTER JOIN PRODUCTS P
    ON I.PRODUCT_ID = P.PRODUCT_ID
    ORDER BY C.CUSTOMER_ID;
    여기서 기준은 CUSTOMERS를 기준으로 잡고서 조회를 했다.
    
    이런 쿼리를 매번 작성하기 불편하기 때문에
    실제 데이터는 아니고 개념적 테이블을 만들수가 있는데
    
    --CREATE VIEW [뷰 NAME] AS
    이하 조회구절
    
    --사용할때는 테이블처럼 사용이 가능하다.
    SELECT * FROM [뷰 NAME];
    
    --EX
    CREATE VIEW ORDER_CUSTOMER AS
    SELECT
    C.NAME , C.CUSTOMER_ID,
    O.STATUS, O.ORDER_DATE,
    p.product_name,
    I.QUANTITY
    FROM CUSTOMERS C
    LEFT OUTER JOIN ORDERS O
    ON O.CUSTOMER_ID = C.CUSTOMER_ID
    LEFT OUTER JOIN ORDER_ITEMS I
    ON O.ORDER_ID = I.ORDER_ID
    LEFT OUTER JOIN PRODUCTS P
    ON I.PRODUCT_ID = P.PRODUCT_ID
    ORDER BY C.CUSTOMER_ID;
    
    --사용해보기
    SELECT * FROM ORDER_CUSTOMER;
    
    --응용하기
    SELECT * FROM ORDER_CUSTOMER WHERE STATUS = 'Shipped'
    ORDER BY CUSTOMER_ID;
    SELECT * FROM ORDER_CUSTOMER WHERE LOWER(NAME) = 'raytheon';
    //재고가 부족할만하것 미리 체크하기.
    SELECT * FROM ORDER_CUSTOMER WHERE QUANTITY < 40;
*/