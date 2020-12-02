#!/bin/bash

good=0

function filter {
	rule=${1%%:*}
	pass=${1##*:}
	min=${rule%%-*}
	max=${rule##*-}
	max=${max%% *}
	c=${rule##* }
	matches=${pass//[^$c]}
	count=${#matches}
	if ((min <= count && count <= max))
	then
		good=$((good + 1))
	fi
}

while IFS= read -r line
do
	filter "$line"
done < input

echo "Good: $good"
