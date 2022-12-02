# `정규식으로 값 변경해보기`
> ## LIKE,REPLACE,INSTR,SUBSTR,COUNT    
```SQL
정규식에는 메타문자와 리터럴 문자가 존재
--메타문자
검색 알고리즘을 지정하는 연산자

--리터럴문자
검색중인 일반적인 문자
```
<table border="1" style="margin:auto;">
    <thead>
        <tr>
            <th style="width:20vh">메타문자</th>
            <th style="width:50vh">설명</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <th>.</th>
            <th>임의의 한 문자</th>
        </tr>
        <tr>
            <th>?</th>
            <th>앞 문자가 없거나 하나 있음(0 또는 1번발생)</th>
        </tr>
        <tr>
            <th>+</th>
            <th>앞 문자가 하나 이상 있음</th>
        </tr>
        <tr>
            <th>*</th>
            <th>앞 문자가 0개 이상 있음</th>
        </tr>
        <tr>
            <th>{num}</th>
            <th>선행 표현식이 정확이 num번 발생</th>
        </tr>
        <tr>
            <th>{num,}</th>
            <th>선행 표현식이 최소 num번 이상발생</th>
        </tr>
        <tr>
            <th>{min,max}</th>
            <th>선행 표현식이 최소 min번 이상,max번 이하 발생</th>
        </tr>
        <tr>
            <th>[...]</th>
            <th>괄호 안의 리스트에 있는 임의의 단일 문자와 일치</th>
        </tr>
        <tr>
            <th>|</th>
            <th>OR 를 나타냄 </th>
        </tr>
        <tr>
            <th>(...)</th>
            <th>괄호로 묵인 표현식을 한 단위로 묶는다</th>
        </tr>
        <tr>
            <th>^</th>
            <th>문자열 시작 부분과 일치</th>
        </tr>
        <tr>
            <th>[^]</th>
            <th>해당 문자에 해당하지 않는 한문자(NOT)</th>
        </tr>
        <tr>
            <th>$</th>
            <th>문자열의 끝 부분과 일치</th>
        </tr>
        <tr>
            <th>\</th>
            <th>표현식에서 후속 문자를 리터럴로(일반 문자)처리</th>
        </tr>
        <tr>
            <th>\n</th>
            <th>괄호 안에 그룹화된 n 번째(1-9)선행 하위식과 일치</th>
        </tr>
        <tr>
            <th>\d</th>
            <th>숫자 문자</th>
        </tr>
        <tr>
            <th>[:class:]</th>
            <th>지정된 POSIX문자 클래스에 속한 임의의 문자와 일치<br>
                [:alpha:] 알파벳 문자<br>
                [:digit:] 숫자<br>
                [:lower:] 소문자 알파벳 문자<br>
                [:upper:] 대문자 알파벳 문자<br>
                [:alnum:] 알파벳/숫자<br>
                [:space:] 공백문자<br>
                [:punct:] 특수문자<br>
                [:cntrl:] 컨트롤 문자<br>
                [:print:] 출력 가능한 문자<br>
            </th>
        </tr>
        <tr>
            <th>[^:class:]</th>
            <th>괄호안의 리스트에 없는 임의의 단일 분자와 일치</th>
        </tr>
    </tbody>
</table>
<br>
<br>

> ## REGEXP_LIKE
> CONSTRAINT CHECK OR 검색할때 사용.
```SQL
SELECT
    REGEXP_LIKE(source_string, search_pattern [, match_parameter])
 FROM DUAL;

Oracle REGEXP_LIKE() 함수는 LIKE 연산자의 고급 버전입니다. 
REGEXP_LIKE() 함수는 정규식 패턴과 일치하는 행을 반환합니다.

