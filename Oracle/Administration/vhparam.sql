set lines 1000
set pages 1000
column "Instance Value" format a20
select 
   a.ksppinm "Parameter|Name", 
   c.ksppstvl "Instance Value"
from 
   x$ksppi a, 
   x$ksppcv b, 
   x$ksppsv c
where 
   a.indx = b.indx 
and 
   a.indx = c.indx
and 
   ksppinm like '%&1%'
order by 
   a.ksppinm;
