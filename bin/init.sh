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
ln -fs $copy_target/extract $copy_target/ext

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
ln -fs $copy_target/.fzf/bin/fzf $copy_target/fzf

exit $?
