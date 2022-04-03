#!/bin/bash
THIS_SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
# PROJECT_PATHなどのsetup時の環境変数の読み込みを行う
source $THIS_SCRIPT_PATH/../setup_env.sh

cp $THIS_SCRIPT_PATH/.zshrc ~/
cp $THIS_SCRIPT_PATH/.zprofile ~/
cp -r $THIS_SCRIPT_PATH/.zsh/ ~/


# # dotfileの展開先でgithubにアクセスできない場合はzipにしたプラグインのファイルを展開するスクリプト
#  if [ `os_type` = 'linux' ]; then
#    zi_path="$HOME/.zi/"
#    mkdir -p $zi_path/plugins/
#    tar zxf $THIS_SCRIPT_PATH/zi.tgz/bin.tgz -C $zi_path

#    find $THIS_SCRIPT_PATH/zi.tgz/plugins/ -type f -name "*.tgz" | xargs -IXXX tar zxf XXX -C $zi_path/plugins/

#    ln -fs $zi_path/bin/_zi $HOME/.zi/plugins/_local---zi/
#    if `has zsh` ; then
#      log_print "zi creinstall exec"
#      zsh -ic "zi creinstall -q $HOME/.zi"
#    else
#      skip_print 'not install zsh. please zsh installed to "zi creinstall -q $HOME/.zi" commnad'
#    fi
#  fi


exit $?
