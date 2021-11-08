" This is really custom stuff, but the commands are mostly based on spacemacs
" https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org

source ~/.vimrc.local.before

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
    set shiftwidth=2
    set tabstop=2                           " An indentation every four columns
    set softtabstop=2                       " Let backspace delete indent
    set hidden
    set expandtab                           " Tabs are spaces, not tabs
    " Make tabs visible: Example tabs < 		>
    set list
    set listchars=tab:▶\ ,trail:·,extends:#,nbsp:.
    set number
    set relativenumber
    set nopaste
    set undofile                            " Save undo's after file closes
    set undolevels=1000                     " How many undos
    set undoreload=10000                    " number of lines to save for undo
    set cm=blowfish2                        " Use blowfish2 when encrypting files
    set undodir=~/.vim/data/undo//          " where to save undo histories
    set directory=~/.vim/data/swap//        " where to save swap files
    set backupdir=~/.vim/data/backup//      " where to save backup files
    set viminfo+='1000,n~/.vim/data/viminfo " where to save .viminfo
    set viewdir=~/.vim/data/view//          " where to save and load view info
    autocmd BufWinLeave .*. mkview
    autocmd BufWinEnter .*. silent loadview
    autocmd FileType make set noexpandtab   " Make files use Tabs (not spaces)
    set splitbelow                          " help menus are below the current edit

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN START
call plug#begin('~/.vim/data/plug')
    " Basic Interface
    Plug 'tpope/vim-sensible'           " sensible defaults
    Plug 'tpope/vim-repeat'             " repeat plugin commands with `.`
    Plug 'tpope/vim-commentary'         " easy comment out lines

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

    "---------
    "- Python
    autocmd FileType python setlocal shiftwidth=2 tabstop=2 softtabstop=2

    "----------
    "- Omni/Misc
    "... empty

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PLUGIN END
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Additional plugin settings
    " Airline
    let g:airline_powerline_fonts = 1

    let g:strip_whitespace_confirm=0
    let g:strip_only_modified_lines=0

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spacemacs like ergonomics and key (re)mappings
" https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org
    let g:mapleader = ' '

    " LSP commands
    " nnoremap <leader>gd :LspDefinition<CR>
    " nnoremap <leader>gr :LspReferences<CR>
    " nnoremap <leader>gi :LspHover<CR>

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
    " open and find files in current buffer dir
    nnoremap <leader>ff :e %:p:h<cr>

    """""""""""
    " s: search
    " search and replace current buffer
    nnoremap <leader>sr :%s//gc<left><left><left>

    """""""""""
    " c: comments
    nmap <leader>cc <Plug>CommentaryLine

source ~/.vimrc.local.after

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Stupid plugins... these have to be last
set nofoldenable    " No more folding
