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

if [ $fzf_extract == 1 ]; then
  tar -xf $THIS_SCRIPT_PATH/.fzf.tgz -C $copy_target
else
  git clone --depth 1 https://github.com/junegunn/fzf.git $copy_target/.fzf
  $copy_target/.fzf/install --bin
fi
ln -fs $copy_target/.fzf/bin/fzf ~/bin/fzf

exit $?
