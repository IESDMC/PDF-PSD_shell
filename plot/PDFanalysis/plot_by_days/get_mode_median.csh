#!/bin/csh

if ($#argv != 4) then
  echo ""
  echo " get_mode_median.csh [net] [sta] [chan] [year]"
  echo ""
  exit
endif

set net = $1
set sta = $2
set chan = $3
set yr = $4


set dir0 = /home/dmc/pgm/PDF/STATS/$net.$sta.--/$chan/Y$yr
set files = `ls $dir0/D*.bin`

foreach file ( $files )
  set day = `echo $file | awk -F/ '{print $NF}' | cut -c2-4`
  echo $day
  set out = "$sta.$chan.$yr.$day.mode.pdf"
#  set out2 = "$sta.$chan.$yr.$day.median.pdf"
  set Ts = `awk '{print $1}' $file | sort -n | uniq`
  if ( -e $out ) rm -f $out
#  if ( -e $out2 ) rm -f $out2
  foreach T ($Ts)
    #mode
    grep $T $file | sort -n -k3 | tail -1 >> $out

    #median
#    set l = `grep $T $file | wc -l |awk '{if ( $1%2 != 0 ) {print ($1+1)/2} else {print $1/2,($1/2)+1}}'`
#    if ( $#l == 2 ) then
#      grep $T $file | sort -n -k3 -r | awk '{if (NR==l1 || NR==l2) (db=$2+db) (N=N+$3)} END {print $1,db/2,N/2}' l1=$l[1] l2=$l[2] >> $out2
#    else 
#      grep $T $file | sort -n -k3 -r | awk '{if ( NR == l ) print $1,$2,$3 }' l=$l >>$out2
#    endif
  end

end
