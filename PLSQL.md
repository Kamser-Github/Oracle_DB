# PL/SQL
```
SQL만으로 구현이 어렵거나 구현이 불가능한 작업을   
수행하기 위해 오라클에서 제공하는 프로그래밍 언어   
```
> 익혀야하는것
```
+ 블럭 구조
+ 변수 선언 방법
+ IF 조건문 사용 방법
+ 반복문 사용 방법
```
<br><br>

## PL/SQL 구조
### `블록이란?`
```
PL/SQL은 데이터베이스 관련 특정 작업을 수행하는 명령어와
실행에 필요한 여러 요소를 정의하는 명령어등으로 구성
이런 명령어를 모아둔 PL/SQL 프로그램의 기본단위를 블록(Block)이라한다
```
> -
```
    구성키워드      필수/선택           설명
    --  --  -       --  --              --
  DECLARE(선언부)     선택        실행에 사용될 변수.상수.커서 등을 선언
  BEGIN(실행부)       필수        조건문,반복문,SELECT,DML,함수등을 정의
EXCEPTION(예외처리부) 선택        PL/SQL 실행 도중 발생하는 오류(예외 상황)을 해결하는 문장기술
```
> 기본형식
```
DECLARE(선택)
    [실행에 필요한 여러 요소 선언];
BEGIN(필수)
    [작업을 위해 실제 실행하는 명령어];
EXCEPTION(선택)
    [PL/SQL 수행 도중 발생하는 오류 처리];
END;
```
> 예
```
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO,PL/SQL');
END;
/
HELLO,PL/SQL
PL/SQL 프로시저가 성공적으로 완료되었습니다.
```
> 주의사항
```
SET SERVEROUTPUT ON;
    새 새션이 시작될때마다 작성을 해야 PL/SQL 결과를 볼수있다.

1.PL/SQL 블럭을 구성하는
     DECLARE,BEGIN,EXCEPTION 키워드에는 세미콜론을 사용하지 않는다.
2.PL/SQL 블럭의 각 부분에서 실행해야 하는 문장의 끝에는 세미콜론을 사용한다
    ex)DBMS_OUTPUT.PUT_LINE('HELLO,PL/SQL');
3.PL/SQL문 내부에서 한 줄 주석(--)과 여러 줄 주석(/* */)을 사용할수 있다.
4.PL/SQL문 작성을 마치고 실행하기위해 마지막에 슬래시(/)를 사용한다.
```

## 변수와 상수
### `변수 선언과 값 대입하기`
```
변수는 데이터를 일시적으로 저장하는 요소로 이름과 저장할 자료형을 지정
선언부(DECLARE)에서 작성한다,선언부에서 작성한 변수는 실행부(BEGIN)에서 사용
```
> 기본 변수 선언과 사용
```
변수 이름 자료형 := 값 또는 값이 도출되는 여러 표현식;

:= 값 또는 값이 도출되는 여러 표현식
위 부분은 생략이 가능하다. 선언만하는 경우
```
> 예
```
DECLARE
    V_EMPNO NUMBER(4) := 7788;
    V_NAME NVARCHAR2(10);
BEGIN
    V_NAME := 'OT';
    DBMS_OUTPUT.PUT_LINE('V_EMPNO :'||V_EMPNO);
    DBMS_OUTPUT.PUT_LINE('V_NAME :'||V_NAME);
    --java에서 데이터끼리 연결할때 +를 쓰듯이
    --Oracle DB에서는 ||를 사용한다.
END;
/
--
V_EMPNO :7788
V_NAME :OT

PL/SQL 프로시저가 성공적으로 완료되었습니다.
```
> 상수 정의하기
```
저장한 값이 필요에 따라 변수와 달리 
    상수(constant)는 한번 저장한 값이
    프로그램이 종료될때까지 유지되는 저장 요소이다.
```
> 기본 형식
```
변수이름 CONSTANT 자료형 := 값또는 값을 도출하는 여러 표현식 ;

나머지는 변수와 동일하지만 차이점하나는

한번 저장한 값은 변경되지 않는다.
```
> 값을 변경할 경우 예시
```
DECLARE
    V_EMPNO CONSTANT NUMBER(4) := 7788;
    V_NAME NVARCHAR2(10) := 'CAT';
BEGIN
    V_NAME := 'OT';
    DBMS_OUTPUT.PUT_LINE('V_EMPNO :'||V_EMPNO);
    DBMS_OUTPUT.PUT_LINE('V_NAME :'||V_NAME);
END;
/
// 가능하다.

//상수 선언후 재할당 경우
DECLARE
    V_EMPNO CONSTANT NUMBER(4) := 7788;
    V_NAME NVARCHAR2(10) := 'CAT';
BEGIN
    V_NAME := 'OT';
    V_EMPNO := 8888;
    DBMS_OUTPUT.PUT_LINE('V_EMPNO :'||V_EMPNO);
    DBMS_OUTPUT.PUT_LINE('V_NAME :'||V_NAME);
END;
/

오류 보고 -
ORA-06550: 줄 6, 열5:PLS-00363: 'V_EMPNO' 식은 피할당자로 사용될 수 없습니다
ORA-06550: 줄 6, 열5:PL/SQL: Statement ignored

라고 나온다.
```
> 변수의 기본값 지정하기
```
DEFAULT 키워드는 변수에 저장할 기본값을 지정한다.

변수이름 자료형 DEFAULT 값 또는 값이 도출되는 여러 표현식;
```
> >예
```
DECLARE
    V_EMPNO CONSTANT NUMBER(4) := 7788;
    V_NAME NVARCHAR2(10) DEFAULT 'CAT';
BEGIN
    DBMS_OUTPUT.PUT_LINE('V_EMPNO :'||V_EMPNO);
    DBMS_OUTPUT.PUT_LINE('V_NAME :'||V_NAME);
END;
/
-
V_EMPNO :7788
V_NAME :CAT
```
> 변수에 NULL값 저장 막기
```
특정 변수에 NULL이 저장되지 않게 하려면 NOT NULL 키워드 사용
PL/SQL에서 선언한 변수는 특정 값을 할당하지 않으면 기본 NULL로 초기화된다.

SQL 제약 조건과 비슷하게
NOT NULL 키워드를 사용할 경우 값을 할당해줘야한다,DEFAULT도 가능
```
>> 기본 형식
```
변수 이름 자료형 NOT NULL (:= 또는 NOT NULL) 값또는 값이 도출되는 여러 표현식;
```
_예시_
```
DECLARE
    V_NAME VARCHAR2(15) NOT NULL := 'NOT NULL';
BEGIN   
    DBMS_OUTPUT.PUT_LINE('V_NAME :'|| V_NAME);
END;
/

V_NAME :NOT NULL

PL/SQL 프로시저가 성공적으로 완료되었습니다.
```
> 변수 이름 정하기   

`PL/SQL문에서 지정하는 객체 이름을 식별자(identifier)라 한다`
```
규칙
1. 같은 블록 안에서 식별자는 고유해야하며 중복이 될수없다
2. 대소문자는 구별하지 않는다.
3. 테이블과 이름 규칙이 같다.
```
### `변수의 자료형`
```
변수에 저장할 데이터가 어떤 종류인지 특징 짓기 위해 사용하는 자료형
▶ 스칼라(scalar)
▶ 복합(composite)
▶ 참조(reference)
▶ LOB(Large OBject)
```
> 스칼라형
```
스칼라형 (scalar type)
숫자,문자열,날짜 오라클에서 제공하는 기본 자료형으로 단일값을 의미
> 프로그래밍 언어에서 primitive type과 유사

    분류    자료형                  설명
    ---     -----                   --
    숫자    NUMBER      소수점을 포함할 수 있는 최대 38자리 숫자 데이터
    문자열  CHAR        최대 32,767바이트 고정 길이 문자열 데이터
            VARCHAR2    최대 32,767바이트 가변 길이 문자열 데이터
    날짜    DATE        기원전 4712년 1월 1일부터 서기 9999년 12월 31일까지
    논리    BOOLEAN     PL/SQL에서만 사용할수있는 
                            논리 자료형 true,false,NULL을 포함
```
> 참조형
```
참조형(reference type)
오라클 데이터 베이스에 존재하는 
    특정 테이블의 열의 자료형이나 하나의 행구조를 참조하는 자료형을 말한다.
    -
열을 참조 %TYPE
행을 참조 %ROWTYPE
    -
```
>> 열을 참조 %TYPE   

`%TYPE로 선언한 변수는 지정한 테이블 열과 완전히 같은 자료형이 된다.`
```
구조 : 변수 이름 테이블이름.열이름 %TYPE;
```
_예_  
``` 
DECLARE
    V_DEPTNO DEPT.DEPTNO%TYPE := 50;
BEGIN
    DBMS_OUTPUT.PUT_LINE('V_DEPTNO :'||V_DEPTNO);
END;
/
```

>> 행을 참조 %ROWTYPE   

`변수 내부는 해당 행이 가지고 있는 열이름을 필드로 갖는다`
```
구조 : 변수이름 테이블 이름%ROWTYPE;
```
> 테이블 이름에 올수 있는것
1. 테이블 이름
2. 커서명
3. 뷰
- 서브쿼리는 안된다.


```
DECLARE
    MANAGER VIP_GRADE%ROWTYPE;
BEGIN
    SELECT GRADE,LOW_LIMIT,HIGH_LIMIT INTO MANAGER
        FROM VIP_GRADE
    WHERE GRADE = 1;
    DBMS_OUTPUT.PUT_LINE('GRADE : '||MANAGER.GRADE);
    DBMS_OUTPUT.PUT_LINE('LOW : '||MANAGER.LOW_LIMIT);
    DBMS_OUTPUT.PUT_LINE('HIGH : '||MANAGER.HIGH_LIMIT);
END;
/
```
` 주의 사항 `
```
DECLARE
    MANAGER VIP_GRADE%ROWTYPE;
BEGIN
           (      A      )      (             B               )
    SELECT GRADE,LOW_LIMIT INTO MANAGER.GRADE,MANAGER.LOW_LIMIT
        FROM VIP_GRADE
    WHERE GRADE = 1;
    DBMS_OUTPUT.PUT_LINE('GRADE : '||MANAGER.GRADE);
    DBMS_OUTPUT.PUT_LINE('LOW : '||MANAGER.LOW_LIMIT);
END;
/

DECLARE
    MANAGER VIP_GRADE%ROWTYPE;
BEGIN
    SELECT * INTO MANAGER
        FROM VIP_GRADE
    WHERE GRADE = 1;
    DBMS_OUTPUT.PUT_LINE('GRADE : '||MANAGER.GRADE);
    DBMS_OUTPUT.PUT_LINE('LOW : '||MANAGER.LOW_LIMIT);
    DBMS_OUTPUT.PUT_LINE('LIMIT : '||MANAGER.HIGH_LIMIT);
END;
/

절차 : 
    1.MANAGER 변수를 VIP_GRADE 테이블 행 구조로 선언한다.
      MANAGER 변수는 내부에 테이블 행 속성과 자료형이 필드로 들어온다.
    2.INTO MANAGER를 하면 SELECT 무느이 결과를 MANAGER에 대입을 한다
      따라서 SELECT에서 가져온 변수개수와 MANAGER가 가져온 변수의 개수가 같아야한다.

      즉 MANAGER 옆에 특정 필드를 지정하지 않으면
      MANAGER는 참조하는 VIP_GRADE의 속성을 다 가지고 있는 상태이고
      SELECT에서 조회한 결과를 MANAGER에 담기때문에
      자료형과 개수가 일치해야된다는것이다.

<<추가 수정 예정>>
```

## 조건 제어문
```
특정 조건식을 통해 상황에 따라 실행할 내용을 달리하는 방식
```

### `IF 조건문`
```
    종류                설명
    ---                 ---
  IF-THEN           특정 조건을 만족하는 경우 작업 수행
  IF-THEN-ELSE      특정 조건을 만족하는 경우와 아닌경우 각각 수행
 IF-THEN-ELSIF      여러 조건에 따라 각각 지정한 작업 수행
```
>IF-THEN
```
IF 조건식 THEN
    수행할 명령어;
END IF;

+ 조건식 : 여러 연산자 및 함수를 사용가능
+ 수행할 명령어 : 여러 명령어 지정가능
```
_예_   
```
DECLARE
    MANAGER EMPLOYEES%ROWTYPE;
BEGIN 
    SELECT * INTO MANAGER
        FROM EMPLOYEES
    WHERE EMPLOYEE_ID=10;
    IF MANAGER.MANAGER_ID=9 THEN
        DBMS_OUTPUT.PUT_LINE('매니저가 맞습니다');
    END IF;
END;
/
매니저가 맞습니다

PL/SQL 프로시저가 성공적으로 완료되었습니다.
```
> IF-THEN-ELSE
```
IF 조건식 THEN
    수행할 명령어(true) ;
ELSE
    수행할 명령어(false) ;
END IF;
```
_예_   
```
DECLARE
    V_NUMBER NUMBER(2) := 15;
BEGIN
    IF MOD(V_NUMBER,2)=1 THEN
        DBMS_OUTPUT.PUT_LINE('홀수');
    ELSE
        DBMS_OUTPUT.PUT_LINE('짝수');
    END IF;
END;
/
홀수

PL/SQL 프로시저가 성공적으로 완료되었습니다.
```

>IF-THEN-ELSIF
```
IF 조건식1 THEN
    조건식 1이 true일때 수행할 명령어 1;
ELSIF 조건식2
    조건식 2이 true일때 수행할 명령어 2;
ELSIF 조건식3
    조건식 3이 true일때 수행할 명령어 3;
ELSE
    조건식1,2,3가 false일때 수행할 명령어 4;
```
_예_
```
SET SERVEROUTPUT ON;
DECLARE
    V_NUMBER NUMBER := 99;
BEGIN
    IF V_NUMBER > 90 THEN
        DBMS_OUTPUT.PUT_LINE('A');
    ELSIF V_NUMBER >80 THEN
        DBMS_OUTPUT.PUT_LINE('B');
    ELSE
        DBMS_OUTPUT.PUT_LINE('C');
    END IF;
END;
/
A

PL/SQL 프로시저가 성공적으로 완료되었습니다.

자주 잊게 되는것
    END IF;
END;
/
```

### `CASE 조건문`   
```
    종류                설명
    ---                 ---
단순 CASE        비교 기준이 되는 조건의 값이 여러가지 일때
                 해당 값만 명시하여 작업수행
검색 CASE        특정한 비교 기준 없이 여러 조건식을 나열하여
                 조건식에 맞는 작업수행
```
>단순 케이스
```
비교 기준(여러 가지 결과 값이 나올 수 있는)이 되는 변수
또는 식을 명시한다. 그 결과 값에 따라 수행할 작업을 지정

그냥 CASE문과 비슷하다.
```
_형식_
```
CASE 비교 기준
    WHEN '값1' THEN
        비교기준='값1' 수행할 명령어;
    WHEN '값2' THEN
        비교기준='값2' 수행할 명령어;
      :              :
    ELSE
        비교기준과 다를경우 수행할 명령어;
END CASE;
```
_예_
```
DECLARE
    PRICE_LIST PRODUCTS%ROWTYPE;
BEGIN
    SELECT * INTO PRICE_LIST
        FROM PRODUCTS
    WHERE PRODUCT_ID=13;
    CASE ROUND(PRICE_LIST.STANDARD_COST,-2)
        WHEN 500 THEN 
            DBMS_OUTPUT.PUT_LINE('싼데?');
        WHEN 600 THEN
            DBMS_OUTPUT.PUT_LINE('그럭저럭?');
        WHEN 700 THEN
            DBMS_OUTPUT.PUT_LINE('정가인듯');
        WHEN 800 THEN
            DBMS_OUTPUT.PUT_LINE('비싸!!');
    END CASE;
END;
/
//저 물건 값을 십의자리에서 반올림하면 600이다.

그럭저럭?
PL/SQL 프로시저가 성공적으로 완료되었습니다.
```
> 검색 CASE
_형식_
```
    CASE
        WHEN 조건식1 THEN
            조건식1이 true일 경우 실행할 명령어1;
        WHEN 조건식2 THEN
            조건식2이 true일 경우 실행할 명령어2;
        WHEN 조건식3 THEN
            조건식3이 true일 경우 실행할 명령어3;
        ELSE
            조건식1,2,3이모두 FALSE일때 실행할 명령어4;
    END CASE;
END;
/
```
_예_   
```
DECLARE
    PRODUCT_PRICES PRODUCTS%ROWTYPE;
    ITEM_PRICE NUMBER(4);
BEGIN
    SELECT STANDARD_COST INTO PRODUCT_PRICES.STANDARD_COST
        FROM PRODUCTS
    WHERE PRODUCT_ID=13;
    ITEM_PRICE := PRODUCT_PRICES.STANDARD_COST;
    CASE
        WHEN ITEM_PRICE<500 THEN DBMS_OUTPUT.PUT_LINE('최저가');
        WHEN ITEM_PRICE<600 THEN DBMS_OUTPUT.PUT_LINE('중저가');
        WHEN ITEM_PRICE<700 THEN DBMS_OUTPUT.PUT_LINE('정가');
        ELSE
            DBMS_OUTPUT.PUT_LINE('너무 비쌈');
    END CASE;
END;
/
```
## 반복 제어문
> 특정 작업을 반복하여 수행하고자 할때 사용
```
        종류            설명
        ---             ---
    기본 LOOP       기본 반박문
    WHILE LOOP      반복 종료를 위한 조건식을 지정하고 만족하면 종료
    FOR LOOP        반복 횟수를 정하여 반복수행
  Cusor FOR LOOP    커서를 활용한 반복수행
```
> 보조 제어문
```
    종료                설명
    ---                 ---
    EXIT            수행 중인 반복 종료
  EXIT-WHEN         반복 종료를 위한 조건식을 지정하고 만족하면 반복 종료
  CONTINUE          수행 중인 반복의 현재 주기를 건너뜀
 CONTINUE-WHEN      특정 조건식을 지정하고 조건식을 만족하면 현재 반복 주기를 건너뜀
```
### `기본 LOOP`
> 형식
```
LOOP
    반복 수행 작업;
END LOOP;

기본 반복문은 반복 종료시점이나 조건식이 따로 없으므로
종료가 필요할경우 EXIT 명령어를 사용하여 종료한다.
```
_예_
```
DECLARE
    N_NUMBER NUMBER(2) := 1;
BEGIN
    LOOP
        N_NUMBER := N_NUMBER+1;
        EXIT WHEN N_NUMBER>4;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('N_NUMBER :='||N_NUMBER);
END;
/
DECLARE
    N_NUMBER NUMBER(2) := 1;
BEGIN
    LOOP
        N_NUMBER := N_NUMBER+1;
        IF N_NUMBER>4 THEN
            EXIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('N_NUMBER :='||N_NUMBER);
END;
//또다른 예제 EXIT-WHEN을 써서 나가기
DECLARE
    N_NUMBER NUMBER(2) := 1;
BEGIN
    LOOP
        N_NUMBER := N_NUMBER+1;
        IF N_NUMBER>4 THEN
            EXIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('N_NUMBER :='||N_NUMBER);
END;
/
;
```
### ` WHILE LOOP`
> 반복 수행 여부를 결정하는 조건식을 먼저 지정   
true 실행 false 반복종료
```
WHILE 조건식 LOOP
    반복 작업 수행;
END LOOP;

java나 js에서 구조랑 매우 흡사하다

while(조건식){
    
}
여는 괄호 : LOOP
닫는 괄호 : LOOP END;
```
_예_
```
구구단 만들어보기
DECLARE
    N_NUMBER INTEGER := 2;
    M_NUMBER INTEGER;
BEGIN
    WHILE N_NUMBER<10 LOOP
        M_NUMBER := 1;
        WHILE M_NUMBER<10 LOOP
            DBMS_OUTPUT.PUT_LINE(N_NUMBER||'X'||M_NUMBER||'='||N_NUMBER*M_NUMBER);
            M_NUMBER := M_NUMBER+1;
        END LOOP;
        N_NUMBER := N_NUMBER+1;
    END LOOP;
END;
/
```
### `FOR LOOP`
```
반복을 지정할수 있는 반복문

지정한 시작부터 1씩 증가하여 종료값까지 작업을 반복수행한다.
FOR문 뒤 i는 반복 수행중 시작값과 종료값 사이의 현재 숫자가 저장되는
특수한 변수로 카운터(counter)라고 한다,

카운터는 선언부에서 정의하지 않고 FOR LOOP문에서 바로 정의하여 사용
FOR LOOP안에서만 사용가능하고,할당도 안되고,참조만 가능
```
> 기본형식
```
FOR i IN 시작 값 ..종료값 LOOP
    반복 작업 수행;
END LOOP;
```
_예_
```
BEGIN
    FOR i in 1..4 LOOP
        DBMS_OUTPUT.PUT_LINE('i의 값 :'||i);
    END LOOP;
END;
/
i의 값 :1
i의 값 :2
i의 값 :3
i의 값 :4
```
> 종료값에서 시작값으로 역순으로 반복은 REVERSE    

`단 시작 값과 종료값의 위치는 같다는것`
>기본형식
```
FOR i IN REVERSE 시작값 .. 종료값 LOOP
    반복 작업수행
END LOOP;
```
_예_
```
BEGIN
    FOR 카운트 IN REVERSE 1..4 LOOP
        DBMS_OUTPUT.PUT_LINE('카운트 :'||카운트);
    END LOOP;
END;
/
//한글도 되고 문자열도 된다
```

### `CONTINUE문 , CONTINUE-WHEN문`
> 반복수행중 CONINUE가 실행되면 바로 건너 뛴다.
```
BEGIN
    FOR i IN 1..4 LOOP
        CONTINUE WHEN MOD(i,2) = 1;
        DBMS_OUTPUT.PUT_LINE('현재 i의 값 : '||i);
    END LOOP;
END;
/

현재 i의 값 : 2
현재 i의 값 : 4
```
_소수만 출력해보기_
```
DECLARE
    CNT INTEGER := 0;
BEGIN
    FOR i IN 2..100 LOOP
        CNT := 0;
        FOR j IN 1..i LOOP
            IF MOD(i,j)=0 THEN
                CNT := CNT+1;
            END IF;
        END LOOP;
        CASE
            WHEN CNT=2 THEN DBMS_OUTPUT.PUT_LINE('소수 : '||i);
            ELSE CNT := 0;
        END CASE;
    END LOOP;
END;
/

소수 : 2
소수 : 3
소수 : 5
  :    :
소수 : 89
소수 : 97

PL/SQL 프로시저가 성공적으로 완료되었습니다.
```