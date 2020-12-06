#!/bin/bash

arr=()

while IFS= read -r line
do
	for i in ${arr[@]}
	do
		if ((i + line == 2020))
		then
			echo $((i * line))
			exit
		fi
	done

	arr+=($line)
done < input
