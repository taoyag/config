" vim: set ts=4 sts=4 sw=4 noet fdm=marker:
" $Id: pukiwiki.vim 13 2008-07-27 10:12:31Z ishii $
" pukiwiki.vim 私家版0.0.4(by id:ampmmn)

if exists('loaded_pukivim') || &cp
  finish
endif
let loaded_pukivim=1

if exists('plugin_pukiwiki_disable')
	finish
endif

" ToDo {{{
" ToDo: InterWikiへの対応
" ToDo: WikiLink内の相対パス指定を解決する(例: ./page,../pageなど)
" ToDo: PukiWiki-Plusの開発版(?)だと、RecentChangesリストで時間が表示されない(epochコマンド) 
"       (Wikiページソースではなく、HTMLソースから必要な箇所を切り出す必要がある)
" ToDo: 凍結されていない状態で凍結解除した場合にその旨出力していない
" ToDo: 凍結状態で再凍結を実行した場合にその旨出力していない
"}}}
" オリジナルからの変更点 {{{
" - Vim7以降でしか動かなくなった(改悪)
" - 1ファイル化(alice.vim含む)
" - proxy設定の追加
" - 401を返した場合はユーザ名/passwordを入力して再試行
" - PukiWiki Plus(?)で追加された、セッションチケットへの対処
" - 凍結ページはreadonlyでとりあえず表示
" - 凍結/凍結解除機能
" - PukiVimコマンドで引数を受け取るようにした
" - Windows環境下でURLに%...%という形式を含む場合に
"   意図しない環境変数へ展開されてしまう現象への対処
" - ユーザファイル保存位置は常に~/(.vim)|(vimfiles)/pukiwim/以下
" - bookmarkのサイト情報でトップページが指定されなかった場合はFrontPageをデフォルトに
" - 外部URL(http://～)への対応
"}}}
" 私家版ChangeLog {{{
"	 0.0.4		2009-04-08	デバッグメッセージ消し忘れたほか
"	 0.0.3		2009-04-07	ダイジェスト認証が通らないのを修正ほか
"	 0.0.2		2009-04-03	一部の処理でレジスタの値を書き換える不具合の修正
"	 0.0.1		2009-04-01	初版
"}}}

" Check Env. "{{{
if v:version < 700
	echoerr "pukiwiki.vim requires Vim 7.0 or later."
	finish
endif
"}}}

scriptencoding utf-8

" global 変数"{{{

" http://vimwiki.net/pukivim_version を取得して
" スナップショットが更新されているかチェックする。
" NOTE:私家版なので下記機能は強制的に無効
"if !exists('g:pukiwiki_check_snapshot')
	let g:pukiwiki_check_snapshot = 0
"endif

" プロキシの設定
if !exists("g:pukiwiki_proxy")
	let g:pukiwiki_proxy=''
endif

" ユーザファイル(ブックマークディレクトリだけ)の保存ディレクトリ
if !exists('g:pukiwiki_datadir')
	" ~/(.vim)|(vimfiles/pukiwiki をデフォルトとする
	let dotvimdir = split(&runtimepath,',')[0]
	let g:pukiwiki_datadir = expand(dotvimdir . '/pukiwiki')
endif

" 外部URLを開くためのコマンドライン
"let g:pukiwiki_urlbrowse_command = ''
if !exists('g:pukiwiki_urlbrowse_command')
	if has('win32')
		"let g:pukiwiki_urlbrowse_command = '"'.expand('"$PROGRAMFILES/Mozilla Firefox/firefox.exe"').'"'
		let g:pukiwiki_urlbrowse_command = 'explorer'
	elseif has('macunix')
		let g:pukiwiki_urlbrowse_command = 'open'
	endif
endif


"}}}

" Command"{{{
command! -nargs=* PukiVim call s:show_bookmark(<f-args>)
command! -nargs=0 PukiVimBrowserOpen call s:show_browser(bufnr('%'))
command! -nargs=+ PukiVimCmd call s:wiki_command(<f-args>)
"}}}

" このスクリプトの更新日時
let s:version_serial = 20090331
" バージョンチェック用URL
let s:version_url = 'http://vimwiki.net/pukivim_version'

"let s:bracket_name = '\[\[\%(\s\)\@!:\=[^\r\n\t[\]<>#&":]\+:\=\%(\s\)\@<!\]\]'
"let s:bracket_name = '\[\[\%(\s\)\@!:\=[^\r\n\t[\]<>#&":]\+:\=\%(\s\)\@<!\]\]'
let s:bracket_name = '\[\[\_.\{-}\]\]'

" エラーメッセージのハイライト出力
function! s:echoErr(msg)"{{{
	echohl ErrorMsg | echo a:msg | echohl
	return 0
endfunction"}}}

" Warningメッセージのハイライト出力
function! s:echoWarning(msg)"{{{
	echohl WarningMsg |echo a:msg|echohl
	return 0
endfunction
"}}}

" 辞書から文字列
function! s:joindict(dict, sep)"{{{
	let data = ''
	for _ in keys(a:dict)
		if data != ''
			let data .= a:sep
		endif
		let data .= printf('%s=%s', _, a:dict[_])
	endfor
	return data
endfunction"}}}

" 指定されたURLを外部プログラムで開く
" (呼び出し側でURLエンコードしてください)
function! s:open_external_url(url) "{{{
	if !exists('g:pukiwiki_urlbrowse_command')
		return
	endif
	let s = g:pukiwiki_urlbrowse_command . " " . a:url
	silent! call system(s)
endfunction
"}}}

" Win32環境固有のエスケープ処理
function! s:escape_for_win32(data) "{{{
	let data = a:data
	" Windowsで、%...%という文字列がパスに含まれていた場合、
	" 環境変数として展開されてしまうことがあるため、これをエスケープする
	if has('win32') == 0
		return data
	endif
	let data = substitute(data, '%', '^\%', 'g')
	let data = substitute(data, '&', '^&', 'g')
	let data = substitute(data, '"', '""', 'g')
	return '"'.data.'"'
endfunction
"}}}

" ファイル読み込み
function! s:readfile(filepath) "{{{
	if filereadable(a:filepath) == 0
		return ''
	endif
	return join(readfile(a:filepath), "\n")
endfunction"}}}

" ヘッダ文字列を生成
function! s:header_string(enable_reload, enable_freeze, freeze)"{{{
	let reload = a:enable_reload? "[リロード] ": ""
	let freeze = a:enable_freeze == 0? '' : a:freeze ? '[凍結解除] ' : '[凍結] '
	return printf("[トップ] %s[新規] %s[一覧] [単語検索] [最終更新] [ヘルプ]\n%s\n",
	\             reload, freeze,
	\             "------------------------------------------------------------------------------")
endfunction
"}}}

" ブックマークページの表示
" 関数の引数が指定された場合、指定されたページを表示します。
" a:000[0] : サイト名 a:000[1] : ページ名
" 例: s:show_bookmark('MyWiki', 'Help')   " MyWikiのHelpページを表示
function! s:show_bookmark(...)"{{{
	let bookmark = {}
	if !s:init_check(bookmark)
		return s:echoErr('起動に失敗しました')
	endif

	if !filereadable(bookmark.path)
		return s:echoErr('ブックマークの読み込みに失敗しました')
	endif
	" ブックマークページを表示し、ローカルなキーマッピングを設定
	if bufexists(bookmark.path) == 0
		execute "e " . bookmark.path
	else
		execute bufnr(bookmark.path) "buffer"
	endif
	nnoremap <silent><buffer> <CR>  :call <SID>open_site('.', '')<CR>
	nnoremap <silent><buffer> <TAB> :call <SID>next_bookmark_item()<CR>

	if s:new_version_exists()
		" 行数をあふれさせてHit-Enterメッセージをわざと表示(FIXME:と思ったらHit-Enterでない)
		call s:echoWarning('PukiVim のスナップショットが更新されています' . repeat("\n", &cmdheight) )
	endif

	" 引数の内容に応じて処理を実行
	if len(a:000) == 0
		return 
	endif

	let cur_pos = getpos('.')

	let site_name = a:000[0]
	normal! gg
	let line = search('^'.site_name)
	call setpos('.', cur_pos)

	if line == 0
		return s:echoWarning('サイト名 '.site_name.'は見つかりませんでした')
	endif

	let page = len(a:000) > 1? a:000[1]: ''
	call s:open_site(line, page)
endfunction
"}}}

" 指定したバッファ番号に対応するバッファで表示しているページをブラウザで開く
function! s:show_browser(buf_nr) "{{{
	let wiki = getbufvar(a:buf_nr, 'PukiWiki')
	let page = getbufvar(a:buf_nr, 'PukiWikiPage')
	if type(page) != type({}) || type(page) != type({})
		return
	endif
	call s:open_external_url(wiki.make_full_url(page.name))
endfunction
"}}}

" コマンドの実行
function! s:wiki_command(...) "{{{
	if len(a:000) < 1
		return 
	endif

	if exists('b:PukiWiki') == 0
		return
	endif

	let wiki = b:PukiWiki
	return wiki.command(a:000[0], a:000[1:])
endfunction
"}}}

" 初期化チェック
function! s:init_check(bookmark) "{{{
	" curlの有無をチェック
	if !executable('curl')
		return s:echoErr('curlがみつかりません')
	endif

	if isdirectory(g:pukiwiki_datadir) == 0 && mkdir(g:pukiwiki_datadir, "p") == 0
		return s:echoErr('データディレクトリを作成できません')
	endif

	let bookmark_path = g:pukiwiki_datadir . '/pukiwiki.list'
	let a:bookmark.path = bookmark_path
	if filereadable(bookmark_path)
		return 1
	endif

	" bookmark 最初は無いから、ユーザ用のファイルをテンプレートから生成
	let bookmark_template = [
		\	"このページは pukivim のブックマークです。貴方が編集したいサイトを記入してお",
		\	"くことが出来ます。書式はタブ区切りでサイト名、url、pukiwikiのエンコードと",
		\	"なっています。",
		\	"",
		\	"urlにはそのサイトのトップページのページ名を付加してください。",
		\	"(必ずしも frontpage とは限らないため)",
		\	"",
		\	"<tab> で移動してサイト名にカーソルを合わせて <cr> を押すことで対象となる",
		\	"pukiwikiを閲覧、編集することが出来ます。",
		\	"",
		\	"mywiki	http://localhost/wiki/index.php?FrontPage\tutf-8",
		\	"vimwiki	http://vimwiki.net/?FrontPage\teuc-jp",
		\]
	if writefile(bookmark_template, bookmark_path) != 0
		return s:echoErr('pukiwiki.list-dist のコピーに失敗しました')
	endif
	return 1
endfunction
" }}}

" 新しいバージョンチェック
function! s:new_version_exists()"{{{
	if g:pukiwiki_check_snapshot==0
		return 0
	endif
	
	" 最新のスナップショットが有るのかチェック
	let proxy = ''
	if g:pukiwiki_proxy != ''
		let proxy = " -x " . g:pukiwiki_proxy
	endif
	let result = system('curl -k -s ' . proxy . s:version_url)
	if result > s:version_serial
		return 1
	endif
	return 0
endfunction
"}}}

" 次のブックマーク要素へジャンプ
function! s:next_bookmark_item()"{{{
	let tmp = @/
	let @/ = '^.*\t\+https\=://.*\t\+.*$'
	silent! execute "normal! n"
	let @/ = tmp
endfunction
"}}}

" カーソル下にあるテキストが[[..]]という形式だったらリンク先ページを開く
function! s:open_wikilink() "{{{
	let cur = s:get_wikilink_string()
	if cur == ''
	" 現在行が#contentsだったら、見出しでfold
		let line = getline('.')
		if line == '#contents'
			setlocal foldmethod=expr foldexpr=getline(v:lnum)=~'^*'?'>1':'='
			return
		endif
		return
	endif

	" 外部URLだったらブラウザを起動
	if cur =~# '^https\?://'
		return s:open_external_url(cur)
	endif

	" ToDo: 「:」を含む場合はInterWikiName ここで処理する必要あり

	let wiki = b:PukiWiki
	if line('.') < 4 && has_key(wiki.cmdnamemap, cur)
		" ヘッダ上のメニューの機能を実行
		return wiki.command(wiki.cmdnamemap[cur],[])
	else
		call wiki.show_page(cur)
	endif
endfunction"}}}

" 指定したサイト/ページを開く
function! s:open_site(line, page1st) "{{{
	let line = getline(a:line)
	if line !~# '^.*\t\+https\=://.*\t\+.*$'
		return 0
	endif
	let site_name = substitute(line , '^\([^\t]*\)\t\+https\=.*$' , '\1' , '')
	let url       = substitute(line , '.*\(https\=.*\)\t\+.*'     , '\1' , '')
"    let url       = substitute(line , '.*\(http.*\)\t\+.*'     , '\1' , '')
	let enc       = substitute(line , '^.*\t\+\(.*\)$'         , '\1' , '')
	let top      = url !~ '?' ? '' : substitute(url  , '.*?\([^\t]*\)\t*'       , '\1' , '')
	let url       = substitute(url  , '^\(.*\)?.*'             , '\1' , '')
	if &modified
		execute ":w"
	endif

	if top == ''
		call s:echoWarning('トップページ名が指定されていません。FrontPageをトップページとします')
		let top = 'FrontPage'
	endif

	let wiki = s:PukiWiki.create(site_name, url, top, enc)

	let page = a:page1st == '' ? top : a:page1st
	call wiki.show_page(page)

	return 1
endfunction
"}}}

" Pukiwiki Plusでのページ編集時のセッションIDを取得する
function! s:get_session_id(filepath) "{{{
	if filereadable(a:filepath) == 0
		return ''
	endif
	let lines = readfile(a:filepath)
	for _ in lines
		if _ !~# ".*pukiwiki.*"
			continue
		endif
		return substitute(_, '.*\tpukiwiki\t*\(.*\)$', '\1', '')
	endfor
	return ''
endfunction
"}}}

" 指定したURLの認証タイプを取得
function! s:get_auth_type(url) "{{{
	let proxy = s:get_proxy_option()
	let cmd = "curl -k -s -I ". proxy . a:url
	let result = system(s:escape_for_win32(cmd))

	let www_auth = substitute(result, '.*WWW-Authenticate:\s*\(.\{-}\)\s.*', '\1', '')
	return www_auth == '' ? 'Internal' : www_auth
endfunction
"}}}

let s:PukiWiki = {
	\ "site_name":"", "url":"", "top":"", "enc":"", "auth_type":"",
	\ "cmdmap":{}, "cmdnamemap":{}
\}

" PukiWikiファクトリメソッド
function! s:PukiWiki.create(site_name, url,top,enc) "{{{
	let obj = deepcopy(self)

	" サイト名(例:MyWiki)
	let obj.site_name = a:site_name
	" サイトのURL
	let obj.url = a:url
	" トップページ名
	let obj.top = a:top
	" Wikiページのエンコード
	let obj.enc = a:enc
	" 認証タイプ(Basic|Digest|Internal)
	let obj.auth_type = ''

	" 内部コマンド
	let obj.cmdmap = {}
	let obj.cmdmap.top       = s:PukiWiki.go_to_top
	let obj.cmdmap.reload    = s:PukiWiki.reload
	let obj.cmdmap.list      = s:PukiWiki.show_pagelist
	let obj.cmdmap.freeze    = s:PukiWiki.freeze
	let obj.cmdmap.unfreeze  = s:PukiWiki.unfreeze
	let obj.cmdmap.search    = s:PukiWiki.search_word
	let obj.cmdmap.new       = s:PukiWiki.newpage
	let obj.cmdmap.newsubdir = s:PukiWiki.newpage_subdir
	let obj.cmdmap.help      = s:PukiWiki.show_help
	let obj.cmdmap.recent    = s:PukiWiki.show_recent

	" 名前からコマンド名を引く
	let obj.cmdnamemap['トップ']   = 'top'
	let obj.cmdnamemap['リロード'] = 'reload'
	let obj.cmdnamemap['新規']     = 'new'
	let obj.cmdnamemap['凍結']     = 'freeze'
	let obj.cmdnamemap['凍結解除'] = 'unfreeze'
	let obj.cmdnamemap['一覧']     = 'list'
	let obj.cmdnamemap['単語検索'] = 'search'
	let obj.cmdnamemap['最終更新'] = 'recent'
	let obj.cmdnamemap['ヘルプ']   = 'help'
	return obj
endfunction
"}}}

" 内部コマンドの実行
function! s:PukiWiki.command(name, param) "{{{
	if has_key(self.cmdmap, a:name) == 0
		return
	endif

	let Func = self.cmdmap[a:name]
	return call(Func, a:param, self)
endfunction
"}}}

" 文字列をURLエンコード
function! s:PukiWiki.urlencode(str) "{{{
  " Return URL encoded string
  let retval = iconv(a:str, &enc, self.enc)
  let retval = substitute(retval, '[^- *.0-9A-Za-z]', '\=s:AL_urlencoder_ch2hex(submatch(0))', 'g')
  let retval = substitute(retval, ' ', '+', 'g')
  return retval
endfunction"}}}

" Wikiページ側のエンコード文字列をVim側のエンコードに変換
function! s:PukiWiki.decode(str) "{{{
	return iconv(a:str, self.enc, &enc)
endfunction"}}}

" 認証情報を保持する(URL毎)
let s:auth_info = {}

" ユーザ名/パスワードの入力
function! s:auth_info.prompt(url)"{{{
	let user_name = input("認証が必要です ユーザ名:")
	let password = inputsecret("Password:")
	let self[a:url] = {"user":user_name, "password":password }
	return self[a:url]
endfunction"}}}

function! s:get_proxy_option() "{{{
	return g:pukiwiki_proxy != '' ? " -x " . g:pukiwiki_proxy . " " : ""
endfunction "}}}

" curlを実行
function! s:PukiWiki.do_curl(url, cookie, auth, postfile, need_session_id)"{{{
	let auth_opt = ''
	if type(a:auth) == type({}) && has_key(a:auth, "user") && has_key(a:auth, "password")

		let auth_opt = printf(" -u %s:%s ", a:auth.user, a:auth.password)
		if self.auth_type ==? 'digest'
			let auth_opt .= " --digest "
		endif
	endif

	let proxy = s:get_proxy_option()

	let cookie_opt = ' '
	if type(a:cookie) == type({}) && len(a:cookie) > 0
		let cookie_opt = printf(' --cookie %s ', s:joindict(a:cookie, ';'))
	endif

	let [tmp_data, tmp_cookie] = [ tempname(), tempname() ]

	let save_cookie_opt = ' '
	if a:need_session_id
		let save_cookie_opt = printf(' -c %s ', tmp_cookie)
	endif

	let post_opt = ' '
	if filereadable(a:postfile)
		let post_opt = " -d @" . a:postfile . " "
	endif

	let cmd = "curl -k --fail -s -w \"%{http_code}\"". proxy . auth_opt . ' -o ' . tmp_data . cookie_opt . post_opt . save_cookie_opt . ' "' . a:url. '"'
	let status_code = system(s:escape_for_win32(cmd))

	let session_id = a:need_session_id ? s:get_session_id(tmp_cookie) : 0

	silent! call delete(tmp_cookie)

	let result = self.decode(s:readfile(tmp_data))

	return [ status_code, result, session_id ]
endfunction"}}}

" GET
" param:パラメータを表すマップ
function! s:PukiWiki.get(param) "{{{
	let cmdparam = ''
	for _ in keys(a:param)
		let p = self.urlencode(a:param[_])
		if cmdparam != ''
			let cmdparam .= '&'
		endif
		let cmdparam .= printf('%s=%s', _, p)
	endfor
	let url = self.url
	if cmdparam != ''
		let url .= '?'. cmdparam
	endif

	let page = {}
	let [page.status_code , page.data, page.session_id] = 
	\		 self.do_curl(url, 0, get(s:auth_info, self.url), '', 1)

	" 認証が必要なら、ユーザ入力の後で再試行
	if page.status_code == 401
		if self.auth_type == ''
			let self.auth_type = s:get_auth_type(url)
		endif

		let auth = s:auth_info.prompt(self.url)
		let [status_code, result, session_id] = self.do_curl(url, 0, auth, '', 1)
		let [page.status_code , page.data, page.session_id] = 
		\		 self.do_curl(url, 0, auth, '', 1)
	endif

	silent! call delete(tmp_data)

	return page
endfunction
"}}}

" POST
function! s:PukiWiki.post(param, cookie) "{{{
	let post_file = tempname()
	call writefile([s:joindict(a:param, '&')], post_file)

	let _ = {}
	let [_.status_code, _.data, dummy] =
	\		self.do_curl(self.url, a:cookie, get(s:auth_info, self.url), post_file, 0)

	if _.status_code == 401
		let auth = s:auth_info.prompt(self.url)
		let [_.status_code, _.data, session_id] =
		\		self.do_curl(self.url, a:cookie, get(s:auth_info, self.url), post_file, 0)
	endif

	silent! call delete(post_file)
	return _
endfunction
"}}}

" GETでコマンド実行
function! s:PukiWiki.command_get(cmd_name, param) "{{{
	let param = deepcopy(a:param)
	let param.cmd=a:cmd_name
	return self.get(param)
endfunction"}}}

" ページを参照するためのURL文字列を生成
" (ここで生成されるURLは編集用ではなく、普通にページにアクセスするためのもの)
" @param page [in] Wikiページ名(URLエンコードしていないもの)
function! s:PukiWiki.make_full_url(page) "{{{
	return self.url . '?' . self.urlencode(a:page)
endfunction
"}}}

" (start,end)管の部分文字列を得る
function! s:substr(data, start, end)"{{{
	" NOTE:正規表現の後方参照を使うと大きいデータで極端に遅くなるための代替処理
	let s = match(a:data, a:start . '\zs')
	let e = match(a:data, a:end, s)
	return a:data[s : e-1]
endfunction"}}}

" ページデータの取得
" page:ページ名 force:凍結中でも取得するか?
function! s:PukiWiki.get_page(page, force) "{{{
	let param         = {}
	let param.page    = a:page

	let page = self.command_get('edit', param)
	let page.name = a:page

	if page.data =~? '<textarea\_.\{-}>\_.\{-}</textarea>\_.\{-}<textarea'
		let page.readonly = 0
		let page.source = s:substr(page.data, '<textarea\_.\{-}>', '</textarea>')
		let page.digest = s:substr(page.data, 'name="digest" value="', '" />')
		let page.ticket = s:substr(page.data, 'name="ticket" value="', '" />')
		return page
	else
		if page.status_code != 200
			return page
		endif
		if a:force == 0
			" エラーケース(通常ここにはこない?)
			let page.readonly = 1
			let page.source=''
			return page
		endif
		let page = self.command_get('source', param)
		let page.name = a:page
		let page.readonly = 1
		let page.source = s:substr(page.data, '<pre id="source">\zs', '</pre>')
		return page
	endif
endfunction"}}}

" 指定したページは存在するか?
function! s:PukiWiki.exist_page(page) "{{{
	let page = self.get_page(a:page, 1)
	return len(page.source) != 0
endfunction"}}}

" 現在のサイトのトップページへ移動
function! s:PukiWiki.go_to_top(...)"{{{
	return self.show_page(self.top)
endfunction"}}}

" リロード
function! s:PukiWiki.reload(...)"{{{
	if exists('b:PukiWikiPage') == 0
		return
	endif
	return self.show_page(b:PukiWikiPage.name)
endfunction"}}}

" 凍結/凍結解除
function! s:freeze(enable) "{{{
	let [cmd, word] = a:enable ? ['freeze', '凍結'] : ['unfreeze','凍結解除']
	let pass = inputsecret(word.'用のパスワード: ')
	if pass == ''
		return
	endif

	let wiki = b:PukiWiki
	let page = b:PukiWikiPage

	let param = {}
	let param.encode_hint = wiki.urlencode('ぷ')
	let param.cmd         = cmd
	let param.page        = wiki.urlencode(page.name)
	let param.pass        = wiki.urlencode(pass)

	let result = wiki.post(param, {})

	" データにformを含んでいたらエラーと見なす(エラーの場合、再試行を促されるため)
	if result.status_code == 401
		return s:echoErr("認証に失敗しました")
	endif
	if result.data =~? '<input type="password"'
		echo 'パスワードが間違っています'
	else
		call wiki.show_page(page.name) " Reload
		echo 'ページを'.word.'しました'
	endif
endfunction
"}}}

" 凍結
function! s:PukiWiki.freeze(...)"{{{
	return s:freeze(1)
endfunction"}}}

" 凍結解除
function! s:PukiWiki.unfreeze(...)"{{{
	return s:freeze(0)
endfunction"}}}

" ページリストの表示
function! s:PukiWiki.show_pagelist(...)"{{{
	let page = self.command_get('list', {})

	let body = s:substr(page.data, '<div id="body">', '<hr class="full_hr" />')
	let body = substitute(body, '<a id\_.\{-}<strong>\(\_.\{-}\)<\/strong><\/a>', '\[\[\1\]\]', 'g')

	let buf_name = self.site_name . " ページ一覧"
	call s:create_buffer(self.enc, buf_name)

	normal! gg"_dG
	execute "normal! i".body

	" 余計なデータの削除
	silent! %g/^$/d _
	silent! %g/<div/d _
	silent! %g/<br/d _
	silent! %g/<\/div/d _
	silent! %g/<ul/d _
	silent! %g/<\/ul/d _
	silent! %g/^\s*<\/li/d _
	silent! %s/^.*<li><a.*>\(.*\)<\/a><small>\(.*\)<\/small>.*$/\t\[\[\1\]\] \2/
	silent! %g/^\[/d _
	silent! %s/\s*<li>\[\[\(.*\)\]\]$/\1/
	silent! %g/\t*<\/t/d _

	execute "normal! ggi" . buf_name . "\n".s:header_string(0,0,0)
	normal! gg

	call s:AL_decode_entityreference_with_range('%')
	call s:setfiletype_pkwkedit(1)

	let b:PukiWiki=self
endfunction"}}}

" 単語検索の実行
function! s:PukiWiki.search_word(...)"{{{
	if len(a:000) == 0
		let word = input('キーワード: ')
	else
		let word = join(a:000, ' ')
	endif
	if word == ''
		return
	endif
	let type = 'AND'
	let andor = input('(And/or): ')
	if andor =~? '^o'
		let type = 'OR'
	endif

	" サーバ側に送信するリクエストデータの生成
	let param = {}
	let param.encode_hint = self.urlencode('ぷ')
	let param.cmd         = 'search'
	let param.word        = self.urlencode(word)
	let param.type        = type

	let result = self.post(param, {})
	if result.status_code == 401
		return s:echoErr("認証に失敗しました")
	endif

	let buf_name = self.site_name . ' 検索結果'
	call s:create_buffer(self.enc, buf_name)

	normal! 1G"_dG
	let body = s:substr(result.data, '<div id="body">', '<form action')

	execute "normal! i" . body

	silent! %g/<div/d _
	silent! %g/<ul/d _
	silent! %g/<\/ul/d _
	silent! %s/<strong class="word.">//g
	silent! %s/<\/strong>//g
	silent! %s/<strong>//g
	silent! %s/^.*<li><a.*>\(.*\)<\/a>\(.*\)<\/li>$/\t\[\[\1\]\] \2/

	execute "normal! ggi" . buf_name . "\n". s:header_string(0,0,0)
	normal! gg
	call s:setfiletype_pkwkedit(1)

	let b:PukiWiki = self
endfunction"}}}

" 新規作成
function! s:PukiWiki.newpage(...)"{{{
	if len(a:000) == 0
		let newname = input('ページ名: ')
	else
		let newname = a:000[0]
	endif

	if newname == ''
		return
	endif
	return self.show_page(newname)
endfunction"}}}

" 下位階層新規作成
function! s:PukiWiki.newpage_subdir(...)"{{{
	if exists('b:PukiWikiPage') == 0
		return
	endif

	let page = b:PukiWikiPage

	if page.name == 'FrontPage'
		return call(s:PukiWiki.newpage, a:000, self)
	endif

	if len(a:000) == 0
		let newname = input('ページ名: '.page.name.'/')
	else
		let newname = a:000[0]
	endif

	if newname == ''
		return
	endif

	return self.show_page(page.name . '/' . newname)
endfunction"}}}

" 最終更新の表示
function! s:PukiWiki.show_recent(...)"{{{
	return self.show_page('RecentChanges')
endfunction"}}}

" ヘルプ
function! s:PukiWiki.show_help(...)"{{{
	return self.show_page(self.exist_page('ヘルプ')? 'ヘルプ': 'Help')
endfunction"}}}


" ページの表示
function! s:PukiWiki.show_page(pagename) "{{{

	" ページ名に#が含まれる場合は分割する(後でanchorを検索する)
	let [pagename, anchor] = [a:pagename, '']
	if a:pagename =~ '#'
		let [pagename, anchor] = split(a:pagename, '#', 1)
	endif
	if pagename == ''
		return 0
	endif

	" ToDo: pagename内に.,..が含まれる場合は展開

	let page = self.get_page(pagename, 1)
	if page.status_code != 200
		if page.status_code == 401
			return s:echoErr("認証に失敗しました")
		endif
		return s:echoWarning('ページの読み込みに失敗しました(status:'.page.status_code.')')
	endif

	let bufdata = printf("%s %s\n%s%s", self.site_name, pagename, s:header_string(1,1,page.readonly), page.source)

	" バッファがなければバッファを作成
	let buf_name = printf('%s %s', self.site_name, pagename)
	let page.bufnr = s:create_buffer(self.enc, buf_name)
	if page.bufnr == 0
		return 0
	endif

	" バッファの内容を更新
	setlocal modifiable
	setlocal noreadonly

	" 一時的にundo/redo機能を無効化し変更内容がundoツリーに残らないようにする
	let org_ul = &undolevels
	let &undolevels = -1

	try
		normal! gg"_dG
		execute "normal! i".bufdata

		" &gt;などのエスケープシーケンスを元に戻す
		call s:AL_decode_entityreference_with_range('%')

		normal! gg3j
		call s:setfiletype_pkwkedit(page.readonly)
	finally
		let &undolevels = org_ul
	endtry

	setlocal nomodified

	" anchorが指定された場合はanchor検索
	if anchor != ''
		let org_pos = getpos('.')
		if search('\[#'.anchor.'\]') == 0
			call setpos('.', org_pos)
		else
			normal! 0
		endif
	endif

	let b:PukiWiki = self
	let b:PukiWikiPage = page

	silent! execute ":redraws!"
	augroup PukiWikiEdit
		execute "autocmd! BufWriteCmd " . substitute(expand("%"), ' ', '\\ ', 'g') . " call s:write_page()"
	augroup END

	return page
endfunction"}}}

" ファイルタイプ固有の設定
function! s:setfiletype_pkwkedit(readonly) "{{{
	setlocal filetype=pukiwiki_edit
	setlocal indentexpr=
	setlocal noswapfile
	setlocal nomodified

	" 以下、syntaxを設定
	runtime! syntax/help.vim

	hi def link BracketName Directory
	"hi def link Head Directory
	"hi def link VimPHPURL Underlined
	hi def link BodyDelim LineNr
	"hi def link NotEditable WarningMsg

	"syntax match VimPHPURL display "s\?https\?:\/\/[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]\+\/vim.php[-\./0-9a-zA-Z]*"
	"syntax match BracketName display "\[\[\%(\s\)\@!:\=[^\r\n\t[\]<>#&":]\+:\=\%(\s\)\@<!\]\]"
	syntax match BracketName display "\[\[\_.\{-}\]\]"
	syntax match BodyDelim display "^-\{3,}.*--$"
	"syntax match Head display "\\\@<!|[^"*|]\+|"
	"syntax match NotEditable display "===== Not Editable ====="

	" Mapping
	nnoremap <silent> <buffer> <CR>    :call <SID>open_wikilink()<CR>
	nnoremap <silent> <buffer> <TAB>   :call <SID>jump_backet(0)<CR>

	if a:readonly
		execute ":setlocal nomodifiable"
		execute ":setlocal readonly"
	endif
endfunction
"}}}

" バッファを作成
function! s:create_buffer(enc, buf_name)"{{{
	let buf_name = substitute(a:buf_name, '/', '.', 'g')
	let buf_name = substitute(buf_name, ' ', '\\ ', 'g')
	if has('win32')
		" Windowsではcolonをファイル名に含められないので置換
		let buf_name = substitute(buf_name, ':', '_', 'g')
	endif

	if bufexists(buf_name)
		silent execute bufnr(buf_name) "buffer"
		" 開こうとしているページが既にオープン済みで、modifiedだったらエラー処理
		if &modified != 0
			return s:echoErr('変更が保存されていません')
		endif
	else
		silent execute "e ++enc=" . a:enc . ' ' . buf_name
	endif
	setlocal noreadonly modifiable noai
	return bufnr(buf_name)
endfunction"}}}


" 編集結果をアップロード
function! s:write_page() "{{{

	let notimestamp = ''
	let last_confirm = input('タイムスタンプを変更しない(y/N): ')
	if last_confirm =~ '^\cy'
		let notimestamp = 'true'
	endif

	let wiki  = b:PukiWiki
	let page = b:PukiWikiPage

	" もし、新規作成ページの場合は日付は強制的に更新
	" (環境によってはそうしないと更新できないことがある)
	if len(page.source) == 0
		let notimestamp = ''
	endif

	" サーバ側に送信するリクエストデータの生成
	let param = {}
	let param.encode_hint = wiki.urlencode('ぷ')

	let param.cmd         = 'edit'
	let param.page        = wiki.urlencode(page.name)
	let param.write       = wiki.urlencode('ページの更新')
	let param.digest      = page.digest
	let param.ticket      = page.ticket
	let param.id          = ''
	let param.notimestamp = notimestamp
	let param.original    = wiki.urlencode(page.source)

	let param.msg         = ''
	let cl = 4
	while cl <= line('$')
		let param.msg .= wiki.urlencode(getline(cl)."\n")
		let cl += 1
	endwhile

	let result = wiki.post(param, {"pukiwiki":page.session_id})
	if result.status_code == 401
		return s:echoErr("認証に失敗しました")
	endif

	" 成功するとPukiWikiがlocationヘッダーを吐くのでresultが作成されない。
	" 作成されている場合には何らかのエラーをHTMLで吐き出している。
	if result.data != ''
		let body = result.data
		if body =~? '<title>\_.\{-}を削除しました\_.\{-}<\/title>'
			call wiki.show_page(wiki.top)
			silent! execute page.bufnr "bwipeout!"
			echo page.name . ' を削除しました'
			return
		endif

		" ここに処理が及ぶ場合、たぶん衝突
		" 書き込みしようとしたバッファの名前の前に'ローカル'を付けて
		" 現在のサーバー上の内容を取得して'diffthis'を実行する。
		let status_line = wiki.site_name . ' ローカル ' . page.name
		execute "f " . escape(status_line, ' ')
		" ローカル側は変更できないように(新しく作成する側を編集する)
		setlocal readonly nomodifiable
		execute "diffthis"
		execute "vnew"
		call wiki.show_page(page.name)
		execute "diffthis"
		return s:echoErr('更新の衝突が発生したか、その他のエラーで書き込めませんでした')
	else
		let &modified = 0
	endif

	call wiki.show_page(page.name)
	redraw!
	echo '更新成功！'
endfunction"}}}

" カーソル位置の[]リンク文字列を取得
function! s:get_wikilink_string()"{{{

	let cur_pos = getpos(".")

	" 前方の[を検索
	let s = searchpos('\V[\|]', 'bcW', line("."))
	if s == [0,0]
		return ''
	endif

	let line = getline(".")
	let chr = line[s[1]-1]

	" searchpairで対応する括弧を見付け、その範囲内を拾う
	let e = searchpairpos('\[', '', '\]', chr==']'? 'b':'', '', line('.'))

	call setpos(".", cur_pos)

	if e == [0,0]
		return ''
	endif
	if chr == ']'
		let [s,e] = [e,s]
	endif
	let link = line[s[1]:e[1]-2]

	let link = substitute(link, '\[\{1,2}\(.*\)\]\{1,2}', '\1', '')

	" InterWikiNameのエイリアスではないエイリアス
	" つまり、ただのエイリアス
	if link =~ '>'
		let link = substitute(link, '^.*>\(.*\)$', '\1', '')
	endif

	return link
endfunction"}}}

" 次/前の角括弧リンクへジャンプ
function! s:jump_backet(reverse)"{{{
	" 自分で書いといて何だけど、ここの処理(header_pattern)はひどい
	let header_pattern = '\%(\[\%(トップ\)\|\%(リロード\)\|\%(新規\)\|\%(凍結\)\|\%(凍結解除\)\|\%(一覧\)\|\%(単語検索\)\|\%(最終更新\)\|\%(ヘルプ\)\]\)'
	let tmp = @/
	let @/ = '\%('.s:bracket_name.'\)\|'. header_pattern
	let direction = a:reverse==0?"n":"N"
	silent! execute "normal!" direction
	let @/ = tmp
endfunction"}}}

" 以下、alice.vimからのコード(一部改変)

function! s:AL_urlencoder_ch2hex(ch)"{{{
  let result = ''
  let i = 0
  let chlen = len(a:ch)
  while i < chlen
    let result .= printf("%%%02x", char2nr(a:ch[i]))
    let i = i + 1
  endwhile
  return result
endfunction"}}}

function! s:Utf_nr2byte(nr)"{{{
  if a:nr < 0x80
    return nr2char(a:nr)
  elseif a:nr < 0x800
    return nr2char(a:nr/64+192).nr2char(a:nr%64+128)
  else
    return nr2char(a:nr/4096%16+224).nr2char(a:nr/64%64+128).nr2char(a:nr%64+128)
  endif
endfunction"}}}

function! s:Uni_nr2enc_char(charcode)"{{{
  let char = s:Utf_nr2byte(a:charcode)
  if has('iconv') && strlen(char) > 1
    let char = strtrans(iconv(char, 'utf-8', &encoding))
  endif
  return char
endfunction"}}}

function! s:AL_decode_entityreference_with_range(range)"{{{
  " Decode entity reference for range
  silent! execute a:range 's/&gt;/>/g'
  silent! execute a:range 's/&lt;/</g'
  silent! execute a:range 's/&quot;/"/g'
  silent! execute a:range "s/&apos;/'/g"
  silent! execute a:range 's/&nbsp;/ /g'
  silent! execute a:range 's/&yen;/\&#65509;/g'
  silent! execute a:range 's/&#\(\d\+\);/\=s:Uni_nr2enc_char(submatch(1))/g'
  silent! execute a:range 's/&amp;/\&/g'
endfunction"}}}

