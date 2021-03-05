#!/usr/bin/env bash



command -v rg >/dev/null 2>&1 || { echo >&2 "I require ripgrep but it's not installed.  Aborting."; exit 1; }
command -v sd >/dev/null 2>&1 || { echo >&2 "I require sd (sed replacement) but it's not installed.  Aborting."; exit 1; }
command -v xclip >/dev/null 2>&1 || { echo >&2 "I require xclip but it's not installed.  Aborting."; exit 1; }


term=$(basename "${1}" | cut -f 1 -d '.')
DIR="${2}"


rg -e "\[.*\]\(.*$term\.md\)" -e "\[\[$term\]\]" -e "\[\[$term.*\]\]" \
    "${DIR}" \
    -t markdown -ol
    # ~/Notes/MD/notes \

## If you want to preview the Backlinks
 ##  rg -e "\[.*\]\(.*$term\.md\)" -e "\[\[$term\]\]" -e "\[\[$term.*\]\]" \
 ##      ~/Notes/  -t markdown -ol \
 ##  fzf --bind pgup:preview-page-up,pgdn:preview-page-down --preview "mdcat {}"
