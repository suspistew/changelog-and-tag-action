#!/bin/bash
declare -A COMMIT_TYPES_TEXT

REGEX_COMMIT="([^ ].*)( {1})(.*)(\()([^ ].*)(\): )(.*)";
COMMIT_TYPES=("feat" "fix" "build" "ci" "docs" "perf" "refactor" "style" "test")

COMMIT_TYPES_TEXT["feat"]="New features :tada:"
COMMIT_TYPES_TEXT["fix"]="Bug fixes :bug:"
COMMIT_TYPES_TEXT["build"]="Build improvements :construction_worker:"
COMMIT_TYPES_TEXT["ci"]="Continuous integration improvements :wrench:"
COMMIT_TYPES_TEXT["docs"]="Documentations :page_facing_up:"
COMMIT_TYPES_TEXT["perf"]="Performance improvements :fire:"
COMMIT_TYPES_TEXT["refactor"]="Refactoring :repeat:"
COMMIT_TYPES_TEXT["style"]="New style :art:"
COMMIT_TYPES_TEXT["test"]="Testing :rocket:"


function get_changelog_line_from_commit {
    echo "**${BASH_REMATCH[5]} :** ${BASH_REMATCH[7]} ([${BASH_REMATCH[1]}](https://github.com/$REPOSITORY/commit/${BASH_REMATCH[1]}))";    
}

function create_changelog {
    echo "# $NEXT_TAG" >> temp2

    for (( i=0; i < ${#COMMIT_TYPES[@]}; i++ )); do
        if [[ ${SORTED_LOGS_SIZES[$i]} > 0 ]]; then
            echo "## ${COMMIT_TYPES_TEXT[${COMMIT_TYPES[$i]}]}" >> this_release_changelog
            for (( j=0; j < ${SORTED_LOGS_SIZES[$i]}; j++ )); do
                echo "- ${SORTED_LOGS[$i,$j]}" >> this_release_changelog
            done
        fi
    done
}
