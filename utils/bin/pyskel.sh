#!/bin/bash

##
## this script creates an empty bash script file
##

# robust bash scripting
set -o errexit
set -o nounset

# check argument count
if [ $# -lt 1 ]; then
   echo "Usage: $0 <targetFilename>"
   exit 1
fi
TARGET_FILENAME="$1"

# check if target file exists
if [ -e "$TARGET_FILENAME" ]; then
   echo "Target file '$TARGET_FILENAME' exists already, aborting..."
   exit 2
fi

# create target file
echo '#!/usr/bin/env python3

import argparse
import sys


def get_args():
    parser = argparse.ArgumentParser(description="")
    #parser.add_argument(help="")
    args = parser.parse_args()
    return args


def main():
    args = get_args()


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print("ERROR: {} ({})".format(e, type(e).__name__))
        sys.exit(1)
' > "$TARGET_FILENAME"
echo "Successfully created target file "$TARGET_FILENAME"!"

# make target file executable
chmod +x "$TARGET_FILENAME"
