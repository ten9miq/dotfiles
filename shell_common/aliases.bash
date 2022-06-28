# bashコマンド
alias v='vim'
alias vi='vim'
# -n スワップファイルなし -u NONE pluginもvimrcも読み込まない -i NONE viminfoを読み込まない
# noremapで<Right> <Left>が使えないのでキーコードで設定
alias vin='vim -n -u NONE -i NONE --cmd "set nowrap" --cmd "set number" --cmd "noremap OC zL" --cmd "noremap OD zH"'
alias l='\ls'
alias ls='\ls -AXFhv --group-directories-first --color=auto'

if $(\ls --time-style= >/dev/null 2>&1) ;then
  alias ll='\ls -lXFhv --group-directories-first --color=auto --time-style="+%y-%m-%d %H:%M:%S"'
  alias la='\ls -alXFhv --group-directories-first --color=auto --time-style="+%y-%m-%d %H:%M:%S"'
else
  alias ll='\ls -lXFhv --group-directories-first --color=auto --full-time'
  alias la='\ls -alXFhv --group-directories-first --color=auto --full-time'
fi

alias cp='cp -i'        # -i    コピー時に上書きされるファイルがある場合、確認が入る。
alias mv='mv -i'        # -i    移動時に上書きされるものがある場合、確認が入る。
alias rm='rm -i'        # -i    ファイルの削除前に確認が入る。
alias sudo='sudo '      # sudoのあとのaliasを展開するようにするために追加
alias sudoE='sudo -E '      # sudo -E(現在の環境変数をそのまま保持する)のあとのaliasを展開するようにするために追加
alias sv='sudo_vim'
alias svi='sudo_vim'
alias hsg='history | grep'
alias g='git'
alias sg="sudo_git"
alias cdu='cd-gitroot' # zshのcd-gitrootのalias
alias du_sort='du -h --max-depth=1 | sort -hr' # コマンドを実行した場所のディレクトリをサイズの大きい順に表示する
alias rsync='rsync -ah --no-i-r --info=progress2'

# mysqlのページャを設定して実行するコマンド
alias mysqll='mysql --pager="less -S -N -i -F -X --shift=30"'
alias mysqlv='mysql --pager="vim -R - -c \"set ft=sql\" -c \"set nowrap\" -c \"noremap <Right> zL\" -c \"noremap <Left> zH\""'

alias watch='watch -n0.3 '
waps(){
  watch -n0.3 "ps fax | grep $@ | grep -v grep"
}
wals(){
  watch -n0.3 'ls | wc -l | (echo "count $(cat)") && ls -AlXvFSh --group-directories-first --time-style="+%y-%m-%d %H:%M:%S"'
}

sudof(){
  sudo zsh -c "$functions[$1]" "$@"
}

sudo_git(){
  sudo git -c 'include.path='"${XDG_CONFIG_DIR:-$HOME/.config}"'/git/config' -c 'include.path='"${HOME}/.gitconfig" $@
}

alias ...='cd ../..'
alias ....='cd ../../..'
alias sle='sudo less -SsNiMRW -z4 -x4 -#15' # 折返しなしを追加したlessパラメータ

if type smartless > /dev/null 2>&1; then
  # コマンドが存在すれば
  alias le='smartless'
  alias lef='less +F'
else
  # コマンドが存在しなければ
  alias le='less'
  alias lef='less +F'
fi
#---------------------------------------------------------------
# sudo.vim プラグインのエイリアス
#---------------------------------------------------------------
sudo_vim(){
  \vim sudo:$1
}

# ------------------------------------
# Docker aliases
# ------------------------------------
alias d="docker"
alias d-c="docker-compose"

alias dc="docker container"
alias di="docker image"
alias dp="docker compose"

#------------------------------------------------
# docker list segments command
#------------------------------------------------
# List containers  old:docker ps
alias dl="docker container ls"
# List containers including stopped containers
alias dla="docker container ls --all"
# Get the latest container ID  old:docker ps --latest --quiet
alias dlate="docker container ls --latest --quiet"

### docker image
# List images  old:docker ps
alias di="docker image ls"
# List images including intermediates
alias dia="docker image ls --all"
# Get the latest image ID
alias dilate="docker image ls | head -n 2 | tail -n 1 | awk '{print \$3}'"

#------------------------------------------------
# docker run command
#------------------------------------------------
# Run an interactive container
alias dr="docker container run --interactive --tty"
# Run a daemonized container
alias drd="docker container run --detach --interactive --tty"
# Runa deamonized container exited to container remove
alias drdrm="docker container run --detach --rm --interactive --tty"
# Run an interactive container exited to container remove
alias drrm="docker container run --rm --interactive --tty"
# Run a daemonized container   --publish-all    Publish all exposed ports to random ports
alias drdpa="docker container run --detach --publish-all --interactive --tty"
# docker container in bash exec
alias de="docker container exec -it"
# 一番新しいコンテナへ入る
alias del='docker container exec -it $(docker container ls --latest --quiet 2>/dev/null \
  || sudo docker container ls --latest --quiet)'

#------------------------------------------------
# docker remove command
#------------------------------------------------
# Remove container id argment or latest container
alias drm="docker container rm"
# REmove latest container
alias drml='docker container rm $(docker container ls --latest --quiet 2>/dev/null \
  || sudo docker container ls --latest --quiet)'

# Remove image id argment or latest image
alias dirm='docker image rm'
# Remove latest image
alias dirml='docker image rm $(docker image ls | head -n 2 | tail -n 1 | awk "{print \$3}" 2>/dev/null || \
  sudo docker image ls | head -n 2 | tail -n 1 | awk "{print \$3}")'

alias dcprune='docker container prune'
alias diprune='docker image prune'
# 停止コンテナ、タグ無しイメージ、未使用ネットワーク､ビルドキャッシュの一括削除 ver >=1.13
alias dsprune='docker system prune'
alias dallprune='docker system prune --all --force'

# Remove all containers  old:docker rm $(docker ps --all --quiet)
alias drma='docker container rm $(docker container ls --all --quiet 2>/dev/null || sudo docker container ls --all --quiet)'
# Remove all images  old:docker rmi $(docker images --quiet)
alias dirma='docker image rm $(docker image ls --all --quiet 2>/dev/null || sudo docker image ls --all --quiet)'
# Remove all containers and images and other
alias dallclean='docker container stop $(docker container ls --quiet 2>/dev/null || sudo docker container ls --quiet); \
  docker container kill $(docker container ls --all --quiet 2>/dev/null || sudo docker container ls --all --quiet); \
  drma 2>/dev/null || sudo drma; dirma 2>/dev/null || sudo dirma; docker system prune --all || sudo docker system prune --all'

#------------------------------------------------
# docker other command
#------------------------------------------------
# Get an IPaddress of a container
alias dip="docker container inspect --format '{{ .NetworkSettings.IPAddress }}'"
# is me add docker group  don't need sudo docker command
alias dockerGroupAdd='docker_group_add'
# List all aliases relating to docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)='\(.*\)'/\1    => \2/"| sed "s/'\\\'//g"; }
# docker image all update
alias diupdate="sudo docker images | cut -d ' ' -f1 | tail -n +2 | sort | uniq | egrep -v '^(<none>|ubuntu)$' | xargs -P0 -L1 sudo docker pull"
# docker image to dockerfile
alias dih="docker_image_history"

docker_image_history(){
  if [ "$1" != "" ]; then
    docker image history --no-trunc $1  | \
    tac | tr -s ' ' | cut -d ' ' -f 5- | \
    sed 's,^/bin/sh -c #(nop) ,,g' | sed 's,^/bin/sh -c,RUN,g' | \
    sed 's, && ,\n  & ,g' | sed 's,\s*[0-9]*[\.]*[0-9]*[kMG]*B\s*$,,g' | head -n -1
  else
    echo "error: no argments."
  fi
}

docker_group_add(){
  sudo groupadd docker # dockerグループを作成
  sudo gpasswd -a $USER docker # 自身をdocker gruopに追加 sudo 不要になる
  sudo systemctl restart docker # dockerの再起動
  echo "グループ適用のためログアウトします｡"
  exit
}
