# Cadmus!

Cadmus is a knowledge management tool in your terminal.

## What does it do

Cadmus provides command driven interface to find and edit Markdown files, such as finding by name, searching for terms, filtering by tags, generating backlinks and generating relative links to other notes.

## How does it Work

Cadmus is just a bunch of shell scripts that essentially use pipes and *ripgrep* with *skim* to display them.

## How Do i Use It 

### Installation

[cadmus is available on the AUR](https://aur.archlinux.org/packages/cadmus-notes/), generally however cadmus will operate in a portable fashion from =~/.cadmus/=, so just using =git= is fine as well:

``` bash
cd $(mktemp -d)
wget https://raw.githubusercontent.com/RyanGreenup/cadmus/master/install.sh
bash install.sh
```

!!! note
    To remove it it is sufficient to perform:
    ```bash
    rm -rf "$HOME/.cadmus"
    rm ~/.local/bin/cadmus
    ```

!!! warning
    This assumes that [the dependencies](#dependencies) have all been installed and [recoll](https://www.lesbonscomptes.com/recoll/) is indexing the directory of your notes.

### Usage

Just run ~cadmus~ at the terminal and it will walk you through generating a config file. Afterwards running ~cadmus~ will show various commands such as find and search that can be used to work with your knowledge base.

!!! note
    Shortly functionality will be implemented to allow creating a `.cadmus` file in any directory that will act as a config for all markdown files beneath that directory, this is useful if you want to use cadmus with documentation for a project and still have access to your notes, or have multiple knowledge bases.
    
    
## When or Why Would I Use This 

Well I wrote this because my interests are Math and Data Sci and quite frankly I suffer from information overload, I like open-source stuff, simple scripts and unix philosophy so if any of that resonates with you try it out.

This is all modular so take what you like and reimplement it, fork it, make PR's and please fell free to post issues even if it's just to say *Hey, I like tool x have you tried it before?*.

## Background

The idea of cadmus is to demonstrate how powerful the terminal can be and how it
can act as a functional replacement for tools like OneNote or Evernote.

In reality *Cadmus* is just a couple of shell scripts to help users tie together other really good tools like *Skim*, *ripgrep*, *recoll* and *TMSU*.

## keyboard bindings

| Command       | Shortcut       | Description                          |
| `cadmus find` | [[Ctrl]]-[[Q]] | switch between find and grep in skim |
|               |                |                                      |

## Dependencies

<!---
This was a dependency but I switched to java script
- [R](https://en.wikipedia.org/wiki/R_(programming_language)) 
-->
- [bat](https://github.com/sharkdp/bat)
- [cut](https://www.gnu.org/software/coreutils/manual/html_node/The-cut-command.html)
- [fd](https://github.com/sharkdp/fd)
- [find](https://man7.org/linux/man-pages/man1/find.1.html)
- [fzf](https://github.com/junegunn/fzf)
- [GNU realpath](https://www.gnu.org/software/coreutils/manual/html_node/realpath-invocation.html#realpath-invocation)
- [grep](https://www.gnu.org/software/grep/)
- [highlight](https://www.archlinux.org/packages/community/x86_64/highlight/)
- jq <sup> [Arch](https://www.archlinux.org/packages/community/x86_64/jq/)  | [brew](https://formulae.brew.sh/formula/jq#default)   |  [ubuntu](https://packages.ubuntu.com/search?keywords=jq) </sup>
- [mdcat](https://aur.archlinux.org/packages/mdcat/)<sup>AUR</sup>
- [node](https://nodejs.org/en/)
- [Pandoc](https://github.com/jgm/pandoc)
- [perl](https://wiki.archlinux.org/index.php/Perl)
- [python](https://www.python.org/download/releases/3.0/)
- [ranger](https://www.archlinux.org/packages/community/any/ranger/)
- [recode](https://www.archlinux.org/packages/extra/x86_64/recode/)
- [Recoll](https://www.lesbonscomptes.com/recoll/)
- [rg](https://www.google.com/search?client=firefox-b-d&q=ripgrep+github)
    - Make sure to include `pcre2`, this comes in *Arch*, if using `cargo`:
    ```bash
    cargo install ripgrep --features 'pcre2' 
    ```
    
- [sd](https://github.com/chmln/sd)
- [sed](https://www.gnu.org/software/sed/)
- [skim](https://github.com/lotabout/skim)
- [tmsu](https://aur.archlinux.org/packages/tmsu/)<sup>AUR</sup>
- [xclip](https://www.archlinux.org/packages/extra/x86_64/xclip/) or [wl-clipboard](https://github.com/bugaevc/wl-clipboard)

### Recommended for all Features

- [iproute2](https://jlk.fjfi.cvut.cz/arch/manpages/man/ip.8) (for the ip binary)
    - if you're on mac [this stackExchange](https://superuser.com/a/898971) answer suggests [iproute2](https://formulae.brew.sh/formula/iproute2mac#default) may work
- tectonic
- texlive
- [Kitty](https://sw.kovidgoyal.net/kitty/) 
    - I've also heard good things about [iterm2](https://www.iterm2.com/)
- [MkDocs](https://pypi.org/project/mkdocs-material-extensions/)
    - [MkDocs Material Extensions](https://pypi.org/project/mkdocs-material-extensions/)
    - [MkDocs Material Theme](https://github.com/squidfunk/mkdocs-material)
- [nvim](https://neovim.io/)
- [tectonic](https://tectonic-typesetting.github.io/en-US/)
- [WeasyPrint](https://aur.archlinux.org/packages/python-weasyprint/)

### Interesting / Helpful / Recommended Generally (Not strictly necessary)

- [guake](http://guake-project.org/) or [yakuake](https://kde.org/applications/en/system/org.kde.yakuake)
- [MarkText](https://github.com/marktext/marktext)
- mdless
- [readability-cli](https://gitlab.com/gardenappl/readability-cli)
- [VNote](https://github.com/tamlok/vnote)
- VSCode

### PATH

If any dependencies are installed with `pip` or `cargo` it will be necessary to add these directories to your `PATH`:

``` bash
## bash
echo '
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
' >> ~/.bashrc

## zsh
echo '
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
' >> ~/.bashrc

## fish

echo '
set PATH $HOME/.local/bin $PATH
set PATH $HOME/bin $PATH
set PATH "$HOME/.cargo/bin $PATH
' >> ~/.config/fish/config.fish
```
