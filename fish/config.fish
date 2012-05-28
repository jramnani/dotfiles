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

# My preferred locale
set -g LC_ALL 'en_US.utf8'

# Aliases
alias c 'clear'
alias cp 'cp -i'
alias df 'df -ah'
alias g 'egrep -i'
alias h 'fc -l'
alias j 'jobs'
alias m $PAGER
alias mv 'mv -i'
alias l 'ls -lhF'
alias ll 'ls -alhF'
alias lt 'ls -lhFtr'
alias rm 'rm -i'
 

# Path
# Assuming OSX for now.
set -g BASE_PATH /usr/local/bin /usr/bin /usr/sbin /bin /sbin

