function! MyQFixHowmKeyCmd(title)
  let g:QFixHowm_Cmd_New = "i".a:title." \<ESC>$a"
  let g:QFixHowm_Key_Cmd_C = "o<ESC>".g:QFixHowm_Cmd_New
  let g:QFixHowm_Key_Cmd_n = ":QFixHowmCursor next<CR>o<CR><ESC>k".g:QFixHowm_Cmd_New
  let g:QFixHowm_Key_Cmd_N = ":QFixHowmCursor bottom<CR>o<CR><ESC>k".g:QFixHowm_Cmd_New
  let g:QFixHowm_Key_Cmd_p = ":QFixHowmCursor prev<CR>I".a:title." <CR><CR><ESC>kk$a"
  let g:QFixHowm_Key_Cmd_P = ":QFixHowmCursor top<CR>I".a:title." <CR><CR><ESC>kk$a"
  let g:QFixHowm_Title = a:title
endfunction

function! QFixHowmCreateNewFileWithTag(tag)
  let bak = g:QFixHowm_Cmd_New
  let title = g:QFixHowm_Title. ' '. a:tag
  let g:QFixHowm_Cmd_New = "i".title." \<CR>\<ESC>kw"
  call QFixHowmCreateNewFile()
  let g:QFixHowm_Cmd_New = bak
endfunction

call MyQFixHowmKeyCmd('=')
