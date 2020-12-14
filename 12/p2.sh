#!/bin/bash

mapfile -t instructions < input

declare -i x=0
declare -i y=0
declare -i wx=10
declare -i wy=1

for inst in ${instructions[@]}
do
	[[ $inst =~ ([A-Z])([0-9]+) ]]

	case ${BASH_REMATCH[1]} in
		N)
			wy=$((wy + ${BASH_REMATCH[2]}))
			;;
		S)
			wy=$((wy - ${BASH_REMATCH[2]}))
			;;
		E)
			wx=$((wx + ${BASH_REMATCH[2]}))
			;;
		W)
			wx=$((wx - ${BASH_REMATCH[2]}))
			;;
		L)
			case ${BASH_REMATCH[2]} in
				90)
					t=$wx
					wx=-$wy
					wy=$t
					;;
				180)
					wx=-$wx
					wy=-$wy
					;;
				270)
					t=$wx
					wx=$wy
					wy=-$t
					;;
			esac
			;;
		R)
			case ${BASH_REMATCH[2]} in
				90)
					t=$wx
					wx=$wy
					wy=-$t
					;;
				180)
					wx=-$wx
					wy=-$wy
					;;
				270)
					t=$wx
					wx=-$wy
					wy=$t
					;;
			esac
			;;
		F)
			x+=$((wx * ${BASH_REMATCH[2]}))
			y+=$((wy * ${BASH_REMATCH[2]}))
			;;
	esac
done

echo $((${x#-} + ${y#-}))
