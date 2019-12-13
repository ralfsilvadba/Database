set lines 1000

select session_recid,
        session_stamp,
        --session_key, input_type, status,
        status,
        to_char(start_time,'dd/mm/yyyy hh24:mi') start_time,
        to_char(end_time,'dd/mm/yyyy hh24:mi') end_time,
        floor(input_bytes/1024/1024) size_mb,
        trunc(elapsed_seconds/60) min,
        input_type
from v$rman_backup_job_details
where input_type in ('DB FULL','DB INCR')
order by session_recid asc;
