---
title: Search
---

# Search
!!! note
    Start this with `cadmus search`

## What does it do

This starts a search dialog with a preview of the note on the side.

## How Do I use it

!!! warning 
    This requires [recoll](https://www.lesbonscomptes.com/recoll/) set up to index your notes directory.

After running the command type in a query just like you would with *Google*, matches will be presented with an instant preview to the side.

Press <kbd>Ctrl</kbd>+<kbd>Q</kbd> to toggle search inside the note for a string (there will **not** be highlighting) [^9]

[^9]: The distinction between this and find is essentially the distinction between `grep` and a search engine.

Pressing Enter on a note will open it in the default app, [^1] if you want to do something else with it copy the path to the clipboard with <kbd>Alt</kbd>+<kbd>w</kbd> as described below in [Keyboard Shortcuts](#keyboard-shortcuts).

[^1]: `xdg-open` / `open` on Linux/Mac respectively

### Keyboard Shortcuts

| Keys                              | Description                                      |
| ---                               | ---                                              |
| <kbd>PgUp</kbd> / <kbd>PgDn</kbd> | Scroll Preview                                   |
| <kbd>Ctrl</kbd>-<kbd>w</kbd>      | Copy Absolute path to note [^2]                  |
| <kbd>Alt</kbd>-<kbd>w</kbd>       | Copy Relative path to note                       |
| <kbd>Ctrl</kbd>-<kbd>o</kbd>      | Open the note in the default app without exiting |
| <kbd>Alt</kbd>-<kbd>y</kbd>       | Copy File Contents to Clipboard [^3]             |

[^2]: TODO: this only works on Xorg at the moment
[^3]: This is really good for *Zulip* / *Discord*

## When Would This Be Used

Imagine you're sitting at your desk and this time you need to, solve a linear recurrence relation, you're solution is `cadmus search` and then type something like `linear recursion` then <kbd>Ctrl</kbd>-<kbd>Q</kbd> `math mod`.


### Example

## How does it Work

So essentially this just uses ~skim~ and ~bat~ to filter/preview the notes, the interactive command is used with ~ripgrep~ and piping (that took me forever to figure out!!) to highlight the match in the preview.[^4] This is the code that achieves it:

```bash
        sk -m -i -c 'recoll -b -t -q "ext:md" {}                 |\
                cut -c 8- | sed s/^/realpath\ \"/                     |\
                sed s+\$+\"\ --relative-to\ \"./\"+ | bash'            \
            --bind pgup:preview-page-up,pgdn:preview-page-down    \
            --preview "bat --color=always --line-range :500           \
                    --terminal-width 80 --theme=TwoDark {+}           \
                    --italic-text=always                              \
                    --decorations=always"                             \
            --color=fg:#f8f8f2,bg:-1,matched:#6272a4,current_fg:#50fa7b,current_bg:#381070,border:#ff79c6,prompt:#bd93f9,query:#bd93f9,marker:#f1fa8c,header:#f1fa8c
```

[^4]: This highlighting works with both ~bat~ and *MDCat*, I prefer *MDCat* but there is a bug with footnotes preventing me from being able to use it right at the moment.

