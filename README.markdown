# Dotfiles

Forked from [michaeljsmalley/dotfiles](https://github.com/michaeljsmalley/dotfiles)

This repository includes all of my custom dotfiles. They should be cloned to
your home directory so that the path is `~/dotfiles/`. The included setup
script creates symlinks from your home directory to the files which are located
in `~/dotfiles/`.

The setup script is smart enough to back up your existing dotfiles into a
`~/dotfiles-YYYY.MM.dd-bak/` directory (e.g. `~/dotfiles-2012.12.21-bak/`)
if you already have any dotfiles of the same name as
the dotfile symlinks being created in your home directory.

So, to recap, the install script will:

1. Back up any existing dotfiles in your home directory to `~/dotfiles-YYYY.MM.dd-bak/`
2. Create symlinks to the dotfiles in `~/dotfiles/` in your home directory

## Installation

```bash
git clone git@github.com:absynce/dotfiles.git ~/dotfiles
cd ~/dotfiles
./makesymlinks.sh
```
