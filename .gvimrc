syntax enable
set background=dark
colorscheme solarized

"colorscheme zenburn
"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

if has("gui_win32")
    " set guifont=Ricty\ Diminished:h11
    " set guifontwide=Ricty\ Diminished:h11
    " set guifont=Consolas:h10:cSHIFTJIS
    set guifont=MyricaM\ M:h10:cSHIFTJIS
    " set printfont=M+2VM+IPAG_circle:h10:cSHIFTJIS
    " winsizeの前に横幅を指定しないとカーソルが出ない
    set columns=170
    autocmd GUIEnter * winpos 180 100
    autocmd GUIEnter * winsize 170 48
endif

if has("gui_gnome")
    autocmd GUIEnter * winsize 130 40
    set guifont=Ricty\ 10
endif

if has("gui_mac") || has("gui_macvim")
    " set guifont=Monaco:h11
    set guifont=Ricty\ Diminished:h14
    set guifontwide=Ricty\ Diminished:h14
    " set guifont=Ricty\ Discord:h12
    " set guifontwide=Ricty\ Discord:h12
    autocmd GUIEnter * winsize 130 120
endif
highlight Pmenu guibg=#666666
highlight PmenuSel guibg=#006800
highlight PmenuSbar guibg=#001800
highlight PmenuThumb guifg=#006000

