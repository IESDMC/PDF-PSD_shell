#!/bin/csh
rm -f minmax.temp
# =====Input arguments===== #
if($#argv != 1) then
  echo
  echo "getMaxValueOfMedian.csh [dir] "
  echo "e.g. getMaxValueOfMedian.csh /home/dmc/QC/PDF/STATS/TW.EC1F.--/EHZ/wrk/PDFanalysis.sts"
  echo
  exit 1
endif

set PDFanalysis_sts_Dir = $1
minmax $PDFanalysis_sts_Dir > minmax.temp
set maxString = `awk '{print $7}' minmax.temp`
set max = `echo $maxString | awk -F'/' '{print $2}' | awk -F'>' '{print $1}'`
echo $max
rm -f minmax.temp
