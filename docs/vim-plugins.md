# Vim プラグイン調査

調査日: 2026-07-11

## 概要

このリポジトリは [dein.vim](https://github.com/Shougo/dein.vim) で Vim プラグインを管理している。
設定は次の3ファイルに分かれている。

- `vim/.vimrc`: dein.vim の導入、プラグイン固有設定、キーマッピング
- `vim/.vim/rc/dein.toml`: 起動時に読み込む23プラグイン
- `vim/.vim/rc/dein_lazy.toml`: 遅延読み込み対象の3プラグイン

dein.vim 本体を含めると管理対象は合計27件である。このほか、3件がコメントアウトされている。
`vim/init.sh` の実行時に `.vimrc`、`.gvimrc`、`.vim/` が `$HOME` へコピーされ、Vimの初回起動時に dein.vim と未導入プラグインがGitHubから取得される。

## プラグイン一覧

### 管理と非同期処理

| プラグイン | 用途 | この設定での扱い |
|---|---|---|
| [Shougo/dein.vim](https://github.com/Shougo/dein.vim) | プラグイン管理 | `.vimrc` から自動取得。Vim 7.4ではタグ `1.5`、Vim 8.0〜8.1ではタグ `2.2` を使用 |
| [wsdjeg/dein-ui.vim](https://github.com/wsdjeg/dein-ui.vim) | deinの更新UI | `:DeinUpdate` による一括更新を想定 |

### 移動とテキスト編集

| プラグイン | 用途 | 主な設定・操作 |
|---|---|---|
| [easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion) | 画面内の候補へ素早く移動 | Spaceをプレフィックスに使用。smartcase、migemoを有効化 |
| [justinmk/vim-sneak](https://github.com/justinmk/vim-sneak) | 2文字検索による移動 | `s` の後に2文字を入力。候補ラベルを表示 |
| [bkad/CamelCaseMotion](https://github.com/bkad/CamelCaseMotion) | camelCase、snake_case単位の移動 | `w`、`b`、`e`、`ge` を標準動作から置換 |
| [aykamko/vim-easymotion-segments](https://github.com/aykamko/vim-easymotion-segments) | EasyMotionを単語セグメントへ拡張 | Spaceと `h`/`l` の組み合わせを割り当て |
| [tpope/vim-surround](https://github.com/tpope/vim-surround) | 括弧や引用符の追加・変更・削除 | プラグイン標準操作を使用 |
| [tpope/vim-commentary](https://github.com/tpope/vim-commentary) | コメント化・解除 | `gc{motion}`。shとVim scriptのコメント形式を明示 |
| [t9md/vim-textmanip](https://github.com/t9md/vim-textmanip) | 行や矩形選択の複製・移動 | Space+`d`/`D`、VisualモードのCtrl+`h`/`j`/`k`/`l` |
| [michaeljsmith/vim-indent-object](https://github.com/michaeljsmith/vim-indent-object) | インデント単位のテキストオブジェクト | プラグイン標準操作を使用 |

### ファイル、バッファ、履歴

| プラグイン | 用途 | 主な設定・操作 |
|---|---|---|
| [scrooloose/nerdtree](https://github.com/preservim/nerdtree) | ファイルツリー | Ctrl+`s` で開閉。隠しファイルを表示 |
| [fholgado/minibufexpl.vim](https://github.com/fholgado/minibufexpl.vim) | バッファをタブ状に表示 | Ctrl+`h`/`j`/`k`/`l` でバッファ移動 |
| [Shougo/unite.vim](https://github.com/Shougo/unite.vim) | ファイル、バッファ、履歴等の統合検索 | `,uy`、`,ub`、`,uf`、`,ur`、`,uu` を割り当て。遅延設定 |
| [Shougo/neomru.vim](https://github.com/Shougo/neomru.vim) | Uniteの最近使ったファイル履歴 | `unite.vim` の読み込み時に追従して読み込む |
| [Shougo/neoyank.vim](https://github.com/Shougo/neoyank.vim) | Uniteのヤンク履歴 | `unite.vim` の読み込み時に追従して読み込む |

### 表示と配色

| プラグイン | 用途 | 主な設定 |
|---|---|---|
| [itchyny/lightline.vim](https://github.com/itchyny/lightline.vim) | ステータスライン | wombat配色。モード、ファイル情報、位置などを表示 |
| [bronson/vim-trailing-whitespace](https://github.com/bronson/vim-trailing-whitespace) | 行末空白の可視化 | 追加設定なし |
| [nathanaelkane/vim-indent-guides](https://github.com/nathanaelkane/vim-indent-guides) | インデント階層の色分け | 起動時に有効化。help、NERDTree、Unite等を除外 |
| [kien/rainbow_parentheses.vim](https://github.com/kien/rainbow_parentheses.vim) | 対応する括弧の色分け | Vim起動時に有効化し、丸・角・波括弧を対象にする |
| [machakann/vim-highlightedyank](https://github.com/machakann/vim-highlightedyank) | ヤンク範囲の一時強調 | `TextYankPost` がない旧Vimでは `y` をプラグインへ割り当て |
| [tomasr/molokai](https://github.com/tomasr/molokai) | molokaiカラースキーム | `.vimrc` の `colorscheme molokai` で使用 |

### 実行、クリップボード、ファイル形式

| プラグイン | 用途 | 主な設定・注意点 |
|---|---|---|
| [vim-scripts/quickrun.vim](https://github.com/vim-scripts/quickrun.vim) | 編集中のコードを実行 | コメントでは Space+`r` を想定するが、`.vimrc` に対応マッピングは見当たらない |
| [greymd/oscyank.vim](https://github.com/greymd/oscyank.vim) | OSC52経由でリモートのヤンクをローカルへ送信 | VisualのSpace+`y`。設定内に約97KBでの既知エラー記録あり |
| [chr4/nginx.vim](https://github.com/chr4/nginx.vim) | Nginx設定のシンタックス | `/etc/nginx/*` を `nginx` filetypeに設定 |
| [ekalinin/Dockerfile.vim](https://github.com/ekalinin/Dockerfile.vim) | Dockerfileのシンタックス | 追加設定なし |
| [fidian/hexmode](https://github.com/fidian/hexmode) | `vim -b` 等で16進編集 | `xxd -g 1`、bin/exe/dat/oを対象に設定 |
| [powerman/vim-plugin-AnsiEsc](https://github.com/powerman/vim-plugin-AnsiEsc) | ANSIエスケープシーケンスの表示 | プラグインに加え、独自の `:AnsiEscDel` も定義 |

## コメントアウトされている候補

| プラグイン | 状態 | 理由 |
|---|---|---|
| [vim-jp/vimdoc-ja](https://github.com/vim-jp/vimdoc-ja) | 無効 | 設定コメントでは容量約70MBを理由に削除 |
| [Yggdroot/indentLine](https://github.com/Yggdroot/indentLine) | 無効 | `vim-indent-guides` を選択しているため |
| [haya14busa/vim-poweryank](https://github.com/haya14busa/vim-poweryank) | 無効 | oscyankより遅く、大量コピー時にもエラーが出るため |

## 調査で判明した保守上の注意点

### 不要プラグイン監査

2026-07-11に、TOMLの全宣言と `.vimrc` の変数、コマンド、マッピング、autocmdを照合した。

#### 削除済み

| プラグイン | 判定理由 | 削除時の追加作業 |
|---|---|---|
| `sickill/vim-monokai` | `.vimrc` と `.gvimrc` が指定する `colorscheme molokai` は `tomasr/molokai` が提供し、このプラグインへの参照がなかった | 2026-07-11に `dein.toml` から削除済み |

設定だけから「機能を失わず確実に削除できる」と判断できたため削除した。

#### 利用していなければ削除可能

| プラグイン | 残す条件 | 削除時に整理するもの |
|---|---|---|
| `vim-scripts/quickrun.vim` | `:QuickRun` を手動で利用している | TOMLの宣言。説明にあるSpace+`r`のマッピングは実装されていない |
| `wsdjeg/dein-ui.vim` | `:DeinUpdate` のUIを利用している | TOMLの宣言と関連コメント。dein本体は残る |
| `powerman/vim-plugin-AnsiEsc` | ANSIコードを色付きで表示する `:AnsiEsc` を利用している | TOMLの宣言。独自の `:AnsiEscDel` はプラグイン非依存なので残せる |
| `fidian/hexmode` | `vim -b` またはbin/exe/dat/oファイルを16進編集している | TOMLの宣言と `.vimrc` の `g:hexmode_*` 2設定 |

quickrunについては、設定先が現行開発元 `thinca/vim-quickrun` ではなく、旧vim.org配布物のGitHubミラー `vim-scripts/quickrun.vim` である。残す場合も配布元の更新を検討する。

#### 用途が限定的だが、設定上は使用中

- `chr4/nginx.vim` と `ekalinin/Dockerfile.vim`: 対象ファイルを編集する場合に自動適用される。対象を扱わないなら削除候補。
- `greymd/oscyank.vim`: VisualモードのSpace+`y`へ明示的に割り当てられている。SSHやtmux越しのコピーを使わないなら削除候補。
- `fholgado/minibufexpl.vim`: 表示設定と4つのバッファ移動キーがあるため使用中。ただしVim標準の `:buffers`、`:bnext` 等だけで足りるなら置換可能。公式READMEは開発先が別リポジトリへ移ったと案内している。
- `bronson/vim-trailing-whitespace`: `set list` と `listchars=...trail:･` でも行末空白は見えるため、可視化は重複する。ただし赤色強調と `:FixWhitespace` はこのプラグイン固有。
- `kien/rainbow_parentheses.vim`: 起動時とSyntaxイベントで明示的に有効化されている。Vim標準の対応括弧表示だけで十分なら削除可能。

#### 現状維持を推奨

`vim-surround`、`vim-commentary`、EasyMotion系、`vim-sneak`、`vim-textmanip`、`vim-indent-guides`、`lightline.vim`、`vim-highlightedyank`、`vim-indent-object`、`CamelCaseMotion`、`tomasr/molokai`、Unite系は、標準マッピングを直接使うもの、または `.vimrc` に明示設定がある。静的検索でプラグイン名が見つからないことだけを理由に削除してはいけない。

次の削除候補は、実際の利用有無を確認したうえでquickrun、dein-ui、AnsiEsc、hexmodeの順に検討するのが安全である。

### vimproc.vimは調査後に削除済み

調査の結果、当時の `.vimrc`、`dein.toml`、`dein_lazy.toml` に記載された使い方では `Shougo/vimproc.vim` は必須ではなかったため、2026-07-11に設定から削除した。

- `.vimrc` 内に `vimproc#...` 関数の呼び出しはなく、先頭にあった `g:vimproc#download_windows_dll` だけがvimproc固有の設定だった。
- `dein.toml` と `dein_lazy.toml` の他プラグインに `depends = 'vimproc.vim'` はない。
- Uniteで使っているソースは `history/yank`、`buffer`、`file`、`register`、`file_mru` であり、vimprocを利用する非同期ソース `file_rec/async` は使っていない。
- quickrunにはvimprocを利用できるrunnerがあるが、このリポジトリには `g:quickrun_config` や `runner = 'vimproc'` 相当の指定がない。通常の同期実行にvimprocは不要である。
- dein.vim自体のインストール、更新、dein-uiの表示にもvimprocは必須ではない。

ネイティブDLL/共有ライブラリのダウンロードやビルドを不要にするため、次の2か所を削除した。

1. `.vimrc` 先頭にあった `let g:vimproc#download_windows_dll = 1`
2. `dein.toml` 冒頭にあった `Shougo/vimproc.vim` ブロック全体

削除後もUniteとquickrunの基本機能は維持される見込みである。ただし、将来次の機能を使う場合はvimprocを戻すか、Vim/Neovimのjob機能を使う別方式を検討する。

- Uniteのvimprocを利用する非同期ソース
- quickrunのvimproc runnerによる非同期実行や実行中プロセスの中断
- vimproc APIを明示的に依存関係として要求する別プラグイン

既存の `$HOME/.vim/dein/` 以下にあるvimproc本体は、このリポジトリのセットアップ対象外であり、自動削除しない。クリーンな環境ではvimprocが新規導入されないことを確認し、既存環境では必要に応じてdeinの未使用プラグイン整理機能を使う。動作確認では `exists('*vimproc#system')` が0である状態で、Uniteの5つのマッピングと `:QuickRun` を実行する。

### 1. dein.vimは保守モード

dein.vimの公式READMEは、活発な開発を終了し、今後はバグ修正のみと明記している。現行版の前提はVim 8.2以上またはNeovim 0.8以上で、後継としてdpp.vimが案内されている。
一方、この設定はVim 7.4ではdein 1.5、Vim 8.0〜8.1ではdein 2.2へ切り替える互換処理を持つ。2.2はVim 8.0以上を要件とし、dein 3.1のREADMEでもVim 8.2未満には2.2を使うよう案内されている。既存のdeinも起動時に確認して互換タグへ切り替える。これらの固定版はdein自身の管理対象から除外し、`:DeinUpdate`で現行HEADへ更新されないようにしている。

### 2. Unite系の遅延読み込み条件が不足している可能性

`dein_lazy.toml` は全体を `lazy: 1` で読み込むが、`unite.vim` 自体には `on_cmd`、`on_map`、`on_source` などの起動条件がない。`neomru.vim` と `neoyank.vim` には `on_source = ['unite.vim']` があるため、Uniteが読み込まれれば連動する。

現在の `,u...` マッピングは `:Unite` を直接実行するため、環境やdeinのキャッシュ状態によってはコマンド未定義になる恐れがある。修正する場合は、まずクリーンな一時ホームで再現確認し、`unite.vim` に `on_cmd = ['Unite', 'UniteWithBufferDir']` を設定する案を検証する。

### 3. NERDTreeの管理先が古い名前

設定は `scrooloose/nerdtree` を指定しているが、公式の現行表記と導入例は `preservim/nerdtree` である。GitHubの転送に依存せず、将来の再インストールを安定させるには設定名の更新候補となる。既存のdein管理ディレクトリが変わる可能性があるため、変更時は再導入手順も確認する。

### 4. 自動取得とネイティブビルドがある

Vim起動時の `git clone` と `dein#install()` によりネットワークアクセスが発生する。プラグインのリビジョンは固定されていないため、再構築時に取得内容が変わり得る。以前はvimprocのネイティブビルドもあったが、設定から削除済みである。

### 5. キーマッピングの影響範囲が広い

CamelCaseMotionは基本移動の `w`、`b`、`e`、`ge` を置き換える。また、バッファ移動とVisualモードのtextmanipがCtrl+`h`/`j`/`k`/`l` を使う。プラグインを外す際は、関連マッピングも同時に整理しないと未定義の `<Plug>` や意図しない操作が残る。

### 6. 設定コメントと実装にずれがある

- quickrunは「Space+`r`」と説明されているが、そのマッピングは確認できない。
- OSC52設定の見出しはpoweryankのままだが、有効なプラグインとコマンドはoscyankである。
- Nginx設定のコメントには別の旧リポジトリ名が残っている。
- 使用されていなかった `sickill/vim-monokai` は削除し、実際に選択される `tomasr/molokai` だけを残した。

これらは直ちに動作不良とは限らないが、次回の設定変更時にコメントと実装を同期することが望ましい。

## 更新・確認方法

- 未導入プラグイン: Vim起動時の `dein#check_install()` により自動導入
- 一括更新: `:DeinUpdate`
- 読み込み状態: `:call dein#check_install()`、`:scriptnames`、`:verbose map <キー>` で確認
- Unite確認: クリーン環境で起動直後に `:echo exists(':Unite')` を実行
- プラグイン削除時: TOMLの宣言だけでなく、`.vimrc` 内の変数、autocmd、コマンド、`<Plug>` マッピングも検索する

実際のホームディレクトリを汚さないよう、導入・更新テストは一時的な `$HOME` と一時的なdeinディレクトリで行う。

## 参照した公式情報

- [vimproc.vim README](https://github.com/Shougo/vimproc.vim): 非同期実行ライブラリの役割、ネイティブ拡張のビルド要件
- [quickrun.vim公式リポジトリ](https://github.com/thinca/vim-quickrun): 現行quickrunの配布元
- [設定で指定されているquickrun.vimミラー](https://github.com/vim-scripts/quickrun.vim): `:QuickRun` の基本機能と現行配布元への案内
- [dein.vim README](https://github.com/Shougo/dein.vim): 保守状況、対応バージョン、導入方法
- [Unite.vim README](https://github.com/Shougo/unite.vim): 機能、コマンド、neomru依存、後継案内
- [NERDTree README](https://github.com/preservim/nerdtree): 現在の管理先とdein向け導入例
- [oscyank.vim](https://github.com/greymd/oscyank.vim): OSC52プラグインの配布元
