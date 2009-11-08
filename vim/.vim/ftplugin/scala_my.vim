setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal autoindent
setlocal smartindent

compiler maven2

setlocal tags+=~/.tags-scala,~/.m2/repository/tags-scalatest-1.0,~/.m2/repository/tags-junit-4.5,./tags;
" lift
setlocal tags+=~/.m2/repository/tags-lift-actor-1.1-M6,~/.m2/repository/tags-lift-mapper-1.1-M6,~/.m2/repository/tags-lift-util-1.1-M6,~/.m2/repository/tags-lift-webkit-1.1-M6,~/.m2/repository/tags-lift-widgets-1.1-M6;

nmap <silent> <buffer> ,t :!(cd %:p:h;ctags_scala)&<CR>

setlocal include=^import
setlocal includeexpr=substitute(v:fname,'\.','/','g')
