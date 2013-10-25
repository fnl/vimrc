#!/bin/sh
ln -s ~/.vim/bashrc ~/.bash_profile
ln -s ~/.vim/gvimrc ~/.gvimrc
ln -s ~/.vim/inputrc ~/.inputrc
ln -s ~/.vim/jshintrc ~/.jshintrc
ln -s ~/.vim/screenrc ~/.screenrc
ln -s ~/.vim/vimrc ~/.vimrc
touch ~/.bash_environment
touch ~/.bash_aliases
cd ~/.vim
./update_bundles.rb
cd -
