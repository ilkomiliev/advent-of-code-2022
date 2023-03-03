#!/usr/bin/env bash

INPUT_FILE="$1"

TTL=0
TTL_3=0

declare -A pos
counter=0
groups=()

chars_lower=()
for i in {97..123} ; do
  chars_lower+=("$(printf "\x$(printf %x $i)")")
done

for (( i=0; i<26; i++ )) ; do
  prio=$(( $i + 1 ))
  pos[${chars_lower[$i]}]=$prio
done

chars_upper=()
for i in {65..91} ; do
  chars_upper+=("$(printf "\x$(printf %x $i)")")
done

for (( i=0; i<26; i++ )) ; do
  prio=$(( $i + 27 ))
  pos[${chars_upper[$i]}]=$prio
done

check() {
  s1="$1"
  s2="$2"
  for (( i=0; i<${#s1}; i++ )) ; do
    sub1="${s1:$i:1}"
    for (( j=0; j<${#s2}; j++ )) ; do
      sub2="${s2:$j:1}"
      if [[ "$sub1" == "$sub2" ]] ; then
        TTL=$(( $TTL + pos[$sub2] ))
        return
      fi
    done
  done
}

check_groups() {
  s1="${groups[0]}"
  s2="${groups[1]}"
  s3="${groups[2]}"
  printf '%s\n' "${groups[@]}"
  echo "-------"
  for (( i=0; i<${#s1}; i++ )) ; do
    sub1="${s1:$i:1}"
    for (( j=0; j<${#s2}; j++ )) ; do
      sub2="${s2:$j:1}"
      if [[ "$sub1" == "$sub2" ]] ; then
        for (( k=0; k<${#s3}; k++ )) ; do
          sub3="${s3:$k:1}"
          if [[ "$sub1" == "$sub3" ]] ; then
            TTL_3=$(( $TTL_3 + pos[$sub3] ))
            return
          fi
        done
      fi
    done
  done
}

while read -r line ; do
  len=${#line}
  pos=$(( $len/2 ))
  s1="${line:0:$pos}"
  s2="${line:(-$pos)}"
  check "$s1" "$s2"
  groups[$counter]="$line"
  if [[ $counter -eq 2 ]] ; then
    counter=0
    check_groups
  else
    counter=$(( $counter + 1 ))
  fi
done < "$INPUT_FILE"

echo $TTL
echo $TTL_3