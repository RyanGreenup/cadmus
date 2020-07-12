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

## Usage

It's all Menu driven so just follow the diagram to do what you need.

![Mindmap of Program Flow](./usage.svg "Diagram of the flow of the script")

## Dependencies

This is HTML:

<ul id="double"> <span class="code-comment"><!-- Alter ID accordingly --></span>

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
- [tmsu](https://aur.archlinux.org/packages/tmsu/)
- [ranger](https://www.archlinux.org/packages/community/any/ranger/)
- [mdcat](https://aur.archlinux.org/packages/mdcat/)
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



</ul></code>

<style>
ul{
  width:760px;
  margin-bottom:20px;
  overflow:hidden;
  border-top:1px solid #ccc;
}
li{
  line-height:1.5em;
  border-bottom:1px solid #ccc;
  float:left;
  display:inline;
}
#double li  { width:50%;} <span class="code-comment">/* 2 col */</span>
#triple li  { width:33.333%; } <span class="code-comment">/* 3 col */</span>
#quad li    { width:25%; } <span class="code-comment">/* 4 col */</span>
#six li     { width:16.666%; } <span class="code-comment">/* 6 col */</span></code>

</style>

<!--> Source: http://csswizardry.com/2010/02/mutiple-column-lists-using-one-ul/ <--->
## Related

- [DNote]
- [TNote]
- [Notable] 

[Notable]: https://github.com/notable/notable
[TNote]: https://github.com/tasdikrahman/tnote
[DNote]: https://github.com/dnote
