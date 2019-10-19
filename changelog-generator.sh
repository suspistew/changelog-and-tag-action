#!/bin/bash

last_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
remote=$(git config --get remote.origin.url)
repository=$(basename "$(dirname "$remote")")/$(basename "$remote")

git config user.email github-actions
git config user.name github-actions

if [ -z "$last_tag" ]; then
    echo "No last tag found, configuring for global log";
    logs=$(git log --oneline)
else
    echo "Configuring git log from last tag: $last_tag";
    logs=$(git log $last_tag..HEAD --oneline)
fi

IFS=$'\n' read -rd '' -a splitted_logs <<<"$logs"
echo "found ${#splitted_logs[@]} logs"

commit_types=("feat" "fix" "build" "ci" "docs" "perf" "refactor" "style" "test")

declare -A commit_types_text
commit_types_text["feat"]="New features :tada:"
commit_types_text["fix"]="Bug fixes :bug:"
commit_types_text["build"]="Build improvements :construction_worker:"
commit_types_text["ci"]="Continuous integration improvements :wrench:"
commit_types_text["docs"]="Documentations :page_facing_up:"
commit_types_text["perf"]="Performance improvements :fire:"
commit_types_text["refactor"]="Refactoring :repeat:"
commit_types_text["style"]="New style :art:"
commit_types_text["test"]="Testing :rocket:"

declare -A sorted_logs
declare -A sorted_logs_size

for (( i=0; i < ${#commit_types[@]}; i++ )); do
    sorted_logs_size[$i]=0
done
regex_commit="([^ ].*)( {1})(.*)(\()([^ ].*)(\): )(.*)";

for (( i=0; i < ${#splitted_logs[@]}; i++ )); do
    log=${splitted_logs[i]}
    if [[ $log =~ $regex_commit ]]
    then
        finded=0
        j=0
        while [[ $finded = 0  && $j < ${#commit_types[@]} ]]
        do
            if [ "${BASH_REMATCH[3]}" = "${commit_types[$j]}" ]; then
                finded=1;
                index=${sorted_logs_size[$j]}
                let "sorted_logs_size[$j]++"
                sorted_logs[$j,$index]="**${BASH_REMATCH[5]} :** ${BASH_REMATCH[7]} ([${BASH_REMATCH[1]}](https://github.com/$repository/commit/${BASH_REMATCH[1]}))";
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

for (( i=0; i < ${#commit_types[@]}; i++ )); do
    if [[ ${sorted_logs_size[$i]} > 0 ]]; then
        echo "## ${commit_types_text[${commit_types[$i]}]}" >> temp
        for (( j=0; j < ${sorted_logs_size[$i]}; j++ )); do
            echo "- ${sorted_logs[$i,$j]}" >> temp
        done
    fi
done

cat temp | cat - CHANGELOG.md >> temp2 && mv temp2 CHANGELOG.md
rm temp

git add CHANGELOG.md
git commit -m "Auto generated CHANGELOG"
git remote add upstreamSecured https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$repository
git push -u upstreamSecured HEAD:${GITHUB_REF}
