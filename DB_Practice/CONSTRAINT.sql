/*
    제약 조건
    데이터를 입력을 할때 제약을 걸겠다는것.
    데이터를 private -> set으로 하겠다.
    
    도메인 > 엔티티 > 릴레이션 
    
    도메인 제약 조건 
    도메인 ? 
    COLUMN의 유효한 값의범위를 지정하는데
    학번 : 0 보다 큰 정수
    납입금 : 0 보다 크고 100만 보다 작은 정수
    이름 : 20자 내의 문자
    납입일 : 2012년 이후 날짜.
    
    값들 컬럼의 유효한 값의 범위를 도메인이라 한다.
    도메인 범위 내에서 값을 범위를 지정해주는것을
    도메인 제약 조건이라한다
    
    NOT NULL > 값을 필수로 넣어야하는 도메인인 경우
    DEFAULT > NOT NULL인데 사용자가 입력을 하는게 아닌 도메인인 경우
    CHECK > 도메인의 범위를 체크하는 조건
    
    1.NOT NULL , DEFAULT 방법
    CREATE TABLE TEST
    (
        ID  VARCHAR2(50) NOT NULL,
        EMAIL VARCHAR2(200) NULL,
        PHONE CHAR(13) NOT NULL
        PWD VARCHAR2(200) DEFAULT '111' //공용계정일경우
    )
    //해당 컬럼에는 반드시 값을 넣어야한다. 안 넣을 경우 ERROR 발생
    
    이미 만들어진 상태라면.
    ALTER TABLE TEST MODIFY EMAIL VARCHAR2(200) NOT NULL;
    ALTER TABLE TEST MODIFY PWD VARCHAR2(200) DEFAULT '111';
    현재 날짜를 디폴트를 할때
    SYSDATE,SYSTIMESTAMP
    
    **꽃**
    --체크 제약조건
    CREATE TABLE TEST
    (
        ID VARCHAR2(50) NULL,
        PHONE VARCHAR2(200) CHECK(PHONE LIKE '010-%-____') NOT NULL,
        EMAIL VARCHAR2(500) NULL
    )
    --전화번호라면 패턴이 있는데 010-0000-0000
    CHECK(PHONE LIKE '010-%-____')
    이런 형태만 들어올수있게 제약을 거는것
    
    체크 제약 조건을 TABLE 생성후 적용할 경우
    ALTER TABLE TEST 
    ADD CONSTRAINT CK_TEST_PHONE [CK_테이블명_컬럼명]
    CHECK(PHONE LIKE '010-%-____');
    
    CREATE TABLE test1
    (
        ID VARCHAR2(20) PRIMARY KEY,
        PWD VARCHAR2(50) NOT NULL,
        GENDER NCHAR(2) CHECK(GENDER IN ('남자' ,'여자')) NOT NULL
    );
    **정규식을 이용한 체크 제약조건
    CREATE TABLE TEST1
    (
        PHONE CHAR(13) CHECK(REGEXP_LIKE(PHONE,'^01[016-9]-\d{3,4}-\d{4}$')) NOT NULL
    );
    
    --제약 조건 삭제
        ALTER TABLE MEMBER
        DROP CONSTRAINT CK_TEST1_PHONE ;
    
    --제약 조건 확인
        SELECT * FROM user_constraints
        WHERE TABLE_NAME = 'TEST1';
    
    --제약 조건 추가
        ALTER TABLE TEST1
        ADD CONSTRAINT CK_TEST1_PHONE CHECK(REGEXP_LIKE(PHONE,'^01[016-9]-\d{3,4}-\d{4}$'));
        
    --제약 조건을 추가할때는 추가하는 컬럼에 다 제약 조건이 걸리면 안된다.
    
    **Entity 제약 조건**
    Primary Key / Unique
    레코드가 쌓이면 컬럼에 데이터가 잘 들어가 있다.
    올바른 값만 잘 들어가 있으면 다 유효할수가 없다.
    동일한 값이 또 들어가게 된다면 중복된 데이터는 어떻게 해야될까?
    식별이 불가능한 레코드가 된다.
    따라서 같은 레코드라고 식별할수 있는게 필요하다.
    테이블 전체에서 식별할수있는 하나의 컬럼이 필요하다.
    식별 컬럼, 식별 KEY라고 한다.
    절대로 중복이 발생할수 없도록 만들어야한다.
    
    CREATE TABLE TEST2
    (
        ID NUMBER ,--PRIMARY KEY, 기본키 제약 조건
        --제약 조건의 이름을 넣고 싶다면.
        --ID NUMBER CONSTRAINT PK_TEST2_ID PRIMARY KEY,
        WRITER_ID NVARCHAR(15) NOT NULL --UNIQUE,
        --여기서 컬럼옆에 제약조건을 붙이면 지저분해보일수 있어서
        --아래에 몰아서 작성도 가능하다.
        CONSTRAINT PK_TEST2_ID PRIMARY KEY(ID),
        CONSTRAINT UK_TEST2_WRITER_ID UNIQUE(WRITER_ID)
    );

    --테이블을 이미 만든 뒤라면, 추가 방법
        ALTER TABLE TEST2
        ADD CONSTRAINT PK_TEST2_ID PRIMARY KEY(ID);
        ALTER TABLE TEST2
        ADD CONSTRAINT UK_TEST2_WRITER_ID UNIQUE(WRITER_ID);
    
    --시퀀스 (Sequence)
        일련번호.
        중복이 안되게 증가를 해야한다.
        다음 값을 얻고 싶다.
        SQL / TOOL로 만들수 잇다.
        
        테이블명_컬럼명_시퀀스
        
        CREATE SEQUENCE SEQ_ID INCREMENT BY 1 START WITH 10000;
        -- INCREMENT BY 1 : 증가값은 1      
        -- START WITH 10000 :  10000부터 증가
    
        
        [사용규칙]
        * NEXTVAL, CURRVAL을 사용할 수 있는 경우   
        - subquery가 아닌 select문   
        - insert문의 select절   
        - insert문의 value절   
        - update문의 set절
        
        * NEXTVAL, CURRVAL을 사용할 수 없는 경우   
        - view의 select절   
        - distinct 키워드가 있는 select문   
        - group by, having, order by절이 있는 select문   
        - select, delete, update의 subquery   
        - create table, alter table 명령의 default값
        
        ** CMD에서는 자동으로 추가할수 없지만
        프로그램에서는 자동으로 추가할수있다
        테이블 -> 테이블명 클릭 -> 
        열 -> 편집 우측하단 -> 
        ID열 -> 열 시퀀스 -> 시퀀스 추가
        **
        
*/
