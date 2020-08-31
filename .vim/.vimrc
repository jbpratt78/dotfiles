" This must be first, because it changes other options
if &compatible
  set nocompatible
endif


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" themes
Plug 'cormacrelf/vim-colors-github'
Plug 'srcery-colors/srcery-vim'

Plug 'itchyny/lightline.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': [
      \ 'python', 
      \ 'bash', 
      \ 'rust', 
      \ 'cpp', 
      \ 'kotlin',
      \ 'javascript', 'typescript',
      \ 'cfn_yaml', 'cfn_json'] }

Plug 'wellle/context.vim'

"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'govim/govim'
Plug 'prabirshrestha/asyncomplete.vim' " Needed to make govim/govim autocompletion work
Plug 'yami-beta/asyncomplete-omni.vim' " Needed to make govim/govim autocompletion work

Plug 'sebdah/vim-delve'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}  " Needed to make sebdah/vim-delve work on Vim
Plug 'Shougo/vimshell.vim'                  " Needed to make sebdah/vim-delve work on Vim

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'udalov/kotlin-vim'
call plug#end()

filetype indent on
syntax on

set shell=$SHELL               " Set the default shell
set history=1000               " The number of history items to remember
set ttyfast                    " Set that we have a fast terminal
set t_Co=256                   " Explicitly tell Vim that the terminal supports 256 colors
set lazyredraw                 " Don't redraw vim in all situations
set synmaxcol=500              " The max number of columns to try and highlight
set noerrorbells               " Don't make noise
set hlsearch                   " Highlight search terms
set incsearch                  " Show searches as you type
set autoread                   " Watch for file changes and auto update
set autowrite                  " Write the contents of the file, if it has been modified
set mouse=a                    " Enable using the mouse if terminal emulator
set linebreak                  " Don't wrap in the middle of words
set ignorecase                 " Ignore case when searching
set smartcase                  " Ignore case if search is lowercase, otherwise case-sensitive
set number                     " Shows line numbers
set nojoinspaces               " Don't add 2 spaces when using J
set autoindent                 " Copy indent from current line when starting a new line 
set laststatus=2               " The last window will always have a status line
set softtabstop=2              " Number of spaces that a <Tab> counts for while performing editing operations
set tabstop=2                  " Number of spaces that a <Tab> in the file counts for
set noswapfile                 " Do not use a swapfile for the buffer
set wildmenu                   " command-line completion operates in an enhanced mode
set shiftwidth=2               " Number of spaces to use for each step of (auto)indent
set expandtab                  " Use the appropriate number of spaces to insert a <Tab>
set smartindent                " Do smart autoindenting when starting a new line
set showmode                   " current mode not shown
set formatoptions+=j           " Remove comments when joining lines with J
set smarttab                   " no smart tab size
set showmatch                  " When a bracket is inserted, briefly jump to the matching one
set showcmd                    " Show (partial) command in the last line of the screen.
set cursorline                 " Highlight the screen line of the cursor with CursorLine
set ruler                      " Show the line and column number of the cursor position, separated by a comma
set hidden                     " When off a buffer is unloaded when it is abandoned
set list                       " Show tabs as CTRL-I is displayed
set path+=**                   " Make |:find| discover recursive paths
set backspace=indent,eol,start " Backspace settings
set pastetoggle=<F3>           " Toggle paste mode

set listchars=eol:¬,tab:->,trail:~,extends:>,precedes:<,space:•
set nobackup
set nowritebackup
set updatetime=500
set balloondelay=250
set signcolumn=number
set ttymouse=sgr
" Set mapping and key timeouts
set timeout
set timeoutlen=1000 
set ttimeoutlen=0

if has('clipboard')     " If the feature is available
  set clipboard=unnamed " copy to the system clipboard
  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif

" Create a directory if it doesn't exist yet
function! s:EnsureDirectory(directory)
  if !isdirectory(expand(a:directory))
    call mkdir(expand(a:directory), 'p')
  endif
endfunction

" govim/govim settings
filetype plugin on
filetype indent on
autocmd! BufEnter,BufNewFile *.go syntax on
autocmd! BufLeave *.go syntax off
if has("patch-8.1.1904")
  set completeopt+=popup
  set completepopup=align:menu,border:off,highlight:Pmenu
endif
command! Cnext try | cbelow | catch | cabove 9999 | catch | endtry
nnoremap <leader>m :Cnext<CR>
" end govim settings

" Write undo tree to a file to resume from next time the file is opened
if has('persistent_undo')
  set undolevels=2000            " The number of undo items to remember
  set undofile                   " Save undo history to files locally
  set undodir=$HOME/.vimundo     " Set the directory of the undofile
  call s:EnsureDirectory(&undodir)
endif

colorscheme srcery
set background=dark

let mapleader = ","
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

" Ignore these folders for completions
set wildignore+=.hg,.git,.svn                          " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg         " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.pyc " compiled object files

let g:lightline = {
      \ 'colorscheme': 'srcery',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ }

" Fuck you, help key.
noremap <F1> <Nop>

" Force root permission saves
cnoremap w!! w !sudo tee % >/dev/null

nmap \e :Files<CR>
nmap \r :Rg<CR>

" Easy saving
map <leader>w :w!<cr>

" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" Resizing windows
nnoremap <silent> <Leader>= :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <Leader>0 :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>9 :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>g :<C-u>vsplit<CR>

noremap <Leader>tt :<C-u>term<CR>
noremap <Leader>vt :<C-u>vert term<CR>

nnoremap <Leader>html :-1read $HOME/.vim/.skeleton.html<CR>
nnoremap <Leader>V :edit $MYVIMRC<CR>

" Open files in horizontal split
nnoremap <silent> <Leader>zz :call fzf#run({
\   'down': '40%',
\   'sink': 'botright split' })<CR>

" Open files in vertical horizontal split
nnoremap <silent> <Leader>ZZ :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical botright split' })<CR>

" NERD TREE
let NERDTreeIgnore=['\~$', '.o$', 'bower_components', 'node_modules', '__pycache__']
let NERDTreeWinSize=20
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=0
let NERDTreeKeepTreeInNewTab=1

map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <C-n> :NERDTreeToggle<CR>
map <leader>ss :setlocal spell!<cr>

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

au BufRead,BufNewFile *.gohtml set filetype=gohtmltmpl


" Rust config
let g:rustfmt_autosave = 1

nmap <silent> <leader>u <Plug>(coc-references)
nmap <silent> <leader>p :call CocActionAsync('format')<CR>
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

au InsertLeave * silent! set nopaste

command! -bang ProjectFiles call fzf#vim#files('~/projects', <bang>0)

au BufRead,BufNewFile *.md setlocal textwidth=80

autocmd FileType python let b:coc_root_patterns = ['.git', '.env']

au BufRead,BufNewFile *.cfn.json set ft=cfn_json
au BufRead,BufNewFile *.cfn.yml set ft=cfn_yaml
au BufRead,BufNewFile *.cfn.yaml set ft=cfn_yaml
autocmd BufWritePost *.cfn.* silent !cfn-format -w % 2>/dev/null

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" govim/govim autocompletion
function! Omni()
    call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
                    \ 'name': 'omni',
                    \ 'whitelist': ['go'],
                    \ 'completor': function('asyncomplete#sources#omni#completor')
                    \  }))
endfunction

au VimEnter * :call Omni()

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
