# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/fnl/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Global aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# ls convenience: l, ll and la
# use GNU ls in preference over "default" ls (Mac OSX)
[ -x /usr/local/bin/gls ] && alias l="gls $lscolor " || alias l="ls $lscolor"
alias ll='ls -lh'
alias la='l -A'
alias ..='cd ..'
alias ...='cd ../..'
alias vi='vim' # always use vim
alias curl-json='curl -H"Content-Type: application/json;charset=utf-8"'
alias curl-post='curl -X POST'
alias curl-post-json='curl -X POST -H"Content-Type: application/json;charset=utf-8"'

# a simple terminal calculator
calc() { awk "BEGIN{ print $* }"; }

# extract the longest line from a file
longestline() { awk '{ print length, $0}' "$1" | sort -nr | head -1; }

# show line number X in file Y
showline() { awk 'NR == '$1' { print; exit }' "$2"; }

# show the column number of each column in a TSV file with a title row
numtsvcols() { head -1 "$@" | tr '\t' '\n' | nl; }

# show the column number of each column in a CSV file with a title row
numcsvcols() { head -1 "$@" | tr ',' '\n' | nl; }

# count and rank the unqiue lines in a file
uniqcount() { sort "$@" | uniq -c | sort -rn | sed 's/^ *//' | sed 's/ /	/'; }

# elasticsearch commands (with echo to ensure a newline is printed)
esDELETE() { local url=$1; shift; curl -XDELETE "$ELASTICSEARCH/$url" "$@"; echo; }
esDELETEh() { local url=$1; shift; curl -i -XDELETE "$ELASTICSEARCH/$url" "$@"; echo; }
esGET() { local url=$1; shift; curl --silent "$ELASTICSEARCH/$url?pretty" -H 'Content-Type: application/json' "$@"; echo; }
esHEAD() { local url=$1; shift; curl -I "$ELASTICSEARCH/$url"; echo $@; }
esPOST() { local url=$1; shift; curl -XPOST "$ELASTICSEARCH/$url" -H 'Content-Type: application/json' "$@"; echo; }
esPOSTh() { local url=$1; shift; curl -i -XPOST "$ELASTICSEARCH/$url" "$@"; echo; }
esPUT() { local url=$1; shift; curl -XPUT "$ELASTICSEARCH/$url" -H 'Content-Type: application/json' "$@"; echo; }
esPUTh() { local url=$1; shift; curl -i -XPUT "$ELASTICSEARCH/$url" "$@"; echo; }

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
alias rc="ranger-cd"

# Use fuzzy finder if present
[ -f ~/.bash_environment ] && source ~/.bash_environment

# Use zoxide
eval "$(zoxide init zsh)"


# Use fuzzy finder if present
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
