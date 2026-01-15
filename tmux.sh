#!/usr/bin/env bash
set -euo pipefail

SESSION="main"
LAYOUT="${1:-default}"

layout_default() {
  tmux split-window -t "$SESSION":0 -v
  tmux split-window -t "$SESSION":0 -h
  tmux resize-pane  -t "$SESSION":0 -D 15
  tmux select-pane  -t "$SESSION":0.0
}
layout_one() {
  tmux split-window -t "$SESSION":0 -v
  tmux resize-pane  -t "$SESSION":0 -D 15
  tmux select-pane  -t "$SESSION":0.1
  tmux send-keys    -t "$SESSION":0.1 "clear" C-m
}
layout_two() {
  tmux split-window -t "$SESSION":0 -h
  tmux split-window -t "$SESSION":0.1 -v
  tmux resize-pane  -t "$SESSION":0 -D 15
  tmux split-window -t "$SESSION":0.0 -v
  tmux select-pane  -t "$SESSION":0.0
  tmux send-keys    -t "$SESSION":0.0 "clear" C-m
}
layout_three() {
  tmux send-keys -t "$SESSION":0.0 "cd ~/Desktop/python" C-m
  tmux split-window -t "$SESSION":0 -v
  tmux split-window -t "$SESSION":0 -h
  tmux resize-pane  -t "$SESSION":0 -D 15
  tmux select-pane  -t "$SESSION":0.0
  tmux send-keys    -t "$SESSION":0.0 "vi ." C-m
}

# tmux が無ければ終了
command -v tmux >/dev/null 2>&1 || { echo "tmux command not found" >&2; exit 1; }

# セッションが無ければ作る
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux new-session -d -s "$SESSION" -n main
  case "$LAYOUT" in
    default|"") layout_default ;;
    1) layout_one ;;
    2) layout_two ;;
    3) layout_three ;;
    *) echo "Usage: $0 [1|2|3]" >&2; exit 1 ;;
  esac
fi

# tmux内なら切替、外ならattach
if [[ -n "${TMUX:-}" ]]; then
  tmux switch-client -t "$SESSION"
else
  tmux attach -t "$SESSION"
fi
