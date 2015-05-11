# Run java_home(1) on OS X.
function java_home
    if test -x /usr/libexec/java_home
        command /usr/libexec/java_home $argv
    else
        command java_home $argv
    end
end
