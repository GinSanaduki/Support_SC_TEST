#!/bin/sh
# Extract_PressRelease.sh
# sh Extract_PressRelease.sh
# IPAの「情報セキュリティ10大脅威」のページと
# プレスリリースのPDFを取得
# 暫定として、2018年から2020年までを取得
# 読みたければ、2011年まではあるみたいだが

which curl > /dev/null 2>&1
test $? -ne 0 && echo "This Script needs CURL Command." && exit 99

YYYY="2018"
NowYYYY=`date | awk '{sub("年",""); print $1; exit;}'`

BaseURL_01="https://www.ipa.go.jp/security/vuln/10threats"
BaseURL_02=".html"

while :
do
	test $YYYY -gt $NowYYYY && exit 0
	URL="$BaseURL_01$YYYY$BaseURL_02"
	FileName="情報セキュリティ10大脅威_"$YYYY".txt"
	curl $URL > $FileName
	sleep 3
	
	cat $FileName | \
	egrep '<a href="/files/[0-9]*?\.pdf" target="_blank">情報セキュリティ10大脅威' | \
	sed -e 's/></>\n</g' | \
	fgrep '<a href=' | \
	sed -e 's/<a href="/https:\/\/www.ipa.go.jp/g' | \
	sed -e 's/target="_blank">//g' | \
	sed -e 's/<img alt=.*//g' | \
	sed -e 's/" /,/g' | \
	sed -e 's/\s/_/g' | \
	sed -e 's/　/_/g' | \
	sed -e 's/_https/https/' | \
	awk 'BEGIN{FS = ",";}{split($1,Arrays,"/"); PDF = Arrays[length(Arrays)]; delete Arrays; print "curl "$1" > "$2"_"PDF; print "sleep 3";}' | \
	sh
	clear
	YYYY=$(($YYYY + 1))
done

