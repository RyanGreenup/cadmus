# cadmus
Shell Scripts to Facilitate Effective Note Taking

## Introduction

This is a **self-contained** shell script that uses pre-existing tools (such as TMSU and recoll) to provide an interface for markdown notes.

It's command based and prints out available subcommands for any given command, these means you can use a directory of markdown files like a personal wiki, much like OneNote/Evernote/Notable, for example:

![Mindmap of Program Flow](./usage.svg "Diagram of the flow of the script")

and an overview of what it looks like in the terminal

![](./media/Many_Examples.png)


Ultimately the idea is it is to act a menu to dispatch different scripts I already had so I could
more easily share those scripts with classmates.

The real heavy lifting is done by Pandoc, Recoll, ripgrep, skim/fzf, TMSU etc.

## Installation

### Automatic

Copy this into your shell:


``` bash
cd $(mktemp -d)
wget https://raw.githubusercontent.com/RyanGreenup/cadmus/master/install.sh
bash install.sh
```


- Cadmus will work from within a self-contained directory and add a symlink to `~/.local/bin`
    - in this way it's zero lock-in, it does not modify your curr directory of Markdown files.
- Installation will automatically create a config file in its directory (which is by default `~/.cadmus`
- The script will list any [dependencies](#dependencies) that are not satisfied.

### Manual

To install manually:

1. satisfy [the dependencies](#Dependencies)
2. [Set up Recoll](#Configuring-recoll)
3. Download cadmus and put it into the `PATH`
    ```bash
    git clone https://github.com/RyanGreenup/cadmus ~/.cadmus  \
    || echo "Delete $HOME/.cadmus first"
    mkdir -p $HOME/.local/bin
    ln -s "$HOME/.cadmus/bin/cadmus" "$HOME/.local/bin/"
    ```
    3. According to the [*SystemD Standard*](https://www.freedesktop.org/software/systemd/man/file-hierarchy.html) `~/.local/bin` should be in `$PATH`, if you are using some other init implementation you can add this directory to `"$PATH"` it by doing something like this: 
    
        ``` bash
        ## Should work in bash/zsh/fish
        echo $PATH | grep "$HOME/.local/bin" &> /dev/null && echo "$HOME/.local/bin in path already" || ls "$HOME/.local/bin" &> /dev/null && echo 'PATH="$PATH:$HOME/.local/bin"' >> $HOME/.profile
        
        ```

> When first run, the script will prompt you to make a config file in the directory in which it is run.

### Assumptions

It is assumed that:

1. Notes are:
    1. *Markdown* files with a `.md` extension
    3. Recoll updates it's index on the fly
        * The notes directory will need to be indexed by *Recoll* in order for
          the results to show up when using `cadmus search`.
3. SSD
    * I use an SSD and  so I let some scripts be pretty inefficient (for example something like `grep | cut |
      xargs find` to avoid creating a variable), I don't know if HDD performance would be great.
5. All Notes have Unique Names
6. On *MacOS* you'll need to define `xdg-open` and have GNU coreutils, so do something like:
  ```bash
  alias xdg-open='open &>/dev/null' 
  alias realpath=grealpath &>/dev/null
  ```
[*nushell*]: https://github.com/nushell/nushell
[*Fish*]:    https://fishshell.com/
[*OMF*]:     https://github.com/oh-my-fish/oh-my-fish


  
### Configuring recoll

Currently the search just uses the default recoll config, I intend to modify this to use `~/.cadmus` as a config directory so as to not interfere with the default config.

It isn't in practice an issue if `~/.recoll` is indexing more than the notes  because you can just modify the call to *Skim* (`sk`) in ..cadmus.. to start the call with `~/Notes/MD`. 
<!---
By default *Cadmus* will use a rcoll configuration at `~/.cadmus`, this is to ensure that it doesn't conflict with any previous configuration.

Set this up by performing:

``` bash
mkdir ~/.cadmus
recoll -c ~/.cadmus
```
then select *index configuration* and configure recoll to have `~/Notes/MD` as the top directory and to exclude `~`, ideally `recoll` will index live which can configured with *indexing schedule*. *Recoll* will then start indexing the files and afterwards (≅ 1-2 minutes) the *GUI* will pop up and you can confirm that the indexing was successful.

|:note: NOTE|
| ---                                                                                   |
| If you want to change the notes directory change the variable `NOTES_DIR` in ****<span style="color:rgb(90,210,90);font-family:Courier New,Courier, monospace,serif;">cadmus</span>**** |

 -->



## Design Philosophy

- ****<span style="color:rgb(90,210,90);font-family:Courier New,Courier, monospace,serif;">cadmus</span>**** acts as a menu for scripts to acheive things
    - The Actual work will be done by subscripts denoted by `description.bash`
        - The subscripts will take the note directory as an argument so they are portable and modular
    - The Arguments will be shifted and then all passed down to subfunctions
    - the script name ~~will~~ should always be printed to the terminal so the individual
      script can be repurposed with out fishing through code.
- Subscripts ~~will~~ should take *only one* argument (or `STDIN`)
    - If the first argument is either `-h` or `--help` help will be printed and then `exit 0`
    - This might lead to some limitations but the simplicity is for sanity, modularity and extensibility.
    - Will always return absolute path.
        - I played around with relative path but it got confusing when calling the script from inside a function inside a script, so instead if you want a relative path you should do `scriptname './' | xargs realpath --relative-to='./'`
- Be a Front end to tie together different scripts and tools
- Don't replicate work other people have done.
- Plain Text, Free as in Speech and Beer.
- try to make modular subscripts:
    - Pipe in input, output goes to STDOUT
    - Leave Aliases and piping to the user
        - See [Recommended Aliases](#recommended-aliases)

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
- [xclip](https://www.archlinux.org/packages/extra/x86_64/xclip/)

### Recommended for all Features

- [ip](https://jlk.fjfi.cvut.cz/arch/manpages/man/ip.8)
    - if you're on mac [this stackExchange](https://superuser.com/a/898971) answer suggests [iproute2](https://formulae.brew.sh/formula/iproute2mac#default) may work
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

## Recommended Aliases

I wrote all this with aliases in mind, when I settle on some aliases i'll put up my `fish` functions. (I also wanted autocomplete)


## Why / Comparison with other tools

So the boxes I needed ticked are, more or less:
𐄞
|           | FOSS | Offline | Linux/BSD? | terminal? | RawFiles? | Markdown | AnyEditor? |
|-----------|------|---------|------------|-----------|-----------|----------|------------|
| OneNote   | ❌   | ❌      | ❌         | ❌        | ❌        | ❌       | ❌         |
| EverNote  | ❌   | ?       | ❌         | ❌        | ❌        | ❌       | ❌         |
| Notable   | ❌   | ✅      | ✅         | ❌        | ✅        | ✅       | ✅         |
| Zim       | ✅   | ✅      | ✅         | ❌        | ✅        | ✅       | ✅         |
| Obsidian  | ❌   | ✅      | ✅         | ❌        | ✅        | ✅       | ✅         |
| dokuwiki  | ✅   | ❌      | ✅         | ❌        | ✅        | ✅*      | ✅         |
| joplin    | ✅   | ✅      | ✅         | ✅        | ❌        | ✅       | ❌ †       |
| mediawiki | ✅   | ❌      | ✅         | ❌        | ❌        | ❌       | ❌ ‡       |
| Org-Mode  | ✅   | ✅      | ✅         | ✅        | ✅        | ❌       | ❌         |
| Cadmus    | ✅   | ✅      | ✅         | ✅        | ✅        | ✅       | ✅         |

> † You can't open the files from vim with FZF so it gets a no. <br>
> ‡ Unlike dokuwiki everything is in a database so it gets a no <br>
> \* With a Plugin <br>

## Related

- [DNote]
- [TNote]
- [Notable] 

[Notable]: https://github.com/notable/notable
[TNote]: https://github.com/tasdikrahman/tnote
[DNote]: https://github.com/dnote
[tmpfs]: https://wiki.archlinux.org/index.php/Tmpfs
[shared_memory]: http://en.wikipedia.org/wiki/Shared_memory


[*stow*]: https://www.google.com/search?client=firefox-b-d&q=gnu+stow
