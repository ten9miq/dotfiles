# Zsh プラグイン調査

調査日: 2026-07-11

## 概要

このリポジトリは [z-shell/zi](https://github.com/z-shell/zi) をプラグインマネージャーとして使用し、`zsh/.zshrc` から10件のプラグインを読み込む。以前使用していたzsh-gomiは、現行のGo版gomiへ移行した。

初回起動時に `$HOME/.zi/bin/zi.zsh` がなければ、次の処理でZi本体を取得する。

```zsh
git clone --depth=1 https://github.com/z-shell/zi.git ${zi_home}/bin
```

プラグインもZiによりGitHubから取得される。すべてブランチの先端を利用し、コミットやタグは固定していない。`wait` 等の遅延指定はなく、基本的にZsh起動時に同期して読み込む構成である。

## 有効なプラグイン

| プラグイン | 用途 | 読み込み設定・依存 |
|---|---|---|
| [zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions) | Zsh標準にない補完定義を追加 | `blockf` で補完ファイルを自動追加せず、後段の`compinit`と組み合わせる。shallow clone |
| [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | 履歴等に基づく入力候補を薄い文字で表示 | shallow clone。標準設定で使用 |
| [zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | 入力済み文字列を含む履歴を検索 | Zshバージョン条件付きとして宣言。ただし条件式に注意が必要 |
| [zdharma-continuum/fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | 入力中のコマンドを構文強調 | `.zshrc` でパス色をカスタマイズ。現行の組織名で取得 |
| [babarot/enhancd](https://github.com/babarot/enhancd) | fzf等を使って`cd`を履歴・候補選択対応に拡張 | `init.sh`を明示して通常ロード。現行のユーザー名で取得 |
| [mollifier/cd-gitroot](https://github.com/mollifier/cd-gitroot) | Gitリポジトリのルートへ移動 | 共通alias `cdu='cd-gitroot'` から利用 |
| [mollifier/zload](https://github.com/mollifier/zload) | 関数・補完ファイルをautoload形式で再読込 | `gcomp`、`gcomp_all` が生成した補完を `zload` する |
| [yonchu/zsh-vcs-prompt](https://github.com/yonchu/zsh-vcs-prompt) | Git/SVN/Hg情報をプロンプトへ表示 | `.zshrc` の `RPROMPT='$(vcs_super_info)'` と多数の表示変数が直接依存 |
| [supercrabtree/k](https://github.com/supercrabtree/k) | 色・Git状態付きのディレクトリ一覧 | `k`コマンドを追加。GNU系`ls`機能への依存に注意 |
| [junegunn/fzf](https://github.com/junegunn/fzf) | fzfのZsh補完とキーバインド | `shell/completion.zsh` と `shell/key-bindings.zsh` だけを読み込み、プラグイン本体は読み込まない設定 |

## コメントアウトされているプラグイン

| プラグイン | 状態 | 関連設定 |
|---|---|---|
| [RobSis/zsh-completion-generator](https://github.com/RobSis/zsh-completion-generator) | 無効 | `GENCOMPL_FPATH`、`gcomp`、`gcomp_all` は残っている。再有効化にはPythonが必要 |

`gcomp` と `gcomp_all` は `gencomp` コマンドを呼ぶため、補完生成プラグインが無効な現在は、別途同名コマンドがなければ正常動作しない。一方、生成済み補完を読む `zload` 自体は利用できる。

## 読み込み後の利用箇所

### プロンプト

`zsh-vcs-prompt` は明確に使用中である。Git状態の記号とフォーマットを `.zshrc` で設定し、右プロンプトから `vcs_super_info` を毎回評価する。削除する場合はプラグイン宣言だけでなく、`ZSH_VCS_PROMPT_*`、`RPROMPT`も同時に置き換える必要がある。

### 補完

`zsh-completions` とリポジトリ内の `~/.zsh/complete` を`fpath`へ加えた後、`compinit`を実行する。WSLまたはrootでは速度を優先して `compinit -C` を使う。リポジトリにはDockerとDocker Composeの補完ファイルも同梱されている。

### fzf

fzfは複数の場所から利用される。

- enhancdの移動先選択
- 旧zsh-gomiの復元画面（移行後は該当しない）
- fzf自身のCtrl+R等のキーバインドと補完
- `shell_common/functions.bash` のプロセス、ディレクトリ、tmux、Git、Docker選択
- グローバルalias `Z='| fzf'`

したがって、fzfプラグインの削除とfzfバイナリの削除は別問題として扱う。現在のZi設定はシェル統合を提供し、`bin/init.sh` は別途fzfバイナリを `$HOME/bin` に配置する。

## 保守上の注意点

### 1. zsh-gomiはアーカイブ済み

`b4b4r07/zsh-gomi` は現行URL `babarot/zsh-gomi` へ転送されるが、リポジトリは2025-01-15にアーカイブされ、読み取り専用である。作者が現在開発するGo製の [babarot/gomi](https://github.com/babarot/gomi) へ2026-07-11に移行した。

古いプラグインはfzfとシェルスクリプトを組み合わせる実装で、現行のGo版とは別物である。ゴミ箱機能を利用している場合は後継CLIへの移行候補、利用していない場合は削除候補となる。

#### 現行gomiへの移行時の注意点

移行は完了している。Ziのリポジトリ名を置き換えるのではなく、`bin/init.sh` が実行バイナリを導入する。

1. **配布形態が異なる。** 旧版はZiがsourceするZshプラグインだが、現行版はGo製の実行バイナリである。`bin/init.sh` はGitHub Releasesの `latest` URLからOS・CPUに合うアーカイブを取得し、`$HOME/bin/gomi`へ配置する。
2. **`-r`の意味が変わる。** 旧版の `gomi -r` は復元画面を開く操作だが、現行版は`rm`互換の `-r` を再帰削除として扱う。現行版の復元は `gomi -b` または `gomi --restore` である。旧操作を手癖やalias、スクリプトに残したまま移行しない。
3. **復元UIのキーが変わる。** 旧版はfzfベースでEnter、Ctrl+V、Ctrl+X等を使う。現行版の組み込みTUIは矢印、`/`、Tab、Space、Enterを使い、fzfは不要である。
4. **既存ゴミ箱の互換性を事前確認する。** 現行版はXDG Trashと`~/.gomi`を使うlegacy方式を選択でき、初回に `~/.config/gomi/config.yaml` を生成する。しかし公式READMEには旧zsh-gomiデータからの移行保証や手順が明記されていない。旧`~/.gomi`を削除せずバックアップし、テストファイルで現行版の一覧・復元を確認してから切り替える。
5. **`rm` aliasは任意である。** 現行版は `-i`、`-f`、`-r` などの`rm`オプションに対応し、公式は `alias rm=gomi` を提案する。このリポジトリは `shell_common/aliases.bash` で既に `alias rm='rm -i'` を定義しているため、置き換えると既存の確認付き削除を上書きする。既存スクリプトの`rm`まで挙動を変えないよう、まずは `gomi` コマンドとして導入し、対話シェル限定のaliasは別途判断する。
6. **設定と安全機能が増える。** 現行版はLinux、macOS、Windows、複数ボリューム、削除禁止パス、履歴フィルター、恒久削除の無効化等に対応する。初期設定をそのまま共有せず、WSLを含む利用OSでゴミ箱の保存先と復元先を確認する。

`bin/init.sh` はcurlでlatestアーカイブを取得し、展開に成功したバイナリを一時ファイル経由で `$HOME/bin/gomi` へ置き換える。処理を単純に保つためwgetフォールバックと事前のバージョン比較は行わず、セットアップのたびにlatestを取得する。公式latestアーカイブにはこの導入経路で利用できるチェックサムがないため、HTTPS取得とアーカイブ展開結果を確認し、配置後にバージョンを表示する。

### 2. 旧所有者名への依存は解消済み

2026-07-11に、GitHubの転送へ依存していた宣言を現行の所有者名へ更新した。

- `zdharma/fast-syntax-highlighting`から`zdharma-continuum/fast-syntax-highlighting`へ更新
- `b4b4r07/enhancd`から`babarot/enhancd`へ更新
- `b4b4r07/zsh-gomi`は現行Go版gomiへの移行に伴い設定から削除

既存環境ではZiの保存ディレクトリ名が変化するため、旧所有者名で取得済みのコピーが `$HOME/.zi/plugins/` 以下に残る可能性がある。新しい宣言の導入を確認後、必要に応じてZiの削除機能で旧コピーを整理する。dotfilesのセットアップから実ホーム内の旧コピーを自動削除はしない。

### 3. history-substring-searchの条件式

設定は次の条件を指定している。

```zsh
zi ice if"[[ __zsh_version > 4.3 ]]"
```

通常のZshバージョン変数は `$ZSH_VERSION` であり、`__zsh_version` はこの `.zshrc` 内で定義されていない。Zi固有の置換でない限り、意図したバージョン比較にならない可能性がある。現代の対応Zshだけを対象にするなら条件自体の削除、古いZshも対象にするなら `$ZSH_VERSION` を使った条件へ修正する候補である。

### 4. プラグインのバージョンが固定されていない

すべて `depth'1'` または同等のshallow cloneで、特定タグ・コミットを固定していない。初回セットアップ時期により取得内容が変わり、上流の破壊的変更がZsh起動へ直接影響し得る。Zi本体も同様である。

また、存在確認後にファイルを無条件で`source`するため、取得が途中で失敗した場合はシェル起動エラーになる可能性がある。`git`がない環境、ネットワークが使えない環境へのフォールバックは、`zsh/init.sh` 内にコメントアウトされた旧tarball展開案しかない。

### 5. 全プラグインが起動時ロード

ZiのTurboモード用 `wait` や `lucid` は使われていない。`zshtime` 関数とコメントアウトされた`zprof`は用意されているため、起動速度を改善する場合は、まず5回の起動時間と`zprof`を測定する。

補完、autosuggestions、syntax highlighting、プロンプトは対話開始時に必要だが、`k`、`cd-gitroot`、`zload`などコマンド起点の機能は遅延読み込み候補になり得る。

### 6. fzfの取得が重複する

Ziはfzfリポジトリをシェル統合用にcloneし、`bin/init.sh` もfzfリポジトリまたは同梱tarballからバイナリを用意する。目的は異なるが、同じ上流リポジトリを別々の場所へ保持する構成である。容量や更新経路を単純化する場合は、インストール済みfzfの標準シェル統合ファイルを読む方式を検討する。

## 不要プラグイン候補

設定から未使用と断定できる有効プラグインはない。次は利用実態を確認して判断する。

| 優先度 | 候補 | 判断基準 |
|---|---|---|
| 中 | `supercrabtree/k` | `k`コマンドを使わず、通常の`ls`で足りるなら削除 |
| 中 | `mollifier/cd-gitroot` | 共通alias `cdu`を使わない、または `git rev-parse --show-toplevel` 等で代替するなら削除 |
| 中 | `mollifier/zload` | `gcomp`/`gcomp_all`を使っていないなら、無効化された補完生成機能とともに削除可能 |
| 低 | `b4b4r07/enhancd` | 拡張`cd`を使わず、標準`cd`や別のディレクトリ移動ツールで十分なら削除 |

`zsh-completions`、`zsh-autosuggestions`、`zsh-history-substring-search`、`fast-syntax-highlighting`、`zsh-vcs-prompt`、fzf統合は、対話操作や現在の明示設定へ直接影響するため、現状維持を推奨する。

## 更新・確認方法

- プラグイン一覧: `zi list`
- 更新: `zi update`
- 読み込み情報: `zi report <plugin>`
- 起動時間: `.zshrc` の `zshtime`、または `time zsh -ic exit`
- 詳細プロファイル: `.zshrc` 冒頭と末尾で `zmodload zsh/zprof`、`zprof`
- 構文確認: `zsh -n zsh/.zshrc`
- コマンド確認: `type cd-gitroot zload gomi k vcs_super_info fzf`

初回取得や更新は上流コードを実行するため、一時ホームまたは検証用ユーザーで確認する。実ホームの `$HOME/.zi` を調査目的で削除しない。

## 参照した公式情報

- [Zi](https://github.com/z-shell/zi): プラグインマネージャー本体、由来、セキュリティ方針
- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting): 現在の管理先
- [enhancd](https://github.com/babarot/enhancd): 現在の管理先、fzf等への依存、`cd`の置換動作
- [zsh-gomi](https://github.com/babarot/zsh-gomi): アーカイブ状態、fzf依存
- [gomi](https://github.com/babarot/gomi): 作者が現在開発する後継CLI
- [cd-gitroot](https://github.com/mollifier/cd-gitroot): コマンドと利用方法
- [zload](https://github.com/mollifier/zload): 補完・関数のautoload機能
- [zsh-completions](https://github.com/zsh-users/zsh-completions): 追加補完
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions): 入力候補表示
