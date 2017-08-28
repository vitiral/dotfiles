""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN START
call plug#begin('~/.local/share/nvim/plugged')
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Misc
Plug 'tpope/vim-sensible'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'Shougo/denite.nvim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Autocompletion

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" " close when complete
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" " Tab completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Languages

"----------
"- Python

Plug 'hdima/python-syntax'

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

"----------
"- Rust

Plug 'rust-lang/rust.vim'

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

"----------
"- Misc Markdown
Plug 'plasticboy/vim-markdown'
Plug 'chrisbra/csv.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#end()
"" PLUGIN END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spacemacs like ergonomics
    " commands can start with ;"
    nnoremap ; :

    " Leader is SPACE instead of \
    let mapleader = ' '

    " w: movement
    nnoremap <leader>wh <C-W>h
    nnoremap <leader>wj <C-W>j
    nnoremap <leader>wk <C-W>k
    nnoremap <leader>wl <C-W>l

    " window management
    map <leader>wS <C-w>s<C-w>j<C-w>=
    map <leader>wV <C-w>v<C-w>l<C-w>=
    nnoremap <leader>wd :q<CR>

    " b: buffers
    " nnoremap <leader>bb :b<SPACE>
    nnoremap <leader>bb :Denite buffer<CR>

    " reload all buffers
    nnoremap <leader>br :checktime<CR>
    nnoremap <silent> <leader>bn :set relativenumber!<cr>:set nonu!<cr>

    " s: search
    nnoremap <leader>sr :%s///gc<left><left><left>
    " -find-project
    nnoremap <leader>sp :Ack<space>
    " -project-findfile
    " nnoremap <leader>pf :CtrlP<cr>
    nnoremap <leader>pf :DeniteProjectDir<CR>

    " open and find files in current buffer
    nnoremap <leader>ff :e <C-R>=expand('%:h').'/'<cr>

    " clears search history
    nnoremap <leader>sc :noh<cr>

    " module remappings, TODO: make these only load for certain files
    nnoremap <leader>mb Oimport ipdb; ipdb.set_trace()<ESC>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc Settings
let g:airline_powerline_fonts = 1

colorscheme molokai
set background=dark
highlight Normal ctermfg=lightgrey ctermbg=black
