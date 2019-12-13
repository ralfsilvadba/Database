# Database 
This repository is intended to store the history of procedures and scripts used in various databases.

### Oracle
* [Administration](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration) - List of scripts used by me for dayli maintenance in Oracle database.

  * [ts_used.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/ts_used.sql) - Show basic informations about free, used and total space of all tablespaces
  * [ts_datafile.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/ts_datafile.sql) - Show informations about datafiles of the specified tablespace 
  * [ts_tempfile.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/ts_tempfile.sql) - Show informations about tempfile of the specified temporary tablespace
  * [ts_extent.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/ts_extent.sql)  - Show informations about name, object_type, size and number of total extent allocation in specified tablespace
  * [bkpa.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/bkpa.sql) - Show informations about size, eleapsed time of backup archived log
  * [bkpf.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/bkpf.sql) - Show informations about size, eleapsed time, status and type of backup full
  * [bkpr.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/bkpr.sql) - Show informations about estimated completion time to restore database
  * [sf.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/sf.sql) - Show informations about long operations
  * [vdg.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/vdg.sql) - Show informations about free, used and total space of diskgroup
  * [vl.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/vl.sql) - Show informations about locks
  * [vlfg.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/vlfg.sql) - Show informations about size, status of redo log groups
  * [vsa.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/vsa.sql) - Show informations about all sessions of database
  * [vsqlid.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/vsqlid.sql) - Show informations about sql_id and prev_sql_id of sessions
  * [vsqltext.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/vsqltext.sql) - Show informations about text of sql_id
  * [trace.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/trace.sql) - Enable basic trace at specified session
  * [purge_explan.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/purge_explan.sql) - Purge execution plan from memory of database
  * [switch_logfile.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/switch_logfile.sql) - Show informations about total numbers of switch logfile by hour
  * [redo_advisory.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/redo_advisory.sql) - Show informations about recommended size for redo log groups
  * [restore_statistics.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/restore_statistics.sql) - Restore statistics of table
  * [manual_sqlTune.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/manual_sqlTune.sql) - Execution package sqlTune in command line
  * [undo_advisory.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/undo_advisory.sql) - Show information about recommended size for undo tablespace
  * [vodtf.sql](https://github.com/ralfsilvadba/Database/tree/master/Oracle/Administration/vodtf.sql) - Show information about all objects in specified datafile
