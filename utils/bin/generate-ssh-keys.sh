#!/bin/bash

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# https://security.stackexchange.com/a/144044
ssh-keygen -t rsa -b 4096 -o -a 100
