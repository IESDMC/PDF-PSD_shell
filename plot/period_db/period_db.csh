#!/bin/csh   
set ps = 'Period_db.ps'
set jpg = 'Period_db.jpg'
set stas = (EC1F  EC2F  EC3F  EC4F  EC5F  EC6F  EC7F  EC8F  EC8A  EC8B  EC9F)
#set stas = (EC8A  EC8B  EC8A.L22D  EC8B.L22D)
set colors = (red  orange  yellow  green  blue  CYAN  purple  black  brown  pink  gray)
set periodMin = '2e-2'
set periodMax = '1e2'
set dbMin = '-150'
set dbMax = '-80'
set xtitle = 'Period (s)'
set ytitle = 'Median (dB)'
set lineWidth = 5
set i = 1
rm -f $ps
rm -f $jpg

psbasemap -JX8il/5i -R$periodMin/$periodMax/$dbMin/$dbMax -Ba1pf3:"$xtitle":/a10:"$ytitle":WSne -X5 -V -K > $ps
foreach sta ($stas)
	set fileDir = '/home/dmc/QC/PDF/STATS/TW.'$sta'.--/EHE/wrk/PDFanalysis.sts'
	echo $fileDir 'i='$i
	awk '{print $1, $4, 0.3}' $fileDir | psxy -JX -R -B -W$lineWidth/$colors[$i] -K -O >> $ps
set y = `expr -115 - 3 \* $i`
echo "0.05 $y 16 0 0 LM $sta" | pstext -JX -R -B -N -K -O >> $ps
psxy -J -R -B -N -W$lineWidth/$colors[$i] -K -O << END >> $ps
0.1 $y  
0.22 $y 
END
	@ i ++
end
psxy -JX -R -B -Sc -Wblack -Gwhite -O << end >> $ps
end

convert -density 150 -rotate 90 -trim $ps $jpg

gv $ps
