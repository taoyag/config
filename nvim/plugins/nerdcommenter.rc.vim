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

