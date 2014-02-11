#!/usr/bin/env bash

echo
echo "=====RUNNING TESTS====="

parsetest=$(echo "(2.1+ 3.6) // 2 * -9.434543 / 3.2 - 3!^2 * |-8| % 3" | bin/sc)
if [[ ${parsetest} = "-5.896589375" ]]
then
	echo "Parsing passed! (try saying that when you're drunk)"
else
	echo "Parsing failed..."

	printf "Testing addition... "
	parsetest=$(echo "3.7 + 9.65 + 2" | bin/sc)
	if [[ ${parsetest} = "15.35" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing subtraction... "
	parsetest=$(echo "9.64 - 7.23 - 2" | bin/sc)
	if [[ ${parsetest} = "0.41" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing unary negative... "
	parsetest=$(echo "3 + -9.8" | bin/sc)
	if [[ ${parsetest} = "-6.8" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing multiplication... "
	parsetest=$(echo "3.5 * 7" | bin/sc)
	if [[ ${parsetest} = "24.5" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing division... "
	parsetest=$(echo "9.9 / 3" | bin/sc)
	if [[ ${parsetest} = "3.3" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing floor division.. "
	parsetest=$(echo "-3.4 // 2" | bin/sc)
	if [[ ${parsetest} = "-2" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing modulo... "
	parsetest=$(echo "5.6 % 3" | bin/sc)
	if [[ ${parsetest} = "2.6" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing factorial... "
	parsetest=$(echo "3!" | bin/sc)
	if [[ ${parsetest} = "6" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	echo "Testing caret power... "
	parsetest=$(echo "3.2 ^ 1.1" | bin/sc)
	if [[ ${parsetest} = "3.59471924007347" ]]
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
	parsetest=$(echo "3.4 ** -2" | bin/sc)
	if [[ ${parsetest} = "0.0865051903114187" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	printf "Testing absolute... "
	parsetest=$(echo "|1-4|" | bin/sc)
	if [[ ${parsetest} = "3" ]]
	then
		echo "ok"
	else
		echo "failed"
		exit -1
	fi

	echo "Something more complicated must have gone wrong. :("
	exit -1
fi

vartest=$(echo "t = 3.54; t * t" | bin/sc)
if [[ ${vartest} = "12.5316" ]]
then
	echo "Variables passed!"
else
	echo "Variables failed."
	exit -1
fi

echo "=====NO FAILURES====="
echo
