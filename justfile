# Justfile for flake-rei

# Default recipe - list all available commands
@default:
    just --list

# QA: Nix, Niri
@qa:
    ! command -v niri > /dev/null || niri validate
    ! command -v nixfmt > /dev/null || (command -v fd > /dev/null && fd -e nix -X nixfmt -c || find . -name "*.nix" -exec nixfmt -c {} +)

# Generate blurred versions of wallpapers in each directory
blur-wallpapers:
    #!/usr/bin/env bash
    command -v magick > /dev/null || (echo -e "\033[0;31mNo found magick\033[0m" && exit 0)
    for dir in assets/wallpapers/*/; do
        blur_dir="${dir}blur/"
        mkdir -p "$blur_dir"

        for img in "$dir"*.{jpg,jpeg,png,webp}; do
            [ -f "$img" ] || continue
            filename=$(basename "$img")

            if [ -f "$blur_dir$filename" ]; then
                ! diff -q "$img" "$blur_dir$filename" > /dev/null 2>&1 && continue
            fi

            echo "Creating blurred version of $filename"
            magick "$img" -blur 0x25 "$blur_dir$filename"
        done
    done