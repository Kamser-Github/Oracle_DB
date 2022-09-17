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
    
    순위 함수
    정렬된 순서대로 일련번호를 붙이고 싶다면 - ROWNUM
    
    SELECT ROW_NUMBER(),employee_id,first_name
    FROM employees
    --WHERE  ROWNUM은 여기서 번호가 결정된다.
    --GROUP BY
    ORDER BY manager_id,
             first_name;
    -- WHERE 절에서 만들어지기 때문에 ORDER BY에서 섞인다.
    
    -- ROWNUM을 ORDER BY 이후에 정하는 함수
    SELECT 
    ROW_NUMBER() OVER (ORDER BY manager_id,first_name),
    --정렬을 하고 일련번호를 붙이게 만들어주는 함수.
    --안에 있는 ORDER BY도 적용되게 한다.
    employee_id,first_name,manager_id
    FROM employees;
    
    --등수 매기기
    SELECT 
    RANK() OVER (ORDER BY manager_id),
    employee_id,first_name,manager_id
    FROM employees;
    --ORDER BY로 묶인 동일한 값을 랭크로 매긴다
    --값이 같으면 공동 순위처럼 매기면서 숫자를 센다.
    // 1 1 3 4 4 5 5 5 5 9 9 9 이런식이다.  
    
    --등수를 매길때 차례대로 점수를 넣고싶을때
    SELECT 
    DENSE_RANK() OVER (ORDER BY manager_id),
    employee_id,first_name,manager_id
    FROM employees;
    // 1 1 1 2 3 3 3 3 4 4 5 5 5 5 6 6 7 8 8 이런식
    
    //파티션별로 순위를 매기고 싶을때
    SELECT 
    ROW_NUMBER() OVER (PARTITION BY manager_id ORDER BY manager_id),
    employee_id,first_name,manager_id
    FROM employees;
    --파티션 별로 다시 순위를 매기고 싶을때 그룹 manager_id,
    1차 정렬은 manager_id
    2차 정렬은 first_name
    ASC 일경우 오름차순으로 그룹별 순서가 매겨짐
    DESC 일경우 내림차순으로 그룹별 순서가 매겨짐
    SELECT 
    ROW_NUMBER() OVER 
    (
        PARTITION BY manager_id 
        ORDER BY manager_id,
                 first_name DESC
    ),
    employee_id,first_name,manager_id
    FROM employees;
*/
SELECT 
ROW_NUMBER() OVER (ORDER BY manager_id,first_name),
employee_id,first_name,manager_id
FROM employees;

SELECT 
DENSE_RANK() OVER (ORDER BY manager_id),
employee_id,first_name,manager_id
FROM employees;

SELECT 
ROW_NUMBER() OVER (PARTITION BY manager_id ORDER BY manager_id,first_name),
employee_id,first_name,manager_id
FROM employees;
--파티션 별로 다시 순위를 매기고 싶을때