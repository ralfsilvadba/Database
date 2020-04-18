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

--Directory tts metadata
CREATE OR REPLACE DIRECTORY TTS_EXPORT AS '/u01/tts';
grant read, write on directory TTS_EXPORT to system;
