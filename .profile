# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bins if they exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# source cargo environment script if it exists
if [ -f "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi

# define locales
export LANGUAGE="es:en"
export LC_MESSAGES="es_ES.UTF-8"
export LC_CTYPE="es_ES.UTF-8"
export LC_COLLATE="es_ES.UTF-8"

# linuxbrew
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] ; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
