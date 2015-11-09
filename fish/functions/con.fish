function con -d "Print the last 40 messages of the system log"
    set -l LOGFILE

    switch "$MYOS"
        case "OSX"
            set LOGFILE "/var/log/system.log"
        case "*BSD"
            set LOGFILE "/var/log/messages"
        case "Solaris"
            set LOGFILE "/var/adm/messages"
        case '*'
            set LOGFILE "/var/log/syslog"
    end

    command tail -n 40 -f "$LOGFILE"
end
