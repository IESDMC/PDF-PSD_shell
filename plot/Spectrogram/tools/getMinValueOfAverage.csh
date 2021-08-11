#!/bin/csh
rm -f minmax.temp
# =====Input arguments===== #
if($#argv != 1) then
  echo
  echo "getMinValueOfMedian.csh [dir] "
  echo "e.g. getMinValueOfMedian.csh /home/dmc/QC/PDF/STATS/TW.EC1F.--/EHZ/wrk/PDFanalysis.sts"
  echo
  exit 1
endif

set PDFanalysis_sts_Dir = $1
minmax $PDFanalysis_sts_Dir > minmax.temp
set minString = `awk '{print $7}' minmax.temp`
set min = `echo $minString | awk -F'/' '{print $1}' | awk -F'<' '{print $2}'`
echo $min
rm -f minmax.temp
