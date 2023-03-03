#!/usr/bin/env bash

MAX=0
MAX1=0
MAX2=0
CURR=0
ELF=1
ELF1=1
ELF2=1
COUNT=1

INPUT_FILE="$1"

while read -r line ; do
  if [[ -n "$line" ]] ; then 
    CURR=$(( $CURR + $line ))
  else
    if (( $CURR > $MAX )) ; then
      MAX2=$MAX1
      MAX1=$MAX
      MAX=$CURR
      ELF=$COUNT
    elif (( $CURR > $MAX1 )) ; then
      MAX2=$MAX1
      MAX1=$CURR
    elif (( $CURR > $MAX2 )) ; then
      MAX2=$CURR
    fi
    CURR=0
    COUNT=$(( $COUNT + 1 ))
  fi
done < "$INPUT_FILE"

echo "MAX: $MAX"
echo "ELF: $ELF"
echo "MAX1: $MAX1"
echo "MAX2: $MAX2"

echo "TTL: $(( $MAX + $MAX1 + $MAX2 ))"
