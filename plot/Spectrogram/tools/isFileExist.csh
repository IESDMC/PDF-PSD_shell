#!/bin/csh
# =====Input arguments===== #
if($#argv != 6) then
  echo
  echo "isFileExist.csh [net] [station] [location] [channel] [year] [month]"
  echo "e.g.	TW EC1F -- EHZ 2020 6"
  echo "	(use -- for no LOCATION specifier)"
  echo
  exit 1
endif

# =====Parameters settings===== #
set net = $1
set sta = $2
set loc = $3
set chan = $4
set yr = $5
set month = $6
set outputFile = 'isFileExist.temp'

# =====Clear old files===== #
rm -f $outputFile

# =====Procedure===== #
set Jdaylist = `/home/dmc/QC/PDF/plot/Spectrogram/tools/listJday.csh $yr $month`
foreach jday ( $Jdaylist )
    if ( -f "/home/dmc/QC/PDF/STATS/$net.$sta.$loc/$chan/Y$yr/HOUR/H$jday.bin" ) then
        echo '1' >> $outputFile
        exit 1
    endif
end

if ( ! -e $outputFile ) then
    echo '0' >> $outputFile
endif



