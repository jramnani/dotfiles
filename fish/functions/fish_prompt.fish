function fish_prompt --description 'Write out the prompt'

# Just calculate these once, to save a few cycles when displaying the prompt
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __fish_prompt_cwd
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

    if test -z (git branch --quiet 2>| awk '/fatal:/ {print "no git"}')
       printf '%s%s%s (%s)\n%s@%s $ ' "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" (parse_git_branch) (whoami) $__fish_prompt_hostname
    else
       printf '%s%s%s\n%s@%s $ ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (whoami) (hostname|cut -d . -f 1)
    end

end

