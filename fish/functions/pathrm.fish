function pathrm -d "Remove a directory from the PATH"
    if test (count $argv) -ne 1
        echo "Usage: pathrm DIR"
        return 1
    end

    set -l NEW_PATH
    set -l path_to_remove $argv[1]

    for p in $PATH
        if test "$p" != "$path_to_remove"
            set NEW_PATH $NEW_PATH "$p"
        end
    end

    set -x PATH $NEW_PATH
end
