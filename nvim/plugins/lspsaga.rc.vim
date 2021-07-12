lua <<EOF
local saga = require 'lspsaga'
saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}
EOF

nnoremap <silent>K :Lspsaga hover_doc<CR>
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>

inoremap <silent> <C-k> <Cmd>Lspsaga signature_help<CR>
nnoremap <silent> gh <Cmd>Lspsaga lsp_finder<CR>
nnoremap <silent> <leader>ac :Lspsaga code_action<CR>
vnoremap <silent> <leader>ac :<C-U>Lspsaga range_code_action<CR>

nnoremap <silent> <leader>rn :Lspsaga rename<CR>
nnoremap <silent> gd :Lspsaga preview_definition<CR>

nnoremap <silent> <leader>cd :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> <leader>cc <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>

nnoremap <silent> [d :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]d :Lspsaga diagnostic_jump_prev<CR>
