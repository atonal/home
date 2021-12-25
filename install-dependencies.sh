#!/bin/bash

DIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")

#echo "Acquire::ForceIPv4 \"true\";" | sudo tee /etc/apt/apt.conf.d/99force-ipv4
install_packages=(
    arandr
    autocutsel
    cscope
    curl
    irssi
    keychain
    libasound2-dev
    libiw-dev
    libxml2-dev
    libxpm-dev
    rxvt-unicode-256color
    suckless-tools
    tig
    tree
    vim
    vim-gtk3
    xclip
    zsh
)

# xmonad
install_packages+=(
    c2hs
    cabal-install
    feh
    libghc-xmonad-contrib-dev
    libghc-xmonad-dev
    stalonetray
    xcompmgr
    xmonad
    xscreensaver
)

sudo apt-get install "${install_packages[@]}"

purge_packages=(
    gnome-screensaver
)

sudo apt-get purge "${purge_packages[@]}"

sudo cabal update
sudo cabal install --global xmobar --flags="all_extensions"

sudo cp "${DIR}"/xmonad.desktop /usr/share/xsessions/

gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.gnome.desktop.lockdown disable-lock-screen true
