#!/bin/bash
# setup時に必要な環境変数やエラートラップの実行
source ./setup_env.sh
logo

# 並列実行できるもの
dists=('vim' 'zsh' 'bash' 'shell_common' 'tmux' 'ssh' 'bin' 'git' 'etc' 'fish')
scripts=()
pids=()
for e in "${dists[@]}"; do
  for script in "$PROJECT_PATH"/"$e"/*.sh; do
    if [ -f "$script" ]; then
      run_print "$script"
      (
        if bash "$script"; then
          ok_print "$script"
        else
          error_print "$script"
          exit 1
        fi
      ) &
      scripts+=("$script")
      pids+=("$!")
    else
      continue
    fi
  done
done

# 終了を待つ
failed_scripts=()
for i in "${!pids[@]}"; do
  if ! wait "${pids[$i]}"; then
    failed_scripts+=("${scripts[$i]}")
  fi
done

if [ "${#failed_scripts[@]}" -gt 0 ]; then
  echo ''
  echo '###############################################################################'
  echo '###                            SETUP FAILED.                                ###'
  echo '###############################################################################'
  printf 'Failed scripts:\n'
  printf '  %s\n' "${failed_scripts[@]}"
  exit 1
fi

echo ''
echo '###############################################################################'
echo '###                                COMPLETE.                                ###'
echo '###############################################################################'
exit 0
