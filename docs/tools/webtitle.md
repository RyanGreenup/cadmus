---
title: Web Title
---

# Print Web Title
!!! note
    Start this with `cadmus tools webtitle`

## What does it do

This transforms a URL in the clipboard into a formatted link

## How Do I use it

Copy / Paste a URL then type `cadmus tools webtitle`, the clipboard should be transformed into a formatted link with the right title.

## When Would This Be Used

This is great for footnotes.

### Example

![](./media/How-To-Webtitle.gif)

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

