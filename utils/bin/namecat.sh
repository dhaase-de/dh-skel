#!/bin/bash

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

for filename in "$@"; do
    echo "========================================"
    echo "File: $filename"
    echo "----------------------------------------"
    cat "$filename"
done
echo "========================================"
