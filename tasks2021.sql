/*1.2. В 1845 году в США была установлена традиция,
согласно которой выборы президента проводятся во вторник
после первого понедельника ноября в год, делящийся на 4 без
остатка. Определить, дату ближайших к заданной дате
президентских выборов в США.*/

/*проблема с отрицательными датами и с датами возле нуля*/

-- SELECT TO_CHAR(TO_DATE(${input_date}, 'dd.mm.syyyy'), 'dd.mm.syyyy') AS "Заданная дата"
-- FROM DUAL;
--
-- SELECT TO_NUMBER(SUBSTR(${input_date}, INSTR(${input_date}, '.', -1, 1) + 1)) AS "Заданная дата"
-- FROM DUAL;
--
-- SELECT SUBSTR(${input_date}, INSTR(${input_date}, '.', -1, 1) + 1)
-- FROM DUAL;

SELECT ${input_date} AS "Заданная дата",
       CASE
           WHEN TO_NUMBER(SUBSTR(${input_date}, INSTR(${input_date}, '.', -1, 1) + 1)) < 1847
               THEN '07.10.1848'
           WHEN TO_NUMBER(TO_CHAR(TO_DATE(${input_date}, 'dd.mm.syyyy'), 'fmsyyyy')) > 9997
               THEN '05.11.9996'
           WHEN (MOD(TO_CHAR(TO_DATE(${input_date}, 'dd.mm.syyyy'), 'fmsyyyy'), 4) = 0)
               THEN TO_CHAR(
                       NEXT_DAY(TO_DATE('31.10.' || TO_CHAR(TO_DATE(${input_date}), 'fmsyyyy')), 1) + 1,
                       'dd.mm.syyyy')
           WHEN (MOD(TO_CHAR(TO_DATE(${input_date}), 'fmsyyyy'), 4) = 1)
               THEN TO_CHAR(
                       NEXT_DAY(
                               ADD_MONTHS(TO_DATE('31.10.' || TO_CHAR(TO_DATE(${input_date}), 'fmsyyyy')), -12),
                               1) + 1,
                       'dd.mm.syyyy')
           WHEN (MOD(TO_CHAR(TO_DATE(${input_date}), 'fmsyyyy'), 4) = 3)
               THEN TO_CHAR(
                       NEXT_DAY(ADD_MONTHS(TO_DATE('31.10.' || TO_CHAR(TO_DATE(${input_date}), 'fmsyyyy')), 12),
                                1) + 1,
                       'dd.mm.syyyy')
           WHEN (MOD(TO_CHAR(TO_DATE(${input_date}), 'fmsyyyy'), 4) = 2)
               THEN CASE
                        WHEN (TO_NUMBER(TO_CHAR(TO_DATE(${input_date}), 'fmmm')) < 5)
                            THEN TO_CHAR(
                                    NEXT_DAY(ADD_MONTHS(
                                                     TO_DATE('31.10.' || TO_CHAR(TO_DATE(${input_date}), 'fmsyyyy')),
                                                     -24),
                                             1) + 1,
                                    'dd.mm.syyyy')
                        ELSE TO_CHAR(
                                    NEXT_DAY(ADD_MONTHS(
                                                     TO_DATE('31.10.' || TO_CHAR(TO_DATE(${input_date}), 'fmsyyyy')),
                                                     24),
                                             1) + 1,
                                    'dd.mm.syyyy')
               END
           END       AS "Дата выборов"
FROM DUAL;

/*1.3 В произвольной символьной строке убрать все лидирующие
  и конечные пробелы, а между словами оставить только по одному пробелу. */

/*Если строка содержит звёздочку, то она пропадёт*/

SELECT TRIM(REGEXP_REPLACE('   Sometimes       I like        to lie    '
    , '[[:space:]]{2,}', ' ')) AS RESULT
FROM DUAL;

SELECT CASE
           WHEN INSTR(${random_string}, 'CHAR(17)') = 0
               THEN
               REPLACE(
                       REPLACE(
                               REPLACE(
                                       TRIM(${random_string}),
                                       ' ', 'CHAR(17) '),
                               ' CHAR(17)', ''),
                       'CHAR(17)', '')
           ELSE REPLACE(
                   REPLACE(
                           REPLACE(
                                   TRIM(${random_string}),
                                   ' ', 'CHAR(18) '),
                           ' CHAR(18)', ''),
                   'CHAR(18)', '')
           END AS RESULT
FROM DUAL;

-- SELECT REPLACE(
--                REPLACE(
--                        REPLACE(REPLACE(TRIM('   Sometimes     I like         to  lie    '), '*', '(*)'), ' ', ' *'),
--                        ' *', ''),
--                '*', '') AS RESULT
-- FROM DUAL;
--
-- SELECT REPLACE(REPLACE(REPLACE(TRIM('   Sometimes     I like         to  lie    '), '*', '(*)'), ' ', ' *'),
--                '') AS RESULT
-- FROM DUAL;

-- SELECT REPLACE(
--                REPLACE(
--                        REPLACE(
--                                ' Sometimes           I   like    to     lie      ',
--                                ' ', '.'),
--                        '...', '.'),
--                '..', '.') AS RESULT
-- FROM DUAL;

/*1.7. В названии отдела вывести только второе слово, если название
  состоит из двух или более слов. Иначе вывести первое слово. */

SELECT DEPARTMENT_NAME,
       CASE
           WHEN INSTR(DEPARTMENT_NAME, ' ') = 0
               THEN DEPARTMENT_NAME
           WHEN INSTR(SUBSTR(DEPARTMENT_NAME, INSTR(DEPARTMENT_NAME, ' ') + 1), ' ') = 0
               THEN SUBSTR(DEPARTMENT_NAME, INSTR(DEPARTMENT_NAME, ' ') + 1)
           ELSE SUBSTR(DEPARTMENT_NAME, INSTR(DEPARTMENT_NAME, ' ') + 1,
                       INSTR(DEPARTMENT_NAME, ' ', 1, 2) - INSTR(DEPARTMENT_NAME, ' ') - 1)
           END AS RESULT
FROM DEPARTMENTS;

/*2.3. Вывести фамилии тех сотрудников, чей оклад выше
среднего в отделе, в котором они работают. В результат вывести:
1) идентификатор отдела, в котором работает сотрудник;
2) средний оклад по отделу, округлённый до целого
числа;
3) фамилию сотрудника;
4) оклад сотрудника.
Сведения должны быть отсортированы по возрастанию:
1) по идентификатору отдела, к которому приписан
сотрудник;
2) по окладу, установленному сотруднику*/

SELECT AVGEMP.DEPARTMENT_ID,
       ROUND(AVG(AVGEMP.SALARY)) AS AVG_SAL,
       EMP.LAST_NAME,
       EMP.SALARY
FROM EMPLOYEES AVGEMP
         JOIN EMPLOYEES EMP
              ON AVGEMP.DEPARTMENT_ID = EMP.DEPARTMENT_ID
WHERE AVGEMP.DEPARTMENT_ID IS NOT NULL
GROUP BY AVGEMP.DEPARTMENT_ID, EMP.LAST_NAME, EMP.SALARY
HAVING EMP.SALARY > AVG(AVGEMP.SALARY)
ORDER BY AVGEMP.DEPARTMENT_ID, EMP.SALARY;

/*2.6. Создать запрос для определения списка городов, в
которых расположены департаменты, суммарная заработная
плата в которых выше средней суммарной заработной платы в
департаментах этого города. Если к отделу не приписано ни
одного сотрудника, считать суммарную заработную плату в этом
отделе равной нулю и учитывать её при подсчёте среднего
значения по городу. В результат вывести:
1) название города;
2) название департамента;
3) среднюю суммарную зарплату в городе, округлённую
до двух знаков после запятой;
4) суммарную зарплату в департаменте.*/

WITH SUM_DEPT AS /* суммарная зарплата в департаментах */
         (SELECT DEPARTMENT_NAME, SUM(NVL(SALARY, 0)) AS SUMSAL
          FROM DEPARTMENTS D
                   LEFT OUTER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
          GROUP BY DEPARTMENT_NAME),
     CITY_AVG AS /* средняя суммарная зарплата по городу */
         (SELECT CITY, AVG(SUMSAL) AS AVGSAL
          FROM DEPARTMENTS D
                   JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
                   JOIN SUM_DEPT S ON D.DEPARTMENT_NAME = S.DEPARTMENT_NAME
          GROUP BY CITY),
     DEPT AS /* департаменты с зарплатой выше, чем средняя по городу */
         (SELECT C.CITY, D.DEPARTMENT_NAME, AVGSAL, SUMSAL
          FROM SUM_DEPT S
                   JOIN DEPARTMENTS D ON S.DEPARTMENT_NAME = D.DEPARTMENT_NAME
                   JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
                   JOIN CITY_AVG C ON S.DEPARTMENT_NAME = D.DEPARTMENT_NAME
          WHERE SUMSAL > AVGSAL)
SELECT CITY,
       DEPARTMENT_NAME,
       TO_CHAR(AVGSAL, '999999.99') AS AVG_CITY_SUM_SAL,
       SUMSAL                       AS SUM_DEPT_SAL
FROM DEPT;

/*2.7. Выбрать сотрудников компании, оклады которых
наиболее близки к среднему окладу по подразделению, к
которому они приписаны. Требуется вывести:
1) идентификатор сотрудника;
2) фамилию сотрудника;
3) идентификатор должности, которую занимает
сотрудник;
4) идентификатор подразделения, к которому приписан
сотрудник;
5) оклад, установленный сотруднику;
6) средний оклад по подразделению, к которому приписан
сотрудник (округлить до целых).
17
Сведения должны быть отсортированы по возрастанию:
1) по идентификатору подразделения, к которому
приписан сотрудник;
2) по окладу, установленному сотруднику;
3) по фамилии сотрудника.*/

SELECT EMPLOYEE_ID,
       LAST_NAME,
       JOB_ID,
       DEPARTMENT_ID,
       SALARY,
       AVG_SAL
FROM EMPLOYEES
         JOIN (SELECT DEPARTMENT_ID,
                      ROUND(AVG(SALARY)) AS AVG_SAL
               FROM EMPLOYEES
               GROUP BY DEPARTMENT_ID) USING (DEPARTMENT_ID)
         JOIN (SELECT DEPARTMENT_ID,
                      MIN(ABS(AVG_SAL - SALARY)) AS MIN_DIFF
               FROM EMPLOYEES
                        JOIN (SELECT DEPARTMENT_ID,
                                     ROUND(AVG(SALARY)) AS AVG_SAL
                              FROM EMPLOYEES
                              GROUP BY DEPARTMENT_ID) USING (DEPARTMENT_ID)
               GROUP BY DEPARTMENT_ID) USING (DEPARTMENT_ID)
WHERE ABS(AVG_SAL - SALARY) = MIN_DIFF
ORDER BY DEPARTMENT_ID, SALARY, LAST_NAME;

/*2.8. Проверить столбцы First_name, Last_name, Salary
таблицы Employees на уникальность значений и вывести все
строки таблицы, в которых хотя бы в одном столбце встречается
значение, которое в этом столбце не уникально (встречается
несколько раз).*/

SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME IN (SELECT FIRST_NAME
                     FROM (SELECT FIRST_NAME,
                                  COUNT(*)
                           FROM EMPLOYEES
                           GROUP BY FIRST_NAME
                           HAVING COUNT(*) > 1))
   OR LAST_NAME IN (SELECT LAST_NAME
                    FROM (SELECT LAST_NAME,
                                 COUNT(*)
                          FROM EMPLOYEES
                          GROUP BY LAST_NAME
                          HAVING COUNT(*) > 1))
   OR SALARY IN (SELECT SALARY
                 FROM (SELECT SALARY,
                              COUNT(*)
                       FROM EMPLOYEES
                       GROUP BY SALARY
                       HAVING COUNT(*) > 1));

/*3.3. Для каждой таблицы схемы вывести:
1) имя таблицы;
2) имя первого столбца первого (по алфавиту)
ограничения уникальности;
3) имя второго столбца первого ограничения
уникальности;
4) общее число столбцов в первом ограничении
уникальности;
5) имя первого столбца второго (по алфавиту)
ограничения уникальности;
6) имя второго столбца второго ограничения
уникальности;
7) общее число столбцов во втором ограничении
уникальности;
8) общее число ограничений уникальности*/

WITH LIST AS (SELECT UCC.CONSTRAINT_NAME AS CNAME,
                     UCC.TABLE_NAME      AS TNAME,
                     UCC.COLUMN_NAME     AS COL
              FROM USER_CONSTRAINTS UC
                       JOIN USER_CONS_COLUMNS UCC
                            ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
                                AND UC.CONSTRAINT_TYPE = 'U'),
     ROWN_COLS AS (SELECT R.*,
                          ROWNUM AS RN
                   FROM (SELECT DISTINCT LIST.*
                         FROM LIST
                         ORDER BY CNAME, TNAME, COL) R),
     RN_GROUPED_COLS AS (SELECT T.TNAME,
                                T.CNAME,
                                T.COL,
                                T.RN - F.FST AS RN
                         FROM (SELECT TNAME,
                                      MIN(RN) AS FST
                               FROM ROWN_COLS
                               GROUP BY TNAME) F
                                  JOIN ROWN_COLS T
                                       ON F.TNAME = T.TNAME),
     ROWN_TABS AS (SELECT R.*,
                          ROWNUM AS RN
                   FROM (SELECT DISTINCT LIST.CNAME,
                                         LIST.TNAME
                         FROM LIST
                         ORDER BY 1, 2) R),
     RN_GROUPED_TABS AS (SELECT T.TNAME,
                                T.CNAME,
                                T.RN - F.FST AS RN
                         FROM (SELECT TNAME,
                                      MIN(RN) AS FST
                               FROM ROWN_TABS
                               GROUP BY TNAME) F
                                  JOIN ROWN_TABS T
                                       ON F.TNAME = T.TNAME),
     JOINED_GROUPS AS (SELECT DISTINCT RC.*,
                                       RT.RN AS RN2
                       FROM RN_GROUPED_COLS RC
                                JOIN RN_GROUPED_TABS RT
                                     ON RC.TNAME = RT.TNAME
                                         AND RC.CNAME = RT.CNAME
                       ORDER BY RC.RN, RT.RN),
     TEMP AS (SELECT TNAME,
                     CNAME,
                     RN2,
                     MIN(RN) AS M
              FROM JOINED_GROUPS
              GROUP BY TNAME,
                       CNAME,
                       RN2),
     COLUMN1 AS (SELECT G.TNAME,
                        G.CNAME,
                        G.COL
                 FROM TEMP
                          LEFT JOIN JOINED_GROUPS G
                                    ON TEMP.TNAME = G.TNAME
                                        AND TEMP.CNAME = G.CNAME
                                        AND G.RN = TEMP.M),
     COLUMN2 AS (SELECT G.TNAME,
                        G.CNAME,
                        G.COL
                 FROM TEMP
                          LEFT JOIN JOINED_GROUPS G
                                    ON TEMP.TNAME = G.TNAME
                                        AND TEMP.CNAME = G.CNAME
                                        AND G.RN = TEMP.M + 1),
     COLLUMNS AS (SELECT C.*,
                         CC.COL AS COL1
                  FROM COLUMN1 C
                           LEFT JOIN COLUMN2 CC
                                     ON C.TNAME = CC.TNAME
                                         AND C.CNAME = CC.CNAME),
     NUM_CONS AS (SELECT TNAME      AS T,
                         CNAME      AS N,
                         COUNT(COL) AS NUM_COLS
                  FROM LIST
                  GROUP BY TNAME,
                           CNAME),
     NUM_CONS_T2 AS (SELECT T,
                            COUNT(C) AS CNT
                     FROM (SELECT DISTINCT TNAME AS T,
                                           CNAME AS C
                           FROM LIST)
                     GROUP BY T),
     FIN AS (SELECT C.*,
                    NC.NUM_COLS,
                    NT.CNT
             FROM COLLUMNS C
                      JOIN NUM_CONS NC
                           ON C.TNAME = NC.T
                               AND C.CNAME = NC.N
                      JOIN NUM_CONS_T2 NT
                           ON C.TNAME = NT.T),
     FIN_RANK AS (SELECT F1.*,
                         F2.CNAME    AS CNAME2,
                         F2.COL      AS COL2,
                         F2.COL1     AS COL12,
                         F2.NUM_COLS AS NUM_COLS2
                  FROM FIN F1
                           LEFT JOIN FIN F2
                                     ON F1.TNAME = F2.TNAME
                                         AND F1.CNAME <> F2.CNAME
                  ORDER BY F1.CNAME, F2.CNAME),
     FIN_ORD AS (SELECT F.*,
                        ROWNUM AS RNK
                 FROM FIN_RANK F)
SELECT TNAME     AS TABLE_NAME,
       COL       AS U_CONS1_COL1,
       COL1      AS U_CONS1_COL2,
       NUM_COLS  AS U_CONS1_COL_CNT,
       COL2      AS U_CONS_COL1,
       COL12     AS U_CONS2_COL2,
       NUM_COLS2 AS U_CONS2_COL_CNT,
       CNT       AS U_CONS_CNT
FROM FIN_ORD
WHERE (RNK, TNAME) IN
      (SELECT MIN(RNK),
              TNAME
       FROM FIN_ORD
       GROUP BY TNAME);

/*3.5. Для таблиц схемы, имеющих индексы вывести:
1) имя таблицы;
2) имя первого (по алфавиту) неуникального индекса;
3) количество столбцов первого неуникального индекса;
4) имя первого (по алфавиту) уникального индекса;
5) количество столбцов первого уникального индекса;
6) общее число неуникальных индексов;
7) общее число уникальных индексов.*/

WITH TNON AS
         (SELECT INDEX_NAME,
                 TABLE_NAME,
                 UNIQUENESS
          FROM USER_INDEXES
          WHERE UNIQUENESS = 'NONUNIQUE'),
     TUN AS
         (SELECT INDEX_NAME,
                 TABLE_NAME,
                 UNIQUENESS
          FROM USER_INDEXES
          WHERE UNIQUENESS = 'UNIQUE')
SELECT NVL(T1.TABLE_NAME, T2.TABLE_NAME)  AS TABLE_NAME,
       NVL(T1.INDEX_NAME, '-')            AS NUI1_NAME,
       (SELECT COUNT(T1.TABLE_NAME)
        FROM USER_IND_COLUMNS
        WHERE INDEX_NAME = T1.INDEX_NAME) AS NUI1_COL_CNT,
       NVL(T2.INDEX_NAME, '-')            AS UI1_NAME,
       (SELECT COUNT(T2.TABLE_NAME)
        FROM USER_IND_COLUMNS
        WHERE INDEX_NAME = T2.INDEX_NAME) AS UI1_COL_CNT,
       (SELECT COUNT(INDEX_NAME)
        FROM TNON
        WHERE TABLE_NAME = T2.TABLE_NAME) AS NUI1_COL_CNT,
       (SELECT COUNT(INDEX_NAME)
        FROM TUN
        WHERE TABLE_NAME = T2.TABLE_NAME) AS UI1_COL_CNT
FROM TNON T1
         FULL OUTER JOIN TUN T2
                         ON T1.TABLE_NAME = T2.TABLE_NAME
WHERE T1.INDEX_NAME <= ALL
      (SELECT INDEX_NAME
       FROM TNON
       WHERE TABLE_NAME = T1.TABLE_NAME)
  AND T2.INDEX_NAME <= ALL
      (SELECT DISTINCT INDEX_NAME
       FROM TUN
       WHERE TABLE_NAME = T2.TABLE_NAME);

/*3.6. Для всех таблиц схемы вывести:
1) имя таблицы;
2) имя первого (по алфавиту) ограничения Check;
3) имена столбцов, на которые действует это ограничение;
4) могут ли эти столбцы содержать пустые значения;
5) общее количество ограничений Check для таблицы*/

WITH TABLE_CONSTRAINT AS (SELECT MIN(CONSTRAINT_NAME) AS CONSTRAINT_NAME,
                                 TABLE_NAME,
                                 COUNT(*)             AS COUNTS
                          FROM USER_CONSTRAINTS
                          WHERE CONSTRAINT_TYPE = 'C'
                          GROUP BY TABLE_NAME)
SELECT TC.TABLE_NAME           AS TABLE_NAME,
       MIN(TC.CONSTRAINT_NAME) AS C1_NAME,
       UCC.COLUMN_NAME         AS C1_COL,
       MIN(NULLABLE)           AS C1_COL_NULLABLE,
       MIN(COUNTS)             AS C_CNT
FROM TABLE_CONSTRAINT TC
         JOIN USER_CONS_COLUMNS UCC
              ON UCC.TABLE_NAME = TC.TABLE_NAME
         JOIN USER_TAB_COLUMNS UTC
              ON UCC.COLUMN_NAME = UTC.COLUMN_NAME
                  AND TC.TABLE_NAME = UTC.TABLE_NAME
GROUP BY TC.TABLE_NAME, UCC.COLUMN_NAME;

/*4.8. Сформировать отчёт, содержащий номер отдела, название отдела, имена и фамилии сотрудников, а также их оклады,
отсортированные по возрастанию. Отчёт должен иметь следующий вид:

FIRST_NAME 	LAST_NAME 	SALARY
Отдел № 	10 	«Administration»
Jennifer 	Whalen 	4400
Clark 	Kent 	1000

Отдел № 	20 	«Marketing»
Max 	Smart 	1000
Pat 	Fay 	6000
Michael 	Harstein 	13000
… 	… 	…

Отдел № 	110 	«Accounting»
William 	Gietz 	8300
Shelley 	Higgins 	12000

Сотрудников, не приписанных к конкретному отделу, не выводить.
*/

WITH DEP_EMP AS (SELECT *
                 FROM (SELECT DEPARTMENT_ID,
                              EMPLOYEE_ID,
                              SALARY
                       FROM EMPLOYEES
                       GROUP BY ROLLUP (DEPARTMENT_ID, EMPLOYEE_ID, SALARY))
                 WHERE NOT ((SALARY IS NOT NULL AND EMPLOYEE_ID IS NULL) OR
                            (SALARY IS NULL AND EMPLOYEE_ID IS NOT NULL))
                   AND (DEPARTMENT_ID IS NOT NULL)
                 ORDER BY DEPARTMENT_ID, SALARY DESC),
     ADD_DEPARTMENT_NAME AS (SELECT D1.DEPARTMENT_ID,
                                    EMPLOYEE_ID,
                                    SALARY,
                                    DEPARTMENT_NAME
                             FROM DEP_EMP D1
                                      JOIN DEPARTMENTS D2 ON
                                 D1.DEPARTMENT_ID = D2.DEPARTMENT_ID),
     ADD_ROWNUM AS (SELECT DEPARTMENT_ID,
                           EMPLOYEE_ID,
                           DEPARTMENT_NAME,
                           ROWNUM AS RN
                    FROM ADD_DEPARTMENT_NAME),
     ADD_NAME AS (SELECT NVL(FIRST_NAME, 'Отдел №')               AS FIRST_NAME,
                         NVL(LAST_NAME, TO_CHAR(A.DEPARTMENT_ID)) AS LAST_NAME,
                         NVL(TO_CHAR(SALARY), DEPARTMENT_NAME)    AS SALARY
                  FROM ADD_ROWNUM A
                           LEFT OUTER JOIN EMPLOYEES E
                                           ON A.EMPLOYEE_ID = E.EMPLOYEE_ID
                  ORDER BY RN)
SELECT *
FROM ADD_NAME;

/*4.1. Написать запрос, выдающий отчёт о суммарных
выплатах сотрудникам, непосредственно подчиняющихся
заданному руководителю по идентификаторам должностей (поле
Job_id). Непосредственное подчинение предполагает подчинение
на первом уровне. Номер каждого руководителя должен
встречаться в отчете лишь дважды.*/

/*SELECT CASE
           WHEN JOB = MJ OR GR = 1
               THEN MNG
           ELSE ' '
           END             AS "Номер руководителя",
       NVL2(JOB, JOB, ' ') AS "Должность",
       ECNT                AS "Кол-во сотрудников",
       SALSUM              AS "Выплаты",
       CASE
           WHEN GR = 2
               THEN 'Общий итог'
           WHEN GR = 1
               THEN 'Суммарная зарплата у руководителя ' || MNG
           ELSE 'Зарплата сотрудников в должности ' || JOB
           END             AS "Вид выплаты"
FROM (SELECT TO_CHAR(M.EMPLOYEE_ID)                       AS MNG,
             JE.JOB_ID                                    AS JOB,
             COUNT(E.EMPLOYEE_ID)                         AS ECNT,
             SUM(E.SALARY)                                AS SALSUM,
             GROUPING(JE.JOB_ID) + GROUPING(JM.JOB_TITLE) AS GR
      FROM EMPLOYEES E
               JOIN EMPLOYEES M
                    ON E.MANAGER_ID = M.EMPLOYEE_ID
               JOIN JOBS JE
                    ON JE.JOB_ID = E.JOB_ID
               JOIN JOBS JM
                    ON JM.JOB_ID = M.JOB_ID
      GROUP BY ROLLUP ((M.EMPLOYEE_ID, JM.JOB_TITLE), JE.JOB_ID))
         LEFT JOIN (SELECT MIN(JOB_ID) MJ,
                           MANAGER_ID
                    FROM EMPLOYEES
                    GROUP BY MANAGER_ID) IE
                   ON IE.MANAGER_ID = MNG
ORDER BY MNG, GR, "Должность";*/

SELECT CASE
           WHEN GROUPING(E.JOB_ID) = 0
               THEN CASE
                        WHEN E.JOB_ID = (SELECT MIN(JOB_ID)
                                         FROM EMPLOYEES
                                         WHERE MANAGER_ID = M.EMPLOYEE_ID)
                            THEN TO_CHAR(M.EMPLOYEE_ID)
                        ELSE ' '
               END
           ELSE NVL(TO_CHAR(M.EMPLOYEE_ID), ' ')
           END       AS "Номер руководителя",
       CASE
           WHEN GROUPING(E.JOB_ID) = 0
               THEN E.JOB_ID
           ELSE ' '
           END       AS "Должность",
       COUNT(*)      AS "Кол-во сотрудников",
       SUM(E.SALARY) AS "Выплаты",
       CASE
           WHEN GROUPING(E.JOB_ID) = 0
               THEN 'Зарплата сотрудников в должности ' || E.JOB_ID
           ELSE
               CASE
                   WHEN GROUPING(M.EMPLOYEE_ID) = 0
                       THEN 'Суммарная зарплата у руководителя ' || M.EMPLOYEE_ID
                   ELSE 'Общий итог'
                   END
           END       AS "Вид выплаты"
FROM EMPLOYEES E
         JOIN EMPLOYEES M
              ON E.MANAGER_ID = M.EMPLOYEE_ID
GROUP BY ROLLUP (M.EMPLOYEE_ID, E.JOB_ID)
ORDER BY M.EMPLOYEE_ID, GROUPING(M.EMPLOYEE_ID), E.JOB_ID;

/*4.4. Вывести все даты за 2013 год и соответствующие дни
недели без использования иерархических запросов и Model.*/

SELECT TO_CHAR((ROWNUM - 1) + TO_DATE('01.01.' || ${input_year}, 'dd.mm.yyyy'), 'dd.mm.yyyy') AS "Date",
       TO_CHAR((ROWNUM - 1) + TO_DATE('01.01.' || ${input_year}, 'dd.mm.yyyy'), 'Day',
               'NLS_DATE_LANGUAGE = Russian')                                                 AS "Day"
FROM (SELECT 512
      FROM DUAL
      GROUP BY CUBE (2, 4, 8, 16, 32, 64, 128, 256, 512))
WHERE ROWNUM - 1 <= TO_DATE('31.12.' || ${input_year}, 'dd.mm.yyyy') - TO_DATE('01.01.' || ${input_year}, 'dd.mm.yyyy');

SELECT TO_CHAR((ROWNUM - 1) + TO_DATE('01.01.' || ${input_year}, 'dd.mm.yyyy'), 'dd.mm.yyyy') AS "Date",
       TO_CHAR((ROWNUM - 1) + TO_DATE('01.01.' || ${input_year}, 'dd.mm.yyyy'), 'Day',
               'NLS_DATE_LANGUAGE = Russian')                                                 AS "Day"
FROM (SELECT LEVEL
      FROM DUAL
      CONNECT BY LEVEL <= 365)
WHERE ROWNUM - 1 <= TO_DATE('31.12.' || ${input_year}, 'dd.mm.yyyy') - TO_DATE('01.01.' || ${input_year}, 'dd.mm.yyyy');

/*5.5. Дана таблица со следующей структурой:
Id  Linked_id   Part
0   -1          Оглавление
1   0           Глава 1
2   1           Часть 1
3   1           Часть 2
4   0           Глава 2
5   4           Часть 1
6   4           Часть 2
(количество глав и частей произвольное). Создать запрос для
вывода оглавления в виде:
Оглавление
1 Глава 1
1.1 Часть 1
1.2 Часть 2
2 Глава 2
2.1 Часть 1
2.2 Часть 2*/

WITH CONTENTS AS (SELECT 0 AS ID, -1 AS LINKED_ID, 'Оглавление' AS PART
                  FROM DUAL
                  UNION ALL
                  SELECT 1, 0, 'Глава 1'
                  FROM DUAL
                  UNION ALL
                  SELECT 2, 1, 'Часть 1'
                  FROM DUAL
                  UNION ALL
                  SELECT 3, 1, 'Часть 2'
                  FROM DUAL
                  UNION ALL
                  SELECT 4, 0, 'Глава 2'
                  FROM DUAL
                  UNION ALL
                  SELECT 5, 4, 'Часть 1'
                  FROM DUAL
                  UNION ALL
                  SELECT 6, 4, 'Часть 2'
                  FROM DUAL),
     ORDEREDCONTENTS AS (SELECT RECORD.ID,
                                RECORD.LINKED_ID,
                                RECORD.PART,
                                (SELECT THEORDER
                                 FROM (SELECT ID, ROWNUM AS THEORDER
                                       FROM (SELECT ID
                                             FROM CONTENTS
                                             WHERE LINKED_ID = RECORD.LINKED_ID
                                             ORDER BY 1))
                                 WHERE ID = RECORD.ID) AS THEORDER
                         FROM CONTENTS RECORD)
SELECT CASE
           WHEN LEVEL = 1
               THEN PART
           ELSE SUBSTR(
                        SYS_CONNECT_BY_PATH(THEORDER, '.'),
                        INSTR(SYS_CONNECT_BY_PATH(THEORDER, '.'), '.', 1, 2) + 1) || ' ' || PART
           END AS "Table of contents"
FROM ORDEREDCONTENTS
START WITH LINKED_ID = -1
CONNECT BY PRIOR ID = LINKED_ID
ORDER SIBLINGS BY ID;

WITH CONTENTS AS (SELECT 0 AS ID, -1 AS LINKED_ID, 'Оглавление' AS PART
                  FROM DUAL
                  UNION ALL
                  SELECT 1, 0, 'Глава 1'
                  FROM DUAL
                  UNION ALL
                  SELECT 2, 1, 'Часть 1'
                  FROM DUAL
                  UNION ALL
                  SELECT 3, 1, 'Часть 2'
                  FROM DUAL
                  UNION ALL
                  SELECT 4, 0, 'Глава 2'
                  FROM DUAL
                  UNION ALL
                  SELECT 5, 4, 'Часть 1'
                  FROM DUAL
                  UNION ALL
                  SELECT 6, 4, 'Часть 2'
                  FROM DUAL)
SELECT RECORD.ID,
       RECORD.LINKED_ID,
       RECORD.PART,
       (SELECT THEORDER
        FROM (SELECT ID, ROWNUM AS THEORDER
              FROM (SELECT ID
                    FROM CONTENTS
                    WHERE LINKED_ID = RECORD.LINKED_ID
                    ORDER BY 1))
        WHERE ID = RECORD.ID) AS THEORDER
FROM CONTENTS RECORD;

/*5.1. Для двух заданных сотрудников найти их
ближайшего общего начальника.
Пример результата:
EMP_1   EMP_2   MAN_ID  MAN_NAME
174     178     149     Zlotkey */

WITH HELP1 AS (SELECT EMPLOYEE_ID AS EMP,
                      LAST_NAME   AS LN,
                      LEVEL       AS LVL
               FROM EMPLOYEES
               START WITH EMPLOYEE_ID = ${first_input}
               CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID),
     HELP2 AS (SELECT EMPLOYEE_ID AS EMP,
                      LAST_NAME   AS LN,
                      LEVEL       AS LVL
               FROM EMPLOYEES
               START WITH EMPLOYEE_ID = ${second_input}
               CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID)
SELECT ${first_input}  AS EMP_1,
       ${second_input} AS EMP_2,
       HELP1.EMP       AS MAN_ID,
       HELP1.LN        AS MAN_NAME
FROM HELP1
         JOIN HELP2
              ON HELP1.EMP = HELP2.EMP
WHERE HELP1.LVL = (SELECT MIN(HELP1.LVL)
                   FROM HELP1
                            JOIN HELP2
                                 ON HELP1.EMP = HELP2.EMP);

/*5.3. Определить список последовательностей
подчиненности от сотрудников, не имеющих менеджера
(менеджеров высшего уровня), до сотрудников, не имеющих
подчиненных. Результат представить в виде:
MAN_LIST
King->Kochhar->Greenberg->Faviet (не имеет подчинённых)*/

/*SELECT LTRIM(SYS_CONNECT_BY_PATH(LAST_NAME, '->'), '->') MAN_LIST
FROM EMPLOYEES
WHERE CONNECT_BY_ISLEAF = 1
CONNECT BY MANAGER_ID = PRIOR EMPLOYEE_ID
START WITH MANAGER_ID IS NULL;*/

/*WITH STR AS (SELECT SYS_CONNECT_BY_PATH(LAST_NAME, '->') AS MANE_LIST, CONNECT_BY_ISLEAF LEAF
             FROM EMPLOYEES
             START WITH MANAGER_ID IS NULL
             CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID)
SELECT SUBSTR(MANE_LIST, 3) AS MANE_LIST
FROM STR
WHERE LEAF = 1;*/

WITH TEMP AS (SELECT LAST_NAME,
                     EMPLOYEE_ID AS EMP,
                     MANAGER_ID  AS MGR
              FROM EMPLOYEES
              START WITH MANAGER_ID IS NULL
              CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID),
     TEMP2 AS (SELECT LAST_NAME,
                      EMP,
                      MGR,
                      SYS_CONNECT_BY_PATH(LAST_NAME, '->') AS MAN_LIST
               FROM TEMP
               START WITH MGR IS NULL
               CONNECT BY PRIOR EMP = MGR)
SELECT REGEXP_REPLACE(MAN_LIST, '^->', '') || ' (не имеет подчинённых)' AS MAN_LIST
FROM TEMP2
WHERE NOT EXISTS(SELECT 'X'
                 FROM EMPLOYEES
                 WHERE MANAGER_ID = TEMP2.EMP);

WITH TEMP AS (SELECT LAST_NAME,
                     EMPLOYEE_ID AS EMP,
                     MANAGER_ID  AS MGR
              FROM EMPLOYEES
              START WITH MANAGER_ID IS NULL
              CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID)
SELECT LAST_NAME,
       EMP,
       MGR,
       SYS_CONNECT_BY_PATH(LAST_NAME, '->') AS MAN_LIST
FROM TEMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMP = MGR;