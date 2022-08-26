CLEAR COL
SET DEFINE ON
SET HEADING OFF
SET PAGES 200
accept ESQ prompt "Entre com o esquema:"
accept TIPO prompt "Entre com o tipo do objeto:"
accept OBJ prompt "Entre com o nome do objeto:"

EXEC DEPTREE_FILL('&TIPO',nvl('&ESQ','<DEFAULT_SCHEMA>'),'&OBJ')

SELECT 'QUANTIDADE DE OBJETOS QUE FICARÃO INVALIDOS: '||COUNT(*) FROM deptree
/
SELECT OWNER,OBJECT_NAME,OBJECT_TYPE FROM deptree WHERE OBJECT_TYPE <> 'SYNONYM' 
   GROUP BY OWNER,OBJECT_NAME,OBJECT_TYPE
/
SELECT OWNER,OBJECT_NAME,OBJECT_TYPE FROM deptree WHERE OBJECT_NAME LIKE 'GT_IPV_%' OR OBJECT_NAME LIKE 'FR_TM_%' AND OBJECT_TYPE <> 'SYNONYM'
   GROUP BY OWNER,OBJECT_NAME,OBJECT_TYPE
/
SET HEADING ON
SET DEFINE on
--/@


--Sequence para ser criada no banco de dados.
CREATE SEQUENCE deptree_seq;
--Tabela para ser criada no banco de dados.
 
   CREATE TABLE "DEPTREE_TEMPTAB" 
   (	"OBJECT_ID" NUMBER, 
	"REFERENCED_OBJECT_ID" NUMBER, 
	"NEST_LEVEL" NUMBER, 
	"SEQ#" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_DAT_SMALL"
  
--Procedure para ser criada no banco de dados.
create or replace PROCEDURE    "DEPTREE_FILL" (type char, schema char, name char) is
  obj_id number;
begin
  delete from deptree_temptab;
  commit;
  select object_id into obj_id from all_objects
    where owner        = upper(deptree_fill.schema)
    and   object_name  = upper(deptree_fill.name)
    and   object_type  = upper(deptree_fill.type);
  insert into deptree_temptab
    values(obj_id, 0, 0, 0);
  insert into deptree_temptab
    select object_id, referenced_object_id,
        level, deptree_seq.nextval
      from public_dependency
      connect by prior object_id = referenced_object_id
      start with referenced_object_id = deptree_fill.obj_id;
exception
  when no_data_found then
    raise_application_error(-20000, 'ORU-10013: ' ||
      type || ' ' || schema || '.' || name || ' was not found.');
end;
 
