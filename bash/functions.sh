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

function backup () {
    local file_to_backup=$1
    if [[ -z $file_to_backup ]]; then
        echo "Usage: backup FILENAME"
        return 1
    fi

    local yymmdd=$(date +"%Y%m%d")
    cp "${file_to_backup}" "${file_to_backup}.${yymmdd}"
}

# swap 2 filenames around
function swap () {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# Pretty prints your PATH. One entry per line.
function ppath () {
    echo $PATH | tr ':' '\n'
}

function mpath () {
    echo $MANPATH | tr ':' '\n'
}

# Bundler and Rails3
# From: http://twistedmind.com/bundle-exec-bash-shortcut
bundle_commands=( spec rspec cucumber cap watchr rails rackup )

function run_bundler_cmd () {
    if [ -e ./Gemfile ]; then
        echo "bundle exec $@"
        bundle exec $@
    else
        echo "$@"
        $@
    fi
}

for cmd in $bundle_commands
do
    alias $cmd="run_bundler_cmd $cmd"
done
