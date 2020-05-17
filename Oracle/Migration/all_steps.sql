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
	--CHANGE SYSTEM PASSWORD
	EXECUTE IMMEDIATE 'ALTER USER SYSTEM IDENTIFIED BY ORACLE';

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

'CTE','WAVE_NFE','SAP_CTE','SRV_4INSIGHTS','USER_DEV_STIT'

CTE	
SAP_CTE 
ZABBIX	
SRV_4INSIGHTS
WAVE_NFE	
USER_DEV_STIT

SELECT USERNAME,CREATED FROM DBA_USERS WHERE TO_CHAR(CREATED,'DD/MM/YY') <> '24/08/13';
select 'CREATE USER '||username||' IDENTIFIED BY test DEFAULT TABLESPACE SYSTEM;' from dba_users where username in ('CTE','WAVE_NFE','SAP_CTE','SRV_4INSIGHTS','USER_DEV_STIT');
select 'ALTER USER ' ||username||' DEFAULT TABLESPACE '||default_tablespace||';' from dba_users where username in ('CTE','WAVE_NFE','SAP_CTE','SRV_4INSIGHTS','USER_DEV_STIT');
set pages 1000
set lines 1000
select 'ALTER USER ' ||username||' QUOTA UNLIMITED ON '||tablespace_name||';' from dba_users du,dba_tablespaces dt where du.username in ('CTE','WAVE_NFE','SAP_CTE','SRV_4INSIGHTS','USER_DEV_STIT') and tablespace_name not in ('SYSTEM','SYSAUX','USERS') and contents = 'PERMANENT';

select 'ALTER USER ' ||username||' QUOTA UNLIMITED ON '||tablespace_name||';' from DBA_TS_QUOTAS where username in ('CTE','WAVE_NFE','SAP_CTE','SRV_4INSIGHTS','USER_DEV_STIT') and tablespace_name not in ('SYSTEM','SYSAUX','USERS') and MAX_BYTES=-1;


CREATE USER CTE IDENTIFIED BY test DEFAULT TABLESPACE SYSTEM;
CREATE USER SAP_CTE IDENTIFIED BY test DEFAULT TABLESPACE SYSTEM;
CREATE USER SRV_4INSIGHTS IDENTIFIED BY test DEFAULT TABLESPACE SYSTEM;
CREATE USER USER_DEV_STIT IDENTIFIED BY test DEFAULT TABLESPACE SYSTEM;
CREATE USER WAVE_NFE IDENTIFIED BY test DEFAULT TABLESPACE SYSTEM;


ALTER USER CTE DEFAULT TABLESPACE TS_CTE;
ALTER USER SAP_CTE DEFAULT TABLESPACE TS_CTE;
ALTER USER SRV_4INSIGHTS DEFAULT TABLESPACE TBS_WAVE_DATA;
ALTER USER USER_DEV_STIT DEFAULT TABLESPACE TBS_WAVE_DATA;
ALTER USER WAVE_NFE DEFAULT TABLESPACE TS_DAT_01;


ALTER USER CTE QUOTA UNLIMITED ON TS_CTE;
ALTER USER WAVE_NFE QUOTA UNLIMITED ON TBS_WAVE_DATA;
ALTER USER WAVE_NFE QUOTA UNLIMITED ON TS_HISTORICO;
ALTER USER WAVE_NFE QUOTA UNLIMITED ON TS_IDX_01;
ALTER USER WAVE_NFE QUOTA UNLIMITED ON TBS_WAVE_IDX;
ALTER USER WAVE_NFE QUOTA UNLIMITED ON TS_CTE;
ALTER USER WAVE_NFE QUOTA UNLIMITED ON TS_DAT_01;

/*

create or replace directory S_DIRECTORY as '+DG_DATA/wave/datafile/';
+------TABLESPACES AND BLOCKSIZE------+
TABLESPACE NAME: TBS_WAVE_DATA BLOCK SIZE: 8192
TABLESPACE NAME: TBS_WAVE_IDX BLOCK SIZE: 8192
TABLESPACE NAME: TS_CTE BLOCK SIZE: 8192
TABLESPACE NAME: TS_DAT_01 BLOCK SIZE: 8192
TABLESPACE NAME: TS_HISTORICO BLOCK SIZE: 8192
TABLESPACE NAME: TS_IDX_01 BLOCK SIZE: 8192
TABLESPACE NAME: TS_DBAMON BLOCK SIZE: 8192
+-----------------------------------+
+------DATAFILES------+
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.279.1035317499','tbs_wave_data.279',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.325.1035308943','tbs_wave_data.325',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.328.1035308945','tbs_wave_data.328',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.327.1035308945','tbs_wave_data.327',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.282.1035316917','tbs_wave_data.282',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.281.1035316929','tbs_wave_data.281',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.287.1035315857','tbs_wave_data.287',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.288.1035315857','tbs_wave_data.288',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.320.1035309759','tbs_wave_data.320',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.321.1035309731','tbs_wave_data.321',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.322.1035309707','tbs_wave_data.322',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.326.1035308945','tbs_wave_data.326',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.324.1035308943','tbs_wave_data.324',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_data.329.1035308945','tbs_wave_data.329',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'tbs_wave_idx.264.1035318495','tbs_wave_idx.264',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_cte.267.1035318449','ts_cte.267',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_cte.268.1035318445','ts_cte.268',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_cte.269.1035318443','ts_cte.269',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.298.1035312911','ts_dat_01.298',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.319.1035309759','ts_dat_01.319',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.318.1035309777','ts_dat_01.318',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.317.1035309791','ts_dat_01.317',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.316.1035310527','ts_dat_01.316',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.315.1035310547','ts_dat_01.315',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.314.1035310549','ts_dat_01.314',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.313.1035310553','ts_dat_01.313',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.312.1035310571','ts_dat_01.312',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.311.1035310583','ts_dat_01.311',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.310.1035311317','ts_dat_01.310',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.272.1035318105','ts_dat_01.272',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.284.1035316787','ts_dat_01.284',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.286.1035316507','ts_dat_01.286',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.285.1035316701','ts_dat_01.285',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.283.1035316863','ts_dat_01.283',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.291.1035315853','ts_dat_01.291',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.289.1035315855','ts_dat_01.289',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.290.1035315853','ts_dat_01.290',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.292.1035315853','ts_dat_01.292',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.296.1035312935','ts_dat_01.296',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.297.1035312913','ts_dat_01.297',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.299.1035312215','ts_dat_01.299',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.300.1035312169','ts_dat_01.300',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.301.1035312155','ts_dat_01.301',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.302.1035312143','ts_dat_01.302',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.304.1035312141','ts_dat_01.304',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.303.1035312141','ts_dat_01.303',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.305.1035311383','ts_dat_01.305',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.306.1035311369','ts_dat_01.306',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.308.1035311323','ts_dat_01.308',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.307.1035311325','ts_dat_01.307',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_dat_01.309.1035311319','ts_dat_01.309',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_historico.273.1035317779','ts_historico.273',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_historico.295.1035312971','ts_historico.295',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_historico.294.1035312973','ts_historico.294',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_historico.276.1035317707','ts_historico.276',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_historico.278.1035317555','ts_historico.278',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_historico.277.1035317651','ts_historico.277',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_historico.274.1035317771','ts_historico.274',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_historico.293.1035312975','ts_historico.293',0,0);
INSERT INTO CONTROL_MIGRATION_FILE VALUES (1,'ts_idx_01.266.1035318487','ts_idx_01.266',0,0);
+-----------------------------------+
+------TTS EXPORT PARFILE------+
directory=DATA_PUMP_DIR
dumpfile=dp_tts.dmp
logfile=dp_ttsexp.log
transport_full_check=no
transport_tablespaces=TBS_WAVE_DATA,
TBS_WAVE_IDX,
TS_CTE,
TS_DAT_01,
TS_HISTORICO,
TS_IDX_01
+------TTS EXPORT PARFILE------+
+------OBJECTS IN SYSTEM/SYSAUX TABLESPACE------+
+-----------------------------------+
+-----------VIOLATIONS-----------+
ALTER TABLESPACE TBS_WAVE_DATA READ ONLY-> OK - NO VIOLATIONS FOUND
ALTER TABLESPACE TBS_WAVE_IDX READ ONLY-> OK - NO VIOLATIONS FOUND
ALTER TABLESPACE TS_CTE READ ONLY-> OK - NO VIOLATIONS FOUND
ALTER TABLESPACE TS_DAT_01 READ ONLY-> OK - NO VIOLATIONS FOUND
ALTER TABLESPACE TS_HISTORICO READ ONLY-> OK - NO VIOLATIONS FOUND
ALTER TABLESPACE TS_IDX_01 READ ONLY-> OK - NO VIOLATIONS FOUND
ALTER TABLESPACE TS_DBAMON READ ONLY-> OK - NO VIOLATIONS FOUND
+-----------------------------------+
+-----------ROLES-----------+
CREATE ROLE R_SAP;
CREATE ROLE WAVE_ROLE;
+-----------------------------------+
**** EXECUTAR O SCRIPT PARA GERAR O DLL DOS USUARIOS ****
**** CRIAR O DIRETORIO COM O FULL PATH DOS DATAFILES PARA UTILZIAR A PROC P_MIGRATION_DATAFILE****

PL/SQL procedure successfully completed.
*/



create directory S_DIRECTORY as '+NFEQAS_DATA/NFEQAS/DATAFILE';
create directory S_DIRECTORY_1 as '+NFEQAS_DATA/NFEQAS2/DATAFILE';



--Import Metada users after TTS
directory=DATA_PUMP_DIR
logfile=test.log
schemas=CTE,NFE,NFE_APP,WAVE_NFE
FULL=Y
CONTENT=METADATA_ONLY
network_link=ONFEDEV
parallel=8
CLUSTER=N








--Generate IMPDP FILE (Destination)
spool off
REM
REM Data Pump parameter file for TTS import
REM
spool dp_ttsimp.par
declare
fname varchar(513);
i number := 0;
begin
dbms_output.put_line('directory=DATA_PUMP_DIR');
dbms_output.put_line('dumpfile=dp_tts.dmp');
dbms_output.put_line('logfile=dp_ttsimp.log');
dbms_output.put('transport_datafiles=');
for df in
(SELECT DIRECTORY_PATH ||'/'|| D_FILE_NAME FILE_NAME FROM DBA_DIRECTORIES DD INNER JOIN CONTROL_MIGRATION CM ON DD.DIRECTORY_NAME = CM.D_DIRECTORY INNER JOIN CONTROL_MIGRATION_FILE CMF ON CM.ID_MIGRATION = CMF.ID_MIGRATION)
loop
if (i!=0) then
dbms_output.put_line(''''||fname||''',');
end if;
i := 1;
fname := df.file_name;
end loop;
dbms_output.put_line(''''||fname||'''');
dbms_output.put_line('');
end;
/





***P2******
--PROC
172.16.108.114
172.16.154.136

--Cadastrar TNS
vi $ORACLE_HOME/network/admin/tnsnames.ora

ONFELJ =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 172.16.154.117)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = qasnfelj)
    )
  )

-- destination database
create directory D_DIRECTORY as '+DG_DATA/QASNFELJ/DATAFILE';
-- source database
create or replace directory S_DIRECTORY as '+DATA/SCALAGNRE/DATAFILE';
 
create public database link ONFE connect to system identified by ORACLE using 'ONFELJ';
 

--
tratar
*
ERROR at line 1:
ORA-02019: connection description for remote database not found
ORA-06512: at "SYS.DBMS_FILE_TRANSFER", line 54
ORA-06512: at "SYS.DBMS_FILE_TRANSFER", line 151
ORA-06512: at line 31
ORA-06512: at line 31
--
/*
Colocar flag de lock e status na control_migration para paralelizar o processo
se o diretorio tiver datafilefiles disponveis faz o lock da config com select for update. se tiver 0 ignora e marcar o diretorio como migrado, procura o proximo
No cotrole do migration colocar uma flag de use goto? Se sim retorna se não sai
*/

INSERT INTO CONTROL_MIGRATION VALUES(0,'S_DIRECTORY','D_DIRECTORY','ONFE',4,1);
INSERT INTO CONTROL_MIGRATION VALUES(1,'S_DIRECTORY','D_DIRECTORY','',2,0);
CREATE TABLE CONTROL_MIGRATION (ID_MIGRATION NUMBER(2), S_DIRECTORY VARCHAR2(50), D_DIRECTORY VARCHAR2(50), S_DATABASE_LINK VARCHAR2(30), NR_LOCK_FILES NUMBER(1), FL_RETURN NUMBER(1));
CREATE TABLE CONTROL_MIGRATION_FILE (ID_MIGRATION NUMBER(2), S_FILE_NAME VARCHAR2(100), D_FILE_NAME VARCHAR2(100), FL_STAT NUMBER(1), FL_LOCK NUMBER(4));
CREATE TABLE CONTROL_MIGRATION_LOG (ID_MIGRATION NUMBER(2), DT_START DATE, DT_END DATE, D_FILE_NAME VARCHAR2(100));



DECLARE
vID_MIGRATION NUMBER(2) :='';
vS_DIRECTORY VARCHAR2(50) :='';
vD_DIRECOTRY VARCHAR2(50) :='';
vS_DATABASE_LINK VARCHAR2(30) :='';
vFL_LOCK NUMBER(4) :='';
vNR_LOCK_FILES NUMBER(1) :='';
vID_MIGRATION_D NUMBER(2) := '0';
vFL_RETURN NUMBER(1) :=0;
vCHECK NUMBER(3) := 0;
R_NO_DATA EXCEPTION;
BEGIN

	--Generate lock value
	SELECT TRUNC(DBMS_RANDOM.value(1,10000)) INTO vFL_LOCK FROM DUAL;
	--GET CONFIG
	SELECT ID_MIGRATION, S_DIRECTORY,D_DIRECTORY, S_DATABASE_LINK,NR_LOCK_FILES,FL_RETURN  INTO vID_MIGRATION,vS_DIRECTORY,vD_DIRECOTRY,vS_DATABASE_LINK,vNR_LOCK_FILES,vFL_RETURN FROM CONTROL_MIGRATION where ID_MIGRATION = vID_MIGRATION_D;

	<<search_new_datafile>>
	FOR C_M_LOCK_DATA IN (SELECT S_FILE_NAME S_FILE_NAME, D_FILE_NAME D_FILE_NAME FROM CONTROL_MIGRATION_FILE WHERE ID_MIGRATION = vID_MIGRATION AND FL_STAT=0 AND FL_LOCK = 0 AND ROWNUM < vNR_LOCK_FILES)
		LOOP

			UPDATE CONTROL_MIGRATION_FILE SET FL_LOCK=vFL_LOCK WHERE ID_MIGRATION=vID_MIGRATION AND D_FILE_NAME=C_M_LOCK_DATA.D_FILE_NAME AND FL_STAT=0;
			COMMIT;	
			
		END LOOP;

	FOR C_M_FILE IN (SELECT S_FILE_NAME S_FILE_NAME, D_FILE_NAME D_FILE_NAME FROM CONTROL_MIGRATION_FILE WHERE ID_MIGRATION = vID_MIGRATION AND FL_STAT=0 AND FL_LOCK=vFL_LOCK)
		LOOP

			UPDATE CONTROL_MIGRATION_FILE SET FL_STAT=9 WHERE ID_MIGRATION=vID_MIGRATION AND D_FILE_NAME=C_M_FILE.D_FILE_NAME;
			COMMIT;
			INSERT INTO CONTROL_MIGRATION_LOG VALUES(vID_MIGRATION,SYSDATE,NULL,C_M_FILE.D_FILE_NAME);
			COMMIT;

			DBMS_FILE_TRANSFER.get_file(
   			source_directory_object      => vS_DIRECTORY,
   			source_file_name             => C_M_FILE.S_FILE_NAME,
   			source_database              => vS_DATABASE_LINK,
   			destination_directory_object => vD_DIRECOTRY,
   			destination_file_name        => C_M_FILE.D_FILE_NAME);

			UPDATE CONTROL_MIGRATION_LOG SET DT_END=SYSDATE WHERE ID_MIGRATION = vID_MIGRATION AND D_FILE_NAME=C_M_FILE.D_FILE_NAME;
			COMMIT;
			UPDATE CONTROL_MIGRATION_FILE SET FL_STAT=1,FL_LOCK=0 WHERE ID_MIGRATION=vID_MIGRATION AND D_FILE_NAME=C_M_FILE.D_FILE_NAME AND  FL_LOCK=vFL_LOCK;
			COMMIT;

		END LOOP;

		IF vFL_RETURN = 1 THEN
			SELECT TO_NUMBER(COUNT(*)) INTO vCHECK FROM CONTROL_MIGRATION_FILE WHERE ID_MIGRATION = vID_MIGRATION AND FL_STAT=0 AND FL_LOCK=0;
				IF vCHECK = 0 THEN
					RAISE R_NO_DATA;
				ELSE
					GOTO search_new_datafile;
				END IF;
		END IF;
		
EXCEPTION
    WHEN R_NO_DATA THEN
        NULL;

END;
/


SELECT TO_NUMBER(COUNT(*)) FROM CONTROL_MIGRATION_FILE WHERE ID_MIGRATION = 0 AND FL_STAT=0 AND FL_LOCK=0;

CREATE OR REPLACE DIRECTORY DATA_PUMP_DIR as '/u01/tts';

--generate impdp tts
set serveroutput on
declare
fname varchar(513);
i number := 0;
begin
dbms_output.put_line('directory=DATA_PUMP_DIR');
dbms_output.put_line('dumpfile=dp_tts.dmp');
dbms_output.put_line('logfile=dp_ttsimp.log');
dbms_output.put('transport_datafiles=');
for df in
(SELECT DIRECTORY_PATH ||'/'|| D_FILE_NAME FILE_NAME FROM DBA_DIRECTORIES DD INNER JOIN CONTROL_MIGRATION CM ON DD.DIRECTORY_NAME = CM.D_DIRECTORY INNER JOIN CONTROL_MIGRATION_FILE CMF ON CM.ID_MIGRATION = CMF.ID_MIGRATION)
loop
if (i!=0) then
dbms_output.put_line(''''||fname||''',');
end if;
i := 1;
fname := df.file_name;
end loop;
dbms_output.put_line(''''||fname||'''');
dbms_output.put_line('');
end;
/

--
--Import user metadata
directory=DATA_PUMP_DIR
logfile=test.log
schemas=CTE,WAVE_NFE,NFE_APP,NFE
CONTENT=METADATA_ONLY
network_link=ONFE
parallel=8
CLUSTER=N

--set tbs to rd
set heading off
feedback off
trimspool on
linesize 500
spool tts_tsrw.sql
prompt /* ==================================== */
prompt /* Make all user tablespaces READ WRITE */
prompt /* ==================================== */
select 'ALTER TABLESPACE ' || tablespace_name || ' READ WRITE;' from dba_tablespaces
where tablespace_name not in ('SYSTEM','SYSAUX','USERS')
and contents = 'PERMANENT';
spool off

/*
set lines 1000
column S_FILE_NAME format a30
column D_FILE_NAME format a30
select * from CONTROL_MIGRATION_FILE;

update CONTROL_MIGRATION_FILE set FL_STAT=0,FL_LOCK=0;
TRUNCATE TABLE CONTROL_MIGRATION_LOG;

DELETE FROM CONTROL_MIGRATION_LOG WHERE D_FILE_NAME IN ('ts_dat.270');

--Check eleapsed
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
select  cml.*, trunc(mod(mod(SYSDATE - DT_START,1)*24,1)*60) as mins from CONTROL_MIGRATION_LOG cml where DT_END IS NULL;

alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
select  cml.*, trunc(mod(mod(NVL(DT_END,SYSDATE) - DT_START,1)*24,1)*60) as mins from CONTROL_MIGRATION_LOG cml where TO_CHAR(DT_START,'DD/MM/YYYY') = TO_CHAR(SYSDATE,'DD/MM/YYYY');

--Check finalized
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
column D_FILE_NAME format a30
select  cml.*, trunc(mod(mod(DT_END - DT_START,1)*24,1)*60) as mins from CONTROL_MIGRATION_LOG cml;

*/

