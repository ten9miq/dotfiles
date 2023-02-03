#---------------------------------------------------------------
# SSH AGENT SETTINGS
# クライアントのLinuxの場合にssh-agentを共通で使う
# https://www8281uo.sakura.ne.jp/blog/?p=617
#---------------------------------------------------------------
SSH_DIR="$HOME/.ssh/"
if [ -d $SSH_DIR ];then
  # SSHで接続していないならssh-agent実行処理を行う
  if [ -z "$SSH_CONNECTION" ]; then
    # 秘密鍵が1つ以上あるかチェック
    FIND_KEY="find $SSH_DIR -name 'id_rsa*' -name '*.pem' -not -name '*.pub'"
    if [ $(eval $FIND_KEY | wc -l) -gt 0 ];then
      SSH_AGENT_FILE=$HOME/.ssh-agent
      [ -f $SSH_AGENT_FILE ] && source $SSH_AGENT_FILE
      ssh-add -l > /dev/null
      if [ $? != 0 ]; then
        # >| を使うことでsetopt no_clobberでも上書きできる
        ssh-agent >| $SSH_AGENT_FILE
        source $SSH_AGENT_FILE
        for KEY in $(eval $FIND_KEY)
        do
          ssh-add $KEY
        done
      fi
    fi
    unset SSH_AGENT_FILE
    unset KEY
  else
    SSH_AGENT_LINK=$HOME/.ssh/agent
    if [ -S $SSH_AUTH_SOCK ]; then
      case $SSH_AUTH_SOCK in
        /tmp/ssh-*/agent.[0-9]*)
          ln -sf $SSH_AUTH_SOCK $SSH_AGENT_LINK;
          ;;
      esac
    fi
    if [ -S $SSH_AGENT_LINK ]; then
      export SSH_AUTH_SOCK=$SSH_AGENT_LINK
    fi
    unset SSH_AGENT_LINK
  fi
fi
unset SSH_DIR

#---------------------------------------------------------------
# SSHログイン時にtmuxを自動で開くようにする
#---------------------------------------------------------------
if type tmux >/dev/null 2>&1; then
  #if not inside a tmux session, and if no session is started, start a new session
  if test -z "$TMUX"; then
    if ! $(tmux attach); then
      tmux new-session
    fi
  fi
fi

#---------------------------------------------------------------
# tmuxのhostごとにstatus lineの色を変える
#---------------------------------------------------------------
if ! [ "$TMUX" = "" ]; then
    tmux set-option status-bg $(perl -MList::Util=sum -e'print+(red,green,blue,yellow,cyan,magenta,white)[sum(unpack"C*",shift)%7]' $(hostname)) | cat > /dev/null
fi