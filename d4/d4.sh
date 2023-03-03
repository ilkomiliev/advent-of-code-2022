#!/usr/bin/env bash

INPUT_FILE="$1"

TTL=0

while read -r line ; do
  s1="${line%%,*}"
  s2="${line##*,}"
  i11="${s1%%-*}"
  i12="${s1##*-}"
  i21="${s2%%-*}"
  i22="${s2##*-}"
  if (( $i11 <= $i21 )) && (( $i12 >= $i22 )) ; then
    TTL=$(( $TTL + 1 ))
  elif (( $i21 <= $i11 )) && (( $i22 >= $i12 )) ; then
    TTL=$(( $TTL + 1 ))
  fi
done < "$INPUT_FILE"

echo "ttl: $TTL" # 503