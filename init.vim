set noswapfile
set encoding=utf-8
set fileencodings=utf-8,gb18030
set backspace=eol,start,indent
set laststatus=2
" set colorcolumn=80
set cursorline
set linebreak
set autoindent
set ignorecase
set smartcase
set ruler
set diffopt+=internal,indent-heuristic,algorithm:patience
set showcmd
set nu

" auto add }
"set smartindent
"set tabstop=4
"set shiftwidth=4
"set expandtab
"imap{ {}<ESC>i<CR><ESC>O

" split the file at right side
set splitright

filetype plugin indent on
syntax on

set termguicolors
color tender
highlight Visual guibg=#323232
highlight Normal guibg=#000001
highlight SignColumn guibg=#000001
highlight StatusLine guibg=#444444 guifg=#b3deef
highlight StatusLineTerm guibg=#444444 guifg=#b3deef
highlight StatusLineTermNC guibg=#444444 guifg=#999999

nnoremap <silent> <c-m> :Mru<cr>
nnoremap <silent> <c-p> :call fzf#Open()<cr>
nnoremap <silent> <leader>t :TagbarToggle<cr>
nnoremap <silent> <leader>e :NERDTreeToggle<cr>
nnoremap <silent> <leader>f :NERDTreeFind<cr>
nnoremap <silent> <leader>c :call lv#Term()<cr>
nnoremap <silent> <c-c> :!/usr/local/bin/ctags -R<cr>

function! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let name = fnamemodify(bufname(buflist[winnr - 1]), ':t')
	return empty(name) ? '[No Name]' : name
endfunction

function! MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif

		let s .= ' '. (i+1) . ' '
		let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
	endfor
	return s
endfunction
set tabline=%!MyTabLine()

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
			\ execute "normal! g`\"" |
			\ endif

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd BufReadPost *.html,*.js,*.css,*.json,*.yaml call lv#ExpandTab(2)
autocmd FileType proto call lv#ExpandTab(4)
autocmd FileType go setlocal formatoptions+=ro
autocmd FileType go call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
autocmd FileType vim nnoremap <buffer> <c-]> :call vim#Jump()<cr>

command -nargs=1 ExpandTab call lv#ExpandTab(<f-args>)

" let g:ackprg = 'ag --vimgrep'
let g:tagbar_compact = 1
let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_width = 30
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_conceal = 0
let g:deoplete#enable_at_startup = 1
let g:go_fmt_command = 'goimports'
let g:go_doc_popup_window = 1
let g:go_rename_command = 'gopls'

" Use deoplete
let g:deoplete#enable_at_startup = 1

if !has('nvim')
	packadd yarp
	packadd vim-hug-neovim-rpc
end


" vim-plug
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes


" Plug '~/my-prototype-plugin'
Plug 'rkulla/pydiction'

" NerdTree Git
Plug 'Xuyuanp/nerdtree-git-plugin'

" FZF 
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Initialize plugin system
call plug#end()

" Setup pydiction
let g:pydiction_location = '/home/bertrand/.vim/plugged/pydiction/complete-dict'
let g:pydiction_menu_height = 3

" Comment in Visual Mode
vnoremap <silent> # :s/^/#/<cr>:noh<cr>
vnoremap <silent> -# :s/^#//<cr>:noh<cr>

" NERDTree configure
" Display hidden files in NerdTree
let NERDTreeShowHidden=1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinPos = 0
let g:NERDTreeChDirMode = 2
let g:NERDTreeWinSize=24
" Prevent FZF open file inside NERDTree buffer
au BufEnter * if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree' && winnr('$') > 1 | b# | exe "normal! \<c-w>\<c-w>" | :blast | endif

" FZF Configure
nnoremap <silent> <c-g> :Ag<cr>
nnoremap <silent> <c-f> :Files<cr>
