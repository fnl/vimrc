setopt autocd extendedglob nomatch

# history settings
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
# bash-like history options
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY

# expanded word-separation chars for file and URL paths
WORDCHARS=${WORDCHARS//[&=\/#@:]}
# key binding Emacs style
bindkey -e

# initialize zsh-style autocompletion
zstyle :compinstall filename '/home/fleitner/.zshrc'
autoload -Uz compinit && compinit

# completion color settings
if [[ -x "dircolors" ]]
then
  eval `dircolors`
elif [[ -x "gdircolors" ]]
then
  eval `gdircolors`
fi

# completion settings
# unset the '//' pattern to mean nothing
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# make completion feel bash-like
setopt BASH_AUTO_LIST
setopt NO_AUTO_MENU
setopt NO_ALWAYS_LAST_PROMPT

# prompt settings
# colors creates associative arrays $fg and $bg with escaped color codes
autoload -U colors zsh/terminfo
# set up colors if the terminal can display at least 8 colors
if [[ "$terminfo[colors]" -ge 8 ]]
then
  colors
  PROMPT="%{$fg[green]%}%(?..[%?] )%(1L.%L.)%{$reset_color%}#%{$fg[green]%}%h%{$reset_color%}<%{$fg[yellow]%}%l%{$reset_color%}>%{$fg[red]%}%m%{$reset_color%}:%{$fg[blue]%}%(4~,.../,)%3~%{$reset_color%}%(!.#.$) "
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'
else
  PROMPT="%(?..[%?] )%(1L.%L.)#%h<%l>%m:%(4~,.../,)%3~%(!.#.$) "
fi

# terminal title to "user@host: path"
function precmd () { print -Pn "\e]0;%n@%m: %d\a" }

# file-type commands
alias -s c=vim
alias -s C=vim
alias -s cpp=vim
alias -s h=vim
alias -s H=vim
alias -s hpp=vim
alias -s java=vim
alias -s pl=vim
alias -s py=vim
alias -s rb=vim
alias -s tex=vim

# read in default aliases
if [[ -f ~/.aliases ]]
then
  . ~/.aliases
fi

# read in local environment setup
if [[ -f ~/.environment ]]
then
  . ~/.environment
fi

# example function: ROT13 encryption
rot13 () {
  tr "[!-O][P-~]" "[P-~][!-O]"
}

function encrypt {
  if (( $# == 0 ))
  then
    # no content given, use readline
    while read line
    do echo $line | rot13
    done
    # process the last line if it is not empty, too
    if [[ "x$line" != x"" ]]
    then
      echo $line | rot13
    fi
  elif [[ -f "$@" ]]
  then
    # filenames given
    cat "$@" | rot13
  else
    # content given, translate it
    echo $* | rot13
  fi
}

# one-liners
function longestline () awk '{ print length, $0}' $1 | sort -nr | head -1
function showline () awk 'NR == '$1' {print;exit};' $2
function addlinenumbers () awk '{printf("%5d : %s\n", NR,$0)}' $1
function dostounix () awk '{sub(/\r$/,"");print}' $1
function unixtodos () awk '{sub(/$/,"\r");print}' $1
function removebom () awk '{if(NR==1)sub(/^\xef\xbb\xbf/,"");print}' $1
function topten () history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head

