#!/bin/bash

# エラートラップ開始
../error_trap.sh

execDir=$(cd $(dirname $0); pwd)
copyToPath="${execDir}/zinit.tgz/plugins/"
mkdir -p "${copyToPath}" # 存在しない時フォルダ作成
echo "コードの実行場所:${execDir}"

gzDir="$HOME/.zinit/plugins/"
[ ! -d $gzDir ] && echo "$HOME/.zinitフォルダがない" && exit 1;
\cd $gzDir

for dir in `find $gzDir -maxdepth 1 -type d`
do
  echo "対象:${dir}"
  baseDir=`basename $dir`
  echo "basename:${baseDir}"
  if [ $baseDir != `basename $gzDir`  ] ; then
    tar -czf "${copyToPath}/${baseDir}.tgz" $baseDir
  fi
  echo "------------------------"
done

# 存在しない時フォルダ作成
\cd $HOME/.zinit/
mkdir -p "${execDir}/zinit.tgz/"
tar -czf "${execDir}/zinit.tgz/bin.tgz" "./bin/"
#read -p " Enter to close:" # 一時停止
