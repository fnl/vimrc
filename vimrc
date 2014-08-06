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

" VIM ADD-ON MANAGER
" ==================

" List of add-ons to maintain with VAM
let addonList = keys({
\ 'AutoTag': "update entries in tag files on saves",
\ 'ctrlp': "[open] files: '<Leader>o' and buffer: '<Leader>b' navigation",
\ 'EasyMotion': "jump around ('<number>w', etc.): '<Leader>j'",
\ 'fugitive': "git commands: ':G'...",
\ 'github:klen/python-mode': "Python IDE",
\ 'Go_Syntax': "syntax files for Golang",
\ 'Gundo': "visual undo tree: '<Leader>u'",
\ 'jshint2': "JavaScript IDE (hints and lint)",
\ 'matchit.zip': "extended % matching",
\ 'Supertab': "tab completion",
\ 'surround': "change surrounding a->b: 'csab' add surrounding ...: 'ysiw'...",
\ 'Syntastic': "automatic syntax checking",
\ 'Tagbar': "display the current tags: '<Leader>T'",
\ 'taglist': "display the current tags: '<Leader>t'",
\ 'The_NERD_Commenter': "toggle comments: '<Leader>c<space>'",
\ 'The_NERD_tree': "file system directory: '<Leader>d'",
\ 'vim-autoformat': "use external formatting programs to arrange code",
\ 'vim-javascript': "JavaScript syntax",
\ 'Vim-R-plugin': "R IDE",
\ 'vim-scala': "Scala syntax",
\ 'vimside': "Scala IDE",
\ })
" 'Emmet': "abbreviation expansion with '<C-y>,'"

" .vim directory and VAM setup
if ! isdirectory(expand('$HOME/.vim/backup'))
  call mkdir(expand('$HOME/.vim/backup'))
endif

if ! isdirectory(expand('$HOME/.vim/tmp'))
  call mkdir(expand('$HOME/.vim/tmp'))
endif

fun! EnsureVamIsOnDisk(plugin_root_dir)
  let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
  if isdirectory(vam_autoload_dir)
    return 1
  else
    if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
      call mkdir(a:plugin_root_dir, 'p')
      execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
              \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
      " VAM runs helptags automatically when you install or update plugins
      exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
    endif
    return isdirectory(vam_autoload_dir)
  endif
endfun

fun! SetupVAM(addons)
  " VAM install location:
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME/.vim/addons', 1)
  if !EnsureVamIsOnDisk(c.plugin_root_dir)
    echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
    return
  endif
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  " Tell VAM which plugins to fetch & load:
  call vam#ActivateAddons(a:addons, {'auto_install' : 1})
endfun

" Ensure VAM and its addons
call SetupVAM(addonList)

" BASIC CONFIGURATION
" ===================

set listchars=tab:→⋅,trail:⋅,eol:¬,extends:➧,nbsp:∙ " invisibles definitions
set scrolloff=3 " start vertical scrolling a bit earlier
set sidescrolloff=3 " scroll at n colums before the side margin in nowrap mode
set wrap " (do not) wrap lines
set undolevels=1000 " tons of undos
set showmatch " jump to matching parens when inserting
set history=100 " a bit more history
set visualbell " stop dinging
set shortmess=atI " short (a), truncate file (t), and no intro (I) messages
set matchtime=5 " 10ths/sec to jump to matching brackets
set nonumber " show/hide line numbers

" Un-nref parenthesis highlights so the cursor can be seen
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" Un-nerf searche and associated highlights
set incsearch " highlight search phrases
set hlsearch " keep the search highlighted when going through them
set ignorecase " ignore case in seraches...
set smartcase " ...but only if there is no capital letter present
hi Search cterm=none ctermfg=black ctermbg=yellow

" Enable spell checking in text files
au FileType text set spell spelllang=en_us " enable spellchecking
hi SpellBad cterm=underline ctermbg=none
hi SpellCap cterm=underline ctermbg=none
hi SpellRare cterm=underline ctermbg=none
hi SpellLocal cterm=underline ctermbg=none

" Allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Make vimdiff play nice on dark background
if &diff
	colorscheme evening
endif

" Let vim switch to paste mode, disabling all kinds of smartness and just
" paste a whole buffer of text instead of regular insert behaviour
set pastetoggle=§

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

" Status line:
" %buffer_number:%file_name
" flags: m=modified r=readonly h=help w=preview_window
" [fileencoding](fileformat){filetype}
" tagname_if_set syntastic_flag_if_relevant
" [byteval_under_cursor][line_number,virtual_col_number][percentage_in_file]
set statusline=%n:%f%m%r%h%w\ [%{&fenc==\"\"?&enc:&fenc}](%{&ff}){%Y}\ %{Tlist_Get_Tagname_By_Line()}\ %{SyntasticStatuslineFlag()}\ %=[0x\%02.2B][%03l,%02v][%02p%%]
set laststatus=2 " show the statusline: 2=always

" Tab and indention handling
set autoindent " indent file by default
set copyindent " copy the previous indentation when autoindenting
set tabstop=2 " number of spaces to use to display tabs
set noexpandtab " (do not) replace (expand) tabs with spaces
set softtabstop=0 " number of spaces to delete/insert when editing expanded tabs
set shiftwidth=0 " number of spaces to manipulate for reindent ops (<< and >>)
" special cases
au FileType text set tabstop=8 noautoindent
au FileType python set tabstop=4 shiftwidth=4 softtabstop=4 expandtab 

" Code folding
set foldenable
set foldmarker={,} " when foldmethod marker is used
set foldmethod=syntax " fold based on... indent, marker, or syntax
" note that Python indention seems to work best with indent
au FileType python set foldmethod=indent
set foldlevel=5 " default fold level (20 is max level for indent)
set foldminlines=2 " number of lines up to which not to fold
set foldnestmax=5 " fold max depth (20 is max for indent)

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

" makeprg
" -------

" Ensure C/C++ uses make
au FileType c,cpp,h,hpp set makeprg=make
" Run Golang unittests
au FileType go set makeprg=go\ test
" Run Python nosetests
au FileType python set makeprg=nosetests\ --doctest-modules

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

autocmd BufRead *.py iabbrev ifmain if __name__ == '__main__':
autocmd BufRead *.py iabbrev definit def __init__(self,
autocmd BufRead *.py iabbrev defdel def __del__(self,
autocmd BufRead *.py iabbrev defcall def __call__(self,
autocmd BufRead *.py iabbrev defiter def __iter__(self,
autocmd BufRead *.py iabbrev defnext def __next__(self,
autocmd BufRead *.py iabbrev d def
autocmd BufRead *.py iabbrev c class
autocmd BufRead *.py iabbrev s self.

" ADD-ON CONFIGURATIONS
" =====================

" AutoFormat
" ----------

let g:autoformat_verbosemode = 1
let g:formatprg_args_python = "-a --max-line-length 99 -"

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

" MatchIt
" -------

" enable extended % matching (if/elsif/else/end) and SGML tags
runtime macros/matchit.vim

" NERDtree
" --------

" close the directory tree when browsing to an entry
let NERDTreeQuitOnOpen=1

" Python-Mode
" -----------

let g:pymode_debug = 0
let g:pymode_python = 'python3'
let g:pymode_options = 0
let g:pymode_trim_whitespaces = 1
let g:pymode_syntax_print_as_function = 1
let g:pymode_lint = 0 " syntastic works better...
let g:pymode_lint_unmodified = 1
let g:pymode_lint_on_fly = 1
let g:pymode_lint_options_mccabe = { 'complexity': 6 }
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
" navigating source code (from pymode_options)
au FileType python set define=^\s*\\(def\\\\|class\\)

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

" KEYMAPPINGS
" ===========

" used leaders:
" a -> autoformat
" b -> switch to buffer
" c -> cwd
" d -> directory tree
" h -> hidden characters
" j -> jump
" m -> :make
" n -> line numbers
" o -> open file
" p -> pymode
" r -> renaming
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

" Gundo
" open revision history
map <Leader>u :GundoToggle<CR>

" NERDTree
" toggle plugin ("[d]irectory tree")
nmap <silent> <Leader>d :NERDTreeToggle<CR>A

" Python-Mode
let g:pymode_run_bind = '<Leader>pp'
let g:pymode_breakpoint_bind = '<Leader>pb'
let g:pymode_rope_rename_bind = '<Leader>prr'
let g:pymode_rope_rename_module_bind = '<Leader>prm'
let g:pymode_rope_organize_imports_bind = '<Leader>pro'
let g:pymode_rope_autoimport_bind = '<Leader>pra'
let g:pymode_rope_module_to_package_bind = '<Leader>prp'
let g:pymode_rope_extract_method_bind = '<Leader>pre'
let g:pymode_rope_extract_variable_bind = '<Leader>prv'
let g:pymode_rope_use_function_bind = '<Leader>prf'
let g:pymode_rope_move_bind = '<Leader>prb'
let g:pymode_rope_change_signature_bind = '<Leader>prs'

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

" Custom (Leader) Keymappings
" ---------------------------

" rename stuff (see custom function Rename())
nmap <Leader>r "zyiw:call Rename()<cr>mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x

" [c]hange vim's working dir to the current buffer's file's dir
nmap <Leader>c :lcd %:p:h<CR>

" clear serach highlights
nmap <silent> <Leader><Leader> :nohlsearch<CR>

" quick make commands and moving through errors
" NB: use :cp, :cn, :cw  for previous, next, and close window
nmap <Leader>m :make<CR>

" moving around the loclist
nmap <Leader>] :lnext<CR>
nmap <Leader>[ :lprevious<CR>

" toggle [h]idden ("list") characters (tab, trail, eol)
nmap <silent> <Leader>h :set nolist!<CR>

" toggle line numbers
nmap <silent> <Leader>n :set nonumber!<CR>

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
