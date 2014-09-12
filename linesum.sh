#!/bin/bash

cd $(dirname $0)
dir=$1
if [ "${dir}" = "" ]
then
	dir=.
fi

type=$2
if [ "${type}" = "" ]
then
	type=m
fi
output=${dir}/linesum.txt

if [ -f ${output} ]
then
	rm -f ${output}
fi

touch ${output}
function foldersum
{
	dir=$1
	
	total=0	
	while read file
	do
		num=$(cat "${file}" | wc -l | awk '{print $1}')
		let total=total+num
		
		echo ${file} -\> ${num} >> ${output}
		
	done <	<(find ${dir} -maxdepth 1 -iname "*.${type}")
	
	skip=0
	while read folder
	do
		if [ ${skip} -eq 0 ]
		then
			let skip=skip+1
			continue
		fi
		
		let num=$(foldersum ${folder})
		let total=total+num
		
	done < <( find ${dir} -maxdepth 1 \( ! -regex '.*/\..*' \) -type d)
	
	if [ ${total} -gt 0 ]
	then
		echo ${dir} -\> ${total} >> ${output}
	fi
	
	echo ${total}
}

foldersum $1
cat ${output}