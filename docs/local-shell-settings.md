# ローカルのシェル設定

`setup.sh` は `bash/.bashrc` と `zsh/.zshrc` を `$HOME` へコピーするため、
それらの末尾へ直接追加した設定は次回の実行で失われる。

`setup.sh` のコピー対象外である `$HOME` 直下に、端末固有または自動追加された設定を置く。

| ファイル | 用途 |
| --- | --- |
| `~/.shellrc.local` | Bash と Zsh の両方で読む設定。`export` など両シェルで使える構文だけを置く。 |
| `~/.bashrc.local` | Bash だけで読む設定。 |
| `~/.zshrc.local` | Zsh だけで読む設定。 |

たとえば、ツールが追加する環境変数は `~/.shellrc.local` に置く。

```sh
export EXAMPLE_TOKEN='...'
export PATH="$HOME/example/bin:$PATH"
```

これらのファイルは `.bashrc` と `.zshrc` の最後に読み込むため、リポジトリ側の既定値をローカル設定で上書きできる。機密値を置く場合は、所有者以外に読めない権限にする。
