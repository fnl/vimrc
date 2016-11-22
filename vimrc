" ===================
" A VIM CONFIGURATION
" ===================
"
" by Florian Leitner <florian.leitner@gmail.com>
"
" Should be used in conjunction with an accompanying setup.sh file.

" These two must be first, because it changes other options as side effect
set nocompatible " disable vi compatibility
set hidden " change buffers w/o saving - essential

" VIM PLUG
" ========

" https://github.com/junegunn/vim-plug
" to set up Plug itself:
" $ mkdir -p ~/.vim/autoload
" $ curl -fLo ~/.vim/autoload/plug.vim \
"        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')
Plug 'craigemery/vim-autotag' " update entries in tag files on saves
Plug 'kien/ctrlp.vim' " [open] files: '<Leader>o' and buffer: '<Leader>b' navigation
Plug 'Lokaltog/vim-easymotion' " jump around ('<number>w', etc.): '<Leader>j'
Plug 'tpope/vim-fugitive' " git commands: ':G'...
Plug 'vim-scripts/Go-Syntax' " syntax file for Golang
Plug 'sjl/gundo.vim' " visual undo tree: '<Leader>u'
Plug 'davidhalter/jedi-vim' " Python code editing
Plug 'Shutnik/jshint2.vim' " JavaScript IDE (hints and lint)
Plug 'edsono/vim-matchit' " extended % matching
Plug 'plasticboy/vim-markdown' " Markdown support
Plug 'alfredodeza/pytest.vim' " support for py.test
Plug 'fs111/pydoc.vim' " python documentation viewer
Plug 'ervandew/supertab' " tab completion
Plug 'tpope/vim-surround' " change surrounding a->b: 'csab' add surrounding ...: 'ysiw'...
Plug 'scrooloose/syntastic' " automatic syntax checking
Plug 'majutsushi/tagbar' " display the current tags: '<Leader>T'
Plug 'vim-scripts/taglist.vim' " display the current tags: '<Leader>t'
Plug 'scrooloose/nerdcommenter' " toggle comments: '<Leader>c<space>'
Plug 'scrooloose/nerdtree' " file system directory: '<Leader>d'
Plug 'Chiel92/vim-autoformat' " use external formatting programs to arrange code
Plug 'pangloss/vim-javascript' " JavaScript syntax
Plug 'jcfaria/Vim-R-plugin' " R IDE
Plug 'matze/vim-tex-fold' " LaTeX document folding
Plug 'derekwyatt/vim-scala' " Scala syntax
Plug 'megaannum/vimside' " Scala IDE
Plug 'tpope/vim-unimpaired' " quickfix q/arglist a/loclist l/taglist t navigation
Plug 'nelstrom/vim-qargs' " adds the Qargs command to replace the arglist with quickfix files
Plug 'akhaku/vim-java-unused-imports' " remove unused Java imports with :UnusedImports...
" Plug 'justmao945/vim-clang' " C++ code completion
" Plug 'Rip-Rip/clang_complete' " Autocompleteion for C, C++, ObjC, and ObjC++ - ONLY FOR :Py2!
Plug 'myint/clang-complete' " Autocompleteion for C, C++, ObjC, and ObjC++ - for both :Py2 and :Py3
Plug 'peterhoeg/vim-qml' " QML syntax highlighting
" Plug 'mattn/emmet-vim' " abbreviation expansion with '<C-y>
call plug#end()

" BASIC CONFIGURATION
" ===================

set listchars=tab:→⋅,trail:⋅,eol:¬,extends:➧,nbsp:∙ " invisibles definitions
set scrolloff=3 " start vertical scrolling a bit earlier
set sidescrolloff=3 " scroll at n colums before the side margin in nowrap mode
set wrap linebreak nolist " (do not) wrap lines, only using a display-based wrap
set undolevels=1000 " tons of undos
set showmatch " jump to matching parens when inserting
set history=100 " a bit more history
set visualbell " stop dinging
set shortmess=atI " short (a), truncate file (t), and no intro (I) messages
set matchtime=5 " 10ths/sec to jump to matching brackets
set nonumber " show/hide line numbers
" au Filetype * set colorcolumn=99 " highlight the last column to use for ideal textwidth
au FileType text,mail,rst,mkd,tex setlocal colorcolumn=0 " unless it is plain text
" sensible text wrapping
" use 'gq' to do the wrapping
set textwidth=0
set wrapmargin=0

" Override/color settings
"colorscheme default " works best... :P
" Set colorcolumn border color
hi ColorColumn ctermbg=LightGrey guibg=LightGrey
" Un-nref parenthesis highlights so the cursor can be seen
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" Un-nerf searche and associated highlights
set incsearch " highlight search phrases
set hlsearch " keep the search highlighted when going through them
set ignorecase " ignore case in seraches...
set smartcase " ...but only if there is no capital letter present
hi Search cterm=none ctermfg=black ctermbg=yellow

" Enable spell checking in text files
au FileType text,mail,rst,mkd,tex setlocal spell spelllang=en_us 
au FileType help setlocal nospell " unless it's a help file
hi SpellBad cterm=underline ctermbg=none
hi SpellCap cterm=underline ctermbg=none
hi SpellRare cterm=underline ctermbg=none
hi SpellLocal cterm=underline ctermbg=none

" Allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Let vim switch to paste mode, disabling all kinds of smartness and just
" paste a whole buffer of text instead of regular insert behaviour
set pastetoggle=<F10>

" Syntax highlighting and filetype-dependent indenting
filetype on
filetype plugin indent on
syntax on

" Default ctag file names
set tags=./tags,tags,~/.tags

" Command line completion
set wildmenu " turn on command line completion wild style
" but ignore files that are sure to be binaries
set wildignore=*.dll,*.o,*.obj,*.pyc,*.pyo,*.jpg,*.gif,*.png,*.swp,*.class
set wildmode=list:longest " and show every possible completion

" Statusline:
" %buffer_number:%file_name
" flags: m=modified r=readonly h=help w=preview_window
" [fileencoding](fileformat){filetype}
" tagname_if_set syntastic_flag_if_relevant
" [byteval_under_cursor][line_number,virtual_col_number][percentage_in_file]
set statusline=%n:%f%m%r%h%w\ [%{&spelllang}.%{&fenc==\"\"?&enc:&fenc}](%{&ff}){%Y}\ %{Tlist_Get_Tagname_By_Line()}\ %{SyntasticStatuslineFlag()}\ %=[0x\%02.5B][%03l,%02v][%02p%%]
set laststatus=2 " show the statusline: 2=always

" Tab and indention handling
set autoindent " indent file by default
set copyindent " copy the previous indentation when autoindenting
set tabstop=2 " number of spaces to use to display tabs
set noexpandtab " (do not) replace (expand) tabs with spaces
set softtabstop=2 " number of spaces to delete/insert when editing expanded tabs
set shiftwidth=2 " number of spaces to manipulate for reindent ops (<< and >>)
" special cases
au FileType text setlocal tabstop=8 noautoindent
au FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" Code folding
set nofoldenable
set foldmarker={,} " when foldmethod marker is used
set foldmethod=syntax " fold based on... indent, marker, or syntax
" note that Python seems to work best with indent
au FileType python setlocal foldmethod=indent
set foldlevel=0 " default fold level (20 is max level for indent)
set foldminlines=2 " number of lines up to which not to fold
set foldnestmax=0 " fold max depth (20 is max for indent)

" Swap and backup settings
set backup " (do not) make backups
set backupdir=~/.vim/backup " backup files dir
set directory=~/.vim/tmp " swap files dir

" Higlight the cursorline after a jump,
" but deactivate highlight on move
function s:Cursor_Moved()
  let cur_pos = winline()
  if g:last_pos == 0
    set cul
    let g:last_pos = cur_pos
    return
  endif
  let diff = g:last_pos - cur_pos
  if diff > 1 || diff < -1
    set cul
  else
    set nocul
  endif
  let g:last_pos = cur_pos
endfunction
autocmd CursorMoved,CursorMovedI * call s:Cursor_Moved()
let g:last_pos = 0

" Scoped variable renaming
function! Rename()
  " Rename variable under cursor
  call inputsave()
  let @z=input("Rename ".@z." to: ")
  call inputrestore()
endfunction

" Remove spaces left of cursor
func Eatspace()
	let c = nr2char(getchar(0))
	return (c =~ '\s') ? '' : c
endfunc
" for example:
" iabbr <silent> if if ()<Left><C-R>=Eatspace()<CR>

" makeprg
" -------

" Ensure C/C++ uses make
au FileType c,cpp,h,hpp setlocal makeprg=make
" Run Golang unittests
au FileType go setlocal makeprg=go\ test
" Run Python unittests
au FileType python setlocal makeprg=py.test\ --doctest-modules

" Golang
" ------

" always format Golang code on write
au FileType go autocmd BufWritePre <buffer> Fmt

" Golang-specifc vim addons
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

" Python
" ------

" python.vim
let g:python_highlight_all = 1

" navigating source code (stolen from pymode)
au FileType python setlocal define=^\s*\\(def\\\\|class\\)

" common expansions of Python special methods and keywords
au FileType python iabb cl class
au FileType python iabb fr from
au FileType python iabb im import
au FileType python iabb la lambda
au FileType python iabb s. self.<C-R>=Eatspace()<CR>
au FileType python iabb ifmain if __name__ == '__main__':<C-R>=Eatspace()<CR><CR>
au FileType python iabb definit def __init__(self,):<Left><Left>
au FileType python iabb defnew def __new__(cls,):<Left><Left>
au FileType python iabb defdel def __del__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defrepr def __repr__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defstr def __str__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defbytes def __bytes__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defeq def __eq__(self, other):<C-R>=Eatspace()<CR><CR>
au FileType python iabb deflt def __lt__(self, other):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defhash def __hash__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defbool def __bool__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defgetattribute def __getattribute__(self, name):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defgetattr def __getattr__(self, name):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defsetattr def __setattr__(self, name, value):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defdelattr def __delattr__(self, name, value):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defdir def __dir__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defget def __get__(self, instance, owner):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defset def __set__(self, instance, value):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defdelete def __delete__(self, instance):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defcall def __call__(self,):<Left><Left>
au FileType python iabb deflen def __len__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb deflenhint def __length_hint__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defgetitem def __getitem__(self, key):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defsetitem def __setitem__(self, key, value):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defdelitem def __delitem__(self, key):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defiter def __iter__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defnext def __next__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defreversed def __reversed__(self):<C-R>=Eatspace()<CR><CR>
au FileType python iabb defcontains def __contains__(self, item):<C-R>=Eatspace()<CR><CR>

" ADD-ON CONFIGURATIONS
" =====================

" AutoFormat
" ----------

let g:autoformat_verbosemode = 1
let g:formatprg_args_python = "-a --max-line-length 99 -"

" clang_complete
" --------------

"let g:clang_auto_select = 1
let g:clang_complete_copen = 1
let g:clang_use_library = 1
let g:clang_debug = 1
if has("unix")
	if (system('uname') =~ "Darwin")
		let g:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
	else
		let g:clang_library_path='/usr/lib/llvm-3.5/lib'
	endif
else " has("win32") || has("win16")
	let g:clang_library_path='please configure your vimrc for this OS, Florian'
endif
let g:clang_complete_macros = 1
let g:clang_complete_patterns = 1

" CScope
" ------

if has("cscope")
    set csprg=cscope
    set csto=0
    au FileType c,h set cst
    au FileType cpp,hpp set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
endif

" Gundo
" -----

let g:gundo_width = 30
let g:gundo_preview_height = 20
let g:gundo_close_on_revert = 1
let g:gundo_preview_bottom = 1

" Jedi
" ----

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0

" MatchIt
" -------

" enable extended % matching (if/elsif/else/end) and SGML tags
runtime macros/matchit.vim

" NERDtree
" --------

" close the directory tree when browsing to an entry
let NERDTreeQuitOnOpen=1

" Python_PyDoc
" ------------

let g:pydoc_cmd = "pydoc"
let g:pydoc_window_lines=0.25

" SuperTab
" --------

" use context-dependent completion style
let g:SuperTabDefaultCompletionType="context"

" TagList
" -------

" python3 language
let s:tlist_def_python_settings = 'python3;c:class;m:member;f:function'
" highlight tag in list after n seconds (default: 4)
let TlistHighlightTag=2
" focus taglist on toggle
let Tlist_GainFocus_On_ToggleOpen=1
" show only the tags for one file (navigate files via NERDTree)
let Tlist_Show_One_File=1
" update the taglist on file modifications
let Tlist_Auto_Update=1
" display the taglist to the right
let Tlist_Use_Right_Window=0
" hide the fold columns
let Tlist_Enable_Fold_Column=0
" do not change the terminal window width
let Tlist_Inc_Winwidth=0
" close the taglist after selecting
let Tlist_Close_On_Select=1
" close vim if taglist is the only window and buffer
let Tlist_Exit_OnlyWindow=1

" TagBar
" ------

" place the bar on the left
let g:tagbar_left = 1
" auto-close the tagbar
let g:tagbar_autoclose = 1
" bar width
let g:tagbar_width = 50
" focus on bar when opened
let g:tagbar_autofocus = 1
" omit irrelevant info to save space
let g:tagbar_compact = 0
" use smaller icons
let g:tagbar_iconchars = ['▸', '▾']

" Syntastic
" ---------

" aggregate errors from multiple checkers
let g:syntastic_aggregate_errors = 1
" automatically open location window
let g:syntastic_auto_loc_list=1
" show current error in command window
let g:syntastic_echo_current_error = 1
" populate loclist with errors
let g:syntastic_always_populate_loc_list = 1
" dis/en-able on open file
let g:syntastic_check_on_open = 1
" dis/en-able on write
let g:syntastic_check_on_wq = 0
" dis/en-able left column signs
let g:syntastic_enable_signs = 0
" set location list window height
let g:syntastic_loc_list_height = 5
" Python-specific setup
let g:syntastic_python_checkers = ['flake8', 'pep257']
let g:syntastic_python_pep257_args = '--ignore=D102,D205,D400'
" C++11 setup
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

" Vim-JavaScript
" --------------

" Enable HTML/CSS syntax highlighting in your JavaScript files.
let javascript_enable_domhtmlcss = 1
" Enable JavaScript code folding.
let b:javascript_fold = 1
" Enable concealing characters. For example, function is replaced with ƒ.
let g:javascript_conceal = 1
" Disable JSDoc syntax highlighting.
let javascript_ignore_javaScriptdoc = 0

" Vim-JSHint2
" -----------

" disable save, as using this breaks syntastic
let jshint2_save = 0

" Vim-LaTeX
" ---------

" always show filename when grepping
set grepprg=grep\ -nH\ $*

" always use tex as filetype
let g:tex_flavor='latex'

" KEYMAPPINGS
" ===========

" used leaders:
" a -> autoformat
" b -> switch to buffer
" c -> NERD Commenter
" d -> directory tree
" h -> hidden characters
" j -> jump
" m -> :make
" M -> menu
" n -> line numbers
" o -> open file
" r -> renaming
" p -> python
" s -> syntastic
" t -> taglist
" T -> Tagbar
" u -> undo window toggle
" [,] -> moving around the loclist

" Add-On Keymappings
" ------------------

" Auotformat
noremap <Leader>a :Autoformat<CR><CR>

" CtrlP
" open the CtrlP file commandline ("[o]pen file")
nmap <silent> <Leader>o :CtrlP<CR>
" open the CtrlP buffer commandline ("open [b]uffer")
nmap <silent> <Leader>b :CtrlPBuffer<CR>

" EasyMotion
" find characters (jump)
let g:EasyMotion_leader_key = '<Leader>j'

" Forms (disable)
let g:menu_map_keys=1
nmap <Leader>M :call forms#menu#MakeMenu('n')<CR>
vmap <Leader>M :call forms#menu#MakeMenu('v')<CR>

" Gundo
" open revision history
map <Leader>u :GundoToggle<CR>

" Jedi
let g:jedi#goto_assignments_command = "<Leader>pa"
let g:jedi#goto_definitions_command = "<Leader>pd"
let g:jedi#usages_command = "<Leader>pu"
let g:jedi#rename_command = "<Leader>pr"

" NERDTree
" toggle plugin ("[d]irectory tree")
nmap <silent> <Leader>d :NERDTreeToggle<CR>A

" Py.test
" run py.test for:
au FileType python nmap <Leader>pta <Esc>:Pytest file<CR>
au FileType python nmap <Leader>ptc <Esc>:Pytest class<CR>
au FileType python nmap <Leader>ptf <Esc>:Pytest function<CR>
au FileType python nmap <Leader>ptm <Esc>:Pytest method<CR>
au FileType python nmap <Leader>ptp <Esc>:Pytest project<CR>
" navigate the current session:
au FileType python nmap <Leader>pts <Esc>:Pytest session<CR>
au FileType python nmap <Leader>ptn <Esc>:Pytest next<CR>
au FileType python nmap <Leader>pte <Esc>:Pytest end<CR>
" stop py.test from running (looponfail):
au FileType python nmap <Leader>ptq <Esc>:Pytest clear<CR>

" Syntastic
" toggle [s]yntastic plugin mode
nmap <silent> <Leader>ss :SyntasticToggleMode<CR>
" syntax [c]heck with Syntasstic plugin
nmap <Leader>sc :SyntasticCheck<CR>
" show Syntastic [e]rror messages
" (could be done with :lopen too)
nmap <Leader>se :Errors<CR>

" TagBar
" toggle the plugin ("[T]agbar")
nmap <silent> <Leader>T :TagbarToggle<CR>

" TagList
" toggle the plugin ("[t]aglist")
nmap <silent> <Leader>t :TlistToggle<CR>

" Vim-clang
let g:clang_c_options = '-std=gnu11'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'

" Custom (Leader) Keymappings
" ---------------------------

" rename stuff (see custom function Rename())
nmap <Leader>r "zyiw:call Rename()<cr>mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x

" [c]hange vim's working dir to the current buffer's file's dir
nmap <Leader>cwd :lcd %:p:h<CR>

" clear serach highlights
nmap <silent> <Leader><Leader> :nohlsearch<CR>

" quick make commands and moving through errors
" NB: use :cp, :cn, :cw  for previous, next, and close window
nmap <Leader>m :make<CR>

" toggle [h]idden ("list") characters (tab, trail, eol)
nmap <silent> <Leader>h :set nolist!<CR>

" toggle line numbers
nmap <silent> <Leader>n :set nonumber!<CR>

" run python and pytest
autocmd FileType python nmap <Leader>pp :!python %<CR>
autocmd FileType python nmap <Leader>ptt :!py.test -s --doctest-modules %<CR>

" Changed Default Keymappings
" ---------------------------

" remember <S-Space> does not work on Mac :(

" write in sudo mode **after** opening a file
cmap w!! w !sudo tee % > /dev/null

" delete all trailing whitespaces when using BS in visual mode
vnoremap <BS> :<BS><BS><BS><BS><BS>%s/\s\+$//ge<CR>

" ctags
map <F2> :!ctags --recurse --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+q .<CR>

" scroll viewport a bit fater
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" remap C-t (back) in help navigation to something intuitive
au filetype help nnoremap <buffer> <C-[> <C-t>

" faster switch to last buffer faster (like gt)
nmap <silent> tt :b#<CR>

" Easy window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Make window resizing easier
" (note: this reversed setting is more intuitive)
nmap <silent> <Up> <C-W>-
nmap <silent> <Down> <C-W>+
nmap <silent> <Left> <C-W>>
nmap <silent> <Right> <C-W>;<
