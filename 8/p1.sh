#!/bin/bash

prog=()

while IFS= read -r line
do
	prog+=("$line")
done < input

declare -i acc=0
declare -i pc=0
declare -r reAcc='acc (.*)'
declare -r reJmp='jmp (.*)'

while true
do
	inst="${prog[$pc]}"
	unset "prog[$pc]"

	if [[ -z "$inst" ]]
	then
		echo $acc
		exit
	fi

	if [[ $inst =~ $reAcc ]]
	then
		acc+=${BASH_REMATCH[1]}
		pc+=1
	elif [[ $inst =~ $reJmp ]]
	then
		pc+=${BASH_REMATCH[1]}
	else # nop
		pc+=1
	fi
done
