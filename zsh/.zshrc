# Soource global definitions
if [ -f /etc/zshrc ]; then
	. /etc/zshrc
fi

# zshの起動処理の速度調査の実行
# zmodload zsh/zprof && zprof
zshtime(){
  for i in $(seq 1 5); do time zsh -ic exit; done
}

# -----------------------------
# Lang
# -----------------------------
#export LANG=ja_JP.UTF-8
#export LESSCHARSET=utf-8

# -----------------------------
# default keybind
# -----------------------------
# bindkey -d  # いったんキーバインドをリセット
bindkey -e  # emacsモードで使う
# bindkey -a  # vicmdモード
# bindkey -v # viinsモード

# -----------------------------
# zinitによるplugin設定
# -----------------------------
zi_home="${HOME}/.zi"
if [ ! -f ${zi_home}/bin/zi.zsh ]; then
  git clone --depth=1 https://github.com/z-shell/zi.git ${zi_home}/bin
fi

source "${zi_home}/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# 補完の強化。
zi ice blockf depth'1'; zi light zsh-users/zsh-completions
# 入力中の文字に応じて灰色の文字でコマンド候補を表示してくれる
zi ice depth'1'; zi light zsh-users/zsh-autosuggestions
# コマンド入力中に上キーや下キーを押した際の履歴の検索を使いやすくする
zi ice if"[[ __zsh_version > 4.3 ]]"; zi light zsh-users/zsh-history-substring-search
# コマンドのシンタックスハイライト
zi ice depth'1'; zi light zdharma-continuum/fast-syntax-highlighting
# cdコマンドをfzfなどと組み合わせ便利にする
zi ice silent pick"init.sh" depth'1'; zi load "babarot/enhancd"
# 補完の動的再読み込みを行う
zi ice depth'1'; zi light mollifier/zload
# 現在のパスのgitの情報を表示するプラグイン
zi ice depth'1'; zi light yonchu/zsh-vcs-prompt
# コマンドの-hで表示されるもので補完ファイルを生成する
export GENCOMPL_FPATH=$HOME/.zsh/complete
# zi ice has'python'; zi light RobSis/zsh-completion-generator
# fzfの補完とキーバインドを追加
zi ice multisrc"shell/{completion,key-bindings}.zsh" \
  id-as"junegunn/fzf_completions" pick"/dev/null" depth'1';
zi light junegunn/fzf

# -----------
# plugin設定
# -----------

# zdharma/fast-syntax-highlightingの色をカスタマイズ
typeset -A FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path]='fg=211'
FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}path-to-dir]='fg=211,underline'

# -----------------------------
# General
# -----------------------------
# エディタをvimに設定
export EDITOR=vim
# 色を使用
autoload -Uz colors ; colors
autoload -Uz add-zsh-hook

# Ctrl+Dでログアウトしてしまうことを防ぐ
#setopt IGNOREEOF
# Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt no_flow_control
# zsh 5.0.2では下記を記載しないと無効にできない
stty stop undef
stty start undef

# ビープ音を鳴らさないようにする
setopt no_beep
# カッコの対応などを自動的に補完する
setopt auto_param_keys
# bgプロセスの状態変化を即時に知らせる
setopt notify
# 8bit文字を有効にする
setopt print_eight_bit
# 終了ステータスが0以外の場合にステータスを表示する
setopt print_exit_value
# 上書きリダイレクトの禁止 echo foo > hoge ですでにhogeが存在する場合､書き込まないでエラーを吐く
setopt no_clobber
# 各コマンドが実行されるときにパスをハッシュに入れる
#setopt hash_cmds
# 範囲指定できるようにする
# 例 : mkdir {1..3} で フォルダ1, 2, 3を作れる
setopt brace_ccl
# コマンドラインがどのように展開され実行されたかを表示するようになる
# なにかしらの操作をするたび、あらゆる動作ログが出る
# setopt xtrace

#
## 実行したプロセスの消費時間が3秒以上かかったら
## 自動的に消費時間の統計情報を表示する。
REPORTTIME=3

## 「/」も単語区切りとみなす。
WORDCHARS=${WORDCHARS:s,/,,}

# -----------------------------
# Prompt
# -----------------------------
# %M    ホスト名
# %m    ホスト名
# %d    カレントディレクトリ(フルパス)
# %~    カレントディレクトリ(フルパス2)
# %C    カレントディレクトリ(相対パス)
# %c    カレントディレクトリ(相対パス)
# %n    ユーザ名
# %#    ユーザ種別
# %?    直前のコマンドの戻り値
# %D    日付(yy-mm-dd)
# %W    日付(mm/dd/yy)
# %w    日付(day dd)
# %*    時間(hh:flag_mm:ss)
# %T    時間(hh:mm)
# %t    時間(hh:mm(am/pm))

#色の定義
#黒赤緑黄青紫水白
local BLACK=$'%{\e[1;30m%}'
local RED=$'%{\e[1;31m%}'
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local PURPLE=$'%{\e[1;35m%}'
local LIGHTBLUE=$'%{\e[1;36m%}'
local WHITE=$'%{\e[1;37m%}'
local DEFAULT=$'%{\e[1;m%}'

# zshのの利用可能な色の一覧表示
zsh_color(){
  for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15  ] && echo;done;echo"]"
}


# Prompt内で変数展開・コマンド置換・算術演算を実行する
setopt prompt_subst
# コピペしやすいようにコマンド実行後は右プロンプトを消す。
# setopt transient_rprompt

[ -f ~/.config/shell_common/prompt.bash ] && source ~/.config/shell_common/prompt.bash

PROMPT="%F{170}%n%f%F{027}@%f%F{green}%5m%f%F{039} $(eval 'echo ${MYPSDIR}') %f
%F{099}[${SHLVL}]%f%F{245}[%D{%y/%m/%d %H:%M:%S}]%f $ "

# Gitリポジトリ配下の場合にプロンプト右にGit上のステータスを表示するプラグインの設定
# 全角文字の一部がzshで表示するときに幅が違うために入力箇所がずれる事象が発生したので記号を変更
ZSH_VCS_PROMPT_AHEAD_SIGIL='↑'
ZSH_VCS_PROMPT_BEHIND_SIGIL='↓'
ZSH_VCS_PROMPT_UNTRACKED_SIGIL='⋯'
ZSH_VCS_PROMPT_STAGED_SIGIL='〓'
if [ $(uname -r | grep -i microsoft) ] ; then
  # wsl用
  ZSH_VCS_PROMPT_UNSTAGED_SIGIL='✚ '
  ZSH_VCS_PROMPT_STASHED_SIGIL='◌ '
  ZSH_VCS_PROMPT_CLEAN_SIGIL='✓ '
  ZSH_VCS_PROMPT_CONFLICTS_SIGIL='✖ '
else
  ZSH_VCS_PROMPT_UNSTAGED_SIGIL='✚'
  ZSH_VCS_PROMPT_STASHED_SIGIL='◌'
  ZSH_VCS_PROMPT_CLEAN_SIGIL='✔'
  ZSH_VCS_PROMPT_CONFLICTS_SIGIL='✖'
fi

## Git without Action.
ZSH_VCS_PROMPT_GIT_FORMATS='(%{%B%F{yellow}%}#s%{%f%b%})' # VCS name
ZSH_VCS_PROMPT_GIT_FORMATS+='[%{%B%F{magenta}%}#b%{%f%b%}' # Branch name
ZSH_VCS_PROMPT_GIT_FORMATS+='#c#d|' # Ahead and Behind
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{green}%}#e%{%f%b%}' # Staged
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{red}%}#f%{%f%b%}' # Conflicts
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{red}%}#g%{%f%b%}' # Unstaged
ZSH_VCS_PROMPT_GIT_FORMATS+='#h' # Untracked
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{033}%}#i%{%f%b%}' # Stashed
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%B%F{green}%}#j%{%f%b%}]' # Clean

RPROMPT='$(vcs_super_info)'

# -----------------------------
# History
# -----------------------------
# 基本設定
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

# ヒストリーに重複を表示しない
setopt histignorealldups
# 他のターミナルとヒストリーを共有
setopt share_history
# すでにhistoryにあるコマンドは残さない
setopt hist_ignore_all_dups
# historyに日付を表示
alias h='fc -lt '%F %T' 1'
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
# 履歴をすぐに追加する
setopt inc_append_history
# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
# setopt hist_verify
#余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks
# historyコマンドは残さない
setopt hist_save_no_dups

# -----------------------------
# functions
# -----------------------------
# 関数の読み込み
[ -f ~/.config/shell_common/functions.bash ] && source ~/.config/shell_common/functions.bash

# 補完ファイルの再読み込みプラグインの読み込み
gcomp(){
  gencomp $@
  zload $GENCOMPL_FPATH/_*
}

gcomp_all(){
  for p in $path; do command -p ls $p; done |\
      uniq |\
      { while read c; do gencomp $c; done }
  zload $GENCOMPL_FPATH/_*
}

# -----------------------------
# Completion
# -----------------------------
if [ -e ~/.zsh/complete/  ]; then
    fpath=(~/.zsh/complete $fpath)
fi
# 自動補完を有効にする
# これはほかの補完ファイルを読み込んだ後に実行しないと意味がない
if [[ $(uname -r) == *microsoft* || $EUID -eq 0 ]]; then
  # wslの場合あまりにも遅いので補完ファイルのセキュアリードオプションを無効化する
  # また、rootで.zshrc使い回す場合にも問題となるため、こちらのオプションを使う
  autoload -Uz compinit ; compinit -C
else
  autoload -Uz compinit ; compinit
fi

# kubectlの補完読み込み
if (type kubectl &> /dev/null) ;then
  source <(kubectl completion bash)
fi

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word
# コマンドミスを修正
setopt correct
# コマンドライン上の引数など全てのスペルチェックをする
setopt correct_all
# correctでの修正候補の例外として設定する
CORRECT_IGNORE='_*' # コマンド名として_で始まる補完関数を修正候補外にする
CORRECT_IGNORE_FILE='.*' # ファイル名としてドットファイルを修正候補外にする
# 補完候補が複数ある時、一覧表示 (auto_list) せず、すぐに最初の候補を補完する
setopt menu_complete # 強制で最初のが選択されるのが使いづらいので無効化
# 補完候補をできるだけ詰めて表示する
setopt list_packed
# 補完候補にファイルの種類も表示する(ls -Fの記号)
setopt list_types
# --prefix=/usr などの = 以降でも補完
setopt magic_equal_subst
## カッコの対応などを自動的に補完
setopt auto_param_keys
## 補完時にヒストリを自動的に展開する。
setopt hist_expand
## 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs
# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments
# 明確なドットの指定なしで.から始まるファイルをマッチ
setopt globdots
# aliasを展開して補完を行う
setopt no_complete_aliases
# 補完時に文字列末尾へカーソル移動
setopt always_to_end
# aliasが展開されていない状態で補完を行う
# setopt complete_aliases
# グロブ表現を解釈してファイルが存在しない場合のエラーを抑止する
setopt nonomatch

# コマンドが間違えている時の指摘時の表示を変更
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [No/yes/abort/edit] => "

# 補完キー連打で順に補完候補を自動で補完
# select=2: 補完候補を一覧から選択する。
#           ただし、補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*' menu select=2
# 補完候補を表示したときに続けてキーを入力するとインタラクティブに絞り込む
# setopt menu_completeが必要
# zstyle ':completion:*' menu select interactive
# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true
# 補完候補にLS_COLORSと同じ色をつける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# 大文字・小文字を区別しない(大文字を入力した場合は区別する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true
# 補完候補の候補のセパレートを変更
zstyle ':completion:*' list-separator '-->'
# 詳細な情報を使う。
zstyle ':completion:*' verbose yes
# 補完するときに、ただ補完候補を出すだけでなく、コマンドの文脈に応じて何の補完をするか表示してくれます
# _complete - 普通の補完関数
# _approximate - ミススペルを訂正した上で補完を行う。
# _match - *などのグロブによってコマンドを補完できる(例えばvi* と打つとviとかvimとか補完候補が表示される)
# _expand - グロブや変数の展開を行う。もともとあった展開と比べて、細かい制御が可能
# _history - 履歴から補完を行う。_history_complete_wordから使われる
# _prefix - カーソルの位置で補完を行う
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
# 補完時のメッセージの色設定
zstyle ':completion:*:descriptions' format $GREEN'completing %B%d%b'$DEFAULT
zstyle ':completion:*:messages' format $LIGHTBLUE'%d'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
## 補完方法毎にグループ化する。
### 補完方法の表示方法
###   %B...%b: 「...」を太字にする。
###   %d: 補完方法のラベル
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
# cd ../の時に今いるディレクトリを補完候補から外す
zstyle ':completion:*' ignore-parents parent pwd ..

# 候補を更新日時でソートする デフォルトはアルファベット順にソート
# zstyle ':completion:*' file-sort modification
# 補完時にディレクトリを先に表示する
zstyle ':completion:*' list-dirs-first true
# cd時の補完の並び
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
#kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# -----------------------------
# KeyBind
# -----------------------------
bindkey '\C-j' backward-word
bindkey '\C-g' forward-word
# esc+hで単語単位での削除
bindkey 'h' vi-backward-kill-word

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "\e[Z" reverse-menu-complete # reverse menu completion binded to Shift-Tab

# 補完候補のメニュー選択で、矢印キーの代わりにhjklで移動出来るようにする。
zmodload zsh/complist
#bindkey -M menuselect '^i' vi-backward-char # 左
bindkey -M menuselect '^h' vi-backward-char # 左 これが動作しない
bindkey -M menuselect '^j' vi-down-line-or-history # 下
bindkey -M menuselect '^k' vi-up-line-or-history # 上
bindkey -M menuselect '^l' vi-forward-char # 右

bindkey -M menuselect '^n' vi-forward-char # 右
bindkey -M menuselect '^p' vi-backward-char # 左

bindkey -M menuselect '^r' history-incremental-search-forward # 補完候補内インクリメンタルサーチ

# ctrl+hでmenuselectで左に動けず、削除をしてしまう問題への対策を研究中
# tty -s && stty erase undef #ttyのctrl+hを無効化 その代わりvim上でbackspaceが効かない
# bindkey -r '^h' # zshのctrl+hを無効化

# -----------------------------
# ディレクトリ移動関係
# -----------------------------
# パスの最後のスラッシュを削除しない
setopt noautoremoveslash
# cdで移動してもpushdと同じようにディレクトリスタックに追加する。
setopt auto_pushd
# ディレクトリスタックへの追加の際に重複させない
setopt pushd_ignore_dups
# ディレクトリ名の入力のみで移動する
setopt auto_cd
#移動先がシンボリックリンクならば実際のディレクトリに移動する
setopt chase_links
#パスに..が含まれる シンボリックリンクではなく実際のディレクトリに移動
setopt chase_dots
#引数なしでpushdするとpushd $HOMEとして実行
setopt pushd_to_home
# cdで移動後に省略lsを実行する(10行を超える内容の時lsの表示内容を前後10行だけに絞る)
chpwd() { ls_abbrev }

# -----------------------------
# alias
# -----------------------------
# aliasの読み込み
[ -f ~/.config/shell_common/aliases.bash ] && source ~/.config/shell_common/aliases.bash

# それぞれのaliasに対応
# setopt no_complete_aliasesでalisaを展開したあととして補完が対応できるはずだが
# alias sg='sudo git -c xxxx'を展開すると-あとのパラメータの補完ができない
# そのためaliasに関数を紐付けることで補完が効くようにする
# 現在のユーザーがrootでない場合にのみ実行する、rootは不要なコマンドであるし、ここでエラーが発生するため
if [[ $EUID -ne 0 ]]; then
  compdef sudo_git=git
fi

# zshのglobal alias
alias -g L='| less'
alias -g H='| head -n 20'
alias -g T='| tail -n 20'
alias -g D="sed -n '1,\$p' " # ファイルの指定範囲行を抽出(巨大なファイルから取り出す際に)
alias -g J='| python -c "import json;print json.dumps(json.loads(raw_input()),ensure_ascii=False,indent=4,separators=('\'','\'', '\'': '\''))"'
alias -g G='| grep'
alias -g GI='| grep -ri' # -r:ディレクトリ内も検索対象とする -i:大文字と小文字を区別せず検索する
alias -g S='sudo '
alias -g E='sudoE '
alias -g R='rsync '
# WSLとwindowsのユーザ名が違う場合に対応
U_PATH="/mnt/c/Users/$(cmd.exe /C 'echo %USERNAME%' 2>/dev/null | tr -d '\r')/Downloads"
alias -g U="$U_PATH"
alias -g V='| tovim'
alias -g Z='| fzf'
alias -g W='| wc -l' # -l:行単位で数える
alias -g X='| xargs -i cmd {}' # -i:標準入力を{}と箇所と置換し､個々にcmdの箇所のコマンドを実行する
alias -g F='find "*" '
alias -g FP='find "*" -print0 ' # -print0:標準出力をNULL文字で区切る
alias -g X='| xargs --no-run-if-empty -i echo {}' # -i:標準入力を{}の箇所と置換し､個々にcmdの箇所のコマンドを実行する
alias -g XP='| xargs -L 50 -P 4 -0 --no-run-if-empty -i cp {}'
# argument list too long のエラーが出る場合にこれでコマンドを並列実行する
# xargsの並列実行について https://tagomoris.hatenablog.com/entry/20110513/1305267021
# -L max-lines:コマンドラインごとに最大で最大行数の非空白の入力行を使用する
# -P max-procs:一度に最大max-procsプロセスまで実行します。
#    デフォルトは1です。max-procsが0の場合、xargsはできるだけ多くのプロセスを一度に実行します。
alias -g FX='find "*" -print0 | xargs -L 50 -P 4 -0 --no-run-if-empty -i cp {}' # -0:入力を空白や改行ではなくNULL文字で区切る

# zshのcompinit時のパーミッションのエラー修復
compinit_fix(){
  compaudit | xargs chmod go-w
}

# グローバルエイリアスを展開する
# http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
globalias() {
  if [[ $LBUFFER =~ '[A-Z0-9]+$' ]]; then
    zle _expand_alias
    # zle expand-word
  fi
  zle self-insert
}
zle -N globalias
bindkey " " globalias

# zshの起動処理の速度調査のスクリプト実行時に表示する設定
if (type zprof &> /dev/null) ;then
  zprof | less
fi

# setup.sh による .zshrc の上書き対象外に置くローカル設定。
# .shellrc.local は Bash/Zsh 共通、.zshrc.local は Zsh 固有の設定に使用する。
[[ -r "$HOME/.shellrc.local" ]] && . "$HOME/.shellrc.local"
[[ -r "$HOME/.zshrc.local" ]] && . "$HOME/.zshrc.local"
