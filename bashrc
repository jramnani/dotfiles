# One profile to rule them all...and in the terminal bind them.
# Functions and aliases get evaluated here.

# Bail if this is a non-interactive shell. i.e. scp
if [[ -z "$PS1" ]]; then
    return
fi

source $HOME/.bash/environment.sh
source $HOME/.bash/functions.sh


########################################################################
#
# Global aliases
#
########################################################################

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


########################################################################
#
# OS Specific config
#
########################################################################

## Completions

_load_bash_completions() {
    # Homebrew bash-completion@2 (bash 4.2+)
    # This is the preferred method for modern Homebrew + bash setups.

    # bash-completion@2 (for bash 4.2+) MUST be loaded before any individual
    # completion scripts, as they depend on functions defined in the main script.
    # See: https://docs.brew.sh/Shell-Completion
    if type brew &>/dev/null; then
        local homebrew_prefix
        homebrew_prefix="$(brew --prefix)"

        if [[ -r "${homebrew_prefix}/etc/profile.d/bash_completion.sh" ]]; then
            source "${homebrew_prefix}/etc/profile.d/bash_completion.sh"
            return
        fi

        # Homebrew bash-completion v1 (older bash < 4.2)
        if [[ -r "${homebrew_prefix}/etc/bash_completion" ]]; then
            source "${homebrew_prefix}/etc/bash_completion"
            return
        fi
    fi

    # MacPorts
    if [[ -r /opt/local/etc/bash_completion ]]; then
        source /opt/local/etc/bash_completion
        return
    fi

    # Linux and other systems
    if [[ -r /etc/bash_completion ]]; then
        source /etc/bash_completion
        return
    fi
}

_load_bash_completions
unset -f _load_bash_completions


## Solaris quirks

if [ $MYOS == "Solaris" ]; then
    alias id='id -a'
    # Tell 'ls' to use color output. '-G'
    alias l='ls -lhFG'
    alias ll='ls -lhFaG'
    alias lt='ls -lhFGtr'
    if [[ -x /usr/local/bin/vim ]]; then
        alias vi='/usr/local/bin/vim'
    fi
fi

## OSX quirks

if [ $MYOS == "OSX" ]; then
    # Tell 'ls' to use color output. '-G'
    alias l='ls -lhFG'
    alias ll='ls -lhFGa'
    alias lt='ls -lhFGtr'
    # OS X 'ldd' equivalent.
    alias ldd='otool -L '
    # OS X virtual memory stats
    alias vmstat='vm_stat'

    # If the MacPorts version of Vim is available, then use it.
    if [[ -x /opt/local/bin/vim ]]; then
        alias vi='/opt/local/bin/vim'
        alias vim='/opt/local/bin/vim'
    fi
fi

## OpenBSD quirks

if [ $MYOS == "OpenBSD" ]; then
    # Human readable sizes. OpenBSD's df doesn't have a '-a' option.
    alias df='df -h'
fi

## Linux quirks

if [ $MYOS == "Linux" ]; then
    # Most distros comes w/ vim installed by default
    if [[ -x /usr/bin/vim ]]; then
        alias vi='/usr/bin/vim'
    fi
fi

## Cygwin quirks

if [ $MYOS == "Cygwin" ]; then
    # Don't use M$ crappy "find" command...
    alias find='/usr/bin/find'
    # Get color output from 'ls'
    alias l='ls -lFh --color=auto'
    alias ll='ls -alFh --color=auto'
fi


########################################################################
#
# Prompt
#
########################################################################

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
    "xterm-kitty") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: $(basename $PWD)\007"' ;;
    "rxvt") PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"' ;;
esac

# Example of environment-specific prompt.
if [ "$DRW_ENV" = "PROD" ]; then
    #PS1="${GREEN}\w${NOCOLOR}\n\u@${RED}\h${NOCOLOR} \$ "
    PS1="${GREEN}\w${NOCOLOR}"' $(__git_ps1 "(%s)") '"\n\u@${RED}\h${NOCOLOR} \$ "
fi


########################################################################
#
# Environment specific config
#
########################################################################

## Placeholder


########################################################################
#
# Machine local config
#
########################################################################

# Allow for machine specific customizations to be quarantined to another file.
# I don't want to do this all over again...
if [[ -r "$HOME/.machinerc" ]]; then
    . "$HOME/.machinerc"
fi
