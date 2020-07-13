#! /usr/bin/env bash
#
# Author: Ryan Greenup <ryan.greenup@protonmail.com>

# * Shell Settings
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# * Main Function
main() {
    setVars
    arguments  "${@}"
    SkimAndGrep

}

# ** Helper Functions
# *** Skim and Grep, the important stuff
SkimAndGrep () {

    ramtmp="$(mktemp -p /dev/shm/)"
    sk -c "echo {} > "${ramtmp}" ; rg -t markdown -l --ignore-case (cat "${ramtmp}")" \
        --preview "mdcat {} 2> /dev/null | \
                        rg -t markdown --colors 'match:bg:yellow' \
                        --no-line-number --ignore-case --pretty --context 20 (cat "${ramtmp}")" \
                        --bind 'ctrl-f:interactive,pgup:preview-page-up,pgdn:preview-page-down,ctrl-y:execute-silent(echo {} | xargs realpath | xclip -selection clipboard)'
        ## Add -i to make it interactive from the start
        ## C-q toggles interactive
        ## C-y Copies Full path to clipboard
}

#
#
# *** Set variables almost globally
setVars () {
    readonly script_name=$(basename "${0}")
    readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)
}

## *** Interpret arguments
arguments () {
    while test $# -gt 0
    do
        case "$1" in
            --help) Help
                ;;
            -h) Help
                ;;
            --*) echo "bad option $1 in "${script_name}""
                ;;
            *) echo -e "argument \e[1;35m${1}\e[0m has no definition."
                ;;
        esac
        shift
    done
}

## *** Print Help

Help () {


    echo
    echo -e "    \e[3m\e[1m    NoteFind.sh \e[0m; Helpful Shell Scripts for Markdown Notes"
    echo -e "    \e[1;31m -------------------------\e[0m "
    echo

    echo -e "        \e[1;91m    \e[1m Binding \e[0m\e[0m \e[1;34m┊┊┊ \e[0m Description "
    echo -e "        ..............\e[1;34m┊┊┊\e[0m........................................... "
    echo -e "        \e[1;93m Ctrl - y \e[0m \e[1;34m   ┊┊┊ \e[0m Copy the Full Path to the Clipboard"
    echo -e "        \e[1;32m Ctrl - e \e[0m \e[1;34m   ┊┊┊ \e[0m Copy the Relative path to the clipboard"
    echo -e "        \e[1;33m Ctrl - q \e[0m \e[1;34m   ┊┊┊ \e[0m Toggle Searching with ripgrep"

    echo

    echo -e "    \e[3m\e[1m• Compatability \e[0m "
    echo
    echo -e "        This uses \e[1mtmpfs\e[0m at \e[1m /dev/shm\e[0m, this should work on \e[3mArch\e[0m, \e[3mFedora\e[0m and \e[3mUbuntu\e[0m, I don't know about  \e[3mMacOS\e[0m "
    echo
        exit 0
}

## * Call Main Function
main "${@}"
