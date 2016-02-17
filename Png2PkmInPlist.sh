#!/bin/bash
while [ $# -ne 0 ]
do
	echo $1
	perl Png2PkmInPlist.pl $1
	shift
done 