#!/bin/bash

outer=('shiny gold')

rules=()

while IFS= read -r line
do
	rules+=("$line")
done < input

while true
do
	prevCount=${#outer[@]}

	for outBag in "${outer[@]}"
	do
		pattern="^([[:alpha:]]+ [[:alpha:]]+).*$outBag"

		ruleCount=${#rules[@]}
		for i in "${!rules[@]}"
		do
			rule="${rules[$i]}"
			if [[ $rule =~ $pattern ]]
			then
				unset "rules[$i]"
				outer+=("${BASH_REMATCH[1]}")
			fi
		done
	done

	newCount=${#outer[@]}
	if ((newCount == prevCount))
	then
		break
	fi
done

count=${#outer[@]}
echo $((count - 1))
