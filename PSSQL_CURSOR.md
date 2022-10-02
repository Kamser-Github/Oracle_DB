# 커서와 예외 처리
> 체크 포인트
```
- 커서의 의미와 사용 방법
- 예외 처리의 의미와 사용 방법
```

## 특정 열을 선택하여 처리하는 커서   
### `커서란?`
```
커서는 SELECT 문 또는 데이터 조작어(DML INSERT,DELETE,UPDATE)같은 SQL문을 실행했을때
해당 SQL문을 처리하는 정보를 저장한 메모리 공간을 말한다.

+ 메모리 공간은 Private SQL Area라고 부르며
    커서는 이 메모리의 포인터를 말한다.
```
__추가 설명__
```
커서를 사용하면 실행된 SQL문의 결과 값을 사용할수 있다.
>>
SELECT문읠 결과 값이 여러 행으로 나왔을때 
각 행별로 특정 작업을 수행하도록 기능을 구현하는 것이 가능하다

저장된 데이터를 극대화할 수 있는 중요한 기능이다.

*커서의 종류

┌─ 명시적 커서 (explicit)
│
└─ 묵시적 커서 (implicit),암시적 커서
```
### `SELECT INTO 방식`
```
A.SELECT INTO문은 조회하는 데이터가 단 하나의 행일때 사용 가능한 방식
B.커서는 결과행이 하나든 여러개든 상관없이 사용가능하다.

A.SELECT INTO문은 SELECT절에 명시한 각 열의 결과 값을 INTO절에 명시한 변수에 담는다.
ㄴ 따라서 명시한 변수는 SELECT가 조회한 개수와 자료형이 일치해야된다.
ㄴ WHERE , GROUP BY도 같이 사용이 가능하다.

//
```
`SELECT 열1,열2,열3..열n INTO 변수1,변수2,변수3...변수n`
```

DECLARE
    into_sample EMPLOYEES%ROWTYPE;
BEGIN
    SELECT EMPLOYEE_ID,FIRST_NAME,MANAGER_ID
        INTO into_sample.EMPLOYEE_ID,into_sample.FIRST_NAME,into_sample.MANAGER_ID
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 13;
    DBMS_OUTPUT.PUT_LINE(into_sample.EMPLOYEE_ID);
    DBMS_OUTPUT.PUT_LINE(into_sample.FIRST_NAME);
    DBMS_OUTPUT.PUT_LINE(into_sample.MANAGER_ID);
END;
/

```

### `명시적 커서`
> 명시적 커서는 직접 커서를 선언하여 사용하는 방법   

```
  단계   명칭                   설명
  ---   -----                   ----
 1단계  커서 선언           사용자가 직접 이름을 지정하여 사용할 커서를
        (declaration)       SQL문과 함께 선언한다.
 2단계  커서 열기           커서를 선언할때 작성한 SQL문을 실행한다.
        (opne)              실행한 SQL문에 영향을 받는 행을 active set이라한다.
 3단계  커서에서 읽어온     실행된 SQL문의 결과 행 정보를 하나씩 읽어와서 변수에 저장한 후
        데이터 사용 (fetch) 필요한 작업을 수행,공통 작업을 반복해서 
                             실행하기위해 여러 종류의 LOOP와 함께 사용
 4단계  커서 닫기           모든 행의 사용이 끝나고 커서를 종료.
        (close)
```
> 기본 형식
```sql
DECLARE
    CURSOR 커서 이름 IS SQL문;   -- 커서 선언(Declaration)
BEGIN
    OPEN 커서 이름;             -- 커서 열기(Open)
    FETCH 커서 이름 INTO 변수   -- 커서로부터 읽어온 데이터사용(Fetch)
    CLOSE 커서 이름;            -- 커서 닫기(Close)
END;
```
> 하나의 행만 조회되는 경우
```sql
SELECT INTO 일 경우보다 여러 단계를 거쳐야하므로 
    커서는 다중행일때 효율이 극대화된다.

DECLARE
    --커서 데이터를 입력할 변수 선언;
    TMP_EMP EMPLOYEES%ROWTYPE;
    
    --명시적 커서 선언;
    CURSOR test_cursor IS 
        SELECT *
            FROM EMPLOYEES
        WHERE employee_id=10;
BEGIN
    OPEN test_cursor;
    -- test)cursor의 속성 개수 INTO 뒤에 온 변수의 개수는 같아야한다.
    FETCH test_cursor INTO TMP_EMP;
    DBMS_OUTPUT.PUT_LINE('직원번호 : '||TMP_EMP.employee_id);
    DBMS_OUTPUT.PUT_LINE('직원이름 : '||TMP_EMP.FIRST_NAME);
    DBMS_OUTPUT.PUT_LINE('매니저번호 : '||TMP_EMP.MANAGER_ID);
    
    --커서닫기(CLOSE)
    CLOSE test_cursor;
    
END;
/
```
> 여러 행을 조회되는 경우 사용하는 LOOP문
```SQL
DECLARE
    --커서 데이터를 입력할 변수 선언;
    TMP_EMP EMPLOYEES%ROWTYPE;
    --명시적 커서 선언;
    CURSOR test_cursor IS 
        SELECT *
            FROM EMPLOYEES;
BEGIN
    OPEN test_cursor;
    LOOP
        --커서로부터 읽어온 데이터 사용(FETCH)
        FETCH test_cursor INTO TMP_EMP;
        --커서의 모든 행을 읽어오기 위해 %NOTFOUND 속성지정
        EXIT WHEN test_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('직원번호 : '||TMP_EMP.employee_id);
    DBMS_OUTPUT.PUT_LINE('직원이름 : '||TMP_EMP.FIRST_NAME);
    DBMS_OUTPUT.PUT_LINE('매니저번호 : '||TMP_EMP.MANAGER_ID);
    DBMS_OUTPUT.PUT_LINE('------------');
    END LOOP;
    --커서닫기(CLOSE)
    CLOSE test_cursor;
END;
/
```
__커서가 무한반복문에 들어갈 경우__
```SQL
DECLARE
    --커서 데이터를 입력할 변수 선언;
    TMP_EMP EMPLOYEES%ROWTYPE;
    --명시적 커서 선언;
    CURSOR test_cursor IS 
        SELECT *
            FROM EMPLOYEES
            WHERE ROWNUM<10;
    cnt INTEGER := 1;
BEGIN
    OPEN test_cursor;
    LOOP
        --커서로부터 읽어온 데이터 사용(FETCH)
        FETCH test_cursor INTO TMP_EMP;
        EXIT WHEN CNT>15;
        --커서의 모든 행을 읽어오기 위해 %NOTFOUND 속성지정
        DBMS_OUTPUT.PUT_LINE('직원번호 : '||TMP_EMP.employee_id);
        DBMS_OUTPUT.PUT_LINE('직원이름 : '||TMP_EMP.FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE('매니저번호 : '||TMP_EMP.MANAGER_ID);
        DBMS_OUTPUT.PUT_LINE('카운트 : '||CNT);
        DBMS_OUTPUT.PUT_LINE('------------');
        CNT := CNT+1;
    END LOOP;
    --커서닫기(CLOSE)
    CLOSE test_cursor;
END;
/
--데이터는 9개 밖에없는데 그뒤로 계속 출력해야되는 상황이라면.
------------
직원번호 : 10
직원이름 : Ryan
매니저번호 : 9
카운트 : 8
------------
직원번호 : 14
직원이름 : Elliot
매니저번호 : 9
카운트 : 9
------------
직원번호 : 14
직원이름 : Elliot
매니저번호 : 9
카운트 : 10
------------
--마지막 커서가 계속 반복해서 찍힌다.

DECLARE
    --커서 데이터를 입력할 변수 선언;
    TMP_EMP EMPLOYEES%ROWTYPE;
    --명시적 커서 선언;
    CURSOR test_cursor IS 
        SELECT *
            FROM EMPLOYEES
            WHERE ROWNUM<10;
    cnt INTEGER := 1;
    result VARCHAR(20);
BEGIN
    OPEN test_cursor;
    LOOP
        --커서로부터 읽어온 데이터 사용(FETCH)
        FETCH test_cursor INTO TMP_EMP;
        EXIT WHEN CNT>15;
        --커서의 모든 행을 읽어오기 위해 %NOTFOUND 속성지정
        DBMS_OUTPUT.PUT_LINE('직원번호 : '||TMP_EMP.employee_id);
        DBMS_OUTPUT.PUT_LINE('직원이름 : '||TMP_EMP.FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE('매니저번호 : '||TMP_EMP.MANAGER_ID);
        DBMS_OUTPUT.PUT_LINE('카운트 : '||CNT);
        CNT := CNT+1;
        IF test_cursor%FOUND THEN result:='읽어올게 있다';
        ELSE result :='읽어올게 없다';
        END IF;
        DBMS_OUTPUT.PUT_LINE(result);
        DBMS_OUTPUT.PUT_LINE('------------');
    END LOOP;
    --커서닫기(CLOSE)
    CLOSE test_cursor;
END;
-- IF문으로 현재 상황을 찍어보면
-- %FOUND FETCH로 읽어올게 있으면 true,없으면 false을 반환한다.
------------
직원번호 : 14
직원이름 : Elliot
매니저번호 : 9
카운트 : 9
읽어올게 있다
------------
직원번호 : 14
직원이름 : Elliot
매니저번호 : 9
카운트 : 10
읽어올게 없다
------------
이렇게 FETCH를 사용하면 CURSOR(포인터)가 이동하고
Private SQL Area의 CURSOR(포인터)가 끝에 닿으면 FETCH는 같은걸 계속 찍는다.

--WHILE문으로 사용하려면 한번더 위에서 읽어서 읽을게 없다는걸 커서에게 알려야한다.
DECLARE
    --커서 데이터를 입력할 변수 선언;
    TMP_EMP EMPLOYEES%ROWTYPE;
    --명시적 커서 선언;
    CURSOR test_cursor IS 
        SELECT *
            FROM EMPLOYEES
            WHERE ROWNUM<10;
BEGIN
    OPEN test_cursor;
    FETCH test_cursor INTO TMP_EMP;
    WHILE test_cursor%FOUND LOOP
        --커서로부터 읽어온 데이터 사용(FETCH)
        --커서의 모든 행을 읽어오기 위해 %NOTFOUND 속성지정
        DBMS_OUTPUT.PUT_LINE('직원번호 : '||TMP_EMP.employee_id);
        DBMS_OUTPUT.PUT_LINE('직원이름 : '||TMP_EMP.FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE('매니저번호 : '||TMP_EMP.MANAGER_ID);
        FETCH test_cursor INTO TMP_EMP;
    END LOOP;
    --커서닫기(CLOSE)
    CLOSE test_cursor;
END;
/


```
> ### %NOTFOUND외 속성
```
        속성                설명
        ---                 ---
커서 이름%NOTFOUND  수행된 FETCH문을 통해 추출한 행이 있으면 false,없으면 true를 반환
커서 이름%FOUND     수행된 FETCH문을 통해 추출한 행이 있으면 true,없으면 false를 반환
커서 이름%ROWCOUNT  현재까지 추출된 행 수를 반환.
커서 이름%ISOPEN    커서가 열려(OPEN)이면 true,닫혀(close)면 false을 반환
```

> ### 여러 개의 행이 조회되는 경우(FOR LOOP문)
__기본형식__
```
FOR 루프 인덱스 이름 IN 커서 이름 LOOP
    결과 행별로 반복 수행할 작업;
END LOOP;

루프 인덱스(loop index)는 커서에 저장된 각 행이 저장되는 변수를 뜻하며
'.'를 통해 행의 각 필드에 접근할수 있다.
예>>
커서에 저장할 SELECT 문에 EMPLOYEE_ID 열이 존재하고
이 커서를 사용하는 루프 인덱스 이름이 loop_tmp일 경우
loop_tmp.EMPLOYEE_ID는 SELECT문을 통해 조회된 
데이터의 각 행에 해당하는 EMPLOYEE_ID열 데이터를 가리키게 됩니다.

커서에 FOR LOOP를 사용할 경우
OPEN, FETCH , CLOSE문을 작성하지 않고
FOR LOOP를 통해 각 명령어를 자동으로 수행하기때문에 간단해진다.
```
_예_
```SQL
DECLARE
    --명시적 커서 선언(Declaration)
    CURSOR c1 IS
    SELECT EMPLOYEE_ID,FIRST_NAME,MANAGER_ID
    FROM EMPLOYEES;
BEGIN
    FOR c1_i IN c1 LOOP
        DBMS_OUTPUT.PUT_LINE(c1_i.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE(c1_i.FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE(c1_i.MANAGER_ID);
    END LOOP;
END;
/
```
> 커서에 사용할 파라미터 입력 받기
__기본형식__
```
CURSOR 커서 이름(파라미터  이름 자료형,...) IS
SELECT ...
```
```SQL
DECLARE
    --커서 데이터를 입력할 변수 선언
    MGR EMPLOYEES%ROWTYPE;
    --명시적 커서 언언(DECLAREATION)
    CURSOR C1 (p_mgrid EMPLOYEES.MANAGER_ID%TYPE) IS
        SELECT *
            FROM EMPLOYEES
        WHERE EMPLOYEES.manager_id=p_mgrid;
BEGIN
    --OPEN 매니저 아이디가 10번인 직원
    OPEN C1(24);
     LOOP
        FETCH C1 INTO MGR;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('이름 : '||MGR.FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE('번호 : '||MGR.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('매니저 번호 : '||MGR.MANAGER_ID);
    END LOOP;
    CLOSE C1;
    --매니저 번호가 1번인 사람 커서 사용
    OPEN C1(1);
    LOOP
        FETCH C1 INTO MGR;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('이름 : '||MGR.FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE('번호 : '||MGR.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('매니저 번호 : '||MGR.MANAGER_ID);
    END LOOP;
    CLOSE C1;
END;
/
--명시적 방법
DECLARE
    --커서 데이터를 입력할 변수 선언
    MGR EMPLOYEES%ROWTYPE;
    input_id employees.manager_id%TYPE;
    --명시적 커서 언언(DECLAREATION)
    CURSOR C1 (p_mgrid EMPLOYEES.MANAGER_ID%TYPE) IS
        SELECT *
            FROM EMPLOYEES
        WHERE EMPLOYEES.manager_id=p_mgrid;
BEGIN
    --OPEN 매니저 아이디가 10번인 직원
    input_id := &INPUT_MGRID;
    OPEN C1(input_id);
     LOOP
        FETCH C1 INTO MGR;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('이름 : '||MGR.FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE('번호 : '||MGR.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('매니저 번호 : '||MGR.MANAGER_ID);
    END LOOP;
    CLOSE C1;
END;
/
/*
핵심은 CURSOR가 포인터로 가리키때마다 
SELECT에서 가져온 데이터를 MGR이 받아야하는데
서로 데이터 타입과 개수가 같아야한다.

입력하는것과 받아주는건 같을 필요가 없다.
*/
DECLARE
    --사용자가 입력한 부서 번호를 저장하는 변수선언
     emp_no employees.employee_id%TYPE;
    --명시적 커서 선언
    CURSOR EMP (p_no employees.employee_id%TYPE) IS
        SELECT employee_id,first_name,manager_id
        FROM EMPLOYEES
        WHERE EMPLOYEES.employee_id=p_no;
BEGIN
    --INPUT_NO에 직원번호 입력받고 . emp_no에 대입;
    emp_no := &INPUT_EMPNO;
    --커서 LOOP시작 , C1커서에 emp_no대입
    FOR c1_tmp IN EMP(emp_no) LOOP
    --커서 FOR LOOP시작, C1커서에 emp_no를 대입
        DBMS_OUTPUT.PUT_LINE('직원번호 : '||c1_tmp.employee_id);
        DBMS_OUTPUT.PUT_LINE('직원이름 : '||c1_tmp.first_name);
        DBMS_OUTPUT.PUT_LINE('매니저번호 : '||c1_tmp.manager_id);
    END LOOP;
END;
/
```
### `묵시적 커서`
> 별다른 선언없이 SQL을 사용할때 오라클에서 자동으로 선언되는 커서
```
사용자가 OPEN,FETCH,CLOSE를 지정하지 않는다.
PL/SQL문 내부에서 DML명령어나 SELECT INTO문이 실행될때
자동으로 생성처리 된다.
```
`여러 행의 결과를 가지는 커서는 명시적 커서만 가능하다`
> 묵시적 커서 특징
```
묵시적 커서의 속성을 사용하면 현재의 커서 정보를 알수있다.

    속성                        설명
    ---                         ---
 SQL%NOTFOUND   묵시적 커서 안에 추출한 행이 있으면 false
                없으면 true를 반환,DML명령어로 영향을 받는 행이
                없을경우에도 true를 반환한다.
 
 SQL%FOUND      묵시적 커서 안에 추출한 행이 있으면 true,
                없으면 false를 반환,DML명령어로 영향을 받는 행이
                없을경우에도 true를 반환한다.
 SQL%ROWCOUNT   묵시적 커서에 현재까지 추출한 행 수 또는
                DML명령어로 영향받는 행 수를 반환
 SQL%ISOPEN     묵시적 커서는 자동으로 SQL문을 실행한 후
                CLOSE되므로 항상 false를 반환한다
```
__예__
```
BEGIN
    UPDATE CUSTOMER_S SET name='둘리'
    WHERE customer_id = 3;
    
    DBMS_OUTPUT.PUT_LINE('갱신된 행의 수: '||SQL%ROWCOUNT);
    IF(SQL%FOUND) THEN
        DBMS_OUTPUT.PUT_LINE('갱신 대상행 존재 여부: '||'true');
    ELSE
        DBMS_OUTPUT.PUT_LINE('갱신 대상행 존재 여부: '||'false');
    END IF;
    
    IF(SQL%ISOPEN) THEN
        DBMS_OUTPUT.PUT_LINE('커서의 오픈 여부 : '||'true');
    ELSE
        DBMS_OUTPUT.PUT_LINE('커서의 오픈 여부 : '||'false');
    END IF;
END;
/
갱신된 행의 수: 1
갱신 대상행 존재 여부: true
커서의 오픈 여부 : false

갱신된 행의 수는
    실제 있는 데이터가 갱신이 되었으므로 1이된다.

갱신 대상 행 존재여부
    실제 데이터가 갱신되었으므로 true가 된다.

커서가 open인 상태인지 검사
    묵시적 커서는 종료와 함께 close되므로
        false이 된다.
```