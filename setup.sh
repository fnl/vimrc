#!/bin/sh
dir=`dirname $0`
ln -s $dir/bashrc ~/.bash_profile
ln -s $dir/gvimrc ~/.gvimrc
ln -s $dir/inputrc ~/.inputrc
ln -s $dir/jshintrc ~/.jshintrc
ln -s $dir/screenrc ~/.screenrc
ln -s $dir/vimrc ~/.vimrc
touch ~/.bash_environment
touch ~/.bash_aliases
cd $dir
./update_bundles.rb
cd -
