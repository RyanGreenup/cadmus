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
    check_for_dependencies
    arguments  "${@}"
    SkimAndGrep

}

# ** Helper Functions
# *** Skim and Grep, the important stuff
ActualWork () {

echo "I am a Template"

}

#
#
# *** Set variables below main
setVars () {
    readonly script_name=$(basename "${0}")
    readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)
}

# *** Interpret arguments
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

# *** Print Help

Help () {


    echo
    echo -e "    \e[3m\e[1m    NoteFind.sh \e[0m; Helpful Shell Scripts for Markdown Notes"
    echo -e "    \e[1;31m -------------------------\e[0m "
    echo

    echo -e "        \e[1;91m    \e[1m Binding \e[0m\e[0m \e[1;34m┊┊┊ \e[0m Description "
    echo -e "        ..............\e[1;34m┊┊┊\e[0m........................................... "
    echo -e "        \e[1;95m Ctrl - q \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Search \e[0m with \e[0m\e[3mripgrep\e[0m"
    echo -e "        \e[1;93m Ctrl - w \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Copy \e[0m the Full Path to the Clipboard"
    echo -e "        \e[1;93m Alt  - w \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Copy \e[0m the Relative Path to the Clipboard"
    echo -e "        \e[1;94m Alt  - e \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Open \e[0m in Emacs"
    echo -e "        \e[1;94m Alt  - v \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Open \e[0m in VSCode"
    echo -e "        \e[1;94m Ctrl - o \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Open \e[0m in Default Program"
    echo

    echo -e "    \e[3m\e[1m• Compatability \e[0m "
    echo
    echo -e "        This uses \e[1mtmpfs\e[0m at \e[1m /dev/shm\e[0m, this should work on \e[3mArch\e[0m, \e[3mFedora\e[0m and \e[3mUbuntu\e[0m, I don't know about  \e[3mMacOS\e[0m "
    echo
        exit 0
}


# *** Check for Dependencies
check_for_dependencies () {

    for i in ${DependArray[@]}; do
        command -v "$i" >/dev/null 2>&1 || { echo >&2 "I require $i but it's not installed.  Aborting."; exit 1; }
    done


}

# **** List of Dependencies

declare -a DependArray=(
                      "rg"
                      "sk"
                      "mdcat"
                      "xclip"
                       )


## * Call Main Function
main "${@}"
