# 패키지(package)
```
업무나 기능면에서 연관성이 높은 프로시저,함수등 여러 개의 PL/SQL 서브프로그램등을
하나의 논리 그룹으로 묶어 통합,관리하는데 사용하는 객체를 말한다.
```
>## 장점   


1. ### 모듈성
    ```
    서브프로그램을 포함한 여러 PL/SQL 구성요소를 모듈화할수 있다.  
    프로그램의 이해를 쉽게 하고 패키지 사이의 상호 작용을
    더 간편하고 명료하게 해 주는 역할을 한다.
    PL/SQL로 제작한 프로그램의 사용 및 관리에 도움을 준다.
    논리적으로 관련된 유형, 변수, 상수, 하위 프로그램, 커서 및 예외를 캡슐화
    LIKE 'class'
    ```
2. ### 쉬운 응용 프로그램 설계
    ```
    패키지에 포함할 서브프로그램은 완벽하게 완성되지 않아도 정의가 가능
    전체 소스 코드를 다 작성하기 전에 미리 패키지에 저장할 서브프로그램을 지정할 수 있으므로 설계가 수월해진다
    LIKE 'abstract'
    ```
3. ### 정보 은닉
    ```
    제작 방식에 따라 패키지에 포함하는 서브프로그램의 외부 노출 여부
    접근 여부를 지정할수 있다.즉 서브프로그램을 사용할때 보안을 강화
    +사양을 통해 기능을 노출하고 패키지 본문에서 자세한 구현을 숨길 수 있습니다
    LIKE 'private'
    ```
4. ### 기능성 향상
    ```
    내부에는 서브프로그램 외에 변수,커서,예외 등도 각 세션이 
        유지되는 동안 선언해서 공용으로 사용 할수있다.
    ex)특정 커서 데이터는 세션이 종료되기 전까지 보존되므로 
            여러 서브프로그램에서 사용이 가능하다.
    ```
5. ### 성능 향상
    ```
    패키지에 포함된 모든 서브프로그램이 메모리에 한 번에 로딩되는데
    메모리에 로딩된 후의 호출은 디스크I/O를 일으키지않으므로 성능이 향상됨
    ``` 
- - -

## 패키지 구조와 생성
`패키지는 두 부분을 나누어서 제작한다.`
1. 명세(specification)
2. 본문(body)

> ### 패키지 명세
```sql
/*
    패키지에 포함할 변수,상수,예외,커서 
        그리고 PL/SQL서브 프로그램을 선언하는 용도로 작성
    패키지 명세에 선언한 여러 객체는 패키지 내부뿐 아니라
        외부에서도 참조할 수 있다.
*/

    --기본형식
CREATE [OR REPLACE] PACKAGE 패키지이름
IS|AS
    서브 프로그램을 포함한 다양한 객체선언
END [패키지 이름];
```
_예_
```SQL
CREATE OR REPLACE PACKAGE pack_test
IS
    --선언부
    spec_no NUMBER := 10;
    FUNCTION func_aftertax(price NUMBER) RETURN NUMBER;
    PROCEDURE product_info(in_productid IN products.product_id%TYPE);
    PROCEDURE category_info(in_categoryid IN product_categories.category_id%TYPE);
END pack_test;
/
--추상메서드,인터페이스와 비슷하게 선언부에는 타입과 매개변수 타입, 객채명만 있으면된다.
```
__패키지 명세 확인하기__
```sql
1. SELECT TEXT FROM USER_SOURCE;

TEXT
--------------------------------------------------------------------------------
PACKAGE pack_test
IS
    --선언부
    spec_no NUMBER := 10;
    FUNCTION func_aftertax(price NUMBER) RETURN NUMBER;
    PROCEDURE product_info(in_productid IN products.product_id%TYPE);
    PROCEDURE category_info(in_categoryid IN product_categories.category_id%TYPE
);
END pack_test;

2. DESC PACK_TEST;

 인수명                         유형                    기본 내부/외부?
 ------------------------------ ----------------------- --------- --------
 IN_CATEGORYID                  NUMBER                  IN
 FUNCTION FUNC_AFTERTAX RETURNS NUMBER

 인수명                         유형                    기본 내부/외부?
 ------------------------------ ----------------------- --------- --------
 PRICE                          NUMBER                  IN
 PROCEDURE PRODUCT_INFO
 인수명                         유형                    기본 내부/외부?
 ------------------------------ ----------------------- --------- --------
 IN_PRODUCTID                   NUMBER                  IN
```
> ### 패키지 본문
> 패키지 명세에서 선언한 서브프로그램 코드를 작성한다.
```SQL
+ 패키지 명세에서 선언하지 않은 객체나 서브프로그램을 선언하는것도 가능하다.
- 단, 패키지 내부에서만 사용할수가 있다.(java : private 메서드)

!! 패키지 본문 이름은 패키지 명세 이름과 같게 지정해야한다.!!
--기본 형식
CREATE [OR REPLACE] PACKAGE BODY 패키지 이름
IS | AS
    패키지 명세에서 선언한 서브프로그램을 포함한 여러 객체 저으이
    경우에 따라 패키지 명세에 존재하지 않은 객체 및 서브프로그램도 정의가능
END [패키지 이름];
```
__예시__
```SQL
CREATE OR REPLACE PACKAGE BODY PACK_TEST
IS
    --명세에 선언된 객체 정의
    --내부에서 사용할 객체 추가 정의 가능
    body_no NUMBER := 10;
    
    --명세에서 작성한 선언부가 동일해야한다.
    FUNCTION func_aftertax(price NUMBER) RETURN NUMBER
        IS
            tax NUMBER := 0.05;
        BEGIN
            RETURN (ROUND(price-(price*tax)));
    END func_aftertax;
    --명세에서 작성한 선언부가 동일해야한다.
    PROCEDURE product_info(in_productid IN products.product_id%TYPE)
        IS
            out_pname products.product_name%TYPE;
            out_price products.list_price%TYPE;
        BEGIN
            SELECT product_name,list_price INTO out_pname,out_price
                FROM products
            WHERE products.product_id = in_productid;
            DBMS_OUTPUT.PUT_LINE('제품 번호 : '||in_productid);
            DBMS_OUTPUT.PUT_LINE('제품 명 : '||out_pname);
            DBMS_OUTPUT.PUT_LINE('제품 가격 : '||out_price);
    END product_info;
    --명세에서 작성한 선언부가 동일해야한다.
    PROCEDURE category_info(in_categoryid IN product_categories.category_id%TYPE)
        IS
            out_cname product_categories.category_name%TYPE;
        BEGIN
            SELECT category_name INTO out_cname
                FROM product_categories
            WHERE category_id = in_categoryid;
            DBMS_OUTPUT.PUT_LINE('분류 번호 : '||in_categoryid);
            DBMS_OUTPUT.PUT_LINE('분류 명 : '||out_cname);
    END category_info;
END;
/
```
> ### 서브프로그램 오버로드
```
같은 패키지에서
                ● 파라미터의 개수
                ● 자료형
                ● 순서
                        가 다를 경우에 한해서만 이름이 같은
                        서브프로그램을 정의할수 있다.
서브프로그램 오버로드(subprogram overload)라고 한다.

 [ 보통 같은 기능을 수행하는 여러 서브프로그램이 
     입력 데이터를 각각 다르게 정의할때 사용 ]
또한
 [ 서브프로그램 종류가 같아야 오벌드가 가능하다.]
반드시
 [특정 프로시저를 오버로드할 때 반드시 이름이 같은 프로시저로 정의해야한다.]
 ```
__기본 형식__
```sql
CREATE [OR REPLACE] PACKAGE 패키지 이름
IS | AS
    서브프로그램 종류 서브프로그램 이름(파라미터 정의);
    서브프로그램 종류 서브프로개름 이름(개수나 자료형,순서가 다른 파라미터 정의);  
END;
```
> 프로시저 오버로드
```SQL
create or replace PACKAGE pkg_overload
IS
    PROCEDURE pro_duct(in_pid products.product_id%TYPE);
    PROCEDURE pro_duct(in_cid products.category_id%TYPE);
END;
/
--body
create or replace PACKAGE BODY pkg_overload
IS
    --물품번호를 입력하면 그 번호에 맞는 이름과 가격이 출력된다.
    PROCEDURE pro_duct(in_pid products.product_id%TYPE)
        IS
            out_dname products.product_name%TYPE;
            out_dprice products.list_price%TYPE;
        BEGIN
            SELECT product_name,list_price INTO out_dname,out_dprice
                FROM PRODUCTS
            WHERE products.product_id = in_pid;
            DBMS_OUTPUT.PUT_LINE('물품 이름 : '||out_dname);
            DBMS_OUTPUT.PUT_LINE('물품 가격 : '||out_dprice);
        END pro_duct;
    --해당 카테고리를 입력하면 해당되는 물품 전부가
    --카테고리 이름,물품이름, 가격이 출력된다.
    PROCEDURE pro_duct(in_cid products.category_id%TYPE)
        IS
            list_cate PRODUCTS%ROWTYPE;
            list_name product_categories.category_name%TYPE;
            CURSOR C1 IS 
                SELECT * FROM PRODUCTS
                    WHERE products.category_id=in_cid;
        BEGIN
            SELECT product_categories.category_name INTO list_name
                FROM product_categories
            WHERE product_categories = in_cid;
            FOR list IN c1 LOOP
                DBMS_OUTPUT.PUT_LINE('카테고리 종류 : '||list_name);
                DBMS_OUTPUT.PUT_LINE('물품 이름 : '||list.PRODUCT_NAME);
                DBMS_OUTPUT.PUT_LINE('물품 가격 : '||list.LIST_PRICE);
            END LOOP;
        END pro_duct;
END;
```
__패키지 사용하기__
```SQL
BEGIN
    DBMS_OUTPUT.PUT_LINE('OVERLOAD');
    pkg_overload.pro_duct(1);
    pkg_overload.pro_duct(in_cid=>1);
END;
/

--주의 할것.
/*
    %TYPE이지만 속성 자료형은 둘다 NUMBER나 INTEGER 일경우 정의가 많다고 에러가 난다.
    따라서 이렇게 참조 자료형은 다르지만 참조된 속성의 자료형은 같을경우에
    in_cid=>1 지목해서 할 경우 해결이 된다.
*/
```

__패키지 삭제하기__
```SQL
--패키지 명세와 본문을 한 번에 제거하기
DROP PACKAGE 패키지 이름;
--패키지의 본문만 삭제
DROP PACKAGE BODY 패키지 이름;
```