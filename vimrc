" Vitiral's vimrc
" This is really custom stuff, but the commands are mostly based on spacemacs
" https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
    set number
    set relativenumber
    set nopaste
    set undofile                            " Save undo's after file closes
    set undolevels=1000                     " How many undos
    set undoreload=10000                    " number of lines to save for undo
    set undodir=~/.vim/data/undo//          " where to save undo histories
    set directory=~/.vim/data/swap//        " where to save swap files
    set backupdir=~/.vim/data/backup//      " where to save backup files
    set viminfo+='1000,n~/.vim/data/viminfo " where to save .viminfo

    set expandtab                   " Tabs are spaces, not tabs
    set shiftwidth=4
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    autocmd BufNewFile,BufRead justfile set filetype=make
    autocmd FileType make set noexpandtab   " Make files use Tabs (not spaces)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN START
call plug#begin('~/.local/share/nvim/plugged')
    " Basic Interface
    Plug 'tpope/vim-sensible'           " sensible defaults
    Plug 'tpope/vim-repeat'             " repeat plugin commands with `.`
    Plug 'tpope/vim-commentary'         " easy comment out lines
    " Plug 'airblade/vim-rooter'          " all files use project-root as cwd
    " let g:rooter_silent_chdir = 1
    " let g:rooter_change_directory_for_non_project_files = 'current'
    Plug 'easymotion/vim-easymotion'    " move around with Cntrl-<motion>
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Look & Feel
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'vim-airline/vim-airline'

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
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': {server_info->['pyls']},
            \ 'whitelist': ['python'],
            \ })
    endif

    "----------
    "- Rust
    Plug 'rust-lang/rust.vim'

    if executable('rls')
        autocmd User lsp_setup call lsp#register_server({
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
    map  <C-F> <Plug>(easymotion-bd-f)
    nmap <C-F> <Plug>(easymotion-overwin-f)
    map  <C-T> <Plug>(easymotion-t)
    nmap <C-T> <Plug>(easymotion-t)
    map  <C-L> <Plug>(easymotion-bd-jk)
    nmap <C-L> <Plug>(easymotion-overwin-line)

    " term colors: http://misc.flogisoft.com/bash/tip_colors_and_formatting
    colorscheme molokai
    set background=dark
    highlight Normal ctermfg=lightgrey ctermbg=NONE
    highlight Search cterm=NONE ctermfg=white ctermbg=241
    highlight ExtraWhitespace ctermbg=236

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Custom Functions
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
" Spacemacs like ergonomics and key (re)mappings
    let mapleader = ' '

    "Get rid of help key
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>

    " Shift+Tab always inserts a Tab in insert mode
    :inoremap <S-Tab> <C-V><Tab>

    " commands can start with ;"
    nnoremap ; :

    " window management
    nnoremap <leader>wh <C-W>h
    nnoremap <leader>wj <C-W>j
    nnoremap <leader>wk <C-W>k
    nnoremap <leader>wl <C-W>l
    map <leader>wS <C-w>s<C-w>j<C-w>=
    map <leader>wV <C-w>v<C-w>l<C-w>=
    nnoremap <leader>wd :q<cr>
    " toggle true paste mode
    nnoremap <silent> <leader>wp :call TogglePaste()<cr>

    " b: buffers
    nnoremap <leader>bb :Buffers<cr>
    " reload all buffers
    nnoremap <leader>br :checktime<cr>

    " s: search
    nnoremap <leader>sr :%s//gc<left><left><left>
    nnoremap <leader>sp :Ag<cr>
    " -project-findfile
    nnoremap <leader>pf :Files<cr>

    " open and find files in current buffer
    nnoremap <leader>ff :e <C-R>=expand('%:h').'/'<cr>

    " clears search history
    nnoremap <leader>sc :noh<cr>

    nmap <leader>cc <Plug>CommentaryLine

    " module remappings, TODO: make these only load for certain files
    nnoremap <leader>mb Oimport ipdb; ipdb.set_trace()<ESC>


