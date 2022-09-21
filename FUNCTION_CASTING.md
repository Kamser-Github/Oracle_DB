# 자료형을 변환하는 형 변환 함수

### 1. 자동 형 변환
```
SELECT SYSDATE,
    '250'+'250', -- 500
    'ABC'+'250'  -- error
FROM DUAL;

왼쪽에서 오른쪽으로 연산할때
자료형이 숫자면 자동 형변환으로 계산이 된다

하지만 숫자가 아닐경우에는 오류가 생긴다
```
```
자동형변환이 잘 작동이 안되기 때문에
사용자가 직접 지정하는 방식인 "명시적 형변환"을 해야한다.

    종류                    설명
    ---                     ---
  TO_CHAR           숫자 또는 날짜데이터 => 문자 데이터
  TO_NUMBER         문자 데이터 => 숫자데이터
  TO_DATE           문자 데이터를 날짜 데이터로 변경


    숫자 데이터 <-> 문자데이터 <-> 날짜데이터
```

## TO_CHAR 날짜,숫자 데이터를 문자데이터로 변환
> TO_CHAR   
```
TO_CHAR([날짜 데이터(필수)],[출력되길 원하는 문자 형태(필수)])
날짜 데이터를 원하는 문자열로 출력합니다.
```
```
SELECT
        TO_CHAR(SYSDATE,'YYYY/MM/DD')
FROM DUAL;

TO_CHAR(SYSDATE,'YYY')
--------------------
2022/09/21
```
```
    형식            설명
    ---             ---
    CC              세기
   YYYY             연(4자리 숫자)
   YY,RR            연(2자리 숫자)
   MM               월(2자리 숫자)
   MON              "언어별 월 이름 약자"
   MONTH            "언어별 월 이름 전체"
   DD               일(2자리 숫자)
   DDD              1년중 며칠(1~366)
   DY               요일(언어별 이름 약자)
   DAY              요일(언어별 요일 이름 전제)
   W                1년중 몇번째주(1~53)

SELECT
    TO_CHAR(SYSDATE,'MM') AS MM,
    TO_CHAR(SYSDATE,'MON') AS MON,
    TO_CHAR(SYSDATE,'MONTH') AS MONTH,
    TO_CHAR(SYSDATE,'DD') AS DD,
    TO_CHAR(SYSDATE,'DAY') AS FAY
FROM DUAL;

MM   MON    MONTH  DD   FAY
---- ------ ------ ---- --------
09   9월    9월    21   수요일
```
`특정 언어에 맞춰서 날짜 출력하기`
```
TO_CHAR(
    [날짜 데이터(필수)],[출력되길 원하는 포멧(필수)],
    NLS_DATE_LANGUAGE = lenguage(선택)
)
날짜 데이터를 출력할문자 형태를 지정하고
원하는 언어 양식을 지정합니다.

SELECT
    TO_CHAR(SYSDATE,'MON-DAY','NLS_DATE_LANGUAGE = JAPANESE') AS JAPAN
FROM DUAL;

JAPAN
------------
9月 -水曜日
```

`시간 형식 지정하여 출력하기`
```
    형식           설명
    ---            ---
    HH24        24시간으로 표현
    HH          12시간으로 표현
    MI              분
    SS              초
  AM , PM        오전 오후표시
  A.M,P.M
```
```
SELECT
    TO_CHAR(SYSTIMESTAMP,'HH') AS HH,
    TO_CHAR(SYSTIMESTAMP,'HH24') AS HH24,
    TO_CHAR(SYSTIMESTAMP,'MI') AS MI,
    TO_CHAR(SYSTIMESTAMP,'HH-MI-SS PM') AS DAY
FROM DUAL;

HH   HH24  MI        DAY
---- ---- ---- ---------------
09   21   49   09-49-17 오후

```

`숫자 제이터를 => 문자 데이터`
```
    형식        설명
    9         숫자의 한 자리를 의미함(빈 자리를 채우지 않음)
    0         빈 자리를 0으로 채움
    $         달러($) 표시를 붙여서 출력
    L         L(Locale) 지역 화폐 단위 기호를 붙여서 출력
    .         소수점을 표시함
    ,         천 단위 구분 기호를 표시함

ELECT TO_CHAR(12345678,'99,9999,99.99') FROM DUAL;
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
```
<BR>

## `TO_NUMBER() 문자 데이터를 숫자 데이터로 변환`
> 숫자처럼 생긴 문자열 데이터를 다룰때 사용한다.
```
TO_NUMVER('[문자열 데이터(필수)]','[인식될 숫자(필수)]')

SELECT '2'+3 FROM DUAL; //덧셈은 문자열을 숫자로 변환
SELECT TO_NUMBER('2')+3 FROM DUAL; //명시적으로 숫자로 변환
```
<BR>

## `TO_DATE 물자 데이터 => 날짜데이터`
> 숫자처럼 생긴 문자열 데이터를 다룰때 사용한다.
```
TO_DATE('[문자열 데이터(필수)]','[인식될 날짜(필수)]');
```
```
SELECT
    TO_DATE('2020-08-13','YY-MM-DD'),
    TO_DATE('20200813','YY-MM-DD')
FROM DUAL;

TO_DATE( TO_DATE(
-------- --------
20/08/13 20/08/13
```
> 16년 5월 이후에 입사한 5명 출력
```
SELECT
    FIRST_NAME AS NAME,
    HIRE_DATE AS HIRE
FROM EMPLOYEES
WHERE
    HIRE_DATE>TO_DATE('201605','YY-MM')
AND ROWNUM < 6 ;

NAME       HIRE
---------- --------
Summer     16/06/07
Rose       16/06/07
Annabelle  16/09/17
Tommy      16/06/17
Jude       16/09/21
```
> 주의해야하지만 자주 쓰이지 않는것
```
년도 표시 YY와 RR의 차이

SELECT
    TO_DATE('49/12/10','YY/MM/DD') AS YY_YEAR_49,
    TO_DATE('49/12/10','RR/MM/DD') AS RR_YEAR_49,
    TO_DATE('50/12/10','YY/MM/DD') AS YY_YEAR_50,
    TO_DATE('50/12/10','RR/MM/DD') AS RR_YEAR_50,
    TO_DATE('51/12/10','YY/MM/DD') AS YY_YEAR_51,
    TO_DATE('51/12/10','RR/MM/DD') AS RR_YEAR_51
FROM DUAL;

YY_YEAR_49 RR_YEAR_49 YY_YEAR_50 RR_YEAR_50 YY_YEAR_51 RR_YEAR_51
---------- ---------- ---------- ---------- ---------- ----------
2049-12-10 2049-12-10 2050-12-10 1950-12-10 2051-12-10 1951-12-10

YY은 현시점 연도에서 동일한 연도로 계산되지만
RR은 현시점 연도 끝자리가 00~49 50~99
     입력수치 연도 끝자리가 00~49 50~99 인경우를 계산하여
    비교적 가까운 날짜의 데이터를 계산해준다
    현시점 끝자리는 22
    입력수치가 50이 넘어가면 가까운 1950년으로 내려가고

    현시점이 끝자리가 50이되면
    입력수치가 49이하일경우 2100년으로 간다.
```
