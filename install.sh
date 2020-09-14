#!/usr/bin/env bash
INSTALL_DIR="$HOME/.cadmus"
BIN_DIR="$HOME/.local/bin/"
mkdir "${BIN_DIR} > /dev/null

main () {
    me=`basename "$0"`

      HelpStatement $1
      UninstallQ $1
    printThis
    download_the_repo
    Install_bin
    check_path
    check_for_dependencies

    echo -e "\nInstallation Complete \n"
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
    echo -e "To uninstall do `basename $0` --rm ,

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


    echo -e "\nAre you happy to proceed? Press y to continue \n"
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

    ## echo "Press Any Key to Check for dependencies, press the c Key to Skip this"
    ## read -d '' -s -n1 CheckDepQ
    ## if [ "$CheckDepQ" == "c" ]; then
    ##     return
    ## fi
    ##
    depLog="$(mktemp)"

    for i in ${StringArray[@]}; do
        command -v "$i" >/dev/null 2>&1 || { echo $i >> "${depLog}"; }
    done

    if [[ $(cat "${depLog}") == "" ]]; then
        echo -e "\nAll Dependencies Satisfied\n"
    else
        echo -e "\e[1;31m \nMissing the Following Dependencies \e[0m \n"
        echo -e "    \e[1;31m -------------------------\e[0m "
        echo -e "\e[1;32m \n"
        addBullets "$(cat "${depLog}")"
        echo -e "\e[0m \n"
        echo -e "They are listed in \e[1;34m "${depLog}" \e[0m \n"
    fi
}


addBullets() {
    command -v sed    >/dev/null 2>&1 || { echo >&2 "I require sed but it's not installed.  Aborting."; exit 1; }
    echo "$1" | sed 's/^/\t‣\ /g'
}

download_the_repo () {

    if [[ -d "${INSTALL_DIR}" ]]; then
        echo -e "Detected a cadmus install"

        if [ -f "${INSTALL_DIR}/config.json" ]; then
            oldConfigFile="$(mktemp)" && cat "${INSTALL_DIR}/config.json" > "${oldConfigFile}"
            echo -e "\n\tConfig File Backed up for later restore\n"
        fi

        ask_to_remove
        download_the_repo
        return
    else
        git clone https://github.com/RyanGreenup/cadmus "$HOME/.cadmus"
    fi

    echo -e "Repository is downloaded\n\n"

    if [[ "$CheckDepQ" == "y" ]] && [[ -f "${oldConfigFile}" ]]; then
        echo -e "Press y to restore the old config or any other key to continue otherwise\n"
        read -d '' -s -n1 CheckDepQ
        cp "${oldConfigFile}" "${INSTALL_DIR}/config.json"
        echo -e "Config Successfully restored"
    fi
}

ask_to_remove () {
    echo "press y to remove "${INSTALL_DIR}""

    read -d '' -s -n1 CheckDepQ
    if [ "$CheckDepQ" == "y" ]; then
            rm -rf "${INSTALL_DIR}"
    else
        exit 1
    fi
}

Install_bin() {
    if [ -f "${BIN_DIR}/cadmus" ]; then
        echo -e "The executable \e[1;32m "${BIN_DIR}"/cadmus \e[0m already exists, it must be replaced, press y to continue or any key to exit"
        read -d '' -s -n1 CheckDepQ
        if [ "$CheckDepQ" == "y" ]; then
                rm "${BIN_DIR}/cadmus"
        else
            exit 1
        fi
        Install_bin
    else
        ln -s "$HOME/.cadmus/bin/cadmus" "$HOME/.local/bin/" && echo -e "\nSuccessfully created symlink from $HOME/.cadmus/bin/cadmus to $HOME/.local/bin/ \n"
    fi
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
                        "tectonic"
                        "stow"
                        "python"
                        "tmsu"
                        "ranger"
                        "mdcat"
                        "jq"
                        "shift"
                        "ip"
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
