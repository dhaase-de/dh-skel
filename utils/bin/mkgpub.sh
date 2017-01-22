#!/bin/bash

# robust bash scripting
set -o errexit
set -o nounset

# get absolute path of this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# check argument count
if [ $# -ne 1 ]; then
    echo "Usage: $0 <repo-name>"
    echo "Will create the public Git repo dh-<repo-name>.git"
    exit 1
fi

# create repo dir
REPO_PREFIX="dh-"
REPO_NAME="$REPO_PREFIX$1.git"
REPO_DIR="$(pwd)/$REPO_NAME"
HOOK_FILE="$REPO_DIR/hooks/post-receive"
if [ -e "$REPO_DIR" ]; then
    echo "Target dir '$REPO_DIR' exists already, aborted"
    exit 2
fi
mkdir "$REPO_DIR" && cd "$REPO_DIR"

# set up git
git init --bare
git remote add github "git@github.com:dhaase-de/$REPO_NAME"

# add post-receive hook
echo '#!/bin/bash

for REMOTE in $(git remote); do
    git push "$REMOTE" --all
    git push "$REMOTE" --tags
done
' > "$HOOK_FILE"
chmod +x "$HOOK_FILE"

# last step must be done manually at the moment
echo "All done, please create the repo '$REPO_PREFIX$1' at github.com!"
