#!/bin/bash
export DB_UNIQUE_NAME=<DB_UNIQUE_NAME>
export DB_NAME=<DB_NAME>
export ORACLE_SID=<SID>
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1/
export PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export BDATA=`date +"%d%m%y%H%M"`

rman target / CATALOG <user>/<pass>@<service> script ARCHIVE_LOG  log=/u01/admin/log/arc_bkp_sbt_$ORACLE_SID.log.$BDATA
