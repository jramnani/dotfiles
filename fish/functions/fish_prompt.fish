# My prompt should look as follows:
#   (virtualenv) pwd (git branch)
#   username@host [status?] ><>
function fish_prompt -d "Write out the prompt"
    set -l last_status $status

    # Python Virtualenv
    if set -q VIRTUAL_ENV
        set_color blue
        printf '%s' (basename $VIRTUAL_ENV)
        set_color normal
    end

    # Color writeable dirs green, read-only dirs red
    if test -w "."
        printf '%s%s%s' (set_color green) (prompt_pwd) (set_color normal)
    else
        printf '%s%s%s' (set_color red) (prompt_pwd) (set_color normal)
    end

    # Git branch and status
    if git rev-parse --git-dir > /dev/null 2>&1
        printf ' (%s)' (parse_git_branch)
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
