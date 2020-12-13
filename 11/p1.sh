#!/bin/bash

mapfile -t grid < input

declare -i width=${#grid[0]}
declare -i height=${#grid[@]}
declare -i mut=1
declare -i neighbors=0

function getNeighbors() {
	neighbors=0
	local -i x
	local -i y
	for ((y = $2 - 1; y <= $2 + 1; y++))
	do
		if ((y < 0 || y >= height))
		then
			continue
		fi

		local line="${grid[$y]}"

		for ((x = $1 - 1; x <= $1 + 1; x++))
		do
			if ((x < 0 || x >= width))
			then
				continue
			elif ((x == $1 && y == $2))
			then
				continue
			fi

			if [[ "${line:$x:1}" == '#' ]]
			then
				neighbors+=1
			fi
		done
	done
}

declare -i occupied=0
declare -i iter=0
while ((mut > 0))
do
	unset back
	declare -a back
	occupied=0
	mut=0
	for ((y = 0; y < ${#grid[@]}; y++))
	do
		line="${grid[$y]}"
		editLine=''

		for ((x = 0; x < "${#line}"; x++))
		do
			if [[ "${line:$x:1}" == 'L' ]]
			then
				getNeighbors $x $y
				if ((neighbors == 0))
				then
					editLine+='#'
					mut+=1
				else
					editLine+='L'
				fi
			elif [[ "${line:$x:1}" == '#' ]]
			then
				getNeighbors $x $y
				if ((neighbors >= 4))
				then
					editLine+='L'
					mut+=1
				else
					editLine+='#'
					occupied+=1
				fi
			else
				editLine+='.'
			fi
		done

		back[$y]="$editLine"
	done
	grid=(${back[*]})
done

echo $occupied
