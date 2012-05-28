set fish_git_dirty_color red
function parse_git_dirty 
         git diff --quiet HEAD ^&-
         if test $status = 1
            echo (set_color $fish_git_dirty_color)"Δ"(set_color normal)
         end
end
function parse_git_branch
         # git branch outputs lines, the current branch is prefixed with a *
         set -l branch (git branch --color ^&- | awk '/*/ {print $2}') 
         echo $branch (parse_git_dirty)     
end

function fish_prompt
         if test -z (git branch --quiet 2>| awk '/fatal:/ {print "no git"}')
            printf '%s@%s %s%s%s (%s) $ ' (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (parse_git_branch)            
         else
            printf '%s@%s %s%s%s $ '  (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
         end 
end

switch (uname -s)
  case "Linux"
    set -g MYOS "Linux"
  case "SunOS"
    set -g MYOS "Solaris"
  case "Darwin"
    set -g MYOS "OSX"
  case "FreeBSD"
    set -g MYOS "FreeBSD"
  case "CYGWIN_NT-5.1"
    set -g MYOS "Cygwin"
  case '*'
    set -g MYOS "Unkown"
end
  
# My preferred locale
set -g LC_ALL 'en_US.utf8'

# Aliases
alias c 'clear'
alias cp 'cp -i'
alias df 'df -ah'
alias g 'egrep -i'
alias h 'fc -l'
alias j 'jobs'
alias m $PAGER
alias mv 'mv -i'
alias l 'ls -lhF'
alias ll 'ls -alhF'
alias lt 'ls -lhFtr'
alias rm 'rm -i'
 

# Path
# Assuming OSX for now.
set -g BASE_PATH /usr/local/bin /usr/bin /usr/sbin /bin /sbin

