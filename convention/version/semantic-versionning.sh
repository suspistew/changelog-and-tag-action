#!/bin/bash

REGEX_TAG="([0-9]*)(\.)([0-9]*)(\.)([0-9]*)";

#
# Update version from last_commit and last_tag
#
function update_version {
    if [ -z "$LAST_TAG" ]; then
        major=0 && minor=0 && patch=0
    else
        if [[ $LAST_TAG =~ $REGEX_TAG ]]; then
            major=${BASH_REMATCH[1]} 
            minor=${BASH_REMATCH[3]}
            patch=${BASH_REMATCH[5]}
        else
            log_error "Your last tag doesn't respect the semantic versionning, stopping now"
            exit $ERROR_CODE
        fi
    fi

    lastcommit=$(get_last_commit)

    case "$lastcommit" in \
        *major* ) let "major++" && patch=0 && minor=0;; 
        *minor* ) let "minor++" && patch=0;; 
        *patch* ) let "patch++";; 
        * ) log_error "Didn't find one of {major,minor,patch} in your last commit. Stopping" && exit $ERROR_CODE;; 
    esac

    NEXT_TAG=$"$major.$minor.$patch"
    log "Next tag will be $NEXT_TAG"

}