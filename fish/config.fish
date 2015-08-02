# On what OS are we running?
switch (uname -s)
  case "Linux"
    set -gx MYOS "Linux"
  case "SunOS"
    set -gx MYOS "Solaris"
  case "Darwin"
    set -gx MYOS "OSX"
  case "FreeBSD"
    set -gx MYOS "FreeBSD"
  case "CYGWIN_NT-5.1"
    set -gx MYOS "Cygwin"
  case '*'
    set -gx MYOS "Unkown"
end


# Set BROWSER for the 'help' command.
if not set -q BROWSER
    switch $MYOS
        case "OSX"
            set -U BROWSER 'open'
        case "Linux"
            set -U BROWSER 'google-chrome'
    end
end

# Shell configuration
set -gx FIGNORE .svn .git .hg .pyc .pyo .o

# My preferred locale
set -gx LC_ALL 'en_US.UTF-8'

# Editing and viewing files
set -gx PAGER less
set -gx EDITOR vim

# Aliases
alias c 'clear'
alias df 'df -ah'
alias g 'egrep -i'
alias j 'jobs'
alias m $PAGER
alias l 'ls -lhF'
alias ll 'ls -alhF'
alias lt 'ls -lhFtr'

# OS specific aliases
if [ $MYOS = "OSX" ]
  alias vmstat 'vm_stat'
end


## Path
# Set the PATH on OS X using /etc/paths like /usr/libexec/path_helper would.
if [ $MYOS = "OSX" ]
  load_path_helper_paths
end

# Third-party packages. Using Homebrew on OS X.
for p in /usr/local/{bin,sbin}
  pathmunge p
end

# My bin dir
pathmunge $HOME/bin

# Configure MANPATH on OS X
if [ $MYOS = 'OSX' ]
    for p in (cat /etc/manpaths)
        manpathmunge "$p"
    end

    for path_file in /etc/manpaths.d/*
        for p in (cat "$path_file")
            manpathmunge "$p" after
        end
    end
end


# Set the shell's greeting.
set fish_greeting (fish_greeting)


## Python
# Use my Python startup file.
set -x PYTHONSTARTUP ~/.pythonrc

# Virtualfish: a Virtualenvwrappper equivalent for Fish.
# https://github.com/adambrenecki/virtualfish
# This config must happen after path munging is complete.
set -gx VIRTUALFISH_HOME $HOME/.venv
set -gx PROJECT_HOME $HOME/code
# Use compat aliases to help my muscle memory for now.
set -gx VIRTUALFISH_COMPAT_ALIASES 1
set -l VIRTUALFISH_PLUGINS auto_activation compat_aliases projects


if which python >/dev/null 2>&1; and python -m virtualfish >/dev/null 2>&1
    eval (python -m virtualfish $VIRTUALFISH_PLUGINS)
end


# Source local machine-specific file.
. $HOME/.machinerc.fish
