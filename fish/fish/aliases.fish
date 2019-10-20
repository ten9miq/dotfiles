# ファイル・ディレクトリ等の色の設定(BSD用)
set LSCOLORS Exfxcxdxbxegedabagacad
# ファイル・ディレクトリ等の色の設定(GNU用)
set LS_COLORS 'di=01;96:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

alias l ls
alias ls 'ls -AXFhv --group-directories-first --color=auto'
alias ll 'ls -lXFhv --group-directories-first --color=auto'
alias la 'ls -alXFhv --group-directories-first --color=auto'

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

alias cp 'cp -i'        # -i    コピー時に上書きされるファイルがある場合、確認が入る。
alias mv 'mv -i'        # -i    移動時に上書きされるものがある場合、確認が入る。
alias rm 'rm -i'        # -i    ファイルの削除前に確認が入る。
alias sudo 'sudo '

alias v vim
alias vi vim
alias sv 'sudo_vim'
alias svi 'sudo_vim'

alias hg 'history | grep'

alias g 'git'

function sudo_vim
  \vim sudo:$1
end
