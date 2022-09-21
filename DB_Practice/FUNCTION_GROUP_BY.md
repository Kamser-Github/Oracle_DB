## 결과 값을 원하는 열로 묶어서 출력
# GROUP BY절   
```
다중행 함수는 지정 테이블의 데이터를 가공하여 하나의 결과 값만 출력한다.
부서 번호별로 급여,사원수,평균등을 구하기 위해선 하나하나 제작을 해야한다.

SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 10;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 20;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 30;
                    :
```
> UNION으로도 해결이 된다.
```
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 10
UNION ALL
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 20
UNION ALL
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 30;
```
> 한눈에 보기도 번거롭고,특정부서를 삭제하거나 추가할때마다   
> SQL문을 수정해야하므로 바람직하지가 않다.   

## _`GROUP BY절 기본 사용법`_
```
여러 데이터에서 의미 있는 하나의 결과를 특정 열 값별로 묶어서 출력할때
데이터를 "그룹화"한다고 표현한다.
SELECT문에서는 GROUP BY절을 작성하여
데이터를 그룹화 할수있는데 다음과 같이 순서에 맞게 작성해야하고
"그룹으로 묶을 기준 열을 지정한다"
```
```
SELECT  [조회할 열 1 이름],[열2 이름], ... ,[열N 이름]
FROM    [조회할 테이블 이름]
WHERE   [조회할 행을 선별하는 조건식]
GROUP BY [그룹화할 열을 지정(여러 개 지정 가능)] <<(1)>>
ORDER BY [정렬하려는 열 지정]
```
### __`먼저 지정한 열로 대 그룹을 나누고 그 다음 지정한 열로 소 그룹을 나눕니다`__   
```
각 부서의 직책별 평균 급여를 알고 싶을때
SELECT DEPTNO, JOB , AVG(SAL)
    FROM EMP
GROUP BY DEPTNO, JOB
OREDER BY DETPTNO, JOB;

>> 그룹을 먼저 부서번호로 나뉜후 거기서 다시 직책으로 그룹을 묶는다.
>> 정렬도 마찬가지로 먼저 부서명을 오름차순으로 정렬하고
    부서명이 동일하면 직책명으로 오름차순으로 정렬한다.
```

### __`다중행 함수를 사용하지 않은 일반 열은`__
### __`GROUP BY절에 명시하지 않으면 SELECT절에서 사용할수가 없다.`__
```
SELECT ENAME,DEPTNO,AVG(SAL)
    FROM EMP
GROUP BY DEPTNO;

//에러발생

마찬가지로 일반 열을 출력할때 SELECT 절에 다중행 함수를 못쓰듯이,
GROUP BY로 묶은 열은 출력할때 SELECT 절에 단일행 함수나 열을 못쓴다.
```

## GROUP BY절에 조건을 줄때 사용하는
# HAVING 절

> HAVING절은 GROUP BY절이 있을때만 사용이 가능하다.   
> ### 그룹화된 결과 값의 범위를 제한하는데 사용한다.   
```
SELECT DEPTNO,JOB,AVG(SAL)
    FROM EMP
GROUP BY DEPTNO,JOB
    HAVING AVG(SAL) >= 2000
ORDER BY DEPTNO,JOB;

HAVING절이 없다면
그룹화된 결과에 평균값이 추가된 테이블이 출력되지만

HAVING절이 추가되면
그룹화된 결과에 조건이 만족하는 다중행만 출력된다.
```
> HAVING절 기본 사용법.   
```
SELECT  [조회할 열 1 이름],[열2 이름], ... ,[열N 이름]
FROM    [조회할 테이블 이름]
WHERE   [조회할 행을 선별하는 조건식]
GROUP BY [그룹화할 열을 지정(여러 개 지정 가능)]
HAVING  [출력 그룹을 제한하는 조건식]
ORDER BY [정렬하려는 열 지정]
```
`GROUP BY,HAVING은 별칭을 사용할수없다.`

### __`WHERE절은 출력 대상 행을 제한하고`__
### __`HAVING절은 그룹화된 대상을 출력에서 제한한다.`__

## WHERE절과 HAVING절의 차이점
```
SELECT DEPTNO , JOB , AVG(SAL)
    FROM EMP
  WHERE SAL<=3000
GROUP BY DEPTNO,JOB
    HAVING AVG(SAL) >= 2000
ORDER BY DEPTNO,JOB;

**중요
    SELECT 구절에서 실행되는 순서
    1. FROM절 실행 결정된 별칭이 모든곳에서 사용된다.
    2. CONNECT BY
    3. WHERE
    4. GROUP BY
    5. HAVING
    6. SELECT 에서 별칭을 만든건 위에 있는곳에서 사용을 할수가없다.
    7. ORDER BY

따라서 HAVING에서 나오는 조건은 WHERE에서 사용할수가 없다.
```
