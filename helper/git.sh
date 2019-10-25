#!/bin/bash
function get_last_tag {
    taglist=$(git rev-list --tags --max-count=1)
    if [ -z "$taglist" ]; then
        echo ""
    else
        echo $(git describe --tags $taglist)
    fi
}

function get_last_commit {
    echo $(git log -n 1 --pretty=format:%s $(git rev-parse HEAD)) 
}

function read_commit_messages {
    if [ -z "$LAST_TAG" ]; then
        echo "No last tag found, configuring for global log";
        COMMIT_MESSAGES=$(git log --oneline)
    else
        echo "Configuring git log from last tag: $LAST_TAG";
        COMMIT_MESSAGES=$(git log $LAST_TAG..HEAD --oneline)    
    fi
}

function split_commit_messages {
    IFS=$'\n' read -rd '' -a SPLITTED_LOGS <<<"$COMMIT_MESSAGES" && echo "found ${#SPLITTED_LOGS[@]} logs"
}

function sort_commit_messages {
    
    for (( i=0; i < ${#COMMIT_TYPES[@]}; i++ )); do
        SORTED_LOGS_SIZES[$i]=0
    done

    for (( i=0; i < ${#SPLITTED_LOGS[@]}; i++ )); do
        log=${SPLITTED_LOGS[i]}
        if [[ $log =~ $REGEX_COMMIT ]]
        then
            finded=0
            j=0
            while [[ $finded = 0  && $j < ${#COMMIT_TYPES[@]} ]]
            do
                if [ "${BASH_REMATCH[3]}" = "${COMMIT_TYPES[$j]}" ]; then
                    finded=1;
                    index=${SORTED_LOGS_SIZES[$j]}
                    let "SORTED_LOGS_SIZES[$j]++"
                    SORTED_LOGS[$j,$index]=$(get_changelog_line_from_commit)
                    echo "$log added to the changelog"
                else
                    let "j++"
                fi
            done
            if [[ $finded = 0 ]]; then 
                echo "$log doesn't match the commit message pattern and won't be part of the changelog.md"
            fi
        else
            echo "$log doesn't match the commit message pattern and won't be part of the changelog.md"
        fi
    done;

    export SORTED_LOGS=$SORTED_LOGS
}

function read_and_sort_last_commit_messages {
    read_commit_messages
    split_commit_messages
    sort_commit_messages
}

function git_commit_push_changelog {
    touch CHANGELOG.md
    touch this_release_changelog
    cat this_release_changelog | cat - CHANGELOG.md >> temp2 && mv temp2 CHANGELOG.md

    git add CHANGELOG.md
    git commit -m "Auto generated CHANGELOG"
    git push -u upstreamSecured HEAD:${GITHUB_REF}
}

function git_post_release {
    touch this_release_changelog
    releaseContent=$(cat this_release_changelog)
    releaseContent=${releaseContent//$'\n'/"\r\n"}
    body=$(printf $'{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "%s","draft": false,"prerelease": false}' "$NEXT_TAG" "${GITHUB_REF}" "$NEXT_TAG" "$releaseContent")
    authorization=$(printf $'Authorization: token %s' $GITHUB_TOKEN)
    curl POST \
        https://api.github.com/repos/$REPOSITORY/releases \
        -H $"$authorization" \
        -d $"$body"
}

declare -A SORTED_LOGS
declare -A SORTED_LOGS_SIZES


git config user.email github-actions
git config user.name github-actions

LAST_TAG=$(get_last_tag)
REMOTE=$(git config --get remote.origin.url)
REPOSITORY=$(basename "$(dirname "$REMOTE")")/$(basename "$REMOTE")
git remote add upstreamSecured https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$REPOSITORY > /dev/null 2>&1