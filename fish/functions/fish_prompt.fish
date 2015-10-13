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

    # Color read-only dirs red, and writeable dirs green.
    set -l prompt_pwd_color red
    if test -w "."
        set prompt_pwd_color green
    end
    printf '%s%s%s' (set_color $prompt_pwd_color) (prompt_pwd) (set_color normal)

    # Git branch and status
    if git rev-parse --git-dir > /dev/null 2>&1
        printf ' (%s)' (__git_status_prompt)
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
