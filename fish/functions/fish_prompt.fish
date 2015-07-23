# My prompt should look as follows:
#   (virtualenv) pwd (git branch)
#   username@host $
function fish_prompt -d "Write out the prompt"
  # Python Virtualenv
  if set -q VIRTUAL_ENV
    printf '%s(%s)%s ' (set_color blue) (basename $VIRTUAL_ENV) (set_color normal)
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

  printf '%s%s@%s%s $ ' (set_color normal) (whoami) (hostname|cut -d . -f 1) (set_color normal)
end
