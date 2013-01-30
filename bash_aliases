#############
## ALIASES ##
#############

alias ls="ls -F --color"
alias ll="ls -hl"
alias la="ls -a"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep='fgrep --color=auto'

alias apt-get='sudo apt-get'
alias fixdirs="find . -type d -exec chmod o-rwx {} \;"
alias openports="netstat -nape --inet"
alias listening="netstat -an | grep LISTEN | awk '{print $1}' | sort -n"

###############
## FUNCTIONS ##
###############

function mkcd() { mkdir "$1" && cd "$1"; }
function calc(){ awk "BEGIN{ print $* }" ;}
function mktar() { tar czf "${1%%/}.tar.gz" "${1%%/}/"; }
function mkmine() { sudo chown -R ${USER} ${1:-.}; }
function gril () { grep -rl "$@" *; }
function vimf () { vim -c "ScratchFind" -c "only"; }
function vimg () { vim -c "ScratchFind 'grep -rl \"$@\" *'" -c "only"; }
function vfind () { vim -p $(find . -name '$@'); }
