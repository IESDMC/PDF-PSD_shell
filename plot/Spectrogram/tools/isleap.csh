#!/bin/csh

# =====Input arguments===== #
if($#argv != 1) then
  echo
  echo "isleap.csh [year]"
  echo "e.g. isleap.csh 2020 "
  echo
  exit 1
endif

# =====Procedure===== #
# checking a leap year or not
if ( !($1 % 4) && ( $1 % 100 || !( $1 % 400) ) ) then
    echo '1'
else
    echo '0'
endif
