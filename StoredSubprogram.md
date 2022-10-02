# 저장 서브 프로그램
> 익혀야하는 것
```
+ 프로시저 작성 및 사용 방법
+ 함수 작성 및 사용 방법
```
### `저장 서브프로그램이란`
```
여러번 사용할 목적으로 이름을 지정하여 오라클에 저장해 두는 PL/SQL

익명 블록(이름없는 PL/SQL)과 달리 저장 서브 프로그램은 오라클에 저장하여
공유가 가능하므로 , 메모리: 성능 :재사용성등 장점이 다양하다.

                        익명블록                저장서브프로그램
                        -------                 -------------
    이름                이름없음                 이름 지정
    오라클 저장         저장할수 없음            저장함
    컴파일              실행할 때마다 컴파일     저장할때 한 번 컴파일
    공유                공유할 수 없음           공유하여 사용 가능
다른 응용프로그램에서의  호출할수없음             호출가능
호출 가능여부
```
> 여러방식으로 저장 서브 프로그램을 구현
```
    서브프로그램                용도
        --                      --
    저장 프로시저       일반적으로 특정 처리 작업 수행을 위한 서브프로그램
 (stored procedure)     SQL문에서 사용 할 수 없다.
    저장 함수           일반적으로 특정 연산을 거친 결과 값을 반환하는 서브프로그램
 (stored function)      SQL문에서 사용 가능하다.
    패키지 
  (package)             저장 서브프로그램을 그룹화하는데 사용합니다.
    트리거              특정 상황(이벤트)이 발생했을때
  (trigger)             자동으로 연달아 수행할 기능을 구현하는 데 사용한다.
```

## 프로시저(stored procedure)
```
저장 프로시저는 특정 처리 작업을 수행하는 데 사용하는 저장 서브프로그램으로
용도에 따라 파라미터를 사용,미사용이 가능하다.

```
### `파라미터를 사용하지 않는 프로시저`
> 프로시저 생성하기
```
작업 수행에 별다른 입력 데이터가 필요하지 않을 경우에 사용

이미 저장된 프로시저의 소스 코드를 변경하고 싶을땐
CREATE OR REPLACE PROCEDURE [변경 프로시저]
    IS
    :

ALTER PROCEDURE은 프로시저의 소스코드내용을 재컴파일하는 명령어로
            작성한 코드 내용을 변경하지 않는다.
```
__형식__
```sql
CREATE [OR REPLACE] PROCEDURE 프로시저 이름
IS | AS
    선언부 := 변수 , 상수 , 커서 등을 선언할 수 있습니다.
BEGIN
    실행부
EXCEPTION
    예외 처리부
END [프로시저 이름];

[OR REPLACE] 동일 이름의 프로시저가 있으면 덮어쓴다.
EXCEPTION 예외 처리부는 생략이 가능하다.
END [프로시저 이름] 프로시저 이름도 생략이 가능하다.
```
_예_
```SQL
CREATE OR REPLACE PROCEDURE pro_noparam
IS
    V_NO NUMBER(4) := 7788;
    V_NAME VARCHAR2(10);
BEGIN
    V_NAME := 'KKAM';
    DBMS_OUTPUT.PUT_LINE('숫자 : '||V_NO);
    DBMS_OUTPUT.PUT_LINE('문자 : '||V_NAME);
END;
/
--java 매서드 중 함수형 인터페이스 Runable()과 비슷하다
--입력값도 없고 출력값도 없다.
Procedure PRO_NOPARAM이(가) 컴파일되었습니다.
```
>프로시저 실행하기
```
생성한 프로시저는 SQL*PLUS에서 실행하거나
다른 PL/SQL 블록안에서 실행이 가능하다.

바로 SQL문에서 실행할때
EXECUTE 프로시저 이름;
```
_예_
```
EXECUTE PRO_NOPARAM;
숫자 : 7788
문자 : KKAM
```
>PL/SQL문에서 프로시저 실행하기   
```SQL
PL/SQL문에서 이미 만들어진! 프로시저를 실행한다면
아래와 같이 실행부(BEGIN)문에 실행할 프로시저 이름을 정한다

BEGIN
    PRO_NOPARAM;
END;
    따로 저장한 순간부터 저렇게 사용이 가능하다.
/
```
_예_
```
BEGIN
    PRO_NOPARAM;
END;
/
```
> 프로시저 내용 확인하기
```
서브프로그램의 소스 코드 내용을 확인하려면

SELECT * FROM USER_SOURCE

    USER_SOURCE의 열                설명
        --  --                      --
        NAME                   서브프로그램(생성 객체)이름
        TYPE                   서브프로그램 종류(PROCEDURE,FUNCTION 등)
        LINE                   서브프로그래멩 작성한 줄 번호
        TEXT                   서브프로그램에 작성한 소스 코드
```
> 프로시저 삭제하기
```
DROP PROCEDURE PRO_NOPARAM;
```

### `파라미터를 사용하는 프로시저`
```
프로시저를 실행하기 위해 입력데이터가 필요한 경우에 파라미터를 정의할수 있다.
파라미터는 여러 개 작성할 수 있으며 다음과 같은 형식으로 사용한다.
```
> 기본 형식
```
CREATE [OR REPLACE] PROCEDURE 프로시저 이름
[
    (파라미터 이름1 [modes] 자료형 [:= | DEFUALT 기본값]),
    (파라미터 이름2 [modes] 자료형 [:= | DEFUALT 기본값]),
            :   <자료형 : 자리수 제한,NOT NULL 사용 불가>
    (파라미터 이름N [modes] 자료형 [:= | DEFUALT 기본값])
]
IS | AS < 선언부가 없어도 반드시 기재>
    선언부
BEGIN
    실행부
EXCEPTION
    예외 처리부
END [프로시저 이름](생략가능);
```
> [modes] 종류와 설명
```
파라미터 모드               설명
    --                      --
    IN             지정하지 않으면 기본값으로 프로시저를 호출할 때 값을 입력받는다.
    OUT            호출할 때 값을 반환한다.
    IN OUT         호출 할때 값을 입력받고 실행 결과 값을 반환한다.
```
> ## IN 파라미터
```
프로 시저 실행에 필요한 값을 입력받는 형식의 파라미터를 지정할때 IN을 사용
IN은 기본값이기 때문에 생략이 가능
```
_예_
```SQL
CREATE PROCEDURE PRO_IN 
(
    param1 IN NUMBER,
    param2 NUMBER,
    param3 NUMBER := 3,
    param4 NUMBER := 4
)
    IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('P1 : '||param1);
    DBMS_OUTPUT.PUT_LINE('P2 : '||param2);
    DBMS_OUTPUT.PUT_LINE('P3 : '||param3);
    DBMS_OUTPUT.PUT_LINE('P4 : '||param4);
END;
/
BEGIN
    PRO_IN(10,9,8,7);
    PRO_IN(8,7);
END;
/
/*
P1 : 10
P2 : 9
P3 : 8
P4 : 7
-- DEFAULT가 붙은건 입력을 안해도 된다.
P1 : 8
P2 : 7
P3 : 3
P4 : 4
*/
```
_예 : 파라미터 프로시저로 테이블 입력해보기)_
```SQL
--파라미터로 테이블에 값 입력해보기.
--EMP_TMP
CREATE TABLE EMP_TMP
AS SELECT EMPLOYEE_ID,FIRST_NAME
FROM EMPLOYEES;

CREATE PROCEDURE EMP_TMP_INSERT
(
    ID EMP_TMP.EMPLOYEE_ID%TYPE,
    NAME2 EMP_TMP.EMPLOYEE_ID%TYPE
)
IS
BEGIN
    INSERT INTO EMP_TMP VALUES(ID,NAME2);
    DBMS_OUTPUT.PUT_LINE('값 입력 완료');
END;
/

EXECUTE EMP_TMP_INSERT(21,'555');
--ERROR 발생 : PK 오류

--EXCEPTION 에러 처리 추가 
CREATE PROCEDURE EMP_TMP_INSERT
(
    ID EMP_TMP.EMPLOYEE_ID%TYPE,
    NAME2 EMP_TMP.EMPLOYEE_ID%TYPE
)
IS
    --DECLARE 대신
    PK_ERROR EXCEPTION;
    PRAGMA EXCEPTION_INIT(PK_ERROR,-1);
BEGIN
    INSERT INTO EMP_TMP VALUES(ID,NAME2);
    DBMS_OUTPUT.PUT_LINE('값 입력 완료');
EXCEPTION
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('에러발생');
--        DBMS_OUTPUT.PUT_LINE('SQLCORE : '||TO_CHAR(SQLCODE));
--        DBMS_OUTPUT.PUT_LINE('SQLERRM : '||TO_CHAR(SQLERRM));
      WHEN PK_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('에러발생');
END;
/
```
`인자개수나 타입이 일치하지 않으면 예외발생`
> 파라미터의 이름을 활용해서 프로시저에 대입   

_예_
```sql
CREATE PROCEDURE EMP_TMP_INSERT
(
    ID EMPLOYEES.EMPLOYEE_ID%TYPE,
    F_NAME EMPLOYEES.FIRST_NAME%TYPE
)
IS
    PK_ERR EXCEPTION;
    PRAGMA EXCEPTION_INIT(PK_ERR,-1);
BEGIN
    INSERT INTO EMP_TMP VALUES (ID,F_NAME);
EXCEPTION
    WHEN PK_ERR THEN
        DBMS_OUTPUT.PUT_LINE('키 오류'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE('키 오류'||SQLERRM);
END;
/
EXECUTE EMP_TMP_INSERT(F_NAME=>'고릴라',ID=>1);

--파라미터 이름을 직접 명시해서 값을 넣어줄수 있다.
```
> ### 파라미터에 값을 넣는 세가지 방법
```
    종류        설명
    --           --
  위치지정      지정한 파라미터 순서대로 값을 지정하는 방식
  이름지정      => 연산자로 파라미터 이름을 명시하여 값을 지정하는 방식
  혼합지정      일부는 순서대로,일부 파라미터는 => 연산자로 값을 지정
```

> ## OUT모드 파라미터
```
OUT 모드를 사용한 파라미터는 프로시저 실행 후 
호출한 프로그램으로 값을 반환한다.
```
__OUT 프로시저 생성__
```SQL
CREATE OR REPLACE PROCEDURE PRO_OUT
(
    in_no EMPLOYEES.EMPLOYEE_ID%TYPE,
    OUT_NAME OUT EMPLOYEES.FIRST_NAME%TYPE,
    OUT_DATE OUT EMPLOYEES.HIRE_DATE%TYPE
)
IS
BEGIN
    SELECT FIRST_NAME,HIRE_DATE INTO OUT_NAME,OUT_DATE
        FROM EMPLOYEES
    WHERE EMPLOYEE_ID = in_no;
END PRO_OUT;
/
```
__OUT 프로시저 파라미터 사용__
```sql
DECLARE
    p_name employees.first_name%TYPE;
    p_date employees.HIRE_DATE%TYPE;
    input_id employees.employee_id%TYPE;
BEGIN
    input_id := &INPUT_ID;
    PRO_OUT(input_id,p_name,p_date);
    DBMS_OUTPUT.PUT_LINE(input_id||'번 직원');
    DBMS_OUTPUT.PUT_LINE('이름 : '||p_name);
    DBMS_OUTPUT.PUT_LINE('입사 날짜 : '||p_date);
END;
/
```
> ### IN OUT 프로시저 파라미터 사용
```

```
__IN OUT 프로시저 생성__
```SQL
CREATE OR REPLACE PROCEDURE PRO_INOUT
(
    NUM IN OUT NUMBER 
)
IS
    BEGIN
        NUM := NUM * 2;
    END PRO_INOUT;
/
```
__IN OUT 프로시저 사용__
```SQL
DECLARE
    P_NUM NUMBER;
BEGIN
    P_NUM := 5;
    PRO_INOUT(P_NUM);
    DBMS_OUTPUT.PUT_LINE('P_NUM: '||P_NUM);
END;
/
P_NUM: 10
```
