" for use Japanese
" set termencoding=japan
""""set gfw=Osaka-Mono:h10
colorscheme vibrantink
""""
highlight Pmenu guibg=#666666
highlight PmenuSel guibg=#006800
highlight PmenuSbar guibg=#001800
highlight PmenuThumb guifg=#006000

set guifont=Consolas:h10
""""if has('gui_macvim')
""""  set transparency=10  " 透明度を指定
""""  set antialias
""""  set guioptions-=t  " ツールバー非表示
""""  set guioptions-=r  " 右スクロールバー非表示
""""  set guioptions-=R
""""  set guioptions-=l  " 左スクロールバー非表示
""""  set guioptions-=L
""""  set guifont=Osaka-Mono:h13
""""
""""  set imdisable    " IMを無効化
""""  
""""  "フルスクリーンモード  
""""  set fuoptions=maxvert,maxhorz
""""    " autocmd GUIEnter * set fullscreen 
""""endif
""""
""""augroup hack234
""""  autocmd!
""""  if has('mac')
""""    autocmd FocusGained * set transparency=10
""""    autocmd FocusLost * set transparency=50
""""  endif
""""augroup END
