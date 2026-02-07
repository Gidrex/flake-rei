#!/usr/bin/env bash

# Script to migrate Clash Verge rules from dotfiles to the actual profile

set -euo pipefail

# ANSI color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Paths
PROFILES_FILE="$HOME/.local/share/io.github.clash-verge-rev.clash-verge-rev/profiles.yaml"
PROFILES_DIR="$HOME/.local/share/io.github.clash-verge-rev.clash-verge-rev/profiles"
SOURCE_RULES="$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")/dotfiles/clash-verge-rev/rules.yaml"

# Validate files
if [[ ! -f "$SOURCE_RULES" ]]; then
    log_error "Source file not found: $SOURCE_RULES"
    exit 1
fi

if [[ ! -f "$PROFILES_FILE" ]]; then
    log_error "Profiles config not found: $PROFILES_FILE"
    exit 1
fi

# Find the UUID of the rules profile
rules_uid=$(grep -B 1 "type: rules" "$PROFILES_FILE" | grep "uid:" | sed 's/.*uid: //')

if [[ -z "$rules_uid" ]]; then
    log_error "Could not find rules profile UUID"
    exit 1
fi

target_file="$PROFILES_DIR/$rules_uid.yaml"

if [[ ! -f "$target_file" ]]; then
    log_error "Target profile not found: $target_file"
    exit 1
fi

# Check if files differ
if cmp -s "$SOURCE_RULES" "$target_file"; then
    log_success "Files identical, no migration needed"
    exit 0
fi

# Show diff and copy
echo "Changes to apply:"
diff -u "$target_file" "$SOURCE_RULES" || true
echo ""

log_step "Migrating rules..."
cp "$SOURCE_RULES" "$target_file" || {
    log_error "Copy failed"
    exit 1
}

# Verify
if cmp -s "$SOURCE_RULES" "$target_file"; then
    log_success "Migrated to: $target_file"
else
    log_error "Verification failed"
    exit 1
fi
