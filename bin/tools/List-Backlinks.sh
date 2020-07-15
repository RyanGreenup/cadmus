#!/usr/bin/env bash


command -v rg >/dev/null 2>&1 || { echo >&2 "I require ripgrep but it's not installed.  Aborting."; exit 1; }
command -v sd >/dev/null 2>&1 || { echo >&2 "I require sd (sed replacement) but it's not installed.  Aborting."; exit 1; }
command -v xclip >/dev/null 2>&1 || { echo >&2 "I require xclip but it's not installed.  Aborting."; exit 1; }



term=$(xclip -selection clipboard -o | xargs basename |  cut -f 1 -d '.')
rg -e "\[.*\]\(.*$term\.md\)" -e "\[\[$term\]\]" -e "\[\[$term.*\]\]" \
    ~/Notes/MD/notes \
    -t markdown -ol


## If you want to preview the Backlinks
 ##  rg -e "\[.*\]\(.*$term\.md\)" -e "\[\[$term\]\]" -e "\[\[$term.*\]\]" \
 ##      ~/Notes/  -t markdown -ol \
 ##  fzf --bind pgup:preview-page-up,pgdn:preview-page-down --preview "mdcat {}"
