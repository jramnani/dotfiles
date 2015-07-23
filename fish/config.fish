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

# Assuming OSX for now. MacPorts, Fink, or Homebrew.
for p in /opt/local/bin /sw/bin /usr/local/bin /usr/local/sbin
  pathmunge p
end

for p in /opt/local/share/man /sw/share/man /usr/local/share/man
  manpathmunge p
end

# My bin dir
pathmunge $HOME/bin

# Set the shell's greeting.
set fish_greeting (fish_greeting)

# Enable vi-mode. Yay!
# From https://github.com/DarkStarSword/junk/blob/master/vi-mode.fish
. $HOME/.config/fish/vi-mode.fish


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

if python -m virtualfish > /dev/null 2> /dev/null
    eval (python -m virtualfish $VIRTUALFISH_PLUGINS)
end


# Source local machine-specific file.
. $HOME/.machinerc.fish
