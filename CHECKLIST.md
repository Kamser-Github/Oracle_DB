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
