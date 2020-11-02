" This is really custom stuff, but the commands are mostly based on spacemacs
" https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org

source ~/.vimrc.local.before

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
    " Note: start encrpytion with `:X`
    set hidden
    set expandtab                           " Tabs are spaces, not tabs
    set shiftwidth=2
    set tabstop=2                           " An indentation every four columns
    set softtabstop=2                       " Let backspace delete indent
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
    " let g:rooter_manual_only = 1
    Plug 'easymotion/vim-easymotion'    " move around with Cntrl-<motion>
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " Use `:Fw` to fold by a pattern. Also use `set nowrap` for long log files 
    Plug 'embear/vim-foldsearch'
    let g:foldsearch_disable_mappings = 1

    " Look & Feel
    Plug 'rafi/awesome-vim-colorschemes'
    " Plug 'ntpeters/vim-better-whitespace'
    Plug 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    "" Languages
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'

    "----------
    "- Omni/Misc
    Plug 'scrooloose/syntastic'
    " Plug 'SirVer/ultisnips'
    Plug 'LnL7/vim-nix'
    Plug 'cespare/vim-toml'
    Plug 'maralla/vim-toml-enhance'
    autocmd FileType toml,markdown
        \ autocmd Syntax <buffer> syntax sync minlines=2000
    Plug 'chrisbra/csv.vim'
    Plug 'elzr/vim-json'
    Plug 'google/vim-jsonnet'
    let g:vim_json_syntax_conceal = 0
    command FmtJson %!python -m json.tool
    let g:markdown_fenced_languages = ['sh', 'bash=sh', 'python']

    "----------
    "- Rust
    Plug 'rust-lang/rust.vim'
    let g:rustfmt_autosave = 0
    if executable('rls')
          au User lsp_setup call lsp#register_server({
                  \ 'name': 'rls',
                  \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
                  \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
                  \ 'whitelist': ['rust'],
                  \ })
    endif

    "----------
    "- Haskell
    Plug 'neovimhaskell/haskell-vim.git'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN END
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Additional plugin settings

    " Airline
    let g:airline_powerline_fonts = 1
    " autocmd FileType
    "     \ c,cpp,java,go,rust,php,javascript,python,twig,xml,yml,perl,markdown
    "     \ autocmd BufEnter <buffer> EnableStripWhitespaceOnSave
    let g:strip_whitespace_confirm=0
    let g:strip_only_modified_lines=0

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
    let g:mapleader = ' '

    " LSP commands
    nnoremap <leader>gd :LspDefinition<CR>
    nnoremap <leader>gr :LspReferences<CR>
    nnoremap <leader>gi :LspHover<CR>

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
    nnoremap <leader>ff :e %:p:h<cr>
    " nnoremap <leader>ff :Files %:p:h<cr>

    """""""""""
    " s: search
    " search and replace current buffer
    nnoremap <leader>sr :%s//gc<left><left><left>
    " search in files
    nnoremap <leader>sf :call SearchDir(".")<cr>
    " clear search history
    nnoremap <leader>sc :noh<cr>

    """""""""""
    " p: project
    " open file
    nnoremap <leader>pf :call fzf#vim#files(".")<cr>

    """""""""""
    " c: comments
    nmap <leader>cc <Plug>CommentaryLine

source ~/.vimrc.local.after

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Stupid plugins... these have to be last
set nofoldenable    " No more folding
