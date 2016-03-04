set guioptions-=T " do not include the toolbar
"set nowrap " do not wrap lines
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Consolas:h15
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif
"set fuoptions=maxvert,maxhorz
let Tlist_Show_Menu=1 " show tags in a menu
colorscheme macvim
set clipboard=unnamed
