# 데이터 정의어
> 핵심 포인트
```
1. 데이터 정의어 사용후 자동으로 발생하는 COMMIT
2. CREATE문으로 테이블생성
3. DROP으로 테이블삭제
```

## 객체를 생성,변경,삭제하는 데이터 정의어
> 데이터정의어(DDL : Data Definition Language)

### `데이터 정의어를 사용할때 유의점`
```
데이터 조작어 DML(DELETE,UPDATE,INSERT)과 달리
명령어를 수행하자마자 바로 반영(COMMIT)이 된다.

ROLLBACK을 통한 실행 취소가 불가능하다.

즉
SQL> INSERT...
SQL> UPDATE..
SQL> DELETE...
SQL> DDL...

사용과 동시에 COMMIT 효과

----------------영수증 출력
새로운 트랜잭션 시작
```

### `테이블 생성 : CREATE`
```
오라클 데이터베이스 객체를 생성하는데  사용하는 명령어
```
> 기본 형식
```
CREATE TABLE 소유 계정.테이블 이름(
    열1이름' '열1자료형,
    열2이름' '열2자료형,
    열3이름' '열3자료형,
       :         :
);
```
> ## 테이블 이름 규칙
```
1. 테이블 이름은 문자로 시작(한글도 가능)
    ex)TABLE1(O) 1TABLE(X)
2. 테이블 이름은 128byte 이하(영어 128자,한글 128/3byte자)
3. 소유자는 중복된 테이블을 가질수 없다.
4. 숫자와 특수문자($,#,_)가 첫글자이후에 사용가능
5. SQL키워드로는 생성 불가
    단 예약어와 이름이 같을시 " "안에 집어넣으면 된다.
    " "안에 있을경우 대소문자를 구별한다
```
### `자료형을 정의해서 테이블 생성`
```
CREATE TABLE EMP_DDL
(
    NO  NUMBER(2),
    HIRE_DATE   DATE,
    JOB NVARCHAR(20),
);
```

### `기존 테이블 열 구조와 데이터를 새 테이블 복사`
```
CREATE TABLE EMP_COPY
AS SELECT * FROM EMP;
```
### `기존 테이블 열 구조와 일부 데이터를 새 테이블 복사`
```
CREATE TABLE EMP_COPY
AS SELECT * FROM EMP
WHERE MANAGER_ID=1;
```
### `기존 테이블 열 구조만 새 테이블 복사`
```
CREATE TABLE EMP_COPY
AS SELECT * FROM EMP
WHERE 1<>1;
```
<br>
<br>

## 테이블을 변경하는 ALTER   
<br>

### `테이블에 열을 추가하는 ADD`   
```
ALTER TABLE [테이블 명] ADD [추가할 열이름] [열의 자료형]

ALTER TABLE EMP_COPY ADD AGE NUMBER(3);
```
### `이름을 변경하는 RENAME`     
> 열의 이름을 변경
```
ALTER TABLE [테이블 명] RENAME COLUMN [기존 열이름] TO [변경 열이름]

ALTER TABLE RENAME COLUMN AGE TO WORK_YEAR;
```
> 테이블의 이름을 변경
```
RENAME [기존 테이블명] TO [변경 테이블명];
RENAME EMP_COPY TO EMP_RENAME;
```

### `열의 자료형을 변경 MODIFY`
```
자료형을 변경할때는 기존 자료형보다 작은 범위로 변경이 불가능하다
즉 제약 조건이나 크기,타입을 변경할수가 없다는것

ALTER TABLE [테이블명] MODIFY [컬럼명] [변경 자료형]
ALTER TABLE EMP_COPY MODIFY PHONE NUMBER(15);
```
### `삭제 DROP`
> 특정 열을 삭제
```
ALTER TABLE [테이블 명] DROP COLUMN [컬럼명];
ALTER TABLE EMP_COPY DROP COLUMN PHONE;
```
> 특정 테이블을 삭제
```
DROP TABLE [테이블 명];
DROP TABLE EMP_RENAE;
```
### `테이블의 데이터를 삭제 TRUNCAKE`
```
특정 테이블의 데이터를 삭제
DELETE 다른점은 

>> 바로 COMMIT이 되기에

>> ROLLBACK이 불가능하다.

TRUNCAKE TABLE [테이블 명];
TRUNCAKE TABLE EMP_RENAME;
```

>> 정리
```
테이블의 열을 수정할땐 ALTER
테이블 자체를 수정할때는 ALTER 명령어를 제외하고 사용
```


