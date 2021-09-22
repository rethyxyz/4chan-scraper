#!/bin/bash

#
# Variables
#
INDEX_COUNTER=0

FILE_EXTENSIONS=(\
    "png"
    "gif"
    "jpg"
    "jpeg"
    "webm"\
)

[ ! "$1" ] && {\
    printf ":: No arguments given.\n"
    printf ":: Ensure you've provided arguments, then rerun %s\n" "$0"
}

for ARG_URL in "$@"; do
    for EXTENSION in ${FILE_EXTENSIONS[@]}; do
        # Get the urls that match the extension.
        URLS=$(\
            curl -s "$ARG_URL" \
            | pup "a attr{href}" \
            | grep "$EXTENSION" \
            | sed "s/^\/\///g"\
        )

        for URL in ${URLS[@]}; do
            BASENAME="${URL##*/}"

            [ ! $(echo "$URL" | grep "^http") ] && \
                URL="https://$URL"

            curl "$URL" > "$BASENAME"
        done

    done

done
