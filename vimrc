"------------------------------------------------------------------------------
" File: $HOME/.vimrc
" Author: Uwe Hermann <uwe@hermann-uwe.de>
" URL: http://www.hermann-uwe.de/files/vimrc
" Modified by: Jeff Ramnani
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" Standard stuff.
"------------------------------------------------------------------------------

" Needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off 
" Use Pathogen plugin to load all other plugins
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

set nocompatible        " Disable vi compatibility.
set nobackup            " Do not keep a backup file.
set number              " Show line numbers.
set history=100         " Number of lines of command line history.
set undolevels=200      " Number of undo levels.
set textwidth=0         " Don't wrap words by default.
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set ignorecase          " Case insensitive matching.
set incsearch           " Incremental search.
set scrolloff=5         " Keep a context when scrolling.
set noerrorbells        " No beeps.
set tabstop=4           " Number of spaces <tab> counts for.
set shiftwidth=4        " number of spaces the lines will be shifted with >> or << 
set softtabstop=4       " makes VIM see multiple space characters as tabstops, 
                        "  and so <BS> does the right thing
set expandtab           " Use spaces instead of <tab> when using the <Tab> key.
set smarttab            " Allows you to backspace through a unit of shiftwidth.
set ttyscroll=0         " Turn off scrolling (this is faster).
set ttyfast             " We have a fast terminal connection.
set hlsearch            " Highlight search matches.
set foldmethod=marker   " Set markers for manual folding. Hopefully this won't 
                        "  b0rk default filetype folding behavior.
set encoding=utf-8      " Set default encoding to UTF-8.
set nostartofline       " Do not jump to first character with page commands,
                        " i.e., keep the cursor in the current column.
set viminfo='20,\"50    " Read/write a .viminfo file, don't store more than
                        " 50 lines of registers.
set splitright          " Vertical splits open new buffer on the right.

" Set mapleader (a.k.a. <Leader>).  Default is "\". 
let mapleader=","

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Tell vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
set listchars=tab:>-,trail:·,eol:$

" Path/file expansion in command-mode.
set wildmode=list:longest
set wildchar=<TAB>

" Enabled file type detection, file-type specific plugins, and indent
" plugins.
filetype plugin indent on

" Enable syntax-highlighting.
if has("syntax")
  syntax on
endif

" Set color scheme based on the background of your terminal.
if &term =~ "xterm"
  set background=light
endif

"------------------------------------------------------------------------------
" Buffer behavior.
"------------------------------------------------------------------------------

" Move between buffers using <Ctrl+h> and <Ctrl+l>. Minimize the other buffers when switching betw them.
nmap <c-h> <c-w>h<c-w><bar>
nmap <c-l> <c-w>l<c-w><bar>
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

"------------------------------------------------------------------------------
" Function keys.
"------------------------------------------------------------------------------

" F1: Toggle hlsearch (highlight search matches).
nmap <F1> :set hls!<CR>
" Unmap  the shortcut for help. In fact, map it to Esc, so my typo changes from
" a bug into a feature.
" map <F1> <Esc>
imap <F1> <Esc>



" F2: Toggle list (display unprintable characters).
nnoremap <F2> :set list!<CR>

" F3: Toggle expansion of tabs to spaces.
nmap <F3> :set expandtab!<CR>

"------------------------------------------------------------------------------
" Correct typos.
"------------------------------------------------------------------------------

" English.

iab beacuse    because
iab becuase    because
iab acn        can
iab cna        can
iab centre     center
iab chnage     change
iab chnages    changes
iab chnaged    changed
iab chnagelog  changelog
iab Chnage     Change
iab Chnages    Changes
iab ChnageLog  ChangeLog
iab debain     debian
iab Debain     Debian
iab definately definitely
iab defualt    default
iab Defualt    Default
iab differnt   different
iab diffrent   different
iab emial      email
iab Emial      Email
iab figth      fight
iab figther    fighter
iab fro        for
iab fucntion   function
iab ahve       have
iab homepgae   homepage
iab hte        the
iab inot       into
iab logifle    logfile
iab lokk       look
iab lokking    looking
iab mial       mail
iab Mial       Mail
iab miantainer maintainer
iab amke       make
iab mroe       more
iab nwe        new
iab recieve    receive
iab recieved   received
iab erturn     return
iab retrun     return
iab retunr     return
iab seperate   separate
iab shoudl     should
iab soem       some
iab taht       that
iab thta       that
iab teh        the
iab tehy       they
iab truely     truly
iab waht       what
iab wiht       with
iab whic       which
iab whihc      which
iab yuo        you
iab databse    database
iab versnio    version
iab obnsolete  obsolete
iab flase      false
iab recrusive  recursive
iab Recrusive  Recursive

" Days of week.
iab monday     Monday
iab tuesday    Tuesday
iab wednesday  Wednesday
iab thursday   Thursday
iab friday     Friday
iab saturday   Saturday
iab sunday     Sunday

" Enable this if you mistype :w as :W or :q as :Q.
" nmap :W :w
" nmap :Q :q
" Enable this if you mistype :x as :X which can ruin your document...
nmap :X :x


"------------------------------------------------------------------------------
" Abbreviations.
"------------------------------------------------------------------------------

" My name + email address.
ab jrr Jeff Ramnani <jefframnani@yahoo.com>

"------------------------------------------------------------------------------
" HTML.
"------------------------------------------------------------------------------

" Print an empty <a> tag.
map! ;h <a href=""></a><ESC>5hi

" Wrap an <a> tag around the URL under the cursor.
map ;H lBi<a href="<ESC>Ea"></a><ESC>3hi


"------------------------------------------------------------------------------
" Plugin configuration
"------------------------------------------------------------------------------
" FuzzyFinder mapping
" Map ,f to file search.
nmap <leader>f :FufFile<CR>

" NERDTree Settings
" Enable nice colors
let NERDChristmasTree = 1
 
" Make it easy to see where we are
let NERDTreeHighlightCursorline = 1
 
" Make bookmarks visible
let NERDTreeShowBookmarks = 1
 
" Show hidden files
let NERDTreeShowHidden = 1
"Don't hijack NETRW
"let NERDTreeHijackNetrw = 0
let NERDTreeIgnore=['\.$', '\~$', '\.DS_Store', '\.pyc', '\.pyo']
 
" Make ,d open NERDTree
nmap <leader>d :NERDTreeToggle<CR>

" VimClojure settings
let clj_highlight_builtins = 1
let clj_highlight_contrib = 1
let clj_paren_rainbow = 1



"------------------------------------------------------------------------------
" File-type specific settings.
"------------------------------------------------------------------------------

if has("autocmd")
  
  " Calls to 'autocmd!' below are to clear any existing autocommands. 
  " This prevents autocommands from being run twice.

  " Makefiles
  augroup makefile
    autocmd!      
    autocmd BufRead,BufReadPre,BufNewFile          ?akefile* set filetype=make
    autocmd BufRead,BufReadPre,BufNewFile          ?akefile* set tabstop=4
    autocmd BufRead,BufReadPre,BufNewFile          ?akefile* set noexpandtab
  augroup END

  " Python code.
  augroup python
    autocmd!
    autocmd BufRead,FileReadPre,BufNewFile      *.py,*.pyw set filetype=python
  augroup END

  " Ruby code.
  augroup ruby
    autocmd!
    " Ruby coders perfer 2 spaces for tabstops.
    autocmd BufRead,FileReadPre,BufNewFile      *.rb set filetype=ruby ts=2 sw=2
    autocmd BufRead,FileReadPre,BufNewFile      [Cc]apfile set filetype=ruby ts=2 sw=2 et
    " Need to set expandtab b/c Rakefile matches rules for Makefiles, as well.
    autocmd BufRead,FileReadPre,BufNewFile      [Rr]akefile set filetype=ruby ts=2 sw=2 et
  augroup END

  " Build files for Ant, NAnt, and MSBuild
  augroup build 
    autocmd!
    " Ant
    autocmd BufRead,FileReadPre,BufNewFile      build.xml set filetype=ant
    " NAnt
    autocmd BufRead,FileReadPre,BufNewFile      *.build   set filetype=xml
    autocmd BufRead,FileReadPre,BufNewFile      *.nant    set filetype=xml
    " MSBuild / Visual Studio
    autocmd BufRead,FileReadPre,BufNewFile      *.proj    set filetype=xml
    autocmd BufRead,FileReadPre,BufNewFile      *.csproj    set filetype=xml
  augroup END
  " XML Files.
  augroup clojure 
    autocmd!
    autocmd BufRead,FileReadPre,BufNewFile     *.clj   set filetype=clojure
  augroup END
endif


"------------------------------------------------------------------------------
" Debian specific options.
"------------------------------------------------------------------------------

" We know xterm-debian is a color terminal.
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86" || &term =~ "xterm-color" || &term =~ "xterm"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

"------------------------------------------------------------------------------
" Backup files
"------------------------------------------------------------------------------

if has("win32")
    " Set the backup dir for Vim's backup files. 
    set bdir=c:\\tmp\\vim,c:\\temp\\vim
    " Set the swap dir where vim puts it's ~ files.
    set dir=c:\\tmp\\vim,c:\\temp\\vim
else
    set bdir=$HOME/tmp/vim
    set dir=$HOME/tmp/vim
endif

"------------------------------------------------------------------------------
" GUI Settings
"------------------------------------------------------------------------------
if has("gui_running")
    " Set the color scheme.
    colorscheme desert
endif

" Mac specific GUI settings.
if has("gui_macvim")
    " Set the font. 'h' = height.
    set guifont=Monaco:h14
    set guioptions=egmrt
endif

"------------------------------------------------------------------------------
" Local settings.
"------------------------------------------------------------------------------

" Source a local configuration file if available.
if $OS == "Windows_NT"
    if filereadable(expand("$HOME/_vimrc.local"))
      source $HOME\_vimrc.local
    endif
else
    if filereadable(expand("$HOME/.vimrc.local"))
      source $HOME/\.vimrc.local
    endif
endif

