#!/bin/bash

field=()

while IFS= read -r line
do
	field+=("$line")
done < input

readonly desty=${#field[@]}
readonly colw=${#field[0]}

function traverse {
	local -n TREES=$1
	sl_r=$2
	sl_d=$3

	curx=0
	cury=0

	TREES=0

	while ((cury < desty ))
	do
		curx=$(((curx + sl_r) % colw))
		cury=$((cury + sl_d))

		row=${field[$cury]}
		if [[ ${row:$curx:1} = '#' ]]
		then
			TREES=$((TREES + 1))
		fi
	done
}

traverse t11 1 1
traverse t31 3 1
traverse t51 5 1
traverse t71 7 1
traverse t12 1 2

echo "5D Trees: $((t11 * t31 * t51 * t71 * t12))"
