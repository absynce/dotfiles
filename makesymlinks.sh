#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
oldDir=~/dotfiles-$(date +"%Y.%m.%d")-bak # old dotfiles backup directory
files="atom bashrc gitconfig tmux.conf vimrc vim private zshrc oh-my-zsh"    # list of files/folders to symlink in homedir
vim=~/.vim                        # vim directory
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
echo "Installing zsh"
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Get oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git
        # Install oh-my-zsh plugins
        # Install zsh-nvm plugin
        git clone https://github.com/lukechilds/zsh-nvm $dir/oh-my-zsh/custom/plugins/zsh-nvm

        # TODO: somehow change to zsh and run these.
        # nvm install node

        # Install oh-my-zsh theme(s)
        # See https://github.com/marszall87/lambda-pure#manually for more info.
        # mkdir -p $dir/oh-my-zsh/custom/themes
        # curl -o  $dir/oh-my-zsh/custom/themes/lambda-pure.zsh https://raw.githubusercontent.com/marszall87/lambda-pure/master/lambda-pure.zsh
        # curl -o  $dir/oh-my-zsh/custom/themes/async.zsh https://raw.githubusercontent.com/marszall87/lambda-pure/master/async.zsh
        # mkdir -p ~/.oh-my-zsh/functions
        # ln -s "$dir/lambda-pure.zsh" ~/.oh-my-zsh/functions/prompt_lambda-pure_setup
        # ln -s "$dir/async.zsh" ~/.oh-my-zsh/functions/async
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
    # If the platform is not supported, tell the user to install zsh :)
    else
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

function isInstalled {
    name=$1
    if ! which $name > /dev/null; then
        # echo "$name : not installed"
        return 1
    else
        # echo "$name : installed"
        return 0
    fi
}

# Install zsh
install_zsh

# Install pathogen
mkdir -p $vim/autoload $vim/bundle
curl -L -Sso $vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# Install Solarized theme
cd $vim/bundle
git clone git://github.com/altercation/vim-colors-solarized.git

# Install Coffeescript support
cd $vim/bundle
git clone https://github.com/kchmck/vim-coffee-script.git

####### Atom Install #########
if ! isInstalled "atom" ; then
    echo "atom not installed"
# cinst Atom # Windows only
fi
# Linux
# TODO: Try http://askubuntu.com/a/630530/168577

# Install atom packages
if isInstalled "atom"; then
    cd $atomDirectory
    apm install --packages-file package.list
fi
