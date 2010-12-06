" One-liners
set cul " highlights current line
set hidden " change buffers w/o saving
set incsearch " highlight search phrases
set hlsearch " keep the search highlighted when going through them
set listchars=tab:>-,trail:- " show tabs and trailing
set scrolloff=10 " Keep 10 lines (top/bottom) for scope
set sidescrolloff=10 " Keep 5 lines at the size
set showmatch " jump to matching parens when inserting
" set matchtime=5 " 10ths/sec to jumpt to matching brackets
" set number " shows line numbers

" Syntax highlighting and filetype-dependent indent
filetype on
filetype plugin indent on
syntax enable

" Remove any trailing whitespace in the file
" autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Command line completion
set wildmenu " turn on command line completion wild style
set wildignore=*.dll,*.o,*.obj,*.pyc,*.jpg,*.gif,*.png
set wildmode=list:longest " and show everything possible

" Status line
set statusline=%f%m%r%h%w\ (%{&ff}){%Y}\ %=[0x\%02.2B][%03l,%02v][%02p%%]
set laststatus=2 " show the statusline always

" Tab handling
set autoindent " indent files
set expandtab " no real tabs
set smarttab " insert blanks using shiftwidth; off uses (soft)tabstop
set shiftwidth=2 " for smarttab
set softtabstop=2 " number of spaces to use when editing tabs
" Update shiftwidth/softtabstop for some filetypes
au BufRead,BufNewFile *.py set shiftwidth=4
au BufRead,BufNewFile *.py set softtabstop=4

" Code folding
set foldenable
set foldmarker={,} " when foldmethod marker is used
set foldmethod=indent " fold based on... indent, marker, syntax
set foldlevel=1 " default fold level (20 is max level for indent)
set foldminlines=2 " num lines to not fold
set foldnestmax=3 " fold max depth (20 is max for indent)

" Store backups into special dirs
set backup
set backupdir=~/.vim/backup " backup files
set directory=~/.vim/tmp " swap files

" Mappings - S-Space does not work on Mac :(
noremap <S-Space> <C-b>
noremap <Space> <C-f>

