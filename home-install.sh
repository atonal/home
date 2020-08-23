#!/bin/bash

set -e
set -u

DIR="$( readlink -f "$( dirname "${BASH_SOURCE[0]}" )" )"

echo "Initializing and updating git submodules"
git submodule update --init

echo "Installing urxvt extensions"
mkdir -p "$HOME/.urxvt/ext"
ln -s -f -v "$DIR/.urxvt/urxvt-font-size/font-size" "$HOME/.urxvt/ext/font-size"

echo
echo "All done."
