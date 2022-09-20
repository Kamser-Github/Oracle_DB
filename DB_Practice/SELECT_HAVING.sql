/*
    집계하기
    [SUM,MIN,MAX,COUNT,AVG]
    
    FROM에 조건을 붙이는건 WHERE
    GROUP BY에 조건을 붙이는건 HAVING
    
    매니저별 담당 직원의수를 조회하시오 단,5명보다 적은 매니저id를 구하시오
    SELECT manager_id,COUNT(manager_id) FROM employees
    GROUP BY manager_id
    HAVING COUNT(manager_id)<5;
    GROUP BY, SELECT에서 생성된 함수는 WHERE에서 사용이 불가하다.
    실행순서가
    FROM > WHERE > GROUP BY > HAVING > ORDER BY > SELECT 이기 때문이다
*/