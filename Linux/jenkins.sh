#! /bin/sh
#
# jenkins.sh
# Copyright (C) 2017 eda <eda@engub>
#
# Distributed under terms of the MIT license.
#

USER='eda'
PASSWD='eda'
JENKENS_SERVER='http://embeddedbuilder:8080'

test () {
curl "${JENKENS_SERVER}/job/3012UDC-J2K-10G-LITE/2/doDelete" \
	 -X POST --user "${USER}:${PASSWD}" \
     -H "Host: embeddedbuilder:8080" \
     -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0" \
     -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
     -H "Accept-Language: en-US,en;q=0.5" \
     --compressed -H "Referer: http://embeddedbuilder:8080/view/EthanView/job/3012UDC-J2K-10G-LITE/1/confirmDelete" \
     -H "Cookie: screenResolution=1920x1080; ACEGI_SECURITY_HASHED_REMEMBER_ME_COOKIE=""ZWRhOjE0OTM3MzgxMzk4NDI6MDkxZjZkZWI0NjY1ZjdmYzhlZTE1MWVmZmQ3OGM4MDZjOWNjOTk0YjliMDY4ZmNhMjc3YTliYTlkOTU0MjhkYQ==""; JSESSIONID.f11631cc=1e8jidlv0ngrc4pg868e10x7e; screenResolution=1920x1080" \
     -H "Connection: keep-alive" \
     --data "json="%"7B"%"7D&Submit=Yes"
}

Usage () {
	echo 'jenkins list   [View]'
	echo 'jenkins export [View] [Job-Filter]'
	echo 'jenkins delb   <Job> <build-list>'
}

list_jobs () {
	if [ -n "$1" ]; then
		JENKENS_URL="${JENKENS_SERVER}/view/$1/"
	else
		JENKENS_URL="${JENKENS_SERVER}"
	fi

	HTML_RET=`curl "${JENKENS_URL}" -X POST --user "${USER}:${PASSWD}" 2>/dev/null | sed -n '/<div id="main-panel">/{p; :loop n; p; b loop}'`
	echo $HTML_RET | grep -oh 'job/[^/]*/' | sort -u
}

export_cfg () {
	CUR_TS="$(date +'%Y-%m-%d_%H-%M-%S')"
	mkdir -p $CUR_TS

	JOBS_LIST="$(list_jobs $1)"
	for job in $JOBS_LIST; do
		job=$(echo $job | sed 's/job//' | sed 's/\///g')
		if [ -z "$2" ] || echo $job | grep -q "$2"; then
			echo -n "Get $job config      ... "
			if curl "${JENKENS_SERVER}/job/$job/config.xml" --user "${USER}:${PASSWD}" > ${CUR_TS}/${job}_config.xml 2>/dev/null; then
				echo "Done"
			else
				echo "Failed!"
			fi
		fi
	done
}

cmd="$1"
[ -z "$cmd" ] || shift
[ -n "$cmd" ] || cmd="list"

case "$cmd" in
	list)
		list_jobs $@
		;;

	export)
		export_cfg $@
		;;

	*)
		Usage
		;;
esac
