/*

비교 연산자는 여러단위로 뽑아낼 수 없다.
관계 연산자로 묶어서 여러 단위로 데이터를 출력한다

여러개의 조건식을 사용하는 AND,OR 연산자
--테이블 안에 있는 문자열 데이터는 대소문자를 구분한다.

따라서 함수로 UPPER,LOWER로 통일해서 검색하는게 좋다.
WHERE UPPER(FIRST_NAME)='JOHN';

조건식이 결과가 true인것만 조회를 한다는것을 명심해야한다.

**실무에는 OR보다 AND를 자주 사용한다**
다양한 조건을 만족하는 데이터만 추출해야하는 경우가 많다.
OR,AND 제한 개수는 없다고 보는게 맞다

SELECT *
    FROM EMPLOYEEES
WHERE [조건식 1]
    AND [조건식 2]
    OR [조건식 3]
     :      :
    AND [조건식 N];

산술 연산자와 연계해서 사용할수도 있다.
SELECT *
    FROM EMPLOYEES
WHERE SAL*12 = 36000;
--연봉이 3600인 직원을 조회한다.
--SAL = 300 인 행만 조회를 하게 된다.

또는
SELECT *
    FROM EMPLOYEES
WHERE SAL*12 > 36000;
--연봉이 3600보다 큰 직원을 조회한다.
--SAL > 300 인 행만 조회를 하게 된다.

**등가 비교 연산자중 DB에 있는 특이한것**
!=는 서로 값이 다를경우 true, 같을경우 false인데
<> , ^= 도 같은 의미로 사용이 된다.


NOT,BETWEEN,IN

*조회수가 0,1,2인 게시글을 조회하시오.
WHERE HIT=1 OR HIT=2 OR HIT3=; // 연속되지 않은경우
WHERE 0<=HIT AND HIT <=2; //한쪽의 범위를 포함하지 않을경우

BETWEEN
WHERE COLUMN명 BETWEEN MIN AND MAX;(양쪽 모두를 포함);
WHERE HIT BETWEEN 0 AND 2; //양쪽 범위를 포함하고,연속되는 범위라면.

NOT BETWEEN
WHERE NOT BETWEEN 2000 AND 3000;


OR, IN
*조회수가 0,2,7인 게시글을 조회하시오
WHERE HIT=0 OR HIT=2 OR HIT=7;
WHERE HIT IN(0,2,7); //연속되지 않은 값을 비교할때 IN을 사용하자

*조회수가 0,2,7이 아닌 게시글을 조회하시오
WHERE HIT NOT IN(0,2,7);


*/
/*
패턴 비교 연산자
LIKE , % , _

종류       의미
 _      어떤 값이든 상관없이 한개의 문자 데이터를 의미
    
 %      길이와 상관없이(문자 없는경우도 포함됨) 모든 문자 데이터.


*회원 중에서 '박'씨 성을 조회하시오.

WHERE NAME LIKE '박%'; 1글자 이상을 의미

*박씨 성이고 외자인 회원을 조회하시오
WHERE NAME LIKE '박_'; 외자 박_ 3글자 박__

*박씨 성을 제외한 회원을 조회하시오
WHERE NOT NAME LIKE '박%';

*이름의 '도'자가 들어간 회원을 조회하시오.
WHERE NAME LIKE '%도%';

**사용성이 다양한 와일드카드이지만**
작은 데이터 베이스는 큰 차이가 없지만
데이터베이스가 점점 무거워 질수록 속도 저하가 발생한다

WHERE LIKE '%'||'가'||'%' 
INSTR - 문자열 검색 함수 INSTR(문자열,검색문자열,위치,찾을 수)

SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME LIKE '%ab%e';

SELECT *
FROM EMPLOYEES
WHERE INSTR(first_name,'ab')>0
    AND INSTR(first_name,'e',LENGTH(first_name))>0;
이렇게 나타 낼수도 있다.



**많이 사용되는 연산자**

!!!주의 할점!!!
NULL은 '현재 무슨 값인지 확정되지 않은 상태'
혹은   '값 자체가 존재하지 않은 상태'
대부분의 연산자는 연산대상이 NULL이면 연산자체가 의미가 없다.
return값이 true , false가 아니라 NULL이다.

TABLE
ID      PW
1234    (NULL)
WHERE ID>NULL 
    AND PW IS NULL;
//조회가 안됨.

WHERE ID>NULL
    OR PW IS NULL;
//조회가 됨.

조건식이랑 사용하면 생각한 결과가 안나올수있다.

IS NULL
IS NOT NULL
--NULL 값을 조회하거나 제외할때 사용한다.

*/
/*
정규식을 이용한 패턴 연산
정규식이란 ?
문자열을 찾을때 검색 패턴기호를 사용했다.
regexlib.com -> search
chat sheet
WHERE TITLE LIKE '%-%-%';//전화번호를 검사하고싶다.%-%-%을 출력해달라.
010-2222-3333;
011-333-4444;
016-234-4534;
017-789-7897;
정규식
01[016789]-[0123456789][0-9][0-9][0-9]-[][][][] 하나의 글자를 대변 0또는 ~~ 9 
[0-9][0-9]~~ 9 
[0-9][0-9][0-9][0-9] = \d\d\d\d = \d{4} 3글자도 해야되는데 \d{3,4}
시작할때 ^ 끝날때 $
^01[016-9]-\d{3,4}-\d{4}$  //전화번호 정규식 =>tester
바로 010으로 시작할때만 적용이 되는것.

01[016-9]-\d{3,4}-\d{4}
중간에 일치하는게 잇으면 된다.

오라클에서 정규식은 LIKE로 해결이 안되기 때문에
REGEXP_LIKE // WHERE REGEXP_LIKE(first_name,'^Ste(v|ph)en$');
//전화번호가 포함된 게시글을 조회하시오.
WHERE REGEXP_LIKE(TITLE,'^01[016-9]-\d{3,4}-\d{4}$');

문자열 비교를 위한 정규식
*이메일은 어떻게 찾아볼수잇을까
//asdogn@nana.com  
//com net org만 잇다고 생각하고
@ . org  net com  //3중에 하나
문자 1개이상 \w+@\w.(org|net|com) 숫자가 된다.
11yodo@11namev.com
\D\w*@\D\w*.(org|net|com);

*/