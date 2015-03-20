function top -d "display and update sorted information about processes"
    if test $MYOS = "OSX"
        # On OS X top defaults to sorting by PID descending.
        # That is never what I want when I'm checking process usage.
        # Use delta mode because it's more useful.
        command top -o cpu -d $argv
    else
        command top $argv
    end
end
