#!/usr/bin/env bash

grim -g "$(slurp)" - | \
  magick - \
  -modulate 100,0 \
  -resize 300% \
  -density 300 \
  -units PixelsPerInch \
  -sharpen 0x1 \
  +repage \
  png:- | \
  tesseract - - -l rus+eng --psm 6 | wl-copy