#!/usr/bin/env bash

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
  local FILE=$1
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

function link_script() {
  local FILE="$1"
  local DESTINATION_DIR="$HOME/bin"
  local DESTINATION_FILE="$DESTINATION_DIR/$FILE"

  if [[ ! -d "$DESTINATION_DIR" ]]; then
      mkdir -p "$DESTINATION_DIR"
  fi

  if [[ -f "$DESTINATION_FILE" && ! -L "$DESTINATION_FILE" ]]; then
      echo "Script already exists for '$FILE'. Leaving it alone."
      return
  fi

  if [[ ! -L "$DESTINATION_FILE" ]]; then
    echo "Linking: $DESTINATION_FILE -> $PWD/bin/$FILE"
    ln -s "$SCRIPT_PATH/bin/$FILE" "$DESTINATION_FILE"
  else
    echo "Link already exists for '$FILE'. Nothing to do."
  fi
}


function install_profile() {
  # Bash profile
  for FILE in bash bash_profile bashrc; do
    link_file $FILE
  done
  unset FILE

  # My scripts
  mkdir -p $HOME/bin
  for FILE in $(ls $SCRIPT_PATH/bin/); do
      link_script $FILE
  done
  unset FILE

  # Fish profile
  mkdir -p $HOME/.config/fish
  if [[ ! -L $HOME/.config/fish/config.fish ]]; then
    ln -s $SCRIPT_PATH/fish/config.fish $HOME/.config/fish/config.fish
  fi
  if [[ ! -L $HOME/.config/fish/vi-mode.fish ]]; then
    ln -s $SCRIPT_PATH/fish/vi-mode.fish $HOME/.config/fish/vi-mode.fish
  fi
  if [[ ! -L $HOME/.config/fish/virtual.fish ]]; then
    ln -s $SCRIPT_PATH/fish/virtual.fish $HOME/.config/fish/virtual.fish
  fi
  if [[ ! -L $HOME/.config/fish/functions ]]; then
    ln -s $SCRIPT_PATH/fish/functions $HOME/.config/fish/functions
  fi
  if [[ ! -L $HOME/.config/fish/completions ]]; then
    ln -s $SCRIPT_PATH/fish/functions $HOME/.config/fish/completions
  fi

  # Emacs
  link_file emacs.d

  # Fonts
  # Configure Font hinting for KDE.
  OS=$(uname -s)
  if [[ $OS = "Linux" ]]; then
    link_file fonts.conf
  fi

  # Git
  link_file gitconfig
  if [[ ! -f "$HOME/.gitconfig-user" ]]; then
      echo "Missing ~/.gitconfig-user file.  It should contain a [user] section."
  fi

  # Mercurial
  for FILE in hgext hgrc; do
    link_file $FILE
  done

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
