#!/usr/bin/env bash

main() {

    check_for_dependencies
    download_the_repo
}

check_for_dependencies() {

    echo "Press Any Key to Check for dependencies, press the c Key to Skip this"
    return_from_function_Q c
    read -d '' -s -n1 CheckDepQ
    if [ "$CheckDepQ" == "c" ]; then
        return
    fi

    for i in ${StringArray[@]}; do
        command -v "$i" >/dev/null 2>&1 || { echo >&2 "I require $i but it's not installed.  Aborting."; exit 1; }
    done

    echo "All Dependencies Satisfied"

}

download_the_repo() {

    echo "Press y to download the repo"
    read -d '' -s -n1 downloadQ
    if [ "$downloadQ" != "y" ]; then
        return
    fi

    mkdir -p $HOME/DotFiles/
    cd $HOME/DotFiles


    if [[ -d ".git" ]]; then
        echo "Detected a Git Repo, Press y to add a submodule or any key to exit"

        if [ "$CheckDepQ" != "y" ]; then
                exit 1
        fi

        git submodule add https://github.com/RyanGreenup/cadmus

    elif [[ -f ".git" ]]; then
        echo "You have a file called .git In there, delete that first.";
    else
        git clone https://github.com/RyanGreenup/cadmus
    fi

}


# Declare an array of string with type
declare -a StringArray=("R"
                        "highlight"
                        node
                        nvim
                        fzf
                        code
                        sk
                        rg
                        perl
                        stow
                        python
                        tmsu
                        ranger
                        mdcat
                        xclip
                        sd
                        fd
                        sed
                        cut
                        grep
                        find
                        realpath
                       )

# Iterate the string array using for loop
##

main
exit 0
