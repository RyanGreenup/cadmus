# cadmus
Shell Scripts to Facilitate Effective Note Taking

## Installation

To install manually, satisfy [the dependencies](#Dependencies) and do something like this:

```bash
cd ~/DotFiles

if [[ -d ".git" ]]; then
    echo "Adding Submodule";
    git submodule add https://github.com/RyanGreenup/cadmus    
else echo "Cloning Repository";
    git clone add https://github.com/RyanGreenup/cadmus    
fi

command -v stow >/dev/null 2>&1 || { echo >&2 "I require stow but it's not installed.  Aborting."; exit 1; }
stow -t $HOME -S cadmus
```

## Dependencies

[R](https://en.wikipedia.org/wiki/R_(programming_language))
[highlight](https://www.archlinux.org/packages/community/x86_64/highlight/)
[node](https://nodejs.org/en/)
[nvim](https://neovim.io/)
[fzf](https://github.com/junegunn/fzf)
[code](https://github.com/lotabout/skim)
[sk](https://github.com/lotabout/skim)
[rg](https://www.google.com/search?client=firefox-b-d&q=ripgrep+github)
[perl](https://wiki.archlinux.org/index.php/Perl)
[stow](https://www.google.com/search?client=firefox-b-d&q=gnu+stow)
[python]
[tmsu](https://aur.archlinux.org/packages/tmsu/)<sup>AUR</sup>
[ranger](https://www.archlinux.org/packages/community/any/ranger/)
[mdcat](https://aur.archlinux.org/packages/mdcat/)<sup>AUR</sup>
[xclip](https://www.archlinux.org/packages/extra/x86_64/xclip/)
[sd](https://github.com/chmln/sd)
[fd](https://github.com/sharkdp/fd)
[sed](https://www.gnu.org/software/sed/)
[cut](https://www.gnu.org/software/coreutils/manual/html_node/The-cut-command.html)
[grep](https://www.gnu.org/software/grep/)
[find](https://man7.org/linux/man-pages/man1/find.1.html)
[GNU realpath](https://www.gnu.org/software/coreutils/manual/html_node/realpath-invocation.html#realpath-invocation)
