#!/bin/bash
# Don't forget to adjust the permissions with:
#chmod +x ~/somecrazyfolder/script1

main () {

setClipboard

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
brokenPath=$(CLIP_OUT)
#find ~/Dropbox/ -name $(echo $(basename $brokenPath)) | fzf | xclip -selection clipboard
## NewFile=$(find ~/Dropbox/ -name $(echo $(basename $brokenPath)) | fzf)
NewFile=$(find ~/Notes/ -name $(echo $(basename $brokenPath)) | fzf)
echo $NewFile | CLIP_IN

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

sourceFile=$(CLIP_OUT)

echo "
SOURCE_FILE.......$sourceFile
NEW_ATTACHMENT....$NewFile
"


sourcePath=$(dirname $sourceFile)

relativePath=$(realpath --relative-to="$sourcePath" $NewFile)
relPathWithDot="./"$relativePath
# echo $relPathWithDot | sd '\n' '' | CLIP_IN
echo $relPathWithDot | tr -d '\n'  | CLIP_IN

echo "

Success! Relative path is in clipboard
"








}



setClipboard () {

case "$(uname -s)" in

    Darwin)
        CLIP_IN () { pbcopy ; }
        CLIP_OUT () {  pbpaste ; }
        xdg-open () {  open "%{@}" ; }
     ;;

    Linux|GNU|*BSD|SunOS)
        ## "$XDG_SESSION_TYPE" not always defined
        if [[ "$( loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type | rg 'wayland' )" ]]; then
            CLIP_IN () { wl-copy ; }
            CLIP_OUT () {  wl-paste ; }
        else
            CLIP_IN () { xclip -selection clipboard ; }
            CLIP_OUT () {  xclip -selection clipboard -o ; }
        fi
     ;;

   CYGWIN*|MINGW32*|MSYS*|MINGW*)
            CLIP_IN () { xclip -selection clipboard ; }
            CLIP_OUT () {  xclip -selection clipboard -o ; }
     ;;

   # Add here more strings to compare
   # See correspondence table at the bottom of this answer

   *)
       echo "Could not Detect OS, if you're not on Mac/Linux, file a bug please"
       echo "Applying Linux Defaults"
        CLIP_IN () { xclip -selection clipboard ; }
        CLIP_OUT () {  xclip -selection clipboard -o ; }
     ;;
esac


}
















main "${@}"

exit 0
## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='
