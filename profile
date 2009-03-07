#
# Copyright (c) 2001 by Sun Microsystems, Inc.
# All rights reserved.
#
# ident	"@(#)local.profile	1.10	01/06/23 SMI"
stty istrip
stty erase 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/etc
PS1='$LOGNAME@'`uname -n`:'$PWD > '
EDITOR=vi
set -o vi
MANPATH=/usr/man:/opt/VRTS/man:/opt/web/man:/usr/local/man
export PATH PS1 EDITOR MANPATH 
http_proxy=http://arcarray.tradearca.max:8080
export http_proxy
export PAGER=more

# Adding aliases

alias h='fc -l'
alias j=jobs
alias m=$PAGER
alias ll='ls -laFo'
alias l='ls -lF'
alias g='egrep -i'
alias c=clear

# be paranoid
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'

