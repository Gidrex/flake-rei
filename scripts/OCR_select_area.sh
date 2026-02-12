#!/usr/bin/env bash

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
  tesseract - - -l "eng,rus" | wl-copy

# paru -S tesseract-data-best-eng tesseract-data-best-rus tesseract-data-eng tesseract-data-rus slurp wofi imagemagick grim

