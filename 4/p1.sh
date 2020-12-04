#!/bin/bash

req=('byr:' 'iyr:' 'eyr:' 'hgt:' 'hcl:' 'ecl:' 'pid:')
t=''

good=0

function check {
	found=0
	for f in ${req[@]}
	do
		if [[ $t == *"$f"* ]]
		then
			found=$((found + 1))
		fi
	done

	if [[ 7 -eq $found ]]
	then
		good=$((good + 1))
	fi
}

while IFS= read -r line
do
	t+=$line
	if [[ -z "$line" ]]
	then
		check
		t=''
	fi
done < input

check # make sure we get the last one

echo $good
