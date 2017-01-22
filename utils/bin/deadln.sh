#!/bin/bash

# Usage: $0 [path1] [path2] [...]
# Prints dead symlinks in the specified paths. If no path is given, "." is used.

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# check argument count
if [ $# -lt 1 ]; then
   WHERE="."
else
    WHERE="$@"
fi

find $WHERE -type l -! -exec test -e {} \; -print | while read -r line ; do
    echo "$line  ->  $(readlink "$line")"
done
