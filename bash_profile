# One profile to rule them all...and in the terminal bind them.
# Terminal settings, environment variables, and path munging.
# Functions and aliases stored in .bashrc

source $HOME/.bash/environment.sh
source $HOME/.bash/functions.sh

########################################################################
#
# Shell configuration
#
########################################################################

export EDITOR=emacs
export VISUAL=emacs
export LANG=en_US.UTF-8
stty istrip
stty erase 

if [ $MYSHELL == "bash" ]; then
    shopt -s checkwinsize

    # Fix typos in 'cd'
    shopt -s cdspell

    # Make bash tab completion ignore certain files (like .svn directories)
    export FIGNORE=.svn:.pyc:.pyo:~
    shopt -u force_fignore
fi


########################################################################
#
# Path munging
#
########################################################################

# time to munge the path... why can't we all just get along?
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
if [[ -d /usr/local/sbin ]]; then
    pathmunge /usr/local/sbin
fi
if [[ -d /usr/local/bin ]]; then
    pathmunge /usr/local/bin
fi
if [[ -d /usr/local/man ]]; then
    manpathmunge /usr/local/man
fi
if [[ -d ~/bin ]]; then
    pathmunge ~/bin
fi

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


    # Can't use the 'pathmunge' function on Cygwin.  Can only set PATH variable
    # in Windows' system properties.
    "Cygwin")
        REV=`uname -r`
        echo -e "Cygwin $REV --  \c"

        # Windows Resource Kit installed?
        if [[ -d "/cygdrive/c/Program Files/Resource Kit" ]]; then
            echo -e "Win Resource kit, \c"
        fi
        ;;

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
            pathmunge /opt/local/sbin
            manpathmunge /opt/local/share/man
        fi
        # Homebrew installed? Like GNU Stow but better...
        if [[ -x /usr/local/bin/brew ]]; then
            echo -e "Homebrew, \c"
            pathmunge /usr/local/sbin
            pathmunge /usr/local/bin
            manpathmunge /usr/local/share/man
            # Homebrew Casks should install applications into /Applications.
            export HOMEBREW_CASK_OPTS=--appdir=/Applications
        fi
        ;;
    *BSD|Linux)
        REV=`uname -r`
        MYOS_NAME=`uname -s`
        echo -e "$MYOS_NAME $REV -- \c"
        ;;
    *)
        ;;
esac


########################################################################
#
# Pager config
#
########################################################################

if [ -x $(which less) ]; then
    PAGER="$(which less) -isR"
else
    PAGER="more"
fi
export PAGER


########################################################################
#
# Java / Python / Ruby config
#
########################################################################

## Java

if [[ -x /usr/bin/java ]]; then
    JAVA_VERSION=`java -version 2>&1 | head -1 | awk '{print $3}'`
    echo -e "Java ${JAVA_VERSION}, \c"
    if [ $MYOS == "OSX" ]; then
        # OSX keeps it's own set of symlinks that point to the current Java version.
        export JAVA_HOME=`/usr/libexec/java_home`
        export CLASSPATH=$JAVA_HOME/lib
    elif [ $MYOS == "Solaris" ]; then
        # Solaris packages will install into /usr/java ...
        export JAVA_HOME=/usr/java
        export CLASSPATH=/usr/java/lib
    else
        # Everyone else seems to keep this convention...
        export JAVA_HOME=/usr/lib/java
        export CLASSPATH=/usr/lib/java
    fi
fi

## Python

if which python >/dev/null 2>&1; then
    # Python prints version information from '-V' to STDERR.
    PYFULLVERSION=`python -V 2>&1 | awk '{print $2}'`
    echo -e "Python $PYFULLVERSION, \c"
    # Always use 'Distribute' for virtualenvs.
    export VIRTUALENV_USE_DISTRIBUTE=1
    # Use my python startup file.
    export PYTHONSTARTUP=$HOME/.pythonrc
fi

## Ruby

if which ruby >/dev/null 2>&1; then
    # Print which Ruby is in my path.
    RUBY_VERSION=`ruby --version 2>&1 | awk '{print $2}'`
    echo -e "Ruby $RUBY_VERSION, \c"
fi

# Are RubyGems installed in my $HOME dir?
if [[ -d $HOME/.gem/ruby/1.8/bin ]]; then
    pathmunge $HOME/.gem/ruby/1.8/bin
fi


########################################################################
#
# OS Specific
#
########################################################################

## Solaris quirks

if [ $MYOS == "Solaris" ]; then
    # Find GCC
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

## OS X quirks

if [ $MYOS == "OSX" ]; then
  # Use a Solarized color pallete for LSCOLORS.
  # Found at: https://github.com/seebi/dircolors-solarized/issues/10
  export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
fi

## Linux quirks -- placeholder

## Cygwin quirks

if [ $MYOS == "Cygwin" ]; then
    umask 022
fi


########################################################################
#
# Environment Specific
#
########################################################################

## Differences for Dev / Testing / Prod environments go here.


########################################################################
#
# Misc
#
########################################################################

# Get our functions and aliases.
if [ -r .bashrc ]; then
    . .bashrc
fi

# Add a new line after we've printed all the stuff about our environment.
echo ""
