#!/bin/bash

mask=''

declare -r maskre='mask = ([01X]+)'
declare -r memre='mem\[([0-9]+)\] = ([0-9]+)'
declare -A memory
while IFS= read -r line
do
	if [[ $line =~ $maskre ]]
	then
		mask="${BASH_REMATCH[1]}"
	elif [[ $line =~ $memre ]]
	then
		declare -i realVal="${BASH_REMATCH[2]}"
		declare -i m=34359738368 # 0x800000000
		for ((i = 0; i < 36; i++))
		do
			if [[ "${mask:$i:1}" == '1' ]]
			then
				realVal=$((realVal | m))
			elif [[ "${mask:$i:1}" == '0' ]]
			then
				realVal=$((realVal & ~m))
			fi
			m=$((m >> 1))
		done
		memory+=([${BASH_REMATCH[1]}]=$realVal)
	fi
done < input

declare -i sum=0
for val in ${memory[@]}
do
	sum+=$val
done

echo $sum
