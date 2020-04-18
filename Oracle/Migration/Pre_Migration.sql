--PreMigration
--Disable block changing tracking
DECLARE
vCheck varchar2(10) :='';
BEGIN

select status into vCheck from V$BLOCK_CHANGE_TRACKING;

	IF vCheck = 'ENABLED' THEN

		EXECUTE IMMEDIATE 'ALTER DATABASE DISABLE BLOCK CHANGE TRACKING';

	END IF;

END;
/
--Enable retricted session;
ALTER SYSTEM ENABLE RESTRICTED SESSION;
--Clear recyclebin
purge recyclebin;
--Disable Jobs
alter system set job_queue_processes=0 scope=BOTH sid='*';
--Kill all sessions
DECLARE
vSTMT varchar2(200) := '';
BEGIN 


	FOR C_SESSION IN (SELECT 'alter system kill session '''||SID||','||SERIAL#||',@'||inst_id||''' immediate' CMD FROM gv_$session WHERE username not in ('SYS','grid'))
		LOOP

		vSTMT := C_SESSION.CMD;

			BEGIN

				EXECUTE IMMEDIATE vSTMT;
				vSTMT := '';

			EXCEPTION
				WHEN OTHERS THEN
					NULL;
					CONTINUE;
			END;

		END LOOP C_SESSION;
END;
/
--Alter password user SYSTEM
alter user system identified by ORACLE;

--Backups
SPOOL SNAPSHOT_OBJECTS.LOG
SET ECHO ON
SELECT 'TOTAL OBJECTS AND STATUS' FROM DUAL;
select count(*),status from dba_objects group by status;

SELECT 'OBJECTS INVALIDS' FROM DUAL;
set lines 1000
select owner, object_name, object_type from dba_objects where status = 'INVALID';

SELECT 'OBJECT BY OWNER' FROM DUAL;
set lines 1000
set pages 1000
column owner format a30
select count(*), owner,object_type from dba_objects group by owner,object_type order by 1 desc,2;

SET ECHO OFF;

SPOOL OFF;
/

--Directory tts metadata
CREATE OR REPLACE DIRECTORY TTS_EXPORT AS '/u01/tts';
grant read, write on directory TTS_EXPORT to system;
