# DECODE함수 , CASE 문

## `DECODE,CASE 모두 조건별로 동일한 자료형의 데이터를 반환해야한다.`

```
NVL,NVL2는 주어진 데이터나 열이 NULL일 경우에
어떤 데이터를 반환할지 정하는 함수라면

특정 열값이나 데이터 값에따라 어떤 데이터를 반환할지
정할때는 DECODE나 CASE문을 사용한다.

기준 데이터를 반드시 명시하고 그 값에 따라 반환 데이터를 정한다.
```

## DECODE 함수
```
DECODE(
    [조건 대상이 될 열 또는 데이터,연산이나 함수의 결과],
    [조건 1],[데이터가 조건 1과 일치할때 반환할 결과],
    [조건 2],[데이터가 조건 2와 일치할때 반환활 결과],
        :                       :
    [조건 n],[데이터가 조건 n와 일치할때 반환할 결과]
    [위 조건 1~n까지 일치한 경우가 없을때 반환할 결과]
)
```
```
직원 테이블에서 
    직책이
        'MANAGER'인 사람은 급여 10%를 인상
        'SALESMAN'인 사람은 급여 5%를 인상
        'ANALYST'인 사람은 급여 동결
        나머지 직책은 급여 3% 인상

SELECT
    NAME,PHONE,JOB,
    DECODE(JOB,
            'MANAGER',SAL*1.1,
            'SALESMAN',SAL*1.05,
            'ANALYST',SAL,
            SAL*1.03) AS UP_SAL
FROM EMPLOYEES;

if-else if 구문과 상당히 유사하다.

단,
마지막 데이터 조건에 해당하는 값이 없으면
NULL이 반환이 된다.
```

<br>
 
## CASE문
> CASE문은 각 조건에 사용하는 데이터가 서로 상관이 없어도 된다,   
> 또 기준 데이터 값은 같은(=) 데이터외에 다양한 조건을 사용할수 있다.   

```
CASE [검사 대상이 될 열 또는 데이터,연산이나 함수의 결과(선택)]
    WHEN [조건 1] THEN [조건 1의 결과 값이 true일때,반환할 결과]
    WHEN [조건 2] THEN [조건 2의 결과 값이 true일때,반환할 결과]
      :     :      :                   :
    WHEN [조건 n] THEN [조건 n의 결과 값이 true일때,반환할 결과]
    ELSE [위 조건1~조건n과 일치하는 경우가 없을때 반환할 결과]
END

```
> 위 DECODE를 CASE문으로 바꿔보기
```
SELECT
    NAME,PHONE,JOB,
    CASE JOB
        WHEN 'MANAGER' THEN SAL*1.1
        WHEN 'SALESMAN' THEN SAL*1.05
        WHEN 'ANALYST' THEN SAL
        ELSE SAL*1.03
    END AS UPSAL
    FROM EMPLOYEES;
```
> 기준 데이터 없이 조건식으로만 CASE문 사용하기
```
SELECT 
    COMM,
    CASE
        WHEN COMM IS NULL THEN '해당사항없음'
        WHEN COMM = 0 THEN '수당없음'
        WHEN COMM > 0 THEN '수당 '||COMM
    END AS COMM_TXT
FROM EMPLOYEES;
```
