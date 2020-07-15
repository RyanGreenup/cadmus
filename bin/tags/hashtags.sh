#!/usr/bin/env bash

if [[ $1 != '' ]]; then
    NOTE_DIR="$1"
else
    NOTE_DIR='./'
fi


## Change to directory so paths are relative to notes dir
cd $NOTE_DIR

## We're going to pipe this back into bash, so we need to make sure bash
## changes to the correct directory before running running any
## tmsu commands

echo "cd $NOTE_DIR"

## This will generate the commands to tag the files wit #tags
rg --pcre2 '(?<=\s#)[a-zA-Z]+(?=\s)' -t markdown -o $NOTE_DIR \
        | sed s+:+\ + | sed s/^/tmsu\ tag\ /
