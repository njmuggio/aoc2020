#!/bin/bash

min=1023
max=0
count=1 # start at 1 to account for missing seat (ours)
sum=0

while IFS= read -r line
do
	count=$((count + 1))
	val=0
	for ((i = 0; i < 10; i++))
	do
		val=$((val * 2))
		c="${line:$i:1}"
		if [[ $c == 'B' || $c == 'R' ]]
		then
			val=$((val + 1))
		fi
	done

	if ((val < min))
	then
		min=$val
	fi
	if ((val > max))
	then
		max=$val
	fi

	sum=$((sum + val))
done < input

expsum=0
if ((count % 2 == 0))
then
	expsum=$(((max + min) * (count / 2)))
else
	expsum=$(((max + min) * (count / 2) + (max + min) / 2))
fi

echo $((expsum - sum))
