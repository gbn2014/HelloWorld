#!/bin/bash
CUR_DIR=`dirname $0`
echo "==start to update svn========================================================="
svn up ../../../../
echo "==svn update finished========================================================="
echo "==remove previous compared and update files==================================="
rm -rf compared_resources/*
rm -rf package_resources/*
find ./update_resources | grep -v "version\|site" | xargs rm -rf
svn up ./
#NEW_RES_VERSION=$1
while read VER
do
		arr=($VER);
		echo "gaobingnan"
		LAST_VERSION=${arr[0]};
		NEW_RES_VERSION=`expr $LAST_VERSION + 1`
done < ./patch_version.txt
echo "$NEW_RES_VERSION \n"

if [ $NEW_RES_VERSION == 0 ]; then
		rm -rf original_resources/* 
fi
echo "==cpoy Rawdata from trunk for a new version==================================="
perl copy_resource.pl $NEW_RES_VERSION
if [ $NEW_RES_VERSION -gt 0 ]; then
	echo "$NEW_RES_VERSION is bigger than 0"
	perl compare_md5_resource.pl $NEW_RES_VERSION
	perl jit_pkm_pvr.pl
else
	while read LINE
	do
			arr=($LINE);
			echo ${arr[0]} ${arr[1]} ${arr[2]};
			firstVersion=${arr[2]}"0";
			echo "$firstVersion is new version";
			fileDir="./update_resources/${arr[0]}/version"
			echo "$fileDir is path"
			echo $firstVersion > $fileDir
	done < ./major_version.conf
fi
function create()
{
		file=$1;
		ifUpdate=$2;
		pre_version=$3;
		fileDir=$4;
		version=${pre_version}${NEW_RES_VERSION};
		if [ $ifUpdate == "true" ]; then
				if [ $NEW_RES_VERSION -gt 0 ]; then
					perl zip_and_rename.pl $3 $version $4 $file					
				fi
		fi
}
echo "==parase conf================================================================="
while read LINE
do
		arr=($LINE);
		create ${arr[0]} ${arr[1]} ${arr[2]} ${arr[3]};
done < ./major_version.conf

ls -l;
