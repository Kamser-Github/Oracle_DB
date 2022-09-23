# 하나의 열에 출력 결과를 담는 다중행 함수
``` 
SELECT SUM(SAL) FROM EMP;

    SUM(SAL)
------------
       20925
```
## _`다중행 함수는 여러 행이 입력되어 하나의 행으로 결과가 출력`_
> ### 다중행 함수를 사용한 SELECT절에서는   
> ### 여러 행이 결과로 나올수 있는 열(함수:연산자가 사용된 데이터도 포함)   
> ### 함께 사용할수 없습니다.
```
SELECT NAME , SUM(SAL)
FROM EMP;

NAME은 여러행이 나오는 COLUMN이고
SUM은 SAL의 COLUMN의 모든 행을 하나로 합친 하나의 행이다.
따라서 오류가 발생한다.
```

## _`합계를 구하는 SUM함수`_
> 숫자,숫자로 암시적 형 변환이 가능한 데이터만 가능하다.
```
SUM([DISTINCT , ALL 둘중에 하나를 선택하거나 아무 값도 지정하지 않음(선택)]
    [합계를 구할 열이나 연산자,함수를 사용한 데이터(필수)])
```
> 합계를 구할 데이터를 지정합니다.   
여기서 COUNT(*)을 넣으면 속도가 저하되므로 확실한 PK값이 잇느걸로 세는게 좋다.   
        SELECT COUNT(ROWNUM) FROM EMPLOYEES; //이것도 가능하다.
<br>

`SUM함수를 분석용도로 사용한다면 다음과 같이 사용도 가능하다`
```
SUM([DISTINCT , ALL 둘중에 하나를 선택하거나 아무 값도 지정하지 않음(선택)]
    [합계를 구할 열이나 연산자,함수를 사용한 데이터(필수)])
OVER(분석을 위한 여러 문법을 지정)(선택)
```
> SUM함수는 NULL값은 제외하고 덧셈연산을 한다.   

```
SELECT SUM(DISTINCT SAL),
       SUM(ALL SAL),
       SUM(SAL),

SUM(DISTINCT) SUM(ALL SAL)    SUM
------------- ------------ -------
        24775        29025  209025
```
> DISTINCT는 중복값을 제외하고 연산을 한다, ALL과 미지정은 같은 결과   

## _`데이터 개수를 구해주는 COUNT함수`_
```
COUNT([DISTINCT,ALL 중 하나를 선택하거나 아무 값도 지정하지 않음(선택)]
      [개수를 구할 열이나 연산자,함수를 사용한 데이터(필수)])
OVER(분석을 위한 여러 문법 지정)(선택)
```
> COUNT 함수에 * 을 사용하면 SELECT문의 결과값으로 나온 행 데이터 개수를 반환   
> SUM과 마찬가지로 DISTINCT는 중복값을 제외하고 데이터 개수를 센다
```
SELECT COUNT(*)
FROM EMPLOYEES
WHERE MANAGER_ID = 1;

  COUNT(*)
----------
        14

--> 이렇게 하면 담당 매니저 ID가 1인 직원의 수를 알수있다.
```
1. SUM과 마찬가지로 DISTINCT를 넣으면 중복값은 제외하고 행의 개수를 센다
2. SUM과 마찬가지로 (arg)에 들어온 열에 null값은 제외하고 센다
3. NULL값을 세고싶다면 조건으로 넣어야한다.
   
## _`최댓값과 최솟값을 구하는 MAX,MIN함수`_

> 입력 데이터 중 최댓값과 최솟값을 반환하는 함수
```
MAX([DISTINCT,ALL 중 하나를 선택하거나 아무 값도 지정하지 않음(선택)]
    [최댓값을 구할 열이나 연산자,함수를 사용한 데이터(필수)])
OVER(분석을 위한 여러 문법 지정)(선택)

MIN도 같다.
```
```
SELECT MAX(SAL)
    FROM EMP;
    WHERE DEPTNO=10;
부서 번호가 10번인 사원들의 최대 급여 출력하기
```
`날짜 및 문자 데이터에서도 사용이 가능하다`
> 부서 번호가 20인 사원의 입사일중 최근 입사일 출력하기
```
    
FROM EMPLOYEES
WHERE HIRE_DATE=(SELECT MAX(HIRE_DATE) FROM EMPLOYEES);

```

## _`평균 값을 구하는 AVG함수`_   
> 숫자,숫자로 암시적 형 변환이 가능한 데이터만 가능하다.
```
AVG([DISTINCT , ALL 둘중에 하나를 선택하거나 아무 값도 지정하지 않음(선택)]
    [평균을 구할 열이나 연산자,함수를 사용한 데이터(필수)])
OVER(분석을 위한 여러 문법을 지정)(선택)
```
```
SELECT AVG(SAL)
    FROM EMP
    WHERE DEPTNO = 30;

//부서 번호가 30인 사원들의 평균 월급을 출력하시오

여기서 중복값을 제외하면

SELECT AVG(DISTINCT SAL)
    FROM EMP
WHERE DEPTNO = 30;

//값이 다르게 나온다.
```
