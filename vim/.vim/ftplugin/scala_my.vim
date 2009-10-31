setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal autoindent
setlocal smartindent

compiler maven2
setlocal tags+=~/.tags-scala,./tags;
nmap <silent> <buffer> ,t :!(cd %:p:h;/opt/local/bin/ctags --options=$HOME/.tags-scala.conf)&<CR>

