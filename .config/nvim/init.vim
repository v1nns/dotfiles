" plugins
function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'unblevable/quick-scope'
Plug 'asvetliakov/vim-easymotion'
Plug 'ray-x/lsp_signature.nvim'
call plug#end()

" another try in the future...
" Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })


" quick scope
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

" yank to clipboard
set clipboard=unnamedplus

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
