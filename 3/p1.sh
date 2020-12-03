#!/bin/bash

field=()

while IFS= read -r line
do
	field+=("$line")
done < input

readonly sl_r=3
readonly sl_d=1
readonly desty=${#field[@]}
readonly colw=${#field[0]}

curx=0
cury=0

trees=0

while ((cury < desty ))
do
	curx=$(((curx + sl_r) % colw))
	cury=$((cury + sl_d))

	row=${field[$cury]}
	if [[ ${row:$curx:1} = '#' ]]
	then
		trees=$((trees + 1))
	fi
done

echo "Trees: $trees"
