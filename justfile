# Justfile for flake-rei

# Default recipe - list all available commands
@default:
    just --list

# QA: Nix, Niri
@qa:
    ! command -v niri > /dev/null || niri validate
    ! command -v nixfmt > /dev/null || (command -v fd > /dev/null && fd -e nix -X nixfmt -c || find . -name "*.nix" -exec nixfmt -c {} +)

# Rebuild hm with change generation
hm:
    home-manager switch --flake ./#$FLAKE_MACHINE

# Generate blurred versions of wallpapers in each directory (parallel processing)
blur-wallpapers:
    #!/usr/bin/env bash
    command -v magick > /dev/null || (echo -e "\\033[0;31mNo found magick\\033[0m" && exit 0)
    nproc=$(nproc 2>/dev/null || echo 4)
    jobs=$((nproc > 1 ? nproc - 1 : 1))
    for dir in assets/wallpapers/*/; do
        blur_dir="${dir}blur/"
        mkdir -p "$blur_dir"
        find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 | \
        xargs -0 -P "$jobs" -I {} bash -c '
            img="$0"
            filename=$(basename "$img")
            blur_dir="$1"
            # Skip if blurred version exists and is newer than source
            if [ ! -f "$blur_dir$filename" ] || [ "$img" -nt "$blur_dir$filename" ]; then
                echo "Creating blurred version of $filename"
                magick "$img" -blur 0x25 "$blur_dir$filename"
            fi
        ' {} "$blur_dir"
    done

# Sync clash verge config
clash_verge_migration:
    ./assets/scripts/clash_verge_migration.sh