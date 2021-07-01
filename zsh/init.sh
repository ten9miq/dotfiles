#!/bin/bash
THIS_SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
# PROJECT_PATHなどのsetup時の環境変数の読み込みを行う
source $THIS_SCRIPT_PATH/../setup_env.sh

cp $THIS_SCRIPT_PATH/.zshrc ~/
cp $THIS_SCRIPT_PATH/.zprofile ~/
cp -pr $THIS_SCRIPT_PATH/.zsh/ ~/


# dotfileの展開先でgithubにアクセスできない場合はzipにしたプラグインのファイルを展開するスクリプト
# if [ `os_type` = 'linux'  ]; then
#   zinit_path="$HOME/.zinit/"
#   mkdir -p $zinit_path/plugins/
#   tar zxf $THIS_SCRIPT_PATH/zinit.tgz/bin.tgz -C $zinit_path
#
#   find $THIS_SCRIPT_PATH/zinit.tgz/plugins/ -type f -name "*.tgz" | xargs -n 1 -IXXX tar zxf XXX -C $zinit_path/plugins/
#
#   ln -fs $zinit_path/bin/_zinit $HOME/.zinit/plugins/_local---zinit/
#   if `has zsh` ; then
#     log_print "zinit creinstall exec"
#     zsh -ic "zinit creinstall -q $HOME/.zinit"
#   else
#     skip_print 'not install zsh. please zsh installed to "zinit creinstall -q $HOME/.zinit" commnad'
#   fi
# fi


exit $?
