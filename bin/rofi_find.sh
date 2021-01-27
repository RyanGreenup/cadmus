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
    rofi_over_Notes "${@}"

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
                      "rofi"
                      "rg"
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
    echo -e "    \e[3m\e[1mNoteFind.sh \e[0m; Helpful Shell Scripts for Markdown Notes"
    echo -e "    \e[1;31m--------------------------\e[0m "
    echo
    echo -e "    \e[3m\e[1m• Usage \e[0m "
    echo
    echo -e "       "${script_name}"   [<path/to/notes>]"
    echo -e "       "${script_name}"   [-h]"
    echo -e "       "${script_name}"   [--help]"
    echo
    echo -e "           \e[3m By Design: No Options; No other Arguments\e[0m"
    echo
    # echo -e "    \e[3m\e[1m• Key Bindings\e[0m "
    # echo
    # echo
    # echo -e "        \e[1;91m    \e[1m Binding \e[0m\e[0m \e[1;34m┊┊┊ \e[0m Description "
    # echo -e "        ..............\e[1;34m┊┊┊\e[0m........................................... "
    # echo -e "        \e[1;95m Ctrl - q \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Search \e[0m with \e[0m\e[3mripgrep\e[0m"
    # echo -e "        \e[1;93m Ctrl - w \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Copy \e[0m the Full Path to the Clipboard"
    # echo -e "        \e[1;93m Alt  - w \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Copy \e[0m the Relative Path to the Clipboard"
    # echo -e "        \e[1;94m Alt  - e \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Open \e[0m in Emacs"
    # echo -e "        \e[1;94m Alt  - v \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Open \e[0m in VSCode"
    # echo -e "        \e[1;94m Ctrl - o \e[0m \e[1;34m   ┊┊┊ \e[0m \e[1m Open \e[0m in Default Program"
    # echo

    # echo -e "    \e[3m\e[1m• Compatability \e[0m "
    # echo
}


# *** Read First Argument
readFirstArgument () {

    if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "" ]]; then
        Help && exit 0
    fi

}
# *** Skim and Grep, the important stuff
#
rofi_over_Notes () {

    ## Change directory if One was specified, exit if no directory exists

    cd "${1}"

    FILE="$(RofiFind)"

    if [[ $FILE != "" ]]; then
        realpath $FILE && exit 0
    fi


    exit 0

}

# **** Skim with Grep
RofiFind () {

    ## Change directory if One was specified, exit if no directory exists

    # I took this bit from https://github.com/davatorium/rofi/issues/997
        #  Not totally sure how it works but it does :shrug

    ## Set Variables
    local selected
    local string
    selected="${1:-}"

    TEMP_DIR="/tmp/cadmus_rofi_preview"
    mkdir -p "${TEMP_DIR}"

#    schemes="$(fd '\.org$')" # TODO Only look at org-mode files (hmmmm)
    schemes="$(find ./ -name '*\.org' -or -name '*\.md')"
    lines=$(printf '%s\n' "${schemes}" | wc -l)
    menu=$(printf '%s\n' "${schemes}"  | rofi -matching fuzzy -location 1 -kb-row-up "" -kb-row-down "" -kb-custom-1 "Up" -kb-custom-2 "Down" -format 'd:s' -dmenu -selected-row $selected)

    exit_code=$?

    selected="${menu%:*}"
    string="${menu##*:}"

    case "${exit_code}" in
        "1") exit 0;;
        "0") PRINT_OUT "${string}" & disown;;
        "10")
            if [[ $selected == "1" ]]; then
                foo_selected="${lines}"
                call="3"
            else
                foo_selected="$(echo -e $(( ${selected} - 1 )))";
                call=$(echo $(( ${selected} - 2 )))
            fi
            foo="$(printf '%s' "${schemes}" | sed -n "${foo_selected}"p)";
            PRINT_OUT "${foo}" & disown;;
        "11")
            if [[ "${selected}" -ge "${lines}" ]]; then
                foo_selected="1"
                call="0"
            else
                foo_selected="$(echo -e $(( ${selected} + 1 )))";
                call="${selected}"
            fi
            foo="$(printf '%s' "${schemes}" | sed -n "${foo_selected}"p)";
            PRINT_OUT "${foo}" & disown
    esac

    RofiFind "${call}"

    exit 0

}

# **** Convert the File with Pandoc and Show in Browser
PRINT_OUT () {
    FILEPATH="$(realpath ${1})"
    FILEPATH_NO_EXT="$(realpath ${1} | cut -f 1 -d '.')"
    DIRECTORY="$(dirname ${FILEPATH}})"
    NAME="$(basename ${@} | cut -f 1 -d '.')"

    BROWSER="chromium"

    # Simpler calls
    #    pandoc -f org -t html "${FILEPATH}" --quiet | cat

    function pandoc_browser() {
        #pandoc -f org -t html "${FILEPATH}" -A /home/ryan/Templates/CSS/gitOrgWrapped.css --mathjax -s --quiet -o "/dev/shm/${NAME}.html" && \
        pandoc -t html  "${FILEPATH}" --extract-media="${TEMP_DIR}/media_${NAME}" -A /home/ryan/Templates/CSS/gitOrgWrapped.css --katex -s --quiet -o "${TEMP_DIR}/${NAME}.html" && \
        "${BROWSER}" "${TEMP_DIR}/${NAME}.html" > /dev/null & disown # Chromium is faster than firefox
    }

    ## By caching the export in /dev/shm/ chrome will just go back to the last tab (quicker)
    ## and pandoc won't reconvert unnecessarily (quicker)
    ## Given that most of the time is spent looking and reading this makes a lot of sense

    if [ "${FILEPATH}" -nt "${TEMP_DIR}/${NAME}.html" ]; then
        # The Live_Reload_JS lets me reload this, otherwise do not disown this process
        pandoc_browser & disown
    else
        "${BROWSER}" "${TEMP_DIR}/${NAME}.html" & disown
    fi

    # I tried this with org-ruby, no luck though for latex though
    # Org-ruby is much faster than pandoc
    # /home/ryan/.gem/ruby/2.7.0/bin/org-ruby "${FILEPATH}" -t html  > /dev/shm/mpv.html
    # cat /home/ryan/Templates/mathjax >> /dev/shm/mpv.html
    # cat /home/ryan/Templates/CSS/gitOrgWrapped.css >> /dev/shm/mpv.html
    # chromium /dev/shm/mpv.html & disown


}


# * Call Main Function
main "${@}"
