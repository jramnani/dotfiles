function pathmunge -d "Add a directory to the PATH if it doesn\'t exist. Can use second arg, 'after' to append. Default is prepend."
  if test -d $argv[1]
    if not contains $argv[1] $PATH
      if test $argv[2] = "after"
        set -gx PATH $PATH "$argv[1]"
      else
        set -gx PATH "$argv[1]" $PATH
      end
    end
  end
end
