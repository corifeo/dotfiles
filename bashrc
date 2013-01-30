#!/bin/bash
# A basically sane bash environment.

# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

# readline config
: ${INPUTRC=~/.inputrc}

unset MAILCHECK

ulimit -S -c 0
umask 0022

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export MANPAGER=less
export IGNOREEOF=3
export PYTHONSTARTUP=~/.pythonrc

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
## HISTORY ##
#############

shopt -s histappend

export HISTIGNORE="&:pwd:ls:ll:lal:[bf]g:exit:rm*:sudo rm*"
export HISTCONTROL=erasedups
export HISTSIZE=10000

#############
## ALIASES ##
#############

if [ -e ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

#######################
## BASH COMPLETITION ##
#######################

if [ -e /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ -e /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#####################
## REMOTE TERMINAL ##
#####################

# Different colors for remote server
if [ -z "$SSH_TTY" ]; then 
   	PS1="\[\033[36m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]$ "
else 
	PS1="\[\033[35m\]\u\[\033[37m\]@\[\033[31m\]\h:\[\033[34;1m\]\w\[\033[m\]$ "
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
