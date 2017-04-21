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

	# discard until main-panel is seen.
	HTML_RET=`$CURL "${JENKENS_URL}" -X POST 2>/dev/null | sed -n '/<div id="main-panel">/{p; :loop n; p; b loop}'`

	# keep only matched job/JOB-NAME/
	echo $HTML_RET | grep -oh 'job/[^/]*/' | sort -u
}

export_cfg () {
	CUR_TS="$(date +'%Y-%m-%d_%H-%M-%S')"
	mkdir -p $CUR_TS

	JOBS_LIST="$(list_jobs $1)"
	for job in $JOBS_LIST; do
		# strip job/ to get the accurate name.
		job=$(echo $job | sed 's/job//' | sed 's/\///g')

		# match filter if it has.
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

	# keep only the first /job/JOB-NAME/ (delet the second /job/JOB-NAME/ April.)
	HTML_RET=`$CURL "${JENKENS_URL}" 2>/dev/null | grep -oh "/job/$job/[0-9]\+/\">[^/]\+/a>" | sed '0~2d'`

	# strip the href string
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
