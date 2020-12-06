#!/bin/bash

sum=0

function check {
	unset aset
	declare -A aset
	len=${#1}
	for ((i = 0; i < len; i++))
	do
		c=${1:$i:1}
		aset+=([$c]=1)
	done

	slen=${#aset[@]}
	sum=$((sum + slen))
}

t=''

while IFS= read -r line
do
	t+="$line"
	if [[ -z "$line" ]]
	then
		check "$t"
		t=''
	fi
done < input

check "$t"

echo $sum
