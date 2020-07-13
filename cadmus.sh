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
readonly script_name=$(basename "${0}")
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)

#}}}

main() {
    arguments  "${@}"

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
            mytest) ${1}
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
