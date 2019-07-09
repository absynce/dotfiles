##############################################################################
#   Filename: .bashrc                                                        #
# Maintainer: Michael J. Smalley <michaeljsmalley@gmail.com>                 #
#        URL: http://github.com/michaeljsmalley/dotfiles                     #
#                                                                            #
#                                                                            #
# Sections:                                                                  #
#   01. General ................. General Bash behavior                      #
#   02. Aliases ................. Aliases                                    #
#   03. Theme/Colors ............ Colors, prompts, fonts, etc.               #
##############################################################################

##############################################################################
# 01. General                                                                #
##############################################################################
# Shell prompt
#export PS1="\n\[\e[0;36m\]┌─[\[\e[0m\]\[\e[1;33m\]\u\[\e[0m\]\[\e[1;36m\] @ \[\e[0m\]\[\e[1;33m\]\h\[\e[0m\]\[\e[0;36m\]]─[\[\e[0m\]\[\e[1;34m\]\w\[\e[0m\]\[\e[0;36m\]]\[\e[0;36m\]─[\[\e[0m\]\[\e[0;31m\]\t\[\e[0m\]\[\e[0;36m\]]\[\e[0m\]\n\[\e[0;36m\]└─[\[\e[0m\]\[\e[1;37m\]\$\[\e[0m\]\[\e[0;36m\]]› \[\e[0m\]"

# If fortune is installed, run a fortune
if [ -e /opt/local/bin/fortune ]; then
    fortune -so
    echo " "
fi

# 07. Git Tab Completion                                                    # 
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

##############################################################################
# 02. Aliases                                                                #
##############################################################################
# Enable colors in "ls" command output
alias ls="ls -Glah"

##############################################################################
# 03. Theme/Colors                                                           #
##############################################################################
# CLI Colors
export CLICOLOR=1
# Set "ls" colors
export LSCOLORS=Gxfxcxdxbxegedabagacad

##################################################################################
# Custom functions
# Thanks to http://github.com/making3/dotfiles
##################################################################################

###
# Resets the database based on the seed and optionally runs the compound server
###
function crs() {
    compound db migrate;
    compound seed;

    if [ "$1" = s ]; then
        compound s;
    fi
}

###
# Sets up genesis development environment (terminal with tmux and a new tab)
###
function genesis() {
    cd ~/dev/genesis-myghr/;
    tup;
    tmux;
}

###
# Opens up a new tab
###
function tup() {
    #!/bin/sh

    WID=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)"| awk '{print $5}')
    xdotool windowfocus $WID
    xdotool key ctrl+shift+t
    xdotool key alt+1
    xdotool key super+Up
    wmctrl -i -a $WID
}

###
# Exports node environments
###
function setenv() {
    if [ "$1" = dev ]; then
        export NODE_ENV=development;
    elif [ "$1" = demo ]; then
        export NODE_ENV=demo;
    elif [ "$1" = p ]; then
        export NODE_ENV=production;
    fi
    echo Environment set to $NODE_ENV;
}

###
# Mocha test with optional grep argument
###
function m() {
    if [[ -n "$1" ]]; then
        if [[ -n "$2" ]]; then
            mocha test/init.js $1 -g "$2";
        else
            mocha test/init.js $1;
        fi
    else
        echo Please specify the test you want to run, and optionally a grep argument.;
    fi
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH=$HOME/npm/bin:$PATH
export PATH=$HOME/npm/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
