#!/bin/bash

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

function print_usage() {
    echo "Usage: zipdir <dirname>"
    exit 1 
}

if [[ $# -ne 1 ]]; then
    print_usage
fi
if [[ ! -d "$1" ]]; then
    print_usage
fi

FULL_PATH="$(cd "$1" && pwd)"

cd "$FULL_PATH" && cd ..

BASENAME="$(basename "$FULL_PATH")"
BASENAME="$(echo $BASENAME | sed 's,/$,,')"

cd "$FULL_PATH" && cd .. && zip -r "$BASENAME.zip" "$BASENAME/"
