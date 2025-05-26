##
## .bashrc of dh
##

#-------------------------------------------------------------------------------
# bash settings
#-------------------------------------------------------------------------------

# enable more powerful bash pattern matching (see http://wiki.bash-hackers.org/syntax/pattern#extended_pattern_language)
shopt -s extglob

# more comfort when changing dirs
shopt -s autocd
shopt -s cdspell
shopt -s dirspell

# append history instead of overwriting
shopt -s histappend

# eternal bash history (see https://stackoverflow.com/a/19533853/1913780)
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T]  "
export HISTFILE=$HOME/.bash_eternal_history

# append to bash history immediately after each command
PROMPT_COMMAND="history -a"

# do not close terminal automatically (but only set it for interactive shells)
case "$-" in
    *i*) export TMOUT=0;;
    *)   ;;
esac

#-------------------------------------------------------------------------------
# paths
#-------------------------------------------------------------------------------

if [ -d $HOME/.local/bin ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d $HOME/bin ]; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -f $HOME/.inputrc ]; then
    export INPUTRC="$HOME/.inputrc"
fi

#-------------------------------------------------------------------------------
# file permissions
#-------------------------------------------------------------------------------

# all new files get rwxr-xr-x (2 = remove write permissions)
umask 0022

#-------------------------------------------------------------------------------
# color definitions
#-------------------------------------------------------------------------------

# reset color
COLOR_OFF='\e[0m'

# regular colors
COLOR_BLACK='\e[0;30m'
COLOR_RED='\e[0;31m'
COLOR_GREEN='\e[0;32m'
COLOR_YELLOW='\e[0;33m'
COLOR_BLUE='\e[0;34m'
COLOR_PURPLE='\e[0;35m'
COLOR_CYAN='\e[0;36m'
COLOR_WHITE='\e[0;37m'

# high intensity
COLOR_IBLACK='\e[0;90m'
COLOR_IRED='\e[0;91m'
COLOR_IGREEN='\e[0;92m'
COLOR_IYELLOW='\e[0;93m'
COLOR_IBLUE='\e[0;94m'
COLOR_IPURPLE='\e[0;95m'
COLOR_ICYAN='\e[0;96m'
COLOR_IWHITE='\e[0;97m'

# bold
COLOR_BOLD_BLACK='\e[1;30m'
COLOR_BOLD_RED='\e[1;31m'
COLOR_BOLD_GREEN='\e[1;32m'
COLOR_BOLD_YELLOW='\e[1;33m'
COLOR_BOLD_BLUE='\e[1;34m'
COLOR_BOLD_PURPLE='\e[1;35m'
COLOR_BOLD_CYAN='\e[1;36m'
COLOR_BOLD_WHITE='\e[1;37m'

# bold high intensity
COLOR_BOLD_IBLACK='\e[1;90m'
COLOR_BOLD_IRED='\e[1;91m'
COLOR_BOLD_IGREEN='\e[1;92m'
COLOR_BOLD_IYELLOW='\e[1;93m'
COLOR_BOLD_IBLUE='\e[1;94m'
COLOR_BOLD_IPRUPLE='\e[1;95m'
COLOR_BOLD_ICYAN='\e[1;96m'
COLOR_BOLD_IWHITE='\e[1;97m'

# underline
COLOR_UNDERLINE_BLACK='\e[4;30m'
COLOR_UNDERLINE_RED='\e[4;31m'
COLOR_UNDERLINE_GREEN='\e[4;32m'
COLOR_UNDERLINE_YELLOW='\e[4;33m'
COLOR_UNDERLINE_BLUE='\e[4;34m'
COLOR_UNDERLINE_PURPLE='\e[4;35m'
COLOR_UNDERLINE_CYAN='\e[4;36m'
COLOR_UNDERLINE_WHITE='\e[4;37m'

# background
COLOR_ON_BLACK='\e[40m'
COLOR_ON_RED='\e[41m'
COLOR_ON_GREEN='\e[42m'
COLOR_ON_YELLOW='\e[43m'
COLOR_ON_BLUE='\e[44m'
COLOR_ON_PURPLE='\e[45m'
COLOR_ON_CYAN='\e[46m'
COLOR_ON_WHITE='\e[47m'

# high intensty background
COLOR_ON_IBLACK='\e[0;100m'
COLOR_ON_IRED='\e[0;101m'
COLOR_ON_IGREEN='\e[0;102m'
COLOR_ON_IYELLOW='\e[0;103m'
COLOR_ON_IBLUE='\e[0;104m'
COLOR_ON_IPURPLE='\e[10;95m'
COLOR_ON_ICYAN='\e[0;106m'
COLOR_ON_IWHITE='\e[0;107m'

#-------------------------------------------------------------------------------
# PS{n} variables
#-------------------------------------------------------------------------------

USERNAME=`whoami`
if [ "$USERNAME" == "root" ]; then
    COLOR_PROMPT=$COLOR_RED
else
    COLOR_PROMPT=$COLOR_GREEN
fi

if [ -n "$SSH_CONNECTION" ]; then
    COLOR_HOST="$COLOR_BLACK$COLOR_ON_WHITE"
else
    COLOR_HOST=$COLOR_OFF
fi

# commands to be executed before showing a new prompt
case "$-" in
    # (use return value indicator only for interactive shells, otherwise there will be problems with rsync)
    *i*) PROMPT_COMMAND="$PROMPT_COMMAND; LASTEXIT=\$?";;
    *)   PROMPT_COMMAND="$PROMPT_COMMAND";;
esac


# prompt style
PS1="\u@\[$COLOR_HOST\]\h\[$COLOR_OFF\]:\[$COLOR_PROMPT\]\w\[$COLOR_OFF\](\$(/bin/ls -1F | grep -e '/$' | wc -l)+\$(/bin/ls -1F | grep -e '[^/]$' | wc -l)),\$(echo \$LASTEXIT | sed -e 's/\(^[0-9]*[1-9][0-9]*$\)/\[$COLOR_RED\]\\1\[$COLOR_OFF\]/g')\$ "
PS2="+ "

#-------------------------------------------------------------------------------
# aliases, functions, variables etc.
#-------------------------------------------------------------------------------

# directory listings
ls --group-directories-first /dev/null &> /dev/null
if [ $? -eq 0 ]; then
    alias ls="ls --color=auto --classify --group-directories-first"
else
    alias ls="ls --color=auto --classify"
fi
alias l="ls -lh"
alias lg="l | grp"
alias lh="l | head"
alias lt="l -t | head"
alias lS="l -S | head"
alias L="l -A"
alias Lg="L | grp"

# change and ls dir
function cl() {
   cd "$*" && l
}

# mkdir, cp, mv, rm
alias cp="cp -riv"
alias rs="rsync --archive --verbose --progress"
alias mv="mv -iv"
alias rm="rm -vI"
alias mkdir="mkdir -p"
function mkcd() {
   mkdir "$*" && cd "$1"
}

# grep
alias grp="grep --color=auto --ignore-case --with-filename --line-number"

# grep in files matching a certain pattern
# update: consider using ripgrep (rg) instead
function fang() {
    # fang: *f*ind *an*d *g*rep
    if [[ $# -ne 2 ]]; then
        echo "Usage: fang <grep_pattern> <file_extension>"
    else
        find . -name "*.$2" -exec grep --with-filename --line-number --ignore-case "$1" {} \; | sort
    fi
}

# less (show current postion in file and case insensitive search)
export LESS="-M -i" 

# file sizes
alias dusch="du -sch"
alias dusl="du -sch * | sort -h -r | less"

# current date string
alias nowstr="date '+%Y-%m-%d__%H-%M-%S'"

# tmux - attach session if it exists, otherwise create new session
function tx() {
    tmux has-session &> /dev/null
    if [[ $? -eq 0 ]]; then
        tmux attach-session
    else
        tmux
    fi
}

# tmuxinator
function mx() {
    tmuxinator start ${1:-mylocal}
}

# editor
export PAGER="less"
export EDITOR="vim"
alias v="vim"
alias vbrc="vim $HOME/.bashrc"

# show readme file
function lr() {
   for file in `find . -mindepth 1 -maxdepth 1 -iname "*readme*" -type f`; do
      if [ "`file $file | grep -i text | wc -l`" -eq "1" ]; then
         less $file
         break
      fi
   done
}

# Git
alias g="git"
alias gg="git status"
alias g.="git status ."

# Docker
alias d="docker"
alias dil="docker image ls"
alias diln="docker image ls | head -n 1 && docker image ls | tail -n +2 | sort"  # sorted by name
alias drrit="docker run -i -t --rm"
alias drrib="docker run -i -t --rm --entrypoint=/bin/bash"
alias dirm="docker image rm"
alias dco="docker container"
alias dcl="docker container ls --all | less -S"
function dcrmall() {
    # remove all containers
    docker container rm $(docker ps -aq)
}
function drmnoname() {
    # remove unnamed images
    docker image rm $(docker image ls | awk '{ if ($2 == "<none>") print $3 }')
}
function dcbash() {
    # start interactive bash in container
    docker container exec -it $* /bin/bash
}
function dtgz() {
    # save image as local tar.gz file
    FILENAME_OUT="$(echo "$1" | sed 's#[/:]#_#g').tar.gz"
    if [[ -e "$FILENAME_OUT" ]]; then
        echo "Target file '$FILENAME_OUT' exists already, aborted"
        exit 1
    fi
    echo "Saving docker image to '$FILENAME_OUT'..."
    docker save "$1" | gzip > "$FILENAME_OUT"
    echo "Done. Files:"
    echo "$FILENAME_OUT  $(du -h "$FILENAME_OUT" | cut -f1)  $(sha1sum "$FILENAME_OUT" | awk '{ print $1 }')"
}
alias dcom="docker compose"
alias dcup="docker compose up -d"
alias dcdo="docker compose down"

# rhash
alias rha="rhash --sha1 --percents --output=rhash.txt --recursive --follow *"
alias rhs="rhash --sha1 --percents --recursive --follow * | sort > rhash_sorted.txt"
function rhc() {
    rhash --check --percents ${1:-rhash*.txt}
}

# other commands
alias gputop="watch -n1 nvidia-smi"

# common typos
alias mkdit="mkdir"
alias dc="cd"
alias whoch='which'

# apt aliases
alias aps="apt search"
alias api="apt install"

#-------------------------------------------------------------------------------
# programming languages
#-------------------------------------------------------------------------------

# R
alias R='R --no-save --no-restore --no-site-file --no-environ'
unset R_LIBS
export R_LIBS_USER="$HOME/R/library/%V"

#-------------------------------------------------------------------------------
# Python
#-------------------------------------------------------------------------------

# executables
which bpython3 > /dev/null
if [ $? -eq 0 ]; then
    alias p3=$(which bpython3)
else
    alias p3=$(which python3)
fi
alias py='python'
alias bp='bpython'

# startup
export PYTHONSTARTUP="$HOME/.pythonstartup"

# create and activate virtual environment
function vvc() {
    python3 -m venv "${1:-venv}"
    source "${1:-venv}"/bin/activate
}

# activate virtual environment
function vva() {
    source "${1:-venv}"/bin/activate
}

# deactivate virtual environment
alias vvd="deactivate"

# activate virtual environment 'dh'
alias vdh="source $HOME/venvs/dh/bin/activate"

# pip installation of wheels from local files (needed if machine has no internet access)
function pinf() {
    pip install --no-index --find-links="$(dirname "$1")" $*
}

# Jupyter
alias jupyhere="jupyter notebook --notebook-dir=."

#-------------------------------------------------------------------------------
# source local '.bashrc' if it exists
#-------------------------------------------------------------------------------

if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi

#-------------------------------------------------------------------------------
# source zoxide definitions if they exist and zoxide is installed
#-------------------------------------------------------------------------------

# if zoxide is not available, just use cd
alias c="cd"

# cd aliases
alias cc="c $HOME/code"
alias ..="c .."
alias ...="c ../.."
alias ....="c ../../.."
alias .....="c ../../../.."
alias ......="c ../../../../.."

# only do something if zoxide is installed and the file $HOME/.bashrc.zoxide exists
which zoxide > /dev/null
if [ $? -eq 0 ]; then
    if [ -f $HOME/.bashrc.zoxide ]; then
        # remove the fallback alias to cd
        unalias c

        # source zoxide definitions generated via 'zoxide init bash --cmd=c > .bashrc.zoxide'
        # this creates the 'c' and 'ci' commands (zoxide defaults are 'z' and 'zi')
        source $HOME/.bashrc.zoxide
    fi
fi
