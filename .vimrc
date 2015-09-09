" vimrc for vitiral
" Check out the spf-13 vim configuration for an updated vimrc
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:"{"}

" Environment {
silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

set nocompatible        " Must be first line

"set shell=/bin/sh
set shell=$SHELL

if WINDOWS()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

if filereadable(expand("~/.vimrc.before.local"))
    source ~/.vimrc.before.local
endif

if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif
" }

"" General {
    " Automatically watch .vimrc and reload when changes are saved
    augroup myvimrc
        au!
        au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
    augroup END

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    scriptencoding utf-8

    if $TMUX==''
        if has('clipboard')
            if has('unnamedplus')  " When possible use + register for copy-paste
                set clipboard=unnamed,unnamedplus
            else         " On mac and Windows, use * register for copy-paste
                set clipboard=unnamed
            endif
        endif
    endif

    set autoread
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Set cursor to first line for git messages
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " Restore cursor to file position in previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Directory Setup
    set backup                  " Backups are nice ...
    if has('persistent_undo')
        set undofile                " So is persistent undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif
" }

" Vim UI {
" Ergonomic {
    " commands can start with ;"
    nnoremap ; :

    " Leader is , instead of \
    let mapleader = ','

    " Notes: os wide Cntrl i=tab, n=enter
    " vim specific: t=indents code (from where?)
    " Easier to escape
    nnoremap <C-f> <nop>
    inoremap <C-f> <ESC>
    vnoremap <C-f> <ESC>
    cnoremap <C-f> <ESC>
    " Hard to reach symbols
    inoremap <C-u> ()<left>
    inoremap <C-t> []<left>
    inoremap <C-b> {}<left>
    inoremap <C-l> <right>
    lnoremap <C-h> <left>
    " insert lines
    inoremap <C-o> <esc>o
    
    " Easier moving in tabs and windows
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h
" }

if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    let g:solarized_contrast="normal"
    let g:solarized_visibility="normal"
    color solarized             " Load a colorscheme
    set background=light
    highlight Normal ctermfg=green
    highlight Comment ctermfg=lightgrey
endif

set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
set nocursorline                " cursor line not highlighted
highlight clear SignColumn      " SignColumn should match background

set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
endif

if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set relativenumber              " line numbers are relevant from cursor

" Search configurations {
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
" }
" }

" Formatting {
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

" Filetype specific
autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml,perl autocmd BufWritePre <buffer> call StripTrailingWhitespace()
autocmd FileType make set noexpandtab   " make files use Tabs (not spaces)
autocmd FileType markdown set wrap linebreak nolist textwidth=0 wrapmargin=0
"autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd BufNewFile,BufRead *.coffee set filetype=coffee

" }

" Key (re)Mappings {
" General reMappings {
    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " ,<space> clears search history
    nnoremap <leader><space> :noh<cr>

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier formatting
    nnoremap <silent> <leader>q gwip

    " python remappings
    nnoremap <leader>sb oimport ipdb; ipdb.set_trace()<ESC>
    nnoremap <leader>sB Oimport ipdb; ipdb.set_trace()<ESC>

    "Get rid of help key
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>

    cmap Tabe tabe

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH
    " What is going on with this fold? {
        " Find merge conflict markers
        map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
    " }}}}
" }

" Window Management {
" ,wX does various things to windows 
" wgX is reserved for 'window goto' for tools like youcompleteme
nnoremap <leader>wf <C-w>= " fix windows
" horizontal+verticl splits
nnoremap <leader>ww <C-w>v<C-w>l<C-w>=
nnoremap <leader>wv <C-w>s<C-w>j<C-w>=
" toggle paste
nnoremap <silent> <leader>wp :set paste!<CR>
" toggle line numbers
nnoremap <silent> <leader>wn :set relativenumber!<cr>:set nonu!<cr>
" reload files
nnoremap <leader>wr :checktime<CR>  " reload all buffers
" leader wc opens rc window for editing
nnoremap <leader>wc :e $MYVIMRC<CR>  " open ~/.vimrc for editing
" show current directory/file
nnoremap <leader>wpd :echo expand('%:p:h')<CR>
nnoremap <leader>wpp :echo expand('%:p')<CR>
" }

" Command Remappings {
    " search and replace
    cmap repl %s///gc<Left><Left><Left>
    " search and replace in all buffers
    cmap brepl bufdo %s///gc<Left><Left><Left>
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h
    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode (auto expands directory)
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    command! ClearHistory !rm -rf $HOME/.viminfo $HOME/.vimswap $HOME/.vimundo $HOME/.vimviews/ $HOME/.vimbackup
" }

" Fix Terrible Movement Wrapping {
    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
" }

" Stupid shift key fixes {
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

" }
" }

" Plugins {
" Ctags {
    set tags=./tags;/,~/.vimtags

    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''
        let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif
" }

" AutoCloseTag {
    " Make it so AutoCloseTag works for xml and xhtml files as well
    au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }

" Tabular {
if isdirectory(expand("~/.vim/bundle/tabular"))
    nmap <Leader>a& :Tabularize /&<CR>
    vmap <Leader>a& :Tabularize /&<CR>
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a,, :Tabularize /,\zs<CR>
    vmap <Leader>a,, :Tabularize /,\zs<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
endif
" }

" JSON {
    nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    let g:vim_json_syntax_conceal = 0 
" }

" Version control Fugitive {
if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
endif
"}

" YouCompleteMe {
    command! GG YcmCompleter GoTo
    nnoremap <leader>wg :YcmCompleter GoTo<CR>
    let g:acp_enableAtStartup = 0
    let g:ycm_confirm_extra_conf = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_server_keep_logfiles = 1
    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = '<C-j>'
    let g:UltiSnipsJumpForwardTrigger = '<C-j>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

    " Enable omni completion on unsuported files
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " For snippet_complete marker.
    if has('conceal')
        set conceallevel=2 concealcursor=i
    endif

    " Disable the neosnippet preview candidate window. Can be too much visual noise
    set completeopt-=preview
" }

" indent_guides {
if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    let g:indent_guides_enable_on_vim_startup = 1
endif
" }

" vim-airline {
    " Set configuration options for the statusline plugin vim-airline.
    " Use the powerline theme and optionally enable powerline symbols.
    " To use the symbols , , , , , , and .in the statusline
    " segments add the following to your .vimrc.before.local file:
    "   let g:airline_powerline_fonts=1
    " If the previous symbols do not render for you then install a
    " powerline enabled font.

    " See `:echo g:airline_theme_map` for some more choices
    " Default in terminal vim is 'dark'
    if isdirectory(expand("~/.vim/bundle/vim-airline/"))
        if !exists('g:airline_theme')
            let g:airline_theme = 'solarized'
        endif
        if !exists('g:airline_powerline_fonts')
            " Use the default set of separators with a few customizations
            let g:airline_left_sep='›'  " Slightly fancier than '>'
            let g:airline_right_sep='‹' " Slightly fancier than '<'
        endif
    endif
" }
" }

" GUI Settings {

" GVIM- (here instead of .gvimrc)
if has('gui_running')
    set guioptions-=T           " Remove the toolbar
    set lines=40                " 40 lines of text instead of 24
    if LINUX() && has("gui_running")
        set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
    elseif OSX() && has("gui_running")
        set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
    elseif WINDOWS() && has("gui_running")
        set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
    endif
else
    if &term == 'xterm' || &term == 'screen'
        set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    endif
    "set term=builtin_ansi       " Make arrow and other keys work
endif

" }

" Functions {
" Initialize directories {
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }

" Strip whitespace {
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" }

" Shell command {
function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }
" }

" Use local vimrc if available {
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
" }

" Use local gvimrc if available and gui is running {
if has('gui_running')
    if filereadable(expand("~/.gvimrc.local"))
        source ~/.gvimrc.local
    endif
endif
" }


" { Extra things that have to go at the end for some reason
" Change spelling checker to underline
set spell                           " Spell checking on
hi clear SpellBad 
hi clear SpellCap " Remove highlight of non capitalized words as first char
hi SpellBad cterm=underline
" }

