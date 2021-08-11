#!/bin/csh
if($#argv != 3) then
  echo
  echo "mk_table.csh [net] [site] [chan]"
  echo
  exit 1
endif

set net = $1
set sta = $2
set chan = $3

set dir0 = /home/dmc/pgm/PDF/STATS

set sts = $dir0/$net.$sta.--/$chan/wrk/PDFanalysis.sts   #/home/dmc/pgm/PDF/STATS/LD.LDA1.--/EPZ/wrk/PDFanalysis.sts

if (-e $sts) then
  set out = $net.$sta..$chan.txt
  awk '{print $1,$3,$4,$7}' $sts > $out  #T,mean,median,mode
  echo output: $out
else 
  echo "  no $sts file!"
endif
