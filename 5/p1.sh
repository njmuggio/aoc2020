#!/bin/bash

max=0

while IFS= read -r line
do
	val=0
	for ((i = 0; i < 10; i++))
	do
		val=$((val * 2))
		c="${line:$i:1}"
		if [[ $c == 'B' || $c == 'R' ]]
		then
			val=$((val + 1))
		fi
	done

	if ((val > max))
	then
		max=$val
	fi
done < input

echo $max
