---
title: Windows
---

# Windows
!!! note
    Start this with `cadmus misc wa/wr`

## What does it do

This offers a fuzzy selection of windows just like rofi but in the terminal.

## How Do I use it

!!! warning 
    This requires [wmctrl](https://www.lesbonscomptes.com/recoll/) set up to index your notes directory.

Run `cadmus misc wa` to activate a window or `cadmus misc wr` to relocate a window, a dialog will popup.

Type to filter the popup and press <kbd>Enter</kbd> to activate that window.

## When Would This Be Used

This is good for when you're looking for a window but you don't want to use rofi for one reason or another.

### Example

#TODO

## How does it Work

This just uses `wmctrl` and `fzf` to filter through the windows like this:

```bash
 wmctrl -R "$(wmctrl -l | cut -f 5- -d " " | fzf)"
 ```


