# One profile to rule them all...and in the terminal bind them.
# Setting terminal settings, environment variables, and path munging.
# functions and aliases stored in .bashrc

##{{{ FUNCTIONS
# Make it easier to mess with $PATH (stolen from Red Hat /etc/profile)
# Helps to keep duplicate pathnames from showing up in your path.
pathmunge () {
        if ! echo $PATH | egrep -s "(^|:)$1($|:)" > /dev/null ; then
           if [ "$2" = "after" ] ; then
              export PATH=$PATH:$1
           else
              export PATH=$1:$PATH
           fi
        fi
}
manpathmunge () {
        if ! echo $MANPATH | egrep -s "(^|:)$1($|:)" > /dev/null ; then
           if [ "$2" = "after" ] ; then
              export MANPATH=$MANPATH:$1
           else
              export MANPATH=$1:$MANPATH
           fi
        fi
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

#{{{ Environment

# Detect: Operating system
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

#{{{ Shell specific stuff
stty istrip
stty erase 
set -o vi

if [ $MYSHELL == "bash" ]; then 
    shopt -s checkwinsize
fi
#}}} End Shell section

#{{{ Path Munging

# time to munge the path... why can't we all just get along?
# agnostic
if [[ -d ~jramnani/bin ]]; then
    pathmunge ~jramnani/bin
fi
if [[ -d /usr/local/sbin ]]; then
    pathmunge /usr/local/sbin after
fi
if [[ -d /usr/local/bin ]]; then
    pathmunge /usr/local/bin after
fi
if [[ -d /sbin ]]; then
    pathmunge /sbin
fi
if [[ -d /usr/sbin ]]; then
    pathmunge /usr/sbin
fi
if [[ -d /usr/X11R6/bin ]]; then
    pathmunge /usr/X11R6/bin after
    manpathmunge /usr/X11R6/man
fi
if [[ -d /usr/share/man ]]; then
    manpathmunge /usr/share/man
fi
if [[ -d /usr/local/man ]]; then 
    manpathmunge /usr/local/man
fi

# Use OpenPKG command that will populate PATH and MANPATH correctly to find OpenPKG tools.
if [[ -d /usr/openpkg ]]; then
    pathmunge /usr/openpkg/bin
    manpathmunge /usr/openpkg/man
fi
# Solaris
case ${MYOS} in
    "Solaris")
        REV=`uname -r`
        echo -e "Solaris $REV --  \c"
        # Old Solaris compiler stuff...
        if [[ -d /usr/ucb ]]; then
            pathmunge /usr/ucb after
        fi
        if [[ -d /usr/ccs/bin ]]; then
            pathmunge /usr/ccs/bin after
        fi
        platform=`uname -i`;
        # platform specific binaries?
        if [[ -d /usr/platform/$platform/sbin ]]; then
            echo -e "prtdiag, \c"
            pathmunge /usr/platform/$platform/sbin after
        fi           
        # rsc ???    
        if [[ -d /usr/platform/$platform/rsc ]]; then
            echo -e "rsc tool, \c"
            pathmunge /usr/platform/$platform/rsc after
        fi           
        # veritas crap
        if [[ -d /opt/VRTS ]]; then         
            echo -e "veritas, \c"
            pathmunge /opt/VRTS/bin after
            manpathmunge /opt/VRTS/man after
        fi
        # Use perl 5.6 until we test 5.8 everywhere
        if [[ -d /usr/perl5/5.6.1/bin ]]; then
            echo -e "perl5.6.1, \c"
            pathmunge /usr/perl5/5.6.1/bin after
            manpathmunge /usr/perl5/5.6.1/man after
        fi               
        # sun C compiler
        if [[ -d /opt/SUNWspro/bin ]]; then
                echo -e "forte, \c"
                pathmunge /opt/SUNWspro/bin after
                manpathmunge /opt/SUNWspro/man after
        fi           
        # solaris xwindows. Can you say "cruft"?
        if [[ -d /usr/openwin/bin ]]; then         
                echo -e "openwin, \c"
                pathmunge /usr/openwin/bin after
                manpathmunge /usr/openwin/man after
        fi
        # solaris location for GNU software. why solaris, why??  
        if [[ -d /usr/sfw ]]; then         
                echo -e "sfw, \c"
                pathmunge /usr/sfw/bin
                manpathmunge /usr/sfw/man after
        fi
        ;;
# End Solaris section

# Cygwin
# Can't use 'pathmunge' function.  Can only set PATH variable in Windows'
#   system properties.
    "Cygwin")
        REV=`uname -r`
        echo -e "Cygwin $REV --  \c"
        
        # Windows Resource Kit installed?
        if [[ -d "/cygdrive/c/Program Files/Resource Kit" ]]; then
            echo -e "Win Resource kit, \c"
        fi
        ;;
# End Cygwin Section

# Mac OSX
    "OSX")
        REV=`uname -r`
        echo -e "Darwin $REV -- \c"
        # Fink installed?  If not, you should, it's a decent package manager...
        if [[ -d /sw ]]; then
            echo -e "Fink, \c"
            # This script sets up all Fink required environment stuff.
            . /sw/bin/init.sh
        fi
        # MacPorts installed? Perhaps even better than Fink...
        if [[ -d /opt/local ]]; then
            echo -e "MacPorts, \c"
            pathmunge /opt/local/bin
            manpathmunge /opt/local/share/man
        fi
        ;;
# End MacOSX section
    *)  ;;
esac
#}}} End path munging section  

# PAGER {{{
if [ -x "/usr/openpkg/bin/less" ]; then
    PAGER="/usr/openpkg/bin/less -isR"
elif [ -x "/usr/bin/less" ]; then
    PAGER="/usr/bin/less -isR"
elif [ -x "/usr/local/bin/less" ]; then
    PAGER="/usr/local/bin/less -isR"
else
    PAGER="more"
fi
export PAGER
#}}}

#{{{ Java / Python / Perl

# Java section
# Is Java installed?
if [[ -x /usr/bin/java ]]; then
    JAVA_VERSION=`java -version 2>&1 | head -1 | awk '{print $3}'`
    echo -e "Java ${JAVA_VERSION}, \c"
    # OSX keeps it's own set of symlinks that point to the current Java version.
    if [ $MYOS == "OSX" ]; then
       export JAVA_HOME=/Library/Java/Home
       export CLASSPATH=$JAVA_HOME/lib
    # Solaris packages will install into /usr/java ...
    elif [ $MYOS == "Solaris" ]; then
        export JAVA_HOME=/usr/java
        export CLASSPATH=/usr/java/lib
    else
     #Everyone else seems to keep this convention...
       export JAVA_HOME=/usr/lib/java
       export CLASSPATH=/usr/lib/java
    fi
fi
# Is Java software installed in $HOME?
if [[ -d $HOME/lib/java ]]; then
    export CLASSPATH=$CLASSPATH:$HOME/lib/java
fi
# End Java section

# Python section
# Is Python installed?
if [[ -x `which python` ]]; then
    # Python prints version information from '-V' to STDERR.
    PYFULLVERSION=`python -V 2>&1 | awk '{print $2}'`
    echo -e "Python $PYFULLVERSION, \c"
    PYSHORTVERSION=`echo $PYFULLVERSION | awk -F'.' '{ print $1"."$2 }'`
fi
# Is Python software installed in $HOME?
if [[ -d $HOME/lib/python ]]; then
    export PYTHONPATH=$HOME/lib/python:$PYTHONPATH
fi
# End Python section
#}}} End Java / Python / Perl

#{{{ OS Specific 

# Solaris quirks
if [ $MYOS == "Solaris" ]; then
    # If OpenPKG is installed, use that termcap instead of the decrepit one that comes w/ Solaris.
    if [[ -d "/usr/openpkg/share/ncurses/terminfo" ]]; then
        export TERMINFO="/usr/openpkg/share/ncurses/terminfo"
    fi
    # Try the obvious place for gcc
    if [[ -x /usr/local/bin/gcc ]]; then
        export CC=/usr/local/bin/gcc
    fi
    # Now try the solaris place for gcc...
    if [[ -x /usr/sfw/bin/gcc ]]; then
        export CC=/usr/sfw/bin/gcc
    fi
    # Fix Solaris lack of a USER environment variable. May be obsolete...
    if [ ! -e ${USER} ]; then
    export USER=$LOGNAME
    fi
    # Let me know if vim is installed
    if [[ -x /usr/local/bin/vim ]]; then
        echo -e "VIM, \c"
    fi
fi
# End Solaris quirks

# Linux -- placeholder

# Cygwin
if [ $MYOS == "Cygwin" ]; then
    umask 022
fi

#}}} end OS Specific

#{{{ Environment Specific

#}}} End Environment specific

# Get our functions and aliases.
if [ -e .bashrc ]; then
    . .bashrc
fi
# Add a new line after we've printed all the stuff about our environment.
echo ""
