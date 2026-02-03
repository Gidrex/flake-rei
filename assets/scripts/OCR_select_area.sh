#!/usr/bin/env bash

grim -g "$(slurp)" - | \
  magick - \
  -alpha set -background white -alpha remove \
  -modulate 100,0 \
  -resize 400% \
  -density 300 \
  -bordercolor white -border 50x50 \
  -sharpen 0x1.5 \
  png:- | \
  tesseract - - -l rus+eng --psm 7 | wl-copy
