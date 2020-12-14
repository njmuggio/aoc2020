#!/bin/bash

title="$1"
shift
title="$title: $*"

times=()

function total {
	if ((${#times[@]} == 0))
	then
		echo '0'
	else
		cmd=${times[*]}
		cmd=${cmd// /+}
		bc <<< "scale = 10; $cmd"
	fi
}

function run {
	t=$( (time "$@" > /dev/null) 2>&1)
	times+=($t)
}

function int_total {
	t=$(total)
	t="${t%.*}"
	echo "${t:-0}"
}

TIMEFORMAT='%3R'
while (((${#times[@]} < 30 && $(int_total) < 600) || $(int_total) < 5))
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

min=${times[0]}
max=${times[0]}
for t in ${times[@]}
do
	if (($(bc <<< "$t < $min")))
	then
		min=$t
	fi

	if (($(bc <<< "$t > $max")))
	then
		max=$t
	fi
done

bw=$(bc -l <<< "scale = 10; ($max - $min) / 10")

col=${times[*]}
tmp=$(mktemp)
echo -e "${col// /\\n}" > $tmp
gnuplot -p <<< "binwidth=$bw
bin(x,width)=width*floor(x/width)
set boxwidth binwidth
#set term dumb 120 31
set term png size 640,480 font 'Monospace,10'
set output 'hist.png'
unset key
set style fill solid border
set ylabel 'Runs'
set xlabel 'Seconds'
set title '$title'
plot '$tmp' using (bin(\$1,binwidth)):(1.0) smooth freq with boxes
"
rm $tmp
