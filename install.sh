#!/bin/bash

# usage: install.sh [-u] [package1] [package2] [...]
#
# This script will INSTALL the packages with the names <package1>, <package2>,
# etc. If "-u" is passed as argument, the packages will be UNINSTALLED instead.
# If no package names are given, all valid packages are considered.

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
DIR_SCRIPT=$(cd "$(dirname "$0")" && pwd)
DIR_TARGET="$HOME"
DIR_BACKUP="$DIR_TARGET"/.dh-skel.install.bak.$(date '+%Y%m%d-%H%M%S')

# check for packages, and if installation (default) or uninstallation (-u) 
MODE="INSTALL"
PACKAGES=""
for ARGV in "$@"; do
    if [ "$ARGV" == "-u" ]; then
        MODE="UNINSTALL"
    else
        PACKAGES="$PACKAGES $ARGV"
    fi
done

# if no packages were specified, use all packages
if [ "$PACKAGES" == "" ]; then
    PACKAGES=" core"
fi

# show actions and ask for user confirmation
read -r -p "Continue to $MODE the following package(s):$PACKAGES? [Y/n] " response
response=${response,,}
if [ "$response" != "" ] && [ "$response" != "y" ] && [ "$response" != "ye" ] && [ "$response" != "yes" ]; then
    exit 1
fi

# loop over all source packages
for PACKAGE in $PACKAGES; do
    DIR_SOURCE="$DIR_SCRIPT"/"$PACKAGE"
    
    if [ ! -d "$DIR_SOURCE" ]; then
        echo "ERROR: package dir '$DIR_SOURCE' does not exist"
        exit 1
    fi

    for FILE in $(cd "$DIR_SOURCE" && find . -mindepth 1 -type f | sed 's,^\./,,'); do
        FILE_SOURCE="$DIR_SOURCE"/"$FILE"
        FILE_TARGET="$DIR_TARGET"/"$FILE"
        FILE_BACKUP="$DIR_BACKUP"/"$FILE"

        # installation casee
        if [ "$MODE" == "INSTALL" ]; then
            SUBDIR_TARGET=$(dirname "$FILE_TARGET")
            SUBDIR_BACKUP=$(dirname "$FILE_BACKUP")

            mkdir -p "$SUBDIR_TARGET"
            
            # if target already is installed, there is nothing to do and we can skip the rest
            if [ -h "$FILE_TARGET" ]; then
                if [ "$(readlink "$FILE_TARGET")" == "$FILE_SOURCE" ]; then
                    echo "[UNCHANGED] -- $FILE_TARGET"
                    continue
                fi
            fi

            # if the target file exists or if it is a symlink, we need to back it up
            if [ -e "$FILE_TARGET" -o  -h "$FILE_TARGET" ]; then
                # back it up
                mkdir -p "$SUBDIR_BACKUP"
                mv --backup "$FILE_TARGET" "$FILE_BACKUP"
            fi

            # now we can create our symlink
            ln -s "$FILE_SOURCE" "$FILE_TARGET"
            echo "[INSTALLED] -- $FILE_TARGET"
        fi
        
        # uninstallation case
        if [ "$MODE" == "UNINSTALL" ]; then
            # only remove traget if it is a correctly installed file
            if [ -h "$FILE_TARGET" ]; then
                if [ "$(readlink "$FILE_TARGET")" == "$FILE_SOURCE" ]; then
                    rm "$FILE_TARGET"
                    echo "[ REMOVED ] -- $FILE_TARGET"
                    continue
                fi
            fi
            
            # otherwise, do nothing
            echo "[UNCHANGED] -- $FILE_TARGET"
        fi
    done
done
