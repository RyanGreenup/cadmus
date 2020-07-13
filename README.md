# cadmus
Shell Scripts to Facilitate Effective Note Taking

## Philosophy

- Be a Front end to tie together different scripts and tools
- Don't replicate work other people have done.
- Plain Text, Open Source.

## Installation

To install, satisfy [the dependencies](#Dependencies) and do something like this:

```bash
cd ~/DotFiles

if [[ -d ".git" ]]; then
    echo "Adding Submodule";
    git submodule add https://github.com/RyanGreenup/cadmus
else echo "Cloning Repository";
    git clone https://github.com/RyanGreenup/cadmus
fi

stow -t $HOME -S cadmus
```

|:warning: WARNING                                                                      |
| ---                                                                                   |
| Stow is [currently broken][stowIssue] on Arch If you are using Stow 2.3.1-2 downgrade |
> Downgrade with:
> sudo pacman -U https://archive.archlinux.org/packages/s/stow/stow-2.2.2-5-any.pkg.tar.xz

[stowIssue]: https://github.com/aspiers/stow/issues/65

## Usage


It's all Menu driven so just follow the diagram to do what you need.

![Mindmap of Program Flow](./usage.svg "Diagram of the flow of the script")

### Assumptions

It is assumed that notes are:

1. *Markdown* files with a `.md` extension
2. Underneath `~/Notes`
3. Recoll updates it's index on the fly
    * `~/Notes` will need to be indexed by *Recoll* so the results will show up.

## Dependencies

- [R](https://en.wikipedia.org/wiki/R_(programming_language))
- [highlight](https://www.archlinux.org/packages/community/x86_64/highlight/)
- [node](https://nodejs.org/en/)
- [nvim](https://neovim.io/)
- [fzf](https://github.com/junegunn/fzf)
- [code](https://github.com/lotabout/skim)
- [sk](https://github.com/lotabout/skim)
- [rg](https://www.google.com/search?client=firefox-b-d&q=ripgrep+github)
- [perl](https://wiki.archlinux.org/index.php/Perl)
- [stow](https://www.google.com/search?client=firefox-b-d&q=gnu+stow)
- [python](https://www.python.org/download/releases/3.0/)
- [tmsu](https://aur.archlinux.org/packages/tmsu/)<sup>AUR</sup>
- [ranger](https://www.archlinux.org/packages/community/any/ranger/)
- [mdcat](https://aur.archlinux.org/packages/mdcat/)<sup>AUR</sup>
  - [Kitty](https://sw.kovidgoyal.net/kitty/) or [iterm2](https://www.iterm2.com/)
- [xclip](https://www.archlinux.org/packages/extra/x86_64/xclip/)
- [sd](https://github.com/chmln/sd)
- [fd](https://github.com/sharkdp/fd)
- [sed](https://www.gnu.org/software/sed/)
- [cut](https://www.gnu.org/software/coreutils/manual/html_node/The-cut-command.html)
- [grep](https://www.gnu.org/software/grep/)
- [find](https://man7.org/linux/man-pages/man1/find.1.html)
- [GNU realpath](https://www.gnu.org/software/coreutils/manual/html_node/realpath-invocation.html#realpath-invocation)
- [Recoll](https://www.lesbonscomptes.com/recoll/)
- [MkDocs](https://pypi.org/project/mkdocs-material-extensions/)
    - [MkDocs Material Theme](https://github.com/squidfunk/mkdocs-material)
    - [MkDocs Material Extensions](https://pypi.org/project/mkdocs-material-extensions/)
- [VNote](https://github.com/tamlok/vnote)
- [Pandoc](https://github.com/jgm/pandoc)


## Related

- [DNote]
- [TNote]
- [Notable] 

[Notable]: https://github.com/notable/notable
[TNote]: https://github.com/tasdikrahman/tnote
[DNote]: https://github.com/dnote
