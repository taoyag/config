if exists('current_compiler')
    finish
endif
let current_compiler = 'xhtml'

if exists(':CompilerSet') != 2
    command -nargs=* CompilerSet setlocal <args>
endif


if has('win32')
    CompilerSet makeprg=tidy\ -raw\ -quiet\ -errors\ --gnu-emacs\ yes\ \"%\"
    CompilerSet errorformat=%f:%l:%c:\ %t%*[^:]:\ %m
else
    CompilerSet makeprg=tidy\ -raw\ -quiet\ -errors\ --gnu-emacs\ yes\ %
    CompilerSet errorformat=%f:%l:%c:\ %t%*[^:]:\ %m
endif
