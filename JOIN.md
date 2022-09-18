`테이블 유저와 테이블명 제약조건 확인하는 방법`

> 연습해야하는 구문이기때문에 따로 저장


```
  SELECT AA.COLUMN_ID,
         AA.COLUMN_NAME,
         BB.COMMENTS,
         AA.DATA_TYPE,
         AA.DATA_LENGTH,
         AA.DATA_DEFAULT,
         CC.PK,
         AA.NULLABLE,
         CC.FK
    FROM ALL_TAB_COLUMNS AA,
         ALL_COL_COMMENTS BB,
         (SELECT A.OWNER,
                 A.TABLE_NAME,
                 A.CONSTRAINT_TYPE,
                 COLUMN_NAME,
                 POSITION,
                 CASE WHEN A.CONSTRAINT_TYPE = 'P' THEN 'Y' END AS PK,
                 CASE WHEN A.CONSTRAINT_TYPE = 'R' THEN 'Y' END AS FK
            FROM ALL_CONSTRAINTS A, ALL_CONS_COLUMNS B
           WHERE     UPPER (A.OWNER) = UPPER ('테이블유저명')
                 AND A.TABLE_NAME = UPPER ('테이블명')
                 AND A.TABLE_NAME = B.TABLE_NAME
                  AND A.CONSTRAINT_NAME = B.CONSTRAINT_NAME
                 AND A.CONSTRAINT_TYPE IN ('P', 'F')) CC
   WHERE     UPPER (AA.OWNER) = UPPER ('테이블유저명')
         AND UPPER (AA.TABLE_NAME) = UPPER ('테이블명')
         AND AA.OWNER = BB.OWNER
         AND AA.TABLE_NAME = BB.TABLE_NAME
         AND AA.COLUMN_NAME = BB.COLUMN_NAME
         AND AA.OWNER = CC.OWNER(+)
         AND AA.TABLE_NAME = CC.TABLE_NAME(+)
         AND AA.COLUMN_NAME = CC.COLUMN_NAME(+)
ORDER BY COLUMN_ID
```