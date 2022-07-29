#!bin/bash

function main()
{
	cp "2_template.sh" "2_upload.sh"
	sh "1_pretreat.sh"
	expect "2_upload.sh"
	exit
}
main