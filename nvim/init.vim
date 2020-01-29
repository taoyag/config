" Python 3.x系のPathを設定
let g:python_host_prog = '~/.anyenv/envs/pyenv/shims/python'
let g:python3_host_prog = '~/.anyenv/envs/pyenv/shims/python3'
let s:plugin = '~/.config/nvim/plugins/config/dein.toml'

" keymappings"
let mapleader=","

" dein.vim を使うために以下を記述
" runtime! plugins/dein.rc.vim

if &compatible
    set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/taoyag/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    " Let dein manage dein
    " Required:
    call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

    " Add or remove your plugins here like this:
    "call dein#add('Shougo/neosnippet.vim')
    "call dein#add('Shougo/neosnippet-snippets')

    call dein#load_toml(s:plugin, {'lazy': 0})
    " Required:
    call dein#end()
    call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
    call dein#install()
endif

" variables
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_mac = has('mac') || has('gui_mac') || has('gui_macvim')
let s:vimrc = expand("<sfile>:p")
let $MYVIMRC = s:vimrc

" set Vim-specific sequences for RGB colors
set termguicolors
let &t_8f = "\[38;2;%lu;%lu;%lum"
let &t_8b = "\[48;2;%lu;%lu;%lum"

set background=dark
colorscheme solarized8

" syntax on
set number
" set relativenumber
set norelativenumber
set incsearch
set inccommand=split
set ignorecase
set smartcase
set hlsearch
set showmode
set backspace=indent,eol,start
set nowrap
set linebreak
set laststatus=2

"indent settings
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

"display tabs and trailing spaces
set list
set listchars=tab:\ \ ,extends:>,precedes:<

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

set exrc
set secure
"hide buffers when not displayed
set hidden

"some stuff to get the mouse going in term
set mouse=a
" set ttymouse=xterm2

" clipboard
set clipboard+=unnamed
" if s:is_mac
    " nnoremap <silent> <SPACE>y :w !pbcopy<CR><CR>
    " vnoremap <silent> <SPACE>y :w !pbcopy<CR><CR>
    " nnoremap <silent> <SPACE>p :r !pbpaste<CR><CR>
    " vnoremap <silent> <SPACE>p :r !pbpaste<CR><CR>
    " set clipboard+=unnamed
" elseif s:is_windows
    " set clipboard+=unnamed
" else
    " let os=system('uname')
    " if os ==? "linux\n"
        " set clipboard=unnamed
    " endif
" endif

scriptencoding utf-8

"  文字コードの自動認識
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
        " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac


fun! Filename(...)
    let filename = expand('%:t:r')
    if filename == '' | return a:0 == 2 ? a:2 : '' | endif
    return !a:0 || a:1 == '' ? filename : substitute(a:1, '$1', filename, 'g')
endf

highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PMenuSbar ctermbg=4
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
        " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac


fun! Filename(...)
    let filename = expand('%:t:r')
    if filename == '' | return a:0 == 2 ? a:2 : '' | endif
    return !a:0 || a:1 == '' ? filename : substitute(a:1, '$1', filename, 'g')
endf

highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PMenuSbar ctermbg=4



"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>
"tags-and-searchesを使い易くする
nnoremap t <Nop>
"「飛ぶ」
nnoremap tt <C-]>
"「進む」
nnoremap tj :<C-u>tag<CR>
"「戻る」
nnoremap tk :<C-u>pop<CR>
"履歴一覧
nnoremap tl :<C-u>tags<CR>

" Ctrl-eでヘルプ
nnoremap <C-e> :<C-u>help<Space>
" カーソル下のキーワードをヘルプでひく
nnoremap <C-e><C-e> :<C-u>help<Space><C-r><C-w><Enter>

" 0, 9で行頭、行末へ
nmap 1 0
nmap 0 ^
nmap 9 $

cmap <C-x> <C-r>=expand('%:p:h')<CR>/
cmap <C-z> <C-r>=expand('%:p:r')<CR>
nmap H ;bp<CR>
nmap L ;bn<CR>
nnoremap <space>w :<C-u>write<CR>
nnoremap <space>q :<C-u>quit<CR>
nnoremap <space>Q :<C-u>quit!<CR>
nnoremap <space>f <C-f><CR>
nnoremap <space>b <C-b><CR>
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap so <C-w>o

vnoremap v $h

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
" makeなどで自動的にQuickFixを開く
au QuickfixCmdPost make,grep,grepadd,vimgrep copen
nnoremap <space>n :cn<CR>
nnoremap <space>p :cp<CR>

nnoremap <space>- <C-W>-
nnoremap <space>+ <C-W>+

" move cursor
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
noremap! <C-d> <Del>


" close buffler
nnoremap ,q :bd<CR>
" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
inoremap <silent> jj <ESC>
" ;でExコマンド入力( ;と:を入替)
noremap ; :
noremap : ;
