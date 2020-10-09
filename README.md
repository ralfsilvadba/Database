# Database 

### Oracle
* [Administration](Oracle/Administration)

  * [ts_used.sql](Oracle/Administration/ts_used.sql) - Show basic informations about free, used and total space of all tablespaces
  * [ts_datafile.sql](Oracle/Administration/ts_datafile.sql) - Show informations about datafiles of the specified tablespace 
  * [ts_tempfile.sql](Oracle/Administration/ts_tempfile.sql) - Show informations about tempfile of the specified temporary tablespace
  * [ts_extent.sql](Oracle/Administration/ts_extent.sql)  - Show informations about name, object_type, size and number of total extent allocation in specified tablespace
  * [bkpa.sql](Oracle/Administration/bkpa.sql) - Show informations about size, eleapsed time of backup archived log
  * [bkpf.sql](Oracle/Administration/bkpf.sql) - Show informations about size, eleapsed time, status and type of backup full
  * [bkpr.sql](Oracle/Administration/bkpr.sql) - Show informations about estimated completion time to restore database
  * [sf.sql](Oracle/Administration/sf.sql) - Show informations about long operations
  * [vdg.sql](Oracle/Administration/vdg.sql) - Show informations about free, used and total space of diskgroup
  * [vl.sql](Oracle/Administration/vl.sql) - Show informations about locks
  * [vlfg.sql](Oracle/Administration/vlfg.sql) - Show informations about size, status of redo log groups
  * [vsa.sql](Oracle/Administration/vsa.sql) - Show informations about all sessions of database
  * [vsqlid.sql](Oracle/Administration/vsqlid.sql) - Show informations about sql_id and prev_sql_id of sessions
  * [vsqltext.sql](Oracle/Administration/vsqltext.sql) - Show informations about text of sql_id
  * [trace.sql](Oracle/Administration/trace.sql) - Enable basic trace at specified session
  * [purge_explan.sql](Oracle/Administration/purge_explan.sql) - Purge execution plan from memory of database
  * [switch_logfile.sql](Oracle/Administration/switch_logfile.sql) - Show informations about total numbers of switch logfile by hour
  * [redo_advisory.sql](Oracle/Administration/redo_advisory.sql) - Show informations about recommended size for redo log groups
  * [restore_statistics.sql](Oracle/Administration/restore_statistics.sql) - Restore statistics of table
  * [manual_sqlTune.sql](Oracle/Administration/manual_sqlTune.sql) - Execution package sqlTune in command line
  * [undo_advisory.sql](Oracle/Administration/undo_advisory.sql) - Show information about recommended size for undo tablespace
  * [vodtf.sql](Oracle/Administration/vodtf.sql) - Show information about all objects in specified datafile
  * [io_calibrate.sql](Oracle/Administration/io_calibrate.sql) - Measure throughput statistics of storage.
  * [vparam.sql](Oracle/Administration/vparam.sql) - Show informations about parameters of database
  * [vhparam.sql](Oracle/Administration/vhparam.sql) - Show informations about hidden parameters of database
  * [vqtable.sql](Oracle/Administration/vqtable.sql) - Show informations about active query execution in specified table

* [Configuration](Oracle/Configuration)
  
  * [hugepages_setting.sh](Oracle/Configuration/hugepages_setting.sh) - Script to calculate number of hugepages
  * [hugepages_step_by_step.txt](Oracle/Configuration/hugepages_step_by_step.txt) - Step by Step used to configure Hugepages in database
  
* [Rman](Oracle/Rman)
  
  * [restore_database_from_veeam.sql](Oracle/Rman/restore_database_from_veeam.sql) - How to restore backup from Veeam One
  * [bkp_archive_log.cmd](Oracle/Rman/bkp_archive_log.cmd) - Script to take backup full stored in rman catalog
  * [bkp_hot_level_0.cmd](Oracle/Rman/bkp_hot_level_0.cmd) - Script to take backup archive log stored in rman catalog
  * [hot_db_diario.sh](Oracle/Rman/hot_db_diario.sh) - Script used in linux to execute rman backup full
  * [archive.sh](Oracle/Rman/archive.sh) - Script used in linux to execute rman backup archive log
  * [crosscheck_backup.cmd](Oracle/Rman/crosscheck_backup.cmd) - Script to run crosscheck stored in rman catalog
  * [crosscheck_backup.sh](Oracle/Rman/crosscheck_backup.sh) - Script used in linux to execute rman crosscheck

* [Cluster](Oracle/Cluster)

  * [config_database](Oracle/Cluster/config_database) - Show informations about service configuration database
  * [config_scan_listener](Oracle/Cluster/config_scan_listener) - Show informations about scan listener
  * [create_service_database](Oracle/Cluster/create_service_database) - Create service for database
  * [modify_oh_database](Oracle/Cluster/modify_oh_database) - Modify path of Oracle home
  * [modify_spfile_database](Oracle/Cluster/modify_spfile_database) - Modify path of spfile
  * [realocate_service](Oracle/Cluster/realocate_service) - Realocate service to another node
  * [start_stop_database](Oracle/Cluster/start_stop_database) - Start/Stop database via service
  * [start_stop_diskgroup](Oracle/Cluster/start_stop_diskgroup) - Start/Stop diskgroup via service
  * [start_stop_instance](Oracle/Cluster/start_stop_instance) - Start/Stop instance via service
  * [start_stop_listener](Oracle/Cluster/start_stop_listener) - Start/Stop listener via service
  * [start_stop_scan_listener](Oracle/Cluster/start_stop_scan_listener) - Start/Stop scan listener via service
  * [status_resource_cluster](Oracle/Cluster/status_resource_cluster) - Show all informations about resources registered in cluster
  
### Informix
* [Administration](Informix/Administration)

  * [active_sessions](Informix/Administration/active_sessions/) - Show informations about active sessions
  * [alert_log](Informix/Administration/alert_log) - Show informations about Alert log
  * [check_cpu_consuming.sh](Informix/Administration/check_cpu_consuming.sh) - Script list sessions by cpu consuming
  * [check_hadr](Informix/Administration/check_hadr) - Show informations about Informix replication (HADR)
  * [chunk_list](Informix/Administration/chunk_list) - Show information about chunck files
  * [enable_disable_trace](Informix/Administration/enable_disable_trace) - Enable/Disable trace at session
  * [lock](Informix/Administration/lock) - Show informations about lock
  * [log_status](Informix/Administration/log_status) - Show informations about redo log
  * [session_temp_consuming](Informix/Administration/session_temp_consuming) - Show informations about temp consuming
  * [sql_executed_session](Informix/Administration/sql_executed_session) - Show all informations about sessions and sql
  * [start_stop_informix](Informix/Administration/start_stop_informix) - Start/Stop informix instance
  * [add_chunk](Informix/Administration/add_chunk) - Script add new chunk to dbspace
  * [check_backup_path](Informix/Administration/check_backup_path) - Script check path backup full
  * [check_log_backup_path](Informix/Administration/check_log_backup_path) - Script check path log backup
  * [check_logbuff_wait](Informix/Administration/check_logbuff_wait) - Script check buffer log wait
  
* [Backup](Informix/Backup)
  
  * [backup_log](Informix/Backup/backup_log) - Script to take backup log
  * [hot_backup_level_0](Informix/Backup/hot_backup_level_0) - Script to take backup full
