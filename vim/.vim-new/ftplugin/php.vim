if has("win32") || has("win64")
    setlocal dictionary=~/vimfiles/dict/php.dict
else
    setlocal dictionary=~/.vim/dict/php.dict
endif

setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
setlocal expandtab
setlocal autoindent
setlocal smartindent

setlocal makeprg=php\ -l\ %
setlocal errorformat=%m\ in\ %f\ on\ line\ %l

