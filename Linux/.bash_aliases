alias startx='sudo service lightdm start'
alias ls='ls --color'
alias cls='clear'
alias l.='ls -d .*'
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
		pushd "$1" >/dev/null;
	fi
	dirs -v
}

function svn() {
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

