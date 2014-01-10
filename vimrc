" This must be first, because it changes other options as side effect
set nocompatible " disable vi compatiblity
set hidden " change buffers w/o saving - essential

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

fun! SetupVAM()
  " Set advanced options like this:
  " let g:vim_addon_manager = {}
  " let g:vim_addon_manager.key = value
  "     Pipe all output into a buffer which gets written to disk
  " let g:vim_addon_manager.log_to_buf =1

  " Example: drop git sources unless git is in PATH. Same plugins can
  " be installed from www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager.drop_git_sources = !executable('git')
  " let g:vim_addon_manager.debug_activation = 1

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
  call vam#ActivateAddons([ 'ctrlp', 'Emmet', 'matchit.zip', 'surround', 'AutoTag', 'The_NERD_Commenter', 'The_NERD_tree', 'Supertab', 'Syntastic', 'Tagbar', 'taglist', 'Gundo', 'fugitive', 'vim-javascript', 'jshint2', 'Go_Syntax', 'vim-scala', 'jedi-vim' ], {'auto_install' : 1})
  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
  " Also See "plugins-per-line" below

  " Addons are put into plugin_root_dir/plugin-name directory
  " unless those directories exist. Then they are activated.
  " Activating means adding addon dirs to rtp and do some additional
  " magic

  " How to find addon names?
  " - look up source from pool
  " - (<c-x><c-p> complete plugin names):
  " You can use name rewritings to point to sources:
  "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()

" Some basic settings
set listchars=tab:→⋅,trail:⋅,eol:¬,extends:➧,nbsp:∙ " invisibles definitions
set scrolloff=3 " start scrolling a bit earlier
set sidescrolloff=3 " scroll at n colums when at the side margin in nowrap mode
set wrap " (do not) wrap lines
set undolevels=1000 " tons of undos
set showmatch " jump to matching parens when inserting
set history=100 " a bit more history
set visualbell " stop dinging!!!
set shortmess=atI " short (a), truncate file (t), and no intro (I) messages
set matchtime=5 " 10ths/sec to jump to matching brackets
"set number " shows line numbers

" make the autocomplete menu readable...
"highlight Pmenu ctermfg=black
"highlight PmenuSel ctermfg=black

" Un-nref parenthesis highlights so the cursor can be seen
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" Un-nerf searches
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

" Let vim switch to paste mode, disabling all kinds of smartness and just
" paste a whole buffer of text instead of regular insert behaviour
set pastetoggle=±

" Set exec-bit on files that start with a she-bang line
"au BufWritePost * if getline(1) =~ "^#!" | silent !chmod +x <afile>

" Syntax highlighting and filetype-dependent indenting
filetype on
filetype plugin indent on
syntax on

" Default tag files
set tags=./tags,tags,~/.tags

" tagging and omni-completion setup (UNUSED FOR NOW)
"au FileType python set omnifunc=pythoncomplete#Complete
"au FileType python3 set omnifunc=python3complete#Complete
"au FileType python3,python set tags=./tags,tags,~/.pytags
"au FileType ruby set omnifunc=rubycomplete#Complete
"au FileType ruby set set tags=./tags,tags,~/.rtags
"au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"au FileType html set omnifunc=htmlcomplete#CompleteTags
"au FileType css set omnifunc=csscomplete#CompleteCSS
"au FileType xml set omnifunc=xmlcomplete#CompleteTags
"au FileType c,h set omnifunc=ccomplete#Complete
"au FileTYpe c,h set tags=./tags,tags,~/.ctags
"au FileType java set omnifunc=javacomplete#Complete
"au FileType java set completefunc=javacomplete#CompleteParamsInfo
"au FileType java set tags=./tags,tags,~/.jtags

" Command line completion
set wildmenu " turn on command line completion wild style
" but ignore files that are "useless" from an IDE perspective
set wildignore=*.dll,*.o,*.obj,*.pyc,*.pyo,*.jpg,*.gif,*.png,*.swp,*.class
set wildmode=list:longest " and show everything possible for completion

" Status line as good as it gets...
" %buffer_number:%file_name
" flags: modified readonly help preview_window
" [fileencoding](fileformat){filetype} tagname
" [byteval_under_cursor][line_number,virtual_col_number][percentage_in_file]
set statusline=%n:%f%m%r%h%w\ [%{&fenc==\"\"?&enc:&fenc}](%{&ff}){%Y}\ %{Tlist_Get_Tagname_By_Line()}\ %{SyntasticStatuslineFlag()}\ %=[0x\%02.2B][%03l,%02v][%02p%%]
set laststatus=2 " show the statusline - always

" Tab indention handling
set autoindent " indent files
au FileType text set noautoindent
set copyindent " copy the previous indetation on autoindenting
set expandtab " no real tabs
au FileType text set noexpandtab
set smarttab " insert blanks using shiftwidth; off uses (soft)tabstop
set shiftwidth=2 " for smarttab (Python uses 4, defined below)
set softtabstop=2 " number of spaces to use when editing tabs (Python see below)
au FileType text set softtabstop=0

" Code folding
set foldenable
set foldmarker={,} " when foldmethod marker is used
set foldmethod=syntax " fold based on... indent, marker, or syntax
" note that Python indention seems to work best with indent
set foldlevel=5 " default fold level (20 is max level for indent)
set foldminlines=2 " number of lines up to which not to fold
set foldnestmax=5 " fold max depth (20 is max for indent)

" Store backups into special dirs
"set nobackup " by default, ignore backups - swaps are good enough
set backupdir=~/.vim/backup " backup files dir
set directory=~/.vim/tmp " swap files dir

" Higlight the cursorline after a jump, but deactivate on move
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

" Tell Rgrep not to use Xargs on Mac OS
"let s:os = system("uname")
"if s:os =~ "Darwin"
"  let g:Grep_Xargs_Options='-0'
"endif

" Scoped Variable Renaming
" ------------------------

function! Rename()
  " Rename variable under cursor (except Python!)
  call inputsave()
  let @z=input("Rename ".@z." to: ")
  call inputrestore()
endfunction

" jedi-vim for Python will override this to use its own renmaing function
nmap <Leader>r "zyiw:call Rename()<cr>mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x

" Plugins Setup
" -------------

" Pathogen setup
call pathogen#infect()
call pathogen#helptags()

" cscope setup
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

" Enable extended % matching (if/elsif/else/end) and SGML tags
runtime macros/matchit.vim

" Command-T/CtrlP setup
" ---------------------

" open the Command-T commandline ("[o]pen file")
"nnoremap <silent> <Leader>o :CommandT<CR>

" open the CtrlP file commandline ("[o]pen file")
nmap <silent> <Leader>o :CtrlP<CR>

" open the Command-T commandline ("open [b]uffer")
"nnoremap <silent> <Leader>b :CommandTBuffer<CR>

" open the CtrlP buffer commandline ("open [b]uffer")
nmap <silent> <Leader>b :CtrlPBuffer<CR>

" flush the Command-T cache ("[f]lush")
"cnoremap <Leader>f :CommandTFlush<CR>

" SuperTab setup
" --------------

" use context-dependent completion style
let g:SuperTabDefaultCompletionType="context"

" ctags setup
" -----------

map <F2> :!ctags --recurse --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+q .<CR>

" TagList setup
" -------------

" python3 language
let s:tlist_def_python_settings = 'python3;c:class;m:member;f:function'
" hilight tag in list after n seconds (default: 4)
let TlistHighlightTag=2
" focus taglist on toggle
let Tlist_GainFocus_On_ToggleOpen=1
" show only the tags for one file (navigate files via NERDTree)
let Tlist_Show_One_File=1
" update the taglist on file modifications
let Tlist_Auto_Update=1
" display the taglist to the right
"let Tlist_Use_Right_Window=1
" hide the fold columns
let Tlist_Enable_Fold_Column=0
" do not change the terminal window width
let Tlist_Inc_Winwidth=0
" close the taglist after selecting
let Tlist_Close_On_Select=1
" close vim if taglist is the only window and buffer
let Tlist_Exit_OnlyWindow=1
" taglist window width setting
"let Tlist_WinWidth="auto"

" toggle the TagList plugin ("[T]aglist")
nmap <silent> <Leader>T :TlistToggle<CR>

" TagBar setup
" ------------

" place the bar on the left
let g:tagbar_left=1
" auto-close the tagbar
let g:tagbar_autoclose=1
" bar width
let g:tagbar_width=50
" focus on bar when opened
let g:tagbar_autofocus=1
" omit irrelevant info to save space
"let g:tagbar_compact=1
" use smaller icons
let g:tagbar_iconchars = ['▸', '▾']

" toggle the TagBar plugin ("[t]agbar")
nmap <silent> <Leader>t :TagbarToggle<CR>

" NERDtree setup
" --------------

" close the directory tree when browsing to an entry
let NERDTreeQuitOnOpen=1

" toggle the NERDTree plugin ("[d]irectory tree")
nmap <silent> <Leader>d :NERDTreeToggle<CR>A

" Syntastic setup
" ---------------

" aggregate errors from multiple checkers
let g:syntastic_aggregate_errors = 1
" automatically open location window
let g:syntastic_auto_loc_list=1
" show current error in command window
let g:syntastic_echo_current_error = 1
" populate loclist with errors
let g:syntastic_always_populate_loc_list = 1
" enable on open file
let g:syntastic_check_on_open = 1
" enable on write
"let g:syntastic_check_on_wq = 1
" dis/en-able left column signs
let g:syntastic_enable_signs = 0
" set location list window height
let g:syntastic_loc_list_height = 5

" toggle [s]yntastic plugin mode
"nmap <silent> <Leader>s :SyntasticToggleMode<CR>
" [c] syntax with Syntasstic plugin
nmap <Leader>s :SyntasticCheck<CR>
" show Syntastic [e]rror messages
" (can be done with :lopen too)
"nmap <Leader>e :Errors<CR>

" C/C++ Setup
" -----------

au FileType c,cpp,h,hpp set makeprg=make

" JavaScript Setup
" ----------------

" vim-jshint2
" using this breaks syntastic...
let jshint2_save = 0

" vim-javascript
" Enable HTML/CSS syntax highlighting in your JavaScript files.
let javascript_enable_domhtmlcss = 1
" Enable JavaScript code folding.
let b:javascript_fold = 1
" Enable concealing characters. For example, function is replaced with ƒ.
let g:javascript_conceal = 1
" Disable JSDoc syntax highlighting.
let javascript_ignore_javaScriptdoc = 0

" Go Setup
" --------

" use makeprg to run unittests
au FileType go set makeprg=go\ test

filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

au FileType go autocmd BufWritePre <buffer> Fmt
au FileType go set tabstop=2

" Python Setup
" ------------

" use makeprg to run unittests
au FileType py,py3 set makeprg=nosetests

" jedi setup
let g:jedi#goto_assignments_command = "<Leader>a"
let g:jedi#goto_definitions_command = "<Leader>g"
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#rename_command = "<Leader>r"
let g:jedi#usages_command = "<Leader>u"

" Syntax highlighting
let g:python_highlight_all = 1

" Update shiftwidth/softtabstop
au BufRead,BufNewFile *.py set shiftwidth=4
au BufRead,BufNewFile *.py set softtabstop=4

" Python make commands

" pydoc.vim setup
let g:pydoc_cmd = "pydoc3"

" Python code checks, tests, and runs
" run checks
"autocmd BufRead *.py nmap <Leader>rc :!pyflakes3k %<CR>
" run test all
"autocmd BufRead *.py nmap <Leader>rt :!py.test-3 -s --doctest-modules --nocapturelog %<CR>
autocmd BufRead *.py nmap <Leader>rt :!nosetest -s --doctest-modules --nocapturelog %<CR>
" run python
autocmd BufRead *.py nmap <Leader>rp :!python %<CR>
"autocmd BufRead *.py nmap <Leader>rp :!python3 %<CR>

" Pytest.vim and py.test
"autocmd BufRead *.py nmap <Leader>pf <Esc>:Pytest file<CR>
"autocmd BufRead *.py nmap <Leader>pc <Esc>:Pytest class<CR>
"autocmd BufRead *.py nmap <Leader>pm <Esc>:Pytest method<CR>
"autocmd BufRead *.py nmap <Leader>ps <Esc>:Pytest session<CR>
"autocmd BufRead *.py nmap <Leader>pn <Esc>:Pytest next<CR>

" Text expansion - iabbrev
autocmd BufRead *.py iabbrev ifmain if __name__ == '__main__':
autocmd BufRead *.py iabbrev definit def __init__(self,
autocmd BufRead *.py iabbrev defdel def __del__(self,
autocmd BufRead *.py iabbrev defcall def __call__(self,
autocmd BufRead *.py iabbrev defiter def __iter__(self,
autocmd BufRead *.py iabbrev defnext def __next__(self,

" General Command Mappings
" ------------------------

" remember <S-Space> does not work on Mac :(
" the mapping for highlight search disable was defined already

" write in sudo mode **after** opening a file
cmap w!! w !sudo tee % > /dev/null

" reset the working dir of the current buffer to the file's dir
nmap <Leader>c :lcd %:p:h<CR>

" quickly clear serach highlights
nmap <silent> <Leader>\ :nohlsearch<CR>

" quick make commands and moving through errors
" easier to just use :cp, :cn, :cw ?
nmap <F7> :cprevious<CR>
nmap <F8> :make<CR>
nmap <F9> :cnext<CR>
"nmap <Leader>q :cwindow<CR>

" moving around the loclist
nmap <Leader>] :lnext<CR>
nmap <Leader>[ :lprevious<CR>

" delete all trailing whitespaces when using BS in visual mode
vnoremap <BS> :<BS><BS><BS><BS><BS>%s/\s\+$//ge<CR>

" scroll viewport a bit fater
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" toggle showing hidden ("list") characters (tab, trail, eol)
nmap <silent> <Leader>h :set nolist!<CR>

" remap back in help to something intuitive
au filetype help nnoremap <buffer> <C-[> <C-t>

" toggle showing line numbers
nmap <silent> <Leader>l :set nonumber!<CR>

" faster switch to last buffer faster (like gt)
nmap <silent> tt :b#<CR>

" Easy window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Make window resizing easier
" (note: reversed setting more intuitive)
nmap <silent> <Up> <C-W>-
  nmap <silent> <Down> <C-W>+
  nmap <silent> <Left> <C-W>>
nmap <silent> <Right> <C-W>;<
