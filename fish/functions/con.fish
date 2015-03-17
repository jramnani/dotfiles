function con -d "Print the last 40 messages of the system log"
    set -l LOGFILE

    if test $MYOS = "OSX"
        set LOGFILE "/var/log/system.log"
    else
        set LOGFILE "/var/log/syslog"
    end

    command tail -40 -f "$LOGFILE"
end
