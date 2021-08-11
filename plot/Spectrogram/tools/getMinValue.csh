#!/bin/csh
rm -f minmax.temp
# =====Input arguments===== #
if($#argv != 1) then
  echo
  echo "getMinValue.csh [dir] "
  echo "e.g. getMinValue.csh /home/dmc/QC/PDF/STATS/TW.EC1F.--/EHZ/wrk/PDFanalysis.sts"
  echo
  exit 1
endif

set PDFanalysis_sts_Dir = $1
minmax $PDFanalysis_sts_Dir > minmax.temp
#minmax PDFanalysis.sts > minmax.temp
set minString = `awk '{print $6}' minmax.temp`
set min = `echo $minString | awk -F'/' '{print $1}' | awk -F'<' '{print $2}'`
echo $min
rm -f minmax.temp
