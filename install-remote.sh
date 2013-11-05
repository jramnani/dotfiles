#!/usr/bin/env bash

# Install my profile on a remote server.  Assuming I have access to Github.

REMOTE_SERVER=$1

if [[ -z $REMOTE_SERVER ]]; then
  echo "Usage: $0 REMOTE_SERVER"
  exit 1
fi

echo "Making code directory"
ssh $REMOTE_SERVER "mkdir -p code"

echo "Cloning profile repository"
ssh $REMOTE_SERVER "cd code; git clone https://github.com/jramnani/dotfiles.git profile"

echo "Installing profile"
ssh $REMOTE_SERVER "cd code/profile; ./install.sh -p"
