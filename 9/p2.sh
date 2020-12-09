#!/bin/bash

declare -a numBuf=()
declare -i lineIdx=0
declare -i target=0
while IFS= read -r line
do
	if ((lineIdx >= 25))
	then
		invalid=1

		for ((i = lineIdx - 24; i < lineIdx; i++))
		do
			for ((j = lineIdx - 25; j < i; j++))
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
			target=$line
		fi
	fi

	numBuf+=("$line")
	lineIdx+=1
done < input

declare -i low=0
declare -i high=2
declare -i sum=$((${numBuf[$low]} + ${numBuf[$high - 1]}))

while true
do
	if ((sum == target))
	then
		declare -i min=${numBuf[$low]}
		declare -i max=${numBuf[$high]}

		for ((i = low; i < high; i++))
		do
			if ((${numBuf[$i]} < min))
			then
				min=${numBuf[$i]}
			elif ((${numBuf[$i]} > max))
			then
				max=${numBuf[$i]}
			fi
		done

		echo $((min + max))
		exit
	elif ((sum < target))
	then
		sum+=${numBuf[$high]}
		high+=1
	else # sum > target
		sum+=-${numBuf[$low]}
		low+=1
	fi
done
