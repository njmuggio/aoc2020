#!/bin/bash

mapfile -t arr < input

function shell_sort {
	# https://oeis.org/A102549
	declare -ra gaps=(57 23 10 4 1)

	for gap in "${gaps[@]}"
	do
		for ((i = gap; i < ${#arr[@]}; i++))
		do
			declare -i t=${arr[$i]}

			for ((j = i; j >= gap && ${arr[$j - $gap]} > t; j -= gap))
			do
				arr[$j]=${arr[$j - $gap]}
			done
			arr[$j]=$t
		done
	done
}

shell_sort

declare -i inc1=0
declare -i inc3=1 # last step is 3
declare -i val=0

for j in ${arr[@]}
do
	if ((j - v == 1))
	then
		inc1+=1
	elif ((j - v == 3))
	then
		inc3+=1
	fi
	v=$j
done

echo $((inc1 * inc3))
