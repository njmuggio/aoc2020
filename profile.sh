#!/bin/bash

times=()

function total {
	cmd=${times[*]}
	cmd=${cmd// /+}
	bc <<< "scale = 10; $cmd"
}

function run {
	t=$((time "$@" > /dev/null) 2>&1)
	times+=($t)
}

TIMEFORMAT='%3R'
while [[ ${#times[@]} -lt 5 ]] || (($(bc <<< "$(total) < 5.0")))
do
	run "$@"
done

printf "Runs:\t%d\n" ${#times[@]}
printf "Tot:\t%f\n" $(total)

avg=$(bc <<< "scale = 10; $(total) / ${#times[@]}")
printf "Avg:\t%f\n" $avg

cmd="scale = 10; sqrt((1 / (${#times[@]} - 1)) * ("
pfx=''
for t in ${times[@]}
do
	cmd+="$pfx($t - $avg)^2"
	pfx=' + '
done
cmd+='))'
s=$(bc -l <<< "$cmd")
printf "SD:\t%f\n" $s
