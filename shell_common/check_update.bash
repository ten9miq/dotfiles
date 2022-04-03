# tmuxの実行時にdotfileの更新チェックが実行されないようにする処理
if [ -n "$TMUX" ]; then
  #何もしない
  :
else
  # loginの場合OS判定処理開始
  if [ "$(uname)" = 'Darwin' ]; then
    OS='Mac'
  elif [ "$(expr substr $(uname -s) 1 5)" = 'Linux' ]; then
    OS='Linux'
  elif [ "$(expr substr $(uname -s) 1 10)" = 'MINGW32_NT' ]; then
    OS='Cygwin'
  elif [ "$(expr substr $(uname -s) 1 10)" = 'MINGW64_NT' ]; then
    OS='Cygwin'
  else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
  fi

  if [ "${OS}" = 'Linux' ] ; then
    # Linuxの場合~/dotfile/の更新がないかチェックし、更新あればgit pullしてsetup.shを実行する
    if type git > /dev/null 2>&1 && [ -d $HOME/dotfiles ] ; then
      \cd $HOME/dotfiles
      branch_name=`git rev-parse --abbrev-ref HEAD`
      if [ ${branch_name} = 'master' -o ${branch_name} = 'before_zinit' ]; then
        git fetch -p || { \cd - ; return 1; }
        git checkout -q ${branch_name}
        latest_rev=$(git ls-remote origin ${branch_name} | awk '{print $1}')
        current_rev=$(git rev-parse HEAD)
        if [ "$latest_rev" != "$current_rev" ]; then
          # 最新じゃない場合には更新処理を行う
          git reset --hard $(git log --pretty=format:%H | head -1)
          git pull origin ${branch_name}
          ./setup.sh
          read wait # 一時停止
        fi
      else
        echo "dotfile not master branch. current branch is ${branch_name}."
      fi
      \cd -
    fi
  fi
fi
