#!/bin/bash

# Copy a folder from one git repo to another git repo,
# preserving full history of the folder.

# TODO: add documentation
# TODO: import multiple branches
# TODO: test rename
# CAVEAT: only imports one branch from remote repository


#//merge_repos_with_history git@gonebig.com:dlauzon/simplerepo2.git git@gonebig.com:dlauzon/simplerepo1.git

MERGE_WORKING_DIR="$HOME/gitimport";

DST_GIT_URL="$1";
DST_GIT_BASENAME=$(basename ${DST_GIT_URL%.*});
DST_GIT_PATH="$MERGE_WORKING_DIR/$DST_GIT_BASENAME";


# Cleanup
echo "Cleaning up..." && rm -rf $MERGE_WORKING_DIR/*


echo -e "\n** Creating working directory for merge at $MERGE_WORKING_DIR";
mkdir -p "$MERGE_WORKING_DIR";

echo -e "\n** Cloning destination repository from $DST_GIT_URL ...";
cd "$MERGE_WORKING_DIR" && git clone "$DST_GIT_URL";

# Skip first param, as it used for the destination repository
shift

export MERGE_BRANCH_ORDER=""

for SRC_GIT_URL in "$@"
do
    SRC_GIT_BASENAME=$(basename ${SRC_GIT_URL%.*});
    SRC_GIT_PATH="$MERGE_WORKING_DIR/$SRC_GIT_BASENAME";
    SRC_GIT_REV="master";
    DST_GIT_BRANCH="MERGE_${SRC_GIT_BASENAME}";

    MERGE_BRANCH_ORDER="${MERGE_BRANCH_ORDER} ${DST_GIT_BRANCH}";

    echo -e "\n** Cloning source repository from $SRC_GIT_URL ...";
    cd "$MERGE_WORKING_DIR" && git clone "$SRC_GIT_URL";

    # TODO: create branch only if it doesn't exist

    echo -e "\n** Importing history from source repository into subfolder '$SRC_GIT_BASENAME' of branch $DST_GIT_BRANCH";
    cd "$DST_GIT_PATH" &&
    git checkout -b "$DST_GIT_BRANCH" &&
    git subtree add -P "$SRC_GIT_BASENAME" "$SRC_GIT_PATH" "$SRC_GIT_REV";
done

echo -e "\n** Well done! to push all your branches to $DST_GIT_URL do:"
echo "git push origin '*:*'"
echo "git push origin --all"
echo "git push origin --tags"

echo -e "\n** FYI. Either just merge the last branch, or merge in this order: $MERGE_BRANCH_ORDER"
