" nnoremap <silent><leader>f :<C-u>Defx<CR>
" nnoremap <silent><leader>f :<C-u>Defx -listed -resume -buffer-name=tab`tabpagenr()`<CR>
" nnoremap <silent><leader>f :<C-u>Defx -split=vertical -winwidth=60 -direction=topleft<CR>

call defx#custom#option('_', {
    \ 'buffer_name': 'defxplorer',
    \ 'columns': 'indent:icons:git:filename:type',
    \ 'show_ignored_files': 1,
    \ 'toggle': 1,
    \ 'resume': 1,
    \ })

" let g:defx_icons_enable_syntax_highlight = 1
let g:defx_icons_column_length = 2

autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
      nnoremap <silent><buffer><expr> <CR> defx#is_directory() ? defx#do_action('open_directory') : defx#do_action('drop')
      nnoremap <silent><buffer><expr> o defx#do_action('drop')
      nnoremap <silent><buffer><expr> s defx#do_action('open', 'split')
      nnoremap <silent><buffer><expr> v defx#do_action('open', 'vsplit')
      nnoremap <silent><buffer><expr> P defx#do_action('open', 'pedit')
      nnoremap <silent><buffer><expr> c defx#do_action('copy')
      nnoremap <silent><buffer><expr> m defx#do_action('move')
      nnoremap <silent><buffer><expr> p defx#do_action('paste')
      nnoremap <silent><buffer><expr> n defx#do_action('new_file')
      nnoremap <silent><buffer><expr> N defx#do_action('new_directory')
      nnoremap <silent><buffer><expr> d defx#do_action('remove')
      nnoremap <silent><buffer><expr> r defx#do_action('rename')
      nnoremap <silent><buffer><expr> t defx#do_action('open_or_close_tree')
      nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
      nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
      nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> .. defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
      nnoremap <silent><buffer><expr> <Esc> defx#do_action('quit')
      nnoremap <silent><buffer><expr> q defx#do_action('quit')
      nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
      nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
      nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
      nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
      nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
      nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
      nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
endfunction
