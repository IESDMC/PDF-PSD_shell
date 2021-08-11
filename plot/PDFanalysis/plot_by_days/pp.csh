#!/bin/cah

set base = NACB.HHZ.2015.mode.ps  #---!!
set files = "*.1[6-9]?.mode.pdf"  #---!!

foreach f ($files)  
 set d = `echo $f | awk -F. '{print $4}'`
echo $d
 set ps = $d.mode.ps
 cp $base $ps
 set jpg = `echo $ps | sed "s/.ps/.jpg/g"`

 awk '{print $1,$2}' $f | psxy -JX8il/5i -R0.02/100/-200/-80 -B -W1/200/0/0 -K -O >> $ps
 convert -trim -rotate 90 -density 150 $ps $jpg
end

