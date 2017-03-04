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
alias gitdiff='git difftool -y'
alias grep='grep --exclude "*.svn*" --exclude "*CVS*" --exlucde "*.git*"  --color=auto'
alias tar='tar --exclude "*.svn*" --exclude "*.git*"'

pd () {
	if [ -z "$1" ]; then
		popd >/dev/null;
	else
		pushd "$1" >/dev/null;
	fi
	dirs -v
}

