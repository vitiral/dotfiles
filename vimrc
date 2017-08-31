"iles FindRootDirectory() Vitiral's vimrc
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
    set viewdir=~/.vim/data/view//          " where to save and load view info
    autocmd BufWinLeave * mkview
    autocmd BufWinEnter * silent loadview

    set expandtab                   " Tabs are spaces, not tabs
    set shiftwidth=4
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    autocmd BufNewFile,BufRead justfile set filetype=make
    autocmd FileType make set noexpandtab   " Make files use Tabs (not spaces)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN START
call plug#begin('~/.vim/data/plug')
    " Basic Interface
    Plug 'tpope/vim-sensible'           " sensible defaults
    Plug 'tpope/vim-repeat'             " repeat plugin commands with `.`
    Plug 'tpope/vim-commentary'         " easy comment out lines
    Plug 'airblade/vim-rooter'          " gets FindRootDirectory()
    let g:rooter_manual_only = 1
    Plug 'easymotion/vim-easymotion'    " move around with Cntrl-<motion>
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Look & Feel
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "" Autocompletion
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
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
	"- Omni/Misc
    Plug 'plasticboy/vim-markdown'
    Plug 'plasticboy/vim-markdown'
    Plug 'cespare/vim-toml'
	Plug 'maralla/vim-toml-enhance'
    autocmd FileType toml
        \ autocmd Syntax <buffer> syntax sync minlines=2000
    Plug 'chrisbra/csv.vim'

    Plug 'yami-beta/asyncomplete-omni.vim'

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN END
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Additional plugin settings

	call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
		\ 'name': 'omni',
		\ 'whitelist': ['*'],
		\ 'completor': function('asyncomplete#sources#omni#completor')
		\  }))

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
    highlight Comment cterm=NONE ctermfg=76
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

    function SearchDir(dir)
        call fzf#vim#grep(
             \ 'grep -vnITr --color=always --exclude-dir=".svn" --exclude-dir=".git" --exclude=tags --exclude=*\.pyc --exclude=*\.exe --exclude=*\.dll --exclude=*\.zip --exclude=*\.gz "^$" ' . a:dir,
             \ 0,
             \ {'options': '--reverse --prompt "Search> "'})
    endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spacemacs like ergonomics and key (re)mappings
" https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org
    let mapleader = ' '

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    "Get rid of help key
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>

    " Shift+Tab always inserts a Tab in insert mode
    :inoremap <S-Tab> <C-V><Tab>

    " commands can start with ;"
    nnoremap ; :

    """""""""""
    " w: window
    nnoremap <leader>wh <C-W>h
    nnoremap <leader>wj <C-W>j
    nnoremap <leader>wk <C-W>k
    nnoremap <leader>wl <C-W>l
    map <leader>wS <C-w>s<C-w>j<C-w>=
    map <leader>wV <C-w>v<C-w>l<C-w>=
    nnoremap <leader>wd :q<cr>
    " toggle true paste mode
    nnoremap <silent> <leader>wp :call TogglePaste()<cr>

    """""""""""
    " b: buffers
    nnoremap <leader>bb :Buffers<cr>
    " reload all buffers
    nnoremap <leader>br :checktime<cr>

    """""""""""
    " f: file management
    " open and find files in current buffer
    " nnoremap <leader>ff :e <C-R>=expand('%:h').'/'<cr>
    nnoremap <leader>ff :Files %:p:h<cr>

    """""""""""
    " s: search
    " search and replace current buffer
    nnoremap <leader>sr :%s//gc<left><left><left>
    " search project
    nnoremap <leader>sp :call SearchDir(FindRootDirectory())<cr>
    " search cwd
    nnoremap <leader>ss :call SearchDir(".")<cr>
    " search file directory
    nnoremap <leader>sf :call SearchDir(expand('%:p:h'))<cr>
    " clear search history
    nnoremap <leader>sc :noh<cr>

    """""""""""
    " p: project
    " open file in project
    nnoremap <leader>pf :call fzf#vim#files(FindRootDirectory())<cr>
    " open file in cwd
    nnoremap <leader>pc :call Files<cr>
    " open file in home
    nnoremap <leader>ph :call fzf#vim#files("~")<cr>

    """""""""""
    " c: comments
    nmap <leader>cc <Plug>CommentaryLine

    " module remappings, TODO: make these only load for certain files
    nnoremap <leader>mb Oimport ipdb; ipdb.set_trace()<ESC>
