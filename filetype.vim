runtime! ftdetect/*.vim

au BufNewFile,BufRead CMakeLists.txt,*.cmake setf cmake
au BufNewFile,BufRead *.txt	setf text
au BufNewFile,BufRead *.csv	setf text
au BufNewFile,BufRead *.tab	setf text
au BufNewFile,BufRead *.tsv	setf text
au BufNewFile,BufRead README	setf text
au BufNewFile,BufRead *.go	setf go
au BufNewFile,BufRead *.m,*.oct setf octave
"au BufNewFile,BufRead *.py	setf python3
au BufNewFile,BufRead Tupfile,*.tup	setf tup
