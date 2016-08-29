call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'sjl/gundo.vim'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
" Plug 'bling/vim-bufferline'
" Plug 'klen/python-mode'

call plug#end()

" Enable mouse
set mouse=a
set ttymouse=xterm2

" Set 2 lines to the cursor - when moving vertically using j/k
set so=2

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Ignore case when searching
" set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Show line numbers
set number

" Highlight current line
set cursorline

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

colorscheme solarized
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Keyboard shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Moving between tabs
noremap <C-j> gT
noremap <C-k> gt


" Plugins configuration

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

nnoremap <F5> :GundoToggle<CR>

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

