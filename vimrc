" One-liners
set cul " highlights current line
set hidden " change buffers w/o saving
set listchars=tab:→⋅,trail:⋅,eol:¬
set scrolloff=3 " start scrolling a bit earlier
set sidescrolloff=10 " Keep 5 lines at the size
set showmatch " jump to matching parens when inserting
set history=100 " a bit more history
set visualbell " stop dinging!!!
set shortmess=atI " short (a), truncate file (t), and no intro (I) messages
" set matchtime=5 " 10ths/sec to jumpt to matching brackets
" set number " shows line numbers

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
set wildignore=*.dll,*.o,*.obj,*.pyc,*.jpg,*.gif,*.png
set wildmode=list:longest " and show everything possible

" Status line
set statusline=%f%m%r%h%w\ (%{&ff}){%Y}\ %=[0x\%02.2B][%03l,%02v][%02p%%]
set laststatus=2 " show the statusline always

" Tab handling
set autoindent " indent files
au FileType text set noautoindent
set expandtab " no real tabs
au FileType text set noexpandtab
set smarttab " insert blanks using shiftwidth; off uses (soft)tabstop
" set shiftwidth=2 " for smarttab
set softtabstop=2 " number of spaces to use when editing tabs
au FileType text set softtabstop=0
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

" Tell Rgrep not to use Xargs on Mac OS 'cause it sucks.
let s:os = system("uname")
if s:os =~ "Darwin"
  let g:Grep_Xargs_Options='-0'
endif

" Mappings -- remember S-Space does not work on Mac :(
" better movement through files
nnoremap <Tab> <C-b>
nnoremap <Space> <C-f>
" serch word under cursor in current dir
nnoremap <C-f> :Rgrep<CR>
" delete all trailing whitespaces in the buffer
nnoremap <silent> <BS> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
" scroll viewport a bit fater
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
" toggle showing list characters (tab, trail, eol)
nmap <silent> <leader>s :set nolist!<CR>
