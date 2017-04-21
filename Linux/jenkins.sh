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
CURL='curl --user '"${USER}:${PASSWD}"

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
	echo 'jenkins builds <Job>'
	echo 'jenkins delb   <Job> <build>'
	echo 'jenkins delb   <Job> <from-build> <to-build>'
}

list_jobs () {
	if [ -n "$1" ]; then
		JENKENS_URL="${JENKENS_SERVER}/view/$1/"
	else
		JENKENS_URL="${JENKENS_SERVER}"
	fi

	HTML_RET=`$CURL "${JENKENS_URL}" -X POST 2>/dev/null | sed -n '/<div id="main-panel">/{p; :loop n; p; b loop}'`
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
			if $CURL "${JENKENS_SERVER}/job/$job/config.xml"  > ${CUR_TS}/${job}_config.xml 2>/dev/null; then
				echo "Done"
			else
				echo "Failed!"
			fi
		fi
	done
}

list_builds () {
	job="$1"
	[ -z "$job" ] && Usage && return

	JENKENS_URL="${JENKENS_SERVER}/job/$job/"
	HTML_RET=`$CURL "${JENKENS_URL}" 2>/dev/null | grep -oh "/job/$job/[0-9]\+/\">[^/]\+/a>" | sed '0~2d'`
	echo "$HTML_RET" | sed 's/<\/a>//g' | sed 's/">/\t/g' | sort -u
}

delete_build () {
	job="$1"
	build_from="$2"
	[ -z "$build_from" ] && Usage && return

	if [ -z "$3" ]; then
		JENKENS_URL="${JENKENS_SERVER}/job/$job/$build_from/doDelete"
		echo $JENKENS_URL
		$CURL ${JENKENS_URL} -X POST 1>/dev/null 2>&1
	else
		for b in $(seq $build_from $3); do
			JENKENS_URL="${JENKENS_SERVER}/job/$job/$b/doDelete"
			echo $JENKENS_URL
			$CURL ${JENKENS_URL} -X POST 1>/dev/null 2>&1
		done
	fi
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

	builds)
		list_builds $@
		;;

	delb)
		delete_build $@
		;;

	dumpbuilds)
		for job in $(list_jobs $1); do
			job=$(echo $job | sed 's/job\///' | sed 's/\///g')
			echo "==>Dump $job buillds..."
			list_builds $job
			echo ""
		done
		;;

	*)
		Usage
		;;
esac
