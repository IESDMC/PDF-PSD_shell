#!/bin/csh
# =====Update===== #
# 1. Aug. 7, 2020
# =====Goals===== #
# 1. Split the hour.idx file, if there are more than one year record.
# =====Givens===== #
# 1. [net] [station] [location] [channel]
# =====Constraints===== #
# 1. Exit when there are no such files.
# 2. Exit when it has not been analyzed.
# 3. No need to process.
# 4. Report message when the file has been processed.
# =====Change log===== #
# 1. check whether split hour.idx or not (Finished)
# 2. how to check whether a file has been processed or not? (Finished)
#    - (X)use the number of lines. if lines > 366*47 = 17202, it has to be splited (does not work).
#    - (X)what if a file starts from 2014-12-31 and ends up at 2015-01-15. It only lasted 2 weeks.
#    - (O)use python to read. If the later num in less than the previous num, there would be a change of year.

# =====Input arguments===== #
if($#argv != 4) then
  echo
  echo "splitHourIdx.csh [net] [station] [location] [channel]"
  echo "e.g.	splitHourIdx.csh CC IT01 -- HHE"
  echo "	(use -- for no LOCATION specifier)"
  echo
  exit 1
endif

# =====Parameters settings===== #
set net = $1
set sta = $2
set loc = $3
set chan = $4

# =====Clear old files===== #
rm -f inputArguments.temp >& /dev/null
rm -f isHourIdxOneYear.temp >& /dev/null

# =====Is the files exist?===== #
# /home/dmc/QC/PDF/STATS/CC.IT01.--/HHE
set DirSTATS = '/home/dmc/QC/PDF/STATS'
set DirSta = $DirSTATS/$net.$sta.$loc
set DirChan = $DirSta/$chan
set YearFiles = `bash -c "ls -d $DirChan/Y* 2>/dev/null"`
set FirstYear = `echo $YearFiles | awk '{print $1}'`
set DirHOUR = $FirstYear/HOUR
set FileHourIdx = $DirHOUR/hour.idx

# No such file or directory
if ( ! -d "$DirChan" ) then
    echo
    echo "No such file or directory $DirChan, abort!"
    echo
    exit 1
else
#   force the conmmand to run with bash shell. This is beacuse we can not redirect stderr in csh.
    set NumOfYearFiles = `bash -c "ls -d $DirChan/Y* 2>/dev/null | wc -l || echo '0'"`
endif

# Has not been analyized (It has run makePDFscript. However, It hasn't run excutePDF.)
if ( ! $NumOfYearFiles ) then
    echo
    echo "No Year files in $DirChan, abort!"
    echo
    exit 1

# Only one year. No need to split. NumOfYearFiles == 1
else if ( $NumOfYearFiles > 0 && $NumOfYearFiles < 2 ) then
    echo
    echo "There's no need to split! $DirChan has only one year record."
    echo
    exit 1

# Has to split
else
#   create a arguments file for python
    echo $net $sta $loc $chan > inputArguments.temp
    echo $YearFiles >> inputArguments.temp
#   is hour.idx only a year data or not
    python /home/dmc/QC/PDF/PROD/bin/tools/splitHourIdx/isHourIdxOneYear.py
    set isHourIdxOneYear = `awk '{print $1}' isHourIdxOneYear.temp`
    if ( ! $isHourIdxOneYear ) then
        echo 'We would like to split the hour.idx. There are '$NumOfYearFiles' years data.'
    else
        echo
        echo 'Data have been processed! '
        echo
        rm -f inputArguments.temp >& /dev/null
        rm -f isHourIdxOneYear.temp >& /dev/null
        exit 1
    endif
endif

# =====Procedure===== #
set time_start = `date +%s`
# run python to split
python /home/dmc/QC/PDF/PROD/bin/tools/splitHourIdx/splitHourIdx.py

# ====Backup & rename===== #
cp $FirstYear/HOUR/hour.idx $FirstYear/HOUR/hour.idx.bak
echo '--> rename : '$FirstYear/HOUR/hour.idx.new' to 'hour.idx
rm -f $FirstYear/HOUR/hour.idx
mv $FirstYear/HOUR/hour.idx.new $FirstYear/HOUR/hour.idx

# =====Clear temp files===== #
rm -f inputArguments.temp
rm -f isHourIdxOneYear.temp

# =====View===== #
# =====Run time===== #
set time_end = `date +%s`
set runtime = `echo | awk '{print (end-start)}' end=$time_end start=$time_start`
echo 'Done. runtime = '$runtime's'
