function ignore -d "Ignore a file in VCS"
    set -l IGNORE_FILE '.gitignore'

    if [ (count $argv) -gt 0 ]
        if test -d '.hg'
            set IGNORE_FILE '.hgignore'
        else if test -d '.svn'
            set IGNORE_FILE '.svnignore'
        end
    end

    for pattern in $argv
        echo "$pattern" >> "$IGNORE_FILE"
    end
end
