" vimrc

" Edit 20170305

"## common ##
syntax on			"シンタックス
set showcmd			"入力中のコマンドを表示
"set nu 			"行番号を表示
set ruler 			"右下に表示
"set list 			"制御文字を表示
set cursorline			"カーソルラインを表示
set showmatch			"対応する括弧を強調表示
set wrap			"ウィンドウの幅より長い行を折り返し表示
set display=lastline		"ウィンドウの最後の行をできる限り表示
set nocompatible		"Vi互換モードオフ
set whichwrap=h,l,<,>		"行頭行末からカーソル左右移動で上下行へ移動
set scrolloff=8			"画面スクロールする際8行の余裕を持たせる
set noerrorbells		"エラーベルを鳴らさない
set visualbell t_vb=		"ビープ音をすべて視覚表示に変更 視覚表示の内容は空文字

"## file ##
set wildmenu			"コマンドライン保管を拡張
set wildmode=list		"コマンドライン保管を拡張2

"## backup ##
set backup			"バックアップファイルを作成
set writebackup			"取得するバックアップを編集前のファイルとする
set backupdir=$HOME/.vimbackup
				"バックアップ作成ディレクトリを設定
call system("mkdir $HOME/.vimbackup")
				"バックアップ作成ディレクトリを作成
au BufWritePre * let &bex = '_' . strftime("%Y%m%d_%H%M%S") . '.backup'
				"バックアップファイルの名称にタイムスタンプと.backup拡張子を付与する

"## tab ##
"set expandtab			"タブの挿入をスペース文字にする
"set autoindent			"自動インデントを有効
"set cindent			"自動インデント(C言語仕様)を有効
"set shiftwidth=4		"Vimの自動インデント等によって挿入されるタブの幅
set tabstop=8			"tabキーの入力文字幅を設定

"## search ##
set incsearch			"インクリメンタルサーチを有効
set hlsearch			"検索にマッチしたすべてのテキストをハイライト
set wrapscan			"検索時、ファイル末尾まで進んだら、ファイル先頭から再び検索
set ignorecase			"検索時、大文字小文字を無視
set smartcase			"検索時、小文字の場合は大小文字を、大文字の場合は大文字のみを検索(ignorecase併用)

"## intellisense ##
set completeopt=menu,menuone
				"候補が1つしかないときもポップアップメニューを使う
set pumheight=8			"ポップアップメニューの最大高さを制御

" ## intellisense DIY ##
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-",'\zs')
	exec "imap " . k . " " . k . "<C-N><C-P>"
endfor
imap <expr> <TAB> pumvisible() ? "\<Down>" : "\<Tab>"


"EOF
