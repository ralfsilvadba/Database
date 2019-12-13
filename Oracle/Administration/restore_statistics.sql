select count(*), stats_update_time
  from dba_tab_stats_history  
 where owner='&OWNER'
   and table_name='&TABLE_NAME'
 group by stats_update_time;
 
 exec dbms_stats.restore_table_stats(ownname=>'<OWNER>',tabname=>'<TABLE_NAME>',AS_OF_TIMESTAMP=>'<STATS_UPDATE_TIME>');
