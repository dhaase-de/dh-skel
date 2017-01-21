#!/bin/bash

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
DIR_SCRIPT=$(cd "$(dirname "$0")" && pwd)
DIR_TARGET="$HOME"
DIR_BACKUP="$DIR_TARGET"/.dh-skel.install.bak.$(date '+%Y%m%d-%H%M%S')

PACKAGES="core"

for PACKAGE in $PACKAGES; do
    DIR_SOURCE="$DIR_SCRIPT"/"$PACKAGE"

    for FILE in $(cd "$DIR_SOURCE" && find . -mindepth 1 -type f | sed 's,^\./,,'); do
        FILE_SOURCE="$DIR_SOURCE"/"$FILE"
        FILE_TARGET="$DIR_TARGET"/"$FILE"
        FILE_BACKUP="$DIR_BACKUP"/"$FILE"

        echo "$FILE_TARGET"

        SUBDIR_TARGET=$(dirname "$FILE_TARGET")
        SUBDIR_BACKUP=$(dirname "$FILE_BACKUP")

        mkdir -p "$SUBDIR_TARGET"

        # does target file exist?
        if [ -e "$FILE_TARGET" ]; then
            # back it up
            mkdir -p "$SUBDIR_BACKUP"
            mv --backup "$FILE_TARGET" "$FILE_BACKUP"
        fi

        # is target a symlink?
        if [ -h "$FILE_TARGET" ]; then
            # does it point to our current file already?
            if [ "$(readlink "$FILE_TARGET")" == "$FILE_SOURCE" ]; then
                # nothing to do here
                continue
            else
                # back it up
                mkdir -p "$SUBDIR_BACKUP"
                mv --backup "$FILE_TARGET" "$FILE_BACKUP"
            fi
        fi

        # now we can create our symlink
        ln -s "$FILE_SOURCE" "$FILE_TARGET"
    done
done
