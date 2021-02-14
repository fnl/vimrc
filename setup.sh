#!/bin/sh

dir=~/.vim
WORKSPACE=

echo "dir=$dir"

# get and install distribution
git submodule update --init --recursive

# vim backup and tmp files
mkdir $dir/backup
mkdir $dir/tmp

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# tmux setup
# mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# configuration files
echo "linking configuration files from $dir/* to ~/.\\1"
ln -s $dir/Rprofile ~/.Rprofile
ln -s $dir/zshrc ~/.zshrc
ln -s $dir/p10k.zsh ~/.p10k.zsh
ln -s $dir/bashrc ~/.bash_profile
ln -s $dir/bash_completion ~/.bash_completion
ln -s $dir/bash_completion.d ~/.bash_completion.d
ln -s $dir/condarc ~/.condarc
ln -s $dir/distributionrc ~/.distributionrc
ln -s $dir/gitconfig ~/.gitconfig
ln -s $dir/gvimrc ~/.gvimrc
ln -s $dir/inputrc ~/.inputrc
ln -s $dir/jshintrc ~/.jshintrc
ln -s $dir/screenrc ~/.screenrc
ln -s $dir/tmux.conf ~/.tmux.conf
ln -s $dir/vimrc ~/.vimrc
cp $dir/signature ~/.plan

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
# optional: install Nerd Fonts: https://www.nerdfonts.com/font-downloads

echo "linking man pages from $dir to ~/$WORKSPACE/man"
mkdir -p ~/$WORKSPACE/man/man1
ln -s $dir/z/z.1 ~/$WORKSPACE/man/man1/
ln -s $dir/aria2/share/man/man1/aria2c.1 ~/$WORKSPACE/man/man1/

# individual environment
echo "touching local bash configuration files"
touch ~/.bash_environment
touch ~/.bash_aliases
