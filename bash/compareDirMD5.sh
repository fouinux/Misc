#!/bin/bash
# Author : gfouilleul
# Usage : $0 [--file] dir1 dir2

# file Option : print output of `file -b $file` if files are differents
optFile=false

# Check & Extract parameters
if [ $# -ge 2 ] ; then
	# Pop parameter
	while [ $# -gt 2 ] ; do
		case "$1" in
			"--file" | "-f")
				optFile=true
				;;
			*)
				echo "Unknown parameter : $1"
				exit
		esac
		# Shift parameter
		shift
	done
	
	# Get the last 2 parameters
	dir1=$1
	dir2=$2
else
	echo "Usage : $0 [--file] dir1 dir2";
	exit
fi

# Check if dir1 & dir2 exist
if [ ! -d $dir1 ] ; then
	echo "Directory $dir1 doesn't exist!"
	exit
fi
if [ ! -d $dir2 ] ; then
	echo "Directory $dir2 doesn't exist!"
	exit
fi

# Foreach file in dir 1
for file in `find $dir1` ; do
	# Sub string
	short=${file#$dir1}
	short=${short#"/"}
	
	# File in dir 2
	file2="$dir2/$short"
	# File exist in 2nd directory
	if [ -f $file2 ] ; then
		# Compare MD5
		md5f1=`md5sum $file  | cut -d " " -f 1`
		md5f2=`md5sum $file2 | cut -d " " -f 1`
		
		# File differents
		if [ $md5f1 != $md5f2 ] ; then
			echo -e "\e[0;31mDiff\e[0m $file"
			
			# Opt file
			if [ $optFile = true ] ; then
				echo -e "\t`file -b $file`"
				echo -e "\t`file -b $file2`"
			fi
		fi
	elif [ -f $file ] ; then
		echo -e "\e[0;32mAlone\e[0m $file"
	fi
done

