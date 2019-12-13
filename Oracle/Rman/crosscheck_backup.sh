#!/bin/bash
export DB_UNIQUE_NAME=<DB_UNIQUE_NAME>
export DB_NAME=<DB_NAME>
export ORACLE_SID=<SID>
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1/
export PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export BDATA=`date +"%d%m%y%H%M"`

pCount=`ps -Al | grep crosscheck_backup.sh | wc -l`

if [ $pCount = 0 ] ; then

        rman target / CATALOG <user>/<pass>@<service> script CROSSCHECK_BACKUP  log=/u01/admin/log/cross_hot_sbt_diario_$ORACLE_SID.log.$BDATA

fi
