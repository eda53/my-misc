#!/usr/bin/env bash
#
# tmux.sess.sh
# Copyright (C) 2018 eda <eda@evertz.com>
#
# Distributed under terms of the Evertz Proprietary license.
#

# Save and restore the state of tmux sessions and windows.
# TODO: persist and restore the state & position of panes.
set -e

dump() {
  local d=$'\t'
  tmux list-windows -a -F "#S${d}#W${d}#{pane_current_path}"
}

save() {
  local of=~/.tmux-session
  [ -n "$1" ] && of="$1"
  dump >>$of
  #sort -u ~/.tmux-session >> ~/.tmux-session.tmp
  #mv ~/.tmux-session.tmp ~/.tmux-session
}

terminal_size() {
  stty size 2>/dev/null | awk '{ printf "-x%d -y%d", $2, $1 }'
}

session_exists() {
  tmux has-session -t "$1" 2>/dev/null
}

add_window() {
  tmux new-window -d -t "$1:" -n "$2" -c "$3"
}

window_exists() {
  tmux list-windows -t "$1" | grep -q ': '"$2"'-\?*\? '
}

window_id() {
  tmux list-windows -t "$1" | grep ': '"$2"'-\?*\? ' | head -n 1 | cut -f 1 -d ':'
}

new_session() {
  cd "$3" &&
  tmux new-session -d -s "$1" -n "$2" $4
}

restore() {
  tmux start-server
  local count=0
  local dimensions="$(terminal_size)"
  local in=~/.tmux-session
  [ -n "$1" ] && in="$1"

  while IFS=$'\t' read session_name window_name dir script; do
	echo "$session_name" | grep -q "^#" && continue
    if [[ -d "$dir" && $window_name != "log" && $window_name != "man" ]]; then
      if session_exists "$session_name"; then
        if ! window_exists "$session_name" "$window_name"; then
          add_window "$session_name" "$window_name" "$dir"
        fi
      else
        new_session "$session_name" "$window_name" "$dir" "$dimensions"
        count=$(( count + 1 ))
      fi
      if [ -n "$script" ]; then
		local wid=$(window_id "$session_name" "$window_name")
		tmux select-window -t "$session_name:$wid"
        eval tmux send-keys -t "$session_name" $script
      fi
    fi
  done <$in

  echo "restored $count sessions"
}

cmd="$1"
shift
case "$cmd" in
save | restore )
  $cmd "$@"
  ;;
* )
  echo "valid commands: save, restore" >&2
  exit 1
esac

<<NOTUSED
SESSIONNAME="bb"
[ -n "$1" ] && SESSIONNAME="$1"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ]; then
    tmux new-session -s $SESSIONNAME -n script -d
    tmux send-keys -t $SESSIONNAME "~/bin/script" C-m 
fi

tmux attach -t $SESSIONNAME
NOTUSED
