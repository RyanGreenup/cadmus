---
title: Find
---

# Find 
!!! note
    Start this with `cadmus find`

## What does it do

This starts a find dialog with a preview of the note on the side.

## How Do I use it

After running the command type in the name or directory of a note and the fuzzy matches will be presented with an instant preview to the side.

Press <kbd>Ctrl</kbd>+<kbd>Q</kbd> to toggle searching inside the note for a string, any matches will be highlighted.

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

Imagine you're sitting at your desk and you forgot how to pipe with *Mathematica*, you're solution is `cadmus find` and then type something like `computer algebra` then <kbd>Ctrl</kbd>-<kbd>Q</kbd> `->`.


![](./media/How-To-Find.gif)


### Example

## How does it Work

So essentially this just uses ~skim~ and ~bat~ to filter/preview the notes, the interactive command is used with ~ripgrep~ and piping (that took me forever to figure out!!) to highlight the match in the preview.[^4] This is the code that achieves it:

```bash
sk --ansi -m -c 'rg -l -t markdown --ignore-case "{}"'    \
    --preview "bat {} 2> /dev/null                             \
        --color=always --line-range :500                       \
        --terminal-width 80                                    \
        --theme=TwoDark                                       |\
            rg --pretty --colors  --context 20 {cq}                \
                --no-line-number --ignore-case                     \
                --colors 'match:fg:21,39,200'                      \
                --colors 'line:style:nobold'                       \
                --colors 'match:style:bold'                        \
                --colors 'match:bg:30,200,30'"                     \
     --bind 'ctrl-f:interactive,pgup:preview-page-up,pgdn:preview-page-down'    \
     --bind 'ctrl-w:execute-silent(echo {}    |\
         xargs realpath                       |\
         xclip -selection clipboard)'                                           \
     --bind 'alt-w:execute-silent(echo {} | xclip -selection clipboard)'        \
     --bind 'alt-v:execute-silent(code -a {}),alt-e:execute-silent(emacs {})'   \
     --bind 'ctrl-o:execute-silent(xdg-open {})'                                \
     --bind 'alt-y:execute-silent(cat {} | xclip -selection clipboard)'         \
     --bind 'alt-o:execute-silent(cat {}      |\
         pandoc -f markdown -t html --mathml  |\
         xclip -selection clipboard)' \
     --bind 'alt-f:execute-silent(echo {}        |\
         xargs dirname                           |\
         xargs cd; cat {}                        |\
         pandoc -f markdown -t dokuwiki --mathml |\
         xclip -selection clipboard)'            \
     --color=fg:#f8f8f2,bg:-1,matched:#6272a4,current_fg:#50fa7b,current_bg:#381070,border:#ff79c6,prompt:#bd93f9,query:#bd93f9,marker:#f1fa8c,header:#f1fa8c
```

[^4]: This highlighting works with both ~bat~ and *MDCat*, I prefer *MDCat* but there is a bug with footnotes preventing me from being able to use it right at the moment.
