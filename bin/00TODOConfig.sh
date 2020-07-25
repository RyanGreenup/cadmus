#!/usr/bin/env bash
set -euo pipefail

conlook () {
    if [[ -f ./.config.json ]]; then
        CONFIG="./config.json"
        return
    elif [[ CONFIG == "" ]]
         if [[ "$(pwd)" == "/" ]]; then
             CONFIG="~/.config/cadmus/config.json"
         else
             cd ..
         fi
         conlook
}
