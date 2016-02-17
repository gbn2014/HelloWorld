#!/bin/bash
# This script upload the update_resources to GameUpdate servers.
# case 1. upload to inhouse server for develop;
# case 2. upload to s3 server via aliyun.

# set evnironment to be "trunk/onlinedev/released" to start the scripts.
envir="trunk"
dest_dir="dest_dir"
server="server"

# define dest_dir and delete old path in aliyun server. 
function define_dest_and_delete_temp()
{
	if [ "$envir" == "trunk" ]; then
		dest_dir="/home/lizi/Software/tomcat/webapps/GameUpdateServer/game"
		server="lizi@192.168.1.139"
		echo "$evnir: unnecessary to delete old temps files."
	elif [ "$envir" == "onlinedev" ]; then
		dest_dir="/home/commander/workspace/upload/"
		server="commander@198.11.173.218"
		echo "$evnir: deleting old temps files."
		for path in `ls update_resources`; do
	    ssh $server <<EOF
	    rm -rf $dest_dir/$path
EOF
		done

	elif [ "$envir" == "released" ]; then
		dest_dir="/home/commander/workspace/upload/"
		server="commander@198.11.173.218"
		echo "$evnir: deleting old temps files."
		for path in `ls update_resources`; do
	    ssh $server <<EOF
	    rm -rf $dest_dir/$path
EOF
		done
		
	elif [ "$envir" == "cnbeta" ]; then
                dest_dir="/home/commander/workspace/upload/"
                server="commander@198.11.173.218"
                echo "$evnir: deleting old temps files."
                for path in `ls update_resources`; do
            ssh $server <<EOF
            rm -rf $dest_dir/$path
EOF
                done

	else
		echo "error evnironment for dest_dir"
	fi
}
# copy update files to server:dest_dir if the major config of current platform is TRUE.

function upload()
{
	platform=$1;
	ifUpdate=$2;
	pre_version=$3;
	if [ "$ifUpdate" == "true" ]; then
		echo "==beginning to upload patches for platform $1============================================="
		platform_dir="update_resources/${platform}";
		version_dir="update_resources/${platform}/version";
		if [ -e $version_dir ]; then
			patch_folder=`cat $version_dir`;
		else
			patch_folder=${pre_version}"0";
			if [ ! -d $platform_dir ]; then
				 mkdir -p $platform_dir
			fi
			echo $patch_folder;
			echo $patch_folder > $version_dir
		fi
		scp -r $platform_dir $server:$dest_dir;
		echo "==platform $1 patches uploaded============================================================"
	fi
}

# run scripts and functions to start the uploading.
define_dest_and_delete_temp
echo "$dest_dir"
echo "$server"

while read LINE
do
		arr=($LINE);
		echo ${arr[0]} ${arr[1]} ${arr[2]}
		upload ${arr[0]} ${arr[1]} ${arr[2]};
		echo "$envir before transfer"
		if [ "$envir" == "onlinedev" ] || [ "$envir" == "released" ] || [ "$envir" == "cnbeta" ];then
			ssh $server <<EOF
		echo "$envir ======${arr[0]} "
    		cd $dest_dir; /home/commander/.rbenv/shims/ruby upload_path.rb $envir ${arr[0]}
EOF
		else
			echo "envir:$envir unnecessary to run transfer script"
		fi
done < ./major_version.conf

# update local patch_version.txt
android_version=`cat update_resources/android_global/version`;
echo "$android_version"
IFS="."
var=($android_version)
echo ${var[2]} > ./patch_version.txt
