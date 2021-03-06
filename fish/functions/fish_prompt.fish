# My prompt should look as follows:
#   pwd env:$VIRTUAL_ENV git:(branch)
#   username@host [status?] ><>
function fish_prompt -d "Write out the prompt"
    set -l last_status $status

    # Color read-only dirs red, and writeable dirs green.
    set -l prompt_pwd_color red
    if test -w "."
        set prompt_pwd_color green
    end
    printf '%s%s%s' (set_color $prompt_pwd_color) (prompt_pwd) (set_color normal)

    # Python Virtualenv
    if set -q VIRTUAL_ENV
        printf ' env:%s%s%s' (set_color blue) (basename $VIRTUAL_ENV) (set_color normal)
    end

    # Git branch and status
    if which git > /dev/null 2>&1
        if git rev-parse --git-dir > /dev/null 2>&1
            printf ' git:%s' (__fish_git_prompt | sed -e 's/^ //')
        end
    end

    # Mercurial branch and status
    if which hg > /dev/null 2>&1; and __find_hg_root
        printf ' hg:(%s)' (__hg_status_prompt)
    end

    printf '\n'

    set_color normal
    printf '%s@%s' (whoami) (hostname | cut -d . -f 1)

    if test $last_status -eq 0
        set_color -o white
        printf ' ><> '
    else
        set_color red -o
        printf ' [%d] ><> ' $last_status
    end

    set_color normal
end


function __hg_status_prompt -d "Print the status of Mercurial repository for use in the prompt"
    set -l hg_prompt_color blue

    set_color $hg_prompt_color
    printf '%s' (cat "$HG_ROOT/bookmarks.current" 2>/dev/null; or cat "$HG_ROOT/branch" 2>/dev/null; or hg branch)

    if test (count (hg status --modified --added --removed --deleted)) != 0
        set_color red
        printf ' Δ'
    end

    set_color normal
end


function __find_hg_root
    set -e HG_ROOT

    for dir in (__fish_parent_directories (pwd))
        if test -f "$dir/.hg/dirstate"
            set -g HG_ROOT "$dir/.hg"
            return 0
        end
    end

    return 1
end
