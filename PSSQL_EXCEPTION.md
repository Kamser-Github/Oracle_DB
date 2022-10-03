## 오류가 발생해도 프로그램이 비정상종료가 되지 않도록 하는 예외처리

### `오류란?`
```
오라클에서 SQL,PL/SQL이 정상 수행되지 못하는 상황을 오류(error)라고 한다.

1-1.컴파일 오류(compile error)
1-2.문법 오류(syntax error)

2-1.런타임 오류(runtime error)
2-2.실행 오류(execute error)

프로그램이 실행되는중 발생한 오류를 예외(exceptoin)이라 하고 
    2번에 해당된다.
```
_예_
```SQL
DECLARE
    v_num NUMBER;
BEGIN   
    SELECT FIRST_NAME INTO v_num
        FROM EMPLOYEES
    WHERE EMPLOYEE_ID=1;
END;
/
/*
ORA-06502: PL/SQL: 수치 또는 값 오류: 
                문자를 숫자로 변환하는데 오류입니다
*/
```
_처리방법_
```SQL
DECLARE
    v_num NUMBER;
BEGIN   
    SELECT FIRST_NAME INTO v_num
        FROM EMPLOYEES
    WHERE EMPLOYEE_ID=1;
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('예외 처리: 수치 또는 값 오류발생');
END;
/
--예외 처리: 수치 또는 값 오류발생
```
`예외 발생지점 뒤에는 실행이 되지 않고 멈춘다.`
```SQL
DECLARE
    v_num NUMBER;
BEGIN   
    SELECT FIRST_NAME INTO v_num
        FROM EMPLOYEES
    WHERE EMPLOYEE_ID=1;
    --에러 발생 아래 지점은 실행이 안된다.break느낌으로
    DBMS_OUTPUT.PUT_LINE('에러발생뒤는 실행이 안된다.');
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('예외 처리: 수치 또는 값 오류발생');
END;
/
```
### `예외 종류`
`예외 종류는 내부 예외 ,사용자 정의 예외`
```
+ 내부 예외란 ?
    오라클에서 미리 정한 예외를 뜻하며
        1.이름이 정해진 예외
        2.이름이 정해지지 않은 예외
+ 사용자 정의란 ?
    사용자가 필요에 따라 추가로 정의한 예외를 말한다.
```
> 예외 중에 ORA-XXXXXX인 예외는 예외 처리부에서 이름을 붙여 사용한다.

### `예외 처리부 작성`
```SQL
--WHEN으로 시작하는 절을 예외핸들러(exception handler)
--발생한 예외 이름과 일치하는 WHEN절중 하나만! 실행이 된다.
--OTHERS는 먼저 작성한 예외랑 일치하는 경우가 없을때 실행.
```
_예1- 사전 정의된 예외처리_
```SQL
DECLARE
    v_wrong NUMBER;
BEGIN
    SELECT FIRST_NAME INTO v_wrong
        FROM EMPLOYEES
    WHERE EMPLOYEE_ID=10;
    
    DBMS_OUTPUT.PUT_LINE('예외가 발생하면 이 문장은 실행안된다');
EXCEPTION
    WHEN TOO_MANY_ROWS  THEN
        DBMS_OUTPUT.PUT_LINE('예외 처리 : 요구보다 많은 행이 추출 오류');
    WHEN VALUE_ERROR    THEN
        DBMS_OUTPUT.PUT_LINE('예외 처리 : 수치 또는 값 오류 발생');
    WHEN OTHERS         THEN
        DBMS_OUTPUT.PUT_LINE('예외 처리 : 사전 정의 외 오류 발생');
    END;
/
```

_예2- 이름없는 예외 사용_
```SQL
/*
이름이 없는 내부 예외를 사용해야한다면 직접 이름을 지어줘야한다.
이름이 정해진 예외는 사전 정의된 예외를 사용할때마다 마찬가지로
예외 처리부에서 지정한 이름으로 예외 핸들러에 작성한다.
*/
DECLARE
    예외 이름1 EXCEPTION;
    PRAGMA EXCEPTION_INIT(예외이름1,예외 번호);
        :
EXCEPTION
    WHEN 예외 이름1 THEN
        예외 처리에 사용할 명령어;
           :
END;
```
_예3- 사용자 정의 예외 사용_
```SQL
/*
오라클에 정의되어 있지 않는 특정 상황을 직접 오류로 정의하는 방식
RAISE키워드를 사용해 예외를 직접 만들수 있다.
직접 만든 예외 역시 앞에 예외 처리와 마찬가지로
예외 처리부에서 예외 이름을 통해 수행할 내용을 작성하여 처리한다.
*/
DECLARE
    사용자 예외 이름 EXCEPTION;
           :
BEGIN
    IF 사용자 예외를 발생시킬 조건 THEN
        RAISE 사용자 예외 이름
        :
    END IF;
EXCEPTION
    WHEN 사용자 예외 이름 THEN
        예외 처리에 사용할 명령어;
        :
END;
/
```
### __raise_application_error__
```
사용자 정의 오류를 발생시킬수 있는 명령어
이걸 사용하면 처리되지 않은 예외를 반환하는 대신
호출자에게 오류를 보고할 수 있다.

실행이되면 현재 블록 실행을 즉시 중지되고
OUT 또는 IN OUT 매개변수에 대한 변경사항을 되돌린다.

패키지변수와 같은 전역 데이터 구조 및 테이블과 같은
데이터베이스 개체에 대한 변경 사항은 롤백되지 않는다.
DML의 효과를 되돌리려면 ROLLBACK을 명시적으로 작성한다.
```
> 기본 구문
```SQL
raise_application_error(
    error_number, 
    message --message 최대길이 2048byte
            --한글로는 680자
    [, {TRUE | FALSE}]
    --FALSE 오류가 이전 모든 오류를 대체
    --TRUE면 이전 오류 스택에 추가된다.
);
--continue 같은 느낌
EX)raise_application_error(
    -20100,
    'Cannot update customer credit from 28th to 31st'
);
```


> 오류 코드와 오류 메세지 사용
```
오류 처리부가 잘 작성이 되어있다면 PL/SQL은 정상 종료된다.
PL/SQL의 정상 종료와 상관없이 발생한 오류 내역이 알고 싶을때 사용한다.

    함수        설명
    ---         ---
  SQLCODE      오류 코드를 반환하는 함수
  SQLERRM      오류 메세지를 반환하는 함수

```
`SQLCODE,SQLERRM은 PL/SQL에서만 사용이 가능하다`


_예_
```sql
DECLARE
    v_wrong NUMBER;
BEGIN
    SELECT FIRST_NAME INTO v_wrong
     FROM EMPLOYEES
    WHERE EMPLOYEE_ID=1;
    
    DBMS_OUTPUT.PUT_LINE('여기가 실행이 되나요?');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외 처리 : 오류 발생');
        DBMS_OUTPUT.PUT_LINE('SQLCODE : '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE('SQLERRM : '||SQLERRM);
END;
/

예외 처리 : 오류 발생
SQLCODE : -6502
SQLERRM : ORA-06502: PL/SQL: 수치 또는 값 오류: 문자를 숫자로 변환하는데 오류입니다
```