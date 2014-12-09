#!/bin/sh
dir=`dirname $0`
echo ".vim content directory: $dir"

# vim Plug
echo "setting up Plug autoload"
mkdir -p $dir/autoload
curl -fLo $dir/autoload/plug.vim \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# configuration files
echo "linking configuration files from $dir/* to ~/.\\1"
mkdir ~/.i3
ln -s $dir/i3config ~/.i3/config
ln -s $dir/i3status.conf ~/.i3status.conf
ln -s $dir/bashrc ~/.bash_profile
ln -s $dir/gvimrc ~/.gvimrc
ln -s $dir/inputrc ~/.inputrc
ln -s $dir/jshintrc ~/.jshintrc
ln -s $dir/muttrc ~/.muttrc
ln -s $dir/octaverc ~/.octaverc
ln -s $dir/Rprofile ~/.Rprofile
ln -s $dir/screenrc ~/.screenrc
ln -s $dir/vimrc ~/.vimrc
ln -s $dir/distributionrc ~/.distributionrc
cp -s $dir/signature ~/.plan

# scripts and binaries
echo "linking scripts and binaries from $dir to ~/bin"
mkdir -p ~/bin
ln -s $dir/bin/* ~/bin/
ln -s $dir/distribution/distribution ~/bin/
ln -s $dir/distribution/distribution ~/bin/barchart
ln -s $dir/z/z.sh ~/bin/z

echo "linking man pages from $dir to ~/man"
mkdir -p ~/man/man.1
ln -s $dir/z/z.1 ~/man/man.1/

# individual environment
echo "touching local bash configuration files"
touch ~/.bash_environment
touch ~/.bash_aliases
