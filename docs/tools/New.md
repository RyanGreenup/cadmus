---
title: New
---

# New Note
!!! note
    Start this with `cadmus tools new`

## What does it do

This provides a dialog that sets the title, heading and filename of a note, offers tags to apply and offers fuzzy search for the appropriate directory to save the note in.

## How Do I use it

After running the command multiple tags will be displayed, filter the tags by typing and use <kbd>Tab</kbd> to selet multiple tags and <kbd>Enter</kbd> to continue. 

Next a directory list will be presented, search through the directories by typing in the name of a directory.

Finally a dialog to type in a name for the title, heading and filename (which will be made to be identical) will be offered, type in title:

* Spaces are fine
* No extension

The file name will be slugified with `-` and the extension `.md` will be applied.

## When Would This Be Used

This is great when you want to quickly make a new note in the right place with the right tags.

### Example

![](./media/New-Note.gif)


## How does it Work

This just uses *TMSU* and *Skim* to choose the directories and tags.

