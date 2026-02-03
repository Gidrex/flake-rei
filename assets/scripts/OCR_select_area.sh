#!/usr/bin/env bash

LANG=$(echo -e "rus\neng" | wofi --width "80px" --prompt "Lang..." --height "200px" --style /home/gidrex/flake-rei/dotfiles/niri/wofi/style.css -S dmenu)

if [ -z "$LANG" ]; then
  exit 0
fi

grim -g "$(slurp)" - | \
  magick - \
  -alpha set -background white -alpha remove \
  -modulate 100,0 \
  -resize 300% \
  -density 300 \
  -bordercolor white -border 50x50 \
  -sharpen 0x1.5 \
  png:- | \
  tesseract - - -l "$LANG" | wl-copy
