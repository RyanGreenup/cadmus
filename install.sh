#!/usr/bin/env bash
INSTALL_DIR="$HOME/.cadmus"

main () {
    me=`basename "$0"`

      HelpStatement $1
      UninstallQ $1
    printThis
    download_the_repo
    Install_bin
    check_path
    check_for_dependencies
}

check_path () {
    echo "$PATH" | grep -q '.local/bin' || echo "bin-dir is not in path, you'll need to add it to the path"
}

function UninstallQ() {

    if [ "$1" == "-rm" ] || [ "$1" == "--rm"  ]; then
        echo "Removing..."
        rm "$HOME/.local/bin/cadmus"
        rm "${INSTALL_DIR}"
        exit 0
    fi

}

HelpStatement() {

    if [ "$1" == "-h" ] || [ "$1" == "--help"  ]; then
    echo -e "To uninstall do `basename $0` --rm is the script name,

If you are on Arch stow 2.3.1-2 is broken, downgrade with

\e[1;35m
    sudo pacman -U https://archive.archlinux.org/packages/s/stow/stow-2.2.2-5-any.pkg.tar.xz
\e[0m

See this for more information:

\e[1;34m
    https://github.com/aspiers/stow/issues/65
\e[0m

        "
    fi
}

printThis () {

    echo "This Script will print to the terminal for review, press any key to continue"
    read -d '' -s -n1

    cd $(dirname "$0")
    pwd
    me=`basename "$0"`
    safePrint $me


    echo "Are you happy to proceed? Press y to continue"
    read -d '' -s -n1 proceedQ
    if [ "$proceedQ" != "y" ]; then
        exit 0
    fi
}

safePrint () {
    if hash highlight 2>/dev/null; then
        highlight "${1}" --syntax=bash --stdout
    else
        cat "${1}"
    fi
}


check_for_dependencies () {

    echo "Missing dependencies will now be printed to STDERR, missing packages to STDOUT"

    ## echo "Press Any Key to Check for dependencies, press the c Key to Skip this"
    ## read -d '' -s -n1 CheckDepQ
    ## if [ "$CheckDepQ" == "c" ]; then
    ##     return
    ## fi
    ##
    depLog="$(mktemp)"

    for i in ${StringArray[@]}; do
        command -v "$i" >/dev/null 2>&1 || { echo >&2 "I require $i but it's not installed.  Aborting."; echo $i >> "${depLog}"; }
    done

    if [[ $(cat "${depLog}") == "" ]]; then
        echo "All Dependencies Satisfied"
    else
        cat "${depLog}"
    fi
}

download_the_repo () {

    echo "Press y to download the repo"
    read -d '' -s -n1 downloadQ
    if [ "$downloadQ" != "y" ]; then
        return
    fi

    if [[ -d "${INSTALL_DIR}/.git" ]]; then
        echo "Detected a cadmus install"
        ask_to_remove
    elif [[ -f ".git" ]]; then
        echo "You have a file called .git In "${INSTALL_DIR}", which was unexpected"
        ask_to_remove
    else
        git clone https://github.com/RyanGreenup/cadmus "~/.cadmus"
    fi

    echo "Repository is downloaded"

}

ask_to_remove () {
    echo "press y to remove "${INSTALL_DIR}""

    read -d '' -s -n1 CheckDepQ
    if [ "$CheckDepQ" != "y" ]; then
            rm -rf "${INSTALL_DIR}"
    else
        exit 1
    fi
}

Install_bin() {
    ln -s "$HOME/.cadmus/bin/cadmus" "$HOME/.local/bin/"
}

# Declare an array of string with type
declare -a StringArray=(
                        "highlight"
                        "node"
                        "nvim"
                        "fzf"
                        "code"
                        "sk"
                        "rg"
                        "perl"
                        "stow"
                        "python"
                        "tmsu"
                        "ranger"
                        "mdcat"
                        "jq"
                        "shift"
                        "xclip"
                        "sd"
                        "fd"
                        "sed"
                        "cut"
                        "grep"
                        "find"
                        "realpath"
                       )

# Iterate the string array using for loop
##

main "$@"
exit 0

## DONE Help
## DONE Uninstall
