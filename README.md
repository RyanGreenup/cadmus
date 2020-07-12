# cadmus
Shell Scripts to Facilitate Effective Note Taking

## Installation

```bash
cd ~/DotFiles

if [[ -d ".git" ]]; then
    echo "Adding Submodule";
    git submodule add https://github.com/RyanGreenup/cadmus    
else echo "Cloning Repository";
    git clone add https://github.com/RyanGreenup/cadmus    
fi

command -v foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
stow -t $HOME -S cadmus
```
