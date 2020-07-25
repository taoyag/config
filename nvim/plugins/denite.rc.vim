try
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'statusline': 0,
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry


nnoremap    [denite]   <Nop>
nmap    f [denite]

nnoremap <silent> <C-n>  :<C-u>Denite buffer -split=floating<CR>
nnoremap <silent> <C-p>  :<C-u>Denite file file:new -split=floating<CR>
nnoremap <silent> <C-b>  :<C-u>Denite bookmark -split=floating<CR>
nnoremap <silent> <C-j>  :<C-u>Denite file_mru -split=floating<CR>
nnoremap [denite]u  :<C-u>Denite<Space>
nnoremap <silent> [denite];  :<C-u>Denite command_history -split=floating<CR>
nnoremap <silent> [denite]p  :<C-u>DeniteProjectDir file/rec -split=floating<CR>
nnoremap <silent> [denite]n  :<C-u>Denite buffer -split=floating<CR>
nnoremap <silent> [denite]f  :<C-u>Denite buffer file file/old file:new -split=floating<CR>
nnoremap <silent> [denite]r  :<C-u>Denite register -split=floating<CR>
nnoremap <silent> [denite]b  :<C-u>Denite buffer file -split=floating<CR>
nnoremap <silent> [denite]gg  :<C-u>Denite grep: -buffer-name=denite-grep-buffer<CR>
nnoremap <silent> [denite]gr  :<C-u>Denite -resume -buffer-name=denite-grep-buffer<CR>
nnoremap <silent> [denite]gn  :<C-u>Denite -resume -buffer-name=denite-grep-buffer -select=+1 -immediately<CR>
nnoremap <silent> [denite]gp  :<C-u>Denite -resume -buffer-name=denite-grep-buffer -select=-1 -immediately<CR>
" nnoremap <silent> [denite]g  :<C-u>Denite grep: -no-empty<CR>
nnoremap <silent> [denite]j  :<C-u>DeniteCursorWord grep:<CR>
nnoremap <silent> [denite]o  :<C-u>Denite outline<CR>
nnoremap <silent> [denite]l  :<C-u>Denite line<CR>

nnoremap <silent> [denite]ma :<C-u>Denite mapping -split=floating<CR>
nnoremap <silent> [denite]me :<C-u>Denite outline:message -split=floating<CR>
nnoremap <silent> [denite]q  :<C-u>Denite qf:ex=vimgrep\ <f-args>
nnoremap <silent> [denite]a  :<C-u>DeniteBookmarkAdd<CR>
" nnoremap <silent> [denite]l  :<C-u>Denite locate<CR>
nnoremap <silent> [denite]/  :<C-u>Denite line<CR>
" nnoremap <silent> [denite]g  :<C-u>Denite grep:<CR><CR><C-W>
nnoremap <silent> <Leader>b  :<C-u>DeniteBookmarkAdd<CR>
nnoremap <silent> [denite]P :<C-u>call <SID>denite_project('-start-insert', 'file/new')<CR>
noremap [denite]t :<C-u>Denite tag:<C-r>=expand('<cword>')<CR><CR>


" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d       denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p       denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q       denite#do_map('quit')
  nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
  nnoremap <silent><buffer><expr> <C-t>   denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>   denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-h>   denite#do_map('do_action', 'split')
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <buffer> jj <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <C-t> denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v> denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h> denite#do_map('do_action', 'split')
endfunction

" "nnoremap    [unite]   <Nop>
" "nmap    f [unite]
" "
" "nnoremap <silent> <C-n>  :<C-u>Unite -buffer-name=files buffer_tab<CR>
" "nnoremap <silent> <C-p>  :<C-u>UniteWithBufferDir -buffer-name=files file file_mru file/new<CR>
" "nnoremap <silent> <C-b>  :<C-u>Unite -buffer-name=files bookmark<CR>
" "nnoremap <silent> <C-j>  :<C-u>Unite -buffer-name=files file_mru<CR>
" "
" "
" "nnoremap [unite]u  :<C-u>Unite<Space>
" "nnoremap <silent> [unite];  :<C-u>Unite history/command<CR>
" "nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
" "nnoremap <silent> [unite]me :<C-u>Unite outline:message<CR>
" "nnoremap <silent> [unite]n  :<C-u>Unite -buffer-name=files buffer_tab<CR>
" "nnoremap <silent> [unite]p  :<C-u>UniteWithBufferDir -buffer-name=files file file_mru file/new<CR>
" "nnoremap <silent> [unite]f  :<C-u>Unite -buffer-name=files buffer file_mru bookmark file file/new<CR>
" "nnoremap <silent> [unite]j  :<C-u>Unite -buffer-name=files file_mru<CR>
" "nnoremap <silent> [unite]r  :<C-u>Unite -buffer-name=register register<CR>
" "nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" "nnoremap <silent> [unite]q  :<C-u>Unite qf:ex=vimgrep\ <f-args>
" "nnoremap <silent> [unite]a  :<C-u>UniteBookmarkAdd<CR>
" "nnoremap <silent> [unite]l  :<C-u>Unite locate<CR>
" "nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
" "nnoremap <silent> [unite]/  :<C-u>Unite line<CR>
" "nnoremap <silent> [unite]g  :<C-u>Unite grep:<CR>
" "nnoremap <silent> [unite]g  :<C-u>Unite grep:<CR><CR><C-W>
" "nnoremap <silent> <Leader>b  :<C-u>UniteBookmarkAdd<CR>
" "nnoremap <silent> [unite]P :<C-u>call <SID>unite_project('-start-insert', 'file/new')<CR>
" "noremap [unite]t :<C-u>Unite tag:<C-r>=expand('<cword>')<CR><CR>
" "
" "nnoremap <C-h>  :<C-u>UniteWithInput help<CR>
" "nnoremap <silent> g<C-h>  :<C-u>UniteWithkursorWord help<CR>
" "
" "function! s:unite_project(...)
" "  let opts = (a:0 ? join(a:000, ' ') : '')
" "  let dir = escape(unite#util#path2project_directory(expand('%')), ':')
" "  execute 'Unite' opts 'file_rec:' . dir
" "endfunction
" "
" "" unite grep に ag(The Silver Searcher) を使う
" "if executable('ag')
" "  let g:unite_source_grep_command = 'ag'
" "  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
" "  let g:unite_source_grep_recursive_opt = ''
" "endif
" "
" "autocmd FileType unite call s:unite_my_settings()
" "function! s:unite_my_settings()"{{{
" "    " Overwrite settings.
" "    imap <buffer> jj      <Plug>(unite_insert_leave)
" "    nnoremap <silent><buffer> <C-k> :<C-u>call unite#mappings#do_action('preview')<CR>
" "    "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
" "
" "    " Start insert.
" "    let g:unite_enable_start_insert = 1
" "endfunction"}}}
" "
" "let g:unite_enable_start_insert = 1
" "let g:unite_source_file_mru_limit = 50
" "let g:unite_source_file_mru_filename_format = ''
" "
" "let g:unite_source_grep_recursive_opt = '-r'
" "call unite#custom#substitute('files', '\$\w\+', '\=eval(submatch(0))', 200)
" "
" "call unite#custom#substitute('files', '[^~.]\zs/', '*/*', 20)
" "call unite#custom#substitute('files', '/\ze[^*]', '/*', 10)
" "
" "call unite#custom#substitute('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
" "call unite#custom#substitute('files', '^@', '\=getcwd()."/*"', 1)
" "call unite#custom#substitute('files', '^\\', '~/*')
" "
" "call unite#custom#substitute('files', '^;v', $DOTVIM . '/*')
" "call unite#custom#substitute('files', '^;r', '\=$VIMRUNTIME."/*"')
" "call unite#custom#substitute('files', '^;w', '~/Documents/workspace*')
" "if s:is_windows
" "  call unite#custom#substitute('files', '^;p', 'C:/Program Files/*')
" "endif
" "
" "call unite#custom#substitute('files', '\*\*\+', '*', -1)
" "call unite#custom#substitute('files', '^\~', escape($HOME, '\'), -2)
" "call unite#custom#substitute('files', '\\\@<! ', '\\ ', -20)
" "call unite#custom#substitute('files', '\\ \@!', '/', -30)
" "
" "call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')
" "autocmd FileType vimfiler call unite#custom_default_action('directory', 'lcd')
" "
" "call unite#custom_filters('line', ['matcher_migemo', 'sorter_default', 'converter_default'])

