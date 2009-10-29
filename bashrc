# One profile to rule them all...and in the terminal bind them.

##{{{ FUNCTIONS

# swap 2 filenames around
function swap ()         
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function ppath () {
    echo $PATH | perl -a -n -F/:/ -e 'foreach (@F) { print "$_\n" }'
}
            
# }}}

#{{{ Colors

WHITE="\[\033[1;37m\]"
BRIGHTGREEN="\[\033[1;32m\]"
GREEN="\[\033[0;32m\]"
RED="\[\033[0;31m\]"
BRIGHTRED="\[\033[1;31m\]"
CYAN="\[\033[0;36m\]"
GRAY="\[\033[0;37m\]"
BLUE="\[\033[0;34m\]"
NOCOLOR="\[\033[00m\]"

#}}}

#{{{ Environment -- Copied from profile.

# Detect: Operating system?
case `uname -s` in
    "Linux")    MYOS="Linux";;
    "SunOS")   MYOS="Solaris";;
    "Darwin")   MYOS="OSX";;
    "FreeBSD")  MYOS="FreeBSD";;
    "CYGWIN_NT-5.1")    MYOS="Cygwin";;
    *)  MYOS="Unknown";;
esac

# Detect: Shell
MYSHELL=`basename $SHELL`

# Detect: User
if [ "$USER" == 'root' ]; then
    USERCOLOR="${RED}"
else
    USERCOLOR="${GREEN}"
fi

#}}}

#{{{  Global aliases

set -o vi
alias df='df -ah'
alias h='fc -l'
alias j=jobs
alias m=$PAGER
alias g='egrep -i'
alias c='clear'
# Why won't Solaris terminal just support colors natively... :(
if [ "$MYOS" != "Solaris" ]; then
    alias ll='ls -lhFaG'
    alias lt='ls -lhFGtr'
    alias l='ls -lhFG'
else
    alias ll='ls -lhFa'
    alias lt='ls -lhFtr'
    alias l='ls -lhF'
fi
# Is OpenPKG installed? If so, use those tools.
[ -x "/usr/openpkg/bin/gls" ] && alias ls='gls --color=auto'
[ -x "/usr/openpkg/bin/gid" ] && alias id='gid'
[ -x "/usr/openpkg/bin/gdu" ] && alias du='gdu'
if [ -x "/usr/openpkg/bin/grm" ]; then 
    alias rm='grm -i'
else
    alias rm='rm -i'
fi
if [ -x "/usr/openpkg/bin/gcp" ]; then
    alias cp='gcp -i'
else
    alias cp='cp -i'
fi
if [ -x "/usr/openpkg/bin/gmv" ];then
    alias mv='gmv -i'
else
    alias mv='mv -i'
fi
#}}}

#{{{ OS Specific 

# Solaris quirks
if [ $MYOS == "Solaris" ]; then
    alias id='id -a'
    if [[ -x /usr/local/bin/vim ]]; then
        alias vi='/usr/local/bin/vim'
        export EDITOR=vim
        export VISUAL=vim
    fi
fi
# End Solaris quirks

# OSX quirks
if [ $MYOS == "OSX" ]; then
    # OS X 'ldd' equivalent.
    alias ldd='otool -L '
    # These aliases allow for easy switching between jvm's.
    alias java16='export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home'
    alias java15='export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.5/Home'
    alias java14='export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.4/Home'

    # If the MacPorts version of Vim is available, then use it.
    if [[ -x /opt/local/bin/vim ]]; then
        alias vi='/opt/local/bin/vim'
        alias vim='/opt/local/bin/vim'
        export EDITOR=vim
        export VISUAL=vim
    fi
    # Use MacPorts bash completion
    if [ -f /opt/local/etc/bash_completion ]; then
        . /opt/local/etc/bash_completion
    fi

fi
# End OSX quirks

# Linux
if [ $MYOS == "Linux" ]; then 
    # Linux comes w/ vim installed by default
    if [[ -x /usr/bin/vim ]]; then
        alias vi='/usr/bin/vim'
        export EDITOR=vim
        export VISUAL=vim
    fi
fi

# Cygwin
if [ $MYOS == "Cygwin" ]; then 
    #Don't use M$ crappy "find" command...
    alias find='/usr/bin/find'
    # Get color output from 'ls'
    alias l='ls -lFh --color=auto'
    alias ll='ls -alFh --color=auto'
fi
#}}} end OS Specific

#{{{ Prompt

# Are we @ Arca?
if [ "$ARCA_ENV" = "PROD" ]; then
    PS1="${GREEN}\w${NOCOLOR}\n\u@${RED}\h${NOCOLOR} \$ "
else
    PS1="${GREEN}\w${NOCOLOR}\n\u@\h \$ "
fi
# Are we root?
if [ "$USER" = "root" ]; then
    PS1="${GREEN}\w${NOCOLOR}\n${RED}\u${NOCOLOR}@\h \$ "
fi

# Set xterm titlebar for the terminals that I use.
# Both Mac temrminals Terminal.app, and iTerm use 'xterm-color'.
case "$TERM" in
    "xterm") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"' ;;
    "xterm-color") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"' ;;
    "rxvt") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"' ;;
esac

#}}} End prompt section

#{{{ Environment Specific
    # placeholder
#}}} End Environment specific

# Allow for machine specific customizations to be quarantined to another file. I don't
# want to do this all over again...
if [[ -e .machinerc ]]; then
    . .machinerc
fi
