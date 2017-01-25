# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history and don't overwrite previous settings
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace (mc)
#HISTCONTROL=ignoreboth

# set the size of the history buffer and file
export HISTFILESIZE=1000
export HISTSIZE=9999

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

# fix cd spelling mistakes
shopt -s cdspell

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
# echo $TERM
case "$TERM" in
  xterm-color) color_prompt=yes;;
  xterm-256color) color_prompt=yes;;
  screen-256color) color_prompt=yes;;
	xterm) if [ "$COLORTERM" == "gnome-terminal" ]
		then color_prompt=yes;
		else echo colorless xterm detected;
		fi;;
	*) echo are you really running a colorless $TERM or a gnome-terminal?;;
esac

# uncomment for a forced colored prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ] && [ "$color_prompt" != "yes" ]
then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null
  then color_prompt=yes;
		echo forced color term despite TERM=\"$TERM\" setting;
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
  else color_prompt=
  fi
fi

# configure the prompt (color?)
black=30
red=31
green=32
yellow=33
blue=34
magenta=35
cyan=36
white=37
hostname=`hostname -s`
if [ $hostname = catalytics ]
then color=$magenta
elif [ $hostname = cerberus ]
then color=$cyan
else color=$blue
fi
if [ "$color_prompt" = yes ]
#then PS1='\[\033[01;37m\]\!\[\033[00m\] \[\033[01;33m\]\u\[\033[00m\]@\[\033[01;'$color'm\]\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\] \$ '
then PS1=' \[\033[01;33m\]\u\[\033[00m\]@\[\033[01;'$color'm\]\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\] \$ '
else PS1=' \u@\h:\w \$ '
#else PS1='\! \u@\h:\w \$ '
fi
unset hostname black red green yellow blue magenta cyan white
unset color color_prompt force_color_prompt

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
  alias grepc="grep --color"
  if [ -x /usr/local/bin/gls ] || [ "`uname`" != "Darwin" ]
  then lscolor="--color"
  else lscolor="-G"
  fi
elif [ "`uname`" == "Darwin" ]
then lscolor="-G"
else lscolor=
fi
unset dircolors

# enable programmable completion features
if [ -f /etc/eash_completion ] && ! shopt -oq posix
then . /etc/bash_completion
elif [ -f /usr/local/etc/bash_completion ] && ! shopt -oq posix
then . /usr/local/etc/bash_completion
else echo "bash completion disabled"
fi

# use vim as editor
export EDITOR=vim

# use US locale and UTF-8 encoding by default
export LC_ALL="en_US.UTF-8"

# a simple terminal calculator
calc() { awk "BEGIN{ print $* }"; }

# extract the longest line from a file
longestline() { awk '{ print length, $0}' "$1" | sort -nr | head -1; }

# show line number X in file Y
showline() { awk 'NR == '$1' { print; exit }' "$2"; }

# show the column number of each column in a TSV file with a title row
numcols() { head -1 "$@" | tr '\t' '\n' | nl; }

# show the column number of each column in a CSV file with a title row
numcsvcols() { head -1 "$@" | tr ',' '\n' | nl; }

# count and rank the unqiue lines in a file
uniqcount() { sort "$@" | uniq -c | sort -rn | sed 's/^ *//' | sed 's/ /	/'; }

# elasticsearch commands (with echo to ensure a newline is printed)
esdelete() { local url=$1; shift; curl -XDELETE "$ELASTICSEARCH/$url" "$@"; echo; }
esdeleteh() { local url=$1; shift; curl -i -XDELETE "$ELASTICSEARCH/$url" "$@"; echo; }
esget() { local url=$1; shift; curl "$ELASTICSEARCH/$url" "$@"; echo; }
eshead() { local url=$1; shift; curl -I "$ELASTICSEARCH/$url"; echo $@; }
espost() { local url=$1; shift; curl -XPOST "$ELASTICSEARCH/$url" "$@"; echo; }
esposth() { local url=$1; shift; curl -i -XPOST "$ELASTICSEARCH/$url" "$@"; echo; }
esput() { local url=$1; shift; curl -XPUT "$ELASTICSEARCH/$url" "$@"; echo; }
esputh() { local url=$1; shift; curl -i -XPUT "$ELASTICSEARCH/$url" "$@"; echo; }

# count and rank the unique fields from a cut
cutcount() { cut "$@" | sort | uniq -c | sort -rn | sed 's/^ *//' | sed 's/ /	/'; }

# convert between DOS line-breaks and UNIX newlines
dos2unix() { awk '{ sub(/\r$/, ""); print }' "$@"; }
unix2dos() { awk '{ sub(/$/, "\r"); print }' "$@"; }

# remove Unicode BOMs from files
removeBOM() { awk '{ if (NR==1) sub(/^\xef\xbb\xbf/, ""); print }' "$@"; }

# show the ten most used commands
topten() { history | awk '{ a[$2]++ }END{ for (i in a) {print a[i] " " i} }' | sort -rn | head; }

# sort the ps output by process RSS memmory usage
psmem() { ps aux | sort -nk +6; }

# determine the external IP
myip() { dig +short myip.opendns.com @resolver1.opendns.com; }

# get a list of all TODO/FIXME tasks in the current project dir
tasks() { grep --exclude-dir=.git -rEI "TODO|FIXME" . 2>/dev/null; }

# diff two unsorted files, sorting them in memory
diff-sorted() { one="$1"; two="$2"; shift 2; diff $* <(sort "$one") <(sort "$two"); }

# remove the tags in XML documents
untag() { sed -e 's/<[^>]*>//g' "$@"; }

# show the last modified files
lt() { ls -ltrha "$@" | tail; }

# show the largest files
lS() { ls -lSrha "$@" | tail; }

# grep the ps shortcut
psgrep() { ps aux | tee >(head -1>&2) | grep -v " grep $@" | grep "$@" -i --color=auto; }

# cd to last path after exiting ranger
function ranger-cd {
	tempfile='/tmp/rangerdir'
	ranger --choosedir="$tempfile" "${@:-$(pwd)}"
	test -f "$tempfile" &&
	if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
		cd -- "$(cat "$tempfile")"
	fi
	rm -f -- "$tempfile"
}

# ls convenience: l, ll and la
# use GNU ls in preference over "default" ls (Mac OSX)
[ -x /usr/local/bin/gls ] && alias l="gls $lscolor " || alias l="ls $lscolor"
alias ll='ls -lh'
alias la='l -A'
unset lscolor

# global aliases
#use GNU ls in preference over "default" ls (Mac OSX)
alias ..='cd ..'
alias ...='cd ../..'
alias vi='vim' # always use vim
alias curl-json='curl -H"Content-Type: application/json;charset=utf-8"'
alias curl-post='curl -X POST'
alias curl-post-json='curl -X POST -H"Content-Type: application/json;charset=utf-8"'

# source local alias definitions
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# source local environment variables
[ -f ~/.bash_environment ] && . ~/.bash_environment

# source local shell settings
[ -f ~/.bash_local ] && . ~/.bash_local

# set up z - jump around
[ -f ~/.vim/z/z.sh ] && . ~/.vim/z/z.sh

#test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
