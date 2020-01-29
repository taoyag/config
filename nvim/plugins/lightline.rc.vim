let g:lightline = {
        \ 'colorscheme': 'solarized'
    \ }

" let g:lightline = {
"         \ 'colorscheme': 'solarized',
"         \ 'mode_map': {'c': 'NORMAL'},
"         \ 'active': {
"         \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'gitgutter', 'filename' ] ],
"         \   'right': [
"         \     ['lineinfo'],
"         \     ['percent'],
"         \     ['charcode', 'fileformat', 'fileencoding', 'filetype'],
"         \   ]
"         \ },
"         \ 'component_function': {
"         \   'modified': 'LightLineModified',
"         \   'readonly': 'LightLineReadonly',
"         \   'fugitive': 'LightLineFugitive',
"         \   'gitgutter': 'LightLineGitGutter',
"         \   'filename': 'LightLineFilename',
"         \   'fileformat': 'LightLineFileformat',
"         \   'filetype': 'LightLineFiletype',
"         \   'fileencoding': 'LightLineFileencoding',
"         \   'mode': 'LightLineMode',
"         \   'charcode': 'LightLineCharCode'
"         \ }
"         \ }
" 
" function! LightLineModified()
"   return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
" endfunction
" 
" function! LightLineReadonly()
"   return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
" endfunction
" 
" function! LightLineFilename()
"   return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
"         \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
"         \  &ft == 'unite' ? unite#get_status_string() :
"         \  &ft == 'vimshell' ? vimshell#get_status_string() :
"         \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
"         \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
" endfunction
" 
" function! LightLineFugitive()
"   try
"     if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
"       return fugitive#head()
"     endif
"   catch
"   endtry
"   return ''
" endfunction
" 
" function! LightLineFileformat()
"   return winwidth(0) > 70 ? &fileformat : ''
" endfunction
" 
" function! LightLineFiletype()
"   return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
" endfunction
" 
" function! LightLineFileencoding()
"   return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
" endfunction
" 
" function! LightLineMode()
"   return winwidth(0) > 60 ? lightline#mode() : ''
" endfunction
" 
" function! LightLineGitGutter()
"   if ! exists('*GitGutterGetHunkSummary')
"         \ || ! get(g:, 'gitgutter_enabled', 0)
"         \ || winwidth('.') <= 90
"     return ''
"   endif
"   let symbols = [
"         \ g:gitgutter_sign_added . ' ',
"         \ g:gitgutter_sign_modified . ' ',
"         \ g:gitgutter_sign_removed . ' '
"         \ ]
"   let hunks = GitGutterGetHunkSummary()
"   let ret = []
"   for i in [0, 1, 2]
"     if hunks[i] > 0
"       call add(ret, symbols[i] . hunks[i])
"     endif
"   endfor
"   return join(ret, ' ')
" endfunction
" 
" " https://github.com/Lokaltog/vim-powerline/blob/develop/autoload/Powerline/Functions.vim
" function! LightLineCharCode()
"   if winwidth('.') <= 70
"     return ''
"   endif
" 
"   " Get the output of :ascii
"   redir => ascii
"   silent! ascii
"   redir END
" 
"   if match(ascii, 'NUL') != -1
"     return 'NUL'
"   endif
" 
"   " Zero pad hex values
"   let nrformat = '0x%02x'
" 
"   let encoding = (&fenc == '' ? &enc : &fenc)
" 
"   if encoding == 'utf-8'
"     " Zero pad with 4 zeroes in unicode files
"     let nrformat = '0x%04x'
"   endif
" 
"   " Get the character and the numeric value from the return value of :ascii
"   " This matches the two first pieces of the return value, e.g.
"   " "<F>  70" => char: 'F', nr: '70'
"   let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')
" 
"   " Format the numeric value
"   let nr = printf(nrformat, nr)
" 
"   return "'". char ."' ". nr
" endfunction

