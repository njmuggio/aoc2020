#!/bin/bash

declare -A cvt

rules=()

nestPattern='([[:digit:]]+) ([[:alpha:]]+ [[:alpha:]]+) bags?,?[[:space:]]?'

while IFS= read -r line
do
	pattern='^([[:alpha:]]+ [[:alpha:]]+).*no other bags'
	if [[ $line =~ $pattern ]]
	then
		cvt+=(["${BASH_REMATCH[1]}"]=1)
	else
		rules+=("$line")
	fi
done < input

while true
do
	unset skip
	for i in "${!rules[@]}"
	do
		unset skipThis
		rule="${rules[$i]}"
		[[ $rule =~ ^([[:alpha:]]+ [[:alpha:]]+) ]]
		bagType="${BASH_REMATCH[1]}"
		rule="${rule#${BASH_REMATCH[1]} bags contain }"
		thisSum=1

		while [[ $rule =~ $nestPattern ]]
		do
			rule="${rule#${BASH_REMATCH[0]}}"
			mult="${BASH_REMATCH[1]}"
			nestCvt="${cvt[${BASH_REMATCH[2]}]}"

			if [[ -z "$nestCvt" ]]
			then
				skip=1
				skipThis=1
				break
			fi

			thisSum=$((thisSum + mult * nestCvt))
		done

		if [[ ! -v skipThis ]]
		then
			unset "rules[$i]"
			if [[ $bagType == 'shiny gold' ]]
			then
				echo $((thisSum - 1))
				exit
			else
				cvt+=(["$bagType"]="$thisSum")
			fi
		fi

	done

	if [[ ! -v skip ]]
	then
		break
	fi
done

