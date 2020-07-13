#! /usr/bin/env bash
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
#{{{ Bash settings
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail
#}}}
#{{{ Variables
IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)

#}}}

main() {

    [[ -z "${1:-}" ]] && mainHelp
    setvars
    arguments  "${@}"

}

function setvars() {

    readonly script_name=$(basename "${0}")
    readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    readonly TERMINAL="kitty"
    readonly TERMINAL_EXEC='kitty -- '
   
}

function mainHelp() {

##    echo -e " \u001b[45;1m \e[1;31m -------------------------\e[0m \u001b[0m \e[1;31m find \e[0m \e[1;34m"
##
    echo
    echo -e "    \e[3m\e[1m    Cadmus\e[0m; Helpful Shell Scripts for Markdown Notes"
    echo -e "    \e[1;31m -------------------------\e[0m "
    echo

    echo -e " \e[1;91m    \e[1m Command \e[0m\e[0m \e[1;34m┊┊┊ \e[0m Description "
    echo -e " ..............\e[1;34m┊┊┊\e[0m........................................... "
    echo -e " 🔍 \e[1;93m find \e[0m \e[1;34m    ┊┊┊ \e[0m Find Notes based on FileName"
    echo -e " 🔎 \e[1;32m search \e[0m \e[1;34m  ┊┊┊ \e[0m Search through Notes using Recoll"
    echo -e " 🏷  \e[1;33m tags \e[0m \e[1;34m    ┊┊┊ \e[0m Use TMSU to work with tags"
    echo -e " 🔧 \e[1;34m tools \e[0m \e[1;34m   ┊┊┊ \e[0m Tools for Editing"
    echo -e " 📝 \e[1;35m export \e[0m \e[1;34m  ┊┊┊ \e[0m Export Notes to Different Formats "
    echo -e " ⎋  \e[1;36m convert \e[0m \e[1;34m ┊┊┊ \e[0m Convert Clipboard Contents to Different Formats "
    echo -e " 🧰 \e[1;37m Misc \e[0m \e[1;34m    ┊┊┊ \e[0m Miscelanneous Tools nice to have on hand "
    echo -e " 🌏  \e[1;92m publish\e[0m \e[1;34m ┊┊┊ \e[0m Publish with \e[1;34m \e[4m\e[3mMkDocs\e[0m\e[0m🐍"
    echo -e " 🕮 \e[1;92m preview \e[0m \e[1;34m  ┊┊┊ \e[0m Preview with \e[1;34m \e[4m\e[3mMarkServ\e[0m\e[0m "

    echo
    }

#{{{ Helper functions

arguments () {

    while test $# -gt 0
    do
        case "$1" in
            --help) Help
                ;;
            -h) Help
                ;;
            find) find
                ;;
            --opt4) echo "option 4"
                ;;
            --opt5) echo "option 5"
                ;;
            --opt6) echo "option 6"
                ;;
            --opt7) echo "option 7"
                ;;
            --opt8) echo "option 8"
                ;;
            --opt9) echo "option 9"
                ;;
            --opt10) echo "option 10"
                ;;
            --*) echo "bad option $1"
                ;;
            *) echo -e "argument \e[1;35m${1}\e[0m has no definition."
                ;;
        esac
        shift
    done
}

mytest() {
    echo "This is a test"
    exit 0
}

Help () {
        # Display Help
        echo "Add description of the script functions here."
        echo
        echo "Syntax: scriptTemplate [-g|h|t|v|V]"
        echo "options:"
        echo "g     Print the GPL license notification."
        echo "h     Print this Help."
        echo "v     Verbose mode."
        echo "V     Print software version and exit."
        exit 0
}

#}}}

main "${@}"

# cursor: 33 del
