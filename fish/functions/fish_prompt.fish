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
		printf '%s%s' (set_color green) (prompt_pwd)
	else
		printf '%s%s' (set_color red) (prompt_pwd)
	end

	# Print git branch
	if test -d ".git"
		printf ' %s(%s)%s\n' (set_color blue) (parse_git_branch) (set_color normal)
  else
    printf '\n'
	end

	printf '%s%s@%s%s $ ' (set_color normal) (whoami) (hostname|cut -d . -f 1) (set_color normal) 

end

