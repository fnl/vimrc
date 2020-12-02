#!/bin/sh

dir=~/.vim
WORKSPACE=

echo "dir=$dir"

# get and install distribution
git submodule update --init --recursive

# vim Plug
echo "setting up Plug autoload"
mkdir -p $dir/autoload
curl -fLo $dir/autoload/plug.vim \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# vim backup and tmp files
mkdir $dir/backup
mkdir $dir/tmp

# configuration files
echo "linking configuration files from $dir/* to ~/.\\1"
#mkdir ~/.i3
#ln -s $dir/i3config ~/.i3/config
#ln -s $dir/i3status.conf ~/.i3status.conf
ln -s $dir/Rprofile ~/.Rprofile
ln -s $dir/bashrc ~/.bash_profile
ln -s $dir/bash_completion ~/.bash_completion
ln -s $dir/bash_completion.d ~/.bash_completion.d
ln -s $dir/condarc ~/.condarc
ln -s $dir/distributionrc ~/.distributionrc
ln -s $dir/gitconfig ~/.gitconfig
ln -s $dir/gvimrc ~/.gvimrc
ln -s $dir/inputrc ~/.inputrc
ln -s $dir/jshintrc ~/.jshintrc
#ln -s $dir/octaverc ~/.octaverc
ln -s $dir/screenrc ~/.screenrc
ln -s $dir/vimrc ~/.vimrc
cp $dir/signature ~/.plan

# tmux setup
ln -s $dir/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# scripts and binaries
echo "linking scripts and binaries from $dir to ~/$WORKSPACE/bin"
mkdir -p ~/$WORKSPACE/bin
ln -s $dir/bin/* ~/$WORKSPACE/bin/
ln -s $dir/distribution/distribution ~/$WORKSPACE/bin/
ln -s $dir/distribution/distribution ~/$WORKSPACE/bin/barchart
ln -s $dir/z/z.sh ~/$WORKSPACE/bin/z
ln -s $dir/aria2/bin/aria2c ~/$WORKSPACE/bin/aria2c

# install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

echo "linking man pages from $dir to ~/$WORKSPACE/man"
mkdir -p ~/$WORKSPACE/man/man1
ln -s $dir/z/z.1 ~/$WORKSPACE/man/man1/
ln -s $dir/aria2/share/man/man1/aria2c.1 ~/$WORKSPACE/man/man1/

# individual environment
echo "touching local bash configuration files"
touch ~/.bash_environment
touch ~/.bash_aliases
