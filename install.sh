#!/bin/bash

set -e

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function install_eggs() {
  cat eggs_to_install | xargs pip install
}

function install_gems() {
  cat gems_to_install | xargs gem install
}

function install_brews() {
  cat brews_to_install | xargs brew install
}

function link_file() {
  FILE=$1
  if [[ -f $HOME/.${FILE} && ! -L $HOME/.${FILE} ]]; then
    mv $HOME/.${FILE} $HOME/.${FILE}.bak
  fi

  if [[ ! -L $HOME/.${FILE} ]]; then
    echo "Linking: $HOME/.${FILE} -> $PWD/$FILE"
    ln -s $SCRIPT_PATH/$FILE $HOME/.${FILE}
  else
    echo "Link already exists for '$FILE'. Nothing to do."
  fi
}

function install_profile() {
  # Bash profile
  for FILE in bash bash_profile bashrc; do
    link_file $FILE
  done

  # Fish profile
  mkdir -p $HOME/.config/fish
  if [[ ! -L $HOME/.config/fish/config.fish ]]; then
    ln -s $SCRIPT_PATH/fish/config.fish $HOME/.config/fish/config.fish
  fi
  if [[ ! -L $HOME/.config/fish/functions ]]; then
    ln -s $SCRIPT_PATH/fish/functions $HOME/.config/fish/functions
  fi
  if [[ ! -L $HOME/.config/fish/completions ]]; then
    ln -s $SCRIPT_PATH/fish/functions $HOME/.config/fish/completions
  fi

  # Git
  # Copy the file, instead of linking, since I use different emails at home and at work.
  if [[ gitconfig -nt $HOME/.gitconfig ]]; then
    echo "Updating gitconfig ..."
    cp $HOME/.gitconfig $HOME/.gitconfig.bak
    cp gitconfig $HOME/.gitconfig
  fi

  # Mercurial
  for FILE in hgext hgrc; do
    link_file $FILE
  done

  # Python
  # Copy IPython configuration file.
  mkdir -p $HOME/.ipython
  if [[ ! -f $HOME/.ipython/ipy_user_conf.py && ! -L $HOME/.ipython/ipy_user_conf.py ]]; then
    ln -s $SCRIPT_PATH/ipython/ipy_user_conf.py $HOME/.ipython/ipy_user_conf.py
  fi
  link_file pythonrc

  # Ruby
  link_file irbrc

  # RPM
  link_file rpmmacros

  # Screen
  link_file screenrc

  # Tmux
  link_file tmux.conf

  # Vim
  # Create the directory where I place my Vim backup files
  mkdir -p $HOME/tmp/vim
  if [[ ! -L $HOME/.vim ]]; then
    echo "Linking Vim config dir: $HOME/.vim -> $SCRIPT_PATH/vim"
    ln -s $SCRIPT_PATH/vim $HOME/.vim
  fi
  link_file vimrc
}

function usage() {
  echo "Usage: $0 [-b brews] | [-e eggs] | [-g gems] | [-p profile] "
}

## Main

if [[ -z $1 ]]; then
  usage
  exit 1
fi

case $1 in
  "-b")
    install_brews
    ;;
  "-e")
    install_eggs
    ;;
  "-g")
    install_gems
    ;;
  "-p")
    install_profile
    ;;
  "*")
    usage
    exit 1
esac