/*
    문자 데이터를 가공하는 문자 함수

    


    CHR
    CONCAT - 문자열 덧셈 함수
        SELECT CONCAT('홍','길동') FROM DUAL;
        SELECT 3||'4' FROM DUAL;
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