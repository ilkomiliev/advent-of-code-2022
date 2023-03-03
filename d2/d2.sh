#!/usr/bin/env bash

# Rock : 1 A X
# Paper: 2 B Y
# Scc  : 3 C Z

# Rock def Scc, Scc def Paper, Paper def Rock
#
# draw: 3
# A X = 1 => 4
# B Y = 2 => 5
# C Z = 3 => 6
#
# win: 6
# A Y = 2 => 8
# B Z = 3 => 9
# C X = 1 => 7
#
# loose: 0
# A Z = 3
# B X = 1
# C Y = 2

declare -A rules
declare -A rules1

# looses
rules["B X"]=1
rules["C Y"]=2
rules["A Z"]=3
#draws
rules["A X"]=4
rules["B Y"]=5
rules["C Z"]=6
# wins
rules["C X"]=7
rules["A Y"]=8
rules["B Z"]=9

## rules1
# X - loose, Y - draw, Z - win
rules1["A X"]=3
rules1["B X"]=1
rules1["C X"]=2

rules1["A Y"]=4
rules1["B Y"]=5
rules1["C Y"]=6

rules1["A Z"]=8
rules1["B Z"]=9
rules1["C Z"]=7


INPUT_FILE="$1"

TTL_SCORE=0
TTL_SCORE1=0

while read -r line ; do
  echo "$line"
  TTL_SCORE=$(( $TTL_SCORE + ${rules["$line"]} ))
  TTL_SCORE1=$(( $TTL_SCORE1 + ${rules1["$line"]} ))
done < "$INPUT_FILE"

echo "ttl score: $TTL_SCORE"
echo "ttl score1: $TTL_SCORE1"
