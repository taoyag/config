"================================================================================
"    Description: Grepヘルパー
"     Maintainer: fuenor@gmail.com
"                 http://sites.google.com/site/fudist/Home/grep
"  Last Modified: 2009-12-23 22:06
"        Version: 2.03
"================================================================================
scriptencoding utf-8

if exists('enable_MyGrep')
  let disable_MyGrep = !enable_MyGrep
endif
if exists('disable_MyGrep') && disable_MyGrep
  finish
endif
if exists("loaded_MyGrep") && !exists('fudist')
  finish
endif
if v:version < 700 || &cp
  finish
endif
let loaded_MyGrep = 1

"メニューへの登録
amenu <silent> 30.331 &Tools.Grep(&G)<Tab>:Grep  :QFGrep!<CR>
amenu <silent> 30.331 &Tools.Fgrep(&G)<Tab>:FGrep  :QFFGrep!<CR>
amenu <silent> 30.331 &Tools.GrepBuffer(&G)<TAB>:BGrep :BGrep<CR>
amenu <silent> 30.331 &Tools.VGrep(&V)<Tab>:VGrep  :QFVGrep!<CR>

amenu <silent> 30.332 &Tools.Grepadd(&G)<Tab>:Grepadd  :QFGrepadd!<CR>
amenu <silent> 30.332 &Tools.Fgrepadd(&G)<Tab>:FGrepadd  :QFFGrepadd!<CR>
amenu <silent> 30.332 &Tools.GrepBufferadd(&G)<TAB>:BGrepadd :BGrepadd<CR>
amenu <silent> 30.332 &Tools.VGrepadd(&V)<Tab>:VGrepadd  :QFVGrepadd!<CR>

"使用するgrep指定
if !exists('mygrepprg')
  let mygrepprg = 'internal'
endif
"使用するgrepのエンコーディング指定
if !exists('g:MyGrep_ShellEncoding')
  let g:MyGrep_ShellEncoding = 'cp932'
endif
"検索対象外のファイル指定
if !exists('g:MyGrep_ExcludeReg')
  let g:MyGrep_ExcludeReg = '[~#]$\|\.bak$\|\.o$\|\.obj$\|\.exe$\|[/\\]tags$\|^tags$'
endif

"ダメ文字対策
if !exists('g:MyGrep_Damemoji')
  let g:MyGrep_Damemoji = 2
endif
"2byte目が0x5cの「ダメ文字」
let g:MyGrep_DamemojiReplaceDefault = ['[]','[ーソЫⅨ噂浬欺圭構蚕十申曾箪貼能表暴予禄兔喀媾彌拿杤歃濬畚秉綵臀藹觸軆鐔饅鷭偆砡纊犾]', '[ー―‐／＼＋±×ＡァゼソゾタダチボポマミАЪЫЬЭЮЯклмн院閏噂云運雲荏閲榎厭円魁骸浬馨蛙垣柿顎掛笠樫機擬欺犠疑祇義宮弓急救掘啓圭珪型契形鶏芸迎鯨后梗構江洪浩港砿鋼閤降察纂蚕讃賛酸餐施旨枝止宗充十従戎柔汁旬楯殉淳拭深申疹真神秦須酢図厨繊措曾曽楚狙疏捜掃挿掻叩端箪綻耽胆蛋畜竹筑蓄邸甜貼転顛点伝怒倒党冬如納能脳膿農覗倍培媒梅鼻票表評豹廟描府怖扶敷法房暴望某棒冒本翻凡盆諭夕予余与誉輿養慾抑欲蓮麓禄肋録論倭僉兌兔兢竸兩兪几處凩凭咫喙喀咯喊喟啻嘴嘶嘲嘸奸媼媾嫋嫂媽嫣學斈孺宀廖彈彌彎弯彑彖悳忿怡恠戞拏拿拆擔拈拜掉掟掵捫曄杣杤枉杰枩杼桀桍栲桎檗歇歃歉歐歙歔毬毫毳毯漾濕濬濔濘濱濮炮烟烋烝瓠畆畚畩畤畧畫痣痞痾痿磧禺秉秕秧秬秡窖窩竈窰紂綣綵緇綽綫總縵縹繃縷隋膽臀臂膺臉臍艝艚艟艤蕁藜藹蘊蘓蘋藾蛔蛞蛩蛬襦觴觸訃訖訐訌諚諫諳諧蹇躰軆躱躾軅軈轆轎轗轜錙鐚鐔鐓鐃鐇鐐閔閖閘閙顱饉饅饐饋饑饒驅驂驀驃鵝鷦鷭鷯鷽鸚鸛黠黥黨黯纊倞偆偰偂傔垬埈埇犾劯砡硎硤硺葈蒴蕓蕙]', '[ーソЫⅨ噂浬欺圭構蚕十申曾箪貼能表暴予禄兔喀媾彌拿杤歃濬畚秉綵臀藹觸軆鐔饅鷭偆砡纊犾－ポл榎掛弓芸鋼旨楯酢掃竹倒培怖翻慾處嘶斈忿掟桍毫烟痞窩縹艚蛞諫轎閖驂黥埈蒴僴礰]']

if !exists('g:MyGrep_DamemojiReplaceReg')
  let g:MyGrep_DamemojiReplaceReg = '(..)'
endif
if !exists('g:MyGrep_DamemojiReplace')
  let g:MyGrep_DamemojiReplace = '[]'
endif
"--includeオプションを使用する
if !exists('g:MyGrep_IncludeOpt')
  let g:MyGrep_IncludeOpt = 0
endif
"現在登録されているGrep結果を保存するファイル
if !exists('g:MyGrep_Resultfile')
  let g:MyGrep_Resultfile = '~/.qfgrep.txt'
endif

if !exists('g:QFix_Height')
  let g:QFix_Height = 10
endif
if !exists('g:QFix_HeightMax')
  let g:QFix_HeightMax = 0
endif
if !exists('g:QFix_HeightDefault')
  let g:QFix_HeightDefault = QFix_Height
endif
if !exists('g:QFix_HeightFixMode')
  let g:QFix_HeightFixMode = 0
endif
if !exists('g:QFix_CopenCmd')
  let g:QFix_CopenCmd = ''
endif

"検索時にカーソル位置の単語を拾う
if !exists('g:MyGrep_DefaultSearchWord')
  let g:MyGrep_DefaultSearchWord = 1
endif

"コマンドラインコマンドを使用する
if !exists('g:MyGrep_UseCommand')
  let g:MyGrep_UseCommand = 1
endif

"デフォルトのファイルパターン
if !exists('g:MyGrep_FilePattern')
  let g:MyGrep_FilePattern = ''
endif

"QFixHowm用の行儀の悪いオプション
let g:MyGrep_FileListWipeTime = 0

""""""""""""""""""""""""""""""
"ユーザ呼び出し用コマンド
""""""""""""""""""""""""""""""
if g:MyGrep_UseCommand == 1
  silent! command -nargs=? -bang BGrep   call BGrep(<q-args>, <bang>0, 0)
  silent! command -nargs=? -bang Grep    call UGrep('grep', <q-args>, <bang>0, 0)
  silent! command -nargs=? -bang EGrep   call UGrep('grep', <q-args>, <bang>0, 0)
  silent! command -nargs=? -bang FGrep   call UGrep('grep -F', <q-args>, <bang>0, 0)
  silent! command -nargs=? -bang Vimgrep call UGrep('vimgrep', <q-args>, <bang>0, 0)
  silent! command -nargs=? -bang VGrep   call UGrep('vimgrep', <q-args>, <bang>0, 0)

  silent! command -nargs=? -bang BGrepadd   call BGrep(<q-args>, <bang>0, 1)
  silent! command -nargs=? -bang Grepadd    call UGrep('grep', <q-args>, <bang>0, 1)
  silent! command -nargs=? -bang EGrepadd   call UGrep('grep', <q-args>, <bang>0, 1)
  silent! command -nargs=? -bang FGrepadd   call UGrep('grep -F', <q-args>, <bang>0, 1)
  silent! command -nargs=? -bang VGrepadd   call UGrep('vimgrep', <q-args>, <bang>0, 1)
  silent! command -nargs=? -bang Vimgrepadd call UGrep('vimgrep', <q-args>, <bang>0, 1)
endif

command! -nargs=? -bang QFBGrep call BGrep(<q-args>, <bang>0, 0)
command! -nargs=? -bang QFGrep  call Grep(<q-args>, <bang>0, 'Grep', 0)
command! -nargs=? -bang QFEGrep call Grep(<q-args>, <bang>0, 'Grep', 0)
command! -nargs=? -bang QFFGrep call FGrep(<q-args>, <bang>0, 0)
command! -nargs=? -bang QFVGrep call VGrep(<q-args>, <bang>0, 0)

command! -nargs=? -bang QFBGrepadd call BGrep(<q-args>, <bang>0, 1)
command! -nargs=? -bang QFGrepadd  call Grep(<q-args>, <bang>0, 'Grepadd', 1)
command! -nargs=? -bang QFEGrepadd call Grep(<q-args>, <bang>0, 'Grepadd', 1)
command! -nargs=? -bang QFFGrepadd call FGrep(<q-args>, <bang>0, 1)
command! -nargs=? -bang QFVGrepadd call VGrep(<q-args>, <bang>0, 1)

let s:usekeymap = 1
if !exists('g:MyGrep_Key')
  let g:MyGrep_Key = 'g'
  if exists('g:QFixHowm_Key')
    let g:MyGrep_Key = g:QFixHowm_Key
  endif
endif
if !exists('g:MyGrep_KeyB')
  let g:MyGrep_KeyB = ','
  if exists('g:QFixHowm_KeyB')
    let g:MyGrep_KeyB = g:QFixHowm_KeyB
  endif
endif
let s:MyGrep_Key = g:MyGrep_Key . g:MyGrep_KeyB

exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'b  :call BGrep("", 0, 0)<CR>'
exec 'silent! vnoremap <unique> <silent> '.s:MyGrep_Key.'b  :call BGrep("", -1, 0)<CR>'
exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'e  :QFGrep!<CR>'
exec 'silent! vnoremap <unique> <silent> '.s:MyGrep_Key.'e  :call Grep("", -1, "Grep", 0)<CR>'
exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'f  :QFFGrep!<CR>'
exec 'silent! vnoremap <unique> <silent> '.s:MyGrep_Key.'f  :call FGrep("", -1, 0)<CR>'
exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'v  :QFVGrep!<CR>'
exec 'silent! vnoremap <unique> <silent> '.s:MyGrep_Key.'v  :call VGrep("", -1, 0)<CR>'

exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'B  :BGrepadd<CR>'
exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'E  :QFGrepadd!<CR>'
exec 'silent! vnoremap <unique> <silent> '.s:MyGrep_Key.'E  :call Grep("", -1, "Grep", 1)<CR>'
exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'F  :QFFGrepadd!<CR>'
exec 'silent! vnoremap <unique> <silent> '.s:MyGrep_Key.'F  :call FGrep("", -1, 1)<CR>'
exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'V  :QFVGrepadd!<CR>'
exec 'silent! vnoremap <unique> <silent> '.s:MyGrep_Key.'V  :call VGrep("", -1, 1)<CR>'
exec 'silent! nnoremap <unique> <silent> '.s:MyGrep_Key.'k :MyGrepReadResult<CR>\|:QFixCopen<CR>'

""""""""""""""""""""""""""""""
"ユーザ呼び出し用コマンド本体
""""""""""""""""""""""""""""""
command! -bang ToggleDamemoji let MyGrep_Damemoji = <bang>0?2:!MyGrep_Damemoji|echo 'Damemoji '.(MyGrep_Damemoji?'ON':'OFF')

""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
function! VGrep(word, mode, addflag)
  let addflag = a:addflag
  let title = 'VGrep'
  if addflag
    let title = 'VGrepadd'
  endif
  let g:MyGrep_UseVimgrep = 1
  call Grep(a:word, a:mode, title, addflag)
endfunction

""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
function! FGrep(word, mode, addflag)
  let addflag = a:addflag
  let title = 'FGrep'
  if addflag
    let title = 'FGrepadd'
  endif
  let pattern = a:word
  let g:MyGrep_Regexp = 0
  call Grep(pattern, a:mode, title, addflag)
endfunction

""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
function! UGrep(cmd, args, mode, addflag)
  if a:args == ''
    if a:cmd == 'grep'
      let title = a:addflag?'Grepadd':'Grep'
      return Grep('', a:mode, title, a:addflag)
    elseif a:cmd == 'grep -F'
      return FGrep('', a:mode, a:addflag)
    elseif a:cmd == 'vimgrep'
      return VGrep('', a:mode, a:addflag)
    endif
    return Grep('', a:mode, title, a:addflag)
  endif
  let addflag = a:addflag
  let g:QFix_SearchPath = getcwd()
  if a:mode
    let disppath = expand('%:p:h')
  else
    let disppath = g:QFix_SearchPath
  endif
  let g:QFix_SearchPath = disppath
  let bufnr = bufnr('%')
  let save_cursor = getpos('.')
  if addflag == 0
    silent! cexpr ''
  endif
  call s:MyGrepPclose()
  silent! cclose
  if g:QFix_SearchPath != ''
    silent exec 'lchdir ' . escape(g:QFix_SearchPath, ' ')
  endif
  if addflag
    let g:QFix_SearchPath = disppath
  endif

  let cmd = a:cmd.' '. a:args
  exec cmd
"  cclose
  let g:QFix_Modified = 1
"  echom retval
  let g:QFix_MyJump = 1
  let g:QFix_SelectedLine = 1
  let g:QFix_SearchResult = []
  let save_qflist = getqflist()
  let g:QFixPrevQFList = save_qflist
  if empty(save_qflist)
    redraw | echo 'QFixGrep : Not found!'
  else
    if g:QFix_HeightFixMode == 1
      let g:QFix_Height = g:QFix_HeightDefault
    endif
    QFixCopen
    redraw | echo ''
  endif
endfunction

""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
function! Grep(word, mode, title, addflag)
  let addflag = a:addflag
  let pattern = a:word
  let extpattern = ''
  let extpat = '\(\s\+\(\*\*\/\)\?\*\.[^.]\+\)\+$'
  if pattern =~ extpat
    let extpattern = matchstr(pattern, extpat)
    let pattern = substitute(pattern, extpat, '', '')
  endif
  if pattern == '' || a:mode == -1
    let pattern = expand("<cword>")
    if g:MyGrep_DefaultSearchWord == 0
      let pattern = ''
    endif
    if a:mode == -1
      exec 'normal! vgvy'
      let pattern = @0
    endif
    let pattern = input(a:title." : ", pattern)
  endif
  if pattern == ''
    let g:MyGrep_Regexp = 1
    let g:MyGrep_Ignorecase = 1
    let g:MyGrep_Recursive  = 0
    let g:MyGrep_UseVimgrep = 0
    return
  endif
  let filepattern = '*'
  if expand('%:e') != ''
    let filepattern = '*.' . expand('%:e')
  endif
  if g:MyGrep_FilePattern != ''
    let filepattern = g:MyGrep_FilePattern
  endif
  if extpattern == ''
    let filepattern = input("file pattern : ", filepattern)
  else
    let filepattern = extpattern
  endif
  if filepattern == '' | return | endif
  let @/ = '\V'.pattern
  call histadd('/', @/)
  call histadd('@', pattern)
  if match(pattern, '\C[A-Z]') != -1
    let g:MyGrep_Ignorecase = 0
  endif
  if a:mode == 0
    let searchPath = getcwd()
  else
    let searchPath = expand('%:p:h')
  endif
  let fenc = &fileencoding
  if fenc == ''
    let fenc = &enc
  endif
  let prevPath = getcwd()
  let prevPath = escape(prevPath, ' ')
  if a:addflag && g:QFix_SearchPath != ''
    let disppath = g:QFix_SearchPath
  else
    let disppath = searchPath
  endif
  let g:QFix_SearchPath = disppath
  if exists('*QFixSaveHeight')
    call QFixSaveHeight(0)
  endif
  call s:MyGrepPclose()
  silent! cclose
  call MyGrep(pattern, searchPath, filepattern, fenc, addflag)
  if g:QFix_SearchPath != ''
    silent exec 'lchdir ' . escape(g:QFix_SearchPath, ' ')
  endif
  let save_qflist = getqflist()
  if empty(save_qflist)
    redraw | echo 'QFixGrep : Not found!'
    if s:MyGrep_ErrorMes != ''
      echohl ErrorMsg
      redraw | echo s:MyGrep_ErrorMes
      echohl None
    endif
  else
    if g:QFix_HeightFixMode == 1
      let g:QFix_Height = g:QFix_HeightDefault
    endif
    if a:addflag
      let g:QFix_SearchPath = disppath
    endif
    QFixCopen
    redraw | echo ''
  endif
  silent exec 'lchdir ' . prevPath
endfunction

""""""""""""""""""""""""""""""
"バッファのみgrep
"無名バッファは検索できない。
""""""""""""""""""""""""""""""
function! BGrep(word, mode, addflag)
  let pattern = a:word
  let mes = "Buffers grep : "
  if a:addflag
    let mes = "Buffers grepadd : "
  endif
  if pattern == '' || a:mode == -1
    let pattern = expand("<cword>")
    if g:MyGrep_DefaultSearchWord == 0
      let pattern = ''
    endif
    if a:mode < 0
      let pattern = @0
    endif
    let pattern = input(mes, pattern)
  endif
"  let pattern = escape(pattern, '\\/.*$^~[]')
"  let pattern = substitute(pattern, '\n$', '', '')
  if pattern == '' | return | endif
  if a:addflag && g:QFix_SearchPath != ''
    let disppath = g:QFix_SearchPath
  else
    let disppath = expand('%:p:h')
  endif
  let g:QFix_SearchPath = disppath
  let @/ = pattern
  call histadd('/', '\V' . @/)
  call histadd('@', pattern)
  let bufnr = bufnr('%')
  let save_cursor = getpos('.')
  if a:addflag == 0
    silent! cexpr ''
  endif
  call s:MyGrepPclose()
  silent! cclose
  if g:QFix_SearchPath != ''
    silent exec 'lchdir ' . escape(g:QFix_SearchPath, ' ')
  endif
  silent! exec ':bufdo | try | vimgrepadd /' . pattern . '/j % | catch | endtry'
  silent! exec 'b'.bufnr
  if a:addflag
    let g:QFix_SearchPath = disppath
  endif
  let g:QFix_MyJump = 1
  let g:QFix_SelectedLine = 1
  let g:QFix_SearchResult = []
  let save_qflist = getqflist()
  if empty(save_qflist)
    redraw | echo 'QFixGrep : Not found!'
  else
    if g:QFix_HeightFixMode == 1
      let g:QFix_Height = g:QFix_HeightDefault
    endif
    QFixCopen
    redraw | echo ''
  endif
endfunction

""""""""""""""""""""""""""""""
"grep helper
""""""""""""""""""""""""""""""
if !exists('g:MyGrepcmd')
  let g:MyGrepcmd = '"#prg#" #defopt# #recopt# #opt# #useropt# -f #searchWordFile# #searchPath#'
endif
if !exists('g:MyGrepcmd_useropt')
  let g:MyGrepcmd_useropt = ''
endif
if !exists('g:MyGrepcmd_regexp')
  let g:MyGrepcmd_regexp = '-nHIE'
endif
if !exists('g:MyGrepcmd_regexp_ignore')
  let g:MyGrepcmd_regexp_ignore = '-nHIEi'
endif
if !exists('g:MyGrepcmd_fix')
  let g:MyGrepcmd_fix = '-nHIF'
endif
if !exists('g:MyGrepcmd_fix_ignore')
  let g:MyGrepcmd_fix_ignore = '-nHIFi'
endif
"オプション
if !exists('g:MyGrep_StayGrepDir')
  let g:MyGrep_StayGrepDir = 1
endif
if !exists('g:MyGrep_Ignorecase')
  let g:MyGrep_Ignorecase = 1
endif
if !exists('g:MyGrep_Regexp')
  let g:MyGrep_Regexp = 1
endif
if !exists('g:MyGrep_Recursive')
  let g:MyGrep_Recursive = 0
endif

if !exists('g:MyGrep_yagrep_opt')
  let g:MyGrep_yagrep_opt = 0
endif
if !exists('g:QFix_SearchPath')
  let g:QFix_SearchPath = ''
endif

"一時的にvimgrepを使用したいときに非0。使用後リセットされる。
let g:MyGrep_UseVimgrep = 0

""""""""""""""""""""""""""""""
"汎用Grep関数
"vimgrepならfencは無視される。
"addflag : grep検索結果追加
""""""""""""""""""""""""""""""
function! MyGrepadd(pattern, searchPath, filepattern, fenc)
  return MyGrep(a:pattern, a:searchPath, a:filepattern, a:fenc, 1)
endfunction

function! MyGrep(pattern, searchPath, filepattern, fenc, addflag, ...)
  let addflag = a:addflag
  let searchPath = a:searchPath
  let pattern = a:pattern
  let prevPath = getcwd()
  let prevPath = escape(prevPath, ' ')
  if g:MyGrep_ExcludeReg == ''
    let g:MyGrep_ExcludeReg = '^$'
  endif
  if a:fenc =~ 'le$'
    let g:MyGrep_UseVimgrep = 1
    redraw | echo 'Use vimgrep(fenc = '.a:fenc .')'
  endif
  if g:mygrepprg == 'internal' || g:mygrepprg == '' || g:MyGrep_UseVimgrep != 0
    silent exec 'lchdir ' . escape(searchPath, ' ')
    if addflag
      silent! exec ':vimgrepadd /' . pattern . '/j ' . a:filepattern
    else
      silent! cexpr ''
      silent! exec ':vimgrep /' . pattern . '/j ' . a:filepattern
    endif
    "ここでバッファ削除
    let idx = 0
    let save_qflist = getqflist()
    for d in save_qflist
      if bufname(d.bufnr) =~ g:MyGrep_ExcludeReg
        call remove(save_qflist, idx)
        silent! exec 'silent! bd ' . d.bufnr
      else
        let idx = idx + 1
      endif
    endfor
    call MyGrepSetqflist(save_qflist)
    if g:MyGrep_StayGrepDir == 0
      silent exec 'lchdir ' . prevPath
    endif
    let g:MyGrep_Regexp = 1
    let g:MyGrep_Ignorecase = 1
    let g:MyGrep_Recursive  = 0
    let g:MyGrep_UseVimgrep = 0
    " MyQFixライブラリを使用可能にする。
    call QFixEnable(searchPath)
    return
  endif

  let l:mygrepprg = expand(g:mygrepprg)
  if !executable(l:mygrepprg)
    echohl ErrorMsg
    redraw|echom '"'.l:mygrepprg.'"'." is not executable!"
    echohl None
    let mes = '"'.l:mygrepprg.'" is not executable!'
    let choice = confirm(mes, "&OK")
    let g:MyGrep_Regexp = 1
    let g:MyGrep_Ignorecase = 1
    let g:MyGrep_Recursive  = 0
    let g:MyGrep_UseVimgrep = 0
    return
  endif
  if g:MyGrep_ShellEncoding =~ 'utf8\c'
    let g:MyGrep_ShellEncoding = 'utf-8'
  endif
  if g:mygrepprg =~ 'yagrep\c'
    if g:MyGrep_yagrep_opt == 2
      let g:MyGrep_Damemoji = 0
    endif
  endif
  let _grepcmd = 'g:MyGrepcmd_regexp'
  if g:MyGrep_Regexp == 0
    let _grepcmd = 'g:MyGrepcmd_fix'
    let g:MyGrep_Regexp = 1
  else
    "だめ文字対策
    if g:MyGrep_Damemoji != 0 && a:fenc == 'cp932'
      let pp = substitute(pattern, g:MyGrep_DamemojiReplaceDefault[2], '', 'g')
      let pp = substitute(pp, '[\\.()?+{}\[\]*]', '', 'g')
      if pp =~ '^\s*$'
        let s:MyGrep_ErrorMes = "ダメ文字しか含まれていません!"
        silent! cexpr ''
        let g:MyGrep_Regexp = 1
        let g:MyGrep_Ignorecase = 1
        let g:MyGrep_Recursive  = 0
        let g:MyGrep_UseVimgrep = 0
        return
      endif
      let pattern = substitute(pattern, g:MyGrep_DamemojiReplaceDefault[g:MyGrep_Damemoji], g:MyGrep_DamemojiReplaceReg, 'g')
      let pattern = substitute(pattern, g:MyGrep_DamemojiReplace, g:MyGrep_DamemojiReplaceReg, 'g')
    endif
  endif
  if g:MyGrep_Ignorecase > 0
    let _grepcmd = _grepcmd.'_ignore'
  endif
  let g:MyGrep_Ignorecase = 1
  let grepcmd = substitute(g:MyGrepcmd, '#defopt#', {_grepcmd}, '')
  let grepcmd = substitute(grepcmd, '#useropt#', g:MyGrepcmd_useropt, '')
  let retval = s:ExecGrep(grepcmd, g:mygrepprg, searchPath, pattern, &enc, a:fenc, a:filepattern)
  let pattern = s:ParseFilepattern(a:filepattern)
  redraw|echo 'QFixGrep : Parsing...'
  let retval = s:ParseSearchResult(retval, pattern, g:MyGrep_ShellEncoding, a:fenc)
  let file = ''
  if a:0 > 0
    let file = a:1
    let retval = searchPath."||\<NL>".retval
  endif
  redraw|echo 'QFixGrep : Set quickfix list...'
  call s:SetQFix(retval, addflag, file)
  if g:MyGrep_StayGrepDir == 0
    silent exec 'lchdir ' . prevPath
  endif
  " MyQFixライブラリを使用可能にする。
  call QFixEnable(searchPath)
  redraw | echo ''
endfunction

let s:MyGrep_ErrorMes = ''
let s:tempname = tempname()

""""""""""""""""""""""""""""""
"検索語ファイルを作成してgrep
""""""""""""""""""""""""""""""
function! s:ExecGrep(cmd, prg, searchPath, searchWord, from_encoding, to_encoding, filepattern)
  " iconv が使えない
  let s:MyGrep_ErrorMes = ''
  if a:from_encoding != a:to_encoding && !has('iconv')
"    echoe 'QFixGrep : not found iconv!'
    let s:MyGrep_ErrorMes = 'QFixGrep : Not found iconv!'
    let choice = confirm(s:MyGrep_ErrorMes, "&OK")
    return
  endif

  let cmd = a:cmd
  " プログラム設定
  let prg = escape(expand(a:prg), '\\')
  let cmd = substitute(cmd, '#prg#', prg, 'g')

  let sPath = '*'
  let ropt = ''
  let opt = ''

  " 検索パス設定
  if match(a:filepattern, '\*\*/') != -1
    let g:MyGrep_Recursive = 1
  endif
  if g:MyGrep_Recursive == 1
    let ropt = '-r'
    let g:MyGrep_Recursive = 0
  endif
  if g:mygrepprg =~ 'yagrep\c'
    if a:to_encoding =~ 'cp932\c'
      let opt = '--ctype=SJIS'
    elseif a:to_encoding =~ 'euc\c'
      let opt = '--ctype=EUC'
    elseif a:to_encoding =~ 'utf-8\c'
      let opt = '--ctype=UTF8'
    endif
    let opt = opt .' -s'
    if g:MyGrep_yagrep_opt == 0
      let opt = ' -s'
    endif
  endif
  if g:MyGrep_IncludeOpt == 1
    let ipat = substitute(a:filepattern, '\*\*/', '', 'g')
    "TODO:空白で区切られたファイルの種類だけ--include=*.hoge
    "簡単に試した限りでは、さほど速度向上にならない気がする。
    "さらに--includeオプションにバグのあるgrepも存在する。
    let opt = opt.' --include='.ipat
  endif
  let cmd = substitute(cmd, '#recopt#', ropt, '')
  let cmd = substitute(cmd, '#opt#', opt, '')
  let cmd = substitute(cmd, '#searchPath#', escape(sPath, '\\'), 'g')

  " 検索語ファイル作成
  if match(cmd, '#searchWordFile#') != -1
"    let s:tempname = tempname()
    let searchWord = iconv(a:searchWord, a:from_encoding, a:to_encoding)
    let searchWordList = [searchWord]
    call writefile(searchWordList, s:tempname, 'b')
    let cmd = substitute(cmd, '#searchWordFile#', s:GrepEscapeVimPattern(s:tempname), 'g')
  endif

  " 検索実行
  let prevPath = getcwd()
  let prevPath = escape(prevPath, ' ')
  silent exec 'lchdir ' . escape(a:searchPath, ' ')
  let retval = system(cmd)
  if exists('s:tempname')
    silent! call delete(s:tempname)
  endif
  return retval
endfunction

""""""""""""""""""""""""""""""
"ファイルパターンを変換
""""""""""""""""""""""""""""""
function! s:ParseFilepattern(filepattern)
  let filepattern = a:filepattern
  let filepattern = substitute(filepattern, '\*\*/', '', 'g')
  let filepattern = substitute(filepattern, '\s\+', ' ', 'g')
  let filepattern = substitute(filepattern, '^\s\|\s$', '', 'g')
  if filepattern == '*'
    let filepattern = '.*'
  else
    let filepattern = substitute(filepattern, ' ', '$\\|', 'g')
    let filepattern = substitute(filepattern, '\.', '\\.', 'g')
    let filepattern = substitute(filepattern, '^*', '\.*', 'g')
    let filepattern = substitute(filepattern, '\\|\*', '\\|\.\*', 'g')
    let filepattern = filepattern.'$'
  endif
  return filepattern
endfunction

""""""""""""""""""""""""""""""
"quickfix登録前処理
""""""""""""""""""""""""""""""
function! s:ParseSearchResult(searchResult, filepattern, shellenc, fenc)
  let wipetime = g:MyGrep_FileListWipeTime
  let g:MyGrep_FileListWipeTime = 0
  if &enc == a:shellenc && &enc == 'cp932' && a:fenc != 'cp932'
"    return a:searchResult
  endif
  let parseResult = ''
  let searchResult = a:searchResult
  let prevfname = ''
  let qfmtime = -1
  let mtime = 0
  while 1
    let idx = match(searchResult, "\<NL>")
    if idx == -1
      break
    endif
    let buf          = strpart(searchResult, 0, idx)
    let searchResult = strpart(searchResult, idx + 1)
    let bufidx       = matchend(buf, ":[0-9]\\+:", 0, 1)
    let extidx       = match(buf, ":[0-9]\\+:", 0, 1)
    let file         = strpart(buf, 0, bufidx)
    let fname        = strpart(buf, 0, extidx)
    if a:shellenc != &enc
      let fname = iconv(fname, a:shellenc, &enc)
    endif
    if wipetime > 0
      if prevfname != fname
        let qfmtime = getftime(fname)
        let prevfname = fname
      endif
      if qfmtime < wipetime
        continue
      endif
    endif
    let ext          = strpart(buf, 0, extidx)
    let content      = strpart(buf, bufidx)
    if a:shellenc != &enc
      let file = iconv(file, a:shellenc, &enc)
    endif
    if a:fenc != &enc
      let content = iconv(content, a:fenc, &enc)
    endif
    let content      = strpart(content, 0, 1024-strlen(file)-32)
    if ext =~ a:filepattern && fname !~ g:MyGrep_ExcludeReg
      let parseResult = parseResult . file . content . "\<NL>"
    endif
  endwhile
  return parseResult
endfunction

""""""""""""""""""""""""""""""
"quickfixに登録
""""""""""""""""""""""""""""""
function! s:SetQFix(result, addflag, file)
  let result = a:result
  let tmpfile = a:file
  if tmpfile != ''
    let saved_verbose = &verbose
    set verbose&vim
    exe 'redir! > ' . tmpfile
    silent echon result
    redir END
    let &verbose = saved_verbose
    return
  endif

  let saved_efm = &efm
  set errorformat=%f:%\\s%#%l:%m
  if a:addflag
    caddexpr result
  else
    cgetexpr result
  endif
  let &errorformat = saved_efm
  return
endfunction

""""""""""""""""""""""""""""""
"正規表現エスケープ
""""""""""""""""""""""""""""""
function! s:GrepEscapeVimPattern(pattern)
  let retval = escape(a:pattern, '\\.*+@{}<>~^$()|?[]%=&')
  let retval = retval
  return retval
endfunction

""""""""""""""""""""""""""""""
"QFixPcloseが存在する時はpcloseの代わりに使用する
""""""""""""""""""""""""""""""
function! s:MyGrepPclose()
  if exists('*QFixPclose')
    call QFixPclose()
  else
    silent! pclose
  endif
endfunction

""""""""""""""""""""""""""""""
"setqflist代替
""""""""""""""""""""""""""""""
function! MyGrepSetqflist(sq)
  if g:QFix_SearchPath != ''
    silent exec 'lchdir ' . escape(g:QFix_SearchPath, ' ')
  endif
  let g:QFix_Modified = 1
  let g:QFixPrevQFList = a:sq
  return setqflist(a:sq)
endfunction

function! QFixEnable(path)
  let g:QFix_SearchPath = a:path
  let g:QFix_SelectedLine = 1
  let g:QFix_MyJump = 1
endfunction

command! -nargs=* -bang QFixCopen call QFixCopen(<q-args>, <bang>0)

""""""""""""""""""""""""""""""
"copen代替
""""""""""""""""""""""""""""""
if !exists('*QFixCopen')
  function! QFixCopen(cmd, mode)
    copen
  endfunction
endif
