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

" Pathogen expects a Bourne compatible shell.
if $SHELL =~ "fish"
  "echomsg "Detected SHELL =~ fish. Manually setting it to bash."
  set shell=/usr/bin/env\ bash
endif

" Use Pathogen plugin to load all other plugins
call pathogen#infect()

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
set ignorecase          " Ignore case sensitivity in searches.
set smartcase           " ignore case if search pattern is all lowercase,
                        " case-sensitive otherwise. Depends on ignorecase.
set incsearch           " Incremental search.
set scrolloff=5         " Keep a context when scrolling.
set noerrorbells        " No beeps.
set tabstop=2           " Number of spaces <tab> counts for.
set shiftwidth=2        " number of spaces the lines will be shifted with >> or <<
set softtabstop=2       " makes VIM see multiple space characters as tabstops,
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
set splitbelow          " Horizonal splits open new buffer below.
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

" When scrolling up and down with line wrapping enabled, scroll using
" editor lines, instead of actual newlines. (more natural scrolling)
nnoremap j gj
nnoremap k gk

"------------------------------------------------------------------------------
" Function keys.
"------------------------------------------------------------------------------

" F1: Toggle hlsearch (highlight search matches).
nmap <F1> :set hls!<CR>
" Unmap  the shortcut for help. In fact, map it to Esc, so my typo changes from
" a bug into a feature.
imap <F1> <Esc>

" F2: Toggle list (display unprintable characters).
nnoremap <F2> :set list!<CR>

" F3: Toggle paste mode
set pastetoggle=<F3>

" F4: Toggle line numbers
nnoremap <F4> :set number!<CR>

" F5: Reload vimrc
nnoremap <F5> :source $MYVIMRC<CR>

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
iab lenght     length
iab logifle    logfile
iab lokk       look
iab lokking    looking
iab mial       mail
iab Mial       Mail
iab miantainer maintainer
iab amke       make
iab mroe       more
iab nwe        new
iab pyton      python
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

" Enable these if you mistype :w as :W or :q as :Q.
nmap :W :w
" I never use 'Ex' mode. Intentionally.
nmap :Q :q
" Enable this if you mistype :x as :X.
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

" Ctrlp
" Recycle my old mappings for Command-t and BufExplorer until I get used to
" how Ctrlp does things.
nmap <leader>be :CtrlPBuffer<CR>

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
" Ignoring: dotfiles, vim backup files, OS X droppings, Python bytecode,
" Go compiler output.
let NERDTreeIgnore=[
      \ '\.$',
      \ '\~$',
      \ '\.DS_Store',
      \ '\.o$',
      \ '\.pyc$',
      \ '\.pyo$',
      \ '.Python',
      \ '__pycache__',
      \ '\.8$',
      \ '\.6$'
\ ]

" Make ,d open NERDTree
nmap <leader>d :NERDTreeToggle<CR>

" lightline - lightweight fancy status line.
" Configure Vim to show a status bar even if only one window is showing.
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }



" VimClojure settings
let g:clojure_fuzzy_indent = 1

"------------------------------------------------------------------------------
" File-type specific settings.
"------------------------------------------------------------------------------

if has("autocmd")

  " Calls to 'autocmd!' below are to clear any existing autocommands.
  " This prevents autocommands from being run twice.

  " Build files for Ant, NAnt, and MSBuild
  augroup build
    autocmd!
    " Ant
    autocmd BufRead,FileReadPre,BufNewFile      build.xml setlocal filetype=ant
    " NAnt
    autocmd BufRead,FileReadPre,BufNewFile      *.build   setlocal filetype=xml
    autocmd BufRead,FileReadPre,BufNewFile      *.nant    setlocal filetype=xml
    " MSBuild / Visual Studio
    autocmd BufRead,FileReadPre,BufNewFile      *.proj    setlocal filetype=xml
    autocmd BufRead,FileReadPre,BufNewFile      *.csproj  setlocal filetype=xml
  augroup END

  augroup rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme  RainbowParentheses
  augroup END

  augroup css
    autocmd!
    autocmd BufRead,FileReadPre,BufNewFile     *.less setlocal filetype=css
  augroup END

  augroup fish
    autocmd!
    autocmd BufRead,FileReadPre,BufNewFile     *.fish setlocal filetype=fish
  augroup END

  " Go code
  " Go coders prefer tabs to spaces.
  augroup golang
    autocmd!
    autocmd BufRead,FileReadPre,BufNewFile     *.go setlocal filetype=go noexpandtab smartindent
  augroup END

  " Git - Commit msgs use a yellow font which is unreadable on a light
  " background.
  " Short term hack until I fix my .gitconfig file.
  " Readability hack provided by: http://shallowsky.com/blog/linux/editors/vim-light-colors.html
  augroup git
    autocmd!
    autocmd BufRead,FileReadPre,BufNewFile     *.git/* setlocal t_Co=256
  augroup END

  augroup javascript
    autocmd!
    autocmd BufRead,BufReadPre,BufNewFile   *.json setlocal filetype=javascript
  augroup END

  " Jinja templates
  augroup jinja
    autocmd!
    autocmd BufRead,BufReadPre,BufNewFile          *.j2 setlocal filetype=htmljinja
    autocmd BufRead,BufReadPre,BufNewFile          *.jinja setlocal filetype=htmljinja
    autocmd BufRead,BufReadPre,BufNewFile          *.jinja2 setlocal filetype=htmljinja
  augroup END

  " Makefiles
  augroup makefile
    autocmd!
    autocmd BufRead,BufReadPre,BufNewFile          Makefile* setlocal filetype=make
    autocmd FileType make setlocal tabstop=4
    autocmd FileType make setlocal noexpandtab
  augroup END

  " Mako templates
  augroup mako
    autocmd!
    autocmd BufRead,BufReadPre,BufNewFile          *.mako setlocal filetype=mako
  augroup END

  " Python code.
  augroup python
    autocmd!
    autocmd BufRead,FileReadPre,BufNewFile      *.py,*.pyw setlocal filetype=python
    autocmd BufRead,FileReadPre,BufNewFile      pythonrc setlocal filetype=python
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  augroup END

  " Ruby code.
  augroup ruby
    autocmd!
    autocmd BufRead,FileReadPre,BufNewFile      *.rb setlocal filetype=ruby
    autocmd BufRead,FileReadPre,BufNewFile      [Cc]apfile setlocal filetype=ruby
    autocmd BufRead,FileReadPre,BufNewFile      [Rr]akefile setlocal filetype=ruby
    autocmd BufRead,FileReadPre,BufNewFile      [Vv]agrantfile setlocal filetype=ruby
    " Ruby coders perfer 2 spaces for tabstops.
    autocmd FileType ruby  setlocal tabstop=2 shiftwidth=2 expandtab
  augroup END

endif


"------------------------------------------------------------------------------
" Terminal options.
"------------------------------------------------------------------------------

" We know xterm-debian is a color terminal.
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Use 256 colors if our terminal supports them.
if &term =~ "xterm-256color"
  set t_Co=256
  set t_AB=[48;5;%dm
  set t_AF=[38;5;%dm
endif

" Set color scheme based on the background of your terminal.
if &term =~ "xterm" || &term =~ "screen"
  set background=dark
  colorscheme solarized
endif


"------------------------------------------------------------------------------
" Backup files
"------------------------------------------------------------------------------

if has("win32")
    set backupdir=$HOME\\tmp\\vim\\backups\\   " backups
    set directory=$HOME\\tmp\\vim\\swap\\      " swap files
    if has("persistent_undo")
      set undodir=$HOME\\tmp\\vim\\undo\\        " undo files
    endif
else
    set backupdir=$HOME/tmp/vim/backup//
    set directory=$HOME/tmp/vim/swap//
    if has("persistent_undo")
      set undodir=$HOME/tmp/vim/undo//
      set undofile
    endif
endif

" Create backup folders if they don't exist.
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif

if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif

if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif


"------------------------------------------------------------------------------
" GUI Settings
"------------------------------------------------------------------------------
if has("gui_running")
    " Set the color scheme.
    set background=dark
    colorscheme solarized
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
