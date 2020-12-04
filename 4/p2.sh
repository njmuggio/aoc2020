#!/bin/bash

req=('byr:' 'iyr:' 'eyr:' 'hgt:' 'hcl:' 'ecl:' 'pid:')
t=''

good=0

function check {
	found=0

	# 1920 <= byr <= 2002
	if [[ $t =~ byr:([0-9]{4})[[:space:]] ]]
	then
		byr="${BASH_REMATCH[1]}"
		if ((1920 <= byr && byr <= 2002))
		then
			found=$((found + 1))
		fi
	fi

	# 2010 <= iyr <= 2020
	if [[ $t =~ iyr:([0-9]{4})[[:space:]] ]]
	then
		iyr="${BASH_REMATCH[1]}"
		if ((2010 <= iyr && iyr <= 2020))
		then
			found=$((found + 1))
		fi
	fi

	# 2020 <= eyr <= 2030
	if [[ $t =~ eyr:([0-9]{4})[[:space:]] ]]
	then
		eyr="${BASH_REMATCH[1]}"
		if ((2020 <= eyr && eyr <= 2030))
		then
			found=$((found + 1))
		fi
	fi

	# hgt must end with 'in' or 'cm'
	# if cm, 150 <= hgt <= 193
	# if in, 59 <= hgt <= 76
	if [[ $t =~ hgt:([0-9]+)(cm|in)[[:space:]] ]]
	then
		hgt="${BASH_REMATCH[1]}"
		unit="${BASH_REMATCH[2]}"

		if [[ $unit == 'cm' ]] && ((150 <= hgt && hgt <= 193))
		then
			found=$((found + 1))
		elif [[ $unit == 'in' ]] && ((59 <= hgt && hgt <= 76))
		then
			found=$((found + 1))
		fi
	fi
	
	# hcl valid hex RGB
	if [[ $t =~ hcl:#[a-f0-9]{6}[[:space:]] ]]
	then
		found=$((found + 1))
	fi

	# ecl is amb, blu, brn, gry, grn, hzl, or oth
	if [[ $t =~ ecl:(amb|blu|brn|gry|grn|hzl|oth)[[:space:]] ]]
	then
		found=$((found + 1))
	fi

	# pid is 9 digit number
	if [[ $t =~ pid:[0-9]{9}[[:space:]] ]]
	then
		found=$((found + 1))
	fi

	if [[ 7 -eq $found ]]
	then
		good=$((good + 1))
	fi
}

while IFS= read -r line
do
	t+="$line "
	if [[ -z "$line" ]]
	then
		check
		t=''
	fi
done < input

check # make sure we get the last one

echo $good
