#!/bin/bash

mask=''

declare -r maskre='mask = ([01X]+)'
declare -r memre='mem\[([0-9]+)\] = ([0-9]+)'
declare -A memory

function setmem {
	local realAddr="$1"
	local val="$2"
	local t="${realAddr//X/}"
	local -i count=$((${#realAddr} - ${#t}))
	local -a xloc

	local -i i=0
	local -i m=0
	local bit='0'

	for ((i = 0; i < 36; i++))
	do
		if [[ "${realAddr:$i:1}" == 'X' ]]
		then
			xloc+=($i)
		fi
	done

	for ((i = 0; i < 2 ** count; i++))
	do
		t="$realAddr"
		m=$((1 << (${#xloc[@]} - 1)))
		while ((m > 0))
		do
			bit=$(((m & i) > 0 ? 1 : 0))
			t="${t/X/$bit}"
			m=$((m >> 1))
		done
		memory+=(["$t"]="$val")
	done
}

while IFS= read -r line
do
	if [[ $line =~ $maskre ]]
	then
		mask="${BASH_REMATCH[1]}"
	elif [[ $line =~ $memre ]]
	then
		realAddr=''
		declare -i m=34359738368 # 0x800000000
		for ((i = 0; i < 36; i++))
		do
			if [[ "${mask:$i:1}" == 'X' ]]
			then
				realAddr+='X'
			elif [[ "${mask:$i:1}" == '1' ]]
			then
				realAddr+='1'
			elif (((${BASH_REMATCH[1]} & m) > 0))
			then
				realAddr+='1'
			else
				realAddr+='0'
			fi
			m=$((m >> 1))
		done
		#memory+=([$realAddr]=${BASH_REMATCH[2]})
		setmem $realAddr ${BASH_REMATCH[2]}
	fi
done < input


declare -i sum=0
for val in "${memory[@]}"
do
	sum+=$val
done

echo $sum
