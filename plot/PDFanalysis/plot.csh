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
set file = $net.$sta..$chan.txt   #input [T,mean,median,mode]

set item = ( mean median mode )
set l = ( 2 3 4 )  # column read from *.txt

set i = 1

while ( $i <= $#item )

set ps = $net.$sta..$chan"_"$item[$i].ps
set jpg = `echo $ps | sed "s/.ps/.jpg/g"`


# mean
psbasemap -JX8il/5i -R0.02/100/-200/-80 -Ba2f3:"period (sec)":/a10:"$item[$i] of power (dB)":neWS -K -X5 > $ps
foreach f ( $net.*.txt)
  #awk '{print log($1)/log(10),$l}' l=$l[$i] $f | psxy -J -R -B -W3/200/200/200 -K -O >> $ps
  awk '{print $1,$l}' l=$l[$i] $f | psxy -J -R -B -W3/200/200/200 -K -O >> $ps
end
  awk '{print $1,$l}' l=$l[$i] $file | psxy -J -R -B -W5 -K -O >> $ps
echo "1 -85 20 0 0 CM $net.$sta..$chan" | pstext -J -R -B -N -K -O >>$ps

convert -density 150 -rotate 90 -trim $ps $jpg

rm -f $ps
echo "  $jpg"

@ i ++
end

