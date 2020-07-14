#! /usr/bin/env bash
#
# Author: Ryan Greenup <ryan.greenup@protonmail.com>

# * Shell Settings
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# * Main Function
main() {

    check_for_dependencies
    setVars
    readFirstArgument "${@}"
    SkimNotes "${@}"

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
                      "rg"
                      "sk"
                      "mdcat"
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
    echo -e "    \e[3m\e[1m    NoteFind.sh \e[0m; Helpful Shell Scripts for Markdown Notes"
    echo -e "    \e[1;31m -------------------------\e[0m "
    echo
    echo -e "    \e[3m\e[1m• Usage \e[0m "
    echo
    echo -e "       "${script_name}"   [<path/to/notes>]"
    echo -e "       "${script_name}"   [-h]"
    echo -e "       "${script_name}"   [--help]"
    echo
    echo -e "           \e[3m By Design: No Options; No other Arguments\e[0m"
    echo
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
    echo -e "        Match highlighting occurs automatically if \e[1m\$SHELL\e[0m is \e[1m **/fish\e[0m"
    echo -e "        This uses \e[1mtmpfs\e[0m at \e[1m /dev/shm\e[0m, this should work on \e[3mArch\e[0m, \e[3mFedora\e[0m and \e[3mUbuntu\e[0m, I don't know about  \e[3mMacOS\e[0m "
    echo
}


# *** Read First Argument
readFirstArgument () {

    if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "" ]]; then
        Help && exit 0
    fi

}
# *** Skim and Grep, the important stuff
SkimNotes () {

    ## Change directory if One was specified, exit if no directory exists
   
    cd "${1}"

    ## If using fish, cleverness can be utilised to highlight matches.
    ## fish only, not zsh or bash

    if [[ "$(basename $SHELL)" == "fish" ]]; then
        FILE="$(SkimGrepHighlightFish)"
        if [[ $FILE != "" ]]; then
            realpath $FILE && exit 0
        else
            exit 1
        fi
    else
        FILE="$(SkimGrep)" 
        if [[ $FILE != "" ]]; then
            realpath $FILE && exit 0
        else
            exit 1
        fi
    fi


    exit 0

}

# **** Skim with Highlight of Grep for Fish
SkimGrepHighlightFish () {

    ramtmp="$(mktemp -p /dev/shm/)"
    sk -c "echo {} > "${ramtmp}" ; rg -t markdown -l --ignore-case (cat "${ramtmp}")" \
        --preview "mdcat {} 2> /dev/null | \
                        rg -t markdown --colors 'match:bg:30,200,30' --colors 'match:fg:21,39,200'\
                        --colors 'match:style:bold'  --colors 'line:style:nobold' \
                        --no-line-number --ignore-case --pretty --context 20 (cat "${ramtmp}")" \
                        --bind 'ctrl-f:interactive,pgup:preview-page-up,pgdn:preview-page-down' \
                        --bind 'ctrl-w:execute-silent(echo {} | xargs realpath | xclip -selection clipboard),alt-w:execute-silent(echo {} | xclip -selection clipboard)' \
                        --bind 'alt-v:execute-silent(code {}),alt-e:execute-silent(emacs {}),ctrl-o:execute-silent(xdg-open {})' \
                        --bind 'alt-y:execute-silent(cat {} | xclip -selection clipboard)' \
                        --bind 'alt-o:execute-silent(cat {} | pandoc -f markdown -t html --mathml | xclip -selection clipboard)' \
                        --bind 'alt-f:execute-silent(echo {} | xargs dirname | xargs cd; cat {} | pandoc -f markdown -t dokuwiki --mathml | xclip -selection clipboard)' \
        ## TODO This should be emacsclient
        ## TODO This should be emacsclient
        ## Add -i to make it interactive from the start
        ## C-q toggles interactive
        ## C-y Copies Full path to clipboard
}


# **** Skim with Grep
SkimGrep () {

    sk --ansi -c 'rg -l -t markdown --ignore-case "{}"' --preview "mdcat {}" \
                        --bind 'ctrl-f:interactive,pgup:preview-page-up,pgdn:preview-page-down' \
                        --bind 'ctrl-w:execute-silent(echo {} | xargs realpath | xclip -selection clipboard),alt-w:execute-silent(echo {} | xclip -selection clipboard)' \
                        --bind 'alt-v:execute-silent(code {}),alt-e:execute-silent(emacs {}),ctrl-o:execute-silent(xdg-open {})' \
                        --bind 'alt-y:execute-silent(cat {} | xclip -selection clipboard)' \
                        --bind 'alt-o:execute-silent(cat {} | pandoc -f markdown -t html --mathml | xclip -selection clipboard)' \
                        --bind 'alt-f:execute-silent(echo {} | xargs dirname | xargs cd; cat {} | pandoc -f markdown -t dokuwiki --mathml | xclip -selection clipboard)' \

}


# * Call Main Function
main "${@}"
