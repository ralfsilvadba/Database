#!/bin/bash

clear
echo""
echo "Zerando as estatísticas da instância. Por favor aguarde..."
onstat -z
sleep 10

touch sessoes.out

momento=$(date +"%d-%m-%Y_%H:%M:%S")

for thd in `onstat -g cpu|grep sqlexec|grep running|head -n 10|sort -r -n -k 6|awk '{print $1}'`
    do
      echo -e "thread_id: [$thd]"
      for rstcb in `onstat -g ath|grep $thd|grep -v Dynamic|head -n 10| sed -e "s/$thd/$thd /g" | awk '{print $3}'`
           do
             echo -e "rstcb_id: [$rstcb]"
             for ses in `onstat -u|grep $rstcb|head -n 10|awk '{print $3}'`
                 do
                   echo -e "sessao: [$ses]"
                   onstat -g ses $ses >> sessoes.out
                   echo
                 done
           done
    done

mv sessoes.out sessoes_$momento.out
echo ""
echo ""
echo ""
echo ""
echo "Sessoes que estao consumindo mais CPU no momento:"
echo ""
echo ""
echo ""
echo ""
cat sessoes_$momento.out
