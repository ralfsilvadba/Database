select /*+ ORDERED */ sh.username||'('||sh.sid||','||sh.serial#||')' Usuario_locando,
        sw.username||'('||sw.sid||')' Usuario_esperando,
        decode(lh.lmode,
                        1, 'null',
                        2, 'row share',
                        3, 'row exclusive',
                        4, 'share',
                        5, 'share row exclusive',
                        6, 'exclusive')  Lock_Type
from v$lock lw,
        v$lock lh,
        v$session sw,
        v$session sh
where lh.id1  = lw.id1
        and  sh.sid  = lh.sid
        and  sw.sid  = lw.sid
        and  sh.lockwait is null
        and  sw.lockwait is not null
        and  lh.type = 'TM'
        and  lw.type = 'TM';
