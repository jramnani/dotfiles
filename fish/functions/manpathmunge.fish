function manpathmunge -d "Add a directory to the MANPATH if it doesn\'t exist. Can use second arg, 'after' to append. Default is prepend."
  if test -d $argv[1]
    if not contains $argv[1] $MANPATH
      if test $argv[2] = "after"
        set -gx MANPATH $MANPATH "$argv[1]"
      else
        set -gx MANPATH "$argv[1]" $MANPATH
      end
    end
  end
end
