## 데이터를 추가,삭제,수정하는 
# 데이터 조작어(Data Manipluation Language)

## __`꼭 익혀야하는 것`__   
1. INSERT문의 기본 사용 방법,서브쿼리의 활동
2. UPDATE문의 기본 방식과 서브쿼리의 활용 및 실행전 검증
3. DELETE문에서 WHERE의 활용

### '테이블에 데이터를 추가하는'   
## INSERT문
```
INSERT INTO 테이블 이름 [(열1,열2...열N)]
VALUES (열 1에 들어갈데이터 ... 열N에 들어갈데이터)
```
`숫자는 그대로 입력,문자열은 ' '로 감싸기`
```
//테이블 생성 DDL
CREATE TABLE test2
(
    name NVARCHAR2(10),
    AGE  NUMBER(3)
);

INSERT INTO TEST2 (NAME,AGE) VALUES ('고라니',15);

NAME = 문자열타입
AGE = 숫자 타입

타입,문자길이,포멧등 일치해야한다.
```
> 열 지정없이 사용할때
```
DESC TEST2;
 이름        널?      유형
 -------- -------- -------
 NAME              NVARCHAR2(10)
 AGE               NUMBER(3)
 순서와 타입이 나오고

 INSERT INTO TEST2 VALUES('비둘기',24);
 모든 열에 다 값을 넣으면 된다.
 ```
 `테이블에 NULL 대입하기`
 ```
새로운 데이터를 추가할때 특정 열에 들어갈 
1.데이터가 확정되지 않았거나
2.필수 데이터 요소가 아닌 경우

-- 명시적 입력
INSERT INTO (NAME,AGE) VALUES ('세균',NULL);

명시적으로 입력하면 좋은점
1. 여러 개발자들이 자료를 찾지않고 
    INSERT문만 봐도 테이블에 포함된 열의 내용을 알수있다.

-- 암시적 입력
--- 데이터 추가시 열을 제외
INSERT INTO (NAME) VALUES ('햄버거');
```
## `테이블에 날짜 데이터 입력하기`
```
INSERT INTO TEST2 VALUES('마징가',13,'2001/05/06');
INSERT INTO TEST2 VALUES('둘리',43,'1985-03-12');

--주의사항 오라클 기본언어군에 따라 표기방법이 다르기 때문에
--오류가 날수있는 부분 KOR은 YYYY-MM--DD가 기본 표기법
INSERT INTO TEST2 VALUES('둘리',43,'03-12-2006');--에러

--이때에는 TO_DATE 함수로 사용하면된다.
INSERT INTO TEST2 VALUES('희동',13,TO_DATE('03-15-1999','MM-DD-YYYY'));
'원하는 날짜 입력','해당하는 포멧입력';

--혹은 현 시점을 입력하고 싶을땐
INSERT INTO TEST2 VALUES('라희',24,SYSDATE);
```

## 서브쿼리를 이용하여 한번에 여러 데이터 추가
```
--등급이 2인 데이터를 한번에 넣기

INSERT INTO EMP_GRADE_1 
        SELECT P.*
        FROM PRODUCTS P,VIP_GRADE G
        WHERE P.LIST_PRICE BETWEEN G.LOW_LIMIT AND G.HIGH_LIMIT
        AND G.GRADE = 2;

이때에 넣는 데이터 열의 개수와 타입이
       받는 데이터 열의 개수와 타입이 일치해야한다.

```
### 주의 사항
```
VALUES절은 사용하지 않는다.
데이터가 추가되는 테이블의 개수와 서브쿼리의 개수가 일치
데이터가 추가되는 테이블의 자료형과 서브쿼리의 자료형이 일치

즉 자료형과 열의 개수만 일치한다면
JOIN문으로 합친 테이블도 들어갈수 있다는것.
```

## `테이블의 있는 데이터 수정하기`   
> UPDATE
```
UPDATE [변경할 테이블]
SET    [변경할 열1=데이터],[변경할 일2=데이터],....
[WHERE 데이터를 변경할 대상 행을 선별하기 위한 조건]    
```

## `데이터 전체 수정하기 `
```
테이블 열에 있는값 전체 수정하기
UPDATE TEST2
    SET MANAGER_ID = 0;
```

## `데이터 일부만 수정하기`   
```
UPDATE TEST2
    SET NAME = '또치',
        AGE  = 34
WHERE TEST2.NAME = '둘리';
```

## `서브쿼리를 사용하여 데이터 수정하기`   

> 여러 열을 한 번에 수정하는 경우
```
UPDATE EMP_GRADE_1
    SET (FIRST_NAME,LIMIT_PRICE) = (SELECT FIRST_NAME,LIST_PRIC
                                     FROM PRODUCTS
                                    WHERE CATEGORY_ID=1);

// 1번 예제 ) 이건 에러가 발생


UPDATE PRODUCT_TMP
    SET (STANDARD_COST,LIST_PRICE) = (SELECT STANDARD_COST,LIST_PRICE 
                                        FROM PRODUCT_TMP2 
                                        WHERE PRODUCT_ID=228)
    WHERE PRODUCT_ID=228;
// 2번 예제 ) 이렇게 해야된다.

UPDATE  PRODUCT_TMP
    SET (STANDARD_COST,LIST_PRICE) = (SELECT 8800.49,4880.98 FROM DUAL)
    WHERE CATEGORY_ID=1;

이유는 단일행의 결과값이 나와야한다.
```
> 열 하나 하나 수정해야하는 경우
```
UPDATE PRODUCT_TMP
    SET STANDARD_COST = (SELECT 5500.49
                            FROM DUAL),
        LIST_PRICE = (SELECT 9780.36
                        FROM DUAL)
    WHERE CATEGORY_ID=1;

--

UPDATE PRODUCT_TMP
    SET STANDARD_COST = (SELECT STANDARD_COST
                            FROM PRODUCT_TMP2
                            WHERE PRODUCT_ID=228),
        LIST_PRICE = (SELECT LIST_PRICE
                            FROM PRODUCT_TMP2
                            WHERE PRODUCT_ID=228)
    WHERE CATEGORY_ID=1;
```
` 변경할 열 개수나 자료형은 일치해야한다.`

> WHERE 절에서 서브쿼리로 사용하여 데이터를 수정하는 경우

```
UPDATE PRODUCT_TMP
    SET LIST_PRICE = 5580.63
WHERE STANDARD_COST = (SELECT STANDARD_COST
                        FROM PRODUCT_TMP2
                        WHERE PRODUCT_ID=228);

항상 등가 연산자의 R-Value는 단일행이 와야한다.
```
> ## UPDATE 사용시 주의점
```
데이터를 수정,삭제할경우 WHERE의 조건식이 중요한데
바로 수정하지말고 조건식의 결과값이 어떻게 되는지 확인해야한다.

결과물이

UPDATE PRODUCT_TMP
    SET LIST_PRICE = 5894.48,
        STANDARD_COST = 3354.99
    WHERE PRODUCT_ID=228;
이라면

실행하기전에

SELECT *
    FROM PRODUCT_TMP
    WHRE PRODUCT_ID=228;

로 확인해보고 수정,삭제를 한다
```
## __`테이블에 있는 데이터 삭제하기`__
```
DELETE [FROM] [테이블 이름]
[WHERE 삭제할 대상 행을 선별하기 위한 조건식];

WHERE절을 사용하지 않으면 테이블 전체의 데이터가 삭제된다.
```
### `데이터 일부분만 삭제하기`
```
SELECT * FROM EMP_TMP;
DELETE EMP_TMP WHERE MANAGER_ID IN (1,24);
```
### `서브쿼리를 사용하여 데이터 삭제하기`
```
DELETE PRODUCT_SAM
    WHERE PRODUCT_ID IN ( SELECT P.PRODUCT_ID
                          FROM PRODUCTS P,vip_grade V
                          WHERE p.list_price BETWEEN V.LOW_LIMIT AND V.HIGH_LIMIT
                          AND V.GRADE = 2);
SELECT * FROM PRODUCT_SAM;         

```
### `데이터 전체 삭제하기`
```
DELETE FROM PRODUCT_SAM
```
