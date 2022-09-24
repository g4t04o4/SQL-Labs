SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID IN (101, NULL); /*ain't working for null*/

/*6.	Создайте пользователя и дайте ему  права на выполнение команд DML и DQL на Вашей таблице DEPARTMENTS.
Может ли любой пользователь передать право создавать запрос к своей таблице DEPARTMENTS?
*/

CREATE USER TEST_USER_1812 IDENTIFIED BY test_password;
GRANT CREATE SESSION TO TEST_USER_1812;
GRANT SELECT ON GERUBU.DEPARTMENTS TO TEST_USER_1812;

/*7.	Создайте запрос для извлечения всех строк из Вашей таблицы DEPARTMENTS
*/
SELECT *
FROM GERUBU.DEPARTMENTS;

/*8.	Добавьте строки в таблицу DEPARTMENTS. Вы должны добавить в свою таблицу отдел EDUCATION с номером 500, а созданный Вами пользователь должен добавить в Вашу таблицу отдел TRAINING с номером 510. (Не подтверждайте выполнение команд)
Из-под учётной записи созданного Вами пользователя просмотрите свою таблицу – видите ли Вы отделы с номером 500 и 510? Объясните результат
*/
GRANT INSERT ON GERUBU.DEPARTMENTS TO TEST_USER_1812;
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (500, 'EDUCATION');
COMMIT;

INSERT INTO GERUBU.DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES (510, 'TRAINING');
COMMIT;

/*9.	Из-под своей учётной записи создайте синоним Dep для таблицы DEPARTMENTS
*/
GRANT CREATE SYNONYM TO TEST_USER_1812;
CREATE SYNONYM DEPT_SNNM FOR GERUBU.DEPARTMENTS;

/*10.	Из-под учётной записи созданного Вами пользователя извлеките все записи из своей таблицы DEPARTMENTS
с использованием синонима, созданного на предыдущем шаге.
*/
SELECT *
FROM DEPT_SNNM;

/*11.	Создайте запрос к представлению словаря данных USER_TABLES, для того чтобы увидеть информацию о таблицах, которыми Вы владеете.
*/
SELECT TABLE_NAME
FROM USER_TABLES;

/*12.	Создайте запрос к представлению словаря данных ALL_TABLES, для того чтобы получить информацию обо всех таблицах,
к которым Вы имеете доступ. Исключите таблицы, которыми Вы владеете.
*/
SELECT TABLE_NAME
FROM ALL_TABLES
MINUS
SELECT TABLE_NAME
FROM USER_TABLES;

/*13.	Отберите привилегию SELECT  у созданного Вами пользователя.
*/
REVOKE SELECT ON GERUBU.DEPARTMENTS FROM TEST_USER_1812;

/*14.	Удалите строки, которые были вставлены в таблицу DEPARTMENTS на шаге 8, и сохраните изменения
 */
DELETE
FROM DEPARTMENTS
WHERE DEPARTMENT_ID IN (500, 510);
COMMIT;

/*1.	Создайте таблицу DEPT2  на основе следующего описания таблицы.
Сохраните команду в файле lab_02_01.sql, а затем выполните файл для создания таблицы.
Убедитесь в том, что таблица создана.*/
CREATE TABLE DEPT2
(
    ID   NUMBER(7),
    NAME VARCHAR2(25)
);
COMMIT;
SELECT *
FROM DEPT2;

/*2.	Заполните таблицу DEPT2 данными из таблицы Departments. Включите только нужные столбцы.
*/
INSERT INTO DEPT2(ID, NAME)
    (SELECT DEPARTMENT_ID, DEPARTMENT_NAME
     FROM DEPARTMENTS);

/*3.	Создайте таблицу EMP2 на основе приведённого описания таблицы. Сохраните команду в скрипт-файле lab_02_03.sql,
а затем выполните его, чтобы создать таблицу. Убедитесь в том, что таблица создана
*/
CREATE TABLE EMP2
(
    ID         NUMBER(7),
    LAST_NAME  VARCHAR2(25),
    FIRST_NAME VARCHAR2(25),
    DEPT_ID    NUMBER(7)
);

/*4.	Измените столбец LAST_NAME в таблице EMP2 так, чтобы
он вмещал фамилии большей длины. Проверьте изменение.
*/
ALTER TABLE EMP2
    MODIFY (LAST_NAME VARCHAR2(50));

/*5.	Убедитесь в том, что информация о таблицах DEPT2 и EMP2 хранится в словаре данных.
*/
SELECT TABLE_NAME
FROM USER_TABLES
WHERE TABLE_NAME IN ('DEPT2', 'EMP2');

/*6.	Создайте таблицу EMPLOYEES2 на основе структуры таблицы EMPLOYEES,
включив только столбцы EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID.
Присвойте столбцам новой таблицы имена ID, FIRST_NAME, LAST_NAME, SALARY, DEPT_ID.
*/
CREATE TABLE EMPLOYEES2
(
    ID         NUMBER(6)    NOT NULL,
    FIRST_NAME VARCHAR2(20),
    LAST_NAME  VARCHAR2(25) NOT NULL,
    SALARY     NUMBER(8, 2),
    DEPT_ID    NUMBER(4)
);
COMMIT;

/*7.	Удалите таблицу EMP2
*/
DROP TABLE EMP2;
COMMIT;

/*8.	Создайте запрос к Корзине, чтобы проверить, что таблица там присутствует.
*/
SELECT *
FROM RECYCLEBIN
WHERE ORIGINAL_NAME = 'EMP2';

/*9.	Восстановите таблицу EMP2 из корзины.
*/
FLASHBACK TABLE EMP2 TO BEFORE DROP;
COMMIT;

/*10.	Удалите столбец FIRST_NAME из таблицы EMPLOYEES2. Проверьте описание таблицы,
чтобы убедиться, что столбец удалён
*/
ALTER TABLE EMPLOYEES2
    DROP COLUMN FIRST_NAME;

/*11.	Пометьте столбец DEPT_ID в таблице EMPLOYEES2 как (UNUSED).
*/
ALTER TABLE EMPLOYEES2
    SET UNUSED (DEPT_ID);

/*12.	Удалите из таблицы EMPLOYEES2 все столбцы помеченные как UNUSED.
*/
ALTER TABLE EMPLOYEES2
    DROP UNUSED COLUMNS;

/*13.	Добавьте ограничение PRIMARY KEY на уровне таблицы EMP2, используя столбец ID.
Назовите ограничение my_emp_id_pk. Ограничение целостности может быть включено с помощью
команды ALTER TABLE.
*/
ALTER TABLE EMP2
    ADD CONSTRAINT MY_EMP_ID_PK PRIMARY KEY (ID);
ALTER TABLE EMP2
    ENABLE CONSTRAINT MY_EMP_ID_PK;

/*14.	Создайте ограничение PRIMARY KEY для таблицы DEPT2, используя столбец ID.
Ограничение должно получить название при создании. Назовите ограничение my_dept_id_pk.
*/
ALTER TABLE DEPT2
    ADD CONSTRAINT MY_DEPT_ID_PK PRIMARY KEY (ID);
ALTER TABLE DEPT2
    ENABLE CONSTRAINT MY_DEPT_ID_PK;

/*15.	Добавьте ссылку в определение таблицы EMP2, благодаря которой служащий не сможет
быть приписан к несуществующему отделу. Назовите ограничение my_emp_dept_id_fk.
*/
ALTER TABLE EMP2
    ADD CONSTRAINT MY_EMP_DEPT_ID_FK FOREIGN KEY (DEPT_ID)
        REFERENCES DEPT2 (ID) ON DELETE CASCADE;

/*16.	Проверьте добавленные ограничения путём запроса к представлению USER_CONSTRAINTS.
Запомните типы и имена ограничений. Сохраните команду в скрипт-файле lab10_4.sql
*/
SELECT *
FROM USER_CONSTRAINTS
WHERE CONSTRAINT_NAME LIKE 'MY%';

/*17.	Отобразите имена объектов и типы данных из представления словаря данных USER_OBJECTS
для таблиц EMP2 и DEPT2. Обратите внимание, что созданы новые таблицы и  индексы.
*/
SELECT OBJECT_NAME, OBJECT_TYPE
FROM USER_OBJECTS UO
         LEFT OUTER JOIN USER_INDEXES UI ON
    (UO.OBJECT_NAME = UI.INDEX_NAME OR
     UO.OBJECT_NAME = UI.TABLE_NAME)
WHERE TABLE_NAME IN ('EMP2', 'DEPT2');

/*18.	Измените таблицу EMP2. Добавьте в неё столбец COMMISSION с типом данных NUMBER
точностью 2 и масштабом 2. добавьте ограничения для столбца COMMISSION, чтобы
величина комиссионных была больше нуля
*/
ALTER TABLE EMP2
    ADD (COMMISSION NUMBER(2, 2)
        CONSTRAINT EMP_COMM_CHECK CHECK (COMMISSION > 0));
COMMIT;

/*19.	Удалите таблицы EMP2 и DEPT2 так, чтобы они не могли быть восстановлены
*/
DROP TABLE EMP2;
PURGE TABLE EMP2;
DROP TABLE DEPT2;
PURGE TABLE DEPT2;

/*20.	Создайте таблицу DEPT_NAMED_INDEX со следующими параметрами:

Индекс для колонки первичного ключа должен быть создан явно и иметь имя DEPT_PK_IDX.
Выполните запрос к представлению USER_INDEXES, чтобы вывести значение столбца INDEX_NAME
для таблицы DEPT_NAMED_INDEX.
*/
CREATE TABLE DEPT_NAMED_INDEX
(
    DEPTNO NUMBER(4) PRIMARY KEY USING INDEX
        (CREATE INDEX DEPT_PK_IDX ON DEPT_NAMED_INDEX (DEPTNO)),
    DNAME  VARCHAR2(30)
);
COMMIT;

SELECT INDEX_NAME,
       TABLE_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'DEPT_NAMED_INDEX';

/*cre_sal_history*/
DROP TABLE SAL_HISTORY;
CREATE TABLE SAL_HISTORY
(
    EMPLOYEE_ID NUMBER(6),
    HIRE_DATE   DATE,
    SALARY      NUMBER(8, 2)
);

/*cre_mgr_history*/
DROP TABLE MGR_HISTORY;
CREATE TABLE MGR_HISTORY
(
    EMPLOYEE_ID NUMBER(6),
    MANAGER_ID  NUMBER(6),
    SALARY      NUMBER(8, 2)
);

/*cre_special_sal*/
DROP TABLE SPECIAL_SAL;
CREATE TABLE SPECIAL_SAL
(
    EMPLOYEE_ID NUMBER(6),
    SALARY      NUMBER(8, 2)
);

/*7.	Напишите команду для выполнения следующего:
•	Выбрать из таблицы EMPLOYEES номер, дату найма, номер менеджера и зарплату для сотрудников,
номер которых меньше 125;
•	Если оклад больше $20000, вставить номер служащего и его оклад в таблицу SPECIAL_SAL;
•	Вставить номер, дату найма и оклад служащего в таблицу SAL_HISTORY;
•	Вставить номер служащего, номер его менеджера и значение зарплаты в таблицу MGR_HISTORY.
*/
INSERT
    WHEN SALARY > 20000 THEN
    INTO SPECIAL_SAL
VALUES (EMPLOYEE_ID, SALARY)
INTO SAL_HISTORY
VALUES (EMPLOYEE_ID, HIRE_DATE, SALARY)
INTO MGR_HISTORY
VALUES (EMPLOYEE_ID, MANAGER_ID, SALARY)
    ELSE
INTO SAL_HISTORY
VALUES (EMPLOYEE_ID, HIRE_DATE, SALARY)
INTO MGR_HISTORY
VALUES (EMPLOYEE_ID, MANAGER_ID, SALARY)
SELECT EMPLOYEE_ID, HIRE_DATE, MANAGER_ID, SALARY
FROM EMPLOYEES
WHERE EMPLOYEE_ID < 125;
/*8.	Выведите записи из таблицы SPECIAL_SAL.
*/
SELECT *
FROM SPECIAL_SAL;

/*9.	Выведите записи из таблицы SAL_HISTORY.
*/
SELECT *
FROM SAL_HISTORY;

/*10.	Выведите записи из таблицы MGR_HISTORY
*/
SELECT *
FROM MGR_HISTORY;

/*cre_sales_source_data*/
DROP TABLE SALES_SOURCE_DATA;
CREATE TABLE SALES_SOURCE_DATA
(
    EMPLOYEE_ID NUMBER(6),
    WEEK_ID     NUMBER(2),
    SALES_MON   NUMBER(8, 2),
    SALES_TUE   NUMBER(8, 2),
    SALES_WED   NUMBER(8, 2),
    SALES_THUR  NUMBER(8, 2),
    SALES_FRI   NUMBER(8, 2)
);

/*ins_sales_source_data*/
INSERT INTO SALES_SOURCE_DATA
VALUES (178, 6, 1750, 2200, 1500, 1500, 3000);
COMMIT;

/*14.	Выведите записи из таблицы SALES_SOURCE_DATA.
*/
SELECT *
FROM SALES_SOURCE_DATA;

/*cre_sales_info*/
DROP TABLE SALES_INFO;
CREATE TABLE SALES_INFO
(
    EMPLOYEE_ID NUMBER(6),
    WEEK        NUMBER(2),
    SALES       NUMBER(8, 2)
);

/*17.	Напишите команду для выполнения следующего:
•	Выбрать из таблицы SALES_SOURCE_DATA записи с номерами служащих, номерами недель, продажами в понедельник, вторник, среду, четверг и пятницу.
•	Выполнить преобразование, которое конвертирует каждую такую запись из таблицы SALES_SOURCE_DATA в несколько записей таблицы SALES_INFO
*/
INSERT ALL
    INTO SALES_INFO
VALUES (EMPLOYEE_ID, WEEK_ID, SALES_MON)
INTO SALES_INFO
VALUES (EMPLOYEE_ID, WEEK_ID, SALES_TUE)
INTO SALES_INFO
VALUES (EMPLOYEE_ID, WEEK_ID, SALES_WED)
INTO SALES_INFO
VALUES (EMPLOYEE_ID, WEEK_ID, SALES_THUR)
INTO SALES_INFO
VALUES (EMPLOYEE_ID, WEEK_ID, SALES_FRI)
SELECT EMPLOYEE_ID,
       WEEK_ID,
       SALES_MON,
       SALES_TUE,
       SALES_WED,
       SALES_THUR,
       SALES_FRI
FROM SALES_SOURCE_DATA;

/*18.	Выведите записи таблицы SALES_INFO.
*/
SELECT *
FROM SALES_INFO;

/*19.	У Вас есть информация о бывших сотрудниках, сохраненная в файле emp.dat.
Вы хотите сохранить имена и E-mail для всех сотрудников, бывших и настоящих, в таблице.
Для того, чтобы сделать это создайте сначала внешнюю таблицу EMP_DATA, используя файл emp.dat.
Директория – Stud. Файл emp.dat можно просмотреть на
\\Oraclebi\Student\SQL (\\Westfold\Student\Student_extern).
При созднии таблицы установите максимально допустимое количество ошибок, равным 0.
Предусмотрите создание Log и Bad файлов
*/

CREATE TABLE EMP_DATA
(
    FIRST_NAME VARCHAR2(20),
    LAST_NAME  VARCHAR2(20),
    EMAIL      VARCHAR2(45)
)
    ORGANIZATION EXTERNAL
    (TYPE ORACLE_LOADER
        DEFAULT DIRECTORY STUD ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
            BADFILE STUD:'badfile42'
        LOGFILE STUD:'logfile42'
        FIELDS TERMINATED BY '|'
            MISSING FIELD VALUES ARE NULL
            REJECT ROWS WITH ALL NULL FIELDS
            (
            first_name CHAR LRTRIM ,
            last_name CHAR LRTRIM,
            email CHAR LRTRIM
            )
        ) LOCATION ('emp.dat')
        ) REJECT LIMIT 0;

SELECT *
FROM EMP_DATA;

DROP TABLE EMP_DATA;

/*20.	Создайте таблицу EMP_HIST на основе таблицы EMPLOYEES, включив в нее три столбца  FIRST_NAME, LAST_NAME, EMAIL
Увеличьте размер столбца EMAIL до 45.
Вставьте данные из таблицы  EMP_DATA  в таблицу EMP_HIST, предполагая, что сведения в таблице EMP_DATA  наиболее свежие. Если строка в таблице EMP_DATA  совпадает со строкой EMP_HIST, измените e-mail в таблице EMP_HIST  на соответствующий e-mail в таблице EMP_DATA. Если в таблице   EMP_DATA есть строка, которой нет в таблице EMP_HIST, вставьте ее в таблицу EMP_HIST. Строки в таблицах считаются соответствующими, когда фамилии и имена сотрудников идентичны.
После выполнения задания выведите на экран содержимое таблицы  EMP_HIST.
*/
CREATE TABLE EMP_HIST
(
    FIRST_NAME VARCHAR2(20),
    LAST_NAME  VARCHAR2(25) NOT NULL,
    EMAIL      VARCHAR2(45) NOT NULL
);
MERGE INTO EMP_HIST EH
USING EMP_DATA ED
ON (
            ED.FIRST_NAME = EH.FIRST_NAME AND
            ED.LAST_NAME = EH.LAST_NAME)
WHEN MATCHED THEN
    UPDATE
    SET EH.EMAIL = ED.EMAIL
WHEN NOT MATCHED THEN
    INSERT
    VALUES (ED.FIRST_NAME, ED.LAST_NAME, ED.EMAIL);
SELECT *
FROM EMP_HIST;

/*1.	Напишите запрос для вывода следующих данных о сотрудниках, менеджер которых имеет номер меньше 120:
•	Номер менеджера (Manager_ID);
•	Идентификатор должности (Job_ID) и общий оклад сотрудников для каждой должности (Job_ID), которые подчиняются одному менеджеру;
•	Общий оклад сотрудников, сгруппированный по их менеджерам;
•	Общий оклад сотрудников независимо от их должности или менеджера.
Результаты отсортировать, как представлено ниже (по возрастанию MGR и убыванию общего оклада сотрудников).
*/
SELECT MANAGER_ID, JOB_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE MANAGER_ID < 120
GROUP BY ROLLUP (MANAGER_ID, JOB_ID)
ORDER BY 1 ASC, 3 DESC;

/*2.  Отметьте выходные данные, полученные в задании 1. Используя функцию GROUPING,
напишите запрос для выяснения, являются ли неопределённые значения в столбцах,
которые соответствуют приведённым в предложении GROUP BY, результатом применения
операции ROLLUP.  Результаты отсортировать, как представлено ниже (по возрастанию
MGR и убыванию общего оклада сотрудников)
*/
SELECT MANAGER_ID,
       JOB_ID,
       SUM(SALARY),
       GROUPING(MANAGER_ID),
       GROUPING(JOB_ID)
FROM EMPLOYEES
WHERE MANAGER_ID < 120
GROUP BY ROLLUP (MANAGER_ID, JOB_ID)
ORDER BY 1 ASC, 3 DESC;

/*3.	Напишите запрос для вывода следующих данных о сотрудниках:
•	Номер менеджера (Manager_ID);
•	Должность и общий оклад по каждой должности для сотрудников, отчитывающихся перед одним и тем же менеджером;
•	Общий оклад сотрудников, сгруппированных по их менеджерам;
•	Сводные значения по общей зарплате для каждой должности независимо от менеджера;
•	Общий оклад сотрудников независимо от должности и менеджера
*/
SELECT MANAGER_ID,
       JOB_ID,
       SUM(SALARY) SUM_SALARY
FROM EMPLOYEES
WHERE JOB_ID IS NOT NULL
  AND MANAGER_ID IS NOT NULL
GROUP BY CUBE (MANAGER_ID, JOB_ID)
ORDER BY MANAGER_ID;

/*4.	Отметьте выходные данные, полученные в задании 3. Используя функцию GROUPING,
напишите запрос для выяснения, являются ли неопределённые значения в столбцах,
kоторые соответствуют приведённым в предложении GROUP BY, результатом применения операции CUBE
*/
SELECT MANAGER_ID,
       JOB_ID,
       SUM(SALARY) SUM_SALARY,
       GROUPING(MANAGER_ID),
       GROUPING(JOB_ID)
FROM EMPLOYEES
WHERE JOB_ID IS NOT NULL
  AND MANAGER_ID IS NOT NULL
GROUP BY CUBE (MANAGER_ID, JOB_ID)
ORDER BY MANAGER_ID;

/*5.	Используя GROUPING SETS, напишите запрос для вывода данных по следующим группировкам:
•	department_id, manager_id, job_id
•	department_id, job_id
•	manager_id, job_id
Запрос должен подсчитывать сумму окладов для каждой группы.
*/
SELECT DEPARTMENT_ID,
       MANAGER_ID,
       JOB_ID,
       SUM(SALARY) SUM_SALARY
FROM EMPLOYEES
WHERE JOB_ID IS NOT NULL
  AND MANAGER_ID IS NOT NULL
  AND DEPARTMENT_ID IS NOT NULL
GROUP BY GROUPING SETS (
    ( DEPARTMENT_ID, MANAGER_ID, JOB_ID ),
    ( DEPARTMENT_ID, JOB_ID),
    ( MANAGER_ID, JOB_ID) );

/*6.	Написать запрос, выдающий отчёт о суммарных выплатах сотрудникам, непосредственно подчиняющихся
руководителю (задаётся полное имя) по названиям должностей (поле JOBS.Job_Title).
Отчёт должен содержать группы строк. Каждая группа относится к данному руководителю и
состоит из регулярных строк, отображающих суммарные выплаты и количество сотрудников на данной должности,
непосредственно подчиняющихся этому руководителю. Группу должна завершать строка с итоговыми значениями
суммарных выплат и количества сотрудников, для сотрудников, непосредственно подчиняющихся  данному руководителю.
В столбце «Должность» этой строки должна быть выведена должность руководителя.
Должна быть предусмотрена сортировка по столбцу Employee_id для руководителя.
Кроме того, отчёт должен быть завершён строкой, представляющей общий итог и содержащей количество
сотрудников и сумму выплат по всем упомянутым руководителям.
*/
SELECT FIRST_NAME || ' ' || LAST_NAME ||
       CASE
           WHEN GRJ = 1 AND GRM = 0
               THEN ' итоги:'
           WHEN GRJ = 1 AND GRM = 1
               THEN 'ОБЩИЙ ИТОГ' END
                                           AS "Руководитель",
       NVL(CASE
               WHEN GRJ = 1 AND GRM = 0
                   THEN JM.JOB_TITLE
               ELSE JO.JOB_TITLE END, ' ') AS "Должность",
       NUM_POD                             AS "Кол-во подчиненных",
       SUM_SALARY                          AS "Сумма"
FROM (SELECT MANAGER_ID,
             JOB_ID,
             COUNT(*)             NUM_POD,
             SUM(SALARY)          SUM_SALARY,
             GROUPING(MANAGER_ID) GRM,
             GROUPING(JOB_ID)     GRJ
      FROM EMPLOYEES
      WHERE JOB_ID IS NOT NULL
        AND MANAGER_ID IS NOT NULL
      GROUP BY ROLLUP (MANAGER_ID, JOB_ID)) MA

LEFT OUTER JOIN
     EMPLOYEES EM ON (EM.EMPLOYEE_ID = MA.MANAGER_ID)
         LEFT OUTER JOIN
     JOBS JO ON (JO.JOB_ID = MA.JOB_ID)
         LEFT OUTER JOIN
     JOBS JM ON (JM.JOB_ID = EM.JOB_ID)
ORDER BY MA.MANAGER_ID, MA.JOB_ID;

/* 1.	Установите в сеансе NLS_DATE_FORMAT в DD-MON-YYYY HH24:MI:SS */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

/*2.	Напишите запрос для вывода смещений (TZ_OFFSET) следующих временных зон:
US/Pacific-New
Singapore
Egypt

  Установите в сеансе значение параметра TIME_ZONE на US/Pacific-New
  Выведите в сеансе значения функций CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP

  Измените в сеансе значение параметра TIME_ZONE. Установите смещение для временной зоны Singapore
  Выведите в сеансе значения функций CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP

*/

SELECT TZ_OFFSET('US/Pacific-New'),
       TZ_OFFSET('Singapore'),
       TZ_OFFSET('Egypt')
FROM DUAL;

ALTER SESSION SET TIME_ZONE = 'US/Pacific-New';
SELECT CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP
FROM DUAL;

ALTER SESSION SET TIME_ZONE = 'Singapore';
SELECT CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP
FROM DUAL;

/*3.	Напишите запрос для вывода значений DBTIMEZONE и SESSIONTIMEZONE.*/
SELECT DBTIMEZONE, SESSIONTIMEZONE
FROM DUAL;

/*4.	Для сотрудников отдела 80 напишите запрос, который извлекает поле YEAR из столбца HIRE_DATE
  таблицы EMPLOYEES.*/

SELECT EXTRACT(YEAR FROM HIRE_DATE) AS YEAR
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 80;

/*5.	Установите в сеансе NLS_DATE_FORMAT в DD-MON-YYYY
*/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';

/*6.	Создайте запрос для вывода фамилии, месяца приема на работу, даты найма для тех сотрудников,
  которые были приняты на работу в январе независимо от года.*/

SELECT LAST_NAME,
       EXTRACT(MONTH FROM HIRE_DATE) AS MONTH,
       HIRE_DATE
FROM EMPLOYEES
WHERE EXTRACT(MONTH FROM HIRE_DATE) = 1;

/*1.	Создайте запрос для вывода фамилии, номера отдела и оклада всех служащих, чей номер отдела и оклад
  совпадают с номером отдела и окладом любого служащего, зарабатывающего комиссионные.*/

SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE (DEPARTMENT_ID, SALARY) IN
      (SELECT DEPARTMENT_ID, SALARY
       FROM EMPLOYEES
       WHERE COMMISSION_PCT IS NOT NULL);

/*2.	Выведите фамилию, название отдела и оклад всех служащих, чей оклад и комиссионные совпадают с окладом и
  комиссионными любого служащего, работающего в отделе, местоположение которого Location_ID = 1700.
 */

SELECT LAST_NAME, DEPARTMENT_NAME, SALARY
FROM EMPLOYEES
         LEFT OUTER JOIN DEPARTMENTS
                         USING (DEPARTMENT_ID)
WHERE (SALARY, NVL(COMMISSION_PCT, 0)) IN
      (SELECT SALARY, NVL(COMMISSION_PCT, 0)
       FROM EMPLOYEES
                LEFT OUTER JOIN DEPARTMENTS
                                USING (DEPARTMENT_ID)
       WHERE LOCATION_ID = 1700);

/*3.	Создайте запрос для вывода фамилии, даты найма и оклада всех служащих, которые получают такой же оклад и
  такие же комиссионные, как Kochhar. Не выводите данные о сотруднике Kochhar. */

SELECT LAST_NAME, HIRE_DATE, SALARY
FROM EMPLOYEES
WHERE (SALARY, NVL(COMMISSION_PCT, 0)) IN
      (SELECT SALARY, NVL(COMMISSION_PCT, 0)
       FROM EMPLOYEES
       WHERE LAST_NAME = 'Kochhar')
  AND LAST_NAME <> 'Kochhar';

/*4.	Выведите фамилию, должность и оклад всех служащих, оклад которых превышает оклад каждого торгового
  менеджера (JOB_ID = ‘SA_MAN’). Отсортируйте результаты по убыванию окладов. */

SELECT LAST_NAME, JOB_ID, SALARY
FROM EMPLOYEES
WHERE SALARY > (SELECT MAX(SALARY)
                FROM EMPLOYEES
                WHERE JOB_ID = 'SA_MAN')
ORDER BY SALARY DESC;

/*5.	Выведите номера, фамилии и отделы служащих, живущих в городах, названия которых начинаются с буквы Т. */

SELECT EMPLOYEE_ID, LAST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
         LEFT OUTER JOIN DEPARTMENTS
                         USING (DEPARTMENT_ID)
WHERE LOCATION_ID IN (
    SELECT LOCATION_ID
    FROM LOCATIONS
    WHERE CITY LIKE 'T%');

/*6.	Напишите запрос для нахождения всех сотрудников, которые зарабатывают больше среднего оклада
  по их отделу. Выведите фамилию, оклад, номер отдела и средний оклад по отделу.
  Отсортируйте результаты по средней зарплате. Используйте псевдонимы для выбираемых столбцов. */

SELECT LAST_NAME     AS ENAME,
       SALARY,
       DEPARTMENT_ID AS DEPT_NO,
       ROUND((SELECT AVG(SALARY)
              FROM EMPLOYEES
              WHERE E.DEPARTMENT_ID = DEPARTMENT_ID
             ), 4)   AS DEPT_AVG
FROM EMPLOYEES E
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEES
                WHERE E.DEPARTMENT_ID = DEPARTMENT_ID)
ORDER BY DEPT_AVG;

/*7.	Найдите всех сотрудников, не являющихся руководителями.
  Выполните это с помощью оператора NOT EXISTS.*/

SELECT LAST_NAME
FROM EMPLOYEES E
WHERE NOT EXISTS(
        SELECT EMPLOYEE_ID
        FROM EMPLOYEES
        WHERE MANAGER_ID = E.EMPLOYEE_ID);

/*8.	Может ли это же быть сделано с помощью оператора NOT IN?*/

SELECT LAST_NAME
FROM EMPLOYEES
WHERE EMPLOYEE_ID NOT IN (
    SELECT MANAGER_ID
    FROM EMPLOYEES
    WHERE MANAGER_ID IS NOT NULL);


/*9.	Выведите фамилии сотрудников, зарабатывающих меньше среднего оклада по их отделу*/

SELECT LAST_NAME
FROM EMPLOYEES E
WHERE SALARY < (
    SELECT AVG(SALARY)
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = E.DEPARTMENT_ID);

/*10.	Выведите фамилии сотрудников, у которых есть коллеги по отделу,
  которые были приняты на работу позже, но имеют более высокий оклад.*/

SELECT LAST_NAME
FROM EMPLOYEES E
WHERE EXISTS(
              SELECT EMPLOYEE_ID
              FROM EMPLOYEES
              WHERE DEPARTMENT_ID = E.DEPARTMENT_ID
                AND HIRE_DATE > E.HIRE_DATE
                AND SALARY > E.SALARY);

/*11.	Выведите номера, фамилии и наименования отделов всех сотрудников. Используйте
  скалярный подзапрос в команде SELECT для вывода наименований отделов.*/

SELECT EMPLOYEE_ID,
       LAST_NAME,
       (SELECT DEPARTMENT_NAME
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID = E.DEPARTMENT_ID) AS DEPARTMENT
FROM EMPLOYEES E
ORDER BY 3;

/*12.	Напишите запрос для вывода наименования отделов и фондов заработной платы отделов,
  размер которых больше 1/8 от общего фонда заработной платы всей компании.
  Используйте предложение WITH для создания запроса. Назовите запрос SUMMARY.*/

WITH SUMMARY AS (SELECT SUM(SALARY) AS SUMM
                 FROM EMPLOYEES)
SELECT DEPARTMENT_NAME, DEPT_TOTAL
FROM (SELECT DEPARTMENT_ID, SUM(SALARY) AS DEPT_TOTAL
      FROM EMPLOYEES
      GROUP BY DEPARTMENT_ID)
         LEFT OUTER JOIN DEPARTMENTS
                         USING (DEPARTMENT_ID)
WHERE DEPT_TOTAL > (SELECT * FROM SUMMARY) / 8;

/*1.	Напишите отчёт, в котором отражена структура отдела, которым руководит Mourgos.
  Выведите фамилии, оклады и номер отдела сотрудников.*/

SELECT LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES
START WITH LAST_NAME = 'Mourgos'
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;

/*2.	Создайте отчёт, который показывает иерархию менеджеров, которым подчиняется сотрудник Lorentz.
  Выведите сначала менеджера, перед которым непосредственно отчитывается Lorentz.*/

SELECT LAST_NAME
FROM EMPLOYEES
WHERE LAST_NAME <> 'Lorentz'
START WITH LAST_NAME = 'Lorentz'
CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID;

/*3.	Создайте отчёт с отступом, в котором отражается иерархия управления, начиная с сотрудника
  по фамилии Kochhar. Выведите фамилии, номера менеджеров и номера отделов сотрудников.
  Назовите столбцы как показано в примере выходных результатов. */

SELECT LPAD(LAST_NAME, 2 * (LEVEL - 1) + LENGTH(LAST_NAME), '_') AS NAME,
       MANAGER_ID                                                AS MGR,
       DEPARTMENT_ID                                             AS DEPTNO
FROM EMPLOYEES
START WITH LAST_NAME = 'Kochhar'
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;

/*4.	Создайте отчёт, отражающий иерархию управления компанией. Начните с
  сотрудника самого высокого уровня и исключите из выходных данных всех служащих с
  идентификатором должности ST_MAN, а также сотрудника De Haan и всех, кто перед ним отчитывается.*/

SELECT LPAD(LAST_NAME, (LEVEL - 1) + LENGTH(LAST_NAME), ' ') AS LAST_NAME,
       EMPLOYEE_ID,
       MANAGER_ID,
       JOB_ID
FROM EMPLOYEES
START WITH EMPLOYEE_ID = (SELECT EMPLOYEE_ID
                          FROM EMPLOYEES
                          WHERE MANAGER_ID IS NULL)
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
       AND LAST_NAME <> 'De Haan'
       AND JOB_ID <> 'ST_MAN';

/*5.	Создать запрос для вывода списка дат и дней недели, начиная с заданной даты до конца месяца.
  SQL Dev*/

DEFINE NEW_DATE = '18-2-2020'
SELECT TO_DATE('&&new_date', 'DD-MM-YYYY') + LEVEL - 1                AS SOME_DATE,
       TO_CHAR(TO_DATE('&new_date', 'DD-MM-YYYY') + LEVEL - 1, 'DAY') AS DAY_WEEK
FROM DUAL
CONNECT BY TO_DATE('&new_date', 'DD-MM-YYYY') + LEVEL - 1 <=
           LAST_DAY(TO_DATE('&new_date', 'DD-MM-YYYY'));
UNDEFINE NEW_DATE;

/*6.	Создать запрос для вывода только правильно написанных выражений со скобками (количество
  открывающих и закрывающих скобок должно быть одинаково, каждой открывающей скобке должна
  соответствовать закрывающая, первая скобка в выражении не должна быть закрывающей).
  Примеры неправильных выражений:
((((a)g)q)
z)(s)(
(((f)e)w))(h(g(w))
*/

WITH INPUT AS (
    SELECT '((((a)g)q))' S
    FROM DUAL
    UNION ALL
    SELECT '((((f)e)w))(h(g(w)))'
    FROM DUAL
    UNION ALL
    SELECT '(z)(s)()'
    FROM DUAL
    UNION ALL

SELECT '((((a)g)q)' STR
FROM DUAL
UNION ALL
SELECT '((a)g)q)' STR
FROM DUAL
UNION ALL
SELECT 'z)(s)('
FROM DUAL
UNION ALL
SELECT '(((f)e)w))(h(g(w))'
FROM DUAL ),
     TMP AS (
         SELECT DISTINCT S, instr(S, ')', 1, LEVEL) - instr(S, '(', 1, LEVEL) AS T
         FROM INPUT
         CONNECT BY instr(S, ')', 1, LEVEL) - instr(S, '(', 1, LEVEL) != 0
     )
SELECT S
FROM TMP
WHERE LENGTH(REPLACE(S, '(')) = LENGTH(REPLACE(S, ')'))
GROUP BY S
HAVING MIN(T) >= 0;


/*7.	Используя таблицы REGIONS, COUNTRIES, LOCATIONS, DEPARTMENTS, построить (показать) иерархию
  объектов "Регион – Страна – Местоположение – Подразделение" для региона name = ' Americas '.
  Иерархия должна быть построена (показана) одной командой SELECT.
  В результате вывести:
- номер уровня, на котором находится в иерархии данный объект (LEVEL),
- имя объекта, дополненное слева (LEVEL -1)*3 пробелами.
Объекты одного уровня должны быть отсортированы по именам.
*/

WITH DATA_TMP AS (
    SELECT '1_' || TO_CHAR(REGION_ID) AS O_ID,
           REGION_NAME                AS NAME,
           'NULL'                     AS REFER
    FROM REGIONS
    UNION
    SELECT '2_' || TO_CHAR(COUNTRY_ID), COUNTRY_NAME, '1_' || TO_CHAR(REGION_ID)
    FROM COUNTRIES
    UNION
    SELECT '3_' || TO_CHAR(LOCATION_ID), CITY, '2_' || TO_CHAR(COUNTRY_ID)
    FROM LOCATIONS
    UNION
    SELECT '4_' || TO_CHAR(DEPARTMENT_ID), DEPARTMENT_NAME, '3_' || TO_CHAR(LOCATION_ID)
    FROM DEPARTMENTS)
SELECT LEVEL                                           AS УРОВЕНЬ,
       LPAD(NAME, LENGTH(NAME) + (LEVEL - 1) * 3, ' ') AS ЕДИНИЦА
FROM DATA_TMP
START WITH REFER = 'NULL'
CONNECT BY PRIOR O_ID = REFER
ORDER SIBLINGS BY NAME;

/*1.	Создайте запрос для поиска в таблице EMPLOYEES сотрудников, чьи имена начинаются на “Na” или “Ne”.*/

SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEES
WHERE REGEXP_LIKE(FIRST_NAME, '^(N[ae])');

/*2.    Создайте запрос для удаления при отображении пробелов в столбце STREET_ADDRESS таблицы LOCATIONS.*/

SELECT STREET_ADDRESS,
       REGEXP_REPLACE(STREET_ADDRESS, '\s+', '') AS FIXED_ADDRESS
FROM LOCATIONS;

/*3.	Создайте запрос, который заменяет при отображении результата St на Street.
  Будьте осторожны, чтобы не изменения не коснулись тех строк, в которых уже есть Street.
  Выведите только те строки, которые Вы изменили.  */

SELECT STREET_ADDRESS,
       REGEXP_REPLACE(STREET_ADDRESS, '(\W)St($|\W)', '\1Street\2') AS FIXED_ADDRESS
FROM LOCATIONS
WHERE REGEXP_LIKE(STREET_ADDRESS, '\WSt($|\W)+');

/*4.	Создать запрос для выделения собственно имени файла из полного его имени. (Полное имя файла
  начинается с имени диска или имени сервера. Оно может содержать произвольное количество имен папок.
  Имя файла может иметь или не иметь расширения. Допускаются пробелы в именах  файлов и папок).*/

WITH DAT AS (
    SELECT 'C:\Windows\Drivers\etc\hosts' AS PATH
    FROM DUAL
    UNION ALL
    SELECT 'C:\Windows\explorer.exe' AS PATH
    FROM DUAL
    UNION ALL
    SELECT '/home/docs/labs.html' AS PATH
    FROM DUAL)
SELECT PATH,
       SUBSTR(REGEXP_SUBSTR(PATH, '(\\|/)([^(\\)(/)])+$'), 2)
           AS FIXED
FROM DAT;

/*5.	Создать запрос для выделения из символьной строки повторяющихся, стоящих рядом слов.*/

WITH DAT AS (SELECT 'кулон кулон где-то где-то лон слон слон слон Книга книга ' INPUT
             FROM DUAL),
     RESULT AS (SELECT DISTINCT INPUT,
                                TRIM(REGEXP_REPLACE(REGEXP_SUBSTR(' ' || DAT.INPUT, '( +\S+)\1+', 1, LEVEL, 'i'), ' +',
                                                    ' ')) OUTPUT
                FROM DAT
                CONNECT BY LEVEL <= LENGTH(INPUT))
SELECT CASE
           WHEN ROWNUM = 1 THEN INPUT
           ELSE ' '
           END STR,
       OUTPUT
FROM RESULT
WHERE OUTPUT IS NOT NULL;


/*6.	Создать условие для проверки правильности ввода номера телефона, который может быть записан в виде:
  (###) ###-##-## или в виде ###-##-##, где # - цифра.*/

WITH DAT (NUM) AS (
    SELECT '123-23-65'
    FROM DUAL
    UNION ALL
    SELECT '(124) 123-23-65'
    FROM DUAL
    UNION ALL
    SELECT '(1243) 123-23-65'
    FROM DUAL
    UNION ALL
    SELECT '(124) 1233-232-635'
    FROM DUAL
    UNION ALL
    SELECT '(124)123-23-65'
    FROM DUAL
    UNION ALL
    SELECT '(124) 1s3-d3-a5'
    FROM DUAL)
SELECT NUM AS VALID
FROM DAT
WHERE REGEXP_LIKE(NUM, '^(\((\d){3}\)\s)?(\d){3}-(\d){2}-(\d){2}$');

/*7.	Создать запрос для выделения только правильно написанных адресов электронной почты.
Под правильно написанными адресами почты будем понимать адреса, соответствующие следующим критериям:
a)	содержащие поля имя_пользователя и имя_домена, разделённые одним символом @
b)	полное имя домена может состоять из нескольких уровней, разделённых точкой (например, alias.spb.ru), точки в самом конце адреса быть не должно (например, 123@asd.com. – некорректный). Имя домена любого уровня (и alias, и spb, и ru) должно содержать не менее 2 символов.
c)	имя пользователя может содержать точку, но не на первой и не на последней позиции
d)	имена пользователя и домена (любого уровня) могут содержать дефис, но не на первой и не на последней позиции.
e)	имена пользователя и домена не должны содержать никаких других символов, кроме букв, цифр, дефиса и точки (адрес 1%#23@asd.com.ua должен определяться как некорректный).
*/

WITH DAT (ADDR) AS (
    SELECT '1@ru'
    FROM DUAL
    UNION ALL
    SELECT '123@asd.com.'
    FROM DUAL
    UNION ALL
    SELECT '(1243)123-23-65'
    FROM DUAL
    UNION ALL
    SELECT 'asdas@asda'
    FROM DUAL
    UNION ALL
    SELECT 'as.@asd.com'
    FROM DUAL
    UNION ALL
    SELECT '.as@asd.com'
    FROM DUAL
    UNION ALL
    SELECT '-user@asd.com'
    FROM DUAL
    UNION ALL
    SELECT 'user-@asd.com'
    FROM DUAL
    UNION ALL
    SELECT 'us-er@asd.com'
    FROM DUAL
    UNION ALL
    SELECT 'us-er@as.c'
    FROM DUAL
    UNION ALL
    SELECT 'u@ab.c.com'
    FROM DUAL
    UNION ALL
    SELECT '123@ad.cm.sa'
    FROM DUAL
    UNION ALL
    SELECT '1%#23@asd.com.ua'
    FROM DUAL)
SELECT ADDR AS VALID
FROM DAT
WHERE REGEXP_LIKE(ADDR,
                  '^((\d|\w)(\d|\w|\.|-)+)?(\d|\w)@' ||
                  '(((\d|\w)(\d|\w|-)*(\d|\w)\.)*((\d|\w)(\d|\w|-)*))?(\d|\w)$');

/*8.	Создать запрос для определения в тексте чисел, за которыми ни в одном месте текста
  не стоит знак  +. Знак числа не выводить. Предположить, что разделителей разрядов в тексте нет.
  Результат отсортировать по возрастанию. */

WITH DAT (TXT) AS (
    SELECT 'Результатом вычисления выражения 2.5*3.000-6*5 будет число -22.5, а результатом вычисления выражения (3.0+5)-9*4 – число -28'
    FROM DUAL),
     VALS AS (SELECT TXT,
                     (REGEXP_SUBSTR(TXT,
                                    '(\d)+((\.)(\d)+)?(\D|$)', 1, LEVEL)) AS VAL,
                     LEVEL
              FROM DAT
              CONNECT BY LEVEL <= REGEXP_COUNT(TXT, '(\d)+((\.)(\d)+)?(\D|$)')),
     EXCLUDED_VALS AS (SELECT TO_NUMBER(REPLACE(REGEXP_REPLACE(VAL, '\+', ''), '.', ',')) AS VAL, TXT
                       FROM VALS
                       WHERE REGEXP_LIKE(VAL, '\+$')),
     RESULT AS (SELECT DISTINCT TO_NUMBER(REPLACE(REGEXP_SUBSTR(VAL,
                                                                '(\d)+((\.)(\d)+)?', 1), '.', ',')) AS VAL,
                                TXT
                FROM VALS
                MINUS
                SELECT VAL, TXT
                FROM EXCLUDED_VALS)
SELECT LTRIM(SYS_CONNECT_BY_PATH(REPLACE(TO_CHAR(VAL), ',', '.'), ' ')) AS РЕЗУЛЬТАТ,
       TXT                                                              AS ТЕКСТ
FROM RESULT
WHERE LEVEL = (SELECT COUNT(VAL) FROM RESULT)
CONNECT BY PRIOR TO_NUMBER(REPLACE(VAL, '.', ',')) <
           TO_NUMBER(REPLACE(VAL, '.', ','))
START WITH VAL = (SELECT MIN(VAL) FROM RESULT);

/*9.	Создать запрос для выбора из текста дробных чисел с разделителем дробной части в
  виде точки. Тройки цифр целой части могут разделяться пробелом, запятой или ничем не разделяться.
  Дробная часть всегда записывается слитно. Совместное использование разных разделителей в одном
  числе не допускается. */

WITH DAT (TXT) AS (SELECT '1245.323 Пусть имеем 212 45 567.456 789 или 212,13,245.4568'
                   FROM DUAL
                   UNION ALL
                   SELECT 'Имеется 123456.345 567 123.375'
                   FROM DUAL),
     PREPARED AS (SELECT DISTINCT LEVEL AS LVL,
                                  TXT,
                                  SUBSTR(REGEXP_SUBSTR(' ' || TXT,
                                                       '\D(\d{1,3})((\s\d{3})+|(\d{3})+|(\,\d{3})+)?\.(\d{1,})', 1,
                                                       LEVEL), 2)
                                        AS NUM
                  FROM DAT
                  CONNECT BY REGEXP_COUNT(' ' || TXT,
                                          '\D(\d{1,3})((\s\d{3})+|(\d{3})+|(\,\d{3})+)?\.(\d{1,})') >= LEVEL
                  ORDER BY 2, 1)
SELECT CASE LVL WHEN 1 THEN TXT ELSE ' ' END AS "Текст",
       NUM                                   AS "Результат"
FROM PREPARED;


/*10.	Написать запрос к таблице, который вернёт значения столбца SOURCE, где все пары прямых скобок в строке, внутри которых нет других прямых скобок, заменит на круглые скобки.
Пример.
Значение SOURCE было:
A[[B[C][D]E[F[J]]H][K]L]M
Результат преобразования:
A[[B(C)(D)E[F(J)]H](K)L]M
*/

WITH S AS (SELECT 'A[[B[dC][D13]E[F[J]]H][K]L]M' STR
           FROM DUAL)
SELECT STR SOURCE, REGEXP_REPLACE(S.STR, '\[(\w+)\]', '(\1)') RES
FROM S;


/*1.	Вычислить отношение зарплаты каждого служащего, работающего на должности  PU_CLERK, к суммарной зарплате всех служащих PU_CLERK.*/

SELECT LAST_NAME,
       SALARY,
       ROUND(SALARY / SUM(SALARY) OVER (PARTITION BY JOB_ID), 9) RR
FROM EMPLOYEES
WHERE JOB_ID = 'PU_CLERK';

/*2.	Вычислить разницу между двумя следующими друг за другом зарплатами сотрудников.*/

SELECT EMPLOYEE_ID,
       LAST_NAME,
       JOB_ID,
       SALARY,
       LAG(SALARY, 1, 0) OVER (ORDER BY SALARY DESC)          SAL_PREV,
       SALARY - LAG(SALARY, 1, 0) OVER (ORDER BY SALARY DESC) SAL_DIFF
FROM EMPLOYEES;

/*3.	Определить ранги сотрудников по получаемой ими зарплате в отделах.*/

SELECT LAST_NAME,
       DEPARTMENT_ID,
       SALARY,
       RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY)       "RANK",
       DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY) "DENSE_RANK"
FROM EMPLOYEES;

/*4.	Определить накапливаемую в пределах отделов сумму зарплат сотрудников.*/

SELECT LAST_NAME,
       DEPARTMENT_ID,
       SALARY,
       SUM(SALARY)
           OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ACC_SAL
FROM EMPLOYEES;

/*5.	Вывести список сотрудников каждого отдела в строку через запятую */

SELECT DEPARTMENT_ID,
       LISTAGG(LAST_NAME, ', ') WITHIN GROUP (ORDER BY DEPARTMENT_ID) NAME_LIST
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID;

/*6.	Вывести список сотрудников отделов с тремя наибольшими зарплатами в виде столбцов. Запрос должен возвращать
  ровно одну строку для каждого отела, причем в строке должно быть 4 столбца: Номер отдела, Фамилия сотрудника
  с наивысшей зарплатой в отделе, Фамилия сотрудника со следующей зарплатой и т.д.*/

WITH DAT AS (SELECT DEPARTMENT_ID,
                    LAST_NAME,
                    DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) R,
                    ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) R1
             FROM EMPLOYEES)
SELECT NVL(TO_CHAR(DEPARTMENT_ID), ' ') DEPARTMENT_ID,
       HIGHEST_PAID,
       SECOND_HIGHEST,
       THIRD_HIGHEST
FROM (SELECT DEPARTMENT_ID,
             NVL(HIGHEST_PAID, ' ')   HIGHEST_PAID,
             NVL(SECOND_HIGHEST, ' ') SECOND_HIGHEST,
             NVL(THIRD_HIGHEST, ' ')  THIRD_HIGHEST
      FROM ((SELECT DEPARTMENT_ID,
                    LAST_NAME HIGHEST_PAID
             FROM DAT
             WHERE R = 1
               AND R = R1)
               LEFT JOIN
           (SELECT DEPARTMENT_ID, LAST_NAME SECOND_HIGHEST
            FROM DAT
            WHERE R = 2
              AND R = R1)
           USING (DEPARTMENT_ID)
               LEFT JOIN
           (SELECT DEPARTMENT_ID, LAST_NAME THIRD_HIGHEST
            FROM DAT
            WHERE R = 3
              AND R = R1)
           USING (DEPARTMENT_ID))
      ORDER BY 1);

/*7.	Вывести список из трех или менее сотрудников, получающих один из трех максимальных окладов по отделу.
  Если четыре человека получают одинаковый – самый максимальный – оклад, в ответ не должно выдаваться ни одной строки.
  Если два сотрудника имеют максимальный оклад, а два – следующий по значению, ответ будет предполагать две строки
  (два сотрудника с максимальным окладом). */

WITH NO AS (
    SELECT *
    FROM (SELECT DEPARTMENT_ID,
                 LAST_NAME,
                 SALARY,
                 RANK,
                 ROWN,
                 COUNT(RANK) OVER (PARTITION BY DEPARTMENT_ID) CNT_RANK,
                 LAG(RANK, 1, 1) OVER (ORDER BY SALARY DESC)   LAG_RANK
          FROM (SELECT DEPARTMENT_ID,
                       LAST_NAME,
                       SALARY,
                       RANK,
                       ROWN
                FROM (SELECT DEPARTMENT_ID,
                             LAST_NAME,
                             SALARY,
                             DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) RANK,
                             ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) ROWN
                      FROM EMPLOYEES)
                WHERE RANK <= 3))
    WHERE CNT_RANK = 4
      AND RANK != LAG_RANK)
SELECT DEPARTMENT_ID,
       LAST_NAME,
       SALARY,
       RANK CNT
FROM (SELECT DEPARTMENT_ID,
             LAST_NAME,
             SALARY,
             RANK,
             ROWN,
             SUM(RANK) OVER (PARTITION BY DEPARTMENT_ID)   SUM_RANK,
             COUNT(RANK) OVER (PARTITION BY DEPARTMENT_ID) CNT_RANK
      FROM (SELECT DEPARTMENT_ID,
                   LAST_NAME,
                   SALARY,
                   RANK,
                   ROWN
            FROM (SELECT DEPARTMENT_ID,
                         LAST_NAME,
                         SALARY,
                         DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) RANK,
                         ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) ROWN
                  FROM EMPLOYEES)
            WHERE RANK <= 3))
WHERE SUM_RANK != 4
  AND (DEPARTMENT_ID, SALARY, RANK) NOT IN (SELECT DEPARTMENT_ID,
                                                   SALARY,
                                                   RANK
                                            FROM NO)
ORDER BY 1 NULLS LAST;

/*8.	Определить список отделов, суммарная зарплата в которых больше средней суммарной зарплаты в отделах в городах,
  где расположены отделы. В отделах без сотрудников суммарную зарплату считать равной нулю и учитывать при подсчёте
  среднего значения по городу.*/

WITH DEP AS (SELECT DISTINCT DEPARTMENT_ID,
                             DEPARTMENT_NAME,
                             SUM(SALARY) OVER (PARTITION BY DEPARTMENT_ID) SUM_DEP,
                             LOCATION_ID
             FROM EMPLOYEES
                      RIGHT JOIN DEPARTMENTS
                                 USING (DEPARTMENT_ID)),
     SAL_CITY AS (SELECT DEPARTMENT_ID,
                         DEPARTMENT_NAME,
                         SUM_DEP,
                         LOCATION_ID,
                         AVG(NVL(SUM_DEP, 0)) OVER (PARTITION BY LOCATION_ID) SUM_CITY
                  FROM DEP)
SELECT DEPARTMENT_ID,
       DEPARTMENT_NAME
FROM SAL_CITY
WHERE SUM_DEP > SUM_CITY
ORDER BY 1;


/*9.	Вывести из таблицы EMPLOYEES информацию о сотрудниках отделов с номерами 10,30,50,90. Вывод должен быть оформлен в таблицу, содержащую столбцы:
  1. Сквозной порядковый номер сотрудника (1…n).
  2. Порядковый номер сотрудника внутри отдела (1…n).
  3. Номер отдела для данного сотрудника (Department_id).
  4. Должность сотрудника (Job_id).
  5. Фамилия сотрудника (Last_name).
  6. Оклад (Salary).
  7. Ранг зарплаты сотрудника в отделе (1-самый высокооплачиваемый).
Строки в выводимой таблице должны удовлетворять следующим условиям:
  1. Строки, представляющие сотрудников одного отдела должны  располагаться друг за другом.
 2. Строки, представляющие сотрудников одного отдела должны располагаться в порядке убывания окладов. При совпадении рангов оклада строки должны располагаться в порядке увеличения идентификатора сотрудника.
*/

WITH ROWN AS (SELECT ROW_NUMBER() OVER (ORDER BY EMPLOYEE_ID) R,
                     EMPLOYEE_ID
              FROM EMPLOYEES)
SELECT (SELECT R FROM ROWN WHERE EMPLOYEE_ID = E.EMPLOYEE_ID)              "SERIAL NUMBER",
       ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_ID ORDER BY EMPLOYEE_ID) "SERIAL NUMBER IN DEP",
       DEPARTMENT_ID,
       JOB_ID,
       LAST_NAME,
       SALARY,
       RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC)       RANK
FROM EMPLOYEES E
WHERE DEPARTMENT_ID IN (10, 30, 50, 90)
ORDER BY 3, 6 DESC, 7, EMPLOYEE_ID;

/*1.	Создать запрос для вычисления суммарных зарплат сотрудников  и количеств сотрудников, работающих на должностях
  ST_CLERK, ST_MAN, AD_PRES и SA_REP в отделах Shipping и Executive,  а также не приписанных ни к одному отделу.
  Предусмотрите нумерацию записей (столбец ID)  и сортировку по DEP_ID, SAL, CNT и JOB_ID.*/

WITH T AS (SELECT DISTINCT DEPARTMENT_ID   DEP_ID,
                           DEPARTMENT_NAME DEP_NAME,
                           JOB_ID,
                           CNT,
                           SAL
           FROM EMPLOYEES
                    LEFT JOIN DEPARTMENTS
                              USING (DEPARTMENT_ID)
           WHERE JOB_ID IN ('ST_CLERK', 'ST_MAN', 'AD_PRES', 'SA_REP')
               AND DEPARTMENT_NAME IN ('Shipping', 'Executive')
              OR DEPARTMENT_ID IS NULL
               MODEL
                   PARTITION BY (DEPARTMENT_ID, DEPARTMENT_NAME)
                   DIMENSION BY (JOB_ID, EMPLOYEE_ID)
                   MEASURES (0 CNT, 0 SAL, SALARY, EMPLOYEE_ID EMP_ID)
                   RULES UPSERT ALL (
                   CNT[FOR JOB_ID IN ('ST_CLERK', 'ST_MAN', 'AD_PRES', 'SA_REP'),ANY] = COUNT(EMP_ID)[CV(), ANY],
                   SAL[ANY,ANY] = SUM(SALARY)[CV(), ANY])
           ORDER BY 1, 5 DESC NULLS LAST, 4, 3)
SELECT ROWNUM                      ID,
       NVL(TO_CHAR(DEP_ID), ' ')   DEP_ID,
       NVL(TO_CHAR(DEP_NAME), ' ') DEP_NAME,
       JOB_ID,
       CASE
           WHEN CNT = 0
               THEN ' '
           ELSE TO_CHAR(CNT)
           END                     CNT,
       NVL(TO_CHAR(SAL), ' ')      SAL
FROM T;

/*2.	Создайте представление DISTR_VIEW на основе запроса, полученного в предыдущем пункте. Проверьте его работоспособность.*/

CREATE OR REPLACE VIEW DISTR_VIEW AS
WITH T AS (
    SELECT DISTINCT DEPARTMENT_ID   DEP_ID,
                    DEPARTMENT_NAME DEP_NAME,
                    JOB_ID,
                    CNT,
                    SAL
    FROM EMPLOYEES
             LEFT JOIN DEPARTMENTS
                       USING (DEPARTMENT_ID)
    WHERE JOB_ID IN ('ST_CLERK', 'ST_MAN', 'AD_PRES', 'SA_REP')
        AND DEPARTMENT_NAME IN ('Shipping', 'Executive')
       OR DEPARTMENT_ID IS NULL
        MODEL
            PARTITION BY (DEPARTMENT_ID, DEPARTMENT_NAME)
            DIMENSION BY (JOB_ID, EMPLOYEE_ID)
            MEASURES (0 CNT, 0 SAL, SALARY, EMPLOYEE_ID EMP_ID)
            RULES UPSERT ALL (
            CNT[FOR JOB_ID IN ('ST_CLERK', 'ST_MAN', 'AD_PRES', 'SA_REP'),ANY] = COUNT(EMP_ID)[CV(), ANY],
            SAL[ANY,ANY] = SUM(SALARY)[CV(), ANY])
    ORDER BY 1, 5 DESC NULLS LAST, 4, 3)
SELECT ROWNUM  ID,
       DEP_ID,
       DEP_NAME,
       JOB_ID,
       CASE
           WHEN CNT = 0
               THEN NULL
           ELSE CNT
           END CNT,
       SAL
FROM T;

SELECT ID,
       NVL(TO_CHAR(DEP_ID), ' ') DEP_ID,
       NVL(DEP_NAME, ' ')        DEP_NAME,
       NVL(JOB_ID, ' ')          JOB_ID,
       NVL(TO_CHAR(CNT), ' ')    CNT,
       NVL(TO_CHAR(SAL), ' ')    SAL
FROM DISTR_VIEW;

/*3.	Создайте запрос к представлению DISTR_VIEW с разделом MODEL для отображения информации в виде:*/

SELECT НОМЕР,
       НАЗВАНИЕ_ОТДЕЛА,
       ДОЛЖНОСТЬ,
       NVL(TO_CHAR("Кол-во"), ' ')     "Кол-во",
       NVL(TO_CHAR("Сумм_Зарпл"), ' ') "Сумм_Зарпл"
FROM DISTR_VIEW
    MODEL
        DIMENSION BY (DEP_ID, JOB_ID ДОЛЖНОСТЬ)
        MEASURES (DEP_NAME НАЗВАНИЕ_ОТДЕЛА, CNT "Кол-во", SAL "Сумм_Зарпл", ID НОМЕР)
        RULES ( НАЗВАНИЕ_ОТДЕЛА[NULL, ANY]='Отдел не определен');

/*4.	Создайте запрос с использованием раздела MODEL для отображения данных представления DISTR_VIEW,
  добавив в отдел  Executive сотрудника в должности SA_REP с зарплатой 5000
Выведите сначала все строки, а затем измените запрос так, чтобы обеспечить вывод только измененных строк.  */

SELECT НОМЕР,
       NVL(НАЗВАНИЕ_ОТДЕЛА, 'Отдел не определен') НАЗВАНИЕ_ОТДЕЛА,
       ДОЛЖНОСТЬ,
       NVL(TO_CHAR("Кол-во"), ' ')                "Кол-во",
       NVL(TO_CHAR("Сумм_Зарпл"), ' ')            "Сумм_Зарпл"
FROM DISTR_VIEW
    MODEL
        DIMENSION BY (DEP_NAME НАЗВАНИЕ_ОТДЕЛА, JOB_ID ДОЛЖНОСТЬ)
        MEASURES (CNT "Кол-во", SAL "Сумм_Зарпл", ID НОМЕР) IGNORE NAV
        RULES ("Кол-во"['Executive', 'SA_REP'] = "Кол-во"[CV(), CV()] + 1,
        "Сумм_Зарпл"['Executive', 'SA_REP'] = "Сумм_Зарпл"[CV(), CV()] + 5000)
ORDER BY 1;

SELECT НОМЕР,
       NVL(НАЗВАНИЕ_ОТДЕЛА, 'Отдел не определен') НАЗВАНИЕ_ОТДЕЛА,
       ДОЛЖНОСТЬ,
       NVL(TO_CHAR("Кол-во"), ' ')                "Кол-во",
       NVL(TO_CHAR("Сумм_Зарпл"), ' ')            "Сумм_Зарпл"
FROM DISTR_VIEW
    MODEL
        RETURN UPDATED ROWS
        DIMENSION BY (DEP_NAME НАЗВАНИЕ_ОТДЕЛА, JOB_ID ДОЛЖНОСТЬ)
        MEASURES (CNT "Кол-во", SAL "Сумм_Зарпл", ID НОМЕР) IGNORE NAV
        RULES ( "Кол-во"['Executive', 'SA_REP']="Кол-во"[CV(), CV()] + 1,
        "Сумм_Зарпл"['Executive', 'SA_REP']="Сумм_Зарпл"[CV(), CV()] + 5000)
ORDER BY 1;

/*5.	Создайте запрос к представлению DISTR_VIEW с использованием раздела MODEL для получения отчета в виде:*/

SELECT NVL(TO_CHAR(ID), ' ')           НОМЕР,
       CASE
           WHEN НАЗВАНИЕ_ОТДЕЛА IN ('flag1', 'flag2') THEN ' '
           WHEN НАЗВАНИЕ_ОТДЕЛА IS NULL THEN 'Отдел не определен'
           ELSE НАЗВАНИЕ_ОТДЕЛА
           END                         НАЗВАНИЕ_ОТДЕЛА,
       ДОЛЖНОСТЬ,
       NVL(TO_CHAR("Кол-во"), ' ')     "Кол-во",
       NVL(TO_CHAR("Сумм_Зарпл"), ' ') "Сумм_Зарпл",
       КОММЕНТАРИИ
FROM DISTR_VIEW
    MODEL
        DIMENSION BY (DEP_NAME НАЗВАНИЕ_ОТДЕЛА, JOB_ID ДОЛЖНОСТЬ)
        MEASURES (ID, CNT "Кол-во", SAL "Сумм_Зарпл", CAST(' ' AS VARCHAR(100)) КОММЕНТАРИИ)
        RULES ( "Кол-во"['Executive', 'SA_REP']="Кол-во"[CV(), CV()] + 1,
        "Сумм_Зарпл"['Executive', 'SA_REP']="Сумм_Зарпл"[CV(), CV()] + 5000,
        "Сумм_Зарпл"['flag1', ' ']=SUM("Сумм_Зарпл")[ANY, ANY],
        КОММЕНТАРИИ['flag1', ' ']='Сумма з/п в отд Executive и Shipping',
        "Сумм_Зарпл"['flag2', ' ']=SUM("Сумм_Зарпл")[ANY, 'SA_REP'] + SUM("Сумм_Зарпл")[ANY, 'AD_PRES'],
        КОММЕНТАРИИ['flag2', ' ']='Сумма з/п в долж SA_REP и AD_PRES')
ORDER BY ID;

/*6.	Создайте запрос к представлению DISTR_VIEW для определения названий отделов, списков должностей,
  на которых работают и получают зарплаты сотрудники, и список суммарных зарплат на этих должностях.*/

WITH T1 AS (SELECT DEP_NAME,
                   JOB_ID,
                   SAL
            FROM DISTR_VIEW
            WHERE CNT IS NOT NULL),
     RES AS (SELECT D_NAME,
                    SUBSTR(JOB, 2)    ДОЛЖ,
                    SUBSTR(SALARY, 2) ЗАРПЛ
             FROM T1
                 MODEL
                     RETURN UPDATED ROWS
                     PARTITION BY (DEP_NAME d_NAME)
                     DIMENSION BY (ROW_NUMBER() OVER (PARTITION BY DEP_NAME ORDER BY JOB_ID DESC, SAL DESC ) AS POSITION)
                     MEASURES (CAST(JOB_ID AS VARCHAR2(100)) AS JOB, CAST(SAL AS VARCHAR2(100)) AS SALARY)
                     RULES UPSERT
                     ITERATE (10) UNTIL (PRESENTV(JOB[ITERATION_NUMBER + 2], 1, 0) = 0 )
                     (JOB[0] = JOB[0] || ', ' || JOB[ITERATION_NUMBER + 1],
                     SALARY[0] = SALARY[0] || ', ' || SALARY[ITERATION_NUMBER + 1])
             ORDER BY 1 NULLS LAST)
SELECT NVL(D_NAME, ' ') НАЗВАНИЕ_ОТДЕЛА,
       ДОЛЖ,
       ЗАРПЛ
FROM RES;

/*7.	В произвольной символьной строке оставить между словами только по одному пробелу. Обеспечьте вывод исходной и
  измененной строк. Задачу решить средствами раздела MODEL.
 */

SELECT ID,
       STR
FROM DUAL
    MODEL
        DIMENSION BY (1 ID)
        MEASURES (CAST(' ' AS VARCHAR(100)) STR)
        RULES ITERATE (1000) UNTIL (ITERATION_NUMBER > 0 AND PREVIOUS(STR[2]) = STR[2]) (
        STR[1] = ' FUCK     THIS SHIT IM     OUT' ,
        STR[2] = CASE
                     WHEN ITERATION_NUMBER = 0 THEN STR[1]
                     ELSE TRIM(REPLACE(STR[2], '  ', ' '))
        END );

/*8.	Создайте запрос для вывода всех суббот и воскресений между двумя заданными датами. Задачу решить с использованием раздела WITH.
Результат для дат 1 октября 2018 года и 25 октября 2018 года:*/

WITH DATA AS (SELECT CASE
                         WHEN TO_CHAR(TO_DATE($(start_date?), 'dd.mm.syyyy'), 'd') = '6'
                             THEN TO_DATE($(start_date?), 'dd.mm.syyyy')
                         WHEN TO_CHAR(TO_DATE($(start_date?), 'dd.mm.syyyy'), 'd') = '7'
                             THEN TO_DATE($(start_date?), 'dd.mm.syyyy')
                         ELSE NEXT_DAY(TO_DATE($(start_date?), 'dd.mm.syyyy'), 6)
                         END FD
              FROM DUAL),
     REC(D) AS (SELECT FD DAY
                FROM DATA
                UNION ALL
                SELECT CASE
                           WHEN TO_CHAR(D, 'd') = '6' THEN D + 1
                           WHEN TO_CHAR(D, 'd') = '7' THEN D + 6
                           ELSE D + 7
                           END
                FROM REC
                WHERE D < TO_DATE($(end_date?))
                  AND D < TO_DATE('26.12.9999'))
SELECT CASE
           WHEN EXTRACT(YEAR FROM D) < 0
               THEN TO_CHAR(D - 2, 'dd-Mon-syyyy ') || TO_CHAR(D, 'Day')
           ELSE TO_CHAR(D, 'dd-Mon-syyyy Day') END AS DAT_DATE
FROM REC
WHERE EXTRACT(YEAR FROM D) <> 0
  AND D BETWEEN TO_DATE($(start_date?), 'dd.mm.syyyy')
    AND TO_DATE($(end_date?), 'dd.mm.syyyy');


/*9.	Создайте отчёт с отступом, в котором отражается иерархия управления, начиная с сотрудника, не имеющего начальника.
  Выведите фамилии, номера сотрудников, менеджеров и уровни подчиненности. Назовите столбцы и отсортируйте результаты
  как показано в примере выходных результатов.  Задачу решить без использования средств иерархических запросов.*/

WITH T1 (LAST_NAME, EMPLOYEE_ID, MANAGER_ID, LEV) AS (
    SELECT LAST_NAME,
           EMPLOYEE_ID,
           MANAGER_ID,
           1 LEV
    FROM EMPLOYEES
    WHERE MANAGER_ID IS NULL
    UNION ALL
    SELECT E.LAST_NAME, E.EMPLOYEE_ID, E.MANAGER_ID, LEV + 1
    FROM EMPLOYEES E
             JOIN T1 M
                  ON (E.MANAGER_ID = M.EMPLOYEE_ID))
         SEARCH DEPTH FIRST BY EMPLOYEE_ID SET ORDERVAL
SELECT LPAD('-', LEV - 1, '-') || LAST_NAME EMPLOYEE,
       EMPLOYEE_ID,
       MANAGER_ID,
       LEV
FROM T1
ORDER BY ORDERVAL;

/*10.	Создать запрос для записи произвольного символьного выражения в обратном порядке символов.
  Обеспечьте вывод исходной и измененной строк. Задачу решить средствами раздела WITH без использования недокументированных функций.*/

WITH S_NORM AS (SELECT 'Hello, my friend!' STR
                FROM DUAL),
     S_NOT (STR, LEV, RTS) AS (SELECT STR, 1 LEV, SUBSTR(STR, LENGTH(STR), 1) RTS
                               FROM S_NORM
                               UNION ALL
                               SELECT S_NOT.STR, LEV + 1, RTS || SUBSTR(S_NOT.STR, LENGTH(S_NOT.STR) - LEV, 1)
                               FROM S_NOT
                                        JOIN S_NORM
                                             ON LEV < LENGTH(S_NOT.STR))
SELECT STR ИСХОДНАЯ_СТРОКА,
       RTS ИЗМЕНЕННАЯ_СТРОКА
FROM S_NOT
WHERE LENGTH(RTS) = LENGTH(STR);


/*11.	Создать запрос для вычисления суммарных зарплат сотрудников, работающих на должностях
  MK_MAN, MK_REP, AD_ASST, SA_REP, IT_PROG, PU_MAN, PU_CLERK для всех отделов, в которых работают сотрудники
  на перечисленных должностях. Задачу решить без использования функций DECODE и CASE*/

SELECT DPT_ID,
       NVL(TO_CHAR(MK_MAN), ' ')   MK_MAN,
       NVL(TO_CHAR(MK_REP), ' ')   MK_REP,
       NVL(TO_CHAR(AD_ASST), ' ')  AD_ASST,
       NVL(TO_CHAR(SA_REP), ' ')   SA_REP,
       NVL(TO_CHAR(IT_PROG), ' ')  IT_PROG,
       NVL(TO_CHAR(PU_MAN), ' ')   PU_MAN,
       NVL(TO_CHAR(PU_CLERK), ' ') PU_CLERK
FROM
    (SELECT DEPARTMENT_ID DPT_ID,
            JOB_ID,
            SALARY
     FROM EMPLOYEES
     WHERE JOB_ID IN ('MK_MAN', 'MK_REP', 'AD_ASST', 'SA_REP', 'IT_PROG', 'PU_MAN', 'PU_CLERK')
       AND DEPARTMENT_ID IS NOT NULL)
        PIVOT ( SUM(SALARY)
        FOR JOB_ID IN ('MK_MAN' AS MK_MAN, 'MK_REP' AS MK_REP, 'AD_ASST' AS AD_ASST,
        'SA_REP' AS SA_REP, 'IT_PROG' AS IT_PROG, 'PU_MAN' AS PU_MAN, 'PU_CLERK' AS PU_CLERK) )
ORDER BY DPT_ID;

/*12.	Создать таблицу JOB_SUM_SAL на основе команды SELECT из п.11. Проверить работоспособность таблицы, выполнив извлечения из нее данных.*/

CREATE TABLE JOB_SUM_SAL AS
SELECT *
FROM (SELECT DEPARTMENT_ID DPT_ID,
             JOB_ID,
             SALARY
      FROM EMPLOYEES
      WHERE JOB_ID IN ('MK_MAN', 'MK_REP', 'AD_ASST', 'SA_REP', 'IT_PROG', 'PU_MAN', 'PU_CLERK')
        AND DEPARTMENT_ID IS NOT NULL)
    PIVOT ( SUM(SALARY)
    FOR JOB_ID IN ('MK_MAN' AS MK_MAN, 'MK_REP' AS MK_REP, 'AD_ASST' AS AD_ASST,
        'SA_REP' AS SA_REP, 'IT_PROG' AS IT_PROG, 'PU_MAN' AS PU_MAN, 'PU_CLERK' AS PU_CLERK) )
ORDER BY DPT_ID;

SELECT *
FROM JOB_SUM_SAL;

DROP TABLE JOB_SUM_SAL;

/*13.	Создать запрос к таблице JOB_SUM_SAL для представления информации в виде:*/

SELECT *
FROM JOB_SUM_SAL
    UNPIVOT ( JOB_SUM_SAL
    FOR JOB_ID IN (MK_MAN, MK_REP, AD_ASST, SA_REP,IT_PROG, PU_MAN, PU_CLERK) );

/*14.	Получить информацию в формате XML:*/

SELECT DPT_ID, JOB_ID_XML
FROM (SELECT DEPARTMENT_ID DPT_ID, JOB_ID, SALARY
      FROM EMPLOYEES)
    PIVOT XML ( SUM(SALARY) SUM
    FOR JOB_ID IN (ANY) )
ORDER BY DPT_ID NULLS LAST;