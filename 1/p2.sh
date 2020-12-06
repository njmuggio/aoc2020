#!/bin/bash

arr=()

while IFS= read -r line
do
	for i in ${arr[@]}
	do
		for j in ${arr[@]}
		do
			if ((i + j + line == 2020))
			then
				echo $((i * j * line))
				exit
			fi
		done
	done

	arr+=($line)
done < input
