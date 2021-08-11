#!/bin/csh
if($#argv != 4) then
  echo
  echo "run.csh [net] [sta] [chan] [year]"
  echo
  exit 1
endif

set net = $1
set sta = $2
set chan = $3
set yr = $4
#set loc = "--" 
set loc = 02  #for CWB24

set sts = /home/dmc/pgm/PDF/STATS/$net.$sta.$loc/$chan/wrk/PDFanalysis.sts  #period(sec),min(db),mean(db),median(db),90%(db),max(db),mode(db)

# make list
if (-e $sts) then
  awk '{print NR,log($1)/log(10),$7}' $sts > tmp.in  #No. log10(T),mode
else
  echo "  no $sts file!"
endif

noisePower tmp.in $net.$sta.$loc.$chan.T001-01.out 0.01 0.1
noisePower tmp.in $net.$sta.$loc.$chan.T01-1.out 0.1 1
noisePower tmp.in $net.$sta.$loc.$chan.T1-10.out 1 10
##rm -f tmp.in
