#!/bin/csh

# =====Input arguments===== #
if($#argv != 2) then
  echo
  echo "firstJday.csh [year] [month]"
  echo "e.g. firstJday.csh 2020 6 "
  echo
  exit 1
endif

# =====Parameters settings===== #
set yr = $1
set month = $2

# =====Procedure===== #
# checking a leap year or not
if ( !($yr % 4) && ( $yr % 100 || !( $yr % 400) ) ) then
    set isLeap = 1
else
    set isLeap = 0
endif

# list the start day of specific month
if ( $isLeap == 1 ) then
    set months = (1  32  61  92  122  153  183  214  245  275  306  336)
   # echo $yr 'is a leap year.'
   # echo 'month' $month 'starts from jday' $months[$month]
   echo $months[$month]
else
    set months = (1  32  60  91  121  152  182  213  244  274  305  335)
   # echo $yr 'is not a leap year.'
   # echo 'month' $month 'starts from jday' $months[$month]
   echo $months[$month]
endif








