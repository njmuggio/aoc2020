#!/bin/bash

prog=()

while IFS= read -r line
do
	prog+=("$line")
done < input
prog+=("echo")

declare -r reAcc='acc (.*)'
declare -r reJmp='jmp (.*)'
declare -r reNop='nop (.*)'

function run {
	local -i acc=0
	local -i pc=0
	local -a progDup=("${prog[@]}")

	if [[ ${progDup[$1]} =~ $reJmp ]]
	then
		progDup[$i]="nop ${BASH_REMATCH[1]}"
	elif [[ ${progDup[$1]} =~ $reNop ]]
	then
		progDup[$i]="jmp ${BASH_REMATCH[1]}"
	else
		return
	fi

	while true
	do
		inst="${progDup[$pc]}"
		unset "progDup[$pc]"

		if [[ -z "$inst" ]]
		then
			break
		fi

		if [[ $inst =~ $reAcc ]]
		then
			acc+=${BASH_REMATCH[1]}
			pc+=1
		elif [[ $inst =~ $reJmp ]]
		then
			pc+=${BASH_REMATCH[1]}
		elif [[ $inst == 'echo' ]]
		then
			echo $acc
			exit
		else # nop
			pc+=1
		fi
	done
}

for i in "${!prog[@]}"
do
	run $i
done
