#!/bin/bash
echo "gen_md5"
echo "$1"
if [ $# -ne 1 ]; then
	echo "wrong input"
	exit 1
fi

cd $1

out_file="md5.result"
if [ -e $out_file ]; then
	rm $out_file
fi
all_files=`find .`
touch $out_file
for i in $all_files
do
   if [ -f $i ]; then
	   md5 $i >> $out_file 
   fi
done

cd -
