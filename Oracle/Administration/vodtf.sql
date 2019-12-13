select t.TABLESPACE_NAME, T.STATUS, T.CONTENTS, F.FILE_NAME, F.FILE_ID, F.BYTES, F.USER_BYTES, S.OWNER, S.SEGMENT_TYPE, S.SEGMENT_NAME,
SUM(S.BYTES) BYTES_DO_SEGMENTO
from DBA_TABLESPACES T, DBA_DATA_FILES F, DBA_EXTENTS S
where upper(f.file_name) like '%' || upper('&DATAFILE_FULLNAME') || '%'
and t.tablespace_name = f.tablespace_name
and s.tablespace_name = f.tablespace_name
and s.file_id = f.file_id
group by t.TABLESPACE_NAME, T.STATUS, T.CONTENTS, F.FILE_NAME, F.FILE_ID, F.BYTES, F.USER_BYTES, S.OWNER, S.SEGMENT_TYPE, S.SEGMENT_NAME
order by 1, 5, 8, 9;
