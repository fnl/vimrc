#!/bin/sh
dir=`dirname $0`

# vim Plug
mkdir -p $dir/autoload
curl -fLo $dir/autoload/plug.vim \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# configuration files
ln -s $dir/bashrc ~/.bash_profile
ln -s $dir/gvimrc ~/.gvimrc
ln -s $dir/inputrc ~/.inputrc
ln -s $dir/jshintrc ~/.jshintrc
ln -s $dir/octaverc ~/.octaverc
ln -s $dir/Rprofile ~/.Rprofile
ln -s $dir/screenrc ~/.screenrc
ln -s $dir/vimrc ~/.vimrc
ln -s $dir/distributionrc ~/.distributionrc

# scripts and binaries
mkdir -p ~/bin
ln -s $dir/bin/* ~/bin/
ln -s $dir/distribution/distribution ~/bin/
ln -s $dir/distribution/distribution ~/bin/barchart
ln -s $dir/z/z.sh ~/bin/z
mkdir -p ~/man/man.1
ln -s $dir/z/z.1 ~/man/man.1/

# individual environment
touch ~/.bash_environment
touch ~/.bash_aliases
