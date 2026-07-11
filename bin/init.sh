#!/bin/bash
THIS_SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
# PROJECT_PATHなどのsetup時の環境変数の読み込みを行う
source $THIS_SCRIPT_PATH/../setup_env.sh

fzf_extract=0 # fzfはデフォルトではDLを行う
copy_target="$HOME/bin"
mkdir -p $copy_target
# 指定のファイル以外をコピーしてかつ、配下のディレクトリをコピーする
while read -r find_path;
do
  if [ $(basename $find_path) == ".fzf.tgz" ]; then
    fzf_extract=1
  else
    # 本スクリプトのパスをfindで取得したパス文字列から削除する
    relative_path=${find_path##$THIS_SCRIPT_PATH/}
    # コピー先のディレクトリがなければ作成する
    mkdir -p $copy_target/$(dirname $relative_path);
    cp $find_path $copy_target/$relative_path;
  fi
done < <(find $THIS_SCRIPT_PATH -type f -not -name '*.sh')
chmod -R +x $copy_target
ln -fs extract $copy_target/ext

# gomiの最新版をGitHub Releasesからインストールする
install_latest_gomi() {
  local platform
  local tarball
  local tmp_dir
  local staged_binary

  platform="$(uname -s) $(uname -m)"
  case "$platform" in
    'Darwin arm64')  tarball='gomi_Darwin_arm64.tar.gz' ;;
    'Darwin x86_64') tarball='gomi_Darwin_x86_64.tar.gz' ;;
    'Linux aarch64' | 'Linux arm64') tarball='gomi_Linux_arm64.tar.gz' ;;
    'Linux x86_64' | 'Linux amd64')  tarball='gomi_Linux_x86_64.tar.gz' ;;
    *)
      skip_print "gomi does not provide a prebuilt binary for $platform"
      return 0
      ;;
  esac

  has curl || { error_print 'gomi installation requires curl'; return 1; }
  has tar || { error_print 'gomi installation requires tar'; return 1; }

  tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/gomi-install.XXXXXX")" || return 1
  staged_binary="$copy_target/.gomi.new.$$"

  if ! curl -fsSL "https://github.com/babarot/gomi/releases/latest/download/$tarball" \
      | tar -xzf - -C "$tmp_dir" || [ ! -f "$tmp_dir/gomi" ]; then
    error_print 'failed to download or extract the latest gomi release'
    \rm -rf "$tmp_dir"
    return 1
  fi

  \cp "$tmp_dir/gomi" "$staged_binary" && chmod 0755 "$staged_binary" &&
    \mv -f "$staged_binary" "$copy_target/gomi" || return 1
  ok_print "gomi installed: $("$copy_target/gomi" --version | head -n 1)"
  \rm -rf "$tmp_dir"
}

install_latest_gomi || exit 1

if [ $fzf_extract == 1 ]; then
  tar -xf $THIS_SCRIPT_PATH/.fzf.tgz -C $copy_target
else
  if [ -d $copy_target/.fzf ]; then
    if type git > /dev/null 2>&1 ; then
      \cd $copy_target/.fzf
      branch_name=`git rev-parse --abbrev-ref HEAD`
      if [ ${branch_name} = 'master' -o ${branch_name} = 'before_zinit' ]; then
        git fetch -p || { \cd - >/dev/null ; return 1; }
        git checkout -q ${branch_name}
        latest_rev=$(git ls-remote origin ${branch_name} | awk '{print $1}')
        current_rev=$(git rev-parse HEAD)
        if [ "$latest_rev" != "$current_rev" ]; then
          # 最新じゃない場合には更新処理を行う
          git reset --hard $(git log --pretty=format:%H | head -1)
          git pull origin ${branch_name}
        fi
      else
        echo "dotfile not master branch. current branch is ${branch_name}."
      fi
      \cd - >/dev/null
    fi
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git $copy_target/.fzf
    $copy_target/.fzf/install --bin
  fi
fi
ln -fs .fzf/bin/fzf $copy_target/fzf

exit $?
