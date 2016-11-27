
call plug#begin('~/.vim/plugged')

" A plugin to deal with things that surround other things - html tags,
" parentheses, quotes, etc.
"Plug 'tpope/vim-surround'

" A plugin that lets you use % to jump between more than just parentheses
" and brackets (uses the syntax files to intelligently guess what to match
" for things like html tags)
"Plug 'tmhedberg/matchit'

" Snazzy, lightweight statusline to replace the default
Plug 'bling/vim-airline'

" Snippets to output oft-written blocks of code for you
"Plug 'Shougo/neosnippet.vim'

" Have vim check your files for syntax errors
"Plug 'scrooloose/syntastic'

" Comment out passages with a key command instead of manually - there are lots
" of plugins that do this - this one is my favorite
"Plug 'scrooloose/nerdcommenter'

" Show git status to the left of the line number
"Plug 'mhinz/vim-signify'

" Control git from inside vim
"Plug 'tpope/vim-fugitive'

" Show a tree menu of the files in your current directory to the left of your
" editor (like you get in most IDEs).

"Plug 'scrooloose/nerdtree'
" Search through files inside nerdtree with ack
"Plug 'vim-scripts/nerdtree-ack'

" Duplicate nerdtree across all tabs (a behavior you'd expect to be default
" coming from IDEs)

"Plug 'jistr/vim-nerdtree-tabs'
"Auto completers
"Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }

call plug#end()

"Things needed to make vim work like it should:
"This is not vi:
set nocompatible
"Use syntax:
syntax enable
"Don't go into command mode:
nnoremap Q <nop>
nnoremap q: <nop>
" Set charset to UTF-8
set encoding=utf-8
scriptencoding utf-8
"make backspace work like it should:
set backspace=indent,eol,start
" Make Y yank to the end of the current line:
nnoremap Y y$
"Use C^h,j,k,l to move between windows:	
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
"Dont tab complete for these files:
set wildignore+=*.o,*.out,*.obj,*.rbc,*.rbo,*.class,*.gem,*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.jpg,*.png,*.gif,*.jpeg,*.bmp,*.tif,*.tiff,*.psd,*.hg,*.git,*.svn,*.exe,*.dll,*.pyc,*.DS_Store
"Don't make swapfiles:
set noswapfile
set nobackup
set nowritebackup
"Make new lines have the right indentation
set autoindent
set smartindent
" Treat long lines as break lines 
map j gj
map k gk
" Always show the status line
set laststatus=3

"Make searching work better:
"Make searching sweet:
set ignorecase
set smartcase
set incsearch
"Make highlights work on searches and brackets:
set hlsearch
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
set showmatch
"makes the current search result always appear in the middle of the screen:
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz

"Key mappings:
"These are to kill the arrow keys and F1 help
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>
noremap   <F1>     <NOP>
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
"set leader
let mapleader = " "
" Use F2 to toggle paste mode instead of having to type ':set paste'
set pastetoggle=<F2>

" Make sure there are at least two lines of padding above and below your
" cursor. This causes the window to scroll when you get within close two lines
" of the bottom of the screen.
set scrolloff=3
" Also keep two columns to the left and right when scrolling horizontally
set sidescrolloff=3

" When you indent or de-indent something in visual mode, the default is to
" immediately un-select the text when finished. This mapping maintains the
" selection even after indenting or de-indenting.
vnoremap < <gv
vnoremap > >gv

" I like to map the right and left arrow keys to go to the previous and next
" buffers while in normal mode.
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>

" Auto-reload your vimrc whenever you write to it:
augroup reload_vimrc " {
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Fill in the 80th column with a solid color, to let you know when you're
" getting close to your wrap limit
set colorcolumn=80
" The colorcolumn can get aesthetically obnoxious though - I like to make it
" light black to keep it unobtrusive:
highlight ColorColumn ctermbg=7

" If we have a sufficient version of vim, we can use a persistennt undo
" file. This lets the undo history for a file persist between editing sessions
if v:version >= 703
        set undofile
        set undodir=~/.vim/tmp,~/.tmp,~/tmp,~/var/tmp,/tmp
endif

"Set relative number
"set relativenumber
set number

" Show a bottom bar that lets you see what you're typing as you enter commands
set showcmd

" Show current position in vile (perecntage scrolled) and current line and
" column
set ruler

" Sometimes vim will ues the system bell to beep at you. Don't let it.
set noerrorbells
set t_vb=
" Vim can use a visual bell instead. I'm allowing it here - you can set this
" to novisualbell instead to disallow it.
set visualbell

" Store lots of undo information
set undolevels=1000

" Remember more command and search history
set history=1000

" Did you make some edits to a file you don't own, only to realize once you
" try to save that you don't have permission to write to it? If you have
" root, this command will let you type :w!! to enter your password and write
" the file.
cmap w!! w !sudo tee % >/dev/null

" When you tab-complete a vim command at the bottom of the screen, make vim pop " up a little menu to show all your completion options at once, instead of only " the current one
set wildmenu

" Ignore case when tab completing vim commands
set wildignorecase

" This line further configures the 'wildmenu' option. You can consult :help
" wildmode for more on the options available, but here's an example. This means
" that the first time you press tab to complete a vim command, the wildmenu
" will just pop up and show your options, not selecting anything for you yet.
" The next time you press tab, it will start cycling through the options.
set wildmode=list:full

" Ignore case when tab-completing filenames
set wildignorecase

" Fairy dust to make vim work faster over a laggy connection
set ttyfast

"Turn on the pretty colors
colorscheme elflord
"colorsheme desert
set background=dark


"Make tabs sweet
set expandtab
set smarttab
set shiftwidth=3
set tabstop=3
set ai "Auto indent
set si "Smart indent
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove


" Remember info about open buffers on close
set viminfo^=%
