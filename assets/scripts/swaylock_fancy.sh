#!/usr/bin/bash

trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
    rm "$image"
    }

image=$(mktemp --suffix=.png)

grim "$image"

magick "$image" -filter Gaussian \
    -resize 20% \
    -define "filter:sigma=2.0" \
    -resize 500.5% \
    -gravity center \
    "$image"

swaylock -i "$image" --hide-keyboard-layout
