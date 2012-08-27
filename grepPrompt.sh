#!/bin/bash

##
## This script performs a grep on files and returns the result in prompt form
## such that the user can select a result and have it open automatically in vi
##
## Usage: '~/bin/grepPrompt.sh [CHJIYP] <query>'
##

EXT=""
if [ "$1" == "C" ]
then
  EXT='-name "*.c" -or -name "*.C" -or -name "*.cpp" -or -name "*.cc"'
elif [ "$1" == "H" ]
then
  EXT='-name "*.hh" -or -name "*.h" -or -name "*.hpp"'
elif [ "$1" == "J" ]
then
  EXT='-name "*.java"'
elif [ "$1" == "I" ]
then
  EXT='-name "*.idl"'
elif [ "$1" == "Y" ]
then
  EXT='-name "*.py"'
elif [ "$1" == "P" ]
then
  EXT='-name "*.proto"'
fi

#
# Prompt line
#
PS3="Choose: "

#
# Allow spaces as part of the selection
#
IFS="
"

#
# Query
#
CMD="find . $EXT | xargs egrep --color=always -nrI '$2' | uniq"
VAR=`eval $CMD`
#echo "$VAR"

echo "Choose from the list below."
select item in $VAR
do
  break
done

if [ "$item" = "" ]; then
  echo "Error in entry."
  exit 1
fi

#
# Open selection in vi
# Extract the file/line fields and strip out terminal color codes
#
FILE=`echo $item | cut -d':' -f 1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`
LINE=`echo $item | cut -d':' -f 2 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`

/usr/bin/vim $FILE +$LINE
