---
title: Create
---

# Create
!!! note
    Start this with `cadmus tags create`
    
!!! warning
    The tags stuff is a **work in progress***, it's a bit rough around the edges.

## What does it do

This starts an interactive dialog to extract inline `#tags` as well as tags in a [YAML](https://en.wikipedia.org/wiki/YAML) header and pass them to [TMSU](https://tmsu.org/).

## How Do I use it

After running the command type a menu will be displayed, if there is no pre-existing *TMSU* database, press <kbd>n</kbd> to create one and then re-execute `cadmus tags create`. From there usually you will want to extract both types of tags so press <kbd>b</kbd>, cadmus will sync the tags between your notes and *TMSU* [^7]

[^7]: I played with the idea of avoiding *TMSU* but it works really well and the *Virtual File System* is really neat.

## When Would This Be Used

This needs to be used every time your tags are changed in order to bring tmsu back in sync, otherwise when you look for tags it won't show the correct notes.

### Example

![](./media/How-to-Tags.gif)

## How does it Work

### Hash tags

Hash tags are easy, just use `ripgrep` with `pcre2`:

```bash
rg --pcre2 '(?<=\s#)[a-zA-Z]+(?=\s)' -t markdown -o $NOTE_DIR \
        | sed s+:+\ + | sed s/^/tmsu\ tag\ /
```

### YAML Tags

This is a little more involved, it's essentially a couple of `for`` loops over the files, I did it in ***R*** first but it was too slow so I redid it in *NodeJS*, checkout these files for the source code:

- `/bin/tags/yaml-parse.js`
- `/home/ryan/.cadmus/bin/tags/ListTags.R`

### Integrating with Vim

I put these lines in my `.vimrc` to generate a list and filter tags using FZF.vim:

```vim
imap <expr> <C-c><C-y> fzf#vim#complete('node ~/bin/printMarkdownTags/yaml-parse.js $HOME/Notes/MD/notes \| sort -u')
imap <expr> <C-c><C-t> fzf#vim#complete('rg --pcre2 "\s#[a-zA-Z-@]+\s" -o --no-filename $HOME/Notes/MD -t md \| sort -u')
```

## Dependencies

This requires, TMSU, nodejs and ripgrep with pcre2.
