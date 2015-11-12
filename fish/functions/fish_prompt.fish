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
            printf ' git:(%s)' (__git_status_prompt)
        end
    end

    # Mercurial branch and status
    if which hg > /dev/null 2>&1
        if __find_hg_root 2>&1
            printf ' hg:(%s)' (__hg_status_prompt)
        end
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


function __git_status_prompt -d "Print the status of git repository for use in the prompt."
    set -l git_prompt_color blue

    # The command, 'git branch', outputs one branch per line, the current branch
    # is prefixed with a '*'.  If HEAD is a commit without a symbolic reference
    # it will look like: '(HEAD detached at c2814fa)'.  If it is a new repository
    # there will be no branch.
    set -l branch (git branch --no-color ^&- | awk '/^\*/ {print $0}' | sed -e 's/\* //' | sed -e 's/[()]//g')

    if test -n "$branch"
        set_color $git_prompt_color
        printf '%s' $branch
        set_color normal

        # Get the status of the working directory. Are there modified files?
        git diff --quiet HEAD 2>&1
        if test $status = 1
            set_color red
            printf ' Δ'
            set_color normal
        end
    end
end


function __hg_status_prompt -d "Print the status of Mercurial repository for use in the prompt"
    set -l hg_prompt_color blue

    set_color $hg_prompt_color
    printf '%s' (cat "$HG_ROOT/branch" 2>/dev/null; or hg branch)

    if test (count (hg status --modified --added --removed --deleted)) != 0
        set_color red
        printf ' Δ'
    end

    set_color normal
end


function __find_hg_root
    set -l dir (pwd)
    set -e HG_ROOT

    while test "$dir" != "/"
        if test -f "$dir/.hg/dirstate"
            set -g HG_ROOT "$dir/.hg"
            return 0
        end

        set -l dir (dirname $dir)
    end

    return 1
end
