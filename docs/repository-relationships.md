# リポジトリの関係図

このリポジトリは、ルートの `setup.sh` から各設定ディレクトリの初期化スクリプトを並列実行し、設定ファイルを `$HOME` 以下へ配置する構成になっている。

## セットアップ時の配置関係

```mermaid
flowchart TD
    user["利用者<br/>bash setup.sh"] --> setup["setup.sh<br/>各 *.sh を並列実行"]
    setup --> env["setup_env.sh<br/>共通関数・OS 判定・バックアップ付きコピー"]
    env --> trap["error_trap.sh<br/>エラー処理"]

    setup --> bash["bash/init.sh"]
    setup --> zsh["zsh/init.sh"]
    setup --> fish["fish/init.sh"]
    setup --> common["shell_common/init.sh"]
    setup --> vim["vim/init.sh"]
    setup --> tmux["tmux/init.sh"]
    setup --> ssh["ssh/init.sh"]
    setup --> git["git/init.sh"]
    setup --> bin["bin/init.sh"]
    setup --> etc["etc/init.sh"]

    env -. "各 init.sh が読み込む" .-> bash
    env -. "各 init.sh が読み込む" .-> zsh
    env -. "各 init.sh が読み込む" .-> fish
    env -. "各 init.sh が読み込む" .-> common
    env -. "各 init.sh が読み込む" .-> vim
    env -. "各 init.sh が読み込む" .-> tmux
    env -. "各 init.sh が読み込む" .-> ssh
    env -. "各 init.sh が読み込む" .-> git
    env -. "各 init.sh が読み込む" .-> bin
    env -. "各 init.sh が読み込む" .-> etc

    bash --> home_bash["$HOME<br/>.bashrc・.bash_profile・.bash/"]
    zsh --> home_zsh["$HOME<br/>.zshrc・.zprofile・.zsh/"]
    fish --> home_fish["$HOME/.config/fish/"]
    common --> home_common["$HOME/.config/shell_common/"]
    vim --> home_vim["$HOME<br/>.vimrc・.gvimrc・.vim/"]
    tmux --> home_tmux["$HOME<br/>.tmux.conf・.tmux/<br/>Linux / WSL のみ"]
    ssh --> home_ssh["$HOME/.ssh/config<br/>Linux / WSL のみ"]
    git --> home_git["$HOME<br/>.gitconfig・.gitconfig.local"]
    bin --> home_bin["$HOME/bin/<br/>補助コマンド・fzf・gomi"]
    etc --> home_etc["$HOME<br/>.inputrc・.toprc"]

    env --> backup["$HOME/.bak_dotfiles/<br/>差分がある既存ファイルを退避"]
    windows["windows/<br/>Windows レジストリ設定"] -. "setup.sh の対象外" .-> manual["手動適用"]
    bin --> github["GitHub Releases / Repository<br/>gomi・fzf を外部取得"]
```

実線は実行または配置、破線は読み込みや対象外の関係を表す。`setup.sh` は `windows/` を除く対象ディレクトリの `*.sh` を並列実行し、いずれかが失敗した場合は失敗したスクリプトを列挙して終了する。

## 配置後の読み込み関係

```mermaid
flowchart LR
    bash_profile["~/.bash_profile"] --> common_env["~/.config/shell_common/env.bash"]
    bash_profile --> common_update["~/.config/shell_common/check_update.bash"]
    bash_profile --> common_startup["~/.config/shell_common/startup.bash"]
    bash_profile --> bashrc["~/.bashrc"]

    bashrc --> common_prompt["~/.config/shell_common/prompt.bash"]
    bashrc --> common_aliases["~/.config/shell_common/aliases.bash"]
    bashrc --> common_functions["~/.config/shell_common/functions.bash"]
    bashrc --> shell_local["~/.shellrc.local"]
    bashrc --> bash_local["~/.bashrc.local"]

    zprofile["~/.zprofile"] --> common_env
    zprofile --> common_update
    zprofile --> common_startup

    zshrc["~/.zshrc"] --> common_prompt
    zshrc --> common_aliases
    zshrc --> common_functions
    zshrc --> shell_local
    zshrc --> zsh_local["~/.zshrc.local"]

    fish_config["~/.config/fish/config.fish"] --> fish_aliases["aliases.fish"]
    fish_config --> fish_env["env.fish<br/>ログインシェル時"]

    gitconfig["~/.gitconfig"] --> git_local["~/.gitconfig.local"]

    vimrc["~/.vimrc"] --> dein["dein.vim"]
    dein --> dein_toml["~/.vim/rc/dein.toml"]
    dein --> dein_lazy["~/.vim/rc/dein_lazy.toml"]
    dein --> plugins["GitHub 上の Vim プラグイン"]
```

Bash と Zsh は `shell_common/` の配置物を共有する。追跡対象外の `*.local` ファイルは、端末固有のパス、環境変数、認証方式などを共有設定から分離するために使う。Fish は独立した設定ツリーを読み込み、Git は `.gitconfig.local`、Vim は `dein.vim` の TOML 定義をそれぞれ参照する。
