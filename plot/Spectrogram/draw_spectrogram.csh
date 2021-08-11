#!/bin/csh
# =====Update Aug. 7, 2020===== #
# =====    Change log     ===== #
# 1. hour.idx would exist in the first year (Finished) using splitHourIdx.csh to solve this problem
# 2. change y-axis accroding to different instruments 
#    - short period (10s ~ 0.05s) (E*, S*)
#    - broad band & strong motion (100s ~ 0.03s) (B*, H*)

# =====Input arguments===== #
if($#argv != 8) then
  echo
  echo "draw_spectrogram.csh [net] [station] [location] [channel] [year] [month] [cpt_max] [cpt_min]"
  echo "e.g.	TW EC1F -- EHZ 2020 06 0 0"
  echo "	(use -- for no LOCATION specifier; use 0 0 for auto detecting color bar)"
  echo "        (recommend entering -50 -190 for manually setting color bar)"
  echo
  exit 1
endif

# Automatically or manually set color bar
if ( ( $7 == 0 ) && ( $8 == 0 ) ) then
#    echo 'Automatically detect color bar'
    set isAutoCpt = 1

# if cpt are positive, exit
else if ( ( $7 > 0) || ( $8 > 0 ) ) then
    echo
    echo "Please retry! cpt should be 'Negative' in this procedure."
    echo 'You entered cpt_max = '$7 'cpt_min = '$8
    echo 
    exit 1

# if cpt_max < cpt_min, exit
else if ( $7 <= $8 ) then
    echo
    echo "Please retry! 'cpt_max' should at least be greater than 'cpt_min' by 10."
    echo 'You entered cpt_max = '$7 'cpt_min = '$8
    echo 
    exit 1

# if (cpt_max - cpt_man) < 10, exit
else if ( ( $7 - $8 ) < 10 ) then
    echo
    echo "Please retry! 'cpt_max' should at least be greater than 'cpt_min' by 10."
    echo 'You entered cpt_max = '$7 'cpt_min = '$8
    echo 
    exit 1

else
    set isAutoCpt = 0
endif 

# =====Parameters settings===== #
set net = $1
set sta = $2
set loc = $3
set chan = $4
set yr = $5
set month = `echo $6 | awk '{printf "%.02d" , $1}'`
set cpt_max = $7
set cpt_min = $8
set monthsLeap = (31 29 31 30 31 30 31 31 30 31 30 31)
set monthsNotLeap = (31 28 31 30 31 30 31 31 30 31 30 31)
set ps = $net.$sta.$loc.$chan.$yr.$month'.ps'
set jpg = $net.$sta.$loc.$chan.$yr.$month'.jpg'
set cpt = 'spectrogram.cpt'


# =====Clear old files===== #
rm -f $ps >& /dev/null
rm -f $jpg >& /dev/null
rm -f *.temp >& /dev/null
rm -f $cpt >& /dev/null

# =====Is the files exist?===== #
csh /home/dmc/QC/PDF/plot/Spectrogram/tools/isFileExist.csh $net $sta $loc $chan $yr $month
set isFileExist = `awk '{print $1}' isFileExist.temp`
if ( ! $isFileExist ) then
    echo
    echo "Cannot find! $net.$sta.$loc.$chan $yr $month (No such file or directory), abort!"
    echo
    exit 1
endif

# =====Prepreparation===== #
echo '--------------------------------------------------------------------------------'
echo '<-- Prepreparation -->'

# Create a file of input arguments for python procedure
echo $net $sta $loc $chan $yr $month > inputArguments.temp

# Create a list of all .bin files. e.g. In the June 2020 we have 153, 154, 155, ..., 182.
csh /home/dmc/QC/PDF/plot/Spectrogram/tools/createBinFiles.csh $yr $month

# Create files for drawing by merging Hxxx.bin and hour.idx
set hourIdxDir = /home/dmc/QC/PDF/STATS/$net.$sta.$loc/$chan/Y$yr/HOUR/hour.idx
if( ! -e $hourIdxDir) then
    echo
    echo "$hourIdxDir does not exist, abort!"
    echo
    exit 1
else
    python /home/dmc/QC/PDF/plot/Spectrogram/tools/merge_bin_idx.py
    echo  
endif

# Checking a leap year or not
echo 'Detecting: a leap year or not'
set isLeap = `/home/dmc/QC/PDF/plot/Spectrogram/tools/isleap.csh $yr`
if ( $isLeap == 1 ) then
    echo $yr 'is a leap year'
else
    echo $yr 'is not a leap year'
endif
echo


# =====Drawing setting===== #
set title = `echo $sta $chan $yr $month`
set cptInterval = 10
set periodMin = '3e-2'
set periodMax = '100'
set pointSize = 0.1
gmtset HEADER_FONT_SIZE	= 24p
gmtset LABEL_FONT_SIZE  = 18p
gmtset ANNOT_FONT_SIZE_PRIMARY	= 14p

# Create colorbar (cpt)
echo 'Detecting: cpt boundary value'
if ( ! $isAutoCpt ) then 
#    Manaul
    echo 'mode choose: manually'
    set maxValueCpt = $cpt_max
    set minValueCpt = $cpt_min
    echo 'max =' $maxValueCpt
    echo 'min =' $minValueCpt
else
#   Auto
    echo 'mode choose: automatically'
    set PDFanalysis_sts_Dir = /home/dmc/QC/PDF/STATS/$net.$sta.$loc/$chan/wrk/PDFanalysis.sts
    echo $PDFanalysis_sts_Dir
    set maxValue = `/home/dmc/QC/PDF/plot/Spectrogram/tools/getMaxValueOfMedian.csh $PDFanalysis_sts_Dir`
    set minValue = `/home/dmc/QC/PDF/plot/Spectrogram/tools/getMinValueOfMedian.csh $PDFanalysis_sts_Dir`
    #set maxValue = `/home/dmc/QC/PDF/plot/Spectrogram/tools/getMaxValueOfAverage.csh $PDFanalysis_sts_Dir`
    #set minValue = `/home/dmc/QC/PDF/plot/Spectrogram/tools/getMinValueOfAverage.csh $PDFanalysis_sts_Dir`
    set maxValueCpt = `echo | awk '{print (maxValue + 5)}' maxValue=$maxValue`
    set minValueCpt = `echo | awk '{print (minValue + 5)}' minValue=$minValue`
    echo 'max =' $maxValueCpt
    echo 'min =' $minValueCpt 
endif 
# e.g. makecpt -Crainbow -T-130/-80/10 -Z > $cpt
makecpt -Crainbow -T$minValueCpt/$maxValueCpt/$cptInterval -Do -Z > $cpt

# y-axis
echo $chan[1]
set firstLetterOfInstru = `echo $chan[1] | awk '{print substr($0,1,1)}'`
echo $firstLetterOfInstru
if ( $firstLetterOfInstru == 'E' || $firstLetterOfInstru == 'S') then
    set periodMin = '5e-2'
    set periodMax = '10'
endif

# =====Drawing figure===== #
echo '--------------------------------------------------------------------------------'
echo '<-- Drawing spectrogram -->'
set i = 1
# Day 01 - Day 10
psbasemap -JX15/2il -R0/10/$periodMin/$periodMax -Ba1f0.25:."$title":/a1pf3:"Period (sec)":WSne -P -X2.5 -Y20 -V -K > $ps
while ( $i > 0  && $i <= 10 )
    set binDir = `awk '(NR == i){print $1}' i=$i ./bin_list_for_draw.temp`
    if (-e $binDir ) then
        awk '{print $1+i-1,$2,$3,pointSize}' i=$i pointSize=$pointSize $binDir  | psxy -JX -R -Ss -C$cpt -V -K -O >> $ps
    endif
    @ i ++
end

# Day 11 - Day 20
set i = 11
psbasemap -JX15/2il -R10/20/$periodMin/$periodMax -Ba1f0.25:"":/a1pf3:"Period (sec)":WSne -Y-8 -V -K -O >> $ps
while ( $i > 10  && $i <= 20 )
    set binDir = `awk '(NR == i){print $1}' i=$i ./bin_list_for_draw.temp`
    if (-e $binDir ) then
        awk '{print $1+i-1,$2,$3,pointSize}' i=$i pointSize=$pointSize $binDir  | psxy -JX -R -Ss -C$cpt -V -K -O >> $ps
    endif
    @ i ++
end

# Day 21 - Day 29 or 30 or 31
set i = 21
psbasemap -JX16.5/2il -R20/30.999/$periodMin/$periodMax -Ba1f0.25:"Day":/a1pf3:"Period (sec)":WSne -Y-8 -V -K -O >> $ps
# If in a leap year 
if ( $isLeap == 1 ) then
    while ( $i > 20  && $i <= $monthsLeap[$month] )
        set binDir = `awk '(NR == i){print $1}' i=$i ./bin_list_for_draw.temp`
        if (-e $binDir ) then
            awk '{print $1+i-1,$2,$3,pointSize}' i=$i pointSize=$pointSize $binDir  | psxy -JX -R -Ss -C$cpt -V -K -O >> $ps
        endif
        @ i ++
    end
# If not in a leap year
else
    while ( $i > 20  && $i <= $monthsNotLeap[$month] )
        set binDir = `awk '(NR == i){print $1}' i=$i ./bin_list_for_draw.temp`
        if (-e $binDir ) then
            awk '{print $1+i-1,$2,$3,pointSize}' i=$i pointSize=$pointSize $binDir  | psxy -JX -R -Ss -C$cpt -V -K -O >> $ps
        endif
        @ i ++
    end
endif

# Color bar
#psscale -C$cpt -D15.5/12/8/0.3 -S -B10 -K -O >> $ps
psscale -C$cpt -D15.5/14.5/12/0.3 -S -B10 -K -O >> $ps

pstext -JX -R -N -O << END >> $ps
#31.8 1e5 18 -90 4 2 10log@-10@-(m@+2@+/s@+4@+)/Hz db
31.8 1e6 18 -90 4 2 10log@-10@-(m@+2@+/s@+4@+)/Hz db
END


# Convert ps to jpg
echo 'converting ps to jpg'
convert -density 150 -trim $ps $jpg
echo '--> done'

# =====Clear temp files===== #
rm -f *.temp

# =====View===== #
#gv $ps
