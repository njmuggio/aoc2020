#!/bin/bash

mapfile -t instructions < input

declare -i hdg=0
declare -i x=0
declare -i y=0

for inst in ${instructions[@]}
do
	[[ $inst =~ ([A-Z])([0-9]+) ]]

	case ${BASH_REMATCH[1]} in
		N)
			y=$((y + ${BASH_REMATCH[2]}))
			;;
		S)
			y=$((y - ${BASH_REMATCH[2]}))
			;;
		E)
			x=$((x + ${BASH_REMATCH[2]}))
			;;
		W)
			x=$((x - ${BASH_REMATCH[2]}))
			;;
		L)
			hdg=$(((hdg + ${BASH_REMATCH[2]}) % 360))
			;;
		R)
			hdg=$(((hdg + 360 - ${BASH_REMATCH[2]}) % 360))
			;;
		F)
			case $hdg in
				0)
					x=$((x + ${BASH_REMATCH[2]}))
					;;
				90)
					y=$((y + ${BASH_REMATCH[2]}))
					;;
				180)
					x=$((x - ${BASH_REMATCH[2]}))
					;;
				270)
					y=$((y - ${BASH_REMATCH[2]}))
					;;
			esac
			;;
	esac
done

echo $((${x#-} + ${y#-}))
