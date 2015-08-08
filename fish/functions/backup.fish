function backup -d "Backup a file with a .YYYYMMDD suffix."
    if test (count $argv) -eq 0
        echo "Usage: backup FILE ..."
        return 1
    end

    set -l YYYYMMDD (date +"%Y%m%d")
    for filename in $argv
        if test -f $filename
            command cp "$filename" "$filename.$YYYYMMDD"
        end
    end
end
