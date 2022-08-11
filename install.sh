#!/bin/sh

#erase old setting
rm -rf ~/.vimrc
rm -rf ~/.vim/
rm -rf ~/.tmux.conf

#link new setting
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.vim ~/.vim
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
