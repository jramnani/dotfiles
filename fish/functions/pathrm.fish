function pathrm -d "Remove one or more directories from the PATH"
    if test (count $argv) -lt 1
        echo "Usage: pathrm DIR [DIR ...]"
        exit 1
    end

    set -l NEW_PATH
    for p in $PATH
        for path_to_remove in $argv
            if test "$p" = "$path_to_remove"
                continue
            else
                set NEW_PATH $NEW_PATH "$p"
            end
        end
    end

    set -x PATH $NEW_PATH
end
