#!/bin/bash

good=0

function filter {
	rule=${1%%:*}
	pass=${1##*:} # includes ' ' before password
	p1=${rule%%-*}
	p2=${rule##*-}
	p2=${p2%% *}
	c=${rule##* }
	match=0
	if [[ ${pass:$p1:1} == $c ]]
	then
		match=$((match + 1))
	fi

	if [[ ${pass:$p2:1} == $c ]]
	then
		match=$((match + 1))
	fi

	if ((match == 1))
	then
		good=$((good + 1))
	fi
}

while IFS= read -r line
do
	filter "$line"
done < input

echo "Good: $good"
