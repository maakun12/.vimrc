" General settings
set nocompatible
set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set number
set cursorline
set cursorcolumn
set virtualedit=onemore
set smartindent
set showmatch
set laststatus=2
set wildmode=list:longest
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
syntax enable
set clipboard+=unnamed

" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'

call plug#end()
filetype plugin indent on

" Colorscheme
colorscheme gruvbox

" Tab settings
set list listchars=tab:\▸\-
set expandtab
set tabstop=2
set shiftwidth=2

" Key mappings
nnoremap j gj
nnoremap k gk
nnoremap gi :LspDefinition<CR>
nnoremap gd :LspImplementation<CR>
nnoremap gr :LspReferences<CR>
nnoremap nt :NERDTreeToggle<CR>
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" Language specific settings
augroup vimrc-filetype
  autocmd!
  " PHP
  autocmd BufNewFile,BufRead *.php set filetype=php
  autocmd FileType php setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
  " Ruby
  autocmd BufNewFile,BufRead *.rb set filetype=ruby
  autocmd BufNewFile,BufRead *.ruby set filetype=ruby
  autocmd FileType ruby setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" PHP Lint
function! s:PHPLint()
  let s:result = system('php -l ' . bufname(""))
  let s:count = split(s:result, "\n")
  echo s:result
endfunction

augroup php-lint
  autocmd!
  autocmd BufWritePost *.php call <SID>PHPLint()
augroup END

" Remove trailing spaces
aug space
  au!
  autocmd BufWritePre *.c,*.py,*.go,*.php,*.rb :%s/\s\+$//e
aug END

" LSP and asyncomplete setup
if executable('pyright-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyright-langserver',
        \ 'cmd': {server_info->['pyright-langserver']},
        \ 'allowlist': ['python'],
        \ })
endif

" autocomplete settings
set completeopt=menu,menuone,noinsert,noselect
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0

" Configure gopls for vim-lsp
augroup lsp_settings
  autocmd!
  autocmd User lsp_setup call lsp#register_server({
  \ 'name': 'gopls',
  \ 'cmd': {server_info->['gopls', '-remote=auto']},
  \ 'allowlist': ['go'],
  \ })
augroup END

" Automatically close quickfix window after jumping to a location
function! s:CloseQuickfix()
  for winnr in range(1, winnr('$'))
    if getwinvar(winnr, '&buftype') ==# 'quickfix'
      execute winnr . 'wincmd c'
    endif
  endfor
endfunction

autocmd BufEnter * call s:CloseQuickfix()
