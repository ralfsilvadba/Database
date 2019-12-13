clear columns
column TOTAL_MB format 999,999,999,999.99
column FREE_MB format 999,999,999,999.99
column "USADO" format 999,999,999,999.99
column "% FREE" format 999.99
compute sum of TOTAL_MB on report
compute sum of FREE_MB on report
compute sum of "USADO" on report
break on report
set lines 200 pages 100

select NAME,
        TOTAL_MB,
        FREE_MB,
        TOTAL_MB-FREE_MB USADO,
        round((FREE_MB/TOTAL_MB)*100) "% FREE"
from v$ASM_DISKGROUP
order by 5 ;

ttitle off
clear columns
