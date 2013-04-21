# My prompt should look as follows:
#   (virtualenv) pwd (git branch)
#   username@host $
function fish_prompt -d "Write out the prompt"
  # Python Virtualenv
  if set -q VIRTUAL_ENV
    printf '%s(%s)%s ' (set_color blue) (basename $VIRTUAL_ENV)
  end

  # Color writeable dirs green, read-only dirs red
  if test -w "."
    printf '%s%s%s' (set_color green) (prompt_pwd) (set_color normal)
  else
    printf '%s%s%s' (set_color red) (prompt_pwd) (set_color normal)
  end

  # Print git branch
  if test -d ".git"
    printf ' (%s)\n' (parse_git_branch)
  else
    printf '\n'
  end

  printf '%s%s@%s%s [%s] $ ' (set_color normal) (whoami) (hostname|cut -d . -f 1) (set_color normal) $vi_mode

end

