#!/bin/bash

mapfile -t grid < input

declare -i width=${#grid[0]}
declare -i height=${#grid[@]}
declare -i mut=1
declare -i neighbors=0

function getNeighbors() {
	neighbors=0
	for ((vy = -1; vy <= 1; vy++))
	do
		for ((vx = -1; vx <= 1; vx++))
		do
			if ((vx == 0 && vy == 0))
			then
				continue
			fi

			local -i x=$(($1 + vx))
			local -i y=$(($2 + vy))

			while ((x >= 0 && x < width && y >= 0 && y < height))
			do
				local line="${grid[$y]}"
				if [[ "${line:$x:1}" == '#' ]]
				then
					neighbors+=1
					break
				elif [[ "${line:$x:1}" == 'L' ]]
				then
					break
				fi

				x=$((x + vx))
				y=$((y + vy))
			done
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
				if ((neighbors >= 5))
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
