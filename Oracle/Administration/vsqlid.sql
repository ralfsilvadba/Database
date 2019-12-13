set lines 1000
set pages 1000
col PROGRAM format a30

select inst_id
        sid,
        serial#,
        program,
        machine,
        status,
        username,
        osuser,
        to_char(logon_time,'dd/mm/yyyy hh24:mi:ss'),
        sql_id,
        prev_sql_id
from gv$session
where inst_id = &instid
        and sid = &sid
        and serial# = &serial;
