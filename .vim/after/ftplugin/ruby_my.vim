" ruby tags
setlocal tags+=~/.tags-ruby,~/.tags-rubygems
" ruby dictionary
if has("win32") || has("win64")
    setlocal dictionary=~/vimfiles/dict/ruby_snippets.dict
else
    setlocal dictionary=~/.vim/dict/ruby_snippets.dict
endif

let ruby_space_errors = 1

nmap <silent> <buffer> ,t :!(cd %:p:h;ctags -R *.rb)&<CR>

" smartchr
inoremap <expr> <buffer> { smartchr#loop('{', '#{', '{{{')
inoremap <expr> <buffer> = smartchr#one_of(' = ', ' == ', '=')

