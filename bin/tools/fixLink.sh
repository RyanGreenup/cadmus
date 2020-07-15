#!/bin/bash
# Don't forget to adjust the permissions with:
#chmod +x ~/somecrazyfolder/script1

## Program


### Description
# This will use fzf to find filenames that might correspond to a path from a broken link in the clipboard.

# so let's say that ~[](~/broken/path/to/rsico.png)~ is a broken link, I can use ~yi(~ to copy that to the clipboard in vim  and run the following bash scipt to return the correct link:

# Requires:
  # * gnu coreutils (specifically realpath)
  # * fzf
  # * xclip


## WARNING, IF YOU USED `SPC F Y` FROM EMACS THIS WILL NOT WORK!!!
## I DON'T KNOW WHY, I THINK IT'S BECAUSE OF Newline Characters at the end maybe?



### Code
#' You have to strip out the `~` characters, they are incompatible with `realpath`
#' fzf returns /home/username/path/to/file so it doesn't matter
brokenPath=$(xclip -o -selection clipboard)
#find ~/Dropbox/ -name $(echo $(basename $brokenPath)) | fzf | xclip -selection clipboard
## NewFile=$(find ~/Dropbox/ -name $(echo $(basename $brokenPath)) | fzf)
NewFile=$(find ~/Notes/ -name $(echo $(basename $brokenPath)) | fzf)
echo $NewFile | xclip -selection clipboard

echo "
Put the path of the source file in the clipboard and Press any Key to Continue

(This doesn't work with a path taken from Emacs:buffer-file-name
  I'd recommend using VSCode for this script)
"

# this will just continue after a key stroke
read -d'' -s -n1

echo "
Using:

"

sourceFile=$(xclip -o -selection clipboard)

echo "
SOURCE_FILE.......$sourceFile
NEW_ATTACHMENT....$NewFile
"


sourcePath=$(dirname $sourceFile)

relativePath=$(realpath --relative-to="$sourcePath" $NewFile)
relPathWithDot="./"$relativePath
echo $relPathWithDot | xclip -selection clipboard

echo "

Success! Relative path is in clipboard
"

exit 0
## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='
