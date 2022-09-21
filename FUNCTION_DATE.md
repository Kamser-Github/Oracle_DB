# 날짜 데이터를 다루는 날짜 함수

## `기본 날짜포멧 변경`
    날짜 함수

```
세션 시간과 포멧 변경

ALTER SESSION SET TIME_ZONE = '-1:0' 
//나는 다른나라에 있다면 우리나라 '09:00';
//LA에 있다면 '-08:00'; CURRENT_DATE는 이걸로 바뀐다.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

22/09/16 23:59:38.606000000 +09:00 - SYSTIMESTAMP //밀리세컨즈까지
22/09/16 23:59:38.606000000 ASIA/SEOUL - CURRENT_TIMESTAMP
```
## `날짜 데이터끼리는 더하기 연산이 되지 않는다`
<br>

```
    연산                             설명
    ---                              ---
날짜데이터+숫짜         날짜 데이터보다 숫짜만큼 일수 이후의 날짜
날짜데이터-숫짜         날짜 데이터보다 숫짜만큼 일수 이전의 날짜
날짜데이터-날짜데이터   두 날짜 데이터 간의 일수 차이
날짜데이터+날짜데이터   연산 불가,지원하지 않음
```
<br>

## `SYSDATE`
> ### 오라클 데이터베이스 서버가 놓인 os의 날짜와 시간을 보여준다.   
```
SELECT
    SYSDATE AS TODAY,
    SYSDATE-1 AS YESTERDAY,
    SYSDATE+1 AS TOMORROW
FROM DUAL;

TODAY    YESTERDA TOMORROW
-------- -------- --------
22/09/21 22/09/20 22/09/22
```
<br>

## `ADD_MONTHS : 몇 개월 이후의 날짜를 구하는`
> ### 오라클 데이터베이스 서버가 놓인 os의 날짜와 시간을 보여준다.   
```
ADD_MONTHS([날짜데이터(필수)],[더할 개월 수(정수)(필수)])
윤년등 복잡해질수 있는 날짜 계산을 간단하게 해준다.
```
```
//입사한지 10년이 되는 날짜 구하기

SELECT
    FIRST_NAME AS NAME,
    HIRE_DATE AS HIREDATE,
    ADD_MONTHS(HIRE_DATE,120) AS WORK10YEAR
FROM EMPLOYEES
WHERE ROWNUM<6;

NAME       HIREDATE WORK10YE
---------- -------- --------
Summer     16/06/07 26/06/07
Rose       16/06/07 26/06/07
Annabelle  16/09/17 26/09/17
Tommy      16/06/17 26/06/17
Blake      16/01/13 26/01/13

//입사 6년 미만 사원 데이터 구하기
SELECT
    FIRST_NAME AS NAME,
    HIRE_DATE AS HIREDATE
FROM EMPLOYEES
WHERE 
    ADD_MONTHS(HIRE_DATE,72)<SYSDATE
    AND ROWNUM<6;

NAME       HIREDATE
---------- --------
Summer     16/06/07
Rose       16/06/07
Annabelle  16/09/17
Tommy      16/06/17
Blake      16/01/13
```
<br>

## `MONTHS_BETWEEN : 두 날짜간의 개월수 차이를 구하는 함수`
> ### 두 날짜 데이터 간의 날짜 차이를 개월수로 계산해서 출력한다.
  
```
MONTHS_BETWEEN([날짜 데이터1(필수)],[날짜 데이터2(필수)])
```
```
SELECT
    FIRST_NAME AS NAME,
    HIRE_DATE AS HIREDATE,
    MONTHS_BETWEEN(HIRE_DATE,SYSDATE) AS MONTH1,
    MONTHS_BETWEEN(SYSDATE,HIRE_DATE) AS MONTH2,
    TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)) AS INT
FROM EMPLOYEES;

NAME       HIREDATE     MONTH1     MONTH2        INT
---------- -------- ---------- ---------- ----------
Sonny      16/07/14 -74.248782 74.2487825         74
Kian       16/10/26 -70.861686 70.8616857         70
Caleb      16/02/12 -79.313299 79.3132986         79
Ronnie     16/11/16 -70.184266 70.1842664         70
Callum     16/10/10 -71.377815 71.3778147         71
Jackson    16/05/01 -76.668137 76.6681373         76
Liam       16/04/10 -77.377815 77.3778147         77
Jaxon      16/07/18  -74.11975 74.1197502         74

두 번째 날짜데이터가 이후일경우 음수로도 나온다.
TRUNC와 잘 활용하면 결과를 정수로 얻을수있다.
```
<br>

## `NEXT_DAY,LAST_DAY 이후의 날짜를 구하려는 함수`
> ### 특정 날짜를 기주능로 돌아오는 요일의 날짜를 출력해누는 함수

```  
NEXT_DAY([날짜데이터(필수)],[요일 문자(필수)])
특정 날짜를 기준으로 돌아오는 요일의 날짜를 출ㄺ해준다
```
```
LAST_DAY([날짜 데이터(필수)]
특정 날짜가 속속 달의 마지막 날짜를 출력해 주는 함수
```

<br>

## `현재 날짜를 구하는 다양한 함수`
> ### 현재의 날짜와 시간을 알려주는 다양한 함수.
> SYSDATE,CURRENT_DATE,SYSTIMESTAMP,CURRENT_TIMESTAMP
```
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
```

<br>

## `EXTRACT : 날짜 데이터에서 특정 날짜만 추출해주는 함수`
> ### EXTRACT([추출하려는 단위(필수)] FROM [날짜데이터(필수)])
```
(YEAR/MONTH/DAY/HOUR/MINUTE/SECOND FROM..)
SELECT 
    EXTRACT(YEAR FROM SYSDATE) AS YEAR,
    EXTRACT(MONTH FROM SYSDATE) AS MONTH,
    EXTRACT(DAY FROM SYSDATE) AS DAY
FROM DUAL;
      YEAR      MONTH        DAY
---------- ---------- ----------
      2022          9         21

EXTRACT(MINUTE FROM SYSTIMESTAMP) 시, 분, 초는 SYSTIMESTAMP랑 쓴다.

가입회원중에 비수기(2,3,11,12)월 달에 가입한 회원을 조회하시오

SELECT * FROM employees WHERE EXTRACT(MONTH FROM HIRE_DATE) IN (2,3,11,12);

```

<br>

## `ROUND,TRUNC : 날짜의 반올림, 버림 함수`
```
NUMBER TYPE

입력 데이터 종류            사용 방식
    --                  -   -   -   -   -   -   -   -
 숫자 데이터            ROUND([숫자(필수)][반올림 위치])
 숫자 데이터            TRUNC([숫자(필수)][버림 위치])
    --                  -   -   -   -   -   -   -   -
 날짜 데이터            ROUND([날짜데이터(필수)],[반올림 기준 포멧])
 날짜데이터             TRUNC([날짜데이터(필수)],[버림 기준 포멧])
 ```
```
SELECT SYSDATE,
    ROUND(SYSDATE,'CC') AS FORMAT_CC,
    ROUND(SYSDATE,'YYYY') AS FORMAT_YYYY,
    ROUND(SYSDATE,'Q') AS FORMAT_Q,
    ROUND(SYSDATE,'DDD') AS FORMAT_DDD,
    ROUND(SYSDATE,'HH') AS FORMAT_HH
FROM DUAL;

SYSDATE  FORMAT_C FORMAT_Y FORMAT_Q FORMAT_D FORMAT_H
-------- -------- -------- -------- -------- --------
22/09/21 01/01/01 23/01/01 22/10/01 22/09/22 22/09/21

포멧 모델                   포멧기준
CC,SCC                  네 자리 연도의 끝 두자리를 기준으로 사용 (20XX)
SYYYY,YYYY,YEAR,        날짜 데이터의 해당 연*월*일의 7월 1일 기준
SYEAR,YYY,YY,Y          (2016년 7월 1일 경우,2017년으로 처리)
IYYY,IYY,IY,I           ISO8601 에서 제정한 날짜 기준년도 포멧을 기준
Q                       각 분기의 두번째 달의 16일 기준
MONTH,MON,MM,RM         각 달의 16일 기준
WW                      해당 연도 몇 주(1~53번째 주)를 기준
IW                      ISO 8601에서 제정한 날짜 기준 해당 연도의 주(week)를 기준
W                       해당 월의 주(1~5번째 주)를 기준
DDD,DD,J                해당 일의 정오(12:00:00)를 기준
DAY,DY,D                한 주가 시작되는 날짜를 기준
HH,HH12,HH24            해당일의 시간을 기준
MI                      해당일 시간의 분을 기준
```