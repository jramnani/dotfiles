#!/bin/sh

set -e

SCRIPT_PATH="$(dirname $(readlink -f $0))"


function link_file {
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

function link_script {
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
    echo "Link already exists for 'bin/$FILE'. Nothing to do."
  fi
}


function install_profile {
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
  for FISH_FILE in $(ls $SCRIPT_PATH/fish/); do
      if [[ ! -L $HOME/.config/fish/$FISH_FILE ]]; then
          echo "Linking  $HOME/.config/fish/$FISH_FILE -> $SCRIPT_PATH/fish/$FISH_FILE"
          ln -s $SCRIPT_PATH/fish/$FISH_FILE $HOME/.config/fish/$FISH_FILE
      else
          echo "Link already exists for 'fish/$FISH_FILE'. Nothing to do."
      fi
  done
  unset FISH_FILE

  # Emacs
  link_file emacs.d

  # Fonts
  # Configure Font hinting for KDE.
  OS=$(uname -s)
  if [[ $OS = "Linux" ]]; then
    link_file fonts.conf
  fi

  # Git
  for GIT_FILE in gitconfig gitignore_global; do
      link_file $GIT_FILE
  done

  if [[ ! -f "$HOME/.gitconfig-user" ]]; then
      echo "Missing ~/.gitconfig-user file.  It should contain a [user] section."
  fi

  # Mercurial
  for HG_FILE in hgext hgrc; do
    link_file $HG_FILE
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


## Main

install_profile
