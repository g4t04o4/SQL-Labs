/* Задачи на использование таблиц БД Студент */

/*1. Создать как можно более короткий запрос для вывода дисциплин,
в названии которых нет букв М и И (в любом регистре).
*/

/*select НАЗВАНИЕ
from ДИСЦИПЛИНА
where UPPER(НАЗВАНИЕ) not like '%М%'
  and UPPER(НАЗВАНИЕ) not like '%И%';

select НАЗВАНИЕ
from ДИСЦИПЛИНА
where length(НАЗВАНИЕ) - length(replace(replace(upper(НАЗВАНИЕ), 'М', 'И'), 'И', null)) = 0;*/

SELECT НАЗВАНИЕ
FROM ДИСЦИПЛИНА
WHERE translate(upper(НАЗВАНИЕ), 'МИ' || upper(НАЗВАНИЕ), 'МИ') IS NULL;

SELECT НАЗВАНИЕ
FROM ДИСЦИПЛИНА
WHERE NOT REGEXP_LIKE(НАЗВАНИЕ, 'М|И', 'i');

/*2. Создать зaпрос для вывода фамилий преподавателей с чётными номерами.
Отсортировать полученный список в порядке уменьшения окладов. Преподавателей, получающий
одинаковый оклад вывести, отсортировав фамилии по алфавиту.
 */

SELECT ФАМИЛИЯ
FROM ПРЕПОДАВАТЕЛЬ
WHERE mod(НОМЕР_ПРЕПОДАВАТЕЛЯ, 2) = 0
ORDER BY ЗАРПЛАТА DESC
       , ФАМИЛИЯ;

/*3. Вывести количество преподавателей, имеющих подчинённых.
 */

SELECT count(DISTINCT ПОДЧИНЯЕТСЯ) AS КОЛИЧЕСТВО
FROM ПРЕПОДАВАТЕЛЬ;

/*4. Вывести два столбца: 1) среднюю зарплату среди всех преподавателей и
2) название кафедры, где средняя зарплата максимальна (пояснение:
необходимо посчитать среднюю зарплату для каждой кафедры и выбрать максимальную из них).
 */

/*select avg(AVG_SAL) as СРЕД_ЗАРПЛАТА,
       max(AVG_SAL) as НАИБ_ЗАРПЛАТА
from (select avg(ЗАРПЛАТА) as AVG_SAL
      from ПРЕПОДАВАТЕЛЬ
      group by КАФЕДРА);

select avg(ЗАРПЛАТА)
from ПРЕПОДАВАТЕЛЬ;*/

SELECT СРЕД_ЗАРПЛАТА, НАИБ_ЗАРПЛАТА
FROM (SELECT avg(ЗАРПЛАТА) AS СРЕД_ЗАРПЛАТА
      FROM ПРЕПОДАВАТЕЛЬ)
       CROSS JOIN
     (SELECT max(AVG_SAL) AS НАИБ_ЗАРПЛАТА
      FROM (SELECT avg(ЗАРПЛАТА) AS AVG_SAL
            FROM ПРЕПОДАВАТЕЛЬ
            GROUP BY КАФЕДРА));

WITH AVG_SAL AS (SELECT AVG(ЗАРПЛАТА) A_SAL
                 FROM ПРЕПОДАВАТЕЛЬ),
     AVG_KAF AS (SELECT AVG(ЗАРПЛАТА) A_KAF
                 FROM ПРЕПОДАВАТЕЛЬ
                 GROUP BY КАФЕДРА),
     MAX_KAF AS (SELECT MAX(A_KAF) M_KAF
                 FROM AVG_KAF)
SELECT A_SAL AS СРЕД_ЗАРПЛАТА,
       M_KAF AS НАИБ_ЗАРПЛАТА
FROM AVG_SAL,
     MAX_KAF;

SELECT (SELECT avg(ЗАРПЛАТА)
        FROM ПРЕПОДАВАТЕЛЬ)      AS СРЕД_ЗАРПЛАТА,
       (SELECT max(AVG_SAL)
        FROM (SELECT avg(ЗАРПЛАТА) AS AVG_SAL
              FROM ПРЕПОДАВАТЕЛЬ
              GROUP BY КАФЕДРА)) AS НАИБ_ЗАРПЛАТА
FROM DUAL;

SELECT avg(sum(ЗАРПЛАТА)) AS СРЕД_СУММ_ЗАРПЛАТА
FROM ПРЕПОДАВАТЕЛЬ
GROUP BY КАФЕДРА;

SELECT max(avg(ЗАРПЛАТА)) AS НАИБ_СРЕД_ЗАРПЛАТА
FROM ПРЕПОДАВАТЕЛЬ
GROUP BY КАФЕДРА;

/* Задачи на использование таблиц БД HR */

/*5. Вывести номер отдела, фамилию и установленные комиссионные для всех сотрудников.
Если сотрудник не получает комиссионные, вывести фразу "Комиссионные не определены".
 */

SELECT DEPARTMENT_ID,
       LAST_NAME,
       nvl2(COMMISSION_PCT,
            (COMMISSION_PCT * 100) || '%',
            'Комиссионные не определены') AS COMISSION
FROM EMPLOYEES;

/*6. Для каждого сотрудника, подчиняющегося сотруднику с номером 120, вывести
значение годового оклада после повышения зарплаты на 100$ в месяц.
При решении учесть, что сотруднику могут быть назначены комиссионные.
 */

SELECT (SALARY + 100) * 12 * (1 + nvl(COMMISSION_PCT, 0)) AS ANNUAL_SALARY
FROM EMPLOYEES
WHERE MANAGER_ID = 120;

/*7. Сколько строк будет выведено в результате выполнения запроса ниже? Объясните почему.*/

/*select LAST_NAME, DEPARTMENT_ID

from EMPLOYEES

where DEPARTMENT_ID not in (10, 20, null);*/

/*Из-за сравнения с null под условие не подходит ни одна строка. В итоге имеем ноль значений.*/

/*select DEPARTMENT_ID
from EMPLOYEES
where DEPARTMENT_ID != 10
  and DEPARTMENT_ID != 20
  and DEPARTMENT_ID != null;

select DEPARTMENT_ID
from EMPLOYEES
where DEPARTMENT_ID != 10
  and DEPARTMENT_ID != 20
  and DEPARTMENT_ID is not null;*/

/*8. Найти отделы, в которых более 3 сотрудников занимают одинаковую должность.
Вывести номер отдела, количество сотрудников, идентификатор должности сотрудников.
Упорядочить результат по номеру отдела.
 */

SELECT DEPARTMENT_ID, count(EMPLOYEE_ID) AS EMPLOYEE_CNT, JOB_ID
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
HAVING count(EMPLOYEE_ID) > 3
ORDER BY DEPARTMENT_ID;

/*select *
from EMPLOYEES EMP1
       inner join EMPLOYEES EMP2
                  on
                      EMP1.EMPLOYEE_ID != EMP2.EMPLOYEE_ID and
                      EMP1.JOB_ID = EMP2.JOB_ID and
                      EMP1.DEPARTMENT_ID = EMP2.DEPARTMENT_ID
       inner join EMPLOYEES EMP3 on
    EMP2.EMPLOYEE_ID != EMP3.EMPLOYEE_ID and
    EMP2.JOB_ID = EMP3.JOB_ID and
    EMP2.DEPARTMENT_ID = EMP3.DEPARTMENT_ID and
    EMP1.EMPLOYEE_ID != EMP3.EMPLOYEE_ID and
    EMP1.JOB_ID = EMP3.JOB_ID and
    EMP1.DEPARTMENT_ID = EMP3.DEPARTMENT_ID;*/

/* Задачи, не подразумевающие использование определённой БД */

/*9. Определить дату второго понедельника марта в этом году.
*/

SELECT next_day(to_date('01.03.' || to_char(sysdate, 'yyyy'),
                        'dd.mm.yyyy') - 1, 1) + 7 AS SECOND_MONDAY
FROM DUAL;

/*14.03.2019*/

SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEES E
       JOIN DEPARTMENTS D ON E.EMPLOYEE_ID = D.MANAGER_ID
INTERSECT
SELECT E1.FIRST_NAME, E1.LAST_NAME
FROM EMPLOYEES E1
       JOIN EMPLOYEES E2 ON E1.MANAGER_ID = E2.EMPLOYEE_ID

