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
    readonly NOTES_DIR="$HOME/Notes"
   
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
    echo -e " 🧰 \e[1;37m misc \e[0m \e[1;34m    ┊┊┊ \e[0m Miscelanneous Tools nice to have on hand "
    echo -e " 🌏\e[1;92m publish\e[0m \e[1;34m   ┊┊┊ \e[0m Publish with \e[1;34m \e[4m\e[3mMkDocs\e[0m\e[0m🐍"
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
            find) NoteFind ## Don't steal function name
                ;;
            search) echo "begin note search"
                ;;
            tags) echo "begin tags"
                ;;
            tools) echo "begin tools"
                ;;
            export) echo "begin export"
                ;;
            convert) echo "begin convert"
                ;;
            misc) echo "begin misc"
                ;;
            publish) echo "begin publish"
                ;;
            preview) echo "begin preview"
                ;;
            --*) echo "bad option $1"
                ;;
            *) echo -e "argument \e[1;35m${1}\e[0m has no definition."
                ;;
        esac
        shift
    done
}

function NoteFind() {
## sk --ansi -i -c 'rg -l -t markdown  "{}"' --preview "mdcat {}"  \
##        --bind pgup:preview-page-up,pgdn:preview-page-down

    ## This is Slow, It should be an option, like option highlight
     ## Open an issue on Github
    sk -i -c "echo {} > /tmp/skVar ; rg -t markdown -l --ignore-case (cat /tmp/skVar)" --preview "mdcat {} 2> /dev/null | rg -t markdown --colors 'match:bg:yellow' --no-line-number --ignore-case --pretty --context 9999999 (cat /tmp/skVar)"         --bind pgup:preview-page-up,pgdn:preview-page-down


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
