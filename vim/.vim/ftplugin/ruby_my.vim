" ruby tags
setlocal tags+=~/.tags-ruby,~/.tags-rubygems
" ruby dictionary
setlocal dictionary=~/.vim/dict/ruby_snippets.dict

let ruby_space_errors = 1

nmap <silent> <buffer> ,t :!(cd %:p:h;ctags -R *.rb)&<CR>
