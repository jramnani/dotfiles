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
alias h 'fc -l'
alias j 'jobs'
alias m $PAGER
alias l 'ls -lhF'
alias ll 'ls -alhF'
alias lt 'ls -lhFtr'


# Path
# Assuming OSX for now. MacPorts, Fink, or Homebrew.
for p in ~/bin /opt/local/bin /sw/bin /usr/local/bin /usr/local/sbin
    if test -d $p
        set -x PATH $p $PATH
    end
end

for p in /opt/local/share/man /sw/share/man /usr/local/share/man
    if test -d $p
        set -x MANPATH $p $MANPATH
    end
end

# Prompt
# Fish is very conservative when setting the prompt. Run the command explicitly here.
switch $MYOS
    case "OSX"
        printf "%s" (fish_title)
end

# Source local machine-specific file.
. $HOME/.machinerc.fish
