/*
숫자 함수

ABS(n) - 절대값을 구하는 함수
    SELECT ABS(35),ABS(-35) FROM DUAL;

SIGN(n) - 음수/양수를 알려주는 함수
    SELECT SIGN(35) , SIGN(-35), SIGN(0) FROM DUAL;
            // 1        //-1       //0
ROUND(n,i) - 숫자의 반올림값을 알려주는 함수
    SELECT ROUND(34.4),ROUND(34.5) FROM DUAL; //34 35
    SELECT ROUND(12.3454124,2),ROUND(12.364123,2) FROM DUAL; //12.35 12.36

MOD(n1,n2) 숫자의 나머지값을 반환하는 함수
    SELECT TRUNC(17/5) 몫, MOD(17,5) 나머지 FROM DUAL; // 3  2

숫자의 제곱을 구하는 함수와 제곱근을 구하는 함수 POWER(n1,n2)/SQRT(n)
    SELECT POWER(5,2),SQRT(25) FROM DUAL; // 25 5
*/ 