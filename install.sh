#!/bin/sh

set -e

SCRIPT_PATH=$(dirname $(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")"))


link_file () {
  local FILE=$1
  if [ -f $HOME/.${FILE} -a ! -L $HOME/.${FILE} ]; then
    mv $HOME/.${FILE} $HOME/.${FILE}.bak
  fi

  if [ ! -L $HOME/.${FILE} ]; then
    echo "Linking: $HOME/.${FILE} -> $SCRIPT_PATH/$FILE"
    ln -s $SCRIPT_PATH/$FILE $HOME/.${FILE}
  else
    echo "Link already exists for '$FILE'. Nothing to do."
  fi
}

link_script () {
  local FILE="$1"
  local DESTINATION_DIR="$HOME/bin"
  local DESTINATION_FILE="$DESTINATION_DIR/$FILE"

  if [ ! -d "$DESTINATION_DIR" ]; then
      mkdir -p "$DESTINATION_DIR"
  fi

  if [ -f "$DESTINATION_FILE" -a ! -L "$DESTINATION_FILE" ]; then
      echo "Script already exists for '$FILE'. Leaving it alone."
      return
  fi

  if [ ! -L "$DESTINATION_FILE" ]; then
    echo "Linking: $DESTINATION_FILE -> $SCRIPT_PATH/bin/$FILE"
    ln -s "$SCRIPT_PATH/bin/$FILE" "$DESTINATION_FILE"
  else
    echo "Link already exists for 'bin/$FILE'. Nothing to do."
  fi
}


install_profile () {
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

  # Clojure's leiningen
  mkdir -p $HOME/.lein
  link_file lein/profiles.clj

  # Fish profile
  mkdir -p $HOME/.config/fish
  for FISH_FILE in $(ls $SCRIPT_PATH/fish/); do
      if [ ! -L $HOME/.config/fish/$FISH_FILE ]; then
          echo "Linking  $HOME/.config/fish/$FISH_FILE -> $SCRIPT_PATH/fish/$FISH_FILE"
          ln -s $SCRIPT_PATH/fish/$FISH_FILE $HOME/.config/fish/$FISH_FILE
      else
          echo "Link already exists for 'fish/$FISH_FILE'. Nothing to do."
      fi
  done
  unset FISH_FILE

  # Emacs
  # link_file emacs.d
  # Doom emacs config
  link_file doom.d
  for EMACS_DIR in emacs.d/{auto-save,auto-save-list,backups}; do
    mkdir -p $EMACS_DIR
    chmod 0700 $EMACS_DIR
  done
  unset EMACS_DIR

  # Fonts
  # Configure Font hinting for KDE.
  OS=$(uname -s)
  if [ $OS = "Linux" ]; then
    link_file fonts.conf
  fi

  # Git
  for GIT_FILE in gitconfig gitignore_global; do
      link_file $GIT_FILE
  done

  if [ ! -f "$HOME/.gitconfig-user" ]; then
      echo "Missing ~/.gitconfig-user file.  It should contain a [user] section."
  fi

  # Mercurial
  for HG_FILE in hgext hgrc; do
    link_file $HG_FILE
  done

  # Molecule
  if [ ! -L "$HOME/.config/molecule/config.yml" ]; then
    echo "Linking Molecule config file: $HOME/.config/molecule/config.yml -> $SCRIPT_PATH/molecule.yml"
    mkdir -p "$HOME/.config/molecule"
    ln -f -s "$SCRIPT_PATH/molecule.yml" "$HOME/.config/molecule/config.yml"
  fi

  # PostgreSQL client
  link_file psqlrc

  # Python
  link_file pythonrc

  # IPython
  if [ ! -L "$HOME/.ipython/profile_default/ipython_config.py" ]; then
      echo "Linking IPython config file for the default profile: $HOME/.ipython/profile_default/ipython_config.py -> $SCRIPT_PATH/ipython/ipython_config.py"
      mkdir -p ~/.ipython/profile_default
      ln -f -s "$SCRIPT_PATH/ipython/ipython_config.py" "$HOME/.ipython/profile_default/ipython_config.py"
  else
      echo "Link already exists for $HOME/.ipython/profile_default/ipython_config.py. Nothing to do."
  fi

  # Ruby
  link_file irbrc
  link_file gemrc

  # RPM
  link_file rpmmacros

  # Screen
  link_file screenrc

  # Starship CLI prompt
  if [ ! -L "$HOME/.config/starship.toml" ]; then
    echo "Linking Starship config file: $HOME/.config/starship.toml -> $SCRIPT_PATH/starship.toml"
    mkdir -p "$HOME/.config"
    ln -f -s "$SCRIPT_PATH/starship.toml" "$HOME/.config/starship.toml"
  fi

  # Tmux
  link_file tmux.conf
  link_file tmux-macos.conf

  # Vim
  # Create the directory where I place my Vim backup files
  mkdir -p $HOME/tmp/vim
  chmod 0700 $HOME/tmp/vim
  if [ ! -L $HOME/.vim ]; then
    echo "Linking Vim config dir: $HOME/.vim -> $SCRIPT_PATH/vim"
    ln -s $SCRIPT_PATH/vim $HOME/.vim
  fi
  link_file vimrc
}


## Main

install_profile
