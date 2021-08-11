#!/bin/csh
# =====Input arguments===== #
if($#argv != 6) then
  echo
  echo "getDBbyFrequency.csh [net] [station] [location] [channel] [year] [frequency]"
  echo "e.g.	TW CHS5 -- HHZ 2013 4"
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
set frequency = $6
set outputFile = dailyNoise_f$frequency.$net.$sta.$loc.$chan.$yr.txt

# =====Clear old files===== #
rm -f $outputFile

# =====Procedure===== #
set fileDir = /home/dmc/QC/PDF/STATS/$net.$sta.$loc/$chan/Y$yr/HOUR
set hourIdx = $fileDir/hour.idx
set bins = `ls $fileDir/*.bin`
set jday_array = `awk '{print $1}' $hourIdx`
set HHMM_array = `awk '{print $2}' $hourIdx`
set H_array = `awk '{print $3}' $hourIdx`
set numOfLine = $#H_array
set period = `echo 1 $frequency | awk '{printf "%.4f", $1/$2}'`
set i = 1

echo $numOfLine
echo $period

while($i <= $numOfLine)
  set jday = $jday_array[$i]
  set HHMM = $HHMM_array[$i]
  set H = $H_array[$i]
  set HH = `echo $HHMM | awk -F':' '{print $1}'`
  set MM = `echo $HHMM | awk -F':' '{print $2}'`
  set jday_output = `echo $jday $HH $MM | awk '{printf "%.4f", ($1+($2+$3/60)/24)-1}'`
  set Freq_lower = `grep $H $fileDir/H$jday.bin | awk '{if ($2 < period) print $1,$2,$3}' period=$period | awk END'{print $1,$2,$3}'`
  set Freq_higher = `grep $H $fileDir/H$jday.bin | awk '{if ($2 > period) print $1,$2,$3}' period=$period | awk NR==1'{print $1,$2,$3}'`
  set mean = `echo $Freq_lower[3] $Freq_higher[3] | awk '{printf "%i", ($1+$2)/2}'`
  echo $jday_output $mean >> $outputFile
  @ i ++
end



