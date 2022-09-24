/* Задачи на использование таблиц БД Студент */

/*1. Вывести имена и фамилии преподавателей наряду с именами и фамилиями их начальников.
Результат должен содержать два столбца: employee и manager. Разделитель имени и фамилии -
пробел. Самого главного начальника не выводить.
 */

SELECT SUB.ФАМИЛИЯ || ' ' || SUB.ИМЯ   AS "EMPLOYEE",
       MAIN.ФАМИЛИЯ || ' ' || MAIN.ИМЯ AS "MANAGER"
FROM ПРЕПОДАВАТЕЛЬ SUB
       INNER JOIN ПРЕПОДАВАТЕЛЬ MAIN
                  ON SUB.ПОДЧИНЯЕТСЯ = MAIN.НОМЕР_ПРЕПОДАВАТЕЛЯ;

/*2. Вывести фамилии студентов и названия дисциплин, предусмотренных их учебным планом,
экзамен по которым они сдали с первой попытки.
 */

SELECT STUD.ФАМИЛИЯ AS FIRST_NAME, DISC.НАЗВАНИЕ AS DISC_NAME
FROM УСПЕВАЕМОСТЬ PRGRS
       INNER JOIN СТУДЕНТ STUD ON PRGRS.НОМЕР_СТУДЕНТА = STUD.НОМЕР_СТУДЕНТА
       INNER JOIN ДИСЦИПЛИНА DISC ON PRGRS.НОМЕР_ДИСЦИПЛИНЫ = DISC.НОМЕР_ДИСЦИПЛИНЫ
WHERE PRGRS.ОЦЕНКА != 2
MINUS
SELECT STUD.ФАМИЛИЯ AS FIRST_NAME, DISC.НАЗВАНИЕ AS DISC_NAME
FROM УСПЕВАЕМОСТЬ PRGRS
       INNER JOIN СТУДЕНТ STUD ON PRGRS.НОМЕР_СТУДЕНТА = STUD.НОМЕР_СТУДЕНТА
       INNER JOIN ДИСЦИПЛИНА DISC ON PRGRS.НОМЕР_ДИСЦИПЛИНЫ = DISC.НОМЕР_ДИСЦИПЛИНЫ
WHERE PRGRS.ОЦЕНКА = 2;

SELECT STUD.ФАМИЛИЯ, DISC.НАЗВАНИЕ
FROM СТУДЕНТ STUD
       INNER JOIN ГРУППА GRP ON STUD.НОМЕР_ГРУППЫ = GRP.НОМЕР_ГРУППЫ
       INNER JOIN УЧЕБНЫЙ_ПЛАН PLAN ON GRP.КОД_НАПРАВЛЕНИЯ = PLAN.КОД_НАПРАВЛЕНИЯ
       INNER JOIN ДИСЦИПЛИНА DISC ON PLAN.НОМЕР_ДИСЦИПЛИНЫ = DISC.НОМЕР_ДИСЦИПЛИНЫ
       INNER JOIN УСПЕВАЕМОСТЬ PRGRS
                  ON PLAN.НОМЕР_ДИСЦИПЛИНЫ = PRGRS.НОМЕР_ДИСЦИПЛИНЫ AND STUD.НОМЕР_СТУДЕНТА = PRGRS.НОМЕР_СТУДЕНТА
WHERE PRGRS.ОЦЕНКА != 2
GROUP BY PRGRS.НОМЕР_СТУДЕНТА, PRGRS.НОМЕР_ДИСЦИПЛИНЫ, STUD.ФАМИЛИЯ, DISC.НАЗВАНИЕ
HAVING count(PRGRS.ДАТА) = 1;

/*3. Создать запрос для получения информации о преподавателях,
которые ничего не преподают.
 */

SELECT ФАМИЛИЯ || ' ' || ИМЯ AS FULL_NAME
FROM ПРЕПОДАВАТЕЛЬ
MINUS
SELECT TCH.ФАМИЛИЯ || ' ' || TCH.ИМЯ AS FULL_NAME
FROM ПРЕПОДАВАТЕЛЬ TCH
       INNER JOIN ДИСЦИПЛИНА DISC ON TCH.НОМЕР_ПРЕПОДАВАТЕЛЯ = DISC.НОМЕР_ПРЕПОДАВАТЕЛЯ;

/*4. Создать запрос для получения информации о кафедрах в виде:
 */

SELECT КАФЕДРА || ':'                      AS " ",
       count(DISTINCT НОМЕР_ПРЕПОДАВАТЕЛЯ) AS "КОЛ-ВО СОТРУДНИКОВ",
       avg(ЗАРПЛАТА)                       AS "СРЕДНЯЯ ЗАРПЛАТА",
       max(ЗАРПЛАТА)                       AS "МАКСИМАЛЬНАЯ ЗАРПЛАТА"
FROM ПРЕПОДАВАТЕЛЬ
GROUP BY КАФЕДРА
UNION ALL
SELECT 'В целом:',
       count(DISTINCT НОМЕР_ПРЕПОДАВАТЕЛЯ),
       avg(ЗАРПЛАТА),
       max(ЗАРПЛАТА)
FROM ПРЕПОДАВАТЕЛЬ;

/* Задачи на использование таблиц схемы HR */

/*5. Вывести номер сотрудника, оклад и разряд (см. столбец grade_level в
таблице job_grades) оклада для каждого сотрудника из 30-го отдела.
 */

SELECT EMP.EMPLOYEE_ID, EMP.SALARY, GRDS.GRADE_LEVEL
FROM EMPLOYEES EMP
       INNER JOIN JOBS JB ON EMP.JOB_ID = JB.JOB_ID
       INNER JOIN JOB_GRADES GRDS ON EMP.SALARY BETWEEN GRDS.LOWEST_SAL AND GRDS.HIGHEST_SAL
WHERE EMP.DEPARTMENT_ID = 30;

/*6. Вывести список сотрудников, чей непосредственный руководитель
НЕ является руководителем отдела, в котором сотрудник работает.
 */

SELECT EMP.LAST_NAME || ' ' || EMP.FIRST_NAME
FROM EMPLOYEES EMP
       INNER JOIN DEPARTMENTS DEPT ON EMP.DEPARTMENT_ID = DEPT.DEPARTMENT_ID AND EMP.MANAGER_ID != DEPT.MANAGER_ID;

/*7. Получить список номеров сотрудников, которые в настоящий момент
занимают должность SA_REP, но это не единственная должность, которую
они когда-либо занимали в компании (решить без использования соединений).
 */

SELECT EMPLOYEE_ID
FROM EMPLOYEES
WHERE JOB_ID = 'SA_REP'
INTERSECT
SELECT EMPLOYEE_ID
FROM JOB_HISTORY
WHERE JOB_ID != 'SA_REP';

/*8. Вывести сотрудников 50-го отдела (номер и фамилию) в следующем порядке:
сначала руководитель отдела, затем руководители других сотрудников (из этого же отдела).
Вывести также комментарии о том, руководителем чего является сотрудник: отдела или
другого сотрудника.
 */

SELECT EMP.EMPLOYEE_ID, EMP.LAST_NAME, 'Department Manager' AS COMMENTARY
FROM EMPLOYEES EMP
       INNER JOIN DEPARTMENTS DEPT ON EMP.EMPLOYEE_ID = DEPT.MANAGER_ID
WHERE EMP.DEPARTMENT_ID = 50
UNION
SELECT EMP1.EMPLOYEE_ID, EMP1.LAST_NAME, 'Employee Manager' AS COMMENTARY
FROM EMPLOYEES EMP1
       INNER JOIN EMPLOYEES EMP2 ON EMP1.EMPLOYEE_ID = EMP2.MANAGER_ID
WHERE EMP1.DEPARTMENT_ID = 50
ORDER BY COMMENTARY;

/* Задачи, не подразумевающие использование определённой схемы */

/*9. Создать таблицу word, содержащую два столбца:

с именем id и типом NUMBER(1) - первичный ключ
с именем letter и типом VARCHAR2(1)
В первый столбец записать цифры от 1 до 4, во второй - любое четырёхбуквенное слово (по одной букве в строке).

Вывести все возможные различные анаграммы этого слова.*/

CREATE TABLE WORD
(
  ID     NUMBER(1) PRIMARY KEY,
  LETTER VARCHAR2(1)
);

TRUNCATE TABLE WORD;

DROP TABLE WORD;

INSERT INTO WORD
VALUES (1, 'j');
INSERT INTO WORD
VALUES (2, 'e');
INSERT INTO WORD
VALUES (3, 'r');
INSERT INTO WORD
VALUES (4, 'k');

SELECT *
FROM WORD;

SELECT DISTINCT W1.LETTER || W2.LETTER || W3.LETTER || W4.LETTER AS ANAGRAM
FROM WORD W1
       INNER JOIN WORD W2 ON W2.ID != W1.ID
       INNER JOIN WORD W3 ON W3.ID NOT IN (W2.ID,
                                           W1.ID)
       INNER JOIN WORD W4 ON W4.ID NOT IN (W3.ID,
                                           W2.ID,
                                           W1.ID);