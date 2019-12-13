set linesize 200
col username format a30
col terminal format a15
col PERCENTUAL_FEITO for a10

SELECT b.username,
        b.terminal,
        b.sid,
        b.serial#,
        b.sql_address,
        TO_CHAR(a.START_TIME,'DD/MM/YYYY HH:MI:SS') INICIO,
        round((a.SOFAR/decode(a.TOTALWORK,0,1,a.TOTALWORK))*100,2)||'%' PERCENTUAL_FEITO,
        a.OPNAME
FROM v$session_longops a,
        v$session b
where a.totalwork > 0
        and b.sid = a.sid
        and (a.SOFAR/decode(a.TOTALWORK,0,1,a.TOTALWORK))*100 < 100
order by a.START_TIME desc;
