--@?/rdbms/admin/addmrpt.sql

DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
         --begin_snap  => 2894,              -- Init snap this line not mandatory
        -- end_snap    => 2895,              -- Final snap this line not mandatory
         sql_id      => '06vyzrk0zbsuq',    -- SQL Id
         scope       => DBMS_SQLTUNE.scope_comprehensive,
         time_limit  => 3600,               -- Execução em seg
         task_name   => '06vyzrk0zbsuq4_AWR2_tuning_task', 
         description => 'Task: 06vyzrk0zbsuq');
   DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/

EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => '7q401rcvafv64_AWR2_tuning_task');


--Show recomendations
 SET LONG 10000;
 SET PAGESIZE 1000
 SET LINESIZE 200
   SELECT 
      DBMS_SQLTUNE.report_tuning_task(
      '7q401rcvafv64_AWR2_tuning_task'
      ) AS recommendations 
   FROM 
      dual;
