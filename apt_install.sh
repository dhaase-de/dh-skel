#!/bin/bash

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

sudo apt update && sudo apt install \
    duf \
    fzf \
    mc \
    renameutils \
    rhash \
    ripgrep \
    zoxide
