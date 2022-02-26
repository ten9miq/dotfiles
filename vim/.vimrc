let g:vimproc#download_windows_dll = 1 " vimprcにwindowsで利用するためのdllをDLする設定を入れておく
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.vim/dein')

" dein.vim 本体
" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  let s:dein_path = expand('~/.vim/dein/repos/github.com/Shougo/dein.vim')
  if !isdirectory(s:dein_path)
    call system('git clone https://github.com/Shougo/dein.vim ' . s:dein_path)
    if v:version == 704
      " vim 7.4では1.5のdeinでないと動作しないので切り替え処理を行う
      call system('cd '. s:dein_path . ' && git checkout -b 1.5 1.5')
    endif
  endif
  set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
endif


" 設定開始
let g:dein#types#git#clone_depth = 1
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " dein Do not manage dein at Vim 7.4, as it is not HEAD
  if v:version != 704
    call dein#add('Shougo/dein.vim')
    call dein#add('cohama/lexima.vim')
  else
    " vim 7.4だとインサートモード移行時にエラーがでるので
    " 以前のバージョンを指定することで回避する
    call dein#add('cohama/lexima.vim', { 'rev': 'aef88ca' })
  endif

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif
"*******************************************************************************************
" 先に実行定義しておかない設定内で実行できない関数
"*******************************************************************************************

" -------------------------------------------------
" ネストしたディレクトリを作成する関数
" -------------------------------------------------
function! s:make_dir(dir)
  if !isdirectory(a:dir)
    " p を渡すことでネストしたディレクトリ全てが作成される
    call mkdir(a:dir, 'p')
  endif
endfunction

"*******************************************************************************************
" 基本設定
"*******************************************************************************************

" setting
" 文字コード設定 自動認識のためのコードを末尾に追加
" set encoding=utf-8
" set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,cp932,sjis
set fileformats=unix,dos,mac
" (Windows向け)パス区切りをスラッシュに
set shellslash
" スワップファイルは使う(異常終了した場合にリカバリーできる)
set swapfile
set directory=$HOME/.vimSwap
call s:make_dir(&directory)
" バックアップディレクトリの指定(下の関数にてディレクトリがない場合には作成する)
set backupdir=$HOME/.vimBackup
" 設定したディレクトリを生成する & をつけてオプションの値を渡していることに注意
call s:make_dir(&backupdir)
" ファイルを閉じてもファイルを閉じる前の操作をUndoできるようになる
set undodir=$HOME/.vimUndo
call s:make_dir(&undodir)
set undofile
" カーソルを移動する際に行頭、行末で止まらないようにする
set whichwrap+=b,s,h,l,<,>,[,]
" VIMのヤンク＆ペーストコマンドがクリップボードを利用
set clipboard=unnamed,unnamedplus,autoselect
" （0の時インサートモードから抜けると自動的にIMEをオフにする
" 再度インサートモードになるときは英数字モードとなる
" (2にするとインサートモードに復帰したときにIMEオンになる)
set iminsert=0
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" ペースト時のオートインデントのをするかを切り替えるショートカット
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" 見た目系
" Syntax Highlightを有効
" syntax enable:
"   現在の色設定を変更しない。
"   そのため、このコマンドを使用する前後にコマンド ":highlight" で好みの色を設定
"   することができる。
" syntax on:
"   現在の設定を破棄して、デフォルトの色を設定させたい場合は次のコマンドを使用する
syntax enable
" カラースキーマー設定
" NeoBundleのインストール後に対象のカラースキーマー名を指定しないとエラーがでる
colorscheme molokai
set background=dark
" 自動判定で256の値が入るが、vim起動時にラグで一瞬違う色が出るのでその対策に明示的に宣言する
set t_Co=256

" tmux上などで256色表示すための判定処理
if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  if $COLORTERM == "gnome-terminal"
    set term=gnome-256color
  else
    if $TERM == "xterm"
      set term=xterm-256color
    endif
  endif
endif

if &term =~ "256color"
  set t_ut=
endif

" commentの色を変更
hi Comment         ctermfg=240
" カーソルがない行の文字がイタリック体にならないようにする
autocmd ColorScheme * hi SpecialKey gui=none
autocmd ColorScheme * hi Special guibg=bg gui=none
"入力中のコマンドをステータスに表示する
set showcmd
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
" set cursorcolumn
" ビープ音を可視化
set visualbell
" ステータスラインを常に表示
set laststatus=2
" ウィンドウにタブバーを表示するようにする
set showtabline=2
" 省略されずに表示
set display=lastline
" 括弧入力時の対応する括弧を表示
set showmatch
" Vimの「%」を拡張する
source $VIMRUNTIME/macros/matchit.vim
" ステータスラインにてファイルエンコーディングやファイルフォーマット(改行コード)を表示
set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P\ 
" コマンドラインの補完
set wildmode=list:longest
" showbreaks 折り返されたところを見やすく
set showbreak=↪
" Tab、行末の半角スペースを明示的に表示する。
set list
" タブや行末スペースをどの記号で表示するかを設定する
set listchars=tab:^\ ,trail:･,extends:»,precedes:«,nbsp:⊔
" itchyny/lightline.vimの色スキーマを変更
let g:lightline = {
    \     'colorscheme': 'wombat',
    \     'active': {
    \       'left': [
    \         [ 'mode', 'paste' ],
    \         [ 'readonly', 'filename', 'modified' ]
    \       ],
    \       'right': [
    \           [ 'lineinfo' ],
    \           [ 'percent' ],
    \           [ 'char_count', 'charvaluehex', 'fileformat', 'fileencoding', 'filetype' ]
    \       ]
    \     },
    \     'component_function': {
    \       'char_count': 'LightlineCharCount'
    \     },
    \ }

" 上記でモード表記されるのでデフォルトのモード表記を非表示にする
set noshowmode

" Space,Tab系
" 行頭以外のTab文字の表示幅（スペースいくつ分）
" set tabstop=4
" 行頭でのTab文字の表示幅
" set shiftwidth=4

"タブ入力を複数の空白入力に置き換える
set expandtab
"画面上でタブ文字が占める幅
set tabstop=2
"自動インデントでずれる幅
set shiftwidth=2
"連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=2
"改行時に前の行のインデントを継続する
set autoindent
"改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" listchars or fillcharsに□や○文字などの全角記号が崩れる問題を解決
if exists('&ambiwidth')
    set ambiwidth=double " UTF-8の□や○でカーソル位置がずれないようにする
endif

" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索時にハイライトを行う
set hlsearch

" コマンドライン設定
" コマンド履歴のヒストリー数を変更
set history=1000
" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
" コマンドラインにて%%と入力すると、%:h<Tab>と入力したときと同じように、
" 自動的にアクティブなバッファのパスに展開される。
cnoremap <expr> %% getcmdtype() ==':' ? expand('%:h').'/' : '%%'

"*******************************************************************************************
" コマンドキー設定
"*******************************************************************************************
" Leader を スペースキーへ置き換える
let mapleader = "\<Space>"

" ノーマルモードで<Leader>yでファイル全体のコピー
nnoremap <silent> <leader>y :%y<CR>
" ノーマルモードで<leader>aでファイル全体を選択する
nnoremap <silent> <leader>a ggVG<CR>
" visualモードとノーマルモードで選択したあとに、
" ヤンクした文字をペーストするとレジスターの中身が入れ替わる現象への対応
noremap <silent> <leader>p "0p<CR>
" 保存
nnoremap <silent> <leader>v :w<CR>
"" w!!でsudoを忘れても保存
cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>

" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" 本来の動作と逆にマッピングすることでgをつけることで論理行で移動する
nnoremap gj j
nnoremap gk k

" ハイライト解除
nmap <C-n> :nohlsearch<CR><Esc>
" Ctrl-cではInsertLeaveイベントが発火しないため cohama/vim-insert-linenrのための設定
inoremap <C-c> <ESC>

" 入力モードでのカーソル移動
" provide hjkl movements in Insert mode via the <Alt> modifier key
" Insert Modeでのカーソル移動 基本的にこれはやらない
" C-o j などを利用するべきだし移動はNormal Modeでやるべき
"inoremap <A-h> <C-o>h
"inoremap <A-j> <C-o>j
"inoremap <A-k> <C-o>k
"inoremap <A-l> <C-o>l
" Ctrl+lは特にキーバインドがないのでDeleteを割り当てる
inoremap <C-l> <Del>
" Insert mode時にCtrl-fに割当がないのでカーソルを右に動かす
inoremap <C-f> <C-o>l
" Insert mode時にCtrl-bの時はカーソルを左に動かす
inoremap <C-b> <C-o>h

" 日本語入力がオンのままでも使えるコマンド(Enterキーは必要)
nnoremap あ a
nnoremap い i
nnoremap う u
nnoremap お o
nnoremap っd dd
nnoremap っy yy
" jjでエスケープ
inoremap <silent> jj <ESC>
" 日本語入力で”っj”と入力してもEnterキーで確定させればインサートモードを抜ける
inoremap <silent> っj <ESC>
" 検索先に移動したときにカーソルの位置を画面中央にする
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz

" filetype=sqlの時にC-cの動作が遅延することへの対策
" :verbose imap <buffer> <C-c> で確認できる
let g:ftplugin_sql_omni_key = '<C-j>'

" -------------------------------------------------
" NERDTree フォルダ階層をツリー表示してくれるプラグインのショートカットを設定
" -------------------------------------------------
nnoremap :tree :NERDTreeToggle
map <C-s> :NERDTreeToggle<CR>
" 隠しファイルを表示する設定
let g:NERDTreeShowHidden = 1
" ツリーの折りたたみの記号を設定
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

" -------------------------------------------------
" Unite.vimのキーマッピングと設定
" -------------------------------------------------
"起動時にInsertモードを有効にして検索可能にする
let g:unite_enable_start_insert=1
" ヤンクのヒストリ機能を有効
let g:unite_source_history_yank_enable =1
" ファイルの開いた履歴を200ストックする
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>

" unite.vim内でのみ有効なキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " 単語単位からパス単位で削除するように変更
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " ESCキーを2回押すと終了する
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction
" -------------------------------------------------
" vim-easymotion
" -------------------------------------------------
" 検索時にsmartcaseで検索する
let g:EasyMotion_smartcase = 1
" 日本語検索を可能にする
let g:EasyMotion_use_migemo = 1
" 移動先候補を下記のみに設定
let g:EasyMotion_keys = 'hklyuiopnmqwertzxcvbasdgjf;'
" easymotionをleader一つで動作するようにする
map <Leader> <Plug>(easymotion-prefix)

" -------------------------------------------------
" t9md/vim-textmanip
" 選択した行またはブロック領域を指定した方向（上/下/右/左）に移動
" -------------------------------------------------
xmap <Space>d <Plug>(textmanip-duplicate-down)
nmap <Space>d <Plug>(textmanip-duplicate-down)
xmap <Space>D <Plug>(textmanip-duplicate-up)
nmap <Space>D <Plug>(textmanip-duplicate-up)

xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-l> <Plug>(textmanip-move-right)

" toggle insert/replace with <F10>
nmap <F10> <Plug>(textmanip-toggle-mode)
xmap <F10> <Plug>(textmanip-toggle-mode)

" -------------------------------------------------
" nathanaelkane/vim-indent-guides
" Yggdroot/indentLineの使用はしない
" インデントに色をつけてくれる
" -------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']

" -------------------------------------------------
" コマンドのヒストリーをたどるときCtrl+pでは
" 先行入力したものでフィルタリングできないためコマンドを修正
" -------------------------------------------------
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" -------------------------------------------------
" sneak.vim
" sのあとに2文字入力することでその場所に移動するプラグイン
" -------------------------------------------------
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
" -------------------------------------------------
" miniburexpl.vim
" バッファをタブのように表示するプラグイン
" -------------------------------------------------
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBuffs = 1

" バッファの移動へショートカットをつける
nmap <C-l> :bnext <CR>
nmap <C-h> :bprev <CR>
nmap <C-j> :bfirst <CR>
nmap <C-k> :blast <CR>

" -------------------------------------------------
" haya14busa/vim-poweryank
" OSC52を使ってリモートでヤンクした内容をローカルのクリップボードに反映させる
" -------------------------------------------------
vnoremap <leader>y :Oscyank<cr> " こっちが動作が早い 1行100文字を974行(97266文字)コピーするとエラーが出る
" map <Leader>y <Plug>(operator-poweryank-osc52) " 1行100文字を974行(97266文字)コピーするとエラーが出る

" -------------------------------------------------
" tpope/vim-commentary
" コメントのパターン設定
" -------------------------------------------------
autocmd FileType sh set commentstring=\#%s
autocmd FileType vim set commentstring=\"%s

" -------------------------------------------------
" kien/rainbow_parentheses.vim
" 対称となる括弧をカラフルに表示する設定
" -------------------------------------------------
"  プラグインを常に適用する設定
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" -------------------------------------------------
" vim-scripts/nginx.vim
" nginxのconfファイルでハイライトを有効にする
" -------------------------------------------------
au BufRead,BufNewFile /etc/nginx/* set ft=nginx

" -------------------------------------------------
" machakann/vim-highlightedyank
" ヤンク対象をハイライトで明示する機能
" -------------------------------------------------
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif

" -------------------------------------------------
" bkad/CamelCaseMotion
" camelCaseやsnake_caseでのモーションを行うプラグイン
" -------------------------------------------------
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

" -------------------------------------------------
" aykamko/vim-easymotion-segments
" easymotionでcamelCaseやsnake_caseでの移動を行えるようにする拡張プラグイン
" -------------------------------------------------
" キャメルケースやスネークケースでのを行うeasymotionのコマンド
nmap <Leader>l  <Plug>(easymotion-segments-LF)
nmap <Leader>L  <Plug>(easymotion-segments-RF)
nmap <Leader>h  <Plug>(easymotion-segments-LB)
nmap <Leader>H  <Plug>(easymotion-segments-RB)
" キャメルケースやスネークケースでのオペレータを使ったeasymotionのコマンド
omap <Leader>l  <Plug>(easymotion-segments-LF)
omap <Leader>L  <Plug>(easymotion-segments-RF)
omap <Leader>h  <Plug>(easymotion-segments-LB)
omap <Leader>H  <Plug>(easymotion-segments-RB)

" -------------------------------------------------
" fidian/hexmode
" vim -b で対象ファイルを16進数エディタして表示､編集が可能になるプラグイン
" -------------------------------------------------
let g:hexmode_xxd_options = '-g 1'
let g:hexmode_patterns = '*.bin,*.exe,*.dat,*.o'

"*******************************************************************************************
" vimの動作改変スクリプト
"*******************************************************************************************
" -------------------------------------------------
"全角スペースを表示
"http://inari.hatenablog.com/entry/2014/05/05/231307
"コメント以外で全角スペースを指定しているので scriptencodingと、
"このファイルのエンコードが一致するよう注意！
"全角スペースが強調表示されない場合、ここでscriptencodingを指定すると良い。
"scriptencoding cp932
" -------------------------------------------------
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
  augroup END
  call ZenkakuSpace()
endif

" -------------------------------------------------
" 最後のカーソル位置を復元する
" -------------------------------------------------
if has("autocmd")
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
endif

" -------------------------------------------------
" カーソル下のsyntax情報を取得する
" -------------------------------------------------
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()

" -------------------------------------------------
" クリップボードからペースト時に自動インデントを行わない設定
" -------------------------------------------------
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" -------------------------------------------------
" Linux上のvimでInsert Modeになるとカーソルを細くする(gVimではデフォルトでなる)
" https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
" -------------------------------------------------
if &term =~ "xterm" " gvimでは実行しないように判定する
  if has("autocmd")
    au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"'
    au InsertEnter,InsertChange *
      \ if v:insertmode == 'i' |
      \   silent execute '!echo -ne "\e[5 q"' |
      \ elseif v:insertmode == 'r' |
      \   silent execute '!echo -ne "\e[3 q"' |
      \ endif
    au VimLeave * silent execute '!echo -ne "\e[ q"'
  endif
endif

" -------------------------------------------------
" バイナリ編集(xxd)モード（vim -b での起動、もしくは *.binファイルを開くと発動します）
" プラグインにより不要
" **.gzのファイルを開く時に下記が無効だとvim内臓のプラグインによりテキストと同じように表示編集可能だが
" 下記の設定が有効だと**.gzファイルが強制的にバイナリ編集になるのでプラグインで行うようにする
" -------------------------------------------------
" augroup BinaryXXD
"   autocmd!
"   autocmd BufReadPre  *.bin let &binary =1
"   autocmd BufReadPost * if &binary | silent %!xxd -g 1
"   autocmd BufReadPost * set ft=xxd | endif
"   autocmd BufWritePre * if &binary | %!xxd -r
"   autocmd BufWritePre * endif
"   autocmd BufWritePost * if &binary | silent %!xxd -g 1
"   autocmd BufWritePost * set nomod | endif
" augroup END

" -------------------------------------------------
" マウスの有効化
" マウスでカーソル移動やスクロール移動が出来るようになります。
" -------------------------------------------------
" if has('mouse')
"     set mouse=a
"     if has('mouse_sgr')
"         set ttymouse=sgr
"     elseif v:version > 703 || v:version is 703 && has('patch632')
"         set ttymouse=sgr
"     else
"         set ttymouse=xterm2
"     endif
" endif

" -------------------------------------------------
" <ESC>wでnowrapをトグル
" -------------------------------------------------
function! Wrap_switch()
  if &wrap == '1'
    set nowrap
  else
    set wrap
  endif
  call Wrap_keybind_setting()
endfunction
nmap <ESC>w :call Wrap_switch()<CR>

" -------------------------------------------------
" vimのwrapの設定を変えるとキーバインドも変更するようにする
" -------------------------------------------------
function! Wrap_keybind_setting()
  if &wrap == '1'
    " 左右の矢印キーでのページ移動を無効化
    noremap <Right> <Right>
    noremap <Left> <Left>
  else
    " 左右の矢印キーでページを左右に半分移動する
    noremap <Right> zL
    noremap <Left> zH
  endif
endfunction
call Wrap_keybind_setting()

if exists('##OptionSet')
  autocmd! OptionSet *wrap call Wrap_keybind_setting()
endif

" -------------------------------------------------
" jqによるjsonのフォーマットをするコマンド
" -------------------------------------------------
command! JqFormat :execute '%!jq "."'
  \ | :set ft=javascript
  \ | :1

" -------------------------------------------------
" pythonによるjsonのフォーマットをするコマンド
" ただしpython ver 3.5で入力出力でキーの順番が同じになった
" それ以前のバージョンでは辞書を使っているので必ずキーでソートされる
" -------------------------------------------------
command! JsonFormat :execute '%!python -m json.tool'
  \ | :set ft=javascript
  \ | :1

" -------------------------------------------------
" pythonによるjsonのフォーマットとUNICODE文字のデコード処理をするコマンド
" -------------------------------------------------
command! JsonFormatUNI :execute '%!python -m json.tool'
 \ | :execute '%!python -c "import re,sys;sys.stdout.write(re.sub(r\"\\\\u[0-9a-f]{4}\", lambda x: unichr(int(\"0x\" + x.group(0)[2:], 16)).encode(\"utf-8\"), sys.stdin.read()))"'
  \ | :%s/ \+$//ge
  \ | :set ft=javascript
  \ | :1

" -------------------------------------------------
" 文字コードの自動認識
" -------------------------------------------------
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" -------------------------------------------------
" 文字数をカウントしLightlineのバーに表示する
" -------------------------------------------------
augroup char_counter
  autocmd!
  autocmd BufCreate,BufEnter * call s:char_counter_initialize()
  autocmd BufNew,BufEnter,BufWrite,InsertLeave,TextChanged * call s:char_counter_update()
augroup END
function! s:char_counter_initialize()
  if !exists('b:char_counter_count')
    let b:char_counter_count = 0
  endif
endfunction
function! s:char_counter_update()
  let b:char_counter_count = s:char_counter()
endfunction
function! s:char_counter()
  let result = 0
  for linenum in range(0, line('$'))
    let line = getline(linenum)
    let result += strlen(substitute(line, '.', 'x', 'g'))
  endfor
  return result
endfunction
if !exists('b:char_counter_count')
  let b:char_counter_count = 0
endif
function! LightlineCharCount() abort
  return b:char_counter_count . '文字'
endfunction

" -------------------------------------------------
" 選択範囲の行の文字数をカウント 選択しEnterで表示
" -------------------------------------------------
function! g:LineCharVCount() range
  let l:result = 0
  for l:linenum in range(a:firstline, a:lastline)
    let l:line = getline(l:linenum)
    let l:result += strlen(substitute(l:line, ".", "x", "g"))
  endfor
  echo '選択行の文字数:' . l:result
endfunction
command! -range LineCharVCount <line1>,<line2>call g:LineCharVCount()
vnoremap<silent> <CR> :LineCharVCount<CR>"}}}
