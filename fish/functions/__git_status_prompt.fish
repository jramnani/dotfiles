function __git_status_prompt -d "Print the status of git repository for use in the prompt."
    set -l git_prompt_color green

    # git branch outputs lines, the current branch is prefixed with a *
    set -l branch (git branch --no-color ^&- | awk '/^\*/ {print $2}')

     # Get the status of the working directory. Are there dirty files?
    git diff --quiet HEAD 2>&1

    if test $status = 1
        set_color $git_prompt_color
        printf '%s' $branch
        set_color red
        printf ' Δ'
        set_color normal
    else
        printf '%s%s%s' (set_color $git_prompt_color) $branch (set_color normal)
    end
end
