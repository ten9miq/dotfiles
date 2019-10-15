#!/bin/bash
# setup時に必要な環境変数やエラートラップの実行
source ./setup_env.sh
logo

# 並列実行できるもの
dists=('vim' 'zsh' 'bash' 'shell_common' 'tmux' 'ssh' 'bin' 'git' 'etc' 'fish')
for e in ${dists[@]}; do
  for script in $PROJECT_PATH/$e/*.sh; do
    if [ -f $script ]; then
      run_print $script
      bash $script && ok_print "$script" || error_print "$script" &
    else
      continue
    fi
  done
done

# 終了を待つ
wait

echo ''
echo '###############################################################################'
echo '###                                COMPLITE.                                ###'
echo '###############################################################################'
exit