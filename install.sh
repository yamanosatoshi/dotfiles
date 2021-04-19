#!/bin/sh

#erase old setting
rm -rf ~/.vimrc
rm -rf ~/.vim/
rm -rf ~/.tmux.conf

#link new setting
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.vim ~/.vim
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

#install basic plubins
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
git clone git://github.com/vim-jp/vital.vim ~/.vim/bundle/vital.vim
