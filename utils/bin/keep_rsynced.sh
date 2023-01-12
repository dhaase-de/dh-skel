#!/bin/bash

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

while inotifywait "$1"; do
    rsync --progress -avz "$1" "$2"
done
