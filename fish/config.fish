# Fish major version. For detecting backwards incompatible changes.
set -x MY_FISH_MAJOR_VERSION (string split . $version | head -n 1)

# On what OS are we running?
switch (uname -s)
    case "Linux"
        set -gx MYOS "Linux"
    case "SunOS"
        set -gx MYOS "Solaris"
    case "Darwin"
        set -gx MYOS "OSX"
    case "FreeBSD"
        set -gx MYOS "FreeBSD"
    case "OpenBSD"
        set -gx MYOS "OpenBSD"
    case "CYGWIN_NT-5.1"
        set -gx MYOS "Cygwin"
    case '*'
        set -gx MYOS "Unknown"
end


# Set BROWSER for the 'help' command.
set -x BROWSER "open -a 'Safari'"

# Shell configuration
set -gx FIGNORE .svn .git .hg .pyc .pyo .o

# My preferred locale
set -gx LC_ALL 'en_US.UTF-8'

# Editing and viewing files
set -gx PAGER less
set -gx EDITOR vim

# Pager
set -gx LESS '--ignore-case --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'

# Prompt
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_char_dirtystate 'Δ'
set -g ___fish_git_prompt_color_branch (set_color blue)
set -g ___fish_git_prompt_color_branch_done (set_color normal)


# Aliases
alias c 'clear'
alias df 'df -ah'
alias g 'egrep --color=auto -i'
alias j 'jobs'
alias m $PAGER
alias l 'ls -lhF'
alias ll 'ls -alhF'
alias lt 'ls -lhFtr'

# OS specific aliases
if [ $MYOS = "OSX" ]
  alias vmstat 'vm_stat'
end


## Path
# Set the PATH on OS X using /etc/paths like /usr/libexec/path_helper would.
if [ $MYOS = "OSX" ]
    # Fish version > 3.x loads paths correctly on macOS / OS X.
    if test $MY_FISH_MAJOR_VERSION -lt 3
        echo "Loading paths from /etc/paths..."
        load_path_helper_paths
    end
end

# Third-party packages. Using Homebrew on OS X.
for p in /usr/local/{bin,sbin}
  pathmunge p
end

# My bin dir
pathmunge $HOME/bin

# Configure MANPATH on OS X
if [ $MYOS = 'OSX' ]
    for p in (cat /etc/manpaths)
        manpathmunge "$p"
    end

    for path_file in /etc/manpaths.d/*
        for p in (cat "$path_file")
            manpathmunge "$p" after
        end
    end
end


# Set the shell's greeting.
set fish_greeting (fish_greeting)


## Python
# Use my Python startup file.
set -x PYTHONSTARTUP ~/.pythonrc

# Don't override my prompt. I put the virtualenv where I want it in fish_prompt.
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# Virtualfish: a Virtualenvwrappper equivalent for Fish.
# https://github.com/adambrenecki/virtualfish
# This config must happen after path munging is complete.
set -gx VIRTUALFISH_HOME $HOME/.local/share/virtualenvs/
set -gx PROJECT_HOME $HOME/code
# Use compat aliases to help my muscle memory for now.
set -gx VIRTUALFISH_COMPAT_ALIASES 1
# Disable auto_activation plugin while I figure out how to make it play nice with Pipenv
#set -l VIRTUALFISH_PLUGINS auto_activation compat_aliases projects
set -l VIRTUALFISH_PLUGINS compat_aliases projects

if begin which python3 >/dev/null 2>&1; and python3 -m virtualfish >/dev/null 2>&1; end
    eval (python3 -m virtualfish $VIRTUALFISH_PLUGINS)
end


# Source local machine-specific file.
if test -f $HOME/.machinerc.fish
    . $HOME/.machinerc.fish
end
