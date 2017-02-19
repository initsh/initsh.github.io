""""""""""""""""""""""""""""""""
""  user defined
""""""""""""""""""""""""""""""""
" Edit 20170220
"## common ##
syntax on
set showcmd
"set nu
set ruler
"set list
set cursorline
set showmatch
set wrap
set display=lastline
set whichwrap=h,l
set scrolloff=5
"set visualbell
set visualbell t_vb=
set noerrorbells

"## backup ##
set backup
set writebackup
"set backupdir=$HOME/.vimbackup
au BufWritePre * let &bex = '_' . strftime("%Y%m%d_%H%M%S") . '.backup'

"## tab ##
"set expandtab
"set shiftwidth=2
"set autoindent
"set tabstop=2

"## search ##
set hlsearch
set wrapscan
"set ignorecase
"set smartcase
set incsearch

"## intellisense ##
set pumheight=10
set wildmode=list
"set wildmode=list:longest
set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-",'\zs')
  exec "imap " . k . " " . k . "<C-N><C-P>"
endfor
imap <expr> <TAB> pumvisible() ? "\<Down>" : "\<Tab>"

"EOF
