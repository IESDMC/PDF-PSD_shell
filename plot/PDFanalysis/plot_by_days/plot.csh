#!/bin/csh
if ($#argv != 3) then
  echo ""
  echo "plot.csh [sta] [chan] [year]"
  echo ""
  exit
endif

set sta = $1
set chan = $2
set yr = $3

#set files = "$sta.$chan.$yr.*.mode.pdf"
set files = "$sta.$chan.$yr.*.median.pdf"

#set ps = $1.$2.$3.mode.ps
set ps = $1.$2.$3.median.ps
set jpg = `echo $ps | sed "s/.ps/.jpg/g"`
psbasemap -JX8il/5i -R0.02/100/-200/-80 -B2f3:"period (sec)":/a10:"power (dB)":neWS -K -X5 > $ps

set color = 225
foreach f ($files)
  awk '{print $1,$2}' $f | psxy -J -R -B -W1/$color -K -O >> $ps
  @ color = $color - 1
end

convert -trim -rotate 90 -density 150 $ps $jpg
