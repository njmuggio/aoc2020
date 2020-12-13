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

arr=(0 ${arr[*]})
destCount=(1)

for ((i = 0; i < ${#arr[@]}; i++))
do
	for ((j = i + 1; j < i + 4 && j < ${#arr[@]}; j++))
	do
		if ((${arr[$j]} - ${arr[$i]} <= 3))
		then
			destCount[$j]=$((${destCount[j]} + ${destCount[i]}))
		fi
	done
done

echo ${destCount[-1]}
