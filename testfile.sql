SELECT ':))', grouping(A), A, grouping(B), B
FROM (SELECT count(DISTINCT DUMMY) A,
             count(DUMMY)          B
      FROM DUAL)
GROUP BY GROUPING SETS ((A, B), A, B, ());

SELECT EMPLOYEE_ID, 'Nothing' AS LAST_NAME
FROM EMPLOYEES
UNION ALL
SELECT NULL, 'Nothing' AS LAST_NAME
FROM DUAL
ORDER BY 1;

SELECT *
FROM EMPLOYEES
    MODEL DIMENSION BY (EMPLOYEE_ID)
        MEASURES (LAST_NAME)
        RULES (LAST_NAME[any] = 'Nothing',
        LAST_NAME[NULL] = 'Nothing')
ORDER BY 1;

SELECT F AS FCK
FROM REG_TEST
WHERE regexp_like(F, '^([^\-\.][a-z0-9\.\-]*?[^\-\.]+)');

CREATE TABLE REG_TEST
(
    F VARCHAR2(20)
);
SELECT *
FROM REG_TEST;

INSERT INTO REG_TEST (F)
VALUES ('12');
INSERT INTO REG_TEST (F)
VALUES ('ab');
INSERT INTO REG_TEST (F)
VALUES ('12-ab');
INSERT INTO REG_TEST (F)
VALUES ('ab-12');
INSERT INTO REG_TEST (F)
VALUES ('1 2');
INSERT INTO REG_TEST (F)
VALUES ('a b');
INSERT INTO REG_TEST (F)
VALUES ('1.a');
INSERT INTO REG_TEST (F)
VALUES ('a.1');

WITH TMP AS (
    SELECT 1 EID, 1 DID, 100 SAL
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 100
    FROM DUAL
    UNION ALL
    SELECT 3, 1, 200
    FROM DUAL
    UNION ALL
    SELECT 4, 2, 300
    FROM DUAL
    UNION ALL
    SELECT 5, 2, 200
    FROM DUAL
),
     TMP2 AS (
         SELECT EID, trunc(avg(SAL) OVER (ORDER BY SAL RANGE UNBOUNDED PRECEDING )) AVG
         FROM TMP
     )
SELECT AVG
FROM TMP2
WHERE EID = 5;

WITH TMP AS (
    SELECT 1 EID, 1 DID, 100 SAL
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 100
    FROM DUAL
    UNION ALL
    SELECT 3, 1, 200
    FROM DUAL
    UNION ALL
    SELECT 4, 2, 300
    FROM DUAL
    UNION ALL
    SELECT 5, 2, 200
    FROM DUAL
)
SELECT EID, trunc(avg(SAL) OVER (ORDER BY SAL RANGE UNBOUNDED PRECEDING )) AVG
FROM TMP;


ALTER SESSION SET nls_language = 'russian';
SELECT to_char(sysdate, 'DDSPth Month')
FROM DUAL;

CREATE TABLE TAB3
(
    ID  NUMBER,
    VAL VARCHAR2(15)
);

COMMIT;

SELECT *
FROM TAB1;

INSERT INTO TAB2
VALUES (1, 'sr');

DELETE
FROM TAB1
WHERE ID = 1;

SAVEPOINT B;

ROLLBACK TO SAVEPOINT A;

WITH TMP AS (
    SELECT 1 ID1, 3 ID2, 2 ID3
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 3
    FROM DUAL
    UNION ALL
    SELECT 3, 2, 4
    FROM DUAL
    UNION ALL
    SELECT 4, 4, NULL
    FROM DUAL
)
SELECT LEVEL, ID1, ID2, ID3
FROM TMP
WHERE ID2 != 2
CONNECT BY PRIOR ID3 = ID1
       AND ID2 != 2;


CREATE TABLE EMP_TEST
AS
SELECT *
FROM EMPLOYEES;

SELECT EMPLOYEE_ID, LAST_NAME, JOB_ID, NEW_EMPLOYEE_ID
FROM EMPLOYEES
    MODEL DIMENSION BY (EMPLOYEE_ID)
        MEASURES (LAST_NAME, JOB_ID, EMPLOYEE_ID NEW_EMPLOYEE_ID)
        RULES (NEW_EMPLOYEE_ID [any] = NEW_EMPLOYEE_ID[cv()] * 10)
ORDER BY 1;

SELECT EMPLOYEE_ID,
       LAST_NAME,
       JOB_ID,
       EMPLOYEE_ID * 10 NEW_EMPLOYEE_ID
FROM EMPLOYEES
ORDER BY 1;

SELECT F AS FCK
FROM REG_TEST
WHERE regexp_like(F, '^[[:digit:][:alpha:]]([[:digit:][:alpha:].-]*[[:digit:][:alpha:]])?');

SELECT *
FROM REG_TEST;

WITH TMP AS (
    SELECT 1 EID, 1 DID, 100 SAL
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 100
    FROM DUAL
    UNION ALL
    SELECT 4, 1, 100
    FROM DUAL
    UNION ALL
    SELECT 3, 1, 200
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 100
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 100
    FROM DUAL
    UNION ALL
    SELECT 4, 2, 300
    FROM DUAL
    UNION ALL
    SELECT 5, 2, 200
    FROM DUAL
)
SELECT EID, count(SAL) OVER (PARTITION BY DID ORDER BY SAL RANGE 2 PRECEDING ) SUM
FROM TMP;

CREATE SEQUENCE AUTO_EMP
    INCREMENT BY 10
    START WITH 5;

DROP SEQUENCE AUTO_EMP;

SELECT AUTO_EMP.CURRVAL
FROM DUAL;

WITH TEST AS (
    SELECT 1 A, 2 B
    FROM DUAL
    UNION
    SELECT 2, 1
    FROM DUAL
    UNION
    SELECT 3, 2
    FROM DUAL
)
SELECT A,
       B,
       LEVEL,
       CONNECT_BY_ISCYCLE          CYCLE,
       sys_connect_by_path(A, '>') CON
FROM TEST
START WITH A = 1
CONNECT BY NOCYCLE PRIOR A = B;

SELECT SYSdate + 2 D
FROM DUAL
CONNECT BY LEVEL <= 5;

WITH T AS (SELECT SYSdate + 2 D
           FROM DUAL
           CONNECT BY LEVEL <= 5)
SELECT D,
       ntile(3) OVER (ORDER BY D DESC) N
FROM T
ORDER BY 1 DESC;

SELECT LOCATION_ID
FROM EMPLOYEES
         JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
WHERE LAST_NAME = 'Hartstein'
   OR LAST_NAME = 'Fay';

SELECT CITY
FROM LOCATIONS
WHERE LOCATION_ID = 1800;

SELECT ':))', grouping(A), A, grouping(B), B
FROM (SELECT count(DISTINCT DUMMY) A,
             count(DUMMY)          B
      FROM DUAL)
GROUP BY CUBE (A), GROUPING SETS ((A, B), B, NULL);

SELECT C A, B
FROM (SELECT 1 A
      FROM DUAL
      UNION ALL
      SELECT 2
      FROM DUAL
      UNION ALL
      SELECT NULL
      FROM DUAL) TEMP
    MODEL DIMENSION BY (A C)
        MEASURES ('!' AS B)
        RULES (B[any] = '@')
ORDER BY 1 DESC;

WITH TMP AS (
    SELECT '12' AS STR
    FROM DUAL
    UNION ALL
    SELECT 'ab' AS STR
    FROM DUAL
    UNION ALL
    SELECT '12-ab' AS STR
    FROM DUAL
    UNION ALL
    SELECT 'ab-12' AS STR
    FROM DUAL
    UNION ALL
    SELECT '1 2' AS STR
    FROM DUAL
    UNION ALL
    SELECT 'a b' AS STR
    FROM DUAL
    UNION ALL
    SELECT '1.a' AS STR
    FROM DUAL
    UNION ALL
    SELECT 'a.1' AS STR
    FROM DUAL
)

SELECT ROWNUM,
       STR,
       REGEXP_REPLACE(
               REGEXP_REPLACE(STR,
                              '(\A[a-zA-Z0-9]{1})([a-zA-Z0-9.-]*)([a-zA-Z0-9]{1})', 'MATCH'), ' ', '!')
FROM TMP;

WITH TMP AS (
    SELECT 1 EID, 1 DID, 100 SAL
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 100
    FROM DUAL
    UNION ALL
    SELECT 3, 1, 200
    FROM DUAL
    UNION ALL
    SELECT 4, 2, 300
    FROM DUAL
    UNION ALL
    SELECT 5, 2, 200
    FROM DUAL
)
SELECT EID, trunc(avg(SAL) OVER (ORDER BY DID DESC RANGE UNBOUNDED PRECEDING)) AVG
FROM TMP;

ALTER SESSION SET nls_language = 'russian';
SELECT to_char(sysdate - 10, 'fmDDSPth        MONth')
FROM DUAL;

GRANT CREATE VIEW TO PUBLIC
    WITH GRANT OPTION;

WITH TMP AS (
    SELECT 1 ID1, 3 ID2, 2 ID3
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 3
    FROM DUAL
    UNION ALL
    SELECT 3, 2, 4
    FROM DUAL
    UNION ALL
    SELECT 4, 4, NULL
    FROM DUAL
)
SELECT sys_connect_by_path(ID2, '=>') A, LEVEL
FROM TMP
WHERE ID2 != 4
CONNECT BY PRIOR ID3 = ID1
       AND ID2 != 2
ORDER BY length(1);

SELECT extract(DAY FROM last_day(sysdate)),
       to_char(to_date('01.01.0000', 'DD.MM.SYYYY') - extract(DAY FROM last_day(sysdate)), 'DD.MM.SYYYY')
FROM DUAL;

WITH TMP AS (
    SELECT '12' AS STR
    FROM DUAL
    UNION ALL
    SELECT 'ab' AS STR
    FROM DUAL
    UNION ALL
    SELECT '12-ab' AS STR
    FROM DUAL
    UNION ALL
    SELECT 'ab-12' AS STR
    FROM DUAL
    UNION ALL
    SELECT '1 2' AS STR
    FROM DUAL
    UNION ALL
    SELECT 'a b' AS STR
    FROM DUAL
    UNION ALL
    SELECT '1.a' AS STR
    FROM DUAL
    UNION ALL
    SELECT 'a.1' AS STR
    FROM DUAL
)

SELECT ROWNUM,
       STR,
       REGEXP_REPLACE(
               REGEXP_REPLACE(STR,
                              '^((([[:alnum:]])([[:alnum:]]|\.|-)*([[:alnum:]])))', 'MATCH'), ' ', '!')
FROM TMP;

WITH TMP AS (
    SELECT 1 EID, 1 DID, 100 SAL
    FROM DUAL
    UNION ALL
    SELECT 2, 1, 100
    FROM DUAL
    UNION ALL
    SELECT 3, 1, 200
    FROM DUAL
    UNION ALL
    SELECT 4, 2, 300
    FROM DUAL
    UNION ALL
    SELECT 5, 2, 200
    FROM DUAL
)
SELECT EID, sum(SAL) OVER (PARTITION BY DID ORDER BY SAL DESC RANGE 2 PRECEDING) SUM
FROM TMP;

WITH A AS (
    SELECT 1 A, 2 B, 3 C
    FROM DUAL
    UNION ALL
    SELECT 1, 1, 3
    FROM DUAL
    UNION ALL
    SELECT 1, 2, 1
    FROM DUAL
    UNION ALL
    SELECT 1, 2, 3
    FROM DUAL
    UNION ALL
    SELECT 2, 2, 3
    FROM DUAL
    UNION ALL
    SELECT 1 A, 2 B, 3 C
    FROM DUAL
)
SELECT A, B, count(C)
FROM A
GROUP BY CUBE (A, B), A, ROLLUP (B, A);

SELECT months_between(to_date('10.01.0001', 'DD.MM.SYYYY'), to_date('10.12.-0001', 'DD.MM.SYYYY'))
FROM DUAL;

WITH TEST AS (SELECT 1 A, 2 B
              FROM DUAL
              UNION
              SELECT 2, 1
              FROM DUAL
              UNION
              SELECT 3, 2
              FROM DUAL)
SELECT PRIOR A, PRIOR B, LEVEL, CONNECT_BY_ROOT A B
FROM TEST
START WITH A = 1
CONNECT BY NOCYCLE PRIOR A = B;

WITH T AS (SELECT CONNECT_BY_ROOT (sysdate + LEVEL) - CONNECT_BY_ROOT sysdate + LEVEL D
           FROM DUAL
           CONNECT BY LEVEL <= 5)
SELECT D,
       ntile(2) OVER (ORDER BY D DESC) N
FROM T
ORDER BY 1 DESC;

SELECT ':))', grouping(A), A, grouping(B), B
FROM (SELECT count(DISTINCT DUMMY) A,
             count(DUMMY)          B
      FROM DUAL)
GROUP BY CUBE (NULL), GROUPING SETS ((NULL, B), A, B);

SELECT ':))', grouping(A), A, grouping(B), B
FROM (SELECT count(DISTINCT DUMMY) A,
             count(DUMMY)          B
      FROM DUAL)
GROUP BY CUBE (a, a), GROUPING SETS (a, b);
