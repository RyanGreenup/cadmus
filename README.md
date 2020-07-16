# cadmus
Shell Scripts to Facilitate Effective Note Taking

## Introduction

Essentially I ~~used to~~ have a dozen shell scripts in `~/bin` that I use to capture notes,
this is an attempt to wrap them into a single script and then have aliases to make them quick to access.

![](./MainMenu.png)

The idea is that it is just a menu to dispatch different scripts so I could
share those scripts with classmates.
  
## Design Philosophy

- ****<span style="color:rgb(90,210,90);font-family:Courier New,Courier, monospace,serif;">cadmus</span>**** acts as a menu for scripts to acheive things
    - the script name ~~will~~ should always be printed to the terminal so the individual
      script can be repurposed with out fishing through code.
- Subscripts ~~will~~ should take *only one* argument (or `STDIN`)
    - If the first argument is either `-h` or `--help` help will be printed and then `exit 0`
    - This might lead to some limitations but the simplicity is for sanity, modularity and extensibility.
    - Will always return absolute path.
        - I played around with relative path but it got confusing when calling the script from inside a function inside a script, so instead if you want a relative path you should do `scriptname './' | xargs realpath --relative-to='./'`
- Be a Front end to tie together different scripts and tools
- Don't replicate work other people have done.
- Plain Text, Open Source.
- Be Modular
    - Pipe in input, output goes to STDOUT
    - Leave Aliases and piping to the user
        - See [Recommended Aliases](#recommended-aliases)
-  ****<span style="color:rgb(90,210,90);font-family:Courier New,Courier, monospace,serif;">cadmus</span>**** will take the notes directory from the global variable `CADMUS_NOTES_DIR`
    - The Actual work will be done by subscripts denoted by `description.bash`
        - The subscripts will take the note directory as an argument so they are portable and modular
    - The Arguments will be shifted and then all passed down to subfunctions

## Installation

To install:

1. satisfy [the dependencies](#Dependencies)
2. [Set up Recoll](#Configuring-recoll)
3. Download cadmus and put it in the `PATH`
    ```bash
    mkdir ~/.cadmus && \
    git clone https://github.com/RyanGreenup/cadmus ~/.cadmus  \
    || echo "Delete ~/.cadmus first"
    ln -s ~/.cadmus/bin/cadmus $HOME/bin/
    ```
    3. If you haven't already add `$HOME/bin` to the `$PATH` variable, something like this should be fairly shell agnostic:
    
        ``` bash
        echo $PATH | grep "$HOME/bin" &> /dev/null && echo "$HOME/bin in path already" || ls "$HOME/bin" &> /dev/null && echo 'PATH="$PATH:$HOME/bin"' >> $HOME/.profile
        
        ```

4. You will probably need to change the directory to your notes in the script:

    ```bash
    which cadmus | xargs xdg-open
    ```
    
    ```
    readonly NOTES_DIR="$HOME/Notes/"
    readonly SERVER_DIR="/var/www/html/MD"
    readonly MKDOCS_YML="$HOME/Notes/mkdocs.yml" 
    ```



<!---
4. Copy the help files to `/usr/share/cadmus`

5. Copy in the scripts, with [*stow*] something like this should be sensible:

    ```bash
    exec bash
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

[stowIssue]: https://github.com/aspiers/stow/issues/65 -->
-->

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
## Usage


It's all Menu driven so just follow the diagram to do what you need.

![Mindmap of Program Flow](./usage.svg "Diagram of the flow of the script")

### Assumptions

It is assumed that:

1. Notes are:
    1. *Markdown* files with a `.md` extension
    2. Underneath `~/Notes` (you ma)
    3. Recoll updates it's index on the fly
        * `~/Notes` will need to be indexed by *Recoll* so the results will show up.
3. SSD
    * I use an SSD and some scripts are pretty inefficient (like `grep | cut |
      xargs find` to avoid creating a variable), I don't know if things like
      would work on a HDD.
5. All Notes have Unique Names
6. On *MacOS* you'll need to define `xdg-open` so do something like:
  ```bash
  alias xdg-open='open &>/dev/null' 
  ```
<!---
2. You're going to use [Kitty](https://sw.kovidgoyal.net/kitty/)
    * You could either change the source or use anoter terminal that supports
      calling functions with `--`, e.g. `kitty -- nvim`
-->
<!---
5. I use [*Fish*] and *Oh My Fish* ([*OMF*]) as my default shell, this means `basename $SHELL` is `fish` for
   me and even though this is written in `bash` maybe that could cause issues.
    * Try [*Fish*] for a while, it's quite good, when you need to test something
      it's easy to temporarily jump back with `exec zsh`.
        * I wonder if this would work for [*nushell*]???
-->

[*nushell*]: https://github.com/nushell/nushell
[*Fish*]:    https://fishshell.com/
[*OMF*]:     https://github.com/oh-my-fish/oh-my-fish

## Dependencies

<!---
This was a dependency but I switched to java script
- [R](https://en.wikipedia.org/wiki/R_(programming_language)) 
-->
- [highlight](https://www.archlinux.org/packages/community/x86_64/highlight/)
- [recode](https://www.archlinux.org/packages/extra/x86_64/recode/)
- [node](https://nodejs.org/en/)
- [fzf](https://github.com/junegunn/fzf)
- [skim](https://github.com/lotabout/skim)
- [rg](https://www.google.com/search?client=firefox-b-d&q=ripgrep+github)
- [perl](https://wiki.archlinux.org/index.php/Perl)
- [python](https://www.python.org/download/releases/3.0/)
- [tmsu](https://aur.archlinux.org/packages/tmsu/)<sup>AUR</sup>
- [ranger](https://www.archlinux.org/packages/community/any/ranger/)
- [mdcat](https://aur.archlinux.org/packages/mdcat/)<sup>AUR</sup>
- [xclip](https://www.archlinux.org/packages/extra/x86_64/xclip/)
- [sd](https://github.com/chmln/sd)
- [fd](https://github.com/sharkdp/fd)
- [sed](https://www.gnu.org/software/sed/)
- [cut](https://www.gnu.org/software/coreutils/manual/html_node/The-cut-command.html)
- [grep](https://www.gnu.org/software/grep/)
- [find](https://man7.org/linux/man-pages/man1/find.1.html)
- [GNU realpath](https://www.gnu.org/software/coreutils/manual/html_node/realpath-invocation.html#realpath-invocation)
- [Recoll](https://www.lesbonscomptes.com/recoll/)
- [Pandoc](https://github.com/jgm/pandoc)
- [bat](https://github.com/sharkdp/bat)

### Recommended for all Features

- [WeasyPrint](https://aur.archlinux.org/packages/python-weasyprint/)
- [tectonic](https://tectonic-typesetting.github.io/en-US/)
- [nvim](https://neovim.io/)
- [Kitty](https://sw.kovidgoyal.net/kitty/) 
    - I've also heard good things about [iterm2](https://www.iterm2.com/)
- [MkDocs](https://pypi.org/project/mkdocs-material-extensions/)
    - [MkDocs Material Theme](https://github.com/squidfunk/mkdocs-material)
    - [MkDocs Material Extensions](https://pypi.org/project/mkdocs-material-extensions/)
- [MarkText](https://github.com/marktext/marktext)
- [VNote](https://github.com/tamlok/vnote)

### recommended / Interesting / Helpful packages not required

- [readability-cli](https://gitlab.com/gardenappl/readability-cli)
- mdless
- VSCode

### PATH

If installed with `pip` or `cargo` it will be necessary to add these directories to your `PATH`:

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

I wrote all this with aliases in mind, when I settle on some aliases i'll put up my `fish` functions. (I also wanted to do some autocomplete.)

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
