function parse_git_branch
         # git branch outputs lines, the current branch is prefixed with a *
         set -l branch (git branch --color ^&- | awk '/^*/ {print $2}') 
         echo $branch (parse_git_dirty)     
end
