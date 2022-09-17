/*
    변환 함수
     TO_CHAR()  TO_DATE()
    숫자 <=> 문자열 <=> 날짜
    TO_NUMBER()   TO_CHAR()
    
    NUMBER 형식을 문자열(VARCHAR2)로 변환 TO_CHAR(NUMBER)
    SELECT TO_CHAR(12345678,'$99,999,999,999.99') FROM DUAL;
    //$12,345,678.00 달라 형식으로 숫자를 문자열로 변경한다.
    //숫자 길이보다 포멧정보가 길어야한다. 
    //포멧문자    설명
    //9         숫자
    //0         빈자리를 채우는 문자
    //$         앞에 $ 표시
    //,         천 단위 구분자 표시 9사이간격만큼마다 찍어낸다
    //.         소수점 표시
    SELECT TO_CHAR(12345678,'99,9999,99.99') FROM DUAL;
    SELECT TO_CHAR(12345678,'9,9,9,9,9,9,9,9')||'HELLO' FROM DUAL;
    //1,2,3,4,5,6,7,8HELLO
    SELECT TO_CHAR(12345678,'9,9,9,9')||'HELLO' FROM DUAL;
    //########HELLO 포멧 크기를 벗어나면 오류가 난다.
    SELECT TO_CHAR(12345,'099,999,999')||'원' FROM DUAL;
    // 000,012,345원
    SELECT TRIM(TO_CHAR(12345,'99,999,999')||'원') FROM DUAL;
    // 12,345원
    SELECT TRIM(TO_CHAR(12345.55,'99,999,999.999999'))||'원' FROM DUAL;
    // 12,345.550000원 소수점은 0으로 자동으로 채운다.
    // 소수점 포멧보다 더 소수점이 길어지면 반올림한다.
    
    DATE 형식을 문자열(VARCHAR2)로 변환 TO_CHAR(DATETIME)
    * * *
    SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
    포멧문자            설명
    YYYY/RRRR/YY/YEAR  년도표시:4자리/Y2K/2자리/영문
    MM/MON/MONTH       월표시:2자리/영문3자리/영문전체
    DD/DAY/DDTH        일표시:2자리/영문/2자리ST
    AM/PM              오전/오후표시
    HH/HH24            시간표시 12/24시간
    MI                 분표시 : 0~59분
    SS                 초표시 : 0~59초
    SELECT TO_CHAR(SYSDATE,'YY/MM/DD HH24:MI') FROM DUAL;
    --22/09/17 01:30
    SELECT TO_CHAR(SYSDATE,'YYYY/MON/DDTH HH:MI') FROM DUAL;
    --2022/9월 /17TH 01:31
    // 위 포멧 형식으로만 사용이 가능하다.
    
    문자열을 날짜 형식으로 변환하는 함수 TO_DATE(문자열,날짜포멧)
    * * *
    날짜까지는 인식을하지만 그 뒤는 포멧을 지정해서 알려줘야한다.
    SELECT TO_DATE('1994-04-01','YYYY-MM-DD') FROM DUAL;
    SELECT TO_DATE('1994-04-01 12:23:03','YYYY/MM/DD HH:MI:SS') FROM DUAL;
    //OK
    SELECT TO_DATE('1994-04-01 12:23:03','YYYY/MM/DD') FROM DUAL;
    //ERROR
    
    문자열을 숫자형식으로 변환하는 함수 TO_TIMESTAMP(문자열)
    SELECT TO_TIMESTAMP('1994-01-01 12:23:25','YYYY-MM-DD HH24:MI:SS')
    FROM DUAL;
    
    문자열을 숫자형식으로 변환하는 함수 TO_NUMBER(문자열)
    SELECT TO_NUMBER('2003') FROM DUAL;
    
    SELECT '2'+3 FROM DUAL; //덧셈은 문자열을 숫자로 변환
    SELECT TO_NUMBER('2')+3 FROM DUAL; //명시적으로 숫자로 변환
    
    변환함수는 자주 사용하기 때문에 암기해두는편이 좋다.
*/
