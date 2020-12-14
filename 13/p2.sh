#!/bin/bash

exec 3<>input
read -r start <&3
mapfile -d, -t buses <&3
exec 3>&-

declare -a starts
declare -a offsets

for i in ${!buses[@]}
do
	if [[ ${buses[$i]} != 'x' ]]
	then
		starts+=(${buses[$i]})
		offsets+=($i)
	fi
done

declare -i step=${starts[0]}
declare -i val=0

for ((i = 1; i < ${#starts[@]}; i++))
do
	declare -i modVal=${starts[$i]}
	declare -i subVal=${offsets[$i]}

	for ((; (val + subVal) % modVal != 0; val += step))
	do
		true
	done

	step=$((step * modVal))
done

echo $val
