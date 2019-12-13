set lines 150
COL NAME FOR A30
COL ALTER_SESSION FOR A15
COL ALTER_SYSTEM FOR A15
COL ALTERADO_POR_SID FOR A16
select t.name,
       t.ISSES_MODIFIABLE "ALTER_SESSION",
       t.ISSYS_MODIFIABLE "ALTER_SYSTEM",
       T.Isinstance_modifiable "ALTER_BY_SID",
       decode(t.type,
              1,
              'BOOLEAN',
              2,
              'STRING',
              3,
              'INTEGER',
              4,
              'PARAMETER FILE',
              5,
              'RESERVED',
              6,
              'BIG INTEGER') "DATATYPE"
  from v$parameter t
 where name LIKE LOWER('%&PARAMETER_NAME%');
