---
title: Filter
---

# Filter
!!! note
    Start this with `cadmus tags filter`

## What does it do

This concurrently filters your notes based on the tags that are in *TMSU*, it will be necessary to [create tags in *TMSU*](./create.md) before doing this if the tags have changed.

## How Do I use it

After running the command a list of tags that are currently in the tmsu database will be presented, press <kbd>Enter</kbd> to select an inital tag.

From here the following will be displayed:

0. Chosen Tags
1. Matching Notes
2. Concurrent Tags

Further tags can be chosen to narrow down the search by pressing <kbd>t</kbd> or the currently selected tags can be accepted with Any key.

After accepting the chosen tags with any key, all the files can be symlinked into `/tmp`,  opened in VScode [^v] or the find selecor can be started on the matches.

[^v]: This will probably change to the default app when I get time to look at it, just change it to whatever app you like in `/bin/tags/FilterNotesByTMSUTag.sh`

## When Would This Be Used

This is great for when you're trying to collect all the knowledge you have on a particular topic when it isn't captured by your directory structure.

(e.g. all notes on `#programming` may span many different directories)

### Example

![](./media/How-To-Filter.gif)

## How does it Work

I don't remember haha.

Basically there is a `bash` function that finds tags in /TMSU/ and it's recursively called with <kbd>t</kbd> until any key is pressed.

The chosen tags are subtracted from the concurrent tags by using `comm`:

```bash
ConcurrentTags="$(comm -13 <(echo "$ChosenTags" | sort) <(echo "$ConcurrentTags" | sort))"
```

The relevant script is in `bin/tags/FilterNotesByTMSUTag.sh`
