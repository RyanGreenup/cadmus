#!/bin/bash
# Don't forget to adjust the permissions with:
#chmod +x ~/somecrazyfolder/script1

## Program


### Description
# will print the title of a webpage
# I took the code from:
  # https://unix.stackexchange.com/a/103253 


### Choose what format to output in
 # LaTeX, # MD or # Org

 command -v recode >/dev/null 2>&1 || { echo >&2 "I require recode but it's not installed.  install with sudo apt recode (or pacman its in the repos), Aborting."; exit 1; }


if [ "$1" == "-h" ]; then
# Put's formated link in clipboard
  echo "
  Usage: `basename $0` <Format>

  This requires GNU recode and GNU wget, they're in the repos

     -m... Format Link for  Markdown........[Title](Link) 
     -o... Format Link for  Org.............[[Link][Title]]
     -l... Format Link for  LaTeX...........href{Link}{Title}
  "
  exit 0
fi


if [[ "$1" == *-m* ]]; then
	echo "Will Export as markdown Format"
	type="md"
elif [[ "$1" == *-o* ]]; then
	echo "Will Export as Org Format"
	type="org"
elif [[ "$1" == *-l* ]]; then
	echo "Will Export as LaTeX Format"
	type="latex"
else
	echo "
	
	Please Specify an export Format

     m... Format Link for  Markdown........[Title](Link) 
     o... Format Link for  Org.............[[Link][Title]]
     l... Format Link for  LaTeX...........href{Link}{Title}
	"
	# Take the next single keystroke
        read -d'' -s -n1
	type=$REPLY

	# reassign type to the corresponding keystroke

	if [[ $type == m ]]; then
		echo ""
		echo "Will Export as markdown Format"
		type="md"
	elif [[ $type == o ]]; then
		echo ""
		echo "Will Export as Org Format"
		type="org"
	elif [[ $type == l ]]; then
		echo ""
		echo "Will Export as LaTeX Format"
		type="latex"
	else
		echo "
		   Correct input not detected.
		   either specify an argument or press the corresponding key,
		   refer to the help with `basename $0` -h.
		   "
		   exit 0

	    fi
    fi

# echo "The chosen format is $type" # To debug var assignment

### Take the link Variable
arglink=$(xclip -o -selection clipboard)

#### Print the Link

##### Assign Colour Variables

# taken from https://stackoverflow.com/a/5947802/10593632
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

#printf "I ${BLUE}love${NC} Stack Overflow\n"
printf "

The Chosen Link is:

${BLUE} $arglink 

${NC} It's description is\n"

title=$(wget -qO- $arglink |
perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' |
recode html..)

echo $title

### Return the Appropriate Ouput

if [[ $type == md ]]; then
	outputlink="[$title]($arglink)"
elif [[ $type == org ]]; then
	outputlink="[[$arglink][$title]]"
elif [[ $type == latex ]]; then
	outputlink="\href{$arglink}{$title}"
else
	echo "the variable \$type doesn't match what was expected
	     despite correct input, this is a bug in the program
	     "
	     exit 1
fi



### Copy the link to the clipboard
echo $outputlink | xclip -selection clipboard


	printf "The following link has been put in the clipboard:

	${ORANGE} $outputlink \n"

## vim:fdm=expr:fdl=0
## vim:fde=getline(v\:lnum)=~'^##'?'>'.(matchend(getline(v\:lnum),'##*')-2)\:'='

exit 0

