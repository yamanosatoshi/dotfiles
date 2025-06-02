#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

FILES=(.vimrc .vim .tmux.conf .gvimrc)

backup_file() {
  local target="$1"
  local path="$HOME/$target"
  if [ -e "$path" ] || [ -L "$path" ]; then
    local backup="${path}.backup.$(date +%s)"
    echo "Backing up $path to $backup"
    mv "$path" "$backup"
  fi
}

create_link() {
  local target="$1"
  ln -sfn "$DOTFILES_DIR/$target" "$HOME/$target"
  echo "Linked $target"
}

for f in "${FILES[@]}"; do
  backup_file "$f"
  create_link "$f"
done

echo "Dotfiles installation complete."
