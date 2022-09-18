/*
100개의 레코드를 5개씩 끊어서 보겠다. 
어느걸 기준으로 이름 ? 납입금 ? 납입일 ? 가지고 있는 컬럼으로는 꺼낼수없다.
ROWNUM 

SELECT * FROM NOTICE;
맨 왼쪽에 붙는 연속되는 숫자.
SELECT * FROM MEMBER WHERE ROWNUM BETWEEN 1 AND 5;
SELECT * FROM employees WHERE ROWNUM BETWEEN 1 AND 10;
1이 아닌 다른숫자는 반응하지 않는다.
ROWNUM이 먼저 지정되고서 레코드 정보가 저장된다
조건이 ROWNUM > 5 일때
ROWNUM은 1로 시작하고  레코드 정보가 계속 변경되면서 들어오는데
조건은 ROWNUM이 5초과이니까 계속 레코드 정보가 조건에 안맞는다고 사라진다.
SELECT * FROM 
(SELECT ROWNUM NUM,NUMBER.* FROM MEMBER)
WHERE NUM BETWEEN 1 AND 5



*/
SELECT ROWNUM,* FROM employees;
-- 위 식은 오류가 난다 *은 이미 모든(ALL)인데 거기에 ROWNUM을 또 작성했기때문에
SELECT NOTICE.employee_id,NOTICE.first_name FROM NOTICE;
-- 원래대로라면 이렇게 하나씩 컬럼명에 테이블을 작성해야하지만
-- FROM에 NOTICE하나만 있기때문에 생략이 가능한것이다.
-- *도 마찬가지로 NOTICE.* 
-- *에 모든것이라는 의미지만 한정을 지어야하기때문에 NOTICE.*
-- 으로 영역을 제한해준다.
SELECT ROWNUM ,employees.* FROM employees;
--먼저 FROM에서 우선순위를 잡기위해서 ()으로 묶고
--FROM절에서 사용할수있게 묶어둔다.
--*은 이제 employees가 아니라 결과집합의 모든것이다.
SELECT * FROM (SELECT ROWNUM NUM, employees.* FROM employees)
WHERE NUM BETWEEN 6 AND 10;
-- 가장 앞에있는 *도 ROWNUM을 가지고 있기때문에 적용이 안된다.
-- 여기서 누구의 ROWNUM을 쓸건지 따로 지정해놓고 사용하면 가능해진다,
-- 레코드 나누어서 출력하는 방법.

/*
    # 중복값 제거
    SELECT DISTINCT manager_id FROM employees;
    하나의 컬럼만 목록으로 사용할때만 사용가능하다는것.

    (+) 열이 여러개 일경우
    SELECT DISTINCT manager_id,employee_id FROM employees;
    manager_id,employee_id 열의 값이 같을경우 제외된다.

    # 중복포함하기
    SELECT ALL manager_id,employee_id FROM employees;
    ALL이 기본 DEFAULT이기 때문에 생략해서 사용하는 것.

*/
/*
            중간 요약과 함수 단원 안내
    SQL => 데이터 관리 시스템에게 질의를 하는 관리 시스템
    DBMS => 데이터 베이스를 관리해주는 시스템
    왜 관리를 하냐 ? 동시성, 보완성이 해결되야하기 대문에
    DB => 데이터를 모아서 쓰자. 중복을 속아내고 데이터를 단일화해서 사용
    DML => CRUD INSERT,SELECT UPDATE ,DELETE
        => 연산자로 기능을 사용
    SELECT 컬럼 선택, 연산, 별칭 = > 필터링 (패턴,정규식) 
            + 함수
    함수 = > INPUT, OUTPUT만 중요
*/
/*
    Function
    오라클의 값에 따라 함수가 달라지는데
    문자열 함수
    숫자 함수
    날짜 함수
    변환 함수(형변환)
    NULL 관련 함수
    집계 함수
*/