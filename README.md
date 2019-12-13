# Database 
This repository is intended to store the history of procedures and scripts used in various databases.

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
  
* [Rman] (Oracle/Rman)
  
  * [restore_database_from_veeam.sql](Oracle/Rman/restore_database_from_veeam.sql) - How to restore backup from Veeam One
