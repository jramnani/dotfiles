#!/bin/bash

# Inspired by this blog post: https://blog.g3rt.nl/upgrade-your-ssh-keys.html

# Upgrades existing RSA keys to introduce a work factor.
# All of my keys are 4096 bytes, so I just need to introduce a work factor, for now.

WORK_FACTOR=100

IDENTITY_FILE="$1"

if [[ -z "$IDENTITY_FILE" ]]; then
    echo "Usage: $0 SSH_IDENTITY_FILE"
    echo "Example: $0 ~/.ssh/id_rsa"
    exit 1
fi

echo "Upgrading SSH identity ${IDENTITY_FILE}. You will be prompted for your passphrase."
ssh-keygen -f "${IDENTITY_FILE}" -p -o -a $WORK_FACTOR
