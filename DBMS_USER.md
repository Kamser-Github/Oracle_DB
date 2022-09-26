# 사용자,권한,롤 관리
> 익혀야 할것
```
-사용자와 권한 관리의 필요성
-객체 관한의 부여와 취소
-롤 개념
```
### `사용자란?`
```
데이터 베이스에 접속하여 데이터를 관리하는 계정을 사용자(USER)라고 한다
```
> 사용자 관리가 필요한 이유
```
한 사용자가(계정)이 여러 종류의 서비스를 관리하기가 어려움
따라서 업무 분할과 효울,보안을 고려하여 여러 사용자로 나눈다

오라클 데이터베이스 객체(뷰,테이블,인덱스등)는 사용자별로 생성됨

1.업무별로 사용자를 생성 -> 사용자 업무에 맞는 데이터 구조를 만들어 관리
2.대표 사용자를 통해 업무에 맞는 구조를 정의 
             ->   사용할수있는 데이터영역을 사용자에게 지정한다.
```
### `데이터 베이스 스키마란?`
```
+ 데이터 베이스의 논리적 정의
+ 데이터 구조와 제약 조건에 대한 명세

-데이터베이스에서 데이터간 관계, 데이터 구조,제약 조건등 
    데이터를 저장 및 관리하기위해 정의한 
        데이터베이스 구조의 범위를 스키마라 한다.

오라클 데이터베이스에서는 사용자와 스키마를 구별하지 않고도 사용

사용자(USER)는 데이터를 사용및 관리하기위해 DB에 접속하는 개체
스키마는 오라클 데이터베이스에 접속한 사용자와 연결된 객체를 의미

C##OT<연습용 계정>

C##OT< 사용자 (USER) >
C##이 생성한 모든 객체는 C##OT의 스키마가 된다.
    모든 객체란 (VIEW,TABLE,INDEX,SEQUENCE,SYNONYM등..)
```

### `사용자 생성`
```
CREATE USER [사용자 이름](필수)<12버전 이후로 C##[아이디] 이다.>
IDENTIFIED BY [패스워드](필수)
*   *   *   *   *   *   *   *   *
DEFAULT TABLESPACE 테이블 스페이스 이름(선택)
TEMPORARY TABLESPACE 테이블 스페이스(그룹) 이름(선택)
QUOTA 테이블 스페이스크기 ON 테이블 스페이스 이름(선택)
PROFILE 프로파일 이름(선택)
PASSWORD EXPIRE(선택)
ACCOUNT [LOOK/UNLOCK](선택);
*   *   *   *   *   *   *   *   *
** 영역은 나중에 추가로 공부예정
```
_사용자 생성은 데이터 베이스 관리 권한을 가진 사용자만 가능_

### `사용자 정보 조회`
```
SELECT * FROM ALL_USERS
WHERE USERNAME = '[사용자명]';
-
SELECT * FROM DBA_USERS
WHERE USERNAME = '[사용자명]';
-
SELECT * FROM DBA_OBJECTS
WHERE OWNER = '[사용자명]';
--

SELECT * FROM DBA_OBJECTS
WHERE OWNER = 'C##OT';
```
### `오라클 사용자의 변경과 삭제`
> 사용자 정보(패스워드) 변경하기 <SYSTEM 관리>
```
ALTER USER [유저 아이디]
IDENTIFIED BY [패스워드];
```
> 오라클 사용자 삭제
```
DROP USER [유저 아이디];

사용자가 접속중이라면 삭제가 안된다.
```
> 오라클 사용자와 객체 모두 삭제
```
DROP USER [유저 아이디] CASCADE;
```
<br><br>

## 권한 관리
```
사용자가 데이터베이스의 모든 데이터를 사용할 수 있다면
데이터의 안전을 보장할수가 없다.

데이터 베이스는 접속 사용자에 따라 데이터영역과 권한을 지정할수있다.

┌─시스템 권한(system privilege)
└─객체 권한(object privilege)

두 가지 권한의 특성이 있고, 권한 부여와 회수를 할수가 있다.
```

### `시스템 권한이란?`
```
▶ 사용자 생성,정보 수정,삭제
▶ 데이터 베이스 접근
▶ 오라클 데이터베이스의 여러 자원과 객체 생성 및 관리등 권한

ANY 키워드가 들어가 있는 권한은
    소유자에 상관없이 사용가능한 권한을 말한다.
```
> 권한부여
```
시스템 권한 분류     시스템 권한         설명
 -----  -----       -----   --          ---
 USER(사용자)       CREATE USER     사용자 생성 권한
                    ALTER USER      생성된 사용자의 정보 수정권한
                    DROP USER       생성된 사용자의 삭제 권한

SEEEION(접속)     CREATE SESSION    데이터베이스 접속 권한
                  ALTER SESSION     데이터베이스 접속 상태에서 환경값 변경 권한

TABLE(테이블)     CREATE TABLE      자신의 테이블 생성 권한
                 CREATE ANY TABLE   임의의 스키마 소유 테이블 생성 권한
                 ALTER ANY TABLE    임의의 스키마 소유 테이블 수정 권한
                 DROP ANY TABLE     임의의 스키마 소유 테이블 삭제 권한
                 INERT ANY TABLE    임의의 스키마 소유 테이블 데이터 삽입 권한
                 UPDATE ANY TABLE   임의의 스키마 소유 테이블 데이터 수정 권한
                 DELETE ANY TABLE   임의의 스키마 소유 테이블 데이터 삭제 권한
                 SELECT ANY TABLE   임의의 스키마 소유 테이블 데이터 조회 권한
            
 INDEX(인덱스)   CREATE ANY INDEX   임의의 시키마 소유 테이블의 인덱스 생성권한
                 ALTER  ANY INDEX   임의의 시키마 소유 테이블의 인덱스 수정권한
                 DROP ANY INDEX     임의의 시키마 소유 테이블의 인덱스 삭제권한

   VIEW(뷰)           생략           뷰에 관련된 권한
SEQUQUENCE(시퀸스)                   시퀸스에 관련된 권한
SYNONYM(동의어)                      동의어에 대한 권한
PROFILE(프로파일)                    사용자 접속 지정과 관련된 여러 권한
    ROLE(롤)                         권한을 묶은 그룹과 관련된 여러 권한
```

### `시스템 권한 부여`
```
GRANT CREATE SESSION TO [사용자 아이디];

데이터 베이스에 접속을 허락하는 명령어
            1                       2
GRANT [시스템권한] TO ([사용자 이름 /롤(Role)/PUBLIC])
          3
[WITH ADMIN OPTION]

1= 시스템 권한 부여할 권한 지정,여러개 경우 ","로 구분

2= 권한을 부여할 대상지정
                        PUBLIC : 모든 사용자에게 부여
            
3= GRANT로 받은 권한을 다른 사람에게 부여할수있는지

```

### `시스템 권한 취소`
```
REVOKE [시스템 권한] FROM [사용자이름/롤이름/PUBLIC]

REVOKE RESOUSE,CREATE TABLE FROM C##OT;
```

### `객체 권한`
> object privilege는 특정 사용자가 생성한 테이블,뷰등과 관련된 권한
```
SCOTT 소유 테이블에 STUDENT 사용자가 SELECT나,INSERT등 작업을 허락

객체 권한분류       객체권한            설명
 ----------         -----               --
 TABLE(테이블)      ATLER          테이블 변경 권한
                   DELETER         테이블 데이터 삭제 권한
                   INDEX           테이블 인덱스 생성 권한
                   INSERT          테이블 데이터 삽입 권한
                 REFERENCES        참조 데이터 생성 권한
                   SELECT          테이블 조회 권한
                   UPDATE          테이블 데이터 수정 권한
    
  VIEW             DELETE          뷰 데이터 삭제 권한
                   INSERT          뷰 데이터 삽입 권한
                 REFERENCES        참조 데이터 생성 권한
                   SELECT          뷰 조회 권한
                   UPDATE          뷰 데이터 수정 권한

 SEQUENCE          ALTER           시퀸스 수정권한
                   SELECT          시퀸스의 CURRVAL,NEXTVAL사용권한
  PROCEDURE        생략            프로시저 관련 권한
  FUNCTION         생략            함수 관련 권한
  PACKAGE          생략            패키지 관련 권한
```
### `객체 권한 부여`
> 객체 권한 부여도 GRANT문 사용
```
GRANT [객체 권한 / ALL PRIVILEGES] - 1
    ON [스키마.객체 이름]          - 2
    TO [사용자 이름,롤이름,PUBLIC] - 3
    [WITH GRANT OPTION]           - 4

1. 객체 권한 지정,여러개일경우","로 구분,
        ALL PRIVILEGES는 객체의 모든 권한을 부여함을 의미(필수)
2. 권한을 부여할 대상 객체를 명시(필수)
3. 권한을 부여하려는 대상 지정,사용자 이름,롤 다수일경우 ","구분
        PUBLIC 모든 사용자에게 권한을 부여하겟다(필수)
4. 다른사람에게 자신이 받은 권한을 다시 줄수잇는데
   자기의 권한이 사라지면 권한을 받은 다른 사람의 권한도 사라진다.
```
> 예시
```
GRANT SELECT ON TEMP TO C##TEST;
>>TEST 사용자에게 TEMP테이블 SELECT권한 부여
GRANT INSERT ON TEMP TO C##TEST;
>>TEST 사용자에게 TEMP테이블 INSERT권한 부여

GRANT SELECT,INSERT ON TEMP TO C##TEST;
>> 위 내용과 동일한데 한 번에 작성
```
### `객체 권한 취소`
> REVOKE 사용
```
ROVOKE [객체 권한/ALL PRIVILEGES](필수)
    ON [스키마.객체 이름](필수)
  FROM [사용자 이름/롤 이름/PUBLIC](필수)
 [CASCADE CONSTRAINTS/FORCE](선택)

 CASCADE 옵션은 더 알아봐야될거같다.
 https://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_9020.htm
 ```
<BR><BR>

## 롤 관리
### `롤 이란?`

```
사용자는 데이터 베이스에서 작업을 진행하기 위해 해당 작업과
관련된 권한을 반드시 부여받아야합니다.

이때 신규사용자가 생기면 시스템에서 권한을 하나하나 다 부여를 해야되는데
이때 권한 부여를 묶어놓은것
```
### `사전정의된 롤`
>CONNECT 롤
```
데이터 베이스에 접속하는데 필요한 권한들

ALTER SESSION,CREAT CLUSTER,CREATE DATABASE LINK,CREATE SEQUENCE
CREATE SESSTION,CREATE SYNONYM,CREATE TABLEM,CREATE VIEW
```
> RESOURCE 롤
```
사용자가 테이블,시퀸스를 비롯한 여러 객체를 생성할수 있는 권한

CRATE TRIGGER,CREATE SEQUENCE,CREATE TYPE,CREATE PROCEDURE,
CREATE CLUSTER,CREATE OPERATION,CREATE INDEXTYPE,CREATE TABLE
```
```
새로운 사용자를 생성하면 CONNECT 롤,RESOURCE 롤을 부여하는 경우가 많다
단
CONNECT 롤에선 VIEW생성,SYNONYM 권한이 제외됨
따로 부여를 해야하낟.
```
> DBA 롤
```
데이터 베이스를 관리하는 대부분을 가지고 있다.
```
### `사용자 정의 롤`
> 사용자가 필요에 의해서 직접 권한을 포함시킨 롤을 말한다
```
1. CREATE ROLE 문으로 롤을 생성
2. GRANT 명령어로 생성한 롤에 권한을 포함
3. GRANT 명령어로 권한이 포함된 롤을 특정 사용자에게 부여
4. REVOKE 명렁어로 롤을 취소시킨다.
```
>롤 생성과 권한 포함
```
데이터 관리 권한이 있는 SYSTEM 계정으로 접속하여 생성

아까 CONNECT , RESOURCE 롤에 제외된 VIEW와,SYNONYM을 추가해서 만든다

CREATE ROLE ROLESTUDY;

GRANT CONNET,RESOURCE,CREATE VIEW,CREATE SYNONYM
    TO ROLESTUDY;
```
> 생성한 롤로 부여해보기
```
GRANT ROLESTUDY TO C##TEST;
```
> 부여된 롤과 권한 확인
```
사용자로 접속 :
SELECT * FROM USER_SYS_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;
```
>부여된 롤 취소
```
REVOKE ROLESTUDY FROM C##TEST;
```
>롤 삭제
```
DROP ROLE ROLESTUDY;
해당 롤을 부여받은 모든 사용자의 롤이 취소가 된다.
```



