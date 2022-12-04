" == FILES & BUFFERS ==

set hidden " Change buffers w/o saving - essential
set nofixendofline " Prevent vim from auto-adding newlines to files

silent !mkdir -p ~/.vim/backup
set backupdir=~/.vim/backup

silent !mkdir -p ~/.vim/tmp
set directory^=~/.vim/tmp/ " ^= prepends this directory

set autowriteall " Save buffer on a plethora of commands, including quitting vim

" == UX ==

" Enable filetype detection
filetype plugin indent on " Load indention rules for specific file type

" Enable syntax-specific functionality
syntax enable
set autoindent " indent next line same way as current line
set smartindent " expand autoindent functions to take syntax into account
set foldmethod=syntax " based on syntax (e.g., JSON folding works out of the box)

" Essentials
set scrolloff=1 " Start vertical scrolling a bit earlier
set sidescrolloff=9 " Scroll at n colums before the side margin in nowrap mode
set undolevels=1000 " Tons of undos
set history=100 " A bit more history
set visualbell " Stop dinging me

" Command line completion
set wildmenu " turn on enhanced command line completion with tab
" but ignore files that are sure to be binaries:
set wildignore=*.dll,*.o,*.obj,*.pyc,*.pyo,*.jpg,*.gif,*.png,*.swp,*.class
set wildmode=list:longest " and show every possible completion

" Write in sudo mode after opening a file
cmap w!! w !sudo tee % > /dev/null

" Delete all trailing whitespaces when using BS in visual mode
vnoremap <BS> :<BS><BS><BS><BS><BS>%s/\s\+$//ge<CR>

" Remap C-t (back) in help navigation to something intuitive: C-[ matching C-]
au filetype help nnoremap <buffer> <C-[> <C-t>

" Delete the last buffer by moving to the previous one
" and then deleting the "alternate file" (#), to close a buffer without
" eliminating the split window - using C-c
nnoremap <C-c> :bp\|bd #<CR>

" Use the system clipboard
set clipboard+=unnamedplus

" == SEARCH ==

set ignorecase " Ignore case when searching
set smartcase " But try to be smart about cases if uppercase is used
set incsearch " Highligth while typing searches
set hlsearch " And highlight search results

" == DISPLAY ==

colorscheme desert
set background=dark
set showmatch " Show matching brackets when text indicator is over them
set laststatus=2 " Always show the status line
set listchars=tab:→⋅,trail:⋅,eol:¬,extends:➧,precedes:←,nbsp:∙ " Invisibles definitions
set showbreak=↯ " Invisible for wrapped lines
set linebreak " wrap at word boundaries (breakat), not within words, if possible

" Status line config
" %buffer_number:%file_name
" flags: m=modified r=readonly h=help w=preview_window
" [fileencoding](fileformat){filetype}
" [byteval_under_cursor][line_number,virtual_col_number][percentage_in_file]
set statusline=%n:%f%m%r%h%w\ [%{&spelllang}.%{&fenc==\"\"?&enc:&fenc}](%{&ff}){%Y}\ %=[0x\%02.5B][%03l,%02v][%02p%%]

" == SPELLING ==

" Enable spell checking in text files
au FileType text,mail,rst,mkd,markdown,tex setlocal spell spelllang=en_us
au FileType help setlocal nospell " unless it's a help file
hi SpellBad cterm=underline ctermbg=none
hi SpellCap cterm=underline ctermbg=none
hi SpellRare cterm=underline ctermbg=none
hi SpellLocal cterm=underline ctermbg=none
