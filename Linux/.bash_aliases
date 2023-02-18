alias startx='sudo service lightdm start'
alias du='du --max-depth 1 -ahx'
alias ls='ls --color'
alias l.='ls -d .*'
alias ll='ls -alF --time-style=long-iso'
alias lh='ll -h'
alias cls='clear'
alias vim='vim -p'
alias upcs='~/bin/updatecs.sh ../lib ../vsysLib ../svn_externals'
alias recs='cscope -kb -i files.cs.txt; ctags -L files.cs.txt --c++-kinds=+p --fields=+iaS --extra=+q;'
alias svn.hist='~/bin/history_of_file.sh'
alias svn.status='~/bin/svn.status.sh'
alias svn.ext='svn pg svn:externals '
alias svn.ignore='svn update --set-depth exclude '
alias dirs='dirs -v'
alias 0='dirs'
for i in `seq 9`; do
	alias $i="pushd +$i >/dev/null && dirs"
done
alias gitdiff='git difftool --extcmd ~/bin/gitdiff.sh -y'
alias gitver='git rev-parse HEAD'
alias grep='grep --exclude "*.svn*" --exclude "*CVS*" --exclude "*.git*" --exclude "*.o" --exclude "*.P"  --color=auto'
alias tar='tar --exclude "*.svn*" --exclude "*.git*" --exclude "*.o" --exclude "*.obj" --exclude "*.P" --exclude "*.ciu"' 
#alias bz2='tar --exclude "*.svn*" --exclude "*.git*" --exclude "*.o" --exclude "*.obj" --exclude "*.P" --exclude "*.d" --exclude "*.img" --exclude "*.ciu"  --exclude "*rootfs*" --exclude "*.bit" --exclude "*.bin" --exclude "*.a" --exclude "*.so" --exclude "*.so.*" --exclude "*tags" --exclude "*cscope.out" --exclude "*.sqsh"'
alias rsync='rsync -av --exclude "*.svn*" --exclude "*.git*" --exclude "*CVS*" --exclude "*.o" --exclude "*.P"'
alias ttys0='screen -x ttys0 || screen -S ttys0 /dev/ttyS0 115200'
alias sl='screen -ls'
alias sx='screen -x'
#alias escp='sshpass -p evertz scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null '
alias ftpput='ftp-upload -u root --password evertz -v -h '
alias sqshll='unsquashfs -ll'
alias smb='smbclient \\\\superstore\\products'
alias wget='wget --no-check-certificate'

dtbdiff() { vimdiff <(dtc -I dtb -O dts $1) <(dtc -I dtb -O dts $2); }
dtv()     { vim <(dtc -I dtb -O dts $1); }


bz2() {
	command tar                   \
		--exclude 'g*.svn*'       \
		--exclude '*.git*'        \
		--exclude '*.o'           \
		--exclude '*.o.cmd'       \
		--exclude '*.obj'         \
		--exclude '*.ko'          \
		--exclude '*.P'           \
		--exclude '*.d'           \
		--exclude '*.img'         \
		--exclude '*.ciu'         \
		--exclude '*rootfs*'      \
		--exclude '*.bit'         \
		--exclude '*.bin'         \
		--exclude '*.a'           \
		--exclude '*.so'          \
		--exclude '*.so.*'        \
		--exclude '*tags'         \
		--exclude '*cscope.out'   \
		--exclude '*.sqsh'        \
		"$@"
}

make_list_targets() {
	make -pRrq "$@" : 2>/dev/null | \
		awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
		sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
}

ssh2() { sshpass -p evertz ssh -2 root@$1 -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null; }
uxp()  { sshpass -p 'TET*/Xxp6`' ssh -2 root@$1 -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null; }

autoscp() {
	local FIFO="$RANDOM"
	while [ -p "/tmp/.empty.${FIFO}.in" ]; do FIFO=$(($FIFO+1)); done
	local FIFO_IN="/tmp/.empty.${FIFO}.in"
	local FIFO_OUT="/tmp/.empty.${FIFO}.out"
	local FIFO_PID="/tmp/.empty.${FIFO}.pid"
	[ -z "$1" ] && echo "password?" && return 1
	local PASSWD="$1"; shift

	trap '[ -f ${FIFO_PID} ] && empty -k $(cat ${FIFO_PID});exit 1;' SIGTERM SIGINT EXIT
	empty -i $FIFO_IN  -o $FIFO_OUT -p ${FIFO_PID} -f scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $@
	empty -i $FIFO_OUT -o $FIFO_IN  -w assword: "$PASSWD\n"

	while [ -p $FIFO_OUT ]; do
		empty -r -i $FIFO_OUT
	done
	trap - SIGTERM SIGINT EXIT
}

escp() { (autoscp 'evertz' $@) }
uscp() { (autoscp 'TET*/Xxp6`' $@) }




zup() {
	[ ! -f "$1" ] && echo "f/w is required!" && return
	[   -z "$2" ] && echo "board IP is required!" && return
	local FW="$1"
	shift
	local NFW='zynq_evertz.img'
	echo "$FW" | grep -q 'trxs_10g' && NFW='trxs_10g.img'

	local IPCNT=$#
	local II=1
	local PIDS=''
	for ip in "$@"; do 
		if ping "$ip" -c 1 -w 1 >/dev/null 2>&1; then
			if [ $II -lt $IPCNT ]; then
				sshpass -p evertz scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null "$FW" root@${ip}:/media/mmcblk0p1/$NFW &
				PIDS="$PIDS $!"
			else
				(autoscp 'evertz' """$FW""" "root@$ip:/media/mmcblk0p1/$NFW")
			fi
		else
			echo "target:$ip not reachable"
		fi
		II=$(($II+1))
	done
	local PID
	for PID in $PIDS; do wait $PID; done
}
pd () {
	if [ -z "$1" ]; then
		popd >/dev/null;
	else
		[ ! -d "$1" ] && return -1
		local dirs_i=0
		for d in $(command dirs -l); do
			[ "$(readlink -f $1)" == "$(readlink -f $d)" ] && pushd +$dirs_i >/dev/null 2>&1 && dirs_i=-1 && break
			let dirs_i=$dirs_i+1
		done
		[ -1 -ne $dirs_i ] && pushd "$1" >/dev/null 2>&1
	fi
	dirs -v
}

svn_pre_commit() {
	[ "$SKIP_SVN_PRECOMMIT" != "1" ]  || return 0

	local svn_pre_commit_dirs_files_cnt=0
	local arg
	for arg in "$@"; do
		case "$arg" in
			-*)
				;;

			*)
				if [ -d "$arg" -o -f "$arg" ]; then
					svn status "$arg" | egrep '(^M|^A)' | egrep '(\.h$|\.hpp$|\.cpp$|\.c$|\.cc$)' | grep -v 'fpga_registers.h' | awk '{print $2;}' | xargs ~/bin/astyle.sh
					svn diff "$arg"
					let svn_pre_commit_dirs_files_cnt=$svn_pre_commit_dirs_files_cnt+1
				fi
				;;
		esac
	done
	if [ $svn_pre_commit_dirs_files_cnt -eq 0 ]; then
		svn status "$arg" | egrep '(^M|^A)' | egrep '(\.h$|\.hpp$|\.cpp$|\.c$|\.cc$)' | grep -v 'fpga_registers.h' | awk '{print $2;}' | xargs ~/bin/astyle.sh
		svn diff
	fi
	return 0
}

svn() {
case $1 in
	st | status )
		shift 1
		command svn status "$@" | sort -k 2
		;;
	patch )
		shift 1
		command svn status "$@" | grep -v '?' | sed 's/.* //' | sort | while read A; do [ -d "$A" ] || command svn diff --diff-cmd diff "$A"; done
		;;
	ci | commit )
		shift 1
		svn_pre_commit "$@" && command svn commit "$@"
		;;
	sci )
		shift 1
		command svn commit "$@"
		;;
	up )
		shift
		command svn up --non-interactive "$@"
		;;
	si | shortinfo )
		shift 1
		svn info --show-item url --no-newline "$@";echo -n '@';svn info --show-item revision "$@";
		;;
	* )
		command svn "$@"
		;;
esac
}

git_pre_commit() {
	[ "$SKIP_GIT_PRECOMMIT" != "1" ]  || return 0

	local svn_pre_commit_dirs_files_cnt=0
	local arg
	for arg in "$@"; do
		case "$arg" in
			-*)
				;;

			*)
				if [ -d "$arg" -o -f "$arg" ]; then
					git status "$arg" | egrep '(^M|^A)' | egrep '(\.h$|\.hpp$|\.cpp$|\.c$|\.cc$)' | grep -v 'fpga_registers.h' | awk '{print $2;}' | xargs ~/bin/astyle.sh
					git difftool --extcmd ~/bin/gitdiff.sh -y "$arg"
					let svn_pre_commit_dirs_files_cnt=$svn_pre_commit_dirs_files_cnt+1
				fi
				;;
		esac
	done
	if [ $svn_pre_commit_dirs_files_cnt -eq 0 ]; then
		git status "$arg" | egrep '(^M|^A)' | egrep '(\.h$|\.hpp$|\.cpp$|\.c$|\.cc$)' | grep -v 'fpga_registers.h' | awk '{print $2;}' | xargs ~/bin/astyle.sh
		git difftool --extcmd ~/bin/gitdiff.sh -y --cached
	fi
	return 0
}

git() {
case $1 in
	pull )
		shift 1
		command git pull --rebase "$@"
		;;
	ci | commit )
		shift 1
		git_pre_commit "$@" && command git commit "$@"
		;;
	sci )
		shift 1
		command git commit "$@"
		;;
	* )
		command git "$@"
		;;
esac
}




export SVN_MERGE=~/bin/svn-merge.sh
export EDITOR=vim

