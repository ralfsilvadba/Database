CREATE SCRIPT HOT_LV0_DIARIO
{
        ALLOCATE CHANNEL t1 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so' maxpiecesize 50G;
        ALLOCATE CHANNEL t2 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so' maxpiecesize 50G;
        ALLOCATE CHANNEL t3 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so' maxpiecesize 50G;
        ALLOCATE CHANNEL t4 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so' maxpiecesize 50G;
        ALLOCATE CHANNEL t5 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so' maxpiecesize 50G;
        ALLOCATE CHANNEL t6 DEVICE TYPE SBT_TAPE PARMS 'SBT_LIBRARY=/opt/veeam/VeeamPluginforOracleRMAN/libOracleRMANPlugin.so' maxpiecesize 50G;

        BACKUP AS BACKUPSET DATABASE FORMAT 'dedf2dda-c24a-4ee2-8b2a-0ca1d21ff635/RMAN_DIARIO_L0_%d_%I_%s_%p_%t_%T.vab' KEEP UNTIL TIME 'SYSDATE+7' FILESPERSET 1;

        RELEASE CHANNEL t1;
        RELEASE CHANNEL t2;
        RELEASE CHANNEL t3;
        RELEASE CHANNEL t4;
        RELEASE CHANNEL t5;
        RELEASE CHANNEL t6;
}
