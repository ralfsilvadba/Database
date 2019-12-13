set lines 1000
column NAME format a10
column DTF format a60
column SIZE_MB format 99999999999
compute sum of SIZE_MB on report
break on report

SELECT TB.NAME,
        DT.NAME "DTF",
        DT.STATUS,
        DT.ENABLED,
        TO_CHAR(DT.CREATION_TIME,'YYYY/MM/DD HH24:MI:SS') "CREATION_TIME",
        SUM(DT.BYTES)/1024/1024 "SIZE_MB"
FROM V$DATAFILE DT
INNER JOIN V$TABLESPACE TB ON DT.TS# = TB.TS#
WHERE TB.NAME='&tbs'
GROUP BY TB.NAME,
        DT.NAME,
        DT.STATUS,
        DT.ENABLED,
        DT.CREATION_TIME
ORDER BY CREATION_TIME,
        SIZE_MB DESC;
