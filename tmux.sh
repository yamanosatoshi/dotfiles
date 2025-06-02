#!/bin/bash

set -e

layout_default() {
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 15
  tmux select-pane -t 1
}

layout_one() {
  tmux split-window -v
  tmux resize-pane -D 15
  tmux select-pane -D
  clear
}

layout_two() {
  tmux split-window -h
  tmux split-window -v
  tmux resize-pane -D 15
  tmux select-pane -t 1
  tmux split-window -v
  tmux select-pane -t 1
  clear
}

layout_three() {
  cd ~/Desktop/python
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 15
  tmux select-pane -t 1
  vi .
  clear
}

usage() {
  echo "Usage: $0 [1|2|3]" >&2
}

command -v tmux >/dev/null 2>&1 || {
  echo "tmux command not found" >&2
  exit 1
}

case "$1" in
  "" ) layout_default ;;
  1 ) layout_one ;;
  2 ) layout_two ;;
  3 ) layout_three ;;
  * ) usage ; exit 1 ;;
esac

