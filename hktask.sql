--1.5

WITH DATA AS (SELECT to_date('25.06.2015', 'DD.MM.SYYYY') AS INITIAL_DAT,
                     to_date('26.08.2039', 'DD.MM.SYYYY') AS CURRENT_DAT
              FROM DUAL),
     NORMALIZED_DATA AS (SELECT CASE
                                  WHEN INITIAL_DAT < CURRENT_DAT
                                    THEN INITIAL_DAT
                                  ELSE CURRENT_DAT END AS INITIAL_DAT,
                                CASE
                                  WHEN INITIAL_DAT < CURRENT_DAT
                                    THEN CURRENT_DAT
                                  ELSE INITIAL_DAT END AS CURRENT_DAT
                         FROM DATA),
     INTERMEDIATE AS (SELECT INITIAL_DAT, CURRENT_DAT, floor(months_between(CURRENT_DAT, INITIAL_DAT)) AS FULL_MONTHS
                      FROM NORMALIZED_DATA),
     INTERMEDIATE2 AS (SELECT INITIAL_DAT, CURRENT_DAT, FULL_MONTHS, floor(FULL_MONTHS / 12) AS FULL_YEARS
                       FROM INTERMEDIATE),
     INTERMEDIATE3 AS (SELECT INITIAL_DAT,
                              CURRENT_DAT,
                              FULL_YEARS,
                              FULL_MONTHS - FULL_YEARS * 12        AS REMAINING_MONTHS,
                              add_months(INITIAL_DAT, FULL_MONTHS) AS INITIAL_PLUS_FULL_MONTHS
                       FROM INTERMEDIATE2),
     RESULTS AS (SELECT INITIAL_DAT,
                        CURRENT_DAT,
                        FULL_YEARS,
                        REMAINING_MONTHS,
                        floor(CURRENT_DAT - INITIAL_PLUS_FULL_MONTHS) AS REMAINING_DAYS,
                        MOD(trunc(FULL_YEARS / 10), 10)               AS DECADES_COUNT,
                        MOD(FULL_YEARS, 10)                           AS YEARS_REMAINDER
                 FROM INTERMEDIATE3),
     FORMATTED AS (SELECT CASE
                            WHEN FULL_YEARS = 0
                              THEN ''
                            WHEN YEARS_REMAINDER >= 5 OR DECADES_COUNT = 1
                              THEN FULL_YEARS || ' лет'
                            WHEN YEARS_REMAINDER < 2
                              THEN FULL_YEARS || ' год'
                            WHEN YEARS_REMAINDER < 5
                              THEN FULL_YEARS || ' года' END    AS "Y",
                          CASE
                            WHEN REMAINING_MONTHS = 0
                              THEN ''
                            ELSE REMAINING_MONTHS || ' мес' END AS "M",
                          CASE
                            WHEN REMAINING_DAYS = 0
                              THEN ''
                            ELSE REMAINING_DAYS || ' дн' END    AS "D"
                   FROM RESULTS)
SELECT *
FROM FORMATTED;

SELECT nullif(nullif(nullif(0, 1), 1), 0)
FROM DUAL;

SELECT nullif(0, NULL)
FROM DUAL;