# 함수
> 함수와 프로시저의 차이점
```
 특징               프로시저                        함수
 --                   ---                           --
 실행           EXECUTE 명령어,                 변수를 사용한 EXECUTE 명령어
                PL/SQL서브프로그램내에서 호출   다른 PL/SQL 서브프로그램,SQL문
파라미터 지정      IN, OUT, IN OUT                  IN
값의 반환     값이 없을수도있고 모드에따라다름   반드시 하나의 값,RETURN을 통해
```
 __`큰 차이:SQL문에서 사용가능,RETURN 절,문으로 반드시 반환값 있어야한다`__

### `함수 생성하기`
> 실행부의 RETURN문이 실행시 함수 실행은 종료됨.
```SQL

CREATE [OR REPLACE] FUNCTION 함수이름
[(
    파라미터 이름1 [IN] 자료형1,
    파라미터 이름2 [IN] 자료형2,
                :
    파라미터 이름N [IN] 자료형N,
)]
RETURN 자료형
IS | AS
    선언부
BEGIN
    실행부
    RETURN (반환값);
EXCEPTION
    예외 처리부
END [함수이름];
/
```
_예_
```SQL
CREATE OR REPLACE FUNCTION f_test
(
    SAL IN NUMBER
)
RETURN NUMBER
IS
    tax NUMBER := 0.05;
BEGIN
    RETURN (ROUND(SAL - (SAL*tax)));
END f_test;
/
--IS위에 RETURN 타입과
--실행부 RETURN 결과값의 타입은 일치해야한다.

--PL/SQL에서 사용하려면 값을 받을 변수도 필요하다
--변수도 RETURN타입과 일치해야한다.
```
### `함수 실행하기`
1. PL/SQL로 함수 실행하기
    ```SQL
    DECLARE
        p_sal NUMBER;
        pram NUMBER;
    BEGIN
        pram := &INPUT_SAL;
        p_sal := f_test(pram);
        DBMS_OUTPUT.PUT_LINE('세금 제외 월급 : '||p_sal);
    END;
    /
    ```
2. SQL문에서 함수 실행하기
    ```SQL
    SELECT f_test(35000) FROM DUAL;
    F_TEST(35000)
    -------------
        33250
    ```
3. 함수에 테이블 데이터 사용하기
    > 함수 파라미터와 자료형이 일치하면 가공된 데이터 입력이 가능하다.
    ```sql
    SELECT PRODUCT_ID,SUBSTR(PRODUCT_NAME,0,10) AS NAME,LIST_PRICE,f_test(list_price) AS 세금제외 FROM PRODUCTS;

    PRODUCT_ID NAME       LIST_PRICE   세금제외
    ---------- ---------- ---------- ----------
       228 Intel Xeon    3410.46       3240
       248 Intel Xeon    2774.98       2636
       249 Intel Xeon    2660.72       2528
         2 Intel Xeon    2554.99       2427
        45 Intel Xeon    2501.69       2377
        46 Intel Xeon    2431.95       2310
        47 Intel Xeon    2377.09       2258
        51 Intel Xeon    2269.99       2156
        91 Intel Xeon    2259.99       2147
        92 Intel Xeon       2200       2090
    
    ```
### `함수 삭제`
```SQL
DROP FUNCTION f_test;
```