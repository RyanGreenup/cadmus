#!/usr/bin/env bash
readonly script_name=$(basename "${0}")
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ "${1:-}" != "" ]]; then
    readonly NOTES_DIR="${1}"
else
    readonly NOTES_DIR="./"
fi

function main() {


    DEFAULTAPP=code ## TODO Should this be xdg-open?
    takeArguments $1
    checkDependencies
    regenTags

    ConcurrentTags="$(tmsu tags)"
    FilterTags

    makeSymlinks

    echo -e "
⁍ \e[1;35mv\e[0m      :: Open all matching files with \e[1;35mV\e[0mSCode
⁍ \e[1;35mc\e[0m      :: \e[1;35mC\e[0mhoose a file to open
⁍ AnyKey :: Create Symlinks in $TEMPDIR
"

    openMatches


}

function checkDependencies() {
    command -v rg    >/dev/null 2>&1 || { echo >&2 "I require ripgrep but it's not installed.  Aborting."; exit 1; }
    command -v sd    >/dev/null 2>&1 || { echo >&2 "I require sd (sed replacement) but it's not installed.  Aborting."; exit 1; }
    command -v tmsu  >/dev/null 2>&1 || { echo >&2 "I require TMSU but it's not installed.  Aborting."; exit 1; }
}


function regenTags() {
    echo -e "
To begin Tag Selection press any key

r :: regenerate Tags"

    read -d '' -s -n1 continueQ

    if [ "$continueQ" == "r" ]; then
        "${script_dir}/tags-to-TMSU.sh" "${NOTES_DIR}" ${@:-} && exit 0
        exit 0 ## Must Exit because it won't find the tags without restarting.
    fi
}

function takeArguments() {
    if [ "$1" == "-h" ] || [ "$1" == "--help"  ]; then
        printHelp
        exit 0
    elif [[ $1 != '' ]]; then
        NOTE_DIR=$1
        cd $NOTE_DIR
    else
        NOTE_DIR='./'
    fi


}

function printHelp() {
    echo "Either Specify the Directory as an argument or it
    will run in the current Directory, otherwise this is interactive and doesn't
    provide STDOUT"
    }

function makeSymlinks() {
    rm -r $TEMPDIR ## If you want to have or logic for tags, the selections
                      ## must persist over iterations
    mkdir $TEMPDIR 2>/dev/null


    for i in $MatchingFiles; do
        ln -s $(realpath $i) /tmp/00tagMatches 2>/dev/null
    done
    echo "SymLinks Made in $TEMPDIR"
}

function openMatches() {

    read -d '' -n1 -s openQ

    if [ "$openQ" == "c" ]; then
        cd $TEMPDIR
        ## sk --ansi -i -c 'rg --color=always -l "{}"' --preview "mdcat {}" \
        ##        --bind pgup:preview-page-up,pgdn:preview-page-down
        sk --ansi --preview "mdcat {}" \
            --bind pgup:preview-page-up,pgdn:preview-page-down | \
            xargs realpath | xargs $DEFAULTAPP -a
    elif [ "$openQ" == "v" ]; then

        for i in "$MatchingFiles"; do

            code -a $i

        done

    else
        echo "The following files were symlinked in $TEMPDIR:"
        echo -e "~~~~~~~~~~~~

            \e[1;34m $(ls $TEMPDIR)\e[0m"

    fi
}

FilterTags() {
    chooseValue=$(echo "$ConcurrentTags" | fzf)
    ChosenTags=$(echo -e ""$ChosenTags"\n"$chooseValue"")
    ChosenTags="$ChosenTags "
    MatchingFiles=$(tmsu files "$ChosenTags")
    ConcurrentTags=$(tmsu tags $MatchingFiles | cut -f 2 -d ':' | space2NewLine | sort | uniq | sort -nr )
    ChosenTags=$(echo "$ChosenTags" | space2NewLine | sort -u )
    ConcurrentTags="$(comm -13 <(echo "$ChosenTags" | sort) <(echo "$ConcurrentTags" | sort))"

    echo -e "

\e[1;32m
═══════════════════════════════════════════════════════════════════════════
\e[0m

The chosen tags are:

\e[1;35m
$(addBullets "$ChosenTags")
\e[0m

With Matching Files:

\e[1;34m
$(addBullets "$MatchingFiles")
\e[0m

and Concurrent Tags:
\e[1;33m
$(addBullets "$ConcurrentTags")
\e[0m
\e[1;32m
═══════════════════════════════════════════════════════════════════════════
\e[0m
"

    ## read -p 'Press t to continue chosing Tags concurrently: ' conTagQ
    ## This temp dir doesn't work ??? TODO
    ## TEMPDIR="$(mktemp -d /tmp/cadmusTagsXXXXXXX)"
    TEMPDIR=/tmp/00tagMatches
    echo -e "


⁍ \e[1;35mt\e[0m      :: Choose Concurrent \e[1;35mT\e[0mags
⁍ AnyKey :: Accept Chosen Tags \e[1;35mT\e[0mags
"

    read -d '' -n1 -s conTagQ


    if [ "$conTagQ" == "t" ]; then
        FilterTags
    fi

}

space2NewLine() {
    command -v perl >/dev/null 2>&1 || { echo >&2 "I require perl but it's not installed.  Aborting."; exit 1; }
    perl -pe 's/(?<=[^\\])\ /\n/g' | rmLeadingWS
}

## For some reason the first TagResult has a leading whitespace which causes it to double up
## This function strips whitespace and so needs to be used
rmLeadingWS() {
    command -v sd >/dev/null 2>&1 || { echo >&2 "I require sd (sed replacement) but it's not installed.  Aborting."; exit 1; }
    sd '^ ' ''
}

addBullets() {
    echo "$1" | perl -pe 's/^(?=.)/\t‣\ /g'
}




main $1

exit 0





# DONE Chosen Tags Should not be listed also as concurrent Tags
# DONE Should get an MDCat Preview
  # DONE Should get Bullets and Horizontal Rules
# DONE Initial Tag
# DONE Coloured Output
# DONE Output should be useful
# DONE fif should use `rg --follow` by default
# DONE Should not call code when C-c out
# DONE Should Cleare Symlink Folder after Running
# DONE Should the option to regen tags present itself?
# TODO Restructure
## Seperate Script
# DONE fimd should use mdcat by default as well as skim interactive
