#!/bin/bash

declare -a numBuf=()
declare -i lineIdx=0

while IFS= read -r line
do
	if ((lineIdx < 25))
	then
		numBuf+=("$line")
	else

		invalid=1

		for ((i = 1; i < 25; i++))
		do
			for ((j = 0; j < i; j++))
			do
				a=${numBuf[$i]}
				b=${numBuf[$j]}
				if ((line == a + b))
				then
					unset invalid
					break 2
				fi
			done
		done

		if [[ -v invalid ]]
		then
			echo $line
		fi

		numBuf[$((lineIdx % 25))]="$line"
	fi
	lineIdx+=1
done < input
