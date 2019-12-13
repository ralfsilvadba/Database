Restaurando backup em um novo servidor a partir do Veeam

1º Editar o arquivo "veeam_config.xml", adicionar ao "PluginParameters" o nome do host ou scan caso o ambiente a ser restaurado seja Oracle RAC
cd /opt/veeam/VeeamPluginforOracleRMAN
vi veeam_config.xml
<PluginParameters customServerName="oracle-scan.domain.test"/>

2º Com o usuário Oracle criar diretório de auditoria
cd $ORACLE_BASE/admin/
mkdir -p <SID ou  DB_UNIQUE_NAME>/adump

3º Caso o ambiente não possua nenhum banco de dados será necessário criar um novo banco para configurar o Veeam

4º Setar o SID e restaurar o SPFILE
export ORACLE_SID=<SID>

rman target / catalog <usuário>/<senha>@<SERICE>

RUN{
	STARTUP NOMOUNT;
	ALLOCATE CHANNEL t1 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so';
	RESTORE SPFILE FROM '<SPFILE_FULLPATH>';
	SHUTDOWN IMMEDIATE;
}

5º Caso o servidor não possua a quantidade necessária de recursor como a origem é necessário criar um PFILE a partir do SPFILE e efetuar a alteração.

6º Iniciar restore, neste ponto é necessário preencher o valor do DBID do banco a ser restaurado

RUN {
	STARTUP NOMOUNT;
	
	ALLOCATE CHANNEL t1 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so';
	ALLOCATE CHANNEL t2 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so';
	ALLOCATE CHANNEL t3 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so';
	ALLOCATE CHANNEL t4 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so';
	
	SET DBID <DBID>;
	RESTORE CONTROLFILE FROM '<CONTROL_FILE_FULL_PATH>';
	ALTER DATABASE MOUNT;
	RESTORE DATABASE;
	RECOVER DATABASE;
	
	
	RELEASE CHANNEL t1;
	RELEASE CHANNEL t2;
	RELEASE CHANNEL t3;
	RELEASE CHANNEL t4;
}

7º Se necessário, cadastrar os archived logs e reiniciar o processo de recover.

RUN {
	catalog device type 'SBT_TAPE'  backuppiece '<BACKUPPIECE_FULLPATH>';
}

RUN{
	ALLOCATE CHANNEL t1 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so';
	RECOVER DATABASE;
}

8º Abrir o database com open resetlogs.

alter database open resetlogs;

