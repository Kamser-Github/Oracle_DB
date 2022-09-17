/*
    # UNION
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
        SELECT employee_id ,first_name FROM employees --107
        UNION --107개
        SELECT employee_id ,first_name FROM employees; --107
    
    UNION ALL 두개를 뒤돌아보지도 않고 합친다.
        SELECT employee_id ,first_name FROM employees --107
        UNION ALL --214개
        SELECT employee_id ,first_name FROM employees; --107
        
    MINUS : 뒤에있는것이랑 공통된것을 빼는것
        A {1,2,3,4} MINUS B {2,3,5}  결과는 {1, 4}
    
    INTERSECT : 두개의 테이블에 공통된것만 남기는것
        A {1,2,3,4} INTERSECT B{2,3,5} 결과는 {2,3}
    
    하나의 테이블에서도 사용이 가능하다.(SET과 같은 개념)
*/