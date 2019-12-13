execute sys.dbms_system.set_sql_trace_in_session(&SID, &SERIAL, TRUE);

SELECT S.USERNAME,
       S.AUDSID,
       S.SID,
       S.SERIAL#,
       PA.VALUE || chr(92) || LOWER(SYS_CONTEXT('USERENV', 'INSTANCE_NAME')) ||
       '_ora_' || P.SPID || '.trc' AS TRACE_FILE
  FROM V$SESSION S, V$PROCESS P, V$PARAMETER PA
 WHERE S.PADDR = P.ADDR
   AND UPPER(PA.NAME) = 'USER_DUMP_DEST'
   AND S.SID = &SID
   AND S.SERIAL# = &SERIAL;
