#!/bin/bash

set -e
set -u

DIR="$( readlink -f "$( dirname "${BASH_SOURCE[0]}" )" )"

install_packages=(
    cscope
    curl
    irssi
    rxvt-unicode-256color
    vim
    vim-gnome
)

sudo apt install -y "${install_packages[@]}"

echo "Initializing and updating git submodules"
git submodule update --init

echo "Installing urxvt extensions"
mkdir -p "$HOME/.urxvt/ext"
ln -s -f -v "$DIR/.urxvt/urxvt-font-size/font-size" "$HOME/.urxvt/ext/font-size"

echo
echo "All done."
