# 문자 데이터를 가공하는 문자 함수

> ### 문자 함수는 문자 데이터를 가공하거나,   
> ### 문자 데이터로부터 특정 결과를 얻고자 할때 사용한다   


## `대,소문자를 바꿔주는 함수`

__입력 데이터에 열 이름이나 데이터를 직접 지정해야한다!__
```
    함수                설명
UPPER(문자열)   괄호 안의 문자 데이터를 모두 대문자로 변환하여 반환
LOWER(문자열)   괄호 안의 문자 데이터를 모두 소문자로 변환하여 반환
INITCAP(문자열) 괄호 안의 문자 데이터의 첫 글자는 대문자,나머지 문자는 소문자로 변환후 반환
```
> ### UPPER(문자열)/LOWER(문자열)
_대/소문자를 가리지 않을때 검사하기 위해서_
```
SELECT LOWER('NewWeeK') FROM DUAL; // newweek;
SELECT UPPER('NewWeeK') FROM DUAL; // NEWWEEK;
SELECT * FROM employees WHERE UPPER(first_name)='JOHN';
SELECT * FROM employees WHERE UPPER(SID)=UPPER('JOHN');
```
> ### INITCAP(문자열)
_첫 글자는 대문자 나머지는 소문자 단) 한글이 섞이면 그 뒤는 대문자_
```
SELECT INITCAP('the..') FROM DUAL; //The..
SELECT INITCAP('the most important is..') FROM DUAL; //The Most
SELECT INITCAP('the m양os파t important is..') FROM DUAL; 
//The M양Os파T 한글 뒤에 영어도 대문자로 변경됨.
```
<br>

## `문자열의 길이를 구하는 함수`   
> ### LENGTH(문자열)

```
SELECT LENGTH('WHERE WE ARE') FROM DUAL;

모든 회원의 핸드폰 번호와 번호의 문자열 길이를 조회하시오.
SELECT PHONE,LENGTH(PHONE) FROM employees;

핸드폰 번호의 숫자만의 길이를 조회하시오
SELECT LENGTH(REPLACE(PHONE,'.','')) FROM employees;

사원의 이름의 길이가 5 이상인 행을 출력하시오
SELECT * 
FROM EMPLOYEES
WHERE LENGTH(FIRST_NAME) >=5 ;
``` 
> ### LENGTH 함수는 수자 비교가 가능하다.   

_LENGTH 함수와 LENGTHB 함수 비교하기_
```
SELECT LENGTH('한글'),LENGTHB('한글')
FROM DUAL;
-- 2  /  6
LENGTHB 는 byte 수를 반환하는데
CharSet ANSI 일 경우에는 2byte 단위
        UTF-8일 경우에는 3byte 단위
```
<br>

## `문자열의 일부를 추출하는 함수`   
> ### SUBSTR(문자열 데이터,시작위치,추출 길이)   
__주의할점 시작 위치가 1부터 시작이다__
```
//문자열 추출함수 SUBSTR(문자열,시작위치,길이)
시작 위치가 음수일 경우에는 
마지막 위치부터 거슬러 올라간 위치에서 시작

SELECT SUBSTR('HELLO',1,3) FROM DUAL; // HEL
SELECT SUBSTR('HELLO',3) FROM DUAL; // LLO
SELECT SUBSTR('HELLO',-1) FROM DUAL; // O
SELECT SUBSTR('HELLO',-3) FROM DUAL; // LLO
SELECT SUBSTR('HELLO',-LENGTH('HELLO')) FROM DUAL; // HELLO
SELECT SUBSTR('HELLO',-LENGTH('HELLO'),2) FROM DUAL; // HE 

만약에 값이 없을 경우에는 NULL이 나온다.
SELECT SUBSTR('HELLO',-6) FROM DUAL; //(NULL)

모든 학생의 이름과 출생 월만을 조회하시오.
SELECT NAME,SUBSTR(BIRTHDAY,3,2) MONTH FROM MEMBERS;

모든 회원중에서 전화번호가 011로 시작하는 회원의 정보를 출력;
SELECT * FROM EMPLOYEES WHERE SUBSTR(PHONE,1,3)='515';
SELECT * FROM EMPLOYEES WHERE PHONE LIKE '515%';

회원 중에서 생년 월이 7,8,9월인 회원의 모든 정보를 출력하시오
SELECT * From EMPLOYEES WHERE SUBSTR(HIRE_DATE,4,2) BETWEEN 7 AND 9;
SELECT * From EMPLOYEES WHERE SUBSTR(HIRE_DATE,4,2) IN('07','08','09');

전화번호를 등록하지 않은 회원중에서 생일이 7,8,9월인 출력
SELECT * FROM EMPLOYEES WHERE SUBSTR(HIR_DATE,4,2) IN('07'',08','09')
AND PHONE IS NULL;
```
<br>

## `문자열 데이터 안에서 특정 문자 위치를 찾는 함수`   
> 찾으려는 문자가 문자열 데이터에 없으면 0을 반환    
```
INSTR([대상 문자열 데이터(필수)],
      [위치를 찾으려는 부분 문자(필수)],
      [위치 찾기를 시작할 대상 문자열 데이터 위치(선택,기본은 1)],
      [시작 위치에서 찾으려는 문자가 몇 번째인지 지정(선택,기본은 1)])

INSTR(문자열,'e',1,1);

Hello, My Favorite Player, Faker
^^
AB
세번째 인자 1은 찾기 시작할 인덱스를 나타내고
네번째 인자 1은 세번째 인자부터 'e'를 찾는데 거기서 1번째 'e'위치를 반환

INSTR(문자열,'e',4,2);

Hello, My Favorite Player, Faker
   ^             ^     ^
   A             B     C
4 = A, 즉 어디서 부터 찾을지 인덱스를 작성,
B = A 이후에 첫번째에 나온 'e' 
2 = C 2가 결국 두번째에 나온 'e'의 위치를 반환.

**주의할점**
세번째 인자가 0보다 작을경우
뒤에서부터 인덱스를 세면서 시작지점을 잡는다.
그리고 검색 방향이 <-----으로 된다.

```
```
SELECT INSTR('ALL WE NEED TO IS JUST TO...','TO) FROM DUAL;
내가 문자열에서 to라는 문자가 있으면 그 문자의 위치를 반환(첫번째)

SELECT INSTR('ALL WE NEED TO IS JUST TO...','TO') FROM DUAL; //13
SELECT INSTR('ALL WE NEED TO IS JUST TO...','TO',15) FROM DUAL; //24
--15는 OFFSET처럼 검색할위치를 정해줌

SELECT INSTR('ALL WE NEED TO IS JUST TO...','TO',1,2) FROM DUAL; 
찾앗으면 카운트를해서 그 순번에 있는 위치를 반환

회원의 전화번호에서 두번째 . 문자가 존재하는 위치를 출력하시오
SELECT DISTINCT INSTR(PHONE,'.',1,2) FROM EMPLOYEES; -- 8 OR 7

회원의 전화번호에서 첫 번째 구분자와 두번째 구분자 사이의 간격은
SELECT DISTINCT INSTR(PHONE,'.',1,2)-INSTR(PHONE,'.')-1 FROM EMPLOYEES; -- 8 OR 7

-1의 이유는 첫번째 위치가 구분자부터 시작되기 때문이다.

회원의 전화번호에서 가운데 사이의 국번을 출력하세요.
SELECT DISTINCT 
SUBSTR
(
    PHONE,
    INSTR(PHONE,'.')+1,
    INSTR(PHONE,'.',1,2)-INSTR(PHONE,'.')-1
)
FROM EMPLOYEES;
```
`특정 문자를 포함하고 있는 행 찾기`
```
사원 이름에 문자 S가 있는 행 구하기

1.INSTR
SELECT *
FROM EMPLOYEES
WHERE INSTR(FIRST_NAME,'S')>0;

2.LIKE
SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME LIKE '%S%';
```
