-- remote database
create directory D_DIRECTORY as '+DG_DATA/NFEDEV/DATAFILE';
-- local database
create directory S_DIRECTORY as '+NFEDEV_DATA/NFEDEV/DATAFILE';
 
create public database link onfedev connect to system identified by ORACLE using 'ONFEDEV';
  

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