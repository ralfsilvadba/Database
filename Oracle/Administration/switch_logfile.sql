COLUMN H00 FORMAT 99
COLUMN H01 FORMAT 99
COLUMN H02 FORMAT 99
COLUMN H03 FORMAT 99
COLUMN H04 FORMAT 99
COLUMN H05 FORMAT 99
COLUMN H06 FORMAT 99
COLUMN H07 FORMAT 99
COLUMN H08 FORMAT 99
COLUMN H09 FORMAT 99
COLUMN H10 FORMAT 99
COLUMN H11 FORMAT 99
COLUMN H12 FORMAT 99
COLUMN H13 FORMAT 99
COLUMN H14 FORMAT 99
COLUMN H15 FORMAT 99
COLUMN H16 FORMAT 99
COLUMN H17 FORMAT 99
COLUMN H18 FORMAT 99
COLUMN H19 FORMAT 99
COLUMN H20 FORMAT 99
COLUMN H21 FORMAT 99
COLUMN H22 FORMAT 99
COLUMN H23 FORMAT 99



WITH
log AS (
SELECT /*+  MATERIALIZE NO_MERGE  */ /* 2d.170 */
       thread#,
       TO_CHAR(TRUNC(first_time), 'YYYY-MM-DD') yyyy_mm_dd,
       TO_CHAR(TRUNC(first_time), 'Dy') day,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '00', 1, 0)) h00,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '01', 1, 0)) h01,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '02', 1, 0)) h02,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '03', 1, 0)) h03,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '04', 1, 0)) h04,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '05', 1, 0)) h05,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '06', 1, 0)) h06,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '07', 1, 0)) h07,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '08', 1, 0)) h08,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '09', 1, 0)) h09,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '10', 1, 0)) h10,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '11', 1, 0)) h11,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '12', 1, 0)) h12,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '13', 1, 0)) h13,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '14', 1, 0)) h14,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '15', 1, 0)) h15,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '16', 1, 0)) h16,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '17', 1, 0)) h17,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '18', 1, 0)) h18,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '19', 1, 0)) h19,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '20', 1, 0)) h20,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '21', 1, 0)) h21,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '22', 1, 0)) h22,
       SUM(DECODE(TO_CHAR(first_time, 'HH24'), '23', 1, 0)) h23,
       COUNT(*) per_day
  FROM v$log_history
 GROUP BY
       thread#,
       TRUNC(first_time)
 ORDER BY
       thread#,
       TRUNC(first_time) DESC NULLS LAST
),
ordered_log AS (
SELECT /*+  MATERIALIZE NO_MERGE  */ /* 2d.170 */
       ROWNUM row_num_noprint, log.*
  FROM log
),
min_set AS (
SELECT /*+  MATERIALIZE NO_MERGE  */ /* 2d.170 */
       thread#,
       MIN(row_num_noprint) min_row_num
  FROM ordered_log
 GROUP BY
       thread#
)
SELECT /*+  NO_MERGE  */ /* 2d.170 */
       log.*
  FROM ordered_log log,
       min_set ms
 WHERE log.thread# = ms.thread#
   AND log.row_num_noprint < ms.min_row_num + 14
 ORDER BY
       log.thread#,
       log.yyyy_mm_dd DESC;
