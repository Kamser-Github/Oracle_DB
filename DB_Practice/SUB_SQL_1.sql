/*
    *부조회(서브쿼리)
    --SELECT 는 순서대로 해야한다 , 순서를 바꿔야하는 경우에는 어떻게 할까?
    --부조회(서브쿼리)
    
    구절의 순서를 바꿔야하는 경우
        SELECT * FROM MEMBER WHERE ROWNUM BETWEEN 1 AND 10;
        //신입 직원으로 정렬한 결과에서 상위 열명을 원하는 경우라면?
        --FROM이 격자형 데이터를 가져온후 등록순으로 정렬을 하고 
        --그뒤 ROWNUM으로 순위를 매겨야한다
        
    --서브쿼리 없이 실행할 경우
        SELECT * FROM employees
        WHERE ROWNUM BETWEEN 1 AND 10
        ORDER BY HIRE_DATE DESC;
    -- 이렇게 하면 먼저 10명이 뽑힌뒤 거기서 정렬을 시작한다.
    
    -- 우리가 원하는건 정렬을 한뒤 10명을 위에서부터 자르는것.
        SELECT * FROM employees ORDER BY HIRE_DATE DESC;
    -- 결과물을 가지고 조회를 한다.
        SELECT * FROM (SELECT * FROM employees ORDER BY HIRE_DATE DESC)
        WHERE ROWNUM BETWEEN 1 AND 10;
    -- X * Y + Z 에서 덧셈을 먼저하고 싶으면 X*(Y+Z) 소괄호를 하는데
    -- 서브쿼리도 같은 방식이라 생각하면 편하다.
    -- 먼저 실행해야할때가 있다면 서브쿼리를 사용하면 된다.
    
    // 매니저가 담당하는 직원의 수가 5명 이하인 매니저 번호를 조회하시오
        SELECT manager_id ,
        COUNT(manager_id)
        FROM employees 
        GROUP BY manager_id
        HAVING COUNT(manager_id)<5;
    // 매니저가 담당하는 직원의 수가 평균보다 작은 매니저 번호를 조회하시오.
        SELECT manager_id ,
        COUNT(manager_id)
        FROM employees 
        GROUP BY manager_id
        HAVING COUNT(manager_id)<(SELECT AVG(COUNT(manager_id))FROM employees GROUP BY manager_id);
    -- 먼저 평균 담당 직원의 수를 구해야 한다.
*/
