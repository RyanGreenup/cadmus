---
title: Back Links
---

# Display Back Links
!!! note
    Start this with `cadmus tools backlinks`

## What does it do

This takes a notes path from the clipboard and displays in the terminal any files that link to it using either:

- `[markdown](./links.md)`
- `[[wiki-links]]`

## How Do I use it

Copy a note path to the clipboard then run `cadmus tools backlinks`, any notes that link to it will be displayed in the terminal.

## When Would This Be Used

This is handy when you have some piece of code, somewhere, that you can't find but you're sure you linked to.

### Example

![](./media/How-To-BackLinks.gif)

## How does it Work

This is just more `ripgrep`:

```bash
rg -e "\[.*\]\(.*$term\.md\)" -e "\[\[$term\]\]" -e "\[\[$term.*\]\]" \
    ~/Notes/MD/notes \
    -t markdown -ol
```

!!! note
    See the script in `/bin/tools/List-Backlinks.sh`



