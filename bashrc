# One profile to rule them all...and in the terminal bind them.
# Functions and aliases get evaluated here.

source $HOME/.bash/environment
source $HOME/.bash/functions

# Set command mode editing to Vim.
set -o vi

#{{{  Global aliases

alias c='clear'
alias cp='cp -i'
alias df='df -ah'
alias g='egrep -i'
alias h='fc -l'
alias j=jobs
alias m=$PAGER
alias mv='mv -i'
alias l='ls -lhF'
alias ll='ls -lhFa'
alias lt='ls -lhFtr'
alias rm='rm -i'

#}}}

#{{{ OpenPKG aliases
# Is OpenPKG installed? If so, use those tools.
if [[ -d /usr/openpkg/bin ]]; then
    [ -x "/usr/openpkg/bin/gls" ] && alias ls='gls --color=auto'
    [ -x "/usr/openpkg/bin/gid" ] && alias id='gid'
    [ -x "/usr/openpkg/bin/gdu" ] && alias du='gdu'
    [ -x "/usr/openpkg/bin/grm" ] && alias rm='grm -i'
    [ -x "/usr/openpkg/bin/gcp" ] && alias cp='gcp -i'
    [ -x "/usr/openpkg/bin/gmv" ] && alias mv='gmv -i'
fi
#}}}

#{{{ OS Specific 

# Solaris quirks
if [ $MYOS == "Solaris" ]; then
    alias id='id -a'
    # Tell 'ls' to use color output. '-G'
    alias l='ls -lhFG'
    alias ll='ls -lhFaG'
    alias lt='ls -lhFGtr'
    if [[ -x /usr/local/bin/vim ]]; then
        alias vi='/usr/local/bin/vim'
        export EDITOR=vim
        export VISUAL=vim
    fi
fi
# End Solaris quirks

# OSX quirks
if [ $MYOS == "OSX" ]; then
    # Tell 'ls' to use color output. '-G'
    alias l='ls -lhFG'
    alias ll='ls -lhFGa'
    alias lt='ls -lhFGtr'
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

if [[ -f /etc/bash_completion ]]; then
  source /etc/bash_completion
fi

# Default prompt.
if type -t __git_ps1 2>&1 > /dev/null; then
    PS1="${GREEN}\w${NOCOLOR}"' $(__git_ps1 "(%s)") '"\n\u@\h \$ "
else
    PS1="${GREEN}\w${NOCOLOR}\n\u@\h \$ "
fi

# Are we root?
if [ "$USER" = "root" ]; then
    PS1="${GREEN}\w${NOCOLOR}\n${RED}\u${NOCOLOR}@\h \$ "
fi

# Set xterm titlebar for the terminals that I use.
# Mac temrminals Terminal.app and iTerm use 'xterm-color'.
case "$TERM" in
    "xterm") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"' ;;
    "xterm-color") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"' ;;
    "xterm-256color") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"' ;;
    "rxvt") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"' ;;
esac

# Example of environment-specific prompt.
if [ "$DRW_ENV" = "PROD" ]; then
    #PS1="${GREEN}\w${NOCOLOR}\n\u@${RED}\h${NOCOLOR} \$ "
    PS1="${GREEN}\w${NOCOLOR}"' $(__git_ps1 "(%s)") '"\n\u@${RED}\h${NOCOLOR} \$ "
fi

#}}} End prompt section

#{{{ Environment Specific
    # placeholder
#}}} End Environment specific

# Allow for machine specific customizations to be quarantined to another file.
# I don't want to do this all over again...
if [[ -r .machinerc ]]; then
    . .machinerc
fi
