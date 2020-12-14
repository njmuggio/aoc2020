#!/bin/bash

exec 3<>input
read -r start <&3
mapfile -d, -t buses <&3
exec 3>&-

declare -i min=$((2 ** 31 - 1))
declare -i minBus=0

for bus in ${buses[@]}
do
	if [[ $bus == 'x' ]]
	then
		continue
	fi

	d=$((start / bus * bus))
	if ((d < start))
	then
		d=$((d + bus))
	fi

	if ((d < min))
	then
		min=$d
		minBus=$bus
	fi
done

echo $((minBus * (min - start)))
