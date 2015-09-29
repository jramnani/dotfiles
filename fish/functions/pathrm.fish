function pathrm -d "Remove a directory from the PATH"
    if test (count $argv) -lt 1
        echo "Usage: pathrm DIR"
        exit 1
    end

    set -l NEW_PATH
    for p in $PATH
        if test "$p" = "$path_to_remove"
            continue
        else
            set NEW_PATH $NEW_PATH "$p"
        end
    end

    set -x PATH $NEW_PATH
end
