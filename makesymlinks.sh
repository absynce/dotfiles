#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
oldDir=~/dotfiles-$(date +"%Y.%m.%d")-bak # old dotfiles backup directory
files="atom bashrc emacs emacs-loadpackages gitconfig tmux.conf vimrc vim private"    # list of files/folders to symlink in homedir
vim=~/.vim                        # vim directory
emacsD=~/.emacs.d                 # emacs package directory
atomDirectory=~/.atom             # atom directory

##########

# create dotfiles_old in homedir
echo -n "Creating $oldDir for backup of any existing dotfiles in ~ ..."
mkdir -p $oldDir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create
# symlinks from the homedir to any files in the ~/dotfiles directory specified
# in $files
for file in $files; do
    if [ -f ~/.$file ]; then
        echo "Moving existing dotfile .$file from ~$dir/ to $oldDir/"
        mv ~/.$file $oldDir/
    elif [ -d ~/.$file ]; then
        echo "Moving existing directory .$file from ~$dir/ to $oldDir/"
        mv ~/.$file/ $oldDir/
    fi
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done


function install_zsh {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/michaeljsmalley/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh
        install_zsh
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

# Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -Sso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# Install Solarized theme
cd $vim/bundle
git clone git://github.com/altercation/vim-colors-solarized.git

# Install Coffeescript support
cd $vim/bundle
git clone https://github.com/kchmck/vim-coffee-script.git

# Emacs install things

# Install stylus-mode and sws-mode for emacs
cd $emacsD
wget -nc --no-check-certificate https://raw.github.com/brianc/jade-mode/master/stylus-mode.el
wget -nc --no-check-certificate https://raw.github.com/brianc/jade-mode/master/sws-mode.el

# Clone emacs-color-theme-solarized from github.com/sellout/emacs-color-theme-solarized
cd $emacsD
git clone git@github.com:sellout/emacs-color-theme-solarized.git

# Install undo-tree and evil
# undo-tree - prereq for evil
git clone http://www.dr-qubit.org/git/undo-tree.git
git clone git://gitorious.org/evil/evil.git

####### Atom Install #########
cinst Atom # Windows only
# Linux
# TODO: Try http://askubuntu.com/a/630530/168577

# Install atom packages
cd $atomDirectory
apm install --packages-file package.list
