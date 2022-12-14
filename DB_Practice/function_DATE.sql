/*
    날짜 함수

    현재 시간을 얻는 함수
    SYSDATE,CURRENT_DATE,SYSTIMESTAMP,CURRENT_TIMESTAMP
    SELECT SYSDATE,CURRENT_DATE,SYSTIMESTAMP,CURRENT_TIMESTAMP FROM DUAL;
    22/09/16 - 데이터베이스 시간대 SYSDATE 오라클 시간대
    22/09/16 - 사용자 설정된 시간대 CURRENT_DATE 세션 설정 (접속시간대)
        세션 시간과 포멧 변경
        ALTER SESSION SET TIME_ZONE = '-1:0' 
        //나는 다른나라에 있다면 우리나라 '09:00';
        // LA에 있다면 '-08:00'; CURRENT_DATE는 이걸로 바뀐다.
        ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
        
        ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
    22/09/16 23:59:38.606000000 +09:00 - SYSTIMESTAMP //밀리세컨즈까지
    22/09/16 23:59:38.606000000 ASIA/SEOUL - CURRENT_TIMESTAMP
    
    날짜 추출함수 EXTRACT
    (YEAR/MONTH/DAY/HOUR/MINUTE/SECOND FROM..)
    SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL; 2022
    SELECT EXTRACT(YEAR FROM MONTH) FROM DUAL; 2022
    SELECT EXTRACT(YEAR FROM DAY) FROM DUAL; 2022
    EXTRACT(MINUTE FROM SYSTIMESTAMP) 시, 분, 초는 SYSTIMESTAMP랑 쓴다.
    
    가입회원중에 비수기(2,3,11,12)월 달에 가입한 회원을 조회하시오
    SELECT * FROM employees WHERE EXTRACT(MONTH FROM HIRE_DATE) IN (2,3,11,12);
    
    날짜를 누적하는 함수 ADD_MONTHS(날짜,정수)
    SELECT ADD_MONTHS(SYSDATE,1) FROM DUAL;
    SELECT ADD_MONTHS(SYSDATE,-1) FROM DUAL;
    
    가입 회원 중에 가입한지 6개월이 안되는 회원을 조회하시오
    SELECT * FROM employees WHERE ADD_MONTHS(HIRE_DATE,6) < SYSDATE;
    SELECT * FROM employees WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE)<6;
    
    날짜의 차이를 알아내는 함수 MONTHS_BETWEEN(날짜,날짜)
    SELECT MONTHS_BETWEEN(SYSDATE,TO_DATE('2022-05-25')) FROM DUAL;
    
    다음 요일을 알려주는 함수 NEXT_DAY(현재날짜,다음요일) FROM DUAL;
    SELECT NEXT_DAY(SYSDATE,'토요일') FROM DUAL;
    SELECT NEXT_DAY(SYSDATE,'토') FROM DUAL;
    SELECT NEXT_DAY(SYSDATE,7) FROM DUAL;
    //오늘이 토요일이면 다음주 토요일 +7 한 날짜를 알려줌
    //오늘이 22-09-17 출력 22-09-24
    
    월의 마지막 일자를 알려주는 함수 LAST_DAY(날짜)
    SELECT LAST_DAY(SYSDATE) FROM DUAL;
    //output : 2022-09-30 , today: 22-09-17
    //금일 기준 추가 월을 더하면 그 월의 마지막 일자를 알려줌.
    SELECT LAST_DAY(ADD_MONTHS(SYSDATE,?)) FROM DUAL;
    
    지정된 범위에서 날짜를 반올림하는/자르는 함수 ROUND/TRUNC(날짜,포멧)
    SELECT ROUND(SYSDATE,'CC'),TRUNC(SYSDATE,'CC') FROM DUAL;
*/
SELECT ROUND(SYSDATE,'CC'),TRUNC(SYSDATE,'CC') FROM DUAL; --세기 100년단위

SELECT ROUND(SYSDATE,'YEAR'),TRUNC(SYSDATE,'YEAR') FROM DUAL; -- 월이 기준
SELECT ROUND(SYSDATE,'Q'),TRUNC(SYSDATE,'Q') FROM DUAL;
SELECT ROUND(SYSDATE,'MONTH'),TRUNC(SYSDATE,'MONTH') FROM DUAL;
SELECT ROUND(SYSDATE,'W'),TRUNC(SYSDATE,'W') FROM DUAL;
SELECT ROUND(SYSDATE,'D'),TRUNC(SYSDATE,'D') FROM DUAL;

SELECT ROUND(SYSDATE),TRUNC(SYSDATE) FROM DUAL;
