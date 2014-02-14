#!/usr/bin/env bash

echo
echo "=====RUNNING TESTS====="

output=$(echo "(2.1+ 3.6) // 2 * -9.434543 / 3.2 - 3!^2 * |-8| % 3" | bin/sc)
if [[ ${output} = "-5.896589375" ]]
then
	echo "Parsing passed! (try saying that when you're drunk)"
else
	echo "Parsing failed..."

	printf "Testing addition... "
	output=$(echo "3.7 + 9.65 + 2" | bin/sc)
	if [[ ${output} = "15.35" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing subtraction... "
	output=$(echo "9.64 - 7.23 - 2" | bin/sc)
	if [[ ${output} = "0.41" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing unary negative... "
	output=$(echo "3 + -9.8" | bin/sc)
	if [[ ${output} = "-6.8" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing multiplication... "
	output=$(echo "3.5 * 7" | bin/sc)
	if [[ ${output} = "24.5" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing division... "
	output=$(echo "9.9 / 3" | bin/sc)
	if [[ ${output} = "3.3" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing floor division.. "
	output=$(echo "-3.4 // 2" | bin/sc)
	if [[ ${output} = "-2" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing modulo... "
	output=$(echo "5.6 % 3" | bin/sc)
	if [[ ${output} = "2.6" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing factorial... "
	output=$(echo "3!" | bin/sc)
	if [[ ${output} = "6" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	echo "Testing caret power... "
	output=$(echo "3.2 ^ 1.1" | bin/sc)
	if [[ ${output} = "3.59471924007347" ]]
	then
		echo '        ___                  '
		echo ' `-._\ /   `--"--.,_         '
		echo '------>|            `--"--.,_'
		echo ' _.-./ `.___,,,,----"""--``. '
		echo "Carrot power activated!"
		echo "Uhh... I mean caret power works."
	else
		echo "failed"
		exit -1
	fi

	printf "Testing python-style power... "
	output=$(echo "3.4 ** -2" | bin/sc)
	if [[ ${output} = "0.0865051903114187" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing absolute... "
	output=$(echo "|1-4|" | bin/sc)
	if [[ ${output} = "3" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	echo "Something more complicated must have gone wrong. :("
	exit -1
fi

output=$(echo "t = eu; t * t" | bin/sc)
if [[ ${output} = "7.38905609893065" ]]
then
	echo "Variables passed!"
else
	echo "Variables failed..."

# this doesn't work because the output is on two lines but I'm not sure how to
# represent that in a string
#	printf "Testing use of ';'... "
#	output=$(echo "2; 3 + 1" | bin/sc)
#	if [[ ${output} = "2 4" ]]
#	then
#		echo "ok"
#	else
#		echo "failed"
#		exit -1
#	fi

	printf "Testing variable assignment... "
	output=$(echo "t = 2; t" | bin/sc)
	if [[ ${output} = "2" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing mathlib variables... "
	output=$(echo "t = pi; t" | bin/sc)
	if [[ ${output} = "3.14159265358979" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing variable maths... "
	output=$(echo "t = 2; t - t" | bin/sc)
	if [[ ${output} = "0" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	echo "Something more complicated must have gone wrong. D:"
	exit -1
fi

output=$(echo "cos(0)" | bin/sc)
if [[ ${output} = "1" ]]
then
	echo "Functions passed!"
else
	echo 'Functions failed. :\'
	exit -1
fi

echo "=====NO FAILURES====="
echo
