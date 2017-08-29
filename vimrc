" Vitiral's vimrc
" This is really custom stuff, but the commands are mostly based on spacemacs
" https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org

" Leader is SPACE instead of \
let mapleader = ' '

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN START

call plug#begin('~/.local/share/nvim/plugged')
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "" Misc
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'Shougo/denite.nvim'

    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'vim-airline/vim-airline'

    Plug 'easymotion/vim-easymotion'

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
"" PLUGIN END

call plug#end()
function TogglePaste()
    if !exists("b:is_paste_buffer")
        tabnew %
        set paste
        set norelativenumber
        set nonumber
        let b:is_paste_buffer=1
    else
        unlet b:is_paste_buffer
        quit
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Additional plugin settings
    " Commentary settings
    xmap gc  <Plug>Commentary
    nmap gc  <Plug>Commentary
    omap gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine

    let g:airline_powerline_fonts = 1
    autocmd FileType
        \ c,cpp,java,go,rust,php,javascript,python,twig,xml,yml,perl,markdown
        \ autocmd BufEnter <buffer> EnableStripWhitespaceOnSave

    " Easymotion Settings
    map  <C-f> <Plug>(easymotion-bd-f)
    nmap <C-f> <Plug>(easymotion-overwin-f)
    map  <C-t> <Plug>(easymotion-t)
    nmap <C-t> <Plug>(easymotion-t)
    map  <C-L> <Plug>(easymotion-bd-jk)
    nmap <C-L> <Plug>(easymotion-overwin-line)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spacemacs like ergonomics
    " commands can start with ;"
    nnoremap ; :


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
    " toggle true paste mode
    nnoremap <silent> <leader>bp :call TogglePaste()<cr>

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

    nmap <leader>cc <Plug>CommentaryLine

    " module remappings, TODO: make these only load for certain files
    nnoremap <leader>mb Oimport ipdb; ipdb.set_trace()<ESC>

" term colors: http://misc.flogisoft.com/bash/tip_colors_and_formatting
colorscheme molokai
set background=dark
highlight Normal ctermfg=lightgrey ctermbg=NONE
highlight Search cterm=NONE ctermfg=white ctermbg=241
highlight ExtraWhitespace ctermbg=236

" Formatting Settings
set number
set relativenumber
set nopaste
set undofile                    " Save undo's after file closes
set undodir=~/.vim/data/undo//            " where to save undo histories
set directory=~/.vim/data/swap//     " where to save swap files
set backupdir=~/.vim/data/backup//        " where to save backup files
set viminfo+='1000,n~/.vim/data/viminfo
set undolevels=1000             " How many undos
set undoreload=10000            " number of lines to save for undo
set expandtab                   " Tabs are spaces, not tabs
set shiftwidth=4
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
autocmd BufNewFile,BufRead justfile set filetype=make
autocmd FileType make set noexpandtab   " Make files use Tabs (not spaces)

""""""""""""""""""
" Key (re)Mappings
    "Get rid of help key
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>

    " Shift+Tab always inserts a Tab
    :inoremap <S-Tab> <C-V><Tab>

