" Basic settings
set nocompatible        " prevent old vi compatibility
set tabstop=4           " size of tab stop in file
set shiftwidth=4        " spaces to indent with << and >>
set softtabstop=4       " size of tab when editing
set expandtab           " convert tabs to spaces
set number              " show line number on current line
set relativenumber      " show relative line number on current line
set showcmd             " show last command
set lazyredraw          " redraw only when needed
set autoindent          " preserve indenting if given no filetype
set ruler               " show location
set visualbell          " flash screen instead of beep with error
set scrolloff=3         " start scrolling 3 lines from edge
syntax enable           " enable syntax highlighting
set showmatch           " show matching [{()}]
set nowrap              " don't wrap lines
set encoding=utf-8      " Display files in utf-8
set fileencoding=utf-8  " Write files in utf-8
set wildmenu                                " command completion
set wildignore=*.swp,*.bak,*.pyc,*.class    " ignore for command completion
set textwidth=80        " wrap at 80 chars (when wrap is on)
imap jj <Esc>

" toggle invisible characters with :set list / :set nolist
set listchars=tab:¦\ ,eol:¬,trail:⋅,extends:❯,precedes:❮

" Color column setting
set colorcolumn=80      " show column 80
highlight ColorColumn ctermbg=7         " light grey color column
highlight ColorColumn guibg=LightGray    " light gray color column gvim

" search settings
set incsearch           " search as characters entered
set hlsearch            " highlight search matches
set ignorecase          " part 1 of 2 for smart searching
set smartcase           " part 2 of 2 for smart searching


" auto commands and file types
filetype plugin indent on      " enable filetype detection and settings
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd FileType markdown,mkd   setlocal textwidth=80
autocmd FileType text           setlocal textwidth=80
autocmd FileType make setlocal noexpandtab
autocmd Filetype php setlocal noexpandtab
autocmd Filetype go setlocal noexpandtab
"autocmd FileType * set fo-=c fo-=r fo-=o     " disable auto comments
autocmd BufWritePre * %s/\s\+$//e       " strip trailing whitespace on write


"vim-plug settings
"
" Automatically install vim-plug and run PlugInstall if vim-plug not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
Plug 'ctrlpvim/ctrlp.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'pangloss/vim-javascript'
Plug 'chemzqm/vim-jsx-improve'
Plug 'scrooloose/nerdtree'
Plug 'michalliu/jsruntime.vim'
Plug 'michalliu/jsoncodecs.vim'
Plug 'michalliu/sourcebeautify.vim'
" Code Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
" Other Code-related
Plug 'neomake/neomake'
" Vim color schemes
Plug 'sickill/vim-monokai'
Plug 'tomasr/molokai'
Plug 'albertorestifo/github.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/seoul256.vim'
Plug 'Addisonbean/Vim-Xcode-Theme'
call plug#end()

" Colorscheme
" No colorscheme - happy with terminal default
"colorscheme seoul256
"set background=light

" Deoplete
let g:deoplete#enable_at_startup = 1

" NERDTree
" open NERDTree if no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" open NERDTree if opening directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Generic toggle function, makes toggles available in insert mode too
function! MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command! -nargs=+ MapToggle call MapToggle(<f-args>)

" custom mapping for leader key
map <SPACE> <leader>
"map <leader>h :wincmd h<CR>
"map <leader>j :wincmd j<CR>
"map <leader>k :wincmd k<CR>
"map <leader>l :wincmd l<CR>
nnoremap <Leader>ww <C-w><C-w>
nnoremap <leader>b :set nomore <Bar> :ls <Bar> :set more <CR>:b<Space>
nnoremap <leader>l :ls<CR> :b<space>
nnoremap <leader>vr :vsp $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

MapToggle <leader>r relativenumber
nnoremap <leader>fj :<C-U>call FormatJSON(v:count)<CR>
" clear highlight from search
" nnoremap <leader>n :noh<CR>
map <leader>n :NERDTreeToggle<CR>

" tern
if exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

" Format json
" - requires node.js
function! FormatJSON(...)
    let code="\"
          \ var i = process.stdin, d = '';
          \ i.resume();
          \ i.setEncoding('utf8');
          \ i.on('data', function(data) { d += data; });
          \ i.on('end', function() {
          \     console.log(JSON.stringify(JSON.parse(d), null,
          \ " . (a:0 ? a:1 ? a:1 : 2 : 2) . "));
          \ });\"
    execute "%! node -e " . code
endfunction

" Mac/Windows compatibility
" I don't like these settings but keep them for reference
" set clipboard=unnamed   " use system buffer
" set mouse=a             " term mouse navigation (but lose cut and paste)
" autocmd GUIEnter * simalt ~x    " start GUI vim maximized (Windows)

"  fold settings
set foldmethod=indent
set nofoldenable          " But turn it off initially

