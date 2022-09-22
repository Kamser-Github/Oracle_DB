# 놓쳤던 부분 다시 짚어보기

### 추가 수당이 없는 사원의 추가 수당은 N/A로 변경
```
//틀린곳
SELECT
    EMPNO,
    ENAME,
    HIREDATE,
    TO_CHAR(NEXT_DAY(ADD_MONTHS(HIREDATE,3),'월요일'),'YYYY-MM-DD') AS R_JOB,
    //
    NVL(COMM,'N/A') AS COMM
    // 여기서 NVL 인자 두개는 타입이 같아야한다.
    // COMM의 타입은 NUMBER
    // 변환되는 타입은 CHAR
    // 타입이 불일치하므로
    // 실수를 했다.
    >> 변경후
    NVL(TO_CHAR(COMM),'N/A') AS COMM
FROM EMP;
```

### 문자열 함수는 문자열 데이터
```

```

### SELECT절의 * 사용
```
SELECT절에서 출력할 열을 * 로 표시한다면,
어떤 열이 어떤 순서로 출력될지 명시적으로 알수 없을뿐만아니라
특정 열이 생기거나 수정되었을 경우에는 그 변화를 찾기 어렵다
급하게 조회하려고 사용할때에는 유용하지만

프로그램내부에서는 명시적으로 열거하는게 좋다

SELECT E.EMPNO,E.NAME,E.JOB,E.MGR
       D.DNAME,D.LOC
    FROM EMP E,DEPT D
WHERE E.DEPTNO = D.DEPTNO
ORDER BY DEMPNO;
```
