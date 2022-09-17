/*
 NULL 함수
 옵션으로 입력하는 컬럼에는 NULL이 들어간다.
 +덧셈을 한다고 할때 NULL+3이면 3이 아니라 NULL이 된다.
 어떤 값을 더해도 NULL이다.
 NULL확인함수,NULL일경우 대체해주는 함수
 
 반환 값이 NULL일 경우 대체 값을 제공하는 NVL(NULL,대체값) 함수
    SELECT NVL(AGE,0) FROM MEMBERS;
    SELECT NVL(MANAGER_ID,0) FROM EMPLOYEES;
 
 NVL에서 조건을 하나 더 확장한 NVL2(입력값,NOTNULL 대체값,NULL대체값)함수
    SELECT NVL2(AGE,100/AGE,0) FROM MEMBERS;
 
 두 값이 같은 경우 NULL 그렇지 않은경우 첫 번째 값 반환 NULLIF(값1,값2)함수
    SELECT NULLIF(MANAGER_ID,1) FROM EMPLOYEES;
    매니저 아이디가 1이면 NULL로 변경, 아니면 그대로 유지.

 조건에 따른 값 선택하기 DECODE(기준값,비교값,출력값,비교값,출력값....)
    가변이기때문에 무한이다,IF-ELSE와 비슷하다.
    SELECT DECODE(GENDER,'남성',1,2) FROM MEMBERS;
    성별이 남성이면 1, 아니면 2를 출력해준다.
    SELECT DECODE(SUBSTR(PHONE,1,3),'011','SK','016','KT','기타) FROM MEMBERS;
    011 이면 SK를 016 KT 그외는 기타를 출력
    SELECT DECODE(SUBSTR(PHONE,1,3),'011','SK',
                        '515','KT',
                        '590','LG',
                        '알뜰폰')||','||PHONE
                        FROM EMPLOYEES;
                        시각적으로 보기  편하게 작성
*/
                     