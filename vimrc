"iles FindRootDirectory() Vitiral's vimrc
" This is really custom stuff, but the commands are mostly based on spacemacs
" https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
    " Note: start encrpytion with `:X`
    set hidden
    set expandtab                           " Tabs are spaces, not tabs
    set shiftwidth=4
    set tabstop=4                           " An indentation every four columns
    set softtabstop=4                       " Let backspace delete indent
    " Make tabs visible: Example tabs < 		>
    set list
    set listchars=tab:▶\ ,trail:·,extends:#,nbsp:.
    set number
    set relativenumber
    set nopaste
    set undofile                            " Save undo's after file closes
    set undolevels=1000                     " How many undos
    set undoreload=10000                    " number of lines to save for undo
    if has('nvim')
        set undodir=~/.nvim/data/undo//          " where to save undo histories
        set directory=~/.nvim/data/swap//        " where to save swap files
        set backupdir=~/.nvim/data/backup//      " where to save backup files
        set viminfo+='1000,n~/.nvim/data/viminfo " where to save .viminfo
        set viewdir=~/.nvim/data/view//          " where to save and load view info
    else
        set cm=blowfish2                        " Use blowfish2 when encrypting files
        set undodir=~/.vim/data/undo//          " where to save undo histories
        set directory=~/.vim/data/swap//        " where to save swap files
        set backupdir=~/.vim/data/backup//      " where to save backup files
        set viminfo+='1000,n~/.vim/data/viminfo " where to save .viminfo
        set viewdir=~/.vim/data/view//          " where to save and load view info
    endif
    autocmd BufWinLeave .*. mkview
    autocmd BufWinEnter .*. silent loadview

    autocmd BufNewFile,BufRead justfile set filetype=make
    autocmd FileType make set noexpandtab   " Make files use Tabs (not spaces)
    set splitbelow                              " help menus are below the current edit

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
    Plug 'embear/vim-foldsearch'        " Use `:Fw` to fold by a pattern. Also use `set nowrap` for long log files
    let g:foldsearch_disable_mappings = 1

    " Look & Feel
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "" Languages

    " Servers
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': './install.sh'
        \ }

    nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

    " TODO: maybe these as well:
    " \ 'javascript': ['javascript-typescript-stdio'],
    let g:LanguageClient_serverCommands = {
        \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
        \ 'python' : ['pyls'],
        \ }


    " Completion only really works on neovim (sad)
    if has('neovim')
        Plug 'roxma/nvim-completion-manager'
    else
        Plug 'maralla/completor.vim'
        inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
    endif


    "----------
    "- Omni/Misc
    Plug 'LnL7/vim-nix'
    Plug 'cespare/vim-toml'
    Plug 'maralla/vim-toml-enhance'
    autocmd FileType toml,markdown
        \ autocmd Syntax <buffer> syntax sync minlines=2000
    Plug 'chrisbra/csv.vim'
    Plug 'elzr/vim-json'
    let g:vim_json_syntax_conceal = 0
    command FmtJson %!python -m json.tool

    let g:markdown_fenced_languages = ['sh', 'bash=sh', 'python']
    "----------
    "- Python
    Plug 'hdima/python-syntax'

    "----------
    "- Rust
    Plug 'rust-lang/rust.vim'
    let g:rustfmt_autosave = 1
    au BufRead,BufNewFile *.crs     setfiletype rust

    "----------
    "- Elm
    Plug 'ElmCast/elm-vim'
    " disable everything, just want syntax really...
    let g:elm_jump_to_error = 0
    let g:elm_make_output_file = ""
    let g:elm_make_show_warnings = 0
    let g:elm_syntastic_show_warnings = 0
    let g:elm_browser_command = ""
    let g:elm_detailed_complete = 0
    let g:elm_format_autosave = 0
    let g:elm_format_fail_silently = 0
    let g:elm_setup_keybindings = 0


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN END
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Additional plugin settings

    " call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
    "     \ 'name': 'omni',
    "     \ 'whitelist': ['*'],
    "     \ 'completor': function('asyncomplete#sources#omni#completor')
    "     \  }))

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
            set signcolumn=no
            let b:is_paste_buffer=1
        else
            unlet b:is_paste_buffer
            set nopaste
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Stupid plugins... these have to be last
set nofoldenable    " No more folding
