set lines 1000
set pages 1000
column program format a50;
column machine format a30;
column username format a35;
column osuser format a15;

select inst_id,
        sid,
        serial#,
        program,
        machine,
        status,
        username,
        osuser,
        to_char(logon_time,'dd/mm/yyyy hh24:mi:ss')
from gv$session
where username is not null
order by sid;
