#!/bin/csh

# =====Input arguments===== #
if($#argv != 2) then
  echo
  echo "listJday.csh [year] [month]"
  echo "e.g. listJday.csh 2020 6 "
  echo
  exit 1
endif

# =====Parameters settings===== #
set yr = $1
set month = $2
set output = 'jday.temp'

# =====Procedure===== #
# checking a leap year or not
set isLeap = `/home/dmc/QC/PDF/plot/Spectrogram/tools/isleap.csh $yr`

# list the start day of specific month
if ( $isLeap == 1 ) then
    set jdayStart = (1  32  61  92  122  153  183  214  245  275  306  336  367)
else
    set jdayStart = (1  32  60  91  121  152  182  213  244  274  305  335  366)
endif

# list jday
set i = $jdayStart[$month]
set monthNext = `expr $month + 1`
while ( $i < $jdayStart[$monthNext] )
    if ( $i < 10 ) then
        set serial = 00$i
    else if ( $i < 100 ) then
        set serial = 0$i
    else
        set serial = $i
    endif
    echo $serial
    @ i ++
end








