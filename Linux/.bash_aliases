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
alias dirs='dirs -v'
alias 0='dirs'
for i in `seq 9`; do
	alias $i="pushd +$i >/dev/null && dirs"
done
alias gitdiff='git difftool -t vimdiff -y'
alias grep='grep --exclude "*.svn*" --exclude "*CVS*" --exclude "*.git*" --exclude "*.o" --exclude "*.P"  --color=auto'
alias tar='tar --exclude "*.svn*" --exclude "*.git*" --exclude "*.o" --exclude "*.P" --exclude "*.ciu" --exclude "*.img"'
alias rsync='rsync -av --exclude "*.svn*" --exclude "*.git*" --exclude "*CVS*" --exclude "*.o" --exclude "*.P"'

pd () {
	if [ -z "$1" ]; then
		popd >/dev/null;
	else
		[ ! -d "$1" ] && return -1
		dirs_i=0
		for d in $(command dirs -l); do
			[ "$(realpath $1)" == "$(realpath $d)" ] && pushd +$dirs_i >/dev/null 2>&1 && dirs_i=-1 && break
			let dirs_i=$dirs_i+1
		done
		[ -1 -ne $dirs_i ] && pushd "$1" >/dev/null 2>&1
		unset dirs_i
	fi
	dirs -v
}

svn() {
case $1 in
	st | status )
		shift 1
		command svn status "$@" | sort -k 2
		;;
	patch )
		shift 1
		command svn status "$@" | grep -v '?' | sed 's/.* //' | sort | while read A; do command svn diff --diff-cmd diff "$A"; done
		;;
	* )
		command svn "$@"
		;;
esac
}


export SVN_MERGE=~/.bin/svn-merge.sh

