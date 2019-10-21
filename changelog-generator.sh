#!/bin/bash

ERROR_CODE=147692

source /helper/git.sh
source /convention/commit/angular.sh
source /convention/version/semantic-versionning.sh

function main {
    
    read_and_sort_last_commit_messages
    update_version 
    create_changelog
    git_commit_push_changelog
    git_post_release
    
    echo ::set-output name=NEW_TAG::$NEXT_TAG
}

main
