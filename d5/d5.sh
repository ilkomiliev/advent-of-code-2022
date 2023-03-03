#!/usr/bin/env bash

INPUT_FILE="$1"

TOP_STACK=()

declare -A cargo

parse_move() {
  line="$1" # move 1 from 2 to 1
  i1="${line%% from*}" # move 1
  how_many="${i1##move }" # 1
  sub="${line##*from }" # 2 to 1
  from=$(( "${sub%% to*}" - 1 )) # 2
  to=$(( "${sub##*to }" - 1 ))
  echo "$how_many $from $to"
}

move_9000() {
  tt=($(parse_move "$1"))
  how_many=${tt[0]}
  from=${tt[1]}
  to=${tt[2]}
  from_arr=(${cargo[$from]})
  to_arr=(${cargo[$to]})
  for (( hh=0; hh<$how_many; hh++ )) ; do
    last_from=$(( ${#from_arr[@]} - 1 ))
    to_arr[${#to_arr[@]}]=${from_arr[$last_from]}
    unset from_arr[$last_from]
  done
  cargo[$from]="${from_arr[@]}"
  cargo[$to]="${to_arr[@]}"
}

move_9001() {
  tt=($(parse_move "$1"))
  how_many=${tt[0]}
  from=${tt[1]}
  to=${tt[2]}
  from_arr=(${cargo[$from]})
  to_arr=(${cargo[$to]})
  for (( hh=0; hh<$how_many; hh++ )) ; do
    to_arr[$(( ${#to_arr[@]} + $hh ))]=${from_arr[$(( ${#from_arr[@]} - $how_many + $hh ))]}
  done
  for (( hh=0; hh<$how_many; hh++ )) ; do
    unset from_arr[$(( ${#from_arr[@]} - 1 ))]
  done
  cargo[$from]="${from_arr[@]}"
  cargo[$to]="${to_arr[@]}"
}

parse_cargo() {
  line="$1"
  count=0
  for (( i=0; i<${#line}; i+=4 )) ; do
    sub=$(echo ${line:$i:4} | tr -d '[ ]')
    if [[ -n $sub ]] ; then
      row=(${cargo[$count]})
      row[${#row[@]}]="$sub"
      cargo[$count]="${row[@]}" # this will save it as a string in bash!!!
    fi
    count=$(( $count + 1 ))
  done
}

fill_cargo() {
  for (( i=0; i<${#cargo[@]}; i++ )) ; do
    tmp=(${cargo[$i]})
    tmp1=()
    len=${#tmp[@]}
    for (( jj=0; jj<$len; jj++ )) ; do
      nn=$(( $len - $jj - 1 ))
      tmp1[$nn]=${tmp[$jj]}
    done
    cargo[$i]="${tmp1[@]}"
  done
}

print_cargo() {
  for (( i=0; i<${#cargo[@]}; i++ )) ; do
    echo "$i: ${cargo[$i]}"
  done
}

OLDIFS=$IFS
IFS=""
while read -r line ; do
  if [[ -n "$line" ]] ; then
    begin="${line:0:2}"
    if [[ "$begin" == "mo" ]] ; then
      move_9001 "$line"
    elif [[ "$begin" == " 1" ]] ; then
      IFS=$OLDIFS
      fill_cargo
      print_cargo
    else
      parse_cargo "$line"
    fi
  fi
done < "$INPUT_FILE"
IFS=$OLDIFS

echo "------------------"
print_cargo

last_elems=()
for (( i=0; i<${#cargo[@]}; i++ )) ; do
  arr=(${cargo[$i]})
  last_elems[$i]=${arr[$(( ${#arr[@]} - 1 ))]}
done

echo "${last_elems[@]}" # 9000: S P F M V D T Z T 9001: Z F S J B P R F P