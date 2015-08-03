# List: Colors
WHITE="\[\033[1;37m\]"
BRIGHTGREEN="\[\033[1;32m\]"
GREEN="\[\033[0;32m\]"
RED="\[\033[0;31m\]"
BRIGHTRED="\[\033[1;31m\]"
CYAN="\[\033[0;36m\]"
GRAY="\[\033[0;37m\]"
BLUE="\[\033[0;34m\]"
NOCOLOR="\[\033[00m\]"

# Detect: OS Platform
case `uname -s` in
    "Linux")
        MYOS="Linux";;
    "SunOS")
        MYOS="Solaris";;
    "Darwin")
        MYOS="OSX";;
    "FreeBSD")
        MYOS="FreeBSD";;
    "OpenBSD")
        MYOS="OpenBSD";;
    "CYGWIN_NT-5.1")
        MYOS="Cygwin";;
    *)
        MYOS="Unknown";;
esac

# Detect: Shell
MYSHELL=`basename $SHELL`

# Detect: User
if [ "$USER" == 'root' ]; then
    USERCOLOR="${RED}"
else
    USERCOLOR="${GREEN}"
fi
