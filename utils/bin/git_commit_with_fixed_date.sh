#!/bin/bash

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# check argument count
if [ $# -ne 2 ]; then
    echo "Usage: $0 <commit-message> <date-abs-or-rel>"
    exit 1
fi

echo "Commit message: $1"

# get new date
DATE_NOW=$(date --iso-8601=seconds | sed 's/T/ /')
DATE_COMMIT=$(date --date="$2" --iso-8601=seconds | sed 's/T/ /')
echo "Current date:   $DATE_NOW"
echo "Commit date:    $DATE_COMMIT"

# ask user to continue
while true; do
    read -p "Commit (y/n)? " ANSWER
    case $ANSWER in
        [Yy]* ) break;;
        [Nn]* ) echo "Aborted"; exit;;
        * ) echo "Expected 'y' or 'n'.";;
    esac
done

# commit
GIT="$(which git)"
export GIT_AUTHOR_DATE="$DATE_COMMIT"
export GIT_COMMITTER_DATE="$DATE_COMMIT"
"$GIT" commit --message="$1" 
