# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history and don't overwrite previous settings
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace (mc)
#HISTCONTROL=ignoreboth

# set the size of the history buffer
HISTSIZE=1000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# save each line of a multi-line command in the same history entry
shopt -s cmdhist

# the name of a directory is executed as if it were the argument to the cd command
[ "`uname`" != "Darwin" ] && shopt -s autocd

# patterns which fail to match filenames during filename expansion result in an expansion error
#shopt -s failglob

# extended pattern matching features
shopt -s extglob

# ** matches all files and zero or more directories and subdirectories;
# if the pattern is followed by a ‘/’, only directories and subdirectories match
[ "`uname`" != "Darwin" ] && shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]
then debian_chroot=$(cat /etc/debian_chroot)
fi

# check for a color terminal to set a color prompt
case "$TERM" in
  xterm-color) color_prompt=yes;;
  xterm-256color) color_prompt=yes;;
esac

# uncomment for a forced colored prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]
then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null
  then color_prompt=yes
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
  else color_prompt=
  fi
fi

# configure the prompt (color?)
if [ "$color_prompt" = yes ]
then PS1='\[\033[01;36m\]\!\[\033[00m\]#\[\033[01;33m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else PS1='\!#\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt

# check for dircolors support of ls
if [ -x /usr/bin/dircolors ]
then dircolors="/usr/bin/dircolors"
elif [ -x /usr/local/bin/gdircolors ]
then dircolors="/usr/local/bin/gdircolors"
else dircolors=
fi

if [ -n "$dircolors" ]
then
  test -f ~/.dircolors && "$($dircolors -b ~/.dircolors)" || eval "$($dircolors -b)"
  alias grep="grep --color"
  if [ -x /usr/local/bin/gls ] || [ "`uname`" != "Darwin" ]
  then lscolor="--color"
  else lscolor="-G"
  fi
else lscolor=
fi
unset dircolors

unset dircolors

# enable programmable completion features
#if [ -f /etc/eash_completion ] && ! shopt -oq posix
#then . /etc/bash_completion
#elif [ -f /usr/local/etc/bash_completion ] && ! shopt -oq posix
#then . /usr/local/etc/bash_completion
#else echo "bash completion disabled"
#fi

# use vim as editor
export EDITOR=vim

# use US locale and UTF-8 encoding by default
export LC_CTYPE="en_US.UTF-8"
export LANG="en_US"

# a simple terminal calculator
calc() { awk "BEGIN{ print $* }"; }

# extract the longest line from a file
longestline() { awk '{ print length, $0}' "$1" | sort -nr | head -1; }

# show line number X in file Y
showline() { awk 'NR == '$1' { print; exit }' "$2"; }

# convert between DOS line-breaks and UNIX newlines
dos2unix() { awk '{ sub(/\r$/, ""); print }' "$@"; }
unix2dos() { awk '{ sub(/$/, "\r"); print }' "$@"; }

# remove Unicode BOMs from files
removeBOM() { awk '{ if (NR==1) sub(/^\xef\xbb\xbf/, ""); print }' "$@"; }

# show the ten most used commands
topten() { history | awk '{ a[$2]++ }END{ for (i in a) {print a[i] " " i} }' | sort -rn | head; }

# diff two unsorted files, sorting them in memory
diff-sorted() { one="$1"; two="$2"; shift 2; diff $* <(sort "$one") <(sort "$two"); }

# source local alias definitions
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# source local environment variables
[ -f ~/.bash_environment ] && . ~/.bash_environment

# source local shell settings
[ -f ~/.bash_local ] && . ~/.bash_local

# global aliases
#use GNU ls in preference over "default" ls (Mac OSX)
alias ..='cd ..'
alias ...='cd ../..'
# use GNU ls in preference over "default" ls (Mac OSX)
[ -x /usr/local/bin/gls ] && alias ls="gls $lscolor" || alias ls="ls $lscolor"
alias l='ls -f --ignore ".*"' # get rid of color
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lhAi'
alias vi='vim' # always use vim
alias curl-json='curl -H"Content-Type: application/json;charset=utf-8"'
alias curl-post='curl -X POST'
alias curl-post-json='curl -X POST -H"Content-Type: application/json;charset=utf-8"'

unset lscolor
