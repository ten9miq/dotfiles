# dotfiles

Bash、Zsh、Fish、Vim、tmux、SSH、Git などの設定を管理し、ホームディレクトリへ配置するための個人用 dotfiles です。

主に Linux と WSL での利用を想定しています。macOS と Cygwin の判定処理も含まれていますが、環境固有の制約があり、現在の Windows 環境からは動作確認していません。

## セットアップ

> \[!WARNING]
> `setup.sh` は実行したユーザーの `$HOME` にある設定ファイルを変更します。既存の設定と外部取得処理を確認してから実行してください。

必要なコマンドは Bash、Git、および一般的な Unix コマンドです。`bin/init.sh` は `fzf` と `gomi` を取得するため、GitHub へ接続できることに加えて `curl` と `tar` も必要です。

```sh
git clone https://github.com/ten9miq/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash setup.sh
```

`setup.sh` はリポジトリのルートから実行してください。各設定の配置処理は並列で実行され、いずれかが失敗した場合は対象スクリプトの一覧を表示して終了ステータス `1` を返します。

既存ファイルと内容が異なる場合、元のファイルは `$HOME/.bak_dotfiles/` に日時付きで退避されます。元へ戻す場合は、退避されたファイル名の日時部分を取り除き、元の配置先へコピーしてください。

## 配置される設定

| ディレクトリ    | 主な配置先・内容                                       |
| --------------- | ------------------------------------------------------ |
| `bash/`         | `~/.bashrc`、`~/.bash_profile`、補完設定               |
| `zsh/`          | `~/.zshrc`、`~/.zprofile`、補完設定                    |
| `fish/`         | `~/.config/fish/`                                      |
| `shell_common/` | `~/.config/shell_common/` に配置する Bash/Zsh 共通設定 |
| `vim/`          | `~/.vimrc`、`~/.gvimrc`、`~/.vim/`                     |
| `tmux/`         | Linux/WSL 向けの `~/.tmux.conf` と関連設定             |
| `ssh/`          | Linux/WSL 向けの `~/.ssh/config`                       |
| `git/`          | `~/.gitconfig` とローカル設定用 `~/.gitconfig.local`   |
| `bin/`          | `~/bin/` の補助コマンド、`fzf`、`gomi`                 |
| `etc/`          | `~/.inputrc`、`~/.toprc` など                          |
| `windows/`      | Windows 用のレジストリ設定（`setup.sh` の対象外）      |

Zsh のプラグインは初回起動時、Vim のプラグインは初回利用時に追加の外部取得が発生する場合があります。

## ローカル設定

端末固有のパス、環境変数、秘密情報は追跡対象の設定ファイルへ直接追加せず、次のローカルファイルへ分離します。

| ファイル             | 用途                         |
| -------------------- | ---------------------------- |
| `~/.shellrc.local`   | Bash と Zsh の共通設定       |
| `~/.bashrc.local`    | Bash 固有の設定              |
| `~/.zshrc.local`     | Zsh 固有の設定               |
| `~/.gitconfig.local` | Git のユーザー情報と認証方式 |

詳しくは [ローカルのシェル設定](docs/local-shell-settings.md) を参照してください。秘密情報を置くファイルは、所有者以外から読めない権限にしてください。

## ドキュメント

* [Vim プラグイン構成](docs/vim-plugins.md)

* [Zsh プラグイン構成](docs/zsh-plugins.md)

* [リポジトリ構成・設定監査](docs/repository-audit.md)

* [AI 開発ガイド](docs/ai-development-guide.md)

## 変更時の確認

シェルファイルを変更した場合は、少なくとも Bash の構文確認を行います。ShellCheck が利用できる環境では、あわせて静的解析を実行します。

```sh
bash -n path/to/file.sh
shellcheck path/to/file.sh
```

配置処理の確認に実際のホームディレクトリは使わず、一時ディレクトリを `$HOME` に指定した隔離環境で検証してください。
