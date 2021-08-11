#!/bin/csh

# =====Input arguments===== #
if($#argv != 2) then
  echo
  echo "createBinFiles.csh [year] [month]"
  echo "e.g. createBinFiles.csh 2020 6 "
  echo
  exit 1
endif

# =====Parameters settings===== #
set yr = $1
set month = $2

# =====Procedure===== #
# checking a leap year or not
set isLeap = `/home/dmc/QC/PDF/plot/Spectrogram/tools/isleap.csh $yr`

# list the start day of specific month
if ( $isLeap == 1 ) then
    set jdayStart = (1  32  61  92  122  153  183  214  245  275  306  336  367)
else
    set jdayStart = (1  32  60  91  121  152  182  213  244  274  305  335  366)
endif

# list HXXX.bin into a file
set i = $jdayStart[$month]
set monthNext = `expr $month + 1`
while ( $i < $jdayStart[$monthNext] )
    if ( $i < 10 ) then
        set serial = H00$i.bin
    else if ( $i < 100 ) then
        set serial = H0$i.bin
    else
        set serial = H$i.bin
    endif
    echo $serial >> ./bin.temp
    echo $serial.temp >> ./bin_list_for_draw.temp
    @ i ++
end
