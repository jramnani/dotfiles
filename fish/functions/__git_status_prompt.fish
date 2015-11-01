function __git_status_prompt -d "Print the status of git repository for use in the prompt."
    set -l git_prompt_color blue

    # The command, 'git branch', outputs one branch per line, the current branch
    # is prefixed with a '*'.  If HEAD is a commit without a symbolic reference
    # it will look like: '(HEAD detached at c2814fa)'
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
