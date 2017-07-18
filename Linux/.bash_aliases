alias startx='sudo service lightdm start'
alias ls='ls --color'
alias l.='ls -d .*'
alias ll='ls -alF --time-style=long-iso'
alias cls='clear'
alias vim='vim -p'
alias upcs='~/.bin/updatecs.sh'
alias svn.hist='~/.bin/history_of_file.sh'
alias svn.status='~/.bin/svn.status.sh'
alias svn.ext='svn pg svn:externals '
alias svn.ignore='svn update --set-depth exclude '
alias dirs='dirs -v'
alias 0='dirs'
for i in `seq 9`; do
	alias $i="pushd +$i >/dev/null && dirs"
done
alias gitdiff='git difftool -t vimdiff -y'
alias grep='grep --exclude "*.svn*" --exclude "*CVS*" --exclude "*.git*" --exclude "*.o" --exclude "*.P"  --color=auto'
alias tar='tar --exclude "*.svn*" --exclude "*.git*" --exclude "*.o" --exclude "*.P" --exclude "*.ciu" --exclude "*.img"'
alias rsync='rsync -av --exclude "*.svn*" --exclude "*.git*" --exclude "*CVS*" --exclude "*.o" --exclude "*.P"'
alias ttys0='screen -x ttys0 || screen -S ttys0 /dev/ttyS0 115200'
alias sl='screen -ls'
alias sx='screen -x'

pd () {
	if [ -z "$1" ]; then
		popd >/dev/null;
	else
		[ ! -d "$1" ] && return -1
		dirs_i=0
		for d in $(command dirs -l); do
			[ "$(readlink -f $1)" == "$(readlink -f $d)" ] && pushd +$dirs_i >/dev/null 2>&1 && dirs_i=-1 && break
			let dirs_i=$dirs_i+1
		done
		[ -1 -ne $dirs_i ] && pushd "$1" >/dev/null 2>&1
		unset dirs_i
	fi
	dirs -v
}

pre_commit() {
	[ "$SKIP_SVN_PRECOMMIT" != "1" ]  || return 0

	svn_pre_commit_dirs_files_cnt=0
	for arg in "$@"; do
		case "$arg" in
			-*)
				;;

			*)
				if [ -d "$arg" ]; then
					svn status "$arg" | egrep '(^M|^A)' | egrep '(.h$|.hpp$|.cpp$|.c$)' | awk '{print $2;}' | xargs astyle
					svn diff "$arg"
					let svn_pre_commit_dirs_files_cnt=$svn_pre_commit_dirs_files_cnt+1
				elif [ -f "$arg" ]; then
					astyle "$arg"
					svn diff "$arg"
					let svn_pre_commit_dirs_files_cnt=$svn_pre_commit_dirs_files_cnt+1
				fi
				;;
		esac
	done
	if [ $svn_pre_commit_dirs_files_cnt -eq 0 ]; then
		svn status "." | egrep '(^M|^A)' | egrep '(.h$|.hpp$|.cpp$|.c$)' | awk '{print $2;}' | xargs astyle
		svn diff
	fi
	unset svn_pre_commit_dirs_files_cnt
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
	commit )
		shift 1
		pre_commit "$@" && command svn commit "$@"
		;;
	* )
		command svn "$@"
		;;
esac
}


export SVN_MERGE=~/.bin/svn-merge.sh
export EDITOR=vim

