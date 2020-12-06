#!/bin/bash

sum=0

function check {
	unset aset
	declare -A aset
	len=${#1}
	for ((i = 0; i < len; i++))
	do
		c=${1:$i:1}
		prev=${aset[$c]:-0}
		aset+=([$c]=$((prev + 1)))
	done


	count=$2
	slen=0
	for ans in ${aset[@]}
	do
		if ((ans == count))
		then
			slen=$((slen + 1))
		fi
	done

	sum=$((sum + slen))
}

t=''
count=0

while IFS= read -r line
do
	count=$((count + 1))
	t+="$line"
	if [[ -z "$line" ]]
	then
		check "$t" $((count - 1)) # remove blank line
		t=''
		count=0
	fi
done < input

check "$t" $count

echo $sum
