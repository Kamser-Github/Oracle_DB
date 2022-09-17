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
/*
    문자열 함수
    CHR
    CONCAT - 문자열 덧셈 함수
        SELECT CONCAT('홍','길동') FROM DUAL;
        SELECT 3||'4' FROM DUAL;
        
    INITCAT - 첫글자를 대문자로 바꾸는 함수
        SELECT INITCAP('the..') FROM DUAL; //The..
        SELECT INITCAP('the most important is..') FROM DUAL; //The Most
        SELECT INITCAP('the m양os파t important is..') FROM DUAL; 
        //The M양Os파T 한글 뒤에 영어도 대문자로 변경됨.
        
    LOWER
    LPAD - 문자열 패딩 함수
        SELECT LPAD('HELLO',5) FROM DUAL; //HELLO
        SELECT LPAD('HELLO',5,'0') FROM DUAL; //HELLO
        SELECT LPAD('HELLO',10,'0') FROM DUAL; //00000HELLO
        SELECT RPAD('HELLO',10,'0') FROM DUAL; //HELLO00000
        너비를 고정하고 싶을때 이건 바이트 단위 2배를 곱해야한다.
        SELECT LPAD(first_name,10,' ') FROM employees; /
        
    LTRIM - 빈 공백을 제거하는 함수
        SELECT LTRIM('    HELLO    ') FROM DUAL; //'HELLO    ';
        SELECT RTRIM('    HELLO    ') FROM DUAL; //'    HELLO';
        SELECT TRIM ('    HELLO    ') FROM DUAL; //'HELLO';
    NLS_INITCAP
    NLS_LOWER
    NLSSORT
    NLS_UPPER
    REGEXP_REPLACE
    REGEXP_SUBSTR
    REPLACE - 문자열 대치 함수 REPLACE(문자열,찾는 문자열,대치할문자열)/TRANSLATE()
        SELECT REPLACE('WHERE WE ARE','WE','YOU') FROM DUAL; //통채로 변경
        SELECT TRANSLATE('WHERE WE ARE','WE','YOU') FROM DUAL; 
        //W = Y ,E = O ,U는 의미없어짐 2,3 매개변수 길이가 일치해야함.
        //YHORO YO ARO
        회원의 이름과 주소를 조회하시오.(단 주소는 빈칸없이 출력하시오)
        SELECT NAME,REPLACE(job_title,' ','') FROM employees;
    RPAD
    RTRIM
    SOUNDEX
    SUBSTR - 문자열 추출함수 SUBSTR(문자열,시작위치,길이)
        SELECT SUBSTR('HELLO',1,3) FROM DUAL;
        SELECT SUBSTR('HELLO',3) FROM DUAL; //전체,시작위치만
        SELECT SUBSTRB('HELLO',3) FROM DAUL; //바이트 안뒤로 자르는것
        모든 학생의 이름과 출생 월만을 조회하시오.
        SELECT NAME,SUBSTR(BIRTHDAY,3,2) MONTH FROM MEMBERS;
        모든 회원중에서 전화번호가 011로 시작하는 회원의 정보를 출력;
        SELECT * FROM EMPLOYEES WHERE SUBSTR(PHONE,1,3)='515';
        SELECT * FROM EMPLOYEES WHERE PHONE LIKE '515%';
        
        회원 중에서 생년 월이 7,8,9월인 회원의 모든 정보를 출력하시오
        SELECT * From EMPLOYEES WHERE SUBSTR(HIRE_DATE,4,2) BETWEEN 7 AND 9;
        SELECT * From EMPLOYEES WHERE SUBSTR(HIRE_DATE,4,2) IN('07','08','09');
        전화번호를 등록하지 않은 회원중에서 생일이 7,8,9월인 출력
        SELECT * FROM EMPLOYEES WHERE SUBSTR(HIR_DATE,4,2) IN('07'',08','09')
        AND PHONE IS NULL;
        
    TRANSLATE
    TREAT
    UPPER - 문자열 소문자 또는 대문자 변경
        //단 대/소문자를 가리지 않을때 검사하기 위해서
        SELECT LOWER('NewWeeK') FROM DUAL; // newweek;
        SELECT UPPER('NewWeeK') FROM DUAL; // NEWWEEK;
        SELECT * FROM employees WHERE UPPER(first_name)='JOHN';
        SELECT * FROM employees WHERE UPPER(SID)=UPPER('JOHN');
        
    INSTR - 문자열 검색 함수 INSTR(문자열,검색문자열,위치,찾을 수)
        SELECT INSTR('ALL WE NEED TO IS JUST TO...','TO) FROM DUAL;
        내가 문자열에서 to라는 문자가 있으면 그 문자의 위치를 반환(첫번째)
        SELECT INSTR('ALL WE NEED TO IS JUST TO...','TO') FROM DUAL; 13
        SELECT INSTR('ALL WE NEED TO IS JUST TO...','TO',15) FROM DUAL; 
        24 --15는 OFFSET처럼 검색할위치를 정해줌
        SELECT INSTR('ALL WE NEED TO IS JUST TO...','TO',1,2) FROM DUAL; 
        찾앗으면 카운트를해서 그 순번에 있는 위치를 반환
        회원의 전화번호에서 두번째 . 문자가 존재하는 위치를 출력하시오
        SELECT DISTINCT INSTR(PHONE,'.',1,2) FROM EMPLOYEES; -- 8 OR 7
        회원의 전화번호에서 첫 번째 구분자와 두번째 구분자 사이의 간격은
        SELECT DISTINCT INSTR(PHONE,'.',1,2)-INSTR(PHONE,'.')-1 FROM EMPLOYEES; -- 8 OR 7
        -1의 이유는 첫번째 위치가 구분자부터 시작되기 때문이다.
        회원의 전화번호에서 가운데 사이의 국번을 출력하세요.
        SELECT DISTINCT 
        SUBSTR
        (
            PHONE,
            INSTR(PHONE,'.')+1,
            INSTR(PHONE,'.',1,2)-INSTR(PHONE,'.')-1
        )
        FROM EMPLOYEES;
    
    LENGTH - 문자열의 길이를 얻는 함수
        SELECT LENGTH('WHERE WE ARE') FROM DUAL;
        
        모든 회원의 핸드폰 번호와 번호의 문자열 길이를 조회하시오.
        SELECT PHONE,LENGTH(PHONE) FROM employees;
        
        핸드폰 번호의 숫자만의 길이를 조회하시오
        SELECT LENGTH(REPLACE(PHONE,'.','')) FROM employees;
    
    코드 값을 반환하는 함수
        SELECT ASCII('A') FROM DUAL;
        
    코드 값으로 문자를 반환하는 함수
        SELECT CHR(65) FROM DUAL;
*/

SELECT * FROM EMPLOYEES WHERE SUBSTR(HIRE_DATE,4,2) IN('07','08','09')
        AND PHONE IS NOT NULL;
SELECT REPLACE(job_title,' ','') FROM employees;
/*
    함수 사용 - 다양한 방법으로 데이터로 추출이 가능
    이름은 몇자인가 ?
    성은 제외하고 이름만 어떻게 되는가?
    이름이 외자인 경우 뒤에 '자'를 붙일 것
    이름에 빈 공백은 제거하고 출력할 것.
    영문 이름이 경우 첫 글자는 소문자로
    row => 함수 => 가공 데이터
*/