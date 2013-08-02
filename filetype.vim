runtime! ftdetect/*.vim

au BufNewFile,BufRead *.txt	setf text
au BufNewFile,BufRead *.csv	setf text
au BufNewFile,BufRead *.tab	setf text
au BufNewFile,BufRead *.tsv	setf text
au BufNewFile,BufRead README	setf text
au BufNewFIle,BufRead *.go	setf go
" Note: Tlist breaks if using python3 !!!!
au BufNewFile,BufRead *.py	setf python
