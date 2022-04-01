#!/bin/bash
export PROJECT_PATH=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
source $PROJECT_PATH/error_trap.sh

true=0
false=1

shopt -s expand_aliases # bashスクリプト内でaliasを使うためのオプション
# alias cp='cp -b --suffix=_$(date +%Y%m%d_%H%M%S)'
alias cp='cpBkMv'
cpBkMv() {
  while (( $# > 0 ))
  do
    case $1 in
      -R | -r | --recursive)
        is_rec=1
      ;;
      -*)
        echo "Illegal option '$1'" 1>&2
        exit 1
      ;;
      *)
        if [[ -n "${src-}" ]] && [[ -n "${target-}" ]]; then
          echo "Too many arguments." 1>&2
          exit 1
        elif [[ -n "${src-}" ]]; then
          target="$1"
        else
          src="$1"
        fi
      ;;
    esac
    shift
  done

  if [[ -z "${src-}" ]]; then
    echo "'src' is required." 1>&2
    exit 1
  fi

  if [[ -z "${target-}" ]]; then
    echo "'target' is required." 1>&2
    exit 1
  fi
  backup_cp(){
    source_name=${1##*/} # basename
    target_dir=${2%/*} # dirname
    bak_path="$HOME/.bak_dotfiles/"
    if [ -e $target_dir/$source_name ]; then
      diff -s $1 $target_dir/$source_name >/dev/null 2>&1
      if [ $? -eq 1 ]; then
        # 差分あり
        mkdir -p $bak_path
        DATE=$(date +%Y%m%d_%H%M%S)
        \cp -f -b --suffix=_$DATE $1 $2  && \mv ${target_dir}/${source_name}_$DATE $bak_path
      fi
    else
      # 存在しない
      \cp $1 $2
    fi
  }

  if [ ${is_rec-0} -eq 1 ]; then
    # -rオプションあり
    find $src -type f | while read -r find_path;
    do
      # 本スクリプトのパスをfindで取得したパス文字列から削除する
      relative_path=${find_path##$THIS_SCRIPT_PATH/}
      # コピー先のディレクトリがなければ作成する
      mkdir -p ${target%/*}/${relative_path%/*} # %/* = dirname
      backup_cp $find_path ${target%/*}/$relative_path
    done
  else
    backup_cp $src $target
  fi
  unset src
  unset target
  unset is_rec
}

# プロセスが実行中であるか
hasprocess() {
  if is_osx; then
    ps -fU$USER | grep $1 | grep -v grep > /dev/null 2>&1 && return $true || return $false
  else
    ps aux | grep $1 | grep -v grep > /dev/null 2>&1 && return $true || return $false
  fi
}

# file が存在し、かつそのサイズが 0 より大きければ真となります。
hasfile() {
  [[ -s $1 ]] && return $true || return $false
}

# 環境変数にあるか判定
hasenv() {
  [[ -z $1 ]] && return $false || return $true
}

# aliasに存在するか
hasalias() {
  : ${1:?}
  alias $1 && return $true || return $false
}

# パスに追加する
exist_expath() {
  [ -d $1 ] && expath $1
}

# パス追加処理
expath() {
  : ${1:?}
  export PATH=$1:$PATH
}

# 小文字化
lower() {
  printf "$1\n" | tr '[A-Z]' '[a-z]'
}

# パスの削除
rmpath() {
  export PATH=$(echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//')
}

# 実行OSの判定処理開始 小文字でOS名を返す
os_type() {
  if [[ "$(uname)" == 'Darwin' ]]; then
    lower 'Osx'
  elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
    if [ $(uname -r | grep -i microsoft) ] ; then
      lower 'WSL'
    else
      lower 'Linux'
    fi
  elif [[ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]]; then
    lower 'Cygwin'
  elif [ "$(expr substr $(uname -s) 1 10)" = 'MINGW64_NT' ]; then
    lower 'Cygwin'
  else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
  fi
}

is_osx() {
  [[ `os_type` == "osx" ]] && return $true || return $false
}

is_linux() {
  [[ `os_type` == "linux" ]] && return $true || return $false
}

is_wsl() {
  [[ `os_type` == "cygwin" ]] && return $true || return $false
}

is_cygwin() {
  [[ `os_type` == "cygwin" ]] && return $true || return $false
}

# コマンドが存在するかチェック 処理部分
is_exists() {
  type $1 > /dev/null 2>&1
  return $?
}

# コマンドが存在するかチェック
has() {
  is_exists "$@"
}

########################################################
# 動作中のログを表示する際に色をつけて表示する
########################################################
# 水色
run_print () {
  printf "\e[36m run\t: $1  \e[0m\n"
}

# 黄色
skip_print() {
  printf "\e[33m skip\t: $1  \e[0m\n"
}

# 紫色
log_print() {
  printf "\e[35m log\t: $1  \e[0m\n"
}

# 緑色
ok_print() {
  printf "\e[32m ok\t: $1  \e[0m\n"
}
# 赤色
error_print() {
  printf "\e[31m fail\t: $1  \e[0m\n"
}


logo='
    _______   ______   .___________. _______  __   __       _______     _______.
   |       \ /  __  \  |           ||   ____||  | |  |     |   ____|   /       |
   |  .--.  |  |  |  | `---|  |----`|  |__   |  | |  |     |  |__     |   (----`
   |  |  |  |  |  |  |     |  |     |   __|  |  | |  |     |   __|     \   \
   |  `--`  |  `--`  |     |  |     |  |     |  | |  `----.|  |____.----)   |
   |_______/ \______/      |__|     |__|     |__| |_______||_______|_______/
'

logo () {
  printf "$logo\n\n"
}
