#!/usr/bin/env bash
set -euo pipefail

# Rebuild script for flake configuration
# Format Nix files, backup, and rebuild

# Logging
success() {
    echo -e "\033[0;32m$1\033[0m"
}
warn() {
    echo -e "\033[0;33m$1\033[0m"
}
error() {
    echo -e "\033[0;31m$1\033[0m"
    exit 1
}

# Machine name
if [ -z "$FLAKE_MACHINE" ]; then
    error "Error: FLAKE_MACHINE environment variable not set.\nRun script with FLAKE_MACHINE=\"<machine-name>\""
fi

# Variables
FLAKE_DIR="$HOME/flake-sysconf"

# Create temporary log files
hm_log="/tmp/hm_rebuild.log"
backup_log="/tmp/backup.log"
format_log="/tmp/format.log"
: > "$hm_log"
: > "$backup_log" 
: > "$format_log"

# Format Nix files
format_nix_files() {
    case "$(command -v nixfmt >/dev/null 2>&1; echo $?)" in
        0)
            nixfmt "$FLAKE_DIR" >> "$format_log" 2>&1 && echo "[OK] Formatting completed" >> "$format_log"
            ;;
        1)
            echo "[WARN] nixfmt command not found" >> "$format_log"
            ;;
        *)
            echo "[ERROR] Error checking nixfmt command" >> "$format_log"
            ;;
    esac
}

# Backup changes to git
backup_changes() {
    commit_time=$(date '+%d.%m.%Y %H:%M:%S')
    current_branch=$(git -C "$FLAKE_DIR" symbolic-ref --short HEAD 2>/dev/null || echo 'main')
    
    cd "$FLAKE_DIR"
    echo "Pulling latest changes from $current_branch..." >> "$backup_log"
    git fetch origin "$current_branch" -q >> "$backup_log" 2>&1

    if [ -z "$(git status --porcelain)" ]; then
        echo "[WARN] No changes detected" >> "$backup_log"
    else
        {
            echo "Committing and pushing changes..."
            git add -A
            git commit -m "Automatic backup at $commit_time" --no-verify
            git push origin "$current_branch" -f
            echo "[OK] Successfully pushed changes"
        } >> "$backup_log" 2>&1
    fi
}

# Rebuild home-manager
rebuild_home_manager() {
    echo "Starting home-manager rebuild..." >> "$hm_log"
    if home-manager switch --flake "$FLAKE_DIR"/#"$FLAKE_MACHINE" --impure >> "$hm_log" 2>&1; then
        echo "[OK] Home-manager rebuild completed" >> "$hm_log"
    else
        echo "[ERROR] Home-manager rebuild failed" >> "$hm_log"
    fi
}

# Parallel execution
{
    # Step 1: Format in background
    gum spin --spinner dot --title "Formatting Nix files..." -- bash -c "
        FLAKE_DIR='$FLAKE_DIR'
        format_log='$format_log'
        $(declare -f format_nix_files)
        format_nix_files
    " &
    format_pid=$!

    # Step 2: Backup in background (if enabled)
    backup_pid=""
    if [ "${FLAKE_BACKUP:-1}" = "1" ]; then
        gum spin --spinner dot --title "Creating backup..." -- bash -c "
            FLAKE_DIR='$FLAKE_DIR'
            backup_log='$backup_log'
            $(declare -f backup_changes)
            backup_changes
        " &
        backup_pid=$!
    fi

    # Wait for format and backup to complete before home-manager
    wait $format_pid
    [ -n "$backup_pid" ] && wait "$backup_pid"

    # Step 3: Home-manager rebuild (depends on format/backup)
    gum spin --spinner dot --title "Rebuilding home-manager..." -- bash -c "
        FLAKE_DIR='$FLAKE_DIR'
        FLAKE_MACHINE='$FLAKE_MACHINE'
        hm_log='$hm_log'
        $(declare -f rebuild_home_manager)
        rebuild_home_manager
    "
}

# Build menu items list
menu_items=("Home-manager logs" "Nixfmt logs")
if [ "${FLAKE_BACKUP:-1}" = "1" ]; then
    menu_items=("Home-manager logs" "Git backup logs" "Nixfmt logs")
fi

# Generate menu
gum style --foreground 81 --border double --padding "1 2" --width 80 --align center --bold "FLAKE REBUILD COMPLETED"
menu="Select logs to view:\n\n"
for i in "${!menu_items[@]}"; do
    menu+="  $((i+1))) ${menu_items[i]}\n"
done
menu+="  ESC) Exit"

echo -e "$menu" | gum style --foreground 255 --border normal --padding "1 2" --width 40 --border-foreground 81

# Save terminal settings and disable echo
old_stty_config=$(stty -g)
stty -echo

while read -r -n 1 choice && [ "$choice" != $'\e' ] && [ -n "$choice" ]; do
    case "$choice" in
        [1-9])
            index=$((choice-1))
            [ "$index" -lt "${#menu_items[@]}" ] && case "${menu_items[index]}" in
                "Home-manager logs") less "$hm_log" ;;
                "Git backup logs") less "$backup_log" ;;
                "Nixfmt logs") less "$format_log" ;;
            esac
            ;;
    esac
done

# Restore terminal settings & cleanup
stty "$old_stty_config"
rm -f "$hm_log" "$backup_log" "$format_log"
