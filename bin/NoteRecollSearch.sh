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
    NoteSearchRecoll "${@}"

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
                      "bat"
                      "sk"
                      "recoll"
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
    echo -e "    \e[3m\e[1m ${script_name}\e[0m; Helpful Shell Scripts for Markdown Notes"
    echo -e "    \e[1;31m--------------------------\e[0m "
    echo
    echo -e "    \e[3m\e[1m• Usage \e[0m "
    echo
    echo -e "       "${script_name}"   [<path/relative/Dir>]"
    echo -e "       "${script_name}"   [-h]"
    echo -e "       "${script_name}"   [--help]"
    echo
    echo -e "           \e[3m By Design: No Options; No other Arguments\e[0m"
    echo
    echo -e "    \e[3m\e[1m• Key Bindings\e[0m "
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
    echo -e "    \e[3m\e[1m• Notes\e[0m "
    echo
    echo -e "        Often path names are too long to see in sk, "
    echo -e "        although they do provide meaningful context,"
    echo -e "        by displaying the pathnames relative from some directory"
    echo -e "        this is somewhat addressed."
    echo -e "        Absolute Paths are still returned for stability though."
    echo
    echo -e "        Highlighting only works on the first word, I can't think of an easy"
    echo -e "        way to convert a list of values ("dog" "fox" "jump") and then perform "
    echo -e "        bat {} | rg -e dog -e fox -e jump " | highlight --syntax bash -O ansi
    echo
    echo -e "    \e[3m\e[1m• Compatability \e[0m "
    echo
    echo -e "        This uses realpath from GNU coreutils, which doesn't"
    echo -e "        come with MacOS out of the box"
    echo
    echo -e "        This doesn't work: "
    echo -e '            rg "$(echo {cq} | rg "$(echo $var | sed s+\ +\|+g )") ' | highlight --syntax bash -O ansi
    echo

}


# *** Read First Argument
readFirstArgument () {

    if [[ "${1:-}" == "-h" ]] || [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "" ]]; then
        Help && exit 0
    fi

}
# *** Note Recoll Search
NoteSearchRecoll () {

    ## Change directory if One was specified, exit if no directory exists
    cd "${1}"


    ## I really really like this one!!
    ## Display Path Relative to Notes Dir
#    sk -i -c 'recoll -b -t -q "ext:md" {} | cut -c 8- | sd '^' 'realpath "' | sd '$' '" --relative-to "./"' | bash ' --bind pgup:preview-page-up,pgdn:preview-page-down --preview "bat --color=always --line-range :500 --terminal-width 80 --theme=Dracula {}"
#    Better Theme
    RelativePath () {
        sk -m -i -c 'recoll -b -t -q "ext:md OR ext:org" {}                 |\
                cut -c 8- | sed s/^/realpath\ \"/                     |\
                sed s+\$+\"\ --relative-to\ \"./\"+ | bash'            \
            --bind pgup:preview-page-up,pgdn:preview-page-down    \
            --preview "bat --color=always --line-range :500           \
                    --terminal-width 80 --theme=TwoDark {+}           \
                    --italic-text=always                              \
                    --decorations=always"                             \
            --color=fg:#f8f8f2,bg:-1,matched:#6272a4,current_fg:#50fa7b,current_bg:#381070,border:#ff79c6,prompt:#bd93f9,query:#bd93f9,marker:#f1fa8c,header:#f1fa8c
    }
    RELATIVE_PATH="$(RelativePath)"

    echo "${RELATIVE_PATH}" | xargs realpath
##    ## Display full path
##    sk -i -c 'recoll -b -t -q "ext:md {}" | cut -c 8-' --bind pgup:preview-page-up,pgdn:preview-page-down --preview "bat --color=always --line-range :500 --terminal-width 80 --theme=Dracula {}"
##
##
##    ## Display only file name
##    ##
##    sk -i -c 'recoll -b -t -q "ext:md" | cut -c 8-  | sd \'^\' \'"\' | sd \'$\' \'"\' | sd \'^\' \'basename \' | bash' --bind pgup:preview-page-up,pgdn:preview-page-down --preview "echo {} | xargs fd |  xargs bat --color=always --line-range :500 --terminal-width 80 --theme=Dracula "

    exit 0
}

# * Call Main Function
main "${@}"
