# ホスト名をドット区切りで3つ目までを取り出す
hostname_head3() { echo $HOSTNAME | sed -r 's@(([^\.]*)(\.[^\.]*){1,2}).*$@\1@'; }

# define the awk script using heredoc notation for easy modification
MYPSDIR_AWK=$(cat << 'EOF'
BEGIN { FS = OFS = "/" }
{
  sub(ENVIRON["HOME"], "~");
  if (length($0) > 16 && NF > 6)
    print $1,$2,".."NF-6"..",$(NF-3),$(NF-2),$(NF-1),$NF
  else
    print $0
}
EOF
)

# my replacement for \w prompt expansion
export MYPSDIR='$(echo -n "$PWD" | awk "$MYPSDIR_AWK")'
