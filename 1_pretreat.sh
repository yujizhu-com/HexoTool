#!bin/bash

function main()
{
	##准备工作
	##保留两空格,用于readme换行
	local time=$(date "+%Y-%m-%d %H:%M:%S") 
	local source="/Users/yujizhu/Documents/Git/MyHD/Center/WebStorm/blog2/source"
	local scaffolds="/Users/yujizhu/Documents/Git/MyHD/Center/WebStorm/blog2/scaffolds"
	local pic="/Users/yujizhu/Documents/Git/MyHD/Center/WebStorm/blog2/pic"
	local oldDir=`pwd`
	local temp=$oldDir"/temp.txt"
	local temp2=$oldDir"/temp2.txt"
	local temp3=$oldDir"/temp3.txt"
	local oldNames=$oldDir"/oldNames.txt"
	local newNames=$oldDir"/newNames.txt"
	cd $source
	
	##替换时间
	find . -name "*.md" > "$oldNames"
	local all=`cat "$oldNames"`
	for i in $all
	do
		sed -in "s|STIME|$time|g" "$i"
		rm -f "$i""n"
	done

	##按时间排序给文件命名
	grep -E "^date" `find . -name "*.md"`> "$temp"
	sed -in 's|date: ||g' "$temp"
	sed -in 's|:||g' "$temp"
	sed -in 's| ||g' "$temp"
	sed -in 's|-||g' "$temp"
	for i in `cat "$temp"`
	do
		local file=${i%.md*}
		local date=${i#*.md}
		echo "$date""|""$file" >> "$temp2"
	done
	cat "$temp2" | sort | grep -oE "[^|./]+$"> "$oldNames"

	#把文件名开头数字去掉
	grep -oE "[^0-9].*$" "$oldNames" > "$newNames"
	local ID=0
	for i in `cat "$newNames"`
	do
		((++ID))
		sed -in "s|${i}|${ID}_${i}|g" "$newNames"
	done
	sed -in "s|__|_|g" "$newNames"

	#暂存分隔符
	local OLD_IFS=$IFS
	IFS=$'\n'
	# 读取文件中的内容到数组中
	local oldNameArray=($(cat "$oldNames"))
	local newNameArray=($(cat "$newNames"))
	# 恢复分隔符
	IFS="$OLD_IFS"
	local expectCmd=""
	local Index=-1
	for file in ${oldNameArray[*]}
	do
		((++Index))
		local ID=$((Index+1))
		local newfile=${newNameArray[Index]}
		local from="$source""/""$file"".md" 
		local to="$source""/""$newfile"".md"
		local backup="$scaffolds""/""$file"".md" 
		#移动
		cp -f "${from}" "${to}""_temp"
		mv "${from}" "${backup}"
		cp "${to}""_temp" "${to}"
		rm -f "${to}""_temp"

		#赋予pic/下的图片序列号,拷贝到对应文件中
		local curDir=`pwd`
		cd "$pic"
		grep -oE "SID/.+\.(png|jpg|jpeg)" "$to" > "$temp"
		sed -in "s|SID/||g" "$temp"
		
		mkdir "${pic}/${newfile}"
		for file in `cat "$temp"`
		do
			mv "$file" "${pic}/${newfile}/${ID}_${file}"
		done

		#将SID/XXX替换为ID_XXX
		local path="${ID}_"
		sed -in "s|SID/|$path|g" "$to"
		rm -f "$to""n"

		cd "$curDir"

		#生成上传图片的命令
		rm -f "${pic}/${newfile}/.DS_Store"
		ls -A "${pic}/${newfile}"
		if [[ `ls -A "${pic}/${newfile}"` ]]
		then
			expectCmd=${expectCmd}'\n'
			expectCmd=${expectCmd}'\nexpect "ftp>*"'
			expectCmd=${expectCmd}'\nsend "lcd /Users/yujizhu/Documents/Git/MyHD/Center/WebStorm/blog2/pic/'${newfile}'\\r"'
			expectCmd=${expectCmd}'\n'
			expectCmd=${expectCmd}'\nexpect "ftp>*"'
			expectCmd=${expectCmd}'\nsend "mkdir /home/Hexo/blog/source/_posts/'${newfile}'\\r"'
			expectCmd=${expectCmd}'\n'
			expectCmd=${expectCmd}'\nexpect "ftp>*"'
			expectCmd=${expectCmd}'\nsend "cd /home/Hexo/blog/source/_posts/'${newfile}'\\r"'
			expectCmd=${expectCmd}'\n'
			expectCmd=${expectCmd}'\nexpect "ftp>*"'
			expectCmd=${expectCmd}'\nsend "mput *\\r"'
			expectCmd=${expectCmd}'\n'
		fi
	done

	local uploadFile="/Users/yujizhu/Documents/Git/MyHD/bin/hexo/2_upload.sh"
	sed -in "s|SENDPIC|${expectCmd}|g" "$uploadFile"
	# echo $expectCmd

	#收尾工作
	#删除sed -n 留下的临时文件
	rm -f "$temp"
	rm -f "$temp2"
	rm -f "$oldNames"
	rm -f "$oldNames""n"
	rm -f "$newNames"	
	rm -f "$newNames""n"
	rm -f "$temp""n"
	rm -f "$temp2""n"
	rm -f "$temp3""n"
	rm -f "$uploadFile""n"
	cd $oldDir
	echo "Pretreat Success"
}

main
exit