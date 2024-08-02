#!/bin/bash
# This script need to setup all dotfiles

# Copy .____.
# cp -fr ./* ~/.config
# rm ~/.config/dotfiling.sh

# Recomended
CONFIG_DIR="$HOME/.config/"
exclude_list=("dotfiling.sh" "starship.toml")

cd "$HOME/flake-rei/config"

for file in *; do
    if [[ ! " ${exclude_list[@]} " =~ " ${file} " ]]; then
        ln -s "$(pwd)/$file" "$CONFIG_DIR/$file"
    fi
done
cp ./starship.toml "$CONFIG_DIR"

cd - > /dev/null
