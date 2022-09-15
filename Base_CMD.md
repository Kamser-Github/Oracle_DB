# 기본 명령어.

`WINDOW CMD에서 기본값 세팅하기`
1. 로그인 관련   

    ```
    SHOW user //현재 접속중인 ID 확인

    CONN C##[ID]/[PW] //해당 아이디로 로그인 변경

    DROP user C##[ID] //해당 아이디 삭제

    CREATE USER C##[ID] IDENTIFIED BY [PW] // 아이디/비번으로 생성

    GRANT CONNECT,RESOURCE,DBA TO C##[ID] // ID에게 권한 부여 명령어

    ```
2. Set size
    ```
    현재 Set SIZE 확인하기
    show pagesize // 보여지는 DB 목록 개수를 확인
    show linesize // 보여지는 테이블의 총 길이를 확인

    SIZE 변경하기
    set pagesize [페이지 크기]
    set linesize [테이블 크기]
    column [컬럼명] format [크기값] //a10,a20... or 9999(천자리까지)

    ex)
    set pagesize 100 // 100줄 마다 스키마가 재 출력
    set linesize 200 // 테이블의 길이를 정한다.
    column table_name format a20 // table_name 길이를 20으로 변경
    ```
       
3. TABLE 만들기.
    ```
    CREATE TABLE [테이블명]
    (
        [컬럼명] [컬럼타입] [컬럼 키]
    );

    ex)

    CREATE TABLE users
    (
        id NVARCHAR2(20) PRIMARY KEY
    );

    //주의할점
    마지막 속성에는 ,를 빼야하며
    () 괄호 마지막에는 항상 ;로 마무리를 해야한다.
    여기서 
    ```
4. COLUMN TYPE
    ```
    가변 문자열
    VARCHAR2(BYTE 길이) => 한글일 경우 글자당 2BYTE 차지
    NVARCHAR2(CHAR 길이) => char 기준으로 글자수로 계산

    고정 문자열
    CHAR(N) => 초과하지않으면 항상 그 길이를 차지.
    NCHAR(N) => char 기준으로 글자수 계산

    숫자
    정수 : INTEGER // 범위는 -21억~21억
    숫자 : NUMBER(byte 길이)
    실수 : FLOAT
    긴수 : LONG (INTEGER를 벗어난 길이) 테이블에 하나만 사용가능
    긴수 : CLOB (추가된 타입 제약없이 사용 가능한 긴수)

    날짜
    DATE : 날짜 (년-월-일-요일)
    TIMESTAMP : 날짜 ( 현재 시간 초까지 찍힘)

    파일 : BLOB(대용량 바이너리 오브젝트 데이터)
    JSON OBJ : JSON(JavaScript Object Notation)
    ```
5. KEY 종류
    ```
    CREATE TABLE positions
    (
        pos_code CHAR(2) PRIMARY KEY,
        pos_name NVARCHAR2(20) NOT NULL DEFAULT 'INFO',
        pos_number NUMBER(2) UNIQUE,
        pos_mean NVARCHAR2(20),
        FOREIGN KEY(pos_mean) REFERENCES 참조테이블[참조컬럼]
    );

    1.PRIMARY KEY(PK)
    해당 테이블에서 유일한 값으로 존재
    기본 제약 NOT NULL

    2.NOT NULL
    해당 컬럼에서 무조건 값을 넣어야함.

    3.DEFAULT '해당 타입'
    해당 컬럼에서 아무 값을 안넣을 경우 자동으로 삽입

    4.UNIQUE
    해당 컬럼에서 유일한 값으로 존재하나.
    기본 제약 NULL도 가능.

    5.FOREIGN KEY
    참조테이블[참조컬럼]에서 값을 가져옴
    대신 참조컬럼의 타입과 길이는 일치해야한다.
    ```
6. ALTER   
`테이블의 속성과 구조를 변경`
    ```
    1.컬럼명 변경
    ALTER TABLE [테이블명] RENAME COLUMN [수정전컬럼] TO [수정후컬럼]
    ex)
    ALTER TABLE player RENAME COLUMN name TO first_name;

    2.만들어진 TABLE에 컬럼 추가.
    ALTER TABLE [테이블명] ADD [추카 컬럼명] [타입] [키값];
    ex)
    ALTER TABLE player ADD email NVARCHAR2(20);
    ALTER TABLE test ADD name VARCHAR2(20) DEFAULT 'ANONNYMOUS';

    3.컬럼 삭제
    ALTER TABLE [테이블명] DROP COLUMN [컬럼명];
    ALTER TABLE player DROP COLUMN email;

    4.컬럼의 타입변경
    //해당 열은 비워져 있어야한다.
    ALTER TABLE [테이블명] MODIFY [컬럼명] 타입[속성] 키값;
    ALTER TABLE player MODIFY AGE CHAR(3);

    5.컬럼에 제약추가하기
    ALTER TABLE [테이블명]
    ADD CONSTRAINT [FK명] FOREIGN KEY(컬럼명) REFERENCES 참조테이블[참조컬럼명];
    ```

7. SELECT 
    `원하는 조건의 정보를 검색해서 보여준다`
    ```
    * = ALL
    SELECT [보고싶은 컬럼명] FROM [해당 컬럼 테이블명];
    SELECT * FROM employees;

    //특정 컬럼만 여러개를 보고싶은 경우
    SELECT [컬럼명],[컬럼명],[컬럼명] FROM [해당 컬럼 테이블명];
    SELECT employee_id,first_name,manager_id FROM employees;
    ```

    (추후 공부할때마다 추가할 예정)

    