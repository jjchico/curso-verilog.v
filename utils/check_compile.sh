#!/bin/sh

find verilog -type d |
while read dir; do
	echo -n "Comprobando $dir... "
	cd "$dir"
	if ls *.v >> /dev/null 2>&1; then
		if iverilog *.v; then
			echo "OK"
		else
			echo "ERROR"
		fi
	fi
	cd - >> /dev/null
done
