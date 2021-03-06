" variables
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_mac = has('mac') || has('gui_mac') || has('gui_macvim')
let s:vimrc = expand("<sfile>:p")
let $MYVIMRC = s:vimrc

if s:is_windows
  let $DOTVIM = expand('~/vimfiles')
else
  let $DOTVIM = expand('~/.vim')
endif

" "if s:is_windows
" "    let $PATH = 'C:\Program Files (x86)\Git\bin;' . $PATH
" "    let $PATH = $HOME . '\bin;' . $PATH
" "endif

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

let s:dein_dir = expand('~/.cache/dein')
if s:is_windows
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim/'
else
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
endif


" Required:
execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')

" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml = expand($DOTVIM . '/dein.toml')
  let s:lazy_toml = expand($DOTVIM . '/dein_lazy.toml')

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

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

filetype plugin indent on

" solarized
syntax enable
set background=dark
" colorscheme solarized

"------------------------------------
" set runtimepath for local scripts
"------------------------------------
set runtimepath+=~/vimlocal

set nocompatible                  " vi互換無し
set backspace=indent,eol,start    " backspaceで削除できるようにする
set history=1000
set showcmd                       "show incomplete cmds down the bottom
set showmode                      "show current mode down the bottom
set incsearch                     "find the next match as we type the search
set hlsearch                      "hilight searches by default
set nowrap                        "dont wrap lines
set linebreak                     "wrap lines at convenient points
set laststatus=2
set autoread
set noundofile

let mapleader=","

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"indent settings
set shiftwidth=4
set softtabstop=4
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

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

" python
if has("mac")
    let $PYTHON_DLL = "/usr/local/Cellar/python/2.6.5/lib/libpython2.6.dylib"
endif

" SKK
inoremap <silent> <C-j> <C-^>

" clipboard
if s:is_mac
    nnoremap <silent> <SPACE>y :w !pbcopy<CR><CR>
    vnoremap <silent> <SPACE>y :w !pbcopy<CR><CR>
    nnoremap <silent> <SPACE>p :r !pbpaste<CR><CR>
    vnoremap <silent> <SPACE>p :r !pbpaste<CR><CR>
    set clipboard+=unnamed,autoselect
elseif s:is_windows
    set clipboard+=unnamed
else
    let os=system('uname')
    if os ==? "linux\n"
        set clipboard=unnamed
    endif
endif

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"高速ターミナル接続
set ttyfast

"tell the term has 256 colors
set t_Co=256

"hide buffers when not displayed
set hidden

scriptencoding utf-8

" lightline.vim
" ステータスライン表示
let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'gitgutter', 'filename' ] ],
        \   'right': [
        \     ['lineinfo'],
        \     ['percent'],
        \     ['charcode', 'fileformat', 'fileencoding', 'filetype'],
        \   ]
        \ },
        \ 'component_function': {
        \   'modified': 'LightLineModified',
        \   'readonly': 'LightLineReadonly',
        \   'fugitive': 'LightLineFugitive',
        \   'gitgutter': 'LightLineGitGutter',
        \   'filename': 'LightLineFilename',
        \   'fileformat': 'LightLineFileformat',
        \   'filetype': 'LightLineFiletype',
        \   'fileencoding': 'LightLineFileencoding',
        \   'mode': 'LightLineMode',
        \   'charcode': 'LightLineCharCode'
        \ }
        \ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightLineGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

" https://github.com/Lokaltog/vim-powerline/blob/develop/autoload/Powerline/Functions.vim
function! LightLineCharCode()
  if winwidth('.') <= 70
    return ''
  endif

  " Get the output of :ascii
  redir => ascii
  silent! ascii
  redir END

  if match(ascii, 'NUL') != -1
    return 'NUL'
  endif

  " Zero pad hex values
  let nrformat = '0x%02x'

  let encoding = (&fenc == '' ? &enc : &fenc)

  if encoding == 'utf-8'
    " Zero pad with 4 zeroes in unicode files
    let nrformat = '0x%04x'
  endif

  " Get the character and the numeric value from the return value of :ascii
  " This matches the two first pieces of the return value, e.g.
  " "<F>  70" => char: 'F', nr: '70'
  let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

  " Format the numeric value
  let nr = printf(nrformat, nr)

  return "'". char ."' ". nr
endfunction

" 不可視文字をハイライトする
" augroup highlightIdegraphicSpace
    " autocmd!
    " autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
    " " 全角空白、タブ
    " autocmd VimEnter,WinEnter * match IdeographicSpace /[　\t]/
" augroup END

"colorscheme YourFavoriteColorscheme
"dont load csapprox if we no gui support - silences an annoying warning
if !has("gui")
    let g:CSApprox_loaded = 1
    " colorscheme vibrantink
else
    if has("gui_gnome")
        set term=gnome-256color
        " colorscheme desert
    else
        " set t_Co=256
        " colorscheme vibrantink
        set guitablabel=%M%t
    endif
    if has("gui_mac") || has("gui_macvim")
        " set antialias
        set guifont=Ricty\ Diminished:h14
        " set guifont=Monaco:h10
    endif
    if has("gui_macvim")
        autocmd GUIEnter * winsize 130 120
    endif
    if s:is_windows
        set guifont=Consolas:h10
    endif
endif

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal g`\""
        endif
    end
endfunction

"define :HighlightExcessColumns command to highlight the offending parts of
"lines that are "too long". where "too long" is defined by &textwidth or an
"arg passed to the command
command! -nargs=? HighlightExcessColumns call s:HighlightExcessColumns('<args>')
function! s:HighlightExcessColumns(width)
    let targetWidth = a:width != '' ? a:width : &textwidth
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth+0) . 'v/'
    else
        echomsg "HighlightExcessColumns: set a &textwidth, or pass one in"
    endif
endfunction

"行番号を表示する
set number
"バックアップファイルを作るディレクトリ
set backupdir=$HOME/vimbackup
set backupskip=/tmp/*,/private/tmp/*

" migemo
if has("migemo")
    set migemo
endif
"スワップファイル用のディレクトリ
set directory=$HOME/vimbackup

function! GetB()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    let c = iconv(c, &enc, &fenc)
    return String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
    let n = a:nr
    let r = ""
    while n
        let r = '0123456789ABCDEF'[n % 16] . r
        let n = n / 16
    endwhile
    return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
    let out = ''
    let ix = 0
    while ix < strlen(a:str)
        let out = out . Nr2Hex(char2nr(a:str[ix]))
        let ix = ix + 1
    endwhile
    return out
endfunc

" 文字コードの自動認識
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

"-------------------------------------------------------------------------------
" キーマッピング
"-------------------------------------------------------------------------------

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

"閉じ括弧を自動的に挿入
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

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

" 編集中のファイルのディレクトリに移動
nnoremap ,d :execute ":lcd" . expand("%:p:h")<CR>

if has("gui_win32") || has("gui_win32s")
    nnoremap <space>v :edit $HOME/config/.vimrc<CR>
else
    nnoremap <space>v :edit $HOME/.vimrc<CR>
endif

" QuickFix
"au QuickFixCmdPost vimgrep cw 
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

" ウインドウの透過(MacVim)
nnoremap ,t :set transparency=20<CR>
nnoremap ,T :set transparency=0<CR>


" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>


"-------------------------------------------------------------------------------
" その他 Misc
"-------------------------------------------------------------------------------
" 日時の自動入力
inoremap <expr> ,df strftime('%Y/%m/%d %H:%M:%S')
inoremap <expr> ,dd strftime('%Y/%m/%d')
inoremap <expr> ,dt strftime('%H:%M:%S')

" パス・ファイル名の挿入
inoremap ,f <C-R>%
inoremap ,p <C-R>=expand('%:p')<CR>

" ;でExコマンド入力( ;と:を入替)
noremap ; :
noremap : ;

"-------------------------------------------------------------------------------
" 各種プラグインの設定
"-------------------------------------------------------------------------------
"------------------------------------
" NERD_commenter.vim
"------------------------------------
" デフォルトキーマッピングをOFFにする
let g:NERDCreateDefaultMappings = 0
" コメントの間にスペースを空ける
let NERDSpaceDelims = 1
""未対応ファイルタイプのエラーメッセージを表示しない
let NERDShutUp=1

nmap <leader>xc         <plug>NERDCommenterComment
nmap <leader>,          <plug>NERDCommenterToggle
nmap <leader>x<space>   <plug>NERDCommenterToggle
nmap <leader>xm         <plug>NERDCommenterMinimal
nmap <leader>xs         <plug>NERDCommenterSexy
nmap <leader>xi         <plug>NERDCommenterInvert
nmap <leader>xy         <plug>NERDCommenterYank
nmap <leader>xl         <plug>NERDCommenterAlignLeft
nmap <leader>xb         <plug>NERDCommenterAlignBoth
nmap <leader>xn         <plug>NERDCommenterNest
nmap <leader>xu         <plug>NERDCommenterUncomment
nmap <leader>x$         <plug>NERDCommenterToEOL
nmap <leader>xA         <plug>NERDCommenterAppend

vmap <leader>,          <plug>NERDCommenterToggle
vmap <leader>x<space>   <plug>NERDCommenterToggle
vmap <leader>xm         <plug>NERDCommenterMinimal
vmap <leader>xs         <plug>NERDCommenterSexy
vmap <leader>xi         <plug>NERDCommenterInvert
vmap <leader>xy         <plug>NERDCommenterYank
vmap <leader>xl         <plug>NERDCommenterAlignLeft
vmap <leader>xb         <plug>NERDCommenterAlignBoth
vmap <leader>xn         <plug>NERDCommenterNest
vmap <leader>xu         <plug>NERDCommenterUncomment
vmap <leader>x$         <plug>NERDCommenterToEOL
vmap <leader>xA         <plug>NERDCommenterAppend


"------------------------------------
" grep.vim
"------------------------------------
" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs = '.svn'
let Grep_Skip_Files = '*.bak *~'

"------------------------------------
" qfixhowm
"------------------------------------
let QfixHowm_Key      = 'g'
let howm_dir          = $HOME . '/Dropbox/howm'
let howm_filename     = '%Y/%m/%d/%Y-%m-%d-%H%M%S.howm'
let howm_fileencoding = 'utf-8'
let howm_fileformat   = 'unix'
let SubWindow_Title   = $HOME . '/howm/__submenu__.howm'
if has("unix")
    let mygrepprg = '/bin/grep'
endif
if has("gui_mac") || has("gui_macvim")
    let mygrepprg = '/usr/bin/grep'
endif
if s:is_windows
    " let mygrepprg = 'ag'
    " let MyGrep_Encoding = 'utf-8'
    let mygrepprg = $HOME . '/bin/grep'
    let MyGrep_cygwin17 = 1
endif
let MyGrep_ExcludeReg = '[/\\].svn[/\\]'
"カレントディレクトリを起点にして検索する
let MyGrep_CurrentDirMode = 0
let MyGrep_DefaultSearchWord = 1

"howm専用MRUを基本に使用する
let QFixHowm_SwapLcommand = 1
let QFixHowm_MruFileMax = 30
let QFixHowm_FileType = 'howm_memo.markdown'

"howmタイムスタンプを更新時間として扱う
let QFixHowm_RecentMode = 2
let QFixHowm_RecentDays = 10
let QFixHowm_HowmTimeStampSort = 1
"vimで開くファイルの指定
let QFixHowm_OpenVimExtReg = '\.txt$\|\.vim$\|\.h$\|\.c$\|\.cpp$'
"オートリンクのタグジャンプファイル作成
let QFixHowm_UseAutoLinkTags = 1
"カテゴリタグ
nnoremap <silent> g,ht :call QFixHowmCreateNewFileWithTag('[ ]')<CR>
let QFixHowm_UserSwActionLock = ['[ ]', '[:private]', '[:vim]', '[:ot]']

"クイックメモのファイル名
let QFixHowm_QuickMemoFile = hostname().'-00-%Y-%m-00-000000.howm'
"オートリンク上のタグジャンプを使用する
let QFixHowm_UseAutoLinkTags = 1
"行頭にQFixHowm_Titleがあってもタイトルとして自動整形しない
let QFixHowm_Autoformat_TitleMode = 0
" ファイルの強制エンコーディングを行わない
"let QFixHowm_ForceEncoding = 0
let QFixHowm_Title = '#'
let HowmHtml_ConvertFunc = '<SID>MarkdownStr2HTML'

nnoremap <silent> g,. :<C-u>call HatenaSuperPreHighlight()<CR>
"Hatena super pre highlight
function! HatenaSuperPreHighlight()
    let ft = expand('%:e')
    if ft == 'howm'
        let ft = 'howm_memo'
    endif
    if &filetype != ft
        exec 'setlocal filetype='.ft
        return
    endif
    let sl = search('^>|.\+|$', 'ncbW')
    if sl == 0
        let sl = search('^>|.\+|$', 'ncW')
    endif
    if sl != 0
        let ft = getline(sl)
        let ft = substitute(ft, '[>|]', '', 'g')
        exec 'setlocal filetype='.ft
        return
    endif
endfunction

" ruby tags
autocmd FileType ruby,eruby setlocal tags+=~/.tags-ruby,~/.tags-rubygems
" ruby dictionary

autocmd FileType ruby,eruby setlocal dictionary=$DOTVIM/dict/ruby_snippets.dict


"------------------------------------
"neocomplete
"------------------------------------
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
" inoremap <expr><C-e>  neocomplete#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

let g:neosnippet#snippets_directory = expand($DOTVIM . '/snippets') . ',' . expand($VIMBUNDLE . '/snipmate-snippets/snippets') . ',' . expand($HOME . '/.vimlocal/snippets')

"------------------------------------
" template.vim
"------------------------------------
autocmd User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
    silent! %s/<+FILE NAME+>/\=Filename()/g
    silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g

    if search('<+CURSOR+>')
        execute 'normal! "_da>'
    endif
endfunction

"------------------------------------
" vim-ref
"------------------------------------
let g:ref_source_webdict_sites = {
            \    'je': {
            \        'url': 'http://dictionary.infoseek.ne.jp/jeword/%s',
            \    },
            \    'ej': {
            \        'url': 'http://dictionary.infoseek.ne.jp/ejword/%s',
            \    },
            \    'wiki': {
            \        'url': 'http://ja.wikipedia.org/wiki/%s',
            \    },
            \}
let g:ref_source_webdict_sites.default = 'ej'

function! g:ref_source_webdict_sites.je.filter(output)
    return join(split(a:output, "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.ej.filter(output)
    return join(split(a:output, "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki.filter(output)
    return join(split(a:output, "\n")[17 :], "\n")
endfunction

let g:ref_alc_encoding = 'Shift-JIS'
let g:ref_jquery_path = $HOME . '/Documents/jqapi-latest/docs'
let g:ref_phpmanual_path = $HOME . '/Documents/phpmanual'

nnoremap <silent> <Space>je :Ref webdict je <C-r><C-w><C-m><C-w>_
nnoremap <silent> <Space>ej :Ref webdict ej <C-r><C-w><C-m><C-w>_
nnoremap <silent> <Space>ee :Ref hyperdict <C-r><C-w><C-m><C-w>_
nnoremap <silent> <Space>s :Ref synonym <C-r><C-w><C-m><C-w>_

"------------------------------------
" vimfiler.vim
"------------------------------------
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0

let g:vimfiler_external_copy_directory_command = 'cp -r $src $dest'
let g:vimfiler_external_copy_file_command = 'cp $src $dest'
let g:vimfiler_external_delete_command = 'rm -r $srcs'
let g:vimfiler_external_move_command = 'mv $srcs $dest'

nnoremap <silent> <F2> :<C-u>VimFilerBufferDir -quit<CR>
" open vimfiler like explorer
" nnoremap <silent> <F3> :<C-u>VimFilerBufferDir -buffer-name=explorer -split -simple -winwidth=35 -no-quit -toggle<CR>
nnoremap <silent> <F3> :<C-u>VimFilerExplorer -buffer-name=explorer -split -simple -winwidth=55 -no-quit -toggle<CR>

"------------------------------------
" unite.vim
"------------------------------------
" The prefix key.
nnoremap    [unite]   <Nop>
nmap    f [unite]

nnoremap <silent> <C-n>  :<C-u>Unite -buffer-name=files buffer_tab<CR>
nnoremap <silent> <C-p>  :<C-u>UniteWithBufferDir -buffer-name=files file file_mru file/new<CR>
nnoremap <silent> <C-b>  :<C-u>Unite -buffer-name=files bookmark<CR>
nnoremap <silent> <C-j>  :<C-u>Unite -buffer-name=files file_mru<CR>


nnoremap [unite]u  :<C-u>Unite<Space>
nnoremap <silent> [unite];  :<C-u>Unite history/command<CR>
nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
nnoremap <silent> [unite]me :<C-u>Unite outline:message<CR>
nnoremap <silent> [unite]n  :<C-u>Unite -buffer-name=files buffer_tab<CR>
nnoremap <silent> [unite]p  :<C-u>UniteWithBufferDir -buffer-name=files file file_mru file/new<CR>
nnoremap <silent> [unite]f  :<C-u>Unite -buffer-name=files buffer file_mru bookmark file file/new<CR>
nnoremap <silent> [unite]j  :<C-u>Unite -buffer-name=files file_mru<CR>
nnoremap <silent> [unite]r  :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]q  :<C-u>Unite qf:ex=vimgrep\ <f-args>
nnoremap <silent> [unite]a  :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [unite]l  :<C-u>Unite locate<CR>
nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
nnoremap <silent> [unite]/  :<C-u>Unite line<CR>
nnoremap <silent> [unite]g  :<C-u>Unite grep:<CR>
nnoremap <silent> [unite]g  :<C-u>Unite grep:<CR><CR><C-W>
nnoremap <silent> <Leader>b  :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [unite]P :<C-u>call <SID>unite_project('-start-insert', 'file/new')<CR>
noremap [unite]t :<C-u>Unite tag:<C-r>=expand('<cword>')<CR><CR>

nnoremap <C-h>  :<C-u>UniteWithInput help<CR>
nnoremap <silent> g<C-h>  :<C-u>UniteWithkursorWord help<CR>

function! s:unite_project(...)
  let opts = (a:0 ? join(a:000, ' ') : '')
  let dir = escape(unite#util#path2project_directory(expand('%')), ':')
  execute 'Unite' opts 'file_rec:' . dir
endfunction

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
    " Overwrite settings.
    imap <buffer> jj      <Plug>(unite_insert_leave)
    nnoremap <silent><buffer> <C-k> :<C-u>call unite#mappings#do_action('preview')<CR>
    "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

    " Start insert.
    let g:unite_enable_start_insert = 1
endfunction"}}}

let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 50
let g:unite_source_file_mru_filename_format = ''

let g:unite_source_grep_recursive_opt = '-r'
call unite#custom#substitute('files', '\$\w\+', '\=eval(submatch(0))', 200)

call unite#custom#substitute('files', '[^~.]\zs/', '*/*', 20)
call unite#custom#substitute('files', '/\ze[^*]', '/*', 10)

call unite#custom#substitute('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
call unite#custom#substitute('files', '^@', '\=getcwd()."/*"', 1)
call unite#custom#substitute('files', '^\\', '~/*')

call unite#custom#substitute('files', '^;v', $DOTVIM . '/*')
call unite#custom#substitute('files', '^;r', '\=$VIMRUNTIME."/*"')
call unite#custom#substitute('files', '^;w', '~/Documents/workspace*')
if s:is_windows
  call unite#custom#substitute('files', '^;p', 'C:/Program Files/*')
endif

call unite#custom#substitute('files', '\*\*\+', '*', -1)
call unite#custom#substitute('files', '^\~', escape($HOME, '\'), -2)
call unite#custom#substitute('files', '\\\@<! ', '\\ ', -20)
call unite#custom#substitute('files', '\\ \@!', '/', -30)

call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')
autocmd FileType vimfiler call unite#custom_default_action('directory', 'lcd')

call unite#custom_filters('line', ['matcher_migemo', 'sorter_default', 'converter_default'])
"------------------------------------
" tabに関する設定
"------------------------------------
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

nnoremap [TABCMD]  <nop>
nmap     t [TABCMD]

nnoremap <silent> [TABCMD]f :<c-u>tabfirst<cr>
nnoremap <silent> [TABCMD]l :<c-u>tablast<cr>
nnoremap <silent> [TABCMD]n :<c-u>tabnext<cr>
nnoremap <silent> [TABCMD]N :<c-u>tabNext<cr>
nnoremap <silent> [TABCMD]p :<c-u>tabprevious<cr>
nnoremap <silent> [TABCMD]e :<c-u>tabedit<cr>
nnoremap <silent> [TABCMD]c :<c-u>tabclose<cr>
nnoremap <silent> [TABCMD]o :<c-u>tabonly<cr>
nnoremap <silent> [TABCMD]s :<c-u>tabs<cr>
nnoremap <silent> [TABCMD]t :<c-u>Unite -immediately tab:no-current<cr>

for n in range(1, 9)
  execute 'nnoremap <silent> [TABCMD]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

"------------------------------------
" grep.vim
"------------------------------------
" カーソル下の単語でGrepBuffer
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><CR>
nnoremap gb :<C-u>GrepBuffer<Space><C-r><C-w><CR>

"------------------------------------
" open-browser.vim
"------------------------------------
" カーソル下のURLをブラウザで開く
nmap Fu <Plug>(openbrowser-open)
vmap Fu <Plug>(openbrowser-open)
" カーソル下の単語でGoogle検索
nnoremap fs :<C-u>OpenBrowserSearch<Space><C-r><C-w><CR>

" XMLの閉タグを自動挿入
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END

autocmd FileType html let b:surround_49  = "<h1>\r</h1>"
autocmd FileType html let b:surround_50  = "<h2>\r</h2>"
autocmd FileType html let b:surround_51  = "<h3>\r</h3>"
autocmd FileType html let b:surround_52  = "<h4>\r</h4>"
autocmd FileType html let b:surround_53  = "<h5>\r</h5>"
autocmd FileType html let b:surround_54  = "<h6>\r</h6>"

autocmd FileType html let b:surround_112 = "<p>\r</p>"
autocmd FileType html let b:surround_117 = "<ul>\r</ul>"
autocmd FileType html let b:surround_111 = "<ol>\r</ol>"
autocmd FileType html let b:surround_108 = "<li>\r</li>"
autocmd FileType html let b:surround_97  = "<a href=\"\">\r</a>"
autocmd FileType html let b:surround_65  = "<a href=\"\r\"></a>"
autocmd FileType html let b:surround_105 = "<img src=\"\r\" alt=\"\" />"
autocmd FileType html let b:surround_73  = "<img src=\"\" alt=\"\r\" />"
autocmd FileType html let b:surround_100 = "<div>\r</div>"
autocmd FileType html let b:surround_68  = "<div class=\"section\">\r</div>"

"------------------------------------
" quickrun.vim
"------------------------------------
if !exists('g:quickrun_config')
    let g:quickrun_config = {'*' : {'split' : 'vertical rightbelow'}}
    let g:quickrun_config.markdown = {'exec' : ['Markdown.pl --html4tags %s > /tmp/markdown.html', 'open -g /tmp/markdown.html', 'cat /tmp/markdown.html']}
endif
let g:quickrun_config['html'] = { 'command' : 'open', 'exec' : '%c %s', 'outputter': 'browser' }

"------------------------------------
" reading-memo
"------------------------------------
nnoremap <Leader>m :call UploadReadingMemo()<CR>
function! UploadReadingMemo()
    let name = getline(1)

    QuickRun
    exec "!google docs delete --folder \"reading-memo\" --title \"" . name . "\""
    exec "!google docs upload --src /tmp/markdown.html --folder \"reading-memo\" --title \"" . name . "\""
endfunction

"------------------------------------
" blogit.vim
"------------------------------------
let blogit_unformat='pandoc --from=html --to=markdown --reference-links'
let blogit_format='pandoc --from=markdown --to=html --no-wrap'


"------------------------------------
" copypath.vim
"------------------------------------
" The prefix key.
nnoremap   [copypath] <Nop>
nmap     C [copypath]

nnoremap [copypath]p :<C-u>CopyPath<CR>
nnoremap [copypath]f :<C-u>CopyFileName<CR>

"------------------------------------
" vim-textmanip 
"------------------------------------
" 選択したテキストの移動
vmap <C-j> <Plug>(Textmanip.move_selection_down)
vmap <C-k> <Plug>(Textmanip.move_selection_up)
vmap <C-h> <Plug>(Textmanip.move_selection_left)
vmap <C-l> <Plug>(Textmanip.move_selection_right)

" 行の複製
vmap <M-d> <Plug>(Textmanip.duplicate_selection_v)
nmap <M-d> <Plug>(Textmanip.duplicate_selection_n)

" ディレクトリが無い場合に作成する
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

" evervim
nnoremap ,en :<C-u>EvervimCreateNote<Cr>

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_enable_smart_case = 1

if s:is_windows
  " Display user name on Windows.
  let g:vimshell_prompt = $USERNAME."% "
  let g:vimshell_use_ckw = 1
else
  " Display user name on Linux.
  let g:vimshell_prompt = $USER."% "

  call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
  call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
  let g:vimshell_execute_file_list['zip'] = 'zipinfo'
  call vimshell#set_execute_file('tgz,gz', 'gzcat')
    call vimshell#set_execute_file('tbz,bz2', 'bzcat')
endif

autocmd FileType vimshell
\ call vimshell#altercmd#define('g', 'git')
\| call vimshell#altercmd#define('i', 'iexe')
\| call vimshell#altercmd#define('l', 'll')
\| call vimshell#altercmd#define('ll', 'ls -l')
\| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')

" function! g:my_chpwd(args, context)
  " call vimshell#execute('ls')
" endfunction

autocmd FileType int-* call s:interactive_settings()
function! s:interactive_settings()
endfunction

" quickhl.vim
nmap <Space>m <Plug>(quickhl-toggle)
xmap <Space>m <Plug>(quickhl-toggle)
nmap <Space>M <Plug>(quickhl-reset)
xmap <Space>M <Plug>(quickhl-reset)
nmap <Space>j <Plug>(quickhl-match)
xmap <Space>J :QuickhlMatchClear<CR>

" easymotion
let g:EasyMotion_leader_key = '<Leader>,'

" for parallels
" inoremap <C-@> <ESC>

" template
autocmd BufNewFile *.rb 0r $DOTVIM/templates/rb.tpl
autocmd BufNewFile *.feature 0r $DOTVIM/templates/feature.tpl

" 文字列選択でクリップボードにコピー、右クリックで貼り付け
set guioptions+=a
nnoremap <RightMouse> "*p

nmap <F8> ;TagbarToggle<CR>

command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>') 
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

" Change current directory.
nnoremap <silent> <Space>cd :<C-u>CD<CR>

" vim-singleton
if s:is_windows
    call singleton#enable()
endif

" very magic
nnoremap / /\v
nnoremap ? ?\v

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

