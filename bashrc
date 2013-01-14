#!/bin/bash
# A basically sane bash environment.
#
# Francesco Manzoni <http://francescomanzoni.com/about> (with help from the internets).

# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

# readline config
: ${INPUTRC=~/.inputrc}

unset MAILCHECK

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

###################
## SHELL OPTIONS ##
###################

if [ -t 0 -a -t 1 ]; then
    #kill flow control
    stty -ixon
    stty -ixoff
    if [ ${BASH_VERSINFO[0]} -ge 4 ]; then
        shopt -s cdspell
        shopt -s extglob
        shopt -s cmdhist
        shopt -s checkwinsize
        shopt -s no_empty_cmd_completion
        shopt -u promptvars
        shopt -s histappend
        set -o noclobber
        shopt -s dirspell
        stty -ctlecho
    fi
fi

#################
## TERM COLORS ##
#################

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0222222" #black
    echo -en "\e]P8222222" #darkgrey
    echo -en "\e]P1803232" #darkred
    echo -en "\e]P9982b2b" #red
    echo -en "\e]P25b762f" #darkgreen
    echo -en "\e]PA89b83f" #green
    echo -en "\e]P3aa9943" #brown
    echo -en "\e]PBefef60" #yellow
    echo -en "\e]P4324c80" #darkblue
    echo -en "\e]PC2b4f98" #blue
    echo -en "\e]P5706c9a" #darkmagenta
    echo -en "\e]PD826ab1" #magenta
    echo -en "\e]P692b19e" #darkcyan
    echo -en "\e]PEa1cdcd" #cyan
    echo -en "\e]P7ffffff" #lightgrey
    echo -en "\e]PFdedede" #white
    clear 
fi

export CLICOLORS=1

if [ -e /bin/dircolors ]; then
    eval $(dircolors -b ~/.dircolors)
fi

#############
## ALIASES ##
#############

alias ls="ls -F --color"
alias ll="ls -hl"
alias la="ls -a"

if type -p vim >/dev/null; then
    alias vi="vim"
else
    alias vim="vi"
fi

###############
## CHECKPATH ##
###############

function chkpath () {
    if [ -d "$1" ]; then
        export PATH=$1:$PATH
    fi
}
chkpath "$HOME/bin"
chkpath "$HOME/scripts"
chkpath "/usr/local/bin"
chkpath "/usr/local/sbin"
chkpath "/opt/local/bin"
chkpath "/opt/local/sbin"

export HISTIGNORE="&:[bf]g:exit"
export HISTCONTROL=ignoredups
export HISTFILESIZE=10000
export HISTSIZE=10000
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export MANPAGER=less
export IGNOREEOF=3
export PYTHONSTARTUP=~/.pythonrc

# grep colors
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

#####################
## EXTRA FUNCTIONS ##
#####################

function mkcd() { mkdir "$1" && cd "$1"; }
function calc(){ awk "BEGIN{ print $* }" ;}
function hex2dec { awk 'BEGIN { printf "%d\n",0x$1}'; }
function dec2hex { awk 'BEGIN { printf "%x\n",$1}'; }
function mktar() { tar czf "${1%%/}.tar.gz" "${1%%/}/"; }
function mkmine() { sudo chown -R ${USER} ${1:-.}; }
function rot13 () { echo "$@" | tr a-zA-Z n-za-mN-ZA-M; }
function :h () {  vim -c "silent help $@" -c "only"; }
function gril () { grep -rl "$@" *; }
function grepword () { grep -Hnr "$@" *; }
function vimf () { vim -c "ScratchFind" -c "only"; }
function vimg () { vim -c "ScratchFind 'grep -rl \"$@\" *'" -c "only"; }
function vfind () { vim -p $(find . -name '$@'); }

# push SSH public key to another box
function sendkey () {
    if [ $# -eq 1 ]; then
        local key=""
        if [ -f ~/.ssh/id_dsa.pub ]; then
            key=~/.ssh/id_dsa.pub
        elif [ -f ~/.ssh/id_rsa.pub ]; then
            key=~/.ssh/id_rsa.pub
        else
            echo "No public key found" >&2
            return 1
        fi
        ssh $1 'cat >> ~/.ssh/authorized_keys' < $key
    fi
}

function syncdirs () {
    if [ $# -ne 2 ]; then
        echo "usage: syncdirs src dest" >&2
    else
        rsync -rtlpvH --safe-links --delete-after "$1" "$2"
    fi
}

#####################
## REMOTE TERMINAL ##
#####################

if [ "$TERM_PROGRAM" = "Apple_Terminal" -a "$TERM" = "vt100" ];then
    export TERM="screen"
fi

# Different colors for remote server
if [ -z "$SSH_TTY" ]; 
then PS1="\[\033[36m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]$ "
else PS1="\[\033[35m\]\u\[\033[37m\]@\[\033[31m\]\h:\[\033[34;1m\]\w\[\033[m\]$ "
fi

#####################
## BASH-COMPLETION ##
#####################

if [ -e /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ -e /etc/bash_completion ]; then
    . /etc/bash_completion
fi

###############
## SSH-AGENT ##
###############

if [ -t 0 -a -t 1 -a -z "$SSH_AUTH_SOCK" ]; then
    if type -p ssh-agent >/dev/null; then
        eval $(/usr/bin/ssh-agent -s)
        trap "eval \$(/usr/bin/ssh-agent -k)" 0
    fi
fi
