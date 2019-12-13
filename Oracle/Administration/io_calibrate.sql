show parameters timed_statistics
show parameters FILESYSTEMIO_OPTIONS

COL NAME FORMAT A50
SELECT NAME,ASYNCH_IO FROM V$DATAFILE F,V$IOSTAT_FILE I
WHERE  F.FILE#=I.FILE_NO
AND    FILETYPE_NAME='DATA FILE';

--
SET SERVEROUTPUT ON

DECLARE

lat  INTEGER;

iops INTEGER;

mbps INTEGER;

num_disk INTEGER;

BEGIN

SELECT COUNT(*) INTO num_disk from v$asm_disk;
-- DBMS_RESOURCE_MANAGER.CALIBRATE_IO (<NUM_DISKS>, <MAX_LATENCY>, iops, mbps, lat);
DBMS_RESOURCE_MANAGER.CALIBRATE_IO (num_disk, 10, iops, mbps, lat);     

DBMS_OUTPUT.PUT_LINE ('max_iops = ' || iops);

DBMS_OUTPUT.PUT_LINE ('latency  = ' || lat);

DBMS_OUTPUT.PUT_LINE('max_mbps = ' || mbps);

DBMS_OUTPUT.PUT_LINE('num_disk = ' || num_disk);
end;

/


--Check result

SELECT TO_CHAR(start_time, 'DD/MM/YYYY hh24:mi:ss') as start_time,
	   TO_CHAR(end_time, 'DD/MM/YYYY hh24:mi:ss') as end_time,
	   max_iops,
	   max_mbps,
	   max_pmbps,
	   latency,
	   num_physical_disks as disks
	FROM dba_rsrc_io_calibrate;
