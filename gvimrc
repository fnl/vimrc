set guioptions-=T " do not include the toolbar
"set nowrap " do not wrap lines
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Meslo\ LG\ M\ DZ\ Regular\ for\ Powerline:h13
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
	" go into full-screen mode
	"set fuoptions=maxvert,maxhorz
	"au GUIEnter * set fullscreen
endif
"let Tlist_Show_Menu=1 " show tags in a menu
"set clipboard=unnamed " use the Mac-internal clipboard
