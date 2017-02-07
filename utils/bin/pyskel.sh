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
echo '#!/usr/bin/python3

# import 


###
#%% main
###


def main():
    pass


if __name__ == "__main__":
    main()
' > "$TARGET_FILENAME"
echo "Successfully created target file "$TARGET_FILENAME"!"

# make target file executable
chmod +x "$TARGET_FILENAME"
