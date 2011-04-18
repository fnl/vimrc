" This must be first, because it changes other options as side effect
set nocompatible

" One-liners
set cul " highlights current line
set hidden " change buffers w/o saving
set listchars=tab:→⋅,trail:⋅,eol:¬,extends:∴,nbsp:∙
set scrolloff=3 " start scrolling a bit earlier
set sidescrolloff=10 " Keep 5 lines at the size
set undolevels=1000 " tons of undos
set showmatch " jump to matching parens when inserting
set history=100 " a bit more history
set visualbell " stop dinging!!!
set shortmess=atI " short (a), truncate file (t), and no intro (I) messages
" set matchtime=5 " 10ths/sec to jumpt to matching brackets
" set number " shows line numbers - set in gvimrc

" Allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Let vim switch to paste mode, disabling all kinds of smartness and just
" paste a whole buffer of text
set pastetoggle=<F2>

" Set exec-bit on files that start with a she-bang line
au BufWritePost * if getline(1) =~ "^#!" | silent !chmod +x <afile>

" Un-nerf searches
set incsearch " highlight search phrases
set hlsearch " keep the search highlighted when going through them
set ignorecase " ignore case in seraches...
set smartcase " ...but only if there is no capital letter present

" Enable extended % matching (if/elsif/else/end) and SGML tags
runtime macros/matchit.vim

" Syntax highlighting and filetype-dependent indent
filetype on
filetype plugin indent on
syntax enable

" Command line completion
set wildmenu " turn on command line completion wild style
set wildignore=*.dll,*.o,*.obj,*.pyc,*.pyo,*.jpg,*.gif,*.png,*.swp,*.bak,*.class
set wildmode=list:longest " and show everything possible

" Status line
set statusline=%n:%f%m%r%h%w\ (%{&ff}){%Y}\ %=[0x\%02.2B][%03l,%02v][%02p%%]
set laststatus=2 " show the statusline always

" Tab handling
set autoindent " indent files
set copyindent " copy the previous indetation on autoindenting
au FileType text set noautoindent
set expandtab " no real tabs
au FileType text set noexpandtab
set smarttab " insert blanks using shiftwidth; off uses (soft)tabstop
set shiftwidth=2 " for smarttab
set softtabstop=2 " number of spaces to use when editing tabs
au FileType text set softtabstop=0

" Code folding
set foldenable
set foldmarker={,} " when foldmethod marker is used
set foldmethod=indent " fold based on... indent, marker, syntax
set foldlevel=5 " default fold level (20 is max level for indent)
set foldminlines=2 " num lines to not fold
set foldnestmax=5 " fold max depth (20 is max for indent)

" Store backups into special dirs
set nobackup " by default, ignore backups - swaps are good enough
set backupdir=~/.vim/backup " backup files
set directory=~/.vim/tmp " swap files

" Tell Rgrep not to use Xargs on Mac OS 'cause it sucks.
let s:os = system("uname")
if s:os =~ "Darwin"
  let g:Grep_Xargs_Options='-0'
endif

" Mappings -- remember S-Space does not work on Mac :(
let mapleader=","

" use ; directly instead of <S-;> to run commands
nnoremap ; :

" better movement through files
nnoremap <Space> <C-f>
nnoremap <S-Space> <C-b>

" make commands and moving through errors
nmap <F7> :cprevious<CR>
nmap <F8> :make<CR>
nmap <F9> :cnext<CR>

" serch word under cursor in current dir
nnoremap <C-S-f> :Rgrep<CR>
nnoremap <C-f> :Grep<CR>

" delete all trailing whitespaces in the buffer when using BS in visual mode
vnoremap <BS> :<BS><BS><BS><BS><BS>%s/\s\+$//ge<CR>

" scroll viewport a bit fater
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" toggle showing list characters (tab, trail, eol)
nmap <silent> <leader>l :set nolist!<CR>
" toggle linenumbering
nnoremap <leader>n :set nonumber!<CR>
" toggle the NERDTree plugin
nmap <silent> <leader>tt :NERDTreeToggle<CR>

" have <Tab> (and <Shift>+<Tab>) change the level of indentation:
inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>

" emacs style autocomplete
inoremap <C-/> <C-N>

" switch to last buffer faster
nnoremap tt :b#<CR>
" switch between adjacent buffers
nnoremap tp :bp<CR>
nnoremap tn :bn<CR>

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Disable arrow keys to force myself using the right keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Clear serach highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Switch to sudo vim <file> **after** opening a file
cmap w!! w !sudo tee % > /dev/null

" PYTHON SETUP

" Update shiftwidth/softtabstop
au BufRead,BufNewFile *.py set shiftwidth=4
au BufRead,BufNewFile *.py set softtabstop=4

" Python make commands
autocmd BufRead *.py set makeprg=python3\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Python code checks and tests
autocmd BufRead *.py nmap <S-t> :!py.test-3.1 -s --doctest-modules --nocapturelog %<CR>
autocmd BufRead *.py nmap <F5> :!python3 %<CR>
autocmd BufRead *.py nmap <S-f> :!pyflakes3k %<CR>

" Pytest.vim and py.test
autocmd BufRead *.py nmap <silent><Leader>tf <Esc>:Pytest file<CR>
autocmd BufRead *.py nmap <silent><Leader>tc <Esc>:Pytest class<CR>
autocmd BufRead *.py nmap <silent><Leader>tm <Esc>:Pytest method<CR>
autocmd BufRead *.py nmap <silent><Leader>ts <Esc>:Pytest session<CR>
autocmd BufRead *.py nmap <silent><Leader>tn <Esc>:Pytest next<CR>

" Only save python files after syntax check
" When writing Python file check the syntax
au! BufWriteCmd *.py call CheckPythonSyntax()
function CheckPythonSyntax()
  " Write the current buffer to a temporary file, check the syntax and
  " if no syntax errors are found, write the file
  let compiler = "python3"
  let curfile = bufname("%")
  let tmpfile = tempname()
  silent execute "write! ".tmpfile
  let output = system("python3 -c \"__import__('py_compile').compile(r'".tmpfile."')\" 2>&1")
  if output != ''
    " Make sure the output specifies the correct filename
    let output = substitute(output, fnameescape(tmpfile), fnameescape(curfile), "g")
    echo output
  else
    write
  endif
  " Delete the temporary file when done
  call delete(tmpfile)
endfunction

" Text expansion - iabbrev
autocmd BufRead *.py iabbrev ifmain if __name__ == '__main__':
autocmd BufRead *.py iabbrev definit def __init__(self,
autocmd BufRead *.py iabbrev defdel def __del__(self,
autocmd BufRead *.py iabbrev defcall def __call__(self,
autocmd BufRead *.py iabbrev defiter def __iter__(self,
autocmd BufRead *.py iabbrev defnext def __next__(self,
