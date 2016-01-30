inoremap { {}<LEFT>

function! IndentBraces()
    let nowletter = getline(".")[col(".")-1]    " 今いるカーソルの文字
    let beforeletter = getline(".")[col(".")-2] " 1つ前の文字

    " カーソルの位置の括弧が隣接している場合
    if nowletter == "}" && beforeletter == "{"
        return "\<LEFT>\<CR>\<RIGHT>\<CR>\<ESC>\<S-o>"
    else
        return "\<CR>"
    endif
endfunction
inoremap <silent> <expr> <CR> IndentBraces()

" OmniSharp
nnoremap <silent> <buffer> <F5> :OmniSharpBuild<CR>
if has("mac")
    nnoremap <silent> <buffer> <S-D-F10> :OmniSharpGetCodeActions<CR>
    nnoremap <silent> <buffer> <D-1> :OmniSharpGetCodeActions<CR>
else
    nnoremap <silent> <buffer> <S-A-F10> :OmniSharpGetCodeActions<CR>
endif

nnoremap <silent> <buffer> <C-]> :OmniSharpGotoDefinition<CR>
nnoremap <silent> <buffer> ma :OmniSharpAddToProject<CR>
nnoremap <silent> <buffer> mc :OmniSharpFindSyntaxErrors<CR>
nnoremap <silent> <buffer> mf :OmniSharpCodeFormat<CR>
nnoremap <silent> <buffer> mi :OmniSharpFindImplementations<CR>
nnoremap <silent> <buffer> mr :OmniSharpRename<CR>
nnoremap <silent> <buffer> mt :OmniSharpTypeLookup<CR>
nnoremap <silent> <buffer> mu :OmniSharpFindUsages<CR>
