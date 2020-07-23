#! /usr/bin/env bash
#
# Author: Ryan Greenup <ryan.greenup@protonmail.com>

# * Shell Settings
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# * Main Function
main() {

    # Use STDERR so as to not clog STDIN
    # Is there a better way to do this?
    echoerr() { echo -e "$@" 1>&2; }


    check_for_dependencies
    setVars
    readFirstArgument "${@}"
    AskValues

    if [ "${promptComplete}" != "Completed" ]; then
        exit 1
    fi

    MakeConfig "${@}"

}

# ** Helper Functions
# *** Check for Dependencies
check_for_dependencies () {

    for i in ${DependArray[@]}; do
        command -v "$i" >/dev/null 2>&1 || { echo >&2 "I require $i but it's not installed.  Aborting."; exit 1; }
    done


}

# **** List of Dependencies

declare -a DependArray=(
                      "jq"
                      "cat"
                      "xclip"
                       )


# *** Set variables below main
setVars () {
    readonly script_name=$(basename "${0}")
    readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)
}

# **** Print Help
Help () {


    echo
    echo -e "    \e[3m\e[1mMakeConfig.sh \e[0m; Helpful Shell Scripts for Markdown Notes"
    echo -e "    \e[1;31m--------------------------\e[0m "
    echo
    echo -e "    \e[3m\e[1m• Usage \e[0m "
    echo
    echo -e "       "${script_name}"   [-h]"
    echo -e "       "${script_name}"   [--help]"
    echo
    echo -e "       Fully Interactive, just follow the prompts"
    echo
    echo -e "           \e[3m By Design: No Options; No Arguments\e[0m"
    echo
    echo -e "    \e[3m\e[1m• Compatability \e[0m "
    echo
    echo -e "        This prints everything to STDERR to that STDOUT only has"
    echo -e "        The config file in it, I'm not sure if that's an issue "
    echo
        exit 0
}


# *** Read First Argument
readFirstArgument () {

    if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]]; then
        Help && exit 0
    fi

}

# ***
AskValues () {
    echoerr "Please Enter the Directory of you Markdown Files"
    echoerr "\t (This directory should contain index.md or home.md)"
     read -e NOTES_DIR
     NOTES_DIR="$(echo "${NOTES_DIR/\~/$HOME}")"
     read -d '' -s -n1 choice
#    NOTES_DIR="$(cd /; sk --height 40% -i -c 'fd {}' )"
    [[ -d "${NOTES_DIR}" ]] || echoerr -e "\n \e[3m\e[1m \e[1;31m ⚠ WARNING: \e[0m No Such Directory!"


    echoerr "\nPlease Enter the Directory of the recoll config you want to use"
    echoerr "\t Leave it blank to use the default config"
    echoerr "\t This is not implemented so don't worry"
    read -e RECOLL_CONFIG_DIR
    RECOLL_CONFIG_DIR="$(echo "${RECOLL_CONFIG_DIR/\~/$HOME}")"
    [[ -d "${RECOLL_CONFIG_DIR}" ]] || echoerr "\n \e[3m\e[1m \e[1;31m ⚠ WARNING: \e[0m No Such Directory!"

    echoerr "\nPlease Enter the location of your mkdocs yml"
    echoerr "\t (If you're not going to use this just leave it blank and press Enter)"
    read -e MKDOCS_YML
    MKDOCS_YML="$(echo "${MKDOCS_YML/\~/$HOME}")"
    [[ -f "${MKDOCS_YML}" ]] || echoerr -e "\n \e[3m\e[1m \e[1;31m ⚠ WARNING: \e[0m No Such File!"

    echoerr "\nPlease Enter the Directory in which you want mkdocs to build your static site"
    echoerr "\t (If you're not going to use this just leave it blank and press Enter)"
    read -e SERVER_DIR
    SERVER_DIR="$(echo "${SERVER_DIR/\~/$HOME}")"
    [[ -d "${SERVER_DIR}" ]] || echoerr -e "\n \e[3m\e[1m \e[1;31m ⚠ WARNING: \e[0m No Such Directory!"

    promptComplete="Completed"

}
# *** Make Config
MakeConfig () {

JSON_STRING=$( jq -n \
                  --arg nd "$NOTES_DIR" \
                  --arg sd "$SERVER_DIR" \
                  --arg rc "$RECOLL_CONFIG_DIR" \
                  --arg mk "$MKDOCS_YML" \
                  '{notesDir: $nd, serverDir: $sd, recollConfigDir: $rc, mkdocsConfigDir: $mk}' )

    echo "$JSON_STRING"

    exit 0
}

# * Call Main Function
main "${@}"
