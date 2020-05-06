--Preparação do sistema operacional
[oracle] cd /u01
[oracle] mkdir tts
Cadastrar TNS no destino
--Origem
SET SERVEROUTPUT ON
set lines 1000
DECLARE
tsname varchar(30);
i number := 0;
checklist varchar2(4000);
vCheck varchar2(2000);
BEGIN
	DBMS_OUTPUT.PUT_LINE('+------TABLESPACES AND BLOCKSIZE------+');
	FOR C_TABLESPACE IN (select tablespace_name, block_size from dba_tablespaces where tablespace_name not in ('SYSTEM','SYSAUX','USERS') and contents = 'PERMANENT')
		LOOP
			DBMS_OUTPUT.PUT_LINE('TABLESPACE NAME: '||C_TABLESPACE.TABLESPACE_NAME || ' BLOCK SIZE: '||C_TABLESPACE.BLOCK_SIZE);
		END LOOP C_TABLESPACE;
	DBMS_OUTPUT.PUT_LINE('+-----------------------------------+');
	DBMS_OUTPUT.PUT_LINE('+------DATAFILES------+');
	FOR C_TBS_DATAFILE IN (select file_name from dba_tablespaces a, dba_data_files b where a.tablespace_name = b.tablespace_name and a.tablespace_name not in ('SYSTEM','SYSAUX','USERS') and contents = 'PERMANENT' order by a.tablespace_name)
		LOOP

		DBMS_OUTPUT.PUT_LINE('INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'''|| C_TBS_DATAFILE.FILE_NAME||''','||''''|| C_TBS_DATAFILE.FILE_NAME||''',0,0);');
		

		END LOOP C_TBS_DATAFILE;
	DBMS_OUTPUT.PUT_LINE('+-----------------------------------+');

	--Create Directory
	EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY DATA_PUMP_DIR as ''/u01/tts''';

	--Generate TTS export file
	DBMS_OUTPUT.PUT_LINE('+------TTS EXPORT PARFILE------+');
	dbms_output.put_line('directory=DATA_PUMP_DIR');
	dbms_output.put_line('dumpfile=dp_tts.dmp');
	dbms_output.put_line('logfile=dp_ttsexp.log');
	dbms_output.put_line('transport_full_check=no');
	dbms_output.put('transport_tablespaces=');
	for ts in
	(select tablespace_name from dba_tablespaces
	where tablespace_name not in ('SYSTEM','SYSAUX','USERS')
	and contents = 'PERMANENT'
	order by tablespace_name)
	loop
	if (i!=0) then
	dbms_output.put_line(tsname||',');
	end if;
	i := 1;
	tsname := ts.tablespace_name;
	end loop;
	dbms_output.put_line(tsname);
	dbms_output.put_line('');
	DBMS_OUTPUT.PUT_LINE('+------TTS EXPORT PARFILE------+');

	--Find objects in SYSTEM/SYSAUX
	DBMS_OUTPUT.PUT_LINE('+------OBJECTS IN SYSTEM/SYSAUX TABLESPACE------+');
	FOR C_OBJECT_TBS IN (select owner, segment_name, segment_type from dba_segments where tablespace_name in ('SYSTEM', 'SYSAUX') and owner not in (select name from system.logstdby$skip_support where action=0))
		LOOP

			DBMS_OUTPUT.PUT_LINE('OWNER: '||C_OBJECT_TBS.OWNER || 'SEGMENT_NAME: '|| C_OBJECT_TBS.SEGMENT_NAME || 'SEGMENT_TYPE: '||C_OBJECT_TBS.SEGMENT_TYPE );

		END LOOP;
	DBMS_OUTPUT.PUT_LINE('+-----------------------------------+');
	--Create users???

	--Check tablespaces
	i := 0;
	for ts in
	(select tablespace_name
	from dba_tablespaces
	where tablespace_name not in ('SYSTEM','SYSAUX','USERS') and contents = 'PERMANENT')
	loop
	if (i=0) then
	checklist := ts.tablespace_name;
	else
	checklist := checklist||','||ts.tablespace_name;
	end if;
	i := 1;
	end loop;
	dbms_tts.transport_set_check(checklist,TRUE,TRUE);
	
	--Validate tablesapces if not_data_found then tablespace to ro
	DBMS_OUTPUT.PUT_LINE('+-----------VIOLATIONS-----------+');
	BEGIN
				select VIOLATIONS INTO vCheck from transport_set_violations;
				DBMS_OUTPUT.PUT_LINE(vCheck);
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                    	--When no_data_found set tablespace to RO
                    	FOR C_TABLESPACE IN (select 'ALTER TABLESPACE ' || tablespace_name || ' READ ONLY' vStmt from dba_tablespaces where tablespace_name not in ('SYSTEM','SYSAUX','USERS') and contents = 'PERMANENT' and STATUS <> 'READ ONLY')
                    		LOOP


                    			EXECUTE IMMEDIATE C_TABLESPACE.vStmt;
                    			DBMS_OUTPUT.PUT_LINE(C_TABLESPACE.vStmt || '-> OK - NO VIOLATIONS FOUND');


                    		END LOOP C_TABLESPACE;

    END;
    DBMS_OUTPUT.PUT_LINE('+-----------------------------------+');

	DBMS_OUTPUT.PUT_LINE('+-----------ROLES-----------+'); 

	FOR C_ROLES IN (select 'CREATE ROLE '||name||';' Stmt from sys.user$ su inner join dba_roles dr on su.name = dr.role where to_char(ctime, 'DD-MON-YYYY') <> '24-AUG-2013')
		LOOP

			DBMS_OUTPUT.PUT_LINE(C_ROLES.Stmt);

		END LOOP C_ROLES;   

	DBMS_OUTPUT.PUT_LINE('+-----------------------------------+');

    DBMS_OUTPUT.PUT_LINE('**** EXECUTAR O SCRIPT PARA GERAR O DLL DOS USUARIOS ****');
    DBMS_OUTPUT.PUT_LINE('**** CRIAR O DIRETORIO COM O FULL PATH DOS DATAFILES PARA UTILZIAR A PROC P_MIGRATION_DATAFILE****');
END;
/

select 'CREATE USER '||username||' IDENTIFIED BY test DEFAULT TABLESPACE SYSTEM;' from dba_users where username in ('SISPAC','NIFI_P2K','KILLINF','GNRE');
select 'ALTER USER ' ||username||' DEFAULT TABLESPACE '||default_tablespace||';' from dba_users where username in ('SISPAC','NIFI_P2K','KILLINF','GNRE');
set pages 1000
set lines 1000
select 'ALTER USER ' ||username||' QUOTA UNLIMITED ON '||tablespace_name||';' from dba_users du,dba_tablespaces dt where du.username in ('SISPAC','NIFI_P2K','KILLINF','GNRE') and tablespace_name not in ('SYSTEM','SYSAUX','USERS') and contents = 'PERMANENT';

select 'ALTER USER ' ||username||' QUOTA UNLIMITED ON '||tablespace_name||';' from DBA_TS_QUOTAS where username in ('SISPAC','NIFI_P2K','KILLINF','GNRE') and tablespace_name not in ('SYSTEM','SYSAUX','USERS') and MAX_BYTES=-1;


--Import Metada users after TTS
directory=DATA_PUMP_DIR
logfile=test.log
schemas=CTE,NFE,NFE_APP,WAVE_NFE
FULL=Y
CONTENT=METADATA_ONLY
network_link=ONFEDEV
parallel=8
CLUSTER=N
