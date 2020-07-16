#!/usr/bin/env bash
readonly script_name=$(basename "${0}")
            script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly script_dir=$(realpath "${script_dir}""/""${script_name}" | xargs dirname)

if [[ $1 != '' ]]; then
    NOTE_DIR=$1
else
    NOTE_DIR='./'
fi

## Must be in notes directory because commands are piped back into bash
cd $NOTE_DIR

main () {




echo 'Which Type of tags would you like to import to TMSU create (1/2/3)?

n ::  New TMSU DB
y ::  YAML Tags
t ::  #Tags
b ::  Both
x ::  Clear all TMSU DB
h ::  help

Make sure to run this from inside the notes directory

(and to back them up of course!)
'

echo 'Selection (n/y/t/b/x/h)'
read -d '' -s -n1 choice


if [ $choice == 'y' ]; then
    echo "Option $choice selected"

    ## Make a File in /tmp/00tags.sh listing the tmsu commands to run
    ## Rscript ~/bin/YamltoTMSU.R $NOTE_DIR ## Assumption that RScript is in ~/bin

    ## Must be run from the directory of the notes
    ## because the commands are piped back into bash, bash
    ## will operate relative to the working directory of the script
    cd $NOTE_DIR

    ## Must call the node script from this directory by using $script_dir
        ## Or assume that it is in the path.
      node "${script_dir}"/yaml-tags-to-TMSU.js "${NOTE_DIR}" 2>/dev/null | bash

elif [ $choice == 't' ]; then
    echo "Option $choice selected" #FIXME

    ## Print the TMSU commands to run to STDOUT (including a CD)
    ## Pipe these back to bash
    hashtags $NOTE_DIR  #| bash
elif [ $choice == 'b' ]; then
    echo "Option $choice selected" #FIXME
    ## TODO this should maybe loop back around ?
    ## I should restructure this with functions anyway.

    ## Implement HashTags
    hashtags $NOTE_DIR | bash 

    ## Implement YAML Tags (see option Y for comments, this is copy/paste)
    cd $NOTE_DIR
    node "${script_dir}"/yaml-tags-to-TMSU.js "${NOTE_DIR}" 2>/dev/null | bash

elif [ $choice == 'n' ]; then
    echo "Option $choice selected" #FIXME
    cd $NOTE_DIR
    tmsu init
elif [ $choice == 'x' ]; then
    echo 'Attempting to Remove TMSU DB
                                      '

    cd $NOTE_DIR

    if [ -d .tmsu  ]; then
     rm -r .tmsu
     tmsu init
    echo "TMSU Database Reset"
    else
      echo "No Database Found, Make one with option n
                              "
    fi



elif [ $choice == 'h' ]; then
    echo "To use this script pipe the output back to bash"
else
    echo 'Please enter y/t/b'
    exit 0
fi


exit 0

}

hashtags () {
cd "${NOTE_DIR}"
## This will generate the commands to tag the files wit #tags
## rg --pcre2 '(?<=\s#)[a-zA-Z]+(?=\s)' -t markdown -o $NOTE_DIR \
##         | sed s+:+\ + | sed s/^/tmsu\ tag\ /

## This is safer, it wraps the path and tag in ''
rg --pcre2 '(?<=\s#)[a-zA-Z]+(?=\s)' -t markdown -o  | sed -e s/^/\'/ -e s/\$/\'/ -e s/:/\'\ \'/ |  sed s/^/tmsu\ tag\ /
}

main "${@:-}"
