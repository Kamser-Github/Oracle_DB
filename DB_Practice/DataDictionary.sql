/*
    System Date
    옷 <-> Oracle DBMS <-> 사용자 데이터
    
    사용자의 정보, 권한, 테이블, 뷰, 제약조건, 함수등을 저장할
    데이터 공간이 DBMS에는 필요한데
    이것을 Data Dictionary라고 한다.
    
    뷰에서 테이블 여러개의 정보를 한곳에 보는거도 있지만
    뷰에서 하나의 테이블에서 더 작은 범위를 지정해서 볼수있는데
    보안의 영역으로 다 보여주지 않을수 있다.
    뷰는 또는 읽기전용이다.
    
    이 방식이 Data Dictionany다
    SELECT COUNT(*) FROM DICT; // 총 4911개가 있다.
*/