set lines 1000

column NAME format a10
column DTF format a60
column SIZE_MB format 99999999999
compute sum of SIZE_MB on report
break on report

SELECT TB.NAME,
        TF.NAME "DTF",
        TF.STATUS,
        TF.ENABLED,
        TO_CHAR(TF.CREATION_TIME,'YYYY/MM/DD HH24:MI:SS') "CREATION_TIME",
        SUM(TF.BYTES)/1024/1024 "SIZE_MB"
FROM V$TEMPFILE TF
INNER JOIN V$TABLESPACE TB ON TB.TS# = TB.TS#
WHERE TB.NAME='&tbs'
GROUP BY TB.NAME,
        TF.NAME,
        TF.STATUS,
        TF.ENABLED,
        TF.CREATION_TIME
ORDER BY CREATION_TIME,
        SIZE_MB DESC;
