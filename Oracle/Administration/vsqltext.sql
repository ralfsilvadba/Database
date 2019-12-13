set lines 1000
set pages 1000
set long 1000

select sql_fulltext
from v$sql
where sql_id = '&sqltext';
