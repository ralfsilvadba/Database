--SELECT COUNT(*) TOTAL_NOTAS_PARADAS FROM TABLE(SYS.PR_LIST_NFS('/nfe_trgt/notas')) WHERE LOWER(COLUMN_VALUE) LIKE '%nfe.txt';
create or replace NONEDITIONABLE FUNCTION     PR_LIST_NFS (p_pattern        IN VARCHAR2,
                                             p_file_separator IN VARCHAR2 := '/')
  RETURN sys.TP_LIST_NFS PIPELINED
AS
  l_pattern VARCHAR2(32767);
  l_ns      VARCHAR2(32767);
BEGIN
  -- Make sure the pattern ends with the file separator.
  l_pattern := RTRIM(p_pattern, p_file_separator) || p_file_separator;

  sys.DBMS_BACKUP_RESTORE.searchfiles(
    pattern => l_pattern,
    ns      => l_ns,
    onlyfnm => TRUE,
    normfnm => TRUE);

  -- Pull back all files directly under specified directory.
  -- WHERE filter removes recursion.
  FOR cur_rec IN (SELECT fname_krbmsft
                  FROM   sys.x$krbmsft
                  WHERE  INSTR(SUBSTR(fname_krbmsft, LENGTH(l_pattern)+1), p_file_separator) = 0)
  LOOP
    -- Display the file name without the preceding path.
    PIPE ROW(SUBSTR(cur_rec.fname_krbmsft, LENGTH(l_pattern)+1));
  END LOOP;
  RETURN;
END;
/
