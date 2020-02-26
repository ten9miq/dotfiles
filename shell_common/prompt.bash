# ホスト名をドット区切りで3つ目までを取り出す
hostname_head3() { echo $HOSTNAME | sed -r 's@(([^\.]*)(\.[^\.]*){1,2}).*$@\1@'; }

# define the awk script using heredoc notation for easy modification
MYPSDIR_AWK=$(cat << 'EOF'
BEGIN { FS = OFS = "/" }
{
  VIEW_LEFT_PATH_COUNT=3
  VIEW_RIGHT_PATH_COUNT=5

  shorten_length=50
  shorten_path_depth=1+VIEW_LEFT_PATH_COUNT+VIEW_RIGHT_PATH_COUNT

  sub(ENVIRON["HOME"], "~");
  if (length($0) > shorten_length && NF > shorten_path_depth){
    # パス省略の左側
    for (j = 1; j <= VIEW_LEFT_PATH_COUNT ; j++ ) {
      printf "%s/",$j
    }
    # 省略部分
    printf "..%s..",NF-VIEW_RIGHT_PATH_COUNT-VIEW_LEFT_PATH_COUNT-1
    # パス省略の右側
    for (i = VIEW_RIGHT_PATH_COUNT; i >= 0 ; i-- ) {
      printf "/%s",$(NF-i)
    }
    printf "\n"
  }else{
    print $0
  }
}
EOF
)

# my replacement for \w prompt expansion
export MYPSDIR='$(echo -n "$PWD" | awk "$MYPSDIR_AWK")'
