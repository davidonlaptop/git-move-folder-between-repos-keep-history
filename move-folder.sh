#!/bin/bash

# Copy a folder from one git repo to another git repo,
# preserving full history of the folder.

# TODO: test rename
# TODO: test import subfolder
# TODO
# CAVEAT: only imports one branch from remote repository

# import_another_git_with_history_to_subfolder
import_folder_from_another_git_repo2(){
    local _mergeworkingdir="$HOME/gitimport";

    local _dst_git_url="$1";
    local _dst_git_basename=$(basename ${_dst_git_url%.*});
    local _dst_git_path="$_mergeworkingdir/$_dst_git_basename";

    local _src_git_url="$2";
    local _src_git_basename=$(basename ${_src_git_url%.*});
    local _src_git_path="$_mergeworkingdir/$_src_git_basename";
    local _src_git_rev="master";
    local _dst_git_branch="MERGE_${_src_git_basename}";

    echo -e "\n** Creating working directory for merge at $_mergeworkingdir";
    mkdir -p "$_mergeworkingdir";

    echo -e "\n** Cloning source repository from $_src_git_url ...";
    cd "$_mergeworkingdir" && git clone "$_src_git_url";

    echo -e "\n** Cloning destination repository from $_dst_git_url ...";
    cd "$_mergeworkingdir" && git clone "$_dst_git_url" && cd "$_dst_git_path";

# TODO: create branch only if it doesn't exist

    echo -e "\n** Importing history from source repository into subfolder '$_src_git_basename' of branch $_dst_git_branch";
    git checkout -b "$_dst_git_branch" && git subtree add -P "$_src_git_basename" "$_src_git_path" "$_src_git_rev";
}


import_folder_from_another_git_repo2 git@gonebig.com:dlauzon/simplerepo2.git git@gonebig.com:dlauzon/simplerepo1.git
#undo_import_folder_from_another_git_repo
#    local _dst_git_url="git@gonebig.com:dlauzon/cme-doc.git";
#    local _src_git_url="git@gonebig.com:dlauzon/entitlementpoc.git";
