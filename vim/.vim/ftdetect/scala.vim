"        $URL: https://lampsvn.epfl.ch/svn-repos/scala/scala-tool-support/trunk/src/vim/ftdetect/scala.vim $

au BufRead,BufNewFile *.scala setlocal filetype=scala
au BufRead,BufNewFile *.scala setlocal shiftwidth=2
au BufRead,BufNewFile *.scala setlocal softtabstop=2
au BufRead,BufNewFile *.scala setlocal expandtab
au BufRead,BufNewFile *.scala setlocal autoindent
au BufRead,BufNewFile *.scala setlocal smartindent

au BufNewFile,BufRead *.scala compiler maven2
au FileType scala set tags+=~/.tags-scala,./tags;
nmap <silent> <buffer> ,t :!(cd %:p:h;ctags --options=$HOME/.tags-scala.conf)&<CR>
